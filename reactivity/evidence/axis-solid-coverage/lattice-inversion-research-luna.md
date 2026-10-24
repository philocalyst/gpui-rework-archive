# Exact lattice-boundary search research

Read-only research for the current half-open correction in `/tmp/gpui-half-open-borrow-sol`, source pin `e872330f303deae4a7fba191af31e5bffa574054`. No implementation tree was edited; no build or timing was run. The question is whether the four binary searches per axis-aligned solid can be removed without changing which 4×4 lattice samples are admitted by the canonical CPU predicate.

## Conclusion

There is a simple exact monotonicity proof for the existing searches, but no useful direct closed-form inverse for their rounded-f64 roots. The most defensible experiment is an arithmetic **seed plus exact local certificate and the existing binary-search fallback**. It can return a lower bound in constant work when the seed is right; when the seed is wrong, it must fall back to the same predicate and search. The estimate never decides membership. This is the standard robust-filter shape: Shewchuk's adaptive predicates do cheap work first and increase precision only when a result is uncertain; here the certificate is simpler because the original scalar predicate can verify the boundary directly ([Shewchuk paper](https://people.eecs.berkeley.edu/~jrs/papers/robustr.pdf), [author's robust-predicate page](https://www.cs.cmu.edu/~quake/robust.html)).

This is a candidate for review and a focused correctness/code-size check, not a speed claim. It adds divisions, seed arithmetic, branches and a helper/certificate call unless inlined. Four binary searches cost at most roughly four times `log2(4*side)` predicate evaluations (up to 64 at a 16,384-side viewport). A seed path can be worse when it misses, and code/frame changes must be counted. A generic closure-based helper can also monomorphize the four axis/boundary predicates or inline them into the caller; audit code size and stack rather than assuming one shared body. The potential saving is the usual case's repeated boundary probes, but this needs measurement.

## Exact predicate and why its roots are searchable

The authoritative scalar sample path in [Canvas `sample`](</tmp/gpui-half-open-borrow-sol/reactivity/crates/canvas/src/canvas.rs:2817>) does, in order: build `wx=x+ox`, `wy=y+oy`; apply the world clip tests against `clip.x as f64 + clip.width as f64` and its y analogue; call `Mapping::local(wx, wy)`; and compare the mapped values against `rect.x as f64`, `rect.y as f64`, and the f64 sums of each origin and extent. The lattice coordinates are exactly `w_i = f64::from(i) * 0.25 + 0.125`, with `i` in `[0, 4*side)`. The lowerer in [current `lower_sampled_rect`](</tmp/gpui-half-open-borrow-sol/reactivity/crates/canvas/src/canvas.rs:157>) intentionally repeats the same local operation order for its axis predicate.

For an axis-aligned inverse, the relevant diagonal coefficient `a` is nonzero: determinant validation rejects zero determinant, and the off-diagonal terms compare equal to zero (including signed zero). Fixing the other coordinate at the exact sample `0.125` as the lowerer does, the selected local coordinate is a composition of rounded operations of the form

`L(w) = RN(RN(RN(a * w) + z) + t)`

where `z` is the signed-zero cross term times `0.125` and `t` is the stored inverse translation. Keep the real code's left-to-right operation sequence for all predicate checks. Round-to-nearest binary floating multiplication and addition are monotone functions of their operands; composition with a fixed addend preserves monotonicity. The input domain is finite: source affine values are finite and bounded, inverse entries are finite and bounded by `1e12`, world samples are at most about 16,384, and the resulting products/sums are far below f64 overflow. Therefore the local result is nondecreasing for `a > 0` and nonincreasing for `a < 0`, even when rounding creates plateaus. Rust documents `f64` as IEEE binary64, and primitive arithmetic uses IEEE round-to-nearest/ties-to-even ([Rust `f64`](https://doc.rust-lang.org/std/primitive.f64.html), [IEEE 754](https://standards.ieee.org/ieee/754/6210/)).

Writing `W_i = w_i`, `L_i = L(W_i)`, `C0 = clip_start`, `C1 = f64(clip_start_f32) + f64(clip_extent_f32)`, `R0 = f64(rect_start_f32)`, and `R1 = f64(rect_start_f32) + f64(rect_extent_f32)`, the exact existing lower-bound predicates are:

| inverse diagonal | `first(i)` | `end(i)` |
| --- | --- | --- |
| `a > 0` | `W_i >= C0 && L_i >= R0` | `W_i >= C1 || L_i >= R1` |
| `a < 0` | `W_i >= C0 && L_i < R1` | `W_i >= C1 || L_i < R0` |

Every conjunct/disjunct is monotone false→true in increasing `i`, so each closure is monotone false→true. `first` is inclusive at the lower local edge. `end` uses the upper edge and remains half-open. Under reflection, which edge controls entry/exit reverses, so the strictness also moves: `local < R1` defines entry and `local < R0` defines exit. Keep the table's exact strict/non-strict comparisons; do not “normalize” them by negating bounds or treating both edges alike.

The current `lower_bound(count, predicate)` is the first `i` in `[0,count)` with true predicate, or `count` if no sample is true. For a monotone predicate `P`, a candidate `j` is exactly that lower bound if and only if:

- `j == 0` and `P(0)` is true; or
- `j == count` and `P(count - 1)` is false; or
- `0 < j < count`, `P(j - 1)` is false and `P(j)` is true.

This is a complete proof by monotonicity: the adjacent false/true pair forces all earlier values false and all later values true. For `count == 0`, return zero without evaluating the predicate; for `count > 0`, the endpoint certificates cover the all-true and all-false cases. The admitted viewport has positive width and height, so each public axis count is nonzero. Compute `first` and `end` independently; preserve `end <= first => empty`, which also covers touching and zero-sample intersections. When nonempty, convert integer cut indices to quarter-pixel endpoints exactly as today. The existing half-open membership and signed-zero comparison semantics remain in the predicate, never in the seed.

## One unified certified-seed formulation

The continuous affine boundaries can provide a seed near each root. They cannot decide the root. Use a single helper that takes the exact predicate closure and a finite seed candidate; applies the local certificate above; and invokes the existing `lower_bound` unchanged if the certificate fails. Optionally try `seed-1`, `seed`, `seed+1` certificates in that constant-sized window before fallback. Those neighboring tests are safe only when each candidate uses the same certificate; do not walk until a direction guess says “close enough.”

A continuous world-boundary estimate (ignoring only the signed-zero cross term in the seed) is:

| diagonal | `first` seed boundary | `end` seed boundary |
| --- | --- | --- |
| `a > 0` | `max(C0, (R0 - t) / a)` | `min(C1, (R1 - t) / a)` |
| `a < 0` | `max(C0, (R1 - t) / a)` | `min(C1, (R0 - t) / a)` |

Map a world boundary `B` to the approximate lattice index `q = 4 * (B - 0.125)`. `round(q)` is a simple seed; `floor/ceil` or testing the neighboring integers are alternatives to compare. Its exact rounding mode is immaterial to correctness because the canonical predicate certifies any accepted index. Do not use `q` as the result and do not “fix up” a failed certificate with a one-sided increment/decrement. The endpoint strictness, RN operation sequence, cancellation, and rounded inverse/forward ties are deliberately resolved only by evaluating `P(j-1)` and `P(j)`.

The inverse division or the subtraction may overflow, become nonfinite, or give a poor estimate near extreme/cancelled cases. Treat every nonfinite intermediate as “no seed,” clamp only a finite candidate into `[0,count]`, then use the certificate; failed certificate means the original binary search. The seed must not use the shader's f32 or double-double inverse, nor reconstruct the inverse by re-inverting the forward matrix. Use the stored `Mapping.inverse` coefficients. F64 division, certificate branches, extra stack slots and fallback cost are real costs to measure; do not hide them inside “constant time.”

### Exact identity case and translation caution

For a true identity mapping (`inverse = [1, +0, +0, 1, +0, +0]`), local x/y equal their positive lattice coordinates, so the intersection is simply `[max(C0,R0), min(C1,R1))`. In real arithmetic its sample cut is `ceil(4*(B - 0.125))`, clamped to `[0,count]`. This can be an exact special case if the integer cut is computed exactly from the binary64 endpoint, or if the formula's result is certified by the same adjacent predicate. A bare floating `ceil` should not silently become a new proof obligation: include neighbors immediately below/at/above every quarter-sample boundary and clip-end sums. The certified seed helper already handles identity without a separate branch; benchmark before adding a special identity path.

A nonzero translation is different. Even with diagonal `±1`, `L(w)` includes a rounded f64 addition to the inverse translation; subtracting translation from an endpoint and applying `ceil` can change which side of an exact half-open edge the scalar RN expression occupies. Keep translation in the certified-seed path unless an exact preimage proof covers the actual operation order and tie cases. This aligns with interval arithmetic's purpose: rounding errors require an enclosing proof, not an assumed exact inverse ([NIST DLMF interval arithmetic](https://dlmf.nist.gov/3.1.ii), [IEEE 1788 interval arithmetic description](https://standards.ieee.org/ieee/1788/4431/)). We do not need to calculate a numeric interval here because the direct neighboring predicate certificate is stronger and smaller.

## Why a universal closed-form inverse is the wrong first target

The threshold is applied to the stored inverse map's rounded result, not to the exact real-valued inverse transform. At one axis it is the sequence of rounded multiplies/adds above; clip end is also a specific rounded f64 sum of f32 fields. Inverting a mathematical affine expression yields only an estimate of this monotone staircase. A complete closed-form method would need to calculate the preimage of the exact IEEE rounding sequence, including half-way ties and sign of zero, then intersect it with the rounded clip boundary. That is possible in principle with exact integer-significand/exponent arithmetic or carefully directed intervals, but it adds more machinery than the searches it replaces and risks silently switching from the renderer's predicate to ideal geometry.

The prior GPU f32/double-double attempt already supplies a cross-backend counterexample: at scale `1.25`, the canonical CPU stored inverse is `0.8` and computes `0.8 * 10.625 == 8.5` at the half-open edge. The shader's reconstructed coefficient differs there, changing edge membership; the GPU correction was rejected for that mismatch. This is not a CPU scalar ambiguity: keep the CPU operation sequence authoritative. Also rejected are: `ceil` without a certificate; computing an inverse from a rounded forward matrix; using f32 for lattice coordinates; moving a strict reflected comparison to the wrong edge; and evaluating transformed points with a fused or reassociated operation sequence. The exact CPU test at an edge must use the code's same separate operations and f64 sums.

## Bounds and exceptional cases that must remain in the gate

- **World sample lattice:** `i*0.25 + 0.125` for integer `i`; `count = side*4` is bounded by 65,536. Preserve that exact construction for certificate probes.
- **Clip:** use `C1 = f64(clip_start) + f64(clip_extent)` exactly as in the canonical path. Test samples equal to either endpoint, neighboring lattice samples, and endpoints whose f32 start/extent sum rounds in f64.
- **Rectangle:** use `R1 = f64(rect_start) + f64(rect_extent)`, not a separately calculated f32 `max_x/max_y`. Test f32 subnormal extents, origins, and neighbors of sample boundaries.
- **Reflection:** diagonal sign decides which local edge belongs to `first` and `end`, with the strictness table above. Include negative transforms and translation cancellation.
- **Signed zero:** off-diagonal `+0/-0` is allowed by `axis_aligned`; do not compare coefficient bits to classify it. IEEE comparisons equate signed zeros, but keep canonical `Mapping::local` evaluation in certificates. Include `rect` and clip starts/translation `-0` cases; empty nonpositive extents remain handled before searching.
- **Domain:** `validate_sampled_domain` checks finite rect/parent and viewport pixel/side limits; `Mapping::new` checks forward transform finite/bounds, nonzero determinant, finite inverse and each inverse component `<=1e12`. Preserve validation/error order. Do not broaden admission for a “better” seed.
- **Empty/endpoint:** preserve `count == 0` safety if helper is reusable elsewhere even though public sampled-clip validation rejects a zero-area viewport; for any positive axis count certify `j=0` and `j=count` without out-of-bounds reads. Preserve `end <= first` and `Rect::default()`.
- **CPU/GPU:** don't route this optimization through GPU f32/DD values. The GPU's separate sample/correction policy and its previously observed 8.5 boundary failure are independent of the CPU exact predicate.

## Falsifiable test and cost plan

Before implementation, capture the existing lowerer's outputs for adversarial cases as the oracle. For every admitted diagonal transform and valid finite rectangle/clip, compare exact `first`, `end`, and returned `Rect` bits between direct binary search and candidate-plus-certificate. Instrument the seed path to prove every accepted candidate satisfies the exact endpoint certificate; force nonfinite/bad seeds and verify they use the same fallback. Include:

- identity, signed-zero identity, pure translations, positive/negative scales and reflected clips;
- inverse coefficient values adjacent to powers of two, small/large admitted inverses, huge cancellation within the valid `1e12` envelope;
- every sample coordinate around `0.125 + k/4` with `next_down`, exact value, and `next_up` for rectangle and clip lower/upper values;
- `rect_start + extent` and `clip_start + extent` ties/rounding, nonpositive or subnormal extents, endpoints outside the viewport, and empty results;
- the known scale-1.25 / inverse-0.8 / world-10.625 / local-edge-8.5 boundary;
- strict reflected-entry/exit comparisons, including equal-to-endpoint samples;
- randomized admitted axis-aligned matrices compared against the exact scalar sampler for all sixteen sample-membership bits, not just the lowered bounding rectangle.

Count actual predicate invocations for both axes, accepted certificates, `j±1` recoveries, fallback frequency, and nonfinite seeds on these fixtures. Separately inspect optimized code size, stack frames, divisions, helper calls and branches. Timing is required before claiming improvement, with identity/translation/common scales and boundary-heavy/cancellation-heavy cases both represented. The formulation loses if its extra divisions and checks cost more than the binary-search probes, its common-case certificates are rare, `.text` or stack cost exceeds the project gate, or fallback complexity harms maintainability. Do not modify the frozen correctness fix or its tests while making this case; treat the seed path as an independently reviewed successor.

## Research references and local evidence

- Canonical rounded membership: `/tmp/gpui-half-open-borrow-sol/reactivity/crates/canvas/src/canvas.rs`, `Mapping::new/local` and `lower_sampled_rect` near lines 66–215, `sample` near 2817.
- Renderer documentation of exact half-open CPU sample membership and independent GPU precision: `/tmp/gpui-half-open-borrow-sol/reactivity/crates/gpu/README.md`, especially lines 44–66.
- Robust filtered predicates: Jonathan Shewchuk, [Adaptive Precision Floating-Point Arithmetic and Fast Robust Geometric Predicates](https://people.eecs.berkeley.edu/~jrs/papers/robustr.pdf); official author page has paper and implementations ([CMU robust predicates](https://www.cs.cmu.edu/~quake/robust.html)).
- IEEE binary64 and rounding semantics: [Rust primitive `f64`](https://doc.rust-lang.org/std/primitive.f64.html), [IEEE 754 standard page](https://standards.ieee.org/ieee/754/6210/).
- Validated intervals: [NIST DLMF §3.1(ii)](https://dlmf.nist.gov/3.1.ii) explains interval arithmetic as a rigorous enclosure for rounding effects; [IEEE 1788](https://standards.ieee.org/ieee/1788/4431/) describes interval operations and floating-point support. The proposed certificate uses the original predicate directly rather than introducing interval arithmetic.
