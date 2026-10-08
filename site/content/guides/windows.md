+++
title = "Keep window and frame lifetimes straight"
description = "Distinguish a window handle, a root entity, retained element state, and a frame callback."
weight = 35
+++

`App::open_window` asks the platform to create a window and installs the entity
returned by its root-builder closure. The window owns that root while it is
open. The returned typed `WindowHandle<V>` identifies the window and expected
root type; copying or dropping a handle does not open or close the window.

The [first-window walkthrough](@/examples/first-window.md) creates that root
with `AppContext::new` inside `App::open_window`. The platform supplies the
native window or browser canvas; the view supplies the element tree.

## Reacquire a window through its handle

[`WindowHandle::update`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.WindowHandle.html#method.update)
looks up the live window and gives the closure exclusive access to its root,
window, and context. It returns an error after close or if the root's type
changed. Do not read or update that same root through another handle inside the
closure; it is already leased. A strong handle to the former root can keep that
entity alive without keeping its former window open.

Use `AsyncWindowContext` across an await. Each operation reacquires access by
window handle; it does not reserve the window while the task waits. Check the
update result after the await because the window may close in between. If work
only needs an entity, a weak entity handle may be enough; see the
[async guide](@/guides/async.md).

## Give retained state a stable identity

An element value normally belongs to one draw. Its `RequestLayoutState` and
`PrepaintState` pass work between phases of that draw. They do not hold the
state of the next element value returned by `render`.

[`Window::with_element_state`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.with_element_state)
keeps state by global element path and Rust state type. Its closure receives
the previous value and returns both the current result and replacement state.
State survives consecutive frames that access it; omitting it from a frame
ends that continuity. Keep the ID stable for the same logical child and
distinct across siblings. In a reordered list, use the item's stable key rather
than its current index.

Use [`Window::use_keyed_state`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.use_keyed_state)
when retained state should be an entity whose notifications invalidate the
containing view. Its key scopes the state to this rendered element. For a
smaller value passed only between phases, use the frame-local state in
`Element`. The [custom-element walkthrough](@/examples/custom-element.md)
shows that frame-local handoff.

## Schedule for the boundary you need

| Operation | When its callback runs | What it retains |
| --- | --- | --- |
| `Context::defer_in` | During effect processing, after the current entity borrow ends | A weak entity handle; delivery needs an available associated window |
| `Window::on_next_frame` | At the next platform frame opportunity, before drawing | The queued callback and anything it captures |
| `Context::on_next_frame` | The same frame opportunity, with an entity update | A strong handle to this entity until delivery or window teardown |
| `Context::spawn_in` | Each time its foreground future is polled | The task's captures; its supplied entity handle is weak |

A frame callback can notify a view before the ensuing draw. Registering it wakes
the platform frame source, but does not invalidate the view or guarantee a
draw. Call `cx.notify()` from the callback when its mutation must be rendered.
Use `request_animation_frame` for continued animation demand, and respect
`App::reduce_motion` for decorative motion. The
[animation walkthrough](@/examples/animation.md) uses the higher-level animation
wrapper, which applies that preference.

## Keep document changes on the model

[`Window::set_window_edited`](https://docs.rs/gpui-ce/0.2.2/gpui/struct.Window.html#method.set_window_edited)
sets the native unsaved-changes indicator on macOS. It does not notify a view,
write a file, or stop the window from closing. Keep the modified flag on the
document model, notify after changing it, and update the native indicator as
part of presenting that state.

Use `on_window_should_close` when closing requires a save or discard decision.
Return `false` while the decision is pending; returning `true` allows the native
close immediately. Track the pending decision so repeated close requests do not
open several prompts. The
[prompt example](https://gpui-ce.github.io/book/platforms.html#wait-for-a-prompt-without-blocking-the-window)
shows the callback, pending flag, receiver, and approved removal together. The
[platform chapter](https://gpui-ce.github.io/book/platforms.html#appearance-backdrops-and-document-state)
also distinguishes document state from the window's color appearance and backdrop.
