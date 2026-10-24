#[path="src/shader.rs"] mod shader;
fn main() {
    println!("cargo::rerun-if-changed={}/src", env!("CARGO_MANIFEST_DIR"));
    let out = std::path::PathBuf::from(std::env::var_os("OUT_DIR").unwrap());
    std::fs::write(out.join("shader.txt"), shader::SOURCE).unwrap();
}
