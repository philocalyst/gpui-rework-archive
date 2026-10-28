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
to the existing recoverable NaN radius admission error. Full qualification at cee7b76d00 passes: 1001 default tests, 1086 X11 tests,
74 GPU tests across all three supported formats, 319 minimal-native library tests,
strict Clippy, 10 standalone port tests, 11 actual native scripts and four minimal
native scripts. The original control independently fails the same full-pixel
witness at c62df431b53b and passes after the shared prerequisite at 1e46391250d8.
A same-window/wrong-sequence mutant reaches the new witness and fails actual
pixels; omitting one sparse region independently fails GPU pixels.

The four-way cost protocol is frozen at 4a1e6f24c748: corrected original control,
failed local-publication predecessor, precise bounding-only variant and bounded
sparse repair. It includes the original ten native-bridge cases plus eighteen
small-text controls (0/25/1000 unrelated labels, 1/2/4 changed fields, source/owner).
Twenty-four balanced orders per case give 2688 fresh timing processes after
336 correctness and 112 allocation processes. No timing verdict exists yet.
This measures Win operation through GPU completion/ACK; it excludes event dispatch,
active NativeHost accessibility-provider projection, WSI and display scanout.
Current test-only fixture rebuilds do not alter the qualified production source.


## Complete glyph-damage result and next isolated hypothesis

The complete four-way dossier is227a0567f912719d741a609c18b76f7f16d0e6c3 on
local/glyph-damage. Its independent verifier checks10421 files,1131 preserved
ELFs,2688 timing processes,336 qualification and112 allocation processes.
Source-stream/control0.107037387 (95% interval[0.105273399,0.112999304]) and
owner-stream/control0.109522705 ([0.106187406,0.119072611]) are substantial wins.
The fixed verdict nevertheless fails: flat-tiny exceeds1.05 versus all three
controls (1.073339175/1.056318804/1.117021753); flat-full versus original/bounds
is1.058354510/1.069131172;25-label four-field source versus bounds is1.058992056.
Wide intervals on tiny-flat do not waive the registered failure. No adoption or
ZGX/hardware ranking follows. Every process passes exact output/work checks.

The source/candidate image authority prerequisite is qualified in all variants.
Candidate1001 default/1086 X11/74 GPU/319 minimal-library tests,10 port,11 native,
4 minimal scripts and strict Clippy pass; corrected predecessor/bounds1083/1085
X11,10 ports each and11 native scripts each also pass. Region omission and
same-window/wrong-sequence mutants fail actual pixels. Main runtime, renderer,
backing and GPU surface headers remain equal across variants; candidate TextPatch
40→96 and SceneDamage24→32. Streaming adds5 allocations/7320 bytes over bounds,
with unchanged net bytes and GPU image/copy work. Shipping37361 lines versus
original36956; native example26306728 versus26306384 bytes.

Next hypothesis: separate ordinary and regional GPU submission through static
internal output types, restoring the original ordinary Output, retained render
and GpuContext submit bodies. Shared preparation can specialize per output type;
charge any duplicate machine code and cold cost explicitly. This applies BBTree's
call-site isolation lesson without adding an executor, changing update admission,
weakening image authority or introducing new shaders/resources. The current shared
repair enum changes ordinary render/submit code; that is a concrete difference to
test, not an established cause of the six failed comparisons. A new preregistered
trial must retain original, bounding-only and failed sparse-repair controls.


## Completed region batching result

Dossier b165ec9b62a8cf308c0b693f8a92fe819c30a5e4 rejects instanced repair rectangles.
The complete fixed matrix finds streaming8.4% and owner-stream7.2% slower than
static sparse repair, with about100ms first regional use. All unaffected controls
pass. Draw-count reduction alone did not reduce the measured complete work.
This is not an async-runtime/cache-hit result; the original fragment math remains
unchanged. The next locality question is the existing scroll copy's coarse repair
bounding box outside an already proved copied rectangle. Solid/Ripple's precise
publication and BBTree's preservation of unaffected facts motivate composing these
proofs, while exact image-token authority remains mandatory. Old scroll-copy
mixed gains and tiny-control failures are both retained, not relabeled adoption.


## Precise scroll repair: complete rejected trial

Sealed dossier `53165424be4665a9874b6f3f5f31aa0d301e57ed`, measured source
`5a07d7c28ffe500a5d24e25fdf1f31ce4857811f`, is local at
`/home/user/gpui-scroll-sparse-lab/reactivity/evidence/scroll-sparse`.
Independent verification covers 11,054 files, 2,800 timing / 420 correctness /
140 allocation processes, 1,066 preserved ELFs and 1,190 archived cache identities.
The initial packaging manifest accidentally skipped two nested manifest.json files;
its preserved copy and corrected exact-path coverage check document the repair.

110 of 112 fixed comparisons pass. Text-0-2-source/static is 1.050606079
(95% paired interval [1.014711041, 1.080154960]); text-1000-1-source/glyph-bounds
is 1.052126970 ([0.993000873, 1.072074686]). Both exceed the fixed 1.05 point
limit. The trial is rejected; intervals do not waive either failure. No native
ZGX comparison or selective rerun follows this result.

