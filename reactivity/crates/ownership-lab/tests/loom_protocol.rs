#![cfg(feature = "loom")]
use gpui_reactivity_ownership_lab::Ready;
use loom::{
    sync::{
        Arc,
        atomic::{AtomicBool, AtomicUsize, Ordering},
    },
    thread,
};

// Abstract SPSC payload slots are atomic only to avoid introducing unsafe test
// code. Relaxed payload writes/reads rely on the modeled tail/head Release/Acquire
// protocol. This models publication/wakeup, NOT rtrb's unsafe slot implementation.
#[derive(Clone, Copy)]
enum Protocol {
    Correct,
    ReleaseOnlyAck,
    NoReleaseCoalescing,
    ClearAfter,
}
struct ModelQueue {
    mode: Protocol,
    bad_ready: AtomicBool,
    head: AtomicUsize,
    tail: AtomicUsize,
    payload: [AtomicUsize; 2],
    ready: Ready,
    events: AtomicUsize,
    capacity: usize,
}
impl ModelQueue {
    fn new(capacity: usize, mode: Protocol) -> Self {
        Self {
            mode,
            bad_ready: AtomicBool::new(false),
            head: AtomicUsize::new(0),
            tail: AtomicUsize::new(0),
            payload: [AtomicUsize::new(0), AtomicUsize::new(0)],
            ready: Ready::default(),
            events: AtomicUsize::new(0),
            capacity,
        }
    }
    fn push(&self, value: usize) -> Result<(), usize> {
        let tail = self.tail.load(Ordering::Relaxed);
        if tail - self.head.load(Ordering::Acquire) == self.capacity {
            return Err(value);
        }
        self.payload[tail % self.capacity].store(value, Ordering::Relaxed);
        self.tail.store(tail + 1, Ordering::Release);
        if self.publish_hint() {
            self.events.fetch_add(1, Ordering::Relaxed);
        }
        Ok(())
    }
    fn pop(&self) -> Option<usize> {
        let head = self.head.load(Ordering::Relaxed);
        if head == self.tail.load(Ordering::Acquire) {
            return None;
        }
        let value = self.payload[head % self.capacity].load(Ordering::Relaxed);
        self.head.store(head + 1, Ordering::Release);
        Some(value)
    }
    fn has_work(&self) -> bool {
        self.tail.load(Ordering::Acquire) > self.head.load(Ordering::Relaxed)
    }
    fn publish_hint(&self) -> bool {
        match self.mode {
            Protocol::Correct | Protocol::ClearAfter => self.ready.publish(),
            Protocol::ReleaseOnlyAck => !self.bad_ready.swap(true, Ordering::AcqRel),
            // Failed CAS has no Release; coalesced publication is missing from
            // the chain acquired by the consumer's exchange acknowledgement.
            Protocol::NoReleaseCoalescing => self
                .bad_ready
                .compare_exchange(false, true, Ordering::AcqRel, Ordering::Acquire)
                .is_ok(),
        }
    }
    fn ack(&self) {
        match self.mode {
            Protocol::Correct | Protocol::ClearAfter => self.ready.acknowledge_before_drain(),
            Protocol::ReleaseOnlyAck => self.bad_ready.store(false, Ordering::Release),
            Protocol::NoReleaseCoalescing => {
                self.bad_ready.swap(false, Ordering::AcqRel);
            }
        }
    }
    fn callback(&self) {
        if self.events.load(Ordering::Relaxed) == 0 {
            return;
        }
        self.events.fetch_sub(1, Ordering::Relaxed);
        if !matches!(self.mode, Protocol::ClearAfter) {
            self.ack();
        }
        // The chosen explicit per-callback budget is exactly one message.
        if let Some(value) = self.pop() {
            assert_eq!(
                value, 1,
                "release/acquire must publish initialized FIFO payload"
            );
        }
        if matches!(self.mode, Protocol::ClearAfter) {
            self.ack();
        } else {
            let work = self.has_work();
            let wake = if matches!(self.mode, Protocol::Correct) {
                self.ready.finish_bounded_drain(work)
            } else {
                work && self.publish_hint()
            };
            if wake {
                self.events.fetch_add(1, Ordering::Relaxed);
            }
        }
    }
    fn assert_progress_obligation(&self) {
        if self.has_work() {
            assert!(
                self.events.load(Ordering::Relaxed) > 0,
                "queued work has no wake"
            );
        }
    }
}
#[test]
fn all_small_schedules_preserve_wake_or_drain_for_every_accepted_message() {
    for capacity in [1, 2] {
        loom::model(move || {
            let queue = Arc::new(ModelQueue::new(capacity, Protocol::Correct));
            queue.push(1).unwrap();
            let producer = {
                let q = queue.clone();
                thread::spawn(move || {
                    if let Err(value) = q.push(2) {
                        assert_eq!(
                            value, 2,
                            "backpressure must retain the rejected owned value"
                        );
                    }
                })
            };
            let consumer = {
                let q = queue.clone();
                thread::spawn(move || q.callback())
            };
            producer.join().unwrap();
            consumer.join().unwrap();
            queue.assert_progress_obligation();
            if queue.has_work() {
                assert_eq!(queue.pop(), Some(2));
            }
            assert!(!queue.has_work());
        });
    }
}
#[test]
#[should_panic(expected = "queued work has no wake")]
fn clear_after_drain_has_a_model_checked_lost_wake_counterexample() {
    loom::model(|| {
        let queue = Arc::new(ModelQueue::new(2, Protocol::ClearAfter));
        queue.push(1).unwrap();
        let producer = {
            let q = queue.clone();
            thread::spawn(move || q.push(2).unwrap())
        };
        let consumer = {
            let q = queue.clone();
            thread::spawn(move || q.callback())
        };
        producer.join().unwrap();
        consumer.join().unwrap();
        queue.assert_progress_obligation();
    });
}

