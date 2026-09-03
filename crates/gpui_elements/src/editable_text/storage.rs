use gpui::NavigationDirection;
use std::ops::Range;
use unicode_segmentation::UnicodeSegmentation;

/// Describes a boundary within a chunk of text.
pub enum TextBoundary {
    /// The utf-8 character
    Graphmeme,
    /// The current word (using whitespace as delimiters)
    Word,
    /// The current line
    Line,
    /// The entire document
    Document,
}

/// Implement this trait to create a storage medium that can be used as the content of EditableText elements.
/// Default implementation is [`StringStorage`].
pub trait UnicodeTextStorage {
    /// Returns the version/generation of the content, which should be incremented ever time the
    /// content is changed so that rendering elements can reprocess the contents via the text layout engine.
    fn version(&self) -> u16;

    /// Returns a reference to the utf8 string.
    fn content_utf8(&self) -> &str;

    /// Returns the UTF-16 length of the content.
    fn len_utf16(&self) -> usize;

    /// Replace contents within the provided range with the given str slice.
    fn replace_range(&mut self, range: Range<usize>, text: &str);

    /// Returns the utf16 position equivalent of the provided utf8 character position.
    fn utf_offset_8to16(&self, pos_uft8: usize) -> usize {
        // Fast path: if offset is 0, return 0
        if pos_uft8 == 0 {
            return 0;
        }

        // Fast path: if offset is at or past end, return cached length
        if pos_uft8 >= self.content_utf8().len() {
            return self.len_utf16();
        }

        let mut count_utf16 = 0;
        for (idx, character) in self.content_utf8().char_indices() {
            if idx >= pos_uft8 {
                break;
            }
            count_utf16 += character.len_utf16();
        }
        count_utf16
    }

    /// Returns the utf8 position equivalent of the provided utf16 character position.
    fn utf_offset_16to8(&self, pos_utf16: usize) -> usize {
        // Fast path: if offset is 0, return 0
        if pos_utf16 == 0 {
            return 0;
        }

        let mut count_utf16 = 0;
        for (idx, character) in self.content_utf8().char_indices() {
            if count_utf16 >= pos_utf16 {
                return idx;
            }
            count_utf16 += character.len_utf16();
        }
        self.content_utf8().len()
    }

    /// Converts a utf8 character range into a utf16 character range.
    fn utf_range_8to16(&self, range_utf8: &Range<usize>) -> Range<usize> {
        self.utf_offset_8to16(range_utf8.start)..self.utf_offset_8to16(range_utf8.end)
    }

    /// Converts a utf16 character range into a utf8 character range.
    fn utf_range_16to8(&self, range_utf16: &Range<usize>) -> Range<usize> {
        self.utf_offset_16to8(range_utf16.start)..self.utf_offset_16to8(range_utf16.end)
    }

    /// Builds a utf8 character range based on a caret position within the storage,
    /// the direction to traverse, and the boundary to stop at.
    /// The start of the range will be the earlier position (destination if Back, caret if Forward),
    /// and the end will be the later position (caret if Back, destination if Forward).
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

    /// Finds the next location from the caret based on the direction to traverse and the boundary to stop at.
    fn offset_from_caret(
        &self,
        caret: usize,
        direction: NavigationDirection,
        boundary: TextBoundary,
    ) -> usize {
        use NavigationDirection::*;
        use TextBoundary::*;
        match (direction, boundary) {
            (Back, Graphmeme) => {
                if caret == 0 {
                    return 0;
                }

                let str = self.content_utf8();
                let iter = str[..caret.min(str.len())].grapheme_indices(true);
                iter.map(|(i, _)| i).next_back().unwrap_or(0)
            }
            (Forward, Graphmeme) => {
                let str = self.content_utf8();
                let len_utf8 = str.len();
                if caret >= len_utf8 {
                    return len_utf8;
                }

                let mut iter = str[caret..].grapheme_indices(true);
                iter.nth(1).map(|(i, _)| caret + i).unwrap_or(len_utf8)
            }
            (Back, Word) => {
                if caret == 0 {
                    return 0;
                }

                let str = self.content_utf8();
                let str = &str[..caret.min(str.len())];

                let mut last_word_start = 0;
                for (idx, _) in str.unicode_word_indices() {
                    if idx < caret {
                        last_word_start = idx;
                    }
                }

                if last_word_start == 0 && caret > 0 {
                    let trimmed = str.trim_end();
                    if trimmed.is_empty() {
                        return 0;
                    }
                    for (idx, _) in trimmed.unicode_word_indices() {
                        last_word_start = idx;
                    }
                }

                last_word_start
            }
            (Forward, Word) => {
                let str = self.content_utf8();
                let len_utf8 = str.len();
                if caret >= len_utf8 {
                    return len_utf8;
                }

                let str = &str[caret..];
                for (idx, word) in str.unicode_word_indices() {
                    let word_end = caret + idx + word.len();
                    if word_end > caret {
                        return word_end;
                    }
                }
                len_utf8
            }
            // Returns the utf-8 character position of first character after the first new-line
            // preceding the character at the provided utf-8 character position.
            (Back, Line) => {
                let str = self.content_utf8();
                let iter = str[..caret.min(str.len())].rfind('\n');
                iter.map(|pos| pos + 1).unwrap_or(0)
            }
            // Returns the utf-8 character position of the character immediately before the first
            // new-line character after the character at the provided utf-8 character position.
            (Forward, Line) => {
                let str = self.content_utf8();
                let iter = str[caret.min(str.len())..].find('\n');
                iter.map(|pos| caret + pos).unwrap_or(str.len())
            }
            (Back, Document) => 0,
            (Forward, Document) => self.content_utf8().len(),
        }
    }

