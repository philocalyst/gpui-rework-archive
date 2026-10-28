# Complete scene support — rejected complete cost gate

Local experiment; not adopted, merged or pushed. The candidate preserves exact
changed support across coalesced scenes, but all sixteen new primary comparisons
miss the fixed <=0.8 requirement. Three additional regression comparisons exceed
1.05. Overall 93 of 112 point comparisons pass. No native ZGX comparison follows
this failure; no hardware/cache-hit/scanout or overall ZGX victory is claimed.

The four primary candidate/prior-precise ratios are 0.957669 (two-field source),
0.978112 (two-field owner), 0.982733 (four-field source), and 0.955904 (four-field
owner). Repairing fewer pixels does not translate into the required complete
operation improvement on these small cases. Preserve both gains and failures.

## Fixed failures

| Case | Control | Paired ratio | 95% paired interval | Limit |
|---|---|---:|---|---:|
| flat-tiny | predecessor | 1.059724779 | [0.954171260, 1.191483678] | 1.05 |
| text-0-2-source | control | 0.954923680 | [0.930605863, 1.031302319] | 0.80 |
| text-0-2-source | bounds | 0.969194920 | [0.925099018, 1.040020261] | 0.80 |
| text-0-2-source | predecessor | 0.962461720 | [0.899610185, 1.010152811] | 0.80 |
| text-0-2-source | scroll_precise | 0.957668610 | [0.897127869, 1.029036341] | 0.80 |
| text-0-2-owner | control | 1.002130091 | [0.910267507, 1.041924696] | 0.80 |
| text-0-2-owner | bounds | 0.974751436 | [0.919423297, 1.046543742] | 0.80 |
| text-0-2-owner | predecessor | 0.966796768 | [0.908946043, 1.018012706] | 0.80 |
| text-0-2-owner | scroll_precise | 0.978111523 | [0.949302507, 1.026697972] | 0.80 |
| text-0-4-source | control | 0.955383524 | [0.907585697, 0.981615013] | 0.80 |
| text-0-4-source | bounds | 0.963426987 | [0.924491359, 0.987477365] | 0.80 |
| text-0-4-source | predecessor | 0.966882462 | [0.945508246, 1.015592567] | 0.80 |
| text-0-4-source | scroll_precise | 0.982732532 | [0.952992119, 1.008401697] | 0.80 |
| text-0-4-owner | control | 0.965377639 | [0.930405349, 0.994790876] | 0.80 |
| text-0-4-owner | bounds | 0.944109001 | [0.887748188, 1.011590022] | 0.80 |
| text-0-4-owner | predecessor | 0.946073007 | [0.908030861, 0.977631507] | 0.80 |
| text-0-4-owner | scroll_precise | 0.955903594 | [0.922683458, 0.984886363] | 0.80 |
| text-1000-4-source | control | 1.052945383 | [1.017371083, 1.082467624] | 1.05 |
| text-1000-4-source | scroll_precise | 1.051235628 | [1.016708969, 1.078481941] | 1.05 |

Intervals do not waive fixed point gates. No failed comparison was rerun, and no
successful subset was selected for adoption.

## Method and execution identities

Preregistration c025341544b45f5b27e405ad8372c332aa333498; inherited protocol-label
correction b4188e7cedc008f6d8b48f03da6173af54c7458d preceded implementation. Source
e5aead49e3a6270e6cde0046bafb77899de6a342 adds the mechanism and tests; qualified
92bfac4445c8b518b945c384fe6ff83ed772ae4f corrects a test-fixture lint only.
Original precise-scroll failure remains sealed at 53165424be4665a9874b6f3f5f31aa0d301e57ed.

28 unchanged cases, 20 paired five-way groups each, two Williams-design cycles,
seed 20261105: 2,800 fresh processes, each with 16 warmups and 64 measured updates
(179,200 measured updates). Before timing, 420 correctness and 140 allocation
processes pass final exact pixels/source epochs and per-operation copy/image
checks. All timed processes and final source/artifact guards also pass. No build,
other test, source edit, allocation probe, analysis or cleanup overlaps timing.

