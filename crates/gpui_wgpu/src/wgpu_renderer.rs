<<<<<<< HEAD
use crate::{CompositorGpuHint, WgpuAtlas, WgpuContext, WgpuContextHandle, WgpuDeviceRequirements};
use gpui::{DevicePixels, GpuSpecs, Scene, Size};

#[cfg(test)]
use gpui::BackdropFilter;
#[cfg(all(test, feature = "test-support", not(target_family = "wasm")))]
use gpui::{Bounds, Point, Quad, ScaledPixels, Underline};
#[cfg(test)]
use gpui_render::blur::{BlurKernel, MAX_GAUSSIAN_SAMPLES_PER_SIDE};
#[cfg(test)]
use gpui_render::shaders::interface as shader_interface;

=======
use crate::{CompositorGpuHint, DeviceErrorState, WgpuAtlas, WgpuContext};
use anyhow::{Context as _, Result};
use bytemuck::{Pod, Zeroable};
use collections::FxHashMap;
use gpui::{
    AtlasTextureId, Background, Bounds, DevicePixels, GpuSpecs, Path, Point, PrimitiveBatch,
    ScaledPixels, Scene, Size, get_gamma_correction_ratios,
};
use log::warn;
#[cfg(not(target_family = "wasm"))]
use raw_window_handle::{HasDisplayHandle, HasWindowHandle};
use smallvec::SmallVec;
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
use std::cell::RefCell;
use std::rc::Rc;
use std::sync::Arc;

mod buffers;
mod drawing;
mod filters;
mod frame;
#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
mod headless;
mod path_types;
mod pipelines;
mod platform;
mod resources;
mod settings;
mod surfaces;
mod target;

#[cfg(all(feature = "test-support", not(target_family = "wasm")))]
pub use headless::WgpuHeadlessRenderer;
use pipelines::WgpuPipelines as ShaderPipelines;
use resources::{GlobalBufferLayout, ResourceMetadata, WgpuResources};
use settings::RenderingParameters;
pub use settings::{FontRasterizationSettings, SubpixelOrder, WgpuSurfaceConfig};
use target::RenderTarget;

/// Shared GPU context reference, used to coordinate device recovery across multiple windows.
pub type GpuContext = Rc<RefCell<Option<WgpuContext>>>;

<<<<<<< HEAD
struct GpuFaultState {
    pending_error: Arc<Mutex<Option<String>>>,
    consecutive_failed_frames: u32,
    device_lost: Arc<std::sync::atomic::AtomicBool>,
    #[cfg(not(target_family = "wasm"))]
    recovery_not_before: Option<std::time::Instant>,
}

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
    target: RenderTarget,
=======
enum InstanceData {
    Storage(wgpu::Buffer),
    // WebGL2 has no storage buffers. A uint texture keeps the records available to both shader
    // stages while preserving integer and floating-point bit patterns exactly.
    Texture {
        texture: wgpu::Texture,
        view: wgpu::TextureView,
        width: u32,
        height: u32,
    },
}

/// GPU resources that must be dropped together during device recovery.
struct WgpuResources {
    device: Arc<wgpu::Device>,
    queue: Arc<wgpu::Queue>,
    pipelines: WgpuPipelines,
    bind_group_layouts: WgpuBindGroupLayouts,
    atlas_sampler: wgpu::Sampler,
    atlas_texture_bind_groups: FxHashMap<AtlasTextureId, CachedTextureBindGroup>,
    globals_buffer: wgpu::Buffer,
    globals_bind_group: wgpu::BindGroup,
    path_globals_bind_group: wgpu::BindGroup,
    instance_data: InstanceData,
    path_intermediate_texture: Option<wgpu::Texture>,
    path_intermediate_view: Option<wgpu::TextureView>,
    path_msaa_texture: Option<wgpu::Texture>,
    path_msaa_view: Option<wgpu::TextureView>,
}

struct CachedTextureBindGroup {
    texture_generation: u64,
    bind_group: wgpu::BindGroup,
}

impl WgpuResources {
    fn invalidate_intermediate_textures(&mut self) {
        self.path_intermediate_texture = None;
        self.path_intermediate_view = None;
        self.path_msaa_texture = None;
        self.path_msaa_view = None;
    }
}

struct WgpuRendererCore {
    resources: WgpuResources,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    atlas: Arc<WgpuAtlas>,
    globals: GlobalBufferLayout,
    rendering_params: RenderingParameters,
    subpixel_order: SubpixelOrder,
    dual_source_blending: bool,
    adapter_info: wgpu::AdapterInfo,
<<<<<<< HEAD
    uploaded_globals: Option<frame::GlobalUniformState>,
    faults: GpuFaultState,
=======
    target_format: wgpu::TextureFormat,
    max_texture_size: u32,
}

/// GPU resources of a windowed renderer. A surface is only ever configured against the
/// device that owns `core`, so it cannot outlive it: there is no surface-only state.
enum RendererState {
    /// Frames can be drawn.
    Ready {
        surface: wgpu::Surface<'static>,
        core: WgpuRendererCore,
    },
    /// The native surface is gone (Android `TerminateWindow`, browser context loss) but
    /// the device, pipelines, and atlas remain so `replace_surface` can resume without
    /// re-uploading cached textures.
    Unconfigured { core: WgpuRendererCore },
    /// Released by `destroy`, or dropped for a device recovery that has not succeeded yet.
    Released,
}

pub struct WgpuRenderer {
    /// Shared GPU context for device recovery coordination (unused on WASM).
    #[allow(dead_code)]
    context: Option<GpuContext>,
    /// Compositor GPU hint for adapter selection (unused on WASM).
    #[allow(dead_code)]
    compositor_gpu: Option<CompositorGpuHint>,
    state: RendererState,
    surface_config: wgpu::SurfaceConfiguration,
    atlas: Arc<WgpuAtlas>,
    transparent_alpha_mode: wgpu::CompositeAlphaMode,
    opaque_alpha_mode: wgpu::CompositeAlphaMode,
    max_texture_size: u32,
    is_bgr: bool,
    failed_frame_count: u32,
    device_errors: Arc<DeviceErrorState>,
    observed_error_generation: u64,
    last_surface_error: Option<String>,
    needs_redraw: bool,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
}

impl WgpuRenderer {
    fn core(&self) -> Option<&WgpuRendererCore> {
        match &self.state {
            RendererState::Ready { core, .. } | RendererState::Unconfigured { core } => Some(core),
            RendererState::Released => None,
        }
    }

    fn core_mut(&mut self) -> Option<&mut WgpuRendererCore> {
        match &mut self.state {
            RendererState::Ready { core, .. } | RendererState::Unconfigured { core } => Some(core),
            RendererState::Released => None,
        }
    }

<<<<<<< HEAD
=======
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
            .unwrap_or_else(|| WgpuContext::instance(Some(Box::new(window.clone()))));

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
            None => ctx_ref.insert(WgpuContext::new(instance, &surface, compositor_gpu)?),
        };

        let atlas = Arc::new(WgpuAtlas::from_context(context));

        Self::new_internal(
            Some(Rc::clone(&gpu_context)),
            context,
            surface,
            config,
            compositor_gpu,
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
        Self::new_from_surface(context, surface, config)
    }

    #[cfg(target_family = "wasm")]
    #[allow(clippy::arc_with_non_send_sync)]
    pub fn new_from_surface(
        context: &WgpuContext,
        surface: wgpu::Surface<'static>,
        config: WgpuSurfaceConfig,
    ) -> anyhow::Result<Self> {
        let atlas = Arc::new(WgpuAtlas::from_context(context));
        Self::new_internal(None, context, surface, config, None, atlas)
    }

>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    fn new_internal(
        gpu_context: Option<GpuContext>,
        context: &WgpuContext,
        surface: Option<wgpu::Surface<'static>>,
        config: WgpuSurfaceConfig,
        compositor_gpu: Option<CompositorGpuHint>,
        extra_requirements: Option<WgpuDeviceRequirements>,
        atlas: Arc<WgpuAtlas>,
    ) -> anyhow::Result<Self> {
<<<<<<< HEAD
        let target =
            RenderTarget::new(&context.adapter, &context.device, surface.as_ref(), config)?;
        if let Some(surface) = surface.as_ref() {
            surface.configure(&context.device, target.configuration());
        }

        let dual_source_blending = context.supports_dual_source_blending();
        let rendering_params = RenderingParameters::new(&context.adapter, target.format());
        let adapter_info = context.adapter.get_info();
        let (resources, metadata) = WgpuResources::new(
            context,
            surface,
            target.configuration(),
            &rendering_params,
            dual_source_blending,
        )?;
        let ResourceMetadata {
            globals,
            last_error,
        } = metadata;
=======
        let surface_caps = surface.get_capabilities(&context.adapter);
        let preferred_formats = [
            wgpu::TextureFormat::Bgra8Unorm,
            wgpu::TextureFormat::Rgba8Unorm,
        ];
        let surface_format = preferred_formats
            .iter()
            .find(|f| surface_caps.formats.contains(f))
            .copied()
            .or_else(|| {
                surface_caps
                    .formats
                    .iter()
                    .find(|format| !format.has_srgb_suffix())
                    .copied()
            })
            .or_else(|| surface_caps.formats.first().copied())
            .ok_or_else(|| {
                anyhow::anyhow!(
                    "Surface reports no supported texture formats for adapter {:?}",
                    context.adapter.get_info().name
                )
            })?;

        let pick_alpha_mode =
            |preferences: &[wgpu::CompositeAlphaMode]| -> anyhow::Result<wgpu::CompositeAlphaMode> {
                preferences
                    .iter()
                    .find(|p| surface_caps.alpha_modes.contains(p))
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
            color_space: wgpu::SurfaceColorSpace::Auto,
            width: clamped_width.max(1),
            height: clamped_height.max(1),
            present_mode: config
                .preferred_present_mode
                .filter(|mode| surface_caps.present_modes.contains(mode))
                .unwrap_or(wgpu::PresentMode::Fifo),
            desired_maximum_frame_latency: 2,
            alpha_mode,
            view_formats: vec![],
        };
        // Configure the surface immediately. The adapter selection process already validated
        // that this adapter can successfully configure this surface.
        surface.configure(&context.device, &surface_config);

        let core = WgpuRendererCore::new(context, atlas.clone(), surface_format, alpha_mode);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

        Ok(Self {
            context: gpu_context,
            compositor_gpu,
<<<<<<< HEAD
            extra_requirements,
            resources: Some(resources),
            target,
            atlas,
            globals,
            rendering_params,
            subpixel_order: SubpixelOrder::RedGreenBlue,
            dual_source_blending,
            adapter_info,
            uploaded_globals: None,
            faults: GpuFaultState {
                pending_error: last_error,
                consecutive_failed_frames: 0,
                device_lost: context.device_lost_flag(),
                #[cfg(not(target_family = "wasm"))]
                recovery_not_before: None,
            },
=======
            state: RendererState::Ready { surface, core },
            surface_config,
            atlas,
            transparent_alpha_mode,
            opaque_alpha_mode,
            max_texture_size,
            is_bgr: false,
            failed_frame_count: 0,
            device_errors: Arc::clone(context.errors()),
            observed_error_generation: 0,
            last_surface_error: None,
            needs_redraw: false,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        })
    }
}

