//! Pixels begin with one exact working color. Only divergent sample coverage
//! promotes a pixel to sixteen independently composited colors. No averaging
//! occurs before all commands have painted, preserving overlap correlation.
#[cfg(test)]
use super::sample_mean;
use super::{TILE, sample_mean_at};
use fearless_simd::{Simd, f32x4, f32x16, mask32x16, prelude::*};
use fearless_simd_macros::simd;

const PIXELS: usize = TILE * TILE;

pub(super) struct Samples<S: Simd> {
    simd: S,
    uniform: [[f32; 4]; PIXELS],
    samples: [[[f32; 16]; 4]; PIXELS],
    mixed: [u64; PIXELS / 64],
}
impl<S: Simd> Samples<S> {
    pub(super) fn with_simd(simd: S) -> Self {
        Self {
            simd,
            uniform: [[0.0; 4]; PIXELS],
            samples: [[[0.0; 16]; 4]; PIXELS],
            mixed: [0; PIXELS / 64],
        }
    }

    pub(super) fn reset(&mut self, color: [f32; 4], collapse: bool) {
        if collapse {
            self.uniform.fill(color);
            self.mixed.fill(0);
        } else {
            self.samples.fill(color.map(|channel| [channel; 16]));
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
            self.samples[pixel] = self.uniform[pixel].map(|channel| [channel; 16]);
            self.mixed[pixel / 64] |= bit;
        }
        blend_coverage(self.simd, &mut self.samples[pixel], color, coverage);
    }

    /// Binary primitive coverage stays compact until the vector predicate.
    #[inline]
    pub(super) fn blend_mask(&mut self, pixel: usize, color: [f32; 4], mask: u16) {
        if mask == 0 {
            return;
        }
        let bit = 1 << (pixel % 64);
        if self.mixed[pixel / 64] & bit == 0 {
            if mask == u16::MAX {
                blend_one(self.simd, &mut self.uniform[pixel], color, 1.0);
                return;
            }
            self.samples[pixel] = self.uniform[pixel].map(|channel| [channel; 16]);
            self.mixed[pixel / 64] |= bit;
        }
        blend_mask(self.simd, &mut self.samples[pixel], color, mask);
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
                    blend_one(self.simd, &mut self.uniform[pixel], source, 1.0);
                }
                return;
            }
            self.samples[pixel] = self.uniform[pixel].map(|channel| [channel; 16]);
            self.mixed[pixel / 64] |= bit;
        }
        blend_sources(self.simd, &mut self.samples[pixel], sources);
    }

    #[inline]
    pub(super) fn color(&self, pixel: usize) -> [f32; 4] {
        if self.mixed[pixel / 64] & (1 << (pixel % 64)) == 0 {
            // Sixteen identical finite f32 values sum exactly in f64, including
            // the signed-zero rule of the reference's first-sample seed.
            self.uniform[pixel]
        } else {
            sample_mean_at(|sample| {
                std::array::from_fn(|channel| self.samples[pixel][channel][sample])
            })
        }
    }
}

// Mixed pixels store four 16-sample channel planes. Each kernel loads coverage
// once and shares alpha and predicates across RGBA; safe unaligned loads have
// exactly 16 lanes, so no tail, image-wide transpose, or extra tile storage exists.
#[inline(always)]
fn source_over<S: Simd, V: SimdFloat<S, Element = f32>>(
    simd: S,
    dst: V,
    src: V,
    alpha: V,
    coverage: V,
) -> V {
    let alpha = alpha * coverage;
    let source = src * coverage;
    let backdrop = dst * (V::splat(simd, 1.0) - alpha);
    source + backdrop
}

#[simd]
fn blend_one<S: Simd>(simd: S, dst: &mut [f32; 4], src: [f32; 4], coverage: f32) {
    source_over(
        simd,
        f32x4::from_slice(simd, dst),
        f32x4::from_slice(simd, &src),
        f32x4::splat(simd, src[3]),
        f32x4::splat(simd, coverage),
    )
    .store_slice(dst);
}

