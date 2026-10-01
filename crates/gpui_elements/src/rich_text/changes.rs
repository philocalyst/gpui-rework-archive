//! Atomic text edits and position mapping for rich-text documents.

use super::Document;
use gpui::SharedString;
use std::{error::Error, fmt, ops::Range};

/// Which side of inserted text a position should stay on when edits are mapped.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Affinity {
    /// Keep the position before text inserted at the same source boundary.
    Before,
    /// Keep the position after text inserted at the same source boundary.
    After,
}

/// A replacement expressed in UTF-8 byte offsets in the original source text.
///
/// The range is half-open and must begin and end on UTF-8 character boundaries.
/// All edits in a [`ChangeSet`] use coordinates from the same original snapshot.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Change {
    pub range: Range<usize>,
    pub insert: String,
}

impl Change {
    pub fn new(range: Range<usize>, insert: impl Into<String>) -> Self {
        Self {
            range,
            insert: insert.into(),
        }
    }
}

/// A validated, canonicalized batch of non-overlapping replacements.
///
/// Text-backed sets retain their source as a [`SharedString`]. Document-backed
/// sets retain a cheap [`Document`] snapshot, so validation, mapping, and tree
/// application do not flatten the entire document. Edits are sorted by
/// `(range.start, range.end)` after validation. Insertion at a consuming edit's
/// start or end is allowed; duplicate insertions at one byte position and
/// insertions strictly inside a consumed range are rejected.
#[derive(Debug, Clone)]
pub struct ChangeSet {
    source: ChangeSource,
    base_len_bytes: usize,
    changes: Vec<Change>,
    removed: Vec<String>,
    map_groups: Vec<PositionMapGroup>,
    result_len_bytes: usize,
    base_len_utf16: usize,
    result_len_utf16: usize,
    is_noop: bool,
}

#[derive(Debug, Clone)]
enum ChangeSource {
    Text(SharedString),
    Document(Document),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PositionMapGroup {
    source_start: usize,
    source_end: usize,
    result_start: usize,
    result_end: usize,
}

impl ChangeSet {
    /// Validates and canonicalizes edits against a source snapshot.
    pub fn new(
        base_text: impl Into<SharedString>,
        changes: impl IntoIterator<Item = Change>,
    ) -> Result<Self, ChangeError> {
        let base_text = base_text.into();
        let source = base_text.as_ref();
        Self::build(
            ChangeSource::Text(base_text.clone()),
            source.len(),
            source.encode_utf16().count(),
            changes,
            |offset| source.is_char_boundary(offset),
            |range| source[range].to_owned(),
        )
    }

    /// Validates edits directly against a persistent document snapshot without flattening it.
    pub fn for_document(
        document: &Document,
        changes: impl IntoIterator<Item = Change>,
    ) -> Result<Self, ChangeError> {
        Self::build(
            ChangeSource::Document(document.clone()),
            document.len_bytes(),
            document.len_utf16(),
            changes,
            |offset| document.is_char_boundary(offset),
            |range| document.slice(range),
        )
    }

