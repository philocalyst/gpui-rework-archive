# Concurrency research: borrow locally, move across time, bound every handoff

**Research snapshot:** 2026-10-20. This proposes an ownership protocol for the runtime in [08-runtime.md](inputs/final/08-runtime.md), not a claim that its queues or event loop are already implemented. Upstream code versions and licenses are pinned below. Progress terminology is precise: `rtrb` documents a wait-free SPSC queue operation; that does not make allocation, destruction, OS wakeup, GPU submission, or an entire frame wait-free. “Lock-free” is not used as a synonym for “fast” or “no mutex in the hot path.”

## Design decision

Keep mutable reactive state, event normalization, Winit callbacks, description, layout, hit/accessibility publication, and the default presentation submission on the event-loop owner thread. Parallelize bounded pure work over immutable inputs and disjoint output slices; join before the borrowed phase ends. Anything that crosses an event turn or survives after a phase ends is an owned immutable packet. Use bounded per-worker SPSC queues for genuinely reliable worker results, a reliable FIFO for events, and a latest-wins triple buffer only for replaceable complete presentation state. Share large immutable inputs at batch/template granularity with `triomphe::Arc`; do not clone an `Arc` per item, node, tile, or glyph.

Use the **narrowest safe tool first**: ordinary Rust borrowing and slices inside a phase; scoped parallel iteration for large independent ranges; bounded SPSC for a fixed producer/consumer pair; one bounded MPMC library channel only where producer/consumer cardinality actually requires it; existing platform wake proxies to reach the event loop. Do not create a custom lock-free deque, allocator, epoch reclamation scheme, or global scheduler as a prerequisite for parallelism.

## One ownership protocol

```text
event-loop owner (Winit/UI; single mutable graph owner)
   │ 1. freeze data needed after this phase; otherwise borrow read-only
   ├── scoped borrowed phase ── Rayon / std scoped threads ── join ──┐
   │     immutable `&[T]`, disjoint `&mut [U]`, worker-local scratch    │
   │                                                                  └─ UI owner continues
   │ 2. async/long CPU work receives owned batch + generation/revision
   ├── one bounded SPSC inbox per fixed worker (or measured library pool)
   │          worker-local scratch → bounded per-worker SPSC outbox
   │                                           │ ready bit + idempotent wake
   │ 3. UI clears wake pending before bounded drain; validates stamps; applies
   ├── immutable latest `PresentPacket` → 3-slot latest-state buffer → presenter
   │        (only if backend/threading makes separate presenter legal)
   └── exact page/resource return SPSC ← presenter/GPU completion/OS release
```

