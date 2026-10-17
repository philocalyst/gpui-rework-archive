use std::{
    borrow::Cow,
    collections::hash_map::Entry,
    ffi::{c_uint, c_void},
    marker::PhantomData,
    mem::ManuallyDrop,
    rc::Rc,
    sync::Arc,
};

use anyhow::{Context as _, Result, ensure};
use collections::HashMap;
use gpui::{
    Bounds, DevicePixels, Font, FontId, FontMetrics, GlyphId, GlyphRenderMode, InlineLayout,
    InlineLayoutRequest, LineLayout, Pixels, PlatformTextSystem, PreparedRasterStyle,
    RasterColorEffect, RasterStyleRequest, RasterizedGlyph, RenderGlyphParams, Rgba8,
    SUBPIXEL_VARIANTS_X, SUBPIXEL_VARIANTS_Y, Size, TextLayoutRequest, TextRenderingMode, point,
    size,
};
use gpui_parley::{
    BitmapFallbackGlyphRasterizer, ColorGlyphKind, FontDataBlob, GlyphRasterizer, ParleyTextSystem,
    RasterFace, SystemFonts,
};
use parking_lot::RwLock;
use windows::{
    Win32::{
        Foundation::*,
        Graphics::{
            Direct2D::{Common::*, *},
            DirectWrite::*,
            Dxgi::Common::*,
            Imaging::*,
        },
        System::Com::*,
        UI::WindowsAndMessaging::*,
    },
    core::*,
};
use windows_numerics::{Matrix3x2, Vector2};

use crate::*;

pub(crate) struct DirectWriteTextSystem {
    parley: ParleyTextSystem,
    renderer: Arc<RwLock<DirectWriteGlyphRenderer>>,
}

#[derive(Clone)]
struct SharedDirectWriteRenderer(Arc<RwLock<DirectWriteGlyphRenderer>>);

struct DirectWriteGlyphRenderer {
    components: DirectWriteComponents,
    variable_factory: Option<IDWriteFactory6>,
    rendering_params: IDWriteRenderingParams,
    faces: HashMap<FontId, NativeFace>,
    sources: HashMap<u64, NativeSource>,
    system_subpixel_rendering: bool,
}

struct DirectWriteComponents {
    factory: IDWriteFactory5,
    in_memory_loader: IDWriteInMemoryFontFileLoader,
}

struct NativeFace {
    face: IDWriteFontFace3,
}

<<<<<<< HEAD
struct NativeSource {
    file: IDWriteFontFile,
=======
struct DirectWriteState {
    /// Used to rasterize color glyphs. `None` while the platform is headless: shaping and
    /// layout don't need a GPU, and nothing is drawn.
    gpu_state: Option<GPUState>,
    system_font_collection: IDWriteFontCollection1,
    custom_font_collection: IDWriteFontCollection1,
    fonts: Vec<FontInfo>,
    font_to_font_id: HashMap<Font, FontId>,
    font_info_cache: HashMap<usize, FontId>,
    layout_line_scratch: Vec<u16>,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
}

#[windows_core::implement()]
struct FontDataOwner {
    _data: FontDataBlob<u8>,
}

impl DirectWriteTextSystem {
<<<<<<< HEAD
    pub(crate) fn new(directx_devices: &DirectXDevices) -> Result<Self> {
        Self::new_inner(Some(directx_devices))
    }

    pub(crate) fn new_headless() -> Result<Self> {
        Self::new_inner(None)
    }
=======
    /// Creates the text system, able to rasterize color glyphs once it has `directx_devices`.
    pub(crate) fn new(directx_devices: Option<&DirectXDevices>) -> Result<Self> {
        let factory: IDWriteFactory5 = unsafe { DWriteCreateFactory(DWRITE_FACTORY_TYPE_SHARED)? };
        // The `IDWriteInMemoryFontFileLoader` here is supported starting from
        // Windows 10 Creators Update, which consequently requires the entire
        // `DirectWriteTextSystem` to run on `win10 1703`+.
        let in_memory_loader = unsafe { factory.CreateInMemoryFontFileLoader()? };
        unsafe { factory.RegisterFontFileLoader(&in_memory_loader)? };
        let builder = unsafe { factory.CreateFontSetBuilder()? };
        let mut locale = [0u16; LOCALE_NAME_MAX_LENGTH as usize];
        unsafe { GetUserDefaultLocaleName(&mut locale) };
        let locale = HSTRING::from_wide(&locale);
        let text_renderer = TextRendererWrapper::new(locale.clone());

        let gpu_state = directx_devices.map(GPUState::new).transpose()?;
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

    fn new_inner(directx_devices: Option<&DirectXDevices>) -> Result<Self> {
        let renderer = Arc::new(RwLock::new(DirectWriteGlyphRenderer::new(directx_devices)?));
        let parley = ParleyTextSystem::new_with_rasterizer(
            SystemFonts::Load,
            "Segoe UI",
            BitmapFallbackGlyphRasterizer::new(SharedDirectWriteRenderer(renderer.clone())),
        )
        .with_fallback_families(["Lilex", "IBM Plex Sans", "Arial"]);

        Ok(Self { parley, renderer })
    }

    /// Uses `directx_devices` to rasterize color glyphs, replacing any previous devices, for
    /// example after the device was lost.
    pub(crate) fn handle_gpu_lost(&self, directx_devices: &DirectXDevices) -> Result<()> {
        self.renderer.write().handle_gpu_lost(directx_devices)
    }

    /// Releases the GPU state, when the platform switches to headless mode.
    pub(crate) fn release_gpu(&self) {
        self.state.write().gpu_state = None;
    }
}

impl PlatformTextSystem for DirectWriteTextSystem {
    fn add_fonts(&self, fonts: Vec<Cow<'static, [u8]>>) -> Result<()> {
        self.parley.add_fonts(fonts)
    }

    fn all_font_names(&self) -> Vec<String> {
        self.parley.all_font_names()
    }

    fn font_generation(&self) -> u64 {
        self.parley.font_generation()
    }

    fn font_id(&self, descriptor: &Font) -> Result<FontId> {
        self.parley.font_id(descriptor)
    }

    fn prewarm_fonts(&self, font_ids: &[FontId]) {
        self.parley.prewarm_fonts(font_ids);
    }

    fn font_metrics(&self, font_id: FontId) -> FontMetrics {
        self.parley.font_metrics(font_id)
    }

    fn typographic_bounds(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Bounds<f32>> {
        self.parley.typographic_bounds(font_id, glyph_id)
    }

    fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>> {
        self.parley.advance(font_id, glyph_id)
    }

    fn glyph_for_char(&self, font_id: FontId, character: char) -> Option<GlyphId> {
        self.parley.glyph_for_char(font_id, character)
    }

    fn rasterize_glyph(&self, params: &RenderGlyphParams) -> Result<RasterizedGlyph> {
        self.parley.rasterize_glyph(params)
    }

    fn prepare_raster_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
        self.parley.prepare_raster_style(request)
    }

    fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout {
        self.parley.layout_text(request)
    }

    fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout {
        self.parley.layout_inline(request)
    }

    fn recommended_rendering_mode(&self, font_id: FontId, font_size: Pixels) -> TextRenderingMode {
        self.parley.recommended_rendering_mode(font_id, font_size)
    }
}

impl GlyphRasterizer for SharedDirectWriteRenderer {
    fn supports_color_glyph(&self, kind: ColorGlyphKind) -> bool {
        self.0.read().supports_color_glyph(kind)
    }

    fn prepare_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
        self.0.read().prepare_style(request)
    }

    fn rasterize(
        &mut self,
        face: RasterFace<'_>,
        params: &RenderGlyphParams,
    ) -> Result<RasterizedGlyph> {
        self.0.write().rasterize(face, params)
    }

    fn recommended_mode(&self) -> TextRenderingMode {
        self.0.read().recommended_mode()
    }
}

impl DirectWriteGlyphRenderer {
    fn new(_directx_devices: Option<&DirectXDevices>) -> Result<Self> {
        let factory: IDWriteFactory5 = unsafe { DWriteCreateFactory(DWRITE_FACTORY_TYPE_SHARED) }
            .context("creating the DirectWrite factory")?;
        let variable_factory = factory.cast().ok();
        let in_memory_loader = unsafe { factory.CreateInMemoryFontFileLoader() }
            .context("creating the DirectWrite in-memory font loader")?;
        unsafe { factory.RegisterFontFileLoader(&in_memory_loader) }
            .context("registering the DirectWrite in-memory font loader")?;
        let rendering_params = unsafe { factory.CreateRenderingParams() }
            .context("reading DirectWrite rendering parameters")?;

        Ok(Self {
            components: DirectWriteComponents {
                factory,
                in_memory_loader,
            },
            variable_factory,
            rendering_params,
            faces: HashMap::default(),
            sources: HashMap::default(),
            system_subpixel_rendering: get_system_subpixel_rendering(),
        })
    }

    fn load_face(&mut self, face: RasterFace<'_>) -> Result<()> {
        let Entry::Vacant(entry) = self.faces.entry(face.font_id) else {
            return Ok(());
        };
        let factory = &self.components.factory;
        let loader = &self.components.in_memory_loader;
        let variable_factory = self.variable_factory.as_ref();
        let use_default_axes = face.variations.is_empty()
            || (variable_factory.is_none() && face.has_default_variations()?);

        ensure!(
            use_default_axes || variable_factory.is_some(),
            "this DirectWrite version cannot instantiate the selected variable-font coordinates"
        );

        let source = match self.sources.entry(face.source_id) {
            Entry::Occupied(entry) => entry.into_mut(),
            Entry::Vacant(entry) => entry.insert(
                NativeSource::new(factory, loader, face.source)
                    .context("DirectWrite could not retain the font source")?,
            ),
        };
        let native = NativeFace::new(
            factory,
            variable_factory,
            &source.file,
            &face,
            use_default_axes,
        )
        .with_context(|| {
            format!(
                "DirectWrite could not create FontId {:?}, face index {}, variations {:?}",
                face.font_id, face.face_index, face.variations
            )
        })?;
        entry.insert(native);

        Ok(())
    }

