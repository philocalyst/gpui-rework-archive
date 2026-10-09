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

Enable `test-support` on the GPUI dependency used by the application. For an
application beside this checkout, the development dependency is:

```toml
[dev-dependencies]
gpui = { package = "gpui-ce", path = "../gpui-ce/crates/gpui", features = ["test-support"] }
```

Adjust the path to your checkout. Keep the application and its tests on the
same GPUI source: the version declared by a development checkout does not
establish that these APIs exist in the published crate with that number.
For a published dependency, use its matching documentation and release.

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

Both `TestApp` and `TestAppContext` draw dirty simulated windows while flushing
effects by default. `TestAppContext::skip_drawing` disables drawing for a
model-only test. An explicit draw is useful when the assertion needs a frame
at a chosen clock value, including a frame that is not otherwise dirty. Use
[`TestAppWindow::draw`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppWindow.html#method.draw) outside a root-view update:
drawing while that update still holds the root's mutable borrow would try to
borrow it again for rendering.

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

### Preserve each event's payload

An event can record an occurrence that is no longer visible in the publisher's
current state. This document publishes two saves in one update. The event
stream must preserve both revisions in order, although reading the document
after the update sees only revision two:

```rust
use futures::{FutureExt as _, StreamExt as _};
use gpui::{AppContext as _, EventEmitter, TestAppContext};

#[derive(Clone, Debug, PartialEq)]
struct Saved { revision: u64 }

struct Document { revision: u64 }
impl EventEmitter<Saved> for Document {}

#[gpui::test]
async fn each_save_keeps_its_revision(cx: &mut TestAppContext) {
    let document = cx.new(|_| Document { revision: 0 });
    let mut saves = cx.events(&document);

    document.update(cx, |document, cx| {
        for _ in 0..2 {
            document.revision += 1;
            cx.emit(Saved { revision: document.revision });
        }
        cx.notify();
    });

    assert_eq!(saves.next().await, Some(Saved { revision: 1 }));
    assert_eq!(saves.next().await, Some(Saved { revision: 2 }));
    assert!(saves.next().now_or_never().is_none());
    assert_eq!(document.read_with(cx, |document, _| document.revision), 2);
}
```

The third assertion checks that no extra event is queued at this boundary;
it does not wait for future work. For one expected occurrence, install
[`Entity::next_event`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Entity.html#method.next_event) before starting the operation.
That future owns its subscription and unsubscribes on drop.

## Observe before starting the operation

Install an observation before the operation that should wake it. Waiting only
after the operation can miss the signal. [`gpui::observe`](https://docs.rs/gpui-ce/0.2.2/gpui/test/fn.observe.html)
returns a stream that owns its subscription:

```rust
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

### Separate animation time from frame delivery

An [animation element](https://docs.rs/gpui-ce/0.2.2/gpui/trait.AnimationExt.html) samples the app executor's clock
when it builds its child. Moving that clock does not by itself establish that
a new frame was drawn. Sample both boundaries: advance time, then draw and
inspect the result.

Here a bar grows from 20 to 120 logical pixels in one second. The assertions
check its initial width, the halfway width, and the endpoint. A repeated initial
value would expose lost element identity; an immediate endpoint would expose
an animation that never ran.

```rust
use gpui::{Animation, AnimationExt, Context, IntoElement, Render, TestApp,
           Window, div, prelude::*, px, rgb, size};
use std::time::Duration;

struct LoadingBar;
impl Render for LoadingBar {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child(
            div()
                .h(px(12.))
                .bg(rgb(0x155b50))
                .with_animation(
                    "loading-bar",
                    Animation::new(Duration::from_secs(1)),
                    |bar, progress| bar.w(px(20. + 100. * progress)),
                )
        )
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, _| LoadingBar);
for (elapsed, expected_width) in [(0, 20.), (500, 70.), (500, 120.)] {
    app.advance_clock(Duration::from_millis(elapsed));
    window.draw();
    window.update(|_, window, _| {
        let bar = window.painted_quads().into_iter()
            .find(|quad| quad.background == rgb(0x155b50).into())
            .expect("the frame must contain the bar");
        assert_eq!(bar.bounds.size,
            size(px(expected_width), px(12.)).scale(window.scale_factor()));
    });
}
```

Keep the animation's ID stable across those draws. To test replay, change that
ID and assert the initial width again. For a frame-request regression, deliver
[`Window::simulate_next_frame`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.simulate_next_frame) as well;
an explicit `draw` checks the resulting frame even if the animation failed to
request one.

The clock belongs to the adapter. [`Animated`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Animated.html) accepts an
explicit clock type, so a `Duration` clock can test interpolation without an
app. [`Transition`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Transition.html) uses `std::time::Instant`; advancing the
executor clock does not advance its run. Duration and spring animation elements
use the executor clock. See the [animation chapter](https://gpui-ce.github.io/book/animation.html)
before choosing which layer to test.

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

## Separate task ownership from entity ownership

[`Context::spawn`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html#method.spawn) gives the future a weak entity handle.
That prevents the future from retaining the entity, but does not cancel the
future when the entity is released. This test keeps the task outside its
entity, releases the entity while the task waits, then lets the task finish:

```rust
use futures::{channel::oneshot, FutureExt as _};
use gpui::TestApp;

let mut app = TestApp::new();
let entity = app.new_entity(|_| String::from("draft"));
let weak = entity.downgrade();
let (complete, completion) = oneshot::channel();
let task = app.update_entity(&entity, |_, cx| {
    cx.spawn(async move |this, cx| {
        completion.await.unwrap();
        this.update(cx, |_, _| ()).is_err()
    })
});

drop(entity);
app.update(|_| {}); // Release the value while the task waits on its channel.
assert!(weak.upgrade().is_none());
assert!(!task.is_ready());

complete.send(()).unwrap();
app.run_until_parked();
assert_eq!(task.now_or_never(), Some(true)); // Completed; entity update failed.
```

The final assertion retrieves the task's output. It establishes both that the
future ran after release and that its attempted entity update returned an error.
A detached task can outlive the entity in the same way. Store the task on the
entity when releasing the entity should cancel it, and avoid a strong handle
back to that owner. Closing a window likewise does not cancel a task supplied
with an [`AsyncWindowContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.AsyncWindowContext.html); the future must
handle a failed window update if it can outlive the window.

## Check which window an update selects

A shared entity can appear in more than one window. Its current window is the
last one whose rendered tree read it. An
[`AsyncWindowContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.AsyncWindowContext.html), in contrast, remembers the
window that created that context. Test both choices when a completion must
return to the window that started the operation:

```rust
use gpui::{AppContext as _, Context, Entity, IntoElement, Render, TestApp,
           Window, div, prelude::*};

struct DocumentView {
    document: Entity<String>,
}

impl Render for DocumentView {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div().child(self.document.read(cx).clone())
    }
}

let mut app = TestApp::new();
let mut first = app.open_window(|_, cx| DocumentView {
    document: cx.new(|_| String::from("shared draft")),
});
let document = first.read(|view, _| view.document.clone());
let mut origin = first.update(|_, window, cx| window.to_async(cx));
let first_id = origin.window_handle();
assert_eq!(
    document.update_in(&mut origin, |_, window, _| window.window_handle()).unwrap(),
    first_id,
);

let mut second = app.open_window(|_, _| DocumentView { document: document.clone() });
let second_id = second.update(|_, window, _| window.window_handle());
second.draw();

// Entity-scoped access follows the latest rendered read, even through `origin`.
assert_eq!(
    document.update_in(&mut origin, |_, window, _| window.window_handle()).unwrap(),
    second_id,
);
// Explicit window access still targets the first window.
assert_eq!(origin.update(|window, cx| {
    document.update(cx, |_, _| window.window_handle())
}).unwrap(), first_id);

second.update(|_, window, _| window.remove_window());
assert!(document.update_in(&mut origin, |_, _, _| ()).is_err());
assert!(origin.update(|_, _| ()).is_ok());

first.draw(); // Reestablish the document's association with the surviving window.
assert_eq!(
    document.update_in(&mut origin, |_, window, _| window.window_handle()).unwrap(),
    first_id,
);
```

The failed entity-scoped update after closure is deliberate. GPUI does not
search other open windows for a substitute. A later draw establishes a new
association; a retained window handle instead always identifies the same
window. See [ownership and data flow](https://gpui-ce.github.io/book/ownership.html#choose-the-window-an-operation-belongs-to)
before choosing an `_in` helper for shared state.

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

## Check that teardown releases the owner

An entity can disappear from the screen while a callback or task still retains
it. Take a [`leak snapshot`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.App.html#method.leak_detector_snapshot) before creating
the owner, then close or release the fixture and flush effects before checking
for new retained entities. `test-support` enables this handle tracking.

This fixture keeps a model alive but releases its observer. The snapshot
exempts the existing model, so the check is specific to the new consumer:

```rust
use gpui::{Subscription, TestApp};

struct Consumer {
    _observation: Subscription,
}

let mut app = TestApp::new();
let model = app.new_entity(|_| 0_u32);
let before = app.read(|cx| cx.leak_detector_snapshot());
let consumer = app.new_entity(|cx| Consumer {
    _observation: cx.observe(&model, |_: &mut Consumer, _, _| {}),
});
let weak_consumer = consumer.downgrade();

drop(consumer);
app.update(|_| {}); // Release the value and drop its subscription.
assert!(weak_consumer.upgrade().is_none());
app.read(|cx| cx.assert_no_new_leaks(&before));
assert_eq!(app.read_entity(&model, |value, _| *value), 0);
```

For a view, close its window and drop any root handle retained by the test.
For a pending task, establish that it started before releasing its owner, as
in the cancellation test above. If the assertion fails, inspect callbacks
that capture a strong owner, tasks stored on the same entity they retain,
and detached subscriptions. `Context::observe` holds the consumer weakly;
`observe_self` and `subscribe_self` retain their target and need a separate
subscription owner. The [ownership chapter](https://gpui-ce.github.io/book/ownership.html#keep-the-subscription)
explains that difference.

Rerun a failing test with `LEAK_BACKTRACE=1` to include the retained handles'
creation sites. A snapshot compares entity IDs, not allocation totals: it
ignores every entity already present, including extra clones of those entities
made later. Pair it with a targeted weak-handle or drop assertion when checking
the lifetime of an existing owner. It does not detect arbitrary `Rc` cycles,
GPU allocations, or a resource intentionally retained by another subsystem.

An entity's slot is removed before its release callbacks and destructor run.
[`WeakEntity::assert_released`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.AnyWeakEntity.html#method.assert_released) checks
that slot and its strong handles; it can pass inside a release callback.
Record a drop guard as well when the test needs to establish destruction of a
resource. [`Context::on_release`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html#method.on_release) shows the callback
and destructor order in an asserting example.

### Separate a close decision from teardown

A close request asks whether the window may close. Teardown removes the window
and releases its root. [`VisualTestContext::simulate_close`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.VisualTestContext.html#method.simulate_close)
tests the first step: it calls the installed callback and returns the decision.
It does not perform the platform's subsequent removal, even when the decision
is `true`.

This fixture vetoes a request while the document is dirty, then allows one after
saving. The window remains open after both decisions. Explicit removal and
dropping the test's root handle establish the separate release boundary:

```rust
use gpui::{Context, IntoElement, Render, TestAppContext, VisualTestContext,
           Window, div};

struct Document { dirty: bool }
impl Render for Document {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div()
    }
}

let mut app = TestAppContext::single();
let handle = app.add_window(|window, cx: &mut Context<Document>| {
    let document = cx.entity().downgrade();
    window.on_window_should_close(cx, move |_, cx| {
        document.read_with(cx, |document, _| !document.dirty).unwrap_or(true)
    });
    Document { dirty: true }
});
let root = handle.root(&mut app).unwrap();
let weak = root.downgrade();
let mut window = VisualTestContext::from_window(*handle, &app);

assert!(!window.simulate_close());
root.update(&mut app, |document, _| document.dirty = false);
assert!(window.simulate_close());
assert_eq!(app.windows().len(), 1);

window.update(|window, _| window.remove_window());
assert!(app.windows().is_empty());
assert!(weak.upgrade().is_some()); // The test still owns `root`.
drop(root);
app.update(|_| {}); // Flush release effects.
assert!(weak.upgrade().is_none());
app.quit();
```

Do not remove the window inside the callback used by `simulate_close`: the
helper restores that callback after obtaining its decision and panics if the
window has disappeared. For an asynchronous confirmation, return `false`,
answer the prompt, then remove the window from the continuation. Test the
continuation separately from the initial veto. The
[platform chapter](https://gpui-ce.github.io/book/platforms.html#wait-for-a-prompt-without-blocking-the-window)
shows that ownership pattern.

## Keep row state with its record

A list can look correct while its retained state belongs to the wrong row.
Test identity by changing one row's state, reordering the records, and checking
that the state follows its record. Distinct initial values catch an accidental
shared key before the reorder.

This `RenderOnce` component uses one `use_state` call site for every row. The
parent's record key gives each call a separate scope. The map lets the test
inspect those state handles without depending on text shaping:

```rust
use gpui::{App, Context, Entity, IntoElement, Render, RenderOnce, TestApp,
           Window, div, prelude::*, text};
use std::{cell::RefCell, collections::BTreeMap, rc::Rc};

type States = Rc<RefCell<BTreeMap<u64, Entity<u64>>>>;

#[derive(IntoElement)]
struct Row { id: u64, states: States }
impl RenderOnce for Row {
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        let state = window.use_state(cx, |_, _| self.id);
        self.states.borrow_mut().insert(self.id, state.clone());
        div().child(text!(state.read(cx).to_string()))
    }
}

