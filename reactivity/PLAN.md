# GPUI clean room reactivity implementation plan

The replacement starts in this independent workspace. Its unit of reuse is a
typed owner, a retained subtree or a leased surface; its unit of work is a changed
destination. It must preserve GPUI's text, input, accessibility, custom rendering
and embedding capabilities while substantially reducing first-party code and
retained memory. The existing GPUI checkout remains the behavioral reference
until representative applications pass the replacement's gates.

The selected representation is in [DESIGN.md](DESIGN.md); the versioned
statute amendments and observable rules are in [CONTRACT.md](CONTRACT.md).
[CONCURRENCY.md](CONCURRENCY.md), [GRAPHICS.md](GRAPHICS.md) and
[FORMULATIONS.md](FORMULATIONS.md) complete those contracts. This document is the
source audit and delivery plan; it does not select a competing mutable-tree runtime.

This plan assigns falsifiable experiments. It
does not claim that the experimental crates are a complete GUI, that vendoring
implements a layout adapter, or that any competitor has been beaten. See
[STATUS.md](STATUS.md) for what actually runs and
[the experiment register](EXPERIMENTS.md) for the remaining choices.

## Current integration priorities

The full original framework remains the replacement target. The
[feature audit](docs/feature-parity.md) records missing behavior, not permission
to reduce the 1.0 scope. The real [Hummingbird Library port](ports/hummingbird/README.md)
now tests SQLite queries, Nucleo matching, stable row actions and typed asynchronous
delivery through the same public View/Win/Window. Grow it into the full player,
then use Zed to exercise independently owned components, editors and multiwindow
services; a synthetic scale fixture cannot stand in for those application contracts.

Portable WGPU/HAL target admission, source-qualified native range editing and
selective nonparent containing blocks over Cephal `perf/cold-layout` are now
[integrated together](evidence/native-text-integration/README.md). Remaining
work includes early Metal/Wayland target proof, native HDR negotiation and
the complete editor/lifecycle contracts. Preserve software-first startup and
acknowledged semantic/scene authority. SIMD uses one
fearless_simd formulation and fallback, with assembly and measured controls.
The [combined source 6d77 checks](evidence/core-catalog-integration/README.md)
now cover immutable device/pipeline ownership with independent renderer states,
the shared typed property catalog and all 13 native inspector controls, and
SIMD-shaped fixed-lightness/hue gamut limits. Preserve the measured single-window
header/layout-lease costs alongside multiwindow savings. Native Application
multiwindow sharing still needs integration. Optional per-entry shader artifacts
and static recipes are now integrated behind vendor-owned admission, with exact
enabled guards, native lifetime/error proof and a checked WGSL fallback. The
[combined campaign](evidence/compact-static-main/README.md) exercises real native
applications and Vulkan readbacks; no hardware performance gate is inferred from
llvmpipe. Build-host/tool/static-word costs remain explicitly charged.

The [native shader lifecycle audit](docs/native-shader-lifecycle-luna.md) selects
static SPIR-V recipes with temporary Vulkan 1.0 modules under the existing stage
guard. The [integrated optional slice](evidence/static-shader/README.md) preserves reusable
Raw ownership, exact device admission, Core error scopes, active trace and
repeated/concurrent pipeline creation. Replay retains ordinary Raw ownership and
was source-audited rather than executed. Native lifetime/heap and the full
authored/vendor/binary bill remain qualified at the frozen producer source. Maintenance5 inline
stages require separate queried/enabled state and pointer-lifetime proof; the
first static recipe does not depend on that extension.

The [acknowledged geometry baseline](benchmarks/acknowledged-text-geometry/README.md)
now preserves exact old P/C maps for ordinary queries and native wrapped/bidi
runs, including late activation after failed newer shaping. Continue with
source-derived compact stops and inherited transform factorization before an
arena. The [selected 12-byte maps](benchmarks/acknowledged-text-geometry/map-controls/ADOPTION.md),
safe borrowed-index checks, consuming-break work cut and intrinsic interaction-map
suppression now have combined source qualification. Preserve the actual query
tradeoffs and losing 8-byte control, not just retained-memory savings. Charge all headers, old epochs, native arrays,
source/binary growth and tiny-label regressions; keep bit-exact producer width,
signed-zero alias geometry, legal graphemes, source-affinity line ownership and
provider retirement as invariant gates. Glyph/font payloads must remain outside
historical geometry.
The [compression audit](docs/text-map-compression-luna.md) prices source-domain
rank planes and exact repeated-line templates after a bitwise compact-stop
control. The [intrinsic measurement audit](docs/intrinsic-text-measure-luna.md)
selects a possible existing Parley scalar metric scan, guarded by explicit
Cephal axis/run-mode authority and unchanged glyph/error admission. Do not
replace height-bearing measurement or infer MaxContent/full-width equivalence.

