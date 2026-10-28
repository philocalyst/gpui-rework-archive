# Independent B cost: gate failed, large sparse advantage observed

**Not admitted under the frozen overall p95 gate.** Median paired B/control
ratios pass the sparse256/1,024 gain targets (0.49565/0.15477), but four tiny
regression cells exceed1.05: sparse9=1.09194, overlap9=1.09149,
overlap32=1.07654 and staircase1=1.17671. These use the identical baseline
publication/shader bypass path; the failing measured gate is not proof that
spatial indexing causes those differences. No alternate aggregation, trimming,
rerun or post-result fallback was used.

Against the practical fully raw serial alternative, B is faster in paired p95
at256/1,024 sparse,256/1,024 staircase and1,024 original overlap. At1,024 sparse,
raw/B=5.36686. B loses to raw in every32-node cell and original overlap256
(raw/B=0.86404). This is an informative locality/cost result, not blanket adoption,
a production GPUI speedup or a ZGX comparison.

Correctness parent23b533e8fe829bd88ed38d817689f95e6aa4c719; original B
preregistration f0dcdc8884f2824ebd8468f47050b79a0bd20e46; measured source
**e5720235ea0952c160eb803de99f4ee15faac795**. Branch local/display-traversal-cost
contains no A encoding or A+B combination and zero shipping-library changes.
A remains sealed separately with its original withheld verdict.

## Frozen endpoint and evidence

270 fresh processes,138,240 measured samples,17,280 warmups; six rounds ABBAAB,
three families × five sizes × three alternatives. Each process preserves64
warmups and512 measured intervals. Forty-five exact endpoint preflights passed;
initial/post-warm/final full-GPUI pixel checks pass in every timed process.
Strict Clippy, tracked source input guards, before/after dataset hashes and
preserved executable/shader identities pass. Public inputs regenerate byte for
byte from B's sealed correctness inputs. No concurrent experiment build/test/
analysis/cleanup occurred during timing; all sample rows and process statuses
are preserved. No samples or processes were excluded.

Endpoint: registered prototype binding patch through Python preparation,
JSON/IPC, actual Vulkan staging and GPU completion, reply and owner acknowledgement.
Public Source/View dispatch, full-render diagnostics and scanout are outside.
This is llvmpipeLLVM20.1.2 software Vulkan with four driver threads. Fresh process
initialization uses warm filesystem/driver caches; it is not cold app startup.

The per-cell statistic is the median of six paired per-round nearest-rank p95
ratios, for ALL gain AND regression clauses. The p95-ms columns below are medians
of process p95s; their ratios need not equal the paired-ratio columns. raw/B>1
favors B. Each family uses its own identical trace across alternatives; staircase
damages64×64 while sparse/original overlap damage32×16, so do not compare raw
visit totals or timing ratios across families.

| Scene | Nodes | Control p95 ms | B p95 ms | Raw p95 ms | Paired B/control | Paired raw/B |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| sparse | 1 | 0.1935 | 0.1846 | 0.2110 | 0.96270 | 1.18351 |
| sparse | 9 | 0.2271 | 0.2388 | 0.2313 | 1.09194 | 0.97746 |
| sparse | 32 | 0.6900 | 0.6870 | 0.4179 | 1.02029 | 0.62493 |
| sparse | 256 | 2.0178 | 1.0136 | 1.5743 | 0.49565 | 1.55317 |
| sparse | 1024 | 6.3174 | 0.9788 | 5.5422 | 0.15477 | 5.36686 |
| overlap | 1 | 0.1956 | 0.1989 | 0.2020 | 0.96787 | 0.96805 |
| overlap | 9 | 0.2659 | 0.2726 | 0.2448 | 1.09149 | 0.91055 |
| overlap | 32 | 0.7340 | 0.7805 | 0.4433 | 1.07654 | 0.54262 |
| overlap | 256 | 2.7598 | 2.4442 | 2.0927 | 0.87503 | 0.86404 |
| overlap | 1024 | 9.6773 | 7.2717 | 7.6129 | 0.76173 | 1.05500 |
| staircase | 1 | 0.1987 | 0.2228 | 0.2336 | 1.17671 | 1.00187 |
| staircase | 9 | 0.3847 | 0.3885 | 0.4300 | 0.98824 | 1.10378 |
| staircase | 32 | 1.2290 | 1.2466 | 0.7258 | 0.96920 | 0.59685 |
| staircase | 256 | 6.1510 | 4.1604 | 5.0434 | 0.68218 | 1.18445 |
| staircase | 1024 | 22.9848 | 12.6709 | 18.6527 | 0.55352 | 1.46439 |

