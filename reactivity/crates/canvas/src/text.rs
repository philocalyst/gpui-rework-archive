use crate::{Error, Rect};
use skrifa::{
    MetadataProvider as _,
    instance::{LocationRef, Size},
    outline::{DrawSettings, Hinting, OutlinePen},
};
use std::{
    borrow::Cow,
    collections::HashMap,
    sync::{
        Arc, Mutex, Weak,
        atomic::{AtomicU64, Ordering},
    },
};
use swash::{
    CacheKey, FontRef,
    scale::{Render, ScaleContext, Source},
    zeno::Format,
};
use unicode_script::{Script, UnicodeScript};

const MAX_TEXT: usize = 32 * 1024;
const MAX_GLYPHS: usize = 32 * 1024;
const CACHE_BYTES: usize = 8 * 1024 * 1024;
static NEXT_FONT: AtomicU64 = AtomicU64::new(1);
static BUNDLED_FONT: Mutex<Weak<FontData>> = Mutex::new(Weak::new());

struct FontData {
    bytes: Cow<'static, [u8]>,
    raster_key: CacheKey,
    id: u64,
}

/// Shared immutable font bytes. Clone this handle to share backing and font
/// identity; independently supplied equal bytes deliberately create a new face.
/// The bundled registry holds only a Weak, so the last owner releases the font.
#[derive(Clone)]
pub struct FontFace(Arc<FontData>);
impl FontFace {
    /// Noto Sans 2.015, upstream provenance and OFL in assets/README.md.
    /// Cold initialization is serialized; shaping and rasterization never lock.
    pub fn bundled() -> Result<Self, Error> {
        // The slot always contains a valid Weak. Parsing publishes nothing until
        // complete; recovering poison after a parser panic cannot expose partial
        // FontData or corrupt the previous immutable face.
        let mut slot = match BUNDLED_FONT.lock() {
            Ok(slot) => slot,
            Err(poison) => {
                BUNDLED_FONT.clear_poison();
                poison.into_inner()
            }
        };
        if let Some(data) = slot.upgrade() {
            return Ok(Self(data));
        }
        let face = Self::from_data(Cow::Borrowed(include_bytes!("../assets/NotoSans.ttf")))?;
        *slot = Arc::downgrade(&face.0);
        Ok(face)
    }
    /// Copies caller bytes once into this face's immutable backing.
    pub fn new(bytes: impl AsRef<[u8]>) -> Result<Self, Error> {
        let bytes = bytes.as_ref();
        if bytes.is_empty() || bytes.len() > 16 * 1024 * 1024 {
            return Err(Error::ResourceLimit);
        }
        Self::from_data(Cow::Owned(bytes.to_vec()))
    }
    fn from_data(bytes: Cow<'static, [u8]>) -> Result<Self, Error> {
        let parsed =
            rustybuzz::ttf_parser::Face::parse(&bytes, 0).map_err(|_| Error::InvalidFont)?;
        // This service deliberately supports outline alpha masks, not bitmap,
        // SVG or layered-color fallback. Reject rather than return empty tofu.
        for tag in [*b"COLR", *b"CBDT", *b"EBDT", *b"sbix", *b"SVG "] {
            if parsed
                .raw_face()
                .table(rustybuzz::ttf_parser::Tag::from_bytes(&tag))
                .is_some()
            {
                return Err(Error::UnsupportedFontFormat);
            }
        }
        let font =
            skrifa::FontRef::from_index(bytes.as_ref(), 0).map_err(|_| Error::InvalidFont)?;
        if font.outline_glyphs().format().is_none() {
            return Err(Error::UnsupportedFontFormat);
        }
        let raster_key = CacheKey::new();
        let id = NEXT_FONT
            .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |v| v.checked_add(1))
            .map_err(|_| Error::ResourceLimit)?;
        Ok(Self(Arc::new(FontData {
            bytes,
            raster_key,
            id,
        })))
    }
    /// Process-local identity, not byte equality or a persistent font ID.
    pub fn same_face(&self, other: &Self) -> bool {
        Arc::ptr_eq(&self.0, &other.0)
    }
}
impl std::fmt::Debug for FontFace {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("FontFace")
            .field("id", &self.0.id)
            .finish_non_exhaustive()
    }
}

