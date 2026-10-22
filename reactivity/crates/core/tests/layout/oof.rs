use super::*;

fn definite_viewport(width: f32, height: f32) -> Size<AvailableSpace> {
    Size {
        width: AvailableSpace::Definite(width),
        height: AvailableSpace::Definite(height),
    }
}
fn out_of_flow(position: cephal::style::Position, x: f32, y: f32) -> Style {
    Style {
        position,
        inset: cephal::Rect {
            left: cephal::style::LengthPercentageAuto::length(x),
            top: cephal::style::LengthPercentageAuto::length(y),
            ..cephal::Rect::splat(cephal::style::LengthPercentageAuto::AUTO)
        },
        ..sized(20.0, 12.0)
    }
}
fn origin(tree: &LayoutTree, mut node: NodeId) -> cephal::Point<f32> {
    let mut point = cephal::Point::ZERO;
    loop {
        let location = tree.layout(node).unwrap().location;
        point.x += location.x;
        point.y += location.y;
        let Some(parent) = tree.tree().parent(node).unwrap() else {
            return point;
        };
        node = parent;
    }
}
#[test]
fn nonparent_absolute_and_fixed_containing_blocks_match_cold() {
    use cephal::style::Position;
    for display in [Display::Block, Display::Flex, Display::Grid] {
        let mut tree = LayoutTree::new();
        let root = tree
            .insert(
                None,
                NodeKind::Element,
                Style {
                    display,
                    position: Position::Relative,
                    ..sized(320.0, 240.0)
                },
            )
            .unwrap();
        let positioned = tree
            .insert(
                Some(root),
                NodeKind::Element,
                Style {
                    display,
                    position: Position::Relative,
                    margin: cephal::Rect::splat(cephal::style::LengthPercentageAuto::length(7.0)),
                    ..sized(80.0, 60.0)
                },
            )
            .unwrap();
        let bridge = tree
            .insert(
                Some(positioned),
                NodeKind::Element,
                Style {
                    display,
                    margin: cephal::Rect::splat(cephal::style::LengthPercentageAuto::length(3.0)),
                    ..sized(35.0, 25.0)
                },
            )
            .unwrap();
        let absolute = tree
            .insert(
                Some(bridge),
                NodeKind::Element,
                out_of_flow(Position::Absolute, 13.0, 17.0),
            )
            .unwrap();
        let fixed = tree
            .insert(
                Some(bridge),
                NodeKind::Element,
                out_of_flow(Position::Fixed, 5.0, 9.0),
            )
            .unwrap();
        let available = definite_viewport(320.0, 240.0);
        tree.compute(root, available).unwrap();
        assert_cold(&tree, root, available);
        let block = origin(&tree, positioned);
        assert_eq!(
            origin(&tree, absolute),
            cephal::Point {
                x: block.x + 13.0,
                y: block.y + 17.0
            }
        );
        assert_eq!(origin(&tree, fixed), cephal::Point { x: 5.0, y: 9.0 });
        assert!(tree.storage().absolute_contexts >= 3);
        let mut style = tree.style(positioned).unwrap().clone();
        style.position = Position::Static;
        tree.set_style(positioned, style).unwrap();
        tree.compute(root, available).unwrap();
        assert_cold(&tree, root, available);
        assert_eq!(origin(&tree, absolute), cephal::Point { x: 13.0, y: 17.0 });
    }
}