    fn create_glyph_run_analysis(
        &self,
        params: &RenderGlyphParams,
    ) -> Result<IDWriteGlyphRunAnalysis> {
        let font = &self.faces[&params.font_id];
        let glyph_id = [params.glyph_id.0 as u16];
        let advance = [0.0];
        let offset = [DWRITE_GLYPH_OFFSET::default()];
        let glyph_run = DWRITE_GLYPH_RUN {
            fontFace: ManuallyDrop::new(Some(unsafe { std::ptr::read(&***font.face) })),
            fontEmSize: params.font_size.as_f32(),
            glyphCount: 1,
            glyphIndices: glyph_id.as_ptr(),
            glyphAdvances: advance.as_ptr(),
            glyphOffsets: offset.as_ptr(),
            isSideways: BOOL(0),
            bidiLevel: 0,
        };
        let transform = DWRITE_MATRIX {
            m11: params.scale_factor,
            m12: 0.0,
            m21: 0.0,
            m22: params.scale_factor,
            dx: 0.0,
            dy: 0.0,
        };
        let baseline_origin_x =
            params.subpixel_variant.x as f32 / SUBPIXEL_VARIANTS_X as f32 / params.scale_factor;
        let baseline_origin_y = params.subpixel_variant.y as f32
            / gpui::SUBPIXEL_VARIANTS_Y as f32
            / params.scale_factor;

        let mut rendering_mode = DWRITE_RENDERING_MODE1::default();
        let mut grid_fit_mode = DWRITE_GRID_FIT_MODE::default();
        unsafe {
            font.face.GetRecommendedRenderingMode(
                params.font_size.as_f32(),
                // Using 96 as scale is applied by the transform
                96.0,
                96.0,
                Some(&transform),
                false,
                DWRITE_OUTLINE_THRESHOLD_ANTIALIASED,
                DWRITE_MEASURING_MODE_NATURAL,
                Some(&self.rendering_params),
                &mut rendering_mode,
                &mut grid_fit_mode,
            )?;
        }
        let rendering_mode = match rendering_mode {
            DWRITE_RENDERING_MODE1_OUTLINE => DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC,
            m => m,
        };

        let antialias_mode = if params.raster_style.mode == GlyphRenderMode::Subpixel {
            DWRITE_TEXT_ANTIALIAS_MODE_CLEARTYPE
        } else {
            DWRITE_TEXT_ANTIALIAS_MODE_GRAYSCALE
        };

        let glyph_analysis = unsafe {
            self.components.factory.CreateGlyphRunAnalysis(
                &glyph_run,
                Some(&transform),
                rendering_mode,
                DWRITE_MEASURING_MODE_NATURAL,
                grid_fit_mode,
                antialias_mode,
                baseline_origin_x,
                baseline_origin_y,
            )
        }?;
        Ok(glyph_analysis)
    }

    fn rasterize_monochrome(
        &self,
        glyph_analysis: &IDWriteGlyphRunAnalysis,
        texture_type: DWRITE_TEXTURE_TYPE,
        native_bounds: RECT,
    ) -> Result<Vec<u8>> {
        let width = (native_bounds.right - native_bounds.left) as usize;
        let height = (native_bounds.bottom - native_bounds.top) as usize;
        let pixel_count = width * height;
        let subpixel = texture_type == DWRITE_TEXTURE_CLEARTYPE_3x1;
        let native_channels = if subpixel { 3 } else { 1 };
        let output_channels = if subpixel { 4 } else { 1 };
        let mut bitmap_data = vec![0u8; pixel_count * output_channels];

        unsafe {
            glyph_analysis.CreateAlphaTexture(
                texture_type,
                &native_bounds,
                &mut bitmap_data[..pixel_count * native_channels],
            )?;
        }

        if !subpixel {
            return Ok(bitmap_data);
        }

        // The output buffer expects RGBA data, so pad the alpha channel with zeros.
        for pixel_ix in (0..pixel_count).rev() {
            let src = pixel_ix * 3;
            let dst = pixel_ix * 4;
            (
                bitmap_data[dst + 2],
                bitmap_data[dst + 1],
                bitmap_data[dst],
                bitmap_data[dst + 3],
            ) = (
                bitmap_data[src],
                bitmap_data[src + 1],
                bitmap_data[src + 2],
                0,
            );
        }

        Ok(bitmap_data)
    }

