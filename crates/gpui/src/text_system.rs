//! Font selection, text layout, interaction geometry, and glyph pixels.
//!
//! These stages produce different results. [`TextSystem`] owns the shared platform
//! font database, resolves [`Font`] requests to [`FontId`]s, and caches font metrics.
//! [`WindowTextSystem`] shapes text and asks the backend to break it into visual rows.
//! The resulting [`LineLayout`] retains interaction geometry and paint fragments.
//! During painting, glyph IDs and positions are sent to the rasterizer, whose pixels are uploaded
//! to the glyph atlas. A layout therefore describes advances and caret geometry; it is not a
//! bitmap, and rasterizing glyphs does not decide line breaks.
//!
//! # Choosing a layout entry point
//!
//! Use [`shape_line`](WindowTextSystem::shape_line) for one already-broken row, and
//! [`shape_text`](WindowTextSystem::shape_text) for a document with hard breaks or wrapping. The latter
//! delegates paragraph direction, bidi resolution, line breaking, alignment, and line clamping
//! to one backend layout request. Use [`layout_inline`](WindowTextSystem::layout_inline) when atomic UI boxes
//! such as icons participate in the same wrapping and baseline calculation as text. The
//! lower-level [`layout_line`](WindowTextSystem::layout_line) returns geometry without the paintable
//! [`ShapedLine`] wrapper.
//!
//! # Text positions
//!
//! Every text range and caret index in this module is a UTF-8 byte offset into the exact source
//! string passed to layout. It is not a Unicode scalar index, UTF-16 code-unit index, grapheme
//! count, or glyph index. Use [`contains_range`](TextRangeExt::contains_range) before slicing an external range;
//! an in-bounds offset can still split a UTF-8 code point. Shape run lengths are UTF-8 byte
//! lengths and must cover the complete string. A backend caret cluster can include multiple
//! scalars, such as a combining sequence or emoji ZWJ sequence; normalize a caret through
//! [`normalized_caret`](PlatformTextLayout::normalized_caret) before assuming a position is a valid editing stop.
//! Glyph IDs are backend font glyph identifiers and cannot be used as text offsets.
//!
//! Unicode has several useful units, and they answer different questions:
//!
//! * UTF-8 byte offsets address Rust string slices and are GPUI's public layout coordinates.
//! * UTF-16 code units are common in platform text-input protocols. Convert at that boundary;
//!   never pass a UTF-16 index directly to a GPUI range.
//! * A grapheme cluster approximates a user-perceived character. It is often a sensible editing
//!   unit, but native shaping can define caret clusters differently.
//! * A glyph is a selected drawing shape. Ligatures can combine characters, and one character
//!   can produce multiple glyphs, so glyph counts do not map one-to-one to any text index.
//!
//! # Visual order and carets
//!
//! Logical source ranges remain in UTF-8 order even when a paragraph contains right-to-left text.
//! [`VisualLine`] records the visual row's logical range and resolved base direction;
//! [`CaretPosition`] adds [`CaretAffinity`] because the same byte boundary may occupy two visual
//! positions at a bidi boundary or soft wrap. Affinity describes the logical neighbor attached to
//! the caret, not a left/right movement direction. Use [`TextMovement`] and the platform layout
//! for visual navigation instead of incrementing byte offsets.
//!
//! # Fonts and units
//!
//! Build a request with [`font`], then choose [`FontWeight`], [`FontWidth`], and [`FontStyle`]
//! as needed. [`FontFeatures`] supplies OpenType feature tags, and [`FontFallbacks`] supplies
//! ordered family names for missing characters. The backend may resolve aliases or select a
//! fallback for an individual character, so one [`TextRun`] is not guaranteed to become one
//! [`PaintFragment`] or one font face. [`FontMetrics`] are reported in the face's font units;
//! pixel helpers scale by `font_size / units_per_em`. Advances are shaped-run geometry, while
//! [`typographic_bounds`](TextSystem::typographic_bounds) describes one glyph's bounds, while
//! [`bounding_box`](TextSystem::bounding_box) returns a font-wide estimate. Neither measures
//! the width of a shaped string.
//!
//! # Cache lifetime
//!
//! Share one [`TextSystem`] across windows. Keep each window's [`WindowTextSystem`] alive so its
//! current-frame and previous-frame layout caches can reuse matching requests. The cache key
//! includes text, shaping properties, and layout options; paint-only changes can reuse shaped
//! geometry and refresh paint fragments. Font registration invalidates font resolution, and a
//! platform font-generation change clears layout caches. Do not construct a new window text
//! system for each label: doing so discards the reuse boundary.
//!
//! # Example
//!
//! ```rust
//! use gpui::{IntoElement, SharedString, Styled as _, TextAlign, TextRun, canvas, hsla, px};
//!
//! fn custom_label() -> impl IntoElement {
//!     canvas(|_, _, _| (), |bounds, _, window, cx| {
//!         let text = SharedString::from("Hello, 世界");
//!         let run = TextRun {
//!             len: text.len(),
//!             color: hsla(0., 0., 0., 1.),
//!             ..Default::default()
//!         };
//!         let shaped = window.text_system().shape_line(text, px(16.), &[run]);
//!         shaped.paint(bounds.origin, px(24.), TextAlign::Left, None, window, cx).unwrap();
//!     }).w(px(180.)).h(px(24.))
//! }
//! ```
//!
//! The snippet shows the single-line path. For user-provided content that may contain line
//! breaks, use [`shape_text`](WindowTextSystem::shape_text) and retain the returned [`ShapedText`] for both
//! painting and hit testing. The [text walkthrough](https://gpui-ce.github.io/examples/text/)
//! demonstrates inherited styles and paragraph constraints.

#[cfg(test)]
use crate::{
    AtlasKey, AtlasTextureKind, PlatformAtlas, TestAtlas, TestTextSystem, hsla, point, size,
};

#[cfg(test)]
use std::{sync::atomic::AtomicUsize, sync::atomic::Ordering};

use crate::{
    Bounds, DevicePixels, Pixels, PlatformTextSystem, Point, ResolvedDirection, Result,
    SharedString, Size, StrikethroughStyle, TextAlign, TextRenderingMode, UnderlineStyle,
    UnicodeBidi, px,
};
use anyhow::{Context as _, anyhow};
use collections::FxHashMap;
use core::fmt;
use derive_more::{Add, Deref, FromStr, Sub};
use palette::Hsla;
use parking_lot::{RwLock, RwLockUpgradableReadGuard};
use schemars::JsonSchema;
use serde::{Deserialize, Serialize};
use smallvec::SmallVec;
use std::{
    borrow::Cow,
    fmt::{Debug, Display, Formatter},
    hash::{Hash, Hasher},
    ops::Range,
    sync::Arc,
};

mod font_fallbacks;
mod font_features;
mod font_width;
mod line;
mod line_layout;

pub use font_fallbacks::*;
pub use font_features::*;
pub use font_width::*;
pub use line::*;
pub use line_layout::*;

/// Check whether a byte range can safely slice a UTF-8 string.
///
/// An offset can be in bounds and still split a scalar. This trait accepts
/// exactly the ranges accepted by `str::get`, including an empty range on a
/// character boundary. It does not check grapheme or shaped-cluster boundaries.
///
/// ```rust
/// use gpui::TextRangeExt as _;
///
/// let text = "café";
/// assert!(text.contains_range(&(3..5)));  // The two-byte é.
/// assert!(!text.contains_range(&(3..4))); // Cuts its encoding in half.
/// assert!(text.contains_range(&(5..5)));  // Empty range at the end.
/// ```
pub trait TextRangeExt {
    /// Returns whether `range` is ordered, in bounds, and lies on character boundaries.
    fn contains_range(&self, range: &Range<usize>) -> bool;
}

impl TextRangeExt for str {
    fn contains_range(&self, range: &Range<usize>) -> bool {
        self.get(range.clone()).is_some()
    }
}

/// A font instance resolved by one platform text backend.
///
/// Obtain it from [`TextSystem::resolve_font`] or a shaped [`PaintFragment`].
/// The numeric value is meaningful to that backend; it is not a family name,
/// a portable file identifier, or an index suitable for reuse in another app.
#[derive(Hash, PartialEq, Eq, Clone, Copy, Debug, serde::Serialize, serde::Deserialize)]
#[repr(C)]
pub struct FontId(pub usize);

/// Number of subpixel glyph variants along the X axis.
pub const SUBPIXEL_VARIANTS_X: u8 = 4;

/// Number of subpixel glyph variants along the Y axis.
pub const SUBPIXEL_VARIANTS_Y: u8 = 1;

/// Shared font database and glyph metrics for a platform text backend.
///
/// Font registration invalidates cached font resolutions. Metrics are cached by resolved
/// [`FontId`], while each window's layout cache belongs to [`WindowTextSystem`].
///
/// An [`App`](crate::App) supplies its shared system through
/// [`App::text_system`](crate::App::text_system). A window exposes both these
/// font operations and its own shaping cache through [`Window::text_system`](crate::Window::text_system).
/// Most views should use [`Text`](crate::Text) or [`StyledText`](crate::StyledText),
/// which perform those steps during the element lifecycle.
/// The [text chapter](https://gpui-ce.github.io/book/text.html) explains how these
/// entry points, font metrics, and caret geometry fit together.
///
/// Use font metrics to place a baseline or size a decoration. Measure a string
/// by shaping it: adding the advances of its individual characters misses
/// kerning, substitutions, ligatures, and fallback. The
/// [text-hit-testing walkthrough](https://gpui-ce.github.io/examples/text-hit-testing/)
/// keeps shaped text and its interaction geometry together.
pub struct TextSystem {
    platform_text_system: Arc<dyn PlatformTextSystem>,
    font_ids_by_font: RwLock<FontLookupCache>,
    font_metrics: RwLock<FxHashMap<FontId, FontMetrics>>,
}

