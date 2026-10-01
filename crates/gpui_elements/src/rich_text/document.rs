//! Persistent UTF-8 text documents used by rich-text editing.

use super::{Change, ChangeError, ChangeSet, Selection};
use crate::editable_text::TextBoundary;
use gpui::{NavigationDirection, SharedString};
use std::{
    fmt,
    ops::Range,
    sync::{Arc, OnceLock},
};
use sum_tree::{Bias, ContextLessSummary, Dimension, Dimensions, Item, SumTree};

const TARGET_CHUNK_BYTES: usize = 2 * 1024;
const MAX_CHUNK_BYTES: usize = 4 * 1024;

#[derive(Clone)]
struct TextChunk {
    text: Arc<str>,
    summary: TextSummary,
}

impl TextChunk {
    fn new(text: &str) -> Self {
        Self {
            text: Arc::from(text),
            summary: TextSummary::of(text),
        }
    }

    fn as_str(&self) -> &str {
        self.text.as_ref()
    }
}

impl fmt::Debug for TextChunk {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter
            .debug_struct("TextChunk")
            .field("bytes", &self.text.len())
            .finish()
    }
}

#[derive(Clone, Copy, Debug, Default)]
struct TextSummary {
    bytes: usize,
    utf16: usize,
    line_feeds: usize,
}

impl TextSummary {
    fn of(text: &str) -> Self {
        Self {
            bytes: text.len(),
            utf16: text.encode_utf16().count(),
            line_feeds: text.bytes().filter(|byte| *byte == b'\n').count(),
        }
    }
}

impl ContextLessSummary for TextSummary {
    fn zero() -> Self {
        Self::default()
    }

    fn add_summary(&mut self, summary: &Self) {
        self.bytes += summary.bytes;
        self.utf16 += summary.utf16;
        self.line_feeds += summary.line_feeds;
    }
}

impl Item for TextChunk {
    type Summary = TextSummary;

