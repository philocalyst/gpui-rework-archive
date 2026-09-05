+++
title = "Platforms: rendering backends"
description = "Understand the platform crates and rendering backends that carry an interface to the screen."
weight = 36
aliases = ["/platforms/backends.html"]
[extra]
category = "PLATFORMS"
legacy_source = "gpui-ce-docs/build/html/platforms/backends.html"
+++

One scene graph, several GPUs — and you, dear reader, never have to care which one is awake today. GPUI-CE draws through a shared wgpu core plus two legacy native renderers (Metal on macOS, DirectX on Windows). This page traces which path your pixels take, and where to look when they wander off.

## The shared core: `gpui_wgpu`

`crates/gpui_wgpu/src/` holds the portable renderer your frames flow through:

- `wgpu_context.rs` — device and adapter setup, the `WgpuBackend` enum (`wgpu_context.rs:22`: `BrowserWebGpu`, `Gl`, `Native(wgpu::Backend)`), `CompositorGpuHint` (`wgpu_context.rs:60`), and `WgpuDeviceRequirements` (`wgpu_context.rs:69`) — request extra features before opening windows.
- `wgpu_renderer.rs` — frame recording and batch submission.
- `wgpu_atlas.rs` — glyph and image atlas on top of wgpu textures.
- Shader sources (names verified by `ls`, all four live in `gpui_wgpu/src/`):

  - `shaders.wgsl`
  - `shaders_storage.wgsl`
  - `shaders_subpixel.wgsl`
  - `shaders_webgl.wgsl` (WebGL-restricted variant)

Backend selection is explicit in `wgpu_context.rs` — no magic, just match arms:

```rust
// On wasm (wgpu_context.rs:177-179) your WebBackendPreference drives this:
//   Auto   => BROWSER_WEBGPU | GL — try the fast path, fall back gracefully.
//   WebGpu => BROWSER_WEBGPU only — fail loudly if the browser lacks it.
//   WebGl  => GL only — the widest-compatible, slowest lane.
// On native Linux-ish paths (wgpu_context.rs:317):
//   backends = VULKAN | GL — Vulkan first, GL when drivers insist.
// On native Windows-ish paths (wgpu_context.rs:319):
//   backends = DX12 — DirectX owns this lane.
```

Adapter-enumeration fallback (`wgpu_context.rs:355`, extra-requirements plumbing at `wgpu_context.rs:494`) covers drivers that advertise more than they deliver. If your window is black on one GPU but fine on another, that function is suspect number one — log `adapter.get_info()` before anything else.

Need more GPU than the defaults? Ask up front, before any window opens:

```rust
use gpui_wgpu::WgpuDeviceRequirements;

app.update(|cx| {
    // set_gpu_requirements lands on App at app.rs:1291 and
    // forwards to Platform at platform.rs:359 — call it early.
    cx.set_gpu_requirements(WgpuDeviceRequirements {
        // TIMESTAMP_QUERY buys you GPU timings; add limits the same way.
        features: wgpu::Features::TIMESTAMP_QUERY,
        // ..Default::default() keeps every other requirement stock.
        ..Default::default()
    });
});
// Open your windows only after this — requirements are read at creation.
```

> **Tip.** GL fallback tightens limits (`wgpu_context.rs:188` adjusts them for GL). If WebGPU looks lush and WebGL looks starved, that clamp is doing its job — not a bug in your shaders.

## Per-platform notes

Verified means we read the file; hedged means the OS, driver, or browser gets the final vote. Both are labeled so you always know which is which.

