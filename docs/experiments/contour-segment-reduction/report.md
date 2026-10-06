# Four-lane contour reduction

Luna modeled the scalar top/right/bottom/left edge scan from `f1eb725c7c`
and a four-lane reduction. Run `node experiment.mjs` in this directory;
[source](experiment.mjs) and [raw output](output.txt) are preserved together.
The root rerun on Node.js 24.19.0 reproduced the raw output byte for byte.

Each arithmetic operation rounds to f32. The comparison checks selected edge,
squared distance, delta, normal and signed-distance bits. The deterministic
seed `0x6d2b79f5` produced 250,000 finite-input cases; every eighth case uses
broad exponents, including squared-distance overflow. Eight explicit fixtures
cover ties, zero size, collapsed segments, overlapping reaches and negative
extents. All comparisons matched exactly.

The production formulation clamps all four segment projections together and
selects the first minimum, preserving the scalar scan's strict-`<` tie rule.
The shader test checks known ties and collapsed/overlapping reaches directly.
This model does not prove bit equality after GPU arithmetic contraction or
establish performance: GPU validation and measurements are recorded separately
in [the benchmark notes](../../element-transform-benchmarks.md).
