# Handle keyboard shortcuts

Declare what your app can do as actions, bind keystrokes to them, and handle
each action in the view that knows how to do it. The tools are
[`actions!`](crate::actions), `#[derive(Action)]`, [`KeyBinding::new`],
[`App::bind_keys`] and [`InteractiveElement::on_action`].

## Declare actions

An action is a type that names a command. For commands with no data, use
[`actions!`](crate::actions) with a namespace. The namespace becomes part of the
name (`editor::Save`), and keymaps refer to actions by that name.

For an action that carries data, derive [`Action`](crate::Action). The type needs
`Clone`, `PartialEq`, `serde::Deserialize` and `schemars::JsonSchema`, so that a
keymap file can supply the data. Add `#[action(no_json)]` to skip the last two.

```standalone_crate
use gpui::{Action, actions};

actions!(keyboard_declare, [Save, Undo]);

#[derive(Clone, PartialEq, serde::Deserialize, schemars::JsonSchema, Action)]
#[action(namespace = keyboard_declare)]
pub struct Find {
    pub query: String,
}
```

Action names must be unique across the app. Two actions with the same name panic
when the app starts, so give each area of the app its own namespace.

## Bind a key to an action

[`KeyBinding::new`] pairs a keystroke with an action and an optional key context.
Pass the bindings to [`App::bind_keys`] before you open windows. This example
binds Cmd-S or Ctrl-S, focuses a view that handles the action, and presses the key.

```standalone_crate
use gpui::{Context, FocusHandle, KeyBinding, TestApp, Window, actions, div, prelude::*};

actions!(keyboard_example, [Save]);

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
app.update(|cx| cx.bind_keys([KeyBinding::new("secondary-s", Save, Some("Editor"))]));

let mut window = app.open_window(|window, cx| {
    let focus_handle = cx.focus_handle();
    window.focus(&focus_handle, cx);
    Editor { focus_handle, saves: 0 }
});

window.simulate_keystrokes("secondary-s");
assert_eq!(window.read(|editor, _| editor.saves), 1);
```

The `Some("Editor")` argument is a key context. The binding applies only when an
element on the focus path declared `key_context("Editor")`. The action then travels
from the focused element up through its ancestors, as the
[input dispatch](crate::_documentation::concepts::input_dispatch) page describes.

## Write keystrokes

A keystroke is zero or more modifiers and a key, joined by dashes. These
modifiers are accepted:

| Written as | Meaning |
| --- | --- |
| `ctrl` | Control |
| `alt` | Option on macOS, Alt elsewhere |
| `shift` | Shift |
| `fn` | The function modifier |
| `cmd` | The platform modifier: Command on macOS, Super or Windows elsewhere. `super` and `win` are aliases. |
| `secondary` | `cmd` on macOS, `ctrl` elsewhere. Use it for shortcuts such as save and copy. |

Keys are names such as `enter`, `escape`, `tab`, `space`, `backspace`, `left`, or
a single character. An uppercase letter means Shift plus that letter, so `S` is
`shift-s`. Names are case-insensitive otherwise.

```standalone_crate
use gpui::Keystroke;

let save = Keystroke::parse("secondary-s").unwrap();
assert!(save.modifiers.secondary());

let capital = Keystroke::parse("S").unwrap();
assert!(capital.modifiers.shift);
assert_eq!(capital.key, "s");

assert!(Keystroke::parse("ctrl-shift-z").is_ok());
assert!(Keystroke::parse("hyper-z").is_err());
```

Prefer `secondary` to `cmd` or `ctrl`. It matches the platform convention without
a `cfg` in your code. `KeyBinding::new` panics on a keystroke or context that
doesn't parse, so bind literal strings there.

## Bind a sequence of keys

Separate keystrokes with spaces to bind a sequence. After the first keystroke,
GPUI waits up to one second for the rest, then gives up.

```standalone_crate
use gpui::{KeyBinding, actions};

actions!(keyboard_sequence, [OpenPalette]);

fn bindings() -> KeyBinding {
    KeyBinding::new("secondary-k secondary-o", OpenPalette, Some("Workspace"))
}
```

Pass the result to [`App::bind_keys`] like any other binding.

## Handle actions in a view

Attach [`on_action`](crate::InteractiveElement::on_action) with `cx.listener`, so
the callback gets your view's state. The handler runs when a focused element is the
element it's attached to or one of its descendants. Focus the element with
[`track_focus`](crate::InteractiveElement::track_focus), as the
[focus guide](crate::_documentation::guides::focus) describes.

A handler stops the action from reaching ancestors. Call [`App::propagate`] to let it
continue, for example when the action doesn't apply right now. If the action
propagates past every handler, GPUI tries the next binding for the same keystroke.
A single-line text input relies on this: its Enter and Tab handlers propagate, so
Enter reaches a `Submit` binding in the form around it, and Tab reaches the
surrounding view.

## Use key contexts

A context is a name, or a name with a value, set with
[`key_context`](crate::InteractiveElement::key_context). A predicate chooses which
contexts a binding applies to:

