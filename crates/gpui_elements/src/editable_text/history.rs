use std::{
    ops::Range,
    time::{Duration, Instant},
};

/// Maximum number of history entries to keep.
pub const MAX_HISTORY_LEN: usize = 1000;

/// Default interval for grouping consecutive edits into a single undo entry.
pub const DEFAULT_GROUP_INTERVAL: Duration = Duration::from_millis(300);

// TODO: Should history get attached directly to storage? currently its per text field and operate both on storage and selection
pub struct EditableTextHistory {
    /// The maximum duration between changes to `content` that can be grouped together as a single entry in the history log.
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

/// A patch-based history entry for memory-efficient undo/redo operations.
/// Instead of storing the full content, we store only the change needed to reverse the edit.
#[derive(Clone, Debug)]
pub struct HistoryEntry {
    /// The byte range that was modified (after the edit, for undo; before the edit, for redo).
    pub range: Range<usize>,
    /// The text that was replaced (to restore on undo).
    pub old_text: String,
    /// The length of the new text that replaced old_text (to know how much to remove on undo).
    pub new_text_len: usize,
    /// The selection range before the edit.
    pub selected_range: (usize, usize),
    /// Timestamp for grouping consecutive edits.
    pub timestamp: Instant,
}

#[derive(Clone, Debug)]
pub enum HistoryKind {
    Undo,
    Redo,
}

impl EditableTextHistory {
    pub fn set_grouping_interval(&mut self, interval: Duration) {
        self.grouping_interval = interval;
    }

    pub fn record(
        &mut self,
        range: Range<usize>,
        old_text: &str,
        new_text_len: usize,
        selected_range: (usize, usize),
    ) {
        let now = Instant::now();

        // Check if we should group with the last entry
        if let Some(last) = self.undo_stack.last_mut()
            && now.duration_since(last.timestamp) < self.grouping_interval
        {
            // The change was triggered within group interval timing.
            // Try to extend the existing patch (which is a mutation).
            // If extending successeds, then we can early-out. Otherwise the mutation is non-contiguous.
            if last.extend(&range, new_text_len) {
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

        // New edit invalidates redo stack
        self.redo_stack.clear();
    }

    fn stack(&self, kind: HistoryKind) -> &Vec<HistoryEntry> {
        // NOTE: Could be an internal map
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

    pub fn has_next(&self, kind: HistoryKind) -> bool {
        !self.stack(kind).is_empty()
    }

    pub fn push(&mut self, kind: HistoryKind, entry: HistoryEntry) {
        self.stack_mut(kind).push(entry);
    }

    pub fn take(&mut self, kind: HistoryKind) -> Option<HistoryEntry> {
        self.stack_mut(kind).pop()
    }
}

impl HistoryEntry {
    fn extend(&mut self, range: &Range<usize>, new_text_len: usize) -> bool {
        // NOTE: Could be more robust. Currently only supports human-written extensions from start towards end.

        // ranges must be contiguous in order to integrate/extend
        if self.range.end != range.start {
            return false;
        }

        self.range.end = range.start + new_text_len;
        self.new_text_len += new_text_len;

        true
    }

    pub fn char_range(&self, max_len: usize) -> Range<usize> {
        let undo_start = self.range.start;
        let undo_end = (self.range.start + self.new_text_len).min(max_len);
        undo_start..undo_end
    }

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

    /// Records a pure insertion of `text` at byte offset `at`, with no grouping of consecutive edits.
    fn record_insert(
        history: &mut EditableTextHistory,
        at: usize,
        text: &str,
        selected_range: (usize, usize),
    ) {
        history.record(at..at, "", text.len(), selected_range);
    }

    #[test]
    fn undo_stack_returns_entries_in_lifo_order() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::ZERO);

        record_insert(&mut history, 0, "a", (0, 0));
        record_insert(&mut history, 1, "b", (1, 1));
        record_insert(&mut history, 2, "c", (2, 2));

        assert!(history.has_next(HistoryKind::Undo));
        assert_eq!(
            history
                .take(HistoryKind::Undo)
                .unwrap()
                .char_range(usize::MAX),
            2..3
        );
        assert_eq!(
            history
                .take(HistoryKind::Undo)
                .unwrap()
                .char_range(usize::MAX),
            1..2
        );
        assert_eq!(
            history
                .take(HistoryKind::Undo)
                .unwrap()
                .char_range(usize::MAX),
            0..1
        );
        assert!(!history.has_next(HistoryKind::Undo));
        assert!(history.take(HistoryKind::Undo).is_none());
    }

    #[test]
    fn empty_history_undo_and_redo_are_noops() {
        let mut history = EditableTextHistory::default();
        assert!(!history.has_next(HistoryKind::Undo));
        assert!(!history.has_next(HistoryKind::Redo));
        assert!(history.take(HistoryKind::Undo).is_none());
        assert!(history.take(HistoryKind::Redo).is_none());
    }

    #[test]
    fn redo_stack_returns_entries_in_lifo_order() {
        let mut history = EditableTextHistory::default();
        history.push(
            HistoryKind::Redo,
            HistoryEntry {
                range: 0..1,
                old_text: "x".into(),
                new_text_len: 1,
                selected_range: (0, 0),
                timestamp: Instant::now(),
            },
        );
        history.push(
            HistoryKind::Redo,
            HistoryEntry {
                range: 1..2,
                old_text: "y".into(),
                new_text_len: 1,
                selected_range: (1, 1),
                timestamp: Instant::now(),
            },
        );

        assert!(history.has_next(HistoryKind::Redo));
        assert_eq!(history.take(HistoryKind::Redo).unwrap().range, 1..2);
        assert_eq!(history.take(HistoryKind::Redo).unwrap().range, 0..1);
        assert!(!history.has_next(HistoryKind::Redo));
        assert!(history.take(HistoryKind::Redo).is_none());
    }

    #[test]
    fn new_record_clears_redo_stack() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::ZERO);

