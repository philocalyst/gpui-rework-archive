use gpui::{
    Error, PropertyState,
    prelude::*,
    property::{Contribution, PropertyId, PropertyValue},
    property_selection,
};
#[derive(Default)]
struct Page {
    destination: Option<Target>,
    state: Option<PropertyState>,
}
impl Page {
    fn inspect(&self, _: Target) -> Option<(Target, PropertyId)> {
        Some((self.destination?, PropertyId::Width))
    }
    fn receive(&mut self, state: Result<PropertyState, &Error>) {
        self.state = Some(state.unwrap());
    }
}
impl View for Page {
    fn view(&self) -> El<'_> {
        button("Read selected width").on_click(property_selection(Self::inspect, Self::receive))
    }
}
#[test]
fn private_inspector_shell_keeps_canonical_width_distinct_from_stored_set() {
    let mut win = Win::with_inspector(
        Page::default(),
        gpui::WindowOptions {
            size: [800, 400],
            ..Default::default()
        },
    )
    .unwrap();
    let panel = win
        .role(gpui::Role::ScrollView)
        .name("GPUI Inspector")
        .one()
        .unwrap();
    win.set_property(
        panel,
        gpui::property::WIDTH,
        Contribution::Set(gpui::Length::Points(111.)),
    )
    .unwrap();
    assert_eq!(
        win.property(panel, gpui::property::WIDTH).unwrap(),
        Length::Points(320.)
    );
    assert_eq!(
        win.contribution(panel, gpui::property::WIDTH).unwrap(),
        Contribution::Set(gpui::Length::Points(111.))
    );
    win.update(|model| model.destination = Some(panel)).unwrap();
    win.activate(win.button("Read selected width")).unwrap();
    let state = win.root().unwrap().state.unwrap();
    assert_eq!(
        state.value,
        PropertyValue::Dimension(gpui::Length::Points(320.))
    );
    assert_eq!(
        state.contribution,
        Contribution::Set(PropertyValue::Dimension(gpui::Length::Points(111.)))
    );
    println!(
        "PROPERTY_SHELL canonical=320 stored_Set=111; deriving Set(canonical) would lose author state"
    );
}
