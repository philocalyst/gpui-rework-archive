//! One authoritative CPU scratch owner, allocated only when rasterizing.
use super::{DisplayList, TILE, visit_tiles};

#[derive(Default)]
pub(super) struct RasterScratch {
    pub(super) offsets: Vec<usize>,
    pub(super) indices: Vec<u32>,
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
    /// Retain unpruned command membership, never color/occlusion certificates.
    /// The scene owner invalidates this at each structural commit; admitted
    /// color patches leave geometry, order and resource membership unchanged.
    pub(super) fn prepare(&mut self, commands: &DisplayList, bounds: [usize; 4]) -> bool {
        debug_assert!(bounds[0] < bounds[2] && bounds[1] < bounds[3]);
        debug_assert!(bounds.iter().all(|&edge| edge <= 16_384 / TILE));
        let key = bounds.map(|edge| edge as u16);
        if self.bounds == key {
            return true;
        }
        // Invalidate before any allocation: catching an allocation panic must
        // not make a partially rebuilt CSR appear reusable.
        self.invalidate();
        let tiles = (bounds[2] - bounds[0]) * (bounds[3] - bounds[1]);
        self.offsets.clear();
        self.offsets.resize(tiles + 1, 0);
        for command in commands.iter() {
            visit_tiles(&command, bounds, |tile| self.offsets[tile + 1] += 1);
        }
        for i in 1..self.offsets.len() {
            self.offsets[i] += self.offsets[i - 1];
        }
        self.indices.clear();
        self.indices.resize(*self.offsets.last().unwrap(), 0);
        // Counting cursor is O(tile count), never O(pixel count).
        self.cursor.clear();
        self.cursor.extend_from_slice(&self.offsets[..tiles]);
        for (index, command) in commands.iter().enumerate() {
            visit_tiles(&command, bounds, |tile| {
                self.indices[self.cursor[tile]] = index as u32;
                self.cursor[tile] += 1;
            });
        }
        self.bounds = key;
        false
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Canvas, ColorConfig};

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
            "raster_headers,Canvas={},Scratch={},RenderStats={}",
            size_of::<Canvas>(),
            size_of::<RasterScratch>(),
            size_of::<super::super::RenderStats>()
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
            assert_eq!(
                first.bytes_current as usize,
                size_of::<RasterScratch>() + canvas.bin_bytes()
            );
        }
    }
}
