#![cfg(target_os = "macos")]
//! macOS platform implementation for GPUI.
//!
//! macOS screens have a y axis that goes up from the bottom of the screen and
//! an origin at the bottom left of the main display.

mod display;
mod display_link;
mod events;
mod haptic_feedback;
mod keyboard;
mod pasteboard;
mod system_notifications;
mod text_system;

#[cfg(feature = "screen-capture")]
mod screen_capture;

#[cfg(not(feature = "wgpu"))]
use gpui_apple::metal_renderer as renderer;
<<<<<<< HEAD
#[cfg(feature = "wgpu")]
mod wgpu_renderer;
#[cfg(feature = "wgpu")]
use wgpu_renderer as renderer;
=======

pub mod metal_renderer {
    pub use gpui_apple::metal_renderer::{PathRasterizationVertex, PathSprite, SurfaceBounds};

    #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
    pub use gpui_apple::metal_renderer::MetalHeadlessRenderer;
}
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

mod platform;
mod window;
mod window_appearance;

<<<<<<< HEAD
pub(crate) use dispatcher::*;
=======
use cocoa::{
    base::{id, nil},
    foundation::{NSAutoreleasePool, NSNotFound, NSString, NSUInteger},
};

use objc::runtime::{BOOL, NO, YES};
use std::{
    ffi::{CStr, c_char},
    ops::Range,
};

>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
pub(crate) use display::*;
pub(crate) use display_link::*;
pub(crate) use gpui_apple::{AppleActivity, AppleDispatcher};
pub(crate) use keyboard::*;
pub(crate) use platform::*;
pub(crate) use text_system::*;
pub(crate) use window::*;

pub use platform::MacPlatform;
