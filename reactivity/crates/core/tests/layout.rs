#![cfg(feature = "layout")]

use std::collections::BTreeMap;
use std::sync::atomic::{AtomicU32, Ordering};

use cephal::style::{
    Dimension, Display, FlexWrap, GridTemplateComponent, LengthPercentage, TrackSizingFunction,
};
use gpui_reactivity_core::layout::{
    AvailableSpace, LayoutError, LayoutTree, MeasureInput, MeasureOutput, Size, Style,
};
use gpui_reactivity_core::{NodeId, NodeKind, TreeError};

fn viewport(width: f32) -> Size<AvailableSpace> {
    Size {
        width: AvailableSpace::Definite(width),
        height: AvailableSpace::MaxContent,
    }
}
fn sized(width: f32, height: f32) -> Style {
    Style {
        size: Size {
            width: Dimension::length(width),
            height: Dimension::length(height),
        },
        ..Style::DEFAULT
    }
}
fn flex() -> Style {
    Style {
        display: Display::Flex,
        flex_wrap: FlexWrap::Wrap,
        ..Style::DEFAULT
    }
}

// Construct a new vendor-owned oracle every time. It shares only local styles
// and topology declarations with the adapter, never caches or retained results.
fn assert_cold(tree: &LayoutTree, root: NodeId, available: Size<AvailableSpace>) {
    let mut cold: cephal::Tree<()> = cephal::Tree::new();
    cold.disable_rounding();
    let mut ids = BTreeMap::new();
    for id in tree.tree().subtree(root).unwrap() {
        let oracle = cold.new_leaf(tree.style(id).unwrap().clone());
        ids.insert(id, oracle);
        if id != root {
            cold.append_child(ids[&tree.tree().parent(id).unwrap().unwrap()], oracle);
        }
    }
    cold.compute_layout(ids[&root], available);
    for (id, oracle) in ids {
        assert_eq!(
            tree.layout(id).unwrap(),
            *cold.layout(oracle),
            "node {id:?}"
        );
    }
}

#[test]
fn real_flex_block_and_grid_layout_match_cold() {
    for display in [Display::Block, Display::Flex, Display::Grid] {
        let mut tree = LayoutTree::new();
        let mut style = Style {
            display,
            ..Style::DEFAULT
        };
        if display == Display::Grid {
            style.grid_mut().template_columns = vec![
                GridTemplateComponent::Single(TrackSizingFunction::length(70.0)),
                GridTemplateComponent::Single(TrackSizingFunction::fr(1.0)),
            ];
            style.gap = Size {
                width: LengthPercentage::length(3.0),
                height: LengthPercentage::length(2.0),
            };
        }
        let root = tree.insert(None, NodeKind::Element, style).unwrap();
        let a = tree
            .insert(Some(root), NodeKind::Element, sized(31.5, 20.5))
            .unwrap();
        let b = tree
            .insert(Some(root), NodeKind::Native, sized(48.25, 15.25))
            .unwrap();
        tree.insert(Some(root), NodeKind::NestedGpui, sized(21.0, 11.0))
            .unwrap();
        tree.compute(root, viewport(240.5)).unwrap();
        assert_cold(&tree, root, viewport(240.5));
        tree.set_style(a, sized(67.75, 33.5)).unwrap();
        tree.compute(root, viewport(240.5)).unwrap();
        assert_cold(&tree, root, viewport(240.5));
        tree.set_style(
            b,
            Style {
                display: Display::None,
                ..sized(48.25, 15.25)
            },
        )
        .unwrap();
        tree.compute(root, viewport(183.0)).unwrap();
        assert_cold(&tree, root, viewport(183.0));
    }
}

