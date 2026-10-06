//! Tab order, focus-visible styling, selection, disclosure, and real scrolling share one reusable view.
#[path = "../../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, AppContext as _};
use gpui_test::gallery::InteractionScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(560., 500., cx);
        cx.open_window(options, |_, cx| cx.new(InteractionScenario::new))
            .expect("open interaction example window");
        example_prelude::init_example(cx, "Interaction states");
    });
}
