# GPUI Community Edition

GPUI is a fast, GPU-accelerated UI framework for Rust. You describe your
interface with flexbox-style elements and Tailwind-style methods, keep state in
handles that GPUI owns for you, and GPUI draws it at the refresh rate of your
display on macOS, Windows, Linux and the web.

GPUI was built by Zed Industries for the [Zed](https://zed.dev) editor. GPUI
Community Edition is a fork maintained for applications of every kind.

```rust,no_run
use gpui::{App, Context, Window, WindowOptions, div, prelude::*};

struct Hello;

impl Render for Hello {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().flex().items_center().justify_center().child("Hello, GPUI!")
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        cx.open_window(WindowOptions::default(), |_, cx| cx.new(|_| Hello)).unwrap();
    });
}
```

```toml
[dependencies]
gpui = { package = "gpui-ce", version = "0.2" }
gpui_platform = { package = "gpui_ce_platform", version = "0.1" }
```

## Learn

- [Documentation](https://docs.rs/gpui-ce): the API reference, with a
  [tutorial](https://docs.rs/gpui-ce/latest/gpui/_documentation/tutorial/index.html),
  [guides](https://docs.rs/gpui-ce/latest/gpui/_documentation/guides/index.html)
  and [concepts](https://docs.rs/gpui-ce/latest/gpui/_documentation/concepts/index.html).
- [Examples](https://github.com/gpui-ce/gpui-ce/tree/main/crates/gpui/examples),
  which also run live on [the GPUI-CE website](https://gpui-ce.github.io).
- [Discord](https://discord.gg/ENGHGjrYEn), for questions.

## Requirements

Rust 1.95 or newer. On macOS, Xcode and its command line tools; on Linux, a few
development packages for Wayland, X11 and fontconfig. The [setup
guide](https://github.com/gpui-ce/gpui-ce/blob/main/SETUP.md) has the details.

## License

Apache-2.0.
