#[path="src/shader.rs"] mod shader;
fn main() {
    println!("cargo::rerun-if-changed=src");
    let out = std::path::PathBuf::from(std::env::var_os("OUT_DIR").unwrap());
    std::fs::write(out.join("shader.txt"), shader::SOURCE).unwrap();
}
