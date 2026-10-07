# Pseudo-mutation campaign

Source revision: `cf2c544d6dcdfd5a0fa3703f220de89ee5d16de8`

Run date: 2026-10-07 00:37 UTC

Cargo target directory: `/Users/mileswirht/.codex/worktrees/f239/gpui-ce3/target/pseudo-mutation/cf2c544d6dcdfd5a0fa3703f220de89ee5d16de8-1791333442348529000-20603`

Campaign status: **complete**

Mutations ran one at a time in a disposable archive of the selected Git revision. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `accept-conflicting-duplicate-report-pixels` | report collection rejects duplicate pixel conflicts | **killed** | 15.55 s |
| `accept-reversed-gpu-timestamps` | GPU timestamp conversion rejects reversed intervals | **killed** | 6.44 s |
| `use-submission-order-for-gpu-timestamp-envelope` | GPU timestamp envelope covers overlapping render passes | **killed** | 6.14 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| report collection rejects duplicate pixel conflicts | **passed** | 154.86 s |
| GPU timestamp conversion rejects reversed intervals | **passed** | 116.4 s |
| GPU timestamp envelope covers overlapping render passes | **passed** | 1.92 s |

## Trial details

### `accept-conflicting-duplicate-report-pixels` — killed

Skip checking canonical snapshots when duplicate report scenario IDs are collected.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test report_collection collect_reports_rejects_pixel_conflicts_for_duplicate_ids`

```text
running 1 test
collect_reports_rejects_pixel_conflicts_for_duplicate_ids --- FAILED

failures:

---- collect_reports_rejects_pixel_conflicts_for_duplicate_ids stdout ----

thread 'collect_reports_rejects_pixel_conflicts_for_duplicate_ids' (90274810) panicked at crates/gpui_test/tests/report_collection.rs:179:61:
called `Result::unwrap_err()` on an `Ok` value: RenderedSuite { scenarios: [RenderedScenario { id: "sample", title: "Sample scenario", viewport: Viewport { width: 4.0, height: 4.0, scale_factor: 1.0 }, font_pack: "fixture-pack", checkpoints: [RenderedCheckpoint { id: "frame", name: "Frame", time_ns: 0, capture: SceneCapture { version: 1, shadows: [], quads: [], paths: [], underlines: [], monochrome_sprites: [], subpixel_sprites: [], polychrome_sprites: [], backdrop_filters: [], filter_boundaries: [], commands: [], bitmaps: [] }, image: ImageBuffer { width: 4, height: 4, _phantom: PhantomData<image::color::Rgba<u8>>, color: CicpRgb { primaries: SRgb, transfer: SRgb, luminance: NonConstant }, data: [1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255] }, metrics: ScenarioMetrics { frame_count: 1, scene_build_p50_ns: 10, scene_build_p95_ns: 10, scene_build_p99_ns: 10, cpu_render_p50_ns: 20, cpu_render_p95_ns: 20, cpu_render_p99_ns: 20, primitive_count: 0, batch_count: 0, bitmap_storage_bytes: 0 }, native: None }] }], native_replay: None, platform_checks: None }
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    collect_reports_rejects_pixel_conflicts_for_duplicate_ids

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 8 filtered out; finished in 0.07s
```

### `accept-reversed-gpu-timestamps` — killed

Saturate a reversed GPU timestamp interval to zero instead of rejecting it.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_wgpu --features test-support --lib timestamp_duration_requires_a_valid_order_and_finite_range`

```text
running 1 test
wgpu_renderer::headless::tests::timestamp_duration_requires_a_valid_order_and_finite_range --- FAILED

failures:

---- wgpu_renderer::headless::tests::timestamp_duration_requires_a_valid_order_and_finite_range stdout ----

thread 'wgpu_renderer::headless::tests::timestamp_duration_requires_a_valid_order_and_finite_range' (90306239) panicked at crates/gpui_wgpu/src/wgpu_renderer/headless.rs:743:9:
assertion failed: timestamp_duration(120, 100, 1.0).is_err()
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    wgpu_renderer::headless::tests::timestamp_duration_requires_a_valid_order_and_finite_range

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 38 filtered out; finished in 0.00s
```

### `use-submission-order-for-gpu-timestamp-envelope` — killed

Use submission order instead of the minimum start and maximum end across overlapping passes.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_wgpu --features test-support --lib timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs`

```text
running 1 test
wgpu_renderer::headless::tests::timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs --- FAILED

failures:

---- wgpu_renderer::headless::tests::timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs stdout ----

thread 'wgpu_renderer::headless::tests::timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs' (90332981) panicked at crates/gpui_wgpu/src/wgpu_renderer/headless.rs:753:9:
assertion `left == right` failed
  left: Some(30ns)
 right: Some(50ns)
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    wgpu_renderer::headless::tests::timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 38 filtered out; finished in 0.00s
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
