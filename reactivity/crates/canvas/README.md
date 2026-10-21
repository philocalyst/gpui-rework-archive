# gpui_canvas

A real software text/canvas foundation independent of legacy GPUI. It shapes
OpenType glyph IDs/positions with pinned rustybuzz 0.20.1 and rasterizes those
same IDs on demand with pinned Swash 0.2.10 (Skrifa 0.44.0). Full Noto Sans 2.015 and its OFL license are
bundled; `TextSystem::new` also accepts caller-supplied font bytes. Nothing reads
an absolute asset path. [Font provenance](assets/README.md).

`FontFace` shares immutable source bytes and a stable raster identity. Cloning a
face and passing it to `TextSystem::from_font` creates independent mutable glyph
caches over that same font. `TextSystem::bundled/new` remain convenient constructors;
`font_face()` borrows the handle and `same_face()` compares process-local identity.
Bundled services share through a weak registry. Supplied bytes are copied once
per explicitly created FontFace; equal bytes are not implicitly interned.

```rust
use gpui_canvas::{Canvas,Color,TextSystem,Point,Rect,Affine};
let mut fonts=TextSystem::bundled()?;
let text=fonts.shape("office café",18.0,Some(200.0))?;
let mut canvas=Canvas::new(320,100)?;
let mut candidate=canvas.stage();
candidate.clear(Color::WHITE);
candidate.draw_text(&mut fonts,&text,Point{x:12.0,y:8.0},
    Affine::IDENTITY,Rect::new(0.0,0.0,320.0,100.0),Color::BLACK)?;
candidate.commit(); // no allocation or validation; preserves output allocation
let rgba=canvas.pixels();
# Ok::<(),gpui_canvas::Error>(())
```

`TextLayout` owns glyph positions, UTF-8 clusters, advance width, line height,
first baseline and font-face identity. A layout can paint through any service
sharing that face; independently constructed faces reject it. Positions do not
keep a face alive: retain a FontFace or TextSystem while its layout needs fresh
rasterization. Painting does not reshape. Wrapping prefers
whitespace, then whole shaping clusters, and reshapes each resulting line. An
indivisible cluster may exceed the requested width. The ink bound describes
conservative source-raster support; device sampling must also be included when
using it for damage. Successful direct drawing appends commands; clear starts a
new scene. Appending after pixels rerenders the retained scene. A clean pixels
call returns immediately; a real render counter tests this.

`CanvasScene` holds an exclusive borrow and a command-only candidate with no
pixel image. Drop preserves the prior scene; commit moves prepared scene data
into the target and retains its sole RGBA image and bin capacities. Candidate
rasterization is not available through its type. Font cache mutation during
preparation does not revoke masks leased by the prior scene. Rendering itself
is synchronous; this is not an asynchronous GPU/OS buffer lease protocol.

## Actual color and sampling contract

