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
    // Neither counter wraps or reuses an accepted occurrence. The entry key
    // already lives in Plan and is unnecessary for EOS authority.
    session: NonZeroU64,
    serial: NonZeroU64,
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
    /// Names the current playback occurrence, not a revision of its lookahead.
    /// A changed stamp requests opening/restarting the current entry. Queue or
    /// policy edits that keep it playing preserve the stamp, including an EOS
    /// already in transit. EOS resolves the successor from the current queue.
    /// Equal stamps do not imply equal lookahead: reconcile it on each delivery.
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
                },
                current,
                lookahead,
            }
        });
    }
    fn refresh(&mut self, serial: NonZeroU64, available: &impl Fn(&Track) -> bool) {
        if let Some(plan) = self.plan.as_mut() {
            if self.queue.current() == Some(plan.current.key) {
                let next = self.queue.lookahead(available);
                if plan.lookahead.as_ref().map(|entry| entry.key) != next {
                    plan.lookahead = next.map(|key| self.queue.entry(key).unwrap().clone());
                }
            } else {
                self.install(serial, available);
            }
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
    /// Duplicate/retired EOS is inert, including after controller replacement.
    /// A lookahead edit cannot retire the still-playing occurrence. RepeatOne
    /// creates a fresh occurrence before accepting another EOS.
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
    /// Revocation requires no fresh stamp and remains available at exhaustion.
    pub fn stop(&mut self) {
        self.plan = None;
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
        if self.plan.is_some()
            && self.queue.current().is_none()
            && let Some(key) = removal
                .next_index
                .and_then(|index| self.queue.available_from(index, available))
        {
            self.queue.jump(key, available)?;
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
    /// Refresh availability without restarting an unchanged current occurrence.
    /// A queued EOS resolves navigation using the latest availability snapshot.
    pub fn availability_changed(
        &mut self,
        available: &impl Fn(&Track) -> bool,
    ) -> Result<(), QueueError> {
        let serial = self.next_serial()?;
        self.refresh(serial, available);
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn exhausted_plan_sequence_rejects_mutation_but_stop_still_revokes_eos() {
        let track = TrackRef::new(Track {
            path: "/prepared.flac".into(),
            track_id: None,
            album_id: None,
            title: String::new(),
            available_when_prepared: true,
        });
        let mut player = PlaybackQueue::new().unwrap();
        player
            .append(vec![track.clone()], &|_| true, &mut |_| 0)
            .unwrap();
        let key = player.queue.at(0).unwrap().key;
        let event = player.plan().unwrap().end_of_stream();
        player.serial = u64::MAX;
        assert_eq!(player.play(key, &|_| true), Err(QueueError::PlanExhausted));
        assert_eq!(
            player.remove(&[key], &|_| true),
            Err(QueueError::PlanExhausted)
        );
        assert_eq!(
            player.replace(vec![track], &|_| true, &mut |_| 0),
            Err(QueueError::PlanExhausted)
        );
        assert_eq!(player.queue.len(), 1);
        assert_eq!(player.plan().unwrap().end_of_stream(), event);
        player.stop();
        assert!(player.plan().is_none());
        assert!(!player.end_of_stream(event, &|_| true, &mut |_| 0).unwrap());
    }
}
