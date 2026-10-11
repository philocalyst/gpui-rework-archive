use std::{fmt::Debug, hash::Hash};

use super::{
    DropPosition, DropTarget, TreeModel, autoscroll_velocity, reduce_drag_roots, resolve_drop,
};

/// Payload shared only by rows belonging to the same tree instance and model
/// generation. The instance token prevents an identical ID from another tree
/// from being accepted accidentally.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TreeDragPayload<Id> {
    pub tree_identity: u64,
    pub model_identity: usize,
    pub model_revision: u64,
    pub roots: Vec<Id>,
}

impl<Id> TreeDragPayload<Id> {
    pub fn belongs_to(
        &self,
        tree_identity: u64,
        model_identity: usize,
        model_revision: u64,
    ) -> bool {
        self.tree_identity == tree_identity
            && self.model_identity == model_identity
            && self.model_revision == model_revision
    }
}

/// A validated, currently displayed drop placement.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct TreeDropPreview<Id> {
    pub target: DropTarget<Id>,
    pub position: DropPosition<Id>,
}

/// Drag-only state. Pointer and viewport coordinates are in logical pixels.
#[derive(Clone, Debug)]
pub(super) struct TreeDndState<Id> {
    pub payload: Option<TreeDragPayload<Id>>,
    pub preview: Option<TreeDropPreview<Id>>,
    pub pointer_y: Option<f32>,
    pub viewport_top: f32,
    pub viewport_height: f32,
    pub hover_target: Option<Id>,
    pub hover_started_at: Option<web_time::Instant>,
    pub error: Option<gpui::SharedString>,
    pub session_generation: u64,
    pub timer_scheduled: bool,
}

impl<Id> Default for TreeDndState<Id> {
    fn default() -> Self {
        Self {
            payload: None,
            preview: None,
            pointer_y: None,
            viewport_top: 0.0,
            viewport_height: 0.0,
            hover_target: None,
            hover_started_at: None,
            error: None,
            session_generation: 0,
            timer_scheduled: false,
        }
    }
}

impl<Id: Clone> TreeDndState<Id> {
    pub fn begin(&mut self, payload: TreeDragPayload<Id>) {
        let session_generation = self.session_generation.wrapping_add(1);
        *self = Self {
            payload: Some(payload),
            session_generation,
            ..Self::default()
        };
    }

    pub fn clear(&mut self) {
        let session_generation = self.session_generation.wrapping_add(1);
        *self = Self::default();
        self.session_generation = session_generation;
    }

    /// End a drag while retaining a rejection/commit error for display.
    pub fn finish(&mut self) {
        let error = self.error.take();
        self.clear();
        self.error = error;
    }

    /// Let a timer relinquish its scheduled flag only if it still owns the
    /// current drag session. A stale task must not stop its replacement.
    pub fn finish_timer(&mut self, generation: u64) -> bool {
        if self.session_generation != generation {
            return false;
        }
        self.timer_scheduled = false;
        true
    }
}

/// Select the drag roots in stable model preorder, retaining selected nodes
/// hidden under collapsed ancestors. If the pressed row is not selected, it is
/// the sole drag root.
pub fn drag_roots_in_preorder<Id, M>(model: &M, selection_order: &[Id], dragged: &Id) -> Vec<Id>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id>,
{
    if !model.contains(dragged) {
        return Vec::new();
    }
    if !selection_order.iter().any(|id| id == dragged) {
        return vec![dragged.clone()];
    }

    let roots = reduce_drag_roots(model, selection_order);
    if roots.len() < 2 {
        return roots;
    }
    let mut ordered: Vec<_> = roots
        .into_iter()
        .filter_map(|id| model_order_path(model, &id).map(|path| (path, id)))
        .collect();
    ordered.sort_by(|(a, _), (b, _)| a.cmp(b));
    ordered.into_iter().map(|(_, id)| id).collect()
}