    fn rasterize_glyph(
        &self,
        params: &RenderGlyphParams,
<<<<<<< HEAD
        glyph_analysis: &IDWriteGlyphRunAnalysis,
        texture_type: DWRITE_TEXTURE_TYPE,
        native_bounds: RECT,
    ) -> Result<RasterizedGlyph> {
        let glyph_bounds = if native_bounds.right <= native_bounds.left
            || native_bounds.bottom <= native_bounds.top
        {
            Bounds::default()
        } else {
            Bounds {
                origin: point(native_bounds.left.into(), native_bounds.top.into()),
                size: size(
                    (native_bounds.right - native_bounds.left).into(),
                    (native_bounds.bottom - native_bounds.top).into(),
                ),
            }
=======
        glyph_bounds: Bounds<DevicePixels>,
    ) -> Result<Vec<u8>> {
        // INVARIANT: the code below drives the *shared* D3D11 immediate context
        // (`Map`/`Unmap`/`Draw`/`CopyResource`), which `DirectXRenderer` and `DirectXAtlas` also
        // touch. An immediate `ID3D11DeviceContext` is not thread-safe, so this must only run on
        // the main UI thread (which it always is; text rasterization never leaves that thread).
        let gpu_state = self
            .gpu_state
            .as_ref()
            .context("rasterizing color glyphs needs a GPU, which headless mode has none of")?;
        let bitmap_size = glyph_bounds.size;
        let subpixel_shift = params
            .subpixel_variant
            .map(|v| v as f32 / SUBPIXEL_VARIANTS_X as f32);
        let baseline_origin_x = subpixel_shift.x / params.scale_factor;
        let baseline_origin_y = subpixel_shift.y / params.scale_factor;

        let transform = DWRITE_MATRIX {
            m11: params.scale_factor,
            m12: 0.0,
            m21: 0.0,
            m22: params.scale_factor,
            dx: 0.0,
            dy: 0.0,
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        };

        if params.raster_style.mode == GlyphRenderMode::Color {
            if let Ok(color) = self.rasterize_color(params, glyph_bounds) {
                return Ok(color);
            }
        }

        let format = params.raster_style.mode.rasterized_format();

        if glyph_bounds.size.width.0 == 0 || glyph_bounds.size.height.0 == 0 {
            return Ok(RasterizedGlyph::empty(format));
        }

        let mut pixels = self.rasterize_monochrome(glyph_analysis, texture_type, native_bounds)?;

        if params.raster_style.mode == GlyphRenderMode::Color {
            let foreground = raster_foreground(params.raster_style);

            if foreground.alpha == 0 {
                return Ok(RasterizedGlyph::empty(format));
            }

            pixels = pixels
                .into_iter()
                .flat_map(|coverage| {
                    let alpha = ((coverage as u16 * foreground.alpha as u16 + 127) / 255) as u8;

                    if alpha == 0 {
                        [0; 4]
                    } else {
                        [foreground.blue, foreground.green, foreground.red, alpha]
                    }
                })
                .collect();
        }

        let rasterized = RasterizedGlyph {
            bounds: glyph_bounds,
            size: glyph_bounds.size,
            format,
            pixels,
        };
        rasterized.validate()?;

        Ok(rasterized)
    }

    fn translate_color_glyph(
        &self,
        params: &RenderGlyphParams,
    ) -> Result<IDWriteColorGlyphRunEnumerator1> {
        let font = &self.faces[&params.font_id];
        let glyph_id = [params.glyph_id.0 as u16];
        let advance = [0.0];
        let offset = [DWRITE_GLYPH_OFFSET::default()];
        let glyph_run = DWRITE_GLYPH_RUN {
            fontFace: ManuallyDrop::new(Some(unsafe { std::ptr::read(&***font.face) })),
            fontEmSize: params.font_size.as_f32(),
            glyphCount: 1,
            glyphIndices: glyph_id.as_ptr(),
            glyphAdvances: advance.as_ptr(),
            glyphOffsets: offset.as_ptr(),
            isSideways: BOOL(0),
            bidiLevel: 0,
        };
        let transform = color_glyph_transform(params.scale_factor);
        let baseline = Vector2::new(
            params.subpixel_variant.x as f32 / SUBPIXEL_VARIANTS_X as f32 / params.scale_factor,
            params.subpixel_variant.y as f32 / SUBPIXEL_VARIANTS_Y as f32 / params.scale_factor,
        );

        // Request COLRv0 translation into ordinary outline runs, including foreground layers.
        Ok(unsafe {
            self.components.factory.TranslateColorGlyphRun(
                baseline,
                &glyph_run,
                None,
                DWRITE_GLYPH_IMAGE_FORMATS_COLR
                    | DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE
                    | DWRITE_GLYPH_IMAGE_FORMATS_CFF,
                DWRITE_MEASURING_MODE_NATURAL,
                Some(&transform),
                0,
            )
        }?)
    }

    fn rasterize_color(
        &self,
        params: &RenderGlyphParams,
        glyph_bounds: Bounds<DevicePixels>,
    ) -> Result<RasterizedGlyph> {
        // Declare the apartment first so every local COM resource drops before it.
        let _apartment = ColorRasterApartment::new()?;
        let enumerator = self.translate_color_glyph(params)?;
        let transform = color_glyph_transform(params.scale_factor);
        let mut ink_bounds = RECT {
            left: glyph_bounds.origin.x.0,
            top: glyph_bounds.origin.y.0,
            right: glyph_bounds.origin.x.0 + glyph_bounds.size.width.0,
            bottom: glyph_bounds.origin.y.0 + glyph_bounds.size.height.0,
        };

        while unsafe { enumerator.MoveNext()? }.as_bool() {
            let color_run = unsafe { &*enumerator.GetCurrentRun()? };
            ensure!(
                (color_run.glyphImageFormat
                    & (DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE | DWRITE_GLYPH_IMAGE_FORMATS_CFF))
                    .0
                    != 0,
                "DirectWrite returned an unsupported color layer format"
            );
            let layer = &color_run.Base;
            let analysis = unsafe {
                self.components.factory.CreateGlyphRunAnalysis(
                    &layer.glyphRun,
                    Some(&transform),
                    DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC,
                    DWRITE_MEASURING_MODE_NATURAL,
                    DWRITE_GRID_FIT_MODE_DEFAULT,
                    DWRITE_TEXT_ANTIALIAS_MODE_GRAYSCALE,
                    layer.baselineOriginX,
                    layer.baselineOriginY,
                )?
            };
            let layer_bounds =
                unsafe { analysis.GetAlphaTextureBounds(DWRITE_TEXTURE_ALIASED_1x1)? };
            union_ink_bounds(&mut ink_bounds, layer_bounds);
        }

        let format = params.raster_style.mode.rasterized_format();

        if ink_bounds.right <= ink_bounds.left || ink_bounds.bottom <= ink_bounds.top {
            return Ok(RasterizedGlyph::empty(format));
        }

        let width = ink_bounds
            .right
            .checked_sub(ink_bounds.left)
            .context("color glyph width overflow")?;
        let height = ink_bounds
            .bottom
            .checked_sub(ink_bounds.top)
            .context("color glyph height overflow")?;
        let byte_count = (width as usize)
            .checked_mul(height as usize)
            .and_then(|pixels| pixels.checked_mul(4))
            .context("color glyph byte count overflow")?;
        ensure!(
            u32::try_from(byte_count).is_ok(),
            "color glyph exceeds WIC's buffer limit"
        );

        let wic: IWICImagingFactory =
            unsafe { CoCreateInstance(&CLSID_WICImagingFactory, None, CLSCTX_INPROC_SERVER)? };
        let bitmap = unsafe {
            wic.CreateBitmap(
                width as u32,
                height as u32,
                &GUID_WICPixelFormat32bppPBGRA,
                WICBitmapCacheOnLoad,
            )?
        };
        let factory: ID2D1Factory =
            unsafe { D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, None)? };
        let properties = D2D1_RENDER_TARGET_PROPERTIES {
            r#type: D2D1_RENDER_TARGET_TYPE_SOFTWARE,
            pixelFormat: D2D1_PIXEL_FORMAT {
                format: DXGI_FORMAT_B8G8R8A8_UNORM,
                alphaMode: D2D1_ALPHA_MODE_PREMULTIPLIED,
            },
            dpiX: 96.0,
            dpiY: 96.0,
            usage: D2D1_RENDER_TARGET_USAGE_NONE,
            minLevel: D2D1_FEATURE_LEVEL_DEFAULT,
        };
        let target = unsafe { factory.CreateWicBitmapRenderTarget(&bitmap, &properties)? };
        let brush = unsafe { target.CreateSolidColorBrush(&D2D1_COLOR_F::default(), None)? };
        let foreground = raster_foreground(params.raster_style);

        // Enumerate again rather than retaining pointers invalidated by MoveNext.
        let enumerator = self.translate_color_glyph(params)?;

        unsafe {
            target.SetTextAntialiasMode(D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE);
            target.SetTextRenderingParams(&self.rendering_params);
            target.SetTransform(&Matrix3x2 {
                M11: params.scale_factor,
                M12: 0.0,
                M21: 0.0,
                M22: params.scale_factor,
                M31: -(ink_bounds.left as f32),
                M32: -(ink_bounds.top as f32),
            });
            target.BeginDraw();
            target.Clear(Some(&D2D1_COLOR_F::default()));
        }

        let draw_result = (|| -> Result<()> {
            while unsafe { enumerator.MoveNext()? }.as_bool() {
                let color_run = unsafe { &*enumerator.GetCurrentRun()? };
                let layer = &color_run.Base;
                let color = if layer.paletteIndex == 0xffff {
                    D2D1_COLOR_F {
                        r: foreground.red as f32 / 255.0,
                        g: foreground.green as f32 / 255.0,
                        b: foreground.blue as f32 / 255.0,
                        a: 1.0,
                    }
                } else {
                    D2D1_COLOR_F {
                        r: layer.runColor.r,
                        g: layer.runColor.g,
                        b: layer.runColor.b,
                        a: layer.runColor.a,
                    }
                };

                unsafe {
                    brush.SetColor(&color);
                    target.DrawGlyphRun(
                        Vector2::new(layer.baselineOriginX, layer.baselineOriginY),
                        &layer.glyphRun,
                        &brush,
                        DWRITE_MEASURING_MODE_NATURAL,
<<<<<<< HEAD
                    );
=======
                        DWRITE_GRID_FIT_MODE_DEFAULT,
                        DWRITE_TEXT_ANTIALIAS_MODE_GRAYSCALE,
                        baseline_origin_x,
                        baseline_origin_y,
                    )
                }?;

                let color_bounds =
                    unsafe { color_analysis.GetAlphaTextureBounds(DWRITE_TEXTURE_ALIASED_1x1) }?;

                let color_size = size(
                    color_bounds.right - color_bounds.left,
                    color_bounds.bottom - color_bounds.top,
                );
                if color_size.width > 0 && color_size.height > 0 {
                    alpha_data.clear();
                    alpha_data.resize((color_size.width * color_size.height) as usize, 0);
                    unsafe {
                        color_analysis.CreateAlphaTexture(
                            DWRITE_TEXTURE_ALIASED_1x1,
                            &color_bounds,
                            &mut alpha_data,
                        )
                    }?;

                    let run_color = {
                        let run_color = color_run.Base.runColor;
                        Rgba {
                            r: run_color.r,
                            g: run_color.g,
                            b: run_color.b,
                            a: run_color.a,
                        }
                    };
                    let bounds = bounds(point(color_bounds.left, color_bounds.top), color_size);
                    glyph_layers.push(GlyphLayerTexture::new(
                        gpu_state,
                        run_color,
                        bounds,
                        &alpha_data,
                    )?);
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
                }
            }

            Ok(())
        })();
        let end_result = unsafe { target.EndDraw(None, None) };
        draw_result?;
        end_result.context("drawing Direct2D color glyph layers")?;
        drop(brush);
        drop(target);

        let pixels = read_color_bitmap(&bitmap, width, height, foreground.alpha)?;

