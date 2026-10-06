//! Shaders that compose with everything else GPUI draws.
//!
//! There are three ways in, each sugar over the next:
//!
//! 1. **Paints from Rust.** A [`Paint`] is a color that varies per fragment,
//!    usable anywhere GPUI takes a fill: backgrounds, borders, and
//!    [`Window::paint_quad`](crate::Window::paint_quad). Build one from typed
//!    [expressions](Expr) in ordinary Rust, with [signed distances](shape),
//!    [noise], GPU loops ([`iterate`], enough for [raymarching](shape::raymarch)
//!    3D scenes), and composition (`over`, `mix`, `clip`, `select`, `map_uv`).
//!
//!    ```ignore
//!    div().bg(paint(|px| {
//!        let ring = shape::circle(px.centered(), 40.0).abs() - 3.0;
//!        color(gold).clip(ring).over(color(navy))
//!    }))
//!    ```
//!
//!    A [`layer`] is an element whose paint is rebuilt from live [`Input`]
//!    each frame (the pointer, hover, presses, and time) for interactive
//!    and animated shaders, alongside the imperative [`canvas`](crate::canvas).
//!
//! 2. **Your own shader code.** A WGSL or GLSL file, or a `#[wgsl]` module,
//!    becomes a [`Shader`] (a paint entry point,
//!    `fn paint(fragment: Fragment, ...) -> vec4<f32>`) or typed
//!    [`Function`]s that mix freely with expressions. [`wgsl_fn!`](crate::wgsl_fn)
//!    brings a `#[wgsl]` function's Rust body along for CPU evaluation.
//!
//! 3. **Your own geometry.** A [`Pipeline`] is a `vertex` and a `fragment`
//!    function; GPUI writes the entry points, clipping, and blending, and
//!    instances it with [`Window::paint_pipeline`](crate::Window::paint_pipeline).
//!
//! Paints never need a vertex stage: the element supplies geometry, corner
//! radii, borders, clipping, and opacity, and a whole composition compiles to
//! one fragment function with no intermediate textures. Plain numbers become
//! uniforms, so rebuilding a paint every frame reuses its compiled program;
//! work that depends only on them is folded on the CPU through the same
//! `wgsl_rs::std` functions the GPU code transpiles to. Renderers that cannot
//! run shaders paint each paint's [fallback](Paint::fallback).

mod builtins;
mod compile;
mod expr;
mod function;
mod layer;
mod library;
mod paint;
mod pipeline;
mod value;

pub use compile::{CompiledPaint, Program, ShaderError};
pub use expr::{
    Bool, Expr, Scalar, Vec2, Vec3, Vec4, constant, iterate, iterate_until, vec2, vec3, vec4,
};
pub use function::{Arguments, CpuFunction, Function, Library, Shader, ShaderArguments, Signature};
pub use layer::{Input, Layer, layer};
pub use library::{noise, prelude, shape};
pub use paint::{Paint, Pixel, backdrop, color, paint, rgba};
pub use pipeline::{Instance, Pipeline, Topology};
pub use prelude::Fragment;
pub use value::{Arith, CpuValue, Float, Operand, Value, Vector, Widen};
pub use wgsl_rs::std::{Vec2f, Vec3f, Vec4f, vec2f, vec3f, vec4f};

#[cfg(test)]
mod tests;
