# Deferred retained-rendering performance follow-up

This branch is a separate, non-delivery follow-up from the final documentation
closeout. It contains no production source edits. It records the exploratory
results available on 2026-10-18 and preserves a bounded diagnostic overlay for
a possible later glyph-rendering investigation. The user chose to wrap sync
and defer performance work; no further benchmark build or run is authorized by
this branch note.

## Valid exploratory profiles

The comparison is pinned to CE retained snapshot `a7e52d69e33f01ef5f1e7bfa37a950f5c774297f`
and gpui-fast `37f3959732d13404989e58e89c4e37ec9489e3f5`. For profiles 02–04,
CE is the baseline and Fast the candidate; a CE/Fast ratio above 1 means CE was
slower. Per-profile geometric-mean wall-time p50 ratios were:

- Owned image cache: `1.139544`.
- Dependency fanout: `1.824318`.
- Supplemental test-mode viewport: `6.051998`.

Each was an exploratory profile with 10 paired runs, 50 measured samples and
10 warmups per scenario, on CPU affinity 2. These are separate per-profile
summaries, not an aggregate for the primary nine-scenario plan. The workloads
measure CPU-side update/layout and quad-scene work with empty text rasterizers;
they provide no glyph or text-sprite performance result. Full profile tables,
p99 ratios, intervals, and provenance are in the companion evidence files
`benchmarks/retained-core/evidence/retained-analysis-valid-profiles-20261018/valid-profiles-02-04.md`
and `valid-profiles-02-04.json`.

## Excluded and incomplete comparisons

- The coalesced viewport timing profile is excluded: Fast failed its geometry
  contract at sample 25, step 35 (sibling reorder).
- The Tall comparison is excluded: CE and Fast had semantic scene mismatches in
  three scenarios.
- The full primary nine-scenario aggregate was not produced.
- No glyph-rendering timing was run or accepted. An optional diagnostic/build
  attempt was interrupted when the user changed scope to wrap the sync work.

The original correctness failures, receipts, and analyzer decisions remain in
the evidence tree; this branch does not relabel or replace them. It makes no
claim that CE is faster or simpler overall.

## Optional diagnostic overlay

The four `.patch` files and `source-hashes.json` are copied from
`glyph-bounded-diagnostics-overlay-20261018`. The JSON binds the CE and Fast
adapter/viewport patch candidates to their exact preimage and candidate hashes.
The overlay reapplies matched 1.0 glyph scale and enables bounded semantic
geometry diagnostics only when explicitly requested. Its diagnostic setting is
off by default. The candidate patches were applied only to separate r6 WIP
source copies; their source manifests record two harness-only changes, and the
original frozen snapshots were left unchanged. The optional CE glyph-diagnostic
build was later interrupted when the user chose to wrap sync; the Fast build,
glyph oracle, and glyph timing never started. No glyph result is claimed here.
Candidate `.rs` files, binaries, and product changes are intentionally absent.
