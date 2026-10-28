//! Immutable packed positions, produced directly in one shared allocation.
use super::{EcoVec, MAX_GLYPHS, MAX_TEXT, PackedGlyph};
use std::{fmt, ops::Deref};

#[derive(Clone)]
pub(super) struct GlyphBuffer {
    values: EcoVec<PackedGlyph>,
    text_len: u16,
}

const _: () = assert!(MAX_GLYPHS <= u16::MAX as usize && MAX_TEXT <= u16::MAX as usize);

fn checked_counts(length: usize, capacity: usize, text_len: usize) -> Option<(u16, u32, u16)> {
    if length > MAX_GLYPHS || text_len > MAX_TEXT {
        return None;
    }
    Some((
        length as u16,
        u32::try_from(capacity).ok()?,
        text_len as u16,
    ))
}

impl GlyphBuffer {
    pub(super) fn new(
        value: EcoVec<PackedGlyph>,
        text_len: usize,
    ) -> Result<Self, EcoVec<PackedGlyph>> {
        let Some((_, _, text_len)) = checked_counts(value.len(), value.capacity(), text_len) else {
            return Err(value);
        };
        Ok(Self {
            values: value,
            text_len,
        })
    }
    pub(super) fn text_len(&self) -> usize {
        usize::from(self.text_len)
    }
    pub(super) fn shared(&self) -> EcoVec<PackedGlyph> {
        self.values.clone()
    }
    #[cfg(test)]
    pub(super) fn capacity(&self) -> usize {
        self.values.capacity()
    }
    #[cfg(test)]
    pub(super) fn is_unique(&mut self) -> bool {
        self.values.is_unique()
    }
}
impl fmt::Debug for GlyphBuffer {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        fmt::Debug::fmt(&**self, f)
    }
}