    fn build(
        source_snapshot: ChangeSource,
        base_len_bytes: usize,
        source_len_utf16: usize,
        changes: impl IntoIterator<Item = Change>,
        mut is_char_boundary: impl FnMut(usize) -> bool,
        mut slice_source: impl FnMut(Range<usize>) -> String,
    ) -> Result<Self, ChangeError> {
        let mut indexed_changes: Vec<_> = changes.into_iter().enumerate().collect();

        for (index, change) in &indexed_changes {
            let range = &change.range;
            if range.start > range.end {
                return Err(ChangeError::ReversedRange { index: *index });
            }
            if range.end > base_len_bytes {
                return Err(ChangeError::OutOfBounds {
                    index: *index,
                    range: range.clone(),
                    len: base_len_bytes,
                });
            }
            if !is_char_boundary(range.start) {
                return Err(ChangeError::NotCharBoundary {
                    index: *index,
                    offset: range.start,
                });
            }
            if !is_char_boundary(range.end) {
                return Err(ChangeError::NotCharBoundary {
                    index: *index,
                    offset: range.end,
                });
            }
        }

        indexed_changes.sort_by(|(left_index, left), (right_index, right)| {
            (left.range.start, left.range.end, left_index).cmp(&(
                right.range.start,
                right.range.end,
                right_index,
            ))
        });

        let mut active_replacement: Option<(usize, usize)> = None;
        let mut last_insertion: Option<usize> = None;
        for (index, change) in &indexed_changes {
            let start = change.range.start;
            let end = change.range.end;
            if start == end {
                if last_insertion == Some(start) {
                    return Err(ChangeError::DuplicateInsertion {
                        index: *index,
                        position: start,
                    });
                }
                last_insertion = Some(start);
                if let Some((replacement_index, replacement_end)) = active_replacement {
                    if start < replacement_end {
                        return Err(ChangeError::Overlap {
                            first_index: replacement_index,
                            second_index: *index,
                        });
                    }
                }
            } else {
                if let Some((replacement_index, replacement_end)) = active_replacement {
                    if start < replacement_end {
                        return Err(ChangeError::Overlap {
                            first_index: replacement_index,
                            second_index: *index,
                        });
                    }
                }
                active_replacement = Some((*index, end));
                last_insertion = None;
            }
        }

        let mut result_len_bytes = base_len_bytes;
        let mut result_len_utf16 = source_len_utf16;
        let mut canonical_changes = Vec::with_capacity(indexed_changes.len());
        let mut removed = Vec::with_capacity(indexed_changes.len());
        for (_, change) in indexed_changes {
            let removed_text = slice_source(change.range.clone());
            if removed_text == change.insert {
                continue;
            }
            let removed_utf16 = removed_text.encode_utf16().count();
            let inserted_utf16 = change.insert.encode_utf16().count();
            result_len_bytes = result_len_bytes
                .checked_sub(change.range.len())
                .and_then(|len| len.checked_add(change.insert.len()))
                .ok_or(ChangeError::LengthOverflow)?;
            result_len_utf16 = result_len_utf16
                .checked_sub(removed_utf16)
                .and_then(|len| len.checked_add(inserted_utf16))
                .ok_or(ChangeError::LengthOverflow)?;
            canonical_changes.push(change);
            removed.push(removed_text);
        }

        // Separate edits can cancel at adjacent boundaries (for example delete `a` at 0 and
        // insert `a` at byte 1). Remove each unchanged touching cluster independently so it
        // cannot move anchors when another cluster in the batch makes a real change.
        let (canonical_changes, removed) =
            filter_noop_clusters(canonical_changes, removed, &mut slice_source);
        if canonical_changes.is_empty() {
            return Ok(Self {
                source: source_snapshot,
                base_len_bytes,
                changes: Vec::new(),
                removed: Vec::new(),
                map_groups: Vec::new(),
                result_len_bytes: base_len_bytes,
                base_len_utf16: source_len_utf16,
                result_len_utf16: source_len_utf16,
                is_noop: true,
            });
        }

        let mut map_groups = Vec::new();
        let mut source_cursor = 0usize;
        let mut result_cursor = 0usize;
        let mut change_index = 0usize;
        while change_index < canonical_changes.len() {
            let group_start = canonical_changes[change_index].range.start;
            let mut next_index = change_index + 1;
            while next_index < canonical_changes.len()
                && canonical_changes[next_index].range.start == group_start
            {
                next_index += 1;
            }

            let result_start = result_cursor + (group_start - source_cursor);
            let mut result_end = result_start;
            let mut source_end = group_start;
            for change in &canonical_changes[change_index..next_index] {
                result_end = result_end
                    .checked_add(change.insert.len())
                    .ok_or(ChangeError::LengthOverflow)?;
                source_end = source_end.max(change.range.end);
            }
            map_groups.push(PositionMapGroup {
                source_start: group_start,
                source_end,
                result_start,
                result_end,
            });
            result_cursor = result_end;
            source_cursor = source_end;
            change_index = next_index;
        }

        Ok(Self {
            source: source_snapshot,
            base_len_bytes,
            is_noop: false,
            changes: canonical_changes,
            removed,
            map_groups,
            result_len_bytes,
            base_len_utf16: source_len_utf16,
            result_len_utf16,
        })
    }

    /// Returns the exact source snapshot this set was validated against.
    pub fn base_text(&self) -> &str {
        match &self.source {
            ChangeSource::Text(text) => text.as_ref(),
            ChangeSource::Document(document) => document.as_str(),
        }
    }

