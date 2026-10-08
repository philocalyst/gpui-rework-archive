# Paint within an element

Use [`canvas`](crate::canvas) for custom drawing inside an ordinary element
tree. Its first closure runs in prepaint, after layout, and returns the data
the paint closure needs. Both receive the canvas's resolved bounds. Geometry
derived from those bounds follows layout; persistent choices, such as a
selected color or data series, belong on the view.

The [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/)
paints a background and two rectangles relative to the canvas origin. It needs
no prepared state. A chart with measured labels or tessellated curves can
prepare those values in the first closure and consume them in the second.
See the [rendering chapter](crate::_documentation::rendering) for the phase
contract and the difference between building an element and painting it.

Choose an element according to the work it needs to do:

| Work | Element |
| --- | --- |
| A styled rectangle, label, or ordinary button | [`div`](crate::div), with text and interaction builders |
| Geometry that fits a box supplied by layout | [`canvas`](crate::canvas), with preparation and paint callbacks |
| Custom measurement, child layout, or retained element state | An [`Element`](crate::Element) implementation |
| Pixels from an existing video or GPU render target | [`surface`](crate::surface) |

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
[`style boundary`](crate::Canvas#style-boundary) also differs from Div's:
put overflow clipping, opacity, and inherited text styling on the parent.
The constructor's [inset-swatch example](crate::canvas#prepare-geometry-then-paint-it)
shows the phase handoff without requiring a custom element type.

## Keep coordinates and clipping explicit

Window paint methods take window-local logical [`Pixels`](crate::Pixels).
Add `bounds.origin` when the geometry starts as a local offset inside a canvas.
Do not add that origin again when a text-layout query already returned a
window-local point. GPUI applies the display scale when it records scene
primitives; application drawing code should not multiply coordinates by it.

Layout bounds do not, by themselves, clip drawing. Use
[`Window::with_content_mask`](crate::Window::with_content_mask) when paint must
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

[`ContentMask`](crate::ContentMask) can also fade its edges. Its bounds and fade
distances use the window's coordinate system; they do not follow an arbitrary
drawing transform. A positive distance makes the edge transparent and ramps
opacity up toward the interior; zero disables that fade. Hit testing still
uses the rectangle, including its faded area. Apply the same mask during
prepaint when the input region must share the paint clip. See the
[clipped-control test](https://gpui-ce.github.io/book/testing.html#check-clipping-and-input-together)
for both phases and a check outside the visible region.

> [!NOTE]
> Path painting currently honors the clip rectangle but ignores its edge
> fades. A mask is not a general alpha texture or a rounded clipping shape.
> Its default bounds are empty; use `None` in `with_content_mask` to retain
> the enclosing clip rather than supplying a default mask.

## Prepare a path once when its geometry is stable

[`PathBuilder`](crate::PathBuilder) builds contours from lines and
[Bézier curves](https://en.wikipedia.org/wiki/B%C3%A9zier_curve), then
[tessellates](https://en.wikipedia.org/wiki/Tessellation_(computer_graphics))
them into triangles. Begin a contour with `move_to`, add segments, and call
`close` when it needs a closing edge. `build` consumes the builder and returns
a [`Path`](crate::Path) or an error:

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

Pass a finished path and its paint to [`Window::paint_path`](crate::Window::paint_path).
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

### Choose how contours meet and fill

A *contour* is a connected sequence of segments. `move_to` starts one without
drawing a line from the preceding contour. Use `close` for a closed stroke:
it joins the last edge to the first. Drawing a final line back to the start
leaves two capped ends instead. [`StrokeOptions`](crate::StrokeOptions)
controls those caps and joins, as well as width and curve tolerance.

One builder uses one [`PathStyle`](crate::PathStyle) for every contour. To fill
a shape and outline it, build a filled path and a stroked path separately.
Color is a paint argument, so two differently colored copies of the same
geometry can share the preparation work.

For a shape with holes, choose a [`FillRule`](crate::FillRule). The default,
`EvenOdd`, leaves a hole where two nested contours overlap, regardless of
which way their points run. `NonZero` takes contour direction into account.
Set it with `with_style(PathStyle::Fill(FillOptions::non_zero()))`. The
[fill-rule diagrams](https://www.w3.org/TR/SVG/painting.html#FillRuleProperty)
show the difference for nested and intersecting contours.

For curves, the endpoint comes first in GPUI's `curve_to` and
`cubic_bezier_to`, before the control points. All those points are absolute
coordinates in the builder's space. Arcs use two radii, an ellipse rotation
in degrees, and flags that choose the sweep. The
[`arc_to` example](crate::PathBuilder::arc_to) draws an upper semicircle and
explains the flags; `relative_arc_to` changes only the endpoint into an offset.

### Place the geometry before stroking

Transform order matters. `scale(2.)` followed by `translate(point(px(40.),
px(0.)))` doubles a shape, then moves it forty logical pixels right. Reversing
those calls doubles the translation too. Rotation acts about the origin;
positive degrees turn clockwise in the window's downward-growing y axis.

For a canvas, author the geometry near `(0, 0)`, apply its local scale or
rotation, then translate by `bounds.origin` last. The resulting vertices are
window-local. An element-offset scope does not move arbitrary vertices passed
to `paint_path`, and scaling for display density yourself would scale them
again when the window records the scene.

### Handle failures before paint

> [!WARNING]
> Stroke dash lengths must be finite and positive, and the pattern must not
> be empty. Invalid patterns return an error from `build`; handle it before
> painting. Supply finite geometry and valid tessellation options as well:
> a fallible tessellator is not a general sanitizer for arbitrary input.

A build can also fail when its intermediate tessellation exceeds 65,536
vertices, the limit of its 16-bit indices. For a detailed plot, reduce the
geometry or increase the curve approximation tolerance in `FillOptions` or
`StrokeOptions`. Shapes that can be painted independently can use separate
paths. Leave `StrokeOptions::variable_line_width` as `None`: GPUI's builder
commands do not supply the custom vertex attributes that option requires.

Keep a finished path when its geometry can be reused. Its positions are baked
into the vertices: changing the data, size, stroke style, or window-local origin
requires updating the geometry. Changing only the paint color does not.
Cloning a path copies its vertex vector, so include that cost when deciding
whether a cache helps. Avoid tessellating unchanged geometry on every paint.
A large plot may need a different representation; measure the work with the
[testing and measurement chapter](https://gpui-ce.github.io/book/testing.html).

## Composite an image already owned by the GPU

Use [`img`](crate::img) for a raster image loaded from bytes, a file, or a URL.
Use [`surface`](crate::surface) when the pixels already belong to a video
buffer, screen-capture frame, or custom GPU render target. The surface retains
that source's handle and lets the selected renderer import it.

A source has pixel dimensions, but a surface has no intrinsic layout size.
Give the element a size, then choose how to fit the source into it with
[`Surface::object_fit`](crate::Surface::object_fit). The default is
[`ObjectFit::Contain`](crate::ObjectFit::Contain): the whole image is visible,
with unused space when its aspect ratio differs from the box. `Cover` fills
the box and can draw beyond it. An enclosing content mask supplies the crop;
fitting alone does not clip.

For custom WGPU drawing, acquire `gpui_wgpu::WgpuContextHandle` from the window
and create a `WgpuRenderTarget` on that device. Render into its texture, then
place the element returned by `target.surface()` in the view. Recreate that
element after resizing the target: an existing surface still retains the old
texture. Notify the view when new pixels are ready; changing a texture's
contents does not tell GPUI to draw a frame.

Check [`SurfaceSource`](crate::SurfaceSource) before choosing a source. Its
variants and supported formats depend on the backend. A WGPU texture must
come from GPUI's device and use its WGPU version; enabling the core texture
variant does not switch the native renderer. The
[platform feature guide](crate::_documentation::platforms#cargo-features)
explains that selection. A native handle also cannot cross the scene-capture
boundary described below. Use capture-compatible sprite pixels when a frame
must travel to another renderer.

## Add behavior separately

A painted shape has no input or accessibility behavior by itself. A decorative
swatch may need neither. A selectable chart point needs a hit region, a named
semantic control, and a keyboard operation that reaches the same state change.
See the [input chapter](crate::_documentation::input) and
[accessibility chapter](crate::_accessibility) for those contracts.

Implement [`Element`](crate::Element) when a reusable component needs its own
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
| Place a popup by a button and fit it to the window | [`anchored`](crate::anchored) | Positions the children after layout; does not shrink an oversized popup |
| Draw above the main tree and escape an ancestor's clip | [`deferred`](crate::deferred) | Delays prepaint and paint, preserving the dispatch parent |
| Restrict an overlay's visible and interactive region | [`Deferred::content_mask`](crate::Deferred::content_mask) | Clips its drawing and hitboxes without changing layout |
| Batch non-overlapping custom geometry | [`Window::paint_layer`](crate::Window::paint_layer) | Gives ordinary primitives one overlap-order region |
| Blur the element and its children together | [`Window::with_filter_layer`](crate::Window::with_filter_layer) | Renders a filtered group through an offscreen target |
| Blur content behind a translucent panel | [`Window::paint_backdrop_filter`](crate::Window::paint_backdrop_filter) | Samples drawing already recorded behind the panel |

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
[input chapter](crate::_documentation::input#keyboard-focus).

> [!WARNING]
> A paint layer's bounds are an ordering promise, not a clip. Cover all of
> the group's drawing and keep order-sensitive geometry out of the same
> batch when it overlaps. Use a content mask when pixels must stop at an
> edge; use a filter layer when the group needs an offscreen image.

## Choose which pixels to blur

Use [`Styled::blur`](crate::Styled::blur) when the element itself should look
soft: its background, contents, and border are filtered together. Use
[`backdrop_blur`](crate::Styled::backdrop_blur) for a sharp panel over a soft
backdrop. The backdrop must already have been painted, and the panel needs
some transparency to show it:

```rust
use gpui::{div, prelude::*, px, rgba};

let frosted_notice = div()
    .p_4()
    .bg(rgba(0xffffffb3))
    .backdrop_blur(px(8.))
    .child("This text stays sharp");

let soft_notice = div()
    .p_4()
    .bg(rgba(0xffffffb3))
    .blur(px(8.))
    .child("This text is blurred with its box");
```

Put the first notice above a patterned or otherwise detailed backdrop to see
the effect. An opaque fill would hide the filtered pixels. Put the second
notice above any background: its own text and box are the blur's input.
Drop shadows and outer rings remain outside a styled element's content-filter
group. Neither kind of blur changes the element's layout or hit region.

For custom drawing, the corresponding window methods make the order explicit.
Call this helper during paint, after recording the drawing behind the panel:

```rust
use gpui::{Bounds, Filter, Pixels, Window, fill, px, rgba};

fn paint_frosted_panel(bounds: Bounds<Pixels>, window: &mut Window) {
    let corners = px(8.).into();
    window.paint_backdrop_filter(bounds, corners, &[Filter::Blur(px(8.))]);
    window.paint_quad(fill(bounds, rgba(0xffffffb3)).corner_radii(corners));
    // Paint the panel's text and controls afterward so they remain sharp.
}
```

Use [`Window::with_filter_layer`](crate::Window::with_filter_layer) when the
closure's drawing should be the input instead. The group draws into a separate
texture, an *offscreen target*. The renderer blurs that image and combines it
with the receiving frame inside the group's rounded bounds. The active content
mask clips the result. This does not establish an input mask or move any
geometry; arrange those during prepaint as usual.

Two limits matter when composing these effects:

- A filter list uses its largest blur radius for **one** operation. Calling
  `.blur(px(4.)).blur(px(8.))` retains two entries but uses an eight-pixel blur;
  it does not blur successively. `filter` replaces the list, and an empty list
  clears it. Backdrop filters follow the same rule.
- [`MAX_FILTER_GROUP_DEPTH`](crate::MAX_FILTER_GROUP_DEPTH) is currently two.
  Deeper content groups draw inline without a separate blur. An enclosing
  group's filter still affects their drawing. Prefer a single group around
  the content that needs to soften together.

Supply finite radii; zero and negative values are skipped. The CSS
[blur](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/filter-function/blur)
and [backdrop-filter](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/backdrop-filter)
references illustrate the visual distinction. GPUI's filter-list and nesting
rules above define its behavior; CSS's complete filter and backdrop-root
semantics do not carry over.

## Capture a frame for another window

A [`SceneCapture`](crate::SceneCapture) packages a finished frame's primitives,
render commands, and sprite pixels. It can carry drawing from a guest process
or interpreter to a host window. It carries no entities, layout, focus, or input
listeners; the host must supply the interaction separately.

There are three distinct steps:

1. **Capture.** Call [`SceneCapture::capture`](crate::SceneCapture::capture)
   with a finished scene and a resolver that copies its referenced atlas tiles.
   This canonicalizes bitmap ordering and merges identical bitmaps for snapshot
   comparison. [`capture_live`](crate::SceneCapture::capture_live) skips that
   content sorting and deduplication for frame transport.
2. **Import.** Call
   [`Window::import_scene_capture`](crate::Window::import_scene_capture) in the
   receiving window. It validates the capture, uploads sprite pixels, and
   replaces capture-local tile IDs with that window's atlas IDs. Retain a
   [`SceneResources`](crate::SceneResources) cache to share identical uploads
   between imported frames. Keep the returned [`ImportedScene`](crate::ImportedScene)
   alive while its drawing can still be used; the cache holds weak references.
3. **Paint.** Call [`Window::paint_scene`](crate::Window::paint_scene) during
   paint, supplying the source display scale and a destination rectangle in
   logical pixels. GPUI adjusts for the receiving window's density and clips
   to the rectangle. Its size does not stretch the captured drawing.

[`SceneCapture::to_scene`](crate::SceneCapture::to_scene) is useful for inspecting
validated drawing data. It leaves sprite references pointing to the capture's
bitmaps and performs no atlas upload. Use window import when the scene will be
drawn by that window's renderer. Native surfaces cannot be captured because
their handles belong to a particular backend.

> [!NOTE]
> A scene capture is not a screenshot. It preserves geometry and rendering
> commands rather than a final image, and still requires a compatible renderer.
> For image comparisons in tests, use the capture facilities described in the
> [testing chapter](https://gpui-ce.github.io/book/testing.html#choose-what-a-simulated-platform-can-establish).
