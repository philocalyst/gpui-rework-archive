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

Use [`BackgroundExecutor::spawn_with_priority`](crate::BackgroundExecutor::spawn_with_priority)
when ordinary background work needs a priority. `Priority::RealtimeAudio` is a
special dedicated-thread path for audio processing, not a general way to get
more CPU time. The Tokio adapter's `spawn` returns `Task<Result<T, JoinError>>`;
`spawn_result` also flattens the future's `anyhow::Result`. Initialize it with
[`gpui_tokio::init`](https://docs.rs/gpui_tokio/latest/gpui_tokio/fn.init.html)
or pass an externally owned runtime to
[`gpui_tokio::init_from_handle`](https://docs.rs/gpui_tokio/latest/gpui_tokio/fn.init_from_handle.html).

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

            if this.update(cx, |this, cx| {
                this.matches = matches;
                cx.notify();
            }).is_err() {
                // The view was released while the search was running.
            }
        })
    }
}
```

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
only checks completion; it does not return the output or drive a task by itself.
Dropping a task cancels unfinished work after its current poll returns.
Detaching transfers the work to the executor and gives up the output handle:

Keep the returned handle in a field if the view owns the work's lifetime.
Calling `detach` lets it continue without a handle that can cancel or await it.

Dropping or detaching controls GPUI's future, not side effects it already
performed. A network request or write needs its own cancellation and
transaction contract. To report `Result` failures from intentionally detached
work, use [`TaskExt::detach_and_log_err`](crate::TaskExt::detach_and_log_err)
or [`TaskExt::detach_and_log_err_with_backtrace`](crate::TaskExt::detach_and_log_err_with_backtrace).
[`Task::fallible`](crate::Task::fallible) makes cancellation observable as
`None`; it does not convert an operation's own error into an `Option`.

## Borrow data for a group of background jobs

On native targets, [`BackgroundExecutor::scoped`](crate::BackgroundExecutor::scoped)
and [`BackgroundExecutor::scoped_priority`](crate::BackgroundExecutor::scoped_priority)
accept `Send` futures that borrow from the surrounding stack. The scope waits
for all jobs before it returns. If the scoped future is dropped, it cancels
those jobs and waits for their futures to be destroyed before returning. These
methods are unavailable on `wasm` targets; use owned `'static` inputs with
`spawn` there.

```rust,ignore
let records = load_records();
executor.scoped(|scope| {
    for chunk in records.chunks(128) {
        scope.spawn(async move {
            index_chunk(chunk).await;
        });
    }
}).await;
```

Each scoped future must be `Send`, and the scope's completion is part of the
caller task's lifetime. For a large synchronous operation that needs a larger
stack, consider [`BackgroundExecutor::spawn_dedicated`](crate::BackgroundExecutor::spawn_dedicated);
it uses a fresh session rather than the shared background workers. Its test
scheduler runs that session in the test loop, while production uses a dedicated
thread. Dedicated web workers require the `wasm-threads` feature and shared
memory, and should be long-lived because creating one is expensive.

## Test scheduling is not production timing

The test scheduler randomizes runnable ordering from a seed and exposes a
controllable clock. [`TestApp::run_until_parked`](crate::TestApp::run_until_parked)
drains work that can run now; it does not advance future timers. Advancing the
clock with `advance_clock` runs work as it becomes due and ends at the requested
time. `run_with_clock_advancement` instead advances through timers until the
scheduler reaches quiescence. `TestAppContext` uses the same test
dispatcher through its [`run_until_parked`](crate::TestAppContext::run_until_parked)
and [`executor`](crate::TestAppContext::executor) methods.

This proves behavior under the chosen task interleavings and simulated time. It
does not measure production latency, guarantee a particular OS-thread order, or
prove cancellation of external I/O. Use a benchmark or platform capture for
performance and the service's own tests for external cancellation behavior.
