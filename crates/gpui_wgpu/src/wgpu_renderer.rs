use crate::{
    CompositorGpuHint, WgpuAtlas, WgpuContext, WgpuDeviceRequirements,
    shaders::{
        blur::BlurUniforms,
        common::{
            FontRasterizationUniforms, GlobalUniforms, ShaderBool, SurfaceColorFormat,
        },
        interface as shader_interface,
        surface::SurfaceUniforms,
    },
};
use gpui::{
    AtlasTextureId, BackdropFilter, Background, Bounds, Corners, DevicePixels, FilterRenderTarget,
    GpuSpecs, MAX_FILTER_GROUP_DEPTH, MonochromeSprite, PaintSurface, Path, Point,
    PolychromeSprite, PrimitiveBatch, Quad, RenderCommand, ScaledPixels, Scene, Shadow, Size,
    SubpixelSprite, Underline, get_gamma_correction_ratios,
};
use log::warn;

#[cfg(not(target_family = "wasm"))]
use raw_window_handle::{HasDisplayHandle, HasWindowHandle};
use std::cell::RefCell;
use std::num::NonZeroU64;
use std::rc::Rc;
use std::sync::{Arc, Mutex};

mod filters;
mod frame;
mod buffers;
mod path_types;
mod pipelines;
mod settings;

use filters::*;
use buffers::*;
use path_types::*;
use pipelines::{
    WgpuBindGroupLayouts as ShaderBindGroupLayouts, WgpuPipelines as ShaderPipelines,
};
pub use settings::{FontRasterizationSettings, SubpixelOrder, WgpuSurfaceConfig};
use settings::RenderingParameters;

/// Shared GPU context reference, used to coordinate device recovery across multiple windows.
pub type GpuContext = Rc<RefCell<Option<WgpuContext>>>;

/// GPU resources that must be dropped together during device recovery.
struct WgpuResources {
    device: Arc<wgpu::Device>,
    queue: Arc<wgpu::Queue>,
    surface: Option<wgpu::Surface<'static>>,
    pipelines: ShaderPipelines,
    bind_group_layouts: ShaderBindGroupLayouts,
    atlas_sampler: wgpu::Sampler,
    surface_sampler: wgpu::Sampler,
    surface_uniforms: DynamicUniformBuffer<SurfaceUniforms>,
    #[cfg(target_os = "macos")]
    core_video_texture_cache: core_video::metal_texture_cache::CVMetalTextureCache,
    /// Reused, dynamically-sized uniform storage for every filter pass in a frame.
    filter_uniforms: DynamicUniformBuffer<BlurUniforms>,
    globals_buffer: wgpu::Buffer,
    globals_bind_group: wgpu::BindGroup,
    path_globals_bind_group: wgpu::BindGroup,
    instances: InstanceBufferArena,
    path_intermediate_texture: Option<wgpu::Texture>,
    path_intermediate_view: Option<wgpu::TextureView>,
    path_msaa_texture: Option<wgpu::Texture>,
    path_msaa_view: Option<wgpu::TextureView>,
    /// Blur offscreen targets. Allocated lazily (only when a frame actually uses a blur filter)
    /// so apps that never blur pay no extra VRAM. `None`/empty until first use.
    ///
    /// Full-resolution offscreen color target the scene is rendered into so that blur passes
    /// can sample already-painted content; blitted to the swapchain at the end of the frame.
    scene_color_texture: Option<wgpu::Texture>,
    scene_color_view: Option<wgpu::TextureView>,
    /// Half-resolution ping/pong targets for the downsample + separable gaussian passes.
    blur_ping_texture: Option<wgpu::Texture>,
    blur_ping_view: Option<wgpu::TextureView>,
    blur_pong_texture: Option<wgpu::Texture>,
    blur_pong_view: Option<wgpu::TextureView>,
    /// Full-resolution offscreen targets a content-filter (`filter`) group renders into before
    /// being blurred and composited back. One per nesting level (indexed by depth) so nested
    /// content blurs isolate consistently with [`MAX_FILTER_GROUP_DEPTH`]; deeper nests render inline.
    filter_group_textures: Vec<wgpu::Texture>,
    filter_group_views: Vec<wgpu::TextureView>,
}

impl WgpuResources {
    fn invalidate_intermediate_textures(&mut self) {
        self.path_intermediate_texture = None;
        self.path_intermediate_view = None;
        self.path_msaa_texture = None;
        self.path_msaa_view = None;
        self.scene_color_texture = None;
        self.scene_color_view = None;
        self.blur_ping_texture = None;
        self.blur_ping_view = None;
        self.blur_pong_texture = None;
        self.blur_pong_view = None;
        self.filter_group_textures.clear();
        self.filter_group_views.clear();
    }
}

/// Initial capacities avoid reallocating for ordinary frames. Both buffers grow before encoding
/// when a scene contains more filter passes or surfaces.
const INITIAL_FILTER_UNIFORM_CAPACITY: u64 = 256;
const INITIAL_SURFACE_UNIFORM_CAPACITY: u64 = 64;

pub struct WgpuRenderer {
    /// Shared GPU context for device recovery coordination (unused on WASM).
    #[allow(dead_code)]
    context: Option<GpuContext>,
    /// Compositor GPU hint for adapter selection (unused on WASM).
    #[allow(dead_code)]
    compositor_gpu: Option<CompositorGpuHint>,
    /// Application-requested extra wgpu features/limits, stored for device recovery.
    #[allow(dead_code)]
    extra_requirements: Option<WgpuDeviceRequirements>,
    resources: Option<WgpuResources>,
    surface_config: wgpu::SurfaceConfiguration,
    atlas: Arc<WgpuAtlas>,
    path_globals_offset: u64,
    gamma_offset: u64,
    maximum_uniform_buffer_size: u64,
    rendering_params: RenderingParameters,
    subpixel_order: SubpixelOrder,
    dual_source_blending: bool,
    adapter_info: wgpu::AdapterInfo,
    transparent_alpha_mode: wgpu::CompositeAlphaMode,
    opaque_alpha_mode: wgpu::CompositeAlphaMode,
    max_texture_size: u32,
    last_error: Arc<Mutex<Option<String>>>,
    failed_frame_count: u32,
    device_lost: std::sync::Arc<std::sync::atomic::AtomicBool>,
    surface_configured: bool,
    needs_redraw: bool,
    clear_color: wgpu::Color,
    #[cfg(not(target_family = "wasm"))]
    device_recovery_not_before: Option<std::time::Instant>,
}

impl WgpuRenderer {
    fn resources(&self) -> &WgpuResources {
        self.resources
            .as_ref()
            .expect("GPU resources not available")
    }

    fn resources_mut(&mut self) -> &mut WgpuResources {
        self.resources
            .as_mut()
            .expect("GPU resources not available")
    }

    /// Creates a new WgpuRenderer from raw window handles.
    ///
    /// The `gpu_context` is a shared reference that coordinates GPU context across
    /// multiple windows. The first window to create a renderer will initialize the
    /// context; subsequent windows will share it.
    ///
    /// # Safety
    /// The caller must ensure that the window handle remains valid for the lifetime
    /// of the returned renderer.
    #[cfg(not(target_family = "wasm"))]
    pub fn new<W>(
        gpu_context: GpuContext,
        window: &W,
        config: WgpuSurfaceConfig,
        compositor_gpu: Option<CompositorGpuHint>,
        extra_requirements: Option<WgpuDeviceRequirements>,
    ) -> anyhow::Result<Self>
    where
        W: HasWindowHandle + HasDisplayHandle + std::fmt::Debug + Send + Sync + Clone + 'static,
    {
        let window_handle = window
            .window_handle()
            .map_err(|e| anyhow::anyhow!("Failed to get window handle: {e}"))?;

        let target = wgpu::SurfaceTargetUnsafe::RawHandle {
            // Fall back to the display handle already provided via InstanceDescriptor::display.
            raw_display_handle: None,
            raw_window_handle: window_handle.as_raw(),
        };

        // Use the existing context's instance if available, otherwise create a new one.
        // The surface must be created with the same instance that will be used for
        // adapter selection, otherwise wgpu will panic.
        let instance = gpu_context
            .borrow()
            .as_ref()
            .map(|ctx| ctx.instance.clone())
            .unwrap_or_else(|| WgpuContext::instance(Box::new(window.clone())));

        // Safety: The caller guarantees that the window handle is valid for the
        // lifetime of this renderer. In practice, the RawWindow struct is created
        // from the native window handles and the surface is dropped before the window.
        let surface = unsafe {
            instance
                .create_surface_unsafe(target)
                .map_err(|e| anyhow::anyhow!("Failed to create surface: {e}"))?
        };

        let mut ctx_ref = gpu_context.borrow_mut();
        let context = match ctx_ref.as_mut() {
            Some(context) => {
                context.check_compatible_with_surface(&surface)?;
                context
            }
            None => ctx_ref.insert(WgpuContext::new(
                instance,
                &surface,
                compositor_gpu,
                extra_requirements.as_ref(),
            )?),
        };

        let atlas = Arc::new(WgpuAtlas::from_context(context));

        Self::new_internal(
            Some(Rc::clone(&gpu_context)),
            context,
            Some(surface),
            config,
            compositor_gpu,
            extra_requirements,
            atlas,
        )
    }

