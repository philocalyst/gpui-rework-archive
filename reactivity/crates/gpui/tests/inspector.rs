use gpui::{
    Error,
    prelude::*,
    property::{BACKGROUND, Contribution, HEIGHT, TRANSFORM, WIDTH},
};

fn control<M: View + 'static>(window: &Win<M>, name: &str) -> Target {
    let panel = window
        .role(gpui::Role::ScrollView)
        .name("GPUI Inspector")
        .one()
        .unwrap();
    window.query().name(name).within(panel).one().unwrap()
}
fn click_control<M: View + 'static>(
    window: &mut Win<M>,
    name: &str,
) -> Result<gpui::Commit, Error> {
    let target = control(window, name);
    window.scroll_into_view(target)?;
    let token = window.with_scene(|_, token| token)?;
    window.presented(token)?;
    window.click(target)
}

struct Panel {
    width: u32,
}
impl View for Panel {
    fn view(&self) -> El<'_> {
        div().w(self.width).h(20).bg(rgb(0x123456))
    }
}

#[test]
fn idle_inspector_refreshes_allocate_nothing_with_or_without_selection() {
    struct Content;
    impl View for Content {
        fn view(&self) -> El<'_> {
            div().w(80).h(20).name("inspected")
        }
    }
    let mut window = Win::with_inspector(Content, gpui::WindowOptions::default()).unwrap();
    let target = window.query().name("inspected").one().unwrap();
    for selected in [false, true] {
        if selected {
            window.inspector_select(target).unwrap();
        }
        window.settle().unwrap();
        window.reset_counters().unwrap();
        let cost = allocation_counter::measure(|| {
            for _ in 0..128 {
                assert_eq!(window.settle().unwrap().changed_nodes, 0);
            }
        });
        assert_eq!(cost.count_total, 0, "selected={selected}: {cost:?}");
        assert_eq!(window.counters().paint_passes, 0);
        assert_eq!(window.counters().source_operations, 0);
    }
}

#[test]
fn typed_inspection_preserves_presence_and_reveals_updated_component_defaults() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    assert!(window.snapshot().unwrap().nodes[0].target.is_none());
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    assert_eq!(
        window.property(panel, WIDTH).unwrap(),
        gpui::Length::Points(20.0)
    );
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
    window
        .set_property(panel, WIDTH, Contribution::Set(gpui::Length::Auto))
        .unwrap();
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Set(gpui::Length::Auto)
    );
    window.update(|model| model.width = 64).unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), gpui::Length::Auto);
    window
        .set_property(panel, WIDTH, Contribution::Inherit)
        .unwrap();
    assert_eq!(
        window.property(panel, WIDTH).unwrap(),
        gpui::Length::Points(64.0)
    );
    assert_eq!(
        window.property(panel, HEIGHT).unwrap(),
        gpui::Length::Points(20.0)
    );
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
}

#[test]
fn paint_and_transform_edits_skip_owner_and_layout_but_publish_real_output() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    let original = window.scene_digest().unwrap();
    window.reset_counters().unwrap();
    window
        .set_property(
            panel,
            BACKGROUND,
            Contribution::Set(gpui::Brush::Solid(rgb(0xef1200))),
        )
        .unwrap();
    assert_ne!(window.scene_digest().unwrap(), original);
    window
        .set_property(
            panel,
            TRANSFORM,
            Contribution::Set(Affine::translation(30.0, 0.0)),
        )
        .unwrap();
    let snapshot = window.snapshot().unwrap();
    assert!((snapshot.nodes[0].bounds[0] - 30.0).abs() < 1e-4);
    assert!(snapshot.nodes[0].bounds[0] <= 30.0, "bounds round outward");
    assert_eq!(window.counters().owner_reruns, 0);
    assert_eq!(window.counters().layout_runs, 0);
    assert_eq!(window.counters().presentations, 2);
}

#[test]
fn invalid_and_foreign_inspector_edits_fail_before_source_admission() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    assert!(matches!(
        window.set_property(
            panel,
            WIDTH,
            Contribution::Set(gpui::Length::Points(f32::NAN))
        ),
        Err(Error::Property(_))
    ));
    assert_eq!(window.snapshot().unwrap().source_epoch, 0);
    assert_eq!(
        window.property(panel, WIDTH).unwrap(),
        gpui::Length::Points(20.0)
    );
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
    let mut other = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    assert_eq!(
        other.set_property(panel, WIDTH, Contribution::Set(gpui::Length::Points(10.0))),
        Err(Error::StaleTarget)
    );
    assert_eq!(other.snapshot().unwrap().source_epoch, 0);
}

