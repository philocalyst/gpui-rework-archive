# Accept text input

Use [`text_input`](gpui_ce_elements::editable_text::text_input) for a single-line
field and [`text_area`](gpui_ce_elements::editable_text::text_area) for several lines.
Both come from the `gpui_ce_elements` crate. Each one draws an
[`EditableTextState`](gpui_ce_elements::editable_text::EditableTextState) entity that
you own. The state holds the text, the selection, the undo history and IME
composition. The element handles layout, the mouse and drawing.

## Hold the state

Create the state in your view and pass it to the element with
[`state`](gpui_ce_elements::editable_text::EditableTextElement::state). A
[`StringStorage`](gpui_ce_elements::editable_text::StringStorage) holds the
text. Use `StringStorage::default()` for an empty field, or
`StringStorage::from("draft")` to start with content.

```rust
# use gpui::{AppContext as _, Context, Entity, Window, div, prelude::*};
# use gpui_ce_elements::editable_text::{EditableTextState, StringStorage, text_input};
# struct Profile { name: Entity<EditableTextState> }
# impl Profile {
fn new(cx: &mut Context<Self>) -> Self {
    let name = cx.new(|cx| EditableTextState::new(StringStorage::from("Ada"), cx));
    Self { name }
}
# }
# impl Render for Profile {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
div().child(text_input("name").state(self.name.downgrade()))
#     }
# }
```

The element takes a [`WeakEntity`](gpui::WeakEntity), so the view keeps ownership
of the state. The element's id, given to `text_input("name")`, must be unique
within the view. If you don't want to own the state, call
[`EditableTextState::use_keyed`](gpui_ce_elements::editable_text::EditableTextState::use_keyed)
in `render` instead. It finds or creates a state from the element's id, and
[`use_keyed_init`](gpui_ce_elements::editable_text::EditableTextState::use_keyed_init)
does the same with a starting value.

## Install the editing keys

The element sets the `EditableText` key context. The editing keys (arrows,
Backspace, select all, undo and so on) are bound to that context by
`default_bindings()`. Register them once, at app startup, before you open a
window:

```rust
# use gpui::App;
use gpui_ce_elements::editable_text::actions::{DEFAULT_INPUT_CONTEXT, default_bindings};

# fn setup(cx: &mut App) {
cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
# }
```

Without these bindings, typed characters still arrive, but the editing keys do
nothing. The [keystroke guide](crate::_documentation::guides::keyboard) explains
how bindings are chosen. The default set is listed in the
[`default_bindings`](gpui_ce_elements::editable_text::actions::default_bindings) docs.

## Read and replace the text

[`EditableTextState::as_str`](gpui_ce_elements::editable_text::EditableTextState::as_str)
returns the current text. [`EditableTextState::emplace`](gpui_ce_elements::editable_text::EditableTextState::emplace)
replaces all of it and emits a change event, so use it to clear a field after you
submit it. Both need the state, so read and update it through the entity.

## React to changes

Each edit emits [`TextChanged`](gpui_ce_elements::editable_text::TextChanged), and
so does [`emplace`](gpui_ce_elements::editable_text::EditableTextState::emplace).
Subscribe with `cx.subscribe`, and keep the returned [`Subscription`](gpui::Subscription)
in your view, because dropping it cancels the subscription. The event runs after
the change, so read the new text with `as_str`. It can't reject or rewrite input.
Do that before the edit happens, in your own code.

The examples below use the event to refresh the view on every keystroke. Use it
to update a character count, enable a button, or run a search.

## Submit with Enter

A single-line field lets Enter pass through, as an HTML form does. The field's
Enter binding calls `propagate`, so GPUI tries the next binding for the key. Bind
Enter to your own action in the view's key context to submit the field. A
multi-line area inserts a newline on Enter instead.

The example below is a sign-up field. Enter adds the name to a list and clears the
field. It binds the default editing keys, focuses the field, types a name and
checks the result.