#[derive(Default)]
struct FontLookupCache {
    generation: u64,
    ids: FxHashMap<Font, Result<FontId>>,
}

impl TextSystem {
    /// Wrap a platform's font database, metrics, and rasterizer.
    ///
    /// Normally the application constructs this system. Share it across windows
    /// rather than creating separate font caches for individual labels.
    pub fn new(platform_text_system: Arc<dyn PlatformTextSystem>) -> Self {
        TextSystem {
            platform_text_system,
            font_metrics: RwLock::default(),
            font_ids_by_font: RwLock::default(),
        }
    }

    /// Shares this application's configured shaping and rasterization backend,
    /// including fonts registered by the host application.
    pub fn platform_backend(&self) -> Arc<dyn PlatformTextSystem> {
        self.platform_text_system.clone()
    }

    /// Return the family names currently visible to the backend.
    ///
    /// The list comes directly from the platform and is not sorted here.
    /// A listed family need not cover every character, and a resolved run may
    /// use fallback faces in addition to the requested family.
    pub fn all_font_names(&self) -> Vec<String> {
        self.platform_text_system.all_font_names()
    }

    /// Register font bytes and invalidate cached resolutions.
    ///
    /// Font family names come from each font's embedded name table; the vector
    /// position or asset path does not name the face. Register fonts before
    /// measuring views that depend on them. Window layout caches detect the
    /// backend's changed font generation when they next shape text.
    ///
    /// # Errors
    ///
    /// Returns the platform loader's error for invalid or unsupported font
    /// data. Cached font resolutions are cleared even when registration fails.
    pub fn add_fonts(&self, fonts: Vec<Cow<'static, [u8]>>) -> Result<()> {
        // Serialize registration with cache misses so an in-flight lookup cannot
        // repopulate a stale miss after the newly registered fonts become available.
        let mut font_ids = self.font_ids_by_font.write();
        let result = self.platform_text_system.add_fonts(fonts);
        font_ids.ids.clear();
        font_ids.generation = self.platform_text_system.font_generation();
        result
    }

    /// Resolve a font request and cache either its ID or its resolution error.
    fn font_id(&self, font: &Font) -> Result<FontId> {
        fn clone_font_id_result(font_id: &Result<FontId>) -> Result<FontId> {
            match font_id {
                Ok(font_id) => Ok(*font_id),
                Err(err) => Err(anyhow!("{err}")),
            }
        }

        let generation = self.platform_text_system.font_generation();
        let font_id = {
            let cache = self.font_ids_by_font.read();
            (cache.generation == generation)
                .then(|| cache.ids.get(font).map(clone_font_id_result))
                .flatten()
        };
        if let Some(font_id) = font_id {
            font_id
        } else {
            let mut font_ids = self.font_ids_by_font.write();
            loop {
                let generation = self.platform_text_system.font_generation();
                if font_ids.generation != generation {
                    font_ids.ids.clear();
                    font_ids.generation = generation;
                }
                if let Some(font_id) = font_ids.ids.get(font) {
                    return clone_font_id_result(font_id);
                }
                let font_id = self.platform_text_system.font_id(font);
                // The backend may be shared with a preview worker registering fonts.
                if self.platform_text_system.font_generation() != generation {
                    continue;
                }
                font_ids
                    .ids
                    .insert(font.clone(), clone_font_id_result(&font_id));
                return font_id;
            }
        }
    }

    /// Resolves the specified font using backend-owned aliases and fallbacks.
    ///
    /// # Panics
    ///
    /// Panics if the backend cannot resolve the font.
    pub fn resolve_font(&self, font: &Font) -> FontId {
        self.font_id(font)
            .unwrap_or_else(|error| panic!("failed to resolve font '{}': {error}", font.family))
    }

    /// Prewarm any system font caches needed to shape text.
    ///
    /// This may be expensive, so callers should generally invoke it on a
    /// background executor. Missing entries are still populated on demand by
    /// the normal shaping path.
    ///
    /// # Panics
    ///
    /// Panics if any request cannot be resolved, as in [`Self::resolve_font`].
    pub fn prewarm_fonts(&self, fonts: &[Font]) {
        let mut font_ids = SmallVec::<[FontId; 8]>::new();
        for font in fonts {
            let font_id = self.resolve_font(font);
            if !font_ids.contains(&font_id) {
                font_ids.push(font_id);
            }
        }
        self.platform_text_system.prewarm_fonts(&font_ids);
    }

    /// Returns the backend's font-wide extent estimate at `font_size`.
    ///
    /// This scales [`FontMetrics::bounding_box`] to logical pixels. Parley uses
    /// maximum advance width and typographic height, so the rectangle need not
    /// enclose every glyph's ink. It does not measure a particular string.
    /// Shape the string to obtain its advance, or use [`Self::typographic_bounds`]
    /// for one character's selected glyph.
    pub fn bounding_box(&self, font_id: FontId, font_size: Pixels) -> Bounds<Pixels> {
        self.read_metrics(font_id, |metrics| metrics.bounding_box(font_size))
    }

    /// Return the typographic bounds of one character's selected glyph.
    ///
    /// The result is scaled to logical pixels and describes that glyph alone.
    /// It does not shape neighboring characters or compute a string's advance.
    /// Use [`WindowTextSystem::shape_line`] for displayed text.
    ///
    /// # Errors
    ///
    /// Returns an error if this face has no glyph for the character or the
    /// platform cannot provide its typographic bounds.
    pub fn typographic_bounds(
        &self,
        font_id: FontId,
        font_size: Pixels,
        character: char,
    ) -> Result<Bounds<Pixels>> {
        let glyph_id = self
            .platform_text_system
            .glyph_for_char(font_id, character)
            .with_context(|| format!("glyph not found for character '{character}'"))?;
        let bounds = self
            .platform_text_system
            .typographic_bounds(font_id, glyph_id)?;
        Ok(self.read_metrics(font_id, |metrics| {
            (bounds / metrics.units_per_em as f32 * font_size.0).map(px)
        }))
    }

    /// Return the backend advance for the glyph selected for `ch`, scaled to `font_size`.
    ///
    /// The result is a [`Size`] because backends can report horizontal and vertical advances.
    /// This performs a character-to-glyph lookup; it does not shape a string and therefore does
    /// not account for ligatures, contextual substitutions, or kerning between characters. Use
    /// [`WindowTextSystem::shape_line`] to measure text as it will be laid out.
    ///
    /// # Errors
    ///
    /// Returns an error if this face has no glyph for the character or the
    /// platform cannot provide its advance.
    pub fn advance(&self, font_id: FontId, font_size: Pixels, ch: char) -> Result<Size<Pixels>> {
        let glyph_id = self
            .platform_text_system
            .glyph_for_char(font_id, ch)
            .with_context(|| format!("glyph not found for character '{ch}'"))?;
        let result = self.platform_text_system.advance(font_id, glyph_id)?
            / self.units_per_em(font_id) as f32;

        Ok(result * font_size)
    }

    /// Return the number of design units in the face's em square.
    ///
    /// Scale a font-unit metric with `font_size / units_per_em`; the em square is a coordinate
    /// system, not a promise that visible glyphs fill the requested font size.
    pub fn units_per_em(&self, font_id: FontId) -> u32 {
        self.read_metrics(font_id, |metrics| metrics.units_per_em)
    }

    /// Return the face's recommended distance above the baseline at `font_size`.
    pub fn ascent(&self, font_id: FontId, font_size: Pixels) -> Pixels {
        self.read_metrics(font_id, |metrics| metrics.ascent(font_size))
    }

    /// Return the face's descent scaled to `font_size`.
    ///
    /// This is a font metric, not the visible lower edge of a particular
    /// string or the line spacing chosen by its parent.
    pub fn descent(&self, font_id: FontId, font_size: Pixels) -> Pixels {
        self.read_metrics(font_id, |metrics| metrics.descent(font_size))
    }

    /// Return the face's x-height scaled to `font_size`.
    ///
    /// This metric helps align small inline content with lowercase text. It
    /// does not measure the particular glyphs in a shaped string.
    pub fn x_height(&self, font_id: FontId, font_size: Pixels) -> Pixels {
        self.read_metrics(font_id, |metrics| metrics.x_height(font_size))
    }

    /// Return the baseline position within a line of `line_height`.
    ///
    /// The method centers the font ascent-plus-descent box in the line, then adds the ascent.
    /// It does not clamp negative leading when the requested line height is smaller than those
    /// metrics.
    pub fn baseline_offset(
        &self,
        font_id: FontId,
        font_size: Pixels,
        line_height: Pixels,
    ) -> Pixels {
        let ascent = self.ascent(font_id, font_size);
        let descent = self.descent(font_id, font_size);
        let padding_top = (line_height - ascent - descent) / 2.;
        padding_top + ascent
    }

    fn read_metrics<T>(&self, font_id: FontId, read: impl FnOnce(&FontMetrics) -> T) -> T {
        let lock = self.font_metrics.upgradable_read();

        if let Some(metrics) = lock.get(&font_id) {
            read(metrics)
        } else {
            let mut lock = RwLockUpgradableReadGuard::upgrade(lock);
            let metrics = lock
                .entry(font_id)
                .or_insert_with(|| self.platform_text_system.font_metrics(font_id));
            read(metrics)
        }
    }

