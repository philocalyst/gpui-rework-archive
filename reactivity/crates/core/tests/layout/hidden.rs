use cephal::style::{Dimension, Display};
use gpui_reactivity_core::layout::{AvailableSpace, LayoutTree, Size, Style};
use gpui_reactivity_core::{NodeId, NodeKind};
use std::collections::BTreeMap;

pub(crate) fn available() -> Size<AvailableSpace> {
    Size {
        width: AvailableSpace::Definite(600.0),
        height: AvailableSpace::Definite(20000.0),
    }
}
fn style(hidden: bool) -> Style {
    Style {
        display: if hidden {
            Display::None
        } else {
            Display::Block
        },
        size: Size {
            width: Dimension::length(20.0),
            height: Dimension::length(10.0),
        },
        ..Style::DEFAULT
    }
}
pub(crate) struct HiddenTree {
    pub tree: LayoutTree,
    pub root: NodeId,
    pub parents: Vec<NodeId>,
    pub leaves: Vec<NodeId>,
}
impl HiddenTree {
    pub fn new(count: usize, hidden: bool) -> Self {
        let mut tree = LayoutTree::new();
        let root = tree
            .insert(
                None,
                NodeKind::Element,
                Style {
                    display: Display::Block,
                    size: Size {
                        width: Dimension::length(600.0),
                        height: Dimension::length(20000.0),
                    },
                    ..Style::DEFAULT
                },
            )
            .unwrap();
        let mut parents = Vec::with_capacity(count);
        let mut leaves = Vec::with_capacity(count);
        for _ in 0..count {
            let parent = tree
                .insert(Some(root), NodeKind::Element, style(hidden))
                .unwrap();
            leaves.push(
                tree.insert(Some(parent), NodeKind::Element, style(false))
                    .unwrap(),
            );
            parents.push(parent);
        }
        Self {
            tree,
            root,
            parents,
            leaves,
        }
    }
    pub fn compute(&mut self) {
        self.tree.compute(self.root, available()).unwrap();
    }
    pub fn set_hidden(&mut self, index: usize, hidden: bool) {
        self.tree
            .set_style(self.parents[index], style(hidden))
            .unwrap();
    }
    pub fn assert_cold(&self) {
        let mut cold: cephal::Tree<()> = cephal::Tree::new();
        cold.disable_rounding();
        let mut ids = BTreeMap::new();
        for node in self.tree.tree().subtree(self.root).unwrap() {
            let id = cold.new_leaf(self.tree.style(node).unwrap().clone());
            ids.insert(node, id);
            if node != self.root {
                cold.append_child(ids[&self.tree.tree().parent(node).unwrap().unwrap()], id);
            }
        }
        cold.compute_layout(ids[&self.root], available());
        for (node, id) in ids {
            assert_eq!(
                self.tree.layout(node).unwrap(),
                *cold.layout(id),
                "{node:?}"
            );
        }
    }
}

#[test]
fn hidden_forest_reveal_move_remove_and_reuse_matches_cold() {
    let mut fixture = HiddenTree::new(1000, true);
    fixture.compute();
    fixture.assert_cold();
    for &leaf in &fixture.leaves {
        assert_eq!(fixture.tree.layout(leaf).unwrap().size, Size::ZERO);
    }
    fixture.set_hidden(0, false);
    fixture.compute();
    fixture.assert_cold();
    assert_eq!(
        fixture.tree.layout(fixture.leaves[0]).unwrap().size,
        Size {
            width: 20.0,
            height: 10.0
        }
    );
    fixture
        .tree
        .reparent(fixture.leaves[0], Some(fixture.parents[1]))
        .unwrap();
    fixture.compute();
    fixture.assert_cold();
    assert_eq!(
        fixture.tree.layout(fixture.leaves[0]).unwrap().size,
        Size::ZERO
    );
    let retired = fixture.parents[2];
    fixture.tree.remove(retired).unwrap();
    let replacement = fixture
        .tree
        .insert(Some(fixture.root), NodeKind::Element, style(true))
        .unwrap();
    assert_ne!(retired, replacement);
    fixture
        .tree
        .insert(Some(replacement), NodeKind::Element, style(false))
        .unwrap();
    fixture.compute();
    fixture.assert_cold();
    fixture.set_hidden(1, false);
    fixture.compute();
    fixture.assert_cold();
    fixture.set_hidden(1, true);
    fixture.compute();
    fixture.assert_cold();
}