Scroll/original is 0.083086662; mixed/original 0.066503121 and mixed/copy-bounds
0.150539480. Precise repair reduces mixed repaired pixels from 169,280 to 15,770;
both copy variants charge 1,401,440 copied pixels and 4,185,280 retained image
bytes per ordinary workload update. All tiny-list comparisons pass in this
cohort without revising older failures. Candidate first updates have no new
pipeline spike. Full/minimal/default/offline GPU gates and strict Clippy pass;
omitting a repair and bypassing the exact predecessor each fail actual pixels.

Runtime/Output/Renderer/RetainedRenderer headers are unchanged. Backing grows
112 to 120 bytes; Metadata 264 to 272; SceneDamage 32 to 40. Shipping code is
37,977 versus static sparse 37,372, and native ELF grows 42,888 bytes. Ordinary
render source is unchanged but its machine code grows 36 bytes. These are
observations, not proof that the two marginal failures are caused by ABI size.
In particular text-1000-1-source/static is 1.003176, while the failure compares
to an older glyph-bounds control. Do not assign a cause from this timing alone.

The next investigation found another concrete lost fact: complete scene commit
collapses all changed command support to one bounding rectangle. Successive
public source edits before ACK also require the union of all preceding candidate
damage; simply applying precise damage from the latest candidate would omit
older edits. A new trial will test bounded support accumulation with exact
P-to-C token authority, preserving existing scroll and single-text paths.
This transfers preservation of unaffected facts and coherent publication from
BBTree/Solid/Ripple; it is not a cache-hit or custom-runtime claim.


## Complete scene support: rejected, with publication lifetime follow-up

Dossier 7494c10970d3dc46e7611d4abe93ab8476682a6e at
/home/user/gpui-scene-support-lab/reactivity/evidence/scene-support independently
verifies 10,746 files, all 2,800 timing / 420 qualification / 140 allocation
processes, 930 preserved ELFs and 1,178 archived cache identities. Source
92bfac4445c8b518b945c384fe6ff83ed772ae4f follows preregistration c025341544b45f5b27e405ad8372c332aa333498
and identity correction b4188e7cedc008f6d8b48f03da6173af54c7458d.

The complete fixed gate rejects the candidate: 93 of 112 comparisons pass.
All sixteen new primary comparisons miss <=0.8. Candidate/prior-precise ratios
for zero-label two/four-field source/owner cases are 0.957668610, 0.978111523,
0.982732532 and 0.955903594. Repair areas shrink from 1,430 to 780 and 3,510 to
1,560 pixels, but complete operations improve only modestly. Three regression
failures remain: flat-tiny/static 1.059724779, 1000-label four-field source/original
1.052945383 and /prior-precise 1.051235628. No threshold change, selective rerun,
adoption or native ZGX comparison. Earlier failed trials remain failed.

All functional, native, minimal/default/offline and strict Clippy gates pass.
The omission fault fails GPU pixels at case 0/tick 3; a review script's incorrect
tick-1 expectation is preserved and corrected without rerunning. Dropping prior
pending damage fails the existing coalesced scroll+owner Rows fixture, with
2,540 of 20,480 image bytes wrong. The intact candidate also passes the new
multi-source Page fixtures; do not claim the negative run reached them.

Shipping code grows by 116 lines, native ELF by 7,912 bytes, and present_walk's
observed local stack reservation by 64 bytes. Header sizes stay unchanged, and
the shared SceneRepair enum fits the existing 72-byte allocation. The global
scene comparison is rejected. Do not infer its few-pixel savings remove the
fixed packet preparation, submission and complete presentation-copy costs.

Inspection before choosing another representation change found a more direct
repeated cost: try_sparse_text allocates TextPatch on every accepted update;
acknowledge consumes that box, and a coalesced full candidate drops it too.
DamageRegions may allocate another bounded vector each time. The allocation
lifetime need not equal the candidate's authority lifetime. A next isolated
hypothesis can retain an owned workspace while an Option payload marks whether
it contains a live candidate, clear region contents while retaining bounded
capacity, and keep full token checks. ACK must move text/geometry exactly once;
failed preparation and full supersession must retire active content without
publishing cached state. Reclaim the workspace with its text resources.

This is a concrete reuse question, not an assertion that heap work caused the
marginal failures. The previous text-session and cold-trim trials concern shaping
scratch, not this publication box. Do not carry the rejected global comparison
or assume the promising 72-byte enum itself improves execution. No next candidate
has been implemented or measured at this checkpoint.

## Publication workspace experiment: implemented, qualification in progress

Preregistration bc6d01564477a0c8b5710b338a29119d991fadaf and candidate
41a67473a0177fbb17df1f7b8e2f2f36dd6940f6 are isolated at
/home/user/gpui-patch-workspace-lab/reactivity/evidence/patch-workspace.
Base remains 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f; the rejected global scene
comparison is absent. An Option<TextUpdate> separates live payload from reusable
Box<TextPatch>. ACK takes the payload, full supersession retires it after successful
preparation, and repair exposure requires live content and the original exact token.
DamageRegions::clear retains bounded capacity with the same canonical empty view.
Unused text resources still reclaim the box and vector. No application API, GPU
submission, shader, dependency or unsafe change.

The initial Canvas test omitted the established one-pixel conservative slot fringe
and expected 12 pixels instead of 44. That failing run remains preserved; the
correction changes only the test. Canvas/GPU 347 tests and full-native 1,106 tests
pass (3 and 45 intentionally ignored), as do strict Clippy, 17 example tests and
all 11 actual native scripts. A bounded mutant, 5d24115d28, omits full-supersession
retirement and fails the exact public acknowledged-text oracle: stale "1111" versus
required "2222", with the other row intact. Two reserve-precheck aborts are also
preserved; neither compiled or ran the mutant. Qualification is not yet complete.

