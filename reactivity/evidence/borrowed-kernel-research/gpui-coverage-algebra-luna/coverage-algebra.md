# Coverage algebra for the GPU tile proof

Research note for candidate `a81bc7536b002b1f81e1b36137c1c4de543e2204`, read-only source inspection on 2026-10-23. No code was changed, built, timed, or tested.

## Finding and claim boundary

**Strongest safe elimination:** compute one conservative certificate for the complete integer tile rectangle visited by a solid draw. If it succeeds, every `full_tile(draw, ..., tile, ...)` call for that draw is redundant. Keep the existing `visit` loop, range accounting, per-tile constant-coverage state, reverse CSR construction, and all opaque-cut conditions unchanged. On the measured full-viewport layer, this replaces 512 expensive coverage proofs per layer with one proof per layer; eight layers go from 4,096 per-tile proofs to eight draw-level proofs. It does not remove the 4,096 forward/reverse tile visits or change the 1.2843916 aggregate host ratio / 0.4873842 aggregate total ratio; the exact gate remains failed.

**Proof, under the current implementation's admitted inputs:** the union of visited tile sample rectangles is contained in one axis-aligned rectangle. Each condition checked by `full_tile` is a half-plane inequality in device `(x,y)`, after its conservative error envelope is included. A half-plane contains a rectangle iff it contains all four rectangle corners. Thus the four outer corners certify every inset corner of every visited tile. This statement is only safe if the envelope is itself bounded over the *whole* rectangle; copying each tile's local rounding margin to only the outer corners is not enough.

**Not yet proved by this note:** the existing constants `16*f32::EPSILON` and `32*f64::EPSILON` are sound bounds for every backend/compiler evaluation path in the shader. The source comments state their intent, and the tile proof already relies on them. The new certificate can preserve or strengthen this envelope, but it cannot turn those constants into a backend-independent theorem without the shader/compiler arithmetic assumptions. No hardware claim is made; current measurements are llvmpipe software Vulkan.

## Exact domain from `visit`

The candidate's `PreparedPlacement::bounds` comes from integer `[left, top, right, bottom]` edges (`u16`) and `device_bounds` converts them exactly to f32. `visit` computes

```
x0 = floor(bounds.x / 16)
x1 = floor((bounds.x_as_usize + bounds.width_as_usize - 1) / 16)
y0 = floor(bounds.y / 16)
y1 = floor((bounds.y_as_usize + bounds.height_as_usize - 1) / 16)
```

using integer division; more literally, casts occur before addition/subtraction. For the current `device_bounds`, all terms are exact nonnegative integers, nonempty, and at most the `u16` scene extent. Define the visited tile union edges

```
L = 16*x0; T = 16*y0
R = min(16*(x1+1), viewport_width)
B = min(16*(y1+1), viewport_height)
```

and proof sample bounds

```
X = [L + 1/8, R - 1/8]
Y = [T + 1/8, B - 1/8].
```

`tile_bounds` clips only the viewport's final row/column. Therefore these are exactly the outermost sample coordinates tested by the constituent `full_tile` calls, including partial tiles at right/bottom. Reusing raw `draw.bounds` would be wrong: those bounds select tiles, while `tile_bounds` defines proof geometry. The formulas above must be derived from the same integer casts as `visit`, not from a separately rounded AABB.

The current drawing rectangles cannot produce an empty visit: prepared bounds are integral and nonempty. Keep a conservative `None` outcome if those source invariants ever change; do not add a new unwrap or alter admission behavior.

## Half-plane certificate

For each local axis `i in {x,y}`, `full_tile` requires four inequalities on each corner `(x,y)`:

```
p_i(x,y) > margin_i(x,y)
extent_i - p_i(x,y) > margin_i(x,y)
q_i(x,y) > guard_i(x,y)
extent_i - q_i(x,y) > guard_i(x,y)
```

