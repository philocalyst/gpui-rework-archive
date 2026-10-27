# Bounded structural delivery sweep — preregistration

Base 6d5e409d6b. Prior BBTree parent-walk trials remain separate and unadopted.
Ordinary Runtime uses a single layout root; the next target is its actual
public deliver_ready path. Current numeric round-robin stage(index) repeatedly
resolves a static nested chain, potentially quadratic over one sweep. Test a
single structural traversal with a bounded admission cursor. No new executor,
readiness mirror, heap queue, interior mutability, or application API changes.

Preserve exact cursor progression, per-lane FIFO, staged backlog budget,
Limited semantics, miss reset after success, wraparound, frozen-before-callback
barrier, terminal status, cancellation credit and existing Question DAG order.
Reader dependencies continue to resolve through the existing typed authority.
A memory-ready stage does not permit busy-polling external futures. Keep the
original indexed stage helper as the differential/negative-control reference.

Use identical public recording-window fixtures for 1/8/32/64 Inbox lanes and
at least one real Question diamond. Complete operations include enqueue,
deliver, normal source publication and acknowledgement. Idle polls, one hot
lane, all ready, rotating budget-one, and callback-generated next-turn work
are adversaries. Exact applied payload transcript/final pixels and counters
must match. Full Question tests cover A-B-A, dependent joins and cancellation.

Before CPU timing freeze clean source and all build inputs, build unique targets,
verify actual executable identities, retain cold/storage/RSS and every failure.
Five alternating process pairs pinned CPU2, 200 warmups and 40 batches of 100
complete operations. Report CPU/wall p50/p95/p99. Primary target >=20% gain at
64 all-ready lanes; <=5% regression in every other cell; noise inconclusive.
Use no compiler/test/allocation work during timing. Algorithm/codegen claims
require actual linked assembly, not asymptotic assumptions about monomorphized
Rust. Full library tests and strict Clippy required. A cursor-reset mutant must
fail the existing public fairness test. Complete native/equivalent competitor
and physical hardware gates remain required before application victory.
