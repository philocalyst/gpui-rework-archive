# Layout preservation cost — both variants NOT ADMITTED

Ordered and Append are **NOT ADMITTED** by the frozen gates. Ordered fails nine timing clauses and one storage clause; Append fails fourteen timing clauses and one storage clause. Retain original automatic layout behavior with the same serial raw renderer. Do not retune/reinterpret/rerun this closed campaign. Bounded CPU handle/cache correctness remains established at99e08a91501979280cc212beb1763a1cb5c35bbb; it is not a performance admission.

Protocol6c61b638f5f934c41116e3eb07cdc961672c93f9; executed source7c9f832ef750ee3c010083b1456f63368e85f235; frozen driver/analyzerb741a3330429f5896f95a771c16785bedec9d946. All288 serial processes completed,110,592 measured updates,576 post-timing allocation probes, final fresh-layout/CPU-pixel and within-GPU full-render comparisons passed; build/strict Clippy/source guards/canonical ELF/unchanged shader pass. No timings were rerun. Inherited mixed CPU/GPU48-byte gate remains FAILED and was not revisited.

## Fixed result

Primary four cells require Source p95≤0.80 and complete endpoint p95≤0.95 versus Automatic. Other twelve cells require both≤1.05. Every ratio uses the same median of six block scores, each geometric mean of matched forward/reverse process-p95 ratios. Lower is better. Displayed aggregate p95s are not the ratios' denominators; do not divide medians to reproduce paired scores.

| Family/direction | Ordered Source | Ordered total | Append Source | Append total |
| --- | ---: | ---: | ---: | ---: |
| keyed4 forward | 0.955913 | 0.981037 | 1.100248 | 1.013108 |
| keyed4 return | 1.017940 | 0.969187 | 1.124715 | 1.031591 |
| unkeyed4 forward | 1.165868 | 1.051675 | 1.131888 | 1.094889 |
| unkeyed4 return | 1.142576 | 1.087498 | 1.216202 | 1.136247 |
| keyed256 forward | 0.891030 | 1.012877 | 0.971236 | 1.114001 |
| keyed256 return | 0.875426 | 1.029342 | 1.001850 | 1.071744 |
| reorder256 forward | 0.811926 | 0.896841 | 0.821307 | 0.914015 |
| reorder256 return | 0.785606 | 0.901200 | 0.804738 | 0.952037 |
| unkeyedmove forward | 0.943507 | 0.906637 | 0.954828 | 0.923023 |
| unkeyedmove return | 0.986854 | 0.956900 | 0.843206 | 0.979735 |
| resources forward | 1.007366 | 1.040865 | 0.901690 | 0.981042 |
| resources return | 1.036858 | 1.005279 | 0.819123 | 0.970873 |
| constraints forward | 0.940433 | 1.010785 | 1.053422 | 1.049138 |
| constraints return | 1.016369 | 0.990967 | 1.030118 | 1.023408 |
| measured forward | 0.927506 | 1.011528 | 0.981832 | 0.976484 |
| measured return | 0.904203 | 0.957228 | 0.913957 | 0.972716 |

Ordered's large reorder endpoint ratios0.896841/0.901200 are useful measured gains in this endpoint; the forward Source ratio0.811926 still fails its fixed0.80 requirement. Large insertion/removal Source ratios0.891030/0.875426 improve but miss0.80; complete ratios1.012877/1.029342 fail0.95. Unkeyed insertion/removal Source1.165868/1.142576 and total1.051675/1.087498 violate regression limits. No waiver for near-threshold/noisy cases. Append's large insertion/removal total1.114001/1.071744 and unkeyed1.094889/1.136247 are losing cases; its constraint-narrow Source1.053422 also fails. These observations do not isolate reproducible causal overhead from scheduling/clock/cache noise; unchanged-path controls also fluctuate.

For scale, median process p95s in keyed256 insertion are Automatic Source0.690547ms/complete3.532767ms and Ordered0.598460ms/3.467640ms. The paired total score nevertheless is1.012877. Reorder forward Automatic0.628096ms/2.253008ms versus Ordered0.517442ms/1.893989ms. These software completion/ack measurements are neither production display latency nor the prior address campaign's full-render transport endpoint. They use the actual native render_packet decision and retained serial raw renderer in all modes. Completion-wait p95 is still large (insertion Automatic2.599620ms/Ordered2.627873ms), so saved producer operations cannot be carried over as total-frame gains.

## Storage, allocation and work

