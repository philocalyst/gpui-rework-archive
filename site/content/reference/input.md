+++
aliases = ["guide/interactivity/events/", "guide/interactivity/gestures-drag/", "interactivity/events.html", "interactivity/gestures-drag.html"]
title = "Input and actions"
description = "Understand dispatch phases, keyboard focus, contexts, and text input."
weight = 30
+++

Pointer input is routed through the hitbox tree; keyboard input is routed along
the focused element path. A key binding turns a keystroke into a typed action,
and an action listener handles the operation. This gives pointer, menu, and
keyboard routes a way to invoke the same operation without pretending they
were the same input event.

Read [input, focus, and actions](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/input/index.html)
for capture and bubble phases, propagation defaults, and text-input boundaries.
The [keyboard walkthrough](@/examples/actions.md) connects a focus handle,
`track_focus`, key context, binding, and action listener. If a shortcut does
nothing, check the active focus path first, then the binding context and
propagation; the [focus guide](@/guides/focus.md) separates those failure cases.
