//! Decoder-facing plans, not a shared queue or a read-question side effect.
//! A real decoder installs an owned Plan and returns its opaque EOS stamp.
//! Audio decoding/device output are outside this queue contract.
use crate::queue::{Entry, EntryKey, Navigation, Queue, QueueError, Repeat, Track, TrackRef};
use std::{
    num::NonZeroU64,
    sync::atomic::{AtomicU64, Ordering},
};

static NEXT_SESSION: AtomicU64 = AtomicU64::new(0);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PlanStamp {
    session: NonZeroU64,
    serial: NonZeroU64,
    entry: EntryKey,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct EndOfStream(PlanStamp);

#[derive(Clone, Debug)]
pub struct Plan {
    stamp: PlanStamp,
    pub current: Entry,
    pub lookahead: Option<Entry>,
}
impl Plan {
    pub fn stamp(&self) -> PlanStamp {
        self.stamp
    }
    pub fn end_of_stream(&self) -> EndOfStream {
        EndOfStream(self.stamp)
    }
}

/// Exclusive application controller. It is deliberately non-Clone; restoration
/// creates a new session. The relaxed counter supplies identity only: a service
/// channel/wake, not this counter, publishes a Plan to another thread.
pub struct PlaybackQueue {
    queue: Queue,
    session: NonZeroU64,
    serial: u64,
    plan: Option<Plan>,
}
impl PlaybackQueue {
    pub fn new() -> Result<Self, QueueError> {
        let previous = NEXT_SESSION
            .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |value| {
                value.checked_add(1)
            })
            .map_err(|_| QueueError::SessionExhausted)?;
        Ok(Self {
            queue: Queue::default(),
            session: NonZeroU64::new(previous + 1)
                .expect("the checked session counter starts above zero"),
            serial: 0,
            plan: None,
        })
    }
    pub fn queue(&self) -> &Queue {
        &self.queue
    }
    pub fn plan(&self) -> Option<&Plan> {
        self.plan.as_ref()
    }
    fn next_serial(&self) -> Result<NonZeroU64, QueueError> {
        self.serial
            .checked_add(1)
            .and_then(NonZeroU64::new)
            .ok_or(QueueError::PlanExhausted)
    }
    fn install(&mut self, serial: NonZeroU64, available: &impl Fn(&Track) -> bool) {
        self.serial = serial.get();
        self.plan = self.queue.current().map(|key| {
            let current = self
                .queue
                .entry(key)
                .expect("the controller retains a live current key")
                .clone();
            let lookahead = self
                .queue
                .lookahead(available)
                .map(|key| self.queue.entry(key).unwrap().clone());
            Plan {
                stamp: PlanStamp {
                    session: self.session,
                    serial,
                    entry: key,
                },
                current,
                lookahead,
            }
        });
    }
    fn refresh(&mut self, serial: NonZeroU64, available: &impl Fn(&Track) -> bool) {
        if self.plan.is_some() {
            self.install(serial, available);
        } else {
            // Even a stopped edit invalidates an older in-flight occurrence.
            self.serial = serial.get();
        }
    }
    fn navigate(
        &mut self,
        navigation: Navigation,
        serial: NonZeroU64,
        available: &impl Fn(&Track) -> bool,
    ) {
        match navigation {
            Navigation::Changed(_) | Navigation::Repeat(_) => self.install(serial, available),
            Navigation::End => {
                self.serial = serial.get();
                self.plan = None;
            }
        }
    }
    /// Explicit play/restart is an occurrence even for the same entry.
    pub fn play(
        &mut self,
        key: EntryKey,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<bool, QueueError> {
        let serial = self.next_serial()?;
        match self.queue.jump(key, available)? {
            Navigation::Changed(_) => {
                self.install(serial, available);
                Ok(true)
            }
            Navigation::End => Ok(false),
            Navigation::Repeat(_) => {
                unreachable!("jump returns only a changed target or unavailable")
            }
        }
    }
    pub fn next(
        &mut self,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        let navigation = self.queue.next(true, available, draw);
        self.navigate(navigation, serial, available);
        Ok(())
    }
    pub fn previous(
        &mut self,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        let navigation = self.queue.previous(available, draw);
        // At the start, Previous does nothing rather than stopping the plan.
        if navigation != Navigation::End {
            self.navigate(navigation, serial, available);
        }
        Ok(())
    }
    /// Duplicate/late EOS is inert, including after replacement of the whole
    /// controller. RepeatOne creates a new occurrence before accepting EOS again.
    pub fn end_of_stream(
        &mut self,
        event: EndOfStream,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<bool, QueueError> {
        if self.plan.as_ref().map(|plan| plan.stamp) != Some(event.0) {
            return Ok(false);
        }
        let serial = self.next_serial()?;
        let navigation = self.queue.next(false, available, draw);
        self.navigate(navigation, serial, available);
        Ok(true)
    }
    pub fn stop(&mut self) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        self.serial = serial.get();
        self.plan = None;
        Ok(())
    }
    pub fn append(
        &mut self,
        tracks: Vec<TrackRef>,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<Option<EntryKey>, QueueError> {
        let serial = self.next_serial()?;
        let start = self.queue.len();
        let first = self.queue.append(tracks, draw)?;
        if first.is_some() {
            if self.plan.is_none()
                && let Some(key) = self.queue.available_from(start, available)
            {
                self.queue.jump(key, available)?;
                self.install(serial, available);
            } else {
                self.refresh(serial, available);
            }
        }
        Ok(first)
    }
    pub fn insert(
        &mut self,
        index: usize,
        tracks: Vec<TrackRef>,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<Option<EntryKey>, QueueError> {
        let serial = self.next_serial()?;
        let start = index.min(self.queue.len());
        let count = tracks.len();
        let first = self.queue.insert(index, tracks)?;
        if first.is_some() {
            let playable = (start..start + count)
                .filter_map(|index| self.queue.at(index))
                .find(|entry| available(&entry.track))
                .map(|entry| entry.key);
            if self.plan.is_none()
                && let Some(key) = playable
            {
                self.queue.jump(key, available)?;
                self.install(serial, available);
            } else {
                self.refresh(serial, available);
            }
        }
        Ok(first)
    }
    pub fn remove(
        &mut self,
        keys: &[EntryKey],
        available: &impl Fn(&Track) -> bool,
    ) -> Result<bool, QueueError> {
        let serial = self.next_serial()?;
        let Some(removal) = self.queue.remove_with_position(keys) else {
            return Ok(false);
        };
        if self.plan.is_some() && self.queue.current().is_none() {
            if let Some(key) = removal
                .next_index
                .and_then(|index| self.queue.available_from(index, available))
            {
                self.queue.jump(key, available)?;
            }
        }
        self.refresh(serial, available);
        Ok(true)
    }
    pub fn move_entries(
        &mut self,
        keys: &[EntryKey],
        destination: usize,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<bool, QueueError> {
        let serial = self.next_serial()?;
        let changed = self.queue.move_entries(keys, destination);
        if changed {
            self.refresh(serial, available);
        }
        Ok(changed)
    }
    pub fn replace(
        &mut self,
        tracks: Vec<TrackRef>,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        self.queue.replace(tracks, draw)?;
        if let Some(key) = self.queue.first_available(available) {
            self.queue.jump(key, available)?;
        }
        self.install(serial, available);
        Ok(())
    }
    pub fn clear(
        &mut self,
        keep_current: bool,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        self.queue.clear(keep_current && self.plan.is_some());
        self.refresh(serial, available);
        Ok(())
    }
    pub fn undo(&mut self, available: &impl Fn(&Track) -> bool) -> Result<bool, QueueError> {
        let serial = self.next_serial()?;
        let changed = self.queue.undo();
        if changed {
            self.refresh(serial, available);
        }
        Ok(changed)
    }
    pub fn toggle_shuffle(
        &mut self,
        available: &impl Fn(&Track) -> bool,
        draw: &mut impl FnMut(usize) -> usize,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        self.queue.toggle_shuffle(draw);
        self.refresh(serial, available);
        Ok(())
    }
    pub fn set_repeat(
        &mut self,
        repeat: Repeat,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<bool, QueueError> {
        let serial = self.next_serial()?;
        let changed = self.queue.set_repeat(repeat);
        if changed {
            self.refresh(serial, available);
        }
        Ok(changed)
    }
    /// Call after accepted availability changes even if the current key stays
    /// equal: the resolved lookahead and EOS policy belong to a new plan.
    pub fn availability_changed(
        &mut self,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        self.refresh(serial, available);
        Ok(())
    }
}