fn model_order_path<Id, M>(model: &M, id: &Id) -> Option<Vec<usize>>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id>,
{
    let mut path = Vec::new();
    let mut current = id.clone();
    let mut visited = std::collections::HashSet::new();
    while let Some(parent) = model.parent(&current) {
        if !visited.insert(current.clone()) {
            return None;
        }
        path.push(model.index_of_child(&parent, &current)?);
        current = parent;
    }
    path.push(model.root_index(&current)?);
    path.reverse();
    Some(path)
}

/// Pick a row-relative target. The middle half of a row means append inside;
/// the upper/lower quarters insert before/after. Row geometry comes from
/// `ListState::bounds_for_item`, so this supports variable-height rows too.
pub fn target_for_row<Id: Clone>(
    id: Id,
    pointer_y: f32,
    top: f32,
    bottom: f32,
) -> Option<DropTarget<Id>> {
    if !pointer_y.is_finite() || !top.is_finite() || !bottom.is_finite() || bottom <= top {
        return None;
    }
    let fraction = ((pointer_y - top) / (bottom - top)).clamp(0.0, 1.0);
    Some(if fraction < 0.25 {
        DropTarget::Before(id)
    } else if fraction > 0.75 {
        DropTarget::After(id)
    } else {
        DropTarget::Inside(id)
    })
}

/// Resolve and validate a preview using the same placement logic used on drop.
/// This ensures invalid cycle targets never display an insertion marker.
pub fn validated_preview<Id, M>(
    model: &M,
    payload: &TreeDragPayload<Id>,
    target: DropTarget<Id>,
) -> Option<TreeDropPreview<Id>>
where
    Id: Clone + Eq + Hash + Debug + 'static,
    M: TreeModel<Id>,
{
    let roots = reduce_drag_roots(model, &payload.roots);
    let position = resolve_drop(model, &roots, target.clone())?;
    Some(TreeDropPreview { target, position })
}

