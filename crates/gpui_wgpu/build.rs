#[path = "src/shaders/mod.rs"]
mod shaders;

use std::{env, fs, path::PathBuf};

fn main() {
    println!("cargo:rerun-if-changed=src/shaders");
    println!("cargo:rerun-if-changed=src/shaders");

    let out_dir = PathBuf::from(env::var("OUT_DIR").expect("OUT_DIR must be set"));
    write_shader(
        &out_dir,
        "gpui_base.wgsl",
        &shader_source("gpui_base.wgsl", &shaders::base::WGSL_SOURCE),
    );
    let subpixel = shader_source("gpui_subpixel.wgsl", &shaders::subpixel_sprite::WGSL_SOURCE);
    write_shader(&out_dir, "gpui_subpixel.wgsl", &subpixel);
    write_shader(
        &out_dir,
        "gpui_subpixel_dual_source.wgsl",
        &format!("enable dual_source_blending;\n{subpixel}"),
    );
}

fn shader_source(name: &str, source: &wgsl_rs::Source) -> String {
    source
        .wgsl_source()
        .unwrap_or_else(|error| panic!("failed to generate {name}: {error}"))
}

fn write_shader(out_dir: &std::path::Path, name: &str, source: &str) {
    fs::write(out_dir.join(name), source).unwrap_or_else(|error| {
        panic!("failed to write generated shader {name}: {error}");
    });
}