    /// Returns the source document revision when this set was built from a document.
    pub fn base_revision(&self) -> Option<u64> {
        match &self.source {
            ChangeSource::Text(_) => None,
            ChangeSource::Document(document) => Some(document.revision()),
        }
    }

    /// Returns the canonical edits in ascending original-coordinate order.
    pub fn changes(&self) -> &[Change] {
        &self.changes
    }

    /// Returns the original UTF-8 byte length.
    pub fn len_bytes_before(&self) -> usize {
        self.base_len_bytes
    }

    /// Returns the resulting UTF-8 byte length.
    pub fn len_bytes_after(&self) -> usize {
        self.result_len_bytes
    }

    /// Returns the original UTF-16 code-unit length.
    pub fn len_utf16_before(&self) -> usize {
        self.base_len_utf16
    }

    /// Returns the resulting UTF-16 code-unit length.
    pub fn len_utf16_after(&self) -> usize {
        self.result_len_utf16
    }

    /// Returns true when the batch contains no replacement entries.
    pub fn is_empty(&self) -> bool {
        self.changes.is_empty()
    }

    /// Returns true when applying the batch leaves the source text unchanged.
    pub fn is_noop(&self) -> bool {
        self.is_noop
    }

    /// Applies all edits to exactly the source snapshot used for validation.
    ///
    /// The output is built in one forward pass, so a batch copies the source
    /// text once regardless of the number of edits.
    pub fn apply_to(&self, source: &str) -> Result<String, ChangeError> {
        if source != self.base_text() {
            return Err(ChangeError::StaleSource);
        }

        if self.is_noop {
            return Ok(source.to_owned());
        }

        let mut output = String::with_capacity(self.result_len_bytes);
        let mut cursor = 0;
        for change in &self.changes {
            output.push_str(&source[cursor..change.range.start]);
            output.push_str(&change.insert);
            cursor = change.range.end;
        }
        output.push_str(&source[cursor..]);
        Ok(output)
    }

    /// Maps a source byte position through this batch.
    ///
    /// Positions inside replaced text collapse to the replacement's start for
    /// [`Affinity::Before`] and to its end for [`Affinity::After`]. Edits with
    /// the same source start are treated as one replacement group. At an
    /// adjacent-edit boundary, the left replacement is already applied before
    /// affinity is evaluated for the edit that starts at that position.
    pub fn map_position(&self, position: usize, affinity: Affinity) -> Result<usize, ChangeError> {
        if position > self.base_len_bytes {
            return Err(ChangeError::PositionOutOfBounds {
                position,
                len: self.base_len_bytes,
            });
        }
        let is_char_boundary = match &self.source {
            ChangeSource::Text(text) => text.is_char_boundary(position),
            ChangeSource::Document(document) => document.is_char_boundary(position),
        };
        if !is_char_boundary {
            return Err(ChangeError::PositionNotCharBoundary { position });
        }
        if self.is_noop {
            return Ok(position);
        }

        let insertion_index = self
            .map_groups
            .partition_point(|group| group.source_start <= position);
        let Some(group) = insertion_index
            .checked_sub(1)
            .and_then(|index| self.map_groups.get(index))
        else {
            return Ok(position);
        };

        if position == group.source_start || position < group.source_end {
            return Ok(match affinity {
                Affinity::Before => group.result_start,
                Affinity::After => group.result_end,
            });
        }

        Ok(group.result_end + (position - group.source_end))
    }

    /// Iterates over unchanged source spans and their corresponding output spans.
    pub fn unchanged_ranges(&self) -> UnchangedRanges<'_> {
        UnchangedRanges {
            change_set: self,
            change_index: 0,
            source_cursor: 0,
            result_cursor: 0,
            done: false,
        }
    }

