//! Compare the actual Consumer projection with ordinary acknowledged Part data.
use super::*;
use crate::{Affine, El, FieldId, Signal, Source, Sources, WindowOptions, column, text_input};
use accesskit_consumer::Tree;

struct Page {
    value: Signal<String>,
    broken: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |p| &p.value, |p| &mut p.value);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            column((text_input(&self.value)
                .name("editor")
                .w(100)
                .h(180)
                .p(4)
                .transform(Affine {
                    a: -1.,
                    b: 0.1,
                    c: 0.15,
                    d: 1.,
                    tx: 108.,
                    ty: 3.,
                }),))
            .w(130)
            .h(56)
            .scroll(crate::Axis::Y),
            crate::div()
                .size(1)
                .bg(crate::Color::BLACK)
                .transform(if self.broken {
                    Affine::scale(0., 1.)
                } else {
                    Affine::IDENTITY
                }),
        ))
    }
}
fn project_tree(win: &Win<Page>, cohort: &Cohort) -> Tree {
    Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Geometry",
            cohort,
        ),
        true,
    )
}
fn input_id(win: &Win<Page>, cohort: &Cohort) -> NodeId {
    let mut result = None;
    win.visit(|part| {
        if part.role() == Role::TextInput {
            result = Some(cohort.id(part));
        }
    })
    .unwrap();
    result.unwrap()
}
fn close(actual: accesskit::Rect, expected: crate::Rect) {
    for (actual, expected) in [
        (actual.x0, expected.x),
        (actual.y0, expected.y),
        (actual.x1, expected.x + expected.width),
        (actual.y1, expected.y + expected.height),
    ] {
        assert!(
            (actual - f64::from(expected)).abs() < 0.002,
            "{actual} != {expected}"
        );
    }
}

