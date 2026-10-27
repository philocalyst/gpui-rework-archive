# Structural delivery sweep: rejected after complete public-operation timing

Candidate 5aa10c66efcfc7c69be83654148d43ad50f28e07; exact source and
control pins are in raw/*-qualified/source.txt. No application API changes.
The sealed inferred LaneSet gains a private-use structural admission method.
No runtime, queue, retained readiness cache, unsafe or owner field was added.

A stack cursor replaces repeated numeric stage(index) calls with bounded
structural sweeps. Per-lane FIFO, round-robin cursor, frozen backlog, limits,
and freeze-before-callback semantics are unchanged. This is a routing/codegen
experiment informed by BBTree; it is not a prefetch executor or async graph.

**Reject.** The primary 64-lane all-ready case is 2.61% slower, missing the
required >=20% improvement. Idle-one and rotating32/64 exceed the <=5%
regression gate. Do not retune those gates or claim fewer cache misses.

| Lanes | Idle ratio | One active ratio | All ready ratio | Budget-one rotation ratio |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1.2184 | 1.0307 | 1.0287 | 0.9953 |
| 8 | 0.9613 | 0.8542 | 1.0041 | 1.0102 |
| 32 | 0.9383 | 0.9612 | 0.9793 | 1.0700 |
| 64 | 0.9499 | 0.8336 | 1.0261 | 1.1419 |

Ratios are medians of five candidate/control process pairs on CPU2. All
160 processes and 6,400 batches are retained, 640,000 complete fixture steps.
A rotate step delivers and acknowledges once per lane; it is not one call.
Final order-sensitive payload fold, fresh-window exact pixels and Counters
match across every pair. Cold wall cost and RSS are in the original logs.
CPU/wall p50/p95/p99 and paired ranges are in raw/paired/summary.json.
The correctness preflight ran alongside compilation; its times are excluded.

The compiled control falsifies the naive source-level quadratic-routing
hypothesis: its 64-lane stage entry dispatches through a jump table (cmp17,
table load, indirect jump). It is not 64 dependent pointer traversals for
every index. Candidate stage_sweep is 9,596 bytes versus control stage 4,840;
the selected symbols and actual instructions are retained, full disassembly
losslessly gzipped. These observations do not isolate every cycle cost.
Whole ELF 10,333,800→10,343,320 bytes. Shipping inventory 36,644 lines
(+66 versus the 36,578 base); owner/queue retained storage is unchanged.
StageSweep is transient typed control state; no measured stack-byte claim.

The full default GPUI suite passes 707 tests, including real Question joins,
stale-completion and cancellation cases. The existing two-Reader diamond
waits for both inputs, supersedes old work, and publishes the new result.
Strict all-target release Clippy passes. The added indexed-oracle differential
covers all 625 four-lane readiness/limit patterns, four cursors, six budgets
and three backlog values (45,000 combinations). A cursor-reset mutant fails
the existing public fairness test: [100,101,102,103,0,1,2,3] replaces the
required alternating order. No timing outcome substitutes for those gates.

The first fixture build failed Rust2024 opaque-return lifetime capture;
precise use<L> fixed only the helper signature in both variants. Both failed
attempts and source guards remain. The negative test was initially launched
before worktree setup finished; no Cargo ran in that attempt, which is noted.
All final source guards and ELF hashes pass. No native or hardware performance
claim is made for this rejected candidate. Run verify.py independently.
