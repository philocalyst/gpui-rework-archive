# Borrowed phases and owned page transfer

This crate makes two ownership boundaries executable without introducing a task
runtime. A `BorrowedPhase` shares an immutable rectangle template and placements,
partitions exclusive output pages, and uses the same kernel serially or through
`std::thread::scope`. A `page_lane` moves preallocated Box payloads through two
bounded SPSC rings, forward and return. The production library forbids unsafe.

```sh
cargo test -p gpui_reactivity_ownership_lab
cargo test --release -p gpui_reactivity_ownership_lab --features loom --test loom_protocol
cargo run --release -p gpui_reactivity_ownership_lab --example measure -- 12
```

`loom` is a test-only feature that substitutes instrumented atomics in the actual
Ready helper. Do not enable it for ordinary execution outside a Loom model.
Standalone validation used `/tmp/reactivity-ownership-harness/Cargo.toml`, pointing
at actual repository sources/tests and keeping the parent lockfile untouched.

## Borrowed phase

`BorrowedPhase::new(template, placements, &mut output_pages)` validates every
page length before writing. `run(Serial)` and `run(Scoped { workers })` call the
same concrete kernel. Each worker gets disjoint mutable pages plus shared input
slices. All scoped threads join before the borrow ends. No per-item Arc, clone,
lock or dynamic callback is used. There is no persistent pool or default thread.

The kernel computes integer translated rectangles and page-local damage bits
for an explicit 512x512 viewport with 64px tiles. i32 origins/placements and u32
extents are widened before addition, so endpoints fit i64 even at source limits.
Each page writes its own non-atomic bitset; the owner OR-reduces in page order
after joining. Integer OR is exactly associative. This is not a general affine,
AA/filter-aware damage implementation. Parallel floating reductions and ordered
blend operations require their own numeric/order contracts.

Geometry pages allocate once at construction. Serial warm runs allocate zero.
Scoped mode creates fresh threads and bookkeeping on EVERY phase. A worker panic
joins the phase and propagates; the unpublished output candidate can be partial
and must be discarded. This is not arbitrary-handler rollback.

## Page ownership and backpressure

The states are move-only:

```text
OwnedPage<T>: producer can mutate its Box
    -> publish into forward SPSC
ReadLease<T>: consumer can borrow &[T]
    -> complete after CPU reads end
CompletedPage<T>: returnable exclusive owner
    -> recycle into return SPSC
OwnedPage<T>: producer reclaims and can mutate again
```

`SendError::Full(value)` returns the same owned value without overwrite. Observed
receiver shutdown returns `Closed(value)`. A shutdown racing after that check
can still follow successful admission; admission is not delivery or effect/GPU
acknowledgement. Drop releases unconsumed payloads safely. Endpoints and page
wrappers are not Clone. Pointer tests and a non-Clone drop-counted payload verify
no payload allocation/copy and exactly-once destruction through these transitions.
Moving the small Box/sequence descriptor does move bytes; “zero payload copy”
does not mean literally no descriptor stores.

`drain`/`reclaim` fill caller-preallocated Option slots. Empty budgets or occupied
slots are rejected before acknowledgement, so no live lease is overwritten.
A returned `wake=true` is mandatory notification to that direction's receiver.
Budgeted leftover work explicitly rearms. The public records are `must_use`.
The host supplies the actual nonblocking wake and close policy; this crate owns
no event loop, timer, blocking send or second scheduler.

`ReadLease::complete` is CPU completion, **not a simulated GPU fence presented as
one**. Its shared references cannot remain live across completion (compile-fail
coverage). A real adapter must retain the lease through actual GPU fence and OS
release callbacks. Sequence stamps are diagnostic: they neither free storage nor
make stale raw pointers safe. This API transfers ordinary owned Boxes; a resource
pool adapter must additionally check its own pool/resource provenance.

Ring capacities bound descriptor count, not arbitrary payload bytes. A production
caller must also bound the preallocated page pool and admitted in-flight bytes.
No overflow Vec is created here. A page that cannot return stays owned by the
consumer until retry or shutdown. Lease retention, endpoint drop and background
OS/GPU cancellation are distinct policies.

## Weak-memory wake proof and Loom scope

The bit is a hint; the queue remains authoritative. The bit's **acquiring
acknowledgement also participates in the visibility/liveness proof**:

1. Write payload and Release-publish the queue tail.
2. Publish the ready hint with a successful AcqRel RMW, including when already
   pending. If it was false, schedule a host wake.
3. At callback start, AcqRel-exchange pending to false BEFORE checking/draining.
4. Drain a bounded batch; if the queue is still nonempty, republish/rearm.

