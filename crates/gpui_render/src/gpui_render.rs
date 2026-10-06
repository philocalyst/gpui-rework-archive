//! Shared typed rendering and shader contracts.

pub mod artifacts;
pub mod blur;
#[cfg(feature = "cpu")]
pub mod cpu;
mod instances;
pub mod path_types;
pub mod shaders;

pub use instances::InstanceRange;