impl Deref for GlyphBuffer {
    type Target = [PackedGlyph];
    fn deref(&self) -> &[PackedGlyph] {
        &self.values
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn glyph(index: u32) -> PackedGlyph {
        PackedGlyph {
            meta: index,
            x: f32::from_bits(0x8000_0000 | index),
            baseline: f32::from_bits(0x7fc0_0000 | index),
        }
    }

    fn bits(value: &PackedGlyph) -> (u32, u32, u32) {
        (value.meta, value.x.to_bits(), value.baseline.to_bits())
    }

    #[test]
    fn checked_header_endpoints_and_failed_admission_preserve_the_vector() {
        assert_eq!(checked_counts(0, 0, 0), Some((0, 0, 0)));
        assert_eq!(
            checked_counts(MAX_GLYPHS, u32::MAX as usize, MAX_TEXT),
            Some((MAX_GLYPHS as u16, u32::MAX, MAX_TEXT as u16))
        );
        assert_eq!(checked_counts(MAX_GLYPHS + 1, 0, 0), None);
        assert_eq!(checked_counts(0, 0, MAX_TEXT + 1), None);
        if let Ok(capacity) = usize::try_from(u64::from(u32::MAX) + 1) {
            assert_eq!(checked_counts(0, capacity, 0), None);
        }
        let mut vector = EcoVec::with_capacity(17);
        vector.push(glyph(7));
        let (pointer, capacity) = (vector.as_slice().as_ptr(), vector.capacity());
        let returned = GlyphBuffer::new(vector, MAX_TEXT + 1).unwrap_err();
        assert_eq!(
            (returned.as_slice().as_ptr(), returned.capacity()),
            (pointer, capacity)
        );
        assert_eq!(bits(&returned[0]), bits(&glyph(7)));
    }

    #[test]
    fn empty_spare_capacity_and_full_buffers_keep_exact_allocation_and_bits() {
        for (capacity, length) in [
            (0, 0),
            (17, 0),
            (17, 1),
            (257, 128),
            (32768, 32768),
            (65537, 1),
        ] {
            let mut vector = EcoVec::with_capacity(capacity);
            vector.extend((0..length).map(|n| glyph(n as u32)));
            let (pointer, capacity) = (vector.as_slice().as_ptr(), vector.capacity());
            let retained = GlyphBuffer::new(vector, MAX_TEXT).unwrap();
            assert_eq!(retained.as_ptr(), pointer);
            assert_eq!((retained.len(), retained.capacity()), (length, capacity));
            assert_eq!(retained.text_len(), MAX_TEXT);
            assert!(
                retained
                    .iter()
                    .enumerate()
                    .all(|(n, g)| bits(g) == bits(&glyph(n as u32)))
            );
            drop(retained);
        }
        println!(
            "GLYPH_OWNER_HEADERS owner={} packed={}",
            size_of::<GlyphBuffer>(),
            size_of::<PackedGlyph>()
        );
        assert_eq!(size_of::<GlyphBuffer>(), 3 * size_of::<usize>());
        assert_eq!(size_of::<Option<GlyphBuffer>>(), size_of::<GlyphBuffer>());
    }

    #[test]
    fn cloned_owners_keep_exact_bits_across_threads_and_original_drop() {
        let retained = GlyphBuffer::new(EcoVec::from([glyph(1), glyph(2)].as_slice()), 8).unwrap();
        let cloned = retained.clone();
        assert_eq!(cloned.as_ptr(), retained.as_ptr());
        assert_eq!(cloned.text_len(), retained.text_len());
        assert!(
            cloned
                .iter()
                .zip(retained.iter())
                .all(|(a, b)| bits(a) == bits(b))
        );
        std::thread::scope(|scope| {
            scope.spawn(|| assert_eq!(retained.len(), 2));
        });
        drop(retained);
        std::thread::spawn(move || {
            assert_eq!(cloned.len(), 2);
            assert_eq!(bits(&cloned[1]), bits(&glyph(2)));
        })
        .join()
        .unwrap();
        assert!(
            std::panic::catch_unwind(|| {
                let _owner = GlyphBuffer::new(EcoVec::from([glyph(3)].as_slice()), 4).unwrap();
                panic!("owner unwind control");
            })
            .is_err()
        );
    }

    #[test]
    fn empty_owners_and_scene_leases_preserve_text_length_and_owner_lifetime() {
        let owner = GlyphBuffer::new(EcoVec::new(), MAX_TEXT).unwrap();
        let cloned = owner.clone();
        assert_eq!(cloned.text_len(), MAX_TEXT);
        assert!(cloned.is_empty());
        let owner = GlyphBuffer::new(EcoVec::from([glyph(4), glyph(9)].as_slice()), 17).unwrap();
        let shared = owner.shared();
        assert_eq!(shared.as_ptr(), owner.as_ptr());
        drop(owner);
        assert_eq!(bits(&shared[1]), bits(&glyph(9)));
        let outcome = std::panic::catch_unwind(|| {
            let _cloned = shared.clone();
            panic!("shared owner unwind control");
        });
        assert!(outcome.is_err());
        assert_eq!(bits(&shared[0]), bits(&glyph(4)));
    }

    #[cfg(not(miri))]
    #[test]
    fn one_allocation_survives_until_last_clone_and_is_released() {
        let cost = allocation_counter::measure(|| {
            let owner = GlyphBuffer::new(EcoVec::from([glyph(1), glyph(2)].as_slice()), 8).unwrap();
            let cloned = owner.clone();
            let shared = owner.shared();
            assert_eq!(cloned.as_ptr(), owner.as_ptr());
            assert_eq!(shared.as_ptr(), owner.as_ptr());
            drop(owner);
            drop(cloned);
            assert_eq!(bits(&shared[1]), bits(&glyph(2)));
            drop(shared);
        });
        assert_eq!(
            (cost.count_total, cost.bytes_total, cost.bytes_current),
            (
                1,
                (4 * size_of::<PackedGlyph>() + 2 * size_of::<usize>()) as u64,
                0
            )
        );
        let empty = allocation_counter::measure(|| {
            let owner = GlyphBuffer::new(EcoVec::new(), 9).unwrap();
            let cloned = owner.clone();
            drop(owner);
            assert_eq!(cloned.text_len(), 9);
        });
        assert_eq!(
            (empty.count_total, empty.bytes_total, empty.bytes_current),
            (0, 0, 0)
        );
    }

    #[cfg(not(miri))]
    #[test]
    fn transfer_allocates_nothing() {
        let mut vector = EcoVec::with_capacity(257);
        vector.extend((0..128).map(glyph));
        let mut owner = None;
        let cost =
            allocation_counter::measure(|| owner = Some(GlyphBuffer::new(vector, 1024).unwrap()));
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        assert_eq!(owner.unwrap().text_len(), 1024);
    }
}
