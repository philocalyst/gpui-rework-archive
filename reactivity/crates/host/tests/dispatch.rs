use gpui_reactivity_host::{Redraw, WakeGate};
use std::sync::{Arc, Barrier};

#[test]
fn idle_and_repeated_requests_do_not_schedule_extra_redraws() {
    let mut redraw = Redraw::default();
    assert!(!redraw.is_pending());
    assert!(redraw.request());
    assert!(!redraw.request());
    redraw.begin();
    assert!(!redraw.is_pending());
    assert!(redraw.request(), "a request made during rendering survives");
}

#[test]
fn concurrent_producers_signal_once_and_can_rearm_during_drain() {
    let gate = Arc::new(WakeGate::default());
    let barrier = Arc::new(Barrier::new(8));
    let signaled: usize = std::thread::scope(|scope| {
        let threads: Vec<_> = (0..8)
            .map(|_| {
                let gate = &gate;
                let barrier = &barrier;
                scope.spawn(move || {
                    barrier.wait();
                    let mut sent = 0;
                    assert!(gate.signal(|| {
                        sent += 1;
                        true
                    }));
                    sent
                })
            })
            .collect();
        threads
            .into_iter()
            .map(|thread| thread.join().unwrap())
            .sum()
    });
    assert_eq!(signaled, 1);
    gate.acknowledge();
    assert!(gate.signal(|| true));
    assert!(gate.signal(|| panic!("coalesced request must not send again")));
}

#[test]
fn failed_send_closes_the_gate_permanently() {
    let gate = WakeGate::default();
    assert!(!gate.signal(|| false));
    assert!(!gate.signal(|| panic!("closed gate must not attempt another send")));
    gate.acknowledge();
    assert!(!gate.signal(|| panic!("acknowledgement cannot reopen a closed loop")));
}
