+++
aliases = ["guide/system/testing/", "system/testing.html"]
title = "Test state, time, and interaction"
description = "Build observer, timer, cancellation, and input fixtures around the behavior that can fail."
weight = 90
+++

<!-- Mirrored from crates/gpui/docs/testing.md; edit that source. -->

A useful GPUI test states what changes, what causes the change, and what must
remain unchanged. Start with an entity test for a state transition. Add a
window when the rule depends on focus, layout, or input dispatch. Advance the
test clock when the rule depends on time.

These harnesses are available with the `test-support` feature:

```toml
[dev-dependencies]
gpui = { package = "gpui-ce", version = "0.2.2", features = ["test-support"] }
```

| Harness | Choose it when |
| --- | --- |
| [`TestApp`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html) | One application needs entities, simulated windows, and automatic draining of ready tasks after updates |
| [`TestAppContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppContext.html) with `#[gpui::test]` | An async test or several applications need the same seeded scheduler |
| [`HeadlessAppContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.HeadlessAppContext.html) | A host or test needs to control input and frame delivery explicitly |
| `VisualTestAppContext` (macOS only) | A screenshot test needs the real off-screen compositor |

The similarly named [`VisualTestContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.VisualTestContext.html) is a
window-bound **simulated** context obtained from `TestAppContext`. It does not
create a native window or supply the macOS compositor.

## Make the assertion at the right boundary

[`TestApp::update`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html#method.update) flushes app effects, releases its
app borrow, and drains ready tasks before returning. Its entity and window
update helpers follow the same pattern. Reads inspect the resulting state;
they do not run tasks or flush effects.

Here an observer copies the model's count into a display. The test checks both
the changed model and the consumer, so omitting `notify` breaks the test:

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
assert_eq!(app.read_entity(&model, |count, _| *count), 1);
assert_eq!(app.read_entity(&display, |display, _| display.count), 1);
```

The subscription is part of the fixture. A temporary
[`Subscription`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Subscription.html) unsubscribes at the end of its
expression. Store it when the consumer owns the relationship, as above; keep
it in a local binding when the test owns it. The
[shared-state walkthrough](https://gpui-ce.github.io/examples/subscriptions/)
uses the same pattern in a view.

Notifications describe a change to current state. GPUI may coalesce several
pending notifications for one entity. If each occurrence matters, publish a
typed event with [`Context::emit`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html#method.emit) and implement
[`EventEmitter<E>`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.EventEmitter.html). Test its payload and occurrence with
[`TestAppContext::events`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppContext.html#method.events), rather than counting
notifications as if they were events.

## Observe before starting the operation

Install an observation before the operation that should wake it. Waiting only
after the operation can miss the signal. [`gpui::observe`](https://docs.rs/gpui-ce/0.2.2/gpui/test/fn.observe.html)
returns a stream that owns its subscription:

```rust,test_harness
use futures::StreamExt as _;
use gpui::{AppContext as _, TestAppContext};

#[gpui::test]
async fn a_notification_exposes_the_new_count(cx: &mut TestAppContext) {
    let count = cx.new(|_| 0_u32);
    let mut changes = gpui::observe(&count, cx);

    count.update(cx, |count, cx| {
        *count = 7;
        cx.notify();
    });

    assert_eq!(changes.next().await, Some(()));
    assert_eq!(count.read_with(cx, |count, _| *count), 7);
}
```

Dropping this stream unsubscribes. In contrast,
[`TestAppContext::notifications`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppContext.html#method.notifications)
detaches its observation and closes its channel when the entity is released;
dropping that receiver alone does not unregister the observation.

For an eventual state, [`TestAppContext::condition`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppContext.html#method.condition)
checks a predicate immediately, then checks again after notifications. It
panics if the condition is not reached within three **test-clock** seconds.
The operation must notify when the state changes. The helper does not turn a
real network request into scheduler-controlled work.

> [!NOTE]
> `TestAppContext::update` flushes effects but does not drain all ready tasks
> before returning. Use `cx.run_until_parked()` before asserting the result of
> queued work, or await an event that establishes the required boundary.

## Check both sides of a timer deadline

Use the test clock instead of `std::thread::sleep`. Draining ready work polls
a newly spawned future, but it does not advance time to its timer. A test of a
one-second delay should prove that the result is absent just before the
deadline and present at the deadline:

```rust
use gpui::TestApp;
use std::{cell::Cell, rc::Rc, time::Duration};

let app = TestApp::new();
let completed = Rc::new(Cell::new(false));
let timer = app.background_executor().timer(Duration::from_secs(1));
let task = app.spawn({
    let completed = completed.clone();
    |_| async move {
        timer.await;
        completed.set(true);
    }
});

app.run_until_parked();
assert!(!completed.get());
app.advance_clock(Duration::from_millis(999));
assert!(!completed.get());
app.advance_clock(Duration::from_millis(1));
assert!(completed.get());
assert!(task.is_ready());
```

[`TestApp::advance_clock`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html#method.advance_clock) runs ready work as it
crosses timers due in the interval, then leaves the clock at the requested
destination. `TestAppContext` exposes the same operation through
`cx.executor().advance_clock(duration)`. For a debounce, repeat the input
before advancing time and assert that only the replacement operation publishes
its result.

[`Task::is_ready`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Task.html#method.is_ready) reports that a task finished or was
cancelled. It does not prove that the operation produced its expected value;
the timer test above establishes that through `completed`. Await the task
when its output is the subject of the assertion. If the test may shut down
the task's executor, await [`task.fallible()`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Task.html#method.fallible) to
distinguish cancellation from a returned value.
The scheduler's `run_with_clock_advancement` has a different purpose: it
advances through pending timers until no work remains. That is convenient for
finishing a finite operation, but it cannot establish a “not yet” assertion
and will not finish an operation that schedules timers forever.

## Test cancellation after work has started

Dropping a [`Task`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Task.html) cancels its future after its current poll
returns. A cancellation test should first establish that the future started,
then drop the handle and drain the cancellation. A guard inside the future
makes its destruction observable:

```rust
use gpui::TestApp;
use std::{cell::Cell, future::pending, rc::Rc};

struct OnDrop(Rc<Cell<bool>>);
impl Drop for OnDrop {
    fn drop(&mut self) {
        self.0.set(true);
    }
}

let app = TestApp::new();
let started = Rc::new(Cell::new(false));
let cancelled = Rc::new(Cell::new(false));
let task = app.spawn({
    let started = started.clone();
    let cancelled = cancelled.clone();
    |_| async move {
        let _guard = OnDrop(cancelled);
        started.set(true);
        pending::<()>().await;
    }
});

app.run_until_parked();
assert!(started.get());
assert!(!cancelled.get());
drop(task);
app.run_until_parked();
assert!(cancelled.get());
```

For a task stored on a view, replace or release that owner and check the same
boundary. Avoid capturing a strong handle to the owner in its own task; such a
cycle can prevent release. [`Context::spawn`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html#method.spawn) supplies
a weak entity handle for updates after an await.

> [!WARNING]
> Cancelling GPUI's future does not undo an HTTP request or write it already
> performed. Test the external operation's own cancellation or transaction
> contract separately.

## Reject a result from a replaced request

Cancellation cannot reject a result that has already escaped the cancelled
operation. Search and reload code often also needs a request identity: apply
the result only if it belongs to the current request. Test that rule by
delivering the newer result first, then releasing the older one.

Here each channel stands in for a request's completion. Both tasks remain
alive so cancellation cannot hide a missing identity check:

```rust
use futures::channel::oneshot;
use gpui::{Entity, Task, TestApp};

struct Search {
    generation: u64,
    result: Option<&'static str>,
}

fn start_request(
    app: &mut TestApp,
    search: &Entity<Search>,
    reply: oneshot::Receiver<&'static str>,
) -> Task<()> {
    let generation = app.update_entity(search, |search, cx| {
        search.generation += 1;
        search.result = None;
        cx.notify();
        search.generation
    });
    let search = search.downgrade();
    app.spawn(move |mut cx| async move {
        let result = reply.await.expect("the test must deliver a reply");
        search.update(&mut cx, |search, cx| {
            if search.generation == generation {
                search.result = Some(result);
                cx.notify();
            }
        }).expect("the fixture must keep the search alive");
    })
}

let mut app = TestApp::new();
let search = app.new_entity(|_| Search { generation: 0, result: None });
let (old_reply, old_result) = oneshot::channel();
let old_task = start_request(&mut app, &search, old_result);
let (new_reply, new_result) = oneshot::channel();
let new_task = start_request(&mut app, &search, new_result);

new_reply.send("current").unwrap();
app.run_until_parked();
assert!(new_task.is_ready());
assert_eq!(app.read_entity(&search, |search, _| search.result), Some("current"));

old_reply.send("obsolete").unwrap();
app.run_until_parked();
assert!(old_task.is_ready());
assert_eq!(app.read_entity(&search, |search, _| search.result), Some("current"));
```

Removing the generation check makes the last assertion fail. The fixture
controls the race itself; a sleep or repeated scheduler seed would only hope
to encounter it. Keep this assertion when adding task cancellation to the
application. Hummingbird's
[async-resource tests](https://github.com/hummingbird-player/hummingbird/blob/2e1ee5f1c8d415ef7f835801fe368ab4106035b5/src/ui/components/async_resource.rs#L345-L393)
exercise the same distinction between abandoning work and rejecting its result.

## Exercise the input path

Calling a handler directly checks its state transition. Simulating input also
checks whether GPUI can reach it. This button owns a focus handle, tracks it on
the rendered element, and accepts primary clicks. The test covers pointer
activation and keyboard activation of that same element:

```rust
use gpui::{Context, FocusHandle, KeyUpEvent, Keystroke, MouseButton, Render, Role, TestApp, Window, div,
           point, prelude::*, px};

struct Counter {
    count: u32,
    focus: FocusHandle,
}

impl Render for Counter {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("increment")
            .role(Role::Button)
            .aria_label("Increment")
            .track_focus(&self.focus)
            .size(px(80.))
            .on_click(cx.listener(|this, _, _, cx| {
                this.count += 1;
                cx.notify();
            }))
            .child("Increment")
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, cx| Counter {
    count: 0,
    focus: cx.focus_handle().tab_stop(true),
});
window.draw();
window.simulate_mouse_move(point(px(10.), px(10.)));
window.simulate_click(point(px(10.), px(10.)), MouseButton::Left);
assert_eq!(window.read(|counter, _| counter.count), 1);

window.update(|counter, window, cx| window.focus(&counter.focus, cx));
window.draw();
window.simulate_keystroke("enter");
assert_eq!(window.read(|counter, _| counter.count), 1);
window.simulate_event(KeyUpEvent {
    keystroke: Keystroke::parse("enter").unwrap(),
});
assert_eq!(window.read(|counter, _| counter.count), 2);
```

Draw before pointer input so the frame contains current bounds and hitboxes.
`simulate_keystroke` sends a key press; send a release as well when testing
click activation, which requires a matching press and release.
Keep the view's element IDs and focus handles stable across draws, as in the
application. To test a key binding, install the binding, set its
[`KeyContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.KeyContext.html) on the focused element, and simulate the
keystroke. Dispatching the action directly bypasses key matching and cannot
detect an incorrect context expression.

[`TestAppWindow::simulate_input`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppWindow.html#method.simulate_input)
dispatches keystrokes for Unicode scalars; it does not reproduce native
[input method](https://en.wikipedia.org/wiki/Input_method) composition. For
composition behavior, test the text-input handler's replacement and marked
range rules directly, then check the native platform path.

### Test composition as a sequence

A test that inserts one string cannot catch an editor that appends every IME
candidate. Start with a buffer containing a non-BMP character such as `a🦀z`;
the crab spans four UTF-8 bytes and two UTF-16 code units. Then exercise the
[input protocol](https://gpui-ce.github.io/book/input.html#replace-provisional-text-instead-of-appending-it):

1. Replace UTF-16 range `1..3` with marked text `に`. Check the buffer `aにz`,
   marked range `1..2`, and selected caret or range.
2. Replace with marked text `日本` and no explicit document range. Check
   `a日本z`, not accumulated candidates, and marked range `1..3`.
3. Let effects run and check the mark again. Observing the editor's own buffer
   notification must not accidentally end composition.
4. Commit `日本語` without an explicit range. Check `a日本語z`, no marked range,
   and the caret at UTF-16 offset four.

Also test `unmark_text` without a replacement: its text must remain. Set a
reversed selection and check both the sorted range and active-end flag before
replacing it. If another owner can replace the buffer, test how the editor
repairs its selection and abandons stale composition. The
[composed-input example's tests](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/examples/view_example/example_tests.rs)
run these sequences against the example's editor.

Geometry assertions need a matching layout. GPUI's default simulated text
system reports one visual row even for hard line breaks. Use
[`TestApp::with_text_system`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html#method.with_text_system) with real shaping
and a bundled font when checking multiline caret positions, bidi, or wrapping.
Draw the text, query its range bounds, and map a point back to a document offset.
Then edit without repainting and check that the handler declines stale geometry.
These assertions check the editor's protocol; a native test still needs to
exercise candidate-window placement and the operating system's IME callbacks.

## Reproduce an ordering failure

`TestApp::new` uses seed zero. [`TestApp::with_seed`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html#method.with_seed)
chooses another runnable ordering. `#[gpui::test]` can run the same body with
several scheduler seeds:

```rust,test_harness
use gpui::{AppContext as _, TestAppContext};

#[gpui::test(iterations = 32)]
fn ready_work_updates_the_count(cx: &mut TestAppContext) {
    let count = cx.new(|_| 0_u32);
    let task = cx.spawn({
        let count = count.clone();
        |mut cx| async move {
            count.update(&mut cx, |count, cx| {
                *count += 1;
                cx.notify();
            });
        }
    });
    cx.run_until_parked();
    assert!(task.is_ready());
    assert_eq!(count.read_with(cx, |count, _| *count), 1);
}
```

Rerun a reported failure with its seed:

```sh
SEED=17 cargo test ready_work_updates_the_count
```

`SEED` overrides explicit `seed` or `seeds(...)` arguments. `ITERATIONS`
overrides the iteration count. With one iteration, `SEED=17` runs seed 17
alone; with several iterations it starts the sequence there. Property tests
also use `SEED` for case generation. Add explicit yield points or controlled
channels at the boundaries that can race; repeating a test cannot reveal an
ordering the fixture makes impossible.

## Assert drawing before comparing pixels

If the regression concerns a requested color, border, or paint rectangle,
inspect the recorded drawing before introducing a pixel comparison. Draw the
frame explicitly: updating state and draining tasks do not, by themselves,
establish that a new frame was built.

```rust
use gpui::{Context, IntoElement, Render, TestApp, Window, div, prelude::*, px, rgb, size};

struct Swatch;
impl Render for Swatch {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child(
            div().w(px(80.)).h(px(32.)).flex_shrink_0().bg(rgb(0x155b50))
        )
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, _| Swatch);
window.draw();
window.update(|_, window, _| {
    let swatch = window.painted_quads().into_iter()
        .find(|quad| quad.background == rgb(0x155b50).into())
        .expect("the swatch should have been painted");
    assert_eq!(
        swatch.bounds.size,
        size(px(80.), px(32.)).scale(window.scale_factor()),
    );
});
```

The recorded bounds use scaled pixels, hence the explicit density conversion.
[`Window::painted_quads`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.painted_quads) returns geometry before
clipping; inspect each quad's content mask when clipping is the subject of the
test. This assertion establishes what GPUI recorded. It cannot establish how a
GPU rasterized the border or antialiased its corners.

A headless host can inspect the complete command stream with
[`HeadlessAppContext::read_scene`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.HeadlessAppContext.html#method.read_scene), or
create a portable [`SceneCapture`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.SceneCapture.html) for comparison.
Capture requires a resolver for referenced atlas pixels, but no pixel renderer.
See [custom drawing](https://gpui-ce.github.io/book/drawing.html) for capture and import.

For a rasterization regression, compare renderer output. On macOS,
`VisualTestAppContext::capture_screenshot` reads the last built scene through
the supplied platform renderer. Build the intended frame with
[`Window::draw`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.draw) and clear its returned arena token first;
capturing alone does not rebuild a dirty view. Keep a failing actual image and
a difference image beside the expected image so a changed baseline can be
reviewed. Choose a pixel tolerance according to the behavior under test, rather
than silently accepting every change near an edge.

## Choose what a simulated platform can establish

`TestApp` uses simulated text metrics, a fake HTTP client returning 404, and
an in-memory platform. Use [`TestApp::with_text_system`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html#method.with_text_system)
or [`TestApp::with_text_system_and_assets`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestApp.html#method.with_text_system_and_assets)
when layout depends on real font shaping or resources. Install the test HTTP
client through [`App::set_http_client`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.App.html#method.set_http_client) when a
resource loader must receive a particular response.

[`HeadlessAppContext::set_automatic_drawing`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.HeadlessAppContext.html#method.set_automatic_drawing)
lets a host batch updates and input before drawing. Advancing its clock and
delivering a next-frame callback are separate operations. Its default scene
recording has no pixel renderer; supply one through `with_platform` for pixel
capture.

On macOS, `VisualTestAppContext` captures the real off-screen compositor.
Supply its asset source when the view needs SVGs; the default source is empty.
Control fonts, scale, viewport, and motion when comparing screenshots. Use
platform integration tests for native IME, accessibility announcements,
window-manager behavior, clipboard permissions, and GPU presentation.

## Measure work separately

Enable `bench-support` for `#[gpui::bench]`. Use
[`BenchAppContext::bench_iter`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.BenchAppContext.html#method.bench_iter)
for synchronous work,
[`bench_task`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.BenchAppContext.html#method.bench_task)
for a returned task through completion, and
[`bench_batched_task`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.BenchAppContext.html#method.bench_batched_task)
when fresh setup belongs outside the timed region. Use
[`bench_renderer`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.BenchAppContext.html#method.bench_renderer)
to include drawing and presentation.

These benchmarks use real workers and wall-clock time. Their frame-budget
counts estimate how much work fits a budget; they do not count observed vsync
misses. Deterministic tests establish behavior under the chosen schedule and
time. Benchmarks measure the cost of that behavior on the machine running them.
