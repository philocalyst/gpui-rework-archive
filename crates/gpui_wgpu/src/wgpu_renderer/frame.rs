use super::{
    WgpuRenderer, begin_color_render_pass,
    buffers::{InstanceTransport, InstanceUpload},
    filters::{FILTER_UNIFORMS_PER_COMPOSITE, FrameUniformRequirements},
    path_types,
};
use gpui::{
    FilterRenderTarget, MAX_FILTER_GROUP_DEPTH, MonochromeSprite, PolychromeSprite, PrimitiveBatch,
    Quad, RenderCommand, Scene, Shadow, SubpixelSprite, Underline,
};
use gpui_render::blur::{FilterCompositeClip, FilterCompositeParameters};
use gpui_render::shaders::{
    common::{FontRasterizationUniforms, GlobalUniforms, ShaderBool},
    interface as shader_interface,
};
use std::cell::Cell;

pub(super) fn render_to_view(
    renderer: &mut WgpuRenderer,
    scene: &Scene,
    frame_view: &wgpu::TextureView,
    readback: Option<ReadbackCopy<'_>>,
) -> Option<wgpu::SubmissionIndex> {
    render_to_view_measured(renderer, scene, frame_view, readback, None)
}

pub(super) fn render_to_view_measured(
    renderer: &mut WgpuRenderer,
    scene: &Scene,
    frame_view: &wgpu::TextureView,
    readback: Option<ReadbackCopy<'_>>,
    timestamps: Option<TimestampCapture<'_>>,
) -> Option<wgpu::SubmissionIndex> {
    let Some(targets) = PreparedTargets::prepare(renderer, scene, frame_view) else {
        return None;
    };
    // Prune once against the complete scene. Doing this inside each draw batch would evict a
    // texture that reappears after an intervening primitive and recreate its platform view.
    renderer.retain_surface_cache(&scene.surfaces);

    match FrameEncoder::new(renderer, scene, targets).encode(readback, timestamps) {
        Ok(command_buffer) => Some(renderer.resources().queue.submit([command_buffer])),
        Err(DrawError::ExternalSurface) => None,
        Err(DrawError::CapacityPlanningInvariant) => {
            log::error!("frame storage exceeded its precomputed capacity");
            None
        }
        Err(DrawError::MissingIntermediateTarget) => {
            log::error!("frame preparation did not create a required intermediate target");
            None
        }
    }
}

#[derive(Clone, Copy)]
pub(super) struct TimestampCapture<'a> {
    pub(super) query_set: &'a wgpu::QuerySet,
    pub(super) resolve_buffer: &'a wgpu::Buffer,
    pub(super) readback_buffer: &'a wgpu::Buffer,
    pub(super) next_query: &'a Cell<u32>,
    pub(super) query_capacity: u32,
}

impl<'a> TimestampCapture<'a> {
    pub(super) fn pass_writes(self) -> wgpu::RenderPassTimestampWrites<'a> {
        let start = self.next_query.get();
        let end = start
            .checked_add(1)
            .expect("GPU timestamp query index overflowed");
        let next = end
            .checked_add(1)
            .expect("GPU timestamp query count overflowed");
        assert!(
            next <= self.query_capacity,
            "GPU timestamp query capacity estimate was too small: need {next}, capacity {}",
            self.query_capacity
        );
        self.next_query.set(next);
        wgpu::RenderPassTimestampWrites {
            query_set: self.query_set,
            beginning_of_pass_write_index: Some(start),
            end_of_pass_write_index: Some(end),
        }
    }

    pub(super) fn query_count(self) -> u32 {
        self.next_query.get()
    }
}

pub(super) struct ReadbackCopy<'a> {
    pub(super) texture: &'a wgpu::Texture,
    pub(super) buffer: &'a wgpu::Buffer,
    pub(super) bytes_per_row: u32,
    pub(super) width: u32,
    pub(super) height: u32,
}

