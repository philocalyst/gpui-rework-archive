# Sol review: ownership, parallel phases and the remaining contracts

Reviewed 2026-10-20 against the current integrated `reactivity/DESIGN.md` and
`GRAPHICS.md`, plus `concurrency-research.md`. This follows the earlier
[primitive review](review-sol.md). New evidence is executable in the
`ownership-lab` worktree; it informs the architecture rather than replacing its
document. The design now explicitly prices source discovery, constructor source
carriers, publication outcomes, exact translations, retained sheets and dense
fallbacks. Those corrections remove several earlier impossible Rust promises.

## Weak-memory correction: clear-before-drain needs an acquiring exchange

The earlier research protocol used `wake_pending.store(false, Release)`, which
is insufficient. The [current research protocol](</root/designs/reactivity/rework/concurrency-research.md:102>)
was corrected during this review.
A queue Acquire need not observe a producer's later tail just because its earlier
ready bit was cleared. The UI can clear the only hint, observe an older empty
queue and sleep with a payload still pending.

The ownership spike's Loom model finds this execution. Its initial implementation
used the same Release-only acknowledgement and failed the positive no-lost-work
property. Changing acknowledgement to `swap(false, AcqRel)` fixes that small model,
provided **every** producer/coalesced notification also performs a successful
AcqRel RMW. An Acquire-only failed CAS on already-pending state does not release
the later producer's queue writes. A second Loom characterization finds that
failure too. Merely changing the UI clear to Acquire does not fix weak producer
coalescing.

The current integrated
[host gate](</root/gpui-ce3/reactivity/crates/host/src/lib.rs:32>) now uses an AcqRel
`fetch_update` for both first and coalesced signals and an AcqRel acknowledgement.
That matches the required chain. Keep that invariant if simplifying it again.
The [corrected research argument](</root/designs/reactivity/rework/concurrency-research.md:111>)
now qualifies the wake path's role: the ring publishes payload, but the gate's
acquiring acknowledgement closes the visibility/liveness gap when coalesced work
would otherwise have no new native event.

A bitmap is also published **before** waking. Two independent modeled producers
write relaxed payloads, set ready bits, then use the same wake protocol. UI
exchanges hint words and republishes leftovers after a one-bit drain budget.
The corrected small model passes; notifying before first bit publication has a
lost-work witness. Queue truth and readiness hints are distinct, but their
ordering is not optional.

These are finite weak-memory models, not merely sequential occupancy traces.
They do not prove rtrb internals, OS event fairness, all producer counts, bit-slot
recycling, terminal close or arbitrary shutdown. Production fan-in still needs
bit registration/teardown tests so a retired producer cannot clear a reused
producer's hint. The actual queue remains authoritative during bounded drain.

## An executable zero-copy scope exists; do not broaden its lifetime

