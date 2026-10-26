use std::collections::BTreeMap;

use gpui_reactivity_core::{NodeId, NodeKind, Tree, TreeError};

#[derive(Clone)]
struct Entry {
    parent: Option<NodeId>,
    children: Vec<NodeId>,
}
#[derive(Default)]
struct Oracle {
    nodes: BTreeMap<NodeId, Entry>,
    roots: Vec<NodeId>,
}
impl Oracle {
    fn children(&self, parent: Option<NodeId>) -> &[NodeId] {
        match parent {
            Some(parent) => &self.nodes[&parent].children,
            None => &self.roots,
        }
    }
    fn children_mut(&mut self, parent: Option<NodeId>) -> &mut Vec<NodeId> {
        match parent {
            Some(parent) => &mut self.nodes.get_mut(&parent).unwrap().children,
            None => &mut self.roots,
        }
    }
    fn insert(&mut self, id: NodeId, parent: Option<NodeId>, before: Option<NodeId>) {
        self.nodes.insert(id, Entry { parent, children: Vec::new() });
        self.attach(id, parent, before);
    }
    fn attach(&mut self, id: NodeId, parent: Option<NodeId>, before: Option<NodeId>) {
        let children = self.children_mut(parent);
        let at = before.map_or(children.len(), |anchor| {
            children.iter().position(|child| *child == anchor).unwrap()
        });
        children.insert(at, id);
    }
    fn reparent(
        &mut self,
        id: NodeId,
        parent: Option<NodeId>,
        before: Option<NodeId>,
    ) -> Result<bool, TreeError> {
        if !self.nodes.contains_key(&id) || parent.is_some_and(|p| !self.nodes.contains_key(&p)) {
            return Err(TreeError::InvalidNode);
        }
        let mut ancestor = parent;
        while let Some(next) = ancestor {
            if next == id {
                return Err(TreeError::Cycle);
            }
            ancestor = self.nodes[&next].parent;
        }
        if before.is_some_and(|anchor| {
            self.nodes.get(&anchor).is_none_or(|entry| entry.parent != parent)
        }) {
            return Err(TreeError::InvalidNode);
        }
        let previous = self.nodes[&id].parent;
        let siblings = self.children(previous);
        let at = siblings.iter().position(|child| *child == id).unwrap();
        if previous == parent && (before == Some(id) || siblings.get(at + 1).copied() == before) {
            return Ok(false);
        }
        self.children_mut(previous).remove(at);
        self.nodes.get_mut(&id).unwrap().parent = parent;
        self.attach(id, parent, before);
        Ok(true)
    }
    fn remove(&mut self, id: NodeId) -> Vec<NodeId> {
        let parent = self.nodes[&id].parent;
        self.children_mut(parent).retain(|child| *child != id);
        let mut pending = vec![id];
        let mut removed = Vec::new();
        while let Some(id) = pending.pop() {
            pending.extend(self.nodes.remove(&id).unwrap().children);
            removed.push(id);
        }
        removed
    }
    fn preorder(&self) -> Vec<NodeId> {
        let mut pending: Vec<_> = self.roots.iter().rev().copied().collect();
        let mut result = Vec::new();
        while let Some(id) = pending.pop() {
            result.push(id);
            pending.extend(self.nodes[&id].children.iter().rev().copied());
        }
        result
    }
    fn check(&self, tree: &Tree) {
        assert_eq!(tree.len(), self.nodes.len());
        assert_eq!(tree.preorder().take(self.nodes.len() + 1).collect::<Vec<_>>(), self.preorder());
        for parent in std::iter::once(None).chain(self.nodes.keys().copied().map(Some)) {
            let expected = self.children(parent);
            assert_eq!(tree.children(parent).unwrap().take(self.nodes.len() + 1).collect::<Vec<_>>(), expected);
            for (index, id) in expected.iter().copied().enumerate() {
                assert!(tree.contains(id));
                assert_eq!(tree.parent(id).unwrap(), parent);
                assert_eq!(tree.next_sibling(id).unwrap(), expected.get(index + 1).copied());
            }
        }
    }
}
fn random(state: &mut u64) -> usize {
    *state ^= *state << 13;
    *state ^= *state >> 7;
    *state ^= *state << 17;
    *state as usize
}

