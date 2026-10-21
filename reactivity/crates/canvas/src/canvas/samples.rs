//! Pixels begin with one exact working color. Only divergent sample coverage
//! promotes a pixel to sixteen independently composited colors. No averaging
//! occurs before all commands have painted, preserving overlap correlation.
use super::{TILE, blend, sample_mean};

const PIXELS: usize = TILE * TILE;

pub(super) struct Samples {
    uniform: [[f32; 4]; PIXELS],
    samples: [[f32; 4]; PIXELS * 16],
    mixed: [u64; PIXELS / 64],
}
impl Samples {
    pub(super) fn new() -> Self {
        Self {
            uniform: [[0.0; 4]; PIXELS],
            samples: [[0.0; 4]; PIXELS * 16],
            mixed: [0; PIXELS / 64],
        }
    }

    pub(super) fn reset(&mut self, color: [f32; 4], collapse: bool) {
        if collapse {
            self.uniform.fill(color);
            self.mixed.fill(0);
        } else {
            self.samples.fill(color);
            self.mixed.fill(u64::MAX);
        }
    }

    #[inline]
    pub(super) fn blend(&mut self, pixel: usize, color: [f32; 4], coverage: [f32; 16]) {
        let bit = 1 << (pixel % 64);
        if self.mixed[pixel / 64] & bit == 0 {
            let first = coverage[0];
            if coverage.iter().all(|&value| value == first) {
                if first > 0.0 {
                    blend(&mut self.uniform[pixel], color, first);
                }
                return;
            }
            self.samples[pixel * 16..pixel * 16 + 16].fill(self.uniform[pixel]);
            self.mixed[pixel / 64] |= bit;
        }
        for (sample, coverage) in self.samples[pixel * 16..pixel * 16 + 16]
            .iter_mut()
            .zip(coverage)
        {
            if coverage > 0.0 {
                blend(sample, color, coverage);
            }
        }
    }

    pub(super) fn blend_sources(&mut self, pixel: usize, sources: [Option<[f32; 4]>; 16]) {
        let bit = 1 << (pixel % 64);
        if self.mixed[pixel / 64] & bit == 0 {
            let bits = sources[0].map(|color| color.map(f32::to_bits));
            if sources
                .iter()
                .all(|color| color.map(|c| c.map(f32::to_bits)) == bits)
            {
                if let Some(source) = sources[0] {
                    blend(&mut self.uniform[pixel], source, 1.0);
                }
                return;
            }
            self.samples[pixel * 16..pixel * 16 + 16].fill(self.uniform[pixel]);
            self.mixed[pixel / 64] |= bit;
        }
        for (sample, source) in self.samples[pixel * 16..pixel * 16 + 16]
            .iter_mut()
            .zip(sources)
        {
            if let Some(source) = source {
                blend(sample, source, 1.0);
            }
        }
    }

    #[inline]
    pub(super) fn color(&self, pixel: usize) -> [f32; 4] {
        if self.mixed[pixel / 64] & (1 << (pixel % 64)) == 0 {
            // Sixteen identical finite f32 values sum exactly in f64, including
            // the signed-zero rule of the reference's first-sample seed.
            self.uniform[pixel]
        } else {
            sample_mean(
                self.samples[pixel * 16..pixel * 16 + 16]
                    .try_into()
                    .unwrap(),
            )
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn identical_finite_samples_preserve_exact_bits_including_signed_zero() {
        let mut tile = Samples::new();
        for bits in [
            0,
            0x8000_0000,
            1,
            0x8000_0001,
            0x7f7f_ffff,
            0xff7f_ffff,
            0x3f80_0001,
        ] {
            let value = f32::from_bits(bits);
            let color = [value, -value, value, -value];
            tile.reset(color, true);
            assert_eq!(
                sample_mean(&[color; 16]).map(f32::to_bits),
                color.map(f32::to_bits)
            );
            assert_eq!(tile.color(0).map(f32::to_bits), color.map(f32::to_bits));
        }
    }

    #[test]
    fn promotion_preserves_every_sample_and_later_overlap() {
        let mut tile = Samples::new();
        let mut reference = [[0.0; 4]; 16];
        let clear = [0.5, -0.0, 7.0, 0.75];
        for mask in 0u32..=u16::MAX as u32 {
            tile.reset(clear, true);
            reference.fill(clear);
            for (color, coverage) in [
                ([1.5, -0.25, 0.3, 0.5], [0.75; 16]),
                (
                    [0.25, 0.125, 0.0, 0.25],
                    std::array::from_fn(|i| ((mask >> i) & 1) as f32),
                ),
                ([-0.0, 0.375, 2.0, 0.5], [0.375; 16]),
            ] {
                tile.blend(19, color, coverage);
                for (sample, coverage) in reference.iter_mut().zip(coverage) {
                    if coverage > 0.0 {
                        blend(sample, color, coverage);
                    }
                }
                assert_eq!(
                    tile.color(19).map(f32::to_bits),
                    sample_mean(&reference).map(f32::to_bits)
                );
                assert_eq!(
                    tile.color(20).map(f32::to_bits),
                    sample_mean(&[clear; 16]).map(f32::to_bits)
                );
            }
        }
    }
}
