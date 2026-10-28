# Actual native mask-path coverage: diagnostic preregistration

Both mask-address and four-cell screens are rejected(b8e6667b,58da795d).
Four-cell stream CPU.955163432 still fails the20% target; mixed has one late
gap and suppresses its ratio. Before another optimization, measure which paths
the real native workload actually selects. No timings, performance comparisons
or acceptance-threshold changes in this diagnostic.

Base7565d788. Add isolated diagnostic-only logging after successful packet
preparation when GPUI_MASK_DIAGNOSTIC is set. Preserve shader bytes, workload
example, publication and submitted records unchanged. Count actual paint-bank
size/packet banked tag, mask/unit-axis/one-to-one-dimension placements and actual
uploaded LOWERED_MASK bits through surviving nonuniform CSR references. Weight
references by tile pixels to give planned full-packet sample counts, not actual
GPU instruction counts or damage-cropped work. This is instrumented execution;
logging overhead cannot be interpreted as application performance.

Fresh target, same native opt3/fatLTO/CGU1 profile and17 workload tests. Freeze
source and runner before8 processes:idle/scroll/stream/both,initial0/190,3s each,
normal ingress and trace,960x720,same font,X11:94,llvmpipe4threads. Capture both
idle states and compare exactly with the uninstrumented four-cell native
preflight images. Retain all processes; assert normal exit,geometry/font,
monotone counters,counts bounded by totals and planned sample sums agree with
existing Stats. Actual cadence is descriptive only; this is not a timed screen.
Verify generated+embedded WGSL identity and source/artifact guards. Keep8GiB
reserve; preserve evidence and failures. No production adoption or ZGX/hardware
claim. A subsequent optimization needs a separate preregistration and fixed
complete gates; do not relabel earlier failed screens as successes.
