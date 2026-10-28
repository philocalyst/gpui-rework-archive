# Native CPU thread attribution

Preregistered follow-up to native-profile dossier a7fbf5e2fe5807d1eb87021918d210e9d65a693e.
That fixed72-process matrix remains complete with36 GPUI cadence failures. This
new diagnostic does not repeat or replace its performance gate. It asks where
the measured CPU work executes before choosing a new architectural optimization.

Use the exact three preserved fat-LTO native ELFs from that dossier, original
source pins and native environment. No code, feature, shader, application API,
presentation policy or input policy changes. The isolated target is intentionally
unused: no recompilation. Verify source-family and executable identities. Keep
all observations local and do not run other tests/builds/native scripts during
the diagnostic. No physical GPU or scanout claim is possible on this machine.

Run stream,scroll,both, six seconds each. Three groups per mode, cyclic Latin
orders (control,sparse,zgx), (sparse,zgx,control), (zgx,control,sparse); shuffle
groups with seed20261102.27 fresh processes, no selective reruns. Sample process
and every live task's /proc stat at50ms. Identify main thread byTID==PID, raster
workers by the actual llvmpipe thread-name prefix, and retain all other names.
Identify a task byTID and creation time to avoid assigning recycled IDs its CPU.

Use the approximately three-second interval visible+1s through +4s. Keep all raw
per-task observations and total process CPU. Sum nonnegative per-task CPU advances
between samples, including newly observed tasks from zero; report disappeared
tasks and process-minus-task residual without hiding quantization/sampling loss.
Report main, named raster and other thread CPU separately. Do not call all other
CPU UI work or infer a source stack from a thread name. Tick/ACK counts are context,
not a per-frame cost denominator. No numerical adoption gate or framework ranking.

Capture /proc maps once after visibility to bind the actual loaded driver modules
to their file hashes. Preserve present-policy source: GPUI FIFO/latency1; ZGX
AutoVsync/default latency2 on Linux. Those settings are unchanged. Thread CPU can
distinguish busy raster work from UI execution, but cannot measure blocked acquire
time or establish why a deadline was missed. No no-op waker or general coroutine
executor follows from this evidence alone.
