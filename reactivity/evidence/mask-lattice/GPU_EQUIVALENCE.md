# Admission narrowed before any performance observation

The first implementation837a23d44e72d3893cbbcf92e17434b1076b8d1a passes353 GPU/
canvas tests and strict Clippy, and the scalar address oracle passes. Independent
pre-change GPU capture6faae98aa7391ede8f07f9325e63f044f1de9adf nevertheless differs
in12/336 frames: near-boundary origin2.125.next_up(), zero horizontal translation,
all three formats, both paint routes and both record modes.99 SDR pixels/106 HDR
pixels differ. Full bytes, hashes and first mismatch evidence remain external.
No tolerance, pixel subset or performance observation is introduced.

Canonical address equivalence alone does not prove equality with the existing
GPU correction/normalization path at numerically ambiguous texel boundaries.
Narrow eligibility using the actual uploaded per-axis error (shared maximum for
compact groups). Distance of the canonical device origin from the odd-eighth
sample lattice must exceed4*(error+(extent+32)*3.8146973e-6). Unit-scale CSR bins
extend at most one16-pixel tile beyond a glyph's canonical bounds. The extra32
and fourfold factor enclose ordinary position, normalization and correction
threshold errors. Near-tie and exact-tie phases keep the original generic GPU
sampler; admitted samples remain outside its correction branch and retain the
same scalar cell. This is a stricter input certificate, not a changed output
oracle. No canonical geometry or clipping changes; all16 samples remain.

The revised production source and all GPU/numerical/public tests must be frozen
and rerun, including the identical336-frame independent oracle and a new bounded
width mutant on the revised source. All earlier failures stay failed. The native
performance schedule/gates are unchanged and have not begun.
