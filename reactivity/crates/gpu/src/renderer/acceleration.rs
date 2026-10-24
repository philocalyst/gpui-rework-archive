//! Cold, owned work. Installing its result needs the context's exclusive borrow.
use super::*;

#[path = "../clip_specialization.rs"]
mod specialization;
// Clip addresses precede material tails and cannot equal the cache sentinel.
const _: () = assert!(
    MAX_DRAWS * 6 + MAX_DRAWS * 2 + MAX_DRAWS / 32 + 1 + gpui_canvas::MAX_CLIP_NODES * 5
        < u32::MAX as usize
);

/// An optional compilation job for one exact context. Preparing it may enter
/// driver locks; callers choose an appropriate cold worker or idle boundary.
/// It owns one device and layout lease, with no scene/window reference.
pub struct ClipAccelerationJob {
    device: wgpu::Device,
    layout: wgpu::BindGroupLayout,
    format: wgpu::TextureFormat,
}
/// A prepared optional pipeline, installable only in its originating context.
pub struct PreparedClipAcceleration {
    layout: wgpu::BindGroupLayout,
    pipeline: wgpu::RenderPipeline,
}
impl ClipAccelerationJob {
    pub async fn prepare(self) -> Result<PreparedClipAcceleration, Error> {
        let (pipeline, layout) =
            create_pipeline(&self.device, self.format, Some(self.layout), true).await?;
        Ok(PreparedClipAcceleration { layout, pipeline })
    }
}
impl GpuContext {
    /// Mint cold work once the application observes useful clip reuse. No
    /// compilation occurs here. Dropping the job cancels unstarted work.
    pub fn clip_acceleration_job(&self) -> Option<ClipAccelerationJob> {
        self.clip_pipeline.is_none().then(|| ClipAccelerationJob {
            device: self.device.clone(),
            layout: self.layout.clone(),
            format: self.format,
        })
    }
    /// Install under exclusive ownership. A foreign context, including another
    /// context on the same device/format, cannot accept this capability.
    /// Retire a lost device's context and states together, as for base rendering.
    pub fn install_clip_acceleration(
        &mut self,
        prepared: PreparedClipAcceleration,
    ) -> Result<bool, Error> {
        if prepared.layout != self.layout {
            return Err(Error::IncompatibleContext);
        }
        if self.clip_pipeline.is_some() {
            return Ok(false);
        }
        self.clip_pipeline = Some(prepared.pipeline);
        Ok(true)
    }
}
impl RendererState {
    /// Eligibility belongs to the successfully admitted packet's sampled CSR.
    /// Unreferenced clip arena nodes and certified uniform tiles do not count.
    pub fn benefits_from_clip_acceleration(&self) -> bool {
        self.packet.as_ref().is_some_and(Packet::clip_accelerated)
    }
}
impl Renderer {
    /// Return cold work only when the current admitted packet can reuse chains.
    pub fn clip_acceleration_job(&self) -> Option<ClipAccelerationJob> {
        self.state
            .benefits_from_clip_acceleration()
            .then(|| self.context.clip_acceleration_job())
            .flatten()
    }
    pub fn install_clip_acceleration(
        &mut self,
        prepared: PreparedClipAcceleration,
    ) -> Result<bool, Error> {
        self.context.install_clip_acceleration(prepared)
    }
}