    #[cfg(target_family = "wasm")]
    pub fn new_from_canvas(
        context: &WgpuContext,
        canvas: &web_sys::HtmlCanvasElement,
        config: WgpuSurfaceConfig,
    ) -> anyhow::Result<Self> {
        let surface = context
            .instance
            .create_surface(wgpu::SurfaceTarget::Canvas(canvas.clone()))
            .map_err(|e| anyhow::anyhow!("Failed to create surface: {e}"))?;

        let atlas = Arc::new(WgpuAtlas::from_context(context));

        Self::new_internal(None, context, Some(surface), config, None, None, atlas)
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    fn new_headless(context: &WgpuContext, size: Size<DevicePixels>) -> anyhow::Result<Self> {
        Self::new_internal(
            None,
            context,
            None,
            WgpuSurfaceConfig {
                size,
                transparent: false,
                preferred_present_mode: None,
            },
            None,
            None,
            Arc::new(WgpuAtlas::from_context(context)),
        )
    }

    fn new_internal(
        gpu_context: Option<GpuContext>,
        context: &WgpuContext,
        surface: Option<wgpu::Surface<'static>>,
        config: WgpuSurfaceConfig,
        compositor_gpu: Option<CompositorGpuHint>,
        extra_requirements: Option<WgpuDeviceRequirements>,
        atlas: Arc<WgpuAtlas>,
    ) -> anyhow::Result<Self> {
        let (surface_format, transparent_alpha_mode, opaque_alpha_mode, present_mode) =
            if let Some(surface) = surface.as_ref() {
                let surface_caps = surface.get_capabilities(&context.adapter);
                let preferred_formats = [
                    wgpu::TextureFormat::Bgra8Unorm,
                    wgpu::TextureFormat::Rgba8Unorm,
                ];
                let surface_format = preferred_formats
                    .iter()
                    .find(|format| surface_caps.formats.contains(format))
                    .copied()
                    .or_else(|| {
                        surface_caps
                            .formats
                            .iter()
                            .find(|format| !format.is_srgb())
                            .copied()
                    })
                    .or_else(|| surface_caps.formats.first().copied())
                    .ok_or_else(|| {
                        anyhow::anyhow!(
                            "Surface reports no supported texture formats for adapter {:?}",
                            context.adapter.get_info().name
                        )
                    })?;

                let pick_alpha_mode = |preferences: &[wgpu::CompositeAlphaMode]| {
                    preferences
                        .iter()
                        .find(|preference| surface_caps.alpha_modes.contains(preference))
                        .copied()
                        .or_else(|| surface_caps.alpha_modes.first().copied())
                        .ok_or_else(|| {
                            anyhow::anyhow!(
                                "Surface reports no supported alpha modes for adapter {:?}",
                                context.adapter.get_info().name
                            )
                        })
                };
                let transparent_alpha_mode = pick_alpha_mode(&[
                    wgpu::CompositeAlphaMode::PreMultiplied,
                    wgpu::CompositeAlphaMode::Inherit,
                ])?;
                let opaque_alpha_mode = pick_alpha_mode(&[
                    wgpu::CompositeAlphaMode::Opaque,
                    wgpu::CompositeAlphaMode::Inherit,
                ])?;
                let present_mode = config
                    .preferred_present_mode
                    .filter(|mode| surface_caps.present_modes.contains(mode))
                    .unwrap_or(wgpu::PresentMode::Fifo);
                (
                    surface_format,
                    transparent_alpha_mode,
                    opaque_alpha_mode,
                    present_mode,
                )
            } else {
                // BGRA matches native desktop swapchains and keeps headless snapshots byte-for-byte
                // comparable to window rendering before the final RGBA readback swizzle.
                (
                    wgpu::TextureFormat::Bgra8Unorm,
                    wgpu::CompositeAlphaMode::PreMultiplied,
                    wgpu::CompositeAlphaMode::Opaque,
                    wgpu::PresentMode::Fifo,
                )
            };

        let alpha_mode = if config.transparent {
            transparent_alpha_mode
        } else {
            opaque_alpha_mode
        };

        let device = Arc::clone(&context.device);
        let max_texture_size = device.limits().max_texture_dimension_2d;

        let requested_width = config.size.width.0 as u32;
        let requested_height = config.size.height.0 as u32;
        let clamped_width = requested_width.min(max_texture_size);
        let clamped_height = requested_height.min(max_texture_size);

        if clamped_width != requested_width || clamped_height != requested_height {
            warn!(
                "Requested surface size ({}, {}) exceeds maximum texture dimension {}. \
                 Clamping to ({}, {}). Window content may not fill the entire window.",
                requested_width, requested_height, max_texture_size, clamped_width, clamped_height
            );
        }

        let surface_config = wgpu::SurfaceConfiguration {
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            format: surface_format,
            width: clamped_width.max(1),
            height: clamped_height.max(1),
            present_mode,
            desired_maximum_frame_latency: 2,
            alpha_mode,
            view_formats: vec![],
        };
        // Configure window surfaces immediately. Headless renderers use the same configuration
        // to describe their offscreen target but have no surface to configure.
        if let Some(surface) = surface.as_ref() {
            surface.configure(&context.device, &surface_config);
        }

        let queue = Arc::clone(&context.queue);
        let dual_source_blending = context.supports_dual_source_blending();

        let rendering_params = RenderingParameters::new(&context.adapter, surface_format);
        let bind_group_layouts = ShaderBindGroupLayouts::new(&device);
        let pipelines = ShaderPipelines::new(
            &device,
            &bind_group_layouts,
            surface_format,
            alpha_mode,
            rendering_params.path_sample_count,
            dual_source_blending,
        );

        let atlas_sampler = device.create_sampler(&wgpu::SamplerDescriptor {
            label: Some("atlas_sampler"),
            mag_filter: wgpu::FilterMode::Linear,
            min_filter: wgpu::FilterMode::Linear,
            ..Default::default()
        });

        let surface_sampler = device.create_sampler(&wgpu::SamplerDescriptor {
            label: Some("surface_sampler"),
            mag_filter: wgpu::FilterMode::Linear,
            min_filter: wgpu::FilterMode::Linear,
            ..Default::default()
        });

        let uniform_alignment = device.limits().min_uniform_buffer_offset_alignment as u64;
        let surface_uniforms = DynamicUniformBuffer::new(
            &device,
            "surface_uniforms",
            INITIAL_SURFACE_UNIFORM_CAPACITY,
            uniform_alignment,
        );
        let filter_uniforms = DynamicUniformBuffer::new(
            &device,
            "filter_uniforms",
            INITIAL_FILTER_UNIFORM_CAPACITY,
            uniform_alignment,
        );

        let globals_size = std::mem::size_of::<GlobalUniforms>() as u64;
        let gamma_size = std::mem::size_of::<FontRasterizationUniforms>() as u64;
        let path_globals_offset = globals_size.next_multiple_of(uniform_alignment);
        let gamma_offset = (path_globals_offset + globals_size).next_multiple_of(uniform_alignment);

        let globals_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("globals_buffer"),
            size: gamma_offset + gamma_size,
            usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
            mapped_at_creation: false,
        });

        let maximum_uniform_buffer_size = device.limits().max_buffer_size.min(u32::MAX as u64);
        let instances = InstanceBufferArena::new(&device);

        let create_globals = |label, offset| {
            bind_group_layouts.create_globals(
                &device,
                label,
                wgpu::BufferBinding {
                    buffer: &globals_buffer,
                    offset,
                    size: NonZeroU64::new(globals_size),
                },
                wgpu::BufferBinding {
                    buffer: &globals_buffer,
                    offset: gamma_offset,
                    size: NonZeroU64::new(gamma_size),
                },
            )
        };
        let globals_bind_group = create_globals("globals_bind_group", 0);
        let path_globals_bind_group =
            create_globals("path_globals_bind_group", path_globals_offset);

        let adapter_info = context.adapter.get_info();

        let last_error: Arc<Mutex<Option<String>>> = Arc::new(Mutex::new(None));
        let last_error_clone = Arc::clone(&last_error);
        device.on_uncaptured_error(Arc::new(move |error| {
            let mut guard = last_error_clone.lock().unwrap();
            *guard = Some(error.to_string());
        }));

        let surface_configured = surface.is_some();
        #[cfg(target_os = "macos")]
        let core_video_texture_cache = create_core_video_texture_cache(&device)?;