#[test]
fn out_of_flow_reparent_remove_slot_reuse_and_hidden_forests_match_cold() {
    use cephal::style::Position;
    let mut tree = LayoutTree::new();
    let root_style = Style {
        display: Display::Block,
        position: Position::Relative,
        ..sized(300.0, 200.0)
    };
    let a = tree
        .insert(None, NodeKind::Element, root_style.clone())
        .unwrap();
    let b = tree.insert(None, NodeKind::Element, root_style).unwrap();
    let parent = tree
        .insert(Some(a), NodeKind::Element, sized(40.0, 30.0))
        .unwrap();
    let child = tree
        .insert(
            Some(parent),
            NodeKind::Element,
            out_of_flow(Position::Absolute, 19.0, 23.0),
        )
        .unwrap();
    let fixed = tree
        .insert(
            Some(child),
            NodeKind::Element,
            out_of_flow(Position::Fixed, 29.0, 31.0),
        )
        .unwrap();
    let available = definite_viewport(300.0, 200.0);
    for root in [a, b] {
        tree.compute(root, available).unwrap();
        assert_cold(&tree, root, available);
    }
    tree.reparent(parent, Some(b)).unwrap();
    for root in [b, a] {
        tree.compute(root, available).unwrap();
        assert_cold(&tree, root, available);
    }
    assert_eq!(origin(&tree, child), cephal::Point { x: 19.0, y: 23.0 });
    assert_eq!(origin(&tree, fixed), cephal::Point { x: 29.0, y: 31.0 });
    let mut style = tree.style(parent).unwrap().clone();
    style.display = Display::None;
    tree.set_style(parent, style).unwrap();
    tree.compute(b, available).unwrap();
    assert_cold(&tree, b, available);
    assert_eq!(tree.layout(child).unwrap().size, cephal::Size::ZERO);
    tree.set_style(parent, sized(40.0, 30.0)).unwrap();
    tree.compute(b, available).unwrap();
    assert_cold(&tree, b, available);
    tree.remove(child).unwrap();
    let replacement = tree
        .insert(
            Some(parent),
            NodeKind::Element,
            out_of_flow(Position::Fixed, 37.0, 41.0),
        )
        .unwrap();
    assert!(!tree.tree().contains(child));
    assert!(!tree.tree().contains(fixed));
    assert_ne!(replacement, child);
    for root in [a, b] {
        tree.compute(root, available).unwrap();
        assert_cold(&tree, root, available);
    }
    assert_eq!(
        origin(&tree, replacement),
        cephal::Point { x: 37.0, y: 41.0 }
    );
    tree.remove(parent).unwrap();
    tree.compute(b, available).unwrap();
    assert_cold(&tree, b, available);
    assert_eq!(tree.storage().absolute_contexts, 0);
}

fn measured(input: MeasureInput, width: f32) -> MeasureOutput {
    MeasureOutput::from_size(Size {
        width: input.known_dimensions.width.unwrap_or(width),
        height: input.known_dimensions.height.unwrap_or(14.0),
    })
}
fn measured_marker(input: MeasureInput) -> MeasureOutput {
    measured(input, 32.0)
}
fn assert_cold_measured(
    tree: &LayoutTree,
    root: NodeId,
    available: Size<AvailableSpace>,
    widths: &BTreeMap<NodeId, f32>,
) {
    let mut cold: cephal::Tree<f32> = cephal::Tree::new();
    cold.disable_rounding();
    let mut ids = BTreeMap::new();
    for id in tree.tree().subtree(root).unwrap() {
        let style = tree.style(id).unwrap().clone();
        let node = match widths.get(&id) {
            Some(&width) => cold.new_leaf_with_context(style, width),
            None => cold.new_leaf(style),
        };
        ids.insert(id, node);
        if let Some(parent) = tree.tree().parent(id).unwrap() {
            cold.append_child(ids[&parent], node);
        }
    }
    cold.compute_layout_with_measure(
        ids[&root],
        available,
        |width: &mut f32, input, _: &Style| measured(input, *width),
    );
    for (id, node) in ids {
        assert_eq!(tree.layout(id).unwrap(), *cold.layout(node), "node {id:?}");
    }
}

