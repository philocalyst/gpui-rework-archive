//! Text styling, mixed scripts, inline highlights, and wrapping in one compact view.

#[path = "../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, prelude::*};
use gpui_test::gallery::TextScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(560., 360., cx);
        cx.open_window(options, |_, cx| cx.new(|_| TextScenario))
            .expect("open text example window");
        example_prelude::init_example(cx, "Text");
    });
}