#[test]
fn inspector_controls_without_a_selection_are_inert() {
    struct Content(bool);
    impl View for Content {
        fn view(&self) -> El<'_> {
            if self.0 {
                div().name("app-root").size(40)
            } else {
                text("removed")
            }
        }
    }
    let mut window = Win::with_inspector(
        Content(true),
        gpui::WindowOptions {
            size: [800, 560],
            ..Default::default()
        },
    )
    .unwrap();
    for after_removal in [false, true] {
        if after_removal {
            let target = window.query().name("app-root").one().unwrap();
            window.inspector_select(target).unwrap();
            window.update(|model| model.0 = false).unwrap();
        }
        assert_eq!(window.inspector_selected().unwrap(), None);
        window.reset_counters().unwrap();
        // Position-free ordinary activation isolates inert editing from the
        // intentional presentation work needed to scroll an offscreen control.
        for label in ["Decrease", "Increase", "Auto", "Inherit", "Select parent"] {
            assert_eq!(
                window
                    .activate(control(&window, label))
                    .unwrap()
                    .changed_nodes,
                0
            );
        }
        assert_eq!(window.counters().source_operations, 0);
        assert_eq!(window.counters().owner_reruns, 0);
        assert_eq!(window.counters().paint_passes, 0);
    }
}

#[test]
fn inspector_parent_walk_stops_at_the_application_root() {
    struct Root;
    impl View for Root {
        fn view(&self) -> El<'_> {
            div().name("app-root").size(40)
        }
    }
    let mut window = Win::with_inspector(
        Root,
        gpui::WindowOptions {
            size: [800, 560],
            ..Default::default()
        },
    )
    .unwrap();
    let root = window.query().name("app-root").one().unwrap();
    window.inspector_select(root).unwrap();
    window.reset_counters().unwrap();
    for _ in 0..3 {
        assert_eq!(
            window
                .activate(control(&window, "Select parent"))
                .unwrap()
                .changed_nodes,
            0
        );
        assert_eq!(window.inspector_selected().unwrap(), Some(root));
    }
    assert_eq!(window.counters().source_operations, 0);
    assert_eq!(window.counters().paint_passes, 0);
}

