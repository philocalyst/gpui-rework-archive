use super::*;

pub(in crate::wgpu_renderer) struct SurfaceCache;

impl SurfaceCache {
    pub(in crate::wgpu_renderer) fn new(_device: &wgpu::Device) -> anyhow::Result<Self> {
        Ok(Self)
    }
}

pub(super) fn draw_surfaces(
    _renderer: &WgpuRenderer,
    _surfaces: &[PaintSurface],
    _pass: &mut wgpu::RenderPass<'_>,
) -> frame::DrawResult {
    Ok(())
}
