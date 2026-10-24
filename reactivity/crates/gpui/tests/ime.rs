//! IME uses ordinary exclusive window input, source and acknowledged query APIs.
use gpui::*;
struct Form {
    a: Signal<String>,
    b: Signal<String>,
    rebound: bool,
    broken: bool,
}
impl Form {
    const A: Source<Self, String> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
    const B: Source<Self, String> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
}
impl View for Form {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::A).direct(Self::B)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(if self.rebound { &self.b } else { &self.a })
                .w(260)
                .p(4)
                .name("first"),
            text_input(&self.b).w(260).p(4).name("second"),
            div().size(4).bg(Color::BLACK).transform(if self.broken {
                Affine::scale(0., 1.)
            } else {
                Affine::IDENTITY
            }),
        ))
    }
}
fn ack(win: &mut Win<Form>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn window(value: &str) -> (Win<Form>, Target, ImeSession) {
    window_font(value, None)
}
fn cjk_window(value: &str) -> (Win<Form>, Target, ImeSession) {
    window_font(
        value,
        Some(FontFace::new(include_bytes!("fonts/ime/cjk.otf")).unwrap()),
    )
}
fn window_font(value: &str, font: Option<FontFace>) -> (Win<Form>, Target, ImeSession) {
    let model = Form {
        a: Signal::new(value.into()),
        b: Signal::new(if font.is_some() {
            String::new()
        } else {
            "other".into()
        }),
        rebound: false,
        broken: false,
    };
    let mut win = match font {
        Some(font) => Win::recording_with_font(model, WindowOptions::default(), font),
        None => Win::recording(model, WindowOptions::default()),
    }
    .unwrap();
    ack(&mut win);
    let target = win.query().name("first").one().unwrap();
    win.focus(target).unwrap();
    ack(&mut win);
    let mut session = ImeSession::default();
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    (win, target, session)
}
fn selection(a: usize, b: usize) -> TextSelection {
    TextSelection {
        anchor: TextPosition {
            offset: TextOffset::new(a).unwrap(),
            affinity: CaretAffinity::Downstream,
        },
        focus: TextPosition {
            offset: TextOffset::new(b).unwrap(),
            affinity: CaretAffinity::Downstream,
        },
    }
}
fn displayed(win: &Win<Form>, target: Target) -> (String, Option<MarkedText>, TextSelection, Rect) {
    let mut result = None;
    win.visit(|part| {
        if part.target() == target {
            let selected = part.selection().unwrap();
            result = Some((
                part.value().unwrap().into(),
                part.marked_text(),
                selected,
                part.text_geometry()
                    .unwrap()
                    .caret_bounds(selected.focus)
                    .unwrap(),
            ));
        }
    })
    .unwrap();
    result.unwrap()
}
#[test]
fn equal_initial_preedit_clear_and_commit_keep_original_replacement() {
    let (mut win, target, mut session) = window("left RIGHT tail");
    win.select(target, selection(5, 10)).unwrap();
    ack(&mut win);
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    let epoch = win.snapshot().unwrap().source_epoch;
    for text in ["RIGHT", "", "RIGHT", ""] {
        win.ime_event(&mut session, ImeEvent::Preedit { text, cursor: None })
            .unwrap();
        ack(&mut win);
        assert_eq!(displayed(&win, target).0, "left RIGHT tail");
        assert_eq!(win.read(Form::A).unwrap(), "left RIGHT tail");
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    }
    win.ime_event(&mut session, ImeEvent::Commit("done"))
        .unwrap();
    ack(&mut win);
    assert_eq!(win.read(Form::A).unwrap(), "left done tail");
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
}
#[test]
fn tiny_preedit_on_large_source_preserves_raw_seam_cursor_and_original_replacement() {
    let prefix = format!("{}a", "x".repeat(16_380));
    let suffix = "z".repeat(16_381);
    let source = format!("{prefix}OLD{suffix}");
    assert_eq!(source.len(), 32 * 1024 - 3);
    let start = prefix.len();
    let (mut win, target, mut session) = window(&source);
    win.select(target, selection(start, start + 3)).unwrap();
    ack(&mut win);
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    let epoch = win.snapshot().unwrap().source_epoch;
    for (text, cursor) in [
        ("OLD", Some((3, 3))),
        ("\u{301}", Some((0, 0))),
        ("\u{301}", Some((2, 2))),
        ("OLD", Some((0, 0))),
        ("", None),
        ("OLD", Some((3, 3))),
    ] {
        win.ime_event(&mut session, ImeEvent::Preedit { text, cursor })
            .unwrap();
        ack(&mut win);
        let (value, mark, selected, _) = displayed(&win, target);
        assert_eq!(
            value,
            if text.is_empty() {
                source.clone()
            } else {
                format!("{prefix}{text}{suffix}")
            }
        );
        let mark = mark.unwrap();
        assert_eq!(mark.range, start..start + text.len());
        assert_eq!(mark.cursor, cursor.map(|(a, b)| start + a..start + b));
        if text == "\u{301}" && cursor == Some((0, 0)) {
            assert_eq!(selected, selection(start - 1, start - 1));
        }
        assert_eq!(win.read(Form::A).unwrap(), source.as_str());
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    }
    win.ime_event(&mut session, ImeEvent::Commit("!")).unwrap();
    ack(&mut win);
    assert_eq!(win.read(Form::A).unwrap(), &format!("{prefix}!{suffix}"));
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
}
#[test]
fn public_preedit_allocation_and_old_candidate_lifetime_workload() {
    fn event(text: &str, cursor: Option<(usize, usize)>) -> ImeEvent<'_> {
        ImeEvent::Preedit { text, cursor }
    }
    fn report(length: usize, stage: &str, cost: allocation_counter::AllocationInfo) {
        eprintln!(
            "IME_PUBLIC_COST length={length} stage={stage} allocations={} bytes={} retained={} peak={}",
            cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max
        );
    }
    for length in [24, 4096, 32 * 1024] {
        let first = "x".repeat(length - 10);
        let changed = "y".repeat(length - 10);
        let expected_first = format!("left {first} tail");
        let expected_changed = format!("left {changed} tail");
        let (mut win, target, mut session) = window("left RIGHT tail");
        win.select(target, selection(5, 10)).unwrap();
        ack(&mut win);
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        let epoch = win.snapshot().unwrap().source_epoch;
        let cost = allocation_counter::measure(|| {
            win.ime_event(&mut session, event(&first, Some((0, 0))))
                .unwrap();
        });
        report(length, "first", cost);
        assert_eq!(displayed(&win, target).0, "left RIGHT tail");
        ack(&mut win);
        assert_eq!(displayed(&win, target).0, expected_first);
        let cost = allocation_counter::measure(|| {
            win.ime_event(
                &mut session,
                event(&first, Some((first.len(), first.len()))),
            )
            .unwrap();
        });
        report(length, "cursor", cost);
        ack(&mut win);
        let old_presented = displayed(&win, target);
        let cost = allocation_counter::measure(|| {
            win.ime_event(&mut session, event(&changed, Some((0, 0))))
                .unwrap();
        });
        report(length, "changed_with_old_p", cost);
        let candidate = win.with_scene(|_, token| token).unwrap();
        assert_eq!(displayed(&win, target), old_presented);
        let cost = allocation_counter::measure(|| {
            assert_eq!(
                win.ime_event(&mut session, event("é", Some((1, 1)))),
                Err(Error::InvalidSelection)
            );
        });
        report(length, "failed_newer_releases_active", cost);
        assert!(!session.is_enabled());
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
        assert_eq!(win.read(Form::A).unwrap(), "left RIGHT tail");
        assert_eq!(displayed(&win, target), old_presented);
        win.presented(candidate).unwrap();
        assert_eq!(displayed(&win, target).0, expected_changed);
        assert_eq!(displayed(&win, target).1.unwrap().range, 5..length - 5);
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(Form::A).unwrap(), "left RIGHT tail");
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        win.ime_event(&mut session, event("", None)).unwrap();
        ack(&mut win);
        assert_eq!(displayed(&win, target).0, "left RIGHT tail");
        win.ime_event(&mut session, ImeEvent::Cancel).unwrap();
        ack(&mut win);
        assert!(displayed(&win, target).1.is_none());
    }
}
#[test]
fn cjk_preedit_replaces_original_selection_then_commits_different_text_once() {
    let (mut win, target, mut session) = cjk_window("left RIGHT tail");
    win.select(target, selection(5, 10)).unwrap();
    ack(&mut win);
    // Selection is a source-domain operation, so explicitly start a fresh stream.
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    let epoch = win.snapshot().unwrap().source_epoch;
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "に",
            cursor: Some((3, 3)),
        },
    )
    .unwrap();
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    assert_eq!(win.read(Form::A).unwrap(), "left RIGHT tail");
    assert_eq!(displayed(&win, target).0, "left RIGHT tail");
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "left に tail");
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "日本",
            cursor: Some((6, 6)),
        },
    )
    .unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "left 日本 tail");
    assert_eq!(displayed(&win, target).1.unwrap().range, 5..11);
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "",
            cursor: None,
        },
    )
    .unwrap();
    ack(&mut win);
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, ImeEvent::Commit("日本語"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "left 日本語 tail");
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
    ack(&mut win);
    assert!(displayed(&win, target).1.is_none());
    assert_eq!(displayed(&win, target).2, selection(14, 14));
}
#[test]
fn interior_combining_and_zwj_byte_intent_uses_legal_geometry_and_invalid_utf8_revokes() {
    for (text, byte, canonical) in [("e\u{301}", 1, 0), ("👩\u{200d}💻", 4, 0), ("אבג", 2, 2)]
    {
        let font = text
            .contains('👩')
            .then(|| FontFace::new(include_bytes!("fonts/ime/emoji.ttf")).unwrap());
        let (mut win, target, mut session) = window_font("", font);
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text,
                cursor: Some((byte, byte)),
            },
        )
        .unwrap();
        ack(&mut win);
        let (_, mark, selected, _) = displayed(&win, target);
        assert_eq!(mark.unwrap().cursor, Some(byte..byte));
        assert!(win.ime_cursor_area(&session).unwrap().is_some());
        assert_eq!(selected.focus.offset.byte(), canonical);
        win.ime_event(&mut session, ImeEvent::Cancel).unwrap();
        ack(&mut win);
        assert_eq!(displayed(&win, target).0, "");
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(Form::A).unwrap(), "");
    }
    let (mut win, _, mut session) = window("source");
    assert!(matches!(
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "é",
                cursor: Some((1, 1))
            }
        ),
        Err(Error::InvalidSelection)
    ));
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "source");
}
#[test]
fn external_equal_edit_rebind_and_focus_turnover_revoke_old_stream() {
    for mode in 0..3 {
        let (mut win, _, mut session) = window("same");
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "new",
                cursor: Some((3, 3)),
            },
        )
        .unwrap();
        ack(&mut win);
        match mode {
            0 => {
                win.set(Form::A, "same".to_owned()).unwrap();
            }
            1 => {
                win.update(|m| {
                    *m.b = "same".into();
                    m.rebound = true;
                })
                .unwrap();
            }
            _ => {
                let target = win.query().name("second").one().unwrap();
                win.focus(target).unwrap();
            }
        }
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(Form::A).unwrap(), "same");
        assert_eq!(
            win.read(Form::B).unwrap(),
            if mode == 1 { "same" } else { "other" }
        );
    }
}
#[test]
fn old_candidate_ack_after_failed_new_source_retains_preview_bytes_mark_and_geometry() {
    let (mut win, target, mut session) = cjk_window("base");
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "é",
            cursor: Some((2, 2)),
        },
    )
    .unwrap();
    ack(&mut win);
    let p = displayed(&win, target);
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "日本",
            cursor: Some((6, 6)),
        },
    )
    .unwrap();
    let candidate = win.with_scene(|_, token| token).unwrap();
    assert_eq!(displayed(&win, target), p);
    assert!(win.update(|m| m.broken = true).is_err());
    assert_eq!(displayed(&win, target), p);
    win.presented(candidate).unwrap();
    let current = displayed(&win, target);
    assert_eq!(current.0, "base日本");
    assert_eq!(current.1.unwrap().range, 4..10);
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "base");
    let json = win.semantics().unwrap().to_json().unwrap();
    assert!(json.contains("base日本"));
    assert!(json.contains("marked_text"));
}
#[test]
fn commit_without_preedit_and_ordinary_keyboard_both_use_canonical_input() {
    let (mut win, target, mut session) = window("a");
    win.ime_event(&mut session, ImeEvent::Commit("é")).unwrap();
    ack(&mut win);
    assert_eq!(win.read(Form::A).unwrap(), "aé");
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "pending",
            cursor: Some((7, 7)),
        },
    )
    .unwrap();
    ack(&mut win);
    win.key(Key::Text("must not duplicate")).unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "aé");
    win.ime_event(&mut session, ImeEvent::Disabled).unwrap();
    ack(&mut win);
    win.key(Key::Text("z")).unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "aéz");
}

