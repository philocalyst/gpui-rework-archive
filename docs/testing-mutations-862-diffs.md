# Pseudo-mutation campaign

Source revision: `862b80a28e02719c78e04687e1d857be881f6182`

Run date: 2026-10-07 07:02 UTC

Cargo target directory: `/Users/mileswirht/.codex/worktrees/f239/gpui-ce3/target/pseudo-mutation/862b80a28e02719c78e04687e1d857be881f6182-1791356549276528000-39913`

Campaign status: **complete**

Mutations ran one at a time in a disposable archive of the selected Git revision. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `compare-scene-storage-bytes` | legacy JSON baseline compares semantically equal to gzip output | **killed** | 13.47 s |
| `ignore-alpha-only-visible-error` | alpha-only changes count as visible differences | **killed** | 3.95 s |
| `count-hidden-transparent-rgb-as-visible` | hidden transparent RGB changes stay invisible | **killed** | 3.62 s |
| `ignore-transparent-image-extent` | transparent out-of-bounds pixels count as exact size changes | **killed** | 3.67 s |
| `drop-motion-transition-error` | motion comparison detects a frozen current frame | **killed** | 4.94 s |
| `publish-after-failed-add` | failed report writes preserve the prior published report | **killed** | 15.14 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| legacy JSON baseline compares semantically equal to gzip output | **passed** | 172.29 s |
| alpha-only changes count as visible differences | **passed** | 4.48 s |
| hidden transparent RGB changes stay invisible | **passed** | 0.69 s |
| transparent out-of-bounds pixels count as exact size changes | **passed** | 0.63 s |
| motion comparison detects a frozen current frame | **passed** | 0.68 s |
| failed report writes preserve the prior published report | **passed** | 0.64 s |

## Trial details

### `compare-scene-storage-bytes` — killed

Compare stored scene bytes instead of the validated capture value, misclassifying equivalent legacy JSON and gzip encodings.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test report_collection gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json`

```text
running 1 test
gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json --- FAILED

failures:

---- gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json stdout ----

thread 'gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json' (146278695) panicked at crates/gpui_test/tests/report_collection.rs:220:5:
assertion `left == right` failed
  left: Some(true)
 right: Some(false)
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    gzip_scene_artifacts_are_deterministic_and_compare_equal_to_legacy_json

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 19 filtered out; finished in 0.12s
```

### `ignore-alpha-only-visible-error` — killed

Omit alpha differences from the alpha-aware visible error metrics.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --lib alpha_only_change_contributes_visible_error`

```text
running 1 test
image_diff::tests::alpha_only_change_contributes_visible_error --- FAILED

failures:

---- image_diff::tests::alpha_only_change_contributes_visible_error stdout ----

thread 'image_diff::tests::alpha_only_change_contributes_visible_error' (146300483) panicked at crates/gpui_test/src/image_diff.rs:372:9:
assertion `left == right` failed
  left: 0.35294117647058826
 right: 1.0
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    image_diff::tests::alpha_only_change_contributes_visible_error

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 14 filtered out; finished in 0.00s
```

### `count-hidden-transparent-rgb-as-visible` — killed

Compare straight RGB values instead of alpha-premultiplied channels when measuring visibility.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --lib invisible_transparent_rgb_changes_are_exact_but_not_visible`

```text
running 1 test
image_diff::tests::invisible_transparent_rgb_changes_are_exact_but_not_visible --- FAILED

failures:

---- image_diff::tests::invisible_transparent_rgb_changes_are_exact_but_not_visible stdout ----

thread 'image_diff::tests::invisible_transparent_rgb_changes_are_exact_but_not_visible' (146318192) panicked at crates/gpui_test/src/image_diff.rs:356:9:
assertion `left == right` failed
  left: 1
 right: 0
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    image_diff::tests::invisible_transparent_rgb_changes_are_exact_but_not_visible

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 14 filtered out; finished in 0.00s
```

### `ignore-transparent-image-extent` — killed

Treat transparent pixels outside one image's bounds as unchanged instead of exact extent changes.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --lib transparent_out_of_bounds_pixels_still_count_as_exact_size_changes`

```text
running 1 test
image_diff::tests::transparent_out_of_bounds_pixels_still_count_as_exact_size_changes --- FAILED

failures:

---- image_diff::tests::transparent_out_of_bounds_pixels_still_count_as_exact_size_changes stdout ----

thread 'image_diff::tests::transparent_out_of_bounds_pixels_still_count_as_exact_size_changes' (146336179) panicked at crates/gpui_test/src/image_diff.rs:409:9:
assertion `left == right` failed
  left: 0
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    image_diff::tests::transparent_out_of_bounds_pixels_still_count_as_exact_size_changes

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 14 filtered out; finished in 0.00s

error: test failed, to rerun pass `-p gpui_ce_test --lib`
```

### `drop-motion-transition-error` — killed

Ignore per-pixel signed motion deltas when comparing adjacent frames.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --lib motion_detects_a_frozen_frame_and_different_opacity`

```text
running 1 test
image_diff::tests::motion_detects_a_frozen_frame_and_different_opacity --- FAILED

failures:

---- image_diff::tests::motion_detects_a_frozen_frame_and_different_opacity stdout ----

thread 'image_diff::tests::motion_detects_a_frozen_frame_and_different_opacity' (146357487) panicked at crates/gpui_test/src/image_diff.rs:437:9:
assertion `left == right` failed
  left: 0
 right: 1
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    image_diff::tests::motion_detects_a_frozen_frame_and_different_opacity

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 14 filtered out; finished in 0.00s

error: test failed, to rerun pass `-p gpui_ce_test --lib`
```

### `publish-after-failed-add` — killed

Allow ReportWriter::finish to publish a staged report after an add operation failed.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --test report_collection failed_report_write_preserves_existing_report_and_refuses_unrelated_directories`

```text
running 1 test
failed_report_write_preserves_existing_report_and_refuses_unrelated_directories --- FAILED

failures:

---- failed_report_write_preserves_existing_report_and_refuses_unrelated_directories stdout ----

thread 'failed_report_write_preserves_existing_report_and_refuses_unrelated_directories' (146424694) panicked at crates/gpui_test/tests/report_collection.rs:355:5:
assertion failed: writer.finish().is_err()
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    failed_report_write_preserves_existing_report_and_refuses_unrelated_directories

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 19 filtered out; finished in 0.04s
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

These six checks assert semantic results directly: equivalent legacy JSON and gzip scene encodings compare equal, alpha-only and hidden-RGB changes have distinct visibility outcomes, transparent extents count as exact changes, frozen motion differs from a moving baseline, and a failed staged write cannot replace the prior report. None depends on frozen raster hashes.
