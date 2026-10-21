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

The complete release parallel Canvas suite passes 77 cases/doctests; strict
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
HDR and parallel controls are separate adoption checks, not inferred wins.
