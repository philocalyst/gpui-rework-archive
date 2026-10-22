//! Designer unit-cube limits, separate from output mapping and composition.
use super::*;
use fearless_simd::{Simd, f64x4, mask64x4, prelude::*, u32x4};
use fearless_simd_macros::simd;

impl OutputProfile {
    /// Maximum OKLCH chroma at fixed L/h in this profile's linear RGB unit cube.
    /// This approximates the first outward boundary from neutral in f64 and
    /// narrows to f32; it is not a correctly rounded root operation, a later
    /// re-entry, or CSS local-MINDE mapping. L must be in [0,1]; hue
    /// must be finite and wraps as in `Color::oklch`. At L=0 or L=1 the limit is 0.
    /// Computation uses f64 coefficients and bounded interval solves. Numerically
    /// unresolved contacts or failure of the final membership check return
    /// `Error::ColorOutOfRange`; no later root is substituted as a maximum.
    /// The result is checked through the production conversion and moved inward
    /// if narrowing would leave the gamut. This does not limit HDR scene colors.
    pub fn max_chroma(self, lightness: f32, hue: f32) -> Result<f32, Error> {
        if !lightness.is_finite() || !(0.0..=1.0).contains(&lightness) || !hue.is_finite() {
            return Err(Error::InvalidColor);
        }
        if lightness == 0.0 || lightness == 1.0 {
            return Ok(0.0);
        }
        let hue = wrap_hue(hue as f64);
        #[cfg(not(feature = "simd"))]
        return limit(fearless_simd::Fallback::new(), self, lightness, hue);
        #[cfg(feature = "simd")]
        fearless_simd::dispatch!(fearless_simd::Level::baseline(), simd => limit(simd, self, lightness, hue))
    }
}
impl Color {
    /// Reduce an OKLCH author's chroma into the profile's linear RGB unit cube,
    /// preserving lightness, hue and alpha. Already in-gamut authors keep every
    /// bit, including valid re-entries beyond the neutral-connected limit.
    /// Other author spaces are rejected: RGB/HDR colors are never silently
    /// converted or clamped. This is not CSS gamut mapping or output tone mapping.
    pub fn fit_chroma(self, profile: OutputProfile) -> Result<Self, Error> {
        if self.space() != ColorSpace::Oklch {
            return Err(Error::InvalidColor);
        }
        if in_gamut(self, profile) {
            return Ok(self);
        }
        let mut channels = self.channels();
        channels[1] = channels[1].min(profile.max_chroma(channels[0], channels[2])?);
        let fitted = Self::pack(channels, ColorSpace::Oklch);
        if in_gamut(fitted, profile) {
            Ok(fitted)
        } else {
            Err(Error::ColorOutOfRange)
        }
    }
}

fn in_gamut(color: Color, profile: OutputProfile) -> bool {
    let mut rgb = color.linear_rgb();
    if profile == OutputProfile::DisplayP3 {
        // Preserve Color::convert's actual path, including the sRGB round trip.
        rgb = matrix(XYZ_TO_P3, matrix(SRGB_TO_XYZ, rgb));
    }
    rgb.into_iter().all(|v| (0.0..=1.0).contains(&v))
}

// Compose the exact existing transform constants. The resulting polynomial is
// algebraically equivalent, not bit-identical after floating reassociation;
// limit() checks the narrowed answer with the original production path above.
const fn compose(a: [[f64; 3]; 3], b: [[f64; 3]; 3]) -> [[f64; 3]; 3] {
    let mut out = [[0.0; 3]; 3];
    let mut i = 0;
    while i < 3 {
        let mut j = 0;
        while j < 3 {
            out[i][j] = a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
            j += 1;
        }
        i += 1;
    }
    out
}
const SRGB: [[f64; 3]; 3] = compose(XYZ_TO_SRGB, LMS_TO_XYZ);
const P3: [[f64; 3]; 3] = compose(XYZ_TO_P3, compose(SRGB_TO_XYZ, SRGB));

