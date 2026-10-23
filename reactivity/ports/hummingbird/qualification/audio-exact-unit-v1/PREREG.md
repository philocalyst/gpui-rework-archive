# Audio structural simplification preregistration

Prepared before any probe timings or root quiet-window grant. Source: isolated
Hummingbird audio worktree, base ecfaddd3cffa07d09510faa7b194c1bea1c123cf.
The root owner must grant the quiet window before the executable is invoked.
Ordinary optimized release, one build job, no target-cpu/native RUSTFLAGS.

The standalone /tmp binary imports production pipeline, FFT, timing and block
source by absolute #[path], unchanged. Its Format/Token/AudioError definitions
are extracted unchanged from production audio/mod.rs. Queue/Track/PlanStamp
come from the real port library. The baseline is git HEAD's original fixed-input
pipeline source. Same token/input blocks/rates/channel mapping/acceptance for
both; incumbent FFT input/output units and delay must match before timing.
This profiles actual pipeline work. Decoder, transport, CPAL, UI and OS devices
are outside the timed scope, so it cannot establish full-player performance.

Frozen cohorts, in executable order:

0-2: 44100 -> 48000, (source/output channels) 1/1, 2/2, 2/1.
3-5: 48000 -> 44100, same three layouts.
6-8: 8000 -> 48000, same layouts.
9-11: 192000 -> 44100, same layouts.
12-14: 768000 -> 44100, same layouts.
15-17: 81920 -> 78750, same layouts (adversarial large admitted FFT units).
18-20: 48000 -> 48000, same layouts (direct mapping, no FFT).
21: 44100 -> 48000 stereo, 31-frame acceptance/backpressure bookkeeping.
22: 81920 -> 78750 stereo, 31-frame acceptance/backpressure bookkeeping.
23: 11025 -> 44100 stereo, separately labeled changed geometry.
24: 44100 -> 11025 stereo, separately labeled changed geometry.

0-22 use identical incumbent FFT units/filter/delay. 23-24 previously used
packet-rounding-prime units; the new bounded smooth admission uses a different
filter/delay. Report them separately and do not count changed filter output as
an incumbent performance or memory win. All ordinary rate geometry and exact
sample equality are already independently tested before this probe.

Run processing cohorts and constructor cohorts separately. Processing excludes
constructor/destructor timing, creates each owner before the timer, processes
25 reusable nonzero 20 ms packets per set (last packet one frame short), and
repeats whole sets to reach at least 1,048,576 input frames. It finishes exact
resampler tail inside the timer and checks equal submitted output-frame counts
for every matched-geometry cohort. Constructor cohorts include construction and
retirement, with 100 operations per timed batch. No global preallocated plan
cache is shared between owner constructions.

One untimed run per version/cohort warms linked code and allocator. Record 13
paired samples per cohort, alternating AB/BA order. Preserve every raw sample.
Report per-cohort median old/new time and ratio, plus all paired ratios. No
aggregate throughput score may hide a slower cohort. Any incumbent cohort with
candidate median above baseline must be repeated with 31 pairs in a separately
identified pass; classify a slowdown only when it repeats under the same
conditions rather than discarding outliers or silently changing sample counts.
A reproducible incumbent slowdown is a failing gate requiring work before
adoption. Newly changed geometry remains separately labeled regardless of speed.
Timing evidence does not replace independent sample, allocation, balanced
retirement, source freeze and linked assembly controls.

Commands after the root grant:
  /tmp/gpui-hummingbird-audio-target/release/hummingbird-audio-probe 0 25 13
  /tmp/gpui-hummingbird-audio-target/release/hummingbird-audio-probe 0 25 13 constructor

Classification note required by root immediately before capture: report every
cohort's paired ratios and 95% interval. A repeated slower incumbent fails;
inconclusive comparisons remain unresolved rather than passing from absence of
significance. No aggregate offset. Keep the preregistered 13/31 repeat rule.
Intervals will use a deterministic paired bootstrap of the median paired ratio
(10,000 resamples, 2.5/97.5 percentiles); retain raw values and seeds.
