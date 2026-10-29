# One bounded live same-slot chain cost decision

Candidate correctness55adff11c0d205bf3a59fdda07e7bcc713305329 (shipping source
a10c29e6e0c62415609bf242e542f0778bceced7); live raw control
b2d48370d75482e300befd81d4f0bcbbedd560c7. Existing single-edit16B/0/0 remains the
baseline. Header40→48B and bound mount+8B remain costs. A/B prior verdicts remain
unchanged. No compression, A encoding, distinct-slot optimization or new registry.

## Identical live workload and endpoint

The same Rust test harness/source fixture is frozen in two isolated worktrees,
with separate targets and preserved executables. Ordinary Win::recording of the
qualified64×64 rectangle fixture, one bound color/transform, increasingly many
unrelated visible rectangles. n=1/9/32/256/1024. Integer clipping/opaque endpoint
colors match independent fresh Window CPU and full GPU oracles. No Python model,
JSON/IPC or cached offline binding in the measured operation.

Three primary workloads at every size:
- single: one Win::set color per frame; cycle White/Red/Blue/Black.
- coalesced: two actual changes per frame; first the next cycle color, then the
  current cycle color. Both source operations occur before native consumption.
- return-original: White then Black each frame, starting/ending acknowledged
  Black. Valid chain permits zero staged record bytes, but repair/copy still run.

Declared fallback control: geometry at n=1 and1024, alternating target x=16/0
through its public transform source with fixed Black. It keeps full preparation;
these two fallback cells are measured and enter non-regression gates. No new
structural/geometry optimization is part of this experiment. Total17 cells.

Measured interval starts before the first public Win::set and ends after
with_paint_scene→the actual private native render_packet→queue submission→GPU
completion wait→Win::presented acknowledgement. Capture source, render/submit,
completion-wait and ack phase durations; completion-wait is not isolated GPU
time. Retained repair and4096-pixel presentation copy are inside. Reuse the
resident context/target per process. WSI acquisition/presentation, display scanout,
process startup, oracle renders/readbacks, JSON logging and memory diagnostics
are outside the steady interval. This is actual live GPUI offscreen GPU packet
latency on software Vulkan, not a native displayed-frame or hardware/ZGX claim.

Each process records fresh-process initialization (warm OS/driver caches) separately,
64 warmups then512 samples. Verify full pixels initially, after warmup and after
measurement. Before timing, run all17 cells × both roles with12 per-edit oracle
checks; preserve complete stage-byte/work counts and current source counters.
During timing preserve each completed sample in a line-buffered file after its
interval. Do not trim, replace, rerun or silently omit failed/slow samples.

## Exact process order and aggregation

Six rounds, four fresh processes per cell per round. Even rounds run
control,candidate,candidate,control (ABBA); odd rounds candidate,control,control,
candidate (BAAB). Rotate the fixed size order1,9,32,256,1024 by round modulo5;
reverse mode order single,coalesced,return-original on odd rounds. The geometry
control follows those modes at n=1/1024. Preserve the complete generated process
order before execution.408 processes,208896 measured samples,26112 warmups.
This symmetric pairing addresses the process-order/noise observed in A/B without
reinterpreting or rerunning either sealed campaign.

For each process, p95 is nearest rank ceil(.95*512)-1 in sorted samples. For each
cell/round, ratio R=sqrt((p95_candidate_1*p95_candidate_2)/
(p95_control_1*p95_control_2)). Per-cell summary is median of its six R values.
Use this EXACT aggregation for EVERY gain and regression clause. Report all six
R values, paired range and each process p50/p95/p99, not just aggregate columns.
Ratios of aggregate displayed percentiles need not equal these paired summaries.

Fixed admission: summary<=0.80 for coalesced256/1024 AND return-original256/1024;
summary<=1.05 for single at all five sizes, coalesced/return-original at1/9/32,
and both geometry fallback cells. All clauses must pass. A failure remains a
failure; identical-path/noise observations do not waive it or prove causal
regression by themselves. No post-result thresholds/fallback changes. There is
no additional optimization/timing campaign within this bounded paint experiment.

## Provenance, storage and architectural handoff

Freeze clean source before each build/preflight gate. Check all tracked present
source/manifests/vendor inputs before/after, actual rebuilt libraries/test ELF,
identical generated shaders inside both executables and byte-identical harness
source. Preserve compiler/toolchain/features/driver/thread settings. Generate
immutable case configs, hash them and scripts before AND after timing. No other
experiment builds/tests/analysis/cleanup while timings run; role processes do not
overlap. Preserve errors and partial event logs; reap owned workers.

Report recorded CPU packet/index capacity, logical raw record bytes, all GPU
buffers/retained image/empty atlas/targets, cold initialization, process RSS and
allocation/header evidence from correctness. Distinguish driver/compiler memory,
model/Canvas state and temporary oracle resources from known renderer capacities;
no claim of whole-app accounting from a subset. Warm update allocations0 and
summary+8B are established separately; do not add an allocator profiler inside
timing. Raw representation, geometry full path and original full-render oracles
remain independent controls. Work/staging reduction is separate from latency.

After this single verdict, return to semantic subtree identity, structural extents,
ancestor/layout/clip and resource closure. Explain that exact same-key endpoint
composition generalizes as a certificate requirement, but one PaintSlot cannot
encode structural operations or arbitrary dependencies. No tree representation
changes here; cold compression remains a separately accounted hypothesis. All
changes remain local; no shipping adoption from this endpoint alone.
