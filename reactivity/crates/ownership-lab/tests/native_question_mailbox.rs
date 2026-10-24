//! Native Arc reclamation and aliasing checks for the production mailbox.
//! Run this integration target normally or through cargo miri test.
//! Loom separately checks weak-memory publication with its tracked adapter.
mod sync {
    pub(super) use std::sync::{Arc, atomic};

    // Loom supplies this same interface with tracked cell-borrow lifetimes.
    pub(super) struct Cell<T>(std::cell::UnsafeCell<T>);
    impl<T> Cell<T> {
        pub(super) fn new(value: T) -> Self {
            Self(std::cell::UnsafeCell::new(value))
        }
        pub(super) fn with_mut<R>(&self, visit: impl FnOnce(*mut T) -> R) -> R {
            visit(self.0.get())
        }
        pub(super) fn into_inner(self) -> T {
            self.0.into_inner()
        }
    }
}

#[allow(dead_code, unsafe_code)]
#[path = "../../gpui/src/reader/linear_mailbox.rs"]
mod mailbox;

#[cfg(test)]
mod tests {
    use super::mailbox::{ABANDONED, Context, Owner, PANICKED, Producer};
    use std::{
        cell::Cell,
        panic::{AssertUnwindSafe, catch_unwind},
        sync::{
            Arc, Barrier, Mutex,
            atomic::{AtomicUsize, Ordering},
            mpsc,
        },
        thread,
    };

    struct Payload {
        value: Cell<u8>,
        drops: Arc<AtomicUsize>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            self.drops.fetch_add(1, Ordering::SeqCst);
        }
    }
    fn payload(value: u8, drops: &Arc<AtomicUsize>) -> Payload {
        Payload {
            value: Cell::new(value),
            drops: drops.clone(),
        }
    }

    #[derive(Default)]
    struct Events {
        published: Option<mpsc::SyncSender<()>>,
        resume: Option<Mutex<mpsc::Receiver<()>>>,
        calls: AtomicUsize,
        panic_notify: bool,
        panic_close: bool,
    }
    impl Context for Events {
        fn notify(&self) {
            if self.calls.fetch_add(1, Ordering::Relaxed) == 0 {
                if let Some(published) = &self.published {
                    published.send(()).unwrap();
                    self.resume
                        .as_ref()
                        .unwrap()
                        .lock()
                        .unwrap()
                        .recv()
                        .unwrap();
                }
            }
            assert!(!self.panic_notify, "notification");
        }
        fn close(&self) {
            assert!(!self.panic_close, "context cleanup");
        }
    }

    #[test]
    fn send_without_sync_reuses_before_the_old_notifier_returns() {
        let (published, ready) = mpsc::sync_channel(0);
        let (resume, wait) = mpsc::sync_channel(0);
        let mut owner = Owner::new(Events {
            published: Some(published),
            resume: Some(Mutex::new(wait)),
            ..Events::default()
        });
        let drops = Arc::new(AtomicUsize::new(0));
        let producer = owner.begin();
        let first = payload(11, &drops);
        let worker = thread::spawn(move || assert!(producer.complete(first).is_ok()));
        ready.recv().unwrap();
        assert_eq!(owner.freeze(), Some(2));
        let first = owner.take().unwrap();
        assert_eq!(first.value.get(), 11);
        drop(first);
        assert!(owner.take().is_none());
        owner.retire();
        assert!(owner.begin().complete(payload(22, &drops)).is_ok());
        let second = owner.take().unwrap();
        assert_eq!(second.value.get(), 22);
        drop(second);
        owner.retire();
        resume.send(()).unwrap();
        worker.join().unwrap();
        drop(owner.close());
        assert_eq!(drops.load(Ordering::SeqCst), 2);
    }

    #[test]
    fn actual_std_arc_extraction_races_the_last_producer_without_double_drop() {
        for _ in 0..8 {
            let mut owner = Owner::new(Events::default());
            let producer = owner.begin();
            let drops = Arc::new(AtomicUsize::new(0));
            let value = payload(7, &drops);
            let start = Arc::new(Barrier::new(2));
            let worker_start = start.clone();
            let worker = thread::spawn(move || {
                worker_start.wait();
                drop(producer.complete(value));
            });
            start.wait();
            drop(owner.close());
            assert!(owner.freeze().is_none());
            worker.join().unwrap();
            assert_eq!(drops.load(Ordering::SeqCst), 1);
        }
    }

    #[test]
    fn abandoned_panicked_and_zero_sized_generations_keep_one_credit() {
        let mut owner = Owner::<(), _>::new(Events::default());
        drop(owner.begin());
        assert_eq!(owner.freeze(), Some(ABANDONED));
        assert!(owner.take().is_none());
        owner.retire();
        owner.begin().panicked();
        assert_eq!(owner.freeze(), Some(PANICKED));
        owner.retire();
        for _ in 0..16 {
            assert_eq!(owner.begin().complete(()), Ok(()));
            assert_eq!(owner.freeze(), Some(2));
            assert_eq!(owner.take(), Some(()));
            assert!(owner.take().is_none());
            owner.retire();
        }
        assert!(owner.close().is_none());
        assert!(!owner.idle());
        assert_eq!(size_of::<Owner<u64, Events>>(), size_of::<usize>());
        assert_eq!(size_of::<Producer<u64, Events>>(), size_of::<usize>());
    }

    #[test]
    fn notification_panic_leaves_exactly_one_published_payload() {
        let mut owner = Owner::new(Events {
            panic_notify: true,
            ..Events::default()
        });
        let drops = Arc::new(AtomicUsize::new(0));
        let producer = owner.begin();
        let value = payload(3, &drops);
        assert!(
            catch_unwind(AssertUnwindSafe(|| {
                drop(producer.complete(value));
            }))
            .is_err()
        );
        assert_eq!(owner.freeze(), Some(2));
        drop(owner.take());
        assert!(owner.take().is_none());
        owner.retire();
        drop(owner.close());
        assert_eq!(drops.load(Ordering::SeqCst), 1);
    }

    #[test]
    fn owner_drop_revokes_a_delayed_producer_without_changing_its_value() {
        let mut owner = Owner::new(Events::default());
        let producer = owner.begin();
        drop(owner);
        let value = String::from("same owned allocation");
        let pointer = value.as_ptr();
        let returned = producer.complete(value).unwrap_err();
        assert_eq!(returned.as_ptr(), pointer);
    }

    #[test]
    fn close_panic_still_rejects_the_delayed_producer() {
        let mut owner = Owner::new(Events {
            panic_close: true,
            ..Events::default()
        });
        let producer = owner.begin();
        assert!(catch_unwind(AssertUnwindSafe(|| owner.close())).is_err());
        assert_eq!(producer.complete(7), Err(7));
        assert!(owner.close().is_none());
    }
}