#[test]
fn initial_font_and_same_selection_cancel_preserve_source_and_revoke_late_commit() {
    let (mut win, target, mut session) = cjk_window("日本");
    let epoch = win.snapshot().unwrap().source_epoch;
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "語",
            cursor: Some((3, 3)),
        },
    )
    .unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "日本語");
    // Preedit collapsed the source caret at its original replacement start.
    win.select(target, selection(6, 6)).unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "日本");
    assert!(displayed(&win, target).1.is_none());
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "日本");
}

#[test]
fn unsupported_preview_and_foreign_session_fail_closed_without_source_edits() {
    let (mut win, target, mut session) = window("safe");
    let (mut foreign, _, mut own) = window("elsewhere");
    foreign
        .ime_event(&mut session, ImeEvent::Commit("wrong window"))
        .unwrap();
    assert_eq!(foreign.read(Form::A).unwrap(), "elsewhere");
    foreign.ime_event(&mut own, ImeEvent::Commit("!")).unwrap();
    assert_eq!(foreign.read(Form::A).unwrap(), "elsewhere!");
    // Re-enable the original transport explicitly after its foreign use.
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "ok",
            cursor: Some((2, 2)),
        },
    )
    .unwrap();
    ack(&mut win);
    let old = displayed(&win, target);
    assert!(matches!(
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "日",
                cursor: Some((3, 3))
            }
        ),
        Err(Error::Canvas(_))
    ));
    assert_eq!(displayed(&win, target), old);
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "safe");
}

