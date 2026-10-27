# Ordinary draw-major compositor: rejected

Protocol frozen before the fixture and shader edits. Control 032bc1b986;
production candidate d297acf16f, qualified with artifact/overlap oracles at
e9124d286c. Ordinary scene packets use the already existing paint-banked
ordered shader: decode one draw, evaluate its sixteen samples, then advance.
Per-sample painter order and the final anchor/delta reduction are unchanged.
This removes the duplicate sample-major loop, with no application API change.

Five interleaved process pairs; five unbanked scenes per process; ten warmups
and sixty measured submissions per scene. 3000 measured redraws total. The
primary endpoint includes native Vulkan submission and device completion poll,
not monitor scanout. Each process records cold context/scene/first-frame costs
separately, all measured host/completion samples, memory statistics and max RSS.
Initial/final full image bytes are retained and exactly equal across alternatives,
including HDR. These are isolated compositor redraws, not end-to-end app updates.

| Scene | Candidate/control median completion ratio | Pair range |
| --- | ---: | ---: |
| Flat | 0.9847 | 0.8496–1.1549 |
| Text | 0.9307 | 0.7005–0.9483 |
| Translucent overlap | 1.0145 | 0.9755–1.0278 |
| Transformed text | 0.9088 | 0.8559–0.9692 |
| HDR | 1.0261 | 1.0115–1.0430 |

Text and transformed text both miss the required 20% improvement. Flat is noisy;
HDR completion regresses 2.6%, and its host median ratio is 1.0540. No aggregate
win or code deletion overrides these gates. **Rejected; do not compose this
shader into the subsequent pixel-uniform experiment.**

59 real software-Vulkan readback tests and 10 GPU units pass unchanged, with one
added exact painter-order witness. Strict Clippy passes. A reversed-painter-order
mutant returns [255,0,0,255] where [0,0,255,255] is required, exiting 101 with one
failed test. The first audit looked for the panic in stdout; corrected audit
checks stderr, preserving the mistake. The first dossier verifier expected
eight default-feature unit tests; this Vulkan-enabled suite has ten. Its count
was corrected without changing any test or performance gate. Source guards match before/after.
The typed shader is compared directly with generated WGSL by a unit assertion;
the complete WGSL byte string is verified inside the benchmark ELF. Both initial
and final executable identities are retained. No SPIR-V artifact is embedded in
this WGSL profile; driver translation is not falsely counted as an ELF artifact.

Shipping core decreases by 23 lines (36555 versus 36578). Generated WGSL decreases
from 18995 to 18181 bytes. Buffer/atlas/index sizes are in each cold Stats record;
no new dependency/vendor/storage buffers or unsafe code. Source-level sixteen
vec4 colors need 256 bytes of local sample values versus the scalar path's two
vec4 accumulators; actual driver register, spill and stack allocation is unknown.
Do not infer a register-pressure improvement from the deleted code.

Pinned nightly 2026-10-23, default release, llvmpipe LLVM20/Mesa25.2.8 Vulkan,
four software-driver threads. Physical GPU, native feature equivalence and two
hardware classes remain untested. No ZGX victory. Run `python3 verify.py` here
for independent sample/ratio, image, artifact and deliberate-failure checks.
