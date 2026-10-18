//! Android platform support for GPUI CE.
//!
//! The Android implementation uses the local GPUI CE workspace crates so the
//! application, window, renderer, input, and event types share one type graph.

pub use gpui;

#[cfg(any(test, target_os = "android"))]
pub(crate) mod owner_thread_registry;

#[cfg(any(test, target_os = "android"))]
mod fling_guard;
#[cfg(any(test, target_os = "android"))]
mod frame_pacer;
#[cfg(any(test, target_os = "android"))]
pub(crate) mod ime_ranges;

#[cfg(target_os = "android")]
pub mod android;

pub mod momentum;
pub mod platform_view;
mod target_platform;
pub use target_platform::{DEFAULT_PLATFORM, TargetPlatform, target_platform};

use std::sync::atomic::AtomicBool;

#[cfg(target_os = "android")]
use std::sync::atomic::Ordering;

/// Appearance of status-bar text and icons.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum StatusBarContentStyle {
    Light,
    #[default]
    Dark,
}

/// Status and navigation bar colors, expressed as 0xRRGGBB.
#[derive(Debug, Clone, Copy, PartialEq, Default)]
pub struct SystemChromeStyle {
    pub status_bar_color: Option<u32>,
    pub status_bar_style: StatusBarContentStyle,
    pub navigation_bar_color: Option<u32>,
}

/// Keyboard style used by the Android platform input adapter.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum KeyboardType {
    #[default]
    Default,
    EmailAddress,
    Phone,
    NumberPad,
    URL,
    Decimal,
}

/// Set when platform text input requires a redraw outside GPUI normal input path.
pub static TEXT_INPUT_DIRTY: AtomicBool = AtomicBool::new(false);

#[cfg(target_os = "android")]
pub(crate) fn mark_text_input_dirty() {
    TEXT_INPUT_DIRTY.store(true, Ordering::Release);
    android::frame_source::wake();
}

/// Returns the Android platform implementation.
#[cfg(target_os = "android")]
pub fn current_platform(headless: bool) -> std::rc::Rc<dyn gpui::Platform> {
    android::current_platform(headless)
}

/// Mobile platform construction is unavailable on non-Android targets.
#[cfg(not(target_os = "android"))]
pub fn current_platform(_headless: bool) -> ! {
    panic!("gpui_mobile::current_platform is available only on Android targets")
}

/// Initialize Android logging. This is a no-op on non-Android targets.
pub fn init_logger() {
    #[cfg(target_os = "android")]
    android::init_logger();
}

/// Apply the Android status and navigation bar appearance.
pub fn set_system_chrome(style: &SystemChromeStyle) {
    #[cfg(target_os = "android")]
    android::jni::set_system_chrome(style);
    #[cfg(not(target_os = "android"))]
    let _ = style;
}