        let resources = WgpuResources {
            device,
            queue,
            surface,
            pipelines,
            bind_group_layouts,
            atlas_sampler,
            surface_sampler,
            surface_uniforms,
            #[cfg(target_os = "macos")]
            core_video_texture_cache,
            filter_uniforms,
            globals_buffer,
            globals_bind_group,
            path_globals_bind_group,
            instances,
            // Defer intermediate texture creation to first draw call via ensure_intermediate_textures().
            // This avoids panics when the device/surface is in an invalid state during initialization.
            path_intermediate_texture: None,
            path_intermediate_view: None,
            path_msaa_texture: None,
            path_msaa_view: None,
            scene_color_texture: None,
            scene_color_view: None,
            blur_ping_texture: None,
            blur_ping_view: None,
            blur_pong_texture: None,
            blur_pong_view: None,
            filter_group_textures: Vec::new(),
            filter_group_views: Vec::new(),
        };

        Ok(Self {
            context: gpu_context,
            compositor_gpu,
            extra_requirements,
            resources: Some(resources),
            surface_config,
            atlas,
            path_globals_offset,
            gamma_offset,
            maximum_uniform_buffer_size,
            rendering_params,
            subpixel_order: SubpixelOrder::RedGreenBlue,
            dual_source_blending,
            adapter_info,
            transparent_alpha_mode,
            opaque_alpha_mode,
            max_texture_size,
            last_error,
            failed_frame_count: 0,
            device_lost: context.device_lost_flag(),
            surface_configured,
            needs_redraw: false,
            clear_color: frame_clear_color(config.transparent),
            #[cfg(not(target_family = "wasm"))]
            device_recovery_not_before: None,
        })
    }

    fn create_sampled_render_texture(
        device: &wgpu::Device,
        format: wgpu::TextureFormat,
        width: u32,
        height: u32,
    ) -> (wgpu::Texture, wgpu::TextureView) {
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("sampled_render_texture"),
            size: wgpu::Extent3d {
                width: width.max(1),
                height: height.max(1),
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format,
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::TEXTURE_BINDING,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        (texture, view)
    }

    fn create_msaa_if_needed(
        device: &wgpu::Device,
        format: wgpu::TextureFormat,
        width: u32,
        height: u32,
        sample_count: u32,
    ) -> Option<(wgpu::Texture, wgpu::TextureView)> {
        if sample_count <= 1 {
            return None;
        }
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("path_msaa"),
            size: wgpu::Extent3d {
                width: width.max(1),
                height: height.max(1),
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count,
            dimension: wgpu::TextureDimension::D2,
            format,
            // wgpu-hal maps transient attachments to memoryless Metal textures on Apple GPUs.
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::TRANSIENT,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        Some((texture, view))
    }

    pub fn update_drawable_size(&mut self, size: Size<DevicePixels>) {
        let width = size.width.0 as u32;
        let height = size.height.0 as u32;

        if width != self.surface_config.width || height != self.surface_config.height {
            let clamped_width = width.min(self.max_texture_size);
            let clamped_height = height.min(self.max_texture_size);

            if clamped_width != width || clamped_height != height {
                warn!(
                    "Requested surface size ({}, {}) exceeds maximum texture dimension {}. \
                     Clamping to ({}, {}). Window content may not fill the entire window.",
                    width, height, self.max_texture_size, clamped_width, clamped_height
                );
            }

            self.surface_config.width = clamped_width.max(1);
            self.surface_config.height = clamped_height.max(1);
            let surface_config = self.surface_config.clone();

            // GPU resources may not exist yet, skip rather than panicking
            let Some(resources) = self.resources.as_mut() else {
                return;
            };

            // Dropping WGPU handles is non-blocking; the backend retains in-flight resources until
            // their submissions complete. Avoiding a full device wait keeps live resize fluid.
            resources.invalidate_intermediate_textures();

            if let Some(surface) = resources.surface.as_ref() {
                surface.configure(&resources.device, &surface_config);
            }
        }
    }

    fn ensure_intermediate_textures(&mut self) {
        if self.resources().path_intermediate_texture.is_some() {
            return;
        }

        let format = self.surface_config.format;
        let width = self.surface_config.width;
        let height = self.surface_config.height;
        let path_sample_count = self.rendering_params.path_sample_count;
        let resources = self.resources_mut();

        let (texture, view) =
            Self::create_sampled_render_texture(&resources.device, format, width, height);
        resources.path_intermediate_texture = Some(texture);
        resources.path_intermediate_view = Some(view);

        let (path_msaa_texture, path_msaa_view) = Self::create_msaa_if_needed(
            &resources.device,
            format,
            width,
            height,
            path_sample_count,
        )
        .map(|(t, v)| (Some(t), Some(v)))
        .unwrap_or((None, None));
        resources.path_msaa_texture = path_msaa_texture;
        resources.path_msaa_view = path_msaa_view;
    }

    /// Lazily allocate the blur offscreen targets — the full-res scene texture, half-res
    /// ping/pong, and one full-res group texture per nesting level. Called only on frames that
    /// actually use a blur filter, so non-blurring apps never pay this VRAM. A no-op once
    /// allocated (invalidated alongside the path intermediates on resize / device loss).
    fn ensure_blur_textures(&mut self) {
        if self.resources().scene_color_texture.is_some() {
            return;
        }
        let format = self.surface_config.format;
        let width = self.surface_config.width;
        let height = self.surface_config.height;
        let blur_width = (width / BLUR_DOWNSAMPLE_FACTOR).max(1);
        let blur_height = (height / BLUR_DOWNSAMPLE_FACTOR).max(1);
        let resources = self.resources_mut();

        let (scene_texture, scene_view) =
            Self::create_sampled_render_texture(&resources.device, format, width, height);
        resources.scene_color_texture = Some(scene_texture);
        resources.scene_color_view = Some(scene_view);
        let (horizontal_texture, horizontal_view) =
            Self::create_sampled_render_texture(&resources.device, format, blur_width, blur_height);
        resources.blur_ping_texture = Some(horizontal_texture);
        resources.blur_ping_view = Some(horizontal_view);
        let (vertical_texture, vertical_view) =
            Self::create_sampled_render_texture(&resources.device, format, blur_width, blur_height);
        resources.blur_pong_texture = Some(vertical_texture);
        resources.blur_pong_view = Some(vertical_view);

        for _ in 0..MAX_FILTER_GROUP_DEPTH {
            let (texture, view) =
                Self::create_sampled_render_texture(&resources.device, format, width, height);
            resources.filter_group_textures.push(texture);
            resources.filter_group_views.push(view);
        }
    }

    /// Selects the physical LCD component order used by subpixel glyph correction.
    pub fn set_subpixel_order(&mut self, order: SubpixelOrder) {
        self.subpixel_order = order;
    }

    /// Updates platform-specific text rasterization parameters.
    pub fn set_font_rasterization_settings(&mut self, settings: FontRasterizationSettings) {
        self.rendering_params.font_rasterization = settings;
        self.subpixel_order = settings.subpixel_order;
    }

    /// Compatibility wrapper for callers that still report the layout as a boolean.
    pub fn set_subpixel_layout(&mut self, is_bgr: bool) {
        self.set_subpixel_order(if is_bgr {
            SubpixelOrder::BlueGreenRed
        } else {
            SubpixelOrder::RedGreenBlue
        });
    }

    pub fn update_transparency(&mut self, transparent: bool) {
        self.clear_color = frame_clear_color(transparent);
        let new_alpha_mode = if transparent {
            self.transparent_alpha_mode
        } else {
            self.opaque_alpha_mode
        };

        if new_alpha_mode != self.surface_config.alpha_mode {
            self.surface_config.alpha_mode = new_alpha_mode;
            let surface_config = self.surface_config.clone();
            let path_sample_count = self.rendering_params.path_sample_count;
            let dual_source_blending = self.dual_source_blending;
            let Some(resources) = self.resources.as_mut() else {
                return;
            };
            if let Some(surface) = resources.surface.as_ref() {
                surface.configure(&resources.device, &surface_config);
            }
            resources.pipelines = ShaderPipelines::new(
                &resources.device,
                &resources.bind_group_layouts,
                surface_config.format,
                surface_config.alpha_mode,
                path_sample_count,
                dual_source_blending,
            );
        }
    }

    /// Controls whether Metal presents as part of the current Core Animation transaction.
    ///
    /// Native tab activation and live-resize callbacks need this synchronization point. The
    /// renderer remains backend-neutral; only the platform integration reaches through wgpu-hal.
    #[cfg(target_os = "macos")]
    pub fn set_presents_with_transaction(&self, enabled: bool) {
        let Some(resources) = self.resources.as_ref() else {
            return;
        };
        // SAFETY: The guard is borrowed only for this property update and no native resource is
        // destroyed or retained beyond it.
        let Some(surface) = resources.surface.as_ref() else {
            return;
        };
        if let Some(surface) = unsafe { surface.as_hal::<wgpu::hal::api::Metal>() } {
            surface
                .render_layer()
                .lock()
                .setPresentsWithTransaction(enabled);
        }
    }

    #[allow(dead_code)]
    pub fn viewport_size(&self) -> Size<DevicePixels> {
        Size {
            width: DevicePixels(self.surface_config.width as i32),
            height: DevicePixels(self.surface_config.height as i32),
        }
    }

    pub fn sprite_atlas(&self) -> &Arc<WgpuAtlas> {
        &self.atlas
    }

    pub fn supports_dual_source_blending(&self) -> bool {
        self.dual_source_blending
    }

    pub fn gpu_context(&self) -> (Arc<wgpu::Device>, Arc<wgpu::Queue>) {
        let resources = self.resources();
        (resources.device.clone(), resources.queue.clone())
    }

    pub fn gpu_specs(&self) -> GpuSpecs {
        GpuSpecs {
            is_software_emulated: self.adapter_info.device_type == wgpu::DeviceType::Cpu,
            device_name: self.adapter_info.name.clone(),
            driver_name: self.adapter_info.driver.clone(),
            driver_info: self.adapter_info.driver_info.clone(),
        }
    }

    pub fn max_texture_size(&self) -> u32 {
        self.max_texture_size
    }

    fn ensure_uniform_capacity(&mut self, scene: &Scene) -> bool {
        let requirements = FrameUniformRequirements::for_scene(scene);
        let maximum_buffer_size = self.maximum_uniform_buffer_size;
        let resources = self.resources_mut();

        let filter_capacity_available = resources.filter_uniforms.ensure_capacity(
            &resources.device,
            requirements.filter_count,
            maximum_buffer_size,
        );
        let surface_capacity_available = resources.surface_uniforms.ensure_capacity(
            &resources.device,
            requirements.surface_count,
            maximum_buffer_size,
        );
        if !filter_capacity_available || !surface_capacity_available {
            log::error!(
                "scene uniform data exceeds the GPU buffer limit: {} filter uniforms and {} \
                 surface uniforms",
                requirements.filter_count,
                requirements.surface_count,
            );
        }
        filter_capacity_available && surface_capacity_available
    }

    pub fn draw(&mut self, scene: &Scene) -> bool {
        // Bail out early if the surface has been unconfigured (e.g. during
        // Android background/rotation transitions).  Attempting to acquire
        // a texture from an unconfigured surface can block indefinitely on
        // some drivers (Adreno).
        if !self.surface_configured {
            return false;
        }

        let frame = match self
            .resources()
            .surface
            .as_ref()
            .expect("draw requires a configured surface")
            .get_current_texture()
        {
            wgpu::CurrentSurfaceTexture::Success(frame) => frame,
            wgpu::CurrentSurfaceTexture::Suboptimal(frame) => {
                // Textures must be destroyed before the surface can be reconfigured.
                drop(frame);
                self.needs_redraw = true;
                let surface_config = self.surface_config.clone();
                let resources = self.resources_mut();
                resources
                    .surface
                    .as_ref()
                    .expect("draw requires a configured surface")
                    .configure(&resources.device, &surface_config);
                return false;
            }
            wgpu::CurrentSurfaceTexture::Lost | wgpu::CurrentSurfaceTexture::Outdated => {
                self.needs_redraw = true;
                let surface_config = self.surface_config.clone();
                let resources = self.resources_mut();
                resources
                    .surface
                    .as_ref()
                    .expect("draw requires a configured surface")
                    .configure(&resources.device, &surface_config);
                return false;
            }
            wgpu::CurrentSurfaceTexture::Timeout | wgpu::CurrentSurfaceTexture::Occluded => {
                self.needs_redraw = true;
                return false;
            }
            wgpu::CurrentSurfaceTexture::Validation => {
                self.needs_redraw = true;
                *self.last_error.lock().unwrap() =
                    Some("Surface texture validation error".to_string());
                return false;
            }
        };

        let frame_view = frame
            .texture
            .create_view(&wgpu::TextureViewDescriptor::default());
        let rendered = self.render_to_view(scene, &frame_view);
        if rendered {
            frame.present();
        }
        rendered
    }

    /// Encodes and submits a complete scene into an arbitrary color target.
    ///
    /// Swapchain drawing, window capture, and headless rendering all use this path so platform
    /// integrations cannot silently diverge in batching, filters, or pipeline state.
    fn render_to_view(&mut self, scene: &Scene, frame_view: &wgpu::TextureView) -> bool {
        frame::render_to_view(self, scene, frame_view)
    }

    fn draw_quads(
        &self,
        quads: &[Quad],
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let data = Self::shader_instance_bytes(quads);
        self.draw_instances(
            data,
            quads.len() as u32,
            &self.resources().pipelines.quads,
            instance_offset,
            pass,
        )
    }

    fn draw_shadows(
        &self,
        shadows: &[Shadow],
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let data = Self::shader_instance_bytes(shadows);
        self.draw_instances(
            data,
            shadows.len() as u32,
            &self.resources().pipelines.shadows,
            instance_offset,
            pass,
        )
    }

    fn draw_underlines(
        &self,
        underlines: &[Underline],
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let data = Self::shader_instance_bytes(underlines);
        self.draw_instances(
            data,
            underlines.len() as u32,
            &self.resources().pipelines.underlines,
            instance_offset,
            pass,
        )
    }

    fn draw_monochrome_sprites(
        &self,
        sprites: &[MonochromeSprite],
        texture_id: AtlasTextureId,
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let texture = self.atlas.get_texture_info(texture_id);
        let data = Self::shader_instance_bytes(sprites);
        self.draw_instances_with_texture(
            data,
            sprites.len() as u32,
            &texture.view,
            &self.resources().pipelines.monochrome_sprites,
            instance_offset,
            pass,
        )
    }

    fn draw_subpixel_sprites(
        &self,
        sprites: &[SubpixelSprite],
        texture_id: AtlasTextureId,
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let texture = self.atlas.get_texture_info(texture_id);
        let data = Self::shader_instance_bytes(sprites);
        let resources = self.resources();
        let pipeline = resources
            .pipelines
            .subpixel_sprites
            .as_ref()
            .unwrap_or(&resources.pipelines.monochrome_sprites);
        self.draw_instances_with_texture(
            data,
            sprites.len() as u32,
            &texture.view,
            pipeline,
            instance_offset,
            pass,
        )
    }

    #[cfg(any(target_os = "macos", target_os = "linux", target_os = "freebsd"))]
    fn draw_surface_views(
        &self,
        surface: &PaintSurface,
        color_view: &wgpu::TextureView,
        chroma_view: &wgpu::TextureView,
        uses_yuv_color: bool,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let uniforms = SurfaceUniforms {
            bounds: surface.bounds.into(),
            content_mask: surface.content_mask.bounds.into(),
            color_format: if uses_yuv_color {
                SurfaceColorFormat::Yuv
            } else {
                SurfaceColorFormat::Rgba
            },
            padding0: 0,
            padding1: 0,
            padding2: 0,
        };
        let resources = self.resources();
        let uniform_slot = resources
            .surface_uniforms
            .write(&resources.queue, &uniforms);
        let bind_group = resources.bind_group_layouts.create_surface(
            &resources.device,
            wgpu::BufferBinding {
                buffer: &resources.surface_uniforms.buffer,
                offset: 0,
                size: Some(uniform_slot.size),
            },
            color_view,
            chroma_view,
            &resources.surface_sampler,
        );

        pass.set_pipeline(&resources.pipelines.surfaces);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(
            shader_interface::DATA_BIND_GROUP,
            &bind_group,
            &[uniform_slot.offset as u32],
        );
        pass.draw(0..resources.pipelines.surfaces.fixed_vertex_count(), 0..1);
        Ok(())
    }

    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    fn draw_surfaces(
        &self,
        surfaces: &[PaintSurface],
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        for surface in surfaces {
            let Some(wgpu_texture) = surface.texture.downcast_ref::<wgpu::Texture>() else {
                continue;
            };
            let texture_view = wgpu_texture.create_view(&wgpu::TextureViewDescriptor::default());
            self.draw_surface_views(surface, &texture_view, &texture_view, false, pass)?;
        }
        Ok(())
    }

    #[cfg(target_os = "macos")]
    fn draw_surfaces(
        &self,
        surfaces: &[PaintSurface],
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        use core_foundation::base::TCFType as _;
        use core_video::{
            metal_texture::CVMetalTextureGetTexture,
            pixel_buffer::kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
        };

        let resources = self.resources();
        for surface in surfaces {
            if surface.image_buffer.get_pixel_format()
                != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            {
                log::error!("unsupported CoreVideo surface pixel format");
                return Err(frame::DrawError::ExternalSurface);
            }
            let luma = match resources
                .core_video_texture_cache
                .create_texture_from_image(
                    surface.image_buffer.as_concrete_TypeRef(),
                    None,
                    metal::MTLPixelFormat::R8Unorm,
                    surface.image_buffer.get_width_of_plane(0),
                    surface.image_buffer.get_height_of_plane(0),
                    0,
                ) {
                Ok(texture) => texture,
                Err(error) => {
                    log::error!("failed to create CoreVideo luma texture: {error}");
                    return Err(frame::DrawError::ExternalSurface);
                }
            };
            let chroma = match resources
                .core_video_texture_cache
                .create_texture_from_image(
                    surface.image_buffer.as_concrete_TypeRef(),
                    None,
                    metal::MTLPixelFormat::RG8Unorm,
                    surface.image_buffer.get_width_of_plane(1),
                    surface.image_buffer.get_height_of_plane(1),
                    1,
                ) {
                Ok(texture) => texture,
                Err(error) => {
                    log::error!("failed to create CoreVideo chroma texture: {error}");
                    return Err(frame::DrawError::ExternalSurface);
                }
            };

            let luma_size = wgpu::Extent3d {
                width: surface.image_buffer.get_width_of_plane(0) as u32,
                height: surface.image_buffer.get_height_of_plane(0) as u32,
                depth_or_array_layers: 1,
            };
            let chroma_size = wgpu::Extent3d {
                width: surface.image_buffer.get_width_of_plane(1) as u32,
                height: surface.image_buffer.get_height_of_plane(1) as u32,
                depth_or_array_layers: 1,
            };
            // SAFETY: CoreVideo created both textures from the exact Metal device exposed by
            // this wgpu device, and each imported descriptor matches its plane.
            let Some(luma_texture) = (unsafe {
                import_core_video_texture(
                    &resources.device,
                    CVMetalTextureGetTexture(luma.as_concrete_TypeRef()).cast(),
                    wgpu::TextureFormat::R8Unorm,
                    luma_size,
                )
            }) else {
                return Err(frame::DrawError::ExternalSurface);
            };
            // SAFETY: Same invariants as the luma plane above.
            let Some(chroma_texture) = (unsafe {
                import_core_video_texture(
                    &resources.device,
                    CVMetalTextureGetTexture(chroma.as_concrete_TypeRef()).cast(),
                    wgpu::TextureFormat::Rg8Unorm,
                    chroma_size,
                )
            }) else {
                return Err(frame::DrawError::ExternalSurface);
            };
            let luma_view = luma_texture.create_view(&wgpu::TextureViewDescriptor::default());
            let chroma_view = chroma_texture.create_view(&wgpu::TextureViewDescriptor::default());
            self.draw_surface_views(surface, &luma_view, &chroma_view, true, pass)?;
        }
        Ok(())
    }

    #[cfg(not(any(target_os = "macos", target_os = "linux", target_os = "freebsd")))]
    fn draw_surfaces(
        &self,
        _surfaces: &[PaintSurface],
        _pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        Ok(())
    }

    /// Builds a filter bind group backed by a distinct frame-local uniform slot.
    fn make_blur_bind_group(
        &self,
        uniforms: BlurUniforms,
        source: &wgpu::TextureView,
    ) -> wgpu::BindGroup {
        let resources = self.resources();
        let uniform_slot = resources.filter_uniforms.write(&resources.queue, &uniforms);
        resources.bind_group_layouts.create_blur(
            &resources.device,
            wgpu::BufferBinding {
                buffer: &resources.filter_uniforms.buffer,
                offset: uniform_slot.offset,
                size: Some(uniform_slot.size),
            },
            source,
            &resources.surface_sampler,
        )
    }

    /// Run a full-screen (3-vertex) blur pass that overwrites `target` by sampling `source`.
    /// `scissor` limits fragment work to the region that
    /// actually feeds the composite — the element bounds dilated by the kernel radius.
    fn run_blur_pass(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        label: &str,
        pipeline: &pipelines::WgpuRenderPipeline,
        target: &wgpu::TextureView,
        source: &wgpu::TextureView,
        uniforms: BlurUniforms,
        scissor: ScissorRectangle,
    ) {
        let bind_group = self.make_blur_bind_group(uniforms, source);
        let resources = self.resources();
        let mut pass = begin_color_render_pass(
            encoder,
            label,
            target,
            wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
        );
        pass.set_pipeline(pipeline);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.set_scissor_rect(scissor.x, scissor.y, scissor.width, scissor.height);
        pass.draw(0..pipeline.fixed_vertex_count(), 0..1);
    }

    /// Blurs `source` and composites it into `target` using the shared filter pipeline.
    fn blur_and_composite(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        source: &wgpu::TextureView,
        target: &wgpu::TextureView,
        parameters: FilterCompositeParameters,
    ) {
        let Some(kernel) = BlurKernel::for_radius(parameters.blur_radius) else {
            return;
        };
        let full_width = self.surface_config.width;
        let full_height = self.surface_config.height;
        let blur_width = (full_width / BLUR_DOWNSAMPLE_FACTOR).max(1) as f32;
        let blur_height = (full_height / BLUR_DOWNSAMPLE_FACTOR).max(1) as f32;

        // Limit the half-res passes to the element bounds dilated by the kernel radius,
        // full-res) — outside that the composite never samples, so there's no reason to blur it.
        let dilation = GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * parameters.blur_radius;
        let scissor = ScissorRectangle::for_blurred_bounds(
            parameters.bounds,
            dilation,
            full_width,
            full_height,
        );
        if scissor.is_empty() {
            return;
        }

        // Owned handles so the passes below don't borrow `self`.
        let (horizontal_target, vertical_target) = {
            let resources = self.resources();
            match (
                resources.blur_ping_view.as_ref(),
                resources.blur_pong_view.as_ref(),
            ) {
                (Some(horizontal), Some(vertical)) => (horizontal.clone(), vertical.clone()),
                _ => return,
            }
        };

        // Downsample, then apply the horizontal and vertical gaussian passes.
        self.run_blur_pass(
            encoder,
            "blur_downsample",
            &self.resources().pipelines.blur_downsample,
            &horizontal_target,
            source,
            BlurUniforms::downsample(),
            scissor,
        );
        self.run_blur_pass(
            encoder,
            "blur_horizontal",
            &self.resources().pipelines.blur,
            &vertical_target,
            &horizontal_target,
            BlurUniforms::gaussian(
                BlurAxis::Horizontal,
                [blur_width, blur_height],
                kernel,
            ),
            scissor,
        );
        self.run_blur_pass(
            encoder,
            "blur_vertical",
            &self.resources().pipelines.blur,
            &horizontal_target,
            &vertical_target,
            BlurUniforms::gaussian(BlurAxis::Vertical, [blur_width, blur_height], kernel),
            scissor,
        );

        // Composite the blurred result into the target (loads existing content). For content blur
        // the quad covers the dilated region so the blur can fade out past the element box (no
        // sharp clip); for backdrop the quad is the element bounds and the shader clips to the
        // rounded rect.
        let clips_to_rounded_bounds = matches!(parameters.clip, FilterCompositeClip::RoundedBounds);
        let composite_bounds = if clips_to_rounded_bounds {
            parameters.bounds
        } else {
            parameters.bounds.dilate(ScaledPixels(dilation))
        };
        let uniforms = BlurUniforms::composite(
            composite_bounds,
            parameters.content_mask,
            parameters.corner_radii,
            parameters.opacity,
            parameters.clip,
        );
        let bind_group = self.make_blur_bind_group(uniforms, &horizontal_target);
        let resources = self.resources();
        let mut pass =
            begin_color_render_pass(encoder, "blur_composite", target, wgpu::LoadOp::Load);
        pass.set_pipeline(&resources.pipelines.blur_composite);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.draw(
            0..resources.pipelines.blur_composite.fixed_vertex_count(),
            0..1,
        );
    }

    /// Blur the scene painted so far behind `filter.bounds` and composite it back as frosted glass.
    fn draw_backdrop_filter(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        filter: &BackdropFilter,
        scene_color_view: &wgpu::TextureView,
    ) {
        self.blur_and_composite(
            encoder,
            scene_color_view,
            scene_color_view,
            FilterCompositeParameters {
                bounds: filter.bounds,
                content_mask: filter.content_mask.bounds,
                corner_radii: filter.corner_radii,
                blur_radius: filter.max_blur_radius(),
                opacity: filter.opacity,
                clip: FilterCompositeClip::RoundedBounds,
            },
        );
    }

    /// Copy the offscreen scene texture into the swapchain texture.
    fn blit_to_frame(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        source: &wgpu::TextureView,
        frame_view: &wgpu::TextureView,
    ) {
        let bind_group = self.make_blur_bind_group(BlurUniforms::copy(), source);
        let resources = self.resources();
        let mut pass = begin_color_render_pass(
            encoder,
            "scene_blit",
            frame_view,
            wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
        );
        pass.set_pipeline(&resources.pipelines.blur_downsample);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.draw(
            0..resources.pipelines.blur_downsample.fixed_vertex_count(),
            0..1,
        );
    }

    fn draw_polychrome_sprites(
        &self,
        sprites: &[PolychromeSprite],
        texture_id: AtlasTextureId,
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let texture = self.atlas.get_texture_info(texture_id);
        let data = Self::shader_instance_bytes(sprites);
        self.draw_instances_with_texture(
            data,
            sprites.len() as u32,
            &texture.view,
            &self.resources().pipelines.polychrome_sprites,
            instance_offset,
            pass,
        )
    }

    fn draw_instances(
        &self,
        data: &[u8],
        instance_count: u32,
        pipeline: &pipelines::WgpuRenderPipeline,
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        if instance_count == 0 {
            return Ok(());
        }
        let Some((offset, size)) = self.write_to_instance_buffer(instance_offset, data) else {
            return Err(frame::DrawError::CapacityPlanningInvariant);
        };
        let resources = self.resources();
        let bind_group = resources.bind_group_layouts.create_instances(
            &resources.device,
            self.instance_buffer_binding(offset, size),
        );
        pass.set_pipeline(pipeline);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.draw(0..pipeline.fixed_vertex_count(), 0..instance_count);
        Ok(())
    }

    fn draw_instances_with_texture(
        &self,
        data: &[u8],
        instance_count: u32,
        texture_view: &wgpu::TextureView,
        pipeline: &pipelines::WgpuRenderPipeline,
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        if instance_count == 0 {
            return Ok(());
        }
        let Some((offset, size)) = self.write_to_instance_buffer(instance_offset, data) else {
            return Err(frame::DrawError::CapacityPlanningInvariant);
        };
        let resources = self.resources();
        let bind_group = resources.bind_group_layouts.create_textured_instances(
            &resources.device,
            self.instance_buffer_binding(offset, size),
            texture_view,
            &resources.atlas_sampler,
        );
        pass.set_pipeline(pipeline);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.draw(0..pipeline.fixed_vertex_count(), 0..instance_count);
        Ok(())
    }

    fn shader_instance_bytes<T: shader_interface::BufferData>(instances: &[T]) -> &[u8] {
        shader_interface::slice_as_bytes(instances)
    }

    fn draw_paths_from_intermediate(
        &self,
        paths: &[Path<ScaledPixels>],
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let sprites = path_types::sprites(paths);

        let resources = self.resources();
        let Some(path_intermediate_view) = resources.path_intermediate_view.as_ref() else {
            return Err(frame::DrawError::MissingIntermediateTarget);
        };

        let sprite_data = Self::shader_instance_bytes(&sprites);
        self.draw_instances_with_texture(
            sprite_data,
            sprites.len() as u32,
            path_intermediate_view,
            &resources.pipelines.paths,
            instance_offset,
            pass,
        )
    }

    fn draw_paths_to_intermediate(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        paths: &[Path<ScaledPixels>],
        instance_offset: &mut u64,
    ) -> frame::DrawResult {
        let vertices = path_types::rasterization_vertices(paths);

        if vertices.is_empty() {
            return Ok(());
        }

        let vertex_data = Self::shader_instance_bytes(&vertices);
        let Some((vertex_offset, vertex_size)) =
            self.write_to_instance_buffer(instance_offset, vertex_data)
        else {
            return Err(frame::DrawError::CapacityPlanningInvariant);
        };

        let resources = self.resources();
        let data_bind_group = resources.bind_group_layouts.create_instances(
            &resources.device,
            self.instance_buffer_binding(vertex_offset, vertex_size),
        );

        let Some(path_intermediate_view) = resources.path_intermediate_view.as_ref() else {
            return Err(frame::DrawError::MissingIntermediateTarget);
        };

        let (target_view, resolve_target) = if let Some(ref msaa_view) = resources.path_msaa_view {
            (msaa_view, Some(path_intermediate_view))
        } else {
            (path_intermediate_view, None)
        };

        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("path_rasterization_pass"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: target_view,
                    resolve_target,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                        store: wgpu::StoreOp::Store,
                    },
                    depth_slice: None,
                })],
                depth_stencil_attachment: None,
                ..Default::default()
            });

            pass.set_pipeline(&resources.pipelines.path_rasterization);
            pass.set_bind_group(
                shader_interface::GLOBAL_BIND_GROUP,
                &resources.path_globals_bind_group,
                &[],
            );
            pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &data_bind_group, &[]);
            pass.draw(0..vertices.len() as u32, 0..1);
        }

        Ok(())
    }

    fn write_to_instance_buffer(
        &self,
        instance_offset: &mut u64,
        data: &[u8],
    ) -> Option<(u64, NonZeroU64)> {
        let resources = self.resources();
        let slice = resources
            .instances
            .write(&resources.queue, instance_offset, data)?;
        Some((slice.offset, slice.size))
    }

    fn instance_buffer_binding(&self, offset: u64, size: NonZeroU64) -> wgpu::BufferBinding<'_> {
        self.resources()
            .instances
            .binding(BufferSlice { offset, size })
    }

    /// Mark the surface as unconfigured so rendering is skipped until a new
    /// surface is provided via [`replace_surface`](Self::replace_surface).
    ///
    /// This does **not** drop the renderer — the device, queue, atlas, and
    /// pipelines stay alive.  Use this when the native window is destroyed
    /// (e.g. Android `TerminateWindow`) but you intend to re-create the
    /// surface later without losing cached atlas textures.
    pub fn unconfigure_surface(&mut self) {
        self.surface_configured = false;
        // Drop intermediate textures since they reference the old surface size.
        if let Some(res) = self.resources.as_mut() {
            res.invalidate_intermediate_textures();
        }
    }

    /// Replace the wgpu surface with a new one (e.g. after Android destroys
    /// and recreates the native window).  Keeps the device, queue, atlas, and
    /// all pipelines intact so cached `AtlasTextureId`s remain valid.
    ///
    /// The `instance` **must** be the same [`wgpu::Instance`] that was used to
    /// create the adapter and device (i.e. from the [`WgpuContext`]).  Using a
    /// different instance will cause a "Device does not exist" panic because
    /// the wgpu device is bound to its originating instance.
    #[cfg(not(target_family = "wasm"))]
    pub fn replace_surface<W: HasWindowHandle>(
        &mut self,
        window: &W,
        config: WgpuSurfaceConfig,
        instance: &wgpu::Instance,
    ) -> anyhow::Result<()> {
        let window_handle = window
            .window_handle()
            .map_err(|e| anyhow::anyhow!("Failed to get window handle: {e}"))?;

        let surface = create_surface(instance, window_handle.as_raw())?;

        let width = (config.size.width.0 as u32).max(1);
        let height = (config.size.height.0 as u32).max(1);

        let alpha_mode = if config.transparent {
            self.transparent_alpha_mode
        } else {
            self.opaque_alpha_mode
        };

        self.surface_config.width = width;
        self.surface_config.height = height;
        self.surface_config.alpha_mode = alpha_mode;
        if let Some(mode) = config.preferred_present_mode {
            self.surface_config.present_mode = mode;
        }

        {
            let res = self
                .resources
                .as_mut()
                .expect("GPU resources not available");
            surface.configure(&res.device, &self.surface_config);
            res.surface = Some(surface);

            // Invalidate intermediate textures — they'll be recreated lazily.
            res.invalidate_intermediate_textures();
        }

        self.surface_configured = true;

        Ok(())
    }

    pub fn destroy(&mut self) {
        // Release surface-bound GPU resources eagerly so the underlying native
        // window can be destroyed before the renderer itself is dropped.
        self.resources.take();
    }

    /// Returns true if the GPU device was lost and recovery is needed.
    pub fn device_lost(&self) -> bool {
        self.device_lost.load(std::sync::atomic::Ordering::SeqCst)
    }

    /// Returns true if a redraw is needed because presentation failed or GPU state was cleared.
    /// Calling this method clears the flag.
    pub fn needs_redraw(&mut self) -> bool {
        std::mem::take(&mut self.needs_redraw)
    }

    /// Recovers from a lost GPU device by recreating the renderer with a new context.
    ///
    /// Call this after detecting `device_lost()` returns true.
    ///
    /// This method coordinates recovery across multiple windows:
    /// - The first window to call this will recreate the shared context
    /// - Subsequent windows will adopt the already-recovered context
    #[cfg(not(target_family = "wasm"))]
    pub fn recover<W>(&mut self, window: &W) -> anyhow::Result<()>
    where
        W: HasWindowHandle + HasDisplayHandle + std::fmt::Debug + Send + Sync + Clone + 'static,
    {
        let gpu_context = self.context.as_ref().expect("recover requires gpu_context");

        // Check whether another window already recovered the shared context.
        let needs_new_context = gpu_context
            .borrow()
            .as_ref()
            .is_none_or(WgpuContext::device_lost);

        if needs_new_context {
            let now = std::time::Instant::now();
            match self.device_recovery_not_before {
                None => {
                    self.device_recovery_not_before =
                        Some(now + std::time::Duration::from_millis(350));
                    anyhow::bail!("waiting for the GPU driver to stabilize before recovery");
                }
                Some(not_before) if now < not_before => {
                    anyhow::bail!("waiting for the GPU driver to stabilize before recovery");
                }
                Some(_) => self.device_recovery_not_before = None,
            }
        } else {
            self.device_recovery_not_before = None;
        }

        let window_handle = window
            .window_handle()
            .map_err(|e| anyhow::anyhow!("Failed to get window handle: {e}"))?;

        let surface = if needs_new_context {
            log::warn!("GPU device lost, recreating context...");

            // Drop old resources to release Arc<Device>/Arc<Queue> and GPU resources
            self.resources = None;
            *gpu_context.borrow_mut() = None;

            let instance = WgpuContext::instance(Box::new(window.clone()));
            let surface = create_surface(&instance, window_handle.as_raw())?;
            let new_context = match WgpuContext::new_rejecting_software(
                instance,
                &surface,
                self.compositor_gpu,
                self.extra_requirements.as_ref(),
            ) {
                Ok(context) => context,
                Err(error) => {
                    self.device_recovery_not_before =
                        Some(std::time::Instant::now() + std::time::Duration::from_millis(350));
                    return Err(error);
                }
            };
            *gpu_context.borrow_mut() = Some(new_context);
            surface
        } else {
            let context_reference = gpu_context.borrow();
            let instance = &context_reference
                .as_ref()
                .expect("a recovered context must exist")
                .instance;
            create_surface(instance, window_handle.as_raw())?
        };

        let config = WgpuSurfaceConfig {
            size: gpui::Size {
                width: gpui::DevicePixels(self.surface_config.width as i32),
                height: gpui::DevicePixels(self.surface_config.height as i32),
            },
            transparent: self.surface_config.alpha_mode != wgpu::CompositeAlphaMode::Opaque,
            preferred_present_mode: Some(self.surface_config.present_mode),
        };
        let gpu_context = Rc::clone(gpu_context);
        let context_reference = gpu_context.borrow();
        let context = context_reference.as_ref().expect("context should exist");

        self.resources = None;
        self.atlas.handle_device_lost(context);

        let extra_requirements = self.extra_requirements.clone();
        let font_rasterization = self.rendering_params.font_rasterization;
        let subpixel_order = self.subpixel_order;
        let mut recovered_renderer = Self::new_internal(
            Some(gpu_context.clone()),
            context,
            Some(surface),
            config,
            self.compositor_gpu,
            extra_requirements,
            self.atlas.clone(),
        )?;
        recovered_renderer.set_font_rasterization_settings(font_rasterization);
        recovered_renderer.set_subpixel_order(subpixel_order);
        *self = recovered_renderer;

        log::info!("GPU recovery complete");
        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    fn create_offscreen_target(&self) -> OffscreenTarget {
        let texture = self
            .resources()
            .device
            .create_texture(&wgpu::TextureDescriptor {
                label: Some("gpui_offscreen_target"),
                size: wgpu::Extent3d {
                    width: self.surface_config.width,
                    height: self.surface_config.height,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format: self.surface_config.format,
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
                view_formats: &[],
            });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        OffscreenTarget {
            texture,
            view,
            size: self.viewport_size(),
        }
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    fn read_offscreen_target(&self, target: &OffscreenTarget) -> anyhow::Result<image::RgbaImage> {
        let width = target.size.width.0 as u32;
        let height = target.size.height.0 as u32;
        let bytes_per_row = width * 4;
        let padded_bytes_per_row =
            bytes_per_row.next_multiple_of(wgpu::COPY_BYTES_PER_ROW_ALIGNMENT);
        let output = self
            .resources()
            .device
            .create_buffer(&wgpu::BufferDescriptor {
                label: Some("gpui_offscreen_readback"),
                size: u64::from(padded_bytes_per_row) * u64::from(height),
                usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
                mapped_at_creation: false,
            });
        let mut encoder =
            self.resources()
                .device
                .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                    label: Some("gpui_offscreen_readback_encoder"),
                });
        encoder.copy_texture_to_buffer(
            target.texture.as_image_copy(),
            wgpu::TexelCopyBufferInfo {
                buffer: &output,
                layout: wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(padded_bytes_per_row),
                    rows_per_image: Some(height),
                },
            },
            wgpu::Extent3d {
                width,
                height,
                depth_or_array_layers: 1,
            },
        );
        let submission = self.resources().queue.submit([encoder.finish()]);

        let (sender, receiver) = std::sync::mpsc::sync_channel(1);
        output
            .slice(..)
            .map_async(wgpu::MapMode::Read, move |result| {
                let _ = sender.send(result);
            });
        self.resources()
            .device
            .poll(wgpu::PollType::Wait {
                submission_index: Some(submission),
                timeout: None,
            })
            .map_err(|error| anyhow::anyhow!("failed to poll offscreen readback: {error}"))?;
        receiver
            .recv()
            .map_err(|error| anyhow::anyhow!("offscreen readback callback dropped: {error}"))?
            .map_err(|error| anyhow::anyhow!("failed to map offscreen readback: {error}"))?;

        let mapped = output.slice(..).get_mapped_range();
        let mut pixels = Vec::with_capacity(bytes_per_row as usize * height as usize);
        for row in mapped.chunks_exact(padded_bytes_per_row as usize) {
            pixels.extend_from_slice(&row[..bytes_per_row as usize]);
        }
        drop(mapped);
        output.unmap();

        if self.surface_config.format == wgpu::TextureFormat::Bgra8Unorm {
            for pixel in pixels.chunks_exact_mut(4) {
                pixel.swap(0, 2);
            }
        }
        image::RgbaImage::from_raw(width, height, pixels)
            .ok_or_else(|| anyhow::anyhow!("offscreen readback dimensions did not match its data"))
    }

    /// Renders through the normal scene path and reads the result without presenting it.
    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    pub fn render_to_image(&mut self, scene: &Scene) -> anyhow::Result<image::RgbaImage> {
        let target = self.create_offscreen_target();
        anyhow::ensure!(
            self.render_to_view(scene, &target.view),
            "failed to render scene into the offscreen target"
        );
        self.read_offscreen_target(&target)
    }
}

