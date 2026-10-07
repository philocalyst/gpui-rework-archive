# Pseudo-mutation campaign

Source revision: `cf2c544d6dcdfd5a0fa3703f220de89ee5d16de8`

Run date: 2026-10-07 00:15 UTC

Cargo target directory: `/Users/mileswirht/.codex/worktrees/f239/gpui-ce3/target/pseudo-mutation/cf2c544d6dcdfd5a0fa3703f220de89ee5d16de8-1791332149632051000-16017`

Campaign status: **complete**

Mutations ran one at a time in a disposable archive of the selected Git revision. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `transpose-cpu-sprite-transform` | CPU transformed position follows the scene matrix law | **killed** | 12.04 s |
| `ignore-transformed-scene-paint-bounds` | transformed sprite culling uses screen-space bounds | **killed** | 124.81 s |
| `freeze-animated-image-clock` | animated image advances from the simulated clock | **killed** | 116.35 s |
| `drop-animated-image-remainder` | animated image preserves elapsed time across frame delays | **killed** | 119.28 s |
| `accept-conflicting-duplicate-report-pixels` | report collection rejects duplicate pixel conflicts | **invalid** | 81.79 s |
| `accept-reversed-gpu-timestamps` | GPU timestamp conversion rejects reversed intervals | **invalid** | 0 s |
| `use-submission-order-for-gpu-timestamp-envelope` | GPU timestamp envelope covers overlapping render passes | **invalid** | 0 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| CPU transformed position follows the scene matrix law | **passed** | 294.96 s |
| transformed sprite culling uses screen-space bounds | **passed** | 174.16 s |
| animated image advances from the simulated clock | **passed** | 3.92 s |
| report collection rejects duplicate pixel conflicts | **passed** | 131.09 s |
| GPU timestamp conversion rejects reversed intervals | **invalid** | 145.47 s |
| GPU timestamp envelope covers overlapping render passes | **invalid** | 3.21 s |

Baseline failure for GPU timestamp conversion rejects reversed intervals: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_wgpu --lib timestamp_duration_requires_a_valid_order_and_finite_range`

```text
running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 25 filtered out; finished in 0.00s
```

Baseline failure for GPU timestamp envelope covers overlapping render passes: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_wgpu --lib timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs`

```text
running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 25 filtered out; finished in 0.00s
```

## Trial details

### `transpose-cpu-sprite-transform` — killed

Transpose the row-major matrix when preparing CPU sprite coordinates.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --lib transformed_position_matches_the_scene_matrix_law`

```text
running 1 test
cpu::frame::transform_tests::transformed_position_matches_the_scene_matrix_law --- FAILED

failures:

---- cpu::frame::transform_tests::transformed_position_matches_the_scene_matrix_law stdout ----

thread 'cpu::frame::transform_tests::transformed_position_matches_the_scene_matrix_law' (87231041) panicked at crates/gpui_render/src/cpu/frame.rs:732:13:
assertion failed: (actual[0] - f32::from(expected.x)).abs() < 1e-5
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    cpu::frame::transform_tests::transformed_position_matches_the_scene_matrix_law

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 36 filtered out; finished in 0.00s
```

### `ignore-transformed-scene-paint-bounds` — killed

Cull transformed sprites using their untransformed bounds.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline -p gpui-ce --lib rotated_sprite_is_culled_when_only_its_untransformed_bounds_hit_the_mask`

```text
running 1 test
scene::tests::rotated_sprite_is_culled_when_only_its_untransformed_bounds_hit_the_mask --- FAILED

failures:

---- scene::tests::rotated_sprite_is_culled_when_only_its_untransformed_bounds_hit_the_mask stdout ----

thread 'scene::tests::rotated_sprite_is_culled_when_only_its_untransformed_bounds_hit_the_mask' (87698231) panicked at crates/gpui/src/scene.rs:1499:9:
assertion failed: scene.monochrome_sprites.is_empty()
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    scene::tests::rotated_sprite_is_culled_when_only_its_untransformed_bounds_hit_the_mask

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 397 filtered out; finished in 0.00s
```

