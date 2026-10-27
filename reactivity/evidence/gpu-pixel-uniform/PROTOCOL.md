# Pixel-uniform coverage in mixed-color tiles: preregistration

Base 6d5e409d6b, excluding rejected draw-major shading and bounded-cache slices.
The native scrolling lab changes integer-aligned 28-pixel row backgrounds.
Existing whole-tile uniform-color proofs fail where a 16-pixel tile crosses rows,
even though each pixel's sixteen coverage samples are identical. Hypothesis:
certify a tile's surviving packet records as lowered solid rectangles with
integer sample-domain endpoints, then execute painter-order composition once
per pixel. Keep original per-sample evaluation as the fallback and disabled-proof
oracle. Colors/alpha may vary between draws/pixels; do not require uniform color.
Preserve final IEEE zero/sign and reduction behavior. No new unsafe or app API.

Do not certify masks, images, rounded geometry, clips, nonintegral rectangle
endpoints or unlowered inverse transforms. Existing host sample-set lowering
must happen first. Honor set_tile_proofs(false); no fallback oracle may silently
use the new certificate. Paint-slot color updates keep geometry authority; tests
must exercise opaque/translucent slots, partial tiles, HDR and negative zero.
Charge metadata, extra reference walks, upload/storage and generated shader size.

Freeze identical 960x720 unbanked fixtures before changing production code:
flat, integer stripes, text on stripes, quarter-offset stripes, HDR stripes.
Five paired AB/BA processes, 10 warmups then 60 measured submissions per cell;
record every host and submission-through-poll duration, cold prepare, max RSS,
complete initial/final image bytes and artifact hashes. Candidate and control
readbacks must be byte-identical. Do not time alongside compilers/tests.
Require >=20% median completion improvement in stripes and text-on-stripes, no
other cell >5% worse, and no unexplained CPU preparation regression. Noise is
inconclusive. Independent GPU/CPU tests remain unchanged; add a direct pixel
certificate witness and a fractional-edge mutant that fails an exact readback.
Check actual generated WGSL against typed source and binary bytes.

Local software Vulkan is diagnostic, not hardware acceptance or scanout latency.
Native benchmark output/typography and feature parity, equivalent dist builds,
complete-workload tail latency and two physical hardware classes remain gates.