#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
struct OffscreenTarget {
    texture: wgpu::Texture,
    view: wgpu::TextureView,
    size: Size<DevicePixels>,
}

/// Surface-free renderer used by GPUI visual tests and benchmarks.
#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
pub struct WgpuHeadlessRenderer {
    renderer: WgpuRenderer,
    target: Option<OffscreenTarget>,
}

#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
impl WgpuHeadlessRenderer {
    pub fn new() -> anyhow::Result<Self> {
        let context = WgpuContext::new_headless(None)?;
        let renderer = WgpuRenderer::new_headless(
            &context,
            Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        )?;
        Ok(Self {
            renderer,
            target: None,
        })
    }

    fn ensure_target(&mut self, size: Size<DevicePixels>) -> anyhow::Result<()> {
        anyhow::ensure!(
            size.width.0 > 0 && size.height.0 > 0,
            "headless render target must have positive dimensions"
        );
        if self
            .target
            .as_ref()
            .is_some_and(|target| target.size == size)
        {
            return Ok(());
        }

        self.renderer.update_drawable_size(size);
        self.target = Some(self.renderer.create_offscreen_target());
        Ok(())
    }
}

#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
impl gpui::PlatformHeadlessRenderer for WgpuHeadlessRenderer {
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<image::RgbaImage> {
        self.ensure_target(size)?;
        let target = self.target.as_ref().expect("target was just ensured");
        anyhow::ensure!(
            self.renderer.render_to_view(scene, &target.view),
            "failed to render headless scene"
        );
        self.renderer.read_offscreen_target(target)
    }

    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> anyhow::Result<()> {
        self.ensure_target(size)?;
        let target = self.target.as_ref().expect("target was just ensured");
        anyhow::ensure!(
            self.renderer.render_to_view(scene, &target.view),
            "failed to render headless scene"
        );
        Ok(())
    }

