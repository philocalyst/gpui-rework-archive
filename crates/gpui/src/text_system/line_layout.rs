use crate::{
    Bounds, FontId, GlyphId, InlineBidiScope, InlineBoxRequest, InlineLayoutRequest,
    InlineTextStyle, Pixels, PlatformTextSystem, Point, SharedString, Size, StrikethroughStyle,
    TextLayoutOptions, TextLayoutRequest, TextRun, UnderlineStyle, VerticalAlign,
};
use collections::FxHashMap;
use palette::Hsla;
use parking_lot::{Mutex, RwLock, RwLockUpgradableReadGuard};
use smallvec::SmallVec;
use std::{
    borrow::Borrow,
    hash::{Hash, Hasher},
    ops::Range,
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
};

/// Resolved glyph fragments and interaction geometry for a text document.
///
/// One document can contain several [`VisualLine`] rows after hard breaks or
/// wrapping. Each row selects a range of [`PaintFragment`] values; each fragment
/// supplies a resolved font, glyph positions, and paint properties. The
/// [`platform_layout`](Self::platform_layout) describes pointer hits, carets,
/// and selection for the same source and line breaks.
///
/// [`WindowTextSystem::layout_line`](crate::WindowTextSystem::layout_line) returns
/// this record for unwrapped measurement. For application drawing, usually keep
/// the [`ShapedLine`](crate::ShapedLine) or [`ShapedText`](crate::ShapedText)
/// returned by the window's shaping methods: those wrappers pair the record
/// with its source and provide paint methods. A backend implements
/// [`PlatformTextSystem::layout_text`] to produce the record itself.
///
/// Treat the fields as one shaping result. Editing a row, glyph, or length does
/// not update the backend's interaction geometry. Shape the new source again
/// when its contents, font request, or wrapping constraint changes. Widths are
/// advances in logical pixels, rather than bounds around visible ink; the
/// [text chapter](crate::_documentation::text) explains that distinction.
#[derive(Clone, Debug)]
pub struct LineLayout {
    /// Base font size requested for the document, in logical pixels.
    pub font_size: Pixels,
    /// Advance width of the widest visual row, before external alignment placement.
    pub width: Pixels,
    /// Maximum ascent used by the document layout, in logical pixels.
    pub ascent: Pixels,
    /// Maximum descent used by the document layout, in logical pixels.
    pub descent: Pixels,
    /// Rows in paint order. A soft-wrapped source line can occupy several rows.
    pub visual_lines: SmallVec<[VisualLine; 1]>,
    /// Positioned glyph fragments referenced by each row's `paint_fragment_range`.
    pub paint_fragments: Vec<PaintFragment>,
    /// The length of the source text in UTF-8 bytes.
    pub len: usize,
    /// Backend-native hit testing, caret movement, and selection geometry for this same text.
    pub platform_layout: Arc<dyn PlatformTextLayout>,
}

/// Logical-pixel font metrics used to align text and embedded boxes in a row.
///
/// Pass these as the fallback metrics in [`InlineLayoutRequest`] or to
/// [`align_inline_boxes`]. Ascent and descent measure outward from the baseline;
/// x-height supplies the reference for [`VerticalAlign::Middle`]. These are
/// already scaled lengths, unlike the design-unit fields of [`crate::FontMetrics`].
#[derive(
    Clone, Copy, Debug, Default, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize,
)]
pub struct InlineTextMetrics {
    /// Logical-pixel distance above the text baseline.
    pub ascent: Pixels,
    /// Logical-pixel distance below the text baseline.
    pub descent: Pixels,
    /// Logical-pixel x-height used when aligning inline boxes.
    pub x_height: Pixels,
}

/// The origin, size, and baseline assigned to one inline row.
///
/// [`InlineLayout::lines`] follows [`LineLayout::visual_lines`] in paint order.
/// Rows can have different heights when an embedded box or a larger font expands
/// them. Use each row's origin and baseline for placement rather than deriving
/// all positions from a single line height.
#[derive(Clone, Copy, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct InlineVisualLine {
    /// The row's top-left relative to the complete inline layout, in logical pixels.
    pub origin: Point<Pixels>,
    /// The row's advance width and allocated height, in logical pixels.
    pub size: Size<Pixels>,
    /// Distance from the row's top to its text baseline, in logical pixels.
    pub baseline: Pixels,
}

/// The layout position assigned to an atomic element box embedded in text.
///
/// The ID identifies an [`InlineBoxRequest`]; it is not an element identity or
/// a byte offset. The containing element uses this record to place and paint
/// that child. Text layout reserves the box's space but does not paint its
/// contents or register its input handlers.
#[derive(Clone, Copy, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct PositionedInlineBox {
    /// The caller-provided [`InlineBoxRequest::id`].
    pub id: u64,
    /// Index into [`InlineLayout::lines`] of the row containing this box.
    pub line_index: usize,
    /// The box bounds relative to the complete inline layout, in logical pixels.
    pub bounds: Bounds<Pixels>,
}

/// One visual region occupied by a logical text range in an inline layout.
///
/// [`PlatformTextLayout::inline_geometry`] can return several regions for one
/// range because wrapping or bidirectional ordering separates its contents.
/// Keep the regions separate for hit testing; their union can include gaps
/// that do not belong to the text. The geometry is relative to the text layout,
/// so add its placed origin before using it in a window paint method.
#[derive(Clone, Copy, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct InlineRangeGeometry {
    /// Bounds relative to the complete text layout, in logical pixels.
    pub bounds: Bounds<Pixels>,
    /// Index of the visual row containing these bounds.
    pub visual_line_index: usize,
}

/// Text and atomic element boxes laid out together in a paragraph.
///
/// Obtain it from [`WindowTextSystem::layout_inline`](crate::WindowTextSystem::layout_inline)
/// with an [`InlineLayoutRequest`]. It owns the resolved geometry, so the
/// request's borrowed source and style slices can go out of scope. A block
/// [`Div`](crate::Div) uses this mechanism to wrap text around inline children;
/// ordinary application views can let the div manage placement and painting.
///
/// For a custom paragraph, [`layout`](Self::layout) supplies glyph fragments,
/// [`lines`](Self::lines) supplies the rows' baselines and heights, and
/// [`boxes`](Self::boxes) supplies child positions. These coordinates are in
/// logical pixels relative to the paragraph, before placement in the window.
/// The box records reserve space; the caller still owns each child's element
/// lifecycle. See the [text chapter](crate::_documentation::text#wrap-text-and-element-boxes-in-one-paragraph)
/// for how inline boxes differ from independent flex items.
#[derive(Clone, Debug)]
pub struct InlineLayout {
    /// The shaped text shared with the ordinary GPUI glyph-paint pipeline.
    pub layout: Arc<LineLayout>,
    /// Per-row block geometry, including the adjusted baseline and height.
    pub lines: Vec<InlineVisualLine>,
    /// Positioned element boxes. Layout computes these bounds but does not paint their contents.
    pub boxes: Vec<PositionedInlineBox>,
    /// Horizontal adjustment used to pixel-snap the common anchor for every visual line.
    pub alignment_offset: Pixels,
    /// Natural logical-pixel size of text and inline boxes together.
    pub size: Size<Pixels>,
}

fn base_inline_line_bounds(metrics: InlineTextMetrics, line_height: Pixels) -> (Pixels, Pixels) {
    let half_leading = ((line_height - metrics.ascent - metrics.descent) / 2.).max(Pixels::ZERO);

    (
        -metrics.ascent - half_leading,
        metrics.descent + half_leading,
    )
}

fn expand_inline_line_for_box(
    top: &mut Pixels,
    bottom: &mut Pixels,
    top_box_height: &mut Pixels,
    bottom_box_height: &mut Pixels,
    height: Pixels,
    metrics: InlineTextMetrics,
    align: VerticalAlign,
) {
    match align {
        VerticalAlign::Baseline => *top = (*top).min(-height),
        VerticalAlign::Middle => {
            let middle = -metrics.x_height / 2.;
            *top = (*top).min(middle - height / 2.);
            *bottom = (*bottom).max(middle + height / 2.);
        }
        VerticalAlign::Top => *top_box_height = (*top_box_height).max(height),
        VerticalAlign::Bottom => *bottom_box_height = (*bottom_box_height).max(height),
    }
}

