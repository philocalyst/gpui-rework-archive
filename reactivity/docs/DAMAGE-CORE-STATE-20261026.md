# Core damage model, solver and canonical publication checkpoint

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

## 1. What is actually collected

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

## 2. The authority model

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

### Transactions, failures and ACK

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

## 3. Journal and dependency closure

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

## 4. The solver is an existing incremental authority

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

### Bounded old-layout evidence

The GPUI journal retains earliest old and latest new final Layout values for
changed full capabilities. It is not a persistent N-node layout or f64 transform
mirror. Its internal optional policy is 64 combined evidence cells, with a
compile-time upper bound of 16 KiB for key/value payload. BTree allocation and
headers are additional, as is one active stack-local question. Exact host size
and allocation measurements remain required.

Initial/full rebuild history is already unusable: it does not allocate new
records. Once incomplete or overflowed, new identities are not accumulated on
repeated failed turns; existing earliest-old records are retained. Successful C
resets the optional budget. ACK and failures do not. If repair rebuilds the arena,
the old capability record is diagnostic evidence and the history is explicitly
incomplete; it is not continuous reconstructable placement across the arena gap.

### Input is not output

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
presentation walk. Parent Placement/Clip fanout still exists when the actual
outgoing context changes. Exact f64 context cancellation and immutable segment
reuse are not implemented by this cut.

## 5. Style semantics, not mutation-route guesses

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

## 6. Canonical metadata revisions and existing token behavior

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

## 7. Retained layout and practical costs

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

## 8. Compatibility that must not be optimized away

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

## 9. Actual evidence and failures

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

## 10. What is still missing, in priority order

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

## 11. Acceptance and measurement gates

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

## 12. Worthwhile experiments not yet earned

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

## 13. Rejected or deliberately deferred approaches

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
