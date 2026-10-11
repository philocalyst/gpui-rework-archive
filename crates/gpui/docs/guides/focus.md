# Manage focus

Exactly one element in a window has keyboard focus. Create a [`FocusHandle`] for
each element that should take focus, attach it with
[`track_focus`](crate::InteractiveElement::track_focus), and move focus with
[`Window::focus`]. Keys then travel from the focused element outward, as the
[input dispatch](crate::_documentation::concepts::input_dispatch) page explains.

## Create and track a focus handle

Create a handle with [`App::focus_handle`], which is `cx.focus_handle()` in a
view. Store it in the view, so it lives as long as the view does. Pass it to
`track_focus` in `render`. An element that tracks a handle can take focus, from a
click or from your code.

```standalone_crate
use gpui::{Context, FocusHandle, TestApp, Window, div, prelude::*};

struct Search {
    focus_handle: FocusHandle,
}

impl Render for Search {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().track_focus(&self.focus_handle).child("Search")
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, cx| Search { focus_handle: cx.focus_handle() });

window.update(|search, window, cx| window.focus(&search.focus_handle, cx));
assert!(window.update(|search, window, _| search.focus_handle.is_focused(window)));
```

## Focus an element

[`Window::focus`] moves focus to the element that tracks a handle, and
[`FocusHandle::focus`] does the same from the handle. Both take `cx`, because
focus is app state. [`Window::blur`] removes focus from the window entirely. Focus
styles apply on the next draw, and keys follow the new focus path from then on.

If a view implements [`Focusable`], you can focus it without knowing its handle.
An `Entity<V>` implements `Focusable` when `V` does, so `view.focus_handle(cx)`
works on the entity you hold.

```standalone_crate
use gpui::{App, Context, FocusHandle, Focusable, TestApp, Window, div, prelude::*};

struct Search {
    focus_handle: FocusHandle,
}

impl Focusable for Search {
    fn focus_handle(&self, _cx: &App) -> FocusHandle {
        self.focus_handle.clone()
    }
}

impl Render for Search {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().track_focus(&self.focus_handle)
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, cx| Search { focus_handle: cx.focus_handle() });

window.update(|search, window, cx| window.focus(&search.focus_handle(cx), cx));
assert!(window.update(|search, window, _| search.focus_handle.is_focused(window)));

window.update(|_, window, cx| window.blur(cx));
assert!(!window.update(|search, window, _| search.focus_handle.is_focused(window)));
```

## Ask what has focus

[`FocusHandle::is_focused`] is true only for the focused element itself.
[`FocusHandle::contains_focused`] is also true when the focused element is a
descendant. That is how a panel can react while a field inside it has focus.
[`Window::focused`] returns the focused handle, if there is one.

These queries need the window, and `contains_focused` also needs `cx`. Call them
inside [`TestAppWindow::update`](crate::TestAppWindow::update) or in your own
`render` and event handlers, where you have a `&Window`.

## Set the tab order

Tab order follows each handle's [`tab_index`](FocusHandle::tab_index), lowest first.
Handles with the same index follow the order they were painted in. A handle can
only be reached with Tab when it is a tab stop, and [`FocusHandle::tab_index`]
doesn't make it one. Call [`FocusHandle::tab_stop`] too.

Set both on the handle you pass to `track_focus`. The
[`InteractiveElement::tab_index`](crate::InteractiveElement::tab_index) method only
applies to elements that create their own handle, which is an element with no
`track_focus` call. If you use `track_focus`, the index belongs on the handle:

```rust
# use gpui::{App, FocusHandle};
fn field(cx: &App, order: isize) -> FocusHandle {
    cx.focus_handle().tab_index(order).tab_stop(true)
}
```

Tab order is independent of layout. Handles are ordered by index, not by where
they appear on screen, so give each field the index you want the user to reach.

## Move focus with Tab

GPUI doesn't bind Tab, so bind it yourself. Bind Tab and Shift-Tab to actions,
and call [`Window::focus_next`] or [`Window::focus_prev`] in the handlers. The
example below scopes the bindings to a `Form` context, moves focus through three
fields, and wraps around.

