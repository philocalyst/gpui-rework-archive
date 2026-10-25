//! Exact GPUI platform text services, executed by the existing compiled backend.
//! Interaction layouts stay in the service; the guest retains real trait objects
//! which forward every native layout operation without approximating its semantics.
use gpui::*;
use serde::{Deserialize, Serialize, de::DeserializeOwned};
use std::{borrow::Cow, ops::Range, sync::Arc};
#[derive(Serialize, Deserialize)]
pub enum Call {
    Reset,
    AddFonts {
        fonts: Vec<Vec<u8>>,
    },
    Text {
        text: String,
        font_size: Pixels,
        runs: Vec<TextRun>,
        options: TextLayoutOptions,
    },
    Inline {
        text: String,
        runs: Vec<TextRun>,
        styles: Vec<InlineTextStyle>,
        boxes: Vec<InlineBoxRequest>,
        font_size: Pixels,
        line_height: Pixels,
        metrics: InlineTextMetrics,
        options: TextLayoutOptions,
        scopes: Vec<InlineBidiScope>,
    },
    Release {
        id: u64,
    },
    Names {},
    Generation {},
    Font {
        descriptor: Font,
    },
    Metrics {
        font_id: FontId,
    },
    Bounds {
        font_id: FontId,
        glyph_id: GlyphId,
    },
    Advance {
        font_id: FontId,
        glyph_id: GlyphId,
    },
    Glyph {
        font_id: FontId,
        ch: char,
    },
    Raster {
        params: RenderGlyphParams,
    },
    Style {
        request: RasterStyleRequest,
    },
    Mode {
        font_id: FontId,
        font_size: Pixels,
    },
    Byte {
        id: u64,
        point: Point<Pixels>,
        height: Pixels,
    },
    Caret {
        id: u64,
        point: Point<Pixels>,
        height: Pixels,
    },
    CaretBounds {
        id: u64,
        caret: CaretPosition,
        height: Pixels,
    },
    Normalize {
        id: u64,
        caret: CaretPosition,
    },
    Adjacent {
        id: u64,
        caret: CaretPosition,
        direction: VisualDirection,
    },
    Selection {
        id: u64,
        range: Range<usize>,
        height: Pixels,
    },
    Geometry {
        id: u64,
        range: Range<usize>,
    },
    Geometries {
        id: u64,
        ranges: Vec<Range<usize>>,
    },
    Before {
        id: u64,
        caret: CaretPosition,
    },
    After {
        id: u64,
        caret: CaretPosition,
    },
    Movement {
        id: u64,
        caret: CaretPosition,
        movement: TextMovement,
        x: Option<Pixels>,
    },
    SelectPoint {
        id: u64,
        point: Point<Pixels>,
        height: Pixels,
        kind: TextSelectionKind,
    },
    PrewarmGlyphs {
        requests: Vec<GlyphRasterRequest>,
    },
}

