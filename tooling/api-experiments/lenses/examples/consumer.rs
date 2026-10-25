use gpui_lens_experiment::{Capability, ErasedElement, Lens};

trait Draggable {
    fn drag_payload(&mut self) -> &mut String;
}
trait HasLabel {
    type Label;
    fn label(&self) -> &Self::Label;
}

struct Card {
    payload: String,
    label: String,
}
impl Draggable for Card {
    fn drag_payload(&mut self) -> &mut String {
        &mut self.payload
    }
}
impl HasLabel for Card {
    type Label = String;
    fn label(&self) -> &String {
        &self.label
    }
}

struct Drag;
impl Lens<Card> for Drag {
    type View<'a> = &'a mut dyn Draggable;
    fn project(target: &mut Card) -> Self::View<'_> {
        target
    }
}
struct Label;
impl Lens<Card> for Label {
    type View<'a> = &'a dyn HasLabel<Label = String>;
    fn project(target: &mut Card) -> Self::View<'_> {
        target
    }
}

fn main() {
    let mut element = ErasedElement::new(Card {
        payload: "file.txt".into(),
        label: "document".into(),
    });
    element
        .capability(Capability::<Card, Drag>::new())
        .unwrap()
        .drag_payload()
        .push_str(".tmp");
    let label = element
        .capability(Capability::<Card, Label>::new())
        .unwrap();
    println!("{}", label.label());
}
