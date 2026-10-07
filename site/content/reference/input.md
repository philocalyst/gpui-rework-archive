+++
aliases = ["guide/interactivity/events/", "guide/interactivity/gestures-drag/", "interactivity/events.html", "interactivity/gestures-drag.html"]
title = "Input and actions"
description = "Understand dispatch phases, keyboard focus, contexts, and text input."
weight = 30
+++

Pointer events follow hitboxes. Keyboard events follow focus. Typed actions
name operations that several input routes can invoke.

Read [input, focus, and actions](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/input/index.html)
for propagation and text-input boundaries. The [keyboard walkthrough](@/examples/actions.md)
connects a focus handle, context, binding, and listener. The
[focus guide](@/guides/focus.md) helps diagnose a shortcut that does nothing.