    /// Returns the start and end of the word the position resides within.
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

/// [`UnicodeTextStorage`] implementation for [`String`].
/// This is not the most performant, especially for large text documents.
/// Its a decent default for editable text fields though.
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
    use gpui::NavigationDirection;

    #[test]
    fn string_storage_utf_offsets_round_trip_multibyte() {
        // "héllo😀": h(1B,1u16) é(2B,1u16) l(1B) l(1B) o(1B) 😀(4B,2u16)
        let storage = StringStorage::from("héllo😀");
        assert_eq!(storage.content_utf8(), "héllo😀");
        assert_eq!(storage.len_utf16(), 7);

        assert_eq!(storage.utf_offset_8to16(0), 0);
        assert_eq!(storage.utf_offset_8to16(1), 1, "start of é");
        assert_eq!(storage.utf_offset_8to16(3), 2, "after é");
        assert_eq!(storage.utf_offset_8to16(6), 5, "start of 😀");
        assert_eq!(storage.utf_offset_8to16(10), 7, "end of content");

        assert_eq!(storage.utf_offset_16to8(0), 0);
        assert_eq!(storage.utf_offset_16to8(1), 1);
        assert_eq!(storage.utf_offset_16to8(2), 3);
        assert_eq!(storage.utf_offset_16to8(5), 6);
        assert_eq!(storage.utf_offset_16to8(7), 10);

        assert_eq!(storage.utf_range_8to16(&(1..6)), 1..5);
        assert_eq!(storage.utf_range_16to8(&(1..5)), 1..6);
    }

    #[test]
    fn string_storage_navigation_and_version_bump() {
        let mut storage = StringStorage::from("hello world");
        assert_eq!(storage.word_range_at(4), 0..5);
        assert_eq!(storage.word_range_at(6), 6..11);
        assert_eq!(
            storage.offset_from_caret(5, NavigationDirection::Back, TextBoundary::Word),
            0,
            "backward word from mid-string"
        );
        assert_eq!(
            storage.offset_from_caret(6, NavigationDirection::Forward, TextBoundary::Word),
            11,
            "forward word to end"
        );
        assert_eq!(
            storage.offset_from_caret(5, NavigationDirection::Back, TextBoundary::Document),
            0
        );
        assert_eq!(
            storage.offset_from_caret(5, NavigationDirection::Forward, TextBoundary::Document),
            11
        );

        let multiline = StringStorage::from("ab\ncd");
        assert_eq!(
            multiline.offset_from_caret(4, NavigationDirection::Back, TextBoundary::Line),
            3,
            "backward line lands just after the preceding newline"
        );
        assert_eq!(
            multiline.offset_from_caret(0, NavigationDirection::Forward, TextBoundary::Line),
            2,
            "forward line lands just before the next newline"
        );

        // A grapheme cluster (biceps + skin tone) is a single graphmeme boundary.
        let clusters = StringStorage::from("a💪🏽b");
        assert_eq!(
            clusters.offset_from_caret(1, NavigationDirection::Forward, TextBoundary::Graphmeme),
            9,
            "forward graphmeme skips the whole cluster"
        );
        assert_eq!(
            clusters.offset_from_caret(9, NavigationDirection::Back, TextBoundary::Graphmeme),
            1
        );

        let version = storage.version();
        storage.replace_range(6..11, "there");
        assert_eq!(storage.content_utf8(), "hello there");
        assert_eq!(storage.version(), version.wrapping_add(1));
    }
}