The estimator is the median of twenty paired process-p50 ratios; intervals use
10,000 paired bootstrap draws and type-7 quantiles. COST.json and PROCESS_ORDER.json
freeze the full schedule and thresholds. The four zero-label two/four-field
source/owner primaries require <=0.8 versus every control. Scroll/mixed retain
<=0.8 versus original/glyph/static and <=1.05 versus prior precise scroll.
Streaming retains <=0.8 versus original/glyph and <=1.05 versus static/precise.
Every other comparison requires <=1.05.

Nightly-2026-10-23, locked offline dependencies, repository-default release profile,
llvmpipe LLVM20.1.2/Mesa25.2.8, four driver workers, private X11 :94. The endpoint
is owner operation through native packet preparation, GPU completion and ACK.
It excludes OS/producer dispatch, active-host accessibility provider projection,
WSI and scanout. Fresh process/object cold observations do not establish a cold
shader disk cache. Actual native scripts establish correctness, not native timing.

| Variant | Compiled source | Measured unit ELF SHA256 |
|---|---|---|
| control | 20919cb160f6fcc5ab85eca607b97d4173739409 | 5a8792f765b3ea8d75c8ba38a620547c187b1945166fef547d31a017655f6f1a |
| bounds | d67a538b9502fb778460d9c59e726d5bb502ce28 | 822ac490efbbce6d4ebe70e8e7a55b45572c8858fbdd9adf008d80b3b704b55c |
| predecessor | c965a893364b46f965c83d10e2cf94a46dac1304 | 13f0e7f29986087eeaec9c3aaac0e1490978d0b517948249b0ab24d211fbe48b |
| scroll_precise | 5a07d7c28ffe500a5d24e25fdf1f31ce4857811f | cdc8811324153f68408374e258ba99f860e893733645ecaa0560520f2bde44ff |
| candidate | 92bfac4445c8b518b945c384fe6ff83ed772ae4f | b3e984734969d945d0debf1719b51f2ae48da70fb52ecfd53e7991e9f5085cc2 |

| Case | /Original | /Glyph bounds | /Static sparse | /Precise scroll | Gate |
|---|---:|---:|---:|---:|---|
| scroll | 0.087487716 | 0.087318047 | 0.086261054 | 0.997510752 | pass |
| both | 0.069198210 | 0.068920941 | 0.068707959 | 1.014353938 | pass |
| stream | 0.104877161 | 0.106266432 | 1.007186948 | 1.026791860 | pass |
| stream-owner | 0.109785655 | 0.107401139 | 1.034628243 | 1.035786453 | pass |
| fractional | 0.993125065 | 0.997683555 | 0.993816060 | 0.993856153 | pass |
| flat-tiny | 0.946881737 | 0.942467324 | 1.059724779 | 0.959856894 | **FAIL** |
| flat-full | 1.016331367 | 0.994449012 | 1.012125190 | 1.018521264 | pass |
| list-tiny | 0.523716185 | 0.488875054 | 0.520930282 | 0.991773409 | pass |
| list-flat | 0.104810473 | 0.102041083 | 0.103798806 | 1.005181192 | pass |
| exposure | 1.000646158 | 0.997056441 | 1.016197165 | 1.010340452 | pass |
| text-0-1-source | 1.014366945 | 1.008737765 | 1.021853133 | 0.983053972 | pass |
| text-0-1-owner | 0.989434450 | 0.962834318 | 0.991433857 | 1.002255699 | pass |
| text-0-2-source | 0.954923680 | 0.969194920 | 0.962461720 | 0.957668610 | **FAIL** |
| text-0-2-owner | 1.002130091 | 0.974751436 | 0.966796768 | 0.978111523 | **FAIL** |
| text-0-4-source | 0.955383524 | 0.963426987 | 0.966882462 | 0.982732532 | **FAIL** |
| text-0-4-owner | 0.965377639 | 0.944109001 | 0.946073007 | 0.955903594 | **FAIL** |
| text-25-1-source | 0.986055178 | 1.030066535 | 1.013812854 | 1.014160445 | pass |
| text-25-1-owner | 0.949698913 | 1.004102978 | 0.997260983 | 1.001479459 | pass |
| text-25-2-source | 0.979002521 | 0.983929358 | 0.972663819 | 0.980280599 | pass |
| text-25-2-owner | 0.969609668 | 0.964917739 | 0.968981632 | 0.937040831 | pass |
| text-25-4-source | 0.939439131 | 0.949796248 | 0.959140491 | 0.942198735 | pass |
| text-25-4-owner | 0.973416465 | 0.979648360 | 0.974509596 | 0.964671300 | pass |
| text-1000-1-source | 0.981516327 | 0.973202838 | 0.992364495 | 1.017701166 | pass |
| text-1000-1-owner | 0.785291020 | 0.978095406 | 0.987131113 | 0.994227203 | pass |
| text-1000-2-source | 0.979472005 | 1.010180739 | 1.024526982 | 1.023359722 | pass |
| text-1000-2-owner | 0.994659382 | 0.991071531 | 1.000938545 | 0.984518505 | pass |
| text-1000-4-source | 1.052945383 | 1.025416594 | 1.040380203 | 1.051235628 | **FAIL** |
| text-1000-4-owner | 0.969453729 | 0.982900597 | 0.992936052 | 1.005581643 | pass |

