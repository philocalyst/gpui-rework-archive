//! Own-focus release admission uses public non-automatic presentation owners.
use gpui::{Error, Role, WindowOptions, prelude::*};

struct Page {
    value: Signal<String>,
    label: Signal<String>,
    checked: bool,
    calls: usize,
    x: f32,
    show: bool,
    replacement: bool,
    broken: bool,
}
impl Default for Page {
    fn default() -> Self {
        Self {
            value: Signal::new("search".into()),
            label: Signal::new("check".into()),
            checked: false,
            calls: 0,
            x: 0.,
            show: true,
            replacement: false,
            broken: false,
        }
    }
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(2), "label", |m| &m.label, |m| &mut m.label);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).field(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value).name("input").w(240).h(32),
            self.show.then(|| {
                let control = if self.replacement {
                    button("replacement")
                } else {
                    checkbox("check", self.checked)
                };
                control
                    .name(&self.label)
                    .w(240)
                    .h(40)
                    .transform(if self.broken {
                        Affine::scale(0., 1.)
                    } else {
                        Affine::translation(self.x, 0.)
                    })
                    .on_click(|m: &mut Self| {
                        m.checked = !m.checked;
                        m.calls += 1;
                    })
            }),
        ))
    }
}
fn ack(win: &mut Win<Page>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn page(inspector: bool) -> Win<Page> {
    let options = WindowOptions {
        size: [720, 900],
        ..Default::default()
    };
    let mut win = if inspector {
        Win::recording_with_inspector(Page::default(), options)
    } else {
        Win::recording(Page::default(), options)
    }
    .unwrap();
    ack(&mut win);
    // Unlike logical focus alone, clicking establishes the collapsed caret
    // whose removal needs the own-focus candidate on the subsequent press.
    win.click(win.query().name("input").one().unwrap()).unwrap();
    ack(&mut win);
    win
}
fn press(win: &mut Win<Page>) -> PointerSession {
    let mut pointer = PointerSession::default();
    win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 12., y: 52. }))
        .unwrap();
    let commit = win
        .pointer_event(&mut pointer, PointerEvent::Press)
        .unwrap();
    assert_eq!(commit.source_epoch, commit.presentation_epoch + 1);
    assert_eq!(commit.prepared_epoch, Some(commit.source_epoch));
    assert_eq!(commit.changed_nodes, 0);
    assert_eq!(win.root().unwrap().calls, 0);
    pointer
}
fn published_checked(win: &Win<Page>) -> bool {
    let mut value = None;
    win.visit(|part| {
        if part.role() == Role::CheckBox {
            value = part.checked();
        }
    })
    .unwrap();
    value.unwrap()
}

#[test]
fn own_focus_candidate_does_not_lose_rapid_release_or_publish_unacknowledged_state() {
    let mut win = page(false);
    let mut pointer = press(&mut win);
    let focus_token = win.with_scene(|_, token| token).unwrap();
    let target = win.focused().unwrap().unwrap();
    assert!(!published_checked(&win));
    let commit = win
        .pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
    assert!(win.root().unwrap().checked);
    assert!(commit.prepared_epoch.is_some());
    assert!(!published_checked(&win));
    assert_eq!(win.presented(focus_token), Err(Error::StalePresentation));
    ack(&mut win);
    assert!(published_checked(&win));
    assert_eq!(win.focused().unwrap(), Some(target));
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
}

#[test]
fn ack_before_release_uses_the_ordinary_current_sheet() {
    let mut win = page(false);
    let mut pointer = press(&mut win);
    ack(&mut win);
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
}

#[test]
fn intervening_model_noop_semantic_geometry_replacement_and_failure_revoke_focus_proof() {
    for change in 0..6 {
        let mut win = page(false);
        let mut pointer = press(&mut win);
        match change {
            0 => {
                win.update(|_| {}).unwrap();
            }
            1 => {
                win.set(Page::LABEL, "renamed".into()).unwrap();
            }
            2 => {
                win.update(|m| m.x = 20.).unwrap();
            }
            3 => {
                win.update(|m| m.replacement = true).unwrap();
            }
            4 => {
                win.update(|m| m.show = false).unwrap();
                win.update(|m| m.show = true).unwrap();
            }
            5 => {
                assert!(win.update(|m| m.broken = true).is_err());
            }
            _ => unreachable!(),
        }
        assert_eq!(
            win.pointer_event(&mut pointer, PointerEvent::Release),
            Err(Error::PresentationStale),
            "change {change}"
        );
        assert_eq!(win.root().unwrap().calls, 0);
        win.update(|m| {
            m.broken = false;
            m.x = 0.;
        })
        .unwrap();
        ack(&mut win);
        win.pointer_event(&mut pointer, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.root().unwrap().calls, 0);
    }
}

