//! Immutable byte ranges for text annotations.
//!
//! `RangeSet` keeps annotation payloads in authoring order and builds a separate interval index
//! for hit testing. Coordinates are UTF-8 byte offsets. Use [`RangeSet::try_new`] or
//! [`RangeSet::validate`] before applying untrusted ranges to text.

use crate::rich_text::{Affinity, ChangeError, ChangeSet, Document};
use std::{
    error::Error,
    fmt,
    ops::{Deref, Range},
    sync::Arc,
};

/// A byte range with independent insertion affinity at its two endpoints.
#[derive(Debug, PartialEq, Eq)]
pub struct Span<T> {
    /// The half-open UTF-8 byte range covered by this annotation.
    pub range: Range<usize>,
    /// Whether the start endpoint stays before or after text inserted at its byte position.
    pub start_affinity: Affinity,
    /// Whether the end endpoint stays before or after text inserted at its byte position.
    pub end_affinity: Affinity,
    /// Client-owned annotation data.
    value: Arc<T>,
}

impl<T> Clone for Span<T> {
    fn clone(&self) -> Self {
        Self {
            range: self.range.clone(),
            start_affinity: self.start_affinity,
            end_affinity: self.end_affinity,
            value: self.value.clone(),
        }
    }
}

impl<T> Span<T> {
    /// Creates a span with explicit endpoint behavior when changes are mapped through it.
    pub fn new(
        range: Range<usize>,
        start_affinity: Affinity,
        end_affinity: Affinity,
        value: T,
    ) -> Self {
        Self {
            range,
            start_affinity,
            end_affinity,
            value: Arc::new(value),
        }
    }

    /// Creates a span that shares an existing annotation payload.
    pub fn shared(
        range: Range<usize>,
        start_affinity: Affinity,
        end_affinity: Affinity,
        value: Arc<T>,
    ) -> Self {
        Self {
            range,
            start_affinity,
            end_affinity,
            value,
        }
    }

    /// Creates a point annotation whose two endpoints have the same insertion affinity.
    pub fn point(position: usize, affinity: Affinity, value: T) -> Self {
        Self::new(position..position, affinity, affinity, value)
    }

    /// Returns whether this span is an explicit point annotation.
    pub fn is_point(&self) -> bool {
        self.range.start == self.range.end
    }

    /// Returns the client-owned annotation payload.
    pub fn value(&self) -> &T {
        self.value.as_ref()
    }

    /// Returns a cheap clone of the shared annotation payload.
    pub fn shared_value(&self) -> Arc<T> {
        self.value.clone()
    }

    pub(crate) fn shifted(&self, offset: usize) -> Self {
        let start = self
            .range
            .start
            .checked_add(offset)
            .expect("text range offset overflow");
        let end = self
            .range
            .end
            .checked_add(offset)
            .expect("text range offset overflow");
        Self::shared(
            start..end,
            self.start_affinity,
            self.end_affinity,
            self.value.clone(),
        )
    }
}

/// A persistent, insertion-ordered collection of annotated text ranges.
///
/// Cloning a set is constant time. `iter` preserves insertion order, which is also the style
/// precedence order used by rich text. Hit-test results are returned in coordinate order.
/// The set does not retain or identify its source document; callers keep it paired with the
/// snapshot whose byte offsets it describes and map it through that snapshot's change set.
#[derive(Debug)]
pub struct RangeSet<T> {
    spans: Arc<[Span<T>]>,
    /// Span indices sorted by (start, end, insertion order).
    by_start: Arc<[usize]>,
    /// Leaves store the last byte position each span can hit; internal nodes store the maximum.
    tree_base: usize,
    max_hit_tree: Arc<[usize]>,
}

impl<T> Clone for RangeSet<T> {
    fn clone(&self) -> Self {
        Self {
            spans: self.spans.clone(),
            by_start: self.by_start.clone(),
            tree_base: self.tree_base,
            max_hit_tree: self.max_hit_tree.clone(),
        }
    }
}

impl<T: PartialEq> PartialEq for RangeSet<T> {
    fn eq(&self, other: &Self) -> bool {
        Arc::ptr_eq(&self.spans, &other.spans) || self.spans == other.spans
    }
}