        if pixels.chunks_exact(4).all(|pixel| pixel[3] == 0) {
            return Ok(RasterizedGlyph::empty(format));
        }

<<<<<<< HEAD
        let bitmap_size = size(width.into(), height.into());
        let rasterized = RasterizedGlyph {
            bounds: Bounds {
                origin: point(ink_bounds.left.into(), ink_bounds.top.into()),
                size: bitmap_size,
            },
            size: bitmap_size,
            format,
            pixels,
=======
        let render_target_texture = {
            let mut texture = None;
            let desc = D3D11_TEXTURE2D_DESC {
                Width: bitmap_size.width.0 as u32,
                Height: bitmap_size.height.0 as u32,
                MipLevels: 1,
                ArraySize: 1,
                Format: DXGI_FORMAT_B8G8R8A8_UNORM,
                SampleDesc: DXGI_SAMPLE_DESC {
                    Count: 1,
                    Quality: 0,
                },
                Usage: D3D11_USAGE_DEFAULT,
                BindFlags: D3D11_BIND_RENDER_TARGET.0 as u32,
                CPUAccessFlags: 0,
                MiscFlags: 0,
            };
            unsafe {
                gpu_state
                    .device
                    .CreateTexture2D(&desc, None, Some(&mut texture))
            }?;
            texture.unwrap()
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        };
        rasterized.validate()?;

        Ok(rasterized)
    }

<<<<<<< HEAD
    fn handle_gpu_lost(&mut self, _directx_devices: &DirectXDevices) -> Result<()> {
        // Color targets are software bitmaps owned by each raster call.
        Ok(())
=======
    fn get_typographic_bounds(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Bounds<f32>> {
        unsafe {
            let font = &self.fonts[font_id.0].font_face;
            let glyph_indices = [glyph_id.0 as u16];
            let mut metrics = [DWRITE_GLYPH_METRICS::default()];
            font.GetDesignGlyphMetrics(glyph_indices.as_ptr(), 1, metrics.as_mut_ptr(), false)?;

            let metrics = &metrics[0];
            let advance_width = metrics.advanceWidth as i32;
            let advance_height = metrics.advanceHeight as i32;
            let left_side_bearing = metrics.leftSideBearing;
            let right_side_bearing = metrics.rightSideBearing;
            let top_side_bearing = metrics.topSideBearing;
            let bottom_side_bearing = metrics.bottomSideBearing;
            let vertical_origin_y = metrics.verticalOriginY;

            let y_offset = vertical_origin_y + bottom_side_bearing - advance_height;
            let width = advance_width - (left_side_bearing + right_side_bearing);
            let height = advance_height - (top_side_bearing + bottom_side_bearing);

            Ok(Bounds {
                origin: Point {
                    x: left_side_bearing as f32,
                    y: y_offset as f32,
                },
                size: Size {
                    width: width as f32,
                    height: height as f32,
                },
            })
        }
    }

    fn get_advance(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>> {
        unsafe {
            let font = &self.fonts[font_id.0].font_face;
            let glyph_indices = [glyph_id.0 as u16];
            let mut metrics = [DWRITE_GLYPH_METRICS::default()];
            font.GetDesignGlyphMetrics(glyph_indices.as_ptr(), 1, metrics.as_mut_ptr(), false)?;

            let metrics = &metrics[0];

            Ok(Size {
                width: metrics.advanceWidth as f32,
                height: 0.0,
            })
        }
    }

    fn all_font_names(&self, components: &DirectWriteComponents) -> Vec<String> {
        let mut result =
            get_font_names_from_collection(&self.system_font_collection, &components.locale);
        result.extend(get_font_names_from_collection(
            &self.custom_font_collection,
            &components.locale,
        ));
        result
    }

    fn handle_gpu_lost(&mut self, directx_devices: &DirectXDevices) -> Result<()> {
        try_to_recover_from_device_lost(|| {
            GPUState::new(directx_devices).context("Recreating GPU state for DirectWrite")
        })
        .map(|gpu_state| self.gpu_state = Some(gpu_state))
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
    }
}

impl Drop for DirectWriteGlyphRenderer {
    fn drop(&mut self) {
        self.faces.clear();
        self.sources.clear();

        unsafe {
            let _ = self
                .components
                .factory
                .UnregisterFontFileLoader(&self.components.in_memory_loader);
        }
    }
}

impl GlyphRasterizer for DirectWriteGlyphRenderer {
    fn supports_color_glyph(&self, kind: ColorGlyphKind) -> bool {
        kind == ColorGlyphKind::ColrV0
    }

    fn prepare_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
        if request.requested_mode == GlyphRenderMode::Color {
            PreparedRasterStyle::preblend(request)
        } else {
            PreparedRasterStyle::independent(request.requested_mode)
        }
    }

    fn rasterize(
        &mut self,
        face: RasterFace<'_>,
        params: &RenderGlyphParams,
    ) -> Result<RasterizedGlyph> {
        ensure!(
            params.scale_factor.is_finite() && params.scale_factor > 0.0,
            "invalid raster scale factor"
        );

        let format = params.raster_style.mode.rasterized_format();

        if params.font_size == Pixels::ZERO {
            return Ok(RasterizedGlyph::empty(format));
        }

        self.load_face(face)?;
        debug_assert!(
            !matches!(params.raster_style.color_effect, RasterColorEffect::Dilation(value) if value != 0)
        );
        let glyph_analysis = self.create_glyph_run_analysis(params)?;
        let texture_type = if params.raster_style.mode == GlyphRenderMode::Subpixel {
            DWRITE_TEXTURE_CLEARTYPE_3x1
        } else {
            DWRITE_TEXTURE_ALIASED_1x1
        };
        let native_bounds = unsafe { glyph_analysis.GetAlphaTextureBounds(texture_type)? };

        self.rasterize_glyph(params, &glyph_analysis, texture_type, native_bounds)
    }

    fn recommended_mode(&self) -> TextRenderingMode {
        if self.system_subpixel_rendering {
            TextRenderingMode::Subpixel
        } else {
            TextRenderingMode::Grayscale
        }
    }
}

impl NativeFace {
    fn new(
        factory: &IDWriteFactory5,
        variable_factory: Option<&IDWriteFactory6>,
        file: &IDWriteFontFile,
        face: &RasterFace<'_>,
        use_default_axes: bool,
    ) -> Result<Self> {
        let mut simulations = DWRITE_FONT_SIMULATIONS_NONE;

        if face.synthesis.embolden {
            simulations |= DWRITE_FONT_SIMULATIONS_BOLD;
        }

        if face.synthesis.skew_degrees.is_some() {
            simulations |= DWRITE_FONT_SIMULATIONS_OBLIQUE;
        }

        let native_face = if use_default_axes {
            let reference =
                unsafe { factory.CreateFontFaceReference(file, face.face_index, simulations) }?;

            unsafe { reference.CreateFontFace() }?
        } else {
            let variable_factory = variable_factory
                .context("this DirectWrite version cannot instantiate variable-font coordinates")?;
            let variations = face
                .variations
                .iter()
                .map(|variation| DWRITE_FONT_AXIS_VALUE {
                    axisTag: DWRITE_FONT_AXIS_TAG(u32::from_le_bytes(variation.tag.to_be_bytes())),
                    value: variation.value,
                })
                .collect::<Vec<_>>();
            let reference = unsafe {
                variable_factory.CreateFontFaceReference(
                    file,
                    face.face_index,
                    simulations,
                    &variations,
                )
            }?;
            let variable_face = unsafe { reference.CreateFontFace() }?;

<<<<<<< HEAD
            variable_face.cast()?
=======
    fn DrawUnderline(
        &self,
        _clientdrawingcontext: *const ::core::ffi::c_void,
        _baselineoriginx: f32,
        _baselineoriginy: f32,
        _underline: *const DWRITE_UNDERLINE,
        _clientdrawingeffect: windows::core::Ref<windows::core::IUnknown>,
    ) -> windows::core::Result<()> {
        Err(windows::core::Error::new(
            E_NOTIMPL,
            "DrawUnderline unimplemented",
        ))
    }

    fn DrawStrikethrough(
        &self,
        _clientdrawingcontext: *const ::core::ffi::c_void,
        _baselineoriginx: f32,
        _baselineoriginy: f32,
        _strikethrough: *const DWRITE_STRIKETHROUGH,
        _clientdrawingeffect: windows::core::Ref<windows::core::IUnknown>,
    ) -> windows::core::Result<()> {
        Err(windows::core::Error::new(
            E_NOTIMPL,
            "DrawStrikethrough unimplemented",
        ))
    }

    fn DrawInlineObject(
        &self,
        _clientdrawingcontext: *const ::core::ffi::c_void,
        _originx: f32,
        _originy: f32,
        _inlineobject: windows::core::Ref<IDWriteInlineObject>,
        _issideways: BOOL,
        _isrighttoleft: BOOL,
        _clientdrawingeffect: windows::core::Ref<windows::core::IUnknown>,
    ) -> windows::core::Result<()> {
        Err(windows::core::Error::new(
            E_NOTIMPL,
            "DrawInlineObject unimplemented",
        ))
    }
}

/// Interprets an optional DirectWrite array pointer as a slice, treating a
/// null pointer with a zero length as an empty slice. A null pointer with a
/// nonzero length fails with `null_error_message`.
///
/// # Safety
///
/// When `ptr` is non-null, the caller must guarantee that it points to a valid
/// array of at least `len` elements that outlives the returned slice.
unsafe fn slice_from_nullable<'a, T>(
    ptr: *const T,
    len: usize,
    null_error_message: &str,
) -> windows::core::Result<&'a [T]> {
    if ptr.is_null() {
        if len != 0 {
            return Err(Error::new(E_INVALIDARG, null_error_message));
        }
        Ok(&[])
    } else {
        Ok(unsafe { std::slice::from_raw_parts(ptr, len) })
    }
}

struct StringIndexConverter<'a> {
    text: &'a str,
    utf8_ix: usize,
    utf16_ix: usize,
}

impl<'a> StringIndexConverter<'a> {
    fn new(text: &'a str) -> Self {
        Self {
            text,
            utf8_ix: 0,
            utf16_ix: 0,
        }
    }

    #[allow(dead_code)]
    fn advance_to_utf8_ix(&mut self, utf8_target: usize) {
        for (ix, c) in self.text[self.utf8_ix..].char_indices() {
            if self.utf8_ix + ix >= utf8_target {
                self.utf8_ix += ix;
                return;
            }
            self.utf16_ix += c.len_utf16();
        }
        self.utf8_ix = self.text.len();
    }