<<<<<<< HEAD
    pub fn update_drawable_size(&mut self, size: Size<DevicePixels>) {
        if !self.target.resize(size) {
            return;
        }
        let config = self.target.configuration().clone();
        let Some(resources) = self.resources.as_mut() else {
            return;
        };
        resources.invalidate_intermediate_textures();
        if let Some(surface) = resources.surface.as_ref() {
            surface.configure(&resources.device, &config);
=======
impl WgpuRendererCore {
    fn create_bind_group_layouts(
        device: &wgpu::Device,
        uses_webgl_instance_data: bool,
    ) -> WgpuBindGroupLayouts {
        let globals =
            device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
                label: Some("globals_layout"),
                entries: &[
                    wgpu::BindGroupLayoutEntry {
                        binding: 0,
                        visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
                        ty: wgpu::BindingType::Buffer {
                            ty: wgpu::BufferBindingType::Uniform,
                            has_dynamic_offset: false,
                            min_binding_size: NonZeroU64::new(
                                std::mem::size_of::<GlobalParams>() as u64
                            ),
                        },
                        count: None,
                    },
                    wgpu::BindGroupLayoutEntry {
                        binding: 1,
                        visibility: wgpu::ShaderStages::FRAGMENT,
                        ty: wgpu::BindingType::Buffer {
                            ty: wgpu::BufferBindingType::Uniform,
                            has_dynamic_offset: false,
                            min_binding_size: NonZeroU64::new(
                                std::mem::size_of::<GammaParams>() as u64
                            ),
                        },
                        count: None,
                    },
                ],
            });

        let instance_data_entry = wgpu::BindGroupLayoutEntry {
            binding: 0,
            visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
            ty: if uses_webgl_instance_data {
                wgpu::BindingType::Texture {
                    sample_type: wgpu::TextureSampleType::Uint,
                    view_dimension: wgpu::TextureViewDimension::D2,
                    multisampled: false,
                }
            } else {
                wgpu::BindingType::Buffer {
                    ty: wgpu::BufferBindingType::Storage { read_only: true },
                    has_dynamic_offset: false,
                    min_binding_size: None,
                }
            },
            count: None,
        };

        let instances = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
            label: Some("instances_layout"),
            entries: &[instance_data_entry],
        });

        let texture = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
            label: Some("texture_layout"),
            entries: &[
                wgpu::BindGroupLayoutEntry {
                    binding: 0,
                    visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
                    ty: wgpu::BindingType::Texture {
                        sample_type: wgpu::TextureSampleType::Float { filterable: true },
                        view_dimension: wgpu::TextureViewDimension::D2,
                        multisampled: false,
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 1,
                    visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
                    ty: wgpu::BindingType::Sampler(wgpu::SamplerBindingType::Filtering),
                    count: None,
                },
            ],
        });

        let surfaces = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
            label: Some("surfaces_layout"),
            entries: &[
                wgpu::BindGroupLayoutEntry {
                    binding: 0,
                    visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
                    ty: wgpu::BindingType::Buffer {
                        ty: wgpu::BufferBindingType::Uniform,
                        has_dynamic_offset: false,
                        min_binding_size: NonZeroU64::new(
                            std::mem::size_of::<SurfaceParams>() as u64
                        ),
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 1,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Texture {
                        sample_type: wgpu::TextureSampleType::Float { filterable: true },
                        view_dimension: wgpu::TextureViewDimension::D2,
                        multisampled: false,
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 2,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Texture {
                        sample_type: wgpu::TextureSampleType::Float { filterable: true },
                        view_dimension: wgpu::TextureViewDimension::D2,
                        multisampled: false,
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 3,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Sampler(wgpu::SamplerBindingType::Filtering),
                    count: None,
                },
            ],
        });

        WgpuBindGroupLayouts {
            globals,
            instances,
            texture,
            surfaces,
        }
    }

    fn create_instance_texture(
        device: &wgpu::Device,
        requested_capacity: u64,
        max_texture_dimension: u32,
    ) -> (InstanceData, u64) {
        let texel_count = requested_capacity.div_ceil(INSTANCE_TEXTURE_TEXEL_SIZE);
        let width = texel_count.min(u64::from(max_texture_dimension)).max(1) as u32;
        let height = texel_count
            .div_ceil(u64::from(width))
            .min(u64::from(max_texture_dimension))
            .max(1) as u32;
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("instance_texture"),
            size: wgpu::Extent3d {
                width,
                height,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: wgpu::TextureFormat::Rgba32Uint,
            usage: wgpu::TextureUsages::TEXTURE_BINDING | wgpu::TextureUsages::COPY_DST,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        let capacity = u64::from(width) * u64::from(height) * INSTANCE_TEXTURE_TEXEL_SIZE;
        (
            InstanceData::Texture {
                texture,
                view,
                width,
                height,
            },
            capacity,
        )
    }

    fn create_pipelines(
        device: &wgpu::Device,
        layouts: &WgpuBindGroupLayouts,
        surface_format: wgpu::TextureFormat,
        alpha_mode: wgpu::CompositeAlphaMode,
        path_sample_count: u32,
        dual_source_blending: bool,
        uses_webgl_instance_data: bool,
    ) -> WgpuPipelines {
        // Diagnostic guard: verify the device actually has
        // DUAL_SOURCE_BLENDING. We have a crash report (ZED-5G1) where a
        // feature mismatch caused a wgpu-hal abort, but we haven't
        // identified the code path that produces the mismatch. This
        // guard prevents the crash and logs more evidence.
        // Remove this check once:
        // a) We find and fix the root cause, or
        // b) There are no reports of this warning appearing for some time.
        let device_has_feature = device
            .features()
            .contains(wgpu::Features::DUAL_SOURCE_BLENDING);
        if dual_source_blending && !device_has_feature {
            log::error!(
                "BUG: dual_source_blending flag is true but device does not \
                 have DUAL_SOURCE_BLENDING enabled (device features: {:?}). \
                 Falling back to mono text rendering. Please report this at \
                 https://github.com/zed-industries/zed/issues",
                device.features(),
            );
        }
        let dual_source_blending =
            dual_source_blending && device_has_feature && !uses_webgl_instance_data;

        let shader_source = if uses_webgl_instance_data {
            WEBGL_SHADERS
        } else {
            STORAGE_BUFFER_SHADERS
        };
        let shader_module = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("gpui_shaders"),
            source: wgpu::ShaderSource::Wgsl(shader_source.into()),
        });

        let subpixel_shader_module = if dual_source_blending {
            Some(device.create_shader_module(wgpu::ShaderModuleDescriptor {
                label: Some("gpui_subpixel_shaders"),
                source: wgpu::ShaderSource::Wgsl(SUBPIXEL_SHADERS.into()),
            }))
        } else {
            None
        };

        let blend_mode = match alpha_mode {
            wgpu::CompositeAlphaMode::PreMultiplied => {
                wgpu::BlendState::PREMULTIPLIED_ALPHA_BLENDING
            }
            _ => wgpu::BlendState::ALPHA_BLENDING,
        };

        let color_target = wgpu::ColorTargetState {
            format: surface_format,
            blend: Some(blend_mode),
            write_mask: wgpu::ColorWrites::ALL,
        };

        let create_pipeline = |name: &str,
                               vs_entry: &str,
                               fs_entry: &str,
                               globals_layout: &wgpu::BindGroupLayout,
                               data_layout: &wgpu::BindGroupLayout,
                               texture_layout: Option<&wgpu::BindGroupLayout>,
                               topology: wgpu::PrimitiveTopology,
                               color_targets: &[Option<wgpu::ColorTargetState>],
                               sample_count: u32,
                               module: &wgpu::ShaderModule| {
            let mut bind_group_layouts = vec![Some(globals_layout), Some(data_layout)];
            bind_group_layouts.extend(texture_layout.map(Some));
            let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
                label: Some(&format!("{name}_layout")),
                bind_group_layouts: &bind_group_layouts,
                immediate_size: 0,
            });

            device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
                label: Some(name),
                layout: Some(&pipeline_layout),
                vertex: wgpu::VertexState {
                    module,
                    entry_point: Some(vs_entry),
                    buffers: &[],
                    compilation_options: wgpu::PipelineCompilationOptions::default(),
                },
                fragment: Some(wgpu::FragmentState {
                    module,
                    entry_point: Some(fs_entry),
                    targets: color_targets,
                    compilation_options: wgpu::PipelineCompilationOptions::default(),
                }),
                primitive: wgpu::PrimitiveState {
                    topology,
                    strip_index_format: None,
                    front_face: wgpu::FrontFace::Ccw,
                    cull_mode: None,
                    polygon_mode: wgpu::PolygonMode::Fill,
                    unclipped_depth: false,
                    conservative: false,
                },
                depth_stencil: None,
                multisample: wgpu::MultisampleState {
                    count: sample_count,
                    mask: !0,
                    alpha_to_coverage_enabled: false,
                },
                multiview_mask: None,
                cache: None,
            })
        };

        let quads = create_pipeline(
            "quads",
            "vs_quad",
            "fs_quad",
            &layouts.globals,
            &layouts.instances,
            None,
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(color_target.clone())],
            1,
            &shader_module,
        );

        let shadows = create_pipeline(
            "shadows",
            "vs_shadow",
            "fs_shadow",
            &layouts.globals,
            &layouts.instances,
            None,
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(color_target.clone())],
            1,
            &shader_module,
        );

        let path_rasterization = create_pipeline(
            "path_rasterization",
            "vs_path_rasterization",
            "fs_path_rasterization",
            &layouts.globals,
            &layouts.instances,
            None,
            wgpu::PrimitiveTopology::TriangleList,
            &[Some(wgpu::ColorTargetState {
                format: surface_format,
                blend: Some(wgpu::BlendState::PREMULTIPLIED_ALPHA_BLENDING),
                write_mask: wgpu::ColorWrites::ALL,
            })],
            path_sample_count,
            &shader_module,
        );

        let paths = create_pipeline(
            "paths",
            "vs_path",
            "fs_path",
            &layouts.globals,
            &layouts.instances,
            Some(&layouts.texture),
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(wgpu::ColorTargetState {
                format: surface_format,
                blend: Some(wgpu::BlendState::PREMULTIPLIED_ALPHA_BLENDING),
                write_mask: wgpu::ColorWrites::ALL,
            })],
            1,
            &shader_module,
        );

        let underlines = create_pipeline(
            "underlines",
            "vs_underline",
            "fs_underline",
            &layouts.globals,
            &layouts.instances,
            None,
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(color_target.clone())],
            1,
            &shader_module,
        );

        let mono_sprites = create_pipeline(
            "mono_sprites",
            "vs_mono_sprite",
            "fs_mono_sprite",
            &layouts.globals,
            &layouts.instances,
            Some(&layouts.texture),
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(color_target.clone())],
            1,
            &shader_module,
        );

        let subpixel_sprites = if let Some(subpixel_module) = &subpixel_shader_module {
            let subpixel_blend = wgpu::BlendState {
                color: wgpu::BlendComponent {
                    src_factor: wgpu::BlendFactor::Src1,
                    dst_factor: wgpu::BlendFactor::OneMinusSrc1,
                    operation: wgpu::BlendOperation::Add,
                },
                alpha: wgpu::BlendComponent {
                    src_factor: wgpu::BlendFactor::One,
                    dst_factor: wgpu::BlendFactor::OneMinusSrcAlpha,
                    operation: wgpu::BlendOperation::Add,
                },
            };

            Some(create_pipeline(
                "subpixel_sprites",
                "vs_subpixel_sprite",
                "fs_subpixel_sprite",
                &layouts.globals,
                &layouts.instances,
                Some(&layouts.texture),
                wgpu::PrimitiveTopology::TriangleStrip,
                &[Some(wgpu::ColorTargetState {
                    format: surface_format,
                    blend: Some(subpixel_blend),
                    write_mask: wgpu::ColorWrites::COLOR,
                })],
                1,
                subpixel_module,
            ))
        } else {
            None
        };

        let poly_sprites = create_pipeline(
            "poly_sprites",
            "vs_poly_sprite",
            "fs_poly_sprite",
            &layouts.globals,
            &layouts.instances,
            Some(&layouts.texture),
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(color_target.clone())],
            1,
            &shader_module,
        );

        let surfaces = create_pipeline(
            "surfaces",
            "vs_surface",
            "fs_surface",
            &layouts.globals,
            &layouts.surfaces,
            None,
            wgpu::PrimitiveTopology::TriangleStrip,
            &[Some(color_target)],
            1,
            &shader_module,
        );

        WgpuPipelines {
            quads,
            shadows,
            path_rasterization,
            paths,
            underlines,
            mono_sprites,
            subpixel_sprites,
            poly_sprites,
            surfaces,
        }
    }

    fn create_path_intermediate(
        device: &wgpu::Device,
        format: wgpu::TextureFormat,
        width: u32,
        height: u32,
    ) -> (wgpu::Texture, wgpu::TextureView) {
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("path_intermediate"),
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
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        Some((texture, view))
    }
}

