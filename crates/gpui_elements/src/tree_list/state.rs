use std::collections::{HashMap, HashSet};
use std::{fmt::Debug, hash::Hash};

use super::model::{ProjectionSplice, TreeChange, TreeModel, VisibleNode};

struct ChildFrame<Id> {
    parent: Option<Id>,
    next_index: usize,
    count: usize,
    depth: usize,
}

/// Iterative preorder traversal whose pending work is one sibling cursor per
/// expanded ancestor, rather than one entry per sibling.
struct VisibleTraversal<'a, Id, M> {
    model: &'a M,
    expanded: &'a HashSet<Id>,
    existing: Option<&'a HashMap<Id, usize>>,
    seen: HashSet<Id>,
    frames: Vec<ChildFrame<Id>>,
}

impl<'a, Id, M> VisibleTraversal<'a, Id, M>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id>,
{
    fn from_children(
        model: &'a M,
        expanded: &'a HashSet<Id>,
        parent: Option<Id>,
        depth: usize,
        seen: HashSet<Id>,
        existing: Option<&'a HashMap<Id, usize>>,
    ) -> Self {
        let count = parent
            .as_ref()
            .map_or_else(|| model.roots_len(), |parent| model.child_count(parent));
        Self {
            model,
            expanded,
            existing,
            seen,
            frames: vec![ChildFrame {
                parent,
                next_index: 0,
                count,
                depth,
            }],
        }
    }
}

impl<Id, M> Iterator for VisibleTraversal<'_, Id, M>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id>,
{
    type Item = VisibleNode<Id>;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let Some(frame) = self.frames.last_mut() else {
                return None;
            };
            if frame.next_index >= frame.count {
                self.frames.pop();
                continue;
            }
            let parent = frame.parent.clone();
            let index_in_parent = frame.next_index;
            let depth = frame.depth;
            frame.next_index += 1;
            let Some(id) = (match parent.as_ref() {
                Some(parent) => self.model.child_at(parent, index_in_parent),
                None => self.model.root_at(index_in_parent),
            }) else {
                continue;
            };
            if self
                .existing
                .is_some_and(|existing| existing.contains_key(&id))
                || !self.seen.insert(id.clone())
            {
                continue;
            }
            let row = VisibleNode {
                id: id.clone(),
                depth,
                parent,
                index_in_parent,
            };
            if self.expanded.contains(&id) {
                self.frames.push(ChildFrame {
                    parent: Some(id.clone()),
                    next_index: 0,
                    count: self.model.child_count(&id),
                    depth: depth + 1,
                });
            }
            return Some(row);
        }
    }
}

/// Expansion and a cached preorder projection for a tree-list.
///
/// Rendering reads `visible_rows` in O(1) and does not walk the model. Initial
/// projection costs O(visible nodes). Expanding/collapsing a node costs O(the
/// visible subtree) plus O(rows) to refresh positional lookup. Bulk
/// `ChildrenChanged` notifications rebuild the projection. Precise indexed
/// edits read only the inserted/moved subtree and the sibling needed to find
/// its position; updating dense row positions still scans the affected cached
/// suffix, but keeps existing identity-map keys in place. The queued splice
/// lets virtualized views update their row storage without diffing the full
/// projection. Full rebuilds also keep a traversal `seen` set alongside the
/// new row vector, so peak auxiliary memory is O(visible nodes) in addition to
/// the cached row and index allocations.
pub struct TreeListState<Id> {
    expanded: HashSet<Id>,
    rows: Vec<VisibleNode<Id>>,
    index: std::collections::HashMap<Id, usize>,
    initialized: bool,
    projection_changes: Vec<ProjectionSplice>,
}

impl<Id> Default for TreeListState<Id> {
    fn default() -> Self {
        Self {
            expanded: HashSet::new(),
            rows: Vec::new(),
            index: std::collections::HashMap::new(),
            initialized: false,
            projection_changes: Vec::new(),
        }
    }
}

