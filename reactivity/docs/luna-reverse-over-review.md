# Reverse-over compression for the banked sample shader

**Review snapshot:** 2026-10-22. This is a source/math review, not a build, GPU profile, or benchmark. No shader or host source was changed.

## Finding

The proposed sixteen-transmittance formulation is a credible *uniform-paint specialization* for the banked shader, but it is not a general replacement for source-over and it is not an exact finite-precision rewrite. On the target banked path it reduces the nominal sample-color state from 64 scalar lanes to 20 (`T[16]` plus one `vec4` sum). It can also replace 16 per-sample vector blends per draw with one weighted paint contribution, if each draw returns one constant premultiplied color times binary sample coverage. It must traverse draws in reverse painter order. Those changes are material: they alter floating-point association and order, and the WGSL contract does not promise the exact rounding behavior needed to make the regrouping bit-identical.

The sample-major shader already in `/root/gpui-ce3` carries one sample color plus the pixel `anchor` and `delta` (about 8 scalar accumulator lanes), at the cost of repeated per-sample draw reconstruction/loads. Reverse-over is therefore a register-pressure candidate against the *banked* shader, not evidence that the ordinary shader keeps 64 sample-color scalars. The architecture choice is a three-way trade: sample-major small live state; draw-major 64-lane state; or uniform-paint reverse-over 20-lane state with changed arithmetic. No performance winner is established here.

## Exact source behavior and real-arithmetic identity

The banked shader initializes sixteen `vec4` values from clear. In ordered command traversal it executes, for sample `s` and draw `i`,

```text
C[s] = p[i,s] + C[s] * (1 - a[i,s])
```

then resolves samples in the order `0..15` using `anchor = C[0]`, `delta = Σ((C[s] - anchor) * 0.0625)`, and `anchor + delta`. The source is `sample_draw(draw, point)`, so `p[i,s]` and `a[i,s]` can vary by sample for masks and images. The source order is the host CSR painter order. The banked draw loop loads a draw once, then visits all 16 sample positions; this is the reason it exists.

For each fixed sample, premultiplied source-over has real-valued affine form `F(c)=p+t*c`, with `t=1-a`. Repeated composition is associative in real arithmetic (Porter–Duff, 1984), but still ordered. Expanding the ordered recurrence gives:

```text
C[s] = p[n,s] + t[n,s] p[n-1,s] + ...
       + (Π_i t[i,s]) clear
```

For a draw whose sample source is `p[i,s] = m[i,s] * P[i]` and alpha is `a[i,s] = m[i,s] * A[i]`, where `P[i]` and `A[i]` are constant across samples and `m` is the sample coverage, define `T[s] = 1` and visit draws from front to back (reverse CSR order):

```text
weight[i] = Σ_s m[i,s] * T[s]
sum       = sum + P[i] * weight[i]
T[s]      = T[s] * (1 - m[i,s] * A[i])
result    = (sum + clear * Σ_s T[s]) / 16
```

This is the advertised 16 `T` scalars plus 4 sum scalars. It replaces the per-draw source-color blend on each lane with a scalar weighted coverage reduction and one `vec4` contribution. If the source color varies by sample, the vector contribution remains lane-specific and this compression does not apply. `m` may be binary geometric coverage or scalar grayscale coverage, but `P` must be sample-constant. Component coverage needs separate transmittance per component and no longer has the 20-scalar ledger.

The formula is related to Porter–Duff’s compositing algebra and the standard premultiplied source-over definition; it is not novel. The separate contribution is exploiting the banked shader’s repeated identical paint across lanes. The established real-arithmetic associativity does not imply bitwise equivalence.

## Candidate ledger

Counts below are source-derived or algebraically counted, not measured hardware results. “Scalar op” counts are rough arithmetic lanes; shader lowering can fuse or restructure them.