    /// Builds the inverse batch against the supplied post-edit document snapshot.
    pub fn invert(&self, after: &Document) -> Result<Self, ChangeError> {
        if after.len_bytes() != self.result_len_bytes || after.len_utf16() != self.result_len_utf16
        {
            return Err(ChangeError::StaleSource);
        }

        let mut expected_segments = Vec::new();
        let mut source_cursor = 0usize;
        for change in &self.changes {
            self.push_source_range(source_cursor..change.range.start, &mut expected_segments);
            if !change.insert.is_empty() {
                expected_segments.push(change.insert.as_str());
            }
            source_cursor = change.range.end;
        }
        self.push_source_range(source_cursor..self.base_len_bytes, &mut expected_segments);
        if !after.content_matches_segments(expected_segments) {
            return Err(ChangeError::StaleSource);
        }

        let mut inverse: Vec<Change> = Vec::with_capacity(self.changes.len());
        source_cursor = 0usize;
        let mut result_cursor = 0usize;
        for (change, removed) in self.changes.iter().zip(&self.removed) {
            result_cursor = result_cursor
                .checked_add(change.range.start - source_cursor)
                .ok_or(ChangeError::LengthOverflow)?;
            let start = result_cursor;
            let end = start
                .checked_add(change.insert.len())
                .ok_or(ChangeError::LengthOverflow)?;
            let inverse_change = Change::new(start..end, removed.clone());
            if let Some(previous) = inverse.last_mut()
                && previous.range.is_empty()
                && inverse_change.range.is_empty()
                && previous.range.start == inverse_change.range.start
            {
                previous.insert.push_str(&inverse_change.insert);
            } else {
                inverse.push(inverse_change);
            }
            result_cursor = end;
            source_cursor = change.range.end;
        }
        Self::for_document(after, inverse)
    }

    pub(crate) fn validate_document_source(&self, document: &Document) -> Result<(), ChangeError> {
        match &self.source {
            ChangeSource::Document(source) if source.same_snapshot(document) => Ok(()),
            ChangeSource::Document(_) => Err(ChangeError::StaleDocument),
            ChangeSource::Text(source) if document.content_equals(source.as_ref()) => Ok(()),
            ChangeSource::Text(_) => Err(ChangeError::StaleSource),
        }
    }

    /// Validates a byte position in the resulting document after the batch.
    pub fn validate_result_position(&self, position: usize) -> Result<(), ChangeError> {
        if position > self.result_len_bytes {
            return Err(ChangeError::PositionOutOfBounds {
                position,
                len: self.result_len_bytes,
            });
        }

        let mut source_cursor = 0usize;
        let mut result_cursor = 0usize;
        for change in &self.changes {
            let unchanged_len = change.range.start - source_cursor;
            let unchanged_end = result_cursor + unchanged_len;
            if position <= unchanged_end {
                let source_position = source_cursor + (position - result_cursor);
                return self.validate_source_position(source_position);
            }
            result_cursor = unchanged_end;

            let inserted_end = result_cursor + change.insert.len();
            if position <= inserted_end {
                let local = position - result_cursor;
                let is_boundary = change.insert.is_char_boundary(local);
                return if is_boundary {
                    Ok(())
                } else {
                    Err(ChangeError::PositionNotCharBoundary { position })
                };
            }
            result_cursor = inserted_end;
            source_cursor = change.range.end;
        }

        let source_position = source_cursor + (position - result_cursor);
        self.validate_source_position(source_position)
    }

    fn validate_source_position(&self, position: usize) -> Result<(), ChangeError> {
        let is_char_boundary = match &self.source {
            ChangeSource::Text(text) => text.is_char_boundary(position),
            ChangeSource::Document(document) => document.is_char_boundary(position),
        };
        if is_char_boundary {
            Ok(())
        } else {
            Err(ChangeError::PositionNotCharBoundary { position })
        }
    }

    fn push_source_range<'a>(&'a self, range: Range<usize>, output: &mut Vec<&'a str>) {
        if range.is_empty() {
            return;
        }
        match &self.source {
            ChangeSource::Text(text) => output.push(&text[range]),
            ChangeSource::Document(document) => {
                output.extend(document.chunk_slices_in_range(range));
            }
        }
    }
}

