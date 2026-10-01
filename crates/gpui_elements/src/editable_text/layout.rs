use crate::rich_text::{Document, InlineColor};
use crate::rich_text::{InlineStyle, RangeSet};
use gpui::{Bounds, Hsla, Pixels, Point, SharedString, Size, TextStyle, TruncateFrom, WrappedLine};
use std::{
    collections::{HashMap, hash_map::DefaultHasher},
    hash::{Hash, Hasher},
    ops::Range,
    sync::Arc,
};

#[derive(Clone, PartialEq)]
pub(super) struct EditableTextLayoutKey {
    pub storage_revision: u64,
    pub wrap_width: Option<Pixels>,
    pub truncation_width: Option<Pixels>,
    pub truncation_affix: SharedString,
    pub truncation_source: TruncateFrom,
    pub is_placeholder: bool,
    pub placeholder_text: Option<SharedString>,
    pub text_style: TextStyle,
    pub text_color: Hsla,
    pub persistent_styles: RangeSet<InlineStyle>,
    pub decorations: RangeSet<InlineStyle>,
    pub font_size: Pixels,
    pub line_height: Pixels,
    pub supports_multiline: bool,
}

/// Inputs that determine whether one logical paragraph can reuse its shaped line.
/// The document revision is deliberately on `EditableTextLayoutKey` instead: an edit advances
/// the layout revision, while unchanged paragraphs can still reuse their shaped lines.
#[derive(Clone, Debug, PartialEq)]
pub(super) struct ParagraphLayoutKey {
    pub base_text_style: TextStyle,
    pub inline_styles: RangeSet<InlineStyle>,
    pub font_size: Pixels,
    pub wrap_width: Option<Pixels>,
    pub line_clamp: Option<usize>,
    pub truncation_width: Option<Pixels>,
    pub truncation_affix: SharedString,
    pub truncation_source: TruncateFrom,
    pub is_placeholder: bool,
    pub placeholder_text: Option<SharedString>,
}

struct ParagraphLayoutCacheEntry {
    key: ParagraphLayoutKey,
    text: SharedString,
    line: Arc<WrappedLine>,
}

/// The active document revision's paragraph cache. It is replaced with the next complete layout,
/// so it retains no stale revisions and stays bounded by the current document's paragraph count.
#[derive(Clone, Default)]
pub(super) struct ParagraphLayoutCache(Arc<HashMap<u64, Vec<ParagraphLayoutCacheEntry>>>);

#[derive(Default)]
pub(super) struct ParagraphLayoutCacheBuilder(HashMap<u64, Vec<ParagraphLayoutCacheEntry>>);

impl ParagraphLayoutCache {
    /// Finds a previously shaped paragraph without allocating a string for the current source
    /// range. The hash narrows the candidate set; full key and chunk-by-chunk text equality keep
    /// collisions from reusing the wrong layout.
    pub fn get(
        &self,
        fingerprint: u64,
        key: &ParagraphLayoutKey,
        document: &Document,
        text_range: &Range<usize>,
    ) -> Option<Arc<WrappedLine>> {
        find_cached_line(&self.0, fingerprint, key, document, text_range)
    }

    pub fn fingerprint(
        key: &ParagraphLayoutKey,
        document: &Document,
        text_range: &Range<usize>,
    ) -> u64 {
        let mut hasher = DefaultHasher::new();
        text_range.len().hash(&mut hasher);
        for chunk in document.chunk_slices_in_range(text_range.clone()) {
            hasher.write(chunk.as_bytes());
        }
        hash_font(&key.base_text_style.font(), &mut hasher);
        hash_pixels(key.font_size, &mut hasher);
        match key.wrap_width {
            Some(width) => {
                true.hash(&mut hasher);
                hash_pixels(width, &mut hasher);
            }
            None => false.hash(&mut hasher),
        }
        key.line_clamp.hash(&mut hasher);
        for span in key.inline_styles.iter() {
            span.range.start.hash(&mut hasher);
            span.range.end.hash(&mut hasher);
            span.start_affinity.hash(&mut hasher);
            span.end_affinity.hash(&mut hasher);
            hash_inline_style(span.value(), &mut hasher);
        }
        key.is_placeholder.hash(&mut hasher);
        key.placeholder_text
            .as_ref()
            .map(|text| text.as_ref())
            .hash(&mut hasher);
        hasher.finish()
    }
}