struct PreparedTargets {
    active: wgpu::TextureView,
    presentation: wgpu::TextureView,
    offscreen: Option<wgpu::TextureView>,
    instances: InstanceUpload,
}

impl PreparedTargets {
    fn prepare(
        renderer: &mut WgpuRenderer,
        scene: &Scene,
        frame_view: &wgpu::TextureView,
    ) -> Option<Self> {
        if !begin_frame(renderer) {
            return None;
        }
        let requirements = {
            let transport = renderer.resources().instances.transport();
            FrameRequirements::for_scene(scene, transport)
        };
        let device = renderer.resources().device.clone();
        let resources = renderer.resources_mut();
        if !resources.instances.ensure_capacity(
            &device,
            &resources.bind_group_layouts,
            requirements.storage_bytes,
            requirements.instance_batches,
        ) {
            return None;
        }
        let instances = {
            let resources = renderer.resources();
            resources.instances.begin_upload(
                &resources.queue,
                requirements.storage_bytes,
                requirements.instance_batches,
            )?
        };
        if !renderer.ensure_uniform_capacity(requirements.uniforms) {
            return None;
        }

        if requirements.uses_path_target {
            renderer.ensure_path_textures();
        }
        if requirements.uses_offscreen_target {
            renderer.ensure_filter_textures(requirements.isolated_target_count);
        }
        write_shader_globals(renderer);

        if requirements.uses_offscreen_target {
            let resources = renderer.resources();
            let offscreen = resources
                .scene_color_view
                .as_ref()
                .expect("blur texture preparation must create a scene target")
                .clone();
            Some(Self {
                active: offscreen.clone(),
                presentation: frame_view.clone(),
                offscreen: Some(offscreen),
                instances,
            })
        } else {
            Some(Self {
                active: frame_view.clone(),
                presentation: frame_view.clone(),
                offscreen: None,
                instances,
            })
        }
    }
}

fn begin_frame(renderer: &mut WgpuRenderer) -> bool {
    let Some(error) = renderer.faults.pending_error.lock().unwrap().take() else {
        renderer.faults.consecutive_failed_frames = 0;
        renderer.atlas.before_frame();
        return true;
    };

    renderer.faults.consecutive_failed_frames += 1;
    log::error!(
        "GPU error during frame (failure {} of 10): {error}",
        renderer.faults.consecutive_failed_frames
    );
    if renderer.faults.consecutive_failed_frames > 10 {
        panic!("too many consecutive GPU errors; last error: {error}");
    }
    if renderer.faults.consecutive_failed_frames > 5 {
        if let Some(resources) = renderer.resources.as_mut() {
            resources.invalidate_intermediate_textures();
        }
        renderer.atlas.clear();
        renderer.target.request_redraw();
        renderer.faults.consecutive_failed_frames = 0;
        return false;
    }

    renderer.atlas.before_frame();
    true
}

#[derive(Clone, Copy, PartialEq)]
pub(super) struct GlobalUniformState {
    globals: GlobalUniforms,
    path_globals: GlobalUniforms,
    font_rasterization: FontRasterizationUniforms,
}