Typed reflection must also support arbitrary inspector value entry and contained
component/tool owners without mirroring application membership or bypassing
source admission. Designer color still needs shared batch/palette operations,
explicit mix contracts and accessibility contrast, beyond the integrated gamut
primitive and tagged HDR storage.

The [Solid/Ripple review](docs/async-graph-luna.md) identifies streams and explicit
optimistic commit/rollback as remaining async ergonomics work. The integrated
[typed Future adapter](docs/future-questions.md) preserves frozen inputs, stale
admission and previous-value projections. Its injected exact-task cancellation
and pinned Future teardown preserve physical completion credit, with no task
state in ordinary controllers. Continue with actual application consumers before
adding a stream policy or optimistic overlay; neither follows automatically from
a terminal-answer Future. The [portable presenter review](docs/portable-presenter-luna.md)
and [color derivation](docs/color-formulation-luna.md) are proposals with explicit
source-review corrections, not implemented performance results.

## Input contracts and evidence

The supplied `designs/reactivity/final/00-model.md` and its eleven statutes supply
the vocabulary, subject to the explicit revision-2 amendments in CONTRACT.md.
Earlier passes and the existing data-structure lab are
decision history, not alternate APIs. Preserve `View::view(&self) -> El<'_>`,
`changed`, plain fields, `Signal`, `List`, scope-owned `Entity`, `Reader`,
`Handoff`, `Target`, typed ports, ordinary methods as routes, constructor children,
and progressive promotion. No `cx` or mandatory UI macro is introduced.

The source checkout is `41a42eb96d6c04e5e71f3577d12934d4de569b20` on
`sync/reviewed`. [baseline.json](evidence/baseline.json) records 260,010 physical
Rust lines in 409 tracked files, including tests, comments and blank lines;
122,958 are under `crates/gpui`. These are physical lines, not semantic SLOC.
The inspector, coordinate-space, testing, reflection and selector refs are pinned
there with merge-base deltas. The inspector ref is an older flattened layout and
its files live under `src/`; interpreting a missing `crates/gpui/src` path as a
missing feature would be wrong. Its available delta is 657 added Rust lines, not
the entire multi-feature inspector work the request describes. Transform work is
8,217 added and 1,007 removed Rust lines at the pinned ref. These branch totals
are evidence to inspect, not precise feature cost estimates.

Copy useful behavior fixtures from these branches, then rewrite the mechanism.
In particular, preserve transformed pointer/vector coordinates, exact ancestor
clips, deferred scene replay, old/new damage, semantic test queries, deterministic
input and render feedback. Keep source attribution when implementation is copied;
"clean room" here means a new architecture, not a legal independent-reimplementation
claim after reading the reference source.

