//! Exclusive queue state. Track data may cross a service boundary; the mutable
//! queue, order and history never do. Availability is supplied by the caller,
//! so rendering and pure queue operations perform no filesystem I/O.
use std::{collections::VecDeque, num::NonZeroU64, path::PathBuf};
use triomphe::Arc;

pub const UNDO_LIMIT: usize = 30;
pub const LARGE_CHANGE: usize = 4096;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct EntryKey(NonZeroU64);
impl EntryKey {
    pub fn get(self) -> u64 {
        self.0.get()
    }
}

#[derive(Debug, PartialEq, Eq)]
pub struct Track {
    pub path: PathBuf,
    pub track_id: Option<i64>,
    pub album_id: Option<i64>,
    pub title: String,
    /// Worker-observed snapshot, not proof that a future decoder open succeeds.
    pub available_when_prepared: bool,
}
pub type TrackRef = Arc<Track>;

#[derive(Clone, Debug)]
pub struct Entry {
    pub key: EntryKey,
    pub track: TrackRef,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Repeat {
    #[default]
    Off,
    All,
    One,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum QueueError {
    KeyExhausted,
    StaleEntry,
    SessionExhausted,
    PlanExhausted,
    Unavailable,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Navigation {
    Changed(EntryKey),
    Repeat(EntryKey),
    End,
}
pub(crate) struct Removal {
    pub next_index: Option<usize>,
}

#[derive(Default)]
struct Sheet {
    // Monotonic keys keep this sorted independently of either permutation.
    entries: Vec<Entry>,
    order: Vec<EntryKey>,
    original: Vec<EntryKey>,
}
impl Sheet {
    fn entry(&self, key: EntryKey) -> Option<&Entry> {
        self.entries
            .binary_search_by_key(&key, |entry| entry.key)
            .ok()
            .map(|index| &self.entries[index])
    }
    fn index(&self, key: EntryKey) -> Option<usize> {
        self.order.iter().position(|candidate| *candidate == key)
    }
}

#[derive(Clone, Copy)]
struct Before {
    current: Option<EntryKey>,
    shuffled: bool,
}
enum Undo {
    Inserted {
        keys: Vec<EntryKey>,
        before: Before,
    },
    Removed {
        entries: Vec<(usize, Entry)>,
        original: Vec<(usize, EntryKey)>,
        before: Before,
    },
    Moved {
        positions: Vec<(usize, EntryKey)>,
        before: Before,
    },
    Shuffled {
        before: Before,
    },
    Unshuffled {
        order: Vec<EntryKey>,
        before: Before,
    },
    Replaced {
        sheet: Sheet,
        before: Before,
    },
}
impl Undo {
    fn items(&self) -> usize {
        match self {
            Self::Inserted { keys, .. } => keys.len(),
            Self::Removed { entries, .. } => entries.len(),
            Self::Moved { positions, .. } => positions.len(),
            Self::Shuffled { .. } => 0,
            Self::Unshuffled { order, .. } => order.len(),
            Self::Replaced { sheet, .. } => sheet.order.len(),
        }
    }
    fn large(&self) -> bool {
        self.items() > LARGE_CHANGE
    }
}

#[derive(Default)]
pub struct Queue {
    sheet: Sheet,
    current: Option<EntryKey>,
    shuffled: bool,
    repeat: Repeat,
    always_repeat: bool,
    next_key: u64,
    undo: VecDeque<Undo>,
}
impl Queue {
    pub fn len(&self) -> usize {
        self.sheet.order.len()
    }
    pub fn is_empty(&self) -> bool {
        self.sheet.order.is_empty()
    }
    pub fn at(&self, index: usize) -> Option<&Entry> {
        self.sheet.entry(*self.sheet.order.get(index)?)
    }
    pub fn entry(&self, key: EntryKey) -> Option<&Entry> {
        self.sheet.entry(key)
    }
    pub fn key(&self, value: u64) -> Option<EntryKey> {
        self.sheet
            .entries
            .binary_search_by_key(&value, |entry| entry.key.get())
            .ok()
            .map(|index| self.sheet.entries[index].key)
    }
    pub fn index_of(&self, key: EntryKey) -> Option<usize> {
        self.sheet.index(key)
    }
    pub fn current(&self) -> Option<EntryKey> {
        self.current
    }
    pub fn current_position(&self) -> Option<usize> {
        self.current.and_then(|key| self.sheet.index(key))
    }
    pub fn shuffled(&self) -> bool {
        self.shuffled
    }
    pub fn repeat(&self) -> Repeat {
        self.repeat
    }
    pub fn history_len(&self) -> usize {
        self.undo.len()
    }
    pub fn set_repeat(&mut self, repeat: Repeat) -> bool {
        let repeat = if repeat == Repeat::Off && self.always_repeat {
            Repeat::All
        } else {
            repeat
        };
        let changed = self.repeat != repeat;
        self.repeat = repeat;
        changed
    }
    pub fn set_always_repeat(&mut self, enabled: bool) -> bool {
        let changed = self.always_repeat != enabled;
        self.always_repeat = enabled;
        if enabled && self.repeat == Repeat::Off {
            self.repeat = Repeat::All;
        }
        changed
    }
    pub fn same_album(&self) -> bool {
        let Some(album) = self.at(0).and_then(|entry| entry.track.album_id) else {
            return false;
        };
        self.sheet
            .entries
            .iter()
            .all(|entry| entry.track.album_id == Some(album))
    }
    fn before(&self) -> Before {
        Before {
            current: self.current,
            shuffled: self.shuffled,
        }
    }
    fn remember(&mut self, action: Undo) {
        if action.large()
            && let Some(index) = self.undo.iter().rposition(Undo::large)
        {
            self.undo.drain(..=index);
        }
        if self.undo.len() == UNDO_LIMIT {
            self.undo.pop_front();
        }
        self.undo.push_back(action);
    }
    fn allocate(&mut self, tracks: Vec<TrackRef>) -> Result<Vec<EntryKey>, QueueError> {
        let count = u64::try_from(tracks.len()).map_err(|_| QueueError::KeyExhausted)?;
        let end = self
            .next_key
            .checked_add(count)
            .ok_or(QueueError::KeyExhausted)?;
        let mut keys = Vec::with_capacity(tracks.len());
        for (index, track) in tracks.into_iter().enumerate() {
            let key = EntryKey(
                NonZeroU64::new(self.next_key + index as u64 + 1)
                    .expect("the checked key range starts above zero"),
            );
            self.sheet.entries.push(Entry { key, track });
            keys.push(key);
        }
        self.next_key = end;
        Ok(keys)
    }
    /// Inserts before this playback-order position, clamped to the end.
    /// While shuffled, inserted tracks append to the original permutation.
    pub fn insert(
        &mut self,
        position: usize,
        tracks: Vec<TrackRef>,
    ) -> Result<Option<EntryKey>, QueueError> {
        if tracks.is_empty() {
            return Ok(None);
        }
        let before = self.before();
        let keys = self.allocate(tracks)?;
        let first = keys[0];
        let position = position.min(self.len());
        self.sheet
            .order
            .splice(position..position, keys.iter().copied());
        if self.shuffled {
            self.sheet.original.extend_from_slice(&keys);
        }
        self.remember(Undo::Inserted { keys, before });
        Ok(Some(first))
    }
    /// Batch append shuffles only the added suffix, as in the original player.
    /// The draw callback supplies an index below its positive argument; modulo
    /// also keeps malformed callback output from violating permutation safety.
    pub fn append(
        &mut self,
        tracks: Vec<TrackRef>,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<Option<EntryKey>, QueueError> {
        let start = self.len();
        let first = self.insert(start, tracks)?;
        if self.shuffled {
            shuffle(&mut self.sheet.order[start..], draw);
        }
        Ok(first)
    }
    pub fn replace(
        &mut self,
        tracks: Vec<TrackRef>,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<(), QueueError> {
        // Check exhaustion before moving the old authoritative sheet.
        self.next_key
            .checked_add(u64::try_from(tracks.len()).map_err(|_| QueueError::KeyExhausted)?)
            .ok_or(QueueError::KeyExhausted)?;
        let before = self.before();
        let sheet = std::mem::take(&mut self.sheet);
        self.sheet.order = self.allocate(tracks)?;
        if self.shuffled {
            self.sheet.original.clone_from(&self.sheet.order);
            shuffle(&mut self.sheet.order, draw);
        }
        self.current = None;
        self.remember(Undo::Replaced { sheet, before });
        Ok(())
    }
    pub fn clear(&mut self, keep_current: bool) {
        let before = self.before();
        let retained = keep_current
            .then(|| self.current.and_then(|key| self.entry(key).cloned()))
            .flatten();
        let sheet = std::mem::take(&mut self.sheet);
        if let Some(entry) = retained {
            self.current = Some(entry.key);
            self.sheet.order.push(entry.key);
            if self.shuffled {
                self.sheet.original.push(entry.key);
            }
            self.sheet.entries.push(entry);
        } else {
            self.current = None;
        }
        self.remember(Undo::Replaced { sheet, before });
    }
    /// Remove explicit live entries. Duplicates/stale keys are ignored; removing
    /// a selected row with no current track never starts playback.
    pub fn remove(&mut self, keys: &[EntryKey]) -> bool {
        self.remove_with_position(keys).is_some()
    }
    pub(crate) fn remove_with_position(&mut self, keys: &[EntryKey]) -> Option<Removal> {
        let mut keys = keys.to_vec();
        keys.sort_unstable();
        keys.dedup();
        keys.retain(|key| self.entry(*key).is_some());
        if keys.is_empty() {
            return None;
        }
        let before = self.before();
        let current = self.current_position();
        let mut removed_before = 0;
        let mut original = Vec::new();
        for (index, key) in self.sheet.original.iter().copied().enumerate() {
            if keys.binary_search(&key).is_ok() {
                original.push((index, key));
            }
        }
        self.sheet
            .original
            .retain(|key| keys.binary_search(key).is_err());
        let mut positions = Vec::with_capacity(keys.len());
        for (index, key) in self.sheet.order.iter().copied().enumerate() {
            if keys.binary_search(&key).is_ok() {
                positions.push((key, index));
                if current.is_some_and(|current| index < current) {
                    removed_before += 1;
                }
            }
        }
        positions.sort_unstable_by_key(|(key, _)| *key);
        let mut entries: Vec<_> = self
            .sheet
            .entries
            .extract_if(.., |entry| keys.binary_search(&entry.key).is_ok())
            .map(|entry| {
                let position = positions
                    .binary_search_by_key(&entry.key, |(key, _)| *key)
                    .expect("every removed entry has a playback-order position");
                (positions[position].1, entry)
            })
            .collect();
        entries.sort_unstable_by_key(|(index, _)| *index);
        self.sheet
            .order
            .retain(|key| keys.binary_search(key).is_err());
        if self
            .current
            .is_some_and(|key| keys.binary_search(&key).is_ok())
        {
            self.current = None;
        }
        self.remember(Undo::Removed {
            entries,
            original,
            before,
        });
        Some(Removal {
            next_index: current.map(|index| index - removed_before),
        })
    }
    /// Destination is a position in the order AFTER removal. Source order is
    /// retained regardless of the caller's selection ordering.
    pub fn move_entries(&mut self, keys: &[EntryKey], destination: usize) -> bool {
        let mut keys = keys.to_vec();
        keys.sort_unstable();
        keys.dedup();
        let positions: Vec<_> = self
            .sheet
            .order
            .iter()
            .copied()
            .enumerate()
            .filter(|(_, key)| keys.binary_search(key).is_ok())
            .collect();
        if positions.is_empty() {
            return false;
        }
        let destination = destination.min(self.len() - positions.len());
        if positions
            .iter()
            .enumerate()
            .all(|(offset, (index, _))| *index == destination + offset)
        {
            return false;
        }
        let before = self.before();
        self.sheet
            .order
            .retain(|key| keys.binary_search(key).is_err());
        self.sheet.order.splice(
            destination..destination,
            positions.iter().map(|(_, key)| *key),
        );
        self.remember(Undo::Moved { positions, before });
        true
    }
    pub fn toggle_shuffle(&mut self, draw: &mut impl FnMut(usize) -> usize) {
        let before = self.before();
        self.shuffled = !self.shuffled;
        if self.shuffled {
            self.sheet.original.clone_from(&self.sheet.order);
            let start = self.current_position().map_or(0, |index| index + 1);
            shuffle(&mut self.sheet.order[start..], draw);
            self.remember(Undo::Shuffled { before });
        } else {
            let order = std::mem::replace(
                &mut self.sheet.order,
                std::mem::take(&mut self.sheet.original),
            );
            self.remember(Undo::Unshuffled { order, before });
        }
    }
    pub fn undo(&mut self) -> bool {
        let Some(action) = self.undo.pop_back() else {
            return false;
        };
        let before = match action {
            Undo::Inserted { keys, before } => {
                // Keys are allocated monotonically, hence sorted already.
                self.sheet
                    .order
                    .retain(|key| keys.binary_search(key).is_err());
                self.sheet
                    .original
                    .retain(|key| keys.binary_search(key).is_err());
                self.sheet
                    .entries
                    .retain(|entry| keys.binary_search(&entry.key).is_err());
                before
            }
            Undo::Removed {
                entries,
                original,
                before,
            } => {
                for (index, entry) in entries {
                    self.sheet.order.insert(index, entry.key);
                    let position = self
                        .sheet
                        .entries
                        .binary_search_by_key(&entry.key, |entry| entry.key)
                        .unwrap_err();
                    self.sheet.entries.insert(position, entry);
                }
                for (index, key) in original {
                    self.sheet.original.insert(index, key);
                }
                before
            }
            Undo::Moved { positions, before } => {
                let mut keys: Vec<_> = positions.iter().map(|(_, key)| *key).collect();
                keys.sort_unstable();
                self.sheet
                    .order
                    .retain(|key| keys.binary_search(key).is_err());
                for (index, key) in positions {
                    self.sheet.order.insert(index, key);
                }
                before
            }
            Undo::Shuffled { before } => {
                self.sheet.order = std::mem::take(&mut self.sheet.original);
                before
            }
            Undo::Unshuffled { order, before } => {
                self.sheet.original = std::mem::replace(&mut self.sheet.order, order);
                before
            }
            Undo::Replaced { sheet, before } => {
                self.sheet = sheet;
                before
            }
        };
        self.current = before.current;
        self.shuffled = before.shuffled;
        true
    }
    pub fn jump(
        &mut self,
        key: EntryKey,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<Navigation, QueueError> {
        let entry = self.entry(key).ok_or(QueueError::StaleEntry)?;
        if !available(&entry.track) {
            return Ok(Navigation::End);
        }
        self.current = Some(key);
        Ok(Navigation::Changed(key))
    }
    pub fn original_key(&self, index: usize) -> Option<EntryKey> {
        if self.shuffled {
            self.sheet.original.get(index).copied()
        } else {
            self.sheet.order.get(index).copied()
        }
    }
    pub fn first_available(&self, available: &impl Fn(&Track) -> bool) -> Option<EntryKey> {
        self.available_from(0, available)
    }
    pub fn available_from(
        &self,
        index: usize,
        available: &impl Fn(&Track) -> bool,
    ) -> Option<EntryKey> {
        self.sheet
            .order
            .get(index..)?
            .iter()
            .copied()
            .find(|key| available(&self.entry(*key).unwrap().track))
    }
    /// A resolved automatic successor. A shuffled wrap is chosen at navigation,
    /// so it has no speculative lookahead before that permutation is committed.
    pub fn lookahead(&self, available: &impl Fn(&Track) -> bool) -> Option<EntryKey> {
        if self.repeat == Repeat::One {
            return self
                .current
                .filter(|key| available(&self.entry(*key).unwrap().track));
        }
        let next = self.available_from(
            self.current_position().map_or(0, |index| index + 1),
            available,
        );
        next.or_else(|| {
            (self.repeat == Repeat::All && !self.shuffled)
                .then(|| self.first_available(available))
                .flatten()
        })
    }
    pub fn next(
        &mut self,
        manual: bool,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Navigation {
        if self.repeat == Repeat::One
            && !manual
            && let Some(key) = self.current
            && available(&self.entry(key).unwrap().track)
        {
            return Navigation::Repeat(key);
        }
        let start = self.current_position().map_or(0, |index| index + 1);
        let next = self.sheet.order[start..]
            .iter()
            .copied()
            .find(|key| available(&self.entry(*key).unwrap().track));
        let next = next.or_else(|| {
            if self.repeat != Repeat::All {
                return None;
            }
            if self.shuffled {
                shuffle(&mut self.sheet.order, draw);
            }
            self.first_available(available)
        });
        self.admit_navigation(next)
    }
    pub fn previous(
        &mut self,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Navigation {
        let end = self.current_position().unwrap_or(0);
        let previous = self.sheet.order[..end]
            .iter()
            .rev()
            .copied()
            .find(|key| available(&self.entry(*key).unwrap().track));
        let previous = previous.or_else(|| {
            if self.repeat != Repeat::All {
                return None;
            }
            if self.shuffled {
                shuffle(&mut self.sheet.order, draw);
            }
            self.sheet
                .order
                .iter()
                .rev()
                .copied()
                .find(|key| available(&self.entry(*key).unwrap().track))
        });
        self.admit_navigation(previous)
    }
    fn admit_navigation(&mut self, key: Option<EntryKey>) -> Navigation {
        if let Some(key) = key {
            self.current = Some(key);
            Navigation::Changed(key)
        } else {
            Navigation::End
        }
    }
}

fn shuffle(keys: &mut [EntryKey], draw: &mut impl FnMut(usize) -> usize) {
    for index in (1..keys.len()).rev() {
        let other = draw(index + 1) % (index + 1);
        keys.swap(index, other);
    }
}
