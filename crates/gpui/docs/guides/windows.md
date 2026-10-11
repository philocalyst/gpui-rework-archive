# Open and manage windows

A window is a platform surface with a root view. You open one with [`App::open_window`],
keep its [`WindowHandle`] to update it later, and react when it closes. This guide covers
the options that matter most, multiple windows, closing, the window state you can query,
and replacing the root view. Web builds differ in a few ways, which are listed at the end.

## Open a window with options

[`App::open_window`] takes a [`WindowOptions`] and a function that builds the root view. The
function receives the new [`Window`] and the [`App`]. It returns an `Entity<V>`,
and the call returns a [`WindowHandle<V>`] for that view. Start from
`WindowOptions::default()` and change only what you need.

```rust
use gpui::{
    AppContext, Bounds, Context, IntoElement, Render, TestApp, TitlebarOptions, Window,
    WindowBounds, WindowOptions, div, prelude::*, px, size,
};

struct Notes {
    text: String,
    dirty: bool,
}

impl Render for Notes {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child(self.text.clone())
    }
}

let mut app = TestApp::new();
let notes = app.update(|cx| {
    let bounds = Bounds::centered(None, size(px(480.), px(320.)), cx);
    cx.open_window(
        WindowOptions::default()
            .window_bounds(WindowBounds::Windowed(bounds))
            .titlebar(Some(TitlebarOptions {
                title: Some("Notes".into()),
                ..Default::default()
            }))
            .window_min_size(size(px(320.), px(200.))),
        |_window, cx| {
            cx.new(|_| Notes {
                text: "Hello".into(),
                dirty: false,
            })
        },
    )
    .unwrap()
});
```

These are the options you'll set most often:

* **`window_bounds`** takes a [`WindowBounds`]. `Windowed` opens at a rectangle in screen
  coordinates. [`Bounds::centered`] builds one centered on a display, or on the primary
  display when you pass `None`. `Maximized` and `Fullscreen` take the size to restore to
  when the user leaves that state. If you leave it unset, the window inherits its bounds.
* **`titlebar`** takes an optional [`TitlebarOptions`]. Its `title` sets the initial title,
  and `appears_transparent` hides the system titlebar so you can draw your own, on macOS
  and Windows. Pass `None` to remove the titlebar altogether.
* **`window_min_size`** stops the user from resizing below a size. Use `is_resizable` and
  `is_minimizable` to turn those capabilities off.
* **`kind`** takes a [`WindowKind`]. The default is `WindowKind::Normal`. `WindowKind::PopUp`
  stays above other windows, so use it sparingly. `WindowKind::AnchoredPopup` places a
  native menu or tooltip relative to a parent window.
* **`focus`** and **`show`** control whether the window takes focus and appears when it
  opens. Set `show(false)` to create a window that you show later.

## Keep a handle and update the window later

The [`WindowHandle`] returned by `open_window` is a typed reference to the window. It
doesn't keep the window open. Call [`WindowHandle::update`] to run code with the root view,
the window and a context. It returns a `Result` that fails once the window is closed or
if its root view has a different type. Use [`WindowHandle::read`] to look at the root
view without changing it.

```rust
# use gpui::{AppContext, Context, IntoElement, Render, TestApp, Window, WindowOptions, div, prelude::*};
# struct Notes {
#     text: String,
#     dirty: bool,
# }
# impl Render for Notes {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
#         div().child(self.text.clone())
#     }
# }
# let mut app = TestApp::new();
# let notes = app.update(|cx| {
#     cx.open_window(WindowOptions::default(), |_window, cx| {
#         cx.new(|_| Notes { text: "Hello".into(), dirty: false })
#     })
#     .unwrap()
# });
app.update(|cx| {
    notes
        .update(cx, |notes, _window, cx| {
            notes.text = "Saved".into();
            notes.dirty = false;
            cx.notify();
        })
        .unwrap();
});

app.update(|cx| {
    let notes = notes.read(cx).unwrap();
    assert_eq!(notes.text, "Saved");
});
```

`WindowHandle` is `Copy`, so you can hold one in several places. Two handles compare equal
when they refer to the same window.

## Work with several windows

Open as many windows as you need by calling `open_window` again. [`App::windows`] lists
every open window as an [`AnyWindowHandle`], whatever its root view type. To find a window
by its view type, call [`AnyWindowHandle::downcast`]. [`App::active_window`] returns the
window that has focus, if one does.

