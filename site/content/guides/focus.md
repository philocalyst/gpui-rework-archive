+++
aliases = ["examples/interaction/", "guide/interactivity/actions-keymap/", "guide/interactivity/focus/", "interactivity/actions-keymap.html", "interactivity/focus.html"]
title = "Route focus and shortcuts"
description = "Connect keyboard focus to a key context and a typed action."
weight = 40
+++

Keep a [`FocusHandle`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.FocusHandle.html)
on the view, attach it to an element with `track_focus`, and focus it through
the window. The [actions walkthrough](@/examples/actions.md) contains all
three steps. A handle is an identity for a focus target; it does not itself
attach the target to the element tree or route a key to a listener.

## Bind an operation

Define a typed action for an operation, then bind one or more key sequences to
it during app setup. Give the target element a key context and an action
listener. The binding's optional context predicate scopes where the shortcut
applies. This makes the operation reusable from a menu, command palette, or
different shortcut without pretending those inputs were keyboard events.

A menu can dispatch the same action. This keeps “save” independent of the key
combination that happens to trigger it on one platform. Use a raw key listener
when the keystroke itself matters, such as editor movement or text handling.

## Diagnose a shortcut that does nothing

Check the focus target first. Then check whether the element carrying the
listener is on that target's dispatch path, and whether the context predicate
matches. A browser preview also needs page focus inside its iframe.

A capture handler may stop propagation before a later handler sees the event.
A bubbling action handler consumes the action by default; call
`cx.propagate()` when an ancestor should handle it too. Ordinary event
listeners continue by default and call `cx.stop_propagation()` to stop. A
multi-stroke key prefix may also be waiting for another stroke. These have
different causes and fixes; see [input and actions](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/input/index.html)
and the [`Keymap`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Keymap.html)
reference before adding a global key listener.

## Keep selection separate

Keyboard focus answers where keys go. Selection answers which domain object is
selected. Hover answers where the pointer is. A list can preserve its selection
while a search field has focus; changing one need not reset the other.