fn filter_noop_clusters(
    changes: Vec<Change>,
    removed: Vec<String>,
    slice_source: &mut impl FnMut(Range<usize>) -> String,
) -> (Vec<Change>, Vec<String>) {
    let mut effective_changes = Vec::with_capacity(changes.len());
    let mut effective_removed = Vec::with_capacity(removed.len());
    let mut index = 0usize;
    while index < changes.len() {
        let start = changes[index].range.start;
        let mut end = changes[index].range.end;
        let mut next_index = index + 1;
        while next_index < changes.len() && changes[next_index].range.start <= end {
            end = end.max(changes[next_index].range.end);
            next_index += 1;
        }

        let original = slice_source(start..end);
        let mut replacement = String::new();
        let mut cursor = start;
        for change in &changes[index..next_index] {
            if cursor < change.range.start {
                replacement.push_str(&slice_source(cursor..change.range.start));
            }
            replacement.push_str(&change.insert);
            cursor = change.range.end;
        }
        if cursor < end {
            replacement.push_str(&slice_source(cursor..end));
        }
        if replacement != original {
            effective_changes.extend(changes[index..next_index].iter().cloned());
            effective_removed.extend(removed[index..next_index].iter().cloned());
        }
        index = next_index;
    }
    (effective_changes, effective_removed)
}

/// A span copied unchanged by a [`ChangeSet`], with offsets in both versions.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct UnchangedRange {
    pub source: Range<usize>,
    pub result: Range<usize>,
}

/// Iterator over the unchanged spans in a [`ChangeSet`].
pub struct UnchangedRanges<'a> {
    change_set: &'a ChangeSet,
    change_index: usize,
    source_cursor: usize,
    result_cursor: usize,
    done: bool,
}

impl Iterator for UnchangedRanges<'_> {
    type Item = UnchangedRange;

    fn next(&mut self) -> Option<Self::Item> {
        if self.done {
            return None;
        }

        while let Some(change) = self.change_set.changes.get(self.change_index) {
            let source_start = self.source_cursor;
            let source_end = change.range.start;
            let result_start = self.result_cursor;
            self.result_cursor += source_end - source_start;
            self.result_cursor += change.insert.len();
            self.source_cursor = change.range.end;
            self.change_index += 1;

            if source_start < source_end {
                return Some(UnchangedRange {
                    source: source_start..source_end,
                    result: result_start..result_start + (source_end - source_start),
                });
            }
        }

        let source_start = self.source_cursor;
        let source_end = self.change_set.base_len_bytes;
        self.done = true;
        if source_start < source_end {
            let result_start = self.result_cursor;
            return Some(UnchangedRange {
                source: source_start..source_end,
                result: result_start..result_start + (source_end - source_start),
            });
        }
        None
    }
}

/// Errors returned when validating, applying, or mapping a change batch.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ChangeError {
    ReversedRange {
        index: usize,
    },
    OutOfBounds {
        index: usize,
        range: Range<usize>,
        len: usize,
    },
    NotCharBoundary {
        index: usize,
        offset: usize,
    },
    Overlap {
        first_index: usize,
        second_index: usize,
    },
    DuplicateInsertion {
        index: usize,
        position: usize,
    },
    InvalidSliceRange {
        range: Range<usize>,
        len: usize,
    },
    StaleSource,
    StaleDocument,
    PositionOutOfBounds {
        position: usize,
        len: usize,
    },
    PositionNotCharBoundary {
        position: usize,
    },
    LengthOverflow,
    RevisionOverflow,
}

impl fmt::Display for ChangeError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::ReversedRange { index } => {
                write!(formatter, "edit {index} has a reversed byte range")
            }
            Self::OutOfBounds { index, range, len } => write!(
                formatter,
                "edit {index} range {}..{} exceeds source length {len}",
                range.start, range.end
            ),
            Self::NotCharBoundary { index, offset } => {
                write!(
                    formatter,
                    "edit {index} offset {offset} is not a UTF-8 boundary"
                )
            }
            Self::Overlap {
                first_index,
                second_index,
            } => write!(formatter, "edits {first_index} and {second_index} overlap"),
            Self::DuplicateInsertion { index, position } => write!(
                formatter,
                "edit {index} duplicates an insertion at byte position {position}"
            ),
            Self::StaleSource => {
                write!(formatter, "change set was built for different source text")
            }
            Self::InvalidSliceRange { range, len } => write!(
                formatter,
                "slice range {}..{} is invalid for source length {len}",
                range.start, range.end
            ),
            Self::StaleDocument => write!(
                formatter,
                "transaction was built for a stale document snapshot"
            ),
            Self::PositionOutOfBounds { position, len } => {
                write!(formatter, "position {position} exceeds source length {len}")
            }
            Self::PositionNotCharBoundary { position } => {
                write!(formatter, "position {position} is not a UTF-8 boundary")
            }
            Self::LengthOverflow => write!(formatter, "edited text length overflows usize"),
            Self::RevisionOverflow => write!(formatter, "document revision overflows u64"),
        }
    }
}

