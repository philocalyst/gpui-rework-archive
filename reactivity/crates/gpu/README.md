# GPU compositor

The renderer borrows the canonical prepared canvas scene. It uploads geometry,
tile references and missing glyph masks, then composites the same 4×4 sample
lattice in linear light. Submission never requests a CPU output image.

## Spatial precision

The GPU does not promise universal CPU byte parity. Canonical inverses are f64;
WGSL arithmetic is f32 and its backend arithmetic rules differ from Rust f64.
Admission rejects inverses whose conservative coefficient/arithmetic estimate
maps to more than **1/32 device pixel**. This is a spatial admission ceiling,
not permission to change sample membership: even a much smaller displacement
can cross a half-open edge or an integer glyph texel boundary.

Each draw carries a local uncertainty envelope. Samples within that envelope
use split inverse coefficients and two-float products/sums, retaining the low
lane separately through comparisons. Glyph coordinates are normalized from the
logical rectangle to physical mask dimensions; near integer texel boundaries
the division and floor also retain the low lane. This fixes the tested 1/3
inverse boundary without requiring hardware f64. It remains finite shader
arithmetic; no portable exact-predicate theorem or all-backend parity claim is
made. Nonfinite coefficients, excessive intermediate magnitudes and overflowing
mask-coordinate scales are rejected with `Error::Precision`.

Clips retain their authored start and extent. Only a sample equal to the rounded
clip endpoint loads the host-computed endpoint residual, preserving the CPU's
half-open comparison against the f64 sum. These two residuals use the spare
lanes of the existing correction record; draw and correction strides do not grow.

The Vulkan regressions exercise neighboring representable widths, reflection,
overlapping alpha edges, physical glyph scales 1/1.25/1.5/2, threshold clear
colors and premultiplied float output. They run on Mesa llvmpipe Vulkan here;
other backends require their own validation.

Portable `cargo test -p gpui_gpu` validates generated WGSL and CPU packing. Run
`cargo test -p gpui_gpu --features vulkan-tests --test render` for actual Vulkan
conformance; this command requires an adapter and never silently skips tests.

## Storage and output

Draw records remain 96 bytes. One 32-byte zero correction is shared by exactly
representable inverses and clip endpoints; other residual tuples are deduplicated by complete bit
equality in a reused host hash table. Each distinct tuple costs another 32 bytes
on the host and GPU, plus one host hash entry (32-byte key and 4-byte index,
plus table overhead). The worst case is one tuple per draw. Buffer capacities
grow geometrically and remain retained. `Stats` reports upload bytes, allocated
GPU buffer bytes, host vector capacity bytes and correction hash entry capacity;
the last is not an allocator-byte total. Glyph atlas/table overhead and wgpu's
internal allocations are separate. No low-lane allocation occurs per sample.

Constant sample colors use anchor-plus-delta averaging so adding a draw covering
zero samples preserves the clear value. Float output stays premultiplied through
profile conversion and storage, avoiding an unnecessary divide/multiply by
alpha. SDR Reinhard evaluation clamps overflow defensively before division;
the canonical color configuration's exposure admission still applies.
An HDR float render target is independent of native surface color management.
Scene `ColorConfig::format` must match the target's SDR or float storage class;
the renderer rejects mismatches rather than silently overriding scene metadata.
The current native host presents a tagged SDR surface; this float target API
does not imply native HDR swapchain negotiation or display support.

## Opaque tile proofs

The existing eight-byte tile header has two forms: `[start, end]` indexes the
sampled CSR, and `[draw_index, 1<<31]` selects one certified final opaque color.
Empty ranges select clear. No per-tile allocation was added. The existing
four-byte-per-tile cursor scratch holds each tile's cutoff while reverse scene
traversal fills the compact CSR in painter order. All canonical and uploaded
draw records remain retained; each frame rebuilds the disposable proof, so
changing alpha, clip or material restores any newly visible background.

A certificate requires a rectangle, alpha exactly one, and no negative-zero
channels (source-over can change a zero's sign according to the backdrop).
The continuous tile must fit in the clip. Four corners of the actual sample
hull, offset 1/8 pixel inside the tile, must independently satisfy:

* canonical f64 membership with an arithmetic guard;
* packed-high f32 membership with a conservative raw dot/origin/extent rounding
  margin **plus** the shader's local uncertainty envelope.

Affine convexity covers every intervening sample. The second check keeps every
rectangle sample outside the DD branch, so the proof does not assume that DD
and CPU f64 produce identical boundary decisions. Uncertain geometry falls
back. A tile's last certified opaque rectangle hides all preceding references;
every later draw remains. If none follow, the shader converts the final color
once per pixel and bypasses all sixteen samples. Bounds that overlap a tile
conservatively can prevent this last case even when their samples are empty.

`set_tile_proofs(false)` selects the general path for comparisons. `Stats`
distinguishes original references, uploaded sampled references, omitted
references, uniform tiles, planned lattice samples and planned `sample_draw`
calls. The last two count shader work, not hardware performance counters.

## Measured regimes

[tile-benchmark.csv](tile-benchmark.csv) records release-build Mesa 26.1.4
llvmpipe Vulkan on LLVM 21.1.8, 512×256 pixels. Each mode runs in a fresh process,
warms three frames, then records nine serialized frames. Wall time covers host
admission/packing/uploads/submission and completion polling. Host submit time
ends when `render` returns. Neither is a discrete-GPU timestamp measurement.
The text fixture uses the Fontdue canvas dependency at this branch's base;
font-backend changes require a new run.

| Case | Wall time, proofs off → on | Host submit time | Sample draw calls |
| --- | ---: | ---: | ---: |
| One opaque fill | 13.05 → 0.43 ms | 47 → 60 μs | 2,097,152 → 0 |
| 24 labels over fill | 22.84 → 20.56 ms | 105 → 118 μs | 6,045,696 → 5,459,968 |
| 32 opaque fills | 182.17 → 1.18 ms | 178 → 715 μs | 67,108,864 → 0 |
| Thin boundary stripes | 23.44 → 26.12 ms | 53 → 84 μs | 6,160,384 → 6,160,384 |

The boundary case loses: it removes no work or storage and adds proof cost.
The full-overlap case removes sampled work while retaining all 32 draw records.
Its explicit GPU buffer capacity falls from 73,808 to 8,276 bytes, and host
vector capacity from 74,880 to 9,344 bytes. For text, retained GPU buffers stay
45,136 bytes and the atlas stays 65,536 bytes; host vectors fall only 572 bytes.
The 524,288-byte render target remains in every case. Source canvas records,
source masks, driver allocations and hash-table overhead are additional; these
figures are not whole-application memory totals. CSV peak RSS is the actual
Linux process high-water mark, including pipeline compilation, fonts and the
software driver, rather than an attributed renderer allocator peak. In-flight
wgpu leases can also keep replaced resources alive beyond a frame. Atlas bytes
count texel payload; physical texture padding and driver overhead are opaque.

Reproduce after setting the Vulkan loader/ICD environment:

```sh
cargo build -p gpui_gpu --release --features vulkan-tests --example tiles
target/release/examples/tiles > tile-benchmark.csv
for case in flat text overlap32 boundary; do
  for proofs in false true; do
    target/release/examples/tiles "$case" "$proofs" >> tile-benchmark.csv
  done
done
```

The general path still evaluates sixteen samples per pixel and every retained
tile reference. Glyph sampling and translucent overlap remain sampled work.