#[test]
fn pointer_preview_suffix_resolves_back_to_source_before_cancel() {
    let (mut win, target, mut session) = window("abc XYZ tail");
    win.select(target, selection(4, 7)).unwrap();
    ack(&mut win);
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "much longer",
            cursor: Some((11, 11)),
        },
    )
    .unwrap();
    ack(&mut win);
    let mut point = None;
    win.visit(|part| {
        if part.target() == target {
            let geometry = part.text_geometry().unwrap();
            let bounds = geometry.caret_bounds(selection(20, 20).focus).unwrap();
            point = Some(Point {
                x: bounds.x,
                y: bounds.y + bounds.height * 0.5,
            });
        }
    })
    .unwrap();
    let mut pointer = PointerSession::default();
    win.pointer_event(&mut pointer, PointerEvent::Move(point.unwrap()))
        .unwrap();
    win.pointer_event(&mut pointer, PointerEvent::Press)
        .unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "abc XYZ tail");
    assert_eq!(displayed(&win, target).2, selection(12, 12));
    assert!(displayed(&win, target).1.is_none());
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "abc XYZ tail");
}

#[test]
fn failed_preedit_restores_original_source_selection_and_releases_stream() {
    for failure in ["é", "日"] {
        let (mut win, target, mut session) = window("left RIGHT tail");
        let original = selection(5, 10);
        win.select(target, original).unwrap();
        ack(&mut win);
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        let epoch = win.snapshot().unwrap().source_epoch;
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "x",
                cursor: Some((1, 1)),
            },
        )
        .unwrap();
        ack(&mut win);
        let old = displayed(&win, target);
        let cursor = if failure == "é" { 1 } else { 3 };
        assert!(
            win.ime_event(
                &mut session,
                ImeEvent::Preedit {
                    text: failure,
                    cursor: Some((cursor, cursor))
                }
            )
            .is_err()
        );
        assert!(!session.is_enabled());
        assert_eq!(win.selection(target).unwrap(), original);
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
        assert_eq!(
            displayed(&win, target),
            old,
            "failed preview preserves acknowledged P"
        );
        assert!(win.ime_cursor_area(&session).unwrap().is_none());
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(Form::A).unwrap(), "left RIGHT tail");
    }
}

