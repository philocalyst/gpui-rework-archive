use crate::{
    shader_sources::{BASE_WGSL, SUBPIXEL_DUAL_SOURCE_WGSL},
    shaders::interface as shader,
};
use std::num::NonZeroU64;

pub(super) struct WgpuPipelines {
    pub(super) quads: WgpuRenderPipeline,
    pub(super) shadows: WgpuRenderPipeline,
    pub(super) path_rasterization: WgpuRenderPipeline,
    pub(super) paths: WgpuRenderPipeline,
    pub(super) underlines: WgpuRenderPipeline,
    pub(super) monochrome_sprites: WgpuRenderPipeline,
    pub(super) subpixel_sprites: Option<WgpuRenderPipeline>,
    pub(super) polychrome_sprites: WgpuRenderPipeline,
    pub(super) surfaces: WgpuRenderPipeline,
    pub(super) blur_downsample: WgpuRenderPipeline,
    pub(super) blur: WgpuRenderPipeline,
    pub(super) blur_composite: WgpuRenderPipeline,
}

pub(super) struct WgpuRenderPipeline {
    raw: wgpu::RenderPipeline,
    specification: shader::Pipeline,
}

impl WgpuRenderPipeline {
    pub(super) fn fixed_vertex_count(&self) -> u32 {
        self.specification.vertex_count.fixed().unwrap_or_else(|| {
            panic!(
                "pipeline {} uses a workload-defined vertex count",
                self.specification.label
            )
        })
    }
}

impl std::ops::Deref for WgpuRenderPipeline {
    type Target = wgpu::RenderPipeline;

    fn deref(&self) -> &Self::Target {
        &self.raw
    }
}

pub(super) struct WgpuBindGroupLayouts {
    pub(super) globals: wgpu::BindGroupLayout,
    pub(super) instances: wgpu::BindGroupLayout,
    pub(super) instances_with_texture: wgpu::BindGroupLayout,
    pub(super) surfaces: wgpu::BindGroupLayout,
    pub(super) blur: wgpu::BindGroupLayout,
}

impl WgpuBindGroupLayouts {
    pub(super) fn new(device: &wgpu::Device) -> Self {
        let globals = linked_bind_group_layout(
            device,
            "globals_layout",
            // Globals are shared by every non-subpixel pipeline, so derive visibility from the
            // complete linked module rather than whichever primitive happens to be created first.
            &crate::shaders::base::WGSL_SOURCE,
            shader::GLOBAL_BIND_GROUP,
            None,
        );
        let instances = linked_bind_group_layout(
            device,
            "instances_layout",
            &crate::shaders::quad::WGSL_SOURCE,
            shader::DATA_BIND_GROUP,
            None,
        );
        let instances_with_texture = linked_bind_group_layout(
            device,
            "instances_with_texture_layout",
            // Polychrome sprites exercise the full shared contract: instance data is consumed by
            // both stages, while the texture and sampler are consumed by the fragment stage.
            &crate::shaders::polychrome_sprite::WGSL_SOURCE,
            shader::DATA_BIND_GROUP,
            None,
        );
        let surfaces = linked_bind_group_layout(
            device,
            "surfaces_layout",
            &crate::shaders::surface::WGSL_SOURCE,
            shader::DATA_BIND_GROUP,
            Some(shader::DATA_BUFFER_BINDING),
        );
        let blur = linked_bind_group_layout(
            device,
            "blur_layout",
            &crate::shaders::blur::WGSL_SOURCE,
            shader::DATA_BIND_GROUP,
            Some(shader::DATA_BUFFER_BINDING),
        );
        Self {
            globals,
            instances,
            instances_with_texture,
            surfaces,
            blur,
        }
    }

