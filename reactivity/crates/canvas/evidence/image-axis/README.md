Exact axis image sampling
=========================

Implementation: `7be2c331854597eaa4a53753e3b9c9cac86ded5f`, based on
`724ece73cb665a1f6d83e97ae7d431eee11a887a`. This changes the serial CPU
raster kernel; it adds no public API, owner fields, retained decoded images,
resource clones, GPU bindings or GPU sampling policy.

Each axis computes the existing clip/domain/normalization/floor/clamp sequence
at its 64 sample positions once per 16×16 tile. The 1,536-byte tap buffer holds
exact integer neighbors and f32 fractions. A column retains two horizontal
filter rows (136 bytes plus 48 bytes of column taps); a full source-row key
proves each hit. Bilinear neighbors are adjacent or clamped identical, so their
parity slots cannot conflict. Reflections work in either scan direction. Every
vertical interpolation still executes at each of the original sixteen sample
positions, followed by the existing per-sample source-over and sample mean.
Pixel visitation changes from row-major to column-major; command order at each
pixel is unchanged. Nearest sampling bypasses interpolation.

No ratio reassociation, early averaging, endpoint bypass, decoded image mirror,
or approximate transform equality is used. Dropping a zero cross term can only
change a zero sign: the nonnegative domain/cell test is unchanged, and the
subsequent half-texel subtraction produces identical filter fractions. The
per-sample oracle includes all four off-diagonal signed-zero combinations,
reflections, near-lattice clips, subnormal HDR channels, negative zero, huge
local origins and a collapsed forward interval. Generic shear/rotation keeps
the scalar inverse path. Both paths use the same color decoder and the original
f32 multiply/add interpolation order. LLVM already vectorized the four color
channels in the baseline; this patch saves repeated work rather than claiming
new SIMD width.

Memory and linked code
----------------------

No `Canvas`, resource, runtime, node or presented header changes. Full-frame
controls assert identical retained/peak requested bytes and zero warm raster
allocations. The image-free control performs no image-helper calls or scratch
initialization. Actual linked x86-64 `render_output<Serial>` reserves 73,208
baseline versus 73,192 candidate local bytes, excluding 48 bytes of register
pushes. The new direct/memoized axis helpers reserve 2,264/2,328 local bytes;
`Axes::fill` reserves another 248 during preparation. The existing memo wrapper
reserves 6,232→6,264 bytes, only for encoded-premultiplied/P3 inputs. These are
stack-frame sizes, not new persistent state. Straight sRGB and HDR still avoid
the 6KiB decoder memo.

The final tap initializer is one 1,536-byte `memset` in the image-only helper.
An intermediate by-value constructor added a redundant 3,240-byte callee frame;
a repeated-record initializer also caused staging and large unrolled code.
Both were rejected before timed capture. The outside tap's unread fraction has
all-one bits so the final fixed buffer initializes directly. Valid fractions
remain ordinary finite values. No unsafe/uninitialized memory is used.

Timing protocol and limits
--------------------------

`image_axis` builds byte-identical harness sources in separate fresh target
directories. `capture.py` verifies executable SHA256, absence/presence of the
linked axis symbol, exact whole-frame output digests, warm allocation counts,
retained/peak bytes, and expected query-counter activation. Five alternating
fresh-process pairs run pinned to CPU 2. Each process retains all nine frames;
frames 0/1 are cold/warmup and frames 2–8 contribute 35 warm samples per
variant/case. Tail estimates from 35 samples are limited; p99 is the maximum,
not a production service tail guarantee. Raw cold rows and paired losses stay
in `raw.csv`. These are CPU full-raster measurements, not GPU timestamp or
whole-application latency claims. The unchanged GPU is a conformance oracle.

The controls cover a 128² image enlarged to roughly 256²; 48 shared/unique
minified images; both straight and premultiplied encoded input; sRGB/P3 and
linear HDR; nearest/linear; reflection; unchanged shear; tiny setup work and
image-free solid rendering. Payloads stay packed 4B/texel or explicit 16B/HDR.
No whole-frame decoded cache is admitted to make the measurements faster.