struct Records { ids: Vec<u64>, states: States }
impl Render for Records {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().children(self.ids.iter().map(|id| {
            div().id(("record", *id)).child(Row { id: *id, states: self.states.clone() })
        }))
    }
}

let mut app = TestApp::new();
let states = States::default();
let mut window = app.open_window(|_, _| Records {
    ids: vec![10, 20], states: states.clone(),
});
window.draw();
let first = states.borrow()[&10].clone();
let second = states.borrow()[&20].clone();
assert_ne!(first.entity_id(), second.entity_id());
assert_eq!(app.read_entity(&first, |value, _| *value), 10);
assert_eq!(app.read_entity(&second, |value, _| *value), 20);

app.update_entity(&first, |value, cx| { *value = 99; cx.notify(); });
window.update(|records, _, cx| { records.ids.reverse(); cx.notify(); });
window.draw();
assert_eq!(states.borrow()[&10].entity_id(), first.entity_id());
assert_eq!(states.borrow()[&20].entity_id(), second.entity_id());
assert_eq!(app.read_entity(&first, |value, _| *value), 99);
assert_eq!(app.read_entity(&second, |value, _| *value), 20);
```

Removing the parent's ID makes the first identity assertion fail. Keying by
position instead makes the state move to the other record after reversal.
Putting an ID on the div returned by `Row::render` is too late to scope its
earlier state hook. For state that must survive removing a row, keep it on a
longer-lived entity; this fixture tests continuity while both rows remain
mounted. See [element identity](https://gpui-ce.github.io/book/ownership.html#give-retained-element-state-an-identity).

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

### Check focus against the rendered tree

Selecting a handle changes `is_focused` immediately. Ancestry queries have a
different boundary: they use the last rendered dispatch tree. This matters
when a panel moves a control elsewhere while keeping its focus identity.

Here the field starts inside a panel, then moves beside it. The field keeps
focus, but the panel stops containing focus only after the next draw:

```rust
use gpui::{Context, FocusHandle, Render, TestApp, Window, div, prelude::*};