#[test]
fn ime_cursor_area_tracks_acknowledged_physical_transform_clip_and_dpi() {
    struct Geometry(Signal<String>);
    impl Geometry {
        const VALUE: Source<Self, String> =
            Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
    }
    impl View for Geometry {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE)
        }
        fn view(&self) -> El<'_> {
            div()
                .w(90)
                .h(50)
                .clip()
                .transform(Affine {
                    a: 1.2,
                    d: 1.1,
                    tx: 10.,
                    ty: 5.,
                    ..Affine::IDENTITY
                })
                .child(text_input(&self.0).w(150).p(4))
        }
    }
    let mut win = Win::recording_scaled(
        Geometry(Signal::new("abc".into())),
        WindowOptions {
            size: [320, 200],
            ..Default::default()
        },
        2.,
    )
    .unwrap();
    let ack = |win: &mut Win<Geometry>| {
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
    };
    ack(&mut win);
    let target = win.input();
    win.focus(target).unwrap();
    ack(&mut win);
    let mut session = ImeSession::default();
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    let old = win.ime_cursor_area(&session).unwrap();
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "ef",
            cursor: Some((2, 2)),
        },
    )
    .unwrap();
    assert_eq!(
        win.ime_cursor_area(&session).unwrap(),
        old,
        "C cannot move the native P caret"
    );
    ack(&mut win);
    let mut expected = None;
    win.visit(|part| {
        if part.target() == target {
            let geometry = part.text_geometry().unwrap();
            let map = geometry.transform().unwrap().coefficients();
            assert_eq!(map[0], f64::from(2.4_f32));
            assert_eq!(map[3], f64::from(2.2_f32));
            let caret = geometry
                .layout()
                .caret_bounds(part.selection().unwrap().focus)
                .unwrap();
            expected = geometry.visible_bounds(caret);
        }
    })
    .unwrap();
    assert!(expected.is_some());
    assert_ne!(expected, old);
    assert_eq!(win.ime_cursor_area(&session).unwrap(), expected);
    let long = "x".repeat(200);
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: &long,
            cursor: Some((200, 200)),
        },
    )
    .unwrap();
    ack(&mut win);
    assert!(
        win.ime_cursor_area(&session).unwrap().is_none(),
        "caret beyond acknowledged ancestor clip has no native area"
    );
    win.ime_event(&mut session, ImeEvent::Cancel).unwrap();
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
}