Reference implementations are JustRach's NanoUI, egoist's MyGo, and Zortax's
zgui. [Core research](docs/research-core.md) pins them and distinguishes
README assertions from source behavior. NanoUI's relationship to MyGo makes them
partly related evidence, not three independent validations of one architecture.
[PanGui's layout rewrite](https://www.pangui.io/blog/05-layout-rework-and-benchmarks/)
reduced approximately 11,000 to 4,800 C# lines through axis sharing, integrated
blending and shared hypothetical/final computation. This is a subsystem example,
not a 4,800-line budget for a complete desktop framework.

## Correct the contracts before implementation

These corrections retain the design's intent while removing impossible Rust
promises. The original documents remain a decision record; compiled fixtures and
this explicit correction list must agree before public API stabilization.

| Design statement | Implementable contract |
| --- | --- |
| `DerefMut` publishes with a guard on drop | `DerefMut` returns `&mut T`. Mark mutation before returning the borrow; publish at the enclosing owner turn barrier. A separately named edit guard may publish on drop, but is not required for `*signal += 1`. |
| Arbitrary `Deref` reads record dependencies without context or instrumentation | The no-macro floor re-describes the owner. Direct wires and explicit source projections provide fine grain. Optional instrumentation may capture reads, but must fall back conservatively across opaque calls. No hidden TLS runtime. |
| A chunked or gap-buffered `List` always dereferences to `[T]` | Keep an actual contiguous `Vec<T>` initially. Chunk geometry/order indexes separately. Changing item storage requires an explicit iterator/chunk API or an explicitly priced compaction; never manufacture a slice over disjoint allocations. |
| `view(&self)` silently has a current generative frame arena | El owns description headers and borrows operands with ordinary lifetimes. Internal lowering alone is generative. A public arena fast path would require an explicit carrier/API; the compiled API oracle prices allocation instead of assuming an arena. |
| Covariant `El` alone prevents mixing live frames | A borrow lifetime prevents escape but does not encode arena identity. Brand arena cursors at the actual construction/consumption seam or use checked arena identity. Test nested simultaneous frames as well as escape. |
| Raw function address is the unique stable identity of a route | Typed method/receiver metadata establishes identity. Codegen can merge equal functions or duplicate one across units. Function-pointer equality is not a durable routing or serialization key. |
| A `Delta` derive can infer arbitrary aliases and generate lazy field access without storage | Proc macros cannot resolve Rust types. Classify through typed traits and generated projections, or explicit annotations for ambiguous boundaries. Ordinary struct fields are materialized; a lazy wrapper accessed through `Deref` needs a separate sound allocation/lifetime proof. Price it. |
| Every view state derives serde automatically | Persist sources through explicit serde bounds. Readers/producers must be reconstructible from their declared inputs. Preserve entity aliasing with a graph table, reject unsupported fields at compile time, and never serialize raw process-local IDs. |
| Every finite generational key is permanently unique | Include owner/arena identity at crossings and retire exhausted generations. Internal lane indexes omit the namespace only behind a validated phase borrow. |
| Four bytes of signal metadata means four bytes of allocation overhead for all `T` | Include alignment and side tables. `bool + u32` occupies eight bytes; `f64 + u32` usually sixteen. Report actual instantiated sizes and wired/unwired totals. |
| Tile/union damage is lossless retained-data compression | It conservatively expands geometric damage. Compression of immutable payload bytes can be lossless; quantized damage must separately report overdraw and never omit pixels. |

Interior mutability is another real boundary: a shared reference cannot prevent
application `Cell`, `Mutex` or I/O from changing the world. The core guarantees its
own phase capabilities. It cannot prove arbitrary application purity on stable
Rust. Tests, documented contracts and optional instrumentation cover that residual.

## One ownership model

Application state belongs to ordinary owner structs. A contained component uses
the parent's scheduling grain until its inputs support independent delivery.
`Entity<T>` names a scope-owned entry; copying a handle does not extend lifetime.
Cross-owner access is generation-checked and scoped. Sends enqueue owned verbs;
they do not run another owner while it is borrowed. No node owns its descendants
through recursive boxes, and no child holds an owning reference back to its parent.

Use three identity domains: process-local capabilities, durable domain identifiers,
and per-frame packet indexes. They are different types. Persisted domain keys are
remapped on restore. Cross-window List moves transfer a linear adoption token
inside one transaction; a bare `Slot<T>` must not authorize simultaneous ownership
in two lists. A failed transfer returns the value and identity to its original
owner. Types encode local invariants; namespace/generation checks handle dynamic
lookup and cross-runtime input.

No `Arc` belongs in each signal, node, property or child edge. Borrow on reads,
move ownership at phase boundaries, and use immutable shared payloads only when
more than one owner really retains them. Evaluate `triomphe::ThinArc` for
header-plus-slice packets, `UniqueArc` while building, and `ArcBorrow` where its
lifetime can remain scoped. Compare complete allocation size, clone/drop traffic,
codegen and dependency cost against a moved `Vec`, `Box<[T]>`, and `std::Arc`.
The initial request-admission experiment uses one shared owner revocation token;
it is explicitly not the per-signal representation.

## The retained tree and its lanes

Separate editable topology, owner identity, paint order, properties, geometry and
capabilities. Making one universal node store all six is the source of default
memory tax. The selected architecture shares immutable template topology and
stores instance identity, typed deviations, editable region runs and selected
layout/space references. The per-node mutable structures below are independent
oracles and dynamic-region competitors, not mandatory records for every instance.
A mutable oracle topology node needs generation, parent, sibling links and kind.
The current safe reference topology uses 28 bytes per allocated slot, with a
16-byte public ID containing arena identity. Internal links are 32-bit indexes;
they do not repeat full IDs. The stronger target is a small per-pass hot record
and side lanes, not a false claim that 28 bytes represents all rendering state.

The experimental `SpatialTree` adds a four-byte directory only to spatial users,
with dense geometry records only for declared geometry. A production version
must also evaluate paged sparse directories so a rare capability does not force a
full-window lane. Store payloads by kind: glyph run, box, image, surface, shader,
route, accessibility and optional debug metadata. An unchanged static subtree
uses a shared immutable recipe plus a small instance patch set. Paint order is a
separate chunked sequence over identities, so moving a subtree need not move all
of its state or rewrite every public key.

Compare intrusive links, 128/256/512-entry paint-order pages, an augmented B+ tree,
and dense vectors using identical mutation traces. Fenwick counts are attractive
for stable pages, but inserting a page into a flat counts vector still moves
entries and may rebuild the index. That global cost must be counted. Reparenting
checks ancestors, edits links once, then invalidates the actual dependent geometry
closure. A layout change can affect siblings or ancestors; it is not always a
leaf-only operation. Deep chains and wide roots are mandatory adversaries.

A transform is a shared coordinate-space record. Paint, hit tests, caret/IME,
accessibility bounds, drag vectors, scroll and inspection consume the same
committed geometry revision. Forward bounds are conservative; inverse point
mapping decides exact hits and clips. Noninvertible input spaces cannot receive
pointer events. Unrepresentable forward bounds force conservative damage rather
than silently disappearing. Store common identity/translation cases compactly;
derive inverse, raster density and clip normalization once per changed space.
Do not put six matrix floats on every primitive.

Build hit acceleration over eligible geometry, preserving paint/stack order.
The reference linear scanner is a correctness oracle, not the final hit path.
Avoid repeatedly walking the entire ancestor clip chain for every candidate:
shared clip scopes and an incremental broad phase must bound this work. Dense
and sparse updates choose different traversal modes by measured dirty density;
never discover an empty dirty set by scanning the whole tree.

## Description, ports and mutation

The public component language remains ordinary Rust. `El<'_>` is the concrete
branch currency, with owned headers and borrowed payloads. Literal properties
store constants. The `&Signal<T>` installation spelling must lower to a typed
owner-relative projector or stable source capability; it cannot retain that
temporary address. `map` installs a sealed
pure circuit; an explicit dynamic projection records a read set. The last form
pays for dependency discovery. A starred scalar expression in the plain path is
a snapshot and triggers owner-grained work when that owner runs; `format!` cannot
turn itself into a direct wire. Preserve this distinction in the examples.

Typed field descriptors bind an owner to a field without retaining its address:
monomorphic read/write projectors, value type, impact and permitted operations.
They are resolved against the currently borrowed owner. An optional data derive
can generate descriptors and recursive deltas; library-owned primitive schemas
generate fluent methods and reflection from the same declaration. Normal users
do not maintain field enums, catalogs, downcasts or wire tables. A manual typed
descriptor is the macro-free escape hatch, and must be ergonomic enough to test
without the derive.

Keep `Source`, `Sink`, `Cell`, `IntoProp` and child sequence families sealed where
they define core scheduling semantics. Let libraries compose components, typed
part capabilities, style recipes and handler policies through public ordinary
traits/functions. Sealing every extension point would defeat component libraries;
allowing arbitrary code to forge a core impact would defeat invalidation.

Each field has an exact `Impact` closure: style, layout, geometry/hit, accessibility,
paint or composite. Generate the phase matrix from the same property schema used
by setters and inspector edits. Destination equality is authoritative after
publication; hashes are only candidate filters. Do not call user effects inside
source propagation or compare functions. Dynamic dependency replacement removes
old edges and installs new edges in the same logical commit.

An unwired plain view pays no graph allocation. A wired source gets a lazy slot;
subscription edges use dense indexes and recyclable intrusive records, with
fanout caches only above an observed crossover. Dirty queues use slot/epoch
deduplication and touched ranges. Generation wrap requires a maintenance/retire
policy. A small revision alone neither discovers dependencies nor proves that a
consumer refers to the same incarnation of a field.

There is a missing carrier in the original sparse-publication proposal. An inline
four-byte stamp with no runtime reference cannot enqueue itself into a runtime's
dirty queue. The first implementable floor is an owner queue plus scanning that
owner's wired field descriptors after its handler: O(wired fields in changed
owners), with no clean-tree scan. A finer path must prove explicit update-token
instrumentation, generated mutation instrumentation, or a lifetime-safe shared
binding carrier and price its bytes. None may retain an unchecked pointer to a
movable field or introduce hidden TLS. Until that experiment passes, O(publications)
delivery from arbitrary `DerefMut` is an unfulfilled gate, not a construction fact.

