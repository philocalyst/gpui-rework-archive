# Variable-width Figma inner-border gradient experiment

This standalone calculation checks the curvature correction for the smoothed-quad field
`inner = -(outer + effective_width(normal))`. The source is [experiment.mjs](experiment.mjs),
and its raw output is [output.txt](output.txt). Run it with `node experiment.mjs`.

For an outward-positive Euclidean signed-distance field with unit contour normal `n`, the
normal field has Hessian

```text
H = κ / (1 + κ d) * (I - n nᵀ)
```

where `d` is signed distance and `κ` is positive curvature for a convex contour. For
`w(n) = |b ⊙ n| - 0.5 * (1 - |a ⊙ n|)`,

```text
∇ₙ w = (b² ⊙ n) / |b ⊙ n| + 0.5 * (a² ⊙ n) / |a ⊙ n|
∇ inner = -(n + H ∇ₙ w)
```

An active-side term is zero when its norm denominator is zero. The result is a local-space
scalar gradient; map it to screen axes by dotting it with the two local-pixel basis vectors.

The experiment retains a generic reference fixture `b = (3, 1), a = (1, 0)` and adds three
production width/active-side pairs: `(3, 1)/(1, 1)`, `(3, 0)/(1, 0)`, and `(0, 2)/(0, 1)`.
Each production pair is checked across four mirrored normal quadrants, five smooth curve
parameters, and three signed offsets: 60 finite-difference samples per pair. The generic
fixture has 15 samples. Each quadrant also gets one projected comparison through the
strong-shear fixture inverse. The experiment uses central finite differences with step `1e-5`.
The maximum local gradient error is `6.504e-10` for the generic fixture and `6.196e-10` for
the production fixtures. The largest strong-shear screen-gradient error across all fixtures is
`2.760e-9`.

Assumptions and limits: the contour is smooth, convex, and locally represented by a Euclidean
nearest-point sample; curvature is positive under the outward-normal convention. The four
quadrants reflect both the cubic and query point consistently, so the returned signed normal
changes sign with the contour. The formula is invalid at the medial axis, at segment-selection
discontinuities, and at focal offsets where `1 + κd` approaches zero. The current Figma corner
curves are convex; straight segments use `κ = 0`, arcs use `κ = 1 / radius`, and cubic segments
use `|cross(P′, P″)| / |P′|³`. This check does not cover zero-width denominators or nonsmooth
joins, which need guarded fallback handling in shader code.
