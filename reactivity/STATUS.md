# Implementation and evidence

The clean-room workspace runs real applications through one exclusively owned
runtime. Start at [the GPUI crate](crates/gpui/README.md). The design documents
describe the intended complete system; this page records what is connected now.

| Boundary | Integrated behavior | Remaining limit |
| --- | --- | --- |
| Ownership and sources | Borrowed View, inline Signal, typed owner-relative sources/actions, contained component projections and declared Source/earlier-Reader input families | One serial root owner; complete dependency/cohort graph remains |
| Public testing | Application::demo, borrowed semantic queries/visits and streaming serialization, conjunctive name/description filters, actions, shared native pointer/focus/keyboard input, typed worker delivery, source JSON and explicit scene/pixel diagnostics | Virtual time, replay, touch/capture/drag and hover callbacks remain |
| Accessibility | Native AccessKit in ordinary desktop profiles, exact acknowledged transitions, controlled checkbox role/state/actions, source-qualified selection and atomic range edits, retired provider authority on text rebind; actual Linux AT-SPI client execution | Topology/missed/capped transitions use full projection; IME, relationships, virtual-item realization and UIA/VoiceOver runtime coverage remain |
| Identity | Window-qualified, never-reused 16-byte target stamps; logical membership checks; keyed realized-row identity; no target allocation table or visited-key history | Cross-window list transfer and unrealized-row accessibility realization remain |
| Worker delivery | Static typed inbox/question chains, frozen batches, versioned input-family admission, one physical completion credit, borrowed cooperative cancellation, native wakes and exclusive cleanup | Reader lookup scans earlier lanes; cross-turn results remain progressive; dynamic graph and demand parking remain; queue capacity is not a byte bound |
| Collections | Borrowed keyed uniform lists and ordinary two-axis scroll panes, f64 rebased offsets, viewport-only virtual rows, shared wheel/reveal/accessibility routing | Explicit uniform-height finite virtual viewports; rotated/sheared scroll apertures and variable-height virtual rows remain |
| Properties and inspector | Typed selectors and closed reflection catalog share validated Set/Inherit transactions; all 13 properties and eight value families feed retained native inspector controls; contained components select mounted targets, edit and refresh canonical state through ordinary typed click methods; edit counts join description changes by exact identity | Arbitrary built-in entry, descendant picking for contained tools, complete theme cascade and user-defined component schemas remain |
| Layout and text | Cephal perf/cold-layout with direct lazy cache handles, selective nonparent containing blocks and allocation-free hidden markers; literal/direct-Signal dimensions and flex recipes; Parley/Engine/Fontique 0.12 with scoped paragraph reuse; source-qualified grapheme editing, native selection/caret paint and horizontal visual navigation; acknowledged wrapped/bidi text geometry | General Reader/Motion recipe algebra, IME/clipboard/vertical navigation/autoscroll, arbitrary font discovery and hostile-font transient budgets remain |
| Canvas | Canonical grouped display list, rounded solid/image shapes, linear-light 4×4 sampling, exact per-pixel sample promotion, separable rectangle/glyph addresses, tile proofs, optional CPU image, exact scene-support damage, certified software-buffer repair, lazy bounds-only CSR membership reused across contained repairs and disjoint parallel bands | Multiple damage islands, persistent GPU repair and complete effect/path/media library remain |
| Images | Borrowed immutable resources, packed RGBA8/P3 or explicit linear HDR, linear-light filtering, CPU/WGSL rendering and native accessible Image roles | Caller decoding/I/O, direct source fanout, mipmaps and native HDR negotiation remain |
| GPU | Vendored WGPU/Core/HAL 30, typed wgsl-rs generation/validation and optional guarded static SPIR-V recipes with scoped Vulkan module lifetime; shared device/pipeline context and independent renderer states; grouped packets, tile proofs, lazy R8 atlas, boundary corrections, SDR/HDR targets, replay and transactional color patches | Native shared-device multiwindow remains; coalesced token gaps can rebuild packets; replay/patch draws the full target; native HDR negotiation, legacy DX11, other primitives and hardware/backend conformance remain |
| Native | Vendor-owned backend hints and target proof; Winit software-first windows, no Auto GPU initialization for certified fills, background GPU preparation for general scenes, checked handoff/recovery, early X11 target admission, surface-lease-safe close/drop, DPI and suspend/recreate | Metal/Wayland retain late attachment; unknown destination state and Wire use full uploads; Windows Auto stays software; shared-device multiwindow and guest/webview composition remain |
| Blank X11 | Exact zero-command certificate uses server fill; no retained client pixel backing; normal-buffer→solid releases backing after server completion | Server/compositor storage remains; other platforms use ordinary software buffers |
| Applications | Counter, Todo, Oklch/transform gallery, composed Workspace and synthetic 250K Library; real Hummingbird SQLite/Nucleo Library and queue port with shared native/headless View, typed workers, duplicate occurrence identity and revocable playback plans | Hummingbird audio/scanner/full navigation/artwork/media services and the complete Zed port remain; synthetic scaling is separate from real domain evidence |

Mutable model/window state uses ordinary exclusive Rust borrows. The production
window engine contains no Rc, RefCell or Cell. Native observation callbacks use
FnMut, allowing plain captured state. Immutable text uses one-word ArcStr leases
between source and presented epochs; fonts, masks and in-flight backend resources have
explicit immutable resource leases. Some test-only read/drop counters still use
interior mutability; dependencies and OS callbacks have their own contracts.

Queries and tests read the acknowledged semantic sheet. A borrowed Part shares
target, parent, role, name/value, supported actions and canonical geometry;
semantic execution revalidates current owner authority. Explicit names and
descriptions occupy sparse cold columns; ordinary nodes carry no annotation
pointer. Candidate metadata and list positions become queryable only with their
acknowledged P. Semantic-only changes can publish at the same scene token without
painting, while an unresolved visual edit keeps the preceding coherent metadata.
Focus and normalized
pointer/keyboard operations use the production dispatcher, including stale-sheet and
owner-quarantine rules. [Native accessibility](crates/gpui/ACCESSIBILITY.md) shares
these identities, focus, geometry and action authority. It adds no GPUI-side
AccessKit tree mirror or historical ID map; the native adapter retains its own
required tree. Stock Linux adapter construction starts background work even
before activation, so lazy conversion is not a zero-cost native AT claim.

