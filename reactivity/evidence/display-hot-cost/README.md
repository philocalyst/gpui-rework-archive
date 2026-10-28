# A timing decision: publication savings, but no unqualified admission

**Conservative fixed-gate verdict: not admitted.** The sparse median p95 targets
pass: hot/control ratios **0.88225 at256 nodes and0.92282 at1024**, both below0.95.
Three tiny individual process pairs exceed the1.05 regression limit. The original
protocol explicitly assigned median per-round ratios to the sparse targets but
not explicitly to its regression clauses. A median-only reading passes all
clauses; the conservative per-round regression reading fails. We retain both
interpretations and withhold admission rather than choose the lenient reading
after seeing the data. No thresholds, fallback choices, samples or order changed;
no attempt was rerun to obtain a passing result.

The serial raw control is also faster than compressed A in every32/256/1024 case
by median paired p95. At1024 its raw/A ratio is0.86843 sparse and0.83370 overlap.
That is the strongest cost counterexample: reduced publication bytes do not
justify selecting compressed A over raw rendering by default. A remains a
correctness-qualified upload/storage alternative, not a general performance win.
B will separately investigate traversal with original record encoding.

This is **registered prototype binding patch → Python preparation and JSON/pipe
→ actual Vulkan staging/encode/completion → reply and owner acknowledgement**.
It is not production GPUI Source/View latency, native presentation, scanout,
physical hardware performance or a ZGX comparison. Full public GPUI/fresh-Window
pixels are independent correctness oracles outside the timed interval. Software
Vulkan llvmpipe/Mesa25.2.8,LP_NUM_THREADS4, pinned nightly2026-10-23 locked offline
release build; no other experiment work overlapped measurements.

Correctness A baseline d40381fa539f2b58b400785b386fe8477bba0954, original radix
bb21d11455b6a03d134f99377c5a16b983fac27f. Timing preregistration was32878eff7a8.
Worker/public fixture build source66182d8bcf7f6858686b554dd7c42da97a304692;
measured owner/logging source64240a0ad892d99e5f0a5604a73b1042a953b116.
The logging-only change preserves completed observations and reaps the worker;
Rust executables, A/radix models and shaders are unchanged. Both exact shader
sources are checked inside the executed worker ELF. The control actually uses
the original radix shader, not A's shader with zero hot cells.

## Frozen comparison

180 independent owner/worker processes: six rounds × two scene families × five
sizes × three roles. Each has64 warmups +512 measured edits: **92160 samples**
and11520 retained warmups. Primary order is ABBAAB across rounds; raw follows
each pair. Tiny fallback was selected before timing: raw pages at1/9, compression
at32/256/1024 for both primary roles. A separate fully uncompressed control runs
at every size. Same32×16 edit area, color cycle and serialized completion policy.
No sample trimming or slow-process exclusion. Every process's final pixel check
passes and all before/after source guards match.

Table values are medians of six process p95 times. Ratios are medians of paired
per-round ratios, so they need not equal ratios of the displayed medians.
Quantiles use nearest rank `ceil(p*n)-1`; all p50/p95/p99 and phase samples remain
in raw/. Preparation, worker phases and IPC are attribution, not added substitute
endpoints. JSON-line logging occurs after each measured interval; that harness
I/O between intervals is explicit and identical across roles.

| Scene | Nodes | Control p95 ms | A p95 ms | Raw p95 ms | Paired A/control p95 |
| --- | ---: | ---: | ---: | ---: | ---: |
|Sparse|1|0.2165|0.2008|0.2000|0.93722|
|Sparse|9|0.2543|0.2272|0.2405|0.88175|
|Sparse|32|0.7063|0.4817|0.4289|0.72584|
|Sparse|256|2.3354|1.9200|1.9314|0.88225|
|Sparse|1024|7.0866|6.5681|5.7808|0.92282|
|Overlap|1|0.2322|0.2185|0.2145|0.95234|
|Overlap|9|0.2694|0.2537|0.2790|0.92048|
|Overlap|32|0.7963|0.5331|0.4459|0.73590|
|Overlap|256|2.7342|2.6166|2.1902|0.95261|
|Overlap|1024|9.9619|9.6740|7.8629|0.96820|