fn aligned_inline_box_y(
    line: InlineVisualLine,
    metrics: InlineTextMetrics,
    height: Pixels,
    align: VerticalAlign,
) -> Pixels {
    match align {
        VerticalAlign::Baseline => line.baseline - height,
        VerticalAlign::Middle => line.baseline - metrics.x_height / 2. - height / 2.,
        VerticalAlign::Top => Pixels::ZERO,
        VerticalAlign::Bottom => line.size.height - height,
    }
}

/// Applies CSS-like vertical alignment and recomputes row heights after backend layout.
///
/// `requests` maps box IDs to vertical alignment. A box with no matching request uses baseline
/// alignment. `line_metrics` and `text_bounds` are per-row values; missing entries use
/// `fallback_metrics` and the supplied `line_height`. Boxes assigned to nonexistent rows are
/// ignored. The function updates each row's vertical origin, height, and baseline, each accepted
/// box's vertical origin, and `size.height`; horizontal geometry is left unchanged.
pub fn align_inline_boxes(
    lines: &mut [InlineVisualLine],
    boxes: &mut [PositionedInlineBox],
    size: &mut Size<Pixels>,
    requests: &[InlineBoxRequest],
    line_metrics: &[InlineTextMetrics],
    text_bounds: &[(Pixels, Pixels)],
    fallback_metrics: InlineTextMetrics,
    line_height: Pixels,
) {
    let request_alignments = requests
        .iter()
        .map(|request| (request.id, request.vertical_align))
        .collect::<FxHashMap<_, _>>();
    let mut boxes_by_line: FxHashMap<_, Vec<_>> = FxHashMap::default();

    for inline_box in boxes
        .iter_mut()
        .filter(|inline_box| inline_box.line_index < lines.len())
    {
        let align = request_alignments
            .get(&inline_box.id)
            .copied()
            .unwrap_or(VerticalAlign::Baseline);

        boxes_by_line
            .entry(inline_box.line_index)
            .or_default()
            .push((inline_box, align));
    }

    let mut line_y = Pixels::ZERO;

    for (line_index, line) in lines.iter_mut().enumerate() {
        let line_boxes = boxes_by_line.remove(&line_index).unwrap_or_default();
        let metrics = line_metrics
            .get(line_index)
            .copied()
            .unwrap_or(fallback_metrics);
        let (mut top, mut bottom) = text_bounds
            .get(line_index)
            .copied()
            .unwrap_or_else(|| base_inline_line_bounds(metrics, line_height));
        let mut top_box_height = Pixels::ZERO;
        let mut bottom_box_height = Pixels::ZERO;

        for (inline_box, align) in &line_boxes {
            expand_inline_line_for_box(
                &mut top,
                &mut bottom,
                &mut top_box_height,
                &mut bottom_box_height,
                inline_box.bounds.size.height,
                metrics,
                *align,
            );
        }

        bottom = bottom.max(top + top_box_height);
        top = top.min(bottom - bottom_box_height);
        line.origin.y = line_y;
        line.size.height = bottom - top;
        line.baseline = -top;

        for (inline_box, align) in line_boxes {
            inline_box.bounds.origin.y =
                line_y + aligned_inline_box_y(*line, metrics, inline_box.bounds.size.height, align);
        }

        line_y += line.size.height;
    }

    size.height = line_y;
}

/// Backend-owned text interaction for a laid-out string.
///
/// Byte positions are UTF-8 boundaries. Geometry is in GPUI layout coordinates, using the
/// caller-provided line height. Implementations must preserve visual order and caret affinity.
///
/// A shaping-cluster hit, a caret stop, and a logical editing range need not
/// have the same boundaries. Use [`Self::byte_index_from_pixel_point`] to
/// identify shaped text under a pointer, and the caret operations for movement.
/// Do not assume that movement visits every index returned by hit testing.
/// The backend defines the ranges returned by [`Self::logical_cluster_before`]
/// and [`Self::logical_cluster_after`]; Parley uses grapheme clusters for those
/// logical ranges, independently of visual direction and soft-wrapped rows.
pub trait PlatformTextLayout: Send + Sync + std::fmt::Debug {
    /// Length of the source text in UTF-8 bytes.
    fn len(&self) -> usize;

    /// Number of visual lines.
    fn line_count(&self) -> usize;

    /// Natural layout size reported by the backend.
    fn size(&self) -> Size<Pixels>;

    /// Returns the UTF-8 byte index of the cluster under a point in GPUI layout coordinates.
    ///
    /// The result is a logical source position even when the point falls in right-to-left text.
    /// Implementations use `Ok` for a point on a visual row and `Err` for the closest logical
    /// boundary at a point outside the row.
    fn byte_index_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<usize, usize>;

    /// Returns the closest affinity-aware caret for a point in GPUI layout coordinates.
    ///
    /// `Ok` means the point lies on a visual row; a point outside a row returns `Err` containing
    /// the caret at the closest visual edge. The caret index is a UTF-8 byte boundary.
    fn caret_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<CaretPosition, CaretPosition>;

    /// Returns the caret bounds in GPUI layout coordinates, if `caret` is representable.
    ///
    /// `line_height` supplies the row height used to place the caret; it need not equal the
    /// backend's natural line height.
    fn caret_bounds(&self, caret: CaretPosition, line_height: Pixels) -> Option<Bounds<Pixels>>;

    /// Snaps a caret to a native cluster boundary.
    fn normalized_caret(&self, caret: CaretPosition) -> CaretPosition;

    /// Finds the adjacent legal caret stop to the visual left or right.
    ///
    /// Returns `None` at that outer edge, or when the backend cannot produce a
    /// neighboring stop. The returned [`CaretPosition`] keeps affinity: at a
    /// soft wrap, another visual position can have the same byte index and a
    /// different affinity. Do not require the index to increase when moving
    /// right through bidirectional text.
    ///
    /// Use [`Self::logical_cluster_before`] or [`Self::logical_cluster_after`]
    /// for source-order editing ranges. Use [`ShapedTextLayout::selection_movement`] when
    /// arrow-key behavior also needs to collapse or extend a selection.
    fn adjacent_visual_caret(
        &self,
        caret: CaretPosition,
        direction: VisualDirection,
    ) -> Option<CaretPosition>;

    /// Returns selection rectangles for a UTF-8 byte range in visual order.
    ///
    /// The range is in logical source order and may produce several rectangles when it crosses
    /// visual rows or bidirectional runs. Backends may extend rectangles to paint selection
    /// whitespace. Backends can override [`Self::inline_geometry`] to provide text-only bounds.
    fn selection_bounds(
        &self,
        byte_range: Range<usize>,
        line_height: Pixels,
    ) -> Vec<Bounds<Pixels>>;

    /// Range rectangles and their visual line indices.
    ///
    /// The default delegates to [`Self::selection_bounds`] using the average row height. It
    /// inherits any selection extensions and estimates row indices from rectangle origins.
    /// Backends supporting inline flow should override it with native text-only geometry and
    /// actual row metrics.
    ///
    /// Returns `None` for an empty range. A nonempty range can produce an empty vector when it
    /// has no drawable geometry.
    fn inline_geometry(&self, range: Range<usize>) -> Option<Vec<InlineRangeGeometry>> {
        if range.is_empty() {
            return None;
        }

        let line_height = self.size().height / self.line_count().max(1) as f32;

        Some(
            self.selection_bounds(range, line_height)
                .into_iter()
                .map(|bounds| InlineRangeGeometry {
                    visual_line_index: (bounds.origin.y / line_height) as usize,
                    bounds,
                })
                .collect(),
        )
    }

    /// Returns native geometry for each input range, preserving input order.
    ///
    /// An empty range or a range with no drawable geometry produces an empty inner vector.
    fn inline_geometry_for_ranges(&self, ranges: &[Range<usize>]) -> Vec<Vec<InlineRangeGeometry>> {
        ranges
            .iter()
            .map(|range| self.inline_geometry(range.clone()).unwrap_or_default())
            .collect()
    }

    /// Returns the atomic logical cluster immediately before the caret in source order.
    fn logical_cluster_before(&self, caret: CaretPosition) -> Option<Range<usize>>;

    /// Returns the atomic logical cluster immediately after the caret in source order.
    fn logical_cluster_after(&self, caret: CaretPosition) -> Option<Range<usize>>;

