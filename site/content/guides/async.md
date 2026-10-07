+++
aliases = ["guide/system/async-executor/", "system/async-executor.html"]
title = "Keep async work alive"
description = "Choose the executor, retain the task, and handle a released view."
weight = 50
+++

Use the foreground executor to coordinate UI state and interact with GPUI
entities. Use the background executor for independent `Send` work such as
blocking I/O or computation that would otherwise delay input. A foreground
future is not permission to hold a mutable entity, app, or window borrow across
`.await`; reacquire access after the wait.

## Keep the task handle

A returned [`Task`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Task.html) is part
of the lifecycle. Store it when the operation belongs to the view. Dropping
the handle cancels future polling; it cannot undo a side effect already sent to
another process or service. Detaching makes the task independent of that handle,
so choose an owner and completion path before detaching.

The [async walkthrough](@/examples/async-task.md) keeps a task in a field, waits
without blocking the UI thread, and updates the view through a weak handle.
Restarting replaces the previous task and cancels its pending completion.

## Apply only the result you still want

If more than one request can complete, identify the request whose result is
current. Cancelling a task does not necessarily undo a request already sent to
another service. A generation counter or request ID can prevent an old result
from replacing newer state.

The view may also be gone. A `WeakEntity` update can fail after release; treat
that as normal teardown rather than unconditionally unwrapping it after an
await. If the result belongs to a window, use `AsyncWindowContext` so each
operation reacquires the live window instead of retaining a window borrow.

If a request can be superseded, keep a request ID or generation with the state.
Check it when the result returns before applying the value. Cancellation and
staleness solve different problems: cancellation asks work to stop, while a
generation check prevents an old result from winning if it completes anyway.

## Test time without sleeping

Use GPUI's test dispatcher and timer controls for deterministic completion
checks. Keep a performance measurement separate: a simulated one-second delay
does not demonstrate production latency.

The [scheduling explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/scheduling/index.html)
documents the executors and task ownership together.