impl<T: Eq> Eq for RangeSet<T> {}

impl<T> Default for RangeSet<T> {
    fn default() -> Self {
        Self::new(std::iter::empty())
    }
}

impl<T> RangeSet<T> {
    /// Creates a range set in stable authoring order.
    ///
    /// This constructor has no text to check byte bounds against. Call [`RangeSet::validate`] or
    /// [`RangeSet::try_new`] before using ranges against a particular string or document.
    pub fn new(spans: impl IntoIterator<Item = Span<T>>) -> Self {
        let spans: Vec<_> = spans.into_iter().collect();
        let mut by_start: Vec<_> = (0..spans.len()).collect();
        by_start.sort_by_key(|&index| {
            let span = &spans[index];
            (span.range.start, span.range.end, index)
        });

        let tree_base = by_start.len().max(1).next_power_of_two();
        let mut max_hit_tree = vec![0usize; tree_base * 2];
        for (leaf, &index) in by_start.iter().enumerate() {
            let span = &spans[index];
            max_hit_tree[tree_base + leaf] = if span.is_point() {
                span.range.start
            } else {
                span.range.end.saturating_sub(1)
            };
        }
        for node in (1..tree_base).rev() {
            max_hit_tree[node] = max_hit_tree[node * 2].max(max_hit_tree[node * 2 + 1]);
        }

        Self {
            spans: spans.into(),
            by_start: by_start.into(),
            tree_base,
            max_hit_tree: max_hit_tree.into(),
        }
    }

    /// Creates a range set and checks that every endpoint belongs to the document's UTF-8 text.
    pub fn try_new(
        document: &Document,
        spans: impl IntoIterator<Item = Span<T>>,
    ) -> Result<Self, RangeError> {
        let ranges = Self::new(spans);
        ranges.validate_document(document)?;
        Ok(ranges)
    }