type RasterStyleKey = (usize, u32, GlyphRenderMode, ForegroundDependency, [u32; 4]);
fn style_key(request: RasterStyleRequest) -> RasterStyleKey {
    let color = request.scene_color;
    (
        request.font_id.0,
        request.glyph_id.0,
        request.requested_mode,
        request.foreground_dependency,
        [
            color.color.red.to_bits(),
            color.color.green.to_bits(),
            color.color.blue.to_bits(),
            color.alpha.to_bits(),
        ],
    )
}
#[derive(Serialize, Deserialize)]
struct PreparedGlyph {
    request: GlyphRasterRequest,
    params: RenderGlyphParams,
    raster: Result<RasterizedGlyph, String>,
}
const MAX_PREPARED_BYTES: usize = 8 * 1024 * 1024;
#[derive(Default)]
struct PreparedRasters {
    entries: collections::HashMap<RenderGlyphParams, Result<RasterizedGlyph, String>>,
    bytes: usize,
}
impl PreparedRasters {
    fn clear(&mut self) {
        self.entries.clear();
        self.bytes = 0;
    }
    fn remove(&mut self, params: &RenderGlyphParams) -> Option<Result<RasterizedGlyph, String>> {
        let raster = self.entries.remove(params)?;
        self.bytes -= raster.as_ref().map_or(0, |r| r.pixels.len());
        Some(raster)
    }
    fn insert(&mut self, params: RenderGlyphParams, raster: Result<RasterizedGlyph, String>) {
        self.remove(&params);
        let bytes = raster.as_ref().map_or(0, |r| r.pixels.len());
        if bytes > MAX_PREPARED_BYTES {
            return;
        }
        if self.bytes + bytes > MAX_PREPARED_BYTES || self.entries.len() >= 4096 {
            self.clear();
        }
        self.bytes += bytes;
        self.entries.insert(params, raster);
    }
}
#[derive(Serialize, Deserialize)]
struct LineData {
    id: u64,
    font_size: Pixels,
    width: Pixels,
    ascent: Pixels,
    descent: Pixels,
    lines: Vec<VisualLine>,
    fragments: Vec<PaintFragment>,
    len: usize,
    line_count: usize,
    size: Size<Pixels>,
}
#[derive(Serialize, Deserialize)]
struct InlineData {
    line: LineData,
    lines: Vec<InlineVisualLine>,
    boxes: Vec<PositionedInlineBox>,
    alignment_offset: Pixels,
    size: Size<Pixels>,
}
#[cfg(any(miri, feature = "host-services"))]
fn encode(value: &impl Serialize) -> Vec<u8> {
    crate::wire::encode_value(value).expect("platform response encoding")
}

#[cfg(miri)]
fn call<R: DeserializeOwned>(request: Call) -> anyhow::Result<R> {
    unsafe extern "C" {
        fn gpui_codepen_rpc_start(bytes: *const u8, len: usize) -> usize;
        fn gpui_codepen_rpc_read(bytes: *mut u8, len: usize);
    }
    let input = encode(&request);
    let len = unsafe { gpui_codepen_rpc_start(input.as_ptr(), input.len()) };
    assert!(
        len <= crate::MAX_FRAME_BYTES,
        "platform response exceeds budget"
    );
    let mut bytes = Vec::with_capacity(len);
    unsafe {
        gpui_codepen_rpc_read(bytes.as_mut_ptr(), len);
        bytes.set_len(len);
    }
    let result: Result<R, String> =
        crate::wire::decode_value(&bytes).map_err(anyhow::Error::msg)?;
    result.map_err(anyhow::Error::msg)
}
#[cfg(not(miri))]
fn call<R: DeserializeOwned>(_: Call) -> anyhow::Result<R> {
    anyhow::bail!("remote platform requires Miri")
}

#[derive(Debug)]
struct RemoteLayout {
    id: u64,
    len: usize,
    line_count: usize,
    size: Size<Pixels>,
}
impl Drop for RemoteLayout {
    fn drop(&mut self) {
        let _: anyhow::Result<()> = call(Call::Release { id: self.id });
    }
}
impl LineData {
    fn into_line(self) -> LineLayout {
        LineLayout {
            font_size: self.font_size,
            width: self.width,
            ascent: self.ascent,
            descent: self.descent,
            visual_lines: self.lines.into_iter().collect(),
            paint_fragments: self.fragments,
            len: self.len,
            platform_layout: Arc::new(RemoteLayout {
                id: self.id,
                len: self.len,
                line_count: self.line_count,
                size: self.size,
            }),
        }
    }
}
#[derive(Default)]
pub struct RemoteTextSystem {
    generation: std::sync::atomic::AtomicU64,
    modes: std::sync::Mutex<collections::HashMap<(usize, u32), TextRenderingMode>>,
    styles: std::sync::Mutex<collections::HashMap<RasterStyleKey, PreparedRasterStyle>>,
    prepared: std::sync::Mutex<PreparedRasters>,
    rasterized: std::sync::Mutex<collections::HashSet<RenderGlyphParams>>,
}

