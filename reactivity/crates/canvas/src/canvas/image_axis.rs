//! Exact separable taps; each of the sixteen correlated samples still blends.
use super::{BorrowedCommand, RenderStats, SAMPLES, Samples, TILE};
use crate::image::{ImageSampling, ImageView, lerp};
use fearless_simd::Simd;
#[derive(Clone, Copy)]
struct Tap {
    low: u32,
    high: u32,
    fraction: f32,
}
const OUTSIDE: Tap = Tap {
    low: u32::MAX,
    high: u32::MAX,
    // Unread for outside taps. All-one bytes let the caller initialize the
    // bounded tap array in place instead of materializing repeated records.
    fraction: f32::from_bits(u32::MAX),
};
struct Axes {
    columns: [[Tap; 4]; TILE],
    rows: [[Tap; 4]; TILE],
}
impl Axes {
    #[cfg(test)]
    fn new(
        command: &BorrowedCommand<'_>,
        tile: [usize; 4],
        image: ImageView<'_>,
        sampling: ImageSampling,
        stats: &mut RenderStats,
    ) -> Self {
        let mut result = Self {
            columns: [[OUTSIDE; 4]; TILE],
            rows: [[OUTSIDE; 4]; TILE],
        };
        result.fill(command, tile, image, sampling, stats);
        result
    }
    fn fill(
        &mut self,
        command: &BorrowedCommand<'_>,
        tile: [usize; 4],
        image: ImageView<'_>,
        sampling: ImageSampling,
        stats: &mut RenderStats,
    ) {
        for (axis, taps) in [&mut self.columns, &mut self.rows].into_iter().enumerate() {
            let (scale, translation, minimum, extent, clip, clip_extent, cells) = if axis == 0 {
                (
                    command.map.inverse[0],
                    command.map.inverse[4],
                    command.rect.x,
                    command.rect.width,
                    command.clip.x,
                    command.clip.width,
                    image.width(),
                )
            } else {
                (
                    command.map.inverse[3],
                    command.map.inverse[5],
                    command.rect.y,
                    command.rect.height,
                    command.clip.y,
                    command.clip.height,
                    image.height(),
                )
            };
            let ratio = f64::from(cells) / f64::from(extent);
            for pixel in
                tile[axis].max(command.bounds[axis])..tile[axis + 2].min(command.bounds[axis + 2])
            {
                for (sample, offset) in SAMPLES.into_iter().enumerate() {
                    stats.sample_tests += 1;
                    let world = pixel as f64 + offset;
                    if world < f64::from(clip) || world >= f64::from(clip) + f64::from(clip_extent)
                    {
                        continue;
                    }
                    // Same subtraction and ratio-first normalization as sample_with.
                    // Omitting a zero cross term can only alter a zero sign;
                    // neither membership nor integer/fraction taps then differ.
                    let position = (scale * world + translation) - f64::from(minimum);
                    if position < 0.0 || position >= f64::from(extent) {
                        continue;
                    }
                    let coordinate = position * ratio;
                    taps[pixel - tile[axis]][sample] = if sampling == ImageSampling::Nearest {
                        let cell = (coordinate as u32).min(cells - 1);
                        Tap {
                            low: cell,
                            high: cell,
                            fraction: 0.0,
                        }
                    } else {
                        let coordinate = coordinate - 0.5;
                        let floor = coordinate.floor();
                        let clamp = |v: f64| v.max(0.0).min(f64::from(cells - 1)) as u32;
                        Tap {
                            low: clamp(floor),
                            high: clamp(floor + 1.0),
                            fraction: (coordinate - floor) as f32,
                        }
                    };
                }
            }
        }
    }
}
struct Horizontal {
    row: u32,
    colors: [[f32; 4]; 4],
}
struct Column {
    taps: [Tap; 4],
    rows: [Horizontal; 2],
}
impl Column {
    fn new(taps: [Tap; 4]) -> Self {
        Self {
            taps,
            rows: std::array::from_fn(|_| Horizontal {
                row: u32::MAX,
                colors: [[0.; 4]; 4],
            }),
        }
    }
    fn fill(&mut self, row: u32, linear: bool, texel: &mut impl FnMut(usize, usize) -> [f32; 4]) {
        let entry = &mut self.rows[(row & 1) as usize];
        if entry.row == row {
            return;
        }
        for (color, tap) in entry.colors.iter_mut().zip(self.taps) {
            if tap.low == u32::MAX {
                continue;
            }
            let low = texel(tap.low as usize, row as usize);
            *color = if linear {
                lerp(low, texel(tap.high as usize, row as usize), tap.fraction)
            } else {
                low
            };
        }
        entry.row = row;
    }
    fn sources(
        &mut self,
        rows: [Tap; 4],
        linear: bool,
        texel: &mut impl FnMut(usize, usize) -> [f32; 4],
    ) -> [Option<[f32; 4]>; 16] {
        let mut result = [None; 16];
        for (sy, row) in rows.into_iter().enumerate() {
            if row.low == u32::MAX {
                continue;
            }
            self.fill(row.low, linear, texel);
            if linear {
                self.fill(row.high, linear, texel);
            }
            // Adjacent (or clamped identical) rows cannot collide in parity.
            // The full row key proves reuse, including reflected scans.
            let low = &self.rows[(row.low & 1) as usize].colors;
            let high = &self.rows[(row.high & 1) as usize].colors;
            for sx in 0..4 {
                if self.taps[sx].low == u32::MAX {
                    continue;
                }
                result[sy * 4 + sx] = Some(if linear {
                    lerp(low[sx], high[sx], row.fraction)
                } else {
                    low[sx]
                });
            }
        }
        result
    }
}
// Image-only scratch stays out of image-free raster frames; no owning lease or
// heap allocation is created. Pixel traversal changes, sample/painter order does not.
#[inline(never)]
pub(super) fn render<S: Simd>(
    samples: &mut Samples<S>,
    command: &BorrowedCommand<'_>,
    tile: [usize; 4],
    stats: &mut RenderStats,
    image: ImageView<'_>,
    sampling: ImageSampling,
    mut texel: impl FnMut(usize, usize) -> [f32; 4],
) {
    debug_assert!(command.map.axis_aligned());
    let mut axes = Axes {
        columns: [[OUTSIDE; 4]; TILE],
        rows: [[OUTSIDE; 4]; TILE],
    };
    axes.fill(command, tile, image, sampling, stats);
    let linear = sampling == ImageSampling::Linear;
    for x in tile[0].max(command.bounds[0])..tile[2].min(command.bounds[2]) {
        let mut column = Column::new(axes.columns[x - tile[0]]);
        for y in tile[1].max(command.bounds[1])..tile[3].min(command.bounds[3]) {
            let sources = column.sources(axes.rows[y - tile[1]], linear, &mut texel);
            samples.blend_sources((y - tile[1]) * TILE + x - tile[0], sources);
            stats.boundary_pixels += 1;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::canvas::{BorrowedSource, Mapping, render_image};
    use crate::{Affine, AlphaMode, Image, ImageProfile, Rect};

    fn images() -> Vec<Image> {
        let mut images = Vec::new();
        for (width, height) in [(1, 1), (7, 11), (33, 17)] {
            for profile in [ImageProfile::Srgb, ImageProfile::DisplayP3] {
                for alpha in [AlphaMode::Straight, AlphaMode::Premultiplied] {
                    let bytes = (0..width * height)
                        .flat_map(|i| {
                            let a = [0, 1, 127, 255][i as usize % 4];
                            let mut rgb =
                                [(i * 29) as u8, (i * 57 + 31) as u8, (i * 13 + 89) as u8];
                            if alpha == AlphaMode::Premultiplied {
                                rgb = rgb.map(|v| v.min(a));
                            }
                            [rgb[0], rgb[1], rgb[2], a]
                        })
                        .collect::<Vec<_>>()
                        .into_boxed_slice();
                    images.push(Image::rgba8(width, height, profile, alpha, bytes).unwrap());
                }
            }
        }
        images.push(
            Image::linear_srgb(
                7,
                11,
                AlphaMode::Premultiplied,
                (0..77)
                    .map(|i| {
                        [
                            f32::from_bits(0x80000001 + i),
                            if i % 2 == 0 { -0.0 } else { 1e19 },
                            -0.25,
                            0.75,
                        ]
                    })
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            )
            .unwrap(),
        );
        images
    }
    fn bits(v: Option<[f32; 4]>) -> Option<[u32; 4]> {
        v.map(|v| v.map(f32::to_bits))
    }

    #[test]
    fn every_correlated_sample_matches_generic_inverse_filter_and_decoder_bits() {
        for image in images() {
            for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
                for (a, d, tx, ty) in [
                    (1., 1., 0., 0.),
                    (-1., 1., 16.125, 0.),
                    (1., -1., 0., 16.375),
                    (-0.7, -1.7, 17., 23.),
                    (0.3, 2.25, 0.125, 0.375),
                    (3.1, 0.7, -1.125, 0.125f32.next_up()),
                    (1e-10, 1., 0.125, 0.),
                    (1., 1., -1_000_000., -1_000_000.),
                ] {
                    for (b, c) in [(0., 0.), (-0., 0.), (0., -0.), (-0., -0.)] {
                        let map = Mapping::new(Affine { a, b, c, d, tx, ty }).unwrap();
                        for rect in [
                            Rect::new(0., 0., 23.7, 19.3),
                            Rect::new(0.125, 0.375, 1., 1.),
                            Rect::new(1_000_000., 1_000_000., 25., 19.),
                            Rect::new(0., 0., 1e-20, 2.),
                        ] {
                            let command = BorrowedCommand {
                                rect,
                                clip: Rect::new(
                                    0.125f32.next_down(),
                                    0.375f32.next_up(),
                                    23.5,
                                    24.,
                                ),
                                map,
                                source: BorrowedSource::ImageLinear(&image),
                                color: [0.; 4],
                                bounds: [1, 2, 29, 31],
                            };
                            let tile = [0, 0, 16, 16];
                            let axes = Axes::new(
                                &command,
                                tile,
                                image.view(),
                                sampling,
                                &mut RenderStats::default(),
                            );
                            for x in 1..16 {
                                let mut column = Column::new(axes.columns[x]);
                                for y in 2..16 {
                                    let actual = column.sources(
                                        axes.rows[y],
                                        sampling == ImageSampling::Linear,
                                        &mut |x, y| image.view().texel(x, y),
                                    );
                                    for i in 0..16 {
                                        let wx = x as f64 + SAMPLES[i % 4];
                                        let wy = y as f64 + SAMPLES[i / 4];
                                        let expected = if wx < f64::from(command.clip.x)
                                            || wy < f64::from(command.clip.y)
                                            || wx
                                                >= f64::from(command.clip.x)
                                                    + f64::from(command.clip.width)
                                            || wy
                                                >= f64::from(command.clip.y)
                                                    + f64::from(command.clip.height)
                                        {
                                            None
                                        } else {
                                            let (lx, ly) = map.local(wx, wy);
                                            image.view().sample(
                                                lx - f64::from(rect.x),
                                                ly - f64::from(rect.y),
                                                f64::from(rect.width),
                                                f64::from(rect.height),
                                                sampling,
                                            )
                                        };
                                        assert_eq!(
                                            bits(actual[i]),
                                            bits(expected),
                                            "a={a} d={d} b={b:?} c={c:?} rect={rect:?} pixel={x},{y} sample={i}"
                                        );
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn whole_tile_overlaps_match_generic_painter_order_and_partial_tiles() {
        let images = images();
        for tile in [[0, 0, 16, 16], [16, 0, 29, 15], [0, 16, 1, 29]] {
            let mut actual = Samples::new();
            let mut expected = Samples::new();
            actual.reset([-0., 0.25, 3., 0.75], true);
            expected.reset([-0., 0.25, 3., 0.75], true);
            for (i, image) in images.iter().enumerate() {
                for sampling in [ImageSampling::Linear, ImageSampling::Nearest] {
                    let rect = Rect::new(0.125, 0.375, 31.7, 29.3);
                    let command = BorrowedCommand {
                        rect,
                        clip: Rect::new(0.375, 0.125, 28.5, 30.),
                        map: Mapping::new(Affine {
                            a: if i % 2 == 0 { 1. } else { -1. },
                            tx: if i % 2 == 0 { 0. } else { 31. },
                            ..Affine::IDENTITY
                        })
                        .unwrap(),
                        source: BorrowedSource::ImageLinear(image),
                        color: [0.; 4],
                        bounds: [1, 2, 30, 31],
                    };
                    render(
                        &mut actual,
                        &command,
                        tile,
                        &mut RenderStats::default(),
                        image.view(),
                        sampling,
                        |x, y| image.view().texel(x, y),
                    );
                    render_image(
                        &mut expected,
                        &command,
                        tile,
                        &mut RenderStats::default(),
                        |x, y| {
                            image.view().sample(
                                x,
                                y,
                                rect.width as f64,
                                rect.height as f64,
                                sampling,
                            )
                        },
                    );
                }
            }
            for y in 0..tile[3] - tile[1] {
                for x in 0..tile[2] - tile[0] {
                    assert_eq!(
                        actual.color(y * TILE + x).map(f32::to_bits),
                        expected.color(y * TILE + x).map(f32::to_bits)
                    );
                }
            }
        }
    }
}

#[cfg(test)]
mod work_tests {
    use super::*;
    use crate::canvas::{BorrowedSource, Mapping};
    use crate::{Affine, AlphaMode, Image, ImageProfile, Rect};
    #[test]
    fn setup_is_per_axis_and_adjacent_filter_rows_are_reused_without_allocation() {
        let image = Image::rgba8(
            2,
            2,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![17, 31, 91, 255, 3, 5, 7, 127, 9, 11, 13, 63, 19, 23, 29, 0].into_boxed_slice(),
        )
        .unwrap();
        let command = BorrowedCommand {
            rect: Rect::new(0., 0., 32., 32.),
            clip: Rect::new(0., 0., 32., 32.),
            map: Mapping::new(Affine::IDENTITY).unwrap(),
            source: BorrowedSource::ImageLinear(&image),
            color: [0.; 4],
            bounds: [0, 0, 32, 32],
        };
        let mut samples = Samples::new();
        for (sampling, expected_calls) in
            [(ImageSampling::Nearest, 64), (ImageSampling::Linear, 256)]
        {
            let mut stats = RenderStats::default();
            let mut calls = 0;
            let allocation = allocation_counter::measure(|| {
                render(
                    &mut samples,
                    &command,
                    [0, 0, 16, 16],
                    &mut stats,
                    image.view(),
                    sampling,
                    |x, y| {
                        calls += 1;
                        image.view().texel(x, y)
                    },
                )
            });
            assert_eq!(calls, expected_calls);
            assert_eq!(stats.sample_tests, 128);
            assert_eq!(stats.boundary_pixels, 256);
            assert_eq!(allocation.count_total, 0);
        }
    }
}