/// A shaped glyph; positions are relative to the top-left layout origin, y down.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Glyph {
    pub id: u16,
    pub cluster: u32,
    pub x: f32,
    pub baseline: f32,
}

/// Process-local immutable raster identity. Equal keys identify the same font
/// face, glyph and scale, including across cache eviction or separate services.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct GlyphKey {
    face: u64,
    glyph: u16,
    size: u32,
}

#[cfg(test)]
impl GlyphKey {
    pub(crate) fn fixture() -> Self {
        Self {
            face: 0,
            glyph: 0,
            size: 0,
        }
    }
}

/// Owned positions from one FontFace, accepted by any service sharing that face.
/// A layout does not keep font backing alive. Advance bounds and ink differ.
#[derive(Clone, Debug)]
pub struct TextLayout {
    pub width: f32,
    pub height: f32,
    pub baseline: f32,
    font_size: f32,
    glyphs: Vec<Glyph>,
    font_id: u64,
}
impl TextLayout {
    pub fn font_size(&self) -> f32 {
        self.font_size
    }
    pub fn glyphs(&self) -> &[Glyph] {
        &self.glyphs
    }
}

#[derive(Clone, Copy, Default)]
pub(crate) struct RasterMetrics {
    pub xmin: i32,
    pub ymin: i32,
    pub width: usize,
    pub height: usize,
}
pub(crate) struct Raster {
    pub key: GlyphKey,
    pub metrics: RasterMetrics,
    pub pixels: Vec<u8>,
}

