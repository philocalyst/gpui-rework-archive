+++
title = "Fields that edit: text_input , text_area"
description = "Connect text editing, selection, composition, and platform input to an editable interface."
weight = 21
aliases = ["/elements/text-input.html"]
[extra]
category = "ELEMENTS"
legacy_source = "gpui-ce-docs/build/html/elements/text-input.html"
+++

This is GPUI’s `<input>` and `<textarea>` in one element family. Single line or multi-line, keyboard and mouse navigation, selection, IME, cut, copy, paste, blinking caret, single-field undo (`crates/gpui_elements/src/editable_text.rs` module docs). The element stays stateless. An entity holds the truth.

```rust
use gpui_ce_elements::editable_text::text_input;

// `text_input("my_input")` names the field. The id is its identity.
// `.placeholder` shows ghost text when empty. It never edits content.
// `.min_h_auto()` hugs one line. No scrolling, no growing.
// `.whitespace_nowrap()` bans wrapping. Overflow clips until you opt in.
text_input("my_input")
    .placeholder("empty text")
    .min_h_auto()
    .whitespace_nowrap()
```

That snippet clips. GPUI clips by default. Scrolling is an explicit opt-in, never a side effect.

## Three shapes, no guessing

```rust
use gpui_ce_elements::editable_text::{text_input, text_area};

// Shape 1: clipped single line. Wrapping banned, overflow clipped.
// Pick this for table cells and fixed slots where scroll bars intrude.
text_input("a").placeholder("empty").min_h_auto().whitespace_nowrap();
// Shape 2: scrolling single line. Same ban, plus horizontal scroll.
// Pick this for search boxes and command palettes with long values.
text_input("b").placeholder("empty").min_h_auto().whitespace_nowrap().overflow_x_scroll();
// Shape 3: wrapping message box. Normal wrap, vertical scroll, height band.
// Pick this for chat composers: grows from 24 to 128, then scrolls.
text_area("c").placeholder("empty").min_h_24().max_h_128().overflow_y_scroll();
```

Rule of thumb: `text_input` for one line, `text_area` for many. Stray newlines never sneak into single lines anyway. Incoming text is validated per line mode (`state.rs:226`). Callers own fancier rules like max length. No built-in validator waits for you.

## State you find, not make

```rust
use gpui::{App, ElementId, Window};
use gpui_ce_elements::editable_text::{EditableTextState, TextChanged, text_input};

// `ElementId::from` names the slot. Same id, same field, every frame.
let id = ElementId::from("my_input");
// `use_keyed` finds the state or seeds an empty one. Runs inside render.
// First frame creates it. Later frames reuse it. Never `new` per frame.
let state = EditableTextState::use_keyed(id.clone(), window, cx);

// `cx.subscribe` listens for `TextChanged`. Fires per keystroke.
// `state.read(cx).as_str()` borrows the current text. Print, store, debounce.
// `.detach()` keeps the listener alive. Dropping it unsubscribes silently.
cx.subscribe(&state, |state, _: &TextChanged, cx| {
    println!("{:?}", state.read(cx).as_str());
}).detach();

// `.state(state.downgrade())` hands a weak handle to the element.
// The element reads through it each frame. The entity owns the text.
text_input(id).state(state.downgrade())
```

`use_keyed` (`state.rs:117`) finds or lazily creates empty state. `use_keyed_init` (`state.rs:137`) seeds a default once, say `StringStorage::from("default")`. Its init closure runs a single time. `EditableTextState::new` (`state.rs:163`) builds raw state with any `UnicodeTextStorage`. Read with `as_str` (`state.rs:183`). `String` is the default storage. Big documents deserve a custom `UnicodeTextStorage` with real `replace_range` cost.

There is no “editing finished” callback. Debounce `TextChanged` or watch focus loss instead. And bindings cut one way: `default_bindings` (`actions.rs:124`) ships platform-aware keys, but no unbind API exists (`actions.rs:123`). Want `Tab` to leave the field? Skip the defaults and ship your own set.

## Move, select, undo

|  |  |
| --- | --- |
| Need | API |
| jump caret | `move_to` (`state.rs:439`) |
| extend selection | `select_to` (`state.rs:451`) |
| select all | `select_document` (`state.rs:526`) |
| linear edit and motion | `delete_linear` (`state.rs:471`), `select_linear` (`state.rs:539`), `nav_linear` (`state.rs:507`) |
| replace everything | `emplace` (`state.rs:192`) |
| history | `history()` (`state.rs:594`) |

Table 5: Caret, selection, and history verbs for editable text.

Unlike bare elements, editable text owns its `FocusHandle` inside. It takes focus without extra wiring. Defaults come from `default_bindings` (`actions.rs:124`).

> **Pitfall.** Building fresh state every render with `new`. The caret jumps and typing stutters. Call `use_keyed` once per id and hand the same state back through `.state(...)`. Create once, reuse always.

Where next? Pair fields with keymap and focus pages under interactivity.

## Sources

- Element docs and all usage shapes: `crates/gpui_elements/src/editable_text.rs` module docs
- Validation per line mode: `state.rs:226`
- State: `state.rs:117`, `state.rs:137`, `state.rs:163`, `state.rs:183`, `state.rs:192`, `state.rs:439`, `state.rs:451`, `state.rs:471`, `state.rs:507`, `state.rs:526`, `state.rs:539`, `state.rs:594`
- Bindings and unbind gap: `actions.rs:123`, `actions.rs:124`