    /// Rasterize a backend glyph and validate its placement and pixel buffer.
    ///
    /// Use the active backend's font and glyph IDs. The result is in device
    /// pixels and may be successfully empty, as for a space. Window painting
    /// normally performs this operation through its glyph atlas cache.
    ///
    /// # Errors
    ///
    /// Returns a platform rasterization error or an error from
    /// [`RasterizedGlyph::validate`] if the dimensions and bytes disagree.
    pub fn rasterize_glyph(&self, params: &RenderGlyphParams) -> Result<ValidatedRasterizedGlyph> {
        let glyph = self.platform_text_system.rasterize_glyph(params)?;

        ValidatedRasterizedGlyph::new(glyph)
    }

    pub(crate) fn prewarm_glyphs(&self, requests: &mut dyn Iterator<Item = GlyphRasterRequest>) {
        self.platform_text_system.prewarm_glyphs(requests);
    }

    /// Normalizes a requested scene color and render mode into the settings which affect the
    /// cached glyph raster.
    #[cfg(test)]
    pub(crate) fn prepare_raster_style(
        &self,
        font_id: FontId,
        glyph_id: GlyphId,
        scene_color: Hsla,
        requested_mode: GlyphRenderMode,
    ) -> PreparedRasterStyle {
        self.prepare_raster_style_request(RasterStyleRequest {
            font_id,
            glyph_id,
            scene_color: crate::hsla_to_rgba(scene_color),
            requested_mode,
            foreground_dependency: ForegroundDependency::Full,
        })
    }

    pub(crate) fn prepare_raster_style_request(
        &self,
        request: RasterStyleRequest,
    ) -> PreparedRasterStyle {
        self.platform_text_system.prepare_raster_style(request)
    }

    /// Returns the text rendering mode recommended by the platform for the given font and size.
    /// The return value will never be [`TextRenderingMode::PlatformDefault`].
    pub(crate) fn recommended_rendering_mode(
        &self,
        font_id: FontId,
        font_size: Pixels,
    ) -> TextRenderingMode {
        self.platform_text_system
            .recommended_rendering_mode(font_id, font_size)
    }
}

/// Window-scoped text shaping and layout cache.
///
/// The cache moves matching layouts between the current frame and the previous frame as the
/// window finishes rendering. Keep one value per window so repeated labels can reuse layout;
/// constructing one for each label starts with an empty cache. Font metrics and font resolution
/// are shared through the [`TextSystem`] dereferenced by this type.
///
/// # Choose a shaping operation
///
/// | Operation | Result and use |
/// | --- | --- |
/// | [`Self::shape_line`] | Paint one row whose line breaks are already known |
/// | [`Self::shape_text`] | Paint a document with hard breaks or optional wrapping |
/// | [`Self::shape_text_with_options`] | Set direction, bidi, and alignment explicitly |
/// | [`Self::layout_line`] | Inspect geometry without a paintable wrapper |
/// | [`Self::layout_inline`] | Wrap text and atomic element boxes together |
///
/// Runs cover the complete source by UTF-8 byte length. Keep the returned
/// layout for both painting and hit testing so the two use the same string,
/// fonts, wrapping, and direction. [`StyledText`](crate::StyledText) handles
/// ordinary styled labels without requiring a manual shaping call.
///
/// # Backend failures
///
/// Layout assumes valid font features and source ranges. The platform layout trait has an
/// infallible return type, so a backend failure can panic even through a method returning
/// `Result`. In Parley, malformed feature tags or values above `u16::MAX` panic during layout.
/// [`FontFeatures`] explains which inputs are accepted; deserializing a request does not
/// establish that it is valid for shaping.
#[derive(Deref)]
pub struct WindowTextSystem {
    line_layout_cache: LineLayoutCache,
    #[deref]
    text_system: Arc<TextSystem>,
}

impl WindowTextSystem {
    /// Create a window's layout cache over the shared font system.
    ///
    /// Normally use [`Window::text_system`](crate::Window::text_system), whose
    /// lifetime and frame boundaries are managed by the window. A manually
    /// constructed instance does not advance its caches merely because an app
    /// renders another window.
    pub fn new(text_system: Arc<TextSystem>) -> Self {
        Self {
            line_layout_cache: LineLayoutCache::new(text_system.platform_text_system.clone()),
            text_system,
        }
    }

    pub(crate) fn layout_index(&self) -> LineLayoutIndex {
        self.line_layout_cache.layout_index()
    }

    pub(crate) fn reuse_layouts(&self, index: Range<LineLayoutIndex>) {
        self.line_layout_cache.reuse_layouts(index)
    }

    pub(crate) fn truncate_layouts(&self, index: LineLayoutIndex) {
        self.line_layout_cache.truncate_layouts(index)
    }

    /// Shape one logical line for painting.
    ///
    /// `runs` partitions the string by UTF-8 byte length and should cover it completely; every
    /// run boundary must also be a UTF-8 character boundary. Each run supplies font and paint
    /// attributes. Fallback can split a styled run into multiple resolved glyph fragments.
    ///
    /// In debug builds this asserts that `text` contains no LF (`\n`). Other hard-break
    /// characters are not checked here. If the input may contain any line breaks, use
    /// [`Self::shape_text`] instead.
    ///
    /// ```rust
    /// use gpui::{SharedString, TextRun, Window, px};
    ///
    /// fn label_width(window: &Window) -> gpui::Pixels {
    ///     let text = SharedString::from("Save café");
    ///     let run = window.text_style().to_run(text.len());
    ///     window.text_system().shape_line(text, px(16.), &[run]).width()
    /// }
    /// ```
    ///
    /// # Panics
    ///
    /// In debug builds, panics if `text` contains LF. Backend layout failures also panic;
    /// see [`WindowTextSystem`]'s backend-failure contract.
    pub fn shape_line(
        &self,
        text: SharedString,
        font_size: Pixels,
        runs: &[TextRun],
    ) -> ShapedLine {
        debug_assert!(
            text.find('\n').is_none(),
            "text argument should not contain newlines"
        );

        let layout = self.layout_line(&text, font_size, runs);

        ShapedLine { layout, text }
    }

    /// Shape a UTF-8 document for painting, including hard breaks and optional wrapping.
    /// Subsets of the text can be styled independently with the `runs` parameter,
    /// where each run gives the number of UTF-8 bytes that it styles. Runs must cover the
    /// complete string and end on UTF-8 character boundaries.
    ///
    /// If `wrap_width` is provided, the backend may insert soft breaks to fit that width. Hard
    /// breaks in the source remain part of the same document layout. `line_clamp` limits
    /// soft wrapping; `None` leaves wrapping unrestricted. This is a line-breaking request,
    /// not source truncation or clipping. In the Parley backend, hard breaks remain and the
    /// final permitted soft row can overflow horizontally. See [`TextLayoutOptions::line_clamp`].
    ///
    /// The backend receives the complete string. Hard breaks, trailing empty lines, bidi
    /// paragraphs, wrapping, and `line_clamp` therefore share one layout model.
    ///
    /// # Panics
    ///
    /// Backend layout failures panic rather than becoming `Err`. In particular, Parley
    /// requires the feature tags and values described by [`FontFeatures`].
    pub fn shape_text<S: AsRef<str> + Into<SharedString>>(
        &self,
        text: S,
        font_size: Pixels,
        runs: &[TextRun],
        wrap_width: Option<Pixels>,
        line_clamp: Option<usize>,
    ) -> Result<ShapedText> {
        self.shape_text_with_options(
            text,
            font_size,
            runs,
            TextLayoutOptions {
                wrap_width,
                line_clamp,
                ..Default::default()
            },
        )
    }

    /// Shape a complete document with explicit direction, bidi, wrapping, and alignment options.
    ///
    /// Run lengths must cover the complete UTF-8 source, with every boundary on a character
    /// boundary. Use [`TextLayoutOptions::wrap_width`] to control line breaking and
    /// [`TextLayoutOptions::alignment_width`] to supply a box for unwrapped alignment.
    /// Backend-specific interactions between those options are documented on the fields.
    ///
    /// # Panics
    ///
    /// Backend layout failures panic rather than becoming `Err`; see [`Self::shape_text`].
    pub fn shape_text_with_options<S: AsRef<str> + Into<SharedString>>(
        &self,
        text: S,
        font_size: Pixels,
        runs: &[TextRun],
        options: TextLayoutOptions,
    ) -> Result<ShapedText> {
        let text = text.into();
        let layout = self
            .line_layout_cache
            .layout_text_with_options(&text, font_size, runs, options);

        Ok(ShapedText { layout, text })
    }

    /// Layout text and atomic element boxes in one inline formatting context.
    ///
    /// Text styles, box insertion points, and bidi scopes use UTF-8 byte positions into
    /// `request.text`. The returned layout owns its geometry and can be retained after the
    /// request's borrowed slices go out of scope. Use this when a box must wrap with text; lay
    /// out an independent icon separately when it should not affect text flow.
    ///
    /// # Panics
    ///
    /// Backend layout failures panic, including invalid Parley font features as described on
    /// [`WindowTextSystem`]. The request must satisfy [`InlineLayoutRequest`]'s range contract.
    pub fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> Arc<InlineLayout> {
        self.line_layout_cache.layout_inline(request)
    }

    /// Layout one logical line without creating a directly paintable wrapper.
    ///
    /// `runs` use UTF-8 byte lengths and should cover the full string at character boundaries.
    /// This returns geometry for measurement and interaction; prefer [`Self::shape_line`] when
    /// the result will be painted through its convenience wrapper. Text may be retained in the
    /// cache, so the returned layout does not borrow from `text`.
    ///
    /// # Panics
    ///
    /// Backend layout failures panic; see [`WindowTextSystem`]'s backend-failure contract.
    pub fn layout_line(&self, text: &str, font_size: Pixels, runs: &[TextRun]) -> Arc<LineLayout> {
        self.line_layout_cache
            .layout_line(&SharedString::new(text), font_size, runs)
    }

