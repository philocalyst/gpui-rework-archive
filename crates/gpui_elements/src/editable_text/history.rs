//! Patch-based undo and redo history for one editable field.
//!
//! [`EditableTextState`](super::EditableTextState) records and applies these patches for its own
//! buffer. The types here also support a custom editing model: record each edit before applying
//! it, then move inverse patches between stacks when undoing or redoing. The history itself does
//! not own or modify text.

use gpui::CaretSelection;
use std::{ops::Range, time::Duration};
use web_time::Instant;

/// Maximum undo entries retained by [`EditableTextHistory::record`].
///
/// The limit counts patches, not bytes. A patch can contain an arbitrarily large replacement.
pub const MAX_HISTORY_LEN: usize = 1000;

/// Time from a group's first edit during which adjacent edits can join that group.
pub const DEFAULT_GROUP_INTERVAL: Duration = Duration::from_millis(300);

/// Undo and redo stacks for one editable text field.
///
/// Each patch stores replaced text and the selection to restore. Adjacent edits can share one
/// undo step for [`DEFAULT_GROUP_INTERVAL`]; [`record`](Self::record) describes that adjacency.
/// Every recorded edit clears redo, including an edit that joins an existing group. Recording
/// beyond [`MAX_HISTORY_LEN`] discards the oldest undo entry.
///
/// A field owns its history. Query it to enable an Undo control; do not share patches between
/// buffers whose byte ranges and selections refer to different text:
///
/// ```
/// use gpui_ce_elements::editable_text::{EditableTextState, HistoryKind};
///
/// fn can_undo(field: &EditableTextState) -> bool {
///     field.history().is_some_and(|history| history.has_next(HistoryKind::Undo))
/// }
/// ```
pub struct EditableTextHistory {
    /// The duration within which a contiguous edit may extend the latest undo entry.
    grouping_interval: Duration,
    /// Stack of previous states for undo.
    undo_stack: Vec<HistoryEntry>,
    /// Stack of undone states for redo.
    redo_stack: Vec<HistoryEntry>,
}
impl Default for EditableTextHistory {
    fn default() -> Self {
        Self {
            grouping_interval: DEFAULT_GROUP_INTERVAL,
            undo_stack: Vec::with_capacity(MAX_HISTORY_LEN),
            redo_stack: Vec::with_capacity(MAX_HISTORY_LEN),
        }
    }
}

/// A replacement to apply when undoing or redoing an edit.
///
/// Remove [`new_text_len`](Self::new_text_len) bytes at [`range.start`](Self::range), insert
/// [`old_text`](Self::old_text), then restore [`selected_range`](Self::selected_range). Offsets
/// address the buffer version to which the patch applies; they are not stable document positions.
/// The history does not validate them against a buffer. Keep ranges on UTF-8 boundaries and
/// make `range.end == range.start + new_text_len` when constructing an entry yourself.
#[derive(Clone, Debug)]
pub struct HistoryEntry {
    /// The UTF-8 byte range occupied by the text to remove in the current buffer.
    pub range: Range<usize>,
    /// The text to insert when applying this entry (the replaced text for undo).
    pub old_text: String,
    /// Number of UTF-8 bytes to remove before inserting `old_text`.
    pub new_text_len: usize,
    /// The selection snapshot stored with this patch and restored when it is applied.
    pub selected_range: CaretSelection,
    /// Monotonic timestamp of the first edit in this grouped entry, used for grouping decisions.
    pub timestamp: Instant,
}

#[derive(Clone, Debug)]
/// Which stack to inspect or move a patch through.
pub enum HistoryKind {
    /// The stack of edits that can be undone.
    Undo,
    /// The stack of edits that can be redone.
    Redo,
}

impl EditableTextHistory {
    /// Sets the maximum time from the current entry's timestamp for a compatible edit to join it.
    ///
    /// Extending an entry does not update its timestamp, so grouping time is measured from the
    /// first edit in the group rather than from each subsequent edit. The comparison is strict:
    /// an edit at the interval's end starts a new group. Use [`Duration::ZERO`] to disable grouping.
    pub fn set_grouping_interval(&mut self, interval: Duration) {
        self.grouping_interval = interval;
    }

    /// Records an edit before the buffer changes and clears redo.
    ///
    /// `range` addresses the replaced bytes in the pre-edit buffer, `old_text` is their previous
    /// content, `new_text_len` is the inserted UTF-8 byte count, and `selected_range` is the
    /// selection from before the edit. The caller must supply these consistently; this history
    /// cannot inspect the buffer.
    ///
    /// An edit joins the latest group when it starts at that group's current end and arrives
    /// within the grouping interval. This groups forward typing, adjacent replacements, and
    /// repeated forward deletion. Backspace normally moves to an earlier offset and starts a
    /// new group. Grouping preserves the first selection and timestamp and concatenates all
    /// replaced text. It does not distinguish words, user commands, or programmatic edits.
    pub fn record(
        &mut self,
        range: Range<usize>,
        old_text: &str,
        new_text_len: usize,
        selected_range: CaretSelection,
    ) {
        let now = Instant::now();
        self.redo_stack.clear();

        // Check if we should group with the last entry
        if let Some(last) = self.undo_stack.last_mut()
            && now.duration_since(last.timestamp) < self.grouping_interval
        {
            if last.extend(&range, old_text, new_text_len) {
                return;
            }
        }

        // Limit history size
        if self.undo_stack.len() >= MAX_HISTORY_LEN {
            self.undo_stack.remove(0);
        }

        self.push(
            HistoryKind::Undo,
            HistoryEntry {
                range: range.start..range.start + new_text_len,
                old_text: old_text.to_string(),
                new_text_len,
                selected_range,
                timestamp: now,
            },
        );
    }