#[test]
fn native_caret_runs_match_canonical_line_at_wraps_and_hard_separators() {
    use gpui_canvas::{CaretAffinity, TextPosition, TextSelection};
    use icu_segmenter::GraphemeClusterSegmenter;
    for source in [
        "",
        "\r\n\r\n",
        "a\r\n\r\nב\r\n",
        "\u{2028}\u{2028}",
        "a\u{2028}\u{2028}ב\u{2028}",
        "office café אבג wrapped words repeated words",
    ] {
        let mut win = Win::demo(Page {
            value: Signal::new(source.into()),
            broken: false,
        });
        let target = win.role(Role::TextInput).one().unwrap();
        for byte in GraphemeClusterSegmenter::new().segment_str(source) {
            for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                let position = TextPosition {
                    offset: gpui_canvas::TextOffset::new(byte).unwrap(),
                    affinity,
                };
                win.select(
                    target,
                    TextSelection {
                        anchor: position,
                        focus: position,
                    },
                )
                .unwrap();
                let mut cohort = Cohort::default();
                cohort.refresh(&win).unwrap();
                let tree = project_tree(&win, &cohort);
                let input = tree
                    .state()
                    .node_by_tree_local_id(input_id(&win, &cohort), TreeId::ROOT)
                    .unwrap();
                let native = input
                    .text_selection_focus()
                    .unwrap()
                    .to_degenerate_range()
                    .bounding_boxes();
                win.visit(|part| {
                    if part.target() != target {
                        return;
                    }
                    let geometry = part.text_geometry().unwrap();
                    let caret = geometry.layout().caret_bounds(position).unwrap();
                    let expected = geometry.visible_bounds(crate::Rect::new(
                        caret.x,
                        caret.y,
                        0.,
                        caret.height,
                    ));
                    match expected {
                        Some(expected) => {
                            assert_eq!(native.len(), 1, "{source:?} {position:?}");
                            close(native[0], expected);
                        }
                        None => assert!(native.is_empty(), "{source:?} {position:?}"),
                    }
                })
                .unwrap();
            }
        }
    }
}
#[test]
fn wrapped_directional_extents_and_hits_use_same_p_affine_clip_and_units() {
    let long_grapheme = format!("a{}", "\u{301}".repeat(200));
    for source in [
        "office café אבג العربية abc repeated words repeated words",
        "a \u{2067}אבג 12\u{2069} z \u{2066}abc\u{2069}",
        long_grapheme.as_str(),
        "e\u{301}\r\n\r\n",
        "\u{200d}",
        "",
    ] {
        let mut win = Win::recording_scaled(
            Page {
                value: Signal::new(source.into()),
                broken: false,
            },
            WindowOptions {
                size: [300, 240],
                ..Default::default()
            },
            1.25,
        )
        .unwrap();
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let target = win.role(Role::TextInput).one().unwrap();
        win.focus(target).unwrap();
        // Late activation discovers already-acknowledged geometry; it does
        // not shape or borrow a newer logical paragraph.
        let mut cohort = Cohort::default();
        cohort.refresh(&win).unwrap();
        let id = input_id(&win, &cohort);
        let tree = project_tree(&win, &cohort);
        let input = tree
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        assert_eq!(
            input.document_range().text(),
            source,
            "projected document preserves its exact source"
        );
        assert_eq!(tree.state().focus_id_in_tree(), input.id());
        let mut units = 0;
        let mut visible = 0;
        win.visit(|part| {
            if part.target() != target {
                return;
            }
            let geometry = part.text_geometry().unwrap();
            for unit in geometry.layout().graphemes() {
                let range = unit.text_range();
                let start_usv = source[..range.start.byte()].chars().count();
                let end_usv = source[..range.end.byte()].chars().count();
                let start = input
                    .text_position_from_global_usv_index(start_usv)
                    .unwrap();
                let end = input.text_position_from_global_usv_index(end_usv).unwrap();
                let mut native_range = start.to_degenerate_range();
                native_range.set_end(end);
                assert_eq!(
                    native_range.text(),
                    &source[range.start.byte()..range.end.byte()]
                );
                let boxes = native_range.bounding_boxes();
                match geometry.visible_bounds(unit.bounds()) {
                    Some(expected) => {
                        assert_eq!(boxes.len(), 1, "{source:?} unit {range:?}");
                        close(boxes[0], expected);
                        visible += 1;
                    }
                    None => assert!(boxes.is_empty()),
                }
                let rect = unit.bounds();
                if rect.width > 0. && !unit.is_hard_break() {
                    let point = geometry
                        .transform()
                        .unwrap()
                        .to_window(crate::Point {
                            x: rect.x + rect.width * 0.5,
                            y: rect.y + rect.height * 0.5,
                        })
                        .unwrap();
                    if part.contains_point(point) {
                        let native_point = input.transform().inverse()
                            * accesskit::Point::new(f64::from(point.x), f64::from(point.y));
                        assert_eq!(
                            input
                                .text_position_at_point(native_point)
                                .to_global_usv_index(),
                            start_usv,
                            "source={source:?} range={range:?} bounds={rect:?} public_hit={:?}",
                            geometry.grapheme_at(point).map(|unit| unit.text_range())
                        );
                        assert_eq!(geometry.grapheme_at(point).unwrap().text_range(), range);
                    }
                }
                units += 1;
            }
        })
        .unwrap();
        if !source.is_empty() {
            assert!(units > 0 && visible > 0);
        }
    }
}