    fn sprite_atlas(&self) -> Arc<dyn gpui::PlatformAtlas> {
        self.renderer.sprite_atlas().clone()
    }
}

#[cfg(target_os = "macos")]
fn create_core_video_texture_cache(
    device: &wgpu::Device,
) -> anyhow::Result<core_video::metal_texture_cache::CVMetalTextureCache> {
    use metal::foreign_types::ForeignTypeRef as _;

    // SAFETY: The HAL guard stays alive while cloning the Objective-C device, and the clone owns
    // its retain count independently of the guard.
    let hal_device = unsafe { device.as_hal::<wgpu::hal::api::Metal>() }
        .ok_or_else(|| anyhow::anyhow!("macOS WGPU device did not expose the Metal HAL"))?;
    let raw_device = objc2::rc::Retained::as_ptr(hal_device.raw_device())
        .cast_mut()
        .cast();
    // SAFETY: `raw_device` came directly from wgpu-hal and is a valid MTLDevice.
    let metal_device = unsafe { metal::DeviceRef::from_ptr(raw_device) }.to_owned();
    core_video::metal_texture_cache::CVMetalTextureCache::new(None, metal_device, None)
        .map_err(|error| anyhow::anyhow!("failed to create CoreVideo Metal texture cache: {error}"))
}

