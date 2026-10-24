//! Component state and styling use the same public IME admission boundary.
use gpui::{
    BoolBinding, BoolInput, El, Error, FieldId, ImeEvent, ImeSession, MarkedText, Signal,
    SignalMap, Source, Sources, Target, View, Win, WindowOptions,
};
use gpui_component::{Input, Theme};

struct Form {
    first: Signal<String>,
    second: Signal<String>,
    gate: Signal<f64>,
    palette: Signal<bool>,
    rebound: bool,
    theme: Theme,
}
impl Form {
    const FIRST: Source<Self, String> =
        Source::new(FieldId::new(1), "first", |m| &m.first, |m| &mut m.first);
    const SECOND: Source<Self, String> =
        Source::new(FieldId::new(2), "second", |m| &m.second, |m| &mut m.second);
    const GATE: Source<Self, f64> =
        Source::new(FieldId::new(3), "gate", |m| &m.gate, |m| &mut m.gate);
    const PALETTE: Source<Self, bool> = Source::new(
        FieldId::new(4),
        "palette",
        |m| &m.palette,
        |m| &mut m.palette,
    );
}
impl View for Form {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::FIRST)
            .direct(Self::SECOND)
            .direct(Self::GATE)
            .direct(Self::PALETTE)
    }
    fn view(&self) -> El<'_> {
        let controls = BoolBinding::new(self.gate.map(|n| *n < 1.0));
        let state = controls.state();
        let paint = BoolBinding::new(&self.palette);
        let painted = paint.state();
        let input = Input::new(
            if self.rebound {
                &self.second
            } else {
                &self.first
            },
            "Title",
            &self.theme,
        )
        .invalid(state);
        let input = input.disabled(state);
        let root = gpui::column((input.build(),))
            .w(&self.gate)
            .bg(painted.select(self.theme.surface(), self.theme.raised()));
        controls.attach(paint.attach(root))
    }
}
fn ack(win: &mut Win<Form>) {
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
}
fn window() -> (Win<Form>, Target, ImeSession) {
    let mut win = Win::recording(
        Form {
            first: Signal::new("base".into()),
            second: Signal::new("other".into()),
            gate: Signal::new(280.0),
            palette: Signal::new(false),
            rebound: false,
            theme: Theme::halloween(),
        },
        WindowOptions::default(),
    )
    .unwrap();
    ack(&mut win);
    let target = win.query().name("Title").one().unwrap();
    win.focus(target).unwrap();
    ack(&mut win);
    let mut session = ImeSession::default();
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    win.ime_event(
        &mut session,
        ImeEvent::Preedit {
            text: "ghost",
            cursor: Some((5, 5)),
        },
    )
    .unwrap();
    ack(&mut win);
    (win, target, session)
}
fn shown(win: &Win<Form>, target: Target) -> (String, Option<MarkedText>, bool, bool) {
    let mut result = None;
    win.visit(|part| {
        if part.target() == target {
            result = Some((
                part.value().unwrap().to_owned(),
                part.marked_text(),
                part.disabled(),
                part.invalid(),
            ));
        }
    })
    .unwrap();
    result.unwrap()
}
#[test]
fn disable_revokes_preedit_before_ack_and_never_reenables_old_stream() {
    let (mut win, target, mut session) = window();
    let old = shown(&win, target);
    assert_eq!(old.0, "baseghost");
    assert!(old.1.is_some());
    assert!(!old.2 && !old.3);
    let json = win.semantics().unwrap().to_json().unwrap();
    assert!(json.contains("marked_text"));
    assert!(json.contains("\"disabled\":false,\"invalid\":false"));
    win.set(Form::GATE, 0.5).unwrap();
    assert_eq!(shown(&win, target), old);
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    assert!(matches!(win.focus(target), Err(Error::NotInteractive)));
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
    ack(&mut win);
    assert_eq!(shown(&win, target), ("base".into(), None, true, true));
    let json = win.semantics().unwrap().to_json().unwrap();
    assert!(!json.contains("marked_text"));
    assert!(json.contains("\"disabled\":true,\"invalid\":true"));
    win.set(Form::GATE, 280.0).unwrap();
    ack(&mut win);
    win.focus(target).unwrap();
    win.ime_event(&mut session, ImeEvent::Commit("still late"))
        .unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    win.ime_event(&mut session, ImeEvent::Commit("!")).unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base!");
}
#[test]
fn rebinding_component_during_preedit_does_not_transfer_the_old_source_lease() {
    let (mut win, target, mut session) = window();
    let old = shown(&win, target);
    win.update(|model| model.rebound = true).unwrap();
    assert_eq!(shown(&win, target), old);
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
    assert_eq!(win.read(Form::SECOND).unwrap(), "other");
    ack(&mut win);
    assert_eq!(shown(&win, target), ("other".into(), None, false, false));
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    win.ime_event(&mut session, ImeEvent::Commit("!")).unwrap();
    assert_eq!(win.read(Form::SECOND).unwrap(), "other!");
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
}
#[test]
fn eligible_disabled_invalid_candidate_after_newer_failure_carries_no_ime_authority() {
    let (mut win, target, mut session) = window();
    let old = shown(&win, target);
    win.set(Form::GATE, 0.5).unwrap();
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert_eq!(shown(&win, target), old);
    assert!(win.set(Form::GATE, f64::NAN).is_err());
    assert_eq!(shown(&win, target), old);
    win.presented(eligible).unwrap();
    assert_eq!(shown(&win, target), ("base".into(), None, true, true));
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
    win.set(Form::GATE, 280.0).unwrap();
    ack(&mut win);
    let repaired = win.query().name("Title").one().unwrap();
    assert_ne!(repaired, target);
    win.focus(repaired).unwrap();
    win.ime_event(&mut session, ImeEvent::Commit("still late"))
        .unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
}
#[test]
fn paint_only_cohort_admission_cancels_preedit_and_publishes_its_removal() {
    let (mut win, target, mut session) = window();
    let old = shown(&win, target);
    win.reset_counters().unwrap();
    let committed = win.set(Form::PALETTE, true).unwrap();
    assert!(committed.prepared_epoch.is_some());
    assert_eq!(win.counters().descriptions, 0);
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(shown(&win, target), old);
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base");
    ack(&mut win);
    assert_eq!(shown(&win, target), ("base".into(), None, false, false));
    win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
    win.ime_event(&mut session, ImeEvent::Commit("!")).unwrap();
    assert_eq!(win.read(Form::FIRST).unwrap(), "base!");
}
