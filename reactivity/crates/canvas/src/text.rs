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
mod bundled_coverage;
mod coverage;
#[cfg(test)]
mod geometry_ledger;
mod layout;
mod paragraph;
mod planner;
use layout::Details;
pub use layout::{
    CaretAffinity, GlyphRun, TextDirection, TextGeometry, TextGrapheme, TextLine, TextOffset,
    TextPosition, TextRun, TextSelection,
};

const MAX_TEXT: usize = 32 * 1024;
const MAX_GLYPHS: usize = 32 * 1024;
const CACHE_BYTES: usize = 8 * 1024 * 1024;
// Named immutable arrays guarantee one linked payload per bundled face even
// when coverage probing and lazy registration land in different codegen units.
static PRIMARY_BYTES: [u8; 2_049_096] = *include_bytes!("../assets/NotoSans.ttf");
static ARABIC_BYTES: [u8; 240_456] = *include_bytes!("../assets/arabic/NotoSansArabic-Regular.ttf");
static HEBREW_BYTES: [u8; 26_900] = *include_bytes!("../assets/hebrew/NotoSansHebrew-Regular.ttf");
static NEXT_FONT: AtomicU64 = AtomicU64::new(1);
#[cfg(test)]
static BUNDLED_PARSES: AtomicU64 = AtomicU64::new(0);
static BUNDLED_FONT: Mutex<Weak<FontData>> = Mutex::new(Weak::new());
static ARABIC_FONT: Mutex<Weak<FontData>> = Mutex::new(Weak::new());
static HEBREW_FONT: Mutex<Weak<FontData>> = Mutex::new(Weak::new());

struct FontData {
    bytes: Cow<'static, [u8]>,
    raster_key: CacheKey,
    id: u64,
    bundled: bool,
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
        Self::shared_static(&BUNDLED_FONT, &PRIMARY_BYTES, true)
    }
    fn fallback_bytes(slot: usize) -> Result<&'static [u8], Error> {
        match slot {
            1 => Ok(&ARABIC_BYTES),
            2 => Ok(&HEBREW_BYTES),
            _ => Err(Error::ForeignLayout),
        }
    }
    fn fallback(slot: usize) -> Result<Self, Error> {
        let registry = match slot {
            1 => &ARABIC_FONT,
            2 => &HEBREW_FONT,
            _ => return Err(Error::ForeignLayout),
        };
        Self::shared_static(registry, Self::fallback_bytes(slot)?, false)
    }
    fn shared_static(
        registry: &Mutex<Weak<FontData>>,
        bytes: &'static [u8],
        bundled: bool,
    ) -> Result<Self, Error> {
        let mut slot = match registry.lock() {
            Ok(slot) => slot,
            Err(poison) => {
                registry.clear_poison();
                poison.into_inner()
            }
        };
        if let Some(data) = slot.upgrade() {
            return Ok(Self(data));
        }
        let face = Self::from_data(Cow::Borrowed(bytes), bundled)?;
        *slot = Arc::downgrade(&face.0);
        Ok(face)
    }
    /// Copies caller bytes once into this face's immutable backing.
    pub fn new(bytes: impl AsRef<[u8]>) -> Result<Self, Error> {
        let bytes = bytes.as_ref();
        if bytes.is_empty() || bytes.len() > 16 * 1024 * 1024 {
            return Err(Error::ResourceLimit);
        }
        Self::from_data(Cow::Owned(bytes.to_vec()), false)
    }
    fn from_data(bytes: Cow<'static, [u8]>, bundled: bool) -> Result<Self, Error> {
        let parsed = ttf_parser::Face::parse(&bytes, 0).map_err(|_| Error::InvalidFont)?;
        // This service deliberately supports outline alpha masks, not bitmap,
        // SVG or layered-color fallback. Reject rather than return empty tofu.
        for tag in [*b"COLR", *b"CBDT", *b"EBDT", *b"sbix", *b"SVG "] {
            if parsed
                .raw_face()
                .table(ttf_parser::Tag::from_bytes(&tag))
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
            .try_update(Ordering::Relaxed, Ordering::Relaxed, |v| v.checked_add(1))
            .map_err(|_| Error::ResourceLimit)?;
        #[cfg(test)]
        if bundled {
            BUNDLED_PARSES.fetch_add(1, Ordering::Relaxed);
        }
        Ok(Self(Arc::new(FontData {
            bytes,
            raster_key,
            id,
            bundled,
        })))
    }
    /// Borrows one scoped planner session for a pass. Coverage parses a
    /// custom primary cmap once; dropping the session releases its caches.
    pub fn shaper(&self) -> TextShaper<'_> {
        TextShaper {
            font: self,
            planner: None,
        }
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
    font: FontSlot,
    simple_tail_bytes: u8,
    pub cluster: u32,
    pub x: f32,
    pub baseline: f32,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct FontSlot(u8);
impl Glyph {
    pub(crate) fn font_slot(self) -> usize {
        usize::from(self.font.0)
    }
}

/// Process-local immutable raster identity. Equal keys identify the same font
/// face, glyph and scale, including across cache eviction or separate services.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct GlyphKey {
    face: u64,
    glyph: u16,
    size: u32,
}

