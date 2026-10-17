use crate::metal_atlas::MetalAtlas;
<<<<<<< HEAD
use anyhow::Result;
use block::ConcreteBlock;
use core_graphics::geometry::CGSize;
use gpui::{
    AtlasTextureId, Bounds, Corners, DevicePixels, FilterRenderTarget, MAX_FILTER_GROUP_DEPTH,
    MonochromeSprite, PaintSurface, Path, PolychromeSprite, PrimitiveBatch, Quad, RenderCommand,
    ScaledPixels, Scene, Shadow, Size, SurfaceSource, Underline, size,
};
use gpui_render::{
    artifacts::{NATIVE_SHADERS, NativeShader},
    blur::{
        BlurAxis, BlurKernel, BlurUniforms, GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS, ScissorRectangle,
        downsampled_dimension,
    },
    path_types::{self, PathRasterizationVertex},
    shaders::{
        common::{FontRasterizationUniforms, GlobalUniforms, ShaderBool, SurfaceColorFormat},
        surface::SurfaceUniforms,
    },
};
#[cfg(any(test, feature = "bench-support", feature = "test-support"))]
use image::RgbaImage;

use core_foundation::base::TCFType;
use core_video::{
    metal_texture::CVMetalTextureGetTexture, metal_texture_cache::CVMetalTextureCache,
    pixel_buffer::kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
};
use foreign_types::{ForeignType, ForeignTypeRef};
use metal::{
    CAMetalLayer, CommandQueue, MTLGPUFamily, MTLPixelFormat, MTLResourceOptions, MTLScissorRect,
    NSRange, NSUInteger, RenderPassColorAttachmentDescriptorRef, SamplerDescriptor,
};
use objc2_quartz_core::{CAAutoresizingMask, CAMetalLayer as Objc2CAMetalLayer};
use parking_lot::Mutex;
use smallvec::SmallVec;
use wgsl_rs::std::{vec2f, vec4f};

use std::{cell::Cell, mem, ptr, sync::Arc};

// Use 4x MSAA, all devices support it.
// https://developer.apple.com/documentation/metal/mtldevice/1433355-supportstexturesamplecount
const PATH_SAMPLE_COUNT: u32 = 4;

// Buffer slots declared by the generated MSL. Group 0 globals land at 0/1, the group 1 data
// binding at 2, Naga's runtime-array sizes buffer at 3.
const GLOBALS_SLOT: u64 = 0;
const FONT_SLOT: u64 = 1;
const DATA_SLOT: u64 = 2;
const SIZES_SLOT: u64 = 3;
const PRIMARY_TEXTURE_SLOT: u64 = 0;
const SECONDARY_TEXTURE_SLOT: u64 = 1;
const SAMPLER_SLOT: u64 = 0;
=======
use anyhow::{Context as _, Result};
use block2::RcBlock;
use core_graphics::geometry::CGSize;
use gpui::{
    AtlasTextureId, Background, Bounds, ContentMask, DevicePixels, PaintSurface, Path, Point,
    PrimitiveBatch, ScaledPixels, Scene, Size, point, size,
};
#[cfg(any(test, feature = "bench-support", feature = "test-support"))]
use image::RgbaImage;
use objc2::runtime::AnyObject;

use core_graphics::color_space::{CGColorSpace, kCGColorSpaceDisplayP3};
use foreign_types::{ForeignType, ForeignTypeRef};
use metal::{
    CAMetalLayer, CommandQueue, MTLGPUFamily, MTLPixelFormat, MTLResourceOptions, NSRange,
    NSUInteger,
};
use objc2_core_foundation::CFRetained;
use objc2_core_video::{
    CVMetalTexture, CVMetalTextureCache, CVMetalTextureGetTexture, CVPixelBufferGetHeight,
    CVPixelBufferGetHeightOfPlane, CVPixelBufferGetPixelFormatType, CVPixelBufferGetWidth,
    CVPixelBufferGetWidthOfPlane, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, kCVReturnSuccess,
};
use parking_lot::Mutex;

use std::{cell::Cell, ffi::c_void, mem, mem::MaybeUninit, ops::Range, ptr, slice, sync::Arc};

// Exported to metal
pub(crate) type PointF = gpui::Point<f32>;

#[cfg(not(feature = "runtime_shaders"))]
const SHADERS_METALLIB: &[u8] = include_bytes!(concat!(env!("OUT_DIR"), "/shaders.metallib"));
#[cfg(feature = "runtime_shaders")]
const SHADERS_SOURCE_FILE: &str = include_str!(concat!(env!("OUT_DIR"), "/stitched_shaders.metal"));
// Use 4x MSAA, all devices support it.
// https://developer.apple.com/documentation/metal/mtldevice/1433355-supportstexturesamplecount
const PATH_SAMPLE_COUNT: u32 = 4;
/// Metal requires the offset a buffer is bound at to be 256-byte aligned.
const INSTANCE_BUFFER_ALIGNMENT: usize = 256;
const MAX_INSTANCE_BUFFER_SIZE: usize = 256 * 1024 * 1024;
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

pub type Context = Arc<Mutex<InstanceBufferPool>>;
pub type Renderer = MetalRenderer;

<<<<<<< HEAD
/// Per-frame global uniforms bound by every pipeline.
struct SceneUniforms {
    globals: GlobalUniforms,
    font: FontRasterizationUniforms,
}

impl SceneUniforms {
    fn new(viewport_size: Size<DevicePixels>) -> Self {
        Self {
            globals: GlobalUniforms {
                viewport_size: vec2f(
                    i32::from(viewport_size.width) as f32,
                    i32::from(viewport_size.height) as f32,
                ),
                // Metal composites straight-alpha; paths premultiply in-shader, matching
                // the neutral (disabled) shader behavior.
                premultiplied_alpha: ShaderBool::Disabled,
                padding: 0,
            },
            // Metal text is gamma-corrected grayscale; font corrections stay neutral.
            font: FontRasterizationUniforms {
                gamma_ratios: vec4f(0.0, 0.0, 0.0, 0.0),
                grayscale_enhanced_contrast: 0.0,
                subpixel_enhanced_contrast: 0.0,
                uses_blue_green_red_subpixel_order: ShaderBool::Disabled,
                padding: 0,
            },
        }
    }
}

fn native_shader(label: &str) -> &'static NativeShader {
    NATIVE_SHADERS
        .iter()
        .find(|shader| shader.label == label)
        .unwrap_or_else(|| panic!("missing generated native shader {label}"))
}

fn bind_scene_uniforms(encoder: &metal::RenderCommandEncoderRef, uniforms: &SceneUniforms) {
    encoder.set_vertex_bytes(
        GLOBALS_SLOT,
        mem::size_of::<GlobalUniforms>() as u64,
        &uniforms.globals as *const GlobalUniforms as *const _,
    );
    encoder.set_fragment_bytes(
        GLOBALS_SLOT,
        mem::size_of::<GlobalUniforms>() as u64,
        &uniforms.globals as *const GlobalUniforms as *const _,
    );
    encoder.set_vertex_bytes(
        FONT_SLOT,
        mem::size_of::<FontRasterizationUniforms>() as u64,
        &uniforms.font as *const FontRasterizationUniforms as *const _,
    );
    encoder.set_fragment_bytes(
        FONT_SLOT,
        mem::size_of::<FontRasterizationUniforms>() as u64,
        &uniforms.font as *const FontRasterizationUniforms as *const _,
    );
}

/// Binds an instance slice and the byte length used by Naga's runtime-array size ABI.
fn bind_instances<T>(
    encoder: &metal::RenderCommandEncoderRef,
    buffer: &metal::BufferRef,
    offset: usize,
    instances: &[T],
) {
    bind_instance_bytes(encoder, buffer, offset, mem::size_of_val(instances));
}

fn bind_instance_bytes(
    encoder: &metal::RenderCommandEncoderRef,
    buffer: &metal::BufferRef,
    offset: usize,
    byte_len: usize,
) {
    let byte_len = u32::try_from(byte_len).expect("Metal instance binding exceeds 4 GiB");
    encoder.set_vertex_buffer(DATA_SLOT, Some(buffer), offset as u64);
    encoder.set_fragment_buffer(DATA_SLOT, Some(buffer), offset as u64);
    encoder.set_vertex_bytes(SIZES_SLOT, 4, &byte_len as *const u32 as *const _);
    encoder.set_fragment_bytes(SIZES_SLOT, 4, &byte_len as *const u32 as *const _);
}

/// Creates the CAMetalLayer that backs a window's view. The renderer drawing
/// into it sets its device and pixel format.
pub fn new_window_layer(transparent: bool) -> metal::MetalLayer {
    let layer = metal::MetalLayer::new();
    // Support direct-to-display rendering if the window is not transparent
    // https://developer.apple.com/documentation/metal/managing-your-game-window-for-metal-in-macos
    layer.set_opaque(!transparent);
    // `metal::MetalLayer` is a CAMetalLayer retained by the Metal crate.
    // Reborrow its Objective-C object as the generated objc2 class to keep
    // selector encodings and the autoresizing mask type checked here.
    let layer_object = unsafe { &*(layer.as_ptr() as *const Objc2CAMetalLayer) };
    layer_object.setAllowsNextDrawableTimeout(false);
    layer_object.setNeedsDisplayOnBoundsChange(true);
    layer_object.setAutoresizingMask(
        CAAutoresizingMask::LayerWidthSizable | CAAutoresizingMask::LayerHeightSizable,
    );
    layer
}

