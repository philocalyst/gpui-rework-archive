+++
title = "Performance: measure first, then cut"
description = "Find expensive work, reduce unnecessary updates, and keep rendering responsive."
weight = 38
aliases = ["/guides/performance.html"]
[extra]
category = "GUIDES"
legacy_source = "gpui-ce-docs/build/html/guides/performance.html"
+++

Welcome, friend — your app is probably already fast enough, and this guide will prove it before you change a single line. GPUI-CE gives you a real profiler, a lap timer for your scroll paths, and four optimizations that actually move the needle. Measure first, cut second, brag never.

## The loop: profile, change, compare

**The profiler** lives behind the scenes in [crates/gpui/src/app.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app.rs) (`foreground_journal`) and wakes up through `install_foreground_journal` (`app.rs:820`). Bench harnesses consume it via `foreground_journal_collector` (`crates/gpui/src/app/bench_context.rs:623-624`), and `tooling/perf/` wraps the whole ritual (“Perf profiler for Zed tests. Outputs timings of tests marked with `#[perf]`”).

```sh
# 1. Baseline in release — debug numbers measure overflow checks, not you.
cargo build --release
cargo test --release --workspace --no-fail-fast
# 2. Focused perf run — flags live in tooling/perf/src/main.rs, read them.
cargo run --release -p perf -- --help
# 3. Everyday hygiene — fmt + clippy keep hot paths review-clean.
just fmt-check
cargo clippy --workspace --all-targets -- -D warnings
```

Rules of the road, taped to your monitor:

1. Release builds only. Debug layout costs lie to your face.
2. One variable at a time. Change batching **or** caching, never both, then re-run.
3. Fixed seed for flakes (`just test-with-seed 12345`) so timing comparisons track code, not noise.
4. Record before/after frame times (p50/p95), not vibes. `hdrhistogram` already ships in the workspace — use it.

> **Pitfall.** Optimizing first paint when users complain about scroll jank. Profile the interaction they actually do — startup traces will happily waste your week.

## The big four

**1. Batch, then stop the relayout churn.** Every `cx.notify()` re-runs `render` for that view, so coalesce rapid updates — text-input keystrokes, drag positions — into one notification per frame. Prefer `cx.listener` closures that mutate several fields and notify once over one-notify-per-field. Hoist invariant subtrees out of per-frame closures so layout reuses them instead of rebuilding.

**2. Virtualize long lists, lovingly.** `uniform_list` ([crates/gpui/src/elements/uniform_list.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/elements/uniform_list.rs)) paints only the visible slice — but only when rows are truly uniform height. Store `ListState` in the view (the `scroll_to_*` family lives at `uniform_list.rs:150-252`), never rebuild it per frame. For variable heights, reach for `elements/list.rs` and accept the measurement cost with eyes open.

```rust
// Keep this beside recipe 7 in the cookbook — it is the fast path, annotated.
// uniform_list (uniform_list.rs:22) renders just the on-screen window of rows.
use gpui::{prelude::*, *};

// state persists across frames; rebuilding it per frame resets scroll to zero.
struct Big { state: ListState }

impl Render for Big {
    fn render(&mut self, _w: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        // size_full() hands the list the whole window to virtualize within.
        div().size_full().child(
            uniform_list(
                // Cloning ListState shares the scroll core — cheap by design.
                self.state.clone(),
                // Fixed 28px rows let the list skip measuring entirely.
                px(28.),
                // Only `range` becomes elements; 9,900 rows never exist.
                |range, _w, _cx| {
                    range.map(|ix| div().px_2().child(format!("row {ix}"))).collect()
                },
            )
        )
    }
}
```