    pub(super) fn create_globals(
        &self,
        device: &wgpu::Device,
        label: &str,
        globals: wgpu::BufferBinding,
        font_rasterization: wgpu::BufferBinding,
    ) -> wgpu::BindGroup {
        device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some(label),
            layout: &self.globals,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: shader::GLOBAL_UNIFORMS_BINDING,
                    resource: wgpu::BindingResource::Buffer(globals),
                },
                wgpu::BindGroupEntry {
                    binding: shader::FONT_RASTERIZATION_BINDING,
                    resource: wgpu::BindingResource::Buffer(font_rasterization),
                },
            ],
        })
    }

    pub(super) fn create_instances(
        &self,
        device: &wgpu::Device,
        instances: wgpu::BufferBinding,
    ) -> wgpu::BindGroup {
        device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("instances"),
            layout: &self.instances,
            entries: &[wgpu::BindGroupEntry {
                binding: shader::DATA_BUFFER_BINDING,
                resource: wgpu::BindingResource::Buffer(instances),
            }],
        })
    }

    pub(super) fn create_textured_instances(
        &self,
        device: &wgpu::Device,
        instances: wgpu::BufferBinding,
        texture: &wgpu::TextureView,
        sampler: &wgpu::Sampler,
    ) -> wgpu::BindGroup {
        device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("textured_instances"),
            layout: &self.instances_with_texture,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: shader::DATA_BUFFER_BINDING,
                    resource: wgpu::BindingResource::Buffer(instances),
                },
                wgpu::BindGroupEntry {
                    binding: shader::PRIMARY_TEXTURE_BINDING,
                    resource: wgpu::BindingResource::TextureView(texture),
                },
                wgpu::BindGroupEntry {
                    binding: shader::PRIMARY_SAMPLER_BINDING,
                    resource: wgpu::BindingResource::Sampler(sampler),
                },
            ],
        })
    }

    pub(super) fn create_surface(
        &self,
        device: &wgpu::Device,
        uniforms: wgpu::BufferBinding,
        color: &wgpu::TextureView,
        chroma: &wgpu::TextureView,
        sampler: &wgpu::Sampler,
    ) -> wgpu::BindGroup {
        device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("surface"),
            layout: &self.surfaces,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: shader::DATA_BUFFER_BINDING,
                    resource: wgpu::BindingResource::Buffer(uniforms),
                },
                wgpu::BindGroupEntry {
                    binding: shader::PRIMARY_TEXTURE_BINDING,
                    resource: wgpu::BindingResource::TextureView(color),
                },
                wgpu::BindGroupEntry {
                    binding: shader::SECONDARY_TEXTURE_BINDING,
                    resource: wgpu::BindingResource::TextureView(chroma),
                },
                wgpu::BindGroupEntry {
                    binding: shader::SURFACE_SAMPLER_BINDING,
                    resource: wgpu::BindingResource::Sampler(sampler),
                },
            ],
        })
    }

    pub(super) fn create_blur(
        &self,
        device: &wgpu::Device,
        uniforms: wgpu::BufferBinding,
        texture: &wgpu::TextureView,
        sampler: &wgpu::Sampler,
    ) -> wgpu::BindGroup {
        device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("blur"),
            layout: &self.blur,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: shader::DATA_BUFFER_BINDING,
                    resource: wgpu::BindingResource::Buffer(uniforms),
                },
                wgpu::BindGroupEntry {
                    binding: shader::PRIMARY_TEXTURE_BINDING,
                    resource: wgpu::BindingResource::TextureView(texture),
                },
                wgpu::BindGroupEntry {
                    binding: shader::PRIMARY_SAMPLER_BINDING,
                    resource: wgpu::BindingResource::Sampler(sampler),
                },
            ],
        })
    }
}

