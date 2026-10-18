use crate::canvas_fallback::{CanvasFontFallback, classify_canvas_fallback};
use crate::canvas_layout::{CanvasOverlay, CanvasPlatformTextLayout};
use crate::canvas_text::{self, CanvasTextMetrics};
use crate::glyph_cache::{CanvasGlyph, GlyphCache};
use anyhow::{Context as _, Result, ensure};
use gpui::{
    Bounds, CaretAffinity, CaretPosition, FallbackFontClass, Font, FontId, FontMetrics, FontStyle,
    GlyphId, GlyphRenderMode, InlineBoxRequest, InlineLayout, InlineLayoutRequest,
    InlineTextMetrics, InlineTextStyle, LineLayout, MissingGlyph, MissingGlyphSink, PaintFragment,
    Pixels, PlatformTextSystem, PreparedRasterStyle, RasterStyleRequest, RasterizedGlyph,
    RasterizedGlyphFormat, RenderGlyphParams, SUBPIXEL_VARIANTS_X, SUBPIXEL_VARIANTS_Y,
    ShapedGlyph, Size, TextLayoutRequest, TextRenderingMode, VerticalAlign, point, px, size,
};
use gpui_parley::{ParleyTextSystem, SystemFonts};
use parking_lot::RwLock;
use std::{
    borrow::Cow,
    collections::{HashMap, HashSet},
    ops::Range,
    sync::Arc,
};

const MAX_MEASUREMENTS: usize = 4096;

pub(crate) struct WebTextSystem {
    native: ParleyTextSystem,
    state: RwLock<State>,
    canvas_font_fallback: CanvasFontFallback,
}

#[derive(Default)]
struct State {
    missing_glyph_sink: Option<Arc<dyn MissingGlyphSink>>,
    descriptors: HashMap<FontId, Font>,
    native_font_ids: HashMap<FontId, FontId>,
    font_handles: HashMap<FontId, FontHandle>,
    next_font_id: usize,
    canvas_font_ids: HashMap<FontId, FontId>,
    glyphs: GlyphCache,
    measurements: HashMap<(FontId, GlyphId, Pixels), CanvasTextMetrics>,
}

#[derive(Clone)]
struct FallbackCandidate {
    source: Range<usize>,
    font_id: FontId,
    font_size: Pixels,
    color: bool,
    template: PaintFragment,
}

enum FontHandle {
    Native(FontId),
    Canvas(Arc<CanvasFont>),
}

struct CanvasFont {
    native_id: FontId,
    descriptor: Font,
    monospace: bool,
}

impl State {
    fn allocate_font_handle(&mut self, handle: FontHandle) -> Result<FontId> {
        let font_id = FontId(self.next_font_id);
        self.next_font_id = self
            .next_font_id
            .checked_add(1)
            .context("Web font handle space exhausted")?;
        self.font_handles.insert(font_id, handle);
        Ok(font_id)
    }

    fn public_native_font_id(&mut self, native_id: FontId) -> Result<FontId> {
        if let Some(font_id) = self.native_font_ids.get(&native_id) {
            return Ok(*font_id);
        }
        let font_id = self.allocate_font_handle(FontHandle::Native(native_id))?;
        self.native_font_ids.insert(native_id, font_id);
        Ok(font_id)
    }

    fn cached_fallback(
        &self,
        native_id: FontId,
        text: &str,
        color: bool,
        font_size: Pixels,
    ) -> Option<(FontId, GlyphId, CanvasTextMetrics)> {
        let font_id = *self.canvas_font_ids.get(&native_id)?;
        let glyph_id = self.glyphs.id_for(font_id, text, color)?;
        let metrics = *self.measurements.get(&(font_id, glyph_id, font_size))?;
        Some((font_id, glyph_id, metrics))
    }
}

impl WebTextSystem {
    pub(crate) fn new(
        system_font_fallback: &str,
        canvas_font_fallback: CanvasFontFallback,
    ) -> Self {
        Self {
            native: ParleyTextSystem::new_with_system_font(SystemFonts::Skip, system_font_fallback),
            state: RwLock::new(State::default()),
            canvas_font_fallback,
        }
    }

    fn canvas_font(&self, font_id: FontId) -> Option<Arc<CanvasFont>> {
        match self.state.read().font_handles.get(&font_id) {
            Some(FontHandle::Canvas(font)) => Some(font.clone()),
            _ => None,
        }
    }

