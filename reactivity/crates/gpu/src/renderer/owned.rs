//! Owned convenience API over the same borrowed rendering implementation.
use super::*;
use gpui_canvas::SlotEdit;

impl Renderer {
    /// Snapshot staging arrays after a successful full preparation only.
    /// This does not describe later slot patches or uncompleted GPU reads.
    #[cfg(feature = "packet-trace")]
    pub fn trace_packet(&self) -> PacketTrace {
        self.state.trace_packet()
    }

    pub async fn request(
        adapter: &wgpu::Adapter,
        format: wgpu::TextureFormat,
    ) -> Result<Self, Error> {
        let context = GpuContext::request(adapter, format).await?;
        let state = RendererState::new(&context);
        Ok(Self { context, state })
    }
    pub async fn new(
        device: wgpu::Device,
        queue: wgpu::Queue,
        format: wgpu::TextureFormat,
    ) -> Result<Self, Error> {
        let context = GpuContext::new(device, queue, format).await?;
        let state = RendererState::new(&context);
        Ok(Self { context, state })
    }
    /// Borrow this owner's context to create additional independent states.
    pub fn context(&self) -> &GpuContext {
        &self.context
    }
    pub fn device(&self) -> &wgpu::Device {
        self.context.device()
    }
    pub fn queue(&self) -> &wgpu::Queue {
        self.context.queue()
    }
    pub fn format(&self) -> wgpu::TextureFormat {
        self.context.format()
    }
    pub fn stats(&self) -> Stats {
        self.state.stats()
    }
    pub fn image_stats(&self) -> Option<ImageStats> {
        self.state.image_stats()
    }
    pub fn set_grouped_records(&mut self, enabled: bool) {
        self.state.set_grouped_records(enabled);
    }
    pub fn set_tile_proofs(&mut self, enabled: bool) {
        self.state.set_tile_proofs(enabled);
    }
    /// See [`RendererState::render`].
    #[inline]
    pub fn render(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        self.state.render(&self.context, scene, target)
    }
    /// See [`RendererState::redraw`].
    #[inline]
    pub fn redraw(
        &mut self,
        target: &wgpu::TextureView,
    ) -> Result<Option<wgpu::SubmissionIndex>, Error> {
        self.state.redraw(&self.context, target)
    }
    /// See [`RendererState::prepare_slots`].
    #[inline]
    pub fn prepare_slots<'owner, 'edits, 'target>(
        &'owner mut self,
        edits: &'edits [SlotEdit],
        target: &'target wgpu::TextureView,
    ) -> Result<GpuSlotCommit<'owner, 'edits, 'target>, SlotError> {
        self.state.prepare_slots(&self.context, edits, target)
    }
}