    pub(crate) fn finish_frame(&self) {
        self.line_layout_cache.finish_frame()
    }
}

/// Requested font weight, conventionally from 100 (thin) to 900 (black), with 400 normal.
///
/// The newtype and `From<f32>` conversion do not validate or clamp values; the range describes
/// the standard weight scale used by the named constants and schema.
#[derive(Clone, Copy, Debug, PartialEq, PartialOrd, Serialize, Deserialize, Add, Sub, FromStr)]
#[serde(transparent)]
pub struct FontWeight(pub f32);

impl Display for FontWeight {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl From<f32> for FontWeight {
    fn from(weight: f32) -> Self {
        FontWeight(weight)
    }
}

impl Default for FontWeight {
    #[inline]
    fn default() -> FontWeight {
        FontWeight::NORMAL
    }
}

impl Hash for FontWeight {
    fn hash<H: Hasher>(&self, state: &mut H) {
        state.write_u32(u32::from_be_bytes(self.0.to_be_bytes()));
    }
}

impl Eq for FontWeight {}

impl FontWeight {
    /// Named thin weight (100).
    pub const THIN: FontWeight = FontWeight(100.0);
    /// Extra light weight (200).
    pub const EXTRA_LIGHT: FontWeight = FontWeight(200.0);
    /// Light weight (300).
    pub const LIGHT: FontWeight = FontWeight(300.0);
    /// Normal (400).
    pub const NORMAL: FontWeight = FontWeight(400.0);
    /// Medium weight (500, higher than normal).
    pub const MEDIUM: FontWeight = FontWeight(500.0);
    /// Semibold weight (600).
    pub const SEMIBOLD: FontWeight = FontWeight(600.0);
    /// Bold weight (700).
    pub const BOLD: FontWeight = FontWeight(700.0);
    /// Extra-bold weight (800).
    pub const EXTRA_BOLD: FontWeight = FontWeight(800.0);
    /// Named black weight (900).
    pub const BLACK: FontWeight = FontWeight(900.0);

    /// The nine named standard weights, in ascending order.
    pub const ALL: [FontWeight; 9] = [
        Self::THIN,
        Self::EXTRA_LIGHT,
        Self::LIGHT,
        Self::NORMAL,
        Self::MEDIUM,
        Self::SEMIBOLD,
        Self::BOLD,
        Self::EXTRA_BOLD,
        Self::BLACK,
    ];
}

impl schemars::JsonSchema for FontWeight {
    fn schema_name() -> std::borrow::Cow<'static, str> {
        "FontWeight".into()
    }

    fn json_schema(_: &mut schemars::SchemaGenerator) -> schemars::Schema {
        use schemars::json_schema;
        json_schema!({
            "type": "number",
            "minimum": Self::THIN,
            "maximum": Self::BLACK,
            "default": Self::default(),
            "description": "Font weight value between 100 (thin) and 900 (black)"
        })
    }
}

/// Allows italic or oblique faces to be selected.
#[derive(Clone, Copy, Eq, PartialEq, Debug, Hash, Default, Serialize, Deserialize, JsonSchema)]
pub enum FontStyle {
    /// A face that is neither italic nor oblique.
    #[default]
    Normal,
    /// A form that is generally cursive in nature.
    Italic,
    /// A typically-sloped version of the regular face.
    Oblique,
}

impl Display for FontStyle {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        Debug::fmt(self, f)
    }
}

/// Shaping and paint properties for a byte range passed to [`WindowTextSystem::shape_text`].
#[derive(Clone, Debug, PartialEq, Default, serde::Serialize, serde::Deserialize)]
pub struct TextRun {
    /// Number of UTF-8 bytes styled by this run.
    ///
    /// Runs are consumed in order and should cover the full input string. Boundaries must be
    /// UTF-8 character boundaries. This is not a count of graphemes, Unicode scalar values, or
    /// shaped glyphs.
    pub len: usize,
    /// The font to use for this run.
    pub font: Font,
    /// Foreground color used when painting the run's glyphs.
    #[serde(with = "crate::color::serde_colors::hsla")]
    pub color: Hsla,
    /// Optional background rectangle painted behind this run.
    #[serde(with = "crate::color::serde_colors::optional_hsla")]
    pub background_color: Option<Hsla>,
    /// Optional underline painted as a foreground decoration.
    pub underline: Option<UnderlineStyle>,
    /// Optional strikethrough painted as a foreground decoration.
    pub strikethrough: Option<StrikethroughStyle>,
    /// Additional spacing applied between glyphs, in logical pixels.
    pub letter_spacing: Option<Pixels>,
}

/// The paragraph base-direction policy supplied to a text backend.
#[derive(
    Clone, Copy, Debug, Default, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize,
)]
pub enum ParagraphDirection {
    /// Determine paragraph direction from its source text.
    #[default]
    Auto,
    /// Use an explicit left-to-right paragraph base direction.
    LeftToRight,
    /// Use an explicit right-to-left paragraph base direction.
    RightToLeft,
}

impl From<ResolvedDirection> for ParagraphDirection {
    fn from(direction: ResolvedDirection) -> Self {
        match direction {
            ResolvedDirection::LeftToRight => Self::LeftToRight,
            ResolvedDirection::RightToLeft => Self::RightToLeft,
        }
    }
}

/// A directional scope within an inline text document.
#[doc(hidden)]
#[derive(Clone, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct InlineBidiScope {
    /// UTF-8 source range covered by this scope.
    pub range: Range<usize>,
    /// Resolved direction used by the scope.
    pub direction: ResolvedDirection,
    /// The CSS `unicode-bidi` behavior for the scope.
    pub unicode_bidi: UnicodeBidi,
}

/// Direction, wrapping, and alignment options for a complete text document.
///
/// Pass this to [`WindowTextSystem::shape_text_with_options`] when the defaults of
/// [`WindowTextSystem::shape_text`] are insufficient. Wrapping decides where a visual row
/// breaks; alignment decides where that row sits in its box. For unwrapped text, supply
/// an alignment width when the box is wider than the text's advance.
///
/// The default leaves wrapping, clamping, and alignment width unset, detects paragraph
/// direction from the source, and aligns at the direction's start edge. These options
/// affect geometry, not the source string or its UTF-8 byte indices.
///
/// ```
/// use gpui::{ParagraphDirection, TextAlign, TextLayoutOptions, Window, px};
///
/// fn caption(window: &Window) -> gpui::Result<gpui::ShapedText> {
///     let source = "Saved";
///     let run = window.text_style().to_run(source.len());
///     window.text_system().shape_text_with_options(
///         source,
///         px(16.),
///         &[run],
///         TextLayoutOptions {
///             alignment_width: Some(px(240.)),
///             text_align: TextAlign::Center,
///             direction: ParagraphDirection::LeftToRight,
///             ..Default::default()
///         },
///     )
/// }
/// ```
#[derive(
    Clone, Copy, Debug, Default, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize,
)]
pub struct TextLayoutOptions {
    /// Optional maximum width, in logical pixels, that triggers soft wrapping.
    pub wrap_width: Option<Pixels>,
    /// Optional soft-wrapping budget, not a source-truncation or clipping operation.
    ///
    /// Parley wraps the preceding rows, then lays out the remainder without further soft
    /// breaks. Hard breaks remain, so the result can have more rows than this value.
    /// `Some(0)` and `Some(1)` both leave the first hard paragraph unwrapped. To hide
    /// overflow or add an ellipsis, use element clipping and
    /// [`TextStyle::text_overflow`](crate::TextStyle::text_overflow).
    pub line_clamp: Option<usize>,
    /// Box width, in logical pixels, used to align unwrapped rows.
    ///
    /// In Parley this width is used when both `wrap_width` and `line_clamp` are `None`.
    /// Wrapped text aligns within the wrapping width instead; a separate alignment width
    /// does not widen that box. This sets geometry, not an element's layout width.
    pub alignment_width: Option<Pixels>,
    /// Horizontal alignment, including direction-aware `Start` and `End` values.
    pub text_align: TextAlign,
    /// Paragraph base direction, either detected from the text or explicitly set.
    pub direction: ParagraphDirection,
    /// Bidirectional behavior applied to the complete document, distinct from the base direction.
    pub unicode_bidi: UnicodeBidi,
}

/// Complete input for one backend-owned text document layout.
///
/// `runs` must cover all UTF-8 bytes of `text` using character-boundary lengths. The borrowed
/// values are consumed synchronously by the backend layout request.
#[derive(Clone, Copy, Debug)]
pub struct TextLayoutRequest<'a> {
    /// UTF-8 source text.
    pub text: &'a str,
    /// Font size shared by all style runs.
    pub font_size: Pixels,
    /// Complete shaping and paint styles covering `text`.
    pub runs: &'a [TextRun],
    /// Wrapping, alignment, and bidirectional layout options.
    pub options: TextLayoutOptions,
}

/// An atomic element inserted at a UTF-8 character boundary in an inline document.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct InlineBoxRequest {
    /// Identifier returned with the positioned box.
    pub id: u64,
    /// UTF-8 byte index at which to insert the box. This is not a character or glyph count.
    pub index: usize,
    /// Measured size of the element.
    pub size: Size<Pixels>,
    /// Vertical alignment within the line containing this element.
    pub vertical_align: crate::VerticalAlign,
}

