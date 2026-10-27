//! Candidate strategy; common workload and fresh full oracle are unchanged.
use gpui_canvas::{DamageRegion, PreparedScene, TextRunSlot};
use gpui_gpu::{RetainedRenderer, wgpu};
pub fn render(
    renderer: &mut RetainedRenderer,
    scene: PreparedScene<'_>,
    slots: &[TextRunSlot],
    target: &wgpu::TextureView,
    damage: Option<DamageRegion>,
    sparse: bool,
) {
    if sparse {
        let edits: Option<Vec<_>> = slots
            .iter()
            .map(|&slot| scene.text_run(slot).map(|group| (slot, group)))
            .collect();
        if let Some(edits) = edits
            && renderer.patch_texts(&edits, target, damage).is_ok()
        {
            return;
        }
    }
    renderer.render(scene, target, damage).unwrap();
}