```standalone_crate
use gpui::{
    AppContext as _, Context, Entity, Focusable, KeyBinding, Subscription, TestApp, Window,
    actions, div, prelude::*, px,
};
use gpui_ce_elements::editable_text::{
    EditableTextState, StringStorage, TextChanged,
    actions::{DEFAULT_INPUT_CONTEXT, default_bindings},
    text_input,
};

actions!(text_input_submit, [Submit]);

struct SignUp {
    name: Entity<EditableTextState>,
    submitted: Vec<String>,
    _subscriptions: Vec<Subscription>,
}

impl SignUp {
    fn new(cx: &mut Context<Self>) -> Self {
        let name = cx.new(|cx| EditableTextState::new(StringStorage::default(), cx));
        let subscription = cx.subscribe(&name, |_, _, _: &TextChanged, cx| cx.notify());
        Self {
            name,
            submitted: Vec::new(),
            _subscriptions: vec![subscription],
        }
    }

    fn submit(&mut self, _: &Submit, _window: &mut Window, cx: &mut Context<Self>) {
        let name = self.name.read(cx).as_str().trim().to_string();
        if !name.is_empty() {
            self.submitted.push(name);
            self.name.update(cx, |state, cx| state.emplace("", cx));
        }
        cx.notify();
    }
}

impl Render for SignUp {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .key_context("SignUp")
            .on_action(cx.listener(Self::submit))
            .child(
                text_input("name")
                    .state(self.name.downgrade())
                    .placeholder("Your name")
                    .placeholder_color(gpui::rgb(0x8a8a8a))
                    .caret_blink_interval_500ms()
                    .w(px(240.))
                    .px_3()
                    .py_2()
                    .border_1()
                    .rounded_md(),
            )
    }
}

let mut app = TestApp::new();
app.update(|cx| {
    cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
    cx.bind_keys([KeyBinding::new("enter", Submit, Some("SignUp"))]);
});

let mut window = app.open_window(|_, cx| SignUp::new(cx));
window.update(|form, window, cx| {
    let focus = form.name.focus_handle(cx);
    window.focus(&focus, cx);
});

window.simulate_input("Ada");
window.simulate_keystrokes("enter");

assert_eq!(window.read(|form, _| form.submitted.clone()), ["Ada"]);
assert_eq!(window.read(|form, cx| form.name.read(cx).as_str().to_string()), "");
```

Your action handler reads the state through its entity and writes it back with
`update`. The view never touches the element. That keeps the element a pure
display of the state, and lets other parts of the app read the same text.

## Style the field

Style the element as you would any other element. Padding, borders, sizing and
colors all apply. A few setters control the parts that are specific to text:

- [`placeholder`](gpui_ce_elements::editable_text::EditableTextElement::placeholder)
  is shown while the field is empty, and
  [`placeholder_color`](gpui_ce_elements::editable_text::EditableTextElement::placeholder_color)
  sets its color.
- [`caret_color`](gpui_ce_elements::editable_text::EditableTextElement::caret_color),
  [`selection_color`](gpui_ce_elements::editable_text::EditableTextElement::selection_color)
  and [`caret_w`](gpui_ce_elements::editable_text::EditableTextElement::caret_w)
  style the cursor and selection.
- [`caret_blink_interval_500ms`](gpui_ce_elements::editable_text::EditableTextElement::caret_blink_interval_500ms)
  blinks the caret. Without an interval, the caret doesn't blink.
- [`accepts_input`](gpui_ce_elements::editable_text::EditableTextElement::accepts_input)
  stops the field taking input while it stays visible, such as while a save is in
  progress.

Give a single-line field `whitespace_nowrap()`, as the module examples do. A multi-line
area wraps by default. Give it a height or a min and max height, and add
`overflow_y_scroll()` if its content can grow past that.

## Use a multi-line area

[`text_area`](gpui_ce_elements::editable_text::text_area) takes the same setters as
`text_input`. Enter inserts a newline, and the arrow keys move between lines. The
state is the same kind of entity, so the code that reads and replaces the text
doesn't change. The [text input example](crate::_documentation::examples::text_input)
shows a single-line field and a text area in one form.

## Input methods

You don't need to do anything for IME. Composition, such as typing Japanese or
Chinese, is handled by the state, which implements [`EntityInputHandler`](gpui::EntityInputHandler).
The platform input method shows its candidate list and sends the final text. Press
Cmd-Space (or Ctrl-Space) to show the platform's character palette.

## Implement your own text element