#[test]
fn ordered_insert_move_remove_and_reuse_match_independent_adjacency() {
    let mut tree = Tree::new();
    let mut oracle = Oracle::default();
    let mut foreign = Tree::new();
    let foreign = foreign.insert(None, NodeKind::Element).unwrap();
    let mut retired = Vec::new();
    let mut rng = 0xd1b5_4a32_d192_ed03;
    for _ in 0..6000 {
        let live: Vec<_> = oracle.nodes.keys().copied().collect();
        let operation = random(&mut rng) % 5;
        if live.is_empty() || (operation < 2 && live.len() < 512) {
            let parent = (!live.is_empty() && random(&mut rng) % 3 != 0)
                .then(|| live[random(&mut rng) % live.len()]);
            let siblings = oracle.children(parent);
            let before = (!siblings.is_empty() && random(&mut rng) % 3 != 0)
                .then(|| siblings[random(&mut rng) % siblings.len()]);
            let id = tree.insert_before(parent, before, NodeKind::Element).unwrap();
            oracle.insert(id, parent, before);
        } else if operation == 2 || live.len() >= 512 {
            let id = live[random(&mut rng) % live.len()];
            let removed = oracle.remove(id);
            assert_eq!(tree.remove(id).unwrap(), removed.len());
            for id in removed {
                assert!(!tree.contains(id));
                retired.push(id);
            }
        } else {
            let id = live[random(&mut rng) % live.len()];
            let parent = (random(&mut rng) % 3 != 0).then(|| live[random(&mut rng) % live.len()]);
            let siblings = oracle.children(parent);
            let before = match random(&mut rng) % 5 {
                0 => Some(foreign),
                1 if !retired.is_empty() => Some(retired[random(&mut rng) % retired.len()]),
                2 if !siblings.is_empty() => Some(siblings[random(&mut rng) % siblings.len()]),
                _ => None,
            };
            let expected = oracle.reparent(id, parent, before);
            assert_eq!(tree.reparent_before(id, parent, before), expected);
        }
        oracle.check(&tree);
    }
}

#[test]
fn first_middle_last_root_and_self_anchor_cases_are_explicit() {
    let mut tree = Tree::new();
    let a = tree.insert(None, NodeKind::Element).unwrap();
    let c = tree.insert(None, NodeKind::Element).unwrap();
    let b = tree.insert_before(None, Some(c), NodeKind::Element).unwrap();
    let first = tree.insert_before(None, Some(a), NodeKind::Element).unwrap();
    assert_eq!(tree.children(None).unwrap().collect::<Vec<_>>(), [first, a, b, c]);
    assert!(!tree.reparent_before(a, None, Some(a)).unwrap());
    assert!(!tree.reparent_before(a, None, Some(b)).unwrap());
    assert!(!tree.reparent_before(c, None, None).unwrap());
    assert!(tree.reparent_before(c, None, Some(first)).unwrap());
    assert_eq!(tree.children(None).unwrap().collect::<Vec<_>>(), [c, first, a, b]);
    let child = tree.insert(Some(a), NodeKind::Element).unwrap();
    let descendant = tree.insert(Some(child), NodeKind::Element).unwrap();
    assert!(tree.reparent_before(child, Some(b), None).unwrap());
    assert_eq!(tree.parent(descendant).unwrap(), Some(child));
    assert_eq!(tree.subtree(child).unwrap().collect::<Vec<_>>(), [child, descendant]);
    assert_eq!(tree.reparent_before(b, Some(descendant), None), Err(TreeError::Cycle));
    assert_eq!(tree.insert_before(Some(a), Some(child), NodeKind::Element), Err(TreeError::InvalidNode));
}