where packed-high `p_i = high[i]*x + high[i+2]*y + high[i+4] - origin_i`, canonical `q_i` uses `draw.inverse`, `margin` is the current `16 eps32 * (sum abs terms + 1) + error[i]`, and `guard` is the current `32 eps64 * (sum abs terms + 1)`. For `x,y >= 0`, each sum-of-absolute-terms envelope is affine with nonnegative coefficients in x and y. Subtracting it from `p` or `q` remains affine; so does `extent - p/q - envelope`. The minima over a rectangle occur at a corner. This proves the ideal real-valued inequalities from four corners.

For a strict floating-point proof of the *certificate calculation*, use lower bounds for the left sides and upper bounds for the envelopes. A practical no-dependency formulation is:

1. Keep the current four geometric sample corners `(L+1/8,T+1/8)`, `(R-1/8,T+1/8)`, `(L+1/8,B-1/8)`, `(R-1/8,B-1/8)`.
2. Compute one global conservative magnitude envelope for each axis over the full domain. Since all device coordinates are nonnegative and the absolute-coefficient envelope grows with x/y, it is bounded by evaluating its positive-term form at `(R-1/8,B-1/8)` (or use exact outward interval additions/multiplications).
3. Form an outward-rounded lower bound for each affine `p`/`q` corner value and upper bound for `extent-p/q`; compare those lower bounds strictly against the global upper margin/guard. Any non-finite, subnormal-sensitive, overflowed, or ambiguous result returns false.
4. Preserve the old per-tile function as fallback. A false negative only gives up this optimization.

