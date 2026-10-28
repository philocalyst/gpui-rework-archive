# Borrow the retained layout routing index

`present_inner` previously built a fresh `BTreeMap<NodeId, usize>` for every
layout/presentation pass, including textless scenes where measurement cannot
run. The callback now binary-searches the already-retained `layout_nodes` Vec.
There is no new field, cache, allocation, unsafe code or adapter API.

A rebuild creates a fresh layout arena and appends exactly one layout node per
logical node, in declaration order. This runtime never removes or reparents an
individual layout node. Consequently IDs have the same arena and generation
and increasing indices. Rebuild asserts sortedness in debug builds. Search
compares the complete arena/generation/index capability; it does not extract a
raw index or weaken the core's stale/foreign-ID validation. If future layout
mutation changes this invariant, the routing design must change with it.

The old cost was O(N) scratch construction plus measured-node lookups on each
pass. Now O(T log N) searches occur only for actual measurement calls. The
[source audit](../../../docs/layout-measure-index-luna.md) also describes a
possible checked O(1) callback slot, which is not implemented here.

## Evidence and limits

Baseline source is `067eebce12`; its runtime source equals the candidate base
`6b543dab9b` before this change. [Metadata](layout-route/metadata.json) records
binary hashes and the tested patch hash. Eleven fresh-process AB/BA pairs per
case ran on one pinned CPU while other heavy agent work was held. The unchanged
`color_cost`, `text_lane_measure` and `retained_list` fixtures include their
existing output checks; dense text used both recording and CPU modes.

At 10,001 nodes the repeated-color mount removes **913 allocation calls**
(3,669→2,756) and reduces requested peak bytes **262,472 B**
(11,099,340→10,836,868). Retained bytes stay 10,074,196. This removes a temporary
map, not the retained layout tree, styles, glyph data or presentation scratch.

| Case, µs | Baseline median | Candidate median | Median paired change |
| --- | ---: | ---: | ---: |
| 10K repeated-color mount | 14,764.907 | 14,600.474 | −1.09% |
| 10K unique-color mount | 9,975.029 | 9,707.164 | −2.53% |
| Textless resize | 3,786.856 | 3,607.702 | −5.18% |
| Sparse-text equal description | 4,993.405 | 5,526.267 | +10.84% |
| Textless failure repair | 8,949.166 | 10,484.481 | +17.87% |
| Dense-text direct edit | 676,881.024 | 681,064.400 | +0.43% |
| Virtual 250K scroll | 268.186 | 264.336 | −1.53% |

The whole fixture trace also matters: paired changes were textless −0.74%,
sparse recording +1.31%, sparse CPU −0.15%, dense recording +0.36%, and dense CPU
+0.51%. The map removal changes allocation history before later phases; the
large repair/equal-description phase differences are not an isolated measure
of binary-search CPU cost. Raw losing cases remain in the
[summary](layout-route/summary.csv), [samples](layout-route/samples.csv.gz) and
[complete output](layout-route/raw.tar.gz). No universal latency improvement,
zero-allocation presentation or whole-process RSS saving is claimed.

The benefit adopted here is eliminating the unconditional scratch index and
its allocations without retaining replacement state. Dense-text search and
allocation-history effects remain explicit profiling targets. The complete
GPUI suite passes **199 cases/doctests**; strict all-target X11+Wayland Clippy
and first-party formatting pass. Current text-cache tests compare fresh output
after insert/remove, remount, resize, font override and failed-shaping repair.