Validation
----------

The debug/release sample-bit and overlap oracles pass. The bounded-work fixture
uses 128 geometric queries for a full tile versus 4,096 generic queries; for a
2×2-to-32×32 fixture, bilinear texel callback calls fall from 16,384 to 256
(nearest 4,096→64), without allocating. This is a structural oracle, not an
application performance estimate.

Public Canvas image tests include independent solid/texel oracles and exact
1/2/4-worker output. Public GPUI borrowed image tests pass. All 23 actual Vulkan
render tests pass with the existing SDR ≤1-byte/channel and documented relative
HDR tolerance; this does not establish universal CPU/GPU byte parity. The real
X11 native image script passes pointer resource replacement, actual ack, resize,
suspend/resume and complete `surface.fetch` versus owner pixels. The final
native command uses the pinned Xvfb on a private display; the first attempt
failed before application rendering because `Xvfb` was absent from PATH. A
preflight assertion was also corrected to exclude cold bin allocations from
the zero-*warm*-allocation assertion. Neither failed attempt produced accepted
timing rows.

Measured warm full-raster controls (milliseconds)
-----------------------------------------------

| Control | Baseline p50 | Axis p50 | Median paired change |
| --- | ---: | ---: | ---: |
| flat | 0.0667 | 0.0722 | +7.61% |
| one | 46.3514 | 6.4059 | -86.23% |
| shared48 | 70.0153 | 23.8417 | -65.78% |
| unique48 | 69.7868 | 23.8274 | -66.06% |
| p3 | 33.8532 | 7.3218 | -78.35% |
| premul | 33.6943 | 7.3862 | -78.05% |
| hdr | 31.9053 | 5.1047 | -83.86% |
| nearest | 19.7682 | 3.3062 | -83.36% |
| shear | 36.1280 | 37.6324 | +3.99% |
| reflected | 34.4113 | 5.2928 | -84.64% |
| tiny | 0.0612 | 0.0590 | -3.36% |
| p3-48 | 173.5551 | 138.4951 | -20.23% |
| premul-48 | 162.7598 | 139.9902 | -14.16% |
| hdr-48 | 47.1843 | 14.8995 | -68.47% |

All 1,260 frame rows and 980 warm samples pass the guards. The enlarged
straight-sRGB image improves about 7.2×; the 48-image sRGB controls improve
about 2.9×. P3/premultiplied minification improves only 20.2%/14.2% because
texel color conversion remains substantial. These losing ratios versus the
straight-sRGB wins remain part of the result. The unchanged generic shear
control is 4.0% slower at the paired median, with pair changes spanning
−3.1%..+12.3%. The image-free solid control is consistently slower across
all five pairs (+4.7%..+8.5%, median +7.6%, approximately 5.5µs). Neither
loss is dismissed as noise or hidden by the unchanged allocation/stack floor.
This is an explicit speed tradeoff for the large image workloads, not a
universal renderer improvement. The tiny image control improves 3.4%.

The linked benchmark grows by 12,272 aggregate text/data/bss bytes (see
`codegen.json`); the source has no new static cache or retained field. This is
real code/data cost despite the unchanged per-owner and per-resource headers.
Construction retained/peak figures exclude the identical caller output and
oracle buffers; they include source payloads and canonical scene storage.
There is no full-app input/latency or GPU-throughput claim in these rows.

Read-only localization of the solid-render regression
---------------------------------------------------

On the pinned flat control, `full && uniform.is_some()` continues before the
existing image match, so no axis test, image helper, decoder memo or tap memset
executes. The `full_tile` helper remains 0x638 bytes. The linked containing
`render_output<Serial>` grows 0x6744→0x6a14 bytes (+720 across its three output
format loops), with changed register/spill choices and branch positions. For
example, a hot loop end-pointer spill changes from rsp+0x78 to rsp+0xb0. These
are concrete common-body codegen changes; they do not prove a particular
microarchitectural cause for the measured loss. A separate follow-up may move
all image-only dispatch behind one outlined call. None of that prospective
code or timing is included in this frozen 7be2 dataset.
