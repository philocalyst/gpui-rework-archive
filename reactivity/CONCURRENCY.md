# Parallel work with one owner per mutable byte

Parallelism should remove serialization without adding a lock, reference count,
allocation or task to each node. The proposed unit of scheduling is an exclusive
output range or a move-only page. The source graph has one mutable owner. Most
work has ordinary Rust lifetimes; only work that crosses time needs a handoff
protocol. This is part of [DESIGN.md](DESIGN.md), with pinned implementations and
primary references in [concurrency-research.md](docs/concurrency-research.md).

## Ownership defines the schedule

| Owner | Exclusive responsibility | Shareable input | Completion boundary |
| --- | --- | --- | --- |
| Event-loop/UI owner | Native callbacks, source mutation, dynamic dependency discovery, identity, logical outcomes, input/focus, sheet publication | Published definitions and sheets | End of invocation/phase |
| Scoped CPU jobs | Disjoint output pages and local scratch | Borrowed immutable phase inputs | Join before input mutation or scratch reset |
| Long-lived worker | Owned job and scratch | Frozen batch, or one immutable backing lease | Stamped owned result, accepted on UI |
| Presentation owner | Device/queue state and resource residency, where backend affinity permits | Immutable sheet and upload/command pages | CPU release plus actual GPU/OS release |

Default presentation remains on the event-loop owner. Winit callbacks, window
creation, redraw/suspend/resume, native IME and platform presentation timing retain
their actual OS requirements. A render thread is a backend-specific optimization,
not a portable assumption. One shared, demand-started pool serves compatible
windows; an unopened service has no pool, queue or stack reservation.

Do not make arbitrary application state `Send` to enable rendering. `View`, owner
handlers and borrowed component arguments may contain `Rc`, platform objects or
other thread-confined values. Worker admission requires a deliberately frozen
`Send` input; shared borrowed inputs require `Sync`. This keeps the no-thread
application as ordinary Rust and keeps platform obligations out of components.

## Borrow within a phase; move across a phase

A phase splits the fields it actually needs:

```text
immutable definitions + admitted input version
                  │ borrowed by all jobs
                  ▼
output lane ── split_at_mut / chunks_mut ── exclusive ranges
                  │ scoped jobs join
                  ▼
deterministic reduction → candidate sheet
```

The safe kernel takes `&Inputs` and `&mut [Output]`, with no `&mut World` and no
callback into source mutation. The same kernel runs serially over all ranges or
in parallel over nonoverlapping ranges. The borrow checker prevents publication,
input replacement, page reuse and a second mutable writer until the phase joins.
No per-item `Arc`, lock, atomic or `Clone` is involved. It is permissible to copy
small registers/queue descriptors; zero-copy here means that the owned payload
allocation and its contents are neither duplicated nor relocated by handoff.

Use `std::thread::scope` as a correctness oracle and a scoped library pool for a
measured production realization. Spawning scoped OS threads per phase reserves
stacks and allocates; it is not a steady-state zero-allocation implementation.
Pool task submission may allocate too. Allocation accounting includes the actual
executor and first/warm dispatch separately. Do not hide a global pool in a
library call. A runtime-owned pool can accept bounded jobs without making the
runtime an ambient application API.

Work that survives the join instead receives an owned input pack. Prefer moving
an existing page; use one immutable `triomphe::Arc` backing per batch or shared
template fanout when ownership really branches. Borrow from that backing inside
the worker. Never clone one `Arc` per primitive, glyph, patch or node. ArcBorrow
cannot turn a scoped reference into an owned cross-turn reference.

## Schedule dependencies, not arbitrary tree cuts

Sharing input does not imply independent computation:

- Decode, shape and geometry preparation can work on independent immutable
  inputs, then publish stamped results.
- Layout can run independent roots or subproblems only after their available
  constraints, intrinsic/baseline inputs and parent negotiation are fixed.
  Flex/grid sizing and percentage dependencies do not become independent merely
  because nodes are siblings. Cephal's serial result remains the oracle.
- Static pure circuits can execute ready layers if their operations and captures
  meet `Send`/`Sync`. Dynamic edge discovery and source mutation stay serial;
  arbitrary closures retain a valid serial path.
- Tile jobs read scene-order bins and own distinct pixels. Effect passes obey
  explicit producer/consumer edges and halos; neighboring output tiles must not
  race by writing a shared blur halo.
