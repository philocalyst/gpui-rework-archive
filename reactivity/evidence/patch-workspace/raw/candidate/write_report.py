from pathlib import Path
import json,hashlib
r=Path(__file__).parent;s=json.loads((r/'matrix-analysis/summary.json').read_text());spec=json.loads((r/'cost-definition.json').read_text());art=json.loads((r/'matrix-artifacts.json').read_text())
lines=['''# Reusable text publication workspace — complete local gate passes

The candidate passes all **112/112 fixed timing point gates**, all six warm-allocation
gates, and all qualification/header/work gates. This admits a subsequent native
end-to-end comparison. It does **not** establish a ZGX advantage, hardware GPU
performance, scanout latency, quality parity, or adoption. Earlier rejected trials
retain their original verdicts; this is a new complete cohort with its own fixed
sampling protocol. No threshold was changed and no cell was selectively rerun.

## Source and scope

- Preregistration: bc6d01564477a0c8b5710b338a29119d991fadaf.
- Initial implementation: e2f8be96746a9ab44b44bbd22f1e61af98837454.
- Qualified/measured source: **41a67473a0177fbb17df1f7b8e2f2f36dd6940f6**.
- Base: 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f, whose earlier failed cohort
  is sealed at 53165424be4665a9874b6f3f5f31aa0d301e57ed.
- Qualification checkpoint before reclaiming completed target caches:
  e106b788863e7ed8a6cad97a4130322b5264ce46 in the separate local checkpoint worktree.
- New experiment worktree: /home/user/gpui-patch-workspace-lab;
  target: /home/user/gpui-patch-workspace-target;
  external receipts: /home/user/gpui-patch-workspace-evidence.

A reusable Box<TextPatch> holds Option<TextUpdate>. ACK moves the live text and
geometry into acknowledged state exactly once; successful full supersession retires
that content; a failed newer preparation preserves the eligible older candidate.
Only a live payload can expose repair metadata, with the existing exact from/to
packet-token checks. DamageRegions::clear preserves bounded vector capacity and
canonical empty behavior, resetting overflow for each operation. Unused text
resources reclaim the box/vector. Application APIs, shaders, GPU submission,
dependencies/vendors and the actual app/28 benchmark fixtures are unchanged. The
lower-level Canvas clear method is additive. There is no new production unsafe,
shared mutable graph, generic executor or callback-elision assumption.

BBTree continuation ownership and Solid/Ripple's separation of staged and committed
state motivate this lifetime split. It removes repeated allocation work. Cache-hit
rates and memory-latency overlap are not measured. The rejected complete-scene
comparison and SceneRepair representation are absent from this candidate.

## Fixed complete performance gate

Five alternatives use identical app/benchmark fixtures, Cargo release profiles,
canonical generated shader and execution environment. Nightly-2026-10-23, locked
offline builds, llvmpipe with four workers and private X11 :94. All 420 correctness,
140 allocation and **10,400 timing processes** finish with matching exact image/source
epoch checks. Every source/artifact guard is empty. There are 16 warmups and 64
measured updates per timing process: **665,600 measured updates**. No builds,
other tests, allocation probes, edits, analysis or cleanup overlapped timing;
only short progress reads and waits were used. Every owned process was reaped.

The schedule was fixed before implementation: 20 paired groups for scroll/mixed/
source-stream/owner-stream, 120 for flat-tiny/list-tiny, and 80 for all other cases.
Each case uses complete five-treatment Williams cycles; whole groups are shuffled
with seed 20261106. Estimator: median of paired process-p50 ratios. Intervals use
10,000 paired bootstrap resamples, the same fixed seed and type-7 quantiles.
Point thresholds are the preregistered gates; intervals are reported without
turning them into a new acceptance rule. Some intervals cross the 5% threshold.

The large gains against the original/glyph/static controls are inherited from the
combined sparse-region and precise-scroll work. Workspace reuse passes its
allocation mechanism test, but its incremental complete-latency effect versus
precise scroll is small and uncertain. It does not explain why earlier cohorts
failed marginal point gates. A passing tolerance gate does not mean every case
became faster.

| Case | Candidate/original | Candidate/precise scroll | Paired 95% interval versus precise |
| --- | ---: | ---: | --- |
''']
for c in ['scroll','both','stream','stream-owner']:
 a=s[c]['comparisons']['control'];b=s[c]['comparisons']['scroll_precise'];ci=b['paired_bootstrap_95'];lines.append(f"| {c} | {a['median_paired_ratio']:.9f} | {b['median_paired_ratio']:.9f} | [{ci[0]:.9f}, {ci[1]:.9f}] |\n")
