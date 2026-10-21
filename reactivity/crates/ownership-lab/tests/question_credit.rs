#![cfg(feature = "loom")]
//! Model of the NEW single-writer question credit protocol. Payload publication
//! stands in for std's channel; it does not model that channel implementation.
use gpui_reactivity_ownership_lab::Ready;
use loom::{
    sync::{
        Arc,
        atomic::{AtomicBool, AtomicUsize, Ordering},
    },
    thread,
};
const RUNNING: usize = 1;
const TERMINAL: usize = 2;
struct Credit {
    state: AtomicUsize,
    payload: AtomicBool,
    ready: Ready,
    events: AtomicUsize,
    consumed: AtomicBool,
}
impl Credit {
    fn new() -> Self {
        Self {
            state: AtomicUsize::new(RUNNING),
            payload: AtomicBool::new(false),
            ready: Ready::default(),
            events: AtomicUsize::new(0),
            consumed: AtomicBool::new(false),
        }
    }
    fn signal(&self) {
        if self.ready.publish() {
            self.events.fetch_add(1, Ordering::Relaxed);
        }
    }
    fn finish(&self, second_wake: bool) {
        self.payload.store(true, Ordering::Release);
        self.signal(); // Remote.try_send can wake before the credit is returned.
        self.state.store(TERMINAL, Ordering::Release);
        if second_wake {
            self.signal();
        }
        // The linear cap never accesses the slot state again after this publish.
    }
    fn callback(&self) {
        if self.events.load(Ordering::Relaxed) == 0 {
            return;
        }
        self.events.fetch_sub(1, Ordering::Relaxed);
        self.ready.acknowledge_before_drain();
        let _message = self.payload.swap(false, Ordering::AcqRel);
        // A message and terminal which coalesced before acknowledgement are
        // acquired together. When still Running, the second wake is required.
        if self.state.load(Ordering::Acquire) == TERMINAL {
            self.consumed.store(true, Ordering::Release);
        }
    }
    fn assert_progress(&self) {
        if self.state.load(Ordering::Acquire) == TERMINAL && !self.consumed.load(Ordering::Acquire)
        {
            assert!(
                self.events.load(Ordering::Relaxed) > 0,
                "returned question credit has no wake"
            );
        }
    }
}
fn check(second_wake: bool) {
    loom::model(move || {
        let slot = Arc::new(Credit::new());
        let producer = {
            let slot = slot.clone();
            thread::spawn(move || slot.finish(second_wake))
        };
        let owner = {
            let slot = slot.clone();
            thread::spawn(move || slot.callback())
        };
        producer.join().unwrap();
        owner.join().unwrap();
        slot.assert_progress();
    });
}
#[test]
fn terminal_after_first_wake_never_strands_latest_input_credit() {
    check(true);
}
#[test]
#[should_panic(expected = "returned question credit has no wake")]
fn omitting_the_post_terminal_wake_has_a_lost_credit_counterexample() {
    check(false);
}

#[test]
fn acquired_terminal_pairs_with_its_unchanged_launched_ticket() {
    loom::model(|| {
        let state = Arc::new(AtomicUsize::new(RUNNING));
        let terminal = {
            let state = state.clone();
            thread::spawn(move || state.store(TERMINAL, Ordering::Release))
        };
        let mut launched_ticket = 7; // UI-owned; an old worker never writes it.
        if state.load(Ordering::Acquire) == TERMINAL {
            assert_eq!(launched_ticket, 7);
            state.store(RUNNING, Ordering::Release);
            launched_ticket = 8; // New lease only after consuming the old terminal.
        }
        terminal.join().unwrap();
        if launched_ticket == 8 {
            assert_eq!(state.load(Ordering::Acquire), RUNNING);
        }
    });
}
