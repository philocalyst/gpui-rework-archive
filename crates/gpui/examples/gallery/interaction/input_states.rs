//! Tab order, focus-visible styling, selection, disclosure, and real scrolling share one reusable view.
#[path = "../../shared/prelude.rs"]
mod example_prelude;
use gpui_test::gallery::interaction_scenario;

fn main() {
    let scenario = interaction_scenario().expect("valid interaction scenario");
    example_prelude::run_example(scenario).expect("run interaction states example");
}
