# Coverage and opaque-prefix frontier — unadopted

Final source `a81bc7536b002b1f81e1b36137c1c4de543e2204` extends the
[uniform-word experiment](../unadopted/README.md). Complete GPU source and
consumer patches are against the shipping commit named in `summary.json`.
The patches include the prerequisite shader consolidation and uniform-word
representation. No shipping renderer is changed by this archive.

The replacement loop now borrows corresponding old/new word slices. In the
actual optimized linked body, one- and two-word comparisons use 16-byte
`movdqu`/`pcmpeqb`/`pmovmskb` sequences. There is no handwritten SIMD, fallback
fork, new dependency, unsafe block, retained field or allocation. This source
form alone reduces linked groups `.text` by 624 bytes against `0be1f9`;
prefix-writing code and its frame grow, and the new one-word helper is charged.
This establishes generated instructions and code size, not elapsed speed.

Two additional bits in existing CSR range endpoints certify constant sample
coverage and an opaque first surviving draw. They add no per-tile storage.
Solid geometry covering every 4x4 sample may be translucent, signed or HDR;
the existing alpha-one/sign-safe proof still exclusively controls dropping
earlier draws. A partially covered draw clears constant coverage, and a later
translucent covering draw cannot restore it. A later safe opaque covering draw
can reset the range. Reverse CSR traversal and painter order remain unchanged.

Constant-coverage tiles blend the ordered draw sequence once per pixel instead
of repeating it at sixteen samples. Sampled tiles blend a certified opaque
prefix once before the sixteen-sample tail, including text and image tails.
A color-only loader reuses the bank decoder without loading geometric state
in its source expression; physical GPU memory transactions are unmeasured.
For the exact two-draw 16x16 prefix fixture, planned source evaluations fall
from 8,192 to 4,352. No claim of proportional wall-time improvement follows.
The final CPU edit classifies material once per draw and skips coverage proofs
when their result cannot change either the opaque cutoff or constant tag.

The first constant-range implementation failed the existing actual HDR test:
the shader optimizer preserved negative zero where the original reduction
produced positive zero. Its log is retained. The corrected path changes only
the exact negative-zero bit pattern to positive zero with integer operations.
This incident is a reason to retain actual backend controls; algebra alone
does not establish floating-point bit equivalence under WGSL optimization.
An initially incorrect empty-tile diagnostic count was also corrected before
qualification. The public diagnostic meaning of `sample_draw_evaluations`
now includes the once-per-pixel seed and constant path; it no longer literally
counts invocations of the general sample function. No fields are added.

Final a81 qualification passes default and no-SIMD fallback suites, each with
11 library, 4 presentation, 52 readback and 1 compile-fail documentation test.
Offline-artifact qualification passes 12, 4, 53 and 1, including SPIR-V/ABI
validation. Strict all-target Clippy passes in normal and offline modes.
Actual Apple ARM64 and Windows MSVC all-feature library checks pass; these
are compile checks, not foreign runtime execution. Historical raw readbacks
were captured at `67510c`, before the CPU proof hoist: all 578 files totaling
13,912,048 bytes match the experimental baseline exactly. The shader is
unchanged by the subsequent CPU edit. Final a81 rendering tests are separate
evidence and do not relabel those historical capture bytes.

The retained linked-code comparison uses the same physical source path,
features, lockfile, release profile and root flags, appending stack metadata
once. Final groups `.text` is **1,616 bytes larger** than `2774732`, read-only
data +896 and relocation data +96. Renderer code is 9,261 versus 9,296 bytes,
but its static frame is **1,448 versus 1,432 bytes**. The final CPU proof hoist
alone adds 96 linked code bytes and 24 relocation bytes. These are static
metadata frames, not measured dynamic stack peaks or additive call chains.
Syn/Tokei charges **30,796** noncomment, nontest core lines: **+104** against
shipping 30,692. Tests, examples, documentation, vendors and evidence are
excluded. Smaller packet words and fewer blends do not satisfy adoption gates.

`captures.tar.gz` preserves intermediate failures, qualification logs, raw
readbacks, observer patches, runners, linked symbol/alias/frame ledgers and
assembly. Every member was reopened and SHA-256 checked against the manifest;
linked ELF files are excluded but their sizes/hashes remain recorded. The
earlier uniform archive retains its independent recovery and 17-bit-handle
negative controls. GPU execution uses Mesa llvmpipe software Vulkan. Hardware
GPU behavior, scanout, startup, RSS, application responsiveness and matched
performance remain unproven; this frontier remains unadopted.