lines.append('''
The largest unaffected-case point ratio is 1.020708454 for 1000-label/two-field
owner updates versus precise scroll (95% interval [1.001014711, 1.030892765]),
below the fixed 1.05 limit. Flat-tiny/static is 1.002665628 and list-tiny/precise
is 0.997054164 in this cohort. These observations do not revise previous cohorts.

All fixed comparisons (each value is a paired point ratio, not a ratio of medians):

| Case | Original | Glyph bounds | Static sparse | Precise scroll |
| --- | ---: | ---: | ---: | ---: |
''')
for c,x in s.items():lines.append('| '+c+' | '+' | '.join(f"{x['comparisons'][v]['median_paired_ratio']:.9f}" for v in spec['variants'][:-1])+' |\n')
lines.append('''
[Full paired estimates, confidence intervals and all process pairs](raw/candidate/matrix-analysis/summary.json)
and [per-process p50/p95/p99, mount/first/first-update observations](raw/candidate/matrix-analysis/processes.json)
are retained. Absolute medians of process p50s below are descriptive; they are a
different estimator from the paired ratios used by the gate.

| Case | Original ms | Static ms | Precise scroll ms | Candidate ms |
| --- | ---: | ---: | ---: | ---: |
''')
for c in ['scroll','both','stream','stream-owner']:
 lines.append('| '+c+' | '+' | '.join(f"{s[c]['variants'][v]['p50_ns']/1e6:.6f}" for v in ['control','predecessor','scroll_precise','candidate'])+' |\n')
