//! Immutable, private generated artifact/interface pair. No caller bytes enter.
use super::*;
mod bundle {
    include!(concat!(env!("OUT_DIR"), "/ui-artifacts.rs"));
}
static ENTRIES: [wgpu::PassthroughShaderEntryPoint<'static>; 2] = [
    wgpu::PassthroughShaderEntryPoint {
        name: Cow::Borrowed("vertex"),
        workgroup_size: (0, 0, 0),
    },
    wgpu::PassthroughShaderEntryPoint {
        name: Cow::Borrowed("fragment"),
        workgroup_size: (0, 0, 0),
    },
];
pub(super) fn create(
    device: &wgpu::Device,
) -> Option<(
    wgpu::ShaderModule,
    wgpu::ShaderModule,
    wgpu::BindGroupLayout,
    wgpu::PipelineLayout,
)> {
    let profile = device.shader_artifact_profile()?;
    if profile.revision() != bundle::REVISION {
        return None;
    }
    let words = *bundle::WORDS.get(profile.variant())?;
    // Every context creates a fresh BGL, preserving the retained layout's
    // context-identity certificate even when hardware interns its layout data.
    let layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
        label: Some("GPUI offline compositor"),
        entries: &bundle::BINDINGS,
    });
    let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: Some("GPUI offline compositor"),
        bind_group_layouts: &[Some(&layout)],
        immediate_size: 0,
    });
    // SAFETY: shader_build mechanically generated these immutable aligned
    // words and their exact interface together from our typed WGSL. It checks
    // Naga input/output validation, descriptor/ABI reflection, baseline SPIR-V
    // capabilities and spirv-val(vulkan1.0). Device admission above proves the
    // enabled backend/feature and effective buffer/image guard policy. Local
    // indices, loops and integer division remain guarded; no Y adjustment is
    // emitted because the admitted backend uses a negative-height viewport.
    // No external bytes, caller-selected profile or reusable foreign BGL enter.
    // Runtime shader/pipeline errors remain in the caller's error scopes.
    let module = |words: &'static [u32],
                  entries: &'static [wgpu::PassthroughShaderEntryPoint<'static>]| unsafe {
        device.create_shader_module_passthrough(wgpu::ShaderModuleDescriptorPassthrough {
            label: Some("GPUI offline compositor"),
            entry_points: Cow::Borrowed(entries),
            spirv: Some(Cow::Borrowed(words)),
            ..Default::default()
        })
    };
    let vertex = module(&bundle::VERTEX, &ENTRIES[..1]);
    let fragment = module(words, &ENTRIES[1..]);
    Some((vertex, fragment, layout, pipeline_layout))
}
