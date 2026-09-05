+++
title = "Focus and tab stops"
description = "Give keyboard input a destination and make movement through an interface deliberate."
weight = 23
aliases = ["/interactivity/focus.html"]
[extra]
category = "INTERACTIVITY"
legacy_source = "gpui-ce-docs/build/html/interactivity/focus.html"
+++

**Focus** marks the element that receives keyboard input. A `FocusHandle` names that element, and `Window::focus` moves focus to it. Tab stops order keyboard navigation between handles.

Use this page when wiring keyboard-first UI. For raw key callbacks see ./events.html. For shortcut dispatch see ./actions-keymap.html.

## Handles

`FocusHandle` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) is a reference-counted id plus tab settings. Views usually store one handle and expose it. `FocusHandle::focus` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) moves window focus to its element. `FocusHandle::is_focused` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) tests current focus.

```rust
use gpui_ce::prelude::*;

// The handle lives in view state so it survives re-renders.
// Focusing a dropped handle silently misses: keep it alive.
struct Editor {
    focus_handle: FocusHandle, // your element's name tag, held tight
}

impl Editor {
    fn focus_me(&self, window: &mut Window, cx: &mut App) {
        // Moves window focus here AND clears pending multi-key
        // sequences (window.rs:2080), so stale "g" never fires later.
        self.focus_handle.focus(window, cx);
    }
}
```

`Window::focused` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) returns the active handle or `None`. `Window::focus` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) sets focus and clears pending keystrokes. `Window::blur` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) clears focus for the whole window.

> **Tip.** Focus once on click or mount, then let tab order carry it. Re-focusing every render churns keystrokes.

## Tab order

`FocusHandle::tab_stop` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) opts an element into tab order. `FocusHandle::tab_index` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) sorts stops numerically. `TabStopMap::next` ([crates/gpui/src/tab_stop.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/tab_stop.rs)) picks the following stop. `TabStopMap::prev` ([crates/gpui/src/tab_stop.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/tab_stop.rs)) picks the previous one.

```rust
use gpui_ce::prelude::*;

// tab_stop(true) joins the Tab chain; tab_index orders it.
// Lower indexes come first, like seats numbered from the door.
fn make_field(cx: &mut App) -> FocusHandle {
    // First field gets index 0, next gets 1, and Tab walks 0, 1, 2.
    // Skip tab_stop and Tab sails right past your field.
    cx.focus_handle().tab_stop(true).tab_index(0)
}
```

`Window::focus_next` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) advances one stop. `Window::focus_prev` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) moves back one stop. Left-button press requests focus ([crates/gpui/src/interactive.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/interactive.rs)).

Both `focus_next` and `focus_prev` quietly return when `focus_enabled` is false or no stops exist ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). That silence is by design: background windows never steal Tabs.

|  |  |  |
| --- | --- | --- |
| Call | Moves to | Quiet when |
| `focus_next` | next tab stop | `focus_enabled` is false |
| `focus_prev` | previous tab stop | no stops registered |
| `blur` | nowhere, unfocused | always succeeds |

Table 27: Focus movement and its silent edges.

## Watch focus change

`Window::on_focus_in` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) fires when a handle or descendant gains focus. `Window::on_focus_out` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) fires when it loses focus. Both return a `Subscription`, and dropping it unregisters the listener.

```rust
use gpui_ce::prelude::*;

// Subscribe once, usually at view construction. The returned
// Subscription is your ticket: drop it and the callback stops.
// Great for swapping highlight rings or saving drafts on blur.
fn watch(cx: &mut App, window: &mut Window, handle: FocusHandle) {
    // Keep this subscription in view state or it dies immediately.
    let _sub = window.on_focus_in(&handle, cx, |_event, _window, _cx| {
        // Runs when this handle or any child grabs focus.
    });
}
```

> **Pitfall.** A dropped `FocusHandle` releases its id, so late focus calls silently miss. Keep view handles alive in view state, and hold `Subscription`s the same way.

## Anti-pattern

Do not call `window.focus` inside every render. Focus churn resets pending keystrokes each call. Focus once on click or mount, then let tab order move it.

Next step: press `tab` to walk stops in your test app, then open [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs).

## Sources

- Handles: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), focus [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), focused [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Focus clears keystrokes: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), blur [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
- Tab walk: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), map [crates/gpui/src/tab_stop.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/tab_stop.rs)
- Focus listeners: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
