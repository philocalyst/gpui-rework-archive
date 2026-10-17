#![cfg(any(target_os = "macos", target_os = "ios"))]
//! Shared Apple rendering, task dispatch, and system services for GPUI.
//!
//! This crate renders GPUI scenes directly with Metal on Apple platforms and
//! provides shared dispatch, text, Keychain, and thermal support. Windowing and
//! input remain owned by the platform-specific crates.

mod dispatcher;
pub mod keychain;
mod metal_atlas;
pub mod metal_renderer;
pub mod thermal;

#[cfg(feature = "font-kit")]
mod open_type;
mod text_system;

pub use dispatcher::{AppleActivity, AppleDispatcher};
#[cfg(target_os = "ios")]
pub use text_system::AppleTextSystem;
pub use text_system::MacTextSystem;
#[cfg(target_os = "macos")]
pub use text_system::MacTextSystem as AppleTextSystem;
