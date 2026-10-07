#![cfg(any(target_os = "linux", target_os = "freebsd"))]
//! Linux and FreeBSD platform implementation for GPUI.
//!
//! The backend selects Wayland or X11 according to enabled features and provides
//! the platform object re-exported as [`current_platform`]. Most application code
//! should call the constructor in `gpui_ce_platform` instead.
mod linux;

pub use linux::current_platform;
