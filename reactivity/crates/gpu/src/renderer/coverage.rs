//! A draw-level enclosure of the existing rounded tile predicate.
use super::{PreparedDraw, tile_bounds};

#[derive(Clone, Copy)]
struct Interval {
    low: f64,
    high: f64,
}
impl Interval {
    fn point(value: f64) -> Option<Self> {
        Self::checked(value, value)
    }
    fn checked(low: f64, high: f64) -> Option<Self> {
        // Nonzero subnormal endpoints decline the filter, including outward
        // steps into the subnormal band. A box crossing zero already encloses
        // zero and every value that a flush-to-zero operation could produce.
        if low > high
            || [low, high]
                .iter()
                .any(|value| !value.is_finite() || (*value != 0.0 && !value.is_normal()))
        {
            return None;
        }
        Some(Self { low, high })
    }
    fn outward(low: f64, high: f64) -> Option<Self> {
        Self::checked(low.next_down(), high.next_up())
    }
    fn scale(self, value: f64) -> Option<Self> {
        Self::point(value)?;
        if value == 0.0 || (self.low == 0.0 && self.high == 0.0) {
            return Self::point(0.0);
        }
        let (low, high) = if value > 0.0 {
            (self.low * value, self.high * value)
        } else {
            (self.high * value, self.low * value)
        };
        Self::outward(low, high)
    }
    fn add(self, other: Self) -> Option<Self> {
        if other.low == 0.0 && other.high == 0.0 {
            return Some(self);
        }
        if self.low == 0.0 && self.high == 0.0 {
            return Some(other);
        }
        Self::outward(self.low + other.low, self.high + other.high)
    }
    fn subtract(self, other: Self) -> Option<Self> {
        self.add(Self {
            low: -other.high,
            high: -other.low,
        })
    }
}

fn axis(
    x: Interval,
    y: Interval,
    [a, b, c]: [f64; 3],
    origin: f64,
    extent: f64,
    scale: f64,
    error: f64,
) -> Option<bool> {
    let origin = Interval::point(origin)?;
    let extent = Interval::point(extent)?;
    // Each node encloses both its exact and rounded operation over all inputs
    // in the prior node's interval. Induction therefore encloses the old
    // rounded expression, not just the ideal affine plane. Contracting a
    // product/add removes a rounding already enclosed; arbitrary fast-math
    // reassociation is not part of either predicate's compilation contract.
    let position = x
        .scale(a)?
        .add(y.scale(b)?)?
        .add(Interval::point(c)?)?
        .subtract(origin)?;
    let magnitude = x
        .scale(a.abs())?
        .add(y.scale(b.abs())?)?
        .add(Interval::point(c.abs())?)?
        .add(Interval::point(origin.low.abs())?)?
        .add(Interval::point(extent.low.abs())?)?
        .add(Interval::point(1.0)?)?;
    let margin = magnitude.scale(scale)?.add(Interval::point(error)?)?;
    Some(position.low > margin.high && extent.subtract(position)?.low > margin.high)
}

fn certificate(
    draw: PreparedDraw<'_>,
    error: [f32; 2],
    columns: usize,
    width: u32,
    height: u32,
) -> Option<bool> {
    if !draw.source.is_solid() || error.iter().any(|e| !e.is_finite() || *e < 0.0) {
        return None;
    }
    let bounds = draw.bounds;
    let (x, y) = (bounds.x as usize, bounds.y as usize);
    let right = x.checked_add(bounds.width as usize)?.checked_sub(1)?;
    let bottom = y.checked_add(bounds.height as usize)?.checked_sub(1)?;
    if columns == 0 || bounds.width < 1.0 || bounds.height < 1.0 {
        return None;
    }
    // These are visit's casts and inclusive integer endpoints. Expand to the
    // full visited tiles, not to the draw AABB; tile_bounds also clips the
    // final viewport row/column exactly as the existing per-tile predicate.
    let [left, top, _, _] = tile_bounds(y / 16 * columns + x / 16, columns, width, height);
    let [_, _, right, bottom] =
        tile_bounds(bottom / 16 * columns + right / 16, columns, width, height);
    let clip = draw.clip;
    if f64::from(clip.x) > f64::from(left)
        || f64::from(clip.y) > f64::from(top)
        || f64::from(clip.x) + f64::from(clip.width) < f64::from(right)
        || f64::from(clip.y) + f64::from(clip.height) < f64::from(bottom)
    {
        return Some(false);
    }
    let x = Interval::checked(f64::from(left) + 0.125, f64::from(right) - 0.125)?;
    let y = Interval::checked(f64::from(top) + 0.125, f64::from(bottom) - 0.125)?;
    let local = draw.local_rect;
    for (i, origin, extent) in [(0, local.x, local.width), (1, local.y, local.height)] {
        let canonical = [draw.inverse[i], draw.inverse[i + 2], draw.inverse[i + 4]];
        for (coefficients, scale, allowance) in [
            (
                canonical.map(|v| f64::from(v as f32)),
                16.0 * f64::from(f32::EPSILON),
                f64::from(error[i]),
            ),
            (canonical, 32.0 * f64::EPSILON, 0.0),
        ] {
            if !axis(
                x,
                y,
                coefficients,
                f64::from(origin),
                f64::from(extent),
                scale,
                allowance,
            )? {
                return Some(false);
            }
        }
    }
    Some(true)
}