[DESIGN's borrowed-worker rule](</root/gpui-ce3/reactivity/DESIGN.md:276>) is
implementable directly. The spike's `BorrowedPhase` borrows one immutable
rectangle template and placements, grants workers disjoint mutable output pages,
and joins scoped threads before those borrows end. Serial and parallel execution
use the same kernel. Integer page-local damage OR produces bitwise-identical
results without a contended atomic per rectangle.

This is zero-copy **input ownership**, not an absence of computed output writes.
It cannot retain a template borrow in a persistent job or publish a reference to
mutable owner data while the owner continues handling input. Those boundaries
require an owned immutable page or shared lease, with its actual allocation and
retention cost. No generation check can replace that owner.

The measured threshold matters: 1,024 primitives take about 5.2 us serial versus
81.9 us with four fresh scoped workers; 262k primitives improve from 1.37 ms to
0.397 ms. Four-worker scope creation makes thirteen Rust allocations each phase,
before accounting OS stacks. A demand-started persistent scoped pool is a useful
next comparison; it cannot be declared free at the windowless floor. Share coarse
immutable inputs and grant exclusive output ranges, not one Arc/task per item.

## Owned page return proves CPU lifetime, not a device fence

The second spike uses two pinned rtrb SPSC rings and move-only preallocated Boxes.
Forward admission returns an immutable `ReadLease`; completing CPU reads returns
a `CompletedPage`, and a return ring gives the producer mutation again. Full and
observed-closed paths preserve the original owned payload. Tests retain addresses
through 2,000 cross-thread cycles, reject overwriting live drain slots, and prove
exactly-once drops with a non-Clone payload. A compile-fail test rejects completion
while a shared data borrow is still used.

No payload clone, per-message Arc increment or new backing allocation is required:
100k warm complete ownership roundtrips allocate zero in the instrumented run.
The small descriptor still moves. Setup costs seven allocations/9,312 requested
bytes for two capacity-two rings, two aligned ready tokens and one 8,192-byte
payload. This is a concrete useful boundary, not a zero-allocation startup claim.

[`GRAPHICS` correctly requires exact resource release](</root/gpui-ce3/reactivity/GRAPHICS.md:258>).
The CPU lease is deliberately **not** its implementation. A real backend must
hold ownership through its actual GPU fence and any OS/import release callback.
A token named `complete` cannot certify DMA completion. A stale-generation result
can be discarded semantically while its backing page must remain alive until
physical release. Memory pressure must stop admission or enter a supported
recovery policy; it cannot force-free an in-flight page to meet a byte budget.

The transport accepts ordinary owned pages, not a validated GPU resource-pool
identity. A resource adapter additionally needs pool/device/generation provenance
and exact release handling. Do not add that machinery to every ordinary CPU page
or pretend a sequence number already proves it.

## Bounded messages are not bounded memory or reliable infinite ingress

The design correctly separates queue depth and frames in flight. Also bound the
bytes in preallocated pages, worker input packs, pending full results and leases.
A capacity-two ring carrying Boxes does not bound the size of those Boxes. One
pending result per worker works only when admission credits also bound already
running work. An async executor with many concurrently completing tasks is not
one SPSC producer merely because it has a “worker” label.

For reliable native input, define the full policy before promising a bounded
preallocated FIFO. Key/IME/close callbacks cannot be arbitrarily dropped,
latest-wins coalesced, or blocked behind a stalled consumer. Processing native
callbacks directly at explicit owner barriers can avoid requiring an overflow
buffer. A theoretical unbounded arrival stream cannot have lossless delivery,
bounded memory and unconditional nonblocking admission simultaneously. Put the
backpressure boundary at the real producer/admission seam.

Acceptance is not acknowledgement. A receiver may shut down just after an
abandonment check; safe ring ownership keeps memory valid but cannot promise the
accepted message ran. Similarly, Handoff take/journaling does not by itself give
exactly-once external I/O across crashes. Such a claim needs a durable outbox and
receiver-side idempotency/acknowledgement protocol. Keep consume-once Rust
ownership and external protocol delivery claims separate.

## Determinism is algebra-specific

The new exact translation lane solves reassociation because every subpath sum
fits i128 under the u32-node/i64-source bound. Integer OR damage reduction is also
exactly associative. Those proofs do not authorize reordered floating source-over
summaries or unrestricted parallel geometry reductions.

[GRAPHICS already acknowledges finite grouping](</root/gpui-ce3/reactivity/GRAPHICS.md:43>).
Select the actual format/order/error policy before a scan replaces the scalar
oracle. Output page ordering, painter order, clip/effect dependencies and reduction
order must follow preassigned ranges, not worker completion order. Contiguous
partitions are an appropriate first path; atomic chunk claims need a separate
load-balancing measurement before work stealing or per-item scheduling.

## What remains unresolved, and what is not a contradiction

The architecture is candid that a bare Signal cannot discover a queue and that
arbitrary handler mutations are not rollback-safe. Do not restate those as open
soundness bugs after the explicit amendment. Typed descriptors remain a useful
manual escape hatch, while trusted validation/impact comes from the property
schema; the arbitrary accessor bundle is not enforcement.

The remaining deliverable is one compiled production path connecting owner
operations, immutable sheet outputs, validated worker admission and a real native
wake. The two page experiments need not become independent schedulers or a new
public queue family in that UI API. Adopt their ownership/acknowledgement
invariants at the existing seams, with losses and startup bytes visible. Keep the
CPU serial fallback and borrowed ordinary Rust surface; neither lock-free rings
nor clever algebra justify additional default per-primitive records.
