# Pseudo-mutation campaign

Source revision: `dc88d18908`

Run date: 2026-10-06 22:01 UTC

Mutations ran one at a time in a disposable `git archive HEAD` checkout. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `skip-underlines` | colored multiline Parley underline pixels | **invalid** | 17.61 s |
| `source-over-alpha` | source-over alpha property and unit law | **invalid** | 9.51 s |
| `ignore-glyph-transform` | transformed monochrome glyph destination pixels | **killed** | 7.93 s |
| `ignore-font-gamma` | analytic half-glyph gamma correction | **invalid** | 7.84 s |
| `ignore-subpixel-order` | RGB and BGR channel mapping | **killed** | 8.39 s |
| `drop-filter-opacity` | nested filter composite opacity and inline depth | **killed** | 7.26 s |
| `inline-boundary-not-stacked` | nested inline filter boundary stack law | **invalid** | 7.29 s |
| `path-half-open-edges` | path shared-edge pixel is rasterized once | **killed** | 8.5 s |
| `ignore-path-raster-clip` | clipped path gradient uses clipped paint bounds | **invalid** | 7.82 s |
| `ignore-path-content-clip` | path composite sprite bounds match the content clip | **killed** | 19.44 s |
| `freeze-animation-clock` | animation time advances and repeat phase | **invalid** | 28.0 s |
| `disable-animation-repeat` | repeat phase at 1250 ms returns near start | **invalid** | 12.7 s |
| `linearize-animation-easing` | analytic eased marker position at 250 ms | **invalid** | 12.76 s |
| `accept-unsupported-capture-version` | capture rejects unsupported format versions | **killed** | 60.04 s |
| `ignore-removed-checkpoints` | report comparison detects removed checkpoints | **killed** | 77.51 s |
| `drop-observation-events` | entity observation receives successive notify events | **killed** | 120.3 s |
| `ignore-selected-report-scenarios` | selected report comparison excludes unrelated scenario changes | **invalid** | 70.81 s |
| `compare-scene-values-without-persisting-json` | fractional capture compares equal after persisted JSON round trip | **killed** | 13.67 s |
| `undo-underline-y-down-offset` | bundled-font underline offset sign law | **killed** | 38.22 s |
| `undo-strikethrough-y-down-offset` | bundled-font strikethrough offset sign law | **killed** | 6.91 s |
| `retain-cpu-frame-ghosts` | retained frame matches fresh renderer after removals and resizes | **killed** | 52.48 s |
| `drop-above-alpha-clamp` | generated source-over alpha and out-of-range foreground edge | **invalid** | 18.46 s |
| `drop-below-alpha-clamp` | generated source-over alpha reference | **killed** | 22.68 s |
| `gpu-alpha-adds-destination-alpha` | native WGPU replay preserves analytic source-over alpha | **killed** | 61.19 s |
| `omit-supported-gpu-timestamps` | measured renderer enables timestamps supported by its selected adapter | **killed** | 6.58 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| colored multiline Parley underline pixels | **passed** | 341.6 s |
| source-over alpha property and unit law | **passed** | 102.18 s |
| transformed monochrome glyph destination pixels | **passed** | 1.9 s |
| analytic half-glyph gamma correction | **passed** | 0.6 s |
| RGB and BGR channel mapping | **passed** | 0.4 s |
| nested filter composite opacity and inline depth | **passed** | 7.29 s |
| path shared-edge pixel is rasterized once | **passed** | 0.4 s |
| clipped path gradient uses clipped paint bounds | **passed** | 0.39 s |
| path composite sprite bounds match the content clip | **passed** | 0.46 s |
| animation time advances and repeat phase | **passed** | 1.13 s |
| capture rejects unsupported format versions | **passed** | 2.11 s |
| report comparison detects removed checkpoints | **passed** | 0.7 s |
| entity observation receives successive notify events | **passed** | 135.91 s |
| selected report comparison excludes unrelated scenario changes | **passed** | 1.58 s |
| bundled-font underline offset sign law | **passed** | 153.12 s |
| retained frame matches fresh renderer after removals and resizes | **passed** | 1.78 s |
| generated source-over alpha and out-of-range foreground edge | **passed** | 0.95 s |
| native WGPU replay preserves analytic source-over alpha | **passed** | 75.75 s |

## Trial details

### `skip-underlines` — invalid

Skip drawing compiled underline batches.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines`

```text
running 1 test
wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines --- FAILED

