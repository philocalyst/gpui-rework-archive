//! Control strategy; the common fixture and oracle are unchanged across variants.
use gpui_canvas::{DamageRegion, PreparedScene, TextRunSlot};
use gpui_gpu::{RetainedRenderer, wgpu};
pub fn render(
    renderer: &mut RetainedRenderer,
    scene: PreparedScene<'_>,
    _slots: &[TextRunSlot],
    target: &wgpu::TextureView,
    damage: Option<DamageRegion>,
    _sparse: bool,
) {
    renderer.render(scene, target, damage).unwrap();
}
