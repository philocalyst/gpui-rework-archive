use std::{fmt::Write, path::PathBuf};
fn main() {
    let out = PathBuf::from(std::env::args_os().nth(1).expect("output directory"));
    let source = "@vertex fn vertex() -> @builtin(position) vec4<f32> { return vec4<f32>(0., 0., 0., 1.); }\n@fragment fn fragment() -> @location(0) vec4<f32> { return vec4<f32>(1., 0., 0., 1.); }\n@compute @workgroup_size(1) fn compute() {}\n";
    let module = naga::front::wgsl::parse_str(source).unwrap();
    let info = naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::all(),
    )
    .validate(&module)
    .unwrap();
    let mut rust = String::new();
    for (name, stage) in [
        ("vertex", naga::ShaderStage::Vertex),
        ("fragment", naga::ShaderStage::Fragment),
        ("compute", naga::ShaderStage::Compute),
    ] {
        let options = naga::back::spv::Options::default();
        let selected = naga::back::spv::PipelineOptions {
            shader_stage: stage,
            entry_point: name.into(),
        };
        let words = naga::back::spv::write_vec(&module, &info, &options, Some(&selected)).unwrap();
        std::fs::write(
            out.join(format!("{name}.spv")),
            words
                .iter()
                .flat_map(|w| w.to_le_bytes())
                .collect::<Vec<_>>(),
        )
        .unwrap();
        writeln!(
            &mut rust,
            "static {}: [u32; {}] = [",
            name.to_uppercase(),
            words.len()
        )
        .unwrap();
        for row in words.chunks(8) {
            rust.push_str("    ");
            for (index, word) in row.iter().enumerate() {
                if index != 0 {
                    rust.push(' ');
                }
                write!(&mut rust, "0x{word:08x},").unwrap();
            }
            rust.push('\n');
        }
        rust.push_str("];\n");
    }
    std::fs::write(out.join("minimal.wgsl"), source).unwrap();
    std::fs::write(out.join("words.rs"), rust).unwrap();
}
