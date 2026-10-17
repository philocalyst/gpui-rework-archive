use crate::{
    Font, LineLayout, Pixels, PlatformTextSystem, TextLayoutOptions, TextLayoutRequest, TextRun, px,
};
use std::{
    collections::{HashMap, HashSet, VecDeque},
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
};
use unicode_segmentation::UnicodeSegmentation;

/// Controls how continuation rows are indented after wrapping.
#[derive(Clone, Copy, Debug, Default, Eq, Hash, PartialEq)]
pub enum IndentAdjustment {
    /// Start continuation rows at column zero.
    NoIndent,
    /// Keep the leading whitespace of the original row.
    #[default]
    SameIndent,
    /// Add the requested number of space columns to the original leading indent.
    ExtraColumns(u32),
}

/// A text segment or an atomic inline element participating in line wrapping.
pub enum LineFragment<'a> {
    /// A text fragment consisting of characters.
    Text {
        /// Text content of this fragment.
        text: &'a str,
    },
    /// An atomic non-text element with a measured width.
    Element {
        /// Element width in logical pixels.
        width: Pixels,
        /// UTF-8 source length represented by the element.
        len_utf8: usize,
    },
}

impl<'a> LineFragment<'a> {
    /// Creates a text fragment.
    pub fn text(text: &'a str) -> Self {
        Self::Text { text }
    }

    /// Creates an atomic element fragment.
    pub fn element(width: Pixels, len_utf8: usize) -> Self {
        Self::Element { width, len_utf8 }
    }
}

/// A source byte boundary and the continuation indent to use after it.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Boundary {
    /// UTF-8 byte offset in the original fragment sequence.
    pub ix: usize,
    /// Continuation indent in measured space columns.
    pub next_indent: u32,
}

#[derive(Clone)]
struct SourceSegment {
    backend: std::ops::Range<usize>,
    source_start: usize,
    element_width: Option<Pixels>,
}

struct Item {
    start: usize,
    width: Pixels,
    text: String,
    element: bool,
    column: usize,
}

const LAYOUT_CACHE_CAPACITY: usize = 4;

/// Wraps source fragments using cluster geometry from one full backend layout.
pub struct LineWrapper {
    text_system: Arc<dyn PlatformTextSystem>,
    font: Font,
    font_size: Pixels,
    generation: Arc<AtomicUsize>,
    seen_generation: usize,
    layouts: HashMap<String, Arc<LineLayout>>,
    layout_order: VecDeque<String>,
}

impl LineWrapper {
    /// Maximum continuation indent emitted by wrap_line, in measured space columns.
    pub const MAX_INDENT: u32 = 256;

    pub(crate) fn new(
        text_system: Arc<dyn PlatformTextSystem>,
        font: Font,
        font_size: Pixels,
        generation: Arc<AtomicUsize>,
    ) -> Self {
        let seen_generation = generation.load(Ordering::Acquire);
        Self {
            text_system,
            font,
            font_size,
            generation,
            seen_generation,
            layouts: HashMap::new(),
            layout_order: VecDeque::new(),
        }
    }