#[derive(Clone, Copy)]
struct Polynomial<S: Simd> {
    a: f64x4<S>,
    b: f64x4<S>,
    c: f64x4<S>,
    d: f64x4<S>,
}
impl<S: Simd> Polynomial<S> {
    #[inline(always)]
    fn evaluate(self, t: f64x4<S>) -> f64x4<S> {
        ((self.a * t + self.b) * t + self.c) * t + self.d
    }
    #[inline(always)]
    fn lower(self) -> Self {
        Self {
            a: -self.a,
            b: -self.b,
            c: -self.c,
            d: -self.d,
        }
    }
    #[inline(always)]
    fn upper(self, white: f64) -> Self {
        Self {
            d: self.d - white,
            ..self
        }
    }
}

#[simd]
fn coefficients<S: Simd>(simd: S, profile: OutputProfile, hue: f32) -> Polynomial<S> {
    let (sin, cos) = (hue as f64).to_radians().sin_cos();
    let q = matrix(OKLAB_TO_LMS, [0.0, cos, sin]);
    let weights = if profile == OutputProfile::Srgb {
        SRGB
    } else {
        P3
    };
    let columns: [f64x4<S>; 3] = std::array::from_fn(|column| {
        f64x4::from_fn(
            simd,
            |lane| if lane < 3 { weights[lane][column] } else { 0.0 },
        )
    });
    let weighted =
        |powers: [f64; 3]| columns[0] * powers[0] + columns[1] * powers[1] + columns[2] * powers[2];
    Polynomial {
        a: weighted(q.map(|v| v * v * v)),
        b: weighted(q.map(|v| 3.0 * v * v)),
        c: weighted(q.map(|v| 3.0 * v)),
        d: weighted([1.0; 3]) + f64x4::from_fn(simd, |lane| if lane == 3 { 1.0 } else { 0.0 }),
    }
}

#[simd]
fn critical_points<S: Simd>(simd: S, p: Polynomial<S>) -> [f64x4<S>; 2] {
    let infinity = f64x4::splat(simd, f64::INFINITY);
    let a = p.a * 3.0;
    let b = p.b * 2.0;
    let discriminant = b * b - a * p.c * 4.0;
    // Stable quadratic roots avoid subtracting nearly equal terms. Degenerate
    // derivatives use their actual degree; no small-coefficient cutoff is used.
    let sign = b
        .simd_lt(0.0)
        .select(f64x4::splat(simd, -1.0), f64x4::splat(simd, 1.0));
    let q = (b + sign * discriminant.max(0.0).sqrt()) * -0.5;
    let safe_a = a.simd_eq(0.0).select(f64x4::splat(simd, 1.0), a);
    let safe_q = q.simd_eq(0.0).select(f64x4::splat(simd, 1.0), q);
    let safe_b = b.simd_eq(0.0).select(f64x4::splat(simd, 1.0), b);
    let quadratic = a.simd_ne(0.0) & discriminant.simd_ge(0.0);
    let linear = a.simd_eq(0.0) & b.simd_ne(0.0);
    let r0 = quadratic.select(q / safe_a, linear.select(-p.c / safe_b, infinity));
    let r1 = (quadratic & q.simd_ne(0.0)).select(p.c / safe_q, infinity);
    let r0 = r0.simd_gt(0.0).select(r0, infinity);
    let r1 = r1.simd_gt(0.0).select(r1, infinity);
    // A discriminant whose sign is not separated could hide two turns. A zero
    // sentinel forces explicit non-admission instead of assuming monotonicity.
    let uncertain = a.simd_ne(0.0)
        & discriminant
            .abs()
            .simd_le((b * b + (a * p.c * 4.0).abs()) * (32.0 * f64::EPSILON));
    [
        uncertain.select(f64x4::splat(simd, 0.0), r0.min(r1)),
        r0.max(r1),
    ]
}

