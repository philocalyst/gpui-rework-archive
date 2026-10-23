//! Host-only proof and generation for the experimental compiled shader bundle.
use naga::{AddressSpace, ArraySize, Module, ShaderStage, StorageAccess, TypeInner};
use sha2::{Digest, Sha256};
use std::{collections::BTreeMap, fmt::Write as _, path::Path, process::Command};

const CAPABILITIES: [naga::back::spv::Capability; 7] = [
    naga::back::spv::Capability::Shader,
    naga::back::spv::Capability::Matrix,
    naga::back::spv::Capability::Sampled1D,
    naga::back::spv::Capability::Image1D,
    naga::back::spv::Capability::ImageQuery,
    naga::back::spv::Capability::DerivativeControl,
    naga::back::spv::Capability::StorageImageExtendedFormats,
];

fn hash(bytes: &[u8]) -> String {
    Sha256::digest(bytes)
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect()
}
fn unwrap_struct(module: &Module, mut ty: naga::Handle<naga::Type>) -> naga::Handle<naga::Type> {
    while let TypeInner::Struct { ref members, .. } = module.types[ty].inner {
        if members.len() != 1 || members[0].offset != 0 {
            break;
        }
        ty = members[0].ty;
    }
    ty
}
fn vector_type(width: naga::VectorSize, kind: naga::ScalarKind) -> TypeInner {
    TypeInner::Vector {
        size: width,
        scalar: naga::Scalar { kind, width: 4 },
    }
}
fn vector(
    module: &Module,
    ty: naga::Handle<naga::Type>,
    width: naga::VectorSize,
    kind: naga::ScalarKind,
) {
    assert_eq!(module.types[ty].inner, vector_type(width, kind));
}
fn structure(
    module: &Module,
    ty: naga::Handle<naga::Type>,
    bytes: u32,
    fields: &[(u32, TypeInner)],
) {
    let TypeInner::Struct { members, span } = &module.types[unwrap_struct(module, ty)].inner else {
        panic!("ABI struct")
    };
    assert_eq!(*span, bytes);
    assert_eq!(members.len(), fields.len());
    for (member, (offset, ty)) in members.iter().zip(fields) {
        assert_eq!(member.offset, *offset);
        assert_eq!(module.types[member.ty].inner, *ty);
    }
}
/// Recheck source and independently reparsed output, including dynamic strides,
/// read-only storage and the complete stage/resource interface.
fn reflect(
    module: &Module,
    info: &naga::valid::ModuleInfo,
    expected: &[(&str, ShaderStage)],
) -> Vec<(u32, u64, &'static str)> {
    use naga::{ImageClass, ImageDimension, ScalarKind as K, VectorSize as V};
    assert!(module.overrides.is_empty());
    assert_eq!(module.entry_points.len(), expected.len());
    let mut stages = module
        .entry_points
        .iter()
        .map(|ep| (ep.name.as_str(), ep.stage))
        .collect::<Vec<_>>();
    stages.sort_by_key(|v| v.0);
    assert_eq!(stages, expected);
    // Check both source and reparsed SPIR-V, including scalar class/width.
    // No user varyings/depth output may make HAL's other stage options relevant.
    for ep in &module.entry_points {
        assert_eq!(ep.function.arguments.len(), 1);
        let argument = &ep.function.arguments[0];
        let output = ep.function.result.as_ref().unwrap();
        let position = Some(naga::Binding::BuiltIn(naga::BuiltIn::Position {
            invariant: false,
        }));
        match ep.stage {
            ShaderStage::Vertex => {
                assert_eq!(
                    argument.binding,
                    Some(naga::Binding::BuiltIn(naga::BuiltIn::VertexIndex))
                );
                assert_eq!(
                    module.types[argument.ty].inner,
                    TypeInner::Scalar(naga::Scalar::U32)
                );
            }
            ShaderStage::Fragment => {
                assert_eq!(argument.binding, position);
                vector(module, argument.ty, V::Quad, K::Float);
            }
            _ => unreachable!(),
        }
        let output_type = if ep.stage == ShaderStage::Vertex && output.binding.is_none() {
            // FORCE_POINT_SIZE adds this exact builtin to the SPIR-V vertex
            // result; the source instead returns Position directly.
            let TypeInner::Struct { members, span } = &module.types[output.ty].inner else {
                panic!("vertex result interface")
            };
            assert_eq!(*span, 32);
            assert_eq!(members.len(), 2);
            assert_eq!(members[0].offset, 0);
            assert_eq!(members[0].binding, position);
            assert_eq!(members[1].offset, 16);
            assert_eq!(
                members[1].binding,
                Some(naga::Binding::BuiltIn(naga::BuiltIn::PointSize))
            );
            assert_eq!(
                module.types[members[1].ty].inner,
                TypeInner::Scalar(naga::Scalar::F32)
            );
            members[0].ty
        } else {
            if ep.stage == ShaderStage::Vertex {
                assert_eq!(output.binding, position);
            } else {
                // WGSL normalizes default interpolation; SPIR-V drops it on
                // fragment outputs. Neither creates an inter-stage varying.
                assert!(matches!(
                    output.binding,
                    Some(naga::Binding::Location {
                        location: 0,
                        blend_src: None,
                        per_primitive: false,
                        ..
                    })
                ));
            }
            output.ty
        };
        vector(module, output_type, V::Quad, K::Float);
    }
    let mut result = Vec::new();
    for (handle, global) in module.global_variables.iter() {
        assert_ne!(global.space, AddressSpace::WorkGroup);
        let Some(binding) = &global.binding else {
            continue;
        };
        assert_eq!(binding.group, 0);
        for (i, ep) in module.entry_points.iter().enumerate() {
            let usage = info.get_entry_point(i)[handle];
            assert!(!usage.contains(naga::valid::GlobalUse::WRITE));
            if ep.stage == ShaderStage::Vertex {
                assert!(usage.is_empty());
            }
        }
        let size = u64::from(module.types[global.ty].inner.size(module.to_ctx()));
        let kind = match binding.binding {
            0 => {
                assert_eq!(global.space, AddressSpace::Uniform);
                structure(
                    module,
                    global.ty,
                    48,
                    &[
                        (0, vector_type(V::Quad, K::Uint)),
                        (16, vector_type(V::Quad, K::Float)),
                        (32, TypeInner::Scalar(naga::Scalar::F32)),
                        (36, TypeInner::Scalar(naga::Scalar::U32)),
                    ],
                );
                assert_eq!(size, 48);
                "uniform"
            }
            1..=3 | 5 => {
                assert_eq!(
                    global.space,
                    AddressSpace::Storage {
                        access: StorageAccess::LOAD
                    }
                );
                let TypeInner::Array {
                    base,
                    size: ArraySize::Dynamic,
                    stride,
                } = module.types[unwrap_struct(module, global.ty)].inner
                else {
                    panic!("runtime array ABI")
                };
                let expected = match binding.binding {
                    1 => {
                        vector(module, base, V::Quad, K::Uint);
                        16
                    }
                    2 => {
                        vector(module, base, V::Bi, K::Uint);
                        8
                    }
                    3 => {
                        assert_eq!(
                            module.types[base].inner,
                            TypeInner::Scalar(naga::Scalar::U32)
                        );
                        4
                    }
                    5 => {
                        structure(
                            module,
                            base,
                            32,
                            &[
                                (0, vector_type(V::Quad, K::Float)),
                                (16, vector_type(V::Quad, K::Float)),
                            ],
                        );
                        32
                    }
                    _ => unreachable!(),
                };
                assert_eq!(stride, expected);
                assert_eq!(size, u64::from(expected));
                "storage"
            }
            4 => {
                assert_eq!(global.space, AddressSpace::Handle);
                assert_eq!(
                    module.types[global.ty].inner,
                    TypeInner::Image {
                        dim: ImageDimension::D2,
                        arrayed: false,
                        class: ImageClass::Sampled {
                            kind: K::Float,
                            multi: false
                        }
                    }
                );
                "texture"
            }
            _ => panic!("unexpected resource"),
        };
        result.push((
            binding.binding,
            if kind == "texture" { 0 } else { size },
            kind,
        ));
    }
    result.sort_by_key(|b| b.0);
    let expected_bindings: &[u32] = if expected == [("vertex", ShaderStage::Vertex)] {
        &[]
    } else {
        &[0, 1, 2, 3, 4, 5]
    };
    assert_eq!(
        result.iter().map(|b| b.0).collect::<Vec<_>>(),
        expected_bindings
    );
    result
}
/// Walk only the framing/capability/descriptor decorations needed by the ABI
/// proof; Naga and spirv-val separately parse and validate the complete module.
fn decorations(words: &[u32], capabilities: &[naga::back::spv::Capability], expected: &[u32]) {
    assert_eq!(&words[..2], &[0x07230203, 0x00010000]);
    let mut descriptors = BTreeMap::<u32, [Option<u32>; 2]>::new();
    let mut at = 5;
    while at < words.len() {
        let count = (words[at] >> 16) as usize;
        assert!(count > 0 && at + count <= words.len());
        let op = words[at] & 0xffff;
        let operands = &words[at + 1..at + count];
        match op {
            17 => {
                // OpCapability
                assert_eq!(operands.len(), 1);
                assert!(capabilities.iter().any(|c| *c as u32 == operands[0]));
            }
            10 => {
                // Naga's SPIR-V<1.3 storage-buffer class declaration.
                let extension = operands
                    .iter()
                    .flat_map(|w| w.to_le_bytes())
                    .collect::<Vec<_>>();
                assert_eq!(
                    std::ffi::CStr::from_bytes_until_nul(&extension)
                        .unwrap()
                        .to_bytes(),
                    b"SPV_KHR_storage_buffer_storage_class"
                );
            }
            71 if operands.len() == 3 => {
                // OpDecorate; Binding=33, DescriptorSet=34
                if let 33..=34 = operands[1] {
                    let slot = &mut descriptors.entry(operands[0]).or_default()
                        [(operands[1] - 33) as usize];
                    assert!(slot.replace(operands[2]).is_none());
                }
            }
            _ => {}
        }
        at += count;
    }
    let mut bindings = descriptors
        .into_values()
        .map(|[binding, set]| {
            assert_eq!(set, Some(0));
            binding.unwrap()
        })
        .collect::<Vec<_>>();
    bindings.sort();
    assert_eq!(bindings, expected);
}
fn validate(module: &Module) -> naga::valid::ModuleInfo {
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::empty(),
    )
    .validate(module)
    .expect("validate compositor module")
}
#[allow(
    clippy::disallowed_methods,
    reason = "Host build must finish external SPIR-V validation before admitting its generated artifacts"
)]
pub fn generate(source: &str, out: &Path) {
    use naga::{
        back::spv,
        proc::{BoundsCheckPolicies, BoundsCheckPolicy as Check},
    };
    println!("cargo::rerun-if-env-changed=GPUI_SPIRV_VAL");
    let tool = std::env::var_os("GPUI_SPIRV_VAL").unwrap_or_else(|| "spirv-val".into());
    let version = Command::new(&tool)
        .arg("--version")
        .output()
        .expect("offline-shader requires spirv-val (GPUI_SPIRV_VAL)");
    assert!(version.status.success());
    let version = String::from_utf8(version.stdout).unwrap();
    let module = naga::front::wgsl::parse_str(source).expect("parse exact typed ui.wgsl");
    let info = validate(&module);
    let bindings = reflect(
        &module,
        &info,
        &[
            ("fragment", ShaderStage::Fragment),
            ("vertex", ShaderStage::Vertex),
        ],
    );
    let layout_json = format!(
        "[{}]",
        bindings
            .iter()
            .map(|(b, s, k)| format!(
                "{{\"binding\":{b},\"min_size\":{s},\"kind\":\"{k}\",\"visibility\":\"fragment\"}}"
            ))
            .collect::<Vec<_>>()
            .join(",")
    );
    let mut rust = String::from(
        "// Generated from the exact typed WGSL; immutable private bundle.\npub const REVISION:u32=2;\npub const BINDINGS:[wgpu::BindGroupLayoutEntry;6]=[\n",
    );
    for (binding, size, kind) in &bindings {
        let ty = match *kind {
            "uniform" | "storage" => format!("wgpu::BindingType::Buffer {{ ty:wgpu::BufferBindingType::{}, has_dynamic_offset:false, min_binding_size:wgpu::BufferSize::new({size}) }}",if *kind=="uniform" {"Uniform"} else {"Storage { read_only:true }"}),
            "texture" => "wgpu::BindingType::Texture { sample_type:wgpu::TextureSampleType::Float { filterable:false },view_dimension:wgpu::TextureViewDimension::D2,multisampled:false }".into(),
            _ => unreachable!(),
        };
        writeln!(rust,"wgpu::BindGroupLayoutEntry {{ binding:{binding},visibility:wgpu::ShaderStages::FRAGMENT,ty:{ty},count:None }},").unwrap();
    }
    rust.push_str("];\n");
    let caps = CAPABILITIES;
    let binding_map: spv::BindingMap = bindings
        .iter()
        .map(|(b, _, _)| {
            (
                naga::ResourceBinding {
                    group: 0,
                    binding: *b,
                },
                spv::BindingInfo {
                    descriptor_set: 0,
                    binding: *b,
                    binding_array_size: None,
                },
            )
        })
        .collect();
    let mut artifacts = Vec::new();
    let mut vertex_words = None;
    for variant in 0..4 {
        let policy = |bit| {
            if variant & bit != 0 {
                Check::Restrict
            } else {
                Check::Unchecked
            }
        };
        let options = spv::Options {
            lang_version: (1, 0),
            flags: spv::WriterFlags::FORCE_POINT_SIZE,
            fake_missing_bindings: false,
            binding_map: binding_map.clone(),
            capabilities: Some(caps.iter().copied().collect()),
            bounds_check_policies: BoundsCheckPolicies {
                index: Check::Restrict,
                buffer: policy(2),
                image_load: policy(1),
                binding_array: Check::Unchecked,
            },
            zero_initialize_workgroup_memory: spv::ZeroInitializeWorkgroupMemoryMode::Polyfill,
            force_loop_bounding: true,
            ray_query_initialization_tracking: true,
            trace_ray_argument_validation: true,
            use_storage_input_output_16: false,
            debug_info: None,
            task_dispatch_limits: None,
            mesh_shader_primitive_indices_clamp: true,
            emit_int_div_checks: true,
        };
        for (entry, stage) in [
            ("vertex", ShaderStage::Vertex),
            ("fragment", ShaderStage::Fragment),
        ] {
            // Match HAL compile_stage's selected-entry compaction and empty
            // pipeline constants. No source override is allowed by reflection.
            let (stage_module, stage_info) = naga::back::pipeline_constants::process_overrides(
                &module,
                &info,
                Some((stage, entry)),
                &Default::default(),
            )
            .expect("compact the exact stage as HAL does");
            let words = spv::write_vec(
                &stage_module,
                &stage_info,
                &options,
                Some(&spv::PipelineOptions {
                    entry_point: entry.into(),
                    shader_stage: stage,
                }),
            )
            .expect("write guarded single-entry SPIR-V");
            let expected: &[u32] = if stage == ShaderStage::Vertex {
                &[]
            } else {
                &[0, 1, 2, 3, 4, 5]
            };
            decorations(&words, &caps, expected);
            let bytes = words
                .iter()
                .flat_map(|w| w.to_le_bytes())
                .collect::<Vec<_>>();
            let parsed = naga::front::spv::parse_u8_slice(
                &bytes,
                &naga::front::spv::Options {
                    adjust_coordinate_space: false,
                    strict_capabilities: true,
                    block_ctx_dump_prefix: None,
                },
            )
            .expect("strict single-entry SPIR-V reparse");
            let reflected = reflect(&parsed, &validate(&parsed), &[(entry, stage)]);
            assert_eq!(reflected.iter().map(|b| b.0).collect::<Vec<_>>(), expected);
            if stage == ShaderStage::Fragment {
                assert_eq!(reflected, bindings);
            }
            let path = out.join(format!("ui-{variant}-{entry}.spv"));
            std::fs::write(&path, &bytes).expect("write stage artifact");
            let valid = Command::new(&tool)
                .args(["--target-env", "vulkan1.0"])
                .arg(&path)
                .output()
                .expect("run spirv-val");
            assert!(
                valid.status.success(),
                "spirv-val: {}",
                String::from_utf8_lossy(&valid.stderr)
            );
            artifacts.push(format!("{{\"variant\":{variant},\"entry\":\"{entry}\",\"buffer_restrict\":{},\"image_restrict\":{},\"bytes\":{},\"sha256\":\"{}\"}}",variant&2!=0,variant&1!=0,bytes.len(),hash(&bytes)));
            if stage == ShaderStage::Vertex {
                if let Some(first) = &vertex_words {
                    assert_eq!(
                        &words, first,
                        "dedup requires all four vertex artifacts equal"
                    );
                    continue;
                }
                vertex_words = Some(words.clone());
            }
            let name = if stage == ShaderStage::Vertex {
                "VERTEX".into()
            } else {
                format!("P{variant}")
            };
            writeln!(rust, "pub static {name}:[u32;{}]=[", words.len()).unwrap();
            for chunk in words.chunks(8) {
                for word in chunk {
                    write!(rust, "0x{word:08x},").unwrap();
                }
                rust.push('\n');
            }
            rust.push_str("];\n");
        }
    }
    rust.push_str("pub static WORDS:[&[u32];4]=[&P0,&P1,&P2,&P3];\n");
    std::fs::write(out.join("ui-artifacts.rs"), rust)
        .expect("write aligned word arrays and layout");
    let manifest = format!(
        r#"{{
  "revision":2, "naga":"30.0.1", "target_env":"vulkan1.0", "spirv_version":"1.0",
  "typed_rust_sha256":"{}", "wgsl_sha256":"{}", "layout_sha256":"{}",
  "spirv_val":{:?}, "layout":{},
  "entry_points":["vertex","fragment"], "entry_strategy":"separate-single-entry-modules",
  "index":"Restrict", "binding_array":"Unchecked", "force_loop_bounding":true,
  "emit_int_div_checks":true, "adjust_coordinate_space":false, "force_point_size":true,
  "allowed_extensions":["SPV_KHR_storage_buffer_storage_class"],
  "workgroup_init":"Polyfill", "fake_missing_bindings":false, "allowed_capabilities":{:?},
  "artifacts":[{}]
}}
"#,
        hash(&std::fs::read("src/shader.rs").unwrap()),
        hash(source.as_bytes()),
        hash(layout_json.as_bytes()),
        version.lines().next().unwrap(),
        layout_json,
        caps.iter().map(|c| format!("{c:?}")).collect::<Vec<_>>(),
        artifacts.join(",\n")
    );
    std::fs::write(out.join("ui-artifacts.json"), manifest).expect("write artifact manifest");
}

