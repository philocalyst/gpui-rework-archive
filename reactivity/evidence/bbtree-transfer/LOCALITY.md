# BBTree, Solid and Ripple: preserve locality through publication

Research follow-up to the maintainer's request, 2026-10-27. This is a transfer
hypothesis, not a breakthrough or performance claim. All references are pinned
read-only checkouts. Prior failed experiments retain their original verdicts.

## Primary implementation evidence

BBTree: `1b0201087102f81189da0c4cd5054a91c8d97d62`,
`/home/user/bbtree-reference-local`. Read `design/12-batch-api.md` and
`bbtree/src/tree/batch.rs` alongside the earlier cost/history study.

- The unit of scheduling is an independent search, not a tree node or arbitrary
  callback. Read-only descent gathers destinations; writes apply in input order.
  A split invalidates affected destinations and separators. The whole batch
  cannot assume a path remains valid because it was valid at gather time.
- A lookup lane retains query, node, edge and prefix; results go to caller-owned
  slots. A live bitset and flat state machine avoid duplicate discriminants and
  nested resume dispatch. This is useful only when its cost is below the
  independent memory stalls it hides. Prefetch is not a readiness observation.
- The ordinary scalar path, append path and small-tree path stay distinct.
  The documented code-generation regressions from adding callers are material
  evidence for measuring complete alternatives, including unaffected controls.

Ripple: `fed124465d162ce17ce009936ef50061719d9882`,
`/home/user/ripple-architecture-reference`, official `Ripple-TS/ripple`.
This is the same revision named by the repo's earlier async-adapter study;
the new study reads compiler, dependency and scheduling code as well.

- `packages/tsrx-ripple/src/transform/client/index.js:1054–1241` emits a shared
  render function with an explicit state object when captures permit hoisting.
  `apply_updates` groups operations by expression identity, evaluates the
  expression once, compares its previous value and executes its destinations.
  The fast single-operation form remains separate. This is a concrete example
  of compiling a description into update operations rather than reinterpreting
  the whole component on each edit. `hoist.js` supplies the capture analysis.
- `packages/ripple/src/runtime/internal/client/runtime.js:850–1094` maintains
  intrusive subscriber links and recycles dependency records in read order.
  It removes stale dependencies after a run. Writes notify subscribers; lazy
  derivations forward notification, then clocks determine whether consumers
  really need to run. Dynamic branches must replace dependencies, not accumulate
  them. This JS object graph is not itself a cache-friendly Rust representation.
- The same file at `1113–1230,1297–1314` deduplicates scheduled blocks, sorts
  only if creation order was disturbed, and separates pre-effects, rendering
  and effects. A queue containing one kind runs directly. Paused/destroyed
  blocks are checked at execution, because earlier parent work may retire them.
- `track-async.js:170–352` ties a request to its call-site pending boundary,
  supersedes with a version, rejects stale completion, and aborts its controller.
  Pending/error derivations propagate separately from values. Promise abortion
  is not proof of physical worker retirement; GPUI's completion-credit rule
  remains necessary. This source does not justify a noop-waker task runtime.
- Historical commit `5de359e430391b0e1609795b42d26161fd5c2ff9` specializes first
  execution of a list item without its own tracked state. Its author reports
  about 4% table-mount improvement, while preserving a nested-list block because
  deleting it changed reactivity. These are upstream measurements, not ours.

Solid: `ff4d3c4479163fbdd3327f5b22d0c3ea7bd1a2c5`,
`/home/user/solid-architecture-reference`, official `solidjs/solid` RC source.
The article is separately pinned in SCHEDULING.md; article prose and runtime
revision must not be presented as if they were the same artifact.

- `packages/solid-signals/src/core/graph.ts` reuses ordered dependency links and
  uses a per-pass generation to avoid repeated scans on rereads. It exempts a
  pending computation from last-subscriber disposal; settlement must eventually
  release it. `async.ts:130–165` gathers release candidates before unlinking.
- `core/heap.ts` deduplicates queued computations and orders them by height;
  tracked effects go directly to their effect queue. This is a dependency-order
  scheduler, not a memory-prefetch executor.
- `core/scheduler.ts:640–715,881–926` separates notifying subscribers, staging
  values, committing values and checking live reporters of pending sources.
  Stale/destroyed reporters cannot keep a transition blocked. Read dependency
  identity, not component nesting alone, decides the relationship.
- `INTERNALS-ASYNC-STATE.md` explicitly distinguishes committed, held and
  optimistic values and records that no-tearing is enforced at effects. Async
  computation may advance before a merged transition reveals its correction.
  A single "dirty/pending" flag cannot encode those independent dimensions.
- `design/write-coalescing.md` is explicitly **iceboxed**, not implemented:
  writes currently notify eagerly even when their staged values later cancel.
  Do not advertise net-change notification elision as an existing Solid win.
  `scheduler.ts:93–104` also keeps a simpler synchronous flush when the optional
  transition/lane/boundary machinery is absent.

## What can actually transfer without changing application code

The common useful structure is:

1. Preserve precise dependency/destination identity from the edit.
2. Gather inputs without modifying published state.
3. Validate only the dependencies required by that candidate operation.
4. Apply operations in semantic order and publish a coherent result.
5. Retire obsolete work/resources using their real lifetime, not a dirty bit.

These systems do not make a display update identical to a B-tree insertion.
Text intrinsic size, flex sibling layout, clip chains, painter order, alpha and
backdrops create dependencies that a key lookup does not have. A display-tree
operation can become *analogous* to a certified leaf replacement when those
dependencies are explicitly unchanged. Structural changes must invalidate that
certificate, as splits invalidate BBTree's gathered destinations.