On the current 64-bit build, Node is 40 B, an actual text-site entry is 80 B,
Presented is 64 B and a frozen list-viewport entry is 40 B. Author Color is 16 B and
Style is 88 B. Resolved styles use an owner-owned default/dense/shared lane with
bounded exact discovery and an unrestricted dense fallback; its header adds 40 B
per owner. Unicode TextLayout is 56 B, eight bytes larger than its predecessor.
These are exact retained layouts, not whole-window memory figures; layout/font/scene
storage and native services remain separately owned.
The [presentation-basis producer](evidence/presented-basis/final/README.md)
measures that 80→64 B row change at alignment 8. General bases reuse existing
geometry epoch streams; ordinary diagonal rows need no pool. Tiny general-only
owners add 408 requested retained bytes and dense general siblings add 344;
query Context adds 16 borrowed bytes. These costs accompany the common large
cohort savings. Row stride does not imply cache-line-aligned allocation.

Designer colors now expose `OutputProfile::max_chroma` and `Color::fit_chroma`
through one Fearless SIMD/Fallback kernel. They preserve Oklch author/alpha bits
for in-gamut colors and find a conservative neutral-connected unit-cube boundary;
RGB/HDR authors are not implicitly tone-mapped or clipped. This is not CSS
local-MINDE mapping, a correctly rounded root operation, or a complete designer
palette/mix/contrast API. [Numerical and allocation evidence](evidence/designer-gamut/README.md)
and [lattice/adaptive controls](evidence/gamut-search-controls/README.md) retain
precision limits, source/stack costs and the unadopted alternatives.

## Current verification

Core shipping source `8c17a763ee` integrates the rapid-focus pointer correction
and Hummingbird queue/controller, including the smaller playback occurrence
stamp. The [combined main qualification](evidence/pointer-queue-main/README.md)
passes 667 GPUI/GPU cases and docs (30 ignored), 33 default and 33 native
Hummingbird cases, strict all-target checks and scoped formatting. All 2,104
tracked input guards match. Both unchanged external Registry/input clients pass
on the frozen ordinary app under CPU and GPU policies; two additional captures
force Vulkan, for six native executions in total. Owned displays stop. These are
behavioral checks on a software-driver host, not timing, RSS, native HDR or
foreign-OS runtime results. Producer foreign library checks remain separately
pinned; SQLite SDK failures are not foreign-app success.

The later [Hummingbird occurrence correction](evidence/hummingbird-occurrence/README.md)
preserves an in-flight EOS across lookahead edits without a restart flag or new
owner field. Two old-source controls fail actual EOS acceptance; the corrected
application passes 35 default and 35 native-feature cases, strict checks and its
headless executable. Core source remains identical to `8c17a763ee`; this does not
rerun or broaden the separate native-window campaign.

Its predecessor `89aeabd539` integrates the
[flat sibling index](evidence/sibling-reconciliation/README.md) and
[lazy Core indirect validation](evidence/lazy-indirect/README.md). Their exact
producer archives retain allocation, code and lifecycle controls. The
[combined main qualification](evidence/structural-main/README.md) passes 656
GPUI/GPU tests and doctests across 61 result groups, with 30 ignored, strict
all-target checks and formatting. All 2,033 source/configuration/port guards and
the frozen executable hash hold. Native Window and foreign-OS qualification
remain pinned to their separate producer campaigns. The earlier `06b15c1835` adds an
[outlined property activation](evidence/property-successor/ADOPTION.md). Its
32 public merged-source cases, strict all-target checks and formatting pass;
exact producer `49707a4a4a` retains its native and Apple/MSVC qualification.
The broader set of native Window/lifecycle/inspector scenarios remains frozen at
`c717df64a9`, which combines cached-edge caret lowering,
compact presentation rows, contained property actions, their exact count fix and
[public selection/state replies](docs/property-state-routes.md). The
[four-way text controls](benchmarks/caret-pair-controls/cached-edge/README.md)
qualify their isolated pins: final versus original medians are about 40% lower
for long Latin shaping, 17% for RTL and 23% for mixed text, with identical heap
rows and explicit small-cohort results. Direct/packed geometry oracles and an
identical 83-case public transcript pass. Main's unchanged Canvas inputs also
pass 193 cases/docs, four ignored, strict checks and formatting at `538191fa01`.
These are text measurements, not native latency or RSS results.

The [basis archive](evidence/presented-basis/final/README.md) and
[contained-editor archive](benchmarks/contained-owner/README.md) retain their
exact producer default/native/strict/cross and actual AT/Apply qualifications.
Independent merged-source review then found a public `Commit.changed_nodes`
undercount for property actions with no-op replies. The combined main campaign
was interrupted rather than certified. The
[identity-union correction](evidence/property-change-union/README.md) is now
integrated; all 11 public regression cases also pass on main `1d5bc3061c`.
The full 524-case producer result retains its earlier source pin. The later
[combined main campaign](evidence/property-selection-main/README.md) now passes
651 GPUI/GPU cases and doctests (29 ignored), including 46 actual Vulkan readbacks,
strict checks, formatting and Apple/MSVC desktop compilation. Hummingbird's nine
tests, five external catalog cases, shared headless transcript and actual GPU
transcript pass. Native Registry geometry/edit/lifecycle, contained property
pointer/server-pixel editing, checkbox events, exact Future wake and blank handoff
also pass. The independent unchanged public editor passes actual Registry
selection, EditableText, Apply, Inherit and Refresh with acknowledged extents.
All 2,029 source guards, executable hashes and owned-process cleanup checks hold.
Vulkan uses llvmpipe; these are functional checks, not latency/RSS measurements.

The [selection producer](evidence/property-selection/final/README.md) charges its
80-byte snapshot and private 40-byte borrowed phase, with no retained header
change. Its matched optimized ordinary caller gains 208 bytes of frame and
864 bytes of linked text. The integrated outline then reduces that caller frame
from 3,816 to 3,416 bytes, with 96 additional linked text bytes and an opt-in call;
allocation rows are unchanged. Canonical
value and exact stored contribution can differ on the inspector shell, so a
compact representation cannot silently conflate them. Current core source is
[30,599 non-test code lines](evidence/core-lines/README.md), including build scripts;
this does not establish full feature parity or forecast final size.

