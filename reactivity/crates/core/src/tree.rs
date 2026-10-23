use std::sync::atomic::{AtomicU64, Ordering};

const NIL: u32 = u32::MAX;
static NEXT_ARENA: AtomicU64 = AtomicU64::new(1);

/// Arena identity is part of equality; ids from different trees never alias.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Hash, Ord, PartialOrd)]
pub struct NodeId {
    arena: u64,
    generation: u32,
    index: u32,
}

/// Embedding sites declare ownership boundaries, without implementing platform hosting.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum NodeKind {
    Element,
    Native,
    WebView,
    NestedGpui,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum TreeError {
    InvalidNode,
    Cycle,
    Capacity,
    InvalidGeometry,
}

// Dead entries reuse `next` as a free-list link. Exhausted generations are retired.
struct Entry {
    generation: u32,
    parent: u32,
    first: u32,
    last: u32,
    prev: u32,
    next: u32,
    kind: Option<NodeKind>,
}

/// Editable topology, independent of spatial and rendering data.
///
/// Insertion/link edits are O(1); cycle validation is O(ancestor depth); removal
/// is O(removed nodes), uses no recursion or temporary node queue. Dropping a
/// million-node chain also drops a flat Vec, never a recursive ownership chain.
pub struct Tree {
    arena: u64,
    entries: Vec<Entry>,
    free: u32,
    first: u32,
    last: u32,
    len: usize,
}

impl Default for Tree {
    fn default() -> Self {
        Self::new()
    }
}

impl Tree {
    pub fn new() -> Self {
        let arena = NEXT_ARENA
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |n| n.checked_add(1))
            .expect("tree arena identity exhausted");
        Self {
            arena,
            entries: Vec::new(),
            free: NIL,
            first: NIL,
            last: NIL,
            len: 0,
        }
    }
    pub fn len(&self) -> usize {
        self.len
    }
    pub fn is_empty(&self) -> bool {
        self.len == 0
    }
    pub fn contains(&self, id: NodeId) -> bool {
        self.index(id).is_ok()
    }
    pub fn kind(&self, id: NodeId) -> Result<NodeKind, TreeError> {
        Ok(self.entries[self.index(id)? as usize].kind.unwrap())
    }
    pub fn parent(&self, id: NodeId) -> Result<Option<NodeId>, TreeError> {
        Ok(self.id_opt(self.entries[self.index(id)? as usize].parent))
    }
    pub fn next_sibling(&self, id: NodeId) -> Result<Option<NodeId>, TreeError> {
        Ok(self.id_opt(self.entries[self.index(id)? as usize].next))
    }
    pub fn children(&self, parent: Option<NodeId>) -> Result<Children<'_>, TreeError> {
        let next = match parent {
            Some(id) => self.entries[self.index(id)? as usize].first,
            None => self.first,
        };
        Ok(Children { tree: self, next })
    }
    /// Whole forest in stable parent-before-child paint order.
    pub fn preorder(&self) -> Preorder<'_> {
        Preorder {
            tree: self,
            next: self.first,
            root: NIL,
        }
    }
    pub fn subtree(&self, root: NodeId) -> Result<Preorder<'_>, TreeError> {
        Ok(Preorder {
            tree: self,
            next: self.index(root)?,
            root: self.index(root)?,
        })
    }
    pub fn insert(&mut self, parent: Option<NodeId>, kind: NodeKind) -> Result<NodeId, TreeError> {
        let parent = self.optional_index(parent)?;
        let index;
        let generation;
        if self.free != NIL {
            index = self.free;
            self.free = self.entries[index as usize].next;
            generation = self.entries[index as usize].generation;
        } else {
            index = u32::try_from(self.entries.len()).map_err(|_| TreeError::Capacity)?;
            if index == NIL {
                return Err(TreeError::Capacity);
            }
            generation = 1;
            self.entries.push(Entry {
                generation,
                parent: NIL,
                first: NIL,
                last: NIL,
                prev: NIL,
                next: NIL,
                kind: None,
            });
        }
        self.entries[index as usize] = Entry {
            generation,
            parent: NIL,
            first: NIL,
            last: NIL,
            prev: NIL,
            next: NIL,
            kind: Some(kind),
        };
        self.attach(index, parent);
        self.len += 1;
        Ok(self.id(index))
    }
    /// Move to the end of a parent's children (or the forest roots).
    /// Every error is detected before any links change.
    pub fn reparent(&mut self, node: NodeId, parent: Option<NodeId>) -> Result<(), TreeError> {
        self.validate_reparent(node, parent)?;
        let index = self.index(node)?;
        let parent = self.optional_index(parent)?;
        if self.entries[index as usize].parent == parent && self.entries[index as usize].next == NIL
        {
            return Ok(());
        }
        self.detach(index);
        self.attach(index, parent);
        Ok(())
    }
    pub(crate) fn validate_reparent(
        &self,
        node: NodeId,
        parent: Option<NodeId>,
    ) -> Result<(), TreeError> {
        let index = self.index(node)?;
        let mut ancestor = self.optional_index(parent)?;
        while ancestor != NIL {
            if ancestor == index {
                return Err(TreeError::Cycle);
            }
            ancestor = self.entries[ancestor as usize].parent;
        }
        Ok(())
    }
    pub fn remove(&mut self, node: NodeId) -> Result<usize, TreeError> {
        let root = self.index(node)?;
        self.detach(root);
        let mut current = root;
        let mut removed = 0;
        // Delete leaves then ascend. A surviving parent's first link is advanced
        // before the child's storage can become free-list metadata.
        loop {
            let child = self.entries[current as usize].first;
            if child != NIL {
                current = child;
                continue;
            }
            let parent = self.entries[current as usize].parent;
            let next = self.entries[current as usize].next;
            if current != root {
                self.entries[parent as usize].first = next;
            }
            let entry = &mut self.entries[current as usize];
            entry.kind = None;
            if let Some(generation) = entry.generation.checked_add(1) {
                entry.generation = generation;
                entry.next = self.free;
                self.free = current;
            }
            removed += 1;
            if current == root {
                break;
            }
            current = if next == NIL { parent } else { next };
        }
        self.len -= removed;
        Ok(removed)
    }
    /// Allocated topology payload, excluding allocator bookkeeping and Tree header.
    pub fn allocated_bytes(&self) -> usize {
        self.entries.capacity() * std::mem::size_of::<Entry>()
    }
    pub fn entry_bytes() -> usize {
        std::mem::size_of::<Entry>()
    }
    pub(crate) fn slot_count(&self) -> usize {
        self.entries.len()
    }
    pub(crate) fn index(&self, id: NodeId) -> Result<u32, TreeError> {
        if id.arena != self.arena {
            return Err(TreeError::InvalidNode);
        }
        match self.entries.get(id.index as usize) {
            Some(e) if e.kind.is_some() && e.generation == id.generation => Ok(id.index),
            _ => Err(TreeError::InvalidNode),
        }
    }
    pub(crate) fn slot(&self, id: NodeId) -> usize {
        id.index as usize
    }
    #[cfg(feature = "layout")]
    pub(crate) fn layout_key(&self, id: NodeId) -> u64 {
        (u64::from(id.generation) << 32) | u64::from(id.index)
    }
    #[cfg(feature = "layout")]
    pub(crate) fn node_for_layout_key(&self, key: u64) -> NodeId {
        let id = NodeId {
            arena: self.arena,
            generation: (key >> 32) as u32,
            index: key as u32,
        };
        assert!(
            self.contains(id),
            "layout engine ids name live nodes in this tree"
        );
        id
    }
    fn optional_index(&self, id: Option<NodeId>) -> Result<u32, TreeError> {
        id.map_or(Ok(NIL), |id| self.index(id))
    }
    fn id(&self, index: u32) -> NodeId {
        NodeId {
            arena: self.arena,
            generation: self.entries[index as usize].generation,
            index,
        }
    }
    fn id_opt(&self, index: u32) -> Option<NodeId> {
        (index != NIL).then(|| self.id(index))
    }
    fn detach(&mut self, index: u32) {
        let e = &self.entries[index as usize];
        let (parent, prev, next) = (e.parent, e.prev, e.next);
        if prev != NIL {
            self.entries[prev as usize].next = next;
        } else if parent == NIL {
            self.first = next;
        } else {
            self.entries[parent as usize].first = next;
        }
        if next != NIL {
            self.entries[next as usize].prev = prev;
        } else if parent == NIL {
            self.last = prev;
        } else {
            self.entries[parent as usize].last = prev;
        }
        self.entries[index as usize].parent = NIL;
        self.entries[index as usize].prev = NIL;
        self.entries[index as usize].next = NIL;
    }
    fn attach(&mut self, index: u32, parent: u32) {
        let last = if parent == NIL {
            self.last
        } else {
            self.entries[parent as usize].last
        };
        if last != NIL {
            self.entries[last as usize].next = index;
        } else if parent == NIL {
            self.first = index;
        } else {
            self.entries[parent as usize].first = index;
        }
        if parent == NIL {
            self.last = index;
        } else {
            self.entries[parent as usize].last = index;
        }
        let e = &mut self.entries[index as usize];
        e.parent = parent;
        e.prev = last;
    }
}

