# Current-route storage prototype: measured, held

This evidence describes source `c11e89da1ec292a6ef7f0203e3929f9138e6fe04`,
not the authoritative clean-room checkout. Parent control
`40382ed1d9` adds only the identical public measurement example to cold-viewport
source `eddd4112aa`. Both controls therefore already have the cold viewport slot.
Subsequent index-construction changes must be measured separately.

On x64, Node is 24 B instead of 40 B; its optional migration representation
remains the same size. The existing identity map's value remains 8 B, storing
the bounded node index and one-based nonzero route slot. A dense vector retains
only present handlers, 16 B each, with one additional allocation when nonempty.
Runtime<()> grows 2328→2352 B against this parent. Compared with main before
the cold-viewport change, the combined header is 16 B smaller. These are type
sizes, not RSS. On 32-bit targets the locator grows 4→8 B per map value; x64
byte results do not transfer to those targets.

## Requested whole-owner storage

The public example mounts recording owners, checks acknowledged action counts,
independently verifies complete white output before measurement, disables and
restores all routes, invokes 100 actions, and drops the complete owner. All
requested allocation deltas balance to zero after drop. Diagnostic snapshots
and pixel preflight are outside the measured operations. Method callbacks are
zero-sized and their Boxes allocate no payload; captured typed source actions
have their existing payload allocation in both versions.

| Fixture | Parent retained B | Prototype retained B | Allocations at mount |
| --- | ---: | ---: | ---: |
| One structural node, no route | 6204 | 6212 | 41→41 |
| Two nodes, one method route | 6876 | 6884 | 43→44 |
| 4097 nodes, no routes | 1862861 | 1797333 | 1209→1209 |
| 4097 nodes, 256 method routes | 1862861 | 1801429 | 1209→1210 |
| 4097 nodes, 4096 method routes | 1862861 | 1862869 | 1209→1210 |
| 4097 nodes, 4096 captured typed routes | 2059469 | 2059477 | 5305→5306 |

`shrink_to_fit` is a best-effort library operation, not a portable capacity
guarantee. [Real-application distribution](distribution.txt) records actual
length/capacity equality in this allocator: Counter 1, Todo 4→68, Workspace 7,
and Library 15 routes. The cold viewport Box is now reused on list refresh and
released when the protocol becomes empty; it is not reallocated on every scroll.

## Timing, including losses

[Density manifest](manifest.json) pins both executable hashes and sources.
There are 1320 rows: 11 alternating fresh-process pairs × 10 density/capture
fixtures × 6 phases. Capture took 12.284 s, CPU2, with all owned build/test work
idle. The per-phase allocation counters price whole recording owners, not
allocator rounding, native memory or other threads. [All 60 cells](summary.csv)
remain, including empty/no-op phases whose percentages have little significance.

The fully captured 4097-node mount loses **21.73%**, 3.163→3.851 ms; equal
description loses **15.08%**, 1.958→2.253 ms. This prevents main adoption.
Fully actionable method-only equal description improves 8.55%, but its 100
coarse activations lose 4.10%. Single captured action activation, repeated 100
times, loses 22.54% (5.591→6.851 µs total), while sparse/dense large-owner exact
activation loses about 1.5%. All exact activation loops allocate zero in both
versions. Method actions deliberately exercise coarse owner descriptions;
those loops allocate in both versions and are not a zero-allocation claim.

[Application manifest](apps-manifest.json) records another 750 rows: five
alternating process pairs × three warm batches × 25 existing public-operation
fixtures, 17.332 s. The 4097-node four-style mount controls lose 3.69–7.00%,
while equal descriptions improve 0.69–2.25%. Counter exact loses 1.57%, Todo
equal improves 0.64%, Workspace rotate loses 0.28%, Library equal loses 2.36%,
and Library scroll improves 1.04%. The mount fixture excludes drop from its
timer; the density fixture's mount includes acknowledgement. Their numbers
are not interchangeable. [All application cells](apps-summary.csv) are retained.

The unpaired `apps-excluded-harness-prefix-baseline.txt` is excluded: the first
collector expected rows to start at column zero, but the Rust test harness
prefixed its first cost row. The corrected collector parses all 75 complete
cost records; the entire paired application campaign was captured afresh.

These are warm-code library operations. They do not measure native event
delivery, startup, upload, compositor/scanout, or NanoUI/MyGo performance.
Artifacts were copied to immutable SHA-named paths before further compilation;
manifests retain the original build-output path as well.

## Correctness and source review

[Five candidate checks](checks.json) record 261 passing accessible X11 cases,
the actual Todo multi-renderer script, the actual 250K Library script, strict
X11+Wayland all-target Clippy and formatting. The preceding default suite had
239 passing cases. Suites overlap and are not added together. Native scripts
check complete server pixels, real pointer/keyboard routes and lifecycle repair.

Public route tests cover captured replacement at a surviving identity, mixed
dense/sparse/empty branches, old-P action revalidation, rejected description
retirement, keyed-row reversal and destructor panic/drop-once quarantine.
The panic case exposed a diagnostic bug: snapshots indexed partially taken
current nodes after an unwind. The fix gates current lookup before reading
addresses; complete old-P content/geometry remains diagnostic with every target
revoked. Independent read-only review found no other correctness blocker.

No unsafe, per-node refcount, RefCell, Cell or Rc is added. Active payload Boxes,
type-erased callback dispatch, coarse-description allocation, O(N) index rebuild
and current list limits remain. A compact capture arena is a separate research
question; this cut does not claim to solve it.