| Case | Candidate warm p50 | Prior precise warm p50 | Original warm p50 | Candidate first update |
|---|---:|---:|---:|---:|
| scroll | 3.027045ms | 3.099961ms | 35.094803ms | 3.378024ms |
| both | 3.915551ms | 3.838073ms | 57.433366ms | 4.329452ms |
| stream | 2.333102ms | 2.266707ms | 21.917530ms | 2.669287ms |
| stream-owner | 2.427780ms | 2.329355ms | 22.220039ms | 2.999258ms |
| flat-tiny | 0.091156ms | 0.091615ms | 0.093994ms | 0.243583ms |
| text-0-2-source | 1.411110ms | 1.418266ms | 1.484283ms | 1.941952ms |
| text-0-2-owner | 1.306211ms | 1.380260ms | 1.344388ms | 1.732880ms |
| text-0-4-source | 1.416913ms | 1.457051ms | 1.521983ms | 1.789065ms |
| text-0-4-owner | 1.370587ms | 1.403408ms | 1.441120ms | 1.720641ms |
| text-1000-4-source | 4.181681ms | 3.914224ms | 3.960505ms | 4.819431ms |

Absolute medians are descriptive; ratios of those medians differ from the paired
gate estimator. Full cold, tail and process observations remain in raw.

## Removed work and added costs

Two-field edits repair 780 instead of 1,430 pixels; four-field edits repair 1,560
instead of 3,510. New small source/owner cases add four to seven invoking-thread
allocation requests. Scroll and mixed repair/copy/image work and allocation counts
remain identical to precise scroll. Each ordinary scroll/mixed operation charges
1,401,440 copied pixels and 4,185,280 retained image bytes, including scratch and
both overlap copies. No traffic is omitted. The allocation ledger is not a full
driver/GPU/process memory measurement.

| Case | Prior warm requests/bytes | Candidate warm requests/bytes | Prior/candidate repaired pixels |
|---|---:|---:|---:|
| text-0-2-source | 171.0/29855.0 | 175.0/31191.0 | 1430.0/780.0 |
| text-0-2-owner | 178.0/34659.0 | 182.0/35995.0 | 1430.0/780.0 |
| text-0-4-source | 255.0/57947.0 | 262.0/61203.0 | 3510.0/1560.0 |
| text-0-4-owner | 209.0/44030.0 | 214.0/46262.0 | 3510.0/1560.0 |
| text-1000-4-source | 318.0/1408151.0 | 325.0/1411407.0 | 3510.0/1560.0 |
| scroll | 468.5/277702.0 | 468.5/277702.0 | 12880.0/12880.0 |
| both | 553.5/358360.0 | 553.5/358360.0 | 15770.0/15770.0 |
| flat-tiny | 69.0/10135.0 | 69.0/10135.0 | 64.0/64.0 |