GPUI already has typed source fanout and staged complete/acknowledged scenes.
Adding another generic reactive graph would duplicate authority and storage.
The useful experiment is to carry the existing exact fanout through the final
publication stage, rather than abandon it because an unrelated feature exists
elsewhere in the window. Only after exposing independent residual gathers does
it make sense to compare scalar, level-wise and memory-yield execution.

## Concrete loss of locality in current GPUI

Audited composed source: `0ac7b8914b1c7b837f8d65a9be3d20ccb52cbff6`.
The sparse-text code is unchanged from the pre-scroll baseline `4afe067fe3e`.

`Runtime::patch` already identifies one changed text destination.
`present_walk` performs ordinary layout and proves that no layout write changed.
But `runtime/sparse_text.rs::try_sparse_text` then rejects **any** metadata,
image or viewport, and requires logical and acknowledged row indexes to match.
Consequently a text edit outside a virtual list loses the local publication
path even if the entire list, all geometry and all resources are unchanged.
Virtualization is a material issue: omitted overscan rows make logical indexes
different from presented indexes. Removing the guards alone is incorrect.

The local candidate must resolve exact P identity, obtain P's own transform
and clip, and update its text/interaction geometry only at acknowledgement.
It must retain the existing complete Canvas command/resource certificate;
equal layout dimensions alone do not prove equal glyph count, material state
or resource leases. Existing text-slot replacement may still reject the actual
stream trace. That rejection rate needs measurement, not an assumption of a win.

The first test should extend the proof to unrelated retained lists, with:

- exact source edit, unchanged layout/topology, no pending newer C;
- precise P identity despite omitted/reordered rows;
- immutable P geometry/clip and the unchanged Canvas run-admission gate;
- conservative fallback for active editing/inspector state;
- old P queries before ACK, exact new pixels and text geometry after ACK;
- resize, coalescing, new glyphs/changed count, removed rows and failed newer
  candidates as adversaries; a wrong-P-row mutant must fail semantic authority.

This establishes a reusable *local publication proof*, not yet a new tree or
async API. Measure actual Workload stream, stream-owner, scroll, both and small
controls. Record fallback counts and complete owner-to-GPU completion separately
from CPU preparation. A successful CPU-only result cannot establish ZGX parity.

## Further experiment, only after that evidence

If local publication matters but Canvas/GPU packet rebuilding still dominates,
investigate a scene sequence with stable segment identity and shared immutable
chunks. Replacement would gather a segment path, prepare new contributions,
validate predecessor/version and splice in painter order. Full traversal must
still be contiguous enough for dense/first frames. Charge every directory,
generation, lease, retained old chunk and flatten/upload cost. The existing
failed packet/tile experiments are mechanism controls, not permission to select
their winning cells or retune the old thresholds.

Async readiness is a separate semantic experiment: GPUI's declared Reader DAG
can identify joins, but currently promises progressive independent readers, not
Solid's atomic transition reveal. Adding commit groups needs explicit semantics
and tests for independent sibling progress, supersession and actual task teardown.
Do not silently change existing Reader behavior to make a benchmark faster.

All changes remain local. Required native parity, physical GPU measurements and
two hardware classes remain open. None of this research supplies those results.

## Follow-up evidence: precise support and actual image authority

Local glyph-damage Stage A (source 5c7bf163d78461ad096448cecfeadfa2ff9d4576) records
160 actual stream/owner updates. Median bounding repair is 99495 pixels, while the
union of changed glyph supports is 2891; 16px tiles cover 11520. Two public Canvas
regressions, six GPUI publication regressions, strict Clippy and 60 separate final
GPU-pixel qualification processes pass. These are work/correctness observations,
not timing evidence. Raw diagnosis and protocol are committed at 49c88983b420e5797fa15e30c6f8e774eac38465.

The bounded rectangle merge in Stage B uses a median 16 regions and 2905 pixels.
Source f864fdfdbe8a4b53b8b55126fdfad6371df6dd48 passes the GPU full-pixel oracle
in all three supported formats, including translucent overlap, empty updates and
failed/resize recovery. The first region tests wrongly assumed author bounds were
exact raster support; failed fixtures and correction are preserved. No timing yet.

A publication adversary then found a real failure in a2507a017eab076a99d01271c53406f03a9439f6:
another presenter can ACK an unbound scroll without advancing the source epoch.
A subsequent text edit reused ordinary bounding damage against the GPU's older
scroll image. Rejecting the sparse token alone was insufficient: the fallback
itself needed exact image authority. Source state and rendered-image identity are
independent versions, just as a BBTree mutation can invalidate a gathered destination
without making its key meaningless. This is a concrete invalidation requirement,
not evidence for an async runtime speedup.

AUTHORITY.md registers the prerequisite before correction. Runtime's existing
acknowledged sequence is made available to all native configurations; native image
reuse uses the exact window/token identity, and the redundant source-epoch stamp
is removed. Ordinary X11 already retained that sequence for accessibility; minimal
native configurations must charge the added field. Corrected 2c49fa9de6 passed
stale-scroll and coalesced pixel witnesses before a later fixture deliberately
poisoned its owner by using NaN literal width. cee7b76d00 changes only that fixture
to the existing recoverable NaN radius admission error. Full qualification is
pending. The original control is independently challenged before the same fix;
future timing comparisons must all contain the correctness prerequisite.