    fn stack(&self, kind: HistoryKind) -> &Vec<HistoryEntry> {
        match kind {
            HistoryKind::Undo => &self.undo_stack,
            HistoryKind::Redo => &self.redo_stack,
        }
    }

    fn stack_mut(&mut self, kind: HistoryKind) -> &mut Vec<HistoryEntry> {
        match kind {
            HistoryKind::Undo => &mut self.undo_stack,
            HistoryKind::Redo => &mut self.redo_stack,
        }
    }

    /// Returns whether the selected undo or redo stack contains an entry.
    pub fn has_next(&self, kind: HistoryKind) -> bool {
        !self.stack(kind).is_empty()
    }

    /// Pushes an entry onto the selected stack without changing the other stack or enforcing the
    /// recording limit. This is the low-level operation used when moving patches between undo and
    /// redo.
    pub fn push(&mut self, kind: HistoryKind, entry: HistoryEntry) {
        self.stack_mut(kind).push(entry);
    }

    /// Removes and returns the most recent entry from the selected stack.
    pub fn take(&mut self, kind: HistoryKind) -> Option<HistoryEntry> {
        self.stack_mut(kind).pop()
    }
}

impl HistoryEntry {
    fn extend(&mut self, range: &Range<usize>, old_text: &str, new_text_len: usize) -> bool {
        if self.range.end != range.start {
            return false;
        }

        self.range.end = range.start + new_text_len;
        self.new_text_len += new_text_len;
        self.old_text.push_str(old_text);

        true
    }

    /// Returns the UTF-8 byte range to remove, limiting its end to `max_len`.
    ///
    /// The method name is retained for compatibility; this range counts bytes, not characters.
    /// The start is unchanged. This does not repair a stale patch, validate UTF-8 boundaries,
    /// or ensure the returned start precedes the end. Apply the patch only to its expected buffer.
    pub fn char_range(&self, max_len: usize) -> Range<usize> {
        let undo_start = self.range.start;
        let undo_end = (self.range.start + self.new_text_len).min(max_len);
        undo_start..undo_end
    }

    /// Converts this patch into its inverse using the current text at the patch range.
    ///
    /// Before applying this patch, capture the text it removes as `prev_text_at_range`. The
    /// inverse removes `self.old_text` and restores that captured text. Its selection and
    /// timestamp are copied unchanged; set the inverse's `selected_range` to the selection from
    /// before applying this patch when implementing undo/redo.
    ///
    /// This replacement trades a four-byte emoji for six bytes of Japanese text. Undo and redo
    /// therefore remove different byte ranges:
    ///
    /// ```
    /// use gpui_ce_elements::editable_text::{EditableTextHistory, HistoryKind};
    ///
    /// let mut history = EditableTextHistory::default();
    /// let mut text = String::from("A😀B");
    /// history.record(1..5, "😀", "日本".len(), (1..5).into());
    /// text.replace_range(1..5, "日本");
    ///
    /// let undo = history.take(HistoryKind::Undo).unwrap();
    /// let range = undo.char_range(text.len());
    /// assert_eq!(range, 1..7);
    /// let removed_text = text[range.clone()].to_owned();
    /// text.replace_range(range, &undo.old_text);
    /// assert_eq!(text, "A😀B");
    ///
    /// let redo = undo.as_inverted(removed_text);
    /// assert_eq!(redo.char_range(text.len()), 1..5);
    /// text.replace_range(redo.char_range(text.len()), &redo.old_text);
    /// assert_eq!(text, "A日本B");
    /// ```
    pub fn as_inverted(self, prev_text_at_range: String) -> Self {
        HistoryEntry {
            range: self.range.start..self.range.start + self.old_text.len(),
            old_text: prev_text_at_range,
            new_text_len: self.old_text.len(),
            selected_range: self.selected_range,
            timestamp: self.timestamp,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn adjacent_replacements_preserve_all_replaced_text() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::MAX);
        history.record(0..2, "é", 1, CaretSelection::from(0..2));
        history.record(1..5, "😀", 3, CaretSelection::from(1..5));

        let entry = history.take(HistoryKind::Undo).unwrap();
        assert_eq!(entry.old_text, "é😀");
        assert_eq!(entry.char_range(4), 0..4);
        assert!(!history.has_next(HistoryKind::Undo));
    }

    #[test]
    fn consecutive_forward_deletions_preserve_all_removed_text() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::MAX);
        history.record(0..2, "é", 0, 0.into());
        history.record(0..4, "😀", 0, 0.into());

        let entry = history.take(HistoryKind::Undo).unwrap();
        assert_eq!(entry.old_text, "é😀");
        assert_eq!(entry.char_range(0), 0..0);
        assert!(!history.has_next(HistoryKind::Undo));
    }

    #[test]
    fn an_edit_that_joins_an_earlier_group_also_invalidates_redo() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::MAX);
        history.record(0..0, "", 1, 0.into());
        history.record(10..10, "", 1, 10.into());
        let undone = history.take(HistoryKind::Undo).unwrap();
        history.push(HistoryKind::Redo, undone);
        assert!(history.has_next(HistoryKind::Redo));

        history.record(1..1, "", 1, 1.into());
        assert!(!history.has_next(HistoryKind::Redo));
        assert_eq!(history.take(HistoryKind::Undo).unwrap().char_range(2), 0..2);
    }
}
