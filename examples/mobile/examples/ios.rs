//! Native UIKit/Metal entry point for the shared mobile acceptance view.
//!
//! The platform registry selects GPUI CE's canonical `gpui_ios` backend; this
//! binary only creates the common window and contains no UIKit bridge of its own.
use gpui_ce_mobile_example::open_main_window;

fn main() {
    gpui_platform::application().run(|cx| {
        if let Err(error) = open_main_window(cx) {
            log::error!("failed to open mobile example window: {error:#}");
        }
        cx.activate(true);
    });
}