impl WgpuRenderer {
    /// Records the new drawable size and reconfigures the surface when one is present.
    /// The size is kept even without GPU resources so that recovery restores it.
    pub fn update_drawable_size(&mut self, size: Size<DevicePixels>) {
        let width = size.width.0 as u32;
        let height = size.height.0 as u32;

        if width == self.surface_config.width && height == self.surface_config.height {
            return;
        }

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

        let Some(core) = self.core_mut() else {
            return;
        };
        let resources = &mut core.resources;

        // Wait for any in-flight GPU work to complete before destroying textures
        if let Err(e) = resources.device.poll(wgpu::PollType::Wait {
            submission_index: None,
            timeout: None,
        }) {
            warn!("Failed to poll device during resize: {e:?}");
        }

        // Destroy old textures before allocating new ones to avoid GPU memory spikes
        if let Some(ref texture) = resources.path_intermediate_texture {
            texture.destroy();
        }
        if let Some(ref texture) = resources.path_msaa_texture {
            texture.destroy();
        }

        // Invalidate intermediate textures - they will be lazily recreated
        // in draw() after we confirm the surface is healthy. This avoids
        // panics when the device/surface is in an invalid state during resize.
        resources.invalidate_intermediate_textures();

        if let RendererState::Ready { surface, core } = &self.state {
            surface.configure(&core.resources.device, &self.surface_config);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
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
<<<<<<< HEAD
        self.set_subpixel_order(if is_bgr {
            SubpixelOrder::BlueGreenRed
        } else {
            SubpixelOrder::RedGreenBlue
        });
    }

    pub fn update_transparency(&mut self, transparent: bool) {
        if !self.target.set_transparent(transparent) {
            return;
=======
        self.is_bgr = is_bgr;
        if let Some(core) = self.core_mut() {
            core.is_bgr = is_bgr;
        }
    }

    pub fn update_transparency(&mut self, transparent: bool) {
        let new_alpha_mode = if transparent {
            self.transparent_alpha_mode
        } else {
            self.opaque_alpha_mode
        };
        if new_alpha_mode == self.surface_config.alpha_mode {
            return;
        }
        self.surface_config.alpha_mode = new_alpha_mode;
        let format = self.surface_config.format;

        let Some(core) = self.core_mut() else {
            return;
        };
        let resources = &mut core.resources;
        resources.pipelines = WgpuRendererCore::create_pipelines(
            &resources.device,
            &resources.bind_group_layouts,
            format,
            new_alpha_mode,
            core.rendering_params.path_sample_count,
            core.dual_source_blending,
            core.uses_webgl_instance_data,
        );

        if let RendererState::Ready { surface, core } = &self.state {
            surface.configure(&core.resources.device, &self.surface_config);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        }
        let config = self.target.configuration().clone();
        if let Some(resources) = self.resources.as_ref() {
            if let Some(surface) = resources.surface.as_ref() {
                surface.configure(&resources.device, &config);
            }
        }
        self.rebuild_pipelines();
    }

    pub(super) fn rebuild_pipelines(&mut self) {
        let config = self.target.configuration();
        let Some(resources) = self.resources.as_mut() else {
            return;
        };
        resources.pipelines = ShaderPipelines::new(
            &resources.device,
            &resources.bind_group_layouts,
            config.format,
            config.alpha_mode,
            self.rendering_params.path_sample_count,
            self.dual_source_blending,
            resources.renderer_tier,
        );
    }

    #[allow(dead_code)]
    pub fn viewport_size(&self) -> Size<DevicePixels> {
        self.target.viewport_size()
    }

    pub fn sprite_atlas(&self) -> &Arc<WgpuAtlas> {
        &self.atlas
    }

    pub fn supports_dual_source_blending(&self) -> bool {
        self.core().is_some_and(|core| core.dual_source_blending)
    }

<<<<<<< HEAD
    pub fn gpu_context(&self) -> (Arc<wgpu::Device>, Arc<wgpu::Queue>) {
        let resources = self.resources();
        (resources.device.clone(), resources.queue.clone())
    }

    pub fn gpu_context_info(&self) -> Option<WgpuContextHandle> {
        if let Some(context) = self.context.as_ref().and_then(|context| {
            context
                .borrow()
                .as_ref()
                .map(|context| context.handle(self.target.format()))
        }) {
            return Some(context);
        }
        self.resources.as_ref().map(|resources| {
            WgpuContextHandle::from_resources(
                resources.device.clone(),
                resources.queue.clone(),
                self.target.format(),
                self.adapter_info.clone(),
                match self.adapter_info.backend {
                    wgpu::Backend::BrowserWebGpu => crate::WgpuBackend::BrowserWebGpu,
                    wgpu::Backend::Gl => crate::WgpuBackend::Gl,
                    backend => crate::WgpuBackend::Native(backend),
                },
                self.faults.device_lost.clone(),
            )
        })
    }

    pub fn gpu_specs(&self) -> GpuSpecs {
        GpuSpecs {
            is_software_emulated: self.adapter_info.device_type == wgpu::DeviceType::Cpu,
            device_name: self.adapter_info.name.clone(),
            driver_name: self.adapter_info.driver.clone(),
            driver_info: self.adapter_info.driver_info.clone(),
        }
=======
    /// Returns `None` once GPU resources have been released by `destroy` or a pending
    /// device recovery.
    pub fn gpu_specs(&self) -> Option<GpuSpecs> {
        let adapter_info = &self.core()?.adapter_info;
        Some(GpuSpecs {
            is_software_emulated: adapter_info.device_type == wgpu::DeviceType::Cpu,
            device_name: adapter_info.name.clone(),
            driver_name: adapter_info.driver.clone(),
            driver_info: adapter_info.driver_info.clone(),
        })
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    pub fn max_texture_size(&self) -> u32 {
        self.target.maximum_dimension()
    }

<<<<<<< HEAD
    /// Encodes and submits a complete scene into an arbitrary color target.
    /// Swapchain drawing, window capture, and headless rendering all use this path so
    /// platform integrations can't diverge in batching, filters, or pipeline state.
    fn render_to_view(&mut self, scene: &Scene, frame_view: &wgpu::TextureView) -> bool {
        frame::render_to_view(self, scene, frame_view, None).is_some()
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    fn render_to_view_with_readback(
=======
    pub fn draw(&mut self, scene: &Scene) -> bool {
        #[cfg(target_family = "wasm")]
        if self.device_lost() {
            if matches!(self.state, RendererState::Ready { .. }) {
                log::error!(
                    "Browser graphics context was lost; rendering has stopped. Reload the page to recover."
                );
                self.unconfigure_surface();
            }
            return false;
        }

        // Bail out early if the surface has been unconfigured (e.g. during
        // Android background/rotation transitions).  Attempting to acquire
        // a texture from an unconfigured surface can block indefinitely on
        // some drivers (Adreno).
        let RendererState::Ready { surface, core } = &mut self.state else {
            return false;
        };

        if let Some(error) = self.last_surface_error.take().or_else(|| {
            self.device_errors
                .observe_error(&mut self.observed_error_generation)
        }) {
            self.failed_frame_count += 1;
            log::error!(
                "GPU error during frame (failure {} of 10): {error}",
                self.failed_frame_count
            );

            // TBD. Does retrying more actually help?
            if self.failed_frame_count > 10 {
                panic!("Too many consecutive GPU errors. Last error: {error}");
            } else if self.failed_frame_count > 5 {
                core.resources.invalidate_intermediate_textures();
                self.atlas.clear();
                self.needs_redraw = true;
                self.failed_frame_count = 0;
                return false;
            }
        } else {
            self.failed_frame_count = 0;
        }

        let frame = match surface.get_current_texture() {
            wgpu::CurrentSurfaceTexture::Success(frame) => frame,
            wgpu::CurrentSurfaceTexture::Suboptimal(frame) => {
                // Textures must be destroyed before the surface can be reconfigured.
                drop(frame);
                surface.configure(&core.resources.device, &self.surface_config);
                return false;
            }
            wgpu::CurrentSurfaceTexture::Lost | wgpu::CurrentSurfaceTexture::Outdated => {
                surface.configure(&core.resources.device, &self.surface_config);
                return false;
            }
            wgpu::CurrentSurfaceTexture::Timeout | wgpu::CurrentSurfaceTexture::Occluded => {
                return false;
            }
            wgpu::CurrentSurfaceTexture::Validation => {
                self.last_surface_error = Some("Surface texture validation error".to_string());
                return false;
            }
        };

        // The acquired texture is the authority on frame dimensions; the surface
        // configuration is only a request.
        let size = Size {
            width: DevicePixels(frame.texture.width() as i32),
            height: DevicePixels(frame.texture.height() as i32),
        };
        let frame_view = frame
            .texture
            .create_view(&wgpu::TextureViewDescriptor::default());
        let premultiplied_alpha =
            self.surface_config.alpha_mode == wgpu::CompositeAlphaMode::PreMultiplied;
        if let Err(error) = core.render_frame(
            scene,
            &frame_view,
            size,
            premultiplied_alpha,
            wgpu::Color::TRANSPARENT,
        ) {
            log::error!("{error:#}");
            return false;
        }

        core.resources.queue.present(frame);
        true
    }
}

impl WgpuRendererCore {
    fn new(
        context: &WgpuContext,
        atlas: Arc<WgpuAtlas>,
        target_format: wgpu::TextureFormat,
        alpha_mode: wgpu::CompositeAlphaMode,
    ) -> Self {
        let device = Arc::clone(&context.device);
        let queue = Arc::clone(&context.queue);
        let rendering_params = RenderingParameters::new(&context.adapter, target_format);
        let uses_webgl_instance_data = context.uses_webgl_instance_data();
        let dual_source_blending =
            context.supports_dual_source_blending() && !uses_webgl_instance_data;
        let bind_group_layouts = Self::create_bind_group_layouts(&device, uses_webgl_instance_data);
        let pipelines = Self::create_pipelines(
            &device,
            &bind_group_layouts,
            target_format,
            alpha_mode,
            rendering_params.path_sample_count,
            dual_source_blending,
            uses_webgl_instance_data,
        );
        let atlas_sampler = device.create_sampler(&wgpu::SamplerDescriptor {
            label: Some("atlas_sampler"),
            mag_filter: wgpu::FilterMode::Linear,
            min_filter: wgpu::FilterMode::Linear,
            ..Default::default()
        });
        let uniform_alignment = device.limits().min_uniform_buffer_offset_alignment as u64;
        let globals_size = std::mem::size_of::<GlobalParams>() as u64;
        let gamma_size = std::mem::size_of::<GammaParams>() as u64;
        let path_globals_offset = globals_size.next_multiple_of(uniform_alignment);
        let gamma_offset = (path_globals_offset + globals_size).next_multiple_of(uniform_alignment);
        let globals_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("globals_buffer"),
            size: gamma_offset + gamma_size,
            usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
            mapped_at_creation: false,
        });
        let (
            instance_data,
            instance_data_capacity,
            max_instance_data_size,
            instance_data_alignment,
        ) = if uses_webgl_instance_data {
            let max_texture_dimension = device.limits().max_texture_dimension_2d;
            let max_instance_data_size = (u64::from(max_texture_dimension).pow(2)
                * INSTANCE_TEXTURE_TEXEL_SIZE)
                .min(MAX_INSTANCE_BUFFER_SIZE);
            let initial_capacity = (2 * 1024 * 1024).min(max_instance_data_size);
            let (instance_data, capacity) =
                Self::create_instance_texture(&device, initial_capacity, max_texture_dimension);
            (
                instance_data,
                capacity,
                max_instance_data_size,
                INSTANCE_TEXTURE_TEXEL_SIZE,
            )
        } else {
            let max_buffer_size = device
                .limits()
                .max_buffer_size
                .min(device.limits().max_storage_buffer_binding_size)
                .min(MAX_INSTANCE_BUFFER_SIZE);
            let initial_capacity = (2 * 1024 * 1024).min(max_buffer_size);
            let buffer = device.create_buffer(&wgpu::BufferDescriptor {
                label: Some("instance_buffer"),
                size: initial_capacity,
                usage: wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
                mapped_at_creation: false,
            });
            (
                InstanceData::Storage(buffer),
                initial_capacity,
                max_buffer_size,
                device.limits().min_storage_buffer_offset_alignment as u64,
            )
        };
        let globals_bind_group = device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("globals_bind_group"),
            layout: &bind_group_layouts.globals,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: 0,
                    resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                        buffer: &globals_buffer,
                        offset: 0,
                        size: NonZeroU64::new(globals_size),
                    }),
                },
                wgpu::BindGroupEntry {
                    binding: 1,
                    resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                        buffer: &globals_buffer,
                        offset: gamma_offset,
                        size: NonZeroU64::new(gamma_size),
                    }),
                },
            ],
        });
        let path_globals_bind_group = device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("path_globals_bind_group"),
            layout: &bind_group_layouts.globals,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: 0,
                    resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                        buffer: &globals_buffer,
                        offset: path_globals_offset,
                        size: NonZeroU64::new(globals_size),
                    }),
                },
                wgpu::BindGroupEntry {
                    binding: 1,
                    resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                        buffer: &globals_buffer,
                        offset: gamma_offset,
                        size: NonZeroU64::new(gamma_size),
                    }),
                },
            ],
        });
        let max_texture_size = device.limits().max_texture_dimension_2d;

        Self {
            resources: WgpuResources {
                device,
                queue,
                pipelines,
                bind_group_layouts,
                atlas_sampler,
                atlas_texture_bind_groups: FxHashMap::default(),
                globals_buffer,
                globals_bind_group,
                path_globals_bind_group,
                instance_data,
                path_intermediate_texture: None,
                path_intermediate_view: None,
                path_msaa_texture: None,
                path_msaa_view: None,
            },
            atlas,
            path_globals_offset,
            gamma_offset,
            instance_data_capacity,
            max_instance_data_size,
            instance_data_alignment,
            uses_webgl_instance_data,
            rendering_params,
            is_bgr: false,
            dual_source_blending,
            adapter_info: context.adapter.get_info(),
            target_format,
            max_texture_size,
        }
    }

    fn resources(&self) -> &WgpuResources {
        &self.resources
    }

    fn resources_mut(&mut self) -> &mut WgpuResources {
        &mut self.resources
    }

    /// Path rendering goes through an intermediate texture that must match the frame
    /// target's dimensions, so the textures are keyed by size and rebuilt on mismatch.
    fn ensure_intermediate_textures(&mut self, size: Size<DevicePixels>) {
        let width = size.width.0 as u32;
        let height = size.height.0 as u32;
        if self
            .resources
            .path_intermediate_texture
            .as_ref()
            .is_some_and(|texture| texture.width() == width && texture.height() == height)
        {
            return;
        }

        let format = self.target_format;
        let path_sample_count = self.rendering_params.path_sample_count;
        let resources = &mut self.resources;

        let (texture, view) =
            Self::create_path_intermediate(&resources.device, format, width, height);
        resources.path_intermediate_texture = Some(texture);
        resources.path_intermediate_view = Some(view);

        let (path_msaa_texture, path_msaa_view) = Self::create_msaa_if_needed(
            &resources.device,
            format,
            width,
            height,
            path_sample_count,
        )
        .map(|(texture, view)| (Some(texture), Some(view)))
        .unwrap_or((None, None));
        resources.path_msaa_texture = path_msaa_texture;
        resources.path_msaa_view = path_msaa_view;
    }

    fn render_frame(
        &mut self,
        scene: &Scene,
        target_view: &wgpu::TextureView,
        size: Size<DevicePixels>,
        premultiplied_alpha: bool,
        clear_color: wgpu::Color,
    ) -> Result<wgpu::SubmissionIndex> {
        anyhow::ensure!(
            size.width.0 > 0 && size.height.0 > 0,
            "invalid render target size: {size:?}"
        );
        anyhow::ensure!(
            size.width.0 as u32 <= self.max_texture_size
                && size.height.0 as u32 <= self.max_texture_size,
            "render target size {size:?} exceeds maximum texture dimension {}",
            self.max_texture_size
        );

        self.atlas.before_frame();
        self.ensure_intermediate_textures(size);

        let gamma_params = GammaParams {
            gamma_ratios: self.rendering_params.gamma_ratios,
            grayscale_enhanced_contrast: self.rendering_params.grayscale_enhanced_contrast,
            subpixel_enhanced_contrast: self.rendering_params.subpixel_enhanced_contrast,
            is_bgr: self.is_bgr as u32,
            _pad: 0,
        };
        let globals = GlobalParams {
            viewport_size: [size.width.0 as f32, size.height.0 as f32],
            premultiplied_alpha: premultiplied_alpha as u32,
            pad: 0,
        };
        let path_globals = GlobalParams {
            premultiplied_alpha: 0,
            ..globals
        };
        self.resources.queue.write_buffer(
            &self.resources.globals_buffer,
            0,
            bytemuck::bytes_of(&globals),
        );
        self.resources.queue.write_buffer(
            &self.resources.globals_buffer,
            self.path_globals_offset,
            bytemuck::bytes_of(&path_globals),
        );
        self.resources.queue.write_buffer(
            &self.resources.globals_buffer,
            self.gamma_offset,
            bytemuck::bytes_of(&gamma_params),
        );

        self.record_frame(scene, target_view, clear_color)
            .inspect_err(|_| {
                // Queue writes are staged before encoding; flush them even if the frame fails.
                self.resources.queue.submit(std::iter::empty());
            })
    }

    fn record_frame(
        &mut self,
        scene: &Scene,
        frame_view: &wgpu::TextureView,
        clear_color: wgpu::Color,
    ) -> Result<wgpu::SubmissionIndex> {
        let mut instance_offset = 0;
        let instance_bindings = self
            .write_instances(scene, &mut instance_offset)
            .with_context(|| {
                format!(
                    "scene too large: {} paths, {} shadows, {} quads, {} underlines, {} monochrome sprites, {} subpixel sprites, {} polychrome sprites",
                    scene.paths.len(),
                    scene.shadows.len(),
                    scene.quads.len(),
                    scene.underlines.len(),
                    scene.monochrome_sprites.len(),
                    scene.subpixel_sprites.len(),
                    scene.polychrome_sprites.len(),
                )
            })?;
        self.prepare_texture_bind_groups(scene);

        let mut encoder =
            self.resources()
                .device
                .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                    label: Some("main_encoder"),
                });

        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("main_pass"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: frame_view,
                    resolve_target: None,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(clear_color),
                        store: wgpu::StoreOp::Store,
                    },
                    depth_slice: None,
                })],
                depth_stencil_attachment: None,
                ..Default::default()
            });

            for batch in scene.batches() {
                match batch {
                    PrimitiveBatch::Quads(range) => self.draw_instances(
                        &instance_bindings.quads,
                        &self.resources().pipelines.quads,
                        instance_range(range),
                        &mut pass,
                    ),
                    PrimitiveBatch::Shadows(range) => self.draw_instances(
                        &instance_bindings.shadows,
                        &self.resources().pipelines.shadows,
                        instance_range(range),
                        &mut pass,
                    ),
                    PrimitiveBatch::Paths(range) => {
                        let paths = &scene.paths[range];
                        if paths.is_empty() {
                            continue;
                        }

                        drop(pass);
                        let rasterized = self.draw_paths_to_intermediate(
                            &mut encoder,
                            paths,
                            &mut instance_offset,
                        )?;

                        pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                            label: Some("main_pass_continued"),
                            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                                view: frame_view,
                                resolve_target: None,
                                ops: wgpu::Operations {
                                    load: wgpu::LoadOp::Load,
                                    store: wgpu::StoreOp::Store,
                                },
                                depth_slice: None,
                            })],
                            depth_stencil_attachment: None,
                            ..Default::default()
                        });

                        if rasterized {
                            self.draw_paths_from_intermediate(
                                paths,
                                &mut instance_offset,
                                &mut pass,
                            )?;
                        }
                    }
                    PrimitiveBatch::Underlines(range) => self.draw_instances(
                        &instance_bindings.underlines,
                        &self.resources().pipelines.underlines,
                        instance_range(range),
                        &mut pass,
                    ),
                    PrimitiveBatch::MonochromeSprites { texture_id, range } => {
                        self.draw_sprites(
                            &instance_bindings.monochrome_sprites,
                            texture_id,
                            &self.resources().pipelines.mono_sprites,
                            instance_range(range),
                            &mut pass,
                        )?;
                    }
                    PrimitiveBatch::SubpixelSprites { texture_id, range } => {
                        let resources = self.resources();
                        self.draw_sprites(
                            &instance_bindings.subpixel_sprites,
                            texture_id,
                            resources
                                .pipelines
                                .subpixel_sprites
                                .as_ref()
                                .unwrap_or(&resources.pipelines.mono_sprites),
                            instance_range(range),
                            &mut pass,
                        )?;
                    }
                    PrimitiveBatch::PolychromeSprites { texture_id, range } => {
                        self.draw_sprites(
                            &instance_bindings.polychrome_sprites,
                            texture_id,
                            &self.resources().pipelines.poly_sprites,
                            instance_range(range),
                            &mut pass,
                        )?;
                    }
                    // Surfaces are macOS-only for video playback and are not
                    // implemented by the WGPU renderer.
                    PrimitiveBatch::Surfaces(_surfaces) => {}
                }
            }
        }

        let submission = self
            .resources()
            .queue
            .submit(std::iter::once(encoder.finish()));
        Ok(submission)
    }

    fn write_instances(
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        &mut self,
        scene: &Scene,
        frame_view: &wgpu::TextureView,
        readback: frame::ReadbackCopy<'_>,
    ) -> Option<wgpu::SubmissionIndex> {
        frame::render_to_view(self, scene, frame_view, Some(readback))
    }
}