    /// Returns the spans in their original insertion order.
    pub fn iter(&self) -> std::slice::Iter<'_, Span<T>> {
        self.spans.iter()
    }

    /// Returns the number of spans, including point annotations.
    pub fn len(&self) -> usize {
        self.spans.len()
    }

    /// Returns whether this set has no spans.
    pub fn is_empty(&self) -> bool {
        self.spans.is_empty()
    }

    /// Checks range ordering, byte bounds, and UTF-8 boundaries against `text`.
    pub fn validate(&self, text: &str) -> Result<(), RangeError> {
        self.validate_with(text.len(), |offset| text.is_char_boundary(offset))
    }

    /// Checks ordering, byte bounds, and UTF-8 boundaries through the document's native index.
    pub fn validate_document(&self, document: &Document) -> Result<(), RangeError> {
        self.validate_with(document.len_bytes(), |offset| {
            document.is_char_boundary(offset)
        })
    }

    fn validate_with(
        &self,
        len: usize,
        mut is_char_boundary: impl FnMut(usize) -> bool,
    ) -> Result<(), RangeError> {
        for span in self.spans.iter() {
            let range = &span.range;
            if range.start > range.end {
                return Err(RangeError::InvertedRange {
                    start: range.start,
                    end: range.end,
                });
            }
            if range.end > len {
                return Err(RangeError::OutOfBounds {
                    start: range.start,
                    end: range.end,
                    len,
                });
            }
            for offset in [range.start, range.end] {
                if !is_char_boundary(offset) {
                    return Err(RangeError::NotCharBoundary { offset });
                }
            }
        }
        Ok(())
    }

    /// Returns annotations whose ranges intersect `range`.
    ///
    /// Non-empty ranges use standard half-open overlap. Point annotations intersect when they
    /// fall inside the queried half-open range. An empty query behaves like [`RangeSet::hit`].
    pub fn overlapping(&self, range: Range<usize>) -> RangeQuery<'_, T> {
        RangeQuery::new(self, range)
    }

    /// Alias for [`RangeSet::overlapping`].
    pub fn query(&self, range: Range<usize>) -> RangeQuery<'_, T> {
        self.overlapping(range)
    }

    /// Clips annotations to a source range and shifts them to start at byte zero.
    ///
    /// Non-empty spans are intersected using half-open range rules. Point annotations at either
    /// boundary are retained so line-end anchors survive paragraph clipping. The returned set
    /// preserves authoring order and shares payload allocations with this set.
    /// The ranges and clipping range must already be valid UTF-8 byte offsets for the source.
    pub fn clipped(&self, range: Range<usize>) -> Result<Self, RangeError> {
        if range.start > range.end {
            return Err(RangeError::InvertedRange {
                start: range.start,
                end: range.end,
            });
        }
        if self.is_empty() {
            return Ok(self.clone());
        }

        let mut indices = Vec::new();
        if range.start == range.end {
            let first = self
                .by_start
                .partition_point(|&index| self.spans[index].range.start < range.start);
            let last = self
                .by_start
                .partition_point(|&index| self.spans[index].range.start <= range.start);
            indices.extend(
                self.by_start[first..last]
                    .iter()
                    .copied()
                    .filter(|&index| self.spans[index].is_point()),
            );
        } else {
            let query_end = self
                .by_start
                .partition_point(|&index| self.spans[index].range.start < range.end);
            let mut candidates = self.query_indices(query_end, range.start);
            while let Some(index) = candidates.next_index(self) {
                let span = &self.spans[index];
                let intersects = if span.is_point() {
                    range.start <= span.range.start && span.range.start < range.end
                } else {
                    span.range.start < range.end && range.start < span.range.end
                };
                if intersects {
                    indices.push(index);
                }
            }

            let anchors_start = self
                .by_start
                .partition_point(|&index| self.spans[index].range.start < range.end);
            let anchors_end = self
                .by_start
                .partition_point(|&index| self.spans[index].range.start <= range.end);
            indices.extend(
                self.by_start[anchors_start..anchors_end]
                    .iter()
                    .copied()
                    .filter(|&index| {
                        let span = &self.spans[index];
                        span.is_point() && span.range.start == range.end
                    }),
            );
        }
        indices.sort_unstable();

        let clipped = indices.into_iter().map(|index| {
            let span = &self.spans[index];
            let start = span.range.start.max(range.start).min(range.end) - range.start;
            let end = span.range.end.min(range.end).max(range.start) - range.start;
            Span::shared(
                start..end,
                span.start_affinity,
                span.end_affinity,
                span.shared_value(),
            )
        });
        Ok(Self::new(clipped))
    }

    /// Returns annotations containing the byte position, plus point annotations at that exact
    /// position. Spans cover `[start, end)`; a position at their end is outside the span.
    pub fn hit(&self, position: usize) -> RangeQuery<'_, T> {
        RangeQuery::at(self, position)
    }

    /// Alias for [`RangeSet::hit`], useful when treating a byte offset as a caret or pointer index.
    pub fn at(&self, position: usize) -> RangeQuery<'_, T> {
        self.hit(position)
    }

    /// Returns a new set containing this set followed by `other` in precedence order.
    pub fn concat(&self, other: &Self) -> Self {
        if self.is_empty() {
            return other.clone();
        }
        if other.is_empty() {
            return self.clone();
        }
        Self::new(self.spans.iter().chain(other.spans.iter()).cloned())
    }

    /// Appends one span while preserving the insertion order of existing annotations.
    pub fn with(&self, span: Span<T>) -> Self {
        Self::new(self.spans.iter().cloned().chain(std::iter::once(span)))
    }

    /// Maps endpoints through a validated change set.
    ///
    /// A `Before` start and `After` end include inserted or replacement text at both boundaries.
    /// Spans that were non-empty and become collapsed are removed, and crossed non-empty spans
    /// drop. Explicit points remain points unless their endpoint affinities expand around inserted
    /// text; a crossed pair on a point stays at its start-affinity position.
    pub fn map_through(&self, changes: &ChangeSet) -> Result<Self, ChangeError> {
        if changes.is_noop() {
            // A no-op shares all storage but still validates every endpoint against the source.
            for (index, span) in self.spans.iter().enumerate() {
                if span.range.start > span.range.end {
                    return Err(ChangeError::ReversedRange { index });
                }
                changes.map_position(span.range.start, span.start_affinity)?;
                changes.map_position(span.range.end, span.end_affinity)?;
            }
            return Ok(self.clone());
        }

        let mut mapped = Vec::with_capacity(self.spans.len());
        for (index, span) in self.spans.iter().enumerate() {
            if span.range.start > span.range.end {
                return Err(ChangeError::ReversedRange { index });
            }
            let start = changes.map_position(span.range.start, span.start_affinity)?;
            let end = changes.map_position(span.range.end, span.end_affinity)?;
            if start > end {
                if span.is_point() {
                    mapped.push(Span::shared(
                        start..start,
                        span.start_affinity,
                        span.end_affinity,
                        span.value.clone(),
                    ));
                }
                continue;
            }
            if !span.is_point() && start == end {
                continue;
            }
            mapped.push(Span::shared(
                start..end,
                span.start_affinity,
                span.end_affinity,
                span.value.clone(),
            ));
        }
        Ok(Self::new(mapped))
    }
}

