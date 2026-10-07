+++
aliases = ["elements/advanced.html", "elements/div.html", "graphics/animation.html", "graphics/geometry-color.html", "graphics/scene-rendering.html", "guide/elements/advanced/", "guide/elements/div/", "guide/graphics/animation/", "guide/graphics/geometry-color/", "guide/graphics/scene-rendering/", "guide/rendering/elements-core/", "guide/rendering/styling/", "guide/rendering/views-render/", "rendering/elements-core.html", "rendering/styling.html", "rendering/views-render.html"]
title = "Rendering and identity"
description = "Understand the view, element phases, layout constraints, scene, and renderer."
weight = 20
+++

An entity-backed [`Render`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Render.html)
returns an element tree for a frame. Each `Element` requests a layout node,
receives resolved bounds in prepaint to register hitboxes and prepare geometry,
then records paint commands. Phase state passes through that one draw; retained
state needs a stable element path or an entity. The scene records those commands
for the selected renderer, whose presentation work is a separate platform step.

Read [from a view to a frame](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/rendering/index.html)
for identity, retained state, the three phases, and renderer boundaries. Use
[layout](@/examples/layout.md) to see constraints resolve, [drawing](@/examples/drawing.md)
to see that bounds do not clip custom paint, and [animation](@/examples/animation.md)
to see an element key retain animation progress between rebuilt values.

The central contracts are [Render](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Render.html),
[Element](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Element.html),
[Styled](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Styled.html), and
[Scene](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Scene.html). A `LayoutId` is
valid only for that frame's layout; an `ElementId` contributes to the stable
path used for interaction and retained state. Do not use one as the other.
