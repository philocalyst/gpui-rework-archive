//! A dense, two-thousand-row virtual list with overlapping cell decoration.
#[path = "../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, AppContext as _};
use gpui_test::gallery::StressScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(460., 540., cx);
        cx.open_window(options, |_, cx| cx.new(|_| StressScenario))
            .expect("open stress example window");
        example_prelude::init_example(cx, "Virtualized rows and overlap");
    });
}