All individual round ratios, p50/p95/p99 and preparation/staging/completion/ack
phase summaries are in raw/analysis.json. Large sparse gains are present in all
six paired rounds. This does not erase the fixed overall non-regression failure.

## What costs changed

At1,024 sparse, median process p50 worker submit-to-completion falls5.5667→0.6646ms;
preparation0.1616→0.1441ms. The intended gain is traversal; both compressed paths
stage972 bytes per timed edit, raw stages2,024. Original overlap stages956 and
staircase980 compressed bytes; B does not remove cold-block rewrites. Each update
still copies a compressed page plus COW node-directory path and frame root.
There is no hot A lookup, coherent shared memory or constant total GPU work.

At1,024 sparse, control/B/raw reserve25,552/28,272/74,192 arena bytes. All additionally
reserve28 argument,8 authority,16,384 pixel,4 unused audit and4 unused counter
bytes;16,384 diagnostic readback bytes are outside the interval. B's serialized
live heap is20,064 allocated/11,516 payload/8,548 fragmentation bytes, versus
control17,344/9,972/7,372. Heap high water21,040 includes960 free bytes and16-byte
null prefix. Current reachable Python graph175,303→217,743 bytes; raw215,003.
These include separately reported store identity and index structures, not only
GPU payload. Index wire root/list bytes256/1,288; CPU membership/mask/order/rank
bytes1,032/256/128/256. Forty-five preflights and all timed owners release every
fenced allocation at teardown; metadata capacities and free bins remain charged.

At1,024 sparse, median fresh worker/owner cold init403.3→790.5ms; original overlap
412.2→839.6ms; staircase414.3→810.2ms. This includes index construction, pipeline
creation and initial staging/completion. Worker peak RSS rises about45.6MiB
(123,122→169,860KiB sparse); do not mislabel unassigned driver/compiler/process
memory as just the small spatial index. The candidate is materially more
expensive to initialize in this software-driver endpoint.

Index construction scans1,024 bounds/32 pages, performs6,204 row/tile tests and
builds258 memberships in sparse. There is **zero spatial maintenance on paint**,
not zero overall maintenance. Geometry and structural work remain independently
charged in the correctness parent: the97-node move enumerates194 extent records,
examines2,231 identity entries, relocates82 rows, rewrites4,776 record bytes, then
rebuilds all99 live bounds/six page ranks/106 memberships;5,872 heap staged bytes
before args/authority. Paint timing does not contain or amortize that rebuild.
Likewise overlapping retained versions are in the correctness ledgers; this
cost endpoint deliberately serializes completion and cannot establish overlapping
frame latency. The spatial lease mutant still corrupts76 audit bytes with correct
final pixels, demonstrating why pixel equality alone is insufficient.

## Requirement matrix and decision

| Requirement | Status |
| --- | --- |
| Original compressed/raw records, bounded COW node/spatial directories | Implemented in executable model |
| Direct admitted paint to exact GPU pixels without global index work | Implemented; restricted public binding adapter |
| Unrelated-subtree locality, visible-sibling adversary | Implemented bounded fixtures; correctness parent |
| Complete staged publication/completion cost | Measured prototype/IPC endpoint; overall gate failed |
| Geometry/structural maintenance and overlapping version lifetimes | Implemented and charged separately in correctness, not timed here |
| Indexed text/images and generic production dependency journal | Still missing |
| Coherent shared memory, physical hardware/scanout and ZGX victory | Still missing |

Keep B as an unadopted architectural candidate with a strong measured large-sparse
locality result and explicit tiny/raw/cold-memory counterexamples. Do not rerun
this sealed campaign for admission or combine A without independent evidence.
The next integration decision must address the missing live production journal
and representation/resource consumers; a Python binding endpoint cannot supply
those guarantees. Raw remains a serious complete alternative, especially at32
records and moderate overlap.

Replay evidence integrity and independently recomputed ratios:
`PYTHONDONTWRITEBYTECODE=1 python3 reactivity/evidence/display-traversal-cost/verify.py`.
