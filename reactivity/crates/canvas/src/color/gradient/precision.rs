//! Conservative preparation-only absolute conversion certificate. The proof and
//! admitted/rejected cohorts are recorded with the native qualification evidence.
use super::{super::OKLAB_TO_LMS, LMS_TO_RGB};
// WGSL may round toward either adjacent f32, so use one ULP, not nearest-even u.
const EPS: f64 = f32::EPSILON as f64;
const TINY: f64 = f32::MIN_POSITIVE as f64;
fn gamma(n: f64) -> f64 {
    n * EPS / (1.0 - n * EPS)
}
fn affine(left: f64, right: f64, weight_error: f64) -> (f64, f64) {
    let base = f64::from(left as f32);
    let delta = f64::from((right - left) as f32);
    let bound = left.abs().max(right.abs());
    let mut error =
        (base - left).abs() + (delta - (right - left)).abs() + delta.abs() * weight_error;
    error += EPS * delta.abs() * (1.0 + weight_error);
    error += EPS * (bound + error);
    // Outward allowance for f64 preparation and subnormal coefficients/ops.
    error += 64.0 * f64::EPSILON * (1.0 + bound) + 32.0 * TINY;
    (bound, error)
}
// Bound the true sine/cosine over the complete resolved hue arc. Endpoint
// values use the independently bounded polynomial with a 2e-6 outward pad;
// every interior extremum is included explicitly, without atan2 or sampling.
fn hue_ranges(left: f64, right: f64) -> [[f64; 2]; 2] {
    use fearless_simd::{Fallback, f32x4, prelude::*};
    let endpoint = |hue: f64| {
        let tau = std::f64::consts::TAU;
        let angle = hue - ((hue + std::f64::consts::PI) / tau).floor() * tau;
        super::trig::sin_cos(f32x4::splat(Fallback::new(), angle as f32)).map(|v| f64::from(v[0]))
    };
    let a = endpoint(left);
    let b = endpoint(right);
    let mut ranges = std::array::from_fn::<_, 2, _>(|i| {
        [
            (a[i].min(b[i]) - 2e-6).max(-1.0),
            (a[i].max(b[i]) + 2e-6).min(1.0),
        ]
    });
    let lo = left.min(right) - 1e-12;
    let hi = left.max(right) + 1e-12;
    for turn in 0..=2 {
        let base = f64::from(turn) * std::f64::consts::TAU;
        for (component, position, value) in [
            (0, base + std::f64::consts::FRAC_PI_2, 1.0),
            (0, base + 3.0 * std::f64::consts::FRAC_PI_2, -1.0),
            (1, base, 1.0),
            (1, base + std::f64::consts::PI, -1.0),
        ] {
            if lo <= position && position <= hi {
                ranges[component][0] = ranges[component][0].min(value);
                ranges[component][1] = ranges[component][1].max(value);
            }
        }
    }
    ranges
}
pub(super) fn conversion_bound(
    left: [f64; 3],
    right: [f64; 3],
    a0: f32,
    a1: f32,
    polar: bool,
) -> [f64; 3] {
    let alpha = f64::from(a0.max(a1));
    if alpha == 0.0 {
        return [0.0; 3];
    }
    // Includes normalized alpha casts, weighted denominator, numerator and WGSL
    // division's 2.5 ULP. FTZ is charged below without a tiny denominator ratio.
    let weight_error = if a0 == a1 || a0 == 0.0 || a1 == 0.0 {
        0.0
    } else {
        12.0 * EPS
    };
    let mut bounds = [0.0; 3];
    let mut errors = [0.0; 3];
    if polar {
        let (l, el) = affine(left[0], right[0], weight_error);
        let (c, ec) = affine(left[1], right[1], weight_error);
        let (_, eh) = affine(left[2], right[2], 0.0);
        let tau_error = (f64::from(std::f32::consts::TAU) - std::f64::consts::TAU).abs();
        let pi_error = (f64::from(std::f32::consts::PI) - std::f64::consts::PI).abs();
        // Hue is in [0, 4pi], so the reduction integer is 0, 1 or 2. A wrong
        // floor at a seam changes only which equivalent period is subtracted.
        let reduction_error =
            eh + 2.0 * tau_error + EPS * (std::f64::consts::PI + eh + 2.0 * tau_error);
        let trig_error = reduction_error
            + pi_error
            + EPS * (std::f64::consts::FRAC_PI_2 + reduction_error + pi_error)
            + 8e-7;
        let [sin, cos] = hue_ranges(left[2], right[2]);
        for (i, row) in OKLAB_TO_LMS.iter().enumerate() {
            let sum = row[1].abs() + row[2].abs();
            let a = cos.map(|v| row[1] * v);
            let b = sin.map(|v| row[2] * v);
            let amplitude = row[1].hypot(row[2]);
            let f = [
                (a[0].min(a[1]) + b[0].min(b[1])).max(-amplitude),
                (a[0].max(a[1]) + b[0].max(b[1])).min(amplitude),
            ];
            let products = [
                left[1] * f[0],
                left[1] * f[1],
                right[1] * f[0],
                right[1] * f[1],
            ];
            let low =
                left[0].min(right[0]) + products.iter().copied().fold(f64::INFINITY, f64::min);
            let high =
                left[0].max(right[0]) + products.iter().copied().fold(f64::NEG_INFINITY, f64::max);
            bounds[i] = low.abs().max(high.abs()) * (1.0 + 64.0 * f64::EPSILON);
            errors[i] = el
                + sum * (ec + (c + ec) * trig_error)
                + EPS * sum * c
                + gamma(6.0) * (l + el + sum * (1.0 + EPS) * (c + ec) * (1.0 + trig_error));
        }
    } else {
        for i in 0..3 {
            (bounds[i], errors[i]) = affine(left[i], right[i], weight_error);
        }
    }
    let cube_errors: [f64; 3] = std::array::from_fn(|i| {
        let (q, e) = (bounds[i], errors[i]);
        3.0 * q * q * e + 3.0 * q * e * e + e * e * e + gamma(2.0) * (q + e).powi(3)
    });
    let q = bounds.iter().copied().fold(0.0_f64, f64::max);
    // Covers every FTZ site even after multiplication reassociation: alpha*v
    // error loses its denominator when premultiplied, and remaining paths have
    // degree at most three in the bounded coordinates. The factor exceeds the
    // polynomial fanout (z^6 < 226), operation count and inverse-matrix
    // amplification. The unweighted term covers moving alpha before products
    // and an output alpha flushed to zero. Neither term divides by min alpha.
    let ftz = (alpha * 16777216.0 + 1024.0) * TINY * (1.0 + q.powi(3));
    LMS_TO_RGB.map(|row| {
        let mut error = 0.0;
        let mut norm = 0.0;
        for i in 0..3 {
            let coefficient = row[i].abs() * (1.0 + EPS);
            // WGSL abstract-float coefficient conversion may select either
            // neighbor; charge a full ULP rather than only Rust's cast residual.
            error += coefficient * cube_errors[i] + EPS * row[i].abs() * bounds[i].powi(3);
            norm += coefficient * (bounds[i] + errors[i]).powi(3);
        }
        let alpha_error = if a0 == a1 { 0.0 } else { gamma(4.0) };
        ((alpha * (error + (gamma(5.0) + alpha_error + EPS) * norm) + ftz)
            * (1.0 + 256.0 * f64::EPSILON))
            .next_up()
    })
}
