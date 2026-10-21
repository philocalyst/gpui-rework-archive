# Shared focus and keyboard input

The production `Win` owns keyboard focus. Native callbacks and headless callers
use the same exclusive `focus`, `clear_focus`, and `key` operations:

```rust
use gpui::{Error, Key, Role, View, Win};

fn edit_title<M: View + 'static>(win: &mut Win<M>) -> Result<(), Error> {
    let input = win.role(Role::TextInput).one()?;
    win.focus(input)?;
    win.key(Key::Text("Café"))?;
    win.key(Key::Backspace)?;
    assert_eq!(win.focused()?, Some(input));
    Ok(())
}
```

`Key` contains `Text(&str)`, `Backspace`, `Tab`, `ReverseTab`, `Enter`, and
`Space`. Text containing control characters is ignored. Backspace removes one
Unicode scalar at the end. Space edits an input or activates another focused
control; Enter activates the focused control. An input has no submit action in
this floor. With no focused control, these keys are idle.

Inputs, buttons, and sites with click handlers are focusable. Tab traverses the
acknowledged sheet in presented preorder and wraps. It rejects a stale sheet
without changing focus. Explicit focus and focused edits use live logical target
authority, so backspace can repair a source edit whose text failed presentation.
Coordinate clicks require current presented geometry and focus the admitted hit;
an empty coordinate click clears focus. Position-free `activate(target)` does
not steal focus.

Removal, loss of handler eligibility on a generic site, logical invalidation,
owner quarantine, and close revoke focus. Presentation-only faults preserve it.
Native window blur calls the same clear operation. Focus-only changes neither
advance the source epoch nor cause description, layout, or paint work. Focus is
one optional 16-byte target, with no separate registration or shared mutable
window wrapper.

This is the shared production keyboard floor. Selection, grapheme deletion, IME,
shortcut routing, focus traps, accessibility platform bridges, and visible focus
ring styling require their own implementation.
