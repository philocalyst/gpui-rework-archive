//! One authoritative CPU scratch owner, allocated only when rasterizing.
use super::{DisplayList, TILE};

#[derive(Default)]
pub(super) struct RasterScratch {
    offsets: Vec<usize>,
    indices: Vec<u32>,
    cursor: Vec<usize>,
    // Canvas axes are at most 16384px: tile endpoints fit in 0..=1024.
    // All-zero bounds cannot describe a nonempty render, so also mean invalid.
    bounds: [u16; 4],
}
impl RasterScratch {
    pub(super) fn invalidate(&mut self) {
        self.bounds = [0; 4];
    }
    pub(super) fn bytes(&self) -> usize {
        self.offsets.capacity() * size_of::<usize>()
            + self.cursor.capacity() * size_of::<usize>()
            + self.indices.capacity() * size_of::<u32>()
    }
    /// Physical tile lookup uses the cached origin/stride, independently of
    /// the requested subrectangle that controls worker and output traversal.
    #[inline]
    pub(super) fn tile(&self, x: usize, y: usize) -> &[u32] {
        let [left, top, right, bottom] = self.bounds.map(usize::from);
        debug_assert!(x >= left && x < right && y >= top && y < bottom);
        let tile = (y - top) * (right - left) + x - left;
        &self.indices[self.offsets[tile]..self.offsets[tile + 1]]
    }
    /// Retain unpruned command membership, never color/occlusion certificates.
    /// The scene owner invalidates this at each structural commit; admitted
    /// color patches leave geometry, order and resource membership unchanged.
    pub(super) fn prepare(&mut self, commands: &DisplayList, bounds: [usize; 4]) -> bool {
        debug_assert!(bounds[0] < bounds[2] && bounds[1] < bounds[3]);
        debug_assert!(bounds.iter().all(|&edge| edge <= 16_384 / TILE));
        let key = bounds.map(|edge| edge as u16);
        // Any subrectangle uses the same unpruned membership. In particular,
        // a full raster primes every later regional repair until structural
        // invalidation. Never enlarge a first regional request speculatively.
        if key[0] >= self.bounds[0]
            && key[1] >= self.bounds[1]
            && key[2] <= self.bounds[2]
            && key[3] <= self.bounds[3]
        {
            return true;
        }
        // Invalidate before any allocation: catching an allocation panic must
        // not make a partially rebuilt CSR appear reusable.
        self.invalidate();
        let tiles = (bounds[2] - bounds[0]) * (bounds[3] - bounds[1]);
        self.offsets.clear();
        self.offsets.resize(tiles + 1, 0);
        for command_bounds in commands.ordered_bounds() {
            visit_tiles(command_bounds, bounds, |tile| self.offsets[tile + 1] += 1);
        }
        for i in 1..self.offsets.len() {
            self.offsets[i] += self.offsets[i - 1];
        }
        self.indices.clear();
        self.indices.resize(*self.offsets.last().unwrap(), 0);
        // Counting cursor is O(tile count), never O(pixel count).
        self.cursor.clear();
        self.cursor.extend_from_slice(&self.offsets[..tiles]);
        for (index, command_bounds) in commands.ordered_bounds().enumerate() {
            visit_tiles(command_bounds, bounds, |tile| {
                self.indices[self.cursor[tile]] = index as u32;
                self.cursor[tile] += 1;
            });
        }
        self.bounds = key;
        false
    }
}

