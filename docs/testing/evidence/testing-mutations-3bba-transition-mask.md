# Pseudo-mutation campaign

Source revision: `3bba425cb91f89d0693e2b6db9f6805697daded1`

Run date: 2026-10-07 07:16 UTC

Cargo target directory: `/Users/mileswirht/.codex/worktrees/f239/gpui-ce3/target/pseudo-mutation/3bba425cb91f89d0693e2b6db9f6805697daded1-1791357384339980000-1757`

Campaign status: **complete**

Mutations ran one at a time in a disposable archive of the selected Git revision. Source files were restored after each trial, and the caller's working tree was not modified.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `drop-transition-exact-mask` | transition visualization marks motion, transparent extent, and catch-up differences | **killed** | 4.03 s |

## Luna baseline checks

Each focused test command ran once against the unmutated archived source first. Only baseline-passing checks count as mutation evidence.

| Focused check | Result | Time |
|---|---:|---:|
| transition visualization marks motion, transparent extent, and catch-up differences | **passed** | 209.69 s |

## Trial details

### `drop-transition-exact-mask` — killed

Render the checkerboard context instead of a red mask for motion-difference pixels.

Command: `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet --offline --locked -p gpui_ce_test --lib transition_visualization_marks_motion_and_transparent_extent`

```text
running 1 test
image_diff::tests::transition_visualization_marks_motion_and_transparent_extent --- FAILED

failures:

---- image_diff::tests::transition_visualization_marks_motion_and_transparent_extent stdout ----

thread 'image_diff::tests::transition_visualization_marks_motion_and_transparent_extent' (150748641) panicked at crates/gpui_test/src/image_diff.rs:581:9:
assertion `left == right` failed
  left: Rgba([40, 0, 0, 255])
 right: Rgba([255, 32, 32, 255])
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace


failures:
    image_diff::tests::transition_visualization_marks_motion_and_transparent_extent

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured; 16 filtered out; finished in 0.00s
```

## Interpretation

`killed` means a test ran and failed by assertion. `survived` means the focused check completed successfully after the source mutation. `invalid` means the mutant did not provide behavioral evidence because compilation, setup, or test selection failed. `timeout` is inconclusive.

The focused semantic check asserts that changed motion pixels receive the exact red mask, unchanged pixels retain their context, transparent extent changes are marked, and a frame that catches up still shows its differing transition. It does not depend on a frozen raster hash.
