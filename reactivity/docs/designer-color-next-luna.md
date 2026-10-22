# Designer palette interpolation API at ebfdb2ad459ab8d9801c295718c83f3bab563392

**Integration disposition.** Supplied report SHA-256 `40c795e8fbe77b2bd9cc3ab63883a11b88a4ed1294d3d09caa8360b3d3c71893`. Root reviewed the report; this is an unimplemented API proposal. Correction to fixture 4: without clipping, a linear primary transform commutes with premultiplied affine mixing and unpremultiplication. Linear-P3 and linear-sRGB interpolation describe the same physical result up to representation/rounding, not intentionally different blends. Verify requested tags and endpoint bits, and compare transformed results within a stated numeric budget. This stronger relation should prevent duplicate algorithms. A coarse const-checked matrix-norm certificate might remove repeated per-sample trig/validation for ordinary bounded ramps, with exact checked fallback for uncertified segments; that proof and measurement are not implemented.

Read-only proposal, pinned to commit `ebfdb2ad459ab8d9801c295718c83f3bab563392` (tree `43b97ea15a5baf7a8763e6c1b1bd423a54c7b866`). I read the pinned files with `git show <sha>:<path>`; the absolute source paths below identify their location in that tree, not a claim that the current shared checkout is still at this revision. No repository files were changed; no build or performance measurement was run.

## Scope from the pinned source

