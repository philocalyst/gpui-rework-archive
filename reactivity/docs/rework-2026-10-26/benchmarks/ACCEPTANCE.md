# Coherent-candidate acceptance matrix (host-controller handoff)

No benchmark/build executed by this lane. Existing workload, not a new fixture.

## Exact inputs and required adaptation

- Fixture: `interaction-lane/baseline/reactivity/crates/gpui/examples/interaction_workload.rs`, 35,639 bytes, SHA256 `833d11326b5100fc48ad54b56172344873a64328a04fa4470a8501ca745f116e`.
- Definition: `interaction-lane/WORKLOAD-CONTRACT.md`. Pinned Inter SHA `40d692fce188e4471e2b3cba937be967878f631ad3ebbbdcd587687c7ebe0c82`.
- Historical source1b0eee3/production7ac is NOT current control. Parent must select actual complete old/current host pins and symmetric stable SourceValue compatibility overlay, then approve both expanded input manifests. Keep original fixture bytes/operation bodies unchanged; example registration may be identical additive Cargo stanzas. If API compilation requires fixture/body change, stop and review explicit adapter; do not silently change workload.
- Existing `invalidation-lane/integrated-timing-handoff-20261025/{PLAN.md,campaign.py,summarize.py,host-manifest.template.json}` is reusable protocol/source, BUT its ad322/5d44 pin assumptions are stale for today's coherent candidate. A reviewed additive manifest/helper adaptation is needed; never overwrite/relabel old evidence.
- Decide measured feature contract explicitly. `retained-text` is default-OFF. Default/default compares shipped paths but cannot claim retained-text gain. Retained-text ON candidate versus old control must disclose resolved feature difference and retain current-candidate feature-OFF isolation control. No unsupported old feature flag merely to pretend parity.

## Same six actual cases

| Case | Required changed operation / retained cadence |
|---|---|
| hover-source-paint | PointerSession enter/adjacent transfer/leave/far jump, first/last/middle row bands; one source with real fanout |
| hover-property-paint | Same pointer trace, old Inherit + new background contribution; retain both public mutations |
| hover-property-layout | Same trace, hovered width +4px/restored; siblings really move |
| popover-scroll | Seven phases open/down/down/reposition/up/up/close; each wheel retains scrolling sheet ACK then anchor-follow sheet ACK (two flushes) |
| window-resize-layout | Public viewport1000x1000↔1200x600; wrapping structural grid, no derived leaf-width edits; NOT wrapping article/text benchmark |
| app-ticked-geometry | Original virtual120Hz triangle widths/heights/translations for every cell; NOT visual-pose replacement |

Primary is side32 (1,024 controls); side100 stress stays separate. All original default color/scale, output extent, subframes and outputs retained. Grid cells have no text; popover/list has text. Responsive wrapping-article fixture is a complementary separately qualified workload, not a substitute.

## Minimal timing/correctness commands

Build BOTH selected roots sequentially with shared approved Nix stable tools, fresh separate targets, one job, identical release/ISA/allocator flags and explicitly selected features:

```
CARGO_TARGET_DIR=$FRESH_TARGET CARGO_BUILD_JOBS=1 RUSTC=$NIX_RUSTC RUSTDOC=$NIX_RUSTDOC \
 RUSTC_WRAPPER= RUSTC_WORKSPACE_WRAPPER= \
 $NIX_CARGO build --locked --offline --release -vv -p gpui \
 --example interaction_workload --message-format=json-render-diagnostics
```

Record actual Cargo fresh:false lib/example artifact paths+hashes, complete source/tool/derivation/font receipt, process status. No bootstrap/nightly/diagnostic/allocation-profiler binary in timings.

For each ELF, each six-case `$CASE`, and each mode (append `--cpu-raster` only in fullCPU mode):

```
COMPARISON_FONT=$PINNED_FONT $ELF $CASE --side 32 --warmup 32 --samples 240 --validate [--cpu-raster]
COMPARISON_FONT=$PINNED_FONT $ELF $CASE --side 32 --warmup 32 --samples 240 [--cpu-raster]
```

