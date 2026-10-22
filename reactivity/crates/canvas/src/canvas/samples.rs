//! Pixels begin with one exact working color. Only divergent sample coverage
//! promotes a pixel to sixteen independently composited colors. No averaging
//! occurs before all commands have painted, preserving overlap correlation.
use super::{TILE, sample_mean};
use fearless_simd::{Simd, f32x4, prelude::*};
use fearless_simd_macros::simd;

const PIXELS: usize = TILE * TILE;

/// Source colors and geometric presence are separate. A present transparent
/// color still blends (and may change a signed zero); absence never blends.
pub(super) struct Sources {
    colors: [[f32; 4]; 16],
    present: u16,
}
impl Sources {
    #[inline]
    pub(super) fn from_fn(mut source: impl FnMut(usize) -> Option<[f32; 4]>) -> Self {
        let mut present = 0;
        let colors = std::array::from_fn(|index| match source(index) {
            Some(color) => {
                present |= 1 << index;
                color
            }
            None => [0.0; 4],
        });
        Self { colors, present }
    }

    #[cfg(test)]
    pub(super) fn get(&self, index: usize) -> Option<[f32; 4]> {
        (self.present & (1 << index) != 0).then_some(self.colors[index])
    }
}

pub(super) struct Samples<S: Simd> {
    simd: S,
    uniform: [[f32; 4]; PIXELS],
    samples: [[f32; 4]; PIXELS * 16],
    mixed: [u64; PIXELS / 64],
}
impl<S: Simd> Samples<S> {
    pub(super) fn with_simd(simd: S) -> Self {
        Self {
            simd,
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
                    blend_one(self.simd, &mut self.uniform[pixel], color, first);
                }
                return;
            }
            self.samples[pixel * 16..pixel * 16 + 16].fill(self.uniform[pixel]);
            self.mixed[pixel / 64] |= bit;
        }
        blend_coverage(
            self.simd,
            &mut self.samples[pixel * 16..pixel * 16 + 16],
            color,
            coverage,
        );
    }

    pub(super) fn blend_sources(&mut self, pixel: usize, sources: &Sources) {
        if sources.present == 0 {
            return;
        }
        let bit = 1 << (pixel % 64);
        if self.mixed[pixel / 64] & bit == 0 {
            let bits = sources.colors[0].map(f32::to_bits);
            if sources.present == u16::MAX
                && sources
                    .colors
                    .iter()
                    .all(|color| color.map(f32::to_bits) == bits)
            {
                blend_one(self.simd, &mut self.uniform[pixel], sources.colors[0], 1.0);
                return;
            }
            self.samples[pixel * 16..pixel * 16 + 16].fill(self.uniform[pixel]);
            self.mixed[pixel / 64] |= bit;
        }
        blend_sources(
            self.simd,
            &mut self.samples[pixel * 16..pixel * 16 + 16],
            sources,
        );
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

// RGBA is already a four-f32 contiguous AoS record. These safe loads/stores do
// not require 16-byte alignment, never read another sample, and have no tail.
// Keep the original scalar alpha multiplication and separate multiplies/add:
// neither reassociation nor fused multiply-add is part of this equation.
#[inline(always)]
fn source_over<S: Simd>(simd: S, dst: &mut [f32; 4], src: [f32; 4], coverage: f32) {
    let alpha = src[3] * coverage;
    let source = f32x4::from_slice(simd, &src) * coverage;
    let backdrop = f32x4::from_slice(simd, dst) * (1.0 - alpha);
    (source + backdrop).store_slice(dst);
}

#[simd]
fn blend_one<S: Simd>(simd: S, dst: &mut [f32; 4], src: [f32; 4], coverage: f32) {
    source_over(simd, dst, src, coverage);
}

#[simd]
fn blend_coverage<S: Simd>(simd: S, dst: &mut [[f32; 4]], src: [f32; 4], coverage: [f32; 16]) {
    for (sample, coverage) in dst.iter_mut().zip(coverage) {
        // Do not blend zero coverage: multiplication by zero can change HDR
        // signed zeros, and evaluating an absent sample can create NaNs.
        if coverage > 0.0 {
            source_over(simd, sample, src, coverage);
        }
    }
}

#[simd]
fn blend_sources<S: Simd>(simd: S, dst: &mut [[f32; 4]], sources: &Sources) {
    if sources.present == u16::MAX {
        // Ordinary interior image samples are all present: contiguous RGBA
        // loads need no Option decoding, mask construction, or bit selection.
        for (sample, source) in dst.iter_mut().zip(sources.colors) {
            source_over(simd, sample, source, 1.0);
        }
    } else {
        let mut mask = sources.present;
        while mask != 0 {
            let sample = mask.trailing_zeros() as usize;
            source_over(simd, &mut dst[sample], sources.colors[sample], 1.0);
            mask &= mask - 1;
        }
    }
}

#[cfg(test)]
impl Samples<fearless_simd::Fallback> {
    pub(super) fn new() -> Self {
        Self::with_simd(fearless_simd::Fallback::new())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::canvas::blend;

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

#[cfg(test)]
mod backend_tests {
    use super::*;

    // Independent component loop, kept outside the SIMD-generic pipeline.
    fn reference(dst: &mut [f32; 4], src: [f32; 4], coverage: f32) {
        let alpha = src[3] * coverage;
        for channel in 0..4 {
            dst[channel] = src[channel] * coverage + dst[channel] * (1.0 - alpha);
        }
    }

    fn check<S: Simd>(simd: S) {
        let values = [
            0.0,
            -0.0,
            f32::from_bits(1),
            -f32::from_bits(1),
            f32::MIN_POSITIVE,
            -f32::MIN_POSITIVE,
            0.5_f32.next_down(),
            0.5,
            0.5_f32.next_up(),
            -3.25,
            2.5,
            1e20,
            -1e20,
        ];
        let coverages = [0.0, -0.0, f32::from_bits(1), 0.125, 0.5, 1.0];
        let mut tile = Samples::with_simd(simd);
        let mut expected = [[0.0; 4]; 16];
        for (index, &value) in values.iter().enumerate() {
            for alpha in [0.0, -0.0, f32::from_bits(1), 0.25, 0.5, 1.0] {
                let clear = [value, -value, values[(index + 3) % values.len()], alpha];
                for collapse in [false, true] {
                    tile.reset(clear, collapse);
                    expected.fill(clear);
                    for turn in 0..32 {
                        let source = [
                            values[(index + turn) % values.len()],
                            -value,
                            values[(index + 7) % values.len()],
                            alpha,
                        ];
                        let coverage =
                            std::array::from_fn(|i| coverages[(i + turn) % coverages.len()]);
                        tile.blend(255, source, coverage);
                        for (sample, coverage) in expected.iter_mut().zip(coverage) {
                            if coverage > 0.0 {
                                reference(sample, source, coverage);
                            }
                        }
                        // Compare every working sample as well as the unchanged
                        // sequential f64 reduction; quantization cannot hide a bit.
                        assert_eq!(
                            tile.samples[255 * 16..256 * 16]
                                .iter()
                                .map(|c| c.map(f32::to_bits))
                                .collect::<Vec<_>>(),
                            expected.map(|c| c.map(f32::to_bits)),
                            "{:?}",
                            simd.level()
                        );
                        assert_eq!(
                            tile.color(255).map(f32::to_bits),
                            sample_mean(&expected).map(f32::to_bits)
                        );
                        let sources: [Option<[f32; 4]>; 16] =
                            std::array::from_fn(|i| ((i + turn) % 3 != 0).then_some(source));
                        tile.blend_sources(255, &Sources::from_fn(|i| sources[i]));
                        for (sample, source) in expected.iter_mut().zip(sources) {
                            if let Some(source) = source {
                                reference(sample, source, 1.0);
                            }
                        }
                        assert_eq!(
                            tile.color(255).map(f32::to_bits),
                            sample_mean(&expected).map(f32::to_bits)
                        );
                    }
                }
            }
        }
        // Presence describes geometry, not source opacity: Some(transparent)
        // performs source-over and changes -0, while None preserves old bits.
        let clear = [-0.0; 4];
        for mask in 0..=u16::MAX {
            tile.reset(clear, true);
            let sources = Sources::from_fn(|index| (mask & (1 << index) != 0).then_some([0.0; 4]));
            tile.blend_sources(255, &sources);
            expected.fill(clear);
            for (index, sample) in expected.iter_mut().enumerate() {
                if mask & (1 << index) != 0 {
                    reference(sample, [0.0; 4], 1.0);
                }
            }
            assert_eq!(
                tile.color(255).map(f32::to_bits),
                sample_mean(&expected).map(f32::to_bits)
            );
            if mask != 0 && mask != u16::MAX {
                assert!(
                    tile.samples[255 * 16..256 * 16]
                        .iter()
                        .zip(expected)
                        .all(|(a, b)| a.map(f32::to_bits) == b.map(f32::to_bits)),
                    "{:?}, presence={mask:x}",
                    simd.level()
                );
            }
        }
        assert_eq!(std::mem::size_of::<Sources>(), 260);
        assert_eq!(std::mem::align_of::<Sources>(), 4);
        assert_eq!(std::mem::size_of::<[Option<[f32; 4]>; 16]>(), 320);
        // Backend tokens are zero-sized. Sample storage has exactly the prior
        // 16-byte RGBA records and promotion bitmap, with no dispatch header.
        assert_eq!(std::mem::size_of::<S>(), 0);
        assert_eq!(std::mem::size_of::<Samples<S>>(), 16 * 256 * 17 + 32);
    }

    #[test]
    fn every_supported_backend_preserves_working_sample_bits_and_storage_size() {
        check(fearless_simd::Fallback::new());
        let level = fearless_simd::Level::new();
        #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
        {
            if let Some(simd) = level.as_sse2() {
                check(simd);
            }
            if let Some(simd) = level.as_sse4_2() {
                check(simd);
            }
            if let Some(simd) = level.as_avx2() {
                check(simd);
            }
            if let Some(simd) = level.as_avx512() {
                check(simd);
            }
        }
        #[cfg(target_arch = "aarch64")]
        if let Some(simd) = level.as_neon() {
            check(simd);
        }
        #[cfg(all(target_arch = "wasm32", target_feature = "simd128"))]
        if let Some(simd) = level.as_wasm_simd128() {
            check(simd);
        }
        eprintln!("executed supported backends up to {level:?}");
    }
}