    fn summary(&self, _: ()) -> Self::Summary {
        self.summary
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct ByteLen(usize);

impl<'a> Dimension<'a, TextSummary> for ByteLen {
    fn zero(_: ()) -> Self {
        Self(0)
    }

    fn add_summary(&mut self, summary: &'a TextSummary, _: ()) {
        self.0 += summary.bytes;
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Utf16Len(usize);

impl<'a> Dimension<'a, TextSummary> for Utf16Len {
    fn zero(_: ()) -> Self {
        Self(0)
    }

    fn add_summary(&mut self, summary: &'a TextSummary, _: ()) {
        self.0 += summary.utf16;
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct LineCount(usize);

impl<'a> Dimension<'a, TextSummary> for LineCount {
    fn zero(_: ()) -> Self {
        Self(0)
    }

    fn add_summary(&mut self, summary: &'a TextSummary, _: ()) {
        self.0 += summary.line_feeds;
    }
}

struct DocumentData {
    tree: SumTree<TextChunk>,
    revision: u64,
    flattened: OnceLock<SharedString>,
}

/// A persistent UTF-8 document with byte, UTF-16, and line indexes.
///
/// Cloning a document is constant time and keeps the original snapshot alive. Edits use a
/// copy-on-write B+ tree of roughly 2 KiB text chunks; only the paths and chunk seams touched by
/// an edit are rebuilt. `as_str` is available for compatibility and lazily caches one contiguous
/// [`SharedString`] per snapshot. Native queries and edits do not require that flattening.
#[derive(Clone)]
pub struct Document {
    data: Arc<DocumentData>,
}

impl fmt::Debug for Document {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter
            .debug_struct("Document")
            .field("revision", &self.revision())
            .field("len_bytes", &self.len_bytes())
            .field("len_utf16", &self.len_utf16())
            .field("line_count", &self.line_count())
            .finish()
    }
}

impl Default for Document {
    fn default() -> Self {
        Self::new("")
    }
}

impl Document {
    /// Creates a new document at revision zero.
    pub fn new(text: impl Into<String>) -> Self {
        let text = text.into();
        Self::from_tree(tree_from_text(&text), 0)
    }

    /// Creates a document from a shared GPUI string.
    pub fn from_shared_string(text: SharedString) -> Self {
        let mut document = Self::from_tree(tree_from_text(text.as_ref()), 0);
        Arc::get_mut(&mut document.data)
            .expect("new document data has one owner")
            .flattened
            .get_or_init(|| text);
        document
    }

    fn from_tree(tree: SumTree<TextChunk>, revision: u64) -> Self {
        Self {
            data: Arc::new(DocumentData {
                tree,
                revision,
                flattened: OnceLock::new(),
            }),
        }
    }

    /// Returns this snapshot's monotonically increasing revision.
    pub fn revision(&self) -> u64 {
        self.data.revision
    }

    /// Returns the number of UTF-8 bytes in the document.
    pub fn len_bytes(&self) -> usize {
        self.data.tree.summary().bytes
    }

    /// Returns the number of UTF-16 code units in the document.
    pub fn len_utf16(&self) -> usize {
        self.data.tree.summary().utf16
    }

    /// Returns the number of LF-delimited lines. Empty text has one line.
    pub fn line_count(&self) -> usize {
        self.data.tree.summary().line_feeds + 1
    }

    /// Returns a cached contiguous view of this revision.
    ///
    /// The first call joins all text chunks. Further calls borrow the same cached string.
    pub fn as_str(&self) -> &str {
        self.shared_string_ref().as_ref()
    }

    /// Returns this revision's cached contiguous GPUI string by cheap clone.
    pub fn shared_string(&self) -> SharedString {
        self.shared_string_ref().clone()
    }

    fn shared_string_ref(&self) -> &SharedString {
        self.data.flattened.get_or_init(|| {
            let mut text = String::with_capacity(self.len_bytes());
            for chunk in self.chunks() {
                text.push_str(chunk);
            }
            SharedString::from(text)
        })
    }

    /// Iterates over the document's UTF-8 chunks without joining them.
    pub fn chunks(&self) -> impl Iterator<Item = &str> {
        self.data.tree.iter().map(TextChunk::as_str)
    }

    /// Returns the number of backing chunks, primarily useful for diagnostics and benchmarks.
    pub fn chunk_count(&self) -> usize {
        self.data.tree.iter().count()
    }

    /// Returns the byte lengths of the backing chunks.
    pub fn chunk_byte_lengths(&self) -> impl Iterator<Item = usize> + '_ {
        self.data.tree.iter().map(|chunk| chunk.text.len())
    }

    /// Finds the chunk adjacent to a byte position using the requested seam bias.
    ///
    /// At an interior chunk boundary, [`Bias::Left`] returns the chunk ending at the position
    /// and [`Bias::Right`] returns the chunk starting there. Positions are clamped to the
    /// document bounds. An empty document has no chunk.
    pub(crate) fn chunk_at_byte(&self, position: usize, bias: Bias) -> Option<(&str, usize)> {
        if self.data.tree.is_empty() {
            return None;
        }
        let position = position.min(self.len_bytes());
        let mut cursor = self.data.tree.cursor::<ByteLen>(());
        cursor.seek(&ByteLen(position), bias);
        cursor
            .item()
            .map(|chunk| (chunk.as_str(), cursor.position.0))
    }

    /// Copies a UTF-8 byte range into a new string.
    ///
    /// The range must be ordered, in bounds, and aligned to UTF-8 boundaries.
    pub fn slice(&self, range: Range<usize>) -> String {
        self.try_slice(range)
            .expect("document slice must be an in-bounds UTF-8 range")
    }

    /// Copies a UTF-8 byte range after validating its bounds and boundaries.
    pub fn try_slice(&self, range: Range<usize>) -> Result<String, ChangeError> {
        self.validate_range(&range)?;
        let mut result = String::with_capacity(range.len());
        for piece in self.chunk_slices_in_valid_range(range) {
            result.push_str(piece);
        }
        Ok(result)
    }

    /// Returns whether `position` is a UTF-8 character boundary.
    pub fn is_char_boundary(&self, position: usize) -> bool {
        if position > self.len_bytes() {
            return false;
        }
        if position == 0 || position == self.len_bytes() {
            return true;
        }

        let mut cursor = self.data.tree.cursor::<ByteLen>(());
        cursor.seek(&ByteLen(position), Bias::Left);
        let Some(chunk) = cursor.item() else {
            return position == self.len_bytes();
        };
        chunk
            .as_str()
            .is_char_boundary(position - cursor.position.0)
    }

    /// Clamps a byte position to the nearest UTF-8 boundary at or before it.
    pub fn clamp_byte_offset(&self, position: usize) -> usize {
        let position = position.min(self.len_bytes());
        if self.is_char_boundary(position) {
            return position;
        }

        let mut cursor = self.data.tree.cursor::<ByteLen>(());
        cursor.seek(&ByteLen(position), Bias::Left);
        let Some(chunk) = cursor.item() else {
            return self.len_bytes();
        };
        let mut local = position - cursor.position.0;
        while !chunk.as_str().is_char_boundary(local) {
            local -= 1;
        }
        cursor.position.0 + local
    }

    /// Converts a UTF-8 byte offset to UTF-16 code units.
    ///
    /// An offset inside a scalar value is treated as lying after that scalar, matching the
    /// historical `UnicodeTextStorage` conversion behavior.
    pub fn byte_to_utf16(&self, position: usize) -> usize {
        let position = position.min(self.len_bytes());
        if position == self.len_bytes() {
            return self.len_utf16();
        }

        let mut cursor = self.data.tree.cursor::<Dimensions<ByteLen, Utf16Len>>(());
        cursor.seek(&ByteLen(position), Bias::Left);
        let byte_start = cursor.position.0.0;
        let utf16_start = cursor.position.1.0;
        let Some(chunk) = cursor.item() else {
            return self.len_utf16();
        };
        let local_position = position - byte_start;
        let mut utf16 = utf16_start;
        for (byte, character) in chunk.as_str().char_indices() {
            if byte >= local_position {
                break;
            }
            utf16 += character.len_utf16();
        }
        utf16
    }

    /// Converts a UTF-16 code-unit offset to a UTF-8 byte boundary.
    ///
    /// Positions inside a surrogate pair are rounded forward to the next scalar boundary.
    pub fn utf16_to_byte(&self, position: usize) -> usize {
        if position >= self.len_utf16() {
            return self.len_bytes();
        }

        let mut cursor = self.data.tree.cursor::<Dimensions<Utf16Len, ByteLen>>(());
        cursor.seek(&Utf16Len(position), Bias::Left);
        let mut byte = cursor.position.1.0;
        let mut utf16 = cursor.position.0.0;
        let Some(chunk) = cursor.item() else {
            return self.len_bytes();
        };
        for character in chunk.as_str().chars() {
            if utf16 >= position {
                return byte;
            }
            utf16 += character.len_utf16();
            byte += character.len_utf8();
        }
        byte
    }

    /// Returns the zero-based line containing a UTF-8 byte offset.
    pub fn line_index(&self, position: usize) -> usize {
        let position = self.clamp_byte_offset(position);
        if position == 0 {
            return 0;
        }
        let mut cursor = self.data.tree.cursor::<ByteLen>(());
        let preceding: LineCount = cursor.summary(&ByteLen(position), Bias::Left);
        let local = position.saturating_sub(cursor.position.0);
        preceding.0
            + cursor
                .item()
                .map(|chunk| {
                    chunk.as_str()[..local]
                        .bytes()
                        .filter(|byte| *byte == b'\n')
                        .count()
                })
                .unwrap_or(0)
    }

    /// Returns the byte range of an LF-delimited line, excluding its LF terminator.
    ///
    /// In CRLF text, the CR byte remains part of the line. A trailing LF creates an empty final
    /// line, and line zero in an empty document is `0..0`.
    pub fn line_range(&self, line: usize) -> Option<Range<usize>> {
        if line >= self.line_count() {
            return None;
        }
        let start = if line == 0 {
            0
        } else {
            self.find_line_feed(line - 1)? + 1
        };
        let end = self
            .find_line_feed(line)
            .unwrap_or_else(|| self.len_bytes());
        Some(start..end)
    }

    /// Returns whether two values refer to the exact same immutable revision snapshot.
    pub fn same_snapshot(&self, other: &Self) -> bool {
        Arc::ptr_eq(&self.data, &other.data)
    }

    /// Restores a prior persistent snapshot in constant time.
    ///
    /// The editable state that owns this document should track its own monotonic generation for
    /// history and rendering; the restored document exposes the snapshot's original revision.
    pub fn restore_from(&mut self, snapshot: &Self) {
        self.clone_from(snapshot);
    }

    /// Starts a transaction whose edits use coordinates in this snapshot.
    pub fn transaction(&self) -> TransactionBuilder {
        TransactionBuilder {
            base: self.clone(),
            changes: Vec::new(),
            selection: None,
        }
    }

    /// Applies a prepared transaction if it was built from this exact snapshot.
    pub fn apply(&mut self, transaction: &Transaction) -> Result<(), ChangeError> {
        if !self.same_snapshot(&transaction.base) {
            return Err(ChangeError::StaleDocument);
        }
        self.apply_changes(&transaction.changes)
    }

    /// Applies a validated batch to this snapshot atomically.
    pub fn apply_changes(&mut self, changes: &ChangeSet) -> Result<(), ChangeError> {
        changes.validate_document_source(self)?;
        if changes.is_noop() {
            return Ok(());
        }

        let revision = self
            .revision()
            .checked_add(1)
            .ok_or(ChangeError::RevisionOverflow)?;
        let mut tree = self.data.tree.clone();
        for change in changes.changes().iter().rev() {
            tree = splice_tree(&tree, change.range.start, change.range.end, &change.insert);
        }

        *self = Self::from_tree(tree, revision);
        Ok(())
    }

    fn validate_range(&self, range: &Range<usize>) -> Result<(), ChangeError> {
        if range.start > range.end {
            return Err(ChangeError::InvalidSliceRange {
                range: range.clone(),
                len: self.len_bytes(),
            });
        }
        if range.end > self.len_bytes() {
            return Err(ChangeError::InvalidSliceRange {
                range: range.clone(),
                len: self.len_bytes(),
            });
        }
        if !self.is_char_boundary(range.start) {
            return Err(ChangeError::PositionNotCharBoundary {
                position: range.start,
            });
        }
        if !self.is_char_boundary(range.end) {
            return Err(ChangeError::PositionNotCharBoundary {
                position: range.end,
            });
        }
        Ok(())
    }

    fn find_line_feed(&self, index: usize) -> Option<usize> {
        let mut cursor = self.data.tree.cursor::<Dimensions<LineCount, ByteLen>>(());
        cursor.seek(&LineCount(index), Bias::Right);
        let lines_before = cursor.position.0.0;
        let bytes_before = cursor.position.1.0;
        let chunk = cursor.item()?;
        let local_index = index.checked_sub(lines_before)?;
        chunk
            .as_str()
            .match_indices('\n')
            .nth(local_index)
            .map(|(offset, _)| bytes_before + offset)
    }

    pub(crate) fn content_equals(&self, text: &str) -> bool {
        if self.len_bytes() != text.len() {
            return false;
        }
        let mut rest = text;
        for chunk in self.chunks() {
            let Some(suffix) = rest.strip_prefix(chunk) else {
                return false;
            };
            rest = suffix;
        }
        rest.is_empty()
    }

    pub(crate) fn content_matches_segments<'a>(
        &self,
        segments: impl IntoIterator<Item = &'a str>,
    ) -> bool {
        let mut chunks = self.chunks();
        let mut current = chunks.next();
        let mut current_offset = 0usize;

        for segment in segments {
            let mut bytes = segment.as_bytes();
            while !bytes.is_empty() {
                while current.is_some_and(|chunk| current_offset == chunk.len()) {
                    current = chunks.next();
                    current_offset = 0;
                }
                let Some(chunk) = current else {
                    return false;
                };
                let remaining = chunk.len() - current_offset;
                let count = remaining.min(bytes.len());
                if chunk.as_bytes()[current_offset..current_offset + count] != bytes[..count] {
                    return false;
                }
                current_offset += count;
                bytes = &bytes[count..];
            }
        }

        while current.is_some_and(|chunk| current_offset == chunk.len()) {
            current = chunks.next();
            current_offset = 0;
        }
        current.is_none()
    }

    pub(crate) fn chunk_slices_in_range(
        &self,
        range: Range<usize>,
    ) -> impl Iterator<Item = &str> + '_ {
        self.validate_range(&range)
            .expect("chunk slice must be an in-bounds UTF-8 range");
        self.chunk_slices_in_valid_range(range)
    }

    fn chunk_slices_in_valid_range(&self, range: Range<usize>) -> impl Iterator<Item = &str> + '_ {
        let mut cursor = self.data.tree.cursor::<ByteLen>(());
        let mut chunk_start = if range.is_empty() {
            0
        } else {
            cursor.seek(&ByteLen(range.start), Bias::Right);
            cursor.position.0
        };
        let mut done = range.is_empty();
        std::iter::from_fn(move || {
            if done {
                return None;
            }

            loop {
                let chunk = cursor.item()?;
                let chunk_end = chunk_start + chunk.as_str().len();
                let local_start = range.start.saturating_sub(chunk_start);
                let local_end = range.end.min(chunk_end) - chunk_start;
                if local_start < local_end {
                    if chunk_end >= range.end {
                        done = true;
                    } else {
                        chunk_start = chunk_end;
                        cursor.next();
                    }
                    return Some(&chunk.as_str()[local_start..local_end]);
                }

                if chunk_end >= range.end {
                    done = true;
                    return None;
                }
                chunk_start = chunk_end;
                cursor.next();
            }
        })
    }
}

impl From<String> for Document {
    fn from(text: String) -> Self {
        Self::new(text)
    }
}

impl From<&str> for Document {
    fn from(text: &str) -> Self {
        Self::new(text)
    }
}

fn tree_from_text(text: &str) -> SumTree<TextChunk> {
    SumTree::from_iter(chunk_text(text), ())
}

fn chunk_text(text: &str) -> Vec<TextChunk> {
    if text.is_empty() {
        return Vec::new();
    }

    let count = text.len().div_ceil(TARGET_CHUNK_BYTES);
    let mut chunks = Vec::with_capacity(count);
    let mut start = 0usize;
    while start < text.len() {
        let remaining_chunks = count - chunks.len();
        let target_len = (text.len() - start)
            .div_ceil(remaining_chunks)
            .min(MAX_CHUNK_BYTES);
        let mut end = (start + target_len).min(text.len());
        while !text.is_char_boundary(end) {
            end -= 1;
        }
        if end == start {
            end = text[start..]
                .char_indices()
                .nth(1)
                .map(|(offset, _)| start + offset)
                .unwrap_or(text.len());
        }
        chunks.push(TextChunk::new(&text[start..end]));
        start = end;
    }
    chunks
}

fn split_at(
    tree: &SumTree<TextChunk>,
    position: usize,
) -> (SumTree<TextChunk>, SumTree<TextChunk>) {
    let mut cursor = tree.cursor::<ByteLen>(());
    let mut prefix = cursor.slice(&ByteLen(position), Bias::Left);
    let mut suffix = SumTree::new(());

    let local = position.saturating_sub(cursor.position.0);
    if let Some(chunk) = cursor.item() {
        let text = chunk.as_str();
        debug_assert!(text.is_char_boundary(local));
        if local > 0 {
            prefix.push(TextChunk::new(&text[..local]), ());
        }
        if local < text.len() {
            suffix.push(TextChunk::new(&text[local..]), ());
        }
        cursor.next();
    }
    suffix.append(cursor.suffix(), ());
    (prefix, suffix)
}

fn splice_tree(
    tree: &SumTree<TextChunk>,
    start: usize,
    end: usize,
    insert: &str,
) -> SumTree<TextChunk> {
    let (left, remaining) = split_at(tree, start);
    let (_, right) = split_at(&remaining, end - start);
    let inserted = tree_from_text(insert);
    let joined = append_normalized(left, inserted);
    append_normalized(joined, right)
}

fn append_normalized(left: SumTree<TextChunk>, right: SumTree<TextChunk>) -> SumTree<TextChunk> {
    if left.is_empty() {
        return right;
    }
    if right.is_empty() {
        return left;
    }

    let left_len = left.summary().bytes;
    let left_tail = left.last().expect("non-empty tree").clone();
    let right_head = right.first().expect("non-empty tree").clone();
    let (left_prefix, _) = split_at(&left, left_len - left_tail.as_str().len());
    let (_, right_suffix) = split_at(&right, right_head.as_str().len());

    let mut seam = String::with_capacity(left_tail.as_str().len() + right_head.as_str().len());
    seam.push_str(left_tail.as_str());
    seam.push_str(right_head.as_str());

    let mut result = left_prefix;
    result.append(tree_from_text(&seam), ());
    result.append(right_suffix, ());
    result
}

/// A builder for a snapshot-bound transaction.
pub struct TransactionBuilder {
    base: Document,
    changes: Vec<Change>,
    selection: Option<Selection>,
}

impl TransactionBuilder {
    /// Adds a replacement using byte coordinates from the builder's base snapshot.
    pub fn replace(mut self, range: Range<usize>, text: impl Into<String>) -> Self {
        self.changes.push(Change::new(range, text));
        self
    }