/// Resolved font size and line height for part of an inline document.
#[derive(Clone, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct InlineTextStyle {
    /// UTF-8 range receiving these resolved metrics.
    pub range: Range<usize>,
    /// Font size for this range.
    pub font_size: Pixels,
    /// Absolute line height for this range.
    pub line_height: Pixels,
}

/// Complete input for a document containing text and element boxes.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub struct InlineLayoutRequest<'a> {
    /// UTF-8 source text.
    pub text: &'a str,
    /// Complete shaping and paint styles covering `text`.
    pub runs: &'a [TextRun],
    /// Resolved font sizes and line heights for UTF-8 ranges within the document.
    pub text_styles: &'a [InlineTextStyle],
    /// Atomic boxes inserted into the text.
    pub boxes: &'a [InlineBoxRequest],
    /// Base font size.
    pub font_size: Pixels,
    /// Requested height of an ordinary text row.
    pub line_height: Pixels,
    /// Metrics for the inline container's base font.
    pub text_metrics: InlineTextMetrics,
    /// Wrapping, alignment, and bidirectional layout options.
    pub options: TextLayoutOptions,
    /// Directional scopes established by nested inline elements.
    pub bidi_scopes: &'a [InlineBidiScope],
}

impl Eq for TextRun {}

impl Hash for TextRun {
    fn hash<H: Hasher>(&self, state: &mut H) {
        fn hash_float<H: Hasher>(value: f32, state: &mut H) {
            if value == 0.0 {
                0.0f32.to_bits().hash(state);
            } else {
                value.to_bits().hash(state);
            }
        }

        fn hash_color<H: Hasher>(color: Hsla, state: &mut H) {
            let color = crate::hsla_to_rgba(color);
            hash_float(color.color.red, state);
            hash_float(color.color.green, state);
            hash_float(color.color.blue, state);
            hash_float(color.alpha, state);
        }

        self.len.hash(state);
        self.font.hash(state);
        hash_color(self.color, state);
        if let Some(color) = self.background_color {
            hash_color(color, state);
        }
        self.background_color.is_some().hash(state);
        self.underline.is_some().hash(state);
        if let Some(underline) = self.underline {
            hash_float(underline.thickness.into(), state);
            underline.color.is_some().hash(state);
            if let Some(color) = underline.color {
                hash_color(color, state);
            }
            underline.wavy.hash(state);
        }
        self.strikethrough.is_some().hash(state);
        if let Some(strikethrough) = self.strikethrough {
            hash_float(strikethrough.thickness.into(), state);
            strikethrough.color.is_some().hash(state);
            if let Some(color) = strikethrough.color {
                hash_color(color, state);
            }
        }
        self.letter_spacing.is_some().hash(state);
        if let Some(letter_spacing) = self.letter_spacing {
            hash_float(letter_spacing.into(), state);
        }
    }
}

impl From<&TextRun> for PaintStyle {
    fn from(run: &TextRun) -> Self {
        Self {
            color: run.color,
            background_color: run.background_color,
            underline: run.underline,
            strikethrough: run.strikethrough,
        }
    }
}

/// An identifier for a specific glyph, as returned by [`WindowTextSystem::layout_line`].
#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash, serde::Serialize, serde::Deserialize)]
#[repr(C)]
pub struct GlyphId(pub u32);

/// Parameters for rendering a glyph and identifying its atlas entry.
///
/// Font and glyph IDs come from the active platform text backend. `font_size` is in logical
/// pixels, `subpixel_variant` selects one of the rasterizer's fractional-position samples, and
/// `scale_factor` converts to device pixels. The complete value, including `raster_style`, is
/// hashed for atlas lookup. The subpixel grid is described by [`SUBPIXEL_VARIANTS_X`] and
/// [`SUBPIXEL_VARIANTS_Y`].
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct RenderGlyphParams {
    /// Font face containing the glyph.
    pub font_id: FontId,
    /// Backend glyph identifier.
    pub glyph_id: GlyphId,
    /// Requested logical font size.
    pub font_size: Pixels,
    /// Fractional positioning sample; X is in `0..SUBPIXEL_VARIANTS_X` and Y in
    /// `0..SUBPIXEL_VARIANTS_Y`.
    pub subpixel_variant: Point<u8>,
    /// Device scale used to rasterize the glyph. This is part of the cache identity.
    pub scale_factor: f32,
    /// Normalized cache-relevant rendering policy.
    pub raster_style: PreparedRasterStyle,
}

/// A glyph request before the platform selects its cache-relevant raster style.
/// Platform bridges can prepare several glyphs together using the same requests
/// that ordinary window painting will subsequently consume.
#[derive(Clone, Copy, Debug, serde::Serialize, serde::Deserialize)]
pub struct GlyphRasterRequest {
    /// Font, glyph, foreground, and requested render mode.
    pub style: RasterStyleRequest,
    /// Logical font size.
    pub font_size: Pixels,
    /// Quantized placement within a device pixel.
    pub subpixel_variant: Point<u8>,
    /// Device pixels per logical pixel.
    pub scale_factor: f32,
}
impl GlyphRasterRequest {
    /// Resolves this request to the ordinary glyph atlas cache key.
    pub fn with_style(self, raster_style: PreparedRasterStyle) -> RenderGlyphParams {
        RenderGlyphParams {
            font_id: self.style.font_id,
            glyph_id: self.style.glyph_id,
            font_size: self.font_size,
            subpixel_variant: self.subpixel_variant,
            scale_factor: self.scale_factor,
            raster_style,
        }
    }
}

/// The kind of glyph image requested from a rasterizer.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum GlyphRenderMode {
    /// A color-independent, one-channel coverage mask.
    Grayscale,
    /// A color-independent, three-channel subpixel coverage mask.
    Subpixel,
    /// A color glyph whose pixels include their final RGB values.
    Color,
}

impl GlyphRenderMode {
    /// Returns the byte format required for this render mode.
    pub const fn rasterized_format(self) -> RasterizedGlyphFormat {
        match self {
            Self::Grayscale => RasterizedGlyphFormat::AlphaMask,
            Self::Subpixel => RasterizedGlyphFormat::BgraSubpixelMask,
            Self::Color => RasterizedGlyphFormat::BgraColor,
        }
    }
}

/// Eight-bit sRGB color stored in a raster cache key when a native raster path needs it.
pub type Rgba8 = palette::Srgba<u8>;

/// Converts a scene color to the bytes used by a raster cache key.
pub trait RasterColorExt {
    /// Clamps each channel to `[0, 1]`, then rounds it to the nearest 8-bit value.
    fn quantize_raster_color(self) -> Rgba8;
}

impl RasterColorExt for crate::Rgba {
    fn quantize_raster_color(self) -> Rgba8 {
        fn channel(value: f32) -> u8 {
            (value.clamp(0.0, 1.0) * 255.0).round() as u8
        }

        Rgba8::new(
            channel(self.red),
            channel(self.green),
            channel(self.blue),
            channel(self.alpha),
        )
    }
}

/// A scene request before a platform rasterizer normalizes its cache-relevant settings.
#[derive(Clone, Copy, Debug, serde::Serialize, serde::Deserialize)]
pub struct RasterStyleRequest {
    /// The canonical font instance containing the glyph.
    pub font_id: FontId,
    /// The glyph whose artwork will be rasterized.
    pub glyph_id: GlyphId,
    /// The exact application color. Rasterizers may only retain a normalized derivative of it.
    #[serde(with = "crate::color::serde_colors::rgba")]
    pub scene_color: crate::Rgba,
    /// The requested kind of glyph image.
    pub requested_mode: GlyphRenderMode,
    /// Which foreground channels can alter the selected artwork.
    pub foreground_dependency: ForegroundDependency,
}

impl RasterStyleRequest {
    /// Quantizes the foreground after removing channels unused by the artwork.
    ///
    /// `AlphaOnly` returns zero RGB channels and the quantized alpha. `Full` retains all four
    /// quantized channels.
    pub fn normalized_color(self) -> Rgba8 {
        let color = self.scene_color.quantize_raster_color();
        if self.foreground_dependency == ForegroundDependency::AlphaOnly {
            return Rgba8::new(0, 0, 0, color.alpha);
        }

        color
    }
}

/// Describes which foreground channels can change rasterized color artwork.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum ForegroundDependency {
    /// The artwork or its fallback may use the complete foreground color.
    Full,
    /// Fixed RGB artwork uses only the foreground alpha.
    AlphaOnly,
}

/// The cache-relevant raster settings chosen by a platform rasterizer.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct PreparedRasterStyle {
    /// The normalized render mode.
    pub mode: GlyphRenderMode,
    /// Any normalized color effect baked into coverage or color pixels.
    pub color_effect: RasterColorEffect,
    /// Which foreground channels can alter this raster or its fallback.
    pub foreground_dependency: ForegroundDependency,
}

impl PreparedRasterStyle {
    /// Creates a style whose raster pixels do not depend on the foreground color.
    pub const fn independent(mode: GlyphRenderMode) -> Self {
        Self {
            mode,
            color_effect: RasterColorEffect::Independent,
            foreground_dependency: ForegroundDependency::Full,
        }
    }

    /// Creates a native preblended style from the request's relevant color channels.
    ///
    /// Foreground channels excluded by `foreground_dependency` are removed before quantization.
    pub fn preblend(request: RasterStyleRequest) -> Self {
        Self {
            mode: request.requested_mode,
            color_effect: RasterColorEffect::Preblend(request.normalized_color()),
            foreground_dependency: request.foreground_dependency,
        }
    }
}