<<<<<<< HEAD
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
=======
    fn create_texture_bind_group(
        &self,
        label: &str,
        texture_view: &wgpu::TextureView,
    ) -> wgpu::BindGroup {
        let resources = self.resources();
        resources
            .device
            .create_bind_group(&wgpu::BindGroupDescriptor {
                label: Some(label),
                layout: &resources.bind_group_layouts.texture,
                entries: &[
                    wgpu::BindGroupEntry {
                        binding: 0,
                        resource: wgpu::BindingResource::TextureView(texture_view),
                    },
                    wgpu::BindGroupEntry {
                        binding: 1,
                        resource: wgpu::BindingResource::Sampler(&resources.atlas_sampler),
                    },
                ],
            })
    }

    fn prepare_texture_bind_groups(&mut self, scene: &Scene) {
        let mut texture_ids = SmallVec::<[AtlasTextureId; 8]>::new();
        for batch in scene.batches() {
            let texture_id = match batch {
                PrimitiveBatch::MonochromeSprites { texture_id, .. }
                | PrimitiveBatch::SubpixelSprites { texture_id, .. }
                | PrimitiveBatch::PolychromeSprites { texture_id, .. } => texture_id,
                _ => continue,
            };
            if !texture_ids.contains(&texture_id) {
                texture_ids.push(texture_id);
            }
        }

        self.resources_mut()
            .atlas_texture_bind_groups
            .retain(|texture_id, _| texture_ids.contains(texture_id));

        for texture_id in texture_ids {
            let Some(texture_info) = self.atlas.get_texture_info(texture_id) else {
                self.resources_mut()
                    .atlas_texture_bind_groups
                    .remove(&texture_id);
                continue;
            };
            let is_current = self
                .resources()
                .atlas_texture_bind_groups
                .get(&texture_id)
                .is_some_and(|cached| cached.texture_generation == texture_info.generation);
            if is_current {
                continue;
            }

            let bind_group =
                self.create_texture_bind_group("atlas_texture_bind_group", &texture_info.view);
            self.resources_mut().atlas_texture_bind_groups.insert(
                texture_id,
                CachedTextureBindGroup {
                    texture_generation: texture_info.generation,
                    bind_group,
                },
            );
        }
    }

    fn draw_instances(
        &self,
        instances: &InstanceBinding,
        pipeline: &wgpu::RenderPipeline,
        range: Range<u32>,
        pass: &mut wgpu::RenderPass<'_>,
    ) {
        if range.is_empty() {
            return;
        }
        pass.set_pipeline(pipeline);
        pass.set_bind_group(0, &self.resources().globals_bind_group, &[]);
        pass.set_bind_group(1, &instances.bind_group, &[]);
        pass.draw(
            0..4,
            instances.first_instance + range.start..instances.first_instance + range.end,
        );
    }

    fn draw_sprites(
        &self,
        sprite_instances: &InstanceBinding,
        texture_id: AtlasTextureId,
        pipeline: &wgpu::RenderPipeline,
        range: Range<u32>,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> Result<()> {
        if range.is_empty() {
            return Ok(());
        }
        let resources = self.resources();
        // The atlas has released this texture; the batch belongs to a stale
        // paint that will be replaced once its view re-renders.
        let Some(texture) = resources.atlas_texture_bind_groups.get(&texture_id) else {
            return Ok(());
        };
        pass.set_pipeline(pipeline);
        pass.set_bind_group(0, &resources.globals_bind_group, &[]);
        pass.set_bind_group(1, &sprite_instances.bind_group, &[]);
        pass.set_bind_group(2, &texture.bind_group, &[]);
        pass.draw(
            0..4,
            sprite_instances.first_instance + range.start
                ..sprite_instances.first_instance + range.end,
        );
        Ok(())
    }

    unsafe fn instance_bytes<T>(instances: &[T]) -> &[u8] {
        unsafe {
            std::slice::from_raw_parts(
                instances.as_ptr() as *const u8,
                std::mem::size_of_val(instances),
            )
        }
    }

    fn draw_paths_from_intermediate(
        &mut self,
        paths: &[Path<ScaledPixels>],
        instance_offset: &mut u64,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> Result<()> {
        let first_path = &paths[0];
        let sprites: Vec<PathSprite> = if paths.last().map(|p| &p.order) == Some(&first_path.order)
        {
            paths
                .iter()
                .map(|p| PathSprite {
                    bounds: p.clipped_bounds(),
                })
                .collect()
        } else {
            let mut bounds = first_path.clipped_bounds();
            for path in paths.iter().skip(1) {
                bounds = bounds.union(&path.clipped_bounds());
            }
            vec![PathSprite { bounds }]
        };

        let Some(path_intermediate_view) = self.resources().path_intermediate_view.clone() else {
            return Ok(());
        };
        let instances =
            self.write_instance_binding("path_sprites_bind_group", instance_offset, &sprites)?;
        let texture = self.create_texture_bind_group(
            "path_intermediate_texture_bind_group",
            &path_intermediate_view,
        );
        let resources = self.resources();
        pass.set_pipeline(&resources.pipelines.paths);
        pass.set_bind_group(0, &resources.globals_bind_group, &[]);
        pass.set_bind_group(1, &instances.bind_group, &[]);
        pass.set_bind_group(2, &texture, &[]);
        pass.draw(
            0..4,
            instances.first_instance..instances.first_instance + sprites.len() as u32,
        );
        Ok(())
    }

    fn draw_paths_to_intermediate(
        &mut self,
        encoder: &mut wgpu::CommandEncoder,
        paths: &[Path<ScaledPixels>],
        instance_offset: &mut u64,
    ) -> Result<bool> {
        let mut vertices = Vec::new();
        for path in paths {
            let bounds = path.clipped_bounds();
            vertices.extend(path.vertices.iter().map(|v| PathRasterizationVertex {
                xy_position: v.xy_position,
                st_position: v.st_position,
                color: path.color,
                bounds,
            }));
        }

        if vertices.is_empty() {
            return Ok(false);
        }

        let vertex_binding = self.write_instance_binding(
            "path_rasterization_bind_group",
            instance_offset,
            &vertices,
        )?;

        let resources = self.resources();
        let Some(path_intermediate_view) = resources.path_intermediate_view.as_ref() else {
            return Ok(false);
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
            pass.set_bind_group(0, &resources.path_globals_bind_group, &[]);
            pass.set_bind_group(1, &vertex_binding.bind_group, &[]);
            // The path rasterization shader loads records by vertex index
            // rather than instance index, so the allocation's base shifts the
            // vertex range here.
            pass.draw(
                vertex_binding.first_instance
                    ..vertex_binding.first_instance + vertices.len() as u32,
                0..1,
            );
        }

        Ok(true)
    }

    fn write_instance_binding<T>(
        &mut self,
        label: &str,
        instance_offset: &mut u64,
        instances: &[T],
    ) -> Result<InstanceBinding> {
        let data = unsafe { Self::instance_bytes(instances) };
        // wgpu rejects zero-sized bindings, so empty primitive arrays still
        // reserve the 16-byte minimum.
        let size = (data.len() as u64).max(16);
        let stride = (std::mem::size_of::<T>() as u64).max(1);
        let (alignment, allocation_size) = if self.uses_webgl_instance_data {
            // The texture transport has no binding offset: the shader indexes
            // the instance texture absolutely, so each allocation must start on
            // a whole instance (a stride multiple) and a whole texel, and must
            // end on a texel boundary so the zero padding of its final partial
            // texel cannot overlap the next allocation.
            (
                least_common_multiple(self.instance_data_alignment, stride),
                size.next_multiple_of(INSTANCE_TEXTURE_TEXEL_SIZE),
            )
        } else {
            (self.instance_data_alignment.max(1), size)
        };
        let mut offset = (*instance_offset).next_multiple_of(alignment);
        if offset + allocation_size > self.instance_data_capacity {
            self.grow_instance_data(allocation_size)?;
            offset = 0;
        }
        *instance_offset = offset + allocation_size;

        let first_instance = if self.uses_webgl_instance_data {
            u32::try_from(offset / stride).context("instance index exceeds u32 range")?
        } else {
            0
        };

        let resources = self.resources();
        if !data.is_empty() {
            match &resources.instance_data {
                InstanceData::Storage(buffer) => resources.queue.write_buffer(buffer, offset, data),
                InstanceData::Texture { .. } => {
                    Self::write_instance_texture(resources, offset, data)
                }
            }
        }
        let bind_group = resources
            .device
            .create_bind_group(&wgpu::BindGroupDescriptor {
                label: Some(label),
                layout: &resources.bind_group_layouts.instances,
                entries: &[wgpu::BindGroupEntry {
                    binding: 0,
                    resource: match &resources.instance_data {
                        InstanceData::Storage(buffer) => {
                            wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                                buffer,
                                offset,
                                size: NonZeroU64::new(size),
                            })
                        }
                        InstanceData::Texture { view, .. } => {
                            wgpu::BindingResource::TextureView(view)
                        }
                    },
                }],
            });
        Ok(InstanceBinding {
            bind_group,
            first_instance,
        })
    }

    fn write_instance_texture(resources: &WgpuResources, offset: u64, data: &[u8]) {
        let InstanceData::Texture {
            texture,
            width,
            height,
            ..
        } = &resources.instance_data
        else {
            return;
        };
        let mut byte_offset = 0usize;
        let mut texel_offset = offset / INSTANCE_TEXTURE_TEXEL_SIZE;
        while byte_offset < data.len() {
            let x = (texel_offset % u64::from(*width)) as u32;
            let y = (texel_offset / u64::from(*width)) as u32;
            if y >= *height {
                // The capacity check in write_instance_binding should make this
                // unreachable. Truncating silently would leave stale bytes in the
                // texture and draw garbage for the remaining instances.
                debug_assert!(
                    false,
                    "instance texture write out of bounds: row {y} >= height {}",
                    *height
                );
                log::error!(
                    "instance texture write out of bounds; dropping {} bytes of instance data",
                    data.len() - byte_offset
                );
                return;
            }
            let available_texels = u64::from(*width - x);
            let remaining_bytes = data.len() - byte_offset;
            let complete_texels = remaining_bytes as u64 / INSTANCE_TEXTURE_TEXEL_SIZE;
            let texels = complete_texels.min(available_texels);
            if texels > 0 {
                let byte_count = (texels * INSTANCE_TEXTURE_TEXEL_SIZE) as usize;
                resources.queue.write_texture(
                    wgpu::TexelCopyTextureInfo {
                        texture,
                        mip_level: 0,
                        origin: wgpu::Origin3d { x, y, z: 0 },
                        aspect: wgpu::TextureAspect::All,
                    },
                    &data[byte_offset..byte_offset + byte_count],
                    wgpu::TexelCopyBufferLayout {
                        offset: 0,
                        bytes_per_row: Some(byte_count as u32),
                        rows_per_image: None,
                    },
                    wgpu::Extent3d {
                        width: texels as u32,
                        height: 1,
                        depth_or_array_layers: 1,
                    },
                );
                byte_offset += byte_count;
                texel_offset += texels;
                continue;
            }

            let mut final_texel = [0; INSTANCE_TEXTURE_TEXEL_SIZE as usize];
            final_texel[..remaining_bytes].copy_from_slice(&data[byte_offset..]);
            resources.queue.write_texture(
                wgpu::TexelCopyTextureInfo {
                    texture,
                    mip_level: 0,
                    origin: wgpu::Origin3d { x, y, z: 0 },
                    aspect: wgpu::TextureAspect::All,
                },
                &final_texel,
                wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(INSTANCE_TEXTURE_TEXEL_SIZE as u32),
                    rows_per_image: None,
                },
                wgpu::Extent3d {
                    width: 1,
                    height: 1,
                    depth_or_array_layers: 1,
                },
            );
            break;
        }
    }

    fn grow_instance_data(&mut self, required: u64) -> Result<()> {
        let capacity = (self.instance_data_capacity * 2)
            .max(required.next_power_of_two())
            .min(self.max_instance_data_size);
        anyhow::ensure!(
            capacity >= required,
            "instance data needs {required} bytes, above the maximum of {}",
            self.max_instance_data_size
        );
        anyhow::ensure!(
            capacity > self.instance_data_capacity,
            "frame instance data exceeds the {}-byte maximum",
            self.max_instance_data_size
        );
        log::debug!(
            "instance data grown from {} to {capacity}",
            self.instance_data_capacity
        );
        // Bind groups created earlier in the frame keep the previous buffer or
        // texture alive, so allocations written before the grow remain valid;
        // only subsequent writes land in the new allocation.
        let uses_webgl_instance_data = self.uses_webgl_instance_data;
        let resources = self.resources_mut();
        if uses_webgl_instance_data {
            let max_texture_dimension = resources.device.limits().max_texture_dimension_2d;
            let (instance_data, actual_capacity) =
                Self::create_instance_texture(&resources.device, capacity, max_texture_dimension);
            resources.instance_data = instance_data;
            self.instance_data_capacity = actual_capacity;
        } else {
            resources.instance_data =
                InstanceData::Storage(resources.device.create_buffer(&wgpu::BufferDescriptor {
                    label: Some("instance_buffer"),
                    size: capacity,
                    usage: wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
                    mapped_at_creation: false,
                }));
            self.instance_data_capacity = capacity;
        }
        Ok(())
    }
}

