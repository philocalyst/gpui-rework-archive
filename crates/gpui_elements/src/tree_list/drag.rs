use std::collections::HashSet;
use std::{fmt::Debug, hash::Hash};

use super::model::TreeModel;

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum DropTarget<Id> {
    Before(Id),
    Inside(Id),
    After(Id),
    /// Append at the root level, including drops into an empty tree.
    RootEnd,
}

/// A resolved insertion location in the model before moving any rows.
/// `index` is the target parent's child index before the drag is applied. A
/// consumer removing source rows first must subtract earlier moved siblings
/// from this index. Before/after the dragged row itself is treated as a no-op.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct DropPosition<Id> {
    pub parent: Option<Id>,
    pub index: usize,
}

impl<Id: Clone + Eq + Hash + Debug + 'static> DropPosition<Id> {
    /// Translate the pre-move index into the index to use after source rows
    /// have been removed. Source roots retain their input order for the caller.
    pub fn index_after_removing<M: TreeModel<Id>>(&self, model: &M, dragged: &[Id]) -> usize {
        let roots = reduce_drag_roots(model, dragged);
        let before = roots
            .iter()
            .filter(|id| model.parent(id) == self.parent)
            .filter(|id| {
                sibling_index(model, self.parent.as_ref(), id)
                    .is_some_and(|index| index < self.index)
            })
            .count();
        self.index.saturating_sub(before)
    }
}

/// Discard selected descendants when an ancestor is already selected. The
/// output keeps caller order and removes duplicate IDs.
pub fn reduce_drag_roots<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    model: &M,
    selected: &[Id],
) -> Vec<Id> {
    let selected_set: HashSet<_> = selected.iter().cloned().collect();
    let mut result = Vec::new();
    let mut emitted = HashSet::new();
    for id in selected {
        if !model.contains(id) || !emitted.insert(id.clone()) {
            continue;
        }
        let mut cursor = model.parent(id);
        let mut descendant = false;
        let mut visited = HashSet::new();
        while let Some(parent) = cursor {
            if !visited.insert(parent.clone()) {
                descendant = true;
                break;
            }
            if selected_set.contains(&parent) {
                descendant = true;
                break;
            }
            cursor = model.parent(&parent);
        }
        if !descendant {
            result.push(id.clone());
        }
    }
    result
}

/// Resolve before/inside/after placement, rejecting missing nodes and moves
/// that would put a node inside its own descendant.
pub fn resolve_drop<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    model: &M,
    dragged: &[Id],
    target: DropTarget<Id>,
) -> Option<DropPosition<Id>> {
    let roots = reduce_drag_roots(model, dragged);
    if roots.is_empty() {
        return None;
    }
    let position = match target {
        DropTarget::Before(id) => {
            if !model.contains(&id) {
                return None;
            }
            if roots.contains(&id) {
                return None;
            }
            let parent = model.parent(&id);
            let index = sibling_index(model, parent.as_ref(), &id)?;
            DropPosition { parent, index }
        }
        DropTarget::After(id) => {
            if !model.contains(&id) {
                return None;
            }
            if roots.contains(&id) {
                return None;
            }
            let parent = model.parent(&id);
            let index = sibling_index(model, parent.as_ref(), &id)?.checked_add(1)?;
            DropPosition { parent, index }
        }
        DropTarget::RootEnd => DropPosition {
            parent: None,
            index: model.roots_len(),
        },
        DropTarget::Inside(id) => {
            if !model.contains(&id) {
                return None;
            }
            DropPosition {
                index: model.child_count(&id),
                parent: Some(id),
            }
        }
    };
    if roots.iter().any(|root| {
        let mut cursor = position.parent.clone();
        let mut visited = HashSet::new();
        while let Some(id) = cursor {
            if &id == root {
                return true;
            }
            if !visited.insert(id.clone()) {
                return true;
            }
            cursor = model.parent(&id);
        }
        false
    }) {
        return None;
    }
    Some(position)
}

fn sibling_index<Id: Clone + Eq + Hash + Debug + 'static, M: TreeModel<Id>>(
    model: &M,
    parent: Option<&Id>,
    child: &Id,
) -> Option<usize> {
    parent.map_or_else(
        || model.root_index(child),
        |parent| model.index_of_child(parent, child),
    )
}

/// Signed scrolling speed for a pointer near a viewport edge, in logical
/// pixels per second. The center area returns zero and either edge accelerates
/// smoothly up to `max_speed`.
pub fn autoscroll_velocity(
    pointer_y: f32,
    viewport_top: f32,
    viewport_height: f32,
    edge_size: f32,
    max_speed: f32,
) -> f32 {
    if !pointer_y.is_finite()
        || !viewport_top.is_finite()
        || !viewport_height.is_finite()
        || !edge_size.is_finite()
        || !max_speed.is_finite()
        || viewport_height <= 0.0
        || edge_size <= 0.0
        || max_speed <= 0.0
    {
        return 0.0;
    }
    let edge = edge_size.min(viewport_height / 2.0);
    let y = pointer_y - viewport_top;
    if y < edge {
        -max_speed * ((edge - y) / edge).clamp(0.0, 1.0).powi(2)
    } else if y > viewport_height - edge {
        max_speed
            * ((y - (viewport_height - edge)) / edge)
                .clamp(0.0, 1.0)
                .powi(2)
    } else {
        0.0
    }
}
