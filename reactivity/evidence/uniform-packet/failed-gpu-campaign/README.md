# Failed fixed GPU comparison

The uniform packet/coverage candidate `a81bc7536b002b1f81e1b36137c1c4de543e2204`
remains unadopted. This preserves its complete fixed v3 comparison against
shipping GPU source, not a production speed claim.

All 22 scheduled AB/BA legs completed in 204.504 seconds, from
2026-10-23T13:47:54.314787Z to 13:51:18.831086Z. Eleven paired readbacks matched
exactly; source/binary guards, process deadlines and team quiet monitoring
passed. No retry, dropped cell or gate change followed measurement.

Correctness passes; regression and speed gates fail. Equal-cell paired geometric
mean median candidate/control ratios are 1.2843916 for host submission and
0.4873842 for total submission plus device-poll wall time. Host has zero of
11 faster process pairs; total has eleven of eleven. Poll is CPU/device
synchronization wall time on llvmpipe software Vulkan, not a GPU timestamp or
hardware measurement. Zero of 26 host cells and 20 of 26 total cells satisfy
all registered cell rules; these rules include tails, not just medians.

All 6,864 raw warmup/measured frames remain in the archive. The worst host
maximum-frame ratio is 34.9426 (rounded SDR motion, pair 5); the worst total
ratio is 5.64736 (flat SDR static, pair 6). Exact raw paths and original stats
remain in the linked ledgers. The analyzer's positive and negative controls,
calibration, original parser failure, source snapshots, fingerprints and full
readbacks remain in `captures.tar.gz`. Root independently reopens and hashes
every payload and all three externally preserved ELF binaries.

The historical source/codegen bill compares candidate to intermediate 277,
not the timed shipping source: +104 core lines, +1,616 text, +896 rodata,
+96 relro bytes and +16 static renderer frame bytes. Keep that baseline
explicit. No new static build is implied by this timed comparison.

The source diagnosis identifies repeated full-tile corner proofs for full
translucent layers. It does not explain away the independent 32K draw
regressions or tails. A new isolated coverage-setup successor is in progress;
this failed capture remains unchanged and is not relabeled by later work.
