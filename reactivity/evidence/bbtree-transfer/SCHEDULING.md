# Display-tree memory lanes and async dependencies

This is an architectural hypothesis under experiment, not an adopted design.
Primary sources: BBTree `1b0201087102f81189da0c4cd5054a91c8d97d62`, especially
`design/12-batch-api.md` and `bbtree/src/tree/batch.rs`; Solid site deployed source
`f45bd3655aa55261ac7f09226c05900b79af95c0`,
[`async-solid-fetch-high-block-low.mdx`](https://github.com/solidjs/solid-site/blob/f45bd3655aa55261ac7f09226c05900b79af95c0/src/pages/Articles/async-solid-fetch-high-block-low.mdx).
The live Solid page returned a browser challenge; the complete deployed source
was read. Main branch e7b40ef lacks this article, so citing main would be wrong.

## Common structure, different readiness

Both ideas separate initiating work from consuming its result. An operation
holds a small continuation and dependency identity. Independent operations can
advance while one waits. Public UI code need not expose scheduling machinery.
But a memory hint never proves data ready and does not generate a wake. A task
may stay pending indefinitely. Therefore distinguish three outcomes:

- `Ready(result)`: validated result can enter the ordered commit stage.
- `MemoryYield(next address)`: immutable synchronous batch can poll again after
  sibling lanes, hiding some load latency. The CPU still enforces the load.
- `Blocked(request stamp)`: park until actual completion/wake; never busy-poll
  using BBTree's noop waker. Supersession/cancellation returns physical credit
  only after actual worker teardown, as current QuestionTask requires.

The first prototype uses an explicit Unpin Future per independent ancestor walk
inside LayoutTree's real pending-root classification. A live bitset bounds the
batch. No allocations, vtables or window tasks are introduced by the executor.
Scalar/level-wise/no-hint variants distinguish scheduling benefit from less
capability validation. A topology proof is a competing algorithm. These parent
chains have the same dependency shape as B-tree descent, but are not ordered
map updates and do not establish equivalence of the entire display engine.

## Lowering updates to schedulable operations

A plausible next stage lowers existing typed binding destinations to internal
operations: resolve live identity/revision; gather style/geometry/resource
inputs; produce a candidate patch; validate dependencies; commit in declared
order. Hot routing fields should be compact and separate from cold payloads.
Retain full identity equality and generation/window namespaces. Routing summaries
can reject candidates cheaply; they cannot grant semantic authority on a tie.

Read-only gathers can interleave under a shared borrow. Conflicting writes to a
node/style/layout ancestor cannot simply run as independent lanes. Gather first,
commit serially or to disjoint owned outputs after proving independence. Real
layout dependencies (intrinsic measurement, sibling distribution, clipping,
stacking and backdrop) define barriers. A whole paint-order scan is already
contiguous and may gain nothing from futures. Gates must charge queueing,
validation, maintained indexes, cold construction and retained storage.

## How Solid's read model maps to existing GPUI

Solid separates async creation, derived reads and the visible blocking boundary.
Its article describes lazy prop reads, dependencies rather than component
nesting controlling request order, and coherent old values during revalidation.
It uses graph-caught NotReadyError for pure reactive derivations. Do not replay
arbitrary Rust View callbacks or effectful tasks on an equivalent exception.

GPUI already has declared Source/Reader dependency packs, owned frozen worker
inputs, request stamps, pending/fault/ready availability and actual teardown
credit. `reader/inputs.rs` refuses to freeze fresh downstream work from a stale
upstream payload. `question_inputs.rs::two_reader_inputs_settle_before_their_dependent_freezes_once`
and `question_futures.rs` exercise join readiness, stale A-B-A results and
never-waking task cancellation. Those are reusable foundations.

There is still a semantic gap: an acknowledged geometric scene is coherent,
but GPUI does not thereby implement Solid's automatic transition of a complete
reactive dependency closure. A new selection source could be displayed beside
an old Reader value. Matching Solid requires defining a ready commit group:
which source/derived sinks must advance together, and which independent siblings
may publish while it is blocked. An inferred group is only sound where the
existing typed dependency graph is complete; coarse View code needs a conservative
boundary or a small explicit API. Never infer independence from component nesting.

For display publication, retain old acknowledged P and its immutable resources
while a newer group gathers. A ready group may patch only if layout/paint/input/
IME/accessibility authority can advance consistently. Otherwise widen the barrier
to the affected ancestor closure. Failed newer candidates and late old task
completions must not revoke an eligible older candidate or publish stale data.
Input processing continues against acknowledged P; no mutable window borrow
crosses external await. Externally visible mutations remain explicit effects,
not speculative computations that may be retried.

## Next falsifiable stages

1. Complete the six-way actual-core parent-chain experiment and exact lifecycle
   tests/Miri/mutant. No claim of cache hits without available hardware counters;
   this VM denies perf. Inspect prefetch instructions and linked code.
2. If it wins complete operations, identify a second measured gather chain
   (resource/identity/geometry) and apply the same lane vocabulary. Compare to
   routing-layout improvement and eliminating redundant traversals.
3. Exercise an async task diamond through ordinary Questions: independent tasks
   start from the same input, the join waits only for its actual inputs, old P
   stays usable, superseded completions never appear, and independent input/UI
   updates keep their latency. First establish current behavior; preregister any
   commit-group semantic/API addition separately.
4. Qualify combined changes on complete GPUI/ZGX workloads with matched profiles,
   visual/feature equivalence and the required physical hardware classes.
