//! Taylor sin(13)/cos(12) on the folded interval ±pi/2. Coefficient words are
//! rounded once on the host, so WGSL constant conversion cannot choose a neighbor.
use fearless_simd::{Simd, f32x4, prelude::*};
#[inline(always)]
pub(super) fn sin_cos<S: Simd>(angle: f32x4<S>) -> [f32x4<S>; 2] {
    let folded = angle.abs().simd_gt(std::f32::consts::FRAC_PI_2);
    let x = folded.select(std::f32::consts::PI - angle.abs(), angle.abs());
    let z = x * x;
    let s = x
        * (1.0
            + z * (f32::from_bits(0xbe2aaaab)
                + z * (f32::from_bits(0x3c088889)
                    + z * (f32::from_bits(0xb9500d01)
                        + z * (f32::from_bits(0x3638ef1d)
                            + z * (f32::from_bits(0xb2d7322b)
                                + z * f32::from_bits(0x2f309231)))))));
    let c = 1.0
        + z * (-0.5
            + z * (f32::from_bits(0x3d2aaaab)
                + z * (f32::from_bits(0xbab60b61)
                    + z * (f32::from_bits(0x37d00d01)
                        + z * (f32::from_bits(0xb493f27e) + z * f32::from_bits(0x310f76c7))))));
    [angle.simd_lt(0.0).select(-s, s), folded.select(-c, c)]
}

#[cfg(test)]
mod tests {
    use super::*;
    fn truncation_and_rounding_bound(sine: bool) -> f64 {
        // This derivation uses one-ULP WGSL rounding at each operation. The
        // alternating nonconstant Horner partial P_i has sign(c_i) and
        // |P_i| <= |c_i| because z|c_(i+1)| < |c_i|. The cos constant term's
        // separate grouped bound is checked below. Contraction can only improve it;
        // reassociation cannot move an addition across a multiplication.
        let coefficients = if sine {
            [
                1.,
                -1. / 6.,
                1. / 120.,
                -1. / 5040.,
                1. / 362880.,
                -1. / 39916800.,
                1. / 6227020800.,
            ]
        } else {
            [
                1.,
                -0.5,
                1. / 24.,
                -1. / 720.,
                1. / 40320.,
                -1. / 3628800.,
                1. / 479001600.,
            ]
        };
        let eps = f64::from(f32::EPSILON);
        let x = std::f64::consts::FRAC_PI_2 + 8. * eps;
        let z = x * x;
        let rounded_z_bound = z * (1. + eps);
        let mut error = (f64::from(coefficients[6] as f32) - coefficients[6]).abs();
        for i in (0..6).rev() {
            if !sine && i == 0 {
                // cos's top partial needs its own bound: group -z/2+z²/24,
                // -z³/720+z⁴/40320, -z⁵/3628800+z⁶/479001600 for P0<=1.
                // Dropping positive terms gives P0 > -.272 for z<2.5.
                assert!(rounded_z_bound < 2.5);
                assert!(
                    1.0 - 2.5 / 2.0 - 2.5_f64.powi(3) / 720.0 - 2.5_f64.powi(5) / 3628800.0 > -1.0
                );
            } else {
                assert!(rounded_z_bound * coefficients[i + 1].abs() < coefficients[i].abs());
            }
            let cast = (f64::from(coefficients[i] as f32) - coefficients[i]).abs();
            let product = eps * rounded_z_bound * (coefficients[i + 1].abs() + error);
            error = cast
                + rounded_z_bound * error
                + product
                + eps * (coefficients[i].abs() + cast + rounded_z_bound * error + product);
        }
        let derivative: f64 = coefficients
            .iter()
            .enumerate()
            .skip(1)
            .map(|(k, c)| k as f64 * c.abs() * rounded_z_bound.powi(k as i32 - 1))
            .sum();
        error += derivative * eps * z;
        if sine {
            x * error + eps * x + x.powi(15) / (1..=15).product::<u64>() as f64
        } else {
            error + x.powi(14) / (1..=14).product::<u64>() as f64
        }
    }
    #[test]
    fn analytic_taylor_bound_and_dense_quadrant_edges() {
        assert!(truncation_and_rounding_bound(true) < 8e-7);
        assert!(truncation_and_rounding_bound(false) < 8e-7);
        let mut maximum = 0.0_f64;
        let mut check = |angle: f32| {
            let actual = sin_cos(f32x4::splat(fearless_simd::Fallback::new(), angle));
            let expected = f64::from(angle).sin_cos();
            let error = (f64::from(actual[0][0]) - expected.0)
                .abs()
                .max((f64::from(actual[1][0]) - expected.1).abs());
            maximum = maximum.max(error);
            assert!(error <= 1.1e-6, "angle {angle}, error {error}");
        };
        for i in 0..=65536 {
            check(-std::f32::consts::PI + i as f32 * (std::f32::consts::TAU / 65536.));
        }
        for angle in [
            -std::f32::consts::PI,
            -std::f32::consts::FRAC_PI_2,
            0.,
            std::f32::consts::FRAC_PI_2,
            std::f32::consts::PI,
        ] {
            for edge in [angle.next_down(), angle, angle.next_up()] {
                check(edge);
            }
        }
        eprintln!(
            "bounded_trig,poly_sin_bound={},poly_cos_bound={},observed={maximum}",
            truncation_and_rounding_bound(true),
            truncation_and_rounding_bound(false)
        );
    }
}
