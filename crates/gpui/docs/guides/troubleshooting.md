# Troubleshooting

Find your symptom below. Each entry gives the usual cause, then the fix. Most
problems here come from one of four places: a missing `notify`, an element that
doesn't have the id or the layout GPUI expects, focus or key context, or a task
or handle that was dropped too early.

## The view doesn't update

**Cause.** You changed a field of a view or entity but didn't call
[`Context::notify`]. A view re-renders only when its entity is notified, or when
its window draws for another reason. A plain field write is invisible to GPUI.

**Fix.** Call `cx.notify()` after the change, on the same context you used to
change the state:

```rust
use gpui::Context;

struct Counter {
    count: usize,
}

impl Counter {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count += 1;
        cx.notify();
    }
}
```

If the state lives in another entity, notify that entity. See
[the frame](crate::_documentation::concepts::the_frame) for when a window
redraws.

## "cannot update … while it is already being updated"

**Cause.** The entity is already leased by an `update` or `read` that is still on
the stack, and you tried to reach it again. The panic message reads
`cannot update Counter while it is already being updated`, or `cannot read` for
a read. The usual reason is a handle you captured earlier, which you then use
inside the update:

- Inside `counter.update(cx, |this, cx| ...)`, you call `counter.read(cx)` or
  `counter.update(cx, ...)` on the same entity, through a clone of its handle.
- An event handler for entity A updates entity B, and B's handler updates A.

GPUI takes the entity out of storage while an update runs, so any access to it
during that update panics. The [ownership concept](crate::_documentation::concepts::ownership)
explains handles and when they can be used.

**Fix.** Inside an update, use the `this` you were given. It is already the
entity's state, so there is no need to read the handle again. For work that
must touch another entity after the current update finishes, defer it:

```rust
use gpui::{App, Entity};

fn bump_later(counter: Entity<usize>, cx: &mut App) {
    // Runs after the current update has finished and released its lease.
    cx.defer(move |cx| counter.update(cx, |count, _| *count += 1));
}
```

## A click handler never runs

**Cause.** One of these:

- The element has no [`id`][InteractiveElement::id]. [`on_click`][StatefulInteractiveElement::on_click]
  is only available on elements with an id, so the code won't compile without
  one. If you attached the handler to a different element, check that one.
- Another element covers the one you clicked. Mouse events go to the topmost
  hitbox, front to back, and a listener only runs if the pointer is over its
  element. An element with [`occlude`][InteractiveElement::occlude] blocks the
  events behind it.
- The element has no size. A zero-width or zero-height element has nothing to
  hit. Check its width and height with the inspector.

**Fix.** Give the element an id with `.id(...)`. Move or raise the element that
covers it, or stop the cover with `occlude` if it shouldn't be there. Give the
element a size with `size`, `w` and `h`, or with its children.

## A key binding does nothing

**Cause.** A keystroke goes to the focused element and the path above it, so
the binding is skipped when:

- No element has focus. Only the element with focus, and its ancestors, receive
  keys. Call `window.focus(&handle, cx)` after the window opens, and make sure
  the element tracks the handle with `track_focus`.
- The binding's key context doesn't match. A binding added with a context such as
  `Some("Editor")` applies only when an element on the focus path calls
  `key_context("Editor")`.
- A deeper binding wins. When two bindings match the same keystroke, the one
  whose context is deeper on the focus path wins, and the last one added wins a
  tie. A binding with no context counts as matching at the deepest level, so it
  can override a binding on an ancestor.
- Another handler stopped the action. An action handler that calls
  `cx.stop_propagation()` keeps it from reaching the bindings or handlers
  behind it.

**Fix.** Check focus first, then the key context, then the bindings. The
[input dispatch concept](crate::_documentation::concepts::input_dispatch)
describes the order in full and includes a working example.

## A scroll container doesn't scroll

**Cause.** The container needs three things. It has no [`id`][InteractiveElement::id],
so GPUI can't keep its scroll offset between frames, and wheel events do
nothing. Its height is unbounded, so its content never overflows it. Or it is a
flex child whose minimum height is its content's height, so it grows instead of
shrinking.

**Fix.** Give the container an id, set `overflow_y_scroll()` (or
`overflow_scroll()` for both axes), and bound its height with `h`, `h_full` or
`max_h` on it or on an ancestor:

```rust
use gpui::{div, prelude::*, px};

let messages = div()
    .id("messages")
    .max_h(px(300.))
    .overflow_y_scroll()
    .children((0..100).map(|index| div().child(format!("message {index}"))));
```

When the container is a flex child inside a column, also add `min_h_0`, as the
[layout example](crate::_documentation::examples::layout) does.

## A flex child overflows instead of shrinking

**Cause.** A flex item's minimum size is its content size by default, so a long
label or a wide child pushes past its container. Flex items grow and shrink
within their parent, but not below that minimum.

**Fix.** Set the minimum to zero on the axis you want to shrink. Use `min_w_0`
for a row and `min_h_0` for a column. The item then shrinks to fit, and its
own scroll container handles the rest:

```rust
use gpui::{div, prelude::*, px};

let row = div()
    .flex()
    .child(div().w(px(200.)).child("Sidebar"))
    .child(div().flex_1().min_w_0().child("A label that is much longer than the space it has"));
```