## Turn and publication protocol

One host turn has these ordered stages:

1. Route keys/focus against the latest logical epoch; coordinate-dependent input
   waits while the presentation epoch is stale. Admit stamped work and
   queue commands. Dispatch one owner handler with exclusive access. Multiple
   events retain their specified read-your-writes behavior.
2. Commit the successful source operation, including admitted completion payloads;
   discover its publications and freeze required worker inputs. Settle pure
   circuits to Ready/Pending/Fault using declared iteration bounds. A derived
   failure does not reverse successful arbitrary source mutation.
3. Publish coherent logical outcomes for those source versions. Release all
   immutable description borrows before mutation/effects or scratch reset.
4. Build a presentation candidate: style, Cephal layout, bounded geometry demand,
   transforms/clips, hit/focus/accessibility, paint fragments and damage.
5. Validate and atomically publish one interaction/presentation epoch. Submit
   only immutable packet ranges and resource leases from that epoch.
6. Run `changed` and external effects after publication. Further writes form a
   new bounded wave with attributed causal edges; they cannot recurse into the
   current phase. Reclaim retired storage only after all leases release it.

Logical and presentation epochs are separate. A failed presentation can retain
the last coherent frame while logical input advances. Key routing observes the
new logical focus; pointer coordinates wait for coherent presentation recovery.
No event may use a half-new hit tree with old pixels. Retry against the latest
logical state. Bound old frames, packet rings,
resource versions and pending/recovery data by explicit bytes/epochs. The modality
matrix, Handoff durability, turn waves and exact commit points are in CONTRACT.md.

