/// Shader-declared data that can be uploaded without serialization.
///
/// # Safety
/// Implementors need a stable C-compatible layout, no implicit padding, fully initialized bytes,
/// and fields matching the WGSL declaration at the same offsets.
pub unsafe trait BufferData: Sized {
    /// Name of the matching WGSL structure.
    const WGSL_TYPE: &'static str;
}

/// Rust stride and WGSL name for one uploaded storage record.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct StorageAbi {
    /// Matching WGSL type name.
    pub wgsl_type: &'static str,
    /// Rust byte stride uploaded for each record.
    pub rust_stride: usize,
}

/// Returns the WGSL name and Rust stride needed to upload `T` as a record.
pub const fn storage_abi<T: BufferData>() -> StorageAbi {
    StorageAbi {
        wgsl_type: T::WGSL_TYPE,
        rust_stride: std::mem::size_of::<T>(),
    }
}

/// Views one ABI-compatible value as bytes without allocating or copying it.
///
/// The returned slice borrows `value` and is safe to upload only because
/// [`BufferData`] requires initialized bytes with the matching shader layout.
pub fn bytes_of<T: BufferData>(value: &T) -> &[u8] {
    unsafe {
        std::slice::from_raw_parts(
            std::ptr::from_ref(value).cast::<u8>(),
            std::mem::size_of::<T>(),
        )
    }
}

/// Views a contiguous slice of ABI-compatible values as bytes without copying.
///
/// The output length is `values.len() * size_of::<T>()`, and it borrows the
/// input slice.
pub fn slice_as_bytes<T: BufferData>(values: &[T]) -> &[u8] {
    unsafe {
        std::slice::from_raw_parts(values.as_ptr().cast::<u8>(), std::mem::size_of_val(values))
    }
}

/// Views of scene data consumed by a pipeline.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub enum DataLayout {
    /// Primitive records uploaded from an instance buffer.
    Instances,
    /// Instance records that also sample a primary texture.
    TexturedInstances,
    /// Monochrome glyph or image records with atlas-specific sampling.
    MonochromeSprites,
    /// Subpixel-coverage glyph records with atlas-specific sampling.
    SubpixelSprites,
    /// Data assembled by the backend rather than uploaded from a scene array.
    NativeOnly,
    /// A backend-owned surface and its per-surface uniforms.
    Surface,
    /// Fullscreen blur-pass uniforms and source textures.
    Blur,
}

/// Vertex-count policy for one draw call.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum VertexCount {
    /// A four-vertex rectangle or rectangle strip.
    Rectangle,
    /// A three-vertex fullscreen triangle.
    FullscreenTriangle,
    /// A count supplied by the draw's data, as in path rasterization.
    Dynamic,
}

/// Primitive topology submitted to WGPU.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum PrimitiveTopology {
    /// Independent groups of three vertices.
    TriangleList,
    /// Connected groups of three vertices with alternating winding.
    TriangleStrip,
}

impl VertexCount {
    /// Returns the fixed count, or `None` for dynamically sized draws.
    pub const fn fixed(self) -> Option<u32> {
        match self {
            Self::Rectangle => Some(RECTANGLE_VERTEX_COUNT),
            Self::FullscreenTriangle => Some(FULLSCREEN_TRIANGLE_VERTEX_COUNT),
            Self::Dynamic => None,
        }
    }
}

/// Generated pipeline entry points and their instance transport contract.
#[derive(Clone, Copy)]
pub struct Pipeline {
    /// Stable pipeline label.
    pub label: &'static str,
    /// Vertex entry-point name.
    pub vertex_entry: &'static str,
    /// Fragment entry-point name.
    pub fragment_entry: &'static str,
    /// Primitive topology used by the pipeline.
    pub topology: PrimitiveTopology,
    /// Host data transport selected for the pipeline.
    pub data_layout: DataLayout,
    /// Fixed or dynamic vertex count.
    pub vertex_count: VertexCount,
}

