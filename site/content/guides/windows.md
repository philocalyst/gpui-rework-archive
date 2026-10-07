+++
title = "Keep window and frame lifetimes straight"
description = "Distinguish a window handle, a root entity, retained element state, and a frame callback."
weight = 35
+++

Opening a window installs a root view. The window retains that view's entity;
the returned window handle identifies the window and records its declared root
type. Copying or dropping a window handle does not open or close a window.

The [first-window walkthrough](@/examples/first-window.md) creates that root
with `AppContext::new` inside `App::open_window`. The platform supplies the
native window or browser canvas; the view supplies the element tree.

## Reacquire a window through its handle

[`WindowHandle::update`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowHandle.html#method.update)
looks up the live window and gives the closure its root, window, and app.
It can fail after close or after the root changes to another type. A strong
handle to the former root can keep that entity alive without keeping its former
window open.

Use an `AsyncWindowContext` across an await. Each operation reacquires access;
it does not reserve the window while the task waits. Handle teardown when
applying the result, as the [async guide](@/guides/async.md) describes.

## Give retained state a stable identity

An element value normally belongs to one draw. Its `RequestLayoutState` and
`PrepaintState` pass work between phases of that draw. They do not hold the
state of the next element value returned by `render`.

[`Window::with_element_state`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.with_element_state)
keeps state separately under the global element path and state type. Its
closure takes the previous state and returns both a result and the replacement
state. State survives consecutive frames that access it; a frame that omits
it ends that continuity. A list row therefore needs its logical key, rather
than its changing position, as an ID.

For an entity whose notifications should invalidate the containing view,
[`Window::use_keyed_state`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.use_keyed_state)
adds that observation. The [custom-element walkthrough](@/examples/custom-element.md)
shows the smaller, frame-local handoff used when no retained state is needed.

## Schedule for the boundary you need

| Operation | When its callback runs | What it retains |
| --- | --- | --- |
| `Context::defer_in` | During effect processing, after the current entity borrow ends | A weak entity handle; delivery needs an available associated window |
| `Window::on_next_frame` | At the next platform frame opportunity, before drawing | The queued callback and anything it captures |
| `Context::on_next_frame` | The same frame opportunity, with an entity update | A strong handle to this entity until delivery or window teardown |
| `Context::spawn_in` | Each time its foreground future is polled | The task's captures; its supplied entity handle is weak |

A frame callback can notify a view before the ensuing draw. Merely queuing the
callback wakes the frame source; it does not force the view to redraw. Use
`request_animation_frame` for continued animation demand, and respect
`App::reduce_motion` for decorative motion. The
[animation walkthrough](@/examples/animation.md) uses the higher-level animation
wrapper, which applies that preference.