## An async task never runs

**Cause.** A [`Task`] cancels when it is dropped. An expression like
`cx.spawn(...);`, with no binding and no `.detach()`, drops the task on the
same line, so its future never gets to finish. A task that is stored and then
replaced or dropped stops in the same way.

**Fix.** Keep the task in a field if you need its result later, or call
`.detach()` if you want it to run to completion on its own. Detaching gives up
the return value, so detach only work whose result you don't need, or handle the
result inside the task:

```rust
use gpui::App;

fn start(cx: &mut App) {
    cx.background_executor()
        .spawn(async {
            // work that runs to completion
        })
        .detach();
}
```

Tests need [`TestApp::run_until_parked`] to run tasks. See the
[testing guide](crate::_documentation::guides::testing).

## Panic: "Action with name … already registered"

**Cause.** Two actions have the same name. An action's name is its namespace and
its type name, such as `editor::Save`, and names must be unique across the whole
binary. The registry is loaded when the app is created, so the panic happens at
startup. Two crates that both declare `actions!(editor, [Save])` collide. So does
a `deprecated_aliases` entry that matches the name of another action.

**Fix.** Give each set of actions its own namespace: `actions!(editor, [Save])`
and `actions!(files, [Save])` produce `editor::Save` and `files::Save`. Remove
the alias if its name is already taken. The
[input dispatch concept](crate::_documentation::concepts::input_dispatch) shows
how actions are declared and bound.

## Text is invisible on the web

**Cause.** The web platform starts with an empty font database, and it doesn't
read the browser's fonts. Until you add a font, the text system has nothing to
draw text with, so text doesn't appear. This differs from desktop, where GPUI
finds the system fonts.

**Fix.** Add the font bytes to the text system before you open a window. Call
`add_fonts` on the text system from [`App::text_system`], with font data you
bundle with the app or fetch before startup.

## The window closes but the app keeps running on macOS

**Cause.** The default quit mode, [`QuitMode::Default`], behaves like
[`QuitMode::Explicit`] on macOS. The app keeps running with no windows, as macOS
apps usually do, and quits only when [`App::quit`] is called, for example from a
menu. On Linux and Windows it behaves like [`QuitMode::LastWindowClosed`], so
closing the last window quits.

**Fix.** Choose the mode you want when you create the application:

```rust,no_run
use gpui::QuitMode;

fn main() {
    gpui_platform::application()
        .with_quit_mode(QuitMode::LastWindowClosed)
        .run(|_cx| {
            // Open the first window here.
        });
}
```

## Entities leak

**Cause.** A reference cycle keeps every entity in it alive, so none is ever
dropped. The usual shape is a parent that holds a strong `Entity` to a child, and
a child that holds a strong `Entity` back to the parent. A subscription or an
observer closure stored on `self` has the same effect if its closure captures a
strong handle to `self`.

**Fix.** Make one side of the link weak. Store a [`WeakEntity`] (from
`Entity::downgrade`) for the back-reference, and call `update` on it, which
returns a `Result` that fails if the entity is gone:

```rust
use gpui::{Entity, WeakEntity};

struct Parent {
    child: Entity<Child>,
}

struct Child {
    parent: WeakEntity<Parent>,
}
```

To find leaks in tests, build with the `leak-detection` feature (the
`test-support` feature enables it). Take a snapshot before the code under test
runs, and assert afterwards that no new entity is still alive:

```rust
use gpui::TestApp;

let mut app = TestApp::new();
let snapshot = app.read(|cx| cx.leak_detector_snapshot());

let entity = app.new_entity(|_| 0usize);
drop(entity);

app.read(|cx| cx.assert_no_new_leaks(&snapshot));
```

`assert_no_new_leaks` panics and lists each leaked entity with its type. Set
`LEAK_BACKTRACE` to include the backtrace where each one was created.

## "returns a reference to a captured variable which escapes the closure body"

**Cause.** You call a method that returns `impl IntoElement` from inside a
closure, usually one passed to `map` to build a list:

```text
.children(self.items.iter().map(|item| self.render_item(item, cx)))
```

In Rust 2024, a function returning `impl Trait` is assumed to borrow all of its
arguments, including `cx`, for as long as the returned value lives. The closure
can't hand out something that still borrows `cx`.

**Fix.** Say that the element owns everything it holds, with `+ use<>`:

```
# use gpui::{Context, IntoElement, div, prelude::*};
# struct List { items: Vec<String> }
# impl List {
fn render_item(&self, item: &str, cx: &mut Context<Self>) -> impl IntoElement + use<> {
    div().child(item.to_string())
}
# }
```

Elements can't hold borrows anyway, so this is always safe for a method that
builds elements: it copies or clones what it needs from its arguments.

## See also

- [Ownership and entities](crate::_documentation::concepts::ownership) explains
  handles, leases and weak handles.
- [Input and dispatch](crate::_documentation::concepts::input_dispatch) explains
  the path keystrokes and clicks take.
- [Testing](crate::_documentation::guides::testing) shows how to reproduce a
  symptom in a headless test.