#[test]
fn idle_identical_styles_and_bad_capabilities_do_no_compute() {
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, flex()).unwrap();
    let child = tree
        .insert(Some(root), NodeKind::Element, sized(40.0, 20.0))
        .unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    let stats = tree.stats();
    let generation = tree.generation();
    let storage = tree.storage();
    for _ in 0..1000 {
        assert!(!tree.compute(root, viewport(200.0)).unwrap());
    }
    assert!(!tree.set_style(child, sized(40.0, 20.0)).unwrap());
    assert!(!tree.reparent(child, Some(root)).unwrap());
    assert_eq!(
        tree.reparent(root, Some(child)),
        Err(LayoutError::Tree(TreeError::Cycle))
    );
    assert_eq!(
        tree.compute(child, viewport(200.0)),
        Err(LayoutError::NotRoot)
    );
    assert_eq!(
        tree.compute(root, viewport(f32::NAN)),
        Err(LayoutError::InvalidViewport)
    );
    let foreign = LayoutTree::new()
        .insert(None, NodeKind::Element, Style::DEFAULT)
        .unwrap();
    assert_eq!(
        tree.set_style(foreign, Style::DEFAULT),
        Err(LayoutError::Tree(TreeError::InvalidNode))
    );
    assert_eq!(tree.stats(), stats);
    assert_eq!(tree.generation(), generation);
    assert_eq!(tree.storage(), storage);
}

#[test]
fn cheap_leaf_forest_has_no_cache_boxes_and_styles_are_released() {
    let mut tree = LayoutTree::new();
    let mut roots = Vec::new();
    for _ in 0..500 {
        roots.push(
            tree.insert(None, NodeKind::Element, sized(10.0, 20.0))
                .unwrap(),
        );
    }
    assert_eq!(tree.storage().active_styles, 1);
    for &root in &roots {
        tree.compute(root, viewport(100.0)).unwrap();
    }
    assert_eq!(tree.storage().allocated_caches, 0);
    for n in 0..500 {
        tree.set_style(roots[0], sized(n as f32, 20.0)).unwrap();
        tree.compute(roots[0], viewport(100.0)).unwrap();
        assert!(tree.storage().active_styles <= 2);
    }
    tree.set_style(roots[0], sized(10.0, 20.0)).unwrap();
    assert_eq!(tree.storage().active_styles, 1);
    for root in roots {
        tree.remove(root).unwrap();
    }
    assert_eq!(tree.storage().active_styles, 0);
    assert_eq!(tree.storage().allocated_caches, 0);
}

#[test]
fn remove_queued_nodes_reuse_slots_reparent_depth_and_switch_roots() {
    let mut tree = LayoutTree::new();
    let a = tree.insert(None, NodeKind::Element, flex()).unwrap();
    let b = tree
        .insert(None, NodeKind::Element, Style::DEFAULT)
        .unwrap();
    let branch = tree.insert(Some(a), NodeKind::Element, flex()).unwrap();
    let leaf = tree
        .insert(Some(branch), NodeKind::Element, sized(24.0, 20.0))
        .unwrap();
    tree.compute(a, viewport(200.0)).unwrap();
    tree.compute(b, viewport(100.0)).unwrap();
    tree.set_style(branch, sized(50.0, 20.0)).unwrap();
    tree.set_style(leaf, sized(60.0, 20.0)).unwrap();
    tree.remove(branch).unwrap();
    let reused = tree.insert(Some(b), NodeKind::WebView, flex()).unwrap();
    tree.insert(Some(reused), NodeKind::Element, sized(17.5, 13.5))
        .unwrap();
    tree.compute(a, viewport(200.0)).unwrap();
    tree.compute(b, viewport(100.0)).unwrap();
    assert_cold(&tree, a, viewport(200.0));
    assert_cold(&tree, b, viewport(100.0));
    assert_eq!(
        tree.layout(leaf),
        Err(LayoutError::Tree(TreeError::InvalidNode))
    );
    tree.set_style(reused, Style::DEFAULT).unwrap();
    tree.reparent(reused, Some(a)).unwrap();
    tree.reparent(reused, None).unwrap();
    tree.compute(reused, viewport(80.0)).unwrap();
    tree.compute(a, viewport(200.0)).unwrap();
    tree.compute(b, viewport(100.0)).unwrap();
    assert_cold(&tree, reused, viewport(80.0));
    assert_cold(&tree, a, viewport(200.0));
    assert_cold(&tree, b, viewport(100.0));
    tree.remove(a).unwrap();
    let new_root = tree
        .insert(None, NodeKind::Element, sized(12.0, 15.0))
        .unwrap();
    tree.compute(new_root, viewport(200.0)).unwrap();
    assert_cold(&tree, new_root, viewport(200.0));
}