pub struct Children<'a> {
    tree: &'a Tree,
    next: u32,
}
impl Iterator for Children<'_> {
    type Item = NodeId;
    fn next(&mut self) -> Option<NodeId> {
        let index = self.next;
        if index == NIL {
            return None;
        }
        self.next = self.tree.entries[index as usize].next;
        Some(self.tree.id(index))
    }
}

pub struct Preorder<'a> {
    tree: &'a Tree,
    next: u32,
    root: u32,
}
impl Preorder<'_> {
    // Called only for the node most recently yielded by this iterator. The tree
    // stays immutably borrowed, so its links and generation cannot change.
    pub(crate) fn skip_descendants(&mut self, node: NodeId) {
        let mut current = self.tree.slot(node) as u32;
        loop {
            if current == self.root {
                self.next = NIL;
                return;
            }
            let entry = &self.tree.entries[current as usize];
            if entry.next != NIL {
                self.next = entry.next;
                return;
            }
            if entry.parent == NIL {
                self.next = NIL;
                return;
            }
            current = entry.parent;
        }
    }
}
impl Iterator for Preorder<'_> {
    type Item = NodeId;
    fn next(&mut self) -> Option<NodeId> {
        let index = self.next;
        if index == NIL {
            return None;
        }
        let mut current = index;
        let first = self.tree.entries[current as usize].first;
        if first != NIL {
            self.next = first;
        } else {
            loop {
                if current == self.root {
                    self.next = NIL;
                    break;
                }
                let e = &self.tree.entries[current as usize];
                if e.next != NIL {
                    self.next = e.next;
                    break;
                }
                if e.parent == NIL {
                    self.next = NIL;
                    break;
                }
                current = e.parent;
            }
        }
        Some(self.tree.id(index))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exhausted_generation_retires_slot_without_aba() {
        let mut tree = Tree::new();
        let node = tree.insert(None, NodeKind::Element).unwrap();
        tree.entries[node.index as usize].generation = u32::MAX;
        let terminal = tree.id(node.index);
        tree.remove(terminal).unwrap();
        let fresh = tree.insert(None, NodeKind::Element).unwrap();
        assert_ne!(fresh.index, terminal.index);
        assert!(!tree.contains(terminal));
    }
}