/// The part of the requested color, if any, which changes rasterized pixels.
#[derive(Clone, Copy, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum RasterColorEffect {
    /// Coverage and color pixels do not depend on the scene color.
    Independent,
    /// CoreGraphics' five-level font-smoothing dilation.
    Dilation(u8),
    /// A quantized color consumed by a native preblending or `currentColor` path.
    Preblend(#[serde(with = "crate::color::serde_colors::rgba8")] Rgba8),
}

impl Hash for RasterColorEffect {
    fn hash<H: Hasher>(&self, state: &mut H) {
        core::mem::discriminant(self).hash(state);

        match self {
            Self::Independent => {}
            Self::Dilation(dilation) => dilation.hash(state),
            Self::Preblend(color) => <[u8; 4]>::from(*color).hash(state),
        }
    }
}

/// The byte layout supplied by a glyph rasterizer.
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum RasterizedGlyphFormat {
    /// One byte of coverage per pixel.
    AlphaMask,
    /// Four bytes per pixel in blue, green, red, unused order.
    BgraSubpixelMask,
    /// Four bytes per pixel in blue, green, red, straight-alpha order.
    BgraColor,
}

/// A glyph raster produced by a platform rasterizer.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct RasterizedGlyph {
    /// Placement relative to the glyph's baseline origin.
    pub bounds: Bounds<DevicePixels>,
    /// Pixel dimensions of the supplied buffer.
    pub size: Size<DevicePixels>,
    /// Byte layout of `pixels`.
    pub format: RasterizedGlyphFormat,
    /// Pixel bytes. Color pixels use straight alpha.
    #[serde(with = "serde_bytes")]
    pub pixels: Vec<u8>,
}

impl RasterizedGlyph {
    /// Returns a successful empty glyph in the requested format.
    pub fn empty(format: RasterizedGlyphFormat) -> Self {
        Self {
            bounds: Bounds::default(),
            size: Size::default(),
            format,
            pixels: Vec::new(),
        }
    }

    /// Checks the placement size and byte count promised by `format`.
    ///
    /// Bounds size must equal buffer size; dimensions must be nonnegative. A zero-sized raster
    /// must have both dimensions zero and no bytes. Nonempty masks require one byte per pixel,
    /// while both BGRA formats require four. Returns an error on any mismatch or byte-count
    /// overflow.
    pub fn validate(&self) -> Result<()> {
        anyhow::ensure!(
            self.bounds.size == self.size,
            "glyph raster bounds size {:?} does not match buffer size {:?}",
            self.bounds.size,
            self.size
        );

        let width: usize = self
            .size
            .width
            .0
            .try_into()
            .map_err(|_| anyhow::anyhow!("glyph raster width is negative"))?;

        let height: usize = self
            .size
            .height
            .0
            .try_into()
            .map_err(|_| anyhow::anyhow!("glyph raster height is negative"))?;

        if width == 0 || height == 0 {
            anyhow::ensure!(
                width == 0 && height == 0 && self.pixels.is_empty(),
                "empty glyph raster must have zero size and no pixels"
            );
            return Ok(());
        }

        let bytes_per_pixel = match self.format {
            RasterizedGlyphFormat::AlphaMask => 1,
            RasterizedGlyphFormat::BgraSubpixelMask | RasterizedGlyphFormat::BgraColor => 4,
        };
        let expected_len = width
            .checked_mul(height)
            .and_then(|pixels| pixels.checked_mul(bytes_per_pixel))
            .ok_or_else(|| anyhow::anyhow!("glyph raster byte count overflow"))?;

        anyhow::ensure!(
            self.pixels.len() == expected_len,
            "glyph raster format {:?} requires {expected_len} bytes for {}x{}, got {}",
            self.format,
            width,
            height,
            self.pixels.len()
        );

        Ok(())
    }
}

/// A glyph raster whose placement and pixel buffer have passed validation.
#[derive(Clone, Debug, Deref)]
pub struct ValidatedRasterizedGlyph(RasterizedGlyph);

impl ValidatedRasterizedGlyph {
    /// Validates a glyph raster before it can be used by an atlas builder.
    ///
    /// Returns an error when [`RasterizedGlyph::validate`] rejects its dimensions or buffer.
    pub fn new(glyph: RasterizedGlyph) -> Result<Self> {
        glyph.validate()?;

        Ok(Self(glyph))
    }
}

/// A cached glyph's GPU tile and the placement metadata for its uploaded pixels.
///
/// `tile: None` represents a successfully cached empty glyph, such as a space; it does not mean
/// rasterization failed.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct GlyphAtlasEntry {
    /// The GPU tile, or `None` for a successfully empty glyph.
    pub tile: Option<crate::AtlasTile>,
    /// Placement relative to the glyph's baseline origin.
    pub bounds: Bounds<DevicePixels>,
    /// Byte layout of the cached pixels.
    pub format: RasterizedGlyphFormat,
}

impl Eq for RenderGlyphParams {}

impl Hash for RenderGlyphParams {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.font_id.0.hash(state);
        self.glyph_id.0.hash(state);
        self.font_size.0.to_bits().hash(state);
        self.subpixel_variant.hash(state);
        self.scale_factor.to_bits().hash(state);
        self.raster_style.hash(state);
    }
}

/// A font request used both for font resolution and shaping-cache identity.
///
/// `family` names the preferred family, and weight, width, and style choose a face or variable
/// font instance. `features` passes OpenType feature tags to shaping. `fallbacks` supplies an
/// ordered family list for characters the preferred face cannot draw; backend and system
/// fallbacks may still participate. Font identity in this request does not guarantee that every
/// glyph in a run comes from the same resolved face.
#[derive(Clone, Debug, Eq, PartialEq, Hash, Serialize, Deserialize)]
pub struct Font {
    /// Preferred family name, resolved against the backend's registered and system fonts.
    ///
    /// The special name ".SystemUIFont" is used to identify the system UI font, which varies based on platform.
    pub family: SharedString,

    /// OpenType feature overrides. An empty list retains backend defaults; see [`FontFeatures`].
    pub features: FontFeatures,

    /// Ordered fallback family names consulted when this family lacks a character.
    ///
    /// `None` leaves fallback choice to the backend and platform. A configured list does not
    /// guarantee that a listed family is installed or contains the glyph.
    pub fallbacks: Option<FontFallbacks>,

    /// Requested face weight, with [`FontWeight::NORMAL`] as the default.
    pub weight: FontWeight,

    /// Requested face width or variable-font `wdth` coordinate; see [`FontWidth`].
    pub width: FontWidth,

    /// Requested upright, italic, or oblique face style.
    pub style: FontStyle,
}

impl Default for Font {
    fn default() -> Self {
        font(".SystemUIFont")
    }
}

/// Build a default [`Font`] request for a family name.
///
/// The request uses normal weight, width, and style, no explicit OpenType features, and no
/// caller-provided fallback list. The system UI request is available with [`Font::default`].
pub fn font(family: impl Into<SharedString>) -> Font {
    Font {
        family: family.into(),
        features: FontFeatures::default(),
        weight: FontWeight::default(),
        width: FontWidth::default(),
        style: FontStyle::default(),
        fallbacks: None,
    }
}

impl Font {
    /// Set the requested weight to [`FontWeight::BOLD`].
    pub fn bold(mut self) -> Self {
        self.weight = FontWeight::BOLD;
        self
    }

    /// Set the requested style to [`FontStyle::Italic`].
    pub fn italic(mut self) -> Self {
        self.style = FontStyle::Italic;
        self
    }
}

/// Measurements supplied by one resolved font face.
///
/// Values are in the face's design units. Convert with the helpers, which scale by
/// `font_size / units_per_em`; GPUI layout geometry is in logical [`Pixels`]. A font-wide
/// bounding box is a backend-provided estimate for the face, not a measured string or glyph.
/// Use the shaped layout's width for text that will be painted, or
/// [`TextSystem::typographic_bounds`] for one glyph's bounds.
#[derive(Clone, Copy, Debug, serde::Serialize, serde::Deserialize)]
pub struct FontMetrics {
    /// The number of font units that make up the "em square",
    /// a scalable grid for determining the size of a typeface.
    pub units_per_em: u32,

    /// Typographic distance above the baseline. Individual glyphs can extend beyond it.
    pub ascent: f32,

    /// Typographic distance below the baseline, expressed as a positive magnitude.
    /// Individual glyphs can extend beyond it.
    pub descent: f32,

    /// The recommended additional space to add between lines of type.
    pub line_gap: f32,

    /// Suggested underline offset from the baseline, in font design units.
    ///
    /// Parley preserves the font's upward-growing y axis: a negative value
    /// places the underline below the baseline. The pixel helper scales this
    /// value without reversing its sign. Resolved [`PaintFragment`] offsets
    /// instead use window coordinates, whose y axis grows downward.
    pub underline_position: f32,

    /// The suggested thickness of the underline.
    pub underline_thickness: f32,

    /// The height of a capital letter measured from the baseline of the font.
    pub cap_height: f32,

    /// The height of a lowercase x.
    pub x_height: f32,

    /// Backend-provided estimate of the font's extents, in design units.
    ///
    /// This need not be the OpenType `head` table's bounding box. The Parley backend uses
    /// maximum advance width and typographic height; it does not promise to enclose every
    /// glyph's painted bounds.
    pub bounding_box: Bounds<f32>,
}

impl FontMetrics {
    /// Scales the typographic ascent to logical pixels.
    pub fn ascent(&self, font_size: Pixels) -> Pixels {
        Pixels((self.ascent / self.units_per_em as f32) * font_size.0)
    }

