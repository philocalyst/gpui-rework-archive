# gpui_canvas

A real software text/canvas foundation independent of legacy GPUI. It shapes
OpenType glyph IDs/positions with pinned rustybuzz 0.20.1 and rasterizes those
same IDs with pinned fontdue 0.9.4. Full Noto Sans 2.015 and its OFL license are
bundled; `TextSystem::new` also accepts caller-supplied font bytes. Nothing reads
an absolute asset path. [Font provenance](assets/README.md).

`FontFace` shares immutable source bytes and parsed font geometry. Cloning a
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
[CSS Color 4 conversion formulas](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#color-conversion-code).
Conversion into extended linear sRGB happens per prepared command. All source-over
composition and sample averaging occur there before final output mapping.

`ColorConfig` declares sRGB or Display P3 output, RGBA8 premultiplied encoded
channels, and explicit clipping or per-channel Reinhard exposure mapping. Both
profiles use the sRGB transfer curve. Output mapping follows composition; no
source gamut clamp is permitted. P3 bytes require a tagged/negotiated host and
must not be passed to an sRGB-only display path as if equivalent. Clipping is a
simple declared SDR policy, not the perceptual CSS gamut mapper. Reinhard is
scene-relative and per-channel, not a hue-preserving HDR standard. Requested
RGBA16F is rejected; Rec.2020, PQ/HLG, arbitrary ICC/video conversion and HDR
surfaces remain unsupported, without silently interpreting them as sRGB.

Rectangles and font masks use a fixed 4×4 per-pixel sample grid, retaining each
sample through ordered composition. Averaging a primitive before composition
would incorrectly correlate overlapping edges and is explicitly tested. Fontdue
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

On the measured x86_64 target, a prepared command is 136 bytes before Vec slack.
CSR offsets and reusable fill cursors use two usize arrays per tile; references
use u32. Stats report actual command/bin Vec capacities, unique retained mask
payload, sample tests and skipped predecessor tiles. Glyph cache table/control,
Arc headers, mask-set buckets, fontdue compiled outline storage, font source
bytes, allocator slack and process/native-service overhead are separate costs;
payload counts are not RSS. Preparing glyph runs allocates bounded command and
mask-dedup scratch, and stores mask Arc leases per glyph command. There is no
claim of zero per-glyph overhead or zero allocation in text preparation. The
raster/compositor pixel loops allocate nothing; warm CSR buffers are reused.

## Validation and measured baseline

Run `cargo test -p gpui_canvas`, the same with `--release`, and
`cargo clippy -p gpui_canvas --all-targets -- -D warnings`.
Seventeen integration tests cover color conversions/roundtrips, negative extended
blending, declared P3 output, HDR rejection, alpha, correlated edges, randomized
forward-polygon versus inverse-raster scenes, ligatures and Unicode, native
fontdue pixel placement, transformed mask-cell sampling, UTF-8 wrapping,
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
[fontdue 0.9.4 indexed raster/metrics](https://docs.rs/fontdue/0.9.4/fontdue/struct.Font.html),
[Unicode script 0.5.8](https://docs.rs/unicode-script/0.5.8/unicode_script/).

## Shared parsed-font measurements and lifetime

Each FontFace is one Arc to immutable `{bytes, fontdue Font, checked ID}`.
The global bundled registry is a directly initialized `Mutex<Weak<FontData>>`;
there is no permanent strong font, global glyph cache or TLS. Cold parsing is
serialized so simultaneous initial callers share exactly one result. Shaping,
measurement and rasterization read the immutable face without taking this lock.
Only a fully parsed face is published. If initialization panics, the slot still
contains a valid Weak, so the next acquisition recovers the poisoned cache lock
and either upgrades or constructs a complete replacement.

On this x86_64 build, FontFace is 8 bytes and TextSystem is 64, versus the prior
280-byte per-service header. FontData's header is 224 bytes (including Fontdue's
192-byte header); its outline buffers are separate allocations. The registry
static is 16 bytes, plus the 8-byte ID counter. Before first use it has no heap
backing. After final strong release, only one expired weak allocation remains:
the 224-byte data header plus two usize atomic reference counts in the same
allocation (240 bytes in this standard-library layout, before allocator slack).
The source bytes are shared read-only static backing for the bundle; supplied
font bytes are owned by their face. The last face/service drop releases parsed
buffers and any owned source bytes. A later bundled acquisition reparses and
mints a fresh ID; an old unleased layout cannot accidentally rebind to it.

Fresh-process observations, Linux x86_64 / Ryzen 7 3700X / rustc 1.97.1 release,
no drawing or glyph-cache population, one run per count:

| Simultaneous services | Prior per-service font: before/live/after-drop RSS KiB | Shared face: before/live/after-drop RSS KiB | Shared initialization |
| --- | --- | --- | --- |
| 1 | 2924 / 17608 / 17196 | 3464 / 18552 / 18232 | 28.177 ms |
| 2 | 2988 / 30332 / 27116 | 3456 / 18468 / 18148 | 28.318 ms + 200 ns |
| 8 | 2892 / 106200 / 79120 | 3444 / 18524 / 18080 | 27.927 ms + seven acquisitions of 40–220 ns |

The baseline is the actual text.rs at `968af6cb88`, using the same borrowed static
font bytes and Fontdue settings, separately compiled with the same dependency
versions. Its individual parses cost 27.9–29.5 ms. Eight service drops cost
9.332 ms there versus 0.544 ms for the shared face. These are single observations,
not latency distributions. Nanosecond warm-call timings include clock overhead.
Different test binaries have different initial code/data residency; compare the
growth with service count, not their small one-font RSS difference.

Reproduce the shared measurement with a fresh process for each count:
`GPUI_FONT_SERVICES=8 cargo test --release -p gpui_canvas --test font_sharing live_services_measurement -- --ignored --exact --nocapture`.
Repeat with 1 and 2. Tests were run through a temporary isolated manifest over
the actual crate sources while the in-progress runtime workspace member lacked
its manifest; no production dependency or parent manifest was replaced.

Weak-expiry tests establish actual ownership release, while RSS remains high
after drop because the allocator retains freed pages and mapped font/code pages
remain resident. These measurements are not exact Fontdue heap attribution or
evidence that all memory returns to the OS. One font still has roughly a 15 MiB
cold RSS increment; sharing removes repeated parsed copies rather than solving
that initial cost. Demand initialization remains necessary. Per-service mutable
raster caches, retained command masks and their existing caps remain independent.
Public header sizes remain Color 20, Glyph 16 and TextLayout 48 bytes.

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