|  |  |  |
| --- | --- | --- |
| **Platform** | **Verified path** | **Varies by platform/version** |
| macOS — Metal | `gpui_apple/src/metal_renderer.rs`, `metal_atlas.rs`, `shaders.metal`; glue in `gpui_macos/src/platform.rs`, `window.rs` | Exact Metal feature set and OS version. Needs Xcode + CLT (README FAQ). |
| Linux — wgpu | `linux/wayland/` + `linux/x11/` windowing; `wgpu_context.rs:317` requests `VULKAN | GL`; portal calls in `linux/platform.rs`, `linux.rs` | Whether you land on Vulkan, GL, or fallback — plus dialog styling. Nix libs come from `flake.nix` (`vulkan-loader`, `wayland`, `xorg.libX11`, `libxcb`, `libxkbcommon`, `alsa-lib`). |
| Windows — DirectX | `directx_renderer.rs`, `directx_devices.rs`, `directx_atlas.rs`, `direct_write.rs`; shaders `shaders.hlsl`, `alpha_correction.hlsl`, `color_text_raster.hlsl` | Which DirectX/DirectWrite/DirectComposition path runs — read `directx_devices.rs` before asserting in a bug report. |
| Web — canvas | `gpui_web/src/platform.rs` (`WebPlatform`), `window.rs`, `display.rs`, `events.rs`, `dispatcher.rs`, fetch-backed `http_client.rs`, `ime_mirror.rs` | Canvas size, DPR, WebGPU availability, IME edges — every browser answers differently. |

Table 29: Verified files on the left, honest hedges on the right.

macOS serves Metal through a stitched shader library: `metal_renderer.rs:48` embeds `shaders.metallib`, and `metal_renderer.rs:50` keeps the `stitched_shaders.metal` source beside it. A headless Metal renderer exists for tests (`gpui_platform.rs:85`) — macOS-only, `None` elsewhere.

Windows extras in the same crate sweeten the deal: `direct_manipulation.rs` (gestures), `system_notifications.rs`, `system_settings.rs`, `vsync.rs`. The workspace `Cargo.toml` enables a wide `windows.*` feature set (Direct3D11, DXGI, DirectComposition, DirectWrite, and friends).

Boot the web path correctly and it rewards you:

```rust
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn main() {
    // web_init() installs the panic hook + logging — call it first, always.
    gpui_platform::web_init();
    // application() picks WebPlatform with Auto: WebGPU else WebGL.
    let app = gpui_platform::application();
    // ... open your window and render, exactly like native ...
}
```

> **Pitfall.** Forgetting `web_init()` before `application()` on WASM. Panics vanish into the console void and logs never appear — one line at the top saves an hour of squinting.

## Debug wrong-backend days

```sh
# Does the web path still compile? Ask these three, in order.
just check-wasm            # stable wasm build for gpui_ce_web + examples
just check-wasm-atomics    # nightly shared-memory path (needs rustup + nightly)
# Then watch wgpu think out loud on native:
RUST_LOG=wgpu=debug cargo run --example window_movable
```

1. Log `adapter.get_info().backend` at startup — print it in your about box during development.
2. Climb the web ladder rung by rung: `Auto` → `WebGpu` → `WebGl`, and note which rung breaks.
3. On Linux, run once under Wayland and once under X11. Compositor-specific bugs love to hide behind “works on my machine”.

> **Note.** Still stuck? The `platforms-overview` matrix names every file to open; start with the row for your OS and read outward.

## Sources

- Backend enum + preference: `crates/gpui_wgpu/src/wgpu_context.rs:22,29`
- Hints + requirements: `wgpu_context.rs:60,69`; web switch: `wgpu_context.rs:177-179`; GL limit clamp: `wgpu_context.rs:188`; native picks: `wgpu_context.rs:317,319`; fallback: `wgpu_context.rs:355,494`
- `App::set_gpu_requirements`: [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs); `Platform` default: [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)
- Metal: `crates/gpui_apple/src/metal_renderer.rs:48,50,147,176`, `shaders.metal`, `metal_atlas.rs`
- Web platform: `crates/gpui_web/src/platform.rs`, `window.rs`, `display.rs`, `events.rs`, `dispatcher.rs`, `http_client.rs`, `ime_mirror.rs`
