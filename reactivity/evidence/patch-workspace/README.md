# Reusable text publication workspace — complete local gate passes

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
| scroll | 0.085834647 | 1.032461123 | [0.977383620, 1.059414176] |
| both | 0.067493327 | 1.013385064 | [0.985901878, 1.034335015] |
| stream | 0.102916904 | 0.985136374 | [0.961903209, 1.018576874] |
| stream-owner | 0.104567052 | 1.002756599 | [0.928760812, 1.009138896] |

The largest unaffected-case point ratio is 1.020708454 for 1000-label/two-field
owner updates versus precise scroll (95% interval [1.001014711, 1.030892765]),
below the fixed 1.05 limit. Flat-tiny/static is 1.002665628 and list-tiny/precise
is 0.997054164 in this cohort. These observations do not revise previous cohorts.

All fixed comparisons (each value is a paired point ratio, not a ratio of medians):

| Case | Original | Glyph bounds | Static sparse | Precise scroll |
| --- | ---: | ---: | ---: | ---: |
| scroll | 0.085834647 | 0.086318342 | 0.086028392 | 1.032461123 |
| both | 0.067493327 | 0.068214729 | 0.068479615 | 1.013385064 |
| stream | 0.102916904 | 0.103044219 | 0.945899166 | 0.985136374 |
| stream-owner | 0.104567052 | 0.104563640 | 0.998244797 | 1.002756599 |
| fractional | 1.001911970 | 1.002933428 | 0.999138592 | 0.998609973 |
| flat-tiny | 1.006778593 | 1.011933541 | 1.002665628 | 0.996991213 |
| flat-full | 0.998645328 | 0.995259551 | 0.999794880 | 1.000822550 |
| list-tiny | 0.520267228 | 0.519698305 | 0.531829075 | 0.997054164 |
| list-flat | 0.105760240 | 0.105332513 | 0.103738603 | 1.019017196 |
| exposure | 1.008472299 | 1.007078177 | 0.998442241 | 0.999787177 |
| text-0-1-source | 1.015411852 | 0.991232391 | 1.009575714 | 1.006287351 |
| text-0-1-owner | 0.991310882 | 1.003797645 | 1.008320794 | 1.009259288 |
| text-0-2-source | 1.009337145 | 1.005147816 | 1.002119699 | 0.998630577 |
| text-0-2-owner | 1.010035082 | 1.018997857 | 1.004052853 | 1.012213194 |
| text-0-4-source | 0.986548011 | 0.998939256 | 0.996553913 | 1.002831770 |
| text-0-4-owner | 1.013938702 | 1.002959458 | 1.006278431 | 1.014718989 |
| text-25-1-source | 1.006058821 | 0.997789472 | 1.009675989 | 1.001178400 |
| text-25-1-owner | 0.982724989 | 1.017999402 | 0.999855854 | 1.010257200 |
| text-25-2-source | 1.010938390 | 0.995885911 | 1.011268708 | 0.987384472 |
| text-25-2-owner | 0.990064997 | 0.999998159 | 0.991456466 | 0.989055357 |
| text-25-4-source | 0.999056370 | 0.991279252 | 1.000364320 | 0.999935218 |
| text-25-4-owner | 1.006768932 | 0.999162869 | 0.995392579 | 0.993645942 |
| text-1000-1-source | 0.990429994 | 1.007841584 | 0.988240357 | 0.997412956 |
| text-1000-1-owner | 0.772714934 | 0.985084747 | 0.980009736 | 0.985654203 |
| text-1000-2-source | 0.990473037 | 0.991210790 | 0.997678563 | 1.003422280 |
| text-1000-2-owner | 0.996279781 | 1.003031489 | 1.014025631 | 1.020708454 |
| text-1000-4-source | 0.986412052 | 0.980889259 | 0.979054908 | 0.995129526 |
| text-1000-4-owner | 0.997609115 | 0.992377345 | 0.999466797 | 1.002813173 |

[Full paired estimates, confidence intervals and all process pairs](raw/candidate/matrix-analysis/summary.json)
and [per-process p50/p95/p99, mount/first/first-update observations](raw/candidate/matrix-analysis/processes.json)
are retained. Absolute medians of process p50s below are descriptive; they are a
different estimator from the paired ratios used by the gate.

| Case | Original ms | Static ms | Precise scroll ms | Candidate ms |
| --- | ---: | ---: | ---: | ---: |
| scroll | 35.348939 | 35.910336 | 3.043957 | 2.999931 |
| both | 57.451555 | 57.215788 | 3.857357 | 3.879428 |
| stream | 21.990883 | 2.347270 | 2.318483 | 2.338059 |
| stream-owner | 22.922467 | 2.396889 | 2.434627 | 2.408900 |

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
| control | 20919cb160f6fcc5ab85eca607b97d4173739409 | 5a8792f765b3ea8d75c8ba38a620547c187b1945166fef547d31a017655f6f1a |
| bounds | d67a538b9502fb778460d9c59e726d5bb502ce28 | 822ac490efbbce6d4ebe70e8e7a55b45572c8858fbdd9adf008d80b3b704b55c |
| predecessor | c965a893364b46f965c83d10e2cf94a46dac1304 | 13f0e7f29986087eeaec9c3aaac0e1490978d0b517948249b0ab24d211fbe48b |
| scroll_precise | 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f | cdc8811324153f68408374e258ba99f860e893733645ecaa0560520f2bde44ff |
| candidate | 41a67473a0177fbb17df1f7b8e2f2f36dd6940f6 | 3383fe53b623097932793af4defc0b47412f59e868a85c61d57fb470fd1bfef4 |

Timing results SHA-256: `20c4f783e04521fd5f6e80a3fcad0a1c884a725e6d2be4780af6f73308701fd0`.
Process-order SHA-256: `ccb119489bb10a1db8b93ac98b014e80e94bb9fa8c19fb00ac7f688372eebd84`.
