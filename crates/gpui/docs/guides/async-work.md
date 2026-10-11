# Run work in the background

Work that takes longer than a frame, such as parsing a large file, searching or waiting on
a network call, runs off the main thread. This guide shows how to start that work, get
its result back into an entity, control how long it lives, and wait with a timeout. The
two executors and how tasks work are in [executors](crate::_documentation::concepts::executors);
this page is about the patterns.

## Compute on a background thread and update the entity

Start the work with [`Context::spawn`]. Inside it, [`AppContext::background_spawn`] runs
the slow part on a worker thread. That part can't touch the entity, so pass it plain data
and return plain data. When it finishes, back on the main thread, update the entity
through the weak handle that `spawn` gives you.

```rust
use gpui::{AppContext, Context, Task, TestApp};

struct Document {
    text: String,
    word_count: Option<usize>,
    _count: Task<()>,
}

impl Document {
    fn count_words(&mut self, cx: &mut Context<Self>) {
        let text = self.text.clone();
        self._count = cx.spawn(async move |document, cx| {
            let count = cx
                .background_spawn(async move { text.split_whitespace().count() })
                .await;
            document
                .update(cx, |document, cx| {
                    document.word_count = Some(count);
                    cx.notify();
                })
                .ok();
        });
    }
}

let mut app = TestApp::new();
let document = app.update(|cx| {
    cx.new(|_| Document {
        text: "one two three".into(),
        word_count: None,
        _count: Task::ready(()),
    })
});

app.update(|cx| document.update(cx, |document, cx| document.count_words(cx)));
app.run_until_parked();

app.update(|cx| assert_eq!(document.read(cx).word_count, Some(3)));
```

The update through `document` returns a `Result`. It fails if the entity was released
while the work ran, which is why the example ignores the error with `.ok()`. The
[`WeakEntity`] handle is what makes this safe: the task never keeps the document alive.

## Store tasks to own and cancel work

Every spawn returns a [`Task`]. A task runs only while it exists, so decide who owns it:

* **Store it in a field** when the work belongs to the entity. Dropping the entity drops
  the task. Assigning a new task to the field drops the old one, which cancels it.
* **Detach it** with [`Task::detach`] when the work must finish even if nothing waits for
  it, such as saving a file. For a task that returns a `Result`, call
  [`TaskExt::detach_and_log_err`] instead. It logs the error if the work fails.

```rust
use gpui::{AppContext, Context, TaskExt};

struct Editor {
    text: String,
}

impl Editor {
    fn save(&mut self, cx: &mut Context<Self>) {
        let text = self.text.clone();
        cx.background_spawn(async move { write_draft(&text) })
            .detach_and_log_err(cx);
    }
}

// Stands in for a file write; a real app would return its I/O error.
fn write_draft(text: &str) -> Result<usize, String> {
    Ok(text.len())
}
```

Dropping a task cancels its future. The future stops at its current `.await` and is
never polled again. A task that is never awaited, stored or detached is dropped at the
end of its statement, so it is cancelled right away.

## Debounce by replacing a stored task

To wait until the user stops typing before searching, store the search task and start a
new one on every change. Each new assignment drops the previous task, so only the last
query runs its search. Await a [`BackgroundExecutor::timer`] first, and do the search
after the timer.

```rust
use std::time::Duration;

use gpui::{AppContext, Context, Task, TestApp};

const DEBOUNCE: Duration = Duration::from_millis(300);

struct Search {
    results: Vec<String>,
    _search: Task<()>,
}

impl Search {
    fn set_query(&mut self, query: String, cx: &mut Context<Self>) {
        self._search = cx.spawn(async move |search, cx| {
            cx.background_executor().timer(DEBOUNCE).await;
            let results = cx
                .background_spawn(async move { find(&query) })
                .await;
            search
                .update(cx, |search, cx| {
                    search.results = results;
                    cx.notify();
                })
                .ok();
        });
    }
}

fn find(query: &str) -> Vec<String> {
    ["apple", "banana", "cherry"]
        .into_iter()
        .filter(|fruit| fruit.contains(query))
        .map(String::from)
        .collect()
}

let mut app = TestApp::new();
let search = app.update(|cx| {
    cx.new(|_| Search {
        results: Vec::new(),
        _search: Task::ready(()),
    })
});

app.update(|cx| search.update(cx, |search, cx| search.set_query("app".into(), cx)));
app.run_until_parked();
app.advance_clock(Duration::from_millis(100));

// Replacing the task cancels the "app" search before its timer fires.
app.update(|cx| search.update(cx, |search, cx| search.set_query("ban".into(), cx)));
app.run_until_parked();
app.advance_clock(Duration::from_millis(400));
app.run_until_parked();

app.update(|cx| assert_eq!(search.read(cx).results, vec!["banana".to_string()]));
```

The timer starts when the task is first polled, which is why the example calls
`run_until_parked` after each change. In an app, the event loop does that for you.

## Set a timeout on a future

[`FutureExt::with_timeout`] wraps any future. It resolves to `Ok` with the future's output,
or to `Err(Timeout)` if the duration passes first. When the timeout wins, the wrapped
future is dropped, so its work stops. Pass the executor whose timers should count, which
you get from `cx.background_executor()`.

