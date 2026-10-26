# Exact samples without unconditional expansion

The software band kernel keeps each pixel as one premultiplied-linear color
until an incoming command has different coverage at its sixteen sample sites.
It then copies the preceding color into that pixel's sixteen slots and performs
the ordinary ordered sample composition. A promoted pixel remains expanded for
the rest of the tile. No primitive is averaged before composition, no coverage
correlation is discarded, and no output color is quantized for storage.

The representation is worker-local: a 4 KiB uniform lane, a 64 KiB expanded lane
and a 256-bit promotion map. It adds no scene, node, command, Canvas or owner
field, no allocation and no resource/refcount operation. Both arrays are fully
initialized once per active band; uniform tile reset subsequently touches only
the 4 KiB lane and map. This is not lazy uninitialized storage or a reduction in
reserved stack. On the inspected x86-64 release instantiation, the function
subtracts 70,504 bytes (68.85 KiB) from the stack, plus six saved registers.
The arrays and map occupy 69,664 bytes. Existing 512 KiB pool stack reservations
remain unchanged. The cost of starting a band therefore includes both arrays'
initialization, even when no pixel eventually promotes.

Uniform coverage applies the same source-over operation once to an identical
color; after expansion it applies that operation independently at each site.
The final sample mean uses a typed sixteen-element array, sums in f64 and narrows
once. Sixteen identical finite f32 values sum exactly within f64's significand.
Seeding from the first sample also retains sixteen negative zeros, matching the
uniform CPU path. The current GPU reduction may erase a zero sign after an empty
sample contribution. The minimized actual Vulkan regression requires equal
numeric HDR colors while allowing either zero sign; there is no cross-device
half-word identity guarantee. Authored Color bits remain lossless.

Axis-aligned rectangles separately factor membership into four x decisions per
column and four y decisions per row. The 64-byte stack mask combines their bits
into the original sixteen correlated sample positions. The same admitted inverse
and half-open clipping predicates apply, including reflection and signed-zero
coefficients. Full-tile certificates test the first and last actual sample
centers; monotonic separable axes prove the remaining centers. General affine
geometry retains its scalar sampling and conservative full-tile proof. A private
oracle compares every resulting membership bit with that original scalar path,
including subnormals, cancellation and neighbors of quarter-pixel boundaries.

At that isolated source, the release parallel Canvas suite passes 77 cases/doctests; strict
all-target parallel Clippy passes. The promotion unit oracle exercises all 65,536
binary coverage patterns with preceding/subsequent translucent layers and an
untouched neighbor. The public randomized regression compares 2,400 complete
images with the uncompressed sixteen-color path across SDR/HDR, sRGB/P3, partial
tiles, reflected/sheared translucent overlaps and real glyph masks. Independent
review additionally compared 15,076,800 concatenated image bytes with the pre-axis
renderer: SHA-256 `95f7c4fb7d270481ec1b92af784987f8b217d54655501fb20eba269a52b53e11`.
Disabling tile proofs disables promotion but still uses the axis membership
optimization; the independent scalar membership oracle covers that shared part.

## Paired retained-scene measurement

The unchanged public `damage_cost` example builds a fresh command-only candidate,
then either fully rasterizes or repairs the certified region in separate canvases
and external buffers. It alternates the two paths and checks every output pixel
outside the timers. The scene is 1280×720, with a small moving caret and 0/64/1000
stable integer-aligned rectangles. Five fresh-process pairs alternate the old
and new binaries; eleven warm rows per workload/process give 55 paired rows.
Raw process CSVs, joined rows, hashes and medians are in
[evidence/samples](evidence/samples/measurements.json). Sources are
`0c050e0147778f48672090f1f32a7d2311510749` and `3e47fbaa56`.

| Draws | Old full raster | Axis + promotion | Old repair raster | Axis + promotion |
| --- | ---: | ---: | ---: | ---: |
| 1 | 484.37 µs | 455.98 µs | 14.41 µs | 5.05 µs |
| 65 | 1,769.46 µs | 800.96 µs | 15.11 µs | 5.66 µs |
| 1,001 | 21,529.79 µs | 6,059.80 µs | 23.39 µs | 13.99 µs |

Warm repair raster makes zero allocations in both binaries. Preparation is
separate and still allocates: median 1,001-draw repair preparation is 180.19→176.98
µs. Bin capacities and retained mask/command storage do not change. These are
CPU preparation/raster measurements on the shared Linux Ryzen host, excluding
native upload, event delivery, compositor, scanout and competitor applications.
The caret scene favors uniform rectangular interiors; text, general affine,
HDR and parallel controls are measured separately below.

## General scenes and output conversion

