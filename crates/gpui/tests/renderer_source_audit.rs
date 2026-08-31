//! Guards the unified renderer boundary against reintroducing native renderer sources.

use std::{
    env, fs,
    path::{Path, PathBuf},
};

fn workspace_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(2)
        .expect("gpui crate must live at <workspace>/crates/gpui")
        .to_path_buf()
}

fn collect_renderer_shader_sources(root: &Path, sources: &mut Vec<PathBuf>) {
    let entries = fs::read_dir(root)
        .unwrap_or_else(|error| panic!("failed to read {}: {error}", root.display()));

    for entry in entries {
        let entry = entry.unwrap_or_else(|error| {
            panic!(
                "failed to inspect an entry under {}: {error}",
                root.display()
            )
        });
        let path = entry.path();
        let file_type = entry
            .file_type()
            .unwrap_or_else(|error| panic!("failed to inspect {}: {error}", path.display()));

        if file_type.is_dir() {
            collect_renderer_shader_sources(&path, sources);
        } else if matches!(
            path.extension().and_then(|extension| extension.to_str()),
            Some("wgsl" | "metal" | "hlsl")
        ) {
            sources.push(path);
        }
    }
}

fn relative_paths(root: &Path, paths: impl IntoIterator<Item = PathBuf>) -> Vec<String> {
    let mut relative: Vec<_> = paths
        .into_iter()
        .map(|path| {
            path.strip_prefix(root)
                .unwrap_or(&path)
                .display()
                .to_string()
        })
        .collect();
    relative.sort();
    relative
}

#[test]
fn renderer_sources_remain_unified_wgpu_only() {
    let root = workspace_root();

    // These were the independent Metal and DirectX renderer implementations. Keeping this
    // explicit list makes a reintroduced module immediately visible in the failure output,
    // while the shader scan below catches renamed replacements.
    let retired_modules = [
        "crates/gpui_macos/src/metal_renderer.rs",
        "crates/gpui_macos/src/metal_atlas.rs",
        "crates/gpui_windows/src/directx_renderer.rs",
        "crates/gpui_windows/src/directx_atlas.rs",
        "crates/gpui_windows/src/directx_devices.rs",
    ];
    let present_modules: Vec<_> = retired_modules
        .iter()
        .map(|relative| root.join(relative))
        .filter(|path| path.exists())
        .collect();
    assert!(
        present_modules.is_empty(),
        "retired backend renderer modules returned: {}",
        relative_paths(&root, present_modules).join(", ")
    );

    let mut platform_shader_sources = Vec::new();
    for relative in ["crates/gpui_macos/src", "crates/gpui_windows/src"] {
        let path = root.join(relative);
        if path.exists() {
            collect_renderer_shader_sources(&path, &mut platform_shader_sources);
        }
    }
    assert!(
        platform_shader_sources.is_empty(),
        "retired platform renderer shader source returned: {}",
        relative_paths(&root, platform_shader_sources).join(", ")
    );

    let rust_shader_module = root.join("crates/gpui_wgpu/src/shaders/mod.rs");
    assert!(
        rust_shader_module.is_file(),
        "the unified renderer must keep its typed Rust shader module"
    );

    // Renderer shaders are authored in Rust and generate WGSL through wgsl-rs. Standalone
    // shader files would bypass the shared types and compile-time source validation.
    let wgpu_source_root = root.join("crates/gpui_wgpu/src");
    let mut wgpu_shader_sources = Vec::new();
    collect_renderer_shader_sources(&wgpu_source_root, &mut wgpu_shader_sources);
    assert!(
        wgpu_shader_sources.is_empty(),
        "standalone WGPU shader sources returned: {}",
        relative_paths(&root, wgpu_shader_sources).join(", ")
    );
}
