# Pseudo-mutation campaign

Source revision: `dc88d18908`

Run date: 2026-10-06 22:30 UTC

Mutations ran one at a time in a disposable `git archive HEAD` checkout. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `ignore-selected-report-scenarios` | selected report comparison excludes unrelated scenario changes | **killed** | 16.74 s |
| `drop-above-alpha-clamp` | generated source-over alpha and out-of-range foreground edge | **killed** | 28.66 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| selected report comparison excludes unrelated scenario changes | **passed** | 212.46 s |
| generated source-over alpha and out-of-range foreground edge | **passed** | 107.33 s |

## Trial details

### `ignore-selected-report-scenarios` — killed

Compare every current scenario even when the report call selects a subset.

Command: `cargo test --quiet --offline --locked -p gpui_ce_test --test state_regressions report_comparison_reports_removed_checkpoints`

```text
running 1 test
report_comparison_reports_removed_checkpoints --- FAILED

failures:

---- report_comparison_reports_removed_checkpoints stdout ----

thread 'report_comparison_reports_removed_checkpoints' (69522020) panicked at crates/gpui_test/tests/state_regressions.rs:222:5:
unselected additions and removals must be excluded: [ReportChange { kind: ScenarioAdded, scenario_id: "unrelated-new", checkpoint_id: None, detail: "scenario added" }, ReportChange { kind: CheckpointRemoved, scenario_id: "animation", checkpoint_id: Some("t250"), detail: "checkpoint removed" }]
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    report_comparison_reports_removed_checkpoints

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 5 filtered out; finished in 0.12s
```

### `drop-above-alpha-clamp` — killed

Allow dithered foreground alpha outside the fixed-function blend range.

Command: `cargo test --quiet --offline -p gpui_ce_render --features cpu --test cpu_properties shader_source_over_matches_independent_straight_alpha_reference`

```text
running 1 test
shader_source_over_matches_independent_straight_alpha_reference --- FAILED

failures:

---- shader_source_over_matches_independent_straight_alpha_reference stdout ----
proptest: FileFailurePersistence::SourceParallel set, but failed to find lib.rs or main.rs

thread 'shader_source_over_matches_independent_straight_alpha_reference' (69631768) panicked at crates/gpui_render/tests/cpu_properties.rs:215:1:
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

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The independent semantic checks use analytic alpha and geometry expectations, transformed sprite placement, fixed dispatcher times, restored scene capture validation, and explicit report checkpoint membership. Their results do not depend on frozen raster hash constants.
