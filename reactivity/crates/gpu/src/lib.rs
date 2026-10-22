//! GPU rendering consumes the same admitted scene as the CPU reference.
#![forbid(unsafe_code)]
mod renderer;
pub mod shader;
pub use renderer::{
    Error, GpuContext, GpuPaintCommit, GpuPaintEdit, GpuSlotCommit, ImageStats, PaintBinding,
    PaintError, PaintRenderer, Renderer, RendererState, SlotError, Stats,
};
pub use wgpu;