The unchanged public `parallel` example measures preparation plus raster for
five scenes, serial execution and owned 1/2/4/8-worker pools. Each process reports
the median of seven warm batches. Five fresh-process repetitions rotate three
kernel versions in both SDR and linear HDR: the pre-axis renderer, axis plus
promotion, and one additional exact output-conversion cache. All 750 CSV rows
retain the same scene/format digest across versions and workers. Pool/font
creation and native presentation are excluded. Raw rows, executable hashes,
per-process diagnostics and every median are in
[the control ledger](evidence/samples/controls/measurements.json).

The last version remembers only the immediately preceding nonuniform pixel's
four working-color bit patterns and encoded output, inside each band's stack.
An exact match copies the final bytes instead of repeating output profile,
transfer or half-float conversion. There is no retained palette, hashing,
approximate comparison, synchronization or allocation. Comparing all channel
bits preserves distinct positive/negative zeros; a two-pixel public HDR test
requires both signs in the same tile. The complete release parallel Canvas
suite at that isolated source passes 78 cases/doctests and strict all-target Clippy.

| Scene | Pre-axis serial | Axis + promotion | Plus output cache | Output |
| --- | ---: | ---: | ---: | --- |
| 640×480, 48 labels | 16.904 ms | 13.869 ms | 13.750 ms | SDR |
| 320×240, 48 sheared translucent boxes | 3.200 ms | 1.952 ms | 1.850 ms | SDR |
| 4×32 boundary scene | 18.322 µs | 12.910 µs | 12.822 µs | SDR |
| 640×480, 48 labels | 21.226 ms | 17.304 ms | 14.639 ms | HDR |
| 320×240, 48 sheared translucent boxes | 4.360 ms | 2.775 ms | 1.938 ms | HDR |
| 4×32 boundary scene | 20.988 µs | 14.878 µs | 13.667 µs | HDR |

The eight-worker label medians are 2.754→2.398→2.330 ms SDR and
3.632→3.034→2.362 ms HDR. Tiny boundary scenes still lose to scheduling:
the final SDR kernel is 12.822 µs serial versus 20.657 µs with eight workers.
Serial remains the default and the explicit scheduling threshold is unchanged.

Retain the output-cache losses: SDR flat 640×360 serial is 183.172→186.190 µs
(+1.65%) versus axis/promotion alone, and 1920×1080 is 1.554→1.581 ms (+1.77%).
The HDR boundary scene with eight workers is 21.659→21.744 µs (+0.39%).
Flat-tile output already converts once per tile, so the extra sampled-pixel cache
offers no conversion reduction there. These finite shared-host observations do
not establish a universal win, hardware-GPU speedup or application input latency.

## Separable glyph addresses

Axis-aligned glyphs now share the original sample-to-mask address calculation
across each tile column and row. Four column addresses and four row offsets
reconstruct the same sixteen correlated coverage values. If all sixteen sites
address one cell, one mask-byte fetch supplies them all. Reflection, clip/domain
comparisons and normalization retain the scalar sampler's f64 operation order.
Dropping zero off-diagonal terms can change a zero sign, which changes neither
half-open membership nor the integer cell address. General affine glyphs keep
the scalar sampler.

The helper borrows its immutable raster. Its address tables occupy 1,032 bytes
on x86-64, transiently inside a worker; no scene, command, node, allocation or
resource lease is added. The original samples are not averaged before blending.
An independent scalar oracle covers every coverage bit, all alpha values,
reflections, quarter-boundary neighbors, subnormal extents, large cancellation,
partial tiles, narrower/disjoint command bins and all signed-zero off-diagonals.
The isolated release Canvas suite and strict parallel Clippy passed; the two
private address oracles also passed after the adversarial bounds extension.
Combined native/GPU verification is recorded separately in the workspace report.

Five alternating fresh-process pairs use the unchanged general-scene example.
The [complete ledger](evidence/glyph-axis/README.md) retains 500 timed rows,
activation checks, source/binary hashes and an excluded earlier capture whose
saved baseline was found to contain the new algorithm. Corrected binaries use
separate source trees and target directories. These medians isolate this change
from the preceding output-cache kernel:

| 48-label scene | Previous serial | Glyph axes serial | Previous 8 workers | Glyph axes 8 workers |
| --- | ---: | ---: | ---: | ---: |
| SDR | 13.805 ms | 5.728 ms | 2.491 ms | 1.119 ms |
| Linear HDR | 14.695 ms | 6.676 ms | 2.684 ms | 1.236 ms |

Geometric/address queries fall 1,846,272→126,744; retained capacities and each
scene/profile digest agree across versions and workers. The non-text controls
retain losses: SDR serial flat +2.05%, large flat +2.12%, shear +2.62% and
boundary +2.88%; HDR serial shear +2.29% and boundary +3.06%. Scheduling noise
is larger for some tiny parallel cells: HDR flat at four workers loses 15.76%.
No whole-application or native-latency speedup is inferred. The capture predates
the integrated Unicode planner, whose shaping and memory costs have their own
[ledger](TEXT.md).
