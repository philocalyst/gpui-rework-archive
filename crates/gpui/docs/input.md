# Input, focus, and actions

GPUI input has three distinct stages: the platform reports an input event, GPUI routes it through
the rendered element tree, and a component decides whether that input changes its state. Pointer
events target the topmost eligible hitbox at the pointer position; keyboard events target the
currently focused node. A [hitbox](crate::Hitbox) is the rectangular input region recorded for an
element, and its [behavior](crate::HitboxBehavior) determines whether it blocks or occludes
hitboxes behind it.

Element callbacks receive the [`Window`](crate::Window) and [`App`](crate::App) that are
dispatching the event. Use [`Context::listener`](crate::Context::listener) when a callback needs
to update the view that built its element. The listener is invoked later during event dispatch;
the context itself is not retained.

## Event routing and propagation

Most element input callbacks run in the bubble phase. GPUI first runs capture handlers from the
root toward the target, then bubble handlers from the target back toward the root. For pointer
events the target comes from hit testing and occlusion; for keyboard events it comes from the
focus path. APIs named `capture_*` register a capture-phase callback; APIs such as `on_mouse_down`
and `on_key_down` register bubble-phase callbacks. Some event families, including click
activation, expose only their standard callback API.

Ordinary event handlers propagate by default. Call [`App::stop_propagation`](crate::App::stop_propagation)
to stop later handlers on the route. Capture handlers run before bubble handlers, so stopping
propagation during capture also prevents the bubble phase. Stopping propagation does not undo
work an earlier handler already performed.

Action dispatch uses the same capture-then-bubble shape, with one important default difference:
action handlers stop propagation when the bubble phase reaches a handler. Call
[`App::propagate`](crate::App::propagate) from that handler when an ancestor or a global action
handler should also get a chance to handle it. Capture-phase action handlers can stop dispatch
with `stop_propagation`.

[`Window::prevent_default`](crate::Window::prevent_default) controls GPUI behavior associated
with an event; it is separate from stopping propagation. For example, it can prevent the usual
focus change on mouse-down or claim a touch long press. It does not cancel every operating-system
or browser default action.

## Pointer activation

Use [`on_click`](crate::StatefulInteractiveElement::on_click) for primary activation. Its
[`ClickEvent`](crate::ClickEvent) can represent a completed mouse click or keyboard activation of
the focused element. GPUI's portable touch recognizer currently synthesizes a mouse press/release
for a tap, so existing click handlers work through the mouse path. Use `on_mouse_down` when work
starts on a press, such as beginning a drag; a press is not the same event as completed activation.
Use [`on_aux_click`](crate::StatefulInteractiveElement::on_aux_click) for secondary click
activation such as a right-click. The portable recognizer reports a long press through phased
[`LongPressEvent`](crate::LongPressEvent) events; custom long-press behavior can observe those
through the low-level mouse-event listener API.

Do not assume a click has a physical cursor position. [`ClickEvent::mouse_position`](crate::ClickEvent::mouse_position)
returns `Some` only for the `Mouse` variant; because GPUI currently maps portable touch taps to
synthesized mouse press/release events, `Some` does not prove that a physical mouse produced the
click. `position()` is available for all click variants, but for keyboard activation it is the
bottom-left corner of the focused element's bounds; it is not a pointer location. Check
`standard_click()`, `is_secondary()`, `is_middle_click()`, or `click_count()` when the distinction
matters.

Interactive elements need stable IDs when their hover, pressed, or other retained element state
must survive a rerender. Pointer delivery is governed by hitboxes and their occlusion behavior;
adding an event callback does not make a visually covered region receive the pointer. Pointer
capture is a separate mechanism for continuing mouse move/up delivery after a drag leaves its
starting hitbox; GPUI releases it on mouse-up.

Raw touch updates are keyed by [`TouchId`](crate::TouchId) from `Started` through `Ended` or
`Cancelled`; cancellation drops provisional state without completing a tap. The portable
recognizer keeps a new contact pending while it can still become a tap or long press. With the
default [`GestureTuning`](crate::GestureTuning), movement past 8 px resolves to a pan, a long
press is offered after 500 ms within that slop, and taps can accumulate a count within 400 ms and
16 px. These are default feel values, not universal platform guarantees. A tap is delivered as a
synthesized mouse press/release, a pan as phased scroll-wheel events, and a long press as phased
`LongPressEvent`s (with `TouchDragEvent` available for elements that claim a touch drag).
The portable recognizer does not currently recognize pinch gestures.

## Keyboard focus

A [`FocusHandle`](crate::FocusHandle) names a focusable identity. Keep the handle with the view,
attach it to the rendered subtree with `track_focus`, and call [`Window::focus`](crate::Window::focus)
to request that it become the keyboard target. Creating or attaching the handle does not itself
request focus. If the handle has no node in the current rendered dispatch tree, key handlers have
no element node to target (dispatch falls back to the root); attach the handle before relying on
it to receive element-level keyboard input.

Focus is separate from visual selection, hover, and domain state. A list can keep one selected row
while a search field owns keyboard focus. Tab navigation uses the recorded focus handles and tab
order; custom widgets that change focus order should use the tab-stop APIs on their focus handles.
An embedded browser can also have two focus systems: the page must focus its iframe before the
GPUI window can receive keys.

## Actions and key bindings

An [`Action`](crate::Action) is a type-safe command such as “save” or “move to the next row.” A
key binding maps one or more keystrokes to an action when its context predicate matches. An action
listener handles the command on the dispatch path. Menus and application code can invoke the same
operation directly without synthesizing its keyboard shortcut.

This editor handles `Save` when it can save and lets the action continue to an ancestor otherwise.
The binding is installed once during application setup; the focused editor contributes its context
and listener when it renders:

```rust,standalone_crate
use gpui::{actions, div, prelude::*, App, Context, FocusHandle, IntoElement, KeyBinding, Render, Window};

actions!(documentation_input, [Save]);

struct Editor {
    focus_handle: FocusHandle,
    can_save: bool,
    saves: usize,
}

impl Editor {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            focus_handle: cx.focus_handle(),
            can_save: true,
            saves: 0,
        }
    }

    fn focus(&self, window: &mut Window, cx: &mut App) {
        window.focus(&self.focus_handle, cx);
    }
}

impl Render for Editor {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .track_focus(&self.focus_handle)
            .key_context("Editor")
            .on_action(cx.listener(|editor, _: &Save, _, cx| {
                if editor.can_save {
                    editor.saves += 1;
                    cx.notify();
                } else {
                    cx.propagate();
                }
            }))
    }
}

fn bind_save(cx: &mut App) {
    cx.bind_keys([KeyBinding::new("cmd-s", Save, Some("Editor"))]);
}
```

Use `actions!` for simple unit actions. Derive `Action` for actions with data; JSON-loaded actions
need `serde::Deserialize` and `schemars::JsonSchema` unless declared with `#[action(no_json)]`.
Action names are registered globally, so registering duplicate names panics during app startup.

Install application bindings with [`App::bind_keys`](crate::App::bind_keys), usually during app
setup. Add `key_context("Editor")` to the relevant subtree and register its action listener
there. Key contexts are collected along the focused node's ancestor path. A binding predicate can
match an identifier (`Editor`), a key-value pair (`mode == insert`), or combine predicates with
`&&`, `||`, `!`, and the descendant operator (`Workspace > Editor`). These terms are parsed by
[`KeyBindingContextPredicate`](crate::KeyBindingContextPredicate).

For programmatic bindings, [`KeyBinding::new`](crate::KeyBinding::new) panics when a keystroke or
context string is invalid. [`KeyBinding::load`](crate::KeyBinding::load) returns
[`InvalidKeystrokeError`](crate::InvalidKeystrokeError) for malformed keystrokes; parse the
context predicate separately so its error can be reported alongside the binding source.

When bindings compete, a match at a deeper context wins; at the same depth, later bindings win.
An unqualified binding is eligible at the deepest context. This lets a user binding appended
after built-in bindings override a built-in binding while a focused editor can override a
workspace shortcut. See [`Keymap::bindings_for_input`](crate::Keymap::bindings_for_input) for
disabled-binding and prefix details.

Separate keystrokes with spaces to define a chord, for example `cmd-k left`. While a prefix can
still complete a longer binding, GPUI holds it pending. If the chord does not complete, GPUI
flushes the pending input after about one second and can replay the prefix as a regular key event
or action. Pending input belongs to the focus that started it and is discarded when focus changes.
When a printable key may belong to an active text input, GPUI also allows the input handler's IME
policy to resolve that ambiguity before committing to a key binding.

Use raw key handlers when the keystroke itself matters, for example for editor navigation or
terminal input. Use actions when several input routes should invoke the same operation. Application
keystroke interceptors run before key binding resolution and can stop it; element key-down/up
handlers run after key binding matching when no binding has consumed the keystroke. Text
composition, candidate selection, and replacement ranges must use the input-handler contract;
seeing a printable [`KeyDownEvent`](crate::KeyDownEvent) does not model an IME session.

## Text input and offsets

Implement [`EntityInputHandler`](crate::EntityInputHandler) for a text-editing view, create an
[`ElementInputHandler`](crate::ElementInputHandler) with the painted element's bounds, and assign
it during paint with [`Window::handle_input`](crate::Window::handle_input). GPUI calls the handler
to read and replace text, manage marked text during IME composition, report selection and geometry,
and accept platform paste. Treat these callbacks as part of the platform text-input protocol, not
as ordinary key events. The [`InputHandler`](crate::InputHandler) contract documents each callback
and its optional return values.

GPUI's ordinary text layout and Rust strings use UTF-8 byte offsets. The platform input-handler
contract uses UTF-16 code-unit ranges. Neither offset measures a user-perceived character: a
combining sequence or emoji may contain several code points, and grapheme boundaries are a
separate concern. Convert at the boundary with [`utf8_to_utf16_offset`](crate::utf8_to_utf16_offset)
and [`utf16_to_utf8_offset`](crate::utf16_to_utf8_offset). These helpers clamp offsets past the
end of the string and snap offsets inside an encoded character to that character's end; they do
not choose grapheme boundaries. Use grapheme segmentation when implementing user-visible cursor
movement.

## Accessibility actions and identities

Programmatic accessibility has its own action type, [`AccessibleAction`](crate::AccessibleAction),
which is unrelated to GPUI's keyboard/menu [`Action`](crate::Action). Give reported controls stable
element IDs and an accessibility role; use a label or value that explains the control's purpose.
Built-in click handlers also expose the accessibility click action. Custom controls can handle
other accessible actions with `on_a11y_action`. [`aria_hidden`](crate::StatefulInteractiveElement::aria_hidden)
hides a subtree from assistive technology while leaving its rendering and input handlers intact,
so do not hide focusable content.

Custom elements can provide synthetic accessibility descendants when their visual implementation
does not correspond to the semantic structure assistive technology needs, such as text runs inside
a custom text editor. Synthetic node IDs must remain stable for the logical descendants across
frames. See the [accessibility module guide](crate::_accessibility) for the ID, role, hidden
subtree, and synthetic-child rules.

The [actions walkthrough](https://gpui-ce.github.io/examples/actions/#focus) connects the focus
handle, key context, binding, and listener in one program.