#[test]
fn viewport_aba_and_surface_loss_revoke_the_exact_focus_candidate() {
    for change in 0..3 {
        let mut win = page(false);
        let mut pointer = press(&mut win);
        let focus_token = win.with_scene(|_, token| token).unwrap();
        match change {
            0 => {
                win.resize([720, 901]).unwrap();
                win.resize([720, 900]).unwrap();
            }
            1 => {
                win.resize_scaled([720, 900], 2.).unwrap();
                win.resize_scaled([720, 900], 1.).unwrap();
            }
            2 => {
                win.presentation_lost().unwrap();
            }
            _ => unreachable!(),
        }
        if change != 2 {
            assert_eq!(win.presented(focus_token), Err(Error::StalePresentation));
        }
        assert_eq!(
            win.pointer_event(&mut pointer, PointerEvent::Release),
            Err(Error::PresentationStale)
        );
        ack(&mut win);
        win.pointer_event(&mut pointer, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.root().unwrap().calls, 0);
    }
}

#[test]
fn equal_viewport_and_fresh_hit_inside_own_focus_paint_keep_the_gesture() {
    let mut win = page(false);
    let mut pointer = press(&mut win);
    win.resize_scaled([720, 900], 1.).unwrap();
    for x in [500., 12.] {
        win.pointer_event(&mut pointer, PointerEvent::Move(Point { x, y: 52. }))
            .unwrap();
    }
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
}

#[test]
fn focus_proof_never_crosses_window_namespaces() {
    let mut first = page(false);
    let mut second = page(false);
    let mut pointer = press(&mut first);
    let _second_pointer = press(&mut second);
    assert_eq!(
        second.pointer_event(&mut pointer, PointerEvent::Release),
        Err(Error::PresentationStale)
    );
    ack(&mut first);
    first
        .pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(first.root().unwrap().calls, 0);
    assert_eq!(second.root().unwrap().calls, 0);
}

#[test]
fn cancellation_and_failed_new_press_consume_the_own_focus_proof() {
    for event in [
        PointerEvent::Cancel,
        PointerEvent::Leave,
        PointerEvent::Move(Point {
            x: f32::NAN,
            y: 52.,
        }),
        PointerEvent::Move(Point {
            x: 12.,
            y: f32::INFINITY,
        }),
        PointerEvent::Wheel(ScrollDelta { x: 0., y: 1. }),
        PointerEvent::Press,
    ] {
        let mut win = page(false);
        let mut pointer = press(&mut win);
        let result = win.pointer_event(&mut pointer, event);
        assert!(
            result.is_ok() || matches!(result, Err(Error::NotHittable | Error::PresentationStale))
        );
        ack(&mut win);
        win.pointer_event(&mut pointer, PointerEvent::Move(Point { x: 12., y: 52. }))
            .unwrap();
        win.pointer_event(&mut pointer, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.root().unwrap().calls, 0, "event {event:?}");
    }
}

#[test]
fn built_in_inspector_accepts_own_focus_c_without_publishing_its_epoch_captions() {
    let mut win = page(true);
    let target = win.query().name("check").one().unwrap();
    win.inspector_select(target).unwrap();
    ack(&mut win);
    while win.update(|_| {}).unwrap().source_epoch < 9 {
        ack(&mut win);
    }
    ack(&mut win);
    let captions = |win: &Win<Page>| {
        let mut values = Vec::new();
        win.visit(|part| {
            if let Some(text) = part.text() {
                values.push(text.to_owned());
            }
        })
        .unwrap();
        values
    };
    let before = captions(&win);
    let mut pointer = press(&mut win);
    let focus = win.with_scene(|_, token| token).unwrap();
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
    assert_eq!(win.inspector_selected().unwrap(), Some(target));
    assert!(!published_checked(&win));
    assert_eq!(captions(&win), before);
    assert_eq!(win.presented(focus), Err(Error::StalePresentation));
    ack(&mut win);
    assert!(published_checked(&win));
    assert_eq!(win.query().name("check").one().unwrap(), target);
}

#[test]
fn inspector_panel_action_uses_the_same_focus_release_proof() {
    let mut win = page(true);
    let target = win.query().name("check").one().unwrap();
    win.inspector_select(target).unwrap();
    ack(&mut win);
    let height = win.query().name("height").one().unwrap();
    let mut point = None;
    win.visit(|part| {
        if part.target() == height {
            let b = part.bounds();
            point = Some(Point {
                x: b.x + b.width / 2.,
                y: b.y + b.height / 2.,
            });
        }
    })
    .unwrap();
    let mut pointer = PointerSession::default();
    win.pointer_event(&mut pointer, PointerEvent::Move(point.unwrap()))
        .unwrap();
    let focus = win
        .pointer_event(&mut pointer, PointerEvent::Press)
        .unwrap();
    assert_eq!(focus.source_epoch, focus.presentation_epoch + 1);
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 0);
    ack(&mut win);
    let mut chosen = false;
    win.visit(|part| {
        chosen |= part
            .text()
            .is_some_and(|text| text.starts_with("Logical height:"))
    })
    .unwrap();
    assert!(chosen);
}