fn write_shader_globals(renderer: &mut WgpuRenderer) {
    let font = renderer.rendering_params.font_rasterization;
    let font_rasterization = font.with_subpixel_order(renderer.subpixel_order).uniforms();
    let globals = GlobalUniforms {
        viewport_size: wgsl_rs::std::vec2f(
            renderer.target.width() as f32,
            renderer.target.height() as f32,
        ),
        premultiplied_alpha: ShaderBool::from(
            renderer.target.alpha_mode() == wgpu::CompositeAlphaMode::PreMultiplied,
        ),
        padding: 0,
    };
    let path_globals = GlobalUniforms {
        premultiplied_alpha: ShaderBool::Disabled,
        ..globals
    };
    let state = GlobalUniformState {
        globals,
        path_globals,
        font_rasterization,
    };
    if renderer.uploaded_globals == Some(state) {
        return;
    }

    let resources = renderer.resources();
    let globals_size = std::mem::size_of::<GlobalUniforms>();
    let font_size = std::mem::size_of::<FontRasterizationUniforms>();
    let upload_size = renderer.globals.font_offset + font_size as u64;
    let mut upload = resources
        .queue
        .write_buffer_with(
            &resources.globals_buffer,
            0,
            std::num::NonZeroU64::new(upload_size).expect("global uniforms are non-empty"),
        )
        .expect("global uniform upload must fit its buffer");
    upload.slice(..).fill(0);
    upload
        .slice(..globals_size)
        .copy_from_slice(shader_interface::bytes_of(&globals));
    upload
        .slice(
            renderer.globals.path_offset as usize
                ..renderer.globals.path_offset as usize + globals_size,
        )
        .copy_from_slice(shader_interface::bytes_of(&path_globals));
    upload
        .slice(
            renderer.globals.font_offset as usize
                ..renderer.globals.font_offset as usize + font_size,
        )
        .copy_from_slice(shader_interface::bytes_of(&font_rasterization));
    drop(upload);
    renderer.uploaded_globals = Some(state);
}

#[derive(Clone, Copy, Default)]
pub(super) struct FrameRequirements {
    storage_bytes: u64,
    /// Instance batches this frame; one downlevel range-uniform slot per batch.
    instance_batches: u64,
    pub(super) uniforms: FrameUniformRequirements,
    isolated_target_count: usize,
    uses_path_target: bool,
    uses_offscreen_target: bool,
}

pub(super) fn timestamp_query_capacity(scene: &Scene) -> anyhow::Result<u32> {
    let requirements = scene.render_plan().requirements();
    let commands = u64::try_from(requirements.command_count)
        .map_err(|_| anyhow::anyhow!("scene command count exceeds GPU timestamp limits"))?;
    let backdrop_filters = u64::try_from(requirements.backdrop_filter_count)
        .map_err(|_| anyhow::anyhow!("scene filter count exceeds GPU timestamp limits"))?;
    let isolated_filters = u64::try_from(requirements.isolated_filter_count)
        .map_err(|_| anyhow::anyhow!("scene filter count exceeds GPU timestamp limits"))?;
    let filters = backdrop_filters
        .checked_add(isolated_filters)
        .ok_or_else(|| anyhow::anyhow!("scene filter count exceeds GPU timestamp limits"))?;
    let offscreen_blit = u64::from(requirements.uses_offscreen_target);
    // Each command may break one paint pass, every path batch adds one raster pass, and each
    // filter composite can use downsample, horizontal, vertical, and composite passes.
    let pass_count = commands
        .checked_mul(2)
        .and_then(|count| count.checked_add(1))
        .and_then(|count| count.checked_add(filters.checked_mul(4)?))
        .and_then(|count| count.checked_add(offscreen_blit))
        .ok_or_else(|| anyhow::anyhow!("scene GPU timestamp capacity overflowed"))?;
    let query_count = pass_count
        .checked_mul(2)
        .ok_or_else(|| anyhow::anyhow!("scene GPU timestamp capacity overflowed"))?;
    let query_count = u32::try_from(query_count).map_err(|_| {
        anyhow::anyhow!("scene requires too many GPU timestamp queries: {query_count}")
    })?;
    anyhow::ensure!(
        query_count <= wgpu::QUERY_SET_MAX_QUERIES,
        "scene needs {query_count} GPU timestamp queries, exceeding WGPU's limit of {}",
        wgpu::QUERY_SET_MAX_QUERIES
    );
    Ok(query_count)
}

