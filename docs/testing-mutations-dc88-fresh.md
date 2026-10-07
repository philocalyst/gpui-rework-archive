# Pseudo-mutation campaign

Source revision: `dc88d1890876ce09c910b755d4d59df3a6606991`

Run date: 2026-10-06 23:46 UTC

Cargo target directory: `/Users/mileswirht/.codex/worktrees/f239/gpui-ce3/target/pseudo-mutation/dc88d18908-1791327119832134000-55044`

Campaign status: **complete**

Mutations ran one at a time in a disposable archive of the selected Git revision. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `skip-underlines` | colored multiline Parley underline pixels | **killed** | 31.66 s |
| `source-over-alpha` | source-over alpha property and unit law | **killed** | 14.23 s |
| `ignore-glyph-transform` | transformed monochrome glyph destination pixels | **killed** | 16.25 s |
| `ignore-font-gamma` | analytic half-glyph gamma correction | **killed** | 15.32 s |
| `ignore-subpixel-order` | RGB and BGR channel mapping | **killed** | 13.6 s |
| `drop-filter-opacity` | nested filter composite opacity and inline depth | **killed** | 14.68 s |
| `inline-boundary-not-stacked` | nested inline filter boundary stack law | **killed** | 23.64 s |
| `path-half-open-edges` | path shared-edge pixel is rasterized once | **killed** | 22.65 s |
| `ignore-path-raster-clip` | clipped path gradient uses clipped paint bounds | **killed** | 21.71 s |
| `ignore-path-content-clip` | path composite sprite bounds match the content clip | **killed** | 43.18 s |
| `freeze-animation-clock` | animation time advances and repeat phase | **killed** | 53.7 s |
| `disable-animation-repeat` | repeat phase at 1250 ms returns near start | **killed** | 20.38 s |
| `linearize-animation-easing` | analytic eased marker position at 250 ms | **killed** | 36.65 s |
| `accept-unsupported-capture-version` | capture rejects unsupported format versions | **killed** | 88.04 s |
| `ignore-removed-checkpoints` | report comparison detects removed checkpoints | **killed** | 128.72 s |
| `drop-observation-events` | entity observation receives successive notify events | **killed** | 131.02 s |
| `ignore-selected-report-scenarios` | selected report comparison excludes unrelated scenario changes | **killed** | 87.99 s |
| `compare-scene-values-without-persisting-json` | fractional capture compares equal after persisted JSON round trip | **killed** | 20.12 s |
| `undo-underline-y-down-offset` | bundled-font underline offset sign law | **killed** | 60.84 s |
| `undo-strikethrough-y-down-offset` | bundled-font strikethrough offset sign law | **killed** | 11.15 s |
| `retain-cpu-frame-ghosts` | retained frame matches fresh renderer after removals and resizes | **killed** | 86.54 s |
| `drop-above-alpha-clamp` | generated source-over alpha and out-of-range foreground edge | **killed** | 59.24 s |
| `drop-below-alpha-clamp` | generated source-over alpha reference | **killed** | 50.59 s |
| `gpu-alpha-adds-destination-alpha` | native WGPU replay preserves analytic source-over alpha | **killed** | 104.49 s |
| `omit-supported-gpu-timestamps` | measured renderer enables timestamps supported by its selected adapter | **killed** | 12.21 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| colored multiline Parley underline pixels | **passed** | 1.72 s |
| source-over alpha property and unit law | **passed** | 1.24 s |
| transformed monochrome glyph destination pixels | **passed** | 1.47 s |
| analytic half-glyph gamma correction | **passed** | 1.18 s |
| RGB and BGR channel mapping | **passed** | 0.99 s |
| nested filter composite opacity and inline depth | **passed** | 0.94 s |
| path shared-edge pixel is rasterized once | **passed** | 0.91 s |
| clipped path gradient uses clipped paint bounds | **passed** | 0.81 s |
| path composite sprite bounds match the content clip | **passed** | 1.32 s |
| animation time advances and repeat phase | **passed** | 2.88 s |
| capture rejects unsupported format versions | **passed** | 0.8 s |
| report comparison detects removed checkpoints | **passed** | 1.28 s |
| entity observation receives successive notify events | **passed** | 81.32 s |
| selected report comparison excludes unrelated scenario changes | **passed** | 2.28 s |
| bundled-font underline offset sign law | **passed** | 144.17 s |
| retained frame matches fresh renderer after removals and resizes | **passed** | 3.44 s |
| generated source-over alpha and out-of-range foreground edge | **passed** | 1.02 s |
| native WGPU replay preserves analytic source-over alpha | **passed** | 123.7 s |

## Trial details

### `skip-underlines` — killed