The unmerged [monotonic caret control](evidence/monotonic-caret-stream/control16/README.md)
passes bitwise geometry, admission and unchanged public-transcript gates. It
saves 655,296 transient requested bytes on the 32 KiB owner, with unchanged
retention, but loses 10–29% on warm long-text timing medians. Main keeps its
cached index. The later [borrowed stream](evidence/monotonic-caret-stream/final-borrowed/README.md)
also remains unadopted: its exact public transcript passes and transient owner
requests fall, but RTL cold/warm medians regress 4.10%/3.06% in the one capture.
The [transaction frontier](docs/text-transaction-frontier-luna.md) selects a
separate partial visitor inside unpublished Canvas planning, keeping the public
atomic visitor contract. Its source, admission and error-precedence proof still
require complete owner/codegen/performance qualification.
The [route census](docs/route-density-census-luna.md) and
[thin-handle feasibility experiment](evidence/thin-route-feasibility/README.md)
likewise remain evidence, not adopted unsafe storage. The
[safe route-column proposal](docs/route-storage-frontier-luna.md) has measured
[rejected AoS/SoA controls](crates/gpui/evidence/route-columns/rejected-controls.md).
The later [packed topology control](crates/gpui/evidence/route-columns/packed-rejected-controls.md)
restores direct activation but still loses no-route description and resize in
all nine pairs. The [split-word successor](crates/gpui/evidence/route-columns/split-rejected-controls.md)
keeps raw parent words and passes actual 100,000-route dispatch. Its single
180-observation capture still loses no-route description by 9.50% in all nine
pairs and several activation cohorts. None is merged; all captures and complete
owner costs are retained.
The [Hummingbird producer](evidence/hummingbird-queue/README.md) retains its
original queue/navigation and native bug evidence. The integrated correction
keeps Session and optional Session at 32 bytes. Its separate inspector successor
requires matching hits on P and its own pending C; it remains unadopted pending
codegen and broader qualification. Audio output/full player and foreign-app
compilation remain outstanding.

The [portable GPU zero-source audit](docs/gpu-zero-floor-luna.md) identifies
Core's eager 512 KiB zero source and separate 256 KiB DX12/GLES sources. These are
descriptor sizes, with no new RSS or timing result. A reviewed primary-source
record corrects an inaccessible Dawn citation. The next isolated Core spike
defers the unused default external-texture parameters buffer/upload; zero-source
ordering and initialization-tracker recovery remain separate proof obligations.

The [combined compact-text/static-shader campaign](evidence/compact-static-main/README.md)
pins source `ebfdb2ad45`: 782 GPUI/Canvas/GPU cases and doctests (31 ignored),
strict all-target checks, formatting, nine Hummingbird cases, five external
catalog cases, headless and actual native CPU/GPU/Auto transcripts, plus actual
Registry Unicode geometry/edit/lifecycle, Future wake and cold-blank handoff pass.
GPU is llvmpipe and Auto stays CPU. Exact source/executable guards and owned
process cleanup pass; this is no hardware, timing, RSS or foreign-OS runtime claim.
The full-feature 32 KiB first-C owner changes from 33,912 to 383 allocations and
2,262,492 to 1,091,784 retained requested bytes. Old-P/new-C adds 482,136 bytes;
plain remains 21 allocations/5,588 retained bytes and warm idle allocates zero.
The selected 12-byte map's separate query controls charge +3.1% long local and
+4.8% whole-selection time against trimmed 24-byte records; the 8-byte alternative
is unadopted. These are measured complete-owner results and qualified tradeoffs.

The later [combined checkbox/surface campaign](evidence/checkbox-config-main/README.md)
pins source `f490974fdc`: 542 GPUI cases/docs (28 ignored), strict all-target
checks, formatting, Apple/Windows desktop/parallel/optional-shader compilation,
nine Hummingbird and five external catalog cases pass. Actual native GPU,
Registry Unicode geometry/edit/lifecycle, checkbox role/action/state events,
Future wake and cold blank-to-GPU handoff pass. All 2,014 source guards,
executable digests and owned-process cleanup checks hold.
[Surface owner removal](evidence/surface-config-owner/README.md) measures
GpuSurface 1,072→1,008 bytes at its separate 64-bit producer pin, with no RSS
claim. [Checkbox identity/focus and sparse/full payload evidence](evidence/typed-checkbox/README.md)
retains its own producer pins. Later transform and contained-editor integrations
retain their separate source qualifications above.

The [combined text/Future/native campaign](evidence/text-main-integration/README.md)
pins main source `007f10ccbd`: 529 GPUI cases/docs (27 ignored), strict checks,
formatting, nine Hummingbird cases, five external catalog cases and the shared
headless transcript pass. Actual AT-SPI geometry/edit/reactivation and late
service/owner replacement pass, as do native Future wakes and cold blank-to-GPU
handoff. Hummingbird passes real X11/AT-SPI through CPU, GPU and Auto using the
same copied executable. GPU uses llvmpipe; Auto stays CPU on this host. All
source/artifact guards and owned-process cleanup checks pass.

The [acknowledged text geometry baseline](benchmarks/acknowledged-text-geometry/README.md)
is integrated from `86dd586142`: 506 GPUI cases/docs, 188 Canvas cases, core
cases, strict checks, Apple/Windows compilation and actual AT-SPI geometry,
selection/edit and provider lifecycle checks pass at that pin. Public Part and
native adapters borrow the same eligible C/acknowledged P map; obsolete glyph
and font buffers stay out of historical geometry. Source ranges and affinity
own lines even with overlapping caret tops. Ordinary headers stay unchanged
except Runtime, which shrinks 64 B. The full-feature plain owner is 5,588 B;
the inspector grows to 82,694 B. A 32 KiB paragraph retains about 1.62 MB of map
capacity and adds about 1.65 MB per old epoch; construction costs and the indexed
Part bounds checks are explicitly charged. The later compact/query work is now
integrated through the combined source below; these baseline numbers and producer
tests retain their original source pins.

