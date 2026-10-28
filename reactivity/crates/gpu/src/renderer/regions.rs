//! One draw for disjoint certified pixel rectangles, with canonical fragments.
use super::*;
use gpui_canvas::DamageRegions;

const MAX_REGIONS: usize = 64;
const INSTANCE_BYTES: u64 = 16;

pub(super) struct RegionBatch {
    pipeline: wgpu::RenderPipeline,
    vertices: wgpu::Buffer,
}
impl RegionBatch {
    pub(super) fn new(context: &GpuContext) -> Self {
        let device = &context.device;
        let vertex = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("GPUI repair rectangles"),
            source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(include_str!(concat!(
                env!("OUT_DIR"),
                "/region.wgsl"
            )))),
        });
        let fragment = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("GPUI canonical repair fragments"),
            source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(SHADER_SOURCE)),
        });
        let layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
            label: Some("GPUI repair rectangles"),
            bind_group_layouts: &[Some(&context.layout)],
            immediate_size: 0,
        });
        let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
            label: Some("GPUI repair rectangles"),
            layout: Some(&layout),
            vertex: wgpu::VertexState {
                module: &vertex,
                entry_point: Some("vertex"),
                compilation_options: Default::default(),
                buffers: &[Some(wgpu::VertexBufferLayout {
                    array_stride: INSTANCE_BYTES,
                    step_mode: wgpu::VertexStepMode::Instance,
                    attributes: &wgpu::vertex_attr_array![0 => Float32x4],
                })],
            },
            fragment: Some(wgpu::FragmentState {
                module: &fragment,
                entry_point: Some("fragment"),
                compilation_options: Default::default(),
                targets: &[Some(wgpu::ColorTargetState {
                    format: context.format,
                    blend: None,
                    write_mask: wgpu::ColorWrites::ALL,
                })],
            }),
            primitive: Default::default(),
            depth_stencil: None,
            multisample: Default::default(),
            multiview_mask: None,
            cache: None,
        });
        let vertices = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("GPUI repair rectangle instances"),
            size: MAX_REGIONS as u64 * INSTANCE_BYTES,
            usage: wgpu::BufferUsages::VERTEX | wgpu::BufferUsages::COPY_DST,
            mapped_at_creation: false,
        });
        Self { pipeline, vertices }
    }

    pub(super) fn write(
        &self,
        context: &GpuContext,
        regions: &DamageRegions,
        size: [u32; 2],
    ) -> Result<u32, Error> {
        if regions.regions().len() > MAX_REGIONS {
            return Err(Error::ResourceLimit);
        }
        // Dimensions and every edge were admitted before reaching this point.
        // At <=16384 pixels these rounded edges remain well within half a pixel
        // of their integer boundary. The fragment still sees exact pixel centers.
        let mut edges = [[0.0f32; 4]; MAX_REGIONS];
        let mut count = 0;
        for region in regions.regions() {
            if let Some([l, t, r, b]) = region.bounds() {
                edges[count] = [
                    2.0 * l as f32 / size[0] as f32 - 1.0,
                    1.0 - 2.0 * t as f32 / size[1] as f32,
                    2.0 * r as f32 / size[0] as f32 - 1.0,
                    1.0 - 2.0 * b as f32 / size[1] as f32,
                ];
                count += 1;
            }
        }
        if count != 0 {
            context
                .queue
                .write_buffer(&self.vertices, 0, bytemuck::cast_slice(&edges[..count]));
        }
        Ok(count as u32)
    }

    pub(super) fn submit(
        &self,
        context: &GpuContext,
        output: Output<'_>,
        bindings: &wgpu::BindGroup,
        count: u32,
    ) -> wgpu::SubmissionIndex {
        let mut encoder = context
            .device
            .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                label: Some("GPUI batched repair"),
            });
        if count != 0 {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("GPUI batched repair"),
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
            pass.set_vertex_buffer(0, self.vertices.slice(..u64::from(count) * INSTANCE_BYTES));
            pass.draw(0..6, 0..count);
        }
        if let Some((backing, target)) = output.present {
            backing.copy(&mut encoder, target);
        }
        context.queue.submit([encoder.finish()])
    }
}