    /// Returns the caret and retained horizontal coordinate after applying a movement.
    ///
    /// The coordinate is useful for consecutive up/down moves. Pass the returned value into the
    /// next vertical movement; horizontal or boundary movement may clear it.
    fn caret_movement(
        &self,
        caret: CaretPosition,
        movement: TextMovement,
        vertical_navigation_x: Option<Pixels>,
    ) -> CaretMovement;

    /// Returns a word, visual row, or hard line selected at a point in GPUI layout coordinates.
    ///
    /// The returned range uses UTF-8 bytes and logical source order.
    fn selection_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
        kind: TextSelectionKind,
    ) -> Range<usize>;
}

/// A direction in visual, rather than logical, text order.
#[derive(Clone, Copy, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum VisualDirection {
    /// Move toward the visual left.
    Left,
    /// Move toward the visual right.
    Right,
}

/// The direction of a semantic text movement.
///
/// Pair it with a [`TextBoundary`] through [`Self::with_boundary`]. Left and
/// right follow visual order. Start and end select the logical edges of the
/// requested row, hard line, or document; the logical start of a right-to-left
/// row can be on its visual right. See [`TextMovement`] for supported pairs.
#[derive(Clone, Copy, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum TextDirection {
    /// Move toward the visual left.
    Left,
    /// Move toward the visual right.
    Right,
    /// Move to the visual row above.
    Up,
    /// Move to the visual row below.
    Down,
    /// Move to the logical start of the requested line or document.
    Start,
    /// Move to the logical end of the requested line or document.
    End,
}

/// The boundary at which a semantic text movement stops.
#[derive(Clone, Copy, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum TextBoundary {
    /// One backend-defined caret step. [`PlatformTextLayout::normalized_caret`] and
    /// [`PlatformTextLayout::adjacent_visual_caret`] govern visual stops, while
    /// [`PlatformTextLayout::logical_cluster_before`] and
    /// [`PlatformTextLayout::logical_cluster_after`] return logical ranges.
    /// [`PlatformTextSystem::layout_text`] provides [`LineLayout::platform_layout`].
    /// Platform constructors use `gpui_ce_parley`, whose logical ranges are graphemes and
    /// visual movement follows Parley cursors. Other backends may differ.
    Cluster,
    /// A word boundary.
    Word,
    /// One visual row produced by line breaking, including soft wrapping.
    VisualLine,
    /// A source line delimited by a hard paragraph separator.
    ///
    /// Soft wrapping does not create another hard line. See
    /// [`is_paragraph_separator`] for recognized separators; CRLF is one break.
    HardLine,
    /// The complete text document.
    Document,
}

/// A direction and unit for moving a caret or extending a selection.
///
/// Use [`caret_movement`](ShapedTextLayout::caret_movement) to move the caret.
/// Use [`selection_movement`](ShapedTextLayout::selection_movement) to keep or
/// collapse a selection's anchor as well. The supplied Parley backend supports
/// these combinations:
///
/// | Operation | [Direction](TextDirection) | [Boundary](TextBoundary) |
/// | --- | --- | --- |
/// | Editing stop | Left / Right | [Cluster](TextBoundary::Cluster) |
/// | Word boundary | Left / Right | [Word](TextBoundary::Word) |
/// | Other row | Up / Down | [VisualLine](TextBoundary::VisualLine) |
/// | Wrapped row edge | Start / End | [VisualLine](TextBoundary::VisualLine) |
/// | Source line edge | Start / End | [HardLine](TextBoundary::HardLine) |
/// | Document edge | Start / End | [Document](TextBoundary::Document) |
///
/// Construct a pair with [`TextDirection::with_boundary`], for example
/// `TextDirection::Down.with_boundary(TextBoundary::VisualLine)`. Construction
/// does not validate the pair. Parley normalizes the caret but performs no
/// movement for unsupported combinations; a custom [`PlatformTextLayout`]
/// defines its own behavior.
///
/// Carry the returned [`CaretMovement::vertical_navigation_x`] into consecutive
/// up/down moves. It remembers the intended horizontal position when an
/// intervening row is shorter. Store the returned value after every movement,
/// including horizontal and boundary moves, so an old column does not leak
/// into the next vertical sequence. Layout computes these positions; the
/// editor still owns its caret, selection, and text buffer.
#[derive(Clone, Copy, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct TextMovement {
    /// The direction in which to move.
    pub direction: TextDirection,
    /// The boundary at which to stop.
    pub boundary: TextBoundary,
}

impl TextDirection {
    /// Creates a semantic movement in this direction with the requested boundary.
    pub const fn with_boundary(self, boundary: TextBoundary) -> TextMovement {
        TextMovement {
            direction: self,
            boundary,
        }
    }
}

/// A semantic selection derived from a point.
#[derive(Clone, Copy, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum TextSelectionKind {
    /// Select a word.
    Word,
    /// Select a soft-wrapped visual row.
    VisualLine,
    /// Select a line delimited by a hard break.
    HardLine,
}

/// One visual row produced by shaping and line breaking.
///
/// A logical source line can occupy several rows after wrapping. This record
/// connects a logical UTF-8 source range to the fragments painted on that row.
/// Bidirectional text can put fragments in a different order from their source
/// bytes. Use [`PlatformTextLayout`] or [`ShapedTextLayout`] for pointer and caret
/// queries rather than interpolating a byte position across the advance width.
#[derive(Clone, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct VisualLine {
    /// The logical UTF-8 byte range assigned to this row in the shaped source.
    ///
    /// This is a source range, not a count of characters or glyphs. Do not use
    /// its order to infer left-to-right movement within bidirectional text.
    pub text_range: Range<usize>,
    /// Indices into [`LineLayout::paint_fragments`] for the positioned glyph runs
    /// painted on this row, ordered by visual position.
    pub paint_fragment_range: Range<usize>,
    /// Horizontal distance consumed by the row's shaped content before alignment,
    /// measured to the backend's final text pen position. Inline layouts include
    /// advances from embedded boxes.
    pub advance_width: Pixels,
    /// Horizontal offset assigned by backend layout, in logical pixels.
    ///
    /// Paint placement adds this to the row's requested origin and alignment.
    pub offset: Pixels,
    /// Base direction used to order and align this visual line.
    pub direction: crate::ResolvedDirection,
}

/// Colors and decorations attached to a resolved glyph fragment.
///
/// [`PaintFragment::style`] carries the properties selected from a [`TextRun`]
/// through backend shaping. This record does not select a font or shape text.
/// When using [`ShapedText`](crate::ShapedText), paint run backgrounds before
/// foreground glyphs and decorations so a later background does not cover
/// earlier text.
#[derive(Clone, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct PaintStyle {
    /// Glyph foreground color.
    #[serde(with = "crate::color::serde_colors::hsla")]
    pub color: Hsla,
    /// Optional run background color, painted separately from foreground glyphs.
    #[serde(with = "crate::color::serde_colors::optional_hsla")]
    pub background_color: Option<Hsla>,
    /// Optional underline style.
    pub underline: Option<UnderlineStyle>,
    /// Optional strikethrough style.
    pub strikethrough: Option<StrikethroughStyle>,
}

/// A resolved font and paint style for glyphs on one visual row.
///
/// [`VisualLine::paint_fragment_range`] selects these records from
/// [`LineLayout::paint_fragments`]. One input [`TextRun`] can produce several
/// fragments through wrapping or font fallback; its index does not identify
/// a unique fragment. Glyph IDs belong to the fragment's resolved [`FontId`].
///
/// Glyph x positions are relative to the visual row, and y positions are
/// relative to its baseline. They are not relative to the fragment's
/// [`x_range`](Self::x_range). Usually let [`ShapedLine`](crate::ShapedLine) or
/// [`ShapedText`](crate::ShapedText) paint these records so baseline placement,
/// rasterization, and atlas allocation stay together.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct PaintFragment {
    /// Index of the input text run that supplies paint properties.
    pub source_run: usize,
    /// Resolved font instance used by the glyphs, including fallback selection.
    pub font_id: FontId,
    /// Resolved size of this shaped run, in logical pixels.
    pub font_size: Pixels,
    /// Positioned glyphs, with row-relative x and baseline-relative y coordinates.
    pub glyphs: Arc<[ShapedGlyph]>,
    /// The fragment's horizontal advance range in visual-row coordinates.
    ///
    /// This includes spacing and is not a tight bound around visible ink.
    pub x_range: Range<Pixels>,
    /// Paint properties shared by every glyph in the fragment.
    pub style: PaintStyle,
    /// Resolved underline offset from the baseline.
    pub underline_offset: Option<Pixels>,
    /// Resolved strikethrough offset from the baseline.
    pub strikethrough_offset: Option<Pixels>,
}