- Damage and classification use disjoint partitions and exact local summaries,
  followed by an OR/count/prefix reduction. A worker-local full-domain N-bit set
  costs N/8 bytes per worker; partitioned sets avoid multiplying that storage.

Static contiguous ranges are the first schedule: good locality and no scheduling
atomic. If measured imbalance warrants it, workers can claim coarse ranges from
one `fetch_add(Relaxed)` cursor. That cursor assigns indices; a separate join or
release/acquire completion barrier publishes output. It does not by itself make
reading output safe. Work stealing is optional coarse scheduling, delegated to
an established library rather than another bespoke unsafe deque.

Choose grain by the complete saved work minus dispatch, wake, cache migration
and reduction cost. Keep tiny/sparse updates serial. Batch by geometry kind,
layout solution or tile locality before adding workers. A task per node turns
the scheduler into a second graph and loses the representation's savings.

## Move pages through bounded SPSC pairs

For a fixed producer and consumer, use a pinned bounded SPSC implementation such
as the audited `rtrb` 0.4.0. Two directional rings carry filled pages and returned
pages. A worker output ring has one producer; the UI holds its sole consumer.
Do not share the producer behind a lock and continue calling it SPSC.

```text
free page → producer owns &mut contents → filled page in reliable ring
          → consumer owns page → immutable CPU/GPU/OS leases
          → every required completion → return ring → free page
```

The page handle is move-only. A full ring returns the same owned page; capacity
failure cannot drop an occurrence or allocate an overflow vector. Bound a
producer's pending page and stop admitting further work until credit returns.
Do not block the UI waiting for ring space. Queue capacity, page capacity, maximum
in-flight jobs and pending slots are one admission/credit calculation.

If K workers each have C result slots of M bytes, slots alone cost K*C*M. Add
ring backing/control, padded cursors, ready hints, worker scratch, retained page
payload and stack reservation/residency. Padding and many mostly-empty rings can
lose to one mature MPMC for rare messages. Select cardinality from actual owners,
then measure; do not declare every channel SPSC by splitting logical names.

Reliable ordered data includes input transitions, text edits, Handoff values,
accepted actions, worker results and lease returns. Latest-wins storage is for a
complete superseding snapshot or an explicitly cumulative delta, never for those
events. A triple buffer can discard an unread presentation only if the newer
packet includes its scene state and all damage since the last consumed/acknowledged
version. Overwritten packets return every unused lease exactly once. Publishing
cannot run an arbitrary final destructor, GPU release or platform callback.

Use a low-frequency bounded MPMC ingress when producer cardinality genuinely is
open. User-visible state is still applied in UI order. A completion sequence is
not an event source's causal order; traces record source sequence and admission
order explicitly. Separate reliable actions from coalescible paint/time patches.

## Wakeups need both liveness and memory visibility

The ring publishes payload. A wake gate only coalesces host notifications, but
its ordering must ensure that coalescing cannot strand a queue read that observes
an older empty cursor. The admitted protocol is:

1. Producer publishes a payload through the ring's release operation.
2. Producer performs a **successful release/acquire RMW even when already
   pending**. The first idle-to-pending transition sends the native wake.
3. UI performs an acquiring RMW from pending to idle **before** inspecting ready
   hints or draining rings. That acquires the producers' preceding publications.
4. UI drains by count/time budget. If work remains, it re-arms before yielding.

The closed-safe `WakeGate` uses a successful update for idle→pending and
pending→pending; a failed acquire-only CAS on pending is insufficient. Its
acknowledgement uses acquire/release CAS and never reopens closed. An ordinary
release store to clear pending is also insufficient: it does not acquire the
coalesced producers. The release/RMW chain, plus queue acquire/release operations,
is the visibility argument. The model-checking experiment retains these weaker
forms as counterexample tests.

| Race | Required result |
| --- | --- |
| Producer's pending RMW precedes acquiring UI clear | Following drain observes its publication |
| Producer RMW follows the clear | Producer arms a new wake; duplicate wakes are harmless |
| UI stops draining with work queued | UI re-arms before returning to host |
| Producer races shutdown | Gate stays closed; pending ownership follows shutdown return policy |

A per-worker ready bit is a hint, not queue truth. Producer publishes its ring,
sets its hint, then arms the gate. UI acquires the gate and snapshots/clears hint
words before draining. Arrivals after that snapshot set the next hint; a bounded
drain preserves/restores the hint for remaining work. Ready words may be sharded
to avoid all workers ping-ponging one cache line. Model the composed protocol,
including multiple producers sharing a hint word; testing a queue in isolation
does not establish wake correctness.

