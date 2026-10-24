//! Immutable, private generated artifact/interface pair. No caller bytes enter.
use super::*;
mod bundle {
    include!(concat!(env!("OUT_DIR"), "/ui-artifacts.rs"));
}
pub(super) use bundle::BINDINGS;
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
pub(super) fn create(device: &wgpu::Device) -> Option<(wgpu::ShaderModule, wgpu::ShaderModule)> {
    let profile = device.shader_artifact_profile()?;
    let words = select(profile.revision(), profile.variant())?;
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
        device.create_shader_module_static_spirv(Some("GPUI offline compositor"), entries, words)
    };
    let vertex = module(&bundle::VERTEX, &ENTRIES[..1])?;
    let fragment = module(words, &ENTRIES[1..])?;
    Some((vertex, fragment))
}

fn select(revision: u32, variant: usize) -> Option<&'static [u32]> {
    if revision != bundle::REVISION {
        return None;
    }
    bundle::WORDS.get(variant).copied()
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn stale_revision_and_missing_variant_decline_before_raw_creation() {
        assert!(select(bundle::REVISION + 1, 0).is_none());
        assert!(select(bundle::REVISION, usize::MAX).is_none());
        for variant in 0..4 {
            assert!(select(bundle::REVISION, variant).is_some());
        }
    }
}
