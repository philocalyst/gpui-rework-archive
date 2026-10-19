//! Pure UTF-16 range math shared by the Android input adapter and host tests.
//!
//! Android deletion follows AOSP BaseInputConnection.deleteSurroundingText:
//! https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/core/java/android/view/inputmethod/BaseInputConnection.java
//! Selection and composing text are protected; surrounding text is deleted in two ranges.

/// Reconstruct the platform setter's directed range after a surrounding delete.
/// UTF16Selection::reversed is retained exactly by the GPUI
/// setter and snapshot wire round-trip, including reversed ranges.
pub(crate) fn selection_after_deletion(
    selection: std::ops::Range<usize>,
    reversed: bool,
    deleted_before: std::ops::Range<usize>,
) -> std::ops::Range<usize> {
    let shift = deleted_before.end.saturating_sub(deleted_before.start);
    let start = selection.start.saturating_sub(shift);
    let end = selection.end.saturating_sub(shift);
    if reversed { end..start } else { start..end }
}

pub(crate) fn deletion_ranges(
    text: &str,
    selection: std::ops::Range<usize>,
    marked: Option<std::ops::Range<usize>>,
    before: usize,
    after: usize,
    code_points: bool,
) -> (std::ops::Range<usize>, std::ops::Range<usize>) {
    let mut boundaries = vec![0];
    for ch in text.chars() {
        boundaries.push(boundaries.last().unwrap() + ch.len_utf16());
    }
    let length = *boundaries.last().unwrap();
    let mut protected_start = selection.start.min(selection.end);
    let mut protected_end = selection.start.max(selection.end);
    if let Some(marked) = marked {
        protected_start = protected_start.min(marked.start.min(marked.end));
        protected_end = protected_end.max(marked.start.max(marked.end));
    }

    let floor_index = |offset: usize| {
        boundaries
            .partition_point(|boundary| *boundary <= offset.min(length))
            .saturating_sub(1)
    };
    let ceil_index =
        |offset: usize| boundaries.partition_point(|boundary| *boundary < offset.min(length));
    let protected_start_index = floor_index(protected_start);
    let protected_end_index = ceil_index(protected_end).min(boundaries.len() - 1);
    protected_start = boundaries[protected_start_index];
    protected_end = boundaries[protected_end_index];

    if code_points {
        let start_index = protected_start_index.saturating_sub(before);
        let end_index = protected_end_index
            .saturating_add(after)
            .min(boundaries.len() - 1);
        return (
            boundaries[start_index]..protected_start,
            protected_end..boundaries[end_index],
        );
    }

    let requested_start = protected_start.saturating_sub(before);
    let requested_end = protected_end.saturating_add(after).min(length);
    let start = boundaries[floor_index(requested_start)];
    let end = boundaries[ceil_index(requested_end).min(boundaries.len() - 1)];
    (start..protected_start, protected_end..end)
}

#[cfg(test)]
#[allow(
    clippy::reversed_empty_ranges,
    reason = "reversed ranges are backward selections"
)]
mod tests {
    use super::{deletion_ranges, selection_after_deletion};

    #[test]
    fn collapsed_and_selected_deletions_preserve_utf16_scalars() {
        let text = "\u{4f60}\u{1f600}\u{597d}";
        assert_eq!(deletion_ranges(text, 3..3, None, 1, 0, false), (1..3, 3..3));
        assert_eq!(deletion_ranges(text, 1..1, None, 0, 1, false), (1..1, 1..3));
        assert_eq!(deletion_ranges(text, 3..3, None, 2, 0, true), (0..3, 3..3));
        assert_eq!(deletion_ranges(text, 1..1, None, 0, 2, true), (1..1, 1..4));
        assert_eq!(
            deletion_ranges(text, 0..0, None, 99, 99, true),
            (0..0, 0..4)
        );

        assert_eq!(
            deletion_ranges("A\u{1f600}B", 1..1, None, 0, 1, false),
            (1..1, 1..3)
        );
        assert_eq!(
            deletion_ranges("A\u{1f600}B", 1..3, None, 1, 1, false),
            (0..1, 3..4)
        );
    }

    #[test]
    fn reversed_selection_and_composition_are_protected() {
        let text = "A\u{1f600}\u{65e5}\u{672c}\u{8a9e}Z";
        let forward = deletion_ranges(text, 3..4, None, 0, 1, false);
        let reversed = deletion_ranges(text, 4..3, None, 0, 1, false);
        assert_eq!(forward, (3..3, 4..5));
        assert_eq!(reversed, forward);

        assert_eq!(
            deletion_ranges("A\u{1f600}B", 1..1, Some(1..3), 0, 1, false),
            (1..1, 3..4),
        );
    }

    #[test]
    fn selection_after_delete_preserves_direction_and_shifts_only_for_left_deletes() {
        assert_eq!(selection_after_deletion(3..4, true, 0..0), 4..3);
        assert_eq!(selection_after_deletion(3..4, false, 0..0), 3..4);
        assert_eq!(selection_after_deletion(3..4, true, 1..3), 2..1);
        assert_eq!(selection_after_deletion(3..4, false, 1..3), 1..2);
    }

    #[test]
    fn utf16_ranges_expand_outward_to_complete_astral_scalars() {
        assert_eq!(
            deletion_ranges("A\u{1f600}B", 2..2, None, 0, 1, false),
            (1..1, 3..4)
        );
        assert_eq!(
            deletion_ranges("A\u{1f600}B", 1..1, None, 0, 1, false),
            (1..1, 1..3)
        );
        assert_eq!(
            deletion_ranges("A\u{1f600}B", 3..3, None, 1, 0, false),
            (1..3, 3..3)
        );
    }
}
