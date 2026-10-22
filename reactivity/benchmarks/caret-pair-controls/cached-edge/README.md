# Cached visual-edge caret control

This experiment replaces duplicate affinity geometry on a proven shared visual
edge with the exact cached f32 prefix. Its exceptional path borrows source
clusters. A separate one-line control stops the index-selection prepass after
the ninth Unicode boundary. No production retained owner, lock, refcount or
unsafe code is added.

## Four independent executables

`pair/metadata.json` pins source, Cargo artifacts, profiles, executable hashes
and source-file guards for these release examples:

| Variant | Source | Purpose |
|---|---|---|
| baseline | `879476dd0bf391e8482dddea61271bb775b4f639` | Original library plus identical fixture |
| initial | `d74fc223e799956c1e21997dd7eec88abe8aff39` | Earlier pair formulation with large cluster copies |
| candidate | `db7281e1cd76d130952cdbb6f3ea5d062b69af9f` | Direct cached edge and borrowed fallback; original prepass |
| threshold | `7eb75ab3971e76f645cb9316a3b1f8b9d7644270` | Candidate plus bounded prepass |

The historical initial source guard uses files recovered from its immutable
Git archive because that experiment's worktree advanced. Every recovered file
matched its original recorded hash. All four fixtures, manifests and lockfiles
match. Frozen executables are omitted from Git; their metadata remains.

Seven paired rounds rotate/reverse the four execution orders on CPU 0. Fourteen
cohorts each check all allocation rows and output checksums. Source and binary
guards run before/after the campaign and after each four-way round. No live
Cargo/rustc/Clippy process overlapped; all cooperating agents held builds/scans.
Finished zombie processes are excluded from the live-process check. The run
took 55.84 seconds; unrelated host activity was uncontrolled.

| Text | Final vs baseline, cold | Final vs baseline, warm | Final vs cached-edge only, warm |
|---|---:|---:|---:|
| Tiny, 5 bytes | +0.12% | −0.55% | +1.71% |
| Label, 18 bytes | −11.06% | −29.10% | −0.22% |
| Latin, 30,800 bytes | −40.96% | −39.74% | −1.21% |
| RTL, 27,000 bytes | −17.28% | −17.52% | −0.39% |
| Mixed direction, 25,200 bytes | −22.43% | −23.30% | −1.27% |
| Short paragraphs, 10,800 bytes | −1.56% | −0.48% | +1.07% |
| One grapheme, 24,001 bytes | −0.90% | −0.94% | −0.70% |

Negative means less elapsed time; values compare medians, not confidence bounds.
All requested/retained/peak bytes and allocation counts match across all four
variants in every cohort. This is work elimination, without a heap reduction.
The process font registry is primed; cold means a fresh scoped planner and warm
means a reused planner. Timing includes previous-output drop. These are text
shape/caret measurements, not process startup, RSS, native input latency, GPU
performance, complete frame time or a competitor comparison. The bounded
prepass has small mixed results and does not eliminate segmentation of one huge
grapheme. Complete samples, checksums and all comparisons remain in `pair/`.

## Correctness and operation evidence

At `db7281…`, the full parallel Canvas suite passes 193 cases/docs, four ignored,
across 28 harnesses; all-target strict Clippy passes. The exact independent
unindexed cursor oracle accepts 94,176 positions, rejects 41,760 snapped
positions and observes 11,096 distinct affinity pairs. It compares f64 geometry
bits and packed Stop source/x/affinity bits over wraps, bidi, styled runs,
ligatures, combining content, UTF-8 interiors, hard breaks, alignments, negative
spacing and extreme widths. Added seven/eight/nine-boundary fixtures exercise
the threshold choice. The threshold source passes this same oracle and strict
all-target Clippy separately. Full-suite results are not retagged to that pin.

The temporary call-local probe records 43,072 shared LTR edges, 20,224 shared RTL
edges, 12,096 endpoint fallbacks and 60,544 other fallback attempts. The latter
includes snapped positions. Counts sum to all oracle attempts. Its bit/packed
oracle passes; the patch was removed and all three touched files match their
baseline hashes. Probe instrumentation has no timing/allocation qualification.

The public 83-case fixture reproduces the existing 2,678,729-byte transcript
exactly: scene geometry/colors/masks, acknowledged semantic JSON, every source
byte with both caret affinities and source-owned line indices. Its SHA-256 is
`1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f`.
This dev `gpui/x11` behavior check qualifies `db7281…`; its reference source is
preserved in `evidence/intrinsic-text-measure`. An initial manifest rewrite was
rejected by `--locked`; it built no executable and is retained separately.
A first oracle invocation selected zero tests because its exact filter omitted
`planner`; that log is preserved and the corrected invocation ran one test.

The independent source/assembly review is in `assembly/report.md`. In the
`db7281…` release executable the common helper is 472 code bytes with a 168-byte
local frame, versus 2,084 bytes/1,144 bytes in the initial formulation. Its
successful shared path constructs no Cursor, queries no cursor geometry and
contains no memcpy call. The separated fallback is 1,251 bytes/504-byte frame;
its callback is 1,064 bytes/96-byte frame, also without emitted memcpy calls.
The restored small-text loop emits no array-map closure. Whole `.text` still
grows 1,440 bytes versus baseline; the executable grows 2,120 bytes. Separate
frames are not summed into a peak-stack estimate. These observations belong to
the cached-edge executable, not automatically the threshold executable.
The separate `assembly/threshold-report.md` and full linked shape disassembly
confirm nine iterator steps in the final executable, with early exit on a missing
boundary. The threshold adds 192 linked text bytes and 208 executable bytes
versus cached-edge only; the 4,568-byte Planner frame is unchanged.

## Cost and reproduction

The frozen threshold source charges **30,013** core non-test/comment/blank code
lines, including 18 build-script lines: +6 versus the 30,007 baseline.
`vendor-code-lines.json` separately charges +79 code lines across the two changed
Parley source files. Tests, the measurement example and patch-ledger prose are
excluded from core rather than presented as shipping simplification.

`source.patch.gz` contains the complete source/test/example/vendor patch from
`9f9ed16a1a`. `pair/run.py` is the exact four-way driver; rebuild/freeze the
recorded examples and recover historical guarded files at their pins before
rerunning. Compressed text and transcript files use lossless gzip. The original
assembly manifest names original uncompressed paths; `SHA256.json` hashes the
actual archived files. This archive does not certify an integrated checkout.
