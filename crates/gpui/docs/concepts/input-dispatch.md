# Input and dispatch

GPUI routes the two kinds of input differently. The mouse goes to *where* the
pointer is. The keyboard goes to *what has focus*, and most keystrokes are first
turned into *actions*. This page explains both paths, so you can predict which
handler runs and why.

## Mouse events

During [paint](crate::_documentation::concepts::the_frame), interactive
elements register mouse listeners with the window, along with the
[`Hitbox`] they inserted during prepaint. When the mouse moves or clicks, GPUI
tests the pointer against the hitboxes of the last frame and offers the event
to the listeners in two passes:

1. **Capture**, from the back of the window to the front, in the order the
   elements were painted. Use [`capture_any_mouse_down`](InteractiveElement::capture_any_mouse_down)
   and friends for this pass. It is for special cases, such as closing a popover
   when the user clicks outside it.
2. **Bubble**, from the front to the back. Ordinary handlers such as
   [`on_mouse_down`](InteractiveElement::on_mouse_down) and
   [`on_click`](StatefulInteractiveElement::on_click) run here, so the element
   on top gets the first chance to respond.

A listener runs only if the pointer is over its element (some listeners, such
as [`on_mouse_down_out`](InteractiveElement::on_mouse_down_out), ask for the
opposite). Call [`App::stop_propagation`] in a handler to keep the event from
reaching elements behind it.

```
# use gpui::{Context, MouseButton, TestApp, Window, div, point, prelude::*, px};
struct Layers {
    clicked: Vec<&'static str>,
}

impl Render for Layers {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .on_mouse_down(MouseButton::Left, cx.listener(|layers, _, _, _| {
                layers.clicked.push("back");
            }))
            .child(
                div()
                    .size(px(50.))
                    .on_mouse_down(MouseButton::Left, cx.listener(|layers, _, _, cx| {
                        layers.clicked.push("front");
                        cx.stop_propagation();
                    })),
            )
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, _| Layers { clicked: Vec::new() });

window.simulate_mouse_down(point(px(10.), px(10.)), MouseButton::Left);
window.simulate_mouse_down(point(px(200.), px(200.)), MouseButton::Left);
assert_eq!(window.read(|layers, _| layers.clicked.clone()), ["front", "back"]);
```

Because dispatch uses hitboxes, an element that draws over another doesn't block
the mouse unless it has a hitbox of its own. Give a floating panel
[`occlude`](InteractiveElement::occlude) to stop the pointer from reaching what's
beneath it.

## Focus

Exactly one element in a window can have keyboard focus. An element can take
focus if it tracks a [`FocusHandle`], which you create with
[`App::focus_handle`] and attach with
[`track_focus`](InteractiveElement::track_focus). Focus moves when the user
clicks a focusable element, and when your code calls [`Window::focus`].
[`Window::focus_next`] and [`Window::focus_prev`] move through the elements
that have a [`tab_index`](InteractiveElement::tab_index); GPUI doesn't bind
Tab to them for you, so bind it in your app.

Focus is a path, not a single element. The *focus path* runs from the window's
root down to the focused element, and keyboard input travels along it. An
element *contains* focus when the focused element is inside it, which is how a
whole panel can respond to keys while a text field inside it has focus. See the
[focus guide](crate::_documentation::guides::focus) for tab order and focus
styles.

## From keystrokes to actions

GPUI doesn't ask every element whether it cares about Cmd-S. Instead, you
declare what the app can *do* as [actions](Action), and a keymap maps
keystrokes to them:

```standalone_crate
use gpui::{App, KeyBinding, actions};

actions!(editor, [Save, Undo]);

fn bind_keys(cx: &mut App) {
    cx.bind_keys([
        KeyBinding::new("cmd-s", Save, Some("Editor")),
        KeyBinding::new("cmd-z", Undo, Some("Editor")),
    ]);
}
```

The third argument is a *key context*: the binding only applies when an element
on the focus path declared that context with
[`key_context`](InteractiveElement::key_context). Contexts let the same
keystroke mean different things in different places. Enter can submit a form in
one panel and insert a newline in an editor.

When a key is pressed, GPUI:

1. Looks up bindings for the keystroke whose context matches the focus path.
   Bindings for contexts deeper in the path win over shallower ones, and among
   bindings at the same depth, the one added last wins. A binding without a
   context counts as matching at the deepest level.
2. Dispatches the winning binding's action along the focus path. Handlers
   registered with [`on_action`](InteractiveElement::on_action) on elements in
   the path receive it.
3. Only if no action handled the keystroke, offers the raw key event to
   [`on_key_down`](InteractiveElement::on_key_down) and
   [`on_key_up`](InteractiveElement::on_key_up) listeners along the path.

Actions travel the focus path in two passes, like mouse events: a capture pass
from the root to the focused element, then a bubble pass back up. An action
handler in the bubble pass stops propagation automatically. Call
[`App::propagate`] in a handler that wants to let the action keep going, for
example because it decided not to handle it after all.

```standalone_crate
use gpui::{Context, FocusHandle, KeyBinding, TestApp, Window, actions, div, prelude::*};

actions!(editor, [Save]);

struct Editor {
    focus_handle: FocusHandle,
    saves: usize,
}

impl Render for Editor {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .key_context("Editor")
            .track_focus(&self.focus_handle)
            .on_action(cx.listener(|editor, _: &Save, _window, _cx| editor.saves += 1))
    }
}

let mut app = TestApp::new();
app.update(|cx| cx.bind_keys([KeyBinding::new("ctrl-s", Save, Some("Editor"))]));

let mut window = app.open_window(|window, cx| {
    let focus_handle = cx.focus_handle();
    window.focus(&focus_handle, cx);
    Editor { focus_handle, saves: 0 }
});

window.simulate_keystrokes("ctrl-s");
assert_eq!(window.read(|editor, _| editor.saves), 1);
```

Bindings can also be sequences, like `"cmd-k cmd-s"`. After the first keystroke
GPUI waits up to a second for the rest of the sequence before it gives up and
dispatches what it has.

Separating keystrokes from actions pays off in three ways. The same action can
be triggered from the keyboard, a menu, a command palette or a button. Users and
settings files can rebind keys without touching your code. And your code can ask
which keys are bound to an action, to show them in a tooltip or a menu, with
[`Window::bindings_for_action`].

## Application-wide actions

Some actions don't belong to any element: Quit, Open Settings, New Window.
Register those on the app with [`App::on_action`]. They run after element
handlers, if no element handled the action, and they work even when nothing has
focus.

## Text input

Typing text is different from pressing shortcuts. Input methods compose
characters across several keystrokes, and some keyboards produce text that no
single key represents. Elements that accept text, such as the editable text
elements in `gpui_ce_elements`, install an input handler that the platform
talks to directly. Keystrokes that don't match a binding become text for the
focused input handler. See the [text input
guide](crate::_documentation::guides::text_input).
