# Schedule work around the UI thread

GPUI has two executor handles because UI state and independent work have
different thread-safety requirements. Choose by the work each future performs,
then keep or detach its [`Task`](crate::Task) according to who owns its
lifetime.

| API | Where each poll runs | Use it for |
| --- | --- | --- |
| [`Context::spawn`](crate::Context::spawn) or [`App::spawn`](crate::App::spawn) | GPUI foreground thread | A view or app task that awaits work, then updates entities or windows |
| [`ForegroundExecutor::spawn`](crate::ForegroundExecutor::spawn) | GPUI foreground thread | A local `!Send` future when no entity context is needed |
| [`BackgroundExecutor::spawn`](crate::BackgroundExecutor::spawn) | Platform background workers in production; controlled scheduler in tests | Owned, `Send` work such as parsing, file access, or computation |
| [`ForegroundExecutor::spawn_when_idle`](crate::ForegroundExecutor::spawn_when_idle) | Foreground thread during idle time when supported | Incremental work that can pause between bounded slices |
| [`BackgroundExecutor::scoped`](crate::BackgroundExecutor::scoped) | Background workers in production; controlled scheduler in tests; native targets only | A group of `Send` jobs that borrow data owned by the caller |
| [`Tokio::spawn`](https://docs.rs/gpui_tokio/latest/gpui_tokio/struct.Tokio.html#method.spawn) | The configured Tokio runtime | Libraries already built around Tokio |

In the browser, background dispatch uses workers only when the build and
browser support them and the application enables them. Otherwise it schedules
ordinary work on the browser thread. Keep polls short there: `Send` makes a
future transferable, but does not establish that another thread will run it.
See the [platform chapter](crate::_documentation::platforms) for browser
capabilities.

Use [`BackgroundExecutor::spawn_with_priority`](crate::BackgroundExecutor::spawn_with_priority)
when ordinary background work needs a priority. `Priority::RealtimeAudio` is a
special dedicated-thread path for native audio processing, not a general way
to get more CPU time. The browser dispatcher has no realtime thread, and its
fallback cannot safely run that blocking audio loop. The Tokio adapter's
`spawn` returns `Task<Result<T, JoinError>>`;
`spawn_result` also flattens the future's `anyhow::Result`. Initialize it with
[`gpui_tokio::init`](https://docs.rs/gpui_tokio/latest/gpui_tokio/fn.init.html)
or pass an externally owned runtime to
[`gpui_tokio::init_from_handle`](https://docs.rs/gpui_tokio/latest/gpui_tokio/fn.init_from_handle.html).

Foreground `spawn_with_priority` methods currently ignore their priority
argument. They neither reorder foreground tasks nor give a poll more time.
Use `spawn_when_idle` when work should wait for an idle slice, and keep every
foreground poll short regardless of how it was scheduled.

On native targets, [`ForegroundExecutor::block_on`](crate::ForegroundExecutor::block_on)
and [`ForegroundExecutor::block_with_timeout`](crate::ForegroundExecutor::block_with_timeout)
are synchronous escape hatches. Calling one from a
foreground callback can block the work needed to complete its future; use
`spawn` in application code. These blocking methods are not available on
`wasm`.

`spawn_when_idle` is still foreground work: its future may hold local UI-side
data, and every poll runs on the foreground thread. On platforms with measured
idle slices, a timeout can promote work that has waited too long to ordinary
foreground scheduling; it does not move that work to a worker thread. Check
[`ForegroundExecutor::idle_time_remaining`](crate::ForegroundExecutor::idle_time_remaining)
inside an idle poll and yield before the slice expires. On platforms without
idle-slice scheduling, this API falls back to low-priority foreground work.

## Keep input and drawing responsive

An `async` function still runs synchronously until it reaches an await that
returns `Pending`. A large parse or tight loop inside a foreground task blocks
input and drawing just like the same work inside a click handler. Move owned
inputs to the background executor, await its task from a foreground task, and
apply the result in a short entity update:

```rust
use gpui::{Context, Task};

struct SearchResults {
    query: String,
    matches: Vec<String>,
}

impl SearchResults {
    fn refresh(&mut self, cx: &mut Context<Self>, source: Vec<String>) -> Task<()> {
        let query = self.query.clone();
        cx.spawn(async move |this, cx| {
            let matches = cx.background_executor().spawn(async move {
                source
                    .into_iter()
                    .filter(|item| item.contains(query.as_str()))
                    .collect::<Vec<_>>()
            }).await;

            let _ = this.update(cx, |this, cx| {
                this.matches = matches;
                cx.notify();
            }); // A released view no longer needs the result.
        })
    }
}
```

Return or retain the task so its caller controls the search's lifetime. If a
new query can start before the previous search finishes, also decide which
result is allowed to win. Replacing the retained task cancels the old future;
a generation check rejects an old result even when the underlying operation
cannot be canceled. The [testing chapter](https://gpui-ce.github.io/book/testing.html#reject-a-result-from-a-replaced-request)
shows that race with controlled completion order.

The entity update closure is synchronous. Never keep `&mut App`, `&mut Window`,
or an entity borrow across an await. `AsyncApp` and `AsyncWindowContext` provide
short update/read closures for work after an await; their app handle is weak, so
an operation that requires a released app can fail or panic according to that
method's contract. [`AsyncApp::update`](crate::AsyncApp::update) gives exclusive
app access only for its synchronous closure; do not await inside it. For
optional global state, use
[`AsyncApp::try_read_global`](crate::AsyncApp::try_read_global). For window
updates, use the `Result` from [`AppContext::update_window`](crate::AppContext::update_window)
or [`AsyncWindowContext::update`](crate::AsyncWindowContext::update) to handle
window teardown.

The [async task walkthrough](https://gpui-ce.github.io/examples/async-task/#completion)
shows this lifecycle in a running view. Zed uses the same weak-entity return
path in its streaming text update loop ([`acp_thread.rs`](https://github.com/zed-industries/zed/blob/da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f/crates/acp_thread/src/acp_thread.rs#L4978-L5005)).

## Await, retain, or detach

[`Task<T>`](crate::Task) is a future and a cancellation handle. Await it when
the caller needs its output or needs to sequence later work. [`Task::is_ready`](crate::Task::is_ready)
reports whether the task has finished or been cancelled; it does not prove
that an output exists, retrieve that output, or poll the future. Dropping a
task requests cancellation after its current poll returns, without waiting
for cleanup. Keep
the handle in a field if the view owns the work's lifetime. Calling
[`Task::detach`](crate::Task::detach) lets the work continue without a handle
that can cancel it or retrieve its output.

Entity and task ownership are separate. The weak handle supplied by
[`Context::spawn`](crate::Context::spawn) stops retaining the entity; it does
not stop the future. A task retained elsewhere or detached can continue after
that entity is released. Likewise, an [`AsyncWindowContext`](crate::AsyncWindowContext)
does not cancel its future when the window closes. Handle failed access after
waiting, or put the task on an owner whose destruction should cancel it. The
[task ownership test](https://gpui-ce.github.io/book/testing.html#separate-task-ownership-from-entity-ownership)
releases an entity while its externally owned task waits, then completes the
task and checks its failed update.

Dropping or detaching controls GPUI's future, not side effects it already
performed. A network request or write needs its own cancellation and
transaction contract. To report `Result` failures from intentionally detached
work, use [`TaskExt::detach_and_log_err`](crate::TaskExt::detach_and_log_err)
or [`TaskExt::detach_and_log_err_with_backtrace`](crate::TaskExt::detach_and_log_err_with_backtrace).
The supplied task keeps running on its original executor; a foreground task
waits for and logs the error.

An executor can also cancel work by discarding its runnable. Awaiting an
ordinary `Task` then panics. [`Task::fallible`](crate::Task::fallible) yields
`None` for that case and `Some(output)` for a completed operation. For a task
returning `Result`, the two failure cases remain distinct:

```rust
use gpui::Task;

# futures::executor::block_on(async {
let task = Task::ready(Err::<(), _>("request rejected"));
assert_eq!(task.fallible().await, Some(Err("request rejected")));
# });
```

`fallible` does not catch panics inside the operation. Detaching also cannot
keep an executor or dedicated session alive during shutdown.

## Capture shutdown work before windows close

[`App::on_app_quit`](crate::App::on_app_quit) has two stages. Its callback
runs with synchronous app access; the owned future it returns runs after
shutdown has removed the windows. Read the data to save in that first stage.
Trying to recover it later through an async window handle is too late.

For example, a native application can take a final snapshot of a notes entity
and write it in the background:

```no_run
use gpui::{App, Entity, Subscription};
use std::path::PathBuf;

fn save_on_shutdown(notes: Entity<String>, path: PathBuf, cx: &App) -> Subscription {
    cx.on_app_quit(move |cx| {
        let snapshot = notes.read(cx).clone();
        let path = path.clone();
        let background = cx.background_executor().clone();
        async move {
            let result = background.spawn(async move {
                std::fs::write(path, snapshot)
            }).await;
            if let Err(error) = result {
                eprintln!("could not save notes: {error}");
            }
        }
    })
}
```

Retain the returned subscription on an application owner. This callback
captures `notes` strongly, so the entity remains available for the snapshot.
[`Context::on_app_quit`](crate::Context::on_app_quit) instead holds its entity
weakly and skips the callback if that entity has already been released.

Native shutdown waits at most [`SHUTDOWN_TIMEOUT`](crate::SHUTDOWN_TIMEOUT)
for all cleanup futures together. Browser shutdown schedules them without
blocking, and page teardown can interrupt them. Use this hook for a final
attempt; also save valuable edits during normal operation. Dropping an
unrelated task or detaching it does not enroll it in shutdown's wait.

## Borrow data for a group of background jobs

On native targets, [`BackgroundExecutor::scoped`](crate::BackgroundExecutor::scoped)
and [`BackgroundExecutor::scoped_priority`](crate::BackgroundExecutor::scoped_priority)
accept `Send` futures that borrow from the surrounding stack. The scope waits
for all jobs before it returns. If the scoped future is dropped, it cancels
those jobs and waits for their futures to be destroyed before returning. These
methods are unavailable on `wasm` targets; use owned `'static` inputs with
`spawn` there.

The closure registers jobs synchronously; they are submitted after it returns.
If registration panics, the unstarted futures are destroyed before the panic
propagates. Once jobs are running, cancellation still has to wait for their
current polls to return. A blocking job can therefore delay scope cleanup.

```rust
use gpui::BackgroundExecutor;

async fn word_counts(executor: &BackgroundExecutor, documents: &[String]) -> Vec<usize> {
    let mut counts = vec![0; documents.len()];
    executor.scoped(|scope| {
        for (document, count) in documents.iter().zip(&mut counts) {
            scope.spawn(async move {
                *count = document.split_whitespace().count();
            });
        }
    }).await;
    counts
}
```

Each job borrows one document and a different output slot. The scope finishes
before `counts` is returned, so no job can retain a reference into the returned
vector. Batch small inputs in real workloads: scheduling a job has a cost.
Each scoped future must be `Send`, and the scope's completion is part of the
caller task's lifetime.

For a long-lived future that needs its own execution thread, consider
[`BackgroundExecutor::spawn_dedicated`](crate::BackgroundExecutor::spawn_dedicated).
Its closure creates the future on that thread, so the future itself may hold
`!Send` values. The test scheduler runs it in the test loop instead. Dedicated
web workers require the `wasm-threads` feature and shared memory, and should be
long-lived because creating one is expensive.

[`DedicatedExecutor`](crate::DedicatedExecutor) reuses one dedicated session
for several `Send` futures. Its constructor takes the scheduler-level handle
from [`BackgroundExecutor::scheduler_executor`](crate::BackgroundExecutor::scheduler_executor).
Retain the dedicated executor as well as any job handles: detaching a job
does not preserve the session after the executor is dropped.

## Test scheduling is not production timing

Enable `test-support` for GPUI's test harnesses. The test scheduler randomizes
runnable ordering from a seed and exposes a controllable clock. `TestApp::run_until_parked`
drains work that can run now; it does not advance future timers. Advancing the
clock with `advance_clock` runs work as it becomes due and ends at the requested
time. `run_with_clock_advancement` instead advances through timers until the
scheduler reaches quiescence. `TestAppContext` uses the same test
dispatcher through its `run_until_parked` and `executor` methods. The
[testing chapter](https://gpui-ce.github.io/book/testing.html) shows complete
fixtures for notification, timer, cancellation, and input behavior.

This proves behavior under the chosen task interleavings and simulated time. It
does not measure production latency, guarantee a particular OS-thread order, or
prove cancellation of external I/O. Use a benchmark or platform capture for
performance and the service's own tests for external cancellation behavior.
