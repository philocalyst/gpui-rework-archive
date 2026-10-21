//! Borrowed disjoint-page computation and owned SPSC page transfer experiments.
//! No ambient runtime, worker pool, per-item lock/refcount, or raw page pointer.
#![forbid(unsafe_code)]
mod pages;
mod phase;
mod ready;
pub use pages::{
    Accepted, CompletedPage, DrainError, DrainReport, OwnedPage, PageConsumer, PageProducer,
    ReadLease, SendError, page_lane,
};
pub use phase::{
    BorrowedPhase, Execution, LocalRect, OutputPage, PhaseError, PhaseReport, PlacedRect, Placement,
};
// Public only so the integration Loom test exercises the exact production bit
// operations. This is not a second native-waker service; page endpoints own it.
#[doc(hidden)]
pub use ready::Ready;