#[test]
fn hidden_subtrees_clear_old_caches_before_becoming_visible_again() {
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, flex()).unwrap();
    let branch = tree.insert(Some(root), NodeKind::Element, flex()).unwrap();
    tree.insert(Some(branch), NodeKind::Element, sized(30.0, 10.0))
        .unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    for _ in 0..3 {
        tree.set_style(
            branch,
            Style {
                display: Display::None,
                ..flex()
            },
        )
        .unwrap();
        tree.compute(root, viewport(200.0)).unwrap();
        assert_cold(&tree, root, viewport(200.0));
        tree.set_style(branch, flex()).unwrap();
        tree.compute(root, viewport(200.0)).unwrap();
        assert_cold(&tree, root, viewport(200.0));
    }
}

static MEASURE_WIDTH: AtomicU32 = AtomicU32::new(20f32.to_bits());
fn measure(input: MeasureInput) -> MeasureOutput {
    MeasureOutput::from_size(Size {
        width: input
            .known_dimensions
            .width
            .unwrap_or(f32::from_bits(MEASURE_WIDTH.load(Ordering::Relaxed))),
        height: input.known_dimensions.height.unwrap_or(14.5),
    })
}
#[test]
fn explicit_measure_invalidation_and_removal_keep_cache_correct() {
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, flex()).unwrap();
    let leaf = tree
        .insert(Some(root), NodeKind::Element, Style::DEFAULT)
        .unwrap();
    tree.set_measure(leaf, Some(measure)).unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    assert_eq!(tree.layout(leaf).unwrap().size.width, 20.0);
    assert_eq!(tree.storage().allocated_caches, 2);
    let calls = tree.stats().measure_calls;
    assert!(!tree.compute(root, viewport(200.0)).unwrap());
    assert_eq!(tree.stats().measure_calls, calls);
    MEASURE_WIDTH.store(61.25f32.to_bits(), Ordering::Relaxed);
    tree.mark_dirty(leaf).unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    assert_eq!(tree.layout(leaf).unwrap().size.width, 61.25);
    tree.set_measure(leaf, None).unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    assert_eq!(tree.layout(leaf).unwrap().size.width, 0.0);
    assert_eq!(tree.storage().allocated_caches, 1);
    assert_cold(&tree, root, viewport(200.0));
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
#[test]
fn randomized_lifecycle_and_viewport_edits_match_fresh_cephal_trees() {
    let mut rng = Rng(0x91ab_8765);
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, flex()).unwrap();
    for _ in 0..25 {
        tree.insert(Some(root), NodeKind::Element, sized(5.0, 10.0))
            .unwrap();
    }
    for _ in 0..600 {
        let ids: Vec<_> = tree.tree().subtree(root).unwrap().skip(1).collect();
        match if ids.is_empty() { 0 } else { rng.next(5) } {
            0 => {
                let parent = if ids.is_empty() || rng.next(2) == 0 {
                    root
                } else {
                    ids[rng.next(ids.len())]
                };
                tree.insert(
                    Some(parent),
                    NodeKind::Element,
                    if rng.next(4) == 0 {
                        flex()
                    } else {
                        sized(rng.next(80) as f32 + 0.25, rng.next(35) as f32 + 0.5)
                    },
                )
                .unwrap();
            }
            1 => {
                let node = ids[rng.next(ids.len())];
                tree.remove(node).unwrap();
            }
            2 => {
                let node = ids[rng.next(ids.len())];
                let parent = if rng.next(2) == 0 {
                    root
                } else {
                    ids[rng.next(ids.len())]
                };
                match tree.reparent(node, Some(parent)) {
                    Ok(_) => {}
                    Err(LayoutError::Tree(TreeError::Cycle)) => {}
                    Err(e) => panic!("{e:?}"),
                }
            }
            _ => {
                let node = ids[rng.next(ids.len())];
                let style = if rng.next(7) == 0 {
                    Style {
                        display: Display::None,
                        ..Style::DEFAULT
                    }
                } else if rng.next(3) == 0 {
                    flex()
                } else {
                    sized(rng.next(80) as f32 + 0.25, rng.next(35) as f32 + 0.5)
                };
                tree.set_style(node, style).unwrap();
            }
        }
        let available = viewport([120.0, 201.5, 320.0][rng.next(3)]);
        tree.compute(root, available).unwrap();
        assert_cold(&tree, root, available);
    }
}