### `freeze-animated-image-clock` — killed

Return the current image frame without consuming simulated elapsed time.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui-ce --lib animation_clock_preserves_elapsed_time_across_frame_delays`

```text
running 1 test
elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays --- FAILED

failures:

---- elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays stdout ----

thread 'elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays' (88157157) panicked at crates/gpui/src/elements/img.rs:908:9:
assertion `left == right` failed
  left: (0, 340ms)
 right: (2, 40ms)
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 397 filtered out; finished in 0.00s
```

### `drop-animated-image-remainder` — killed

Discard elapsed time remaining after a GIF frame-cycle boundary.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui-ce --lib animation_clock_preserves_elapsed_time_across_frame_delays`

```text
running 1 test
elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays --- FAILED

failures:

---- elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays stdout ----

thread 'elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays' (88601021) panicked at crates/gpui/src/elements/img.rs:908:9:
assertion `left == right` failed
  left: (0, 0ns)
 right: (2, 40ms)
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    elements::img::tests::animation_clock_preserves_elapsed_time_across_frame_delays

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 397 filtered out; finished in 0.00s
```

### `accept-conflicting-duplicate-report-pixels` — invalid

Skip checking canonical snapshots when duplicate report scenario IDs are collected.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test report_collection collect_reports_rejects_pixel_conflicts_for_duplicate_ids`

```text
running 1 test
collect_reports_rejects_pixel_conflicts_for_duplicate_ids --- FAILED

failures:

---- collect_reports_rejects_pixel_conflicts_for_duplicate_ids stdout ----

thread 'collect_reports_rejects_pixel_conflicts_for_duplicate_ids' (88877985) panicked at crates/gpui_test/tests/report_collection.rs:179:61:
called `Result::unwrap_err()` on an `Ok` value: RenderedSuite { scenarios: [RenderedScenario { id: "sample", title: "Sample scenario", viewport: Viewport { width: 4.0, height: 4.0, scale_factor: 1.0 }, font_pack: "fixture-pack", checkpoints: [RenderedCheckpoint { id: "frame", name: "Frame", time_ns: 0, capture: SceneCapture { version: 1, shadows: [], quads: [], paths: [], underlines: [], monochrome_sprites: [], subpixel_sprites: [], polychrome_sprites: [], backdrop_filters: [], filter_boundaries: [], commands: [], bitmaps: [] }, image: ImageBuffer { width: 4, height: 4, _phantom: PhantomData<image::color::Rgba<u8>>, color: CicpRgb { primaries: SRgb, transfer: SRgb, luminance: NonConstant }, data: [1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255, 1, 2, 3, 255] }, metrics: ScenarioMetrics { frame_count: 1, scene_build_p50_ns: 10, scene_build_p95_ns: 10, scene_build_p99_ns: 10, cpu_render_p50_ns: 20, cpu_render_p95_ns: 20, cpu_render_p99_ns: 20, primitive_count: 0, batch_count: 0, bitmap_storage_bytes: 0 }, native: None }] }], native_replay: None, platform_checks: None }
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    collect_reports_rejects_pixel_conflicts_for_duplicate_ids

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 8 filtered out; finished in 0.27s
```

### `accept-reversed-gpu-timestamps` — invalid

Saturate a reversed GPU timestamp interval to zero instead of rejecting it.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_wgpu --lib timestamp_duration_requires_a_valid_order_and_finite_range`

```text
focused check did not pass before mutation (invalid)
```

### `use-submission-order-for-gpu-timestamp-envelope` — invalid

Use submission order instead of the minimum start and maximum end across overlapping passes.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_wgpu --lib timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs`

```text
focused check did not pass before mutation (invalid)
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