```rust
# use gpui::{AppContext, Context, IntoElement, Render, TestApp, Window, WindowOptions, div, prelude::*};
# struct Notes {
#     text: String,
#     dirty: bool,
# }
# impl Render for Notes {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
#         div().child(self.text.clone())
#     }
# }
# let mut app = TestApp::new();
# let _notes = app.update(|cx| {
#     cx.open_window(WindowOptions::default(), |_window, cx| {
#         cx.new(|_| Notes { text: "Hello".into(), dirty: false })
#     })
#     .unwrap()
# });
app.update(|cx| {
    cx.open_window(WindowOptions::default(), |_window, cx| {
        cx.new(|_| Notes {
            text: "Second".into(),
            dirty: false,
        })
    })
    .unwrap();
});

app.update(|cx| assert_eq!(cx.windows().len(), 2));
```

## Close a window and react to it

Call [`Window::remove_window`] to close the window the call is made from. It marks the window
for removal, and GPUI removes it when the current update finishes. To close another window,
update its handle and call `remove_window` on the window you're given. Subscribe to
[`App::on_window_closed`] to learn about any window closing, including ones you didn't open.
The callback receives the window's id after the window is gone.

```rust
# use gpui::{AppContext, Context, IntoElement, Render, TestApp, Window, WindowOptions, div, prelude::*};
# struct Notes {
#     text: String,
#     dirty: bool,
# }
# impl Render for Notes {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
#         div().child(self.text.clone())
#     }
# }
# let mut app = TestApp::new();
# let _notes = app.update(|cx| {
#     cx.open_window(WindowOptions::default(), |_window, cx| {
#         cx.new(|_| Notes { text: "Hello".into(), dirty: false })
#     })
#     .unwrap()
# });
use std::{cell::Cell, rc::Rc};

let second = app.update(|cx| {
    cx.open_window(WindowOptions::default(), |_window, cx| {
        cx.new(|_| Notes { text: "Second".into(), dirty: false })
    })
    .unwrap()
});

let closed = Rc::new(Cell::new(0));
app.update(|cx| {
    let closed = closed.clone();
    cx.on_window_closed(move |_cx, _window_id| closed.set(closed.get() + 1))
        .detach();
});

app.update(|cx| {
    second
        .update(cx, |_notes, window, _cx| window.remove_window())
        .unwrap();
});

app.update(|cx| {
    assert_eq!(cx.windows().len(), 1);
    assert_eq!(closed.get(), 1);
});
```

Closing from the title bar is different. The platform asks the window whether it may close.
Register a check with [`Window::on_window_should_close`]. It runs before the window closes,
and returning `false` keeps the window open. A common use is asking the user before
discarding unsaved changes. Read the state through a weak handle, because the callback
outlives the current update:

```rust
# use gpui::{AppContext, Context, IntoElement, Render, TestApp, Window, WindowOptions, div, prelude::*};
# struct Notes {
#     text: String,
#     dirty: bool,
# }
# impl Render for Notes {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
#         div().child(self.text.clone())
#     }
# }
# let mut app = TestApp::new();
# let notes = app.update(|cx| {
#     cx.open_window(WindowOptions::default(), |_window, cx| {
#         cx.new(|_| Notes { text: "Hello".into(), dirty: true })
#     })
#     .unwrap()
# });
app.update(|cx| {
    notes
        .update(cx, |_notes, window, cx| {
            let view = cx.entity().downgrade();
            window.on_window_should_close(cx, move |_window, cx| {
                view.upgrade().map_or(true, |notes| !notes.read(cx).dirty)
            });
        })
        .unwrap();
});
```

### Quit when the last window closes

What happens when the last window closes depends on [`QuitMode`]. `QuitMode::Default`
quits when the last window closes everywhere except macOS, where the app keeps running
until the user quits it. `QuitMode::LastWindowClosed` always quits when the last window
closes. `QuitMode::Explicit` quits only when you call [`App::quit`]. Set the mode on the
application builder, as in this example, or with [`App::set_quit_mode`].

