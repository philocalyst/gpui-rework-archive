//! WGSL linked at Cargo build time from the Rust-authored shader modules.

pub const BASE_WGSL: &str = include_str!(concat!(env!("OUT_DIR"), "/gpui_base.wgsl"));
pub const SUBPIXEL_DUAL_SOURCE_WGSL: &str =
    include_str!(concat!(env!("OUT_DIR"), "/gpui_subpixel_dual_source.wgsl"));

#[derive(Clone, Copy)]
pub struct GeneratedBinding {
    pub binding: u32,
    pub visibility: u32,
    pub kind: GeneratedBindingKind,
}

#[derive(Clone, Copy)]
pub enum GeneratedBindingKind {
    Uniform(u64),
    StorageRead(u64),
    Texture2dFloat,
    FilteringSampler,
}

include!(concat!(env!("OUT_DIR"), "/shader_interface.rs"));

pub struct NativeShader {
    pub label: &'static str,
    pub vertex_entry: &'static str,
    pub fragment_entry: &'static str,
    pub hlsl: &'static str,
    pub msl: &'static str,
}

include!(concat!(env!("OUT_DIR"), "/native_shaders.rs"));