/// One explicitly supplied font, horizontal single-script LTR paragraphs,
/// Latin/Greek/Cyrillic plus common/inherited characters, bounded grayscale cache.
/// No system font discovery, fallback, bidi paragraph resolution or editing model.
pub struct TextSystem {
    face: FontFace,
    cache: HashMap<(u16, u32), Arc<Raster>>,
    cache_bytes: usize,
    // No scaler or outline storage until the first requested glyph. A boxed
    // owner keeps every unused service's header small; no shared raster lock.
    scaler: Option<Box<ScaleContext>>,
}
impl TextSystem {
    /// Noto Sans 2.015, upstream commit and OFL attribution in assets/README.md.
    pub fn bundled() -> Result<Self, Error> {
        Ok(Self::from_font(FontFace::bundled()?))
    }
    pub fn new(bytes: impl AsRef<[u8]>) -> Result<Self, Error> {
        Ok(Self::from_font(FontFace::new(bytes)?))
    }
    /// Creates a private mutable raster cache over shared immutable font data.
    pub fn from_font(face: FontFace) -> Self {
        Self {
            face,
            cache: HashMap::new(),
            cache_bytes: 0,
            scaler: None,
        }
    }
    pub fn font_face(&self) -> &FontFace {
        &self.face
    }
    pub fn cache_bytes(&self) -> usize {
        self.cache_bytes
    }
    pub fn clear_cache(&mut self) {
        self.cache.clear();
        self.cache_bytes = 0;
        self.scaler = None;
    }
    pub fn shape(
        &self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextLayout, Error> {
        if !font_size.is_finite() || !(0.0..=512.0).contains(&font_size) || font_size == 0.0 {
            return Err(Error::InvalidFontSize);
        }
        if max_width.is_some_and(|w| !w.is_finite() || w <= 0.0) {
            return Err(Error::InvalidWidth);
        }
        if text.len() > MAX_TEXT {
            return Err(Error::ResourceLimit);
        }
        let face = rustybuzz::ttf_parser::Face::parse(&self.face.0.bytes, 0)
            .map_err(|_| Error::InvalidFont)?;
        let mut paragraph_script = None;
        for c in text.chars() {
            if c == '\n' {
                paragraph_script = None;
                continue;
            }
            if c.is_control()
                || matches!(c,'\u{200e}'|'\u{200f}'|'\u{2028}'|'\u{2029}'|'\u{202a}'..='\u{202e}'|'\u{2066}'..='\u{2069}')
            {
                return Err(Error::UnsupportedControl(c));
            }
            if face.glyph_index(c).is_none_or(|id| id.0 == 0) {
                return Err(Error::MissingGlyph(c));
            }
            let script = c.script();
            if matches!(script, Script::Common | Script::Inherited) {
                continue;
            }
            if !matches!(script, Script::Latin | Script::Greek | Script::Cyrillic)
                || paragraph_script.is_some_and(|previous| previous != script)
            {
                return Err(Error::UnsupportedScript(c));
            }
            paragraph_script = Some(script);
        }
        // Same font-unit line metrics/rounding as the previous backend. Shaping
        // and layout do not depend on which requested glyphs have been painted.
        let scale = font_size / face.units_per_em() as f32;
        let ascent = face.ascender() as f32 * scale;
        let line_height = ((i32::from(face.ascender()) - i32::from(face.descender())
            + i32::from(face.line_gap())) as f32
            * scale)
            .max(font_size);
        let mut result = TextLayout {
            width: 0.0,
            height: line_height,
            baseline: ascent,
            font_size,
            glyphs: Vec::new(),
            font_id: self.face.0.id,
        };
        let mut line = 0usize;
        let mut paragraph_offset = 0;
        let mut shaping_budget = 1024 * 1024;
        for paragraph in text.split('\n') {
            if paragraph.is_empty() {
                line += 1;
                paragraph_offset += 1;
                continue;
            }
            let (positions, width) = self.shape_line(paragraph, font_size, &mut shaping_budget)?;
            if max_width.is_none_or(|w| width <= w) {
                Self::append(&mut result, positions, paragraph_offset, line, line_height)?;
                line += 1;
            } else {
                // Greedy cluster-boundary wrapping. Prefer whitespace boundaries,
                // then reshape each chosen line so its edge shaping is authoritative.
                let limit = max_width.unwrap();
                let mut start = 0;
                while start < paragraph.len() {
                    let (all, _) =
                        self.shape_line(&paragraph[start..], font_size, &mut shaping_budget)?;
                    let mut end = paragraph.len();
                    let mut preferred = None;
                    let mut last_cluster = start;
                    for (i, g) in all.iter().enumerate() {
                        let cluster = start + g.cluster as usize;
                        if cluster == last_cluster && i != 0 {
                            continue;
                        }
                        if cluster > start
                            && paragraph[..cluster]
                                .chars()
                                .next_back()
                                .is_some_and(char::is_whitespace)
                        {
                            preferred = Some(cluster);
                        }
                        if g.x > limit && cluster > start {
                            end = preferred.filter(|v| *v > start).unwrap_or(cluster);
                            break;
                        }
                        last_cluster = cluster;
                    }
                    // The last cluster's advance may cross the limit, so select
                    // an earlier complete cluster if no overflow origin existed.
                    let mut shaped =
                        self.shape_line(&paragraph[start..end], font_size, &mut shaping_budget)?;
                    while shaped.1 > limit {
                        let previous = shaped
                            .0
                            .iter()
                            .map(|g| g.cluster as usize)
                            .filter(|c| *c > 0)
                            .max();
                        let Some(previous) = previous else {
                            break;
                        }; // indivisible cluster may overflow
                        end = start + previous;
                        shaped = self.shape_line(
                            &paragraph[start..end],
                            font_size,
                            &mut shaping_budget,
                        )?;
                    }
                    Self::append(
                        &mut result,
                        shaped.0,
                        paragraph_offset + start,
                        line,
                        line_height,
                    )?;
                    result.width = result.width.max(shaped.1);
                    line += 1;
                    start = end;
                }
            }
            result.width = result.width.max(if max_width.is_none_or(|w| width <= w) {
                width
            } else {
                0.0
            });
            paragraph_offset += paragraph.len() + 1;
        }
        result.height = line.max(1) as f32 * line_height;
        Ok(result)
    }
    fn append(
        layout: &mut TextLayout,
        mut glyphs: Vec<Glyph>,
        offset: usize,
        line: usize,
        line_height: f32,
    ) -> Result<(), Error> {
        if layout.glyphs.len() + glyphs.len() > MAX_GLYPHS {
            return Err(Error::ResourceLimit);
        }
        for g in &mut glyphs {
            g.cluster += offset as u32;
            g.baseline += layout.baseline + line as f32 * line_height;
        }
        layout.glyphs.extend(glyphs);
        Ok(())
    }
    fn shape_line(
        &self,
        text: &str,
        size: f32,
        budget: &mut usize,
    ) -> Result<(Vec<Glyph>, f32), Error> {
        *budget = budget.checked_sub(text.len()).ok_or(Error::ResourceLimit)?;
        let face = rustybuzz::Face::from_slice(&self.face.0.bytes, 0).ok_or(Error::InvalidFont)?;
        let mut buffer = rustybuzz::UnicodeBuffer::new();
        buffer.push_str(text);
        buffer.guess_segment_properties();
        if buffer.direction() != rustybuzz::Direction::LeftToRight {
            return Err(Error::UnsupportedDirection);
        }
        let shaped = rustybuzz::shape(&face, &[], buffer);
        let scale = size / face.units_per_em() as f32;
        let mut x = 0.0;
        let mut glyphs = Vec::with_capacity(shaped.len());
        for (info, pos) in shaped.glyph_infos().iter().zip(shaped.glyph_positions()) {
            if info.glyph_id == 0 {
                return Err(Error::InvalidFont);
            }
            glyphs.push(Glyph {
                id: info.glyph_id as u16,
                cluster: info.cluster,
                x: x + pos.x_offset as f32 * scale,
                baseline: -(pos.y_offset as f32) * scale,
            });
            x += pos.x_advance as f32 * scale;
        }
        Ok((glyphs, x))
    }
    pub(crate) fn validate(&self, layout: &TextLayout) -> Result<(), Error> {
        if layout.font_id != self.face.0.id {
            Err(Error::ForeignLayout)
        } else {
            Ok(())
        }
    }
    pub(crate) fn raster(&mut self, id: u16, size: f32) -> Result<Arc<Raster>, Error> {
        if !size.is_finite() || size <= 0.0 || size > 4096.0 {
            return Err(Error::InvalidFontSize);
        }
        let key = (id, size.to_bits());
        if !self.cache.contains_key(&key) {
            let bounds = outline_bounds(&self.face.0.bytes, id, size)?;
            let estimated = if let Some(r) = bounds {
                ((r[2] - r[0] + 2.0) as usize)
                    .checked_mul((r[3] - r[1] + 2.0) as usize)
                    .ok_or(Error::ResourceLimit)?
            } else {
                0
            };
            if estimated > 1024 * 1024 {
                return Err(Error::ResourceLimit);
            }
            if self.cache_bytes + estimated > CACHE_BYTES || self.cache.len() >= 4096 {
                self.clear_cache();
            }
            let (metrics, pixels) = if bounds.is_some() {
                // This is the narrow outline-alpha path of the existing GPUI
                // SwashGlyphRasterizer: stable face key, unhinted default instance,
                // native placement and owned grayscale coverage, no color fallback.
                let mut font =
                    FontRef::from_index(&self.face.0.bytes, 0).ok_or(Error::InvalidFont)?;
                font.key = self.face.0.raster_key;
                let context = self
                    .scaler
                    .get_or_insert_with(|| Box::new(ScaleContext::with_max_entries(1)));
                let mut scaler = context.builder(font).size(size).hint(false).build();
                let image = Render::new(&[Source::Outline])
                    .format(Format::Alpha)
                    .render(&mut scaler, id)
                    .ok_or(Error::InvalidFont)?;
                if image.content != swash::scale::image::Content::Mask {
                    return Err(Error::UnsupportedFontFormat);
                }
                let p = image.placement;
                let bytes = (p.width as usize)
                    .checked_mul(p.height as usize)
                    .ok_or(Error::ResourceLimit)?;
                if bytes > 1024 * 1024 || bytes != image.data.len() {
                    return Err(Error::ResourceLimit);
                }
                let ymin = p
                    .top
                    .checked_sub(p.height as i32)
                    .ok_or(Error::InvalidGeometry)?;
                (
                    RasterMetrics {
                        xmin: p.left,
                        ymin,
                        width: p.width as usize,
                        height: p.height as usize,
                    },
                    image.data,
                )
            } else {
                (RasterMetrics::default(), Vec::new())
            };
            // Enforce the actual retained-byte cap independently of the
            // conservative preflight estimate and the backend's placement.
            if self.cache_bytes + pixels.len() > CACHE_BYTES {
                self.clear_cache();
            }
            self.cache_bytes += pixels.len();
            self.cache.insert(
                key,
                Arc::new(Raster {
                    key: GlyphKey {
                        face: self.face.0.id,
                        glyph: id,
                        size: size.to_bits(),
                    },
                    metrics,
                    pixels,
                }),
            );
        }
        Ok(Arc::clone(&self.cache[&key]))
    }
    /// Conservative local raster bounds, useful for damage and paint geometry.
    pub fn ink_bounds(&self, layout: &TextLayout) -> Result<Rect, Error> {
        self.validate(layout)?;
        let mut min = [f32::INFINITY; 2];
        let mut max = [f32::NEG_INFINITY; 2];
        for g in &layout.glyphs {
            let Some([left, bottom, right, top]) =
                outline_bounds(&self.face.0.bytes, g.id, layout.font_size)?
            else {
                continue;
            };
            min[0] = min[0].min(g.x + left - 1.0);
            min[1] = min[1].min(g.baseline - top - 1.0);
            max[0] = max[0].max(g.x + right + 1.0);
            max[1] = max[1].max(g.baseline - bottom + 1.0);
        }
        Ok(if min[0].is_finite() {
            Rect::new(min[0], min[1], max[0] - min[0], max[1] - min[1])
        } else {
            Rect::default()
        })
    }
}

// A no-allocation control-hull pen preflights the same default outline used
// by Swash. Bezier curves lie in their control hull. Guard one device pixel
// after floor/ceil for raster rounding; reject excessive outlines before render.
fn outline_bounds(bytes: &[u8], glyph: u16, size: f32) -> Result<Option<[f32; 4]>, Error> {
    let font = skrifa::FontRef::from_index(bytes, 0).map_err(|_| Error::InvalidFont)?;
    let outlines = font.outline_glyphs();
    let outline = outlines
        .get(skrifa::GlyphId::new(u32::from(glyph)))
        .ok_or(Error::InvalidFont)?;
    if outline.draw_memory_size(Hinting::None) > 1024 * 1024 {
        return Err(Error::ResourceLimit);
    }
    let mut pen = BoundsPen::default();
    outline
        .draw(
            DrawSettings::unhinted(Size::new(size), LocationRef::default()),
            &mut pen,
        )
        .map_err(|_| Error::InvalidFont)?;
    if pen.invalid {
        return Err(Error::InvalidGeometry);
    }
    if pen.segments > 65_536 {
        return Err(Error::ResourceLimit);
    }
    Ok(
        (pen.segments != 0 && pen.max[0] > pen.min[0] && pen.max[1] > pen.min[1]).then(|| {
            [
                pen.min[0].floor(),
                pen.min[1].floor(),
                pen.max[0].ceil(),
                pen.max[1].ceil(),
            ]
        }),
    )
}
struct BoundsPen {
    min: [f32; 2],
    max: [f32; 2],
    segments: usize,
    invalid: bool,
}
impl Default for BoundsPen {
    fn default() -> Self {
        Self {
            min: [f32::INFINITY; 2],
            max: [f32::NEG_INFINITY; 2],
            segments: 0,
            invalid: false,
        }
    }
}
impl BoundsPen {
    fn point(&mut self, x: f32, y: f32) {
        if !x.is_finite() || !y.is_finite() || x.abs() > 1_048_576.0 || y.abs() > 1_048_576.0 {
            self.invalid = true;
        }
        self.min[0] = self.min[0].min(x);
        self.min[1] = self.min[1].min(y);
        self.max[0] = self.max[0].max(x);
        self.max[1] = self.max[1].max(y);
    }
}
impl OutlinePen for BoundsPen {
    fn move_to(&mut self, x: f32, y: f32) {
        self.point(x, y);
    }
    fn line_to(&mut self, x: f32, y: f32) {
        self.segments += 1;
        self.point(x, y);
    }
    fn quad_to(&mut self, cx: f32, cy: f32, x: f32, y: f32) {
        self.segments += 1;
        self.point(cx, cy);
        self.point(x, y);
    }
    fn curve_to(&mut self, cx0: f32, cy0: f32, cx1: f32, cy1: f32, x: f32, y: f32) {
        self.segments += 1;
        self.point(cx0, cy0);
        self.point(cx1, cy1);
        self.point(x, y);
    }
    fn close(&mut self) {}
}

#[cfg(test)]
mod font_tests {
    use super::*;
    use std::sync::Barrier;