#[test]
fn inspector_picking_uses_actual_shape_and_cannot_select_panel_controls() {
    for panel in [false, true] {
        let mut win = page(true);
        win.activate(win.button("Pick element")).unwrap();
        ack(&mut win);
        win.click(win.query().name("input").one().unwrap()).unwrap();
        ack(&mut win);
        let app = win.query().name("check").one().unwrap();
        let point = if panel {
            Point { x: 420., y: 16. }
        } else {
            Point { x: 12., y: 52. }
        };
        let mut pointer = PointerSession::default();
        win.pointer_event(&mut pointer, PointerEvent::Move(point))
            .unwrap();
        win.pointer_event(&mut pointer, PointerEvent::Press)
            .unwrap();
        win.pointer_event(&mut pointer, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.inspector_selected().unwrap(), (!panel).then_some(app));
        assert_eq!(win.root().unwrap().calls, 0);
    }
}

#[test]
fn inspector_focus_proof_does_not_cover_later_source_or_viewport_changes() {
    for change in 0..9 {
        let mut win = page(true);
        let target = win.query().name("check").one().unwrap();
        let mut pointer = press(&mut win);
        match change {
            0 => {
                win.update(|_| {}).unwrap();
            }
            1 => {
                win.set(Page::LABEL, "renamed".into()).unwrap();
            }
            2 => {
                win.inspector_select(target).unwrap();
            }
            3 => {
                win.resize([721, 900]).unwrap();
                win.resize([720, 900]).unwrap();
            }
            4 => {
                win.resize_scaled([720, 900], 2.).unwrap();
                win.resize_scaled([720, 900], 1.).unwrap();
            }
            5 => {
                win.presentation_lost().unwrap();
            }
            6 => {
                win.update(|m| m.show = false).unwrap();
            }
            7 => {
                win.activate(win.button("Pick element")).unwrap();
            }
            8 => {
                assert!(win.update(|m| m.broken = true).is_err());
            }
            _ => unreachable!(),
        }
        assert_eq!(
            win.pointer_event(&mut pointer, PointerEvent::Release),
            Err(Error::PresentationStale),
            "change {change}"
        );
        ack(&mut win);
        win.pointer_event(&mut pointer, PointerEvent::Release)
            .unwrap();
        assert_eq!(win.root().unwrap().calls, 0);
    }
}

#[test]
fn absent_point_encoding_preserves_finite_bits_and_public_debug_shape() {
    let mut win = page(false);
    let mut pointer = PointerSession::default();
    assert_eq!(pointer.position(), None);
    assert_eq!(
        format!("{pointer:?}"),
        "PointerSession { position: None, pressed: None }"
    );
    // Both signs, zero, subnormals, normal boundaries and maximum finite.
    let finite_bits = [
        0,
        1,
        0x007f_ffff,
        0x0080_0000,
        0x3f7f_ffff,
        0x3f80_0000,
        0x7f7f_ffff,
        0x8000_0000,
        0x8000_0001,
        0x807f_ffff,
        0x8080_0000,
        0xbf80_0000,
        0xff7f_ffff,
    ];
    for x in finite_bits {
        for y in finite_bits {
            let point = Point {
                x: f32::from_bits(x),
                y: f32::from_bits(y),
            };
            win.pointer_event(&mut pointer, PointerEvent::Move(point))
                .unwrap();
            let actual = pointer.position().unwrap();
            assert_eq!([actual.x.to_bits(), actual.y.to_bits()], [x, y]);
        }
    }
    // Include the reserved word and its predecessor: neither is finite input.
    for bits in [
        0x7f80_0000,
        0xff80_0000,
        0x7fc0_0000,
        0xffff_fffe,
        0xffff_ffff,
    ] {
        for point in [
            Point {
                x: f32::from_bits(bits),
                y: 0.,
            },
            Point {
                x: 0.,
                y: f32::from_bits(bits),
            },
        ] {
            let mut win = page(false);
            let mut pressed = press(&mut win);
            win.pointer_event(&mut pressed, PointerEvent::Move(point))
                .unwrap();
            assert_eq!(pressed.position(), None);
            ack(&mut win);
            win.pointer_event(&mut pressed, PointerEvent::Move(Point { x: 12., y: 52. }))
                .unwrap();
            win.pointer_event(&mut pressed, PointerEvent::Release)
                .unwrap();
            assert_eq!(win.root().unwrap().calls, 0);
        }
    }
    if cfg!(target_pointer_width = "64") {
        assert_eq!(size_of::<PointerSession>(), 32);
        assert_eq!(size_of::<Option<PointerSession>>(), 32);
        assert_eq!(align_of::<PointerSession>(), 8);
    }
}