pub(super) fn whole(
    draw: PreparedDraw<'_>,
    error: [f32; 2],
    columns: usize,
    width: u32,
    height: u32,
) -> bool {
    certificate(draw, error, columns, width, height).unwrap_or(false)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::renderer::{full_tile, validate_draw, visit};
    use gpui_canvas::{PreparedSource, Rect};

    fn draw(width: u32, height: u32) -> PreparedDraw<'static> {
        PreparedDraw {
            local_rect: Rect::new(-1.0, -1.0, width as f32 + 2.0, height as f32 + 2.0),
            inverse: [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
            clip: Rect::new(0.0, 0.0, width as f32, height as f32),
            bounds: Rect::new(0.0, 0.0, width as f32, height as f32),
            color: [0.25, -0.0, 3.0, 0.5],
            source: PreparedSource::Solid,
        }
    }

    fn implication(draw: PreparedDraw<'_>, width: u32, height: u32) -> bool {
        let Ok(error) = validate_draw(draw, 0, width, height) else {
            return false;
        };
        let columns = width.div_ceil(16) as usize;
        if !whole(draw, error, columns, width, height) {
            return false;
        }
        visit(draw, columns, |tile| {
            assert!(
                full_tile(draw, error, tile, columns, width, height),
                "global certificate failed old rounded predicate: tile={tile}, size={width}x{height}, draw={draw:?}, error={error:?}"
            );
        });
        true
    }

    #[test]
    fn complete_visited_box_including_partial_final_tiles_is_certified() {
        for (width, height) in [(1, 1), (17, 19), (65, 33), (512, 256), (8192, 1024)] {
            assert!(
                implication(draw(width, height), width, height),
                "{width}x{height}"
            );
        }
        assert!(
            validate_draw(draw(16384, 1024), 0, 16384, 1024).is_err(),
            "the old precision admission independently rejects this large transform"
        );
        let mut shifted = draw(81, 49);
        shifted.bounds = Rect::new(17.0, 17.0, 47.0, 30.0);
        assert!(implication(shifted, 81, 49));
        // Bounds select complete tiles. A geometry matching only the bounds
        // must not certify the extra sample points in those visited tiles.
        shifted.local_rect = shifted.bounds;
        assert!(!whole(shifted, [0.0; 2], 6, 81, 49));
    }

    #[test]
    fn exhaustive_dyadic_geometry_has_an_independent_integer_sample_oracle() {
        let mut accepted = 0;
        // All coefficients have denominator 16, all sample positions 8.
        // The integer oracle uses denominator 128, independent of both proof
        // implementations and of f64 multiply/add evaluation.
        for width in 1..=49 {
            for height in [1, 15, 16, 17, 31, 33] {
                for shear in [-2, -1, 0, 1, 2] {
                    for flip in [-1, 1] {
                        let mut value = draw(width, height);
                        value.inverse = [
                            flip as f64,
                            0.0,
                            shear as f64 / 16.0,
                            1.0,
                            if flip < 0 { f64::from(width) } else { 0.0 },
                            0.0,
                        ];
                        value.local_rect =
                            Rect::new(-16.0, -1.0, width as f32 + 32.0, height as f32 + 2.0);
                        if !implication(value, width, height) {
                            continue;
                        }
                        accepted += 1;
                        for y in 0..height * 4 {
                            for x in 0..width * 4 {
                                let sx = i64::from(x * 2 + 1);
                                let sy = i64::from(y * 2 + 1);
                                let tx = if flip < 0 { i64::from(width) * 128 } else { 0 };
                                let local_x = i64::from(flip) * sx * 16
                                    + i64::from(shear) * sy
                                    + tx
                                    + 16 * 128;
                                let local_y = sy * 16 + 128;
                                assert!(0 < local_x && local_x < (i64::from(width) + 32) * 128);
                                assert!(0 < local_y && local_y < (i64::from(height) + 2) * 128);
                            }
                        }
                    }
                }
            }
        }
        assert!(
            accepted > 2000,
            "exercise actual nontrivial certificates: {accepted}"
        );
    }

    #[test]
    fn rounded_implication_survives_boundaries_clips_cancellation_and_corrections() {
        let mut accepted = 0;
        let mut rejected = 0;
        let transforms = [
            [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
            [-1.0, 0.0, 0.0, 1.0, 65.0, 0.0],
            [1.0, 0.0, 0.0, -1.0, 0.0, 33.0],
            [1.0, 0.125, -0.25, 1.0, 4.0, -2.0],
            [0.75, 0.5, -0.5, 0.75, 16.0, 0.0],
            [
                1.0000000000000002,
                0.0,
                0.0,
                0.9999999999999999,
                0.12500000000000003,
                0.0,
            ],
            [16.0, 0.0, 0.0, 0.0625, -64.0, 0.0],
            [1.0, 0.0, -1.0, 1.0, 32.0, 0.0],
        ];
        for width in [15, 16, 17, 31, 32, 33, 63, 64, 65] {
            for height in [15, 16, 17, 31, 32, 33] {
                for inverse in transforms {
                    for inset in [-16.0_f32, -1.0, -0.125, 0.0, 0.125, 0.125_f32.next_up()] {
                        for clip_delta in [-f32::EPSILON, 0.0, f32::EPSILON] {
                            let mut value = draw(width, height);
                            value.inverse = inverse;
                            value.local_rect = Rect::new(
                                inset,
                                inset,
                                width as f32 - inset * 2.0,
                                height as f32 - inset * 2.0,
                            );
                            value.clip.width += clip_delta;
                            if implication(value, width, height) {
                                accepted += 1;
                            } else {
                                rejected += 1;
                            }
                        }
                    }
                }
            }
        }
        assert!(
            accepted > 1000 && rejected > 1000,
            "both filter outcomes required: {accepted}/{rejected}"
        );
    }

    #[test]
    fn binary_boundary_fuzz_preserves_the_old_rounded_predicate() {
        let mut seed = 0x46b9_d5ca_1732_85e1_u64;
        let mut accepted = 0;
        for _ in 0..8192 {
            seed ^= seed << 13;
            seed ^= seed >> 7;
            seed ^= seed << 17;
            let width = 1 + (seed as u32 % 129);
            let height = 1 + ((seed >> 32) as u32 % 65);
            let scale = 2.0_f64.powi(((seed >> 16) % 17) as i32 - 8);
            let low = ((seed >> 8) as i32 % 17) as f64 * f64::EPSILON;
            let mut value = draw(width, height);
            value.inverse = [
                scale + low,
                0.0,
                scale * (seed % 5) as f64 / 64.0,
                scale,
                -low,
                low,
            ];
            let inset = -(((seed >> 40) % 5) as f32);
            value.local_rect = Rect::new(
                inset,
                inset,
                (width as f32 + 8.0) * scale as f32 - inset * 2.0,
                (height as f32 + 8.0) * scale as f32 - inset * 2.0,
            );
            if seed & 1 != 0 {
                value.local_rect.x = value.local_rect.x.next_up();
            }
            if seed & 2 != 0 {
                value.clip.width = value.clip.width.next_down();
            }
            accepted += usize::from(implication(value, width, height));
        }
        assert!(
            accepted > 1000,
            "binary cases need real fast-path acceptance: {accepted}"
        );
    }

    #[test]
    fn intervals_enclose_separate_and_fused_rounded_operations() {
        for a in [
            -1e100,
            -1024.0,
            -1.0,
            -0.0,
            0.0,
            1.0,
            1.0_f64.next_up(),
            1024.0,
            1e100,
        ] {
            for b in [-1e100, -1.0, -0.0, 0.0, 1.0, 1e100] {
                for c in [-1e100, -1.0, -0.0, 0.0, 1.0, 1e100] {
                    let result = Interval::point(b)
                        .and_then(|v| v.scale(a))
                        .and_then(|v| v.add(Interval::point(c)?));
                    if let Some(interval) = result {
                        for value in [a * b + c, a.mul_add(b, c)] {
                            assert!(interval.low <= value && value <= interval.high);
                        }
                    }
                }
            }
        }
        for value in [
            f64::NAN,
            f64::INFINITY,
            f64::NEG_INFINITY,
            f64::from_bits(1),
            -f64::from_bits(1),
        ] {
            assert!(Interval::point(value).is_none());
        }
        assert!(
            Interval::point(f64::MIN_POSITIVE)
                .unwrap()
                .scale(0.5)
                .is_none()
        );
        assert!(Interval::point(f64::MAX).unwrap().scale(2.0).is_none());
    }
}
