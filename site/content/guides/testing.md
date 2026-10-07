+++
aliases = ["guide/system/testing/", "system/testing.html"]
title = "Test state, then interaction"
description = "Exercise entity updates in a controlled app and check native behavior where it runs."
weight = 90
+++

Start with the rule that can fail. If a click changes a count, test the state
transition before checking the whole window. Add an input test when focus,
coordinates, or dispatch order affects the result.

## Enable the controlled app

Enable `test-support` on the core crate in your development dependencies:

```toml
[dev-dependencies]
gpui = { package = "gpui-ce", path = "../../crates/gpui", features = ["test-support"] }
```

Adjust the path to your checkout. [`TestApp`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html)
creates a test platform and flushes pending effects after each update:

```rust
use gpui::TestApp;

#[test]
fn increment_changes_the_count() {
    let mut app = TestApp::new();
    let counter = app.new_entity(|_| 0_u32);
    app.update_entity(&counter, |count, cx| {
        *count += 1;
        cx.notify();
    });
    assert_eq!(app.read_entity(&counter, |count, _| *count), 1);
}
```

For a larger fixture, [`TestAppContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppContext.html)
and [`#[gpui::test]`](https://docs.rs/gpui-ce/0.2.2/gpui/attr.test.html) expose
controlled scheduling and repeated seeded runs. Choose that lower-level context
when the test needs to manage effect flushing explicitly.

## Exercise the window

`TestApp::open_window` builds a view in a test window. Its returned handle can
update the view, dispatch an action, send a keystroke, or simulate pointer input.
Retain the same IDs and focus handles that the real view uses; rebuilding a
fixture with different identities can conceal the bug you are investigating.

> [!NOTE]
> The default test text system does not reproduce native font shaping. Use
> `TestApp::with_text_system` when measurements need a real text backend.

## Check the platform boundary

Run the relevant example with ordinary Cargo:

```sh
cargo run --example hello_world
cargo run --example actions_and_keybinds
cargo run -p gpui-documentation-examples --example counter
```

A controlled app checks framework behavior. Native decoration, clipboard
permissions, IME composition, accessibility integration, and GPU presentation
also need checks on the platform that supplies them. See the
[platform guide](@/guides/platforms.md) for those boundaries.
