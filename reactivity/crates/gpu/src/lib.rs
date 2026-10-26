//! GPU rendering consumes the same admitted scene as the CPU reference.
#![cfg_attr(not(feature = "offline-shader"), forbid(unsafe_code))]
#![cfg_attr(feature = "offline-shader", deny(unsafe_code))]
mod renderer;
pub mod shader;
pub use renderer::{
    Error, GpuContext, GpuPaintCommit, GpuPaintEdit, GpuSlotCommit, ImageStats, PaintBinding,
    PaintError, PaintRenderer, Renderer, RendererState, SlotError, Stats,
};
pub use wgpu;

#[cfg(all(test, feature = "gpu-tests"))]
#[path = "../tests/support/adapter.rs"]
mod test_adapter;
