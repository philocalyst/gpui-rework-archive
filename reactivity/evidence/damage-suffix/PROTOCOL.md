# Unequal display-stream suffix — preregistration

Local experiment, no implementation or measurement yet. Base41a67473a0177fbb17df1f7b8e2f2f36dd6940f6
passes patch-workspace local gates but fails native-workspace344c7f8ddd55326dca2c88322f67530914c97733.
Diagnostic a34b61c86fbbc6906d834e071bdb7c4fb70aac8d shows17 >25ms ACK gaps
in the first second of every empty-start candidate stream run, none thereafter;
initial190 eliminates this loss through exact and owner ingress. Named raster
workers dominate steady CPU. Neither observation proves a cache-miss problem.

Hypothesis: when command count changes, forward-only positional damage comparison
pairs inserted glyphs with unrelated following retained draws, inflating repaint.
Before the existing forward comparison, trim the exactly unchanged common suffix
only when lengths differ. The first unequal reverse pair contributes both old and
new support; all remaining unmatched contributions retain their support. Reuse
existing exact BorrowedCommand equality, including live immutable lease identity,
not approximate bounds or resource hashes. Equal-length behavior, APIs, headers,
shader, packet rebuilding and tokens stay unchanged. This is a small competing
algorithm, not adoption of the rejected global scene-support representation.

Unique branch local/damage-suffix and worktree /home/user/gpui-damage-suffix-lab;
fresh target /home/user/gpui-damage-suffix-target; external evidence
/home/user/gpui-damage-suffix-evidence. Local only. Source cone includes all crates,
vendors, manifests, tools, ports/comparisons/benchmarks and .cargo; old evidence is
available through immutable Git history without duplicating it into this checkout.
Freeze source before each build gate; preserve every failure and source/artifact
identity. No production unsafe or shared mutable owner is introduced.

Correctness: public Canvas tests cover insertion/removal before an unchanged
suffix, asymmetric lengths, an unequal last reverse pair, empty streams, equal
length reorder, alpha/overlap, transforms/clips and glyph runs. Every changed pixel
must lie in damage and regional repair must exactly match independent full output.
Public owner/GPU tests must cover the actual empty-start workload for both ingress
routes, full fresh-frame equality, pending/unacknowledged updates, failed newer
preparation and eligible older ACKs. Existing token/resource authority tests remain
mandatory. A separate bounded mutant omits the first unequal reverse pair's support
and must fail actual pixels. No weakened oracle or tolerance.

First screen: Canvas/GPU/default/full-native/minimal/offline tests and strict Clippy,
17 app tests and actual native scripts under existing feature profiles; generated
shader/embedded ELF identity and library rebuild receipts. Reuse baseline receipts
only for byte-identical unchanged inputs. Record shipping lines, native/test ELF
sizes, hot headers, allocations/retained storage and changed assembly/prologues.
The proposal adds no retained storage; verify this rather than infer from LOC.

Then an isolated native cadence screen: two exact preserved matched-profile ELFs,
qualified baseline and candidate, 8 balanced pairs for each stream route (32 fresh
eight-second observations). Existing initial0 workload/font/geometry/display/driver
and pacing stay unchanged; enable existing ACK trace in both. Fixed order seed
20261109. Every candidate run must admit464–488 updates and have at most two
ACK gaps >25ms in its first second. Preserve all baseline failures and every raw
process/task-independent CPU sample and ACK; do not infer a CPU victory from
unequal admitted work. This is a startup mechanism gate only. Failure rejects
this candidate before the longer cost trial; success admits the next stage.

Before any longer timing, freeze the complete unchanged28-case paired schedule
against qualified patch-workspace. Use20 groups per primary4,120 for flat-tiny and
list-tiny,80 for remaining22; balanced alternating order and whole-group shuffle,
seed20261110. 4160 processes (16 warm+64 measured each). Every paired median
process-p50 ratio must be<=1.05; report10000 paired bootstrap/type7 intervals with
that seed, without using uncertainty to waive point thresholds. Existing full
matrix's original-control results remain scoped to its cohort. All existing
correctness/work/epoch and allocation probes precede timing. Actual cold startup
is the new primary benefit, not a claim of20% warm improvement from this change.
No observation is dropped or retried. Scripts/verifier freeze before observations.

If those gates pass, qualify a new four-mode native comparison against ZGX with
the unchanged58–61Hz/.8 CPU-rate/.01 idle-core criteria before any goal claim.
All required hardware, scanout, visual/input-policy and two-class gates remain.
No builds/tests/edits/analysis/cleanup overlap timing; keep8GiB minimum free and
prefer12GiB before large builds. Archive exact binaries/evidence before reclaiming
completed caches. Reap all owned processes. Research motivation is precise staged
publication (Solid/Ripple) and retained validated state (BBTree); no async executor
or cache-hit improvement is claimed for suffix comparison.
