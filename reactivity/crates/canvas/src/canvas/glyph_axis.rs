//! Factor axis-aligned mask reconstruction into shared column/row addresses.
//! These are the original sixteen sample sites, not averaged glyph coverage.
use super::{BorrowedCommand, BorrowedSource, RenderStats, SAMPLES, TILE};
use crate::text::Raster;

const OUTSIDE: usize = usize::MAX;

pub(super) struct GlyphAxis<'a> {
    mask: &'a Raster,
    columns: [[usize; 4]; TILE],
    rows: [[usize; 4]; TILE],
}

impl<'a> GlyphAxis<'a> {
    pub(super) fn new(
        command: &BorrowedCommand<'a>,
        tile: [usize; 4],
        stats: &mut RenderStats,
    ) -> Option<Self> {
        debug_assert!(command.map.axis_aligned());
        let BorrowedSource::Glyph(mask) = command.source else {
            return None;
        };
        if mask.metrics.width == 0 || mask.metrics.height == 0 {
            return None;
        }
        let mut result = Self {
            mask,
            columns: [[OUTSIDE; 4]; TILE],
            rows: [[OUTSIDE; 4]; TILE],
        };
        let mut any = [false; 2];
        for (axis, addresses) in [&mut result.columns, &mut result.rows]
            .into_iter()
            .enumerate()
        {
            let (scale, translation, minimum, extent, clip, clip_extent, cells) = if axis == 0 {
                (
                    command.map.inverse[0],
                    command.map.inverse[4],
                    command.rect.x,
                    command.rect.width,
                    command.clip.x,
                    command.clip.width,
                    mask.metrics.width,
                )
            } else {
                (
                    command.map.inverse[3],
                    command.map.inverse[5],
                    command.rect.y,
                    command.rect.height,
                    command.clip.y,
                    command.clip.height,
                    mask.metrics.height,
                )
            };
            let ratio = cells as f64 / extent as f64;
            let first = tile[axis].max(command.bounds[axis]);
            let end = tile[axis + 2].min(command.bounds[axis + 2]);
            for pixel in first..end {
                for (sample, offset) in SAMPLES.into_iter().enumerate() {
                    stats.sample_tests += 1;
                    let world = pixel as f64 + offset;
                    if world < clip as f64 || world >= clip as f64 + clip_extent as f64 {
                        continue;
                    }
                    // Keep mask_sample's subtraction and normalization order.
                    // Omitting the zero off-diagonal term can only alter a zero
                    // sign, which cannot change membership or the cell address.
                    let position = (scale * world + translation) - minimum as f64;
                    if position < 0.0 || position >= extent as f64 {
                        continue;
                    }
                    let cell = ((position * ratio) as usize).min(cells - 1);
                    addresses[pixel - tile[axis]][sample] = if axis == 0 {
                        cell
                    } else {
                        cell * mask.metrics.width
                    };
                    any[axis] = true;
                }
            }
        }
        (any[0] && any[1]).then_some(result)
    }