struct LivePanel {
    width: u32,
    show: bool,
    broken: bool,
    clicks: u32,
}
impl Default for LivePanel {
    fn default() -> Self {
        Self {
            width: 80,
            show: true,
            broken: false,
            clicks: 0,
        }
    }
}
impl View for LivePanel {
    fn view(&self) -> El<'_> {
        column((
            self.show.then(|| {
                div()
                    .w(self.width)
                    .h(60)
                    .bg(rgb(0x123456))
                    .rounded(8.0)
                    .transform(if self.broken {
                        Affine::scale(0.0, 1.0)
                    } else {
                        Affine::IDENTITY
                    })
                    .name("inspected card")
            }),
            button("Application action")
                .h(32)
                .on_click(|m: &mut Self| m.clicks += 1),
        ))
    }
}
fn inspected(recording: bool) -> Win<LivePanel> {
    let options = gpui::WindowOptions {
        size: [800, 560],
        ..Default::default()
    };
    if recording {
        Win::recording_with_inspector(LivePanel::default(), options)
    } else {
        Win::with_inspector(LivePanel::default(), options)
    }
    .unwrap()
}
fn card(win: &Win<LivePanel>) -> Target {
    let mut result = None;
    win.visit(|part| {
        if part.name() == Some("inspected card") {
            result = Some(part.target());
        }
    })
    .unwrap();
    result.unwrap()
}
fn pointer_click(
    win: &mut Win<LivePanel>,
    mouse: &mut PointerSession,
    point: Point,
) -> Result<gpui::Commit, Error> {
    win.pointer_event(mouse, PointerEvent::Move(point))?;
    win.pointer_event(mouse, PointerEvent::Press)?;
    win.pointer_event(mouse, PointerEvent::Release)
}
fn acknowledge(win: &mut Win<LivePanel>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
#[test]
fn actual_inspector_controls_pick_noninteractive_app_shape_and_edit_real_properties() {
    let mut win = inspected(false);
    let target = card(&win);
    let mut mouse = PointerSession::default();
    let pick = win.button("Pick element");
    let mut pick_point = None;
    win.visit(|part| {
        if part.target() == pick {
            let b = part.bounds();
            pick_point = Some(Point {
                x: b.x + 10.0,
                y: b.y + 10.0,
            });
        }
    })
    .unwrap();
    pointer_click(&mut win, &mut mouse, pick_point.unwrap()).unwrap();
    pointer_click(&mut win, &mut mouse, Point { x: 20.0, y: 20.0 }).unwrap();
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
    assert_eq!(win.root().unwrap().clicks, 0);
    win.reset_counters().unwrap();
    click_control(&mut win, "Increase").unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(81.0)
    );
    assert_eq!(
        win.contribution(target, WIDTH).unwrap(),
        Contribution::Set(gpui::Length::Points(81.0))
    );
    click_control(&mut win, "Auto").unwrap();
    assert_eq!(
        win.contribution(target, WIDTH).unwrap(),
        Contribution::Set(gpui::Length::Auto)
    );
    win.update(|m| m.width = 140).unwrap();
    assert_eq!(card(&win), target);
    click_control(&mut win, "Inherit").unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(140.0)
    );
    click_control(&mut win, "background").unwrap();
    click_control(&mut win, "Increase").unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::srgb(18. / 255. + 0.05, 52. / 255., 86. / 255., 1.).unwrap()
    );
    click_control(&mut win, "Inherit").unwrap();
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        rgb(0x123456)
    );
    assert_eq!(
        win.counters().owner_reruns,
        1,
        "only the explicit model update reruns the owner"
    );
    assert!(win.snapshot().unwrap().nodes.iter().any(|n| {
        n.text
            .as_deref()
            .is_some_and(|t| t.starts_with("Layout: 140.0 × 60.0"))
    }));
}
#[test]
fn inspector_selection_rejects_foreign_panel_and_removed_targets_before_admission() {
    let mut a = inspected(false);
    let b = inspected(false);
    let original = card(&a);
    let before = a.snapshot().unwrap().source_epoch;
    assert_eq!(a.inspector_select(card(&b)), Err(Error::StaleTarget));
    assert_eq!(
        a.inspector_select(control(&a, "Increase")),
        Err(Error::StaleTarget)
    );
    assert_eq!(a.snapshot().unwrap().source_epoch, before);
    a.inspector_select(original).unwrap();
    a.update(|m| m.show = false).unwrap();
    assert_eq!(a.inspector_selected().unwrap(), None);
    let epoch = a.snapshot().unwrap().source_epoch;
    assert_eq!(a.inspector_select(original), Err(Error::StaleTarget));
    assert_eq!(
        a.activate(control(&a, "Increase")).unwrap().changed_nodes,
        0
    );
    assert_eq!(a.snapshot().unwrap().source_epoch, epoch);
    a.update(|m| m.show = true).unwrap();
    assert_ne!(card(&a), original);
    assert_eq!(a.inspector_selected().unwrap(), None);
}
#[test]
fn pending_presentation_consumes_pick_release_and_failed_geometry_keeps_logical_repair() {
    let mut win = inspected(true);
    acknowledge(&mut win);
    let target = card(&win);
    win.click(win.button("Pick element")).unwrap();
    let mut mouse = PointerSession::default();
    assert_eq!(
        pointer_click(&mut win, &mut mouse, Point { x: 20.0, y: 20.0 }),
        Err(Error::PresentationStale)
    );
    acknowledge(&mut win);
    win.pointer_event(&mut mouse, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.inspector_selected().unwrap(), None);
    pointer_click(&mut win, &mut mouse, Point { x: 20.0, y: 20.0 }).unwrap();
    acknowledge(&mut win);
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
    click_control(&mut win, "background").unwrap();
    acknowledge(&mut win);
    let tint = control(&win, "Increase");
    win.scroll_into_view(tint).unwrap();
    acknowledge(&mut win);
    win.focus(tint).unwrap();
    assert!(win.update(|m| m.broken = true).is_err());
    assert_eq!(win.click(tint), Err(Error::PresentationStale));
    win.key(Key::Enter).unwrap_err(); // logical tint commits, visual prepare still fails
    assert_eq!(
        win.property(target, BACKGROUND).unwrap().solid().unwrap(),
        Color::srgb(18. / 255. + 0.05, 52. / 255., 86. / 255., 1.).unwrap()
    );
    win.update(|m| m.broken = false).unwrap();
    acknowledge(&mut win);
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
}

