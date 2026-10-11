# 1. Hello, window

In this chapter you create a project, open a window, and show a title in it.

## Create the project

Make a new binary crate and add GPUI to it:

```sh
cargo new todos
cd todos
```

```toml
[dependencies]
gpui = { package = "gpui-ce", version = "0.2" }
gpui_platform = { package = "gpui_ce_platform", version = "0.1" }
```

`gpui` is the framework. `gpui_platform` connects it to the operating system you
build for: macOS, Windows, Linux or a web browser. The package names say
`gpui-ce` because this is GPUI Community Edition, but in your code the crate is
called `gpui`.

## Write the app

Replace `src/main.rs` with this:

```no_run
use gpui::{App, Context, QuitMode, Window, WindowOptions, colors::Colors, div, prelude::*};

struct Todos;

impl Render for Todos {
    fn render(&mut self, window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);

        div()
            .size_full()
            .p_8()
            .bg(colors.background)
            .text_color(colors.text)
            .text_3xl()
            .child("Todos")
    }
}

fn main() {
    gpui_platform::application()
        .with_quit_mode(QuitMode::LastWindowClosed)
        .run(|cx: &mut App| {
            cx.open_window(WindowOptions::default(), |_window, cx| {
                cx.new(|_cx| Todos)
            })
            .unwrap();
            cx.activate(true);
        });
}
```

Run it with `cargo run`. A window opens with "Todos" in large type. Close it and
the program exits.

## What the code does

**`main` starts the application.** `gpui_platform::application()` creates an
[`Application`] for the platform you built for, and [`run`](Application::run)
starts its event loop. The closure runs once the platform is ready, and receives
an [`App`]: the object that owns everything in your program. `run` doesn't
return until the program quits. [`QuitMode::LastWindowClosed`] makes it quit
when its last window closes, which is how most apps behave on Windows and
Linux; on macOS, apps normally keep running until you quit them.

**`open_window` creates a window.** It takes [`WindowOptions`], which control
the window's size, title bar and more, and a closure that builds the window's
*root view*. [`activate`](App::activate) brings the app to the front.

**A view is a struct that can render.** `Todos` implements [`Render`]. GPUI
calls its `render` method whenever the window needs to be drawn, and `render`
returns a tree of *elements* describing what to show. Here the tree is a single
[`div`] containing some text.

**`cx.new` hands the view to GPUI.** The app owns your views and the rest of your
state. `cx.new(|_cx| Todos)` gives the app a `Todos` and returns an
[`Entity<Todos>`](Entity), a handle you use to reach it. You'll use entities a
lot; [ownership](crate::_documentation::concepts::ownership) explains why GPUI
works this way.

## Styling elements

Each method called on `div()` sets one style property:

* `size_full` makes the element fill its parent, here the whole window.
* `p_8` adds padding. The numbers follow the scale from Tailwind CSS, where each
  step is a quarter of a *rem*, the window's base font size of 16 pixels. So
  `p_8` is two rems, or 32 pixels.
* `bg` and `text_color` set the background and text colors. Text properties
  apply to all the text inside an element, including its children's.
* `text_3xl` sets a large font size.

The colors come from [`Colors::for_appearance`](colors::Colors::for_appearance),
which gives you a small palette matching the system's light or dark appearance.

The methods come from the [`Styled`] trait, which you imported with
`gpui::prelude::*`. [Layout and style](crate::_documentation::concepts::layout_and_style)
covers the whole system.

In the [next chapter](crate::_documentation::tutorial::ch2_state) you give the
view some todos, and make them respond to clicks.
