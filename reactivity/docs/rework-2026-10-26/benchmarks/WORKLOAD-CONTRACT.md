# Changed-work interaction contract, version 1 (draft until correctness gates pass)

Production source: `7ac6f33` in philocalyst/gpui-rework-archive. The new example
uses only ordinary public GPUI APIs. It does not add hover, popover, animation,
private layout timing, or GPU APIs to production merely to claim support.

## Scope and tiers

The primary fixture is a dense inspector/dashboard of 32 rows x 32 individually
named, actionable cells (1,024 controls, 24px base size, 30px rows). A separate
100 x 100 stress tier has 10,000 controls (8px cells, 10px rows). Do not substitute
the stress tier for the primary result or aggregate the two. Except for actual
popover/list content, cells are solid-color structural controls without text;
the text lane owns a complementary responsive text/reflow workload.

Physical viewport 1000 x 1000, scale 1, default color configuration. The resize
case alternates 1200 x 600 and 1000 x 1000. Immutable font is the existing pinned
Inter-Regular.ttf, SHA256
40d692fce188e4471e2b3cba937be967878f631ad3ebbbdcd587687c7ebe0c82.
Every operation is changed work; no idle/equal-value timing is included here.

## Operations

1. `hover-source-paint`: real normalized PointerSession Move/Leave, public
   acknowledged hit test, application target-to-cell lookup, then one direct
   typed source assignment. One global hovered ID maps to all cell backgrounds.
   This intentionally measures that actual source fanout, not an invented native
   hover callback. The trace alternates enter, transfer to a neighboring cell,
   leave, and enter a far cell. Repeated cycle bands explicitly target the first
   row, last row and two middle regions throughout warmup and measurement.
   Samples retain hovered-cell ordinal so first/last-row hit-routing cost is
   reported separately; a paint fast path cannot hide reverse-scan hit work.
2. `hover-property-paint`: identical pointer trace. The application removes the
   prior target's BACKGROUND contribution with Inherit and applies a typed
   background contribution to the newly hit target. Two edits may prepare two
   complete candidates before the one final logical ACK. Neither edit is hidden
   or called a native CSS hover implementation.
3. `hover-property-layout`: same public typed-property route, but WIDTH gains
   four logical pixels while hovered, then restores Inherit. Later siblings
   genuinely move in the ordinary row layout. Pointer points are independent
   deterministic baseline cell centers, not queries of the result being tested.
4. `popover-scroll`: real click opens/closes conditional app-composed 240 x 160
   popover content above a real native VirtualList of 10,000 x 32px labeled rows.
   The seven-step cycle is open, wheel down 32, wheel down 32, horizontal
   reposition, wheel up 32, wheel up 32, close. Wheel is a normalized public
   PointerEvent at a fixed point outside the overlay. After each scrolling sheet
   is logically acknowledged, the application reads its actual acknowledged row
   anchor and updates the popover transform, then acknowledges that sheet too.
   Thus a scroll operation has two real prepare/ACK stages. They are retained
   and reported, not divided away. The public API has no atomic native anchored
   popover positioning facility. Title/menu and row text are Inter14.
5. `window-resize-layout`: only public Win::resize changes the entire viewport.
   An actual wrapping flex row contains all fixed-size controls; its max-content
   width exceeds both viewport widths. The primary tier changes from 38 columns
   / 27 lines to 46 columns / 23 lines; the stress tier changes from 100 / 100 to
   120 / 84. Dependent x/y positions and line counts change without any manual
   derived leaf-width assignment. Height changes also constrain/clamp visible
   content. Target namespace and surviving site identities remain stable. This
   is native layout reflow, not a flex-grow leaf-width benchmark.
6. `app-ticked-geometry`: each explicit 120Hz application tick changes mapped
   widths, heights and y translations across all cells. Per-cell phase offsets
   form a deterministic triangular cycle; no native easing/timer/timeline API is
   claimed. Layout and output geometry both change. No sleeps or worker thread
   are in the operation. Virtual timestamps describe inputs, not OS scheduling.

## Measurement boundaries

Recording mode uses the real production owner/layout/Canvas path, but the
adapter performs an explicitly **logical headless ACK**, not native presentation.

- `routing_ns`: normalized move/leave + hit testing/application lookup, or the
  acknowledged anchor query. Click callbacks that mutate are in edit/prepare.
- `edit_prepare_ns`: complete public mutating calls, including source/model
  admission, relevant owner/description work, layout, scene preparation and any
  click/wheel dispatch in that call. Public APIs fuse these phases. They are NOT
  falsely presented as isolated source or isolated layout wall times.
- `scene_borrow_ns`: borrowing the completed scene/token and O(1) draw count.
- `raster_ns`: optional full CPU render_bgrx into a preallocated output slice.
  This is a distinct `cpu-raster` mode, not interleaved with scene-only samples.
  Resize uses a preallocated maximum-size backing; allocation is outside timers.
- `logical_ack_ns`: public Win::presented for the actual completed token.
- `edit_prepare_calls` retains every public edit call, including both old-target
  Inherit and new-target Set on hover transfer. `logical_submissions` and
  `ack_calls` count final completed sheets actually handed to the logical
  adapter, not every superseded candidate prepared by those edits.
- Work counters retain source operations/reads, descriptions, destination
  comparisons, layout/measure calls, paint passes and presentations separately.
  They count documented invocations, not visited nodes or elapsed layout time.
- Model/source-only wall time, isolated layout wall time, upload bytes/time,
  native present, GPU execution, display scanout and input latency are unavailable
  at this public headless cut and must remain null/unavailable, not zero.

The total is the sum of these measured public phases. Oracle/JSON work is not in
the phase timers. Timer overhead is retained, not subtracted. Instrumentation is
ordinary stock counters. No global allocation wrapper is added to CPU timing.

## Exact correctness and authority gates

`--validate` is a separate correctness-only full trace, checking every logical
submission including the intermediate scrolling sheet before anchor reposition.
It reconstructs expected
model state independently from the operation trace, checks actual source state,
and compares complete ordered canonical draw geometry/color/clip words plus all
CPU output pixels with a fresh public-API window reconstructed from that expected
state. Target namespaces/resource IDs are intentionally not compared across fresh
windows. That oracle detects incremental reconstruction/retained-state mistakes;
it is NOT an independent implementation of GPUI's layout or text rasterizer.
Additional fixed geometry, hit, color, inheritance and anchor assertions avoid
relying solely on that shared implementation. No tolerant pixel comparison.

Before timing, adversarial controls also cover initial/pending ACK authority,
older coherent ACK after a newer failed preparation, stale old tokens, target
disappearance while hovered, stale property admission, remount identity, and
restoring Inherit/base after leave. Validation runs have `timing_eligible=false`.
Final timing traces retain exact expected state checks outside phase timers and
initial/final full-output gates, but do not mount an oracle between every sample.

Trace defaults: 32 warmup + 240 measured operations. Parent grants timing windows;
none may run before a grant. Planned process campaign: one discarded + seven
measured processes per case/mode/tier, serialized, raw per-operation samples and
child CPU time/HWM retained. Report each operation/subframe count and differing
scene versus CPU-raster modes. Cold construction is separate diagnostic cost,
not part of steady-state samples.

## Reproducibility / resource rules

Separate baseline source tree and target; original measured baseline untouched.
Source is frozen/committed before a build. One compiler job, no incremental or
debug info. Parent controls release of the build and quiet timing windows.
The entire dedicated seeded target must stay under 400 MiB unless parent grants
more; never mutate the root baseline target. Keep at least 8 GiB disk free and
record exact source/toolchain/build messages, executable SHA256 and raw results.
