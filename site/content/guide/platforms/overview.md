+++
title = "Platforms: overview"
description = "Find the boundary between your application, GPUI, and the operating system beneath it."
weight = 35
aliases = ["/platforms/overview.html"]
[extra]
category = "PLATFORMS"
legacy_source = "gpui-ce-docs/build/html/platforms/overview.html"
+++

Come sit with us — your app code stays put while GPUI-CE handles every OS quirk underneath. **One trait** picks the right native backend for you, so you write a window once and run it on macOS, Linux, Windows, and the web.

## The one idea: `Platform` is a contract

**`Platform`** is the trait that hides OS differences behind one stable surface. It covers executors, text, windows, displays, URLs, file prompts, and quit hooks ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). Its siblings live right beside it:

- `PlatformWindow` (`platform.rs:864`) — one native window: sizing, handles, appearance.
- `PlatformHeadlessRenderer` (`platform.rs:1072`) — offscreen drawing for tests.
- `PlatformDispatcher` (`platform.rs:1108`) — foreground and background task dispatch.
- `PlatformTextSystem` (`platform.rs:1151`) — font shaping and measurement.
- `PlatformAtlas` (`platform.rs:1419`) — the shared glyph and image atlas.

You never pick an implementation by hand, friend. Call `gpui_platform::application()` ([crates/gpui_platform/src/gpui_platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui_platform/src/gpui_platform.rs)) and `current_platform(headless)` (`gpui_platform.rs:57`) chooses with `#[cfg]`:

- macOS → `MacPlatform::new(headless)` (`gpui_platform.rs:60`)
- Windows → `WindowsPlatform::new(headless)` (`gpui_platform.rs:66`)
- Linux/FreeBSD → `gpui_linux::current_platform(headless)` (`gpui_platform.rs:73`)
- WASM → `WebPlatform::new(true)` (`gpui_platform.rs:79`)

Headless mode (`gpui_platform::headless()`, `gpui_platform.rs:23`) hands you an `Application` with no windows at all. That is your testing superpower — pair it with `#[gpui::test]` suites ([crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)).

```rust
use gpui_platform::application;

fn main() {
    // application() sniffs the OS for you — no #[cfg] in your code, ever.
    let app = application();
    app.run(|cx| {
        // Default options open a plain window; your view renders inside it.
        cx.open_window(Default::default(), |_, cx| {
            // cx.new() plants your root state into the entity tree.
            cx.new(|_| RootView)
        }).expect("open window");
    });
}
```

> **Pitfall.** `current_headless_renderer()` (`gpui_platform.rs:85`) returns `Some` on macOS (`MetalHeadlessRenderer`) and `None` everywhere else. Gate your visual snapshot tests on that, or CI goes red on Linux and Windows while passing on your Mac.

## Per-OS matrix

“Verified” below means the file sits in this repo and names that symbol. Anything else we hedge as varying by platform/version — honest docs beat confident docs.

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| **Target** | **Crate** | **Windowing** | **Renderer** | **Notes** |
| macOS | `gpui_macos` + `gpui_apple` | AppKit / NSWindow — `gpui_macos/src/window.rs` | Metal — `gpui_apple/src/metal_renderer.rs`, `shaders.metal` | Needs Xcode + CLT (README FAQ). `set_window_appearance` truly works here; a no-op elsewhere (`platform.rs:192`). |
| Linux | `gpui_linux` | Wayland or X11 — `linux/wayland/`, `linux/x11/`, picked by `guess_compositor()` in `platform.rs:98` | wgpu over Vulkan/GL (see backends page) | Both compositors ship in one binary. Portal calls live in `linux/platform.rs` + `linux.rs`; exact dialog looks vary by platform/version. |
| Windows | `gpui_windows` | Win32 — `windows/src/platform.rs`, `window.rs` | DirectX — `directx_renderer.rs`, `directx_devices.rs`, `direct_write.rs`, `shaders.hlsl` | Plus `direct_manipulation.rs`, `system_notifications.rs`. Exact DirectX/DirectWrite path varies by platform/version — read `directx_devices.rs` first. |
| Web / WASM | `gpui_web` | Canvas + DOM events — `web/src/window.rs`, `events.rs`, `display.rs` | WebGPU or WebGL — `WebBackendPreference::{Auto, WebGpu, WebGl}` in `gpui_wgpu/src/wgpu_context.rs:29` | Enter via `web_init()` + `application_with_web_backend()` (`gpui_platform.rs:31,51`). IME mirror in `ime_mirror.rs`. |
| Any (tests) | core | Headless client | None except macOS Metal headless | `#[gpui::test]` + `TestAppContext`; offscreen windows via test helpers. |

Table 30: Every target, one row: where windows and pixels come from.

Input, clipboard, and IME follow the same friendly split: `keyboard.rs` per OS, `clipboard.rs` (Linux keeps X11 and Wayland variants side by side), `ime_mirror.rs` on web, and `pasteboard.rs` on mac (`gpui_macos/src/pasteboard.rs`). Accessibility travels through the `accesskit` family (see workspace `Cargo.toml`); exact screen-reader behavior varies by platform/version.

> **Tip.** On Linux, `guess_compositor()` (`platform.rs:98`) reads the session and returns `"Wayland"`, `"X11"`, or `"Headless"` — and `linux.rs:36-54` maps each string to `WaylandClient`, `X11Client`, or `HeadlessClient`. When a bug only bites one compositor, print that string first.

## Choose your target

|  |  |  |
| --- | --- | --- |
| **If you want…** | **Target** | **One-liner** |
| Ship a desktop app this week | Your dev OS | `cargo run` — no cfg, platform auto-selected. |
| Support both Linux compositors | Linux, both backends | Keep Wayland + X11 code paths on; test under each compositor. |
| Pixel-perfect macOS chrome | macOS | Use `set_window_appearance`; verified Metal path. |
| Run in a browser tab | WASM | `just check-wasm`; pick `WebBackendPreference::Auto` first. |
| Fast headless CI | Headless | `gpui_platform::headless()` + `#[gpui::test]`. |

Table 31: Pick a goal, grab its row, go build.

```sh
# just wraps the exact cargo lines — start here, peek inside later.
just check              # workspace check (native target)
just check-wasm         # wasm32-unknown-unknown, stable (needs target installed)
just check-examples     # examples + gpui_ce_web on wasm
just build-linux        # -p gpui_ce_linux
just build-mac          # -p gpui_ce_macos
just build-windows      # -p gpui_ce_windows
```

> **Note.** New to GPU backends? Wander over to `platforms-backends` next — it traces one frame from your `render` all the way to pixels, per OS.

## Sources

- `Platform` trait: [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)
- `PlatformWindow`: `platform.rs:864`; headless renderer: `platform.rs:1072`; dispatcher: `platform.rs:1108`; text system: `platform.rs:1151`; atlas: `platform.rs:1419`
- `set_window_appearance` no-op default: `platform.rs:192`; appearance query: `platform.rs:182`
- `guess_compositor`: `platform.rs:98`; Linux mapping: `crates/gpui_linux/src/linux.rs:36-54`
- Entry points: `crates/gpui_platform/src/gpui_platform.rs:13,23,31,51,57,60,66,73,79,85`
- Test context: [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)
