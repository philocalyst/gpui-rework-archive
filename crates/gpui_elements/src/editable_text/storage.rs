//! Storage contracts for editable text and UTF-8/UTF-16 boundary conversion.
//!
//! Implementations own the document text and must change [`UnicodeTextStorage::version`] whenever
//! its contents change. The storage API uses UTF-8 byte offsets and Rust `str` slicing, so every
//! range passed to [`UnicodeTextStorage::replace_range`] must be ordered, in bounds, and on UTF-8
//! character boundaries. These offsets count bytes, not Unicode scalar values or user-perceived
//! grapheme clusters. The default navigation helpers move by grapheme cluster for `Cluster`, use
//! `unicode_word_indices` for `Word`, and use newline delimiters for line movement.
//!
//! The web input bridge speaks UTF-16 because browser selection and composition APIs use code
//! units. Use the conversion methods at that boundary; keep document mutations and selection state
//! in UTF-8. For a long document, a custom piece table or rope can implement this trait, but it
//! must still provide a valid `&str` view and an accurate UTF-16 length.

pub use gpui::TextBoundary;
use gpui::{NavigationDirection, utf8_to_utf16_offset, utf16_to_utf8_offset};
use std::ops::Range;
use unicode_segmentation::UnicodeSegmentation;

/// Text storage used by [`super::EditableTextState`].
///
/// Implement this trait to replace the default [`StringStorage`] with a document representation
/// suited to the application's size and mutation pattern. GPUI currently requests a contiguous
/// `&str` for layout and snapshots the current contents as a [`gpui::SharedString`], so this trait
/// does not by itself make the rendering pipeline zero-copy. [`replace_range`](Self::replace_range)
/// receives UTF-8 byte indices and must apply valid in-range edits while preserving UTF-8.
/// Advance [`version`](Self::version) whenever content changes so the element rebuilds its layout.
pub trait UnicodeTextStorage {
    /// Returns the current content generation.
    ///
    /// Advance this value after every content mutation, including edits made outside
    /// [`EditableTextState`](super::EditableTextState). It is a `u16`, so wrapping is allowed; do
    /// not use it as a globally unique revision id.
    fn version(&self) -> u16;

    /// Returns the current contents as valid UTF-8.
    fn content_utf8(&self) -> &str;

    /// Returns the number of UTF-16 code units in the current contents.
    ///
    /// This is not the UTF-8 byte length or the number of Rust `char`s. For example, `"a😀"` has
    /// 5 UTF-8 bytes, 2 Rust `char`s, and 3 UTF-16 code units.
    fn len_utf16(&self) -> usize;

    /// Replaces a UTF-8 byte range with `text`.
    ///
    /// The range supplied by editable text is valid, ordered, within the current string, and on
    /// UTF-8 character boundaries. Implementations must update [`version`](Self::version).
    fn replace_range(&mut self, range: Range<usize>, text: &str);

    /// Converts a UTF-8 byte offset to a UTF-16 code-unit offset.
    ///
    /// The default implementation clamps offsets past the end. An offset inside an encoded
    /// character rounds forward to that character's end, as in
    /// [`utf8_to_utf16_offset`](gpui::utf8_to_utf16_offset).
    /// This converts units; it does not normalize to a grapheme boundary.
    fn utf_offset_8to16(&self, pos_uft8: usize) -> usize {
        // Fast path: if offset is 0, return 0
        if pos_uft8 == 0 {
            return 0;
        }

        // Fast path: if offset is at or past end, return cached length
        if pos_uft8 >= self.content_utf8().len() {
            return self.len_utf16();
        }

        utf8_to_utf16_offset(self.content_utf8(), pos_uft8)
    }

    /// Converts a UTF-16 code-unit offset to a UTF-8 byte offset.
    ///
    /// The default implementation clamps offsets past the end and rounds an offset inside a
    /// surrogate pair forward to that character's end, as in
    /// [`utf16_to_utf8_offset`](gpui::utf16_to_utf8_offset).
    ///
    /// ```
    /// use gpui_ce_elements::editable_text::{StringStorage, UnicodeTextStorage};
    ///
    /// let text = StringStorage::from("a😀b");
    /// assert_eq!(text.utf_offset_8to16(5), 3); // After the emoji: bytes become code units.
    /// assert_eq!(text.utf_offset_16to8(3), 5); // The same boundary in the other direction.
    /// assert_eq!(text.utf_offset_16to8(2), 5); // Inside the surrogate pair: round forward.
    /// ```
    fn utf_offset_16to8(&self, pos_utf16: usize) -> usize {
        // Fast path: if offset is 0, return 0
        if pos_utf16 == 0 {
            return 0;
        }

        utf16_to_utf8_offset(self.content_utf8(), pos_utf16)
    }

