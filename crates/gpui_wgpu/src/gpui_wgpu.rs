mod wgpu_atlas;
mod wgpu_context;
mod wgpu_renderer;

pub use wgpu;
pub use wgpu_atlas::*;
pub use wgpu_context::*;
<<<<<<< HEAD
#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
pub use wgpu_renderer::WgpuHeadlessRenderer;
pub use wgpu_renderer::{
    FontRasterizationSettings, GpuContext, SubpixelOrder, WgpuRenderer, WgpuSurfaceConfig,
};
=======
#[cfg(all(
    not(target_family = "wasm"),
    any(test, feature = "bench-support", feature = "test-support")
))]
pub use wgpu_renderer::WgpuHeadlessRenderer;
pub use wgpu_renderer::{GpuContext, WgpuRenderer, WgpuSurfaceConfig};
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
