//! Data access for tree-list views. The view owns labels and row rendering;
//! this trait only describes stable identity and tree structure.

use std::fmt::Debug;
use std::hash::Hash;
use std::ops::Range;

/// Read-only indexed access to a tree with stable node identifiers.
///
/// Implementations should make child lookup inexpensive. Identifiers need not
/// encode position and may be shared with an application's own model. IDs must
/// remain stable under `Eq`/`Hash` for their lifetime. The structure must be a
/// true tree: each ID appears once, roots have no parent, child/parent queries
/// agree, and parent chains terminate. Projection traversal defensively skips
/// repeated IDs and cycles, but malformed models make placement ambiguous.
pub trait TreeModel<Id: Clone + Eq + Hash + Debug + 'static> {
    fn roots_len(&self) -> usize;
    fn root_at(&self, index: usize) -> Option<Id>;
    fn child_count(&self, parent: &Id) -> usize;
    /// Whether this node can contain children. Override when branch identity
    /// is independent of the current child count (for example, lazy trees).
    fn is_branch(&self, id: &Id) -> bool {
        self.child_count(id) > 0
    }
    fn child_at(&self, parent: &Id, index: usize) -> Option<Id>;
    fn parent(&self, id: &Id) -> Option<Id>;
    fn contains(&self, id: &Id) -> bool;

    /// Return a direct child index. Override this for O(1) drag targeting when
    /// the model stores reverse indexes; the default scans siblings.
    fn index_of_child(&self, parent: &Id, child: &Id) -> Option<usize> {
        (0..self.child_count(parent)).find(|&i| self.child_at(parent, i).as_ref() == Some(child))
    }

    /// Return a root index. Override this for O(1) root drag targeting.
    fn root_index(&self, root: &Id) -> Option<usize> {
        (0..self.roots_len()).find(|&i| self.root_at(i).as_ref() == Some(root))
    }
}

/// A structural change that can be applied to the cached visible projection.
/// `parent: None` refers to the root list. Send `ChildrenChanged` after the
/// model has been mutated. Structural notifications prune IDs no longer in
/// the model, including descendants omitted from `NodesRemoved.removed`.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum TreeChange<Id> {
    /// One child was inserted at `index` in the already-updated sibling list.
    ChildInserted {
        parent: Option<Id>,
        index: usize,
        inserted: Id,
    },
    /// One child was removed at `index`; `removed` lists the removed subtree
    /// IDs in preorder, with the removed child first. It is captured before
    /// mutating the model so hidden descendants can also be pruned from state.
    ChildRemoved {
        parent: Option<Id>,
        index: usize,
        removed: Vec<Id>,
    },
    /// Move one subtree. `to_index` is its final index in the destination list
    /// after the model has been updated. `moved` contains the subtree IDs in
    /// preorder, with the moved root first.
    ChildMoved {
        from_parent: Option<Id>,
        from_index: usize,
        to_parent: Option<Id>,
        to_index: usize,
        moved: Vec<Id>,
    },
    ChildrenChanged {
        parent: Option<Id>,
    },
    NodesRemoved {
        parent: Option<Id>,
        removed: Vec<Id>,
    },
    /// Sibling reorder, reparent, or cross-parent move. Applied as one atomic
    /// projection rebuild so a moved ID cannot appear twice in the row index.
    NodesMoved {
        from_parent: Option<Id>,
        to_parent: Option<Id>,
        moved: Vec<Id>,
    },
    /// Node content changed without changing tree structure.
    DataChanged {
        id: Id,
    },
    /// The logical model was replaced. Clears expansion, selection, focus, and
    /// range anchor even when the new model reuses the same IDs. For unknown
    /// structural changes within the same logical model, call
    /// `TreeListState::rebuild_projection` to preserve expansion state.
    Reset,
}

/// One currently visible row in preorder.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct VisibleNode<Id> {
    pub id: Id,
    pub depth: usize,
    pub parent: Option<Id>,
    pub index_in_parent: usize,
}

/// Incremental edit to the visible preorder projection. `old_range` indexes
/// the projection immediately before this change, and `inserted_count` is the
/// number of rows replacing it. Apply queued edits in order to preserve scroll
/// anchoring in virtualized-list implementations.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ProjectionSplice {
    pub old_range: Range<usize>,
    pub inserted_count: usize,
    pub new_len: usize,
}
