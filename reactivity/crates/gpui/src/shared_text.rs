//! Immutable, one-word UTF-8 ownership for retained text only. Resource leases
//! (font faces, glyph masks and backend objects) keep their existing ownership.
//! Construction copies borrowed valid UTF-8 once; publication clones a lease.
use std::ops::Deref;

#[repr(transparent)]
#[derive(Clone, Debug, PartialEq, Eq)]
pub(crate) struct SharedText(arcstr::ArcStr);
fn joined_len(lengths: [usize; 3]) -> Option<usize> {
    lengths[0].checked_add(lengths[1])?.checked_add(lengths[2])
}
impl SharedText {
    #[cfg(feature = "retained-text")]
    pub(crate) fn utf8_backing(&self)->gpui_reactivity_core::resource::Utf8Backing {gpui_reactivity_core::resource::Utf8Backing::new(self.0.clone())}
    /// Copy three UTF-8 fragments directly into their final immutable lease.
    pub(crate) fn try_join(parts: [&str; 3]) -> Option<Self> {
        let length = joined_len(parts.map(str::len))?;
        if length == 0 {
            return Some(Self(arcstr::ArcStr::new()));
        }
        let initialize = |destination: &mut [std::mem::MaybeUninit<u8>]| {
            let (prefix, tail) = destination.split_at_mut(parts[0].len());
            let (middle, suffix) = tail.split_at_mut(parts[1].len());
            prefix.write_copy_of_slice(parts[0].as_bytes());
            middle.write_copy_of_slice(parts[1].as_bytes());
            suffix.write_copy_of_slice(parts[2].as_bytes());
        };
        // SAFETY: concatenating valid UTF-8 fragments yields valid UTF-8.
        // `length` is their checked sum, so the two splits leave three exact
        // destination lengths. Each safe copy initializes its entire slice.
        // No user code runs here; these bounded, equal-length operations cannot
        // panic (ArcStr's initializer has no unwind cleanup for its allocation).
        #[expect(unsafe_code, reason = "checked UTF-8 fragments initialize every byte")]
        let lease = unsafe { arcstr::ArcStr::try_init_with_unchecked(length, initialize) };
        lease.map(Self)
    }
}
impl Deref for SharedText {
    type Target = str;
    #[inline]
    fn deref(&self) -> &str {
        self.0.as_str()
    }
}
impl AsRef<str> for SharedText {
    #[inline]
    fn as_ref(&self) -> &str {
        self
    }
}
impl From<&str> for SharedText {
    #[inline]
    fn from(value: &str) -> Self {
        Self(arcstr::ArcStr::from(value))
    }
}
impl From<String> for SharedText {
    #[inline]
    fn from(value: String) -> Self {
        Self::from(value.as_str())
    }
}
#[cfg(test)]
impl SharedText {
    pub fn strong_count(&self) -> Option<usize> {
        arcstr::ArcStr::strong_count(&self.0)
    }
    pub fn as_ptr(&self) -> *const str {
        self.0.as_str() as *const str
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::mem::size_of;
    fn assert_send_sync<T: Send + Sync>() {}
    #[test]
    fn direct_join_initializes_exact_unicode_fragments_and_checks_length_overflow() {
        for value in ["", "a\0é漢🙂z", "a\u{301}z", "👩‍❤️‍💋‍👨x", "🇫🇷עברית"]
        {
            for left in (0..=value.len()).filter(|&n| value.is_char_boundary(n)) {
                for right in (left..=value.len()).filter(|&n| value.is_char_boundary(n)) {
                    let parts = [&value[..left], &value[left..right], &value[right..]];
                    assert_eq!(SharedText::try_join(parts).unwrap().as_ref(), value);
                }
            }
        }
        assert_eq!(joined_len([usize::MAX, 1, 0]), None);
        assert_eq!(joined_len([usize::MAX - 1, 1, 1]), None);
        assert_eq!(joined_len([usize::MAX - 2, 1, 1]), Some(usize::MAX));
    }
    #[test]
    fn direct_join_allocates_only_final_lease_and_empty_is_static() {
        for length in [0, 1, 24, 4096, 32 * 1024] {
            let payload = "x".repeat(length);
            let mut lease = None;
            let cost = allocation_counter::measure(|| {
                lease = SharedText::try_join(["", payload.as_str(), ""]);
            });
            let expected = if length == 0 {
                0
            } else {
                length + 2 * size_of::<usize>()
            };
            assert_eq!(cost.count_total, u64::from(length != 0));
            assert_eq!(cost.bytes_total, expected as u64);
            assert_eq!(cost.bytes_current, expected as i64);
            assert_eq!(cost.bytes_max, expected as u64);
            assert_eq!(lease.as_ref().unwrap().as_ref(), payload);
        }
    }
    #[test]
    fn one_word_utf8_lease_preserves_owned_unicode_and_thread_transfer() {
        assert_send_sync::<SharedText>();
        assert_eq!(size_of::<SharedText>(), size_of::<usize>());
        assert_eq!(size_of::<Option<SharedText>>(), size_of::<usize>());
        let owned = String::from("Café naïve\0λЖ");
        let lease = SharedText::from(owned.as_str());
        assert_ne!(lease.as_ptr() as *const u8, owned.as_ptr());
        drop(owned);
        let pointer = lease.as_ptr();
        let clone = lease.clone();
        assert!(std::ptr::eq(pointer, clone.as_ptr()));
        assert_eq!(clone.as_ref(), "Café naïve\0λЖ");
        std::thread::scope(|scope| {
            let borrowed = &lease;
            scope.spawn(move || assert_eq!(borrowed.as_ref(), "Café naïve\0λЖ"));
            scope.spawn(move || assert_eq!(clone.as_ref(), "Café naïve\0λЖ"));
        });
    }
    #[test]
    fn exact_allocation_requests_include_header_growth_and_static_empty() {
        for payload in [
            "".to_owned(),
            "a".repeat(3),
            "a".repeat(8),
            "a".repeat(23),
            "a".repeat(24),
            "a".repeat(25),
            "a".repeat(64),
            "é".repeat(3),
            "a".repeat(4096),
        ] {
            let length = payload.len();
            let mut thin = None;
            let thin_allocation =
                allocation_counter::measure(|| thin = Some(SharedText::from(payload.as_str())));
            let mut baseline = None;
            let baseline_allocation = allocation_counter::measure(|| {
                baseline = Some(triomphe::Arc::<str>::from(payload.as_str()))
            });
            let word = size_of::<usize>();
            let expected_baseline = (word + length).next_multiple_of(word);
            assert_eq!(baseline_allocation.count_total, 1);
            assert_eq!(baseline_allocation.bytes_total, expected_baseline as u64);
            assert_eq!(thin_allocation.count_total, u64::from(length != 0));
            assert_eq!(
                thin_allocation.bytes_total,
                if length == 0 {
                    0
                } else {
                    (2 * word + length) as u64
                }
            );
            assert_eq!(thin.as_ref().unwrap().as_ref(), payload);
            let pointer = thin.as_ref().unwrap().as_ptr();
            let borrowed = allocation_counter::measure(|| {
                for _ in 0..1000 {
                    let copy = thin.as_ref().unwrap().clone();
                    assert!(std::ptr::eq(pointer, copy.as_ptr()));
                    std::hint::black_box(copy.as_ref());
                }
            });
            assert_eq!(borrowed.count_total, 0);
            println!(
                "lease,len={length},triomphe_bytes={},thin_bytes={}",
                baseline_allocation.bytes_total, thin_allocation.bytes_total
            );
        }
    }
}