impl GlyphKey {
    pub(crate) fn index_parts(self) -> (u64, u64) {
        (
            self.face,
            (u64::from(self.size) << 16) | u64::from(self.glyph),
        )
    }
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

#[derive(Clone, Debug)]
struct FontSet {
    primary: FontFace,
    fallbacks: [Option<FontFace>; 2],
}
impl FontSet {
    fn face(&self, slot: usize) -> Result<&FontFace, Error> {
        if slot == 0 {
            Ok(&self.primary)
        } else {
            self.fallbacks
                .get(slot - 1)
                .and_then(Option::as_ref)
                .ok_or(Error::ForeignLayout)
        }
    }
}

/// Owned positions and immutable face leases. Accepted by any service sharing
/// the primary face; fallback slots always retain their exact original faces.
/// Advance bounds and ink differ.
#[derive(Clone, Debug)]
pub struct TextLayout {
    pub width: f32,
    pub height: f32,
    pub baseline: f32,
    font_size: f32,
    glyphs: Vec<Glyph>,
    fonts: Arc<FontSet>,
    mapping: Option<Arc<Details>>,
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

/// A scoped parser over immutable font bytes, reusable across measurement and
/// painting. It owns parsed shaping tables and reusable paragraph scratch,
/// borrows the backing, and releases both on drop. Returned layouts do not
/// borrow this parser.
///
/// This separates read-only shaping from a service's mutable glyph cache without
/// a self reference, permanent table cache or shared mutable lock. Each returned
/// layout owns one immutable FontSet lease shared by layouts from this pass.
pub struct TextShaper<'font> {
    font: &'font FontFace,
    planner: Option<Box<planner::Planner<'font>>>,
}
impl<'font> TextShaper<'font> {
    pub fn shape(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.shape_mode(text, font_size, max_width, false)
    }
    /// Requests original-byte, grapheme-safe caret geometry as cold layout data.
    /// This does not create selection state or advertise native range actions.
    pub fn shape_interactive(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.shape_mode(text, font_size, max_width, true)
    }
    fn shape_mode(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
        interactive: bool,
    ) -> Result<TextLayout, Error> {
        if !font_size.is_finite() || !(0.0..=512.0).contains(&font_size) || font_size == 0. {
            return Err(Error::InvalidFontSize);
        }
        if max_width.is_some_and(|w| !w.is_finite() || w <= 0.) {
            return Err(Error::InvalidWidth);
        }
        if text.len() > MAX_TEXT {
            return Err(Error::ResourceLimit);
        }
        if self.planner.is_none() {
            self.planner = Some(Box::new(planner::Planner::new(self.font)?));
        }
        self.planner
            .as_mut()
            .unwrap()
            .shape(text, font_size, max_width, interactive)
    }
}

/// Horizontal Unicode paragraph shaping and a bounded grayscale raster cache.
/// Bundled text lazily resolves Hebrew/Arabic outline fallback. Custom primary
/// fonts have explicit coverage errors; no OS font discovery or color fallback.
pub struct TextSystem {
    face: FontFace,
    rasters: RasterCache,
}
#[derive(Default)]
struct RasterCache {
    cache: HashMap<GlyphKey, Arc<Raster>>,
    cache_bytes: usize,
    // No scaler/outline storage until the first requested glyph.
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
            rasters: RasterCache::default(),
        }
    }
    pub fn font_face(&self) -> &FontFace {
        &self.face
    }
    pub fn cache_bytes(&self) -> usize {
        self.rasters.cache_bytes
    }
    pub fn clear_cache(&mut self) {
        self.rasters.clear_cache();
    }
    /// Shapes one string. For a batch, borrow a [`TextShaper`] from
    /// [`FontFace::shaper`] to reuse planner tables and scratch across the pass.
    pub fn shape(
        &self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.face.shaper().shape(text, font_size, max_width)
    }
    pub(crate) fn validate(&self, layout: &TextLayout) -> Result<(), Error> {
        if !layout.fonts.primary.same_face(&self.face) {
            Err(Error::ForeignLayout)
        } else {
            Ok(())
        }
    }
    pub(crate) fn layout_key(
        &self,
        layout: &TextLayout,
        glyph: Glyph,
        size: f32,
    ) -> Result<GlyphKey, Error> {
        let face = layout.fonts.face(glyph.font_slot())?;
        Ok(GlyphKey {
            face: face.0.id,
            glyph: glyph.id,
            size: size.to_bits(),
        })
    }
    pub(crate) fn layout_raster(
        &mut self,
        layout: &TextLayout,
        glyph: Glyph,
        size: f32,
    ) -> Result<Arc<Raster>, Error> {
        self.rasters
            .raster(layout.fonts.face(glyph.font_slot())?, glyph.id, size)
    }
    /// Conservative local raster bounds, useful for damage and paint geometry.
    pub fn ink_bounds(&self, layout: &TextLayout) -> Result<Rect, Error> {
        self.validate(layout)?;
        let mut min = [f32::INFINITY; 2];
        let mut max = [f32::NEG_INFINITY; 2];
        for g in &layout.glyphs {
            let Some([left, bottom, right, top]) = outline_bounds(
                &layout.fonts.face(g.font_slot())?.0.bytes,
                g.id,
                layout.font_size,
            )?
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

impl RasterCache {
    fn clear_cache(&mut self) {
        self.cache.clear();
        self.cache_bytes = 0;
        self.scaler = None;
    }
    fn raster(&mut self, face: &FontFace, id: u16, size: f32) -> Result<Arc<Raster>, Error> {
        if !size.is_finite() || size <= 0.0 || size > 4096.0 {
            return Err(Error::InvalidFontSize);
        }
        let key = GlyphKey {
            face: face.0.id,
            glyph: id,
            size: size.to_bits(),
        };
        if !self.cache.contains_key(&key) {
            let bounds = outline_bounds(&face.0.bytes, id, size)?;
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
                let mut font = FontRef::from_index(&face.0.bytes, 0).ok_or(Error::InvalidFont)?;
                font.key = face.0.raster_key;
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
                        face: face.0.id,
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
}

// A no-allocation control-hull pen preflights the same default outline used
// by Swash. The count is checked after traversal, not an early parser abort.
// Bezier curves lie in their control hull. Guard one device pixel
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
pub(crate) static BUNDLED_TEST_LOCK: Mutex<()> = Mutex::new(());

#[cfg(test)]
mod font_tests {
    use super::*;
    use std::sync::Barrier;

    // Unit tests sharing the process-global registry hold BUNDLED_TEST_LOCK.
    // Integration tests run in separate binaries with independent statics.
    #[test]
    fn bundled_concurrency_release_remint_and_poison_recovery() {
        let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
        fn send_sync<T: Send + Sync>() {}
        send_sync::<CacheKey>();
        send_sync::<FontFace>();
        send_sync::<TextSystem>();
        let before = BUNDLED_PARSES.load(Ordering::Relaxed);
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
        // Count primary bundled parses alone: unrelated caller-supplied and
        // fallback faces may mint IDs concurrently in other tests. Cold calls
        // must still avoid speculatively parsing and discarding copies.
        assert_eq!(BUNDLED_PARSES.load(Ordering::Relaxed), before + 1);
        assert!(matches!(faces[0].0.bytes, Cow::Borrowed(_)));
        let weak = Arc::downgrade(&faces[0].0);
        let old_id = faces[0].0.id;
        let service = TextSystem::from_font(faces[0].clone());
        let layout = service.shape("office", 18.0, None).unwrap();
        assert!(service.rasters.scaler.is_none());
        service.ink_bounds(&layout).unwrap();
        assert!(service.rasters.scaler.is_none());
        drop(service);
        drop(faces);
        assert!(
            weak.upgrade().is_some(),
            "owned layout keeps its exact font lease"
        );
        let shared = FontFace::bundled().unwrap();
        assert_eq!(shared.0.id, old_id);
        assert_eq!(
            TextSystem::from_font(shared.clone()).validate(&layout),
            Ok(())
        );
        drop(shared);
        drop(layout);
        assert!(weak.upgrade().is_none());
        assert!(BUNDLED_FONT.lock().unwrap().upgrade().is_none());
        let renewed = FontFace::bundled().unwrap();
        assert!(renewed.0.id > old_id);
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