Measured headers remain Runtime 1824, Prepared 40, TextResources 168, TextPatch 96
and SceneDamage 40 bytes in the native build. Shipping code is 38,016 lines (+39)
and native ELF 26,389,256 bytes (+936). This establishes neither an allocation win
nor speed. Six mandatory warm-allocation reductions precede timing. The fixed
10400-process schedule expands short-control sampling before implementation:
20 paired groups for the four primary workloads, 120 for tiny flat/list, 80 for
all other cases. Thresholds and all earlier verdicts remain unchanged. No timing
has run at this checkpoint. BBTree continuation ownership and Solid/Ripple staged
publication motivate the lifetime split; cache-hit rates remain unmeasured.

## Publication workspace: complete local gate passes; native comparison admitted

Dossier **f7b3f60c70faf6d548fffda530d4de83b2570e34** independently verifies 33,600
files, 10,400 timing / 420 qualification / 140 allocation processes, all 112 fixed
point comparisons, 930 preserved ELFs and 867 archived cache identities. Measured
source remains 41a67473a0177fbb17df1f7b8e2f2f36dd6940f6. All six allocation gates
pass: stream and owner-stream save two requests/608 requested bytes per warm
update; the four required small source-edit cases save one request/96 bytes.
Every qualification frame retains exactly the same composited/copy/image work
as precise scroll, and all exact output/epoch checks pass. All full/default/
minimal/offline/native/Clippy, lifetime-fault, shader and header gates pass.

Paired candidate/original p50 ratios are scroll .085834647, mixed .067493327,
stream .102916904 and owner-stream .104567052. Versus precise scroll they are
1.032461123, 1.013385064, .985136374 and 1.002756599. The large original-control
gains are inherited from the combined earlier work; reuse's incremental timing
benefit is small and uncertain. Its deterministic allocation reduction is real.
The largest unaffected-case point regression is 1.020708454 (1000-label two-field
owner versus precise scroll), within the fixed 1.05 limit. Some confidence
intervals cross 1.05; acceptance was explicitly based on fixed point gates.
No sampling rule/threshold changed, no observation was selected or repeated,
and no earlier failed cohort is reclassified. There is still no cache-hit claim.

Native experiment **03ca419868b0d538e6847e59b60424a31aa32dfa** is preregistered
at /home/user/gpui-native-workspace-lab/reactivity/evidence/native-workspace.
It compares original/static-sparse/candidate/ZGX with matched fat-LTO/CGU1
profiles and exact preserved control ELFs. Four modes, eight balanced groups,
128 eight-second observations; all active candidate/ZGX cadence checks precede
CPU-ratio inference. Candidate/ZGX <=.8 CPU-rate ratios are required in each
active mode; idle has a fixed zero-update/.01-core gate. It carries no production
or workload edit. Hardware, scanout, input-policy and AA/quality gates stay open.
This native trial has not been measured at this checkpoint.


## Native outcome and startup diagnosis

The workspace native trial is sealed at344c7f8ddd55326dca2c88322f67530914c97733:
all128 processes exit normally, but56 cadence observations fail, including all8
candidate stream runs (450–455 updates versus required464–488). Scroll/mixed
candidate cadence passes; paired candidate/ZGX CPU-rate medians8.068852596 and
6.055584861 fail the .8 gate. Idle passes. Independent verifier reconstructs1474
files,128 observations,20 preflights and52 app tests. No adoption or ZGX claim.

Diagnostic d8ca07eb04bc520c77a5c79193ee667990cf3e02, sealed
**a34b61c86fbbc6906d834e071bdb7c4fb70aac8d**, reuses the exact two native ELFs.
All52 observations and639 manifest entries verify. Empty-start stream has exactly17
ACK gaps>25ms in the first second in all12 exact/owner runs, none later; all12
prefilled candidate runs admit359/6seconds with no such gaps. Initial190 changes
both text and scroll state, so this supports startup dependence, not unique causal
identification of glyph growth. Warm offscreen fixtures seed190. Main thread
medians .071–.130cores are much smaller than named llvmpipe .557–.992cores;
thread names do not establish source stacks or cache misses. Instrumented CPU
rates are not interchangeable with the earlier uninstrumented trial.

New **local/damage-suffix** preregistration0a7f3b822b09744e7e45a1ac9961d8aaa183a416
at /home/user/gpui-damage-suffix-lab proposes trimming only exactly equal suffix
contributions when display-stream lengths differ. Existing forward pairing shifts
unrelated retained draws after inserted glyphs. The first unequal reverse pair
must retain both supports; a bounded omission mutant will test this. No new
publication representation, storage, API, shader or executor. This competes with,
and does not reclassify, the earlier rejected global scene-support experiment.
Startup cadence must pass before a fixed complete warm regression matrix.

The BBTree batch document was re-read at1c72bd27994ed0a38694b029618e80115e22644f
alongside the pinned Solid/Ripple research. Its benefit overlaps independent
memory-miss chains; it cannot by itself remove the dominant repeated raster work
observed here. Preserving already established equality through scene publication
is a separate algorithmic application of retained validated state. Async gather
and coherent ready-group publication remain hypotheses for actual measured graph
bottlenecks, with the earlier lane failures kept intact.