fn hash_float<H: Hasher>(value: f32, hasher: &mut H) {
    // `PartialEq` treats both signed zeroes as equal. Keep the hash consistent with that.
    let bits = if value == 0.0 { 0 } else { value.to_bits() };
    bits.hash(hasher);
}

fn hash_pixels<H: Hasher>(value: Pixels, hasher: &mut H) {
    hash_float(f32::from(value), hasher);
}

fn hash_font<H: Hasher>(font: &gpui::Font, hasher: &mut H) {
    font.family.hash(hasher);
    font.features.hash(hasher);
    font.fallbacks.hash(hasher);
    hash_float(font.weight.0, hasher);
    font.style.hash(hasher);
}

fn hash_hsla<H: Hasher>(color: Hsla, hasher: &mut H) {
    hash_float(color.hue.into_positive_degrees(), hasher);
    hash_float(color.saturation, hasher);
    hash_float(color.lightness, hasher);
    hash_float(color.alpha, hasher);
}

fn hash_inline_style<H: Hasher>(style: &InlineStyle, hasher: &mut H) {
    match style.color {
        None => 0u8.hash(hasher),
        Some(InlineColor::Replace(color)) => {
            1u8.hash(hasher);
            hash_hsla(color, hasher);
        }
        Some(InlineColor::Blend(color)) => {
            2u8.hash(hasher);
            hash_hsla(color, hasher);
        }
        Some(InlineColor::Reset) => 3u8.hash(hasher),
    }
    hash_nested_option(&style.background_color, hasher, |color, hasher| {
        hash_hsla(*color, hasher)
    });
    hash_nested_option(&style.font_family, hasher, |family, hasher| {
        family.hash(hasher)
    });
    style.font_features.hash(hasher);
    style.font_fallbacks.hash(hasher);
    match style.font_weight {
        Some(weight) => {
            true.hash(hasher);
            hash_float(weight.0, hasher);
        }
        None => false.hash(hasher),
    }
    style.font_style.hash(hasher);
    hash_nested_option(&style.underline, hasher, |underline, hasher| {
        hash_pixels(underline.thickness, hasher);
        match underline.color {
            Some(color) => {
                true.hash(hasher);
                hash_hsla(color, hasher);
            }
            None => false.hash(hasher),
        }
        underline.wavy.hash(hasher);
    });
    hash_nested_option(&style.strikethrough, hasher, |strikethrough, hasher| {
        hash_pixels(strikethrough.thickness, hasher);
        match strikethrough.color {
            Some(color) => {
                true.hash(hasher);
                hash_hsla(color, hasher);
            }
            None => false.hash(hasher),
        }
    });
    hash_nested_option(&style.letter_spacing, hasher, |spacing, hasher| {
        hash_pixels(*spacing, hasher)
    });
    match style.fade_out {
        Some(fade_out) => {
            true.hash(hasher);
            hash_float(fade_out, hasher);
        }
        None => false.hash(hasher),
    }
}

fn hash_nested_option<T, H: Hasher>(
    value: &Option<Option<T>>,
    hasher: &mut H,
    hash_value: impl FnOnce(&T, &mut H),
) {
    match value {
        Some(Some(value)) => {
            2u8.hash(hasher);
            hash_value(value, hasher);
        }
        Some(None) => 1u8.hash(hasher),
        None => 0u8.hash(hasher),
    }
}

impl ParagraphLayoutCacheBuilder {
    pub fn get(
        &self,
        fingerprint: u64,
        key: &ParagraphLayoutKey,
        document: &Document,
        text_range: &Range<usize>,
    ) -> Option<Arc<WrappedLine>> {
        find_cached_line(&self.0, fingerprint, key, document, text_range)
    }

    pub fn insert(
        &mut self,
        fingerprint: u64,
        key: ParagraphLayoutKey,
        text: SharedString,
        line: Arc<WrappedLine>,
    ) {
        self.0
            .entry(fingerprint)
            .or_default()
            .push(ParagraphLayoutCacheEntry { key, text, line });
    }

    pub fn finish(self) -> ParagraphLayoutCache {
        ParagraphLayoutCache(Arc::new(self.0))
    }
}

fn find_cached_line(
    entries: &HashMap<u64, Vec<ParagraphLayoutCacheEntry>>,
    fingerprint: u64,
    key: &ParagraphLayoutKey,
    document: &Document,
    text_range: &Range<usize>,
) -> Option<Arc<WrappedLine>> {
    entries.get(&fingerprint)?.iter().find_map(|entry| {
        (entry.key == *key && document_range_equals(document, text_range, &entry.text))
            .then(|| entry.line.clone())
    })
}

