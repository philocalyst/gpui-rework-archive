# Rejected retained route-column controls

Base is `89aeabd53942c3a4643bcb6fd978e6a24703f6d2`. These isolated safe controls
shrink retained `Node`40→24 by moving its unchanged `Option<Handler>` owners to
cold columns. `El`176, `DraftNode`152, Handler/Route ABI and public API stay intact.
There is no unsafe, new dependency, duplicated owner or retained refcount.

**Do not adopt these controls.** Their actual retained-byte savings are real,
but the coordinated paired measurements show material activation, description
and resize regressions. Every sample, including losses, remains in this archive.

## Controls and bills

| Control | Route storage | Runtime header growth | Shipping code growth |
| --- | --- | ---: | ---: |
| AoS | exact boxed dense16N or sorted sparse24H |24B|137 lines|
| Boxed AoS floor control | optional boxed AoS owner |8B plus24B heap when nonempty|not separately counted|
| SoA | exact boxed handlers16H + sparse keys4H, or dense16N |32B|114 lines|
| Sparse-only SoA index | same SoA storage; only sparse routed old ordinals indexed |32B|107 lines|

The base six-library lib/src+build bill is30,513 lines. The counter excludes tests,
comments, blanks, application/support fixtures, tools and vendor. Its exact JSON
and helper/Tokei hashes are included. No vendor or support source was changed.
The public benchmark fixture and lifecycle tests are separately counted by Tokei.

The first three controls use temporary old ordinal addressing only after Siblings
has read old ordinals; reused rows reset them before publication. The successor
uses Content eligibility to avoid indexing absent/dense routes, writing only H
sparse old rows. Component scopes and full64-bit identities are never narrowed.
The existing Content high bit supplies O(1) eligibility; text/image decoders mask it.

All retained columns are boxed slices with no spare capacity. Reconciliation's
Vec builders have observed exact capacities on this target. Sparse/dense thresholds
compare exact retained requests:24H<16N or20H<16N. Property take/restore preserves
site keys and eligibility; inspector replaces existing routes. Consumed routes drop
at replacement, scope-rejected routes at rejection, and unmatched routes at scope
exit in old row order. Moving ownership changes backing-storage deallocation order;
no identical allocator-operation trace is claimed.

## Complete-owner allocator requests

These are actual `Win` owners, including runtime, layout, Canvas, presentation,
styles, routes and captures. Allocator request counters are neither RSS nor usable
allocator classes. No public zero-node View exists: an empty div still retains one
row. `Runtime<()>` is1824B base,1848 AoS,1832 boxed AoS,1856 SoA. `Win` remains8B.

| Owner | AoS live delta | Boxed AoS live delta | SoA live delta |
| --- | ---: | ---: | ---: |
|1 row, no route|+8B|−8B|+16B|
|1 row,1 route|+24B|+32B|+32B|
|100 rows, no route|−1576B|−1592B|−1568B|
|100 rows,1 route|−1552B|−1544B|−1548B|
|100 rows,66 routes|+8B|+16B|−248B|
|100 rows,100 routes|+24B|+32B|+32B|
|actual Workspace32 rows/7 routes|−320B|−312B|−340B|

Nonempty AoS adds one mount allocation; boxing adds another. Sparse SoA adds two
mount allocations; dense SoA adds one. Route-free columns allocate nothing.
Boxing helps the route-free header floor but loses8B and one allocation whenever
routes exist, so it is not a global improvement.

Exact16,384-row SoA owners with0/164/8192 ZST routes retain262,112/258,832/98,272 fewer
requested bytes. No-route mount peak also falls262,112B. With164 or8192 routes the
mount peak instead rises32B because description allocation dominates; equal-update
whole-trace peaks fall258,832/98,272B. The sparse-only successor's44 owner rows are
exactly identical to the full-index SoA control.

The128-usize capture fixture retains1024B per captured route, unchanged. Mount and
replacement measurements include the actual captured owners. The transition partial
phase model separately prices observed100-row old/next capacities and draft128
capacity, both live route columns, and old+new captured payloads. It is a subtotal,
not a whole-owner peak forecast:100→1 routes and1→100 have the same subtotal delta
but different measured peak behavior. No El+Draft+Node triple-array saving is added.

## One coordinated timing run

Rust1.97.1/LLVM22, optimized release, no default features, root Cargo config retained.
Root explicitly held all other workers and granted CPU0. Nine alternating AB/BA
fresh-process pairs per candidate produced540 observations in51.8s. Every public
operation validated output/counters. Precise Source activation asserts zero owner
reruns; equal description, resize and snapshot are separate cases. Process audits
show no build-process entries. No sample was discarded or retried.

Median paired percentage change (positive is slower):

| Case | AoS | SoA | Sparse-only SoA |
| --- | ---: | ---: | ---: |
|exact activation1000/1000 routes|+5.92%|+5.67%|+13.36%|
|exact activation1000/500|+24.18%|+13.33%|+20.03%|
|exact activation16384/164|+15.53%|+11.64%|+20.27%|
|exact activation16384/8192|+60.24%|+36.01%|+41.41%|
|equal description16384/no routes|+13.75%|+14.62%|+12.24%|
|equal description16384/164|+2.58%|+42.49%|+41.82%|
|resize16384/no routes|+7.57%|+5.17%|+6.42%|
|snapshot16384/164|−3.02%|−2.28%|−1.49%|

See timing-summary.csv for all30 rows, ranges and slower-pair counts. The large
SoA description loss is retained without attribution to a single cause. Allocation
history and code layout also change; these data do not isolate a single instruction.

The identical public harness linked .text grows1712B AoS or1520B SoA, rodata112/128B.
Actual snapshot disassembly changes40-byte row addressing and handler-null tests to
24-byte row addressing and a Content sign-bit test, without cold-column lookup.
This codegen fact does not establish a full-window latency win.

## Correctness and reproducibility

The sparse-only successor passes153 no-default library tests (6 ignored) and70
selected integration cases: routes8, lists19, components10, inspector15,
property_actions9, property_selection9. Its four private route tests cover exact
storage thresholds/capacities, empty noallocation, bounded Content decoding,
sparse-only old indexing and dense takes independent of ordinal values.
Public lifecycle controls include all/sparse/dense/absent transitions, keyed
reorder/removal, current capture replacement, exact destructor order, consumed and
unmatched destructor panic, property selection/request/reply restoration and no
quarantined-target revival. The same new routes8 pass against the actual baseline.

Rejected formulations were not broad-qualified with default/native/strict/cross
checks. Miri is unavailable; there is no unsafe integration or soundness claim.
A shared-target Cargo stale-artifact attempt was caught before any boxed data was
accepted. All accepted source-switch builds require fresh=false and a layout oracle;
executables were copied and hashed before another build. That rejected attempt and
preliminary source-hash files are explicitly labeled. Exact source hashes come from
immutable named commits. Full patches apply to the pinned base without any producer
commit dependency. Binaries are omitted from this archive; their hashes, Cargo JSON,
source patches, commands and raw output are retained for rebuilding and review.
