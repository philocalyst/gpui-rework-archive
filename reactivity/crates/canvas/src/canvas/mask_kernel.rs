//! Four lattice x sites share y/clip terms before producing a compact mask.
//! Fallback and hardware backends instantiate the same ordered f64 operations.
use super::{BorrowedCommand, BorrowedSource, Mapping, RenderStats, SAMPLES};
use fearless_simd::{Simd, f64x4, prelude::*};
use fearless_simd_macros::simd;

#[inline(always)]
fn x_terms<S: Simd>(simd: S, map: Mapping, x: f64x4<S>) -> [f64x4<S>; 2] {
    [
        f64x4::splat(simd, map.inverse[0]) * x,
        f64x4::splat(simd, map.inverse[1]) * x,
    ]
}

#[inline(always)]
fn local_row<S: Simd>(simd: S, map: Mapping, x: [f64x4<S>; 2], y: f64) -> [f64x4<S>; 2] {
    // Keep both cross terms, including signed zeros, and Mapping::local's
    // multiply/add order. Separate operators never request fused arithmetic.
    [
        x[0] + f64x4::splat(simd, map.inverse[2] * y) + map.inverse[4],
        x[1] + f64x4::splat(simd, map.inverse[3] * y) + map.inverse[5],
    ]
}

#[simd]
pub(super) fn coverage<S: Simd>(
    simd: S,
    command: &BorrowedCommand<'_>,
    x: usize,
    y: usize,
    stats: &mut RenderStats,
) -> u16 {
    let x_pixel = x;
    stats.sample_tests += 16;
    let world_x = f64x4::from_fn(simd, |lane| x as f64 + SAMPLES[lane]);
    let clip_x = world_x.simd_ge(command.clip.x as f64)
        & world_x.simd_lt(command.clip.x as f64 + command.clip.width as f64);
    let x = x_terms(simd, command.map, world_x);
    let r = command.rect;
    let (rx, ry, width, height) = (r.x as f64, r.y as f64, r.width as f64, r.height as f64);
    let radius = match command.source {
        BorrowedSource::Rect => 0.0,
        BorrowedSource::Rounded(radius) => (radius as f64).min(width * 0.5).min(height * 0.5),
        _ => unreachable!("binary coverage belongs to primitive shapes"),
    };
    let mut mask = 0;
    for (row, offset) in SAMPLES.into_iter().enumerate() {
        let world_y = y as f64 + offset;
        if world_y < command.clip.y as f64
            || world_y >= command.clip.y as f64 + command.clip.height as f64
        {
            continue;
        }
        let [lx, ly] = local_row(simd, command.map, x, world_y);
        let mut inside = clip_x
            & lx.simd_ge(rx)
            & lx.simd_lt(rx + width)
            & ly.simd_ge(ry)
            & ly.simd_lt(ry + height);
        if radius > 0.0 {
            // Identical to rounded::contains. Admission bounds inverse entries
            // to 1e12 and rect/world positions to finite magnitudes; these
            // products and squared distances fit comfortably in f64.
            let px = lx - rx;
            let py = ly - ry;
            let radius_v = f64x4::splat(simd, radius);
            let dx = (radius_v - px).max(px - (width - radius)).max(0.0);
            let dy = (radius_v - py).max(py - (height - radius)).max(0.0);
            inside &= (dx * dx + dy * dy).simd_le(radius * radius);
        }
        mask |= (inside.to_bitmask() as u16) << (row * 4);
    }
    mask & command
        .clip_chain
        .map_or(u16::MAX, |chain| chain.mask(simd, x_pixel, y, stats))
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::canvas::sample;
    use crate::{Affine, Rect};

    fn check<S: Simd>(simd: S) {
        let maps = [
            Affine::IDENTITY,
            Affine {
                a: -1.0,
                b: -0.0,
                c: 0.0,
                d: 1.0,
                tx: 32.0,
                ty: -0.0,
            },
            Affine {
                a: 1.0,
                b: 0.0,
                c: -0.0,
                d: -1.0,
                tx: -0.0,
                ty: 32.0,
            },
            Affine {
                a: 1.0,
                b: 0.25,
                c: -0.5,
                d: 1.0,
                tx: 0.125,
                ty: 0.375,
            },
            Affine {
                a: -0.7,
                b: -0.3,
                c: 0.2,
                d: 1.3,
                tx: 31.125,
                ty: -0.375,
            },
            Affine {
                a: 0.000001,
                b: -0.0,
                c: 0.0,
                d: 1.0,
                tx: 0.125,
                ty: 0.375,
            },
            Affine {
                a: f32::from_bits(1),
                b: 1.0,
                c: -1.0,
                d: -0.0,
                tx: 32.0,
                ty: 0.0,
            },
        ];
        for transform in maps {
            // Exercise exact AND of correlated prefixes on every supported
            // backend, including a proven rectangular prefix below two equal
            // rounded clips. No independently filtered alpha is multiplied.
            let mut canvas = crate::Canvas::recording(64, 64, Default::default()).unwrap();
            let rect = Rect::new(0.125, 0.375, 31.5, 30.5);
            let parent = canvas
                .create_clip(
                    None,
                    crate::ClipShape::Rect(Rect::new(0., 0., 64., 64.)),
                    Affine::IDENTITY,
                )
                .unwrap();
            let parent = canvas
                .create_clip(
                    Some(parent),
                    crate::ClipShape::RoundedRect { rect, radius: 7.25 },
                    transform,
                )
                .unwrap();
            let clip = canvas
                .create_clip(
                    Some(parent),
                    crate::ClipShape::RoundedRect { rect, radius: 7.25 },
                    transform,
                )
                .unwrap();
            let geometry = canvas.clip_geometry().unwrap();
            let chain = geometry.chain(clip).unwrap();
            let command = BorrowedCommand {
                rect: Rect::new(0., 0., 64., 64.),
                map: Mapping::new(Affine::IDENTITY).unwrap(),
                clip: Rect::new(0., 0., 64., 64.),
                clip_chain: Some(chain),
                source: BorrowedSource::Rect,
                color: [1.; 4],
                bounds: [0, 0, 64, 64],
            };
            for y in 0..64 {
                for x in 0..64 {
                    assert_eq!(
                        coverage(simd, &command, x, y, &mut RenderStats::default()),
                        chain.sample_mask(x as u32, y as u32),
                        "clip AND {:?} {transform:?} {x},{y}",
                        simd.level()
                    );
                }
            }
            let map = Mapping::new(transform).unwrap();
            for world_x in [
                [0.0, -0.0, 1.0, -1.0],
                [
                    f64::from_bits(1),
                    -f64::from_bits(1),
                    16_383.875,
                    1_000_000.125,
                ],
            ] {
                for world_y in [0.0, -0.0, 0.125, -1.0, 16_383.875] {
                    let x = f64x4::from_slice(simd, &world_x);
                    let [actual_x, actual_y] = local_row(simd, map, x_terms(simd, map, x), world_y);
                    for lane in 0..4 {
                        let expected = map.local(world_x[lane], world_y);
                        assert_eq!(
                            (actual_x[lane].to_bits(), actual_y[lane].to_bits()),
                            (expected.0.to_bits(), expected.1.to_bits()),
                            "{:?}, {transform:?}",
                            simd.level()
                        );
                    }
                }
            }
            for rect in [
                Rect::new(0.0, 0.0, 32.0, 32.0),
                Rect::new(0.125, 0.375, 15.875, 12.3),
                Rect::new(-10.0, 2.0, 25.0, 5.0),
                Rect::new(0.125, 0.125, f32::from_bits(1), 1.0),
            ] {
                for clip in [
                    Rect::new(-0.0, 0.0, 64.0, 64.0),
                    Rect::new(0.125, 0.375, 17.0, 20.0),
                    Rect::new(0.125_f32.next_down(), 0.375_f32.next_up(), 31.0, 31.0),
                ] {
                    for radius in [0.0, -0.0, f32::from_bits(1), 0.125, 3.25, f32::MAX] {
                        for source in [BorrowedSource::Rect, BorrowedSource::Rounded(radius)] {
                            let command = BorrowedCommand {
                                clip_chain: None,
                                rect,
                                clip,
                                map,
                                source,
                                color: [0.0; 4],
                                bounds: [0, 0, 64, 64],
                            };
                            for (x, y) in [
                                (0, 0),
                                (1, 3),
                                (7, 11),
                                (15, 16),
                                (17, 23),
                                (31, 31),
                                (63, 0),
                            ] {
                                let mut stats = RenderStats::default();
                                let actual = coverage(simd, &command, x, y, &mut stats);
                                let expected = sample(&command, x, y, &mut RenderStats::default())
                                    .into_iter()
                                    .enumerate()
                                    .fold(0u16, |mask, (i, c)| mask | (u16::from(c > 0.0) << i));
                                assert_eq!(
                                    actual,
                                    expected,
                                    "{:?}, {transform:?}, {rect:?}, {clip:?}, radius={radius}, pixel={x},{y}",
                                    simd.level()
                                );
                                assert_eq!(stats.sample_tests, 16);
                            }
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn every_supported_backend_matches_mapping_bits_and_all_primitive_sites() {
        eprintln!(
            "clip mask backend: Fallback; detected {:?}",
            fearless_simd::Level::new()
        );
        check(fearless_simd::Fallback::new());
        let level = fearless_simd::Level::new();
        #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
        {
            if let Some(s) = level.as_sse2() {
                check(s);
            }
            if let Some(s) = level.as_sse4_2() {
                check(s);
            }
            if let Some(s) = level.as_avx2() {
                check(s);
            }
            if let Some(s) = level.as_avx512() {
                check(s);
            }
        }
        #[cfg(target_arch = "aarch64")]
        if let Some(s) = level.as_neon() {
            check(s);
        }
        #[cfg(all(target_arch = "wasm32", target_feature = "simd128"))]
        if let Some(s) = level.as_wasm_simd128() {
            check(s);
        }
    }
}