    /// Sets the resulting selection in the edited document.
    pub fn selection(mut self, selection: Selection) -> Self {
        self.selection = Some(selection);
        self
    }

    /// Validates all replacements and the optional post-edit selection.
    pub fn build(self) -> Result<Transaction, ChangeError> {
        let changes = ChangeSet::for_document(&self.base, self.changes)?;
        if let Some(selection) = self.selection {
            changes.validate_result_position(selection.anchor)?;
            changes.validate_result_position(selection.head)?;
        }
        Ok(Transaction {
            base: self.base,
            changes,
            selection: self.selection,
        })
    }
}

/// A validated set of edits tied to one exact document snapshot.
#[derive(Clone, Debug)]
pub struct Transaction {
    base: Document,
    changes: ChangeSet,
    selection: Option<Selection>,
}

impl Transaction {
    /// Returns the validated edit batch.
    pub fn changes(&self) -> &ChangeSet {
        &self.changes
    }

    /// Returns the validated edit batch.
    pub fn change_set(&self) -> &ChangeSet {
        &self.changes
    }

    /// Returns the post-edit selection, if one was specified.
    pub fn selection(&self) -> Option<Selection> {
        self.selection
    }

    /// Returns the source revision captured when this transaction was built.
    pub fn base_revision(&self) -> u64 {
        self.base.revision()
    }