impl FrameRequirements {
    pub(super) fn for_scene(scene: &Scene, transport: InstanceTransport) -> Self {
        let planned = scene.render_plan().requirements();
        let mut storage_bytes = 0_u64;
        let mut instance_batches = 0_u64;
        let mut reserve = |element_size: usize, count: usize| {
            if count > 0 {
                let stride = element_size as u64;
                storage_bytes = storage_bytes.next_multiple_of(transport.batch_alignment(stride));
                storage_bytes = storage_bytes.saturating_add(stride.saturating_mul(count as u64));
                instance_batches += 1;
            }
        };

        for command in scene.render_commands() {
            let RenderCommand::Batch(batch) = command else {
                continue;
            };
            match batch {
                PrimitiveBatch::Shadows { range, .. } => {
                    reserve(std::mem::size_of::<Shadow>(), range.len())
                }
                PrimitiveBatch::Quads { range, .. } => {
                    reserve(std::mem::size_of::<Quad>(), range.len())
                }
                PrimitiveBatch::Paths {
                    rasterization_vertex_count,
                    sprite_count,
                    ..
                } if *rasterization_vertex_count > 0 => {
                    reserve(
                        std::mem::size_of::<path_types::PathRasterizationVertex>(),
                        *rasterization_vertex_count,
                    );
                    reserve(std::mem::size_of::<path_types::PathSprite>(), *sprite_count);
                }
                PrimitiveBatch::Underlines(range) => {
                    reserve(std::mem::size_of::<Underline>(), range.len())
                }
                PrimitiveBatch::MonochromeSprites { range, .. } => {
                    reserve(std::mem::size_of::<MonochromeSprite>(), range.len())
                }
                PrimitiveBatch::SubpixelSprites { range, .. } => {
                    reserve(std::mem::size_of::<SubpixelSprite>(), range.len())
                }
                PrimitiveBatch::PolychromeSprites { range, .. } => {
                    reserve(std::mem::size_of::<PolychromeSprite>(), range.len())
                }
                PrimitiveBatch::Paths { .. }
                | PrimitiveBatch::Surfaces(_)
                | PrimitiveBatch::BackdropFilters(_)
                | PrimitiveBatch::FilterBoundary(_) => {}
            }
        }
        debug_assert_eq!(instance_batches as usize, planned.instance_batch_count);

        Self {
            storage_bytes,
            instance_batches,
            uniforms: FrameUniformRequirements {
                filter_count: FILTER_UNIFORMS_PER_COMPOSITE
                    * (planned.backdrop_filter_count + planned.isolated_filter_count) as u64
                    + u64::from(planned.uses_offscreen_target),
                surface_count: planned.surface_count as u64,
            },
            isolated_target_count: planned.isolated_target_count,
            uses_path_target: planned.uses_path_target,
            uses_offscreen_target: planned.uses_offscreen_target,
        }
    }
}

struct FrameEncoder<'a> {
    renderer: &'a WgpuRenderer,
    scene: &'a Scene,
    encoder: wgpu::CommandEncoder,
    targets: TargetStack,
    offscreen: Option<wgpu::TextureView>,
    presentation: wgpu::TextureView,
    instances: InstanceUpload,
}

