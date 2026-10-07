# Testing views, scenes, and pixels

The testing boundary is a finished `SceneCapture`, not a screenshot of a native window. Ordinary GPUI views build the scene, pinned Parley fonts supply glyph pixels, and the CPU backend replays the captured command stream. Layout/state regressions and rendering regressions can therefore be investigated separately.

## Use the harness in an application

Add `gpui_ce_test` as a development dependency under the Rust crate name `gpui_test`. Add `insta` only if you want snapshot assertions. Within this workspace, use `gpui_test.workspace = true`. An application can use its existing view directly:

```rust,ignore
use anyhow::Result;
use gpui::{AppContext as _, px, size};
use gpui_test::{Harness, Scenario, dispatch_click_on};
use std::time::Duration;

#[test]
fn settings_panel_states() -> Result<()> {
    let scenario = Scenario::new(
        "settings-panel",
        "Settings panel",
        size(px(480.0), px(320.0)),
        |_, cx| cx.new(SettingsPanel::new),
    )?
    .checkpoint("initial", "Initial settings", Duration::ZERO)?
    .checkpoint_with("expanded", "Expanded details", Duration::ZERO,
        |cx, _view, window| {
            dispatch_click_on(cx, window.into(), "settings-details")
        })?;

    // The button uses .debug_selector(|| "settings-details".into()).
    let rendered = Harness::new().run(&scenario)?;
    for (name, snapshot) in rendered.snapshots()? {
        insta::assert_snapshot!(name, snapshot);
    }
    Ok(())
}
```

View factories receive the real headless window and app, so existing constructors that configure focus or window state work directly. Checkpoints use absolute simulated times. `checkpoint_with` advances the normal headless dispatcher, dispatches real events or updates the application's entity, and draws a finished frame. Equal-time checkpoints are useful for successive input states. Do not advance a wall clock or sleep to test animation. A checkpoint update can assert the view's state as well as its pixels.

The compact snapshots fingerprint every primitive field, command, and bitmap byte, plus the rendered RGBA bytes. Counts, per-array fingerprints, and bounded named geometry samples localize changes without repeating thousands of glyphs. Measured timings are excluded. Full scene JSON and PNGs remain in reports for diagnosis. Review a changed capture before accepting it with Insta.

`Harness::with_asset_source` supplies application assets. `with_text_system` supplies an application's text backend and labels its font pack `custom`; `with_named_text_system` records a useful pack identifier. The default pack embeds its font bytes and skips host font discovery. `bundled_fonts()` exposes those same bytes for native examples or application setup without repeating file paths.

### Capture an application-owned suite

The Rust API does not require the `gpui-test` CLI or the bundled font fixtures. Convert typed scenarios with different view types into `AnyScenario`, then let one harness capture them in order. Pass the same asset source and text system your app uses; the named font pack is report metadata, not a global registration:

```rust,ignore
use gpui_test::{AnyScenario, Harness, ReportOptions, write_report};
use std::{path::Path, sync::Arc};

let cases: Vec<AnyScenario> = vec![settings_scenario()?.into(), search_scenario()?.into()];
let suite = Harness::new()
    .with_named_text_system("product-fonts-v1", app_text_system())
    .with_asset_source(Arc::new(AppAssets))
    .run_all(&cases)?;

// Either persist the portable report directly or inspect snapshots in memory.
write_report(&suite, Path::new("target/settings-report"), ReportOptions::default())?;
for scenario in &suite.scenarios {
    for (name, snapshot) in scenario.snapshots()? {
        insta::assert_snapshot!(name, snapshot);
    }
}
```

`app_text_system()` returns `Arc<dyn PlatformTextSystem>` backed by the application’s font setup, and `AppAssets` implements GPUI’s `AssetSource`. `Harness::new()` uses the bundled deterministic fonts only when no text system is supplied. `AnyScenario` erases only the view type so heterogeneous cases can share one harness and report; each scenario factory remains typed and can also be opened natively.

## One portable artifact protocol