    fn advance_to_utf16_ix(&mut self, utf16_target: usize) {
        for (ix, c) in self.text[self.utf8_ix..].char_indices() {
            if self.utf16_ix >= utf16_target {
                self.utf8_ix += ix;
                return;
            }
            self.utf16_ix += c.len_utf16();
        }
        self.utf8_ix = self.text.len();
    }
}

fn font_style_to_dwrite(style: FontStyle) -> DWRITE_FONT_STYLE {
    match style {
        FontStyle::Normal => DWRITE_FONT_STYLE_NORMAL,
        FontStyle::Italic => DWRITE_FONT_STYLE_ITALIC,
        FontStyle::Oblique => DWRITE_FONT_STYLE_OBLIQUE,
    }
}

fn font_style_from_dwrite(value: DWRITE_FONT_STYLE) -> FontStyle {
    match value.0 {
        0 => FontStyle::Normal,
        1 => FontStyle::Italic,
        2 => FontStyle::Oblique,
        _ => unreachable!(),
    }
}

fn font_weight_to_dwrite(weight: FontWeight) -> DWRITE_FONT_WEIGHT {
    DWRITE_FONT_WEIGHT(weight.0 as i32)
}

fn font_weight_from_dwrite(value: DWRITE_FONT_WEIGHT) -> FontWeight {
    FontWeight(value.0 as f32)
}

fn get_font_names_from_collection(
    collection: &IDWriteFontCollection1,
    locale: &HSTRING,
) -> Vec<String> {
    unsafe {
        let mut result = Vec::new();
        let family_count = collection.GetFontFamilyCount();
        for index in 0..family_count {
            let Some(font_family) = collection.GetFontFamily(index).log_err() else {
                continue;
            };
            let Some(localized_family_name) = font_family.GetFamilyNames().log_err() else {
                continue;
            };
            let Some(family_name) = get_name(localized_family_name, locale).log_err() else {
                continue;
            };
            result.push(family_name);
        }

        result
    }
}

fn font_face_to_font(font_face: &IDWriteFontFace3, locale: &HSTRING) -> Option<Font> {
    let localized_family_name = unsafe { font_face.GetFamilyNames().log_err() }?;
    let family_name = get_name(localized_family_name, locale).log_err()?;
    let weight = unsafe { font_face.GetWeight() };
    let style = unsafe { font_face.GetStyle() };
    Some(Font {
        family: family_name.into(),
        features: FontFeatures::default(),
        weight: font_weight_from_dwrite(weight),
        style: font_style_from_dwrite(style),
        fallbacks: None,
    })
}

// https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_font_feature_tag
fn apply_font_features(
    direct_write_features: &IDWriteTypography,
    features: &FontFeatures,
) -> Result<()> {
    let tag_values = features.tag_value_list();

    // All of these features are enabled by default by DirectWrite.
    // If you want to (and can) peek into the source of DirectWrite
    let mut feature_liga = make_direct_write_feature("liga", 1);
    let mut feature_clig = make_direct_write_feature("clig", 1);
    let mut feature_calt = make_direct_write_feature("calt", 1);

    for (tag, value) in tag_values {
        if tag.as_str() == "liga" && *value == 0 {
            feature_liga.parameter = 0;
            continue;
        }
        if tag.as_str() == "clig" && *value == 0 {
            feature_clig.parameter = 0;
            continue;
        }
        if tag.as_str() == "calt" && *value == 0 {
            feature_calt.parameter = 0;
            continue;
        }

        unsafe {
            direct_write_features.AddFontFeature(make_direct_write_feature(tag, *value))?;
        }
    }
    unsafe {
        direct_write_features.AddFontFeature(feature_liga)?;
        direct_write_features.AddFontFeature(feature_clig)?;
        direct_write_features.AddFontFeature(feature_calt)?;
    }

    Ok(())
}

#[inline]
const fn make_direct_write_feature(feature_name: &str, parameter: u32) -> DWRITE_FONT_FEATURE {
    let tag = make_direct_write_tag(feature_name);
    DWRITE_FONT_FEATURE {
        nameTag: tag,
        parameter,
    }
}

#[inline]
const fn make_open_type_tag(tag_name: &str) -> u32 {
    let bytes = tag_name.as_bytes();
    debug_assert!(bytes.len() == 4);
    u32::from_le_bytes([bytes[0], bytes[1], bytes[2], bytes[3]])
}

#[inline]
const fn make_direct_write_tag(tag_name: &str) -> DWRITE_FONT_FEATURE_TAG {
    DWRITE_FONT_FEATURE_TAG(make_open_type_tag(tag_name))
}

#[inline]
fn get_name(string: IDWriteLocalizedStrings, locale: &HSTRING) -> Result<String> {
    let mut locale_name_index = 0u32;
    let mut exists = BOOL(0);
    unsafe { string.FindLocaleName(locale, &mut locale_name_index, &mut exists as _)? };
    if !exists.as_bool() {
        unsafe {
            string.FindLocaleName(
                DEFAULT_LOCALE_NAME,
                &mut locale_name_index as _,
                &mut exists as _,
            )?
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f
        };

        Ok(Self { face: native_face })
    }
}

impl NativeSource {
    fn new(
        factory: &IDWriteFactory5,
        loader: &IDWriteInMemoryFontFileLoader,
        source: &FontDataBlob<u8>,
    ) -> Result<Self> {
        let bytes = source.as_ref();
        let data_len =
            u32::try_from(bytes.len()).context("font data exceeds DirectWrite limits")?;
        let owner: windows::core::IUnknown = FontDataOwner {
            _data: source.clone(),
        }
        .into();
        let file = unsafe {
            loader.CreateInMemoryFontFileReference(factory, bytes.as_ptr().cast(), data_len, &owner)
        }?;

        Ok(Self { file })
    }
}

fn get_system_subpixel_rendering() -> bool {
    let mut smoothing_enabled = BOOL::default();
    let enabled_result = unsafe {
        SystemParametersInfoW(
            SPI_GETFONTSMOOTHING,
            0,
            Some((&mut smoothing_enabled as *mut BOOL).cast::<c_void>()),
            SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS::default(),
        )
    };

    let mut smoothing_type = c_uint::default();
    let type_result = unsafe {
        SystemParametersInfoW(
            SPI_GETFONTSMOOTHINGTYPE,
            0,
            Some((&mut smoothing_type as *mut c_uint).cast::<c_void>()),
            SYSTEM_PARAMETERS_INFO_UPDATE_FLAGS::default(),
        )
    };

    enabled_result.is_ok()
        && type_result.is_ok()
        && smoothing_enabled.as_bool()
        && smoothing_type == FE_FONTSMOOTHINGCLEARTYPE
}

struct ColorRasterApartment {
    initialized: bool,
    _thread: PhantomData<Rc<()>>,
}

impl ColorRasterApartment {
    fn new() -> Result<Self> {
        let status = unsafe { CoInitializeEx(None, COINIT_MULTITHREADED) };
        let initialized = status != RPC_E_CHANGED_MODE;

        if initialized {
            // S_OK and S_FALSE both acquire a reference that this guard must release.
            status
                .ok()
                .context("initializing COM for color rasterization")?;
        }

        Ok(Self {
            initialized,
            _thread: PhantomData,
        })
    }
}

impl Drop for ColorRasterApartment {
    fn drop(&mut self) {
        if self.initialized {
            unsafe { CoUninitialize() };
        }
    }
}

fn color_glyph_transform(scale_factor: f32) -> DWRITE_MATRIX {
    DWRITE_MATRIX {
        m11: scale_factor,
        m12: 0.0,
        m21: 0.0,
        m22: scale_factor,
        dx: 0.0,
        dy: 0.0,
    }
}

fn raster_foreground(style: PreparedRasterStyle) -> Rgba8 {
    match style.color_effect {
        RasterColorEffect::Preblend(color) => color,
        _ => Rgba8::new(0, 0, 0, 255),
    }
}

fn union_ink_bounds(bounds: &mut RECT, layer: RECT) {
    if layer.right <= layer.left || layer.bottom <= layer.top {
        return;
    }

    if bounds.right <= bounds.left || bounds.bottom <= bounds.top {
        *bounds = layer;

        return;
    }

    bounds.left = bounds.left.min(layer.left);
    bounds.top = bounds.top.min(layer.top);
    bounds.right = bounds.right.max(layer.right);
    bounds.bottom = bounds.bottom.max(layer.bottom);
}

fn read_color_bitmap(bitmap: &IWICBitmap, width: i32, height: i32, alpha: u8) -> Result<Vec<u8>> {
    ensure!(width > 0 && height > 0, "color bitmap dimensions are empty");

    let lock = unsafe {
        bitmap.Lock(
            &WICRect {
                X: 0,
                Y: 0,
                Width: width,
                Height: height,
            },
            WICBitmapLockRead.0 as u32,
        )?
    };
    let stride = unsafe { lock.GetStride()? } as usize;
    let mut buffer_size = 0;
    let mut buffer = std::ptr::null_mut();
    unsafe { lock.GetDataPointer(&mut buffer_size, &mut buffer)? };

    let row_bytes = (width as usize)
        .checked_mul(4)
        .context("color bitmap row size overflow")?;
    let required_bytes = (height as usize - 1)
        .checked_mul(stride)
        .and_then(|offset| offset.checked_add(row_bytes))
        .context("color bitmap buffer size overflow")?;
    ensure!(
        !buffer.is_null() && stride >= row_bytes && buffer_size as usize >= required_bytes,
        "WIC returned an invalid color bitmap buffer"
    );

    // The lock owns the mapping until all rows have been copied.
    let source = unsafe { std::slice::from_raw_parts(buffer, buffer_size as usize) };
    let byte_count = row_bytes
        .checked_mul(height as usize)
        .context("color bitmap byte count overflow")?;
    let mut pixels = vec![0; byte_count];

    for (row_index, row) in pixels.chunks_exact_mut(row_bytes).enumerate() {
        let offset = row_index * stride;
        row.copy_from_slice(&source[offset..offset + row_bytes]);
    }

    // Scaling premultiplied RGB and alpha together leaves straight RGB unchanged.
    // Retain the original alpha for division to avoid quantizing the scaled RGB twice.
    for pixel in pixels.chunks_exact_mut(4) {
        let coverage = pixel[3] as u16;
        let scaled_alpha = ((coverage * alpha as u16 + 127) / 255) as u8;

        if scaled_alpha == 0 {
            pixel.fill(0);

            continue;
        }

        for channel in &mut pixel[..3] {
            *channel = ((*channel as u16 * 255 + coverage / 2) / coverage).min(255) as u8;
        }

        pixel[3] = scaled_alpha;
    }

    Ok(pixels)
}

#[cfg(test)]
mod tests {
    use std::collections::BTreeMap;

    use super::*;
    use gpui::{
        FontStyle, FontWeight, FontWidth, ForegroundDependency, Point, RasterizedGlyphFormat, Rgba,
        font, px, rgba,
    };
    use gpui_parley::FontSynthesis;

    const IBM_PLEX: &[u8] =
        include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf");
    const IBM_PLEX_ITALIC: &[u8] =
        include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Italic.ttf");
    const SOURCE_SERIF: &[u8] =
        include_bytes!("../../../assets/fonts/source-serif-4/SourceSerif4[opsz,wght].ttf");
    const NOTO_SANS: &[u8] =
        include_bytes!("../../../assets/fonts/noto-sans/NotoSans[wdth,wght].subset.ttf");

