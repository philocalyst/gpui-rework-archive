# Live same-slot chain cost: NOT ADMITTED

The frozen gate fails the 1,024-node single-edit control: median-of-six paired p95 ratio **1.103170 > 1.05**. All four large coalesced/return-original gain clauses pass, but they do not waive this failure. No admission, shipping adoption, rerun, threshold revision or additional paint optimization follows this campaign. The observed regression is not by itself proof of a reproducible causal mechanism. A remains admission-withheld; independent B remains NOT ADMITTED.

Actual live public `Win::set` → native packet → GPU completion → `Win::presented`, using the existing raw renderer on software Vulkan. No Python/offline adapter or IPC is inside the measured operation. It includes source work, render preparation/submission, GPU completion wait, acknowledgement, retained repair and presentation copy. It excludes WSI/scanout, process initialization, oracle rendering/readback, logging and storage diagnostics. This is not a displayed frame, hardware result or ZGX win.

## Frozen comparison

Protocol commit `4c14e2a31d1e61a71527b2ae58c339711acc07bc`; [complete protocol](PROTOCOL.md). Candidate correctness `55adff11c0d205bf3a59fdda07e7bcc713305329`; control `b2d48370d75482e300befd81d4f0bcbbedd560c7`. Measured identical-harness commits: candidate `30c1bbae64`, control `2ab7119928` (full SHAs in frozen source files). Both generated production shaders are identical and embedded in their distinct executed ELFs.

408 fresh sequential processes, 64 warmups + 512 measured samples each: **208,896 measured samples / 26,112 warmups**. Six ABBA/BAAB rounds; all statuses, full logs, all six ratios, per-process p50/p95/p99 and phases preserved. Per-process p95 uses nearest rank; each round ratio is the geometric mean of two candidate p95s divided by two control p95s; every gate uses the median of those six ratios. Displayed p95 columns are medians of twelve process p95s and their quotient need not equal the paired ratio.

| Mode | Nodes | Control p95 ms | Candidate p95 ms | Paired ratio | Limit | Pass |
|---|---:|---:|---:|---:|---:|---|
| single | 1 | 0.1854 | 0.1892 | 0.961816 | 1.05 | yes |
| coalesced | 1 | 0.2147 | 0.1931 | 0.893041 | 1.05 | yes |
| return-original | 1 | 0.2174 | 0.1925 | 0.834825 | 1.05 | yes |
| geometry | 1 | 0.2939 | 0.2952 | 0.957996 | 1.05 | yes |
| single | 9 | 0.2232 | 0.2060 | 1.003914 | 1.05 | yes |
| coalesced | 9 | 0.2586 | 0.2436 | 0.929892 | 1.05 | yes |
| return-original | 9 | 0.2521 | 0.2117 | 0.840432 | 1.05 | yes |
| single | 32 | 0.1979 | 0.1981 | 1.032886 | 1.05 | yes |
| coalesced | 32 | 0.2376 | 0.2054 | 0.855224 | 1.05 | yes |
| return-original | 32 | 0.2409 | 0.2011 | 0.881934 | 1.05 | yes |
| single | 256 | 0.1984 | 0.2045 | 1.032451 | 1.05 | yes |
| coalesced | 256 | 0.2810 | 0.2021 | 0.738192 | 0.80 | yes |
| return-original | 256 | 0.2993 | 0.1935 | 0.647135 | 0.80 | yes |
| single | 1024 | 0.1828 | 0.2101 | 1.103170 | 1.05 | **NO** |
| coalesced | 1024 | 0.5054 | 0.2142 | 0.432918 | 0.80 | yes |
| return-original | 1024 | 0.4940 | 0.1783 | 0.356892 | 0.80 | yes |
| geometry | 1024 | 0.9617 | 0.9406 | 0.983007 | 1.05 | yes |

The failing single1024 round ratios are 1.155949, 1.310834, 1.026737, 1.244107, 1.050391 and 0.925074. Single1024 median process stage-p95s (control→candidate) are source 0.762→1.518µs, render/submit 20.854→28.609µs, completion wait 164.835→182.728µs and ack 0.125→0.236µs. Stage percentiles do not sum to endpoint p95, and completion wait is not isolated GPU time. No causal attribution or follow-up timing campaign is inferred.

## Work, storage and cold costs

At 1,024 nodes, coalesced staging/validation/bin visits change **114,960B/1,024/8,220 → 16B/0/0**; return-original changes to **0B/0/0**, while retained repair and full 4096-pixel presentation copy still run. Single remains 16B/0/0 in both roles. Geometry remains full fallback, alternating 114,960–114,976B/1,024/8,220–8,224 visits in both roles. At 1 node its fallback stages 368–376B. These reductions are separate from latency. No resource/geometry transition gained authority.

Known renderer capacities are identical by role:

