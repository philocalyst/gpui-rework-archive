# Bounded inverse identity lookup: second formulation held

Candidate `b70d1ec799256f34f2ba503c168cd60362a88b5c`; unchanged baseline
`b15133e90d` is source724 plus the identical public fixture. This includes the
validated-index refactor and first map-free form; those changes are not isolated
by this comparison. The [first campaign](../identity-order/README.md) remains
separate, including all of its losing cases.

Ordered nodes retain no identity index. One clamped offset and one corrective
probe can accept only an exact canonical identity match; binary search handles
remaining gaps. Reordered nodes use a direct u32 inverse when the **current**
inclusive ID span is at most 2N, otherwise sorted u32 positions. Vacancies use
u32::MAX outside the admitted position domain. There is no index of historical
IDs and dense payload cannot exceed 8N bytes. A cold typed Index box keeps the
default Nodes header at 32 B; the compiler lays out the enum at 24 B without
manual tags or unsafe. Runtime is 2,384→2,368 B; Node40/P80 stay unchanged.
First cold dense indexing performs two allocations: 24 B descriptor plus 4×span
positions; the exact span6/N3 threshold fixture requests 48 B total.

The map oracle covers 15,120 permutations across contiguous, gapped and extreme
ID families, all missing small IDs, exact dense threshold/overflow fallback,
replacements, and lookup revocation after take. Full default GPUI tests and
strict accessible native all-target Clippy pass (`checks.json`). The public
release preflight checks keyed target reversal, exact actions, complete pixels,
and allocation balance. No native execution is claimed for this representation.

The independent Cargo targets, same fixture SHA, exact source pins, toolchain,
immutable SHA-named linked executables and allocator/layout ledgers are in
`frozen.json` and adjacent logs. `capture.py` serializes seven alternating fresh
process pairs (1,260 rows), then five app pairs × three batches ×25 cases
(750 rows), on CPU2 in a coordinated quiet 20.75-second window. Raw files are
unchanged. Summary percentages are medians of paired changes, with every pair
and range retained. These are headless public-operation controls, not native
latency or pure index microbenchmarks. The list's independent O(N) realized
presentation-membership check remains in complete focus/property calls.

| Control | Median paired change |
| --- | ---: |
| 4096 contiguous first/last focus | −61.5% / −76.6% |
| 4096 gapped first/last focus | −55.8% / −76.6% |
| 4096 permuted first property | −71.9% |
| 4096 permuted inspect | −56.7% |
| Existing four large style mounts | −17.2% … −19.3% |
| Existing warm inspector overrides | **+2.2% … +11.5%** |
| Gapped4096 mount | **+10.2%** |
| Permuted4096 activation | **+2.2%** |
| Permuted4096 destruction | **+134.7%** |

Ordered4096 requested retention is 2,029,972→1,954,788 B (−75,184 B),
and mount requests 5,318→4,941 allocations. Reordered4096 retains
9,627,148→9,510,468 B after reversal; it pays one more allocation than
the first map-free form because of the cold descriptor. These requested-byte
savings do not establish an RSS/PSS or native-window improvement.

**Hold:** the primary address regressions are fixed, but inspector and drop
losses remain. Do not integrate this form, pool the two campaigns, or rerun until
a concrete structural/codegen cause justifies a new variant. Investigate the
validated-index refactor separately and actual paint/destruction code before
adding more representation complexity.
