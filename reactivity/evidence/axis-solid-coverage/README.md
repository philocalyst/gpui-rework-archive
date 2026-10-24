# Canonical sample coverage for axis-aligned solids

Main adopts Root composition `36b559ad5c60ad8261c5ffe4fc23130c916343b5` over
`202d34f328`, retaining the borrowed correction qualified at
`e872330f303deae4a7fba191af31e5bffa574054`.
[Exact adopted source hashes](source-equivalence.json) cover all four paths.

At scale 1.25, stored inverse 0.8 maps world sample 10.625 to the half-open
local edge 8.5 in the canonical CPU operation order. The old GPU double-double
reconstruction selects the other side. The original 39 bad bytes and native
trace remain preserved. Both the shipping source and the proposed uniform-prefix
optimization fail the adversarial fixture; that optimization remains stopped.

For plain axis-aligned solids, the renderer now lowers the existing canonical
inverse predicate onto the exact quarter-pixel interval selecting the same 4×4
samples. Only uploaded coverage changes. Original geometry still drives
validation, bounds, CSR membership, opaque proofs and patch addresses. Rounded,
glyph, image and sheared sources keep their original path. Empty coverage uses
a positive offscreen domain to avoid eager shader division by zero. Generated
WGSL, packet ABI, GPU resources and color operations are unchanged.

PreparedDraw and Mapping cross the lowering boundaries by borrow. No new
retained fields, allocations or caches are added. The correctness fix adds 68
non-test, non-comment core lines, making the composed core 31,813.
[The independent Main inventory](main-core-lines.json), measured at `63e0a521f4`,
counts 31,795 library source lines and 18 build-script lines. Vendored code,
comments, tests, examples and application ports are excluded.

Root passes the unchanged ordinary GPU suite (47), scalar Canvas/GPU suite
(273 passed, 3 ignored, 31 harnesses) and default/scalar strict checks. All 2,787
source/config guards match. The interrupted first strict wrapper has no final
result and remains incomplete; resumed strict gates pass on the unchanged source
and original bounds. Producer counts (47/254) retain their older source pin and
are not relabelled as the composed source. Original failed controls and one-ULP
test-assumption failure remain in the first-fix archive.

Matched same-path production controls charge +2,656 linked `.text` bytes and
+168 `.eh_frame` bytes, with unchanged rodata/data.rel.ro/exception tables.
The ordinary renderer's own frame is 1,496→1,320 bytes; paint-observed is
1,640→1,432. The checked helper remains 668 code bytes/frame 104; the shared
lattice kernel is 1,119 bytes/frame 0. These are per-function observations,
excluding callees and return address, not call-chain or latency bounds. The
additional group scan and up to 68 predicate probes per eligible draw are real
host work. No speed, hardware-GPU, RSS or general precision claim follows.

[The selected archive](qualification.tar.gz) is reopened and verified through
[its member ledger](archive-members.json). It contains raw Root gates and
producer source/cost/trace records; executable bytes and whole disassembly remain
in the separately hashed [first-fix](first-fix-original-seal.json) and
[borrowed](borrowed-original-seal.json) original archives.
[Luna's certified-seed research](lattice-inversion-research-luna.md) explores
removing search work while preserving the exact predicate and fallback. That
experiment is separate and is not included in this adoption. The subsequent
[matched linked checkpoint](certified-seed-linked-cost.json) holds that seed:
its production lowerer grows 1,119→2,207 code bytes and its proven geometry
subchain grows 160→288 stack bytes. Whole `.text` grows 1,088 bytes, shaders
remain equal, and fewer probes do not establish a speed win. The initial
missing offline dependency failure and all actual ELF/assembly evidence remain
in [the original sealed archive](certified-seed-original-seal.json). These costs
attach to `e872330f30`/`ae1618396c`, not a new execution of Main.

General glyph/image/shear precision, hardware/backend conformance, native HDR,
legacy DX and persistent GPU damage repair remain. Apple/MSVC compile checks and
offline SPIR-V tests attach to the original first-fix source, not a new execution
of this composition.
