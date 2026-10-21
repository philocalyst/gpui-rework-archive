# Preserved surface repair

The software presenter repairs a certified old native buffer directly. It keeps
no additional image, previous display list, pixel hash, compression dictionary or
per-node damage field. The ordinary public full-render path remains the pixel
oracle. GPU rendering still renders complete frames.

## What establishes the proof

Canvas compares the old and newly completed canonical commands while both sets
of immutable mask leases are live. Equal commands require exact bounds, rectangle,
clip, inverse-mapping and working-color bits, plus identical leased raster data.
Insertion, removal, reordering or a changed command contributes both old and new
support. A clear or output-configuration change covers the entire image. The
comparison stops when support already covers the viewport. It neither hashes
commands nor quantizes geometry or HDR working colors.

Each completed candidate unions that support with any unpresented predecessor's
support. Failed preparation never replaces the coherent candidate or its damage.
Only successful presentation of the exact token retires the pending transition.
The existing 40-byte Prepared header retains its size: admitted viewport extents
fit two u16 values, making room for the eight-byte DamageRegion. Node, Presented,
Style and Canvas headers gain no damage fields.

The native software surface exclusively owns a 26-byte history: three rectangles
and the count of known presents, capped at four. A reported buffer age is useful
only when it refers to an actual known presentation in this surface generation.
The presenter unions the intervening transitions and the current candidate's
transition. Undefined contents, ages beyond the bound, new surfaces and resized
surfaces require full rendering. The history advances only after native present
and exact owner acknowledgement succeed. A solid backend presentation clears the
history because it can discard the pixel backing entirely. History storage does
not allocate or grow with scene size.

Native upload remains complete, even for empty raster damage. Window exposure can
require restoring server contents although the client buffer already contains
the right pixels. Raster damage alone does not grant permission to omit upload.
An unchanged preserved image therefore skips CPU binning and raster work while
still taking the normal native presentation and accessibility acknowledgement.

## Raster work and ownership

Only intersecting 16×16 tiles are rasterized. CSR counts, offsets and references
cover the repair rectangle's tiles instead of the whole viewport. Bins retain
their existing peak Vec capacities; a formerly full-frame render does not shrink
them. No separate damage bitmap or tile queue is retained. The explicit worker
pool estimates work over the repair area and borrows immutable commands while
workers own disjoint mutable output bands. Repair cannot touch diagnostic pixels
or mark a previously allocated diagnostic image clean.

The public Canvas APIs are `commit_with_damage`, `render_bgrx_region` and, with
the parallel feature, `render_bgrx_region_with`. A region call requires a caller
proof that pixels outside the region already match the scene. Calling full
`render_bgrx` needs no preservation proof. Both validate output format and length
before accessing the supplied buffer. Current native software output is opaque
sRGB BGRX. Damage comparison also tests HDR scenes, but this change does not add
native HDR output negotiation.

## Evidence and limits

Source `b0a85781ea` passes all 19 integration gates: 408 debug and 408 release
workspace cases/doctests, 73 parallel Canvas cases, strict Clippy/format,
18 actual Vulkan readbacks and the six native application/accessibility scripts.
The parallel suite overlaps the workspace tests. Linux execution does not stand
in for Windows, macOS or Wayland runtime coverage.

Canvas reference tests compare every pixel after insertion/removal, reordering,
reflections, shear, fractional clips, text movement, unpresented intermediate
edits and HDR working-color changes, with tile proofs enabled and disabled.
Explicit one-, two- and four-worker pools produce the same repaired image.
An independent reference canvas checks a distant two-tile repair uses at most
128 bytes of bins rather than allocating a viewport-wide index.

Owner tests check coalesced candidates, failed later preparation, exact token
acknowledgement, empty re-exposure, five independent simulated swapchain images,
ages through and beyond retained history, and revoked surface authority. The
actual X11 Todo and 250K Library scripts check server pixels, transforms, input,
resize and suspend/resume with the production native presenter.

`cargo run --release -p gpui_canvas --example damage_cost` emits paired raw rows
for a small moving caret over stable lists of 1, 65 and 1001 commands. Each row
compares full preparation/rendering with exact comparison/repair, alternates
order, uses separate retained canvases/buffers and checks every pixel outside the
timed interval. Allocator instrumentation is present in both raster timings.
This fixture excludes native upload, event delivery, scanout, font shaping and
whole-application startup. Its ratios are not click-to-photon measurements.

Five fresh processes provide 55 paired steady rows per workload on an AMD Ryzen
7 3700X, x86-64 Linux/NixOS, Rust 1.97.1. Source and executable identity, all raw
rows and phase medians are in [the evidence](../canvas/evidence/damage/measurements.json).

| Stable commands plus caret | Full prepare + raster, median | Compare + repair, median |
| --- | ---: | ---: |
| 1 | 482.6 µs | 14.8 µs |
| 65 | 1,766.2 µs | 27.6 µs |
| 1,001 | 21,639.8 µs | 206.7 µs |

Warm repair rasterization creates no allocations in this fixture; preparation
still allocates its transactional command storage. Both canvases retain the
bin capacities established by their initial full rendering. The separate local
bin oracle, rather than these warm capacities, establishes the 128-byte bound.

This first representation uses one conservative bounding rectangle. Widely
separated edits can repaint their intervening area. Comparison and binning still
walk command order, although full damage comparison short-circuits. Persistent
subtree recipes, damage islands, retained GPU attachments, paths/SDF effects and
compositor feedback remain separate work; none is implied by these results.
