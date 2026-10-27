# Rejected text-witness replay experiment

Disposition: **reject; do not integrate**. The preregistered state-update gate
requires at least 20% lower process CPU with 1000 static labels and no cell over
5% slower. Replay achieved 15.1% at 1000 labels and regressed 6.8% at 10000.
All five large-cell ratios were slower. Thresholds were not changed afterward.

| Static labels | Median candidate / baseline CPU | Five-process range |
| --- | ---: | ---: |
| 0 | 1.0263 | 0.9722–1.0599 |
| 25 | 0.9746 | 0.9641–1.0631 |
| 100 | 0.9487 | 0.9351–0.9727 |
| 1000 | 0.8488 | 0.8342–0.8705 |
| 10000 | 1.0684 | 1.0380–1.1395 |

Each process measures 2000 updates after 200 warmups, in 200 batches of ten;
five repetitions, five sizes, two alternatives: 100000 measured updates and
10000 raw batches. `paired-witness/summary.json` includes per-process p50/p95/p99
of batch-average costs. These are not individual-operation tail latencies.
The runner alternates order, preserves every process, and stops on failure.
No builds or other owned benchmarks ran during this campaign. Background VM
services were not continuously monitored; small differences remain noisy.

## Source and mechanism

Baseline `75a9e2b06b`; candidate `3c7fe2e240`; mutant `24b922d58a`.
Preregistration began at `8fe0a910bc`, before any timing. The baseline fixture's
leaf typography and mutable fresh-pixel access were corrected before its first
successful run. Candidate and baseline are isolated worktrees/targets; the
original archive checkout is untouched. No push or adoption.

`CanvasScene` searches up to eight previous text groups from a moving cursor.
It copies their admitted glyph witnesses only when live immutable glyph storage,
exact forward transform, origin, rectangular clip, scale and colour match.
Mask positions are remapped into the new scene, so every admitted resource is
still leased by that scene. Chain clips, shared-colour text and mismatches use
ordinary admission. Failed preparation and abandoned stages preserve the old
scene. This reduces per-glyph admission, but still traverses and republishes the
whole runtime scene. It therefore does not remove the architectural bottleneck.

## Qualification and costs

The candidate ran 107 Canvas unit tests (2 ignored) and three public differential
tests. Repeated identical configurations exercise hits; changes include shear,
reflection, translated bounds, fractional DPI, clip, alpha, Unicode, empty and
single-glyph text, clear within a stage, foreign font, abort and source drops.
Fresh ordinary Canvas drawing is the pixel oracle. A unit test verifies actual
replay. The mutant omits forward-transform comparison and fails exact pixels at
translation 90, under both its accidental initial stable compiler and the
corrected pinned nightly. This is the intended stale-bounds witness.

The full GPUI/native/GPU/platform gates were **not run** for this rejected
candidate. Narrow correctness success does not qualify adoption. No new
production unsafe code, dependency or vendor patch. Measurement-only Linux
clock FFI is in the example, separate from the unsafe-denying library.

Shipping code: 36191 → 36384, **+193 lines**, using the repository's Syn/Tokei
inventory. The candidate adds a forward transform and raster-scale certificate
per grouped run, a temporary mask remapping vector, and a staging cursor. Full
retained glyph/scene traversal remains. Whole-executable hashes/sizes are in
`artifacts.json`; these examples are not a native application's binary delta.
Every process retains GNU time's peak RSS (including the untimed fresh oracle).
Median baseline/candidate peak RSS at 1000 labels: 20700/20872 KiB; at 10000:
45168/45036 KiB. These small RSS differences do not establish a memory win.
Exact allocator/driver/stack attribution was not completed after rejection.
Cold mount CPU and teardown wall time are preserved in every run log.

## Competitor diagnostic and remaining work

ZGX source is pinned at `a3678578980ef239058c557338ef9c544d356b0c`.
Its unchanged `micro_bench` builds and runs locally. The initial single-run
diagnostic reports GPUI about 459 microseconds for source→recording→ACK versus
ZGX about 2.8 microseconds for RENDER=0 source→layout/damage. These endpoints
and release profile settings differ; **they are not a matched comparison**.
ZGX does not record GPUI's canonical glyph list at that endpoint. Both use the
comparison DejaVu Sans bytes. Geometry, typography, rendering and native cadence
still need independent cross-framework qualification. The website's Mac results
cannot be pooled with this Linux VM. No hardware GPU is exposed and the archived
`mothership` host cannot resolve; hardware access was requested while work proceeds.

Next experiment starts from the baseline, excluding this rejected patch. Use
the layout engine's actual changed-layout report, sparse complete/presented
publication, and bounded transactional text-run replacement. Do not assume
layout containment from a fixed width and height. All coarse/failure/IME paths
must retain the complete recorder as an independent fallback.

## Failure history and reproduction

Preserved failures: a sparse-checkout hash guard initially included absent paths
and stopped before compilation; the baseline example lacked `mut` for a pixel
oracle; a foreign-font test mistakenly used two handles to the same globally
bundled face. The corrected test constructs an independent font owner. The
negative control was first invoked from the repository root and thus used stable
Rust; the explicit nightly rerun also fails the intended pixel assertion.
Perf hardware counters are unavailable (`perf_event_paranoid=4`), so no
instruction-count claim is made. Raw failed logs remain beside corrected runs.

Build baseline and candidate from their frozen commits with the pinned
`nightly-2026-10-23`, `cargo build --locked --release -p gpui --example
state_update_cost`, distinct target directories. Run `measure.py` after adapting
its local absolute paths to those executables and the pinned comparison font;
it refuses to overwrite the output directory. `verify.py` validates the stored
payload hashes, counts, independently recalculated ratios, and rejection.
Input receipts cover the sparse checkout's tracked reactivity sources, vendors,
manifests, lockfile, toolchain and configuration. Compilation artifacts in the
Cargo JSON record actual rebuilt packages. Do not remove failed evidence or
rewrite raw patch whitespace to satisfy a documentation formatter.