All pre-acknowledgement producer RMW releases form the chain acquired by the
consumer exchange. Queue reads therefore cannot miss those published entries
while clearing their sole hint. A producer after that exchange sets a new hint
and schedules a wake, possibly redundantly. A full budget republishes unfinished
work. Successful host notification and eventual callback scheduling are external
assumptions, not an OS liveness theorem.

Six Loom tests explore finite small programs without setting preemption or
permutation bounds: capacities one/two, one bounded callback, later publication,
full ownership return, and two separately scheduled bitmap producers. Relaxed
atomic payload cells model slots without new unsafe test code; tail/head use
Release/Acquire. The actual production Ready operations use Loom atomics. The
abstract model does NOT instrument or prove rtrb's internal unsafe implementation.

Two positive models preserve accepted FIFO data and an outstanding wake for any
unfinished work. Four expected-panic models find real witnesses:

- clearing after drain;
- Release-only `store(false)` acknowledgement seeing stale empty queue;
- failed-CAS Acquire-only coalescing omitting later publication from the chain;
- host wake preceding the first ready-bitmap publication.

The bitmap model publishes the payload, AcqRel-sets its hint, then wakes. The
consumer exchanges hints and republishes budget leftovers. This is evidence for
the hint protocol, not a shipped bitmap registration/recycling implementation or
a proof for unbounded executions/fairness. Four tests characterize bugs; their
passing status means the broken alternatives have counterexamples.

## Dependency and cache assumptions

Pinned [rtrb 0.4.0 source](https://docs.rs/rtrb/0.4.0/src/rtrb/lib.rs.html) provides
one producer/consumer, fixed-capacity storage, Release tail/head publication and
Acquire opposite-cursor checks. Its single-slot operations are documented as
wait-free; that does not make caller loops, allocation, destruction, OS wakes or
frames wait-free. The wrapper uses the current acquire-synchronizing abandonment
check. The two endpoints share rtrb's custom two-owner header; payload transfer
performs no std Arc clone/refcount. Each ring has a setup Box header plus a slot
allocation. Each direction also has one Arc-owned Ready token, cloned only at
setup. rtrb's source uses 128-byte cursor padding on x86-64; Ready is aligned to
64 bytes. These are layout choices, not proof of zero cacheline contention.
Producer/consumer cursors necessarily communicate. Adjacent output-page metadata
can share boundary cachelines; no cache-miss/prefetch claim was measured.

[Loom 0.7.2](https://docs.rs/loom/0.7.2/loom/) explores modeled atomic executions;
it is not a replacement for dependency safety validation or platform callback
fixtures. No Miri/sanitizer result is claimed for this task. The only new unsafe
is isolated allocation instrumentation in `examples/measure.rs`: it forwards the
exact pointer/layout to System, using nonallocating atomic counters. It is not
adopted as a production allocator or ownership optimization.

## Measured costs and losing regimes

`measure.csv` is one Ryzen 7 3700X/x86-64/Rust 1.97.1 release run, 12 phase rounds,
no CPU pinning. Scoped startup/join and Rust allocations are INCLUDED. OS stack
reservations/mappings, scheduler internals and GPU memory are outside the allocator
counter and must be measured separately in a real host.

| Work | Serial | Scoped 2 | Scoped 4 |
| --- | ---: | ---: | ---: |
| 1,024 primitives | 5.20 us | 52.5 us | 81.9 us |
| 16,384 primitives | 83.2 us | 92.0 us | 106 us |
| 262,144 primitives | 1.370 ms | 0.688 ms | 0.397 ms |

Serial warm phase allocation count is zero. Scoped two/four workers cost seven/
thirteen Rust allocations per phase, respectively; four-worker requested bytes
are 680 per phase, excluding stacks. Large phase output geometry is 6,291,456
bytes; setup allocates 4,099 times/6,423,552 requested bytes including page headers,
inputs and 4,096 output Boxes. This is a deliberately explicit page representation,
not proof that one Box per tiny instance is the best storage.

Two capacity-two rings, two aligned Ready tokens and one 8,192-byte payload cost
seven setup allocations/9,312 requested bytes. Of that, 1,120 bytes are queue/hint
setup, not payload. After setup, 100,000 same-thread publish/read/complete/return
cycles allocate **zero**, averaging 59 ns per complete roundtrip in this run.
A two-thread scoped run averages 603 ns including polling/yields and startup;
it makes four startup allocations/224 requested bytes total. Threads are not
pinned, and this does not predict event-loop/compositor latency.

Keep serial as the small-work default. This evidence supports scoped borrowed
pages above measured grain thresholds and linear preallocated ownership transfer
at a real thread boundary; it does not justify a mandatory pool, per-item task,
new unsafe reclamation scheme, or globally lock-free GUI architecture.