The existing `TwoEpoch` experiment proves owned-candidate publication behavior,
not rollback of arbitrary mutable handlers. Production source mutations commit
on normal return; panic poisons the owner. Typed atomic batches stage only their
supported operations. Cephal is private memo state; candidate failure discards
outputs and invalidates cache closure, or poisons/recreates the workspace. Old
presentation readers lease immutable answers. No inverse Cephal journal is
required. Inject faults at every boundary, including accepted-result retention.

`Handoff` is a bounded owned FIFO with explicit backpressure and turn-end
diagnostics. A full queue returns the payload. Consuming is acknowledgement;
serialization of in-flight occurrences is opt-in through source serde, not
callbacks. Exact async request stamps include owner/site/incarnation/request
identity; A-to-B-to-A is still a new request. Validate frozen input revisions and
policy at admission, not merely parameter equality. Cancellation is an efficiency
tool; rejection of stale completion is the correctness mechanism.
The primitive request gate consumes its ticket on `accept`; the runtime must
retain the owned accepted completion in the committed inbox. Consuming a ticket
and dropping its payload on a failed presentation would lose a valid result.

## Cephal layout and mathematical simplification

Use [Cephal perf/cold-layout `20c4c494`](vendor/PROVENANCE.md), whose package
version remains 0.1.1, without `taffy-compat`, through
`LayoutTree`, `CacheAccess` and `Incremental` over our topology. Its owning `Tree`
is a useful cold-layout oracle but is not a second production tree. Implement
style interning, measured content, caches, scheduler flags and layout outputs as
lanes. The adapter owns dirty reasons, removed-node cleanup, query generations,
speculative cache writes and rounding publication. Public APIs do not expose
Cephal node IDs or styles as permanent application identity.

On this x86-64 toolchain the pinned types measure `Style = 288`, `Layout = 92`,
`NodeCache = 464` bytes before heap spills. At 100k fully populated caches that
alone is 46.4 MB of payload. A convenience adapter that eagerly creates one
cache and style per node misses the memory goal. Evaluate lazy caches for
nontrivial nodes, interning common styles, one-entry caches with pooled spills,
and measured cache eviction. Preserve hypothetical/final answers and cache-key
correctness; memory reduction cannot discard required invalidation state.