    fn native_font_id(&self, font_id: FontId) -> FontId {
        match self.state.read().font_handles.get(&font_id) {
            Some(FontHandle::Native(native_id)) => *native_id,
            Some(FontHandle::Canvas(font)) => font.native_id,
            None => panic!("unknown Web font handle {font_id:?}"),
        }
    }

    fn public_font_id(&self, native_id: FontId) -> FontId {
        let mut state = self.state.write();
        if let Some(font_id) = state.native_font_ids.get(&native_id) {
            return *font_id;
        }
        state
            .public_native_font_id(native_id)
            .expect("Web font handle space exhausted")
    }

    fn expose_native_layout(&self, layout: &mut LineLayout) {
        for fragment in &mut layout.paint_fragments {
            fragment.font_id = self.public_font_id(fragment.font_id);
        }
    }

    fn expose_inline_layout(&self, layout: &mut InlineLayout) {
        let mut shaped_layout = (*layout.layout).clone();
        self.expose_native_layout(&mut shaped_layout);
        layout.layout = Arc::new(shaped_layout);
    }

    fn canvas_font_id(&self, source_font_id: FontId) -> Result<FontId> {
        let (native_id, descriptor) = {
            let state = self.state.read();
            if let Some(font_id) = state.canvas_font_ids.get(&source_font_id) {
                return Ok(*font_id);
            }
            let native_id = match state.font_handles.get(&source_font_id) {
                Some(FontHandle::Native(native_id)) => *native_id,
                Some(FontHandle::Canvas(_)) => {
                    anyhow::bail!("Canvas fallback source font is already a Canvas font")
                }
                None => anyhow::bail!("unknown source font handle for Canvas fallback"),
            };
            let descriptor = state
                .descriptors
                .get(&source_font_id)
                .cloned()
                .context("missing source font descriptor for Canvas fallback")?;
            (native_id, descriptor)
        };
        let monospace = match (
            self.native.glyph_for_char(native_id, 'i'),
            self.native.glyph_for_char(native_id, 'm'),
        ) {
            (Some(narrow), Some(wide)) => {
                self.native.advance(native_id, narrow)?.width
                    == self.native.advance(native_id, wide)?.width
            }
            _ => false,
        };
        let mut state = self.state.write();
        if let Some(font_id) = state.canvas_font_ids.get(&source_font_id) {
            return Ok(*font_id);
        }
        let font = Arc::new(CanvasFont {
            native_id,
            descriptor,
            monospace,
        });
        let font_id = state.allocate_font_handle(FontHandle::Canvas(font))?;
        state.canvas_font_ids.insert(source_font_id, font_id);
        Ok(font_id)
    }

    fn register_glyph(&self, font_id: FontId, text: &str, color: bool) -> Result<GlyphId> {
        if let Some(glyph_id) = self.state.read().glyphs.id_for(font_id, text, color) {
            return Ok(glyph_id);
        }
        // Another thread may register the same glyph between the read and write locks.
        self.state
            .write()
            .glyphs
            .get_or_insert(font_id, text, color)
    }

    fn canvas_glyph(&self, font_id: FontId, glyph_id: GlyphId) -> Result<CanvasGlyph> {
        self.state
            .read()
            .glyphs
            .glyph(font_id, glyph_id)
            .cloned()
            .context("invalid Canvas glyph ID")
    }

    fn measure(
        &self,
        font_id: FontId,
        glyph_id: GlyphId,
        font_size: Pixels,
    ) -> Result<CanvasTextMetrics> {
        let key = (font_id, glyph_id, font_size);
        if let Some(metrics) = self.state.read().measurements.get(&key) {
            return Ok(*metrics);
        }
        let font = self
            .canvas_font(font_id)
            .context("invalid Canvas font ID")?;
        let glyph = self.canvas_glyph(font_id, glyph_id)?;
        let metrics = canvas_text::measure(&glyph.text, &font.css_font(font_size, glyph.color)?)?;
        ensure!(metrics.advance >= 0.0, "Canvas returned a negative advance");
        let mut state = self.state.write();
        if state.measurements.len() >= MAX_MEASUREMENTS {
            state.measurements.clear();
        }
        state.measurements.insert(key, metrics);
        Ok(metrics)
    }

