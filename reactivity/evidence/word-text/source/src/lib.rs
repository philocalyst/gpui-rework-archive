//! Isolated representation experiment; not a production GPUI dependency.
use std::{fmt, mem::ManuallyDrop, num::NonZeroUsize, ops::Deref, ptr::NonNull};

/// Immutable UTF-8 with one-word ownership and a one-word Option niche.
///
/// Low address bits zero mean an owned ArcStr::into_raw pointer. Otherwise
/// they encode an inline byte length. Inline words have no provenance and
/// are never dereferenced as pointers. Their bytes are borrowed from this
/// object's own storage, using a pointer derived from &self instead.
#[repr(transparent)]
pub struct WordText(NonNull<()>);

const WORD: usize = size_of::<usize>();
const INLINE: usize = if cfg!(any(
    target_pointer_width = "32",
    target_pointer_width = "64"
)) {
    WORD - 1
} else {
    0
};
const PAYLOAD_OFFSET: usize = if cfg!(target_endian = "little") { 1 } else { 0 };
const TAG_OFFSET: usize = if cfg!(target_endian = "little") {
    0
} else {
    WORD - 1
};

// SAFETY: Public construction accepts valid borrowed UTF-8 and retains no
// mutable borrow. The heap arm owns an immutable, Send + Sync ArcStr lease;
// inline bytes reside entirely in this immutable value. No raw pointer API
// is exposed, and mutation is possible only by moving/replacing the owner.
unsafe impl Send for WordText {}
unsafe impl Sync for WordText {}

impl WordText {
    fn inline_len(&self) -> usize {
        self.0.addr().get() & 7
    }

    fn heap(&self) -> ManuallyDrop<arcstr::ArcStr> {
        debug_assert_eq!(self.inline_len(), 0);
        // SAFETY: A zero tag is exclusively an unchanged into_raw pointer.
        // This temporary borrows the existing lease; ManuallyDrop prevents
        // consuming its strong count. The caller cannot retain this handle.
        ManuallyDrop::new(unsafe { arcstr::ArcStr::from_raw(self.0) })
    }
}

impl From<&str> for WordText {
    fn from(value: &str) -> Self {
        if !value.is_empty() && value.len() <= INLINE {
            let mut bytes = [0; WORD];
            bytes[TAG_OFFSET] = value.len() as u8;
            bytes[PAYLOAD_OFFSET..PAYLOAD_OFFSET + value.len()].copy_from_slice(value.as_bytes());
            let address = NonZeroUsize::new(usize::from_ne_bytes(bytes)).unwrap();
            Self(NonNull::without_provenance(address))
        } else {
            Self(arcstr::ArcStr::into_raw(arcstr::ArcStr::from(value)))
        }
    }
}

impl Deref for WordText {
    type Target = str;
    fn deref(&self) -> &str {
        let length = self.inline_len();
        if length != 0 {
            // SAFETY: The pointer derives from this object's field, not the
            // no-provenance address stored in that field. Every byte was
            // initialized from valid UTF-8; payload and tag never overlap.
            // length <= WORD-1, and the returned borrow is bounded by &self.
            unsafe {
                let data = std::ptr::addr_of!(self.0).cast::<u8>().add(PAYLOAD_OFFSET);
                str::from_utf8_unchecked(std::slice::from_raw_parts(data, length))
            }
        } else {
            let lease = self.heap();
            // SAFETY: The temporary only lends the unchanged ArcStr lease.
            // Its UTF-8 allocation is owned by self for the returned borrow;
            // it is not storage inside the temporary handle.
            unsafe { &*(lease.as_str() as *const str) }
        }
    }
}

impl Clone for WordText {
    fn clone(&self) -> Self {
        if self.inline_len() != 0 {
            Self(self.0)
        } else {
            Self(arcstr::ArcStr::into_raw(arcstr::ArcStr::clone(
                &self.heap(),
            )))
        }
    }
}

impl Drop for WordText {
    fn drop(&mut self) {
        if self.inline_len() == 0 {
            // SAFETY: This is the one owned strong lease for this handle.
            // heap() temporaries never drop it; clone() creates a new lease.
            unsafe { drop(arcstr::ArcStr::from_raw(self.0)) }
        }
    }
}

impl PartialEq for WordText {
    fn eq(&self, other: &Self) -> bool {
        **self == **other
    }
}
impl Eq for WordText {}
impl fmt::Debug for WordText {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        fmt::Debug::fmt(&**self, formatter)
    }
}