impl<'a> FrameEncoder<'a> {
    fn new(renderer: &'a WgpuRenderer, scene: &'a Scene, targets: PreparedTargets) -> Self {
        let encoder =
            renderer
                .resources()
                .device
                .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                    label: Some("gpui_frame"),
                });
        Self {
            renderer,
            scene,
            encoder,
            targets: TargetStack::new(targets.active),
            offscreen: targets.offscreen,
            presentation: targets.presentation,
            instances: targets.instances,
        }
    }

    fn encode(
        mut self,
        readback: Option<ReadbackCopy<'_>>,
        timestamps: Option<TimestampCapture<'_>>,
    ) -> Result<wgpu::CommandBuffer, DrawError> {
        let result = self.encode_commands(timestamps);
        if result.is_ok() {
            if let Some(offscreen) = &self.offscreen {
                self.renderer.blit_to_frame(
                    &mut self.encoder,
                    offscreen,
                    &self.presentation,
                    timestamps,
                );
            }
            if let Some(timestamps) = timestamps.filter(|timestamps| timestamps.query_count() > 0) {
                let query_count = timestamps.query_count();
                self.encoder.resolve_query_set(
                    timestamps.query_set,
                    0..query_count,
                    timestamps.resolve_buffer,
                    0,
                );
                self.encoder.copy_buffer_to_buffer(
                    timestamps.resolve_buffer,
                    0,
                    timestamps.readback_buffer,
                    0,
                    u64::from(query_count) * 8,
                );
            }
            if let Some(readback) = readback {
                self.encoder.copy_texture_to_buffer(
                    readback.texture.as_image_copy(),
                    wgpu::TexelCopyBufferInfo {
                        buffer: readback.buffer,
                        layout: wgpu::TexelCopyBufferLayout {
                            offset: 0,
                            bytes_per_row: Some(readback.bytes_per_row),
                            rows_per_image: Some(readback.height),
                        },
                    },
                    wgpu::Extent3d {
                        width: readback.width,
                        height: readback.height,
                        depth_or_array_layers: 1,
                    },
                );
            }
        }
        self.instances.finish(&mut self.encoder);
        self.renderer.resources().finish_frame_uploads();
        let command_buffer = self.encoder.finish();
        result.map(|()| command_buffer)
    }

    fn encode_commands(&mut self, timestamps: Option<TimestampCapture<'_>>) -> DrawResult {
        let paint_pass_draws = timestamps.map(|_| scene_paint_pass_draws(self.scene));
        let paint_pass_timestamps = |start: usize, draws_paths: bool| {
            timestamps
                .filter(|_| {
                    draws_paths || paint_pass_draws.as_ref().is_some_and(|draws| draws[start])
                })
                .map(TimestampCapture::pass_writes)
        };
        let mut pass = begin_scene_render_pass(
            self.renderer,
            &mut self.encoder,
            "main_pass",
            self.targets.current(),
            wgpu::LoadOp::Clear(self.renderer.target.clear_color()),
            paint_pass_timestamps(0, false),
        );

        for (command_index, command) in self.scene.render_commands().iter().enumerate() {
            match command {
                RenderCommand::Batch(PrimitiveBatch::Paths {
                    range,
                    rasterization_vertex_count,
                    sprite_count,
                    ..
                }) => {
                    if *rasterization_vertex_count == 0 {
                        continue;
                    }
                    let paths = &self.scene.paths[range.clone()];
                    drop(pass);
                    let rasterized = self.renderer.draw_paths_to_intermediate(
                        &mut self.encoder,
                        paths,
                        &mut self.instances,
                        timestamps,
                    );
                    pass = begin_scene_render_pass(
                        self.renderer,
                        &mut self.encoder,
                        "after_paths",
                        self.targets.current(),
                        wgpu::LoadOp::Load,
                        paint_pass_timestamps(command_index + 1, *sprite_count > 0),
                    );
                    rasterized?;
                    self.renderer.draw_paths_from_intermediate(
                        paths,
                        &mut self.instances,
                        &mut pass,
                    )?;
                }
                RenderCommand::Batch(PrimitiveBatch::BackdropFilters(range)) => {
                    drop(pass);
                    for filter in &self.scene.backdrop_filters[range.clone()] {
                        self.renderer.draw_backdrop_filter(
                            &mut self.encoder,
                            filter,
                            self.targets.current(),
                            timestamps,
                        );
                    }
                    pass = begin_scene_render_pass(
                        self.renderer,
                        &mut self.encoder,
                        "after_backdrop_filter",
                        self.targets.current(),
                        wgpu::LoadOp::Load,
                        paint_pass_timestamps(command_index + 1, false),
                    );
                }
                RenderCommand::Batch(PrimitiveBatch::FilterBoundary(_)) => {
                    unreachable!("filter boundaries must be compiled into render commands")
                }
                RenderCommand::Batch(batch) => encode_inline_batch(
                    self.renderer,
                    self.scene,
                    batch,
                    &mut self.instances,
                    &mut pass,
                )?,
                RenderCommand::BeginFilter {
                    target: FilterRenderTarget::Isolated(index),
                    ..
                } => {
                    drop(pass);
                    let target =
                        self.renderer.resources().filter_group_views[index.as_usize()].clone();
                    self.targets.enter(target);
                    pass = begin_scene_render_pass(
                        self.renderer,
                        &mut self.encoder,
                        "filter_group",
                        self.targets.current(),
                        wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                        paint_pass_timestamps(command_index + 1, false),
                    );
                }
                RenderCommand::EndFilter {
                    boundary_index,
                    target: FilterRenderTarget::Isolated(_),
                    ..
                } => {
                    drop(pass);
                    let (filtered, parent) = self.targets.exit();
                    let boundary = &self.scene.filter_boundaries[*boundary_index];
                    self.renderer.blur_and_composite(
                        &mut self.encoder,
                        &filtered,
                        parent,
                        FilterCompositeParameters {
                            bounds: boundary.bounds,
                            content_mask: boundary.content_mask.bounds,
                            corner_radii: boundary.corner_radii,
                            corner_smoothing: boundary.corner_smoothing,
                            blur_radius: boundary.max_blur_radius(),
                            opacity: boundary.opacity,
                            clip: FilterCompositeClip::ContentShape,
                        },
                        timestamps,
                    );
                    pass = begin_scene_render_pass(
                        self.renderer,
                        &mut self.encoder,
                        "after_content_filter",
                        self.targets.current(),
                        wgpu::LoadOp::Load,
                        paint_pass_timestamps(command_index + 1, false),
                    );
                }
                RenderCommand::BeginFilter {
                    target: FilterRenderTarget::Inline,
                    ..
                }
                | RenderCommand::EndFilter {
                    target: FilterRenderTarget::Inline,
                    ..
                } => {}
            }
        }
        drop(pass);
        self.targets.assert_balanced();
        Ok(())
    }
}