Skip drawing compiled underline batches.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_test --test state_regressions wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines`

```text
running 1 test
wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines --- FAILED

failures:

---- wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines stdout ----

thread 'wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines' (80402059) panicked at crates/gpui_test/tests/state_regressions.rs:315:5:
the CPU raster must include colored underline pixels
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.07s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `source-over-alpha` — killed

Replace accumulated alpha with foreground alpha in source-over.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs`

```text
running 1 test
overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs --- FAILED

failures:

---- overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 214
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 233

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 243

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 249

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 251

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 253

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 250

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 244

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 235

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 219

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 192

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 170

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 128

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (80447543) panicked at crates/gpui_render/tests/cpu_properties.rs:80:1:
Test failed: actual channel 255 differs from expected 128.
minimal failing input: below_byte = 1, above_byte = 1
	successes: 0
	local rejects: 0
	global rejects: 0



failures:
    overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.01s
```

### `ignore-glyph-transform` — killed

Render monochrome glyphs without their scene transform.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties monochrome_glyph_samples_at_transformed_destination_coordinates`

```text
running 1 test
monochrome_glyph_samples_at_transformed_destination_coordinates --- FAILED

failures:

---- monochrome_glyph_samples_at_transformed_destination_coordinates stdout ----

thread 'monochrome_glyph_samples_at_transformed_destination_coordinates' (80492280) panicked at crates/gpui_render/tests/cpu_properties.rs:824:5:
assertion `left == right` failed: untransformed origin must remain clear
  left: [255, 0, 0, 255]
 right: [0, 0, 0, 0]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    monochrome_glyph_samples_at_transformed_destination_coordinates

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-font-gamma` — killed

Force neutral coverage correction even when a platform requests gamma correction.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties font_gamma_correction_preserves_neutral_and_corrects_half_coverage`

```text
running 1 test
font_gamma_correction_preserves_neutral_and_corrects_half_coverage --- FAILED

failures:

---- font_gamma_correction_preserves_neutral_and_corrects_half_coverage stdout ----

thread 'font_gamma_correction_preserves_neutral_and_corrects_half_coverage' (80547334) panicked at crates/gpui_render/tests/cpu_properties.rs:639:5:
gamma 2.2 should map half coverage to about 0.769 alpha (196/255), got 128
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    font_gamma_correction_preserves_neutral_and_corrects_half_coverage

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s

error: test failed, to rerun pass `-p gpui_ce_render --test cpu_properties`
```

### `ignore-subpixel-order` — killed

Ignore the configured panel order when packing font rasterization uniforms.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties subpixel_order_reverses_red_and_blue_coverage_channels`

```text
running 1 test
subpixel_order_reverses_red_and_blue_coverage_channels --- FAILED

failures:

---- subpixel_order_reverses_red_and_blue_coverage_channels stdout ----

thread 'subpixel_order_reverses_red_and_blue_coverage_channels' (80602722) panicked at crates/gpui_render/tests/cpu_properties.rs:714:5:
assertion `left == right` failed: BGR panel order reverses red and blue coverage lanes
  left: [255, 0, 0, 255]
 right: [0, 0, 255, 255]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    subpixel_order_reverses_red_and_blue_coverage_channels

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `drop-filter-opacity` — killed

Ignore the content-filter group's opacity during compositing.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (80649736) panicked at crates/gpui_render/src/cpu.rs:411:9:
assertion `left == right` failed
  left: [255, 0, 0, 255]
 right: [255, 0, 0, 64]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 34 filtered out; finished in 0.00s
```

### `inline-boundary-not-stacked` — killed

Fail to push the inline filter's matching stack marker.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (80710987) panicked at crates/gpui_render/src/cpu.rs:410:10:
called `Result::unwrap()` on an `Err` value: mismatched CPU filter command stream
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 34 filtered out; finished in 0.00s
```

### `path-half-open-edges` — killed

Treat every path triangle edge as included, double-covering shared pixels.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties adjacent_path_triangles_assign_shared_edge_pixels_once`

```text
running 1 test
adjacent_path_triangles_assign_shared_edge_pixels_once --- FAILED

failures:

---- adjacent_path_triangles_assign_shared_edge_pixels_once stdout ----

thread 'adjacent_path_triangles_assign_shared_edge_pixels_once' (80772078) panicked at crates/gpui_render/tests/cpu_properties.rs:378:5:
assertion `left == right` failed: the shared diagonal's pixel center must belong to exactly one triangle
  left: [191, 0, 0, 255]
 right: [255, 0, 0, 128]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    adjacent_path_triangles_assign_shared_edge_pixels_once

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-path-raster-clip` — killed