    fn report_missing(&self, text: &str, layout: &LineLayout) {
        let Some(sink) = self.state.read().missing_glyph_sink.clone() else {
            return;
        };
        let mut missing_ranges = Vec::new();
        let mut missing_font_by_range = HashMap::new();
        for fragment in &layout.paint_fragments {
            let Some(ranges) = &fragment.glyph_source_ranges else {
                continue;
            };
            if self.canvas_font(fragment.font_id).is_some() {
                continue;
            }
            for (glyph, range) in fragment.glyphs.iter().zip(ranges.iter()) {
                if glyph.id.0 == 0 && text.get(range.clone()).is_some() {
                    missing_ranges.push(range.clone());
                    missing_font_by_range
                        .entry(range.clone())
                        .or_insert(fragment.font_id);
                }
            }
        }
        let grapheme_ranges =
            crate::run_replacements::graphemes_intersecting_ranges(text, &missing_ranges);
        let mut missing = Vec::new();
        for range in grapheme_ranges {
            let Some(grapheme) = text.get(range.clone()) else {
                continue;
            };
            let Some(font_id) = missing_ranges
                .iter()
                .find(|missing| missing.start < range.end && range.start < missing.end)
                .and_then(|missing| missing_font_by_range.get(missing))
                .copied()
            else {
                continue;
            };
            let native_font_id = self.native_font_id(font_id);
            let font_class = match (
                self.native
                    .glyph_for_char(native_font_id, char::from_u32(105).unwrap()),
                self.native
                    .glyph_for_char(native_font_id, char::from_u32(109).unwrap()),
            ) {
                (Some(narrow), Some(wide))
                    if self
                        .native
                        .advance(native_font_id, narrow)
                        .is_ok_and(|narrow| {
                            self.native
                                .advance(native_font_id, wide)
                                .is_ok_and(|wide| narrow.width == wide.width)
                        }) =>
                {
                    FallbackFontClass::Monospace
                }
                _ => FallbackFontClass::Proportional,
            };
            missing.push(MissingGlyph::new(grapheme.into(), font_class));
        }
        if !missing.is_empty() {
            sink.report(missing);
        }
    }

    fn fallback_glyph(
        &self,
        native_id: FontId,
        text: &str,
        color: bool,
        font_size: Pixels,
    ) -> Result<(FontId, GlyphId, CanvasTextMetrics)> {
        if let Some(cached) = self
            .state
            .read()
            .cached_fallback(native_id, text, color, font_size)
        {
            return Ok(cached);
        }
        let font_id = self.canvas_font_id(native_id)?;
        let glyph_id = self.register_glyph(font_id, text, color)?;
        let metrics = self.measure(font_id, glyph_id, font_size)?;
        Ok((font_id, glyph_id, metrics))
    }
}

impl PlatformTextSystem for WebTextSystem {
    fn font_generation(&self) -> u64 {
        self.native.font_generation()
    }

    fn set_missing_glyph_sink(&self, sink: Option<Arc<dyn MissingGlyphSink>>) {
        // Cosmic must not report missing glyphs before Canvas has a chance to replace them.
        self.state.write().missing_glyph_sink = sink;
    }

    fn add_fonts(&self, fonts: Vec<Cow<'static, [u8]>>) -> Result<()> {
        self.native.add_fonts(fonts)?;
        self.state.write().measurements.clear();
        Ok(())
    }

    fn all_font_names(&self) -> Vec<String> {
        self.native.all_font_names()
    }

    fn font_id(&self, font: &Font) -> Result<FontId> {
        let native_id = self.native.font_id(font)?;
        let mut state = self.state.write();
        let font_id = state
            .public_native_font_id(native_id)
            .context("allocating Web font handle")?;
        state
            .descriptors
            .entry(font_id)
            .or_insert_with(|| font.clone());
        Ok(font_id)
    }

    fn prewarm_fonts(&self, font_ids: &[FontId]) {
        let native_ids = font_ids
            .iter()
            .map(|font_id| self.native_font_id(*font_id))
            .collect::<Vec<_>>();
        self.native.prewarm_fonts(&native_ids);
    }

    fn font_metrics(&self, font_id: FontId) -> FontMetrics {
        self.native.font_metrics(self.native_font_id(font_id))
    }