impl WgpuRenderer {
    /// Mark the surface as unconfigured so rendering is skipped until a new
    /// surface is provided via [`replace_surface`](Self::replace_surface).
    ///
    /// This does **not** drop the renderer — the device, queue, atlas, and
    /// pipelines stay alive.  Use this when the native window is destroyed
    /// (e.g. Android `TerminateWindow`) but you intend to re-create the
    /// surface later without losing cached atlas textures.
    pub fn unconfigure_surface(&mut self) {
        self.state = match std::mem::replace(&mut self.state, RendererState::Released) {
            RendererState::Ready { core, surface } => {
                drop(surface);
                RendererState::Unconfigured { core }
            }
            state @ (RendererState::Unconfigured { .. } | RendererState::Released) => state,
        };
        // Drop intermediate textures since they reference the old surface size.
        if let Some(core) = self.core_mut() {
            core.resources.invalidate_intermediate_textures();
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

        let mut core = match std::mem::replace(&mut self.state, RendererState::Released) {
            RendererState::Ready {
                core,
                surface: old_surface,
            } => {
                drop(old_surface);
                core
            }
            RendererState::Unconfigured { core } => core,
            RendererState::Released => {
                anyhow::bail!("Cannot replace the surface: GPU resources have been released")
            }
        };
        surface.configure(&core.resources.device, &self.surface_config);
        core.resources.invalidate_intermediate_textures();
        self.state = RendererState::Ready { surface, core };

        Ok(())
    }

    pub fn destroy(&mut self) {
        // Release surface-bound GPU resources eagerly so the underlying native
        // window can be destroyed before the renderer itself is dropped.
        self.state = RendererState::Released;
    }

    /// Returns true if the GPU device was lost and recovery is needed.
    pub fn device_lost(&self) -> bool {
        self.device_errors.device_lost()
    }

    /// Returns true if a redraw is needed because GPU state was cleared.
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

        // Check if another window already recovered the context
        let needs_new_context = gpu_context
            .borrow()
            .as_ref()
            .is_none_or(|ctx| ctx.device_lost());

        let window_handle = window
            .window_handle()
            .map_err(|e| anyhow::anyhow!("Failed to get window handle: {e}"))?;

        let surface = if needs_new_context {
            log::warn!("GPU device lost, recreating context...");

            // Drop old resources to release Arc<Device>/Arc<Queue> and GPU resources
            self.state = RendererState::Released;
            *gpu_context.borrow_mut() = None;

            // Wait briefly for the GPU driver to stabilize, then try to
            // recreate the context without software renderers. If this fails
            // the caller should request another frame and retry — the real GPU
            // may need more time to come back (e.g. after suspend/resume).
            std::thread::sleep(std::time::Duration::from_millis(350));

            let instance = WgpuContext::instance(Some(Box::new(window.clone())));
            let surface = create_surface(&instance, window_handle.as_raw())?;
            let new_context =
                WgpuContext::new_rejecting_software(instance, &surface, self.compositor_gpu)?;
            *gpu_context.borrow_mut() = Some(new_context);
            surface
        } else {
            let ctx_ref = gpu_context.borrow();
            let instance = &ctx_ref.as_ref().unwrap().instance;
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
        let ctx_ref = gpu_context.borrow();
        let context = ctx_ref.as_ref().expect("context should exist");

        self.state = RendererState::Released;
        self.atlas.handle_device_lost(context);

        let is_bgr = self.is_bgr;
        *self = Self::new_internal(
            Some(gpu_context.clone()),
            context,
            surface,
            config,
            self.compositor_gpu,
            self.atlas.clone(),
        )?;
        self.set_subpixel_layout(is_bgr);

        log::info!("GPU recovery complete");
        Ok(())
    }
}

#[cfg(all(
    not(target_family = "wasm"),
    any(test, feature = "bench-support", feature = "test-support")
))]
struct HeadlessRenderTarget {
    texture: wgpu::Texture,
    view: wgpu::TextureView,
}