impl<T> Deref for RangeSet<T> {
    type Target = [Span<T>];

    fn deref(&self) -> &Self::Target {
        &self.spans
    }
}

impl<T> RangeSet<T> {
    fn query_indices(&self, end: usize, min_hit: usize) -> RangeQueryIndices {
        RangeQueryIndices {
            set_base: self.tree_base,
            end,
            min_hit,
            stack: [None; usize::BITS as usize],
            stack_len: 0,
        }
        .with_root(self)
    }
}

#[derive(Clone, Copy)]
struct QueryNode {
    node: usize,
    low: usize,
    high: usize,
}

struct RangeQueryIndices {
    set_base: usize,
    end: usize,
    min_hit: usize,
    stack: [Option<QueryNode>; usize::BITS as usize],
    stack_len: usize,
}

impl RangeQueryIndices {
    fn with_root<T>(mut self, set: &RangeSet<T>) -> Self {
        if self.end > 0 && set.max_hit_tree[1] >= self.min_hit {
            self.stack[0] = Some(QueryNode {
                node: 1,
                low: 0,
                high: self.set_base,
            });
            self.stack_len = 1;
        }
        self
    }

    fn next_index<T>(&mut self, set: &RangeSet<T>) -> Option<usize> {
        while self.stack_len > 0 {
            self.stack_len -= 1;
            let QueryNode { node, low, high } = self.stack[self.stack_len].take().unwrap();
            if low >= self.end || set.max_hit_tree[node] < self.min_hit {
                continue;
            }
            if high - low == 1 {
                if low < set.by_start.len() {
                    return Some(set.by_start[low]);
                }
                continue;
            }

            let middle = (low + high) / 2;
            let right = node * 2 + 1;
            let left = node * 2;
            // Push right first so the iterator returns results in coordinate order.
            if middle < self.end && set.max_hit_tree[right] >= self.min_hit {
                self.stack[self.stack_len] = Some(QueryNode {
                    node: right,
                    low: middle,
                    high,
                });
                self.stack_len += 1;
            }
            if low < self.end && set.max_hit_tree[left] >= self.min_hit {
                self.stack[self.stack_len] = Some(QueryNode {
                    node: left,
                    low,
                    high: middle,
                });
                self.stack_len += 1;
            }
        }
        None
    }
}

/// A range-query iterator over the interval index.
pub struct RangeQuery<'a, T> {
    set: &'a RangeSet<T>,
    indices: RangeQueryIndices,
    query_start: usize,
    query_end: usize,
    point_query: bool,
}

impl<'a, T> RangeQuery<'a, T> {
    fn at(set: &'a RangeSet<T>, position: usize) -> Self {
        let end = set
            .by_start
            .partition_point(|&index| set.spans[index].range.start <= position);
        Self {
            set,
            indices: set.query_indices(end, position),
            query_start: position,
            query_end: position,
            point_query: true,
        }
    }

    fn new(set: &'a RangeSet<T>, range: Range<usize>) -> Self {
        if range.start == range.end {
            return Self::at(set, range.start);
        }
        let query_start = range.start;
        let query_end = range.end;
        let end = set
            .by_start
            .partition_point(|&index| set.spans[index].range.start < query_end);
        Self {
            set,
            indices: set.query_indices(end, query_start),
            query_start,
            query_end,
            point_query: false,
        }
    }