Use the un-clipped path bounds when preparing the path paint gradient.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties clipped_path_gradient_uses_the_clipped_paint_bounds`

```text
running 1 test
clipped_path_gradient_uses_the_clipped_paint_bounds --- FAILED

failures:

---- clipped_path_gradient_uses_the_clipped_paint_bounds stdout ----

thread 'clipped_path_gradient_uses_the_clipped_paint_bounds' (80820845) panicked at crates/gpui_render/tests/cpu_properties.rs:330:9:
clipped 0-to-1 sRGB gradient at its midpoint should be near linear-light 55, got [18, 18, 18, 255]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    clipped_path_gradient_uses_the_clipped_paint_bounds

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-path-content-clip` — killed

Build the path composite sprite using raw path bounds rather than clipped bounds.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties path_composite_sprite_bounds_match_the_content_clip`

```text
running 1 test
path_composite_sprite_bounds_match_the_content_clip --- FAILED

failures:

---- path_composite_sprite_bounds_match_the_content_clip stdout ----

thread 'path_composite_sprite_bounds_match_the_content_clip' (80945172) panicked at crates/gpui_render/tests/cpu_properties.rs:353:5:
assertion `left == right` failed
  left: 0.0
 right: 0.25
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    path_composite_sprite_bounds_match_the_content_clip

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `freeze-animation-clock` — killed

Ignore elapsed simulated time at each scenario checkpoint.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (81128126) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 0 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.54s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `disable-animation-repeat` — killed

Remove repeat behavior from the gallery motion scenario.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (81196526) panicked at crates/gpui_test/tests/state_regressions.rs:76:5:
repeat phase at 1250 ms should be near its start: 180 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.50s
```

### `linearize-animation-easing` — killed

Replace ease-in-out with linear progress.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (81297000) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 37 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.43s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `accept-unsupported-capture-version` — killed

Accept any positive serialized scene-capture version.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test capture_validation rejects_version_mutation_and_non_finite_filter_encoding`

```text
running 1 test
rejects_version_mutation_and_non_finite_filter_encoding --- FAILED

failures:

---- rejects_version_mutation_and_non_finite_filter_encoding stdout ----

thread 'rejects_version_mutation_and_non_finite_filter_encoding' (81618933) panicked at crates/gpui_render/tests/capture_validation.rs:165:5:
assertion failed: validate_json(unsupported).is_err()
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    rejects_version_mutation_and_non_finite_filter_encoding

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 6 filtered out; finished in 0.00s
```

### `ignore-removed-checkpoints` — killed

Omit baseline checkpoints that are absent from the current report.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (82014581) panicked at crates/gpui_test/tests/state_regressions.rs:232:5:
assertion `left == right` failed: unchanged fractional geometry must not produce spurious scene differences
  left: 0
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.03s
```

### `drop-observation-events` — killed

Do not enqueue observer notifications in the test observation stream.

Command: `cargo -Zchecksum-freshness test --quiet --offline --locked -p gpui-ce --lib observation_stream_receives_each_notify_and_unsubscribes_on_drop`

```text
running 1 test
test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop --- FAILED

failures:

---- test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop stdout ----

thread 'test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop' (82478486) panicked at crates/gpui/src/test.rs:242:13:
assertion `left == right` failed
  left: None
 right: Some(())
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 391 filtered out; finished in 0.01s
```

### `ignore-selected-report-scenarios` — killed

Compare every current scenario even when the report call selects a subset.

Command: `cargo -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (82793138) panicked at crates/gpui_test/tests/state_regressions.rs:222:5:
unselected additions and removals must be excluded: [ReportChange { kind: ScenarioAdded, scenario_id: "unrelated-new", checkpoint_id: None, detail: "scenario added" }, ReportChange { kind: CheckpointRemoved, scenario_id: "animation", checkpoint_id: Some("t250"), detail: "checkpoint removed" }]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.16s
```

### `compare-scene-values-without-persisting-json` — killed

Compare a freshly serialized capture instead of the serialized manifest scene bytes.

Command: `cargo -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (82863609) panicked at crates/gpui_test/tests/state_regressions.rs:232:5:
assertion `left == right` failed: unchanged fractional geometry must not produce spurious scene differences
  left: 3
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.12s
```

### `undo-underline-y-down-offset` — killed

Pass Parley's y-up underline offset directly into GPUI's y-down paint coordinates.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_parley decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts`

```text
running 1 test
text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts --- FAILED

failures:

---- text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts stdout ----

thread 'text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts' (83065294) panicked at crates/gpui_ce_parley/src/text_system.rs:4003:13:
IBM Plex Sans: underline offset -1.5200001px should be positive and within descent 4.4px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 60 filtered out; finished in 0.01s
```

### `undo-strikethrough-y-down-offset` — killed

Pass Parley's y-up strikethrough offset directly into GPUI's y-down paint coordinates.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_parley decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts`