#[test]
fn failed_new_l_and_old_c_ack_never_reinterpret_native_p_geometry() {
    use crate::property::{Contribution, WIDTH};
    let mut win = Win::recording(
        Page {
            value: Signal::new("office café אבג العربية wrapped words".into()),
            broken: false,
        },
        WindowOptions::default(),
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let target = win.role(Role::TextInput).one().unwrap();
    let snapshot = |win: &Win<Page>| {
        let mut cohort = Cohort::default();
        cohort.refresh(win).unwrap();
        let id = input_id(win, &cohort);
        let tree = project_tree(win, &cohort);
        let input = tree
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        (
            input.document_range().text(),
            input.document_range().bounding_boxes(),
        )
    };
    let p0 = snapshot(&win);
    win.set_property(target, WIDTH, Contribution::Set(crate::Length::Points(60.)))
        .unwrap();
    let c1 = win.with_scene(|_, token| token).unwrap();
    assert_eq!(snapshot(&win), p0);
    assert!(
        win.update(|page| {
            page.value = Signal::new("new logical source reshaped before later failure".into());
            page.broken = true;
        })
        .is_err()
    );
    assert_eq!(snapshot(&win), p0);
    win.presented(c1).unwrap();
    let p1 = snapshot(&win);
    assert_eq!(p1.0, p0.0);
    assert_ne!(p1.1, p0.1);
    win.update(|page| page.broken = false).unwrap();
    assert_eq!(snapshot(&win), p1);
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(
        snapshot(&win).0,
        "new logical source reshaped before later failure"
    );
}

#[test]
fn text_input_and_label_are_leaf_documents_but_button_children_keep_own_carriers() {
    use crate::{button, text};
    let value = Signal::new("own input".to_owned());
    assert!(std::panic::catch_unwind(|| text_input(&value).child(text("other"))).is_err());
    assert!(std::panic::catch_unwind(|| text("own label").child(text("other"))).is_err());
    struct Button;
    impl View for Button {
        fn view(&self) -> El<'_> {
            button("own button text")
                .w(200)
                .p(5)
                .child(text("independent child").p(3))
                .transform(Affine {
                    tx: 17.,
                    ty: 9.,
                    ..Affine::IDENTITY
                })
        }
    }
    let win = Win::demo(Button);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let tree = Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Button",
            &cohort,
        ),
        true,
    );
    win.visit(|part| {
        let root = tree
            .state()
            .node_by_tree_local_id(cohort.id(part), TreeId::ROOT)
            .unwrap();
        let carrier = if part.role() == Role::Button {
            assert_eq!(root.children().count(), 2);
            root.children()
                .find(|child| child.role() == accesskit::Role::Label)
                .unwrap()
        } else {
            root
        };
        assert_eq!(carrier.document_range().text(), part.text().unwrap());
        let expected = part
            .text_geometry()
            .unwrap()
            .visible_bounds(
                part.text_geometry()
                    .unwrap()
                    .layout()
                    .runs()
                    .next()
                    .unwrap()
                    .bounds(),
            )
            .unwrap();
        close(carrier.document_range().bounding_boxes()[0], expected);
    })
    .unwrap();
}

#[test]
fn native_geometry_projection_allocation_ledger() {
    struct Budget {
        value: Signal<String>,
        kind: u8,
    }
    impl Budget {
        const VALUE: Source<Self, String> =
            Source::new(FieldId::new(1), "value", |p| &p.value, |p| &mut p.value);
    }
    impl View for Budget {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE)
        }
        fn view(&self) -> El<'_> {
            match self.kind {
                0 => crate::text(&self.value),
                1 => crate::text(&self.value).name("renamed"),
                _ => text_input(&self.value),
            }
            .w(400)
            .p(4)
        }
    }
    for (case, source, kind) in [
        ("label_short", "office café אבג".to_owned(), 0),
        ("renamed_short", "office café אבג".to_owned(), 1),
        ("input_short", "office café אבג".to_owned(), 2),
        ("input_32k", "a".repeat(32 * 1024), 2),
    ] {
        let win = Win::demo(Budget {
            value: Signal::new(source),
            kind,
        });
        let mut cohort = Cohort::default();
        let cohort_cost = allocation_counter::measure(|| {
            cohort.refresh(&win).unwrap();
        });
        let mut update = None;
        let output_cost = allocation_counter::measure(|| {
            update = Some(project(
                &win.accessibility_sheet().unwrap(),
                win.accessibility_state().unwrap(),
                "Budget",
                &cohort,
            ));
        });
        let update = update.unwrap();
        let nodes = update.nodes.len();
        let runs = update
            .nodes
            .iter()
            .filter(|(_, n)| n.role() == accesskit::Role::TextRun)
            .count();
        let units: usize = update
            .nodes
            .iter()
            .map(|(_, n)| n.character_lengths().len())
            .sum();
        let mut tree = None;
        let consumer_cost = allocation_counter::measure(|| {
            tree = Some(Tree::new(update, true));
        });
        println!(
            "NATIVE_GEOMETRY case={case} cohort_alloc={} cohort_retained={} nodes={nodes} runs={runs} units={units} output_alloc={} output_requested={} output_retained={} output_peak={} consumer_alloc={} consumer_requested={} consumer_retained={} consumer_peak={}",
            cohort_cost.count_total,
            cohort_cost.bytes_current,
            output_cost.count_total,
            output_cost.bytes_total,
            output_cost.bytes_current,
            output_cost.bytes_max,
            consumer_cost.count_total,
            consumer_cost.bytes_total,
            consumer_cost.bytes_current,
            consumer_cost.bytes_max
        );
        drop(tree);
    }
}

