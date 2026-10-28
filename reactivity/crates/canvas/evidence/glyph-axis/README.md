# Exact separable glyph addresses

The public `parallel` example is unchanged. Baseline source is
`62f68419395bc501ffc8e781f306dd74c7d9cbda`; candidate production source is
`0a16952cf3539c874a00a5db60b9feae9138ea9b`. Later commit `f43c068527`
adds only the narrower-bin/signed-zero oracle. Both binaries use the preceding
Rustybuzz text planner; this isolates raster changes and does not measure the
subsequent integrated Unicode planner or style lane.

`measurements.json` pins executable SHA-256 values, affinity and every median.
`paired.csv` retains all 500 timed rows: five fresh-process repetitions of two
algorithms, two formats, five scenes and serial/1/2/4/8-worker execution.
Each executable reports the median of seven warm batches. Algorithm order
alternates by repetition. Explicit team builds and other captures were stopped.
This is a Ryzen 7 3700X / Rust 1.97.1 Linux observation, with warm OS caches.
The recorded process affinity allows all 16 logical CPUs; pools may use them.

The script checks algorithm activation before timing: the label fixture must
report 1,846,272 geometric queries for the baseline and 126,744 for the
candidate, for every worker count. Those untimed probes are the two
`*-activation.csv` files. Every timed process rechecks its executable hash.
All scene/profile/worker digests, command counts, bin references and retained
output/command/bin/mask capacities agree between algorithms. Digests are a
fixture check, not a universal collision-free pixel proof; the independent
scalar oracle compares all 16 coverage values by their f32 bits.

The initial 500-row capture is preserved under `invalid-baseline/`. Its purported
saved baseline was copied after a candidate rebuild and ran the same optimized
algorithm. Its timings establish no change. This was caught by the activation
counters before adopting or reporting a result. The corrected baseline was
built from its pinned commit in `/root/gpui-glyph-baseline`, with a separate
`/tmp/gpui-glyph-baseline-target` Cargo target. Candidate artifacts use
`/tmp/gpui-axis-target`; neither compared source tree is mutated during capture.

To reproduce on this configured host, build the `parallel` example with
`--locked --offline --release -p gpui_canvas --features parallel` in each pinned
tree using those separate target directories, then run `measure.py`. Its paths
and activation constants intentionally describe this exact fixture.

Font and pool creation are outside the measured preparation+raster loop. Native
upload, event scheduling, accessibility projection, compositor and scanout are
not measured. Every losing cell remains in the JSON and CSV; see the discussion
in [sample storage](../../SAMPLE_STORAGE.md).
