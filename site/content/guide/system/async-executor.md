+++
title = "Async executor: tasks that respect windows"
description = "Run asynchronous work without blocking the interface, then bring its result back to state."
weight = 30
aliases = ["/system/async-executor.html"]
[extra]
category = "SYSTEM"
legacy_source = "gpui-ce-docs/build/html/system/async-executor.html"
+++

If your UI ever freezes, look here first. A **Task** is a future the executor polls until it resolves or its owner drops it. GPUI gives you two executors: **BackgroundExecutor** runs `Send` futures off the UI thread ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)), and **ForegroundExecutor** runs futures on the UI thread ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)). Spawn on the wrong one and every window stutters.

```rust
// Fetch off-thread, then touch your view on-thread. This is the whole dance.
let fetch = cx.background_executor().spawn(async move {
    // Background work must be `Send + 'static` — no borrowed view state here.
    load_bytes().await // `executor.rs:117` enforces the `Send` bound
});
cx.foreground_executor().spawn(async move {
    // Foreground work needs no `Send` — this is where UI updates belong.
    let bytes = fetch.await; // wait off-thread first, then update below
    view.update(&mut cx, |v, cx| v.set_bytes(bytes, cx)).ok();
}).detach(); // `detach()` lets the task finish without holding its handle
```

You have four spawn paths, and they are not interchangeable. Pick with intent.

|  |  |  |
| --- | --- | --- |
| Call | Runs on | What you should know |
| `cx.spawn` | foreground | `async_context.rs:242`; dies with the view — your safest default |
| `cx.background_executor().spawn` | background | `executor.rs:117`; needs `Send + 'static`; I/O lives here |
| `cx.foreground_executor().spawn` | foreground | `executor.rs:359`; no `Send` needed; UI writes live here |
| `Tokio::spawn` | tokio pool | `gpui_tokio.rs:55`; call `init` first (`gpui_tokio.rs:12`); returns `Task<Result<R, JoinError>>` |

Table 38: The four ways to spawn, and where each one runs.

## Lifetimes you can trust

A `Task<R>` arrives immediately, before any work runs. Drop it and the future cancels silently — no panic, no log, just gone. That silence is a feature when your view closes mid-fetch, and a trap when you drop a handle by accident.

```rust
// Holding the task ties its life to your view. Dropping cancels. On purpose.
struct Reader {
    _fetch: Task<Vec<u8>>, // keep me alive and the fetch survives
}
// Anti-pattern: a detached loop with no owner outlives its view forever.
// cx.spawn(async move |_cx| { loop { tick().await; } }).detach();
// Fix: store the `Task` in your view so closing the view kills the loop.
```

> **Pitfall.** Dropping a `Task` cancels it without a sound. If your fetch never finishes, check whether its handle fell off the end of a function before you blame the network.

When a task fails after you detached it, reach for `detach_and_log_err`. It takes `&App` for logging context ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)), and its sibling `detach_and_log_err_with_backtrace` adds a full backtrace for `anyhow::Error` ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)). Two more tools round out the set: `spawn_when_idle` defers work until the UI rests ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)), and `spawn_with_priority` orders background work ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)). To wait on a group, open a `Scope` and `spawn` into it ([crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs), [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)).

> **Tip.** Prefetch with `spawn_when_idle`, not `spawn`. Your scroll stays smooth and the data is warm when the user asks.

Where next? Cache what you fetched (`system-assets-http`), then measure the win (`guides-performance`).

## Sources

- `BackgroundExecutor`, `ForegroundExecutor`: [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs), [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)
- `BackgroundExecutor::spawn`, `spawn_with_priority`: [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs), [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)
- `detach_and_log_err`, backtrace variant: [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs), [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)
- `ForegroundExecutor::spawn`, `spawn_when_idle`: [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs), [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)
- `Scope`, `Scope::spawn`: [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs), [crates/gpui/src/executor.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/executor.rs)
- `cx.spawn`, executor accessors: [crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs), [crates/gpui/src/app/async_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/async_context.rs)
- Tokio `init`, `Tokio::spawn`: [crates/gpui_tokio/src/gpui_tokio.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_tokio/src/gpui_tokio.rs), [crates/gpui_tokio/src/gpui_tokio.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_tokio/src/gpui_tokio.rs)
