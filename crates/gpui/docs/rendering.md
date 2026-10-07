# From a view to a frame

A [`Render`](crate::Render) implementation describes a view's current element
tree. It does not submit GPU commands. The tree passes through layout, prepaint,
and paint before the platform renderer presents the frame.

That division lets application code describe an interface with builders while
custom elements control measurement or painting when a builder is insufficient.
The [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/#paint)
uses [`canvas`](crate::canvas) to cross that boundary without implementing a
new element type.

## State and identity

A view is an [`Entity`](crate::Entity) whose value implements `Render`. Its
state survives frames because the application owns the entity. Most elements
returned by a render call are temporary values. GPUI keeps selected element
state separately, indexed by stable IDs on the path through the element tree.

Use a stable [`ElementId`](crate::ElementId) for an interactive element or an
animation. Reusing the same ID in the same parent connects the new element to
its retained state. Changing the ID starts another identity. Avoid using an
array index for a row that can move: the row's logical key is usually the
identity you want to retain.

Re-rendering does not mean every pixel must be repainted. The window tracks
invalidated views and can reuse cached rendering work. A `render` function
should describe the current UI correctly whenever it is called. Do not make
correctness depend on an assumed call count.

## The three element phases

| Phase | Input | Responsibility |
| --- | --- | --- |
| [`Element::request_layout`](crate::Element::request_layout) | Window and app context | Request layout nodes and retain the element's layout state. |
| [`Element::prepaint`](crate::Element::prepaint) | Resolved bounds | Prepare hitboxes, dispatch nodes, child drawing, and paint state. |
| [`Element::paint`](crate::Element::paint) | Bounds and prepared state | Record primitives and install handlers for the frame. |

The state associated types connect those phases without requiring a custom
element to recompute its work. Bounds are in logical [`Pixels`](crate::Pixels);
the platform converts to device pixels for rendering. A display scale factor
is not a multiplier that application layout code should apply a second time.

[`Div`](crate::Div) handles these phases for a styled container.
[`canvas`](crate::canvas) gives a caller two closures after layout: prepaint can
prepare a value; paint consumes that value and records drawing commands.
Implement `Element` when layout or lifecycle control is part of the component's
behavior, rather than merely its appearance.

## Layout constraints

Flex and grid layout are calculated by the layout engine. A child's requested
size is resolved against its parent's available space; it is not a guarantee
that the child can grow beyond those constraints. A scrolling region needs a
finite viewport. A flexible text pane may need `min_w_0` before it can shrink
below its content's intrinsic width.

The [layout walkthrough](https://gpui-ce.github.io/examples/layout/#constraints)
shows that interaction between a fixed sidebar and a flexible pane. The
[list walkthrough](https://gpui-ce.github.io/examples/lists/#visible-range)
shows why a list asks for visible rows rather than constructing every item.

## Scene and renderer boundaries

Paint commands contribute primitives to a [`Scene`](crate::Scene). The scene
is finalized into ordered batches and a render plan. Render backends consume
that plan and resolve textures, paths, masks, and filters. Scene ordering is
observable: overlapping drawings must preserve the same stacking order as the
element tree.

Scene captures and CPU rendering are useful for deterministic tests. They do
not prove that a native GPU driver, window decoration, IME, or browser surface
behaves the same way. The [testing guide](https://gpui-ce.github.io/guides/testing/)
describes which layer each test exercises.