struct Workspace {
    panel: FocusHandle,
    field: FocusHandle,
    field_inside_panel: bool,
}

impl Render for Workspace {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        let field = div().track_focus(&self.field);
        let panel = div().track_focus(&self.panel);
        if self.field_inside_panel {
            panel.child(field)
        } else {
            div().child(panel).child(field)
        }
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|window, cx| {
    let panel = cx.focus_handle();
    let field = cx.focus_handle();
    window.focus(&field, cx);
    assert!(field.is_focused(window));
    assert!(!panel.contains_focused(window, cx)); // No rendered ancestry yet.
    Workspace { panel, field, field_inside_panel: true }
});

window.update(|view, window, cx| {
    assert!(view.panel.contains_focused(window, cx));
    assert!(!view.panel.within_focused(window, cx));

    window.focus(&view.panel, cx);
    assert!(view.field.within_focused(window, cx));
    assert!(!view.field.contains_focused(window, cx));

    window.focus(&view.field, cx);
    view.field_inside_panel = false;
    cx.notify();
    assert!(view.panel.contains_focused(window, cx)); // Still the previous frame.
});
window.draw();
window.update(|view, window, cx| {
    assert!(view.field.is_focused(window));
    assert!(!view.panel.contains_focused(window, cx));
});
```

The panel and field need separate handles even though they belong to one
view. Reusing a handle would give them the same identity; querying that
identity cannot distinguish the two nodes. Opening the window performs its
initial draw after the setup closure returns. The later `draw` publishes the
changed ancestry. Native window activation is a
third question, checked separately with
[`Window::is_window_active`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.is_window_active). See
[keyboard focus](https://gpui-ce.github.io/book/input.html#keyboard-focus) for the ownership
and tab-order rules behind these assertions.

### Check accessible activation against the reported node

A pointer test can pass while the accessibility node has the wrong name or
advertises no action. Force tree construction, inspect the node the app
reported, and activate that node through GPUI's accessibility action routing:

```rust
use gpui::{AccessibleAction, AppContext, Context, Render, Role, TestApp, Text, Window,
           div, prelude::*, px};