/// One positioned glyph selected by shaping.
///
/// The containing [`PaintFragment`] supplies its font, size, and color. A glyph
/// ID is meaningful only with that font; it is not a Unicode scalar or a source
/// byte index. Shaping can map several source characters to one glyph or one
/// character to several glyphs, so these records are unsuitable for counting
/// characters or defining an editor's selection boundaries.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct ShapedGlyph {
    /// Backend font glyph ID; it is not a source-text index.
    pub id: GlyphId,

    /// Logical-pixel position with x relative to the row and y relative to its baseline.
    ///
    /// Add the placed row origin to x and the placed baseline to y before painting.
    pub position: Point<Pixels>,

    /// Whether painting should use the color-emoji rasterization path.
    pub is_emoji: bool,
}

/// Determines which logical neighbor owns a caret at a shared text boundary.
///
/// At a soft wrap, downstream places the caret at the next row's start, and upstream places it at
/// the previous row's end. At a bidirectional boundary, affinities can place the same byte index at
/// different horizontal positions. They refer to logical order, not visual left and right.
#[derive(
    Clone, Copy, Debug, Default, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize,
)]
pub enum CaretAffinity {
    /// The caret attaches to the logically following cluster.
    #[default]
    Downstream,
    /// The caret attaches to the logically preceding cluster.
    Upstream,
}

/// Hard line breaks that place an inserted-text caret downstream.
static HARD_LINE_BREAK_CHARACTERS: phf::Set<char> = phf::phf_set! {
    '\n',
    '\r',
    '\u{001c}',
    '\u{001d}',
    '\u{001e}',
    '\u{0085}',
    '\u{2028}',
    '\u{2029}',
};

/// Returns whether `character` separates Unicode text paragraphs.
///
/// Line separator (`U+2028`) is a hard line break within the current paragraph. Consumers are
/// responsible for treating a CRLF pair as one paragraph separator.
pub fn is_paragraph_separator(character: char) -> bool {
    character != '\u{2028}' && HARD_LINE_BREAK_CHARACTERS.contains(&character)
}

impl CaretAffinity {
    /// Returns the affinity for a caret placed after inserted text.
    pub fn for_inserted_text(text: &str) -> Self {
        Self::from(text)
    }
}

impl From<&str> for CaretAffinity {
    fn from(text: &str) -> Self {
        let Some(last_character) = text.chars().next_back() else {
            return Self::Downstream;
        };

        if HARD_LINE_BREAK_CHARACTERS.contains(&last_character) {
            return Self::Downstream;
        }

        Self::Upstream
    }
}

/// A byte position together with the information needed to place it visually.
///
/// Constructing this value does not check the index. Use
/// [`ShapedTextLayout::normalized_caret`] to obtain a valid editing stop in a particular layout.
#[derive(
    Clone, Copy, Debug, Default, Eq, Hash, PartialEq, serde::Serialize, serde::Deserialize,
)]
pub struct CaretPosition {
    /// Logical UTF-8 byte offset in the source text, before any layout normalization.
    pub index: usize,
    /// The logical neighbor that owns this position.
    pub affinity: CaretAffinity,
}

impl From<(usize, CaretAffinity)> for CaretPosition {
    fn from((index, affinity): (usize, CaretAffinity)) -> Self {
        Self { index, affinity }
    }
}

impl CaretPosition {
    /// Creates a caret attached to the next logical cluster.
    pub const fn attached_to_next_cluster(index: usize) -> Self {
        Self {
            index,
            affinity: CaretAffinity::Downstream,
        }
    }

    /// Creates a caret attached to the previous logical cluster.
    pub const fn attached_to_previous_cluster(index: usize) -> Self {
        Self {
            index,
            affinity: CaretAffinity::Upstream,
        }
    }
}

/// An affinity-aware text selection.
///
/// The anchor stays fixed while the caret is the active endpoint. Either endpoint may be the
/// logical start or end of the selected byte range.
///
/// Converting a byte range places the caret at its **start** and the anchor at its **end**,
/// both with downstream affinity. Construct the endpoints explicitly when the direction of
/// selection matters.
///
/// ```
/// use gpui::CaretSelection;
///
/// let selection = CaretSelection::from(3..7);
/// assert_eq!(selection.caret.index, 3);
/// assert_eq!(selection.anchor.index, 7);
/// assert_eq!(selection.byte_range(), 3..7);
/// ```
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct CaretSelection {
    /// The fixed position of the selection, which may be its logical start or end.
    pub anchor: CaretPosition,
    /// The active position of the selection. Equal byte indices make the selection empty,
    /// even when the endpoints have different affinities.
    pub caret: CaretPosition,
}

impl From<usize> for CaretSelection {
    fn from(index: usize) -> Self {
        CaretPosition::attached_to_next_cluster(index).into()
    }
}

impl From<CaretPosition> for CaretSelection {
    fn from(caret: CaretPosition) -> Self {
        Self {
            anchor: caret,
            caret,
        }
    }
}

/// Creates a downstream-affinity selection whose caret is `start` and anchor is `end`.
impl From<Range<usize>> for CaretSelection {
    fn from(range: Range<usize>) -> Self {
        Self {
            anchor: CaretPosition::attached_to_next_cluster(range.end),
            caret: CaretPosition::attached_to_next_cluster(range.start),
        }
    }
}

impl CaretSelection {
    /// Returns whether both endpoints have the same UTF-8 byte index.
    ///
    /// Different affinities at that same index still count as an empty selection.
    pub fn is_empty(&self) -> bool {
        self.anchor.index == self.caret.index
    }

    /// Compares the active caret's UTF-8 byte index with the fixed anchor's index.
    pub fn endpoint_ordering(self) -> std::cmp::Ordering {
        self.caret.index.cmp(&self.anchor.index)
    }

    /// Returns the selected UTF-8 byte range in logical source order, dropping endpoint affinity.
    pub fn byte_range(self) -> Range<usize> {
        self.anchor.index.min(self.caret.index)..self.anchor.index.max(self.caret.index)
    }

    /// Limits both selection endpoints to `max_idx` while preserving their affinities.
    ///
    /// This is a numeric clamp. It does not check UTF-8 or cluster boundaries; normalize each
    /// endpoint with [`ShapedTextLayout::normalized_caret`] before using it as an editing stop.
    pub fn min(mut self, max_idx: usize) -> Self {
        self.caret.index = self.caret.index.min(max_idx);
        self.anchor.index = self.anchor.index.min(max_idx);

        self
    }

    /// Moves the active end while preserving the anchor.
    pub fn with_caret(self, caret: CaretPosition) -> Self {
        Self {
            anchor: self.anchor,
            caret,
        }
    }
}

/// The result of calculating movement through a laid-out document.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct CaretMovement<T = CaretPosition> {
    /// The value at the requested destination.
    pub result: T,
    /// The horizontal coordinate from the layout's left edge retained across consecutive vertical
    /// movements.
    pub vertical_navigation_x: Option<Pixels>,
}

/// The result of calculating a selection movement through a laid-out document.
pub type CaretSelectionMovement = CaretMovement<CaretSelection>;

impl CaretMovement<CaretSelection> {
    /// Moves or extends the selection to `caret`, clearing the retained vertical coordinate.
    pub fn move_or_select_to(self, caret: CaretPosition, extend: bool) -> Self {
        let result = if extend {
            self.result.with_caret(caret)
        } else {
            caret.into()
        };

        Self {
            result,
            vertical_navigation_x: None,
        }
    }
}

