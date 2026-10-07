# Input, focus, and actions

GPUI dispatches pointer input through hitboxes and keyboard input through the
focused element's dispatch path. A callback runs with the window and application
contexts that own that path. Input does not give a listener an independent
reference to application state.

## Pointer events

Give an interactive element a stable ID. Its hitbox, hover state, press state,
and listeners belong to that identity. A click is a completed press/release
interaction; it is not a synonym for every mouse-down event. Use the specific
mouse or pointer listener when the earlier event is the operation you need.

Capture handlers run from ancestors toward the target. Bubble handlers run
back toward ancestors. A handler can stop propagation through
[`App::stop_propagation`](crate::App::stop_propagation). Stopping propagation
changes which later handlers run; it does not undo state already changed by
an earlier handler. See [`InteractiveElement`](crate::InteractiveElement) for
the individual event contracts.

## Keyboard focus

A [`FocusHandle`](crate::FocusHandle) names a focusable identity. Keep it on
the view and attach it to the element tree with `track_focus`. Call
[`Window::focus`](crate::Window::focus) to select it. Merely creating the handle
does not make an element the keyboard target.

Focus is separate from visual selection, hover, and a component's domain state.
A list can keep one selected row while a search field has keyboard focus. An
embedded browser example also has two focus systems: the page must focus the
iframe before the GPUI window can receive its keys.

The [actions walkthrough](https://gpui-ce.github.io/examples/actions/#focus)
connects the handle, key context, binding, and listener in one program.

## Actions and key bindings

An [`Action`](crate::Action) names an operation such as “save” or “increment”.
A [`KeyBinding`](crate::KeyBinding) translates a keystroke into an action under
a matching key-context predicate. An action listener handles that operation
on the dispatch path. Menus and other input devices can dispatch the same action
without pretending to generate its keyboard shortcut.

Install application bindings during setup. Put context-specific handlers on
the relevant view. Context predicates are evaluated against the focus path's
key contexts. Shortcut precedence and multi-stroke handling are defined by
[`Keymap`](crate::Keymap), rather than by the order in which a view rendered.

Use raw key handlers when the keystroke itself is meaningful, as in a text
editor. Use actions when several input routes represent the same operation.
Text composition must go through the input-handler contract: a printable key
is not enough to model an IME.

## Text offsets

Ordinary text layout uses UTF-8 byte offsets. Native input handlers use UTF-16
ranges where their platform contract requires them. Neither offset measures
user-visible characters. A combining mark, emoji sequence, or shaped cluster
can contain several Unicode scalars.

Convert at the boundary and preserve valid encoding boundaries. See
[`EntityInputHandler`](crate::EntityInputHandler) and the
[Unicode text segmentation specification](https://www.unicode.org/reports/tr29/)
for the distinction between encoding offsets and grapheme movement.