failures:

---- wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines stdout ----

thread 'wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines' (64306541) panicked at crates/gpui_test/tests/state_regressions.rs:315:5:
the CPU raster must include colored underline pixels
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.03s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `source-over-alpha` — invalid

Replace accumulated alpha with foreground alpha in source-over.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs`

```text
running 1 test
overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs --- FAILED

failures:

---- overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 214
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 233

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 243

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 249

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 251

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 253

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 250

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 244

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 235

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 219

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 192

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 170

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 128

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (64354407) panicked at crates/gpui_render/tests/cpu_properties.rs:80:1:
Test failed: actual channel 255 differs from expected 128.
minimal failing input: below_byte = 1, above_byte = 1
	successes: 0
	local rejects: 0
	global rejects: 0



failures:
    overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-glyph-transform` — killed

Render monochrome glyphs without their scene transform.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties monochrome_glyph_samples_at_transformed_destination_coordinates`

```text
running 1 test
monochrome_glyph_samples_at_transformed_destination_coordinates --- FAILED

failures:

---- monochrome_glyph_samples_at_transformed_destination_coordinates stdout ----

thread 'monochrome_glyph_samples_at_transformed_destination_coordinates' (64396093) panicked at crates/gpui_render/tests/cpu_properties.rs:824:5:
assertion `left == right` failed: untransformed origin must remain clear
  left: [255, 0, 0, 255]
 right: [0, 0, 0, 0]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    monochrome_glyph_samples_at_transformed_destination_coordinates

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-font-gamma` — invalid

Force neutral coverage correction even when a platform requests gamma correction.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties font_gamma_correction_preserves_neutral_and_corrects_half_coverage`

```text
running 1 test
font_gamma_correction_preserves_neutral_and_corrects_half_coverage --- FAILED

failures:

---- font_gamma_correction_preserves_neutral_and_corrects_half_coverage stdout ----

thread 'font_gamma_correction_preserves_neutral_and_corrects_half_coverage' (64434865) panicked at crates/gpui_render/tests/cpu_properties.rs:639:5:
gamma 2.2 should map half coverage to about 0.769 alpha (196/255), got 128
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    font_gamma_correction_preserves_neutral_and_corrects_half_coverage

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s

error: test failed, to rerun pass `-p gpui_ce_render --test cpu_properties`
```

### `ignore-subpixel-order` — killed

Ignore the configured panel order when packing font rasterization uniforms.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties subpixel_order_reverses_red_and_blue_coverage_channels`

```text
running 1 test
subpixel_order_reverses_red_and_blue_coverage_channels --- FAILED

failures:

---- subpixel_order_reverses_red_and_blue_coverage_channels stdout ----

thread 'subpixel_order_reverses_red_and_blue_coverage_channels' (64477944) panicked at crates/gpui_render/tests/cpu_properties.rs:714:5:
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

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (64511858) panicked at crates/gpui_render/src/cpu.rs:411:9:
assertion `left == right` failed
  left: [255, 0, 0, 255]
 right: [255, 0, 0, 64]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 34 filtered out; finished in 0.00s
```

### `inline-boundary-not-stacked` — invalid

Fail to push the inline filter's matching stack marker.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (64548289) panicked at crates/gpui_render/src/cpu.rs:410:10:
called `Result::unwrap()` on an `Err` value: mismatched CPU filter command stream
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 34 filtered out; finished in 0.00s
```

### `path-half-open-edges` — killed

Treat every path triangle edge as included, double-covering shared pixels.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties adjacent_path_triangles_assign_shared_edge_pixels_once`

```text
running 1 test
adjacent_path_triangles_assign_shared_edge_pixels_once --- FAILED

failures:

---- adjacent_path_triangles_assign_shared_edge_pixels_once stdout ----

thread 'adjacent_path_triangles_assign_shared_edge_pixels_once' (64590117) panicked at crates/gpui_render/tests/cpu_properties.rs:378:5:
assertion `left == right` failed: the shared diagonal's pixel center must belong to exactly one triangle
  left: [191, 0, 0, 255]
 right: [255, 0, 0, 128]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    adjacent_path_triangles_assign_shared_edge_pixels_once

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-path-raster-clip` — invalid

Use the un-clipped path bounds when preparing the path paint gradient.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties clipped_path_gradient_uses_the_clipped_paint_bounds`

```text
running 1 test
clipped_path_gradient_uses_the_clipped_paint_bounds --- FAILED