    /// Scales the typographic descent to logical pixels.
    pub fn descent(&self, font_size: Pixels) -> Pixels {
        Pixels((self.descent / self.units_per_em as f32) * font_size.0)
    }

    /// Returns the recommended additional space to add between lines of type in pixels.
    pub fn line_gap(&self, font_size: Pixels) -> Pixels {
        Pixels((self.line_gap / self.units_per_em as f32) * font_size.0)
    }

    /// Scales the suggested underline offset to logical pixels, preserving its sign.
    ///
    /// Parley's font metrics use negative offsets below the baseline. This
    /// does not convert to a downward-growing window offset; use the resolved
    /// [`PaintFragment::underline_offset`] when painting shaped text.
    pub fn underline_position(&self, font_size: Pixels) -> Pixels {
        Pixels((self.underline_position / self.units_per_em as f32) * font_size.0)
    }

    /// Returns the suggested thickness of the underline in pixels.
    pub fn underline_thickness(&self, font_size: Pixels) -> Pixels {
        Pixels((self.underline_thickness / self.units_per_em as f32) * font_size.0)
    }

    /// Returns the height of a capital letter measured from the baseline of the font in pixels.
    pub fn cap_height(&self, font_size: Pixels) -> Pixels {
        Pixels((self.cap_height / self.units_per_em as f32) * font_size.0)
    }

    /// Returns the height of a lowercase x in pixels.
    pub fn x_height(&self, font_size: Pixels) -> Pixels {
        Pixels((self.x_height / self.units_per_em as f32) * font_size.0)
    }

    /// Scales the backend's font-wide bounding-box estimate to logical pixels.
    pub fn bounding_box(&self, font_size: Pixels) -> Bounds<Pixels> {
        (self.bounding_box / self.units_per_em as f32 * font_size.0).map(px)
    }
}

#[cfg(test)]
mod text_range_tests {
    use super::*;

    #[test]
    fn contained_ranges_are_valid_utf8_slices() {
        let text = "aé日";
        #[allow(
            clippy::reversed_empty_ranges,
            reason = "The reversed range is intentional invalid input for contains_range."
        )]
        let cases = [
            ("valid ASCII", 0..1, true),
            ("valid multibyte", 1..3, true),
            ("empty", 1..1, true),
            ("out of bounds", 0..text.len() + 1, false),
            ("reversed", 3..1, false),
            ("split UTF-8 code point", 2..3, false),
        ];

        for (name, range, expected) in cases {
            assert_eq!(text.contains_range(&range), expected, "{name}");
        }
    }
}

#[cfg(test)]
mod layout_cache_tests {
    use super::*;

    fn window_text_system() -> WindowTextSystem {
        WindowTextSystem::new(Arc::new(TextSystem::new(Arc::new(TestTextSystem))))
    }

    #[test]
    fn paint_changes_reuse_shaped_geometry() {
        let system = window_text_system();
        let text = SharedString::from("paint cache");
        let mut run = TextRun {
            len: text.len(),
            color: hsla(0.0, 0.8, 0.4, 1.0),
            ..Default::default()
        };
        let first = system
            .shape_text(text.clone(), px(16.0), &[run.clone()], None, None)
            .unwrap();

        run.color = hsla(0.6, 0.8, 0.4, 1.0);
        run.underline = Some(crate::UnderlineStyle {
            thickness: px(1.5),
            color: None,
            wavy: false,
        });
        let second = system
            .shape_text(text, px(16.0), std::slice::from_ref(&run), None, None)
            .unwrap();

        assert!(Arc::ptr_eq(&first.platform_layout, &second.platform_layout));
        assert_eq!(second.paint_fragments[0].style, PaintStyle::from(&run));
        assert!(second.paint_fragments[0].underline_offset.is_some());
    }

    #[test]
    fn inline_layouts_reuse_all_valid_widths_across_frames() {
        let system = window_text_system();
        let text = "cached inline paragraph";
        let runs = [TextRun {
            len: text.len(),
            ..Default::default()
        }];
        let request = |wrap_width| InlineLayoutRequest {
            text,
            runs: &runs,
            text_styles: &[],
            boxes: &[],
            font_size: px(16.0),
            line_height: px(20.0),
            text_metrics: InlineTextMetrics::default(),
            options: TextLayoutOptions {
                wrap_width: Some(wrap_width),
                text_align: TextAlign::Left,
                ..Default::default()
            },
            bidi_scopes: &[],
        };

        let wide = system.layout_inline(request(px(200.0)));
        let narrow = system.layout_inline(request(px(80.0)));
        assert!(!Arc::ptr_eq(&wide, &narrow));

        let painted_runs = [TextRun {
            color: hsla(0.5, 0.8, 0.4, 1.0),
            ..runs[0].clone()
        }];
        let changed_paint = system.layout_inline(InlineLayoutRequest {
            runs: &painted_runs,
            ..request(px(200.0))
        });
        let changed_size = system.layout_inline(InlineLayoutRequest {
            font_size: px(18.0),
            ..request(px(200.0))
        });
        assert!(!Arc::ptr_eq(&wide, &changed_paint));
        assert!(!Arc::ptr_eq(&wide, &changed_size));
        assert!(Arc::ptr_eq(
            &wide,
            &system.layout_inline(request(px(200.0)))
        ));

        system.finish_frame();
        assert!(Arc::ptr_eq(
            &wide,
            &system.layout_inline(request(px(200.0)))
        ));
        assert!(Arc::ptr_eq(
            &narrow,
            &system.layout_inline(request(px(80.0)))
        ));
    }
}

#[cfg(test)]
mod raster_contract_tests {
    use super::*;

    fn params(style: PreparedRasterStyle) -> RenderGlyphParams {
        RenderGlyphParams {
            font_id: FontId(7),
            glyph_id: GlyphId(42),
            font_size: px(16.0),
            subpixel_variant: point(1, 0),
            scale_factor: 2.0,
            raster_style: style,
        }
    }