The [combined Hummingbird renderer checks](ports/hummingbird/evidence/renderer-policies/README.md)
pin source `c73144892c`: the shared executable passes its headless transcript and
actual X11/AT-SPI CPU, GPU and Auto transcripts. Each native run presents eight
acknowledged frames. Explicit GPU uses llvmpipe; Auto remains software under this
host's ordinary admission rules. Nine application tests, 17 public Future tests,
five external catalog cases, strict application Clippy and the borrowed-search
driver's locked compilation pass. These checks include the integrated Future
adapter and Vulkan stage ownership repair without retagging earlier campaigns.

The [typed Future adapter](evidence/future-adapter/README.md) is integrated from
source `a951113912`: 516 public/library/doc cases, 12 headless reader cases,
nine current-source Loom mailbox cases, exact native Future and ordinary-credit
wakes, strict all-target checks and Apple/Windows compilation pass at that pin.
Whole-chain close cancels tasks before response/queue/capture destructors run.
Ordinary Controller/Completion/lane layouts and allocation controls are unchanged;
the adapter adds 254 first-party shipping code lines plus a new normal dependency
edge to the already locked pin-project-lite 0.2.17. Transient typed close storage
and executor-owned storage are charged in the evidence. Streams and optimistic
commit/rollback remain separate work. Consumer lock corrections and independent
main changes are recorded without retagging the producer gates.

The [Vulkan stage ownership repair](evidence/vulkan-stage-ownership/README.md)
qualifies isolated source `52701c8cc7`: 44 real Vulkan pixel cases, eight GPU
units, four presentation cases, scoped lifetime/error/unwind regression, strict
all-target checks and Apple/Windows GPU compilation pass. Stage-local modules
now clean up on every construction exit; reusable Raw modules keep their owner.
The modified vendor file loses 36 non-test code lines and the local stage type
shrinks 80→72 bytes. Six first-party libraries remain byte-identical to the
preceding source. This is no new startup/RSS or hardware measurement.

The later [blank Auto refinement](evidence/auto-blank-cold/README.md) pins
source `8158386886`: certified command-free opaque SDR fills never attempt GPU
initialization, including blank resize/resume; first complex CPU pixels precede
normal delayed handoff. Seven actual native cases, 173 GPUI unit cases (23
ignored), strict all-target Clippy and Apple/Windows desktop compilation pass.
It adds two shipping code lines and no owner fields. This is work elimination,
not a new hardware startup/RSS measurement. The full combined campaign remains
qualified separately below.

The latest [combined core/catalog/graphics checks](evidence/core-catalog-integration/README.md)
pin library source `6d77c71c12`: 43 core, 493 GPUI (25 ignored), 182 Canvas
(four ignored), 57 GPU including 44 Vulkan pixel cases, five external component
library/catalog cases and nine native-feature Hummingbird cases pass. Strict
GPUI/core/GPU/Canvas all-target Clippy, formatting, Apple AArch64 and Windows MSVC
desktop/parallel all-target compilation pass. Six explicit native cases include
the expanded inspector, target leases, Todo, provider lifecycle, real registry
Unicode text/actions and no-session-bus presentation. The shared Hummingbird
executable passes its headless SQL and actual X11/AT-SPI transcripts.

At source `6d77`, the full native-feature plain headless owner retains 5,652 requested Rust bytes
in 21 allocations. The owner with its 28-node inspector panel retains 64,878 in 250; its active-tool
increment is 59,226 bytes including text/font/layout/paint resources, and 100 warm
idle operations allocate nothing. Runtime 1904 is that source’s full-feature profile;
its default was 1888. [Lazy-image controls](evidence/headless-image-lazy/README.md)
separately prove removal of the eager 1,792,000-byte image allocation. Neither
ledger measures RSS or native blank-window memory. The shared GPU context also
retains a 1,924-byte Rust layout lease if a context is dropped before its states;
[its evidence](evidence/gpu-layout-identity/README.md) charges this tradeoff.

Earlier source-qualified campaigns follow; their counts overlap the current one.
The preceding [combined native text/layout/presentation checks](evidence/native-text-integration/README.md)
pin library source `8ea8b9d76a`: 43 core cases with layout verification,
489 GPUI cases/docs (25 ignored), strict GPUI/core/GPU all-target Clippy,
five actual native protocol scripts and Apple/Windows desktop all-target
compilation pass. The preceding [text/graphics integration](evidence/stack-integration/README.md)
passes 177 Canvas cases (four ignored), 49 GPU cases including real Vulkan pixels,
and strict GPUI Clippy. Counts overlap; neither compile checks nor llvmpipe prove
native foreign-platform execution or hardware performance. Source-qualified
producer reports retain their own controls and measured losses.

The [real Hummingbird port](ports/hummingbird/README.md) is integrated, including
its [original native transcript](ports/hummingbird/evidence/README.md). The combined
campaign above also executes the later borrowed-SQL-row implementation: nine
native-feature tests and the shared headless/native executable transcripts pass.
The external native driver reacquires text authority after an edit; its stale-ID
failure is preserved. Full original framework parity is
still missing; the [feature audit](docs/feature-parity.md) is a delivery map,
not a narrowed 1.0 target. Shared GPU resources, typed catalog controls and
designer gamut operations are integrated. Optional offline shader artifacts and
static recipes, compact acknowledged geometry, consuming line breaking and
intrinsic interaction-map suppression are integrated through the later combined
source above. Each producer archive retains its own qualification pin.

The [source ledger](evidence/core-lines/README.md) counts 30,007 non-test library
code lines at `f490974fdc`, including 18 build-script lines, versus original
GPUI's 56,922 including 28 build-script lines. These are pinned actual counts,
not a current-feature-equivalence or predicted final-size claim. Dependencies,
local vendor patches, tools, app ports and fixtures retain their separate scopes.

The [combined core/paint checks](evidence/core-paint-integration/README.md)
pin implementation `de18f040c9`: **622 workspace cases/doctests**, 130 accessible
native unit cases, 138 parallel Canvas cases/docs, eight GPU units, 37 actual
Vulkan readbacks and a GPU borrow compile-fail doc pass. All eleven gates pass,
including strict accessible X11/Wayland/parallel/Vulkan all-target Clippy,
formatting, exact headers, and actual X11 reactive-style and five-policy Todo
scripts with independent complete server/GPU pixel oracles. Strict desktop
all-target Clippy also passes for Apple aarch64 and Windows MSVC through the
actual adapters. These counts overlap other campaigns; cross-compilation and
llvmpipe/Xvfb do not establish native OS runtime or hardware performance.

