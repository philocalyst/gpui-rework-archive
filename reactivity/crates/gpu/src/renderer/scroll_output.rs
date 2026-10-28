//! Keep copy/repair submission separate from the ordinary full/region body.
use super::*;
use gpui_canvas::ScrollCopy;

impl GpuContext {
    #[inline(never)]
    pub(super) fn submit_scroll(
        &self,
        output: Output<'_>,
        bindings: &wgpu::BindGroup,
        scroll: &ScrollCopy,
    ) -> wgpu::SubmissionIndex {
        let (backing, target) = output.present.expect("retained scroll backing");
        let mut encoder = self
            .device
            .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                label: Some("GPUI frame"),
            });
        backing.scroll(&mut encoder, scroll);
        if scroll.repairs().next().is_some() {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("GPUI frame"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: output.view,
                    resolve_target: None,
                    depth_slice: None,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Load,
                        store: wgpu::StoreOp::Store,
                    },
                })],
                depth_stencil_attachment: None,
                timestamp_writes: None,
                occlusion_query_set: None,
                multiview_mask: None,
            });
            pass.set_pipeline(&self.pipeline);
            pass.set_bind_group(0, bindings, &[]);
            for repair in scroll.repairs() {
                if let Some([l, t, r, b]) = repair.bounds() {
                    pass.set_scissor_rect(l, t, r - l, b - t);
                    pass.draw(0..3, 0..1);
                }
            }
        }
        backing.copy(&mut encoder, target);
        self.queue.submit([encoder.finish()])
    }
}
