#[cfg(feature = "loom")]
use loom::sync::atomic::{AtomicBool, Ordering};
#[cfg(not(feature = "loom"))]
use std::sync::atomic::{AtomicBool, Ordering};

/// Internal protocol seam, also exercised with Loom atomics. The queue owns
/// payload publication; acquiring this hint also orders discovery after coalescing.
/// This is not a native terminal-close gate. True return means the
/// caller MUST schedule a wake. Failed OS notification requires shutdown/retry
/// policy at the host, not a claim of delivery from this flag.
#[derive(Debug, Default)]
#[repr(align(64))]
pub struct Ready(AtomicBool);
impl Ready {
    pub fn publish(&self) -> bool {
        !self.0.swap(true, Ordering::AcqRel)
    }
    // Acquire the release chain of EVERY coalesced producer before checking the
    // queue. A Release-only store can clear the hint and then see a stale empty
    // queue under weak memory. Every publish must also be a successful RMW.
    pub fn acknowledge_before_drain(&self) {
        self.0.swap(false, Ordering::AcqRel);
    }
    pub fn finish_bounded_drain(&self, queue_has_work: bool) -> bool {
        queue_has_work && self.publish()
    }
}
