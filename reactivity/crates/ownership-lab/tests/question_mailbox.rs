#![cfg(feature = "loom")]
//! The exact GPUI safe mailbox implementation, with Loom synchronization.
mod sync {
    pub use loom::sync::{Mutex, atomic};
    pub use std::sync::TryLockError;
}
#[path = "../../gpui/src/reader/linear_mailbox.rs"]
mod mailbox;
use gpui_reactivity_ownership_lab::Ready;
use loom::{
    sync::{
        Arc,
        atomic::{AtomicBool, AtomicUsize, Ordering},
        mpsc,
    },
    thread,
};
use mailbox::Mailbox;

#[test]
fn a_single_wake_after_terminal_cannot_strand_a_published_response() {
    loom::model(|| {
        let slot = Arc::new(Mailbox::new());
        slot.begin();
        let gate = Arc::new(Ready::default());
        let events = Arc::new(AtomicUsize::new(0));
        let consumed = Arc::new(AtomicBool::new(false));
        let worker = {
            let (slot, gate, events) = (slot.clone(), gate.clone(), events.clone());
            thread::spawn(move || {
                slot.complete(7, || {
                    if gate.publish() {
                        events.fetch_add(1, Ordering::Release);
                    }
                })
                .unwrap();
            })
        };
        let owner = {
            let (slot, gate, events, consumed) =
                (slot.clone(), gate.clone(), events.clone(), consumed.clone());
            thread::spawn(move || {
                if events.load(Ordering::Acquire) > 0 {
                    events.fetch_sub(1, Ordering::Relaxed);
                    gate.acknowledge_before_drain();
                    if let Some((terminal, value)) = slot.freeze() {
                        assert_eq!((terminal, value), (2, Some(7)));
                        slot.retire();
                        consumed.store(true, Ordering::Release);
                    }
                }
            })
        };
        worker.join().unwrap();
        owner.join().unwrap();
        assert!(consumed.load(Ordering::Acquire) || events.load(Ordering::Acquire) > 0);
        if !consumed.load(Ordering::Acquire) {
            assert_eq!(slot.freeze(), Some((2, Some(7))));
            slot.retire();
        }
        assert!(slot.idle());
        slot.close();
    });
}

struct Payload {
    drops: Arc<AtomicUsize>,
}
impl Drop for Payload {
    fn drop(&mut self) {
        self.drops.fetch_add(1, Ordering::SeqCst);
    }
}
#[test]
fn close_racing_publication_releases_exactly_one_owned_payload() {
    loom::model(|| {
        let slot = Arc::new(Mailbox::new());
        slot.begin();
        let drops = Arc::new(AtomicUsize::new(0));
        let worker = {
            let (slot, drops) = (slot.clone(), drops.clone());
            thread::spawn(move || {
                drop(slot.complete(Payload { drops }, || {}));
            })
        };
        let owner = {
            let slot = slot.clone();
            thread::spawn(move || slot.close())
        };
        worker.join().unwrap();
        owner.join().unwrap();
        drop(slot);
        assert_eq!(drops.load(Ordering::SeqCst), 1);
    });
}

#[test]
fn a_late_old_notification_cannot_overwrite_a_reused_physical_lease() {
    loom::model(|| {
        let slot = Arc::new(Mailbox::new());
        slot.begin();
        let (sent, ready) = mpsc::channel();
        let (resume, wait) = mpsc::channel();
        let worker = {
            let slot = slot.clone();
            thread::spawn(move || {
                slot.complete(11, || {
                    sent.send(()).unwrap();
                    wait.recv().unwrap();
                })
                .unwrap();
            })
        };
        ready.recv().unwrap();
        assert_eq!(slot.freeze(), Some((2, Some(11))));
        slot.retire();
        slot.begin();
        slot.complete(22, || {}).unwrap();
        resume.send(()).unwrap();
        worker.join().unwrap();
        assert_eq!(slot.freeze(), Some((2, Some(22))));
        slot.retire();
        slot.close();
    });
}

#[test]
fn abandonment_releases_credit_without_a_payload_and_stays_bounded() {
    loom::model(|| {
        let slot = Arc::new(Mailbox::<u64>::new());
        slot.begin();
        let worker = {
            let slot = slot.clone();
            thread::spawn(move || slot.finish(3, || {}))
        };
        worker.join().unwrap();
        assert_eq!(slot.freeze(), Some((3, None)));
        slot.retire();
        assert!(slot.idle());
        slot.begin();
        slot.complete(9, || {}).unwrap();
        assert_eq!(slot.freeze(), Some((2, Some(9))));
        slot.close();
    });
}

#[test]
fn notification_and_payload_drop_run_outside_the_mutex() {
    loom::model(|| {
        struct Probe {
            slot: Arc<Mailbox<Probe>>,
            drops: Arc<AtomicUsize>,
        }
        impl Drop for Probe {
            fn drop(&mut self) {
                assert!(self.slot.unlocked());
                self.drops.fetch_add(1, Ordering::SeqCst);
            }
        }
        let slot = Arc::new(Mailbox::new());
        slot.begin();
        let drops = Arc::new(AtomicUsize::new(0));
        let probe = Probe {
            slot: slot.clone(),
            drops: drops.clone(),
        };
        assert!(slot.complete(probe, || assert!(slot.unlocked())).is_ok());
        let (_, value) = slot.freeze().unwrap();
        slot.retire();
        drop(value);
        slot.close();
        assert_eq!(drops.load(Ordering::SeqCst), 1);
    });
}

#[test]
fn close_never_waits_for_a_descheduled_producer_holding_the_response_mutex() {
    loom::model(|| {
        let slot = Arc::new(Mailbox::new());
        slot.begin();
        let (locked, ready) = mpsc::channel();
        let (resume, wait) = mpsc::channel();
        let worker = {
            let slot = slot.clone();
            thread::spawn(move || {
                slot.hold_for_test(|| {
                    locked.send(()).unwrap();
                    wait.recv().unwrap();
                });
                assert_eq!(slot.complete(42, || {}), Err(42));
            })
        };
        ready.recv().unwrap();
        // If close attempted to lock, Loom would detect this wait cycle:
        // close waits for the worker, worker waits for resume after close.
        slot.close();
        assert_eq!(slot.freeze(), None);
        resume.send(()).unwrap();
        drop(slot);
        worker.join().unwrap();
    });
}

#[test]
fn a_worker_lease_defers_reclamation_after_close_but_cannot_admit_it() {
    loom::model(|| {
        let slot = Arc::new(Mailbox::new());
        slot.begin();
        let drops = Arc::new(AtomicUsize::new(0));
        let worker_lease = slot.clone();
        assert!(
            worker_lease
                .complete(
                    Payload {
                        drops: drops.clone()
                    },
                    || {}
                )
                .is_ok()
        );
        slot.close();
        assert!(slot.freeze().is_none());
        drop(slot);
        assert_eq!(drops.load(Ordering::SeqCst), 0);
        drop(worker_lease);
        assert_eq!(drops.load(Ordering::SeqCst), 1);
    });
}