    /// Returns the exact source snapshot captured by this transaction.
    pub fn base_snapshot(&self) -> &Document {
        &self.base
    }
}

impl crate::editable_text::UnicodeTextStorage for Document {
    fn version(&self) -> u16 {
        self.revision() as u16
    }

    fn content_utf8(&self) -> &str {
        self.as_str()
    }

    fn len_utf16(&self) -> usize {
        Document::len_utf16(self)
    }

    fn utf_offset_8to16(&self, position: usize) -> usize {
        Document::byte_to_utf16(self, position)
    }

    fn utf_offset_16to8(&self, position: usize) -> usize {
        Document::utf16_to_byte(self, position)
    }

    fn utf_range_8to16(&self, range: &Range<usize>) -> Range<usize> {
        self.byte_to_utf16(range.start)..self.byte_to_utf16(range.end)
    }

    fn utf_range_16to8(&self, range: &Range<usize>) -> Range<usize> {
        self.utf16_to_byte(range.start)..self.utf16_to_byte(range.end)
    }

    fn replace_range(&mut self, range: Range<usize>, text: &str) {
        let changes = ChangeSet::for_document(self, [Change::new(range, text)])
            .expect("replace_range requires a valid UTF-8 range");
        self.apply_changes(&changes)
            .expect("replace_range must use the current document snapshot");
    }

