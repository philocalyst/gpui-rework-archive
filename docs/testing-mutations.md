# Pseudo-mutation testing

The runner applies one source mutation at a time in a disposable archive of a pinned Git revision. It restores each edited file after its trial and does not change the caller's checkout. Every focused test must pass on the unmutated source first. A mutation counts as killed only when the selected test fails with its expected assertion evidence; compilation failures, setup errors, zero selected tests, and timeouts are reported separately.

| Source revision | Mutations | Result | Evidence |
|---|---:|---|---|
| `dc88d1890876ce09c910b755d4d59df3a6606991` | 25 | **25 killed, 0 survived, 0 invalid, 0 timed out** | [Full Luna report](testing-mutations-dc88-fresh.md) |
| `cf2c544d6dcdfd5a0fa3703f220de89ee5d16de8` | 7 runtime-specific | First run: **4 killed, 0 survived, 3 invalid, 0 timed out**. The three invalids were rerun separately below. | [First run](testing-mutations-cf2-runtime.md) |
| `cf2c544d6dcdfd5a0fa3703f220de89ee5d16de8` | 3 corrected retries | **3 killed, 0 survived, 0 invalid, 0 timed out**. | [Corrected rerun](testing-mutations-cf2-runtime-followup.md) |
| `862b80a28e02719c78e04687e1d857be881f6182` | 6 report/diff mutations | **6 killed, 0 survived, 0 invalid, 0 timed out**. | [Fresh Luna report](testing-mutations-862-diffs.md) |

The two cf2 reports cover seven distinct runtime mutations: CPU matrix convention, transformed scene culling, animated-image clock and remainder, duplicate-report pixel conflicts, and reversed or misordered GPU timestamps. The first report's two timestamp cases had zero selected tests because the WGPU unit tests require `test-support`; the duplicate-pixel case failed the intended `unwrap_err()` assertion, but the classifier initially lacked that exact panic marker. The follow-up adds the feature flag and marker and records three clean baseline passes followed by three assertion kills. Do not read the two reports as one 7-mutant run.

The dc88 run covers rendering semantics, path clipping, capture validation, report comparison, observation events, Parley decoration placement, retained CPU-frame clearing, alpha limits, and native WGPU replay. Its dedicated Cargo cache passed every focused baseline before mutation trials. Full 32-mutant anchor preflight passed on both cf2 and the final artifact implementation at `8248d464cf`; the campaign results above retain their tested source revisions.

The 862 campaign covers equivalent legacy/gzip scene storage, alpha-only errors, invisible transparent RGB, transparent image extents, frozen transitions, and failed-writer publication. All six pristine checks passed before the corresponding assertion kills. Its 37 active mutation anchors passed preflight on that exact revision. One older JSON-value-comparison mutation was retired because comparison now uses validated `SceneCapture` values directly; its historical evidence remains above. Preflight confirms that anchors apply, not that every older mutation was rerun at 862.

To run the current default campaign, install the pinned nightly and run:

```sh
rustup toolchain install nightly-2026-09-30
python3 scripts/testing/pseudo_mutation.py --timeout-seconds 600 --report docs/testing-mutations-run.md
```

The runner invokes `cargo +nightly-2026-09-30 -Zchecksum-freshness test --quiet ...`. Each campaign receives a unique cache below `target/pseudo-mutation/<revision>-<run-id>`, so its mutated executables cannot contaminate ordinary builds or another campaign. Preflight requires every selected source anchor exactly once. On timeout, it terminates the Cargo process tree (POSIX process group or bounded Windows `taskkill /T`), then records the result as inconclusive.

## Historical evidence and limitations

The initial campaign at `0103d685c6` recorded **11 killed and 1 survivor**. The survivor widened CPU path raster bounds while later compositing still clipped the sprite, leaving that particular solid-path test unchanged. Later gradient-paint and direct composite-bounds laws closed that gap. This historical count is kept distinct from the completed dc88 result above.

One earlier run reused the ordinary Cargo target directory and contaminated a concurrently generated benchmark executable with a mutant. Its evidence was discarded and the benchmark was rebuilt from unmutated source. The [first dc88 attempt](testing-mutations-dc88-first-attempt.md) also had invalid classifications caused by missing assertion markers and stale artifacts in a reused cache; those trials were not counted. The [cache-isolation check](testing-mutations-cache-check.md), [baseline diagnosis](testing-mutations-baseline-diagnosis.md), and [fresh dc88 campaign](testing-mutations-dc88-fresh.md) preserve the investigation and the clean rerun.

Other older exploratory reports remain available: [initial cleanup campaign](testing-mutations-run.md) and [first follow-up](testing-mutations-followup.md). They are historical evidence, not a replacement for the completed fresh dc88 result above.
