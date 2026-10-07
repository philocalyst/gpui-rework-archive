# Test state, time, and effects

Pick a harness for the behavior under test. [`TestApp`](crate::TestApp) is the
smallest option for entities, views, simulated input, and deterministic task
completion. [`TestAppContext`](crate::TestAppContext) is the context supplied
to `#[gpui::test]` and supports multiple app contexts that share the test
scheduler. [`HeadlessAppContext`](crate::HeadlessAppContext) lets an external
host drive windows, input, frames, and drawing. The macOS-only
[`VisualTestAppContext`](crate::VisualTestAppContext) combines deterministic
tasks with actual platform rendering for screenshots.

## Observe state after effects run

`TestApp::update` and `TestAppWindow::update` flush effects and drain work that
is ready before they return. `read` methods only inspect current state; they
do not flush observers or other queued effects. Create the observer before the
update that should notify it, and retain the subscription for as long as it
should remain active:

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

A temporary `Subscription` is dropped at the end of its expression and stops
observing. The
[shared-state walkthrough](https://gpui-ce.github.io/examples/subscriptions/)
shows the same relationship in a view. When using `TestAppContext`, the
[`gpui::observe`](crate::observe) helper exposes notifications as a stream;
its owning `Observation` keeps the subscription alive and unsubscribes when
dropped.

## Drive timers with the test clock

Draining ready work does not invent elapsed time. Poll a timer into its waiting
state, then advance simulated time; advancing runs work due within the interval:

```rust
use gpui::TestApp;
use std::time::Duration;

let app = TestApp::new();
let timer = app.background_executor().timer(Duration::from_secs(1));
app.run_until_parked();
assert!(!timer.is_ready());

app.advance_clock(Duration::from_secs(1));
assert!(timer.is_ready());
```

`is_ready` reports completion but does not produce the task's output. Await the
task in a foreground task when the value matters. Dropping the timer or its
owning task cancels unfinished work; detaching lets it run without a handle.
For `TestAppContext`, `cx.executor().advance_clock(duration)` advances time and
runs work due within that interval. `run_until_parked` drains work that is
already runnable without advancing time. The same behavior applies to
`HeadlessAppContext` and the legacy `VisualTestContext`, which share the test
scheduler. `VisualTestAppContext` exposes its own clock controls. The
scheduler's `run_with_clock_advancement` is different: it advances to each
pending timer until no further work or timers remain.

`#[gpui::test]` uses a seeded scheduler that can vary runnable ordering. Pin a
failure with the reported `SEED` value; property tests also use this seed for
case generation. A passing run covers the interleavings and simulated time
that the test actually drove. It does not prove all possible schedules,
production thread timing, or an external service's cancellation behavior.

## Choose app, window, or host-level testing

Use [`TestApp::open_window`](crate::TestApp::open_window) and its returned
[`TestAppWindow`](crate::TestAppWindow) when a test needs a root view plus
keystrokes, text input, pointer events, or resizing. `TestAppWindow::draw`
refreshes layout and hit-test state before pointer input; its simulation
methods then use GPUI's normal dispatch path. `TestAppContext` offers the
legacy [`VisualTestContext`](crate::VisualTestContext) for window-bound input
and element inspection.

Use [`HeadlessAppContext`](crate::HeadlessAppContext) when the test or embedding
host needs explicit frame control. Its default app effects draw dirty windows;
call `set_automatic_drawing(false)` to batch updates, input, and drawing at a
chosen frame boundary. Advancing the clock and delivering a next-frame callback
are separate operations. `HeadlessAppContext::new` records the GPUI scene but
has no pixel renderer; `with_platform` can install a renderer for screenshot
capture.

The default `TestApp` text system supplies simulated measurements. Use
[`TestApp::with_text_system`](crate::TestApp::with_text_system) with the fonts
and platform text system needed when the result depends on real shaping. A
simulated platform cannot establish native IME composition, accessibility,
window-manager behavior, GPU presentation, or real network/filesystem timing.
Use platform integration tests for those contracts. For screenshot tests on
macOS, `VisualTestAppContext` renders off-screen with the real compositor; its
default no-op asset source omits SVG assets unless supplied with
`with_asset_source`.

For performance, enable `bench-support` and use `#[gpui::bench]`. Choose the
measurement around the work: `BenchAppContext::bench_iter` for synchronous
state changes, `BenchAppContext::bench_task` to measure a returned `Task`
through completion, and `BenchAppContext::bench_batched_task` when each
iteration needs fresh setup outside the timed region. Use `bench_renderer`
when the entity update should be measured through drawing and presentation.
These benchmarks use real background worker concurrency and wall-clock timers;
they complement deterministic tests rather than proving a performance bound
on every machine. Their frame-budget counts are synthetic estimates, not
observed vsync misses.