impl WgpuPipelines {
    pub(super) fn new(
        device: &wgpu::Device,
        bind_group_layouts: &WgpuBindGroupLayouts,
        surface_format: wgpu::TextureFormat,
        alpha_mode: wgpu::CompositeAlphaMode,
        path_sample_count: u32,
        dual_source_blending: bool,
    ) -> Self {
        let dual_source_blending = supported_dual_source_blending(device, dual_source_blending);
        let shader_module = create_shader_module(device, "gpui_shaders", BASE_WGSL);
        let subpixel_shader_module = dual_source_blending.then(|| {
            device.create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("gpui_subpixel_shaders"),
                source: wgpu::ShaderSource::Wgsl(std::borrow::Cow::Borrowed(
                    SUBPIXEL_DUAL_SOURCE_WGSL,
                )),
            })
        });

        let instance_layout = create_pipeline_layout(
            device,
            "instance_pipeline_layout",
            bind_group_layouts,
            &bind_group_layouts.instances,
        );
        let textured_layout = create_pipeline_layout(
            device,
            "textured_pipeline_layout",
            bind_group_layouts,
            &bind_group_layouts.instances_with_texture,
        );
        let surface_layout = create_pipeline_layout(
            device,
            "surface_pipeline_layout",
            bind_group_layouts,
            &bind_group_layouts.surfaces,
        );
        let blur_layout = create_pipeline_layout(
            device,
            "blur_pipeline_layout",
            bind_group_layouts,
            &bind_group_layouts.blur,
        );

        let scene_target = color_target(surface_format, Some(scene_blend_state(alpha_mode)));
        let path_rasterization_target = color_target(
            surface_format,
            Some(wgpu::BlendState::PREMULTIPLIED_ALPHA_BLENDING),
        );
        let path_target = color_target(surface_format, Some(path_blend_state()));
        let overwrite_target = color_target(surface_format, None);
        let composite_target =
            color_target(surface_format, Some(premultiplied_composite_blend_state()));

        let layout_for = |data_layout| match data_layout {
            shader::DataLayout::Instances => &instance_layout,
            shader::DataLayout::TexturedInstances => &textured_layout,
            shader::DataLayout::Surface => &surface_layout,
            shader::DataLayout::Blur => &blur_layout,
        };
        let create =
            |specification: shader::Pipeline, target: &wgpu::ColorTargetState, samples, module| {
                create_render_pipeline(
                    device,
                    specification,
                    layout_for(specification.data_layout),
                    target,
                    samples,
                    module,
                )
            };

        Self {
            quads: create(shader::QUADS, &scene_target, 1, &shader_module),
            shadows: create(shader::SHADOWS, &scene_target, 1, &shader_module),
            path_rasterization: create(
                shader::PATH_RASTERIZATION,
                &path_rasterization_target,
                path_sample_count,
                &shader_module,
            ),
            paths: create(shader::PATHS, &path_target, 1, &shader_module),
            underlines: create(shader::UNDERLINES, &scene_target, 1, &shader_module),
            monochrome_sprites: create(
                shader::MONOCHROME_SPRITES,
                &scene_target,
                1,
                &shader_module,
            ),
            subpixel_sprites: subpixel_shader_module.as_ref().map(|module| {
                create(
                    shader::SUBPIXEL_SPRITES,
                    &wgpu::ColorTargetState {
                        write_mask: wgpu::ColorWrites::COLOR,
                        ..color_target(surface_format, Some(subpixel_blend_state()))
                    },
                    1,
                    module,
                )
            }),
            polychrome_sprites: create(
                shader::POLYCHROME_SPRITES,
                &scene_target,
                1,
                &shader_module,
            ),
            surfaces: create(shader::SURFACES, &scene_target, 1, &shader_module),
            blur_downsample: create(
                shader::BLUR_DOWNSAMPLE,
                &overwrite_target,
                1,
                &shader_module,
            ),
            blur: create(shader::BLUR, &overwrite_target, 1, &shader_module),
            blur_composite: create(shader::BLUR_COMPOSITE, &composite_target, 1, &shader_module),
        }
    }
}

fn linked_bind_group_layout(
    device: &wgpu::Device,
    label: &str,
    source: &wgsl_rs::Source,
    group_index: u32,
    dynamic_uniform_binding: Option<u32>,
) -> wgpu::BindGroupLayout {
    let linkage = wgsl_rs::linkage::wgpu::analyze_wgsl_module(source)
        .unwrap_or_else(|error| panic!("failed to analyze shader module {}: {error}", source.name));
    let group = linkage.bind_group(group_index).unwrap_or_else(|| {
        panic!(
            "shader module {} has no bind group {group_index}",
            source.name
        )
    });
    let mut entries = group.entries.clone();
    let interface = naga_interface(source);

    for entry in &mut entries {
        entry.visibility = interface
            .bindings
            .iter()
            .find_map(|binding| {
                (binding.group == group_index && binding.binding == entry.binding)
                    .then_some(binding.visibility)
            })
            .unwrap_or_else(|| {
                panic!(
                    "Naga found no stage using shader binding {group_index}:{} in {}",
                    entry.binding, source.name
                )
            });

        if let wgpu::BindingType::Buffer { ty, .. } = entry.ty {
            let min_binding_size = linkage
                .buffers
                .iter()
                .find(|buffer| buffer.group == group_index && buffer.binding == entry.binding)
                .and_then(|buffer| NonZeroU64::new(buffer.size));
            entry.ty = wgpu::BindingType::Buffer {
                ty,
                has_dynamic_offset: dynamic_uniform_binding == Some(entry.binding),
                min_binding_size: interface
                    .bindings
                    .iter()
                    .find_map(|binding| {
                        (binding.group == group_index && binding.binding == entry.binding)
                            .then_some(binding.uniform_size)
                    })
                    .flatten()
                    .or(min_binding_size),
            };
        }
    }

    device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
        label: Some(label),
        entries: &entries,
    })
}