The earlier [combined style checks](evidence/reactive-style-ports/integration/checks.json)
preserve the direct-style checkpoint and actual ordinary-scroll oracle at
`b1fc101435`. Subsequent literal-builder controls found substantial codegen and
mount-time regressions despite the corrected 12-byte Flex size. Main
`859274504e` now resolves literal assignment before source erasure using the
same typed property schema. Its integrated checks pass 626 workspace cases/docs,
strict accessible Linux and Apple/Windows desktop cross checks, and the actual
X11 complete-image style oracle. The [frozen 582b controls](evidence/literal-dispatch/README.md)
show fields/recipe builders about 80% faster than their matched modern baseline
with identical allocation totals; the candidate remains
114.6%/72.5% slower than the historical primitive fields/recipe controls. Direct caller bodies grow and element
copies remain. The measured 582b classifier has since been simplified to a
private boolean; its capture is not retagged as an integrated-source timing.

Registered direct signals bind dimensions, colors, transforms, radius and flex
fields through the existing typed source registry. One source freeze admits all
sinks before mutation, and inspector masks preserve an advancing lower base.
The [compact recipe](evidence/reactive-style-ports/compact-flex/README.md)
keeps literal Flex at its measured 12-byte baseline; four borrowed signal
operands occupy 40 bytes without recipe allocation. Ordinary owner/node/style
headers and the plain owner allocation floor are unchanged. The initial
104-byte recipe and its correction remain recorded. This is the direct Signal
surface; it does not implement the full proposed reactive expression algebra.

The [pointer protocol checks](evidence/pointer-protocol/checks.json) pin
`c6db932473` (integrated as `3bbacbe3b1`). Nine public pointer cases plus the focus
and presentation suites pass 27 cases. Native units, actual X11 Todo/scroll,
strict Linux Clippy and actual Apple/Windows desktop cross-checks pass. The
32-byte caller-owned session replaces the native host's existing fields;
Runtime/Node/Presented and the same-feature NativeHost size do not grow.

The [paint coupling](evidence/paint-coupling/README.md) connects registered
background/foreground sources to canonical Canvas edits and native GPU patches.
Same-alpha changes skip View, layout, shaping and the paint walk. They preserve
acknowledged geometry and exact pending observer authority, including no-op
updates and late accessibility activation. The path still updates k destinations
and may rebuild a GPU packet across coalesced-token gaps. A first paint-only
owner pays the complete Metadata/PaintState/field/sink/edit storage; the report
charges those costs and GPU map ownership explicitly. GPU patches reuse admitted
bins/resources but draw the complete target.

The [CPU cache controls](benchmarks/bin-miss/README.md) separately replace full
material reconstruction with ordered integer bounds and reuse any containing
membership cache. Distant-repair median is 42.561→2.740 µs in the pinned five-way
software microbenchmark. The rejected first candidate's +104.6% miss regression
is retained. Canvas is now 488 B instead of 552 B; its first CPU raster allocates
an 80 B scratch owner, so active header storage grows 16 B. Recording-only
canvases allocate no scratch. Full-color raster loses 2.05% versus the first-lazy
control while remaining 8.32% below the parent. The renderer pool still performs
its separate full-command scheduling estimate; cached membership is not zero
raster work or a whole-window memory/startup result.

The [public paint substrate](evidence/paint-patch/README.md) remains the checked
borrowed-guard interface. Ordinary GPU Renderer is 872 B; native PaintRenderer
adds a 24 B map header and 12 B per reserved site. GpuSurface is 1080 B and
NativeHost is 688 B with both X11/Wayland (680 B with X11 alone).

The [combined graphics/scroll checks](evidence/graphics-scroll-integration/checks.json)
pin implementation `f01947e679`: **568 workspace cases/doctests**, 115 accessible
native unit cases, 123 parallel Canvas cases/doctests, seven GPU unit cases and
33 actual Vulkan readbacks pass. Strict accessible X11/Wayland/parallel/Vulkan
all-target Clippy, formatting and native header checks pass, along with actual
X11 Todo and ordinary-scroll pixel oracles. Strict desktop Clippy passes for
the actual Apple aarch64 and Windows MSVC adapters. Counts overlap; cross-checks
do not establish native OS execution, and llvmpipe/Xvfb do not establish hardware
performance or scanout latency.

Ordinary scroll panes retain offscreen controls for reveal/accessibility;
virtual rows leaving the admitted cohort retire their targets and focus.
Rounded solid/image paint and own-shape hit testing share the radius property;
descendant clipping stays rectangular. CPU-valid radii outside the admitted GPU
precision class use the existing CPU fallback. Scroll adds no hot node/runtime
field but charges 104 retained bytes to the first virtual-list cohort; rounded
geometry adds eight bytes only to existing Metadata owners. Detailed cold costs
and numerical limitations remain in the isolated evidence.

The [complete image integration report](evidence/images-integration/checks.json)
records **22 successful gates** at source `724ece73cb`. Its
[source/log hashes](evidence/images-integration/checks-source.json) preserve the
exact checkout and separate desktop cross-checks.

- Debug and release workspace suites: **479 passing cases/doctests each**;
  strict workspace/native Clippy and first-party formatting pass.
- Parallel Canvas: **113 cases**. Optimized Loom: **6 protocol, 3 historical
  credit and 9 production-mailbox cases**; proof limits remain in [TESTING](TESTING.md).
- Actual Vulkan: **23 readback cases**, including packed images, linear HDR/P3,
  mixed resource offsets, Unicode, transforms and all author color layouts.
- Actual X11 scripts: Todo across renderer policies, worker delivery, Reader
  credit retirement, the 250K Library, Unicode and clickable images. They check
  acknowledged input, resize/suspend/recovery and complete server pixels.
- Actual AccessKit Consumer: **20 cases**. The Linux AT-SPI client and presentation
  without a session bus also execute successfully. Native scripts overlap the
  accessible unit suites; these counts are not added into a new total.

