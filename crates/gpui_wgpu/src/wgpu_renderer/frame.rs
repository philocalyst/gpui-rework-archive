use super::{
    FilterCompositeClip, FilterCompositeParameters, WgpuRenderer, begin_color_render_pass,
    buffers::InstanceUpload, path_types,
};
use crate::shaders::{
    common::{FontRasterizationUniforms, GlobalUniforms, ShaderBool},
    interface as shader_interface,
};
use gpui::{
    FilterRenderTarget, MonochromeSprite, PolychromeSprite, PrimitiveBatch, Quad, RenderCommand,
    Scene, Shadow, SubpixelSprite, Underline,
};

pub(super) fn render_to_view(
    renderer: &mut WgpuRenderer,
    scene: &Scene,
    frame_view: &wgpu::TextureView,
) -> bool {
    let Some(targets) = PreparedTargets::prepare(renderer, scene, frame_view) else {
        return false;
    };

    match FrameEncoder::new(renderer, scene, targets).encode() {
        Ok(command_buffer) => {
            renderer.resources().queue.submit([command_buffer]);
            true
        }
        Err(DrawError::ExternalSurface) => false,
        Err(DrawError::CapacityPlanningInvariant) => {
            log::error!("frame storage exceeded its precomputed capacity");
            false
        }
        Err(DrawError::MissingIntermediateTarget) => {
            log::error!("frame preparation did not create a required intermediate target");
            false
        }
    }
}

struct PreparedTargets {
    active: wgpu::TextureView,
    presentation: wgpu::TextureView,
    offscreen: Option<wgpu::TextureView>,
    filter_groups: Vec<wgpu::TextureView>,
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
        let required_storage =
            FrameStorageRequirements::for_scene(scene, renderer.resources().instances.alignment());
        let device = renderer.resources().device.clone();
        if !renderer
            .resources_mut()
            .instances
            .ensure_capacity(&device, required_storage.bytes)
        {
            return None;
        }
        let instances = {
            let resources = renderer.resources();
            resources
                .instances
                .begin_upload(&resources.queue, required_storage.bytes)?
        };
        if !renderer.ensure_uniform_capacity(scene) {
            return None;
        }

        renderer.ensure_intermediate_textures();
        let uses_offscreen_target = scene.requires_offscreen_rendering();
        if uses_offscreen_target {
            renderer.ensure_blur_textures();
        }
        write_shader_globals(renderer);

        if uses_offscreen_target {
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
                filter_groups: resources.filter_group_views.clone(),
                instances,
            })
        } else {
            Some(Self {
                active: frame_view.clone(),
                presentation: frame_view.clone(),
                offscreen: None,
                filter_groups: Vec::new(),
                instances,
            })
        }
    }
}

fn begin_frame(renderer: &mut WgpuRenderer) -> bool {
    let Some(error) = renderer.last_error.lock().unwrap().take() else {
        renderer.failed_frame_count = 0;
        renderer.atlas.before_frame();
        return true;
    };

    renderer.failed_frame_count += 1;
    log::error!(
        "GPU error during frame (failure {} of 10): {error}",
        renderer.failed_frame_count
    );
    if renderer.failed_frame_count > 10 {
        panic!("too many consecutive GPU errors; last error: {error}");
    }
    if renderer.failed_frame_count > 5 {
        if let Some(resources) = renderer.resources.as_mut() {
            resources.invalidate_intermediate_textures();
        }
        renderer.atlas.clear();
        renderer.target.request_redraw();
        renderer.failed_frame_count = 0;
        return false;
    }

    renderer.atlas.before_frame();
    true
}