    #[test]
    fn fixed_fonts_cover_native_modes_instances_and_empty_glyphs() -> Result<()> {
        let system = DirectWriteTextSystem::new_headless()?;
        system.add_fonts(vec![
            Cow::Borrowed(IBM_PLEX),
            Cow::Borrowed(SOURCE_SERIF),
            Cow::Borrowed(NOTO_SANS),
        ])?;

        let regular_id = system.font_id(&font("IBM Plex Sans"))?;
        let regular_glyph = system
            .glyph_for_char(regular_id, 'A')
            .context("IBM Plex Sans has no A glyph")?;

<<<<<<< HEAD
        for scale_factor in [1.0, 1.5, 2.0] {
            let grayscale = rasterize(
                &system,
                regular_id,
                regular_glyph,
                GlyphRenderMode::Grayscale,
                point(0, 0),
                scale_factor,
            )?;
            assert_eq!(grayscale.format, RasterizedGlyphFormat::AlphaMask);
            grayscale.validate()?;
=======
    #[test]
    fn color_emoji_rasterization_is_stable_across_batches() -> Result<()> {
        let devices = DirectXDevices::new()?;
        let text_system = DirectWriteTextSystem::new(Some(&devices))?;
>>>>>>> 23cb1f7c5c21ea7f7e30eb9b07590058e9835b6f

            for subpixel_x in 0..SUBPIXEL_VARIANTS_X {
                for subpixel_y in 0..SUBPIXEL_VARIANTS_Y {
                    let subpixel = rasterize(
                        &system,
                        regular_id,
                        regular_glyph,
                        GlyphRenderMode::Subpixel,
                        point(subpixel_x, subpixel_y),
                        scale_factor,
                    )?;
                    assert_eq!(subpixel.format, RasterizedGlyphFormat::BgraSubpixelMask);
                    subpixel.validate()?;
                }
            }
        }

        let space = system
            .glyph_for_char(regular_id, ' ')
            .context("IBM Plex Sans has no space glyph")?;
        let empty = rasterize(
            &system,
            regular_id,
            space,
            GlyphRenderMode::Grayscale,
            point(0, 0),
            1.0,
        )?;
        assert_eq!(empty.size, Size::default());
        assert!(empty.pixels.is_empty());

        let monochrome_color = rasterize(
            &system,
            regular_id,
            regular_glyph,
            GlyphRenderMode::Color,
            point(0, 0),
            1.0,
        )?;
        assert_eq!(monochrome_color.format, RasterizedGlyphFormat::BgraColor);
        assert!(
            monochrome_color
                .pixels
                .chunks_exact(4)
                .filter(|pixel| pixel[3] != 0)
                .all(|pixel| pixel[..3] == [255, 255, 255])
        );
        monochrome_color.validate()?;

        let synthesized_id = system.font_id(&font("IBM Plex Sans").bold().italic())?;
        let synthesized_glyph = system
            .glyph_for_char(synthesized_id, 'A')
            .context("synthesized IBM Plex Sans has no A glyph")?;
        let synthesized = rasterize(
            &system,
            synthesized_id,
            synthesized_glyph,
            GlyphRenderMode::Grayscale,
            point(0, 0),
            2.0,
        )?;
        assert!(!synthesized.pixels.is_empty());
        synthesized.validate()?;

        let mut light = font("Source Serif 4");
        light.weight = FontWeight::LIGHT;
        let mut bold = light.clone();
        bold.weight = FontWeight::BOLD;
        bold.style = FontStyle::Normal;
        let rasterize_font = |descriptor: &gpui::Font| {
            let font_id = system.font_id(descriptor)?;
            let glyph_id = system
                .glyph_for_char(font_id, 'A')
                .context("fixture has no A glyph")?;

            rasterize(
                &system,
                font_id,
                glyph_id,
                GlyphRenderMode::Grayscale,
                point(0, 0),
                2.0,
            )
        };

        for (first, second) in [
            (light, bold),
            (
                font("Noto Sans"),
                gpui::Font {
                    width: FontWidth::CONDENSED,
                    ..font("Noto Sans")
                },
            ),
        ] {
            let first = rasterize_font(&first)?;
            let second = rasterize_font(&second)?;
            first.validate()?;
            second.validate()?;
            assert_ne!((first.bounds, first.pixels), (second.bounds, second.pixels));
        }

        Ok(())
    }

    #[test]
    fn direct_write_loads_a_nonzero_collection_face() -> Result<()> {
        let collection = test_collection(&[SOURCE_SERIF, IBM_PLEX, IBM_PLEX_ITALIC]);
        let source = FontDataBlob::from(collection);
        let mut renderer = DirectWriteGlyphRenderer::new(None)?;
        renderer.load_face(RasterFace {
            font_id: FontId(1),
            source_id: source.id(),
            source: &source,
            face_index: 1,
            normalized_coords: &[],
            variations: &[],
            synthesis: FontSynthesis::default(),
            has_color_glyphs: false,
        })?;
        let codepoint = 'A' as u32;
        let mut glyph_id = 0;
        unsafe {
            renderer.faces[&FontId(1)].face.GetGlyphIndices(
                &raw const codepoint,
                1,
                &raw mut glyph_id,
            )?;
        }
        assert_ne!(glyph_id, 0);

        Ok(())
    }

    #[test]
    fn native_color_survives_device_recovery() -> Result<()> {
        let devices = DirectXDevices::new()?;
        let system = DirectWriteTextSystem::new(&devices)?;
        let font_id = system.font_id(&font("Segoe UI Emoji"))?;
        let glyph_id = system
            .glyph_for_char(font_id, '😀')
            .context("Segoe UI Emoji has no grinning-face glyph")?;
        let before = rasterize(
            &system,
            font_id,
            glyph_id,
            GlyphRenderMode::Color,
            point(0, 0),
            2.0,
        )?;
        assert_eq!(before.format, RasterizedGlyphFormat::BgraColor);
        assert!(before.pixels.chunks_exact(4).any(|pixel| {
            pixel[3] > 128
                && (pixel[0].abs_diff(pixel[1]) > 20
                    || pixel[1].abs_diff(pixel[2]) > 20
                    || pixel[0].abs_diff(pixel[2]) > 20)
        }));
        before.validate()?;

        let replacement_devices = DirectXDevices::new()?;
        system.handle_gpu_lost(&replacement_devices)?;
        let after = rasterize(
            &system,
            font_id,
            glyph_id,
            GlyphRenderMode::Color,
            point(0, 0),
            2.0,
        )?;
        after.validate()?;
        assert_eq!(before.bounds, after.bounds);
        assert_eq!(before.format, after.format);
        assert_eq!(before.pixels, after.pixels);

        Ok(())
    }

    #[test]
    fn headless_color_layers_preserve_palette_foreground_and_alpha() -> Result<()> {
        let (system, font_id) = color_test_system()?;

        for character in ['A', 'B'] {
            let glyph_id = system.glyph_for_char(font_id, character).unwrap();
            let red = color_params(
                &system,
                font_id,
                glyph_id,
                rgba(0xe02010ff),
                point(0, 0),
                2.0,
            );
            let green = color_params(
                &system,
                font_id,
                glyph_id,
                rgba(0x20c080ff),
                point(0, 0),
                2.0,
            );
            let red_pixels = system.rasterize_glyph(&red)?;
            let green_pixels = system.rasterize_glyph(&green)?;
            red_pixels.validate()?;
            green_pixels.validate()?;
            assert!(!red_pixels.pixels.is_empty());
            assert_eq!(red_pixels.format, RasterizedGlyphFormat::BgraColor);
            assert!(red_pixels.pixels.chunks_exact(4).any(|pixel| pixel[3] == 0));
            assert!(red_pixels.pixels.chunks_exact(4).any(|pixel| {
                pixel[0] == 255 && pixel[1] == 0 && pixel[2] == 0 && pixel[3] == 128
            }));

            if character == 'A' {
                assert_eq!(
                    red.raster_style.foreground_dependency,
                    ForegroundDependency::AlphaOnly
                );
                assert_eq!(red.raster_style, green.raster_style);
                assert_eq!(red_pixels.pixels, green_pixels.pixels);
                assert!(red_pixels.pixels.chunks_exact(4).any(|pixel| {
                    pixel[3] == 255
                        && pixel[0].abs_diff(128) <= 2
                        && pixel[1] == 0
                        && pixel[2].abs_diff(127) <= 2
                }));
            } else {
                assert_eq!(
                    red.raster_style.foreground_dependency,
                    ForegroundDependency::Full
                );
                assert_ne!(red.raster_style, green.raster_style);
                assert_ne!(red_pixels.pixels, green_pixels.pixels);
                assert!(
                    red_pixels
                        .pixels
                        .chunks_exact(4)
                        .any(|pixel| { pixel[..3] == [16, 32, 224] && pixel[3] == 255 })
                );
            }

            for alpha in [0, 64, 128, 255] {
                let foreground = Rgba8::new(224, 32, 16, alpha);
                let params = color_params(
                    &system,
                    font_id,
                    glyph_id,
                    foreground.into(),
                    point(0, 0),
                    2.0,
                );
                let rasterized = system.rasterize_glyph(&params)?;
                rasterized.validate()?;

                assert_foreground_alpha(&rasterized, &red_pixels, alpha);
            }
        }

        Ok(())
    }

    #[test]
    fn color_layer_bounds_cover_empty_and_smaller_base_outlines() -> Result<()> {
        let (system, font_id) = color_test_system()?;

        for character in ['i', ' '] {
            let glyph_id = system.glyph_for_char(font_id, character).unwrap();

            for scale_factor in [1.0, 1.5, 2.0] {
                for subpixel_variant in subpixel_variants() {
                    let params = color_params(
                        &system,
                        font_id,
                        glyph_id,
                        rgba(0xffffffff),
                        subpixel_variant,
                        scale_factor,
                    );
                    assert_color_bounds(&system, character, &params)?;
                }
            }
        }

        Ok(())
    }

    #[test]
    fn color_rasterization_balances_uninitialized_sta_and_mta_apartments() -> Result<()> {
        for (apartment, concurrent_mta) in [
            (None, false),
            (None, true),
            (Some(COINIT_APARTMENTTHREADED), false),
            (Some(COINIT_MULTITHREADED), false),
        ] {
            // Keep another thread's MTA alive to exercise implicit membership deterministically.
            let _concurrent_apartment =
                concurrent_mta.then(ColorRasterApartment::new).transpose()?;

            std::thread::spawn(move || -> Result<()> {
                assert_eq!(explicit_calling_apartment()?, None);
                let caller = apartment
                    .map(|mode| -> Result<ColorRasterApartment> {
                        assert_eq!(unsafe { CoInitializeEx(None, mode) }, S_OK);

                        Ok(ColorRasterApartment {
                            initialized: true,
                            _thread: PhantomData,
                        })
                    })
                    .transpose()?;
                let before = explicit_calling_apartment()?;
                let (system, font_id) = color_test_system()?;
                let glyph_id = system.glyph_for_char(font_id, 'B').unwrap();
                let params = color_params(
                    &system,
                    font_id,
                    glyph_id,
                    rgba(0x20c080ff),
                    point(1, 1),
                    1.5,
                );

                for iteration in 0..3 {
                    let rasterized = system.rasterize_glyph(&params)?;
                    rasterized.validate()?;
                    assert!(
                        rasterized
                            .pixels
                            .chunks_exact(4)
                            .any(|pixel| pixel[..3] == [128, 192, 32])
                    );
                    assert_eq!(
                        explicit_calling_apartment()?,
                        before,
                        "apartment changed after raster {iteration}"
                    );
                }

                drop(system);
                drop(caller);
                assert_eq!(explicit_calling_apartment()?, None);

                Ok(())
            })
            .join()
            .expect("color raster thread panicked")?;
        }

        Ok(())
    }

    #[test]
    fn color_fallback_bakes_foreground_and_bitmap_fonts_keep_portable_routing() -> Result<()> {
        let system = DirectWriteTextSystem::new_headless()?;
        system.add_fonts(vec![Cow::Borrowed(IBM_PLEX)])?;
        let font_id = system.font_id(&font("IBM Plex Sans"))?;
        let glyph_id = system.glyph_for_char(font_id, 'A').unwrap();

        for alpha in [0, 64, 128, 255] {
            let params = color_params(
                &system,
                font_id,
                glyph_id,
                Rgba8::new(224, 32, 16, alpha).into(),
                point(1, 1),
                1.5,
            );
            let rasterized = system.rasterize_glyph(&params)?;
            rasterized.validate()?;
            assert_eq!(rasterized.format, RasterizedGlyphFormat::BgraColor);
            assert!(rasterized.pixels.chunks_exact(4).all(|pixel| {
                pixel[3] <= alpha && (pixel[3] == 0 || pixel[..3] == [16, 32, 224])
            }));

            let renderer = system.renderer.read();
            let error = renderer.translate_color_glyph(&params).unwrap_err();
            assert_eq!(
                error.downcast_ref::<windows::core::Error>().unwrap().code(),
                DWRITE_E_NOCOLOR
            );
        }

        let bitmap_system = DirectWriteTextSystem::new_headless()?;
        bitmap_system.add_fonts(vec![Cow::Borrowed(include_bytes!(
            "../../../assets/fonts/noto-color-emoji/NotoColorEmoji.subset.ttf"
        ))])?;
        let font_id = bitmap_system.font_id(&font("Noto Color Emoji"))?;
        let glyph_id = bitmap_system.glyph_for_char(font_id, '😀').unwrap();
        let params = color_params(
            &bitmap_system,
            font_id,
            glyph_id,
            rgba(0xffffffff),
            point(0, 0),
            1.0,
        );
        let rasterized = bitmap_system.rasterize_glyph(&params)?;
        rasterized.validate()?;
        assert_eq!(rasterized.format, RasterizedGlyphFormat::BgraColor);
        assert!(!rasterized.pixels.is_empty());
        assert!(bitmap_system.renderer.read().faces.is_empty());

        Ok(())
    }

    #[test]
    fn native_color_target_failure_uses_monochrome_foreground() -> Result<()> {
        let _apartment = ColorRasterApartment::new()?;
        let wic: IWICImagingFactory =
            unsafe { CoCreateInstance(&CLSID_WICImagingFactory, None, CLSCTX_INPROC_SERVER)? };
        let bitmap = unsafe {
            wic.CreateBitmap(1, 1, &GUID_WICPixelFormat32bppPBGRA, WICBitmapCacheOnLoad)?
        };
        let factory: ID2D1Factory =
            unsafe { D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, None)? };
        let properties = D2D1_RENDER_TARGET_PROPERTIES {
            r#type: D2D1_RENDER_TARGET_TYPE_SOFTWARE,
            pixelFormat: D2D1_PIXEL_FORMAT {
                format: DXGI_FORMAT_B8G8R8A8_UNORM,
                alphaMode: D2D1_ALPHA_MODE_PREMULTIPLIED,
            },
            dpiX: 96.0,
            dpiY: 96.0,
            ..Default::default()
        };
        let target = unsafe { factory.CreateWicBitmapRenderTarget(&bitmap, &properties)? };
        let maximum_width = unsafe { target.GetMaximumBitmapSize() };
        let width: i32 = maximum_width
            .checked_add(1)
            .context("Direct2D bitmap limit overflow")?
            .try_into()?;
        drop(target);

        let (system, font_id) = color_test_system()?;
        let glyph_id = system.glyph_for_char(font_id, 'B').unwrap();
        let params = color_params(
            &system,
            font_id,
            glyph_id,
            rgba(0xe0201080),
            point(0, 0),
            1.0,
        );
        system.rasterize_glyph(&params)?;

        let renderer = system.renderer.read();
        let glyph_analysis = renderer.create_glyph_run_analysis(&params)?;
        let oversized = Bounds {
            origin: point(0.into(), (-10).into()),
            size: size(width.into(), 1.into()),
        };
        assert!(renderer.rasterize_color(&params, oversized).is_err());

        let native_bounds = RECT {
            left: oversized.origin.x.0,
            top: oversized.origin.y.0,
            right: oversized.origin.x.0 + oversized.size.width.0,
            bottom: oversized.origin.y.0 + oversized.size.height.0,
        };
        let coverage = renderer.rasterize_monochrome(
            &glyph_analysis,
            DWRITE_TEXTURE_ALIASED_1x1,
            native_bounds,
        )?;
        let fallback = renderer.rasterize_glyph(
            &params,
            &glyph_analysis,
            DWRITE_TEXTURE_ALIASED_1x1,
            native_bounds,
        )?;
        fallback.validate()?;
        assert_eq!(fallback.format, RasterizedGlyphFormat::BgraColor);
        assert_eq!(fallback.bounds, oversized);
        assert!(fallback.pixels.chunks_exact(4).any(|pixel| pixel[3] != 0));

        for (pixel, coverage) in fallback.pixels.chunks_exact(4).zip(coverage) {
            assert_eq!(pixel[3], ((coverage as u16 * 128 + 127) / 255) as u8);

            if pixel[3] == 0 {
                assert_eq!(pixel, [0; 4]);
            } else {
                assert_eq!(pixel[..3], [16, 32, 224]);
            }
        }

        Ok(())
    }

