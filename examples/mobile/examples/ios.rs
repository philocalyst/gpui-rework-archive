//! The iOS example app. `gpui_platform` selects the iOS backend, so this only opens the
//! shared window.
use gpui_ce_mobile_example::open_main_window;

fn main() {
    gpui_platform::application().run(|cx| {
        if let Err(error) = open_main_window(cx) {
            log::error!("failed to open mobile example window: {error:#}");
        }
        cx.activate(true);
    });
}