Strict all-target Clippy also passes for the actual aarch64 macOS and x86-64
Windows MSVC desktop adapters. Those are cross-compilation results. AppKit,
VoiceOver, UIA, Windows and Wayland execution still need their native runners.
Vulkan runs on Mesa 26.1.4 llvmpipe/LLVM 21.1.8, proving software-backend execution,
not discrete-GPU performance. The X11 solid-window script confirms zero client
SHM mappings for certified solid frames and a 2,097,152-byte mapping for its
normal 800×600 buffer; server/compositor storage remains separate.

The [integrated image-axis follow-up](evidence/image-axis-integration/checks.json)
at `71ce05bb92` passes 116 parallel Canvas cases/doctests, all 23 Vulkan
readbacks, the real X11 image/pointer/resize/recovery script, and strict native
all-target Clippy. These scoped checks supplement the complete campaign above.

The [combined input-family checks](evidence/question-inputs/integration/checks.json)
at `e10c2226d5` pass 499 workspace cases/doctests, strict accessible native
all-target Clippy, and the real X11 Question dependency chain and 250K Library
scripts. Their isolated transport evidence also includes 3 credit and 9
exact-source mailbox Loom cases; those models do not prove the sequential
input-family settlement logic.

The [combined presentation checks](evidence/presentation-integration/checks.json)
pin source `dcdadf4d52` and record **17 successful gates**: 500 workspace
cases/doctests, 108 accessible native unit cases and 29 actual Vulkan readbacks;
strict native Clippy and formatting; seven actual X11 application/destination
scripts; no-SHM Wire fallback, AT-SPI activation/actions/reactivation and
presentation without a session bus. Strict all-target desktop Clippy passes for
the actual Apple aarch64 and Windows MSVC adapters. These counts overlap the
earlier campaigns; the desktop checks are cross-compilation, and Vulkan uses
llvmpipe. This is correctness evidence, not hardware timing or memory evidence.

The [flex integration checks](evidence/flex-integration/checks.json) at source
`f2c33080ef` pass **510 workspace cases/doctests**. The isolated GPUI suite
passes 291, including ten public flex tests and Todo's shared application model.
Strict native Clippy, formatting, exact header checks and the actual X11 Todo
script across renderer policies pass. Apple aarch64 and Windows MSVC desktop
all-target Clippy also passes; those checks remain cross-compilation only.
The three new style fields fit existing padding: Style remains 88 B, El 176 B,
Node 40 B, Presented 80 B and Runtime 2,384 B on the measured 64-bit build.
This earlier gate covers literal layout. Direct signal ports and compact typed
recipes are connected by the later style campaign above.

The [semantic streaming checks](evidence/semantic-stream/checks.json) at source
`c894ff7c41` pass **298 default GPUI cases/doctests**, strict accessible native
all-target Clippy, formatting and the actual unchanged layout ledger. Six public
cases cover pending/failed candidates, logical removal, virtual realization,
writer failure, quarantine/close and 32 allocation-free sink writes. `semantics()`
borrows the same `Part` getters as `visit`, with live focus and frozen acknowledged
node data. It adds no retained tree or runtime field. This is diagnostic semantic
serialization; source persistence, platform adapter projections and replay remain
separate. No latency or resident-memory saving is claimed.

Earlier source-pinned reports remain intact: the
[21-gate baseline](evidence/checks.json) at `5b0a38b222`,
[cached-cmap checks](evidence/cmap-integration-checks.json) at `76f5be8493` and
[callback-destructor regression](evidence/snapshot-retirement-checks.json)
at `f8f318fb8a`. A callback panic can interrupt destructive reconciliation; old
presented content/geometry stays inspectable while every target is revoked.
The Node24 and P56 storage prototypes remain isolated because of their measured
mount/traversal regressions.
The [ordered identity index](crates/gpui/evidence/identity-order/README.md) and
[bounded dense index](crates/gpui/evidence/identity-order-dense/README.md) also
remain isolated: their allocation/lookup savings did not justify application
regressions. The production owner retains its 2,384-byte header and BTree lookup.
The [counted style palette](benchmarks/research/counted-style-palette/phase-results.md)
also remains isolated. It sharply reduces first sparse-edit allocations, but
whole-cohort lane changes take 62–113% longer at 4K/65K slots and about 3.8×
the parent time at 60/139 slots. A separate batch transform is under evaluation.

## Measurements and their boundaries

