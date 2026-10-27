use gpui_gpu::RetainedRenderer;
pub fn map_bytes(renderer: &RetainedRenderer) -> usize {
    renderer.text_packet_capacity_bytes()
}
