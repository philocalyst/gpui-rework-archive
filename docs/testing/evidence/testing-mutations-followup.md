# Pseudo-mutation campaign

Source revision: `dc88d18908`

Run date: 2026-10-06 22:37 UTC

Mutations ran one at a time in a disposable `git archive HEAD` checkout. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `skip-underlines` | colored multiline Parley underline pixels | **killed** | 23.27 s |
| `source-over-alpha` | source-over alpha property and unit law | **killed** | 11.04 s |
| `ignore-font-gamma` | analytic half-glyph gamma correction | **killed** | 10.77 s |
| `inline-boundary-not-stacked` | nested inline filter boundary stack law | **killed** | 8.62 s |
| `ignore-path-raster-clip` | clipped path gradient uses clipped paint bounds | **killed** | 10.39 s |
| `freeze-animation-clock` | animation time advances and repeat phase | **killed** | 21.61 s |
| `disable-animation-repeat` | repeat phase at 1250 ms returns near start | **killed** | 15.16 s |
| `linearize-animation-easing` | analytic eased marker position at 250 ms | **killed** | 16.11 s |
| `ignore-selected-report-scenarios` | selected report comparison excludes unrelated scenario changes | **invalid** | 0 s |
| `drop-above-alpha-clamp` | generated source-over alpha and out-of-range foreground edge | **invalid** | 0 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| colored multiline Parley underline pixels | **passed** | 1.13 s |
| source-over alpha property and unit law | **passed** | 0.77 s |
| analytic half-glyph gamma correction | **passed** | 0.85 s |
| nested inline filter boundary stack law | **passed** | 10.98 s |
| clipped path gradient uses clipped paint bounds | **passed** | 0.72 s |
| animation time advances and repeat phase | **passed** | 1.15 s |
| selected report comparison excludes unrelated scenario changes | **invalid** | 1.2 s |
| generated source-over alpha and out-of-range foreground edge | **invalid** | 0.86 s |

## Trial details

### `skip-underlines` — killed

Skip drawing compiled underline batches.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_test --test state_regressions wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines`

```text
running 1 test
wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines --- FAILED

failures:

---- wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines stdout ----

thread 'wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines' (69838992) panicked at crates/gpui_test/tests/state_regressions.rs:315:5:
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

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 214
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 233

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 243

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 249

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 251

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 253

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 250

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 244

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 235

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 219

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 192

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 170

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:74:5:
actual channel 255 differs from expected 128

thread 'overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs' (69878836) panicked at crates/gpui_render/tests/cpu_properties.rs:80:1:
Test failed: actual channel 255 differs from expected 128.
minimal failing input: below_byte = 1, above_byte = 1
	successes: 0
	local rejects: 0
	global rejects: 0



failures:
    overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs

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

thread 'font_gamma_correction_preserves_neutral_and_corrects_half_coverage' (69922868) panicked at crates/gpui_render/tests/cpu_properties.rs:639:5:
gamma 2.2 should map half coverage to about 0.769 alpha (196/255), got 128
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    font_gamma_correction_preserves_neutral_and_corrects_half_coverage

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 20 filtered out; finished in 0.00s

error: test failed, to rerun pass `-p gpui_ce_render --test cpu_properties`
```

### `inline-boundary-not-stacked` — killed

Fail to push the inline filter's matching stack marker.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --lib nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target`

```text
running 1 test
cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target --- FAILED

failures:

---- cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target stdout ----

thread 'cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target' (69957360) panicked at crates/gpui_render/src/cpu.rs:410:10:
called `Result::unwrap()` on an `Err` value: mismatched CPU filter command stream
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    cpu::tests::nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 34 filtered out; finished in 0.00s
```

### `ignore-path-raster-clip` — killed

Use the un-clipped path bounds when preparing the path paint gradient.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties clipped_path_gradient_uses_the_clipped_paint_bounds`

```text
running 1 test
clipped_path_gradient_uses_the_clipped_paint_bounds --- FAILED

failures:

---- clipped_path_gradient_uses_the_clipped_paint_bounds stdout ----

thread 'clipped_path_gradient_uses_the_clipped_paint_bounds' (70002985) panicked at crates/gpui_render/tests/cpu_properties.rs:330:9:
clipped 0-to-1 sRGB gradient at its midpoint should be near linear-light 55, got [18, 18, 18, 255]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    clipped_path_gradient_uses_the_clipped_paint_bounds

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

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (70079135) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 0 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.56s

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

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (70142603) panicked at crates/gpui_test/tests/state_regressions.rs:76:5:
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

thread 'fixed_animation_times_are_idempotent_and_cross_repeat_boundaries' (70198312) panicked at crates/gpui_test/tests/state_regressions.rs:61:5:
ease-in-out at 250 ms should move about 16 px; got 37 px
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    fixed_animation_times_are_idempotent_and_cross_repeat_boundaries

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.50s

error: test failed, to rerun pass `-p gpui_ce_test --test state_regressions`
```

### `ignore-selected-report-scenarios` — invalid

Compare every current scenario even when the report call selects a subset.

Command: `cargo -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
focused check did not pass before mutation (invalid)
```

### `drop-above-alpha-clamp` — invalid

Allow dithered foreground alpha outside the fixed-function blend range.

Command: `cargo -Zchecksum-freshness test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties shader_source_over_matches_independent_straight_alpha_reference`

```text
focused check did not pass before mutation (invalid)
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