## Exact unchanged suffix: qualified startup win, complete regression gate pending

Production source **df8ca59f69813e7dd05711fead98ed4278f1688d** adds 12 shipping
lines to `Canvas::damage_from`. When command counts differ, compare backward
through the exact unchanged suffix before the existing forward comparison.
Retain both supports at the first unequal reverse pair. The same exact command
certificate (geometry, color, clip, material and immutable glyph lease identity)
remains authoritative. No new retained storage, unsafe code, API or shader change.
The test-only example visitor is excluded from the shipping count and timed path.

Correctness/code-cost dossier **380db598cdbed2dd81c5a41745473c40a876f148** is
independently verified: all five configurations and 15 actual native checks pass;
100 cold-stream fresh-reference frame comparisons pass, including skipped ACKs.
The bounded omission mutant fails exact changed-pixel coverage at (44, 2).
All hot headers remain unchanged. Default-release native ELF grows 864 bytes;
`damage_from` machine code grows 1,860 to 2,499 bytes and its local stack
reservation 936 to 1,272 bytes. Build reserve stops occurred after passed test
suites and preserved ELFs; separate frozen-source remainder gates completed.
These stops and the initial rejected cleanup attempt remain in the dossier.

Native startup dossier **bea6c4cf9135f494925ccd80b05f584e20fe7ff4** independently
verifies all 32 eight-second processes, six preflights and exact artifacts.
Every candidate run (eight exact-source and eight owner-route runs) produces
479 updates and one ACK gap above 25 ms in the first second. Baseline produces
445–455 updates and 17 such first-second gaps in every run. No later gaps occur.
All 16 candidate runs pass the fixed 464–488 update and at-most-two-gap gates.
No reruns, subsets, threshold changes or claim about historical failed trials.

This intervention supports excessive damage from command-count shifts as the
startup cause. It is not a custom async runtime or evidence of higher cache-hit
rate. The BBTree connection remains eliminating repeated dependent work while
preserving exact identity; Solid/Ripple distinguish speculative computation
from publication and retained authority. None licenses weakening ACK validity
or moving mutable owner work into independently scheduled tasks.

The preregistered complete regression continuation is **64e90ba23d** on
`local/damage-suffix-cost`: 168 qualification processes, 56 allocation probes,
and 4,160 timing processes across all 28 cases. Every paired median process-p50
ratio must remain at most 1.05 versus qualified pre-change composition, and all
four warm invoking-thread allocation measures must not grow. Exact pixels,
epochs, copy/image work and unchanged headers remain mandatory; composited
support may shrink but cannot grow. The runner, analyzer, checker and independent
verifier are frozen before observations. No cost results yet at this checkpoint.

Remaining goal: steady-state raster workers still dominate CPU. The prior
whole-native trial's scroll/mixed ratios 8.07/6.06 versus ZGX remain failures.
The startup win does not establish overall superiority, hardware GPU behavior,
scanout latency or quality parity. Any next shader/sample lowering experiment
needs its own exact numerical certificate, failed mutant and preregistered full
cost gates; the old pixel-uniform experiment remains rejected. All work local.


## Exact suffix complete regression passes; mask-address lowering begins

Regression dossier **f90ca6b10844b9c7c828e37e310021d0e270df6c** independently
verifies13,274 raw files:4,160 timing processes,168 qualification processes and56
allocation probes. All28 fixed point gates pass; paired median ratios range
0.973507727–1.019494719, all<=1.05. Some bootstrap intervals cross1.05: this is
not a statistical upper-bound claim. All112 warm allocation comparisons pass,
exact pixels/epochs and copy/image charges match, damage never grows, and hot
headers remain unchanged. No failed/retried timing processes or passing subset.
The source/API/shader/unsafe/storage limitations of the startup win are unchanged.

The next isolated hypothesis is **local/mask-lattice**, preregistered at
**d3b1c9c49b6fd4ee4585c3977e9b6352b9716020**, implementation
**7798bfd650dfe571d8edf391886a46e245df913d**, with independent pre-change oracle
**6faae98aa7391ede8f07f9325e63f044f1de9adf** containing the identical public GPU
fixtures. No correctness or performance result yet. New-checkout index setup
faultc9fc88fa29 is preserved before the corrected production-identical prereg;
no build/test observation was made from the bad checkout.

For unit inverse axes and equal mask/logical dimensions, bounded dyadic origins
and translations permit exact f64 scalar mapping. Quantizing only the uploaded
sampling origin to ceil((origin-1/8)*4)/4 preserves every texel address and
half-open edge at the fixed odd-eighth sample lattice. Canonical geometry,
clipping/corrections, CSR bounds, atlas leases and publication identities stay
unchanged. A per-placement material bit in existing records allows the shader
to skip repeated inverse/normalization/error arithmetic. All16 correlated samples,
blend operations and anchor/delta reduction remain. This is distinct from the
rejected pixel-uniform sample collapse and has no new pipeline or retained index.

A full independent exact pixel oracle, numerical-boundary tests, bounded mutant,
configuration/native gates and matched end-to-end screen are required. The
screen's stream/mixed CPU improvement target is20%; scroll must not regress5%.
Only a passing screen admits the28-case full cost matrix, followed by a new
matched ZGX comparison. The dyadic proof and implementation are hypotheses until
validated; software Vulkan cannot close the physical hardware/quality gates.

