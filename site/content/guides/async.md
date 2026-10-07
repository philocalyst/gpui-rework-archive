+++
aliases = ["guide/system/async-executor/", "system/async-executor.html"]
title = "Keep async work alive"
description = "Choose the executor, retain the task, and handle a released view."
weight = 50
+++

Use the foreground executor to coordinate UI state. Use the background executor
for owned `Send` work that would block input if performed in a listener.
Neither executor lets you keep a mutable app or window borrow across an await.

## Keep the task handle

A returned `Task` is part of the lifecycle. Store it when the operation belongs
to the view. Dropping it normally cancels the operation. Detaching makes the
work independent of that handle, so use it deliberately.

The [async walkthrough](@/examples/async-task.md) keeps a task in a field, waits
without blocking the UI thread, and updates the view through a weak handle.
Restarting replaces the previous task and cancels its pending completion.

## Apply only the result you still want

If more than one request can complete, identify the request whose result is
current. Cancelling a task does not necessarily undo a request already sent to
another service. A generation counter or request ID can prevent an old result
from replacing newer state.

The view may also be gone. Handle a failed weak update as teardown rather than
unconditionally unwrapping it after an await.

## Test time without sleeping

Use GPUI's test dispatcher and timer controls for deterministic completion
checks. Keep a performance measurement separate: a simulated one-second delay
does not demonstrate production latency.

The [scheduling explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/scheduling/index.html)
documents the executors and task ownership together.