    /// Converts both endpoints of a UTF-8 byte range to UTF-16 code units.
    ///
    /// Each endpoint follows [`utf_offset_8to16`](Self::utf_offset_8to16), including its clamping
    /// and rounding rules. This does not sort endpoints or expand to whole graphemes.
    fn utf_range_8to16(&self, range_utf8: &Range<usize>) -> Range<usize> {
        self.utf_offset_8to16(range_utf8.start)..self.utf_offset_8to16(range_utf8.end)
    }

    /// Converts both endpoints of a UTF-16 code-unit range to UTF-8 bytes.
    ///
    /// Each endpoint follows [`utf_offset_16to8`](Self::utf_offset_16to8), including its clamping
    /// and rounding rules. This does not sort endpoints or expand to whole graphemes.
    fn utf_range_16to8(&self, range_utf16: &Range<usize>) -> Range<usize> {
        self.utf_offset_16to8(range_utf16.start)..self.utf_offset_16to8(range_utf16.end)
    }

    /// Returns the source range between `caret` and its navigation destination.
    ///
    /// Supply an in-bounds UTF-8 character boundary. Backward movement returns `destination..caret`;
    /// forward movement returns `caret..destination`. The default delegates to
    /// [`offset_from_caret`](Self::offset_from_caret) and preserves the supplied caret endpoint;
    /// it does not clamp that endpoint or validate a range returned by a custom implementation.
    fn range_from_caret(
        &self,
        caret: usize,
        direction: NavigationDirection,
        magnitude: TextBoundary,
    ) -> Range<usize> {
        let offset = self.offset_from_caret(caret, direction, magnitude);
        match direction {
            NavigationDirection::Back => offset..caret,
            NavigationDirection::Forward => caret..offset,
        }
    }

    /// Finds a navigation destination in logical source order, in UTF-8 bytes.
    ///
    /// Backward means earlier in the string, which can differ from visually left in bidirectional
    /// text. Supply a UTF-8 character boundary; the default implementation slices at the caret and
    /// can panic for an interior byte. Grapheme movement also needs a grapheme boundary if it must
    /// preserve whole clusters.
    ///
    /// `Cluster` uses Unicode grapheme segmentation. `Word` moves to the preceding word's start or
    /// the following word's end, using `unicode_word_indices`. Both `VisualLine` and `HardLine`
    /// stop at newline boundaries here: storage has no wrapping geometry. Keyboard actions on
    /// the field use shaped layout when available; these storage helpers do not.
    fn offset_from_caret(
        &self,
        caret: usize,
        direction: NavigationDirection,
        boundary: TextBoundary,
    ) -> usize {
        use NavigationDirection::*;
        use TextBoundary::*;
        match (direction, boundary) {
            (Back, Cluster) => {
                if caret == 0 {
                    return 0;
                }

                let str = self.content_utf8();
                let iter = str[..caret.min(str.len())].grapheme_indices(true);
                iter.map(|(i, _)| i).next_back().unwrap_or(0)
            }
            (Forward, Cluster) => {
                let str = self.content_utf8();
                let len_utf8 = str.len();
                if caret >= len_utf8 {
                    return len_utf8;
                }

                let mut iter = str[caret..].grapheme_indices(true);
                iter.nth(1).map(|(i, _)| caret + i).unwrap_or(len_utf8)
            }
            (Back, Word) => {
                let text = self.content_utf8();
                let prefix = &text[..caret.min(text.len())];

                prefix
                    .unicode_word_indices()
                    .next_back()
                    .map_or(0, |(idx, _word)| idx)
            }
            (Forward, Word) => {
                let text = self.content_utf8();
                let len_utf8 = text.len();

                if caret >= len_utf8 {
                    return len_utf8;
                }

                text[caret..]
                    .unicode_word_indices()
                    .next()
                    .map_or(len_utf8, |(idx, word)| caret + idx + word.len())
            }
            // Returns the utf-8 character position of first character after the first new-line
            // preceding the character at the provided utf-8 character position.
            (Back, VisualLine | HardLine) => {
                let str = self.content_utf8();
                let iter = str[..caret.min(str.len())].rfind('\n');
                iter.map(|pos| pos + 1).unwrap_or(0)
            }
            // Returns the utf-8 character position of the character immediately before the first
            // new-line character after the character at the provided utf-8 character position.
            (Forward, VisualLine | HardLine) => {
                let str = self.content_utf8();
                let iter = str[caret.min(str.len())..].find('\n');
                iter.map(|pos| caret + pos).unwrap_or(str.len())
            }
            (Back, Document) => 0,
            (Forward, Document) => self.content_utf8().len(),
        }
    }