/// Measurement and editing geometry for one shaped document.
///
/// [`crate::WindowTextSystem::shape_text`] returns a [`crate::ShapedText`]
/// that dereferences to this layout and adds paint methods. Keep that one
/// result for measuring, drawing, and pointer handling. Recomputing any of
/// those with a different string, wrap width, or font can produce a caret
/// that disagrees with the displayed text.
///
/// # Coordinates and source positions
///
/// Points and rectangles here use logical pixels relative to the layout's
/// own origin. They do not include the window position at which it is
/// painted. Subtract that placement from a pointer point before hit testing,
/// and add it to a returned caret or selection rectangle before painting.
/// Any additional alignment applied at paint time must also be accounted
/// for. [`crate::TextLayout`] is different: an element's shared layout handle
/// remembers its prepainted window position and converts coordinates for you.
///
/// Byte indices address the exact UTF-8 source that was shaped. Use an
/// affinity-aware [`CaretPosition`] when a soft-wrap boundary can belong to
/// either neighboring row. Visual left/right movement follows the drawn
/// order; logical cluster queries follow source order. See the
/// [text chapter](crate::_documentation::text) for choosing between them.
///
/// The `line_height` passed to geometry queries determines each visual row's
/// vertical position. Use the same value when painting those rows. This type
/// calculates geometry; it does not keep an editor's selection, apply edits,
/// or register input handlers.
#[derive(Debug)]
pub struct ShapedTextLayout {
    /// Resolved rows, glyph fragments, and backend interaction geometry.
    pub layout: Arc<LineLayout>,

    /// The wrap width used when this document was shaped, if any.
    ///
    /// Changing this field changes the reported width cap but does not
    /// recompute line breaks. Shape a new document to change wrapping.
    pub wrap_width: Option<Pixels>,
}

impl ShapedTextLayout {
    /// The length of the underlying source text, in UTF-8 bytes.
    #[allow(clippy::len_without_is_empty)]
    pub fn len(&self) -> usize {
        self.layout.platform_layout.len()
    }

    /// Return the widest row's advance, capped by the requested wrap width.
    ///
    /// This is a reported layout width, not an ink bound or a clip. A row
    /// containing unbreakable content can draw beyond it. Use a content mask
    /// when the region must clip, and reshape when its wrap width changes.
    pub fn width(&self) -> Pixels {
        self.wrap_width
            .unwrap_or(Pixels::MAX)
            .min(self.layout.width)
    }

    /// Returns the size of the complete text using the supplied visual-row height.
    ///
    /// Height is row count multiplied by `line_height`, rather than the backend's natural metrics
    /// height. Width is the advance width capped by the wrap constraint.
    pub fn size(&self, line_height: Pixels) -> Size<Pixels> {
        Size {
            width: self.width(),
            height: line_height * self.line_count(),
        }
    }

    /// Returns the number of visual rows after hard breaks and soft wrapping.
    pub fn line_count(&self) -> usize {
        self.layout.platform_layout.line_count()
    }

    /// Return the layout's maximum ascent above the baseline, in logical pixels.
    ///
    /// This is a font metric, not the height of the ink in a particular row.
    pub fn ascent(&self) -> Pixels {
        self.layout.ascent
    }

    /// Return the layout's maximum descent below the baseline, in logical pixels.
    pub fn descent(&self) -> Pixels {
        self.layout.descent
    }

    /// Returns visual rows in paint order; their source ranges remain in logical UTF-8 order.
    pub fn visual_lines(&self) -> &[VisualLine] {
        &self.layout.visual_lines
    }

    /// Returns the positioned glyph fragments for a row, in visual paint order.
    ///
    /// Pass a row from [`Self::visual_lines`]. The method indexes this layout's fragment array
    /// directly and panics if the row's fragment range is out of bounds.
    pub fn fragments_for_line(&self, line: &VisualLine) -> &[PaintFragment] {
        &self.layout.paint_fragments[line.paint_fragment_range.clone()]
    }

    /// Return the base font size requested during shaping, in logical pixels.
    ///
    /// Individual resolved fragments may use a different font or size.
    pub fn font_size(&self) -> Pixels {
        self.layout.font_size
    }

    /// Find the source cluster under a point relative to this layout's origin.
    ///
    /// The backend returns the logical start of the visual cluster under the point.
    /// Whitespace is hit like any other cluster. `Ok` identifies a hit on a
    /// visual row; `Err` carries the closest boundary when the point lies
    /// outside it. `Err` is useful for dragging a selection beyond the text,
    /// rather than an indication that shaping failed. Supply the same row
    /// height used to paint the document.
    ///
    /// See also [`Self::closest_byte_index_for_pixel_point`].
    pub fn byte_index_for_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<usize, usize> {
        self.layout
            .platform_layout
            .byte_index_from_pixel_point(pixel_point, line_height)
    }

    /// Find the nearest caret stop, discarding its affinity.
    ///
    /// Closest means the character boundary closest to the given position.
    /// The backend only returns cluster boundaries. For right-to-left clusters, the
    /// visual left edge maps to the logical end and the visual right edge maps to the logical
    /// start. Zero-width clusters share a stop with an adjacent cluster and use visual order to
    /// break ties. The point is relative to this layout's origin. `Ok` and
    /// `Err` preserve the hit-versus-nearest-edge distinction from
    /// [`Self::closest_caret_for_pixel_point`].
    pub fn closest_byte_index_for_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<usize, usize> {
        self.closest_caret_for_pixel_point(pixel_point, line_height)
            .map(|caret| caret.index)
            .map_err(|caret| caret.index)
    }

