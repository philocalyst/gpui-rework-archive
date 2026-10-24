//! One inline response, transferred by the existing terminal publication.
//! The unique Completion writes; the exclusive window owner takes. Closing
//! only revokes admission. The last Arc reclaims the payload without locking.
use super::sync::{
    Cell,
    atomic::{AtomicBool, AtomicU8, Ordering},
};

const IDLE: u8 = 0;
const PENDING: u8 = 1;
const READY: u8 = 2;
const TAKEN: u8 = 4;
const WRITING: u8 = 6;

pub(super) struct Mailbox<P> {
    state: AtomicU8,
    closed: AtomicBool,
    slot: Cell<Option<P>>,
}
// SAFETY: The linear Completion is the only writer in a pending generation.
// READY Release follows the end of its cell borrow; the owner's successful
// Acquire claim precedes its sole take. Retire/begin require that same exclusive
// owner and cannot overlap its take. After publishing, an old Completion can
// notify or release its Arc, but never accesses this slot again. Close touches
// only an atomic; final payload destruction has unique ownership of the Arc.
// P crosses threads by ownership, so Send is required; no shared P is exposed.
unsafe impl<P: Send> Sync for Mailbox<P> {}

impl<P> Mailbox<P> {
    pub(super) fn new() -> Self {
        Self {
            state: AtomicU8::new(IDLE),
            closed: AtomicBool::new(false),
            slot: Cell::new(None),
        }
    }
    pub(super) fn begin(&self) {
        assert!(
            !self.closed.load(Ordering::Acquire),
            "closed response owner"
        );
        assert_eq!(self.state.load(Ordering::Acquire), IDLE, "retired response");
        self.state.store(PENDING, Ordering::Release);
    }
    pub(super) fn idle(&self) -> bool {
        self.state.load(Ordering::Acquire) == IDLE
    }
    pub(super) fn complete(&self, value: P, notify: impl FnOnce()) -> Result<(), P> {
        if self.closed.load(Ordering::Acquire) {
            return Err(value);
        }
        self.state
            .compare_exchange(PENDING, WRITING, Ordering::Acquire, Ordering::Acquire)
            .expect("one response per physical lease");
        if self.closed.load(Ordering::Acquire) {
            return Err(value);
        }
        self.slot.with_mut(|slot| {
            // SAFETY: This generation's sole writer claimed WRITING. The owner
            // cannot take before READY, and final reclamation needs our Arc.
            let slot = unsafe { &mut *slot };
            assert!(slot.is_none(), "empty response before publication");
            *slot = Some(value);
        });
        self.finish(READY, notify);
        Ok(())
    }
    pub(super) fn finish(&self, terminal: u8, notify: impl FnOnce()) {
        assert!(matches!(terminal, READY | 3 | 5), "response terminal");
        self.state.store(terminal, Ordering::Release);
        // Old notification may outlive take, retire and the next generation;
        // no slot access follows publication, including if notify panics.
        notify();
    }
    pub(super) fn freeze(&self) -> Option<u8> {
        if self.closed.load(Ordering::Acquire) {
            return None;
        }
        let state = self.state.load(Ordering::Acquire);
        matches!(state, READY | 3 | 5).then_some(state)
    }
    pub(super) fn take(&self) -> Option<P> {
        // Terminal-without-payload and repeated takes never enter the cell.
        if self
            .state
            .compare_exchange(READY, TAKEN, Ordering::Acquire, Ordering::Acquire)
            .is_err()
        {
            return None;
        }
        self.slot.with_mut(|slot| {
            // SAFETY: Acquire observes the ended producer borrow. TAKEN allows
            // one take; the exclusive owner retires only after this ends.
            unsafe { (&mut *slot).take() }
        })
    }
    pub(super) fn retire(&self) {
        self.state.store(IDLE, Ordering::Release);
    }
    pub(super) fn close(&self) {
        self.closed.store(true, Ordering::Release);
    }
    pub(super) fn into_payload(self) -> Option<P> {
        self.slot.into_inner()
    }
    #[cfg(test)]
    pub(super) fn unlocked(&self) -> bool {
        // The tracked-cell harness rejects a callback inside the slot borrow.
        self.slot.with_mut(|_| true)
    }
    #[cfg(test)]
    #[allow(dead_code, reason = "Only Loom pauses an active cell borrower.")]
    pub(super) fn hold_for_test(&self, paused: impl FnOnce()) {
        self.slot.with_mut(|_| paused());
    }
}