// Enclose each simple positive derivative root by endpoints with separated,
// opposite derivative signs. Coefficients in this fixed profile family are
// ordinary finite f64 values; 32ε covers the short non-FMA Horner evaluation.
// Failure to isolate is carried as uncertainty, never guessed into a crossing.
#[simd]
fn critical_radius<S: Simd>(simd: S, p: Polynomial<S>, t: f64x4<S>) -> f64x4<S> {
    let zero = f64x4::splat(simd, 0.0);
    let infinity = f64x4::splat(simd, f64::INFINITY);
    let present = t.simd_lt(f64::INFINITY);
    let t = present.select(t, zero);
    let mut radius = (1.0 + t.abs()) * (32.0 * f64::EPSILON);
    let mut result = infinity;
    for _ in 0..32 {
        let low = (t - radius).max(0.0);
        let high = t + radius;
        let (left, left_error) = derivative(p, low);
        let (right, right_error) = derivative(p, high);
        let separated = (left.simd_lt(-left_error) & right.simd_gt(right_error))
            | (left.simd_gt(left_error) & right.simd_lt(-right_error));
        let found = separated & present & result.simd_eq(f64::INFINITY);
        result = found.select(radius * 2.0, result);
        if (present & result.simd_eq(f64::INFINITY)).to_bitmask() & 7 == 0 {
            break;
        }
        radius *= 2.0;
    }
    present.select(result, zero)
}
#[inline(always)]
fn derivative<S: Simd>(p: Polynomial<S>, t: f64x4<S>) -> (f64x4<S>, f64x4<S>) {
    let value = (p.a * 3.0 * t + p.b * 2.0) * t + p.c;
    let error = ((p.a.abs() * 3.0 * t + p.b.abs() * 2.0) * t + p.c.abs()) * (32.0 * f64::EPSILON);
    (value, error)
}
#[inline(always)]
fn endpoint_error<S: Simd>(p: Polynomial<S>, t: f64x4<S>, radius: f64x4<S>) -> f64x4<S> {
    let magnitude = ((p.a.abs() * t + p.b.abs()) * t + p.c.abs()) * t + p.d.abs();
    let (slope, slope_error) = derivative(p, t);
    magnitude * (32.0 * f64::EPSILON)
        + (slope.abs() + slope_error) * radius
        + ((p.a.abs() * 3.0 * t + p.b.abs()) + p.a.abs() * radius) * radius * radius
}

// Positive f32 bits are used only to recognize convergence. Samples remain
// f64 t values; clamping here describes the finite representable chroma domain.
#[inline(always)]
fn chroma_floor<S: Simd>(value: f64x4<S>, lightness: f64) -> u32x4<S> {
    let value = (value * lightness).min(f32::MAX as f64);
    let (low, high) = value.split();
    let rounded = low.narrow(high);
    let (low, high) = rounded.widen();
    let down = low.combine(high).simd_gt(value).to_vector();
    let (low, high) = down.split();
    // Canonical true masks are -1, so adding their narrowed bits steps inward.
    rounded.bitcast::<u32x4<S>>() + low.narrow(high).bitcast::<u32x4<S>>()
}

