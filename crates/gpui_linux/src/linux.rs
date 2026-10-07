#[cfg(any(feature = "wayland", feature = "x11"))]
mod character_palette;
mod dispatcher;
mod headless;
mod keyboard;
mod platform;
mod system_notifications;
#[cfg(feature = "wayland")]
mod wayland;
#[cfg(feature = "x11")]
mod x11;

#[cfg(any(feature = "wayland", feature = "x11"))]
mod xdg_desktop_portal;

pub use dispatcher::*;
pub(crate) use headless::*;
pub(crate) use keyboard::*;
pub(crate) use platform::*;
#[cfg(feature = "wayland")]
pub(crate) use wayland::*;
#[cfg(feature = "x11")]
pub(crate) use x11::*;

use std::rc::Rc;

/// Creates the Linux/FreeBSD platform implementation selected from the process environment.
///
/// `headless` bypasses Wayland/X11 and selects a synthetic display for non-visual app and test
/// work. Otherwise `ZED_HEADLESS` selects headless mode, then a non-empty `WAYLAND_DISPLAY`
/// selects Wayland when enabled, then `DISPLAY` selects X11 when enabled. This constructor does
/// not return a `Result`; connection or backend setup failures can panic. See the
/// [platform guide](https://docs.rs/gpui-ce/0.2.2/gpui/_documentation/platforms/index.html) for
/// target-specific service behavior.
pub fn current_platform(headless: bool) -> Rc<dyn gpui::Platform> {
    #[cfg(feature = "x11")]
    use anyhow::Context as _;

    if headless {
        return Rc::new(LinuxPlatform {
            inner: HeadlessClient::new(),
        });
    }

    match gpui::guess_compositor() {
        #[cfg(feature = "wayland")]
        "Wayland" => Rc::new(LinuxPlatform {
            inner: WaylandClient::new(),
        }),

        #[cfg(feature = "x11")]
        "X11" => Rc::new(LinuxPlatform {
            inner: X11Client::new()
                .context("Failed to initialize X11 client.")
                .unwrap(),
        }),

        "Headless" => Rc::new(LinuxPlatform {
            inner: HeadlessClient::new(),
        }),
        _ => unreachable!(
            r#"At least one of the "wayland" or "x11" features must be enabled on gpui_linux or gpui_platform."#
        ),
    }
}
