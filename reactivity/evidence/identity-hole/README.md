# One positive identity gap: inline representation and common lookup

Production source commits `2eae1a93fbddf7705901af359e08aaa7751d1894` and
`db04a211c5ba7a1d13647c2a62a03ec350adb5a9`, based on `f251f4be7b`.
The first adds one exact inline case to the private logical identity index; the
second keeps its general binary searches outside the common inline arithmetic.
The previous [996-row representation campaign](../identity-index/README.md) and
[576-row normalized inline campaign](../identity-inline/README.md) remain frozen
and unchanged. This is a distinct source/artifact campaign, not a replacement of
older losses.

## Representation and exactness

`IdentityIndex::Hole { first:u64, shape:HoleShape }` has the same16B maximum enum
payload as existing alternatives. The index remains24B. `HoleShape(u64)` stores
`len:17 | cut:17 | gap:30`, least-significant field first. A compile-time assertion
requires the existing admitted `MAX_NODES`100000 to fit17bits. All field masks,
shifts and the gap limit are private named constants/accessors. No unsafe code,
refcount, external registry, side table, new node/P/owner field, or old-ID history.

A first construction scan records the first nonconsecutive identity. Only exactly
two runs in preorder, with a **positive** ID gap below2^30, use this case. Larger
gaps and descending/reordered/wrapping runs fall back to existing exact Runs or
Indexed construction. The encoding limit never rejects an otherwise admitted ID.
No overflowing `first + len` or `first + cut` is computed to admit or search it.

The two admitted ID intervals map to node indices as follows:

- first run: `delta = identity.checked_sub(first)`, `delta < cut` gives `delta`;
- second run: `index = delta.checked_sub(gap)`, require `cut <= index < len`.

That lower bound rejects IDs inside the hole even if subtracting gap yields an
otherwise valid prefix index. Both intervals are increasing, separated, and have
exactly the input's admitted length. This proves disjointness without allocating
or sorting. `u64::MAX` is valid as the final ID. The general Runs disjointness and
Indexed uniqueness assertions remain unchanged.

## Actual linked boundary

The initial source2eae passes all gates but its four-arm `get` compiles to372B
and becomes outlined despite ordinary `#[inline]`. `before-outlining/` retains
that source/artifact manifest and actual linked disassembly. It is **untimed**.
This known code-generation setback is not discarded as if an attribute proved
successful inlining.

Source db04 moves only the two general searches to ordinary non-generic private
slice helpers (`find_run`, `find_entry`), leaving the inline dispatcher with short
Contiguous/Hole arithmetic. No `inline(always)`, `inline(never)`, cold hint, or
second enum guard is added. Actual linked final consumer:

| Body | initial Hole2eae | final db04 | prior inline f251 |
|---|---:|---:|---:|
|`get`|372B outlined|absent|absent|
|`required`|inlined|absent|absent|
|`Win::style_property<Option<f32>>`|359B|538B|664B|
|`Runtime::resolve`|482B|715B|717B|
|`read_properties`|552B|552B|552B|
|general helper `find_entry`|—|91B|—|
|general helper `find_run`|—|109B|—|

The actual common property and resolution bodies contain the checked integer
arithmetic directly; the two search calls apply only to general representations.
`asm/` holds bounded disassembly of the linked executable, not just standalone
compiler output. Construction remains a full identity scan; this case removes
an allocation/search, not description or whole-window preparation.

## Correctness and matched artifacts

The representation passed15 focused tests in debug and release,371 library/public
cases (8 explicit ignored native tests), strict headless all-target Clippy and
accessible-X11 library Clippy. After the helper-only split, the15 focused cases
passed again in debug/release and both strict Clippy profiles passed. The broader
public suite belongs to the immediately preceding2eae source; the final public
owner preflight exercises the split through all tested phases.

Archived test logs trim only trailing blank EOF; captured measurement stdout remains untouched.
Tests enumerate hole IDs against exact membership, boundary gaps2^30−1/2^30/2^30+1,
maximum admitted count with both extreme cuts, final ID `u64::MAX`, reversed and
wrapping runs, duplicate rejection, and allocation zero for the previously32B
two-run child replacement. Actual Linux/Apple/Windows emitted-code controls
compile layout assertions index24B, HoleShape8B, Entry12B/alignment4, Run16B.
These are cross-target compiler checks, not desktop execution/timing claims.

The five owner variants use the **byte-identical normalized caller** from the
previous campaign: every fresh/stable/grown ordered/permuted phase executes at
least65K reads, reporting the actual post-growth target count. The four previous
consumer executables and root rlib/rmeta producers are reused **by exact frozen
hash**, not rebuilt; the new Hole producer and caller are freshly compiled at
opt-level3 in `/tmp/gpui-idnorm-hole-hot-target`. No original artifact is replaced.
`frozen.json` discloses old producer freshness and all source/caller/artifact bits.
Large preflights compare complete pixels, all local bounds, target retirement,
identity stability and the final public inspector edit across all five variants.

`run.py` never invokes a compiler. It freezes/checks source, identical caller,
producer logs, root library, executable and complete oracles. Five rotated rounds
place every variant in each position once; one overall180s deadline, no retry or
exclusion path. CPU2 affinity, before/after compiler-process snapshots and CPU,
I/O and memory PSI remain part of the record. The source remains isolated until
its full distributions and construction/lookup tradeoffs are reviewed.

## Measured rejection: all900 cost rows retained

**Do not adopt the Hole variant on these results.** The common child-replacement
index becomes allocation-free and its lookups improve, but the complete-owner
controls lose enough to reject this formulation. The smaller f251 source remains
the candidate for production qualification. A separate future single-search
resolution change must be evaluated on its own; it is not evidence of repairing
these Hole losses.

