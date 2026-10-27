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

## Earlier research and current experiment receipts

The repo already studied Solid/Ripple and integrated its typed Future adapter;
see `reactivity/docs/async-graph-luna.md` and `future-questions.md`. The previously
unreadable article is now resolved through official deploy-prod source. Keep
those earlier ownership/cancellation findings and real Library consumer gates.
`QUESTION_INPUTS.md` explicitly identifies the current static earlier-only DAG
and warns that resolving Reader keys scans the earlier lane chain. Large graph
routing is another measurable target, not a reason to replace small typed lanes
with an unbounded executor or duplicate readiness cache.

The older [AMAC paper](https://www.vldb.org/pvldb/vol9/p252-kocberber.pdf) explains
why independent continuations help irregular pointer chains and why refilling
completed lanes matters. It is a direct research antecedent for this direction.
The current GPUI trial uses fixed batches, not AMAC's refill strategy; mixed-depth
measurements therefore do not establish that we have tested a fully occupied
adaptive executor. That remains a distinct hypothesis with result-order and
bounded-storage costs to charge.

Current local dossiers: tree-memory-lanes (first six-way experiment, rejected
on contiguous overhead); tree-parent-columns (deep gains, rejected outlined
scalar fallback); tree-admitted-walk (one-time admission/inlining qualification
complete, unadopted after longer no-regression gates). Every variant is local and separate. Full-application composition,
input latency and hardware gates still decide whether any kernel is worth keeping.

Ordinary Runtime currently builds a single LayoutTree root. Deep multi-root
filter gains therefore do not establish an ordinary frame gain. The next
measured stage targets actual delivery: deliver_ready repeatedly resolves a
numeric cursor through a static nested lane chain. A bounded structural sweep
may remove repeated routing while retaining exact FIFO, frozen-before-callback
batches, rotating fairness, backlog charging and physical cancellation credit.
This is a new candidate, not a claim that task readiness equals memory readiness.

## Actual publication experiment after the routing trials

The structural delivery sweep is rejected. On the measured release binary,
indexed staging already uses jump-table dispatch; replacing it doubled the
64-lane routing routine (4840→9596 bytes) without meeting the complete-operation
gate. Complete dossier: local/delivery-sweep, dbd7dbd40b. This is a concrete
counterexample to inferring runtime pointer-chain cost from generic Rust source.

The next candidate preserves existing typed destination authority rather than
adding a lookup structure. Lane::apply formerly collapsed two distinct source
identities to an unknown edit, forcing owner description. SourceEdits now keeps
up to four identities in transient storage. The first certificate admits only
disjoint visual-text sinks, no owner dependence, inspector, virtual list or
Question plan. Existing callback order and one normal layout/paint/ACK boundary
remain. Opaque edits, overflow and unproven destinations retain the old path.
An owner-dependency mutant leaves visibly stale derived text and is caught.

The first 210-process public-operation comparison met numerical gates: with
1000 static labels, two-field CPU ratio .7298 (all pairs .724–.762), four-field
.7448 (.702–.766). All one-field/fallback medians <=1.05, but some individual
controls remain noisy. Four-field allocation requests 1194→120, requested warm
bytes 1322409→343672, zero retained delta; measured Win wrapper unchanged.
Full default GPUI tests (711), strict Clippy, exact fresh-window pixel oracles
and the mutant pass/fail as intended. The composed suite passes 1049 tests and
six actual X11 scripts cover source/remote delivery, producer shutdown, Question
wake, Future cancellation and Todo interaction. Complete dossier 1830d9d54f.
Source/evidence at /home/user/gpui-source-batch-lab, branch
local/source-batch-publication. This is not a competitor or hardware victory.

A separate next hypothesis is to preserve the same complete changed-source set
when refreshing Questions. Currently any multi-field batch uses coarse refresh,
which can cancel unrelated work. A single earlier-first graph pass can resolve
all final input versions under one owner borrow, skip unrelated declarations,
and still reject stale A-B-A completions. Only after that should the text batch
certificate be extended to windows whose Question readiness/projections did not
change. Avoid refreshing separately per field if it manufactures redundant
intermediate request stamps in dependent joins. Unknown callbacks keep coarse
refresh. This proposal is not implemented by the current text-only trial and
does not supply Solid's automatic multi-output transition semantics.

The separate Question-source-set prototype is now frozen and its first 54
targeted tests plus strict Clippy pass. It preserves unrelated Ready questions,
freezes dependent tuples once from final inputs, and rejects stale A-B-A results.
A multi-source diamond, forgetting-one-member mutant and equal settled-endpoint
cost fixture are being qualified independently. No performance verdict yet.