// Allowed is polynomial <=0. Each derivative interval is monotone, so an
// outward endpoint brackets the first exit. Unresolved contacts block that
// lane's later answers; their earliest possible t is returned separately.
// Admission compares that uncertainty with other independently resolved faces.
// No whole-gamut monotonicity is assumed. All RGB lanes share the same solve.
#[simd]
fn first_exit<S: Simd>(
    simd: S,
    p: Polynomial<S>,
    turns: [f64x4<S>; 2],
    bound: f64x4<S>,
    lightness: f64,
) -> [f64x4<S>; 2] {
    let infinity = f64x4::splat(simd, f64::INFINITY);
    let mut result = p.d.simd_gt(0.0).select(f64x4::splat(simd, 0.0), infinity);
    let zero = f64x4::splat(simd, 0.0);
    let mut unresolved = infinity;
    let mut start = zero;
    for turn in [turns[0], turns[1], infinity] {
        let end = turn.min(bound);
        let radius = critical_radius(simd, p, turn);
        let overlaps = (turn - radius).simd_lt(bound);
        let radius = overlaps.select(radius + (turn - end).abs(), zero);
        let finite_radius = radius.simd_lt(f64::INFINITY);
        let safe_radius = finite_radius.select(radius, zero);
        let value = p.evaluate(end);
        let error = endpoint_error(p, end, safe_radius);
        let uncertain = !finite_radius | value.abs().simd_le(error);
        let pending = result.simd_eq(f64::INFINITY) & unresolved.simd_eq(f64::INFINITY);
        // An uncertain extremum can hide an outward pair of roots before it.
        // The whole preceding monotone interval is unresolved, not just the
        // derivative-root enclosure. A failed enclosure has no certified start.
        unresolved = (pending & uncertain).select(finite_radius.select(start, zero), unresolved);
        let active = pending & !uncertain & value.simd_gt(error);
        if active.to_bitmask() & 7 != 0 {
            let mut low = start;
            let mut high = end;
            loop {
                let middle = low + (high - low) * 0.5;
                let same = chroma_floor(low, lightness)
                    .simd_eq(chroma_floor(high, lightness))
                    .to_bitmask();
                let refining = active
                    & !mask64x4::from_bitmask(simd, same)
                    & middle.simd_gt(low)
                    & middle.simd_lt(high);
                if refining.to_bitmask() & 7 == 0 {
                    break;
                }
                let outside = p.evaluate(middle).simd_gt(0.0);
                high = (refining & outside).select(middle, high);
                low = (refining & !outside).select(middle, low);
            }
            result = active.select(low, result);
        }
        start = end;
    }
    [result, unresolved]
}

#[simd]
fn limit<S: Simd>(simd: S, profile: OutputProfile, lightness: f32, hue: f32) -> Result<f32, Error> {
    let p = coefficients(simd, profile, hue);
    let turns = critical_points(simd, p);
    // Cauchy's bound uses the actual nonzero leading degree. Lower roots are
    // hue-only in t=C/L. Solving them first confines the white-bound search,
    // even when L^-3 is enormous for a subnormal f32 lightness.
    let leading =
        p.a.simd_ne(0.0)
            .select(p.a.abs(), p.b.simd_ne(0.0).select(p.b.abs(), p.c.abs()))
            .max(f64::MIN_POSITIVE);
    let bound = 1.0 + p.b.abs().max(p.c.abs()).max(p.d.abs()) / leading;
    let rgb = f64x4::from_fn(simd, |lane| if lane < 3 { 1.0 } else { 0.0 });
    let bound = rgb.simd_eq(1.0).select(bound, f64x4::splat(simd, 1.0));
    let l = lightness as f64;
    let [lower, lower_unresolved] = first_exit(simd, p.lower(), turns, bound, l);
    let lower: [f64; 4] = lower.into();
    let lower = lower[..3].iter().copied().fold(f64::INFINITY, f64::min);
    if !lower.is_finite() {
        return Err(Error::ColorOutOfRange);
    }
    let [upper, upper_unresolved] = first_exit(
        simd,
        p.upper(1.0 / (l * l * l)),
        turns,
        f64x4::splat(simd, lower),
        l,
    );
    let upper: [f64; 4] = upper.into();
    let cap = upper[..3].iter().copied().fold(lower, f64::min);
    let unresolved: [f64; 4] = lower_unresolved.min(upper_unresolved).into();
    if unresolved[..3].iter().any(|&t| t < cap) {
        return Err(Error::ColorOutOfRange);
    }
    let limit = cap * l;
    if !limit.is_finite() || limit < 0.0 {
        return Err(Error::ColorOutOfRange);
    }
    let mut chroma = limit as f32;
    if chroma as f64 > limit {
        chroma = chroma.next_down();
    }
    // Narrowing and the composed coefficient matrix can differ by a few ulps
    // from the original path. Correct chroma only; never clip RGB or alter L/h.
    for _ in 0..64 {
        if in_gamut(
            Color::pack([lightness, chroma, hue, 1.0], ColorSpace::Oklch),
            profile,
        ) {
            return Ok(chroma);
        }
        chroma = chroma.next_down().max(0.0);
    }
    Err(Error::ColorOutOfRange)
}

#[cfg(test)]
#[path = "gamut/tests.rs"]
mod tests;
