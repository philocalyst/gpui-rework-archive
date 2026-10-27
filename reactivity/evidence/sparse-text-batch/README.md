# Atomic sparse text batches

Rejected performance variant; the fixed 5% control gate fails. No adoption,
ZGX ranking or hardware claim. All work is local.

Two to four disjoint source-text changes now prepare one atomic sparse canonical
scene transaction after ordinary layout proves zero geometry writes. Canvas
validates all run slots/common state, duplicate addresses, raster leases, aggregate
resource uses and tile-reference limits before changing any command. The complete
batch then publishes in input order with one damage union and one ACK. Old text
and interaction geometry remain presented until that ACK. No application API
change or new unsafe; Canvas adds an optional low-level TextRunReplacement API.
Run-length, geometry, new-resource, unknown-source and owner-dependent cases keep
the full path. This is BBTree-style gather/validate/ordered commit, not a custom
async executor or a measured cache-hit improvement.

Four Canvas tests and three public GPUI tests cover exact fresh reconstruction,
transformed/fractional clips, collective final resource uses, late-member failure,
duplicates/foreign layout, two/four-field edits, intrinsic layout fallback and
failed newer preparation followed by an older eligible ACK. An internal assertion
confirms actual sparse-row preparation. The sequential-commit mutant fails the
public pixel assertion that a later rejected run must leave the first unchanged.
Default GPUI+Canvas tests/doctests: 975; X11 composition: 1048; strict Clippy and
six actual X11 scripts pass. These are composition checks, not native timing.

Preserved failures: first Clippy rejected an unused mut in a new test; full
all-target Clippy then found a pre-existing type-complexity warning in the old
text_cache_capacity example. The corrections only remove mut and add an example
type alias. No production change was made to select a passing test outcome.

Before paired timing, artifact hashes exposed Cargo convenience example paths
replaced by native test builds. The first 42 allocation probes/four preflights
used matching native-feature binaries; they are preserved in excluded directories.
The original full/artifact receipt was also taken after default tests had replaced
the build-only alias. artifact-pin repeats explicit build-only commands under full
source guards, captures dependency fingerprints, and binds direct build/out files.
The intended control hashes match the historical receipts exactly. All intended
allocation probes/preflights were run with matching default+simd artifacts before
any paired timing. See raw/artifact-pin/RECOVERY.json; no timing sample was discarded.

The complete trial has 210 fresh processes / 840000 enqueue, deliver, record and
ACK operations, five alternating pairs per 21 cells on CPU2, 200 warmups, 40×100
operations. Both variants retain zero owner reruns for every exact-source batch;
coarse controls perform 4000. All final source epochs/pixels match the independent
fresh-window oracle. Primary 1000-label two/four-field CPU ratios .06928/.12344
(14.4x/8.1x) pass. The 25-label two-field owner control is 1.05617 and fails.
The zero-label two-field exact case is also slower, ratio 1.07818. Keep both
losing regimes and all paired ranges; narrow regressions are not assigned a
hardware cause by these measurements.

Separate 42-process allocation probes: with 1000 static labels, two-field warm
requests 84→63 and requested bytes 341828→5688; four-field 120→114 and
343672→10628. One-field remains 33 requests/2602 B. Warm retained delta is zero
in every cell; all one-field/coarse warm allocation records match exactly.
Concrete Win wrappers remain 296 B typed / 256 B opaque. TextResources itself
is 176 B: the patch owner grows 8→16 B for a boxed slice, while DirtyText remains
24 B and each owned patch row is 40 B. Transient clones/plans are charged.

Shipping inventory: 36941 lines, +280 over the 36661-line base. Default measured
ELF: 10198560→10245928 B. Linked try_sparse_text grows 2078→5337 B per
specialization as the new batch body is inlined; the stack reservation grows
344→584 B, with six pushes in both. These are local prologue sizes, not a bound
on total call-stack use. Delivery routine sizes remain 5672/5650/5672 B. The
whole symbol tables/selected assembly are preserved. An outline-only follow-up
will test the enlarged routine; this is not an established explanation of the
control regression.

The native GPU adapter still rebuilds/uploads the complete packet for text; this
CPU experiment does not implement sparse GPU text-record or tile-index updates.
An AMD9950X KVM guest, shared host noise, unavailable perf counters, software
Vulkan and no render node limit the evidence. No builds/tests/allocator probes
or source edits ran during paired timing. Full source and ELF guards pass.
Cold owner-creation times and whole-process maximum RSS (including diagnostic
fresh-window pixels) are separate in raw/paired-cold-rss.json; they are not an
attribution of GPU/driver allocations. CPU/wall p50/p95/p99 remain in the raw
summaries and batches. No warm/cold/scanout endpoint mixing.

| Static labels | Fields | Mode | CPU candidate/control | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | exact | 1.00270 | 0.9663–1.0807 |
| 0 | 2 | exact | 1.07818 | 0.9961–1.1291 |
| 0 | 4 | exact | 0.98521 | 0.8939–1.0424 |
| 0 | 1 | owner | 1.00083 | 0.8682–1.0777 |
| 0 | 2 | owner | 0.99666 | 0.9302–1.1807 |
| 0 | 4 | owner | 0.95453 | 0.9075–1.1581 |
| 25 | 1 | exact | 1.01246 | 0.9447–1.0725 |
| 25 | 2 | exact | 0.73321 | 0.6926–0.8449 |
| 25 | 4 | exact | 0.96816 | 0.7673–0.9841 |
| 25 | 1 | owner | 1.01500 | 0.7558–1.1964 |
| 25 | 2 | owner | 1.05617 | 0.9491–1.2199 |
| 25 | 4 | owner | 1.02162 | 0.9267–1.0429 |
| 1000 | 1 | exact | 1.01555 | 0.8560–1.0558 |
| 1000 | 2 | exact | 0.06928 | 0.0673–0.0732 |
| 1000 | 4 | exact | 0.12344 | 0.1175–0.1274 |
| 1000 | 1 | owner | 0.98302 | 0.9242–1.0196 |
| 1000 | 2 | owner | 0.98820 | 0.8917–1.0917 |
| 1000 | 4 | owner | 1.03239 | 0.9719–1.1035 |
| 0 | 4 | opaque | 1.01048 | 0.9259–1.2518 |
| 25 | 4 | opaque | 0.95617 | 0.9486–1.0127 |
| 1000 | 4 | opaque | 0.95970 | 0.9240–1.0657 |

Base 1830d9d54fe73903ffd909e3e19aab8c25e9763d; final source 34e170689fbb10689d81baa3b97b95d11ba7b48a. The actual measured commits, commands, compiler flags, feature/dependency fingerprints and immutable ELF hashes are in raw/artifact-pin and raw/paired/metadata.json. Run `python3 reactivity/evidence/sparse-text-batch/verify.py` to independently reconstruct the verdict.
