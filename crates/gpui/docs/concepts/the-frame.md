# The frame

This page follows one change through GPUI: from the moment you call `notify`
to the moment new pixels reach the screen. Knowing this path tells you where
each kind of code belongs, why some state survives between frames and some
doesn't, and why an idle GPUI app uses no CPU at all.

## From a change to a frame

Suppose a click handler increments a counter and calls
[`Context::notify`]. Here is what happens next.

1. **The window is marked dirty.** While the counter's window drew its last
   frame, GPUI recorded that it read the counter. Notifying the counter marks
   that window as needing a new frame. Nothing is drawn yet.
2. **The platform asks for a frame.** A dirty window asks the operating system
   to call it back at the display's next refresh, through a display link on
   macOS or `requestAnimationFrame` in a browser. Several changes before that
   callback cost one frame, not several.
3. **GPUI draws the window.** It calls `render` on the window's root view,
   builds the element tree, lays it out, and paints it into a *scene*: a flat
   list of primitives such as rectangles, glyphs, paths and images.
4. **The renderer presents the scene.** The scene goes to the GPU in a few
   batched draw calls and appears on screen.
5. **The window goes quiet.** If nothing is dirty and no animation asked for
   another frame, the window stops requesting frames until the next change.

The last step matters. GPUI isn't a game loop that redraws sixty times a second
regardless. It draws when something changed and only then.

## Building a frame

Drawing a window walks the element tree four times. Each walk has a job, and the
jobs are ordered so that each one can rely on the one before it.

| Phase | What it does | What it knows |
| --- | --- | --- |
| Render | Views return their elements | The views' state |
| Request layout | Each element describes its size and position rules to the layout engine | Styles, but no sizes yet |
| Prepaint | Each element learns its bounds and records how it can be hit by the mouse | Final bounds |
| Paint | Each element adds primitives to the scene and registers event listeners | Final bounds, hitboxes |

**Render.** GPUI calls [`Render::render`] on the root view. Views build their
elements with [`div`] and friends and return them. Child views appear in that
tree as elements too, and GPUI renders them as it reaches them. This is the
only phase you touch in most code.

**Request layout.** Each element calls back into the window with its
[`Style`]: flex direction, padding, width, and so on. GPUI builds a layout tree
from these requests, and then [Taffy](https://github.com/DioxusLabs/taffy), the
layout engine GPUI uses, computes every element's bounds in one pass. An
element that measures its own content, such as text, provides a measuring
function instead of a fixed size.

**Prepaint.** Every element now knows its [`Bounds`]. Elements that react to
the mouse insert a [`Hitbox`] here, so that GPUI can later tell which element
is under the pointer. Scrollable containers apply their scroll offset, and
elements that need to know their final position, such as an autoscroll target,
compute it now.

**Paint.** Elements paint quads, text, images and paths into the scene, in
back-to-front order. They also register their event listeners. Those listeners,
like the hitboxes, stay active until the next frame replaces them, so a click is
always delivered to the interface the user actually saw.

At the end, the new frame replaces the previous one. Its hitboxes and listeners
are what the next mouse event is tested against, and its scene is what the
renderer draws.

## What lives between frames

Elements are values that you build in `render`, consume while drawing, and
throw away. A `div()` returned from `render` doesn't exist on the next frame;
`render` builds a new one. Building elements is cheap, and rebuilding them
means your interface is always a function of your current state.

State that must outlive a frame lives in one of three places:

* **Entities.** Your view's fields, and any other entity, persist until you drop
  their last handle. This is where application state belongs. See
  [ownership](crate::_documentation::concepts::ownership).
* **Element state.** Some state belongs to an element rather than to your
  program: whether a button is pressed, how far a list is scrolled, which part
  of an animation is playing. GPUI stores it for you, keyed by the element's
  [`id`](InteractiveElement::id). An element with the same id path on the next
  frame gets the same state back. That's why interactive elements need ids, and
  why the ids must be stable from one frame to the next.
* **The last frame.** Hitboxes, listeners and layout from the last frame stay
  around until the next one replaces them. Input is dispatched against them.

[Elements](crate::_documentation::concepts::elements) explains element ids and
element state in more detail.

## Rendering less

By default, a dirty window renders its whole tree, starting from the root view.
This is usually fast: rendering only builds small values, and layout and paint
are designed for it. When a view is expensive to render and rarely changes,
embed it with [`Entity::cached`]. GPUI then reuses that view's elements, layout
and painted primitives from the previous frame until the view itself is
notified.

Lists are the other big lever. [`uniform_list`] and [`list`] only render the
rows that are visible, so a list of a million rows costs about as much as a
list of thirty.

## Asking for the next frame

Animations need frames even when no state changes. An animated element asks
for the next frame while it is running, and stops asking when it finishes, so
an app is idle again as soon as its last animation ends. You rarely need to do
this yourself: [`with_animation`](AnimationExt::with_animation), transitions
and springs request frames for you. For your own continuous drawing, call
[`Window::request_animation_frame`] from `render`, and
[`Window::on_next_frame`] to run code right after the next frame is drawn.

[`Window::refresh`] marks the whole window dirty without notifying any entity.
It is useful when something outside your state changes what a view shows, such
as the system appearance.

## Rules of thumb

* Keep `render` free of side effects. It may run many times, or not at all, for
  a given change.
* Never block in `render` or in event handlers. Start a task with
  [`Context::spawn`] instead; see [executors](crate::_documentation::concepts::executors).
* Give every interactive element a stable `id`.
* Call `notify` when state that affects rendering changes, and only then.
* Reach for [`Entity::cached`] and virtualized lists when profiling shows
  rendering is expensive, not before.
