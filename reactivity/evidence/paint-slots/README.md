# Source paint slots and exact CPU space columns

This is a reviewable implementation milestone, not a recommendation to adopt the
whole representation yet. The source update and GPU upload now operate on one
owned source slot rather than every destination. Allocation and linked-code
controls also expose remaining construction and property-read costs. There is
no timed performance capture in this package.

Production source is `be3809f750` plus `d7fcdf62ca`, based on
`de18f040c98dbfc32d33bd1e51515bbf11bce53b`. Later candidate commits add only the
matched public storage/codegen fixtures and correct their initial acknowledgement
setup. The control branch adds the identical fixtures to that base. The
implementation and authority contract are in [paint-slots.md](../../docs/paint-slots.md).

## What the source removes

* A registered color publication freezes and converts one source value, updates
  one author-bank entry and one owned C working-color row. It no longer walks
  per-destination color fanout or rewrites every effective style/inspector base.
* The old 112-byte Runtime paint-map object, its field/sink/edit vectors and the
  native positional `PaintRenderer` map are removed from the GPUI path.
* CPU retained commands refer to shared exact inverse-basis/clip scopes and
  owned paint rows. They retain the original two inverse translations exactly.
* A native exact-token GPU transition writes 16 bytes per changed source color,
  with zero draw validation, binning visits or bind-group creation in the tested
  path. It still clears, draws and submits a complete new target.

This does not remove CPU pixel work, CPU membership processing, GPU geometry
uploads on a full rebuild, or all source-construction allocations. GPU space
factoring remains separate work.

## Matched allocation controls

The fixture uses only the pre-slot public API. All nodes overlap so command
storage scales with owner size. Modes are transparent/default (0), repeated
black literal (1), one shared registered source (2), unique literal colors (3),
and unique literal colors plus unique inverse bases (4). Pending rows retain
acknowledged P, perform a coarse child-count edit, then prepare a resized C.
They include the owner, layout caches, old P, C and command capacities, but no
font service, native driver or owned CPU image.

The initial 24-row baseline, before adding mode 4, is retained separately. Final
baseline/candidate each have 30 rows; source hashes are identical, and count,
mode, pending state and command count are checked pairwise. These are allocator
requested-byte counts, not usable allocation size, RSS, timing, or statistical
performance results.

| Scene | Baseline live B | Candidate live B | Change | Baseline → candidate allocations |
| --- | ---: | ---: | ---: | ---: |
| Empty owner | 5,652 | 5,652 | 0 | 37 → 37 |
| One default node | 6,412 | 6,412 | 0 | 40 → 40 |
| One shared-source node | 7,724 | 7,452 | −3.52% | 53 → 53 |
| 4,096 default nodes | 4,592,308 | 4,592,308 | 0 | 1,211 → 1,211 |
| 4,096 repeated black literals | 2,677,412 | 2,464,420 | −7.96% | 1,239 → 1,228 |
| 4,096 shared-source nodes | 2,727,404 | 2,399,700 | −12.02% | 9,459 → 10,129 |
| 4,096 unique literal colors | 2,677,412 | 2,562,724 | −4.28% | 1,239 → 1,239 |
| 4,096 unique colors and bases | 2,677,412 | 2,759,332 | +3.06% | 1,239 → 1,250 |
| Shared-source owner with held C | 3,530,516 | 2,973,412 | −15.78% | 19,639 → 20,964 |
| Unique colors/bases with held C | 3,464,132 | 3,431,364 | −0.95% | 3,192 → 3,225 |

The held unique case still loses peak requested bytes: 5,462,916 → 5,544,836.
The one-source-node mount requests 9,984 → 10,112 bytes despite lower retained
bytes. Transient `Discovery.ports` uses a BTreeMap per bound node/port; this is a
real construction-allocation regression, not hidden by reporting retained bytes.

## Type and storage ledger