BBTree's memory lanes overlap independent dependent-load chains. Here the
measured bottleneck is repeated raster arithmetic, so address lowering applies
the internal-operation/cost-accounting lesson without claiming an async-runtime
or cache-hit breakthrough. Solid/Ripple publication/retention semantics still
constrain which prepared data and immutable resources a visible update may use.


## Mask lattice narrowed after exact GPU rejection; qualification complete

The first scalar certificate was insufficient: source837a23d44e produced12/336
independent GPU frame mismatches near an odd-eighth sample boundary, despite
passing scalar-address tests. All rejected bytes and attempts are preserved.
Production9e4ef386f193a17d74bda63867b0ca4c86e0e59e adds a separation guard
using the uploaded error bound; ambiguous boundaries retain generic sampling.
No tolerance, sample reduction or publication change was introduced.

Qualification seal **677b1fb7a51a7bab12dbad0bf4e8815fcd254b74** independently
verifies2,026 files,411 executable identities,five configurations and15 actual
native checks. All336 frames agree exactly across unchanged oracle,revised WGSL
and offline builds. The bounded width-guard mutant still fails at its exact
texel-address witness. Shipping code grows61 lines; default native ELF grows
1,232 bytes; hot headers are unchanged. These are correctness and cost receipts,
not a performance result.

Native screen **ca5a289640b8cd60525fbe599a0a19c3e184a503** uses the exact
suffix baseline and a matched opt3/fatLTO/CGU1 profile. Both build and17 workload
tests pass. The fixed64-process idle/scroll/stream/both screen remains pending,
with20% stream/mixed CPU and5% scroll regression limits; failing work/cadence
suppresses a whole mode's ratio. A pass admits the separate28-case cost matrix,
then a fresh ZGX trial. Physical hardware,scanout and quality gates remain open.

This experiment tests whether immutable placement preparation can remove repeated
raster address work without disturbing Solid/Ripple publication semantics. It
does not establish a BBTree-style latency-hiding runtime or increased cache hits.
The pinned BBTree design's independent memory lanes remain a separate hypothesis
whose usefulness must follow measured dependent-load stalls and complete costs.


## Mask lattice native rejected; bounded fetch reuse isolated

Native seal **b8e6667b3f93130e80776f46a3b7cb7ac1fafadd** independently verifies
824 files,64 normal processes,10 preflights and34 workload tests. All active
runs produce479 updates. Stream paired CPU ratio.960680128 (95% paired
bootstrap[.884411214,.995055403]) fails the<=.8 target; scroll1.009169198
passes its<=1.05 point gate but CI extends to1.0856. One candidate mixed run
(group2) has a late>25ms ACK gap, so the whole mixed ratio is suppressed. Idle
observed CPU/updates remain0. The candidate is rejected without cost-matrix
admission; numerical qualification does not change that result.

A separate **local/mask-quad** experiment is preregistered631a132f5528f70ac426d40d5a7865347524ccb9,
implemented4af395b9664b724720ece82d8ce624d18a3b1bcc. It tests the combined
mask certificate plus at most four distinct texture fetches per banked mask
pixel. All16 original color products/blends and anchor/delta reduction remain.
Only full rectangular clip membership admits caching; chains/edge pixels retain
generic sampling. No adjacent atlas reads, new pipeline, retained storage or API.
The bounded Y-selection mutant0a508aba22064461b53db62225ce5d1cce24c07e must
falsify independent exact public pixels. Qualification is in progress; no result.

This separates independent address/fetch work from dependent consumption, a
limited transfer of BBTree's batching lesson. It does not transplant its unsafe
prefetcher or memory-only noop-waker into real tasks, nor assert cache-hit gains.
The full64-process screen retains20% stream/mixed CPU targets; unchanged complete
configuration/cost/hardware gates follow a screen pass. Old pixel-uniform flat
regression warns that added shader/register costs may erase gains even on paths
with no new cache hits; no passing subset or tolerance will waive those gates.


Four-cell early correctness admission is sealed
**e00f436fbfef57bdc0379df6e46c6888d7855097**, production
**7565d788dcdf62f87c43a2d4910764a3ff2be764**. Independent verification covers
1,421 files,70 ELF identities,353 GPU/canvas tests,strict Clippy,336 exact
pre-change-oracle frames and96 external pixel rejections for the corrected
wrong-row mutant849ea944. The mutant's own replay test passes; only independent
reference pixels expose its mistake. Initialsource4af395b9's overwritten-local
Clippy failure is retained; corrected source was rebuilt after release GPU clean.
Generated WGSL21978 bytes is verified inside the freshly executed render ELF.
Shipping38163 lines (+74 parent,+135 qualified suffix).

This admits only the preregistered early native screen, frozen
**fdff0f361c60af149a2b81509548f987490fbf1d**, seed20261113. Native build pending;
no timing result. Full configuration,offline,native,cost and competitor gates
remain open. No changed public fixture, threshold, sample order or publication
authority. All previous rejections remain rejected.


## Four-cell screen rejected; actual native dispatch explains missing mechanism

