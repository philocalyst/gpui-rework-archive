/// A validated positive raster scale, or its exact normal power-of-two
/// reciprocal tagged by a negative sign. Both encodings occupy the same f32.
#[derive(Clone, Copy)]
pub(super) struct MetricScale(f32);

impl MetricScale {
    pub(super) fn new(scale: f32) -> Self {
        let bits = scale.to_bits();
        let exponent = bits >> 23;
        if bits & 0x7f_ffff == 0 && (1..254).contains(&exponent) {
            Self(f32::from_bits(0x8000_0000 | ((254 - exponent) << 23)))
        } else {
            Self(scale)
        }
    }

    pub(super) fn apply(self, metrics: [f32; 4]) -> [f32; 4] {
        if self.0.is_sign_negative() {
            // For normal powers of two this reciprocal is exact: multiplication
            // and division round the identical real result once to f32.
            let inverse = -self.0;
            metrics.map(|value| value * inverse)
        } else {
            metrics.map(|value| value / self.0)
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::hint::black_box;

    #[test]
    fn encoding_preserves_four_bytes_and_rejects_inexact_or_subnormal_reciprocals() {
        assert_eq!(size_of::<MetricScale>(), size_of::<f32>());
        for exponent in 0..=254 {
            for mantissa in [0, 1, 0x3f_ffff, 0x7f_ffff] {
                let bits = exponent << 23 | mantissa;
                if bits == 0 {
                    continue;
                }
                let scale = f32::from_bits(bits);
                let encoded = MetricScale::new(scale).0;
                if mantissa == 0 && (1..254).contains(&exponent) {
                    assert_eq!(encoded.to_bits(), 0x8000_0000 | ((254 - exponent) << 23));
                    assert_eq!((-encoded).to_bits(), (1.0 / black_box(scale)).to_bits());
                    assert!(encoded.is_normal());
                } else {
                    assert_eq!(encoded.to_bits(), bits);
                    assert!(encoded.is_sign_positive());
                }
            }
        }
        assert_eq!(MetricScale::new(1.25).0.to_bits(), 1.25f32.to_bits());
        // Rounding an arbitrary reciprocal changes actual f32 metric bits.
        assert_ne!(
            (9.0 / black_box(1.25f32)).to_bits(),
            (9.0 * black_box(0.8f32)).to_bits()
        );
    }

    #[test]
    fn every_power_and_fallback_keep_signed_zero_extremes_and_random_float_bits() {
        let mut scales: Vec<_> = (1..=254)
            .map(|exponent| f32::from_bits(exponent << 23))
            .collect();
        scales.extend([
            f32::from_bits(1),
            f32::from_bits(1 << 22),
            f32::MIN_POSITIVE.next_down(),
            1.25,
            1.0f32.next_up(),
            2.0f32.next_down(),
            f32::MAX,
        ]);
        let edges = [
            0.0,
            -0.0,
            1.0,
            -1.0,
            3.0,
            -3.0,
            9.0,
            -9.0,
            f32::from_bits(1),
            -f32::from_bits(1),
            f32::MIN_POSITIVE,
            -f32::MIN_POSITIVE,
            f32::MAX,
            -f32::MAX,
        ];
        let mut checked = 0;
        for scale in scales {
            let compiled = MetricScale::new(black_box(scale));
            for value in edges {
                let values = [value; 4];
                assert_eq!(
                    compiled.apply(values).map(f32::to_bits),
                    values.map(|v| (v / black_box(scale)).to_bits())
                );
                checked += 4;
            }
            let mut random = 0x4e72_1a9du32;
            for _ in 0..4096 {
                let values = std::array::from_fn(|_| {
                    random ^= random << 13;
                    random ^= random >> 17;
                    random ^= random << 5;
                    let bits = if random & 0x7f80_0000 == 0x7f80_0000 {
                        random ^ 0x0080_0000
                    } else {
                        random
                    };
                    f32::from_bits(bits)
                });
                assert_eq!(
                    compiled.apply(values).map(f32::to_bits),
                    values.map(|v| (v / black_box(scale)).to_bits()),
                    "scale={:08x} values={:08x?}",
                    scale.to_bits(),
                    values.map(f32::to_bits)
                );
                checked += 4;
            }
        }
        println!("METRIC_SCALE exact_float_division_checks={checked}");
    }
}