| Formulation | Live accumulation state | Per draw, for constant paint and binary coverage | Order / data requirements | Main cost or risk |
|---|---:|---|---|---|
| Sample-major baseline (`05af5841e15cdddd9f0bce62b9f35ccc9966c312`) | 4 `color` + 4 `anchor` + 4 `delta` | 16 coverage/source evaluations and 16 four-channel source-over updates; draw loads occur inside each sample loop | Forward CSR painter order; any supported source | Small state. Repeats draw decoding/load in source; compiler may hoist some invariant work, which must be checked in generated code. |
| Draw-major banked (`854406bb5fd3fdbe3d1b268700670477d3373518`) | 16 × `vec4` = 64 scalar sample colors, plus temporaries/reduction state | One draw decode; 16 four-channel source-over updates | Forward CSR order; any supported source | Avoids repeated decoding but increases live state substantially. Register allocation, occupancy, spills are backend-specific and unmeasured. |
| Reverse-over uniform-paint | 16 scalar `T` + 4 scalar sum = 20 accumulator lanes, plus paint/coverage temporaries | 16 scalar coverage/transmittance updates + scalar weighted sum; one four-channel paint multiply/add | Reverse CSR order; same constant premultiplied paint/alpha across samples, coverage multiplies both | Changed association/order; scalar reduction and `T` state can still cost registers; only eligible materials benefit. |
| Reverse-over arbitrary sampled source | At least 16 `T` + 4 sum, but needs sample-varying source reduction or equivalent extra state/work | Still up to 16 per-lane vector products/additions, now plus transmittance maintenance | Reverse CSR order; sample-varying glyph/image results retained | Does not justify 20-lane claimed win; likely adds work/state compared with the banked path. Reject as a default. |

For the uniform-paint case, a rough arithmetic comparison per draw is 16×(4 multiplies + 4 adds) for source-over in the banked path versus 16 transmittance updates, one 16-term scalar weighted sum, and (4 multiplies + 4 adds) for the aggregate contribution. The saved work is principally RGB vector blending; coverage and alpha transmittance remain per lane. This excludes geometric evaluation, source decode, reduction, and compiler fusion. It is a derived operation count only.

The 20-lane formulation does not reduce retained scene bytes or allocations by itself. `load_banked_draw` already resolves shared paint-bank state once per draw in the banked path. A compressed material palette or paint identifier belongs in the retained packet only if it replaces existing duplicated values and has a byte/capacity ledger; it cannot be counted as a benefit of this pixel algebra.

## Numeric boundary and equality claims

The mathematical assumptions are: premultiplied paint; scalar alpha; source-over only; a common linear working color space; finite input values; no sample-varying shading or side effects; coverage multiplies both premultiplied color and alpha; same draw order in the expanded expression. Under those assumptions the real-valued expression is equivalent.

It is not bit-equivalent to the existing shader generally. The existing code rounds each multiply/add at each forward composition step, then forms the anchor-relative mean. The reverse-over expression multiplies several transmittances, reverses draw traversal, accumulates weighted paint contributions, and reduces in a different order. A simple distinguishing case is two half-alpha layers with a clear value near a binary32 rounding boundary: forward `p₂ + (p₁ + clear*t₁)*t₂` and expanded `p₂ + p₁*t₂ + clear*t₁*t₂` have different round points. An opaque layer does not rescue general bit equality for lanes with partial coverage: alpha one is multiplied by coverage, so edge lanes still have `t > 0`.

WGSL 2026 floating-point rules explicitly allow implementations to ignore zero sign, flush denormals for listed operations, choose either adjacent rounded value where accuracy is specified rather than a fixed rounding mode, and use fused operations where permitted. Thus CPU f64 or one adapter’s output is not a portable proof of shader equivalence. HDR adds finite values with a wide range and negative values in the extended-sRGB path; overflow, underflow, cancellation, and signed-zero cases need explicit treatment. Existing output then applies P3 conversion, HDR clamping or SDR tone mapping/unpremultiplication. A small working-color error can change an encoded output code at a threshold.

An interval/certificate fallback is theoretically possible only if it bounds the optimized and reference paths through final output conversion, including adapter arithmetic, attachment conversion, transfer encoding/tone mapping, and alpha handling; it must prove both paths land in the same final code value. If the interval overlaps a quantization boundary, use the current path. For SDR, a local bound around one output code is not enough unless the full transfer and attachment quantization are enclosed. For HDR float output, “same quantized code” may not apply at all; the project's existing HDR tolerance would need to define acceptance. Computing a useful interval may erase the arithmetic savings, and no cheap certificate is established here. Treat it as research, not a deployable fallback.