#[test]
fn inspector_controls_preserve_exact_bound_sources_and_reveal_latest_masked_base() {
    struct Reactive {
        width: Signal<u32>,
    }
    impl Reactive {
        const WIDTH: Source<Self, u32> =
            Source::new(FieldId::new(1), "width", |m| &m.width, |m| &mut m.width);
    }
    impl View for Reactive {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::WIDTH)
        }
        fn view(&self) -> El<'_> {
            column((
                div()
                    .w(&self.width)
                    .h(40)
                    .bg(rgb(0x123456))
                    .name("bound card"),
                button("Update source").on_click(Self::WIDTH.update(|w| *w = 140)),
            ))
        }
    }
    let mut win = Win::with_inspector(
        Reactive {
            width: Signal::new(80),
        },
        gpui::WindowOptions {
            size: [800, 560],
            ..Default::default()
        },
    )
    .unwrap();
    let target = win.query().name("bound card").one().unwrap();
    win.inspector_select(target).unwrap();
    win.reset_counters().unwrap();
    click_control(&mut win, "Increase").unwrap();
    win.click(win.button("Update source")).unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(81.0)
    );
    click_control(&mut win, "Inherit").unwrap();
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(140.0)
    );
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
    win.resize_scaled([1200, 840], 1.5).unwrap();
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
    assert_eq!(
        win.property(target, WIDTH).unwrap(),
        gpui::Length::Points(140.0)
    );
    assert!(win.bounds(control(&win, "Increase")).unwrap().x > 700.0);
}

#[test]
fn inspector_geometry_captions_publish_the_same_candidate_and_need_no_followup_frame() {
    let mut win = inspected(true);
    acknowledge(&mut win);
    let target = card(&win);
    win.inspector_select(target).unwrap();
    acknowledge(&mut win);
    let before = win.snapshot().unwrap();
    let old_captions: Vec<_> = before
        .nodes
        .iter()
        .filter_map(|n| n.text.as_ref())
        .filter(|t| t.starts_with("Displayed "))
        .cloned()
        .collect();
    click_control(&mut win, "Increase").unwrap();
    win.set_property(
        target,
        TRANSFORM,
        Contribution::Set(Affine::translation(30.0, 0.0)),
    )
    .unwrap();
    let pending = win.snapshot().unwrap();
    assert_eq!(pending.presentation_epoch, before.presentation_epoch);
    let pending_captions: Vec<_> = pending
        .nodes
        .iter()
        .filter_map(|n| n.text.as_ref())
        .filter(|t| t.starts_with("Displayed "))
        .cloned()
        .collect();
    assert_eq!(
        pending_captions, old_captions,
        "pending preparation cannot mutate old P captions"
    );
    acknowledge(&mut win);
    let shown = win.snapshot().unwrap();
    let mut geometry = None;
    win.visit(|part| {
        if part.target() == target {
            geometry = Some((part.bounds(), part.transform().unwrap()));
        }
    })
    .unwrap();
    let (bounds, transform) = geometry.unwrap();
    let bounds_label = format!(
        "Displayed bounds @{}\n{:.1}, {:.1}  {:.1} × {:.1}",
        shown.presentation_epoch, bounds.x, bounds.y, bounds.width, bounds.height
    );
    let transform_label = format!(
        "Displayed transform @{}\n{:.1} {:.1} {:.1} {:.1} {:.1} {:.1}",
        shown.presentation_epoch,
        transform.a,
        transform.b,
        transform.c,
        transform.d,
        transform.tx,
        transform.ty
    );
    assert!(
        shown
            .nodes
            .iter()
            .any(|n| n.text.as_deref() == Some(bounds_label.as_str()))
    );
    assert!(
        shown
            .nodes
            .iter()
            .any(|n| n.text.as_deref() == Some(transform_label.as_str()))
    );
    assert!(
        bounds.width >= 81.0 && (bounds.width - 81.0).abs() < 1e-3,
        "conservative bounds round outward"
    );
    assert_eq!(transform.tx, 30.0);
    win.reset_counters().unwrap();
    win.settle().unwrap();
    assert_eq!(
        win.counters().presentations,
        0,
        "caption coherence requires no extra frame"
    );
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().paint_passes, 0);
}