pub(crate) struct MeasuredRows {
    pub(crate) tree: LayoutTree,
    root: NodeId,
    rows: Vec<NodeId>,
    leaves: Vec<NodeId>,
    widths: BTreeMap<NodeId, f32>,
    tooltip: Option<NodeId>,
    target_bridge: NodeId,
    available: Size<AvailableSpace>,
}
impl MeasuredRows {
    pub(crate) fn new(include_tooltip: bool) -> Self {
        use cephal::style::Position;
        let mut tree = LayoutTree::new();
        let root = tree
            .insert(
                None,
                NodeKind::Element,
                Style {
                    display: Display::Block,
                    position: Position::Relative,
                    ..sized(600.0, 20_000.0)
                },
            )
            .unwrap();
        let mut rows = Vec::new();
        let mut leaves = Vec::new();
        let mut widths = BTreeMap::new();
        for _ in 0..1000 {
            let row = tree
                .insert(
                    Some(root),
                    NodeKind::Element,
                    Style {
                        display: Display::Flex,
                        ..sized(600.0, 20.0)
                    },
                )
                .unwrap();
            let leaf = tree
                .insert(Some(row), NodeKind::Element, Style::DEFAULT)
                .unwrap();
            tree.set_measure(leaf, Some(measured_marker)).unwrap();
            widths.insert(leaf, 32.0);
            rows.push(row);
            leaves.push(leaf);
        }
        let bridge = tree
            .insert(Some(rows[0]), NodeKind::Element, sized(30.0, 18.0))
            .unwrap();
        let target_bridge = tree
            .insert(Some(rows[999]), NodeKind::Element, sized(30.0, 18.0))
            .unwrap();
        let tooltip = include_tooltip.then(|| {
            tree.insert(
                Some(bridge),
                NodeKind::Element,
                out_of_flow(Position::Absolute, 10.0, 20.0),
            )
            .unwrap()
        });
        Self {
            tree,
            root,
            rows,
            leaves,
            widths,
            tooltip,
            target_bridge,
            available: definite_viewport(600.0, 480.0),
        }
    }
    pub(crate) fn compute(&mut self) {
        self.tree
            .compute_with(self.root, self.available, &mut |id, input| {
                measured(input, self.widths[&id])
            })
            .unwrap();
    }
    pub(crate) fn assert_cold(&self) {
        assert_cold_measured(&self.tree, self.root, self.available, &self.widths);
    }
    pub(crate) fn edit_text(&mut self) {
        self.widths.insert(self.leaves[500], 48.0);
        self.tree.mark_dirty(self.leaves[500]).unwrap();
    }
    pub(crate) fn edit_style(&mut self) {
        let mut style = self.tree.style(self.rows[500]).unwrap().clone();
        style.size.width = Dimension::length(590.0);
        self.tree.set_style(self.rows[500], style).unwrap();
    }
    pub(crate) fn edit_placement(&mut self) {
        self.tree
            .set_style(
                self.tooltip.unwrap(),
                out_of_flow(cephal::style::Position::Absolute, 25.0, 35.0),
            )
            .unwrap();
    }
    pub(crate) fn reparent(&mut self) {
        self.tree
            .reparent(self.tooltip.unwrap(), Some(self.target_bridge))
            .unwrap();
    }
}

#[test]
fn thousand_measured_rows_keep_off_path_answers_during_oof_and_text_edits() {
    let mut fixture = MeasuredRows::new(true);
    fixture.compute();
    fixture.assert_cold();
    let before = fixture.tree.stats();
    fixture.edit_text();
    fixture.compute();
    fixture.assert_cold();
    let text = fixture.tree.stats();
    fixture.edit_style();
    fixture.compute();
    fixture.assert_cold();
    let style = fixture.tree.stats();
    assert!(style.cached_answers - text.cached_answers >= 900);
    fixture.edit_placement();
    fixture.compute();
    fixture.assert_cold();
    assert_eq!(
        origin(&fixture.tree, fixture.tooltip.unwrap()),
        cephal::Point { x: 25.0, y: 35.0 }
    );
    let placement = fixture.tree.stats();
    fixture.reparent();
    fixture.compute();
    fixture.assert_cold();
    let moved = fixture.tree.stats();
    assert!(moved.cached_answers - placement.cached_answers >= 900);
    // Physical-work budgets are asserted by the normal-policy external driver.
    // verify-cache deliberately recomputes shortcut answers speculatively.
    eprintln!(
        "oof_work,text_measure={},text_compute={},style_measure={},style_compute={},placement_measure={},placement_compute={},reparent_measure={},reparent_compute={}",
        text.measure_calls - before.measure_calls,
        text.computed_answers - before.computed_answers,
        style.measure_calls - text.measure_calls,
        style.computed_answers - text.computed_answers,
        placement.measure_calls - style.measure_calls,
        placement.computed_answers - style.computed_answers,
        moved.measure_calls - placement.measure_calls,
        moved.computed_answers - placement.computed_answers
    );
}

