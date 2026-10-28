# Reuse publication workspace independently of candidate validity — preregistration

Local isolated experiment; no implementation or timing at this checkpoint.
Base 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f is the failed precise-scroll source,
whose rejected result is sealed at 53165424be4665a9874b6f3f5f31aa0d301e57ed.
Do not carry the rejected complete-scene comparison from 7494c10970d3dc46e7611d4abe93ab8476682a6e.
Unique worktree /home/user/gpui-patch-workspace-lab, target
/home/user/gpui-patch-workspace-target, external receipts
/home/user/gpui-patch-workspace-evidence. Everything remains local.

## Hypothesis

try_sparse_text allocates TextPatch per accepted update; acknowledge takes and
drops the box. Full candidate supersession also drops it. Native damage collection
can allocate a bounded region vector per patch. The same owned storage can serve
successive candidates if allocation lifetime is separated from live-payload and
image-authority lifetime. Reuse the box and bounded region capacity while an
Option payload records whether row/value/geometry belong to a live candidate.

ACK moves the live value/geometry exactly once into the acknowledged columns and
retires the payload. Full supersession retires it only after successful complete
preparation. Failed newer preparation leaves an older eligible candidate intact.
A reused workspace never grants authority: expose repair only for a live payload
with the exact existing from/to token checks; native GPU image authority remains
unchanged. Cache preparation failures must not publish partial content or regions.
Unused text resources reclaim the workspace and its capacity. Old glyph/geometry
leases must not be retained merely to keep a box reusable.

Add a DamageRegions clear/reset operation that retains an existing bounded Vec
capacity, resets overflow for the next operation, and preserves the canonical
empty-region behavior. At most 64 regions/512 bytes; no unbounded history or arena.
No production unsafe, Rc/Cell/RefCell, dependency, executor, shader, GPU submission
change, application API change or View callback elision. A lower-level additive
DamageRegions method is permitted. Existing scroll and repair algorithms stay.

BBTree motivates reusing an owned continuation without confusing storage with a
valid gathered destination; Solid/Ripple motivate explicit staged versus committed
state. This is allocation reuse, not proof of cache hits or memory-latency overlap.
Earlier shaping-session/cold-trim results concern different storage and keep their
original verdicts. The marginal earlier failures do not establish an allocator
cause; deterministic removed requests and complete gates must decide this trial.

## Required qualification and falsification

Freeze clean source before each gate; preserve all failures. Full/default/minimal
libraries and native scripts, Canvas/GPU/offline shader and strict Clippy apply.
Keep all 28 cost fixtures and the actual app byte-identical. Check exact images,
source epochs and per-operation copy/image counters. Existing stale-image, omission,
coalesced scroll/text and failed-newer/older-ACK witnesses remain mandatory.

New public-operation lifecycle checks cover first/warm use, repeated ACK, source
and owner edits, a sparse candidate superseded by a full/reordered candidate,
failed preparation, no-change text, removal and text-service reclamation. Check
acknowledged text/geometry and exact images, plus resource lifetime and retained
capacity. A bounded mutant that omits retirement on full supersession must fail
an exact public acknowledged-text or geometry oracle; a count-only failure does
not qualify. The optimization does not change image-repair derivation, so the new
lifetime witness need not manufacture a GPU-authority bypass to get a pixel failure.
Damage reset tests cover empty/one/many/overflow and repeated capacity reuse.

## Fixed cost and storage gates

Five immutable variants: original 20919cb160f6, glyph bounds d67a538b9502, static
sparse c965a893364b, failed precise scroll 5a07d7c28ffe, and the candidate. The
failed global scene-support algorithm is excluded. Scroll/mixed retain <=0.8
versus original/glyph/static and <=1.05 versus precise scroll; source/owner stream
retain <=0.8 versus original/glyph and <=1.05 versus static/precise. Every other
comparison requires <=1.05 versus all controls. No threshold relaxation, selective
rerun, post-hoc treatment selection or partial adoption. No native ZGX comparison
after a failed complete gate.

New deterministic gates require at least one fewer warm invoking-thread allocation
request than precise scroll in stream, owner-stream, 0/1000-label one-field source,
and 0-label two/four-field source cases. Charge first-use, requested/net/peak bytes
and retained cache separately. Header gates require Runtime 1824, Prepared 40,
TextResources 168, SceneDamage 40 and TextPatch 96 with native-core / 40 without.
Retained workspace cap is one box plus <=512 region bytes per text service;
geometry/value leases move out on ACK and are dropped on supersession. Failure
of these storage/work gates rejects the candidate even if timings pass.

The fixed schedule expands short-control samples before implementation: 20 paired
groups for scroll/mixed/source-stream/owner-stream, 120 for flat-tiny/list-tiny,
and 80 for each other case. Earlier short-control intervals were substantially
wider than the 5% limit. Additional groups reduce that uncertainty; they do not
revise any earlier failure or change the threshold. Every case repeats complete
five-treatment Williams cycles with balanced positions/adjacencies. Shuffle whole
groups with seed 20261106; PROCESS_ORDER.json freezes all 10,400 fresh processes.
Each runs 16 warmups and 64 measured updates (665,600 measured updates). First
run 420 correctness and 140 allocation processes with unchanged 16/4 workloads.

Estimator: median of the fixed per-case number of paired process-p50 ratios;
10,000 paired bootstrap draws with fixed seed, type-7 intervals. Point gates
remain mandatory irrespective of intervals. Whole native ELF/code, local stack,
headers, dependency/vendor and generated shader costs are reported separately.
Nightly-2026-10-23, locked offline release, llvmpipe/four workers and X11 :94.
No build, other test, source edit, allocation probe, analysis or cleanup overlaps
timing. Source/profile/fixture/actual-ELF/shader guards and an independent verifier
are mandatory. Software Vulkan and native scripts establish no hardware/scanout
or global ZGX victory. Native end-to-end comparison remains a separate later gate.