#[test]
fn nonpainted_unplaced_text_preserves_content_without_inventing_window_geometry() {
    struct Unplaced;
    impl View for Unplaced {
        fn view(&self) -> El<'_> {
            column((crate::text("unplaced source")
                .w(100)
                .h(30)
                .transform(Affine::scale(0., 1.)),))
            .w(100)
            .h(20)
            .scroll(crate::Axis::Y)
        }
    }
    let win = Win::demo(Unplaced);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let tree = Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Unplaced",
            &cohort,
        ),
        true,
    );
    win.visit(|part| {
        if part.role() == Role::Text {
            assert!(part.transform().is_none());
            assert!(part.text_geometry().unwrap().transform().is_none());
            let label = tree
                .state()
                .node_by_tree_local_id(cohort.id(part), TreeId::ROOT)
                .unwrap();
            assert_eq!(label.document_range().text(), "unplaced source");
            assert!(label.document_range().bounding_boxes().is_empty());
        }
    })
    .unwrap();
}

#[test]
fn native_consumer_rounded_clip_hits_match_acknowledged_parts() {
    use crate::{
        Color, Point, div,
        property::{CLIP, Contribution},
    };
    struct ClipPage {
        map: Affine,
        broken: bool,
    }
    impl View for ClipPage {
        fn view(&self) -> El<'_> {
            div()
                .size(32)
                .rounded(16.0)
                .clip()
                .name("clip-parent")
                .transform(if self.broken {
                    Affine::scale(0., 1.)
                } else {
                    self.map
                })
                .child(
                    div()
                        .size(48)
                        .bg(Color::BLACK)
                        .name("clip-child")
                        .on_click(|_: &mut Self| {}),
                )
        }
    }
    for map in [
        Affine::IDENTITY,
        Affine {
            a: -1.,
            b: 0.125,
            c: 0.25,
            d: 1.,
            tx: 40.,
            ty: 4.,
        },
    ] {
        let mut win = Win::recording_scaled(
            ClipPage { map, broken: false },
            WindowOptions {
                size: [80, 80],
                ..Default::default()
            },
            1.25,
        )
        .unwrap();
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let parent = win.query().name("clip-parent").one().unwrap();
        let child = win.query().name("clip-child").one().unwrap();
        let verify = |win: &Win<ClipPage>| {
            let mut cohort = Cohort::default();
            cohort.refresh(win).unwrap();
            let sheet = win.accessibility_sheet().unwrap();
            let tree = Tree::new(
                project(&sheet, win.accessibility_state().unwrap(), "Clip", &cohort),
                true,
            );
            let mut child_id = None;
            let mut points = Vec::new();
            win.visit(|part| {
                if part.target() == child {
                    child_id = Some(cohort.id(part));
                    for y in 0..64 {
                        for x in 0..64 {
                            let point = Point {
                                x: x as f32 + 0.5,
                                y: y as f32 + 0.5,
                            };
                            points.push((point, part.contains_point(point)));
                        }
                    }
                }
                if part.target() == parent {
                    let node = tree
                        .state()
                        .node_by_tree_local_id(cohort.id(part), TreeId::ROOT)
                        .unwrap();
                    assert_eq!(node.clips_children(), part.clips_children());
                    assert!(node.data().hit_test_shape().is_some());
                    close(
                        node.bounding_box().unwrap(),
                        part.unclipped_bounds().unwrap(),
                    );
                }
            })
            .unwrap();
            let child_id = child_id.unwrap();
            let child_node = tree
                .state()
                .node_by_tree_local_id(child_id, TreeId::ROOT)
                .unwrap();
            let filter = |node: &accesskit_consumer::NodeRef<'_>| {
                if node.id() == child_node.id() {
                    accesskit_consumer::FilterResult::Include
                } else {
                    accesskit_consumer::FilterResult::ExcludeNode
                }
            };
            let parent_id = child_node.parent().unwrap().id();
            let blocked = |node: &accesskit_consumer::NodeRef<'_>| {
                if node.id() == parent_id {
                    accesskit_consumer::FilterResult::ExcludeSubtree
                } else {
                    filter(node)
                }
            };
            for (point, expected) in points {
                let point = accesskit::Point::new(f64::from(point.x), f64::from(point.y));
                assert!(
                    tree.state().root().node_at_point(point, &blocked).is_none(),
                    "ExcludeSubtree blocks descendants; ExcludeNode below keeps them reachable"
                );
                assert_eq!(
                    tree.state().root().node_at_point(point, &filter).is_some(),
                    expected,
                    "root query {map:?} {point:?}"
                );
                assert_eq!(
                    child_node.node_at_point(point, &filter).is_some(),
                    expected,
                    "subtree query obeys ancestor {map:?} {point:?}"
                );
            }
        };
        verify(&win);
        win.set_property(parent, CLIP, Contribution::Set(false))
            .unwrap();
        let eligible = win.with_scene(|_, token| token).unwrap();
        verify(&win); // C cannot rewrite native P.
        assert!(win.update(|page| page.broken = true).is_err());
        verify(&win); // A failed newer L cannot rewrite native P either.
        win.presented(eligible).unwrap();
        verify(&win);
    }
    eprintln!(
        "native_clip_headers,node={},shape={}",
        size_of::<accesskit::Node>(),
        size_of::<accesskit::HitTestShape>()
    );
}

