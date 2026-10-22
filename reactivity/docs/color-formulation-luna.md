# SIMD-first OKLCH gamut limits: exact fixed-L/hue cubics, separate CSS mapping

## Decision

Add a clearly named *constant-lightness, constant-hue chroma limit* for designer controls, computed from the target's linear RGB transform. It can replace repeated Oklab conversions and iterative chroma search with three hue-dependent cubics and bounded root selection. Keep it distinct from a CSS `local-MINDE` operation: CSS Color 4 intentionally accepts tiny lightness/hue changes near the boundary to reduce chroma loss, so the exact ray limit and local-MINDE are different output contracts. Keep both possible and expose the choice; do not silently call the ray cap “CSS gamut mapping.”

The existing author representation makes this boundary natural: [`crates/canvas/src/color.rs`](../crates/canvas/src/color.rs) retains finite tagged author colors including out-of-gamut/extended RGB, uses f64 matrix conversion for OKLCH, and only applies `SdrMapping` on final straight output-profile RGB. Its current `Clip` is explicitly non-perceptual; the per-channel Reinhard option can shift hue. Add a designer gamut operation at the author/profile boundary, before final output conversion, and keep it out of linear-light compositing and `Rgba16Float` HDR handling.

## Exact derivation

Let lightness satisfy \(L\in(0,1)\), chroma \(C\ge0\), hue be \(h\), and \(u=(\cos h,\sin h)\). The inverse Oklab matrix maps ([L, C\cos h, C\sin h]) to the *pre-cube LMS roots*:

\[
\ell'_k = L + C q_k,\qquad q=M_{OKLab\to LMS}[0,\cos h,\sin h]_k.
\]

The destination's linear-RGB conversion from cubed LMS is a 3×3 matrix (W), so output channel (j) is exactly

\[
R_j(C)=\sum_{k=0}^2 W_{jk}(L+Cq_k)^3
       =A_jC^3+3LB_jC^2+3L^2D_jC+L^3S_j,
\]

