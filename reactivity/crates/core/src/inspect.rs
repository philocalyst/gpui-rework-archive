//! Inspection consumes production accessors, never an independent mirror tree.
use crate::{NodeId, NodeKind, Tree, TreeError};

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct NodeInfo {
    pub id: NodeId,
    pub parent: Option<NodeId>,
    pub kind: NodeKind,
    pub child_count: usize,
}

pub fn node(tree: &Tree, id: NodeId) -> Result<NodeInfo, TreeError> {
    Ok(NodeInfo {
        id,
        parent: tree.parent(id)?,
        kind: tree.kind(id)?,
        child_count: tree.children(Some(id))?.count(),
    })
}

pub fn nodes(tree: &Tree) -> impl Iterator<Item = NodeInfo> + '_ {
    tree.preorder()
        .map(|id| node(tree, id).expect("preorder yields live nodes"))
}