#[cfg(test)]
mod tests {
    use super::*;
    fn source() -> String {
        std::fs::read_to_string(std::env::var_os("GPUI_PROOF_WGSL").unwrap()).unwrap()
    }
    #[test]
    fn valid_integer_or_narrow_fragment_output_cannot_pass_stage_interface_proof() {
        let source = source();
        let (prefix, _) = source.split_once("@fragment fn fragment(").unwrap();
        for (ty, value) in [("vec4u", "vec4u(0u)"), ("vec2f", "vec2f(0.0)")] {
            let changed = format!(
                "{prefix}@fragment fn fragment(@builtin(position) p: vec4f) -> @location(0) {ty} {{ return {value}; }}"
            );
            let module = naga::front::wgsl::parse_str(&changed).unwrap();
            let info = validate(&module); // The control is valid Naga, not a type-error rejection.
            assert!(
                std::panic::catch_unwind(|| reflect(
                    &module,
                    &info,
                    &[
                        ("fragment", ShaderStage::Fragment),
                        ("vertex", ShaderStage::Vertex)
                    ]
                ))
                .is_err()
            );
        }
    }
    #[test]
    fn changed_binding_cannot_keep_the_generated_host_layout() {
        let source = source();
        let changed = source.replace("@binding(5)", "@binding(6)");
        assert_ne!(source, changed);
        let module = naga::front::wgsl::parse_str(&changed).unwrap();
        let info = validate(&module);
        assert!(
            std::panic::catch_unwind(|| reflect(
                &module,
                &info,
                &[
                    ("fragment", ShaderStage::Fragment),
                    ("vertex", ShaderStage::Vertex)
                ]
            ))
            .is_err()
        );
    }
    #[test]
    fn writable_resource_cannot_pass_read_only_abi_proof() {
        let source = source();
        let changed = source.replace("var<storage, read> WORDS", "var<storage, read_write> WORDS");
        assert_ne!(source, changed);
        let module = naga::front::wgsl::parse_str(&changed).unwrap();
        let info = validate(&module);
        assert!(
            std::panic::catch_unwind(|| reflect(
                &module,
                &info,
                &[
                    ("fragment", ShaderStage::Fragment),
                    ("vertex", ShaderStage::Vertex)
                ]
            ))
            .is_err()
        );
    }
    #[test]
    fn changed_descriptor_set_cannot_pass_physical_binding_proof() {
        let bytes = std::fs::read(std::env::var_os("GPUI_PROOF_FRAGMENT").unwrap()).unwrap();
        let mut words = bytes
            .chunks_exact(4)
            .map(|b| u32::from_le_bytes(b.try_into().unwrap()))
            .collect::<Vec<_>>();
        decorations(&words, &CAPABILITIES, &[0, 1, 2, 3, 4, 5]);
        let mut at = 5;
        let mut changed = false;
        while at < words.len() {
            let count = (words[at] >> 16) as usize;
            if words[at] & 0xffff == 71 && count == 4 && words[at + 2] == 34 {
                words[at + 3] = 1;
                changed = true;
                break;
            }
            at += count;
        }
        assert!(changed);
        let caps = CAPABILITIES;
        assert!(
            std::panic::catch_unwind(|| decorations(&words, &caps, &[0, 1, 2, 3, 4, 5])).is_err()
        );
    }
}