`write_report` writes `manifest.json`, checkpoint PNGs and gzip-compressed scene JSON, a Markdown table, a Plotters SVG, and a static HTML viewer. Every artifact link is relative. Copy the directory to a website, embed the viewer in an iframe, serve it locally, or retain it as a forge job artifact. The versioned manifest supplies the same input to the GitHub and GitLab adapters; the Rust harness contains no forge API code.

For larger suites, `ReportWriter` accepts individual captures or existing reports and holds only scenario metadata after each write. `gpui-test collect` uses this path, preserving the original measurements. Artifact writes happen in a sibling staging directory; `finish()` publishes the complete bundle. Failed additions cannot publish a partial report, and the previous output remains available.

```rust,ignore
let mut writer = gpui_test::ReportWriter::new("target/report", options)?;
for case in &cases {
    writer.add_scenario(&case.run(&harness)?)?;
}
let manifest = writer.finish()?;
// Rebuild presentation without decoding captures or measuring again.
manifest.write_views("target/report")?;
```

Scene artifacts use deterministic, fast gzip after capture and measurement. `SceneCapture` remains ordinary JSON; `read_report` and comparison transparently read both `.scene.json.gz` and legacy `.scene.json` files. Storage encoding never changes comparison status or reviewed snapshots. Readers bound gzip expansion and validate the restored capture before replay.

Comparison distinguishes scene changes, pixel changes, metadata changes, added/removed scenarios, and added/removed checkpoints. The manifest stores these typed results, and every viewer and forge adapter consumes them directly. Only the Rust comparison layer reads baseline pixels and scene values, avoiding encoding-only changes from a second file comparison. A missing baseline is explicit. `gpui-test run --baseline DIR` produces advisory differences; `gpui-test check --baseline DIR` fails when the selected scenarios change. A partial `check` compares only those scenarios, so unrelated baseline cases are not reported as removed.

Image comparison keeps coordinates and input extents intact. Exact red marks every RGBA or extent change; the magnitude heatmap uses a fixed scale for premultiplied color and alpha error. Bounds, raw error, and visible error stay separate, so transparent RGB noise cannot masquerade as visible damage. Wipe, blink, side-by-side, and actual-pixel views inspect the same selected checkpoint. The checked-in viewer exports `renderReport(root, manifest, {baseURL})` with a disposer; a website can mount it directly against forge-hosted assets without recomputing diffs. Embedded instances keep selection local; standalone reports opt into `useHash: true` for checkpoint links.

The timeline supports frame scrubbing, timed playback, and jumps to changed frames. It plots exact, visible, and transition errors separately, with a percentage scale that exposes small failures. Transition analysis compares signed premultiplied color/alpha changes and extent changes between adjacent checkpoint pairs; a static color offset cancels, while frozen motion, reversed motion, and altered fades remain visible. Separate transition masks show where motion diverged, including when the final image catches up to the baseline. Statistics-only comparison allocates no image, and report generation writes transition images only for failures. Baseline and current elapsed times are reported independently. Removed, added, or reordered checkpoints never get bridged into a false motion comparison. These are sampled frames; place checkpoints around the animation events you need to verify rather than relying on interpolation.

On GitHub, commit-addressed `runs/<sha>/` directories, a report index, and per-PR history can live on a dedicated Pages branch. The Rust writer and trusted publisher embed one shared viewer from checked-in sources. The publisher validates the manifest, escapes embedded data, and sanitizes the graph; artifact-provided HTML and scripts are excluded. A website can link directly to these forge-hosted runs without needing a service or a database. See [setup and forge adapters](testing.md).

## Rendering contracts

Capture v1 owns canonical atlas bitmaps and compiled commands. Resources are sorted/deduplicated by their content, so unrelated atlas allocation history does not change snapshots. Native surfaces carry operating-system handles and produce an explicit unsupported-capture error. Restored scenes are for renderer replay; they do not restore live layout or paint caches.

Validation recompiles the expected command stream from the captured primitive arrays. This checks batching, texture references, smoothing flags, path resource counts, and filter nesting with the production compiler. Malformed serialized ranges are never used for indexing. Complete triangles, finite geometry, bitmap dimensions/byte counts, and filter parameters are also validated.