#[cfg(all(
    not(target_family = "wasm"),
    any(test, feature = "bench-support", feature = "test-support")
))]
impl HeadlessRenderTarget {
    fn size(&self) -> Size<DevicePixels> {
        Size {
            width: DevicePixels(self.texture.width() as i32),
            height: DevicePixels(self.texture.height() as i32),
        }
    }
}

#[cfg(all(
    not(target_family = "wasm"),
    any(test, feature = "bench-support", feature = "test-support")
))]
pub struct WgpuHeadlessRenderer {
    context: WgpuContext,
    core: WgpuRendererCore,
    render_target: Option<HeadlessRenderTarget>,
    observed_error_generation: u64,
}

#[cfg(all(
    not(target_family = "wasm"),
    any(test, feature = "bench-support", feature = "test-support")
))]
impl WgpuHeadlessRenderer {
    pub fn new() -> anyhow::Result<Self> {
        let (context, target_format) = WgpuContext::new_headless()?;
        // The device may be shared with earlier renderers; observe only errors raised from
        // here on, including any while this renderer builds its pipelines.
        let observed_error_generation = context.errors().current_generation();
        let atlas = Arc::new(WgpuAtlas::from_context(&context));
        let core = WgpuRendererCore::new(
            &context,
            atlas,
            target_format,
            wgpu::CompositeAlphaMode::Opaque,
        );

        Ok(Self {
            context,
            core,
            render_target: None,
            observed_error_generation,
        })
    }

    fn ensure_render_target(&mut self, size: Size<DevicePixels>) -> anyhow::Result<()> {
        anyhow::ensure!(
            size.width.0 > 0 && size.height.0 > 0,
            "invalid headless render target size: {size:?}"
        );
        anyhow::ensure!(
            size.width.0 as u32 <= self.core.max_texture_size
                && size.height.0 as u32 <= self.core.max_texture_size,
            "headless render target size {size:?} exceeds maximum texture dimension {}",
            self.core.max_texture_size
        );
        if self
            .render_target
            .as_ref()
            .is_some_and(|target| target.size() == size)
        {
            return Ok(());
        }

        let texture = self
            .core
            .resources
            .device
            .create_texture(&wgpu::TextureDescriptor {
                label: Some("headless_render_target"),
                size: wgpu::Extent3d {
                    width: size.width.0 as u32,
                    height: size.height.0 as u32,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format: self.core.target_format,
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
                view_formats: &[],
            });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        self.render_target = Some(HeadlessRenderTarget { texture, view });
        Ok(())
    }

    fn check_gpu_errors(&mut self) -> anyhow::Result<()> {
        anyhow::ensure!(
            !self.context.device_lost(),
            "GPU device was lost during headless rendering"
        );
        if let Some(error) = self
            .context
            .errors()
            .observe_error(&mut self.observed_error_generation)
        {
            anyhow::bail!("GPU error during headless rendering: {error}");
        }
        Ok(())
    }

    fn render(&mut self, scene: &Scene, size: Size<DevicePixels>) -> anyhow::Result<()> {
        self.check_gpu_errors()?;
        self.ensure_render_target(size)?;
        let view = self
            .render_target
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Headless render target was not created"))?
            .view
            .clone();
        self.core
            .render_frame(scene, &view, size, false, wgpu::Color::BLACK)?;
        Ok(())
    }

    /// Copies the current render target back to the CPU. Dimensions come from the
    /// target texture itself, so the copy can never disagree with what was rendered.
    fn read_image(&mut self) -> anyhow::Result<image::RgbaImage> {
        let target = self
            .render_target
            .as_ref()
            .ok_or_else(|| anyhow::anyhow!("Headless render target was not created"))?;
        let width = target.texture.width();
        let height = target.texture.height();
        let bytes_per_row = width
            .checked_mul(4)
            .ok_or_else(|| anyhow::anyhow!("Headless render target row size overflowed"))?;
        let padded_bytes_per_row = bytes_per_row
            .checked_next_multiple_of(wgpu::COPY_BYTES_PER_ROW_ALIGNMENT)
            .ok_or_else(|| anyhow::anyhow!("Headless padded row size overflowed"))?;
        let buffer_size = u64::from(padded_bytes_per_row)
            .checked_mul(u64::from(height))
            .ok_or_else(|| anyhow::anyhow!("Headless readback buffer size overflowed"))?;
        anyhow::ensure!(
            buffer_size <= self.core.resources.device.limits().max_buffer_size,
            "Headless readback buffer size {buffer_size} exceeds maximum buffer size {}",
            self.core.resources.device.limits().max_buffer_size
        );
        let readback_buffer = self
            .core
            .resources
            .device
            .create_buffer(&wgpu::BufferDescriptor {
                label: Some("headless_readback_buffer"),
                size: buffer_size,
                usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
                mapped_at_creation: false,
            });
        let mut encoder =
            self.core
                .resources
                .device
                .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                    label: Some("headless_readback_encoder"),
                });
        encoder.copy_texture_to_buffer(
            wgpu::TexelCopyTextureInfo {
                texture: &target.texture,
                mip_level: 0,
                origin: wgpu::Origin3d::ZERO,
                aspect: wgpu::TextureAspect::All,
            },
            wgpu::TexelCopyBufferInfo {
                buffer: &readback_buffer,
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
        let submission = self
            .core
            .resources
            .queue
            .submit(std::iter::once(encoder.finish()));
        let (sender, receiver) = std::sync::mpsc::channel();
        readback_buffer
            .slice(..)
            .map_async(wgpu::MapMode::Read, move |result| {
                if sender.send(result).is_err() {
                    log::error!("Headless readback receiver was dropped before mapping completed");
                }
            });
        self.core
            .resources
            .device
            .poll(wgpu::PollType::Wait {
                submission_index: Some(submission),
                timeout: Some(std::time::Duration::from_secs(30)),
            })
            .map_err(|error| anyhow::anyhow!("Failed to wait for headless rendering: {error}"))?;
        receiver
            .recv_timeout(std::time::Duration::from_secs(30))
            .map_err(|error| anyhow::anyhow!("Failed to receive headless mapping result: {error}"))?
            .map_err(|error| anyhow::anyhow!("Failed to map headless readback buffer: {error}"))?;
        self.check_gpu_errors()?;

        let mapped_data = readback_buffer.slice(..).get_mapped_range()?;
        let pixel_capacity = usize::try_from(u64::from(bytes_per_row) * u64::from(height))
            .map_err(|_| anyhow::anyhow!("Headless image size exceeds addressable memory"))?;
        let mut pixels = Vec::with_capacity(pixel_capacity);
        for row in mapped_data
            .chunks_exact(padded_bytes_per_row as usize)
            .take(height as usize)
        {
            pixels.extend_from_slice(&row[..bytes_per_row as usize]);
        }
        drop(mapped_data);
        readback_buffer.unmap();

        if self.core.target_format == wgpu::TextureFormat::Bgra8Unorm {
            for pixel in pixels.chunks_exact_mut(4) {
                pixel.swap(0, 2);
            }
        }

        image::RgbaImage::from_raw(width, height, pixels)
            .ok_or_else(|| anyhow::anyhow!("Failed to create image from headless pixel data"))
    }
}

#[cfg(all(
    not(target_family = "wasm"),
    any(test, feature = "bench-support", feature = "test-support")
))]
impl gpui::PlatformHeadlessRenderer for WgpuHeadlessRenderer {
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<image::RgbaImage> {
        self.render(scene, size)?;
        self.read_image()
    }

    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> anyhow::Result<()> {
        self.render(scene, size)
    }

    fn sprite_atlas(&self) -> Arc<dyn gpui::PlatformAtlas> {
        self.core.atlas.clone()
    }
}