fn remember_raster(cache: &mut collections::HashSet<RenderGlyphParams>, params: RenderGlyphParams) {
    if cache.len() >= 4096 && !cache.contains(&params) {
        cache.clear();
    }
    cache.insert(params);
}
#[cfg(miri)]
pub(crate) fn begin_session() {
    call::<()>(Call::Reset).expect("platform session initialization");
}
impl RemoteTextSystem {
    pub fn new() -> Self {
        Self {
            generation: std::sync::atomic::AtomicU64::new(
                call(Call::Generation {}).expect("font generation"),
            ),
            ..Default::default()
        }
    }
    #[cfg(miri)]
    pub(crate) fn refresh_font_generation(&self) -> bool {
        let generation: u64 = call(Call::Generation {}).expect("font generation");
        if self
            .generation
            .swap(generation, std::sync::atomic::Ordering::Relaxed)
            == generation
        {
            return false;
        }
        self.styles.lock().unwrap().clear();
        self.modes.lock().unwrap().clear();
        self.prepared.lock().unwrap().clear();
        self.rasterized.lock().unwrap().clear();
        true
    }
}
impl PlatformTextSystem for RemoteTextSystem {
    fn add_fonts(&self, fonts: Vec<Cow<'static, [u8]>>) -> anyhow::Result<()> {
        let generation: u64 = call(Call::AddFonts {
            fonts: fonts.into_iter().map(|f| f.into_owned()).collect(),
        })?;
        self.generation
            .store(generation, std::sync::atomic::Ordering::Relaxed);
        self.styles.lock().unwrap().clear();
        self.modes.lock().unwrap().clear();
        self.prepared.lock().unwrap().clear();
        self.rasterized.lock().unwrap().clear();
        Ok(())
    }
    fn all_font_names(&self) -> Vec<String> {
        call(Call::Names {}).expect("font names")
    }
    fn font_generation(&self) -> u64 {
        self.generation.load(std::sync::atomic::Ordering::Relaxed)
    }
    fn font_id(&self, descriptor: &Font) -> anyhow::Result<FontId> {
        call(Call::Font {
            descriptor: descriptor.clone(),
        })
    }
    fn font_metrics(&self, font_id: FontId) -> FontMetrics {
        call(Call::Metrics { font_id }).expect("font metrics")
    }
    fn typographic_bounds(
        &self,
        font_id: FontId,
        glyph_id: GlyphId,
    ) -> anyhow::Result<Bounds<f32>> {
        call(Call::Bounds { font_id, glyph_id })
    }
    fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> anyhow::Result<Size<f32>> {
        call(Call::Advance { font_id, glyph_id })
    }
    fn glyph_for_char(&self, font_id: FontId, ch: char) -> Option<GlyphId> {
        call(Call::Glyph { font_id, ch }).expect("character mapping")
    }
    fn rasterize_glyph(&self, params: &RenderGlyphParams) -> anyhow::Result<RasterizedGlyph> {
        if let Some(raster) = self.prepared.lock().unwrap().remove(params) {
            return raster.map_err(anyhow::Error::msg);
        }
        let raster = call(Call::Raster {
            params: params.clone(),
        })?;
        remember_raster(&mut self.rasterized.lock().unwrap(), params.clone());
        Ok(raster)
    }
    fn prewarm_glyphs(&self, requests: &mut dyn Iterator<Item = GlyphRasterRequest>) {
        // Leftover prefetches belonged to the previous fragment. Its atlas may
        // have already held those pixels, so no paint call consumed them.
        self.prepared.lock().unwrap().clear();
        let mut batch = Vec::new();
        let mut scheduled = collections::HashSet::default();
        for request in requests {
            let key = style_key(request.style);
            let style = self.styles.lock().unwrap().get(&key).copied();
            if let Some(style) = style {
                let params = request.with_style(style);
                if self.rasterized.lock().unwrap().contains(&params)
                    || self.prepared.lock().unwrap().entries.contains_key(&params)
                {
                    continue;
                }
            }
            let key = (
                key,
                f32::from(request.font_size).to_bits(),
                request.subpixel_variant,
                request.scale_factor.to_bits(),
            );
            if scheduled.insert(key) {
                batch.push(request);
            }
            if batch.len() == 256 {
                self.prepare_batch(std::mem::take(&mut batch));
            }
        }
        if !batch.is_empty() {
            self.prepare_batch(batch);
        }
    }
    fn prepare_raster_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
        let key = style_key(request);
        let mut styles = self.styles.lock().unwrap();
        if let Some(style) = styles.get(&key) {
            return *style;
        }
        let style = call(Call::Style { request }).expect("raster style");
        if styles.len() >= 4096 {
            styles.clear();
        }
        styles.insert(key, style);
        style
    }
    fn recommended_rendering_mode(&self, font_id: FontId, font_size: Pixels) -> TextRenderingMode {
        let key = (font_id.0, f32::from(font_size).to_bits());
        let mut modes = self.modes.lock().unwrap();
        if modes.len() >= 4096 {
            modes.clear();
        }
        *modes
            .entry(key)
            .or_insert_with(|| call(Call::Mode { font_id, font_size }).expect("raster mode"))
    }
    fn layout_text(&self, r: TextLayoutRequest<'_>) -> LineLayout {
        let data: LineData = call(Call::Text {
            text: r.text.into(),
            font_size: r.font_size,
            runs: r.runs.to_vec(),
            options: r.options,
        })
        .expect("text layout");
        data.into_line()
    }
    fn layout_inline(&self, r: InlineLayoutRequest<'_>) -> InlineLayout {
        let data: InlineData = call(Call::Inline {
            text: r.text.into(),
            runs: r.runs.to_vec(),
            styles: r.text_styles.to_vec(),
            boxes: r.boxes.to_vec(),
            font_size: r.font_size,
            line_height: r.line_height,
            metrics: r.text_metrics,
            options: r.options,
            scopes: r.bidi_scopes.to_vec(),
        })
        .expect("inline layout");
        InlineLayout {
            layout: Arc::new(data.line.into_line()),
            lines: data.lines,
            boxes: data.boxes,
            alignment_offset: data.alignment_offset,
            size: data.size,
        }
    }
}
impl RemoteTextSystem {
    fn prepare_batch(&self, requests: Vec<GlyphRasterRequest>) {
        // A failed optional batch falls back to ordinary per-glyph calls,
        // retaining their original diagnostics and rasterization behavior.
        if let Ok(glyphs) = call::<Vec<PreparedGlyph>>(Call::PrewarmGlyphs { requests }) {
            let mut styles = self.styles.lock().unwrap();
            let mut prepared = self.prepared.lock().unwrap();
            let mut rasterized = self.rasterized.lock().unwrap();
            for glyph in glyphs {
                if styles.len() >= 4096 {
                    styles.clear();
                }
                styles.insert(style_key(glyph.request.style), glyph.params.raster_style);
                if glyph.raster.is_ok() {
                    remember_raster(&mut rasterized, glyph.params.clone());
                }
                prepared.insert(glyph.params, glyph.raster);
            }
        }
    }
}
impl PlatformTextLayout for RemoteLayout {
    fn len(&self) -> usize {
        self.len
    }
    fn line_count(&self) -> usize {
        self.line_count
    }
    fn size(&self) -> Size<Pixels> {
        self.size
    }
    fn byte_index_from_pixel_point(
        &self,
        point: Point<Pixels>,
        height: Pixels,
    ) -> Result<usize, usize> {
        call(Call::Byte {
            id: self.id,
            point,
            height,
        })
        .expect("text hit testing")
    }
    fn caret_from_pixel_point(
        &self,
        point: Point<Pixels>,
        height: Pixels,
    ) -> Result<CaretPosition, CaretPosition> {
        call(Call::Caret {
            id: self.id,
            point,
            height,
        })
        .expect("caret hit testing")
    }
    fn caret_bounds(&self, caret: CaretPosition, height: Pixels) -> Option<Bounds<Pixels>> {
        call(Call::CaretBounds {
            id: self.id,
            caret,
            height,
        })
        .expect("caret bounds")
    }
    fn normalized_caret(&self, caret: CaretPosition) -> CaretPosition {
        call(Call::Normalize { id: self.id, caret }).expect("caret normalization")
    }
    fn adjacent_visual_caret(
        &self,
        caret: CaretPosition,
        direction: VisualDirection,
    ) -> Option<CaretPosition> {
        call(Call::Adjacent {
            id: self.id,
            caret,
            direction,
        })
        .expect("visual caret")
    }
    fn selection_bounds(&self, range: Range<usize>, height: Pixels) -> Vec<Bounds<Pixels>> {
        call(Call::Selection {
            id: self.id,
            range,
            height,
        })
        .expect("selection bounds")
    }
    fn inline_geometry(&self, range: Range<usize>) -> Option<Vec<InlineRangeGeometry>> {
        call(Call::Geometry { id: self.id, range }).expect("inline geometry")
    }
    fn inline_geometry_for_ranges(&self, ranges: &[Range<usize>]) -> Vec<Vec<InlineRangeGeometry>> {
        call(Call::Geometries {
            id: self.id,
            ranges: ranges.to_vec(),
        })
        .expect("inline geometries")
    }
    fn logical_cluster_before(&self, caret: CaretPosition) -> Option<Range<usize>> {
        call(Call::Before { id: self.id, caret }).expect("cluster before")
    }
    fn logical_cluster_after(&self, caret: CaretPosition) -> Option<Range<usize>> {
        call(Call::After { id: self.id, caret }).expect("cluster after")
    }
    fn caret_movement(
        &self,
        caret: CaretPosition,
        movement: TextMovement,
        x: Option<Pixels>,
    ) -> CaretMovement {
        call(Call::Movement {
            id: self.id,
            caret,
            movement,
            x,
        })
        .expect("caret movement")
    }
    fn selection_from_pixel_point(
        &self,
        point: Point<Pixels>,
        height: Pixels,
        kind: TextSelectionKind,
    ) -> Range<usize> {
        call(Call::SelectPoint {
            id: self.id,
            point,
            height,
            kind,
        })
        .expect("selection hit testing")
    }
}

