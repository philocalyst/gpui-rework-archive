#![cfg(target_family = "wasm")]
//! Browser support for GPUI applications.
//!
//! `gpui_ce_web` adapts browser event, window, display, keyboard, fetch, and
//! dispatch APIs to GPUI's platform traits. Applications normally use the
//! constructors re-exported by `gpui_ce_platform`; these types are useful when
//! embedding GPUI into an existing browser runtime.

//! GPUI's browser platform uses one document-owned canvas and supports one top-level window.
//! Browser WebGPU is preferred by default, with an automatic WebGL2 fallback. Applications can
//! force either backend with [`WebBackendPreference`]. Opening a second top-level window, or
//! reopening one after it closes, returns [`WebWindowError`].

mod dispatcher;
mod display;
mod events;
mod http_client;
mod ime_mirror;
mod keyboard;
mod logging;
mod platform;
mod window;

pub use dispatcher::WebDispatcher;
pub use display::WebDisplay;
pub use gpui_wgpu::WebBackendPreference;
pub use http_client::FetchHttpClient;
pub use keyboard::WebKeyboardLayout;
pub use logging::init_logging;
pub use platform::{WebPlatform, WebWindowError};
pub use window::WebWindow;
