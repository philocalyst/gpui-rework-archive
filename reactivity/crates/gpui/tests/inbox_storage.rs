//! Public lifecycle adversaries for the single bounded payload buffer.
use gpui::{El, Remote, SendError, View, Win, div};
use std::sync::{
    Arc,
    atomic::{AtomicBool, Ordering},
    mpsc,
};
use std::time::Duration;

#[derive(Default)]
struct Page {
    values: Vec<(usize, usize)>,
    terminal: usize,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        div()
    }
}

#[test]
fn concurrent_clone_drop_and_prebind_fifo_end_with_one_terminal() {
    let (remote, inbox) = Remote::bounded(128);
    let (done, finished) = mpsc::channel();
    let mut workers = Vec::new();
    for producer in 0..8 {
        let remote = remote.clone();
        let done = done.clone();
        workers.push(std::thread::spawn(move || {
            for sequence in 0..16 {
                let copy = remote.clone();
                copy.try_send((producer, sequence)).unwrap();
                drop(copy);
            }
            drop(remote);
            done.send(()).unwrap();
        }));
    }
    drop(remote);
    drop(done);
    for _ in 0..8 {
        finished
            .recv_timeout(Duration::from_secs(3))
            .expect("producer completion");
    }
    for worker in workers {
        worker.join().unwrap();
    }
    let mut win = Win::demo(Page::default())
        .with_inbox_status(inbox, |page: &mut Page, value| match value {
            Some(value) => page.values.push(value),
            None => page.terminal += 1,
        })
        .unwrap();
    for _ in 0..128 {
        assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    }
    assert_eq!(win.root().unwrap().terminal, 0);
    assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    assert_eq!(win.deliver_ready(1).unwrap().applied, 0);
    let page = win.root().unwrap();
    assert_eq!(page.terminal, 1);
    for producer in 0..8 {
        assert_eq!(
            page.values
                .iter()
                .filter(|(id, _)| *id == producer)
                .map(|(_, sequence)| *sequence)
                .collect::<Vec<_>>(),
            (0..16).collect::<Vec<_>>()
        );
    }
}

#[test]
fn logical_capacity_bounds_zst_values_and_zero_capacity() {
    for capacity in [0, 1, 3] {
        let (remote, inbox) = Remote::bounded(capacity);
        for _ in 0..capacity {
            remote.try_send(()).unwrap();
        }
        assert!(matches!(remote.try_send(()), Err(SendError::Full(()))));
        let mut win = Win::demo(Page::default())
            .with_inbox(inbox, |_: &mut Page, _: ()| {})
            .unwrap();
        assert_eq!(win.deliver_ready(usize::MAX).unwrap().applied, capacity);
        if capacity != 0 {
            remote.try_send(()).unwrap();
        }
        win.close();
        assert!(matches!(remote.try_send(()), Err(SendError::Closed(()))));
    }
}

#[test]
fn receiver_drop_releases_the_lock_before_payload_destructors_reenter() {
    struct Payload {
        reenter: Option<Remote<Payload>>,
        observed: Arc<AtomicBool>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            if let Some(remote) = self.reenter.take() {
                let result = remote.try_send(Payload {
                    reenter: None,
                    observed: self.observed.clone(),
                });
                self.observed.store(
                    matches!(result, Err(SendError::Closed(_))),
                    Ordering::SeqCst,
                );
            }
        }
    }
    let (done, finished) = mpsc::channel();
    let observed = Arc::new(AtomicBool::new(false));
    let check = observed.clone();
    let worker = std::thread::spawn(move || {
        let (remote, inbox) = Remote::bounded(1);
        remote
            .try_send(Payload {
                reenter: Some(remote.clone()),
                observed,
            })
            .unwrap();
        drop(inbox);
        done.send(()).unwrap();
    });
    finished
        .recv_timeout(Duration::from_secs(3))
        .expect("payload reentry must not deadlock");
    worker.join().unwrap();
    assert!(check.load(Ordering::SeqCst));
}