Five balanced rounds,25 processes, UTC2026-10-22T03:51:09–30Z; sum of actual child
wall times15.45s. All900 cost rows and1000 guard rows pass, no failures, retries,
exclusions or removed rounds. Compiler process snapshots are clear. CPU PSI
avg10 some0.00→2.33; I/O PSI some/full0.85→0.72. This coordinated hold still has
observed background pressure; no isolated-machine claim. `capture/` preserves
untouched stdout and process durations. `summary.json` has every allocation
observation and all five operation-normalized time samples; `summary.csv` has
all180 phase/count/variant medians, min/max and relative comparisons.

Public property reads, median ns/read. Every read phase has at least65K reads:

| Children / state / order | tree | packed | Runs | inline f251 | Hole db04 |
|---|---:|---:|---:|---:|---:|
|1 fresh ordered|6.32|8.68|7.85|6.67|6.81|
|1 fresh permuted|7.36|8.99|8.58|6.66|7.34|
|1 stable ordered|6.34|8.61|7.83|6.70|6.76|
|1 stable permuted|7.30|9.18|8.77|6.60|7.34|
|1 grown ordered|7.05|11.80|11.61|9.47|7.73|
|1 grown permuted|7.90|12.12|12.39|10.42|8.56|
|60 fresh ordered|16.22|8.54|7.88|6.41|7.17|
|60 grown ordered|16.00|22.59|11.72|9.75|8.55|
|4096 fresh ordered|64.45|8.53|7.81|6.25|7.02|
|4096 grown ordered|61.98|49.37|11.56|9.61|8.21|
|65536 fresh ordered|74.78|8.59|7.84|6.24|7.04|
|65536 fresh permuted|119.25|9.01|8.68|7.11|7.84|
|65536 stable ordered|74.07|8.55|7.89|6.29|7.06|
|65536 stable permuted|119.70|9.00|8.75|7.12|7.94|
|65536 grown ordered|73.96|61.27|11.66|9.76|8.35|
|65536 grown permuted|119.52|83.95|13.12|11.26|9.25|

Compared with f251, Hole grown lookups improve12.4–18.4%, but fresh/stable
lookups lose roughly10–14% in most cases. Tiny grown remains+9.6/+8.4% versus
tree, even after removing its allocated/search representation. Smaller storage
and a shorter linked property body are insufficient to infer faster execution.

Whole-owner median, milliseconds. Each mount includes real recording
prepare/ack; stable/grow includes the public model update and prepare/ack:

| Children / phase | tree | inline f251 | Hole db04 | Hole vs inline |
|---|---:|---:|---:|---:|
|1 mount|0.121023|0.123893|0.129143|+4.24%|
|1 stable|0.010020|0.009050|0.009061|+0.12%|
|1 grow|0.011691|0.011530|0.022150|+92.11%|
|60 mount|0.091533|0.088143|0.093892|+6.52%|
|60 stable|0.062681|0.063862|0.067211|+5.24%|
|60 grow|0.092402|0.083382|0.088112|+5.67%|
|4096 mount|6.327238|6.268678|6.416841|+2.36%|
|4096 stable|3.675522|3.650181|3.639332|−0.30%|
|4096 grow|5.997550|5.775795|5.998220|+3.85%|
|65536 mount|113.200322|114.186961|117.383085|+2.80%|
|65536 stable|66.745946|64.960660|64.396159|−0.87%|
|65536 grow|117.707232|106.682348|113.180889|+6.09%|

The tiny growth result is retained, not dismissed: its five Hole times are
13.721,22.331,12.120,22.150,23.391µs, versus f25112.061,10.960,10.700,11.790,
11.530µs. There is a broad/bimodal distribution and only five samples; the
reported+92.11% is the descriptive median comparison, not a significance or
causal attribution claim. The65K growth loss appears in all five pairs. No
additional capture or threshold tuning was used to select a better result.

Allocation counters corroborate only the specific representation improvement.
Fresh/stable owner allocations match f251 exactly. Every grown owner saves one
32B request and32B retained versus f251;65K growth peak remains44564704B because
other scratch dominates. Its cumulative requested bytes fall238342086→238342054,
requests22049→22048 and signed retained delta−33292135→−33292167. At4096 children,
peak3033857→3033825B; at1 child peak remains1868B. No RSS/PSS or constant-time
owner-preparation claim follows from these numbers.

General reverse/permuted/even-odd construction and multi-hole fallback are not
newly timed in this owner-only campaign. The previous campaign's even-odd
construction loss (Runs+103.6% versus tree,+22.8% versus packed) remains a known
adoption caveat; this patch does not establish its repair. The first construction
scan changes to record the break, and compiler layout/inlining changes affect
more than lookup. Both are potential costs; the raw controls establish the
observed total tradeoff without pretending to isolate a cause.

## Clean production handoff

To qualify the smaller candidate on the current integrated framework, the exact
production-only chain is:

1. `8da013d5f81d2687d9fdc7321f91109713e1e6c1`: Contiguous / packed Indexed;
2. `75544537f7596a7e0929306ab27b48f9942b7062`: exact affine Runs;
3. `f251f4be7bc215644859df8ee2f70a0f104f8d36`: ordinary inline lookup hints.

**Exclude** `2eae1a93fbddf7705901af359e08aaa7751d1894` and
`db04a211c5ba7a1d13647c2a62a03ec350adb5a9`: measured rejected Hole source. Evidence
commits contain no production module edits or installed benchmark example;
they can be kept independently without importing these two source commits.
The header/layout/codegen assertions in archived controls are not new main test
modules. Integrated owner sizes and a separately changed target-resolution path
must be requalified against the actual main source; historical size assertions
must not override current production structure.