struct SaveButton { saves: usize }
impl Render for SaveButton {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div().id("save").role(Role::Button).aria_label("Save draft")
            .w(px(120.)).h(px(32.))
            .on_click(cx.listener(|this, _, _, cx| {
                this.saves += 1;
                cx.notify();
            }))
            .child(Text::new_inaccessible("Save draft".into()))
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, _| SaveButton { saves: 0 });
window.update(|_, window, _| window.set_a11y_forced(true));
window.draw();
let button = window.update(|_, window, _| {
    let tree = window.a11y_tree().expect("a forced draw builds the tree");
    let (id, node) = tree.nodes.iter()
        .find(|(_, node)| node.role() == Role::Button && node.label() == Some("Save draft"))
        .expect("the named button must be exposed");
    assert!(node.supports_action(AccessibleAction::Click));
    *id
});
let handle = window.handle();
app.update(|cx| {
    cx.update_window(handle.into(), |_, window, cx| {
        window.perform_a11y_action(button, AccessibleAction::Click, None, cx);
    }).unwrap();
});
assert_eq!(window.read(|view, _| view.saves), 1);
window.draw();
window.update(|_, window, _| {
    assert!(window.a11y_tree().unwrap().nodes.iter()
        .any(|(id, node)| *id == button && node.label() == Some("Save draft")));
});
```

Dispatch through `AppContext::update_window` so the callback can update the
root view. `TestAppWindow::update` already borrows that view; activating its
listener there would attempt a second mutable borrow and panic. The final
draw checks that the same control keeps its node ID after an update.
Use IDs from [`Window::a11y_tree`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.a11y_tree), rather than the
temporary letter keys in the JSON dump. This fixture checks the reported
capability and GPUI's action routing. It does not check a screen reader's
announcement or a native adapter's connection to that screen reader; verify
those in the application on its target platform. The
[accessibility chapter](https://gpui-ce.github.io/book/accessibility.html) explains node identity,
properties, and custom children.

### Check the key binding as well as its action

A key context decides whether a binding matches. It does not remove the
action listener. This test keeps one listener installed in both modes, then
checks that Ctrl-S reaches it only in edit mode:

```rust
use gpui::{Context, FocusHandle, KeyBinding, Render, TestApp, Window, actions, div, prelude::*};

