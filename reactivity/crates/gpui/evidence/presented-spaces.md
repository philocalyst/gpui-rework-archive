# Exact cohort-owned presented spaces

The public geometry, query, inspector and input APIs stay unchanged. On this
x86-64 build, Presented changes from 80 B to 56 B; Prepared changes from 40 B
to 64 B, and Runtime<()> changes from 2,368 B to 2,416 B. Part remains 16 B.
Its final private representation remains a node reference plus a borrowed
visitor context; the context adds one borrowed lane reference on the visitor
stack. No pointer
or allocation is added per ordinary element, logical node or presented node.

## Ownership and exactness

Each complete sheet owns its geometry. Presented stores the canonical local
size, exact translation and one selector byte. Local origin is always (+0,+0),
as in the existing paint/admission loop. The lane holds one common four-float
linear map inline, a boxed palette of at most 32 exact linear maps, or a full
six-float dense map per published index. The 33rd distinct linear map selects
the dense fallback; it is not a public limit. The dense allocation reserves the
current logical node count, just as the existing presentation vector does.

Selector 255 explicitly means no admitted map. Its dense placeholder is never
observable. Reconstruction copies all six fields without arithmetic,
quantization, matrix composition, normalization or conversion. Equality uses
all four linear coefficient words; signed-zero coefficients and translations
survive. Canvas receives the same raw admitted map as before this storage cut.

The builder only reads the new candidate's published prefix when promoting to
dense. It never borrows current mutable styles or the old P. All lane allocation
and shrinking finishes before command publication. Candidate and acknowledged
lanes move together with their nodes. Failed preparation/resize cannot replace
either complete sheet, and acknowledgement of an older complete candidate after
a newer failure preserves that candidate's geometry. No historical palette
survives reconstruction; ordinary retirement drops its owned lane.

Queries, native semantic projection, snapshots, targeted click-center selection,
pointer hit testing and list-ancestor hit clips use this same immutable lane.
Common, shared and absent maps read their already-borrowed node directly.
In release builds, only
dense semantic access computes `(node_address - sheet_start) / sizeof(Presented)`
and uses ordinary checked slice indexing. No pointer is reconstructed or
dereferenced from an integer. This read-only offset grants no model/input
authority. Internal paint/input/snapshot loops keep their existing explicit
indices. Scoped queries select subslices of the same full Context, so the dense
offset remains global to the correct immutable P.

Private Part constructors receive references selected from that Context's sheet;
the borrow fixes the allocation for the Part lifetime. Lifetime equality alone
does not prove allocation membership. Current private callsites establish that
invariant and debug assertions check it. Making the private constructors select
only from Context-owned slices could localize that proof and remove debug
per-item checks; that is an assessed follow-up, not part of this measured cut.

## Allocation and retained cost

The [lane ledger](presented-spaces-lane-allocations.csv) counts construction of
4,096 maps, excluding separately preallocated presentation records:

| Distinct linear maps | Requests | Requested B | Live B | Counter peak B |
| --- | ---: | ---: | ---: | ---: |
| All absent | 0 | 0 | 0 | 0 |
| One common | 0 | 0 | 0 | 0 |
| Two | 2 | 544 | 32 | 544 |
| 32 | 1 | 512 | 512 | 512 |
| 33 or 4,096 | 2 | 98,816 | 98,304 | 98,816 |

The two-map row includes the initial 512 B discovery allocation and its shrink
to 32 B. The dense row includes 512 B of bounded discovery scratch. These are
allocation-counter requests, not allocator usable sizes or RSS. Dense storage
keeps total per-node capacity at 80 B, with the 48 B owner-header increase; it
does not claim a unique-map memory win.

The [real traces](presented-spaces-entropy-candidate.csv) and
[lane payloads](presented-spaces-lanes.csv) show common maps for Counter, Todos,
Workspace before rotation and all Library scroll/density states. Rotated
Workspace has two linear maps (32 B payload). The animated unique adversary
falls back to dense with no historical growth. Translations remain per node.
For example, Library retains capacity for 60 P records: 4,800 → 3,360 B, even
when density culling publishes 44 records. Rotated Workspace uses
32 × 56 + 32 = 1,824 B instead of 2,560 B. Add the 48 B owner headers in both
comparisons; these are not complete-window figures.

[Whole-owner measurements](presented-spaces-owner-memory.csv) include model,
layout, style/text lanes and command-only Canvas. The pending case retains old
P plus a complete candidate, forcing resize so no-op content still has a C.
There is no owned CPU framebuffer or font service in these rectangle-only
fixtures. Each row compares identical operation/constraint history.

