//! Demonstrates a foreground task awaiting background work and cancellation.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::App;
use gpui_test::gallery::AsyncTaskScenario;

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(360., 220., cx);
        cx.open_window(options, |_, cx| cx.new(|_| AsyncTaskScenario::new()))
            .expect("Failed to open window");

        example_prelude::init_example(cx, "Async Tasks");
    });
}