    /// Returns the UTF-8 byte range of the Unicode word at or ending at `position`.
    ///
    /// The default uses Unicode word segmentation and includes a word's end when testing the
    /// position. Thus an offset exactly between a word and its following punctuation selects
    /// that word. Other gaps return an empty range at the offset. Positions past the text end
    /// clamp to the end and can select the final word.
    ///
    /// ```
    /// use gpui_ce_elements::editable_text::{StringStorage, UnicodeTextStorage};
    ///
    /// let text = StringStorage::from("cat! dog");
    /// assert_eq!(text.word_range_at(3), 0..3); // The end of "cat", just before '!'.
    /// assert_eq!(text.word_range_at(4), 4..4); // The gap after '!'.
    /// assert_eq!(text.word_range_at(99), 5..8); // Clamped to the final word's end.
    /// ```
    fn word_range_at(&self, position: usize) -> Range<usize> {
        let offset = position.min(self.content_utf8().len());

        for (idx, word) in self.content_utf8().unicode_word_indices() {
            let word_end = idx + word.len();
            if offset >= idx && offset <= word_end {
                return idx..word_end;
            }
        }

        offset..offset
    }
}

/// Simple [`UnicodeTextStorage`] implementation backed by [`String`].
///
/// Each edit uses `String::replace_range`; text length and snapshots are based on the complete
/// string. It is a practical default for short fields and small text areas. Larger documents can
/// use another storage implementation, while accounting for the current layout API's need for a
/// contiguous `&str` view.
#[derive(Clone, Default)]
pub struct StringStorage {
    value: String,
    version: u16,
}
impl<S> From<S> for StringStorage
where
    S: Into<String>,
{
    fn from(value: S) -> Self {
        Self {
            value: value.into(),
            version: u16::default(),
        }
    }
}
impl UnicodeTextStorage for StringStorage {
    fn version(&self) -> u16 {
        self.version
    }

    fn content_utf8(&self) -> &str {
        self.value.as_str()
    }

    fn len_utf16(&self) -> usize {
        self.value.chars().map(|c| c.len_utf16()).sum()
    }

    fn replace_range(&mut self, range: Range<usize>, text: &str) {
        self.value.replace_range(range, &text);
        self.version = self.version.wrapping_add(1);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn word_navigation_handles_boundaries_and_scripts() {
        for (text, caret, direction, expected) in [
            ("", 0, NavigationDirection::Back, 0),
            ("", 0, NavigationDirection::Forward, 0),
            ("   ", 3, NavigationDirection::Back, 0),
            ("   ", 0, NavigationDirection::Forward, 3),
            ("hello world", 11, NavigationDirection::Back, 6),
            ("hello world", 0, NavigationDirection::Forward, 5),
            ("hello world", 2, NavigationDirection::Forward, 5),
            (", hi!", 5, NavigationDirection::Back, 2),
            (", hi!", 0, NavigationDirection::Forward, 4),
            ("a 日本語 b", 11, NavigationDirection::Back, 8),
            ("a 日本語 b", 2, NavigationDirection::Forward, 5),
            ("hi", 100, NavigationDirection::Back, 0),
            ("hi", 100, NavigationDirection::Forward, 2),
        ] {
            let storage = StringStorage::from(text);

            assert_eq!(
                storage.offset_from_caret(caret, direction, TextBoundary::Word),
                expected,
                "text {text:?}, caret {caret}, direction {direction:?}",
            );
        }
    }
}
