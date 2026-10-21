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

The Vulkan regressions exercise neighboring representable widths, reflection,
overlapping alpha edges, physical glyph scales 1/1.25/1.5/2, threshold clear
colors and premultiplied float output. They run on Mesa llvmpipe Vulkan here;
other backends require their own validation.

Portable `cargo test -p gpui_gpu` validates generated WGSL and CPU packing. Run
`cargo test -p gpui_gpu --features vulkan-tests --test render` for actual Vulkan
conformance; this command requires an adapter and never silently skips tests.

## Storage and output

Draw records remain 96 bytes. One 32-byte zero correction is shared by exactly
representable inverses; other residual tuples are deduplicated by complete bit
equality in a reused host hash table. Each distinct tuple costs another 32 bytes
on the host and GPU, plus one host hash entry (24-byte key and 4-byte index,
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
The current native host presents a tagged SDR surface; this float target API
does not imply native HDR swapchain negotiation or display support.

The general path still evaluates sixteen samples per pixel and every retained
tile reference. This crate currently claims correctness improvements, not a
completed opaque-tile/occlusion optimization or discrete-GPU performance result.