lines.append('''
Fresh process/object mount and first-use observations are not cold shader-disk-cache
measurements. Software Vulkan/private X11 cannot establish physical GPU or scanout
results. The actual native event-loop/ZGX gate remains a separate next experiment.

## Removed work and retained storage

All six deterministic warm invoking-thread allocation gates pass against precise
scroll: stream 221→219 requests and owner-stream 381→379; each saves 608 requested
bytes (96-byte workspace and 512-byte region capacity). Zero/1000-label one-field
source updates save one request/96 bytes (132→131); zero-label two-field source
171→170 and four-field source 255→254 also save one request/96 bytes. These are
invoking-thread counts, not total-process/GPU allocation counts. First-use, mount,
requested/net/peak bytes for all 28 cases remain in the allocation ledger.

Scroll and mixed warm allocations remain 468.5 and 553.5 median requests. Every
candidate qualification frame has exactly the same composited-pixel, copied-pixel
and retained-image work as precise scroll; each full GPU image also matches its
oracle. Scroll/mixed retain 1,401,440 copied pixels and 4,185,280 image bytes,
including both overlap copies and scratch. The workspace optimization does not
reduce raster work or conceal work behind a counter change.

Runtime 1824, Prepared 40, TextResources 168, SceneDamage 40 and native TextPatch
96 bytes are unchanged. TextPatch without native remains 40 bytes. The cached
capacity is at most one box plus 512 requested vector bytes per text service;
allocator bookkeeping is outside that bound. Payload text/geometry leases move
out on ACK or drop on supersession, and unused text resources reclaim the cache.
Tests verify actual box/vector address reuse, zero region-reset allocations and
text-service reclamation, as well as empty/one/many/overflow behavior.

Shipping code is **38,016 lines (+39)** across seven first-party libraries/build
scripts. Native ELF is **26,389,256 bytes (+936)**; the qualified unit ELF is
61,399,440 bytes (+87,200, including test code). Native try_sparse_text grows
2513→2602 machine-code bytes while its observed local stack reservation shrinks
440→408 bytes. present_walk grows 26864→26880 bytes with the same [4096,200]
local stack reservations. DamageRegions::include grows 886→925 bytes; clear adds
73 bytes. Ordinary/scroll/regional GPU renderer sizes and local reservations are
unchanged. These are local prologues, not whole call-chain or driver/GPU stacks.

[Work ledger](raw/candidate/work-summary.json),
[allocation ledger](raw/candidate/allocation-summary.json),
[allocation verdict](raw/candidate/allocation-verdict.json), and
[code/layout/dependency ledger](raw/candidate/code-layout-costs.json).

## Qualification, negative witness and preserved failures

- Canvas/GPU: 347 passed, 3 intentionally ignored; strict Clippy passes.
- Full native: 1106 passed, 45 ignored, 17 example tests; strict Clippy passes.
- Minimal library: 329 passed, 25 ignored, 17 example tests; strict Clippy passes.
- Default: 1013 passed, 13 ignored; strict Clippy passes.
- Offline shaders: 79 passed, none ignored; strict Clippy passes.
- All eleven full-native and four minimal-native interaction/a11y scripts pass.
- 28 generated shader files are recorded; canonical WGSL is embedded in three
  executed binaries. Five distinct generated SPIR-V modules validate and occur
  in the executed offline binary. No shader or GPU submission change is carried.

Bounded mutant **5d24115d28d39f4095415290fd262cd2bb05e6b2** omits only successful
full-supersession payload retirement. The identical public test fails after ACK:
actual text/geometry rows [("1111",4),("01234567890",11)] versus required
[("2222",4),("01234567890",11)]. This is an exact public stale-value witness,
not a count-only failure or a synthetic GPU-authority bypass. Normal source passes
that test plus repeated ACK, failed-newer/older-ACK, reorder, removal/remount and
independent fresh pixels. Existing native coalesced-scroll/incorrect-image and
GPU omission tests remain exercised in the composed suite.

The initial e2f8be9 Canvas workspace fixture failed because it treated 2×2 author
bounds as exact slot support. Slot support includes the one-pixel conservative
raster fringe, so three separated inputs cover 44 pixels, not 12. Commit 41a6747
corrects only that test and explicitly checks its support bounds; the failing run
and binary remain preserved. Two negative-run reserve prechecks aborted before
compilation. The qualified negative run later passed its expected-failure witness.

Before timing, completed qualification was committed separately and exact ELF
cache copies were archived by hash. The first candidate-cache archival stopped
at its 8-GiB reserve check after preserving/removing one copy; no build, test or
timing was active. Regenerable libraries were reclaimed after the evidence
checkpoint and the remaining 479 cache copies were then archived successfully.
All partial receipts are preserved. About 14 GiB was free before timing; no cleanup
overlapped measurement. Canonical raw/compressed ELFs, sources, fingerprints,
generated shaders and evidence remain available. Cache-path restoration requires
the exact archive receipts, not rebuilding an allegedly identical executable.

## Reproduction and verification

Run `python3 verify.py` from this dossier after packaging. The verifier was frozen
before timing. It checks the complete manifest/fileset, qualification counts,
negative semantic witness, balanced schedule, every process/raw record and exact
work counts, paired bootstrap calculations, all fixed gates, shader bytes inside
actual ELFs, and every preserved/archive identity. An independent verifier pass
is required before treating this dossier as sealed. All changes remain local.

| Variant | Source | Unit ELF SHA-256 |
| --- | --- | --- |
''')
for n,a in art.items():lines.append(f"| {n} | {a['source']} | {a['sha256']} |\n")
lines.append('\nTiming results SHA-256: `'+hashlib.file_digest((r/'matrix-timing/results.json').open('rb'),'sha256').hexdigest()+'`.\n')
lines.append('Process-order SHA-256: `'+spec['process_manifest_sha256']+'`.\n')
(r/'dossier-report.txt').write_text(''.join(lines))
print('report written; performance gate passes; native ZGX comparison remains pending')
