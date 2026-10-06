# Antialiasing in an affine coordinate space

Luna's prototype tested derivative-based coverage before settling on an analytic
formulation. The integrated implementation lives in
[common.rs](../crates/gpui_render/src/shaders/common.rs),
[corner_smoothing.rs](../crates/gpui_render/src/shaders/corner_smoothing.rs) and
their quad, sprite, underline, shadow and filter callers. It adds no GPU ABI field
or vertex varying. It uses the inverse matrix already cached for exact clipping.

## One pixel basis, one contour sample

For a local scalar contour `d(p)`, let `Jx` and `Jy` be the local displacements
corresponding to one device pixel along each screen axis. The inverse affine map
provides those columns exactly:

```text
screen_gradient = (dot(gradient(d), Jx), dot(gradient(d), Jy))
coverage = saturate(0.5 - d / max(length(screen_gradient), epsilon))
```

Identity linear mappings retain the original `saturate(0.5 - d)` path, including
translations. Nonidentity mappings keep the coverage ramp at a device pixel's
scale. This is a local gradient approximation, not exact integration of a curved
shape over a pixel; finite precision and nonsmooth contour joins remain limits.

`LocalPixelBasis` is shared by all scalar coverage calculations in a fragment.
`PreparedCornerSample` returns distance, its gradient, selected corner/segment,
path progress and curvature from one corner solve. Distance-only entry points
delegate to the sample. Circular corners retain their existing fast selection;
normalized superellipses keep the compact quadrant path when adjacent reaches
permit it. Figma corners reuse the nearest arc or cubic for border and dash work.

The gradient must differentiate the actual scalar approximation, including its
magnitude. Normalizing it would be wrong for the existing quarter-ellipse and
superellipse approximations. The superellipse uses the full quotient rule;
wavy underlines now compute distance and gradient together, including the
derivative of their slope-correction denominator.

## Curved variable-width borders

For a convex Euclidean contour with outward normal `n`, distance `d` and curvature
`k`, its normal-field Hessian is `k / (1 + k*d) * (I - n*nᵀ)`. Differentiating
the effective border width through that field gives the inner-border gradient.
`BorderWidthSample` retains both width and its derivative with respect to the
signed normal, so all four quadrants and absent border sides behave consistently.
Arcs use `k = 1/r`; cubics use `abs(cross(P', P'')) / length(P')³` at the selected
nearest point. At a focal or medial degeneracy the shader falls back to the normal
term instead of amplifying an invalid Hessian.

The [bounded finite-difference experiment](experiments/aa-variable-width-curvature/report.md)
records the derivation, executable source and raw output. It checks 15 generic
samples and 180 production-width samples across four reflected quadrants. Maximum
local error is approximately `7e-10` in double precision, and the largest strong
shear projection error is `2.76e-9`. That is a mathematical check under the report's stated
assumptions, not an exhaustive shader or nonsmooth-join proof.

Dash coverage uses the same pixel basis. A circle's angle-derived arclength has
gradient magnitude `radius / radial_distance`; the Figma nearest-point arclength
uses the corresponding `1 / (1 + k*d)` offset factor. The gradient's sign is
irrelevant to coverage, but its direction and magnitude are both necessary under
shear.

## Experiments that removed complexity

Scalar `dpdx(distance)`/`dpdy(distance)` was rejected: a finite pixel chord through
a nonlinear contour can disagree with the local gradient, producing incorrect
coverage under strong shear. Analytic gradients remove those fragment derivative
uniformity constraints and allow clipped fragments to exit before contour work.
Content-filter composites skip contour sampling when their clipping mode does
not require it. Ordinary solid underlines avoid wave calculations.

Borderless rounded quads apply outer coverage once. Sending them through the
border union introduced a synthetic half-pixel inner inset and darkened compressed
edges. Removing that path also removes needless inner-border calculations and the
former `BorderDistances` intermediate. The existing inherited-filter-fade
regression remains strict: content compositing rechecks hard clips without
multiplying fades already painted into the isolated children.

## Validation

The shader suite includes finite differences for superellipse gradients in every
quadrant, the ellipse approximation, signed variable-width border derivatives and
wavy underlines, plus a focal-point fallback. Generated WGSL validation and
native/downlevel ABI tests accompany these checks.

The headless affine edge test uses five matrices: identity translation, 4× zoom,
anisotropic scale/shear, strong shear/compression and an oblique mapping. It checks
the analytic one-pixel ramp on the straight section of a rounded borderless quad.
The large-origin clip test keeps geometry edges away from its own mask so its
exhaustive interior and AABB-phantom assertions isolate clip interpolation.

Final integrated test results and GPU measurements are recorded in
[the benchmark notes](element-transform-benchmarks.md).