#[test]
fn native_shape_predicate_matches_canvas_at_circle_ties_and_signed_zero() {
    for map in [
        Affine::IDENTITY,
        Affine {
            a: -1.,
            b: -0.,
            c: 0.,
            d: 1.,
            tx: 10.,
            ty: -0.,
        },
        Affine {
            a: 1.,
            b: 0.125,
            c: 0.25,
            d: 1.,
            tx: 4.,
            ty: 3.,
        },
    ] {
        let rect = crate::Rect::new(0., 0., 10., 10.);
        for radius in [0., f32::from_bits(1), 5., f32::MAX] {
            let shape = accesskit::HitTestShape::rounded_rect(
                [0., 0., 10., 10.],
                radius,
                [map.a, map.b, map.c, map.d, map.tx, map.ty],
            )
            .unwrap();
            for x in [-0., 0., 2., 5., 10., 10_f32.next_down(), 10_f32.next_up()] {
                for y in [0., 1_f32.next_down(), 1., 1_f32.next_up(), 5., 10.] {
                    let point = map.apply(crate::Point { x, y }).unwrap();
                    assert_eq!(
                        shape.contains(accesskit::Point::new(point.x.into(), point.y.into())),
                        gpui_canvas::rounded_rect_contains(rect, radius, map, point).unwrap(),
                        "{map:?} {point:?} {radius:?}"
                    );
                }
            }
        }
    }
    for (bounds, radius, map) in [
        ([0., 0., -1., 1.], 0., [1., 0., 0., 1., 0., 0.]),
        ([0., 0., 1., 1.], f32::NAN, [1., 0., 0., 1., 0., 0.]),
        ([0., 0., 1., 1.], 0., [0., 0., 0., 1., 0., 0.]),
    ] {
        assert!(accesskit::HitTestShape::rounded_rect(bounds, radius, map).is_none());
    }
}

#[test]
fn continuous_zero_radius_edge_ties_share_canvas_and_native_arithmetic() {
    struct Edge;
    impl View for Edge {
        fn view(&self) -> El<'_> {
            crate::div()
                .size(32)
                .clip()
                .bg(crate::Color::BLACK)
                .transform(Affine {
                    a: 0.1,
                    tx: 0.3,
                    ..Affine::IDENTITY
                })
        }
    }
    let win = Win::demo(Edge);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let mut update = project(
        &win.accessibility_sheet().unwrap(),
        win.accessibility_state().unwrap(),
        "Edge",
        &cohort,
    );
    let (_, node) = update.nodes.pop().unwrap();
    let shape = node.hit_test_shape().unwrap();
    win.visit(|part| {
        let map = part.transform().unwrap();
        for x in [0.3_f32.next_down(), 0.3, 0.3_f32.next_up()] {
            let point = crate::Point { x, y: 0.5 };
            let expected =
                gpui_canvas::rounded_rect_contains(part.local_bounds(), 0., map, point).unwrap();
            assert_eq!(part.contains_point(point), expected);
            assert_eq!(
                shape.contains(accesskit::Point::new(x.into(), 0.5)),
                expected
            );
            assert_eq!(expected, x > 0.3);
        }
        // This lies before the first accepted 4x4 sample column, yet continuous
        // input accepts it. No coverage-lattice rectangle enters the hit path.
        assert!(part.contains_point(crate::Point {
            x: 0.3_f32.next_up(),
            y: 0.5
        }));
        assert!(
            gpui_reactivity_core::CoordinateSpace::new(map)
                .hit(part.local_bounds(), crate::Point { x: 0.3, y: 0.5 }),
            "freeze the old subtract-first positive control"
        );
    })
    .unwrap();
}