#[test]
fn all_lane_producers_are_revoked_before_a_payload_drop_can_unwind() {
    struct Payload {
        other: Remote<()>,
        observed: Arc<AtomicBool>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            self.observed.store(
                matches!(self.other.try_send(()), Err(SendError::Closed(()))),
                Ordering::SeqCst,
            );
            panic!("retired payload fault");
        }
    }
    let (remote, inbox) = Remote::bounded(1);
    let (other, other_inbox) = Remote::bounded(1);
    let observed = Arc::new(AtomicBool::new(false));
    remote
        .try_send(Payload {
            other: other.clone(),
            observed: observed.clone(),
        })
        .unwrap();
    let mut win = Win::demo(Page::default())
        .with_inbox(other_inbox, |_: &mut Page, _: ()| {})
        .unwrap()
        .with_inbox(inbox, |_: &mut Page, _: Payload| {})
        .unwrap();
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| win.close())).is_err());
    assert!(observed.load(Ordering::SeqCst));
    assert!(matches!(other.try_send(()), Err(SendError::Closed(()))));
    // Repeated revocation contains no retained payload and completes normally.
    win.close();
}

#[test]
fn simultaneous_final_two_producers_publish_one_bound_terminal() {
    let (first, inbox) = Remote::<()>::bounded(1);
    let second = first.clone();
    let barrier = Arc::new(std::sync::Barrier::new(3));
    let (done, finished) = mpsc::channel();
    let mut workers = Vec::new();
    for remote in [first, second] {
        let barrier = barrier.clone();
        let done = done.clone();
        workers.push(std::thread::spawn(move || {
            barrier.wait();
            drop(remote);
            done.send(()).unwrap();
        }));
    }
    drop(done);
    let mut win = Win::demo(Page::default())
        .with_inbox_status(inbox, |page: &mut Page, value: Option<()>| {
            assert!(value.is_none());
            page.terminal += 1;
        })
        .unwrap();
    assert_eq!(win.deliver_ready(4).unwrap().applied, 0);
    barrier.wait();
    for _ in 0..2 {
        finished
            .recv_timeout(Duration::from_secs(3))
            .expect("last producer drop");
    }
    for worker in workers {
        worker.join().unwrap();
    }
    assert_eq!(win.deliver_ready(4).unwrap().applied, 1);
    assert_eq!(win.deliver_ready(4).unwrap().applied, 0);
    assert_eq!(win.root().unwrap().terminal, 1);
}

#[test]
fn abandoned_inbox_revokes_before_a_reentrant_panicking_payload_drop() {
    struct Payload {
        remote: Option<Remote<Payload>>,
        observed: Arc<AtomicBool>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            if let Some(remote) = self.remote.take() {
                let result = remote.try_send(Payload {
                    remote: None,
                    observed: self.observed.clone(),
                });
                self.observed.store(
                    matches!(result, Err(SendError::Closed(_))),
                    Ordering::SeqCst,
                );
                panic!("abandoned payload fault");
            }
        }
    }
    let (done, finished) = mpsc::channel();
    let observed = Arc::new(AtomicBool::new(false));
    let check = observed.clone();
    let worker = std::thread::spawn(move || {
        let (remote, inbox) = Remote::bounded(1);
        remote
            .try_send(Payload {
                remote: Some(remote.clone()),
                observed: observed.clone(),
            })
            .unwrap();
        assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| drop(inbox))).is_err());
        assert!(matches!(
            remote.try_send(Payload {
                remote: None,
                observed
            }),
            Err(SendError::Closed(_))
        ));
        done.send(()).unwrap();
    });
    finished
        .recv_timeout(Duration::from_secs(3))
        .expect("panicking payload must release queue lock");
    worker.join().unwrap();
    assert!(check.load(Ordering::SeqCst));
}

#[test]
fn shared_transport_does_not_require_payload_sync() {
    fn send_sync<T: Send + Sync>() {}
    send_sync::<Remote<mpsc::Receiver<u8>>>();
    send_sync::<gpui::Inbox<mpsc::Receiver<u8>>>();
}

