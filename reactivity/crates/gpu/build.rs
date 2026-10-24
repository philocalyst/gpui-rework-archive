#[path = "src/clip_specialization.rs"]
mod clip_specialization;
#[allow(dead_code)]
#[path = "src/shader.rs"]
mod shader;

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
    #[cfg(feature = "offline-shader")]
    shader_build::generate(&source, output.parent().unwrap());
    let source = clip_specialization::specialize(&source);
    wgsl_rs::validate_wgsl_source(&source).expect("validate the cold clip specialization");
    let cold = output.parent().unwrap().join("clip");
    std::fs::create_dir_all(&cold).expect("cold artifact directory");
    std::fs::write(cold.join("ui.wgsl"), &source).expect("write cold specialization");
    #[cfg(feature = "offline-shader")]
    shader_build::generate(&source, &cold);
}