    /// Find the nearest caret while preserving its soft-wrap affinity.
    ///
    /// Positions outside a visual line return the caret at that edge in `Err`, matching
    /// [`Self::closest_byte_index_for_pixel_point`]. The point is relative to
    /// this layout's origin, and `line_height` must match painting. A pointer
    /// selection usually accepts either result, allowing its endpoint to
    /// follow the nearest edge outside the text:
    ///
    /// ```rust
    /// use gpui::{CaretPosition, Pixels, Point, ShapedTextLayout};
    ///
    /// fn caret_at_pointer(
    ///     layout: &ShapedTextLayout,
    ///     pointer: Point<Pixels>,
    ///     painted_origin: Point<Pixels>,
    ///     line_height: Pixels,
    /// ) -> CaretPosition {
    ///     // No extra alignment has been applied beyond the stored layout.
    ///     layout
    ///         .closest_caret_for_pixel_point(pointer - painted_origin, line_height)
    ///         .unwrap_or_else(|nearest_edge| nearest_edge)
    /// }
    /// ```
    pub fn closest_caret_for_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
    ) -> Result<CaretPosition, CaretPosition> {
        self.layout
            .platform_layout
            .caret_from_pixel_point(pixel_point, line_height)
    }

    /// Return a byte index's caret position relative to this layout's origin.
    ///
    /// The backend maps cluster boundaries to direction-aware visual edges. An index
    /// inside an atomic cluster snaps to its logical start. On a shared wrap boundary, the cluster
    /// starting at the index owns the position, so the caret moves to the following visual line.
    /// An index beyond the source length returns `None`. Use
    /// [`Self::visual_position_for_caret`] to retain an explicit affinity.
    pub fn visual_position_for_byte_index(
        &self,
        byte_index: usize,
        line_height: Pixels,
    ) -> Option<Point<Pixels>> {
        if byte_index > self.len() {
            return None;
        }

        self.visual_position_for_caret(
            CaretPosition::attached_to_next_cluster(byte_index),
            line_height,
        )
    }

    /// Return a caret's top-left point relative to this layout's origin.
    ///
    /// Affinity resolves the two possible rows at a soft-wrap boundary. The
    /// backend can return `None` when it cannot represent the position. Add
    /// the painted origin before using this point in a window paint method.
    pub fn visual_position_for_caret(
        &self,
        caret: CaretPosition,
        line_height: Pixels,
    ) -> Option<Point<Pixels>> {
        self.layout
            .platform_layout
            .caret_bounds(caret, line_height)
            .map(|bounds| bounds.origin)
    }

    /// Snap an external caret to a backend cluster boundary.
    ///
    /// Constructing [`CaretPosition`] does not validate its byte index.
    /// Normalize positions received from another source before movement or
    /// painting. This preserves affinity when possible; it does not map a
    /// position from a different source string into this one.
    pub fn normalized_caret(&self, caret: CaretPosition) -> CaretPosition {
        self.layout.platform_layout.normalized_caret(caret)
    }

    /// Finds the adjacent legal caret stop to the visual left or right.
    ///
    /// Returns `None` at the corresponding outer edge, or when the backend
    /// cannot produce a neighboring stop. Keep the returned affinity: another
    /// visual position can have the same byte index at a soft wrap. An index
    /// can decrease when moving right through bidirectional text.
    ///
    /// Use [`Self::logical_cluster_before`] or [`Self::logical_cluster_after`]
    /// for source-order editing ranges, and [`Self::selection_movement`] when
    /// an arrow key should also collapse or extend the current selection.
    pub fn adjacent_visual_caret(
        &self,
        caret: CaretPosition,
        direction: VisualDirection,
    ) -> Option<CaretPosition> {
        self.layout
            .platform_layout
            .adjacent_visual_caret(caret, direction)
    }

    /// Finds the preceding editing unit in logical source order.
    ///
    /// The returned range uses UTF-8 bytes. This follows the source, not the
    /// visual left edge of bidirectional text. The supplied Parley backend
    /// returns grapheme ranges, so a base letter and combining accent can be
    /// removed together. It returns `None` at the source start.
    ///
    /// If the index is inside a grapheme, Parley returns that containing range.
    /// A pointer's shaping-cluster hit can therefore lie inside the returned
    /// editing unit; it need not identify one endpoint. Keep caret movement
    /// and deletion policy explicit when building an editor.
    pub fn logical_cluster_before(&self, caret: CaretPosition) -> Option<Range<usize>> {
        self.layout.platform_layout.logical_cluster_before(caret)
    }

    /// Finds the following editing unit in logical source order.
    ///
    /// The supplied Parley backend returns a UTF-8 grapheme range and `None`
    /// at the source end. An index inside a grapheme selects that containing
    /// range. This follows the source rather than the visual right edge; see
    /// [`Self::logical_cluster_before`] for the corresponding backward query
    /// and its distinction from a shaping-cluster hit.
    pub fn logical_cluster_after(&self, caret: CaretPosition) -> Option<Range<usize>> {
        self.layout.platform_layout.logical_cluster_after(caret)
    }

    /// Calculates a caret's destination and preferred column for later vertical moves.
    ///
    /// [`TextMovement`] describes the direction/boundary pairs supported by the
    /// supplied backend. Carry the returned `vertical_navigation_x` into the
    /// next movement, and store the returned caret on the editor. This method
    /// changes no editor state and edits no text. Use [`Self::selection_movement`]
    /// when the current selection also determines where movement should begin.
    pub fn caret_movement(
        &self,
        caret: CaretPosition,
        movement: TextMovement,
        vertical_navigation_x: Option<Pixels>,
    ) -> CaretMovement {
        self.layout
            .platform_layout
            .caret_movement(caret, movement, vertical_navigation_x)
    }

    /// Calculates a moved or extended selection while preserving caret affinity.
    ///
    /// A left/right cluster or word movement without extension collapses a nonempty selection
    /// to the requested visual edge, without taking another step. Other movements start at the
    /// active caret. Extending keeps the anchor fixed.
    /// If either endpoint has no representable geometry, collapsing falls back
    /// to logical byte order.
    ///
    /// `selection` is the current anchor and active caret.
    /// `movement` supplies the direction and boundary.
    /// `extend` keeps the anchor fixed when true and collapses the result when false.
    /// `vertical_navigation_x` carries the horizontal target across vertical movements.
    /// `line_height` converts caret positions into comparable visual coordinates.
    pub fn selection_movement(
        &self,
        selection: CaretSelection,
        movement: TextMovement,
        extend: bool,
        vertical_navigation_x: Option<Pixels>,
        line_height: Pixels,
    ) -> CaretSelectionMovement {
        let forward = movement.direction == TextDirection::Right;
        let horizontal = matches!(
            movement.direction,
            TextDirection::Left | TextDirection::Right
        ) && matches!(
            movement.boundary,
            TextBoundary::Cluster | TextBoundary::Word
        );

        if !extend && !selection.is_empty() && horizontal {
            let caret_visual_position =
                self.visual_position_for_caret(selection.caret, line_height);
            let anchor_visual_position =
                self.visual_position_for_caret(selection.anchor, line_height);
            let (visual_start, visual_end) = caret_visual_position
                .zip(anchor_visual_position)
                .map(|(caret_visual_position, anchor_visual_position)| {
                    if (caret_visual_position.y, caret_visual_position.x)
                        <= (anchor_visual_position.y, anchor_visual_position.x)
                    {
                        (selection.caret, selection.anchor)
                    } else {
                        (selection.anchor, selection.caret)
                    }
                })
                .unwrap_or_else(|| {
                    if selection.caret.index <= selection.anchor.index {
                        (selection.caret, selection.anchor)
                    } else {
                        (selection.anchor, selection.caret)
                    }
                });

            let caret = if forward { visual_end } else { visual_start };

            return CaretSelectionMovement {
                result: caret.into(),
                vertical_navigation_x: None,
            };
        }

        let CaretMovement {
            result: caret,
            vertical_navigation_x,
        } = self.caret_movement(selection.caret, movement, vertical_navigation_x);

        CaretSelectionMovement {
            result: if extend {
                selection.with_caret(caret)
            } else {
                caret.into()
            },
            vertical_navigation_x,
        }
    }

    /// Select a word, visual row, or hard line at a layout-relative point.
    ///
    /// `kind` chooses the boundary rule. The result is a range in logical
    /// UTF-8 source order, even when the selected text reads right to left.
    pub fn selection_from_pixel_point(
        &self,
        pixel_point: Point<Pixels>,
        line_height: Pixels,
        kind: TextSelectionKind,
    ) -> Range<usize> {
        self.layout
            .platform_layout
            .selection_from_pixel_point(pixel_point, line_height, kind)
    }

    /// Return layout-relative rectangles covering a source range.
    ///
    /// `byte_range` uses logical UTF-8 source order. One range can produce
    /// several rectangles when it crosses rows or bidirectional runs; do
    /// not replace them with a single bounding box. An empty range produces
    /// no rectangles. Backends may extend selection into row whitespace.
    /// Add the painted origin to each rectangle and use the same row height
    /// as the text. For a collapsed selection, query the caret separately.
    pub fn selection_bounds(
        &self,
        byte_range: Range<usize>,
        line_height: Pixels,
    ) -> SmallVec<[Bounds<Pixels>; 4]> {
        let mut result = SmallVec::new();

        if byte_range.is_empty() {
            return result;
        }

        result.extend(
            self.layout
                .platform_layout
                .selection_bounds(byte_range, line_height),
        );
        result
    }
}

impl std::ops::Deref for ShapedTextLayout {
    type Target = LineLayout;

    fn deref(&self) -> &Self::Target {
        &self.layout
    }
}

pub(crate) struct LineLayoutCache {
    previous_frame: Mutex<FrameCache>,
    current_frame: RwLock<FrameCache>,
    platform_text_system: Arc<dyn PlatformTextSystem>,
    font_generation: AtomicU64,
}

#[derive(Default)]
struct FrameCache {
    lines: FrameLayouts<CacheKey, LineLayout>,
    shaped_texts: FrameLayouts<CacheKey, ShapedTextLayout>,
    inline_layouts: FrameLayouts<InlineCacheKey, InlineLayout>,
}

struct FrameLayouts<Key, Value> {
    entries: FxHashMap<Arc<Key>, Arc<Value>>,
    used: Vec<Arc<Key>>,
}

impl<Key, Value> Default for FrameLayouts<Key, Value> {
    fn default() -> Self {
        Self {
            entries: FxHashMap::default(),
            used: Vec::new(),
        }
    }
}

impl<Key, Value> FrameLayouts<Key, Value>
where
    Key: Eq + Hash,
{
    fn get<Query>(&self, key: &Query) -> Option<&Arc<Value>>
    where
        Arc<Key>: Borrow<Query>,
        Query: Eq + Hash + ?Sized,
    {
        self.entries.get(key)
    }

    fn remove_entry<Query>(&mut self, key: &Query) -> Option<(Arc<Key>, Arc<Value>)>
    where
        Arc<Key>: Borrow<Query>,
        Query: Eq + Hash + ?Sized,
    {
        self.entries.remove_entry(key)
    }

    fn insert(&mut self, key: Arc<Key>, value: Arc<Value>) {
        self.entries.insert(key.clone(), value);
        self.used.push(key);
    }

    fn reuse(&mut self, previous: &mut Self, range: Range<usize>) {
        for key in &previous.used[range] {
            if let Some(layout) = previous.entries.remove(key) {
                self.entries.insert(key.clone(), layout);
            }

            self.used.push(key.clone());
        }
    }

    fn clear(&mut self) {
        self.entries.clear();
        self.used.clear();
    }
}

