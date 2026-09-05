+++
title = "Platform Loop"
description = "Follow a platform event into the framework, through an update, and back to the screen."
weight = 8
aliases = ["/fundamentals/platform-loop.html"]
[extra]
category = "FUNDAMENTALS"
legacy_source = "gpui-ce-docs/build/html/fundamentals/platform-loop.html"
+++

GPUI draws only when something is dirty. The platform owns the frame clock; GPUI owns the scene. The two meet in `on_request_frame` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). Fresh windows start dirty, so the first frame always draws.

A **frame** is one draw-plus-present cycle for one window. A **scene** is the retained command list the window builds during draw. The platform presents scenes to the screen.

```
platform event (input, resize, timer, schedule_frame)
  -> on_request_frame(options)
  -> dirty or force_render? draw scene : skip
  -> present scene (platform draws it)
  -> still dirty? schedule another frame
```

## Event loop and frame requests

`Platform::run` owns the OS event loop. Each `PlatformWindow` registers an `on_request_frame` callback that receives `RequestFrameOptions` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). GPUI installs this callback when a `Window` is created ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)).

`RequestFrameOptions` has two flags:

- `require_presentation` — the platform needs a present even without changes.
- `force_render` — bypass cached view reuse and redraw everything.

`PlatformWindow::schedule_frame` asks for a future frame ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). `PlatformWindow::frame_waker` returns a wakeup closure for idle windows ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). `App::flush_effects` calls `schedule_frame` for every dirty window at the end of each update ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). New invalidations wake the platform only on the clean-to-dirty transition, so ten notifies still schedule one frame.

Dispatchers connect executors to the loop. `PlatformDispatcher` posts runnables to main or background threads ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). `PlatformScheduler` wraps it for the foreground executor ([crates/gpui/src/platform_scheduler.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform_scheduler.rs)). No busy loop exists; idle windows sleep until woken.

## Dirty tracking and redraw

A **dirty** window needs a redraw. `Window::refresh` marks the window dirty ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). It no-ops while a draw is in flight, so mid-draw notifies defer instead of corrupting the scene. `App::refresh_windows` marks every window dirty through one coalesced effect ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)).

The invalidator holds two pieces of state: a `dirty` bit and a `dirty_views` set ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). `Context::notify` dirties one entity; `refresh` dirties the whole window. Multiple marks per cycle still produce one draw. `invalidate_view` during draw returns `false` and skips the dirty bit ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). The draw loop re-arms itself instead, so deferred work lands on the next frame.

The frame callback applies this policy ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)):

- Dirty or `force_render` — run `Window::draw`, then `present`.
- Clean but `require_presentation` — `present` the last scene again.
- Clean and no demand — skip both.
- Re-invalidated mid-draw or pending next-frame callbacks — `schedule_frame` again.

`Window::draw` clears the dirty bit first, rebuilds the scene from dirty views, swaps rendered frames, and returns an arena guard ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). Clearing first is the trick: anything dirtied during the draw stays dirty and schedules a follow-up. A remembered `deferred_force_render` flag survives across the deferred path, so a forced redraw is never silently downgraded ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). `on_next_frame` queues a closure without dirtying, so animations use it instead of `refresh`.

```rust
// refresh() dirties the whole window. One call per frame is enough.
// on_next_frame() queues follow-up work WITHOUT dirtying the window.
// It wakes the platform explicitly, so idle windows still run it.
// request_animation_frame() = on_next_frame + notify current view.
window.refresh();

// Run once after the current frame, without a full redraw.
window.on_next_frame(|window, cx| {
    // Follow-up work runs here: measure, then maybe refresh.
});

// Decorative loops: prefer animations over manual frames.
window.request_animation_frame();
```

> **Warning.** `force_render` bypasses cached view reuse. Reach for it on GPU device recovery only, never as a refresh substitute. It redraws everything, while `refresh` redraws what is dirty.

## Throttling and pacing

Frames can be throttled before drawing. The check reads `RequestFrameOptions`, focus state, and thermal state ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). No fixed refresh rate is assumed in portable code.

- Presentation demand (`require_presentation`, pending callbacks) disables throttling.
- Inactive windows use `WindowOptions::inactive_frame_interval` (about 30 fps by default).
- `ThermalState::Serious` or `Critical` caps background work near 60 fps ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)).
- Throttled frames re-arm with `schedule_frame` plus an explicit platform wakeup.

`Window::request_animation_frame` notifies the current view on the next frame ([crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs)). Callers driving spinners or pulses should use `AnimationExt::with_animation`, which respects `App::reduce_motion` ([crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs)). Toggling reduce-motion refreshes every window at once. Skip manual frame requests when reduce-motion is set.

> **Tip.** Pause decorative animation with `tab` focus checks plus `reduce_motion`, not with frame counters. The platform already throttles unfocused windows for you.

## GPU delegation

GPUI never talks to the GPU directly from portable code. `Window::present` hands the finished scene to `PlatformWindow::draw(&scene)` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). The platform renderer encodes and submits it.

The window borrows its sprite atlas from the platform at creation ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). Glyph and image tiles live there across frames. `force_render` exists for GPU device recovery: it bypasses cached atlas references after the platform rebuilds the device.

Some backends expose `gpu_context` (device and queue) and `gpu_device_lost` ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)). Both are cfg-gated to Linux, FreeBSD, and some Windows builds. Embedders that captured the device must stop submitting while `gpu_device_lost` reads `Some(true)`. Headless renderers implement `PlatformHeadlessRenderer` to encode scenes offscreen without presenting ([crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs)).

```
Window::draw -> Scene -> present -> PlatformWindow::draw(&scene)
  -> backend encodes scene, submits to GPU, presents surface
```

## Sources

- [crates/gpui/src/platform.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform.rs) (`RequestFrameOptions`), `:902` (`frame_waker`), `:905` (`on_request_frame`), `:916` (`draw`), `:917` (`schedule_frame`), `:918` (`sprite_atlas`), `:992`–`:1007` (`gpu_context`, `gpu_device_lost`), `:1072` (`PlatformHeadlessRenderer`), `:1108` (`PlatformDispatcher`), `:446` (`ThermalState`)
- [crates/gpui/src/window.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/window.rs) (invalidator state), `:172` (`invalidate_view` mid-draw), `:235` (`wake_platform`), `:1546` (frame callback), `:1580` (`deferred_force_render`), `:1590` (throttling), `:1640` (dirty-or-force branch), `:2043` (`refresh`), `:2369` (`on_next_frame`), `:2389` (`request_animation_frame`), `:2886` (`draw`)
- [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) (`reduce_motion`), `:1103` (`refresh_windows`), `:1787` (`flush_effects` scheduling)
- [crates/gpui/src/platform_scheduler.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/platform_scheduler.rs) (`PlatformScheduler`)