```rust,no_run
use gpui::{App, Context, IntoElement, QuitMode, Render, Window, WindowOptions, div, prelude::*};

struct Notes;

impl Render for Notes {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child("Notes")
    }
}

fn main() {
    gpui_platform::application()
        .with_quit_mode(QuitMode::LastWindowClosed)
        .run(run);
}

fn run(cx: &mut App) {
    cx.open_window(WindowOptions::default(), |_window, cx| cx.new(|_| Notes))
        .unwrap();
    cx.activate(true);
}
```

## Query the window's state

A [`Window`] reports what it's doing right now. These methods are the ones you'll use most.
Read them during render or inside a window update:

* [`Window::bounds`] is the window's rectangle in screen coordinates. It can span displays.
* [`Window::viewport_size`] is the drawable area, which excludes the titlebar. Lay out your
  content from this size.
* [`Window::scale_factor`] is the number of device pixels per logical pixel. It's `2.0` on
  many high-density displays.
* [`Window::is_window_active`] tells you whether the window has focus.
* [`Window::window_bounds`], [`Window::is_maximized`] and [`Window::is_fullscreen`] report
  its state. Use [`Window::toggle_fullscreen`], [`Window::zoom_window`] and
  [`Window::minimize_window`] to change it.

```rust
# use gpui::{AppContext, Context, IntoElement, Render, TestApp, Window, WindowOptions, div, prelude::*};
# struct Notes {
#     text: String,
#     dirty: bool,
# }
# impl Render for Notes {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
#         div().child(self.text.clone())
#     }
# }
# let mut app = TestApp::new();
# let notes = app.update(|cx| {
#     cx.open_window(WindowOptions::default(), |_window, cx| {
#         cx.new(|_| Notes { text: "Hello".into(), dirty: false })
#     })
#     .unwrap()
# });
app.update(|cx| {
    notes
        .update(cx, |_notes, window, _cx| {
            assert!(window.scale_factor() > 0.0);
            let _content_size = window.viewport_size();
            let _focused = window.is_window_active();
        })
        .unwrap();
});
```

## Replace the root view

[`Window::replace_root`] swaps the window's root view for a new one and redraws the window.
The old view is released if nothing else holds it. The new view can have a different type.
After you replace it, a [`WindowHandle`] typed to the old view no longer matches, so
[`WindowHandle::update`] and [`WindowHandle::read`] fail. Keep an [`AnyWindowHandle`]
instead when you expect to replace the root.

```rust
# use gpui::{AppContext, Context, IntoElement, Render, TestApp, Window, WindowOptions, div, prelude::*};
# struct Notes {
#     text: String,
#     dirty: bool,
# }
# impl Render for Notes {
#     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
#         div().child(self.text.clone())
#     }
# }
# let mut app = TestApp::new();
# let notes = app.update(|cx| {
#     cx.open_window(WindowOptions::default(), |_window, cx| {
#         cx.new(|_| Notes { text: "Hello".into(), dirty: false })
#     })
#     .unwrap()
# });
struct Settings;

impl Render for Settings {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child("Settings")
    }
}

app.update(|cx| {
    notes
        .update(cx, |_notes, window, cx| {
            window.replace_root(cx, |_window, _cx| Settings);
        })
        .unwrap();
});

app.read(|cx| assert!(notes.read(cx).is_err()));
```

## Web differences

On the web, GPUI has one window: the page's canvas. These differences apply to
`gpui_web` builds:

* `App::open_window` supports one top-level window. A second call returns an error, and
  reopening a window after it closes isn't supported.
* Only `WindowKind::Normal` works. `PopUp`, `AnchoredPopup`, `Floating` and dialog windows
  return an error.
* The window fills the page. Of the `WindowOptions` fields, only `kind` and `show` are
  read, so `window_bounds`, `titlebar`, `window_min_size` and the resize options have no
  effect.
* `Window::minimize_window` and `Window::zoom_window` log a warning and do nothing.
  `App::quit` logs a warning and does nothing.

Write window code so that it works with one window, and check the result of every
`open_window` call.

## See also

- [Windows example](crate::_documentation::examples::windows), which opens windows with
  different options and closes them from a list.
- [Share state between views](crate::_documentation::guides::sharing_state), for observing
  state that several windows show.
- [Run work in the background](crate::_documentation::guides::async_work), for working
  with a window from async code.
- [Contexts](crate::_documentation::concepts::contexts), for `Window`, `App` and
  `Context<T>`.
