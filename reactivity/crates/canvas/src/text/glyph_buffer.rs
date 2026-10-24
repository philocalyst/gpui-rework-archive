//! The finished glyph allocation, with its bounded document length in the header.
use super::{MAX_GLYPHS, MAX_TEXT, PackedGlyph};
use std::{fmt, mem::ManuallyDrop, ops::Deref, ptr::NonNull};

pub(super) struct GlyphBuffer {
    pointer: NonNull<PackedGlyph>,
    capacity: u32,
    length: u16,
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
    pub(super) fn new(value: Vec<PackedGlyph>, text_len: usize) -> Result<Self, Vec<PackedGlyph>> {
        let Some((length, capacity, text_len)) =
            checked_counts(value.len(), value.capacity(), text_len)
        else {
            return Err(value);
        };
        let mut value = ManuallyDrop::new(value);
        Ok(Self {
            pointer: NonNull::new(value.as_mut_ptr()).expect("Vec pointers are nonnull"),
            capacity,
            length,
            text_len,
        })
    }

    pub(super) fn text_len(&self) -> usize {
        usize::from(self.text_len)
    }

    #[cfg(test)]
    pub(super) fn capacity(&self) -> usize {
        self.capacity as usize
    }
}

impl Deref for GlyphBuffer {
    type Target = [PackedGlyph];

    fn deref(&self) -> &[PackedGlyph] {
        // SAFETY: Admission retains the Vec's aligned pointer and initialized
        // length. This borrow cannot outlive its unique allocation owner.
        unsafe { std::slice::from_raw_parts(self.pointer.as_ptr(), usize::from(self.length)) }
    }
}

impl Drop for GlyphBuffer {
    fn drop(&mut self) {
        // SAFETY: Admission transferred one Global Vec without changing its
        // pointer, initialized length or actual capacity. Only this owner drops
        // that allocation; no API changes these fields after admission.
        unsafe {
            drop(Vec::from_raw_parts(
                self.pointer.as_ptr(),
                usize::from(self.length),
                self.capacity as usize,
            ))
        }
    }
}

impl Clone for GlyphBuffer {
    fn clone(&self) -> Self {
        Self::new(self.to_vec(), self.text_len())
            .unwrap_or_else(|_| panic!("cloned glyph capacity exceeds the header domain"))
    }
}

impl fmt::Debug for GlyphBuffer {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        fmt::Debug::fmt(&**self, f)
    }
}

// SAFETY: This owns the same allocation as Vec<PackedGlyph>. PackedGlyph has
// only Copy integer/float fields; shared access exposes only an immutable slice.
unsafe impl Send for GlyphBuffer where PackedGlyph: Send {}
unsafe impl Sync for GlyphBuffer where PackedGlyph: Sync {}

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
        let mut vector = Vec::with_capacity(17);
        vector.push(glyph(7));
        let (pointer, capacity) = (vector.as_ptr(), vector.capacity());
        let returned = GlyphBuffer::new(vector, MAX_TEXT + 1).unwrap_err();
        assert_eq!(
            (returned.as_ptr(), returned.capacity()),
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
            let mut vector = Vec::with_capacity(capacity);
            vector.extend((0..length).map(|n| glyph(n as u32)));
            let (pointer, capacity) = (vector.as_ptr(), vector.capacity());
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
        assert_eq!(size_of::<GlyphBuffer>(), size_of::<usize>() + 8);
        assert_eq!(size_of::<Option<GlyphBuffer>>(), size_of::<GlyphBuffer>());
    }

    #[test]
    fn clone_and_threads_have_independent_ownership_and_shared_borrows() {
        let retained = GlyphBuffer::new(vec![glyph(1), glyph(2)], 8).unwrap();
        let cloned = retained.clone();
        assert_ne!(cloned.as_ptr(), retained.as_ptr());
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
        std::thread::spawn(move || assert_eq!(cloned.len(), 2))
            .join()
            .unwrap();
        drop(retained);
        assert!(
            std::panic::catch_unwind(|| {
                let _owner = GlyphBuffer::new(vec![glyph(3)], 4).unwrap();
                panic!("owner unwind control");
            })
            .is_err()
        );
    }

    #[cfg(not(miri))]
    #[test]
    fn transfer_allocates_nothing_and_clone_keeps_only_packed_values() {
        let mut vector = Vec::with_capacity(257);
        vector.extend((0..128).map(glyph));
        let mut owner = None;
        let cost =
            allocation_counter::measure(|| owner = Some(GlyphBuffer::new(vector, 1024).unwrap()));
        assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
        let owner = owner.unwrap();
        let mut cloned = None;
        let cost = allocation_counter::measure(|| cloned = Some(owner.clone()));
        assert_eq!(
            (cost.count_total, cost.bytes_total),
            (1, (128 * size_of::<PackedGlyph>()) as u64)
        );
        assert_eq!(cloned.as_ref().unwrap().text_len(), 1024);
    }
}