fn document_range_equals(document: &Document, range: &Range<usize>, text: &str) -> bool {
    if range.len() != text.len() {
        return false;
    }
    let mut offset = 0;
    for chunk in document.chunk_slices_in_range(range.clone()) {
        let end = offset + chunk.len();
        if text.get(offset..end) != Some(chunk) {
            return false;
        }
        offset = end;
    }
    offset == text.len()
}

/// Data used across successive layout requests to gauge whether layout must be recomputed.
#[derive(Default, Clone)]
pub(super) struct EditableTextLayoutState {
    /// The last known size of the text, as generated during layout.
    pub size: Option<Size<Pixels>>,
    /// The full set of text and style inputs that affect shaping.
    pub cache_key: Option<EditableTextLayoutKey>,
}

/// Internal state/result after the element has recomputed layout.
#[derive(Default)]
pub(super) struct EditableTextLayoutResult {
    /// Whether the element supports multiple lines of text
    pub supports_multiline: bool,
    /// Whether the element is currently accepting inputs
    pub accepts_input: bool,
    /// The last seen scroll position and size of the element
    pub scroll_bounds: Bounds<Pixels>,
    /// The screen-space text viewport inside the element's padding.
    pub inner_bounds: Bounds<Pixels>,
    pub state: EditableTextLayoutState,
    /// The `ShapedLine` produced by the painter's `prepaint`.
    /// Cached so IME `bounds_for_range` / `character_index_for_point` can evaluate without re-shaping.
    pub lines: Arc<[TextLineSegment]>,
    pub paragraph_cache: ParagraphLayoutCache,
    pub line_height: Pixels,
    /// The next position the scroll view should move to.
    /// Set by the state in response to user actions.
    pub next_scroll_offset: Option<Point<Pixels>>,
}

/// A segment of text that is a single logical/document line but can take up multiple rows due to wrapping.
#[derive(Clone)]
pub(super) struct TextLineSegment {
    /// The utf8 byte range in the content string that this line covers.
    pub text_range: Range<usize>,
    /// The shaped and wrapped text for this line, if available.
    pub wrapped_line: Option<Arc<WrappedLine>>,

    /// The y-coordinate of this segment which can be multiplied by the line_height
    /// to get its pixel location relative to the bounds of the text area.
    pub pos_y: usize,
}

impl TextLineSegment {
    /// The number of visual lines this segment encapsulates,
    /// since it can occupy multiple rows due to wrapping.
    pub fn row_count(&self) -> usize {
        let count = self
            .wrapped_line
            .as_ref()
            .map(|line| line.wrap_boundaries().len());
        count.unwrap_or_default() + 1
    }

    /// Returns true if the line contains a given position (e.g. for finding the line containing the caret).
    /// If `includes_end` is true, the end of the line is treated as inclusive instead of exclusive.
    pub fn contains_position(&self, pos: usize, include_end: bool) -> bool {
        if self.text_range.is_empty() {
            return pos == self.text_range.start;
        }

        if include_end {
            (self.text_range.start..=self.text_range.end).contains(&pos)
        } else {
            self.text_range.contains(&pos)
        }
    }

    /// Returns the index of the character within this segment that is closest
    /// to the provided screen space position.
    /// The character index returned is in absolute space; it is not relative to this segment.
    pub fn character_index_at_point(&self, point: Point<Pixels>, line_height: Pixels) -> usize {
        let mut offset = 0usize;
        if !self.text_range.is_empty()
            && let Some(wrapped) = &self.wrapped_line
        {
            offset = wrapped
                .closest_index_for_position(point, line_height)
                .unwrap_or_else(|closest| closest)
                .min(wrapped.text.len());
        }
        self.text_range.start + offset
    }

    /// Returns the screen space position of the character at the position provided.
    /// The position of the character must be absolute to the string this segment
    /// partially represents, it is converted to a relative offset internally.
    pub fn position_for_index(
        &self,
        character_index: usize,
        line_height: Pixels,
    ) -> Option<Point<Pixels>> {
        let wrapped = self.wrapped_line.as_ref()?;
        // the position in the text relative to this line segment
        let relative_text_pos = character_index
            .saturating_sub(self.text_range.start)
            .min(wrapped.text.len());
        // the screen position of the character in this line segment
        wrapped.position_for_index(relative_text_pos, line_height)
    }
}
