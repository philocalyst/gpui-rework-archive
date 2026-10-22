use async_channel::{TryRecvError, TrySendError};
use std::alloc::{GlobalAlloc, Layout, System};
use std::sync::atomic::{AtomicIsize, AtomicUsize, Ordering};
use std::sync::{Arc, Barrier};
use std::thread;

struct Counting;
static LIVE: AtomicIsize = AtomicIsize::new(0);
unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let pointer = unsafe { System.alloc(layout) };
        if !pointer.is_null() {
            LIVE.fetch_add(layout.size() as isize, Ordering::SeqCst);
        }
        pointer
    }
    unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
        LIVE.fetch_sub(layout.size() as isize, Ordering::SeqCst);
        unsafe { System.dealloc(pointer, layout) };
    }
    unsafe fn realloc(&self, pointer: *mut u8, layout: Layout, new_size: usize) -> *mut u8 {
        let new_pointer = unsafe { System.realloc(pointer, layout, new_size) };
        if !new_pointer.is_null() {
            LIVE.fetch_add(new_size as isize - layout.size() as isize, Ordering::SeqCst);
        }
        new_pointer
    }
}
#[global_allocator]
static ALLOCATOR: Counting = Counting;

fn live_bytes() -> isize {
    LIVE.load(Ordering::SeqCst)
}

struct Payload(Vec<u8>);

struct DropProbe {
    _value: usize,
    drops: Arc<AtomicUsize>,
}
impl Drop for DropProbe {
    fn drop(&mut self) {
        self.drops.fetch_add(1, Ordering::Relaxed);
    }
}

fn close_and_drain_retains_no_payloads_while_old_senders_survive() {
    let (owner_tx, owner_rx) = async_channel::unbounded::<Payload>();
    let stale_callback = owner_tx.clone();
    let before_payload = live_bytes();
    assert!(owner_tx.try_send(Payload(vec![0; 8 * 1024 * 1024])).is_ok());

    // Closing rejects future pushes but intentionally leaves already queued
    // values readable. Drain them before dropping this receiver/generation.
    owner_rx.close();
    let retained_before_drain = live_bytes();
    assert!(retained_before_drain >= before_payload + 8 * 1024 * 1024);
    let mut drained = 0;
    loop {
        match owner_rx.try_recv() {
            Ok(payload) => {
                // Touch the payload so the allocation remains observably live
                // through the drain operation in optimized builds.
                assert_eq!(payload.0.len(), 8 * 1024 * 1024);
                drained += 1;
                drop(payload);
            }
            Err(TryRecvError::Closed) => break,
            Err(TryRecvError::Empty) => panic!("closed queue reported Empty before Closed"),
        }
    }
    assert_eq!(drained, 1);
    let after_drain = live_bytes();
    assert!(retained_before_drain - after_drain >= 8 * 1024 * 1024);

    // A callback that outlives the receiver still owns the old channel, but
    // cannot append to it; its rejected payload is returned to the caller.
    match stale_callback.try_send(Payload(vec![1; 8 * 1024 * 1024])) {
        Err(TrySendError::Closed(payload)) => drop(payload),
        other => panic!("closed generation accepted a stale send: {other:?}"),
    }
    drop(owner_rx);
    drop(owner_tx);
    drop(stale_callback);

    println!(
        "queued_payload_bytes_before_drain={}",
        retained_before_drain - before_payload
    );
    println!(
        "queued_payload_bytes_released_by_drain={}",
        retained_before_drain - after_drain
    );
}