#[test]
fn long_preedit_capacity_does_not_escape_into_canonical_committed_source() {
    let (mut ordinary, _, _) = window("source");
    ordinary.key(Key::Text("!")).unwrap();
    let ordinary_capacity = ordinary.read(Form::A).unwrap().capacity();
    let (mut win, _, mut session) = window("source");
    let long = "x".repeat(4096);
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: &long,
            cursor: Some((long.len(), long.len())),
        },
    )
    .unwrap();
    ack(&mut win);
    win.ime_event(&mut session, ImeEvent::Commit("!")).unwrap();
    ack(&mut win);
    let source = win.read(Form::A).unwrap();
    assert_eq!(source, "source!");
    assert_eq!(
        source.capacity(),
        ordinary_capacity,
        "composition peak capacity must not become Source history"
    );
}

#[test]
fn own_commit_rebind_or_removal_finishes_the_valid_edit_and_revokes_stream() {
    struct Rebind {
        a: Signal<String>,
        b: Signal<String>,
    }
    impl Rebind {
        const A: Source<Self, String> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
        const B: Source<Self, String> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
    }
    impl View for Rebind {
        fn sources() -> Sources<Self> {
            Sources::new().field(Self::A).direct(Self::B)
        }
        fn view(&self) -> El<'_> {
            if self.a.as_str() == "gone" {
                button("gone")
            } else {
                text_input(if self.a.as_str() == "trigger" {
                    &self.b
                } else {
                    &self.a
                })
                .w(260)
                .name("input")
            }
        }
    }
    for committed in ["trigger", "gone"] {
        let mut win = Win::recording(
            Rebind {
                a: Signal::new("start".into()),
                b: Signal::new("trigger".into()),
            },
            WindowOptions::default(),
        )
        .unwrap();
        let acknowledge = |win: &mut Win<Rebind>| {
            win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
        };
        acknowledge(&mut win);
        let target = win.input();
        win.focus(target).unwrap();
        win.select(target, selection(0, 5)).unwrap();
        acknowledge(&mut win);
        let mut session = ImeSession::default();
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "marked",
                cursor: Some((6, 6)),
            },
        )
        .unwrap();
        acknowledge(&mut win);
        let epoch = win.snapshot().unwrap().source_epoch;
        let edit = win
            .ime_event(&mut session, ImeEvent::Commit(committed))
            .unwrap();
        assert_eq!(edit.source_epoch, epoch + 1);
        assert!(edit.prepared_epoch.is_some());
        assert!(
            !session.is_enabled(),
            "commit cannot grant authority to replacement field"
        );
        assert_eq!(win.read(Rebind::A).unwrap(), committed);
        acknowledge(&mut win);
        if committed == "trigger" {
            assert_eq!(win.query().name("input").one().unwrap(), target);
        } else {
            assert!(win.focused().unwrap().is_none());
        }
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(Rebind::B).unwrap(), "trigger");
        assert_eq!(win.read(Rebind::A).unwrap(), committed);
    }
}

