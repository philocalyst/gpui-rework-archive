# Cold scratch trimming: preregistration

A separate candidate based on bounded-cache dossier e6bda77dfc (production
fefa519956), retaining the original 1024-byte eligibility threshold and all
memory/semantic gates. The previous candidate retained at most 45,046 requested
planner bytes but exceeded the 5% CPU regression gate in two cells. It remains
unadopted; this experiment does not replace or reinterpret its measurements.

BBTree source 1b0201087102f81189da0c4cd5054a91c8d97d62, design/06-cost-model.md
and design/03-decisions.md D50, describes how a rare call inside a hot traversal
changed register/stack behavior. Transfer hypothesis: move paragraph scratch
replacement into a non-inlined cold helper, retaining only a flag check in
PlannerState::for_cache. This is a code-generation hypothesis, not proof of the
cause of the preceding regression. Inspect linked assembly before timing.
No changes to cache eligibility, ownership, fonts, layout output, dependencies,
unsafe code or application APIs. Preserve old bounded and unbounded controls.

Before timing, freeze a clean commit; run exact cached/fresh Unicode/layout and
font replacement tests including layouts retained across trimming. Run the
unchanged capacity ledger: <=256 KiB retained after every stage and zero after
clear/drop. Preserve long-paragraph transient peak and first-short rebuilding
costs. The old no-trim mutant remains historical evidence; build a new mutant
removing only the cold helper's two replacements and require the same memory
failure. Preserve before/after complete source guards and binary hashes.

Five paired/interleaved processes in each 0/25/100/1000/10000-static-label cell,
200 warmups, 2000 operations in batches of ten, ordinary source-to-recording plus
ACK fixture. Compare candidate, old bounded, unbounded cache and sparse-only.
Same pinned nightly, default release, identical DejaVu font and final pixel
oracle. Candidate must be within 5% of unbounded cache in every cell, and retain
>=20% advantage over sparse-only at 0 and 1000 labels. Noise is inconclusive.
Do not run compilers, other benchmarks or allocation probes during timing.
Keep every batch, process order, CPU/wall p50/p95/p99, max RSS, cold costs and
linked-code sizes. Inventory shipping lines separately from fixtures/evidence.

A passing CPU/memory experiment admits broader composed native qualification.
It does not establish ZGX superiority, hardware GPU behavior or scanout latency.
