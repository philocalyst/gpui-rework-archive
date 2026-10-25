//! A dense, two-thousand-row virtual list with overlapping cell decoration.
#[path = "../shared/prelude.rs"]
mod example_prelude;
use gpui_test::gallery::stress_scenario;

fn main() {
    let scenario = stress_scenario().expect("valid stress scenario");
    example_prelude::run_example(scenario).expect("run uniform list example");
}
