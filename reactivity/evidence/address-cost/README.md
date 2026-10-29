# Complete native address cost decision

**Relative domains: NOT ADMITTED. Stable draw addressing: NOT ADMITTED. Retain original serial raw as the current practical choice.** Neither representation meets the frozen gain/regression gates; stable addressing also fails the known-storage gate. All288 processes and final original-GPU encoding checks pass, with zero fallback,110,592 measured updates and unchanged input guards. This closes the bounded reference-encoding cost campaign; no retuning or adoption follows.

Parent `b1b640d87b58f7addbb0a59cfeb610a70cb093f0` established bounded version-consistent GPU consumption. Protocol `46b7a61f9f678eefa2bb2b8a5365786761211c6f`, clarified with implementation before any observations; compiled source `68a1f99f37084c3a8a328599dbc9c2fb36dfdcfb`; frozen driver/analysis campaign `fa5c90d775c22078e166d7aa5c2e0bc81fd87cbe`. Local branch local/address-cost; no pushes. Inherited mixed exact CPU/GPU48-byte gate remains **FAILED**. This campaign verifies final original-GPU encoding equality, not cross-backend parity, production frame latency, WSI or ZGX advantage.

## Fixed verdict

Relative mixed insertion/removal median-of-six paired p95 ratios versus equivalent private raw relocation are **0.997184 /1.011261**, and versus serial raw **0.998244 /1.015152**. All four miss the required≤0.80. Keyed4 removal versus raw1.065857 and both resource directions1.114099 /1.097901 exceed the≤1.05 regression limit. Seven timing clauses fail; known accounted storage stays within4× raw. The64-byte first-insertion record saving does not translate into an admitted complete cost win.

Stable keyed256 insertion/removal ratios versus private raw relocation are **1.137910 /1.131718**, and versus serial raw **1.148437 /1.155943**; all miss≤0.80. Tiny/unkeyed/reorder/resource losses remain. Twenty timing clauses and ten family/direction storage cells fail. Nine reused tile lists in the bounded insertion never authorized a net win. Exact per-cell scores, all six block ratios, thresholds and failed clauses are in `raw/analysis.json`.

| Family / direction | Relative / relocation | Relative / raw | Stable / relocation | Stable / raw |
| --- | ---: | ---: | ---: | ---: |
| keyed4 insert | 0.976440 | 1.043784 | 1.087435 | 1.136466 |
| keyed4 remove | 0.980771 | 1.065857 | 1.079625 | 1.132829 |
| unkeyed4 insert | 0.983560 | 0.981107 | 1.089683 | 1.128344 |
| unkeyed4 remove | 0.981688 | 0.966466 | 1.090986 | 1.172336 |
| keyed256 insert | 0.986431 | 1.001811 | 1.137910 | 1.148437 |
| keyed256 remove | 0.995772 | 1.019019 | 1.131718 | 1.155943 |
| reorder256 forward | 1.025737 | 1.011646 | 1.112539 | 1.097238 |
| reorder256 return | 0.986651 | 0.987729 | 1.077209 | 1.085802 |
| mixed insert | 0.997184 | 0.998244 | 1.014187 | 1.044057 |
| mixed remove | 1.011261 | 1.015152 | 1.032805 | 1.063979 |
| resources forward | 1.022442 | 1.114099 | 1.057039 | 1.111714 |
| resources return | 1.019175 | 1.097901 | 1.049895 | 1.094240 |

Each ratio is candidate/control (lower is better), not a speedup. Every timing clause uses the same frozen aggregation: nearest-rank per-process directional p95; within each block geometric mean of forward/reverse ratios; ordinary median of six block ratios. Displayed absolute p95s are medians across12 processes and need not divide to the paired score. No outlier rejection, adaptive stopping, rerun or gate waiver occurred. These observations decide this candidate; individual noisy pairs do not prove that a specific encoding instruction caused a regression.

## Endpoint and controls

Ordinary Source value construction/`Win::set` → description/reconciliation/layout/paint → exact scene/key borrow → complete preparation/copy/upload → actual draw submission → device completion → acknowledgement → predecessor drop. CPU known-storage ledger for at most two versions is included before retirement. Source, prepare/submit, completion/ack/retirement stages share fixed timestamp placement. No Python/IPC, readback, oracle draw, JSON/file output or allocation-counter wrapper is inside the measured interval. Existing test-build semantic/cold observers remain in all lanes, so this is a restricted native recording endpoint rather than production GPUI frame latency.