#[cfg(target_os = "macos")]
unsafe fn import_core_video_texture(
    device: &wgpu::Device,
    raw_texture: *mut objc2::runtime::AnyObject,
    format: wgpu::TextureFormat,
    size: wgpu::Extent3d,
) -> Option<wgpu::Texture> {
    use objc2::{rc::Retained, runtime::ProtocolObject};

    // SAFETY: CoreVideo returned a live Objective-C MTLTexture. Retaining it transfers one owned
    // reference into the HAL texture so it outlives the CVMetalTexture wrapper.
    let object = unsafe { Retained::retain(raw_texture) }?;
    // SAFETY: CVMetalTextureGetTexture guarantees that the object implements MTLTexture.
    let raw =
        unsafe { Retained::cast_unchecked::<ProtocolObject<dyn objc2_metal::MTLTexture>>(object) };
    // SAFETY: The texture belongs to this device and the supplied metadata exactly describes its
    // CoreVideo plane.
    let hal_texture = unsafe {
        wgpu::hal::metal::Device::texture_from_raw(
            raw,
            format,
            objc2_metal::MTLTextureType::Type2D,
            1,
            1,
            size.into(),
        )
    };
    Some(unsafe {
        device.create_texture_from_hal::<wgpu::hal::api::Metal>(
            hal_texture,
            &wgpu::TextureDescriptor {
                label: Some("core_video_surface_plane"),
                size,
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format,
                usage: wgpu::TextureUsages::TEXTURE_BINDING,
                view_formats: &[],
            },
        )
    })
}

