+++
title = "Click drag scroll"
description = "Carry an interaction across space, from the first pointer movement to the final drop."
weight = 25
aliases = ["/interactivity/gestures-drag.html"]
[extra]
category = "INTERACTIVITY"
legacy_source = "gpui-ce-docs/build/html/interactivity/gestures-drag.html"
+++

**Gestures** turn raw pointer input into drag, scroll, and pinch events. A **drag** carries a typed payload from a source element to a drop target. Scroll events pan content under the cursor.

Use this page for draggable UI and scrollable lists. For basic clicks see ./events.html. For shortcut dispatch see ./actions-keymap.html.

## Click detail

`ClickEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) has mouse, keyboard, and touch variants. `ClickEvent::modifiers` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) reports held keys. `ClickEvent::position` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) reports the release point in pixels.

```rust
use gpui_ce::prelude::*;

// position() is the release point, not the press point, so a
// press-drag-release reports where the finger landed. Pair it
// with modifiers() to tell ctrl-click from plain click.
div().id("row").on_click(|event, _window, _cx| {
    // Release point in pixels. Held keys ride along for free.
    let _point = event.position();
})
```

`MouseClickEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) pairs the down and up events. `ClickEvent::is_secondary` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) detects right-click or long-press. Keyboard clicks only fire on focused elements ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)).

> **Tip.** Check `is_secondary` before opening context menus. Trackpads send long-press, mice send right button.

## Drag and drop

`Div::on_drag` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) starts a drag with a typed value plus a ghost view. `Div::on_drop` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) receives values of one type on any element. `Div::can_drop` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) predicates whether a drop lands.

```rust
use gpui_ce::prelude::*;

// The value must be 'static: the drag owns an Arc copy after
// on_drag returns, so borrowed data would dangle. The closure
// builds the little ghost that follows your cursor mid-drag.
div().id("card").on_drag(Card { id: 7 }, |value, _offset, _window, cx| {
    // value is your Arc-cloned payload; return the ghost view.
    // Mouse move refreshes the window so the ghost trails you.
    cx.new(|_| GhostView { card: value.clone() })
})
```

`Div::on_drag_move` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) tracks the cursor while a typed drag is active. `ExternalDragPayload` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) offers data to the OS past window edges. Releasing the button ends the drag and clears it ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

The drag lives on `App::active_drag` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)), not on your view. Past the window edge GPUI hands it to the platform ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). Only one `on_drag` per element survives; a second trips a debug assert.

|  |  |  |
| --- | --- | --- |
| Stage | Lives in | Ends when |
| ghost follows cursor | `App::active_drag` | mouse move refreshes |
| drop lands | `on_drop` + `can_drop` | button releases |
| leaves window | platform handoff | OS takes over |

Table 28: The little life of a drag.

## Scroll and hover help

`Div::on_scroll_wheel` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) fires bubble-phase scrolls over the hitbox. `ScrollWheelEvent` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) carries a `ScrollDelta` ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)) in pixels or lines. `Div::tooltip` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) builds a hover popup view on demand.

```rust
use gpui_ce::prelude::*;

// Scroll gates on should_handle_scroll, not plain hover, so
// nested scrollers nest sanely: inner lists eat their own wheel.
// Deltas coalesce per frame, so add them up, never count events.
div().id("list").on_scroll_wheel(|event, _window, _cx| {
    // Pixels for trackpads, Lines for wheels; coalesce() merges.
    let _delta = event.delta.clone();
})
```

`Div::tooltip_show_delay` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)) postpones the popup. The default wait is 500 ms ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)). When inspector picking runs, normal mouse handling is skipped ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

```rust
use gpui_ce::prelude::*;
use std::time::Duration;

// Tooltips build lazily on hover, then hide when the cursor
// leaves or the owner unmounts. The delay keeps casual passes
// from flashing popups everywhere. Warm and polite.
div().id("save-btn").tooltip(|_window, _cx| my_tooltip_view())
```

> **Pitfall.** Only one `on_drag` per element is supported, and a second call trips a debug assert. Split multiple drag sources into nested divs.

## Anti-pattern

Do not hold the dragged value by reference across frames. The drag owns an `Arc` copy after `on_drag` returns. Borrowed data dangles when the source view updates.

Next step: press `tab` to a draggable card, then open [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs).

## Sources

- Click: [crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs), secondary [crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs), keyboard-only [crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)
- Drag store: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs), drag move [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs), drop [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
- Drag end: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), platform handoff [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Scroll delta: [crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs), coalesce [crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs), scroll gate [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Tooltip delay: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs), builder [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
