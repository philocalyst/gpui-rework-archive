//! Layout patterns. The view is shared with the deterministic regression gallery.

#[path = "../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, prelude::*};
use gpui_test::gallery::LayoutScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(680., 420., cx);
        cx.open_window(options, |_, cx| cx.new(|_| LayoutScenario))
            .expect("open layout example window");
        example_prelude::init_example(cx, "Layout");
    });
}
