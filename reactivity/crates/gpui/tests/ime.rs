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
    let mut win = Win::recording(
        Form {
            a: Signal::new(value.into()),
            b: Signal::new("other".into()),
            rebound: false,
            broken: false,
        },
        WindowOptions::default(),
    )
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
fn cjk_preedit_replaces_original_selection_then_commits_different_text_once() {
    let (mut win, target, mut session) = window("left RIGHT tail");
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
    assert_eq!(win.read(&Form::A).unwrap(), "left RIGHT tail");
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
    assert_eq!(win.read(&Form::A).unwrap(), "left 日本語 tail");
    assert_eq!(win.snapshot().unwrap().source_epoch, epoch + 1);
    ack(&mut win);
    assert!(displayed(&win, target).1.is_none());
    assert_eq!(displayed(&win, target).2, selection(14, 14));
}
#[test]
fn interior_combining_and_zwj_byte_intent_uses_legal_geometry_and_invalid_utf8_revokes() {
    for (text, byte) in [("e\u{301}", 1), ("👩\u{200d}💻", 4), ("אבג", 2)] {
        let (mut win, target, mut session) = window("");
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
        assert!(selected.focus.offset.byte() <= text.len());
        win.ime_event(&mut session, ImeEvent::Cancel).unwrap();
        ack(&mut win);
        assert_eq!(displayed(&win, target).0, "");
        win.ime_event(&mut session, ImeEvent::Commit("late"))
            .unwrap();
        assert_eq!(win.read(&Form::A).unwrap(), "");
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
    assert_eq!(win.read(&Form::A).unwrap(), "source");
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
                win.set(&Form::A, "same".to_owned()).unwrap();
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
        assert_eq!(win.read(&Form::A).unwrap(), "same");
        assert_eq!(
            win.read(&Form::B).unwrap(),
            if mode == 1 { "same" } else { "other" }
        );
    }
}
#[test]
fn old_candidate_ack_after_failed_new_source_retains_preview_bytes_mark_and_geometry() {
    let (mut win, target, mut session) = window("base");
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
    assert_eq!(win.read(&Form::A).unwrap(), "base");
    let json = win.semantics().unwrap().to_json().unwrap();
    assert!(json.contains("base日本"));
    assert!(json.contains("marked_text"));
}
#[test]
fn commit_without_preedit_and_ordinary_keyboard_both_use_canonical_input() {
    let (mut win, target, mut session) = window("a");
    win.ime_event(&mut session, ImeEvent::Commit("é")).unwrap();
    ack(&mut win);
    assert_eq!(win.read(&Form::A).unwrap(), "aé");
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
    assert_eq!(win.read(&Form::A).unwrap(), "aé");
    win.ime_event(&mut session, ImeEvent::Disabled).unwrap();
    ack(&mut win);
    win.key(Key::Text("z")).unwrap();
    ack(&mut win);
    assert_eq!(displayed(&win, target).0, "aéz");
}
