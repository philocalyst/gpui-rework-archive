+++
title = "Paint within an element"
description = "Keep layout, frame-local preparation, clipping, and paint order explicit."
weight = 75
+++

Use [`canvas`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.canvas.html) when an element
needs custom drawing but the surrounding element tree can remain ordinary
GPUI elements. The first closure runs in prepaint after layout and returns the
frame-local data the paint closure needs. Both receive the canvas bounds. Use
those resolved bounds for geometry that should move or resize with its parent;
keep persistent choices, such as a selected color, on the view.

The [drawing walkthrough](@/examples/drawing.md) returns no preparation state.
It paints a background and two rectangles relative to the canvas origin. Resize
the preview and watch the rectangles follow the new bounds. This is the right
shape for inexpensive frame-local drawing; precompute paths or measurements in
prepaint when painting needs prepared geometry.

## Clip deliberately

Layout bounds say where an element is placed. They do not, by themselves,
restrict its paint commands. Wrap drawing in
[`Window::with_content_mask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.with_content_mask)
when it must stay inside a rectangle. The helper intersects the supplied mask
with the enclosing mask, then restores the previous mask after the closure.
The walkthrough's blue rectangle keeps its requested size and is cropped at
the canvas edge. Remove the mask to see that layout placement alone does not
clip a paint command.

A [`ContentMask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ContentMask.html)
can also fade its edges. Its bounds and fade distances use window coordinates;
they do not follow an arbitrary drawing transform.

## Prepare paths, then paint them

[`PathBuilder`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.PathBuilder.html)
constructs filled or stroked paths from lines and curves. Begin a contour with
`move_to`, add segments, and close it when the contour requires a closing edge.
`build` consumes the builder and returns a tessellated path or an error. Handle
that error before passing the path and color to
[`Window::paint_path`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.paint_path).
Use this route for geometry that should be filled or stroked as a path; use
quads for rectangles and images for raster content.

Compute frame-local geometry in prepaint when paint needs it. Keep persistent
application state on the view. For a reusable custom element that must own
layout or interaction behavior, follow the [phase walkthrough](@/examples/custom-element.md), then read the
[`Element` phase contract](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Element.html)
and the [rendering explanation](@/reference/rendering.md).
