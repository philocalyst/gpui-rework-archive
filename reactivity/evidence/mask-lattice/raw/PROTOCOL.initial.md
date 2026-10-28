# Glyph mask lattice lowering — preregistration before implementation

Base production df8ca59f69813e7dd05711fead98ed4278f1688d: exact suffix startup
win qualified at380db598cdbed2dd81c5a41745473c40a876f148, native startup
bea6c4cf9135f494925ccd80b05f584e20fe7ff4, full28-case regression
f90ca6b10844b9c7c828e37e310021d0e270df6c. Every old failed experiment remains failed.
New local/mask-lattice, /home/user/gpui-mask-lattice-lab and unique target
/home/user/gpui-mask-lattice-target; external /home/user/gpui-mask-lattice-evidence.
Unique oracle/mutant checkouts/targets must be created with fail-fast guards.
No application API, dependency, unsafe or ownership-model change is intended.

## Hypothesis and exact certificate

Prior native thread diagnostics identify raster workers as the dominant CPU
cost. Generic mask samples repeatedly evaluate inverses, normalized texel
coordinates and correction bounds at all16 sample points. For unit-scale
translations and one mask texel per local unit, their addresses can be lowered
once during packet preparation while retaining every sample/composite operation.
This is an unmeasured hypothesis, not a cache-hit or custom-runtime claim.

Retain canonical geometry/clip for admission, CSR and all publication proofs.
A private material tag marks only admitted mask placements, in existing words;
no new per-draw allocation, pipeline or retained lookup structure. Keep original
clip/correction handling, shared state, paint-bank authority and atlas identity.
The GPU can then subtract a lowered device origin, test the same half-open
extent, floor the coordinate and fetch the same mask texel. Alpha/composition,
all16 correlated samples, anchor/delta reduction, output conversion and copies
remain unchanged. All other transforms/densities/materials use the old path.

Admission requires exact unit inverse axes and zero cross terms, logical mask
extents equal integer atlas dimensions, and canonical local origins/translations
on a bounded dyadic grid. Proposed sufficient domain: components are multiples
of2^-32 with magnitude<=2^17. With viewport<=16384, sums/differences occupy fewer
than53 integer bits after scaling, so the canonical f64 map and subtraction are
exact. The address-equivalent device origin is ceil((origin-1/8)*4)/4. It selects
the identical nearest-neighbor cell at every fixed odd-eighth sample; integer
extents preserve both edges. Its f32 quarter-grid subtraction at these bounded
coordinates is exact. Check this derivation against the actual scalar oracle,
including ties, both signs, clip endpoints and rejection boundaries; narrow the
certificate if needed before observations and retain failed attempts.

This differs from rejected pixel-uniform173e7c1a34: no collapsing16 samples,
no new tile-class dispatch and no SDR-only reassociation. BBTree's useful lesson
here is resolving repeated dependent work into a compact internal operation;
its noop-waker memory lanes cannot stand in for real async task readiness.
Solid/Ripple's compute/publication split requires immutable resource identity
and acknowledged authority to remain intact. Previous generic owner-memory-lane
failures remain evidence against assuming a scheduler alone fixes raster cost.

## Correctness and mechanism gates before timing

Freeze clean sources before every build; separate targets; exact Cargo freshness,
executed ELF and generated/embedded WGSL/SPIR-V receipts. Use pinned
nightly2026-10-23 content-fingerprint, locked offline release. No source edit
until processes and input guards finish. At least8GiB free throughout; prefer12GiB
before fresh full builds. Preserve inactive source/evidence before cache cleanup.

Public Canvas/Renderer fixtures cover inline/compact draws, banked/unbanked
paints, multiple glyph leases and atlas placements, clips/chains and rounded
ancestors, fractional origins and exact sample ties, alpha overlap, transform/
density fallbacks, SDR/BGRA/HDR, replay and sparse repair. Compare exact GPU
readbacks against independently compiled pre-change core with identical fixture
code; preserve the full images/hashes, no new tolerance. Unit arithmetic tests
compare certificate membership and texel cells with actual scalar formulas.
Require exercised eligible/rejected cases and a bounded mutant that violates
an admission condition and fails exact sample/pixel authority. Run full GPU/
canvas and strict Clippy, default/full-native/minimal/offline composed gates,
application port and existing actual X11 scripts before end-to-end claims.
Record fresh/cached artifacts and test-only source additions separately.

## First native admission screen

Matched native opt3/fat-LTO/CGU1/unwind/debug0/stripnone profile, same driver and
LP_NUM_THREADS=4, owned X11:94. Reuse exact qualified suffix native baseline;
compile candidate in a fresh target. Existing native Workload and workload
ports remain byte-identical outside test-only correctness visitors. Sixteen
model warmups in later cost matrix remain unchanged; native starts from actual
empty state. Before timing, exact frozen captures at initial0/190 and port tests.

Four cases idle/scroll/stream/both, eight AB/BA balanced pairs per case, eight
seconds per process, all32 groups shuffled seed20261111:64 processes. Freeze
schedule, runner, analyzer and independent verifier before observations. Enforce
464–488 updates for active cases, <=2 ACK gaps>25ms in firstsecond, none later;
zero idle updates. No ratios for failed cadence. CPU measured over fixed visible
+1..6s window with>=4.8s coverage, same sampling/trace for both. Candidate/baseline
paired median CPU <=.8 in stream and both; <=1.05 in scroll. Idle has no added
frame/loop work and no observed CPU growth. Report10000 paired bootstrap/type7
intervals reset seed per case, RSS, startup, task/tick counts and all failures.
No subset, threshold change or same-candidate retry after performance failure.

If and only if that screen passes, run the unchanged28-case complete cost gate:
168 qualification and56 invoking-thread allocation processes;4160 timing
processes,16 warmups+64 measured operations,20 pairs scroll/both/stream/stream-owner,
120 flat-tiny/list-tiny,80 every other case, alternating pairs shuffled seed20261112.
Require all paired median process-p50 candidate/baseline ratios<=1.05, exact pixels/
epochs/copy/image/composited work, unchanged hot headers and no growth in warm
requests/requested/net/peak bytes. Report cold/tails/ELF/shipping/generated-code/
local-stack and retained capacities separately. Changed sampling addresses must
not reduce model work or reported16-sample counts.

Only then admit a fresh matched native ZGX comparison with the prior fixed
20% CPU advantage and cadence gates. A software-Vulkan win alone cannot satisfy
two-hardware-class, physical GPU/scanout or visual-quality gates. Do not mark
the user's overall goal achieved until those requirements are actually met.
All changes stay local; the campaign remains active.