Share algorithms across abstract axes and across measuring/final placement.
Use monotone constraints, interval bounds and exact dependency closures where
applicable; do not claim arbitrary CSS/geometry feedback is monotone. Scroll
extents, wrapping, percentage resolution, min/max-content and baseline dependencies
need explicit equations and a deterministic bound on feedback. A convergence
failure reports its dependency cycle and uses the specified stable fallback.

Run upstream Chrome fixtures from the full source repository, current GPUI's
Taffy fixtures, and randomized retained-versus-cold Cephal traces. Published crate
archives do not contain the full upstream test corpus. Test font/image measurement,
RTL, fractional scale, grid/absolute placement, hidden nodes, large coordinates,
reparent/removal, cache eviction and failed candidate/cache recovery. Retain a reference
Taffy comparison outside the shipping dependency graph until parity is proven.

## Damage, retained packets and motion

Track old and new visual support, including shadow/blur/filter inflation, clip,
opacity, backdrop dependencies and compositing order. An empty change submits
nothing. Exposure, resize, scale/format changes and device loss have explicit
full-invalidation paths. Persistent render targets require damage repair for
each target generation; swapchain images cannot be assumed to contain the last
frame. Use buffer-age history or redraw the required superset per acquired image.

Use an adaptive damage representation: a few exact rectangles first, tile words
when overlap grows, full-surface when bookkeeping plus expected overdraw loses.
The experiment currently uses conservative 64-pixel tiles and sparse word clear.
Lossless compression belongs on immutable tape/property pages: shared defaults,
equal-span deduplication with collision confirmation, dictionary indexes and
bit-packed flags. Try XOR/delta encoding or zstd only for cold snapshots/evicted
payloads when decode and working-set costs justify it. Keep mutation-hot geometry
directly readable. Compression must not make a clean tree require decompression.

Time-sampled motion lanes are grouped by property kind. They read a virtual or
host monotonic clock and write the same property ports as ordinary updates.
Transform/opacity tracks avoid layout; font/size tracks explicitly enter layout.
Interruption starts from the sampled value and velocity. Exit transitions lease
the required subtree/resource fragments with a bounded lifetime; they do not pin
the whole owner graph. Reduced-motion, paused/hidden surfaces, zero-duration and
spring termination have ordinary state-machine tests.

Renderer-neutral packets own resource references and offsets, never live frame
borrows. Select backend per packet/pass/range, not per primitive. Reuse a GPU
device, pipelines, text system and bounded atlas caches across windows where the
backend permits it. Cache keys include device generation, color space, scale and
shader/pipeline identity. Backpressure bounds submitted frames and uploads;
obsolete not-yet-submitted presentation packets may be replaced, reliable user
actions may not. Driver work is measured through completion, not just CPU enqueue.

## Embedding and first class inspection

A same-runtime GPUI subtree mounts normally and borrows the host's owner tree,
theme, text and device services. An independent GPUI runtime or wasm/process guest
uses a versioned surface protocol: owned input, viewport/scale, scene or texture
lease, damage, focus/IME, accessibility subtree, cursor, clipboard and lifecycle.
Do not recursively create a second native event loop or copy an entire display
tree merely to embed a component. The guest's version and resource leases keep
old callbacks and GPU work from touching a remounted surface.

Native child webviews have real stacking/transform limitations. An OS child
window often cannot interleave arbitrary transformed sibling draws. Negotiate
capabilities: native child rectangular overlay, offscreen texture composition,
or an explicit unsupported requirement. Texture composition may cost readback,
IPC, an additional buffer, or a webview process. Count that total. Include tab
navigation, pointer capture, popup ownership, IME coordinates and accessible-tree
merging in the contract; a `WebView` enum variant alone implements none of them.

The inspector is an adapter over committed production visitors, not a shadow
tree. Typed property descriptors give get/validate/set/reset, origin/precedence,
allowed behavior hooks, and exact phase impact. Reuse these for accessibility,
semantic tests, serialized snapshots and debugger edits. Preserve library-private
state through typed part capabilities; styles and behavior are overridable only
at declared extension seams. A string inspection protocol may select a descriptor
at a process/tool boundary, then must validate its type and revision.

Detailed traces and source locations live in optional cold storage. With tracing
disabled there are no trace allocations or extra history scans. Snapshot capture
walks the committed tree only on request and is byte/depth bounded; large captures
stream to a serializer. Persist application source data independently of derived
layout/scene/debug data. Unknown plugin records survive round trips verbatim;
resource handles, closures and process IDs never enter the durable format.

