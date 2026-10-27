# Size-gated, outlined tile equivalence

Base3dd29a0ebdea85ed7b4076ab51069865293e8737 remains rejected. Its stream saved
about85% of damaged compositing pixels, but short one-field updates saved none
(416→416) while paying extra word/list comparisons and commands. Test a fixed
4096-pixel minimum bounding-damage area (sixteen16x16 tiles) for refinement.
This is a conservative work-amortization hypothesis, not a hardware-cache
measurement or a threshold retroactively applied to the prior samples.

Move dirty-list/word comparison out of the CSR rebuild into a separate outlined
read-only pass, called only for Some nonempty damage with area>=4096. Compute
common-word changes only inside that pass. Smaller damage retains packet-only
preparation/submission. None remains explicit full repaint, empty damage copies
only; greater than256 spans still falls back to original bounding damage.
Preserve both old and new memberships, exact common-word numerical bounds,
shader words/arithmetic, painter order, resources, token/ACK and atomic rejection.
No public API, dependency, retained header, or unsafe changes. Charge the extra
large-case pass, code/stack, transient allocations and all baseline costs.

Before timing: complete GPU suite/strict Clippy, exact public threshold-boundary
cases at4095/4096 pixels, existing equal-word/different-membership numerical
witness, moved/occluded/fractional/HDR/late-failure/span-cap tests; full/default
and X11 GPUI+Canvas suites and strict Clippy; six actual private-X11 scripts.
A fresh omitted-old-membership mutant must fail the moved-glyph exact image.
Freeze clean commits; full input guards, immutable ELFs, generated shader bytes.

Primary measurement keeps the identical21-cell GPU fixture and immutable full
control64523d173a / SHA8773b9f402d60b583ad96bba77ba20b98c4615e938e4f0114bb014b91ded4470.
Five alternating pairs,10 warmups60 updates, affinity2–5, llvmpipe4, same font,
features and pinned nightly. Primary1000-label stream and two/four-field exact
completion ratios<=.8; all full-scene and short one-field controls<=1.05.
Report every other cell, pair range, cold/p50/p95/p99, RSS and exact final images.

Separate mechanism comparison against the frozen ungated tile ELF
58f1d07001088c0e420f290b32a56ed5fff7e516e8fb8e01d772ff652f6878fc:
three alternating pairs for0/25-label single exact,25-label two exact,
1000-label four exact, and stream0/25/1000 (seven cells,42 processes).
The two single-field median ratios must be<=1.0 and stream ratios<=1.05;
report the two other short-batch cells. Keep4096 fixed even if a gate fails.
No owned compiler, tests, allocator probes or source edits alongside timings.
Separate42-process allocation/actual-repaint accounting, full shipping/code/
stack/header/capacity ledger. Diagnostic allocator times are not performance.

This VM provides software Vulkan/private X11, not physical GPU or scanout.
Equivalent native ZGX ports, matched distribution profiles and two hardware
classes remain mandatory. Keep all changes local; no automatic adoption/push.