| Change | Evidence | Limit |
| --- | --- | --- |
| Immutable packed images | [Image evidence](crates/gpui/evidence/images.md): 48 covers share one 65,536-byte source; stable GPU pixel uploads and warm raster allocations are zero | Image-free owner adds 16 requested B and no allocations; per-scene 64 MiB cap does not cap overlapping cohorts/process memory |
| Exact image-axis taps | [Guarded CPU controls](crates/canvas/evidence/image-axis-outlined/README.md): one-image preparation+raster 46.50→6.27 ms; 48 shared covers 70.12→22.78 ms | Image-only transient taps/cache; flat no-image control loses 5.08%, tiny control 1.70%; sheared control is noisy. No native/GPU latency claim |
| Preserved software repair | [Damage evidence](crates/gpui/RETAINED_DAMAGE.md): moving caret over 1,001 stable commands reduces median prepare+raster 21.64 ms→206.7 µs; no warm repair raster allocations | Excludes native upload/event delivery/scanout. One conservative rectangle, O(commands) comparison, no GPU repair or competitor claim |
| Observed X11 destination | [Protocol and pixel evidence](docs/native-destination-invalidation.md): partial scene change uploads 4,356 image bytes versus 94,208 for the full fixture; unchanged native host layouts | SHM path only; exposure/unknown destination requires full repair and Wire keeps full uploads. Image bytes are not total protocol traffic, latency or RSS |
| GPU packet replay | [Replay evidence](crates/gpu/README.md): same admitted scene skips CPU validation, binning, scene uploads and binding creation; fresh targets still receive a complete draw | Renderer grows 48 B and native GpuSurface 64 B, plus one opaque backend bind group; no GPU timing or pixel-preservation claim |
| Exact sample promotion | [Sample storage](crates/canvas/SAMPLE_STORAGE.md): moving-caret fixture full raster 21.53→6.06 ms; 48-label SDR preparation+raster 16.90→13.87 ms | Adds 4 KiB+32 B initialized worker scratch; no retained reduction; native upload/latency excluded |
| Exact output reuse | [General controls](crates/canvas/SAMPLE_STORAGE.md): the one-pixel cache further lowers 48-label HDR preparation+raster 17.30→14.64 ms and sheared translucent boxes 2.78→1.94 ms | SDR flat serial panels lose 1.65–1.77%; small stack-only cache, no retained reduction or native latency claim |
| Exact glyph addresses | [500-row controls](crates/canvas/evidence/glyph-axis/README.md): 48-label SDR preparation+raster 13.80→5.73 ms, HDR 14.70→6.68 ms | Adds 1,032 B transient address tables per worker; several non-text serial controls lose 2–3%; excludes native upload and predates Unicode integration |
| Current-owner style sharing | [Style evidence](crates/gpui/evidence/retained-styles.md): Node 128→40 B; repeated whole owners save about 16% requested retained bytes | Adds 40 B owner header; unique payload neutral; two-style coarse descriptions lose about 10%, first inspector densification 10–20% |
| One Unicode layout | [Text evidence](crates/canvas/TEXT.md): 1000-label owner mount 14.79→12.85 ms, requested peak 2.11→1.93 MB | Retains 8,304 B more, prepare loses 4.6%, empty native PSS adds 194 KiB; Linux text-only cut, no native IME/selection claim |
| Borrowed coverage descriptors | [Cached-cmap evidence](crates/canvas/evidence/cached-cmap.md): reused 1000-label pass 8.93→8.50 ms, owner edit 12.21→11.62 ms | Adds 104 B scoped planner storage, unchanged retained layout and allocation counts; single-label edit loses about 1%; no native latency claim |
| Lazy fonts and scoped shaping | [Startup](crates/gpui/STARTUP.md): Gallery median 80.038→40.525 ms on default-reset Xvfb; 23.302 ms with -noreset | Display reset is an environmental cost; warm filesystem, fresh processes, present acknowledgement rather than scanout |
| CPU-first blank | [Memory CSV](crates/gpui/evidence-native-memory-auto-swash.csv): roughly 8.5 MiB PSS, one idle thread, no GPU probe on this device-less Linux host | Predates representation/solid changes; driver/compositor bytes are separate |
| Canonical retained runs | [Canvas](crates/canvas/README.md): 32K-glyph grouped fixture retained heap 4,456,500→1,269,876 B; peak 6,689,076→1,795,060 B | Unique-mask heap is neutral; Canvas header grows 208 B; flat traversal can lose |
| Grouped GPU packets | [GPU](crates/gpu/README.md): 32K fixture record bytes 3,072,096→1,104,096; explicit GPU buffer capacity 4,198,484→2,101,332 B | Frame time is neutral/slightly slower; fixture retains records hidden by a final opaque fill |
| Tile certificates | [GPU results](crates/gpu/tile-benchmark.csv): 32 opaque overlaps 182.17→1.18 ms on llvmpipe | Boundary-heavy case 23.44→26.12 ms loses; not a hardware-GPU comparison |
| Blank solid transport | [Mapping results](crates/gpui/evidence-native-solid.csv): normal buffer retains 2 MiB mapping; initial/returned solid retains zero | Client transport only, not whole application/server/compositor memory |
| Static delivery cleanup | [Borrow-guard evidence](crates/gpui/evidence/remote-guard.md): channel/staging 4→3 allocations and binding 1→0; headless Remote 24→16 B, Inbox 64→56 B | End-to-end timing is neutral; attached OS/wake allocations are not claimed zero |
| Keyed viewport | [List evidence](crates/gpui/VIRTUAL_LIST.md): 27 retained semantic nodes and 59,979 requested framework bytes at 100 through 250K identifiers; mount median 375–495 µs | Warm code/allocator, fresh owner caches, fixed-text fixture, no native submission; app IDs and reverse index are separate |
| Packed identities and geometry | [Sheet packing](crates/gpui/evidence/sheet-packing.md): bounded parent index and finite affine sentinel reduce Node 232→224 B and P 104→88 B; FieldId's checked nonzero encoding subsequently shrinks its option to 8 B | Exact admitted-domain representation; no coordinate quantization or new unsafe |
| Dense text storage | [Text-lane evidence](crates/gpui/evidence/text-lane.md): Node 216→136 B, plus 80 B per actual text site; 4,097-node sparse fixture saves 307,256 requested retained B | Adds one Vec header and one nonempty lane allocation; dense text headers are neutral; measured timing losses are retained |
| Native semantic projection | [Projection evidence](crates/gpui/ACCESSIBILITY.md): exactly reserved 10K-button output removes about 0.87 MB retained and 1.62 MB peak requested B versus geometric growth | Extra read pass; excludes adapter-owned tree, D-Bus and OS providers; changed P still projects the full tree |
| Thin text leases | [Paired evidence](crates/gpui/evidence/thin-text.md): P 88→80 B and text-site 80→72 B; 100K no-text fixture saves 800,000 requested retained B | Each unique nonempty payload requests 1–8 B more; no-text preparation loses about 10% and sparse edits about 6%; rejected flag packing did not fix it |
| Lossless author colors | [Color proof and measurements](crates/canvas/COLOR_PACKING.md): Color 20→16 B, Style 96→88 B, Node 136→128 B, preserving all admitted HDR/author bits | Some conversion/mount/raster phases lose; native first acknowledgement is flat and native RSS/PSS increased in the paired capture; Canvas working colors already occupied 16 B |
| Measurement routing | [Paired evidence](crates/gpui/evidence/layout-route.md): 10,001-node repeated-color mount removes 913 scratch allocations and 262,472 peak requested bytes | Retained storage is unchanged; individual trace phases lose and dense text searches are not a universal speedup |
| Sparse native semantics | [Transition evidence](crates/gpui/SPARSE_ACCESSIBILITY.md): 100K leaf projection+Consumer replacement about 77.7 ms→73.6 µs, peak about 34.8 MB→328 B; verified field hints remove the common P scan | Warm repeated replacement, not screen-reader latency; active 10K geometry preparation pays about 14.3% comparison tax; inactive observation skips it |
| Typed questions | [Input-family ledger](evidence/question-inputs/README.md): first declared u64 question requests 2 allocations/120 B headless, plan 384→328 B, Completion 72→40 B; ordinary owners gain no fields | Source coalescing loses 0.59% in paired controls; projection description pays two boxes/88 B; Library worker reserves 256 KiB stack; earlier-tail scans and progressive cross-turn results remain |
| Cooperative Library work | [Cancellation evidence](docs/question-cancellation.md): obsolete worker retirement/latest dispatch 8.434 ms→29.611 µs, stopping after 128 of 250K tracks | Current remaining scan loses 0.94%; source edit, first 128 tracks, latest execution and presentation excluded |

