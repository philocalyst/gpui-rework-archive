+++
title = "Paint within an element"
description = "Keep layout, frame-local preparation, clipping, and paint order explicit."
weight = 75
+++

<!-- Mirrored from crates/gpui/docs/drawing.md; edit that source. -->

Use [`canvas`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.canvas.html) for custom drawing inside an ordinary element
tree. Its first closure runs in prepaint, after layout, and returns the data
the paint closure needs. Both receive the canvas's resolved bounds. Geometry
derived from those bounds follows layout; persistent choices, such as a
selected color or data series, belong on the view.

The [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/)
paints a background and two rectangles relative to the canvas origin. It needs
no prepared state. A chart with measured labels or tessellated curves can
prepare those values in the first closure and consume them in the second.
See the [rendering chapter](https://gpui-ce.github.io/book/rendering.html) for the phase
contract and the difference between building an element and painting it.

Choose an element according to the work it needs to do:

| Work | Element |
| --- | --- |
| A styled rectangle, label, or ordinary button | [`div`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.div.html), with text and interaction builders |
| Geometry that fits a box supplied by layout | [`canvas`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.canvas.html), with preparation and paint callbacks |
| Custom measurement, child layout, or retained element state | An [`Element`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Element.html) implementation |
| Pixels from an existing video or GPU render target | [`surface`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.surface.html) |

## Give a canvas space and an owner

A canvas does not measure its drawing to choose a size. Set its width and
height, or use `size_full` inside a parent that already has a resolved size.
The callback bounds cover that complete box. A rectangle drawn outside it
does not enlarge the canvas or push a sibling aside.

The prepaint result belongs to one frame. Use it to pass a prepared path,
label geometry, or hitbox into paint. Keep the chart's data, selection, and
reusable geometry on an entity; notify the view when they change. Rebuilding
the canvas then captures the current values in new callbacks. Retaining the
canvas value or its prepaint result is not a cross-frame state mechanism.

Put ordinary behavior on a surrounding div. That div can own a name, role,
focus handle, and click listener while the canvas supplies the picture.
Canvas itself has no accessibility node or automatic hit region. Its
[`style boundary`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Canvas.html#style-boundary) also differs from Div's:
put overflow clipping, opacity, and inherited text styling on the parent.
The constructor's [inset-swatch example](https://docs.rs/gpui-ce/0.2.2/gpui/fn.canvas.html#prepare-geometry-then-paint-it)
shows the phase handoff without requiring a custom element type.

## Keep coordinates and clipping explicit

Window paint methods take window-local logical [`Pixels`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Pixels.html).
Add `bounds.origin` when the geometry starts as a local offset inside a canvas.
Do not add that origin again when a text-layout query already returned a
window-local point. GPUI applies the display scale when it records scene
primitives; application drawing code should not multiply coordinates by it.

Layout bounds do not, by themselves, clip drawing. Use
[`Window::with_content_mask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.with_content_mask) when paint must
stay inside a rectangle:

```rust
use gpui::{Bounds, ContentMask, Pixels, Window, fill, rgb};

fn paint_region(bounds: Bounds<Pixels>, window: &mut Window) {
    let mask = ContentMask { bounds, fade_out: Default::default() };
    window.with_content_mask(Some(mask), |window| {
        window.paint_quad(fill(bounds, rgb(0x155b50)));
    });
}
```

Call this during paint. The helper intersects its mask with the enclosing mask
and restores the previous mask after the closure returns normally. In the
walkthrough, the blue rectangle keeps its requested size while the mask crops
it at the canvas edge. Clipping changes which pixels survive, not the geometry
that was laid out or recorded.

[`ContentMask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ContentMask.html) can also fade its edges. Its bounds and fade
distances use the window's coordinate system; they do not follow an arbitrary
drawing transform.

## Prepare a path once when its geometry is stable

[`PathBuilder`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.PathBuilder.html) builds contours from lines and
[Bézier curves](https://en.wikipedia.org/wiki/B%C3%A9zier_curve), then
[tessellates](https://en.wikipedia.org/wiki/Tessellation_(computer_graphics))
them into triangles. Begin a contour with `move_to`, add segments, and call
`close` when it needs a closing edge. `build` consumes the builder and returns
a [`Path`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Path.html) or an error:

```rust
use gpui::{PathBuilder, point, px};

let mut outline = PathBuilder::stroke(px(2.));
outline.move_to(point(px(0.), px(0.)));
outline.line_to(point(px(48.), px(0.)));
outline.curve_to(point(px(0.), px(0.)), point(px(24.), px(32.)));
outline.close();
let path = outline.build()?;
assert!(!path.vertices.is_empty());
# Ok::<(), anyhow::Error>(())
```

Pass a finished path and its paint to [`Window::paint_path`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.paint_path).
That method consumes the path, applies the active content mask and opacity,
and scales it for the scene. It does not compute a layout box or register a
hitbox. Use quads for rectangles, paths for filled or stroked contours, and
image elements for raster content.

Builder transforms apply to all contours at `build` time, including commands
added before the transform call. Calling `transform` replaces the accumulated
transform; `translate`, `scale`, and `rotate` append to it. The geometry is
transformed *before* stroking, so a builder scale leaves its stroke width and
dash lengths unchanged. A later window display scale affects the complete
tessellated result.

> [!WARNING]
> Stroke dash lengths must be finite and positive, and the pattern must not
> be empty. Invalid patterns return an error from `build`; handle it before
> painting. Supply finite geometry and valid tessellation options as well:
> a fallible tessellator is not a general sanitizer for arbitrary input.

Keep a finished path when its geometry can be reused. Rebuild when the data,
size, or relevant style changes, rather than tessellating unchanged geometry
on every paint. Cloning a path copies its vertex vector, so include that cost
when deciding whether a cache helps. A large plot may need a different
representation; measure the work with the
[testing and measurement chapter](https://gpui-ce.github.io/book/testing.html).

## Composite an image already owned by the GPU

Use [`img`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.img.html) for a raster image loaded from bytes, a file, or a URL.
Use [`surface`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.surface.html) when the pixels already belong to a video
buffer, screen-capture frame, or custom GPU render target. The surface retains
that source's handle and lets the selected renderer import it.

A source has pixel dimensions, but a surface has no intrinsic layout size.
Give the element a size, then choose how to fit the source into it with
[`Surface::object_fit`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Surface.html#method.object_fit). The default is
[`ObjectFit::Contain`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ObjectFit.html#variant.Contain): the whole image is visible,
with unused space when its aspect ratio differs from the box. `Cover` fills
the box and can draw beyond it. An enclosing content mask supplies the crop;
fitting alone does not clip.

For custom WGPU drawing, acquire `gpui_wgpu::WgpuContextHandle` from the window
and create a `WgpuRenderTarget` on that device. Render into its texture, then
place the element returned by `target.surface()` in the view. Recreate that
element after resizing the target: an existing surface still retains the old
texture. Notify the view when new pixels are ready; changing a texture's
contents does not tell GPUI to draw a frame.

Check [`SurfaceSource`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.SurfaceSource.html) before choosing a source. Its
variants and supported formats depend on the backend. A WGPU texture must
come from GPUI's device and use its WGPU version; enabling the core texture
variant does not switch the native renderer. The
[platform feature guide](https://gpui-ce.github.io/book/platforms.html#cargo-features)
explains that selection. A native handle also cannot cross the scene-capture
boundary described below. Use capture-compatible sprite pixels when a frame
must travel to another renderer.

## Add behavior separately

A painted shape has no input or accessibility behavior by itself. A decorative
swatch may need neither. A selectable chart point needs a hit region, a named
semantic control, and a keyboard operation that reaches the same state change.
See the [input chapter](https://gpui-ce.github.io/book/input.html) and
[accessibility chapter](https://gpui-ce.github.io/book/accessibility.html) for those contracts.

Implement [`Element`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Element.html) when a reusable component needs its own
layout, prepaint, or interaction behavior beyond canvas callbacks. The
[custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/)
passes a prepared quad through all three phases. Keep retained application
state on the view, and retain element state under a stable ID when the element
itself needs continuity between frames.

## Choose what should paint above what

A menu may belong to a button's subtree for keyboard routing while needing
to draw outside a scroll pane. Position, clipping, and paint order are separate
choices:

| Need | Tool | Effect |
| --- | --- | --- |
| Place a popup by a button and fit it to the window | [`anchored`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.anchored.html) | Positions the children after layout; does not shrink an oversized popup |
| Draw above the main tree and escape an ancestor's clip | [`deferred`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.deferred.html) | Delays prepaint and paint, preserving the dispatch parent |
| Restrict an overlay's visible and interactive region | [`Deferred::content_mask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Deferred.html#method.content_mask) | Clips its drawing and hitboxes without changing layout |
| Batch non-overlapping custom geometry | [`Window::paint_layer`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.paint_layer) | Gives ordinary primitives one overlap-order region |
| Blur the element and its children together | [`Window::with_filter_layer`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.with_filter_layer) | Renders a filtered group through an offscreen target |
| Blur content behind a translucent panel | [`Window::paint_backdrop_filter`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.paint_backdrop_filter) | Samples drawing already recorded behind the panel |

For example, position a small notice at a button's bottom-left corner and
draw it above surrounding content:

```rust
use gpui::{Bounds, Pixels, anchored, deferred, div, prelude::*, px, rgb, text};

fn saved_notice(button_bounds: Bounds<Pixels>) -> impl IntoElement {
    deferred(
        anchored().position(button_bounds.bottom_left()).child(
            div()
                .id("saved-notice")
                .w(px(160.))
                .p_2()
                .bg(rgb(0x155b50))
                .text_color(rgb(0xffffff))
                .child(text!("Changes saved")),
        ),
    )
    .priority_auto()
}
```

Pass bounds from the current frame; old bounds can place the notice beside a
button that has moved. `anchored` may switch the attached corner or move the
notice against a window edge to fit it. `deferred` lets it escape a scroll
pane's mask. Its child still requests layout in the original tree; here the
anchored wrapper uses absolute positioning so it does not reserve an ordinary
row in the parent's flow.

This builds the notice's placement and appearance. An interactive popup also
needs opening and dismissal state, keyboard focus, and accessible controls.
Deferral changes where content paints, not who owns that state or which
ancestors receive keyboard events. See the
[input chapter](https://gpui-ce.github.io/book/input.html#keyboard-focus).

> [!WARNING]
> A paint layer's bounds are an ordering promise, not a clip. Cover all of
> the group's drawing and keep order-sensitive geometry out of the same
> batch when it overlaps. Use a content mask when pixels must stop at an
> edge; use a filter layer when the group needs an offscreen image.

## Capture a frame for another window

A [`SceneCapture`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SceneCapture.html) packages a finished frame's primitives,
render commands, and sprite pixels. It can carry drawing from a guest process
or interpreter to a host window. It carries no entities, layout, focus, or input
listeners; the host must supply the interaction separately.

There are three distinct steps:

1. **Capture.** Call [`SceneCapture::capture`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SceneCapture.html#method.capture)
   with a finished scene and a resolver that copies its referenced atlas tiles.
   This canonicalizes bitmap ordering and merges identical bitmaps for snapshot
   comparison. [`capture_live`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SceneCapture.html#method.capture_live) skips that
   content sorting and deduplication for frame transport.
2. **Import.** Call
   [`Window::import_scene_capture`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.import_scene_capture) in the
   receiving window. It validates the capture, uploads sprite pixels, and
   replaces capture-local tile IDs with that window's atlas IDs. Retain a
   [`SceneResources`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SceneResources.html) cache to share identical uploads
   between imported frames. Keep the returned [`ImportedScene`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ImportedScene.html)
   alive while its drawing can still be used; the cache holds weak references.
3. **Paint.** Call [`Window::paint_scene`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.paint_scene) during
   paint, supplying the source display scale and a destination rectangle in
   logical pixels. GPUI adjusts for the receiving window's density and clips
   to the rectangle. Its size does not stretch the captured drawing.

[`SceneCapture::to_scene`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SceneCapture.html#method.to_scene) is useful for inspecting
validated drawing data. It leaves sprite references pointing to the capture's
bitmaps and performs no atlas upload. Use window import when the scene will be
drawn by that window's renderer. Native surfaces cannot be captured because
their handles belong to a particular backend.

> [!NOTE]
> A scene capture is not a screenshot. It preserves geometry and rendering
> commands rather than a final image, and still requires a compatible renderer.
> For image comparisons in tests, use the capture facilities described in the
> [testing chapter](https://gpui-ce.github.io/book/testing.html#choose-what-a-simulated-platform-can-establish).
