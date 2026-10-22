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
fn built_in_inspector_requires_ack_because_epoch_captions_can_change_layout() {
    let mut win = page(true);
    let mut pointer = press(&mut win);
    assert_eq!(
        win.pointer_event(&mut pointer, PointerEvent::Release),
        Err(Error::PresentationStale)
    );
    ack(&mut win);
    win.pointer_event(&mut pointer, PointerEvent::Press)
        .unwrap();
    win.pointer_event(&mut pointer, PointerEvent::Release)
        .unwrap();
    assert_eq!(win.root().unwrap().calls, 1);
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
    for point in [
        Point { x: -0., y: 0. },
        Point { x: 0., y: -0. },
        Point {
            x: f32::from_bits(1),
            y: -f32::from_bits(1),
        },
    ] {
        win.pointer_event(&mut pointer, PointerEvent::Move(point))
            .unwrap();
        let actual = pointer.position().unwrap();
        assert_eq!(
            [actual.x.to_bits(), actual.y.to_bits()],
            [point.x.to_bits(), point.y.to_bits()]
        );
    }
    for point in [
        Point { x: f32::NAN, y: 0. },
        Point {
            x: 0.,
            y: f32::INFINITY,
        },
        Point {
            x: f32::NEG_INFINITY,
            y: 0.,
        },
    ] {
        win.pointer_event(&mut pointer, PointerEvent::Move(point))
            .unwrap();
        assert_eq!(pointer.position(), None);
    }
    if cfg!(target_pointer_width = "64") {
        assert_eq!(size_of::<PointerSession>(), 32);
        assert_eq!(align_of::<PointerSession>(), 8);
    }
}
