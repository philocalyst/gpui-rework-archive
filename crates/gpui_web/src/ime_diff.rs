//! Unicode-scalar-safe diffing for DOM text edits, whose offsets are UTF-16 units.

/// The minimal replacement recovered from two UTF-16 strings.
#[derive(Debug, Eq, PartialEq)]
pub(crate) struct ImeTextDiff {
    /// Number of unchanged UTF-16 units before the replacement.
    pub(crate) prefix_length: usize,
    /// End of the replaced range in the old UTF-16 string.
    pub(crate) replaced_old_end: usize,
    /// Text to insert, decoded only after both diff boundaries are validated.
    pub(crate) replacement: String,
}

/// Finds a common UTF-16 prefix/suffix while keeping both edit boundaries on
/// Unicode scalar boundaries. The optional caret offset is in UTF-16 units.
/// Invalid UTF-16 is rejected rather than repaired lossily.
pub(crate) fn diff_ime_text(
    old: &str,
    new: &str,
    post_edit_caret: Option<usize>,
) -> Option<ImeTextDiff> {
    let old_units: Vec<u16> = old.encode_utf16().collect();
    let new_units: Vec<u16> = new.encode_utf16().collect();

    // The suffix is anchored as everything after the post-edit caret. If that
    // exact suffix does not match, use the ordinary common-suffix fallback.
    let anchored_suffix_length = post_edit_caret
        .map(|caret| new_units.len().saturating_sub(caret))
        .filter(|&suffix_length| {
            suffix_length <= old_units.len()
                && old_units[old_units.len() - suffix_length..]
                    == new_units[new_units.len() - suffix_length..]
        });

    let mut suffix_length = anchored_suffix_length.unwrap_or_else(|| {
        old_units
            .iter()
            .rev()
            .zip(new_units.iter().rev())
            .take_while(|(old_unit, new_unit)| old_unit == new_unit)
            .count()
    });
    while suffix_length > 0
        && (!is_utf16_scalar_boundary(&old_units, old_units.len() - suffix_length)
            || !is_utf16_scalar_boundary(&new_units, new_units.len() - suffix_length))
    {
        suffix_length -= 1;
    }

    let mut prefix_length = old_units
        .iter()
        .zip(&new_units)
        .take_while(|(old_unit, new_unit)| old_unit == new_unit)
        .count()
        .min(old_units.len() - suffix_length)
        .min(new_units.len() - suffix_length);
    while prefix_length > 0
        && (!is_utf16_scalar_boundary(&old_units, prefix_length)
            || !is_utf16_scalar_boundary(&new_units, prefix_length))
    {
        prefix_length -= 1;
    }

    let replaced_old_end = old_units.len() - suffix_length;
    let replacement =
        decode_utf16_strict(&new_units[prefix_length..new_units.len() - suffix_length])?;
    Some(ImeTextDiff {
        prefix_length,
        replaced_old_end,
        replacement,
    })
}

fn is_utf16_scalar_boundary(units: &[u16], index: usize) -> bool {
    index == 0
        || index == units.len()
        || !(matches!(units[index - 1], 0xD800..=0xDBFF) && matches!(units[index], 0xDC00..=0xDFFF))
}

fn decode_utf16_strict(units: &[u16]) -> Option<String> {
    String::from_utf16(units).ok()
}

#[cfg(test)]
mod tests {
    use super::{decode_utf16_strict, diff_ime_text};

    #[test]
    fn shared_high_surrogates_stay_inside_replacement() {
        let diff = diff_ime_text("😀😀😀", "🕸🕸🕸", Some(0)).unwrap();
        assert_eq!(diff.prefix_length, 0);
        assert_eq!(diff.replaced_old_end, 6);
        assert_eq!(diff.replacement, "🕸🕸🕸");
    }

    #[test]
    fn shared_low_surrogate_cannot_be_kept_as_a_suffix() {
        let other = char::from_u32(0x1FA00).unwrap().to_string();
        assert_eq!("😀".encode_utf16().last(), other.encode_utf16().last());
        let diff = diff_ime_text("😀", &other, None).unwrap();
        assert_eq!(diff.prefix_length, 0);
        assert_eq!(diff.replaced_old_end, 2);
        assert_eq!(diff.replacement, other);
    }

    #[test]
    fn anchored_diff_preserves_dom_utf16_offsets_around_astral_replacement() {
        let diff = diff_ime_text("a😀z", "a🕸z", Some(3)).unwrap();
        assert_eq!(diff.prefix_length, 1);
        assert_eq!(diff.replaced_old_end, 3);
        assert_eq!(diff.replacement, "🕸");
    }

    #[test]
    fn malformed_utf16_is_rejected_without_lossy_replacement() {
        assert!(decode_utf16_strict(&[0xD83D]).is_none());
        assert!(decode_utf16_strict(&[0xDC00]).is_none());
        assert_eq!(
            decode_utf16_strict(&[0xD83D, 0xDE00]).as_deref(),
            Some("😀")
        );
    }
}