#[test]
fn randomized_oof_lifecycle_matches_new_vendor_owned_forests() {
    use cephal::style::Position;
    let mut tree = LayoutTree::new();
    let root_style = Style {
        display: Display::Block,
        position: Position::Relative,
        ..sized(240.0, 180.0)
    };
    let roots = [
        tree.insert(None, NodeKind::Element, root_style.clone())
            .unwrap(),
        tree.insert(None, NodeKind::Element, root_style).unwrap(),
    ];
    let mut nodes = Vec::new();
    let mut rng = Rng(0x1ac5_f00d);
    for index in 0..20 {
        let parent = roots
            .get(index)
            .copied()
            .unwrap_or_else(|| nodes[rng.next(nodes.len())]);
        let position = [
            Position::Static,
            Position::Relative,
            Position::Absolute,
            Position::Fixed,
        ][rng.next(4)];
        nodes.push(
            tree.insert(
                Some(parent),
                NodeKind::Element,
                out_of_flow(position, 3.0, 7.0),
            )
            .unwrap(),
        );
    }
    let available = definite_viewport(240.0, 180.0);
    for step in 0..160 {
        let node = nodes[rng.next(nodes.len())];
        match rng.next(5) {
            0 => {
                let mut style = tree.style(node).unwrap().clone();
                style.position = [
                    Position::Static,
                    Position::Relative,
                    Position::Absolute,
                    Position::Fixed,
                ][rng.next(4)];
                style.inset.left = cephal::style::LengthPercentageAuto::length(rng.next(31) as f32);
                tree.set_style(node, style).unwrap();
            }
            1 => {
                let parent = if rng.next(3) == 0 {
                    roots[rng.next(2)]
                } else {
                    nodes[rng.next(nodes.len())]
                };
                let result = tree.reparent(node, Some(parent));
                assert!(result.is_ok() || result == Err(LayoutError::Tree(TreeError::Cycle)));
            }
            2 => {
                tree.remove(node).unwrap();
                nodes.retain(|&id| tree.tree().contains(id));
                nodes.push(
                    tree.insert(
                        Some(roots[rng.next(2)]),
                        NodeKind::Element,
                        out_of_flow(Position::Absolute, 11.0, 13.0),
                    )
                    .unwrap(),
                );
            }
            3 => {
                let mut style = tree.style(node).unwrap().clone();
                style.display = if style.display == Display::None {
                    Display::Block
                } else {
                    Display::None
                };
                tree.set_style(node, style).unwrap();
            }
            _ => tree.mark_dirty(node).unwrap(),
        }
        for root in if step % 2 == 0 {
            roots
        } else {
            [roots[1], roots[0]]
        } {
            tree.compute(root, available).unwrap();
            assert_cold(&tree, root, available);
        }
    }
}

#[test]
fn measurement_panic_cannot_publish_partial_oof_layout() {
    let mut fixture = MeasuredRows::new(true);
    fixture.compute();
    fixture.assert_cold();
    assert!(fixture.tree.storage().absolute_contexts > 0);
    fixture.tree.mark_dirty(fixture.leaves[500]).unwrap();
    let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        fixture
            .tree
            .compute_with(fixture.root, fixture.available, &mut |_, _| {
                panic!("injected OOF measurement fault")
            })
    }));
    assert!(result.is_err());
    assert!(fixture.tree.is_poisoned());
    assert_eq!(
        fixture.tree.layout(fixture.tooltip.unwrap()),
        Err(LayoutError::Poisoned)
    );
    assert_eq!(
        fixture.tree.compute(fixture.root, fixture.available),
        Err(LayoutError::Poisoned)
    );
}

#[test]
fn a_former_forest_root_uses_its_new_initial_containing_block() {
    use cephal::style::{LengthPercentageAuto, Position};
    let mut tree = LayoutTree::new();
    let moved = tree
        .insert(None, NodeKind::Element, sized(80.0, 60.0))
        .unwrap();
    let bridge = tree
        .insert(Some(moved), NodeKind::Element, sized(30.0, 20.0))
        .unwrap();
    let mut style = out_of_flow(Position::Fixed, 0.0, 0.0);
    style.inset = cephal::Rect {
        right: LengthPercentageAuto::length(5.0),
        bottom: LengthPercentageAuto::length(9.0),
        ..cephal::Rect::splat(LengthPercentageAuto::AUTO)
    };
    let fixed = tree.insert(Some(bridge), NodeKind::Element, style).unwrap();
    tree.compute(moved, definite_viewport(80.0, 60.0)).unwrap();
    assert_eq!(origin(&tree, fixed), cephal::Point { x: 55.0, y: 39.0 });
    let root = tree
        .insert(
            None,
            NodeKind::Element,
            Style {
                position: Position::Relative,
                ..sized(300.0, 200.0)
            },
        )
        .unwrap();
    tree.compute(root, definite_viewport(300.0, 200.0)).unwrap();
    tree.reparent(moved, Some(root)).unwrap();
    assert_eq!(
        tree.compute(moved, definite_viewport(80.0, 60.0)),
        Err(LayoutError::NotRoot)
    );
    tree.compute(root, definite_viewport(300.0, 200.0)).unwrap();
    assert_cold(&tree, root, definite_viewport(300.0, 200.0));
    assert_eq!(origin(&tree, fixed), cephal::Point { x: 275.0, y: 179.0 });
    tree.remove(moved).unwrap();
    tree.compute(root, definite_viewport(300.0, 200.0)).unwrap();
    assert_eq!(tree.storage().absolute_contexts, 0);
}
