use gpui::reflection::{Reflect, reflect_trait};
use gpui::{AnyElement, IntoElement, ParentElement, Select, SelectableElement, div};

#[reflect_trait]
trait Draggable {
    fn set_payload(&mut self, payload: String);
}
#[reflect_trait]
trait Badge {
    fn badge_count(&self) -> usize;
}

#[derive(Reflect)]
#[reflect(Draggable, Badge)]
struct Card;
impl Draggable for Card {
    fn set_payload(&mut self, _payload: String) {}
}
impl Badge for Card {
    fn badge_count(&self) -> usize {
        1
    }
}

// Intentional negative probe for the legacy form. Positive tuple and `.and(...)`
// alternatives live in `compositions_positive.rs`.
fn repeated_reflects_is_rejected(element: AnyElement) -> impl IntoElement {
    div().child(element).select_mut(
        Select::this().reflects(Draggable).reflects(Badge),
        |mut view| {
            view.with(Draggable, |mut draggable| draggable.set_payload("x".into()));
            view.with(Badge, |badge| {
                let _ = badge.badge_count();
            });
        },
    )
}

fn main() {}