There is one defensible semantic slice: the existing uniform-opaque tile sentinel can directly return the sole proven final color, because no prior sample value contributes. That mechanism already exists in both source pins. Expanding it requires an exact sample-coverage proof and needs to honor the output/negative-zero contract; the CPU opaque-cut regression discovered by the parent is a reason to keep proof conditions explicit. No new general algebraic rewrite qualifies as exact without narrowing semantics or changing the stated tolerance.

## Further formulations

### A. Exact sample-signature reuse for constant-paint geometric runs

For a pixel, form a 16-bit coverage mask for each axis-aligned solid/rounded primitive. Samples whose complete ordered coverage sequence is identical produce the same per-sample recurrence bit-for-bit when evaluated once. A per-sample signature could group those lanes; evaluate the recurrence once per unique signature, then replay the unchanged anchor-relative reduction in original sample order by looking up the class result. This preserves source-over order and can reduce blend evaluations when several samples share the same signature.

This is exact only if signature equality includes every coverage decision, clip test, and source value, and if the original per-sample recurrence is executed in the same order. Images, glyph mask texels, and any sample-varying source disable it. A 16-bit mask alone is not a full signature for a stack: either retain per-draw masks and refine signatures draw-by-draw, or hash/sample-compare the entire ordered bit sequence. Hash collisions cannot authorize merging; equality must be checked. Building the masks still costs coverage work. A useful retained version would cache them across paint-only edits, but needs a coverage revision/key and costs `2 bytes × (boundary pixel × draw)` before descriptors. It can readily exceed existing command/tile references. The minimal experiment is tile-local and only for stable axis-aligned solid rectangle stacks, using compact x/y four-bit masks and a bounded active lane-class table; fallback immediately on unsupported draw type or capacity. This is an inference from the current four-by-four lattice and should be evaluated against simple sample-major shading.

The closest primary research connection is correlation-aware semi-analytic visibility: Crassin et al. use coverage masks to preserve correlated subpixel visibility and explicitly report remaining precision/correlation limitations. Their result supports the need to preserve coverage correlation; it does not validate this proposed signature cache or its cost.

### B. Paint identity sharing and Oklch boundaries

The banked packet already factors common paint/material state: draw records reference shared group state, and the shader loads the shared color once per draw. If many controls use palette variants, an exact shared paint ID can avoid repeated RGBA payload only when the payload was otherwise duplicated; report actual unique paint count, descriptor/index bytes, lookup cost, and updates before claiming a memory reduction. Lossless IDs do not compress distinct arbitrary HDR colors.

Oklch is useful for authoring, interpolation, and some SDR gamut-mapping decisions. It is not a composition accumulator: source-over is defined on premultiplied linear tristimulus components, while Oklch conversion uses nonlinear transforms and polar hue coordinates. Converting each source to linear working RGB before compositing is required; averaging or composing Oklch coordinates changes the operation. CSS Color 4 describes Oklch gamut mapping for individual SDR colors and preserves out-of-gamut intermediate values; that does not imply it is a suitable HDR storage codec. For HDR, preserve a tagged linear wide-gamut working value and apply the selected output transform once at the end, as the current shader does. Oklch should not enter this pixel-loop optimization.

## Adoption gate and adversarial cases

No implementation or performance claim is recommended until an isolated shader variant can be built and profiled. First prove generated IR/ISA has 20-or-fewer accumulator lanes and record actual register count, spills/local-memory traffic, occupancy, shader size, and command/bank load transactions on each target backend. Source declarations do not establish compiler allocation. Compare sample-major, draw-major, and reverse-over in the same runtime/pipeline, including shader compilation and fallback costs. A per-target optimized pipeline is not a whole-renderer win if selection/compilation costs exceed the saved work.