fn dropping_receiver_alone_retains_payload_until_last_sender_drops() {
    let (owner_tx, owner_rx) = async_channel::unbounded::<Payload>();
    let stale_callback = owner_tx.clone();
    let before_payload = live_bytes();
    assert!(owner_tx.try_send(Payload(vec![2; 8 * 1024 * 1024])).is_ok());

    drop(owner_rx);
    drop(owner_tx);
    let retained_after_receiver_drop = live_bytes();
    assert!(retained_after_receiver_drop >= before_payload + 8 * 1024 * 1024);

    // The stale callback keeps the channel Arc alive after the receiver goes
    // away. Only its final drop destroys the queue and any unconsumed values.
    drop(stale_callback);
    let after_last_sender_drop = live_bytes();
    assert!(retained_after_receiver_drop - after_last_sender_drop >= 8 * 1024 * 1024);

    println!(
        "queued_payload_bytes_retained_after_receiver_drop={}",
        retained_after_receiver_drop - before_payload
    );
    println!(
        "queued_payload_bytes_released_by_last_sender_drop={}",
        retained_after_receiver_drop - after_last_sender_drop
    );
}

fn close_race_drains_every_accepted_value() {
    // Bounded contention check of the async-channel 2.5.0 close/push race.
    // A barrier releases four producers and the closer together in each round.
    // Source inspection supplies the atomic-ordering proof; this stress only
    // checks observable accounting under ordinary thread scheduling.
    const ROUNDS: usize = 64;
    const PRODUCERS: usize = 4;
    const SENDS_PER_PRODUCER: usize = 512;
    let mut accepted_total = 0usize;
    let mut attempted_total = 0usize;

    for _ in 0..ROUNDS {
        let (tx, rx) = async_channel::unbounded::<DropProbe>();
        let drops = Arc::new(AtomicUsize::new(0));
        let gate = Arc::new(Barrier::new(PRODUCERS + 1));
        let accepted = Arc::new(AtomicUsize::new(0));
        let mut producers = Vec::new();

        for _ in 0..PRODUCERS {
            let producer_tx = tx.clone();
            let producer_drops = drops.clone();
            let producer_gate = gate.clone();
            let producer_accepted = accepted.clone();
            producers.push(thread::spawn(move || {
                // Ensure there is at least one already-published item before
                // closing, then race the remaining sends against receiver.close().
                assert!(producer_tx
                    .try_send(DropProbe {
                        _value: 0,
                        drops: producer_drops.clone(),
                    })
                    .is_ok());
                producer_accepted.fetch_add(1, Ordering::Relaxed);
                producer_gate.wait();

                for value in 1..SENDS_PER_PRODUCER {
                    let item = DropProbe {
                        _value: value,
                        drops: producer_drops.clone(),
                    };
                    if producer_tx.try_send(item).is_ok() {
                        producer_accepted.fetch_add(1, Ordering::Relaxed);
                    }
                }
                // Keep a stale callback sender alive until after drain/close.
                drop(producer_tx);
            }));
        }

        gate.wait();
        rx.close();
        let mut drained = 0usize;
        loop {
            match rx.try_recv() {
                Ok(item) => {
                    drained += 1;
                    drop(item);
                }
                Err(TryRecvError::Closed) => break,
                Err(TryRecvError::Empty) => {
                    panic!("close+drain saw Empty while concurrent producers were retiring")
                }
            }
        }

        for producer in producers {
            producer.join().expect("producer panicked");
        }
        let accepted = accepted.load(Ordering::Relaxed);
        let attempts = PRODUCERS * SENDS_PER_PRODUCER;
        assert_eq!(drained, accepted, "accepted events must all be drained");
        assert_eq!(drops.load(Ordering::Relaxed), attempts);
        accepted_total += accepted;
        attempted_total += attempts;

        // The sender used below is the global/control stream analogue; closing
        // the bus-event queue must not close or consume it.
        let (control_tx, control_rx) = async_channel::unbounded::<&'static str>();
        control_tx.try_send("RemoveAdapter").unwrap();
        assert_eq!(control_rx.try_recv().unwrap(), "RemoveAdapter");
        drop(control_tx);
        drop(control_rx);
        drop(tx);
        drop(rx);
    }

    println!("race_rounds={ROUNDS}");
    println!("race_attempted_values={attempted_total}");
    println!("race_accepted_and_drained_values={accepted_total}");
}

fn main() {
    dropping_receiver_alone_retains_payload_until_last_sender_drops();
    close_and_drain_retains_no_payloads_while_old_senders_survive();
    close_race_drains_every_accepted_value();
}