```text
running 1 test
text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts --- FAILED

failures:

---- text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts stdout ----

thread 'text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts' (83109878) panicked at crates/gpui_ce_parley/src/text_system.rs:4008:13:
IBM Plex Sans: strikethrough offset 4.9440002px should be negative and within ascent 16.400002px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 60 filtered out; finished in 0.01s
```

### `retain-cpu-frame-ghosts` — killed

Skip clearing the retained CPU target before replaying the next scene.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes`

```text
running 1 test
retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes --- FAILED

failures:

---- retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes' (83426264) panicked at crates/gpui_render/tests/cpu_properties.rs:146:1:
Test failed: assertion failed: `(left == right)` 
  left: `[255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255]`, 
 right: `[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]`: retained frame differs at step 1, size 8x6, mode 0 at crates/gpui_render/tests/cpu_properties.rs:202.
minimal failing input: generated = []
	successes: 0
	local rejects: 0
	global rejects: 0

note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.01s
```

### `drop-above-alpha-clamp` — killed

Allow dithered foreground alpha outside the fixed-function blend range.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties shader_source_over_matches_independent_straight_alpha_reference`

```text
running 1 test
shader_source_over_matches_independent_straight_alpha_reference --- FAILED

failures:

---- shader_source_over_matches_independent_straight_alpha_reference stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'shader_source_over_matches_independent_straight_alpha_reference' (83585673) panicked at crates/gpui_render/tests/cpu_properties.rs:215:1:
Test failed: alpha above one over opaque black should be clamped to an opaque red result: Vec4 { x: 1.25, y: 0.0, z: 0.0, w: 1.0 } at crates/gpui_render/tests/cpu_properties.rs:251.
minimal failing input: below = (
    0.0,
    0.0,
    0.0,
    0.0,
), above = (
    0.0,
    0.0,
    0.0,
    0.0,
)
	successes: 0
	local rejects: 0
	global rejects: 0

note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    shader_source_over_matches_independent_straight_alpha_reference

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `drop-below-alpha-clamp` — killed

Allow dithered destination alpha outside the fixed-function blend range.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties shader_source_over_matches_independent_straight_alpha_reference`

```text
running 1 test
shader_source_over_matches_independent_straight_alpha_reference --- FAILED

failures:

---- shader_source_over_matches_independent_straight_alpha_reference stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs
proptest: Saving this and future failures in /private/var/folders/vf/qpw72bpn65g0y01bnbwf90n80000gn/T/gpui-pseudo-mutants-6xixxf30/checkout/crates/gpui_render/tests/cpu_properties.proptest-regressions
proptest: If this test was run on a CI system, you may wish to add the following line to your copy of the file.
cc dc612aba483a38fbd503b7bd2452b9038e8836fbc1633acc0e11a42de02e4bcd

thread 'shader_source_over_matches_independent_straight_alpha_reference' (83741507) panicked at crates/gpui_render/tests/cpu_properties.rs:215:1:
Test failed: source-over channel 1.1032203 differs from scalar reference 1 at crates/gpui_render/tests/cpu_properties.rs:242.
minimal failing input: below = (
    0.0,
    0.0,
    0.0,
    1.1032203,
), above = (
    0.0,
    0.0,
    0.0,
    0.0,
)
	successes: 0
	local rejects: 0
	global rejects: 0

note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    shader_source_over_matches_independent_straight_alpha_reference

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `gpu-alpha-adds-destination-alpha` — killed

Use additive destination alpha in WGPU source-over replay.

Command: `GPUI_REQUIRE_GPU=1 cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_wgpu --features test-support --test capture_parity captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles`

```text
running 1 test
captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles --- FAILED

failures:

---- captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles stdout ----

thread 'captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles' (84030189) panicked at crates/gpui_wgpu/tests/capture_parity.rs:112:9:
blue over red GPU (6,2) channel 0: [64, 0, 128, 255], expected [85, 0, 170, 191] ±2
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 2.26s
```

### `omit-supported-gpu-timestamps` — killed

Never request optional encoder timestamp-query features for measured replay.

Command: `GPUI_REQUIRE_GPU=1 cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_wgpu --features test-support --test capture_parity captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles`

```text
running 1 test
captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles --- FAILED

failures:

---- captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles stdout ----

thread 'captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles' (84068763) panicked at crates/gpui_wgpu/tests/capture_parity.rs:164:9:
assertion `left == right` failed: measurement renderer should enable timestamp queries when its selected adapter supports them
  left: false
 right: true
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.58s
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