## Platform, memory and thread responsibilities

Vendor Winit and keep its lifecycle semantics behind `crates/host`. Components
and the kernel use portable commands/capabilities; platform and renderer adapters
can use a narrow raw native escape hatch. Redraw, resize-sensitive rendering,
resume/suspend and platform callbacks are handled synchronously where required.
Do not buffer `RedrawRequested` and render later outside a native callback.
Portable `Application::attach` is a capability negotiation, not an unconditional
promise that Winit can be pumped on iOS or web.

The baseline owns native events, application mutation, logical settling, layout,
interaction publication and GPU submission on the main thread. There is no pool
or render thread at the unwired floor. The design has explicit parallel phases:
independent decode/shaping/compute over frozen owned inputs; disjoint slab jobs
for wide geometry/animation batches; optional Cephal independent-child queries;
and an optional submission owner consuming immutable packets. The graph itself
does not become a fine-grained lock network. Preserve deterministic merge order
and stamped admission when work finishes in a different order.

Compare a single owner, scoped workers, a demand-started persistent pool, and a
dedicated packet submission thread. Tune grain from work estimates and observed
latency, with cancellation points and caps on scratch/queued bytes. A separate
presentation lane may consume immutable committed geometry and bounded patches;
it may not mutate application state from an input thread. Winit event ownership
and native rendering callbacks constrain which thread placements are legal.

SIMD is part of the lane format: contiguous same-kind values, predictable lengths
and bulk operations. Use one fearless_simd formulation whose fallback executes
the same logic; scalar calls are a small batch of that pipeline. Inspect LLVM's
vectorization of clear/dedup/compare/damage/animation loops and validate generated
assembly against matched production workloads. Avoid forcing gathers
over a pointer graph, and avoid enabling AVX globally for a distributable binary.
Measure frequency throttling, lane occupancy, instruction cache, branch misses,
tail cost and memory bandwidth. Unsafe must remove a measured cost and have a
smaller auditable contract than the safe alternative; exotic representation is
an experiment, not a requirement to introduce undefined behavior.

Budget four distinct memory ledgers: application live/committed allocations,
process mappings and RSS/PSS, CPU presentation buffers, and GPU/compositor memory.
Count thread stacks and reserved address space separately from resident pages.
Start with an empty runtime, then empty window, renderer/device, font/IME/a11y,
one control, large tree, multiple windows, guest surfaces, and teardown. Shared
device/code/font pages are attributed once and reported as shared, not hidden.

Apply the small-ELF literature to paging and linking measurements: demand-load
optional systems, map immutable templates read-only where sharing helps, remove
unused font/CSD/backend startup paths, and compare section GC, dynamic/static
linking, ThinLTO and codegen units. A tiny executable that only performs `exit`
does not establish a GUI's memory floor. Do not remove required libc/TLS/unwind/
sanitizer/platform initialization or invent unsafe overlapping mappings merely
to reproduce a byte count. OS/driver buffers are real costs even when absent
from the application allocator.

## Testing and serialization use the production path

`Application::demo` and `Win::demo` are host configurations of the real turn
engine. Each input and virtual-clock advance is a turn barrier. Tests query
typed `Target` capabilities and semantic role/text/focus/bounds visitors; no
parallel test application, hidden `settle`, arbitrary sleeps or callback mocking
is needed for ordinary component behavior. The low-level experiments already
test their production APIs; they do not yet provide this application surface.

Use deterministic input, worker ordering, clock and resource readiness. A failed
test exports source state through serde, input trace, clock, chosen scheduler
order, committed epochs and a bounded snapshot. Restore remints capabilities and
reconstructs derived state through the normal mount path. Round-trip shared
entities once with alias preservation, not once per handle. Handoff payloads,
unknown plugins, non-UTF8 paths where supported, floats/NaNs, secrets/redaction and
schema migration need explicit formats and tests; generic JSON alone is not
lossless for every Rust type or byte string.

Keep independent oracles: adjacency-list tree, cold layout, full dependency
recompute, scalar interpolation/transform, exact pixel-damage coverage and full
repaint. Random traces cover mount/edit/reorder/reparent/teardown, stale IDs,
dynamic read-set changes, spurious publications, callback reentrancy, A-to-B-to-A,
worker/device loss, hidden windows, IME and composed clipping. A full oracle is a
test/reference path, never the hidden normal cost. Shrink failing traces and save
seeds. Miri/sanitizers are required for new unsafe; when unavailable the unsafe
change remains unaccepted, not silently waived.