    fn revision(&self) -> u64 {
        Document::revision(self)
    }

    fn len_bytes(&self) -> usize {
        Document::len_bytes(self)
    }

    fn clamp_byte_offset(&self, position: usize) -> usize {
        Document::clamp_byte_offset(self, position)
    }

    fn shared_string(&self) -> SharedString {
        Document::shared_string(self)
    }

    fn document_snapshot(&self) -> Document {
        self.clone()
    }

    fn slice_bytes(&self, range: Range<usize>) -> String {
        self.slice(range)
    }

    fn apply_changes(&mut self, changes: &ChangeSet) -> Result<(), ChangeError> {
        Document::apply_changes(self, changes)
    }

    fn restore_document(&mut self, document: &Document) -> Result<(), ChangeError> {
        self.restore_from(document);
        Ok(())
    }

    fn offset_from_caret(
        &self,
        caret: usize,
        direction: NavigationDirection,
        boundary: TextBoundary,
    ) -> usize {
        super::navigation::offset_from_caret(self, caret, direction, boundary)
    }

    fn range_from_caret(
        &self,
        caret: usize,
        direction: NavigationDirection,
        boundary: TextBoundary,
    ) -> Range<usize> {
        let caret = self.clamp_byte_offset(caret);
        let offset = super::navigation::offset_from_caret(self, caret, direction, boundary);
        match direction {
            NavigationDirection::Back => offset..caret,
            NavigationDirection::Forward => caret..offset,
        }
    }

