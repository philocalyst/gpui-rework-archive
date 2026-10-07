# Key dispatch

Use a key binding when a keystroke should invoke a named operation. The binding produces an
[`Action`](crate::Action); an element listener decides what that action does. This keeps the
operation reusable from menus or code that invoke it directly and keeps shortcut policy in the
application keymap.

## Define, bind, and handle an action

Use `actions!` for unit actions, or derive `Action` for an action with a payload. An action's
registered name includes its namespace. Payload actions loaded from JSON need
`serde::Deserialize` and `schemars::JsonSchema`; `#[action(no_json)]` opts out of that
configuration path.

This example installs a shortcut and handles it on the focused editor. If the editor cannot save,
it lets the action continue up the element tree:

```rust,standalone_crate
use gpui::{actions, div, prelude::*, App, Context, FocusHandle, IntoElement, KeyBinding, Render, Window};

actions!(editor, [Save]);

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

Call `bind_save` during app setup. `key_context("Editor")` contributes a context to the rendered
dispatch path; it does not grant focus. Attach a [`FocusHandle`](crate::FocusHandle) to the
element with `track_focus` and request it with [`Window::focus`](crate::Window::focus) when the
editor should receive keyboard input. See [Input, focus, and actions](input.md) for focus, event
propagation, raw-key versus action routing, and text input.

## Contexts and precedence

The keymap checks a binding's context predicate against the contexts on the focused node's
ancestor path. A plain identifier matches a context such as `Editor`; a key-value predicate
matches state such as `mode == insert`. Combine terms with `&&`, `||`, and `!`; use `>` to require
one context below another, as in `Workspace > Editor`. The
[`KeyBindingContextPredicate`](crate::KeyBindingContextPredicate) parser returns an error for
malformed expressions.

The deepest matching context has precedence. Bindings at the same depth are considered in reverse
insertion order, so later additions win ties. An unqualified binding is eligible at the deepest
depth. This allows an editor shortcut to override a workspace shortcut and user bindings appended
after built-in bindings to override a built-in binding. Disabled bindings (`NoAction` in code or
`null` in a keymap file) and `Unbind` entries suppress matching bindings according to their
context and source precedence; see [`Keymap::bindings_for_input`](crate::Keymap::bindings_for_input).

For example, a Zed-style keymap entry binds a simple action by its registered name. The array and
entry shape belong to the application that loads the file; GPUI itself does not define a keymap
file format:

```json
[
  {
    "context": "Editor && mode == insert",
    "bindings": {
      "cmd-s": "editor::Save"
    }
  }
]
```

The exact keymap file envelope belongs to the application that loads it. Action names and
serialized payloads are interpreted by that application's action registry. Invalid action names
or payloads are reported by [`ActionBuildError`](crate::ActionBuildError); invalid keystrokes
return [`InvalidKeystrokeError`](crate::InvalidKeystrokeError). `KeyBinding::new` is a convenient
constructor that panics if its keystroke or context fails to parse; use `KeyBinding::load` when
configuration errors need to be handled.

## Multi-stroke shortcuts

Separate strokes with spaces: `cmd-k left`. GPUI holds a matching prefix while a longer binding
can still complete. If it remains unresolved, the pending sequence is flushed after about one
second; the prefix can then dispatch as an action or be replayed as raw key input. Pending input is
associated with the focus that started it and is cleared when focus changes. Applications can
observe whether a chord is pending through [`Window::has_pending_keystrokes`](crate::Window::has_pending_keystrokes)
and inspect its strokes with [`Window::pending_input_keystrokes`](crate::Window::pending_input_keystrokes).

Application keystroke interceptors run before keymap resolution and can stop it. Element key-down
and key-up listeners run after binding matching when no binding consumes the keystroke. An active
text input may defer printable keys to its input handler according to the IME policy; use
[`EntityInputHandler`](crate::EntityInputHandler) for composition, marked text, replacement
ranges, and platform paste.
