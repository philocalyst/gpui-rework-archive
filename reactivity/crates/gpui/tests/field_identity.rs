use gpui::{El, FieldId, Role, Signal, Source, Sources, View, Win, column, text_input};

struct Edges {
    zero: Signal<String>,
    maximum: Signal<String>,
}
impl Edges {
    const ZERO: Source<Self, String> =
        Source::new(FieldId::new(0), "zero", |m| &m.zero, |m| &mut m.zero);
    const MAXIMUM: Source<Self, String> = Source::new(
        FieldId::new(u32::MAX),
        "maximum",
        |m| &m.maximum,
        |m| &mut m.maximum,
    );
}
impl View for Edges {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::ZERO).direct(Self::MAXIMUM)
    }
    fn view(&self) -> El<'_> {
        column((text_input(&self.zero), text_input(&self.maximum)))
    }
}

#[test]
fn public_local_id_extremes_route_independent_input_and_direct_updates() {
    let mut win = Win::demo(Edges {
        zero: Signal::new("zero".into()),
        maximum: Signal::new("maximum".into()),
    });
    let zero = win.role(Role::TextInput).text("zero").one().unwrap();
    let maximum = win.role(Role::TextInput).text("maximum").one().unwrap();
    win.type_text(zero, "first").unwrap();
    assert_eq!(win.root().unwrap().zero.as_str(), "zerofirst");
    assert_eq!(win.root().unwrap().maximum.as_str(), "maximum");
    win.type_text(maximum, "last").unwrap();
    assert_eq!(win.root().unwrap().zero.as_str(), "zerofirst");
    assert_eq!(win.root().unwrap().maximum.as_str(), "maximumlast");
    win.set(Edges::ZERO, "changed first".to_owned()).unwrap();
    win.set(Edges::MAXIMUM, "changed last".to_owned()).unwrap();
    assert_eq!(
        win.role(Role::TextInput)
            .text("changed first")
            .one()
            .unwrap(),
        zero
    );
    assert_eq!(
        win.role(Role::TextInput)
            .text("changed last")
            .one()
            .unwrap(),
        maximum
    );
    assert_eq!(win.counters().descriptions, 1);
    assert_eq!(win.counters().exact_updates, 4);
}
