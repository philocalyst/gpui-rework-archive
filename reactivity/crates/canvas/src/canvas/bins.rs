//! One authoritative CPU scratch owner, allocated only when rasterizing.
use super::{DisplayList, TILE};

// Admission bounds regional CSR references and every painter ordinal.
const _: () = assert!(super::MAX_REFERENCES < u32::MAX as usize);
const _: () = assert!(super::MAX_COMMANDS <= u16::MAX as usize + 1);
// Tile endpoints use at most eleven bits. Retire cut certificates lazily in an
// unused bound bit, so paint commits never scan tiles or enlarge the header.
const CUTS_DIRTY: u16 = 1 << 15;
const _: () = assert!(16_384 / TILE < CUTS_DIRTY as usize);

#[derive(Default)]
pub(super) struct RasterScratch {
    offsets: Vec<u32>,
    indices: Vec<u32>,
    // Canvas axes are at most 16384px: tile endpoints fit in 0..=1024.
    // All-zero bounds cannot describe a nonempty render, so also mean invalid.
    bounds: [u16; 4],
}
impl RasterScratch {
    pub(super) fn invalidate(&mut self) {
        self.bounds = [0; 4];
    }
    pub(super) fn revoke_cuts(&mut self) {
        self.bounds[0] |= CUTS_DIRTY;
    }
    pub(super) fn bytes(&self) -> usize {
        (self.offsets.capacity() + self.indices.capacity()) * size_of::<u32>()
    }
    /// Borrow contiguous physical rows. Recursive workers split both membership
    /// and output at the same row boundary; only immutable offsets overlap.
    pub(super) fn rows(&mut self, bounds: [usize; 4]) -> ([u16; 4], &[u32], &mut [u32]) {
        debug_assert_eq!(self.bounds[0] & CUTS_DIRTY, 0);
        let stride = usize::from(self.bounds[2] - self.bounds[0]);
        let first = (bounds[1] - usize::from(self.bounds[1])) * stride;
        let end = (bounds[3] - usize::from(self.bounds[1])) * stride;
        let offsets = &self.offsets[first..=end];
        (
            self.bounds,
            offsets,
            &mut self.indices[offsets[0] as usize..offsets[end - first] as usize],
        )
    }
    /// Unpruned membership survives exact-alpha paint patches. Structural
    /// mutation invalidates membership and its embedded cuts before publication.
    pub(super) fn prepare(&mut self, commands: &DisplayList, bounds: [usize; 4]) -> bool {
        debug_assert!(bounds[0] < bounds[2] && bounds[1] < bounds[3]);
        debug_assert!(bounds.iter().all(|&edge| edge <= 16_384 / TILE));
        let key = bounds.map(|edge| edge as u16);
        let mut cached = self.bounds;
        cached[0] &= !CUTS_DIRTY;
        if key[0] >= cached[0] && key[1] >= cached[1] && key[2] <= cached[2] && key[3] <= cached[3]
        {
            if self.bounds[0] & CUTS_DIRTY != 0 {
                for span in self.offsets.windows(2) {
                    if span[0] != span[1] {
                        self.indices[span[0] as usize] &= u16::MAX as u32;
                    }
                }
                self.bounds = cached;
            }
            return true;
        }
        // Allocation failure cannot publish a partially rebuilt CSR.
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
        let total = self.offsets[tiles];
        self.indices.clear();
        self.indices.resize(total as usize, 0);
        // Decrement cumulative ends while visiting painters backwards. This
        // fills each tile in ascending order without a separate cursor array.
        for (index, command_bounds) in commands.ordered_bounds().enumerate().rev() {
            visit_tiles(command_bounds, bounds, |tile| {
                self.offsets[tile + 1] -= 1;
                self.indices[self.offsets[tile + 1] as usize] = index as u32;
            });
        }
        // Each former end now holds that tile's start, including empty tiles.
        self.offsets.copy_within(1.., 0);
        self.offsets[tiles] = total;
        self.bounds = key;
        false
    }
}