with (A_j=\sum_kW_{jk}q_k^3), (B_j=\sum_kW_{jk}q_k^2), (D_j=\sum_kW_{jk}q_k), and (S_j=\sum_kW_{jk}). For the exact D65 neutral transform (S_j=1); implementation should compute/use the actual matrix row sum or the exact same constants/order as conversion, rather than hard-code 1 if its f64 matrix stack differs by a few ulps. This identity follows directly from the inverse-Oklab equations published by Björn Ottosson ([Oklab formulas](https://bottosson.github.io/posts/oklab/)) and the current source conversion (`linear_rgb` in `color.rs`).

For (L>0), put (t=C/L). Then

\[
R_j=L^3P_j(t),\quad P_j(t)=A_jt^3+3B_jt^2+3D_jt+S_j.
\]

For destination linear RGB bounds ([0,1]), the valid interval is (0\le P_j(t)\le L^{-3}) for every channel. At neutral (t=0), all channels are in gamut (modulo the tiny matrix-rounding note above). The exact chroma cap is the *first outward crossing* over all six boundary polynomials (P_j(t)=0) and (P_j(t)=L^{-3}). It is not the largest root: a channel cubic can leave and later re-enter, and a tangential root can touch the boundary without exiting.

## SIMD-oriented bounded solve

Precompute target transform matrices once. For batches, consume hue/lightness/chroma in structure-of-arrays form. Per lane, compute sin/cos once (special-case exact cardinal hues if deterministic signed-zero behavior matters), derive q, then the three coefficient triples. Fast paths mask already-in-gamut colors and neutral/endpoints before root work. Work in normalized (t=C/L), which leaves lower-bound cubics dependent only on hue; the white bound is the per-lane (L^{-3}). A palette/editor can reuse hue coefficients when many colors share a hue.

For a robust first-exit solver, compute each cubic's derivative roots (a quadratic), retain positive finite critical points, sort the at-most-two points, and split (t\ge0) into monotone intervals. For each interval and each lower/upper RGB boundary, an endpoint sign change identifies at most one root; solve with a safeguarded Newton/Halley step inside a bracket, falling back to a fixed-count bisection when the candidate leaves the interval, the derivative is too small, or the residual is poor. Select the smallest root at which the polynomial moves outward from its allowed interval. This handles tangent contacts by checking the next monotone interval/sign instead of declaring every root an exit. Vector masks can perform a fixed maximum number of intervals and refinements across all lanes; each lane uses the same polynomial and fallback formula, avoiding a branch-heavy per-color conversion loop.

A closed-form Cardano candidate can reduce iterations, but it should be a candidate generator, not the correctness proof: signed cube root, near-zero leading coefficients, near-double roots, discriminant cancellation, and root-ordering are difficult SIMD lane cases. Validate each candidate by polynomial residual and interval membership; refine or bracket-fallback under the same bound. Coloraide's MIT-licensed implementation is a useful pinned implementation reference: [`fit_oklch_cubic.py` at 4888fc2](https://github.com/facelessuser/coloraide/blob/4888fc2d7657e29c5f91a0dc3a0a562900950cb8/coloraide/gamut/fit_oklch_cubic.py) shows the hue-only coefficient factorization, (t=C/L), turning points, and Cardano path. Its algebra solver is also part of the implementation; do not treat “closed form” as proof of numerical robustness or equivalence to CSS. The current CSS local-MINDE implementation remains an important reference output, not an oracle for exact constant-L/hue chroma limits.

An appealing SIMD hybrid is: lane-masked “already valid” test → evaluate cubics at candidate endpoint → stable derivative roots → bounded monotone-interval root solve. That avoids six repeated full OKLCH↔RGB conversions per iteration and avoids a binary search over a non-monotone whole-gamut predicate. If a simpler fixed bisection is used, bracket separately on each monotone interval; do not bisect a global `in_gamut(t)` predicate because it can become true again after an RGB channel re-enters.

## Semantics: this is deliberately not local-MINDE

CSS Color 4's local-MINDE algorithm clips a trial candidate to the destination gamut, computes ΔEOK against that clipped candidate, and accepts the clipped color when the difference is below a JND threshold; otherwise it lowers chroma and continues a bounded binary search. That means the mapped result may have a small lightness/hue change and preserve more chroma at parts of the gamut surface. The CSS spec defines the algorithm and threshold behavior directly ([CSS Color 4, gamut mapping](https://www.w3.org/TR/css-color-4/#css-gamut-mapping)). The exact cubic cap instead holds (L) and (h) fixed and stops exactly at first gamut contact. It is a better-behaved “maximum chroma at this lightness and hue” designer control and a useful deterministic primitive, but it cannot replace local-MINDE without changing that contract. Ottosson's cusp/one-Halley gamut clipping is a third technique: it estimates a cusp and solves a line intersection, with variants that intentionally trade lightness to retain chroma ([gamut clipping derivation](https://bottosson.github.io/posts/gamutclipping/)). Do not conflate these algorithms either.

Suggested API split:

- `Oklch::max_chroma(target_rgb)` / `fit_chroma_preserving_lh(...)`: strict first-exit cap, for sliders, palette generation, and predictable authored values.
- `map_to_gamut(method = LocalMinde { jnd, epsilon })`: spec-aligned perceptual mapping with explicit tolerance, for CSS-compatible SDR output.
- A later cusp/fast preview method may be offered only with a separately named quality contract.

## Numerical and perceptual edge cases

- (L\le0) and (L\ge1): return black/white with the existing alpha policy; do not divide by L. Current author API limits OKLCH L to [0,1].
- (C=0): keep exact neutral and avoid undefined-hue `atan2`; alpha remains unchanged. Keep color gamut tests on straight RGB, not premultiplied color.
- Hue wrap and cardinal angles: canonicalize hue once; set exact sine/cosine for cardinal angles if useful so scalar and SIMD agree at signed-zero/primary boundaries.
- Finite/extreme chroma: the cap depends on L/h and remains bounded by a first boundary exit, so do not evaluate a huge authored C in cubic arithmetic before testing/solving. Reject non-finite coefficients and return a typed error/fallback; do not leak NaN into output.
- Near neutral / dark / light: when (L^{-3}) grows, white-bound coefficients can be badly scaled; normalize boundary equations and use f64 for coefficients/root refinement even if storage and vector lanes are f32. Near (L=1), the cap tends to zero; near (L=0), use explicit endpoint behavior.
- Roundoff: after solving, convert with the exact production matrix and verify target bounds; if an f32 cast drifts slightly out, move C inward by a small representable step and re-check. Preserve alpha and authored metadata. Do not broadly clip RGB as a substitute for the cap.
- Destination target: derive W separately for linear sRGB and linear Display-P3. If later supporting different white points/adaptation or HDR output, derive coefficients for that exact transform and document the gamut domain; do not apply SDR ([0,1]) caps to extended-range/HDR values.

## Validation and performance proposal (not run)

Build a reference test grid over hue, L, and requested C for linear sRGB and Display-P3. Check: in-gamut inputs are bit-preserved if the API promises that; capped output is in bounds under production conversion; a tiny increment above the reported cap crosses at least one boundary except for documented tangent/corner ties; L/h/alpha remain fixed; scalar and SIMD results agree within an explicit OKLab and channel error budget. Include hue wrap, cardinal directions, neutral, near-black/near-white, high chroma, roots near a cubic turning point, and multiple SIMD lanes with mixed early exits. Compare against a slow high-precision monotone-interval reference for correctness, not against local-MINDE where semantics differ.

Benchmark only after correctness: batches matching designer use (small palette, thousands of swatches, animation), scalar current conversions, SIMD cubic cap, scalar/SIMD local-MINDE, and hue-cached repeated batches. Report colors/sec plus worst ΔEOK, max gamut violation, and lane-mask utilization. Do not call a conversion-count reduction a speed win until measured on x86 and ARM. Keep compositing/per-pixel scene colors out of this benchmark and API: those operate in linear light and must not repeatedly undergo authoring-space gamut mapping.

## Primary and implementation references

- [Ottosson, Oklab equations](https://bottosson.github.io/posts/oklab/), source of inverse LMS-root/cube structure.
- [Ottosson, gamut clipping](https://bottosson.github.io/posts/gamutclipping/), cusp and Halley alternatives, plus their lightness/chroma tradeoffs.
- [W3C CSS Color 4, gamut mapping](https://www.w3.org/TR/css-color-4/#css-gamut-mapping), normative local-MINDE semantics and bounded search.
- [Coloraide cubic fit implementation, pinned MIT source](https://github.com/facelessuser/coloraide/blob/4888fc2d7657e29c5f91a0dc3a0a562900950cb8/coloraide/gamut/fit_oklch_cubic.py), hue polynomial factorization and Cardano implementation.
- Pinned GPUI source: [`color.rs`](../crates/canvas/src/color.rs), current authoring/conversion/output separation and matrix evaluation.

Implementation qualification: the algebraic polynomial expansion is not bit-identical to the production matrix evaluation under floating-point reassociation. Verify with the actual conversion and an explicit channel/OKLab error budget. This document proposes an algorithm; no cubic gamut operation or speed result is currently shipped.