Compile-fail fixtures prove phase/owner borrows, no write through `&self`, no
internal frame cursor escape, no turn-scoped mutable owner across async work,
no mutation through readers, no wrong
typed target/field, no cross-brand geometry, and no unsound Send/Sync. Diagnostics
are reviewed as API. Library examples must actually compile; `rust,ignore` is
reserved for clearly marked design alternatives, not proof of a working surface.

## Delivery sequence and deletion gates

| Slice | Deliverable | Required exit evidence |
| --- | --- | --- |
| 0 | Pinned reference inventory, corrected contracts, tiny standalone workspace, scalar oracles | Reproducible tests and source/memory ledger; no legacy dependency in the core |
| 1 | Topology, spatial lane, exact transforms/clips, primitive state/admission, Winit boundary | Randomized/deep/ABA/overflow/idle tests; default memory measured; this is the current foundation scope |
| 2 | Shared-topology Cephal correctness adapter; template/typed-overlay representation lab | Cold/retained layout parity, removal/cache/rounding/fault injection; template equivalence and dense losses |
| 3 | Compiled owned `El` floor, typed schemas/operations, template instances, owner dispatch, target visitor | One real headless counter/settings screen; production turn barriers; API and lifetime corpus |
| 4 | Coherent immutable sheets, direct wires, explicit projections, List transfers, precision-tiered `changed` | Promotion preserves behavior; dynamic edge oracle; changed-owner scan priced; exact typed path; transfer failure atomicity |
| 5 | Retained fragments, hit index, damage repair, animation lanes, inspector editing | Full-paint equivalence, idle zero submit, geometry/hit/a11y epoch equality, interrupt/exit/resource tests |
| 6 | Native host + renderer/text service adoption, same-runtime embedding | First compositor-visible frame, Winit lifecycle/IME/a11y fixtures on supported platforms, device-loss recovery |
| 7 | Async cohorts, text editing/editor geometry, virtualization, history library | Existing design's async/Text/H gates; multiple viewport coherence; journal restore and undo protocol |
| 8 | Library overrides, native/webview/guest surface capabilities, media/shader/color tiers | Component-library replacement tests and negotiated native composition limits; import fences, bounded queues |
| 9 | Measured parallel/SIMD/cache/compression choices and representative product ports | End-to-end p50/p99, memory and work counters; two hardware classes; competitor ports and feature parity |
| 10 | Replace first-party usage and remove legacy systems | Zero remaining required legacy usage; documented compatibility window; deletion commits and no fallback-default path |

This is a dependency order, not an estimate that each row is a small PR. Borrow
the existing text/shader/native service implementations only after their boundary
is small enough to justify copying; do not drag `App`/`Window` contexts into the
new kernel. A compatibility surface is a bounded island, with its first-party
usage and retained bytes reported. It must not become the implementation of the
replacement. Remove old code only when the corresponding feature and platform
gate passes; the user's authorization to delete does not prove parity.

## Code and performance budgets

Use actual [shipping core counts](evidence/core-lines/README.md), excluding
comments, blanks and tests and charging library build scripts. Do not predict a
final size. If an abstraction starts growing per-property/per-platform mirrors,
review its formulation before extending it. Readable shared code and representative
application usage establish simplicity; shorter syntax alone does not.
Text/shaping/layout/windowing/render dependencies, vendored code, generated code,
tests, examples and all feature crates must also be reported in the total.
An order-of-magnitude claim requires equivalent scope and explicit counting;
moving 100k lines into a dependency is not a 100k-line simplification.

Every integration includes a public-API adversarial review, type/size review,
causal work counters, full-oracle comparison where relevant, and a meaningful
commit message recording the invariant, discarded alternatives, measured scope
and remaining limits. Review the final combined types before cherry-picking a
worktree. Re-run the affected gates after integration, not only inside spikes.

No hard frame-time claim is accepted from this machine's microbenchmarks.
Compare equal features, renderer/backend, workload, frame bounds, cache state,
font/scale and measured intervals. Include cold construction/first frame,
steady input-to-present distribution, CPU+GPU work, upload bytes and idle power.
Beating a competitor requires correctness and feature parity, lower p50 and p99
outside noise on at least two hardware classes, and no hidden memory/compile-time
regression. Until then the result is an experiment with published counters.