    fn word_range_at(&self, position: usize) -> Range<usize> {
        super::navigation::word_range_at(self, position)
    }
}

#[cfg(test)]
mod tests {
    use super::{Document, MAX_CHUNK_BYTES, TARGET_CHUNK_BYTES};
    use crate::editable_text::TextBoundary;
    use crate::rich_text::{Affinity, Change, ChangeError, ChangeSet, Selection};

    #[test]
    fn snapshots_are_cheap_and_stale_transactions_are_rejected() {
        let mut document = Document::new("hello");
        let snapshot = document.clone();
        let transaction = document
            .transaction()
            .replace(5..5, "!")
            .selection(Selection::new(6, 6))
            .build()
            .unwrap();
        document.apply(&transaction).unwrap();

        assert_eq!(snapshot.as_str(), "hello");
        assert_eq!(snapshot.revision(), 0);
        assert_eq!(document.as_str(), "hello!");
        assert_eq!(document.revision(), 1);
        assert_eq!(transaction.selection(), Some(Selection::new(6, 6)));
        assert_eq!(
            document.apply(&transaction),
            Err(ChangeError::StaleDocument)
        );

        let mut unrelated = Document::new("hello");
        assert_eq!(
            unrelated.apply(&transaction),
            Err(ChangeError::StaleDocument)
        );

        let branch = Document::new("abcdef");
        let left_transaction = branch.transaction().replace(1..2, "X").build().unwrap();
        let right_transaction = branch.transaction().replace(1..2, "Y").build().unwrap();
        let mut left = branch.clone();
        let mut right = branch;
        left.apply(&left_transaction).unwrap();
        right.apply(&right_transaction).unwrap();
        assert_eq!(left.revision(), right.revision());
        assert_eq!(left.as_str(), "aXcdef");
        assert_eq!(right.as_str(), "aYcdef");
        assert_eq!(
            left.apply(&left_transaction),
            Err(ChangeError::StaleDocument)
        );
        assert_eq!(
            right.apply(&left_transaction),
            Err(ChangeError::StaleDocument)
        );
    }

