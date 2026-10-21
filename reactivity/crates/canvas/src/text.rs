use crate::{Error, Rect};
use fontdue::{Font, FontSettings, Metrics};
use std::{
    borrow::Cow,
    collections::HashMap,
    sync::{
        Arc, Mutex, Weak,
        atomic::{AtomicU64, Ordering},
    },
};
use unicode_script::{Script, UnicodeScript};

const MAX_TEXT: usize = 32 * 1024;
const MAX_GLYPHS: usize = 32 * 1024;
const CACHE_BYTES: usize = 8 * 1024 * 1024;
static NEXT_FONT: AtomicU64 = AtomicU64::new(1);
static BUNDLED_FONT: Mutex<Weak<FontData>> = Mutex::new(Weak::new());

struct FontData {
    bytes: Cow<'static, [u8]>,
    font: Font,
    id: u64,
}

/// Shared immutable parsed font. Clone this handle to share geometry and font
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
        rustybuzz::Face::from_slice(&bytes, 0).ok_or(Error::InvalidFont)?;
        let font = Font::from_bytes(bytes.as_ref(), FontSettings::default())
            .map_err(|_| Error::InvalidFont)?;
        let id = NEXT_FONT
            .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |v| v.checked_add(1))
            .map_err(|_| Error::ResourceLimit)?;
        Ok(Self(Arc::new(FontData { bytes, font, id })))
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

/// Owned positions from one FontFace, accepted by any service sharing that face.
/// A layout does not keep parsed font data alive. Advance bounds and ink differ.
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

pub(crate) struct Raster {
    pub key: GlyphKey,
    pub metrics: Metrics,
    pub pixels: Vec<u8>,
}

/// One explicitly supplied font, horizontal single-script LTR paragraphs,
/// Latin/Greek/Cyrillic plus common/inherited characters, bounded grayscale cache.
/// No system font discovery, fallback, bidi paragraph resolution or editing model.
pub struct TextSystem {
    face: FontFace,
    cache: HashMap<(u16, u32), Arc<Raster>>,
    cache_bytes: usize,
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
            if !self.face.0.font.has_glyph(c) {
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
        let metrics = self
            .face
            .0
            .font
            .horizontal_line_metrics(font_size)
            .ok_or(Error::InvalidFont)?;
        let line_height = metrics.new_line_size.max(font_size);
        let mut result = TextLayout {
            width: 0.0,
            height: line_height,
            baseline: metrics.ascent,
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
        let key = (id, size.to_bits());
        if !self.cache.contains_key(&key) {
            let metrics = self.face.0.font.metrics_indexed(id, size);
            let bytes = metrics
                .width
                .checked_mul(metrics.height)
                .ok_or(Error::ResourceLimit)?;
            if bytes > 1024 * 1024 {
                return Err(Error::ResourceLimit);
            }
            // Bound metadata as well as bitmap payload, including empty glyphs.
            if self.cache_bytes + bytes > CACHE_BYTES || self.cache.len() >= 4096 {
                self.clear_cache();
            }
            let (metrics, pixels) = self.face.0.font.rasterize_indexed(id, size);
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
            let m = self.face.0.font.metrics_indexed(g.id, layout.font_size);
            if m.width == 0 || m.height == 0 {
                continue;
            }
            let x = g.x + m.xmin as f32;
            let y = g.baseline - m.ymin as f32 - m.height as f32;
            min[0] = min[0].min(x - 0.5);
            min[1] = min[1].min(y - 0.5);
            max[0] = max[0].max(x + m.width as f32 + 0.5);
            max[1] = max[1].max(y + m.height as f32 + 0.5);
        }
        Ok(if min[0].is_finite() {
            Rect::new(min[0], min[1], max[0] - min[0], max[1] - min[1])
        } else {
            Rect::default()
        })
    }
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
        send_sync::<Font>();
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
        drop(service);
        drop(faces);
        assert!(weak.upgrade().is_none());
        assert!(BUNDLED_FONT.lock().unwrap().upgrade().is_none());
        // Positions alone do not pin the large parsed outline store.
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
            "font_face_bytes={},text_system_bytes={},font_data_header_bytes={},registry_static_bytes={},fontdue_header_bytes={}",
            std::mem::size_of::<FontFace>(),
            std::mem::size_of::<TextSystem>(),
            std::mem::size_of::<FontData>(),
            std::mem::size_of::<Mutex<Weak<FontData>>>(),
            std::mem::size_of::<Font>()
        );
    }
}