**3. Cache assets and images like you mean it.** Images flow through `image_cache()` plus `AnyImageCache` (`crates/gpui/src/elements/image_cache.rs:15,25`) and the `ImageCacheProvider` trait (`image_cache.rs:216-222`). Load once behind a provider, share the `Entity`, and let the atlas (`PlatformAtlas` at `platform.rs:1419`, wgpu side `wgpu_atlas.rs`) keep glyphs and textures resident. Re-decoding a PNG per frame is the classic 10x slowdown — grep your hot path for `RenderImage` allocations and gasp appropriately.

**4. Respect the GPU you were given.** The shared renderer (`gpui_wgpu/src/wgpu_renderer.rs`) batches scene draws, and `WgpuDeviceRequirements` (`wgpu_context.rs:69`) lets you request extra features up front via `App::set_gpu_requirements` (`app.rs:1291`, forwarded at `platform.rs:359`) — always before opening windows.

```rust
// Ask for GPU features before any window exists — afterwards is too late.
use gpui_wgpu::WgpuDeviceRequirements;

app.update(|cx| {
    // TIMESTAMP_QUERY enables GPU timings; add limits the same way.
    cx.set_gpu_requirements(WgpuDeviceRequirements {
        // Features travel through Box<dyn Any> at platform.rs:359.
        features: wgpu::Features::TIMESTAMP_QUERY,
        // Keep everything else stock with Default.
        ..Default::default()
    });
});
// Now open windows — the compositor reads your requirements at creation.
```

Practical notes, verified and hedged where due:

- Prefer fewer, larger batches: one `uniform_list` beats 10k individual views.
- Watch texture uploads: scrolling that decodes new images every frame stutters on any backend (Metal, Vulkan/GL, DX12, WebGPU/WebGL — exact cost varies by platform/version).
- On web, `WebGl` runs under tighter limits than `BrowserWebGpu` (`wgpu_context.rs:188` clamps them); test the GL fallback explicitly, not hopefully.
- If a driver lies about capabilities, adapter fallback (`wgpu_context.rs:355`, extra-requirements path at `wgpu_context.rs:494`) kicks in — log `adapter.get_info()` so bug reports name the real backend.

> **Warning.** Spawning unbounded background tasks per keystroke is a fork bomb in a trench coat. The executor integrates with the event loop, but it cannot save you from yourself — debounce, then spawn.

## Non-goals

- Never hand-roll your own atlas, text shaper, or executor. `PlatformTextSystem`, `PlatformAtlas`, and the platform dispatchers exist so you stay in product code.
- Never compare GPUI-CE to Electron, Tauri, Iced, or Dioxus on one debug-mode microbenchmark. Capability gaps (native windows vs webview, retained vs immediate trade-offs) matter more than a single fps number you ran once.
- Never skip the baseline. An optimization without a before/after table is a story, not an improvement.

## Try it

1. Take cookbook recipe 7 (10k rows) and time scroll with `uniform_list` vs 10k plain `div` children. Write down the ratio — that number is why virtualization exists.
2. Add an `ImageCache` to a screen with 50 thumbnails; profile with and without it. The diff is your caching story for code review.
3. Force `WebBackendPreference::WebGl` on your web build and re-run the same interaction. Note what regresses; that list is your low-end support checklist.

> **Note.** Next step: open `tooling/perf/src/main.rs`, run it with `--help`, and pick one `#[perf]` test to beat.

## Sources

- Foreground journal: `crates/gpui/src/app.rs:718,820`; bench collector: `crates/gpui/src/app/bench_context.rs:623-624`; test journal: `bench_context.rs:1131,1135,1181`
- Perf harness: `tooling/perf/src/main.rs`
- GPU requirements: `crates/gpui_wgpu/src/wgpu_context.rs:60,69,188,355,494`; `App::set_gpu_requirements`: `app.rs:1291`; platform forward: `platform.rs:359`
- Image cache: `crates/gpui/src/elements/image_cache.rs:15,25,216-222`; atlas: `platform.rs:1419`
- Virtualized list: `crates/gpui/src/elements/uniform_list.rs:22,150-252`
