# Resident word deltas: functional qualification only

**Unadopted.** Baseline `984e5eb0ce`; first word-loop `c98422fd76`;
run-based production `78497e978e`; stronger failure test `6224da8f97`.
The patches, ordinary optimized library assembly, fingerprints and controls
are preserved here. This archive does not change shipping GPU source.

The builder overwrites the existing CPU packet, compares final words bitwise,
and temporarily uses proven-unused correction/address/padding bits for dirty
masks. Resource coordinates are finalized after draw and resource admission.
Reverse CSR construction clears the masks before upload and coalesces adjacent
dirty words. First or invalidated packets use one full record-prefix upload.
PaintRenderer carries pre-clear residency only on its exclusive stack.
Buffer growth and image relocation independently force full writes.

No shadow packet, dirty Vec, owner field, unsafe code or shader ABI is added.
Measured headers remain Renderer 888 B, RendererState 840 B and Stats 200 B.
Syn/Tokei charges **30,692 → 30,894**, including 18 library build lines in both:
**202 additional noncomment, nontest core lines**. Tests, comments, examples,
vendors and evidence are excluded. No future reduction is booked.

Default SIMD and fallback configurations each pass 12 library, 4 presentation
and 47 software-Vulkan readback cases. Strict all-target Clippy passes.
The final stronger test passes after restoring production source, followed by
the complete 12/4/47 suite and strict Clippy again. Existing HDR, image, paint
bank, queued replay, wrong-context, growth/shrink and device-loss controls pass.
The 4,096-mask unit test checks exact maximal runs across record boundaries.

Identical scenes upload zero draw-record bytes. The shared-glyph/inline-image
translation fixture uploads at most 80 draw-record bytes and zero glyph-mask
or image-pixel bytes. Uniform, tile, index and correction uploads, validation,
binning, bind groups and complete pixel rendering remain charged.

The deliberate missing-residency fault fails the final actual pixel comparison
after a late GPU precision rejection. Recovery preserves dimensions, record
count and image prefix, so relocation cannot conceal the fault. The earlier
negative control caught only the full-upload invariant. The stronger one
catches wrong pixels. The first `--exact` attempt accidentally selected zero
tests; that log is retained and excluded. Full-name controls select one test.

Assembly inspection motivated walking dirty runs instead of every word.
Ordinary x86_64 library output already uses 128-bit integer word comparisons;
no native CPU flags or second scalar algorithm is used. Three constant-width
run specializations increase generated code, an unresolved cost. These are
library assembly controls, not linked application or timing proof. Sparse
color changes can still produce one queue write per draw. Fewer bytes alone
cannot establish better CPU time or latency.

No timing, hardware-GPU, startup, foreign-runtime or adoption claim is made.
A proposed four-word shared-state prefix and two-word placement suffix could
remove inline encoding and much of this machinery. Packing a correction index
into an upward-rounded error certificate needs separate numerical proof:
wider guards can change linear-filter fractions. It is not an implemented or
lossless replacement.