Four-cell native seal **58da795dad73d181269ed59b5cca05c4bca80b51** verifies
816 files and all64 normal processes. Stream paired CPU.955163432
(95%[.909938804,.987780127]) fails.8; scroll1.020634540 passes1.05 point
but CI reaches1.0892. Mixed group2 candidate has one late>25ms gap,so its whole
ratio is suppressed. Idle0. No full-cost admission or adoption.

Native path diagnostic **6d63fbf47c2751825ea9623aa5ff7918b801becb** verifies
260 files and8 corrected instrumented processes,1,082 preparations. Every
paint-bank count is0 and actual banked packet tagfalse: the four-cell shader
path was never selected. Corrected full-packet counts:2,779,389 mask references,
2,587,037 lowered (93.079%). All mask placements have unit axes/dimensions.
These are planned references,not repair-cropped work or cache/hardware counters.
Initial classifier3d06af57 mislabeled untextured solids; all8 original processes
are retained,mask-reference totals rejected. Corrected09bd0c1f adds nonzero
packed dimensions. Both corrected frozen images match uninstrumented output.
No performance claim from logging.

The architectural coupling is between paint-bank representation and traversal
choice. New **local/mask-tiles**, preregistered
**5d37f245e0cda910bb9a554f836964284f06fdbc**, production
**d63782dd4c528860c21c6cc45caa177adce2cd08**, isolates this choice: bit30
of an existing tile range marks only nonuniform literal tiles containing a
surviving lowered-mask reference. It selects ordered draw evaluation with bounded
mask fetch reuse. Other literal tiles retain sample-major traversal; uniform
tilebit31 retains priority; existing tile-proofs disable clears new selection.
No new records,pipeline,retained state,API,dependency or unsafe. Added CSR search
and shader register/code-generation costs remain charged.

Qualification,wrong-row mutant and an actual-native selected-path audit must
precede the64-process20% admission screen(seed20261115). A pass still requires
complete configurations,offline/native/cost(seed20261116),ZGX and hardware
gates. Generic draw-majord35d2335 and pixel-uniform173e7c1a remain rejected.
This is a private scheduling choice over compiled operations,not evidence of
a BBTree async executor or higher cache-hit rate in GPUI.


Mask-tiles early GPU admission is sealed
**6d4d44a31de30c418167a97cf977e5634d453a8f**:729 files,64 canonical ELF
identities,353 tests,strict Clippy,336 exact public reference frames and the
wrong-Y mutantfb4bb250's actual proof-toggle test failure. Its1,836 differing
bytes are retained; the disabled-proof bytes independently equal the original
oracle. A first stderr-only witness parser failure is preserved; corrected
parser reads the same captured stdout too,with no test retry. Shipping38181
lines (+18 four-cell,+153 suffix),WGSL22041 bytes.

Actual-native audit **68682a99b03e0f33bf0c7fc438a067a8cea78953** independently
verifies130 files and all8 normal processes. All1,082 literal packets now select
marked mask tiles; all lowered planned references lie in selected tiles.
916,140 cumulative tile selections,exact initial0/190 native images and the
unchanged shader/workload. These instrumented counts establish path selection,
not speed or hardware cache behavior.

The uninstrumented native screen is frozen at
**f21f5dab4247fc98860a10a655ba625a4790a681**,seed20261115. Matched build is
complete; workload tests/preflights/timing remain pending. Both independent
admission receipts are mandatory before observations. Prior failures retain
their verdicts; no full-cost/ZGX/hardware admission or victory yet.


Mask-tiles native screen sealed **f0da94c8f4847a22c2db96c5038d79d8fc23662a**:
827 independently verified files,64 normal processes,34 workload tests and10
preflights. Stream CPU ratio .923431477 (95%[.843563731,.951912205]) misses .8.
Scroll/mixed comparisons are suppressed because baseline cadence gates failed;
all candidate work gates pass. No retry or full-cost admission.

New mask-miss preregistration **662707d79f3b3da28dacfc452090ff0c5f6c52a1**,
production **b817779c5609a038edd8f7d22f46863416c9e17e**, reuses one original
source sample only when the existing exact lowered-mask certificate proves all
16 samples miss the mask domain. Every original blend and reduction remains.
No signed-zero no-op assumption, new API, storage, dependency or unsafe.
Early GPU seal **e97729cbb03e71890f4f8efb97ce1920594284ca** independently
verifies727 files,64 ELF identities,353 tests,Clippy and336 exact frames. An
over-broad miss certificate6afe48dd fails the ordinary proof-toggle fixture,
3718 differing bytes against independently equal fallback/oracle/candidate.
Shipping38207 lines (+26 parent,+179 suffix); generated WGSL22857 bytes.
First-packet support audit70b75c8c is building; no native performance result.

The BBTree transfer remains explicit: reduce repeated work within bounded,
independent operation lanes while charging lane state and compilation costs.
It does not justify changing Solid/Ripple dependency authority or task wakeups,
and neither planned mask reuse nor software rendering establishes cache hits.


Mask-miss native selection audit **2520aeece9359124d0d8f4d450b04f03f5685d55**
verifies189 files,17 workload tests,8 normal corrected processes and1082 selected
literal packets. Initial0:262087/296960 lowered pixel references miss; initial190:
600100/683264. Only first submissions enumerated; planned complete packets,
not damage-cropped GPU work. Exact images0/190 and unchanged shader/workload.
The initial diagnostic failed window activation after the private display lost
its window manager; retained one SIGTERM process and guards. Restored owned
openbox and separately froze a complete diagnostic cohort, without shader or
gate changes. Native screen423a0cd0 is building in its own uninstrumented target.

