#[allow(dead_code)]
#[path = "src/shader.rs"]
mod shader;

#[allow(dead_code)]
#[path = "src/renderer/region_shader.rs"]
mod region_shader;

#[cfg(feature = "offline-shader")]
#[path = "src/shader_build.rs"]
mod shader_build;

fn main() {
    // Track child modules too if the typed shader is split in the future.
    println!("cargo::rerun-if-changed=src");
    let source = shader::ui::WGSL_SOURCE
        .wgsl_source()
        .expect("generate the typed UI shader");
    wgsl_rs::validate_wgsl_source(&source).expect("validate the typed UI shader");
    let output = std::path::PathBuf::from(std::env::var_os("OUT_DIR").expect("Cargo OUT_DIR"))
        .join("ui.wgsl");
    std::fs::write(&output, &source).expect("write the typed UI shader");
    let regions = region_shader::region::WGSL_SOURCE
        .wgsl_source()
        .expect("generate the typed region vertex shader");
    wgsl_rs::validate_wgsl_source(&regions).expect("validate the region vertex shader");
    std::fs::write(output.with_file_name("region.wgsl"), regions)
        .expect("write the region vertex shader");
    #[cfg(feature = "offline-shader")]
    shader_build::generate(&source, output.parent().unwrap());
}