fn write_shader_globals(renderer: &WgpuRenderer) {
    let font = renderer.rendering_params.font_rasterization;
    let font_rasterization = FontRasterizationUniforms {
        gamma_ratios: wgsl_rs::std::vec4f(
            font.gamma_ratios[0],
            font.gamma_ratios[1],
            font.gamma_ratios[2],
            font.gamma_ratios[3],
        ),
        grayscale_enhanced_contrast: font.grayscale_enhanced_contrast,
        subpixel_enhanced_contrast: font.subpixel_enhanced_contrast,
        uses_blue_green_red_subpixel_order: ShaderBool::from(
            renderer.subpixel_order == super::SubpixelOrder::BlueGreenRed,
        ),
        padding: 0,
    };
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

    let resources = renderer.resources();
    let globals_size = std::mem::size_of::<GlobalUniforms>();
    let font_size = std::mem::size_of::<FontRasterizationUniforms>();
    let upload_size = renderer.gamma_offset + font_size as u64;
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
            renderer.path_globals_offset as usize
                ..renderer.path_globals_offset as usize + globals_size,
        )
        .copy_from_slice(shader_interface::bytes_of(&path_globals));
    upload
        .slice(renderer.gamma_offset as usize..renderer.gamma_offset as usize + font_size)
        .copy_from_slice(shader_interface::bytes_of(&font_rasterization));
}

#[derive(Default)]
struct FrameStorageRequirements {
    bytes: u64,
    alignment: u64,
}

impl FrameStorageRequirements {
    fn for_scene(scene: &Scene, alignment: u64) -> Self {
        let mut requirements = Self {
            alignment,
            ..Self::default()
        };
        for command in scene.render_commands() {
            let RenderCommand::Batch(batch) = command else {
                continue;
            };
            match batch {
                PrimitiveBatch::Quads(range) => requirements.reserve::<Quad>(range.len()),
                PrimitiveBatch::Shadows(range) => requirements.reserve::<Shadow>(range.len()),
                PrimitiveBatch::Paths(range) => {
                    let paths = &scene.paths[range];
                    let vertex_count = path_types::rasterization_vertex_count(paths);
                    requirements.reserve::<path_types::PathRasterizationVertex>(vertex_count);
                    if vertex_count > 0 {
                        requirements
                            .reserve::<path_types::PathSprite>(path_types::sprite_count(paths));
                    }
                }
                PrimitiveBatch::Underlines(range) => requirements.reserve::<Underline>(range.len()),
                PrimitiveBatch::MonochromeSprites { range, .. } => {
                    requirements.reserve::<MonochromeSprite>(range.len())
                }
                PrimitiveBatch::SubpixelSprites { range, .. } => {
                    requirements.reserve::<SubpixelSprite>(range.len())
                }
                PrimitiveBatch::PolychromeSprites { range, .. } => {
                    requirements.reserve::<PolychromeSprite>(range.len())
                }
                PrimitiveBatch::Surfaces(_)
                | PrimitiveBatch::BackdropFilters(_)
                | PrimitiveBatch::FilterBoundary(_) => {}
            }
        }
        requirements
    }