Shipping code is 38,093 lines, +116 versus precise scroll. No vendor/dependency
change. Native ELF is 26,396,232 bytes, +7,912; the test ELF is 60,951,336 bytes.
Runtime remains 1,824 bytes, Prepared 40, TextPatch 96, TextResources 168,
SceneDamage 40 and Metadata 272. SceneRepair is 72 bytes, the same size as the
old ScrollTransition allocation: do not assume an 80-byte enum. Each bounded
region vector holds at most 64 x 8 = 512 bytes; complete lifetime/allocator
observations remain separate from headers.

Native Lab present_walk grows from 26,864 to 27,871 code bytes; its observed local
prologue reservations change from [4096,200] to [4096,264]. New damage_regions is
3,206 bytes with a 1,464-byte local reservation; shared unchanged predicate is
364/176. Ordinary retained render, regional render/submission and scroll render
have the same observed code sizes/prologues as the predecessor. These are local
prologue observations, not complete call-chain, driver or GPU stack costs.
Canonical WGSL SHA256 remains ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1.
All five generated SPIR-V modules validate and occur in the executed offline ELF;
canonical WGSL occurs in regular/offline GPU render and native example binaries.

## Architecture and qualification

The new Canvas method retains bounded support across complete ordered streams.
Each mismatch contributes old and new support, including unmatched tails. Glyph
coverage equivalence shares the prior exact scroll predicate. Before ACK, damage
from P to C is composed with damage from C to N, or with the prior conservative
prepared bounds when a sparse certificate is unavailable. Full PresentationTokens
bind publication and actual GPU image authority. The optional cold metadata box
holds either scroll or region repair; ordinary GPU submission, single-text source,
app and cost fixtures are unchanged. No executor, production unsafe code or new
application API. The additive Canvas method does not change existing signatures.

349 Canvas/GPU tests, 1,105 full native library tests, 1,011 default tests,
329 minimal library tests, 80 offline GPU tests, strict Clippy in all configurations,
17 workload-example tests in full/minimal configurations, 11 actual native scripts
and four minimal native scripts pass. Ignored counts and exact configurations are
preserved. The example tests are not fresh standalone independent application
port builds. Exact CPU repair and full GPU images cover all three GPU formats,
transparent HDR, materials, order, insertions/removals, clipped tails and overflow.
Native checks cover coalesced sources/owners, stale images and failed newer
preparation followed by older eligible acknowledgement.

Omission mutant 8cb6281f6cec7d93bee1792bd0bd85a8603ef935 fails exact pixels at
case 0/tick 3/Rgba8UnormSrgb. Its review script incorrectly expected tick 1;
the original assertion failure is retained. A separate review validates the
original tick-3 pixel witness without rerunning the test or changing its criterion.
Pending-damage mutant ce224ce7e2b94a331ce98caebf32d90794921ef3 fails the existing
coalesced scroll+owner Rows fixture: 2,540 of 20,480 bytes differ, first byte 54
instead of 93. That failure occurs before the new Page fixture in the mutant;
the intact candidate passes both. Do not claim a negative Page execution.

The first Canvas/GPU test command passed, but strict Clippy rejected an unused
VIEW constant in a shared test fixture. The preserved correction is test lint
handling only. All source guards are empty. Completed target ELF cache copies
were verified in canonical raw/gzip storage before removal; exact path/hash/mode
receipts and restore_cached_elf.py remain. Recorded regenerable rlib/rmeta cleanup
preserves source, generated shaders, evidence and all executed binaries. The
original checkout remains unchanged and every owned process is reaped.

Run `python3 reactivity/evidence/scene-support/verify.py` for independent exact
manifest coverage, process-order/row/counter checks, point estimates/intervals,
fault witnesses, generated/embedded shaders, ELF identities and cache archives.
The rejected global scene comparison should not be carried into the next trial.
Its shared 72-byte repair representation motivates a separate question: can
publication authority live independently of text geometry without growing the
ordinary borrowed damage header? That is an untested follow-up, not a causal
explanation of these failures.