    #[test]
    fn no_op_does_not_advance_revision() {
        let mut document = Document::new("same");
        let transaction = document
            .transaction()
            .replace(0..4, "same")
            .build()
            .unwrap();
        document.apply(&transaction).unwrap();
        assert_eq!(document.revision(), 0);
        assert_eq!(document.as_str(), "same");
    }

    #[test]
    fn byte_utf16_and_lf_line_queries_work_across_chunks() {
        let mut text = "a".repeat(2 * 1024 - 2);
        text.push_str("🐻\né\r\nlast\n");
        let document = Document::new(text);
        let bear = 2 * 1024 - 2;

        assert_eq!(document.byte_to_utf16(bear), bear);
        assert_eq!(document.utf16_to_byte(bear + 1), bear + 4);
        assert_eq!(
            document.len_utf16(),
            document.as_str().encode_utf16().count()
        );
        assert_eq!(document.line_count(), 4);
        assert_eq!(document.line_range(1), Some((bear + 5)..(bear + 8)));
        assert_eq!(document.line_range(2), Some((bear + 9)..(bear + 13)));
        assert_eq!(document.line_range(3), Some((bear + 14)..(bear + 14)));
        assert_eq!(document.line_index(bear + 5), 1);
        assert!(document.chunks().count() >= 2);
        assert!(
            document
                .chunk_byte_lengths()
                .all(|len| len <= MAX_CHUNK_BYTES)
        );
    }

    #[test]
    fn repeated_small_edits_keep_chunk_seams_bounded() {
        let mut document = Document::new("a".repeat(128 * 1024));
        let start_count = document.chunk_count();
        for _ in 0..256 {
            let transaction = document
                .transaction()
                .replace(2 * 1024..2 * 1024, "x")
                .build()
                .unwrap();
            document.apply(&transaction).unwrap();
        }

        let lengths: Vec<_> = document.chunk_byte_lengths().collect();
        assert!(lengths.iter().all(|len| *len <= MAX_CHUNK_BYTES));
        assert!(lengths.iter().all(|len| *len >= TARGET_CHUNK_BYTES / 2));
        assert!(document.chunk_count() <= start_count + 2);
        assert_eq!(document.len_bytes(), 128 * 1024 + 256);
    }

