# Design

GPUI was built for one demanding application: [Zed](https://zed.dev), a code
editor that aims to respond to every keystroke within a frame, on documents of
any size. Most of GPUI's design follows from that goal and from the language it
is written in. This page explains the main decisions, what they buy you, and
what they cost.

## Why draw everything on the GPU?

A code editor shows a lot of text, scrolls it constantly, and is expected to keep
up with a 120 Hz display. GPUI sends a whole frame to the GPU as a handful of
batched draw calls: rectangles, glyphs from a texture atlas, shadows, paths and
images. Drawing a frame costs little CPU time, and the cost depends on what is
visible rather than on how it was produced.

The price is that GPUI draws its own controls instead of using the operating
system's. A GPUI button looks the same on every platform, which is often what
an app wants and sometimes what it doesn't. Native behaviors that come for free
with system controls, such as text input methods and accessibility, have to be
built into GPUI deliberately, and they are.

## Why build the interface again every frame?

Your `render` method returns a fresh tree of elements whenever a view changes.
There is no diffing against the previous tree and no virtual DOM to reconcile;
the elements are built, laid out, painted and dropped.

This keeps your code simple. The interface is a function of your state, so it
can't drift out of sync with it, and there are no update methods to write for
each way the state can change. It's affordable because elements are small
values and GPUI is designed to rebuild them quickly; when a view is expensive,
[`Entity::cached`] reuses its last frame instead.

Rebuilding everything doesn't mean forgetting everything. State that belongs to
an element, like a scroll position or a running animation, is kept between
frames under the element's id. GPUI is sometimes called a hybrid of immediate
and retained mode for this reason: you write code as if the interface were
recreated every frame, and GPUI retains what needs retaining.

## Why does the app own my state?

User interfaces are graphs of shared, mutable state, and Rust is strict about
both sharing and mutation. The usual workaround, `Rc<RefCell<T>>`, gives up most
of what makes Rust pleasant: borrows are checked at run time, cycles leak, and
nothing knows who depends on what.

GPUI instead keeps all state in one owner, the [`App`], and gives you typed
handles, [`Entity<T>`](Entity), to reach it. Because every read and update goes
through the app, GPUI knows which windows depend on which entities, can tell
observers about changes, and can hand out mutable access without runtime borrow
flags scattered through your program. Handles can be stored anywhere and sent
into async code, because a handle borrows nothing.

The cost is a little ceremony: you read through `entity.read(cx)` and write
through `entity.update(cx, ...)` rather than touching a field directly. And GPUI
doesn't detect changes for you. You call `notify` when something changed. That
makes updates explicit and cheap, but forgetting to notify is the most common
GPUI bug. [Ownership](crate::_documentation::concepts::ownership) describes the
model in full.

## Why pass contexts everywhere?

Almost every function takes a `cx`. Passing access explicitly, instead of
reaching for thread-locals or globals, means the borrow checker can see it: a
function that takes `&mut App` can change things, one that takes `&App` can
only look, and nothing can hold onto access longer than it should. It also
makes code testable, since a test can create an app of its own and pass it in.

## Why style with methods instead of stylesheets?

GPUI has no stylesheets and no cascade, apart from text properties that
inherit. Each element carries its own styles, set with methods named after
[Tailwind CSS](https://tailwindcss.com) classes.

Methods are typed and discoverable: your editor completes them, the compiler
checks them, and a style can't silently fail to match. Keeping styles on the
element means you can read a piece of interface and see exactly how it looks,
and reusing a look means writing a function or a component, which Rust already
does well. What you give up is the ability to restyle an app from the outside.
Themes in GPUI are ordinary state, usually a [`Global`], that your components
read.

## Why actions and key contexts?

Zed is used mostly from the keyboard, with hundreds of commands that users
rebind. So GPUI separates *what* the app can do, declared as
[actions](Action), from *which keys* do it, declared in a keymap, and from
*where* a key applies, declared with key contexts on the element tree. The same
keystroke can mean different things in an editor and a file list, the same
action can come from a key, a menu or a command palette, and a user's keymap
can change any of it without touching your code. [Input and
dispatch](crate::_documentation::concepts::input_dispatch) explains the
mechanics.

## Why its own executor?

GPUI's async executor is integrated with each platform's event loop, so tasks
spawned on the main thread run between frames and input events, with access to
your entities. In tests the same executor runs on a simulated clock with a
seeded scheduler, which makes async code deterministic: a timeout takes no time
to test, and a scheduling bug can be reproduced from its seed. [Executors and
tasks](crate::_documentation::concepts::executors) describes both.

## Why flexbox and grid?

Layout uses [Taffy](https://github.com/DioxusLabs/taffy), an implementation of
the CSS flexbox and grid algorithms. They are expressive, familiar to anyone
who has built for the web, and documented far beyond what any new layout system
could be.

## What GPUI doesn't do

Knowing what a framework leaves out is as useful as knowing what it does.

* **No native controls.** GPUI draws everything itself. Apps look the same on
  every platform and don't automatically adopt the look of each.
* **A small set of built-in widgets.** GPUI gives you elements, styling,
  layout, input and text editing (in `gpui_ce_elements`). Buttons, menus,
  dialogs and the like are yours to build as components, which is quick, but it
  is work that a widget toolkit would do for you.
* **No automatic change tracking.** State changes are announced with `notify`
  or events. There are no signals, and nothing recomputes on its own.
* **Desktop and web only.** GPUI runs on macOS, Windows, Linux and in browsers
  through WebAssembly. Touch input is supported, but there are no mobile
  platform backends.
* **One UI thread.** Views and entities live on the main thread. Use the
  background executor for parallel work.
* **Not yet stable.** GPUI is pre-1.0, and APIs change between releases.

If these trade-offs suit your app, GPUI is fast, predictable and pleasant to
build with. If not, [Comparison](crate::_documentation::comparison) describes
other Rust toolkits and what they do differently.