struct NagaBinding {
    group: u32,
    binding: u32,
    visibility: wgpu::ShaderStages,
    uniform_size: Option<NonZeroU64>,
}

struct NagaInterface {
    bindings: Vec<NagaBinding>,
}

fn naga_interface(source: &wgsl_rs::Source) -> NagaInterface {
    let generated = source.wgsl_source().unwrap_or_else(|error| {
        panic!("failed to generate shader module {}: {error}", source.name)
    });
    let module = naga::front::wgsl::parse_str(&generated)
        .unwrap_or_else(|error| panic!("failed to parse shader module {}: {error}", source.name));
    let info = naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::all(),
    )
    .validate(&module)
    .unwrap_or_else(|error| panic!("failed to validate shader module {}: {error}", source.name));
    let mut layouter = naga::proc::Layouter::default();
    layouter
        .update(module.to_ctx())
        .unwrap_or_else(|error| panic!("failed to lay out shader module {}: {error}", source.name));

    let bindings = module
        .global_variables
        .iter()
        .filter_map(|(handle, variable)| {
            let binding = variable.binding.as_ref()?;
            let mut visibility = wgpu::ShaderStages::empty();
            for (index, entry_point) in module.entry_points.iter().enumerate() {
                if !info.get_entry_point(index)[handle].is_empty() {
                    visibility |= match entry_point.stage {
                        naga::ShaderStage::Vertex => wgpu::ShaderStages::VERTEX,
                        naga::ShaderStage::Fragment => wgpu::ShaderStages::FRAGMENT,
                        naga::ShaderStage::Compute => wgpu::ShaderStages::COMPUTE,
                        naga::ShaderStage::Task => wgpu::ShaderStages::TASK,
                        naga::ShaderStage::Mesh => wgpu::ShaderStages::MESH,
                        naga::ShaderStage::RayGeneration => wgpu::ShaderStages::RAY_GENERATION,
                        naga::ShaderStage::Miss => wgpu::ShaderStages::MISS,
                        naga::ShaderStage::AnyHit => wgpu::ShaderStages::ANY_HIT,
                        naga::ShaderStage::ClosestHit => wgpu::ShaderStages::CLOSEST_HIT,
                    };
                }
            }
            Some(NagaBinding {
                group: binding.group,
                binding: binding.binding,
                visibility,
                uniform_size: (variable.space == naga::AddressSpace::Uniform).then(|| {
                    NonZeroU64::new(u64::from(layouter[variable.ty].size))
                        .expect("uniform types cannot be empty")
                }),
            })
        })
        .collect();
    NagaInterface { bindings }
}

fn create_shader_module(
    device: &wgpu::Device,
    label: &str,
    source: &'static str,
) -> wgpu::ShaderModule {
    device.create_shader_module(wgpu::ShaderModuleDescriptor {
        label: Some(label),
        source: wgpu::ShaderSource::Wgsl(std::borrow::Cow::Borrowed(source)),
    })
}

fn create_pipeline_layout(
    device: &wgpu::Device,
    label: &str,
    layouts: &WgpuBindGroupLayouts,
    data_layout: &wgpu::BindGroupLayout,
) -> wgpu::PipelineLayout {
    device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: Some(label),
        bind_group_layouts: &[Some(&layouts.globals), Some(data_layout)],
        immediate_size: 0,
    })
}

fn create_render_pipeline(
    device: &wgpu::Device,
    specification: shader::Pipeline,
    layout: &wgpu::PipelineLayout,
    color_target: &wgpu::ColorTargetState,
    sample_count: u32,
    module: &wgpu::ShaderModule,
) -> WgpuRenderPipeline {
    let raw = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some(specification.label),
        layout: Some(layout),
        vertex: wgpu::VertexState {
            module,
            entry_point: Some(specification.vertex_entry),
            buffers: &[],
            compilation_options: wgpu::PipelineCompilationOptions::default(),
        },
        fragment: Some(wgpu::FragmentState {
            module,
            entry_point: Some(specification.fragment_entry),
            targets: &[Some(color_target.clone())],
            compilation_options: wgpu::PipelineCompilationOptions::default(),
        }),
        primitive: wgpu::PrimitiveState {
            topology: specification.topology,
            ..Default::default()
        },
        depth_stencil: None,
        multisample: wgpu::MultisampleState {
            count: sample_count,
            ..Default::default()
        },
        multiview_mask: None,
        cache: None,
    });
    WgpuRenderPipeline { raw, specification }
}