Raw uses the unchanged original shader and serially reuses one renderer. The other three use frozen private-version transport: predecessor buffers copied before patches, private coherent version bindings and fence before retirement. A predecessor update makes **three queue submissions** (copy, staged-write flush, draw), versus **one** for original serial raw. The raw-relocation lane isolates that transport from relative encoding; stable versus raw-relocation similarly separates address/directory effects from their common private transport. Compare both with practical serial raw, but do not attribute private lifetime/extra-submission costs solely to encoding. Private versions support deferred old consumption tested in the parent; this timing campaign consumes/fences each frame serially and does not time concurrent presentation.

Six families at64×64: keyed4, unkeyed4, keyed256 insertion/removal; keyed256 reorder/return; mixed false/true insertion/removal; text/image replacement/return. One initial frame,32 warm and384 measured updates (192 per direction) in each fresh process. Six blocks, rotated mode order followed by its reverse for each family:288 processes. No concurrent own build, cleanup or analysis. Software Vulkan llvmpipe LLVM20.1.2/Mesa25.2.8, LP_NUM_THREADS=4 on local AMD9950X/KVM8-vCPU VM. No hardware display/render-node claim.

| Family / direction | Raw p95 ms | Relocation p95 ms | Relative p95 ms | Stable p95 ms |
| --- | ---: | ---: | ---: | ---: |
| keyed4 insert | 1.6978 | 1.8124 | 1.8178 | 1.9626 |
| keyed4 remove | 1.3702 | 1.4671 | 1.4914 | 1.6036 |
| unkeyed4 insert | 1.8965 | 2.0153 | 1.9380 | 2.1572 |
| unkeyed4 remove | 1.5036 | 1.6046 | 1.5621 | 1.7855 |
| keyed256 insert | 9.0405 | 9.2368 | 9.0829 | 10.2794 |
| keyed256 remove | 8.6939 | 9.0052 | 9.0513 | 10.0990 |
| reorder256 forward | 8.7843 | 8.5462 | 8.6203 | 9.7039 |
| reorder256 return | 8.9423 | 8.6634 | 8.7170 | 9.6750 |
| mixed insert | 4.5854 | 4.7012 | 4.7452 | 4.7778 |
| mixed remove | 4.2675 | 4.3389 | 4.4400 | 4.4203 |
| resources forward | 3.1885 | 3.3483 | 3.5946 | 3.5911 |
| resources return | 3.1916 | 3.3149 | 3.5417 | 3.5456 |

Source-stage median-p50 summaries in keyed256 insertion are0.3964ms raw and0.4411ms stable, prepare/submit0.1728/0.3060ms, completion/ack/retirement7.1122/8.2403ms. Stage medians are separate summaries and do not sum to endpoint p95. The last stage is wall-clock waiting plus ack/drop, not GPU timestamp instrumentation or causal kernel profiling. This software full-render endpoint is dominated by that stage; the remaining global producer work is a structural limitation, not evidence that it dominates this endpoint's latency.

## Storage, churn and compaction

The fixed handle policy is bounded at4,096, with no recycling. Repeated deletion/reminting therefore accumulates directory rows despite small current scenes. Mixed stable directories grow290→3,537 rows during measured insertions and the handle allocation12,320→98,336B. Tiny unkeyed grows125→1,462 rows and3,104→49,184B handle allocation. Keyed4 grows26→217 rows; keyed25687→278. Reorder remains70 rows, resources4. No fallback occurs; these losses are inside the admitted bound, not an overflow artifact.

| Family (max both directions) | Raw CPU / GPU bytes | Relative CPU / GPU bytes | Stable CPU / GPU bytes |
| --- | ---: | ---: | ---: |
| keyed4 | 2888 / 1489 | 10640 / 2977 | 39200 / 24993 |
| unkeyed4 | 2920 / 1489 | 10720 / 2977 | 113500 / 37281 |
| keyed256 | 13992 / 9425 | 51712 / 18849 | 107752 / 33185 |
| reorder256 | 12952 / 9425 | 51472 / 18849 | 96000 / 33185 |
| mixed | 3288 / 67280 | 11152 / 69024 | 231248 / 124064 |
| resources | 2092 / 66640 | 7520 / 133280 | 7712 / 133280 |

Known CPU counts concrete version/state/Frame/Base and handle headers, current staged arrays, cloned Base arrays and observer capacities without double-counting embedded Vec headers. Known GPU counts unique live predecessor/current buffers, superseded copied buffers and atlas allocations; targets add16,384B and post-timing readback16,384B transient separately. CPU and GPU ratios are gated separately: maximum per-process directional coexistence payload, divided by matched raw maximum, worst of12 pairs≤4. This is a **known representation-payload** gate, not complete process memory. Opaque driver/pipeline/allocator state, hash-map control bytes, test-harness/sample storage, common producer diagnostics and temporary constructor allocations are not an exact retained-byte ledger. Their execution remains inside stated timing scopes; process RSS/HWM and parent requested-allocation captures are reported separately.

