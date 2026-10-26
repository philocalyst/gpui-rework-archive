# GPUI damage rework: collected engineering brief

**Collection date:** 2026-10-26 UTC. **Status:** experimental repository checkpoint, not a finished or performance-qualified release. **Selected code-only source:** `3c5cc3330cf6e6878489a55f1ab7218731a379af`.

This brief preserves design, implementation state, measured evidence, failures, weaknesses, and the research backlog. Component chapters have explicit evidence cutoffs. New host results belong in a dated addendum and the host manifest. The archival ref index distinguishes alternatives from the selected source.

## Normative design comes first

All127 user-designated original design files are preserved unchanged. Start with the [original design README](../../../designs/reactivity/README.md), [final constitution](../../../designs/reactivity/final/00-model.md), [ladder](../../../designs/reactivity/07-the-ladder.md), and [structural consolidation review](../../../designs/reactivity/11-consolidations.md). The original README gives the consolidated final statutes precedence over historical passes. **One semantic model, proofs at boundaries, no third language, nothing ambient** remains the criterion; this status brief does not silently amend it.

Read the [design-to-implementation crosswalk and complete127-file index](DESIGN-CROSSWALK.md). It explicitly distinguishes preserved originals from a still-incomplete conformance audit, including the nightly/stable and Source-algebra gaps.