Same-profile headless `Runtime<()>` is 2,320 bytes on both sides. Native candidate
is 2,336 bytes; that is a different feature profile, not a 16-byte source-slot
regression. Node remains 40 bytes, Presented 80, Style 88, El 176, Fanout 32 and
Canvas 488. The existing Metadata box shrinks 256 → 248 bytes and source-only
paint owners no longer need it solely for paint bindings. Public Win is 8 bytes.

| Candidate type | Bytes | Cost scope |
| --- | ---: | --- |
| CPU Columns | 48 | Replaces two existing vector headers |
| InlineDraw / CommonGroup | 56 / 32 | Was 104 plus source / 80 plus range |
| StoredCommon / Scope | 24 / 48 | Translation pair + selectors / exact basis + clip |
| PaintValue | 24 | Working color plus masked support/proof bits |
| SourceColor | 48 | Author value, working value, C position, qualified key, users |
| Color Record | 72 | Layout plus declared/effective color references |
| Color Bound | 88 headless / 128 native | Active-only box; native last transition adds 40 |
| PaintSlot / Option<PaintSlot> | 4 / 4 | Positional, not namespace authority |
| SlotEdit / native SlotTransition | 20 / 40 | One value; one last exact-token transition |
| Frame / PreparedScene / PreparedGroup | 88 / 56 / 104 | Borrowed/transient views |

PreparedScene grows 48 → 56 bytes to preserve the original implicit viewport
when a caller mutates its public width/height header. It is a transient borrowed
view, and is still a real ABI/copy cost. Native Renderer remains 872 bytes;
GpuSurface is 1,056 bytes, replacing the former 24-byte positional wrapper.
These native sizes are also reported with their feature profile in the log.

Before Vec capacity, the fully unique CPU inline case costs 56 + 48 + 24 = 128
bytes versus 108 previously. The 20-byte excess per draw is not amortized by
sharing in that regime. An adjacent cohort beginning after the first 32 scopes
now reuses the exact last scope: 4,096 repeats add zero rows/allocations. Two
alternating late scopes deliberately retain the bounded-discovery loss: the
test ends with 162 rows, capacity 256, two growth allocations requesting 18,432
bytes. The first-32-only source is preserved in `be3809f750`.

The GPU bank prefix costs one 16-byte header, two bits per row rounded to a
16-byte word, and 16 bytes per row through the last shared slot. Intervening
literal rows duplicate color payloads already in draw records. Finding that
last row currently scans all literal rows for an all-literal scene. The banked
shader uses 16 local Vec4 colors (256 bytes before backend allocation/register
decisions). Neither effect has a measured frame-time result here.

## Linked public consumer audit

The exact same ordinary `Win::property(BACKGROUND)` helper runs for a literal
owner and a source-bound owner. It also calls typed `Win::set`. The original
fixture incorrectly inspected before initial acknowledgement and failed with
empty P on both implementations; the corrected fixture acknowledges first and
both final executions pass. No timings were taken from either version.

The baseline `style_property<Color>` linked body is 431 bytes; candidate is 622.
Candidate plain default/dense/shared paths materialize all 88 Style bytes in a
96-byte stack area before calling the erased declaration getter. The bound path
additionally calls a 295-byte outlined `Bound::get`, which calls a 268-byte
`Bank::colors`. The copies were not optimized away. These are concrete remaining
costs, not a claim that wrappers/const selectors necessarily disappear.

The CPU scope finder is outlined at 558 bytes in the storage consumer and called
once from admission and once from storage. The exact last/prefix comparisons
do not perform FP arithmetic, but still add full-preparation work. GPU bank
lookup is outside the 16-sample loop in the authored WGSL; no hardware ISA,
register-pressure or latency claim follows from that source structure alone.

The storage consumer's linked `.text` is 7,944,145 → 7,963,365 bytes (+19,220),
with data 153,160 → 153,696 (+536). Exact property-consumer sizes and executable
hashes are in the provenance. These binaries include allocation instrumentation
and example code; they are not stripped native deployment footprint estimates.

## Coverage preservation and exact gate scope

