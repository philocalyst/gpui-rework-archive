//! Embedded monochrome SVG and procedural raster media, shared with regression captures.
#[path = "../../../shared/prelude.rs"]
mod example_prelude;
use gpui::{App, AppContext as _};
use gpui_test::gallery::MediaScenario;

fn main() {
    env_logger::init();
    gpui_platform::application().run(|cx: &mut App| {
        let options = example_prelude::centered_window(380., 250., cx);
        cx.open_window(options, |_, cx| cx.new(|_| MediaScenario))
            .expect("open media example window");
        example_prelude::init_example(cx, "Bundled media");
    });
}
