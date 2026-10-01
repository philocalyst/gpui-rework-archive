use crate::rich_text::{ChangeError, ChangeSet, Document};
use gpui::{NavigationDirection, SharedString};
use std::{cell::RefCell, ops::Range};
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

/// Implement this trait to provide custom content storage for EditableText elements.
/// The built-in keyed state constructors use the persistent [`Document`] backend; use
/// [`StringStorage`] directly when constructing a state that needs a mutable `String` adapter.
pub trait UnicodeTextStorage {
    /// Returns the version/generation of the content, which should be incremented ever time the
    /// content is changed so that rendering elements can reprocess the contents via the text layout engine.
    fn version(&self) -> u16;

    /// Returns a monotonically increasing revision for cache keys.
    ///
    /// This default preserves compatibility with existing storage implementations. Backends
    /// that can outlive `u16` wraparound should override it with their own wider generation.
    fn revision(&self) -> u64 {
        u64::from(self.version())
    }

    /// Returns a reference to the utf8 string.
    fn content_utf8(&self) -> &str;

    /// Returns the current UTF-8 byte length without requiring callers to inspect the contents.
    fn len_bytes(&self) -> usize {
        self.content_utf8().len()
    }

    /// Clamps a byte offset to a valid UTF-8 character boundary.
    fn clamp_byte_offset(&self, position: usize) -> usize {
        let text = self.content_utf8();
        let mut position = position.min(text.len());
        while !text.is_char_boundary(position) {
            position -= 1;
        }
        position
    }

    /// Returns a shared snapshot of the current content.
    ///
    /// The default copies the text. Backends that already retain shared text can override this
    /// to return a cheap clone, which lets editable elements avoid copying on every frame.
    fn shared_string(&self) -> SharedString {
        SharedString::from(self.content_utf8())
    }

    /// Returns a persistent document snapshot.
    ///
    /// The default implementation copies legacy storage into a document. Tree-backed storage
    /// should override this to return a cheap snapshot.
    fn document_snapshot(&self) -> Document {
        Document::new(self.content_utf8())
    }

    /// Copies the requested byte range using this backend's native slice operation when available.
    fn slice_bytes(&self, range: Range<usize>) -> String {
        self.content_utf8()[range].to_owned()
    }

    /// Applies a validated batch of replacements to this backend.
    ///
    /// The complete source is checked before any mutation. Replacements then apply from right to
    /// left so their original-snapshot byte ranges remain valid.
    fn apply_changes(&mut self, changes: &ChangeSet) -> Result<(), ChangeError> {
        if self.content_utf8() != changes.base_text() {
            return Err(ChangeError::StaleSource);
        }
        for change in changes.changes().iter().rev() {
            self.replace_range(change.range.clone(), &change.insert);
        }
        Ok(())
    }

    /// Restores a previously captured document snapshot.
    ///
    /// Custom legacy backends remain source-compatible and restore by replacing their contents.
    /// Persistent backends should override this to share the prior tree/root in constant time.
    fn restore_document(&mut self, document: &Document) -> Result<(), ChangeError> {
        self.replace_range(0..self.len_bytes(), document.as_str());
        Ok(())
    }

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
    revision: u64,
    shared_value: RefCell<Option<(u64, SharedString)>>,
    document_value: RefCell<Option<(u64, Document)>>,
}
impl<S> From<S> for StringStorage
where
    S: Into<String>,
{
    fn from(value: S) -> Self {
        Self {
            value: value.into(),
            version: u16::default(),
            revision: 0,
            shared_value: RefCell::default(),
            document_value: RefCell::default(),
        }
    }
}
impl UnicodeTextStorage for StringStorage {
    fn version(&self) -> u16 {
        self.version
    }

    fn revision(&self) -> u64 {
        self.revision
    }

    fn content_utf8(&self) -> &str {
        self.value.as_str()
    }

    fn shared_string(&self) -> SharedString {
        if let Some((revision, text)) = self.shared_value.borrow().as_ref()
            && *revision == self.revision
        {
            return text.clone();
        }

        let text = SharedString::from(self.value.as_str());
        self.shared_value
            .replace(Some((self.revision, text.clone())));
        text
    }

    fn document_snapshot(&self) -> Document {
        if let Some((revision, document)) = self.document_value.borrow().as_ref()
            && *revision == self.revision
        {
            return document.clone();
        }

        let document = Document::new(self.value.clone());
        self.document_value
            .replace(Some((self.revision, document.clone())));
        document
    }

    fn len_utf16(&self) -> usize {
        self.value.chars().map(|c| c.len_utf16()).sum()
    }

    fn replace_range(&mut self, range: Range<usize>, text: &str) {
        self.value.replace_range(range, &text);
        self.version = self.version.wrapping_add(1);
        self.revision = self.revision.wrapping_add(1);
        self.shared_value.get_mut().take();
        self.document_value.get_mut().take();
    }

    fn apply_changes(&mut self, changes: &ChangeSet) -> Result<(), ChangeError> {
        let updated = changes.apply_to(self.value.as_str())?;
        if updated != self.value {
            self.value = updated;
            self.version = self.version.wrapping_add(1);
            self.revision = self.revision.wrapping_add(1);
            self.shared_value.get_mut().take();
            self.document_value.get_mut().take();
        }
        Ok(())
    }
}