fn repaint_line_layout(layout: Arc<LineLayout>, runs: &[TextRun]) -> Arc<LineLayout> {
    let paint_matches = layout.paint_fragments.iter().all(|fragment| {
        runs.get(fragment.source_run)
            .is_some_and(|run| fragment.style == PaintStyle::from(run))
    });

    if paint_matches {
        return layout;
    }

    let mut repainted = (*layout).clone();

    for fragment in &mut repainted.paint_fragments {
        if let Some(run) = runs.get(fragment.source_run) {
            fragment.style = PaintStyle::from(run);
        }
    }

    Arc::new(repainted)
}

fn repaint_shaped_text_layout(
    layout: Arc<ShapedTextLayout>,
    runs: &[TextRun],
) -> Arc<ShapedTextLayout> {
    let repainted = repaint_line_layout(layout.layout.clone(), runs);

    if Arc::ptr_eq(&repainted, &layout.layout) {
        return layout;
    }

    Arc::new(ShapedTextLayout {
        layout: repainted,
        wrap_width: layout.wrap_width,
    })
}

#[derive(Clone, Default)]
pub(crate) struct LineLayoutIndex {
    lines_index: usize,
    shaped_texts_index: usize,
    inline_layouts_index: usize,
}

impl LineLayoutCache {
    pub fn new(platform_text_system: Arc<dyn PlatformTextSystem>) -> Self {
        let font_generation = platform_text_system.font_generation();
        Self {
            previous_frame: Mutex::default(),
            current_frame: RwLock::default(),
            platform_text_system,
            font_generation: AtomicU64::new(font_generation),
        }
    }

    pub fn layout_index(&self) -> LineLayoutIndex {
        let frame = self.current_frame.read();
        LineLayoutIndex {
            lines_index: frame.lines.used.len(),
            shaped_texts_index: frame.shaped_texts.used.len(),
            inline_layouts_index: frame.inline_layouts.used.len(),
        }
    }

    /// Invalidates every cached layout after backend shaping state changes.
    pub fn clear(&self) {
        *self.previous_frame.lock() = FrameCache::default();
        *self.current_frame.write() = FrameCache::default();
    }

    fn sync_font_generation(&self) {
        let generation = self.platform_text_system.font_generation();
        if self.font_generation.load(Ordering::Acquire) != generation {
            self.clear();
            self.font_generation.store(generation, Ordering::Release);
        }
    }

    pub fn reuse_layouts(&self, range: Range<LineLayoutIndex>) {
        let mut previous_frame = &mut *self.previous_frame.lock();
        let mut current_frame = &mut *self.current_frame.write();

        current_frame.lines.reuse(
            &mut previous_frame.lines,
            range.start.lines_index..range.end.lines_index,
        );
        current_frame.shaped_texts.reuse(
            &mut previous_frame.shaped_texts,
            range.start.shaped_texts_index..range.end.shaped_texts_index,
        );
        current_frame.inline_layouts.reuse(
            &mut previous_frame.inline_layouts,
            range.start.inline_layouts_index..range.end.inline_layouts_index,
        );
    }

    pub fn truncate_layouts(&self, index: LineLayoutIndex) {
        let mut current_frame = &mut *self.current_frame.write();
        current_frame.lines.used.truncate(index.lines_index);
        current_frame
            .shaped_texts
            .used
            .truncate(index.shaped_texts_index);
        current_frame
            .inline_layouts
            .used
            .truncate(index.inline_layouts_index);
    }

    pub fn finish_frame(&self) {
        let mut prev_frame = self.previous_frame.lock();
        let mut curr_frame = self.current_frame.write();
        std::mem::swap(&mut *prev_frame, &mut *curr_frame);
        curr_frame.lines.clear();
        curr_frame.shaped_texts.clear();
        curr_frame.inline_layouts.clear();
    }

    pub fn layout_text_with_options<Text>(
        &self,
        text: Text,
        font_size: Pixels,
        runs: &[TextRun],
        options: TextLayoutOptions,
    ) -> Arc<ShapedTextLayout>
    where
        Text: AsRef<str>,
        SharedString: From<Text>,
    {
        self.sync_font_generation();
        let wrap_width = options.wrap_width;
        let shaping_runs = runs.iter().map(ShapingRun::from).collect::<SmallVec<_>>();
        let key = &CacheKeyRef {
            text: text.as_ref(),
            font_size,
            runs: &shaping_runs,
            options,
        } as &dyn AsCacheKeyRef;

        let current_frame = self.current_frame.upgradable_read();
        if let Some(layout) = current_frame.shaped_texts.get(key) {
            return repaint_shaped_text_layout(layout.clone(), runs);
        }

        let previous_frame_entry = self.previous_frame.lock().shaped_texts.remove_entry(key);
        if let Some((key, layout)) = previous_frame_entry {
            let mut current_frame = RwLockUpgradableReadGuard::upgrade(current_frame);
            current_frame.shaped_texts.insert(key, layout.clone());
            repaint_shaped_text_layout(layout, runs)
        } else {
            drop(current_frame);
            let text = SharedString::from(text);
            let document_layout = if options != TextLayoutOptions::default() || text.contains('\n')
            {
                Arc::new(self.platform_text_system.layout_text(TextLayoutRequest {
                    text: &text,
                    font_size,
                    runs,
                    options,
                }))
            } else {
                self.layout_line::<&SharedString>(&text, font_size, runs)
            };

            let layout = Arc::new(ShapedTextLayout {
                layout: document_layout,
                wrap_width,
            });
            let key = Arc::new(CacheKey {
                text,
                font_size,
                runs: shaping_runs,
                options,
            });

            let mut current_frame = self.current_frame.write();
            current_frame.shaped_texts.insert(key, layout.clone());

            layout
        }
    }

    pub fn layout_line<Text>(
        &self,
        text: Text,
        font_size: Pixels,
        runs: &[TextRun],
    ) -> Arc<LineLayout>
    where
        Text: AsRef<str>,
        SharedString: From<Text>,
    {
        self.sync_font_generation();
        let shaping_runs = runs.iter().map(ShapingRun::from).collect::<SmallVec<_>>();
        let key = &CacheKeyRef {
            text: text.as_ref(),
            font_size,
            runs: &shaping_runs,
            options: TextLayoutOptions::default(),
        } as &dyn AsCacheKeyRef;

        let current_frame = self.current_frame.upgradable_read();
        if let Some(layout) = current_frame.lines.get(key) {
            return repaint_line_layout(layout.clone(), runs);
        }

        let mut current_frame = RwLockUpgradableReadGuard::upgrade(current_frame);
        if let Some((key, layout)) = self.previous_frame.lock().lines.remove_entry(key) {
            current_frame.lines.insert(key, layout.clone());
            repaint_line_layout(layout, runs)
        } else {
            let text = SharedString::from(text);
            let layout = self.platform_text_system.layout_text(TextLayoutRequest {
                text: &text,
                font_size,
                runs,
                options: TextLayoutOptions::default(),
            });
            let key = Arc::new(CacheKey {
                text,
                font_size,
                runs: shaping_runs,
                options: TextLayoutOptions::default(),
            });
            let layout = Arc::new(layout);
            current_frame.lines.insert(key, layout.clone());
            layout
        }
    }

    pub fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> Arc<InlineLayout> {
        self.sync_font_generation();
        let key = &request as &dyn AsInlineCacheKeyRef;
        let current_frame = self.current_frame.upgradable_read();

        if let Some(layout) = current_frame.inline_layouts.get(key) {
            return layout.clone();
        }

        let previous_frame_entry = self.previous_frame.lock().inline_layouts.remove_entry(key);

        if let Some((key, layout)) = previous_frame_entry {
            let mut current_frame = RwLockUpgradableReadGuard::upgrade(current_frame);
            current_frame.inline_layouts.insert(key, layout.clone());

            return layout;
        }

        drop(current_frame);
        let layout = Arc::new(self.platform_text_system.layout_inline(request));
        let key = Arc::new(InlineCacheKey::from(request));

        let mut current_frame = self.current_frame.write();
        current_frame.inline_layouts.insert(key, layout.clone());

        layout
    }
}

