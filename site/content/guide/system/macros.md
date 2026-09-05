+++
title = "Macros: the verified list"
description = "Understand the generated code behind actions, refinements, tests, and framework helpers."
weight = 33
aliases = ["/system/macros.html"]
[extra]
category = "SYSTEM"
legacy_source = "gpui-ce-docs/build/html/system/macros.html"
+++

A **derive macro** generates trait code at compile time, so you write one attribute and skip the boilerplate. Only the macros below exist in `gpui_macros`. Anything else is invented — do not use it, and do not trust a blog that tells you otherwise.

```rust
// The two lines you write most. Declare actions, then register them.
#[derive(Action, Clone)] // `gpui_macros.rs:19` — makes `Save` dispatchable
#[action(namespace = editor)] // the derive needs its namespace attribute
struct Save;
actions!(editor, [Save]); // `action.rs:24` — declares plus registers in one step
// `register_action!` (`gpui_macros.rs:28`) covers the manual-impl escape hatch.
```

|  |  |  |
| --- | --- | --- |
| Macro | Where it lives | Why you reach for it |
| `#[derive(Action)]` | `gpui_macros.rs:19` | dispatchable keymap actions; pair with `actions!` |
| `register_action!` | `gpui_macros.rs:28` | registers a hand-written `Action` impl |
| `#[derive(IntoElement)]` | `gpui_macros.rs:34` | wraps `RenderOnce` so a value works as a child |
| `#[derive(AppContext)]` | `gpui_macros.rs:58` | builds a context from a `#[app]` field |
| `#[derive(VisualContext)]` | `gpui_macros.rs:91` | builds a visual context from `#[window]` plus `#[app]` fields |
| `style_helpers` + family | `gpui_macros.rs:99` | generates the margin/padding/border builder methods |
| `#[gpui::test]` | `gpui_macros.rs:196` | async GPUI test with a `TestAppContext` |
| `#[gpui::bench]` | `gpui_macros.rs:211` | benchmark harness entry |
| `#[gpui::property_test]` | `gpui_macros.rs:284` | proptest-backed cases with replayable seeds |

Table 39: Every macro that exists, and the one job each one does.

## Two derives that bite

`#[derive(AppContext)]` needs a field marked `#[app]` — the macro has nothing to wrap without it ([crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)). `#[derive(VisualContext)]` needs both `#[window]` and `#[app]` fields, since a visual context borrows the window and the app together ([crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)). Forget a marker and the error points at generated code. Check your fields first.

```rust
// sketch — not API
// Wrong: inventing `#[derive(Element)]` — no such macro exists in gpui_macros.
// Right: `#[derive(IntoElement)]` on a `RenderOnce` type (`gpui_macros.rs:34`).
```

> **Pitfall.** `#[derive(Render)]` exists but stays hidden (`gpui_macros.rs:39`). Implement `Render` by hand instead — the derive is an internal detail, not a promise.

> **Tip.** Property tests replay from seeds, and `SEED` pins a failing run (`test.rs:44`). Paste the seed into your retry command and the flake becomes a repro.

Where next? Drive your new actions with simulated input (`system-testing`).

## Sources

- `derive(Action)`, `register_action`: [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs), [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)
- `derive(IntoElement)`, `derive(Render)`: [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs), [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)
- `derive(AppContext)`, `derive(VisualContext)`: [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs), [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)
- `test`, `bench`, `property_test`: [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs), [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs), [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)
- `actions!`: [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs)
- `SEED` handling: [crates/gpui/src/test.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/test.rs)