    fn matches(&self, span: &Span<T>) -> bool {
        let start = span.range.start;
        let end = span.range.end;
        if self.point_query {
            if start == end {
                start == self.query_start
            } else {
                start <= self.query_start && self.query_start < end
            }
        } else if start == end {
            self.query_start <= start && start < self.query_end
        } else {
            start < self.query_end && self.query_start < end
        }
    }
}

impl<'a, T> Iterator for RangeQuery<'a, T> {
    type Item = &'a Span<T>;

    fn next(&mut self) -> Option<Self::Item> {
        while let Some(index) = self.indices.next_index(self.set) {
            let span = &self.set.spans[index];
            if self.matches(span) {
                return Some(span);
            }
        }
        None
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        (0, None)
    }
}

/// A directed selection stored as anchor and active head byte offsets.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Selection {
    /// The fixed endpoint of the selection, in UTF-8 bytes.
    pub anchor: usize,
    /// The active endpoint of the selection, in UTF-8 bytes.
    pub head: usize,
    /// Insertion affinity at the anchor endpoint.
    pub anchor_affinity: Affinity,
    /// Insertion affinity at the active head endpoint.
    pub head_affinity: Affinity,
}

impl Selection {
    /// Creates a selection whose non-empty range includes insertions at either endpoint.
    ///
    /// A collapsed caret defaults to `After`, so typing at its position leaves the caret after
    /// the inserted text. Use [`Selection::with_affinities`] for a different editing policy.
    pub fn new(anchor: usize, head: usize) -> Self {
        if anchor == head {
            Self {
                anchor,
                head,
                anchor_affinity: Affinity::After,
                head_affinity: Affinity::After,
            }
        } else if anchor < head {
            Self {
                anchor,
                head,
                anchor_affinity: Affinity::Before,
                head_affinity: Affinity::After,
            }
        } else {
            Self {
                anchor,
                head,
                anchor_affinity: Affinity::After,
                head_affinity: Affinity::Before,
            }
        }
    }

    /// Creates a selection with explicit insertion affinity at both endpoints.
    pub fn with_affinities(
        anchor: usize,
        head: usize,
        anchor_affinity: Affinity,
        head_affinity: Affinity,
    ) -> Self {
        Self {
            anchor,
            head,
            anchor_affinity,
            head_affinity,
        }
    }

    /// Returns the ordered half-open range covered by this selection.
    pub fn range(self) -> Range<usize> {
        self.anchor.min(self.head)..self.anchor.max(self.head)
    }

    /// Returns the selection's direction, based on its current endpoints.
    pub fn direction(self) -> SelectionDirection {
        if self.anchor > self.head {
            SelectionDirection::Backward
        } else {
            SelectionDirection::Forward
        }
    }

    /// Returns whether the selection is collapsed.
    pub fn is_empty(self) -> bool {
        self.anchor == self.head
    }

    /// Alias for [`Selection::is_empty`], emphasizing the collapsed-caret case.
    pub fn is_caret(self) -> bool {
        self.is_empty()
    }

    /// Returns the active endpoint, where a caret is drawn.
    pub fn caret(self) -> usize {
        self.head
    }

    /// Maps both directed endpoints through a validated change set.
    pub fn map_through(self, changes: &ChangeSet) -> Result<Self, ChangeError> {
        Ok(Self::with_affinities(
            changes.map_position(self.anchor, self.anchor_affinity)?,
            changes.map_position(self.head, self.head_affinity)?,
            self.anchor_affinity,
            self.head_affinity,
        ))
    }

    /// Collapses the selection to its active head, preserving the default caret policy.
    pub fn collapse_to_head(self) -> Self {
        Self::new(self.head, self.head)
    }

    /// Collapses the selection to its fixed anchor, preserving the default caret policy.
    pub fn collapse_to_anchor(self) -> Self {
        Self::new(self.anchor, self.anchor)
    }
}

impl From<usize> for Selection {
    fn from(position: usize) -> Self {
        Self::new(position, position)
    }
}

/// The direction in which a selection extends from its anchor to its head.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SelectionDirection {
    /// The active head is at or after the anchor.
    Forward,
    /// The active head is before the anchor.
    Backward,
}