The measurement rows pin their own baselines. Dense text, thin leases, color
packing and row derivation were measured independently; their percentages are
not additive, and a combined native memory/performance improvement is not inferred.

The [16-cell direct-paint campaign](benchmarks/nanoui-mygo-gpui/paint-only/results/paint-only-5f4-peer-16cell-20261022/README.md)
pins GPUI `5f4db5f288`, JustRach NanoUI and MyGo, with 100 fresh starts, 1,000
clicks and five idle samples per cell. Within GPUI, registered direct color
updates versus matched full-description controls give p50 click-to-server-pixel
0.130 versus 0.151 ms at eager zero, 0.143 versus 1.994 ms at eager 1K,
0.274 versus 24.167 ms at eager 10K, and 0.135 versus 0.214 ms at virtual 250K.
Startup is effectively unchanged within each GPUI pair; eager 10K is about
182 ms. Its direct-path idle PSS is 50,826–50,992 KiB; there is no near-zero
native memory claim. The pinned observer uses the upper central sample for
even-n p50. Root independently verified raw counts, unique event IDs, quantiles,
memory extrema, executable hashes and exact paired GPUI preflight images.
Peer backend/font/styling/overscan and accessibility differences remain explicit;
these Xvfb software observations are not a universal ranking or scanout result.

The [audited native-default comparison](benchmarks/nanoui-mygo-gpui/native-default-724ece73/captures/native-default-20261021/README.md)
pins JustRach NanoUI, MyGo, and GPUI `724ece73cb`, with 100 fresh starts,
1,000 clicks and five idle samples per accepted cell. GPUI's three fixtures
measure 16.07–31.61 ms median spawn-to-X11-pixel and 0.197–1.944 ms median
click-to-changed-pixel on Xvfb. Geometry/pixel preflights and the rejected
NanoUI binary mismatch are preserved. This is a scoped software/X11 comparison,
not compositor/scanout timing or an all-application result.

The [separate 724/current native comparison](benchmarks/nanoui-mygo-gpui/native-paired-724-current/results/paired-724-current-dcdadf4-20261021/README.md)
uses the identical fixture and accepted pixel preflights at source `dcdadf4d52`.
Median click-to-changed-pixel is 194→147 µs for eager zero, 1.973→1.876 ms for
eager 1,000 and 263→209 µs for virtual 250K. Startup medians are respectively
16.09→16.16, 31.76→31.50 and 17.22→17.31 ms; idle PSS changes are below 0.3%
in five samples per cell. All six 100-start/1,000-click cells remain intact.
These sequential source blocks are descriptive, not per-event paired confidence
intervals. Auto selects ReferenceCpu and no AT client is active; this does not
measure GPU packet replay or update the earlier competitor campaign.

The [matched memory-floor diagnostic](docs/memory-floor-attribution-luna.md)
separates truly blank windows from zero-row text fixtures. The default blank
window measures 11,515 KiB median PSS in three samples. The optional-feature
contrast attributes roughly 3 MiB mostly file-backed PSS to the accessibility
bundle under this setup; disabling accessibility is not a product optimization.

The [ThinLTO floor diagnostic](evidence/empty-floor-lto/README.md) reduces the
matched executable file by 19.1%, while default/ThinLTO startup and resident-memory
ranges overlap. Its startup endpoint is a parent-observed presentation marker,
not the X11 pixel endpoint above. The first insufficiently guarded capture is
preserved and excluded; the corrected capture guards source/config and executable
identity. No release-profile change was adopted from this diagnostic.

Near-zero native memory, universal byte parity and an order-of-magnitude
feature-equivalent simplification have not been established.
Reports retain losing cases. The full Hummingbird source audit is
[pinned separately](docs/hummingbird-source-audit-luna.md). The keyed-list and
worker-delivery and image foundations are integrated; complete async admission,
media and richer input remain prerequisites for that port.
The [packed-dimension experiment](crates/gpui/evidence/dimensions.md) remains out
of production: its exact 8-byte node saving did not justify unresolved phase costs.

## Scope and line accounting

The primary size measure is **shipping first-party core library code**, excluding
comments, blank lines, tests, documentation examples, vendors, labs, application
examples, benchmarks, tools and evidence. Source `8350157374` contains **26,069**
code lines across Canvas/Core/GPUI/GPU/Host/State. The original GPUI crate at
`41a42eb96d` contains **56,894** under the same comment/test exclusion rules.
These are actual source counts, not forecasts or a feature-equivalence claim.
The original framework still provides substantial functionality missing here.

[The counter and pinned per-file ledgers](evidence/core-lines/README.md) combine
Syn test/module analysis with Tokei's source-code classification. Ambiguous macro
or cfg syntax remains charged and appears in diagnostics. Code is kept readable;
one physical line may contain several statements, so line count alone is not a
complexity or quality measure. No projected final count is used as an acceptance
gate. New capabilities must first be reviewed for a simpler shared formulation.

The older [physical-line ledger](evidence/line-counts.json) and the
[broad source inventory](evidence/source-inventory/) retain separate historical
accounting for comments, tests, experiments, tools and complete vendored sources.
They are not the core-code metric. Vendoring does not make dependency code vanish.

[Baseline](evidence/baseline.json) pins the original 260,010 physical Rust lines
and inspector/transforms/testing branch deltas. Legacy remains a plumbing and
behavior reference; nothing was deleted under a false feature-equivalence claim.
[Provenance](vendor/PROVENANCE.md) records Winit/Cephal; [presenter patches](vendor/PRESENTER_PATCHES.md)
documents the additional complete archives and bounded platform ownership fixes.

Topology/layout, template, exact-translation, coverage and ownership labs remain
independent correctness/comparison tools. Their measurements are not automatically
production results. [PLAN](PLAN.md), [REVIEW](REVIEW.md) and [EXPERIMENTS](EXPERIMENTS.md)
retain the admission and deletion gates.