    fn reserve<T: shader_interface::BufferData>(&mut self, count: usize) {
        if count == 0 {
            return;
        }
        self.bytes = self.bytes.next_multiple_of(self.alignment);
        self.bytes += (std::mem::size_of::<T>() as u64 * count as u64).max(16);
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
            targets: TargetStack::new(targets.active, targets.filter_groups),
            offscreen: targets.offscreen,
            presentation: targets.presentation,
            instances: targets.instances,
        }
    }

    fn encode(mut self) -> Result<wgpu::CommandBuffer, DrawError> {
        let result = self.encode_commands();
        if result.is_ok() {
            if let Some(offscreen) = &self.offscreen {
                self.renderer
                    .blit_to_frame(&mut self.encoder, offscreen, &self.presentation);
            }
        }
        self.instances.finish();
        self.renderer.resources().finish_frame_uploads();
        result?;
        Ok(self.encoder.finish())
    }

    fn encode_commands(&mut self) -> DrawResult {
        let mut pass = begin_color_render_pass(
            &mut self.encoder,
            "main_pass",
            self.targets.current(),
            wgpu::LoadOp::Clear(self.renderer.target.clear_color()),
        );

        for command in self.scene.render_commands() {
            match command {
                RenderCommand::Batch(PrimitiveBatch::Paths(range)) => {
                    let paths = &self.scene.paths[range];
                    if path_types::rasterization_vertex_count(paths) == 0 {
                        continue;
                    }
                    drop(pass);
                    let rasterized = self.renderer.draw_paths_to_intermediate(
                        &mut self.encoder,
                        paths,
                        &mut self.instances,
                    );
                    pass = begin_color_render_pass(
                        &mut self.encoder,
                        "after_paths",
                        self.targets.current(),
                        wgpu::LoadOp::Load,
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
                    for filter in &self.scene.backdrop_filters[range] {
                        self.renderer.draw_backdrop_filter(
                            &mut self.encoder,
                            filter,
                            self.targets.current(),
                        );
                    }
                    pass = begin_color_render_pass(
                        &mut self.encoder,
                        "after_backdrop_filter",
                        self.targets.current(),
                        wgpu::LoadOp::Load,
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
                    self.targets.enter(index.as_usize());
                    pass = begin_color_render_pass(
                        &mut self.encoder,
                        "filter_group",
                        self.targets.current(),
                        wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                    );
                }
                RenderCommand::EndFilter {
                    boundary,
                    target: FilterRenderTarget::Isolated(_),
                } => {
                    drop(pass);
                    let (filtered, parent) = self.targets.exit();
                    self.renderer.blur_and_composite(
                        &mut self.encoder,
                        &filtered,
                        parent,
                        FilterCompositeParameters {
                            bounds: boundary.bounds,
                            content_mask: boundary.content_mask.bounds,
                            corner_radii: boundary.corner_radii,
                            blur_radius: boundary.max_blur_radius(),
                            opacity: boundary.opacity,
                            clip: FilterCompositeClip::ContentShape,
                        },
                    );
                    pass = begin_color_render_pass(
                        &mut self.encoder,
                        "after_content_filter",
                        self.targets.current(),
                        wgpu::LoadOp::Load,
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

struct TargetStack {
    current: wgpu::TextureView,
    parents: Vec<wgpu::TextureView>,
    isolated: Vec<wgpu::TextureView>,
}

impl TargetStack {
    fn new(root: wgpu::TextureView, isolated: Vec<wgpu::TextureView>) -> Self {
        Self {
            current: root,
            parents: Vec::new(),
            isolated,
        }
    }

    fn current(&self) -> &wgpu::TextureView {
        &self.current
    }

    fn enter(&mut self, target_index: usize) {
        let next = self.isolated[target_index].clone();
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
    batch: PrimitiveBatch,
    instances: &mut InstanceUpload,
    pass: &mut wgpu::RenderPass<'_>,
) -> DrawResult {
    match batch {
        PrimitiveBatch::Quads(range) => renderer.draw_quads(&scene.quads[range], instances, pass),
        PrimitiveBatch::Shadows(range) => {
            renderer.draw_shadows(&scene.shadows[range], instances, pass)
        }
        PrimitiveBatch::Underlines(range) => {
            renderer.draw_underlines(&scene.underlines[range], instances, pass)
        }
        PrimitiveBatch::MonochromeSprites { texture_id, range } => renderer
            .draw_monochrome_sprites(
                &scene.monochrome_sprites[range],
                texture_id,
                instances,
                pass,
            ),
        PrimitiveBatch::SubpixelSprites { texture_id, range } => renderer.draw_subpixel_sprites(
            &scene.subpixel_sprites[range],
            texture_id,
            instances,
            pass,
        ),
        PrimitiveBatch::PolychromeSprites { texture_id, range } => renderer
            .draw_polychrome_sprites(
                &scene.polychrome_sprites[range],
                texture_id,
                instances,
                pass,
            ),
        PrimitiveBatch::Surfaces(range) => renderer.draw_surfaces(&scene.surfaces[range], pass),
        PrimitiveBatch::Paths(_)
        | PrimitiveBatch::BackdropFilters(_)
        | PrimitiveBatch::FilterBoundary(_) => {
            unreachable!("pass-interrupting batches are handled by FrameEncoder")
        }
    }
}