// Integer bounds were clipped and admitted before append; this projection
// preserves the previous floor/ceil tile intersection and painter ordinal.
#[inline]
fn visit_tiles(command_bounds: [u16; 4], tile_bounds: [usize; 4], mut visit: impl FnMut(usize)) {
    let [x, y, r, b] = command_bounds.map(usize::from);
    let columns = tile_bounds[2] - tile_bounds[0];
    for ty in (y / TILE).max(tile_bounds[1])..b.div_ceil(TILE).min(tile_bounds[3]) {
        for tx in (x / TILE).max(tile_bounds[0])..r.div_ceil(TILE).min(tile_bounds[2]) {
            visit((ty - tile_bounds[1]) * columns + tx - tile_bounds[0]);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Canvas, ColorConfig};

    #[test]
    fn bounds_projection_and_csr_match_independent_command_membership() {
        use crate::{Affine, AlphaMode, Color, Image, ImageSampling, Rect};
        let mut canvas = Canvas::recording(65, 49, ColorConfig::default()).unwrap();
        let clip = Rect::new(1.25, 2.5, 62.0, 44.0);
        for i in 0..9 {
            canvas
                .fill_rounded_rect(
                    Rect::new(-3.5 + i as f32 * 7.0, i as f32 * 3.25, 19.5, 13.5),
                    i as f32,
                    Affine {
                        c: 0.125,
                        ..Affine::IDENTITY
                    },
                    clip,
                    Color::BLACK,
                )
                .unwrap();
        }
        // Exercise both private address forms without loading a shared font
        // in this unit binary (the font lifecycle oracle owns that registry).
        let draw = canvas.commands.inline[0];
        canvas.commands.append(
            draw.common,
            [super::super::PendingDraw {
                geometry: draw.geometry,
                source: super::super::RECT_SOURCE,
            }],
            true,
            Vec::new(),
        );
        let image = Image::linear_srgb(
            1,
            1,
            AlphaMode::Straight,
            Box::new([[0.25, 0.5, 0.75, 0.5]]),
        )
        .unwrap();
        canvas
            .draw_image(
                &image,
                Rect::new(34.5, 23.0, 30.0, 24.0),
                Affine::IDENTITY,
                clip,
                ImageSampling::Linear,
            )
            .unwrap();
        let commands = &canvas.commands;
        assert!(!commands.inline.is_empty());
        assert!(!commands.placements.is_empty());
        let expected: Vec<_> = commands.iter().map(|c| c.bounds).collect();
        assert_eq!(commands.ordered_bounds().len(), expected.len());
        assert!(
            commands
                .ordered_bounds()
                .map(|b| b.map(usize::from))
                .eq(expected.iter().copied())
        );
        assert!(
            commands
                .ordered_bounds()
                .rev()
                .map(|b| b.map(usize::from))
                .eq(expected.iter().rev().copied())
        );
        for bounds in [[0, 0, 5, 4], [1, 1, 4, 3], [3, 2, 5, 4], [0, 0, 1, 1]] {
            let mut scratch = RasterScratch::default();
            assert!(!scratch.prepare(commands, bounds));
            let columns = bounds[2] - bounds[0];
            for ty in bounds[1]..bounds[3] {
                for tx in bounds[0]..bounds[2] {
                    // Independent intersection/ordinal walk, with no CSR count
                    // or cursor code and no resource/material projection.
                    let members: Vec<_> = expected
                        .iter()
                        .enumerate()
                        .filter_map(|(i, &[l, t, r, b])| {
                            (l / TILE <= tx
                                && r.div_ceil(TILE) > tx
                                && t / TILE <= ty
                                && b.div_ceil(TILE) > ty)
                                .then_some(i as u32)
                        })
                        .collect();
                    let tile = (ty - bounds[1]) * columns + tx - bounds[0];
                    assert_eq!(
                        &scratch.indices[scratch.offsets[tile]..scratch.offsets[tile + 1]],
                        members
                    );
                }
            }
        }
    }

    #[test]
    fn recording_has_no_scratch_allocation_and_first_raster_charges_one_owner() {
        let mut canvas = None;
        let recording = allocation_counter::measure(|| {
            canvas = Some(Canvas::recording(32, 32, ColorConfig::default()).unwrap());
        });
        let mut canvas = canvas.unwrap();
        assert!(canvas.raster.is_none());
        assert_eq!((recording.count_total, recording.bytes_total), (0, 0));
        canvas.clear(crate::Color::WHITE);
        let first = allocation_counter::measure(|| {
            canvas.render_bgrx(&mut [0; 32 * 32]).unwrap();
        });
        let warm = allocation_counter::measure(|| {
            canvas.render_bgrx(&mut [0; 32 * 32]).unwrap();
        });
        assert_eq!((warm.count_total, warm.bytes_total), (0, 0));
        eprintln!(
            "raster_headers,Canvas={},Scratch={},RenderStats={},Frame={}",
            size_of::<Canvas>(),
            size_of::<RasterScratch>(),
            size_of::<super::super::RenderStats>(),
            size_of::<super::super::Frame<'_>>()
        );
        eprintln!(
            "raster_allocations,first_requests={},first_bytes={},retained={},csr_bytes={},warm_requests={},warm_bytes={}",
            first.count_total,
            first.bytes_total,
            first.bytes_current,
            canvas.bin_bytes(),
            warm.count_total,
            warm.bytes_total
        );
        #[cfg(target_pointer_width = "64")]
        {
            assert_eq!(size_of::<Canvas>(), 488);
            assert_eq!(size_of::<RasterScratch>(), 80);
            assert_eq!(size_of::<super::super::RenderStats>(), 96);
            assert_eq!(size_of::<super::super::Frame<'_>>(), 88);
            assert_eq!(
                first.bytes_current as usize,
                size_of::<RasterScratch>() + canvas.bin_bytes()
            );
        }
    }
}
