+++
title = "Paint within an element"
description = "Keep layout, frame-local preparation, clipping, and paint order explicit."
weight = 75
+++

Use [`canvas`](https://docs.rs/gpui-ce/0.2.2/gpui/fn.canvas.html) when an element
needs custom drawing without a custom `Element` implementation. Its first
closure runs during prepaint and returns data for its second closure, which
runs during paint. Both receive the rectangle assigned by layout.

The [drawing walkthrough](@/examples/drawing.md) needs no preparation state.
It paints a background and two rectangles relative to the canvas origin. A
resized window gives the next frame new bounds; the drawing uses those bounds
rather than keeping an independent viewport.

## Clip deliberately

Layout bounds say where an element is placed. They do not, by themselves,
restrict its paint commands. Wrap drawing in
[`Window::with_content_mask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.with_content_mask)
when it must stay inside a rectangle. The helper intersects the supplied mask
with the enclosing mask, then restores the previous mask after the closure.
The walkthrough crops its right rectangle when the available width is small.

A [`ContentMask`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.ContentMask.html)
can also fade its edges. Its bounds and fade distances use window coordinates;
they do not follow an arbitrary drawing transform.

## Prepare paths, then paint them

[`PathBuilder`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.PathBuilder.html)
constructs filled or stroked paths from lines and curves. Begin a contour with
`move_to`, add segments, and close it when the contour requires a closing edge.
`build` consumes the builder and returns a tessellated path or an error. Handle
that result before passing the path and color to
[`Window::paint_path`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.paint_path).

Compute frame-local geometry in prepaint when paint needs it. Keep persistent
application state on the view. For a reusable custom element, follow the [phase walkthrough](@/examples/custom-element.md), then read the
[`Element` phase contract](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Element.html)
and the [rendering explanation](@/reference/rendering.md).