`rtrb` documents wait-free queue operations. The host proxy, allocator, destructor,
page fault, CAS wake gate and caller's retry loop do not inherit that guarantee.
The design claims bounded storage and ownership transfer without per-item locks;
it does not claim an entire UI frame is wait-free.

## Leases replace speculative reclamation

A generation validates identity. It does not keep memory allocated. A page
submitted to a driver remains immutable and pinned until its CPU borrowers have
ended and the actual GPU fence/OS import release has transferred ownership back.
Dropping a command packet or advancing a UI epoch is not that release.

Use distinct states/capabilities for prepared, submitted, GPU-complete and
OS-released resources. Backend code mints completion evidence from its actual
API; an application cannot manufacture a `Completed` value to reclaim memory.
Imported native/video buffers may need multiple named releases. Device generation
changes revoke future use while old resources retire according to device-loss
and callback rules. Resource IDs in packets never authorize unchecked pointers.

Prefer this linear page ownership over global epoch/hazard reclamation for the
normal pipeline. It gives a finite memory bound even when a consumer stalls:
admission stops at the lease cap. Shared fanout uses one bounded immutable page
lease with an explicit reader set/refcount where needed. A stalled reader cannot
pin an unbounded history of sheets. Reclamation/destructor work runs on its legal
owner in a bounded maintenance budget, with a reliable shutdown drain.

Shutdown first closes admission and revokes request authorities, then joins
borrowed work, returns queued/pending payloads under their declared policy,
releases device/OS resources legally and drops owners in the documented order.
No worker may call a dead window or block on a return queue whose consumer has
already exited. Test shutdown at every page transition, not just idle.

## SIMD and caches follow the representation

Dense per-kind lanes expose independent operations and predictable loads. Use
ordinary loops first, inspect vectorization and dependencies, then introduce a
small backend-dispatched kernel where it wins. Scalar tails, alignment,
uninitialized padding, aliasing and CPU feature checks are part of that kernel.
Do not assume a packed record is faster than SoA: measure which fields are read
together and total fetched cache lines. Cold route/debug/reflection metadata
stays out of paint, hit and damage lanes.

Bit masks and bounded integer prefix/count operations have exact associative
reductions. The fixed-subpixel translation specialization uses i128 path sums;
its admitted path bound prevents overflow for every regrouping. General f64
affine composition and finite-precision color folds do not have that property.
SIMD/FMA/reassociation must retain the selected reproducibility/error contract.
The discovered query-history cancellation case is a regression, not a tolerance
to hide behind a faster benchmark.

Keep producer/consumer control away from payload and each other's hot cursor.
Do not pad every primitive to a cache line. First-touch worker-local scratch and
coarse contiguous outputs reduce false sharing; NUMA placement and software
prefetch need counter evidence. Report cache misses, bandwidth and migration
alongside time. CPU workers, integrated GPU and compositor can contend for the
same memory bandwidth even when CPU utilization looks available.

## Latency and proof gates

Input has admission priority. Pure jobs have page-boundary cancellation and
deadline checks; a cancelled candidate releases its pages and leaves the last
coherent sheet available. Cancellation never discards a committed reliable
action. UI never waits on a long worker to route a key or settle source state.
Synchronous borrowed jobs are admitted only when their complete join fits the
phase budget; larger work takes the owned pending-result path.

Measure cold thread/service creation, warm dispatch, queue saturation, input
p50/p95/p99, worst callback duration, CPU/GPU overlap and memory high-water.
Compare serial/scoped/pool/presenter variants on the same workloads. Vary worker
count, chunk size, dirty density, scene order, tiny/deep/wide trees, cancellation,
stalled consumers and multiwindow contention.

Required proofs/tests are exclusive output coverage; serial/parallel equivalence;
exact-once page/drop/return; bounded full behavior; stale result rejection;
weak-memory wake and ready-hint liveness; damage accumulation across skipped
snapshots; CPU/GPU/OS release separation; and shutdown from every transition.
Loom models the small wrapper protocol, not a real GPU or OS. Miri checks any new
unsafe ownership wrapper, not atomic liveness. Reuse audited queue machinery;
unsafe is not a prerequisite for safe disjoint parallel work.