Research implications, not new experiments/adoptions: BBTree's documented
level-by-level scheduler shares decisions across homogeneous lanes and exceeds
its generic coroutine scheduler. The new support counts also make spatial
bin granularity a concrete question:16x16 bins send most glyph references to
pixels outside that glyph. Smaller or subdivided bins might reject these before
shader traversal, but charge more CSR entries, tile words, upload and CPU repair
work. No bin-size change or performance claim has been made. A future proposal
must fix its representation and selection rule before observations, preserve
all exact images and test flat/dense/cold/mutation cases as complete alternatives.

Solid's pinned fetch-high/block-low article still distinguishes starting work
from the reads/boundaries that delay visible publication. Ripple track-async.js
at fed1244 checks request versions in both fulfillment and rejection, propagates
pending dependencies and retires boundary requests separately. These mechanisms
preserve meaning when scheduling moves work; they do not turn a pending I/O task
into BBTree's immediately repollable memory-yield lane. Re-read source supports
the existing scheduling constraints, not a newly measured asynchronous win.


Mask-miss screen **c8a65525e8798fd522eb91ef19ff4bd0e4e2ba9a** independently
verifies828 files,64 normal processes,10 preflights,34 workload tests and all
work/cadence gates. Ratios:scroll .961561475 (95%[.938169310,1.011688005]);
stream .896043156 ([.873979826,.954716972]);mixed .915155878
([.892158435,.941034601]);idle0/0. Stream/mixed miss .8:rejected,no full-cost
admission. Matched native ELF22530144 versusbaseline22523464.

New mask-grid preregistration **1c225400e838a761e43a4c33607c0292247d82e7**,
production **02d46fee9533d1b8c8b551337d3ccec5b84c0a0b**, tests8x8 bins only
for mask scenes with unpruned fine references within the existing4Mi cap.
Other scenes use16x16. Existing mode bit16 communicates selection,private
bin/count/visit/coverage functions receive the edge; no new buffers/headers/API.
Fine planning adds a bounds pass and potentially4x tile words/cursors; cost
must include these. Resource limits and full pixel sample arithmetic remain.
New budget/partial-bin/alternating-replay tests; existing public mask fixture
unchanged. Fresh GPU gate is running. No performance or adoption claim.


Fine-grid early admission **dbc8777eb0f70a6c3fbcc543b95ad2a364a20aba** verifies
1073 files,64 executable identities,356 tests,Clippy and336 exact reference
frames. Initial02d46fee failed typed WGSL validation (signed inferred edge versus
unsigned coordinate); corrected39efefe5 uses explicitu32 and fresh GPU rebuild.
Mutantd992ae45 ignores fine addressing: internal test/replay/proof comparisons
pass but independent oracle rejects all336 frames. The harness's erroneous
expectedexit101 failure is retained; external rejection supplies the witness.
Shipping38262 lines (+55 parent,+234 suffix),WGSL22953 bytes. Actual-native
instrumented audit7cc9497c is building; uninstrumented screene117ad4b is frozen
with seed20261119,not started. No full qualification/performance/adoption claim.


Fine-grid native audit **74144bfcca964141654cf6641dda2f1ffa14f53b** verifies
141 files,17 workload tests,8 normal processes and1082 literal8x8 preparations.
Both native images exact; first-packet draw/mask/unit-axis/dimension counts
match16x16parent2520aeec. Planned sample work initial0:10307584/18989056
(.542817084),initial190:15196160/27451392 (.553566100). Reference counts increase:
10066 and14840 respectively. This is planned complete-packet work, not timing,
repair-cropped loads or cache counters. Native screene117ad4b is now building;
unchanged20% targets and all resource/complete-cost/hardware gates remain.


Fine-grid screen **0d48eb1dacc4768a29fb3eaf531f4b75c6c7196b** verifies828 files,
64 normal processes,10 preflights,34 workload tests and all work/cadence gates.
Ratios:scroll .875697727 (95%[.847234207,.927114238]);stream .865797657
([.800268375,.920098988]);mixed .870368870 ([.742981928,.943701227]);idle0/0.
Stream/mixed fail .8. Planned-work reduction did not establish the target end-to-
end improvement. No full-cost admission; no retuning this grid experiment.

New sample-partitions preregistration **f9c3f300e7c3052d6b574b49d3df4b154320a30d**,
production **ddf9f4b6c6adf625b2b839c9d4ffe52c4a01574c**, starts from16x16
mask-missb817. Two cut bitsets encode rectangular groups of samples that have
executed identical source-over operations. Each new source unions cuts; new
representatives inherit their old color before any blend. No merging based on
float equality, averaging or skipped zero arithmetic. Masks use exact cells
only with full clip proof; lowered solids use exact axis membership; unknown
cases split fully. Final16 anchor/delta operations remain in original order.
16vec4 storage remains, extra masks/control/code-generation costs charged.
This tests BBTree's shared homogeneous-stage decisions in a compiled operation
kernel, not an async runtime. Existing publication/task authority is untouched.
GPU suite plus new public96-frame refinement/fallback/replay adversary is starting.
Existing336 independent reference images remain unchanged. No performance claim.


