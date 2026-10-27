# Changed-record tile repair — rejected performance qualification

The stream completes4.5–4.9x faster than full preparation across0/25/1000 static
labels. Its paired ratios are .204038/.222182/.214537. The separate three-pair
packet-only comparison gives .255704/.253400/.227724: this additional gain comes
from refining output work, beyond retaining the GPU packet. Every stream pair
wins in both comparisons. The fixed trial still fails: short single-field
controls at0/25 labels are1.099998/1.073309, above1.05. All five0-label single-field
pairs exceed1.05. The25-label two-field exact case also loses at1.169136, although
it was not a fixed control. Preserve this losing regime; do not adopt the trial.

The1000-label two/four-field primaries pass at .716769/.761192. Four-field pairs
span .6283–1.2403, so this is not a uniform per-pair win. All full-scene control
medians pass, with broad pair ranges retained below. Separately against packet-only,
short two/four-field ratios are .992901/1.077381; refining their small dirty bounds
did not establish a general benefit. No previous failed verdict is amended.

Implementation: the previous atomic gather/validate/text packet commit remains.
While rebuilding complete surviving CSR, compare old/new tile reference lists
and old/new referenced glyph/common words. Changed common numerical bounds mark
the whole run. Equal lists and equal words reuse old pixels; changed lists mark
a tile even when glyph words agree. Both old and new memberships matter. Merge
adjacent dirty tiles into disjoint row spans, intersect caller-certified damage,
and issue those scissored draws in one retained pass plus one complete copy.
More than256 spans falls back to bounding damage; None still means full repaint.
The shader, sample arithmetic, painter order, atlas leases, scene token/ACK
rules, headers and public application interfaces are unchanged. No new unsafe,
executor or hardware-cache assertion. Complete CSR work remains, so this is not
an O(changed) whole-frame algorithm. The input-equivalence argument is in
[raw/proof.txt](raw/proof.txt).

Correctness:78 GPU tests/doctests and strict Clippy;975 default GPUI+Canvas,
1048 X11-composed tests/doctests and strict Clippy; six actual private-X11 scripts.
Tests cover copy-only unchanged records, one changed glyph in a paragraph,
old/new support across tile and opaque boundaries, HDR/SDR, fractional/near-edge
geometry, empty/clipped/full damage and span-count fallback. A numerical witness
uses ordinary Canvas scenes: a tiny forward-translation difference changes the
conservative bound32→33 while inverse/local/glyph words coincide. The optimized
image matches both the old image and an independently fresh new render exactly.
The separately frozen mutant4eb6ba28b5 omits old-only dirty memberships and fails
the exact moved-glyph image comparison. The previous packet's late-rejection,
replay and native predecessor/coalescing/failed-newer/older-ACK tests also pass.

Failed fixture attempts remain: candidate had wrong public coordinate types;
qualified used a singleton seed that is not a tracked run; boundary forgot
Canvas's one-pixel outward guard; rounding searched the wrong neighborhood.
Correcting fixtures changed no production code, shader, image tolerance or gate.
Native qualification source32aae50d17 predates only GPU public test additions;
all native/production/dependency inputs match the final GPU sourceef71ae3001.
The final measured ELF is byte-identical to source32aae50d17. Allocation source
c7fb8baf7d only adds diagnostics to the separate allocation example; its guarded
build and strict Clippy are separate, not repeated full-native executions.

Performance:210 fresh processes,21 cells,five alternating pairs,10 warmups and
60 measured updates each (12600 measured updates). Mechanism comparison:30 fresh
processes,five cells,three pairs (1800 updates). Same960x720 fixture, DejaVu font,
shared ZGX735-character stream payload, pinned nightly2026-10-23, features,
CPU affinity2–5 and llvmpipe4. Canonical scene/delta construction, preparation,
submission and queue completion are included. Shaping is outside timing.
`host_ns` is wall time through submit, not thread CPU time. Independent initial/
final images, final scene receipts, immutable ELF/features and full input guards
pass across all processes. No owned compiler/test/probe/source edits during
these timings. Cold creation and max RSS include the independent image oracle;
raw percentiles, process samples, cold/RSS and all pair ranges remain available.
This diagnostic is not native input-to-scanout or a ZGX comparison.

Allocation:42 separate processes,60 warm samples each, exact fresh/cross-variant
GPU images. Caller-thread Rust allocations only; driver/foreign/worker allocations
are excluded. Candidate sparse retained delta is zero; full paths in both
variants include queue-allocation cycles. Warm full-control allocation counts
and byte distributions match control apart from separately reported run-map
storage. At1000 labels, two fields122/17225→100/81593 requests/requested bytes;
four132/19329→123/87645; stream131/50121→115/209739. Fewer requests but more
transient bytes remains a loss. Versus packet-only, stream adds8 requests/7680
requested bytes. Headers and run-map capacities are unchanged from that base:
RetainedRenderer944 B (+24 vs full control), map16032 B for1000-label stream;
native TextResources192 B (+16 vs original), default176 B.