The CPU renderer shares Rust-authored paint, corner, shadow, glyph-correction, and path-coverage helpers with GPU shaders. Paths follow the same raster-target-then-sprite composition boundary. Filter isolation uses the shared depth cap; blur uses the production kernel, downsampling, scissor, and maximum-radius rule. Text coverage defaults to neutral correction for portable captures. `CpuRenderer::with_font_rasterization` accepts the same `FontRasterizationSettings` type exported by WGPU when explicit gamma, contrast, or BGR behavior needs testing.

Software pixel goldens are a deterministic contract for this backend. Independent analytic probes also replay captures through WGPU: transparent source-over, clipping, monochrome and color tiles, changed atlas contents, target resize, and allocation accounting. Existing native tests cover gradients, border coordinates, path geometry, and blur symmetry. Their expectations come from compositing and geometry laws rather than the CPU image alone. Mesa lavapipe runs the required replay checks in CI without a physical GPU. Semantic CPU contracts run on Linux, macOS, and Windows; reviewed pixel goldens use the Ubuntu capture environment.

## Frame work and native measurements

`gpui-test bench --samples 20` redraws each checkpoint at a fixed simulated time after one warm-up draw. The launcher selects a release build for `bench`. One harness reuses its bundled font system across scenarios; CPU replay retains and clears its target between frames. The report separates scene-build and CPU-replay p50/p95/p99 timings, sample count, primitive/batch counts, and captured bitmap bytes. Font setup, RGBA readback, serialization, and image encoding are outside the measurements. Use the same machine and toolchain for performance comparisons.

Add `--gpu` to replay those exact captures through one retained WGPU renderer. The launcher enables the optional backend automatically. Atlas upload, target creation, timestamp mapping, and PNG readback stay outside the sampled interval. Native wall time covers frame preparation, encoding, submission, and queue completion; device timestamps cover the earliest measured render-pass start through the latest pass end, including gaps and overlapping passes. Clear-only captures have no device timing; supported adapters still report their capability. Invalid driver counters disable device timing for the entire report and record the reason, while completed-frame wall timing, images, and allocation measurements continue. This is frame work, not monitor presentation or vsync latency. Reports retain the native PNG, its red difference against the CPU rendering, and pixel/channel error statistics.

Memory has explicit sources and scopes. Tracked resource bytes include the live atlas backing textures, headless color target, and readback buffer. WGPU allocator reports provide reserved backing-block bytes, including unused capacity, on supported backends such as Vulkan and D3D12. Metal falls back to `MTLDevice.currentAllocatedSize`, which includes resources on that selected shared device. Neither number claims system-wide VRAM residency. Unsupported telemetry has a reason, rather than a fabricated zero or a bitmap-size estimate. CPU-only reports need no GPU fields or native dependencies.

`gpui-test platform --output native-report` runs a real native event loop on its main thread. It opens two hidden windows, verifies idempotent visibility, activates them and checks focus transfer, waits for redraw and exact content-resize callbacks, inspects a nonempty native scene/readback, then verifies both window handles close. Each wait has a five-second deadline. Its typed manifest, Markdown table, Plotters latency graph, and HTML viewer use the same report writer and forge protocol. The public `gpui_ce_platform::testing::run_window_checks` callback receives the report before quitting: macOS can terminate the process when its event loop quits, so callers save results in that callback. CI runs X11 under Xvfb/openbox and native macOS/Windows probes separately from the GPU-free contracts.

The capture boundary also suits live-update and interpreter work: a running view can export a versioned value, and a separate renderer or report viewer can consume it without sharing Rust object layouts, native handles, or atlas lifetimes. The harness adds no hot-patching runtime dependency. A dedicated pinned-nightly Miri job runs `cargo miri test --locked -p gpui_ce_render --features cpu --test capture_validation` without entering native font/platform calls or graphics drivers.