The three conservative regression failures are sparse1 round3=1.11138,
sparse9 round0=1.24637, and overlap1 round3=1.08612. Tiny median ratios improve,
and even independently repeated identical raw/control cases vary. That makes
these observations noisy; it does not authorize deleting them or retroactively
changing the regression statistic.1024 overlap passes under either reading
(maximum individual ratio below1.0). Future preregistrations should specify the
aggregation for every clause explicitly; this capture remains unchanged.

At1024 sparse, median process p50 preparation drops0.1980→0.0456ms; worker
submit/completion drops5.8300→5.6930ms. At1024 overlap, preparation drops
0.2276→0.0598ms while worker completion is8.7150→8.7439ms. Thus the mechanism
primarily removes model publication work; full traversal and version lookup still
consume the dominant worker time. These phase quantiles must not be summed into
a fabricated end-to-end percentile.

## Retained cost and limits

For the serialized sparse case (round0; exact per-round ledgers retained):

| Nodes | Control arena capacity B | A arena capacity + hot B | Raw arena capacity B | Control heap high-water B | A heap high-water B |
| ---: | ---: | ---: | ---: | ---: | ---: |
|1|8336|8336+48|8336|272|208|
|9|8784|8784+48|8784|1168|656|
|32|9680|9680+48|10320|2960|1552|
|256|12752|13264+48|25040|5520|5136|
|1024|25552|26064+48|74192|18320|17936|

Arena capacity includes an explicit8192B reserve beyond initial construction,
never grown or hidden during timing. The baseline/raw worker also allocates a4B
unused hot binding. Both use16384B retained pixels,28B arguments,8B authority,
4B unused audit binding, and a separate16384B diagnostic readback buffer. Driver/
pipeline allocations are not attributed by those wire-buffer ledgers.

At1024 sparse, A has *lower used heap high-water but higher reserved GPU capacity*
than control. Current live COW allocations are17856B versus17344B; meaningful
payload/directories/root10016B versus9972B. CPU reachable model objects are177812B
versus175303B. A's worker peak RSS is roughly4–5MiB higher across these processes;
RSS includes code, allocator and driver/compiler overhead, not just hot cells.
The earlier overlapping-lifetime storage saving must not be substituted for this
serialized measurement. Dense1024 hot keys still cost49152 GPU bytes before CPU
metadata, as measured in the qualified correctness model.

A's admitted staged publication remains104B excluding the4B audit-count argument;
the actual timing endpoint uploads **108B/edit**, four queue writes.1024 sparse
control uploads972B/edit and raw2024B/edit. These are measured staging bytes,
not coherent shared memory, constant total work, a speedup, or eliminated stale
upload waste. Full traversal remains N×damage area. The old-color eviction
counterexample remains in d40381: round-robin loses4 decoded bytes while final
pixels match because stale rendering is suppressed.

Cold values record fresh-process representation/device/pipeline construction
from already admitted records, with warm OS/driver caches. They are not cold
application startup or flushed-cache benchmarks. Source dispatch/admission and
full renderer diagnostics are excluded from the stated endpoint. Process peak
RSS is reported separately from retained model objects and explicit GPU buffers.

Thirty exact endpoint preflights cover all scene/size/role combinations; three
additional largest sparse cases check the logging-only harness change. Timing
processes verify initial, post-warmup and final pixels against the full public
renderer files. Generated fixture inputs have post-run content digests and all
mtime/ctime predate timing; unlike source files, a separate pre-timing dataset
digest was not captured. Executed binaries were hashed before timing and again
after. All evidence, process order, logs, samples and this limitation are retained.

Run `python3 verify.py` to hash the dossier, check executed binaries/embedded
shaders and preflights, verify every line-buffered sample against its process
result, rederive all180 process distributions/92160 samples and both gate
interpretations, and recheck source guards. No files were published or adopted.