    #[inline]
    pub(super) fn coverage(&self, x: usize, y: usize) -> [f32; 16] {
        let columns = self.columns[x];
        let rows = self.rows[y];
        let at = |column, row| {
            if column == OUTSIDE || row == OUTSIDE {
                0.0
            } else {
                self.mask.pixels[row + column] as f32 / 255.0
            }
        };
        if columns.iter().all(|&column| column == columns[0])
            && rows.iter().all(|&row| row == rows[0])
        {
            [at(columns[0], rows[0]); 16]
        } else {
            std::array::from_fn(|index| at(columns[index % 4], rows[index / 4]))
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::canvas::{Mapping, sample};
    use crate::text::RasterMetrics;
    use crate::{Affine, GlyphKey, Rect};

    #[test]
    fn clipped_command_bounds_and_signed_zero_axes_match_scalar_samples() {
        let mask = Raster {
            key: GlyphKey::fixture(),
            metrics: RasterMetrics {
                width: 7,
                height: 11,
                ..Default::default()
            },
            pixels: (0..77).map(|i| (i * 113 + 17) as u8).collect(),
        };
        for b in [0.0, -0.0] {
            for c in [0.0, -0.0] {
                let command = BorrowedCommand {
                    rect: Rect::new(0.125, 0.375, 22.7, 19.3),
                    clip: Rect::new(0.375, 0.125, 21.5, 25.0),
                    map: Mapping::new(Affine {
                        b,
                        c,
                        ..Affine::IDENTITY
                    })
                    .unwrap(),
                    source: BorrowedSource::Glyph(&mask),
                    color: [0.0; 4],
                    bounds: [0; 4],
                };
                for bounds in [
                    [0, 0, 32, 32],
                    [3, 5, 9, 13],
                    [17, 1, 23, 3],
                    [31, 31, 32, 32],
                    [0, 0, 0, 0],
                ] {
                    let command = BorrowedCommand { bounds, ..command };
                    for tile in [[0, 0, 16, 16], [16, 0, 29, 15], [0, 16, 1, 29]] {
                        let axis = GlyphAxis::new(&command, tile, &mut RenderStats::default());
                        for y in tile[1].max(bounds[1])..tile[3].min(bounds[3]) {
                            for x in tile[0].max(bounds[0])..tile[2].min(bounds[2]) {
                                let actual = axis.as_ref().map_or([0.0; 16], |axis| {
                                    axis.coverage(x - tile[0], y - tile[1])
                                });
                                let expected = sample(&command, x, y, &mut RenderStats::default());
                                assert_eq!(
                                    actual.map(f32::to_bits),
                                    expected.map(f32::to_bits),
                                    "bounds={bounds:?} tile={tile:?} b={b:?} c={c:?}"
                                );
                            }
                        }
                        if tile[0].max(bounds[0]) >= tile[2].min(bounds[2])
                            || tile[1].max(bounds[1]) >= tile[3].min(bounds[3])
                        {
                            assert!(axis.is_none());
                        }
                    }
                }
            }
        }
    }

    #[test]
    fn shared_mask_addresses_match_every_original_scalar_sample() {
        for (width, height) in [(1, 1), (7, 11), (19, 17)] {
            let mask = Raster {
                key: GlyphKey::fixture(),
                metrics: RasterMetrics {
                    width,
                    height,
                    ..Default::default()
                },
                pixels: (0..width * height).map(|i| (i * 113 + 17) as u8).collect(),
            };
            for sx in [-3.1, -1.0, -0.7, 0.3, 1.0, 3.1] {
                for sy in [-1.7, 1.0, 2.25] {
                    for (tx, ty) in [
                        (0.0, 0.0),
                        (0.125, 0.375),
                        (0.125f32.next_up(), (-0.125f32).next_down()),
                        (-1_000_000.0, -1_000_000.0),
                    ] {
                        let map = Mapping::new(Affine {
                            a: sx,
                            b: -0.0,
                            c: 0.0,
                            d: sy,
                            tx,
                            ty,
                        })
                        .unwrap();
                        for rect in [
                            Rect::new(0.0, 0.0, 32.0, 32.0),
                            Rect::new(0.125, 0.375, 15.875, 2.3),
                            Rect::new(-10.0, 2.0, 25.0, 5.0),
                            Rect::new(1_000_000.0 + 0.125, 1_000_000.0 + 0.375, 20.0, 20.0),
                            Rect::new(0.125, 0.125, f32::from_bits(1), 1.0),
                        ] {
                            for clip in [
                                Rect::new(-0.0, 0.0, 32.0, 32.0),
                                Rect::new(0.125, 0.375, 17.0, 20.0),
                                Rect::new(0.125f32.next_down(), 0.375f32.next_up(), 31.0, 31.0),
                            ] {
                                let command = BorrowedCommand {
                                    rect,
                                    clip,
                                    map,
                                    source: BorrowedSource::Glyph(&mask),
                                    color: [0.0; 4],
                                    bounds: [0, 0, 32, 32],
                                };
                                for tile in [[0, 0, 16, 16], [16, 16, 31, 29], [0, 4, 1, 5]] {
                                    let axis =
                                        GlyphAxis::new(&command, tile, &mut RenderStats::default());
                                    for y in tile[1]..tile[3] {
                                        for x in tile[0]..tile[2] {
                                            let reference =
                                                sample(&command, x, y, &mut RenderStats::default());
                                            let actual = axis.as_ref().map_or([0.0; 16], |axis| {
                                                axis.coverage(x - tile[0], y - tile[1])
                                            });
                                            assert_eq!(
                                                actual.map(f32::to_bits),
                                                reference.map(f32::to_bits),
                                                "{width}x{height} scale={sx},{sy} translation={tx},{ty} rect={rect:?} clip={clip:?} pixel={x},{y}"
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
    }
}
