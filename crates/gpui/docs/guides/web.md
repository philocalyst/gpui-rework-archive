# Run on the web

This guide builds a GPUI app for `wasm32-unknown-unknown`, serves it with Trunk,
and opens it in a browser tab. The code is the same as the native app: the
entry point is still `gpui_platform::application()`, and only the platform
behind it changes.

## Know what changes in the browser

- **One window, one canvas.** GPUI appends a single `<canvas>` to the page and
  draws the window into it. The window's size follows the browser viewport.
  Opening a second top-level window, or reopening one after it closes, fails
  with `WebWindowError`.
- **GPU rendering.** GPUI uses WebGPU when the browser has it, and falls back to
  WebGL2 otherwise. To force one, pass a `WebBackendPreference` to
  `gpui_platform::application_with_web_backend()`.
- **Fonts come from you.** Browsers don't expose system fonts, so add every font
  the app uses with [`TextSystem::add_fonts`].
- **No filesystem.** Embed assets in the binary with `include_bytes!`, or fetch
  them over HTTP. `gpui_platform::application()` installs a fetch-based
  [`HttpClient`](crate::http_client::HttpClient), so [`App::http_client`] works.
- **Background work.** [`BackgroundExecutor`] runs futures on Web Workers only
  when the browser provides `SharedArrayBuffer` and `Atomics`, which it does on
  cross-origin isolated pages. Without them, background work runs on the main
  thread, and a long computation freezes the page as it would on any other
  single-threaded app. See [executors and tasks](crate::_documentation::concepts::executors).
- **Platform services differ.** Some services work in the browser, some do
  nothing, and some return an error. The
  [platform services guide](crate::_documentation::guides::platform_services)
  lists them.

## Write the entry point

The browser runs `main` once the page loads. Call `gpui_platform::web_init` first
so panics show up in the browser console. Then load fonts in the
`application().run` callback, before you open a window:

```rust,no_run
use std::borrow::Cow;

use gpui::{App, Context, Window, WindowOptions, div, prelude::*};

struct Hello;

impl Render for Hello {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().size_full().flex().items_center().justify_center().child("Hello from the browser")
    }
}

/// Registers the fonts the app draws with. Pass the bytes of your font files.
fn load_fonts(cx: &mut App, fonts: Vec<Cow<'static, [u8]>>) {
    cx.text_system()
        .add_fonts(fonts)
        .expect("the bundled fonts are valid");
}

fn main() {
    #[cfg(target_family = "wasm")]
    gpui_platform::web_init();

    gpui_platform::application().run(|cx: &mut App| {
        // On the web, embed each font with `include_bytes!` and pass it here
        // as `Cow::Borrowed`. The list is empty in this example.
        load_fonts(cx, Vec::new());

        cx.open_window(WindowOptions::default(), |_window, cx| cx.new(|_cx| Hello))
            .unwrap();
        cx.activate(true);
    });
}
```

[`Application::run`] calls your closure only after the browser's graphics have
started. If they can't start, GPUI draws a message in the page instead, and your
closure never runs.

The `#[cfg(target_family = "wasm")]` attribute keeps `web_init` out of native
builds, so the same file still compiles for your desktop target.

## Add the page

Trunk builds the crate and writes the JavaScript glue that loads it. Create
`index.html` next to `Cargo.toml`. The `data-trunk` link tells Trunk which Rust
binary to build:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Hello GPUI</title>
    <link data-trunk rel="rust" />
    <style>
      html, body { margin: 0; height: 100%; overflow: hidden; }
      canvas { position: fixed; inset: 0; }
    </style>
  </head>
  <body></body>
</html>
```

GPUI appends the canvas to `<body>`, and the stylesheet pins it to the full
viewport with the page's scrolling turned off. If the crate has more than one
binary, add `data-bin="<name>"` to the link.

## Build and serve

Install the WebAssembly target and Trunk once:

```sh
rustup target add wasm32-unknown-unknown
cargo install trunk
```

Then, in the crate directory, start a development server:

```sh
trunk serve
```

Trunk rebuilds and reloads the page when you save a file. Open
`http://127.0.0.1:8080` to see the app. For a production build, run
`trunk build --release`, which writes the files to `dist/`.

The live examples on the [GPUI site](https://gpui-ce.github.io/) are built this
way. The player lives in
[`site/player`](https://github.com/gpui-ce/gpui-ce/tree/main/site/player). Its
`index.html` is the model for the page above, and it adds a loading message and
a dark-mode background.

## See also

- [Start a project](crate::_documentation::guides::start_a_project) covers the
  native setup.
- [Use platform services](crate::_documentation::guides::platform_services)
  lists what works in the browser.
- [Platforms](crate::_documentation::platforms) describes each target.