The global margin is intentionally looser than the tile-local one; near edges, large canvases, shear, or cancellation may make it reject. This is safe and acceptable for an initial implementation. Current validation bounds the aggregate transform magnitude by `f32::MAX/32`, admits f32 narrowing only when finite, and limits local-to-device error to `1/32`; those checks are useful preconditions but do not replace outward rounding in the new proof. `f64::from(f32)` is exact. For f64 operation bounds, use a documented `gamma_n = n*u/(1-n*u)`-style absolute error bound for the finite multiply/add sequence or explicit directed `next_down`/`next_up` interval helpers; never assume ordinary rounded evaluation is an outward interval endpoint. IEEE interval arithmetic defines the enclosure obligation, and Shewchuk explains fast filters that accept only when an explicit error bound certifies the sign [IEEE 1788-2015](https://standards.ieee.org/ieee/1788/4431/), [Shewchuk 1997 paper](https://people.eecs.berkeley.edu/~jrs/papers/robustr.pdf).

A compact alternative is to evaluate affine minima directly by coefficient sign and endpoints, rather than run four separate dot products. For `f = a*x+b*y+c`, `min(f)` selects `Lx` when `a>=0`, else `Rx`, and similarly for `b`. However, it must be paired with an outward bound on coefficient products/sums and on the conservative envelope. It is less code to audit initially to share one four-corner kernel with `full_tile` and feed it the global rectangle.

Clip: preserve `full_tile`'s *continuous* clip containment check, lifted to the global `[L,R] × [T,B]` rectangle. It is a separate condition from the affine inverse rectangle and must use the existing correction-aware semantics in the renderer. Do not round clip endpoints to tile indices. If an endpoint comparison is within the arithmetic uncertainty of equality, reject the global certificate. Since actual proof samples stay 1/8 pixel inside the maximum edge, a conservative continuous containment check is sufficient and preserves inclusive edge behavior.

## Safe integration shape

Suggested source-level shape, not an implementation:

```
whole_bounds = if self.tile_proofs && draw.source.is_solid()
    certify_visited_bounds(draw, error, width, height) // Option<CoverageCertificate>
else None;
visit(draw, columns, |tile| {
    let proof_needed = opaque || self.ranges[tile][1] & CONSTANT_TILE != 0;
    let covered = self.tile_proofs && draw.source.is_solid() && proof_needed
        && (whole_bounds.is_some() || full_tile(draw, error, tile, ...));
    // existing CONSTANT_TILE and opaque/cursor state transition, unchanged
});
```

The actual `covered` condition must keep candidate semantics: it is relevant only when a tile is still `CONSTANT_TILE`, or when a sign-safe opaque solid can establish the per-tile cut. The certificate says geometric coverage, not opacity. Keep the existing `opaque` test exactly where it authorizes `[address, CONSTANT_TILE | 1]` and cursor reset. In particular, the certificate must not cause translucent paint to reset a tile's opaque-prefix cursor. Preserve `color[3] == 1.0` and the negative-zero/negative-subnormal filter; do not change color math, source ordering, HDR source-over, ranges, correction indices, or DD shader fallback.

The certificate is a small stack local (boolean/enum and, if useful for diagnostics, four integer edges). It adds no per-tile vector, heap allocation, reference, draw tag, shader branch, or record layout. It remains compatible with safe Rust and the existing borrowed SIMD word comparisons. There is no reason to add handwritten SIMD to this scalar eight-constraint proof: the hot work being removed is hundreds of repeated proofs, and the first formulation is constant-size. If later profiles show row interval solving is worthwhile, vectorize only the shared constraint kernel and compare it with scalar codegen. A primary SIMD scan study compares horizontal, vertical, and tree SIMD algorithms and shows scan implementation is workload/layout dependent, not an automatic win [Zhang, Wang & Ross, 2020](https://www.cs.columbia.edu/~kar/pubsk/ADMS2020.pdf). This task is not a prefix-sum problem.

A useful precondition fast path can use `tile_count(draw) > 1` (or preferably a coarse threshold justified by later measurements) before doing this certificate, but don't claim a speedup from an unmeasured threshold. For the fixed 512-tile layers, proof cost moves from O(area) to O(1), while all necessary bin visits stay O(area). On `runs32k`/`singletons32k`, most draw bounds are small; avoid paying a more expensive certificate in addition to the old proof on those draws. Whether the precheck should be only for viewport-covering draws or all multi-tile draws is a measurement decision after correctness is established.

## General affine half-plane row certificate

The same inequality form can eliminate all-corner work on partial/rotated bounds by solving one admissible x interval per visited tile row. At a fixed row sample y, each constraint `A*x + B*y + C > E(x,y)` becomes `s*x + k(y) > 0`; for `s>0`, it yields a lower x bound, for `s<0`, an upper bound, and for `s==0`, either accepts/rejects the whole row. Intersect all eight packed/canonical constraints plus clip x constraints with the row's geometric sample interval. Since y ranges over the row's inset vertical interval and the constraints are affine, a *whole tile row* requires the interval to hold at both y endpoints. Conservative interval arithmetic rounds lower bounds upward and upper bounds downward (with strict margins), and rejects zero/near-zero slopes rather than divide unsafely. The result is O(number of tile rows) divisions/constraint setup instead of O(tile area) tile proofs. Each tile still needs only an integer membership comparison against that row interval during `visit`.

This extension is not a free replacement for current `full_tile`: it needs exact treatment of clip residuals, slope sign/zero, division enclosure, negative and signed-zero coefficients, final partial tile endpoints, and shader packed-high/canonical envelopes. It can conservatively reject whole rows and fall back to `full_tile` per tile. Prove and ship the simpler whole rectangle first. The classical conservative-rasterization literature likewise starts from cell overlap/containment and treats tile traversal as a distinct setup problem; it supports the geometric framing, but it does not validate this renderer's floating-point envelope [Akenine-Möller & Aila, 2005](https://www.lunduniversity.lu.se/lup/publication/95de0a4d-2816-426f-9c72-30b7fd6358fa), [GPU Gems 2, ch. 42](https://developer.nvidia.com/gpugems/gpugems2/part-v-image-oriented-computing/chapter-42-conservative-rasterization).

## Adversarial correctness fixtures

A candidate change should preserve existing tests and add a small, independent geometric oracle (or exhaustive comparison) over `covered_by_global` versus `full_tile` for every visited tile. The independent expected result should use conservative exact/high-precision or interval arithmetic, not call the implementation helper under test. Include:

- full viewport and final partial right/bottom tiles; 1×1 viewport; a draw ending exactly on a 16-pixel boundary and one ending 1 device pixel either side;
- a rectangle that spans many tiles but misses by a tiny amount at only the far corner; false negatives allowed, false positives forbidden;
- identity, axis flips, rotations, shear, large/small scales, coefficient cancellation, huge translation, and near-singular transforms still within current validation;
- exact boundary touch and ±one representable f32 step around each local rectangle edge; packed-high and canonical classifications intentionally disagree; nonzero correction/DD fallback cases;
- clip start/end exactly on a tile edge, just inside/outside it, and clip correction residuals around rounded f32 `start+extent`;
- negative zero, positive/negative subnormal colors, HDR negative/large values, alpha 1 vs next-down(1), and translucent full coverage after both constant and nonconstant prefixes;
- independent x/y clipping with partial final tile, and source kinds (solid qualifies; mask/image/rounded reject as today).

For the state transition test, compare per-tile `[range address, count/CONSTANT_TILE, cursor]` after each draw against shipping/current candidate. A global certificate false is allowed; a globally true certificate must mean every old per-tile true result is true. Separately compare final references and image bytes across SDR/HDR and transparent/opaque backdrops.

## Foundational retained-painter compression: constrained opportunity

A shared full-bounds prefix is possible only when the eligible references form one contiguous painter-order prefix applicable to every tile. Store that prefix once; each tile's range holds only its local suffix and a prefix length/cutoff. The shader can replay `prefix[0..k]` then its tile suffix, saving duplicate addresses and tile-reference writes. This could make the root-first/all-canvas scene substantially smaller, but it does not apply to arbitrary full-bounds draws interleaved with tile-local draws: two streams would reorder painter composition unless the shader merges by order (extra tags/metadata) or scans the global list for every tile (O(T*P)). Do not solve that by adding draw-order tags or a plane.

Opaque-prefix semantics are the hard part. A root opaque draw creates a global backdrop-independent base; a later *local* opaque draw can retire earlier global/local draws only in the tiles it covers. Encoding one bit as `OPAQUE_PREFIX` is ambiguous if it can mean either “global shared root” or “tile-local cutoff.” Empty local suffixes and tiles whose local cutoff precedes all shared entries must remain representable. Keep a distinct semantic interpretation in existing range words (if possible), and prove these cases before changing CSR or shader loops. Charge stats by logical `G*T` work even if only G addresses are physically stored, unless the stat definition is deliberately revised across all comparators. Continue validating and admitting every resource and correction before a compressed prefix becomes resident; an admission failure must revoke the cached packet. Avoid copying a common prefix into every tile at preparation time: that repeats work instead of compressing it.

This representation's benefit is speculative; current evidence says shared-image fixture uses eight 128×128 placements, not full-canvas images, and the tested full-canvas opaque-root-first case does not benefit from a generic sampled-only prefix. It is a separate research branch from deleting coverage proofs.

## Observed facts, derived facts, and predictions

**Observed in source/evidence:** candidate `bin_draw` calls `full_tile` in the forward `visit`; `full_tile` checks clip containment and four corners in packed-high and canonical f64 arithmetic; `visit` enumerates integer tiles; candidate calls the proof on translucent solids only while the tile's constant-coverage bit remains set, and on any material-sign-safe opaque solid; eight full layers cover 512 tiles each in the cited fixture; fixed campaign failed its host regression gate with layer ratios 2.288–2.420 and aggregate host ratio 1.2843916 slower. The fixed campaign report says software Vulkan llvmpipe only.

**Derived mathematical result:** with an outwardly bounded affine envelope, four corners of the exact visited union rectangle prove the same strict half-plane constraints at all constituent tile corners. Thus a whole-rectangle certificate is sound and needs constant proof work per qualifying draw; it remains a fallback-only optimization and cannot increase false coverage.

**Predictions to test later:** full-screen layers should lose nearly all repeated transform/margin arithmetic; tile visits, CSR bookkeeping, queue submission, reference writes, 32k regressions, and frame tails remain. Any wall-time estimate beyond that is speculation. Do not call the fixed failure a pass or attribute all host cost to coverage arithmetic.