/// Only the first member's high half stores a lazy cut + 1. Zero is unknown;
/// low halves always retain the admitted painter ordinal. A cut of 65535
/// cannot be encoded and is conservatively recomputed on the next raster.
#[inline]
pub(super) fn ordinal(word: u32) -> usize {
    word as u16 as usize
}
#[inline]
pub(super) fn cached_cut(members: &[u32]) -> Option<usize> {
    members
        .first()
        .and_then(|word| (word >> 16).checked_sub(1))
        .map(|cut| cut as usize)
}
pub(super) fn cache_cut(members: &mut [u32], cut: usize) {
    if cut < u16::MAX as usize
        && let Some(first) = members.first_mut()
    {
        *first = u32::from(*first as u16) | (((cut + 1) as u32) << 16);
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
        let common = canvas.commands.columns.resolve(
            canvas.commands.inline[0].common,
            super::super::viewport_rect(65, 49),
            false,
        );
        let geometry = canvas.commands.inline[0].geometry;
        let common =
            canvas
                .commands
                .columns
                .store(common, super::super::viewport_rect(65, 49), None, false);
        let start = canvas.commands.placements.len();
        canvas.commands.placements.push(super::super::Placement {
            geometry,
            common: canvas.commands.commons.len() as u32,
            source: super::super::RECT_SOURCE,
        });
        canvas.commands.publish_group(start, common);
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
        let expected: Vec<_> = commands
            .iter(super::super::viewport_rect(65, 49))
            .map(|c| c.bounds)
            .collect();
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
                        &scratch.indices
                            [scratch.offsets[tile] as usize..scratch.offsets[tile + 1] as usize],
                        members
                    );
                }
            }
        }
    }

    fn cuts(canvas: &Canvas) -> Vec<Option<usize>> {
        let scratch = canvas.raster.as_ref().unwrap();
        scratch
            .offsets
            .windows(2)
            .map(|span| cached_cut(&scratch.indices[span[0] as usize..span[1] as usize]))
            .collect()
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
        assert!(cuts(&canvas).iter().all(Option::is_none));
        canvas.set_tile_proofs(true);
        let damage = DamageRegion::checked_canvas_bounds([16, 16, 32, 32]);
        canvas.render_bgrx_region(&mut words, damage).unwrap();
        let cached = cuts(&canvas);
        for (tile, &cut) in cached.iter().enumerate() {
            assert_eq!(cut, if tile == 5 { Some(2) } else { None });
        }
        let edits = [PaintEdit::new(index, Color::rgb(30, 70, 140))];
        drop(canvas.prepare_paint(&edits).unwrap());
        assert_eq!(cuts(&canvas)[5], Some(2));
        canvas.prepare_paint(&edits).unwrap().commit();
        canvas.render_bgrx_region(&mut words, damage).unwrap();
        assert_eq!(cuts(&canvas)[5], Some(2));
        let edits = [PaintEdit::new(index, Color::rgba(30, 70, 140, 128))];
        assert!(canvas.prepare_paint(&edits).is_err());
        assert_eq!(cuts(&canvas)[5], Some(2));
        canvas.render_bgrx(&mut words).unwrap();
        let cached = cuts(&canvas);
        for (tile, &cut) in cached.iter().enumerate() {
            assert_eq!(cut, if tile == 5 { Some(2) } else { Some(0) });
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
        assert!(cuts(&canvas).iter().all(Option::is_none));
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
            scratch.offsets.last().copied(),
            Some(super::super::MAX_REFERENCES as u32)
        );
        assert!(cuts(&canvas).iter().all(Option::is_none));
        for members in scratch.offsets.windows(2) {
            let members = &scratch.indices[members[0] as usize..members[1] as usize];
            assert_eq!(members.len(), super::super::MAX_COMMANDS);
            assert!(
                members
                    .iter()
                    .copied()
                    .map(ordinal)
                    .eq(0..super::super::MAX_COMMANDS)
            );
        }
        let index = canvas
            .paint_index((super::super::MAX_COMMANDS - 1) as u32)
            .unwrap();
        let edits = [PaintEdit::new(index, Color::WHITE)];
        canvas.prepare_paint(&edits).unwrap().commit();
        canvas.render_bgrx(&mut words).unwrap();
        assert!(words.iter().all(|&word| word == 0x00ff_ffff));
        assert!(canvas.stats().bins_reused);
        assert_eq!(canvas.stats().skipped_command_tiles, 64 * 65535);
        // The largest encodable cut occupies all high bits. The final
        // translucent command must still read its unmodified low ordinal.
        canvas.clear(Color::WHITE);
        for _ in 0..super::super::MAX_COMMANDS - 1 {
            canvas
                .fill_rect(clip, Affine::IDENTITY, clip, Color::WHITE)
                .unwrap();
        }
        canvas
            .fill_rect(clip, Affine::IDENTITY, clip, Color::rgba(0, 0, 0, 128))
            .unwrap();
        canvas.render_bgrx(&mut words).unwrap();
        assert!(cuts(&canvas).iter().all(|&cut| cut == Some(65534)));
        let mut oracle = Canvas::recording(128, 128, ColorConfig::default()).unwrap();
        oracle.clear(Color::WHITE);
        oracle.set_tile_proofs(false);
        oracle
            .fill_rect(clip, Affine::IDENTITY, clip, Color::rgba(0, 0, 0, 128))
            .unwrap();
        let mut expected = [0; 128 * 128];
        oracle.render_bgrx(&mut expected).unwrap();
        assert_eq!(words, expected);
        canvas.render_bgrx(&mut words).unwrap();
        assert_eq!(words, expected);
        assert_eq!(canvas.stats().skipped_command_tiles, 64 * 65534);
    }

    #[test]
    fn embedded_cut_preserves_a_nonzero_first_painter_and_no_opaque_prefix() {
        use crate::{Affine, Color, Rect};
        let clip = Rect::new(0.0, 0.0, 48.0, 16.0);
        let mut canvas = Canvas::recording(48, 16, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        canvas
            .fill_rect(
                Rect::new(1.0, 1.0, 11.0, 11.0),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
        canvas
            .fill_rect(
                Rect::new(20.0, 1.0, 8.0, 11.0),
                Affine::IDENTITY,
                clip,
                Color::rgba(255, 0, 0, 128),
            )
            .unwrap();
        let mut expected = [0; 48 * 16];
        canvas.set_tile_proofs(false);
        canvas.render_bgrx(&mut expected).unwrap();
        let mut words = [0; 48 * 16];
        canvas.set_tile_proofs(true);
        canvas.render_bgrx(&mut words).unwrap();
        assert_eq!(words, expected);
        assert_eq!(cuts(&canvas), [Some(0), Some(0), None]);
        let scratch = canvas.raster.as_ref().unwrap();
        assert_eq!(ordinal(scratch.indices[scratch.offsets[1] as usize]), 1);
        canvas.set_tile_proofs(false);
        canvas.render_bgrx(&mut words).unwrap();
        assert_eq!(words, expected);
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
            assert_eq!((first.count_total, first.bytes_total), (2, 76));
            assert_eq!(canvas.bin_bytes(), 20);
            assert_eq!(size_of::<Canvas>(), 488);
            assert_eq!(size_of::<RasterScratch>(), 56);
            assert_eq!(size_of::<super::super::RenderStats>(), 96);
            assert_eq!(size_of::<super::super::Frame<'_>>(), 88);
            assert_eq!(
                first.bytes_current as usize,
                size_of::<RasterScratch>() + canvas.bin_bytes()
            );
        }
    }
}
