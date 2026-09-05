+++
title = "Event handlers"
description = "Turn pointer and keyboard input into typed event handlers and visible state changes."
weight = 22
aliases = ["/interactivity/events.html"]
[extra]
playground = true
category = "INTERACTIVITY"
legacy_source = "gpui-ce-docs/build/html/interactivity/events.html"
+++

**Event handlers** are callbacks that run when input hits your element. You attach them with `Div` builder methods like `on_click`. They fire during paint-registered dispatch each frame ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

Use this page to wire mouse and keyboard input. For shortcuts see ./actions-keymap.html. For window setup see ../fundamentals/windows.html.


{{ <playground example="interaction" title="Try the input states" label="Interactive companion" /> }}


## Mouse input

`Div::on_mouse_down` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) takes a button plus a callback. `Div::on_mouse_up` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) mirrors it for release. `Div::on_mouse_move` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) fires while the cursor crosses the hitbox.

```rust
use gpui_ce::prelude::*;

// Needs .id(...): listeners hang off element state, and a bare
// div rebuilds fresh every frame with nowhere to hang them.
div()
    .id("ok-button") // claim an identity so clicks find you again
    .on_mouse_down(MouseButton::Left, |event, _window, _cx| {
        // event.button tells you which button; event.click_count
        // counts rapid repeats, so double-click is just count == 2.
        let _repeats = event.click_count;
    })
```

`MouseDownEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) carries button, position, modifiers, and click count. `MouseUpEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) carries the same fields. `Div::on_click` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) wraps a down-up pair into one `ClickEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)).

|  |  |  |
| --- | --- | --- |
| Method | Fires when | Needs |
| `on_mouse_down` | press lands inside hitbox | `.id()` |
| `on_mouse_up` | release lands inside hitbox | `.id()` |
| `on_click` | down-up pair completes | `.id()` |
| `on_mouse_move` | cursor crosses hitbox | paint each frame |

Table 26: Mouse handlers at a glance.

> **Tip.** Reach for `on_click` for buttons. Save `on_mouse_down` for press-feel things like starting a drag.

## Keyboard input

`Div::on_key_down` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) fires on key press during bubble. `Div::on_key_up` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) fires on release. `Div::on_action` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) fires when a keymap binding produces a matching action.

```rust
use gpui_ce::prelude::*;

// Raw keys ignore the keymap entirely, so this fires even
// when no binding matches. Prefer on_action for shortcuts.
div()
    .id("search-box") // focus must live here before keys arrive
    .on_key_down(|event: &KeyDownEvent, _window, _cx| {
        // is_held stays true while the OS auto-repeats the key.
        // Use it to skip repeat work like re-sending a request.
        let _held = event.is_held;
    })
```

`KeyDownEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) carries the parsed keystroke. `KeyUpEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) mirrors it. Raw handlers ignore the keymap, so prefer actions for anything the user can rebind.

## Capture and bubble

**Dispatch order** is the path listeners fire in: capture first, bubble second. Mouse capture runs back to front, then bubble runs front to back ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). Keyboard capture runs root to focus, then bubble runs focus to root ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

```rust
use gpui_ce::prelude::*;

// capture_any_* sees every press before children do, even ones
// aimed elsewhere. Bubble handlers only fire inside the hitbox.
// That split is the whole menu trick: capture to close, bubble to pick.
div()
    .id("menu") // capture still needs identity to register
    .capture_any_mouse_down(|_event, _window, _cx| {
        // runs back-to-front: parents see the press first here.
        // Call cx.stop_propagation() to keep children in the dark.
    })
```

`Div::capture_any_mouse_down` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) observes every press before children. `Div::capture_key_down` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) does the same for keys. Call `cx.stop_propagation()` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)) to halt later listeners. Call `cx.propagate()` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)) to keep an action moving upward.

Bubble mouse handlers check `hitbox.is_hovered` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)), so outside clicks never reach them. When inspector picking runs, normal mouse handling is skipped entirely ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). Pointer capture auto-releases on mouse up ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

> **Pitfall.** Waiting for an outside click in `on_mouse_down`. Bubble only fires inside the hitbox, so your menu never closes. Use `capture_any_mouse_down` or `on_mouse_down_out` instead.

## Anti-pattern

Do not hand-roll hover tracking in `on_mouse_move`. `Div::on_hover` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) reports `true` on enter and `false` on leave. It also fires when layout shifts under a still cursor.

```rust
use gpui_ce::prelude::*;

// Wrong: move events skip layout-shift hovers and spam per pixel.
// Right: on_hover diffs was_hovered vs hovered for you (div.rs:2750).
div().id("card").on_hover(|hovered: &bool, _window, _cx| {
    // hovered == true means entered; false means left. That is all.
    let _inside = *hovered;
})
```

Next step: press `ctrl` + `q` to quit your test app, then open [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs).

## Sources

- Mouse dispatch order: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), capture [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), bubble [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Keyboard dispatch: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), capture [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), bubble [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Inspector skip: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs); pointer auto-release: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Hover diff: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs); scroll gate: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
