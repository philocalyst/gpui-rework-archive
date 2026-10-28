//! One inline response. Exclusive owner methods govern reuse; a consuming
//! producer ends its cell borrow before publishing and notifying the owner.
use super::sync::{
    Arc, Cell,
    atomic::{AtomicBool, AtomicU8, Ordering},
};
use std::panic::AssertUnwindSafe;

const IDLE: u8 = 0;
const PENDING: u8 = 1;
const READY: u8 = 2;
const TAKEN: u8 = 4;
pub(super) const ABANDONED: u8 = 3;
pub(super) const PANICKED: u8 = 5;

pub(super) trait Context {
    fn notify(&self);
    fn close(&self);
}

pub(super) struct Shared<P, C: Context> {
    state: AtomicU8,
    closed: AtomicBool,
    // No payload borrow crosses a user callback or destructor. Publication and
    // close finish their state transition before notifying or cleaning context.
    // Keep the mutex predecessor's unwind traits without constraining P.
    slot: AssertUnwindSafe<Cell<Option<P>>>,
    context: C,
}
// SAFETY: Only the exclusive Owner can begin, take and retire a generation.
// Its sole Producer acquires PENDING before writing, then ends its cell borrow
// before publishing READY with Release. Owner acquires READY before taking;
// the next PENDING Release/Acquire publishes the end of that take to reuse.
// No producer accesses the cell after publication. Close only sets an atomic;
// the last Arc uniquely owns reclamation. Context is independently Sync and
// payloads cross threads by ownership, so they require Send rather than Sync.
unsafe impl<P: Send, C: Context + Sync> Sync for Shared<P, C> {}

pub(super) struct Owner<P, C: Context> {
    shared: Option<Arc<Shared<P, C>>>,
}
pub(super) struct Producer<P, C: Context> {
    shared: Option<Arc<Shared<P, C>>>,
}

impl<P, C: Context> Owner<P, C> {
    pub(super) fn new(context: C) -> Self {
        Self {
            shared: Some(Arc::new(Shared {
                state: AtomicU8::new(IDLE),
                closed: AtomicBool::new(false),
                slot: AssertUnwindSafe(Cell::new(None)),
                context,
            })),
        }
    }
    pub(super) fn context(&self) -> &C {
        &self.shared.as_ref().expect("live response owner").context
    }
    pub(super) fn idle(&self) -> bool {
        self.shared
            .as_ref()
            .is_some_and(|shared| shared.state.load(Ordering::Relaxed) == IDLE)
    }
    pub(super) fn begin(&mut self) -> Producer<P, C> {
        let shared = self.shared.as_ref().expect("live response owner");
        assert_eq!(
            shared.state.load(Ordering::Relaxed),
            IDLE,
            "retired response"
        );
        shared.state.store(PENDING, Ordering::Release);
        Producer {
            shared: Some(shared.clone()),
        }
    }
    pub(super) fn freeze(&mut self) -> Option<u8> {
        let state = self.shared.as_ref()?.state.load(Ordering::Acquire);
        matches!(state, READY | ABANDONED | PANICKED).then_some(state)
    }
    pub(super) fn take(&mut self) -> Option<P> {
        let shared = self.shared.as_ref()?;
        if shared.state.load(Ordering::Acquire) != READY {
            return None;
        }
        let value = shared.slot.with_mut(|slot| {
            // SAFETY: This exclusive owner acquired the producer's ended cell
            // borrow. It cannot begin another generation during its own take.
            unsafe { (&mut *slot).take() }
        });
        assert!(value.is_some(), "published response");
        shared.state.store(TAKEN, Ordering::Relaxed);
        value
    }
    pub(super) fn retire(&mut self) {
        let shared = self.shared.as_ref().expect("live response owner");
        assert!(
            matches!(
                shared.state.load(Ordering::Acquire),
                TAKEN | ABANDONED | PANICKED
            ),
            "consumed response before reuse"
        );
        shared.state.store(IDLE, Ordering::Relaxed);
    }
    pub(super) fn close(&mut self) -> Option<P> {
        let shared = self.shared.take()?;
        shared.closed.store(true, Ordering::Release);
        shared.context.close();
        // Atomically release this lease or reclaim the allocation uniquely.
        // A producer can never race a unique slot extraction.
        Arc::into_inner(shared).and_then(|shared| shared.slot.0.into_inner())
    }
    #[cfg(test)]
    pub(super) fn shared_for_test(&self) -> &Arc<Shared<P, C>> {
        self.shared.as_ref().expect("live response owner")
    }
}
impl<P, C: Context> Drop for Owner<P, C> {
    fn drop(&mut self) {
        drop(self.close());
    }
}

impl<P, C: Context> Producer<P, C> {
    pub(super) fn context(&self) -> &C {
        &self
            .shared
            .as_ref()
            .expect("linear response producer")
            .context
    }
    pub(super) fn complete(mut self, value: P) -> Result<(), P> {
        let shared = self.shared.take().expect("linear response producer");
        if shared.closed.load(Ordering::Acquire) {
            return Err(value);
        }
        assert_eq!(
            shared.state.load(Ordering::Acquire),
            PENDING,
            "active response"
        );
        shared.slot.with_mut(|slot| {
            // SAFETY: This generation's unique consuming Producer acquired
            // PENDING. Its owner cannot take before the following publication.
            let slot = unsafe { &mut *slot };
            assert!(slot.is_none(), "empty response before publication");
            *slot = Some(value);
        });
        shared.state.store(READY, Ordering::Release);
        shared.context.notify();
        Ok(())
    }
    pub(super) fn panicked(mut self) {
        self.finish(PANICKED);
    }
    fn finish(&mut self, terminal: u8) {
        if let Some(shared) = self.shared.take() {
            assert_eq!(
                shared.state.load(Ordering::Acquire),
                PENDING,
                "active response"
            );
            shared.state.store(terminal, Ordering::Release);
            shared.context.notify();
        }
    }
}
impl<P, C: Context> Drop for Producer<P, C> {
    fn drop(&mut self) {
        self.finish(ABANDONED);
    }
}
#[cfg(test)]
impl<P, C: Context> Shared<P, C> {
    pub(super) fn unlocked_for_test(&self) -> bool {
        self.slot.with_mut(|_| true)
    }
}
