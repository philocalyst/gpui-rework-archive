+++
aliases = ["examples/interaction/", "guide/interactivity/actions-keymap/", "guide/interactivity/focus/", "interactivity/actions-keymap.html", "interactivity/focus.html"]
title = "Route focus and shortcuts"
description = "Connect keyboard focus to a key context and a typed action."
weight = 40
+++

Keep a `FocusHandle` on the view, attach it to an element with `track_focus`,
and focus it through the window. The [actions walkthrough](@/examples/actions.md)
contains all three steps. An unattached handle cannot create a dispatch path.

## Bind an operation

Define an action for an operation, then bind a key to it during app setup.
Give the target element a key context and an action listener. The binding's
context predicate decides where that shortcut applies.

A menu can dispatch the same action. This keeps “save” independent of the key
combination that happens to trigger it on one platform. Use a raw key listener
when the keystroke itself matters, such as editor movement or text handling.

## Diagnose a shortcut that does nothing

Check the focus target first. Then check whether the element carrying the
listener is on that target's dispatch path, and whether the context predicate
matches. A browser preview also needs page focus inside its iframe.

A capture handler may stop propagation before a later handler sees the event.
A key prefix may be waiting for another stroke. Those cases have different
contracts; see [input and actions](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/input/index.html)
and the `Keymap` reference instead of adding another global handler.

## Keep selection separate

Keyboard focus answers where keys go. Selection answers which domain object is
selected. Hover answers where the pointer is. A list can preserve its selection
while a search field has focus; changing one need not reset the other.