The UI thread is the sole mutable owner of the reactive graph and the Winit event loop. It may own the renderer too; this is the default because Winit’s `EventLoop` is `!Send + !Sync`, is intended to be created on the main thread for portable behavior, and platform graphics/presentation APIs impose their own thread rules. A separate presentation owner is an optional backend realization, not a universal thread. Winit `EventLoopProxy` is the cross-thread event-loop wake route; worker code must not call reactive graph code or recursively settle from a wake callback. See the pinned Winit 0.30.13 audit in [research-platform.md](research-platform.md) and [Winit’s pinned event-loop source](https://github.com/rust-windowing/winit/blob/e9809ef54b18499bb4f2cac945719ecc2a61061b/src/event_loop.rs).

### Borrowed phase work versus owned cross-turn work

When all results are needed before the next phase, make the borrow explicit and split the output into disjoint slices:

```rust,ignore
fn patch<'frame>(input: &'frame [Node], output: &'frame mut [Patch]) {
    assert_eq!(input.len(), output.len());
    output.par_chunks_mut(CHUNK).enumerate().for_each(|(chunk, dst)| {
        let start = chunk * CHUNK;
        for (src, out) in input[start..start + dst.len()].iter().zip(dst) {
            *out = classify(src); // pure; no mutable graph, no allocator
        }
    }); // joined before `input`/`output` are borrowed again
}
```

The compiler proves exclusive output slices do not overlap. There is no `Arc` clone, per-item message, shared mutable bitset, or publication atomic for this phase. Rust `thread::scope` allows a worker closure to borrow non-`'static` data and joins all scoped threads at scope exit; Rayon offers the same useful pattern through `ThreadPool::install` / scoped parallel iterators ([`std::thread::scope`](https://doc.rust-lang.org/std/thread/fn.scope.html), [`Scope::spawn`](https://doc.rust-lang.org/std/thread/struct.Scope.html), [Rayon parallel slice API](https://docs.rs/rayon/latest/rayon/slice/trait.ParallelSliceMut.html)). The borrow lifetime ends at join. Do not smuggle that reference into a `'static` worker queue.

For work that can outlive the phase, freeze the minimum required input into one owned batch: content/revision stamps, a compact range/task list, and either moved inline data or one shared immutable backing allocation. A worker returns an owned result plus `{owner_generation, request_revision, work_sequence}`. UI applies only if all three still match. Revision checks reject stale results; they do **not** prove that a pointer is still allocated or make dereferencing a freed object safe.

`triomphe::Arc` is useful for immutable cross-thread snapshots when weak references are unnecessary. The crate’s `Arc` omits weak-count storage and weak-reference RMW work; `ArcBorrow` is a pointer-sized borrowed view that does not own a reference and cannot outlive its source ([triomphe 0.1.17 docs](https://docs.rs/triomphe/0.1.17/triomphe/), [ArcBorrow docs](https://docs.rs/triomphe/0.1.17/triomphe/struct.ArcBorrow.html)). Use ordinary borrows/`ArcBorrow` inside a valid scope. Use an owned `Arc` only at a real ownership boundary, commonly one clone per submitted batch or per shared template fanout. The existing runtime measured borrow reads as much cheaper than cloning an `Arc`; its “borrow to read” law should hold in the worker path too. Refcount clone/drop is still shared atomic cacheline traffic; triomphe does not make that free.

### Typed phases and cache-friendly parallel output

Use phase-specific records instead of a generic work-item framework:

```rust,ignore
struct FrozenBatch { owner: OwnerGen, revision: Revision, input: Arc<[InputRecord]> }
struct WorkerResult { owner: OwnerGen, revision: Revision, patches: PageLease<Patch> }
struct PresentPacket { epoch: Epoch, scene: SceneLease, damage: DamageSnapshot }
struct ReturnedLease { id: LeaseId, after: FenceValue, release: ReleaseReason }
```

These are illustrative kernel-internal shapes. Cross-turn records own their memory or hold a lease whose lifetime protocol is explicit. UI-only structures remain `!Send` and need no atomics. Workers write into per-worker scratch or disjoint ranges. For boolean/dirty classification, each worker may write an exact local bitset and UI OR-reduces words once after join; this avoids contended `fetch_or` on every node and false sharing between adjacent atomic bits. If the next pass consumes set-bit indices, scan words linearly (SIMD-friendly), then prefix-sum per-worker counts to assign compact output ranges. Benchmark against dense scatter at realistic dirty rates: a full bitset sweep loses when only a few nodes change. Keep the previously measured dirty-walk/dense-patch fast paths where they win. Do not add software prefetch just because a bitset is large: linear word scans are hardware-prefetch-friendly already; measure cache-miss stalls and the target CPU first, since explicit prefetch may evict useful lines or waste bandwidth.

Across asynchronous workers, give each worker private scratch and a producer-owned SPSC outbox. A producer writes its completion payload, then publishes the queue tail with `Release`; UI consumes the tail with `Acquire` before reading payload. Queue control words and worker readiness should not share hot cache lines with the UI’s consumer cursor. A single global atomic ready bitmap can itself become a new contended cacheline: partition ready words by worker group and pad groups to cache lines, or use one padded readiness flag per worker where worker count is modest. Readiness is a hint; each ring is the source of truth. A ready-bit clear must be followed by checking the ring and restoring/rearming if it remains non-empty.

Prefer coarse chunks over a task per node. Start with static contiguous partitions because they preserve locality and have no scheduling atomic. If measured shape imbalance hurts p99, let workers claim *chunks* from one atomic cursor (`fetch_add(chunk_len, Relaxed)`) over an immutable range; the cursor only allocates disjoint indices. A synchronous scoped phase still joins all workers before reading outputs; a persistent pool additionally needs an explicit completion counter/barrier whose final Release/Acquire handoff publishes those outputs. Tune chunk length against task imbalance, cache migration and input-latency interference. Per-item work stealing adds a much harder deque/weak-memory proof and is unjustified unless chunk assignment is measured as the bottleneck.

For parallel rasterization, assign each pixel tile a single writer/workgroup. Each tile reads a compact list of scene commands in original painter order. This removes per-pixel atomics and preserves source-over ordering. Bins can be built in parallel using private count arrays + reduction/prefix sums; the fine pass uses a stable order within each tile. Do not atomically blend arbitrary translucent fragments in whichever order threads finish. Floating-point source-over is noncommutative in order and finite precision makes regrouping/reassociation observably different. Reorder only proven opaque, order-independent regions.

## Reliable queues, latest-state buffers, and wakeups are distinct protocols

### Queue choice and current source audit

| Primitive | Audited source / license | Useful guarantee | Suitable use | Do not infer |
|---|---|---|---|---|
| `rtrb` 0.4.0 | [`mgeier/rtrb`, commit `494aea450b4a686682cd0e941ff4317f967c8f23`](https://github.com/mgeier/rtrb/tree/494aea450b4a686682cd0e941ff4317f967c8f23), MIT OR Apache-2.0 | Explicit SPSC ownership: `Producer`/`Consumer` are `Send`, not `Sync`; bounded `push` returns `Full(value)`; release-publishes tail and acquire-observes opposite cursor; docs call it wait-free | Per-worker completion outbox, UI↔single presenter, page-return queue | Not multi-producer; not allocation-free if the payload allocates; destructor, callback, OS wake and caller loop are not guaranteed wait-free |
| `triple_buffer` 9.0.0 | [`HadrienG2/triple-buffer`, commit `90f704172a61642c7e045e4d8d69151e49f5dcf1`](https://github.com/HadrienG2/triple-buffer/tree/90f704172a61642c7e045e4d8d69151e49f5dcf1), MPL-2.0 | One producer/consumer with three slots; publish/read swaps indices using AcqRel; consumer sees the latest published value and unread intermediate values can be overwritten | Complete replaceable scene/presentation snapshot; cursor/paint patch only when latest state subsumes skipped updates | Not a FIFO, not safe for key/button/IME events or lease returns; producer/consumer ownership API and dirty bit do not automatically solve outer wake protocol |
| `crossbeam-channel` 0.5.17 | [`crossbeam-rs/crossbeam`, commit `099d0469efcfacb32527bd9451a4fb62586ae537`](https://github.com/crossbeam-rs/crossbeam/tree/099d0469efcfacb32527bd9451a4fb62586ae537/crossbeam-channel), MIT OR Apache-2.0 | Mature bounded MPMC channel, preserves messages, handles cloned producers/consumers, supports `try_send` | General ingress with truly multiple independent producers; lower-frequency reliable messages | Not wait-free API; bounded `send` can block; per-slot sequence/CAS coordination is broader contention than SPSC; use `try_send` on latency-sensitive senders and define full behavior |

These are upstream source identities retrieved 2026-10-20, not a claim that all three should be vendored. Prefer one dependency only if its semantics match. `rtrb`’s ring buffer is a credible default for one producer/one consumer; its source has the standard SPSC release/acquire pattern: producer writes slot, stores new tail `Release`, consumer loads tail `Acquire`, reads initialized slot, stores head `Release`; producer acquire-loads head before reusing that slot. The Rust memory model defines this publication edge: writes before a release are visible after a matching acquire ([Rust atomic ordering docs](https://doc.rust-lang.org/std/sync/atomic/enum.Ordering.html)). Crossbeam’s bounded array queue instead uses a per-slot stamp plus CAS reservation and SeqCst fences in contended paths ([pinned array source](https://github.com/crossbeam-rs/crossbeam/blob/099d0469efcfacb32527bd9451a4fb62586ae537/crossbeam-channel/src/flavors/array.rs)); this is sound general MPMC machinery, not an argument to use an MPMC queue when all channels are SPSC.

The `triple_buffer` source explicitly uses an AcqRel swap because the producer must release prior writes and acquire the consumer’s relinquished buffer before reusing it ([pinned implementation](https://github.com/HadrienG2/triple-buffer/blob/90f704172a61642c7e045e4d8d69151e49f5dcf1/src/lib.rs)). It is a deliberate lossy/latest-wins protocol. Its current crate license is MPL-2.0 (per-file copyleft obligations); record that if vendoring/distributing source. If dependency policy disallows MPL, use an already-approved equivalent or skip this optimization; do not transmute it into a queue.

### Reliable FIFO event/completion path

Raw key/button/IME/clipboard/close events and protocol completions are reliable ordered data, never latest-wins patches. Event-loop input is already serialized by the Winit owner; normalize in-place into a preallocated FIFO and preserve per-source sequence. Worker completions use per-worker bounded SPSC. If a queue is full, `rtrb::Producer::push` returns the still-owned value: keep one bounded pending result on the worker, stop admitting more jobs to that worker, and wake the consumer; do not drop, allocate an overflow vector, or block the UI. Choose capacity/admission from a measured maximum in-flight work count, and expose `queue_full`, `pending_worker`, and `admission_stall` counters. If task producer cardinality is not fixed, use a bounded library MPMC queue at the dispatch boundary, but keep worker outputs SPSC.

Per-worker queue fan-in has storage `K × (C × sizeof(Result) + control)` for `K` workers and capacity `C`; its worst retained `Result` bytes must be bounded and in the ledger. Each queue is single producer/single consumer; no producer serializes on another producer’s head/tail cacheline. Ready flags/bitset add a small, explicit cost. A single MPMC is simpler for rare completion traffic; benchmark before insisting on the fan-in. Never put an `Arc` clone inside every queue element when a batch can refer to one owned backing lease.

### Triple buffer is only for snapshots that supersede

`PresentPacket` can be latest-wins only if it fully describes the current epoch or its damage is accumulated from the last acknowledged packet. If frame N carries “damage A” and frame N+1 overwrites it with “damage B,” the presenter still needs A∪B unless N was already consumed. Easiest safe packet is a complete immutable retained scene snapshot with epoch, or `delta_since_ack + accumulated_damage`. The UI writes into producer-owned slot, publishes, and may overwrite an unread snapshot. Presenter acquires the latest slot and discards the old one. No arbitrary events, completions, fence returns, accessibility deltas, or ownership transfers may be silently overwritten.

One-way latest state buffer is not enough for memory ownership. If its slots carry leases, overwriting an unread packet must return its leases exactly once. Use a fixed lease/page pool and explicit return queue or have the triple-buffer slot own a move-only lease whose drop returns into a bounded nonblocking reclamation path. Do not call an arbitrary destructor or GPU/OS release function from a timing-sensitive publish operation. Fixed-size scene packet slots avoid allocator work; move resource/page IDs, not owning `Arc`s per draw command.

### Lost-wake proof: clear pending *before* bounded drain

The queue stores data; a gate only coalesces host notifications. Model it as `Idle | Pending | Closed`, not as a Boolean that shutdown can accidentally reopen. Producer sequence is: (1) push/publish payload into its bounded queue (`Release` tail for SPSC), (2) use a closed-safe successful AcqRel RMW (`fetch_update` returning `Some(Pending)` for either open state, and preserving `Closed` without posting) so even an already-pending producer releases its queue publication. Post `Wake` only when the previous state was `Idle`. If the gate is `Closed`, no new work is admitted; an already-published completion follows the shutdown join-and-drain/return policy. A host wake does not execute UI work on the producer.

At each wake callback, UI does (1) an acquiring RMW acknowledgement `Pending -> Idle` before draining; if state is already `Idle`, it remains idle, and if `Closed`, it stays closed, (2) drains a bounded amount of work, and (3) if work remains, requests/rearms another host wake and keeps processing later. Every admitted producer performs a successful AcqRel RMW after publishing, including producers that find the gate already `Pending`; a failed compare-exchange with only `Acquire` semantics is insufficient. The shutdown owner changes the gate to `Closed` with a closed-safe RMW, stops admission and joins producers before its final drain. Never clear after checking queue empty. The clear-before-drain ordering closes both races:

| Producer timing | What happens | Why no item/wake is lost |
|---|---|---|
| Producer publishes, then gate RMW observes `Pending` before UI acknowledgement | It need not post a second host event | Its RMW release-publishes its queue write and acquire-links to the preceding pending-state RMW; UI’s later AcqRel acknowledgement reads the last preceding RMW in modification order and acquires its release sequence before draining |
| Producer publishes after UI `Pending -> Idle` acknowledgement | Its AcqRel RMW observes `Idle`, sets `Pending`, and posts wake | The post-ack producer RMW release-publishes the payload; UI may also consume it in the current drain; duplicate wake is harmless |
| Producer publishes after UI’s final empty test | Producer’s RMW reads false unless another producer already armed it; one RMW sets true and posts | Queue is non-empty with a host wake outstanding; if another producer armed it, that producer’s wake remains outstanding |
| UI hits message/time budget with work still queued | UI explicitly re-arms before returning to event loop | Bounded drain gives Winit/input another turn; remaining work is not stranded |

The wake gate participates in the weak-memory handoff; queue publication alone plus a notification bit set with relaxed/Acquire-only coalescing is not enough to justify that a later UI queue read sees the latest producer's publication. In the protocol above, each admitted producer's successful AcqRel RMW release-publishes its prior queue write. A coalescing producer's RMW also acquires the prior gate modification; successive RMWs extend the release-sequence/happens-before chain. UI's AcqRel acknowledgement reads the preceding RMW in modification order, including coalesced producers, before it drains. The queue's own Release tail / Acquire head protocol remains necessary for slot ownership and payload initialization; the acquired gate chain plus queue acquire loads ensures the consumer cannot legally treat a newly published item as absent due to a stale observation. Do not replace the producer RMW with `compare_exchange(false, true, AcqRel, Acquire)`: the failed `Acquire` path does not release-publish that producer's queue write, so the chain can omit it. Do not replace UI acknowledgement with `store(false, Release)`: it does not acquire the producers' release sequence before reading queues. Do not use a Boolean `swap(false) / swap(true)` as the final gate if shutdown must be terminal; use an enum and RMW that preserves `Closed`. This is an application-level handshaking invariant; do not assume an OS event-loop proxy guarantees notification coalescing or queue visibility. Duplicate wakes are permitted; lost reliable payloads are not.

For worker fan-in, producer first publishes its own ring entry, then sets its group’s ready bit with `Release` (`fetch_or` is only a hint), then uses the same closed-safe gate RMW. UI acknowledges with its closed-preserving AcqRel transition before snapshotting/swapping ready words and drains only flagged rings, but must recheck any ring whose budget ended and preserve its ready bit. Race after bitmap snapshot sets the bit in the next bitmap; race before snapshot is included. Queue head/tail, not the bitmap, decides whether data exists. Model-check this wrapper as well as testing the queue library.

Use Release/Acquire only where there is a proven synchronization pairing. `Relaxed` is appropriate for independent statistical counters, not for queue payload publication. `SeqCst` may be an acceptable starting point for a new tiny protocol; weaken only with a written happens-before argument and Loom coverage. Rust documents these orderings as matching C++20 atomics; Lê et al. show why translating work-stealing algorithms to weak memory requires more than copying the sequentially consistent proof ([paper, PPoPP 2013](https://hal.inria.fr/hal-00802885/document)). Avoid a custom Chase–Lev deque unless profiling requires work stealing and the weak-memory proof/test burden is funded: the original deque paper is not sufficient as an implementation ordering recipe ([Chase & Lev, SPAA 2005](https://www.cs.wm.edu/~dcschmidt/PDF/work-stealing-dequeue.pdf); corrected weak-memory treatment above).

## GPU/resource reclamation: generations validate identity, leases protect lifetime

Every shared page, imported plane, atlas allocation, command buffer, scene buffer and presentable resource has an owner and an explicit transition. Example:

```text
UI/asset owner → queued packet → submitted to queue/fence value N
              → GPU in flight → fence N signalled
              → OS/native release callback received (if required)
              → returned lease queue → free-list reuse
```

An epoch/generation check rejects an old ID after slot reuse, but it cannot make a dangling pointer valid. The memory must remain allocated and immutable until every CPU borrower and every GPU/OS consumer has relinquished it. If the driver has accepted an upload/command, CPU packet drop is not a GPU-completion fence. If an imported video/native surface is in use, release only at the API’s required synchronization point. Device loss revokes the device-generation namespace, then resources retire via loss semantics; it does not justify early free while callbacks still own pointers.

Prefer move-only `LeaseId { slot, generation }` with owner state and counts for named asynchronous consumers, not raw pointers in cross-thread packets. The lease table pins the page; return/free queue conveys a completed hand-back. Retire only when CPU borrows are joined/dropped, GPU fence has completed, and OS importer callback has returned ownership. Bound outstanding page leases per window/device and stop admission or fall back when at cap. Do not add global epoch-based reclamation as an easier-sounding substitute; it risks unbounded pins from a stalled reader and adds global grace-period work.

## Thread placement and latency policy

1. **UI/event loop:** Winit event loop, mutable graph, input, short UI phases, completion validation, hit/accessibility epochs. Never blocks waiting for a worker pool or full result queue. Winit event-loop callbacks are not interchangeable with an arbitrary thread; event loop creation/main-thread requirements are platform dependent and already pinned in [research-platform.md](research-platform.md).
2. **CPU workers:** only expensive, pure, bounded jobs with immutable owned input or scoped borrows and disjoint output. One process-wide/adaptive pool shared among windows; avoid one pool per window, nested pools, per-frame thread creation, or eager stacks. Admission uses UI latency deadline; workers yield/admit no lower-priority cache warm when input/frame deadline approaches.
3. **GPU queue/presentation:** renderer submits on whichever thread backend/API permits. By default this is UI/event loop for Winit portability and simple ownership. A separate presenter is allowed only after proving window handle, surface, queue, acquire/present, native release, and shutdown thread-affinity rules for each target backend. It receives immutable owned packets only and never accesses the graph.
4. **OS compositor:** separate OS-owned process/service; it is neither a GPUI worker nor a thread we can schedule. Native retained transforms may move composition there, subject to API semantics.

Parallelize above a measured grain size: tiny lists and sparse patches remain serial because task scheduling, cache migration, and worker wake cost exceed the saved work. `std::thread::available_parallelism()` is an estimate, not an affinity/latency promise. Let CPU/GPU composition compete on actual hardware; pinning threads can hurt portability, power and heterogenous-core placement. Measure input-to-photon p50/p95/p99 while workers saturate, not just isolated throughput. Bound worker completion drains by count *and* time, then service input and re-arm; do not let an adversarial completion burst starve pointer/key events. Results from stale epochs are dropped by owner/revision checks and count their drop reason.

## Memory and coherence ledger

For `K` workers, per-worker SPSC capacity `C`, message size `M`, and ready-group size `G` workers:

```text
completion slots            K × C × M bytes
ring control/cache padding  K × (2 aligned cursors + flags) bytes (implementation-specific)
ready bitset                ceil(K / G) × 8 bytes + cache-line padding
worker scratch              K × scratch_per_worker (counted high-water)
UI→present latest packet    3 × packet_slot_bytes (or 3 slots of indices/leases)
present→UI return ring      C_return × sizeof(LeaseId) + controls
pool stacks                 K × configured_stack_bytes of virtual reservation; resident use measured
```

Do not pack all worker head/tail or ready atomics into one cache line: false sharing can erase SPSC’s reduced logical contention. Pad hot producer and consumer cursors; benchmark the target CPU’s cache-line size instead of treating 64 B as an architectural law. Place worker scratch and output lanes on the worker that writes them, then merge sequentially on UI. On NUMA systems, first-touch allocation and remote reads can dominate; retain local scratch, batch work by page/range, and measure before adding node pinning. A dense exact bitset reduces random node atomics but has `N/8` bytes per worker; local scratch scales as `K×N/8`, so use tile/partition bitsets where full-domain bitmaps cost more than sparse lists.

Queue allocation is a startup/novelty cost, not steady per-item cost. `rtrb::RingBuffer::new(C)` allocates slots once; `push` moves the already-constructed `T`. If `T` contains a `Vec`/`Arc`, that payload’s allocation/refcount is still real. Build bounded page pools from the same per-window memory ledger; count committed/live bytes and queue high-water. A lock-free interface can still allocate, fault pages, run a slow destructor, or block in an OS wake.

## Validation: proof obligations, not just stress loops

| Invariant | Test/proof |
|---|---|
| Only one thread owns each SPSC half; payload is never read before publication and never reused before consumer releases head | Library unit tests + wrapper property tests at capacities 1, 2 and wrap boundaries; full/empty returns retain ownership |
| Wake protocol cannot strand a non-empty queue | Loom model of queue occupancy + `wake_pending` + producer/consumer clear-before-drain + host wake; enumerate enqueue before clear, between clear/drain, at empty-check, budget rearm, duplicate wake and shutdown |
| Readiness bit never suppresses queue truth | Loom model with two workers sharing a ready word, snapshot/clear, concurrent producer set, budget exit; queue remains authoritative |
| UI does not observe partial/stale worker publication | deterministic delayed/reordered worker results; validate owner generation, request revision, sequence and full cohort publication |
| Triple-buffer overwrites only supersedable complete state | test N unconsumed snapshots→latest N+k; cumulative damage/full-state equivalence; overwritten lease returned exactly once |
| No use-after-free on page/resource return | Miri on unsafe wrappers/drop paths; model CPU lease state machine; delayed GPU-fence and delayed OS-release fake callbacks; generation wrap/slot reuse tests |
| No event loss or accidental coalescing | flood key/button/IME/event protocol with saturated queues; assert ordered sequences, bounded backpressure, shutdown suffix semantics |
| UI latency remains bounded under worker burst | load test pointer/key while completions saturate; p99 and maximum callback budget; bounded drain must yield and rearm |
| Parallel output agrees with serial scene order | serial oracle for blend/path/tile output; randomized partitions; cross-architecture float tolerance and exact opaque tests |

Loom systematically permutes modeled concurrent executions under a C11-like model ([Loom README](https://github.com/tokio-rs/loom)); run a small abstraction of wrapper state, not an OS proxy or a GPU driver. Miri checks Rust UB/aliasing and unsafe ownership paths; it is not a proof of atomic liveness or GPU synchronization ([Miri project](https://github.com/rust-lang/miri)). Use standard queue implementations to inherit their audited ordering, and model-check the new composition around them. Every new `unsafe` needs an invariant comment, Miri fixture, stress test, and a measured reason; safe scoped slices should cover ordinary parallel raster/layout work.

## Tempting shortcuts to reject

* **One global MPSC “everything” queue:** turns independent worker completions into a shared reservation/cacheline point, mixes reliable events with coalescible frame patches, makes per-source ordering/backpressure unclear, and tempts unbounded buffering.
* **A custom lock-free queue before measuring:** introduces unsafe slot lifetime, wraparound, ABA and wakeup proofs. `rtrb` already provides a bounded SPSC implementation with explicit ownership; crossbeam covers general MPMC. Use either if semantics fit.
* **One `Arc` per item:** repeated refcount RMW on shared control block, extra pointer chase, and potential final-drop work on a latency-sensitive thread. Move compact values; share immutable backing once per batch/template.
* **Generation tags as reclamation:** tags only reject stale identity; they cannot protect the referent’s memory. Retain a lease until all CPU/GPU/OS users release.
* **Triple-buffer event queue:** loses intermediate events by design. It may only carry a fully superseding snapshot or cumulative patch state.
* **Clear wake flag after draining:** a producer may see the flag still armed, skip posting, then UI clears after observing empty; new work is stranded. Clear first, drain boundedly, rearm if work remains.
* **One permanent thread per window/core:** stacks, wakeups and pool contention burden startup and idle. Share a lazy bounded pool; keep the simple one-thread path for small/quiet workloads.
* **Atomic OR for every dirty node:** creates cacheline ping-pong. Use disjoint worker bitsets and reduce once, or dense scatter where touched set is sparse; select by measured density.
* **Atomic blending/parallel painter reordering:** can change alpha results and float rounding. Single-writer tile plus stable scene-order list is the uncomplicated correctness baseline.
* **Calling GPU/OS callbacks from a slot destructor:** destruction may occur on the wrong thread and before GPU/OS release. Defer ownership return through explicit queues/fences.

## Primary references and exact source identity

* `rtrb` 0.4.0, source commit [`494aea450b4a686682cd0e941ff4317f967c8f23`](https://github.com/mgeier/rtrb/tree/494aea450b4a686682cd0e941ff4317f967c8f23), MIT OR Apache-2.0; source implementation: [`src/lib.rs`](https://github.com/mgeier/rtrb/blob/494aea450b4a686682cd0e941ff4317f967c8f23/src/lib.rs). Project docs describe the SPSC API and candidly caution that its own benchmarks are hardware-sensitive ([README](https://github.com/mgeier/rtrb/blob/494aea450b4a686682cd0e941ff4317f967c8f23/README.md)).
* `triple_buffer` 9.0.0, source commit [`90f704172a61642c7e045e4d8d69151e49f5dcf1`](https://github.com/HadrienG2/triple-buffer/tree/90f704172a61642c7e045e4d8d69151e49f5dcf1), MPL-2.0; [pinned source](https://github.com/HadrienG2/triple-buffer/blob/90f704172a61642c7e045e4d8d69151e49f5dcf1/src/lib.rs).
* `crossbeam-channel` 0.5.17, source commit [`099d0469efcfacb32527bd9451a4fb62586ae537`](https://github.com/crossbeam-rs/crossbeam/tree/099d0469efcfacb32527bd9451a4fb62586ae537/crossbeam-channel), MIT OR Apache-2.0; [bounded array flavor](https://github.com/crossbeam-rs/crossbeam/blob/099d0469efcfacb32527bd9451a4fb62586ae537/crossbeam-channel/src/flavors/array.rs).
* Rust [scoped threads](https://doc.rust-lang.org/std/thread/fn.scope.html), [atomic orderings](https://doc.rust-lang.org/std/sync/atomic/enum.Ordering.html), and [atomic memory model](https://doc.rust-lang.org/std/sync/atomic/index.html); Rayon [`ParallelSliceMut`](https://docs.rs/rayon/latest/rayon/slice/trait.ParallelSliceMut.html).
* Chase & Lev, “Dynamic Circular Work-Stealing Deque,” SPAA 2005 [paper](https://www.cs.wm.edu/~dcschmidt/PDF/work-stealing-dequeue.pdf); Lê, Pop, Cohen & Zappa Nardelli, “Correct and Efficient Work-Stealing for Weak Memory Models,” PPoPP 2013 [author manuscript](https://hal.inria.fr/hal-00802885/document), DOI 10.1145/2442516.2442524.
* `triomphe` 0.1.17 [crate documentation](https://docs.rs/triomphe/0.1.17/triomphe/), including [`ArcBorrow`](https://docs.rs/triomphe/0.1.17/triomphe/struct.ArcBorrow.html).
* Loom [repository and usage](https://github.com/tokio-rs/loom); Miri [repository](https://github.com/rust-lang/miri).
* Winit 0.30.13, source commit [`e9809ef54b18499bb4f2cac945719ecc2a61061b`](https://github.com/rust-windowing/winit/tree/e9809ef54b18499bb4f2cac945719ecc2a61061b), Apache-2.0; event-loop requirements and API pinned in [event_loop.rs](https://github.com/rust-windowing/winit/blob/e9809ef54b18499bb4f2cac945719ecc2a61061b/src/event_loop.rs).