Both candidates fail the small keyed removal layout-storage gate: **8,320 versus6,336 bytes,1.313131×**, over the fixed1.10× limit. This is retained high-water arena capacity: the earlier17-node insertion grows topology/lane capacity; removing back to15 keeps it. The sealed correctness trace locates the difference: Ordered topology896 versus448, lanes3,616 versus1,808; cached payload2,520 and704-byte headers match; runtime handle capacity240 versus512 partially offsets that growth. This concrete mechanism explains storage, not latency. No arena shrink/reset retune follows this result.

Large insertion current known layout80,424 versus84,312 bytes and removal80,032 versus83,952 remain modest reductions. A large part is exact-length handle vector capacity, not compressed storage. Measured-tree4,904 versus4,824 bytes and Source peak7,043 versus7,007 (forward),7,034 versus6,998 (return) remain explicit losses. All renderer GPU-byte ratios are1.0; Source peak gates pass, including unchanged183,344/183,288-byte large insertion/removal peaks. Known layout/renderer ledgers are incomplete payload attribution, not whole application/RSS claims. The same344-byte experimental State and40-byte core counters are included in all selectors. No feature-off shipping bytes or latency were inferred by subtraction.

Post-timing warmed Source allocation for keyed256 insertion is432,024B/193 allocations versus589,560B/273; removal430,222B/189 versus587,926B/270. These are later alternating-update histories and differ from the initial correctness trace's423,504/581,024 numbers. Both are reported in their scopes. Reduced requested allocation does not lower the measured Source peak. Samples are preallocated benchmark storage, separately recorded; requested allocations include existing test observers and exclude final diagnostic snapshots/oracles.

Remaining work is unchanged from qualification:269 correspondence/preflight/handle/order visits plus267 removal checks for large insertion, temporary1,220-byte plan,4,304-byte new handle vector while old capacity is live,200-byte frontier. Source still globally describes/reconciles/updates identity indices and paints. Measured route construction/sort/qualified lookup is charged within Source. All paths use the same renderer and resource authority. Example insertion stages7,992 instance bytes, validates71 draws, visits486 tile bins, composites957 pixels and copies4,096, one actual renderer submission; reorder stages7,872, validates70, visits476, composites576 and copies4,096. These work counters are not GPU timing. The structural layout improvement creates no16-byte paint publication claim.

Device/pipeline and owner setup are descriptive cold metrics: keyed256 median owner setup Automatic0.7162ms, Ordered0.7647ms, Append0.7888ms; initial frame18.4661/19.0936/19.6816ms. Device/pipeline156.1646/155.9187/174.9270ms. Cold regressions are retained, not gated away. Process RSS/HWM includes driver/device and later oracle pipelines; representative keyed256 end-before-oracle approximately110MiB, after-oracle approximately127MiB, not a layout-memory total. Every process's initial/warm/end/after-oracle records are preserved.

## Endpoint and limitations

Clock includes value construction, ordinary Win::set, source/layout/paint, original packet decision/preparation/upload/submission, actual GPU completion wait and acknowledgement. No IPC/readback/JSON/allocation-counter wrapper in that interval. Same feature/profile/ELF/counters/observers in all alternatives. Scalar samples and O(slots) current-layout storage reporting run after each timed endpoint in every mode; they can condition next-frame caches. Post-timing allocation probes wrap only Source, followed by rendering/ack outside that wrapper. Per-update producer and preservation metadata are inside Source. No diagnostic-free production endpoint was measured.

Native recording offscreen64×64, llvmpipe Vulkan withLP_NUM_THREADS=4, six paired blocks,32 warm/384 measured updates per process; source/platform/canonical identities in raw. No WSI/scanout, hardware GPU, production application or ZGX claim. Within-backend GPU oracle equality does not repair the inherited cross-backend failure. All original failed-newer/poison/remint/routing controls remain in the prior sealed qualification; no unrelated broad correctness campaign was repeated here.

## Decision and next boundary

Close both preservation variants as NOT ADMITTED. The worthwhile architectural evidence is that actual correspondence can preserve qualified handles/cached answers, while arena high-water storage and full producer work can outweigh its benefit. The initial failed-description certificate cleanup and final revocation fix remain in the parent dossier. No adoption, shipping fallback heuristic or threshold tuning is implied.

Continue investigating the remaining live producer/reconciliation boundary with measured and diagnostic work clearly distinguished before selecting another representation. Full description/paint, local structural/dependency journals, semantic-node→GPU emission/resource closure, compressed persistent CPU/GPU storage and coherent shared memory remain open. This experiment does not solve those requirements. All changes stay local.

Run `python3 reactivity/evidence/layout-preservation-cost/verify.py` to verify manifest, frozen sources, canonical executable/shader, every process result/pixels, source guards and exact frozen analysis/verdict. First-party non-test inventory remains38,710; new cost harness/ledger methods are test-only. Dossier raw payload/counters are evidence, not new production mirrors.