#[simd]
fn blend_mask<S: Simd>(simd: S, dst: &mut [[f32; 16]; 4], src: [f32; 4], mask: u16) {
    let present = mask32x16::from_bitmask(simd, u64::from(mask));
    let alpha = f32x16::splat(simd, src[3]);
    let coverage = f32x16::splat(simd, 1.0);
    for (destination, source) in dst.iter_mut().zip(src) {
        let old = f32x16::from_slice(simd, destination);
        let painted = source_over(simd, old, f32x16::splat(simd, source), alpha, coverage);
        // Preserve old lane bits, including negative zero, when absent.
        present.select(painted, old).store_slice(destination);
    }
}

#[simd]
fn blend_coverage<S: Simd>(simd: S, dst: &mut [[f32; 16]; 4], src: [f32; 4], coverage: [f32; 16]) {
    let coverage = f32x16::from_slice(simd, &coverage);
    let alpha = f32x16::splat(simd, src[3]);
    let present = coverage.simd_gt(0.0);
    for (destination, source) in dst.iter_mut().zip(src) {
        let old = f32x16::from_slice(simd, destination);
        let painted = source_over(simd, old, f32x16::splat(simd, source), alpha, coverage);
        present.select(painted, old).store_slice(destination);
    }
}

#[simd]
fn blend_sources<S: Simd>(simd: S, dst: &mut [[f32; 16]; 4], sources: [Option<[f32; 4]>; 16]) {
    // Image sampling produces AoS optional colors. Pack each present source
    // exactly once into bounded per-pixel planes, accounting for this gather
    // in whole-render image controls as well as primitive controls.
    let mut colors = [[0.0; 16]; 4];
    let mut present = 0u16;
    for (index, source) in sources.into_iter().enumerate() {
        if let Some(source) = source {
            present |= 1 << index;
            for (plane, value) in colors.iter_mut().zip(source) {
                plane[index] = value;
            }
        }
    }
    if present == 0 {
        return;
    }
    let present = mask32x16::from_bitmask(simd, u64::from(present));
    let alpha = f32x16::from_slice(simd, &colors[3]);
    for (destination, source) in dst.iter_mut().zip(colors) {
        let old = f32x16::from_slice(simd, destination);
        let painted = source_over(
            simd,
            old,
            f32x16::from_slice(simd, &source),
            alpha,
            f32x16::splat(simd, 1.0),
        );
        present.select(painted, old).store_slice(destination);
    }
}

#[cfg(test)]
impl<S: Simd> Samples<S> {
    fn sample_bits(&self, pixel: usize, sample: usize) -> [u32; 4] {
        std::array::from_fn(|channel| self.samples[pixel][channel][sample].to_bits())
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
                            (0..16)
                                .map(|i| tile.sample_bits(255, i))
                                .collect::<Vec<_>>(),
                            expected.map(|c| c.map(f32::to_bits)),
                            "{:?}",
                            simd.level()
                        );
                        assert_eq!(
                            tile.color(255).map(f32::to_bits),
                            sample_mean(&expected).map(f32::to_bits)
                        );
                        let sources =
                            std::array::from_fn(|i| ((i + turn) % 3 != 0).then_some(source));
                        tile.blend_sources(255, sources);
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
        // Every binary coverage mask, including all 16 samples, must
        // preserve the exact old bits in absent lanes after SIMD selection.
        let clear = [-0.0, f32::from_bits(1), -f32::from_bits(1), 0.75];
        let source = [1.5, -0.125, 0.25, 0.5];
        for mask in 0..=u16::MAX {
            tile.reset(clear, true);
            tile.blend_mask(255, source, mask);
            expected.fill(clear);
            for (index, sample) in expected.iter_mut().enumerate() {
                if mask & (1 << index) != 0 {
                    reference(sample, source, 1.0);
                }
            }
            assert_eq!(
                tile.color(255).map(f32::to_bits),
                sample_mean(&expected).map(f32::to_bits)
            );
            if mask != 0 && mask != u16::MAX {
                assert!(
                    (0..16)
                        .zip(expected)
                        .all(|(i, b)| tile.sample_bits(255, i) == b.map(f32::to_bits)),
                    "{:?}, mask={mask:x}",
                    simd.level()
                );
            }
        }
        // Backend tokens are zero-sized. Sample storage has exactly the prior
        // floating-point payloads and promotion bitmap, with no dispatch header.
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
