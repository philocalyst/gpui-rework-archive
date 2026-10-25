use gpui_composition_api_experiment::{Card, DraggableBadge};

#[inline(never)]
fn edit<T: DraggableBadge>(value: &mut T) {
    value.set_payload(format!("{}:{}", value.payload(), value.badge_count()));
}

fn main() {
    let mut card = Card::new("item", 2);
    edit(&mut card);
    std::hint::black_box(card);
}
