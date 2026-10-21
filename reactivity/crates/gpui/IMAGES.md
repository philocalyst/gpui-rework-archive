# Immutable images

`Image` owns validated caller-provided pixels. `image(&asset)` borrows it during
`View::view`; description, Canvas and acknowledged presentation retain one lease
per distinct resource, rather than cloning a handle per image node. Construct
assets outside `view`. No decoder, I/O task, mutable pixel bag or ambient cache is
introduced by this API.

```rust
use gpui::{AlphaMode, Image, ImageProfile, prelude::*};
struct Cover(Image);
impl View for Cover {
    fn view(&self) -> El<'_> {
        image(&self.0).w(256).h(256).name("Album cover")
    }
}
let asset = Image::rgba8(1, 1, ImageProfile::Srgb, AlphaMode::Straight,
    vec![255, 40, 80, 255].into_boxed_slice()).unwrap();
```

Run the actual accessible desktop example from `reactivity`:

```
cargo run -p gpui --example covers --features x11 -- --cpu
cargo run -p gpui --example covers --features x11 -- --gpu
```

Use `wayland` for normal Linux Wayland, or `desktop` on macOS/Windows. These
normal profiles include native accessibility. `x11-minimal`/`wayland-minimal`
are explicitly AT-disabled diagnostic profiles. The example creates procedural
cover pixels; it does not pretend to implement PNG/JPEG loading or an image cache
service. Existing Readers can supply application-owned resources to a view.

## Pixel and sampling contract

- `Image::rgba8` consumes packed row-major RGBA8 with explicit `ImageProfile`
  (`Srgb` or `DisplayP3`) and `AlphaMode`. Both profiles use the sRGB transfer.
- `Image::linear_srgb` consumes scene-relative extended linear sRGB float pixels,
  with scene reference-white semantics. It canonicalizes straight input to
  premultiplied working pixels in place; original straight-channel bits are not
  retained. Finite RGB magnitude is at most `1e20`; alpha is in `[0,1]`.
- Alpha mode describes the supplied channel space. Encoded premultiplied RGB is
  unpremultiplied **before** transfer and primary conversion, then multiplied by
  alpha in working linear light. Encoded premultiplied bytes require RGB ≤ alpha.
  Premultiplied float alpha-zero input requires zero RGB. All alpha-zero samples
  contribute transparent black; straight RGBA8 may retain hidden source bytes.
- Default `ImageSampling::Linear` is bilinear reconstruction in premultiplied
  linear light, with texel centers and clamped edge taps. `.sampling(Nearest)`
  explicitly selects nearest reconstruction. Both retain the canvas's correlated
  4×4 geometry/compositing samples. This is not mipmapped/area minification.
- Layout supplies the image content rectangle. One known dimension preserves
  aspect; two known dimensions stretch it. Normal flex stretch also constrains
  dimensions. Unconstrained measurement starts from intrinsic pixel dimensions.
  Padding, transforms, viewport/list clips and ordinary source-over still apply.
- Hit testing uses the image element's geometry, including transparent texels;
  alpha is not a second hit map. Give meaningful images an explicit `.name`.
  Image names remain separate from text/input values and map to native Image role.

No color conversion happens by changing a resource's profile tag. Constructors
validate before publishing an identity. Each new resource has an exact private
monotonic identity, even when bytes are equal; caches never treat a hash or reused
address as proof that resources match.

## Admission, ownership and memory

Each resource admits nonzero sides ≤16384 and at most 4,194,304 pixels, with an
exact checked input length. `MAX_IMAGE_SCENE_BYTES` is 64 MiB of distinct payload
in one logical/canonical scene. Repeated references do not consume it again.
GPU binding and numerical precision limits are checked separately.

That scene cap is **not** a process/window cap: application assets, logical
resources, the previous acknowledged sheet, one complete pending sheet, Canvas,
GPU buffers and in-flight submissions can own different live resources. Failed
newer preparation keeps the coherent old candidate and old P leases. Exact
acknowledgement rotates the pending cohort; removal releases the last cold state
only after the removal is acknowledged. Suspension retains P resources.

RGBA8 remains four bytes/texel in CPU resources and GPU WORDS. Explicit linear
HDR remains sixteen. The GPU uses the same four storage bindings as before:
checked image word offsets and profile/alpha/filter flags occupy existing draw
resource lanes. Uploads are bounded 64 KiB chunks, with no persistent decoded
CPU/GPU linear mirror. A stable exact resource-key sequence and sufficiently
large draw prefix upload zero pixel bytes. Resource-set/order or prefix changes
currently repack/reupload the live set; no historical resources accumulate.
An image-free scene releases the cold GPU index and returns to ordinary buffer
residency. Old submitted bind groups retain their own buffer leases.

On the measured 64-bit branch base, each image is an 8-byte lease plus one
40-byte allocation header and the standard 16-byte Arc counters, plus pixels.
Canvas adds one 8-byte cold pointer; Runtime adds its own 8-byte pointer and
contains that Canvas (16 bytes combined). Renderer adds one 8-byte pointer.
El176/Draft152/Style88/Node40/Presented80 are unchanged on this base; main's newer
Presented representation is a separate integration. No per-node image lease is
added. Cold resource/cohort headers and handle capacities are additional; the
allocator ledger includes their actual retained allocations. SceneStorage
reports its boxed resource header separately from lanes; hash-table capacities
are diagnostic counts, not a claim that control/allocator bytes are free.

CPU straight-sRGB uses a shared immutable 1 KiB transfer table, verified against
the existing Color path for all 256 channel values ×256 alpha values. P3 and
encoded-premultiplied input keep the existing conversion/matrix order and an
exact tile-local 256-entry memo. Full texel indices prove reuse; collisions only
repeat conversion. HDR and straight-sRGB do not initialize the memo. The memo
is scoped borrowed scratch in an image-only out-of-line helper, not a persistent
resource mirror or image-free raster-frame allocation.

## Verification and evidence

See [image evidence](evidence/images.md) for source/binary pins, raw CSV, linked
stack inspection and measured costs, including losing regimes. Native proof:

```
DISPLAY=:99 cargo test -p gpui --features x11-minimal --lib \
  native::image_tests::native_image_pointer_resize_resume_matches_complete_surface \
  -- --exact --ignored --nocapture --test-threads=1
cargo test -p gpui_gpu --features vulkan-tests --test render
cargo test -p gpui_canvas --features parallel
cargo test -p gpui --test images
```

The native test requires an actual X11 display, sends ordinary pointer events,
waits real presentation acknowledgements, resizes/suspends/resumes, then compares
all fetched X11 pixels to the owner output. Vulkan tests hard-require an adapter;
these results use llvmpipe, not discrete-GPU timing. SDR image fixtures assert
≤1 byte/channel error; HDR fixtures assert absolute error
`≤max(2e-6, 1.5e-3 × abs(CPU))`. These are explicit tested tolerances, not universal
CPU/GPU bit parity. Independent CPU oracles compare constant images to solid
geometry and nearest texels to separately authored rectangles; transparent-edge
and linear-light tests check reconstruction. Resource/candidate/cohort failures
and parallel worker output are covered separately.

Native surface negotiation remains opaque tagged sRGB SDR. Float HDR rendering
and profiled resources do not establish native HDR presentation. Decoding,
ICC/EXIF, animation, mipmaps, nine-slice, image tint/opacity properties and async
I/O/cache policies are outside this slice.