    fn typographic_bounds(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Bounds<f32>> {
        let Some(font) = self.canvas_font(font_id) else {
            return self
                .native
                .typographic_bounds(self.native_font_id(font_id), glyph_id);
        };
        let font_size = px(self.native.font_metrics(font.native_id).units_per_em as f32);
        let metrics = self.measure(font_id, glyph_id, font_size)?;
        Ok(Bounds {
            origin: point(metrics.left, -metrics.ascent),
            size: size(
                metrics.right - metrics.left,
                metrics.ascent + metrics.descent,
            ),
        })
    }

    fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>> {
        let Some(font) = self.canvas_font(font_id) else {
            return self.native.advance(self.native_font_id(font_id), glyph_id);
        };
        let font_size = px(self.native.font_metrics(font.native_id).units_per_em as f32);
        Ok(size(
            self.measure(font_id, glyph_id, font_size)?.advance,
            0.,
        ))
    }

    fn glyph_for_char(&self, font_id: FontId, character: char) -> Option<GlyphId> {
        if self.canvas_font(font_id).is_none() {
            return self
                .native
                .glyph_for_char(self.native_font_id(font_id), character);
        }
        let mut buffer = [0; 4];
        let text = character.encode_utf8(&mut buffer);
        let color =
            classify_canvas_fallback(text).is_some_and(|fallback| fallback.emoji_presentation);
        match self.register_glyph(font_id, text, color) {
            Ok(glyph_id) => Some(glyph_id),
            Err(error) => {
                log::warn!("registering Canvas glyph failed: {error:#}");
                None
            }
        }
    }

    fn rasterize_glyph(&self, params: &RenderGlyphParams) -> Result<RasterizedGlyph> {
        if self.canvas_font(params.font_id).is_none() {
            let mut native_params = params.clone();
            native_params.font_id = self.native_font_id(params.font_id);
            return self.native.rasterize_glyph(&native_params);
        }
        let metrics = self.measure(
            params.font_id,
            params.glyph_id,
            params.font_size * params.scale_factor,
        )?;
        if metrics.right <= metrics.left || metrics.ascent + metrics.descent <= 0. {
            return Ok(RasterizedGlyph::empty(
                params.raster_style.mode.rasterized_format(),
            ));
        }
        let (offset_x, offset_y) = subpixel_offset(params);
        let left = (f64::from(metrics.left) + f64::from(offset_x)).floor() - 1.;
        let top = (-f64::from(metrics.ascent) + f64::from(offset_y)).floor() - 1.;
        let right = (f64::from(metrics.right) + f64::from(offset_x)).ceil() + 1.;
        let bottom = (f64::from(metrics.descent) + f64::from(offset_y)).ceil() + 1.;
        ensure!(
            [left, top, right, bottom]
                .into_iter()
                .all(|value| value >= f64::from(i32::MIN) && value <= f64::from(i32::MAX)),
            "Canvas text bounds exceed device coordinates"
        );
        let width = (right as i32)
            .checked_sub(left as i32)
            .context("Canvas text width overflow")?;
        let height = (bottom as i32)
            .checked_sub(top as i32)
            .context("Canvas text height overflow")?;
        let bounds = Bounds {
            origin: point((left as i32).into(), (top as i32).into()),
            size: size(width.into(), height.into()),
        };
        let font = self
            .canvas_font(params.font_id)
            .context("invalid Canvas font ID")?;
        let glyph = self.canvas_glyph(params.font_id, params.glyph_id)?;
        let css_font = font.css_font(params.font_size * params.scale_factor, glyph.color)?;
        let pixels = canvas_text::rasterize(
            &glyph.text,
            &css_font,
            bounds,
            subpixel_offset(params),
            glyph.color,
        )?;
        let (format, pixels) = if glyph.color {
            (RasterizedGlyphFormat::BgraColor, pixels)
        } else if params.raster_style.mode == GlyphRenderMode::Subpixel {
            (
                RasterizedGlyphFormat::BgraSubpixelMask,
                pixels.into_iter().flat_map(|alpha| [alpha; 4]).collect(),
            )
        } else {
            (RasterizedGlyphFormat::AlphaMask, pixels)
        };
        Ok(RasterizedGlyph {
            bounds,
            size: bounds.size,
            format,
            pixels,
        })
    }

    fn prepare_raster_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
        if self.canvas_font(request.font_id).is_none() {
            let mut native_request = request;
            native_request.font_id = self.native_font_id(native_request.font_id);
            return self.native.prepare_raster_style(native_request);
        }
        let mode = if self
            .canvas_glyph(request.font_id, request.glyph_id)
            .is_ok_and(|glyph| glyph.color)
        {
            GlyphRenderMode::Color
        } else {
            GlyphRenderMode::Grayscale
        };
        PreparedRasterStyle::independent(mode)
    }

    fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout {
        for run in request.runs {
            let _ = self.font_id(&run.font);
        }
        let mut measured = self.native.layout_text(request);
        if self.canvas_font_fallback == CanvasFontFallback::Disabled
            || measured.ascent + measured.descent <= px(0.)
        {
            self.expose_native_layout(&mut measured);
            return measured;
        }
        let text_metrics = InlineTextMetrics {
            ascent: measured.ascent,
            descent: measured.descent,
            x_height: measured.ascent / 2.,
        };
        self.layout_inline(InlineLayoutRequest {
            text: request.text,
            runs: request.runs,
            text_styles: &[],
            boxes: &[],
            font_size: request.font_size,
            line_height: measured.ascent + measured.descent,
            text_metrics,
            options: request.options,
            bidi_scopes: &[],
        })
        .layout
        .as_ref()
        .clone()
    }

    fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout {
        for run in request.runs {
            let _ = self.font_id(&run.font);
        }
        if self.canvas_font_fallback == CanvasFontFallback::Disabled {
            let mut initial = self.native.layout_inline(request);
            self.expose_inline_layout(&mut initial);
            return initial;
        }
        let (mut initial, initial_provenance) = self
            .native
            .layout_inline_with_synthetic_root_provenance(request);
        let initial_synthetic_root = initial_provenance
            .into_iter()
            .filter(|(fragment_index, glyph_index)| {
                initial
                    .layout
                    .paint_fragments
                    .get(*fragment_index)
                    .and_then(|fragment| {
                        fragment
                            .glyph_source_ranges
                            .as_ref()
                            .and_then(|ranges| ranges.get(*glyph_index))
                    })
                    .is_some_and(Range::is_empty)
            })
            .collect::<HashSet<_>>();

        let mut glyph_records = Vec::new();
        let mut glyph_locations = Vec::new();
        let mut run_starts = Vec::with_capacity(request.runs.len());
        let mut run_start = 0usize;
        for run in request.runs {
            run_starts.push(run_start);
            run_start += run.len;
        }
        for (fragment_index, fragment) in initial.layout.paint_fragments.iter().enumerate() {
            let Some(source_ranges) = &fragment.glyph_source_ranges else {
                // Without exact byte ownership, replacing any grapheme could erase neighboring
                // shaping clusters or corrupt source mapping.
                self.expose_inline_layout(&mut initial);
                self.report_missing(request.text, &initial.layout);
                return initial;
            };
            let Some(line_index) = initial
                .layout
                .visual_lines
                .iter()
                .position(|line| line.paint_fragment_range.contains(&fragment_index))
            else {
                continue;
            };
            for (glyph_index, (glyph, source)) in
                fragment.glyphs.iter().zip(source_ranges.iter()).enumerate()
            {
                glyph_records.push(crate::run_replacements::GlyphRecord {
                    source: source.clone(),
                    font_id: fragment.font_id,
                    source_run: fragment.source_run,
                    line_index,
                    missing: glyph.id.0 == 0,
                    native_color: glyph.is_emoji,
                    fragment_index,
                    fragment_source: fragment.source_range.clone(),
                    synthetic_root_control: initial_synthetic_root
                        .contains(&(fragment_index, glyph_index)),
                });
                glyph_locations.push((fragment_index, glyph_index));
            }
        }
        let candidates = crate::run_replacements::collect_candidates(
            request.text,
            &glyph_records,
            self.canvas_font_fallback,
        )
        .into_iter()
        .filter_map(|candidate| {
            let (fragment_index, _) = *candidate
                .glyph_records
                .first()
                .and_then(|index| glyph_locations.get(*index))?;
            let template = initial.layout.paint_fragments.get(fragment_index)?;
            if candidate.glyph_records.iter().any(|index| {
                glyph_locations
                    .get(*index)
                    .and_then(|(fragment_index, _)| {
                        initial.layout.paint_fragments.get(*fragment_index)
                    })
                    .is_none_or(|fragment| fragment.font_size != template.font_size)
            }) {
                return None;
            }
            let source_run = candidate.source_run;
            let run_start = *run_starts.get(source_run)?;
            let run = request.runs.get(source_run)?;
            if candidate.source.start < run_start || candidate.source.end > run_start + run.len {
                return None;
            }
            if request.text_styles.iter().any(|style| {
                style.range.start < candidate.source.end
                    && candidate.source.start < style.range.end
                    && !(style.range.start <= candidate.source.start
                        && candidate.source.end <= style.range.end)
            }) {
                return None;
            }
            let font_id = self.font_id(&run.font).ok()?;
            Some(FallbackCandidate {
                source: candidate.source,
                font_id,
                font_size: template.font_size,
                color: candidate.color,
                template: template.clone(),
            })
        })
        .collect::<Vec<_>>();

        if candidates.is_empty() {
            self.expose_inline_layout(&mut initial);
            self.report_missing(request.text, &initial.layout);
            return initial;
        }

        let mut boxes = request.boxes.to_vec();
        let mut injections = Vec::new();
        let mut next_id = u64::MAX;
        for candidate in &candidates {
            while boxes.iter().any(|inline_box| inline_box.id == next_id) {
                next_id = next_id.saturating_sub(1);
            }
            let Some(text) = request.text.get(candidate.source.clone()) else {
                continue;
            };
            let Ok((font_id, glyph_id, metrics)) = self.fallback_glyph(
                candidate.font_id,
                text,
                candidate.color,
                candidate.font_size,
            ) else {
                continue;
            };
            let height = metrics.ascent + metrics.descent;
            if !metrics.advance.is_finite() || !height.is_finite() || height <= 0. {
                continue;
            }
            boxes.push(InlineBoxRequest {
                id: next_id,
                index: candidate.source.start,
                size: size(px(metrics.advance), px(height)),
                vertical_align: VerticalAlign::Baseline,
            });
            injections.push((candidate.clone(), next_id, font_id, glyph_id, metrics));
            next_id = next_id.saturating_sub(1);
        }
        // Parley partitions inline requests by index. Stable sorting keeps caller boxes in
        // their original order at ties and places each Canvas replacement at its source index.
        boxes.sort_by_key(|inline_box| inline_box.index);
        if injections.is_empty() {
            self.expose_inline_layout(&mut initial);
            self.report_missing(request.text, &initial.layout);
            return initial;
        }

        // Only hide native glyphs for candidates whose Canvas glyph and measured advance are ready.
        let successful = injections
            .iter()
            .map(|(candidate, ..)| candidate)
            .collect::<Vec<_>>();
        let mut text_styles = Vec::new();
        for style in request.text_styles {
            let mut cursor = style.range.start;
            for candidate in successful.iter().filter(|candidate| {
                style.range.start <= candidate.source.start
                    && candidate.source.end <= style.range.end
            }) {
                if cursor < candidate.source.start {
                    text_styles.push(InlineTextStyle {
                        range: cursor..candidate.source.start,
                        ..style.clone()
                    });
                }
                text_styles.push(InlineTextStyle {
                    range: candidate.source.clone(),
                    font_size: px(0.),
                    line_height: style.line_height,
                });
                cursor = candidate.source.end;
            }
            if cursor < style.range.end {
                text_styles.push(InlineTextStyle {
                    range: cursor..style.range.end,
                    ..style.clone()
                });
            }
        }
        for candidate in successful.iter().filter(|candidate| {
            !request.text_styles.iter().any(|style| {
                style.range.start <= candidate.source.start
                    && candidate.source.end <= style.range.end
            })
        }) {
            text_styles.push(InlineTextStyle {
                range: candidate.source.clone(),
                font_size: px(0.),
                line_height: request.line_height,
            });
        }
        text_styles.sort_by_key(|style| (style.range.end, style.range.start));

        let (mut layout, speculative_provenance) = self
            .native
            .layout_inline_with_synthetic_root_provenance(InlineLayoutRequest {
                boxes: &boxes,
                text_styles: &text_styles,
                ..request
            });
        let speculative_synthetic_root = speculative_provenance.into_iter().collect::<HashSet<_>>();

        // Parley must retain every request ID in the layout. If it does not, discard this
        // speculative pass rather than suppressing source glyphs without replacement geometry.
        if injections
            .iter()
            .any(|(_, id, ..)| !layout.boxes.iter().any(|inline_box| inline_box.id == *id))
        {
            self.expose_inline_layout(&mut initial);
            self.report_missing(request.text, &initial.layout);
            return initial;
        }
        let replacement_ranges = injections
            .iter()
            .map(|(candidate, ..)| candidate.source.clone())
            .collect::<Vec<_>>();
        // The placeholder pass may reshape clusters. Validate every new mapping before
        // suppressing native paint: contained remappings are safe, while crossings,
        // malformed UTF-8 ranges, or missing provenance discard the speculative layout.
        if speculative_synthetic_root
            .iter()
            .any(|(fragment_index, glyph_index)| {
                layout
                    .layout
                    .paint_fragments
                    .get(*fragment_index)
                    .and_then(|fragment| {
                        fragment
                            .glyph_source_ranges
                            .as_ref()
                            .and_then(|ranges| ranges.get(*glyph_index))
                    })
                    .is_none_or(|range| !range.is_empty())
            })
        {
            self.expose_inline_layout(&mut initial);
            self.report_missing(request.text, &initial.layout);
            return initial;
        }
        for (fragment_index, fragment) in layout.layout.paint_fragments.iter().enumerate() {
            let Some(source_ranges) = &fragment.glyph_source_ranges else {
                self.expose_inline_layout(&mut initial);
                self.report_missing(request.text, &initial.layout);
                return initial;
            };
            if source_ranges.len() != fragment.glyphs.len()
                || source_ranges
                    .iter()
                    .enumerate()
                    .any(|(glyph_index, range)| {
                        request.text.get(range.clone()).is_none()
                            || (range.is_empty()
                                && !speculative_synthetic_root
                                    .contains(&(fragment_index, glyph_index)))
                            || (!range.is_empty()
                                && crate::run_replacements::replacement_glyph_is_suppressed(
                                    range,
                                    &replacement_ranges,
                                )
                                .is_err())
                    })
            {
                self.expose_inline_layout(&mut initial);
                self.report_missing(request.text, &initial.layout);
                return initial;
            }
        }
        let mut line_fragments = vec![Vec::new(); layout.layout.visual_lines.len()];
        for (line_index, line) in layout.layout.visual_lines.iter().enumerate() {
            for (fragment_offset, fragment) in layout.layout.paint_fragments
                [line.paint_fragment_range.clone()]
            .iter()
            .enumerate()
            {
                let fragment_index = line.paint_fragment_range.start + fragment_offset;
                let mut fragment = fragment.clone();
                fragment.font_id = self.public_font_id(fragment.font_id);
                if let Some(source_ranges) = &fragment.glyph_source_ranges {
                    let keep = fragment
                        .glyphs
                        .iter()
                        .zip(source_ranges.iter())
                        .enumerate()
                        .filter_map(|(index, (glyph, range))| {
                            let suppress =
                                if speculative_synthetic_root.contains(&(fragment_index, index)) {
                                    false
                                } else {
                                    crate::run_replacements::replacement_glyph_is_suppressed(
                                        range,
                                        &replacement_ranges,
                                    )
                                    .expect("replacement glyph mappings were validated above")
                                };
                            (!suppress).then_some((glyph.clone(), range.clone(), index))
                        })
                        .collect::<Vec<_>>();
                    fragment.glyphs = keep
                        .iter()
                        .map(|(glyph, _, _)| glyph.clone())
                        .collect::<Vec<_>>()
                        .into();
                    fragment.glyph_source_ranges = Some(
                        keep.iter()
                            .map(|(_, range, _)| range.clone())
                            .collect::<Vec<_>>()
                            .into(),
                    );
                }
                if !fragment.glyphs.is_empty() {
                    line_fragments[line_index].push(fragment);
                }
            }
        }
        let positioned_boxes = layout.boxes.clone();
        let mut overlays = Vec::new();
        for (candidate, id, font_id, glyph_id, metrics) in &injections {
            let Some(inline_box) = positioned_boxes
                .iter()
                .find(|inline_box| inline_box.id == *id)
            else {
                continue;
            };
            let line = layout.lines[inline_box.line_index];
            let line_local_x = inline_box.bounds.origin.x - line.origin.x;
            let line_local_y = inline_box.bounds.origin.y - line.origin.y;
            let glyph = ShapedGlyph {
                id: *glyph_id,
                position: point(
                    line_local_x - px(metrics.left),
                    line_local_y + px(metrics.ascent) - line.baseline,
                ),
                is_emoji: candidate.color,
            };
            let mut fragment = candidate.template.clone();
            fragment.source_range = candidate.source.clone();
            fragment.font_id = *font_id;
            fragment.font_size = candidate.font_size;
            fragment.glyphs = vec![glyph].into();
            fragment.glyph_source_ranges = Some(vec![candidate.source.clone()].into());
            fragment.x_range = line_local_x..line_local_x + px(metrics.advance);
            line_fragments[inline_box.line_index].push(fragment);

            let start = initial.layout.platform_layout.caret_bounds(
                CaretPosition {
                    index: candidate.source.start,
                    affinity: CaretAffinity::Downstream,
                },
                request.line_height,
            );
            let end = initial.layout.platform_layout.caret_bounds(
                CaretPosition {
                    index: candidate.source.end,
                    affinity: CaretAffinity::Upstream,
                },
                request.line_height,
            );
            let rtl =
                matches!((start, end), (Some(start), Some(end)) if start.origin.x > end.origin.x);
            overlays.push(CanvasOverlay {
                source: candidate.source.clone(),
                bounds: inline_box.bounds,
                line_index: inline_box.line_index,
                rtl,
            });
        }

        let private_ids = injections
            .iter()
            .map(|(_, id, ..)| *id)
            .collect::<HashSet<_>>();
        layout
            .boxes
            .retain(|inline_box| !private_ids.contains(&inline_box.id));
        let mut shaped_layout = (*layout.layout).clone();
        shaped_layout.paint_fragments.clear();
        for (line_index, fragments) in line_fragments.iter_mut().enumerate() {
            fragments.sort_by_key(|fragment| fragment.x_range.start);
            let start = shaped_layout.paint_fragments.len();
            shaped_layout.paint_fragments.append(fragments);
            shaped_layout.visual_lines[line_index].paint_fragment_range =
                start..shaped_layout.paint_fragments.len();
        }
        shaped_layout.platform_layout = Arc::new(CanvasPlatformTextLayout::new(
            shaped_layout.platform_layout.clone(),
            overlays,
        ));
        layout.layout = Arc::new(shaped_layout);
        self.report_missing(request.text, &layout.layout);
        layout
    }

