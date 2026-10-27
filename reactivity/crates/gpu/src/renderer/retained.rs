//! A renderer-owned image, never a preservation assumption about a swapchain.
use super::*;
use gpui_canvas::{DamageRegion, SlotEdit};

pub(super) struct Output<'a> {
    pub(super) view: &'a wgpu::TextureView,
    pub(super) damage: Option<DamageRegion>,
    pub(super) present: Option<(&'a Backing, &'a wgpu::TextureView)>,
}
impl<'a> From<&'a wgpu::TextureView> for Output<'a> {
    fn from(view: &'a wgpu::TextureView) -> Self {
        Self {
            view,
            damage: None,
            present: None,
        }
    }
}

/// Work and explicit image storage of the last successful retained submission.
/// Packet `Stats` still describe the complete admitted scene; these counters
/// describe the pixels actually submitted, not GPU time or driver allocations.
#[derive(Clone, Copy, Debug, Default)]
pub struct RetainedStats {
    pub composited_pixels: u64,
    pub copied_pixels: u64,
    pub image_bytes: u64,
}

/// Optional retained output over the unchanged full-frame renderer.
///
/// A single owned texture costs width × height × bytes-per-pixel. Every submit
/// copies it to the caller's fresh target; repair and copy use one command buffer.
/// `None` damage requests full compositing. `Some` is a caller certificate that
/// all differences from the last successful image are inside those device-pixel
/// bounds, including old and new support, clear/profile changes and removals.
/// Do not pass damage relative to a different scene or an untracked epoch.
/// Resize, failed scene preparation and diagnostic changes force a full render.
/// No source scene, target view or caller token is retained.
///
/// The immutable dereference exposes device, queue and packet diagnostics. There
/// is intentionally no mutable dereference that could silently invalidate pixels.
pub struct RetainedRenderer {
    inner: Renderer,
    backing: Option<Box<Backing>>,
    stats: RetainedStats,
}
impl std::ops::Deref for RetainedRenderer {
    type Target = Renderer;
    fn deref(&self) -> &Renderer {
        &self.inner
    }
}
impl RetainedRenderer {
    pub fn new(inner: Renderer) -> Self {
        Self {
            inner,
            backing: None,
            stats: RetainedStats::default(),
        }
    }
    pub fn retained_stats(&self) -> RetainedStats {
        self.stats
    }
    pub fn set_tile_proofs(&mut self, enabled: bool) {
        self.inner.set_tile_proofs(enabled);
    }
    pub fn set_grouped_records(&mut self, enabled: bool) {
        self.inner.set_grouped_records(enabled);
    }
    pub fn render(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
        damage: Option<DamageRegion>,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        let size = [scene.width, scene.height];
        // Invalidate image authority even when admission fails before uploads.
        let valid =
            self.backing.as_ref().is_some_and(|b| b.valid) && self.inner.state.packet.is_some();
        if let Some(backing) = &mut self.backing {
            backing.valid = false;
        }
        if size.contains(&0)
            || size.iter().any(|&n| n > 16_384)
            || u64::from(size[0]) * u64::from(size[1]) > MAX_PIXELS as u64
        {
            return Err(Error::ResourceLimit);
        }
        check_target(target, size, self.inner.format())?;
        check_damage(damage, size)?;
        let resized = self.backing.as_ref().is_none_or(|b| b.size() != size);
        if resized {
            let pipeline = self.backing.take().map(|b| b.pipeline);
            self.backing = Some(Box::new(Backing::new(&self.inner.context, size, pipeline)));
        }
        let backing = self.backing.as_mut().unwrap();
        let damage = damage.filter(|_| valid && !resized);
        let submitted = self.inner.state.render_observed(
            &self.inner.context,
            scene,
            backing.output(target, damage),
            |_, _, _, _| {},
        )?;
        backing.valid = true;
        self.stats = backing.stats(damage);
        Ok(submitted)
    }
    /// Copy the last successful image to a fresh target, without compositing.
    pub fn redraw(
        &mut self,
        target: &wgpu::TextureView,
    ) -> Result<Option<wgpu::SubmissionIndex>, Error> {
        let Some(backing) = self.backing.as_ref().filter(|b| b.valid) else {
            return Ok(None);
        };
        check_target(target, backing.size(), self.inner.format())?;
        let empty = Some(DamageRegion::default());
        let result = self
            .inner
            .state
            .redraw_output(&self.inner.context, backing.output(target, empty))?;
        if result.is_some() {
            self.stats = backing.stats(empty);
        }
        Ok(result)
    }
    /// Validate and commit a color-slot patch, then repair and copy the image.
    /// Rejection leaves the previous packet and image eligible for retry.
    pub fn patch_slots(
        &mut self,
        edits: &[SlotEdit],
        target: &wgpu::TextureView,
        damage: Option<DamageRegion>,
    ) -> Result<wgpu::SubmissionIndex, SlotError> {
        let backing = self
            .backing
            .as_ref()
            .filter(|b| b.valid)
            .ok_or(SlotError::NoPacket)?;
        check_target(target, backing.size(), self.inner.format())
            .map_err(|_| SlotError::InvalidTarget)?;
        check_damage(damage, backing.size()).map_err(|_| SlotError::InvalidTarget)?;
        let mut plan = self
            .inner
            .state
            .prepare_slots(&self.inner.context, edits, &backing.view)?;
        plan.output = backing.output(target, damage);
        let submitted = plan.commit();
        self.stats = backing.stats(damage);
        Ok(submitted)
    }
}
fn check_target(
    view: &wgpu::TextureView,
    size: [u32; 2],
    format: wgpu::TextureFormat,
) -> Result<(), Error> {
    if [view.texture().width(), view.texture().height()] != size
        || view.texture().format() != format
    {
        return Err(Error::InvalidScene);
    }
    Ok(())
}
fn check_damage(damage: Option<DamageRegion>, size: [u32; 2]) -> Result<(), Error> {
    if damage
        .and_then(|d| d.bounds())
        .is_some_and(|[_, _, right, bottom]| right > size[0] || bottom > size[1])
    {
        return Err(Error::InvalidScene);
    }
    Ok(())
}