pub fn new_renderer(
    context: self::Context,
    _bounds: gpui::Size<f32>,
    transparent: bool,
) -> Result<Renderer> {
    Ok(MetalRenderer::new(context, transparent))
=======
pub unsafe fn new_renderer(
    context: self::Context,
    _native_window: *mut c_void,
    _native_view: *mut c_void,
    _bounds: gpui::Size<f32>,
    transparent: bool,
    use_display_p3: bool,
) -> Renderer {
    MetalRenderer::new(context, transparent, use_display_p3)
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
}

pub struct InstanceBufferPool {
    buffer_size: usize,
    buffers: Vec<metal::Buffer>,
}

impl Default for InstanceBufferPool {
    fn default() -> Self {
        Self {
            buffer_size: 2 * 1024 * 1024,
            buffers: Vec::new(),
        }
    }
}

pub(crate) struct InstanceBuffer {
    metal_buffer: metal::Buffer,
    size: usize,
}

impl InstanceBufferPool {
    pub(crate) fn reset(&mut self, buffer_size: usize) {
        self.buffer_size = buffer_size;
        self.buffers.clear();
    }

    pub(crate) fn acquire(
        &mut self,
        device: &metal::Device,
        unified_memory: bool,
<<<<<<< HEAD
        minimum_size: usize,
    ) -> InstanceBuffer {
        if minimum_size > self.buffer_size {
            self.reset(
                minimum_size
                    .checked_next_power_of_two()
                    .unwrap_or(minimum_size),
            );
        }
=======
    ) -> InstanceBuffer {
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        let buffer = self.buffers.pop().unwrap_or_else(|| {
            let options = if unified_memory {
                MTLResourceOptions::StorageModeShared
                    // Buffers are write only which can benefit from the combined cache
                    // https://developer.apple.com/documentation/metal/mtlresourceoptions/cpucachemodewritecombined
                    | MTLResourceOptions::CPUCacheModeWriteCombined
            } else {
                MTLResourceOptions::StorageModeManaged
            };

            device.new_buffer(self.buffer_size as u64, options)
        });
        InstanceBuffer {
            metal_buffer: buffer,
            size: self.buffer_size,
        }
    }

    pub(crate) fn release(&mut self, buffer: InstanceBuffer) {
        if buffer.size == self.buffer_size {
            self.buffers.push(buffer.metal_buffer)
        }
    }
}

pub struct MetalRenderer {
    device: metal::Device,
    layer: Option<metal::MetalLayer>,
    is_apple_gpu: bool,
    is_unified_memory: bool,
    presents_with_transaction: bool,
    /// For headless rendering, tracks whether output should be opaque
    opaque: bool,
    command_queue: CommandQueue,
    paths_rasterization_pipeline_state: metal::RenderPipelineState,
    path_sprites_pipeline_state: metal::RenderPipelineState,
    shadows_pipeline_state: metal::RenderPipelineState,
<<<<<<< HEAD
    smoothed_shadows_pipeline_state: metal::RenderPipelineState,
    quads_pipeline_state: metal::RenderPipelineState,
    smoothed_quads_pipeline_state: metal::RenderPipelineState,
    underlines_pipeline_state: metal::RenderPipelineState,
    monochrome_sprites_pipeline_state: metal::RenderPipelineState,
    polychrome_sprites_pipeline_state: metal::RenderPipelineState,
    smoothed_polychrome_sprites_pipeline_state: metal::RenderPipelineState,
    surfaces_pipeline_state: metal::RenderPipelineState,
    // Blur pipelines: downsample (no blend, also used for the final blit), separable gaussian
    // (no blend), and composite (alpha blend into a rounded rect), from shared shader sources.
    blur_downsample_pipeline_state: metal::RenderPipelineState,
    blur_pipeline_state: metal::RenderPipelineState,
    blur_composite_pipeline_state: metal::RenderPipelineState,
    smoothed_blur_composite_pipeline_state: metal::RenderPipelineState,
    sampler: metal::SamplerState,
    #[allow(clippy::arc_with_non_send_sync)]
    instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>,
    sprite_atlas: Arc<MetalAtlas>,
    core_video_texture_cache: core_video::metal_texture_cache::CVMetalTextureCache,
    path_intermediate_texture: Option<metal::Texture>,
    path_intermediate_msaa_texture: Option<metal::Texture>,
    // Offscreen scene target (the scene is rendered here, then blitted to the drawable, so blur
    // passes can sample already-painted content), the half-res ping/pong blur targets, and a
    // full-res target for content-filter groups.
    scene_color_texture: Option<metal::Texture>,
    blur_ping_texture: Option<metal::Texture>,
    blur_pong_texture: Option<metal::Texture>,
    /// Full-resolution offscreen targets a content-filter (`filter`) group renders into before
    /// being blurred and composited back. One per nesting level (indexed by isolation depth) so
    /// nested content blurs isolate consistently with [`MAX_FILTER_GROUP_DEPTH`]; deeper nests render
    /// inline.
    group_textures: Vec<metal::Texture>,
    intermediate_texture_size: Option<Size<DevicePixels>>,
=======
    quads_pipeline_state: metal::RenderPipelineState,
    underlines_pipeline_state: metal::RenderPipelineState,
    monochrome_sprites_pipeline_state: metal::RenderPipelineState,
    polychrome_sprites_pipeline_state: metal::RenderPipelineState,
    surfaces_pipeline_state: metal::RenderPipelineState,
    unit_vertices: metal::Buffer,
    #[allow(clippy::arc_with_non_send_sync)]
    instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>,
    sprite_atlas: Arc<MetalAtlas>,
    core_video_texture_cache: CFRetained<CVMetalTextureCache>,
    path_intermediate_texture: Option<metal::Texture>,
    path_intermediate_msaa_texture: Option<metal::Texture>,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    path_sample_count: u32,
    /// Offscreen render target reused across `render_scene` calls when
    /// rendering headlessly without reading pixels back.
    #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
    headless_render_target: Option<metal::Texture>,
}

<<<<<<< HEAD
impl MetalRenderer {
    /// Creates a new MetalRenderer with a CAMetalLayer for window-based rendering.
    pub fn new(instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>, transparent: bool) -> Self {
        let device = Self::create_device();

        let layer = new_window_layer(transparent);
        layer.set_device(&device);
        layer.set_pixel_format(MTLPixelFormat::BGRA8Unorm);
        layer.set_maximum_drawable_count(3);
        // Allow texture reading for visual tests (captures screenshots without ScreenCaptureKit)
        #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
        layer.set_framebuffer_only(false);

        Self::new_internal(device, Some(layer), !transparent, instance_buffer_pool)
    }

=======
#[repr(C)]
pub struct PathRasterizationVertex {
    pub xy_position: Point<ScaledPixels>,
    pub st_position: Point<f32>,
    pub color: Background,
    pub bounds: Bounds<ScaledPixels>,
}

impl MetalRenderer {
    /// Creates a new MetalRenderer with a CAMetalLayer for window-based rendering.
    pub fn new(
        instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>,
        transparent: bool,
        use_display_p3: bool,
    ) -> Self {
        let device = Self::create_device();
        let layer = metal::MetalLayer::new();
        Self::configure_layer(&layer, &device, transparent, use_display_p3);
        Self::new_internal(device, Some(layer), !transparent, instance_buffer_pool)
    }

    /// Creates a renderer for a CAMetalLayer owned by a platform view, such as
    /// the backing layer UIKit creates for a view whose `layerClass` is
    /// `CAMetalLayer`. The renderer retains the layer.
    pub fn from_layer(
        instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>,
        layer: &objc2_quartz_core::CAMetalLayer,
        transparent: bool,
    ) -> Self {
        let device = Self::create_device();
        // Both types bind the same Objective-C class, so this only changes which
        // Rust wrapper views the live layer. `to_owned` retains it.
        let layer = unsafe {
            metal::MetalLayerRef::from_ptr(ptr::from_ref(layer).cast_mut().cast::<CAMetalLayer>())
        }
        .to_owned();
        Self::configure_layer(&layer, &device, transparent, false);
        Self::new_internal(device, Some(layer), !transparent, instance_buffer_pool)
    }

    fn configure_layer(
        layer: &metal::MetalLayerRef,
        device: &metal::DeviceRef,
        transparent: bool,
        use_display_p3: bool,
    ) {
        layer.set_device(device);
        layer.set_pixel_format(MTLPixelFormat::BGRA8Unorm);
        // metal-rs doesn't bind these setters, so view the same object through
        // objc2's typed CAMetalLayer binding.
        let objc2_layer: &objc2_quartz_core::CAMetalLayer = unsafe { &*layer.as_ptr().cast() };
        if use_display_p3 {
            // SAFETY: The constant is extern, from Core Graphics
            let display_p3_name = unsafe { kCGColorSpaceDisplayP3 };
            if let Some(display_p3_color_space) = CGColorSpace::create_with_name(display_p3_name) {
                // SAFETY: `layer` is a CAMetalLayer and the color space remains valid for the call.
                // 'metal-rs' does not expose CAMetalLayer's typed `colorspace` setter.
                // Could be replaced with a native binding via objc2-* in future
                unsafe {
                    let _: () = objc2::msg_send![
                        objc2_layer,
                        setColorspace: display_p3_color_space.as_ptr().cast::<c_void>()
                    ];
                }
            } else {
                log::error!("unable to create the Display P3 color space");
            }
        }
        // Support direct-to-display rendering if the window is not transparent
        // https://developer.apple.com/documentation/metal/managing-your-game-window-for-metal-in-macos
        layer.set_opaque(!transparent);
        layer.set_maximum_drawable_count(3);
        // Allow texture reading for visual tests and UI automation screenshots
        // (captures without ScreenCaptureKit). Only debug builds pay the
        // presentation cost, even when `test-support` is compiled in.
        #[cfg(all(feature = "test-support", debug_assertions))]
        layer.set_framebuffer_only(false);
        objc2_layer.setAllowsNextDrawableTimeout(false);
        objc2_layer.setNeedsDisplayOnBoundsChange(true);
        // UIKit sizes a view's backing layer itself; only AppKit-hosted
        // layers need to track their superlayer's bounds.
        #[cfg(target_os = "macos")]
        objc2_layer.setAutoresizingMask(
            objc2_quartz_core::CAAutoresizingMask::LayerWidthSizable
                | objc2_quartz_core::CAAutoresizingMask::LayerHeightSizable,
        );
    }

>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    /// Creates a new headless MetalRenderer for offscreen rendering without a window.
    ///
    /// This renderer can render scenes to images without requiring a CAMetalLayer,
    /// window, or AppKit. Use `render_scene_to_image()` to render scenes.
    #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
    pub fn new_headless(instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>) -> Self {
        let device = Self::create_device();
        Self::new_internal(device, None, true, instance_buffer_pool)
    }

<<<<<<< HEAD
=======
    #[cfg(target_os = "macos")]
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    fn create_device() -> metal::Device {
        // Prefer low‐power integrated GPUs on Intel Mac. On Apple
        // Silicon, there is only ever one GPU, so this is equivalent to
        // `metal::Device::system_default()`.
        if let Some(d) = metal::Device::all()
            .into_iter()
            .min_by_key(|d| (d.is_removable(), !d.is_low_power()))
        {
            d
        } else {
            // For some reason `all()` can return an empty list, see https://github.com/zed-industries/zed/issues/37689
            // In that case, we fall back to the system default device.
            log::error!(
                "Unable to enumerate Metal devices; attempting to use system default device"
            );
<<<<<<< HEAD
            metal::Device::system_default().unwrap_or_else(|| {
                log::error!("unable to access a compatible graphics device");
                std::process::exit(1);
            })
        }
    }

=======
            Self::system_default_device()
        }
    }

    #[cfg(target_os = "ios")]
    fn create_device() -> metal::Device {
        Self::system_default_device()
    }

    fn system_default_device() -> metal::Device {
        metal::Device::system_default().unwrap_or_else(|| {
            log::error!("unable to access a compatible graphics device");
            std::process::exit(1);
        })
    }

>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    fn new_internal(
        device: metal::Device,
        layer: Option<metal::MetalLayer>,
        opaque: bool,
        instance_buffer_pool: Arc<Mutex<InstanceBufferPool>>,
    ) -> Self {
<<<<<<< HEAD
        // Shared memory can be used only if CPU and GPU share the same memory space.
        // https://developer.apple.com/documentation/metal/setting-resource-storage-modes
        let is_unified_memory = device.has_unified_memory();
=======
        #[cfg(feature = "runtime_shaders")]
        let library = device
            .new_library_with_source(&SHADERS_SOURCE_FILE, &metal::CompileOptions::new())
            .expect("error building metal library");
        #[cfg(not(feature = "runtime_shaders"))]
        let library = device
            .new_library_with_data(SHADERS_METALLIB)
            .expect("error building metal library");

        fn to_float2_bits(point: PointF) -> u64 {
            let mut output = point.y.to_bits() as u64;
            output <<= 32;
            output |= point.x.to_bits() as u64;
            output
        }

        // Shared memory can be used only if CPU and GPU share the same memory space.
        // https://developer.apple.com/documentation/metal/setting-resource-storage-modes
        // iOS does not support managed resources. Its simulator may report a
        // non-unified host GPU even though resources must still use shared storage.
        let is_unified_memory = cfg!(target_os = "ios") || device.has_unified_memory();
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        // Apple GPU families support memoryless textures, which can significantly reduce
        // memory usage by keeping render targets in on-chip tile memory instead of
        // allocating backing store in system memory.
        // https://developer.apple.com/documentation/metal/mtlgpufamily
        let is_apple_gpu = device.supports_family(MTLGPUFamily::Apple1);

<<<<<<< HEAD
        // Compile the Naga-generated MSL with the device's runtime compiler, deduplicating
        // per source so each module compiles exactly once.
        let mut libraries: Vec<(&'static str, metal::Library)> = Vec::new();
        let mut library_for = |source: &'static str| -> metal::Library {
            if let Some((_, library)) = libraries
                .iter()
                .find(|(registered, _)| *registered == source)
            {
                return library.clone();
            }
            let library = device
                .new_library_with_source(source, &metal::CompileOptions::new())
                .unwrap_or_else(|error| panic!("error building metal library: {error}"));
            libraries.push((source, library.clone()));
            library
        };

        let mut pipeline = |label: &str| -> (&'static NativeShader, metal::Library) {
            let shader = native_shader(label);
            (shader, library_for(shader.msl))
        };

        let (path_rasterization_shader, path_rasterization_library) =
            pipeline("path_rasterization");
        let paths_rasterization_pipeline_state = build_path_rasterization_pipeline_state(
            &device,
            &path_rasterization_library,
            path_rasterization_shader,
            MTLPixelFormat::BGRA8Unorm,
            PATH_SAMPLE_COUNT,
        );
        let (paths_shader, paths_library) = pipeline("paths");
        let path_sprites_pipeline_state = build_path_sprite_pipeline_state(
            &device,
            &paths_library,
            paths_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (shadows_shader, shadows_library) = pipeline("shadows");
        let shadows_pipeline_state = build_pipeline_state(
            &device,
            &shadows_library,
            shadows_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (smoothed_shadows_shader, smoothed_shadows_library) = pipeline("smoothed_shadows");
        let smoothed_shadows_pipeline_state = build_pipeline_state(
            &device,
            &smoothed_shadows_library,
            smoothed_shadows_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (quads_shader, quads_library) = pipeline("quads");
        let quads_pipeline_state = build_pipeline_state(
            &device,
            &quads_library,
            quads_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (smoothed_quads_shader, smoothed_quads_library) = pipeline("smoothed_quads");
        let smoothed_quads_pipeline_state = build_pipeline_state(
            &device,
            &smoothed_quads_library,
            smoothed_quads_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (underlines_shader, underlines_library) = pipeline("underlines");
        let underlines_pipeline_state = build_pipeline_state(
            &device,
            &underlines_library,
            underlines_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (monochrome_shader, monochrome_library) = pipeline("monochrome_sprites");
        let monochrome_sprites_pipeline_state = build_pipeline_state(
            &device,
            &monochrome_library,
            monochrome_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (polychrome_shader, polychrome_library) = pipeline("polychrome_sprites");
        let polychrome_sprites_pipeline_state = build_pipeline_state(
            &device,
            &polychrome_library,
            polychrome_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (smoothed_polychrome_shader, smoothed_polychrome_library) =
            pipeline("smoothed_polychrome_sprites");
        let smoothed_polychrome_sprites_pipeline_state = build_pipeline_state(
            &device,
            &smoothed_polychrome_library,
            smoothed_polychrome_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (surfaces_shader, surfaces_library) = pipeline("surfaces");
        let surfaces_pipeline_state = build_pipeline_state(
            &device,
            &surfaces_library,
            surfaces_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (blur_downsample_shader, blur_downsample_library) = pipeline("blur_downsample");
        let blur_downsample_pipeline_state = build_blur_pipeline_state(
            &device,
            &blur_downsample_library,
            blur_downsample_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (blur_shader, blur_library) = pipeline("blur");
        let blur_pipeline_state = build_blur_pipeline_state(
            &device,
            &blur_library,
            blur_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        // Premultiplied blend (One / OneMinusSourceAlpha) — the composite outputs a premultiplied
        // blurred sample; straight-alpha blending would darken the faded edges.
        let (blur_composite_shader, blur_composite_library) = pipeline("blur_composite");
        let blur_composite_pipeline_state = build_path_sprite_pipeline_state(
            &device,
            &blur_composite_library,
            blur_composite_shader,
            MTLPixelFormat::BGRA8Unorm,
        );
        let (smoothed_blur_composite_shader, smoothed_blur_composite_library) =
            pipeline("smoothed_blur_composite");
        let smoothed_blur_composite_pipeline_state = build_path_sprite_pipeline_state(
            &device,
            &smoothed_blur_composite_library,
            smoothed_blur_composite_shader,
            MTLPixelFormat::BGRA8Unorm,
        );

        let sampler_descriptor = SamplerDescriptor::new();
        sampler_descriptor.set_min_filter(metal::MTLSamplerMinMagFilter::Linear);
        sampler_descriptor.set_mag_filter(metal::MTLSamplerMinMagFilter::Linear);
        let sampler = device.new_sampler(&sampler_descriptor);

        let command_queue = device.new_command_queue();
        let sprite_atlas = Arc::new(MetalAtlas::new(device.clone(), is_apple_gpu));
        let core_video_texture_cache =
            CVMetalTextureCache::new(None, device.clone(), None).unwrap();
=======
        let unit_vertices = [
            to_float2_bits(point(0., 0.)),
            to_float2_bits(point(1., 0.)),
            to_float2_bits(point(0., 1.)),
            to_float2_bits(point(0., 1.)),
            to_float2_bits(point(1., 0.)),
            to_float2_bits(point(1., 1.)),
        ];
        let unit_vertices = device.new_buffer_with_data(
            unit_vertices.as_ptr() as *const c_void,
            mem::size_of_val(&unit_vertices) as u64,
            if is_unified_memory {
                MTLResourceOptions::StorageModeShared
                    | MTLResourceOptions::CPUCacheModeWriteCombined
            } else {
                MTLResourceOptions::StorageModeManaged
            },
        );

        let paths_rasterization_pipeline_state = build_path_rasterization_pipeline_state(
            &device,
            &library,
            "paths_rasterization",
            "path_rasterization_vertex",
            "path_rasterization_fragment",
            MTLPixelFormat::BGRA8Unorm,
            PATH_SAMPLE_COUNT,
        );
        let path_sprites_pipeline_state = build_path_sprite_pipeline_state(
            &device,
            &library,
            "path_sprites",
            "path_sprite_vertex",
            "path_sprite_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );
        let shadows_pipeline_state = build_pipeline_state(
            &device,
            &library,
            "shadows",
            "shadow_vertex",
            "shadow_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );
        let quads_pipeline_state = build_pipeline_state(
            &device,
            &library,
            "quads",
            "quad_vertex",
            "quad_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );
        let underlines_pipeline_state = build_pipeline_state(
            &device,
            &library,
            "underlines",
            "underline_vertex",
            "underline_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );
        let monochrome_sprites_pipeline_state = build_pipeline_state(
            &device,
            &library,
            "monochrome_sprites",
            "monochrome_sprite_vertex",
            "monochrome_sprite_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );
        let polychrome_sprites_pipeline_state = build_pipeline_state(
            &device,
            &library,
            "polychrome_sprites",
            "polychrome_sprite_vertex",
            "polychrome_sprite_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );
        let surfaces_pipeline_state = build_pipeline_state(
            &device,
            &library,
            "surfaces",
            "surface_vertex",
            "surface_fragment",
            MTLPixelFormat::BGRA8Unorm,
        );

        let command_queue = device.new_command_queue();
        let supports_shared_storage = cfg!(target_os = "ios") || is_apple_gpu;
        let sprite_atlas = Arc::new(MetalAtlas::new(device.clone(), supports_shared_storage));
        // metal and objc2-metal expose the same Objective-C device; the borrowed
        // protocol object remains valid while `device` owns it.
        let core_video_texture_cache = unsafe {
            let mut cache = ptr::null_mut();
            let status = CVMetalTextureCache::create(
                None,
                None,
                &*device
                    .as_ptr()
                    .cast::<objc2::runtime::ProtocolObject<dyn objc2_metal::MTLDevice>>(),
                None,
                ptr::NonNull::from(&mut cache),
            );
            assert_eq!(
                status, kCVReturnSuccess,
                "failed to create CoreVideo Metal texture cache"
            );
            CFRetained::from_raw(ptr::NonNull::new(cache).expect("CoreVideo returned a null cache"))
        };
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

        Self {
            device,
            layer,
            presents_with_transaction: false,
            is_apple_gpu,
            is_unified_memory,
            opaque,
            command_queue,
            paths_rasterization_pipeline_state,
            path_sprites_pipeline_state,
            shadows_pipeline_state,
<<<<<<< HEAD
            smoothed_shadows_pipeline_state,
            quads_pipeline_state,
            smoothed_quads_pipeline_state,
            underlines_pipeline_state,
            monochrome_sprites_pipeline_state,
            polychrome_sprites_pipeline_state,
            smoothed_polychrome_sprites_pipeline_state,
            surfaces_pipeline_state,
            blur_downsample_pipeline_state,
            blur_pipeline_state,
            blur_composite_pipeline_state,
            smoothed_blur_composite_pipeline_state,
            sampler,
=======
            quads_pipeline_state,
            underlines_pipeline_state,
            monochrome_sprites_pipeline_state,
            polychrome_sprites_pipeline_state,
            surfaces_pipeline_state,
            unit_vertices,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
            instance_buffer_pool,
            sprite_atlas,
            core_video_texture_cache,
            path_intermediate_texture: None,
            path_intermediate_msaa_texture: None,
<<<<<<< HEAD
            scene_color_texture: None,
            blur_ping_texture: None,
            blur_pong_texture: None,
            group_textures: Vec::new(),
            intermediate_texture_size: None,
=======
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
            path_sample_count: PATH_SAMPLE_COUNT,
            #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
            headless_render_target: None,
        }
    }

    pub fn layer(&self) -> Option<&metal::MetalLayerRef> {
        self.layer.as_ref().map(|l| l.as_ref())
    }

    pub fn layer_ptr(&self) -> *mut CAMetalLayer {
        self.layer
            .as_ref()
            .map(|l| l.as_ptr())
            .unwrap_or(ptr::null_mut())
    }

    pub fn sprite_atlas(&self) -> &Arc<MetalAtlas> {
        &self.sprite_atlas
    }

    pub fn set_presents_with_transaction(&mut self, presents_with_transaction: bool) {
        self.presents_with_transaction = presents_with_transaction;
        if let Some(layer) = &self.layer {
            layer.set_presents_with_transaction(presents_with_transaction);
        }
    }

    pub fn update_drawable_size(&mut self, size: Size<DevicePixels>) {
        if let Some(layer) = &self.layer {
            layer.set_drawable_size(CGSize::new(size.width.0 as f64, size.height.0 as f64));
        }
<<<<<<< HEAD
        self.update_intermediate_texture_size(size);
    }

    fn update_intermediate_texture_size(&mut self, size: Size<DevicePixels>) {
        if self.intermediate_texture_size == Some(size) {
            return;
        }
        self.path_intermediate_texture = None;
        self.path_intermediate_msaa_texture = None;
        self.scene_color_texture = None;
        self.blur_ping_texture = None;
        self.blur_pong_texture = None;
        self.group_textures.clear();
        self.intermediate_texture_size = (size.width.0 > 0 && size.height.0 > 0).then_some(size);
    }

    fn prepare_intermediate_textures(&mut self, scene: &Scene, size: Size<DevicePixels>) {
        self.update_intermediate_texture_size(size);
        let Some(size) = self.intermediate_texture_size else {
            return;
        };
        let requirements = scene.render_plan().requirements();
        let full_w = size.width.0 as u64;
        let full_h = size.height.0 as u64;

        let make_color_texture = |width: u64, height: u64| {
            let descriptor = metal::TextureDescriptor::new();
            descriptor.set_width(width.max(1));
            descriptor.set_height(height.max(1));
            descriptor.set_pixel_format(metal::MTLPixelFormat::BGRA8Unorm);
            descriptor.set_storage_mode(metal::MTLStorageMode::Private);
            descriptor.set_usage(
                metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead,
            );
            self.device.new_texture(&descriptor)
        };

        if requirements.uses_path_target && self.path_intermediate_texture.is_none() {
            let texture_descriptor = metal::TextureDescriptor::new();
            texture_descriptor.set_width(full_w);
            texture_descriptor.set_height(full_h);
            texture_descriptor.set_pixel_format(metal::MTLPixelFormat::BGRA8Unorm);
            texture_descriptor.set_storage_mode(metal::MTLStorageMode::Private);
            texture_descriptor.set_usage(
                metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead,
            );
            self.path_intermediate_texture = Some(self.device.new_texture(&texture_descriptor));

            // Storage mode guidance:
            // https://developer.apple.com/documentation/metal/choosing-a-resource-storage-mode-for-apple-gpus
            // Rendering MSAA textures are done in a single pass, so we can use memory-less storage on Apple Silicon
            if self.path_sample_count > 1 {
                let storage_mode = if self.is_apple_gpu {
                    metal::MTLStorageMode::Memoryless
                } else {
                    metal::MTLStorageMode::Private
                };
                let msaa_descriptor = texture_descriptor;
                msaa_descriptor.set_texture_type(metal::MTLTextureType::D2Multisample);
                msaa_descriptor.set_storage_mode(storage_mode);
                msaa_descriptor.set_sample_count(self.path_sample_count as _);
                self.path_intermediate_msaa_texture =
                    Some(self.device.new_texture(&msaa_descriptor));
            }
        }

        if requirements.uses_offscreen_target {
            self.scene_color_texture
                .get_or_insert_with(|| make_color_texture(full_w, full_h));
            let blur_width = u64::from(downsampled_dimension(full_w as u32));
            let blur_height = u64::from(downsampled_dimension(full_h as u32));
            self.blur_ping_texture
                .get_or_insert_with(|| make_color_texture(blur_width, blur_height));
            self.blur_pong_texture
                .get_or_insert_with(|| make_color_texture(blur_width, blur_height));
            while self.group_textures.len() < requirements.isolated_target_count {
                self.group_textures.push(make_color_texture(full_w, full_h));
            }
=======
        self.update_path_intermediate_textures(size);
    }

    fn update_path_intermediate_textures(&mut self, size: Size<DevicePixels>) {
        // We are uncertain when this happens, but sometimes size can be 0 here. Most likely before
        // the layout pass on window creation. Zero-sized texture creation causes SIGABRT.
        // https://github.com/zed-industries/zed/issues/36229
        if size.width.0 <= 0 || size.height.0 <= 0 {
            self.path_intermediate_texture = None;
            self.path_intermediate_msaa_texture = None;
            return;
        }

        let texture_descriptor = metal::TextureDescriptor::new();
        texture_descriptor.set_width(size.width.0 as u64);
        texture_descriptor.set_height(size.height.0 as u64);
        texture_descriptor.set_pixel_format(metal::MTLPixelFormat::BGRA8Unorm);
        texture_descriptor.set_storage_mode(metal::MTLStorageMode::Private);
        texture_descriptor
            .set_usage(metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead);
        self.path_intermediate_texture = Some(self.device.new_texture(&texture_descriptor));

        if self.path_sample_count > 1 {
            // https://developer.apple.com/documentation/metal/choosing-a-resource-storage-mode-for-apple-gpus
            // Rendering MSAA textures are done in a single pass, so we can use memory-less storage on Apple Silicon
            let storage_mode = if self.is_apple_gpu {
                metal::MTLStorageMode::Memoryless
            } else {
                metal::MTLStorageMode::Private
            };

            let msaa_descriptor = texture_descriptor;
            msaa_descriptor.set_texture_type(metal::MTLTextureType::D2Multisample);
            msaa_descriptor.set_storage_mode(storage_mode);
            msaa_descriptor.set_sample_count(self.path_sample_count as _);
            self.path_intermediate_msaa_texture = Some(self.device.new_texture(&msaa_descriptor));
        } else {
            self.path_intermediate_msaa_texture = None;
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        }
    }

    pub fn update_transparency(&mut self, transparent: bool) {
        self.opaque = !transparent;
        if let Some(layer) = &self.layer {
            layer.set_opaque(!transparent);
        }
    }

    pub fn destroy(&self) {
        // nothing to do
    }

    pub fn draw(&mut self, scene: &Scene) {
        let layer = match &self.layer {
            Some(l) => l.clone(),
            None => {
                log::error!(
                    "draw() called on headless renderer - use render_scene_to_image() instead"
                );
                return;
            }
        };
        let viewport_size = layer.drawable_size();
        let viewport_size: Size<DevicePixels> = size(
            (viewport_size.width.ceil() as i32).into(),
            (viewport_size.height.ceil() as i32).into(),
        );
        let drawable = if let Some(drawable) = layer.next_drawable() {
            drawable
        } else {
            log::error!(
                "failed to retrieve next drawable, drawable size: {:?}",
                viewport_size
            );
            return;
        };

<<<<<<< HEAD
        let mut instance_buffer = self.acquire_instance_buffer(scene);
        let command_buffer =
            match self.draw_primitives(scene, &mut instance_buffer, drawable, viewport_size) {
                Ok(command_buffer) => command_buffer,
                Err(error) => {
                    log::error!("failed to render pre-sized scene: {error}");
                    return;
                }
            };
        self.release_instance_buffer_when_complete(&command_buffer, instance_buffer);
=======
        let command_buffer = match self.render_frame(scene, drawable.texture(), viewport_size) {
            Ok(command_buffer) => command_buffer,
            Err(error) => {
                log::error!("failed to render: {error:#}");
                return;
            }
        };
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

        if self.presents_with_transaction {
            command_buffer.commit();
            command_buffer.wait_until_scheduled();
            drawable.present();
        } else {
            command_buffer.present_drawable(drawable);
            command_buffer.commit();
        }
    }

<<<<<<< HEAD
=======
    fn render_frame(
        &mut self,
        scene: &Scene,
        texture: &metal::TextureRef,
        viewport_size: Size<DevicePixels>,
    ) -> Result<metal::CommandBuffer> {
        let mut writer = InstanceBufferWriter::new(
            &self.device,
            &self.instance_buffer_pool,
            self.is_unified_memory,
        );
        let instance_bindings = write_instances(scene, &mut writer).with_context(|| {
            format!(
                "scene too large: {} paths, {} shadows, {} quads, {} underlines, {} mono, {} poly, {} surfaces",
                scene.paths.len(),
                scene.shadows.len(),
                scene.quads.len(),
                scene.underlines.len(),
                scene.monochrome_sprites.len(),
                scene.polychrome_sprites.len(),
                scene.surfaces.len(),
            )
        })?;
        let command_buffer = self.draw_primitives_to_texture(
            scene,
            &instance_bindings,
            &mut writer,
            texture,
            viewport_size,
        )?;

        let instance_buffer_pool = self.instance_buffer_pool.clone();
        let instance_buffer = Cell::new(Some(writer.finish()));
        let block = RcBlock::new(move |_: ptr::NonNull<AnyObject>| {
            if let Some(instance_buffer) = instance_buffer.take() {
                instance_buffer_pool.lock().release(instance_buffer);
            }
        });
        // SAFETY: Both pointee types are opaque views of the same Objective-C block pointer ABI.
        unsafe {
            command_buffer.add_completed_handler(&*RcBlock::as_ptr(&block).cast());
        }

        Ok(command_buffer)
    }

>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    /// Renders the scene to a texture and returns the pixel data as an RGBA image.
    /// This does not present the frame to screen - useful for visual testing
    /// where we want to capture what would be rendered without displaying it.
    ///
    /// Note: This requires a layer-backed renderer. For headless rendering,
    /// use `render_scene_to_image()` instead.
<<<<<<< HEAD
    #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
=======
    #[cfg(any(test, feature = "test-support"))]
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    pub fn render_to_image(&mut self, scene: &Scene) -> Result<RgbaImage> {
        let layer = self
            .layer
            .clone()
            .ok_or_else(|| anyhow::anyhow!("render_to_image requires a layer-backed renderer"))?;
        let viewport_size = layer.drawable_size();
        let viewport_size: Size<DevicePixels> = size(
            (viewport_size.width.ceil() as i32).into(),
            (viewport_size.height.ceil() as i32).into(),
        );
        let drawable = layer
            .next_drawable()
            .ok_or_else(|| anyhow::anyhow!("Failed to get drawable for render_to_image"))?;

<<<<<<< HEAD
        let mut instance_buffer = self.acquire_instance_buffer(scene);
        let command_buffer =
            self.draw_primitives(scene, &mut instance_buffer, drawable, viewport_size)?;

        command_buffer.commit();
        command_buffer.wait_until_completed();
        self.instance_buffer_pool.lock().release(instance_buffer);

        let texture = drawable.texture();
        let width = texture.width() as u32;
        let height = texture.height() as u32;
        let bytes_per_row = width as usize * 4;
        let buffer_size = height as usize * bytes_per_row;
        let mut pixels = vec![0u8; buffer_size];
        let region = metal::MTLRegion {
            origin: metal::MTLOrigin { x: 0, y: 0, z: 0 },
            size: metal::MTLSize {
                width: width as u64,
                height: height as u64,
                depth: 1,
            },
        };
        texture.get_bytes(
            pixels.as_mut_ptr() as *mut std::ffi::c_void,
            bytes_per_row as u64,
            region,
            0,
        );
        for chunk in pixels.chunks_exact_mut(4) {
            chunk.swap(0, 2);
        }
        RgbaImage::from_raw(width, height, pixels)
            .ok_or_else(|| anyhow::anyhow!("Failed to create RgbaImage from pixel data"))
=======
        let command_buffer = self.render_frame(scene, drawable.texture(), viewport_size)?;

        // Commit and wait for completion without presenting
        command_buffer.commit();
        command_buffer.wait_until_completed();

        read_texture_to_image(drawable.texture())
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    /// Renders a scene to an image without requiring a window or CAMetalLayer.
    ///
    /// This is the primary method for headless rendering. It creates an offscreen
    /// texture, renders the scene to it, and returns the pixel data as an RGBA image.
    #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
    pub fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> Result<RgbaImage> {
        if size.width.0 <= 0 || size.height.0 <= 0 {
            anyhow::bail!("Invalid size for render_scene_to_image: {:?}", size);
        }

<<<<<<< HEAD
        // Create an offscreen texture as render target
        let texture_descriptor = metal::TextureDescriptor::new();
        texture_descriptor.set_width(size.width.0 as u64);
        texture_descriptor.set_height(size.height.0 as u64);
        texture_descriptor.set_pixel_format(MTLPixelFormat::BGRA8Unorm);
        texture_descriptor
            .set_usage(metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead);
        texture_descriptor.set_storage_mode(metal::MTLStorageMode::Managed);
        let target_texture = self.device.new_texture(&texture_descriptor);

        let mut instance_buffer = self.acquire_instance_buffer(scene);
        let command_buffer =
            self.draw_primitives_to_texture(scene, &mut instance_buffer, &target_texture, size)?;

        if !self.is_unified_memory {
            let blit = command_buffer.new_blit_command_encoder();
            blit.synchronize_resource(&target_texture);
            blit.end_encoding();
        }
        command_buffer.commit();
        command_buffer.wait_until_completed();
        self.instance_buffer_pool.lock().release(instance_buffer);

        let width = size.width.0 as u32;
        let height = size.height.0 as u32;
        let bytes_per_row = width as usize * 4;
        let buffer_size = height as usize * bytes_per_row;
        let mut pixels = vec![0u8; buffer_size];
        let region = metal::MTLRegion {
            origin: metal::MTLOrigin { x: 0, y: 0, z: 0 },
            size: metal::MTLSize {
                width: width as u64,
                height: height as u64,
                depth: 1,
            },
        };
        target_texture.get_bytes(
            pixels.as_mut_ptr() as *mut std::ffi::c_void,
            bytes_per_row as u64,
            region,
            0,
        );
        for chunk in pixels.chunks_exact_mut(4) {
            chunk.swap(0, 2);
        }
        RgbaImage::from_raw(width, height, pixels)
            .ok_or_else(|| anyhow::anyhow!("Failed to create RgbaImage from pixel data"))
=======
        // Headless callers do not have a Cocoa event-loop pool to release
        // autoreleased command buffers and render-pass descriptors.
        objc2::rc::autoreleasepool(|_| {
            // Update path intermediate textures for this size
            self.update_path_intermediate_textures(size);

            // Create an offscreen texture as render target
            let texture_descriptor = metal::TextureDescriptor::new();
            texture_descriptor.set_width(size.width.0 as u64);
            texture_descriptor.set_height(size.height.0 as u64);
            texture_descriptor.set_pixel_format(MTLPixelFormat::BGRA8Unorm);
            texture_descriptor.set_usage(
                metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead,
            );
            // Like the atlas, only Apple GPUs can create shared textures on macOS;
            // Intel Macs cannot, even with unified memory. iOS has no managed storage.
            let uses_shared_storage = cfg!(target_os = "ios") || self.is_apple_gpu;
            texture_descriptor.set_storage_mode(if uses_shared_storage {
                metal::MTLStorageMode::Shared
            } else {
                metal::MTLStorageMode::Managed
            });
            let target_texture = self.device.new_texture(&texture_descriptor);

            let command_buffer = self.render_frame(scene, &target_texture, size)?;

            // Managed textures require an explicit blit synchronize before the CPU
            // can read back the rendered data. Without this, get_bytes returns
            // stale zeros.
            if !uses_shared_storage {
                let blit = command_buffer.new_blit_command_encoder();
                blit.synchronize_resource(&target_texture);
                blit.end_encoding();
            }

            // Commit and wait for completion
            command_buffer.commit();
            command_buffer.wait_until_completed();

            read_texture_to_image(&target_texture)
        })
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    /// Renders a scene to a reused offscreen texture without reading pixels
    /// back or blocking on GPU completion.
    ///
    /// This mirrors the CPU cost of presenting a frame to a window (scene
    /// encoding, instance buffer writes, command submission) and is used by
    /// headless benchmark rendering, where the produced pixels are never
    /// inspected.
    #[cfg(any(test, feature = "bench-support", feature = "test-support"))]
    pub fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> Result<()> {
        if size.width.0 <= 0 || size.height.0 <= 0 {
            anyhow::bail!("Invalid size for render_scene: {:?}", size);
        }

<<<<<<< HEAD
        let needs_new_target = self.headless_render_target.as_ref().is_none_or(|texture| {
            texture.width() != size.width.0 as u64 || texture.height() != size.height.0 as u64
        });
        if needs_new_target {
            let texture_descriptor = metal::TextureDescriptor::new();
            texture_descriptor.set_width(size.width.0 as u64);
            texture_descriptor.set_height(size.height.0 as u64);
            texture_descriptor.set_pixel_format(MTLPixelFormat::BGRA8Unorm);
            texture_descriptor.set_usage(
                metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead,
            );
            texture_descriptor.set_storage_mode(metal::MTLStorageMode::Private);
            self.headless_render_target = Some(self.device.new_texture(&texture_descriptor));
        }
        let target_texture = self
            .headless_render_target
            .clone()
            .expect("just ensured the render target exists");

        let mut instance_buffer = self.acquire_instance_buffer(scene);
        let command_buffer =
            self.draw_primitives_to_texture(scene, &mut instance_buffer, &target_texture, size)?;
        self.release_instance_buffer_when_complete(&command_buffer, instance_buffer);
        command_buffer.commit();
        Ok(())
    }

    fn acquire_instance_buffer(&self, scene: &Scene) -> InstanceBuffer {
        self.instance_buffer_pool.lock().acquire(
            &self.device,
            self.is_unified_memory,
            required_instance_buffer_size(scene),
        )
    }

    fn release_instance_buffer_when_complete(
        &self,
        command_buffer: &metal::CommandBufferRef,
        instance_buffer: InstanceBuffer,
    ) {
        let instance_buffer_pool = self.instance_buffer_pool.clone();
        let instance_buffer = Cell::new(Some(instance_buffer));
        let block = ConcreteBlock::new(move |_| {
            if let Some(instance_buffer) = instance_buffer.take() {
                instance_buffer_pool.lock().release(instance_buffer);
            }
        });
        command_buffer.add_completed_handler(&block.copy());
    }

    fn draw_primitives(
        &mut self,
        scene: &Scene,
        instance_buffer: &mut InstanceBuffer,
        drawable: &metal::MetalDrawableRef,
        viewport_size: Size<DevicePixels>,
    ) -> Result<metal::CommandBuffer> {
        self.draw_primitives_to_texture(scene, instance_buffer, drawable.texture(), viewport_size)
=======
        objc2::rc::autoreleasepool(|_| {
            self.update_path_intermediate_textures(size);

            let needs_new_target = self.headless_render_target.as_ref().is_none_or(|texture| {
                texture.width() != size.width.0 as u64 || texture.height() != size.height.0 as u64
            });
            if needs_new_target {
                let texture_descriptor = metal::TextureDescriptor::new();
                texture_descriptor.set_width(size.width.0 as u64);
                texture_descriptor.set_height(size.height.0 as u64);
                texture_descriptor.set_pixel_format(MTLPixelFormat::BGRA8Unorm);
                texture_descriptor.set_usage(
                    metal::MTLTextureUsage::RenderTarget | metal::MTLTextureUsage::ShaderRead,
                );
                texture_descriptor.set_storage_mode(metal::MTLStorageMode::Private);
                self.headless_render_target = Some(self.device.new_texture(&texture_descriptor));
            }
            let target_texture = self
                .headless_render_target
                .clone()
                .expect("just ensured the render target exists");

            let command_buffer = self.render_frame(scene, &target_texture, size)?;

            // Commit without waiting, mirroring presentation to a real window where
            // the CPU doesn't block on the GPU.
            command_buffer.commit();
            Ok(())
        })
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_primitives_to_texture(
        &mut self,
        scene: &Scene,
<<<<<<< HEAD
        instance_buffer: &mut InstanceBuffer,
        texture: &metal::TextureRef,
        viewport_size: Size<DevicePixels>,
    ) -> Result<metal::CommandBuffer> {
        self.prepare_intermediate_textures(scene, viewport_size);
        let command_queue = self.command_queue.clone();
        let command_buffer = command_queue.new_command_buffer();
        let alpha = if self.opaque { 1. } else { 0. };
        let mut instance_offset = 0;
        let scene_uniforms = SceneUniforms::new(viewport_size);

        // Render the scene into an offscreen color texture (so filters can sample it), then
        // blit it to `texture`. Owned clones keep the textures borrowable without borrowing
        // `self` across the batch loop (which calls `&mut self` methods like `draw_surfaces`).
        // Only route through the offscreen scene texture when the scene actually contains blur
        // filters; otherwise render straight to `texture` exactly as before (no regression, no
        // extra blit for the common case).
        let use_offscreen = scene.requires_offscreen_rendering();
        let scene_color_owned = self.scene_color_texture.clone();
        let blur_ping_owned = self.blur_ping_texture.clone();
        let blur_pong_owned = self.blur_pong_texture.clone();
        let group_owned = self
            .group_textures
            .iter()
            .cloned()
            .collect::<SmallVec<[metal::Texture; MAX_FILTER_GROUP_DEPTH]>>();
        let scene_color: &metal::TextureRef = if use_offscreen {
            scene_color_owned.as_deref().unwrap_or(texture)
        } else {
            texture
        };
        // The active render target; switches to the group texture inside a content-filter group.
        let mut current_target: &metal::TextureRef = scene_color;
        let mut filter_stack = SmallVec::<[&metal::TextureRef; MAX_FILTER_GROUP_DEPTH]>::new();

        let mut command_encoder = new_command_encoder_for_texture(
            command_buffer,
            current_target,
            viewport_size,
            |color_attachment| {
                color_attachment.set_load_action(metal::MTLLoadAction::Clear);
                color_attachment.set_clear_color(metal::MTLClearColor::new(0., 0., 0., alpha));
            },
        );

        for command in scene.render_commands() {
            let ok = match command {
                RenderCommand::Batch(PrimitiveBatch::Shadows { range, smoothed }) => self
                    .draw_shadows(
                        &scene.shadows[range.clone()],
                        *smoothed,
                        instance_buffer,
                        &mut instance_offset,
                        &scene_uniforms,
                        command_encoder,
                    ),
                RenderCommand::Batch(PrimitiveBatch::Quads { range, smoothed }) => self.draw_quads(
                    &scene.quads[range.clone()],
                    *smoothed,
                    instance_buffer,
                    &mut instance_offset,
                    &scene_uniforms,
                    command_encoder,
                ),
                RenderCommand::Batch(PrimitiveBatch::Paths {
                    range,
                    rasterization_vertex_count,
                    sprite_count,
                }) => {
                    if *rasterization_vertex_count == 0 {
                        continue;
                    }
                    let paths = &scene.paths[range.clone()];
=======
        instance_bindings: &InstanceBindings,
        writer: &mut InstanceBufferWriter,
        texture: &metal::TextureRef,
        viewport_size: Size<DevicePixels>,
    ) -> Result<metal::CommandBuffer> {
        let command_queue = self.command_queue.clone();
        let command_buffer = command_queue.new_command_buffer();
        let alpha = if self.opaque { 1. } else { 0. };

        let mut command_encoder = new_command_encoder_for_texture(
            command_buffer,
            texture,
            viewport_size,
            Some(metal::MTLClearColor::new(0., 0., 0., alpha)),
        );

        for batch in scene.batches() {
            match batch {
                PrimitiveBatch::Shadows(range) => {
                    self.draw_shadows(range, instance_bindings, viewport_size, command_encoder)
                }
                PrimitiveBatch::Quads(range) => {
                    self.draw_quads(range, instance_bindings, viewport_size, command_encoder)
                }
                PrimitiveBatch::Paths(range) => {
                    let paths = &scene.paths[range];
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
                    command_encoder.end_encoding();

                    let did_draw = self.draw_paths_to_intermediate(
                        paths,
<<<<<<< HEAD
                        *rasterization_vertex_count,
                        instance_buffer,
                        &mut instance_offset,
                        &scene_uniforms,
                        command_buffer,
                    );

                    command_encoder = new_command_encoder_for_texture(
                        command_buffer,
                        current_target,
                        viewport_size,
                        |color_attachment| {
                            color_attachment.set_load_action(metal::MTLLoadAction::Load);
                        },
                    );

                    if did_draw {
                        self.draw_paths_from_intermediate(
                            paths,
                            *sprite_count,
                            instance_buffer,
                            &mut instance_offset,
                            &scene_uniforms,
                            command_encoder,
                        )
                    } else {
                        false
                    }
                }
                RenderCommand::Batch(PrimitiveBatch::Underlines(range)) => self.draw_underlines(
                    &scene.underlines[range.clone()],
                    instance_buffer,
                    &mut instance_offset,
                    &scene_uniforms,
                    command_encoder,
                ),
                RenderCommand::Batch(PrimitiveBatch::MonochromeSprites { texture_id, range }) => {
                    self.draw_monochrome_sprites(
                        *texture_id,
                        &scene.monochrome_sprites[range.clone()],
                        instance_buffer,
                        &mut instance_offset,
                        &scene_uniforms,
                        command_encoder,
                    )
                }
                RenderCommand::Batch(PrimitiveBatch::PolychromeSprites {
                    texture_id,
                    range,
                    smoothed,
                }) => self.draw_polychrome_sprites(
                    *texture_id,
                    &scene.polychrome_sprites[range.clone()],
                    *smoothed,
                    instance_buffer,
                    &mut instance_offset,
                    &scene_uniforms,
                    command_encoder,
                ),
                RenderCommand::Batch(PrimitiveBatch::Surfaces(range)) => self.draw_surfaces(
                    &scene.surfaces[range.clone()],
                    &scene.surface_opacities()[range.clone()],
                    &scene_uniforms,
                    command_encoder,
                ),
                RenderCommand::Batch(PrimitiveBatch::BackdropFilters(range)) => {
                    command_encoder.end_encoding();
                    if let (Some(ping), Some(pong)) =
                        (blur_ping_owned.as_deref(), blur_pong_owned.as_deref())
                    {
                        for filter in &scene.backdrop_filters[range.clone()] {
                            self.metal_blur_and_composite(
                                command_buffer,
                                &scene_uniforms,
                                current_target,
                                current_target,
                                ping,
                                pong,
                                viewport_size,
                                filter.bounds,
                                filter.content_mask.bounds,
                                filter.corner_radii,
                                filter.corner_smoothing,
                                filter.max_blur_radius(),
                                filter.opacity,
                                true,
                            );
                        }
                    }
                    command_encoder = new_command_encoder_for_texture(
                        command_buffer,
                        current_target,
                        viewport_size,
                        |color_attachment| {
                            color_attachment.set_load_action(metal::MTLLoadAction::Load);
                        },
                    );
                    true
                }
                RenderCommand::BeginFilter {
                    target: FilterRenderTarget::Isolated(target_index),
                    ..
                } => {
                    command_encoder.end_encoding();
                    filter_stack.push(current_target);
                    current_target = group_owned[target_index.as_usize()].as_ref();
                    command_encoder = new_command_encoder_for_texture(
                        command_buffer,
                        current_target,
                        viewport_size,
                        |color_attachment| {
                            color_attachment.set_load_action(metal::MTLLoadAction::Clear);
                            color_attachment
                                .set_clear_color(metal::MTLClearColor::new(0., 0., 0., 0.));
                        },
                    );
                    true
                }
                RenderCommand::EndFilter {
                    boundary_index,
                    target: FilterRenderTarget::Isolated(_),
                    ..
                } => {
                    let boundary = &scene.filter_boundaries[*boundary_index];
                    let parent = filter_stack
                        .pop()
                        .expect("render plan emitted an unmatched isolated filter end");
                    command_encoder.end_encoding();
                    if let (Some(ping), Some(pong)) =
                        (blur_ping_owned.as_deref(), blur_pong_owned.as_deref())
                    {
                        self.metal_blur_and_composite(
                            command_buffer,
                            &scene_uniforms,
                            current_target,
                            parent,
                            ping,
                            pong,
                            viewport_size,
                            boundary.bounds,
                            boundary.content_mask.bounds,
                            boundary.corner_radii,
                            boundary.corner_smoothing,
                            boundary.max_blur_radius(),
                            boundary.opacity,
                            false,
                        );
                    }
                    current_target = parent;
                    command_encoder = new_command_encoder_for_texture(
                        command_buffer,
                        current_target,
                        viewport_size,
                        |color_attachment| {
                            color_attachment.set_load_action(metal::MTLLoadAction::Load);
                        },
                    );
                    true
                }
                RenderCommand::BeginFilter {
                    target: FilterRenderTarget::Inline,
                    ..
                }
                | RenderCommand::EndFilter {
                    target: FilterRenderTarget::Inline,
                    ..
                } => true,
                RenderCommand::Batch(PrimitiveBatch::SubpixelSprites { .. }) => unreachable!(),
                RenderCommand::Batch(PrimitiveBatch::FilterBoundary(_)) => {
                    unreachable!("filter boundaries are resolved by the render plan")
                }
            };
            if !ok {
                command_encoder.end_encoding();
                anyhow::bail!(
                    "scene too large: {} paths, {} shadows, {} quads, {} underlines, {} mono, {} poly, {} surfaces",
                    scene.paths.len(),
                    scene.shadows.len(),
                    scene.quads.len(),
                    scene.underlines.len(),
                    scene.monochrome_sprites.len(),
                    scene.polychrome_sprites.len(),
                    scene.surfaces.len(),
                );
=======
                        writer,
                        viewport_size,
                        command_buffer,
                    )?;

                    command_encoder = new_command_encoder_for_texture(
                        command_buffer,
                        texture,
                        viewport_size,
                        None,
                    );

                    if did_draw {
                        if let Err(error) = self.draw_paths_from_intermediate(
                            paths,
                            writer,
                            viewport_size,
                            command_encoder,
                        ) {
                            command_encoder.end_encoding();
                            return Err(error);
                        }
                    }
                }
                PrimitiveBatch::Underlines(range) => {
                    self.draw_underlines(range, instance_bindings, viewport_size, command_encoder)
                }
                PrimitiveBatch::MonochromeSprites { texture_id, range } => self
                    .draw_monochrome_sprites(
                        texture_id,
                        range,
                        instance_bindings,
                        viewport_size,
                        command_encoder,
                    ),
                PrimitiveBatch::PolychromeSprites { texture_id, range } => self
                    .draw_polychrome_sprites(
                        texture_id,
                        range,
                        instance_bindings,
                        viewport_size,
                        command_encoder,
                    ),
                PrimitiveBatch::Surfaces(range) => self.draw_surfaces(
                    &scene.surfaces[range.clone()],
                    range.start,
                    instance_bindings,
                    viewport_size,
                    command_encoder,
                ),
                PrimitiveBatch::SubpixelSprites { .. } => unreachable!(),
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
            }
        }

        command_encoder.end_encoding();

<<<<<<< HEAD
        // Present the offscreen scene by copying it into the drawable/target texture.
        if use_offscreen && scene_color_owned.is_some() {
            self.run_metal_blur_pass(
                command_buffer,
                &self.blur_downsample_pipeline_state,
                texture,
                scene_color,
                viewport_size,
                &scene_uniforms,
                BlurUniforms::copy([
                    i32::from(viewport_size.width) as f32,
                    i32::from(viewport_size.height) as f32,
                ]),
                ScissorRectangle {
                    x: 0,
                    y: 0,
                    width: i32::from(viewport_size.width).max(0) as u32,
                    height: i32::from(viewport_size.height).max(0) as u32,
                },
                metal::MTLPrimitiveType::Triangle,
                3,
                false,
            );
        }

        if !self.is_unified_memory {
            // Sync the instance buffer to the GPU
            instance_buffer.metal_buffer.did_modify_range(NSRange {
                location: 0,
                length: instance_offset as NSUInteger,
            });
        }

        Ok(command_buffer.to_owned())
    }

    /// Run a single blur pass: draw a full-screen (or composite) quad sampling `source` into
    /// `target`. `params` is supplied to both shader stages; `load` keeps existing target
    /// contents (used by the composite), otherwise the target is cleared.
    #[allow(clippy::too_many_arguments)]
    fn run_metal_blur_pass(
        &self,
        command_buffer: &metal::CommandBufferRef,
        pipeline: &metal::RenderPipelineState,
        target: &metal::TextureRef,
        source: &metal::TextureRef,
        target_viewport: Size<DevicePixels>,
        scene_uniforms: &SceneUniforms,
        params: BlurUniforms,
        scissor: ScissorRectangle,
        primitive: metal::MTLPrimitiveType,
        vertex_count: u64,
        load: bool,
    ) {
        let encoder = new_command_encoder_for_texture(
            command_buffer,
            target,
            target_viewport,
            |color_attachment| {
                if load {
                    color_attachment.set_load_action(metal::MTLLoadAction::Load);
                } else {
                    color_attachment.set_load_action(metal::MTLLoadAction::Clear);
                    color_attachment.set_clear_color(metal::MTLClearColor::new(0., 0., 0., 0.));
                }
            },
        );
        encoder.set_scissor_rect(MTLScissorRect {
            x: scissor.x as u64,
            y: scissor.y as u64,
            width: scissor.width as u64,
            height: scissor.height as u64,
        });
        encoder.set_render_pipeline_state(pipeline);
        bind_scene_uniforms(encoder, scene_uniforms);
        encoder.set_vertex_bytes(
            DATA_SLOT,
            mem::size_of::<BlurUniforms>() as u64,
            &params as *const BlurUniforms as *const _,
        );
        encoder.set_fragment_bytes(
            DATA_SLOT,
            mem::size_of::<BlurUniforms>() as u64,
            &params as *const BlurUniforms as *const _,
        );
        encoder.set_fragment_texture(PRIMARY_TEXTURE_SLOT, Some(source));
        encoder.set_fragment_sampler_state(SAMPLER_SLOT, Some(&self.sampler));
        encoder.draw_primitives(primitive, 0, vertex_count);
        encoder.end_encoding();
    }

    /// Blur `source` (full-resolution) using the half-res ping/pong textures and composite the
    /// result into `target`, clipped to `bounds`/`corner_radii`/`content_mask` and modulated by
    /// `opacity`. Shared by the backdrop and content-filter paths, mirroring the wgpu
    /// backend's pass structure via the shared `gpui_render::blur` contracts.
    #[allow(clippy::too_many_arguments)]
    fn metal_blur_and_composite(
        &self,
        command_buffer: &metal::CommandBufferRef,
        scene_uniforms: &SceneUniforms,
        source: &metal::TextureRef,
        target: &metal::TextureRef,
        ping: &metal::TextureRef,
        pong: &metal::TextureRef,
        viewport_size: Size<DevicePixels>,
        bounds: Bounds<ScaledPixels>,
        content_mask: Bounds<ScaledPixels>,
        corner_radii: Corners<ScaledPixels>,
        corner_smoothing: f32,
        blur_radius: f32,
        opacity: f32,
        // Backdrop clips to the rounded rect; content (`filter`) bleeds past its bounds.
        clip_rounded: bool,
    ) {
        let Some(kernel) = BlurKernel::for_radius(blur_radius) else {
            return;
        };
        let full_width = i32::from(viewport_size.width).max(0) as u32;
        let full_height = i32::from(viewport_size.height).max(0) as u32;
        let blur_size = [
            downsampled_dimension(full_width) as f32,
            downsampled_dimension(full_height) as f32,
        ];
        let blur_viewport_size = Size {
            width: DevicePixels(blur_size[0] as i32),
            height: DevicePixels(blur_size[1] as i32),
        };
        let dilation = GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * blur_radius;
        let scissor =
            ScissorRectangle::for_blurred_bounds(bounds, dilation, full_width, full_height);
        if scissor.is_empty() {
            return;
        }
        let clip = if clip_rounded {
            gpui_render::blur::FilterCompositeClip::RoundedBounds
        } else {
            gpui_render::blur::FilterCompositeClip::ContentShape
        };

        // Downsample source -> ping, then separable gaussian ping -> pong -> ping.
        self.run_metal_blur_pass(
            command_buffer,
            &self.blur_downsample_pipeline_state,
            ping,
            source,
            blur_viewport_size,
            scene_uniforms,
            BlurUniforms::downsample([full_width as f32, full_height as f32], blur_size),
            scissor,
            metal::MTLPrimitiveType::Triangle,
            3,
            false,
        );
        self.run_metal_blur_pass(
            command_buffer,
            &self.blur_pipeline_state,
            pong,
            ping,
            blur_viewport_size,
            scene_uniforms,
            BlurUniforms::gaussian(BlurAxis::Horizontal, blur_size, kernel),
            scissor,
            metal::MTLPrimitiveType::Triangle,
            3,
            false,
        );
        self.run_metal_blur_pass(
            command_buffer,
            &self.blur_pipeline_state,
            ping,
            pong,
            blur_viewport_size,
            scene_uniforms,
            BlurUniforms::gaussian(BlurAxis::Vertical, blur_size, kernel),
            scissor,
            metal::MTLPrimitiveType::Triangle,
            3,
            false,
        );

        // Composite the blurred result into the target (preserving its contents).
        let composite_bounds = if clip_rounded {
            bounds
        } else {
            bounds.dilate(ScaledPixels(dilation))
        };
        let composite_uniforms = BlurUniforms::composite(
            composite_bounds,
            content_mask,
            corner_radii,
            corner_smoothing,
            opacity,
            clip,
            blur_size,
            [full_width as f32, full_height as f32],
        );
        let encoder = new_command_encoder_for_texture(
            command_buffer,
            target,
            viewport_size,
            |color_attachment| {
                color_attachment.set_load_action(metal::MTLLoadAction::Load);
            },
        );
        let pipeline = if composite_uniforms.corner_smoothing > 0.0 {
            &self.smoothed_blur_composite_pipeline_state
        } else {
            &self.blur_composite_pipeline_state
        };
        encoder.set_render_pipeline_state(pipeline);
        bind_scene_uniforms(encoder, scene_uniforms);
        encoder.set_vertex_bytes(
            DATA_SLOT,
            mem::size_of::<BlurUniforms>() as u64,
            &composite_uniforms as *const BlurUniforms as *const _,
        );
        encoder.set_fragment_bytes(
            DATA_SLOT,
            mem::size_of::<BlurUniforms>() as u64,
            &composite_uniforms as *const BlurUniforms as *const _,
        );
        encoder.set_fragment_texture(PRIMARY_TEXTURE_SLOT, Some(ping));
        encoder.set_fragment_sampler_state(SAMPLER_SLOT, Some(&self.sampler));
        encoder.draw_primitives(metal::MTLPrimitiveType::TriangleStrip, 0, 4);
        encoder.end_encoding();
    }

    fn draw_paths_to_intermediate(
        &self,
        paths: &[Path<ScaledPixels>],
        rasterization_vertex_count: usize,
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_buffer: &metal::CommandBufferRef,
    ) -> bool {
        if paths.is_empty() {
            return true;
        }
        let Some(intermediate_texture) = &self.path_intermediate_texture else {
            return false;
        };
=======
        Ok(command_buffer.to_owned())
    }

    fn draw_paths_to_intermediate(
        &self,
        paths: &[Path<ScaledPixels>],
        writer: &mut InstanceBufferWriter,
        viewport_size: Size<DevicePixels>,
        command_buffer: &metal::CommandBufferRef,
    ) -> Result<bool> {
        if paths.is_empty() {
            return Ok(false);
        }
        let intermediate_texture = self
            .path_intermediate_texture
            .as_ref()
            .context("missing path intermediate texture")?;

        let mut vertices = Vec::new();
        for path in paths {
            vertices.extend(path.vertices.iter().map(|v| PathRasterizationVertex {
                xy_position: v.xy_position,
                st_position: v.st_position,
                color: path.color,
                bounds: path.bounds.intersect(&path.content_mask.bounds),
            }));
        }
        let vertex_instance_bindings = writer.write(&vertices)?;
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

        let render_pass_descriptor = metal::RenderPassDescriptor::new();
        let color_attachment = render_pass_descriptor
            .color_attachments()
            .object_at(0)
            .unwrap();
        color_attachment.set_load_action(metal::MTLLoadAction::Clear);
        color_attachment.set_clear_color(metal::MTLClearColor::new(0., 0., 0., 0.));

        if let Some(msaa_texture) = &self.path_intermediate_msaa_texture {
            color_attachment.set_texture(Some(msaa_texture));
            color_attachment.set_resolve_texture(Some(intermediate_texture));
            color_attachment.set_store_action(metal::MTLStoreAction::MultisampleResolve);
        } else {
            color_attachment.set_texture(Some(intermediate_texture));
            color_attachment.set_store_action(metal::MTLStoreAction::Store);
        }

        let command_encoder = command_buffer.new_render_command_encoder(render_pass_descriptor);
        command_encoder.set_render_pipeline_state(&self.paths_rasterization_pipeline_state);
<<<<<<< HEAD
        bind_scene_uniforms(command_encoder, scene_uniforms);

        align_offset(instance_offset);
        let vertices_bytes_len =
            mem::size_of::<PathRasterizationVertex>() * rasterization_vertex_count;
        let next_offset = *instance_offset + vertices_bytes_len;
        if next_offset > instance_buffer.size {
            command_encoder.end_encoding();
            return false;
        }
        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) }
                as *mut PathRasterizationVertex;
        let mut vertices = path_types::rasterization_vertices(paths);
        for index in 0..rasterization_vertex_count {
            let Some(vertex) = vertices.next() else {
                command_encoder.end_encoding();
                return false;
            };
            unsafe { buffer_contents.add(index).write(vertex) };
        }
        if vertices.next().is_some() {
            command_encoder.end_encoding();
            return false;
        }
        bind_instance_bytes(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            vertices_bytes_len,
=======
        command_encoder.set_vertex_buffer(
            PathRasterizationInputIndex::Vertices as u64,
            Some(&vertex_instance_bindings.buffer),
            vertex_instance_bindings.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            PathRasterizationInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );
        command_encoder.set_fragment_buffer(
            PathRasterizationInputIndex::Vertices as u64,
            Some(&vertex_instance_bindings.buffer),
            vertex_instance_bindings.offset as u64,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        );
        command_encoder.draw_primitives(
            metal::MTLPrimitiveType::Triangle,
            0,
<<<<<<< HEAD
            rasterization_vertex_count as u64,
        );
        *instance_offset = next_offset;

        command_encoder.end_encoding();
        true
=======
            vertices.len() as u64,
        );

        command_encoder.end_encoding();
        Ok(true)
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_shadows(
        &self,
<<<<<<< HEAD
        shadows: &[Shadow],
        smoothed: bool,
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        if shadows.is_empty() {
            return true;
        }
        align_offset(instance_offset);

        let shadow_bytes_len = mem::size_of_val(shadows);
        let next_offset = *instance_offset + shadow_bytes_len;
        if next_offset > instance_buffer.size {
            return false;
        }

        let pipeline = if smoothed {
            &self.smoothed_shadows_pipeline_state
        } else {
            &self.shadows_pipeline_state
        };
        command_encoder.set_render_pipeline_state(pipeline);
        bind_scene_uniforms(command_encoder, scene_uniforms);

        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) };
        unsafe {
            ptr::copy_nonoverlapping(
                shadows.as_ptr() as *const u8,
                buffer_contents,
                shadow_bytes_len,
            );
        }
        bind_instances(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            shadows,
        );

        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::TriangleStrip,
            0,
            4,
            shadows.len() as u64,
        );
        *instance_offset = next_offset;
        true
=======
        shadows: Range<usize>,
        instance_bindings: &InstanceBindings,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) {
        if shadows.is_empty() {
            return;
        }

        command_encoder.set_render_pipeline_state(&self.shadows_pipeline_state);
        command_encoder.set_vertex_buffer(
            ShadowInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_buffer(
            ShadowInputIndex::Shadows as u64,
            Some(&instance_bindings.shadows.buffer),
            instance_bindings.shadows.offset as u64,
        );
        command_encoder.set_fragment_buffer(
            ShadowInputIndex::Shadows as u64,
            Some(&instance_bindings.shadows.buffer),
            instance_bindings.shadows.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            ShadowInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );

        command_encoder.draw_primitives_instanced_base_instance(
            metal::MTLPrimitiveType::Triangle,
            0,
            6,
            shadows.len() as u64,
            shadows.start as u64,
        );
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_quads(
        &self,
<<<<<<< HEAD
        quads: &[Quad],
        smoothed: bool,
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        if quads.is_empty() {
            return true;
        }
        align_offset(instance_offset);

        let quad_bytes_len = mem::size_of_val(quads);
        let next_offset = *instance_offset + quad_bytes_len;
        if next_offset > instance_buffer.size {
            return false;
        }

        let pipeline = if smoothed {
            &self.smoothed_quads_pipeline_state
        } else {
            &self.quads_pipeline_state
        };
        command_encoder.set_render_pipeline_state(pipeline);
        bind_scene_uniforms(command_encoder, scene_uniforms);

        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) };
        unsafe {
            ptr::copy_nonoverlapping(quads.as_ptr() as *const u8, buffer_contents, quad_bytes_len);
        }
        bind_instances(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            quads,
        );

        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::TriangleStrip,
            0,
            4,
            quads.len() as u64,
        );
        *instance_offset = next_offset;
        true
=======
        quads: Range<usize>,
        instance_bindings: &InstanceBindings,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) {
        if quads.is_empty() {
            return;
        }

        command_encoder.set_render_pipeline_state(&self.quads_pipeline_state);
        command_encoder.set_vertex_buffer(
            QuadInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_buffer(
            QuadInputIndex::Quads as u64,
            Some(&instance_bindings.quads.buffer),
            instance_bindings.quads.offset as u64,
        );
        command_encoder.set_fragment_buffer(
            QuadInputIndex::Quads as u64,
            Some(&instance_bindings.quads.buffer),
            instance_bindings.quads.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            QuadInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );

        command_encoder.draw_primitives_instanced_base_instance(
            metal::MTLPrimitiveType::Triangle,
            0,
            6,
            quads.len() as u64,
            quads.start as u64,
        );
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_paths_from_intermediate(
        &self,
        paths: &[Path<ScaledPixels>],
<<<<<<< HEAD
        sprite_count: usize,
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        let Some(_) = paths.first() else {
            return true;
        };

        let Some(ref intermediate_texture) = self.path_intermediate_texture else {
            return false;
        };
=======
        writer: &mut InstanceBufferWriter,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> Result<()> {
        let Some(first_path) = paths.first() else {
            return Ok(());
        };
        let intermediate_texture = self
            .path_intermediate_texture
            .as_ref()
            .context("missing path intermediate texture")?;

        command_encoder.set_render_pipeline_state(&self.path_sprites_pipeline_state);
        command_encoder.set_vertex_buffer(
            SpriteInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_bytes(
            SpriteInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );

        command_encoder.set_fragment_texture(
            SpriteInputIndex::AtlasTexture as u64,
            Some(intermediate_texture),
        );
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

        // When copying paths from the intermediate texture to the drawable,
        // each pixel must only be copied once, in case of transparent paths.
        //
        // If all paths have the same draw order, then their bounds are all
        // disjoint, so we can copy each path's bounds individually. If this
        // batch combines different draw orders, we perform a single copy
        // for a minimal spanning rect.
<<<<<<< HEAD
        align_offset(instance_offset);
        let sprite_bytes_len = mem::size_of::<path_types::PathSprite>() * sprite_count;
        let next_offset = *instance_offset + sprite_bytes_len;
        if next_offset > instance_buffer.size {
            return false;
        }

        command_encoder.set_render_pipeline_state(&self.path_sprites_pipeline_state);
        bind_scene_uniforms(command_encoder, scene_uniforms);
        command_encoder.set_fragment_texture(PRIMARY_TEXTURE_SLOT, Some(intermediate_texture));
        command_encoder.set_fragment_sampler_state(SAMPLER_SLOT, Some(&self.sampler));

        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) }
                as *mut path_types::PathSprite;
        let mut sprites = path_types::sprites(paths);
        for index in 0..sprite_count {
            let Some(sprite) = sprites.next() else {
                return false;
            };
            unsafe { buffer_contents.add(index).write(sprite) };
        }
        if sprites.next().is_some() {
            return false;
        }

        bind_instance_bytes(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            sprite_bytes_len,
        );
        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::TriangleStrip,
            0,
            4,
            sprite_count as u64,
        );
        *instance_offset = next_offset;

        true
=======
        let sprites;
        if paths.last().unwrap().order == first_path.order {
            sprites = paths
                .iter()
                .map(|path| PathSprite {
                    bounds: path.clipped_bounds(),
                })
                .collect();
        } else {
            let mut bounds = first_path.clipped_bounds();
            for path in paths.iter().skip(1) {
                bounds = bounds.union(&path.clipped_bounds());
            }
            sprites = vec![PathSprite { bounds }];
        }

        let sprite_instance_bindings = writer.write(&sprites)?;
        command_encoder.set_vertex_buffer(
            SpriteInputIndex::Sprites as u64,
            Some(&sprite_instance_bindings.buffer),
            sprite_instance_bindings.offset as u64,
        );

        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::Triangle,
            0,
            6,
            sprites.len() as u64,
        );
        Ok(())
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_underlines(
        &self,
<<<<<<< HEAD
        underlines: &[Underline],
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        if underlines.is_empty() {
            return true;
        }
        align_offset(instance_offset);

        let underline_bytes_len = mem::size_of_val(underlines);
        let next_offset = *instance_offset + underline_bytes_len;
        if next_offset > instance_buffer.size {
            return false;
        }

        command_encoder.set_render_pipeline_state(&self.underlines_pipeline_state);
        bind_scene_uniforms(command_encoder, scene_uniforms);

        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) };
        unsafe {
            ptr::copy_nonoverlapping(
                underlines.as_ptr() as *const u8,
                buffer_contents,
                underline_bytes_len,
            );
        }
        bind_instances(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            underlines,
        );

        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::TriangleStrip,
            0,
            4,
            underlines.len() as u64,
        );
        *instance_offset = next_offset;
        true
=======
        underlines: Range<usize>,
        instance_bindings: &InstanceBindings,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) {
        if underlines.is_empty() {
            return;
        }

        command_encoder.set_render_pipeline_state(&self.underlines_pipeline_state);
        command_encoder.set_vertex_buffer(
            UnderlineInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_buffer(
            UnderlineInputIndex::Underlines as u64,
            Some(&instance_bindings.underlines.buffer),
            instance_bindings.underlines.offset as u64,
        );
        command_encoder.set_fragment_buffer(
            UnderlineInputIndex::Underlines as u64,
            Some(&instance_bindings.underlines.buffer),
            instance_bindings.underlines.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            UnderlineInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );

        command_encoder.draw_primitives_instanced_base_instance(
            metal::MTLPrimitiveType::Triangle,
            0,
            6,
            underlines.len() as u64,
            underlines.start as u64,
        );
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_monochrome_sprites(
        &self,
        texture_id: AtlasTextureId,
<<<<<<< HEAD
        sprites: &[MonochromeSprite],
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        if sprites.is_empty() {
            return true;
        }
        align_offset(instance_offset);

        let sprite_bytes_len = mem::size_of_val(sprites);
        let next_offset = *instance_offset + sprite_bytes_len;
        if next_offset > instance_buffer.size {
            return false;
        }

        let texture = self.sprite_atlas.metal_texture(texture_id);
        command_encoder.set_render_pipeline_state(&self.monochrome_sprites_pipeline_state);
        bind_scene_uniforms(command_encoder, scene_uniforms);

        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) };
        unsafe {
            ptr::copy_nonoverlapping(
                sprites.as_ptr() as *const u8,
                buffer_contents,
                sprite_bytes_len,
            );
        }
        bind_instances(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            sprites,
        );
        // Generated native shaders derive tile coordinates from the atlas size in the
        // vertex stage; bind the same texture to both stages, as WGPU and DirectX do.
        command_encoder.set_vertex_texture(PRIMARY_TEXTURE_SLOT, Some(&texture));
        command_encoder.set_fragment_texture(PRIMARY_TEXTURE_SLOT, Some(&texture));
        command_encoder.set_fragment_sampler_state(SAMPLER_SLOT, Some(&self.sampler));

        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::TriangleStrip,
            0,
            4,
            sprites.len() as u64,
        );
        *instance_offset = next_offset;
        true
=======
        sprites: Range<usize>,
        instance_bindings: &InstanceBindings,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) {
        if sprites.is_empty() {
            return;
        }

        let Some(texture) = self.sprite_atlas.metal_texture(texture_id) else {
            return;
        };
        let texture_size = size(
            DevicePixels(texture.width() as i32),
            DevicePixels(texture.height() as i32),
        );
        command_encoder.set_render_pipeline_state(&self.monochrome_sprites_pipeline_state);
        command_encoder.set_vertex_buffer(
            SpriteInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_buffer(
            SpriteInputIndex::Sprites as u64,
            Some(&instance_bindings.monochrome_sprites.buffer),
            instance_bindings.monochrome_sprites.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            SpriteInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );
        command_encoder.set_vertex_bytes(
            SpriteInputIndex::AtlasTextureSize as u64,
            mem::size_of_val(&texture_size) as u64,
            &texture_size as *const Size<DevicePixels> as *const _,
        );
        command_encoder.set_fragment_buffer(
            SpriteInputIndex::Sprites as u64,
            Some(&instance_bindings.monochrome_sprites.buffer),
            instance_bindings.monochrome_sprites.offset as u64,
        );
        command_encoder.set_fragment_texture(SpriteInputIndex::AtlasTexture as u64, Some(&texture));

        command_encoder.draw_primitives_instanced_base_instance(
            metal::MTLPrimitiveType::Triangle,
            0,
            6,
            sprites.len() as u64,
            sprites.start as u64,
        );
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_polychrome_sprites(
        &self,
        texture_id: AtlasTextureId,
<<<<<<< HEAD
        sprites: &[PolychromeSprite],
        smoothed: bool,
        instance_buffer: &mut InstanceBuffer,
        instance_offset: &mut usize,
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        if sprites.is_empty() {
            return true;
        }
        align_offset(instance_offset);

        let sprite_bytes_len = mem::size_of_val(sprites);
        let next_offset = *instance_offset + sprite_bytes_len;
        if next_offset > instance_buffer.size {
            return false;
        }

        let texture = self.sprite_atlas.metal_texture(texture_id);
        let pipeline = if smoothed {
            &self.smoothed_polychrome_sprites_pipeline_state
        } else {
            &self.polychrome_sprites_pipeline_state
        };
        command_encoder.set_render_pipeline_state(pipeline);
        bind_scene_uniforms(command_encoder, scene_uniforms);

        let buffer_contents =
            unsafe { (instance_buffer.metal_buffer.contents() as *mut u8).add(*instance_offset) };
        unsafe {
            ptr::copy_nonoverlapping(
                sprites.as_ptr() as *const u8,
                buffer_contents,
                sprite_bytes_len,
            );
        }
        bind_instances(
            command_encoder,
            &instance_buffer.metal_buffer,
            *instance_offset,
            sprites,
        );
        command_encoder.set_vertex_texture(PRIMARY_TEXTURE_SLOT, Some(&texture));
        command_encoder.set_fragment_texture(PRIMARY_TEXTURE_SLOT, Some(&texture));
        command_encoder.set_fragment_sampler_state(SAMPLER_SLOT, Some(&self.sampler));

        command_encoder.draw_primitives_instanced(
            metal::MTLPrimitiveType::TriangleStrip,
            0,
            4,
            sprites.len() as u64,
        );
        *instance_offset = next_offset;
        true
=======
        sprites: Range<usize>,
        instance_bindings: &InstanceBindings,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) {
        if sprites.is_empty() {
            return;
        }

        let Some(texture) = self.sprite_atlas.metal_texture(texture_id) else {
            return;
        };
        let texture_size = size(
            DevicePixels(texture.width() as i32),
            DevicePixels(texture.height() as i32),
        );
        command_encoder.set_render_pipeline_state(&self.polychrome_sprites_pipeline_state);
        command_encoder.set_vertex_buffer(
            SpriteInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_buffer(
            SpriteInputIndex::Sprites as u64,
            Some(&instance_bindings.polychrome_sprites.buffer),
            instance_bindings.polychrome_sprites.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            SpriteInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );
        command_encoder.set_vertex_bytes(
            SpriteInputIndex::AtlasTextureSize as u64,
            mem::size_of_val(&texture_size) as u64,
            &texture_size as *const Size<DevicePixels> as *const _,
        );
        command_encoder.set_fragment_buffer(
            SpriteInputIndex::Sprites as u64,
            Some(&instance_bindings.polychrome_sprites.buffer),
            instance_bindings.polychrome_sprites.offset as u64,
        );
        command_encoder.set_fragment_texture(SpriteInputIndex::AtlasTexture as u64, Some(&texture));

        command_encoder.draw_primitives_instanced_base_instance(
            metal::MTLPrimitiveType::Triangle,
            0,
            6,
            sprites.len() as u64,
            sprites.start as u64,
        );
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }

    fn draw_surfaces(
        &mut self,
        surfaces: &[PaintSurface],
<<<<<<< HEAD
        opacities: &[f32],
        scene_uniforms: &SceneUniforms,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) -> bool {
        command_encoder.set_render_pipeline_state(&self.surfaces_pipeline_state);
        bind_scene_uniforms(command_encoder, scene_uniforms);
        command_encoder.set_fragment_sampler_state(SAMPLER_SLOT, Some(&self.sampler));

        for (index, surface) in surfaces.iter().enumerate() {
            let image_buffer = match &surface.source {
                SurfaceSource::Surface(image_buffer) => image_buffer,
                SurfaceSource::Unsupported(size) => {
                    log::error!("Metal cannot draw unsupported surface source with size {size:?}");
                    continue;
                }
                // WGPU textures exist when gpui's `custom-gpu` feature is on; only
                // the WGPU renderer (gpui_macos's `wgpu` feature) can draw them.
                #[allow(unreachable_patterns)]
                _ => {
                    log::error!("Metal cannot draw WGPU texture surfaces");
                    continue;
                }
            };

            assert_eq!(
                image_buffer.get_pixel_format(),
                kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            );

            let y_texture = self
                .core_video_texture_cache
                .create_texture_from_image(
                    image_buffer.as_concrete_TypeRef(),
                    None,
                    MTLPixelFormat::R8Unorm,
                    image_buffer.get_width_of_plane(0),
                    image_buffer.get_height_of_plane(0),
                    0,
                )
                .unwrap();
            let cb_cr_texture = self
                .core_video_texture_cache
                .create_texture_from_image(
                    image_buffer.as_concrete_TypeRef(),
                    None,
                    MTLPixelFormat::RG8Unorm,
                    image_buffer.get_width_of_plane(1),
                    image_buffer.get_height_of_plane(1),
                    1,
                )
                .unwrap();

            let surface_uniforms = SurfaceUniforms {
                bounds: surface.bounds.into(),
                content_mask: surface.content_mask.into(),
                color_format: SurfaceColorFormat::Yuv,
                opacity: opacities.get(index).copied().unwrap_or(1.0),
                padding0: 0,
                padding1: 0,
                padding2: 0,
                padding3: 0,
                padding4: 0,
                padding5: 0,
            };
            command_encoder.set_vertex_bytes(
                DATA_SLOT,
                mem::size_of::<SurfaceUniforms>() as u64,
                &surface_uniforms as *const SurfaceUniforms as *const _,
            );
            command_encoder.set_fragment_bytes(
                DATA_SLOT,
                mem::size_of::<SurfaceUniforms>() as u64,
                &surface_uniforms as *const SurfaceUniforms as *const _,
            );
            command_encoder.set_fragment_texture(PRIMARY_TEXTURE_SLOT, unsafe {
                let texture = CVMetalTextureGetTexture(y_texture.as_concrete_TypeRef());
                Some(metal::TextureRef::from_ptr(texture as *mut _))
            });
            command_encoder.set_fragment_texture(SECONDARY_TEXTURE_SLOT, unsafe {
                let texture = CVMetalTextureGetTexture(cb_cr_texture.as_concrete_TypeRef());
                Some(metal::TextureRef::from_ptr(texture as *mut _))
            });

            command_encoder.draw_primitives(metal::MTLPrimitiveType::TriangleStrip, 0, 4);
        }
        true
=======
        first_surface: usize,
        instance_bindings: &InstanceBindings,
        viewport_size: Size<DevicePixels>,
        command_encoder: &metal::RenderCommandEncoderRef,
    ) {
        if surfaces.is_empty() {
            return;
        }

        command_encoder.set_render_pipeline_state(&self.surfaces_pipeline_state);
        command_encoder.set_vertex_buffer(
            SurfaceInputIndex::Vertices as u64,
            Some(&self.unit_vertices),
            0,
        );
        command_encoder.set_vertex_buffer(
            SurfaceInputIndex::Surfaces as u64,
            Some(&instance_bindings.surfaces.buffer),
            instance_bindings.surfaces.offset as u64,
        );
        command_encoder.set_vertex_bytes(
            SurfaceInputIndex::ViewportSize as u64,
            mem::size_of_val(&viewport_size) as u64,
            &viewport_size as *const Size<DevicePixels> as *const _,
        );

        for (index, surface) in surfaces.iter().enumerate() {
            let image_buffer = &surface.image_buffer;
            let texture_size = size(
                DevicePixels::from(CVPixelBufferGetWidth(image_buffer) as i32),
                DevicePixels::from(CVPixelBufferGetHeight(image_buffer) as i32),
            );

            assert_eq!(
                CVPixelBufferGetPixelFormatType(image_buffer),
                kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            );

            let plane_texture = |plane, format| unsafe {
                let mut texture = ptr::null_mut();
                let status = CVMetalTextureCache::create_texture_from_image(
                    None,
                    &self.core_video_texture_cache,
                    image_buffer,
                    None,
                    format,
                    CVPixelBufferGetWidthOfPlane(image_buffer, plane),
                    CVPixelBufferGetHeightOfPlane(image_buffer, plane),
                    plane,
                    ptr::NonNull::from(&mut texture),
                );
                assert_eq!(
                    status, kCVReturnSuccess,
                    "failed to create CoreVideo Metal texture"
                );
                CFRetained::<CVMetalTexture>::from_raw(
                    ptr::NonNull::new(texture).expect("CoreVideo returned a null texture"),
                )
            };
            let y_texture = plane_texture(0, objc2_metal::MTLPixelFormat::R8Unorm);
            let cb_cr_texture = plane_texture(1, objc2_metal::MTLPixelFormat::RG8Unorm);

            command_encoder.set_vertex_bytes(
                SurfaceInputIndex::TextureSize as u64,
                mem::size_of_val(&texture_size) as u64,
                &texture_size as *const Size<DevicePixels> as *const _,
            );
            command_encoder.set_fragment_texture(SurfaceInputIndex::YTexture as u64, unsafe {
                let texture = CVMetalTextureGetTexture(&y_texture)
                    .expect("CoreVideo returned no Metal texture");
                Some(metal::TextureRef::from_ptr(
                    objc2::rc::Retained::as_ptr(&texture) as *mut _,
                ))
            });
            command_encoder.set_fragment_texture(SurfaceInputIndex::CbCrTexture as u64, unsafe {
                let texture = CVMetalTextureGetTexture(&cb_cr_texture)
                    .expect("CoreVideo returned no Metal texture");
                Some(metal::TextureRef::from_ptr(
                    objc2::rc::Retained::as_ptr(&texture) as *mut _,
                ))
            });

            command_encoder.draw_primitives_instanced_base_instance(
                metal::MTLPrimitiveType::Triangle,
                0,
                6,
                1,
                (first_surface + index) as u64,
            );
        }
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }
}

fn new_command_encoder_for_texture<'a>(
    command_buffer: &'a metal::CommandBufferRef,
    texture: &'a metal::TextureRef,
    viewport_size: Size<DevicePixels>,
<<<<<<< HEAD
    configure_color_attachment: impl Fn(&RenderPassColorAttachmentDescriptorRef),
=======
    clear_color: Option<metal::MTLClearColor>,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
) -> &'a metal::RenderCommandEncoderRef {
    let render_pass_descriptor = metal::RenderPassDescriptor::new();
    let color_attachment = render_pass_descriptor
        .color_attachments()
        .object_at(0)
        .unwrap();
    color_attachment.set_texture(Some(texture));
    color_attachment.set_store_action(metal::MTLStoreAction::Store);
<<<<<<< HEAD
    configure_color_attachment(color_attachment);
=======
    if let Some(clear_color) = clear_color {
        color_attachment.set_load_action(metal::MTLLoadAction::Clear);
        color_attachment.set_clear_color(clear_color);
    } else {
        color_attachment.set_load_action(metal::MTLLoadAction::Load);
    }
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

    let command_encoder = command_buffer.new_render_command_encoder(render_pass_descriptor);
    command_encoder.set_viewport(metal::MTLViewport {
        originX: 0.0,
        originY: 0.0,
        width: i32::from(viewport_size.width) as f64,
        height: i32::from(viewport_size.height) as f64,
        znear: 0.0,
        zfar: 1.0,
    });
    command_encoder
}

<<<<<<< HEAD
fn build_pipeline_state(
    device: &metal::DeviceRef,
    library: &metal::LibraryRef,
    shader: &NativeShader,
    pixel_format: metal::MTLPixelFormat,
) -> metal::RenderPipelineState {
    let vertex_fn = library
        .get_function(shader.vertex_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.vertex_entry));
    let fragment_fn = library
        .get_function(shader.fragment_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.fragment_entry));

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(shader.label);
=======
#[cfg(any(test, feature = "bench-support", feature = "test-support"))]
fn read_texture_to_image(texture: &metal::TextureRef) -> Result<RgbaImage> {
    let width = texture.width() as u32;
    let height = texture.height() as u32;
    let bytes_per_row = width as usize * 4;
    let mut pixels = vec![0u8; height as usize * bytes_per_row];

    let region = metal::MTLRegion {
        origin: metal::MTLOrigin { x: 0, y: 0, z: 0 },
        size: metal::MTLSize {
            width: width as u64,
            height: height as u64,
            depth: 1,
        },
    };
    texture.get_bytes(
        pixels.as_mut_ptr() as *mut std::ffi::c_void,
        bytes_per_row as u64,
        region,
        0,
    );

    // Convert BGRA to RGBA (swap B and R channels)
    for chunk in pixels.chunks_exact_mut(4) {
        chunk.swap(0, 2);
    }

    RgbaImage::from_raw(width, height, pixels).context("failed to create RgbaImage from pixel data")
}

fn build_pipeline_state(
    device: &metal::DeviceRef,
    library: &metal::LibraryRef,
    label: &str,
    vertex_fn_name: &str,
    fragment_fn_name: &str,
    pixel_format: metal::MTLPixelFormat,
) -> metal::RenderPipelineState {
    let vertex_fn = library
        .get_function(vertex_fn_name, None)
        .expect("error locating vertex function");
    let fragment_fn = library
        .get_function(fragment_fn_name, None)
        .expect("error locating fragment function");

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(label);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    descriptor.set_vertex_function(Some(vertex_fn.as_ref()));
    descriptor.set_fragment_function(Some(fragment_fn.as_ref()));
    let color_attachment = descriptor.color_attachments().object_at(0).unwrap();
    color_attachment.set_pixel_format(pixel_format);
    color_attachment.set_blending_enabled(true);
    color_attachment.set_rgb_blend_operation(metal::MTLBlendOperation::Add);
    color_attachment.set_alpha_blend_operation(metal::MTLBlendOperation::Add);
    color_attachment.set_source_rgb_blend_factor(metal::MTLBlendFactor::SourceAlpha);
    color_attachment.set_source_alpha_blend_factor(metal::MTLBlendFactor::One);
    color_attachment.set_destination_rgb_blend_factor(metal::MTLBlendFactor::OneMinusSourceAlpha);
<<<<<<< HEAD
    color_attachment.set_destination_alpha_blend_factor(metal::MTLBlendFactor::One);
=======
    color_attachment.set_destination_alpha_blend_factor(metal::MTLBlendFactor::OneMinusSourceAlpha);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

    device
        .new_render_pipeline_state(&descriptor)
        .expect("could not create render pipeline state")
}

fn build_path_sprite_pipeline_state(
    device: &metal::DeviceRef,
    library: &metal::LibraryRef,
<<<<<<< HEAD
    shader: &NativeShader,
    pixel_format: metal::MTLPixelFormat,
) -> metal::RenderPipelineState {
    let vertex_fn = library
        .get_function(shader.vertex_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.vertex_entry));
    let fragment_fn = library
        .get_function(shader.fragment_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.fragment_entry));

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(shader.label);
=======
    label: &str,
    vertex_fn_name: &str,
    fragment_fn_name: &str,
    pixel_format: metal::MTLPixelFormat,
) -> metal::RenderPipelineState {
    let vertex_fn = library
        .get_function(vertex_fn_name, None)
        .expect("error locating vertex function");
    let fragment_fn = library
        .get_function(fragment_fn_name, None)
        .expect("error locating fragment function");

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(label);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    descriptor.set_vertex_function(Some(vertex_fn.as_ref()));
    descriptor.set_fragment_function(Some(fragment_fn.as_ref()));
    let color_attachment = descriptor.color_attachments().object_at(0).unwrap();
    color_attachment.set_pixel_format(pixel_format);
    color_attachment.set_blending_enabled(true);
    color_attachment.set_rgb_blend_operation(metal::MTLBlendOperation::Add);
    color_attachment.set_alpha_blend_operation(metal::MTLBlendOperation::Add);
    color_attachment.set_source_rgb_blend_factor(metal::MTLBlendFactor::One);
    color_attachment.set_source_alpha_blend_factor(metal::MTLBlendFactor::One);
    color_attachment.set_destination_rgb_blend_factor(metal::MTLBlendFactor::OneMinusSourceAlpha);
<<<<<<< HEAD
    color_attachment.set_destination_alpha_blend_factor(metal::MTLBlendFactor::One);
=======
    color_attachment.set_destination_alpha_blend_factor(metal::MTLBlendFactor::OneMinusSourceAlpha);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

    device
        .new_render_pipeline_state(&descriptor)
        .expect("could not create render pipeline state")
}

fn build_path_rasterization_pipeline_state(
    device: &metal::DeviceRef,
    library: &metal::LibraryRef,
<<<<<<< HEAD
    shader: &NativeShader,
=======
    label: &str,
    vertex_fn_name: &str,
    fragment_fn_name: &str,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    pixel_format: metal::MTLPixelFormat,
    path_sample_count: u32,
) -> metal::RenderPipelineState {
    let vertex_fn = library
<<<<<<< HEAD
        .get_function(shader.vertex_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.vertex_entry));
    let fragment_fn = library
        .get_function(shader.fragment_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.fragment_entry));

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(shader.label);
=======
        .get_function(vertex_fn_name, None)
        .expect("error locating vertex function");
    let fragment_fn = library
        .get_function(fragment_fn_name, None)
        .expect("error locating fragment function");

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(label);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    descriptor.set_vertex_function(Some(vertex_fn.as_ref()));
    descriptor.set_fragment_function(Some(fragment_fn.as_ref()));
    if path_sample_count > 1 {
        descriptor.set_raster_sample_count(path_sample_count as _);
        descriptor.set_alpha_to_coverage_enabled(false);
    }
    let color_attachment = descriptor.color_attachments().object_at(0).unwrap();
    color_attachment.set_pixel_format(pixel_format);
    color_attachment.set_blending_enabled(true);
    color_attachment.set_rgb_blend_operation(metal::MTLBlendOperation::Add);
    color_attachment.set_alpha_blend_operation(metal::MTLBlendOperation::Add);
    color_attachment.set_source_rgb_blend_factor(metal::MTLBlendFactor::One);
    color_attachment.set_source_alpha_blend_factor(metal::MTLBlendFactor::One);
    color_attachment.set_destination_rgb_blend_factor(metal::MTLBlendFactor::OneMinusSourceAlpha);
    color_attachment.set_destination_alpha_blend_factor(metal::MTLBlendFactor::OneMinusSourceAlpha);

    device
        .new_render_pipeline_state(&descriptor)
        .expect("could not create render pipeline state")
}

<<<<<<< HEAD
// Blur downsample/gaussian passes overwrite their target (no blending). The composite pass
// uses the normal alpha-blending pipeline (`build_path_sprite_pipeline_state`) instead.
fn build_blur_pipeline_state(
    device: &metal::DeviceRef,
    library: &metal::LibraryRef,
    shader: &NativeShader,
    pixel_format: metal::MTLPixelFormat,
) -> metal::RenderPipelineState {
    let vertex_fn = library
        .get_function(shader.vertex_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.vertex_entry));
    let fragment_fn = library
        .get_function(shader.fragment_entry, None)
        .unwrap_or_else(|error| panic!("error locating {}: {error}", shader.fragment_entry));

    let descriptor = metal::RenderPipelineDescriptor::new();
    descriptor.set_label(shader.label);
    descriptor.set_vertex_function(Some(vertex_fn.as_ref()));
    descriptor.set_fragment_function(Some(fragment_fn.as_ref()));
    let color_attachment = descriptor.color_attachments().object_at(0).unwrap();
    color_attachment.set_pixel_format(pixel_format);
    color_attachment.set_blending_enabled(false);

    device
        .new_render_pipeline_state(&descriptor)
        .expect("could not create render pipeline state")
}

fn required_instance_buffer_size(scene: &Scene) -> usize {
    let mut required = 0;
    let mut reserve = |element_size: usize, count: usize| {
        if count > 0 {
            align_offset(&mut required);
            required = required.saturating_add(element_size.saturating_mul(count));
        }
    };

    for command in scene.render_commands() {
        let RenderCommand::Batch(batch) = command else {
            continue;
        };
        match batch {
            PrimitiveBatch::Shadows { range, .. } => reserve(mem::size_of::<Shadow>(), range.len()),
            PrimitiveBatch::Quads { range, .. } => reserve(mem::size_of::<Quad>(), range.len()),
            PrimitiveBatch::Paths {
                rasterization_vertex_count,
                sprite_count,
                ..
            } if *rasterization_vertex_count > 0 => {
                reserve(
                    mem::size_of::<path_types::PathRasterizationVertex>(),
                    *rasterization_vertex_count,
                );
                reserve(mem::size_of::<path_types::PathSprite>(), *sprite_count);
            }
            PrimitiveBatch::Underlines(range) => reserve(mem::size_of::<Underline>(), range.len()),
            PrimitiveBatch::MonochromeSprites { range, .. } => {
                reserve(mem::size_of::<MonochromeSprite>(), range.len())
            }
            PrimitiveBatch::PolychromeSprites { range, .. } => {
                reserve(mem::size_of::<PolychromeSprite>(), range.len())
            }
            PrimitiveBatch::Paths { .. }
            | PrimitiveBatch::SubpixelSprites { .. }
            | PrimitiveBatch::Surfaces(_)
            | PrimitiveBatch::BackdropFilters(_)
            | PrimitiveBatch::FilterBoundary(_) => {}
        }
    }
    required
}

// Align to multiples of 256 make Metal happy.
fn align_offset(offset: &mut usize) {
    *offset = (*offset).div_ceil(256) * 256;
=======
#[derive(Clone)]
struct InstanceBinding {
    buffer: metal::Buffer,
    offset: usize,
}

struct InstanceBindings {
    quads: InstanceBinding,
    shadows: InstanceBinding,
    underlines: InstanceBinding,
    monochrome_sprites: InstanceBinding,
    polychrome_sprites: InstanceBinding,
    surfaces: InstanceBinding,
}

fn write_instances(scene: &Scene, writer: &mut InstanceBufferWriter) -> Result<InstanceBindings> {
    Ok(InstanceBindings {
        quads: writer.write(&scene.quads)?,
        shadows: writer.write(&scene.shadows)?,
        underlines: writer.write(&scene.underlines)?,
        monochrome_sprites: writer.write(&scene.monochrome_sprites)?,
        polychrome_sprites: writer.write(&scene.polychrome_sprites)?,
        surfaces: writer.write_iter(scene.surfaces.iter().map(|surface| SurfaceBounds {
            bounds: surface.bounds,
            content_mask: surface.content_mask,
        }))?,
    })
}

struct InstanceBufferWriter {
    device: metal::Device,
    pool: Arc<Mutex<InstanceBufferPool>>,
    unified_memory: bool,
    filled: Vec<(InstanceBuffer, usize)>,
    current: InstanceBuffer,
    offset: usize,
}

impl InstanceBufferWriter {
    fn new(
        device: &metal::Device,
        pool: &Arc<Mutex<InstanceBufferPool>>,
        unified_memory: bool,
    ) -> Self {
        let current = pool.lock().acquire(device, unified_memory);
        Self {
            device: device.clone(),
            pool: pool.clone(),
            unified_memory,
            filled: Vec::new(),
            current,
            offset: 0,
        }
    }

    fn allocate<T>(&mut self, count: usize) -> Result<(InstanceBinding, &mut [MaybeUninit<T>])> {
        let size = mem::size_of::<T>() * count;
        let mut offset = self.offset.next_multiple_of(INSTANCE_BUFFER_ALIGNMENT);
        if offset + size > self.current.size {
            self.grow(size)?;
            offset = 0;
        }
        self.offset = offset + size;

        let binding = InstanceBinding {
            buffer: self.current.metal_buffer.clone(),
            offset,
        };
        // Safety: the reservation lies within a buffer this frame owns
        // exclusively, and never overlaps one handed out earlier.
        let values = unsafe {
            let start = (self.current.metal_buffer.contents() as *mut u8).add(offset);
            slice::from_raw_parts_mut(start.cast::<MaybeUninit<T>>(), count)
        };
        Ok((binding, values))
    }

    fn write<T>(&mut self, values: &[T]) -> Result<InstanceBinding> {
        let (binding, destination) = self.allocate::<T>(values.len())?;
        unsafe {
            ptr::copy_nonoverlapping(
                values.as_ptr(),
                destination.as_mut_ptr().cast::<T>(),
                values.len(),
            );
        }
        Ok(binding)
    }

    fn write_iter<T>(
        &mut self,
        values: impl ExactSizeIterator<Item = T>,
    ) -> Result<InstanceBinding> {
        let (binding, destination) = self.allocate::<T>(values.len())?;
        for (slot, value) in destination.iter_mut().zip(values) {
            slot.write(value);
        }
        Ok(binding)
    }

    fn grow(&mut self, required: usize) -> Result<()> {
        let mut pool = self.pool.lock();
        let buffer_size = (pool.buffer_size * 2)
            .max(required.next_power_of_two())
            .min(MAX_INSTANCE_BUFFER_SIZE);
        anyhow::ensure!(
            buffer_size >= required,
            "instance buffer needs {required} bytes, above the maximum of {MAX_INSTANCE_BUFFER_SIZE}"
        );
        anyhow::ensure!(
            buffer_size > self.current.size,
            "frame instance data exceeds the {MAX_INSTANCE_BUFFER_SIZE}-byte maximum"
        );
        if buffer_size != pool.buffer_size {
            log::info!("increased instance buffer size to {buffer_size}");
            pool.reset(buffer_size);
        }
        let buffer = pool.acquire(&self.device, self.unified_memory);
        drop(pool);

        let filled = mem::replace(&mut self.current, buffer);
        self.filled.push((filled, self.offset));
        self.offset = 0;
        Ok(())
    }

    fn finish(self) -> InstanceBuffer {
        let Self {
            unified_memory,
            filled,
            current,
            offset,
            ..
        } = self;

        if !unified_memory {
            for (buffer, written) in &filled {
                if *written == 0 {
                    continue;
                }
                buffer.metal_buffer.did_modify_range(NSRange {
                    location: 0,
                    length: *written as NSUInteger,
                });
            }
            if offset > 0 {
                current.metal_buffer.did_modify_range(NSRange {
                    location: 0,
                    length: offset as NSUInteger,
                });
            }
        }

        // Metal retains encoded resources until the command buffer completes.
        // Only the final, largest buffer is worth keeping in the pool.
        drop(filled);
        current
    }
}

#[repr(C)]
enum ShadowInputIndex {
    Vertices = 0,
    Shadows = 1,
    ViewportSize = 2,
}

#[repr(C)]
enum QuadInputIndex {
    Vertices = 0,
    Quads = 1,
    ViewportSize = 2,
}

#[repr(C)]
enum UnderlineInputIndex {
    Vertices = 0,
    Underlines = 1,
    ViewportSize = 2,
}

#[repr(C)]
enum SpriteInputIndex {
    Vertices = 0,
    Sprites = 1,
    ViewportSize = 2,
    AtlasTextureSize = 3,
    AtlasTexture = 4,
}

#[repr(C)]
enum SurfaceInputIndex {
    Vertices = 0,
    Surfaces = 1,
    ViewportSize = 2,
    TextureSize = 3,
    YTexture = 4,
    CbCrTexture = 5,
}

#[repr(C)]
enum PathRasterizationInputIndex {
    Vertices = 0,
    ViewportSize = 1,
}

#[derive(Clone, Debug, Eq, PartialEq)]
#[repr(C)]
pub struct PathSprite {
    pub bounds: Bounds<ScaledPixels>,
}

#[derive(Clone, Debug, Eq, PartialEq)]
#[repr(C)]
pub struct SurfaceBounds {
    pub bounds: Bounds<ScaledPixels>,
    pub content_mask: ContentMask<ScaledPixels>,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
}

#[cfg(any(test, feature = "bench-support", feature = "test-support"))]
pub struct MetalHeadlessRenderer {
    renderer: MetalRenderer,
}

#[cfg(any(test, feature = "bench-support", feature = "test-support"))]
impl MetalHeadlessRenderer {
    pub fn new() -> Self {
        let instance_buffer_pool = Arc::new(Mutex::new(InstanceBufferPool::default()));
        let renderer = MetalRenderer::new_headless(instance_buffer_pool);
        Self { renderer }
    }
}

#[cfg(any(test, feature = "bench-support", feature = "test-support"))]
impl gpui::PlatformHeadlessRenderer for MetalHeadlessRenderer {
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<image::RgbaImage> {
        self.renderer.render_scene_to_image(scene, size)
    }

    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> anyhow::Result<()> {
        self.renderer.render_scene(scene, size)
    }

    fn sprite_atlas(&self) -> Arc<dyn gpui::PlatformAtlas> {
        self.renderer.sprite_atlas().clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
<<<<<<< HEAD
    use gpui::{
        AtlasKey, BackdropFilter, BorderStyle, ContentMask, Edges, ImageId, Path, PlatformAtlas,
        PlatformHeadlessRenderer, RenderImageParams, RenderSvgParams, ScaledFilter,
        TransformationMatrix, checkerboard, hsla, linear_color_stop, linear_gradient,
        pattern_slash, px, solid_background, white,
    };
    use std::borrow::Cow;

    #[test]
    fn intermediate_textures_follow_scene_requirements() {
        let pool = Arc::new(Mutex::new(InstanceBufferPool::default()));
        let mut renderer = MetalRenderer::new_headless(pool);
        let target_size = size(DevicePixels(5), DevicePixels(5));
        let mut empty_scene = Scene::default();
        empty_scene.finish();

        renderer.prepare_intermediate_textures(&empty_scene, target_size);
        assert!(renderer.path_intermediate_texture.is_none());
        assert!(renderer.scene_color_texture.is_none());
        assert!(renderer.blur_ping_texture.is_none());
        assert!(renderer.group_textures.is_empty());

        let bounds = Bounds {
            origin: gpui::point(ScaledPixels(0.0), ScaledPixels(0.0)),
            size: size(ScaledPixels(5.0), ScaledPixels(5.0)),
        };
        let mut filtered_scene = Scene::default();
        filtered_scene.insert_primitive(BackdropFilter {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            filters: smallvec::smallvec![ScaledFilter::Blur(ScaledPixels(1.0))],
            opacity: 1.0,
            ..Default::default()
        });
        filtered_scene.finish();

        renderer.prepare_intermediate_textures(&filtered_scene, target_size);
        assert!(renderer.path_intermediate_texture.is_none());
        assert!(renderer.scene_color_texture.is_some());
        assert!(renderer.blur_ping_texture.is_some());
        assert!(renderer.blur_pong_texture.is_some());
        assert!(renderer.group_textures.is_empty());
    }

    #[test]
    fn generated_sprite_shader_preserves_monochrome_coverage() {
        let pool = Arc::new(Mutex::new(InstanceBufferPool::default()));
        let mut renderer = MetalRenderer::new_headless(pool);
        let tile_size = Size {
            width: DevicePixels(8),
            height: DevicePixels(8),
        };
        let key = AtlasKey::Svg(RenderSvgParams {
            path: "generated-sprite-coverage-test".into(),
            size: tile_size,
        });
        let tile = renderer
            .sprite_atlas()
            .get_or_insert_with(&key, &mut || {
                Ok(Some((tile_size, Cow::Owned(vec![64; 64]))))
            })
            .unwrap()
            .unwrap();
        let bounds = Bounds {
            origin: gpui::point(ScaledPixels(8.0), ScaledPixels(8.0)),
            size: Size {
                width: ScaledPixels(16.0),
                height: ScaledPixels(16.0),
            },
        };
        let mut scene = Scene::default();
        scene.insert_primitive(MonochromeSprite {
            order: 0,
            padding: 0,
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            color: white().into(),
            tile,
            transformation: TransformationMatrix::unit(),
        });
        scene.finish();

        let image = renderer
            .render_scene_to_image(
                &scene,
                Size {
                    width: DevicePixels(32),
                    height: DevicePixels(32),
                },
            )
            .unwrap();
        let center = image.get_pixel(16, 16).0;
        assert!(
            center[0] >= 63 && center[0] <= 65 && center[1] == center[0] && center[2] == center[0],
            "monochrome coverage was altered before blending: {center:?}"
        );
    }

    /// Pixel spot-check helpers for the generated-shader contract tests below.
    ///
    /// Headless Metal runs on whichever Apple GPU the host provides, and the
    /// shared shaders exercise `sin`/`pow`/`exp`/MSAA paths whose last-ulp
    /// rounding varies across GPU generations and Metal compiler versions.
    /// These tests therefore pin exact bytes only where the math is bit-exact
    /// (solid colors, cleared background) and use small tolerances plus
    /// structural checks (coverage ramps, dash gaps, blur falloff) everywhere
    /// else. Deterministic byte-exact parity for quad backgrounds is covered
    /// by `quad_backgrounds_match_legacy_metal_pixels` in `gpui_wgpu`, which
    /// runs on a software renderer.
    fn pixel(image: &RgbaImage, x: u32, y: u32) -> [u8; 4] {
        image.get_pixel(x, y).0
    }

    fn assert_pixel_close(
        image: &RgbaImage,
        x: u32,
        y: u32,
        expected: [u8; 4],
        tolerance: u8,
        what: &str,
    ) {
        let actual = pixel(image, x, y);
        for (channel, (observed, reference)) in actual.iter().zip(expected.iter()).enumerate() {
            assert!(
                observed.abs_diff(*reference) <= tolerance,
                "{what} pixel ({x}, {y}) channel {channel}: got {actual:?}, expected {expected:?} ± {tolerance}",
            );
        }
    }

    /// Renders `scene` headlessly and checks the output size. The pixel
    /// contracts below only hold where Metal actually executes, so non-macOS
    /// builds stop after the dimension check.
    fn render_for_contracts(
        renderer: &mut MetalHeadlessRenderer,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> Option<RgbaImage> {
        let image = renderer.render_scene_to_image(scene, size).unwrap();
        assert_eq!(
            image.dimensions(),
            (size.width.0 as u32, size.height.0 as u32)
        );
        if cfg!(target_os = "macos") {
            Some(image)
        } else {
            None
        }
    }

    #[test]
    fn generated_quad_shaders_render_background_contracts() {
        let mut renderer = MetalHeadlessRenderer::new();
        let bounds = |x, y| Bounds {
            origin: gpui::point(ScaledPixels(x), ScaledPixels(y)),
            size: Size {
                width: ScaledPixels(2.0),
                height: ScaledPixels(2.0),
            },
        };
        let mut quads = Scene::default();
        for (bounds, background) in [
            (bounds(0.0, 0.0), solid_background(hsla(0.0, 1.0, 0.5, 1.0))),
            (
                bounds(2.0, 0.0),
                checkerboard(hsla(0.6, 0.7, 0.5, 1.0), 1.0),
            ),
            (
                bounds(0.0, 2.0),
                pattern_slash(hsla(0.3, 0.8, 0.5, 1.0), 1.0, 1.0),
            ),
            (
                bounds(2.0, 2.0),
                linear_gradient(
                    45.0,
                    linear_color_stop(hsla(0.8, 0.9, 0.4, 1.0), 0.0),
                    linear_color_stop(hsla(0.1, 0.8, 0.6, 1.0), 1.0),
                ),
            ),
        ] {
            quads.insert_primitive(Quad {
                bounds,
                content_mask: ContentMask {
                    bounds,
                    ..Default::default()
                },
                background,
                ..Default::default()
            });
        }
        quads.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &quads,
            Size {
                width: DevicePixels(4),
                height: DevicePixels(4),
            },
        ) else {
            return;
        };

        // Solid red is exactly representable, so it must round-trip untouched.
        for (x, y) in [(0, 0), (1, 0), (0, 1), (1, 1)] {
            assert_pixel_close(&image, x, y, [255, 0, 0, 255], 0, "solid background");
        }
        // The checkerboard alternates cleared black with the pattern color.
        // The pattern color is pure ALU math (no transcendentals), so it is tight.
        assert_pixel_close(&image, 2, 0, [0, 0, 0, 255], 1, "checkerboard off-square");
        assert_pixel_close(
            &image,
            3,
            0,
            [38, 110, 217, 255],
            2,
            "checkerboard on-square",
        );
        assert_pixel_close(
            &image,
            2,
            1,
            [38, 110, 217, 255],
            2,
            "checkerboard on-square",
        );
        assert_pixel_close(&image, 3, 1, [0, 0, 0, 255], 1, "checkerboard off-square");
        // Slash coverage runs through trig (`sin`) and derivatives, so assert
        // hue structure instead of exact bytes: green-dominant, lit, varying.
        let slash = [
            pixel(&image, 0, 2),
            pixel(&image, 1, 2),
            pixel(&image, 0, 3),
            pixel(&image, 1, 3),
        ];
        for (i, texel) in slash.iter().enumerate() {
            assert!(
                texel[1] > texel[0] && texel[0] > texel[2] && texel[1] > 20,
                "slash texel {i} keeps its green hue: {texel:?}",
            );
        }
        let mut slash_distinct = 0;
        for (i, texel) in slash.iter().enumerate() {
            if slash[..i].iter().all(|other| other != texel) {
                slash_distinct += 1;
            }
        }
        assert!(
            slash_distinct >= 2,
            "slash pattern varies across the quadrant: {slash:?}",
        );
        // The gradient interpolates in Oklab with per-pixel dither, so its
        // texels must be shaded (never flat red/black) and almost all distinct.
        let gradient = [
            pixel(&image, 2, 2),
            pixel(&image, 3, 2),
            pixel(&image, 2, 3),
            pixel(&image, 3, 3),
        ];
        for (i, texel) in gradient.iter().enumerate() {
            assert_ne!(*texel, [255, 0, 0, 255], "gradient texel {i} is shaded");
            assert_ne!(*texel, [0, 0, 0, 255], "gradient texel {i} is shaded");
        }
        let mut gradient_distinct = 0;
        for (i, texel) in gradient.iter().enumerate() {
            if gradient[..i].iter().all(|other| other != texel) {
                gradient_distinct += 1;
            }
        }
        assert!(
            gradient_distinct >= 3,
            "gradient interpolates across the quadrant: {gradient:?}",
        );
    }

    #[test]
    fn generated_underline_shaders_render_line_contracts() {
        let mut renderer = MetalHeadlessRenderer::new();
        let underline_bounds = Bounds {
            origin: gpui::point(ScaledPixels(1.5), ScaledPixels(3.5)),
            size: Size {
                width: ScaledPixels(5.0),
                height: ScaledPixels(1.5),
            },
        };
        let underline_frame = Bounds {
            origin: gpui::point(ScaledPixels(0.0), ScaledPixels(0.0)),
            size: Size {
                width: ScaledPixels(8.0),
                height: ScaledPixels(8.0),
            },
        };
        let mut underline = Scene::default();
        underline.insert_primitive(Quad {
            bounds: underline_frame,
            content_mask: ContentMask {
                bounds: underline_frame,
                ..Default::default()
            },
            background: solid_background(hsla(0.0, 0.0, 0.1, 1.0)),
            ..Default::default()
        });
        underline.insert_primitive(Underline {
            order: 0,
            padding: 0,
            bounds: underline_bounds,
            content_mask: ContentMask {
                bounds: underline_bounds,
                ..Default::default()
            },
            color: hsla(0.6, 0.8, 0.6, 0.65).into(),
            thickness: ScaledPixels(1.0),
            wavy: gpui::ShaderBool::Disabled,
        });
        underline.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &underline,
            Size {
                width: DevicePixels(8),
                height: DevicePixels(8),
            },
        ) else {
            return;
        };
        assert_pixel_close(&image, 0, 0, [26, 26, 26, 255], 1, "underline backdrop");
        assert_pixel_close(&image, 7, 7, [26, 26, 26, 255], 1, "underline backdrop");
        assert_pixel_close(&image, 3, 3, [56, 98, 162, 255], 3, "straight underline");
        assert_pixel_close(&image, 3, 4, [56, 98, 162, 255], 3, "straight underline");

        let mut wavy = Scene::default();
        wavy.insert_primitive(Underline {
            order: 0,
            padding: 0,
            bounds: underline_bounds,
            content_mask: ContentMask {
                bounds: underline_bounds,
                ..Default::default()
            },
            color: hsla(0.1, 0.9, 0.55, 1.0).into(),
            thickness: ScaledPixels(1.0),
            wavy: gpui::ShaderBool::Enabled,
        });
        wavy.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &wavy,
            Size {
                width: DevicePixels(8),
                height: DevicePixels(8),
            },
        ) else {
            return;
        };
        assert_pixel_close(
            &image,
            0,
            0,
            [0, 0, 0, 255],
            1,
            "wavy underline clears outside the line",
        );
        // The wave must actually oscillate instead of drawing a straight band,
        // and its warm line color must show up somewhere.
        let raw = image.as_raw();
        assert_ne!(
            &raw[3 * 8 * 4..4 * 8 * 4],
            &raw[4 * 8 * 4..5 * 8 * 4],
            "wavy underline oscillates between rows",
        );
        assert!(
            image
                .pixels()
                .any(|texel| texel.0[0] > 100 && texel.0[0] > texel.0[2]),
            "wavy underline draws its warm line color",
        );
    }

    #[test]
    fn generated_border_shader_renders_dashed_rounded_rect() {
        let mut renderer = MetalHeadlessRenderer::new();
        let full = Bounds {
            origin: gpui::point(ScaledPixels(0.0), ScaledPixels(0.0)),
            size: Size {
                width: ScaledPixels(16.0),
                height: ScaledPixels(16.0),
            },
        };
        let box_bounds = Bounds {
            origin: gpui::point(ScaledPixels(4.0), ScaledPixels(4.0)),
            size: Size {
                width: ScaledPixels(8.0),
                height: ScaledPixels(8.0),
            },
        };
        let mut border = Scene::default();
        border.insert_primitive(Quad {
            bounds: box_bounds,
            content_mask: ContentMask {
                bounds: full,
                ..Default::default()
            },
            background: solid_background(hsla(0.05, 0.8, 0.45, 1.0)),
            border_style: BorderStyle::Dashed,
            border_color: hsla(0.6, 0.9, 0.7, 1.0).into(),
            corner_radii: Corners::all(ScaledPixels(2.0)),
            border_widths: Edges::all(ScaledPixels(1.0)),
            ..Default::default()
        });
        border.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &border,
            Size {
                width: DevicePixels(16),
                height: DevicePixels(16),
            },
        ) else {
            return;
        };
        assert_pixel_close(
            &image,
            0,
            0,
            [0, 0, 0, 255],
            1,
            "outside the rounded rect stays clear",
        );
        assert_pixel_close(&image, 8, 8, [207, 78, 23, 255], 3, "interior fill");
        // Dashes: along the top edge some texels carry the border hue while
        // others fall back to gaps. A dash period spans 3px over an 8px edge,
        // so both must appear regardless of dash phase.
        let edge: Vec<[u8; 4]> = (4..12).map(|x| pixel(&image, x, 4)).collect();
        let border_like = edge
            .iter()
            .filter(|texel| texel[2] > 150 && texel[1] > 100)
            .count();
        assert!(
            (1..8).contains(&border_like),
            "top edge mixes dash and gap texels: {edge:?}",
        );

        let mut custom_border = Scene::default();
        custom_border.insert_primitive(Quad {
            bounds: box_bounds,
            content_mask: ContentMask {
                bounds: full,
                ..Default::default()
            },
            background: solid_background(hsla(0.05, 0.8, 0.45, 1.0)),
            border_style: BorderStyle::Dashed,
            border_dashed_length: 4.0,
            border_dashed_gap: 0.5,
            border_color: hsla(0.6, 0.9, 0.7, 1.0).into(),
            corner_radii: Corners::all(ScaledPixels(2.0)),
            border_widths: Edges::all(ScaledPixels(1.0)),
            ..Default::default()
        });

        custom_border.finish();
        let Some(custom_image) = render_for_contracts(
            &mut renderer,
            &custom_border,
            Size {
                width: DevicePixels(16),
                height: DevicePixels(16),
            },
        ) else {
            return;
        };

        assert_ne!(
            image.as_raw(),
            custom_image.as_raw(),
            "custom dash length and gap change the rendered border",
        );
    }

    #[test]
    fn generated_shadow_shader_renders_soft_falloff() {
        let mut renderer = MetalHeadlessRenderer::new();
        let full = Bounds {
            origin: gpui::point(ScaledPixels(0.0), ScaledPixels(0.0)),
            size: Size {
                width: ScaledPixels(16.0),
                height: ScaledPixels(16.0),
            },
        };
        let box_bounds = Bounds {
            origin: gpui::point(ScaledPixels(4.0), ScaledPixels(4.0)),
            size: Size {
                width: ScaledPixels(8.0),
                height: ScaledPixels(8.0),
            },
        };
        let mut shadow = Scene::default();
        shadow.insert_primitive(Shadow {
            order: 0,
            blur_radius: ScaledPixels(2.0),
            bounds: box_bounds,
            content_mask: ContentMask {
                bounds: full,
                ..Default::default()
            },
            corner_radii: Corners::all(ScaledPixels(2.0)),
            color: hsla(0.7, 0.8, 0.3, 0.7).into(),
            element_bounds: box_bounds,
            element_corner_radii: Corners::all(ScaledPixels(2.0)),
            inset: gpui::ShaderBool::Disabled,
            corner_smoothing: 0.0,
        });
        shadow.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &shadow,
            Size {
                width: DevicePixels(16),
                height: DevicePixels(16),
            },
        ) else {
            return;
        };
        let center = pixel(&image, 8, 8);
        let corner = pixel(&image, 0, 0);
        assert!(
            center[0] > 10,
            "shadow covers the element center: {center:?}",
        );
        assert!(
            corner[0] < 5,
            "shadow falls off to clear at the corner: {corner:?}",
        );
        assert!(
            center[0] > corner[0],
            "shadow has a coverage ramp: center {center:?}, corner {corner:?}",
        );
        // The opaque headless target composites over black, so alpha stays 1.
        assert_eq!(center[3], 255, "shadow center alpha: {center:?}");
        assert_eq!(corner[3], 255, "shadow corner alpha: {corner:?}");
    }

    #[test]
    fn generated_blur_shader_softens_backdrop() {
        let mut renderer = MetalHeadlessRenderer::new();
        let full = Bounds {
            origin: gpui::point(ScaledPixels(0.0), ScaledPixels(0.0)),
            size: Size {
                width: ScaledPixels(16.0),
                height: ScaledPixels(16.0),
            },
        };
        let box_bounds = Bounds {
            origin: gpui::point(ScaledPixels(4.0), ScaledPixels(4.0)),
            size: Size {
                width: ScaledPixels(8.0),
                height: ScaledPixels(8.0),
            },
        };
        let mut filter = Scene::default();
        filter.insert_primitive(Quad {
            bounds: full,
            content_mask: ContentMask {
                bounds: full,
                ..Default::default()
            },
            background: checkerboard(hsla(0.2, 0.7, 0.5, 1.0), 2.0),
            ..Default::default()
        });
        filter.insert_primitive(BackdropFilter {
            bounds: box_bounds,
            content_mask: ContentMask {
                bounds: full,
                ..Default::default()
            },
            corner_radii: Corners::all(ScaledPixels(2.0)),
            filters: smallvec::smallvec![ScaledFilter::Blur(ScaledPixels(1.0))],
            opacity: 0.8,
            ..Default::default()
        });
        filter.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &filter,
            Size {
                width: DevicePixels(16),
                height: DevicePixels(16),
            },
        ) else {
            return;
        };
        // Outside the filter region the checkerboard is untouched.
        assert_pixel_close(&image, 0, 0, [0, 0, 0, 255], 1, "unfiltered off-square");
        assert_pixel_close(&image, 2, 0, [181, 217, 38, 255], 2, "unfiltered on-square");
        // Inside, the blur must mix neighbors: neither sharp nor clear.
        let soft = pixel(&image, 8, 8);
        let sharp = [181, 217, 38, 255];
        assert_ne!(
            soft,
            [0, 0, 0, 255],
            "blurred texel mixes content: {soft:?}"
        );
        let drift = soft
            .iter()
            .zip(sharp.iter())
            .map(|(observed, reference)| observed.abs_diff(*reference))
            .max()
            .unwrap_or(0);
        assert!(
            drift >= 15,
            "blur mixes neighboring texels instead of passing through: {soft:?}",
        );
    }

    #[test]
    fn generated_sprite_shader_blends_opacity() {
        let mut renderer = MetalHeadlessRenderer::new();
        let key = AtlasKey::Image(RenderImageParams {
            image_id: ImageId(0),
            frame_index: 0,
        });
        let tile = renderer
            .sprite_atlas()
            .get_or_insert_with(&key, &mut || {
                Ok(Some((
                    Size {
                        width: DevicePixels(2),
                        height: DevicePixels(2),
                    },
                    Cow::Borrowed(&[
                        0, 0, 255, 255, 0, 255, 0, 255, 255, 0, 0, 255, 255, 255, 255, 255,
                    ]),
                )))
            })
            .unwrap()
            .unwrap();
        let sprite_bounds = Bounds {
            origin: gpui::point(ScaledPixels(1.0), ScaledPixels(1.0)),
            size: Size {
                width: ScaledPixels(6.0),
                height: ScaledPixels(6.0),
            },
        };
        let mut sprite = Scene::default();
        sprite.insert_primitive(PolychromeSprite {
            order: 0,
            grayscale: gpui::ShaderBool::Disabled,
            opacity: 0.75,
            corner_smoothing: 0.0,
            bounds: sprite_bounds,
            content_mask: ContentMask {
                bounds: sprite_bounds,
                ..Default::default()
            },
            corner_radii: Corners::all(ScaledPixels(1.0)),
            tile,
        });
        sprite.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &sprite,
            Size {
                width: DevicePixels(8),
                height: DevicePixels(8),
            },
        ) else {
            return;
        };
        assert_pixel_close(
            &image,
            0,
            0,
            [0, 0, 0, 255],
            1,
            "outside the sprite stays clear",
        );
        // Texel centers sample exactly, so the red and white texels must land
        // at 75% opacity (255 * 0.75 = 191.25 -> 191).
        assert_pixel_close(
            &image,
            2,
            2,
            [191, 0, 0, 255],
            2,
            "red texel at 75% opacity",
        );
        assert_pixel_close(
            &image,
            5,
            5,
            [191, 191, 191, 255],
            2,
            "white texel at 75% opacity",
        );
        // The 2x2 tile holds saturated texels, so the sprite interior must be
        // lit but capped by the 75% opacity (a full white texel lands at 191).
        let mut sum = [0u64; 3];
        let mut count = 0u64;
        let mut brightest = 0u8;
        for y in 2..6 {
            for x in 2..6 {
                let texel = pixel(&image, x, y);
                for channel in 0..3 {
                    sum[channel] += u64::from(texel[channel]);
                    brightest = brightest.max(texel[channel]);
                }
                count += 1;
            }
        }
        let mean = [sum[0] / count, sum[1] / count, sum[2] / count];
        for (channel, level) in mean.iter().enumerate() {
            assert!(
                (40..=200).contains(level),
                "sprite interior channel {channel} looks sampled and blended, not degenerate: {mean:?}",
            );
        }
        assert!(
            (150..=195).contains(&brightest),
            "75% opacity caps the brightest texel near 191, got {brightest}",
        );
    }

    #[test]
    fn generated_path_shader_fills_and_antialiases() {
        let mut renderer = MetalHeadlessRenderer::new();
        let mut path = Path::new(gpui::point(px(1.0), px(1.0)));
        path.line_to(gpui::point(px(7.0), px(1.0)));
        path.line_to(gpui::point(px(4.0), px(7.0)));
        path.line_to(gpui::point(px(1.0), px(1.0)));
        path.content_mask = ContentMask {
            bounds: Bounds {
                origin: gpui::point(px(0.0), px(0.0)),
                size: Size {
                    width: px(8.0),
                    height: px(8.0),
                },
            },
            ..Default::default()
        };
        path.color = solid_background(hsla(0.45, 0.9, 0.45, 1.0));
        let mut path_scene = Scene::default();
        path_scene.insert_primitive(path.scale(1.0));
        path_scene.finish();
        let Some(image) = render_for_contracts(
            &mut renderer,
            &path_scene,
            Size {
                width: DevicePixels(8),
                height: DevicePixels(8),
            },
        ) else {
            return;
        };
        assert_pixel_close(
            &image,
            4,
            2,
            [11, 218, 156, 255],
            2,
            "triangle interior fill",
        );
        assert_pixel_close(
            &image,
            0,
            7,
            [0, 0, 0, 255],
            1,
            "outside the triangle stays clear",
        );
        // MSAA edges must produce partially covered texels: strictly between
        // clear and the fill color along the green channel.
        assert!(
            image.pixels().any(|texel| {
                let g = texel.0[1];
                g > 20 && g < 200 && texel.0[0] < 11
            }),
            "triangle edges are antialiased",
        );
    }
=======
    use objc2_core_foundation::{CFDictionary, CFType};
    use objc2_core_video::{
        CVPixelBufferCreate, CVPixelBufferGetBaseAddressOfPlane,
        CVPixelBufferGetBytesPerRowOfPlane, CVPixelBufferLockBaseAddress, CVPixelBufferLockFlags,
        CVPixelBufferUnlockBaseAddress, kCVPixelBufferIOSurfacePropertiesKey,
    };

    #[test]
    fn render_core_video_surface() {
        let attributes = CFDictionary::from_slices(
            &[unsafe { kCVPixelBufferIOSurfacePropertiesKey }],
            &[&*CFDictionary::<CFType, CFType>::empty()],
        );
        let mut image_buffer = ptr::null_mut();
        assert_eq!(
            unsafe {
                CVPixelBufferCreate(
                    None,
                    16,
                    16,
                    kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                    Some(attributes.as_opaque()),
                    ptr::NonNull::from(&mut image_buffer),
                )
            },
            kCVReturnSuccess
        );
        let image_buffer =
            unsafe { CFRetained::from_raw(ptr::NonNull::new(image_buffer).unwrap()) };
        unsafe {
            assert_eq!(
                CVPixelBufferLockBaseAddress(&image_buffer, CVPixelBufferLockFlags::empty()),
                kCVReturnSuccess
            );
            for plane in 0..2 {
                let bytes = CVPixelBufferGetBaseAddressOfPlane(&image_buffer, plane).cast::<u8>();
                let length = CVPixelBufferGetBytesPerRowOfPlane(&image_buffer, plane)
                    * CVPixelBufferGetHeightOfPlane(&image_buffer, plane);
                slice::from_raw_parts_mut(bytes, length).fill(128);
            }
            assert_eq!(
                CVPixelBufferUnlockBaseAddress(&image_buffer, CVPixelBufferLockFlags::empty()),
                kCVReturnSuccess
            );
        }

        let bounds = Bounds {
            origin: Point::default(),
            size: size(ScaledPixels(16.0), ScaledPixels(16.0)),
        };
        let mut scene = Scene::default();
        scene.insert_primitive(PaintSurface {
            order: 0,
            bounds,
            content_mask: ContentMask { bounds },
            image_buffer: image_buffer.clone(),
        });
        drop(image_buffer);
        scene.finish();

        let mut renderer = MetalRenderer::new_headless(Arc::new(Mutex::new(Default::default())));
        let image = renderer
            .render_scene_to_image(&scene, size(DevicePixels(16), DevicePixels(16)))
            .unwrap();
        for image::Rgba([red, green, blue, alpha]) in image.pixels() {
            assert!(red.abs_diff(128) <= 2);
            assert!(green.abs_diff(128) <= 2);
            assert!(blue.abs_diff(128) <= 2);
            assert_eq!(*alpha, 255);
        }
    }
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
}
