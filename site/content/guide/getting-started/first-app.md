+++
title = "First app: window plus root view"
description = "Build a complete application one piece at a time: a project, a root view, and a window."
weight = 4
aliases = ["/getting-started/first-app.html"]
[extra]
category = "GETTING STARTED"
legacy_source = "gpui-ce-docs/build/html/getting-started/first-app.html"
+++

**First-app** is the guaranteed-success tutorial: one window, one root view, built line by line. You need Rust plus the system libraries from the getting-started page. Ten minutes from now you hold a running window you understand completely.

## Step 1: create the project

```sh
# Fresh binary crate; hello-gpui becomes your window's home.
cargo new hello-gpui
# Move inside: every command below runs from the crate root.
cd hello-gpui
```

## Step 2: add the dependencies

```sh
# Adds the framework to [dependencies]; the alias below still needs Cargo.toml.
cargo add gpui-ce
```

Then declare the platform bootstrap crate in `Cargo.toml`. This repo calls it `gpui_platform` (`crates/gpui_platform/Cargo.toml:3`):

```toml
# Framework plus OS bootstrap, aliased so code says gpui_platform::application.
[dependencies]
gpui-ce = "0.2.2"
gpui_platform = { package = "gpui_ce_platform", version = "0.1.0" }
```

> **Tip.** Check the versions after pasting. `gpui-ce` moves quickly, and a stale pin is the most common reason a fresh tutorial checkout fails to build.

## Step 3: define the root view

A **root view** is the `Entity` that a window draws first: a struct plus a `Render` impl. Put this in `src/main.rs`:

```rust
// Import rendering traits (the prelude) plus the pieces this view names.
use gpui::{Context, IntoElement, Render, Window, div, prelude::*};

// The struct holds state; tonight it holds one greeting word.
struct RootView {
    label: String,
}

impl Render for RootView {
    // Read self, return boxes. Render never mutates, never blocks.
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .flex() // lay children out with flexbox (taffy under the hood)
            .flex_col() // stack them vertically, not in a row
            .items_center() // center children along the cross axis
            .justify_center() // center children along the main axis
            .gap_3() // breathe between children
            .text_xl() // big text for the greeting
            .child(format!("Hello, {}!", self.label)) // build the string fresh each frame
    }
}
```

The struct holds state. The `render` method reads `self` and returns elements. Keep those two jobs separate and the mental-model page stays true.

## Step 4: open a window on launch

Extend `src/main.rs` with the entry point:

```rust
// App owns everything; WindowOptions tunes the new window; application picks the backend.
use gpui::{App, WindowOptions};
use gpui_platform::application;

fn main() {
    // run() fires this closure once, when the app finishes launching.
    application().run(|cx: &mut App| {
        // Build the window and install RootView as the thing it draws.
        cx.open_window(WindowOptions::default(), |_, cx| {
            // cx.new moves RootView into GPUI and returns Entity<RootView>.
            cx.new(|_| RootView {
                label: "World".to_string(), // owned String: the view must own its state
            })
        })
        .unwrap(); // open_window can fail (no display, no GPU), so it returns Result
        cx.activate(true); // bring the app forward so the window lands on top
    });
}
```

`application()` picks the platform backend ([crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)). `run` starts the event loop and invokes your closure once ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). `open_window` builds the window, and its inner closure must return an `Entity<RootView>`, which `cx.new` provides ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs), [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)).

> **Warning.** The inner closure receives `(&mut Window, &mut App)` and must return `Entity<V>`. Return the struct itself and the compiler rejects it. Wrap it with `cx.new` — that move into GPUI ownership is the whole point.

Two quiet details deserve daylight. `open_window` draws one frame synchronously before returning, so your window paints even before any `notify` fires. And `WindowOptions::default()` already sets `focus: true` and `show: true` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)), so the window appears immediately with no extra flags.

## Step 5: run it

```sh
# Build and launch; expect one centered greeting window.
cargo run
```

One window opens with centered greeting text. `cx.activate(true)` brings it forward on launch ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). If the window hides behind your terminal, that call is the first place to look.

## What just happened

|  |  |
| --- | --- |
| **Call** | **Effect** |
| `application()` | Selected your OS backend with zero `cfg` in your code. |
| `run(\|cx\| ...)` | Ran the closure once the app finished launching. |
| `open_window(opts, build)` | Created the window, ran `build`, installed its `Entity` as root, drew one frame. |
| `cx.new(build)` | Stored `RootView` inside GPUI and returned the owning `Entity`. |
| `render` each frame | Rebuilt the `div` tree from `self.label`. |

Table 15: The five calls that stand up your first window, and what each one owns.

Your next move is the counter-tutorial: same skeleton, plus mutable state and two clickable buttons. It reuses every line above and adds interaction.

## Sources

- Entry shape (`run`, `open_window`, `cx.new`, `activate`): `crates/gpui/examples/legacy/hello_world.rs:96-114`
- `gpui_platform::application`: [crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)
- `Application::run`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs); `App::open_window`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- `AppContext::new`: [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs); `Render::render`: [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs)
- `WindowOptions::default` (`focus`, `show`): [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs); `App::activate`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- `div()`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs); styling via `Styled` (in prelude): [crates/gpui/src/prelude.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/prelude.rs)