    #[test]
    fn raster_buffers_enforce_the_documented_format_contract() {
        let cases = [
            (
                "alpha mask",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: point(DevicePixels(-1), DevicePixels(-2)),
                        size: size(DevicePixels(2), DevicePixels(1)),
                    },
                    size: size(DevicePixels(2), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: vec![0, 255],
                },
                true,
            ),
            (
                "subpixel mask",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: point(DevicePixels(1), DevicePixels(-2)),
                        size: size(DevicePixels(1), DevicePixels(2)),
                    },
                    size: size(DevicePixels(1), DevicePixels(2)),
                    format: RasterizedGlyphFormat::BgraSubpixelMask,
                    pixels: vec![0; 8],
                },
                true,
            ),
            (
                "straight-alpha color",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: point(DevicePixels(0), DevicePixels(-1)),
                        size: size(DevicePixels(1), DevicePixels(1)),
                    },
                    size: size(DevicePixels(1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::BgraColor,
                    pixels: vec![1, 2, 3, 4],
                },
                true,
            ),
            (
                "empty glyph",
                RasterizedGlyph::empty(RasterizedGlyphFormat::AlphaMask),
                true,
            ),
            (
                "wrong alpha stride",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(2), DevicePixels(1)),
                    },
                    size: size(DevicePixels(2), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: vec![0],
                },
                false,
            ),
            (
                "wrong BGRA stride",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(1), DevicePixels(1)),
                    },
                    size: size(DevicePixels(1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::BgraColor,
                    pixels: vec![0; 3],
                },
                false,
            ),
            (
                "partially empty dimensions",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(0), DevicePixels(1)),
                    },
                    size: size(DevicePixels(0), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: Vec::new(),
                },
                false,
            ),
            (
                "negative dimensions",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(-1), DevicePixels(1)),
                    },
                    size: size(DevicePixels(-1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: Vec::new(),
                },
                false,
            ),
            (
                "bounds and buffer size disagree",
                RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(2), DevicePixels(1)),
                    },
                    size: size(DevicePixels(1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: vec![255],
                },
                false,
            ),
        ];

        for (description, raster, valid) in cases {
            assert_eq!(raster.validate().is_ok(), valid, "{description}");
        }
    }

    #[test]
    fn prepared_style_and_format_drive_atlas_keys_without_caching_pixels() {
        let backend = Arc::new(SequencedRasterizer::default());
        let text_system = TextSystem::new(backend.clone());
        let style_a = text_system.prepare_raster_style(
            FontId(7),
            GlyphId(42),
            hsla(0.0, 0.0, 0.20, 1.0),
            GlyphRenderMode::Grayscale,
        );
        let style_b = text_system.prepare_raster_style(
            FontId(7),
            GlyphId(42),
            hsla(0.0, 0.0, 0.24, 1.0),
            GlyphRenderMode::Grayscale,
        );
        let style_c = text_system.prepare_raster_style(
            FontId(7),
            GlyphId(42),
            hsla(0.0, 0.0, 0.30, 1.0),
            GlyphRenderMode::Grayscale,
        );
        assert_eq!(style_a, style_b, "nearby scene colors share a mask style");
        assert_ne!(
            style_a, style_c,
            "different dilation levels need distinct rasters"
        );

        let first = params(style_a);
        let second = params(style_b);
        let third = params(style_c);
        assert_eq!(first, second);
        let first_raster = text_system.rasterize_glyph(&first).unwrap();
        let reused_raster = text_system.rasterize_glyph(&second).unwrap();
        let distinct_raster = text_system.rasterize_glyph(&third).unwrap();
        assert_eq!(first_raster.pixels, reused_raster.pixels);
        assert_eq!(first_raster.pixels, distinct_raster.pixels);
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 3);
        for (format, expected) in [
            (
                RasterizedGlyphFormat::AlphaMask,
                AtlasTextureKind::Monochrome,
            ),
            (
                RasterizedGlyphFormat::BgraSubpixelMask,
                AtlasTextureKind::Subpixel,
            ),
            (
                RasterizedGlyphFormat::BgraColor,
                AtlasTextureKind::Polychrome,
            ),
        ] {
            assert_eq!(
                AtlasKey::from((first.clone(), format)).texture_kind(),
                expected
            );
        }
    }

    #[test]
    fn atlas_entries_own_their_raster_metadata_and_retry_failures() {
        let backend = Arc::new(SequencedRasterizer {
            attempts: AtomicUsize::new(0),
            fail_until_valid: true,
        });
        let text_system = TextSystem::new(backend.clone());
        let params = params(PreparedRasterStyle::independent(GlyphRenderMode::Grayscale));
        let atlas = TestAtlas::new();

        assert!(
            atlas
                .get_or_insert_glyph_with(&params, &mut || { text_system.rasterize_glyph(&params) })
                .is_err()
        );
        assert!(
            atlas
                .get_or_insert_glyph_with(&params, &mut || { text_system.rasterize_glyph(&params) })
                .is_err()
        );
        let first_success = atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        let second_success = atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();

        assert_eq!(first_success, second_success);
        assert_eq!(
            first_success.bounds.size,
            size(DevicePixels(1), DevicePixels(1))
        );
        assert_eq!(first_success.format, RasterizedGlyphFormat::AlphaMask);
        assert!(first_success.tile.is_some());
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 3);

        atlas.clear();
        atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 4);
    }

    #[test]
    fn separate_atlases_keep_the_metadata_for_their_own_pixels() {
        let backend = Arc::new(ChangingRasterizer::default());
        let text_system = TextSystem::new(backend.clone());
        let params = params(PreparedRasterStyle::independent(GlyphRenderMode::Color));
        let first_atlas = TestAtlas::new();
        let second_atlas = TestAtlas::new();

        let silhouette = first_atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        let silhouette_hit = first_atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        assert_eq!(silhouette_hit, silhouette);
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 1);

        let color = second_atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        assert_ne!(color.bounds, silhouette.bounds);
        assert_ne!(color.format, silhouette.format);
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 2);

        let original = first_atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        assert_eq!(original, silhouette);
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 2);

        first_atlas.clear();
        let recovered = first_atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))
            .unwrap();
        assert_ne!(recovered.bounds, silhouette.bounds);
        assert_eq!(recovered.format, RasterizedGlyphFormat::BgraColor);
        assert_eq!(backend.attempts.load(Ordering::SeqCst), 3);
    }

    #[test]
    fn successful_empty_glyphs_are_cached_without_a_tile() {
        let atlas = TestAtlas::new();
        let params = params(PreparedRasterStyle::independent(GlyphRenderMode::Grayscale));
        let mut builds = 0;
        let mut build = || {
            builds += 1;

            ValidatedRasterizedGlyph::new(RasterizedGlyph::empty(RasterizedGlyphFormat::AlphaMask))
        };

        let first = atlas.get_or_insert_glyph_with(&params, &mut build).unwrap();
        let second = atlas.get_or_insert_glyph_with(&params, &mut build).unwrap();
        assert_eq!(first, second);
        assert!(first.tile.is_none());
        assert_eq!(builds, 1);
    }

    #[test]
    fn custom_glyph_builders_validate_before_caching() {
        let atlas = TestAtlas::new();
        let params = params(PreparedRasterStyle::independent(GlyphRenderMode::Grayscale));
        let mut builds = 0;
        let mut build = || {
            builds += 1;
            let size = size(DevicePixels(1), DevicePixels(1));
            let pixels = if builds == 1 { Vec::new() } else { vec![255] };

            ValidatedRasterizedGlyph::new(RasterizedGlyph {
                bounds: Bounds {
                    origin: Point::default(),
                    size,
                },
                size,
                format: RasterizedGlyphFormat::AlphaMask,
                pixels,
            })
        };

        assert!(atlas.get_or_insert_glyph_with(&params, &mut build).is_err());

        let first = atlas.get_or_insert_glyph_with(&params, &mut build).unwrap();
        let second = atlas.get_or_insert_glyph_with(&params, &mut build).unwrap();
        assert_eq!(first, second);
        assert!(first.tile.is_some());
        assert_eq!(builds, 2);
    }

    #[derive(Default)]
    struct ChangingRasterizer {
        attempts: AtomicUsize,
    }

    impl PlatformTextSystem for ChangingRasterizer {
        fn add_fonts(&self, _fonts: Vec<Cow<'static, [u8]>>) -> Result<()> {
            Ok(())
        }

        fn all_font_names(&self) -> Vec<String> {
            Vec::new()
        }

        fn font_id(&self, descriptor: &Font) -> Result<FontId> {
            PlatformTextSystem::font_id(&TestTextSystem, descriptor)
        }

        fn font_metrics(&self, font_id: FontId) -> FontMetrics {
            PlatformTextSystem::font_metrics(&TestTextSystem, font_id)
        }

        fn typographic_bounds(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Bounds<f32>> {
            PlatformTextSystem::typographic_bounds(&TestTextSystem, font_id, glyph_id)
        }

        fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>> {
            PlatformTextSystem::advance(&TestTextSystem, font_id, glyph_id)
        }

        fn glyph_for_char(&self, font_id: FontId, character: char) -> Option<GlyphId> {
            PlatformTextSystem::glyph_for_char(&TestTextSystem, font_id, character)
        }

        fn rasterize_glyph(&self, _params: &RenderGlyphParams) -> Result<RasterizedGlyph> {
            let attempt = self.attempts.fetch_add(1, Ordering::SeqCst);
            let (origin, size, format) = match attempt {
                0 => (
                    point(DevicePixels(-2), DevicePixels(-7)),
                    size(DevicePixels(2), DevicePixels(3)),
                    RasterizedGlyphFormat::AlphaMask,
                ),
                1 => (
                    point(DevicePixels(1), DevicePixels(-9)),
                    size(DevicePixels(4), DevicePixels(5)),
                    RasterizedGlyphFormat::BgraColor,
                ),
                _ => (
                    point(DevicePixels(3), DevicePixels(-8)),
                    size(DevicePixels(3), DevicePixels(4)),
                    RasterizedGlyphFormat::BgraColor,
                ),
            };
            let bytes_per_pixel = if format == RasterizedGlyphFormat::AlphaMask {
                1
            } else {
                4
            };

            Ok(RasterizedGlyph {
                bounds: Bounds { origin, size },
                size,
                format,
                pixels: vec![
                    0x7f;
                    size.width.0 as usize * size.height.0 as usize * bytes_per_pixel
                ],
            })
        }

        fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout {
            PlatformTextSystem::layout_text(&TestTextSystem, request)
        }

        fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout {
            PlatformTextSystem::layout_inline(&TestTextSystem, request)
        }
    }

    #[derive(Default)]
    struct SequencedRasterizer {
        attempts: AtomicUsize,
        fail_until_valid: bool,
    }

    impl PlatformTextSystem for SequencedRasterizer {
        fn add_fonts(&self, _fonts: Vec<Cow<'static, [u8]>>) -> Result<()> {
            Ok(())
        }

        fn all_font_names(&self) -> Vec<String> {
            Vec::new()
        }

        fn font_id(&self, descriptor: &Font) -> Result<FontId> {
            PlatformTextSystem::font_id(&TestTextSystem, descriptor)
        }

        fn font_metrics(&self, font_id: FontId) -> FontMetrics {
            PlatformTextSystem::font_metrics(&TestTextSystem, font_id)
        }

        fn typographic_bounds(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Bounds<f32>> {
            PlatformTextSystem::typographic_bounds(&TestTextSystem, font_id, glyph_id)
        }

        fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>> {
            PlatformTextSystem::advance(&TestTextSystem, font_id, glyph_id)
        }

        fn glyph_for_char(&self, font_id: FontId, character: char) -> Option<GlyphId> {
            PlatformTextSystem::glyph_for_char(&TestTextSystem, font_id, character)
        }

        fn rasterize_glyph(&self, _params: &RenderGlyphParams) -> Result<RasterizedGlyph> {
            let attempt = self.attempts.fetch_add(1, Ordering::SeqCst);
            if !self.fail_until_valid {
                return Ok(RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(1), DevicePixels(1)),
                    },
                    size: size(DevicePixels(1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: vec![0x7f],
                });
            }
            match attempt {
                0 => Err(anyhow!("transient native failure")),
                1 => Ok(RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(1), DevicePixels(1)),
                    },
                    size: size(DevicePixels(1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: Vec::new(),
                }),
                _ => Ok(RasterizedGlyph {
                    bounds: Bounds {
                        origin: Point::default(),
                        size: size(DevicePixels(1), DevicePixels(1)),
                    },
                    size: size(DevicePixels(1), DevicePixels(1)),
                    format: RasterizedGlyphFormat::AlphaMask,
                    pixels: vec![0x7f],
                }),
            }
        }

        fn prepare_raster_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
            PreparedRasterStyle {
                mode: request.requested_mode,
                color_effect: RasterColorEffect::Dilation(
                    (request.scene_color.red * 4.0).floor() as u8
                ),
                foreground_dependency: request.foreground_dependency,
            }
        }

        fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout {
            PlatformTextSystem::layout_text(&TestTextSystem, request)
        }

        fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout {
            PlatformTextSystem::layout_inline(&TestTextSystem, request)
        }
    }
}
