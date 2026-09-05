+++
title = "Actions and keymap"
description = "Separate the meaning of a command from the key or control that invokes it."
weight = 24
aliases = ["/interactivity/actions-keymap.html"]
[extra]
category = "INTERACTIVITY"
legacy_source = "gpui-ce-docs/build/html/interactivity/actions-keymap.html"
+++

**Actions** are typed structs that name user intents like save or delete. The **keymap** maps keystrokes plus a focus context to an action. Dispatch walks the focus tree and runs the first matching handler.

Use this page to add keyboard shortcuts. For raw key callbacks see ./events.html. For focus setup see ./focus.html.

## Define actions

`Action` ([crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs)) requires clone, partial equality, a static name, and JSON build. The `actions!` macro ([crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs)) declares unit-struct actions in one line. The `Action` derive handles structs with payload fields.

```rust
use gpui_ce::prelude::*;

// Each name registers as "editor::MoveUp": namespace plus struct.
// Two crates registering the same name panic at App creation,
// so namespace with your feature, not with "global".
actions!(editor, [MoveUp, MoveDown]);
```

Namespaced actions register as `editor::MoveUp`. Duplicate registration panics during `App` creation. Payload actions need `serde::Deserialize` unless marked `no_json` ([crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs)).

> **Tip.** Start with unit actions via `actions!`. Reach for payload structs only when the handler needs data.

## Bind keys

`KeyBinding::new` ([crates/gpui/src/keymap/binding.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/keymap/binding.rs)) parses keystroke text, an action, and an optional context. `Keystroke::parse` ([crates/gpui/src/platform/keystroke.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform/keystroke.rs)) accepts strings like `cmd-s` or `g g`. `KeyContext::parse` ([crates/gpui/src/keymap/context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/keymap/context.rs)) accepts predicates like `Editor && mode == normal`.

```rust
use gpui_ce::prelude::*;

// The context string is a predicate, not a label: this binding
// only fires when the focused element publishes "Editor".
// Omit it (None) and the shortcut fires everywhere. Careful.
fn bind(cx: &mut App) {
    cx.bind_keys([KeyBinding::new("cmd-s", Save, Some("Editor"))]);
}
```

`App::bind_keys` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)) appends bindings to the shared keymap. `App::on_action` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)) registers a global fallback handler. Element handlers come from `Div::on_action` ([crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)).

|  |  |  |
| --- | --- | --- |
| Piece | Parses | Example |
| keystroke | `Keystroke::parse` | `cmd` + `s`, `g g` |
| context | `KeyContext::parse` | `Editor`, `mode == normal` |
| binding | `KeyBinding::new` | keystrokes + action + context |

Table 25: The three parts of every shortcut.

## Dispatch trace

A keystroke becomes a handler call in five steps. Picture a letter traveling up a family tree, asking each generation for permission.

```rust
use gpui_ce::prelude::*;

// Imagine the user pressed cmd-s inside your Editor.
// Here is the little journey that keystroke takes:
//
// 1. Arrival. The platform delivers KeyDownEvent (interactive.rs:25)
//    with is_held == false for a fresh press, true for auto-repeat.
// 2. Accumulation. DispatchTree::dispatch_key (key_dispatch.rs:483)
//    appends it to pending input: "g" waits, hoping for "g g".
// 3. Matching. The keymap tests keystrokes plus KeyContext against
//    every binding. Multi-key misses replay their prefix (key_dispatch.rs:513).
// 4. Walking. Window::dispatch_action (window.rs:2201) defers the
//    action, then walks the focus path: globals first, then capture
//    root-to-focus, then bubble focus-to-root (window.rs:6000).
// 5. Running. The first on_action handler runs. Bubble-phase actions
//    stop propagation by default, so call cx.propagate() to share.
window.dispatch_action(Box::new(Save), cx);
```

`FocusHandle::dispatch_action` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) targets one subtree only. `Window::bindings_for_action` ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)) lists keys bound to an action. Use it to render shortcut hints.

Global listeners run in capture before any window node ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). A pending sequence clears on focus change ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). Stale prefixes replay instead of vanishing ([crates/gpui/src/key_dispatch.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/key_dispatch.rs)).

> **Pitfall.** Two bindings for one keystroke resolve by context specificity, not order. Overlapping contexts silently shadow each other. Keep contexts disjoint and audit with `bindings_for_action`.

## Anti-pattern

Do not bind the same keystroke in two active contexts. The loser never fires and shows no error. Audit with `bindings_for_action` before adding global shortcuts.

Next step: press `cmd` + `s` in your test app, then open [crates/gpui/src/key_dispatch.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/key_dispatch.rs).

## Sources

- Action trait: [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs), macro [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs), no\_json [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs)
- Binding: [crates/gpui/src/keymap/binding.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/keymap/binding.rs), keystroke [crates/gpui/src/platform/keystroke.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform/keystroke.rs)
- Dispatch key: [crates/gpui/src/key_dispatch.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/key_dispatch.rs), replay [crates/gpui/src/key_dispatch.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/key_dispatch.rs), flush [crates/gpui/src/key_dispatch.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/key_dispatch.rs)
- Dispatch action: [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), node walk [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs), default stop [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)
