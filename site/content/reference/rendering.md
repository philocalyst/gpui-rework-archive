+++
aliases = ["elements/advanced.html", "elements/div.html", "graphics/animation.html", "graphics/geometry-color.html", "graphics/scene-rendering.html", "guide/elements/advanced/", "guide/elements/div/", "guide/graphics/animation/", "guide/graphics/geometry-color/", "guide/graphics/scene-rendering/", "guide/rendering/elements-core/", "guide/rendering/styling/", "guide/rendering/views-render/", "rendering/elements-core.html", "rendering/styling.html", "rendering/views-render.html"]
title = "Rendering and identity"
description = "Understand the view, element phases, layout constraints, scene, and renderer."
weight = 20
+++

A view returns an element tree. Elements request layout, prepare drawing and
interaction state, then paint into a scene. The renderer consumes that scene's
plan and presents a frame.

Read [from a view to a frame](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/rendering/index.html)
for identity, retained state, the three phases, and renderer boundaries.
Use [layout](@/examples/layout.md) for constraints, [drawing](@/examples/drawing.md)
for custom paint, and [animation](@/examples/animation.md) for keyed state.

The central contracts are [Render](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Render.html),
[Element](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Element.html),
[Styled](https://docs.rs/gpui-ce/0.2.2/gpui/trait.Styled.html), and
[Scene](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Scene.html).
