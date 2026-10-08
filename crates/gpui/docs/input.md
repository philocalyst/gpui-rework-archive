# Input, focus, and actions

Use [`on_click`](crate::StatefulInteractiveElement::on_click) to activate a
control and [`on_action`](crate::InteractiveElement::on_action) for a command
shared by shortcuts and menus. Use raw key or pointer listeners when the
individual press, release, or movement matters. Text editing also needs the
platform input-handler protocol; a stream of key presses cannot represent
composition or replacement ranges.

Pointer input follows the frame's painted regions. A [hitbox](crate::Hitbox)
records such a region, and its [behavior](crate::HitboxBehavior) determines
whether it blocks hitboxes behind it. Keyboard input follows the selected
focus node and its ancestors. A listener outside that route cannot handle the
key, even when its element is visible beside the focused control.

Element callbacks receive the [`Window`](crate::Window) and [`App`](crate::App) that are
dispatching the event. Use [`Context::listener`](crate::Context::listener) when a callback needs
to update the view that built its element. The listener is invoked later during event dispatch;
the context itself is not retained.

## Event routing and propagation

Most element input callbacks run in the bubble phase. Keyboard listeners capture from the root
toward the focused node, then bubble back along that path. Pointer listeners capture in paint
order, from back to front, then bubble in reverse order. Low-level pointer listeners receive
events even outside their own hitbox; the ordinary element builders filter by hit testing and
occlusion. This lets an outside-click handler observe a click without being its target.
APIs named `capture_*` register a capture-phase callback; APIs such as `on_mouse_down`
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
capture makes its chosen hitbox eligible for mouse move/up handling after a
drag leaves the region. It does not request native capture outside the window
or make delivery exclusive. A rebuilt hitbox has a new ID, so a custom drag
must keep its active state on an owner and renew capture during prepaint.
GPUI releases it after a received mouse-up. See
[`Window::capture_pointer`](crate::Window::capture_pointer).

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

Give each target its own handle. Cloning a handle shares its identity; it
does not create a child identity. Attaching the same handle to a panel and
its field leaves keyboard lookup with the last registered node. Track one
handle on the panel and another on the field when their relationship matters.

Focus is separate from visual selection, hover, and domain state. A list can keep one selected row
while a search field owns keyboard focus. Tab traversal uses the recorded focus handles and tab
order, but the application must connect a key or action to that traversal.
An embedded browser can also have two focus systems: the page must focus its iframe before the
GPUI window can receive keys.

### Connect Tab to traversal

`tab_index(0)` makes an element a candidate for traversal. It does not install
a key binding. Call [`Window::focus_next`](crate::Window::focus_next) for Tab
and [`Window::focus_prev`](crate::Window::focus_prev) for Shift+Tab, from a
listener on the root or another ancestor of the controls. Both methods wrap
at the ends of the last painted order; neither changes focus when there are
no enabled stops.

Here two targets retain their own handles, and setup selects the first. The
root handles Tab only when no modifier other than Shift is pressed, leaving
application shortcuts alone:

```rust
use gpui::{App, Context, FocusHandle, IntoElement, KeyDownEvent, Render, Window,
    div, prelude::*};

fn traverse(event: &KeyDownEvent, window: &mut Window, cx: &mut App) {
    let mut modifiers = event.keystroke.modifiers;
    let reverse = modifiers.shift;
    modifiers.shift = false;
    if event.keystroke.key == "tab" && !modifiers.modified() {
        if reverse {
            window.focus_prev(cx);
        } else {
            window.focus_next(cx);
        }
        cx.stop_propagation();
    }
}

struct Fields {
    first: FocusHandle,
    second: FocusHandle,
}

impl Render for Fields {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().on_key_down(traverse)
            .child(div().track_focus(&self.first).child("First"))
            .child(div().track_focus(&self.second).child("Second"))
    }
}

# #[cfg(feature = "test-support")]
# {
let mut app = gpui::TestApp::new();
let mut window = app.open_window(|window, cx| {
    let first = cx.focus_handle().tab_stop(true);
    window.focus(&first, cx);
    Fields { first, second: cx.focus_handle().tab_stop(true) }
});
assert!(window.update(|fields, window, _| fields.first.is_focused(window)));
window.simulate_keystroke("tab");
assert!(window.update(|fields, window, _| fields.second.is_focused(window)));
window.simulate_keystroke("shift-tab");
assert!(window.update(|fields, window, _| fields.first.is_focused(window)));
window.simulate_keystroke("shift-tab");
assert!(window.update(|fields, window, _| fields.second.is_focused(window)));
# }
```