#[cfg(feature = "host-services")]
pub struct TextService {
    text: Arc<dyn PlatformTextSystem>,
    factory: TextSystemFactory,
    layouts: collections::HashMap<u64, Arc<dyn PlatformTextLayout>>,
    next: u64,
    dynamic_fonts: bool,
}
#[cfg(feature = "host-services")]
pub type TextSystemFactory =
    Arc<dyn Fn() -> anyhow::Result<Arc<dyn PlatformTextSystem>> + Send + Sync>;
#[cfg(feature = "host-services")]
impl TextService {
    pub fn new() -> anyhow::Result<Self> {
        Self::with_factory(Self::portable_factory())
    }
    pub fn portable_factory() -> TextSystemFactory {
        Arc::new(|| {
            Ok(Arc::new(
                gpui_ce_parley::ParleyTextSystem::without_system_fonts(),
            ))
        })
    }
    pub fn with_factory(factory: TextSystemFactory) -> anyhow::Result<Self> {
        let text = factory()?;
        text.add_fonts(vec![
            Cow::Borrowed(include_bytes!(
                "../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf"
            )),
            Cow::Borrowed(include_bytes!(
                "../../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBold.ttf"
            )),
            Cow::Borrowed(include_bytes!("../../assets/fonts/lilex/Lilex-Regular.ttf")),
        ])?;
        Ok(Self {
            text,
            factory,
            layouts: Default::default(),
            next: 0,
            dynamic_fonts: false,
        })
    }
    fn layout(&self, id: u64) -> anyhow::Result<&dyn PlatformTextLayout> {
        self.layouts
            .get(&id)
            .map(|v| v.as_ref())
            .ok_or_else(|| anyhow::anyhow!("expired text layout"))
    }
    fn line(&mut self, line: LineLayout) -> LineData {
        self.next += 1;
        let id = self.next;
        let data = LineData {
            id,
            font_size: line.font_size,
            width: line.width,
            ascent: line.ascent,
            descent: line.descent,
            lines: line.visual_lines.to_vec(),
            fragments: line.paint_fragments,
            len: line.len,
            line_count: line.platform_layout.line_count(),
            size: line.platform_layout.size(),
        };
        self.layouts.insert(id, line.platform_layout);
        data
    }
    pub fn handle(&mut self, bytes: &[u8]) -> Vec<u8> {
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(
            || -> anyhow::Result<Vec<u8>> {
                let request: Call = crate::wire::decode_value(bytes).map_err(anyhow::Error::msg)?;
                Ok(match request {
                    Call::Reset => {
                        if self.dynamic_fonts {
                            *self = Self::with_factory(self.factory.clone())?;
                        }
                        self.layouts.clear();
                        encode(&Ok::<_, String>(()))
                    }
                    Call::AddFonts { fonts } => {
                        anyhow::ensure!(
                            fonts.len() <= 128
                                && fonts.iter().map(Vec::len).sum::<usize>() <= 32 * 1024 * 1024,
                            "font upload exceeds platform budget"
                        );
                        self.text
                            .add_fonts(fonts.into_iter().map(Cow::Owned).collect())?;
                        self.dynamic_fonts = true;
                        encode(&Ok::<_, String>(self.text.font_generation()))
                    }
                    Call::Release { id } => {
                        self.layouts.remove(&id);
                        encode(&Ok::<_, String>(()))
                    }
                    Call::Text {
                        text,
                        font_size,
                        runs,
                        options,
                    } => {
                        anyhow::ensure!(
                            text.len() <= 1024 * 1024 && runs.len() <= 16384,
                            "text layout exceeds platform budget"
                        );
                        let line = self.text.layout_text(TextLayoutRequest {
                            text: &text,
                            font_size,
                            runs: &runs,
                            options,
                        });
                        let data = self.line(line);
                        encode(&Ok::<_, String>(data))
                    }
                    Call::Inline {
                        text,
                        runs,
                        styles,
                        boxes,
                        font_size,
                        line_height,
                        metrics,
                        options,
                        scopes,
                    } => {
                        anyhow::ensure!(
                            text.len() <= 1024 * 1024
                                && runs.len() <= 16384
                                && styles.len() <= 16384
                                && boxes.len() <= 16384
                                && scopes.len() <= 16384,
                            "inline layout exceeds platform budget"
                        );
                        let layout = self.text.layout_inline(InlineLayoutRequest {
                            text: &text,
                            runs: &runs,
                            text_styles: &styles,
                            boxes: &boxes,
                            font_size,
                            line_height,
                            text_metrics: metrics,
                            options,
                            bidi_scopes: &scopes,
                        });
                        let line = self.line((*layout.layout).clone());
                        let data = InlineData {
                            line,
                            lines: layout.lines,
                            boxes: layout.boxes,
                            alignment_offset: layout.alignment_offset,
                            size: layout.size,
                        };
                        encode(&Ok::<_, String>(data))
                    }
                    Call::Names {} => {
                        encode(&Ok::<Vec<String>, String>(self.text.all_font_names()))
                    }
                    Call::Generation {} => encode(&Ok::<u64, String>(self.text.font_generation())),
                    Call::Font { descriptor } => {
                        encode(&Ok::<FontId, String>(self.text.font_id(&descriptor)?))
                    }
                    Call::Metrics { font_id } => {
                        encode(&Ok::<FontMetrics, String>(self.text.font_metrics(font_id)))
                    }
                    Call::Bounds { font_id, glyph_id } => encode(&Ok::<Bounds<f32>, String>(
                        self.text.typographic_bounds(font_id, glyph_id)?,
                    )),
                    Call::Advance { font_id, glyph_id } => encode(&Ok::<Size<f32>, String>(
                        self.text.advance(font_id, glyph_id)?,
                    )),
                    Call::Glyph { font_id, ch } => encode(&Ok::<Option<GlyphId>, String>(
                        self.text.glyph_for_char(font_id, ch),
                    )),
                    Call::Raster { params } => encode(&Ok::<RasterizedGlyph, String>(
                        self.text.rasterize_glyph(&params)?,
                    )),
                    Call::Style { request } => encode(&Ok::<PreparedRasterStyle, String>(
                        self.text.prepare_raster_style(request),
                    )),
                    Call::Mode { font_id, font_size } => encode(&Ok::<TextRenderingMode, String>(
                        self.text.recommended_rendering_mode(font_id, font_size),
                    )),
                    Call::Byte { id, point, height } => {
                        encode(&Ok::<Result<usize, usize>, String>(
                            self.layout(id)?.byte_index_from_pixel_point(point, height),
                        ))
                    }
                    Call::Caret { id, point, height } => {
                        encode(&Ok::<Result<CaretPosition, CaretPosition>, String>(
                            self.layout(id)?.caret_from_pixel_point(point, height),
                        ))
                    }
                    Call::CaretBounds { id, caret, height } => {
                        encode(&Ok::<Option<Bounds<Pixels>>, String>(
                            self.layout(id)?.caret_bounds(caret, height),
                        ))
                    }
                    Call::Normalize { id, caret } => encode(&Ok::<CaretPosition, String>(
                        self.layout(id)?.normalized_caret(caret),
                    )),
                    Call::Adjacent {
                        id,
                        caret,
                        direction,
                    } => encode(&Ok::<Option<CaretPosition>, String>(
                        self.layout(id)?.adjacent_visual_caret(caret, direction),
                    )),
                    Call::Selection { id, range, height } => {
                        encode(&Ok::<Vec<Bounds<Pixels>>, String>(
                            self.layout(id)?.selection_bounds(range, height),
                        ))
                    }
                    Call::Geometry { id, range } => {
                        encode(&Ok::<Option<Vec<InlineRangeGeometry>>, String>(
                            self.layout(id)?.inline_geometry(range),
                        ))
                    }
                    Call::Geometries { id, ranges } => {
                        encode(&Ok::<Vec<Vec<InlineRangeGeometry>>, String>(
                            self.layout(id)?.inline_geometry_for_ranges(&ranges),
                        ))
                    }
                    Call::Before { id, caret } => encode(&Ok::<Option<Range<usize>>, String>(
                        self.layout(id)?.logical_cluster_before(caret),
                    )),
                    Call::After { id, caret } => encode(&Ok::<Option<Range<usize>>, String>(
                        self.layout(id)?.logical_cluster_after(caret),
                    )),
                    Call::Movement {
                        id,
                        caret,
                        movement,
                        x,
                    } => encode(&Ok::<CaretMovement, String>(
                        self.layout(id)?.caret_movement(caret, movement, x),
                    )),
                    Call::SelectPoint {
                        id,
                        point,
                        height,
                        kind,
                    } => encode(&Ok::<Range<usize>, String>(
                        self.layout(id)?
                            .selection_from_pixel_point(point, height, kind),
                    )),
                    Call::PrewarmGlyphs { requests } => {
                        anyhow::ensure!(
                            requests.len() <= 256,
                            "glyph preparation batch exceeds budget"
                        );
                        let mut glyphs = Vec::with_capacity(requests.len());
                        let mut bytes = 0;
                        for request in requests {
                            let style = self.text.prepare_raster_style(request.style);
                            let params = request.with_style(style);
                            let raster = self
                                .text
                                .rasterize_glyph(&params)
                                .map_err(|error| format!("{error:#}"));
                            bytes += raster.as_ref().map_or(0, |r| r.pixels.len());
                            anyhow::ensure!(
                                bytes <= MAX_PREPARED_BYTES,
                                "glyph preparation pixels exceed batch budget"
                            );
                            glyphs.push(PreparedGlyph {
                                request,
                                params,
                                raster,
                            });
                        }
                        encode(&Ok::<_, String>(glyphs))
                    }
                })
            },
        ))
        .unwrap_or_else(|panic| {
            let message = panic
                .downcast_ref::<String>()
                .map(String::as_str)
                .or_else(|| panic.downcast_ref::<&str>().copied())
                .unwrap_or("unknown panic");
            Err(anyhow::anyhow!(
                "native GPUI text service panicked: {message}"
            ))
        });
        result.unwrap_or_else(|error| encode(&Err::<(), _>(format!("{error:#}"))))
    }
}