The relevant implementation is `/root/gpui-acknowledged-text-geometry/reactivity/crates/canvas/src/color.rs` at the pinned commit. `ColorSpace` already distinguishes encoded sRGB/P3, linear sRGB/P3, and OKLCH. `Color` is a 16-byte packed `[u32; 4]` holding finite straight-alpha authorship. Constructors admit negative and extended RGB subject to finite working-linear-sRGB magnitude at most `1e20`; alpha is numeric `[0,1]`; OKLCH requires `L ∈ [0,1]`, nonnegative C, and wraps H into `[0,360)`. `convert` returns the same value when the target tag already matches and otherwise converts through the existing f64 path. `Color::premultiplied` is compositor-specific: it first converts to linear sRGB and then multiplies all three RGB channels by alpha. The output-profile and tone-map types are a later, separate boundary. See the pinned [Color implementation](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/canvas/src/color.rs#L5-L110), [conversion and compositor helper](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/canvas/src/color.rs#L199-L253), and [output configuration](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/canvas/src/color.rs#L304-L431).

The gamut feature is already present in this snapshot: `OutputProfile::max_chroma` and `Color::fit_chroma` are in `crates/canvas/src/color/gamut.rs`. Do not repeat that work or make interpolation call it implicitly. `fit_chroma` only accepts OKLCH, preserves L/H/alpha and already-valid authors, and states that it is neither CSS gamut mapping nor output tone mapping ([pinned gamut source](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/canvas/src/color/gamut.rs#L31-L52)).

I read the pinned `reactivity/docs/production-gaps-luna.md`, `color-formulation-luna.md`, and `color-packing-luna.md`. They are useful scope and test-plan inputs, but they are not all current implementation authority: production-gaps still lists gamut mapping as a proposed next step, while gamut.rs has since shipped it; color-packing describes the 16-byte packing as a proposal, while this pinned Color is already `[u32;4]`. The remaining concrete color gap is mix/palette interpolation. Pinned-source search finds `fit_chroma`/ `max_chroma` but no color mix/interpolation operation in the color implementation. The production-gap report correctly calls for a separate authoring operation, explicit space/alpha/hue behavior, and one Fearless SIMD-shaped implementation with fallback. The current SIMD pattern is in [gamut.rs](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/canvas/src/color/gamut.rs#L1-L29): it uses `f64x4`, `#[simd]`, `Fallback`, and baseline dispatch. `crates/canvas/Cargo.toml` already pins `fearless_simd = 1.1.0`, enables the `simd` feature by default, and provides a same-source fallback; no new dependency is needed.

## Proposal: one reusable segment with an explicit domain

Expose a reusable two-stop segment, rather than only a one-shot `Color::mix`. The object converts each endpoint once, then samples any number of progress values in that chosen domain. Its API makes linear-light versus perceptual interpolation explicit, and requires the hue route only for the polar domain:

    pub enum PaletteSpace {
        LinearSrgb,
        LinearDisplayP3,
        Oklch { hue: HueRoute },
    }

    pub enum HueRoute {
        Shorter,
        Longer,
        Increasing,
        Decreasing,
    }

    pub struct PaletteSegment { /* private, reusable coefficients/endpoints */ }

    impl PaletteSegment {
        pub fn new(a: Color, b: Color, space: PaletteSpace)
            -> Result<Self, PaletteError>;

        pub fn sample(&self, t: f32) -> Result<Color, PaletteError>;

        pub fn sample_into(
            &self,
            t: &[f32],
            out: &mut [Color],
        ) -> Result<(), PaletteError>;
    }

    pub enum PaletteError {
        InvalidProgress,
        LengthMismatch,
        Color(Error),
    }

The names avoid a misleading generic “linear” flag: `LinearSrgb` and `LinearDisplayP3` are linear-light coordinates in those primaries; `Oklch` is a perceptual authoring space with a hue arc policy. Linear RGB keeps the existing extended range, including negatives and values above one. It carries no absolute luminance unit or reference-white scale: `ColorConfig::reference_white_nits` is output metadata, not an interpolation multiplier. OKLCH conversion may reject colors whose L is not representable in the existing bounded OKLCH author space. No domain clamps, tone maps, or gamut fits. The result is tagged in the selected interpolation space, preserving full f32 authoring precision rather than quantizing to 8-bit.

Use a fixed premultiplied-alpha rule, applied in the chosen interpolation coordinates. This is the transparent-color default with a clear contract; it is not the canvas compositor's linear-sRGB premultiplication helper. The W3C algorithm multiplies all rectangular coordinates by alpha, but in polar coordinates multiplies L and C while leaving H unmultiplied; it then interpolates and unpremultiplies. The current GPUI helper always transforms to linear sRGB first, so reusing it for OKLCH or P3 would silently change the selected domain. The [W3C CSS Color 4 interpolation algorithm](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#interpolation) and [alpha/polar rules](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#interpolating-with-alpha) give the precise mathematical precedent.

For `t ∈ [0,1]`, let `A = (1 − t)A₀ + tA₁`. In a linear RGB domain, sample each straight channel as `Cᵢ = ((1 − t)A₀C₀ᵢ + tA₁C₁ᵢ) / A` when `A > 0`. In OKLCH, use that same formula for L and C, but interpolate the hue on its selected adjusted arc without premultiplying it. When both endpoint alphas are zero and `0 < t < 1`, the premultiplied coordinates are zero; emit neutral zero L/C (or zero linear RGB), alpha +0, and the adjusted interpolated hue for OKLCH. This defines the division-by-zero case and prevents NaN. Keep exact endpoints as endpoints: `t == 0` and `t == 1` return the already-converted endpoint Color. That preserves authored hidden RGB under zero alpha and signed-zero endpoint bits; the open interval follows premultiplication. This deliberate anchor rule is useful for author palettes but is another reason not to call the whole API CSS-conformant.

Require finite progress in `[0,1]`; do not clamp or extrapolate implicitly. Reject mismatched lengths before writing, then pre-scan every progress value for finiteness and range before writing. If an extreme OKLCH sample cannot satisfy Color's existing `1e20` working-domain invariant, return `ColorOutOfRange` through `PaletteError::Color`; document that the batch writes its valid prefix before that failure. Ordinary in/out-of-gamut values within the existing numerical admission are preserved. Callers wanting a target-display preview explicitly invoke the existing `fit_chroma(profile)` after sampling.

## Hue routes and powerless hue policy

Normalize the two hues once in `new`, apply the selected W3C route to the endpoint pair, and store adjusted start/end values. The spec's boundary conditions matter:

- shorter adjusts Δh into `[-180, 180]`;
- longer takes the complementary arc, so equal hues make one full turn; exact 180-degree ties retain their signed direction;
- increasing uses `[0, 360)`, and decreasing uses `(-360, 0]`; equal hues make no turn for these two routes.

After setup, `h(t) = h₀ + t(h₁ − h₀)` remains in a bounded interval no longer than one revolution. A vector kernel can normalize by one conditional add/subtract and canonicalize zero, rather than a general remainder operation for every lane. These are the current [CSS Color 4 hue-interpolation rules](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#hue-interpolation). Existing ColorAide documentation also makes hue route a typed interpolation choice and documents premultiplication and powerless/missing values separately ([interpolation overview](https://facelessuser.github.io/coloraide/interpolation/), [plugin setup](https://facelessuser.github.io/coloraide/plugins/interpolate/)).

The GPUI `Color` has finite numeric channels but no `none`/missing marker or conversion provenance. Do not promise CSS conformance. Use this bounded policy: when an endpoint is converted from a non-OKLCH author space to OKLCH and its resulting chroma is at or below the CSS powerless threshold `4 × 10⁻⁶`, set the internal interpolation C to zero and treat that converted hue as missing. If only one converted endpoint is powerless, carry the other endpoint's numeric hue before applying the route. If both are powerless, use numeric 0 degrees as the canonical representative because the output type cannot preserve “missing.” An endpoint already tagged OKLCH supplies an authored numeric hue, even when its chroma is zero; route it as specified. This follows the distinction the spec makes between a hue that becomes missing through conversion and an explicitly supplied powerless hue, within the information GPUI retains. If a caller converted RGB to an OKLCH Color earlier, that Color no longer tells this API the earlier provenance; its stored OKLCH hue is treated as numeric. That limitation must be in docs/tests.

The `4 × 10⁻⁶` threshold is specified for OKLCH hue powerlessness in [CSS Color 4's OKLCH definition](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#specifying-oklab-oklch). This API supports no other missing-component or analogous-set behavior, does not model missing alpha, and does not use CSS host-syntax defaults/legacy sRGB rules. It borrows explicit hue and alpha mathematics; it is not a CSS color-mix implementation.

## Avoiding repeated work with one scalar/batch kernel

During `PaletteSegment::new`, convert each input to the selected domain once, premultiply the stored endpoint coordinates, and pre-adjust OKLCH hue. Store two `[f64; 4]` coefficient arrays (start/end), two already-converted endpoint Colors, and compact private state for the result tag and any admission certificate. Rebuild the Fearless `f64x4<S>` values inside the dispatched kernel; this keeps the segment independent of a particular SIMD backend. That is 64 B of f64 coefficients + 32 B of endpoint Colors + 8 B of state = 104 B if laid out with `repr(C)` and two 32-byte coefficient arrays plus an 8-byte private state word; verify with a `size_of` assertion in implementation. It is one reusable value, not added to each Color, not an allocation, and has no global cache. A 1,000-segment table would account for 104,000 bytes of segment objects before any caller-owned sampled Color buffer; this is an arithmetic budget, not a measurement. A dynamic output buffer is supplied by the caller and each returned Color remains the current 16-byte representation.

A single shared `#[simd]` kernel evaluates one f64 progress value across four component lanes. For OKLCH, the lanes hold premultiplied L/C, route-adjusted unpremultiplied H, and alpha; for linear RGB they hold premultiplied RGB and alpha. Each sample supplies one scalar progress value, broadcast through the existing Fearless SIMD operations. `sample_into` selects the `Simd` implementation once, then runs the shared per-sample kernel over the caller's progress slice; `sample` calls the same kernel once. A once-per-call domain choice selects the unpremultiplication rule and result tag. Lane outputs narrow to f32 and pack as one Color. This is component-wise SIMD, not a claim that the batch processes four swatches at once or that it is faster.

The SIMD call pattern already fits the pinned code: use the existing Fearless `f64x4` / `Simd` / `#[simd]` family, `Fallback` when the `simd` feature is absent, and baseline dispatch once per `sample_into` call when enabled. No dynamic dispatch per swatch and no temporary Vec. The current [gamut kernel](https://github.com/gpui-ce/gpui-ce/blob/ebfdb2ad459ab8d9801c295718c83f3bab563392/reactivity/crates/canvas/src/color/gamut.rs#L113-L135) shows the real API shape; this is a reuse of that design, not evidence of an interpolation speedup.

Do not bypass private Color admission just because ordinary values are small. For a safe direct-pack path, prove output Color invariants per segment:
- Linear sRGB channels are convex combinations of admitted endpoint channels. With progress restricted to `[0,1]`, narrowing to f32 cannot exceed the representable endpoint interval; alpha is also convex. This proves the existing direct linear-sRGB bound without a per-sample matrix conversion.
- For linear Display P3, certify the endpoint working-linear-sRGB margin against the f32 output rounding bound for the P3-to-working matrix. If the interval proof does not give enough margin, use `Color::new`'s existing validator for that segment's samples.
- For OKLCH, certify a conservative inverse-matrix bound once from the L/C ranges and the absolute row sums of the existing OKLab-to-LMS, LMS-to-XYZ and XYZ-to-sRGB matrices. Use upward-rounded interval arithmetic and require the bound to remain below `1e20`; it bounds every hue in the selected arc and every interpolated L/C. If it cannot certify, retain the checked `Color::new` path for those samples. This is a representation-safety check only; it neither clips colors nor duplicates the existing gamut solver.

These certificates are a no-new-rejection fast-path selector. They must never reject an otherwise valid segment: uncertified samples go through the existing constructor and receive its exact error. Start with the checked path if the outward-rounding proof is not ready; direct `pack` is allowed only after the proof and boundary tests exist. The endpoint Color copies make `t=0/1` safe without recomputation.

## Independent verification and bounded implementation budget

Build the reference in tests from converted endpoints plus an independent scalar f64 equation, not by calling `PaletteSegment::sample` or the SIMD kernel. Verify the route table independently from W3C pseudocode and include explicit fixtures:

1. Linear-light alpha: linear sRGB `(1, 0, 0, 0.25)` to `(0, 0, 1, 0.75)` at `t = 0.5` must give `(0.25, 0, 0.75, 0.5)`. Add negative and (>1) extended values; assert no clipping.
2. OKLCH premultiplication/hue: `(L=.4, C=.1, H=350, A=.25)` to `(.8, .3, 10, .75)` at `t=.5` yields `(A=.5, L=.7, C=.25, H=0)` with shorter hue. Compare all four route choices for 350→10 shorter/increasing take +20°; longer/decreasing take −340°; test equal-angle longer full turn and ±180° ties.
3. Powerless behavior: converted RGB gray with `C ≤ 4 × 10⁻⁶` to a chromatic OKLCH endpoint carries the chromatic hue; two conversion-generated powerless endpoints use the documented numeric-zero fallback. Direct OKLCH neutral inputs retain numeric hue. Exercise chroma immediately below/at/above the threshold, plus transparent endpoints and alpha=0 interior behavior.
4. Linear Display P3: independently calculate the expected P3-light interpolation in P3 coordinates, include an out-of-sRGB but admitted color, and verify the result is tagged LinearDisplayP3. Check that this differs from linear-sRGB interpolation where the primary transform makes the expected values differ.
5. Endpoint and invalid input: exact target-domain `same_authoring` at `t=0` and `t=1`, including alpha `-0.0` and transparent hidden RGB; reject NaN, infinities, `t < 0`, `t > 1`, and mismatched slices before writes. Include valid extreme values near the current `1e20` admission edge and verify checked fallback behavior.
6. For scalar/batch and fallback/native paths, compare with the independent oracle. Require exact endpoint bits and the specified neutral/hue fixtures; for general computed lanes set and report an explicit ULP/channel error budget before changing the implementation. Test partial writes if an uncertified sample returns ColorOutOfRange. Keep existing compositor tests unchanged.

The implementation budget is a proposed guardrail, not a count: at most four public API types (`PaletteSpace`, `HueRoute`, `PaletteSegment`, `PaletteError`), no Color representation/layout change, one small module plus public re-exports, roughly 200 authored shipping lines, one 104-byte reusable segment, zero hidden allocations, zero new dependencies/features/build scripts, and caller-owned output capacity only. Keep the independent test/reference addition separate and count it later. If direct-pack interval proofs expand the code materially, ship the checked constructor path first and leave the proof as a follow-up; do not hide safety behind a faster unchecked pack call.

## Primary sources

- Pinned GPUI source at commit `ebfdb2ad459ab8d9801c295718c83f3bab563392`: `reactivity/crates/canvas/src/color.rs`, `reactivity/crates/canvas/src/color/gamut.rs`, `reactivity/crates/canvas/Cargo.toml`, and `reactivity/crates/canvas/src/lib.rs`. Tree: `43b97ea15a5baf7a8763e6c1b1bd423a54c7b866`.
- W3C, [CSS Color Module Level 4, 20 October 2026](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/): [space selection](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#interpolation), [interpolation/missing components](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#interpolation), [alpha premultiplication](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#interpolating-with-alpha), [hue arcs](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#hue-interpolation), and [OKLCH powerless hue threshold](https://www.w3.org/TR/2026/CRD-css-color-4-20261020/#specifying-oklab-oklch).
- Linebender, Rust `color` crate 0.3.3 source: [straight-alpha premultiply, interpolation and hue-fixup implementation/tests](https://docs.rs/crate/color/0.3.3/source/src/color.rs#L1372-L1398), [alpha/premultiplied methods](https://docs.rs/crate/color/0.3.3/source/src/color.rs#L1586-L1617), and [hue-route conformance tests](https://docs.rs/crate/color/0.3.3/source/src/color.rs#L2111-L2142). This provides independent Rust implementation precedent; it does not remove GPUI's missing-value and provenance limitations.
- ColorAide, [interpolation behavior](https://facelessuser.github.io/coloraide/interpolation/) and [interpolator setup contract](https://facelessuser.github.io/coloraide/plugins/interpolate/), useful reference for treating setup/precomputation separately from sampling and for keeping hue, alpha, powerless and missing semantics distinct.

