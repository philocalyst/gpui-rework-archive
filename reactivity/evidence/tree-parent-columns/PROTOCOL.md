# Compact parent routing and selective batching: preregistration

Separate experiment after tree-memory-lanes 8ec3302553. Its six-way first
campaign found 2.48x large shuffled filtering with level-wise lanes and 1.57x
with prefetching Future lanes, but contiguous regressions (10% and 62%) fail
admission. These results remain preserved, not reclassified by this protocol.

Hypothesis: BBTree's compact routing principle matters before latency hiding.
Move the sole authoritative parent links out of the 28-byte Entry into a dense
u32 column. Other link/generation/kind fields remain in 24-byte Entry. No parent
copy/cache, no duplicated topology. Charge the extra Vec header, independent
allocation capacities and lookup indirection. Every insert/free-slot reuse,
remove/reparent/cycle check and iterator must use the authoritative column.
Maintain Tree::entry_bytes as aggregate per-slot bytes, and allocated_bytes as
the sum of actual capacities. Never claim a net memory saving from narrower
routing alone.

Compare unchanged original scalar, AoS level-wise, AoS hinted Future, SoA scalar,
SoA hinted Future, and SoA selective safe scheduling. Same six public compute
cells, five interleaved processes, 20 warmup, 40 batches of 5; exact all-layout
fingerprints/stats. Add a mixed-depth 1..128-chain cell with deterministic
allocation order to expose uneven lane occupancy. Preserve old cells unchanged.
Do not compare mixed-depth timings against a baseline that lacks that fixture.

Selective variant: if the forest has exactly one root, collect pending directly
using that topology proof. Otherwise retain scalar below 32 pending/32768 live
nodes or when any of the first four pending-node depths is below 16; use 32-lane
level-wise traversal above those thresholds. These are conservative routing
heuristics, not correctness assumptions. Thresholds fixed before timings.

Same >=20% large shuffled improvement and <=5% small/contiguous/full-operation
regression gate. Noise remains inconclusive. Report cold setup and all tails,
allocation capacity, header/stack/ELF and core lines. A passing core trial only
admits complete GPUI integration/native comparison, not competitor claims.
All public tree/layout tests unchanged, plus removal/reparent/reuse/foreign ID
oracles; run Miri on lifecycle logic. A mutant omitting parent-column attachment
must fail. The safe selected variant restores forbid(unsafe_code), removes the
hint/runtime alternatives from shipping code, and retains simple scalar fallback.
Future-hint comparator retains the narrowly scoped earlier unsafe invariant.
