//! Compare the actual native projection with the acknowledged public sheet.
use super::*;
use crate::{
    BoolBinding, BoolInput, El, FieldId, Signal, SignalMap, Source, Sources, WindowOptions,
};
struct Page {
    value: Signal<String>,
    number: Signal<f64>,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const NUMBER: Source<Self, f64> =
        Source::new(FieldId::new(2), "number", |m| &m.number, |m| &mut m.number);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::NUMBER)
    }
    fn view(&self) -> El<'_> {
        let binding = BoolBinding::new(self.number.map(|n| *n < 1.0));
        let state = binding.state();
        binding.attach(
            crate::div()
                .w(&self.number)
                .bg(state.select(crate::Color::BLACK, crate::Color::WHITE))
                .child(
                    crate::text_input(&self.value)
                        .name("Validated")
                        .w(100)
                        .h(25)
                        .invalid(state),
                ),
        )
    }
}
fn invalid_node(win: &Win<Page>) -> Option<accesskit::Invalid> {
    let mut cohort = Cohort::default();
    cohort.refresh(win).unwrap();
    let sheet = win.accessibility_sheet().unwrap();
    let update = project(
        &sheet,
        win.accessibility_state().unwrap(),
        "Validation",
        &cohort,
    );
    let (_, input) = update
        .nodes
        .iter()
        .find(|(_, node)| node.role() == accesskit::Role::TextInput)
        .unwrap();
    input.invalid()
}
#[test]
fn native_invalid_projection_preserves_old_p_and_failed_candidate_barriers() {
    let mut w = Win::recording(
        Page {
            value: Signal::new("Draft".into()),
            number: Signal::new(2.0),
        },
        WindowOptions::default(),
    )
    .unwrap();
    let token = w.with_scene(|_, t| t).unwrap();
    w.presented(token).unwrap();
    assert_eq!(invalid_node(&w), None);
    w.set(Page::NUMBER, 0.5).unwrap();
    let older = w.with_scene(|_, t| t).unwrap();
    assert_eq!(invalid_node(&w), None);
    assert!(w.set(Page::NUMBER, f64::NAN).is_err());
    assert_eq!(invalid_node(&w), None);
    w.presented(older).unwrap();
    assert_eq!(invalid_node(&w), Some(accesskit::Invalid::True));
    w.set(Page::NUMBER, 2.0).unwrap();
    assert_eq!(invalid_node(&w), Some(accesskit::Invalid::True));
    let token = w.with_scene(|_, t| t).unwrap();
    w.presented(token).unwrap();
    assert_eq!(invalid_node(&w), None);
}

#[test]
fn ime_disabled_invalid_projection_keeps_p_and_eligible_c_without_live_edit_actions() {
    struct Input {
        value: Signal<String>,
        gate: Signal<f64>,
    }
    impl Input {
        const VALUE: Source<Self, String> =
            Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
        const GATE: Source<Self, f64> =
            Source::new(FieldId::new(2), "gate", |m| &m.gate, |m| &mut m.gate);
    }
    impl View for Input {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE).direct(Self::GATE)
        }
        fn view(&self) -> El<'_> {
            let binding = BoolBinding::new(self.gate.map(|n| *n < 1.0));
            let state = binding.state();
            binding.attach(
                crate::div().w(&self.gate).child(
                    crate::text_input(&self.value)
                        .name("Title")
                        .w(180)
                        .disabled(state)
                        .invalid(state),
                ),
            )
        }
    }
    fn node(win: &Win<Input>) -> accesskit::Node {
        let mut cohort = Cohort::default();
        cohort.refresh(win).unwrap();
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "IME controls",
            &cohort,
        )
        .nodes
        .into_iter()
        .find(|(_, node)| node.role() == accesskit::Role::TextInput)
        .unwrap()
        .1
    }
    let mut win = Win::recording(
        Input {
            value: Signal::new("base".into()),
            gate: Signal::new(280.0),
        },
        WindowOptions::default(),
    )
    .unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let target = win.query().name("Title").one().unwrap();
    win.focus(target).unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let mut session = crate::ImeSession::default();
    win.ime_event(&mut session, crate::ImeEvent::Enabled)
        .unwrap();
    win.ime_event(
        &mut session,
        crate::ImeEvent::Preedit {
            text: "ghost",
            cursor: Some((5, 5)),
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let old = node(&win);
    assert_eq!(old.value(), Some("baseghost"));
    assert!(!old.is_disabled());
    assert_eq!(old.invalid(), None);
    assert!(old.is_read_only());
    win.set(Input::GATE, 0.5).unwrap();
    let eligible = win.with_scene(|_, t| t).unwrap();
    assert_eq!(node(&win), old);
    assert!(win.set(Input::GATE, f64::NAN).is_err());
    assert_eq!(node(&win), old);
    win.presented(eligible).unwrap();
    let acknowledged = node(&win);
    assert_eq!(acknowledged.value(), Some("base"));
    assert!(acknowledged.is_disabled());
    assert_eq!(acknowledged.invalid(), Some(accesskit::Invalid::True));
    assert!(acknowledged.is_read_only());
    for action in [
        accesskit::Action::Focus,
        accesskit::Action::SetValue,
        accesskit::Action::SetTextSelection,
        accesskit::Action::ReplaceSelectedText,
    ] {
        assert!(!acknowledged.supports_action(action));
    }
    assert!(win.ime_cursor_area(&session).unwrap().is_none());
    win.ime_event(&mut session, crate::ImeEvent::Commit("late"))
        .unwrap();
    assert_eq!(win.read(Input::VALUE).unwrap(), "base");
}
