+++
title = "Scene and rendering: primitives, paths, SVG"
description = "Trace drawing commands into a scene and through the renderer to the GPU."
weight = 28
aliases = ["/graphics/scene-rendering.html"]
[extra]
category = "GRAPHICS"
legacy_source = "gpui-ce-docs/build/html/graphics/scene-rendering.html"
+++

**Scene** is the frame’s draw list ([crates/gpui/src/scene.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/scene.rs)). Your elements record primitives into it, then a backend consumes them. You describe, GPUI draws — that split keeps your code backend-free.

```rust
// Paint in three verbs: open a layer, record work, close it.
// Everything between push and pop shares one ordering baseline.
scene.clear(); // fresh frame, drop last frame `scene.rs:60`
scene.push_layer(root_bounds); // order baseline enters `scene.rs:80`
scene.insert_primitive(quad); // anything `Into<Primitive>` lands here `scene.rs:101`
scene.pop_layer(); // baseline leaves `scene.rs:87`
scene.finish(); // seal the list for the backend `scene.rs:201`
```

The verified surface stays small on purpose: `clear`, `push_layer` / `pop_layer`, `insert_primitive`, `replay`, `finish`, `batches` ([crates/gpui/src/scene.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/scene.rs), `:80–87`, `:101`, `:191`, `:201`, `:229`). Rasterization and GPU upload live in backend crates, outside this page. Never invent GPU internals here.

## Scene primitives

**Primitive** is one drawable thing: quad, path, underline, shadow, sprite, surface, filter (`crates/gpui/src/scene.rs:319–330`). Each answers `bounds()` and `content_mask()` (`crates/gpui/src/scene.rs:334–362`). Layers scope ordering, and `batches()` groups the sealed list for the backend.

```rust
// The backend reads grouped work, not raw insertions.
// Your job ends at `finish` — ordering and filtering belong downstream.
scene.finish(); // seal it `scene.rs:201`
for batch in scene.batches() { // grouped draws `scene.rs:229`
    // backend uploads and draws each batch in turn
}
```

Batching merges greedily across kinds by global draw order, not by fixed cutoffs. Sprites split batches on texture change: same kind still breaks the run when `texture_id` differs (`crates/gpui/src/scene.rs:516–517`). Filter boundaries never merge — each ships solo so the renderer can switch targets at exactly the right point (`scene.rs:601–608`).

**BoundsTree** is `pub(crate)` ([crates/gpui/src/bounds_tree.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/bounds_tree.rs)). It is an internal spatial index for ordering, not public API. Never cite it from app code.

> **Tip.** Fewer primitives beat clever primitives. Emit runs of quads and glyphs, merge many tiny paths into one, and your batches stay long and happy.

## Paths and builders

Three things share the name path, and only two draw. Learn the trio once and the confusion ends forever.

```rust
// Build with the builder, paint the product.
// `stroke` outlines, `fill` paints the inside — pick one to start.
let mut b = PathBuilder::stroke(px(2.)); // ergonomic constructor `path_builder.rs:88`
b.move_to(point(0., 0.)); // pen down `path_builder.rs:125`
b.line_to(point(64., 0.)); // straight edge `path_builder.rs:131`
b.curve_to(point(64., 64.), ctrl); // smooth quadratic bend `path_builder.rs:137`
let path: Path<Pixels> = b.build()?; // tessellated, fallible `path_builder.rs:244`
window.paint_path(path, color); // hand the mesh to the scene
```

|  |  |
| --- | --- |
| Name | What it really is |
| `scene::Path` | Drawable mesh of triangles (`scene.rs:1006`), id is `PathId` (`:1001`) |
| `PathBuilder` | Ergonomic constructor with lyon inside (`path_builder.rs:25`) |
| `gpui_path` | Filesystem paths only — `AbsPath`, `RelPath`, never vector art |

Table 21: Three paths, two that draw, one that walks the disk.

The tessellation gap matters. `Path::curve_to` bakes a rough single-triangle quadratic ([crates/gpui/src/scene.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/scene.rs)), fine for simple fans. `PathBuilder::curve_to` delegates to lyon for proper multi-triangle curves ([crates/gpui/src/path_builder.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/path_builder.rs)), and adds `cubic_bezier_to` plus `arc_to` (`path_builder.rs:144`, `:155`). Reach for the builder whenever curves must look smooth. Note `build` returns `Result`, so let `?` carry the failure.

> **Pitfall.** `gpui_path` never draws. It wraps `std::path::Path` for absolute and relative filesystem entries (`crates/gpui_path/src/`). Import it for vector graphics and your build fails with a puzzling type error.

## Svg pictures

**SvgRenderer** parses with `usvg` and rasterizes per scale ([crates/gpui/src/svg_renderer.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/svg_renderer.rs)). Parse once, rasterize per size, and your icons stay crisp on every display.

```rust
// Parse the bytes once, then rasterize each scale you need.
// Keep `parsed` beside your asset — re-parsing per DPI wastes the win.
let svg = SvgRenderer::new(asset_source); // renderer with your assets `svg_renderer.rs:125`
let parsed: ParsedSvg = svg.parse_svg(&bytes)?; // fonts resolve, text flattens `svg_renderer.rs:192`
let frame = svg.render_single_frame(&parsed, SvgSize::ScaleFactor(2.0))?; // Retina-ready `svg_renderer.rs:225`
```

Sizes come in three flavors: **SvgSize** offers `Size`, `ExactSize`, or `ScaleFactor` ([crates/gpui/src/svg_renderer.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/svg_renderer.rs)), chosen via **RenderSvgParams** (`svg_renderer.rs:86`). Parsing resolves fonts and flattens text to paths, so one `ParsedSvg` serves many scales through `render_parsed` (`svg_renderer.rs:198`).

> **Tip.** Cache `ParsedSvg` per asset and rasterize per needed `SvgSize`. Prefer `ScaleFactor` over re-parsing when the same art crosses DPIs.

Where next? Fill your scene with words (`./text-system.html`), tune the numbers inside each box (`./geometry-color.html`), or set the whole frame in motion (`./animation.html`).

## Sources

- `Scene`: [crates/gpui/src/scene.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/scene.rs); `clear`: `scene.rs:60`; `push_layer` / `pop_layer`: `scene.rs:80–87`; `insert_primitive`: `scene.rs:101`
- `replay`: `scene.rs:191`; `finish`: `scene.rs:201`; `batches`: `scene.rs:229`; `Primitive`: `scene.rs:319–330`; `bounds` / `content_mask`: `scene.rs:334–362`
- `PathId`: `scene.rs:1001`; `Path`: `scene.rs:1006`; `move_to` / `line_to` / `curve_to` / `push_triangle`: `scene.rs:1057–1093`
- `PathBuilder`: [crates/gpui/src/path_builder.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/path_builder.rs); `stroke`: `path_builder.rs:88`; `fill`: `path_builder.rs:96`; `curve_to`: `path_builder.rs:137`; `build`: `path_builder.rs:244`
- `SvgRenderer`: [crates/gpui/src/svg_renderer.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/svg_renderer.rs); `RenderSvgParams`: `svg_renderer.rs:86`; `SvgSize`: `svg_renderer.rs:108`; `new`: `svg_renderer.rs:125`
- `parse_svg`: `svg_renderer.rs:192`; `render_parsed`: `svg_renderer.rs:198`; `render_single_frame`: `svg_renderer.rs:225`
- `BoundsTree` (`pub(crate)`): [crates/gpui/src/bounds_tree.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/bounds_tree.rs); filesystem paths: `crates/gpui_path/src/`