failures:

---- clipped_path_gradient_uses_the_clipped_paint_bounds stdout ----

thread 'clipped_path_gradient_uses_the_clipped_paint_bounds' (64631023) panicked at crates/gpui_render/tests/cpu_properties.rs:330:9:
clipped 0-to-1 sRGB gradient at its midpoint should be near linear-light 55, got [18, 18, 18, 255]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    clipped_path_gradient_uses_the_clipped_paint_bounds

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `ignore-path-content-clip` — killed

Build the path composite sprite using raw path bounds rather than clipped bounds.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties path_composite_sprite_bounds_match_the_content_clip`

```text
running 1 test
path_composite_sprite_bounds_match_the_content_clip --- FAILED

failures:

---- path_composite_sprite_bounds_match_the_content_clip stdout ----

thread 'path_composite_sprite_bounds_match_the_content_clip' (64734615) panicked at crates/gpui_render/tests/cpu_properties.rs:353:5:
assertion `left == right` failed
  left: 0.0
 right: 0.25
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    path_composite_sprite_bounds_match_the_content_clip

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `freeze-animation-clock` — invalid

Ignore elapsed simulated time at each scenario checkpoint.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (64874058) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 0 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.27s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `disable-animation-repeat` — invalid

Remove repeat behavior from the gallery motion scenario.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (64934827) panicked at crates/gpui_test/tests/state_regressions.rs:76:5:
repeat phase at 1250 ms should be near its start: 180 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.41s
```

### `linearize-animation-easing` — invalid

Replace ease-in-out with linear progress.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (64996562) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 37 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.42s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `accept-unsupported-capture-version` — killed

Accept any positive serialized scene-capture version.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test capture_validation rejects_version_mutation_and_non_finite_filter_encoding`

```text
running 1 test
rejects_version_mutation_and_non_finite_filter_encoding --- FAILED

failures:

---- rejects_version_mutation_and_non_finite_filter_encoding stdout ----

thread 'rejects_version_mutation_and_non_finite_filter_encoding' (65292411) panicked at crates/gpui_render/tests/capture_validation.rs:165:5:
assertion failed: validate_json(unsupported).is_err()
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    rejects_version_mutation_and_non_finite_filter_encoding

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 6 filtered out; finished in 0.00s
```

### `ignore-removed-checkpoints` — killed

Omit baseline checkpoints that are absent from the current report.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (65615098) panicked at crates/gpui_test/tests/state_regressions.rs:232:5:
assertion `left == right` failed: unchanged fractional geometry must not produce spurious scene differences
  left: 0
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.28s
```

### `drop-observation-events` — killed

Do not enqueue observer notifications in the test observation stream.

Command: `cargo test --quiet --offline --locked -p gpui-ce --lib observation_stream_receives_each_notify_and_unsubscribes_on_drop`

```text
running 1 test
test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop --- FAILED

failures:

---- test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop stdout ----

thread 'test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop' (66132501) panicked at crates/gpui/src/test.rs:242:13:
assertion `left == right` failed
  left: None
 right: Some(())
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 391 filtered out; finished in 0.01s
```

### `ignore-selected-report-scenarios` — invalid

Compare every current scenario even when the report call selects a subset.

Command: `cargo test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (66473805) panicked at crates/gpui_test/tests/state_regressions.rs:222:5:
unselected additions and removals must be excluded: [ReportChange { kind: ScenarioAdded, scenario_id: "unrelated-new", checkpoint_id: None, detail: "scenario added" }, ReportChange { kind: CheckpointRemoved, scenario_id: "animation", checkpoint_id: Some("t250"), detail: "checkpoint removed" }]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.18s
```

### `compare-scene-values-without-persisting-json` — killed

Compare a freshly serialized capture instead of the serialized manifest scene bytes.

Command: `cargo test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (66535726) panicked at crates/gpui_test/tests/state_regressions.rs:232:5:
assertion `left == right` failed: unchanged fractional geometry must not produce spurious scene differences
  left: 3
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.09s
```

### `undo-underline-y-down-offset` — killed

Pass Parley's y-up underline offset directly into GPUI's y-down paint coordinates.

Command: `cargo test --quiet --offline -p gpui_ce_parley decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts`

```text
running 1 test
text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts --- FAILED

failures:

---- text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts stdout ----

