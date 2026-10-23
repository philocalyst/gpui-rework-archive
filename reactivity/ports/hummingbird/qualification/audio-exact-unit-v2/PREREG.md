# Nearest smooth audio successor preregistration

Written before any v2 timings or root quiet GO. The v1 candidate and evidence
are committed as 5cebe30308 in the isolated audio worktree, with frozen binary
and source under /tmp/gpui-hummingbird-audio-evidence/sol-freeze. The successor
changes only geometry selection: retain every already-smooth requested unit;
otherwise select the least 7-smooth multiplier at/above target if it fits, or
the largest legal multiplier at/below bound. Unit cap 16384 and 100 ms remain.
Actual planning remains one exact-unit RealFFT processor, with no fallback
backend, additional mode or new CPU-target flags.

The standalone /tmp binary loads the unchanged current pipeline, FFT, timing
and block files via #[path], plus unchanged Format/Token/AudioError definitions
and real port Queue/Track/PlanStamp. The baseline file is the original pre-slice
HEAD pipeline from ecfaddd3cffa07d09510faa7b194c1bea1c123cf; its hash must equal
v1 baseline799116196ebd4b54a046878ae4e85a66223c4bb17fee1f9e0b67a82900813aa3.
It is not reconstructed from current HEAD. No baseline fixes are permitted.
Builds must complete and exact source/probe/binary fingerprints must be frozen
before root grants timing. Ordinary optimized release, build jobs 1; no native
CPU flags. No source changes during capture.

Frozen cohort numbering is identical to v1:
0-2: 44100->48000, (source/output channels)1/1, 2/2, 2/1.
3-5: 48000->44100, same layouts.
6-8: 8000->48000, same layouts.
9-11: 192000->44100, same layouts.
12-14: 768000->44100, same layouts.
15-17: 81920->78750, same layouts.
18-20: 48000->48000, same layouts.
21: 44100->48000 stereo, 31-frame acceptance.
22: 81920->78750 stereo, 31-frame acceptance.
23: 11025->44100 stereo, changed filter 224/896, delay 448;
    original 221/884, delay 442; v1 binary 256/1024, delay 512.
24: 44100->11025 stereo, changed filter 300/75, delay 37;
    original 296/74, delay 37; v1 binary 512/128, delay 64.

0-22 must still assert identical incumbent FFT units and delay before timing.
Known-broken processing 15-17/22 are explicitly unresolved and WILL NOT RUN:
the untouched baseline failed its v1 warmup with Decode("resampler made no
tail progress"). Preserve that failure; no new reference repair, input-length
change or processing rerun for these cohorts. The actual 40974-frame pathological
candidate tail has an independent pinned-Rubato full-pipeline sample oracle.
All 25 constructor cohorts run, including the four pathological ones. Processing
23-24 remains separately labeled changed filter regardless of time or delay;
a different filter cannot be counted as an incumbent performance win.

Processing excludes construction/retirement, uses 25 reusable nonzero 20 ms packets
(last one frame short), repeats sets to at least 1,048,576 source frames, includes
final tail in timer and checks equal output frame counts for matched geometry.
Constructors measure 100 construction+retirement operations per sample. Same
inputs/token/channel mapping/acceptance for each pair. The scope is pipeline
work; decoder/transport/CPAL/device/UI/OS are excluded. No complete-player claim.

One untimed warmup per version/cohort. Record 13 paired AB/BA samples per cohort,
alternating order. Preserve every raw duration/output frame count/paired ratio.
Report each cohort separately with median times, all paired ratios and95%
percentile bootstrap interval of median paired ratio (10,000 resamples, xorshift32
seed 0x183b294d + cohort + (constructor ? 1000 : 0)). Never use an aggregate to hide a
regression. Any incumbent with slower candidate median repeats 31 pairs in a
separate identified capture. A repeated slower incumbent fails. Inconclusive
comparisons remain unresolved, not passing from absence of significance. No
silent outlier deletion or sample count changes. For changed filter 23/24, also
report any slower constructor prominently rather than offsetting with throughput.

After root GO, run these commands sequentially, retaining separate full logs:
/tmp/gpui-hummingbird-audio-target/release/hummingbird-audio-probe-v2 0 15 13
/tmp/gpui-hummingbird-audio-target/release/hummingbird-audio-probe-v2 18 22 13
/tmp/gpui-hummingbird-audio-target/release/hummingbird-audio-probe-v2 23 25 13
/tmp/gpui-hummingbird-audio-target/release/hummingbird-audio-probe-v2 0 25 13 constructor
