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

## Connect Tab to the focus order

Register each control with `tab_index(0)`, or mark its retained focus handle
with `tab_stop(true)`. Then route Tab to `window.focus_next(cx)` and Shift+Tab
to `window.focus_prev(cx)` on an ancestor of those controls. Recording the
stops alone does not install traversal. Give the window an initial rendered
focus target so that ancestor is on the first key's route.

The [counter's root listener](@/examples/counter.md#render) shows the setup;
the [input chapter's executed example](https://gpui-ce.github.io/book/input.html#connect-tab-to-traversal)
checks both directions through dispatch. A child editor can consume Tab for
indentation before the root handles it. The browser examples reserve Escape
to return to the surrounding page, which provides a way out of the wrapped
GPUI focus order.

## Bind an operation

Define a typed action for an operation, then bind one or more key sequences to
it during app setup. Give the target element a key context and an action
listener. The binding's optional context predicate scopes where the shortcut
applies. This makes the operation reusable from a menu, command palette, or
different shortcut without pretending those inputs were keyboard events.

A menu can dispatch the same action. This keeps “save” independent of the key
combination that happens to trigger it on one platform. Use a raw key listener
when the keystroke itself matters, such as navigation by a physical key.
Use the [text-input protocol](https://gpui-ce.github.io/book/input.html#text-input-and-offsets)
for composed text, replacement, and selection; a printable key event cannot
describe those operations.

## Diagnose a shortcut that does nothing

Draw after changing the target's ancestry or key context, then inspect the
focus and binding state. Selection changes immediately; contexts and
listeners come from the last rendered tree. A browser preview also needs
page focus inside its iframe.

1. **Check the selected identity** with
   [`window.focused(cx)`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.focused).
   Keep the handle, attach it with `track_focus`, then request focus. A selected
   handle can still be absent from the rendered tree.
2. **Check the context path** with
   [`window.context_stack()`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.context_stack).
   Put the context on the target or an ancestor, then match the binding's
   predicate against that path.
3. **Check the command's shortcut** with
   [`window.highest_precedence_binding_for_action(&action)`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.highest_precedence_binding_for_action).
   Check the strokes, context, removals, and later competing bindings. The
   action's data must match too.
4. **Check for a listener** with
   [`window.is_action_available(&action, cx)`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.is_action_available).
   Register the listener on the focused path.
   [`App::is_action_available`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.App.html#method.is_action_available)
   checks globals and the accessible active window. Presence alone does not
   prove the handler accepts the current state.
5. **Check for a pending chord** with
   [`window.has_pending_keystrokes()`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.has_pending_keystrokes).
   Complete the chord or check its
   [replay rules](https://gpui-ce.github.io/book/input.html#wait-for-a-pending-chord).

If a container owns the focused handle, put its keyboard listener on that
container or an ancestor. A listener on a canvas child is outside the route;
the focused container does not forward keys into its descendants. The
[input chapter's routing section](https://gpui-ce.github.io/book/input.html#put-listeners-on-the-focused-path)
explains how the same rule affects key contexts and action handlers.

A capture handler may stop propagation before a later handler sees the event.
A bubbling action handler consumes the action by default; call
`cx.propagate()` when an ancestor should handle it too. Ordinary event
listeners continue by default and call `cx.stop_propagation()` to stop. A
multi-stroke key prefix may also be waiting for another stroke. These have
different causes and fixes; see [input and actions](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/input/index.html)
and the [`Keymap`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Keymap.html)
reference before adding a global key listener.

The [binding test](https://gpui-ce.github.io/book/testing.html#check-the-key-binding-as-well-as-its-action)
keeps a listener installed in two modes and checks that the shortcut reaches
it only in edit mode. The
[focus test](https://gpui-ce.github.io/book/testing.html#check-focus-against-the-rendered-tree)
separately checks selection and rendered ancestry. These catch different
failures; directly calling the action handler catches neither.

## Keep selection separate

Keyboard focus answers where keys go. Selection answers which domain object is
selected. Hover answers where the pointer is. A list can preserve its selection
while a search field has focus; changing one need not reset the other.
