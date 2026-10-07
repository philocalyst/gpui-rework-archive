# Input, focus, and actions

Element callbacks receive the [`Window`](crate::Window) and [`App`](crate::App)
that are dispatching the event. Use [`Context::listener`](crate::Context::listener)
when a callback needs to update the view that built its element.

## Activation and pointer events

Use [`on_click`](crate::StatefulInteractiveElement::on_click) for primary activation.
Its [`ClickEvent`](crate::ClickEvent) can represent a completed mouse click,
keyboard activation, or a recognized touch tap. Use `on_mouse_down` when the
operation starts on a mouse press, such as beginning a drag. A mouse press and
an activation are different events.

[`on_aux_click`](crate::StatefulInteractiveElement::on_aux_click) handles secondary
activation, including a right click or touch long press. Do not require a mouse
position from every click: [`ClickEvent::mouse_position`](crate::ClickEvent::mouse_position)
returns `None` for keyboard and touch activation.

Give an interactive element a stable ID to retain its press and hover state
across frames. Pointer hitboxes determine where it receives input; keyboard
activation follows the attached focus path.

## Propagation has two defaults

> [!NOTE]
> Ordinary input handlers propagate by default. Call
> [`App::stop_propagation`](crate::App::stop_propagation) to prevent later handlers
> from seeing that event. A bubbling action handler stops by default: call
> [`App::propagate`](crate::App::propagate) when an ancestor should have a chance
> to handle the action.

This handler consumes Save when it can save and passes it to its ancestor
otherwise:

```rust,standalone_crate
use gpui::{Context, IntoElement, actions, div, prelude::*};

actions!(documentation_input, [Save]);
struct Editor { can_save: bool, saves: usize }

fn save_handler(cx: &mut Context<Editor>) -> impl IntoElement {
    div().on_action(cx.listener(|editor, _: &Save, _, cx| {
        if editor.can_save {
            editor.saves += 1;
            cx.notify();
        } else {
            cx.propagate();
        }
    }))
}
```

Capture dispatch visits ancestors toward the target; bubble dispatch travels
back toward ancestors. Stopping propagation affects subsequent handlers, not
work an earlier handler already performed.
[`Window::prevent_default`](crate::Window::prevent_default) has a separate
purpose: it prevents applicable GPUI default behaviors, including parent focus
on mouse-down and touch gesture claiming. It does not promise to cancel every
native or browser default action.

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