## Contents
1. [Chapter 1: Executive overview](#chapter-1)
2. [Chapter 2: Core damage model and solver](#chapter-2)
3. [Chapter 3: Rendering, retained ownership and parallel execution](#chapter-3)
4. [Chapter 4: Correctness, authority and completion](#chapter-4)
5. [Chapter 5: Text ownership and accounting](#chapter-5)
6. [Chapter 6: Measured evidence and operational lessons](#chapter-6)
7. [Chapter 7: Realistic benchmarking and research atlas](#chapter-7)

## Evidence navigation

- [Historical scene preparation](benchmarks/scene-costs.png), [full CPU output](benchmarks/cpu-output-costs.png), and [raster phase share](benchmarks/raster-phase-share.png). These are **historical baseline-only** graphs, not current unified-candidate gains.
- [Historical summary data](benchmarks/historical-interaction-summary.json), [new comparison acceptance contract](benchmarks/ACCEPTANCE.md), and [original workload contract](benchmarks/WORKLOAD-CONTRACT.md).
- [Source refs](SOURCE-REFS.json), [detached snapshots](DETACHED-SOURCE-REFS.json), and [source-worktree inventory](WORKTREE-SOURCE-INVENTORY.json). Listed refs are not qualification claims.
- [Actual target-consumer obligations](supporting/TARGET-RECEIPT-CONSUMER-CONTRACT.md). This is a contract, not an implementation claim.

Historical `gui-comparison/…` paths and transport packet names in component provenance identify the original experiment workspace. They are not promises that every raw log or transport archive is checked into this documentation directory. Source revisions are preserved by the archival refs; selected portable evidence is linked above. Build caches, executable bulk and credentials are excluded.

<a id="chapter-1"></a>

## Chapter 1: Executive overview

## GPUI rework: engineering checkpoint and forward brief

**Checkpoint date:** 2026-10-26 UTC. This is a preservation and review checkpoint, not a release certification.

### Read this first

The project has substantial working code, several independently qualified improvements, and a growing common damage model. It does **not** yet have a fully qualified end-to-end implementation of the desired retained, intrinsically damage-tracked architecture. In particular, a clean logical change receipt is not by itself proof that the correct physical target pixels have been repaired. The actual backend consumer, snapshot ownership, pending damage across skipped output, and target completion must be qualified together with the frontend producer.

The correct interpretation of this checkpoint is:

- Preserve the implementation, original controls, failed attempts, corrected descendants, and research rather than lose useful work in transient worktrees.
- Make the current integrated source inspectable without claiming that tests from separate predecessors automatically qualify it.
- Record what has been measured, which measurements were rejected, and which attractive conclusions remain hypotheses.
- Give the next engineer a concrete path from the checkpoint to a finished, measured system.

There is no defensible overall completion percentage or hours-to-finish estimate. The remaining work includes architectural integration, not merely formatting or a final test run. The completion gates below are more useful than an invented date.

### The architectural objective

Ordinary model mutations should produce typed, identity-stable change facts. Dependencies should determine the necessary derived work. A successful canonical publication should bind the exact immutable scene and its resources to an accepted revision. A backend should consume that accepted stream, expand old and new physical support while both are available, and repair its own target relative to the last output it actually completed.

An ordinary popover should not be a privileged optimization case. Its insertion, removal, movement, clipping, resource changes, overlap and scrolling should be explained by the same model as any other subtree. A successful implementation must also handle unglamorous cases: removal exposes earlier contributors; translucent objects need ordered replay; a resize can create a new scene without changing source state; a failed newer attempt must not destroy an older eligible acknowledgement; metadata can change without changing the public draw token; skipped intermediate output still accumulates physical damage.

The intended direction is fewer traversals, smaller retained state, bounded staging, and parallel execution of truly independent work. It is not a growing collection of named fast paths or a second shadow graph in each backend.

### Current state in one page

#### What is real

The work includes a common identity/facet/dependency/publication vocabulary; bounded transactional change preparation; exact Canvas publication binding; checked material mutation; retained text/resource experiments; an actual host executor and catalog implementation; and source-level integration of solver output evidence, style classification and independent canonical revisions. The component chapters identify their exact source pins and limitations.

Actual host checks have qualified important predecessors and individual changes. Examples include native correctness fixtures, coherent default smoke tests, retained-text compilation and a named ownership test, stable record/action compatibility controls, and the tile-CSR pass removal across release profiles with exact output/stat comparisons and mutation controls. The CSR change also removes the intended copy call in linked release code without increasing that function's frame or allocation sites. None of this establishes a global application speedup.

#### What is not yet established

- The final combined source has not inherited qualification merely by combining reviewed patches.
- The actual target/index consumer needs a complete producer-to-output proof, including skipped scene revisions and failed physical writes.
- Full presentation and command construction remain important sources of broad work; structural ownership extraction is not yet general immutable-group reuse.
- Resource accounting covers explicitly registered subsets. It is not a bound on all application memory, allocator overhead, native resources or GPU residency.
- Stable source-type compatibility has required explicit reusable registrations/adapters. Native syntax parity must be stated precisely rather than inferred from successful application migrations.
- Current unified before/after realistic timing graphs are not available at this checkpoint.

### How to interpret evidence

Each result must carry a source identity, build-input identity, feature/profile contract, executable identity, workload identity and outcome. There are different categories of evidence:

1. **Design or source inspection:** a plausible mechanism, with no execution claim.
2. **Model check:** an abstract arithmetic or partition model, not a Rust or native run.
3. **Compilation:** a real compiler accepted a particular source/configuration; this does not execute its behavior.
4. **Focused runtime tests:** named tests ran and passed; unrelated suites remain open.
5. **Cross-output correctness:** full images, geometry, semantic outputs or reference results match under a declared workload.
6. **Mechanism falsification:** a bounded intentional defect fails the intended assertion, and the restored implementation passes.
7. **Performance qualification:** matched, reproducible measurements on qualified outputs, with adverse cases and variability retained.

A zero-selected test invocation is not a pass. A successful library check is not a test-suite result. A source-level allocation estimate is not RSS. A lower instruction count is not measured latency. Scheduled pixels and upload bytes are work counters, not GPU frame time. Software graphics and headless CPU output are not hardware presentation latency.

### Realistic benchmark evidence

The preserved six-scenario historical baseline covers source-driven hover, typed paint hover, layout-changing hover, window resize, geometry animation, and popover plus virtual scrolling. The original fixture and pinned Inter font are identified in the benchmarking chapter. These plots are useful for locating costs, but they are **not** before/after measurements of the current unified candidate.

The reported full-CPU phase-sum medians in that historical campaign range from about 6.53 ms to 15.92 ms per workload operation. Popover plus virtual scroll is the largest of those measurements. The sum includes the instrumented phases of that harness, not outer event-to-display latency. Native GPU performance is not established by these charts.

The next comparison must use fresh matched builds of the actual control and candidate, preserve the original operation and acknowledgement sequence, compare complete outputs, and disclose feature/API adaptations. In particular, enabling a retained-text feature does not exercise scoped text reuse if the fixture still mounts an unaccounted window. Changing its font to make a constructor work would invalidate the comparison. The benchmark chapter explains the required same-font scoped API adaptation and the separate feature-off control.

### Why progress has not matched the apparent parallelism

Six cloud work streams have not meant six independent implementation streams. Three have concentrated on implementation and three on adversarial review. Additional host work has handled actual compilers, native fixtures, stable compatibility and performance evidence. Review has caught real defects, but the project has also accumulated too many independently reasonable checkpoints before a single combined runtime path was exercised.

Concrete friction included compiler-less source work, host toolchain restoration and compatibility migration, source/feature drift across worktrees, intentionally conservative resource guards, model-capacity interruption, native launch limits, and source preparation taking too long before a known correction was compiled. These explain delays; they do not justify claiming uninterrupted utilization or finished integration.

The corrective direction is to stop adding independent mechanisms, consolidate one coherent candidate, keep exact controls and failed evidence, and make host compilation and realistic workload results the critical path. Documentation and artifact preparation should enable that path, not repeatedly delay it.

### Completion gates

#### Gate A: one coherent source and compatible public surface

Freeze one candidate containing the reviewed producer, solver, rendering, text and host adaptations. Resolve conflicts explicitly. Verify ordinary builds, relevant feature combinations, real application ports, and public type/lifetime constraints. Preserve a clear inventory of deliberately excluded experiments.

#### Gate B: complete damage ownership and publication

Qualify direct, mapped and coarse mutations; actual layout/answer evidence; graph closure; scene publication; metadata-only canonical edges; resources; and old/new identity. Failed or incomplete evidence must conservatively invalidate rather than manufacture a selective proof. Preserve old eligible public acknowledgements and exact revision-domain separation.

#### Gate C: actual backend consumption

Use the existing host backend implementation, not a parallel test-only implementation. Verify target storage identity, generation, extent and configuration; contiguous accepted revisions; old/new support; pending unions; ordered contributor replay; prewrite versus partial-write failures; and real completion/copy/fence boundaries. Include the metadata-between-two-unrendered-paints case.

#### Gate D: broad work and memory reduction

Measure graph visits, solver answers, descriptions, command emission, bin/projection work, allocation requests, retained/staged/retired bytes and target work independently. Broad immutable-scene rebuilding must not be concealed by reporting only a faster leaf kernel. Any new indirection, weak-owner envelope, root record or cache must be included in the cost model.

#### Gate E: realistic comparison

Run the unchanged six-scenario matrix and separately qualified text/native workloads against matched controls. Retain warm/cold-history distinctions, process-level variability, tails, peak memory and adverse cases. Publish per-scenario graphs even when a change loses. Reject or explicitly label inconclusive candidates.

#### Gate F: repository handoff

Push a non-forced, reviewable checkpoint to the verified project remote. Keep the brief, source inventory, reproducible test/benchmark commands, concise results and meaningful historical alternatives. Exclude credentials, environment dumps, build caches and unneeded binaries. Verify the remote commit rather than treating a local commit or an accepted push request as publication proof.

### How to use the rest of this brief

The component chapters are deliberately detailed. Each should be read as a status-and-research record, not a claim that every experiment should become production code. The highest-value next step is whichever closes the current end-to-end correctness or measurement gap. Prefer an experiment that can remove an entire retained representation or traversal, but require a concrete ownership proof and an adverse-case measurement before adopting it.

The untried-experiment atlas is extensive, not a promise of exhaustive knowledge of all possible algorithms. Items are marked according to what was actually attempted, merely inspected, rejected, or left as a hypothesis. Preserve those distinctions when extending the project.

### Final collection caveat: late full promotion

The zero-entry hard-full preparation result is deliberately narrower than “all full scenes retain no copied change entries.” It applies when `Journal::prepare` already knows the batch is hard-full. A later `PreparedChanges::with_closed` promotion, for example after a serial or coverage failure, can retain an already prepared vector and its capacity. This remains a source-level memory cleanup opportunity, not an adopted or measured optimization. The frozen code is not changed merely to make the brief's result cleaner.

### Latest host integration result at collection time

The host's coherent renderer merge compiled in release and passed nine focused gates, but its existing Canvas-size assertion failed: 864 bytes observed versus the legacy 464-byte expectation. The declared binding accounts for 400 added bytes. Its reported first-raster allocation ledger remained two requests / 76 bytes, with Scratch 56, Stats 96 and Frame 88. This is a real retained-header cost, not a memory improvement; the failure is preserved instead of silently increasing a budget. It is also not proof that the new target consumer exists: the host explicitly reported that no new target-consumer production code had been written in that merge.

Separately, the host's selective-output descendant passed 29 selected controls, and the omitted-offset mutation failed the intended assertion after cold-output checks; a fresh reverse-restored source passed. These qualify that isolated descendant's stated gates, not the complete collected tree. Exact source identities and evidence boundaries are in the measured-evidence chapter.

<a id="chapter-2"></a>

## Chapter 2: Core damage model and solver

## Core damage model, solver and canonical publication checkpoint

**Date:** 2026-10-26. **Status:** collected experimental source, not a qualified
shipping composition. This chapter deliberately separates implemented machinery,
source review, actual host results, and work still missing. It is not a claim of
an order-of-magnitude end-to-end improvement.

The code-only composition described here is
`3c5cc3330cf6e6878489a55f1ab7218731a379af`, branch
`lane1-coherent-damage`, worktree `coherent-damage-source`. A later documentation
commit may contain this chapter without changing that code. No cloud compiler,
formatter, benchmark or native gate ran for this composition. The host-owned
stable SourceValue adaptation is a separate overlay: this chapter neither
contains its restricted inputs nor silently substitutes an authored approximation.

### 1. What is actually collected

The composition combines the previously separated retained-layout and multi-slot
paint work with the common dependency model, actual solver observations,
canonical metadata publication, recorded Canvas ownership, and scoped text
resource work. It is one source tree, not an assertion that independent passing
branches qualified their combination.

| Layer | Included authored source / selected bodies |
|---|---|
| Corrected first coherent assembly | `11d4bb3929b00255ba566c7411dd7613163f3308` |
| Solver scheduling cut | `21b52e1defce29dc0b4db3af4acd846468069a5a` |
| Bounded actual layout writes | `dc7fa92d957faa8f659d4ba3be3b633261510141` |
| Exact replay/output closure | `b659df22cad567c6c5a35d655a49ca824072f5f7`, rebased as `e061a85` |
| Layout input/output phase split | `d34f8890af275adeff1978ccfee5e2ee4e47addb` |
| Callback lifetime and fixture imports | shipped-lineage `c519dca633790ac7678f32dfaba5c923031ee197` and `76301eb99b733304f33d851ff20936e0dd174c1f`; equivalent selective-lineage fixes included |
| Observation compatibility | `b6d051278c39d33b97655dec00e3f4f93ea92fbd` and test `3236bed0e2f39fe5a79ce5a6059013a3deaabaab` |
| Positive non-graphical schema | `4a5ffa8df5d889beba917f8369d02df4fc87d335` |
| Canonical metadata C integration | `c99816d53578cb2c34cd1e49426b20fc8f5fb03a` |
| Exact style classification | `016f603121191e440a90d1790441f24b887bab4a`, composed as `14faa95` |
| Recorded renderer / compact material ownership / strict transaction | selected pre-R4 bodies from `bf52c3682d8e5bd2fc0ef3c5cb388a312d668ba6`, preserving the corrected hard-full publication test |
| Optional text ownership and retirement | `13f383c10c215ea18d441fb7ef6036ce4b929644` |
| Shared source capture | `cf6e8fff5e90282729ef8acedfb587da94009f8b` |
| Explicit font + resource constructor | `4c334a37f527394b11aa50f969ade6c674d68a14`, composed as `3c5cc33` |

The renderer integration first collected the later `14e3e6e` geometry-extraction
bodies as `a500da5`. That intermediate commit is preserved. The final composition
explicitly restores the pre-R4 storage interfaces in `3ea5cf9`: the later
geometry extraction requires consumer adapters that are not present in this
cloud tree. This is a visible deferral, not an assertion that the two storage
interfaces are interchangeable. Renderer, text and correctness chapters describe
those alternatives in more detail.

The source body inventory accompanies this chapter. It is a guard over authored
bytes, not proof of the executable that a host eventually runs.

### 2. The authority model

Several identities must not be conflated:

* **Logical source epoch S** describes admitted model operations. An operation
  may retain a logical prefix even when preparing a complete candidate fails.
* **Canonical revision C** names an accepted immutable Canvas/metadata cohort.
  It advances independently of S. Resize can publish new C at unchanged S.
* **Public PresentationToken** qualifies the eligible complete presentation
  sheet. It is not an arbitrary integer, storage address, or automatic raster
  completion certificate.
* **Acknowledged P** is the sheet whose presentation was actually acknowledged.
  Old eligible C may still be acknowledged after a newer logical operation fails.
* **Target surface generation and completed-image revision** belong to the
  actual output consumer. Neither S, C nor ACK alone proves what pixels are in a
  target, and an index update is not a completed image lease.
* **SiteId** is semantic owner + monotonic logical identity. It is not an ordinal,
  PaintSlot, layout arena slot, GPU address, or painter rank.
* **Layout NodeId** retains its full arena namespace and generation. A recycled
  physical slot does not recreate the old capability.
* **ResourceId** has its own private resource-domain identity. Numeric equality
  between independent counters never authorizes a cross-domain reference.

The common files are `crates/core/src/change.rs`,
`crates/gpui/src/runtime/changes.rs`, and the Canvas publication implementation.
The producer still has a trusted schema obligation: declaring a dependency graph
complete is not a type-system proof that every hidden model read was registered.
Private Window issuer ownership and a consumed publication ticket prevent a
caller from rebinding the actual Window's receipt to a different scene. They do
not make an arbitrary external producer's semantic declarations truthful.

#### Transactions, failures and ACK

The preparation guards retain pending facts when dropped. A successful canonical
publication consumes the matching prepared journal and issuer ticket and binds
them to the concrete Canvas. No reusable receipt can be applied to two unrelated
same-length scenes. Old Canvas resources remain owned independently of mutable
logical resource banks.

ACK is a separate operation. It must not clear pending damage from a failed newer
turn, replace the earliest old layout baseline, or promote a target image merely
because its sequence number looks current. Missing context rejects before
callbacks and input-session consumption; an admitted operation that later fails
may consume its event/session and retain a logical prefix. Those are different
transaction boundaries, not a promise of universal rollback.

A particularly important existing failure was repaired before adding sparse
indexes. A scroll-triggered description could take nodes/styles/handlers, then
fail the combined gradient resource budget, while its wrapper restored
`logical_valid=true`. That left empty logical nodes with a stale inverse. The
fix revokes validity immediately before destructive reconciliation. Early safe
errors can retain validity; late failures cannot. The natural regression uses
256 distinct 4096-stop gradients, about 67,121,152 bytes, exceeding the 64 MiB
budget. Old C also owns a small image and gradient so retaining pixels tests
actual resource leases, not only black rectangles. This is fail-closed recovery,
not a fully transactional logical reconciliation implementation.

### 3. Journal and dependency closure

The journal records generic facets: topology, layout constraints, text source and
policy, text width, paint, transform, clip, stacking, resource pixels/metrics,
hit, semantics, and primitive content. Coalescing keeps earliest old support and
latest new support. Source-side support may be **Pending**: geometry has not yet
been resolved. Pending is not the same as truly unbounded sampling and must not
irreversibly force full raster when an admitted old/new group resolver can later
establish exact support.

Hard reasons remain explicit: initial state, capacity, revision gap, unknown
or incomplete dependency information, unbounded effects, and scene-wide changes.
A hard-full journal keeps its pending internal facts for failed preparation and
repair, but exports no unusable partial change vector into the accepted Canvas.
Full is not permission for a slot-only update: a truncated history may have
omitted a layout fact, and repainting old geometry cannot repair that omission.

The dependency queue caps and deduplicates on enqueue, not only on pop. Partial
artifacts are not materialized when a hard reason already requires complete
preparation. Closure merge honors the smaller budget immediately, even if the
second closure contains only existing keys. Invalidated fields are private;
callers cannot clear a full reason or remove downstream artifacts and retain an
apparently genuine receipt.

A closed receipt binds the exact journal mutation serial and graph generations.
A late same-phase mutation still changes the serial. A graph version is a
separate domain + checked generation, so unchanged S or C alone cannot justify
reusing an old closure. A missing/exhausted after-graph is not equivalent to no
after-graph. Reclosure unions earlier full reasons; a later valid fact cannot
launder an earlier unknown mapping into a clean result.

OLD and NEW logical dependencies are both needed. Inserted sites are legitimately
absent on the old side, removed sites on the new side. Missing retained sites are
not legitimate absence. Earlier unconditional closure on both sides turned every
ordinary insertion/removal into unknown/full; the side-aware handling fixes that
without a popover exception. Group and tile relationships must likewise be
closed over both old and new memberships, including split/merge of a common
lowering group.

Owner-local resource read replacement is bounded and transactional. It stages
only changed reverse buckets, validates raw input size before sorting, reserves
commit capacity before C mutation, and retains accepted edges on failure. It does
not clone the full graph per text update. Stable ResourceIds survive C rebasing;
snapshot-local GroupIds cannot be carried blindly across generations. Lazy group
IDs must be derived from the current admitted catalog context, not stale fields
left in an old descriptor.

### 4. The solver is an existing incremental authority

The major correction was to stop duplicating Cephal's scheduler in an eager
bidirectional graph SCC. Cephal already visits dirty work deepest-first, replays
cached LayoutInput questions, and stops upward propagation when
`LayoutOutput::same_for_parent` reports unchanged answers. It distinguishes
unchanged, overflow-only and full changes. Baselines, collapsible margins,
out-of-flow state and visible overflow matter; a fixed parent width/height alone
is not a valid propagation boundary.

`LayoutTree::set_style` intentionally dirties the changed node and immediate
parent, because the parent reads some child style directly outside cached
answers. Cheap empty leaves redirect dirty marking to the parent. These guards
remain. The removed edges were the new graph's blanket child Layout → parent
Layout and parent Layout → child Layout/TextLayout edges, which premarked the
whole connected tree before the real scheduler could stop.

The first cut kept every solved-layout renderer receipt conservative/full. The
next cut observes what the solver actually does:

1. `Engine::set_unrounded_layout` already compares stored old/new layouts.
   The observer runs below speculation/equality guards, before overwrite, and
   receives the complete generational NodeId.
2. Comparable cached answers are observed at the scheduler's existing comparison
   seam, including overflow-only partial passes. No extra layout question is
   asked to discover a difference.
3. Replay provenance is exact node + full LayoutInput, including float bits.
   A recursive fresh child question is not authorized by its parent's replay.
4. Fresh computed/cheap questions, empty/evicted/context-bound/unstored histories,
   newly observed axes, hidden paths, root query changes, direct out-of-flow root
   work and initial-containing-block passes report incomplete evidence.
5. Incomplete, topology, configuration, mapping and capacity cases stay full.
   The first clean discriminator is a real same-metric image replacement with
   different pixels, comparable unchanged answers and cached unrelated peers.
   Resource type is not an admission predicate.

The two callback references have **independent lifetimes**. The original shared
lifetime was a real host compiler failure, not a theoretical concern. The narrow
correction changes no scheduling behavior.

#### Bounded old-layout evidence

The GPUI journal retains earliest old and latest new final Layout values for
changed full capabilities. It is not a persistent N-node layout or f64 transform
mirror. Its internal optional policy is 64 combined evidence cells, with a
compile-time upper bound of 16 KiB for key/value payload. BTree allocation and
headers are additional, as is one active stack-local question. Exact host size
and allocation measurements remain required.

Initial/full rebuild history is already unusable: it does not allocate new
records. Once structurally incomplete or overflowed, new identities are not accumulated
on repeated failed turns; existing earliest-old records are retained. An answer-
comparison gap independently forces full but may still retain useful final-layout
writes under the same combined budget. Successful C
resets the optional budget. ACK and failures do not. If repair rebuilds the arena,
the old capability record is diagnostic evidence and the history is explicitly
incomplete; it is not continuous reconstructable placement across the arena gap.

#### Input is not output

Removing the Layout SCC was insufficient while both `Facets::phases` and
`Phase::Layout.downstream` still seeded Placement automatically. The collected
split removes both eager routes. Layout/Width/Height inputs request measure/layout
work; actual location writes seed Transform/Subtree. Actual size and content
changes preserve own primitive effects. They affect descendant clipping only at
an active clip or List/ListItem/Scroll viewport. Padding, border and scrollbar
changes can move own text/image origins without moving the box. Text source,
font policy, text width and resource metrics retain direct own-primitive effects
when metrics happen to be equal.

Painter-order output stays conservative/full until the complete ordered subtree
catalog is proved. Root/scroll and topology fallback behavior remains. Effective
scroll clamping is a derived placement value: shrinking ordinary content can
change the clamped offset without a user scroll. Both admitted offset changes
and derived clamp changes now emit typed Transform/Subtree facts.

The 128-child width fixture changes real parent pixels, compares full cold output
and unchanged child matrices, then asserts a small **materialized input closure**.
That count is not elapsed time, retired instructions, edge visits, or a removed
presentation walk. Local Transform/Clip facts still conservatively fan out to descendants; that
fanout is NOT gated by exact outgoing f64-context equality. Exact context
cancellation and immutable segment reuse are not implemented by this cut.

### 5. Style semantics, not mutation-route guesses

`style_facets` compares all twelve existing Style fields with exact authoring
comparison. It is shared by coarse View reconciliation, direct property mutation
and mapped source fanout. Width and height are separate constraint facts;
gap/padding/flow/alignment/justification/wrap are layout; font size is text policy;
transform has subtree scope; foreground/background changes are material paint.
There is no epsilon, and the field inventory is exhaustive so a new field forces
classification review.

Alpha changes also mark primitive content because command admission/opaque versus
translucent handling can change. Equal-color source binding detachment is not a
material-only no-op: the literal must not follow a later shared-source write.
Gradient key and solid/gradient transitions include resource + primitive content.
Pure local layout or paint changes no longer inherit coarse reconciliation's
blanket Paint/Subtree classification.

Retained CheckBox state is the one stateful site-kind collapse: a checked-state
flip preserves identity but changes primitive and semantic payload. Handler
presence changes hit and semantic capabilities even when transparent pixels stay
identical. Unexpected other retained-kind changes use conservative topology/full
recovery. Tests compare coarse/direct/mapped facts and cold outputs, include exact
ULP and signed-zero controls, alpha fallback, equal-color binding detachment,
checked-state pixels/identity, and transparent action add/remove.

A remaining consumer obligation is global pipeline state. For example, changing
paint-bank presence can change the shader's global interpretation even when some
owners' effective colors are unchanged. A local artifact set alone does not prove
that global mode, clear/config/format or surface generation stayed equal. The
incremental target must compare the actual old/new global header or force full.
The current full Canvas rendering path remains available; do not claim the
missing target integration is safe merely because a local cold test passes.

### 6. Canonical metadata revisions and existing token behavior

Metadata-only updates already emitted zero commands before this rework. There is
no new performance win to claim for that fact. The real bug was architectural:
metadata/source coverage advanced without a new canonical receipt, while the
change-scene API equated C sequence with public token sequence.

The collected implementation derives the next C/snapshot sequence from the
accepted journal base with checked addition. It adds no second retained counter.
Metadata can publish C2 while the same public token for draw/sheet1 stays eligible.
A subsequent checked paint can publish C3 with public token2. The callback validates
the Canvas receipt against the private canonical journal base and complete source
epoch, not numeric equality with the public token.

A strict Canvas transaction accepts zero actual mutations only with positive
raw and closed Hit/Semantics admission. Future/unknown bits fail closed. It
consumes the journal and issuer ticket exactly once and preserves command/group/
resource ownership. Raw Paint with zero actual slot changes is not sufficient:
that path declines and prepares complete C instead. A non-graphical edge cannot
promote a target image or acknowledge a buffer.

Metadata proof decline retains a logical pending prefix, marks preparation needed,
and does not retry failed graphics, patch P, or relabel old complete coverage. An
explicit preparation barrier can then perform full canonical fallback. The
positive proof also permits two legitimate metadata operations in an EditTurn to
form one C without assuming `complete_epoch == source_epoch - 1`. A prior failed
graphical prefix remains forbidden by dirty/layout/history guards and raw/closed
facets, not merely an epoch coincidence.

The tests interleave metadata, checked paint, pending candidate metadata, multiple
metadata edits, a failed newer transform, old eligible token ACK, valid repair,
resize at unchanged S and repeated metadata. They distinguish read-only old-P
query counts from target minting: `one()` must still reject PresentationStale when
current authority is unavailable. A receiver that misses a metadata revision sees
a genuine predecessor gap. A real checked zero-edit publication reaches the final
canonical sequence for exhaustion testing; subsequent checked semantic admission
rejects before changing metadata, Canvas or the eligible token.

### 7. Retained layout and practical costs

The retained topology path uses complete layout capabilities and a sorted full-ID
inverse, not a map from a raw storage index. The reverse-preorder sibling frontier
replaces per-parent BTree scratch with a stack whose live state follows active
ancestor sibling frontiers. It does not reserve N. A wide star and a chain can
have one live cell; an adversarial comb can grow to depth. Model enumeration is
useful source evidence, not a runtime allocation result.

Reconciliation accumulates topology from retained identity/index and length
information while already visiting drafts. It no longer builds and rescans a
separate old-ID vector. Scope-rejected consumed nodes still retire their old
layout handles. Prefix-preserving tail removal still changes topology. The
inverse retains namespace/generation checks and rejects recycled/foreign handles.
It is rebuilt/sorted for topology turns; this is not O(changed) topology indexing.

The packed NodeLinks viewport facts occupy spare bits in the existing word. They
are recomputed for reused nodes and close both sibling roots and the final spine.
No-viewport descriptions skip useless propagation using the fully produced list
and scroll drafts, including empty lists and scroll-only trees. Independent forest
models falsified omitted closures. These bits are topology evidence, not actual
clip, text, resource, hit or target-image authority.

Graph descriptions and base-edge registration still walk N. BTree/HashMap node
costs, two OLD/NEW graph cohorts, sorted inverse storage, optional history, material
CSR, source bank transitions and simultaneous old/new resource leases all count.
Canvas binding was measured on a host as growing from 464 to 784 bytes for the
standalone binding checkpoint: 320 bytes, not an earlier rough 48-byte estimate.
Later layouts require their own measurement. Compact material references resolve
u32 indexes through the owned SceneGroups rather than duplicate u64 locals; that
saves payload but adds dependent reads and must be priced on real hardware.

### 8. Compatibility that must not be optimized away

ItemSource promises purity **during a description**, not immutability between
turns. An Rc<Cell>-backed length changing externally 1→2 is legal. Resize used to
observe it and must continue to do so for untracked providers. A blanket no-list-
redescription argument based only on world transform or explicit height was not
sufficient.

The restored compatibility admission applies before patching an exact direct
source, only to typed Paint/Transform sinks disjoint from viewport ancestry and
subtree. It gates legacy external observation only. It grants no clean output,
no draw skip, no cache authority and no popover-name exception. Ancestor/inside-
viewport, mixed layout, failed preparation and dimension/scale mismatch stay
conservative. The test mutates external length, performs a real disjoint move
without description at the old boundary, then resizes and requires observation
and complete cold final equality.

Tracked provider/template capabilities remain an explicit experimental contract.
They must cover item observations AND relevant row-template dependencies, not
just length/keys. Existing compatible Signal revision authority is preferable to
another clock. Drop, replacement and exhaustion must invalidate evidence. A
watch is not automatic dependency discovery. The original untracked fixture was
not silently replaced with an annotated one to earn a headline result.

### 9. Actual evidence and failures

The final collected composition has **no host compile/test/benchmark result**.
Separate results must remain separate:

* Hosts compiled Core/Canvas and the corrected first GPUI assembly. Actual errors
  exposed missing Hash derives, a private text-module import, an incorrect planner
  path, cfg on an assignment expression, receiver borrow conflicts, fixture
  dereferencing and callback lifetime coupling. Every correction is preserved as
  a small descendant; source review had missed some real compiler errors.
* A host reported the corrected two-owner transfer/same-S resize smoke passing
  on `ce18a57492076ae6038795c42ae842242326d748`.
* Corrected solver tests, the write-history test and two core observer tests were
  reported passing. The inherited layout cross-product then failed on source
  `8a17eeae05b232f0c85aad14884c3a84f042d832`, line1035: one description versus
  expected zero for the disjoint transform. Earlier capability/selector checks
  passed; later cold assertions were not reached. The expectation was not relaxed.
  The missing observation compatibility predicate was restored separately, and
  the external-provider boundary control added. Retest is still required.
* Earlier retained packets contained a missing closing brace and an ambiguous
  `.name("popup")` selector matching a Div and Text fallback. Separate test-only
  descendants corrected them; failed artifacts are not rewritten.
* Renderer CSR and standalone CPU-cache results are real but do not qualify this
  composition. The default-OFF CPU-cache B is a preserved alternative, not the
  common target/index consumer in this checkpoint.

Source-only delimiter checks and exhaustive Python models are labelled as such.
They do not prove Rust syntax, borrowing, cfg combinations, native behavior,
pixels, assembly or speed. A helper failure caused by `grep -q` closing a live
`rustc -Vv` pipe was a driver failure before compilation, not a compiler failure.
Capture complete identity output and status before examining its bytes.

### 10. What is still missing, in priority order

1. **Compile and execute this exact composition.** Use the symmetric host-owned
   stable overlay and real fonts, fresh targets and exact executable identities.
2. **Run the unchanged cross-product plus external observation control.** Do not
   turn the failed assertion into a tolerated extra description.
3. **Bind one actual target consumer.** The host R4 wrapper/index/executor source
   is not available in this cloud tree. Contracts and fixtures are not that
   implementation. Import/audit its actual tracked diff and prove predecessor,
   surface, global-mode, pending-union and completion behavior.
4. **Run one combined history:** hover transfer, popover insertion/removal/move,
   text/width change, scroll/clamp, resize/scale, failed newer preparation, old
   eligible ACK and repair. Compare complete cold outputs at intermediate states,
   not only final checksums. Validate the actual primary popover's separate flushes.
5. **Connect immutable group reuse.** Recorded own ranges and exact frame binding
   are prerequisites, not retained unchanged command fragments. Common clipped
   groups need all placements for max-error lowering; a semantic middle range
   cannot be lowered independently.
6. **Finish scoped application adoption.** Explicit resource/font mount and edit
   turns exist, but general scoped pointer/key/IME/scroll/resize adapters are not
   complete. Legacy constructors remain unaccounted. Feature-on alone does not
   prove original benchmark operations reach accounted text.
7. **Close global/resource dependencies.** Actual material descriptors, font/image
   metrics, pipeline config, root scale and target generations need complete
   producer-to-consumer coverage, not an extra renderer-private dirty graph.
8. **Measure retained capacity and tails.** No memory or parallelism win follows
   from fewer source containers or zero final draw emissions alone.

### 11. Acceptance and measurement gates

Use ordinary stable Rust in the shared pinned Nix environment. No bootstrap,
nightly, JIT, hidden wrapper or cloud build substitutes for this. Freeze inputs
before gates; keep per-lane fresh target directories. Old mtimes have produced a
stale executable before. Preserve full source/config/font/features/compiler/ISA,
Cargo freshness output, generated shader bytes and executable hashes. Independent
application lockfiles need independent locked/offline checks.

The minimum named tests include `runtime::canonical_revision_tests`,
`runtime::style_delta_tests`, `runtime::solver_dependency_tests`,
`runtime::layout_writes`, `layout::write_observer_tests`, the original
`runtime::layout_nodes::integrated_cross_product_tests`,
`untracked_observation_boundaries`, `change_publication`, `resource_scope`,
`late_scroll_resource`, Canvas publication/recording tests and the retained text
lifetime/abort/ownership matrix. Run default and retained-text configurations.
Native accessibility, surface loss, image/pool parity and full workspace/Clippy/
format gates are additional; none are implied by one named smoke.

Discriminating mutants must fail their intended assertion, not compile, timeout
or crash elsewhere. Preserve mutant and restored executable identities:

* Omit the admitted scroll offset fact: full pixels/cold rows pass first, then the
  required subtree placement receipt assertion must fail.
* Restore Layout→Placement: the real 128-child width test must fail its input
  artifact gate after full output validation.
* Omit final-spine or sibling-root viewport propagation: forest controls fail.
* Omit consumed scope-rejection retirement: cardinality/old-handle tests fail.
* Replace pending damage union with the latest update: disconnected changes and
  skipped output, including metadata between paint changes, must expose stale
  output against cold full pixels.
* Remove actual slot/user coverage or hard-full rejection: late invalid/subset/
  hidden-layout cases must fail before mutation.

Timing uses the original immutable six-case interaction workload. Diagnostics,
allocation counters and cold validation are separate from timed binaries. Report
scene-only and full-CPU tiers, stress tiers, all paired AB/BA processes, p50/p95/
p99 and worst tails, RSS/retained capacity and cold construction separately.
Warmup=0 means the **first measured changed operation after the mandatory oracle**:
that oracle warms driver raster/CSR caches. It is not cold raster. Per-case
regression/memory gates and quiet-host conditions must be fixed before looking at
results. Native/GPU/display scanout conclusions require their actual environment,
not software Vulkan or process wall time. No no-op scenario can replace genuine
leaving/entering hover colors with independent cold output.

### 12. Worthwhile experiments not yet earned

The following are a roadmap, not latent performance claims:

* Sparse earliest-old transform/clip/scroll input capture, combined with current
  unchanged locals, to reconstruct old/new f64 ancestor spaces without a 48-byte
  transform mirror per node. Bound paths and retain earliest old across failure.
* Stop descendant placement only when exact outgoing wide context is unchanged;
  independently continue semantic clip, hit and membership changes. Never use
  equal parent size or a rounded AABB as the proof.
* Retained per-scroll extent contributions, so max-union shrink/removal rescans
  only an affected scroll subtree rather than all nodes. Preserve clamping.
* Fuse base dependency registration and derived resource observation into existing
  mandatory visits; measure edge/node allocation and avoid a new whole-graph pass.
* Replace sorted inverse `(NodeId,index)` tuples with an index permutation into
  the immutable ordered vector. Price smaller storage against dependent key loads
  and full capability comparisons; qualify recycled/foreign handles.
* A proof-bearing completed graphical-output receipt that can admit equal layout
  inputs without raw Hit/Semantics-only restriction. It must include metadata,
  viewport, material binding and context completeness, not just absent raster bits.
* Immutable local command segments with stable resources and explicit painter
  splices, reused from C, not P. Preserve common-group lowering and resource leases.
* Output jobs derived through the same bounded dependency queue, with lazy old/new
  group adjacency and target-specific completion—not a second hidden fixed point.
* Compact canonical-to-physical catalogs with generation-safe slots, while keeping
  full semantic IDs out of every tile reference. Measure bytes and cache misses.
* Parallel jobs only after dependency closure/ordering is correct: disjoint tile
  jobs, bounded worker scratch, deterministic error precedence and exact output.
  Root borrowing and native retirement must remain explicit.
* App-owned resource sharing and mandatory-before-optional admission across all
  windows, including source/packed/font/image owners. Optional raw cache pressure
  must not starve required output. Shared backing is charged once, queued leases
  remain charged until real retirement, and maintenance work is bounded.
* Match tracked/untracked source fixtures with identical operation bodies and cold
  outputs. Learn source/template dependencies from actual framework-managed
  producers rather than annotating one popover scenario.
* Compile/codegen experiments: no-list mount adverse cases, K=0/1/many slots,
  broad and deep frontiers, common-mask coupling, shader size, stack, allocation,
  branch/LLC behavior and linked text size. Source LOC alone does not price them.

### 13. Rejected or deliberately deferred approaches

We rejected dense N+1 sibling buckets as the final frontier, a separate old-ID
collection/scan, raw ordinal inverse keys, and persistent full graph cloning per
text change. We rejected enqueue-unbounded queues, caller-editable closed
artifacts, caller Paint annotations as actual slot coverage, hard-full slot
retarget, generic reusable receipts, independent counters authorizing App globals,
and carrying snapshot GroupIds blindly across rebase.

We rejected fixed-size parent propagation guesses because real baseline/margin/
OOF/overflow answers matter. We rejected blanket resize skip for untracked
ItemSource, automatic purity inferred from a source key, full color cross-swap
hover assertions (real base colors alternate), and end-only popover validation
that skips intermediate flushes. We rejected an always-N f64 mirror before
pricing a bounded first-write alternative.

We also rejected treating an empty output list, a zero-record benchmark, aliased
paired-process directories, optimized-away Python assertions or a stale ELF as a
passing gate. Failed helpers and source checkpoints remain preserved. The honest
next step is one reproducible integrated executable and target consumer, not more
names for independently unqualified fast paths.

<a id="chapter-3"></a>

## Chapter 3: Rendering, retained ownership and parallel execution

## Rendering, canonical ownership, incremental membership, and target completion

**Checkpoint brief — 2026-10-26.** This section records the rendering lane's implementation, evidence, failures, open integration work, and experiment backlog. It is intentionally explicit about what is implemented versus what merely has a proof sketch. It is not a release qualification or a claim that pushing this checkpoint finishes innate damage tracking.

**Selected coherent source:** `3c5cc3330cf6e6878489a55f1ab7218731a379af` uses pre-R4 / bf52-style storage. The geometry/paint extraction described below is a separate reviewed candidate, not part of that selected source. Metadata canonical-C sequencing is implemented in source, independently from public draw-token sequencing; composed host qualification remains separate.

The collector should preserve the source pins, patches, input manifests, negative results, and gate helpers referenced below. They are useful controls, not disposable scratch. Workspace evidence paths are listed in the registry; those artifacts should be collected into the repository's evidence directory when assembling the final checkpoint.

### 1. Executive assessment

The project now has several necessary pieces of a common damage model:

- Canonical scene revisions and one-shot publication transactions.
- A bound Canvas view that owns its actual change batch, semantic draw partition, material-reader mapping, and optional already-closed dependency receipt.
- Actual checked-slot witnesses, including a precommit read view, rather than caller-supplied dirty IDs.
- A fused producer path that records mandatory node-owned draw ranges during actual successful drawing.
- A narrower material-reader representation that reuses the mandatory group table instead of duplicating semantic IDs.
- A strict whole-command-owner retarget for proven non-graphical transitions.
- An ownership extraction separating existing geometry/resource storage from mutable paint values, without adding another heap owner.
- A host-owned compact contributor catalog and a host-owned deterministic row executor, with focused host test evidence.
- A proven software-GPU regional-output experiment, and a separately scoped checked-paint CPU packed-image experiment.

These pieces do **not** yet prove a single, general producer-to-target incremental renderer. The decisive remaining integration is the actual host consumer that binds accepted old/new snapshots, updates membership, accumulates target-relative damage, executes ordered work, and publishes completion only after successful writes/copies/fences. That implementation must be exercised on ordinary insertion, removal, overlap, text, clip, scroll, and resize. A popover cannot be declared unsupported merely because its application name is inconvenient.

The ownership extraction alone is not a traversal win. It is a prerequisite for future immutable command reuse. The GPU regional-output experiment still performs full validation, preparation, binning, and upload. The packed CPU cache currently preserves only checked paint-slot transitions. Those limitations are fundamental to interpreting the evidence.

This lane has not received a qualified latency series for the new common consumer. No performance graph should silently splice results from separate prototypes or treat source review, a model, a successful compile, or a linked-code improvement as an end-to-end timing result.

### 2. Authority domains: similar numbers are not interchangeable capabilities

#### 2.1 Source, canonical scene, index, image, and presentation

Keep the following domains distinct:

| Domain | Meaning | What it does not establish |
|---|---|---|
| Source epoch / logical state | Admitted model/style/text inputs | A complete canonical scene or valid pixels |
| Accepted canonical C | A successfully committed immutable scene description and associated metadata | That any target rendered it |
| Indexed scene revision | Membership/catalog prepared for a C | That tile jobs executed |
| Complete image revision | Actual complete pixels in one specific owned target/domain | Native presentation or ACK |
| Presentation token / P | The existing draw/publication/native presentation protocol | The actual base of every private render target |
| Bank origin | Birth identity of one positional material bank | Current material value revision or current C |
| GroupId | A snapshot-local dependency node | Stable semantic identity or physical storage slot |
| Catalog handle/slot | Checked physical addressing under a snapshot lease | Painter order or semantic SiteId |

Metadata can advance canonical C while the same draw token remains eligible. That does not authorize relabeling an image that still has unrendered paint changes. Likewise a renderer can have completed an unacknowledged C; its next damage base is that actual complete C, not an older P.

The selected coherent source implements independent C sequencing and metadata retargeting while preserving the public draw token. This is source integration, not a composed runtime qualification. Future rendering changes must preserve it rather than restore an older token-coupled producer literal.

#### 2.2 The intended end-to-end path

```text
logical mutation and actual output changes
    -> bounded common dependency closure over OLD and NEW dependencies
    -> guarded canonical preparation / resource admission
    -> actual node-owned draw ranges and immutable resource leases
    -> one successful Canvas publication of C
    -> target consumer observes the exact accepted edge
    -> old/new physical group, clip, order, resource and tile expansion
    -> transactional membership/catalog update
    -> immutable ordered work snapshot
    -> joined CPU work or submitted/completed GPU work
    -> required output copy/readback/fence succeeds
    -> target-complete image lease
    -> separate native presentation / ACK
```

No stage may mint the next stage's authority merely because its stamp looks plausible. In particular, a `CompletedWrites` returned by a leaf executor is not an ACK, and an index commit is not image completion.

### 3. What the actual Canvas representation owns

The original `DisplayList` owns:

- A dense painter-ordered `Vec<DrawRef>`.
- Inline geometry and compact common text groups.
- Scope and paint columns.
- Unique mask leases and their full-key index.
- Optional image, gradient, and parent-linked clip storage.

`DrawRef` is asserted to be **14 bytes**. Its command, glyph, and mask addresses are local to the owning list. `StoredCommon` similarly contains local scope/paint addressing. Its paint lane is overloaded: for image/gradient material it carries radius bits, not a paint-bank row. Treating every such lane as an ordinary material index would be a correctness error.

Text is intentionally compact. A common group retains the packed shared glyph owner and raster witnesses instead of copying expanded glyph geometry into every record. The GPU baseline also distinguishes inline records from common-state groups. The inspected GPU layout uses six 16-byte words for an inline record, versus five common words plus two words per placement. Flattening every glyph into a fixed 96-byte record would lose that compaction; even forcing a singleton into an 80+32-byte group costs 16 bytes compared with the inline form.

`PreparedGroup` is safe because it pairs an ordered slice with its exact owner. A saved slice, cursor, or equal draw count is not independently safe. Local mask index zero in one owner can mean completely different coverage from local index zero in another.

#### 3.1 Why partial reuse cannot just save PreparedGroup

`Canvas::stage` starts a replacement while exclusively borrowing the predecessor. A successful commit replaces the old list. A borrowed prepared group cannot outlive that owner or cross a later mutable scene update. Copying only `DrawRef` also fails because its resource/column addresses remain local.

Wrapping the entire old list in `Arc` is not a free fix. Checked paint and literal detachment currently mutate state inside it; naive sharing forces COW or breaks readers. Retaining `Arc<previous Canvas>` chains is an unbounded history, not an acceptable retained model.

The current extraction creates an explicit boundary:

```text
DisplayList
    DrawGeometry
        existing order / inline / common records
        existing immutable-scope rows
        existing mask/index/image/gradient/clip owners
    PaintState
        existing paint-value/support/discovery Vec
```

No new Vec, Arc, Box, or full image owner is added by this extraction. It is not yet independently immutable geometry. Recording and literal detachment still mutate it explicitly. Future sharing must first settle material-binding addressing and old resource/value lifetime.

#### 3.2 Layout and destruction costs

The extraction has exact host gates comparing its owner shape with a test-only mirror of the old representation. It retains the 14-byte witness and the old combined two-Vec scope/paint header budget. The historical `Columns` log lane is preserved as the combined new pair, not silently redefined as only paint storage.

No host size result is claimed for the new extraction yet. Nested Rust types can change layout, so `size_of` assertions are gates, not measurements fabricated from a diagram.

Explicit clear and reserve order are preserved. Implicit destruction changes the order in which the plain paint Vec buffer is freed relative to mask/image resources. `PaintValue` has no custom resource lease destructor; reviewers found no semantic pixel/authority defect. Nevertheless exact allocator-event order and global physical-OOM equivalence are not claimed.

### 4. Canonical publication is an actual transaction, not a dirty flag

#### 4.1 Bound accepted views

The Canvas binding owns its one-shot publication receipt, change batch, mandatory `SceneGroups`, material-user CSR, mutation witness, scratch witness buffer, and optional `ClosedDependencies`.

The view has no public receipt getter or raw rebind constructor. It borrows the actual Canvas owner. Its scene-matching discriminator includes the exact owner and all render-relevant copied header fields, using float bits where necessary. Equal draw count is deliberately insufficient. A copied `PreparedScene` with altered width, clear, mapping, or reference white is not the same view.

Full publication performs every fallible metadata/resource check before canonical mutation. The successful path then moves owned receipts and metadata without a new fallible allocation. Dropping a stage or publication guard retains the old C and pending journal.

Canonical mutations revoke the binding at actual mutation boundaries. Scope/resource creation, literal edits, shared-slot edits, clear, successful append, and scene replacement are included. Stage creation/drop, failed validation, text rollback, ordinary rendering, and diagnostic allocation do not falsely become canonical changes. The mutation audit cannot be reduced to the raster scratch invalidation function: scratch preparation can change a CSR window while C remains identical.

#### 4.2 Hard-full is not permission to reuse old geometry

A truncated journal may retain a Paint row while losing a later Layout/Topology fact. Repainting old geometry over the whole target cannot recover omitted logical geometry. Therefore checked-slot publication rejects hard-full reasons and requires full scene preparation.

A real host fixture failure exposed a stale **test contract**, not a reached slot-guard defect. Frozen core `6d6f676` intentionally exports an empty zero-capacity entry Vec for hard-full candidates while retaining pending Journal facts until success. The public test still expected one copied row. Host source `55d97528a5f9d1a31a9a792778ae4744ad9dd0f3` compiled; its first five named public gates passed, then the sixth failed at `publication.rs:146:5`, length zero versus one. The subsequent slot rejection had not run.

The separate test-only correction `5399733` changes that exact assertion to `(len, capacity) == (0, 0)` and strengthens checks that:

1. CAPACITY remains after rejected slot publication.
2. Retry preparation still exports zero rows/capacity.
3. An accepted full snapshot retains its hard-full receipt.
4. Pending Journal history drains only after successful full commit.

It changes no production guard. Its repaired host result must be recorded separately from the preserved original failure; it is not an overall rendering pass.

#### 4.3 Checked paint causality comes from actual edits

A precommit `PreparedSlotMutation` borrows the actual checked plan. It reports exact predecessor, bank origin, actual changed slots using the existing bit-equality rule, and every actual semantic reader. It allocates no new state and cannot coexist with consuming the plan into commit.

This prevents using caller Paint annotations as the authority for changed material. The Canvas builds reader ownership from actual prepared group paint slots and the validated own-range partition. Every actual changed row must be covered by the common closure. A raw Hit source can invalidate Material or Layout through real dependency edges; the receiver must reject the latter for slot-only retargeting.

Material and Primitive are distinct domains. An RGB value update is not automatically a geometry change; caret/selection primitives are not ordinary paint-bank edits. Alpha/image/material coverage changes can invalidate opaque cuts even if bounds and order are unchanged. The checked same-alpha path is a scoped baseline, not a universal material theorem.

#### 4.4 Zero-actual-mutation retarget has one authority

`commit_non_graphical_publication` delegates to the existing checked retarget. The common receiver handles **all** `changed == 0` publications, including nonempty same-color edit lists. It requires:

- Exact accepted predecessor and matching one-shot stamps.
- No hard-full reason.
- A positive raw schema allowing only Hit/Semantics.
- A mandatory closed receipt containing only same-owner Site Hit/Semantics nodes.

Material, Raster, Primitive, layout, placement, clip, resources, global pipeline nodes, and unknown/future domains fail closed. Empty caller edits are not a substitute for proof.

A raw Paint no-op conservatively returns `IncompleteChanges` until a completed-output proof exists. That error does not itself execute fallback: the actual Runtime receiver must stage fully rather than leak an error into an otherwise valid turn. The receiver gate is explicit.

This path adds no Canvas field or owner and does not traverse commands. It examines existing facts and closure nodes. Commit-only zero-allocation tests exclude graph/guard construction and old closure destruction. Native semantic publication and target image completion remain separate.

### 5. Removing actual publication work

#### 5.1 Mandatory own ranges fused into actual emission

The fused producer replaces its old separate `change_groups` vector with one mandatory recorder table. It reserves the known node count once before callbacks. Each node receives a checked own scope, including omitted/empty nodes, so parent ordinal can be resolved through that same current table. No second N-entry token table is needed.

The scope reserves and pushes its placeholder before a guard exists. Drop cannot allocate. It records the actual successful end and resets the active owner. Explicit finish distinguishes a completed callback from an error or caught panic. Nested active scopes, stale parent selectors, and clear-after-recording fail closed. An explicit restart is allowed only under the checked empty-stage conditions.

Once recording begins, legacy publication with caller-supplied external ranges cannot bypass it. The recorded path transfers the mandatory Vec into `SceneGroups`. Trace allocation failure cannot discard that required metadata or replay drawing.

The optional material trace observes only actual successful admitted draw/slot use. Empty text, clipped geometry, and late glyph rollback add no false edge. Adjacent identical `(slot, owner)` entries are suppressed. Nonadjacent dedup remains explicit later work.

When the optional trace is complete, full publication avoids the old canonical group/span join. When it declines, the independent scan remains the oracle/fallback. This is a real pass-removal seam, but not elimination of mandatory group validation, sorting, CSR construction, all Runtime traversal, or all command emission.

The Runtime port must preserve its current canonical `change_stamp()` allocator. Reapplying the old `e3d9221` literal that derived C from draw-token sequence would undo the later metadata-C correction.

#### 5.2 Material users reuse canonical identities instead of owning copies

The earlier CSR duplicated each semantic local ID as `NonZeroU64`. The current candidate stores private u32 addresses into its **own bound** mandatory group table. It reconstructs full identity from that table and owner.

| Storage | Earlier element | Current source element |
|---|---:|---:|
| Staged `(slot, owner)` edge | 16 bytes | 8 bytes |
| Retained user entry | 8 bytes | 4 bytes |
| Row offset | 4 bytes | 4 bytes |
| Vec/Binding headers | unchanged | unchanged |

For actual staged-edge capacity `Ce`, old owner capacity `Co`, and new owner capacity `Cn`, matched-capacity publication overlap saves `8*Ce + 4*(Co+Cn)` bytes of logical payload. Do not substitute lengths for capacities or turn this into an RSS claim.

The same Vec requests and CSR copy remain. Sorting now loads canonical local IDs indirectly. It explicitly sorts by semantic local ID, not physical table order; `[9,2,7]` must still expose users `[2,7,9]`. Replacement with `[7,9,2]` rebuilds the paired CSR. A bank/revision/range/count check precedes comparator access and allocation. Same-revision foreign-table exclusion comes from private paired construction, not revision equality alone.

#### 5.3 Why a new material-user sorting algorithm was not forced

Let `E` be emitted pairs, `U` unique pairs, `S` rows, and `U_s` unique users in row `s`. Actual emission is monotone in owner-table address, but semantic IDs can be arbitrarily ordered after valid reordering.

- Counting scatter plus per-row sort adds owner initialization/scatter and may reserve E owners instead of U. A one-shared-material scene still sorts all semantic IDs and pays the extra passes.
- Retaining sorted pairs removes CSR allocation/copy but retains roughly `8*Ce` instead of `4*Cu + 4*Co`; the one-material dense case nearly doubles retained user payload.
- Last-owner-per-slot scratch can reuse offsets, but adds initialization and another traversal/reset when the fused trace is already unique.

Actual E/U and slot skew must be measured before choosing an adaptive general algorithm. A benchmark-specific shortcut or an asymptotic slogan is not sufficient.

#### 5.4 A separate exact CPU CSR copy-pass removal

The ordinary CPU CSR already uses two Vec owners and reverse painter scatter. There was no extra cursor array to remove. The new source instead:

1. Counts into `offsets[tile]`.
2. Prefixes T real entries into cumulative ends.
3. Saves the final end, with safe internal T=0 handling.
4. Reverse-scatters painters by decrementing those same cells.
5. Writes the final sentinel.

The ends become starts directly, so `copy_within(1.., 0)` disappears. It removes a source-level 4*T-byte copy and one sentinel prefix addition, not the O(R) reference work, two command-bounds walks, membership zeroing, allocations, or Samples raster work.

A finite integer model compared both algorithms to independent memberships for 108,788 matrices. That is model evidence only. The unchanged exact-capacity/order/cut tests and new sparse/empty/dense/partial-tile fixture are real host gates.

The codegen reviewer records a parent-reported host result for source `8be82d4d0aeb245e912c23b2152990add0cfe90a`: first release 274 tests, four docs, six named gates and image/pool exact comparisons passed. Reported linked `RasterScratch::prepare` shrank 2087 to 2061 bytes; memcpy/memmove sites went from one to zero; its 224-byte frame and initialization/allocation sites were unchanged. Scalar/default SIMD/stat parity and mutants were still open in that report. This is not elapsed-time or cache evidence. Raw linked assembly was not independently inspected in this lane.

### 6. Retained index and physical closure

The private index proof separates stable semantic key, painter rank, and physical addressing. These cannot be collapsed into PaintSlot or a dense ordinal.

Its draft updates only affected tiles, unions old and new support, preserves every unchanged current contributor, sorts only additions, and linearly merges them into already ordered membership. A previous full re-sort of every dirty tile member was removed. Added fanout scratch refers to `(tile, changed-edit index)` rather than copying a large semantic key and u128 rank per reference.

The global reference limit must be applied to the final total, not to transient per-tile update order. Otherwise a move from a later tile to an earlier tile at the cap can spuriously reject before the later subtraction. Retained/staged peak remains a separate budget.

The proof also distinguishes index publication from complete image authority. An index can admit C2 while the image still contains C0. Failed/partial jobs must not fabricate a completed C2 image or restore C0 eligibility after physical writes.

#### 6.1 Shared common-group coupling

A semantic own range can start inside a common group. Lowering a clipped suffix as though it were a complete group can change shared error/quantization behavior. The full-group read seam therefore returns the entire containing canonical group, and the strict boundary accessor rejects a middle cursor.

Physical invalidation needs a fixed point across BOTH old and new group-to-owner edges. A removed owner can dirty an old shared group; a new split/merge can reach another owner, which reaches another old group. Repeated global scans per frontier step are not an incremental algorithm. The proposed adapter uses retained interval/reverse membership queries with deduped frontier, and the shared core dependency queue remains the authority.

Snapshot-local GroupId must be minted lazily from the current admitted scene revision and local group cursor. Metadata-only C rebase must not leave stored C1 GroupIds masquerading under C2 or require scanning all group payloads merely to rewrite their epoch.

#### 6.2 Compact catalog evidence and limits

The host owns the production `Catalog<K,B>` and snapshot implementation. Reported source `fb019539fa55e679696f836ceac4078f849257a4` passed nine focused tests covering stale reuse, generation exhaustion, failed staging, and CPU lease retention. Admission handles are checked; retained private u32 slots are usable only under the immutable snapshot/lease. Do not infer the whole public handle's size merely from a reported 64-bit generation width.

The cloud's provisional catalog is cfg(test) only and must not become a competing generation system. The semantic map may retain full keys once, but copying a 16-byte SiteId or a rank-bearing tuple into every one of millions of tile references is memory-adverse. The old GPU reference is four bytes. A Vec header per tile is also real overhead, not a memory win by definition.

CPU borrow protection is not a GPU retirement theorem. Slot reuse and old buffer release still need the actual queue/fence lease. Failed admission can grow capacities without publishing state; that observable memory cost must be reported.

### 7. Deterministic bounded parallel execution

The authorized attached executor checkpoint separates scheduling from identity/history. It accepts a rectangle or borrowed sorted `TileRowSpan` selection, validates target stamp/extent/output/membership before writes, and splits exclusive physical rows and mutable CSR slices. Immutable offsets can overlap. Each tile replays contributors in original painter order; parallelism is across disjoint outputs, not across arbitrary translucent commands.

Its leaf returns `CompletedWrites`, not image completion or ACK. Scoped workers join before borrows end. A caller catching a panic must revoke target completion if writes may have occurred.

Reported host R4 by-reference work completed both feature cohorts and exact all-stat/image comparisons. That applies to the host's current implementation, not the unadapted geometry extraction. Exact R4 source/adapter identity must remain in the host evidence registry. No timing claim follows.

The original recursive row partition repeatedly rescanned X minima/maxima. The narrow R1 proposal carried admitted X and used sorted first/last rows for Y. The host confirmed the newer common plan already does this, so the R1 patch is marked superseded and must not overwrite R4. Initial admission, exact absolute `TileColumns`, partition searches, and reference validation remain real work.

Two important cost/semantic details remain visible:

- `owned_descriptor_bytes == 0` means the leaf borrows descriptors. A producer-owned span Vec is not free.
- A no-parallel build receiving a parallel hint must still report serial execution. The old R1 source had a latent stats mismatch for that adversary; actual R4 evidence must name whether that case was exercised.

`Samples` contains 256 uniform colors, 4096 sample colors, and four mixed masks: 69,664 bytes of source array payload at TILE=16. That is not automatically the emitted stack frame or a guaranteed memset. Worker count, stack/cache occupancy, and generated initialization need linked measurement. A fast branch inside the same function does not prove the large frame disappears.

### 8. The missing actual target consumer is a specific integration gap

The cloud has the authorized attached R1 executor and its own source transactions. The host owns the newer catalog, R4 leaf, and actual target wrapper. The current host target/index consumer implementation is not present in this cloud checkout. Integration requires the actual host implementation and its exact source identity, not a second wrapper presented as production.

The necessary consumer contract is concrete:

1. Observe each successful accepted-C edge, even when output is skipped. Canvas stores the latest edge, not an implicit event history. Missing edges require an explicit full fallback.
2. Expand old and new physical support while BOTH exact admitted snapshots and their resource leases remain available. Latest C cannot reconstruct a skipped removal. Only after that expansion may the consumer retain just the physical tile union and release edge views.
3. Bind damage to actual target storage identity, surface generation, extent, format/configuration, and complete-image base. A scene sequence or pointer alone is insufficient, especially for arbitrary externally mutable buffers.
4. Prepare catalog/membership/jobs transactionally before writing. Preserve deterministic current order and all unchanged contributors intersecting dirty tiles.
5. On prewrite failure, preserve the old complete lease and pending union. Before the first possible write, revoke complete-image eligibility. Partial-write failure must retain all possibly touched support; otherwise recover fully.
6. Publish completion only for the captured revision after joined work and required copy/upload/fence succeeds. A concurrent newer receipt must not be erased by clearing an older job prefix. A synchronous exclusive borrow can forbid that concurrency instead of adding a queue.
7. Keep internal cached-image completion distinct from external destination-copy/native-surface completion. A successful private repair plus failed external copy does not complete that destination.
8. Keep all of this distinct from P/ACK. Metadata receipt success alone neither presents pixels nor promotes an image base.

#### 8.1 The essential mixed history

The end-to-end matrix must include:

```text
complete target C0
accept paint C1 on the left, do not render
accept metadata-only C2, same public draw token
accept paint C3 on the right, do not render until now
render once -> exact cold C3 pixels
```

C2 may rebase the admitted index stamp in O(1), and GroupId can be minted lazily under C2. It must not clear the left damage from C1 or mark the image complete. This is the direct connection between the metadata optimization and actual damage correctness.

Additional required histories include removal exposing unchanged translucent content; moved siblings and inherited clip exposure; ordinary popover insertion/removal; scroll with follow-anchor intermediate subframes; resize/format/device-generation changes; valid-header preparation failure; stale catalog generation; invalid output between sparse commits; and failure after an actual row write.

#### 8.2 Current CPU packed-image baseline

The default-OFF `cpu-output-cache-experiment` is a real serial BGRX consumer, but deliberately narrower than the common model:

- Only the existing checked atomic paint-slot transition preserves its packed state.
- Structural geometry, clear, extent, configuration and resource changes revoke it and take the direct path.
- Changed slots contribute their already conservative support to dirty tiles before a final global bounding-box fold. This preserves disconnected *slot* damage; it is not perfect per-pixel support for a shared row with distant users.
- One full-grid CSR/frame is prepared once; selected dirty row runs use the same kernel. Calling render_output separately per tile would be the wrong architecture and duplicate preparation.
- Every accepted arbitrary caller destination is fully overwritten in active pixels. No validity is inferred from previous caller contents. Existing exact BGRX length validation remains authoritative; oversized/padded buffers reject untouched.
- The first sparse event may seed a private image with full raster plus full copy. Subsequent sparse events repair plus full output copy. Dense/resize paths drop/invalidate to avoid a copy regression.
- Diagnostic RGBA ownership excludes this packed owner. `with_pixels` can intentionally disable the experiment, so old diagnostic tests are not automatically meaningful cache benchmarks.
- Failed output validation must not consume pending dirty bits. A rejection between two sparse commits is a mandatory regression.

This can be included as an explicitly scoped GPUI-to-Canvas consumer baseline. It does not mean R4/catalog integration exists, and it does not provide generic incremental popover/scroll/resize output. The newer common consumer must eliminate those named eligibility limitations through ordinary dependencies, not rename them as exceptional application cases.

### 9. Evidence ledger: keep the scope attached to every result

The table is a rendering-lane evidence snapshot. The final collector should append newer actual host results without rewriting the preserved failures.

| Work | Actual evidence received | What remains unearned |
|---|---|---|
| Borrowed source-array spelling | Both variants compiled; host reported every targeted copy remained | No runtime/timing promotion; no new cosmetic ABI retry justified |
| Hardened GPU geometry 464 | Host reported 24 cells / 640 actual subframes and both pixel mutants qualified | General resources/text eligibility, prep/upload elimination, native/hardware timing |
| Initial checked-paint cache | Both variants compiled; 12 complete 256×256 images matched; three intended pixel failures and restored images reported | Current coherent Runtime/target composition and performance |
| Cache full-feature allocation | Actual failure: 3 requests/148 bytes versus old 2/76 | Cannot call that suite qualified by hiding the failure |
| Cache accounting A / tiny-grid B | Separate reviewed descendants | Exact later host result must be supplied by host owner; do not inherit initial image passes |
| Host catalog | Nine focused tests reported passed | GPU fence retirement and global memory/performance claims |
| Host R4 by-reference executor | Both feature cohorts and exact all-stat/image comparison reported complete | New geometry adapter compatibility and end-to-end target correctness/timing |
| CSR end-offset cut | Reported 274 tests, four docs, six gates and image/pool comparisons; linked copy site removed | Scalar/SIMD/stat/mutant completion and timing, as open in the received report |
| Rendering source 55d975 | Compiled; first five named gates passed; sixth fixture failed at exact stale expectation | Overall qualification; repaired slot/recovery path had not yet run |
| Fixture correction 5399733 | Reviewed test-only repair and content guards | Repaired host execution must be recorded separately |
| Geometry/paint extraction | Two independent source reviews, exact reconstructions/guards and source tests authored | Rust/layout/allocation/output/codegen gates and actual sharing/reuse gain |

#### 9.1 Allocation failure that was real, not a pixel defect

The cache feature's observed 3/148 first-render result has an exact decomposition on the selected 64-bit source: original scratch 56 bytes, feature scratch 120 bytes, CSR offsets 20 bytes, and one u64 dirty bitmap word 8 bytes. Thus 120+20+8 = 148. No packed image had been allocated; the state was only Baseline tracking.

The honest accounting-only descendant preserves production and the old default-OFF exact 2/76 assertion. The separate tiny-grid candidate declines tracking when fewer than eight tiles make the nonempty sparse budget zero. Its source prediction is 2/140: scratch120 plus CSR20. The seven-versus-eight boundary and remove-guard mechanism mutant are distinct from image mutants. This is not a reason to silently raise the original budget or claim a runtime result for B before it is recorded.

#### 9.2 Exactness controls matter even for performance-negative experiments

The borrowed-array tests added independent site/presence/input-bit oracles and a public nearest-image/quarter-overlay discriminator. Those tests remain valuable even though the performance hypothesis failed its codegen gate.

Private working-bit failures and public packed-pixel failures are different. A same-popcount site permutation can change floating summation bits without crossing an 8-bit output threshold. A private mask-order assertion cannot be advertised as a public complete-image mutant. Conversely a public wrong-owner or missing-old-support mutant must fail at the intended complete pixel assertion, not merely fail compilation or panic elsewhere.

### 10. Historical dense prototypes: useful controls, not the final architecture

#### 10.1 Integer opaque spans

The integer prototype preflights a whole borrowed scene, seeds clear, and writes ordered spans before CSR/Samples. It restricts inverse, flat clip, source channels, opacity and integer translation/coverage. Effective overlay area is bounded by one frame, plus an unavoidable seed fill, so at most 2N requested stores. A last full-viewport opaque rectangle can reset the prefix only after complete scene admission.

The actual original 32-grid animation is not an integer fixture. Its SpaceBetween layout returns unrounded geometry; the inspected phase arithmetic has slack values not divisible by 31. An aligned surrogate cannot be renamed the original animation. This is a real negative applicability result, not a rendering bug.

The four feature-only counters add a source-expected 32 bytes to the embedded stats/header; default fields remain unchanged. The ordinary CSR strategy fixtures explicitly select their original path under this feature, preserving every assertion. Candidate engagement tests and old binary complete-output capture remain separate. A no-op control cannot pass a candidate-only engagement assertion by definition.

#### 10.2 Fractional disjoint-pixel strips

The fractional prototype is more applicable in principle: certify disjoint **pixel footprints**, fill full interiors, and compute boundary mask classes using the original fixed lattice, blend order, mean and encoder. It rejects shared pixels even when continuous rectangles do not overlap. This avoids cross-command sample correlation only because the actual pixel footprints are disjoint.

Its bounded binary searches explicitly handle no-satisfier sentinels, crossed endpoints, and singleton mask zero. The independent axis model covered 70,700 bounded cases, including eighth-grid shifts, nextafter sides, minimum subnormal and clips; thousands of singleton candidates had zero masks. That is not a Rust/f32 proof or a latency result.

It still performs whole-scene preflight and repeats axis work during paint. Keeping all arbitrary results through full admission is not constant-space for free. A naive `[Axis;2]` per draw would be large; even a roughly 12-byte compact descriptor for 1024 draws is about 12 KiB of real stack storage. Recursive unrolling is not a solution. A bounded endpoint-probe reformulation using admitted bounds is a hypothesis, not implemented qualification.

The seven counters add a source-expected 56-byte feature-only stats/header cost. `sample_tests` must count actual ordered axis membership queries, including rejection work, rather than inventing 16-site samples. Partial-mask continuation stack isolation needs linked inspection. Fast BGRX engagement is limited to its actual SDR/sRGB admission; HDR/P3 diagnostics remain ordinary reference paths or existing BGRX rejection.

These variants should remain frozen controls while common damage is completed. They must not displace the dominant real interaction work or become a collection of named special cases.

### 11. Rejected or deliberately deferred designs

1. **Use ACK P as every target's damage base.** Wrong when an unacknowledged C was rendered or intermediate Cs were skipped.
2. **Redraw changed commands only.** Removal, translucency and overlap require all current contributors in order.
3. **Treat Load+scissor as a full renderpass clear.** Preservation/clear behavior belongs to the actual shader/target contract; outside pixels need proven ownership.
4. **Trust packet token alone for image validity.** Storage, surface/device/sample/format/pipeline generations and prior image identity matter.
5. **Bind arbitrary generic scene data by equal count/stamp.** The accepted view must be minted by the actual producer and own its metadata pairing; repeated generic public issuers and interior mutability were not an exact-scene witness.
6. **Clear unknown/pending/full flags heuristically.** Logical Pending is not true Unbounded; only a proof-bearing old/new physical resolution can localize it. Hard Full cannot authorize old-geometry retarget.
7. **Lower a semantic suffix of a common text group.** It can break shared correction/error semantics and coupled owner invalidation.
8. **Copy local DrawRef without its owner.** Mask, scope, paint, image and clip indexes become foreign addresses.
9. **Make stable identity equal rank, row, or arena slot.** Insertion/reorder/reuse defeats that equation.
10. **Store full semantic key and cached u128 rank per tile reference.** At millions of references the metadata itself can dominate; compact snapshot-bound slots are the intended direction.
11. **Use a fixed 96-byte GPU record for every glyph.** It destroys current common-state text compaction.
12. **Return a new ResourceLimit because optional evidence allocation failed.** The geometry ledger was corrected to decline to full; optional reuse cannot redefine accepted scene semantics.
13. **Count only final live capacity.** Old/new ledgers, staging, retired leases, maps, jobs, output owners and failed-attempt growth are real.
14. **Assume an Option inside a large function removes its stack frame.** Linked code must prove it. The negative borrowed-array result is a warning against source-spelling optimism.
15. **Ignore first sparse seed/copy or dense fallback cost.** It biases real interaction results.
16. **Benchmark fresh full targets against persistent repair targets.** It measures an unfair allocation/resource lifetime difference.
17. **Run timing with a fresh oracle/diagnostic capture in the measured hook.** Correctness and telemetry must be separate, with the synchronous GPU/readback/ACK boundary labeled honestly.
18. **Treat ignored/zero-selected exit 0 as a pass.** Named gate helpers require one selected, one passed and zero ignored.
19. **Treat Git tracked inventory as all build inputs.** The missing historical gamut include, root config and inherited lockfiles already disproved that.
20. **Treat host-relayed facts as independent raw-code inspection.** Preserve their reported source and scope; linked claims require the corresponding actual artifact evidence.

### 12. Promising experiments still worth trying after the coherent path works

The following register is not permission to start parallel variants before the damage matrix. Each row needs an actual consumer, a matched adverse control and a named falsifier.

| Experiment | Expected mechanism | Main risk / falsifier | Measurement that decides |
|---|---|---|---|
| Retain lowered GPU groups | Reuse immutable validated common/placement blocks; upload only changed ranges | Global clip/correction relocation or shared max-error changes invalidates addresses; old/new group split/merge mutant | All groups/words walked, upload bytes, prep time, live+retired GPU bytes, complete output |
| Stable-handle CPU membership | Update only old/new affected tiles; merge unchanged ordered members with sorted additions | Dense ordinal projection secretly remains O(N); stale handle/generation/order mutant | Global walks, dirty refs, merge/sort input, directory bytes and full-path latency |
| Immutable command segments | Skip unchanged paint callbacks/resource re-description using paired local owners | Fat per-node owners, local namespace collision, unbounded history, literal COW cost | Segment headers, dirty amplification, old/new/retired peak, emitted commands and actual operation time |
| Completed-solve graphical-clean proof | Reuse whole owner when layout inputs changed but actual graphical outputs did not | Absence of Primitive alone misses clip/material/placement/global changes | Output comparisons, skipped callbacks, semantic/native publication, full cold pixels |
| General private output image | Repair actual old/new tile union for every admitted mutation; full-copy arbitrary callers | Storage/domain confusion, diagnostic second owner, dense/seed copy regression | Rasterized pixels, full-copy bytes, cold/first-sparse/warm/dense latency and owner peak |
| Material coverage proof reuse | Preserve cuts only for exact unchanged proof class; update color without rebuilding geometry | Alpha/image/signed-zero/FTZ proof changes; disable-revocation mutant | Cut recomputation, skipped contributors, exact pixels and material update cost |
| Stable clip pages/chains | Retain immutable ancestor-linked clip resources without global rebuilding | Exposed old support or wrong generation/owner; ancestor clip mutant | Clip nodes copied/lowered, retained page capacity, dirty tile expansion |
| Dirty atlas/resource upload | Upload only changed full-key glyph/image material versions | Same nominal ID with new pixels/opacity or old queue reads | Unique backing charges, upload bytes, queue-retired peak, exact sampling |
| Work-balanced row scheduling | Split heavy selected rows by admitted work estimate without changing painter order | Scheduler overhead, cache/stack pressure, hidden rescan | Jobs, split/probe counts, worker utilization, scalar/parallel exact stats and end-to-end time |
| Small uniform driver / sampled continuation | Avoid constructing the large Samples frame on truly uniform bands | Same-function frame retained, state replay, changed stats; actual band census may show little eligibility | Linked frame/init bytes and real uniform-band distribution before timing |
| Fractional interior/mask classes | Replace dense per-pixel sampling for certified disjoint footprints | Shared pixel, site-order rounding, empty-search sentinel | Original animation census, exact old binary outputs, axis queries/encodes/stores and whole-path time |
| Integer opaque spans | Avoid CSR/Samples in genuinely integer opaque scenes | Original animation is fractional; unsupported late command or store-budget error | Actual immutable case eligibility, 2N store accounting, dense adverse/control timing |
| Reuse admitted text groups | Skip repeated font/key/bounds preparation while keeping packed glyph/raster owners | Child inline source dependency or global mask dedup/error ordering | Glyph/layout calls, witness copies, full-key resources, actual text interaction pixels/time |
| Bounded spare staging buffers | Reuse one empty command/metadata allocation cohort after commit | Idle memory growth or triple owner peak; failed newer must retain old C | Allocation traces and retained/staged peak across fixed-size churn |
| Adaptive MaterialUsers construction | Dedup or bucket only when real E/U/skew makes it worthwhile | One-hot dense regression or extra retained E-sized owner buffer | Actual edge census, comparator/scatter work, cold dense/sparse latency and peak |
| Eliminate overwritten CSR zeroing | Avoid initializing membership words that will all be overwritten | Uninitialized read/drop/rollback; unsafe builder proof burden | Actual memset share of cost, memory-safety/failed-admission gates; do not adopt on theory alone |
| Output encoder reuse | Reuse exact working-color/config projections beyond adjacent uniform pixels | Wrong HDR/SDR/mapping/reference-white key; source-bit mutant | Encode counts and full output across all admitted configs, not only visual equality |
| Persistent ordered node/group runs | Avoid full mandatory metadata rebuilding when unchanged topology dominates | A second topology authority or unstable parent/rank aliases | Metadata entries visited/copied, insertion/removal/reorder tests and aggregate memory |
| Ordinary layered overlap | Retain composited work only under actual transform/clip/resource dependencies | Named popover fallback, filter/readback nonlocality or order loss | Real popup/scroll/overlap operations, full cold pixels and actual damaged work |
| Reusable readback/staging leases | Reuse only after map/unmap and queue completion | Early reuse with pending copy or extent/format change | Observed overlapping leases, staging peaks, full bytes and completion time |
| Batched material descriptor updates | Patch changed value runs under stable bank identity | Bank-mode shader switch or stale in-flight value version | Descriptor/upload bytes, queue order, exact HDR/zero behavior and pending-history tests |
| Conservative support refinement | Tighten inflated support only with exact inherited AA/filter/clip proof | Under-damage outside logical rect or changed tile proof path | Old-support/clip-expansion mutants, dirty-vs-full work and exact all-pixel differences |

The dominant priorities are the first five rows: actual old/new membership, actual target ownership and actual unchanged command work. Micro-optimizations should not replace them merely because they are easy to compile.

### 13. Performance protocol and realistic graphs

Historical reports placed CPU raster work around 84–94% in the examined interaction path. That is context, not a current measurement of the new checkpoint. It explains why eliminating only a 6–16% preparation slice has an ideal Amdahl ceiling of roughly 1.06–1.19×, not 10×. A sparse target that replaces most raster work with a small dirty fraction plus a full output copy can have a different ceiling; the copy, seed, validation and unchanged fixed work remain floors.

#### 13.1 Preserve the actual operations

Use the immutable original grid hover, solid-grid resize, fractional animation, popover insertion/removal/scroll/follow-anchor and real text-wrapping resize as distinct cases. Do not replace fractional animation with aligned rectangles, collapse the two popup intermediate flushes, omit cold state, or rename a new text fixture as the original solid grid.

Every selected seed/warmup/measured subframe needs correctness preflight outside timers. The prior GPU matrix does not cover a later history just because the scenario name is equal. The proposed 8-warmup + 32-measured software pilot reaches beyond the earlier 0–31 history and therefore needs its own complete preflight. Three balanced pairs are a bounded pilot, not the original 240-sample precision contract.

#### 13.2 State the boundary

For CPU, specify whether the total includes source admission, realization/layout, canonical preparation, resource work, membership, kernel, full caller copy and actual native presentation. Report narrower phases separately without subtracting inconvenient work from the headline.

For software GPU, use matched persistent full and repair targets with the same pipeline/resources. If completion includes full host-readable output, include encoder/copy/map/wait/readback and extent reallocation. A hook before ACK creates a synchronous instrumented architecture; it is not native hardware latency. Per-readback channel/encoder allocations are still allocations even if the timing vector is pre-reserved.

For target reuse, cold seed, first sparse seed, warm sparse, dense and resize must be separate. A fallback cell belongs in the graph; filtering only eligible cells answers a different question.

#### 13.3 Identity, pairing, and adverse gates

Freeze source tree, required assets, dependency locks, Nix shell, stable compiler, target ISA, feature/profile flags, actual ELF freshness, adapter/device, worker count, environment and histories. Record author versus reconstructed host identity honestly. No benchmark during another lane's busy window; the controller grants the quiet window.

Run balanced paired processes and preserve every pair. Predefine slowdown/memory ceilings and stop/promotion rules. Do not report only the best median. New codegen improvements need linked caller/callee/frame/initialization evidence, and code size must not be attributed solely to a memcpy if tag/iterator control also changed.

#### 13.4 Graph set to produce from actual data

1. Per-case whole-operation latency: baseline, current full control, actual damage consumer; show all pairs and interval/dispersion.
2. Cold/first-sparse/warm/dense decomposition, with full copy/readback visible.
3. Work elimination: commands emitted, groups lowered, tiles/references scheduled, sample tests, upload bytes, output bytes and fallback reasons.
4. Retained + staged + retired memory high water; logical capacities, allocator requested bytes and RSS/GPU measurements remain separate axes.
5. Parallel scaling at 1/2/4 workers under exact output/stat parity, with scheduling and stack/cache costs.
6. Eligibility on the entire realistic history, including popover/text/resize, not only synthetic solids.

A graph drawn before the actual coherent consumer passes is an architecture illustration, not a performance result. The repository should keep raw JSON/CSV, every pair, analysis scripts and identity manifest alongside final plots.

### 14. Roadmap to actual innate damage, in dependency order

1. **Freeze one coherent checkpoint.** Merge reviewed deltas by content/lineage, preserve failures and original assertions, and keep mandatory assets/locks. A checkpoint can be useful without claiming release readiness.
2. **Close current real failures first.** Re-run the exact hard-full fixture after the test-only repair, then the remaining named/full cohorts. Do not erase the original failure or infer the now-reached slot/recovery assertions passed.
3. **Complete actual producer receipt integration.** C sequencing must be independent of draw/P tokens; metadata retains full semantic publication. Raw input questions and actual placement/clip/material outputs need the completed-solve proof, not inference from absent Primitive alone.
4. **Bind one actual output consumer.** The checked-paint cache is a scoped baseline, not the general answer. The host catalog/R4 path must consume accepted old/new snapshots and target-domain dirty union for ordinary popover/text/scroll/resize and failure histories.
5. **Execute the mixed target matrix.** Especially C0 image → paint C1 pending → metadata C2 → paint C3 → one output. Add prewrite rejection, partial write, missed receipt, resize and old/new lease cases. Rebase index metadata without promoting image/ACK authority.
6. **Remove whole-scene preparation only through the consumer.** Retain validated lowered groups and resource/correction addresses, merge only affected membership, and price dense ordinal projection. Metadata-only proofs cannot be advertised as prep/upload elimination.
7. **Use the geometry/paint split for measured sharing.** First prove mutation/layout/allocation invariants; then introduce bounded complete-group local owners, exact bank/value/resource lifetimes and retirement. Do not allocate one fat list per rectangle or retain predecessor Canvas chains.
8. **Run realistic paired benchmarks in an approved quiet window.** Correctness outside timers, same targets/resources, explicit output/native boundary, all cases and adverse gates.
9. **Publish graphs and limitations together.** The user asked for real interaction improvements, not a collection of optimistic isolated variants. The common path and its measured fallback cells are the deliverable.

### 15. Source and artifact registry for checkpoint collection

These pins identify source provenance. They are not substitutes for the actual host tree/ELF identity.

| Item | Exact pin / identity | Scope |
|---|---|---|
| Corrected first assembled prerequisite | `11d4bb3929b00255ba566c7411dd7613163f3308` | Receiver/stable-cfg compiler fixes preserved |
| Bound publication / actual readers | `71891f557b40e42495cb8dbcd4cdce4fcb0611f1` | Early Canvas source checkpoint |
| Precommit slot witness | `910852bd24f56cabe2953873caaaace3450345cf` | Borrow-scoped actual edits/readers |
| Closed receipt / Material guard | `58658123114570054a901285e58733eb083f7926` | Pre-fusion base |
| Fused Canvas recording | `28dc3cb9597f799931fb8ce43ffc7586eecba21d` | On closed Canvas base |
| Actual producer/refinement origin | `e3d9221f84f020fae87a3fbf09fed1ba9753ca26` | Must preserve later C allocator when porting Runtime |
| Material owner indexes | `41c5ee921d0dfa6abba7aca3f14f9cd8f24dfff7` | 8-byte edges / 4-byte users |
| Receipt-history fixture | `ee0ab00b4a23657e0bb407f47c4885d4388283f6` | Skipped output / failed newer / reversion |
| Shipped ordered rendering | `b02f3b90bc6edb7ffd377e9801142febb65f2981` | Fusion + compact users + fixture |
| Hard-full test repair | `539973331b2409adb746966d0bbcc778b9766f6e` | Test-only, production unchanged |
| CSR end-offset cut | `5c458586ff7e7dd2bdfcb2dcea3f30447e7d7e1a` | Independent one-file descendant |
| Strict transaction on fused base | `bf52c3682d8e5bd2fc0ef3c5cb388a312d668ba6` | Requires positive core schema |
| Same strict transaction on pre-fusion base | `47ca43cf43304b5ecf3821b3a5c91e267dadc500` | Distinct lineage; do not force-substitute |
| Geometry extraction before integrated correction | `cedf50fcab0384b273990df909641de84aaa8833` | Pre-fusion source checkpoint |
| Reviewed integrated geometry | `f414f7e857ffd16ac7053ce63df2948b8900dd37` | Original fixture bytes preserved |
| Corrected integrated geometry final | `14e3e6ed267838d8c150ec425f2421fbfca5b9a8` | Production same as reviewed f414; common fixture corrected |
| Positive non-graphical core origin | `4a5ffa8df5d889beba917f8369d02df4fc87d335` | Import tiny helper diff, not its whole newer parent |
| Source-only GPU index proof | `e8b99316298c9c0272c01d7df4e27f94028bb5d3` | cfg(test), not the production target consumer |
| Host production catalog report | `fb019539fa55e679696f836ceac4078f849257a4` | Nine focused tests reported |
| Hardened GPU geometry author | `464bfdddc07a34bf8ed5e37980ccf1fdef6428b2` | Qualified software-GPU scope only |
| Exact diagnostic source origin | `33e5adf08deb4ec1a04266ec2d94fbb40fef0425` | Independent full-GPU output oracle |
| Cache fixture-corrected candidate | `91cac8a804266368ce3baf6def7e18dbccee5244` | Preserve allocation failure evidence |
| Cache tiny-grid B | `db30008693a4389cff361484adf86271068afd2a` | Separate scoped consumer candidate |
| Integer span candidate/control | `73a6aff9f18c9e4881692b36d48ba4df3f39f13d` / `4899459b3f981e681fe7b2a772dca559e4508267` | Default-OFF, not original animation win |
| Fractional final candidate/control | `48dbb8d` / `7b270ef` | Frozen source-only controls; collector should resolve full objects |

#### 15.1 Reviewed transport artifacts

Historical workspace artifact paths below are provenance references, not assertions that these files are present in the collected repository. Preserve available bundles through the collection manifest:

- `gui-comparison/render-lane/next-rendering-source-v1.tar.gz`: 37,165 bytes; SHA256 `cd906a22c9a007c99eb0854840ea8a5854378114deff9b12bc681a0dfb77fddb`.
- `gui-comparison/render-lane/hard-full-fixture-source-v1.tar.gz`: 4,668 bytes; SHA256 `c89d32dcb4d2ef0d2644d311d219ffd3f7a7c684971ecf4b1c47658959789224`.
- `gui-comparison/render-lane/csr-end-offset-source-v1.tar.gz`: 8,978 bytes; SHA256 `2fff0c730da6f0ff4cc2ffe590fa03c90df8ea81dda65b31fbed313139ec3cbb`.
- `gui-comparison/render-lane/draw-geometry-extraction-source-v2.tar.gz`: 35,191 bytes; SHA256 `755cc1902b8f882d264d6676d56ef654fddc06204c422c087a392452656d02db`.
- `gui-comparison/render-lane/canonical-required-input-repair-v2.tar.gz`: SHA256 `e04e5ef53255ad5c3cb8dfd604ac695a3916e7993224fb8a79182b1f62bca82e`.
- `gui-comparison/cpu-raster-lane/paint-cache-thin-v2.tar.gz`: SHA256 `07f3dffa20ca4c15740f1a28a6e310714f42950ae3efc803ba57376b4fae81f9`.
- `gui-comparison/cpu-raster-lane/fractional-span-v1.tar.gz`: SHA256 `8d9af3c57551352e522a24219711bdc3b4771a3d75362e5b513b842a24e5f205`.

The geometry packet explicitly guards both original and already-applied CSR source variants. It requires the host's R4 private receiver adapters; it never replaces the executor with an old file. The canonical-revision Runtime and newer core phase work remain separate and must be composed without overwriting them with an older complete core file.

The historical gamut fixture is not an invented replacement: Git blob `e25ee83dfb400430ed545e1fe35e5cb4fd9c0343`, 136,745 bytes / 1191 rows, SHA256 `b93285544c9d661d4424513a5e8d5417a1032f2876196adac4857c0e41d771dc`. Required-input preflight also covers ignored root config and inherited lockfiles. A tracked-file list is not complete build input authority.

The authorized attached R1 executor archive has SHA256 `ca4a07d6a9b84568fd63d8f6eceba957fc50cf2b4cca601b80b031e86368d85c`. Its source is the historical R1 checkpoint, not the newer R4 wrapper. Host-reported linked facts remain explicitly host-reported.

#### 15.2 Files worth preserving alongside the brief

Keep the rendering handoff/history; source and invariant reviews; `TARGET-RECEIPT-CONSUMER-CONTRACT.md`; `IMMUTABLE-COMMAND-OWNER-MIGRATION.md`; material-user cost/negative-construction notes; the exact guard and named-test validators; immutable original interaction fixture; corrected source manifests; finite interval/axis/partition/CSR models; and original failed/mutant/restored logs. They explain why the current contracts exist and prevent repeating attractive but invalid shortcuts.

### 16. Bottom line

The architecture is moving toward innate damage, but the word should describe one actual composed producer/index/target pipeline, not the union of isolated proof claims. The next success criterion is ordinary realistic interactions with exact complete output, correct pending/failure/P semantics, bounded ownership, and recorded whole-path work/time. The current checkpoint is valuable precisely because it preserves both the working pieces and the remaining boundary honestly.

<a id="chapter-4"></a>

## Chapter 4: Correctness, authority and completion

## Correctness, authority boundaries, remaining risks, and completion gates

This section documents the retained UI and canonical-damage work as a correctness protocol, not as an already-qualified performance result. Source candidates, compiler corrections, isolated tests, composed application tests, and actual target-image tests are different evidence. Passing one does not imply the others.

Paths below are repository-relative. Source references use the `reactivity/` tree represented by the candidate packets. Final integration identity and executable qualification must be read from the accompanying integration manifest; do not substitute a convenient worktree or a later untested descendant.

### Collected source identity and qualification boundary

The independently audited code-only collection is
`3c5cc3330cf6e6878489a55f1ab7218731a379af`. The reviewed documentation checkpoint
is `783358f432e9e8edef9865a1cd096148d3af774c`; its only differences from that
code pin are two documentation/inventory files. All36 listed authored source
files matched their recorded byte lengths, hashes, and code-pin contents, and
the reviewed collection was clean. This is a source identity audit, not a full
build-input or executable qualification.

The collection includes the canonical metadata and exact style cuts, solver
observations, scoped text/resource work, and recorded Canvas ownership. Its
renderer storage deliberately selects the reviewed **pre-R4** bodies from
`bf52c3682d8e5bd2fc0ef3c5cb388a312d668ba6`; the intermediate later-geometry
composition is preserved but is not silently substituted into this collection.
The actual host target/index wrapper and consumer adapters remain a separate
completion blocker. No final-composition compiler, runtime, pixel, mutant,
native, or benchmark result is implied by this identity audit.

### 1. The authorities that must remain separate

#### Logical source state: S

`source_epoch` identifies admitted logical source operations. It is not a presentation receipt or an image-buffer age. Multiple admitted edits may occur before one canonical publication. A resize may change canonical output without advancing S.

An admitted operation is not universally rolled back when later preparation fails. `EditTurn` deliberately retains an accepted logical prefix when dropped; it does not publish in `Drop`. A source setter may report a committed-error result when the value was accepted but subsequent description/layout/painting failed. Tests must distinguish rejection before admission from failure after an admitted edit.

The live logical cohort includes current nodes, styles, source fanout, handlers, list realization state, and full-identity indexes. Its `logical_valid` bit must describe the *current working cohort*, not whether an older complete frame exists.

#### Accepted canonical state: C

C is the immutable scene actually accepted by Canvas, with its exact mutation batch, semantic group partition, source epoch, snapshot generation, and optional closed dependency receipt. It is not the most recent attempted scene.

The canonical revision is owner-qualified and monotonic. It is distinct from S, from the draw token, and from a surface generation. A failed preparation must not advance canonical history, clear its pending journal, or install partially built metadata.

The shared definitions are in `crates/core/src/change.rs`. The concrete scene/metadata binding is in `crates/canvas/src/canvas/publication.rs`. The GPUI producer and dependency adapter are in `crates/gpui/src/runtime/changes.rs` and `crates/gpui/src/runtime.rs`.

#### Public draw token

`PresentationToken` identifies an eligible complete graphical candidate for the window's presentation/ACK protocol. A strictly non-graphical canonical transition can advance C while keeping the same draw token and the same command/resource owner. Therefore `C.sequence == draw_token.sequence` is not a valid invariant after metadata-only publication.

Conversely, an unchanged draw token is not evidence that no canonical edge was accepted. A consumer that misses an intermediate metadata edge must detect the canonical predecessor gap even though graphical bytes did not change.

#### Acknowledged presentation: P

P is the geometry/semantic sheet associated with actual acknowledgement. In recording/native-style operation it can lag C and S. Rendering or borrowing C is not an ACK. Surface loss revokes coordinate authority without destroying the older coherent commands used for recovery.

A newer failed candidate must not make the older eligible draw token unusable merely because S advanced. Acknowledging that older candidate must install only its coherent sheet/coverage, not the newer failed logical state.

Presented observation and actionable target minting are deliberately different APIs. `Query::count` can inspect a valid presented sheet without minting a new target. `Query::one` additionally requires a current presentation. Thus pending graphical work or a failed-newer logical prefix can leave old-P names observable while new actionable target minting returns `PresentationStale`.

Relevant code: `crates/gpui/src/runtime/query.rs`, `runtime/metadata.rs`, `runtime/paint.rs`, and `Runtime::acknowledge`.

#### Completed target image

A backend target has a separate authority: which exact source revision its physical pixels represent. Its domain must include actual storage identity, surface generation, extent, format, and relevant configuration. A matching scene sequence alone is not target identity.

An accepted but unrendered C may advance a target's admitted/pending revision and damage union. It must not advance completed-image authority. Canonical publication, joined leaf jobs, internal packed-cache repair, external destination copy, native presentation, and GPU completion/fence retirement are distinct boundaries.

The current consumer contract is `supporting/TARGET-RECEIPT-CONSUMER-CONTRACT.md`. That document is a contract and test obligation, not proof that the current host-owned target wrapper implements it. At the last cloud review, that actual host wrapper/catalog implementation was not available in the local source set. End-to-end qualification therefore requires the exact host-owned implementation and composed executable, not inference from the contract or an isolated leaf executor.

### 2. Required transaction ordering

The safe publication order is:

1. Admit the logical operation under its actual owner/context and classify its changed inputs.
2. Retain pending typed facts, earliest old support/input evidence, and any required resource leases.
3. Resolve the current topology/full-capability mapping before consuming logical indexes as solver handles.
4. Compute the shared bounded logical closure and actual solver/output facts. Missing provenance, unknown support, or budget overflow must remain explicit conservative reasons.
5. Prepare all fallible canonical metadata, group-range, resource-read, and publication-ticket work while old C is still intact.
6. Commit the actual Canvas scene or checked slot transaction.
7. Commit the matching journal/publication metadata and accepted derived state without a recoverable failure in between.
8. Only then reset/rebase optional history whose baseline is accepted C.
9. Independently admit and complete target work. Revoke image authority before the first physical write.
10. ACK only according to the actual presentation protocol.

Returning an error is not enough to prove rollback. The audit must identify which phase changed model values, logical indexes, solver lanes, canonical resources, completed pixels, and P. Each error path must preserve or explicitly revoke the appropriate authority.

#### Pre-admission rejection versus admitted failure

Missing/foreign resource context is a pre-operation rejection. It must occur before owner callbacks, logical mutations, or retry-sensitive pointer/IME session consumption. A later rendering failure after an admitted input event may legitimately retain the logical prefix and consume that event; do not promise wholesale rollback of external input state.

The scoped path uses a borrowed `ResourceContext`; the window stores its accounting witness rather than silently acquiring an ambient App owner. Ordinary mutation entry points reject a scoped window without the matching context. ACK, accepted-scene reads, readback, presentation loss, and counter reset have a narrow callback-free access path. That whitelist must remain explicit. The current contextful `EditTurn` surface does not by itself imply a completed contextful native input/scroll API.

Relevant code: `crates/gpui/src/runtime/edit_turn.rs`, `runtime/input.rs`, `runtime/ime.rs`, `runtime/delivery.rs`, and `tests/resource_scope.rs`.

### 3. Logical identity and topology invariants

- A logical site is owner-qualified and never replaced by a reusable vector ordinal.
- Core `NodeId` includes arena, generation, and slot. A foreign arena or retired generation is not a valid handle even if its numeric slot matches.
- The retained layout mapping must round-trip the *full* current capability: logical index → full layout `NodeId` → current logical index.
- Description preorder, parent identity, scope ownership, keyed-list identity, and component remount rules all participate in retention. Equal kind at a shifted unkeyed ordinal is insufficient.
- The retained inverse must be current before dirty logical identities are translated into solver handles. Inspector and other late updates must not use an old ordinal mapping after topology edits.
- A successful topology edit is not established solely by stable public logical targets. Tests also need the private `LayoutNodes::Edited`/same-original-handle witness and complete inverse round trips to exclude silent arena rebuilds.

Relevant implementation: `crates/gpui/src/runtime/layout_nodes.rs`, `runtime/identity_index.rs`, `runtime/siblings.rs`, `runtime/links.rs`, and `crates/core/src/tree.rs`.

The reverse-preorder sibling frontier is valid because each subtree is contiguous in admitted preorder and active parent keys are unique. One completed child-frame pop is sufficient under that contract. This is not a generic arbitrary-graph stack algorithm. Its retained capacity is O(depth), worst-case O(N); tall/comb trees must be priced alongside broad forests. Replacing an associative map with an N+1 dense vector was not automatically a memory improvement.

Viewport ancestry/subtree bits are derived from the *new complete description*, cleared on reused links, and closed over actual preorder edges. They are not stale flags copied from the previous window. Empty lists and Scroll-only trees are required controls.

### 4. The late-description failure that motivated phase revocation

A real source-level bug was identified in the old scroll error path. The wrapper restored `logical_valid` for every rejected presentation-only scroll as though rejection always preceded reconciliation. But `describe_inner` destructively took handlers/styles/nodes before late aggregate gradient admission. `background::reconcile` could then return `ResourceLimit`, leaving an old identity index paired with an empty current node vector. Restoring logical validity could permit a stale lookup/panic.

The correction revokes logical validity immediately before the first destructive take. The entry-time identity-reuse decision is captured separately. Only an early rejected scroll whose cohort remained intact may retain logical validity; a late admission failure may preserve older C/P without authorizing broken working indexes.

`tests/late_scroll_resource.rs` is the natural public falsifier. It uses 256 distinct legal maximum-stop gradients: 262,192 bytes each, totaling 67,121,152 bytes, exceeding the 64 MiB aggregate limit. The row count/depth remains small, and gradient rasterization is not reached. Its older safe frame contains an image and gradient so the test also exercises old Canvas resource ownership after the logical image bank is replaced. Required assertions include early rejection authority, exact old token/P/full BGRX, clean stale-target rejection rather than panic, legal old ACK, and later valid repair without reviving old targets.

This is not a helper-only artificial state test, nor proof that all allocation/OOM behavior is transactional.

### 5. Canonical publication is concrete ownership, not public integers

Public revisions and group IDs are witnesses, not permission to reuse arbitrary pixels. The accepted-scene view must bind the exact immutable scene instance to its metadata. A generic public `accept<S>(scene, stamp, groups)` wrapper could not establish that: a caller could issue different arbitrary scenes under one own-domain revision, and generic S could contain interior mutation.

The concrete design instead consumes a non-Clone/non-Copy publication receipt into one Canvas-owned binding. Immutable borrowing pins that owner against mutation. Full scene commit validates metadata/group ranges/material users before mutation. Ordinary canonical mutation revokes the binding; checked slot publication is the explicitly admitted preservation path.

Important invalidation sites include full scene commit, clear, literal/slot paint mutation, clip publication, and command/resource additions. New mutation APIs must either revoke the binding or join a proven checked transaction. Merely updating a token is not sufficient.

`SceneGroups` has private validated metadata: owner/revision/source/snapshot agreement, unique site IDs, complete contiguous own-command partition (including zero-draw nodes), and contiguous preorder ancestry. Earlier-parent DAG validation alone was insufficient for subtree assumptions.

`MaterialUsers` derives actual slot users from accepted commands/group membership, not caller annotations. A paint-only retarget must cover every actual changed material user's semantic owner. A full/truncated/unknown journal cannot certify absence of graphical edits. Empty slot transactions are particularly dangerous: they require the strict non-graphical raw-and-closed proof, not a caller's empty edit list.

The full admission currently has real costs: complete group/span traversal, edge collection/sort/dedup, and material-user CSR allocation. Do not describe it as globally scan-free.

### 6. Shared changes and dependency closure

The mutation algebra distinguishes at least:

- topology/order;
- layout/assigned constraints;
- text source/policy/wrap width;
- local/world transform;
- clipping;
- material color;
- primitive content or membership;
- resource pixels/metrics;
- hit/semantic state.

Paint must not mean every possible graphical mutation. Same-alpha material color changes may preserve geometry; opacity changes, source-to-literal binding changes, gradient membership, caret/selection primitives, and checked-state primitive changes cannot impersonate a material-only slot update.

#### Boundedness and provenance

The journal coalesces earliest old/latest new facts by full logical site and keeps overflow/full reasons sticky until successful C. Dropped prepared guards preserve pending facts; only successful matching C clears them.

The closure queue deduplicates and caps *before enqueue*. Early full paths return before seeding partial work. Merging old/new closures must cap the existing set against the smaller limit even when the incoming set is empty or a subset.

Computed `Invalidated` fields must remain private. Exposing mutable `full` or `artifacts` would let a caller remove downstream work or clear a hard fallback while retaining source seed phases, then seal a misleading receipt.

A closed receipt binds the exact journal mutation serial and graph provenance. Source serial alone is insufficient when read edges change without a new input fact. Opaque unique graph domains plus checked mutation generations cover reset/register/edge/finish/rebase and committed resource-read changes. Dropped staged read changes preserve the accepted version. An exhausted after-graph is not equivalent to no after-graph.

Old/new graph universes require phase-aware membership: a newly inserted site is absent from OLD; a removed site is absent from NEW. Those are allowed only for the corresponding Empty side. Missing retained sites must still be unknown/full. Otherwise every insertion/removal degenerates into full rebuild—or, in an unsafe implementation, missing dependencies are ignored.

Graph completion counters are consistency checks, not automatic discovery of every real read. Producer schemas and actual read registration remain correctness obligations.

#### Stable resource reads

The rejected generic persistent derived cohort admitted stale Group/Tile generations and complicated rebase. The narrower `ResourceReadPatch` retains stable ResourceId→owner-artifact edges. It validates owners, bounds changed owners and raw input count, stages only affected reverse buckets, and admits root hash-table capacity before allocation-free graph commit. Snapshot-local group/tile expansion remains separately generation-qualified in the common bounded queue.

This does not eliminate unrelated work elsewhere: the current `ArtifactStore::commit` still scans accepted derived owners and may allocate BTree metadata. Standard-container overhead, staged/retired leases, and global allocation aborts remain distinct from charged retained payload.

### 7. Solver correctness and what the current cut actually removes

Cephal already owns dynamic layout-question dependencies and value-change stopping. `vendor/cephal/src/schedule/mod.rs` replays cached questions deepest-first and propagates unchanged, overflow-only, or full answer changes. `crates/core/src/layout.rs` adapts this retained solver.

An eager parent Layout↔child Layout graph SCC premarked the entire connected tree and defeated that existing mechanism. The bounded scheduling cut removes those mirrored edges while preserving:

- direct changed style/measure owner admission;
- immediate-parent invalidation for child style fields read outside cached answers;
- cheap empty-leaf redirection to its parent;
- topology edit parent invalidation;
- solver cache eviction, hidden/context/OOF, viewport and generation fallbacks.

Final `Layout` writes are streamed before non-speculative overwrite, with full `NodeId`. The optional journal retains earliest before/latest after across failed attempts and clears only after successful C. Its internal 64-entry policy has a <=16 KiB inline key/value bound; BTree overhead is additional. Initial/rebuild/structurally incomplete history does not allocate new unusable records. A comparable-answer gap can still retain bounded final-write evidence; it does not certify a complete solve. An arena rebuild makes reconstruction explicitly incomplete.

Final `Layout` alone does not contain every `LayoutOutput` baseline/margin/OOF or size-only answer. The comparable-answer observer therefore uses the comparisons the scheduler already performs. Fresh computed/cheap questions require exact node+full-question replay provenance, including signed-zero float bits; nested fresh child questions are not authorized by their parent's replay. Hidden helpers and direct root/initial-containing-block OOF routes explicitly report gaps. Missing/evicted/context-bound/unstored/newly observed questions also remain gaps.

A successful solve is not clean simply because no event arrived. Clean output closure requires no gap/overflow/topology/config reason, current capability resolution, and a bounded complete output cohort. The generic first positive is a same-metric image replacement: real pixels change but comparable metrics remain unchanged, unrelated peers stay cached, and full cold output agrees. Image type is not an admission switch. Changed metrics, parent-width wrapping, and overflow/gap controls must retain conservative fallback when evidence is incomplete.

Input invalidation and output change must remain separate. Removing eager `Facets::Layout` placement seeding is insufficient if `Phase::Layout.downstream()` still reintroduces Placement. Text source/policy still affects its own primitive even if metrics remain unchanged. Padding/scrollbars/content width affect own text/image placement even when outer size/location do not change.

The current input/output cut does **not** eliminate parent Placement/Clip dependency traversal, full presentation/group lowering, or the Scroll transformed-extent pass. Count actual computed/cached answers, measure calls, changed layout writes, input/output closure artifacts, and complete scene visits separately.

### 8. Placement/clip reconstruction prerequisites

Child world space is composed from inherited wide parent space, effective parent viewport offset, its own local layout location, and its own local transform. Parent size or baseline alone does not change a child's world transform.

However, own size can change an active outgoing clip or viewport; nested rounded clipping can change with an identical AABB; omitted list rows can alter published semantic ancestry. Raster clip, hit clip, semantic chain, published-parent identity, and list/scroll membership are independent outgoing channels.

Comparing rounded P/Canvas f32 transforms is unsafe. Wide `CoordinateSpace` retains f64 intermediates and uncertainty. A recorded arithmetic falsifier uses f32-authored scale products that round to the same parent f32 transform yet produce a different descendant f32 translation after cancellation.

Do not add an unconditional per-node f64 mirror merely to compare spaces. A bounded earliest-old local-input journal plus current unchanged inputs can reconstruct old-C/new paths under explicitly supported topology/config/scroll conditions. It must capture *all* writes since old C, including failed newer work. Current narrowed P geometry cannot fill missing before images. Missing ancestry, changed arena, unrecorded transform/clip/scroll input, or budget overflow remains full.

Even exact context reconstruction does not alone permit skipping full command/presentation construction. Immutable accepted-group reuse, material/text/resource membership, and semantic visibility must independently qualify. Price those prerequisites before claiming a walk disappeared.

### 9. Metadata, untracked providers, and compatibility

The old one-epoch metadata guard protected against relabelling an older graphical C after a failed newer prefix, but also blocked legitimate multi-edit metadata-only turns. The replacement is a strict positive non-graphical raw-and-closed proof, not relaxed arithmetic.

Dirty/invalid/layout/topology/history guards remain. Proof decline leaves metadata logically pending and does not retry failed graphical preparation or patch P. An explicit later settle/present may take full recovery. Tests must exercise C2 metadata/draw1 → graphical C3/draw2 → metadata while draw2 pending → multiple metadata edits/one C → failed newer graphical + metadata + old eligible ACK → repair → same-S resize.

Untracked `ItemSource` is pure only during a description. A legal externally shared length may change between turns. Blanket resize realization removal therefore changed observable behavior. `tests/untracked_item_source_resize.rs` and `tests/untracked_observation_boundaries.rs` preserve the distinction: a historically disjoint source transform does not observe external list mutation, but the established resize boundary does.

The optional source-observation experiment must be labelled separately and remain default-off until its complete read-set promise, registered revision/projector incarnation, bounded metadata, panic boundary, and retired/retargeted-source controls qualify. Never silently impose across-turn immutability on legacy providers.

**Known coverage gap in the collected source:** `crates/gpui/tests/disjoint_transform.rs` has a whole-file `cfg(feature = "source-observation-experiment")` gate. A default-feature run therefore does not execute its original cold-output, failed-newer, old-ACK and observation-boundary controls. Passing a default suite cannot be reported as covering that file. The default integrated cross-product and `tests/untracked_observation_boundaries.rs` provide narrower controls, not equivalent registration of the historical family; the broader restoration alternative is preserved separately, not selected here. Preserve and restore the legacy default controls independently of the experimental tracked-source fixtures, then run both declared configurations; do not remove the cold or authority oracles to obtain a green count. This is a test-coverage limitation, not an observed output failure or proof that another test covers the same history.

The source-region compatibility predicate restores the existing clean disjoint Paint/Transform observation admission. It is not a scenario-name dispatcher and grants no output cleanliness or partial-raster permission. Original cross-product work assertions remain requirements unless an explicitly justified contract change is reviewed.

### 10. Known failures, corrections, and evidence limits

The following were real failures or concrete defects, not benchmark hypotheses:

- Late scroll resource admission could restore a broken logical cohort; phase revocation and natural public regression were authored.
- A retained test merge lacked a closing brace; a one-brace test-only correction and bounded lexical checker were added.
- A strict `name("popup").one()` selector matched both a named container and text fallback; role-qualified selection fixed the fixture without weakening uniqueness.
- Source handoff Python had an undefined variable/artifact-path bug; source inventory guards and actual embedded-block synthetic tests were corrected in separate packets.
- A timing summarizer failed under prescribed isolated Python import semantics; canonical process-directory/command uniqueness checks also required correction. No synthetic timing result is a real benchmark.
- Feature-on packed-cache allocation accounting incorrectly asserted the default engine ledger. Exact feature header/bitmap costs were separated from the later tiny-grid tracking optimization.
- Actual compilers found mutable receiver borrow errors, missing Hash derives, wrong module path/cfg placement, shared callback lifetime invariance, missing test imports, and a mapper parameter dereference error. Human source review and delimiter checking missed some of these; they never constituted compiler qualification.
- Actual host solver tests and observer/history tests passed at a corrected pin, while the existing cross-product then failed `descriptions: 1` versus `0` after popup translation. Earlier retained capability checks passed; later cold checks were not reached. The fix restores the proven region-local observation admission; the assertion was not discarded.
- Metadata lifecycle tests initially attempted target minting from stale P; they were corrected to presented-name counts plus explicit `PresentationStale` negatives, leaving production authority unchanged.

An earlier proposed native ID-alias concern was retracted after finding existing pre-projection namespace-exhaustion guards. Do not repeat it as an open bug.

Qualification must always name exact source/patch, stable adaptation, toolchain, feature set, font/resource inputs, and executable. Old isolated paint/cache/layout passes do not qualify the final coherent composition. Source-only packets and UNRUN mutants must stay labelled as such.

### 11. Minimum coherent end-to-end matrix

Use one integrated source identity and one actual target consumer, not separate favorable results from several worktrees. At minimum run one realistic window history containing:

1. Initial keyed text/list/scroll scene and acknowledged P.
2. Ordinary popover insertion between existing siblings, followed by retained capability/inverse checks.
3. Genuine one-source two-owner hover/color transfer.
4. Popover transform/layout/content updates and text edit/wrap.
5. Popover removal with old support/exposure repair.
6. Scroll, then extent shrink/clamped offset.
7. Metadata-only C interleaved with unrendered graphical C.
8. Resize/scale and explicit target-generation recovery.
9. Failed newer preparation, old eligible ACK, and valid repair.
10. A final complete cold scene/layout/pixel comparison with coherent target identity.

For target pending history specifically: completed C0 → unrendered paint C1(left) → metadata C2(same draw token) → paint C3(right) → one output. Empty metadata must not clear prior pending left damage or certify completed pixels. Include delayed multiple edges, removal under translucency, and A→B→A histories so latest-edge-only handling cannot accidentally pass.

Validate all active output pixels and documented padding policy, exact semantic/visible rows, stable expected targets/handles, current full inverse, accepted batch/closed receipt, and target completed/admitted/pending revisions. Compare work only after these oracles pass.

### 12. Missing adversarial campaigns worth completing

#### Required before default-on or production speed claims

- Integrated full default and relevant feature matrices, not selected smoke tests alone.
- Real target consumer pending-union, old/new snapshot lease, prewrite rejection, postwrite failure, destination-copy failure, resize/storage/config mismatch, skipped-edge, and recovery tests.
- Property/state-machine generation of S/C/P/draw/target histories: dropped turns, repeated noops, metadata, logical retirement, failed newer, old ACK, surface loss and recovery.
- Exhaustive small ordered forests for topology/frontier/edit-plan composition and full inverse authority; retain tall/comb/broad cases and capacity measurements.
- Actual solver cold differentials for fixed/auto size, baseline alignment, wrap/stretch, cheap leaves, overflow/Scroll, hidden and OOF contexts, cache eviction and generation rollover.
- Resource lease retirement under accepted/unsubmitted/failed frames and queued readback; no resource release merely because logical ownership moved.
- Scoped context rejection before every callback/session mutation; separate admitted event failure semantics.

#### Discriminating mutants

A successful mutant gate requires the restored executable to pass first, a fresh mutant executable, the intended named assertion, restoration of source bytes, and a fresh restored rerun. Compile errors, missing tests, timeout, signals, or an earlier unrelated failure are not a useful kill.

High-value mutants include:

- remove logical revocation before destructive description;
- restore eager Layout→Placement/SCC propagation and kill actual work/artifact gates after cold equality;
- omit actual admitted Scroll or derived clamp facts;
- allow alpha/binding/primitive edits as material-only;
- allow empty slot transactions without strict non-graphical raw+closed proof;
- omit one actual material user or old removal support;
- clear target pending damage on metadata-only edge or after one of several delayed edges;
- mark image complete before joined jobs/copy, or restore old image authority after a physical write failure;
- ignore graph generation/journal serial/predecessor mismatch;
- compare only f32 parent transforms or clip AABBs;
- drop old scene/resource leases before physical old/new expansion;
- accept unknown retained site/foreign full handle;
- relax current-presentation target minting after pending/failed work.

#### Useful later experiments, not completion substitutes

- Bounded sparse local-input reconstruction versus conservative full placement walk, with exact f64/clip semantics and memory accounting.
- Value-change-aware solver read edges only where actual Cephal questions prove omitted reads; no blanket CSS/fixed-size heuristic.
- Compact changed-owner/ancestor frontiers versus map/vector representations over broad forests and deep chains.
- Material-user/index construction fused with mandatory admission where it genuinely removes a pass; account for staging capacity and failure behavior.
- Branch/cache/SIMD experiments in actual ordered compositing kernels, always against complete output and realistic predictor/resource history.
- Cold-start, first measured operation after validation, and steady-state campaigns separately. Include actual popover/text/scroll/resize workload histories; avoid relabelling a warmed first operation as cold raster.

### 13. Rollout and completion criteria

1. Freeze one coherent source and all required inputs. Preserve earlier packets and failure evidence.
2. Compile under the required pinned stable environment and symmetric approved adaptation; no alternate compiler is a qualification shortcut.
3. Pass full relevant unit/integration/negative-compile tests, then realistic composed history and actual target tests.
4. Execute intended mutants with precise failure attribution and restored reruns.
5. Record allocations, retained/staged/retired payload/capacity, graph/solver/presentation/bin/upload/copy work separately. Container and allocator overhead are not zero merely because payload is bounded.
6. Only then run paired timing with provenance and all correctness oracles. Report scope accurately: logical work, canonical admission, CPU kernel, full copy, native present and GPU completion are different measurements.
7. Keep incomplete paths conservative and explicit. Default-off experiments must not silently change baseline contracts or disable old cold/authority tests.
8. Promote only after no unexplained regression remains in original scenarios and target error recovery. Preserve a simple full fallback and a way to compare against it.

The finishing objective is not more interfaces: it is one demonstrably coherent producer→closure→publication→physical-target path, with realistic scenarios, precise fallback reasons, and measured total cost.

<a id="chapter-5"></a>

## Chapter 5: Text ownership and accounting

## Text shaping, reflow, ownership and accounting checkpoint

### Read this status boundary first

This section records actual source, author-run source/transport checks, and separately
reported host evidence. It is not a claim that the newest integrated text path has
passed the host compiler, the complete library suite, or a performance campaign.
No Rust compiler, Nix bypass, profiler, or timing run was used in the cloud lane.
The host controller owns the exact shared-Nix/stable toolchain, public/private
SourceValue composition, expanded input manifest, executable provenance and runs.

The current implementation is more than an unused Parley API: the feature-gated
GPUI measure and final-shape hooks use a common source-side artifact owner. However,
that actual adoption is still awaiting its coherent host qualification. It must not
be advertised as a measured shaping speedup. The six original interaction scenarios
mostly contain solid controls, not wrapping paragraphs. Their resize result is not
a text-reflow result. The separate authored wrapping article is complementary.

### Exact source checkpoints and transport

| Source | Purpose | Qualification scope known here |
|---|---|---|
| `30f5dc8182c53b7916849b08226fa8314d6a0f0a` | Repaired independent paragraph seam/control | Historical source and host prerequisite chain; retain original evidence |
| `a727080c89d15b54478a80440a229520d2a167a8` | Mechanical width-output storage cut | Must compare original→mechanical→facade, not only two descendants sharing the cut |
| `17d5ac1fc7f9eb630ed52cb787093ea93b1491e6` | Corrected borrowed-read facade | Required-input descendant `117213e6e68421beaed615973c7ff5833deab3fb` |
| `b80dcc8c6cf4015257034637ae5742e5f75a772f` | Immutable `ShapedParagraph`/independent `WidthView` | Required-input descendant `2b8a34110b1d5d50652afa7d85d43462d7482d40`; host foundation edge reported qualified |
| `27098e3f53ecc1b71879f567052fd4900beddcc6` | Paired-read cursor core | Host cursor delta reported qualified, including negative/restored control |
| `88d4c8052187c7a73f3351da6b2466391f59d281` | One shared canonical Canvas admission/lowering traversal | Focused host laws/probes and height mutant/restoration reported; use host receipts for final combined status |
| `11d4bb3929b00255ba566c7411dd7613163f3308` | Corrected first coherent public source baseline | Includes public exports, receiver/fixture/hash, module-path and cfg-expression fixes |
| `0113e501c8ee82ae9d4749413c5f42129da79db4` | Actual producer shape-owner retirement + touched store/lifecycle tests | Source reviewed, ordered packet independently reconstructed; new tests unrun here |
| `13f383c10c215ea18d441fb7ef6036ce4b929644` | Actual weak source-witness/raw-owner binding | Source reviewed; coherent seven-stage packet, 35 exact tests; host-pending |
| `cf6e8fff5e90282729ef8acedfb587da94009f8b` | Shared UTF8 source instead of a second raw String copy | Separate reviewed five-file descendant; four Canvas laws plus one real-hook law; host-pending |
| `4c334a37f527394b11aa50f969ade6c674d68a14` | Exact caller font plus explicit resource constructor | Separate reviewed two-file suffix and same-face/cold-output law; host-pending |

The `13f383c` archive is
`evidence/optional-shape-binding-11d-v1-13f383c.tar.gz`, 172,910 bytes,
SHA256 `38e461eb14f8c09b0f2ba6d87435d06240be81b41b825f4ff3d206b001f944fc`.
It contains seven ordered deltas from exact `11d4bb3`, all sixteen changed final
files, preimage/absence guards, test inventory, cost notes and local verification.
Both author and reviewer reconstructed the patches and matched sixteen final
payloads to frozen Git blobs. This is source transport evidence, not Rust execution.

The `cf6e8ff` suffix is in `evidence/source-copy-removal-cf6e8ff/`; its 28,240-byte
binary patch has SHA256
`67210e91be06b79413b0e9c1243b239d74dae408e4314381c6058b669cebccca`.
It must follow `13f383c`; it must not overwrite another owner's solver/render tree.
Earlier full/lean/thin archives, rejected transfers and failure logs remain intact.

### 1. The representation cut: shape facts versus width output

Originally one mutable layout mixed source/shaping facts with line-breaking output.
The mechanical storage cut first made the width-output boundary explicit. It was
kept separate from the borrowed facade so that an original→mechanical→facade
three-way control could detect a common regression hidden in both descendants.

The immutable owner retains source/shaping data. Independent owned width views
retain their own line/output buffers and borrow the same immutable paragraph facts.
Read objects always pair one shape resource with its correct width output; fields
are private and constructors establish that pair. Derived Line/Run/Cluster walks
preserve it. The law is not “any shape plus any width buffer is acceptable.”

Inline box placement was a concrete mutable seam: line breaking mutates box
placement. That mutable state belongs on the width side. The current immutable
conversion still deliberately refuses unsupported boxes/alignment and returns the
original layout. Indent/options are preserved. Current owners store those policies;
there is no per-view indent override. The Canvas builder fixes the supported
policy, so the current compatibility key is not a claim of sharing across arbitrary
indent, locale, brush, alignment or overflow policies.

Each width view independently owns its output storage. Old views cannot be cleared,
rebroken or dropped out from under live borrowers. External negative probes check
actual borrow/privacy reasons, not merely any compiler failure. A `Cursor` remains
an owner-free source index/affinity as before; the geometry index is the paired,
borrowed object. The cursor refactor preserves the ordinary Layout public API and
routes its internal byte/line/neighbor arithmetic through the same paired read.
The host measured `CursorGeometry` at 56→64 bytes. That extra reference is a cost,
not a free abstraction.

#### Independent oracles matter

Candidate cold and reused paths can share a new implementation bug. Therefore the
unchanged public ordinary cursor dump runs across frozen old and new roots, as do
full canonical output controls. The cursor seam has 640 deterministic records,
held A/B/A indices, alternating queries, distinct-affinity witnesses and post-drop
rechecks. Ordinary layout controls have 88 and 108 records; the latter includes
boxes, shifts, alignment, raw metrics, runs/glyphs/source and every-byte cursor
rectangles. The canonical lowering control has 160 records.

Some older internal layout assertions normalize style parents/metrics and use
PartialEq floats: signed zero is equal there. Those laws are useful but are not
raw-bit whole-structure identity. Raw public output dumps are complementary.

### 2. One canonical Canvas admission/lowering traversal

The shared lowering cut does not replace error policy with a convenient cache
summary. Ordinary Layout and borrowed WidthView feed one traversal. It preserves
coverage and paragraph order, glyph-count caps, normalized-coordinate checks,
original BlobId-to-font-slot mapping, cluster/glyph validation, caret generation,
and height arithmetic. MATERIALIZE=false still executes admission checks; it is
not only a width/height accessor.

The original post-break body was mechanically compared with the factored body;
only explicit receiver/font-map routing and paired-caret routing were permitted.
The independent 160-record helper stayed unchanged (SHA256
`db08b56d99243f7c396c68b61662ef464b3611ec8d38ccc95d8051838497d3c8`).
A source-only same-path A/B/A test alone would not qualify the rewrite.

Font identity is exact. A resource captures the originating builder's BlobIds,
accepted FontSet and FontBytes guards before that builder drops. A fresh planner
registration of the same FontFace mints different IDs. Equal font bytes do not
make a foreign registration map valid. Focused laws check missing maps, fresh
registration IDs for the same face, final used-slot `same_face`, both materialize
modes, and first-error precedence. Reflow never keeps a Planner/Collection/cmap or
source-analysis cache merely to preserve IDs.

### 3. Actual TextSite integration, not a second text LRU

The common producer identifies the existing site with the actual Sites/FrameIssuer
namespace and node identity. Source/font/policy changes invalidate Shape and its
dependents. Width changes invalidate width output and downstream layout, not Shape.
Paint, clip, transform, stacking and raster dependencies remain separate. All normal
text, including a popover caption, uses these generic dependencies; no popover flag
or fixture-specific key exists.

The common ArtifactStore owns source-side derived artifact slots, not a backend
catalog. A TextSite still has its existing one-width packed TextLayout cache.
Measure and final shape resolve the same immutable raw paragraph resource when
its exact effective source, accepted primary FontFace identity, font-size bits and
fixed supported policy agree. The effective immutable IME/display source lease is
captured once for both paths. No arbitrary independent caller font can poison the
key: it is derived from the actual TextShaper. Context ownership is checked too;
a same-window scope created in a second ResourceContext cannot reuse an uncharged
first-context artifact.

Initial capture stays interleaved with ordinary work: coverage→build paragraph→
break→canonical lowering/admission→optional ownership capture. Quota decline keeps
the output already produced, drops capture prefixes and continues. It does not
rerun the complete ordinary planner. Record capacity and raw backing slots are
preflighted before consuming a Layout. Unsupported ownership conversion restores
that Layout. Later semantic errors retain their ordinary precedence.

#### Sparse ownership and transactional retirement

The first dense index was not acceptable: a late text site among nontext nodes,
or a late admitted site after many quota declines, could reserve large Entry arrays.
A repeated pending-key scan was also quadratic. The current sparse map has one
row per owned Artifact, accepted/pending state, and a bounded touched-key vector.
Map nodes and touched capacity are staged before C. The intended touched commit
has no map insert/Vec growth; its allocator assertions remain host-pending.

A→measure B→final A discards incompatible pending B and reuses accepted A. It does
not blindly evict valid A. Changed/removed/nontext owners are collected during
existing reconciliation visits before identity is lost, and Shape invalidations
are collected during the existing closure walk. Complete history stages those
retirements only. Full/overflow/incomplete/unknown history keeps a full-liveness
reference fallback. That fallback may scan accepted rows more than once; it is
not advertised as changed-only work.

Publication is success-only for common graph/store state. Read-edge replacements
are prepared before C and committed after accepted C, followed by artifact commit
and graph rebase. Error/panic abort drops pending ownership but retains producer
facts for repair. `StoreVisits.retire` counts existing rows visited, not miss lookups
or private BTree comparisons. `staged_optional` proves an actual new raw artifact
was staged; merely observing a new source record is not a valid rollback witness.
Touched Vec capacity may retain a historical high water while any owner remains.

### 4. Reclaimable optional owners and the real accounting boundary

A raw cache is optional; a published output is not. It would be wrong to let an
optional cache consume headroom and then reject an otherwise valid ordinary output
because its cache key cannot be retained. A strong frontend-owned optional cache
in another window cannot be reclaimed by merely ordering this call's reservations.

The generic context-owned optional root stores a typed payload and its existing
ResourceLease. Frontends hold weak handles. Lookup establishes a real transient
pin using an atomic close/pin protocol. An external normal ResourceLease pin, such
as a genuinely queued mandatory owner, protects its record. Explicit bounded
reclaim visits at most min(requested budget, initial indexed owners). Lookup does
not sweep. No hidden mutex, default budget or invented GPU-fence completion token
was introduced.

The primitive is bookkeeping, not a semantic certificate. Generic T may expose
unleased children, contain a duplicate record lease, or mutate through interior
state. Trusted concrete adapters must establish same-root/owned-child accounting
and safe non-reentrant destruction. T destructors run synchronously under the
exclusive context borrow and may otherwise panic or lock. Arc and BTree allocations
remain ordinary infallible/global-OOM allocations. Recoverable numeric/reserve
checks do not prove physical-OOM atomicity.

The sealed Canvas adapter moves the SAME Arc<ShapeResource> and SAME record into
the optional owner. Its payload contains the Arc, not another copy of its own
record lease. Pinning reconstructs the original pair before dropping the temporary
pin. Storing the old ShapeArtifact unchanged inside an optional root would self-pin
forever and was rejected.

#### The packed key is optional too

A packed output is self-contained. Its source/font validity witness can be absent.
The witness now lives in a context-owned typed root holding the whole immutable
SharedText and exact FontFace key, with registered UTF8/font backing leases. Shaped
and ArtifactStore hold only weak witness handles in production. Reference-only
strong variants remain cfg(test), not a production retention route.

Witness admission precedes raw capture. Decline returns ordinary packed output,
sets input=None and disallows future hits. A known-width measure that just shaped
this invocation returns those metrics directly, even without a retained witness;
it does not shape twice merely because the optional key was declined. Zero budget
means zero retained_payload_bytes in the ONE ledger for UTF8/font/raw roots, not a
secret second source budget. The real-window fixture requires actual packed text,
no witness/raw stage, and full cold-identical pixels.

#### What the App limit does and does not cover

**Covered subset:** explicitly registered optional whole-ArcStr backing, accepted
font/FontBytes roots, raw source/shape Vec payload capacities, with physical alias
deduplication within one App context. Root/record/backing counts are also bounded.

**Not a complete cap:** mandatory TextSite/model/P source ownership, existing
packed/renderable/GPU payloads, parser/raster scratch, all staging/transient peaks,
Arc control blocks, private BTree nodes/spare storage, allocator rounding/RSS, and
other unregistered application resources. Existing legacy constructors remain
visibly unaccounted. No fabricated production per-window budget was installed.

FontData is charged as its header plus owned byte capacity; borrowed static bytes
add zero. FontBytes wrappers are separate payloads referring to the same accepted
face; those shared bytes are not charged twice. The locked whole ArcStr1.2 adapter
uses its full stable data pointer and exact requested dynamic allocation len plus
two usize fields. Static/empty/immortal roots retain zero lease-owned heap bytes.
No unsafe header read, pointer subtraction, arbitrary projection, inline buffer,
subslice or fresh Arc wrapper identity is used to pretend shared physical identity.

Index removal is never byte credit. Ledger maintenance observes actual final guard
drops separately. Shared child roots and real pins can keep charges live. Unused
new candidates support exact-handle discard without sweeping, but conservative
weak record/root charges still await explicit maintenance. Pending weak entries
can leave indexed orphans. Limits bound those rows; App maintenance policy remains
explicit, not an automatic hot-path full scan.

A surviving Weak retains the entire Arc allocation envelope after payload fields
have dropped, not only an imagined control word. `inspect_optional_metadata` sees
indexed owners only and excludes retired envelopes still held by weak handles.
The 0/1/128 probe prices indexed/orphan rows, typed owner headers, pin/weak handles,
and isolated allocator requests. Half the handles survive reclaim; final balance
is checked only after final handles and context drop. The residual row deliberately
combines stale envelopes and empty map capacity. It is not a fake isolated weak-byte
estimate. Libtest sparse-entry layouts include test reference variants and are
labeled as such, not exact production weak-only layout.

### 5. Removing the second source copy, with a real child lease

`13f383c` still kept a raw String copy in addition to the registered whole ArcStr.
`cf6e8ff` adds a sealed OwnedShapeSource factory. Its sole text input is Utf8Backing;
there is no separately supplied &str to mismatch. The original copied API remains
as a reference/fallback API. The shared capture checks actual accounting domain,
origin and exact full str identity before consuming owners.

Raw ShapeResource now keeps that immutable backing plus a DISTINCT CHILD
Utf8Source record. The child shares the same physical backing as the input witness.
It does not share the witness's exact record: that would externally pin the witness
owner and prevent reclaiming it while raw shape remains. It is not the raw record
itself, so it cannot self-pin the raw optional owner either. This is a DAG of
ownership, not a cycle.

Tests reclaim the input witness while holding a real raw pin, check the exact
registered live-root sum still includes source once, then reclaim raw and maintain
to zero registered charges. A real GPUI resolver test checks source pointer identity
against SharedText, so merely adding an unused factory cannot satisfy it. Shape
and owned-measure A/B/A compare complete packed output/metric bits with ordinary
controls. Record-slot and foreign-context cases decline raw retention, preserve
output and check actual build/capture counters for no reshaping.

This is not automatically a memory win. The String capacity is removed, but
SourceStorage's inline representation is larger, and a distinct record, Arc header,
backing-reference Vec and map bookkeeping are added. Empty/short/14KB cases report
removed capacity and isolated child-alias record allocation/ref costs. Source bytes
are not billed twice. Small strings can lose. The host can compare public
size_of::<ShapeResource>() across frozen roots for the actual compiled header delta.
Raw+packed retention may still be far worse than transient ordinary shaping for
many unique sites. No RSS or full retained-peak benefit has been measured here.

### 6. Output lifetime and failure tests

Published Canvas owns existing packed geometry/glyph positions and immutable
renderable masks/materials, never ShapeResource or its raw font-registration map.
The lifecycle fixture extracts the accepted Canvas, drops Runtime/model/TextSite
caches/TextSystem/context, then renders twice into fresh sentinel buffers and
compares every active BGRX pixel with independent cold output. It does not read a
hidden cached image. Zero registered charges proves the tracked accounting cohort
retired, not that every FontData strong reference in the process is dead. No public
weak-font observer was added just to overstate that smoke.

The two-site failed-newer fixture requires a real raw stage before a later NUL
coverage failure. Old eligible C/token, acknowledged P and full pixels remain.
Explicit optional pressure may expire old caches too; old packed output remains
renderable. Repair preserves the earlier accepted logical source write and matches
fresh cold output. Private warmed packed caches may survive failed preparation as
before; that is not publication of a new C. Optional cache identities are not proof
of surviving payloads after pressure.

P/ACK publication and actual raster damage authority are distinct. A target can
render C without ACK or skip scenes. Damage must be relative to its actual complete
scene revision and surface generation, not universally “old acknowledged P.” Text
lifetime tests do not license a different renderer base.

### 7. Host evidence, failures and known open gates

Reported by the parent, not independently executed in this cloud lane:

- Corrected17→b80 foundation edge passed 88/108 exact output (1,361,990 bytes),
  ownership probes and width negative/restored controls. Exact suite counts and
  ignored status must be read from the host receipts, not shorthand messages.
- Cursor delta passed ordinary cross-root 640/88/108 output (12,095,913 bytes),
  held-index/ownership and intended negative/restored controls. Geometry size grew
  56→64 bytes.
- Shared lowering focused laws/probes passed; height mutation changed the intended
  twenty baseline words, left the other 140 records unchanged, and restoration
  matched the independent 160 control. Final combined receipt must be checked.
- Corrected coherent production/libtest compilation and named late-owner/width
  smoke were reported on host `4b0ff7f7a527addc2756bc2b4dcdb587fcec3e9a`.
  This is not a broad execution claim for the newer 0113/13f/cf6 suffixes.

Source review missed real compiler issues earlier. They are preserved, not hidden:
private Canvas text-module imports required root reexports; an explicit module
path resolved relative to planner.rs and needed sibling `resource.rs`; a cfg on
an assignment expression required a block; ArcStr::is_static is associated, not
a receiver method. Earlier inherited packaging/test registration and moved-field
issues required correction. Negative ownership fixtures also needed real public
values so intended privacy failure was not mixed with unrelated hidden-type errors.
The checker was not relaxed to accept arbitrary failures.

False-positive gates were hardened: exact selected tests and zero ignored, exact
positive dump counts, isolated Python (not ambient PYTHONOPTIMIZE), independent
expanded source manifests, fresh native test/Parley artifacts and before/after
hashes. A successful zero-test Cargo filter is not qualification. Selected-payload
preimage guards are not full input identity or cfg/env/build hermeticity proofs.
The exact gamut/rootignore/locks/assets supplement remains required on all roots.

### 8. Original six scenarios, font/scope API and the unfinished adapter

The frozen fixture is `interaction-lane/baseline/reactivity/crates/gpui/examples/
interaction_workload.rs`, 35,639 bytes, SHA256
`833d11326b5100fc48ad54b56172344873a64328a04fa4470a8501ca745f116e`.
Its exact Inter font SHA256 is
`40d692fce188e4471e2b3cba937be967878f631ad3ebbbdcd587687c7ebe0c82`.
Keep side32 primary and side100 stress separate. Preserve text, traces, widths,
subframes, two-mutation property calls and wheel→ACK→anchor-follow→ACK cadence.
Do not substitute source-rectangle pose changes or the wrapping article.

A real integration gap was found: the fixture mounts recording_with_font, which
is legacy Unaccounted. Turning retained-text ON alone does NOT exercise scoped raw
shape reuse. recording_with_resources instead used the default font. The minimal
constructor suffix `4c334a37f527394b11aa50f969ade6c674d68a14` composes both exact
caller font and explicit context. Its focused law is
`runtime::retained_text_lifetime_tests::accounted_custom_font_constructor_preserves_exact_face_and_cold_output`;
it is reviewed source, not a host pass. No switch to default font
is allowed to make a benchmark pass.

The general mutator adapter is NOT finished. Source/property operations can use
explicit scoped turns, but naïvely batching all original operations into one turn
would change preparation cadence. Pointer Move/Press/Release/Wheel, resize and
list scrolling, font replacement, keyboard and IME operations need resource
threading through their existing immediate paths,
including rejection before caller-owned pointer-session consumption. Preserve
legacy closed/poisoned stream semantics and original public call/ACK boundaries.
The original six remain valid unchanged core/render controls. Accounted-text claims
require the reviewed API-only adapter, symmetric cold/full-output comparison,
explicit scope/feature disclosure, and candidate feature-OFF isolation control.

The complementary stock wrapping article (frozen `a47bad473ed426a5e63393c12d0d1632f98bd524`)
uses authored prose, exact font, genuine width/height/caret change, cold scene/pixel
oracles, clipping/exposure/scroll and oldP/newC controls. It is not a relabeling of
the original solid-grid resize. No timing result for new reuse is recorded here.

### 9. Rejected or deliberately deferred approaches

- A text-specific LRU, fixture IDs, popover switch or duplicate resource catalog:
  rejected in favor of generic dependency/artifact ownership.
- Fresh planner registration IDs inferred from equal font bytes: incorrect.
- Raw-only source accounting while packed keys keep strong source clones: incomplete.
- Mandatory output failure because an optional key/cache exhausted quota: incorrect.
- Mandatory-first ordering alone as cross-window cache eviction: insufficient.
- Summing per-phase historical allocation events as a live peak: double counts
  shared leases and can confuse address reuse. Use declared simultaneous owners.
- Any/Send+Sync or a nominal ResourceKind as proof of immutable/font-free content:
  false. Actual typed render adapters are still required for general render roots.
- Arbitrary by-value buffer projection: can observe an inline stack address before
  moving the owner. Only sealed proven full heap allocations are acceptable.
- Wrapper Arc identity around SharedGlyphs/EcoVec/ThinArc clones: can double-charge
  one backing. Use actual locked-type backing identity with guards, not a new wrapper.
- App owner numbers cast into scene Global nodes: independent issuer domains can
  collide numerically. App-global support remains unavailable until tagged-domain
  binding; genuine window-global origins derive the actual FrameIssuer.
- Per-byte caret topology redesign, broad shared-layout API rollout, asynchronous
  shaping, and persistent font-bearing old scenes: not smuggled into this cut.

### 10. Promising untried experiments and exact gates

1. **Share identical shape artifacts across sites.** Use common source/font/policy
   dependencies and exact originating font-domain map, not equal-byte keys or a
   second interner. First settle tagged context/global origin and typed common
   store consumption. Prove cross-context rejection, distinct-font-domain behavior,
   retirement/failed-C rollback and old-scene lifetime before timing. Measure many
   unique and many identical sites, including duplicate metadata and raw+packed.
2. **Reduce caret indexing allocation.** Current reconstruction can allocate
   per-byte/source-boundary metadata every width. A source-stable cluster identity
   plus width-dependent visual lane might avoid it, but run-split graphemes and
   affinity make this nontrivial. Require canonical identity laws across line
   splits, every-byte/both-affinity raw rectangles, non-dyadic sizes, independent
   frozen cursor output and a discriminating mutation. Do not change error order.
3. **Reuse bounded width buffers or final artifacts.** Preserve independent old
   views and A/B/A simultaneous indices; pool ownership must not rebreak borrowers.
   Price peak old/new views and packed output overlap, not just retained length.
   Control actual wrap/height/caret changes and use full cold output.
4. **Use dependency closure to avoid unnecessary measure/final work.** Width affects
   TextLayout, source/font affects Shape; transform/paint/clip are separate. Require
   complete producer history or conservative fallback, real first/last/middle and
   removal traces, error repair, independent full scene/pixels and changed-work
   counters. A skipped callback count is not a shaped-glyph count.
5. **Share immutable packed draw fragments.** Keep exact scale/transform/clip/paint
   dependencies and existing font-free mask/glyph leases. Never put raw shape/font
   owners into old Canvas/P/GPU roots merely to reuse CPU work. Requalify ordered
   overlap, clipping/exposure and actual target-base damage authority.
6. **Parallel width/lowering work over immutable owners.** No retained Planner
   caches. First prove Send/Sync and borrowed-view lifetimes on actual libraries,
   keep deterministic paragraph admission/first-error order, bound worker queues
   and overlap capacity, and hold real leases until actual jobs end. A numeric
   caller fence token is not lifetime proof.
7. **Trim shape representation/storage.** The 4+6 private Vec capacities are now
   inspectable in isolated diagnostics. Determine which data is genuinely needed
   for width/cursor before dropping it. Compare all independent outputs and first
   errors, use allocator/declared-live union and RSS separately, and retain ordinary
   fallback. Length is not capacity and source-only sizeof is not memory profiling.
8. **Finish registered mandatory resource admission.** Bind all actual packed,
   image/gradient/raster/GPU retainers to sealed backing adapters and App policy.
   Preserve old+new transient budget and real queued leases across windows. Do not
   claim the optional subset already provides this, or invent a hidden reserve.
9. **Remove duplicate typed root handles, not just payload copies.** The current
   optional shape envelope and its accounting guard both retain the same Arc root.
   A constructor-bound typed root-slot borrow through the existing lease could
   remove one handle/atomic operation without an ID lookup catalog. It needs a
   sealed slot/type/pointer law, actual payload/lease pairing, zero unsafe generic
   projection, ownership/expiry tests and measured metadata benefit. It is not
   implemented; optimizing an eight-byte handle is lower priority than qualification.

Every experiment needs the coherent compiler/ownership baseline first, realistic
same-work output acceptance before timing, original control roots, and matched
fresh-process evidence. No speedup graph may turn a static work estimate, capacity
model, scheduled GPU area or source-level String removal into measured latency,
RSS, frame rate, native present, or input-to-photon data.

<a id="chapter-6"></a>

## Chapter 6: Measured evidence and operational lessons

## Measured evidence, performance limits, and remaining qualification

**Initial evidence cutoff: 2026-10-26 02:34 UTC; dated updates through 02:58 UTC follow.** This section distinguishes source review, actual compilation, correctness qualification, linked-code measurements, and elapsed performance. They are not interchangeable. Host-reported results below were received independently as execution status; this section does not imply that every raw host archive was locally inspectable. No new Rust compilation, installation, or benchmark was performed by this review lane.

**Evidence navigation:** packaged benchmark data and graph artifacts, where included, belong under the curated repository’s `supporting/benchmarks/`. Paths such as `interaction-lane/…`, `render-lane/…`, `research-structural-lane/…`, and `report/…` below identify the historical source workspace used for this review; they are provenance labels, **not promises that those paths are included in the curated repository**. Historical source/raw evidence not explicitly packaged must be treated as not included. Commit pins and exact numerical scopes remain the durable references.

### 1. What can presently be claimed

1. The historical original interaction workload has a reproducible six-scenario **baseline**, including full CPU raster output. It is nightly/non-Nix evidence, not a current shipping comparison.
2. Several isolated changes have substantial correctness qualification: regional geometry repair, standalone CPU output cache, text ownership prerequisites, retained-update controls, and the small CSR end-offset rewrite. Those results do **not** qualify their later compositions automatically.
3. The CSR rewrite has a real linked-code result: one offset-copy site removed, function code reduced by 26 bytes, frame unchanged. It has no demonstrated elapsed speedup.
4. The retained physical catalog has real requested-byte costs, including a large staged clone. Those measurements expose a problem rather than establish a memory win.
5. The first coherent producer/Canvas assembly has actual scoped smoke positives, but current successors still have open receiver, integration, native-publication, and benchmark gates. There is no defensible claim that the complete innate-damage architecture is finished, nor a matched end-to-end speedup or finish ETA.
6. Scheduled repair area is a useful work metric, **not latency**. Smaller dirty areas do not remove full preparation, dependency closure, projection, binning, upload, synchronization, or destination-copy costs unless the actual consumer proves that removal.

### 2. Original realistic interaction baseline

#### Provenance and measurement meaning

- Production base: `7ac6f33`; harness/source: `1b0eee3b9252b6647f13be63477cb158d21c04c8`.
- Compiler: `rustc 1.101.0-nightly 7189d39d9`, nightly 2026-10-23, LLVM 23.1.4. **Historical nightly/non-Nix baseline only.**
- Binary SHA256: `e77873f203e04cbaf3e98193e7870b07ea4cb27c19a76a895514821f9674ed1c`.
- Exact workload: `interaction-lane/baseline/reactivity/crates/gpui/examples/interaction_workload.rs`, SHA256 `833d11326b5100fc48ad54b56172344873a64328a04fa4470a8501ca745f116e`.
- Source data: `interaction-lane/raw/primary-analysis/summary.json`, `per-run.csv`, and `RESULTS.md`.
- 96 serial children exited successfully: one predeclared discarded process plus seven measured processes for each of six cases and two modes; 84 measured children. Each measured process used 32 warmup and 240 changed operations.
- The table is the **median of seven per-process operation quantiles**, not a quantile pooled across all processes. Quantile/MAD details and tails remain in the raw summary.
- `Sample::finish` defines total as a **sum of measured phases**: routing, public edit/preparation, scene borrow, optional CPU raster, and logical headless ACK. It is not outer event wall latency, frame rate, native presentation, GPU execution, or input-to-photon latency.
- Initial/final exact scene/pixel reconstruction passed; a separate correctness campaign checked each logical submission, including intermediate popover scroll sheets.

| Original case, primary side 32 | Scene phase-sum p50 / p95 ms | Full CPU phase-sum p50 / p95 ms |
|---|---:|---:|
| hover-source-paint | 0.470276 / 0.776590 | 6.692134 / 8.875404 |
| hover-property-paint | 0.841334 / 1.314966 | 7.090390 / 9.543271 |
| hover-property-layout | 1.155099 / 1.958739 | 7.534001 / 10.203606 |
| window-resize-layout | 0.548037 / 0.939561 | 6.530505 / 8.823498 |
| app-ticked-geometry | 1.489715 / 2.534085 | 10.224797 / 13.244478 |
| popover-scroll | 1.527192 / 2.316152 | 15.915316 / 22.374713 |

All twelve numerical rows were independently checked against the raw summary. Graphs under `report/interaction-update/` are this baseline, not results from the new coherent candidate.

The primary grid has 1,024 controls. Resize changes the public viewport between 1000×1000 and 1200×600 and really rewraps fixed children; it is not a text-article benchmark. Animation changes widths, heights, and translation; replacing it with a visual pose would change the workload. Popover uses ordinary open/scroll/reposition/close phases, including two acknowledged flushes for wheel/anchor-follow steps. Side-100 stress must remain separate.

Whole-child peak RSS includes launch, setup, initial/final reconstruction oracles, and output buffers. The historical runs shared a roughly 20.88 MiB floor, which did not discriminate scenario retained memory. It is not application-only steady-state RSS.

### 3. Regional GPU scheduled area: correctness-qualified work, not timing

The independently published software-Vulkan geometry results covered all 24 cells of the output-mode/scenario matrix and **640 complete active-pixel comparisons: 512 regional plus 128 full**. Inventory, intermediate flush, delayed submit, and resize lease controls passed. Both the public long-move and real-trace mutants reached intended complete-pixel failures, with restored positives passing. These are llvmpipe software-Vulkan results, not native/hardware-GPU latency.

Primary SDR/sRGB, side 32, **post-seed** scheduled area:

| Case | Subframes | Full / regional / empty | Scheduled / full-reference pixels | Fraction |
|---|---:|---:|---:|---:|
| hover-source-paint | 32 | 0 / 32 / 0 | 135,680 / 32,000,000 | 0.424% |
| hover-property-paint | 32 | 0 / 32 / 0 | 135,680 / 32,000,000 | 0.424% |
| hover-property-layout | 32 | 0 / 32 / 0 | 2,061,568 / 32,000,000 | 6.4424% |
| window-resize-layout | 4 | 4 / 0 / 0 | 3,440,000 / 3,440,000 | 100% |
| app-ticked-geometry | 32 | 0 / 32 / 0 | 29,483,008 / 32,000,000 | 92.1344% |
| popover-scroll | 22 | 22 / 0 / 0 | 22,000,000 / 22,000,000 | 100% |

Every case has a separate full seed of 1,000,000/1,000,000 pixels. Other three output modes matched subframe counts; do not invent their area totals from this table. See `report/geometry-work-update/{geometry-scheduled-area.png,scheduled-area.csv,PROVENANCE.md}`. Published task provenance is recorded in that sidecar.

This reveals both opportunity and limits: hover repair area is small, while actual animation is still about 92% of full area and resize/popover take full output. A “236× faster” inference from the paint area ratio would be false.

### 4. Isolated mechanism qualification and composition boundaries

#### CPU output cache

The corrected A source, host `f8f81f6156c2043f2d89a7074d9a19e7507d28c9`, completed the same-source feature+parallel and fallback+parallel cohorts, each 268 passed / zero failed / four original ignores, and default-off 247 / zero / three ignores. Four compile-fail docs passed in each cohort; two declared elapsed probes remained deferred. Both new 12-image capture sets exactly matched the original control.

A prior full-suite failure was real: the allocation ledger expected `(2,76)` but observed `(3,148)`. A was a **test-accounting correction**, not a production optimization: feature Scratch 120 bytes plus CSR 20 plus bitmap 8, image allocation zero; warm operation zero allocation. Default Scratch 56 and `(2,76)` stayed unchanged. Original failure and exact-source repair were preserved.

B, actual host `68b0bc6deb46dfcdc23a493c8b901b06d69bdc43`, independently completed three positive cohorts (269 feature, 269 fallback, 247 default-off), four docs per cohort, and twelve-image parity. A mechanism falsifier and three complete-image mutants failed as intended, with restored positives. It removed an unnecessary eight-byte bitmap allocation where fewer than eight tiles cannot satisfy sparse admission: **two requests / 140 bytes versus A's three / 148**. The 64-byte feature header remains a cost; warm zero-allocation does not erase it. These are requested-byte/unit-test observations, not release RSS or speed results.

Pool-1/2/4 test determinism alone does not prove actual parallel execution; the full existing parallel suite was required. A “foreign slot” negative is positional out-of-range validation, not a theorem that every cross-Canvas `PaintSlot` is rejected by identity.

#### Text prerequisites and deltas

- Corrected 17→b80 standalone prerequisite eventually passed both complete 88/108 output inventories, **1,361,990 bytes per root exact**, control 251 / candidate 253 tests with zero failures and three original ignores, four repaired external ownership probes, and width-120 negative/restored controls. This was baseline prerequisite qualification, not GPUI reuse.
- Cursor delta, host control `1756f1bfce0cddaa4c1a03a0cdfd33a3b95ca93c`, candidate `110494fadfb843afb81f4eae12ee72d21eea0046`, passed 640/88/108 inventories and **12,095,913 bytes per root exact**, ownership controls and intended cursor-equality mutant/restoration. `CursorGeometry` grew **56→64 bytes**. Earlier b80-derived controls did not retroactively qualify the missing 17→b80 prerequisite.
- Earlier 30f/a727/17 stages each passed 110 library and 140 applicable integration tests, all 88 records exact, width-zero mutant restricted to intended width, and public borrowed-layout compile-fail/after-drop positives. Four reader types grew eight bytes each. No memory/speed win follows.
- Shared lowering had focused/ownership positives and an intended 20-word mutant with other 140 words unchanged and restored 160 exact; the final 160/640/88/108 join was still pending in the last independently available checkpoint. Do not mark it complete without the final receipt.

#### Retained/core and first coherent assembly

Isolated 6041 retained work passed 203 library + 53 core tests and seven intended mutants/restored positives; it does not contain the P1 production fix. A zero-selected core-doc run was explicitly rejected as evidence.

The older integrated R5 replay passed 13 gates / 40 executions /zero failures/zero ignores. It is not qualification of the new canonical dependency graph.

At this cutoff the first coherent Linux `ce18` source had four default smoke positives. Retained source `4b0ff7f7a527addc2756bc2b4dcdb587fcec3e9a` had production/full-libtest compilation and named late-owner/width identity positives under audited adapters. Current ordered rendering `55d975` passed its first five public gates, then failed public test 6 at the stale `entries.len()==1` assertion: actual hard-full export is zero rows. The slot guard had not yet run. The independently reviewed test-only correction expects exact `(len,capacity)==(0,0)`, verifies CAPACITY survives rejection/retry, and drains the journal only after accepted full snapshot. Rerun was not yet observed. This is a fixture contract mismatch, not evidence of successful rendering qualification or a proven production defect.

### 5. Real memory and linked-code measurements

#### Retained catalog is not free

Host storage source `fb019539fa55e679696f836ceac4078f849257a4` passed nine focused stale/reuse/exhaustion/staging/CPU-lease tests. On 40,000 contributors and four million references:

| Requested-byte quantity | Observed |
|---|---:|
| Membership references | 16,000,000 bytes, equal to `Vec<u32>` control |
| Live catalog | 5,308,584 bytes |
| Staged full clone | 4,082,856 bytes / five allocation requests |
| Old catalog + old references + new catalog | 25,391,440 bytes **before new memberships** |

Hot lease clone/read/early rejection allocated zero. Full-key/generation linked lookup was present; staging-callee inspection was pending. These are requested-byte/software measurements, **not RSS, hardware-cache misses, or a memory saving**. Paged rows/sharded-index work must beat this actual baseline, including retained old/staged/retired overlap, not an imagined expanded reference representation.

#### CSR copy-pass removal: small, genuine codegen cut

Actual host `8be82d4d0aeb245e912c23b2152990add0cfe90a` qualified all three feature profiles, exact images/statistics/pools, and three intended mutants with restored positives. The transformation counts at `offsets[tile]`, forms cumulative ends, reverse-scatters by decrementing those same entries into starts, then writes the final total sentinel. It removes the final `copy_within` without adding a cursor array, owner, or allocation.

Linked release `RasterScratch::prepare`: **2,087→2,061 code bytes**, memcpy/memmove sites **one→zero**, frame **224 bytes unchanged**, initialization/allocation sites unchanged. This confirms the intended pass was removed. It is bounded O(tile-count) logical traffic removal; O(reference-count) count/scatter, two bounds traversals, membership zero-initialization and raster work remain. No elapsed improvement was measured.

#### Samples representations: rejected/adverse, not “optimized”

Independently published stable linked facts for flat/nested/Option Samples variants:

| Variant | ELF bytes | BGRX CFA frame bytes |
|---|---:|---:|
| flat | 986,752 | 72,800 |
| nested | 986,952 | 72,800 |
| Option | 987,984 | 139,376 |

Option emitted a 66,560-byte temporary copy; nested retained promotion spills/reloads. The current Option spelling was rejected for runtime promotion on codegen grounds. No invented numerical performance threshold or elapsed regression is claimed. A borrowed-array candidate compiled but retained every targeted copy; promotion stopped without tests/timing. Stable compiler self-comparison elimination was not disproved merely by source inspection.

Later borrowed executor partition: **24-byte borrowed view removed 224-byte worker copy**. BGRX wrapper unwind **1,680→1,232 bytes**, branches **21→30**, admission frame **208→240 bytes**. This is a codegen tradeoff, not an unconditional speed win. Host also confirmed **all 69,664 bytes of Samples initialized before classification**; a one-initialization-per-band fast-prefix continuation was being implemented, not qualified. Nearly every original 32-side primary band intersects 24-pixel cells/30-pixel row gaps; actual first-mixed/uniform census is required before expecting uniform-prefix benefit.

### 6. Source-ready structural work: what it does and does not prove

The ordered renderer `b02f3b90bc6edb7ffd377e9801142febb65f2981` has four reviewed content steps: actual scoped recording, producer adoption, compact material-user addresses, and skipped-output receipt tests. Exact guards are selected-file evidence, not whole-source or fresh-ELF authority.

- **One semantic span authority:** each runtime node, including empty/omitted nodes, finishes an own scope before descendants/continue. One mandatory `GroupSpan` Vec transfers into the accepted binding; there is no shadow parent-token Vec. Known node count is reserved before callbacks. Optional material-edge tracing may decline to an independent scan.
- **Compact users:** u32 indices into the binding's own immutable canonical group table replace duplicated u64 local IDs. User payload 8→4 bytes, staged edge 16→8 bytes; Vec headers/request count do not shrink. Semantic-local iteration order is preserved even when local IDs are nonmonotone. Extra indirect table/comparator loads remain real cache costs. A tiny scoped allocation expectation of two requests / 20 bytes excludes prebuilt groups/edges and is unrun, not whole-publication memory evidence.
- **Receipt ownership:** Canvas privately consumes the publication receipt once; accepted immutable view takes no caller receipt. Mutation revokes binding; failed preflight preserves old C. Closed Material/Raster/Hit/Semantics proof does not permit Primitive/Layout/resource/global changes to impersonate a paint-only patch.
- **Zero-change hole found and fixed in source:** discriminating an empty edit list was insufficient; a nonempty same-color list has zero actual changes. All `changed==0` publications now require a positive Hit/Semantics-only closed proof. Paint no-op rejection is conservative. The **runtime must catch that rejection and actually full-stage**, rather than return an ordinary interaction error; Canvas does not implement the fallback by returning Err.
- **Geometry/PaintState extraction:** final reviewed successor `14e3e6ed267838d8c150ec425f2421fbfca5b9a8` aligns to corrected fixture base 5399733. It moves existing owners, adds no heap/Vec/Arc, preserves scope-before-paint admission and image-radius bit overload. It is **not independently immutable geometry**: literal detachment still mutates a stored PaintRef. Host R4 field-path adapters are mandatory and independently guarded. No new compilation/layout/allocator/output claim follows from source audits.
- **Dependency scheduling:** Cephal already owns cached question replay and exact answer-change stopping. An eager parent↔child Layout SCC defeats that authority. The selected next cut uses direct changed owners and actual solver writes/answers, preserves child-style/immediate-parent and cheap-leaf guards, and emits bounded derived facts. It must not add a second LayoutOutput mirror/full scan or infer baseline/overflow independence from fixed size alone. See `adversarial-retained-review/SOLVER-DEPENDENCY-CUT-20261026.md`.

The target consumer still needs a complete chain: accepted edge→closed logical nodes→old/new physical group/resource/tile expansion→deterministic jobs→actual completed target revision. Expand old/new support while both exact snapshots/resources remain leased; after expansion a target may retain just physical dirty union, not another semantic graph. Intermediate accepted Cs never mean completed pixels. Missing receipt chain or old physical metadata forces full recovery. Revoke image authority before the first possible write; partial failure preserves damage and invalidates the old image. Cache-image completion and native destination-copy/publication are separate physical authorities. These are obligations, not a claim that the current host wrapper has already consumed them.

### 7. Failed/inconclusive execution and tooling constraints

- Cloud had no rustc/cargo/nix in PATH or bounded standard tool search. No substitute toolchain was installed. Actual compilation belongs to the pinned shared-Nix/stable host route.
- Mac disk initially prevented heavy work; a fresh user-triggered check later found 39.53 GiB free and the pinned native closure was restored/rooted. Old disk/closure blockers must not be repeated as current. A later connection interruption was transient; no remote job termination was inferred from UI disconnection.
- Mac original native Auto 14 frames and GPU 11 frames passed nine checks/clean exit under **unknown load**. Those were old native paths, not the new coherent composition or timing. Todo UnitChoice migration passed five gates; original `Source<Filter>` remained unsupported. Public Frame/Domain integration correction and fresh per-worker status were still open at the last checkpoint.
- Actual compile failures were retained and corrected separately: receiver-local E0502, missing Phase/Artifact Hash E0599, wrong resource-module path, fixture reference dereferences, solver shared callback lifetimes, missing test imports, and historical unclosed test delimiter/ambiguous selector. Do not label source-predicted failures as observed compiler failures, or setup errors as intended mutant failures.
- Strict Core Clippy originally failed three inherited test predicates; a test-only descendant `1f14e91b77f7c9a6702fbc444d2c0f3927ba7989` passed affected tests and exact all-target Clippy, with 1459 guarded inputs. That did not qualify unrelated GPUI runtime gates.
- Software GPU preflight passed 41 complete images with clocks disabled, source `9ec80d13fcc6d151096ee6f1af759cce57a576ac`, ELF `6e642c1309ccd483bd3d362289a9cf6a40cc42a797f677a8ebef2fec8251728b`. The timing pilot completed **zero pairs**: affinity guard killed/reaped a child that widened affinity. One later clock-disabled diagnostic captured `interac:disk$0`, expected CPU 14, actual CPUs 0–15, and complete cleanup. Mesa 26.2.5 disk-cache worker source matches the full-affinity flag; installed Nix patch equivalence was not proved. No env/cache/guard relaxation or retry yielded timing data.
- IO admission remained unchanged; read-busy pressure 45–59% versus 20% cap and sdb 9.6/10-second activity were observed with owner unknown. Do not kill unrelated workloads or call task-induced correlation exclusive attribution.
- Resource/permission holds were real. A specifically approved private input-record write eventually succeeded once; that was not general permission to bypass archive access restrictions. Restricted raw exports were not proxied or silently re-uploaded. A newly user-attached old executor checkpoint authorized only those bytes, not later host revisions.
- A 20-minute ra-jit attempt was cancelled/reaped with no output. A seed-qualified Canvas JIT hot consumer did serve two edits without post-seed Cargo fallback and matched authorities/reversal; neither result proves cold/full-workspace compile speed or Rust borrow-check compatibility.

### 8. Realistic matched benchmark plan

Use `research-structural-lane/COHERENT-BENCHMARK-ACCEPTANCE.md` and the existing source protocol, not a new easier workload.

1. Freeze **actual complete host control/candidate pins**, dependencies, feature resolution, stable compiler/Nix/ISA/allocator flags, source inventories and fresh release ELFs. Historical 1b0/7ac is not today's current control. Retained-text is default-OFF; disclose feature differences and retain candidate feature-OFF isolation.
2. Finish current coherent correctness gates first: real producer/closure/retained rendering/native publication; ordinary popover/text/layout/resize/order/clip/resource changes; old ACK/failed newer/surface generation; exact cold output and error behavior. No performance acceptance for a partially qualified assembly.
3. Keep the original fixture and operation bodies/hash, pinned font, primary side 32, both scene/fullCPU modes, and all intermediate popover sheets. Side 100 and wrapping-article/native tests are separate workloads.
4. Validate every subframe against fresh within-variant cold output **and cross-variant** exact scene/geometry/clip/color/extent/active pixels using separately requalified diagnostic captures. Shared new resolver/cold implementation alone is insufficient.
5. Seven fresh matched AB/BA process pairs per case/mode/history; alternating whole-case order, declared warmup 32/samples 240, separate warmup 0 history, no selected retries/tail trimming. Mandatory initial oracle warms raster/CSR/text even at warmup 0: not first-ever cold raster/OS evidence.
6. Timed binaries contain no validation/profiling. Preserve per-step routing/edit/borrow/raster/ACK and total phase sums, process wall/user/system, faults/context switches, RSS, all pair ratios, p50/p95/p99/max, first operation and construction separately. Add a separately labeled outer wall measure if actual event latency is the goal; do not relabel phase sums.
7. Apply predeclared acceptance/noise gates per operation class before seeing data; the existing protocol's investigation ratios are mean 1.05/p95 1.10/p99 1.15/max 1.25 and first/construction 1.10. Any changes must be declared first, never fitted after results. Noise is inconclusive, not trimmed success.
8. Report allocator requested/live/capacity/snapshot peaks separately from whole-child RSS. Include old+new+staged+retired owners, metadata, scratch, full-output copies, and failed-attempt capacity growth. No allocation profiler in elapsed campaign.
9. Native/hardware GPU measurements need separately qualified transport, completion and quiet/resource guards. Zero completed software pairs cannot populate a speedup graph.

### 9. Remaining experiments, prioritized—not promises or new parallel scope

These should be evaluated only after the coherent path closes and representative measurements identify the bottleneck. Existing frozen prototypes remain evidence, not permission to keep proliferating disconnected implementations.

| Priority | Experiment / likely payoff | Key risk and decisive evidence |
|---|---|---|
| P0 | Consume accepted dependency/old-new support directly through retained groups, target dirty union and real output completion. Potentially removes whole-scene work on ordinary small changes. | Correctness/authority risk highest: insertion/removal/order/resources/shared groups/failed newer. Complete cold outputs and real current consumer counters, not metadata-only tests. |
| P0 | Solver-owned value-change propagation instead of eager Layout SCC. Can stop unrelated ancestor/descendant work. | Baselines, visible overflow, parent direct style reads, cache eviction and topology must remain conservative; actual computed/cached answers/measure callbacks/changed writes. |
| P0 | Retained physical storage without full catalog clone, using host-owned paged/sharded representation. Targets measured staged 4.083MB and old/new overlap. | More indirection/fragmentation/retirement. Beat actual 16 MB references plus 5.309 MB catalog baseline with full peak accounting and fence-safe lifetime. |
| P1 | Deterministic selected row/tile jobs with actual parallel execution and immutable lease lifetime. | Scheduling overhead, cache sharing, physical output exclusivity, readback/copy dominate small jobs. Compare serial/owned pools, stats, skew and complete pixels under real original traces. |
| P1 | Separate stable geometry/resources from mutable paint only when receivers truly preserve addressing/alias semantics. | Current extraction alone saves nothing; literal detach/common-group repartition/clip dependencies still mutate geometry. Measure removed emissions/leases/copies and all headers/old owners. |
| P1 | Reuse text shape/layout through exact source/font/width owner receipts. | Cross-font/owner aliasing, retained capacity, UTF-8/empty/width-zero/failed callbacks. Foundation deltas are not full runtime reuse; disclose reader/header growth and live capacities. |
| P2 | Avoid Samples initialization on actually uniform prefixes/bands without a second global scan. | Nearly all original primary bands are mixed. Obtain first-mixed/band census and linked init/copy disposition; include rejection and dense animation costs. Option spelling already adverse. |
| P2 | CSR end-offset pass removal. | Already correctness/codegen-qualified; bounded O(T) cut only. Measure representative full-cost consequence after integration, not isolated memmove timing. |
| P2 | Material-user duplicate suppression/sorting alternatives. | One-hot slots still sort nearly all locals; counting-scatter adds zero/scatter passes. First measure edge/unique ratio and skew; no extra algorithm without evidence. |
| P3 | SIMD/branch/layout microexperiments on actual hot kernel. | ISA/code-size/register pressure, stack spills and default-path cost. Matched source/ELF and complete scalar/SIMD bits before isolated host microbench; never infer app speed from instruction count. |
| P3 | Explicit native-backend lazy API initialization. | Default Auto already selects one API; only broad explicit-GPU route is a plausible target. Contributor Vulkan/GL RSS reports are not reproduced current-branch savings. |

### 10. Work distribution and operational lessons

The six native implementation assignments covered three host lanes for storage/parallel kernels/integration and three Mac lanes for native event contracts/GPU ownership/native qualification. Three cloud implementation lanes built canonical damage/retained renderer/text source, with separate adversarial reviews. Assignment count is not proof of continuous execution.

Effort produced real artifacts: ownership/text gates and mutants; core dependency and publication contracts; actual Canvas consuming bindings and scoped producer recording; retained membership/job prototypes; compact storage and memory measurements; regional exact-output tests; CPU cache qualification; codegen-rejected Samples variants; source-guarded compiler repairs; and historical/current-work graphs. It also spent substantial time on staging, packet alignment, rebuild/transfer, resource admission, permission holds, and test-contract repairs.

The coordination weaknesses were material:

- Too many independently correct fragments were described before one actual producer-to-native consumer closed. Metadata enums and source-ready patches are not user-visible completion.
- Repeated review/packaging loops delayed compiler feedback. Small coherent checkpoints should compile earlier, with exact API/header bodies rather than commit titles or peer working-file assumptions.
- A frozen/working-file Phase::Material mismatch was caught; branch ancestry did not guarantee physical source inclusion. Exact file hashes and role-specific manifests are required.
- A missing 17→b80 prerequisite was temporarily obscured by a b80-derived cursor control. Qualification must be a dependency graph, not “tests passed somewhere.”
- Whole-owner zero-change guard needed actual same-color bypass review; receiver fallback still needs a real test. Conservative rejection without handled fallback is not a finished optimization.
- Known allocation/header costs must be declared up front, not discovered as “unexpected regressions” after broad suites. A test ledger correction is not a production memory fix.
- Current host errors/status must be surfaced quickly. inProgress/Working UI is not a running compiler, and queued work is not a result.
- Resource/access guards must stay unchanged; failed attempts and zero-selected tests cannot be laundered into evidence. Access restrictions do not justify proxy retrieval.

The appropriate next report is therefore a single coherent qualification matrix plus matched realistic graphs, with honest full-fallback and negative cases—not a total of source patches, a count of configured lanes, or an extrapolation from scheduled area.

### Dated addendum — 2026-10-26 02:44 UTC

New host results supersede the earlier **pending** status only within these scopes:

- Current Mac P1-native Auto and GPU paths passed the nine-checkpoint gates on physical **Apple M3 Pro / Metal**, with clean exits, reaping and no signals. Coverage includes submission/ACK/backend selection, commands, geometry, and CPU cold oracle. It does **not** establish canonical submitted-scene identity, GPU completion, surface pixels, native display latency, or matched performance.
- Current stable source passed three P1 regressions, Frame/Domain, the named retained case, and 47 corrected core/layout tests. Registered enum controls are qualified. Native arbitrary structs/enums remain unsupported; required cases-trait import and wildcard handling are part of the compatibility boundary, not evidence of arbitrary native-record support.
- Twelve historical native harness traces remain correctness-only and timing-ineligible. No matched native process pairs or new latency graphs are available.

Earlier compile/fixture failures above remain historical facts; these positives do not retroactively erase them or qualify untested canonical/GPU-image authorities.

#### 2026-10-26 02:51 UTC — scoped recovery

Nudox reports **22/22 corrected rendering gates** complete and drained. The coherent merge is frozen with an **accounting failure preserved**; its exact assertion, actual/expected values and source/feature identity have not yet been supplied to this section. Do not call the merge all-green or reinterpret the failure as an approved budget change. Selective positive/mutant/restored work finished, without a new integrated latency claim.

Qualified Mac native/source `a54e27f8`, enum candidate `5e9a287b`, and corrected solver `448ff7bd` on separate `qualification/solver-author-corrections-r33` are distinct qualifications. None establishes that their combined source has been integrated or qualified. Exact accounting-failure evidence is the next missing item, not a reason to erase historical failures.

#### 2026-10-26 02:58 UTC — exact accounting failure and selective controls

- Coherent host source `59acb124a0a2148ffb8cc55d39725f1fb2012491` compiled in release and passed nine focused controls. The preserved failure is `bins::tests::recording_has_no_scratch_allocation_and_first_raster_charges_one_owner`, `bins.rs:471:13`: **Canvas 864 bytes versus legacy expectation 464 bytes**. The declared inline binding is **400 bytes**, exactly the difference. Allocator requests remain **two / 76 bytes**, Scratch **56**, RenderStats **96**, and Frame **88** bytes. This is explicit header growth, not a hidden heap request, RSS measurement or memory saving. The old assertion remains a real failed gate until a separately reviewed versioned accounting correction; the merge is not all-green.
- No target-consumer production code has been written in this reported coherent scope. Contracts and tests are not a completed retained-image consumer.
- Selective source `5c674a8575e796de5c1923bbfb0c92efe9b8ffdf` passed **29 controls**. The omitted-offset mutant reached its intended assertion after cold checks, and a fresh reverse-restored source passed. This qualifies that selective control/falsifier scope, not integration with the unresolved target consumer or a new timing result.

<a id="chapter-7"></a>

## Chapter 7: Realistic benchmarking and research atlas

## Realistic benchmarking and future-research atlas

Status: 2026-10-26. This chapter separates measured historical evidence, source-reviewed implementation, failed experiments, and untried designs. A source review is not compiler qualification; a passing correctness gate is not a speedup. Local paths below are relative to `gui-comparison/` unless otherwise stated. No current unified-candidate speedup is established by the historical charts.

### 1. Evidence that can be graphed now

#### 1.1 Six realistic public interaction traces: historical baseline only

Existing graphs:

- `report/interaction-update/scene-costs.png`
- `report/interaction-update/cpu-output-costs.png`
- `report/interaction-update/raster-phase-share.png`
- Graph provenance: `report/interaction-update/provenance.json`
- Numeric source: `interaction-lane/raw/primary-analysis/summary.json`
- Original contract: `interaction-lane/WORKLOAD-CONTRACT.md`

These are source `1b0eee3b9252b6647f13be63477cb158d21c04c8` over production `7ac6f33`, built with rustc1.101 nightly2026-10-23, **not** the shared stable/Nix shipping qualification. Binary SHA256 `e77873f203e04cbaf3e98193e7870b07ea4cb27c19a76a895514821f9674ed1c`. Ninety-six serial child processes included twelve predeclared priming discards and84 measured children: seven measured processes per scenario/mode, each32 warmups and240 samples. No selective tail deletion is implied by the priming discard.

Headline values are median of seven per-process p50 values, milliseconds:

| Original scenario | Scene p50 | Full CPU output p50 | Full CPU output p95 |
|---|---:|---:|---:|
| App-ticked geometry |1.490|10.225|13.244|
| Hover property, layout |1.155|7.534|10.204|
| Hover property, paint |0.841|7.090|9.543|
| Hover source, paint |0.470|6.692|8.875|
| Popover plus scrolling |1.527|15.915|22.375|
| Window resize, layout |0.548|6.531|8.823|

These are **baseline costs, not improvement ratios**. `total_ns` is the sum of measured public routing/edit-prepare/scene-borrow/optional-raster/logical-ACK phases. It is not an outer event-wall interval, native presentation, display latency, or achieved frame rate. FullCPU mode renders a complete caller output; scene mode does not rasterize. Phase p50s do not add to total p50, and whole-process RSS includes construction/oracles/output.

The six traces genuinely exercise:

1. PointerSession enter/transfer/leave/far jumps with first/last/middle-row hit-routing bands and one source's real background fanout.
2. Typed-property paint contributions, retaining both old-target Inherit and new-target Set mutations.
3. Typed width +4px hover/restoration, with ordinary row-layout sibling displacement.
4. Seven-phase conditional popover open/down/down/reposition/up/up/close above a10,000-row VirtualList. A scroll operation retains **two** real sheets: scroll ACK, acknowledged anchor read, follow transform, follow ACK.
5. Whole viewport1000×1000↔1200×600 with wrapping structural flex controls; no manually derived leaf widths. This is not an article text-reflow workload.
6. Application-driven virtual120Hz triangular width/height/translation changes across all cells. This is layout-changing motion, not a visual-only pose substitution.

Primary side32 contains1,024 controls; side100/10,000-control stress is separate. Grid cells are solid structural controls without text; popover/list text uses pinned Inter14. This eligibility matters: a solid-only repair can help these actual grid traces, but cannot be called a general text/image/clip solution.

#### 1.2 Historical paired CPU-scene experiment

`structures-lane/TIMING-RESULTS.md` and `structures-lane/results/paired-timing/` preserve actual paired wall-time observations, raw samples, tails, process resources and identities. Baseline common harness `7ac6f33`; plain range control `ec2f38a` with shipping source `515b02e`; inline variant `b8b0084`. Same compiler/flags, independent targets;120 process legs completed. Seven retained rounds after an explicitly discarded initial round,32 warmups/240 samples.

The clearest observed result was sparse-owner median paired mean −4.36% plain/−5.49% inline, lower in7/7 rounds. Forced-idle is near clock/dispatch floor, not OS idle/power. Sparse-direct means were noisy; width/edit were within spread; virtual-scroll pairs mixed. Cold construction/complete topology and fast-control gates remained unresolved. This is isolated historical CPU-scene evidence, not today's coherent candidate, GPU or display result.

#### 1.3 An actual rejected CPU-raster candidate

`cpu-raster-lane/RESULT.md`, `evidence/PROOF.md`, `evidence/timing-summary.stdout`, and `evidence/timing-v1/summary.json` preserve control `a4774e1` versus candidate `820ec18` over restoration71cc/archivecc193. Tile-local clip-prefix membership reuse is exact and bounded, with full-output correctness evidence, but the fixed70-leg campaign **rejected** it on four adverse cells. Targeted serial preparation+raster cases improved greatly (24 overlapping draws46.603→12.752ms; depth16 prefix292.798→22.599ms), yet singleton/sparse/shear controls breached predeclared gates. Keep those losses and code/stack/init costs alongside the wins; do not quietly revive it as adopted.

#### 1.4 GPU work graphs are not timing graphs

`render-lane/CHART_SPECS.json`, `work-counts.csv`, and `prepare_chart_data.py` describe360 exact-output checked rows from source `ea60b2d5968378e554b99329d018db4a45693726`, SwiftShader CPU Vulkan. They quantify scheduled scissor pixels, renderer-requested upload bytes, application-encoded pass/draw/submission counts, and logical added-owner payloads. They explicitly contain no timings. Scheduled scissor area is not physical fragment invocations; requested uploads are not measured bus traffic; logical payloads are not resident GPU memory. These isolated graphics fixtures do not prove that scene reconstruction disappeared.

#### 1.5 What is absent

No completed matched current-unified six-scenario timing campaign was found in this bounded local inventory. The parent-reported software-GPU pilot completed zero pairs after an affinity guard failure; it supplies no speedup point. Native presentation, hardware GPU execution, input-to-photon, power, complete physical-memory peak, and full application-wide mandatory+optional budget remain separate evidence gaps.

### 2. Existing reproducible harness and acceptance contract

The original fixture is `interaction-lane/baseline/reactivity/crates/gpui/examples/interaction_workload.rs`,35,639 bytes, SHA256 `833d11326b5100fc48ad54b56172344873a64328a04fa4470a8501ca745f116e`. Font SHA256 `40d692fce188e4471e2b3cba937be967878f631ad3ebbbdcd587687c7ebe0c82`. Keep both identities, exact inputs, operation sequence, subframes and outputs.

`research-structural-lane/COHERENT-BENCHMARK-ACCEPTANCE.md` is the concrete host-controller checklist. Existing implementation-ready protocol source lives in `invalidation-lane/integrated-timing-handoff-20261025/` (`PLAN.md`, `campaign.py`, `summarize.py`, manifest template). Its authored ad322/5d44 pins are **not** today's coherent pins and cannot simply be relabelled. Parent/host must select complete actual control/candidate identities, approve the same stable SourceValue adaptation, features and expanded source manifests, then record new provenance.

Build separately and sequentially under the selected shared Nix stable tools, same release/ISA/allocator settings, fresh targets:

```
CARGO_TARGET_DIR=$FRESH_TARGET CARGO_BUILD_JOBS=1 \
 RUSTC=$NIX_RUSTC RUSTDOC=$NIX_RUSTDOC RUSTC_WRAPPER= RUSTC_WORKSPACE_WRAPPER= \
 $NIX_CARGO build --locked --offline --release -vv -p gpui \
 --example interaction_workload --message-format=json-render-diagnostics
```

Capture command status and complete stdout/stderr; retain actual Cargo `fresh:false` library/example artifact paths and hashes, tool `-vV`, derivation/store, source/input manifest and font receipt. No bootstrap/nightly/diagnostic/allocation-profiler binary in elapsed comparisons.

For each selected ELF and original case, append `--cpu-raster` only for fullCPU mode:

```
COMPARISON_FONT=$PINNED_FONT $ELF $CASE --side 32 --warmup 32 --samples 240 --validate
COMPARISON_FONT=$PINNED_FONT $ELF $CASE --side 32 --warmup 32 --samples 240
```

Run correctness separately before timing. Primary is six cases×two modes, seven fresh matched AB/BA process pairs; alternate whole-case order, preserve every tail, and never retry only losing cells. Report separate warmup0 first-measured-operation history and side100 stress. Even warmup0 runs the original mandatory start oracle and can warm raster/CSR/text; label it first operation **after oracle**, not cold OS/cache or first-ever raster. `cold_construct_ns` is construction, not cold raster.

The original `--validate` compares every actual sheet against fresh **within-variant** cold reconstruction. It does not independently prove cross-variant equality. Use a symmetric separately qualified diagnostic adapter plus existing `invalidation-lane/integrated-core-handoff-20261025/compare-full-outputs.py` to compare ordered public geometry/clip/color words and every active CPU pixel across control/candidate, including all intermediate popover sheets. Keep diagnostic/cold oracle work outside elapsed runs. Empty, partial, duplicate, zero-selected, ignored or failed captures are not passes.

#### 2.1 Scoped text integration is a real blocker, not a feature-flag detail

The historical fixture uses `Win::recording_with_font` with pinned Inter. That constructor remains `WindowAccounting::Unaccounted` even with retained-text enabled; existing `recording_with_resources` selects a default font. Therefore a plain feature-ON build of the unchanged fixture does not establish scoped raw-shape reuse. A separately reviewed context+SAME-pinned-font constructor adaptation is needed before a text-enabled coherent comparison. Never silently replace font, change workload, or attribute core/render gain to unused text reuse. The text owner is auditing this narrow adapter; it is not claimed complete here.

Default-OFF retained-text also means feature contract must be explicit: normal/default comparison tests shipped paths; candidate feature-ON versus an old control lacking that feature must disclose the intended difference and retain candidate feature-OFF isolation control. No fictitious feature parity.

#### 2.2 Minimum measurements and acceptance

- Every step's routing/edit_prepare/scene_borrow/full-raster/logical-ACK/total nanoseconds, operation class/hover ordinal, edit and sheet counts; preserve each of seven process pair ratios, means/p50/p95/p99/max and variability.
- Whole-child wall/user/system, peak RSS, faults/context switches; RSS includes setup/oracles/buffers. Process replicates, not within-process operations, are the independent repetition unit.
- Separately instrument requested allocator bytes/counts, retained capacities and declared phase-snapshot live unions. Label missing opaque/allocator/Arc/parser/driver memory; a snapshot maximum is not execution high-water or RSS.
- Stock source/read/destination/descriptions/layout/measure/paint/presentation counters separately. Measure callbacks are not shape misses; draw counts are not visited nodes.
- Explain raw+packed overlap, child records, backing/ref-vector/index/Weak-shell costs. Optional-root accounting is not a complete mandatory model/packed-output budget.
- Existing predeclared investigation gates: paired mean≤1.05,p95≤1.10,p99≤1.15,max≤1.25; construction/first operation≤1.10; median paired peak-RSS excess≤max(8MiB,5%). Apply per operation class too. These are descriptive acceptance limits, not confidence tests. Parent may choose another policy only before seeing observations. Noise is inconclusive, not permission to trim.

### 3. Prioritized experiment atlas

The following is a backlog, not an implementation claim. Priorities: **P0** finish coherent correctness/measurement; **P1** likely next structural cuts after a measured bottleneck; **P2** conditional or specialized research. Every experiment needs a baseline preserving original errors, ownership and full output.

#### P0 — Finish one coherent dependency/damage path before adding variants

**Mechanism:** common producer identities and phase closure connect source/layout/resource changes to accepted scene/material support, renderer target-base authority and retirement. Retain exact scene revision and surface generation of the target's last complete image. Interaction ACK P is separate: a target can render unacknowledged C or skip C revisions.

**Status:** pieces exist and are source-reviewed; host qualification is composition-specific. Frozen text binding13f383c and geometry extractionf414f7e are not a universal completed system.

**Downside/falsifier:** missing changed/removed-owner history, owner-domain collisions, stale clip/transform propagation, a failed newer stage retiring accepted resources, or publishing complete-image authority before all jobs finish. Force old-P/new-C, render-without-ACK, skipped frames, failed staging, resize/surface loss and two-window shared-backing cases.

**Measure:** actual six traces, original full output, phase/counter attribution, metadata/retired overlap and negative histories. Do not add a new optimization until this baseline is reproducible.

#### P1 — Immutable command-owner segments, not another full-scene cache

**Mechanism:** retain complete existing common-group immutable geometry/resource owners and pair them with explicit mutable paint bank/version. Reuse unchanged owners directly in accepted scene; changed segments rebuild. Local command/mask/clip/image indices must always resolve against their originating owner. Geometry/paint extraction is the bounded prerequisite, not the speedup itself.

**Explored:** `render-lane/IMMUTABLE-COMMAND-OWNER-MIGRATION.md`; `research-structural-lane/{LOCAL-DRAW-FRAGMENT-DESIGN,WHOLE-COMMAND-OWNER-REUSE-REVIEW}.md`. Strict whole-owner Hit/Semantics retarget seam exists; it does not solve partial scene reconstruction.

**Costs:** Arc/control/owner headers, live+staged+retired roots, catalog refs, stable ordering, and paint value revision/in-flight leases. A naive8*N `(segment,local)` directory still retains O(N) storage/build work alongside old DrawRefs. Arc-wrapping the entire previous Canvas causes COW/full-copy or retention chains, not a structural win.

**Falsifiers:** two owners with colliding local0 masks/commands resolve wrong; shared scope max-error partition changes; stale paint version affects queued work; gradient transfer mutates borrowed geometry; Runtime slot reset invalidates otherwise stable roots. Test equal-index distinct-owner masks and exact SDR/HDR/profile bytes, first-error/resource limit order and outstanding queue leases.

**Measure:** producer emissions/traversals, copied bytes, reference visits and owner memory, not only scissored pixels. Compare warm untouched, sparse geometry, dense resize and text/resource scenes.

#### P1 — Remove duplicate source ownership before retaining more text

**Mechanism:** immutable shape owner reads the same concrete whole Utf8Backing as the source witness. A DISTINCT child Utf8Source lease keeps source bytes charged when witness is reclaimed; raw optional owner must not contain its own record lease. Source bytes derive from sealed backing only, never independent text+owner arguments.

**Status:** separate shared-shape-source successor source-reviewed, final tests added, not claimed compiled/executed here. Existing13f binding remains frozen. This removes a String copy, not the raw+packed retention overlap.

**Costs/falsifiers:** extra child record/ref-vector/index allocation and larger inline enum can dominate short strings; child-slot quota can decline before raw capture. Witness reclaim/raw-live must retain source charge once; final raw drop+explicit reap must release it; no self-pin, font ID remint or semantic error swallowing. Preserve measure/full A/B/A bits and no-rerun first-error order.

**Measure:** actual removed String capacities versus extra metadata for empty/short/14KB sources, requested allocations and raw+packed live unions. Do not present reduced copied payload as lower RSS without measurement.

#### P1 — Width-specific views over one immutable shape owner

**Mechanism:** one immutable paragraph owner, distinct width buffers, same original breaker and shared canonical lowering. Preserve exact originating BlobIds/accepted faces. Font-bearing raw owners remain source-side; committed Canvas retains only existing packed positions/masks/geometry.

**Explored:** b80 immutable owner/view, cursor paired-read and shared lowering88d source/gates; current typed consumer follows them. `IMMUTABLE-WIDTH-VIEW-SOURCE-REVIEW.md`, `CURSOR-PAIRED-READ-SOURCE-REVIEW.md`, `SHARED-LOWERING-SOURCE-REVIEW.md` describe the boundary.

**Costs/falsifiers:** line/run/cursor readers gain a reference; raw shape plus packed output can increase retained memory; width views/cursor topology still allocate and lowering still walks output. Inline boxes, bidi/cluster affinities, indentation, emergency wraps, source separators, fallback faces and foreign IDs must match. HoldingA while constructingB/A2 must not mutateA. Old scenes must render after frontend/raw owner drop.

**Measure:** responsive wrapping article plus original popover/list text, exact line/glyph/caret/packed output, build counts, capacities, first width and repeated widths. Avoid a permanent Planner/Collection/parser cache unless measured and explicitly billed.

#### P1 — Optional-retention pressure without mandatory admission inversion

**Mechanism:** context-owned optional roots, producer Weak handles, O(1) typed pins, bounded explicit reclaim and separate bounded ledger reap. Real C/P/GPU lease pins protect mandatory consumers; removing index entries does not itself credit bytes.

**Status:** generic optional primitive and actual weak text binding exist; not a complete App memory limit. Any/Send/Sync does not prove immutable/font-free/same-root payload. Typed adapters must prove that.

**Costs/falsifiers:** extra Root/Arc/Weak/BTree metadata, atomic pins, synchronous destructors under context mutation, stale Weak shells after payload drops. Reclaim one window while another shares backing, race pin/close, fail reservations and shut down context with a live pin. Mandatory payload must not fail only because optional caches consumed the budget; solving full priority needs actual reclaim authority, not hidden second caps.

**Measure:**0/1/128 owners, indexed orphans, retired Weak shells, visits bounded by requested budget and initial rows, final requested-allocation balance and old/new overlap. Metadata diagnostics must not add a full scan to each paint/width hit.

#### P1 — Incremental ordered tile membership and deterministic job partitions

**Mechanism:** transactional old/new supports repair only affected tiles' ordered contributor memberships; immutable committed index yields disjoint CPU jobs. Removal/reorder is as important as insertion. Final global reference bound is computed after subtracting ALL edited old refs and adding ALL new refs, not transient per-tile order.

**Explored:** renderer private incremental index prototype/design, common dependency contract. Not yet proof that record lowering/global catalog preparation disappeared.

**Costs/falsifiers:** tile×draw reference explosion, metadata for sparse/dense cases, stage rollback and dirty coverage. Reordering overlapping translucent draws, clip changes, equal final ref count with add-before-remove, failed partial output, and missing ancestor closure must fail closed. Index revision is not completed output authority; GPU jobs need actual queue/fence leases.

**Measure:** membership edits, refs/capacity, full preparation costs, job balance, CPU cache locality and full output. Compare dense fallback and tile sizes; count no-op traversal overhead too.

#### P1 — Disconnected damage supports and cost-aware scheduling

**Mechanism:** preserve per-change old/new tile supports before bounding-box union; sparse distant edits should not force rasterizing the large empty rectangle between them. Schedule bounded row runs or tile jobs over one full-grid CSR, not repeated preparation per rectangle.

**Status:** paint-only cache proof explores disconnected tile union; geometry repair currently still full packet preparation plus scissor. Do not claim scissor eliminates scene preparation.

**Costs/falsifiers:** bitmaps/runs, repeated contributor replay, extra passes, fragmented upload/submission overhead. A tiny scattered support can touch many bins; conservative clip/max-error boundaries must include all influence. Old target-base revision and surface generation must match; unsupported resources/clip chains fall back full.

**Measure:** full end-to-end output phase plus preparation/upload/job counts, sparse-local versus dispersed/dense, first seed and resize. Compare one bbox, row runs and tiles under the same original operations; never infer time from area ratio.

#### P2 — Paint-only packed CPU output preservation

**Mechanism:** optional packed image under existing boxed scratch; only prevalidated atomic paint-slot transitions preserve it. Every geometry/resource/config mutation invalidates. Initial direct; first later sparse update pays full render+seed; warm repair updates disconnected tiles then copies the ENTIRE active caller output. One full-grid preparation; dense direct fallback.

**Explored:** `CPU-OUTPUT-CACHE-EXPERIMENT.md`, `CPU-PAINT-ONLY-CACHE-AUTHORITY-REVIEW.md`, renderer `CPU_OUTPUT_CACHE_FEASIBILITY.md`. This is a narrow proof, not the innate general damage model or an accepted universal path.

**Costs/falsifiers:** extra full packed image and full destination copy can lose; diagnostics RGBA must decline/drop packed cache in strict first-proof policy. Invalid destination between two commits must leave pending dirty/image authority and caller bytes unchanged. Extent, proof setting, literal paint, unused resource publication, clear, failed stage and all mutation barriers need exact tests. Padding/oversized buffers must preserve original InvalidDimensions behavior.

**Measure:** seed, steady sparse, no-op copy, dense/resize, output bandwidth and requested allocation; do not hide the first seed or mandatory full caller overwrite.

#### P2 — Unchanged-suffix rigid movement after real flow changes

**Mechanism:** when a genuine layout change leaves an unaffected subtree's shape/size/style identical, move its retained draw/clip/hit/accessibility frontier by a certified rigid delta instead of reconstructing geometry. Existing reference zgui951a0ea3 requires same size/border/padding/margins/overflow/scrollbars, integer device movement, no transformed ancestry and rigid descendants.

**Explored research only:** `codegen-review-lane/REFERENCE_RETAINED_MOTION_REVIEW.md`; not implemented/adopted in GPUI. MyGo9c69cf82 samples poses then updates only outermost changed world-transform roots, but still resets/paints/presents the retained tree. Visual pose is not equivalent to current layout-changing width/SpaceBetween traces.

**GPUI blockers:** viewport-clipped content omitted at original emission may become exposed; integer motion must preserve text raster phase; local masks/paint indices must remain owner-paired; group max-error repartition and ancestor clips can change. Damage is union of old target-base and new admitted supports, not universal old ACKP/newC.

**Measure/falsifiers:** exposed clipped suffix, text at fractional scale, nested clip/filter/transform, sticky/fixed/scroll descendants, partial visibility and reverse moves. Compare full cold output/hit/AT, not only submitted geometry. Eligibility certification/traversal cost is part of result.

#### P2 — Broad list realization and dependency closure before row certificates

**Mechanism:** unchanged list topology/width/scroll/anchor dependencies can skip realization even when an unrelated transform changes elsewhere. Reuse actual complete producer history and explicit ancestry/dependency closure, not benchmark-specific row counts.

**Explored:** disjoint-transform source cut and primary trace eligibility review. Uniform-row certificate remains lower priority: restricted semantic specialization, O(N) placements retained, certification/default-path cost charged. Never hardcode primary32/columns or alter fixture to fit.

**Falsifiers:** transformed ancestor affects viewport, nested Scroll/List ancestry, source structural reads, text/layout destinations, size/scale/pending plan, changing membership/anchor, unknown site identity. Recompute clip/hit/AT and normal patch/present where required.

**Measure:** actual popover scroll+anchor follow and list realization counters, cold open/close, retained topology edits and viewport changes; ensure reduced describe/realization is not merely cached TextLayout called shaping elimination.

#### P2 — Cursor topology reuse, output streaming and memory layout

**Mechanism:** immutable paragraph topology can support repeated cursor indexes/line views without rebuilding source cluster maps, and canonical lowering might stream directly to final packed output rather than retaining duplicate intermediate arrays.

**Status:** paired-read correctness seam exists, but broad topology reuse/direct streaming is untried. A new index must derive from exact owner+width pair and preserve both-affinity every-byte semantics, including usize::MAX handling. Direct streaming must preserve first error and required reserve/admission order.

**Costs/falsifiers:** another retained index may exceed recomputation cost; source/width lifetime errors, bidi boundaries, line separator semantics and fonts kept alive by renderable output. Test A/B/A held cursors, fallback runs and frontend-drop scenes.

**Measure:** repeated caret queries and actual wrapping/edit traces, index construction/capacity, stack header growth and final packed output; no pointer-size-only performance claim.

#### P2 — SIMD/branch/cache microexperiments only after dominant pass attribution

**Mechanism:** optimize required dependency checks, bin/clip membership, vectorized coverage and cold/hot branch layout after macro measurements show that work remains dominant. Existing structures timing and rejected clip cache show why local wins do not guarantee end-to-end acceptance.

**Costs/falsifiers:** code growth, i-cache pressure, initialization memset, larger stack frames, unpredictable sparse branches, backend divergence and parallel overhead. Keep assembly/linked text size and adversarial no-clip/singleton/sparse/dense controls. No unsafe/uninitialized memory merely to remove initialization without full soundness proof.

**Measure:** batched cheap operations to separate clock floor, all process tails, per-backend exact output and actual app phase attribution. A nanosecond fast-path win is not evidence for millisecond resize improvement.

#### P2 — Native initialization and software-GPU affinity: independent investigations

**Native initialization:** contributor Vulkan-first/GL-fallback RSS102→83MB on NixOS/RADV is contributor-reported, not reproduced. Local default Auto, explicit GPU and offscreen paths differ; software offscreen Vulkan-only timing cannot benefit from removing a GL initialization path it never enters. See `VULKAN-FIRST-INITIALIZATION-REVIEW.md`. Future native memory experiment needs actual backend init/destruction allocations and same app/device, not transplanted percentage claims.

**Software-GPU affinity:** observed `interac:disk$0` expanded assigned CPU14 to0–15. Primary Mesa26.2.5 disk-cache queue requests SET_FULL_AFFINITY; source is strongly consistent, actual Nix patchset/syscall attribution still unverified. Minimal source-only proposal removes just that flag, preserving priority/cache/jobs. No driver build/install/environment/cache-disable override is authorized by the proposal. See `MESA-DISK-QUEUE-AFFINITY-REVIEW.md`. A changed dependency requires fresh selected-history exact preflight and a wholly new matched timing configuration; the failed0-pair campaign remains preserved.

### 4. Acceptance philosophy and handoff boundary

The fastest next step is not another cache. It is to qualify one coherent source, compare the original realistic operations under matched tools, disclose losses and memory overlap, and use that profile to select the next pass-eliminating cut. Resource identities must represent actual ownership domains, not raw counter casts. Local indexes always travel with their owner. Publication ACK, accepted scene revision, target's complete-image base and GPU completion are distinct authorities. Optional retention can disappear without invalidating accepted packed output; mandatory output cannot disappear merely because a cache entry was reclaimed.

No item above authorizes host builds, security/affinity changes, driver installation or new benchmark execution by itself. Parent/controller coordinates actual host permissions, quiet window, current pin selection and acceptance. All source-only deliverables and failed experiments remain useful evidence, but none substitutes for current coherent full-output and elapsed measurements.

#### Constructor follow-up (02:37 UTC, source-only)
A separately reviewed21-line successor in `paragraph-view-lane/font-resource-constructor` adds `recording_with_font_and_resources`, forwarding the SAME supplied immutable font and context into the existing mount. Its authored test checks exact same_face in stored/system font, actual raw admission, and ordinary same-font cold pixels. No compiler/test execution is claimed here. This closes only initial constructor expressibility: subsequent property/source/pointer/resize/scroll operations still need explicit scoped resource threading and full trace qualification. It does not retroactively qualify a feature-ON unchanged original fixture or change the historical font identity.

## Original-design crosswalk and complete corpus

The full companion [DESIGN-CROSSWALK.md](DESIGN-CROSSWALK.md) is an integral part of this brief, with every original file linked and all SHA256 values available in [the manifest](ORIGINAL-DESIGNS-MANIFEST.json). The original sources are authoritative; the engineering chapters report implementation progress, not replacement statutes.