    fn recommended_rendering_mode(&self, font_id: FontId, font_size: Pixels) -> TextRenderingMode {
        if self.canvas_font(font_id).is_some() {
            TextRenderingMode::Grayscale
        } else {
            self.native
                .recommended_rendering_mode(self.native_font_id(font_id), font_size)
        }
    }
}

impl CanvasFont {
    fn css_font(&self, font_size: Pixels, color: bool) -> Result<String> {
        let font_size = f32::from(font_size);
        ensure!(
            font_size.is_finite() && font_size > 0.,
            "invalid Canvas font size"
        );
        let style = match self.descriptor.style {
            FontStyle::Normal => "normal",
            FontStyle::Italic => "italic",
            FontStyle::Oblique => "oblique",
        };
        let mut families = Vec::new();
        if !color && !self.descriptor.family.starts_with('.') {
            families.push(quote_family(&self.descriptor.family));
        }
        if let Some(fallbacks) = &self.descriptor.fallbacks {
            families.extend(
                fallbacks
                    .fallback_list()
                    .iter()
                    .map(|family| quote_family(family)),
            );
        }
        families.push(
            if color {
                "emoji"
            } else if self.monospace {
                "monospace"
            } else {
                "sans-serif"
            }
            .to_owned(),
        );
        Ok(format!(
            "{style} {} {font_size}px {}",
            self.descriptor.weight.0,
            families.join(", ")
        ))
    }
}

