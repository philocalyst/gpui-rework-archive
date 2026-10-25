use gpui_composition_api_experiment::{DragLabel, LabeledGroup};

struct Both;
impl DragLabel for Both {
    fn label(&self) -> &'static str {
        "drag"
    }
}
impl gpui_composition_api_experiment::BadgeLabel for Both {
    fn label(&self) -> &'static str {
        "badge"
    }
}

fn main() {
    let both = Both;
    let group: &dyn LabeledGroup = &both;
    let _ = group.label(); // expected: multiple applicable methods
}