    #[test]
    fn wic_readback_preserves_rows_and_converts_premultiplied_alpha() -> Result<()> {
        let _apartment = ColorRasterApartment::new()?;
        let factory: IWICImagingFactory =
            unsafe { CoCreateInstance(&CLSID_WICImagingFactory, None, CLSCTX_INPROC_SERVER)? };
        let source = [
            0, 0, 0, 0, 32, 64, 128, 128, 17, 18, 19, 20, 255, 0, 0, 255, 9, 8, 7, 0, 21, 22, 23,
            24,
        ];
        let bitmap = unsafe {
            factory.CreateBitmapFromMemory(2, 2, &GUID_WICPixelFormat32bppPBGRA, 12, &source)?
        };

        for (alpha, expected_alpha) in [(255, 128), (128, 64), (64, 32)] {
            let pixels = read_color_bitmap(&bitmap, 2, 2, alpha)?;
            assert_eq!(
                pixels,
                [
                    0,
                    0,
                    0,
                    0,
                    64,
                    128,
                    255,
                    expected_alpha,
                    255,
                    0,
                    0,
                    alpha,
                    0,
                    0,
                    0,
                    0
                ]
            );
        }

        assert_eq!(read_color_bitmap(&bitmap, 2, 2, 0)?, vec![0; 16]);

        Ok(())
    }

    fn color_params(
        system: &DirectWriteTextSystem,
        font_id: FontId,
        glyph_id: GlyphId,
        scene_color: Rgba,
        subpixel_variant: Point<u8>,
        scale_factor: f32,
    ) -> RenderGlyphParams {
        RenderGlyphParams {
            font_id,
            glyph_id,
            font_size: px(24.0),
            subpixel_variant,
            scale_factor,
            raster_style: system.prepare_raster_style(RasterStyleRequest {
                font_id,
                glyph_id,
                scene_color,
                requested_mode: GlyphRenderMode::Color,
                foreground_dependency: ForegroundDependency::Full,
            }),
        }
    }

    fn explicit_calling_apartment() -> windows::core::Result<Option<(APTTYPE, APTTYPEQUALIFIER)>> {
        let mut apartment = APTTYPE::default();
        let mut qualifier = APTTYPEQUALIFIER::default();

        match unsafe { CoGetApartmentType(&mut apartment, &mut qualifier) } {
            Err(error) if error.code() == CO_E_NOTINITIALIZED => Ok(None),
            Err(error) => Err(error),
            // Other tests can keep the process MTA alive without initializing this thread.
            Ok(()) if apartment == APTTYPE_MTA && qualifier == APTTYPEQUALIFIER_IMPLICIT_MTA => {
                Ok(None)
            }
            Ok(()) => Ok(Some((apartment, qualifier))),
        }
    }

    fn subpixel_variants() -> impl Iterator<Item = Point<u8>> {
        (0..SUBPIXEL_VARIANTS_X).flat_map(|subpixel_x| {
            (0..SUBPIXEL_VARIANTS_Y).map(move |subpixel_y| point(subpixel_x, subpixel_y))
        })
    }

    fn assert_foreground_alpha(actual: &RasterizedGlyph, opaque: &RasterizedGlyph, alpha: u8) {
        if alpha == 0 {
            assert_eq!(actual.size, Size::default());
            assert!(actual.pixels.is_empty());

            return;
        }

        assert_eq!(actual.bounds, opaque.bounds);

        for (actual, opaque) in actual
            .pixels
            .chunks_exact(4)
            .zip(opaque.pixels.chunks_exact(4))
        {
            assert_eq!(
                actual[3],
                ((opaque[3] as u16 * alpha as u16 + 127) / 255) as u8
            );

            if actual[3] == 0 {
                assert_eq!(actual, [0; 4]);
            } else {
                assert_eq!(actual[..3], opaque[..3]);
            }
        }
    }