#[test]
fn retained_queries_reuse_clean_sibling_caches() {
    let mut tree = LayoutTree::new();
    let root = tree.insert(None, NodeKind::Element, flex()).unwrap();
    let a = tree.insert(Some(root), NodeKind::Element, flex()).unwrap();
    let b = tree.insert(Some(root), NodeKind::Element, flex()).unwrap();
    let leaf = tree
        .insert(Some(a), NodeKind::Element, sized(20.0, 10.0))
        .unwrap();
    tree.insert(Some(b), NodeKind::Element, sized(30.0, 10.0))
        .unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    let before = tree.stats().cached_answers;
    tree.set_style(leaf, sized(25.0, 10.0)).unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    assert!(tree.stats().cached_answers > before);
    assert_cold(&tree, root, viewport(200.0));
}

#[test]
fn calc_program_validation_and_parent_viewport_dependencies() {
    use cephal::style::CalcOp;
    let mut tree = LayoutTree::new();
    assert_eq!(tree.register_calc(&[]), Err(LayoutError::InvalidCalc));
    assert_eq!(
        tree.register_calc(&[CalcOp::Add]),
        Err(LayoutError::InvalidCalc)
    );
    assert_eq!(
        tree.register_calc(&[CalcOp::Px(f32::NAN)]),
        Err(LayoutError::InvalidCalc)
    );
    assert_eq!(
        tree.register_calc(&[CalcOp::Px(1.0); 17]),
        Err(LayoutError::InvalidCalc)
    );
    let expression = tree
        .register_calc(&[CalcOp::Percent(0.5), CalcOp::Px(10.0), CalcOp::Sub])
        .unwrap();
    let root = tree
        .insert(None, NodeKind::Element, Style::DEFAULT)
        .unwrap();
    let leaf = tree
        .insert(
            Some(root),
            NodeKind::Element,
            Style {
                size: Size {
                    width: Dimension::calc(expression),
                    height: Dimension::length(11.0),
                },
                ..Style::DEFAULT
            },
        )
        .unwrap();
    tree.compute(root, viewport(200.0)).unwrap();
    assert_eq!(tree.layout(leaf).unwrap().size.width, 90.0);
    tree.compute(root, viewport(300.0)).unwrap();
    assert_eq!(tree.layout(leaf).unwrap().size.width, 140.0);
    let name = tree.intern("column");
    assert_eq!(name, tree.intern("column"));
}

fn panic_measure(_: MeasureInput) -> MeasureOutput {
    panic!("injected measurement fault")
}
#[test]
fn measurement_panic_poisoning_prevents_reusing_partial_layout() {
    let mut tree = LayoutTree::new();
    let root = tree
        .insert(None, NodeKind::Element, Style::DEFAULT)
        .unwrap();
    tree.set_measure(root, Some(panic_measure)).unwrap();
    assert!(
        std::panic::catch_unwind(std::panic::AssertUnwindSafe(
            || tree.compute(root, viewport(100.0))
        ))
        .is_err()
    );
    assert!(tree.is_poisoned());
    assert_eq!(tree.layout(root), Err(LayoutError::Poisoned));
    assert_eq!(
        tree.compute(root, viewport(100.0)),
        Err(LayoutError::Poisoned)
    );
}
