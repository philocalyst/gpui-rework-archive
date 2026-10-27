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

The earlier Question-source-set prototype passed its initial semantic gates; its
completed performance rejection and follow-up formulations are recorded below.


## Completed Question cohort trial and next isolated formulations

The by-value source-set candidate is complete and rejected on its fixed CPU
controls. Dossier 394e246b9b on local/question-source-set preserves 240 fresh
processes / 960000 complete settled operations. Unrelated two/four-field
1000-label ratios are .05558/.06011 (18.0x/16.6x), but dependent two-field 25-label
and owner-dependent four-field 1000-label medians are 1.05394/1.05134. Narrow
numerical failures and broad ranges are not waived. All exact final pixels and
worker counts pass; 718 default and 791 X11 GPUI cases/doctests, strict Clippy,
all four source positions, a diamond, the missing-member mutant and six actual
native scripts qualify correctness. This count excludes unchanged Canvas tests;
the earlier 1049 text-batch combined count included Canvas and is a different scope.

The four-field array grows four linked delivery routines 6705→7429 bytes.
local/question-source-borrowed tests a concrete representation change: borrow
that set for the one synchronous refresh instead of copying it through the graph.
No owner reference enters an external task. Footprint is a hypothesis for a new
comparison, not an established causal explanation of the two losing controls.

A separate local/sparse-text-batch candidate starts from the qualified text-only
batch base. It keeps ordinary layout and requires zero changed layout writes,
then validates every replacement run before changing canonical commands. Mask
use counts and tile references must be admitted collectively: two independently
legal replacements can remove a resource's last uses together. P text/geometry
still changes only on ACK; duplicate slots, later failure, new resources, changed
run lengths and unproven geometry keep conservative behavior. Its new safe
Canvas transaction and public rollback/oracle tests are frozen at 6a2cea6a5c;
no performance result yet.

Archive follow-up: PLAN.md proposes chunked paint order and counted B+ sequences,
but no qualified implementation was found in the inspected clean-room sources.
The identity-order and identity-order-dense dossiers are held: lookup/memory wins
came with mount, inspector and teardown regressions. They are not evidence to
replace painter-order storage wholesale. Variable-length glyph spans and resource
lifetime are promising separate questions after the bounded batch is measured.


## Completed borrowed and atomic sparse-batch formulations

The borrowed source cohort is also rejected: baseline primary ratios
.05313/.05741, but zero-label two-field dependent control 1.07654, paired range
.9508–1.1731. Complete dossier 6553d9a6df. Its 240-process main comparison and
24-process owned comparison both preserve exact outputs and task counts;
48 allocation probes retain zero warm bytes, 719 default / 792 X11 GPUI tests
and six actual native scripts pass. The owned comparison is separate: dependent
25-label median 1.00108, owner1000 .97194, primary unrelated .98759/.99809.
There is little evidence of a general borrowing improvement. Control failures
moving between trials do not establish a cache or ABI cause.

Atomic sparse text batches also reject their numerical gate: 210 processes,
primary .06928/.12344 but owner25 two-field 1.05617. Complete dossier 2d55c3dff1.
With 1000 labels, two-field requested bytes fall 341828→5688, four-field
343672→10628, with zero warm retention. Exact public pixels/geometry, late
rejection atomicity mutant, 975 default / 1048 X11 GPUI+Canvas tests, strict
Clippy and six actual native scripts qualify the exercised semantics. The boxed
patch-slice owner adds 8 persistent bytes. Shipping code adds 280 lines.

Artifact guards caught Cargo test replacing convenience example paths with
other feature builds before timing. Both dossiers preserve the discovery and
bind direct build/out executables from explicit build-only JSON receipts.
Excluded native-feature sparse allocation probes are retained separately.
Independent dossier verifiers recompute both failed numerical verdicts.

The next isolated trial, local/sparse-text-outline at a476ef4330, adds only
#[inline(never)] to try_sparse_text_batch. The prior compiler inlined that helper
into try_sparse_text, growing it 2078→5337 B and stack reservation 344→584 B.
This is a concrete code-layout hypothesis, not a causal conclusion from the
narrow control loss. Its full matrix and separate inline comparison are fixed
before measurement. No storage, eligibility or API change is mixed into it.

The native GPU path still rebuilds and uploads the entire packet after a text
change. Future transfer of validated text-run changes into GPU record/tile
updates is a separate hypothesis. It requires exact scene-token matching,
painter-order addresses, tile incidence, raster leases and failed-preparation
replay authority. CPU sparse recording is not sparse GPU packet preparation.

## Further primary research: batching without application API changes