/// Why a range could not be applied to a particular UTF-8 string.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum RangeError {
    /// The range's start is greater than its end.
    InvertedRange { start: usize, end: usize },
    /// The range extends past the text's byte length.
    OutOfBounds {
        start: usize,
        end: usize,
        len: usize,
    },
    /// A range endpoint falls inside a UTF-8 code point.
    NotCharBoundary { offset: usize },
}

impl fmt::Display for RangeError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvertedRange { start, end } => {
                write!(f, "range starts at {start} after its end at {end}")
            }
            Self::OutOfBounds { start, end, len } => {
                write!(f, "range {start}..{end} exceeds text length {len}")
            }
            Self::NotCharBoundary { offset } => {
                write!(f, "byte offset {offset} is not a UTF-8 character boundary")
            }
        }
    }
}

impl Error for RangeError {}

#[cfg(test)]
mod tests {
    use super::*;

    fn span(range: Range<usize>, value: &'static str) -> Span<&'static str> {
        Span::new(range, Affinity::Before, Affinity::After, value)
    }

    #[test]
    fn hit_and_overlap_queries_include_point_annotations() {
        let ranges = RangeSet::new([
            span(0..5, "outer"),
            span(2..4, "inner"),
            Span::point(3, Affinity::After, "point"),
            span(5..8, "next"),
        ]);

        assert_eq!(
            ranges.hit(3).map(|span| *span.value()).collect::<Vec<_>>(),
            ["outer", "inner", "point"]
        );
        assert_eq!(
            ranges
                .overlapping(3..6)
                .map(|span| *span.value())
                .collect::<Vec<_>>(),
            ["outer", "inner", "point", "next"]
        );
        assert_eq!(
            ranges.hit(5).map(|span| *span.value()).collect::<Vec<_>>(),
            ["next"]
        );
    }

    #[test]
    fn clipping_shifts_ranges_keeps_points_and_preserves_precedence_and_payloads() {
        let ranges = RangeSet::new([
            span(2..8, "wide"),
            span(0..3, "outside"),
            Span::point(4, Affinity::Before, "start-point"),
            span(5..6, "inner"),
            Span::point(7, Affinity::After, "end-point"),
            Span::point(8, Affinity::After, "past-end"),
        ]);

        let clipped = ranges.clipped(4..7).unwrap();
        assert_eq!(
            clipped
                .iter()
                .map(|span| (*span.value(), span.range.clone()))
                .collect::<Vec<_>>(),
            [
                ("wide", 0..3),
                ("start-point", 0..0),
                ("inner", 1..2),
                ("end-point", 3..3),
            ]
        );
        assert!(Arc::ptr_eq(
            &ranges[0].shared_value(),
            &clipped[0].shared_value()
        ));

        let empty = ranges.clipped(4..4).unwrap();
        assert_eq!(empty.len(), 1);
        assert_eq!(empty[0].value(), &"start-point");
        assert_eq!(empty[0].range, 0..0);
        assert!(ranges.clipped(Range { start: 7, end: 4 }).is_err());
    }

    #[test]
    fn clipping_shares_payloads_without_requiring_clone() {
        #[derive(Debug, PartialEq)]
        struct Payload(u32);

        let payload = Arc::new(Payload(42));
        let ranges = RangeSet::new([Span::shared(
            2..6,
            Affinity::Before,
            Affinity::After,
            payload.clone(),
        )]);
        let clipped = ranges.clipped(3..5).unwrap();

        assert_eq!(clipped[0].range, 0..2);
        assert_eq!(clipped[0].value().0, 42);
        assert!(Arc::ptr_eq(&payload, &clipped[0].shared_value()));
    }

    #[test]
    fn clipping_an_empty_set_shares_its_index_and_checks_range_order() {
        let ranges = RangeSet::<u8>::default();
        let clipped = ranges.clipped(4..7).unwrap();
        assert!(Arc::ptr_eq(&ranges.spans, &clipped.spans));
        assert!(Arc::ptr_eq(&ranges.by_start, &clipped.by_start));
        assert!(Arc::ptr_eq(&ranges.max_hit_tree, &clipped.max_hit_tree));
        assert!(ranges.clipped(Range { start: 7, end: 4 }).is_err());
    }

    #[test]
    fn validates_utf8_boundaries_in_bytes_not_utf16_units() {
        let text = "a😀b";
        let ranges = RangeSet::new([span(1..5, "emoji")]);
        assert!(ranges.validate(text).is_ok());

        let split_emoji = RangeSet::new([span(2..5, "invalid")]);
        assert_eq!(
            split_emoji.validate(text),
            Err(RangeError::NotCharBoundary { offset: 2 })
        );
        assert_eq!(text.len(), 6);
        assert_eq!(text.encode_utf16().count(), 4);
    }

    #[test]
    fn endpoint_affinity_maps_points_and_drops_collapsed_ranges() {
        let insert = ChangeSet::new("ab", [crate::rich_text::Change::new(1..1, "x")]).unwrap();
        let ranges = RangeSet::new([
            Span::new(0..1, Affinity::Before, Affinity::Before, "exclusive-before"),
            Span::new(1..1, Affinity::Before, Affinity::After, "inclusive-point"),
            Span::new(1..1, Affinity::Before, Affinity::Before, "left-point"),
            Span::new(1..1, Affinity::After, Affinity::After, "right-point"),
            Span::new(1..1, Affinity::After, Affinity::Before, "crossed-point"),
        ]);

        let mapped = ranges.map_through(&insert).unwrap();
        let mapped: Vec<_> = mapped
            .iter()
            .map(|span| (*span.value(), span.range.clone()))
            .collect();
        assert_eq!(
            mapped,
            [
                ("exclusive-before", 0..1),
                ("inclusive-point", 1..2),
                ("left-point", 1..1),
                ("right-point", 2..2),
                ("crossed-point", 2..2),
            ]
        );

        let deletion = ChangeSet::new("abc", [crate::rich_text::Change::new(0..3, "x")]).unwrap();
        let exclusive = RangeSet::new([Span::new(
            0..3,
            Affinity::After,
            Affinity::Before,
            "exclusive",
        )]);
        let inclusive = RangeSet::new([Span::new(
            0..3,
            Affinity::Before,
            Affinity::After,
            "inclusive",
        )]);
        assert!(exclusive.map_through(&deletion).unwrap().is_empty());
        assert_eq!(inclusive.map_through(&deletion).unwrap()[0].range, 0..1);
    }

    #[test]
    fn no_op_mapping_shares_storage_and_still_checks_boundaries() {
        let source = RangeSet::new([span(0..1, "kept")]);
        let no_op = ChangeSet::new("a😀b", std::iter::empty::<crate::rich_text::Change>()).unwrap();
        let mapped = source.map_through(&no_op).unwrap();
        assert!(Arc::ptr_eq(&source.spans, &mapped.spans));

        let invalid = RangeSet::new([span(2..5, "split scalar")]);
        assert!(invalid.map_through(&no_op).is_err());

        let reversed = RangeSet::new([span(Range { start: 2, end: 1 }, "reversed")]);
        assert_eq!(
            reversed.map_through(&no_op),
            Err(ChangeError::ReversedRange { index: 0 })
        );
    }

    #[test]
    fn mapping_does_not_require_cloneable_annotation_data() {
        #[derive(Debug, PartialEq)]
        struct Payload(String);

        let source = RangeSet::new([Span::new(
            0..1,
            Affinity::Before,
            Affinity::After,
            Payload("value".to_owned()),
        )]);
        let changes = ChangeSet::new("a", [crate::rich_text::Change::new(0..0, "!")]).unwrap();
        let mapped = source.map_through(&changes).unwrap();
        assert_eq!(mapped[0].range, 0..2);
        assert_eq!(mapped[0].value().0, "value");
    }

    #[test]
    fn selections_keep_direction_and_map_active_caret() {
        let forward = Selection::new(1, 4);
        assert_eq!(forward.range(), 1..4);
        assert_eq!(forward.direction(), SelectionDirection::Forward);

        let backward = Selection::new(4, 1);
        assert_eq!(backward.range(), 1..4);
        assert_eq!(backward.direction(), SelectionDirection::Backward);

        let changes = ChangeSet::new("abcd", [crate::rich_text::Change::new(2..2, "xy")]).unwrap();
        let caret = Selection::new(2, 2).map_through(&changes).unwrap();
        assert_eq!(caret.caret(), 4);
        assert!(caret.is_caret());
    }
}
