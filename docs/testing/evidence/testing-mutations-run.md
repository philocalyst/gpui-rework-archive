# Pseudo-mutation campaign

Source revision: `a00a48972e`

Run date: 2026-10-06 20:13 UTC

Mutations ran one at a time in a disposable `git archive HEAD` checkout. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `skip-underlines` | colored multiline Parley underline pixels | **killed** | 15.24 s |
| `source-over-alpha` | source-over alpha property and unit law | **killed** | 8.87 s |
| `ignore-glyph-transform` | transformed monochrome glyph destination pixels | **killed** | 9.51 s |
| `ignore-font-gamma` | analytic half-glyph gamma correction | **killed** | 7.05 s |
| `ignore-subpixel-order` | RGB and BGR channel mapping | **killed** | 6.73 s |
| `drop-filter-opacity` | nested filter composite opacity and inline depth | **killed** | 6.07 s |
| `inline-boundary-not-stacked` | nested inline filter boundary stack law | **killed** | 6.3 s |
| `path-half-open-edges` | path shared-edge pixel is rasterized once | **killed** | 6.79 s |
| `ignore-path-raster-clip` | clipped path gradient uses clipped paint bounds | **killed** | 7.01 s |
| `ignore-path-content-clip` | path composite sprite bounds match the content clip | **killed** | 18.67 s |
| `freeze-animation-clock` | animation time advances and repeat phase | **killed** | 28.04 s |
| `disable-animation-repeat` | repeat phase at 1250 ms returns near start | **killed** | 10.06 s |
| `linearize-animation-easing` | analytic eased marker position at 250 ms | **killed** | 11.81 s |
| `accept-unsupported-capture-version` | capture rejects unsupported format versions | **killed** | 47.94 s |
| `ignore-removed-checkpoints` | report comparison detects removed checkpoints | **killed** | 53.32 s |
| `drop-observation-events` | entity observation receives successive notify events | **killed** | 90.02 s |
| `ignore-selected-report-scenarios` | selected report comparison excludes unrelated scenario changes | **killed** | 57.47 s |
| `compare-scene-values-without-persisting-json` | fractional capture compares equal after persisted JSON round trip | **killed** | 9.56 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| cargo test --offline -p gpui_ce_test --test state_regressions wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines | **passed** | 97.93 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs | **passed** | 60.75 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties monochrome_glyph_samples_at_transformed_destination_coordinates | **passed** | 0.69 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties font_gamma_correction_preserves_neutral_and_corrects_half_coverage | **passed** | 0.42 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties subpixel_order_reverses_red_and_blue_coverage_channels | **passed** | 0.45 s |
| cargo test --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target | **passed** | 6.38 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties adjacent_path_triangles_assign_shared_edge_pixels_once | **passed** | 0.44 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties clipped_path_gradient_uses_the_clipped_paint_bounds | **passed** | 0.47 s |
| cargo test --offline -p gpui_ce_render --features cpu --test cpu_properties path_composite_sprite_bounds_match_the_content_clip | **passed** | 0.49 s |
| cargo test --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries | **passed** | 0.83 s |
| cargo test --offline -p gpui_ce_render --features cpu --test capture_validation rejects_version_mutation_and_non_finite_filter_encoding | **passed** | 1.78 s |
| cargo test --offline -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints | **passed** | 0.71 s |
| cargo test --offline --locked -p gpui-ce --lib observation_stream_receives_each_notify_and_unsubscribes_on_drop | **passed** | 98.26 s |
| cargo test --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints | **passed** | 1.51 s |

## Trial details

### `skip-underlines` — killed

Skip drawing compiled underline batches.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines`

```text
running 1 test
wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines --- FAILED

failures:

---- wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines stdout ----

thread 'wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines' (37475494) panicked at crates/gpui_test/tests/state_regressions.rs:316:5:
the CPU raster must include colored underline pixels
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.03s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `source-over-alpha` — killed

Replace accumulated alpha with foreground alpha in source-over.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs`

```text
running 1 test
overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs --- FAILED

failures:

---- overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 214
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 233

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 243

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 249

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 251

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 253

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 250

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 244

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 235

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 219

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 192

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 170

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 128

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (37513771) panicked at crates/gpui_render/tests/cpu_properties.rs:80:1:
Test failed: actual channel 255 differs from expected 128.
minimal failing input: below_byte = 1, above_byte = 1
	successes: 0
	local rejects: 0
	global rejects: 0



failures:
    overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s
```

### `ignore-glyph-transform` — killed

Render monochrome glyphs without their scene transform.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties monochrome_glyph_samples_at_transformed_destination_coordinates`

```text
running 1 test
monochrome_glyph_samples_at_transformed_destination_coordinates --- FAILED

failures:

---- monochrome_glyph_samples_at_transformed_destination_coordinates stdout ----

thread 'monochrome_glyph_samples_at_transformed_destination_coordinates' (37548928) panicked at crates/gpui_render/tests/cpu_properties.rs:714:5:
assertion `left == right` failed: untransformed origin must remain clear
  left: [255, 0, 0, 255]
 right: [0, 0, 0, 0]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    monochrome_glyph_samples_at_transformed_destination_coordinates

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s
```

### `ignore-font-gamma` — killed

Force neutral coverage correction even when a platform requests gamma correction.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties font_gamma_correction_preserves_neutral_and_corrects_half_coverage`

```text
running 1 test
font_gamma_correction_preserves_neutral_and_corrects_half_coverage --- FAILED

failures:

---- font_gamma_correction_preserves_neutral_and_corrects_half_coverage stdout ----

thread 'font_gamma_correction_preserves_neutral_and_corrects_half_coverage' (37581308) panicked at crates/gpui_render/tests/cpu_properties.rs:529:5:
gamma 2.2 should map half coverage to about 0.769 alpha (196/255), got 128
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    font_gamma_correction_preserves_neutral_and_corrects_half_coverage

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s

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

thread 'subpixel_order_reverses_red_and_blue_coverage_channels' (37613520) panicked at crates/gpui_render/tests/cpu_properties.rs:604:5:
assertion `left == right` failed: BGR panel order reverses red and blue coverage lanes
  left: [255, 0, 0, 255]
 right: [0, 0, 255, 255]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    subpixel_order_reverses_red_and_blue_coverage_channels

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s
```

### `drop-filter-opacity` — killed

Ignore the content-filter group's opacity during compositing.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (37642909) panicked at crates/gpui_render/src/cpu.rs:384:9:
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

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (37671024) panicked at crates/gpui_render/src/cpu.rs:383:10:
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

thread 'adjacent_path_triangles_assign_shared_edge_pixels_once' (37703789) panicked at crates/gpui_render/tests/cpu_properties.rs:268:5:
assertion `left == right` failed: the shared diagonal's pixel center must belong to exactly one triangle
  left: [191, 0, 0, 255]
 right: [255, 0, 0, 128]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    adjacent_path_triangles_assign_shared_edge_pixels_once

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s
```

### `ignore-path-raster-clip` — killed

Use the un-clipped path bounds when preparing the path paint gradient.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties clipped_path_gradient_uses_the_clipped_paint_bounds`

```text
running 1 test
clipped_path_gradient_uses_the_clipped_paint_bounds --- FAILED

failures:

---- clipped_path_gradient_uses_the_clipped_paint_bounds stdout ----

thread 'clipped_path_gradient_uses_the_clipped_paint_bounds' (37737762) panicked at crates/gpui_render/tests/cpu_properties.rs:220:9:
clipped 0-to-1 sRGB gradient at its midpoint should be near linear-light 55, got [18, 18, 18, 255]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    clipped_path_gradient_uses_the_clipped_paint_bounds

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s
```

### `ignore-path-content-clip` — killed

Build the path composite sprite using raw path bounds rather than clipped bounds.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties path_composite_sprite_bounds_match_the_content_clip`

```text
running 1 test
path_composite_sprite_bounds_match_the_content_clip --- FAILED

failures:

---- path_composite_sprite_bounds_match_the_content_clip stdout ----

thread 'path_composite_sprite_bounds_match_the_content_clip' (37824773) panicked at crates/gpui_render/tests/cpu_properties.rs:243:5:
assertion `left == right` failed
  left: 0.0
 right: 0.25
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    path_composite_sprite_bounds_match_the_content_clip

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 18 filtered out; finished in 0.00s
```

### `freeze-animation-clock` — killed

Ignore elapsed simulated time at each scenario checkpoint.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (37947753) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 0 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.28s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `disable-animation-repeat` — killed

Remove repeat behavior from the gallery motion scenario.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (37993065) panicked at crates/gpui_test/tests/state_regressions.rs:76:5:
repeat phase at 1250 ms should be near its start: 180 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.26s
```

### `linearize-animation-easing` — killed

Replace ease-in-out with linear progress.

Command: `cargo test --quiet --offline -p gpui_ce_test --test state_regressions fixed_animation_times_are_idempotent_and_cross_repeat_boundaries`

```text
running 1 test
fixed_animation_times_are_idempotent_and_cross_repeat_boundaries --- FAILED

failures:

---- fixed_animation_times_are_idempotent_and_cross_repeat_boundaries stdout ----

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (38042706) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 37 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.19s

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

thread 'rejects_version_mutation_and_non_finite_filter_encoding' (38265498) panicked at crates/gpui_render/tests/capture_validation.rs:165:5:
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

thread 'report_comparison_reports_removed_checkpoints' (38511320) panicked at crates/gpui_test/tests/state_regressions.rs:233:5:
assertion `left == right` failed: unchanged fractional geometry must not produce spurious scene differences
  left: 0
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.13s
```

### `drop-observation-events` — killed

Do not enqueue observer notifications in the test observation stream.

Command: `cargo test --quiet --offline --locked -p gpui-ce --lib observation_stream_receives_each_notify_and_unsubscribes_on_drop`

```text
running 1 test
test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop --- FAILED

failures:

---- test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop stdout ----

thread 'test::tests::observation_stream_receives_each_notify_and_unsubscribes_on_drop' (38935699) panicked at crates/gpui/src/test.rs:242:13:
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

Command: `cargo test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (39191392) panicked at crates/gpui_test/tests/state_regressions.rs:223:5:
unselected additions and removals must be excluded: [ReportChange { kind: ScenarioAdded, scenario_id: "unrelated-new", checkpoint_id: None, detail: "scenario added" }, ReportChange { kind: CheckpointRemoved, scenario_id: "animation", checkpoint_id: Some("t250"), detail: "checkpoint removed" }]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.04s
```

### `compare-scene-values-without-persisting-json` — killed

Compare a freshly serialized capture instead of the serialized manifest scene bytes.

Command: `cargo test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (39234485) panicked at crates/gpui_test/tests/state_regressions.rs:233:5:
assertion `left == right` failed: unchanged fractional geometry must not produce spurious scene differences
  left: 3
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 4 filtered out; finished in 0.24s
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
