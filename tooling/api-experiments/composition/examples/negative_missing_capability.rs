use gpui_composition_api_experiment::{DraggableBadge, Satisfies};

struct OnlyDraggable;
impl gpui_composition_api_experiment::Draggable for OnlyDraggable {
    fn payload(&self) -> &str {
        ""
    }
    fn set_payload(&mut self, _: String) {}
}

fn needs_both<T: Satisfies<dyn DraggableBadge>>(_: T) {}

fn main() {
    needs_both(OnlyDraggable);
}