actions!(documentation_key_matching, [SaveDraft]);

struct Document {
    editing: bool,
    saves: usize,
    focus: FocusHandle,
}

impl Render for Document {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("document")
            .track_focus(&self.focus)
            .key_context(if self.editing { "Document mode=edit" } else { "Document mode=review" })
            .on_action(cx.listener(|this, _: &SaveDraft, _, cx| {
                this.saves += 1;
                cx.notify();
            }))
            .child(if self.editing { "Edit mode" } else { "Review mode" })
    }
}

let mut app = TestApp::new();
app.update(|cx| cx.bind_keys([
    KeyBinding::new("ctrl-s", SaveDraft, Some("Document && mode == edit")),
]));
let mut window = app.open_window(|window, cx| {
    let focus = cx.focus_handle();
    window.focus(&focus, cx);
    Document { editing: false, saves: 0, focus }
});
window.draw();
window.simulate_keystroke("ctrl-s");
assert_eq!(window.read(|document, _| document.saves), 0);

window.update(|document, _, cx| {
    document.editing = true;
    cx.notify();
});
window.draw();
window.simulate_keystroke("ctrl-s");
assert_eq!(window.read(|document, _| document.saves), 1);
```

Dispatching `SaveDraft` directly would bypass the binding and reach the
listener in either mode. Drawing after the mode change matters too: matching
uses the context in the rendered dispatch tree. See
[key matching and dispatch](https://gpui-ce.github.io/book/input.html#actions-and-key-bindings)
for the connection between bindings, contexts, and listeners.

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
repairs its selection and abandons stale composition.

In this checkout, `crates/gpui/examples/view_example/example_tests.rs` runs
these sequences against the composed-input editor. Run it from the workspace
root:

```sh
cargo test --locked -p gpui-ce --example view_example --features test-support
```

Read the test and editor from the same checkout. Older versions of this
example tested typing and cursor movement but did not implement the composition
protocol above.

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

```rust
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

