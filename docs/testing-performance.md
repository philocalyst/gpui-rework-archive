# Report collection profile

These measurements exercise `gpui-test collect` over saved report directories. They do not rerender scenarios or use `--gpu`. Peak memory is the macOS `/usr/bin/time -lp` “maximum resident set size” value; wall time includes reading and validating scene/image artifacts, duplicate comparison when present, staging the destination, writing artifacts, and regenerating report views.

## Retained optimized run

The release binary was built from `862b80a28e02719c78e04687e1d857be881f6182` with `rustc 1.101.0-nightly (5c543b0b8, 2026-09-29)` for `aarch64-apple-darwin` on macOS 15.7.4 / Apple M3 Pro. The input manifests carry report provenance `458c43e9a05cd2385079de3959773d3c04e9d330`, the source revision used to capture the original frames.

The workload contains 29 scenarios, 78 checkpoints, and 28,886,264 bytes across `target/visual-final/combined-v2`. Both retained inputs use `.scene.json.gz` captures. The duplicate run adds `/tmp/gpui-report-fast-single`; all scenario IDs matched, scene JSON and PNG bytes matched between inputs, and the output retained CPU and native metrics from the first input.

| Inputs | Wall | User | System | Peak RSS | Raw log | Output |
|---|---:|---:|---:|---:|---|---|
| `combined-v2` | 3.22 s | 1.27 s | 0.30 s | 191,840,256 B (182.95 MiB) | `/tmp/gpui-report-final-v2-single.time.log` | `/tmp/gpui-report-final-v2-single` |
| `combined-v2` + `gpui-report-fast-single` | 2.93 s | 1.29 s | 0.33 s | 209,321,984 B (199.63 MiB) | `/tmp/gpui-report-final-v2-duplicate.time.log` | `/tmp/gpui-report-final-v2-duplicate` |

The final runner at `fdec165b0e` also skips channel analysis when both frame pairs are byte-identical. A follow-up used the regenerated `combined-v3` report, with the same 29 scenarios and 78 checkpoints. Its duplicate input was the single run's output. All primary PNGs, compressed scenes, source provenance, and CPU/native timing samples were preserved again.

| Inputs | Wall | User | System | Peak RSS | Raw log |
|---|---:|---:|---:|---:|---|
| `combined-v3` | 3.14 s | 0.92 s | 0.24 s | 197,885,952 B (188.72 MiB) | `/tmp/gpui-report-fdec-single.time.log` |
| `combined-v3` + `gpui-report-fdec-single` | 3.45 s | 0.96 s | 0.26 s | 209,338,368 B (199.64 MiB) | `/tmp/gpui-report-fdec-duplicate.time.log` |

These are individual runs, not a statistical performance budget. Wall time varies with scheduling and filesystem state; CPU time and peak memory are reported separately. The final outputs are `/tmp/gpui-report-fdec-single` and `/tmp/gpui-report-fdec-duplicate`.

## Earlier profile reference

An earlier session profile recorded approximately 2.06 s wall / 0.94 s user and 433 MB peak RSS for one combined report, and 5.82 s wall / 3.63 s user and 960 MB peak RSS for the same report supplied twice. The workload was described as 29 scenarios and 78 checkpoints, with an approximately 22.5 MB report bundle. Its raw timing logs, exact byte counts, executable source revision, and scene encoding cannot be verified from retained files, so these figures are a contextual reference rather than a reproducible before measurement.

The current writer stages a complete destination before replacing it and writes native heatmaps. The earlier profile predates that output work. Therefore, the wall times do not isolate the duplicate-comparison optimization and should not be read as a universal speedup. The current peak-RSS figures are exact for the retained runs; the earlier RSS values are approximate session records. Re-run both profiles from the same binary and input directories when a strict before/after comparison is needed.
