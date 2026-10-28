//! GPUI's browser platform uses one document-owned canvas and supports one top-level window.
//! Browser WebGPU is preferred by default, with an automatic WebGL2 fallback. Applications can
//! force either backend with `WebBackendPreference`. Opening a second top-level window, or
//! reopening one after it closes, returns `WebWindowError`.

#[cfg(target_family = "wasm")]
mod dispatcher;
#[cfg(target_family = "wasm")]
mod display;
#[cfg(target_family = "wasm")]
mod events;
#[cfg(target_family = "wasm")]
mod http_client;
#[cfg(target_family = "wasm")]
mod ime_mirror;
#[cfg(target_family = "wasm")]
mod keyboard;
#[cfg(target_family = "wasm")]
mod logging;
#[cfg(target_family = "wasm")]
mod platform;
#[cfg(target_family = "wasm")]
mod viewport;
#[cfg(target_family = "wasm")]
mod window;

#[cfg(target_family = "wasm")]
pub use dispatcher::WebDispatcher;
#[cfg(target_family = "wasm")]
pub use display::WebDisplay;
#[cfg(target_family = "wasm")]
pub use gpui_wgpu::WebBackendPreference;
#[cfg(target_family = "wasm")]
pub use http_client::FetchHttpClient;
#[cfg(target_family = "wasm")]
pub use keyboard::WebKeyboardLayout;
#[cfg(target_family = "wasm")]
pub use logging::init_logging;
#[cfg(target_family = "wasm")]
pub use platform::{WebPlatform, WebWindowError};
#[cfg(target_family = "wasm")]
pub use window::WebWindow;
