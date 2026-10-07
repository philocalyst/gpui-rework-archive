# Tasks and the UI thread

The foreground executor runs work on the UI thread. The background executor
runs `Send` work through the platform dispatcher. Those are scheduling choices,
not two ways to borrow an entity's state.

## Leave the UI thread free

A listener should perform a short update and return. A long CPU calculation
inside a listener delays input and drawing. Move that work to
[`BackgroundExecutor::spawn`](crate::BackgroundExecutor::spawn), carrying owned
data into the future. Do not carry `&mut Window`, `&mut App`, or a borrowed view
across an await point.

Use [`Context::spawn`](crate::Context::spawn) to coordinate the result with the
view. Its future receives a weak entity handle and an async context. After the
work completes, update the entity through that context and call `notify` if
the visible state changed.

The [async walkthrough](https://gpui-ce.github.io/examples/async-task/#completion)
shows the complete lifecycle. Its timer yields while the application remains
responsive; a blocking operation belongs on the background executor rather
than inside the same foreground future.

## Keep or detach the task

A [`Task`](crate::Task) represents running work. Dropping its handle normally
cancels the task. Keep it in a field when the work belongs to the view's lifetime.
Calling `detach` lets the task continue without that handle; it also means the
caller cannot later await the result through the dropped handle.

Cancellation is not rollback. An operation may already have written a file,
sent a request, or changed another resource before the task is dropped. Check
the operation's own cancellation contract when that distinction matters.

## Return through a weak handle

The view can disappear before a future completes. Weak entity updates return
an error when the entity has been released. Handle that ordinary teardown path
instead of unconditionally unwrapping an update after an await.

Keeping a strong entity handle in a long-lived task can keep the view alive.
Capturing a weak handle makes the intended lifetime explicit. Similarly,
[`AsyncApp`](crate::AsyncApp) has a weak application lifetime: converting an
app context to an async context does not keep an application running forever.

## Deterministic tests

The test dispatcher controls scheduling and simulated time. Use its timer and
clock operations to test a task completion or animation without sleeping the
test process. Such a test proves behavior under the controlled schedule; it
does not measure production latency. Native performance measurements belong
in a separate benchmark or platform capture.