#[test]
fn unshapable_commit_keeps_canonical_source_write_and_old_p_without_live_stream() {
    let (mut win, target, mut session) = window("base");
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "ok",
            cursor: Some((2, 2)),
        },
    )
    .unwrap();
    ack(&mut win);
    let old = displayed(&win, target);
    let epoch = win.snapshot().unwrap().source_epoch;
    assert!(matches!(
        win.ime_event(&mut session, ImeEvent::Commit("日")),
        Err(Error::Canvas(_))
    ));
    assert!(!session.is_enabled());
    assert_eq!(win.read(Form::A).unwrap(), "base日");
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
    assert_eq!(displayed(&win, target), old);
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "base日");
    win.set(Form::A, "fixed".to_owned()).unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "fixed");
    assert!(displayed(&win, target).1.is_none());
}

#[test]
fn cleared_preedit_resumes_keys_at_original_replacement_and_revokes_late_commit() {
    for (key, expected, caret) in [
        (Key::Text("!"), "left ! tail", 6),
        (Key::Backspace, "left  tail", 5),
        (Key::Space, "left   tail", 6),
    ] {
        let (mut win, target, mut session) = window("left RIGHT tail");
        win.select(target, selection(5, 10)).unwrap();
        ack(&mut win);
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "marked",
                cursor: Some((6, 6)),
            },
        )
        .unwrap();
        ack(&mut win);
        let p = displayed(&win, target);
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "",
                cursor: None,
            },
        )
        .unwrap();
        let cleared = win.with_scene(|_, token| token).unwrap();
        let epoch = win.snapshot().unwrap().source_epoch;
        let edit = win.key(key).unwrap();
        assert_eq!(edit.source_epoch, epoch + 1);
        assert!(edit.prepared_epoch.is_some());
        assert_eq!(win.read(Form::A).unwrap(), expected);
        let candidate = win.with_scene(|_, token| token).unwrap();
        assert_ne!(candidate, cleared);
        assert_eq!(displayed(&win, target), p);
        assert_eq!(win.presented(cleared), Err(Error::StalePresentation));
        assert_eq!(displayed(&win, target), p);
        assert!(win.ime_cursor_area(&session).unwrap().is_none());
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(Form::A).unwrap(), expected);
        assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
        win.presented(candidate).unwrap();
        let current = displayed(&win, target);
        assert_eq!(current.0, expected);
        assert!(current.1.is_none());
        assert_eq!(current.2, selection(caret, caret));
    }
}

#[test]
fn cleared_preedit_noop_key_publishes_cancel_while_control_text_stays_ignored() {
    let (mut win, target, mut session) = window("base");
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "x",
            cursor: Some((1, 1)),
        },
    )
    .unwrap();
    ack(&mut win);
    let p = displayed(&win, target);
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "",
            cursor: None,
        },
    )
    .unwrap();
    let cleared = win.with_scene(|_, token| token).unwrap();
    let epoch = win.snapshot().unwrap().source_epoch;
    win.key(Key::Text("\n")).unwrap();
    assert_eq!(win.with_scene(|_, token| token).unwrap(), cleared);
    assert!(win.ime_cursor_area(&session).unwrap().is_some());
    let cancelled = win.key(Key::Enter).unwrap();
    assert_eq!(cancelled.source_epoch, epoch);
    assert!(cancelled.prepared_epoch.is_some());
    let candidate = win.with_scene(|_, token| token).unwrap();
    assert_ne!(candidate, cleared);
    assert_eq!(displayed(&win, target), p);
    assert_eq!(win.presented(cleared), Err(Error::StalePresentation));
    assert_eq!(displayed(&win, target), p);
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::A).unwrap(), "base");
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch);
    win.presented(candidate).unwrap();
    let current = displayed(&win, target);
    assert_eq!(current.0, "base");
    assert!(current.1.is_none());
    assert_eq!(current.2, selection(4, 4));
}