#[test]
fn catalog_controls_edit_and_inherit_all_thirteen_picked_live_properties() {
    use gpui::property::{PROPERTIES, PropertyValue};
    let mut win = inspected(false);
    let target = card(&win);
    click_control(&mut win, "Pick element").unwrap();
    pointer_click(
        &mut win,
        &mut PointerSession::default(),
        Point { x: 20., y: 20. },
    )
    .unwrap();
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
    win.reset_counters().unwrap();
    for info in PROPERTIES {
        click_control(&mut win, info.name).unwrap();
        let before = win.property_value(target, info.id).unwrap();
        let direction = match before {
            PropertyValue::Color(value)
                if value.space() == gpui::ColorSpace::Oklch && value.channels()[0] >= 0.95 =>
            {
                "Decrease"
            }
            _ => "Increase",
        };
        click_control(&mut win, direction).unwrap();
        let after = win.property_value(target, info.id).unwrap();
        assert_ne!(after, before, "{}", info.name);
        assert_eq!(
            win.property_contribution(target, info.id).unwrap(),
            Contribution::Set(after)
        );
        click_control(&mut win, "Inherit").unwrap();
        assert_eq!(win.property_value(target, info.id).unwrap(), before);
        assert_eq!(
            win.property_contribution(target, info.id).unwrap(),
            Contribution::Inherit
        );
    }
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
}

#[test]
fn transform_editor_exposes_each_of_the_six_components() {
    use gpui::property::{PropertyId, PropertyValue};
    let mut win = inspected(false);
    let target = card(&win);
    win.inspector_select(target).unwrap();
    click_control(&mut win, "transform").unwrap();
    for (index, name) in ["a", "b", "c", "d", "tx", "ty"].into_iter().enumerate() {
        assert!(win.contains_text(&format!("Component: {name}")).unwrap());
        click_control(&mut win, "Increase").unwrap();
        let mut matrix = [1., 0., 0., 1., 0., 0.];
        matrix[index] += 1.;
        let [a, b, c, d, tx, ty] = matrix;
        assert_eq!(
            win.property_value(target, PropertyId::Transform).unwrap(),
            PropertyValue::Transform(Affine { a, b, c, d, tx, ty })
        );
        assert!(
            win.contains_text(&format!("Logical transform:\n{name}={:?}", matrix[index]))
                .unwrap()
        );
        click_control(&mut win, "Inherit").unwrap();
        if index != 5 {
            click_control(&mut win, "Component").unwrap();
        }
    }
}

