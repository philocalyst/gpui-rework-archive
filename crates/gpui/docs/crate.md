GPUI is a GPU-accelerated UI framework for Rust. You describe your interface
with flexbox-style elements and Tailwind-style methods, keep your state in
handles that GPUI owns for you, and GPUI turns it into pixels at the refresh
rate of your display, on macOS, Windows, Linux and the web.

GPUI was built by [Zed Industries](https://zed.dev) to make the Zed editor.
This crate is GPUI Community Edition (GPUI-CE), a fork maintained for
applications of every size. It is published as `gpui-ce` and imported as `gpui`.

Here is a complete program. It opens a window with a button that counts its
clicks:

```no_run
use gpui::{App, Context, Window, WindowOptions, div, prelude::*, rgb};

struct Counter {
    count: usize,
}

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .bg(rgb(0xf5f5f4))
            .child(
                div()
                    .id("button")
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x2563eb))
                    .text_color(rgb(0xffffff))
                    .cursor_pointer()
                    .child(format!("Clicked {} times", self.count))
                    .on_click(cx.listener(|counter, _event, _window, cx| {
                        counter.count += 1;
                        cx.notify();
                    })),
            )
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        cx.open_window(WindowOptions::default(), |_window, cx| {
            cx.new(|_cx| Counter { count: 0 })
        })
        .unwrap();
        cx.activate(true);
    });
}
```

The same view runs without a window in tests. [`TestApp`] drives it with
simulated input, so you can check behavior instead of pixels:

```
# use gpui::{Context, Window, div, prelude::*};
# struct Counter { count: usize }
# impl Render for Counter {
#     fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
#         div().id("button").size_full().on_click(cx.listener(|counter, _, _, cx| {
#             counter.count += 1;
#             cx.notify();
#         }))
#     }
# }
use gpui::{MouseButton, TestApp, point, px};

let mut app = TestApp::new();
let mut window = app.open_window(|_window, _cx| Counter { count: 0 });

window.simulate_click(point(px(10.), px(10.)), MouseButton::Left);
window.simulate_click(point(px(10.), px(10.)), MouseButton::Left);

assert_eq!(window.read(|counter, _cx| counter.count), 2);
```

# Overview

A GPUI program is a tree of *views* that render *elements*, driven by state
that GPUI owns on your behalf.

* **[`App`] owns your state.** You don't keep application state in local
  variables or `Rc<RefCell<_>>`. You hand it to GPUI with [`App::new`] and get
  back an [`Entity<T>`]: a cheap, clonable handle you use to read and update
  the value. Because one owner sees every change, GPUI knows exactly what to
  redraw and can notify anyone who is watching.
* **A view is an entity that can [`Render`].** Each frame, GPUI asks the views
  that changed for a fresh tree of elements. A view keeps its state between
  frames; the elements it returns are thrown away after they're drawn.
* **Elements describe the interface.** [`div`] is the workhorse: a box with
  children, styles and event handlers. Text, [`img`], [`svg`],
  [`uniform_list`] and [`canvas`] cover the rest, and you can write your own by
  implementing [`Element`]. Style them with [`Styled`] methods named after
  Tailwind CSS classes, such as `.flex()`, `.p_4()` and `.rounded_md()`, and
  GPUI lays them out with flexbox and grid.
* **Contexts give you access.** Every callback receives the contexts it needs:
  [`App`] for application-wide services, [`Context<T>`] while you work on one
  entity, and [`Window`] for the window being drawn or handling input.
* **You say when something changed.** Mutating an entity's fields doesn't
  redraw anything. Call [`Context::notify`] and GPUI re-renders the views that
  depend on that entity before the next frame.
* **Input flows to the right place.** Mouse events go to the element under
  the pointer. Key events go to the focused element. Key bindings turn
  keystrokes into typed [actions](Action) that bubble up the tree of focused
  elements until something handles them.

The [concepts](crate::_documentation::concepts) section explains each of these
ideas in depth.

# Getting started

Add GPUI and its platform crate to `Cargo.toml`. The platform crate picks the
right windowing and rendering backends for the target you build for:

```toml
[dependencies]
gpui = { package = "gpui-ce", version = "0.2" }
gpui_platform = { package = "gpui_ce_platform", version = "0.1" }
```

Then follow the [tutorial](crate::_documentation::tutorial), which builds a
small, polished app one idea at a time. [Start a
project](crate::_documentation::guides::start_a_project) covers system
requirements for each platform.

The rest of this page is a map of GPUI:

* [How do I…](#how-do-i) answers common questions with short examples.
* [The API at a glance](#the-api-at-a-glance) groups the crate's items by
  what they're for.
* [Crate features](#crate-features) lists the optional parts of GPUI.
* [Documentation](#documentation) points to everything else.

# How do I…

Each answer is a starting point. Follow its link for the whole story.

### Respond to a click

Give the element an [`id`](InteractiveElement::id) so GPUI can track it
between frames, then register a handler. [`Context::listener`] gives the
handler mutable access to your view:

```
# use gpui::{Context, Window, div, prelude::*};
# struct Counter { count: usize }
# impl Render for Counter {
#     fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
div()
    .id("increment")
    .child("Add one")
    .on_click(cx.listener(|counter, _event, _window, cx| {
        counter.count += 1;
        cx.notify();
    }))
#     }
# }
```

See [mouse and touch input](crate::_documentation::guides::mouse_and_touch).

### Bind a keyboard shortcut

Declare an [action](Action), bind a keystroke to it, and handle it on an
element that has focus or contains the focused element:

```standalone_crate
use gpui::{App, KeyBinding, actions};

actions!(editor, [Save]);

fn bind_keys(cx: &mut App) {
    cx.bind_keys([KeyBinding::new("cmd-s", Save, Some("Editor"))]);
}
```

```standalone_crate
# use gpui::{Context, FocusHandle, Window, actions, div, prelude::*};
# actions!(editor, [Save]);
# struct Editor { focus_handle: FocusHandle }
# impl Editor { fn save(&mut self, _: &Save, _: &mut Window, _: &mut Context<Self>) {} }
# impl Render for Editor {
#     fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
div()
    .key_context("Editor")
    .track_focus(&self.focus_handle)
    .on_action(cx.listener(Editor::save))
#     }
# }
```

See [keyboard input](crate::_documentation::guides::keyboard).

### Run work without freezing the window

[`Context::spawn`] runs async code on the main thread, where it can update
entities. Move expensive work to a thread pool with
[`background_spawn`](AppContext::background_spawn) and await the result:

```
# use gpui::{AppContext, Context, Task};
# struct Report { summary: Option<String>, task: Option<Task<()>> }
# fn summarize(text: &str) -> String { text.to_uppercase() }
impl Report {
    fn refresh(&mut self, text: String, cx: &mut Context<Self>) {
        self.task = Some(cx.spawn(async move |this, cx| {
            let summary = cx.background_spawn(async move { summarize(&text) }).await;
            this.update(cx, |report, cx| {
                report.summary = Some(summary);
                cx.notify();
            })
            .ok();
        }));
    }
}
```

Dropping a [`Task`] cancels it, so storing it in the view ties the work's
lifetime to the view's. See [async work](crate::_documentation::guides::async_work).

### Show a list of ten thousand rows

[`uniform_list`] renders only the rows that are visible, so its cost depends
on the height of the window, not the length of the list:

```
# use gpui::{Context, Window, div, prelude::*, px, uniform_list};
# struct Log { lines: Vec<String> }
# impl Render for Log {
#     fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
uniform_list(
    "log",
    self.lines.len(),
    cx.processor(|log, range: std::ops::Range<usize>, _window, _cx| {
        range
            .map(|index| div().h(px(20.)).child(log.lines[index].clone()))
            .collect::<Vec<_>>()
    }),
)
.h_full()
#     }
# }
```

See [lists and scrolling](crate::_documentation::guides::lists_and_scrolling).

### Animate a change

Wrap any element with [`with_animation`](AnimationExt::with_animation). The
closure receives the eased progress, from `0.0` to `1.0`, and returns the
element as it should look at that point:

```
# use gpui::{IntoElement, div, prelude::*};
use gpui::{Animation, AnimationExt, ease_in_out, millis};

# fn fade_in() -> impl IntoElement {
div()
    .child("Saved")
    .with_animation(
        "fade-in",
        Animation::new(millis(300)).with_easing(ease_in_out),
        |element, progress| element.opacity(progress),
    )
# }
```

See [animation](crate::_documentation::guides::animation).

### Draw a custom shape

[`canvas`] gives you a callback with the element's bounds and direct access
to the window's paint methods:

```
# use gpui::{IntoElement, canvas, fill, prelude::*, px, rgb};
# fn swatch() -> impl IntoElement {
canvas(
    |_bounds, _window, _cx| {},
    |bounds, _state, window, _cx| {
        window.paint_quad(fill(bounds, rgb(0x2563eb)));
    },
)
.size(px(64.))
# }
```

See [custom drawing](crate::_documentation::guides::custom_drawing).

# The API at a glance

GPUI's items are all exported from the crate root. These tables group them by
purpose.

**Applications and windows**

| Item | Purpose |
| --- | --- |
| [`Application`] | Starts the event loop. Get one from `gpui_platform::application()`. |
| [`App`] | The application context: windows, globals, key bindings, platform services. |
| [`Window`], [`WindowOptions`] | One window: its size, focus, input and drawing. |
| [`WindowHandle`], [`AnyWindowHandle`] | Refer to a window from outside it. |

**State**

| Item | Purpose |
| --- | --- |
| [`Entity`], [`WeakEntity`] | Handles to state owned by the app. |
| [`Context`] | Access to one entity while you update it. |
| [`AppContext`] | The operations every context supports: create, read and update entities. |
| [`EventEmitter`], [`Subscription`] | Typed events between entities. |
| [`Global`] | Application-wide singletons such as settings. |

**Views and elements**

| Item | Purpose |
| --- | --- |
| [`Render`] | A stateful view: an entity that renders elements. |
| [`RenderOnce`], [`IntoElement`] | A stateless component, built and consumed in one frame. |
| [`div`], [`Div`] | The general-purpose container element. |
| [`StyledText`], [`img`], [`svg`], [`canvas`] | Text runs, images, vector icons, custom painting. |
| [`uniform_list`], [`list`] | Virtualized lists of equal or varying row heights. |
| [`anchored`], [`deferred`] | Popovers and overlays that escape their parent. |
| [`Element`], [`AnyElement`] | The low-level element protocol, for custom layout and painting. |

**Style and layout**

| Item | Purpose |
| --- | --- |
| [`Styled`] | Tailwind-style builder methods for layout, color, borders, shadows and text. |
| [`Style`], [`StyleRefinement`] | The full style, and a partial one that overrides it. |
| [`px`], [`rems`], [`relative`] | Lengths in logical pixels, root ems and fractions. |
| [`Hsla`], [`Rgba`], [`rgb`], [`hsla`] | Colors. |
| [`Bounds`], [`Point`], [`Size`], [`Pixels`] | Geometry. |

**Input**

| Item | Purpose |
| --- | --- |
| [`InteractiveElement`], [`StatefulInteractiveElement`] | Mouse, keyboard, focus, hover and drag handlers on elements. |
| [`FocusHandle`], [`Focusable`] | Keyboard focus. |
| [`Action`], [`actions!`], [`KeyBinding`] | Keystrokes mapped to typed commands. |
| [`ClickEvent`], [`MouseDownEvent`], [`KeyDownEvent`], … | The events your handlers receive. |

**Motion**

| Item | Purpose |
| --- | --- |
| [`Animation`], [`AnimationExt`] | Animate an element over time. |
| [`StyleTransitions`] | Animate style changes such as hover colors. |
| [`Transition`], [`SpringConfig`] | Animate values toward a moving target. |

**Async and time**

| Item | Purpose |
| --- | --- |
| [`Task`] | A handle to running async work; dropping it cancels the work. |
| [`AsyncApp`], [`AsyncWindowContext`] | Contexts you can hold across `.await`. |
| [`BackgroundExecutor`], [`ForegroundExecutor`] | Spawn work on a thread pool or the main thread. |

**Testing**

| Item | Purpose |
| --- | --- |
| [`TestApp`] | A headless app for driving views with simulated input. |
| [`TestAppContext`], [`#[gpui::test]`](test) | Async tests with a deterministic scheduler. |

# Crate features

| Feature | Default | Effect |
| --- | --- | --- |
| `wayland`, `x11` | yes | Include the Wayland and X11 code paths on Linux and FreeBSD. |
| `font-kit` | yes | Use font-kit for font discovery on macOS. |
| `windows-manifest` | yes | Embed an application manifest in Windows executables. |
| `test-support` | no | [`TestApp`], [`TestAppContext`] and other testing tools. |
| `inspector` | no | The element inspector, for debugging layout in a running app. |
| `profiler` | no | Frame, input-latency and task profiling, with an on-screen overlay. |
| `hot-patching` | no | Patch render code into a running app with Dioxus' `dx`. See [hot reload](crate::_documentation::guides::hot_reload). |
| `embedded-assets` | no | Embed an asset directory in the binary with `rust-embed`. |
| `leak-detection` | no | Report entity handles that outlive their app, with backtraces. |
| `screen-capture` | no | Capture screen contents as a surface on Windows. |
| `custom-gpu` | no | Draw into a window with your own `wgpu` code. |
| `stacker` | no | Grow the stack on demand for very deep element trees. |
| `bench-support` | no | Helpers for Criterion benchmarks of GPUI code. |

# Documentation

* The [tutorial](crate::_documentation::tutorial) builds a complete app.
* The [guides](crate::_documentation::guides) solve specific problems.
* The [concepts](crate::_documentation::concepts) explain how GPUI works.
* The [examples](crate::_documentation::examples) are complete programs you
  can run, many of them live in your browser.
* [Design](crate::_documentation::design) explains why GPUI is the way it is,
  [comparison](crate::_documentation::comparison) weighs it against other Rust
  toolkits, [platforms](crate::_documentation::platforms) describes what runs
  where, and [upstream](crate::_documentation::upstream) lists the differences
  from Zed's GPUI.
