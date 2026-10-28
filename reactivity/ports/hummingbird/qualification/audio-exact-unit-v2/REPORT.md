# Bounded nearest-smooth successor

This is functional/resource qualification only. No v2 processing or constructor
timing has run. The preregistered v2 timing campaign remains on HOLD, and the
v1 changed-filter constructor regression is not declared resolved.

Keep an already-smooth requested multiplier. Otherwise choose the least
7-smooth multiplier at or above the request if one fits; if none fits, choose
the largest legal multiplier. The existing 16384-frame and 100 ms bounds remain.
This replaces binary padding with two bounded integer searches; it adds no
planner, backend or retained state.

| Rate pair | Legacy input/output; delay | v1 binary input/output; delay | v2 input/output; delay |
|---|---|---|---|
| 11025 -> 44100 | 221/884; 442 | 256/1024; 512 | 224/896; 448 |
| 44100 -> 11025 | 296/74; 37 | 512/128; 64 | 300/75; 37 |
| 11025 -> 768000 | 294/20480; 10240 | 147/10240; 5120 | 147/10240; 5120 |

The first two legacy units inherit prime factors from a rounded 20 ms decoder
packet; the bounded exact processor admits only 7-smooth units. The third
exceeds the explicit output frame cap. These changes affect the filter even
where integer delay matches. They are not matched-quality performance wins.
`ordinary-geometry-matrix.csv` is arithmetic, not timing or quality evidence:
232 ordinary pairs preserve legacy units, 17 pass through, 39 change because
of packet-rounding factors and one changes because of the cap.

Before service scheduling work, 25 private and 16 public tests passed. The
582 whole-pipeline constructor cases require both retained and peak requested
bytes no larger than faithful legacy FixedInput owners, plus balanced
retirement. The 800 smooth marginal core cases enforce the same bounds and
retirement; 160000 structured pair cases check allocation-free exact-ratio
admission. These controls passed again in the later service suite. The
44100 -> 11025 stereo pipeline retains 33376 requested bytes versus 74842 for
the legacy owners. This is not a whole-process or universal 16 MiB envelope.

Frozen v2 source, manifests, probe and binary:
`/tmp/gpui-hummingbird-audio-evidence/sol-nearest-freeze`. Its `sha256.txt` hash is
`7852699a034a22b4f5db11946e0a1afa288c3ddbaa03791cf9c8eeaab25759f7`.
Functional logs: `/tmp/gpui-audio-sol-nearest-final-gates.log` and
`/tmp/gpui-audio-sol-nearest-smooth-gates.log`. The explicit changed 300/75
sample-oracle extension is a separate test-only successor after the frozen
public-service clock capture; see `../audio-progress-clock/REPORT.md`.

The subsequent actual-service clock control found that the original scheduling
could not sustain 256/16 units at 768000 -> 48000. Pipeline-only measurements
therefore cannot establish usable service throughput. Its progress-driven
successor and separately scoped deadline qualification are recorded there.
Arbitrary rational rate coverage remains incomplete: reduced prime factors or
a GCD-reduced unit beyond the cap need a separate formulation.
