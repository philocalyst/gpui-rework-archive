//! A single physical response slot. The parent chooses std or Loom sync.
//! No payload destructor or notification runs while the mutex is held.
use super::sync::{
    Mutex, TryLockError,
    atomic::{AtomicBool, AtomicU8, Ordering},
};
pub(super) struct Mailbox<P> {
    state: AtomicU8,
    closed: AtomicBool,
    slot: Mutex<Option<P>>,
}
impl<P> Mailbox<P> {
    pub(super) fn new() -> Self {
        Self {
            state: AtomicU8::new(0),
            closed: AtomicBool::new(false),
            slot: Mutex::new(None),
        }
    }
    pub(super) fn begin(&self) {
        assert!(
            !self.closed.load(Ordering::Acquire),
            "closed response owner"
        );
        self.state.store(1, Ordering::Release);
    }
    pub(super) fn idle(&self) -> bool {
        self.state.load(Ordering::Acquire) == 0
    }
    pub(super) fn complete(&self, value: P, notify: impl FnOnce()) -> Result<(), P> {
        if self.closed.load(Ordering::Acquire) {
            return Err(value);
        }
        let mut slot = self
            .slot
            .lock()
            .unwrap_or_else(|poison| poison.into_inner());
        if self.closed.load(Ordering::Acquire) {
            drop(slot);
            return Err(value);
        }
        // Only the single linear completion can write this physical
        // lease. The owner cannot begin another until take+retire.
        assert!(slot.is_none(), "one response per physical lease");
        *slot = Some(value);
        drop(slot);
        self.finish(2, notify);
        Ok(())
    }
    pub(super) fn finish(&self, terminal: u8, notify: impl FnOnce()) {
        debug_assert!(terminal > 1);
        self.state.store(terminal, Ordering::Release);
        // After publication the cap never accesses this lease again.
        // Wake is after publication, including abandonment and panic.
        notify();
    }
    // Freeze readiness only. Terminal publication seals the response until the
    // owner takes it during apply; callbacks cannot create another physical cap.
    pub(super) fn freeze(&self) -> Option<u8> {
        if self.closed.load(Ordering::Acquire) {
            return None;
        }
        let terminal = self.state.load(Ordering::Acquire);
        if terminal <= 1 {
            return None;
        }
        Some(terminal)
    }
    pub(super) fn take(&self) -> Option<P> {
        // The owner previously acquired terminal during staging. No new cap
        // exists until retire, so intervening callbacks cannot change the slot.
        // Never wait even on an invariant violation.
        debug_assert!(self.state.load(Ordering::Relaxed) > 1);
        let mut slot = match self.slot.try_lock() {
            Ok(slot) => slot,
            Err(TryLockError::Poisoned(poison)) => poison.into_inner(),
            Err(TryLockError::WouldBlock) => panic!("terminal published before producer unlock"),
        };
        let value = slot.take();
        drop(slot);
        value
    }
    pub(super) fn retire(&self) {
        self.state.store(0, Ordering::Release);
    }
    pub(super) fn close(&self) {
        // Owner drops its Arc lease. A descheduled physical cap keeps the
        // response alive; the final Arc drops Mutex<Option<P>> with unique
        // ownership, without locking or touching a concurrent writer.
        self.closed.store(true, Ordering::Release);
    }
    #[cfg(test)]
    pub(super) fn unlocked(&self) -> bool {
        self.slot.try_lock().is_ok()
    }
    #[cfg(test)]
    #[allow(
        dead_code,
        reason = "Only the same-source Loom harness pauses a producer inside the mutex."
    )]
    pub(super) fn hold_for_test(&self, paused: impl FnOnce()) {
        let _slot = self
            .slot
            .lock()
            .unwrap_or_else(|poison| poison.into_inner());
        paused();
    }
}
