//! One authoritative CPU scratch owner, allocated only when rasterizing.
use super::{DisplayList, TILE};

// Admission bounds the sum of full-viewport references before recording.
// A regional CSR is a subset. Offsets/cursors never require pointer width.
const _: () = assert!(super::MAX_REFERENCES < u32::MAX as usize);
const _: () = assert!(super::MAX_COMMANDS < u32::MAX as usize);

#[derive(Default)]
pub(super) struct RasterScratch {
    membership: Membership,
    // Construction cursors become lazy opaque-prefix certificates once the
    // immutable CSR is complete. MAX means this physical tile is unexamined.
    cursor: Vec<u32>,
}
#[derive(Default)]
pub(super) struct Membership {
    offsets: Vec<u32>,
    indices: Vec<u32>,
    // Canvas axes are at most 16384px: tile endpoints fit in 0..=1024.
    // All-zero bounds cannot describe a nonempty render, so also mean invalid.
    bounds: [u16; 4],
}
impl Membership {
    pub(super) fn columns(&self) -> usize {
        usize::from(self.bounds[2] - self.bounds[0])
    }
    pub(super) fn left(&self) -> usize {
        usize::from(self.bounds[0])
    }
    /// Physical tile lookup uses the cached origin/stride, independently of
    /// the requested subrectangle that controls worker and output traversal.
    #[inline]
    pub(super) fn tile(&self, x: usize, y: usize) -> &[u32] {
        let [left, top, right, bottom] = self.bounds.map(usize::from);
        debug_assert!(x >= left && x < right && y >= top && y < bottom);
        let tile = (y - top) * (right - left) + x - left;
        &self.indices[self.offsets[tile] as usize..self.offsets[tile + 1] as usize]
    }
}
impl RasterScratch {
    pub(super) fn invalidate(&mut self) {
        self.membership.bounds = [0; 4];
    }
    pub(super) fn bytes(&self) -> usize {
        self.membership.offsets.capacity() * size_of::<u32>()
            + self.cursor.capacity() * size_of::<u32>()
            + self.membership.indices.capacity() * size_of::<u32>()
    }
    /// Split immutable geometry from writable proof rows. A worker receives
    /// only its own rows; no lock, atomics, aliasing or additional owner exists.
    pub(super) fn rows(&mut self, bounds: [usize; 4]) -> (&Membership, &mut [u32]) {
        let stride = self.membership.columns();
        let first = (bounds[1] - usize::from(self.membership.bounds[1])) * stride;
        let count = (bounds[3] - bounds[1]) * stride;
        (&self.membership, &mut self.cursor[first..first + count])
    }
    /// Retain unpruned command membership and lazily computed opaque cuts.
    /// Color patches preserve exact alpha, order and geometry. Structural
    /// mutation invalidates both before either can become observable again.
    pub(super) fn prepare(&mut self, commands: &DisplayList, bounds: [usize; 4]) -> bool {
        debug_assert!(bounds[0] < bounds[2] && bounds[1] < bounds[3]);
        debug_assert!(bounds.iter().all(|&edge| edge <= 16_384 / TILE));
        let key = bounds.map(|edge| edge as u16);
        let cached = self.membership.bounds;
        if key[0] >= cached[0] && key[1] >= cached[1] && key[2] <= cached[2] && key[3] <= cached[3]
        {
            return true;
        }
        // Invalidate before any allocation: catching an allocation panic must
        // not make a partially rebuilt CSR appear reusable.
        self.invalidate();
        let Self {
            membership: bins,
            cursor,
        } = self;
        let tiles = (bounds[2] - bounds[0]) * (bounds[3] - bounds[1]);
        bins.offsets.clear();
        bins.offsets.resize(tiles + 1, 0);
        for command_bounds in commands.ordered_bounds() {
            visit_tiles(command_bounds, bounds, |tile| bins.offsets[tile + 1] += 1);
        }
        for i in 1..bins.offsets.len() {
            bins.offsets[i] += bins.offsets[i - 1];
        }
        bins.indices.clear();
        bins.indices
            .resize(*bins.offsets.last().unwrap() as usize, 0);
        cursor.clear();
        cursor.extend_from_slice(&bins.offsets[..tiles]);
        for (index, command_bounds) in commands.ordered_bounds().enumerate() {
            visit_tiles(command_bounds, bounds, |tile| {
                bins.indices[cursor[tile] as usize] = index as u32;
                cursor[tile] += 1;
            });
        }
        cursor.fill(u32::MAX);
        bins.bounds = key;
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
        let common = canvas.commands.inline[0].common;
        let geometry = canvas.commands.inline[0].geometry;
        canvas.commands.append(
            common,
            [super::super::PendingDraw {
                geometry,
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
                        &scratch.membership.indices[scratch.membership.offsets[tile] as usize
                            ..scratch.membership.offsets[tile + 1] as usize],
                        members
                    );
                }
            }
        }
    }

    #[test]
    fn opaque_certificates_follow_physical_tiles_and_exact_alpha() {
        use crate::{Affine, Color, DamageRegion, PaintEdit, Rect};
        let clip = Rect::new(0.0, 0.0, 64.0, 48.0);
        let mut canvas = Canvas::recording(64, 48, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        // Every tile has opaque command 0. Only (1, 1) has opaque command 2.
        for (rect, color) in [
            (clip, Color::BLACK),
            (clip, Color::rgba(255, 0, 0, 128)),
            (Rect::new(16.0, 16.0, 16.0, 16.0), Color::WHITE),
            (clip, Color::rgba(0, 255, 0, 128)),
        ] {
            canvas
                .fill_rect(rect, Affine::IDENTITY, clip, color)
                .unwrap();
        }
        let index = canvas.paint_index(2).unwrap();
        let mut words = [0; 64 * 48];
        // A proof-disabled raster constructs membership but no certificates.
        canvas.set_tile_proofs(false);
        canvas.render_bgrx(&mut words).unwrap();
        assert!(
            canvas
                .raster
                .as_ref()
                .unwrap()
                .cursor
                .iter()
                .all(|&cut| cut == u32::MAX)
        );
        canvas.set_tile_proofs(true);
        let damage = DamageRegion::checked_canvas_bounds([16, 16, 32, 32]);
        canvas.render_bgrx_region(&mut words, damage).unwrap();
        let cuts = &canvas.raster.as_ref().unwrap().cursor;
        for (tile, &cut) in cuts.iter().enumerate() {
            assert_eq!(cut, if tile == 5 { 2 } else { u32::MAX });
        }
        let edits = [PaintEdit::new(index, Color::rgb(30, 70, 140))];
        canvas.prepare_paint(&edits).unwrap().commit();
        canvas.render_bgrx_region(&mut words, damage).unwrap();
        assert_eq!(canvas.raster.as_ref().unwrap().cursor[5], 2);
        let edits = [PaintEdit::new(index, Color::rgba(30, 70, 140, 128))];
        assert!(canvas.prepare_paint(&edits).is_err());
        assert_eq!(canvas.raster.as_ref().unwrap().cursor[5], 2);
        canvas.render_bgrx(&mut words).unwrap();
        let cuts = &canvas.raster.as_ref().unwrap().cursor;
        for (tile, &cut) in cuts.iter().enumerate() {
            assert_eq!(cut, if tile == 5 { 2 } else { 0 });
        }
        // Re-evaluate with the existing exhaustive path as an independent
        // oracle; proof mode changes do not revoke same-geometry certificates.
        let expected = words;
        canvas.set_tile_proofs(false);
        canvas.render_bgrx(&mut words).unwrap();
        assert_eq!(words, expected);
        canvas.set_tile_proofs(true);
        canvas.clear(Color::WHITE);
        canvas.render_bgrx(&mut words).unwrap();
        assert!(words.iter().all(|&pixel| pixel == 0x00ff_ffff));
        assert!(
            canvas
                .raster
                .as_ref()
                .unwrap()
                .cursor
                .iter()
                .all(|&cut| cut == 0)
        );
    }

    #[test]
    fn admitted_reference_and_command_limits_fit_narrow_membership_and_cuts() {
        use crate::{Affine, Color, PaintEdit, Rect};
        let clip = Rect::new(0.0, 0.0, 128.0, 128.0);
        let mut canvas = Canvas::recording(128, 128, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        // 65,536 commands x64 physical tiles reaches the admitted 4M limit.
        for _ in 0..super::super::MAX_COMMANDS {
            canvas
                .fill_rect(clip, Affine::IDENTITY, clip, Color::BLACK)
                .unwrap();
        }
        let mut words = [0; 128 * 128];
        canvas.render_bgrx(&mut words).unwrap();
        let scratch = canvas.raster.as_ref().unwrap();
        assert_eq!(
            scratch.membership.offsets.last().copied(),
            Some(super::super::MAX_REFERENCES as u32)
        );
        assert!(
            scratch
                .cursor
                .iter()
                .all(|&cut| cut == (super::super::MAX_COMMANDS - 1) as u32)
        );
        let index = canvas
            .paint_index((super::super::MAX_COMMANDS - 1) as u32)
            .unwrap();
        let edits = [PaintEdit::new(index, Color::WHITE)];
        canvas.prepare_paint(&edits).unwrap().commit();
        canvas.render_bgrx(&mut words).unwrap();
        assert!(words.iter().all(|&word| word == 0x00ff_ffff));
        assert!(canvas.stats().bins_reused);
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