    /// Returns wrap points for the complete input, measured in its original UTF-8 bytes.
    ///
    /// Text is shaped as one complete document so ligatures, kerning, Arabic joining, bidi
    /// ordering, and fallback selection remain backend-owned. Atomic elements are represented
    /// by object-replacement placeholders for shaping and their supplied widths replace the
    /// placeholder advances. Boundaries are emitted only between both backend clusters and
    /// Unicode grapheme clusters.
    pub fn wrap_line<'a>(
        &'a mut self,
        fragments: &'a [LineFragment<'a>],
        wrap_width: Pixels,
        indent: IndentAdjustment,
    ) -> std::vec::IntoIter<Boundary> {
        let mut backend_text = String::new();
        let mut source_segments: Vec<SourceSegment> = Vec::with_capacity(fragments.len());
        let mut source_byte = 0usize;
        for fragment in fragments {
            match fragment {
                LineFragment::Text { text } if !text.is_empty() => {
                    let start = backend_text.len();
                    backend_text.push_str(text);
                    if let Some(previous) = source_segments.last_mut()
                        && previous.element_width.is_none()
                        && previous.backend.end == start
                    {
                        previous.backend.end = backend_text.len();
                    } else {
                        source_segments.push(SourceSegment {
                            backend: start..backend_text.len(),
                            source_start: source_byte,
                            element_width: None,
                        });
                    }
                    source_byte += text.len();
                }
                LineFragment::Text { .. } => {}
                LineFragment::Element { width, len_utf8 } => {
                    let start = backend_text.len();
                    backend_text.push('\u{fffc}');
                    source_segments.push(SourceSegment {
                        backend: start..backend_text.len(),
                        source_start: source_byte,
                        element_width: Some(*width),
                    });
                    source_byte = source_byte.saturating_add(*len_utf8);
                }
            }
        }

        let layout = self.layout_for(&backend_text);
        let mut native_clusters = Vec::new();
        let mut backend_index = 0usize;
        while backend_index < backend_text.len() {
            let normalized = layout.platform_layout.normalized_caret(
                crate::CaretPosition::attached_to_next_cluster(backend_index),
            );
            assert_eq!(
                normalized.index, backend_index,
                "backend cluster traversal did not begin at a normalized caret"
            );
            let cluster = layout
                .platform_layout
                .logical_cluster_after(normalized)
                .filter(|range| range.start == backend_index && range.end > backend_index)
                .expect("backend must expose the next logical cluster");
            native_clusters.push(cluster.clone());
            backend_index = cluster.end;
        }

        // Some test/native backends expose character stops rather than grapheme stops. A safe
        // cut must be a boundary in both sets: the intersection keeps ligatures and backend
        // clusters intact while also keeping combining and emoji ZWJ graphemes atomic.
        let mut grapheme_boundaries = HashSet::from([0, backend_text.len()]);
        for (start, grapheme) in backend_text.grapheme_indices(true) {
            grapheme_boundaries.insert(start);
            grapheme_boundaries.insert(start + grapheme.len());
        }
        let mut safe_clusters = Vec::new();
        let mut group_start = 0usize;
        let mut group_end = 0usize;
        for native in native_clusters {
            assert_eq!(
                native.start, group_end,
                "backend clusters must be contiguous"
            );
            group_end = native.end;
            if grapheme_boundaries.contains(&group_end) {
                safe_clusters.push(group_start..group_end);
                group_start = group_end;
            }
        }
        assert_eq!(
            group_start,
            backend_text.len(),
            "backend cluster and grapheme boundaries did not cover the full text"
        );

        let line_height = layout.ascent + layout.descent;
        let mut items = Vec::with_capacity(safe_clusters.len());
        let mut segment_index = 0;
        for cluster in safe_clusters {
            while source_segments
                .get(segment_index)
                .is_some_and(|segment| segment.backend.end <= cluster.start)
            {
                segment_index += 1;
            }
            let segment = source_segments
                .get(segment_index)
                .filter(|segment| {
                    segment.backend.start <= cluster.start && cluster.end <= segment.backend.end
                })
                .expect("shaped cluster must belong to one source segment");
            let (start, width, text, element) = if let Some(element_width) = segment.element_width {
                assert_eq!(
                    cluster, segment.backend,
                    "inline placeholder must be atomic"
                );
                (segment.source_start, element_width, String::new(), true)
            } else {
                let text = backend_text
                    .get(cluster.clone())
                    .expect("backend cluster must be a UTF-8 range")
                    .to_owned();
                let source_start = segment.source_start + cluster.start - segment.backend.start;
                let width = layout
                    .platform_layout
                    .selection_bounds(cluster, line_height)
                    .iter()
                    .map(|bounds| bounds.size.width)
                    .sum();
                (source_start, width, text, false)
            };
            items.push(Item {
                start,
                width,
                text,
                element,
                column: items.len(),
            });
        }

        // Only the space advance is measured separately; source cluster widths above all come
        // from the single full-text backend layout.
        let space = self.cluster_width(" ");
        let mut out = Vec::new();
        let mut width = px(0.);
        let mut first_nonwhite = None;
        let mut base_indent = None;
        let mut last_candidate = 0usize;
        let mut last_candidate_column = 0usize;
        let mut last_candidate_width = px(0.);
        let mut last_wrap = 0usize;
        let mut last_wrap_column = 0usize;
        let mut prev_space = false;
        for item in items {
            if item.text.contains('\n') {
                continue;
            }
            let is_space = !item.element && item.text.chars().all(char::is_whitespace);
            let is_word = !item.element
                && item
                    .text
                    .chars()
                    .any(|c| c.is_alphanumeric() || c == '_' || c == '\'');
            let is_cjk = !item.element
                && item.text.chars().any(|c| {
                    matches!(
                        c,
                        '\u{2e80}'..='\u{9fff}'
                            | '\u{f900}'..='\u{faff}'
                            | '\u{20000}'..='\u{3134f}'
                    )
                });
            if first_nonwhite.is_some()
                && ((prev_space && is_word) || (is_cjk && !is_space) || (!is_word && !is_space))
            {
                last_candidate = item.start;
                last_candidate_column = item.column;
                last_candidate_width = width;
            }
            if !is_space && first_nonwhite.is_none() {
                first_nonwhite = Some(item.column);
            }
            width += item.width;
            if width > wrap_width && item.start > last_wrap {
                let use_candidate =
                    last_candidate > last_wrap && width - last_candidate_width <= wrap_width;
                let carried = if use_candidate {
                    width - last_candidate_width
                } else {
                    item.width
                };
                if base_indent.is_none() {
                    base_indent = first_nonwhite.map(|first| {
                        Self::MAX_INDENT.min(first.saturating_sub(last_wrap_column) as u32)
                    });
                }
                let indent_columns = match indent {
                    IndentAdjustment::NoIndent => 0,
                    IndentAdjustment::SameIndent => base_indent.unwrap_or(0),
                    IndentAdjustment::ExtraColumns(extra) => {
                        if let Some(base) = base_indent {
                            let candidate = base.saturating_add(extra);
                            let reserve = carried.max(space * 2.);
                            if space * candidate as f32 + reserve > wrap_width {
                                0
                            } else {
                                Self::MAX_INDENT.min(candidate)
                            }
                        } else {
                            0
                        }
                    }
                };
                if use_candidate {
                    last_wrap = last_candidate;
                    last_wrap_column = last_candidate_column;
                    width -= last_candidate_width;
                } else {
                    last_wrap = item.start;
                    last_wrap_column = item.column;
                    width = item.width;
                }
                out.push(Boundary {
                    ix: last_wrap,
                    next_indent: indent_columns,
                });
                last_candidate = 0;
                width += space * indent_columns as f32;
                first_nonwhite = None;
            }
            prev_space = is_space;
        }
        out.into_iter()
    }

    fn layout_for(&mut self, text: &str) -> Arc<LineLayout> {
        let generation = self.generation.load(Ordering::Acquire);
        if generation != self.seen_generation {
            self.layouts.clear();
            self.layout_order.clear();
            self.seen_generation = generation;
        }
        if let Some(layout) = self.layouts.get(text) {
            return layout.clone();
        }
        let runs = [TextRun {
            len: text.len(),
            font: self.font.clone(),
            ..Default::default()
        }];
        let layout = Arc::new(self.text_system.layout_text(TextLayoutRequest {
            text,
            font_size: self.font_size,
            runs: &runs,
            options: TextLayoutOptions::default(),
        }));
        let key = text.to_owned();
        if self.layouts.len() == LAYOUT_CACHE_CAPACITY
            && let Some(expired) = self.layout_order.pop_front()
        {
            self.layouts.remove(&expired);
        }
        self.layout_order.push_back(key.clone());
        self.layouts.insert(key, layout.clone());
        layout
    }

    fn cluster_width(&mut self, text: &str) -> Pixels {
        let layout = self.layout_for(text);
        layout
            .platform_layout
            .selection_bounds(0..text.len(), layout.ascent + layout.descent)
            .iter()
            .map(|bounds| bounds.size.width)
            .sum()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{TestTextSystem, font};

    fn wrapper() -> LineWrapper {
        LineWrapper::new(
            Arc::new(TestTextSystem),
            font("Lilex"),
            px(12.),
            Arc::new(AtomicUsize::new(0)),
        )
    }

    #[test]
    fn continuation_indent_modes_use_measured_space_columns() {
        let text = "   abcdefghijklmnopqrstuvwxyz";
        let fragment = [LineFragment::text(text)];
        let mut measure = wrapper();
        let width = measure.cluster_width(" ") * 10.0;
        let same = measure
            .wrap_line(&fragment, width, IndentAdjustment::SameIndent)
            .collect::<Vec<_>>();
        assert!(!same.is_empty());
        assert_eq!(same[0].next_indent, 3);
        let no_indent = measure
            .wrap_line(&fragment, width, IndentAdjustment::NoIndent)
            .collect::<Vec<_>>();
        assert_eq!(no_indent[0].next_indent, 0);
        let extra = measure
            .wrap_line(&fragment, width, IndentAdjustment::ExtraColumns(2))
            .collect::<Vec<_>>();
        assert_eq!(extra[0].next_indent, 5);
        assert!(text.is_char_boundary(same[0].ix));
    }

    #[test]
    fn cjk_and_emoji_boundaries_are_backend_cluster_safe() {
        let text = "你好👩‍👩‍👧‍👦世界";
        let fragment = [LineFragment::text(text)];
        let mut wrapper = wrapper();
        let width = wrapper.cluster_width("你") * 1.25;
        let boundaries = wrapper
            .wrap_line(&fragment, width, IndentAdjustment::NoIndent)
            .collect::<Vec<_>>();
        assert!(!boundaries.is_empty());
        assert!(
            boundaries
                .iter()
                .all(|boundary| text.is_char_boundary(boundary.ix))
        );
        assert!(
            boundaries
                .iter()
                .all(|boundary| boundary.ix != text.find('👩').unwrap() + '👩'.len_utf8())
        );
    }

    #[test]
    fn full_document_layout_cache_is_bounded_reuses_hits_and_resets_on_font_change() {
        let mut wrapper = wrapper();
        for index in 0..12 {
            let document = format!("document {index}");
            wrapper.layout_for(&document);
        }
        assert_eq!(wrapper.layouts.len(), LAYOUT_CACHE_CAPACITY);
        assert_eq!(wrapper.layout_order.len(), LAYOUT_CACHE_CAPACITY);

        let document = "recent document";
        let first = wrapper.layout_for(document);
        let hit = wrapper.layout_for(document);
        assert!(
            Arc::ptr_eq(&first, &hit),
            "cached documents should be reused"
        );

        wrapper.generation.fetch_add(1, Ordering::AcqRel);
        let after_font_change = wrapper.layout_for(document);
        assert!(!Arc::ptr_eq(&hit, &after_font_change));
        assert_eq!(wrapper.layouts.len(), 1);
        assert_eq!(wrapper.layout_order.len(), 1);
    }

    #[test]
    fn wraps_ascii_at_word_boundaries_with_original_byte_offsets() {
        let text = "aa bb cc";
        let fragment = [LineFragment::text(text)];
        let mut wrapper = wrapper();
        let width = wrapper.cluster_width(" ") * 4.0;
        let boundaries = wrapper
            .wrap_line(&fragment, width, IndentAdjustment::NoIndent)
            .collect::<Vec<_>>();

        assert_eq!(
            boundaries
                .iter()
                .map(|boundary| boundary.ix)
                .collect::<Vec<_>>(),
            vec![3, 6]
        );
        assert_eq!(&text[..boundaries[0].ix], "aa ");
        assert_eq!(&text[boundaries[0].ix..boundaries[1].ix], "bb ");
    }

    #[test]
    fn atomic_element_uses_caller_width_and_source_byte_length() {
        let fragments = [
            LineFragment::text("a"),
            LineFragment::element(px(100.), 7),
            LineFragment::text("b"),
        ];
        let mut wrapper = wrapper();
        let boundaries = wrapper
            .wrap_line(&fragments, px(20.), IndentAdjustment::NoIndent)
            .collect::<Vec<_>>();
        assert_eq!(boundaries.first().map(|b| b.ix), Some(1));
        assert_eq!(
            boundaries.iter().map(|b| b.ix).collect::<Vec<_>>(),
            vec![1, 8]
        );
    }
}
