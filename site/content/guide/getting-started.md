+++
title = "Getting started"
description = "Install the platform dependencies, add the crates, and open your first GPUI window."
weight = 2
aliases = ["/getting-started.html"]
[extra]
category = "GETTING STARTED"
legacy_source = "gpui-ce-docs/build/html/getting-started.html"
+++

**gpui-ce** is a GPU-accelerated GUI framework for Rust. You describe UI in code, and GPUI turns it into pixels every frame. Start here when you want a running window today, then follow the mental-model page and the two tutorials below.

## Prerequisites

Install Rust first with rustup. Then install the system libraries for your OS.

macOS renders through Metal. Install Xcode from the App Store or the Apple Developer site. Launch Xcode once and accept the default macOS components. Then point the command line tools at your Xcode copy:

```sh
# Install the compiler toolchain Xcode needs for Metal builds.
xcode-select --install
# Point the tools at Xcode itself, not the standalone CLT package.
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

Linux needs Wayland/X11, Vulkan, audio, and font libraries, plus C build tools. The Nix closure names them all: `alsa-lib`, `libdrm`, `mesa`, `libxkbcommon`, `libva`, `vulkan-loader`, `wayland`, `xorg.libX11`, `xorg.libxcb`, with `cmake`, `pkg-config`, `fontconfig`, `freetype`, `openssl`, and `zlib` on top (`flake.nix:53`, `flake.nix:71`).

> **Warning.** Install the matching development packages with your distro package manager. Library names differ per distro, so match the names above rather than copying a stranger’s `apt` line.

On Windows, install the normal Rust MSVC toolchain. The backend crates arrive through Cargo, no extra SDK step.

## Add the crates

The package is `gpui-ce`, and its library name is `gpui` (`crates/gpui/Cargo.toml:2`, `crates/gpui/Cargo.toml:44`):

```sh
# Adds gpui-ce to [dependencies] and fetches the framework.
cargo add gpui-ce
```

The platform bootstrap (`application()`) lives in a second package, `gpui_ce_platform`. This repo refers to it as `gpui_platform`, so add it under that name:

```toml
# Main framework plus the OS bootstrap crate, aliased to gpui_platform.
[dependencies]
gpui-ce = "0.2.2"
gpui_platform = { package = "gpui_ce_platform", version = "0.1.0" }
```

Then import the prelude in every UI file. It carries `Render`, `Styled`, `InteractiveElement`, `Element`, and the other traits you reach for constantly ([crates/gpui/src/prelude.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/prelude.rs)):

```rust
// One import covers the rendering traits behind every page in this track.
use gpui::prelude::*;
```

> **Tip.** One prelude import per UI file keeps you sane. If a builder method like `.flex()` goes missing, the prelude import is the first suspect.

## Minimal skeleton

This is the smallest complete program. It opens one window with one root view:

```rust
// Full file: src/main.rs. Every line below earns its place.
use gpui::{App, Context, IntoElement, Render, Window, WindowOptions, div, prelude::*};
use gpui_platform::application; // zero-cfg bootstrap: picks your OS backend

struct Hello; // unit struct: this view holds no state yet

impl Render for Hello {
    // GPUI calls render at the start of each frame; read state, return boxes.
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().child("Hello from gpui-ce") // one box, one line of text
    }
}

fn main() {
    // application() builds the right backend; run() fires the closure once at launch.
    application().run(|cx: &mut App| {
        // Build the window, install Hello as its root view, keep the handle.
        cx.open_window(WindowOptions::default(), |_, cx| cx.new(|_| Hello))
            .unwrap(); // open_window returns Result: a window can fail (no display, no GPU)
        cx.activate(true); // bring the app forward so the window is visible
    });
}
```

Run it with `cargo run`. One window appears with one line of text.

> **Note.** Your `run` closure takes `FnOnce(&mut App)` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). It fires exactly once, when the app finishes launching. Anything you want alive for the whole session — windows, global entities — starts here. Embedders that own their own run loop use `run_embedded` instead, which hands back an `ApplicationHandle` rather than blocking.

## What you get

|  |  |
| --- | --- |
| **Line** | **What it does** |
| `application()` | Builds an `Application` on the right backend, no `cfg` in your code. |
| `.run(\|cx\| ...)` | Starts the event loop, then calls your closure once at launch. |
| `cx.open_window(...)` | Creates a window, installs the root view, draws one frame before returning. |
| `cx.new(\|_\| Hello)` | Moves your state into GPUI ownership and hands you an `Entity<Hello>`. |
| `render(...)` | Rebuilds the element tree from current state at the start of each frame. |
| `cx.activate(true)` | Brings the app forward; `true` steals focus from other apps. |

Table 13: Every line of the skeleton, and the job each line does.

Two subtleties hide in that table. First, `open_window` draws a frame synchronously before it returns, so the handle you get back already points at a painted window. Second, `WindowOptions::default()` already sets `focus: true` and `show: true` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)), so a bare default window appears immediately. You only touch those fields when you want a hidden or background window.

Headless tests skip all of this. `gpui_platform::headless()` builds the same `Application` on a stub platform ([crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)), which is how the `gpui::test` harness opens windows without a screen.

## Next steps

Read the mental-model page for the three registers (`Entity`, View, Element). Follow first-app for a line-by-line window build. Finish with counter-tutorial, which adds state and clicks.

> **Note.** Stuck on shortcuts later? Actions turn keystrokes like `cmd-Q` into logical operations. That story lives outside this track, but the keymap pages pick it up.

## Sources

- Quickstart shape (`Application::run`, `App::open_window`): `README.md:17`, [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs), [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- `run_embedded` for embedders: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- Install command: `README.md:21`; macOS Xcode/Metal steps: `README.md:56-74`
- Linux system libraries and build tools: `flake.nix:53`, `flake.nix:71`
- Crate and library names: `crates/gpui/Cargo.toml:2`, `crates/gpui/Cargo.toml:44`, `crates/gpui_platform/Cargo.toml:3`
- `gpui_platform::application`, `headless`, `current_platform`: [crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs), [crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs), [crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)
- `Render::render`: [crates/gpui/src/element.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/element.rs); `AppContext::new` (`cx.new`): [crates/gpui/src/gpui.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/gpui.rs)
- `WindowOptions::default` (`focus`, `show`): [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs); `App::activate`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)
- Prelude contents: [crates/gpui/src/prelude.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/prelude.rs); `div()`: [crates/gpui/src/elements/div.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/div.rs)
- Skeleton pattern (`open_window` + `cx.new` + `activate`): `crates/gpui/examples/legacy/hello_world.rs:96-114`