        record_insert(&mut history, 0, "a", (0, 0));
        let undone = history.take(HistoryKind::Undo).unwrap();
        history.push(HistoryKind::Redo, undone);
        assert!(history.has_next(HistoryKind::Redo));

        record_insert(&mut history, 0, "b", (0, 0));
        assert!(!history.has_next(HistoryKind::Redo));
        assert!(history.take(HistoryKind::Redo).is_none());
    }

    #[test]
    fn contiguous_edits_within_group_interval_merge_into_single_entry() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::from_secs(60));

        record_insert(&mut history, 0, "a", (0, 0));
        record_insert(&mut history, 1, "b", (1, 1));
        record_insert(&mut history, 2, "c", (2, 2));

        assert_eq!(history.undo_stack.len(), 1);
        let entry = history.take(HistoryKind::Undo).unwrap();
        assert_eq!(entry.char_range(usize::MAX), 0..3);
        assert_eq!(entry.new_text_len, 3);
        assert_eq!(entry.old_text, "");
    }

    #[test]
    fn non_contiguous_edits_do_not_group() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::from_secs(60));

        record_insert(&mut history, 0, "a", (0, 0));
        record_insert(&mut history, 5, "b", (5, 5));

        assert_eq!(history.undo_stack.len(), 2);
    }

    #[test]
    fn char_range_clamps_to_available_length() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::ZERO);

        record_insert(&mut history, 0, "hello", (0, 0));
        let entry = history.take(HistoryKind::Undo).unwrap();
        assert_eq!(entry.char_range(3), 0..3);
        assert_eq!(entry.char_range(10), 0..5);
    }

    #[test]
    fn inverted_entry_swaps_old_and_new_text() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::ZERO);

        history.record(0..3, "foo", 3, (3, 3));
        let entry = history.take(HistoryKind::Undo).unwrap();
        assert_eq!(entry.range, 0..3);
        assert_eq!(entry.old_text, "foo");
        assert_eq!(entry.new_text_len, 3);
        assert_eq!(entry.selected_range, (3, 3));
        let timestamp = entry.timestamp;

        let inverted = entry.as_inverted("bar".to_string());
        assert_eq!(inverted.range, 0..3);
        assert_eq!(inverted.old_text, "bar");
        assert_eq!(inverted.new_text_len, 3);
        assert_eq!(inverted.selected_range, (3, 3));
        assert_eq!(inverted.timestamp, timestamp);
    }

    #[test]
    fn history_length_is_capped() {
        let mut history = EditableTextHistory::default();
        history.set_grouping_interval(Duration::ZERO);

        for i in 0..MAX_HISTORY_LEN + 10 {
            record_insert(&mut history, i, "x", (i, i));
        }

        assert_eq!(history.undo_stack.len(), MAX_HISTORY_LEN);
        let mut oldest_range_start = None;
        while let Some(entry) = history.take(HistoryKind::Undo) {
            oldest_range_start = Some(entry.range.start);
        }
        assert_eq!(oldest_range_start, Some(10));
    }
}
