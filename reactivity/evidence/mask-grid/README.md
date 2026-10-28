# Budget-preserving mask grid: early GPU admission

Corrected production39efefe58d08646a8976171770c369c28e91e10d passes356 GPU/canvas
tests (3 ignored), strict Clippy and336 exact unchanged public images versus
independently compiled original oracle6faae98a. Added budget-boundary/fallback,
partial-tile and alternating-grid replay checks pass. No application API changes.
Shipping38262 lines (+55 mask-miss,+234 suffix); generated WGSL22953 bytes.
Larger grid/CSR capacities, CPU prepass, uploads and code-generation costs remain
unqualified. Coarse fallback keeps the4Mi reference budget.

Initial02d46fee failed typed WGSL validation: signed inferred edge divided an
unsigned coordinate. No test executable ran. Corrected explicitu32 declaration
and cleaned release GPU package before rebuilding; original failure preserved.

Bounded mutantd992ae45 ignores the host fine-grid bit. Its ordinary public test
passes internal replay/compact/proof comparisons because all share the same wrong
grid. The harness incorrectly expected exit101; its AssertionError is retained.
Independent original-oracle comparison rejects all336 captured mutant frames;
first0-false-0-0-false.rgba has5877 differing bytes (first3098,126versus125).
This is an external exact-pixel rejection, not a claimed test panic. No retry or
fixture change. Candidate matches every corresponding independent frame.

Early admission only: native path/count audit, performance screen, full
configurations/offline/cost/ZGX/hardware/quality gates remain open. No adoption.