#[cfg(all(test, feature = "host-services"))]
mod tests {
    use super::*;
    use core::prelude::v1::test;
    fn invoke<R: DeserializeOwned>(service: &mut TextService, call: Call) -> anyhow::Result<R> {
        let bytes = service.handle(&encode(&call));
        let value: Result<R, String> =
            crate::wire::decode_value(&bytes).map_err(anyhow::Error::msg)?;
        value.map_err(anyhow::Error::msg)
    }
    #[test]
    fn batched_glyphs_match_native_styles_placement_and_pixels() {
        let mut service = TextService::new().unwrap();
        let font_id = service
            .text
            .font_id(&Font {
                family: "IBM Plex Sans".into(),
                ..Default::default()
            })
            .unwrap();
        let mut requests = Vec::new();
        for ch in ['A', ' ', 'é'] {
            let glyph_id = service.text.glyph_for_char(font_id, ch).unwrap();
            for requested_mode in [
                GlyphRenderMode::Grayscale,
                GlyphRenderMode::Subpixel,
                GlyphRenderMode::Color,
            ] {
                for scale_factor in [1., 2.] {
                    for subpixel_variant in [point(0, 0), point(3, 2)] {
                        requests.push(GlyphRasterRequest {
                            style: RasterStyleRequest {
                                font_id,
                                glyph_id,
                                scene_color: hsla_to_rgba(hsla(0.37, 0.61, 0.43, 0.83)),
                                requested_mode,
                                foreground_dependency: ForegroundDependency::Full,
                            },
                            font_size: px(16.),
                            subpixel_variant,
                            scale_factor,
                        });
                    }
                }
            }
        }
        let expected: Vec<_> = requests
            .iter()
            .map(|request| {
                let params = request.with_style(service.text.prepare_raster_style(request.style));
                let raster = service.text.rasterize_glyph(&params).unwrap();
                (params, raster)
            })
            .collect();
        let actual: Vec<PreparedGlyph> =
            invoke(&mut service, Call::PrewarmGlyphs { requests }).unwrap();
        assert_eq!(actual.len(), expected.len());
        for (actual, (params, raster)) in actual.into_iter().zip(expected) {
            assert_eq!(actual.params, params);
            let actual = actual.raster.unwrap();
            assert_eq!(actual.bounds, raster.bounds);
            assert_eq!(actual.size, raster.size);
            assert_eq!(actual.format, raster.format);
            assert_eq!(actual.pixels, raster.pixels);
        }
    }
    #[test]
    fn platform_bridge_preserves_bidi_carets_selection_and_layout_lifetimes() {
        let mut service = TextService::new().unwrap();
        let descriptor = Font {
            family: "IBM Plex Sans".into(),
            features: FontFeatures::disable_ligatures(),
            ..Default::default()
        };
        let _font: FontId = invoke(
            &mut service,
            Call::Font {
                descriptor: descriptor.clone(),
            },
        )
        .unwrap();
        let text = "hello שלום 👩‍💻 world";
        let runs = vec![TextRun {
            len: text.len(),
            font: descriptor,
            ..Default::default()
        }];
        let options = TextLayoutOptions::default();
        let direct = service.text.layout_text(TextLayoutRequest {
            text,
            font_size: px(16.),
            runs: &runs,
            options,
        });
        let remote: LineData = invoke(
            &mut service,
            Call::Text {
                text: text.into(),
                font_size: px(16.),
                runs,
                options,
            },
        )
        .unwrap();
        assert_eq!(remote.width, direct.width);
        assert_eq!(remote.fragments, direct.paint_fragments);
        for x in [0., 25., 70., 120., 200.] {
            let point = point(px(x), px(8.));
            let remote_caret: Result<CaretPosition, CaretPosition> = invoke(
                &mut service,
                Call::Caret {
                    id: remote.id,
                    point,
                    height: px(24.),
                },
            )
            .unwrap();
            assert_eq!(
                remote_caret,
                direct
                    .platform_layout
                    .caret_from_pixel_point(point, px(24.))
            );
        }
        let selection: Vec<Bounds<Pixels>> = invoke(
            &mut service,
            Call::Selection {
                id: remote.id,
                range: 0..text.len(),
                height: px(24.),
            },
        )
        .unwrap();
        assert_eq!(
            selection,
            direct
                .platform_layout
                .selection_bounds(0..text.len(), px(24.))
        );
        invoke::<()>(&mut service, Call::Release { id: remote.id }).unwrap();
        assert!(
            invoke::<CaretPosition>(
                &mut service,
                Call::Normalize {
                    id: remote.id,
                    caret: CaretPosition::default()
                }
            )
            .is_err()
        );
    }
    #[test]
    fn font_upload_returns_the_backend_generation() {
        let mut service = TextService::new().unwrap();
        let before: u64 = invoke(&mut service, Call::Generation {}).unwrap();
        let generation: u64 = invoke(
            &mut service,
            Call::AddFonts {
                fonts: vec![
                    include_bytes!("../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf")
                        .to_vec(),
                ],
            },
        )
        .unwrap();
        assert!(generation > before);
        assert_eq!(generation, service.text.font_generation());
    }
}
