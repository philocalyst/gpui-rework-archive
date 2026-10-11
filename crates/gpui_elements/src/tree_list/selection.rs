use std::collections::HashSet;
use std::{fmt::Debug, hash::Hash};

use super::model::{TreeChange, TreeModel};

/// Reusable ID-based selection, focus, anchor, range, and keyboard state.
/// Selected IDs are retained while hidden; removal should be reported with
/// `retain_existing`/`remove_ids` after the backing model changes.
#[derive(Clone, Debug)]
pub struct SelectionState<Id> {
    selected: HashSet<Id>,
    selected_order: Vec<Id>,
    focused: Option<Id>,
    anchor: Option<Id>,
}

impl<Id> Default for SelectionState<Id> {
    fn default() -> Self {
        Self {
            selected: HashSet::new(),
            selected_order: Vec::new(),
            focused: None,
            anchor: None,
        }
    }
}

impl<Id: Clone + Eq + Hash> SelectionState<Id> {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn selected_ids(&self) -> &HashSet<Id> {
        &self.selected
    }
    /// Selected IDs in selection-add order, including currently hidden IDs.
    pub fn selected_ordered(&self) -> &[Id] {
        &self.selected_order
    }
    pub fn is_selected(&self, id: &Id) -> bool {
        self.selected.contains(id)
    }
    pub fn focused(&self) -> Option<&Id> {
        self.focused.as_ref()
    }
    pub fn anchor(&self) -> Option<&Id> {
        self.anchor.as_ref()
    }
    pub fn set_focused(&mut self, id: Option<Id>) {
        self.focused = id;
    }
    pub fn set_anchor(&mut self, id: Option<Id>) {
        self.anchor = id;
    }
    pub fn set_selected(&mut self, id: Id, selected: bool) {
        if selected {
            if self.selected.insert(id.clone()) {
                self.selected_order.push(id);
            }
        } else {
            self.selected.remove(&id);
            self.selected_order.retain(|selected| selected != &id);
        }
    }
    pub fn clear(&mut self) {
        self.selected.clear();
        self.selected_order.clear();
        self.focused = None;
        self.anchor = None;
    }
    pub fn clear_selection(&mut self) {
        self.selected.clear();
        self.selected_order.clear();
    }
    pub fn select_only(&mut self, id: Id) {
        self.selected.clear();
        self.selected_order.clear();
        self.selected.insert(id.clone());
        self.selected_order.push(id.clone());
        self.focused = Some(id.clone());
        self.anchor = Some(id);
    }
    pub fn toggle(&mut self, id: Id) {
        if self.selected.remove(&id) {
            self.selected_order.retain(|selected| selected != &id);
        } else {
            self.selected.insert(id.clone());
            self.selected_order.push(id.clone());
        }
        self.focused = Some(id.clone());
        self.anchor = Some(id);
    }

    /// Select the visible interval from the stored anchor through `target`.
    /// Hidden selected IDs survive. If the anchor is hidden, the range starts
    /// at the target, while the hidden anchor itself remains selected.
    pub fn extend_to(&mut self, visible: &[Id], target: Id, additive: bool) {
        self.extend_to_ordered(
            visible.len(),
            |index| visible.get(index).cloned(),
            target,
            additive,
        );
    }

    /// Slice-free counterpart to `extend_to`, for cached projections and other
    /// virtual lists. `id_at` is called only for rows involved in the range.
    pub fn extend_to_ordered(
        &mut self,
        len: usize,
        mut id_at: impl FnMut(usize) -> Option<Id>,
        target: Id,
        additive: bool,
    ) {
        let Some(target_index) = (0..len).find(|&index| id_at(index).as_ref() == Some(&target))
        else {
            return;
        };
        let anchor = self.anchor.clone().unwrap_or_else(|| target.clone());
        let anchor_index = (0..len).find(|&index| id_at(index).as_ref() == Some(&anchor));
        self.extend_to_indices(len, id_at, anchor_index, target_index, target, additive);
    }

    /// Range selection when the caller already has cached indexes for the
    /// anchor and target. This avoids searching the visible projection again.
    pub fn extend_to_indices(
        &mut self,
        len: usize,
        mut id_at: impl FnMut(usize) -> Option<Id>,
        anchor_index: Option<usize>,
        target_index: usize,
        target: Id,
        additive: bool,
    ) {
        if target_index >= len {
            return;
        }
        let anchor = self.anchor.clone().unwrap_or_else(|| target.clone());
        let anchor_index = anchor_index.filter(|index| *index < len);
        if !additive {
            for index in 0..len {
                if let Some(id) = id_at(index) {
                    self.selected.remove(&id);
                }
            }
            let selected = &self.selected;
            self.selected_order.retain(|id| selected.contains(id));
        }
        if anchor_index.is_none() && !additive {
            if self.selected.insert(anchor.clone()) {
                self.selected_order.push(anchor.clone());
            }
        }
        let start = anchor_index.unwrap_or(target_index).min(target_index);
        let end = anchor_index.unwrap_or(target_index).max(target_index);
        for index in start..=end {
            if let Some(id) = id_at(index) {
                if self.selected.insert(id.clone()) {
                    self.selected_order.push(id);
                }
            }
        }
        self.focused = Some(target);
        if self.anchor.is_none() {
            self.anchor = Some(anchor);
        }
    }

