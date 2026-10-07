//! Shared typed rendering and shader contracts.

//! Rendering building blocks shared by GPUI's native and headless backends.
//!
//! This crate contains the data prepared by GPUI before a backend submits a frame:
//! CPU rasterization, path and instance packing, font uniforms, blur parameters, and
//! generated shader artifacts. It does not own a window or a GPU device. Platform
//! crates consume these types to turn a [`gpui::Scene`] into pixels.

pub mod artifacts;
pub mod blur;
mod instances;
pub mod path_types;
pub mod shaders;

pub use instances::InstanceRange;