macro_rules! define_pipelines {
        ($($name:ident: $label:literal, $vertex:ident, $fragment:ident, $topology:ident, $layout:ident, $vertices:ident;)*) => {
            $(
                #[doc = "Pipeline entry points and upload contract for this shader pair."]
                pub const $name: Pipeline = Pipeline {
                    label: $label,
                    vertex_entry: stringify!($vertex),
                    fragment_entry: stringify!($fragment),
                    topology: PrimitiveTopology::$topology,
                    data_layout: DataLayout::$layout,
                    vertex_count: VertexCount::$vertices,
                };
            )*

            /// Every generated GPUI pipeline in this module.
            pub const ALL: &[Pipeline] = &[$($name),*];
        };
    }

define_pipelines! {
    QUADS: "quads", vertex_quad, fragment_quad, TriangleStrip, Instances, Rectangle;
    SMOOTHED_QUADS: "smoothed_quads", vertex_smoothed_quad, fragment_smoothed_quad, TriangleStrip, Instances, Rectangle;
    SHADOWS: "shadows", vertex_shadow, fragment_shadow, TriangleStrip, Instances, Rectangle;
    SMOOTHED_SHADOWS: "smoothed_shadows", vertex_smoothed_shadow, fragment_smoothed_shadow, TriangleStrip, Instances, Rectangle;
    PATH_RASTERIZATION: "path_rasterization", vertex_path_rasterization, fragment_path_rasterization, TriangleList, Instances, Dynamic;
    PATHS: "paths", vertex_path, fragment_path, TriangleStrip, TexturedInstances, Rectangle;
    UNDERLINES: "underlines", vertex_underline, fragment_underline, TriangleStrip, Instances, Rectangle;
    MONOCHROME_SPRITES: "monochrome_sprites", vertex_monochrome_sprite, fragment_monochrome_sprite, TriangleStrip, MonochromeSprites, Rectangle;
    SUBPIXEL_SPRITES: "subpixel_sprites", vertex_subpixel_sprite, fragment_subpixel_sprite, TriangleStrip, SubpixelSprites, Rectangle;
    POLYCHROME_SPRITES: "polychrome_sprites", vertex_polychrome_sprite, fragment_polychrome_sprite, TriangleStrip, TexturedInstances, Rectangle;
    SMOOTHED_POLYCHROME_SPRITES: "smoothed_polychrome_sprites", vertex_smoothed_polychrome_sprite, fragment_smoothed_polychrome_sprite, TriangleStrip, TexturedInstances, Rectangle;
    SURFACES: "surfaces", vertex_surface, fragment_surface, TriangleStrip, Surface, Rectangle;
    BLUR_DOWNSAMPLE: "blur_downsample", vertex_blur_fullscreen, fragment_blur_downsample, TriangleList, Blur, FullscreenTriangle;
    BLUR: "blur", vertex_blur_fullscreen, fragment_blur, TriangleList, Blur, FullscreenTriangle;
    BLUR_COMPOSITE: "blur_composite", vertex_blur_composite, fragment_blur_composite, TriangleStrip, Blur, Rectangle;
    SMOOTHED_BLUR_COMPOSITE: "smoothed_blur_composite", vertex_smoothed_blur_composite, fragment_smoothed_blur_composite, TriangleStrip, Blur, Rectangle;
}

/// Pipeline metadata for rasterizing an emoji into a native atlas texture.
pub const EMOJI_RASTERIZATION: Pipeline = Pipeline {
    label: "emoji_rasterization",
    vertex_entry: "vertex_emoji_rasterization",
    fragment_entry: "fragment_emoji_rasterization",
    topology: PrimitiveTopology::TriangleStrip,
    data_layout: DataLayout::NativeOnly,
    vertex_count: VertexCount::Rectangle,
};

