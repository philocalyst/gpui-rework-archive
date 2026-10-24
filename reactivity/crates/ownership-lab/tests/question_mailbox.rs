#![cfg(feature = "loom")]
//! The exact production role mailbox with Loom-tracked cell borrows.
//! Models use only the safe Owner/Producer interface. Native Miri separately
//! checks real std Arc::into_inner; the Loom adapter below models cell safety,
//! not the destructor-thread guarantee of that unavailable Loom operation.
#[allow(dead_code)]
mod sync {
    use std::ops::Deref;

    pub(super) use loom::sync::atomic;

    pub(super) struct Arc<T>(loom::sync::Arc<T>);
    impl<T> Arc<T> {
        pub(super) fn new(value: T) -> Self {
            Self(loom::sync::Arc::new(value))
        }

        pub(super) fn into_inner(this: Self) -> Option<T> {
            loom::sync::Arc::try_unwrap(this.0).ok()
        }
    }
    impl<T> Clone for Arc<T> {
        fn clone(&self) -> Self {
            Self(self.0.clone())
        }
    }
    impl<T> Deref for Arc<T> {
        type Target = T;
        fn deref(&self) -> &T {
            &self.0
        }
    }

    pub(super) struct Cell<T>(loom::cell::UnsafeCell<T>);
    impl<T> Cell<T> {
        pub(super) fn new(value: T) -> Self {
            Self(loom::cell::UnsafeCell::new(value))
        }

        pub(super) fn with_mut<R>(&self, visit: impl FnOnce(*mut T) -> R) -> R {
            self.0.with_mut(visit)
        }

        pub(super) fn into_inner(self) -> T {
            self.0.into_inner()
        }
    }
}

#[path = "../../gpui/src/reader/linear_mailbox.rs"]
mod linear_mailbox;
use linear_mailbox::{ABANDONED, Context, Owner, PANICKED, Producer, Shared};
use sync::Arc;
const READY: u8 = 2;
#[cfg(test)]
mod tests {
    use super::*;
    use loom::{
        sync::{
            Arc as LoomArc,
            atomic::{AtomicBool, AtomicU64, AtomicUsize, Ordering},
        },
        thread,
    };
    use std::{cell::Cell as LocalCell, panic::AssertUnwindSafe};

    struct NotifyGate {
        entered: AtomicBool,
        release: AtomicBool,
    }

    struct TestContext {
        current: AtomicU64,
        notifications: AtomicUsize,
        panic_notify: bool,
        gate: Option<LoomArc<NotifyGate>>,
    }

    impl TestContext {
        fn new() -> Self {
            Self {
                current: AtomicU64::new(0),
                notifications: AtomicUsize::new(0),
                panic_notify: false,
                gate: None,
            }
        }
    }

    impl Context for TestContext {
        fn notify(&self) {
            self.notifications.fetch_add(1, Ordering::Relaxed);
            if self.panic_notify {
                panic!("notification panic after publication");
            }
            if let Some(gate) = &self.gate {
                if !gate.entered.swap(true, Ordering::AcqRel) {
                    while !gate.release.load(Ordering::Acquire) {
                        thread::yield_now();
                    }
                }
            }
        }

        fn close(&self) {
            self.current.store(0, Ordering::Release);
        }
    }

    #[test]
    fn producer_publishes_before_owner_poll_without_any_wake_or_join() {
        loom::model(|| {
            let mut owner = Owner::<usize, TestContext>::new(TestContext::new());
            let producer = owner.begin();
            let worker = thread::spawn(move || producer.complete(41).unwrap());

            let result = loop {
                if owner.freeze() == Some(READY) {
                    break owner.take().unwrap();
                }
                thread::yield_now();
            };
            assert_eq!(result, 41);
            owner.retire();
            worker.join().unwrap();
        });
    }

    #[test]
    fn exclusive_owner_api_rejects_invalid_phase_calls() {
        loom::model(|| {
            let mut owner = Owner::<usize, TestContext>::new(TestContext::new());
            let _producer = owner.begin();
            let second_begin = std::panic::catch_unwind(AssertUnwindSafe(|| owner.begin()));
            assert!(second_begin.is_err());
            let premature_retire = std::panic::catch_unwind(AssertUnwindSafe(|| owner.retire()));
            assert!(premature_retire.is_err());
        });
    }

    #[test]
    fn one_producer_transfers_a_send_but_not_sync_payload() {
        loom::model(|| {
            let mut owner = Owner::<LocalCell<usize>, TestContext>::new(TestContext::new());
            let producer = owner.begin();
            let worker = thread::spawn(move || producer.complete(LocalCell::new(17)).unwrap());
            let value = loop {
                if owner.freeze() == Some(READY) {
                    break owner.take().unwrap();
                }
                thread::yield_now();
            };
            assert_eq!(value.get(), 17);
            owner.retire();
            worker.join().unwrap();
        });
    }

    #[test]
    fn notify_panic_cannot_undo_ready_or_reopen_the_slot() {
        loom::model(|| {
            let mut context = TestContext::new();
            context.panic_notify = true;
            let mut owner = Owner::<usize, TestContext>::new(context);
            let producer = owner.begin();
            let result = std::panic::catch_unwind(AssertUnwindSafe(|| producer.complete(7)));
            assert!(result.is_err());
            assert_eq!(owner.freeze(), Some(READY));
            assert_eq!(owner.take(), Some(7));
            owner.retire();
        });
    }

