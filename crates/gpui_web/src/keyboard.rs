//! Keyboard layout adapter for browser-produced keystrokes.

use gpui::PlatformKeyboardLayout;

/// Keyboard-layout adapter used by the browser platform.
///
/// The implementation reports a US layout because DOM keyboard events do not provide GPUI with
/// the user's complete physical-keyboard map. Browser-produced keystrokes remain the source of
/// actual key input; this value should not be read as hardware detection.
pub struct WebKeyboardLayout;

impl PlatformKeyboardLayout for WebKeyboardLayout {
    fn id(&self) -> &str {
        "us"
    }

    fn name(&self) -> &str {
        "US"
    }
}