    /// Move focus by a signed visible-row delta, clamped to the current range.
    pub fn move_focus(&mut self, visible: &[Id], delta: isize) -> Option<&Id> {
        self.move_focus_ordered(visible.len(), |index| visible.get(index).cloned(), delta)
    }

    pub fn move_focus_ordered(
        &mut self,
        len: usize,
        mut id_at: impl FnMut(usize) -> Option<Id>,
        delta: isize,
    ) -> Option<&Id> {
        if len == 0 {
            self.focused = None;
            return None;
        }
        let current = self
            .focused
            .as_ref()
            .and_then(|id| (0..len).find(|&index| id_at(index).as_ref() == Some(id)));
        let next = match current {
            Some(i) => (i as i128 + delta as i128).clamp(0, (len - 1) as i128) as usize,
            None if delta < 0 => len - 1,
            None => 0,
        };
        self.focused = id_at(next);
        self.focused.as_ref()
    }
    pub fn focus_home(&mut self, visible: &[Id]) -> Option<&Id> {
        self.focus_home_ordered(visible.len(), |index| visible.get(index).cloned())
    }
    pub fn focus_home_ordered(
        &mut self,
        len: usize,
        mut id_at: impl FnMut(usize) -> Option<Id>,
    ) -> Option<&Id> {
        self.focused = (len > 0).then(|| id_at(0)).flatten();
        self.focused.as_ref()
    }
    pub fn focus_end(&mut self, visible: &[Id]) -> Option<&Id> {
        self.focus_end_ordered(visible.len(), |index| visible.get(index).cloned())
    }
    pub fn focus_end_ordered(
        &mut self,
        len: usize,
        id_at: impl FnMut(usize) -> Option<Id>,
    ) -> Option<&Id> {
        self.focused = len.checked_sub(1).and_then(id_at);
        self.focused.as_ref()
    }
    pub fn focus_at(&mut self, visible: &[Id], index: usize) -> Option<&Id> {
        self.focused = visible.get(index).cloned();
        self.focused.as_ref()
    }

    /// Remove deleted IDs from selection and repair focus/anchor if necessary.
    pub fn remove_ids(&mut self, removed: &[Id]) {
        let removed: HashSet<_> = removed.iter().cloned().collect();
        self.selected.retain(|id| !removed.contains(id));
        self.selected_order.retain(|id| !removed.contains(id));
        if self.focused.as_ref().is_some_and(|id| removed.contains(id)) {
            self.focused = None;
        }
        if self.anchor.as_ref().is_some_and(|id| removed.contains(id)) {
            self.anchor = None;
        }
    }

    /// Keep only IDs accepted by a caller's model membership predicate.
    pub fn retain_existing(&mut self, mut exists: impl FnMut(&Id) -> bool) {
        self.selected.retain(|id| exists(id));
        let selected = &self.selected;
        self.selected_order.retain(|id| selected.contains(id));
        if self.focused.as_ref().is_some_and(|id| !exists(id)) {
            self.focused = None;
        }
        if self.anchor.as_ref().is_some_and(|id| !exists(id)) {
            self.anchor = None;
        }
    }

    /// Reconcile stable-ID selection state with a structural notification.
    /// Hidden IDs remain selected across collapse and moves; removed IDs are
    /// dropped even if they were hidden in the current projection.
    pub fn refresh<M: TreeModel<Id>>(&mut self, model: &M, change: &TreeChange<Id>)
    where
        Id: Debug + 'static,
    {
        match change {
            TreeChange::ChildRemoved { removed, .. } => self.remove_ids(removed),
            TreeChange::ChildInserted { .. } | TreeChange::ChildMoved { .. } => {}
            TreeChange::NodesRemoved { removed, .. } => {
                self.remove_ids(removed);
                self.retain_existing(|id| model.contains(id));
            }
            TreeChange::Reset => self.clear(),
            TreeChange::ChildrenChanged { .. } | TreeChange::NodesMoved { .. } => {
                self.retain_existing(|id| model.contains(id));
            }
            TreeChange::DataChanged { .. } => {}
        }
    }
}