fn instance_range(range: Range<usize>) -> Range<u32> {
    range.start as u32..range.end as u32
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

struct RenderingParameters {
    path_sample_count: u32,
    gamma_ratios: [f32; 4],
    grayscale_enhanced_contrast: f32,
    subpixel_enhanced_contrast: f32,
}

impl RenderingParameters {
    fn new(adapter: &wgpu::Adapter, surface_format: wgpu::TextureFormat) -> Self {
        use std::env;

        let format_features = adapter.get_texture_format_features(surface_format);
        let path_sample_count = [4, 2, 1]
            .into_iter()
            .find(|&n| format_features.flags.sample_count_supported(n))
            .unwrap_or(1);

        let gamma = env::var("ZED_FONTS_GAMMA")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(1.8_f32)
            .clamp(1.0, 2.2);
        let gamma_ratios = get_gamma_correction_ratios(gamma);

        let grayscale_enhanced_contrast = env::var("ZED_FONTS_GRAYSCALE_ENHANCED_CONTRAST")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(1.0_f32)
            .max(0.0);

        let subpixel_enhanced_contrast = env::var("ZED_FONTS_SUBPIXEL_ENHANCED_CONTRAST")
            .ok()
            .and_then(|v| v.parse().ok())
            .unwrap_or(0.5_f32)
            .max(0.0);

        Self {
            path_sample_count,
            gamma_ratios,
            grayscale_enhanced_contrast,
            subpixel_enhanced_contrast,
        }
    }
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
}

#[cfg(test)]
mod tests {
    use super::*;
<<<<<<< HEAD
    use crate::wgpu_renderer::filters::FrameUniformRequirements;
=======
    use gpui::{
        BorderStyle, ColorSpace, ContentMask, Corners, Edges, Hsla, MonochromeSprite,
        PolychromeSprite, Quad, Shadow, Size, SubpixelSprite, Underline, linear_color_stop,
        linear_gradient,
    };
    #[cfg(target_os = "linux")]
    use gpui::{DevicePixels, PlatformHeadlessRenderer, Scene};

    #[cfg(target_os = "linux")]
    fn device_size(width: i32, height: i32) -> Size<DevicePixels> {
        Size {
            width: DevicePixels(width),
            height: DevicePixels(height),
        }
    }

    #[cfg(target_os = "linux")]
    fn solid_quad(x: f32, y: f32, width: f32, height: f32, color: Hsla) -> Quad {
        let bounds = Bounds {
            origin: Point {
                x: x.into(),
                y: y.into(),
            },
            size: Size {
                width: width.into(),
                height: height.into(),
            },
        };
        Quad {
            order: 0,
            border_style: BorderStyle::Solid,
            bounds,
            content_mask: ContentMask { bounds },
            background: color.into(),
            border_color: color,
            corner_radii: Corners::default(),
            border_widths: Edges::default(),
        }
    }

    /// Channels are compared with a small tolerance so the assertions hold across
    /// drivers without pinning exact rasterizer output.
    #[cfg(target_os = "linux")]
    fn assert_pixel(image: &image::RgbaImage, x: u32, y: u32, expected: [u8; 4]) {
        let actual = image.get_pixel(x, y).0;
        assert!(
            actual
                .iter()
                .zip(expected)
                .all(|(actual, expected)| actual.abs_diff(expected) <= 3),
            "pixel ({x}, {y}) was {actual:?}, expected {expected:?}"
        );
    }

    #[cfg(target_os = "linux")]
    const RED: [u8; 4] = [255, 0, 0, 255];
    #[cfg(target_os = "linux")]
    const BLUE: [u8; 4] = [0, 0, 255, 255];
    #[cfg(target_os = "linux")]
    const BLACK: [u8; 4] = [0, 0, 0, 255];

    #[cfg(target_os = "linux")]
    #[test]
    fn headless_renderer_draws_quads_with_distinct_colors() -> anyhow::Result<()> {
        let mut renderer = WgpuHeadlessRenderer::new()?;
        let mut scene = Scene::default();
        scene.insert_primitive(solid_quad(0.0, 0.0, 32.0, 32.0, gpui::red()));
        scene.insert_primitive(solid_quad(32.0, 0.0, 32.0, 32.0, gpui::blue()));
        scene.finish();

        let image = renderer.render_scene_to_image(&scene, device_size(64, 32))?;
        assert_eq!(image.dimensions(), (64, 32));
        assert_pixel(&image, 8, 16, RED);
        assert_pixel(&image, 24, 16, RED);
        assert_pixel(&image, 40, 16, BLUE);
        assert_pixel(&image, 56, 16, BLUE);
        Ok(())
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn headless_renderer_captures_each_requested_size() -> anyhow::Result<()> {
        let mut renderer = WgpuHeadlessRenderer::new()?;
        let mut scene = Scene::default();
        scene.insert_primitive(solid_quad(2.0, 2.0, 4.0, 3.0, gpui::red()));
        scene.finish();

        // 13 px rows are 52 bytes, forcing readback to strip copy-row padding.
        let image = renderer.render_scene_to_image(&scene, device_size(13, 7))?;
        assert_eq!(image.dimensions(), (13, 7));
        assert_pixel(&image, 0, 0, BLACK);
        assert_pixel(&image, 3, 3, RED);
        assert_pixel(&image, 12, 6, BLACK);

        let image = renderer.render_scene_to_image(&scene, device_size(17, 9))?;
        assert_eq!(image.dimensions(), (17, 9));
        assert_pixel(&image, 3, 3, RED);
        assert_pixel(&image, 16, 8, BLACK);

        let image = renderer.render_scene_to_image(&Scene::default(), device_size(13, 7))?;
        assert_eq!(image.dimensions(), (13, 7));
        assert!(image.pixels().all(|pixel| pixel.0 == BLACK));
        Ok(())
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn headless_renderer_reuses_target_for_same_size() -> anyhow::Result<()> {
        let mut renderer = WgpuHeadlessRenderer::new()?;
        let target_texture = |renderer: &WgpuHeadlessRenderer| {
            renderer
                .render_target
                .as_ref()
                .map(|target| target.texture.clone())
        };

        renderer.render_scene(&Scene::default(), device_size(16, 16))?;
        let first = target_texture(&renderer);
        assert!(first.is_some());

        renderer.render_scene(&Scene::default(), device_size(16, 16))?;
        assert_eq!(target_texture(&renderer), first);

        renderer.render_scene(&Scene::default(), device_size(16, 17))?;
        assert_ne!(target_texture(&renderer), first);
        Ok(())
    }

    #[cfg(target_os = "linux")]
    #[test]
    fn headless_renderer_rejects_invalid_sizes() -> anyhow::Result<()> {
        let mut renderer = WgpuHeadlessRenderer::new()?;
        let too_large = renderer.core.max_texture_size as i32 + 1;

        for size in [
            device_size(0, 8),
            device_size(8, 0),
            device_size(-1, 8),
            device_size(too_large, 8),
        ] {
            assert!(
                renderer.render_scene(&Scene::default(), size).is_err(),
                "{size:?} should be rejected"
            );
            assert!(
                renderer
                    .render_scene_to_image(&Scene::default(), size)
                    .is_err(),
                "{size:?} should be rejected"
            );
        }

        // Rejection must leave the renderer usable.
        let image = renderer.render_scene_to_image(&Scene::default(), device_size(4, 4))?;
        assert_eq!(image.dimensions(), (4, 4));
        Ok(())
    }
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

    // Native shader backends can differ slightly when quantizing transcendental math to UNORM8.
    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    const MAX_CROSS_BACKEND_CHANNEL_DELTA: u8 = 2;

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    fn dashed_border_scene(dash_length: f32, dash_gap: f32) -> Scene {
        let full_bounds = Bounds {
            origin: Point {
                x: ScaledPixels(0.0),
                y: ScaledPixels(0.0),
            },
            size: Size {
                width: ScaledPixels(40.0),
                height: ScaledPixels(20.0),
            },
        };
        let quad_bounds = |left| Bounds {
            origin: Point {
                x: ScaledPixels(left),
                y: ScaledPixels(4.0),
            },
            size: Size {
                width: ScaledPixels(12.0),
                height: ScaledPixels(12.0),
            },
        };
        let mut scene = Scene::default();

        for (bounds, corner_smoothing) in [(quad_bounds(4.0), 0.0), (quad_bounds(24.0), 0.6)] {
            scene.insert_primitive(Quad {
                bounds,
                content_mask: gpui::ContentMask {
                    bounds: full_bounds,
                    ..Default::default()
                },
                background: gpui::solid_background(gpui::hsla(0.05, 0.8, 0.45, 1.0)),
                border_style: gpui::BorderStyle::Dashed,
                border_dashed_length: dash_length,
                border_dashed_gap: dash_gap,
                border_color: gpui::hsla(0.6, 0.9, 0.7, 1.0).into(),
                corner_radii: gpui::Corners::all(ScaledPixels(4.0)),
                border_widths: gpui::Edges::all(ScaledPixels(2.0)),
                corner_smoothing,
                ..Default::default()
            });
        }

        scene.finish();

        scene
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    fn images_differ_in_region(
        first: &image::RgbaImage,
        second: &image::RgbaImage,
        left: u32,
        right: u32,
    ) -> bool {
        (4..16).any(|y| (left..right).any(|x| first.get_pixel(x, y) != second.get_pixel(x, y)))
    }

    #[test]
    fn rust_storage_types_match_shader_strides() {
        fn module_layout(source: &wgsl_rs::Source) -> (naga::Module, naga::proc::Layouter) {
            let source = source.wgsl_source().expect("shader must generate WGSL");
            let module =
                naga::front::wgsl::parse_str(&format!("enable dual_source_blending;\n{source}"))
                    .expect("generated shader must parse as WGSL");
            let mut layouter = naga::proc::Layouter::default();
            layouter
                .update(module.to_ctx())
                .expect("generated shader types must have valid layouts");
            (module, layouter)
        }

        let (base, base_layout) = module_layout(&gpui_render::shaders::base::WGSL_SOURCE);
        let (subpixel, subpixel_layout) =
            module_layout(&gpui_render::shaders::subpixel_sprite::WGSL_SOURCE);

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
                shader_stride as usize, abi.rust_stride,
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
        scene.finish();

        assert_eq!(
            frame::FrameRequirements::for_scene(
                &scene,
                super::buffers::InstanceTransport::StorageBuffer
            )
            .uniforms,
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
        let straight = pipelines::desktop_scene_blend_state(wgpu::CompositeAlphaMode::Opaque);
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
        // Forces a non-zero first-instance index in the mixed-type arena.
        scene.insert_primitive(Quad::default());
        scene.insert_primitive(Underline {
            order: 0,
            padding: 0,
            bounds,
            content_mask: gpui::ContentMask {
                bounds,
                ..Default::default()
            },
            color: gpui::hsla(0.0, 1.0, 0.5, 0.5).into(),
            thickness: ScaledPixels(1.0),
            wavy: false.into(),
        });
        scene.finish();

        let image = renderer.render_to_image(&scene)?;
        let center = image.get_pixel(1, 1).0;
        assert_eq!(
            center,
            [128, 0, 0, 255],
            "must match the retired Metal renderer's mixed primitive baseline"
        );
        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn configurable_dashes_reach_both_wgpu_quad_pipelines() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let size = Size {
            width: DevicePixels(40),
            height: DevicePixels(20),
        };
        let mut renderer = WgpuRenderer::new_headless(&context, size)?;
        let default_image = renderer.render_to_image(&dashed_border_scene(2.0, 1.0))?;
        let custom_image = renderer.render_to_image(&dashed_border_scene(4.0, 0.5))?;

        assert!(
            images_differ_in_region(&default_image, &custom_image, 4, 16),
            "custom dash length and gap must change the ordinary quad pipeline"
        );
        assert!(
            images_differ_in_region(&default_image, &custom_image, 24, 36),
            "custom dash length and gap must change the smoothed quad pipeline"
        );

        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn quad_backgrounds_match_legacy_metal_pixels() -> anyhow::Result<()> {
        const LEGACY: &[u8] = &[
            255, 0, 0, 255, 255, 0, 0, 255, 0, 0, 0, 255, 38, 110, 217, 255, 255, 0, 0, 255, 255,
            0, 0, 255, 38, 110, 217, 255, 0, 0, 0, 255, 10, 34, 4, 255, 57, 196, 22, 255, 193, 114,
            152, 255, 223, 155, 105, 255, 57, 196, 22, 255, 10, 34, 4, 255, 165, 60, 182, 255, 193,
            114, 151, 255,
        ];
        let bounds = |x, y| Bounds {
            origin: Point {
                x: ScaledPixels(x),
                y: ScaledPixels(y),
            },
            size: Size {
                width: ScaledPixels(2.0),
                height: ScaledPixels(2.0),
            },
        };
        let mut scene = Scene::default();
        for (order, (bounds, background)) in [
            (
                bounds(0.0, 0.0),
                gpui::solid_background(gpui::hsla(0.0, 1.0, 0.5, 1.0)),
            ),
            (
                bounds(2.0, 0.0),
                gpui::checkerboard(gpui::hsla(0.6, 0.7, 0.5, 1.0), 1.0),
            ),
            (
                bounds(0.0, 2.0),
                gpui::pattern_slash(gpui::hsla(0.3, 0.8, 0.5, 1.0), 1.0, 1.0),
            ),
            (
                bounds(2.0, 2.0),
                gpui::linear_gradient(
                    45.0,
                    gpui::linear_color_stop(gpui::hsla(0.8, 0.9, 0.4, 1.0), 0.0),
                    gpui::linear_color_stop(gpui::hsla(0.1, 0.8, 0.6, 1.0), 1.0),
                ),
            ),
        ]
        .into_iter()
        .enumerate()
        {
            scene.insert_primitive(Quad {
                order: order as u32,
                bounds,
                content_mask: gpui::ContentMask {
                    bounds,
                    ..Default::default()
                },
                background,
                ..Default::default()
            });
        }
        scene.finish();
        let context = WgpuContext::new_headless(None)?;
        let mut renderer = WgpuRenderer::new_headless(
            &context,
            Size {
                width: DevicePixels(4),
                height: DevicePixels(4),
            },
        )?;
        let actual = renderer.render_to_image(&scene)?;
        for (index, (actual, expected)) in actual.as_raw().iter().zip(LEGACY).enumerate() {
            assert!(
                actual.abs_diff(*expected) <= MAX_CROSS_BACKEND_CHANNEL_DELTA,
                "legacy mismatch at pixel ({}, {}), channel {}: got {}, expected {}",
                (index / 4) % 4,
                (index / 4) / 4,
                index % 4,
                actual,
                expected,
            );
        }
        assert_eq!(actual.as_raw().len(), LEGACY.len());
        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn quad_border_backgrounds_use_the_fill_coordinate_space() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let size = Size {
            width: DevicePixels(12),
            height: DevicePixels(12),
        };
        let bounds = Bounds {
            origin: Point {
                x: ScaledPixels(0.0),
                y: ScaledPixels(0.0),
            },
            size: Size {
                width: ScaledPixels(12.0),
                height: ScaledPixels(12.0),
            },
        };
        let render = |quad| -> anyhow::Result<image::RgbaImage> {
            let mut scene = Scene::default();
            scene.insert_primitive(quad);
            scene.finish();
            let mut renderer = WgpuRenderer::new_headless(&context, size)?;
            renderer.render_to_image(&scene)
        };
        let backgrounds = [
            gpui::solid_background(gpui::hsla(0.0, 1.0, 0.5, 1.0)),
            gpui::checkerboard(gpui::hsla(0.6, 0.7, 0.5, 1.0), 2.0),
            gpui::pattern_slash(gpui::hsla(0.3, 0.8, 0.5, 1.0), 2.0, 2.0),
            gpui::linear_gradient(
                90.0,
                gpui::linear_color_stop(gpui::hsla(0.8, 0.9, 0.4, 1.0), 0.0),
                gpui::linear_color_stop(gpui::hsla(0.1, 0.8, 0.6, 1.0), 1.0),
            ),
        ];
        let border_samples = [
            (1, 1),
            (6, 1),
            (10, 1),
            (1, 6),
            (10, 6),
            (1, 10),
            (6, 10),
            (10, 10),
        ];

        for background in backgrounds {
            let filled = render(Quad {
                bounds,
                content_mask: gpui::ContentMask {
                    bounds,
                    ..Default::default()
                },
                background,
                ..Default::default()
            })?;
            let bordered = render(Quad {
                bounds,
                content_mask: gpui::ContentMask {
                    bounds,
                    ..Default::default()
                },
                border_color: background,
                border_widths: gpui::Edges::all(ScaledPixels(4.0)),
                ..Default::default()
            })?;

            for (x, y) in border_samples {
                let border_pixel = bordered.get_pixel(x, y).0;
                let fill_pixel = filled.get_pixel(x, y).0;
                for (channel, (border, fill)) in
                    border_pixel.iter().zip(fill_pixel.iter()).enumerate()
                {
                    assert!(
                        border.abs_diff(*fill) <= MAX_CROSS_BACKEND_CHANNEL_DELTA,
                        "border background must sample like a fill at ({x}, {y}), channel {channel}, for {background:?}: got {border_pixel:?}, expected {fill_pixel:?}"
                    );
                }
            }
            assert_eq!(
                bordered.get_pixel(6, 6).0,
                [0, 0, 0, 255],
                "border background must not paint the quad interior for {background:?}"
            );
        }
        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn cached_filter_bindings_accept_frame_local_dynamic_offsets() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let size = Size {
            width: DevicePixels(4),
            height: DevicePixels(4),
        };
        let mut renderer = WgpuRenderer::new_headless(&context, size)?;
        let bounds = Bounds {
            origin: Point {
                x: ScaledPixels(0.0),
                y: ScaledPixels(0.0),
            },
            size: Size {
                width: ScaledPixels(4.0),
                height: ScaledPixels(4.0),
            },
        };
        let mut scene = Scene::default();
        scene.insert_primitive(BackdropFilter {
            bounds,
            content_mask: gpui::ContentMask {
                bounds,
                ..Default::default()
            },
            filters: smallvec::smallvec![gpui::ScaledFilter::Blur(ScaledPixels(1.0))],
            opacity: 1.0,
            ..BackdropFilter::default()
        });
        scene.finish();

        renderer.render_to_image(&scene)?;
        renderer.render_to_image(&scene)?;
        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn odd_sized_blur_preserves_edge_symmetry() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let size = Size {
            width: DevicePixels(5),
            height: DevicePixels(5),
        };
        let mut renderer = WgpuRenderer::new_headless(&context, size)?;
        let full_bounds = Bounds {
            origin: Point {
                x: ScaledPixels(0.0),
                y: ScaledPixels(0.0),
            },
            size: Size {
                width: ScaledPixels(5.0),
                height: ScaledPixels(5.0),
            },
        };
        let center_bounds = Bounds {
            origin: Point {
                x: ScaledPixels(2.0),
                y: ScaledPixels(2.0),
            },
            size: Size {
                width: ScaledPixels(1.0),
                height: ScaledPixels(1.0),
            },
        };
        let mut scene = Scene::default();
        scene.insert_primitive(Quad {
            order: 0,
            bounds: full_bounds,
            content_mask: gpui::ContentMask {
                bounds: full_bounds,
                ..Default::default()
            },
            background: gpui::solid_background(gpui::hsla(0.0, 0.0, 0.0, 1.0)),
            ..Default::default()
        });
        scene.insert_primitive(Quad {
            order: 1,
            bounds: center_bounds,
            content_mask: gpui::ContentMask {
                bounds: center_bounds,
                ..Default::default()
            },
            background: gpui::solid_background(gpui::hsla(0.0, 0.0, 1.0, 1.0)),
            ..Default::default()
        });
        scene.insert_primitive(BackdropFilter {
            order: 2,
            bounds: full_bounds,
            content_mask: gpui::ContentMask {
                bounds: full_bounds,
                ..Default::default()
            },
            filters: smallvec::smallvec![gpui::ScaledFilter::Blur(ScaledPixels(2.0))],
            opacity: 1.0,
            ..Default::default()
        });
        scene.finish();

        let image = renderer.render_to_image(&scene)?;
        for y in 0..5 {
            for x in 0..5 {
                let actual = image.get_pixel(x, y).0;
                let horizontal = image.get_pixel(4 - x, y).0;
                let vertical = image.get_pixel(x, 4 - y).0;
                for channel in 0..4 {
                    assert!(
                        actual[channel].abs_diff(horizontal[channel]) <= 1,
                        "horizontal blur asymmetry at ({x}, {y}), channel {channel}: {actual:?} vs {horizontal:?}"
                    );
                    assert!(
                        actual[channel].abs_diff(vertical[channel]) <= 1,
                        "vertical blur asymmetry at ({x}, {y}), channel {channel}: {actual:?} vs {vertical:?}"
                    );
                }
            }
        }
        assert!(
            image.get_pixel(1, 2).0[0] > 0,
            "blur must spread from the center pixel"
        );
        Ok(())
    }

    #[cfg(all(feature = "test-support", not(target_family = "wasm")))]
    #[test]
    fn alternating_instance_batches_fit_the_exact_upload_arena() -> anyhow::Result<()> {
        let context = WgpuContext::new_headless(None)?;
        let size = Size {
            width: DevicePixels(1),
            height: DevicePixels(1),
        };
        let mut renderer = WgpuRenderer::new_headless(&context, size)?;
        let bounds = Bounds {
            origin: Point {
                x: ScaledPixels(0.0),
                y: ScaledPixels(0.0),
            },
            size: Size {
                width: ScaledPixels(1.0),
                height: ScaledPixels(1.0),
            },
        };
        let mut scene = Scene::default();
        for index in 0..512 {
            scene.insert_primitive(Quad {
                order: index * 2,
                bounds,
                content_mask: gpui::ContentMask {
                    bounds,
                    ..Default::default()
                },
                background: gpui::solid_background(gpui::hsla(0.0, 0.0, 0.0, 1.0)),
                ..Default::default()
            });
            scene.insert_primitive(Underline {
                order: index * 2 + 1,
                padding: 0,
                bounds,
                content_mask: gpui::ContentMask {
                    bounds,
                    ..Default::default()
                },
                color: gpui::hsla(0.0, 0.0, 1.0, 1.0).into(),
                thickness: ScaledPixels(1.0),
                wavy: false.into(),
            });
        }
        scene.finish();
        assert_eq!(
            scene
                .render_commands()
                .iter()
                .filter(|command| matches!(command, gpui::RenderCommand::Batch(_)))
                .count(),
            1024
        );

        renderer.render_to_image(&scene)?;
        Ok(())
    }

    #[test]
    fn webgl_quad_layout_matches_fixed_decoder() {
        let quad = Quad {
            order: 41,
            border_style: BorderStyle::Dashed,
            bounds: Bounds {
                origin: Point {
                    x: 1.0.into(),
                    y: 2.0.into(),
                },
                size: Size {
                    width: 3.0.into(),
                    height: 4.0.into(),
                },
            },
            content_mask: ContentMask {
                bounds: Bounds {
                    origin: Point {
                        x: 5.0.into(),
                        y: 6.0.into(),
                    },
                    size: Size {
                        width: 7.0.into(),
                        height: 8.0.into(),
                    },
                },
            },
            background: linear_gradient(
                11.0,
                linear_color_stop(
                    Hsla {
                        h: 12.0,
                        s: 13.0,
                        l: 14.0,
                        a: 15.0,
                    },
                    16.0,
                ),
                linear_color_stop(
                    Hsla {
                        h: 17.0,
                        s: 18.0,
                        l: 19.0,
                        a: 20.0,
                    },
                    21.0,
                ),
            )
            .color_space(ColorSpace::Oklab),
            border_color: Hsla {
                h: 22.0,
                s: 23.0,
                l: 24.0,
                a: 25.0,
            },
            corner_radii: Corners {
                top_left: 26.0.into(),
                top_right: 27.0.into(),
                bottom_right: 28.0.into(),
                bottom_left: 29.0.into(),
            },
            border_widths: Edges {
                top: 30.0.into(),
                right: 31.0.into(),
                bottom: 32.0.into(),
                left: 33.0.into(),
            },
        };

        let bytes = unsafe { WgpuRendererCore::instance_bytes(std::slice::from_ref(&quad)) };
        let words: &[u32] = bytemuck::cast_slice(bytes);
        assert_eq!(
            words,
            &[
                41,
                1,
                1.0_f32.to_bits(),
                2.0_f32.to_bits(),
                3.0_f32.to_bits(),
                4.0_f32.to_bits(),
                5.0_f32.to_bits(),
                6.0_f32.to_bits(),
                7.0_f32.to_bits(),
                8.0_f32.to_bits(),
                1,
                1,
                0,
                0,
                0,
                0,
                11.0_f32.to_bits(),
                12.0_f32.to_bits(),
                13.0_f32.to_bits(),
                14.0_f32.to_bits(),
                15.0_f32.to_bits(),
                16.0_f32.to_bits(),
                17.0_f32.to_bits(),
                18.0_f32.to_bits(),
                19.0_f32.to_bits(),
                20.0_f32.to_bits(),
                21.0_f32.to_bits(),
                0,
                22.0_f32.to_bits(),
                23.0_f32.to_bits(),
                24.0_f32.to_bits(),
                25.0_f32.to_bits(),
                26.0_f32.to_bits(),
                27.0_f32.to_bits(),
                28.0_f32.to_bits(),
                29.0_f32.to_bits(),
                30.0_f32.to_bits(),
                31.0_f32.to_bits(),
                32.0_f32.to_bits(),
                33.0_f32.to_bits(),
            ]
        );
    }
}
