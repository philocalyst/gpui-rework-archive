# Display-tree memory lanes: mechanism works, general candidate rejected

BBTree-inspired experiment in actual LayoutTree::compute_inner, frozen at
8ec3302553. Classifies pending changes through independent immutable parent
chains. Application API and serial mutation/layout semantics stay unchanged.
The 32-lane executor uses explicit Unpin Futures, a live-bit mask and bounded
stack arrays. Only a local x86 prefetch hint is unsafe; the experimental core
lint changes forbid to deny with a single function exception. This is unadopted.

Six separately compiled alternatives, five rotated/reversed interleaved process
pairs per six public-compute cells, 20 warmup, 40 batches of five operations.
180 processes, 7,200 batches, 36,000 timed complete compute calls. CPU ratios
below are medians of paired process p50s against original scalar:

| Cell | Validated scalar | Level loop | Future/no hint | Future/hint | Root proof/fallback |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tiny full update | 1.014 | 1.024 | 1.158 | 0.885 | 1.045 |
| Contiguous filter | 1.224 | 1.098 | 1.339 | 1.621 | 1.233 |
| Shuffled depth128 filter | 1.172 | 0.404 | 0.460 | 0.639 | 0.483 |
| Shuffled depth32 filter | 0.889 | 0.473 | 0.494 | 0.641 | 0.557 |
| Shallow filter | 0.786 | 0.939 | 0.971 | 0.871 | 0.819 |
| Single-root full update | 0.994 | 1.004 | 1.048 | 0.990 | 0.973 |

The large independent-chain improvement is real in this trace, but contiguous
regressions violate the <=5% gate. The Future/hint candidate is rejected. The
safe level loop also fails that gate. Small identical-path cells show substantial
noise, which is not evidence of a mechanism gain. No losing process was removed.
Root-proof mode falls back to no-hint Future batches for multi-root filtering;
it is not a pure scalar control there. All process tails and individual ratios
are retained, including noisy ranges.

Filtering measures ordinary compute() with edits on a different forest root;
it is explicitly scheduler work, not a rendered frame. Full cells include
set_style and dirty layout; their near-parity bounds practical benefit here.
All final layout-field hashes AND LayoutStats match across all variants/runs.
Cold construction/first-layout and exact retained capacities remain in each log.
Current payload for depth128 is about 14.8 MB lanes plus 23.4 MB layout caches;
this is not a memory saving. Parent Entry is 28 bytes; BBTree-style compact
routing is a separate next hypothesis, not a retroactive interpretation.

All six variants pass 46 existing/new core tests. Candidate strict Clippy passes.
Miri passes the new root/lifecycle test (130.78s), with prefetch compiled out but
all lane state/index/capability logic active. The mutant collapses completed lanes
to the first forest root and fails exact results. A stale slot and a foreign tree
ID reject; removal/reuse/reparent tests preserve full capabilities and input order.
Linked executable inspection finds 33 prefetcht0 instructions only in the hinted
variant, none in the controls. This confirms emitted hints, not hardware cache
hit/miss counts: this VM denies perf. No hidden allocation or virtual dispatch
is introduced by lanes; batch arrays/selected Vec and their overhead are charged.

The initial fixture compile failure referenced an obsolete Layout field and is
preserved in raw/candidate; correction hashes every field of current Layout.
Source guards before/after tests and timing, exact binary hashes, compiler,
process commands, machine and raw CSVs are preserved. verify.py independently
recomputes quantiles/ratios and rejects the candidate on its original threshold.
No native/physical GPU, Solid transition-semantic or ZGX victory is claimed.
