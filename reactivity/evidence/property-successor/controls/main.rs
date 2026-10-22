use gpui::{Error, PropertyChange, View, El, Win, Target, button, row, property_action, property::{PropertyId, PropertyValue, Contribution}};
#[derive(Default)]
struct Model { target: Option<Target>, replies: usize }
impl Model {
    fn ordinary(&mut self) { self.replies += 1; }
    fn propose(&self) -> Option<PropertyChange> {
        Some((self.target?, PropertyId::Width, Contribution::Set(PropertyValue::Dimension(Some(80.)))))
    }
    fn reply<T>(&mut self, result: Result<T, &Error>) { assert!(result.is_ok()); self.replies += 1; }
}
impl View for Model {
    fn view(&self) -> El<'_> {
        let subject = button("Subject").w(80).h(32);
        #[cfg(feature="selection")]
        let subject = subject.on_click(gpui::property_selection(|_: &Self, own|Some((own,PropertyId::Width)), Self::reply));
        #[cfg(not(feature="selection"))]
        let subject = subject.on_click(Self::ordinary);
        #[cfg(feature="property")]
        let action = button("Action").on_click(property_action(Self::propose, Self::reply));
        #[cfg(not(feature="property"))]
        let action = button("Action").on_click(Self::ordinary);
        row((subject, action))
    }
}
fn main() {
    let mut owner = Win::with_size(Model::default(), 240, 120).unwrap();
    let subject = owner.button("Subject");
    owner.update(|model| model.target = Some(subject)).unwrap();
    #[cfg(feature="selection")]
    let target = subject;
    #[cfg(not(feature="selection"))]
    let target = owner.button("Action");
    for _ in 0..3 { owner.activate(target).unwrap(); }
    assert_eq!(owner.root().unwrap().replies, 3);
    assert_eq!(owner.property_value(subject, PropertyId::Width).unwrap(), PropertyValue::Dimension(Some(80.)));
    println!("replies=3 width=80");
}
