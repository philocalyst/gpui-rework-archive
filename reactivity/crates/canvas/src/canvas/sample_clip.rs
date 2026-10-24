//! Pair entry/exit cuts in the same exact binary-lifting kernel.
use super::Mapping;
use crate::Rect;
use fearless_simd::{Simd, f64x2, prelude::*};
use fearless_simd_macros::simd;

#[simd]
pub(super) fn lower<S: Simd>(
    simd: S,
    map: &Mapping,
    rect: Rect,
    clip: Rect,
    viewport: [u32; 2],
) -> Rect {
    if rect.is_empty() || clip.is_empty() {
        return Rect::default();
    }
    let exit = f64x2::from_fn(simd, |lane| lane as f64).simd_gt(0.0);
    let mut intervals = [[0_u32; 2]; 2];
    for (axis, interval) in intervals.iter_mut().enumerate() {
        let (minimum, extent, clip_start, clip_extent) = if axis == 0 {
            (rect.x, rect.width, clip.x, clip.width)
        } else {
            (rect.y, rect.height, clip.y, clip.height)
        };
        let minimum = f64::from(minimum);
        let maximum = minimum + f64::from(extent);
        let clip_start = f64::from(clip_start);
        let clips = f64x2::from_fn(simd, |lane| {
            clip_start + lane as f64 * f64::from(clip_extent)
        });
        let scale = map.inverse[axis * 3];
        let negative = f64x2::splat(simd, scale).simd_lt(0.0);
        let edges =
            (exit ^ negative).select(f64x2::splat(simd, maximum), f64x2::splat(simd, minimum));
        let cross = map.inverse[2 - axis] * 0.125;
        let count = viewport[axis] * 4;
        let mut step = f64::from(1_u32 << (31 - count.leading_zeros()));
        let mut position = f64x2::splat(simd, -1.0);
        while step >= 1.0 {
            // Position and step are exact integers; no lane conversion or
            // rounded midpoint operation is needed inside this loop.
            let candidate = position + step;
            let world = candidate * 0.25 + 0.125;
            let local = world * scale + cross + map.inverse[axis + 4];
            let mapped = local.simd_ge(edges) ^ negative;
            let clipped = world.simd_ge(clips);
            let predicate = (clipped & mapped) | (exit & (clipped | mapped));
            position =
                (candidate.simd_lt(f64::from(count)) & !predicate).select(candidate, position);
            step *= 0.5;
        }
        let mut cuts = [0.0; 2];
        (position + 1.0).store_slice(&mut cuts);
        *interval = cuts.map(|cut| cut as u32);
        if interval[1] <= interval[0] {
            return Rect::default();
        }
    }
    let [[left, right], [top, bottom]] = intervals;
    Rect::new(
        left as f32 * 0.25,
        top as f32 * 0.25,
        (right - left) as f32 * 0.25,
        (bottom - top) as f32 * 0.25,
    )
}
