# Public service clock qualification

Written before any candidate scheduled capture. The independent pipeline v2
microbenchmark campaign remains on HOLD; no timing result from it is implied.

The control is the frozen nearest-smooth pipeline plus the original service's
unconditional 2 ms park after every unit. The actual public service receives a
real nonzero WAV through Symphonia, queue intents, the media worker, pipeline,
events and output-provider seam. Only the device sink is scheduled by the test.
The source, test and release binary are preserved under
`/tmp/gpui-hummingbird-audio-evidence/sol-clock-baseline`. Its release binary
SHA-256 is `e5cc8caf0eafbb198b3d1815a3db4467d3ef8b4bf63d66e6d3b889c10517f6c5`.

The baseline was captured in Root's exclusive quiet window. With the fixed
100 ms prebuffer, the first 768000 -> 48000 cohort missed 5328 frames over 25
scheduled 10 ms consumption deadlines and failed the zero-starvation assertion.
The unmodified test stopped at that first failure; the later baseline cohorts
are not measured. Preserve this failure, rather than modifying the control.

The candidate makes `Owner::cycle` return an ephemeral progress flag. Only a
consumed reply, completed preparation, accepted PCM, advanced source offset,
issued media request, newly produced tail PCM or terminal transition earns an
immediate next turn. Every turn checks close/latest intent and delivers events.
Zero credits or blocked media retain the existing park behavior. No callback
wake syscall, persistent header, transport, worker or queue is added.

The public deadline test is identical between baseline and candidate. For each
of 768000 -> 48000, 768000 -> 96000, 384000 -> 48000, 48000 -> 44100,
44100 -> 48000 and 11025 -> 44100, prefill 100 ms, then consume a fixed 10 ms
callback amount at each of 25 absolute deadlines. Require exactly zero missing
frames. This gate covers the tested service and schedule; it is not hardware
playback or a universal latency bound.

Freeze the ordinary optimized release test binary and exact audio/test sources
before Root grants quiet capture. Run the following exact test 13 times, in
sequential fresh child processes, preserving every full result and exit status:

```
audio-clock-candidate clocked::scheduled_public_output_keeps_up_with_fixed_consumption_deadlines --ignored --exact --nocapture --test-threads=1
```

Every repetition must pass all six cohorts. Any failure is unresolved and must
remain visible; do not drop, rerun or aggregate it away. These are zero-missing-
frame deadline checks, not paired throughput ratios or confidence intervals.
Do not run other tests, builds, profilers or pipeline timings in that window.
Report DONE only after all 13 child processes exit, or after the first failure
terminates the campaign. Candidate source changes require a new freeze and GO.

Untimed qualification additionally drives the actual `Owner::cycle` under
virtual 1 ms consumption credits and requires each true flag to advance work,
three repeated blocked calls to remain unchanged and false, exact independent
Rubato delay/frame accounting, and complete drain. The separate public lifecycle
test accounts for every accepted frame through pause, seek, stop and tail drain.
Expanded real-codec seeks check the exact integer sample target: the faster
service exposed a pre-existing float-ceiling error at a packet boundary, fixed
using rational packet timestamps and integer millisecond targets.