| Predicate | Matches when |
| --- | --- |
| `Editor` | The innermost context is named `Editor`. |
| `mode == insert`, `mode != insert` | The context has `mode` set (or not set) to `insert`. |
| `!ReadOnly` | No context on the focus path is named `ReadOnly`. |
| `Editor && mode == insert` | Both hold. |
| `Editor \|\| Preview` | Either holds. |
| `Panel > Editor` | An `Editor` context sits below a `Panel` context. |

Precedence from loosest to tightest is `>`, `||`, `&&`, `==` and `!=`, then `!`.
Add parentheses when you mix `>` with other operators.

```standalone_crate
use gpui::{KeyBindingContextPredicate, KeyContext};

let editor = KeyContext::parse("Editor mode = insert").unwrap();

let insert = KeyBindingContextPredicate::parse("Editor && mode == insert && !ReadOnly").unwrap();
assert!(insert.eval(&[editor.clone()]));

let not_insert = KeyBindingContextPredicate::parse("Editor && mode != insert").unwrap();
assert!(!not_insert.eval(&[editor]));

let nested = KeyBindingContextPredicate::parse("Panel > Editor").unwrap();
let panel = KeyContext::parse("Panel").unwrap();
let field = KeyContext::parse("Editor").unwrap();
assert!(nested.eval(&[panel, field]));
```

Contexts let one keystroke mean different things in different places. Enter can
submit a form in one panel and insert a newline in an editor.

## Show the shortcut for an action

To show a shortcut in a menu, tooltip or command palette, ask the window.
[`Window::keystroke_text_for`] returns the highest-precedence binding for the
action on the focus path, formatted for the platform. Use
[`Window::bindings_for_action`] when you need every binding.

```standalone_crate
use gpui::{Context, FocusHandle, KeyBinding, TestApp, Window, actions, div, prelude::*};

actions!(keyboard_display, [Save]);

struct Editor {
    focus_handle: FocusHandle,
}

impl Render for Editor {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().key_context("Editor").track_focus(&self.focus_handle)
    }
}

let mut app = TestApp::new();
app.update(|cx| cx.bind_keys([KeyBinding::new("secondary-s", Save, Some("Editor"))]));

let mut window = app.open_window(|window, cx| {
    let focus_handle = cx.focus_handle();
    window.focus(&focus_handle, cx);
    Editor { focus_handle }
});

let shortcut = window.update(|_, window, _| window.keystroke_text_for(&Save));
assert!(shortcut.ends_with('S'));
```

The text is platform-formatted: `⌘S` on macOS and `ctrl-S` elsewhere. Show it as
is, and don't parse it. Lookups read the last frame drawn, so before the first
frame `keystroke_text_for` returns the action's name instead.

## Handle app-wide actions

Some actions belong to no element, such as Quit or Open Settings. Register them
with [`App::on_action`]. These handlers run at the end of the bubble phase, only
when no element handled the action, and they work even when nothing has focus.

```standalone_crate
use std::{cell::Cell, rc::Rc};

use gpui::{App, Context, FocusHandle, KeyBinding, TestApp, Window, actions, div, prelude::*};

actions!(keyboard_app, [Quit]);

struct Root {
    focus_handle: FocusHandle,
}

impl Render for Root {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().track_focus(&self.focus_handle)
    }
}

let quits = Rc::new(Cell::new(0));
let mut app = TestApp::new();
app.update(|cx| {
    cx.bind_keys([KeyBinding::new("secondary-q", Quit, None)]);
    let quits = quits.clone();
    cx.on_action(move |_: &Quit, _: &mut App| quits.set(quits.get() + 1));
});

let mut window = app.open_window(|window, cx| {
    let focus_handle = cx.focus_handle();
    window.focus(&focus_handle, cx);
    Root { focus_handle }
});

window.simulate_keystrokes("secondary-q");
assert_eq!(quits.get(), 1);
```

## Handle raw key events

Bindings cover the keys you name. For the rest, attach
[`on_key_down`](crate::InteractiveElement::on_key_down) or
[`on_key_up`](crate::InteractiveElement::on_key_up). These run only for keystrokes
that no action handled, and they follow the focus path. Read the key from
`event.keystroke`.

```standalone_crate
use gpui::{FocusHandle, KeyDownEvent, div, prelude::*};

fn pad(focus: &FocusHandle) -> impl IntoElement {
    div().track_focus(focus).on_key_down(|event: &KeyDownEvent, _window, _cx| {
        if event.keystroke.key == "escape" {
            // Close the pad here.
        }
    })
}
```

Use raw handlers for keys you can't bind, such as a canvas that reads arbitrary
keys. For shortcuts, prefer actions. Users can rebind actions, and menus and
tooltips can show them. A raw handler gets neither.

## See also

- [Input and dispatch](crate::_documentation::concepts::input_dispatch) explains
  how GPUI picks the handler for a keystroke.
- [Manage focus](crate::_documentation::guides::focus) covers the focus path that
  actions travel.
- [Accept text input](crate::_documentation::guides::text_input) covers typed text
  and the default editing bindings.
- The [keyboard example](crate::_documentation::examples::keyboard) shows these
  pieces in a running app. Run it with `cargo run --example keyboard`.
