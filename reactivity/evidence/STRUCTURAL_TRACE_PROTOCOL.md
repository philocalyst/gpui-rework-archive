# Live structural boundary investigation

Baseline is the existing raw native renderer at b2d48370d75482e300befd81d4f0bcbbedd560c7.
The same-slot cost campaign is closed NOT ADMITTED (single1024=1.103170); do not
retune, combine A/B, or adopt its paint change here. No timing or speed gate is
part of this investigation. Choose a representation experiment from an actual
structural trace first.

Existing capabilities: contiguous preorder Node storage; semantic node identities
with namespace/lifetime rules; arithmetic identity lookup for one contiguous ID
run and compact runs/index fallback. Complete description reconstructs these
structures. Unkeyed sibling shape changes remint identities; admitted keyed list
rows may survive reorder. No new identity registry is needed to observe these.
Missing: preserving/connecting identity and ordered extents through reconciliation,
renderer packets, dependency/resource closure and publication.

Use ordinary public Source<Vec<u64>> edits in two models: unkeyed children and
keyed uniform-list rows. Insert/remove/reorder three initial rows, with 4/32/256
unrelated sibling nodes. A small insertion increases the left column's intrinsic
height and moves a following overlapping sibling outside the edited subtree.
Trace identity survival/reminting, old/new preorder extents, relocation, layout
rebuild and paint visits, actual GPU staging/validation/binning and damage.
Retain complete CPU/full-GPU pixel oracles. A bounded mutant that repairs only
the edited subtree's old/new rectangle must expose the outside-sibling damage.

Instrumentation is test-only and uses the existing exclusively owned runtime;
no shared mutable registry, public API or shipping representation change. Count
actual reconciliation/layout-insertion/paint-loop visits. Snapshot/scene diagnostic
materialization is explicitly O(N), outside the observed update and not a journal
adapter. Do not claim all internal allocations or every layout-engine visit from
these counters; separately count Source-update allocations and scene capacities.

Record submitted/acknowledged authority, stale acknowledgement rejection and a
failed newer structural preparation retaining the last coherent candidate. If a
fixture cannot cover image/text resource lifetime, mark it open; do not infer
leases from rectangle pixels. Trace source resource reconciliation and existing
Canvas/renderer boundaries before choosing the smallest subsequent experiment.
Keep original raw renderer/full preparation paths. No adoption, benchmark rerun,
shipping claim or publication. All work stays local.

Fixture correction after first gate: the structural Vec source must be registered
with `Sources::field`, whose documented owner dependency re-describes ordinary
Deref/branch reads. `direct` explicitly excludes those dependencies; the first
fixture incorrectly used it, produced no structural candidate, and correctly
accepted the unchanged token. Preserve that failed harness attempt. No runtime
authority rule or acceptance requirement changes.
