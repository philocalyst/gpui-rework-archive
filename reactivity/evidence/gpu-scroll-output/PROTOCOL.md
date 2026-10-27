# Isolate scroll submission and restore ordinary output footprint

Registered before implementation, following failed scroll-copy dossier
8041b7a7fe4f21f27498110e30034d300fee5a7f. Original baseline4afe067fe3e has the
same actual100K-row Workload/public owner/native bridge fixture as failed-copy
8eebb25bd8, via unchanged test-only baseline6269bdfafc. All changes remain local.

The predecessor has large scroll/mixed gains but its8x8 flat paired median ratio
1.071750023 fails1.05. Warm flat allocation/work/image counts are unchanged.
GPU Output40->48, SlotGuard80->88 and submit636->1176 machine bytes suggest a
common-path layout/dispatch hypothesis, not proof of a causal slowdown. Preserve
that failed verdict and its wide uncertainty interval.

Candidate: replace simultaneously stored ordinary damage and optional scroll
pointer with a closed mutually exclusive Full/Region/Scroll descriptor. Test
whether it restores Output40/SlotGuard80. Separate scroll submission from the
ordinary submission body so unsupported/absent scrolls do not carry the scroll
repair loop through ordinary code generation. Keep safe Rust and bounded closed
payloads; no dynamic dispatch, unsafe niches or representation transmutation.

Do not alter Canvas contribution equivalence, Runtime proposal eligibility,
presentation-token authority, shaders, scratch capacity/allocation policy,
source routes, API defaults, command work or viewport/text geometry. In particular
retain the192-byte Backing from the predecessor: lazy-boxing its scratch is a
separate hypothesis. Only the mutually exclusive output representation and scroll
submission isolation are changed here; measure total code/stack, not just the
outlined caller. Existing public application/render calls remain compatible.

Correctness gates: exact public Canvas/GPU oracles including repeated/bidirectional
copies, failure/resize/unsupported fallback and stale image tokens; actual native
Workload scroll/mixed pixel oracle; whole default/X11 GPUI+Canvas and GPU suites,
strict Clippy and11 native scripts. Preserve the original content/token negative
witnesses. Add a fresh mutant that clears instead of loads the retained copied
image before repair, which must fail the complete GPU pixel oracle. No tolerance
changes. Freeze clean commits, all-input guards and unique targets; preserve actual
executed/measured binaries before rebuild/removal.

Use byte-identical scroll_bench.rs and native Workload fixture from8eebb25bd8 and
the same ten cases,16warmups/64measured frames, cold owner/first-image reporting,
explicit llvmpipe and LP_NUM_THREADS=4. No threshold/fixture adjustment. Original
acceptance remains>=20% scroll AND mixed gain, all eight controls<=1.05. Also
require candidate/predecessor median ratio<=1.05 in every case to retain the
mechanism's performance. Report confidence intervals and do not turn uncertain
point gates into adoption or hardware claims.

15 independent pairs/case for each comparison,450 fresh timing processes across
original, failed-copy and candidate. Freeze a shuffled10x15 job-group order using
seed20261028 before timing: each(case,pair) group runs all three variants in one
of the six permutations, chosen cyclically by(pair+case_index)%6. The same original
and predecessor observations each pair compare to the candidate. Each process has
its own complete final pixel oracle. Three correctness-only processes per variant
and case, then one separate allocation process per variant and case precede timing.
All work/hash/epoch/copy/image counters must agree with intended admission; no
compiler/test/allocation/cleanup overlaps timing. Maintain>=8GiB free.

The primary estimator is median of15 paired process-median ratios; type-7 p95/p99
and paired median bootstrap10000 resamples(seed20261028), raw tails and cold/first
copy costs are reported. Compile profiles/toolchain/features match. Existing
immutable comparator ELFs may be reused from their exact source/feature receipts;
run them anew on these traces. Cross-worktree target reuse is forbidden.

This is a complete public owner/scene/native-bridge/GPU-completion/ACK micro gate
on a ready device. Native event dispatch, producer transport, WSI, device startup,
OS cold caches, scanout, text-quality parity and two physical hardware classes
remain separate. No ZGX victory or BBTree cache-hit claim follows from this trial.