Sample-partitions positive checkpoint **a4204460d9288ccd5c222bc69c87ef6b29084117**
verifies707 files,63 ELF identities,354 tests,Clippy,336 independent exact images
and the new96-frame scalar-literal-oracle refinement/replay adversary. Shipping
38283 lines (+76 mask-miss,+255 suffix),WGSL25602 bytes. Negative control remains
pending; this is not native/performance admission. Completed main build caches
were reclaimed only after this independent checkpoint, preserving all canonical
ELFs and generated shader bytes to maintain8GiB reserve. Horizontal-cut mutant
is building separately. Dynamic representative indexing and extra control may
change LLVM/GPU register spilling; no claim that fewer logical blends guarantee
faster execution.


Sample-partitions early admission **a0086d6dd1ae8cd4e4869e88851885b03c73989b**
verifies734 files,64 canonicalELF identities,354 tests,Clippy and336 independent
exact frames plus96-frame scalar-oracle adversary. Horizontal-cut mutant
**7bcd9c311a093776cc7b588a2e49e211be01a1f1** fails publicproof-toggle:
3855 bytes differ,first432 expected76actual88. Disabled-proof bytes independently
equal originaloracle and candidate. All host/workload bytes matchb817; inherited
selection audit2520aeec is reverified without relabeling its old shader/counts
as new execution counters. Uninstrumented native **0b60a96399b381c6fda0a4706b05e08f85dd9396**
is building,seed20261121. No timing/full-cost/adoption claim.


## Representation redirection from the user

Sample-partitions native rejection is sealed at ceed2bd852d576a0b2aec08a728e8f0c92075a06:
828 files,64 normal processes,10 exact preflights,34 workload tests; scroll
.877526746 passes1.05,stream .882167801 fails.8,mixed suppressed for baseline
work/cadence failure. No full-cost admission. The shader sequence stops here.

The user's clarified objective is an integrated contiguous/addressable display
tree, directly addressed subtree damage/update storage, bounded random-access
lossless compression, and CPU/GPU publication/consumption. **It does not exist
in the current implementation.** Compact nodes, parent columns, source patches
and retained pixels do not establish it. BBTree terminology on shader work did
not satisfy this architecture. Future changes remain local; the separately
authorized snapshot publication does not authorize further pushes.

Next isolated experiment: local/display-spans, based on qualified suffix core
df8ca59f. Compare packed preorder spans with stable paged handles, explicit
compression/index costs, structural relocation, dependency closure, old/new
damage and stale-frame/resource authority. Fixed-size publication descriptors
are separated from payload copies, CPU scans, GPU decoding and rendering.
Executable models are research, not a completed integration or a ZGX victory.


First representation pair sealed **36f700a7345e7a561c66de498f840437ad4f0d3c**
on local/display-spans. Verifier checks1054 files,172 exact Vulkan pixel/word
frames,132 codec cases and4 actual GPU mutants. Public source/structural trace
uses unchanged APIs, fresh full View oracle,9->10->9 nodes and stale authority.
Packed1024-node front insertion moves49056 logical bytes/uploads15248; stable
slots move0/upload1416. Cross-group move uploads1336 packed versus1488 paged.
These are structural counts, not timings. CPU full scans/mirrors remain; tiny
compressed tree loses904 vs432 raw bytes; append-only version memory grows.
The full-snapshot adapter, staged GPU writes and serialized completion are not
the requested integrated architecture. Resource payload lifetimes remain open.

Next isolated hypothesis local/display-chunks retains this first-pair baseline:
ordered compressed chunks, stable identity directory, incremental dirty-page
journal, raw tiny fallback and fenced reclamation. Charge total metadata,
description, damage, indices, scratch, fragmentation and in-flight versions.
Direct ordinary Source paint must avoid full-snapshot extraction; subtree start
lookup and extent enumeration are separate. Overlapping GPU submissions and
real text/image payload leases precede any resource-completeness claim.
Historical469.5x is CPU recording versus old GPUI, not ZGX; older native workspace
mixed CPU remains6.06x ZGX. New representations have no competitor timing claim.
All new work stays local.


Incremental chunk checkpoint **57ccf254851e12839da4b5deedd5c7047b686c80** on
local/display-chunks separately seals Stage A2834 deterministic checks and
B1/C1:16 public paint edits,51 exact actual GPU byte readbacks,3 overlapping
submitted roots, and a267-byte real glyph/image resource-lease mutant failure.
A visible1024-node point edit uses1 identity lookup/32 decoded rows/564 encoded
bytes/2 damage records.97-node movement enumerates194 records and examines2231
index entries. Raw tiny fallback reduces the actual overlap heap6144->4096B.
Upload-log and completion-history leaks were found and fixed; original cohorts
remain. This is a restricted offline binding plus a byte-lifetime audit, not a
renderer consuming the new chunk tree or generic production journal integration.
Flat publication/resource table rebuilding remains linear; no timing claim.

Next local/display-radix at /home/user/gpui-display-radix-lab preregisters
**f1e9d54bf8906f0aa169bd2769cdc0d74272a922**: bounded COW directory plus one
combined public edit-to-final-pixels trace, scene-size sweep, all metadata and
in-flight costs, clipped/overlapping content, stale/deferred publication, real
resource leases and uncompressed serial controls. It must report an explicit
implemented/restricted/missing matrix. Staging is not coherent shared memory.
