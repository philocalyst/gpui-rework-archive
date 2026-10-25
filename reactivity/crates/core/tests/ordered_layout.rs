#![cfg(feature = "layout")]

use std::collections::BTreeMap;
use cephal::style::{Dimension, Display};
use gpui_reactivity_core::{NodeId, NodeKind};
use gpui_reactivity_core::layout::{AvailableSpace, LayoutTree, Size, Style};

fn sized(width: f32) -> Style {
    Style {
        size: Size { width: Dimension::length(width), height: Dimension::length(20.) },
        flex_shrink: 0.,
        ..Style::DEFAULT
    }
}
fn available() -> Size<AvailableSpace> {
    Size { width: AvailableSpace::Definite(500.), height: AvailableSpace::MaxContent }
}
fn cold(tree: &LayoutTree, root: NodeId) {
    let mut oracle: cephal::Tree<()> = cephal::Tree::new();
    oracle.disable_rounding();
    let mut ids = BTreeMap::new();
    for id in tree.tree().subtree(root).unwrap() {
        let next = oracle.new_leaf(tree.style(id).unwrap().clone());
        ids.insert(id, next);
        if let Some(parent) = tree.tree().parent(id).unwrap() {
            oracle.append_child(ids[&parent], next);
        }
    }
    oracle.compute_layout(ids[&root], available());
    for (id, next) in ids {
        assert_eq!(tree.layout(id).unwrap(), *oracle.layout(next));
    }
}
#[test]
fn actual_ordered_flex_edits_retain_handles_and_match_fresh_numerical_layout() {
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, Style { display: Display::Flex, ..Style::DEFAULT }).unwrap();
    let a = tree.insert(Some(root), NodeKind::Element, sized(30.)).unwrap();
    let c = tree.insert(Some(root), NodeKind::Element, sized(50.)).unwrap();
    tree.compute(root, available()).unwrap();
    cold(&tree, root);
    let b = tree.insert_before(Some(root), Some(c), NodeKind::Element, sized(40.)).unwrap();
    tree.compute(root, available()).unwrap();
    cold(&tree, root);
    assert_eq!(tree.layout(b).unwrap().location.x, 30.);
    assert_eq!(tree.layout(c).unwrap().location.x, 70.);
    assert!(tree.reparent_before(c, Some(root), Some(a)).unwrap());
    tree.compute(root, available()).unwrap();
    cold(&tree, root);
    assert_eq!(tree.layout(a).unwrap().location.x, 50.);
    let stats = tree.stats();
    let generation = tree.generation();
    assert!(!tree.reparent_before(c, Some(root), Some(c)).unwrap());
    assert!(!tree.reparent_before(c, Some(root), Some(a)).unwrap());
    assert!(!tree.compute(root, available()).unwrap());
    assert_eq!(tree.stats(), stats);
    assert_eq!(tree.generation(), generation);
    let group = tree.insert_before(Some(root), Some(b), NodeKind::Element, Style { display: Display::Flex, ..Style::DEFAULT }).unwrap();
    assert!(tree.reparent_before(a, Some(group), None).unwrap());
    tree.compute(root, available()).unwrap();
    cold(&tree, root);
    assert!(tree.tree().contains(a));
    assert_eq!(tree.tree().parent(a).unwrap(), Some(group));
    tree.remove(b).unwrap();
    tree.compute(root, available()).unwrap();
    cold(&tree, root);
}