#[test]
fn color_editor_preserves_every_author_space_and_rejects_invalid_steps_visibly() {
    use gpui::property::{PropertyId, PropertyValue};
    struct Surface(Color);
    impl View for Surface {
        fn view(&self) -> El<'_> {
            div().size(60).bg(self.0).name("surface")
        }
    }
    for color in [
        Color::srgb(0.2, 0.3, 0.4, 0.5).unwrap(),
        Color::linear_srgb(1.5, -0.1, 0.4, 0.5).unwrap(),
        Color::display_p3(0.2, 0.3, 0.4, 0.5).unwrap(),
        Color::linear_display_p3(1.5, -0.1, 0.4, 0.5).unwrap(),
        Color::oklch(0.4, 0.1, 30., 0.5).unwrap(),
    ] {
        let mut win = Win::with_inspector(
            Surface(color),
            gpui::WindowOptions {
                size: [800, 560],
                ..Default::default()
            },
        )
        .unwrap();
        let target = win.query().name("surface").one().unwrap();
        win.inspector_select(target).unwrap();
        click_control(&mut win, "background").unwrap();
        for component in 0..4 {
            click_control(&mut win, "Increase").unwrap();
            let PropertyValue::Brush(gpui::Brush::Solid(after)) =
                win.property_value(target, PropertyId::Background).unwrap()
            else {
                panic!()
            };
            assert_eq!(after.space(), color.space());
            let names = if color.space() == gpui::ColorSpace::Oklch {
                ["L", "C", "h", "alpha"]
            } else {
                ["R", "G", "B", "alpha"]
            };
            assert!(
                win.contains_text(&format!(
                    "Logical background:\n{:?} {}={:?}",
                    after.space(),
                    names[component],
                    after.channels()[component]
                ))
                .unwrap()
            );
            for channel in 0..4 {
                let delta = if channel == component {
                    if color.space() == gpui::ColorSpace::Oklch && channel == 2 {
                        15.
                    } else {
                        0.05
                    }
                } else {
                    0.
                };
                assert!(
                    (after.channels()[channel] - (color.channels()[channel] + delta)).abs() < 2e-7
                );
            }
            click_control(&mut win, "Inherit").unwrap();
            let PropertyValue::Brush(gpui::Brush::Solid(restored)) =
                win.property_value(target, PropertyId::Background).unwrap()
            else {
                panic!()
            };
            assert!(restored.same_authoring(color));
            if component != 3 {
                click_control(&mut win, "Component").unwrap();
            }
        }
    }
    let mut win = inspected(false);
    let target = card(&win);
    win.inspector_select(target).unwrap();
    click_control(&mut win, "gap").unwrap();
    let epoch = win.inspect().unwrap().source_epoch;
    click_control(&mut win, "Decrease").unwrap();
    assert_eq!(win.inspect().unwrap().source_epoch, epoch);
    assert_eq!(
        win.property_value(target, PropertyId::Gap).unwrap(),
        PropertyValue::Number(0.)
    );
    assert_eq!(
        win.property_contribution(target, PropertyId::Gap).unwrap(),
        Contribution::Inherit
    );
    assert!(
        win.contains_text("Last edit rejected: Property(Negative)")
            .unwrap()
    );
    click_control(&mut win, "Increase").unwrap();
    assert!(!win.contains_text("Last edit rejected:").unwrap());
    click_control(&mut win, "background").unwrap();
    for _ in 0..3 {
        click_control(&mut win, "Component").unwrap();
    }
    let epoch = win.inspect().unwrap().source_epoch;
    click_control(&mut win, "Increase").unwrap();
    assert_eq!(win.inspect().unwrap().source_epoch, epoch);
    assert!(
        win.contains_text("Last edit rejected: InvalidColor")
            .unwrap()
    );
    click_control(&mut win, "Decrease").unwrap();
    assert!(!win.contains_text("Last edit rejected:").unwrap());
}

#[test]
fn basis_inspector_captions_resolve_partial_candidate_pool_and_scale() {
    let mut win = inspected(true);
    acknowledge(&mut win);
    let target = card(&win);
    win.inspector_select(target).unwrap();
    acknowledge(&mut win);
    for (scale, map) in [
        (
            1.0,
            Affine {
                a: 1.25,
                b: 0.125,
                tx: 30.0,
                ..Affine::IDENTITY
            },
        ),
        (
            2.0,
            Affine {
                a: 1.5,
                c: -0.25,
                tx: 20.0,
                ..Affine::IDENTITY
            },
        ),
        (1.0, Affine::scale(-1.25, 1.5)),
    ] {
        let before = win.snapshot().unwrap();
        win.set_property(target, TRANSFORM, Contribution::Set(map))
            .unwrap();
        win.resize_scaled([800, 560], scale).unwrap();
        assert_eq!(win.snapshot().unwrap().nodes, before.nodes);
        acknowledge(&mut win);
        let shown = win.snapshot().unwrap();
        let mut map = None;
        win.visit(|part| {
            if part.target() == target {
                map = part.transform();
            }
        })
        .unwrap();
        let map = map.unwrap();
        let label = format!(
            "Displayed transform @{}\n{:.1} {:.1} {:.1} {:.1} {:.1} {:.1}",
            shown.presentation_epoch, map.a, map.b, map.c, map.d, map.tx, map.ty
        );
        assert!(
            shown
                .nodes
                .iter()
                .any(|node| node.text.as_deref() == Some(label.as_str())),
            "caption must use the same C pool and admitted DPI coefficients"
        );
        win.reset_counters().unwrap();
        win.settle().unwrap();
        assert_eq!(win.counters().presentations, 0);
    }
}