`Color` is a validated straight-alpha `[f32;4]` plus source profile, not a byte
component bag. Familiar const rgb/rgba constructors mean encoded sRGB. Explicit
constructors support encoded/linear sRGB and Display P3; negative and extended
RGB survive conversion. Alpha is finite in [0,1]. Numeric admission limits the
converted working channels to ±1e20, with an explicit error beyond that range.
D65 matrices and mirrored negative transfer functions follow
[CSS Color 4 conversion formulas](https://www.w3.org/TR/2026/CRD-css-color-4-20261009/#color-conversion-code).
Conversion into extended linear sRGB happens per prepared command. All source-over
composition and sample averaging occur there before final output mapping.

`ColorConfig` declares sRGB or Display P3 output, RGBA8 premultiplied encoded
channels, and explicit clipping or per-channel Reinhard exposure mapping. Both
profiles use the sRGB transfer curve. Output mapping follows composition; no
source gamut clamp is permitted. P3 bytes require a tagged/negotiated host and
must not be passed to an sRGB-only display path as if equivalent. Clipping is a
simple declared SDR policy, not the perceptual CSS gamut mapper. Reinhard is
scene-relative and per-channel, not a hue-preserving HDR standard.
RGBA16F is a real linear-light eight-byte output with explicit primaries,
reference white and finite-saturation conversion policy; see [COLOR.md](COLOR.md).
It has no SDR transfer, gamut clamp or tone map. Rec.2020, PQ/HLG, arbitrary
ICC/video conversion and HDR surface negotiation remain unsupported here;
a host must explicitly negotiate a matching presentation path.

Rectangles and font masks use a fixed 4×4 per-pixel sample grid, retaining each
sample through ordered composition. Averaging a primitive before composition
would incorrectly correlate overlapping edges and is explicitly tested. Swash
already integrates outline coverage into grayscale cells; those cells are a
piecewise-constant local field sampled by the common grid. Native integer mask
placement preserves its antialiasing. This is finite sampling and bitmap
reconstruction, not exact area AA, hinting or arbitrarily scalable outline text.
Device-scale rerasterization and high-zoom/anisotropic text quality remain gates.

Geometry uses core Rect/Affine/Point. Clip is one canvas-space axis-aligned
rectangle. Negative scale, shear and reflection work. Nonfinite, singular,
out-of-domain or excessively large inverse coefficients return InvalidGeometry.
There is no silent rotated-clip AABB approximation. Rounded/path clips, borders,
images, gradients, effects and custom shaders are not implemented by this API.

Text currently supports one strong script per paragraph: Latin, Greek or
Cyrillic, with common/inherited characters. Missing glyphs, mixed/other scripts,
bidi formatting controls, tabs and unsupported directions return explicit errors.
No font fallback, bidi paragraph resolver, editing/caret model, variation API,
color glyph or LCD text support is claimed. These are production integration
requirements, not made-up replacement glyphs.

## Work and memory

One tightly packed output image costs **4×width×height bytes**. There is no full
float image. One 16×16 tile retains 16 premultiplied-linear samples per pixel:
**65,536 bytes** of stack scratch, reused for the frame. Convex inverse-mapped
full-tile certificates bypass sample tests; full opaque rectangles cut prior tile
commands. Uniform tile prefixes fold once and need no scratch writes. Strict
margin guards cover the admitted f64 arithmetic; uncertain cases sample normally.
Direct and accelerated output is byte-identical in randomized tests. The
independent f64 polygon/sample oracle permits one byte of final rounding error.

Limits are 16,777,216 pixels, 16,384 pixels per side, 65,536 commands, 4,194,304
tile references, 32 MiB distinct leased mask payload per admitted scene, 8 MiB
cached mask payload and 4,096 cache entries, 1 MiB per raster, 16 MiB font input,
32 KiB text input, 32K glyphs and a 1 MiB cumulative shaping-input work budget.
The wrapping work budget bounds repeated suffix shaping, returning ResourceLimit
instead of allowing quadratic pathological input work without a bound.
A staged scene can temporarily retain old+new command/mask sets; at the maxima,
old/new leases plus cache have a conservative 72 MiB mask-payload bound. Actual
shared masks usually overlap. The cache cap is independent from live command
leases: eviction cannot free a mask still in use.

The retained display list uses typed geometry/resource lanes; see the measured
run representation below. CSR offsets and reusable fill cursors use two usize
arrays per tile; references use u32. Stats report exact draw/resource Vec and
bin capacities, unique retained mask payload, sample tests and skipped tile
predecessors. Hash-table/control bytes, Arc bodies, bounded Swash scratch, source
bytes, allocator slack and process/native-service overhead are separate costs;
payload counters are not RSS. The raster/compositor pixel loops allocate nothing;
warm CSR buffers are reused.

## Validation and measured baseline

Run `cargo test -p gpui_canvas`, the same with `--release`, and
`cargo clippy -p gpui_canvas --all-targets -- -D warnings`.
Integration tests cover color conversions/roundtrips, negative extended
blending, declared P3 output, linear HDR bytes, alpha, correlated edges, randomized
forward-polygon versus inverse-raster scenes, ligatures and Unicode, native
independent Swash pixel placement, transformed mask-cell sampling, UTF-8 wrapping,
foreign-font rejection, clipped reflected text, resource caps and candidate
failure/commit. A compile-fail doctest prevents candidate rasterization.
The font registry unit test verifies Send+Sync, one parse across eight concurrent
cold acquisitions, final strong release, fresh identity on reinitialization and
recovery from a simulated initialization panic. Public tests verify cross-service
layout admission, independent caches and ownership of caller-supplied font bytes.

`cargo run --release -p gpui_canvas --example cpu -- /tmp/labels.ppm` renders
actual complete labels and emits counters and median timings. The optional PPM
is an opaque sRGB example output, not a font screenshot substitute. Tests do not
use reference screenshots. [Recorded CSV](evidence.csv) is one Linux x86_64 run
on an AMD Ryzen 7 3700X, rustc 1.97.1, default release optimization, one warm-up
and median of three complete clear/admit/bin/render frames. Boundary-dense
4×4 frames are batched 200 times per sample. Font initialization was 24.8 ms;
the first 16-glyph shape was 221 μs. Shaping is outside those frame timings;
command preparation, mask lookups/leases, bins, sampling/composition and final
encoding are inside. No window/compositor, upload or GPU timing is included.

The scalar direct path is deliberately exhaustive under the same sampling
contract, not an existing competitor renderer. Large flat/opaque overlaps remove
millions of tests; small sheared boxes, labels and boundary-dense cases receive
little or no benefit, and may lose to proof setup. Forty-eight real 16px labels
at 640×480 cost about 31 ms on this baseline. That is useful correctness evidence,
not an acceptable final text-performance target or a claim of GPUI completion.

Verified primary library APIs: [rustybuzz 0.20.1](https://docs.rs/rustybuzz/0.20.1/rustybuzz/),
[Swash scaling](https://docs.rs/swash/latest/swash/scale/index.html),
[Skrifa outline API](https://docs.rs/skrifa/0.44.0/skrifa/outline/),
[Unicode script 0.5.8](https://docs.rs/unicode-script/0.5.8/unicode_script/).

## Lazy outline font lifetime and measured memory

Each FontFace is one Arc to immutable `{bytes, stable Swash key, checked ID}`.
There is no eagerly compiled glyph array. Face admission parses borrowed font
headers, not every glyph's geometry. Noto Sans bytes remain borrowed static data;
caller bytes are copied once. The bundled registry is a directly initialized
`Mutex<Weak<FontData>>`. Only cold admission takes the lock; poisoning before
publication is recovered because the slot always contains a valid Weak.
The last strong owner releases caller bytes. A later bundled acquisition mints
new identity, so old layouts cannot accidentally rebind.

Each TextSystem owns an independent bounded mask cache and an optional boxed
Swash ScaleContext, allocated only on its first nonempty requested outline.
The context caches at most one face entry and uses a stable per-face CacheKey.
`clear_cache` also releases its scaler scratch. Existing scene Arc leases remain
valid. Measurement/ink bounds do not create the scaler. The header sizes on
x86_64 are FontFace 8, TextSystem 72, FontData 40, RasterMetrics 24 (formerly
Fontdue Metrics 64). The registry is 16 bytes plus the 8-byte ID counter.
After final strong release, the registry retains one expired weak allocation:
40-byte data header plus two usize atomic counts, 56 bytes before allocator slack.
No permanent strong font, TLS, per-glyph shared lock, or eager geometry remains.

A Skrifa control-hull pen preflights only the requested outline: finite bounded
coordinates, admission of at most 65,536 emitted segments, at most 1 MiB backend outline scratch and
at most 1 MiB estimated mask. A Bezier lies within its control hull; floor/ceil
plus a one-pixel margin protects raster placement. Actual returned mask length
and the 8 MiB cache cap are checked independently. Bounds can be loose, so an
unusually curved outline can be rejected conservatively. This is a resource
admission policy, not a claim that untrusted font parsing is allocation-free.
The segment count is checked after outline traversal; it limits accepted work,
not the number of callbacks executed before returning an error.

The narrow production path adapts the outline/alpha/placement glue already used
by the repository's `crates/gpui_ce_parley/src/store.rs` SwashGlyphRasterizer.
It uses the default variation instance and unhinted grayscale outlines. Fontdue
is now a dev-only quality oracle. AA output intentionally changes: 84 masks over
Latin, Greek, Cyrillic, accents, descenders and physical scales 1/1.25/2 preserve
all tested dimensions/placements, while 4,779 of 18,333 coverage bytes differ;
RMS error versus Fontdue is 1.5101 on the 0–255 scale (maximum difference17).
The regression cap is four RMS levels, with exact per-paragraph glyph counts. A fresh independent Swash
context supplies native-mask and transformed-cell exact renderer oracles.
This is neither universal font parity nor a visual quality proof for every font.
Color/bitmap/SVG font formats are rejected explicitly instead of silently
emitting empty masks. No fallback, variation authoring, LCD or hinted-text
support is added by this change.

Fresh-process release component observations (Ryzen 7 3700X, rustc 1.97.1,
Linux x86_64, one run per count), reproduced by
`cargo run --release -p gpui_canvas --example font_memory -- 1` (also 2 and 8):

| Services | Cold admission | Retained admission heap | Shape | First masks + command preparation | First direct BGRX frame |
| --- | --- | --- | --- | --- | --- |
| 1 | 84.8 µs | 56 B / 1 allocation | 299.8 µs | 113.2 µs | 828.8 µs |
| 2 | 81.4 µs | 56 B / 1 allocation | 265.9 µs | 110.8 µs | 826.2 µs |
| 8 | 83.1 µs | 56 B / 1 allocation | 260.1 µs | 108.2 µs | 828.3 µs |

The actual shaped text is “office café AVATAR” at 16px, one label on a white
640×480 scene. Unique mask payload is 1,207 B; preparation retains 8,767 B
including scaler scratch, mask/table/control blocks and commands, with an
11,263 B peak increment. Shape retains 256 B of positions. Render adds 19,400 B
of reusable bin storage, with the caller's 1,228,800 B BGRX output allocated
outside that phase. Service Vec storage is also allocated before admission;
charge 72×count bytes plus its Vec header when comparing full ownership.
The phase ledger's negative clear/drop counts include allocations from earlier
phases; they are not leaks. A cache clear releases 4,328 requested bytes here,
while scenes continue leasing masks. See [raw phases](evidence-font-lazy.csv).

The same executable's Fontdue 0.9.4 cold parse takes 24.42 ms and retains
12,519,432 requested heap bytes in 170,881 allocations; its transient peak varies
with hash seeding. This measures requested allocator bytes, not resident pages.
The previous shared-Fontdue implementation already avoided duplicate parsed
copies across services; the new path removes its first-face geometry floor.
Native CPU-reference observations before this change showed empty/Todo anon
1,492/14,376 KiB (`gpui/evidence-native-memory-cpu.csv`); that process delta agrees
with an eager font cost but is not exact causal heap attribution. Whole-process
startup, OS first-present, RSS/PSS, and the CPU-first/GPU-upgrade path require
separate native measurements. No sub-50ms application claim follows from these
component results. Earlier canvas CSVs below use the Fontdue baseline and are
historical rendering experiments, not newly measured Swash frame distributions.

## Exact opaque sRGB quantization

Opaque clipped sRGB output uses an exact byte quantizer in place of three
per-pixel power functions. The final linear channels are f32. Their ordered
positive IEEE bit patterns select a seven-mantissa-bit bucket and compare one
byte boundary. All buckets cross at most one boundary; initialization checks
that invariant. The 3 KiB static table is derived from this build's existing f64
transfer/rounding implementation, rather than an approximate gamma fit. It
allocates no heap. A raster pass selects its encoder once, keeping lazy table
initialization and the general converter's stack out of the pixel loop.
Translucent output, P3 output and tone mapping retain the general conversion.

The exhaustive release test compares all **107,011,406** f32 values from just
below the first nonzero threshold through one. Below that threshold the result
is zero; values outside [0,1] are clipped. Normal tests check every quantization
threshold and bucket boundary. Reproduce the exhaustive check and isolated
conversion timing with:

```sh
cargo test -p gpui_canvas --release every_in_range_float_matches -- --ignored
cargo test -p gpui_canvas --release opaque_quantizer_microbenchmark -- --ignored --nocapture
```

[Paired renderer measurements](evidence-color.csv) retain the reference run,
the table experiment and the final encoder split, under the same protocol as
the baseline above. The 48-label scene decreased from 29–31 ms to 14–16 ms;
sheared rectangles decreased from about 7.3 ms to 3.0–3.2 ms. These are shared
host CPU runs, without display submission, rather than latency guarantees.
Small boundary-heavy scenes and geometry sampling remain costs. Assembly
inspection confirmed table loads/comparisons on the opaque path; power/round
library calls remain in initialization and the general converter. This changes
conversion work, not sampling quality, color profiles or the output byte contract.

## Borrowed canonical scene

`Canvas::prepared_scene()` exposes painter-ordered draws without rasterizing,
allocating, or cloning mask handles. Each draw carries the same local rectangle,
f64 inverse mapping, world clip, conservative clipped device bounds, and
premultiplied extended-linear-sRGB color used by the CPU. Glyph masks borrow
immutable coverage bytes and carry a process-local `GlyphKey`; a key remains
stable across cache eviction and services sharing one `FontFace`. Distinct font
faces have distinct keys, including independently parsed equal font bytes.

A backend must upload while the scene is borrowed or explicitly retain its own
resource lease. The view does not provide a GPU fence or extend a mask lifetime.
Narrowing the inverse to f32 requires backend-specific precision validation;
the CPU's f64 coverage certificates do not certify a different shader domain.
The retained command remains 136 bytes on x86_64; this export adds no forward
matrix or resource clone per glyph. CPU tile bins are disposable derived data.

`Canvas::recording(width, height, config)` retains no CPU image. Native rendering
can consume the prepared scene directly. The first `try_pixels()` allocates the
sole output image and reports allocation failure; later scene commits reuse it.
`output_bytes()` exposes retained image capacity. `new` and `with_color_config`
keep their eager allocation behavior. The infallible `pixels()` convenience
panics on allocation failure; fallible hosts should use `try_pixels()`.

## Optional disjoint-band CPU rendering

Enable `parallel` and construct an owned `RenderPool::new(workers)` (1–64).
`try_pixels_with(&pool)` has the same fallible image-allocation contract as
`try_pixels`; `pixels_with` is the convenience wrapper. The default feature set
has no active Rayon dependency, worker thread, or pool allocation. No global
pool is initialized. A pool can serve successive canvases; a frame returns only
after its borrowed output work completes.

The same generic raster kernel serves serial rendering and parallel 16-row
bands. Each job borrows the immutable commands, CSR bins, and immutable mask
pointees, and owns a disjoint mutable output slice. No scene/resource cloning,
mutable font service, per-pixel atomics, or dynamic pixel callback enters that
kernel. Band counters reduce after completion. Output format dispatch is outside
the kernel. The pool uses pinned [Rayon 1.12.0](https://docs.rs/rayon/1.12.0/rayon/struct.ThreadPoolBuilder.html)
and its [nonoverlapping mutable slice chunks](https://docs.rs/rayon/1.12.0/rayon/slice/trait.ParallelSliceMut.html).
This does not prove Rayon's executor lock-free or allocation-free.

The default scheduling threshold is 65,536 estimated units: one per output pixel
plus conservative 16-sample command-bound area; a rectangle certified to fill
the complete viewport contributes only its tile area. This estimate affects
scheduling only. Heights up to 16 remain serial. `with_min_work(0)` forces the
parallel comparison for taller images. Small work should remain serial: in the
[measured run](evidence-parallel.csv), a 4×32 boundary scene took 18.0 µs serial
and 22.2 µs with eight workers. Pools with one worker likewise add overhead.
On the same shared Ryzen 7 3700X, a 640×480 scene of 48 shaped labels took
15.87 ms serial, 8.13 ms with two workers, 4.31 ms with four, and 2.52 ms with
eight. A 1920×1080 flat panel took 1.69 ms serial and 0.36 ms with eight.
These medians include command preparation, bin construction, and rasterization,
but exclude font/pool creation and presentation. Seven warm batches were used;
CSV rows retain exact equal frame digests and allocation-capacity ledgers.
Shared-host CPU timings are evidence for this workload, not latency guarantees.

Reproduce with `cargo run --release -p gpui_canvas --features parallel --example
parallel`. Public tests compare every byte of serial/parallel output with
1/2/4/8 workers, both profiles, both SDR mappings, alpha, fractional clipping,
shear/reflection, text, partial bands, width one, and both proof paths. Existing
independent exhaustive geometry and glyph-mask oracles also pass after the
kernel refactor. Clean output access remains zero raster work.

Each active band uses one 64 KiB stack sample tile; at most one such tile is
active per pool worker. This replaces the serial tile rather than retaining a
second image. The pool requests 512 KiB stack reservation per worker, including
that tile. Pool metadata, TLS, allocator arenas and OS guard/rounding costs are
additional. The ignored `pool_memory_measurement` test prints process RSS/VMS
and thread counts in separate processes (`GPUI_RENDER_WORKERS=1,2,4,8`). On this
host, initialization was 41/60/190/317 µs, with RSS increments 80/156/152/240 KiB.
After a 640×480 frame, total RSS increments were 1712/1800/1916/2276 KiB,
including the sole 1200 KiB image and touched worker scratch. Linux/glibc arenas
reserved roughly 65 MiB virtual address space per worker in addition to the
requested stacks. Dropping the pool signals shutdown; measurements show threads
and mappings can still exist immediately after drop. RSS/VMS are not exact heap
attribution, and allocator retention prevents immediate OS-reclamation claims.

## Safe compiler SIMD evidence

The release `render_band<OutputEncoder>` assembly contains packed four-channel
SSE `mulps`/`addps` for source-over. Sample means accumulate in f64 and narrow
once, preserving identical clear samples exactly. Rust/LLVM emits this
from ordinary safe array loops; baseline x86_64 SSE requires no runtime feature
probe or unsafe vector loads. This is four color channels, not four independent
coverage tests. The fixed scalar sample positions and arithmetic order remain
the reference contract.

A paired whole-build experiment disabled LLVM SLP and loop vectorizers with
`RUSTFLAGS='-Cllvm-args=-vectorize-slp=false -Cllvm-args=-vectorize-loops=false'`
in a separate target directory. All frame digests matched. The
[non-vectorized run](evidence-no-vectorize.csv) took 20.64 ms for serial labels,
4.75 ms for serial shear, and 0.272 ms for the flat scene; the ordinary build
above took 15.87/3.22/0.197 ms. These flags affect the whole build, so the timing
difference is not attributed solely to the blend instructions. There is no new
unsafe intrinsic implementation, AVX2 claim, or changed sampling quality.


`Color::oklch` and the free `oklch` helper preserve perceptual authored
coordinates; default neutral constants use Oklch. Composition remains in extended
linear sRGB. RGB byte constructors stay const and compatible. Actual RGBA16Float
can be selected with `ColorConfig::linear_hdr(profile, reference_white_nits)`.
Both serial and parallel raster schedules instantiate the same eight-byte writer;
`pixels`/`try_pixels` return the selected format, and output capacity is 8×width×height
instead of 4×width×height. There is still one optional image, no full-frame f32
intermediate, and one 64 KiB sample tile per active worker. Staged commits reuse
the selected-format output allocation. The supplied metadata describes linear
premultiplication, D65 primaries, reference white, and final IEEE-binary16 finite
saturation; those bytes alone do not enable an HDR monitor or OS surface.

The [actual linear16F measurement](evidence-hdr-parallel.csv) uses
`GPUI_RENDER_HDR=1` with the parallel example: the 640×480 shaped-label scene
retains a 2,457,600-byte output and took 19.93 ms serial, 10.15/5.47/3.41 ms
with 2/4/8 workers. The eight-byte converter is more expensive than the exact
opaque-sRGB byte quantizer; HDR is an explicit format choice with measurable
cost. Digests agree across all worker counts. This scene contains ordinary SDR
labels; separate actual-byte tests exercise >1 highlights, negative channels,
alpha, cancellation before final storage saturation, and real font coverage.


A zero-coverage command must preserve the image. Sample means therefore sum
sixteen f32 working colors in f64 and narrow once; sixteen identical f32 values
fit exactly within f64's significand. The former repeated f32 accumulation could
shift a constant tile by one ulp and cross an exact RGBA8 quantization threshold,
while an untouched tile encoded the original clear. A public regression uses
that threshold with both output formats, proof modes and opaque/translucent
clear colors. Per-sample source-over and the coverage sample positions are
unchanged. The paired vectorization CSVs above were rerun after this correction.

## Write each output pixel once

The band kernel now writes empty tiles directly from a cached clear pixel,
uniform tiles from one encoded summary, and boundary tiles from their sample
mean. This removes the preceding whole-band clear pass and its redundant writes
under all nonempty tiles. A uniform summary is already its exact sample mean,
so it also needs no sixteen-value reduction. The single fixed sample array
remains; no branch-heavy optional-array representation is required.

[Paired runs](evidence-single-write.csv) compare binaries from the preceding
`ed876fe8e0` implementation and this kernel, alternating twice on the same host.
All digests and sample/work counts agree. Serial 640×360 flat scenes decreased
from 195.5–195.7 µs to 175.2–176.0 µs; 1920×1080 flat scenes decreased from
1.687–1.695 ms to 1.485–1.487 ms. Label scenes remained approximately 15.6–15.8 ms;
this removes output writes rather than their dominant glyph sampling. Existing
independent geometry/mask/alpha oracles and both-format parallel byte comparisons
pass. Retained allocation capacities do not increase.

## Device-resolution text without layout inflation

`draw_text_scaled(..., raster_scale)` keeps shaped positions in logical units,
requests glyph masks at `layout.font_size() * raster_scale`, and expresses raster
bearings/extents back in logical units. The window's device transform still maps
that logical geometry to pixels. This produces real physical-resolution outlines;
it does not enlarge an existing bitmap. The physical font size must be finite,
positive and at most 4096 px; the existing 1 MiB per-mask cap still applies.
Invalid density/product is rejected before rasterization, including empty runs.

A glyph mask's coverage cells uniformly span its `PreparedDraw::local_rect`.
Its pixel dimensions can therefore differ from logical dimensions. CPU and GPU
consumers must test the half-open local rectangle before normalized texel lookup,
then clamp roundoff of an admitted interior point to the last valid texel. At
scale one the dimension ratio is exactly one. No scale field or forward matrix
is added per command, and physical size remains part of the stable glyph key.

Public tests compare 2× logical text byte-for-byte with a direct 32 px physical
font, verify it differs from magnifying a 16 px mask, preserve 1× pixels, exercise
fractional-density keys and reject invalid requests atomically. An additional
private edge oracle covers exact and adjacent floating local edges across seven
densities. Native DPI integration and GPU precision validation are separate host
responsibilities; the canvas supplies the same borrowed scene contract.

## Direct native CPU output

`render_bgrx(&mut [u32])` renders directly into a host-owned mapped buffer of
exactly width×height words. Each word is `0x00RRGGBB` (B,G,R,0 bytes on
little-endian hosts). It creates no canvas RGBA image and uses no byte casts or
unsafe code. `render_bgrx_with(destination, &pool)` uses the same optional owned
executor with disjoint mutable word bands. The private pixel writer is generic
over byte or word elements; format dispatch stays outside the pixel kernel.

This output requires sRGB/RGBA8 configuration and an opaque clear color.
Unsupported profile, float format, alpha or dimensions return typed errors before
writing any destination or changing render statistics. Authored P3/Oklch colors
still convert through the normal working pipeline. The host owns output lifetime,
resize, synchronization and the actual presentation acknowledgement.

Each call renders the supplied buffer, including a new swap buffer when the scene
is unchanged. It does not claim an external-buffer identity cache. The optional
internal image keeps its dirty state: a later `pixels()` diagnostic is coherent,
and an already-current internal image stays current. Public tests verify packed
word equality against RGBA for alpha/text/affine/clip/SDR mappings, staged commits,
new destinations, internal cache reuse, rejected output immutability, and exact
1/2/4/8-worker word rendering with zero internal output capacity. This seam lets a
native software presenter avoid loading a GPU backend and avoid a second canvas
image; actual process/driver memory savings require host measurements.

## Production retained text runs

The Canvas now owns one typed display list, consumed directly by both CPU raster
and PreparedScene. It does not freeze or copy another packet on each paint.
Each admitted text call with two or more visible glyphs stores its inverse,
clip and premultiplied paint once (80 bytes), plus an 8-byte painter range.
Each placement is 32 bytes: local Rect16, four checked u16 device bounds8,
common index4 and mask index4. The u16 bounds cover the admitted 16,384-pixel
canvas dimensions. The painter lane stores one private u32 address per draw.
Rectangles and visible singleton glyphs use an inline form: 104-byte
common+geometry record plus a separate 4-byte source lane, avoiding a separate
run descriptor. These widths are measured x86_64 layouts, not serialized ABI.

Masks have one Arc lease per complete stable GlyphKey in the scene. Preparation
looks up that key before requesting a font-cache raster: repeated placements
perform no Arc increments/decrements. The primary face is factored out of its
resource index, leaving a lossless 48-bit glyph+physical-size key in u64. Other
faces use complete keys. There is no truncated hash identity, pointer address,
or approximate equality; final font owner release/remint remains foreign-safe.
Preparation stages only 28-byte geometry+source entries, not expanded 136-byte
commands, and computes the common inverse/color conversion once per run.

All limits and fallible lane reservations precede publication. Failure may
grow capacity or populate the independent bounded text cache; it cannot append
partial draws/resources. Once admitted, appending touches primitive indices
and moved Arc leases with no user callbacks. Private address tags stay below
the checked draw limit; borrowed views cannot outlive/mutate the Canvas.
`clear` retains lane capacity for warm use; replacing a staged scene drops the
old lanes and leases. A rejected/dropped stage preserves the old scene/image.

The existing `scene.draws()` remains an exact-size double-ended flattened view.
`scene.groups()` adds an exact-size double-ended common-state view, whose
`placements()` exposes only local geometry, device bounds and mask borrow.
`scene.masks()` traverses unique leases. A backend can upload common state once
per group, rather than reconstructing per-glyph matrix/paint records. Existing
The GPU now consumes grouped views directly; its packet/storage measurements are
reported in [the GPU crate](../gpu/README.md). The `scene.storage()` ledger reports
exact Vec capacity bytes and resource-index entry/capacity counts, deliberately
not an invented byte size for opaque HashMap bucket/control allocation.

Three fresh-process alternating release pairs, same source and font/cache warm
fixture compiled against pre-change `99b788db26` and this implementation:

| Scene | Expanded / retained requested heap B | Expanded / retained preparation | Expanded / retained flat traversal |
| --- | --- | --- | --- |
| 48 labels, 672 visible glyphs | 122,016 / 38,264 | 173.8 / 62.9 µs | 0.678 / 1.016 µs |
| 1,000×32 glyph runs | 4,456,500 / 1,269,876 | 9.234 / 3.056 ms | 45.8 / 50.5 µs |
| 32,000 singleton runs, one mask | 4,456,500 / 3,670,132 | 11.248 / 8.018 ms | 44.9 / 60.9 µs |
| 32,000 distinct physical mask sizes | 12,477,848 / 12,477,848 | 92.267 / 90.136 ms | 71.7 / 88.4 µs |

These counters charge all newly retained lanes/hash tables, new mask/raster/cache
allocations and allocator-requested control blocks. They exclude preexisting
shared font bytes, the layout and warm masks, and no output image is allocated.
Add the Canvas header: 336 bytes before, 544 after. Thus the unique-mask case is
heap-neutral but loses 208 bytes in full ownership, and more allocations are
performed in these fixtures. Full totals for the first two cases including that
header are 122,352→38,808 and 4,456,836→1,270,420 bytes. Shared bundle bytes are
2,049,096 once, not per scene; TextSystem72, FontFace8 and FontData40 plus Arc
counts are unchanged. Unique-size preparation retains roughly 1 MB in the text
cache after dropping the scene, equally in both implementations; the negative
drop column records this ownership split. See [all raw pairs](evidence-retained-runs.csv).
Peak new requested heap for the 32-glyph-run case falls 6,689,076→1,795,060 B.

For that case the exact typed-lane capacities are painter131,072 +
common/range90,112 + placements1,048,576 + resource handles32 = 1,269,792 B.
The remaining84 B is the measured standard HashMap allocation in this build;
it is not a stable library ABI. Display-list header280 is already inside
Canvas544, not an additional allocation. `group_views` compares flat/grouped
iteration over the same data; one run took47.5/63.0 µs for32k draws. Grouping
therefore does not promise faster CPU traversal. Its backend advantage is the
shared common state and fewer retained resource leases. The GPU integration
reduces packet bytes with neutral/slightly slower measured frame times.

The complete CPU compositor was also tested in three alternating process pairs
([frame CSV](evidence-retained-frames.csv)). Text remains essentially neutral:
48-label warm frame median16.45→16.34 ms. Flat167→173 µs and boundary-dense
4.93→5.27 µs lose modestly. Full640×480 label PPM output matches byte-for-byte
(SHA256 `cae70aa4df17d20ff27eae66a81bddf8cf987762383c302cf0cb7fe4242ecd07`).
This is a memory/preparation improvement with measured traversal losses, not a
universal rendering speedup. No process-RSS or native-startup saving is inferred.

Reproduce with `--example retained_runs -- labels|groups|singletons|unique`,
`--example group_views`, and the existing `--example cpu`. Allocation counters
measure the owner thread, not driver allocation or Rayon workers. Independent
review additionally compared old/new prepared snapshots, reverse traversal and
exact pixels on24 fixtures covering four DPI scales, mixed order, rotations,
clips, eviction, abandoned stages, serial and two-worker output. Public tests
check whole group counts/order in both directions, full-key multi-face identity,
one leased resource across cache clears/services, and failed-stage isolation.

`scene.solid_bgrx()` certifies only zero-command, opaque, sRGB/RGBA8 scenes and
returns exactly the packed0x00RRGGBB result of the normal encoder. It allocates
no image/bins and runs no raster work; unsupported scenes return None. Public
scene metadata edits still pass finite/range/configuration validation. This is
an optional native solid-fill content certificate, not an OS submission or a
presentation acknowledgment. Native hosts must submit successfully before
advancing their presentation token, and use ordinary rendering otherwise.