Property tests check compositing laws, clipping locality, canonical atlas history, and timeline ordering using generated inputs. Independent affine probes compare the shared shader transform with GPUI's matrix law; rotated, non-square sprite fixtures check screen-space culling, clipping, ordering, and CPU/native pixels. Image playback preserves variable frame delays and cycle remainders under large simulated clock jumps. Analytic state tests cover Parley underline pixels, dispatcher time, easing, repeat boundaries, and removed checkpoints. The isolated Luna mutation campaign exercises deliberate regressions against those assertions; see [the mutation evidence](testing-mutations.md). Run `python3 scripts/testing/pseudo_mutation.py --help` for its source-revision and output controls. Compile failures, zero-test selections, timeouts, and surviving mutations remain distinct from detected regressions.

## Verification of the implementation

Local checks used the pinned nightly on macOS, including actual Metal replay and native window checks. The results below cover the changed contracts and examples; they do not claim that every existing workspace test ran.

| Check | Local result |
|---|---|
| CPU rendering | 66 unit, capture-validation, and property checks passed |
| Scene construction and image playback | 16 scene checks and eight image checks passed, including transformed culling/order and variable-delay animation |
| Parley | 61 checks passed; decoration probes independently verify text metrics and underline pixels |
| Harness and comparison | 17 library checks, 20 collection/encoding checks, seven state regressions, and all 23 reviewed scene/pixel checkpoints passed |
| Example lessons | Eight checks passed with real pointer, drag/drop, keyboard, animation restart, editor, and GIF frame behavior |
| Example builds and captures | All 31 targets compiled; all 24 scenario-backed examples captured at 20 samples per checkpoint |
| Web example | `hello_world` compiled for `wasm32-unknown-unknown` with the shared font pack |
| Miri | Seven capture-validation checks passed with isolation enabled; 64 source-over cases and 24 retained-frame cases passed with filesystem isolation disabled for proptest setup |
| Native renderer | 39 WGPU unit checks, four analytic parity/capacity checks, two native replay checks, and 200 repeated mixed-script frames passed |
| Native OS integration | Actual macOS visibility, activation, focus, redraw, exact resize, and two-window close checks passed: six supported capabilities, 13 events, no errors |
| Saved aggregate | 29 scenarios and 78 checkpoints, with 20 CPU and native samples each; every primary scene, PNG, native PNG, timing sample, and typed baseline change survived report regeneration unchanged |
| Report collection | Optimized collection used 182.95 MiB peak RSS for one report and 199.63 MiB for a duplicate pair; [workload and raw measurements](testing-performance.md) preserve the comparison's limits |
| Luna mutations | 25 dc88 mutations, seven distinct cf2 runtime mutations, six 862 diff/report mutations, and one 3bba transition-mask mutation were detected; [revision-specific evidence](testing-mutations.md) preserves invalid attempts and corrected retries separately |
| Forge adapters and launchers | 58 Python checks completed: 57 passed, one Windows-only launcher check skipped locally |
| Browser viewer | Resize alignment, wipe clipping, exact/magnitude/transition masks, pixel focusing, scrub/play/replay, changed-frame navigation, two independent embedded instances, and mount/unmount verified in the actual browser |
| Local HTTP publication | All 387 main-report assets (28,709,118 bytes) and 392 injected-motion-probe assets were retrieved byte-for-byte; identical main-report assets required 325 distinct blobs |
| Code quality | Scoped renderer, harness, and WGPU Clippy checks passed with `--no-deps`; the test crate's package file list includes its fonts |

Saved reports retain full captures and timing provenance. Native replay measures queue-completed wall time and tracked/device allocation scopes; invalid Metal counters are explicitly unavailable, with their driver error preserved. The report protocol and production HTTP adapters are exercised against a stateful local forge, including hosted asset retrieval, JavaScript/CSS/gzip MIME types, generated viewers, report history, bounded comments, identical-blob reuse, and stale-head guards. A deliberately altered baseline also produced a transition-only failure whose red and magnitude images were hosted and linked in the comment. No external forge write or deployment was performed.

Linux and Windows jobs are configured in CI; their operating-system execution was not performed on this macOS checkout. Native frame work excludes monitor presentation and vsync latency.
