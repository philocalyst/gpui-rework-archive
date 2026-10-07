//! Demonstrates a foreground task awaiting background work and cancellation.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui_test::gallery::tasks_scenario;

fn main() {
    let scenario = tasks_scenario().expect("valid async task scenario");
    example_prelude::run_example(scenario).expect("run async task example");
}
