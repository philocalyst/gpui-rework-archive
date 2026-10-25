use gpui::{AnyElement, IntoElement, Select, SelectableElement};

struct Card {
    label: String,
}

// The selector itself performs the concrete downcast and lends only `&mut Card`.
fn typed_query(element: AnyElement) -> impl IntoElement {
    element.select_mut(Select::this().of::<Card>(), |card| {
        card.label.clone_from(&"selected".to_owned());
    })
}

// The default borrowed reflected view also offers an optional concrete downcast.
fn downcast_from_view(element: AnyElement) -> impl IntoElement {
    element.select_mut(Select::this(), |mut view| {
        if let Some(card) = view.downcast_mut::<Card>() {
            card.label.clone_from(&"selected".to_owned());
        }
    })
}

fn main() {}
