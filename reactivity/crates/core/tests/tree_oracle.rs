use gpui_reactivity_core::{NodeId, NodeKind, Tree, TreeError, inspect};

struct OracleNode {
    id: NodeId,
    parent: Option<usize>,
    children: Vec<usize>,
    live: bool,
}
struct Rng(u64);
impl Rng {
    fn next(&mut self, n: usize) -> usize {
        self.0 ^= self.0 << 13;
        self.0 ^= self.0 >> 7;
        self.0 ^= self.0 << 17;
        self.0 as usize % n
    }
}

fn expected_order(nodes: &[OracleNode], roots: &[usize]) -> Vec<usize> {
    let mut stack: Vec<_> = roots.iter().rev().copied().collect();
    let mut result = Vec::new();
    while let Some(index) = stack.pop() {
        result.push(index);
        stack.extend(nodes[index].children.iter().rev().copied());
    }
    result
}

#[test]
fn randomized_edits_match_independent_adjacency_oracle() {
    for seed in [1, 0x8234_8192, 0xdead_beef] {
        let mut rng = Rng(seed);
        let mut tree = Tree::new();
        let mut nodes: Vec<OracleNode> = Vec::new();
        let mut roots = Vec::new();
        for step in 0..6000 {
            let live: Vec<_> = nodes
                .iter()
                .enumerate()
                .filter(|(_, n)| n.live)
                .map(|(i, _)| i)
                .collect();
            let operation = if live.is_empty() { 0 } else { rng.next(3) };
            match operation {
                0 => {
                    let parent = if live.is_empty() || rng.next(4) == 0 {
                        None
                    } else {
                        Some(live[rng.next(live.len())])
                    };
                    let id = tree
                        .insert(parent.map(|p| nodes[p].id), NodeKind::Element)
                        .unwrap();
                    let index = nodes.len();
                    nodes.push(OracleNode {
                        id,
                        parent,
                        children: Vec::new(),
                        live: true,
                    });
                    if let Some(p) = parent {
                        nodes[p].children.push(index);
                    } else {
                        roots.push(index);
                    }
                }
                1 => {
                    let index = live[rng.next(live.len())];
                    let parent = if rng.next(4) == 0 {
                        None
                    } else {
                        Some(live[rng.next(live.len())])
                    };
                    let mut ancestor = parent;
                    let mut cycle = false;
                    while let Some(p) = ancestor {
                        if p == index {
                            cycle = true;
                            break;
                        }
                        ancestor = nodes[p].parent;
                    }
                    let before: Vec<_> = tree.preorder().collect();
                    let result = tree.reparent(nodes[index].id, parent.map(|p| nodes[p].id));
                    if cycle {
                        assert_eq!(result, Err(TreeError::Cycle));
                        assert_eq!(tree.preorder().collect::<Vec<_>>(), before);
                    } else {
                        result.unwrap();
                        if let Some(p) = nodes[index].parent {
                            nodes[p].children.retain(|&i| i != index);
                        } else {
                            roots.retain(|&i| i != index);
                        }
                        nodes[index].parent = parent;
                        if let Some(p) = parent {
                            nodes[p].children.push(index);
                        } else {
                            roots.push(index);
                        }
                    }
                }
                _ => {
                    let index = live[rng.next(live.len())];
                    let removed = expected_order(&nodes, &[index]);
                    assert_eq!(tree.remove(nodes[index].id).unwrap(), removed.len());
                    if let Some(p) = nodes[index].parent {
                        nodes[p].children.retain(|&i| i != index);
                    } else {
                        roots.retain(|&i| i != index);
                    }
                    for i in removed {
                        nodes[i].live = false;
                        assert!(!tree.contains(nodes[i].id));
                    }
                }
            }
            let expected = expected_order(&nodes, &roots);
            assert_eq!(tree.len(), expected.len(), "seed {seed}, step {step}");
            assert_eq!(
                tree.preorder().collect::<Vec<_>>(),
                expected.iter().map(|&i| nodes[i].id).collect::<Vec<_>>()
            );
            assert_eq!(inspect::nodes(&tree).count(), tree.len());
            for &i in &expected {
                assert_eq!(
                    tree.parent(nodes[i].id).unwrap(),
                    nodes[i].parent.map(|p| nodes[p].id)
                );
                assert_eq!(
                    tree.children(Some(nodes[i].id))
                        .unwrap()
                        .collect::<Vec<_>>(),
                    nodes[i]
                        .children
                        .iter()
                        .map(|&j| nodes[j].id)
                        .collect::<Vec<_>>()
                );
            }
        }
    }
}

#[test]
fn arena_identity_stale_ids_and_failure_atomicity() {
    let mut a = Tree::new();
    let mut b = Tree::new();
    let old = a.insert(None, NodeKind::WebView).unwrap();
    let other = b.insert(None, NodeKind::Native).unwrap();
    assert_ne!(old, other);
    assert!(!a.contains(other));
    assert_eq!(a.reparent(old, Some(other)), Err(TreeError::InvalidNode));
    a.remove(old).unwrap();
    let fresh = a.insert(None, NodeKind::NestedGpui).unwrap();
    assert_ne!(old, fresh);
    assert_eq!(a.remove(old), Err(TreeError::InvalidNode));
    assert_eq!(a.children(None).unwrap().collect::<Vec<_>>(), vec![fresh]);
    assert_eq!(a.kind(fresh).unwrap(), NodeKind::NestedGpui);
}

#[test]
fn deep_tree_streaming_removal_and_drop() {
    let mut tree = Tree::new();
    let root = tree.insert(None, NodeKind::Element).unwrap();
    let mut parent = root;
    for _ in 1..100_000 {
        parent = tree.insert(Some(parent), NodeKind::Element).unwrap();
    }
    assert_eq!(tree.subtree(root).unwrap().count(), 100_000);
    assert_eq!(tree.reparent(root, Some(parent)), Err(TreeError::Cycle));
    assert_eq!(tree.remove(root).unwrap(), 100_000);
    assert!(tree.is_empty());
    // Reuse the intrusive free list after the full deep removal.
    for _ in 0..100_000 {
        tree.insert(None, NodeKind::Element).unwrap();
    }
    assert_eq!(tree.children(None).unwrap().count(), 100_000);
}