    #[test]
    fn chunk_lookup_obeys_left_and_right_seam_bias() {
        let left = "a".repeat(TARGET_CHUNK_BYTES);
        let right = "b".repeat(TARGET_CHUNK_BYTES);
        let document = Document::new(format!("{left}{right}"));
        let boundary = TARGET_CHUNK_BYTES;

        assert_eq!(
            document.chunk_at_byte(boundary, sum_tree::Bias::Left),
            Some((left.as_str(), 0))
        );
        assert_eq!(
            document.chunk_at_byte(boundary, sum_tree::Bias::Right),
            Some((right.as_str(), boundary))
        );
        assert!(document.chunk_at_byte(0, sum_tree::Bias::Left).is_some());
        assert!(
            document
                .chunk_at_byte(document.len_bytes(), sum_tree::Bias::Right)
                .is_none()
        );
    }

    #[test]
    fn slices_and_affinity_mapping_are_utf8_safe() {
        let document = Document::new("ab🐻cd");
        let changes =
            crate::rich_text::ChangeSet::for_document(&document, [Change::new(2..6, "🐈")])
                .unwrap();
        assert_eq!(document.slice(2..6), "🐻");
        assert_eq!(changes.map_position(2, Affinity::Before).unwrap(), 2);
        assert_eq!(changes.map_position(2, Affinity::After).unwrap(), 6);
        assert_eq!(
            changes
                .invert(&Document::new("ab🐈cd"))
                .unwrap()
                .len_bytes_before(),
            8
        );
    }

    #[test]
    fn native_queries_edits_and_restore_do_not_flatten_snapshots() {
        use crate::editable_text::UnicodeTextStorage;
        use gpui::NavigationDirection;

        let source = Document::new(format!(
            "{}🐻\nword {}",
            "a".repeat(10_000),
            "b".repeat(10_000)
        ));
        assert!(source.data.flattened.get().is_none());

        assert_eq!(source.slice(10..20), "a".repeat(10));
        let bear = 10_000;
        assert_eq!(source.byte_to_utf16(bear), bear);
        assert_eq!(source.utf16_to_byte(bear + 1), bear + 4);
        assert_eq!(source.line_index(bear + 5), 1);
        assert_eq!(
            <Document as UnicodeTextStorage>::utf_offset_8to16(&source, bear + 4),
            bear + 2
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::utf_offset_16to8(&source, bear + 2),
            bear + 4
        );
        let second_line_start = bear + 5;
        assert_eq!(
            <Document as UnicodeTextStorage>::offset_from_caret(
                &source,
                bear,
                NavigationDirection::Forward,
                TextBoundary::Graphmeme,
            ),
            bear + 4
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::offset_from_caret(
                &source,
                bear + 4,
                NavigationDirection::Forward,
                TextBoundary::Word,
            ),
            second_line_start + 4
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::range_from_caret(
                &source,
                second_line_start + 4,
                NavigationDirection::Back,
                TextBoundary::Word,
            ),
            second_line_start..second_line_start + 4
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::word_range_at(&source, second_line_start + 1),
            second_line_start..second_line_start + 4
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::offset_from_caret(
                &source,
                second_line_start,
                NavigationDirection::Back,
                TextBoundary::Line,
            ),
            second_line_start
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::offset_from_caret(
                &source,
                bear,
                NavigationDirection::Back,
                TextBoundary::Document,
            ),
            0
        );
        assert_eq!(
            <Document as UnicodeTextStorage>::offset_from_caret(
                &source,
                bear,
                NavigationDirection::Forward,
                TextBoundary::Document,
            ),
            source.len_bytes()
        );
        assert!(source.data.flattened.get().is_none());

        let changes = ChangeSet::for_document(&source, [Change::new(5..6, "x")]).unwrap();
        let mut edited = source.clone();
        edited.apply_changes(&changes).unwrap();
        assert!(edited.data.flattened.get().is_none());

        let mut restored = edited;
        restored.restore_from(&source);
        assert!(restored.same_snapshot(&source));
        assert!(restored.data.flattened.get().is_none());
        assert_eq!(restored.as_str(), source.as_str());
    }

    #[test]
    fn restore_document_trait_reuses_the_prior_snapshot() {
        use crate::editable_text::UnicodeTextStorage;

        let before = Document::new("a🐻b");
        let mut after = before.clone();
        after.replace_range(1..5, "🐈");
        <Document as UnicodeTextStorage>::restore_document(&mut after, &before).unwrap();
        assert!(after.same_snapshot(&before));
        assert_eq!(after.as_str(), "a🐻b");
    }
}
