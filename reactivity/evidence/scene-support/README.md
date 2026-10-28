# Bounded support through complete scene publication — preregistration

Local isolated experiment, not adopted. Base 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f
is the failed precise-scroll candidate; its sealed result remains rejected at
53165424be4665a9874b6f3f5f31aa0d301e57ed. This protocol precedes implementation
and all new measurements. Worktree /home/user/gpui-scene-support-lab, unique target
/home/user/gpui-scene-support-target, external receipts /home/user/gpui-scene-support-evidence.

## Hypothesis and authority

Canvas currently collapses changed complete-scene command support into one
bounding rectangle. Preserve bounded separated support using the existing exact
ordered contribution predicate, including glyph coverage equality already proved
in the scroll trial. Unmatched old AND new tails contribute support; clear,
profile and size changes require full repair. The existing 64-region cap widens
to a conservative bounding rectangle. One rectangle allocates no region vector.
No heuristic may omit coverage, relax pixel equality or skip View callbacks.

A candidate C after acknowledged P may be superseded by N before ACK. D(C,N)
alone is insufficient: compose it with certified D(P,C), or with the existing
conservative prepared bounding damage if no exact region certificate survives.
The resulting region certificate must bind P's full PresentationToken to N's.
Never infer image authority from source epoch. A failed newer preparation leaves
an older eligible certificate intact. Any stale/foreign GPU predecessor gets
complete existing fallback. Size/scale mismatch does not admit sparse reuse.
Scroll-copy admission and single-text preparation keep their existing behavior.

Store optional complete-scene regions in the existing cold metadata repair slot,
sharing its box with the existing scroll alternative. Keep ordinary SceneDamage
and TextPatch field layouts unchanged. Charge enum/header growth, new cold
allocations, region capacities, generated code and local stack reservations.
Retain ordinary GPU submission and canonical shader; no new pipeline, executor,
unsafe, dependency, application API or task behavior. An additive Canvas method
may expose complete-scene regions without changing existing methods.

This tests BBTree's preservation of valid facts across unrelated edits and
Solid/Ripple's precise dependency/publication boundary. It does not equate UI
operations to ordered-map updates or claim cache hits/latency hiding.

## Qualification before timing

Freeze clean commits; preserve every failure/correction. Full/default/minimal
library and native scripts, GPU/offline-SPIR-V and strict Clippy gates apply.
Exercise complete exact images in all GPU formats and CPU repair oracle: separated
edits, add/remove/reorder, unmatched tails, glyph coverage/color/geometry changes,
clips/transforms/images/gradients, region overflow and transparent HDR. Native
cases include several source edits before ACK, changing geometry, stale image,
failed newer candidate then older eligible ACK, and fallback after copy/paint.
A bounded mutant that drops previously pending damage must fail actual pixels;
a region omission mutant must fail actual pixels. No tolerance/count-only witness.

## Fixed complete-operation cost gate

Five immutable alternatives: corrected original 20919cb160f6; glyph bounds
d67a538b9502; static sparse c965a893364b; failed precise scroll 5a07d7c28ffe;
and new candidate. Existing application and all 28 workload fixtures remain
byte-identical. Preserve canonical measured ELFs; build only in unique targets.
Use unchanged release profile, nightly-2026-10-23, locked offline dependencies,
llvmpipe LP_NUM_THREADS=4 and private X11 :94. No hardware/scanout claim.

The four zero-unrelated-label multi-field source/owner cases are the new primary:
2/4 separated edits must each cost <=0.8 of all four controls. They isolate the
changed repair support without large unrelated scene reconstruction costs.
Scroll and mixed retain <=0.8 versus original/glyph/static and <=1.05 versus
failed precise scroll. Stream and owner-stream retain <=0.8 versus original/
glyph and <=1.05 versus static/precise. Every other comparison is <=1.05.
No selective rerun, threshold change or partial adoption after a failure.

COST.json and PROCESS_ORDER.json freeze all 2,800 fresh timing processes, twenty
paired five-way groups per case, two Williams-design cycles and seed 20261105.
Each runs 16 warmups and 64 measured updates. First run 420 correctness and 140
allocation processes, with per-frame copy/image counters and final exact
pixel/source-epoch checks. Primary estimator is the median of 20 paired process
p50 ratios, type-7 quantiles, 10,000 paired bootstrap draws with fixed seed.
Point gates remain mandatory independent of confidence intervals. All cold/tail,
allocation, rendering/copy work and retained storage observations are reported.
No builds/tests/source edits/analysis/cleanup overlap timing. Full artifact,
fixture, profile, shader and source guards before/after; independent verifier.
No native ZGX comparison follows a failed complete cost gate.
