//! Typed, composable fragment paints.
//!
//! A shader closure builds a Rust value graph on the CPU. Its fields become
//! uniforms by default; values passed to [`constant`] are embedded in WGSL.
//! Paint colors use GPUI's sRGB numeric channel convention and are premultiplied
//! internally for compositing.

mod compiler;
mod expr;
mod field;
mod paint;

pub use compiler::{CompiledPaint, ShaderError};
#[cfg(any(test, feature = "test-support"))]
pub use compiler::{ShaderCacheStats, reset_shader_cache_stats, shader_cache_stats};
pub use field::{
    Field, Predicate, Scalar, ShaderValue, Vec2, Vec3, Vec4, constant, vec2, vec3, vec4,
};
pub use paint::{Backdrop, IntoPaintColor, Paint, Pixel, backdrop, color, rgba, shader};

#[cfg(test)]
mod tests;
