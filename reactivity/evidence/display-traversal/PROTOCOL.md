# B: damage-directed traversal, original record encoding

Independent parent bb21d11455b6a03d134f99377c5a16b983fac27f. No A hot encoding,
no A+B combination. Unchanged12-u32 compressed/raw record format and same COW
node directory. Prior A cost be4833a9cfe2fa41acc7cd61338b5851984793e3 observed
sparse median gains, but admission was withheld because regression aggregation
was underspecified and a conservative interpretation failed. Noisy individual
pairs do not establish reproducible causal regressions. Raw serial beat compressed
A at every tested32/256/1024 case; preserve that memory/decode tradeoff and paired
summary distinction. Do not rerun or reinterpret the sealed A campaign.

## Mechanism

Coarse8×8-pixel tiles over the admitted64×64 offscreen surface. Each tile stores
an ordered list of conservative contributing chunk IDs. A chunk mask is the
union of all live rows' raster supports, including transparent rows conservatively.
Lists preserve logical painter page order, never numeric physical-page order.
The GPU visits every record of listed chunks and applies the same exact per-row
clip/rect predicate. A list may overinclude; it must never omit contributing
siblings. Initial clipping/transforms are already lowered into admitted exact
integer raster supports by the public renderer. General effects/clip transforms
remain unsupported, not approximated.

The GPU index uses an immutable256B root of64 list pointers. Each tile payload
contains a count and ordered u32 page IDs. A frame root owns both node and spatial
roots, so old deferred work cannot combine a newer index with old node payloads.
A paint-only delta does not change bounds or memberships and must not scan/copy
the index. Bounds changes recompute only affected page masks, update affected
tile lists in painter order and charge every copied/examined membership and root
word. Current page masks, order/rank lookup, CPU list copies, heap references,
fragmentation, scratch and all in-flight versions are explicit costs.

The first structural policy deliberately rebuilds page order/ranks and masks
from the full page chain on insertion/removal/move. Charge this O(N) work and all
list comparisons/copies. It is a structural counterexample, not an incremental
structural claim.97-node movement remains in the corpus. Stable identity gives
start lookup; it does not make either extent enumeration or spatial maintenance
constant. No generic public dependency journal or coherent shared memory claim.

## Decisive fixtures and correctness gates

Reuse A cost's sealed sparse/overlap public fixtures as fixed controls after
capturing their content digests BEFORE any new execution. Sparse: same32×16
source edit, increasingly many unrelated visible subtrees outside its support.
At256/1024 records, added unrelated chunks must not increase rendered record
visits (root and target chunks can remain conservative false positives).

The previous overlap fixture has an opaque target drawn last, so its underlying
rectangles are potential contributors without an occlusion certificate; it does
not prove all are inherently necessary. Add a stronger independent public source
fixture: root background is the edited source; above it, up to1023 one-pixel-high
staircase rectangles overlap within rows. Each successive rectangle begins one
pixel later and extends to the right edge, alternating colors. Each node retains
at least one visible pixel. All those siblings legitimately contribute to the
repaired image, even though an index can localize them by tile. Painter reversal
or dropping a contributing sibling must fail the full renderer pixel oracle.
Within each family all alternatives use identical public edits and damage area.
No timing ratios across different families/campaigns are combined.

Include actual GPU pixels and decoded records, deferred oldest submission,
reverse completion notification, stale/failed newer authority, old/new geometry
support, image/glyph resource leases, insertion/removal and97-node movement.
Independent full GPUI/fresh-Window or full structural painter remains the oracle.
GPU record visits are read back explicitly in correctness mode; counters disabled
for timing. Initial and per-update index work are never hidden in oracle scans.
Mutants: omit a contributing page/sibling, reverse painter order, omit old support,
combine stale spatial and new node epochs, prematurely reuse an index payload.
Preserve raw/serial controls and all failed attempts; no A changes inherited.

## Prospective cost gate, explicit aggregation

After bounded correctness, use the resident prototype endpoint qualified by A:
registered model patch through preparation, JSON/IPC, actual staging, GPU
completion, reply and owner acknowledgement. Public Source/View dispatch and
scanout remain outside; report this endpoint verbatim. Capture all source,
executable/shader and generated-dataset hashes before AND after the run.

Six independent rounds with ABBAAB primary order; each case64 warmups and512
measured samples; sizes1/9/32/256/1024; sparse, original overlap and staircase
families. Compare B against original compressed full traversal with the same
preselected tiny raw fallback (1/9 raw,32+ compressed), plus an independent fully
uncompressed serial full-scan control at every case. B bypasses spatial indexing
at<=32 records, using the original full path, selected before measurements.
Index construction/bypass/structural transitions remain charged.

For EACH scene/size cell, the summary statistic is the MEDIAN of six paired
per-round p95 B/control ratios; each process p95 is nearest-rank ceil(.95*n)-1.
Use this same aggregation for ALL gain and regression clauses. Primary gain
requires cell summaries<=0.95 for256/1024 sparse. No-regression requires<=1.05 for
1/9/32 in all families and1024 in both overlap families. Report every individual
ratio/range and raw/B paired summary, even if summary gates pass. No post-result
fallback, quantile/aggregation change, trimming or rerun to obtain admission.

An admission against compressed control alone does not select B over raw: retain
raw's complete endpoint p95 and memory/upload costs as an independent Pareto
alternative. Report p50/p95/p99, preparation and worker phases, cold process init
with cache state, spatial-index construction/maintenance, serialized and overlap
storage, CPU graph/scratch, all GPU capacities and unassigned driver memory. No
concurrent builds/tests/analysis/cleanup during timings. No shipping, production,
physical-hardware or ZGX performance claim from this prototype gate. All local.
