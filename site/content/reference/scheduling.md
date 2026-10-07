+++
aliases = ["fundamentals/platform-loop.html", "guide/fundamentals/platform-loop/"]
title = "Scheduling and lifetimes"
description = "Understand foreground work, background work, cancellation, and weak updates."
weight = 40
+++

A task can outlive its initiating event, but it does not carry a mutable app or
window borrow across an await. A foreground future is polled on the UI thread;
keep each poll short and reacquire the entity through its weak handle after an
await. Use the background executor for owned `Send` work that can run
independently. Retain the task handle when the initiating view owns the work;
dropped tasks stop polling, but cannot roll back an external side effect.

Read [tasks and the UI thread](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/scheduling/index.html)
for executor, cancellation, and task ownership. The [async walkthrough](@/examples/async-task.md)
stores a task on the view, cancels it from a click, and ignores completion if
the weak view handle can no longer be updated. For window work, see the
[window lifetime guide](@/guides/windows.md); `AsyncWindowContext` reacquires
the live window on each operation.
