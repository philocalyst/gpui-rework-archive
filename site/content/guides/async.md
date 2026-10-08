+++
aliases = ["guide/system/async-executor/", "system/async-executor.html"]
title = "Keep async work alive"
description = "Choose the executor, retain the task, and handle a released view."
weight = 50
+++

Use a foreground task to wait for work and apply its result to GPUI state.
Each poll runs on the UI thread, so a long parse or computation there still
delays input. Move owned inputs to the background executor when the work can
run independently and is `Send`, then await its result from the foreground.
On the web, background dispatch can fall back to the browser thread; check the
[platform requirements](https://gpui-ce.github.io/book/platforms.html) before
relying on parallel execution.

An entity, app, or window borrow must end before `.await`. Reacquire state
after the wait through an
[`AsyncApp`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.AsyncApp.html) or
[`AsyncWindowContext`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.AsyncWindowContext.html)
update closure.

## Keep the task handle

A [`Task`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Task.html) is both a future
and a cancellation handle. Await it to obtain its output. Store it on the view
when releasing the view should cancel the operation. Dropping it requests
cancellation after the current poll returns; detaching lets the operation
continue without a handle that can cancel it or retrieve its output.

The [async walkthrough](@/examples/async-task.md) keeps a task in a field, waits
without blocking the UI thread, and updates the view through a weak handle.
Restarting replaces the previous task and cancels its pending completion.

The weak entity handle passed to `Context::spawn` does not cancel the task.
If the task is retained elsewhere or detached, it can run after the view is
released. Its next weak entity update returns an error. Closing a window also
leaves a window-aware task running; handle the error from the next window
update. The [ownership test](https://gpui-ce.github.io/book/testing.html#separate-task-ownership-from-entity-ownership)
demonstrates this distinction with a controlled completion channel.

## Apply only the result you still want

Cancelling GPUI's future cannot undo a request or write already sent to another
service. If a request can be replaced, keep its identity with the state and
check it before applying the result. A generation counter is one option:
increment it when starting a request, capture that value, and accept the
result only if the stored generation still matches.

Test the race by completing the newer request first and the older one second.
The [stale-result test](https://gpui-ce.github.io/book/testing.html#reject-a-result-from-a-replaced-request)
keeps both tasks alive so cancellation cannot hide a missing identity check.
The request's own cancellation or transaction contract needs a separate test.

## Test time without sleeping

Use GPUI's test dispatcher and timer controls to check completion at a deadline.
The [timer test](https://gpui-ce.github.io/book/testing.html#check-both-sides-of-a-timer-deadline)
asserts pending state immediately before the deadline and completion at it.
A simulated delay establishes timing behavior under that schedule, not
production latency.

The [scheduling explanation](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/scheduling/index.html)
documents the executors and task ownership together.