| Scene | Pending | Live inline → candidate B | Peak inline → candidate B |
| --- | --- | ---: | ---: |
| One node, common | No | 5,580 → 5,604 | 5,740 → 5,780 |
| One node, common | Yes | 5,660 → 5,660 | 6,928 → 6,952 |
| Three nodes, two maps | No | 6,996 → 7,004 | 7,268 → 7,788 |
| Three nodes, two maps | Yes | 7,236 → 7,204 | 8,820 → 8,828 |
| 4,097 nodes, common | No | 4,293,317 → 4,195,037 | 4,628,389 → 4,530,109 |
| 4,097 nodes, common | Yes | 2,247,429 → 2,050,821 | 4,704,949 → 4,606,669 |
| 4,097 nodes, two maps | No | 1,919,757 → 1,821,509 | 2,787,664 → 2,787,712 |
| 4,097 nodes, two maps | Yes | 2,247,517 → 2,050,973 | 4,705,037 → 4,606,789 |
| 4,097 nodes, unique | No | 2,275,932 → 2,275,980 | 2,787,664 → 2,787,712 |
| 4,097 nodes, unique | Yes | 2,603,692 → 2,603,740 | 5,061,212 → 5,061,260 |
| 4,097 nodes, all absent | Yes | 2,190,085 → 1,993,477 | 4,647,605 → 4,549,325 |

Small owners can lose bytes, and layout/description scratch can dominate peak
regardless of retained savings. Different mode histories can retain different layout and Canvas
capacities; comparisons across unrelated rows are not a storage result.
Every row, including 32-map and losing controls, remains in the raw CSV.

## Verification and code generation

The first full GPUI run passed 260 cases/doctests (eight manual/measurement
ignores), including both new public tests. The later borrowed-Part full run
passed 263 cases/doctests (nine ignores). The final constructor formulation then
passed all five focused public geometry/subtree cases, six release lane cases
and its cohort construction test. Strict native
`x11,wayland` all-target Clippy passed. Native nonignored unit/consumer tests
passed 103 cases, including the 100,000-node full/sparse semantic consumer
comparison. Final borrowed construction also passed all 20 focused native
semantic/Consumer cases (four manual ignores), including the 100,000-node
comparison, plus strict native all-target Clippy. Actual Xvfb :94 Todo policy loops and 250,000-record Library
wheel/pointer/resize/resume gates passed (5.57 s and 2.36 s). These are
functional checks, not native latency claims.

Both the [initial](presented-spaces-oracle-candidate.csv) and
[final](presented-spaces-oracle-final.csv) public oracles match all 45 inline
hashes exactly. Each hashes every public transform coefficient bit, local and
clipped rectangles, unclipped bounds and the complete reference pixel output.
Separate tests cover paused P, pending dense maps, failed newer C/resize,
coherent old-candidate acknowledgement, DPI recovery, target retirement,
reflection, absent geometry, all 32 palette entries and exact signed-zero bits.
The per-lane rebuild test holds an older sheet through 100 independent dense
rebuilds and checks all coefficient bits.

Ordinary downstream release Counter output matches the inline baseline byte
for byte, including snapshot, pixels and counters. Both first_frame programs
execute successfully. No outlined per-node builder, lane transform getter or
exact comparator is present/called in Counter or first_frame. Their `.text`
sections in the getter-only downstream check grow by 3,728 B
(2,973,319 → 2,977,047) and 3,616 B (3,053,543 → 3,057,159), respectively; no code-size reduction is claimed.

No dependency, unsafe code, refcount, shared mutable owner, global/TLS arena or
public type is added. The canonical authoring style lane is unchanged. No
native latency, raster throughput or cross-device byte parity claim follows
from the operation fixture.

## All three paired captures

[Initial](presented-spaces-initial-cost.csv),
[getter-only](presented-spaces-getter-cost.csv), and
[borrowed-node](presented-spaces-final-cost.csv) each retain all 1,470 rows:
five alternating fresh-process pairs, three rounds/process, 49 cases/round,
pinned to CPU 2. Root and peers explicitly held builds/captures. Elapsed capture
times were 12.68 s, 13.18 s and 12.11 s. The timed fixture source is byte-identical
in the baseline and candidates. Source/executable pins are in the
[provenance](presented-spaces.json) and each capture JSON. The ordinary release
profile and checked-in flags are retained; no native-specific CPU flags were
added. A separate warm font-bearing owner keeps the font face resident.

`mount` includes owner teardown, `update` includes one coarse source turn and
acknowledgement, and `visit` reads transform/local/unclipped bounds through the
public visitor. These are unit-harness public-operation measurements in
recording mode. They do not measure native input/submit or raster throughput.
A discarded preflight is not performance evidence.

