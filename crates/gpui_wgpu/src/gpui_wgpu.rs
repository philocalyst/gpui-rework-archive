//! WGPU context, surface, atlas, and renderer integration for GPUI.
//!
//! A [`WgpuContext`] owns device-level state while [`WgpuRenderTarget`] owns a
//! drawable texture. The renderer exposes recovery and device-loss state so a
//! platform can recreate a surface without rebuilding the application scene.

mod wgpu_atlas;
mod wgpu_context;
mod wgpu_renderer;

pub use wgpu;
pub use wgpu_atlas::*;
pub use wgpu_context::*;
pub use wgpu_renderer::{
    FontRasterizationSettings, GpuContext, SubpixelOrder, WgpuRenderer, WgpuSurfaceConfig,
};
#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
pub use wgpu_renderer::{
    GpuFrameMeasurement, GpuOwnedMemoryUsage, GpuReplayInfo, WgpuHeadlessRenderer,
};