    fn assert_color_bounds(
        system: &DirectWriteTextSystem,
        character: char,
        params: &RenderGlyphParams,
    ) -> Result<()> {
        // Load the native face through Parley's selected instance first.
        let actual = system.rasterize_glyph(params)?;
        actual.validate()?;
        assert!(!actual.pixels.is_empty());

        let renderer = system.renderer.read();
        let glyph_analysis = renderer.create_glyph_run_analysis(params)?;
        let base_bounds =
            unsafe { glyph_analysis.GetAlphaTextureBounds(DWRITE_TEXTURE_ALIASED_1x1)? };

        if character == ' ' {
            // Empty bounds can retain the glyph run's translated origin.
            assert_eq!(base_bounds.right, base_bounds.left);
            assert_eq!(base_bounds.bottom, base_bounds.top);
        } else {
            assert!(actual.size.width.0 > base_bounds.right - base_bounds.left);
        }

        // A larger target detects artwork that the calculated bounds would clip.
        let padded_bounds = Bounds {
            origin: point(
                (actual.bounds.origin.x.0 - 4).into(),
                (actual.bounds.origin.y.0 - 4).into(),
            ),
            size: size(
                (actual.size.width.0 + 8).into(),
                (actual.size.height.0 + 8).into(),
            ),
        };
        let padded = renderer.rasterize_color(params, padded_bounds)?;
        padded.validate()?;
        assert_padded_color_matches(&actual, &padded);

        Ok(())
    }

    fn assert_padded_color_matches(actual: &RasterizedGlyph, padded: &RasterizedGlyph) {
        let actual_width = actual.size.width.0 as usize;
        let padded_width = padded.size.width.0 as usize;

        for (pixel_index, pixel) in padded.pixels.chunks_exact(4).enumerate() {
            let column = pixel_index % padded_width;
            let row = pixel_index / padded_width;
            let actual_x = padded.bounds.origin.x.0 + column as i32 - actual.bounds.origin.x.0;
            let actual_y = padded.bounds.origin.y.0 + row as i32 - actual.bounds.origin.y.0;

            if actual_x < 0
                || actual_y < 0
                || actual_x >= actual.size.width.0
                || actual_y >= actual.size.height.0
            {
                assert_eq!(pixel, [0; 4], "color ink extends outside raster bounds");

                continue;
            }

            let offset = (actual_y as usize * actual_width + actual_x as usize) * 4;
            assert_eq!(pixel, &actual.pixels[offset..offset + 4]);
        }
    }

    fn color_test_system() -> Result<(DirectWriteTextSystem, FontId)> {
        let outline_system = DirectWriteTextSystem::new_headless()?;
        outline_system.add_fonts(vec![Cow::Borrowed(IBM_PLEX)])?;
        let font_id = outline_system.font_id(&font("IBM Plex Sans"))?;
        let mut glyphs = [0; 6];

        for (index, character) in ['A', 'B', 'i', ' ', 'H', 'O'].into_iter().enumerate() {
            glyphs[index] = outline_system.glyph_for_char(font_id, character).unwrap().0 as u16;
        }

        let system = DirectWriteTextSystem::new_headless()?;
        system.add_fonts(vec![Cow::Owned(test_color_font(glyphs))])?;
        let font_id = system.font_id(&font("IBM Plex Sans"))?;

        Ok((system, font_id))
    }

    fn test_color_font(glyphs: [u16; 6]) -> Vec<u8> {
        let [
            palette,
            foreground,
            small_base,
            empty_base,
            first_layer,
            second_layer,
        ] = glyphs;
        let mut base_records: [(u16, Vec<(u16, u16)>); 4] = [
            (palette, vec![(first_layer, 0), (second_layer, 1)]),
            (foreground, vec![(first_layer, 0xffff), (second_layer, 1)]),
            (small_base, vec![(first_layer, 0), (second_layer, 1)]),
            (empty_base, vec![(first_layer, 0)]),
        ];
        base_records.sort_by_key(|record| record.0);

        let mut colr = Vec::new();
        colr.extend_from_slice(&0u16.to_be_bytes());
        colr.extend_from_slice(&(base_records.len() as u16).to_be_bytes());
        colr.extend_from_slice(&14u32.to_be_bytes());
        colr.extend_from_slice(&(14 + base_records.len() as u32 * 6).to_be_bytes());
        colr.extend_from_slice(&7u16.to_be_bytes());

        let mut layer_index = 0u16;

        for (glyph_id, layers) in &base_records {
            colr.extend_from_slice(&glyph_id.to_be_bytes());
            colr.extend_from_slice(&layer_index.to_be_bytes());
            colr.extend_from_slice(&(layers.len() as u16).to_be_bytes());
            layer_index += layers.len() as u16;
        }

        for (_glyph_id, layers) in &base_records {
            for (glyph_id, palette_index) in layers {
                colr.extend_from_slice(&glyph_id.to_be_bytes());
                colr.extend_from_slice(&palette_index.to_be_bytes());
            }
        }

        // One opaque red and one half-transparent blue CPAL entry.
        let cpal = vec![
            0, 0, 0, 2, 0, 1, 0, 2, 0, 0, 0, 14, 0, 0, 0, 0, 255, 255, 255, 0, 0, 128,
        ];
        let table_count = read_u16(IBM_PLEX, 4).unwrap() as usize;
        let mut tables = BTreeMap::new();

        for table_index in 0..table_count {
            let record = 12 + table_index * 16;
            let tag: [u8; 4] = IBM_PLEX[record..record + 4].try_into().unwrap();
            let offset = read_u32(IBM_PLEX, record + 8).unwrap() as usize;
            let length = read_u32(IBM_PLEX, record + 12).unwrap() as usize;
            tables.insert(tag, IBM_PLEX[offset..offset + length].to_vec());
        }

        tables.insert(*b"COLR", colr);
        tables.insert(*b"CPAL", cpal);
        tables.get_mut(b"head").unwrap()[8..12].fill(0);

        let table_count = tables.len() as u16;
        let search_range = (1u16 << table_count.ilog2()) * 16;
        let mut font = vec![0; 12 + tables.len() * 16];
        font[..4].copy_from_slice(&IBM_PLEX[..4]);
        font[4..6].copy_from_slice(&table_count.to_be_bytes());
        font[6..8].copy_from_slice(&search_range.to_be_bytes());
        font[8..10].copy_from_slice(&(table_count.ilog2() as u16).to_be_bytes());
        font[10..12].copy_from_slice(&(table_count * 16 - search_range).to_be_bytes());

        let mut head_offset = 0;

        for (table_index, (tag, data)) in tables.into_iter().enumerate() {
            let offset = font.len();
            let record = 12 + table_index * 16;
            font[record..record + 4].copy_from_slice(&tag);
            font[record + 4..record + 8].copy_from_slice(&sfnt_checksum(&data).to_be_bytes());
            font[record + 8..record + 12].copy_from_slice(&(offset as u32).to_be_bytes());
            font[record + 12..record + 16].copy_from_slice(&(data.len() as u32).to_be_bytes());

            if tag == *b"head" {
                head_offset = offset;
            }

            font.extend_from_slice(&data);

            while !font.len().is_multiple_of(4) {
                font.push(0);
            }
        }

        let adjustment = 0xb1b0_afbau32.wrapping_sub(sfnt_checksum(&font));
        font[head_offset + 8..head_offset + 12].copy_from_slice(&adjustment.to_be_bytes());

        font
    }

    fn sfnt_checksum(data: &[u8]) -> u32 {
        data.chunks(4).fold(0u32, |checksum, chunk| {
            let mut word = [0; 4];
            word[..chunk.len()].copy_from_slice(chunk);

            checksum.wrapping_add(u32::from_be_bytes(word))
        })
    }

    fn rasterize(
        system: &DirectWriteTextSystem,
        font_id: FontId,
        glyph_id: GlyphId,
        mode: GlyphRenderMode,
        subpixel_variant: Point<u8>,
        scale_factor: f32,
    ) -> Result<RasterizedGlyph> {
        let raster_style = system.prepare_raster_style(RasterStyleRequest {
            font_id,
            glyph_id,
            scene_color: rgba(0xffffffff),
            requested_mode: mode,
            foreground_dependency: ForegroundDependency::Full,
        });

        system.rasterize_glyph(&RenderGlyphParams {
            font_id,
            glyph_id,
            font_size: px(24.0),
            subpixel_variant,
            scale_factor,
            raster_style,
        })
    }

    fn test_collection(faces: &[&[u8]]) -> Vec<u8> {
        let header_len = 12 + faces.len() * 4;
        let mut collection = vec![0; header_len];
        collection[..4].copy_from_slice(b"ttcf");
        collection[4..8].copy_from_slice(&0x0001_0000u32.to_be_bytes());
        collection[8..12].copy_from_slice(&(faces.len() as u32).to_be_bytes());

        for (face_idx, face) in faces.iter().enumerate() {
            while collection.len() % 4 != 0 {
                collection.push(0);
            }

            let face_offset = collection.len();
            let offset_position = 12 + face_idx * 4;
            collection[offset_position..offset_position + 4]
                .copy_from_slice(&(face_offset as u32).to_be_bytes());
            collection.extend_from_slice(face);

            let table_count = read_u16(face, 4).expect("font has an SFNT table count") as usize;
            for table_idx in 0..table_count {
                let table_offset_position = face_offset + 12 + table_idx * 16 + 8;
                let table_offset = read_u32(&collection, table_offset_position)
                    .expect("font has an SFNT table offset");
                let collection_offset = table_offset + face_offset as u32;
                collection[table_offset_position..table_offset_position + 4]
                    .copy_from_slice(&collection_offset.to_be_bytes());
            }
        }

        collection
    }

    fn read_u16(data: &[u8], offset: usize) -> Option<u16> {
        Some(u16::from_be_bytes(
            data.get(offset..offset + 2)?.try_into().ok()?,
        ))
    }

    fn read_u32(data: &[u8], offset: usize) -> Option<u32> {
        Some(u32::from_be_bytes(
            data.get(offset..offset + 4)?.try_into().ok()?,
        ))
    }
}
