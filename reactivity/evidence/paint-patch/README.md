# Paint substrate evidence

Source: `ab51133c84`; baseline: `f01947e679`. There was no timing campaign.
All builds used two Cargo jobs and the isolated `/tmp/gpui-paint-patch-target`.
`manifest.json` pins source, manifests/lock, artifacts and logs. New code is safe
Rust and adds no dependency or retained Canvas/ordinary Renderer fields.

Passing gates: 129 Canvas tests/docs (4 ignored measurements), 8 GPU units,
36 actual Vulkan cases and 1 GPU borrow compile-fail doc, strict Canvas/GPU
all-target Clippy with parallel/Vulkan features. Vulkan was Mesa llvmpipe;
this is actual backend correctness evidence, not hardware latency evidence.

The initial proof fixture assumed a final uniform tile when its partial upper
rectangle intersected every tile of a 32×32 scene. That assertion was wrong:
there was a prefix certificate but no final uniform tile. The retained failed
log is `initial-proof-fixture-failure.txt`. The corrected 64×64 fixture has
actual final uniform tiles and tests negative-zero/subnormal rejection in the
second edit, atomic preservation, and successful forced full rebuilding.
No production fix was needed for that fixture change.

Layout/allocation logs:

- Canvas 552 B; DisplayList 288 B, both unchanged.
- Plain Renderer 872 B, unchanged; opt-in PaintRenderer 896 B.
- Active Site 12 B; PaintIndex/PaintBinding 4 B each.
- Canvas PaintEdit 20 B; GpuPaintEdit 24 B; each borrowed guard 40 B.
- Optional map allocation is Vec capacity × 12 B; no map allocation until
  requested. The actual three-site fixture retains 36 B of entry capacity.
- Canvas plan validation/commit: 0 owner-thread allocations, 0 requested bytes.
- GPU queue/driver internal staging costs are not captured by that counter.

Optimized callee inspection used dev dependencies and compiled gpui_gpu itself
with `-C opt-level=3 -C debug-assertions=no --emit=asm`, no LTO. Ordinary
Renderer::render is 8,541 bytes and has no calls into the paint module; the empty
observer is specialized away. Opt-in PaintRenderer::render is 9,843 bytes plus a
410-byte capture helper. Its prepare_paint is 1,315 bytes and commit is 657 bytes.
These are actual library bodies, not a source-equivalent baseline size/timing
comparison. Separate specialization is a binary code-size cost when both paths
are linked. `ordinary-render.s`, its call list, and `callees.s` retain the emitted
code with only location/CFI/debug temporary labels removed.

Each three-group patch uploads 48 color bytes, with zero validated draws,
zero bin visits, zero mask uploads and zero binding creations. It still clears
and samples the full target. Tests queue A→patch-B→patch-C without any intermediate
poll/readback, then compare each frame byte-for-byte with ordinary full rebuilds
in SDR/HDR. Canvas tests also compare full pixels across P3/HDR/masks and prove
outside-damage pixels remain unchanged in a preserved external image.

See `docs/paint-patch.md` for transactional authority, positional key limitations,
the support proof, GPU proof-class eligibility and pending GPUI/native coupling.
