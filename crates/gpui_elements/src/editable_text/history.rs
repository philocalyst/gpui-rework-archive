//! Patch-based undo and redo history for one editable field.
//!
//! History stores UTF-8 byte ranges and the selection before each edit. A new history entry clears
//! redo entries; a contiguous edit may extend the latest undo entry within the grouping interval.
//! The undo stack is capped at [`MAX_HISTORY_LEN`].

use gpui::CaretSelection;
use std::{ops::Range, time::Duration};
use web_time::Instant;

/// Maximum number of history entries to keep.
pub const MAX_HISTORY_LEN: usize = 1000;

/// Default interval for grouping consecutive edits into a single undo entry.
pub const DEFAULT_GROUP_INTERVAL: Duration = Duration::from_millis(300);

// TODO: Should history get attached directly to storage? currently its per text field and operate both on storage and selection
/// Undo and redo stacks for one editable text field.
///
/// Contiguous edits may be coalesced while the latest entry remains within the grouping interval.
/// Pushing a distinct new entry clears the redo stack.
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

/// A patch-based history entry for memory-efficient undo/redo operations.
///
/// `range`, `new_text_len`, and `selected_range` are interpreted against the buffer version for the
/// stack holding the entry. Ranges and lengths are UTF-8 bytes. Instead of storing the full
/// content, the entry keeps only the replaced text and enough information to restore it.
#[derive(Clone, Debug)]
pub struct HistoryEntry {
    /// The UTF-8 byte range occupied by the new text for undo, or the old text for redo.
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
    /// first edit in the group rather than from each subsequent edit.
    pub fn set_grouping_interval(&mut self, interval: Duration) {
        self.grouping_interval = interval;
    }

    /// Records one edit using a pre-edit UTF-8 byte range and clears redo if it creates a new entry.
    ///
    /// A contiguous append may extend the latest undo patch while its original timestamp is within
    /// the grouping interval; that early-return path leaves the redo stack unchanged.
    /// `range` addresses the replaced bytes in the pre-edit buffer, `old_text` is their previous
    /// content, `new_text_len` is the inserted UTF-8 byte count, and `selected_range` is the
    /// selection snapshot from before the edit.
    pub fn record(
        &mut self,
        range: Range<usize>,
        old_text: &str,
        new_text_len: usize,
        selected_range: CaretSelection,
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

    /// Returns the UTF-8 byte range to remove, clipped to a buffer of `max_len` bytes.
    ///
    /// The method name is retained for compatibility; this range counts bytes, not characters.
    pub fn char_range(&self, max_len: usize) -> Range<usize> {
        let undo_start = self.range.start;
        let undo_end = (self.range.start + self.new_text_len).min(max_len);
        undo_start..undo_end
    }

    /// Converts this patch into its inverse using the current text at the patch range.
    ///
    /// `prev_text_at_range` becomes the text to restore by the inverse entry.
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
