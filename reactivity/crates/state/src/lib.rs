//! Explicit state primitives, independent of a UI runtime.
//!
//! This crate implements mutation stamps, bounded consume-once handoffs, request
//! admission, and separate logical/presentation publication. It does **not**
//! implement a reactive graph, direct wires, automatic read tracking, scheduling,
//! persistence, or recursive deltas. No operation looks up an ambient runtime or
//! invokes application effects.
#![forbid(unsafe_code)]

mod field;
mod handoff;
mod publication;
mod request;
mod signal;

pub use field::TypedField;
pub use handoff::{Full, Handoff, Unconsumed};
pub use publication::{Epoch, TwoEpoch};
pub use request::{AdmissionError, OwnerRegistry, OwnerScope, RequestGate, RequestStamp};
pub use signal::{Revision, Signal};
