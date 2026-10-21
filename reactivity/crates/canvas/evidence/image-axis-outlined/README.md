Outlined image-dispatch follow-up
==================================

Implementation `d4d9293f58` follows the exact axis implementation `7be2c33185`.
The original 7be2 dataset remains untouched at `../image-axis`; its +7.61%
solid and +3.99% generic-shear medians are retained. This follow-up moves the
entire image-only decode/axis/generic dispatch behind one outlined call.
It changes no coordinate, filter, color, lease or sample-blending policy.
No more implementation variants or hint tuning were used for this capture.

Actual linked common `render_output<Serial>` shrinks 0x6a14→0x6738 bytes:
732 bytes smaller than 7be2, and 12 bytes smaller than baseline 724's 0x6744.
Its local stack returns to baseline 73,208 bytes (excluding 48 bytes of pushes).
The image-only dispatcher has 157 code bytes and 56 local stack bytes; its
memo branch tail-calls the existing decoder wrapper. The full linked
benchmark's aggregate text/data/bss grows 12,272 bytes versus baseline,
including all section/padding costs. Source introduces no new owner fields,
static cache or resource-payload expansion. See `codegen.json` for linked
prologues and exact section totals. This static boundary improvement did not
eliminate the measured solid-render loss.

Protocol is byte-identical to the first campaign: baseline 724 versus final
d4d929, five alternating fresh-process pairs over 14 controls, pinned CPU 2,
nine frames/process with frames 2–8 contributing 35 warm observations per
variant/case. All 1,260 raw rows (including cold rows) and 980 warm samples
pass executable/source hashes, linked activation, exact framebuffer digest,
unchanged scene retained/peak requested bytes and zero warm allocations.
The first campaign's data is never pooled with this campaign.

| Control | Baseline p50 ms | Outlined p50 ms | Paired median change |
| --- | ---: | ---: | ---: |
| flat | 0.0664 | 0.0704 | +5.08% |
| one | 46.5008 | 6.2732 | -86.08% |
| shared48 | 70.1226 | 22.7813 | -67.59% |
| unique48 | 66.5450 | 22.7681 | -65.56% |
| p3 | 33.9546 | 7.2558 | -78.64% |
| premul | 33.9775 | 7.2520 | -78.61% |
| hdr | 31.9245 | 4.8493 | -84.82% |
| nearest | 19.9100 | 3.1853 | -83.99% |
| shear | 36.4592 | 36.1930 | -0.84% |
| reflected | 34.5122 | 5.1602 | -85.00% |
| tiny | 0.0576 | 0.0585 | +1.70% |
| p3-48 | 175.3127 | 138.5852 | -20.77% |
| premul-48 | 162.7450 | 131.7792 | -19.67% |
| hdr-48 | 47.0618 | 13.2910 | -71.73% |

Recommendation: adopt the exact axis implementation with this small outlined
boundary, while retaining the explicit flat/tiny regressions. The common
image controls improve roughly 3–7× without decoded-image residency. The
solid case is still consistently slower (+4.64%..+6.09% across five pairs,
median +5.08%, about 4µs at this resolution). The tiny control also loses
(+1.34%..+2.63%, median +1.70%, about 0.9µs). The generic shear median is −0.84%
with a wide −8.86%..+7.82% range; this is no confident shear improvement.
P3/premultiplied minification remains expensive (139/132ms), despite 20.8%/
19.7% paired improvements. No GPU throughput, all-app latency, native PSS or
universal image-free latency claim follows from these CPU controls.

Exact per-sample oracles and the unchanged generic path remain the correctness
boundary. The release Canvas unit/public image suite, strict parallel all-target
Clippy and all 23 actual Vulkan tests pass for this dispatcher source. Final
native and borrowed-owner logs are included separately. GPU policies and
existing ≤1-byte SDR / relative-HDR tolerances are unchanged. Tail estimates
from 35 warm observations are limited; p99 is the maximum. Scene construction
allocation figures exclude the same caller output/oracle buffers on both
sides, and stack/code bytes are accounted separately.
