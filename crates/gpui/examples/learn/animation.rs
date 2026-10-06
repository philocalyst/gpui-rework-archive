//! Animation example. The view is also shared with the deterministic regression gallery.

#[path = "../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, prelude::*};
use gpui_test::gallery::AnimationScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(520., 260., cx);
        cx.open_window(options, |_, cx| cx.new(|_| AnimationScenario))
            .expect("open animation example window");
        example_prelude::init_example(cx, "Animation");
    });
}