fn begin_scene_render_pass<'a>(
    renderer: &'a WgpuRenderer,
    encoder: &'a mut wgpu::CommandEncoder,
    label: &'a str,
    target: &'a wgpu::TextureView,
    load: wgpu::LoadOp<wgpu::Color>,
    timestamp_writes: Option<wgpu::RenderPassTimestampWrites<'a>>,
) -> wgpu::RenderPass<'a> {
    let mut pass = begin_color_render_pass(encoder, label, target, load, timestamp_writes);
    pass.set_bind_group(
        shader_interface::GLOBAL_BIND_GROUP,
        &renderer.resources().globals_bind_group,
        &[],
    );
    pass
}

fn scene_paint_pass_draws(scene: &Scene) -> Vec<bool> {
    let commands = scene.render_commands();
    let mut draws_by_start = vec![false; commands.len() + 1];
    let mut segment_start = 0;
    let mut segment_has_draw = false;

    for (index, command) in commands.iter().enumerate() {
        if paint_pass_breaks_at(command) {
            draws_by_start[segment_start] = segment_has_draw;
            segment_start = index + 1;
            segment_has_draw = false;
        } else if command_has_inline_draw(command) {
            segment_has_draw = true;
        }
    }
    draws_by_start[segment_start] = segment_has_draw;
    draws_by_start
}

fn paint_pass_breaks_at(command: &RenderCommand) -> bool {
    match command {
        RenderCommand::Batch(PrimitiveBatch::Paths {
            rasterization_vertex_count,
            ..
        }) => *rasterization_vertex_count > 0,
        RenderCommand::Batch(PrimitiveBatch::BackdropFilters(_)) => true,
        RenderCommand::BeginFilter {
            target: FilterRenderTarget::Isolated(_),
            ..
        }
        | RenderCommand::EndFilter {
            target: FilterRenderTarget::Isolated(_),
            ..
        } => true,
        _ => false,
    }
}

