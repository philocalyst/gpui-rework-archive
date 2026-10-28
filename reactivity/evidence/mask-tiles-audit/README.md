# Actual native literal-mask traversal selection: verified audit

Instrumentedsource9dcff820167b627d272bb391090a9613e00a4b2a uses the exact
shader and complete workload of productiond63782dd. All8 preregistered native
processes exit normally,with1,082 packet preparations across idle/scroll/stream/
both andinitial0/190. Every packet has zero paint-bank entries and a false
banked packet tag,yet every packet now selects literal mask tiles. Across the
cohort,916,140 tile selections are recorded. All2,587,037 lowered mask references
lie within selected tiles; actual mask references total2,779,389.

These are instrumented CPU-side packet decisions and planned full-packet sample
counts,not GPU instruction/cache counts or actual damage-cropped shading work.
Shader dispatch for the checked range bit is in the exact embedded WGSL. The
initial full native frames render marked tiles with that shader. Both frozen
initial0/190 native images match the uninstrumented reference exactly. This
closes the missing-path issue diagnosed in6d63fbf4; it establishes no speedup.

All17 workload tests pass. Source/profile/driver/artifact guards pass. Generated
WGSL matches the main candidate's independently qualified artifact and occurs
inside the executed native ELF. The logger correctly distinguishes untextured
solids using nonzero mask dimensions and clears the tile tag before decoding
reference ranges. Its sample sums equal existing Stats. No shader instrumentation,
workload edits,performance measurement or production adoption in this audit.

Run `python3 verify.py` to rederive all8 raw observations,selected-count gates,
source/artifact identities and exact images. The uninstrumented matched64-process
screen remains pending; later full configuration/offline/native/cost/ZGX/hardware/
scanout/quality gates remain open. All prior experiment failures remain rejected.
All changes local; canonical executables are externally hash-addressed.
