use gpui_composition_api_experiment::{
    Badge, Card, Draggable, DraggableBadge, edit_erased_group, fluent_query, with_group_bound,
};

fn main() {
    let mut card = Card::new("item", 2);
    with_group_bound(&mut card);
    let erased: &mut dyn DraggableBadge = &mut card;
    edit_erased_group(erased);
    let _query = fluent_query();
    // Methods from the individual traits are available on the composed object.
    let mut card = Card::new("item", 2);
    Draggable::set_payload(&mut card, "new".into());
    assert_eq!(Badge::badge_count(&card), 2);
}