fn characterize_bad_weak_memory(mode: Protocol) {
    loom::model(move || {
        let queue = Arc::new(ModelQueue::new(2, mode));
        queue.push(1).unwrap();
        let producer = {
            let q = queue.clone();
            thread::spawn(move || q.push(2).unwrap())
        };
        let consumer = {
            let q = queue.clone();
            thread::spawn(move || q.callback())
        };
        producer.join().unwrap();
        consumer.join().unwrap();
        queue.assert_progress_obligation();
    });
}
#[test]
#[should_panic(expected = "queued work has no wake")]
fn release_only_ack_can_clear_hint_then_observe_stale_empty_queue() {
    characterize_bad_weak_memory(Protocol::ReleaseOnlyAck);
}
#[test]
#[should_panic(expected = "queued work has no wake")]
fn failed_cas_coalescing_does_not_release_the_later_producers_work() {
    characterize_bad_weak_memory(Protocol::NoReleaseCoalescing);
}

fn bitmap_model(wake_before_bitmap: bool) {
    loom::model(move || {
        struct Hints {
            bits: AtomicUsize,
            ready: Ready,
            events: AtomicUsize,
            payload: [AtomicUsize; 2],
            consumed: AtomicUsize,
        }
        let h = Arc::new(Hints {
            bits: AtomicUsize::new(0),
            ready: Ready::default(),
            events: AtomicUsize::new(0),
            payload: [AtomicUsize::new(0), AtomicUsize::new(0)],
            consumed: AtomicUsize::new(0),
        });
        let producers = [0, 1].map(|i| {
            let h = h.clone();
            thread::spawn(move || {
                // Two separately scheduled producers own distinct payload slots.
                h.payload[i].store(i + 1, Ordering::Relaxed);
                if wake_before_bitmap && h.ready.publish() {
                    h.events.fetch_add(1, Ordering::Relaxed);
                }
                h.bits.fetch_or(1 << i, Ordering::AcqRel);
                if !wake_before_bitmap && h.ready.publish() {
                    h.events.fetch_add(1, Ordering::Relaxed);
                }
            })
        });
        let consumer = {
            let h = h.clone();
            thread::spawn(move || {
                if h.events.load(Ordering::Relaxed) > 0 {
                    h.events.fetch_sub(1, Ordering::Relaxed);
                    h.ready.acknowledge_before_drain();
                    let bits = h.bits.swap(0, Ordering::AcqRel);
                    if bits != 0 {
                        let one = bits & bits.wrapping_neg();
                        let i = one.trailing_zeros() as usize;
                        assert_eq!(h.payload[i].load(Ordering::Relaxed), i + 1);
                        h.consumed.fetch_or(one, Ordering::Relaxed);
                        // One-bit drain budget; republish the unfinished hints first.
                        h.bits.fetch_or(bits ^ one, Ordering::AcqRel);
                    }
                    if h.ready
                        .finish_bounded_drain(h.bits.load(Ordering::Acquire) != 0)
                    {
                        h.events.fetch_add(1, Ordering::Relaxed);
                    }
                }
            })
        };
        for producer in producers {
            producer.join().unwrap();
        }
        consumer.join().unwrap();
        let missing = 3 ^ h.consumed.load(Ordering::Relaxed);
        assert_eq!(h.bits.load(Ordering::Relaxed), missing);
        if missing != 0 {
            assert!(
                h.events.load(Ordering::Relaxed) > 0,
                "bitmap work has no wake"
            );
        }
    });
}
#[test]
fn first_publication_bitmap_precedes_wake_and_partial_scan_rearms() {
    bitmap_model(false);
}
#[test]
#[should_panic(expected = "bitmap work has no wake")]
fn waking_before_first_bitmap_publication_has_a_lost_work_schedule() {
    bitmap_model(true);
}
