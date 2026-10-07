+++
aliases = ["guide/system/testing/", "system/testing.html"]
title = "Test state, then interaction"
description = "Exercise entity updates in a controlled app and check native behavior where it runs."
weight = 90
+++

Start with the rule that can fail. If a click changes a count, test the state
transition first; this localizes a failure to the model or notification before
rendering is involved. Open a test window when focus, hitboxes, layout, or
dispatch order changes the behavior. Keep identities the same as production so
the test exercises the same retained-state path.

## Enable the controlled app

Enable `test-support` on the core crate in your development dependencies:

```toml
[dev-dependencies]
gpui = { package = "gpui-ce", path = "../../crates/gpui", features = ["test-support"] }
```

Adjust the path to your checkout. [`TestApp`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html)
creates a deterministic test platform. Entity updates flush ready effects, so
this assertion checks the model result immediately:

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

For a view, retain the test window returned by `open_window` and use its
`simulate_click`, `simulate_keystroke`, or `simulate_scroll` methods. These
dispatch input through GPUI's window path and drain ready effects. For tests
that need direct control over the scheduler, use
[`TestAppContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppContext.html)
and [`#[gpui::test]`](https://docs.rs/gpui-ce/0.2.2/gpui/attr.test.html); choose
a seed when deterministic scheduling matters and vary it when looking for
ordering bugs.

## Exercise the window

`TestApp::open_window` builds the root once in a test window. Its returned
window object exposes a typed root handle and input simulation. Focus the same
handle and use the same element IDs as the application; a fixture with
different identities can hide a retained-state or focus-path bug. If a click
does nothing, first assert the view's state after simulated input, then inspect
the focus and hit-test assumptions.

> [!NOTE]
> The default test platform is controlled, not a native desktop. Its default
> text system does not reproduce the fonts and shaping selected by every target;
> its fake HTTP client also returns 404 unless configured otherwise. Supply
> `TestApp::with_text_system` and an asset source when a test depends on shaping,
> font metrics, or loaded resources. This still does not test native IME,
> clipboard permissions, decorations, GPU presentation, or OS accessibility.

Use `TestApp::advance_clock` for timer behavior rather than sleeping. It makes
due test tasks runnable but does not model production wall-clock scheduling or
latency. Assert the resulting state; measure production timing separately.

## Check the platform boundary

Run the relevant example with ordinary Cargo:

```sh
cargo run --example hello_world
cargo run --example actions_and_keybinds
cargo run -p gpui-documentation-examples --example counter
```

A controlled app checks framework behavior. Native decoration, clipboard
permissions, IME composition, accessibility integration, and GPU presentation
need checks on the platform that supplies them. See the
[platform guide](@/guides/platforms.md) for those boundaries.
