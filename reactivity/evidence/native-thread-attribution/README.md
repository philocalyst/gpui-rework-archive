# Native thread attribution — raster work dominates this VM

Preregistered f99d4da21c0dd7f72cfb62a4de98ede952771c0a after native-profile
report a7fbf5e2fe5807d1eb87021918d210e9d65a693e.27 fresh processes, three active
modes, three cyclic orders per mode, six-second lifetime, seed20261102. All
processes and observation harnesses complete normally. These are attribution
observations, not repeated attempts to pass the earlier cadence gate. That
72-process matrix and all36 GPUI cadence failures remain unchanged.

Exact same three fat-LTO native executables, sources, defaults and software Vulkan
environment. No new compilation or production code/API changes; the isolated
build target is intentionally unused. All three source families match their
frozen production inputs. Script/driver/executable identities remain unchanged.

Median observed CPU cores in the approximately three-second interval from
visible+1s to +4s, sampled every50ms:

| Mode | App | Main thread | Named llvmpipe workers | Other threads | Whole process |
| --- | --- | ---: | ---: | ---: | ---: |
| stream | baseline | .0442 | 3.6126 | .0238 | 3.6807 |
| stream | sparse | .0579 | .4873 | .0307 | .5724 |
| stream | ZGX | .0237 | .0541 | .0439 | .1218 |
| scroll | baseline | .0239 | 3.8099 | .0170 | 3.8543 |
| scroll | sparse | .0272 | 3.7924 | .0170 | 3.8469 |
| scroll | ZGX | .0237 | .0135 | .0506 | .0879 |
| both | baseline | .0204 | 3.8519 | .0136 | 3.8887 |
| both | sparse | .0205 | 3.8562 | .0102 | 3.8936 |
| both | ZGX | .0304 | .0676 | .0541 | .1488 |

Columns are medians separately and need not add to the whole-process median.
Task identity includes TID and creation time. Main is identified byTID==PID;
only actual llvmpipe-* names are classified as raster workers. All other names,
creation/disappearance records and CPU counters are preserved. Other CPU is not
assumed UI work. Sampling and OS-tick quantization produce process-minus-task
residuals of about -0.02 to +0.04 CPU seconds per interval; they remain reported.
Loaded driver module paths and hashes are taken from actual process maps.

The evidence confines the next optimization: almost all observed scroll/mixed CPU
executes in software raster workers. Improving main-thread traversal alone cannot
remove that CPU work. This does not measure hardware GPU behavior, shader source
stacks, memory stalls, cache hits or blocked surface acquisition. GPUI FIFO/latency1
and ZGX AutoVsync/default latency2 stay unchanged. No presentation or render-quality
equivalence is newly claimed; initial cross-renderer glyph appearance differs.

A plausible next experiment is batching certified disjoint repair rectangles into
one draw while preserving the existing fragment computation. Current regional
submission issues a separate full-screen draw/scissor for each rectangle. A small
vertex instance stream could select identical integer pixel coverage in one draw.
This is an unimplemented hypothesis: thread attribution does not prove command
count is the bottleneck. It needs exact pixel/format/edge/admission/device-lifetime
checks, a missing-region mutant, charged cold pipeline/upload/storage costs and
complete cost controls. Mixed scroll+text remains a separate certificate problem;
a text-only batch cannot be presented as solving it.

BBTree's independent-operation batching and preservation of valid structural
facts motivate this experiment; Solid/Ripple motivate preserving precise update
identity through publication. No generic async executor, unsafe window ownership,
new dependency or changed application model follows. Keep all changes local.