| Case | Initial vs baseline | Getter-only vs baseline | Borrowed vs baseline | Final ns/op inline → borrowed |
| --- | ---: | ---: | ---: | ---: |
| 4,097 common mount/drop | +20.9% | +20.2% | +19.1% | 3,361,459 → 4,003,542 |
| 4,097 two-map mount/drop | +2.7% | +1.1% | −2.7% | 4,125,804 → 4,014,297 |
| 4,097 unique mount/drop | +11.0% | +10.2% | +8.4% | 3,652,124 → 3,957,248 |
| 4,097 common update | −1.5% | +0.4% | −0.4% | 2,794,770 → 2,783,692 |
| 4,097 32-map update | +0.2% | −0.8% | +1.7% | 2,675,289 → 2,721,576 |
| 4,097 unique update | −3.2% | −5.3% | −1.6% | 2,702,752 → 2,660,034 |
| 4,097 common visit | +73.4% | +25.4% | +24.2% | 83,204 → 103,372 |
| 4,097 two-map visit | +72.1% | +27.6% | +31.7% | 82,983 → 109,303 |
| 4,097 unique visit | +72.2% | +29.6% | +31.9% | 83,363 → 109,986 |
| 4,097 all-absent visit | +131.8% | +137.4% | +150.4% | 6,967 → 17,444 |
| Three-node common visit | +22.6% | −7.8% | −2.8% | 100.9 → 98.1 |
| Three-node two-map visit | +47.7% | +2.7% | +3.4% | 83.8 → 86.6 |
| Todo equal description | −3.0% | −0.2% | −1.2% | 49,698 → 49,094 |
| Workspace rotate | +2.6% | +1.2% | +1.2% | 43,857 → 44,379 |
| Library equal description | −2.0% | −0.3% | −3.1% | 27,738 → 26,872 |
| Library scroll | −0.8% | −0.6% | +0.1% | 2,142,091 → 2,143,528 |

The [complete summary](presented-spaces-summary.csv) preserves all 49 cases,
including one-node controls: final mount/drop +0.4–4.5%, normal visits up to
+76.6% (about 11 ns more), and absent visit about 8 ns faster. Tiny nanosecond
controls and raw timings drift between windows. Cross-capture comparisons use
each candidate's paired baseline; they are not direct paired tests of the two
candidate binaries. The summary's final/getter column is a ratio of normalized
ratios, not a new independent measurement. On that basis, borrowed-node large
common visit changes about −1.0% relative to getter-only, two-map/dense visits
about +3.3%/+1.8%, and absent visit about +5.5%. The final formulation is clearer
and avoids common indexed access, but the remaining broad visitor loss persists.

## Emitted consumer loop and recommendation

The initial binary outlined Part::transform (356 B) and unclipped_bounds
(161 B); the baseline inlined both. An inline hint removed the former, but LLVM
still outlined a 396 B unclipped wrapper. The separate annotation commit makes
that wrapper visible to callers and removes repeated per-node getter calls.
It improves the large visitor regression without removing it.

The final [ordinary downstream consumer](presented-spaces-consumer.rs) is built
with rustc against the separately compiled regular GPUI rlibs, not the unit
harness. Both programs print the same three 129-node results. Its
[emitted loop](presented-spaces-consumer-visit.asm) has no Part getter call:
common/shared translations use fixed offsets from the borrowed node, and the
address subtraction/constant division occurs only in the dense branch. The
absent branch bypasses both lane selection and dense address work. A remaining
call to the core CoordinateSpace bounds helper spills live reconstructed
coefficients around the call; no claim is made that the full projection overhead
is an unavoidable mathematical cost. Consumer `.text`/binary hashes are recorded
in the provenance; this diagnostic consumer adds no public API.

Recommendation: hold the storage cut out of main for now. The exact memory
savings and frozen-sheet ownership are validated, but common mount/drop remains
about 19% slower and large semantic geometry visits remain 24–32% slower, with a
larger relative absent-map loss. Real app update controls are mostly flat, which
does not erase those adversarial costs. The borrowed-node formulation is the
clearer candidate if a later performance budget accepts the tradeoff; neither
inlining nor pointer-offset derivation establishes a general performance win.

## Source size and reproduction

Against 62f670dc26, the complete source/test cut adds 883 and removes 86 lines
across eight files, before evidence. The new space module is 127 lines before
its test module, with 189 lines of invariants/ledger tests. The ignored public
operation fixture is 228 lines; the standalone public geometry tests are 180
lines and the private cohort test is 62 lines. The old 24 B per-node optional
map wrapper and its test are removed, not retained as another path.

The standalone geometry consumer `.text` is 2,895,735 → 2,900,055 B (+4,320 B,
0.15%); source, regular rlibs and executable hashes are pinned in the JSON.
It was compiled with the recorded rustc flags plus `--extern gpui=...` and
`-L dependency=.../release/deps` against each independent Cargo target. Its
assembly shows ordinary checked dense access; no unsafe or raw dereference is
needed to compute the offset.

Build each source in its own target directory, freeze the resulting test binary,
and arrange a quiet CPU window before running the checked capture helper:

```sh
cargo test --manifest-path reactivity/Cargo.toml -p gpui --release --lib --no-run
python3 reactivity/crates/gpui/evidence/presented-spaces-capture.py \
  --inline /path/to/frozen-inline --candidate /path/to/frozen-candidate \
  --output /path/to/cost.csv --pairs 5 --cpu 2
```

The source/operation pins in each capture take precedence over later packaging
changes. The owner/lane ledgers and exact oracle are explicit ignored tests in
`runtime::space_ledger`, independent of the timing capture. No timing was taken
while peers were building, testing or benchmarking.