```standalone_crate
use gpui::{Context, FocusHandle, KeyBinding, TestApp, Window, actions, div, prelude::*};

actions!(focus_tab, [NextField, PreviousField]);

struct Form {
    focus_handle: FocusHandle,
    fields: Vec<FocusHandle>,
}

impl Render for Form {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .key_context("Form")
            .track_focus(&self.focus_handle)
            .on_action(cx.listener(|_, _: &NextField, window, cx| window.focus_next(cx)))
            .on_action(cx.listener(|_, _: &PreviousField, window, cx| window.focus_prev(cx)))
            .children(self.fields.iter().map(|handle| {
                div().track_focus(handle).child("Field")
            }))
    }
}

let mut app = TestApp::new();
app.update(|cx| {
    cx.bind_keys([
        KeyBinding::new("tab", NextField, Some("Form")),
        KeyBinding::new("shift-tab", PreviousField, Some("Form")),
    ]);
});

let mut window = app.open_window(|_, cx| Form {
    focus_handle: cx.focus_handle(),
    fields: (0..3).map(|order| cx.focus_handle().tab_index(order).tab_stop(true)).collect(),
});

let focused_field = |window: &mut gpui::TestAppWindow<Form>| {
    window.update(|form, window, _| form.fields.iter().position(|field| field.is_focused(window)))
};

window.update(|form, window, cx| window.focus(&form.focus_handle, cx));

window.simulate_keystrokes("tab");
assert_eq!(focused_field(&mut window), Some(0));

window.simulate_keystrokes("tab tab");
assert_eq!(focused_field(&mut window), Some(2));

window.simulate_keystrokes("tab");
assert_eq!(focused_field(&mut window), Some(0));

window.simulate_keystrokes("shift-tab");
assert_eq!(focused_field(&mut window), Some(2));
```

A focused multiline text field takes Tab for itself. Its default binding inserts
a tab character, so Tab won't reach your `Form` binding while it has focus. A
single-line text field passes Tab on, so your binding works there. For multiline
fields, use a different key, or call `focus_next` from a button.

## Style focused elements

Three style methods change an element's look based on focus. Each one applies
only to elements that track a handle.

- [`focus`](crate::InteractiveElement::focus) applies when the element itself is
  focused.
- [`in_focus`](crate::InteractiveElement::in_focus) applies when the element or
  one of its descendants is focused.
- [`focus_visible`](crate::InteractiveElement::focus_visible) applies when the
  element is focused and the last input was from the keyboard. Use it for focus
  rings that shouldn't appear after a mouse click.

```rust
# use gpui::{Context, FocusHandle, Window, div, prelude::*, rgb};
# struct Field { focus_handle: FocusHandle }
# impl Render for Field {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
div()
    .track_focus(&self.focus_handle)
    .border_2()
    .border_color(rgb(0x3b3b3b))
    .focus(|style| style.border_color(rgb(0x3b82f6)))
    .focus_visible(|style| style.bg(rgb(0x1e3a8a)))
    .child("Name")
#     }
# }
```

## React to focus changes

To run code when focus moves, register a listener on the view's
[`Context`](crate::Context) and keep the returned [`Subscription`](crate::Subscription)
alive. The listener is dropped when the subscription is. [`Context::on_focus`] fires
when the handle itself gains focus. [`Context::on_blur`] fires when it loses focus.
[`Context::on_focus_in`] and [`Context::on_focus_out`] also count descendants.
[`Context::on_focus_lost`] fires when nothing in the window has focus, which is a
good moment to pick a fallback. For a listener that isn't tied to a view, use the
window's [`Window::on_focus_in`] and [`Window::on_focus_out`].

Focus listeners run while the window draws, so they fire on the next frame. They
only run in the active window. Windows in a test start inactive, so the example
activates its window first.

```standalone_crate
use gpui::{Context, FocusHandle, Subscription, TestApp, Window, div, prelude::*};

struct Field {
    focus_handle: FocusHandle,
    events: Vec<&'static str>,
    _subscriptions: Vec<Subscription>,
}

impl Render for Field {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().track_focus(&self.focus_handle)
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, cx| Field {
    focus_handle: cx.focus_handle(),
    events: Vec::new(),
    _subscriptions: Vec::new(),
});
window.activate();

window.update(|field, window, cx| {
    let handle = field.focus_handle.clone();
    let focus = cx.on_focus(&handle, window, |field, _, _| field.events.push("focus"));
    let blur = cx.on_blur(&handle, window, |field, _, _| field.events.push("blur"));
    field._subscriptions.extend([focus, blur]);
    window.focus(&handle, cx);
});
window.draw();
assert_eq!(window.read(|field, _| field.events.clone()), ["focus"]);

window.update(|_, window, cx| window.blur(cx));
window.draw();
assert_eq!(window.read(|field, _| field.events.clone()), ["focus", "blur"]);
```

## See also

- [Handle keyboard shortcuts](crate::_documentation::guides::keyboard) covers the
  actions that Tab and Shift-Tab are bound to.
- [Respond to the mouse and touch](crate::_documentation::guides::mouse_and_touch)
  covers clicks, which also move focus to an element that tracks a handle.
- [Accept text input](crate::_documentation::guides::text_input) covers the text
  fields that keep Tab for themselves.
- [Input and dispatch](crate::_documentation::concepts::input_dispatch) explains the
  focus path that keys follow.