Keep the failing checkout and `Cargo.lock` with the seed. A seed reproduces a
sequence of scheduler choices, not an execution across arbitrary code or
dependency versions. Changing the runnable work or the random-number generator
can change that sequence. See the Rand book's
[reproducibility discussion](https://rust-random.github.io/book/crate-reprod.html)
for the distinction between a seeded run and a stable generator contract.

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

### Check clipping and input together

A clipped control should reject input outside its visible region. Test the
paint mask and the input path separately: a quad's full bounds can extend
beyond its mask, and a pointer listener does not filter itself by that mask.

This canvas draws a 100-pixel square through a 40-pixel mask. Prepaint applies
the mask when inserting the hitbox; paint applies it again when recording the
quad. The listener checks that hitbox before counting a press:

```rust
use gpui::{Bounds, ContentMask, Context, HitboxBehavior, IntoElement, MouseButton,
           MouseDownEvent, Render, TestApp, Window, canvas, fill, point,
           prelude::*, px, rgb, size};
use std::{cell::Cell, rc::Rc};

struct ClippedControl { presses: Rc<Cell<usize>> }
impl Render for ClippedControl {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        let presses = self.presses.clone();
        canvas(
            |bounds, window, _| {
                let mask = ContentMask {
                    bounds: Bounds::new(bounds.origin, size(px(40.), px(40.))),
                    ..Default::default()
                };
                let hitbox = window.with_content_mask(Some(mask.clone()), |window| {
                    window.insert_hitbox(bounds, HitboxBehavior::Normal)
                });
                (mask, hitbox)
            },
            move |bounds, (mask, hitbox), window, _| {
                window.with_content_mask(Some(mask), |window| {
                    window.paint_quad(fill(bounds, rgb(0x155b50)));
                });
                window.on_mouse_event(move |event: &MouseDownEvent, phase, window, _| {
                    if phase.bubble() && event.button == MouseButton::Left
                        && hitbox.is_hovered(window)
                    {
                        presses.set(presses.get() + 1);
                    }
                });
            },
        ).size(px(100.))
    }
}

let presses = Rc::new(Cell::new(0));
let mut app = TestApp::new();
let mut window = app.open_window(|_, _| ClippedControl { presses: presses.clone() });
window.draw();
window.update(|_, window, _| {
    let quad = window.painted_quads().into_iter()
        .find(|quad| quad.background == rgb(0x155b50).into())
        .expect("the control should have been painted");
    assert_eq!(quad.bounds.size, size(px(100.), px(100.)).scale(window.scale_factor()));
    assert_eq!(quad.content_mask.bounds.size, size(px(40.), px(40.)).scale(window.scale_factor()));
});

window.simulate_mouse_down(point(px(60.), px(20.)), MouseButton::Left);
assert_eq!(presses.get(), 0, "the clipped part must not accept a press");
window.simulate_mouse_up(point(px(60.), px(20.)), MouseButton::Left);
window.simulate_mouse_down(point(px(20.), px(20.)), MouseButton::Left);
assert_eq!(presses.get(), 1);
```

Removing the prepaint mask makes the first press count. Removing the paint
mask makes the recorded-mask assertion fail. This checks GPUI's clipping and
input records without depending on a GPU's rasterization. See
[coordinate spaces](https://gpui-ce.github.io/book/layout.html#keep-geometry-in-one-coordinate-space)
for the corresponding layout and offset rules.

### Check that a shared model invalidates a cached view

A cache test first draws the view, draws again to check reuse, then changes an
input and draws to check invalidation. Reading a model during rendering
registers a window redraw dependency. It does not give that model the reading
view's identity. Retain an observation that notifies the view when the model
changes; otherwise a
window redraw can reuse the view's old cached content.

Here the child reads a shared color. Its observation forwards notification
without copying the color into a second field:

```rust
use gpui::{AppContext as _, Context, Entity, IntoElement, Render, StyleRefinement,
           Subscription, TestApp, Window, div, prelude::*, rgb};
use std::{cell::Cell, rc::Rc};

struct Swatch {
    color: Entity<u32>,
    renders: Rc<Cell<usize>>,
    _observation: Subscription,
}
impl Render for Swatch {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        self.renders.set(self.renders.get() + 1);
        div().size_full().bg(rgb(*self.color.read(cx)))
    }
}

struct Panel { swatch: Entity<Swatch> }
impl Render for Panel {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        self.swatch.clone().cached(StyleRefinement::default().size_full())
    }
}

let mut app = TestApp::new();
let color = app.new_entity(|_| 0x155b50_u32);
let renders = Rc::new(Cell::new(0));
let mut window = app.open_window(|_, cx| Panel {
    swatch: cx.new(|cx| Swatch {
        color: color.clone(),
        renders: renders.clone(),
        _observation: cx.observe(&color, |_, _, cx| cx.notify()),
    }),
});

window.draw();
let first_draws = renders.get();
assert!(first_draws > 0);
window.draw();
assert_eq!(renders.get(), first_draws, "unchanged content should be reused");

app.update_entity(&color, |color, cx| {
    *color = 0x315ac6;
    cx.notify();
});
window.draw();
assert!(renders.get() > first_draws);
window.update(|_, window, _| {
    let quads = window.painted_quads();
    assert!(quads.iter().any(|quad| quad.background == rgb(0x315ac6).into()));
    assert!(!quads.iter().any(|quad| quad.background == rgb(0x155b50).into()));
});
```

The render count checks reuse, not a general promise about how often `render`
runs. The painted-color assertions establish the visible result. Removing
the observation leaves the old color cached even though the model notifies.
The same ownership rule applies to a view that reads a global: retain an
[`observe_global`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Context.html#method.observe_global) subscription and notify the
view. See [cached views](https://gpui-ce.github.io/book/rendering.html#cache-a-view-with-known-dimensions).

### Check the row after a scroll request

A queued scroll is not yet a visible row. For a uniform list, draw after the
request and assert the target's painted position. This example gives row
5,000 a distinct fill, scrolls it to the top, and resizes the same window.
The second assertion catches a lost handle or element identity during resize.

```rust
use gpui::{Context, IntoElement, Render, ScrollStrategy, TestApp,
           UniformListScrollHandle, Window, div, prelude::*, px, rgb, size, uniform_list};

struct Rows {
    scroll: UniformListScrollHandle,
}
impl Render for Rows {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        uniform_list("rows", 10_000, |range, _, _| {
            range.map(|index| {
                div().w_full().h(px(20.)).bg(if index == 5_000 {
                    rgb(0x155b50)
                } else {
                    rgb(0xffffff)
                })
            }).collect::<Vec<_>>()
        }).size_full().track_scroll(&self.scroll)
    }
}

let mut app = TestApp::new();
let mut window = app.open_window(|_, _| Rows {
    scroll: UniformListScrollHandle::new(),
});
window.simulate_resize(size(px(300.), px(200.)));
window.draw();
window.update(|_, window, _| {
    assert!(!window.painted_quads().iter()
        .any(|quad| quad.background == rgb(0x155b50).into()));
});
window.update(|view, _, cx| {
    view.scroll.scroll_to_item_strict(5_000, ScrollStrategy::Top);
    cx.notify();
});

for viewport in [size(px(300.), px(200.)), size(px(150.), px(120.))] {
    window.simulate_resize(viewport);
    window.draw();
    window.update(|_, window, _| {
        let row = window.painted_quads().into_iter()
            .find(|quad| quad.background == rgb(0x155b50).into())
            .expect("row 5,000 must be in the painted viewport");
        assert_eq!(row.bounds.top(), px(0.).scale(window.scale_factor()));
        assert_eq!(row.bounds.size,
            size(viewport.width, px(20.)).scale(window.scale_factor()));
    });
}
```

This checks layout and recorded drawing, not wheel-event routing. To cover the
latter, draw first to install the hitbox, send
[`simulate_scroll`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.TestAppWindow.html#method.simulate_scroll) inside the list,
and draw again. The [lists chapter](https://gpui-ce.github.io/book/lists.html) explains
which changes require a splice, a measurement reset, or only a redraw.

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

### Check a failed load and an explicit retry

A failure is a completed cache result. The default fake HTTP client makes
that behavior testable without a server:

```rust
use futures::FutureExt as _;
use gpui::{ImageAssetLoader, ImageCacheError, Resource, TestApp};

let mut app = TestApp::new();
let source = Resource::Uri("https://example.invalid/cover.png".into());
let (request, started) = app.update(|cx| cx.fetch_asset::<ImageAssetLoader>(&source));
assert!(started);

// update drained ready work; the fake client has already returned its 404.
let error = request.now_or_never()
    .expect("the fake response should be ready")
    .expect_err("the default client returns 404");
assert!(matches!(error, ImageCacheError::BadStatus { status, .. }
    if status.as_u16() == 404));

let (_, started) = app.update(|cx| cx.fetch_asset::<ImageAssetLoader>(&source));
assert!(!started, "a cached failure must not start another request");

app.update(|cx| cx.remove_asset::<ImageAssetLoader>(&source));
let (_, started) = app.update(|cx| cx.fetch_asset::<ImageAssetLoader>(&source));
assert!(started, "eviction must allow a new request");
```

This checks loading and cache reuse. To check the failure UI, draw a view with
[`Img::with_fallback`](https://docs.rs/gpui-ce/0.2.2/gpui/trait.StyledImage.html#method.with_fallback) and assert its
replacement. `Img` uses a logging wrapper with a separate typed cache key;
evict that request with [`ImageSource::remove_asset`](https://docs.rs/gpui-ce/0.2.2/gpui/enum.ImageSource.html#method.remove_asset).
When a view uses an image-cache provider, remove the provider's entry instead.
The [assets chapter](https://gpui-ce.github.io/book/assets.html#give-the-cache-an-owner)
explains those lifetimes and the notification needed to render a retry.

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