The old five public `gpui/tests/paint_patch.rs` tests are byte-identical: full CPU
color oracle; pending targets/geometry; prior full C and failed newer prepare;
masked lower bases/alpha fallback; virtual Keep-P membership/semantic columns.
Existing `canvas/tests/paint.rs` and native AccessKit Consumer transitions are
also unchanged. The latter cover preserved full pending rows/zero-node deltas,
no-op complete coverage and late observer activation. They execute in the native
unit gate. Only obsolete private map-capacity assertions became Colors-bank and
Metadata-absent assertions in the retained cold/warm allocation test.

New Canvas slot tests cover independent literal full-render oracles, whole-list
rejection, dropped admission, legacy literal detachment including exact-equal
Set, and empty/clipped deferred admission. New public GPUI cases cover distinct
equal-valued sources, one-source publication work, and equal inspector masking
with independent peer pixels. A private owner test admits 131,074 distinct color
ports on 65,537 zero-size nodes with zero allocations in the draw-admission phase
and no C paint rows/resource-limit failure. This does not claim the preceding
description/registry construction allocated nothing.

The actual GPU bank case queues full A, slot patch B and slot patch C to separate
targets without polling/readback between submissions, then compares SDR/HDR
bytes against fresh full literal packets. Other new cases reject a late invalid
edit without changing an earlier valid row, reject literal/missing positions,
and reject signed-zero/negative-subnormal opaque-proof changes before full
render recovery. The actual native private bridge independently compares
`with_paint_scene → GpuSurface::render_paint` against a fresh full GPU renderer,
CPU output, and real window policies. Coalesced-token gaps and alpha changes
prove full fallback. GPU upload counts are 16 bytes per changed slot, independent
of destination count in those executions.

Gate counts are parsed from logs, and overlap across profiles:

| Exact Cargo selection | Executed | Deliberate exclusions |
| --- | ---: | --- |
| `test -p gpui --lib --tests -- --test-threads=1` | 363 | Docs; ignored native/cost tests |
| `test -p gpui_canvas -p gpui_gpu --features gpui_canvas/parallel --lib --tests -- --test-threads=1` | 154 | Docs; feature-gated actual Vulkan test file; ignored cost tests |
| `test -p gpui_gpu --features vulkan-tests --test render -- --test-threads=1` | 39 | Other packages/docs |
| `test -p gpui --features x11,wayland --lib -- --nocapture --test-threads=1` | 134 | 19 ignored native/cost tests; docs/public integration files |
| `test --release -p gpui --lib -- --nocapture --test-threads=1` | 103 | 5 ignored library tests; docs/public integration files |
| `test -p gpui_canvas -p gpui --doc -- --test-threads=1` | 26 | 1 merged GPUI pass, 23 separate GPUI cases, 2 Canvas cases; other packages/profiles |
| `test -p gpui --features x11,wayland --lib native_todo_port_presents_edits_pointer_actions_resize_and_inspection -- --ignored --exact native::tests::native_todo_port_presents_edits_pointer_actions_resize_and_inspection --nocapture --test-threads=1` | 1 | Other native scripts |

All use `--manifest-path reactivity/Cargo.toml`, distinct recorded target
directories and two build jobs. Native execution uses Xvfb `:94` plus the local
Vulkan software adapter. This is real API/render/readback coverage, not hardware
GPU performance evidence. Strict all-target Clippy enables
`gpui/x11,gpui/wayland,gpui_canvas/parallel,gpui_gpu/vulkan-tests` for all three
packages. Existing vendor Parley ICU deprecation warnings remain outside the
first-party strict lint scope. Apple/Windows gates are not claimed by this branch.

## Recommendation and next cuts

Keep this as the end-to-end correctness substrate under review. Before adopting
the representation broadly, replace per-port transient BTreeMap discovery,
restore borrowed ordinary property access, and evaluate immutable literal
interning/copy-on-write separately. The unique-scope/color loss and extra bank
scan need controls rather than assumed wins. No source edits implementing those
follow-ups are mixed into the frozen implementation.
