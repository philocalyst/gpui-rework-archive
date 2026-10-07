# Test state and effect timing

[`TestApp`](crate::TestApp) supplies a simulated platform and controlled
scheduling without opening a native window. Enable `test-support` to use it.
Its update methods flush app effects and drain ready work before returning.
This makes the boundary between a mutation and an observer's result visible
in a test.

## Observe a separate model

This test gives the consumer a derived count and a retained subscription.
Creating the consumer completes one app update, so the observer is active
before the later update notifies the model:

```rust
use gpui::{Subscription, TestApp};

struct DisplayCount {
    count: u32,
    _observation: Subscription,
}

let mut app = TestApp::new();
let model = app.new_entity(|_| 0_u32);
let display = app.new_entity(|cx| DisplayCount {
    count: 0,
    _observation: cx.observe(&model, |display: &mut DisplayCount, model, cx| {
        display.count = *model.read(cx);
        cx.notify();
    }),
});

app.update_entity(&model, |count, cx| {
    *count += 1;
    cx.notify();
});
assert_eq!(app.read_entity(&display, |display, _| display.count), 1);
```

A read borrows current state without flushing effects. An assertion inside the
mutating closure can therefore see a value from before the queued observer runs.
The assertion above happens after `update_entity` returns.

Keep the subscription in an owning field. A temporary subscription cancels at
the end of the constructor and never observes the later notification. The
[shared-state walkthrough](https://gpui-ce.github.io/examples/subscriptions/)
uses the same relationship in a visible view.

## Advance time explicitly

[`TestApp::run_until_parked`](crate::TestApp::run_until_parked) drains ready work
without advancing time. Poll a timer into its waiting state, advance the clock,
then drain the scheduler again:

```rust
use gpui::TestApp;
use std::time::Duration;

let mut app = TestApp::new();
let task = app.background_executor().timer(Duration::from_secs(1));
app.run_until_parked();
assert!(!task.is_ready());
app.advance_clock(Duration::from_secs(1));
app.run_until_parked();
assert!(task.is_ready());
```

Dropping a task cancels its remaining work. Detach only when the test intends
that work to continue without its local handle. Retain foreground tasks and
drive their executor so completion is part of the test's setup.

## Check input after layout

[`TestApp::open_window`](crate::TestApp::open_window) returns a
[`TestAppWindow`](crate::TestAppWindow) for view updates and input simulation.
Call [`draw`](crate::TestAppWindow::draw) when pointer input needs current
layout or hit-test state. Keystrokes, scalar text input, actions, pointer events,
and resize notifications then pass through GPUI's dispatch path.

The default test text system supplies simulated measurements. Use
[`TestApp::with_text_system`](crate::TestApp::with_text_system) when the result
depends on actual shaping. Native decoration, IME composition, accessibility
integration, and GPU presentation need checks on the platform that supplies
them; a simulated window cannot establish those contracts.
