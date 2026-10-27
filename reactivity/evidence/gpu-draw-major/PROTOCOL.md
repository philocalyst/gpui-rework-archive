# Ordinary compositor draw-major evaluation: preregistration

Starting composition: 6d5e409d6b (unadopted retained GPU output, sparse text and
owned text cache; corrected public native lab fixture). Software-Vulkan native
diagnostics remain below the lab's tick gate. Investigate ordinary GPU shading
before further source-update micro-optimization. Those diagnostic runs are not
paired performance evidence and were not made with matched dist profiles.

The existing paint-banked shader decodes each draw once and retains sixteen
sample colors. Ordinary scenes instead iterate samples outside draws, repeatedly
decoding records. Experiment: reuse the existing draw-major implementation for
ordinary packets too. Preserve per-sample painter order and final anchor/delta
reduction order exactly. This trades record loads for register/local storage;
physical-GPU register pressure and losing scenes must not be hidden.

Before changing the shader, freeze an identical ordinary (unbanked) fixture in
both worktrees. Five paired processes, rotated AB/BA, 10 warm frames then 60
measured frames per flat, text, translucent-overlap, transformed-text and HDR
cell. Record every host-submit and submission-through-poll duration; capture
initial/full scene preparation separately. Keep raw outputs, pixel digests,
source/compiler/device/features/executable/shader receipts. Preserve failed runs.
No timing during compilers/tests. This isolates compositor work, not native
input-to-display latency. Native port quality and scheduling remain separate.

Admission: >=20% median GPU-completion wall improvement for ordinary text and
transformed text, <=5% regression in any other cell, no unexplained host or
memory growth. Noise is inconclusive. Full independent CPU/GPU SDR/HDR, clip,
image, precision, partial-tile and retained-output tests must pass unchanged.
A reversed-painter-order mutant must fail the exact overlap oracle. Verify the
generated WGSL matches the typed shader and is embedded in the actual binary.
No new unsafe or application API. Software Vulkan cannot qualify a global
hardware shader choice; two physical hardware classes remain required.