Most fields should use `gpui_ce_elements`. To accept text in your own element, a
view implements [`EntityInputHandler`](gpui::EntityInputHandler), and the element
hands it to the window during paint with [`ElementInputHandler`](gpui::ElementInputHandler).
The window then routes typed text and IME events to the view. This sketch appends
text at the end and ignores the cursor. A real field tracks the selection and
converts offsets with [`utf8_to_utf16_offset`](gpui::utf8_to_utf16_offset) and
[`utf16_to_utf8_offset`](gpui::utf16_to_utf8_offset).

```rust
use std::ops::Range;

use gpui::{
    Bounds, Context, ElementInputHandler, EntityInputHandler, FocusHandle, Pixels, Point,
    UTF16Selection, Window, canvas, div, prelude::*, utf8_to_utf16_offset, utf16_to_utf8_offset,
};

struct RawField {
    focus_handle: FocusHandle,
    text: String,
    marked: Option<Range<usize>>,
}

impl RawField {
    fn utf8_range(&self, range: Option<Range<usize>>) -> Range<usize> {
        match range {
            Some(range) => {
                utf16_to_utf8_offset(&self.text, range.start)
                    ..utf16_to_utf8_offset(&self.text, range.end)
            }
            None => self.marked.clone().unwrap_or(self.text.len()..self.text.len()),
        }
    }
}

impl EntityInputHandler for RawField {
    fn text_for_range(
        &mut self,
        range: Range<usize>,
        adjusted_range: &mut Option<Range<usize>>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<String> {
        *adjusted_range = Some(range.clone());
        self.text.get(self.utf8_range(Some(range))).map(str::to_string)
    }

    fn selected_text_range(
        &mut self,
        _ignore_disabled_input: bool,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<UTF16Selection> {
        let end = utf8_to_utf16_offset(&self.text, self.text.len());
        Some(UTF16Selection { range: end..end, reversed: false })
    }

    fn marked_text_range(&self, _window: &mut Window, _cx: &mut Context<Self>) -> Option<Range<usize>> {
        self.marked.as_ref().map(|range| {
            utf8_to_utf16_offset(&self.text, range.start)..utf8_to_utf16_offset(&self.text, range.end)
        })
    }

    fn unmark_text(&mut self, _window: &mut Window, _cx: &mut Context<Self>) {
        self.marked = None;
    }

    fn replace_text_in_range(
        &mut self,
        range: Option<Range<usize>>,
        text: &str,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        let range = self.utf8_range(range);
        self.text.replace_range(range, text);
        self.marked = None;
        cx.notify();
    }

    fn replace_and_mark_text_in_range(
        &mut self,
        range: Option<Range<usize>>,
        new_text: &str,
        _new_selected_range: Option<Range<usize>>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        let range = self.utf8_range(range);
        let start = range.start;
        self.text.replace_range(range, new_text);
        self.marked = Some(start..start + new_text.len());
        cx.notify();
    }

    fn bounds_for_range(
        &mut self,
        _range: Range<usize>,
        element_bounds: Bounds<Pixels>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<Bounds<Pixels>> {
        Some(element_bounds)
    }

    fn character_index_for_point(
        &mut self,
        _point: Point<Pixels>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<usize> {
        Some(utf8_to_utf16_offset(&self.text, self.text.len()))
    }
}

impl Render for RawField {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let view = cx.entity();
        let focus_handle = self.focus_handle.clone();
        div().track_focus(&self.focus_handle).size_full().child(
            canvas(
                |_, _, _| {},
                move |bounds, _, window, cx| {
                    window.handle_input(&focus_handle, ElementInputHandler::new(bounds, view), cx);
                },
            )
            .size_full(),
        )
    }
}
```

The window asks the input handler for the text, the selection and the IME state,
and calls it back to insert text. `handle_input` must run during paint each frame,
and the handler is only active while the focus handle is focused. The [`EntityInputHandler`](gpui::EntityInputHandler) docs say what each method
must return.

## See also

- [Handle keyboard shortcuts](crate::_documentation::guides::keyboard) covers the
  bindings that Enter and the editing keys use.
- [Manage focus](crate::_documentation::guides::focus) covers how a field takes
  focus, and why Tab belongs to it.
- [Input and dispatch](crate::_documentation::concepts::input_dispatch) explains how
  typed text reaches the focused input handler.
- The [text input example](crate::_documentation::examples::text_input) and the
  [tutorial's text input chapter](crate::_documentation::tutorial) build a working
  form step by step.
