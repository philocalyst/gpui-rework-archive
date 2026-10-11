# Executors and tasks

GPUI runs your code on one thread: the main thread, where the event loop, your
views and all entity state live. That keeps state simple, because nothing else
can touch an entity while you're updating it. It also means that anything slow
on that thread freezes the window. GPUI's async support exists to get slow work
off the main thread and to wait for things without blocking it.

## Two executors

GPUI has two executors, and every async API uses one or the other.

| | Foreground executor | Background executor |
| --- | --- | --- |
| Runs futures on | The main thread | A pool of worker threads |
| Futures must be | `'static` | `Send + 'static` |
| Can reach entities and windows | Yes, through an async context | No |
| Start one with | [`App::spawn`], [`Context::spawn`], [`Context::spawn_in`] | [`background_spawn`](AppContext::background_spawn) |

The foreground executor interleaves your futures with input handling and
drawing. A foreground future runs until it awaits, then yields so the window
stays responsive. It must not do long computations between awaits.

The background executor runs futures on other threads, in parallel with the UI.
Its futures can't hold contexts or entity handles, which aren't `Send`: they
take plain data in and return plain data out.

The usual pattern combines them. A foreground task starts the background work,
awaits its result, and then updates an entity:

```
# use gpui::{AppContext, Context, Task};
# fn parse(text: &str) -> usize { text.lines().count() }
struct Document {
    text: String,
    line_count: Option<usize>,
    _count_lines: Task<()>,
}

impl Document {
    fn count_lines(&mut self, cx: &mut Context<Self>) {
        let text = self.text.clone();
        self._count_lines = cx.spawn(async move |document, cx| {
            // On a worker thread: no entities, just data.
            let count = cx.background_spawn(async move { parse(&text) }).await;
            // Back on the main thread, with access to the entity.
            document
                .update(cx, |document, cx| {
                    document.line_count = Some(count);
                    cx.notify();
                })
                .ok();
        });
    }
}
```

## Tasks

Every spawn returns a [`Task<T>`](Task). A task is a future for the result of
the work, and it owns the work: **dropping a task cancels it**. Cancellation
happens at the next await point, and the future is dropped without running
further.

This makes ownership of async work explicit. Decide who should own each task:

* **Store it in a field** when the work belongs to an entity. When the entity is
  released, its tasks are dropped and the work stops. Replacing the field
  cancels the previous task, which is exactly what you want for a search that
  should restart on every keystroke.
* **Await it** when you need its result in another async block.
* **[`detach`](Task::detach) it** when the work should run to completion no
  matter what, such as writing a file the user asked to save. For a task that
  returns a `Result`, [`detach_and_log_err`](TaskExt::detach_and_log_err) also
  logs a failure.

A task that you neither store, await nor detach is dropped at the end of the
statement, and its work never happens. That's the most common async mistake in
GPUI.

## Waiting for time

[`BackgroundExecutor::timer`] returns a task that completes after a duration.
Await it in a foreground task to delay or repeat work:

```
use std::time::Duration;
use gpui::{AppContext, TestApp};

let mut app = TestApp::new();
let ticks = app.update(|cx| cx.new(|_| 0));

let _clock = app.update(|cx| {
    // A weak handle, so the loop doesn't keep the entity alive. Updating it
    // fails once the entity is dropped, which ends the loop.
    let ticks = ticks.downgrade();
    cx.spawn(async move |cx| {
        loop {
            cx.background_executor().timer(Duration::from_secs(1)).await;
            let updated = ticks.update(cx, |ticks, cx| {
                *ticks += 1;
                cx.notify();
            });
            if updated.is_err() {
                break;
            }
        }
    })
});

app.advance_clock(Duration::from_secs(3));
assert_eq!(app.read(|cx| *ticks.read(cx)), 3);
```

## Async contexts

A foreground future receives an [`AsyncApp`] (or an [`AsyncWindowContext`] from
`spawn_in`) instead of `&mut App`. It can't borrow the app across an await,
because other code must be able to use it in the meantime. Instead, each call
through it borrows the app briefly and runs a complete update. See
[contexts](crate::_documentation::concepts::contexts#async-contexts) for how
they work.

[`Context::spawn`] also gives your future a [`WeakEntity`] for the entity that
spawned it, rather than a strong handle. A task stored in an entity's field
therefore doesn't keep that entity alive, and updates through the weak handle
fail cleanly once the entity is gone.

## Tests are deterministic

In tests, both executors run on a simulated, single-threaded scheduler. Time
doesn't pass unless the test advances it, and work only runs when the test lets
it. [`TestApp::run_until_parked`] runs everything that's ready;
[`TestApp::advance_clock`] moves time forward and wakes timers, as in the
example above. Tests that involve async code are therefore fast and repeatable,
with no sleeps or retries.

The scheduler can also run tasks in a random order chosen by a seed, which
shakes out ordering bugs. `#[gpui::test(iterations = 100)]` runs a test with a
hundred different seeds; set `SEED` to reproduce a failure. The [testing
guide](crate::_documentation::guides::testing) covers both.

## On the web

A WebAssembly app gets one thread unless it is built with WebAssembly threads
and served from a cross-origin isolated page. `gpui_platform` builds GPUI for
the single-threaded case, so on the web the background executor runs its
futures on the main thread. Your code still works, but background work competes
with drawing, so break long computations into chunks that await between them.
The [web guide](crate::_documentation::guides::web) describes the multithreaded
setup.
