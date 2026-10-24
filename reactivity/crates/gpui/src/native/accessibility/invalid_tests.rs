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