[CoroBase (VLDB 2021)](https://vldb.org/pvldb/vol14/p431-he.pdf), sections 1,
4.3–4.4 and 5.9–5.10, studies inter-transaction coroutine batching while retaining
single-operation application interfaces. Its two-level structure flattens engine
operations while keeping application transactions separate. Fully nested frames
add switching and allocation costs; excessive flattening can enlarge instruction
footprints. Its evaluation uses a custom frame allocator, and larger batches can
increase transaction latency. The paper also changes reclamation boundaries and
transaction-local scratch ownership when several transactions share one thread.
Those details prohibit treating an existing thread-local buffer as lane-local.

[Psaropoulos et al. (VLDB 2017)](https://vldb.org/pvldb/vol11/p230-psaropoulos.pdf),
sections 1–2, distinguishes static interleaving for uniform lookup control flow
from dynamic interleaving when paths diverge. Its coroutine formulation seeks
maintainable code comparable to hand-written AMAC, not a universal claim that
coroutines beat tight loops.

GPUI inference: existing frozen update batches and immutable scene borrows are
plausible boundaries for internal gather work. Arbitrary mutable callbacks remain
ordered, external tasks require real wakes, and input latency/teardown remain
first-class gates. Neither database result qualifies GPUI's scheduler or supplies
Solid's automatic coherent publication semantics. The locally tested loop/Future
and source-cohort results above decide their actual usefulness here.


## Completed outline-only qualification

The one-annotation follow-up is complete at local/sparse-text-outline,
5b670209df18941f8604bea2ee2d2bfe3597da78. Its single-run routine shrinks from
5337 to 2133 bytes, stack reservation 584 to 312 bytes; the separate batch is
3181/520 bytes. Total ELF grows 208 bytes versus inline; shipping inventory
36942 lines. No semantic/storage/API change was made.

All 975 default / 1048 X11 GPUI+Canvas tests, strict Clippy, six actual native
scripts and 42 allocation probes pass. The unchanged transaction's negative
witness is explicitly inherited, not rerun. Build-only default+simd executables
were pinned before test feature-unification could overwrite convenience aliases.
Full input and ELF guards pass around 210 baseline and 24 mechanism processes.

The fixed numerical verdict is again rejection. Primary two/four-field
1000-label ratios .065991/.124281 are 15.2x/8.0x improvements, but the four-field
owner-dependent control is 1.050214, above 1.05. Keep its .90079–1.05801 paired
range and do not round it into a pass. Separately against inline, the 25-label
two-field owner ratio is 1.04803, 1000-label single exact .98045 and two/four
exact .98801/.97327. A smaller routine did not establish a general control win.

The next useful architectural boundary is the native GPU packet: sparse CPU
text publication still validates/rebuilds/uploads every record and tile index.
A bounded gather/validate/commit there must also preserve atlas leases, exact
predecessor token, painter order and old/new tile membership. Updating glyph
words alone is insufficient. Capacity-indexed tile lists are a separate possible
experiment; no such implementation or performance claim exists yet. Do not
combine it with unrelated shader experiments or silently adopt rejected slices.


## GPU text transaction: completed, rejected qualification

Preregistration 0deed98cc8 on local/gpu-text-packet; common fixture/full-preparation
control frozen at 64523d173a. The new low-level path gathers at most four compact
masked groups, checks atlas entries and unchanged transform/clip/color/correction
authority, replaces glyph words, removes their old CSR references and inserts
new memberships after existing opaque cutoffs in painter order. It still scans,
repacks and potentially uploads the complete tile/index arrays. This is not an
O(changed) whole-frame algorithm. Plain Renderer keeps its existing ownership;
RetainedRenderer additionally owns a positional run directory, fully charged.

The first candidate a3495f600d correctly rejected but was overly restrictive:
its common-word comparison also froze numerical error bounds derived from glyph
positions. Two new tests failed ChangedCommon. Corrected GPU source 11ad2fff8f
recomputes those two bounds like full preparation while retaining every other
common-word check. The unchanged exact tests, complete GPU suite (75) and strict
Clippy pass; the omitted-new-membership mutant cca9f74c6d fails the exact image
oracle. All generated/embedded WGSL bytes match the full control. No shader edit.

Correctness-only preflight: 0-label/two-field, 1000-label/four-field, 25-label/
735-character stream and full-scene control. Every initial/final image matches
fresh reconstruction and the control exactly. Candidate packet reuse is 60/60
for each sparse case, including the stream, and 0/60 for full preparation. Those
durations are excluded from performance qualification. The first native bridge
source 4ee1af8db2 retains an exact predecessor token and passes a private bounded
transition through with_paint_scene; public application interfaces are unchanged.
Completed dossier de8e4f6fea at
`/home/user/gpui-gpu-text-packet-lab/reactivity/evidence/gpu-text-packet`.
The verifier reconstructs 210 measured processes, 12600 measured updates, 42
allocation processes, exact initial/final images and the fixed failed verdict.
Default GPUI+Canvas975, native1048 and six actual native scripts pass. The native
GPU Todo script includes predecessor/ACK/coalescing/failed-newer/new-mask tests.

Large two/four-field completion ratios .690910/.547986 pass the .8 primary gate;
tiny full two/four controls1.080780/1.076605 fail1.05. Every tiny two-field pair is
above1.05. Stream gains only2–4%. Do not explain away these failures as noise.
RetainedRenderer grows24 B, native TextResources16 B, map16 KiB at1000 labels.
Sparse two-field requests drop122→97 but requested bytes rise17225→80185;
complete-CSR scratch remains a cost. Shipping code37367(+425), ELF+34360 B,
unchanged shader; local patch stack reservation856 B, not a total stack bound.

A follow-up may compare old/new glyph words and preserve unchanged memberships,
then derive dirty tiles from old surviving plus new admitted references. Derived
common error-bound changes conservatively dirty the whole affected run. Multiple
scissored tile spans can reuse the unchanged shader and one presentation copy.
This is an unimplemented hypothesis, not an inferred speedup or an adoption of
the rejected base. It must charge comparisons, scratch, commands and full controls,
and preserve exact painter order, sample arithmetic, old/new support and fallback.
