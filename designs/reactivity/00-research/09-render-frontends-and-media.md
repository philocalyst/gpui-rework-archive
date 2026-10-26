# Renderer Frontends and Media Pipeline Audit

This note records the current implementation facts and the constraints they impose on the retained
design. It is research input; the normative contracts are in
[03-hybrid-plan.md](../03-hybrid-plan.md) and [runtime/media.md](../runtime/media.md).

## Current GPUI seam

The present abstractions are convenient for individual cases but do not form one ownership or
rendering model:

- [`ImageSource`](../../../crates/gpui/src/elements/img.rs) is a runtime enum over a `Resource`, an
  already decoded `RenderImage`, a platform `Image`, or a custom closure receiving `Window` and
  `App`. Strings are classified by whether they parse as a URI.
- [`RenderImage`](../../../crates/gpui/src/assets.rs) owns an eager `SmallVec` of decoded image
  frames. GIF and animated WebP loading therefore tend toward retaining the entire decoded
  animation in CPU memory.
- [`ImageCacheItem`](../../../crates/gpui/src/elements/image_cache.rs) manually changes from a shared
  task to a cloned loaded result. `RetainAllImageCache` is mounted through element state and retains
  a hash map without a framework-wide byte/residency policy.
- [`SurfaceSource`](../../../crates/gpui/src/elements/surface.rs) is platform-shaped in the core UI
  crate: a `CVPixelBuffer` on macOS and a type-erased `Any` expected to contain a wgpu texture on
  Linux/FreeBSD. [`PaintSurface`](../../../crates/gpui/src/scene.rs) repeats that platform split.
- [`PlatformWindow::draw`](../../../crates/gpui/src/platform.rs) accepts a whole `Scene`, while the
  Linux/FreeBSD GPU context escape hatch returns a type-erased `Any`. The Metal, DirectX and wgpu
  renderers consequently interpret core scene arrays themselves instead of consuming a narrow,
  capability-negotiated packet protocol.

This explains the manual-memory feel: acquisition, task polling, decoded-frame ownership, cache
identity, platform texture import, scene submission and GPU retirement are separate public or
semi-public concepts. Adding a `VideoSource` enum beside `ImageSource` would duplicate the problem.

## Verified platform implications

The design can provide one semantic media path, but it must not promise that every platform takes
the same physical path.

- Apple documents `CVMetalTextureCache` as directly creating Metal textures from Core Video image
  buffers. Crucially, the client must retain the created texture wrapper until GPU commands finish;
  this validates fence-owned import leases rather than frame-local borrowing.
  [Apple CVMetalTextureCache](https://developer.apple.com/documentation/corevideo/cvmetaltexturecache-q3j),
  [create texture from image](https://developer.apple.com/documentation/corevideo/cvmetaltexturecachecreatetexturefromimage%28_%3A_%3A_%3A_%3A_%3A_%3A_%3A_%3A_%3A%29)
- Media Foundation hardware decode shares a Direct3D device through `IMFDXGIDeviceManager`, and
  exposes decoder output surfaces through D3D video interfaces. Device changes require recreation
  of decoder and texture resources. That makes device generation part of the media import key, not
  an implementation afterthought.
  [Microsoft Media Foundation API](https://learn.microsoft.com/en-us/windows/win32/api/_mf/)
- WebGPU external textures may represent one to three planes plus crop, rotation and color
  conversion metadata. Import can avoid a copy, but that is explicitly implementation-dependent;
  the source frame also has an expiration/lifetime protocol. The portable promise is therefore
  “copy-minimal with a measured fallback,” never unconditional zero-copy.
  [WebGPU external textures](https://gpuweb.github.io/gpuweb/#gpuexternaltexture)
- Current wgpu exposes `ExternalTexture`, including NV12/YU12 formats and conversion metadata, but
  its feature is still capability-gated and documented as implementation-in-progress. The retained
  design must negotiate it per device and keep plane upload/RGBA fallbacks.
  [wgpu `ExternalTexture`](https://docs.rs/wgpu/latest/wgpu/struct.ExternalTexture.html),
  [wgpu feature status](https://docs.rs/wgpu/latest/wgpu/struct.FeaturesWGPU.html#associatedconstant.EXTERNAL_TEXTURE)

## Conclusions carried into the plan

1. Public authoring needs one destination per semantic kind—`image(source)` and `video(source)`—and
   framework-owned conversions for ordinary Rust source values. It does not need a public source
   enum or a user-managed `Arc<RenderImage>`.
2. Acquisition is not decoding. A path, embedded asset, HTTP request, in-memory bytes, application
   provider and live camera can all produce a byte/frame stream, after which common sniff/demux,
   decode, transform, cache and presentation stages apply.
3. Still images, animated images and video share source identity, cancellation, visibility priority,
   budgets, color management, renderer import and inspection, but not one giant runtime object or
   one buffering policy.
4. A native decoded surface is an opaque lease interpreted by the renderer frontend that created
   the capability. It is never `Any` in the core scene and is held through the submission fence.
5. The core sends immutable scene/resource deltas in bulk. Backend specialization occurs once per
   frame/pass/range, not through a trait call for every primitive.
6. Device loss invalidates residency/import generations while retaining or reacquiring the cheapest
   authoritative upstream representation. HTTP cache entries and decoded CPU images need not be
   discarded merely because a GPU device changed.
7. Animated media is deadline work, not a source-state write on every frame. Queues are bounded by
   bytes and presentation time; late frames are dropped/coalesced according to the media policy.
8. Inspector and tests need deterministic acquisition, decode and clock providers, plus redaction of
   URLs, headers and protected surfaces. A screenshot readback is not always legal or available.

## Rejected shortcuts

- A universal `Arc<dyn MediaSource>` would hide useful static dispatch and require object identity,
  allocation and thread bounds even for a path or embedded asset.
- A public enum with every source/backend variant would make downstream matches non-exhaustive and
  leak platform growth into application code.
- Caching only final RGBA frames loses progressive decode, scale-specific variants, YUV sampling,
  native decoder surfaces and device-independent reuse.
- Treating an HTTP URL as a cache key ignores request headers, redirects, `Vary`, validators,
  authorization and explicit no-store policy.
- Decoding every animation frame eagerly replaces CPU time with unbounded resident memory and poor
  startup. A disposal-aware bounded frame window and keyframe checkpoints are required.
- Calling every imported video frame “zero-copy” is unverifiable. Decoder format, device identity,
  backend capability, crop/color conversion and shader use can all force a copy.
