# Luna 08: scene and GPU documentation review

## Read inventory

Reviewed the current source and documentation by hand for this pass:

- `crates/gpui/src/scene.rs`: scene recording, draw-order assignment, layers, replay, finishing, batch iteration, renderer commands, filters, scene-space data types, path primitives, and shader records.
- `crates/gpui/src/scene/plan.rs`: command compilation, batch boundaries, filter target assignment, requirements, and capture-command validation.
- `crates/gpui/src/scene/capture.rs`, `atlas.rs`, and `embed.rs`: portable captures, bitmap validation, atlas resolution, import lifetime, and composition into a receiving scene.
- `crates/gpui/src/scene/abi.rs` and `crates/gpui_render/src/shaders/interface.rs`: Rust record layouts, WGSL type mapping, pipeline data layouts, and upload bindings.
- `crates/gpui/src/path_builder.rs`: path command construction, transforms, dash expansion, and lyon tessellation.
- `crates/gpui_render/src/path_types.rs`, `blur.rs`, `artifacts.rs`, `instances.rs`, `shaders/interface.rs`, and the shader modules `paths.rs`, `filters.rs`, `sprites.rs`, `quads.rs`, and `shadows.rs`: path rasterization, upload layouts, blur stages, shader artifacts, sprite draws, and filter compositing.
- `crates/gpui_wgpu/src/wgpu_renderer.rs`, `wgpu_renderer/platform.rs`, `wgpu_context.rs`, `wgpu_atlas.rs`, `wgpu_renderer/frame.rs`, and `wgpu_renderer/settings.rs`: WGPU public renderer/context/target/atlas contracts, frame submission, recovery, and device-loss signals.
- `crates/gpui_apple/src/metal_renderer.rs` and `metal_atlas.rs`: Metal public renderer, atlas, headless adapter, render targets, and resource handling.

## Documentation edits and source-grounded clarifications

- Expanded `Scene` docs to explain the record → `finish` → inspect/render lifecycle, type-grouped storage versus painter-ordered commands, scene-space units, and the data that a scene does not carry.
- Clarified `push_layer`: its bounds contribute to overlap ordering and its contents share an order key; the bounds do not themselves clip pixels. `ContentMask` supplies geometric clipping.
- Explained that replay inserts previous paint operations into the receiving scene's current order tree and layer stack.
- Added plan guidance for compatible adjacent batches, scene-array range validity, resource estimates, path rasterization, and the fixed two-level content-filter isolation limit. Deeper groups are represented in the command stream but render inline.
- Expanded `PathBuilder` docs with logical-pixel coordinates, build-time transform timing, SVG arc angle units, and the triangle tessellation behavior. The `x_rotation` parameter is typed as `Pixels` but is interpreted as degrees by the implementation.
- Added call-level guidance for the shared blur-uniform constructors, tying scene-space geometry to physical texture dimensions and describing the copy, downsample, separable blur, and composite stages.
- Clarified the imported-scene resource lifetime: the imported handle keeps atlas entries alive, while the cache itself uses weak references.
- Expanded WGPU renderer and shared-context docs to describe thread confinement, temporary surface detachment, surface replacement, and the need to rebuild device-bound resources after device loss.
- Audited the public Scene, plan, capture, embed, scene-atlas, path-builder, blur/ABI/artifact records, and renderer-facing WGPU/Metal declarations for concrete units, ordering, lifetimes, validation outcomes, and recovery constraints. Added the missing Metal atlas/headless type contracts and corrected the Gaussian-kernel docs to match its actual NaN/positive-infinity handling.

Relevant current source locations include `scene.rs:95` (`Scene`), `scene.rs:195` (`push_layer`), `scene.rs:346` (`replay`), `scene.rs:366` (`finish`), `plan.rs:19` (filter-depth limit), `plan.rs:53` (plan requirements), `plan.rs:328` (`PrimitiveBatch`), `plan.rs:387` (`RenderCommand`), `capture.rs:73` (`SceneCapture`), `atlas.rs:19` (`SceneAtlas`), `path_builder.rs:179` (arc units), `path_builder.rs:234` (transform replacement), `path_builder.rs:279` (build/tessellation), `blur.rs:73` (`BlurKernel`), `shaders/interface.rs:6` (`BufferData` safety contract), `wgpu_renderer.rs:44` (thread-local coordination), `wgpu_context.rs:382` (`WgpuRenderTarget`), `wgpu_renderer/platform.rs:206` (surface replacement), `metal_renderer.rs:684` (Metal draw), and `metal_atlas.rs:19` (`MetalAtlas`).

## Pinned usage references

- Zed documentation reference, commit `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`: `crates/gpui/examples/painting.rs:66-110` demonstrates filled paths built with `PathBuilder`; `:350-400` paints background quads before paths and builds optional dashed strokes before calling `Window::paint_path`. This illustrates why painting APIs are the ordinary app-facing surface and why painter order matters.
- Hummingbird documentation reference, commit `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`: `src/ui/components/knob.rs:342-370` builds stroke paths for a track, value arc, and tick, then paints each path in sequence. This is a compact real consumer example for the path-builder-to-window-paint handoff.
- Jiff 0.2.38 primary crate docs (`README.md` and `src/lib.rs` in the local Cargo registry) provide a useful structure: a short purpose statement, a complete runnable example, an explicit conceptual model, links to deeper API sections, and a clear list of limitations. For scene docs, retain that progression: a small user-facing paint example first, then explain the renderer-neutral scene contract and its backend constraints.

## Limits of this pass

The public declarations in the listed Scene/plan/capture/embed/atlas/path APIs and renderer-facing records/functions were reviewed individually. Shader modules were read for the renderer-facing data flow and contracts; their pure shader math helpers were not all audited as separate end-user APIs. I did not build or run platform renderers, so runtime parity is not claimed. The Zed and Hummingbird repositories were read at their pinned commits through Git because their reference clones had not checked out ordinary files into the worktree. Hummingbird provides application call sites rather than a separate GPUI renderer contract.