The diagnostic helper records retained compositing separately from its allocator
scope. Stream median canonical damage66627 pixels becomes9808 composited pixels,
while every submission still copies691200 pixels. Short single-field damage416
remains416: extra comparison and commands remove no output work there. Two/four
fields reduce1456→1040 and3536→2288 pixels, but their mechanism timings do not
show a consistent gain. This supports testing a size threshold; it does not
prove the exact cause of every timing difference. No threshold is implemented
or retrospectively used to select this trial's samples.

Code:37461 shipping lines, +94 over packet-only (+519 over the outline base).
Measured ELF14733192 B, +3832 over packet-only (+38192 over full control).
Patch body8898 B/local stack reservation888 B versus packet-only8062/856;
wrapper455/104 versus439/88; submit_regions801/1368 versus original submit636/1344;
new span helper256 B. Full retained render2228/664 is unchanged from packet-only.
Reservations exclude pushed registers/callees/driver stacks, not total bounds.
Complete symbols and selected assembly are retained. Generated WGSL remains
SHA256 ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1,
verified embedded in the actual timed ELFs. Dependencies remain unchanged;
allocation-counter0.8.1 stays diagnostic-only. Maximum span vector capacity is
256 rectangles; real allocation effects are measured, not inferred from that cap.

Sources:base de8e4f6fea; preregistration f720eab8631a189c55afa0d9a608c13018ec5371;
production f7942c19db707c3f6da04d476bf14c65c5705760;
final GPU/measurement ef71ae300172d5e3ee958c654900cd36839e015c;
native32aae50d1727b2b2cfc77fb07df86cdcaf263cba;
allocation c7fb8baf7db023943a28c6163cdc8b74166f655f.
Full-preparation control64523d173a and packet-only11ad2fff8f use their preserved
immutable executables; inherited build/test receipts are explicitly labelled.
The native planning and historical results in those inherited folders are not
new executions. Cleanup receipts preserve sources/evidence and measured ELFs;
older completed test binaries were losslessly archived. Free space briefly fell
to7.2GiB during compilation/archive work, then recovered14GiB before timing;
see raw/housekeeping.txt. No measurement occurred during that cleanup.

The AMD9950X KVM guest has no physical render node; Vulkan is llvmpipe and X11 is
private. Cache misses and scanout were not measured. Equivalent native workload
ports, matched distribution profiles and two physical hardware classes remain
required. Everything is local; no merge or push. Run
`python3 reactivity/evidence/gpu-text-tiles/verify.py` to reconstruct the failed
verdict, all percentiles/allocations, image equality, receipts and content hashes.

## Full-preparation baseline

| Labels | Fields | Mode | Paired completion ratio | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | exact | 1.099998 | 1.0595–1.1497 |
| 0 | 2 | exact | 0.849177 | 0.6923–0.9738 |
| 0 | 4 | exact | 0.933896 | 0.8507–1.0939 |
| 0 | 1 | full | 1.045380 | 0.8592–1.1530 |
| 0 | 2 | full | 1.030372 | 0.9061–1.2371 |
| 0 | 4 | full | 1.030756 | 0.6767–1.0948 |
| 25 | 1 | exact | 1.073309 | 0.9838–1.0931 |
| 25 | 2 | exact | 1.169136 | 0.9004–1.8573 |
| 25 | 4 | exact | 0.910755 | 0.8532–1.0477 |
| 25 | 1 | full | 0.997361 | 0.8921–1.0616 |
| 25 | 2 | full | 1.022551 | 1.0057–1.0686 |
| 25 | 4 | full | 1.006562 | 0.9119–1.0702 |
| 1000 | 1 | exact | 0.685252 | 0.5944–0.8728 |
| 1000 | 2 | exact | 0.716769 | 0.4931–0.7860 |
| 1000 | 4 | exact | 0.761192 | 0.6283–1.2403 |
| 1000 | 1 | full | 1.017158 | 0.9713–1.0690 |
| 1000 | 2 | full | 1.007587 | 0.9722–1.0689 |
| 1000 | 4 | full | 1.016702 | 0.9789–1.0371 |
| 0 | 1 | stream | 0.204038 | 0.2000–0.2254 |
| 25 | 1 | stream | 0.222182 | 0.2081–0.2668 |
| 1000 | 1 | stream | 0.214537 | 0.2001–0.2750 |

## Packet-only mechanism baseline

| Labels | Fields | Mode | Paired completion ratio | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | stream | 0.255704 | 0.2277–0.2828 |
| 25 | 1 | stream | 0.253400 | 0.2150–0.3113 |
| 1000 | 1 | stream | 0.227724 | 0.2218–0.2789 |
| 1000 | 2 | exact | 0.992901 | 0.6601–1.1777 |
| 1000 | 4 | exact | 1.077381 | 1.0135–1.2401 |