    // This is the only unit test using the process-global bundled registry.
    // Integration tests run in separate binaries with independent statics.
    #[test]
    fn bundled_concurrency_release_remint_and_poison_recovery() {
        fn send_sync<T: Send + Sync>() {}
        send_sync::<CacheKey>();
        send_sync::<FontFace>();
        send_sync::<TextSystem>();
        let before = NEXT_FONT.load(Ordering::Relaxed);
        let barrier = Arc::new(Barrier::new(9));
        let jobs: Vec<_> = (0..8)
            .map(|_| {
                let barrier = Arc::clone(&barrier);
                std::thread::spawn(move || {
                    barrier.wait();
                    FontFace::bundled().unwrap()
                })
            })
            .collect();
        barrier.wait();
        let faces: Vec<_> = jobs.into_iter().map(|job| job.join().unwrap()).collect();
        assert!(faces.iter().all(|face| face.same_face(&faces[0])));
        // Every successful parse mints exactly one ID, so this checks that the
        // concurrent cold calls did not speculatively parse and discard copies.
        assert_eq!(NEXT_FONT.load(Ordering::Relaxed), before + 1);
        assert!(matches!(faces[0].0.bytes, Cow::Borrowed(_)));
        let weak = Arc::downgrade(&faces[0].0);
        let old_id = faces[0].0.id;
        let service = TextSystem::from_font(faces[0].clone());
        let layout = service.shape("office", 18.0, None).unwrap();
        assert!(service.scaler.is_none());
        service.ink_bounds(&layout).unwrap();
        assert!(service.scaler.is_none());
        drop(service);
        drop(faces);
        assert!(weak.upgrade().is_none());
        assert!(BUNDLED_FONT.lock().unwrap().upgrade().is_none());
        // Positions alone do not pin the immutable font backing.
        assert_eq!(layout.font_id, old_id);
        let renewed = FontFace::bundled().unwrap();
        assert!(renewed.0.id > old_id);
        assert_eq!(
            TextSystem::from_font(renewed.clone()).validate(&layout),
            Err(Error::ForeignLayout)
        );
        let renewed_weak = Arc::downgrade(&renewed.0);
        drop(renewed);
        assert!(renewed_weak.upgrade().is_none());

        // Simulate a parser panic before publication. The Weak remains valid;
        // the next cold call recovers and constructs complete immutable data.
        assert!(
            std::thread::spawn(|| {
                let _slot = BUNDLED_FONT.lock().unwrap();
                panic!("simulated unpublished-font initialization panic");
            })
            .join()
            .is_err()
        );
        assert!(BUNDLED_FONT.is_poisoned());
        let recovered = FontFace::bundled().unwrap();
        assert!(!BUNDLED_FONT.is_poisoned());
        let recovered_weak = Arc::downgrade(&recovered.0);
        drop(recovered);
        assert!(recovered_weak.upgrade().is_none());
        eprintln!(
            "font_face_bytes={},text_system_bytes={},font_data_header_bytes={},registry_static_bytes={},scaler_header_bytes={}",
            std::mem::size_of::<FontFace>(),
            std::mem::size_of::<TextSystem>(),
            std::mem::size_of::<FontData>(),
            std::mem::size_of::<Mutex<Weak<FontData>>>(),
            std::mem::size_of::<ScaleContext>()
        );
    }
}