/// Bind-group index for frame-global uniforms.
pub const GLOBAL_BIND_GROUP: u32 = 0;
/// Bind-group index for per-pipeline data and textures.
pub const DATA_BIND_GROUP: u32 = 1;
/// Binding index of [`GlobalUniforms`](super::common::GlobalUniforms).
pub const GLOBAL_UNIFORMS_BINDING: u32 = 0;
/// Binding index of font-rasterization uniforms.
pub const FONT_RASTERIZATION_BINDING: u32 = 1;
/// Binding index of the primary scene-data buffer.
pub const DATA_BUFFER_BINDING: u32 = 0;
/// Binding index of the primary sampled texture.
pub const PRIMARY_TEXTURE_BINDING: u32 = 1;
/// Binding index of the secondary sampled texture.
pub const SECONDARY_TEXTURE_BINDING: u32 = 2;
/// Binding index of the primary texture sampler.
pub const PRIMARY_SAMPLER_BINDING: u32 = 2;
/// Binding index of the sampler used for backend-owned surfaces.
pub const SURFACE_SAMPLER_BINDING: u32 = 3;
/// Number of vertices in a rectangle draw.
pub const RECTANGLE_VERTEX_COUNT: u32 = 4;
/// Number of vertices in a fullscreen triangle draw.
pub const FULLSCREEN_TRIANGLE_VERTEX_COUNT: u32 = 3;
/// D3D11 constant-buffer register of the per-draw instance base for instanced pipelines.
/// Group-0 cbuffers occupy b0 and b1, and the group-1 uniform lands on b2.
pub const DX11_DRAW_CONSTANTS_REGISTER: u32 = 3;

macro_rules! buffer_data {
        ($($rust:ty => $wgsl:literal),* $(,)?) => {
            $(
                unsafe impl BufferData for $rust {
                    const WGSL_TYPE: &'static str = $wgsl;
                }
            )*
        };
    }

buffer_data! {
    super::common::GlobalUniforms => "GlobalUniforms",
    super::common::FontRasterizationUniforms => "FontRasterizationUniforms",
    super::surface::SurfaceUniforms => "SurfaceUniforms",
    super::blur::BlurUniforms => "BlurUniforms",
    gpui::Quad => "Quad",
    gpui::Shadow => "Shadow",
    gpui::Underline => "Underline",
    gpui::MonochromeSprite => "MonochromeSprite",
    gpui::SubpixelSprite => "SubpixelSprite",
    gpui::PolychromeSprite => "PolychromeSprite",
}

/// Storage-buffer layouts for scene records uploaded by the render pipelines.
pub const SCENE_STORAGE_ABI: &[StorageAbi] = &[
    storage_abi::<gpui::Quad>(),
    storage_abi::<gpui::Shadow>(),
    storage_abi::<gpui::Underline>(),
    storage_abi::<gpui::MonochromeSprite>(),
    storage_abi::<gpui::SubpixelSprite>(),
    storage_abi::<gpui::PolychromeSprite>(),
];

macro_rules! render_layout {
    ($ty:ty, $name:literal, $($field:ident),+ $(,)?) => {
        gpui::SceneBufferLayout {
            name: $name,
            size: std::mem::size_of::<$ty>(),
            fields: &[$((stringify!($field), std::mem::offset_of!($ty, $field))),+],
        }
    };
}

#[doc(hidden)]
pub const RENDER_BUFFER_LAYOUTS: &[gpui::SceneBufferLayout] = &[
    render_layout!(
        super::common::GlobalUniforms,
        "GlobalUniforms",
        viewport_size,
        premultiplied_alpha,
        padding
    ),
    render_layout!(
        super::common::FontRasterizationUniforms,
        "FontRasterizationUniforms",
        gamma_ratios,
        grayscale_enhanced_contrast,
        subpixel_enhanced_contrast,
        uses_blue_green_red_subpixel_order,
        padding
    ),
    render_layout!(
        super::surface::SurfaceUniforms,
        "SurfaceUniforms",
        bounds,
        content_mask,
        color_format,
        opacity,
        padding0,
        padding1,
        padding2,
        padding3,
        padding4,
        padding5
    ),
    render_layout!(
        super::blur::BlurUniforms,
        "BlurUniforms",
        bounds,
        content_mask,
        corner_radii,
        direction,
        standard_deviation,
        opacity,
        sample_count,
        sample_step,
        composite_clip,
        downsample_mode,
        source_size,
        target_size,
        corner_smoothing,
        padding0,
        padding1,
        padding2
    ),
    render_layout!(crate::path_types::PathSprite, "PathSprite", bounds),
    render_layout!(
        crate::path_types::PathRasterizationVertex,
        "PathRasterizationVertex",
        xy_position,
        curve_position,
        color,
        bounds
    ),
];
