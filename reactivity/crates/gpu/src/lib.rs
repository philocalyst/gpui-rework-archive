//! GPU rendering consumes the same admitted scene as the CPU reference.
#![forbid(unsafe_code)]
mod renderer;
pub mod shader;
pub use renderer::{Error, Renderer, Stats};
pub use wgpu;
