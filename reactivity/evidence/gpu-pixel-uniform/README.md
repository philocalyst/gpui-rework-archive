# Pixel-uniform SDR coverage: rejected on flat-frame regression

Candidate f813187f98c4428f64567b702b4fa425d79fdbb8 against control
a0684a2b3498821129453c8c929ecf6c5f6ba810, both based on 6d5e409d6b.
No application API changes. Integer-aligned solid geometry can have identical
coverage for all sixteen samples in each pixel even when a tile crosses two
colors. After ordinary lowering, a packet certificate allows one painter-order
composition per pixel. Nonqualifying tiles keep the original sampling path.

Five AB/BA process pairs, 10 warmup and 60 measured redraws per cell, 960x720,
llvmpipe LLVM20/Mesa25.2.8 Vulkan, LP_NUM_THREADS=4, pinned nightly2026-10-23,
default release. Complete initial/final SDR/HDR readbacks match byte-for-byte.
Ratios below are paired medians of process p50 completion-through-poll:

| Cell | Candidate/control | Result |
| --- | ---: | --- |
| Flat | 1.1661 | 16.6% slower; fails <=5% regression gate |
| Integer stripes | 0.1201 | 8.33x faster |
| Text on stripes | 0.6981 | 30.2% less time |
| Quarter-offset stripes | 1.0096 | 1.0% slower, broad range |
| HDR stripes | 0.9760 | 2.4% less time, broad range |

The target cells clear the >=20% improvement gate but the complete candidate
is rejected. No noisy losing runs were removed. Flat uses zero new certificates;
shader code-generation/pipeline interference is a hypothesis for a later
separate experiment, not an established explanation or waived gate. Host timing,
all tails, cold setup/preparation, Stats and max RSS remain in raw/paired.
This is steady packet redraw, not a complete application frame or scanout test.

The initial prototype bf1687a328 failed the unchanged exact HDR negative-zero
oracle. Before any timing, eligibility was narrowed to SDR; HDR remains the
original fallback. raw/candidate preserves that failure, raw/sdr-only the first
corrected tests, and raw/qualified the final metric-reset candidate's 60 GPU
integration plus 10 unit passes and strict Clippy. New checks count validation
only when actually run; packet replay resets their work count to zero.

The fractional-edge mutant removes only integer-endpoint admission. It fails
with white [255,255,255,255] versus [255,187,187,255], proving the certificate
cannot accept fractional edges. It was built from the pre-SDR-restriction
prototype and exercised an SDR case; it is not a purported final-source rerun.
Source guards, generated WGSL hashes and exact embedded binary checks are kept.
Raw images are losslessly gzip-compressed; verify.py decompresses and checks all
3000 samples and full pixel parity. No new per-draw buffer or retained cache was
introduced. Shipping line inventory and shader/ELF sizes are preserved separately.

The typed shader and original per-sample oracle remain available. No physical
GPU or two-hardware-class claim; native output/typography parity still incomplete.