impl<Id: Clone + Eq + Hash + Debug + 'static> TreeListState<Id> {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn expanded_ids(&self) -> &HashSet<Id> {
        &self.expanded
    }
    pub fn is_expanded(&self, id: &Id) -> bool {
        self.expanded.contains(id)
    }
    pub fn visible_rows<M: TreeModel<Id>>(&mut self, model: &M) -> &[VisibleNode<Id>] {
        if !self.initialized {
            self.rebuild_projection(model);
        }
        &self.rows
    }
    /// Read-only cached rows. Call `visible_rows` once after construction to
    /// initialize before using this accessor.
    pub fn visible_rows_cached(&self) -> &[VisibleNode<Id>] {
        &self.rows
    }
    pub fn visible_len(&self) -> usize {
        self.rows.len()
    }
    pub fn visible_row(&self, index: usize) -> Option<&VisibleNode<Id>> {
        self.rows.get(index)
    }
    pub fn visible_index(&self, id: &Id) -> Option<usize> {
        self.index.get(id).copied()
    }

    /// Drain projection edits since the last call. Apply in order to the
    /// virtual-list state; each range is relative to the projection after all
    /// earlier returned edits have been applied.
    pub fn take_projection_changes(&mut self) -> Vec<ProjectionSplice> {
        std::mem::take(&mut self.projection_changes)
    }

    /// Replace expansion state in one operation, useful for initial state or
    /// restoring a saved set of expanded IDs without repeated branch rebuilds.
    pub fn set_expanded_ids<M: TreeModel<Id>>(
        &mut self,
        model: &M,
        ids: impl IntoIterator<Item = Id>,
    ) -> bool {
        let next: HashSet<_> = ids.into_iter().filter(|id| model.contains(id)).collect();
        if self.expanded == next {
            return false;
        }
        self.expanded = next;
        self.rebuild_projection(model);
        true
    }

    pub fn set_expanded<M: TreeModel<Id>>(&mut self, model: &M, id: Id, expanded: bool) -> bool {
        if !model.contains(&id) {
            return false;
        }
        if expanded {
            if !self.expanded.insert(id.clone()) {
                return false;
            }
        } else if !self.expanded.remove(&id) {
            return false;
        }
        if !self.initialized {
            self.rebuild_projection(model);
            return true;
        }
        self.refresh_branch(model, &id);
        true
    }

    pub fn toggle_expanded<M: TreeModel<Id>>(&mut self, model: &M, id: Id) -> bool {
        self.set_expanded(model, id.clone(), !self.is_expanded(&id))
    }

    /// Apply a structural notification after the backing model was changed.
    /// Removal notifications should include every removed descendant.
    pub fn refresh<M: TreeModel<Id>>(&mut self, model: &M, change: TreeChange<Id>) {
        match change {
            TreeChange::ChildInserted {
                parent,
                index,
                inserted,
            } => {
                if self.initialized {
                    self.insert_child(model, parent, index, inserted);
                } else {
                    self.rebuild_projection(model);
                }
            }
            TreeChange::ChildRemoved {
                parent,
                index,
                removed,
            } => {
                if self.initialized {
                    let removed_from_model =
                        !removed.is_empty() && removed.iter().all(|id| !model.contains(id));
                    if removed_from_model {
                        for id in &removed {
                            self.expanded.remove(id);
                        }
                        let source_matches = removed
                            .first()
                            .and_then(|root| {
                                self.index.get(root).map(|&row_index| {
                                    self.rows[row_index].parent == parent
                                        && self.rows[row_index].index_in_parent == index
                                })
                            })
                            .unwrap_or(true);
                        if source_matches {
                            self.remove_child(model, parent, index, &removed);
                        } else {
                            self.rebuild_projection(model);
                        }
                    } else {
                        self.rebuild_projection(model);
                    }
                } else {
                    for id in &removed {
                        self.expanded.remove(id);
                    }
                    self.rebuild_projection(model);
                }
            }
            TreeChange::ChildMoved {
                from_parent,
                from_index,
                to_parent,
                to_index,
                moved,
            } => {
                if self.initialized {
                    self.move_child(model, from_parent, from_index, to_parent, to_index, &moved);
                } else {
                    self.rebuild_projection(model);
                }
            }
            TreeChange::ChildrenChanged { parent } => {
                self.expanded.retain(|id| model.contains(id));
                match parent {
                    Some(id) => self.refresh_branch(model, &id),
                    None => self.rebuild_projection(model),
                }
            }
            TreeChange::NodesRemoved { parent, removed } => {
                for id in removed {
                    self.expanded.remove(&id);
                }
                self.expanded.retain(|id| model.contains(id));
                match parent {
                    Some(id) => self.refresh_branch(model, &id),
                    None => self.rebuild_projection(model),
                }
            }
            TreeChange::NodesMoved { .. } => {
                // The model already reflects both sides of a move. One atomic
                // rebuild avoids duplicate row IDs and invalid intermediate indexes.
                self.expanded.retain(|id| model.contains(id));
                self.rebuild_projection(model);
            }
            TreeChange::DataChanged { .. } => {
                // Structure and row geometry are unchanged. Keep the ID in the
                // notification so callers can invalidate just their row view.
            }
            TreeChange::Reset => {
                self.expanded.clear();
                self.rebuild_projection(model);
            }
        }
    }

    /// Rebuild the full visible preorder after bulk replacement or unknown changes.
    pub fn rebuild_projection<M: TreeModel<Id>>(&mut self, model: &M) {
        let old_len = self.rows.len();
        let was_initialized = self.initialized;
        self.rows.clear();
        self.rows.extend(VisibleTraversal::from_children(
            model,
            &self.expanded,
            None,
            0,
            HashSet::new(),
            None,
        ));
        self.initialized = true;
        self.reindex();
        if was_initialized {
            self.projection_changes.push(ProjectionSplice {
                old_range: 0..old_len,
                inserted_count: self.rows.len(),
                new_len: self.rows.len(),
            });
        }
    }

    fn refresh_branch<M: TreeModel<Id>>(&mut self, model: &M, parent: &Id) {
        if !self.initialized {
            self.rebuild_projection(model);
            return;
        }
        if !model.contains(parent) {
            self.rebuild_projection(model);
            return;
        }
        let Some(&parent_index) = self.index.get(parent) else {
            return;
        };
        let depth = self.rows[parent_index].depth;
        let mut end = parent_index + 1;
        while end < self.rows.len() && self.rows[end].depth > depth {
            end += 1;
        }
        let mut replacement = Vec::new();
        if self.expanded.contains(parent) {
            let seen: HashSet<Id> = self.rows[..=parent_index]
                .iter()
                .map(|row| row.id.clone())
                .chain(self.rows[end..].iter().map(|row| row.id.clone()))
                .collect();
            replacement.extend(VisibleTraversal::from_children(
                model,
                &self.expanded,
                Some(parent.clone()),
                depth + 1,
                seen,
                None,
            ));
        }
        let old_range = parent_index + 1..end;
        let inserted_count = replacement.len();
        if !old_range.is_empty() || inserted_count > 0 {
            self.rows.splice(old_range.clone(), replacement);
            self.projection_changes.push(ProjectionSplice {
                old_range,
                inserted_count,
                new_len: self.rows.len(),
            });
        }
        self.reindex();
    }

    fn reindex(&mut self) {
        self.index.clear();
        self.index.reserve(self.rows.len());
        for (i, row) in self.rows.iter().enumerate() {
            self.index.insert(row.id.clone(), i);
        }
    }

    fn insert_child<M: TreeModel<Id>>(
        &mut self,
        model: &M,
        parent: Option<Id>,
        index: usize,
        inserted: Id,
    ) {
        if !self.location_matches(model, parent.as_ref(), index, &inserted)
            || self.index.contains_key(&inserted)
        {
            self.rebuild_projection(model);
            return;
        }
        let (position, depth) = match parent.as_ref() {
            Some(parent) => {
                let Some(&parent_row) = self.index.get(parent) else {
                    return;
                };
                if !self.expanded.contains(parent) {
                    return;
                }
                (
                    self.sibling_insert_position(model, Some(parent), index, parent_row + 1),
                    self.rows[parent_row].depth + 1,
                )
            }
            None => (self.sibling_insert_position(model, None, index, 0), 0),
        };
        let replacement = self.collect_subtree(model, inserted, parent.clone(), depth, index);
        let inserted_count = replacement.len();
        self.rows.splice(position..position, replacement);
        self.update_sibling_indices(position + inserted_count, parent.as_ref(), index, 1);
        self.record_suffix_change(position, 0, inserted_count);
    }

    fn remove_child<M: TreeModel<Id>>(
        &mut self,
        model: &M,
        parent: Option<Id>,
        index: usize,
        removed: &[Id],
    ) {
        let Some(root) = removed.first() else { return };
        let Some(&start) = self.index.get(root) else {
            return;
        };
        if self.rows[start].parent != parent || self.rows[start].index_in_parent != index {
            self.rebuild_projection(model);
            return;
        }
        let end = self.subtree_end(start);
        for row in &self.rows[start..end] {
            self.index.remove(&row.id);
            self.expanded.remove(&row.id);
        }
        self.rows.drain(start..end);
        self.update_sibling_indices(start, parent.as_ref(), index, -1);
        self.record_suffix_change(start, end - start, 0);
    }

    fn move_child<M: TreeModel<Id>>(
        &mut self,
        model: &M,
        from_parent: Option<Id>,
        from_index: usize,
        to_parent: Option<Id>,
        to_index: usize,
        moved: &[Id],
    ) {
        let Some(root) = moved.first().cloned() else {
            return;
        };
        if !self.location_matches(model, to_parent.as_ref(), to_index, &root) {
            self.rebuild_projection(model);
            return;
        }
        let Some(&start) = self.index.get(&root) else {
            // The moved branch was hidden by a collapsed ancestor. It may now
            // be visible at the destination, so insert only that subtree.
            self.insert_child(model, to_parent, to_index, root);
            return;
        };
        if self.rows[start].parent != from_parent || self.rows[start].index_in_parent != from_index
        {
            self.rebuild_projection(model);
            return;
        }
        let end = self.subtree_end(start);
        if to_parent
            .as_ref()
            .and_then(|parent| self.index.get(parent))
            .is_some_and(|&parent_row| (start..end).contains(&parent_row))
        {
            // Reject malformed reparenting into the moved subtree. Rebuilding
            // from the guarded traversal avoids dropping rows on this path.
            self.rebuild_projection(model);
            return;
        }
        let old_len = end - start;
        for row in &self.rows[start..end] {
            self.index.remove(&row.id);
        }
        self.rows.drain(start..end);
        self.refresh_indices_from(start);
        self.update_sibling_indices(start, from_parent.as_ref(), from_index, -1);
        let (position, depth) = match to_parent.as_ref() {
            Some(parent) => {
                let Some(&parent_row) = self.index.get(parent) else {
                    self.record_suffix_change(start, old_len, 0);
                    return;
                };
                if !self.expanded.contains(parent) {
                    self.record_suffix_change(start, old_len, 0);
                    return;
                }
                (
                    self.sibling_insert_position(model, Some(parent), to_index, parent_row),
                    self.rows[parent_row].depth + 1,
                )
            }
            None => (self.sibling_insert_position(model, None, to_index, 0), 0),
        };
        let replacement = self.collect_subtree(model, root, to_parent.clone(), depth, to_index);
        let inserted_len = replacement.len();
        self.rows.splice(position..position, replacement);
        self.update_sibling_indices(position + inserted_len, to_parent.as_ref(), to_index, 1);
        let range_start = start.min(position);
        let old_end = if position >= start {
            position + old_len
        } else {
            end
        };
        let old_range_len = old_end.saturating_sub(range_start);
        let replacement_count = old_range_len
            .saturating_sub(old_len)
            .saturating_add(inserted_len);
        self.record_suffix_change(range_start, old_range_len, replacement_count);
    }

    fn sibling_insert_position<M: TreeModel<Id>>(
        &self,
        model: &M,
        parent: Option<&Id>,
        index: usize,
        fallback: usize,
    ) -> usize {
        if index == 0 {
            return fallback.min(self.rows.len());
        }
        let previous = match parent {
            Some(parent) => model.child_at(parent, index - 1),
            None => model.root_at(index - 1),
        };
        previous
            .and_then(|id| self.index.get(&id).copied())
            .map(|row| self.subtree_end(row))
            .unwrap_or(fallback.min(self.rows.len()))
    }

    fn location_matches<M: TreeModel<Id>>(
        &self,
        model: &M,
        parent: Option<&Id>,
        index: usize,
        id: &Id,
    ) -> bool {
        if !model.contains(id) {
            return false;
        }
        match parent {
            Some(parent) => model.child_at(parent, index).as_ref() == Some(id),
            None => model.root_at(index).as_ref() == Some(id),
        }
    }

    fn collect_subtree<M: TreeModel<Id>>(
        &self,
        model: &M,
        root: Id,
        parent: Option<Id>,
        depth: usize,
        index_in_parent: usize,
    ) -> Vec<VisibleNode<Id>> {
        let mut rows = vec![VisibleNode {
            id: root.clone(),
            depth,
            parent,
            index_in_parent,
        }];
        if self.expanded.contains(&root) {
            let mut seen = HashSet::new();
            seen.insert(root.clone());
            rows.extend(VisibleTraversal::from_children(
                model,
                &self.expanded,
                Some(root),
                depth + 1,
                seen,
                Some(&self.index),
            ));
        }
        rows
    }

    fn subtree_end(&self, start: usize) -> usize {
        let depth = self.rows[start].depth;
        let mut end = start + 1;
        while end < self.rows.len() && self.rows[end].depth > depth {
            end += 1;
        }
        end
    }

    fn update_sibling_indices(
        &mut self,
        start_row: usize,
        parent: Option<&Id>,
        from: usize,
        delta: isize,
    ) {
        // Earlier preorder rows cannot be later siblings. Starting after the
        // inserted subtree also keeps its already-correct indexes untouched.
        for row in &mut self.rows[start_row..] {
            if row.parent.as_ref() == parent && row.index_in_parent >= from {
                row.index_in_parent = row.index_in_parent.saturating_add_signed(delta);
            }
        }
    }

    fn record_suffix_change(&mut self, start: usize, old_len: usize, inserted_count: usize) {
        // Dense row positions shift after a splice, but identity-map keys stay
        // in place. Update only values in the affected suffix.
        self.refresh_indices_from(start);
        self.projection_changes.push(ProjectionSplice {
            old_range: start..start + old_len,
            inserted_count,
            new_len: self.rows.len(),
        });
    }

    fn refresh_indices_from(&mut self, start: usize) {
        for i in start..self.rows.len() {
            if let Some(index) = self.index.get_mut(&self.rows[i].id) {
                *index = i;
            } else {
                self.index.insert(self.rows[i].id.clone(), i);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::super::{
        drag::{DropTarget, autoscroll_velocity, reduce_drag_roots, resolve_drop},
        selection::SelectionState,
    };
    use super::*;
    use std::cell::Cell;
    use std::collections::HashMap;

    #[derive(Default)]
    struct Model {
        roots: Vec<usize>,
        nodes: HashMap<usize, (Option<usize>, Vec<usize>)>,
    }
    impl TreeModel<usize> for Model {
        fn roots_len(&self) -> usize {
            self.roots.len()
        }
        fn root_at(&self, i: usize) -> Option<usize> {
            self.roots.get(i).copied()
        }
        fn child_count(&self, id: &usize) -> usize {
            self.nodes.get(id).map_or(0, |n| n.1.len())
        }
        fn child_at(&self, id: &usize, i: usize) -> Option<usize> {
            self.nodes.get(id).and_then(|n| n.1.get(i)).copied()
        }
        fn parent(&self, id: &usize) -> Option<usize> {
            self.nodes.get(id).and_then(|n| n.0)
        }
        fn contains(&self, id: &usize) -> bool {
            self.nodes.contains_key(id)
        }
    }
    impl Model {
        fn add(&mut self, id: usize, parent: Option<usize>) {
            self.nodes.insert(id, (parent, Vec::new()));
            if let Some(p) = parent {
                self.nodes.get_mut(&p).unwrap().1.push(id);
            } else {
                self.roots.push(id);
            }
        }
    }

    #[test]
    fn iterative_projection_handles_deep_trees_and_skips_collapsed_subtrees() {
        let mut deep = Model::default();
        deep.add(0, None);
        for id in 1..20_000 {
            deep.add(id, Some(id - 1));
        }
        let mut state = TreeListState::new();
        for id in 0..20_000 {
            state.expanded.insert(id);
        }
        let rows = state.visible_rows(&deep);
        assert_eq!(rows.len(), 20_000);
        assert_eq!(rows.last().unwrap().depth, 19_999);

        struct WideModel;
        impl TreeModel<usize> for WideModel {
            fn roots_len(&self) -> usize {
                1
            }
            fn root_at(&self, index: usize) -> Option<usize> {
                (index == 0).then_some(0)
            }
            fn child_count(&self, parent: &usize) -> usize {
                (*parent == 0).then_some(1_000_000).unwrap_or(0)
            }
            fn child_at(&self, parent: &usize, index: usize) -> Option<usize> {
                (*parent == 0 && index < 1_000_000).then_some(index + 1)
            }
            fn parent(&self, id: &usize) -> Option<usize> {
                (*id > 0 && *id <= 1_000_000).then_some(0)
            }
            fn contains(&self, id: &usize) -> bool {
                *id <= 1_000_000
            }
        }
        let mut state = TreeListState::new();
        assert_eq!(state.visible_rows(&WideModel).len(), 1);
        assert!(state.visible_row(1).is_none());
    }

    #[test]
    fn wide_preorder_traversal_keeps_pending_work_bounded_by_depth() {
        struct MillionChildren;
        impl TreeModel<usize> for MillionChildren {
            fn roots_len(&self) -> usize {
                0
            }
            fn root_at(&self, _: usize) -> Option<usize> {
                None
            }
            fn child_count(&self, parent: &usize) -> usize {
                if *parent == 0 { 1_000_000 } else { 0 }
            }
            fn child_at(&self, parent: &usize, index: usize) -> Option<usize> {
                (*parent == 0 && index < 1_000_000).then_some(index + 1)
            }
            fn parent(&self, id: &usize) -> Option<usize> {
                (*id > 0 && *id <= 1_000_000).then_some(0)
            }
            fn contains(&self, id: &usize) -> bool {
                *id == 0 || (1..=1_000_000).contains(id)
            }
        }
        let expanded = HashSet::from([0]);
        let mut rows = VisibleTraversal::from_children(
            &MillionChildren,
            &expanded,
            Some(0),
            1,
            HashSet::new(),
            None,
        );
        assert_eq!(
            rows.frames.len(),
            1,
            "one cursor represents the whole sibling list"
        );
        assert_eq!(rows.next().map(|row| row.id), Some(1));
        assert_eq!(rows.frames.len(), 1);
        assert_eq!(rows.next().map(|row| row.id), Some(2));
        assert_eq!(rows.frames.len(), 1);
    }

    #[test]
    fn cached_row_access_avoids_model_calls_and_collapsed_branch_refresh_is_local() {
        struct CountingModel {
            roots: Vec<usize>,
            children: HashMap<usize, Vec<usize>>,
            calls: Cell<usize>,
            child_calls: Cell<usize>,
        }
        impl TreeModel<usize> for CountingModel {
            fn roots_len(&self) -> usize {
                self.calls.set(self.calls.get() + 1);
                self.roots.len()
            }
            fn root_at(&self, index: usize) -> Option<usize> {
                self.calls.set(self.calls.get() + 1);
                self.roots.get(index).copied()
            }
            fn child_count(&self, parent: &usize) -> usize {
                self.calls.set(self.calls.get() + 1);
                self.child_calls.set(self.child_calls.get() + 1);
                self.children.get(parent).map_or(0, Vec::len)
            }
            fn child_at(&self, parent: &usize, index: usize) -> Option<usize> {
                self.calls.set(self.calls.get() + 1);
                self.child_calls.set(self.child_calls.get() + 1);
                self.children
                    .get(parent)
                    .and_then(|children| children.get(index))
                    .copied()
            }
            fn parent(&self, _: &usize) -> Option<usize> {
                self.calls.set(self.calls.get() + 1);
                None
            }
            fn contains(&self, id: &usize) -> bool {
                self.calls.set(self.calls.get() + 1);
                self.roots.contains(id)
                    || self.children.values().any(|children| children.contains(id))
            }
        }
        let model = CountingModel {
            roots: vec![1, 2],
            children: HashMap::from([(1, vec![3]), (2, vec![4])]),
            calls: Cell::new(0),
            child_calls: Cell::new(0),
        };
        let mut state = TreeListState::new();
        assert_eq!(state.visible_rows(&model).len(), 2);
        model.calls.set(0);
        model.child_calls.set(0);
        assert_eq!(state.visible_row(1).map(|row| row.id), Some(2));
        assert_eq!(state.visible_rows_cached().len(), 2);
        assert_eq!(state.visible_index(&1), Some(0));
        assert_eq!(model.calls.get(), 0);

        state.refresh(&model, TreeChange::ChildrenChanged { parent: Some(1) });
        assert_eq!(
            model.child_calls.get(),
            0,
            "collapsed branch should not inspect its children"
        );
        assert_eq!(
            model.calls.get(),
            1,
            "only membership of the changed branch is checked"
        );
    }

    #[test]
    fn precise_insert_does_not_read_a_million_row_unaffected_branch() {
        struct WideModel {
            child_reads: Cell<usize>,
            unaffected_branch_reads: Cell<usize>,
            inserted: Cell<bool>,
        }
        impl TreeModel<usize> for WideModel {
            fn roots_len(&self) -> usize {
                2
            }
            fn root_at(&self, index: usize) -> Option<usize> {
                [10, 20].get(index).copied()
            }
            fn child_count(&self, parent: &usize) -> usize {
                match parent {
                    10 => {
                        if self.inserted.get() {
                            2
                        } else {
                            1
                        }
                    }
                    20 => 1_000_000,
                    _ => 0,
                }
            }
            fn child_at(&self, parent: &usize, index: usize) -> Option<usize> {
                self.child_reads.set(self.child_reads.get() + 1);
                if *parent == 20 {
                    self.unaffected_branch_reads
                        .set(self.unaffected_branch_reads.get() + 1);
                }
                match parent {
                    10 => [11, 12]
                        .get(index)
                        .copied()
                        .filter(|id| *id != 12 || self.inserted.get()),
                    20 if index < 1_000_000 => Some(100 + index),
                    _ => None,
                }
            }
            fn parent(&self, id: &usize) -> Option<usize> {
                if *id == 11 || *id == 12 {
                    Some(10)
                } else if (100..1_000_100).contains(id) {
                    Some(20)
                } else {
                    None
                }
            }
            fn contains(&self, id: &usize) -> bool {
                *id == 10
                    || *id == 20
                    || *id == 11
                    || (*id == 12 && self.inserted.get())
                    || (100..1_000_100).contains(id)
            }
        }
        let model = WideModel {
            child_reads: Cell::new(0),
            unaffected_branch_reads: Cell::new(0),
            inserted: Cell::new(false),
        };
        let mut state = TreeListState::new();
        state.visible_rows(&model);
        state.set_expanded(&model, 10, true);
        assert_eq!(state.visible_len(), 3);
        model.inserted.set(true);
        model.child_reads.set(0);
        model.unaffected_branch_reads.set(0);

        state.refresh(
            &model,
            TreeChange::ChildInserted {
                parent: Some(10),
                index: 1,
                inserted: 12,
            },
        );

        assert!(
            model.child_reads.get() <= 4,
            "precise insertion should do bounded local reads"
        );
        assert_eq!(
            model.unaffected_branch_reads.get(),
            0,
            "the million-child sibling branch must not be read"
        );
        assert_eq!(state.visible_index(&12), Some(2));
        assert_eq!(state.visible_index(&20), Some(3));
    }

    #[test]
    fn precise_insert_remove_and_move_keep_preorder_indices_and_splices() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        model.add(3, Some(1));
        model.add(4, Some(2));
        model.add(5, Some(3));
        let mut state = TreeListState::new();
        state.expanded.extend([1, 2, 3, 4]);
        assert_eq!(
            state
                .visible_rows(&model)
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2, 4, 3, 5]
        );

        model.nodes.get_mut(&1).unwrap().1.remove(0);
        model.nodes.remove(&2);
        model.nodes.remove(&4);
        state.refresh(
            &model,
            TreeChange::ChildRemoved {
                parent: Some(1),
                index: 0,
                // The payload is incomplete; the cached subtree range must
                // still remove every visible descendant from the identity map.
                removed: vec![2],
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 3, 5]
        );
        assert_eq!(state.visible_index(&5), Some(2));
        assert_eq!(state.visible_index(&4), None);
        assert!(!state.is_expanded(&4));
        assert_eq!(
            state.take_projection_changes(),
            [ProjectionSplice {
                old_range: 1..3,
                inserted_count: 0,
                new_len: 3,
            }]
        );

        model.add(6, Some(1));
        model.add(7, Some(6));
        state.expanded.insert(6);
        state.refresh(
            &model,
            TreeChange::ChildInserted {
                parent: Some(1),
                index: 1,
                inserted: 6,
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 3, 5, 6, 7]
        );
        assert_eq!(state.visible_row(3).unwrap().index_in_parent, 1);
        assert_eq!(
            state.take_projection_changes(),
            [ProjectionSplice {
                old_range: 3..3,
                inserted_count: 2,
                new_len: 5,
            }]
        );

        // Move 3 after 6. The destination index is its final sibling index.
        let siblings = &mut model.nodes.get_mut(&1).unwrap().1;
        siblings.swap(0, 1);
        state.refresh(
            &model,
            TreeChange::ChildMoved {
                from_parent: Some(1),
                from_index: 0,
                to_parent: Some(1),
                to_index: 1,
                moved: vec![3, 5],
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 6, 7, 3, 5]
        );
        assert_eq!(state.visible_row(3).unwrap().index_in_parent, 1);
        assert_eq!(state.visible_row(4).unwrap().parent, Some(3));
        let changes = state.take_projection_changes();
        assert_eq!(
            changes,
            [ProjectionSplice {
                old_range: 1..5,
                inserted_count: 4,
                new_len: 5,
            }]
        );
    }

    #[test]
    fn stale_precise_notifications_fall_back_without_corrupting_rows() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        let mut state = TreeListState::new();
        state.expanded.insert(1);
        assert_eq!(
            state
                .visible_rows(&model)
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2]
        );

        // The model does not contain the purported insertion. Rebuilding from
        // the model leaves the cached projection unchanged.
        state.refresh(
            &model,
            TreeChange::ChildInserted {
                parent: Some(1),
                index: 1,
                inserted: 99,
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2]
        );

        // The destination is valid, but the cached source index is stale.
        // A rebuild must avoid duplicating the moved row.
        state.refresh(
            &model,
            TreeChange::ChildMoved {
                from_parent: Some(1),
                from_index: 1,
                to_parent: Some(1),
                to_index: 0,
                moved: vec![2],
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2]
        );
        assert_eq!(state.visible_index(&2), Some(1));

        // A stale removal is rejected because its ID still exists in the model.
        state.refresh(
            &model,
            TreeChange::ChildRemoved {
                parent: Some(1),
                index: 0,
                removed: vec![2],
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2]
        );
        assert_eq!(state.visible_index(&2), Some(1));
    }

    #[test]
    fn malformed_cycles_and_duplicate_edges_terminate_without_duplicate_rows() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        model.nodes.get_mut(&2).unwrap().1.push(1);
        let mut state = TreeListState::new();
        state.expanded.extend([1, 2]);
        assert_eq!(
            state
                .visible_rows(&model)
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2]
        );
        state.refresh_branch(&model, &1);
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1, 2]
        );
    }

    #[test]
    fn branch_refresh_and_removal_keep_projection_and_selection_coherent() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        model.add(3, Some(1));
        model.add(4, None);
        let mut state = TreeListState::new();
        state.set_expanded(&model, 1, true);
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|r| r.id)
                .collect::<Vec<_>>(),
            [1, 2, 3, 4]
        );
        model.nodes.get_mut(&1).unwrap().1.remove(0);
        model.nodes.remove(&2);
        state.refresh(
            &model,
            TreeChange::NodesRemoved {
                parent: Some(1),
                removed: vec![2],
            },
        );
        assert_eq!(
            state
                .visible_rows_cached()
                .iter()
                .map(|r| r.id)
                .collect::<Vec<_>>(),
            [1, 3, 4]
        );
        let mut selection = SelectionState::new();
        selection.select_only(2);
        selection.refresh(
            &model,
            &TreeChange::NodesRemoved {
                parent: Some(1),
                removed: vec![2],
            },
        );
        assert!(selection.selected_ids().is_empty());
    }

    #[test]
    fn branch_edits_emit_direct_virtual_list_splices() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        model.add(3, Some(1));
        model.add(4, None);
        let mut state = TreeListState::new();
        assert_eq!(state.visible_rows(&model).len(), 2);
        assert!(state.take_projection_changes().is_empty());

        assert!(state.set_expanded(&model, 1, true));
        let expanded = state.take_projection_changes();
        assert_eq!(expanded.len(), 1);
        assert_eq!(expanded[0].old_range, 1..1);
        assert_eq!(expanded[0].inserted_count, 2);
        assert_eq!(expanded[0].new_len, 4);

        assert!(state.set_expanded(&model, 1, false));
        let collapsed = state.take_projection_changes();
        assert_eq!(collapsed[0].old_range, 1..3);
        assert_eq!(collapsed[0].inserted_count, 0);
        assert_eq!(collapsed[0].new_len, 2);
    }

    #[test]
    fn structural_notifications_prune_unlisted_removed_descendants() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        let mut state = TreeListState::new();
        state.expanded.extend([1, 2]);
        state.visible_rows(&model);
        let mut selection = SelectionState::new();
        selection.select_only(2);
        model.nodes.remove(&1);
        model.nodes.remove(&2);
        model.roots.clear();
        let change = TreeChange::NodesRemoved {
            parent: None,
            removed: vec![1],
        };
        state.refresh(&model, change.clone());
        selection.refresh(&model, &change);
        assert!(state.expanded_ids().is_empty());
        assert!(selection.selected_ids().is_empty());
        assert!(selection.focused().is_none());
    }

    #[test]
    fn reset_clears_identity_state_even_when_ids_are_reused() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        let mut tree = TreeListState::new();
        tree.set_expanded(&model, 1, true);
        let mut selection = SelectionState::new();
        selection.select_only(2);
        selection.set_focused(Some(1));
        selection.set_anchor(Some(2));

        let reset = TreeChange::Reset;
        tree.refresh(&model, reset.clone());
        selection.refresh(&model, &reset);

        assert!(tree.expanded_ids().is_empty());
        assert_eq!(
            tree.visible_rows_cached()
                .iter()
                .map(|row| row.id)
                .collect::<Vec<_>>(),
            [1]
        );
        assert!(selection.selected_ids().is_empty());
        assert!(selection.selected_ordered().is_empty());
        assert!(selection.focused().is_none());
        assert!(selection.anchor().is_none());
    }

    #[test]
    fn hidden_anchor_and_hidden_selection_survive_collapse() {
        let mut selection = SelectionState::new();
        selection.select_only(2usize);
        let visible = [1, 3, 4];
        selection.extend_to(&visible, 4, false);
        assert!(selection.is_selected(&2));
        assert!(selection.is_selected(&4));
        assert_eq!(selection.selected_ordered(), &[2, 4]);
        assert_eq!(selection.focused(), Some(&4));
        let ids = [10, 11, 12];
        selection.move_focus(&ids, 1);
        assert_eq!(selection.focused(), Some(&10));
        selection.move_focus(&ids, isize::MAX);
        assert_eq!(selection.focused(), Some(&12));
    }

    #[test]
    fn plain_selection_replaces_ordered_ids_without_stale_or_duplicate_entries() {
        let mut selection = SelectionState::new();
        selection.select_only('A');
        selection.select_only('B');
        selection.select_only('B');
        assert_eq!(selection.selected_ids(), &HashSet::from(['B']));
        assert_eq!(selection.selected_ordered(), &['B'][..]);
    }

    #[test]
    fn drag_roots_drop_placements_and_cycle_rejection() {
        let mut model = Model::default();
        model.add(1, None);
        model.add(2, Some(1));
        model.add(3, Some(2));
        model.add(4, None);
        assert_eq!(reduce_drag_roots(&model, &[1, 2, 4]), [1, 4]);
        assert_eq!(
            resolve_drop(&model, &[4], DropTarget::Before(1)),
            Some(super::super::drag::DropPosition {
                parent: None,
                index: 0
            })
        );
        assert!(resolve_drop(&model, &[4], DropTarget::Before(4)).is_none());
        assert!(resolve_drop(&model, &[1], DropTarget::Inside(3)).is_none());
        assert_eq!(
            resolve_drop(&model, &[4], DropTarget::Inside(1))
                .unwrap()
                .index,
            1
        );
        let position = resolve_drop(&model, &[1], DropTarget::After(4)).unwrap();
        assert_eq!(position.index, 2);
        assert_eq!(position.index_after_removing(&model, &[1]), 1);
    }

    #[test]
    fn autoscroll_is_signed_clamped_and_zero_in_center() {
        assert_eq!(autoscroll_velocity(50.0, 0.0, 100.0, 20.0, 500.0), 0.0);
        assert_eq!(autoscroll_velocity(0.0, 0.0, 100.0, 20.0, 500.0), -500.0);
        assert_eq!(autoscroll_velocity(100.0, 0.0, 100.0, 20.0, 500.0), 500.0);
    }
}
