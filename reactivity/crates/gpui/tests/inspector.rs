use gpui::{
    Error,
    prelude::*,
    property::{BACKGROUND, Contribution, HEIGHT, TRANSFORM, WIDTH},
};

struct Panel {
    width: u32,
}
impl View for Panel {
    fn view(&self) -> El<'_> {
        div().w(self.width).h(20).bg(rgb(0x123456))
    }
}

#[test]
fn typed_inspection_preserves_presence_and_reveals_updated_component_defaults() {
    let mut window = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    assert!(window.snapshot().unwrap().nodes[0].target.is_none());
    let panel = window.inspect().unwrap().nodes[0].target.unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), Some(20.0));
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
    window
        .set_property(panel, WIDTH, Contribution::Set(None))
        .unwrap();
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Set(None)
    );
    window.update(|model| model.width = 64).unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), None);
    window
        .set_property(panel, WIDTH, Contribution::Inherit)
        .unwrap();
    assert_eq!(window.property(panel, WIDTH).unwrap(), Some(64.0));
    assert_eq!(window.property(panel, HEIGHT).unwrap(), Some(20.0));
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
        .set_property(panel, BACKGROUND, Contribution::Set(rgb(0xef1200)))
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
        window.set_property(panel, WIDTH, Contribution::Set(Some(f32::NAN))),
        Err(Error::Property(_))
    ));
    assert_eq!(window.snapshot().unwrap().source_epoch, 0);
    assert_eq!(window.property(panel, WIDTH).unwrap(), Some(20.0));
    assert_eq!(
        window.contribution(panel, WIDTH).unwrap(),
        Contribution::Inherit
    );
    let mut other = Win::with_size(Panel { width: 20 }, 100, 40).unwrap();
    assert_eq!(
        other.set_property(panel, WIDTH, Contribution::Set(Some(10.0))),
        Err(Error::StaleTarget)
    );
    assert_eq!(other.snapshot().unwrap().source_epoch, 0);
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
    win.click(win.button("Width +20")).unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Some(100.0));
    assert_eq!(
        win.contribution(target, WIDTH).unwrap(),
        Contribution::Set(Some(100.0))
    );
    win.click(win.button("Auto")).unwrap();
    assert_eq!(
        win.contribution(target, WIDTH).unwrap(),
        Contribution::Set(None)
    );
    win.update(|m| m.width = 140).unwrap();
    assert_eq!(card(&win), target);
    win.click(win.button("Inherit width")).unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Some(140.0));
    win.click(win.button("Set tint")).unwrap();
    assert_eq!(win.property(target, BACKGROUND).unwrap(), rgb(0x0d9488));
    win.click(win.button("Inherit tint")).unwrap();
    assert_eq!(win.property(target, BACKGROUND).unwrap(), rgb(0x123456));
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
        a.inspector_select(a.button("Set tint")),
        Err(Error::StaleTarget)
    );
    assert_eq!(a.snapshot().unwrap().source_epoch, before);
    a.inspector_select(original).unwrap();
    a.update(|m| m.show = false).unwrap();
    assert_eq!(a.inspector_selected().unwrap(), None);
    let epoch = a.snapshot().unwrap().source_epoch;
    assert_eq!(a.inspector_select(original), Err(Error::StaleTarget));
    assert_eq!(a.click(a.button("Set tint")), Err(Error::MissingElement));
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
    let tint = win.button("Set tint");
    win.focus(tint).unwrap();
    assert!(win.update(|m| m.broken = true).is_err());
    assert_eq!(win.click(tint), Err(Error::PresentationStale));
    win.key(Key::Enter).unwrap_err(); // logical tint commits, visual prepare still fails
    assert_eq!(win.property(target, BACKGROUND).unwrap(), rgb(0x0d9488));
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
    win.click(win.button("Width +20")).unwrap();
    win.click(win.button("Update source")).unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Some(100.0));
    win.click(win.button("Inherit width")).unwrap();
    assert_eq!(win.property(target, WIDTH).unwrap(), Some(140.0));
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().descriptions, 0);
    win.resize_scaled([1200, 840], 1.5).unwrap();
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
    assert_eq!(win.property(target, WIDTH).unwrap(), Some(140.0));
    assert!(win.bounds(win.button("Set tint")).unwrap().x > 700.0);
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
    win.click(win.button("Width +20")).unwrap();
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
        bounds.width >= 100.0 && (bounds.width - 100.0).abs() < 1e-3,
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