Stable mixed peak known CPU231,248B versus raw3,288B (**70.331×**) and unkeyed insertion113,500B versus2,920B (**38.870×**). Keyed4 GPU peak24,993B versus1,489B (**16.785×**); unkeyed removal37,281B versus1,489B (**25.038×**). Resources keep two private64KiB atlases during replacement:133,280B GPU versus66,640B raw. Relative/private raw use identical known payload; raw's smaller single-renderer lifetime service is stated explicitly.

Compaction is charged during measurement: summed across12 processes, stable keyed4 removal84, unkeyed removal108, keyed256 removal228, reorder forward72/return60, mixed removal144. None was excluded as setup; every retained arena remains under4× current dense-reference count+1,024. Final pixels match raw after churn, while the parent provides per-step/deferred-version lifetime and wrong-descriptor tests. Final equality alone is not new generic lifetime proof.

In warmed keyed256 insertions stable stages4,172–4,220B, copies16,544 GPU bytes, and carries growing directory/list storage; first-insertion5,052B from the parent is a different history. Mixed stable insertion stages1,208–8,504B as the directory grows, copies10,656–24,992B and may retain8,448B of superseded copied storage. Unkeyed insertion stages808–4,368B and can retain4,096 superseded bytes. Raw full payload stays7,992B keyed256 /1,320B mixed /1,336B unkeyed. Lower staged bytes coexist with larger copies, scans, directories and completion cost. Resource candidate updates stage128 instance bytes plus actual16-byte image /42-or70-byte mask payload, and copy1,056 bytes; raw keeps reusable masks after warmup. Every per-step counter is preserved.

## Cold and process scope

Cold device/pipeline setup, owner creation and initial-frame time are descriptive, outside acceptance. Owner setup excludes constructing the small model supplied to Win::recording. For keyed256, median device/pipeline setup is123.832ms raw /124.091 relocation /139.506 relative /125.105 stable; initial frame13.839/13.080/14.235/14.526ms. Relative's cold increase is retained alongside its failed warm decision; this is not a causally isolated shader-compile result.

Median end-before-oracle VmRSS in keyed256 is109.83/110.24/110.22/110.27MiB (raw/relocation/relative/stable); mixed111.65/112.00/112.03/112.01MiB. Resource raw/candidates111.61/111.87/111.89/111.88MiB. These process totals include software driver, pipelines, font/runtime/test diagnostics and preallocated samples, unlike the known-payload gate; they do not corroborate a70× whole-process increase. Initial, warm, end-before-oracle and after-oracle RSS/HWM are separately preserved. Canonical ELF and generated shader byte sizes are artifact scope, not shipping binary growth. Production library source is unchanged from the parent; this branch adds only the test harness/evidence.

## Provenance and architectural decision

Clean committed build/strict Clippy passed before timing. Completed parent cache was transferred to this unique target only after verifying parent guards/canonical artifacts; all seven first-party release packages were explicitly cleaned. Cargo checksum-freshness and actual executable freshness, original embedded WGSL, unchanged alternative WGSL, full input guards and driver/analysis hashes are verified. No source edit during compiler or timing gates. All samples, process order/exit/logs, final images, environment and storage counters are preserved; verifier recomputes the frozen decision. Local incremental floor2GiB; no Mothership use or altered8GiB rule. No deployment or pushes.

Raw is the current choice. Relative domains remove some prefix churn but fail the complete-cost gain/regression gates. Stable draw addresses preserve contributor references but their frozen nonrecycling directory, copied arena and private-version transport cost too much here. This rejects these implementations/policies under this endpoint; it does not prove every virtual-address scheme impossible. Do not tune reference encodings indefinitely or reopen paint/A/B campaigns.

The next investigation returns to the live producer boundary: keyed256 removal/reorder preserves267 semantic identities yet still performs267 reconciliation/index/layout insertions and267 paint visits. Mixed remints six of seven identities; resources preserve three and already showzero layout insertions. Existing fast cases must remain controls. Trace why shape-changing reconciliation reconstructs layout nodes, which exact identity/style/child-order/text/resource facts could preserve valid nodes/caches, and which ancestor/dependency invalidations must still propagate. Keep the326-byte outside-subtree damage and identical-cold/different-pixel witnesses. Any experiment must retain full producer/render oracles, charge description/reconciliation work, and avoid a parallel identity registry. Contiguous semantic storage exists; generic structural/dependency journal, integrated compression, coherent shared publication and qualified ZGX advantage remain missing.