fn quote_family(family: &str) -> String {
    let mut quoted = String::from("\"");
    for character in family.chars() {
        match character {
            '\\' | '"' => {
                quoted.push('\\');
                quoted.push(character);
            }
            character if character.is_control() => quoted.push(' '),
            character => quoted.push(character),
        }
    }
    quoted.push('"');
    quoted
}

fn subpixel_offset(params: &RenderGlyphParams) -> (f32, f32) {
    (
        f32::from(params.subpixel_variant.x) / SUBPIXEL_VARIANTS_X as f32,
        f32::from(params.subpixel_variant.y) / SUBPIXEL_VARIANTS_Y as f32,
    )
}

#[cfg(test)]
mod font_handle_tests {
    use super::*;

    #[test]
    fn opaque_font_handles_round_trip_high_bit_native_ids() {
        let native_id = FontId(1usize << (usize::BITS - 1));
        let mut state = State::default();

        let public_id = state.public_native_font_id(native_id).unwrap();
        assert_eq!(state.public_native_font_id(native_id).unwrap(), public_id);
        assert_eq!(state.native_font_ids.get(&native_id), Some(&public_id));
        assert!(
            matches!(state.font_handles.get(&public_id), Some(FontHandle::Native(id)) if *id == native_id)
        );

        let canvas_id = state
            .allocate_font_handle(FontHandle::Canvas(Arc::new(CanvasFont {
                native_id,
                descriptor: Font::default(),
                monospace: false,
            })))
            .unwrap();
        assert_ne!(canvas_id, public_id);
        assert!(
            matches!(state.font_handles.get(&canvas_id), Some(FontHandle::Canvas(font)) if font.native_id == native_id)
        );
    }
}