fn color_target(
    format: wgpu::TextureFormat,
    blend: Option<wgpu::BlendState>,
) -> wgpu::ColorTargetState {
    wgpu::ColorTargetState {
        format,
        blend,
        write_mask: wgpu::ColorWrites::ALL,
    }
}

fn supported_dual_source_blending(device: &wgpu::Device, requested: bool) -> bool {
    let supported = device
        .features()
        .contains(wgpu::Features::DUAL_SOURCE_BLENDING);
    if requested && !supported {
        log::error!(
            "dual-source blending was requested but is absent from device features {:?}; falling \
             back to monochrome text rendering",
            device.features(),
        );
    }
    requested && supported
}

fn scene_blend_state(alpha_mode: wgpu::CompositeAlphaMode) -> wgpu::BlendState {
    let source_color_factor = if alpha_mode == wgpu::CompositeAlphaMode::PreMultiplied {
        wgpu::BlendFactor::One
    } else {
        wgpu::BlendFactor::SrcAlpha
    };
    source_over_blend_state(source_color_factor)
}

fn premultiplied_composite_blend_state() -> wgpu::BlendState {
    source_over_blend_state(wgpu::BlendFactor::One)
}

fn source_over_blend_state(source_color_factor: wgpu::BlendFactor) -> wgpu::BlendState {
    #[cfg(any(target_os = "macos", target_os = "windows"))]
    let destination_alpha_factor = wgpu::BlendFactor::One;
    #[cfg(not(any(target_os = "macos", target_os = "windows")))]
    let destination_alpha_factor = wgpu::BlendFactor::OneMinusSrcAlpha;

    wgpu::BlendState {
        color: wgpu::BlendComponent {
            src_factor: source_color_factor,
            dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
            operation: wgpu::BlendOperation::Add,
        },
        alpha: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::One,
            dst_factor: destination_alpha_factor,
            operation: wgpu::BlendOperation::Add,
        },
    }
}

fn path_blend_state() -> wgpu::BlendState {
    wgpu::BlendState {
        color: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::One,
            dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
            operation: wgpu::BlendOperation::Add,
        },
        alpha: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::One,
            dst_factor: wgpu::BlendFactor::One,
            operation: wgpu::BlendOperation::Add,
        },
    }
}

fn subpixel_blend_state() -> wgpu::BlendState {
    wgpu::BlendState {
        color: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::Src1,
            dst_factor: wgpu::BlendFactor::OneMinusSrc1,
            operation: wgpu::BlendOperation::Add,
        },
        alpha: wgpu::BlendComponent {
            src_factor: wgpu::BlendFactor::One,
            dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
            operation: wgpu::BlendOperation::Add,
        },
    }
}

#[cfg(test)]
pub(super) fn desktop_scene_blend_state(alpha_mode: wgpu::CompositeAlphaMode) -> wgpu::BlendState {
    scene_blend_state(alpha_mode)
}

#[cfg(all(test, not(target_family = "wasm")))]
mod tests {
    use super::*;
    use crate::WgpuContext;

    #[test]
    fn generated_layouts_create_every_pipeline_and_bind_group() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let device = &context.device;
        let layouts = WgpuBindGroupLayouts::new(device);
        let _pipelines = WgpuPipelines::new(
            device,
            &layouts,
            context.color_texture_format(),
            wgpu::CompositeAlphaMode::Opaque,
            1,
            context.supports_dual_source_blending(),
        );

        let buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("shader_interface_test_buffer"),
            size: 256,
            usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::STORAGE,
            mapped_at_creation: false,
        });
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("shader_interface_test_texture"),
            size: wgpu::Extent3d {
                width: 1,
                height: 1,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: wgpu::TextureFormat::Rgba8Unorm,
            usage: wgpu::TextureUsages::TEXTURE_BINDING,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        let sampler = device.create_sampler(&wgpu::SamplerDescriptor::default());
        let binding = || wgpu::BufferBinding {
            buffer: &buffer,
            offset: 0,
            size: NonZeroU64::new(256),
        };

        let _globals = layouts.create_globals(device, "test_globals", binding(), binding());
        let _instances = layouts.create_instances(device, binding());
        let _textured = layouts.create_textured_instances(device, binding(), &view, &sampler);
        let _surface = layouts.create_surface(device, binding(), &view, &view, &sampler);
        let _blur = layouts.create_blur(device, binding(), &view, &sampler);
        Ok(())
    }
}