fn command_has_inline_draw(command: &RenderCommand) -> bool {
    match command {
        RenderCommand::Batch(PrimitiveBatch::Shadows { range, .. })
        | RenderCommand::Batch(PrimitiveBatch::Quads { range, .. })
        | RenderCommand::Batch(PrimitiveBatch::Underlines(range))
        | RenderCommand::Batch(PrimitiveBatch::MonochromeSprites { range, .. })
        | RenderCommand::Batch(PrimitiveBatch::SubpixelSprites { range, .. })
        | RenderCommand::Batch(PrimitiveBatch::PolychromeSprites { range, .. })
        | RenderCommand::Batch(PrimitiveBatch::Surfaces(range)) => !range.is_empty(),
        _ => false,
    }
}

struct TargetStack {
    current: wgpu::TextureView,
    parents: smallvec::SmallVec<[wgpu::TextureView; MAX_FILTER_GROUP_DEPTH]>,
}

impl TargetStack {
    fn new(root: wgpu::TextureView) -> Self {
        Self {
            current: root,
            parents: smallvec::SmallVec::new(),
        }
    }

    fn current(&self) -> &wgpu::TextureView {
        &self.current
    }

    fn enter(&mut self, next: wgpu::TextureView) {
        self.parents
            .push(std::mem::replace(&mut self.current, next));
    }

    fn exit(&mut self) -> (wgpu::TextureView, &wgpu::TextureView) {
        let parent = self
            .parents
            .pop()
            .expect("render plan ended an isolated filter without beginning one");
        let filtered = std::mem::replace(&mut self.current, parent);
        (filtered, &self.current)
    }

    fn assert_balanced(&self) {
        assert!(
            self.parents.is_empty(),
            "render plan left an isolated filter group open"
        );
    }
}

#[derive(Debug)]
pub(super) enum DrawError {
    CapacityPlanningInvariant,
    ExternalSurface,
    MissingIntermediateTarget,
}

pub(super) type DrawResult = Result<(), DrawError>;

fn encode_inline_batch(
    renderer: &WgpuRenderer,
    scene: &Scene,
    batch: &PrimitiveBatch,
    instances: &mut InstanceUpload,
    pass: &mut wgpu::RenderPass<'_>,
) -> DrawResult {
    match batch {
        PrimitiveBatch::Quads { range, smoothed } => {
            renderer.draw_quads(&scene.quads[range.clone()], *smoothed, instances, pass)
        }
        PrimitiveBatch::Shadows { range, smoothed } => {
            renderer.draw_shadows(&scene.shadows[range.clone()], *smoothed, instances, pass)
        }
        PrimitiveBatch::Underlines(range) => {
            renderer.draw_underlines(&scene.underlines[range.clone()], instances, pass)
        }
        PrimitiveBatch::MonochromeSprites { texture_id, range } => renderer
            .draw_monochrome_sprites(
                &scene.monochrome_sprites[range.clone()],
                *texture_id,
                instances,
                pass,
            ),
        PrimitiveBatch::SubpixelSprites { texture_id, range } => renderer.draw_subpixel_sprites(
            &scene.subpixel_sprites[range.clone()],
            *texture_id,
            instances,
            pass,
        ),
        PrimitiveBatch::PolychromeSprites {
            texture_id,
            range,
            smoothed,
        } => renderer.draw_polychrome_sprites(
            &scene.polychrome_sprites[range.clone()],
            *texture_id,
            *smoothed,
            instances,
            pass,
        ),
        PrimitiveBatch::Surfaces(range) => renderer.draw_surfaces(
            &scene.surfaces[range.clone()],
            &scene.surface_opacities()[range.clone()],
            pass,
        ),
        PrimitiveBatch::Paths { .. }
        | PrimitiveBatch::BackdropFilters(_)
        | PrimitiveBatch::FilterBoundary(_) => {
            unreachable!("pass-interrupting batches are handled by FrameEncoder")
        }
    }
}
