use crate::rich_text::{Document, InlineStyle, RangeSet, Selection};
use std::{
    collections::VecDeque,
    time::{Duration, Instant},
};

/// Maximum number of history entries to keep.
pub const MAX_HISTORY_LEN: usize = 1000;

/// Default interval for grouping consecutive edits into a single undo entry.
pub const DEFAULT_GROUP_INTERVAL: Duration = Duration::from_millis(300);

/// The complete editor state needed to restore one side of an undoable operation.
///
/// Document and RangeSet clones are persistent snapshots, so recording an edit does not copy the
/// full text or all annotation payloads.
#[derive(Clone, Debug)]
pub struct HistorySnapshot {
    pub document: Document,
    pub inline_styles: RangeSet<InlineStyle>,
    pub selection: Selection,
}

/// A single atomic text, formatting, and selection transition.
#[derive(Clone, Debug)]
pub struct HistoryEntry {
    pub before: HistorySnapshot,
    pub after: HistorySnapshot,
    pub timestamp: Instant,
    /// Whether restoring either side changes the document text (as opposed to formatting only).
    pub text_changed: bool,
    can_group: bool,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum HistoryKind {
    Undo,
    Redo,
}

/// Undo/redo history shared by text edits and persistent inline formatting.
pub struct EditableTextHistory {
    grouping_interval: Duration,
    undo_stack: VecDeque<HistoryEntry>,
    redo_stack: VecDeque<HistoryEntry>,
}

impl Default for EditableTextHistory {
    fn default() -> Self {
        Self {
            grouping_interval: DEFAULT_GROUP_INTERVAL,
            // Large eager reservations make each small editor allocate tens of kilobytes.
            undo_stack: VecDeque::new(),
            redo_stack: VecDeque::new(),
        }
    }
}

impl EditableTextHistory {
    pub fn set_grouping_interval(&mut self, interval: Duration) {
        self.grouping_interval = interval;
    }

    /// Records a complete state transition. Only adjacent simple inserts can be grouped.
    pub fn record(
        &mut self,
        before: HistorySnapshot,
        after: HistorySnapshot,
        can_group: bool,
        text_changed: bool,
    ) {
        let now = Instant::now();
        if can_group
            && let Some(last) = self.undo_stack.back_mut()
            && last.can_group
            && now.duration_since(last.timestamp) < self.grouping_interval
            && last.after.document.same_snapshot(&before.document)
            && last.after.selection == before.selection
            && last.after.inline_styles == before.inline_styles
        {
            last.after = after;
            last.timestamp = now;
            last.text_changed |= text_changed;
            // A new edit after undo always discards redo, even when it joins this entry.
            self.redo_stack.clear();
            return;
        }

        if self.undo_stack.len() >= MAX_HISTORY_LEN {
            self.undo_stack.pop_front();
        }
        self.undo_stack.push_back(HistoryEntry {
            before,
            after,
            timestamp: now,
            text_changed,
            can_group,
        });
        self.redo_stack.clear();
    }

    /// Prevents the next insertion from joining the most recent typing group.
    pub fn break_grouping(&mut self) {
        if let Some(last) = self.undo_stack.back_mut() {
            last.can_group = false;
        }
    }

    /// Updates the after-state of an in-progress IME history entry.
    pub fn update_composition_after(&mut self, after: HistorySnapshot) {
        if let Some(last) = self.undo_stack.back_mut() {
            last.after = after;
            last.timestamp = Instant::now();
            last.text_changed = true;
            last.can_group = false;
            self.redo_stack.clear();
        }
    }

    /// Removes an IME entry that was canceled back to the same text and formatting.
    ///
    /// This runs only when composition ends, so comparing the persistent chunk streams does not
    /// add work to the per-keystroke path or flatten a document.
    pub fn discard_noop_composition(&mut self) -> bool {
        let Some(last) = self.undo_stack.back() else {
            return false;
        };
        let before = &last.before;
        let after = &last.after;
        if before.document.len_bytes() == after.document.len_bytes()
            && before
                .document
                .content_matches_segments(after.document.chunks())
            && before.inline_styles == after.inline_styles
        {
            self.undo_stack.pop_back();
            true
        } else {
            false
        }
    }

    pub fn has_next(&self, kind: HistoryKind) -> bool {
        !self.stack(kind).is_empty()
    }

    pub fn take(&mut self, kind: HistoryKind) -> Option<HistoryEntry> {
        self.stack_mut(kind).pop_back()
    }

    pub fn push(&mut self, kind: HistoryKind, entry: HistoryEntry) {
        let stack = self.stack_mut(kind);
        if stack.len() >= MAX_HISTORY_LEN {
            stack.pop_front();
        }
        stack.push_back(entry);
    }

    fn stack(&self, kind: HistoryKind) -> &VecDeque<HistoryEntry> {
        match kind {
            HistoryKind::Undo => &self.undo_stack,
            HistoryKind::Redo => &self.redo_stack,
        }
    }

    fn stack_mut(&mut self, kind: HistoryKind) -> &mut VecDeque<HistoryEntry> {
        match kind {
            HistoryKind::Undo => &mut self.undo_stack,
            HistoryKind::Redo => &mut self.redo_stack,
        }
    }
}
