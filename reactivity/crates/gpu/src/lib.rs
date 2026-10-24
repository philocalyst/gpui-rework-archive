//! GPU rendering consumes the same admitted scene as the CPU reference.
#![recursion_limit = "256"]
#![cfg_attr(not(feature = "offline-shader"), forbid(unsafe_code))]
#![cfg_attr(feature = "offline-shader", deny(unsafe_code))]
mod renderer;
pub mod shader;
pub use renderer::{
    ClipAccelerationJob, Error, GpuContext, GpuPaintCommit, GpuPaintEdit, GpuSlotCommit,
    ImageStats, PaintBinding, PaintError, PaintRenderer, PreparedClipAcceleration, Renderer,
    RendererState, SlotError, Stats,
};
pub use wgpu;