impl Error for ChangeError {}

#[cfg(test)]
mod tests {
    use super::{Affinity, Change, ChangeError, ChangeSet};

    #[test]
    fn applies_sorted_unicode_batch_once() {
        let edits = [
            Change::new(10..10, "!"),
            Change::new(0..4, "Hi"),
            Change::new(4..4, " 🙂"),
        ];
        let changes = ChangeSet::new("🐻 café", edits).unwrap();

        assert_eq!(changes.changes()[0].range, 0..4);
        assert_eq!(changes.changes()[1].range, 4..4);
        assert_eq!(changes.changes()[2].range, 10..10);
        assert_eq!(changes.apply_to("🐻 café").unwrap(), "Hi 🙂 café!");
        assert_eq!(changes.len_bytes_before(), "🐻 café".len());
        assert_eq!(changes.len_utf16_before(), "🐻 café".encode_utf16().count());
    }

    #[test]
    fn rejects_invalid_utf8_ranges_and_overlaps_atomically() {
        assert!(matches!(
            ChangeSet::new("é", [Change::new(1..2, "x")]),
            Err(ChangeError::NotCharBoundary { .. })
        ));
        assert!(matches!(
            ChangeSet::new("abcdef", [Change::new(1..4, "x"), Change::new(3..5, "y")]),
            Err(ChangeError::Overlap { .. })
        ));
        assert!(matches!(
            ChangeSet::new("abc", [Change::new(1..1, "x"), Change::new(1..1, "y")]),
            Err(ChangeError::DuplicateInsertion { .. })
        ));
    }

    #[test]
    fn touching_edits_map_shared_boundaries_with_affinity() {
        let changes = ChangeSet::new(
            "abcdef",
            [
                Change::new(1..3, "XY"),
                Change::new(3..3, "!"),
                Change::new(3..5, "Z"),
            ],
        )
        .unwrap();
        assert_eq!(changes.apply_to("abcdef").unwrap(), "aXY!Zf");
        assert_eq!(changes.map_position(3, Affinity::Before).unwrap(), 3);
        assert_eq!(changes.map_position(3, Affinity::After).unwrap(), 5);
    }

    #[test]
    fn adjacent_replacements_preserve_the_boundary_after_the_left_edit() {
        let changes =
            ChangeSet::new("abcdef", [Change::new(3..5, "Z"), Change::new(1..3, "XY")]).unwrap();
        assert_eq!(changes.apply_to("abcdef").unwrap(), "aXYZf");
        assert_eq!(changes.map_position(3, Affinity::Before).unwrap(), 3);
        assert_eq!(changes.map_position(3, Affinity::After).unwrap(), 4);

        let single = ChangeSet::new("abcdef", [Change::new(1..3, "XY")]).unwrap();
        assert_eq!(single.map_position(3, Affinity::Before).unwrap(), 3);
        assert_eq!(single.map_position(3, Affinity::After).unwrap(), 3);
    }

    #[test]
    fn mixed_noop_edit_does_not_move_anchors() {
        let changes =
            ChangeSet::new("abcdef", [Change::new(1..2, "b"), Change::new(4..5, "Q")]).unwrap();
        assert_eq!(changes.changes().len(), 1);
        assert_eq!(changes.map_position(2, Affinity::Before).unwrap(), 2);
        assert_eq!(changes.map_position(2, Affinity::After).unwrap(), 2);
    }

    #[test]
    fn net_noop_touching_cluster_is_pruned_beside_real_edits() {
        let changes = ChangeSet::new(
            "abcdef",
            [
                Change::new(1..2, ""),
                Change::new(2..2, "b"),
                Change::new(5..6, "X"),
            ],
        )
        .unwrap();

        assert_eq!(changes.changes().len(), 1);
        assert_eq!(changes.changes()[0].range, 5..6);
        assert_eq!(changes.apply_to("abcdef").unwrap(), "abcdeX");
        assert_eq!(changes.map_position(1, Affinity::Before).unwrap(), 1);
        assert_eq!(changes.map_position(2, Affinity::After).unwrap(), 2);
    }