trait AsInlineCacheKeyRef {
    fn as_inline_cache_key_ref(&self) -> InlineLayoutRequest<'_>;
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct InlineCacheKey {
    text: SharedString,
    runs: SmallVec<[TextRun; 1]>,
    text_styles: Vec<InlineTextStyle>,
    boxes: Vec<InlineBoxRequest>,
    font_size: Pixels,
    line_height: Pixels,
    text_metrics: InlineTextMetrics,
    options: TextLayoutOptions,
    bidi_scopes: Vec<InlineBidiScope>,
}

impl From<InlineLayoutRequest<'_>> for InlineCacheKey {
    fn from(request: InlineLayoutRequest<'_>) -> Self {
        Self {
            text: SharedString::new(request.text),
            runs: SmallVec::from(request.runs),
            text_styles: request.text_styles.to_vec(),
            boxes: request.boxes.to_vec(),
            font_size: request.font_size,
            line_height: request.line_height,
            text_metrics: request.text_metrics,
            options: request.options,
            bidi_scopes: request.bidi_scopes.to_vec(),
        }
    }
}

impl AsInlineCacheKeyRef for InlineCacheKey {
    fn as_inline_cache_key_ref(&self) -> InlineLayoutRequest<'_> {
        InlineLayoutRequest {
            text: &self.text,
            runs: &self.runs,
            text_styles: &self.text_styles,
            boxes: &self.boxes,
            font_size: self.font_size,
            line_height: self.line_height,
            text_metrics: self.text_metrics,
            options: self.options,
            bidi_scopes: &self.bidi_scopes,
        }
    }
}

impl AsInlineCacheKeyRef for InlineLayoutRequest<'_> {
    fn as_inline_cache_key_ref(&self) -> InlineLayoutRequest<'_> {
        *self
    }
}

impl PartialEq for dyn AsInlineCacheKeyRef + '_ {
    fn eq(&self, other: &dyn AsInlineCacheKeyRef) -> bool {
        self.as_inline_cache_key_ref() == other.as_inline_cache_key_ref()
    }
}

impl Eq for dyn AsInlineCacheKeyRef + '_ {}

impl Hash for dyn AsInlineCacheKeyRef + '_ {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.as_inline_cache_key_ref().hash(state);
    }
}

impl<'a> Borrow<dyn AsInlineCacheKeyRef + 'a> for Arc<InlineCacheKey> {
    fn borrow(&self) -> &(dyn AsInlineCacheKeyRef + 'a) {
        self.as_ref() as &dyn AsInlineCacheKeyRef
    }
}

trait AsCacheKeyRef {
    fn as_cache_key_ref(&self) -> CacheKeyRef<'_>;
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct CacheKey {
    text: SharedString,
    font_size: Pixels,
    runs: SmallVec<[ShapingRun; 1]>,
    options: TextLayoutOptions,
}

#[derive(Copy, Clone, PartialEq, Eq, Hash)]
struct CacheKeyRef<'a> {
    text: &'a str,
    font_size: Pixels,
    runs: &'a [ShapingRun],
    options: TextLayoutOptions,
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct ShapingRun {
    len: usize,
    font: crate::Font,
    letter_spacing: Option<Pixels>,
}

impl From<&TextRun> for ShapingRun {
    fn from(run: &TextRun) -> Self {
        Self {
            len: run.len,
            font: run.font.clone(),
            letter_spacing: run.letter_spacing,
        }
    }
}

impl PartialEq for dyn AsCacheKeyRef + '_ {
    fn eq(&self, other: &dyn AsCacheKeyRef) -> bool {
        self.as_cache_key_ref() == other.as_cache_key_ref()
    }
}

impl Eq for dyn AsCacheKeyRef + '_ {}

impl Hash for dyn AsCacheKeyRef + '_ {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.as_cache_key_ref().hash(state)
    }
}

impl AsCacheKeyRef for CacheKey {
    fn as_cache_key_ref(&self) -> CacheKeyRef<'_> {
        CacheKeyRef {
            text: &self.text,
            font_size: self.font_size,
            runs: self.runs.as_slice(),
            options: self.options,
        }
    }
}

impl<'a> Borrow<dyn AsCacheKeyRef + 'a> for Arc<CacheKey> {
    fn borrow(&self) -> &(dyn AsCacheKeyRef + 'a) {
        self.as_ref() as &dyn AsCacheKeyRef
    }
}

impl AsCacheKeyRef for CacheKeyRef<'_> {
    fn as_cache_key_ref(&self) -> CacheKeyRef<'_> {
        *self
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{point, px, size};

    #[test]
    fn caret_selection_endpoint_ordering_uses_byte_indices() {
        for (caret, anchor, expected) in [
            (
                CaretPosition::attached_to_next_cluster(2),
                CaretPosition::attached_to_next_cluster(5),
                std::cmp::Ordering::Less,
            ),
            (
                CaretPosition::attached_to_next_cluster(5),
                CaretPosition::attached_to_previous_cluster(5),
                std::cmp::Ordering::Equal,
            ),
            (
                CaretPosition::attached_to_previous_cluster(8),
                CaretPosition::attached_to_next_cluster(5),
                std::cmp::Ordering::Greater,
            ),
        ] {
            let selection = CaretSelection { anchor, caret };
            assert_eq!(selection.endpoint_ordering(), expected);
        }
    }

    #[test]
    fn paragraph_separators_match_unicode_bidi_class_b() {
        for character in [
            '\n', '\r', '\u{001c}', '\u{001d}', '\u{001e}', '\u{0085}', '\u{2029}',
        ] {
            assert!(is_paragraph_separator(character));
        }

        for character in [' ', '\u{2028}'] {
            assert!(!is_paragraph_separator(character));
        }
    }

    #[test]
    fn inserted_text_affinity_tracks_trailing_paragraph_separators() {
        for (text, expected) in [
            ("", CaretAffinity::Downstream),
            ("ordinary text", CaretAffinity::Upstream),
            ("\n", CaretAffinity::Downstream),
            ("\r", CaretAffinity::Downstream),
            ("\u{001c}", CaretAffinity::Downstream),
            ("\u{001d}", CaretAffinity::Downstream),
            ("\u{001e}", CaretAffinity::Downstream),
            ("\u{0085}", CaretAffinity::Downstream),
            ("\u{2028}", CaretAffinity::Downstream),
            ("\u{2029}", CaretAffinity::Downstream),
            ("\nordinary text", CaretAffinity::Upstream),
        ] {
            assert_eq!(CaretAffinity::from(text), expected, "From({text:?})");
            assert_eq!(
                CaretAffinity::for_inserted_text(text),
                expected,
                "for_inserted_text({text:?})"
            );
        }
    }

    #[test]
    fn inline_box_alignment_preserves_unsorted_boxes_and_empty_lines() {
        let mut lines = [InlineVisualLine::default(); 3];
        let mut boxes =
            [(20, 2, 14.), (10, 0, 18.), (90, 3, 100.)].map(|(id, line_index, height)| {
                PositionedInlineBox {
                    id,
                    line_index,
                    bounds: Bounds::new(point(px(7.), px(99.)), size(px(5.), px(height))),
                }
            });
        let mut layout_size = size(px(100.), px(999.));
        let original_lines = lines;
        let original_boxes = boxes;

        let requests = [InlineBoxRequest {
            id: 20,
            index: 0,
            size: boxes[0].bounds.size,
            vertical_align: VerticalAlign::Top,
        }];
        let metrics = InlineTextMetrics {
            ascent: px(8.),
            descent: px(2.),
            x_height: px(4.),
        };

        align_inline_boxes(
            &mut lines,
            &mut boxes,
            &mut layout_size,
            &requests,
            &[metrics],
            &[(px(-7.), px(3.)), (px(-11.), px(4.))],
            metrics,
            px(12.),
        );

        for ((line, mut expected_line), (origin_y, height, baseline)) in lines
            .iter()
            .zip(original_lines)
            .zip([(0., 21., 18.), (21., 15., 11.), (36., 14., 9.)])
        {
            expected_line.origin.y = px(origin_y);
            expected_line.size.height = px(height);
            expected_line.baseline = px(baseline);
            assert_eq!(*line, expected_line);
        }

        for ((inline_box, mut expected_box), origin_y) in
            boxes.iter().zip(original_boxes).zip([36., 0., 99.])
        {
            expected_box.bounds.origin.y = px(origin_y);
            assert_eq!(*inline_box, expected_box);
        }

        assert_eq!(layout_size, size(px(100.), px(50.)));
    }
}
