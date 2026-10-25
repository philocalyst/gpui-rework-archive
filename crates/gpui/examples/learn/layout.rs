//! Layout patterns. The view is shared with the deterministic regression gallery.

#[path = "../shared/prelude.rs"]
mod example_prelude;
use gpui_test::gallery::layout_scenario;

fn main() {
    env_logger::init();
    let scenario = layout_scenario().expect("valid layout scenario");
    example_prelude::run_example(scenario).expect("run layout example");
}