The assertions run with `test-support`. They exercise dispatch through the
rendered tree, including backward wrapping; calling the traversal methods
directly would leave the key listener untested.

The listener bubbles, so a child can handle Tab first by stopping propagation.
For example, an editor may use Tab to indent. Once the root handles the key,
it stops further dispatch. The web backend also cancels the browser's Tab
action for a stopped key event, keeping browser and GPUI focus together.
An embedded preview needs a way to leave that wrapped order: these walkthroughs
reserve Escape to return focus to their page controls.
See W3C's [keyboard-trap guidance](https://www.w3.org/WAI/WCAG22/Understanding/no-keyboard-trap.html)
for the exit rule and examples of embedded applications.

### Put listeners on the focused path

Focusing a container does not send keys down through its children. If a
preview's root carries the focus handle, a key listener on its canvas child
is outside the route. Put that listener on the root alongside `track_focus`,
or give the child its own handle and focus it. Ancestors remain on the route
and can handle a key that the target propagates.

This applies to action handlers and key contexts too. A child `key_context`
cannot qualify a shortcut while its parent is the focused target. The
[actions walkthrough](https://gpui-ce.github.io/examples/actions/#dispatch)
keeps its focus handle, context, and action handler on one element so their
relationship is visible.

Choose a query according to the question being asked:

| Question | Query |
| --- | --- |
| Is this the selected GPUI identity? | [`FocusHandle::is_focused`](crate::FocusHandle::is_focused) |
| Does this panel contain that identity? | [`FocusHandle::contains_focused`](crate::FocusHandle::contains_focused) |
| Does the selected subtree contain this handle? | [`FocusHandle::within_focused`](crate::FocusHandle::within_focused) |
| Is the operating system sending keys to this window? | [`Window::is_window_active`](crate::Window::is_window_active) |

GPUI keeps its selected focus target when the native window deactivates.
Check activation separately when focus styling should dim while the user
works in another window. Subtree queries use the last rendered dispatch
tree; they do not traverse fields on a view. Changes to rendered ancestry
take effect after GPUI draws again.
The [rendered-focus test](https://gpui-ce.github.io/book/testing.html#check-focus-against-the-rendered-tree)
selects a field before its first draw, moves it outside its panel, and checks
exactly when each query changes.

[`Window::on_focus_in`](crate::Window::on_focus_in) and
[`Window::on_focus_out`](crate::Window::on_focus_out) watch a whole subtree.
Moving between its descendants produces neither event. Native activation
and deactivation do count as entering and leaving. These listeners run when
a draw compares focus paths, so a call to `focus` changes the selected
identity before it invokes those listeners. Keep their subscriptions alive.

Choose who owns the handle according to what the component needs:

| Need | Pattern |
| --- | --- |
| A button reached through ordinary tab traversal | Give the element a stable ID and `tab_index(0)`; GPUI retains its internal handle |
| A search field that application code must focus | Store a `FocusHandle` on the view and attach it with `track_focus` |
| A focusable container that should be skipped during traversal | Keep its handle's `tab_stop` false; focus it explicitly when needed |

An explicit handle starts with `tab_stop` false. Configure it before retaining
it, for example `cx.focus_handle().tab_stop(true)`, to make it a tab stop.
[`FocusHandle::tab_index`](crate::FocusHandle::tab_index) controls its order
within a tab group. Element tab setters configure internally retained handles;
they do not change a handle passed to `track_focus`.

GPUI orders negative indices like any other indices. To skip a stop, set its
`tab_stop` flag to false. For an internal handle, write
`.tab_index(0).tab_stop(false)` in that order: `tab_index` enables the stop.
Use [`tab_group`](crate::InteractiveElement::tab_group) to keep a composite
widget's ordering local. A child at index 100 in group 1 still precedes a
child at index zero in group 2; the group positions are compared first.
Groups may nest, and equal indices follow the order recorded during paint.

Use [`InteractiveElement::focus_visible`](crate::InteractiveElement::focus_visible)
for a keyboard-focus ring. It applies when the element is focused and the
window's last input was a keyboard event. This is an input-modality check,
so programmatic focus can also show the ring. Give the control an accessible
role and name as described in the [accessibility chapter](crate::_accessibility).

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

An element's `key_context` uses entry syntax such as `Editor mode=insert`.
A binding's predicate uses expression syntax such as `Editor && mode == insert`.
The contexts stay separate along the path: `Editor && mode == insert` requires
both entries on one node. Use `Workspace > Editor` when the relationship is
between an ancestor and a descendant, with spaces around `>`. See
[`KeyContext::parse`](crate::KeyContext::parse) for accepted entry characters and
[`KeyBindingContextPredicate::parse`](crate::KeyBindingContextPredicate::parse)
for executable matching examples.

Build a fresh context from the component's state when rendering. The entry
setters keep the first value: calling `set("mode", "normal")` on a context
that already has `mode=insert` leaves it in insert mode. The
[`set` example](crate::KeyContext::set) shows how to replace the facts by
clearing and rebuilding them. Changing a stored context takes effect in
dispatch after the changed element is rendered again.

Choose the scope of an exclusion deliberately. `Editor && mode != readonly`
checks the mode on the editor's own node, and also matches when that key is
absent. `Editor && !(mode == readonly)` rejects a read-only mode anywhere on
the path, including an ancestor. After a descendant operator, negation checks
only the path below its matching ancestor. For example,
`Workspace > Editor && !(mode == readonly)` excludes read-only nodes below
the workspace. Parentheses matter: `!` binds more tightly than `==`, so negate
the complete equality with `!(mode == readonly)`.

For programmatic bindings, [`KeyBinding::new`](crate::KeyBinding::new) panics when a keystroke or
context string is invalid. [`KeyBinding::load`](crate::KeyBinding::load) returns
[`InvalidKeystrokeError`](crate::InvalidKeystrokeError) for malformed keystrokes; parse the
context predicate separately so its error can be reported alongside the binding source.

When bindings compete, a match at a deeper context wins; at the same depth, later bindings win.
An unqualified binding is eligible at the deepest context. This lets a user binding appended
after built-in bindings override a built-in binding while a focused editor can override a
workspace shortcut. See [`Keymap::bindings_for_input`](crate::Keymap::bindings_for_input) for
disabled-binding and prefix details.

### Show the shortcut for the command's target

A toolbar button and an editor can invoke the same action while belonging to
different focus paths. To show the editor's shortcut on that button, query
[`Window::highest_precedence_binding_for_action_in`](crate::Window::highest_precedence_binding_for_action_in)
with the editor's focus handle. That query includes the editor's ancestors
and leaves focus where it is. Passing a single `KeyContext` instead omits
those ancestors, which can change the winning binding.

For a command aimed at the currently focused control, use
[`Window::highest_precedence_binding_for_action`](crate::Window::highest_precedence_binding_for_action).
It returns one unshadowed binding; `bindings_for_action` returns all of them
in insertion order. Both compare the action's data as well as its type. A
shortcut for “open file A” need not match an action carrying file B.

Binding lookup does not establish that a command is enabled. Availability
queries check for a listener of the action's type, and that listener can
still reject the particular value or state. Keep the command's enablement
rule with its owner. Contexts come from the last rendered tree; draw changed
ancestry before querying it. Changing focus between nodes already in that
tree changes the current-focus lookup immediately.

### Wait for a pending chord

Separate keystrokes with spaces to define a chord, for example `cmd-k left`.
While a prefix can still complete a longer binding, GPUI holds it pending.
If that prefix also completes a shorter binding, GPUI gives the longer one a
one-second deadline before replaying the prefix. Pending printable input also
gets a deadline when the focused input handler accepts text. A command prefix
with neither ambiguity can remain pending without a timer. Further pending
strokes restart an existing deadline; a mismatching stroke can trigger replay
immediately. Replay tries eligible actions, then ordinary key and text input.
Changing focus discards the pending sequence.

The platform can mark a key-down event with
[`prefer_character_input`](crate::KeyDownEvent::prefer_character_input).
When the focused input handler accepts text, this lets character entry take
precedence over a completed binding. Use the text-input protocol for composing
and replacing that text; a key event alone cannot describe those operations.

Use raw key handlers when the keystroke itself matters, for example for editor navigation or
terminal input. Use actions when several input routes should invoke the same operation. Application
keystroke interceptors run before key binding resolution and can stop it; element key-down/up
handlers run after key binding matching when no binding has consumed the keystroke. Text
composition, candidate selection, and replacement ranges must use the input-handler contract;
seeing a printable [`KeyDownEvent`](crate::KeyDownEvent) does not model an IME session.

`capture_key_down` captures the raw key route; it still runs after binding
resolution. Use [`App::intercept_keystrokes`](crate::App::intercept_keystrokes)
when interception must precede that resolution. Key-up delivery follows the
focus at release, so an element can receive a release without having handled
the press. A shortcut may have consumed the press or moved focus in between.

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

### Replace provisional text instead of appending it

An [input method](https://en.wikipedia.org/wiki/Input_method) can revise a word
while the user chooses its spelling. The marked range identifies the text the
input method still owns. Keep that range on the editor alongside the selection;
it is not a separate copy of the buffer.

Suppose the buffer is `a🦀z`, and the input method replaces the crab. These ranges
count UTF-16 code units from the document's start:

| Callback | Buffer afterward | Marked range |
| --- | --- | --- |
| `replace_and_mark_text_in_range(Some(1..3), "に", …)` | `aにz` | `Some(1..2)` |
| `replace_and_mark_text_in_range(None, "日本", …)` | `a日本z` | `Some(1..3)` |
| `replace_text_in_range(None, "日本語")` | `a日本語z` | `None` |

The second and third calls target the current marked range. Inserting each
candidate at the caret would leave `に日本日本語` in the buffer. An explicit
replacement range takes precedence; without one, use the marked range, then
the selection. [`unmark_text`](crate::EntityInputHandler::unmark_text) ends the
composition without changing its text.

The `new_selected_range` on a marked replacement is relative to the **inserted
text**. After inserting `日本` at document offset one, a relative selection of
`0..2` becomes document selection `1..3`. Convert each endpoint to UTF-8 before
using it to slice a Rust string. Do not add a UTF-16 offset to a byte offset:

```rust
use gpui::{utf16_to_utf8_offset, utf8_to_utf16_offset};

let source = "a🦀z";
let bytes = utf16_to_utf8_offset(source, 1)..utf16_to_utf8_offset(source, 3);
assert_eq!(&source[bytes.clone()], "🦀");
assert_eq!(bytes, 1..5);
assert_eq!(utf8_to_utf16_offset(source, 5), 3);
```

Keep the selection's anchor and active end, even when the platform asks for a
sorted range. [`UTF16Selection::reversed`](crate::UTF16Selection::reversed)
records an active end at the range's start. Implement
[`set_selected_text_range`](crate::EntityInputHandler::set_selected_text_range)
so a platform selection command updates the same state used by replacement and
painting. Otherwise Select All can appear to succeed in system UI while the
next edit still inserts at the old caret.

### Answer geometry from the painted layout

The platform uses [`bounds_for_range`](crate::EntityInputHandler::bounds_for_range)
to place candidate UI and
[`character_index_for_point`](crate::EntityInputHandler::character_index_for_point)
to locate text under a point. Keep the [`ShapedText`](crate::ShapedText) used for
painting, its origin, and its line height. Translate a window point into layout
coordinates before hit testing, and translate the resulting byte index back to
UTF-16. Translate bounds in the other direction; leave device scaling and screen
coordinates to the platform.

An edit invalidates the old layout even if its allocation remains alive. Return
`None` until a matching layout is available, rather than placing candidates
beside the wrong character. An empty range asks for caret bounds. A nonempty
range can cross visual rows; the platform's single rectangle can describe its
first visual segment. The [text chapter](crate::_documentation::text) explains
caret affinity and visual movement. The
[composition example's editor](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/examples/view_example/example_editor.rs)
shows the buffer, selection, marked range, and geometry callbacks together.

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