    #[test]
    fn closing_admission_precedes_panicking_context_cleanup() {
        struct PanicClose;
        impl Context for PanicClose {
            fn notify(&self) {}
            fn close(&self) {
                panic!("context cleanup");
            }
        }

        loom::model(|| {
            let mut owner = Owner::new(PanicClose);
            let producer = owner.begin();
            assert!(std::panic::catch_unwind(AssertUnwindSafe(|| owner.close())).is_err());
            let value = String::from("exact rejected allocation");
            let pointer = value.as_ptr();
            let returned = producer.complete(value).unwrap_err();
            assert_eq!(returned.as_ptr(), pointer);
            assert!(owner.close().is_none());
        });
    }

    #[test]
    fn old_notifier_can_outlive_take_retire_and_reuse() {
        loom::model(|| {
            let gate = LoomArc::new(NotifyGate {
                entered: AtomicBool::new(false),
                release: AtomicBool::new(false),
            });
            let mut context = TestContext::new();
            context.gate = Some(gate.clone());
            let mut owner = Owner::<usize, TestContext>::new(context);
            let old = owner.begin();
            let old_worker = thread::spawn(move || old.complete(1).unwrap());
            while !gate.entered.load(Ordering::Acquire) {
                thread::yield_now();
            }

            assert_eq!(owner.freeze(), Some(READY));
            assert_eq!(owner.take(), Some(1));
            owner.retire();
            owner.begin().complete(2).unwrap();
            assert_eq!(owner.freeze(), Some(READY));
            assert_eq!(owner.take(), Some(2));
            owner.retire();
            gate.release.store(true, Ordering::Release);
            old_worker.join().unwrap();
        });
    }

    #[test]
    fn panic_and_abandonment_publish_empty_terminal_states() {
        loom::model(|| {
            let mut owner = Owner::<usize, TestContext>::new(TestContext::new());
            owner.begin().panicked();
            assert_eq!(owner.freeze(), Some(PANICKED));
            assert_eq!(owner.take(), None);
            owner.retire();

            drop(owner.begin());
            assert_eq!(owner.freeze(), Some(ABANDONED));
            assert_eq!(owner.take(), None);
            owner.retire();
        });
    }

    #[test]
    fn close_rejects_late_completion_and_preserves_original_payload() {
        loom::model(|| {
            let mut owner = Owner::<Box<usize>, TestContext>::new(TestContext::new());
            let producer = owner.begin();
            assert!(owner.close().is_none());
            let value = Box::new(19);
            let pointer = value.as_ref() as *const usize;
            let returned = producer.complete(value).unwrap_err();
            assert_eq!(returned.as_ref() as *const usize, pointer);
        });
    }

    #[test]
    fn close_racing_write_reclaims_payload_exactly_once() {
        loom::model(|| {
            struct DropCount(LoomArc<AtomicUsize>);
            impl Drop for DropCount {
                fn drop(&mut self) {
                    self.0.fetch_add(1, Ordering::SeqCst);
                }
            }

            let drops = LoomArc::new(AtomicUsize::new(0));
            let mut owner = Owner::<DropCount, TestContext>::new(TestContext::new());
            let producer = owner.begin();
            let worker_drops = drops.clone();
            let worker = thread::spawn(move || {
                let value = DropCount(worker_drops);
                producer.complete(value)
            });
            let retired = owner.close();
            drop(worker.join().unwrap().err());
            drop(retired);
            assert_eq!(drops.load(Ordering::SeqCst), 1);
        });
    }

    #[test]
    fn owner_and_producer_are_one_optional_arc_each() {
        assert_eq!(
            std::mem::size_of::<Owner<usize, TestContext>>(),
            std::mem::size_of::<Option<Arc<Shared<usize, TestContext>>>>()
        );
        assert_eq!(
            std::mem::size_of::<Producer<usize, TestContext>>(),
            std::mem::size_of::<Option<Arc<Shared<usize, TestContext>>>>()
        );
    }
}

#[cfg(test)]
mod owner_handoff_tests {
    use super::*;
    use loom::thread;

    struct HandoffContext;
    impl Context for HandoffContext {
        fn notify(&self) {}
        fn close(&self) {}
    }

    // In the typed API, the next Producer cannot exist until the owner has
    // taken and retired the prior generation. If it crosses threads, the safe
    // executor handoff publishes that prior owner access. This models that
    // role order, unlike the raw pre-issued-writer mutant test.
    #[test]
    fn owner_created_next_producer_is_handed_off_after_take() {
        loom::model(|| {
            let mut owner = Owner::<usize, HandoffContext>::new(HandoffContext);
            owner.begin().complete(10).unwrap();
            assert_eq!(owner.freeze(), Some(READY));
            assert_eq!(owner.take(), Some(10));
            owner.retire();

            let next = owner.begin();
            let worker = thread::spawn(move || next.complete(20).unwrap());
            let value = loop {
                if owner.freeze() == Some(READY) {
                    break owner.take().unwrap();
                }
                thread::yield_now();
            };
            assert_eq!(value, 20);
            owner.retire();
            worker.join().unwrap();
        });
    }
}
