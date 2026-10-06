# Testing views, scenes, and pixels

The testing boundary is a finished `SceneCapture`, not a screenshot of a native window. Ordinary GPUI views build the scene, pinned Parley fonts supply glyph pixels, and the CPU backend replays the captured command stream. Layout/state regressions and rendering regressions can therefore be investigated separately.

## Use the harness in an application

Add `gpui_ce_test` as a development dependency under the Rust crate name `gpui_test`, and add `insta` for snapshot assertions. Within this workspace, use `gpui_test.workspace = true`. An application can use its existing view directly:

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

## One portable artifact protocol

`write_report` writes `manifest.json`, checkpoint PNGs and scene JSON, a Markdown table, a Plotters SVG, and a static HTML viewer. Every artifact link is relative. Copy the directory to a website, embed the viewer in an iframe, serve it locally, or retain it as a forge job artifact. The versioned manifest supplies the same input to the GitHub and GitLab adapters; the Rust harness contains no forge API code.

Comparison distinguishes scene changes, pixel changes, metadata changes, added/removed scenarios, and added/removed checkpoints. The manifest stores these typed results, and every viewer and forge adapter consumes them directly. Only the Rust comparison layer reads baseline pixels and scene values, avoiding encoding-only changes from a second file comparison. A missing baseline is explicit. `gpui-test run --baseline DIR` produces advisory differences; `gpui-test check --baseline DIR` fails when the selected scenarios change. A partial `check` compares only those scenarios, so unrelated baseline cases are not reported as removed.

On GitHub, commit-addressed `runs/<sha>/` directories, a report index, and per-PR history can live on a dedicated Pages branch. The trusted publisher regenerates HTML from the manifest and sanitizes the graph; it does not execute or publish artifact-provided HTML. A website can link directly to these forge-hosted runs without needing a service or a database. See [setup and forge adapters](testing.md).

## Rendering contracts

Capture v1 owns canonical atlas bitmaps and compiled commands. Resources are sorted/deduplicated by their content, so unrelated atlas allocation history does not change snapshots. Native surfaces carry operating-system handles and produce an explicit unsupported-capture error. Restored scenes are for renderer replay; they do not restore live layout or paint caches.

Validation recompiles the expected command stream from the captured primitive arrays. This checks batching, texture references, smoothing flags, path resource counts, and filter nesting with the production compiler. Malformed serialized ranges are never used for indexing. Complete triangles, finite geometry, bitmap dimensions/byte counts, and filter parameters are also validated.

The CPU renderer shares Rust-authored paint, corner, shadow, glyph-correction, and path-coverage helpers with GPU shaders. Paths follow the same raster-target-then-sprite composition boundary. Filter isolation uses the shared depth cap; blur uses the production kernel, downsampling, scissor, and maximum-radius rule. Text coverage defaults to neutral correction for portable captures. `CpuRenderer::with_font_rasterization` accepts the same `FontRasterizationSettings` type exported by WGPU when explicit gamma, contrast, or BGR behavior needs testing.

Software pixel goldens are a deterministic contract for this backend. Native GPU sampling, MSAA, color formats, and platform font backends still need targeted backend checks; CPU goldens do not establish exact native GPU equivalence. Semantic contracts run on Linux, macOS, and Windows in CI, while reviewed pixel goldens use the Ubuntu capture environment.

## Performance and future work

`gpui-test bench --samples 20` redraws each checkpoint at a fixed simulated time. The report separates scene-build and CPU-replay p50/p95/p99 timings, sample count, primitive/batch counts, and captured bitmap bytes. Font setup, serialization, and image encoding are outside those measurements. Use release builds and the same machine/toolchain for performance comparisons. These numbers measure repeated frame work, not display presentation latency.

CPU reports mark GPU memory as unavailable. Captured bitmap storage is not VRAM residency. Native presentation timing and driver memory require a backend measurement implementation; the manifest reserves `gpu_memory_bytes` for a real measurement rather than estimating it from texture bytes.

The capture boundary also suits live-update and interpreter work: a running view can export a versioned value, and a separate renderer or report viewer can consume it without sharing Rust object layouts, native handles, or atlas lifetimes. The harness adds no hot-patching runtime dependency. `cargo miri test -p gpui_ce_render --features cpu --test capture_validation` checks this value boundary without entering native font/platform calls or graphics drivers. All seven capture checks passed under Miri on the pinned nightly. The separate live-update branch was not available in this checkout, so this work establishes the shared artifact boundary without assuming its implementation.

Property tests check compositing laws, clipping locality, canonical atlas history, and timeline ordering using generated inputs. Analytic state tests cover Parley underline pixels, dispatcher time, easing, repeat boundaries, and removed checkpoints. The isolated Luna mutation campaign exercises deliberate regressions against those assertions; see [the mutation evidence](testing-mutations.md). Run `python3 scripts/testing/pseudo_mutation.py --help` for its source-revision and output controls. Compile failures, zero-test selections, timeouts, and surviving mutations remain distinct from detected regressions.

## Verification of the implementation

Local checks used the pinned nightly on macOS. These are focused checks of the new boundary and shared examples, rather than a claim that every existing workspace test ran.

| Check | Local result |
|---|---|
| Renderer and harness, all targets | 69 tests passed, including the 23 reviewed scene/pixel checkpoints |
| Native component and styling lessons | Both tests passed with real click, redraw, Tab, and Shift-Tab events |
| Entity observation stream | Successive notifications and safe stream disposal passed |
| Miri capture validation | All seven checks passed without entering native font or GPU calls |
| Luna source mutations | All 18 detected after 14 baseline commands passed; no survivors, invalid trials, or timeouts |
| Native examples | All 40 targets compiled |
| Web example | `hello_world` compiled for `wasm32-unknown-unknown` with the shared font pack |
| Forge adapters and launchers | 22 checks completed; the Windows-only launcher check was skipped locally |
| Code quality and packaging | Renderer/harness Clippy passed with `--no-deps`; the test crate's package file list includes its fonts |
| Saved reports | Full and selected CLI comparisons passed from outside the repository; intentional scene, pixel, and metadata changes failed with before/current/red images |
| Repeated frame benchmark | All 23 checkpoints used 20 samples and matched the single-frame scene and pixel baseline |
| Website artifacts | The generated and trusted viewers rendered locally; all 23 checkpoint labels appeared in the sanitized Plotters graph |

Linux and Windows contract jobs are configured in CI but were not executed from this checkout. Forge publication was tested with mocked APIs; no report was posted or deployed. Native GPU presentation and driver memory remain separate backend measurements, as described above.
