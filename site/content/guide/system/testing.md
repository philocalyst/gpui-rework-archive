+++
title = "Testing: drive the app like a user"
description = "Exercise state changes and input using GPUI’s test contexts and supporting tools."
weight = 34
aliases = ["/system/testing.html"]
[extra]
category = "SYSTEM"
legacy_source = "gpui-ce-docs/build/html/system/testing.html"
+++

Your test should click what users click. A **TestAppContext** runs headless app logic with no window ([crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)), while a **VisualTestContext** adds a real window for input and pixels ([crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)). The `#[gpui::test]` macro wires either into `cargo test` ([crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)). Start headless, go visual the moment input matters.

## Test anatomy in ten lines

```rust
#[gpui::test] // harness entry — expands to `run_test` with seed support (`test.rs:95`)
async fn counter_increments(cx: &mut TestAppContext) {
    // Open a real window with your real view. Needs a constructor closure.
    let (view, cx) = cx.add_window_view(|_, cx| Counter::new(cx)); // `test_context.rs:319`
    // Type like a user. Visual context — no window handle needed here.
    cx.simulate_keystrokes("j"); // `test_context.rs:825` — key events, not raw text
    // Render before you assert, or you read yesterday's layout.
    cx.draw(); // `test_context.rs:924` — paints the scene so state settles
    // Borrow window plus app together and check what the user would see.
    cx.update(|_window, cx| view.read(cx).count()); // `test_context.rs:779`
}
```

Read it top to bottom: attribute, window, input, draw, assert. Skip `draw` and your assertion races layout. Skip `update` and you borrow the wrong context. Ten lines, same order, every time.

> **Tip.** Keep one constructor per test (`add_window_view` for views, `add_window` for raw windows at `test_context.rs:251`). Shared setup across tests breeds shared flakes.

## Input simulation coverage

Two contexts, two signatures — that is the whole confusion, so here it is plainly. `TestAppContext` methods take an explicit window handle, because headless tests can juggle several windows. `VisualTestContext` methods skip the handle, because the window is already yours.

|  |  |  |
| --- | --- | --- |
| Call | Where it lives | What you should know |
| `simulate_keystrokes` | `test_context.rs:529` + `test_context.rs:825` | key events; headless form takes a window handle |
| `simulate_input` | `test_context.rs:545` + `test_context.rs:831` | raw text input; bypasses key bindings |
| `simulate_click` | `test_app.rs:442` + `test_context.rs:881` | headless takes position + button; visual takes position + modifiers |
| `draw` | `test_app.rs:485` + `test_context.rs:924` | renders before pixel or layout asserts |
| `run_test` + `SEED` | `test.rs:95` + `test.rs:44` | harness entry; `SEED=123 cargo test` replays a seed |

Table 40: Every input-simulation call, and which context owns it.

```rust
// sketch — not API
// Wrong: asserting view state without a flush — you may read pre-layout state.
// view.read(cx).count() // stale! call `draw` or `update` first, then assert.
// Right: `simulate_click(point(10.0, 20.0), Modifiers::default())`, then `draw()`.
```

> **Pitfall.** `simulate_input` sends text, not keys. Testing a `j` binding with `simulate_input("j")` passes input but never fires the binding — use `simulate_keystrokes("j")` for keymaps.

Fake the network while you are here: `FakeHttpClient::with_200_response` stands in for servers (`system-assets-http`). Pin flakes with `SEED=123 cargo test`, since `run_test` honors that variable ([crates/gpui/src/test.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/test.rs)).

Where next? Open [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs) and write your first visual test.

## Sources

- `TestAppContext`, `VisualTestContext`: [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)
- `add_window`, `add_window_view`: [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)
- `simulate_keystrokes`, `simulate_input` (both contexts): [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)
- `simulate_click`, `draw`: [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs), [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)
- Window-reader `simulate_click`, `draw`: [crates/gpui/src/app/test_app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_app.rs), [crates/gpui/src/app/test_app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_app.rs)
- `run_test`, `SEED`: [crates/gpui/src/test.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/test.rs), [crates/gpui/src/test.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/test.rs)
- `#[gpui::test]`: [crates/gpui_macros/src/gpui_macros.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_macros/src/gpui_macros.rs)
