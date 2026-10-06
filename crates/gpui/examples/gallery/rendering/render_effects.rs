//! Clipping, opacity, gradients, paths, and filter grouping in one reusable paint scenario.
#[path = "../../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, AppContext as _};
use gpui_test::gallery::EffectsScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(480., 420., cx);
        cx.open_window(options, |_, cx| cx.new(|_| EffectsScenario))
            .expect("open rendering effects example window");
        example_prelude::init_example(cx, "Rendering effects");
    });
}