```rust
use std::time::Duration;

use gpui::{AppContext, FutureExt, Timeout, TestApp};

struct Status {
    message: String,
}

let mut app = TestApp::new();
let status = app.update(|cx| cx.new(|_| Status { message: String::new() }));

app.update(|cx| {
    let status = status.clone();
    cx.spawn(async move |cx| {
        // A stand-in for a slow request that takes ten seconds.
        let request = cx.background_executor().timer(Duration::from_secs(10));
        let message = match request
            .with_timeout(Duration::from_secs(2), cx.background_executor())
            .await
        {
            Ok(()) => "finished".to_string(),
            Err(Timeout) => "timed out".to_string(),
        };
        status.update(cx, |status, cx| {
            status.message = message;
            cx.notify();
        });
    })
    .detach();
});

app.run_until_parked();
app.advance_clock(Duration::from_secs(3));
app.run_until_parked();

app.update(|cx| assert_eq!(status.read(cx).message, "timed out"));
```

## Work with a window from async code

[`Context::spawn`] gives you an [`AsyncApp`], which can update the app but knows nothing
about windows. When the work needs a window, such as to set its title or to read focus,
use [`Context::spawn_in`]. It takes the window you pass in and gives the closure an
[`AsyncWindowContext`]. Call [`AsyncWindowContext::update`] to run code with the window,
which returns a `Result` that fails once the window has closed.

```rust
use std::time::Duration;

use gpui::{Context, Render, Task, Window, div, prelude::*};

struct Clock {
    ticks: usize,
    _ticker: Task<()>,
}

impl Clock {
    fn start(&mut self, window: &mut Window, cx: &mut Context<Self>) {
        self._ticker = cx.spawn_in(window, async move |clock, cx| loop {
            cx.background_executor().timer(Duration::from_secs(1)).await;
            let Ok(ticks) = clock.update(cx, |clock, cx| {
                clock.ticks += 1;
                cx.notify();
                clock.ticks
            }) else {
                break;
            };
            // Fails once the window is gone, which ends the loop.
            if cx
                .update(|window, _cx| window.set_window_title(&format!("{ticks} s")))
                .is_err()
            {
                break;
            }
        });
    }
}

impl Render for Clock {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child(format!("{} s", self.ticks))
    }
}
```

`start` takes the window and passes it to `spawn_in`. Keep the task in a field so that
dropping the view stops the clock.

## Use tokio libraries through `gpui_tokio`

Some libraries, such as networking crates, expect a [tokio](https://tokio.rs) runtime.
The `gpui_ce_tokio` crate, which the workspace depends on as `gpui_tokio`, runs one for
you and returns each future as a GPUI task. Call `gpui_tokio::init(cx)` once at startup. It
creates a runtime with two worker threads. To share a runtime you already have, call
`gpui_tokio::init_from_handle` instead. Calling either before the first use is required:
the functions below read the runtime from the app and panic if it's missing.

* `Tokio::spawn(cx, future)` runs a `Send` future on tokio and returns a
  `Task<Result<R, JoinError>>`.
* `Tokio::spawn_result(cx, future)` does the same for a future that returns
  `anyhow::Result<R>`, and returns a `Task<anyhow::Result<R>>`.
* `Tokio::handle(cx)` returns the runtime's `tokio::runtime::Handle`, for code that needs
  one directly.

Dropping the GPUI task aborts the tokio task. Await the GPUI task, or detach it, the same
way as any other task. The futures you pass to tokio can't use entities or windows, so
move results back with `Context::spawn` as in the first section. This crate has no
doctests, so this page describes its API rather than running an example.

## Test async code deterministically

In tests, both executors run on a single simulated scheduler, and time only moves when
the test moves it. [`TestApp::run_until_parked`] runs all work that can make progress.
[`TestApp::advance_clock`] moves the simulated time forward and wakes any timers that are
due. Together they make the timers in this guide run instantly and repeatably.

```rust
use std::time::Duration;

use gpui::{AppContext, Context, Task, TestApp};

struct Ticker {
    ticks: usize,
    _task: Task<()>,
}

let mut app = TestApp::new();
let ticker = app.update(|cx| {
    cx.new(|cx: &mut Context<Ticker>| Ticker {
        ticks: 0,
        _task: cx.spawn(async move |ticker, cx| loop {
            cx.background_executor().timer(Duration::from_secs(1)).await;
            if ticker
                .update(cx, |ticker, cx| {
                    ticker.ticks += 1;
                    cx.notify();
                })
                .is_err()
            {
                break;
            }
        }),
    })
});

// Let the task start its first timer, then advance one second at a time.
app.run_until_parked();
for _ in 0..3 {
    app.advance_clock(Duration::from_secs(1));
    app.run_until_parked();
}

app.update(|cx| assert_eq!(ticker.read(cx).ticks, 3));
```

Each test with [`TestApp`] is one turn of the event loop, so run the work and then assert in
a later update. The [testing guide](crate::_documentation::guides::testing) covers seeds
and `#[gpui::test]`, which runs a test with many random task orderings.

## See also

- [Executors and tasks](crate::_documentation::concepts::executors), for the foreground
  and background executors.
- [Contexts](crate::_documentation::concepts::contexts#async-contexts), for `AsyncApp` and
  `AsyncWindowContext`.
- [Share state between views](crate::_documentation::guides::sharing_state), for updating
  entities from tasks.
- [The tasks example](crate::_documentation::examples::tasks), a stopwatch and a
  cancellable prime search.
