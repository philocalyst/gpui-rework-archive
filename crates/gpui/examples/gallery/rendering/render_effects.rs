//! Clipping, opacity, gradients, paths, and filter grouping in one reusable paint scenario.
#[path = "../../shared/prelude.rs"]
mod example_prelude;
use gpui_test::gallery::effects_scenario;

fn main() {
    env_logger::init();
    let scenario = effects_scenario().expect("valid effects scenario");
    example_prelude::run_example(scenario).expect("run rendering effects example");
}