// Preserve one original baseline shader. The portable and offline paths share
// the same explicit layout; inferred layouts are exclusive to one pipeline.
pub(super) fn interface(device: &wgpu::Device) -> wgpu::BindGroupLayout {
    let buffer = |binding, size, uniform| wgpu::BindGroupLayoutEntry {
        binding,
        visibility: wgpu::ShaderStages::FRAGMENT,
        ty: wgpu::BindingType::Buffer {
            ty: if uniform {
                wgpu::BufferBindingType::Uniform
            } else {
                wgpu::BufferBindingType::Storage { read_only: true }
            },
            has_dynamic_offset: false,
            min_binding_size: wgpu::BufferSize::new(size),
        },
        count: None,
    };
    let entries = [
        buffer(0, 48, true),
        buffer(1, 16, false),
        buffer(2, 8, false),
        buffer(3, 4, false),
        wgpu::BindGroupLayoutEntry {
            binding: 4,
            visibility: wgpu::ShaderStages::FRAGMENT,
            ty: wgpu::BindingType::Texture {
                sample_type: wgpu::TextureSampleType::Float { filterable: false },
                view_dimension: wgpu::TextureViewDimension::D2,
                multisampled: false,
            },
            count: None,
        },
        buffer(5, 32, false),
    ];
    #[cfg(feature = "offline-shader")]
    assert_eq!(entries, artifact::BINDINGS);
    device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
        label: Some("GPUI compositor interface"),
        entries: &entries,
    })
}

pub(super) async fn create_pipeline(
    device: &wgpu::Device,
    format: wgpu::TextureFormat,
    layout: Option<wgpu::BindGroupLayout>,
    accelerated: bool,
) -> Result<(wgpu::RenderPipeline, wgpu::BindGroupLayout), Error> {
    let internal = device.push_error_scope(wgpu::ErrorFilter::Internal);
    let memory = device.push_error_scope(wgpu::ErrorFilter::OutOfMemory);
    let errors = device.push_error_scope(wgpu::ErrorFilter::Validation);
    let layout = layout.unwrap_or_else(|| interface(device));
    #[cfg(feature = "offline-shader")]
    let artifact = if accelerated {
        None
    } else {
        artifact::create(device)
    };
    #[cfg(not(feature = "offline-shader"))]
    let artifact = None::<(wgpu::ShaderModule, wgpu::ShaderModule)>;
    let (vertex, fragment) = match artifact {
        Some((vertex, fragment)) => (vertex, Some(fragment)),
        None => (
            device.create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("GPUI compositor"),
                source: wgpu::ShaderSource::Wgsl(if accelerated {
                    Cow::Owned(specialization::specialize(SHADER_SOURCE))
                } else {
                    Cow::Borrowed(SHADER_SOURCE)
                }),
            }),
            None,
        ),
    };
    let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: Some("GPUI compositor"),
        bind_group_layouts: &[Some(&layout)],
        immediate_size: 0,
    });
    let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: Some("GPUI compositor"),
        layout: Some(&pipeline_layout),
        vertex: wgpu::VertexState {
            module: &vertex,
            entry_point: Some("vertex"),
            compilation_options: Default::default(),
            buffers: &[],
        },
        primitive: Default::default(),
        depth_stencil: None,
        multisample: Default::default(),
        fragment: Some(wgpu::FragmentState {
            module: fragment.as_ref().unwrap_or(&vertex),
            entry_point: Some("fragment"),
            compilation_options: Default::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format,
                blend: None,
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        multiview_mask: None,
        cache: None,
    });
    // Also reject an invalid pipeline after loss: creation errors on a dead
    // device may be ignored, but a dead pipeline cannot return this layout.
    let actual = pipeline.get_bind_group_layout(0);
    let error = errors.pop().await;
    let memory = memory.pop().await;
    let internal = internal.pop().await;
    if let Some(error) = error.or(memory).or(internal) {
        return Err(Error::Shader(error.to_string()));
    }
    if actual != layout {
        return Err(Error::Shader("invalid compositor layout".into()));
    }
    Ok((pipeline, layout))
}

pub(super) fn repeats_chain(records: &[Word], references: &[u32], range: [u32; 2]) -> bool {
    let mut previous = u32::MAX;
    for &address in &references[range[0] as usize..range[1] as usize] {
        let base = (address & !INLINE_RECORD) as usize;
        let clip = if address & INLINE_RECORD != 0 {
            records[base + 3]
        } else {
            records[records[base + 1][3] as usize + 2]
        };
        if clip[0] == 0x7fc0_0003 {
            if previous == clip[1] {
                return true;
            }
            previous = clip[1];
        }
    }
    false
}
