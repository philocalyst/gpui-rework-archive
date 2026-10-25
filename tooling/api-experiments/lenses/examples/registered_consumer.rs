use gpui_lens_experiment::registry::{RegisteredElement, RegistryCapability, RegistryLens, Schema};
use std::sync::{Arc, LazyLock};

trait Draggable {
    fn payload(&mut self) -> &mut String;
}
struct Card(String);
struct Pill(String);
impl Draggable for Card {
    fn payload(&mut self) -> &mut String {
        &mut self.0
    }
}
impl Draggable for Pill {
    fn payload(&mut self) -> &mut String {
        &mut self.0
    }
}
struct Drag;
impl RegistryLens<Card, dyn Draggable> for Drag {
    fn project<'a>(card: &'a mut Card) -> &'a mut (dyn Draggable + 'static) {
        card
    }
}
impl RegistryLens<Pill, dyn Draggable> for Drag {
    fn project<'a>(pill: &'a mut Pill) -> &'a mut (dyn Draggable + 'static) {
        pill
    }
}

static CARD_SCHEMA: LazyLock<Arc<Schema<Card>>> = LazyLock::new(|| {
    let mut builder = Schema::builder();
    builder.register(RegistryCapability::<dyn Draggable, Drag>::new());
    Arc::new(builder.build())
});
static PILL_SCHEMA: LazyLock<Arc<Schema<Pill>>> = LazyLock::new(|| {
    let mut builder = Schema::builder();
    builder.register(RegistryCapability::<dyn Draggable, Drag>::new());
    Arc::new(builder.build())
});

fn main() {
    let drag = RegistryCapability::<dyn Draggable, Drag>::new();
    let mut elements = vec![
        RegisteredElement::new(Card("card".into()), CARD_SCHEMA.clone()),
        RegisteredElement::new(Pill("pill".into()), PILL_SCHEMA.clone()),
    ];
    for element in &mut elements {
        if element.has(drag) {
            element.get(drag).unwrap().payload().push('!');
        }
    }
    println!(
        "{} registered elements support dragging",
        elements.iter().filter(|e| e.has(drag)).count()
    );
}