#[test]
fn mixed_question_chain_is_cancelled_before_retired_inbox_payload_unwinds() {
    use gpui::{
        Completion, FieldId, Questions, Signal, Source, Sources, StartError, WindowOptions,
    };
    use std::convert::Infallible;
    struct Model(Signal<u32>);
    const VALUE: Source<Model, u32> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
    impl View for Model {
        fn sources() -> Sources<Self> {
            Sources::new().direct(VALUE)
        }
        fn view(&self) -> El<'_> {
            div()
        }
    }
    struct Payload {
        questions: [Completion<(), Infallible>; 2],
        other: Remote<()>,
        observed: Arc<AtomicBool>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            let cancelled = self.questions.iter().all(Completion::is_cancelled);
            let revoked = matches!(self.other.try_send(()), Err(SendError::Closed(())));
            self.observed.store(cancelled && revoked, Ordering::SeqCst);
            panic!("mixed retirement fault");
        }
    }
    let (jobs, ready) = mpsc::channel();
    let another = jobs.clone();
    let (questions, _) = Questions::new()
        .question(
            VALUE,
            |value| *value,
            move |_: u32, completion: Completion<(), Infallible>| {
                jobs.send(completion).map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let (questions, _) = questions
        .question(
            VALUE,
            |value| *value,
            move |_: u32, completion: Completion<(), Infallible>| {
                another.send(completion).map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let (remote, inbox) = Remote::bounded(1);
    let (other, other_inbox) = Remote::bounded(1);
    let mut win = Win::with_questions(Model(Signal::new(1)), questions, WindowOptions::default())
        .unwrap()
        .with_inbox(other_inbox, |_: &mut Model, _: ()| {})
        .unwrap()
        .with_inbox(inbox, |_: &mut Model, _: Payload| {})
        .unwrap();
    let first = ready
        .recv_timeout(Duration::from_secs(3))
        .expect("first question started");
    let second = ready
        .recv_timeout(Duration::from_secs(3))
        .expect("second question started");
    assert!(!first.is_cancelled() && !second.is_cancelled());
    let observed = Arc::new(AtomicBool::new(false));
    remote
        .try_send(Payload {
            questions: [first, second],
            other: other.clone(),
            observed: observed.clone(),
        })
        .unwrap();
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| win.close())).is_err());
    assert!(observed.load(Ordering::SeqCst));
    assert!(matches!(other.try_send(()), Err(SendError::Closed(()))));
    win.close();
}

#[test]
fn payload_drop_unwind_after_callback_fault_keeps_the_owner_quarantined() {
    use std::sync::atomic::AtomicUsize;
    struct Payload {
        id: usize,
        dropped: Arc<AtomicUsize>,
    }
    impl Drop for Payload {
        fn drop(&mut self) {
            let bit = 1 << self.id;
            assert_eq!(self.dropped.fetch_or(bit, Ordering::SeqCst) & bit, 0);
            if self.id == 1 {
                panic!("quarantined payload fault");
            }
        }
    }
    let dropped = Arc::new(AtomicUsize::new(0));
    let (remote, inbox) = Remote::bounded(3);
    let mut win = Win::demo(Page::default())
        .with_inbox(inbox, |_: &mut Page, value: Payload| {
            if value.id == 0 {
                panic!("callback fault before retired payload fault");
            }
        })
        .unwrap();
    for id in 0..3 {
        remote
            .try_send(Payload {
                id,
                dropped: dropped.clone(),
            })
            .unwrap();
    }
    assert!(
        std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let _ = win.deliver_ready(3);
        }))
        .is_err()
    );
    assert_eq!(dropped.load(Ordering::SeqCst), 7);
    assert!(win.snapshot().unwrap().poisoned);
    assert!(matches!(
        remote.try_send(Payload { id: 3, dropped }),
        Err(SendError::Closed(_))
    ));
    assert_eq!(
        win.deliver_ready(1).unwrap_err().error,
        gpui::Error::Poisoned
    );
    win.close();
}