    #[test]
    fn insertion_at_a_deletion_end_can_make_the_batch_a_noop() {
        let changes =
            ChangeSet::new("ab", [Change::new(0..1, ""), Change::new(1..1, "a")]).unwrap();
        assert!(changes.is_noop());
        assert_eq!(changes.changes(), &[]);
        assert_eq!(changes.apply_to("ab").unwrap(), "ab");
    }

    #[test]
    fn edit_input_permutations_have_the_same_canonical_result() {
        let edits = [
            Change::new(0..1, "A"),
            Change::new(2..2, "!"),
            Change::new(5..7, "🐈"),
        ];
        let expected = ChangeSet::new("abcdefg", edits.clone()).unwrap();
        for permutation in [[2, 1, 0], [1, 0, 2], [1, 2, 0], [0, 2, 1], [2, 0, 1]] {
            let changes = ChangeSet::new(
                "abcdefg",
                permutation.into_iter().map(|index| edits[index].clone()),
            )
            .unwrap();
            assert_eq!(changes.changes(), expected.changes());
            assert_eq!(
                changes.apply_to("abcdefg").unwrap(),
                expected.apply_to("abcdefg").unwrap()
            );
        }
    }

    #[test]
    fn stale_input_is_rejected_and_noop_mapping_is_identity() {
        let changes = ChangeSet::new("aéz", [Change::new(1..3, "é")]).unwrap();
        assert!(changes.is_noop());
        assert_eq!(changes.apply_to("aéz").unwrap(), "aéz");
        assert_eq!(changes.map_position(3, Affinity::After).unwrap(), 3);
        assert_eq!(changes.apply_to("aez"), Err(ChangeError::StaleSource));
    }

    #[test]
    fn unchanged_ranges_include_source_and_result_coordinates() {
        let changes = ChangeSet::new(
            "abcdefg",
            [Change::new(2..3, "XYZ"), Change::new(5..5, "!")],
        )
        .unwrap();
        let spans: Vec<_> = changes.unchanged_ranges().collect();
        assert_eq!(spans[0].source, 0..2);
        assert_eq!(spans[0].result, 0..2);
        assert_eq!(spans[1].source, 3..5);
        assert_eq!(spans[1].result, 5..7);
        assert_eq!(spans[2].source, 5..7);
        assert_eq!(spans[2].result, 8..10);
    }

    #[test]
    fn inverse_coalesces_adjacent_deletes_and_round_trips_unicode() {
        use crate::rich_text::Document;

        let before = Document::new("a🐻bcéz");
        let changes =
            ChangeSet::for_document(&before, [Change::new(1..5, ""), Change::new(5..9, "")])
                .unwrap();
        let mut after = before.clone();
        after.apply_changes(&changes).unwrap();
        assert_eq!(after.as_str(), "az");

        let inverse = changes.invert(&after).unwrap();
        assert_eq!(inverse.changes().len(), 1);
        assert_eq!(inverse.changes()[0].range, 1..1);
        assert_eq!(inverse.changes()[0].insert, "🐻bcé");
        after.apply_changes(&inverse).unwrap();
        assert_eq!(after.as_str(), before.as_str());
    }

    #[test]
    fn inverse_handles_replacement_and_boundary_insertion() {
        use crate::rich_text::Document;

        let before = Document::new("abcdef");
        let changes =
            ChangeSet::for_document(&before, [Change::new(1..3, "X"), Change::new(3..3, "!")])
                .unwrap();
        let mut after = before.clone();
        after.apply_changes(&changes).unwrap();
        assert_eq!(after.as_str(), "aX!def");
        let inverse = changes.invert(&after).unwrap();
        after.apply_changes(&inverse).unwrap();
        assert_eq!(after.as_str(), before.as_str());
    }

    #[test]
    fn inverse_rejects_same_sized_but_unrelated_after_document() {
        use crate::rich_text::Document;

        let before = Document::new("abcdef");
        let changes = ChangeSet::for_document(&before, [Change::new(1..3, "XY")]).unwrap();
        assert_eq!(changes.len_bytes_after(), 6);
        assert_eq!(changes.len_utf16_after(), 6);
        assert!(matches!(
            changes.invert(&Document::new("aQYdef")),
            Err(ChangeError::StaleSource)
        ));
    }
}