| Nodes / mode | Raw records B | CPU packet/index capacity B | GPU buffers B | Retained image B | Target B | Atlas B |
|---|---:|---:|---:|---:|---:|---:|
| 1 / single | 144 | 480 | 480 | 16384 | 16384 | 1 |
| 9 / single | 912 | 1392 | 1488 | 16384 | 16384 | 1 |
| 32 / single | 3120 | 3968 | 5328 | 16384 | 16384 | 1 |
| 256 / single | 24624 | 29056 | 41168 | 16384 | 16384 | 1 |
| 1024 / single | 98352 | 115072 | 164048 | 16384 | 16384 | 1 |
| 1024 / geometry | 98352 | 131472 | 164048 | 16384 | 16384 | 1 |

The retained chain header is 40→48B (+8B); previous correctness measured bound mount +8B, no allocation count increase, and 1,000 same-slot writes with zero allocations/bytes. This campaign does not profile allocation inside timing. Model/Canvas storage, allocator overhead, temporary oracle resources and driver/compiler allocations are not fully itemized. Process RSS includes all test/oracle/driver resources; it is not whole-application attribution.

Fresh-process initialization (warm OS/driver caches) is separate. At 1 node single: control137.209ms/candidate139.174ms; at 1,024 single245.259/246.614ms, coalesced241.752/248.352ms, return-original241.840/247.429ms, geometry257.511/247.437ms. Corresponding1,024 process maximum-RSS medians are 128,430/128,560KiB;128,364/128,376KiB;128,346/128,402KiB;128,512/128,666KiB. All cells are recorded in analysis.json. No cold or memory speed claim follows these descriptive values.

## Qualification and preservation

34 preflight processes ×13 initial/per-edit comparisons =442 exact four-way pixel comparisons;408 timing processes ×3 initial/post-warm/final comparisons =1,224 more. Independent fresh-window CPU and full GPU renderers remain oracles. Both strict all-target Clippy gates, clean source before/after guards, identical harness/shader checks and actual fresh executed ELF checks pass. All processes exited0 and every sample/log pair is retained. Geometry and foreign-slot authority counterexamples remain in the parent correctness dossier; no new correctness campaign was added.

`raw.tar.gz` losslessly contains the complete external capture, including errors, configs, ordered processes, logs, pixels, guards, toolchain, compiler JSON, cache-reclaim receipts and analysis inputs. `RAW_MANIFEST.json` hashes every archived file. The first cache-reclaim attempt assumed the older Cargo deps layout and stopped before mutation; the preserved rejected script and corrected recursive manifest document this bookkeeping correction. Canonical ELFs remain in the external content-addressed store; only verified duplicate binaries and completed regenerable caches were removed. `verify.py` checks the archive, pixels, samples, aggregation, gates and local canonical binaries when available.

## Transfer back to subtree journals

Exact predecessor, namespace and immutable interpretation are reusable certificate invariants. `(C0→C1,key s)+(C1→C2,key s)` may compose only if the renderer still owns C0 and the key continues to name the same object with the same structural/resource meaning. Failed preparation, foreign destination, replacement, unsupported geometry/resource changes and stale acknowledgement must revoke or reject authority. Equality of the last value never supplies missing history.

A semantic subtree transition needs a different representation: an identity tied to generation/namespace; an ordered structural extent for both old and new versions; explicit parent/child/order changes; ancestor/layout/clip/transform and overlapping-contributor closure; and versioned resource leases plus publication/completion authority. A PaintSlot supplies none of those extents or dependencies. A fixed-size certificate can publish a reference, but arbitrary replacement still costs proportional to changed payload and affected rendering. This experiment changes neither tree representation nor compression/shared-memory model.

The existing runtime already stores a contiguous preorder Node vector and semantic identities, with arithmetic identity lookup for a contiguous identity run and compact run/index fallbacks. Complete description rebuilds that mapping, reconciles identity and materializes new nodes. Semantic identity is not arbitrary positional continuity: unkeyed run shape changes remint identities, while admitted keyed list rows have different survival rules. The next architecture work must preserve those rules and charge the description/reconciliation boundary instead of hiding it behind an offline snapshot adapter.

| Requirement | Status after this campaign |
|---|---|
| Ordinary Source→retained raw GPU pixels | Implemented existing production path; measured here |
| Bounded same-key authority composition | Correctness qualified; cost NOT ADMITTED |
| Contiguous CPU preorder and logical identity lookup | Existing, rebuilt on full description |
| Stable semantic subtree→ordered GPU extent | Missing |
| Structural/dependency/resource journal | Missing |
| Integrated lossless compressed retained tree | Missing; earlier restricted prototypes do not compose into production |
| Coherent shared CPU/GPU memory | Missing; staged queue writes remain |
| ZGX end-to-end hardware superiority | Missing |

Continue with structural identity/extents and dependency/resource closure; do not expand into more paint special cases or combine A/B. All changes remain local.
