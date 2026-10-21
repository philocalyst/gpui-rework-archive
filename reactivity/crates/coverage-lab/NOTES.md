# Conservative coverage proofs as work elimination

This is a scalar, dependency-free, safe Rust supporting experiment. It keeps a
clear all-pixel/all-shape reference, then proves which geometric/compositing work
can be omitted. It is not a renderer backend, a new adopted core matrix API, a
complete path rasterizer, or an SDF atlas implementation.

The inspiration from [Ben Joffe's weekday derivation](https://www.benjoffe.com/fast-day-of-week)
is methodological: state a domain, reformulate the computation around an
invariant, prove the reduced operation set, validate against a reference, and
measure the losing cases. No weekday arithmetic trick is reused. Here the two
invariants are Lipschitz coverage bounds and the absorbing effect of an opaque
source-over operation over its full footprint.

## 1. Geometry and primary derivation

Local shapes are centered at the origin. The exact mathematical signed distances
are:

```text
circle radius r: d(p) = sqrt(px² + py²) - r
box half-extents h:
    q = abs(p) - h
    d(p) = length(max(q, 0)) + min(max(qx, qy), 0)
```

Both functions are 1-Lipschitz in local Euclidean coordinates. The circle result
follows from the reverse triangle inequality. For a box, the expression is the
Euclidean distance to the closed box outside it and the negative nearest-boundary
distance inside it. Distances on either side are 1-Lipschitz; for points on
opposite sides, the segment between them crosses the boundary, and the sum of
their distances to that crossing bounds their signed-distance difference by the
segment length. This establishes the global bound, including edges/corners.

For the forward affine map `w = A p + t`, let `M = A^-1` and
`F(w) = d(M(w-t))`. This composition is generally **not** a world-space signed
distance under nonuniform scale/shear, but:

```text
|F(w1) - F(w2)| <= ||M||₂ |w1-w2|
||M||₂ <= sqrt(||M||₁ ||M||∞) = L
```

The second inequality follows because the spectral radius of `MᵀM` is bounded
by its induced infinity norm, and induced norms are submultiplicative:
`||MᵀM||∞ <= ||Mᵀ||∞ ||M||∞ = ||M||₁ ||M||∞`.
This bound is sharp for diagonal/identity maps and conservative for general
rotation/shear. It is computed once for the Space, not sampled again from a
transformed distance texture.

For a closed axis-aligned tile Q, with exact center c and half extents hx,hy:

```text
R = sqrt(hx² + hy²)
for every w in Q: F(w) in F(c) + [-L R, +L R]
```

If the outward interval's lower endpoint is strictly positive, Q is certainly
Outside. If its upper endpoint is strictly negative, Q is certainly Inside.
Otherwise Q is Boundary. Strict comparisons deliberately do not certify a tile
that only touches an edge. Scalar local geometry and the per-instance Space are
the canonical retained representation; transforms do not require a resampled field.

## 2. Floating point and admission contract

The proof uses interval enclosures of the exact real operations on the supplied
binary64 inputs. It does not assume that a heuristic center epsilon is enough.

* Basic addition/multiplication/reciprocal operations widen their rounded result
  with `next_down`/`next_up`. Products consider all four endpoint products. Square,
  abs, min and max use monotonic interval rules. Exact zero identities avoid
  artificial subnormal uncertainty from zero × anything and zero + anything.
* Inverse coefficients, inverse translation, induced-norm upper bound, tile
  center, half extents, center-distance evaluation and radius all use those
  interval operations. A rounded center never silently shrinks the tile footprint.
* `sqrt` supplies only a seed. A proposed lower root is accepted only when an
  outward square interval proves its square <= input; an upper root is accepted
  only when its square interval proves its square >= input. Eight adjacent-float
  attempts are allowed. Failure returns uncertainty, not an assumed library
  accuracy bound. This also permits the implementation to decline subnormal
  cases in which adjacent roots cannot certify a square comparison.
* Finite input coefficients, translations, local dimensions, query coordinates
  and extents are capped at 2²⁰ in magnitude. Spaces additionally require a
  determinant interval excluding zero, a finite inverse-norm upper bound <=2²⁰,
  and `norm_upper(A) × norm_upper(A^-1) <=4096` with an outward product.
  These are conservative admission limits, not assertions that every rejected
  mathematical transform is invalid.
* A nonfinite interval or failed root bracket makes the classification Boundary.
  Singular, too large or ill-conditioned Spaces remain unadmitted; they classify
  Boundary and decline point refinement. The operation planner rejects an
  unadmitted scene instead of inventing a result or treating uncertainty as empty.

The floating-point environment must provide ordinary IEEE binary64 basic
operations with gradual underflow and without fast-math/FTZ/DAZ transformations.
That is the tested Rust x86_64 default environment. The crate does not configure
or audit foreign changes to the floating-point control state. The input-domain
limits and finite checks avoid large-intermediate overflow; uncertainty still
falls back to Boundary. There is no claim of exact classification for an
unspecified environment or unsupported representation.

The scalar boundary refiner evaluates implicit circle/box inequalities with ordinary binary64
inverse-point arithmetic. It provides point coverage, with the usual rounding
limits near a mathematical edge. Averaging a supplied finite point grid is a
finite-sample estimate, **not exact pixel-area AA**. A 0.01-radius circle at the
pixel center can be fully covered by a center sample and missed by a 2×2 grid;
a regression test makes that distinction explicit. No smoothstep-distance ramp,
font hinting, subpixel text or area integration claim is made.

## 3. Ordered operation planner

`Plan` borrows an immutable operation slice, preventing later geometry/paint edits
from invalidating its certificates. The API supports bounded premultiplied linear
RGBA source-over plus an explicit pointwise backdrop-brightness dependency.

Bins are assembled front-to-back, then reversed to execute original paint order.
An Inside certificate plus exact alpha=1 makes the tile's source-over result
independent of all earlier source-over work in that dependency segment:

```text
opaque_source over D = opaque_source + (1-1)D = opaque_source
```

Earlier draws in that segment are skipped **before** their references or geometry
certifications are produced. A semitransparent operation never establishes that
state, and all overlapping semitransparent operations above the opaque fill stay
in paint order. Every explicit backdrop operation is retained and resets the
occlusion state, so earlier dependency-producing work is preserved. This is
intentionally conservative even when an opaque foreground would mathematically
hide a backdrop result. The toy pointwise dependency checks barrier semantics;
it does not claim to implement spatial blur or its inflated dependency bounds.

Flat mode classifies each relevant tile. Hierarchy mode classifies a rectangular
range of tiles, propagates Inside/Outside certificates over the range, and
subdivides only Boundary ranges. Already hidden ranges need no geometry query.
`build_unculled` is a classification-only control with opaque removal disabled.
A plan allocates bins/work storage; this experiment does not claim allocation-free
frame construction. The hierarchy also scans per-tile hidden flags, so fewer
SDF calls need not imply proportionately less setup time.

## 4. Validation

Six public integration tests include:

* Exhaustive small dyadic circle/box transforms (reflection, nonuniform scale and
  shear), tile grids and 9×9 sample probes per certified tile, checked by an
  independent implicit geometric equation without SDF/sqrt/division.
* 5,000 random dyadic transforms/fractional rectangles and sampled inverse-norm
  directions. Singular, nonfinite, oversized/ill-conditioned and one-ULP edge
  cases return uncertainty rather than a false certificate.
* 80 independently composited scenes, 12×9 pixels and 4×4 subpixel samples,
  compared exactly against both planners at tile sizes 1/2/4/8. The implicit
  oracle's bounded dyadic products are exactly representable in these cases;
  composition uses an independent channel loop in original operation order.
* Opaque/semitransparent ordering, dependency barriers, the whole-range hierarchy
  shortcut, and the explicit point-sample-versus-area distinction.

Sampling tests supplement the enclosure derivation; they are not a proof over
all continuous inputs. The admission/environment contract and interval reasoning
are the basis of certified Inside/Outside results.

## 5. Measured work, bytes and losses

```sh
cargo test --manifest-path reactivity/Cargo.toml -p gpui_reactivity_coverage_lab
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui_reactivity_coverage_lab --all-targets -- -D warnings
cargo run --release --manifest-path reactivity/Cargo.toml -p gpui_reactivity_coverage_lab --example workloads
```

[results.csv](results.csv) records six workloads, direct baseline, three tile sizes
(4/16/32), flat/hierarchy/unculled-hierarchy plans, geometry evaluation counts,
certified tile classes, skipped/retained tile operations, boundary point tests,
immutable scene payload, retained plan temporary payload and output payload.
All produced images are checked exactly against the direct finite-sample output.

Checked machine: AMD Ryzen 7 3700X, x86_64, Rust 1.97.1, scalar release build,
three timed repetitions with median total time, center point sample. No affinity,
frequency control or GPU/backend timing. Build and render are timed separately;
the median total is measured per repetition and need not equal the sum of their
separate medians. Space construction/admission is amortized outside timed plans.
These are renderer-independent microbenchmarks, not application/frame-rate claims.

Representative 16-pixel hierarchical tiles:

| Workload | Direct total | Proof plan build+render | Direct implicit point tests | Plan center+point evaluations |
|---|---:|---:|---:|---:|
| 512² flat fill | 4.79 ms | 1.93 ms | 262,144 | 1 |
| 16 sheared circles, 256² | 2.46 ms | 0.872 ms | 1,048,576 | 85,352 |
| 64 opaque overlaps, 256² | 11.22 ms | 0.489 ms | 4,194,304 | 1 |
| 64 translucent overlaps, 256² | 11.24 ms | 6.79 ms | 4,194,304 | 64 |
| 128 textlike stems, 128² | 4.41 ms | 0.601 ms | 2,097,152 | 63,744 |
| 64 boundary-dense circles, 4² | 2.76 µs | **10.90 µs** | 1,024 | **1,088** |

The opaque-overlap case removes 16,128 hidden tile draws and reduces retained bin
operations from 16,384 (unculled control) to 256. The retained plan payload falls
from 139,480 to 16,600 bytes. Background references are never appended; no actual
allocator-call count is claimed. In contrast the unbinned direct baseline has no
plan storage at all. Binning adds memory when no useful work can be removed.

The boundary-dense case loses about 3.95× in time: every original point test remains,
64 interval tests are added, and the plan retains 760 bytes. Shear can make the
norm bound loose: the 16-pixel sheared-circle scene certifies no Inside tiles,
though Outside rejection still removes substantial work. Small textlike boxes
here are analytic stems, not font outlines or evidence for SDF text quality.

The exact known-payload ledger uses actual Vec capacities and `size_of`:
`Color=32`, `Operation=224`, `Primitive=192`, `Space=168` bytes in this build.
Scene payload is its Vec header plus command capacity. Plan payload includes the
Plan header, bin capacity, every bin's operation capacity and retained range
scratch. Output payload is width×height×32; its separate Vec header is 24 bytes.
Allocator headers, driver memory, Arc resources (none used), and benchmark's
reference-output duplication are outside these payload columns. Outputs still
have to be written; a whole-tile proof does not make final pixels or presentation
free. This lab deliberately uses inline analytic command parameters instead of
one heap allocation per shape; no compact production scene ABI is proposed.

The direct/boundary point path uses squared radius or box comparisons and a
cached reciprocal determinant; it does not pay a gratuitous SDF square root or
per-point matrix inversion. `distance_evaluations` counts interval center-SDF
attempts only. `boundary_point_tests` counts implicit point predicates separately,
so direct rendering has zero SDF evaluations and all of its work in the latter
column. The table's plan-query total sums those two distinct categories.