pub(super) struct Backing {
    view: wgpu::TextureView,
    pipeline: wgpu::RenderPipeline,
    binding: wgpu::BindGroup,
    valid: bool,
}
impl Backing {
    fn new(context: &GpuContext, size: [u32; 2], pipeline: Option<wgpu::RenderPipeline>) -> Self {
        let device = context.device();
        let pipeline = pipeline.unwrap_or_else(|| {
            let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("GPUI retained image copy"),
                source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(include_str!("retained.wgsl"))),
            });
            device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
                label: Some("GPUI retained image copy"),
                layout: None,
                vertex: wgpu::VertexState {
                    module: &shader,
                    entry_point: Some("vertex"),
                    compilation_options: Default::default(),
                    buffers: &[],
                },
                fragment: Some(wgpu::FragmentState {
                    module: &shader,
                    entry_point: Some("fragment"),
                    compilation_options: Default::default(),
                    targets: &[Some(wgpu::ColorTargetState {
                        format: context.format(),
                        blend: None,
                        write_mask: wgpu::ColorWrites::ALL,
                    })],
                }),
                primitive: Default::default(),
                depth_stencil: None,
                multisample: Default::default(),
                multiview_mask: None,
                cache: None,
            })
        });
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("GPUI retained image"),
            size: wgpu::Extent3d {
                width: size[0],
                height: size[1],
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: context.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::TEXTURE_BINDING,
            view_formats: &[],
        });
        let view = texture.create_view(&Default::default());
        let binding = device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("GPUI retained image"),
            layout: &pipeline.get_bind_group_layout(0),
            entries: &[wgpu::BindGroupEntry {
                binding: 0,
                resource: wgpu::BindingResource::TextureView(&view),
            }],
        });
        Self {
            view,
            pipeline,
            binding,
            valid: false,
        }
    }
    fn size(&self) -> [u32; 2] {
        [self.view.texture().width(), self.view.texture().height()]
    }
    fn output<'a>(
        &'a self,
        target: &'a wgpu::TextureView,
        damage: Option<DamageRegion>,
    ) -> Output<'a> {
        Output {
            view: &self.view,
            damage,
            present: Some((self, target)),
        }
    }
    fn stats(&self, damage: Option<DamageRegion>) -> RetainedStats {
        let [width, height] = self.size();
        let pixels = u64::from(width) * u64::from(height);
        RetainedStats {
            composited_pixels: damage.map_or(pixels, |d| {
                d.bounds()
                    .map_or(0, |[l, t, r, b]| u64::from(r - l) * u64::from(b - t))
            }),
            copied_pixels: pixels,
            image_bytes: pixels
                * u64::from(self.view.texture().format().block_copy_size(None).unwrap()),
        }
    }
    pub(super) fn copy(&self, encoder: &mut wgpu::CommandEncoder, target: &wgpu::TextureView) {
        let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
            label: Some("GPUI retained image copy"),
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                view: target,
                resolve_target: None,
                depth_slice: None,
                ops: wgpu::Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                    store: wgpu::StoreOp::Store,
                },
            })],
            depth_stencil_attachment: None,
            timestamp_writes: None,
            occlusion_query_set: None,
            multiview_mask: None,
        });
        pass.set_pipeline(&self.pipeline);
        pass.set_bind_group(0, &self.binding, &[]);
        pass.draw(0..3, 0..1);
    }
}

#[cfg(test)]
mod damage_header_ledger {
    use super::*;
    #[test]
    fn retained_damage_headers() {
        eprintln!(
            "DAMAGE_GPU_HEADERS,Output={},Backing={},RetainedRenderer={},Renderer={}",
            size_of::<Output<'_>>(),
            size_of::<Backing>(),
            size_of::<RetainedRenderer>(),
            size_of::<Renderer>()
        );
    }
}
