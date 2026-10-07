//! Embedded monochrome SVG and procedural raster media, shared with regression captures.
#[path = "../../../shared/prelude.rs"]
mod example_prelude;
use gpui_test::gallery::media_scenario;

fn main() {
    let scenario = media_scenario().expect("valid media scenario");
    example_prelude::run_example(scenario).expect("run media example");
}
