//! Conservative f32 evaluation bound for prepared f64 color coordinates. Host
//! Color conversion is separate; pinned evidence states the numeric assumptions.
use super::{super::OKLAB_TO_LMS, LMS_TO_RGB};
// WGSL may round toward either adjacent f32, so use one ULP, not nearest-even u.
const EPS: f64 = f32::EPSILON as f64;
const TINY: f64 = f32::MIN_POSITIVE as f64;
fn gamma(n: f64) -> f64 {
    n * EPS / (1.0 - n * EPS)
}
// Experimental rectangular-Lab arm. The two interior Bernstein controls are
// N(q0²*q1), N(q0*q1²), scaled by max author alpha. Endpoints stay in their
// independent exact prepared words; their inverse-Lab residual is charged here.
pub(super) fn bernstein(
    left: [f64; 3],
    right: [f64; 3],
    a0: f32,
    a1: f32,
    p0: [f32; 4],
    p1: [f32; 4],
) -> ([[f32; 3]; 2], [f64; 3]) {
    let alpha = f64::from(a0.max(a1));
    let powers: [[f64; 3]; 4] = [
        std::array::from_fn(|i| left[i] * left[i] * left[i]),
        std::array::from_fn(|i| left[i] * left[i] * right[i]),
        std::array::from_fn(|i| left[i] * right[i] * right[i]),
        std::array::from_fn(|i| right[i] * right[i] * right[i]),
    ];
    let controls = powers.map(|q| super::super::matrix(LMS_TO_RGB, q));
    let stored = [
        controls[1].map(|v| (alpha * v) as f32),
        controls[2].map(|v| (alpha * v) as f32),
    ];
    let errors = std::array::from_fn(|c| {
        let norm = alpha * controls.iter().map(|v| v[c].abs()).fold(0.0_f64, f64::max);
        let preparation_norm: f64 = (0..3)
            .map(|i| alpha * LMS_TO_RGB[c][i].abs() * left[i].abs().max(right[i].abs()).powi(3))
            .sum();
        let endpoint_error = (f64::from(p0[c]) - f64::from(a0) * controls[0][c])
            .abs()
            .max((f64::from(p1[c]) - f64::from(a1) * controls[3][c]).abs());
        let cast_error = (f64::from(stored[0][c]) - alpha * controls[1][c])
            .abs()
            .max((f64::from(stored[1][c]) - alpha * controls[2][c]).abs());
        let anchor_error = endpoint_error + 0.75 * cast_error;
        let mut parameter_error = 0.0;
        if a0 != a1 && a0 > 0.0 && a1 > 0.0 {
            // Absolute derivative in v of the alpha-conditioned endpoint form.
            let k1 = f64::from(stored[0][c]);
            let k2 = f64::from(stored[1][c]);
            let k = k1.abs().max(k2.abs());
            let denominator_error = gamma(4.0);
            let derivative = 2.0 * f64::from(p0[c]).abs().max(f64::from(p1[c]).abs())
                + (1.0 + denominator_error) * (3.0 * k + 0.75 * (k2 - k1).abs());
            parameter_error = 12.0 * EPS * derivative + denominator_error * 0.75 * k;
        }
        // At exact v, the nonnegative Bernstein weights total A(t)/max(A).
        // The longest color path has nine one-ULP factors including shared
        // complement uses and both final sums; unequal alpha adds 3*D's
        // nontrivial product. Perturbed weights and stored controls also enter
        // the rounding norm. No other channel's magnitude enters this bound.
        let graph = if a0 == a1 { 9.0 } else { 10.0 };
        let mut error =
            anchor_error + parameter_error + gamma(graph) * (norm + anchor_error + parameter_error);
        // Controls use a short f64 matrix/product DAG. The broad host
        // conversion assumption remains the same as the direct-LMS profile.
        error += 128.0 * f64::EPSILON * (1.0 + preparation_norm);
        // <256 scalar arithmetic input/output sites, each with sensitivity
        // <32*max(1, norm+anchor_error), plus weighted ratio loss <512*T*norm.
        // Ordinary subnormal rounding and FTZ double this <2^15 allowance;
        // 2^20 reserves the remaining DAG fanout. See the experiment ledger.
        error += 1048576.0 * TINY * (1.0 + norm + anchor_error);
        (error * (1.0 + 256.0 * f64::EPSILON)).next_up()
    });
    (stored, errors)
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
    // The per-lane graph has <256 scalar arithmetic nodes / <1024 FTZ input
    // and output sites. A polynomial perturbation has fanout <512, polar
    // sensitivity <16*max(1,Q), cube sensitivity <4*max(1,Q²), and inverse
    // matrix row norm <8: their product is <=2^28*(1+Q³). Ratio FTZ loses
    // its denominator after premultiplication; rounding and other paths keep
    // the total below 2^32. After alpha moves before products, <1024 sites
    // amplify by <16*max(1,Q³), below the unweighted 2^16 allowance. Neither
    // term divides by minimum alpha. The qualification proof enumerates the DAG.
    let ftz = (alpha * 4294967296.0 + 65536.0) * TINY * (1.0 + q.powi(3));
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