First line is correctness-only, never timed evidence. Repeat validation for warmup0 history too. Timed primary matrix=6cases×2modes; seven fresh matched AB/BA pairs, alternating whole-case order, no trimmed tails/selective retries. Preserve warmup0 first-measured-operation history separately (existing protocol also uses240 samples). Original mandatory start oracle runs even warmup0, warming driver raster/CSR/text; this is NOT first-ever raster/cache or cold OS evidence. Construction is separate `cold_construct_ns`, not cold raster. Separate side100 stress after primary; no pooling.

Full original `--validate` compares every subframe to fresh within-variant cold reconstruction. It does NOT prove cross-variant equality. Also use existing diagnostic full-output capture/comparator (`invalidation-lane/integrated-core-handoff-20261025/compare-full-outputs.py` and symmetric diagnostic adapter) on actual selected pins: exact ordered public scene/geometry/clip/color words, actual extent and every active CPU output byte, same seed/warmup/history including intermediate popover frames. Requalify adapter against actual composition; don't inherit older pin qualification. Diagnostic/cold oracle work stays outside timing binary/intervals. Any missing/duplicate/zero frame, ignored/zero selected test, nonzero exit or output mismatch blocks performance acceptance.

## Minimum raw evidence and acceptance

- Keep each process JSON and every original per-step phase: routing, edit_prepare, scene_borrow, full raster, logical ACK, total; total is SUM of measured phases, not outer event wall latency. Keep step/class, hover ordinal, submissions/edit calls and raw tails. Store process wall/user/system, faults/context switches and whole-child peak RSS. Seven process pairs are replicates; 240 operations are not240 independent process experiments.
- Report each case/mode/history independently: paired means/p50/p95/p99/max and all seven ratios, first operation, construction, variability/MAD. Existing predeclared investigation gates: mean≤1.05, p95≤1.10,p99≤1.15,max≤1.25; construction/first≤1.10. Apply to each operation class too, not just pooled phase average. Noise means inconclusive, not trim/relabel/pass. Parent may choose different thresholds only BEFORE seeing data and record them.
- Memory: wait4 whole-child peak RSS includes setup/oracles/output, not application-only/steady retained bytes. Existing process gate median paired excess≤max(8MiB,5%). Separately collect allocator requested bytes/count, live requested/declared retained capacities and declared phase snapshot peaks with explicit exclusions; never substitute scheduled work, type sizeof or static payload for RSS. No allocation profiler in elapsed campaign.
- Work: stock source ops/reads, destination compares, descriptions, layout/measure callbacks, paint passes/presentations, subframe counts. Measure callbacks≠shape misses; current diagnostics do not imply visited-node/shaped-glyph counts. Actual optional root/record/ref-capacity/index/Weak-shell and raw+packed overlap accounting stays separate, with mandatory model/packed baseline and opaque overhead excluded where not measured.
- Current CPU headless runs establish no hardware GPU/native present/input-to-photon/frame-rate claim. GPU scheduled area/upload requests are work counters only. Native/software-GPU timing requires separately qualified transport and completed matched pairs; failed affinity-guard pilot with0pairs is no data point for a speed chart.

## Newly identified integration blocker (02:31 UTC)
Text owner actual-source audit: original six mounts `Win::recording_with_font` using pinned Inter. That legacy constructor remains `WindowAccounting::Unaccounted` even with retained-text enabled; current scoped constructor `recording_with_resources` selects default font. Therefore enabling retained-text on the unchanged original fixture does NOT by itself exercise scoped raw shape reuse. Never attribute a core/render-only gain to text reuse. Before a text-enabled coherent comparison, owner/core must review an explicit context+SAME pinned-font API adapter, preserve every original operation/ACK and all source bytes apart from separately documented constructor adaptation, prove identical outputs, and bind new fixture identity. Until then retain original SHA as historical/control workload identity and report honest unaccounted/core-render-only scope. The pinned font cannot be silently replaced with default font to make scoped accounting available.
