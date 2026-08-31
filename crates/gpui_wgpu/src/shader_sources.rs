//! WGSL linked at Cargo build time from the Rust-authored shader modules.

pub(crate) const BASE_WGSL: &str = include_str!(concat!(env!("OUT_DIR"), "/gpui_base.wgsl"));
#[cfg(test)]
pub(crate) const SUBPIXEL_WGSL: &str =
    include_str!(concat!(env!("OUT_DIR"), "/gpui_subpixel.wgsl"));
pub(crate) const SUBPIXEL_DUAL_SOURCE_WGSL: &str =
    include_str!(concat!(env!("OUT_DIR"), "/gpui_subpixel_dual_source.wgsl"));