Correctness oracle must run the existing per-sample forward source-over path and compare complete attachments. Required cases include: two and many overlapping half-alpha solids; complementary subpixel rectangles; equal and unequal alpha; clear alpha zero, one, and partial; signed zero; subnormals; near-underflow transmittance; large positive/negative HDR; P3/wide-gamut; SDR tone-map/clamp thresholds; alpha-zero premultiplied colors; rounded edges with 0/1 coverage; glyph masks with distinct texels; bilinear images; empty and opaque tiles; maximum CSR depth; NaN/Inf rejection/handling if admission permits either. Test every backend's declared output tolerance, and report exact mismatches separately from tolerance passes.

For an optimization slice that must not change current source-over semantics, keep the existing exact opaque/full-tile work elimination and consider signature reuse only under exact equal-input reuse with reduction replay. The 20-lane reverse-over path is an opt-in quality/tolerance experiment for uniform solid paints, disabled for HDR/wide gamut until the final-output error contract is certified. Do not make it the default from operation count alone.

## Source pins and primary references

Local code pins reviewed:

* Sample-major renderer: `/root/gpui-ce3/reactivity`, commit `05af5841e15cdddd9f0bce62b9f35ccc9966c312`; `crates/gpu/src/shader.rs`, `fragment`; `crates/canvas/src/canvas.rs`, `render_band`, `blend`, `sample_mean`.
* Banked renderer and paint slots: `/root/gpui-paint-slot-refinement/reactivity`, commit `7687b32246` (source tree assembled from `be3809f750` + `d7fcdf62ca`, with later style-only changes); `crates/gpu/src/shader.rs`, `banked_fragment` and `fragment`. I verified this function directly from the pinned tree with `git show`; the later worktree head `854406bb5fd3fdbe3d1b268700670477d3373518` contains the same shader function.
* Existing research documents read: `docs/graphics-research.md`, `docs/renderer-work-removal-luna.md`, and `GRAPHICS.md` in the above sources. They already explain affine source-over summaries, exact sample/painter order, opaque coverage proof obligations, HDR test requirements, and shader register concerns; this review does not claim those concepts as new.

Primary technical references:

* Thomas Porter and Tom Duff, “Compositing Digital Images,” SIGGRAPH 1984, pp. 253–259. Establishes the premultiplied matte/compositing algebra and motivates associativity as a real-arithmetic regrouping tool: <https://keithp.com/~keithp/porterduff/p253-porter.pdf>.
* W3C, “Compositing and Blending Level 1,” §5.1 and §9.1.4. Defines premultiplied simple alpha compositing and source-over: <https://www.w3.org/TR/compositing-1/>.
* W3C, “WebGPU Shading Language,” floating-point evaluation section. Specifies the portability freedoms relevant to exactness: <https://www.w3.org/TR/WGSL/#floating-point-evaluation>.
* Crassin, Wyman, McGuire, and Lefohn, “Correlation-Aware Semi-Analytic Visibility for Antialiased Rendering,” HPG 2018. Uses coverage masks to retain correlated subpixel visibility; authors note remaining precision/correlation limitations: <https://research.nvidia.com/publication/2018-08_correlation-aware-semi-analytic-visibility-antialiased-rendering>.
* Ahrens, Demmel, and Nguyen, “Algorithms for Efficient Reproducible Floating Point Summation,” ACM TOMS 46(3), 2020. Their reproducible accumulator is an explicit algorithm for order-independent bitwise sums, rather than an assumption that ordinary floating-point regrouping is stable: <https://people.eecs.berkeley.edu/~demmel/ma221_Fall23/J115_Efficient_Reproducible_Summation_TOMS_2020.pdf>.
* Björn Ottosson, “A perceptual color space for image processing,” Oklab introduction (2020): <https://bottosson.github.io/posts/oklab/>.
* W3C, “CSS Color Module Level 4,” Oklab/Oklch and gamut-mapping sections. Specifies Oklch use for SDR gamut mapping while retaining out-of-gamut intermediate colors; not a source-over accumulation space: <https://www.w3.org/TR/css-color-4/>.
* AMD GPUOpen, “Occupancy explained.” Describes register pressure, occupancy trade-offs, and spills as target/compiler measurements, not source-level scalar counts: <https://gpuopen.com/learn/occupancy-explained/>.