#[cfg(not(target_family = "wasm"))]
fn create_surface(
    instance: &wgpu::Instance,
    raw_window_handle: raw_window_handle::RawWindowHandle,
) -> anyhow::Result<wgpu::Surface<'static>> {
    unsafe {
        instance
            .create_surface_unsafe(wgpu::SurfaceTargetUnsafe::RawHandle {
                // Fall back to the display handle already provided via InstanceDescriptor::display.
                raw_display_handle: None,
                raw_window_handle,
            })
            .map_err(|e| anyhow::anyhow!("{e}"))
    }
}

fn begin_color_render_pass<'encoder>(
    encoder: &'encoder mut wgpu::CommandEncoder,
    label: &'encoder str,
    target: &'encoder wgpu::TextureView,
    load: wgpu::LoadOp<wgpu::Color>,
) -> wgpu::RenderPass<'encoder> {
    encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
        label: Some(label),
        color_attachments: &[Some(wgpu::RenderPassColorAttachment {
            view: target,
            resolve_target: None,
            ops: wgpu::Operations {
                load,
                store: wgpu::StoreOp::Store,
            },
            depth_slice: None,
        })],
        depth_stencil_attachment: None,
        ..Default::default()
    })
}

fn frame_clear_color(transparent: bool) -> wgpu::Color {
    if transparent {
        return wgpu::Color::TRANSPARENT;
    }
    #[cfg(target_os = "windows")]
    {
        // Preserve the former DirectComposition renderer's opaque white backing.
        return wgpu::Color::WHITE;
    }
    #[cfg(target_os = "macos")]
    {
        // Preserve CAMetalLayer's opaque black backing without affecting transparent windows.
        return wgpu::Color {
            r: 0.0,
            g: 0.0,
            b: 0.0,
            a: 1.0,
        };
    }
    #[cfg(not(any(target_os = "windows", target_os = "macos")))]
    {
        // Existing WGPU platforms have historically cleared opaque surfaces transparently.
        wgpu::Color::TRANSPARENT
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rust_storage_types_match_shader_strides() {
        fn module_layout(source: &wgsl_rs::Source) -> (naga::Module, naga::proc::Layouter) {
            let source = source.wgsl_source().expect("shader must generate WGSL");
            let module = naga::front::wgsl::parse_str(&format!(
                "enable dual_source_blending;\n{source}"
            ))
            .expect("generated shader must parse as WGSL");
            let mut layouter = naga::proc::Layouter::default();
            layouter
                .update(module.to_ctx())
                .expect("generated shader types must have valid layouts");
            (module, layouter)
        }

        let (base, base_layout) = module_layout(&crate::shaders::base::WGSL_SOURCE);
        let (subpixel, subpixel_layout) =
            module_layout(&crate::shaders::subpixel_sprite::WGSL_SOURCE);

        for abi in shader_interface::SCENE_STORAGE_ABI
            .iter()
            .chain(path_types::STORAGE_ABI)
        {
            let base_handle = base
                .types
                .iter()
                .find(|(_, ty)| ty.name.as_deref() == Some(abi.wgsl_type))
                .map(|(handle, _)| handle);
            let shader_stride = if let Some(handle) = base_handle {
                base_layout[handle].to_stride()
            } else {
                let (handle, _) = subpixel
                    .types
                    .iter()
                    .find(|(_, ty)| ty.name.as_deref() == Some(abi.wgsl_type))
                    .unwrap_or_else(|| panic!("missing WGSL type {}", abi.wgsl_type));
                subpixel_layout[handle].to_stride()
            };
            assert_eq!(
                shader_stride as usize,
                abi.rust_stride,
                "Rust and WGSL layouts differ for {}",
                abi.wgsl_type,
            );
        }
    }

    #[test]
    fn large_filter_scenes_reserve_unique_uniform_slots() {
        let mut scene = Scene::default();
        scene
            .backdrop_filters
            .resize_with(100, BackdropFilter::default);

        assert_eq!(
            FrameUniformRequirements::for_scene(&scene),
            FrameUniformRequirements {
                filter_count: 401,
                surface_count: 0,
            }
        );
    }

    #[test]
    fn large_blur_radii_expand_tap_spacing_instead_of_truncating_the_kernel() {
        let kernel = BlurKernel::for_radius(100.0).expect("positive radii have a blur kernel");
        assert_eq!(kernel.standard_deviation, 50.0);
        assert_eq!(kernel.sample_count, MAX_GAUSSIAN_SAMPLES_PER_SIDE);
        assert!(kernel.sample_step > 4.0);
    }

    #[cfg(any(target_os = "macos", target_os = "windows"))]
    #[test]
    fn desktop_blending_preserves_native_alpha_accumulation() {
        let straight =
            pipelines::desktop_scene_blend_state(wgpu::CompositeAlphaMode::Opaque);
        assert_eq!(straight.color.src_factor, wgpu::BlendFactor::SrcAlpha);
        assert_eq!(straight.alpha.dst_factor, wgpu::BlendFactor::One);

        let premultiplied =
            pipelines::desktop_scene_blend_state(wgpu::CompositeAlphaMode::PreMultiplied);
        assert_eq!(premultiplied.color.src_factor, wgpu::BlendFactor::One);
        assert_eq!(premultiplied.alpha.dst_factor, wgpu::BlendFactor::One);
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn underline_opacity_is_applied_once() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let size = Size {
            width: DevicePixels(3),
            height: DevicePixels(3),
        };
        let mut renderer = WgpuRenderer::new_headless(&context, size)?;
        let bounds = Bounds {
            origin: Point {
                x: ScaledPixels(0.0),
                y: ScaledPixels(0.0),
            },
            size: Size {
                width: ScaledPixels(3.0),
                height: ScaledPixels(3.0),
            },
        };
        let mut scene = Scene::default();
        scene.insert_primitive(Underline {
            order: 0,
            padding: 0,
            bounds,
            content_mask: gpui::ContentMask { bounds },
            color: gpui::hsla(0.0, 1.0, 0.5, 0.5).into(),
            thickness: ScaledPixels(1.0),
            wavy: false.into(),
        });
        scene.finish();

        let image = renderer.render_to_image(&scene)?;
        let center = image.get_pixel(1, 1).0;
        assert!(
            (120..=136).contains(&center[0]),
            "half-opacity red should contribute about 128, got {center:?}"
        );
        assert!(center[1] <= 2 && center[2] <= 2);
        assert_eq!(center[3], 255);
        Ok(())
    }
}
