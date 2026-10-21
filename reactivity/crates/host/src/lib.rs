//! The native loop owns callback timing; the core owns work and publication.
//!
//! This crate is an experimental internal boundary. Default builds contain no
//! window-system dependency, thread, timer, allocation, or process-global state.
//! Select `x11`, `wayland`, or `native` for the platform callback adapter.

#![forbid(unsafe_code)]

use std::sync::atomic::{AtomicU8, Ordering};

const IDLE: u8 = 0;
const PENDING: u8 = 1;
const CLOSED: u8 = 2;

#[cfg(any(feature = "native", feature = "x11", feature = "wayland"))]
pub mod native;

/// Coalesces wake requests until the owner starts draining work.
///
/// Publish work to its synchronized queue **before** calling `signal`. The
/// successful sender signals the native loop. That callback acknowledges
/// **before** draining the queue, so work arriving during the drain can wake it
/// again. This gate is not a queue or a memory reclamation protocol.
/// Drain to empty, or rearm before yielding with queued work still remaining.
#[derive(Debug, Default)]
pub struct WakeGate(AtomicU8);

impl WakeGate {
    /// Coalesces or sends a wake. False means the sender observed a closed loop.
    /// Once a send fails, later signals remain closed, including after an ack.
    /// The sending operation must not panic or reenter this gate.
    pub fn signal(&self, send: impl FnOnce() -> bool) -> bool {
        // A coalesced signal must also release its preceding queue writes.
        // The owner's acquiring acknowledgement observes this RMW chain before
        // checking the queues. An Acquire-only failed CAS leaves a lost-wake
        // execution possible when that check observes an older empty cursor.
        match self.0.fetch_update(Ordering::AcqRel, Ordering::Acquire, |state| {
            (state != CLOSED).then_some(PENDING)
        }) {
            Ok(IDLE) => {
                if send() {
                    true
                } else {
                    self.0.store(CLOSED, Ordering::Release);
                    false
                }
            }
            Ok(_) => true,
            Err(_) => false,
        }
    }

    /// Starts a drain; a subsequent request must signal the loop again.
    /// The acquiring RMW also observes coalesced producers before queue reads.
    pub fn acknowledge(&self) {
        let _ = self
            .0
            .compare_exchange(PENDING, IDLE, Ordering::AcqRel, Ordering::Acquire);
    }
}

/// Presentation requests coalesce locally; idle has no scheduled callback.
#[derive(Debug, Default)]
pub struct Redraw {
    pending: bool,
}

impl Redraw {
    /// Returns true when the native window needs its first redraw request.
    pub fn request(&mut self) -> bool {
        !std::mem::replace(&mut self.pending, true)
    }

    /// Called at the beginning of the native redraw callback, before rendering.
    pub fn begin(&mut self) {
        self.pending = false;
    }

    /// Whether a redraw request is outstanding.
    pub fn is_pending(&self) -> bool {
        self.pending
    }
}