thread 'text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts' (66727864) panicked at crates/gpui_ce_parley/src/text_system.rs:4003:13:
IBM Plex Sans: underline offset -1.5200001px should be positive and within descent 4.4px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 60 filtered out; finished in 0.01s
```

### `undo-strikethrough-y-down-offset` — killed

Pass Parley's y-up strikethrough offset directly into GPUI's y-down paint coordinates.

Command: `cargo test --quiet --offline -p gpui_ce_parley decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts`

```text
running 1 test
text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts --- FAILED

failures:

---- text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts stdout ----

thread 'text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts' (66764977) panicked at crates/gpui_ce_parley/src/text_system.rs:4008:13:
IBM Plex Sans: strikethrough offset 4.9440002px should be negative and within ascent 16.400002px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    text_system::tests::decoration_offsets_use_gpui_y_down_coordinates_for_bundled_fonts

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 60 filtered out; finished in 0.01s
```

### `retain-cpu-frame-ghosts` — killed

Skip clearing the retained CPU target before replaying the next scene.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes`

```text
running 1 test
retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes --- FAILED

failures:

---- retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'retained_cpu_frame_matches_fresh_renderer_after_generated_removals_and_resizes' (67046166) panicked at crates/gpui_render/tests/cpu_properties.rs:146:1:
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

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `drop-above-alpha-clamp` — invalid

Allow dithered foreground alpha outside the fixed-function blend range.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties shader_source_over_matches_independent_straight_alpha_reference`

```text
running 1 test
shader_source_over_matches_independent_straight_alpha_reference --- FAILED

failures:

---- shader_source_over_matches_independent_straight_alpha_reference stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'shader_source_over_matches_independent_straight_alpha_reference' (67144556) panicked at crates/gpui_render/tests/cpu_properties.rs:215:1:
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

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties shader_source_over_matches_independent_straight_alpha_reference`

```text
running 1 test
shader_source_over_matches_independent_straight_alpha_reference --- FAILED

failures:

---- shader_source_over_matches_independent_straight_alpha_reference stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs
proptest: Saving this and future failures in /private/var/folders/vf/qpw72bpn65g0y01bnbwf90n80000gn/T/gpui-pseudo-mutants-dfkxve5d/checkout/crates/gpui_render/tests/cpu_properties.proptest-regressions
proptest: If this test was run on a CI system, you may wish to add the following line to your copy of the file.
cc dc52eaf807f473c2ec744ab32412097de949d1a4dfc0e80aa1fe83bd9267dab7

thread 'shader_source_over_matches_independent_straight_alpha_reference' (67250414) panicked at crates/gpui_render/tests/cpu_properties.rs:215:1:
Test failed: source-over channel -0.20441215 differs from scalar reference 0 at crates/gpui_render/tests/cpu_properties.rs:242.
minimal failing input: below = (
    0.0,
    0.0,
    0.0,
    -0.20441215,
), above = (
    0.0,
    0.0,
    0.0,
    0.0,
)
	successes: 4
	local rejects: 0
	global rejects: 0

note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    shader_source_over_matches_independent_straight_alpha_reference

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s
```

### `gpu-alpha-adds-destination-alpha` — killed

Use additive destination alpha in WGPU source-over replay.

Command: `GPUI_REQUIRE_GPU=1 cargo test --quiet --offline -p gpui_ce_wgpu --features test-support --test capture_parity captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles`

```text
running 1 test
captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles --- FAILED

failures:

---- captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles stdout ----

thread 'captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles' (67522808) panicked at crates/gpui_wgpu/tests/capture_parity.rs:112:9:
blue over red GPU (6,2) channel 0: [64, 0, 128, 255], expected [85, 0, 170, 191] ±2
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 1.64s
```

### `omit-supported-gpu-timestamps` — killed

Never request optional encoder timestamp-query features for measured replay.

Command: `GPUI_REQUIRE_GPU=1 cargo test --quiet --offline -p gpui_ce_wgpu --features test-support --test capture_parity captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles`

```text
running 1 test
captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles --- FAILED

failures:

---- captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles stdout ----

thread 'captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles' (67561827) panicked at crates/gpui_wgpu/tests/capture_parity.rs:164:9:
assertion `left == right` failed: measurement renderer should enable timestamp queries when its selected adapter supports them
  left: false
 right: true
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    captured_gpu_replay_matches_analytic_alpha_masks_and_reloaded_tiles

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.48s
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