pub fn autoscroll_velocity_for_pointer(
    pointer_y: f32,
    viewport_top: f32,
    viewport_height: f32,
) -> f32 {
    autoscroll_velocity(pointer_y, viewport_top, viewport_height, 36.0, 640.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[derive(Clone)]
    struct Node {
        parent: Option<usize>,
        children: Vec<usize>,
    }
    struct Model {
        roots: Vec<usize>,
        nodes: Vec<Node>,
    }

    impl Model {
        fn sample() -> Self {
            Self {
                roots: vec![0, 1, 2],
                nodes: vec![
                    Node {
                        parent: None,
                        children: vec![3],
                    },
                    Node {
                        parent: None,
                        children: vec![],
                    },
                    Node {
                        parent: None,
                        children: vec![],
                    },
                    Node {
                        parent: Some(0),
                        children: vec![4],
                    },
                    Node {
                        parent: Some(3),
                        children: vec![],
                    },
                ],
            }
        }
    }

    impl TreeModel<usize> for Model {
        fn roots_len(&self) -> usize {
            self.roots.len()
        }
        fn root_at(&self, i: usize) -> Option<usize> {
            self.roots.get(i).copied()
        }
        fn child_count(&self, id: &usize) -> usize {
            self.nodes[*id].children.len()
        }
        fn child_at(&self, id: &usize, i: usize) -> Option<usize> {
            self.nodes[*id].children.get(i).copied()
        }
        fn parent(&self, id: &usize) -> Option<usize> {
            self.nodes.get(*id)?.parent
        }
        fn contains(&self, id: &usize) -> bool {
            *id < self.nodes.len()
        }
    }

    #[test]
    fn selection_roots_follow_model_preorder_and_remove_hidden_descendants() {
        let model = Model::sample();
        // Deliberately reverse selection order; hidden descendants are still
        // collapsed-model descendants and are removed from the drag roots.
        assert_eq!(
            drag_roots_in_preorder(&model, &[4, 1, 0, 3], &4),
            vec![0, 1]
        );
    }

    #[test]
    fn dragging_one_selected_node_does_not_walk_unrelated_collapsed_subtrees() {
        use std::cell::Cell;
        struct WideModel {
            child_visits: Cell<usize>,
        }
        impl TreeModel<usize> for WideModel {
            fn roots_len(&self) -> usize {
                2
            }
            fn root_at(&self, i: usize) -> Option<usize> {
                (i < 2).then_some(i)
            }
            fn child_count(&self, id: &usize) -> usize {
                usize::from(*id == 0) * 1_000_000
            }
            fn child_at(&self, id: &usize, i: usize) -> Option<usize> {
                self.child_visits.set(self.child_visits.get() + 1);
                (*id == 0 && i < 1_000_000).then_some(i + 2)
            }
            fn parent(&self, id: &usize) -> Option<usize> {
                (*id >= 2).then_some(0)
            }
            fn contains(&self, id: &usize) -> bool {
                *id < 1_000_002
            }
        }
        let model = WideModel {
            child_visits: Cell::new(0),
        };
        assert_eq!(drag_roots_in_preorder(&model, &[1], &1), vec![1]);
        assert_eq!(model.child_visits.get(), 0);
    }

    #[test]
    fn target_zones_cover_before_inside_and_after() {
        assert_eq!(
            target_for_row(7, 2.0, 0.0, 20.0),
            Some(DropTarget::Before(7))
        );
        assert_eq!(
            target_for_row(7, 10.0, 0.0, 20.0),
            Some(DropTarget::Inside(7))
        );
        assert_eq!(
            target_for_row(7, 18.0, 0.0, 20.0),
            Some(DropTarget::After(7))
        );
    }

    #[test]
    fn preview_uses_drop_validation_and_rejects_cycles() {
        let model = Model::sample();
        let payload = TreeDragPayload {
            tree_identity: 1,
            model_identity: 1,
            model_revision: 0,
            roots: vec![0],
        };
        assert!(validated_preview(&model, &payload, DropTarget::Inside(3)).is_none());
        assert!(validated_preview(&model, &payload, DropTarget::After(1)).is_some());
    }

    #[test]
    fn root_end_index_is_adjusted_after_dragged_roots_are_removed() {
        let model = Model::sample();
        let position = resolve_drop(&model, &[0, 1, 2], DropTarget::RootEnd).unwrap();
        assert_eq!(position.parent, None);
        assert_eq!(position.index, 3);
        assert_eq!(position.index_after_removing(&model, &[0, 1, 2]), 0);
    }

    #[test]
    fn autoscroll_only_runs_in_edge_zones_and_is_bounded() {
        assert_eq!(autoscroll_velocity_for_pointer(100.0, 0.0, 200.0), 0.0);
        assert!(autoscroll_velocity_for_pointer(0.0, 0.0, 200.0) < 0.0);
        assert_eq!(autoscroll_velocity_for_pointer(200.0, 0.0, 200.0), 640.0);
        assert_eq!(autoscroll_velocity_for_pointer(f32::NAN, 0.0, 200.0), 0.0);
    }

    #[test]
    fn stale_drag_timer_cannot_clear_new_session_timer_flag() {
        let mut state = TreeDndState::default();
        state.begin(TreeDragPayload {
            tree_identity: 1,
            model_identity: 1,
            model_revision: 0,
            roots: vec![0],
        });
        let stale_generation = state.session_generation;
        state.clear();
        state.begin(TreeDragPayload {
            tree_identity: 1,
            model_identity: 1,
            model_revision: 0,
            roots: vec![1],
        });
        state.timer_scheduled = true;

        assert!(!state.finish_timer(stale_generation));
        assert!(state.timer_scheduled);
        assert!(state.finish_timer(state.session_generation));
        assert!(!state.timer_scheduled);
    }

    #[test]
    fn reset_revision_rejects_payload_even_when_tree_model_and_ids_are_reused() {
        let payload = TreeDragPayload {
            tree_identity: 8,
            model_identity: 21,
            model_revision: 4,
            roots: vec![2, 5],
        };
        assert!(payload.belongs_to(8, 21, 4));
        assert!(!payload.belongs_to(8, 21, 5));
    }
}
