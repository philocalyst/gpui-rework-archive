//! Native navigation over a persistent [`Document`](super::document::Document).

use std::ops::Range;

use gpui::NavigationDirection;
use sum_tree::Bias;
use unicode_segmentation::{GraphemeCursor, GraphemeIncomplete, UnicodeSegmentation};

use crate::editable_text::TextBoundary;

use super::document::Document;

/// Finds a caret destination without materializing the document as a contiguous string.
pub(crate) fn offset_from_caret(
    document: &Document,
    caret: usize,
    direction: NavigationDirection,
    boundary: TextBoundary,
) -> usize {
    let caret = document.clamp_byte_offset(caret);
    match (direction, boundary) {
        (NavigationDirection::Back, TextBoundary::Graphmeme) => {
            previous_grapheme_boundary(document, caret)
        }
        (NavigationDirection::Forward, TextBoundary::Graphmeme) => {
            next_grapheme_boundary(document, caret)
        }
        (NavigationDirection::Back, TextBoundary::Word) => previous_word_start(document, caret),
        (NavigationDirection::Forward, TextBoundary::Word) => next_word_end(document, caret),
        (NavigationDirection::Back, TextBoundary::Line) => {
            document
                .line_range(document.line_index(caret))
                .unwrap()
                .start
        }
        (NavigationDirection::Forward, TextBoundary::Line) => {
            document.line_range(document.line_index(caret)).unwrap().end
        }
        (NavigationDirection::Back, TextBoundary::Document) => 0,
        (NavigationDirection::Forward, TextBoundary::Document) => document.len_bytes(),
    }
}

/// Returns the range of the Unicode word touching `position`, when one exists.
pub(crate) fn word_range_at(document: &Document, position: usize) -> Range<usize> {
    let position = document.clamp_byte_offset(position);
    let line = document.line_range(document.line_index(position)).unwrap();
    let text = document.slice(line.clone());

    for (start, word) in text.unicode_word_indices() {
        let word_start = line.start + start;
        let word_end = word_start + word.len();
        if word_start <= position && position <= word_end {
            return word_start..word_end;
        }
    }

    position..position
}

fn next_grapheme_boundary(document: &Document, caret: usize) -> usize {
    let len = document.len_bytes();
    if caret >= len {
        return len;
    }

    let Some((mut chunk, mut chunk_start)) = document.chunk_at_byte(caret, Bias::Right) else {
        return len;
    };
    let mut cursor = GraphemeCursor::new(caret, len, true);

    loop {
        match cursor.next_boundary(chunk, chunk_start) {
            Ok(Some(boundary)) => return boundary,
            Ok(None) => return len,
            Err(GraphemeIncomplete::NextChunk) => {
                let next_start = chunk_start + chunk.len();
                let Some((next_chunk, actual_start)) =
                    document.chunk_at_byte(next_start, Bias::Right)
                else {
                    return len;
                };
                if actual_start < next_start || actual_start <= chunk_start {
                    return len;
                }
                chunk = next_chunk;
                chunk_start = actual_start;
            }
            Err(GraphemeIncomplete::PreContext(offset)) => {
                let Some((context, context_start)) = context_ending_at(document, offset) else {
                    return len;
                };
                cursor.provide_context(context, context_start);
            }
            Err(GraphemeIncomplete::PrevChunk | GraphemeIncomplete::InvalidOffset) => return len,
        }
    }
}

fn previous_grapheme_boundary(document: &Document, caret: usize) -> usize {
    if caret == 0 {
        return 0;
    }

    let Some((mut chunk, mut chunk_start)) = document.chunk_at_byte(caret, Bias::Left) else {
        return 0;
    };
    let mut cursor = GraphemeCursor::new(caret, document.len_bytes(), true);

    loop {
        match cursor.prev_boundary(chunk, chunk_start) {
            Ok(Some(boundary)) => return boundary,
            Ok(None) => return 0,
            Err(GraphemeIncomplete::PrevChunk) => {
                let Some((previous_chunk, previous_start)) =
                    document.chunk_at_byte(chunk_start, Bias::Left)
                else {
                    return 0;
                };
                if previous_start >= chunk_start {
                    return 0;
                }
                chunk = previous_chunk;
                chunk_start = previous_start;
            }
            Err(GraphemeIncomplete::PreContext(offset)) => {
                let Some((context, context_start)) = context_ending_at(document, offset) else {
                    return 0;
                };
                cursor.provide_context(context, context_start);
            }
            Err(GraphemeIncomplete::NextChunk | GraphemeIncomplete::InvalidOffset) => return 0,
        }
    }
}

/// Supplies GraphemeCursor with a nonempty piece of text ending at its requested context offset.
fn context_ending_at(document: &Document, offset: usize) -> Option<(&str, usize)> {
    if offset == 0 {
        return None;
    }
    let (chunk, chunk_start) = document.chunk_at_byte(offset, Bias::Left)?;
    let end = offset.checked_sub(chunk_start)?;
    if end == 0 || end > chunk.len() || !chunk.is_char_boundary(end) {
        return None;
    }
    Some((&chunk[..end], chunk_start))
}

fn next_word_end(document: &Document, caret: usize) -> usize {
    let mut line_index = document.line_index(caret);
    let line_count = document.line_count();

    while line_index < line_count {
        let line = document.line_range(line_index).unwrap();
        let start = caret.max(line.start);
        let text = document.slice(start..line.end);
        if let Some((word_start, word)) = text.unicode_word_indices().next() {
            return start + word_start + word.len();
        }
        line_index += 1;
    }

    document.len_bytes()
}

fn previous_word_start(document: &Document, caret: usize) -> usize {
    let mut line_index = document.line_index(caret);
    loop {
        let line = document.line_range(line_index).unwrap();
        let end = caret.min(line.end);
        let text = document.slice(line.start..end);
        if let Some((word_start, _)) = text.unicode_word_indices().next_back() {
            return line.start + word_start;
        }
        if line_index == 0 {
            return 0;
        }
        line_index -= 1;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::editable_text::{StringStorage, UnicodeTextStorage};

    fn document_with_seam(cluster: &str, prefix_len: usize) -> Document {
        let prefix = "a".repeat(prefix_len);
        let suffix_len = 4096usize.saturating_sub(prefix.len() + cluster.len());
        let text = format!("{prefix}{cluster}{}", "b".repeat(suffix_len));
        let document = Document::new(text);
        assert_eq!(document.chunk_count(), 2);
        assert_eq!(
            document.chunk_byte_lengths().collect::<Vec<_>>(),
            [2048, 2048]
        );
        document
    }

    fn assert_grapheme_navigation_matches_string(document: &Document) {
        let text = document.as_str();
        let storage = StringStorage::from(text.to_owned());
        let mut boundaries: Vec<_> = text
            .grapheme_indices(true)
            .map(|(index, _)| index)
            .collect();
        boundaries.push(text.len());

        for &caret in &boundaries {
            assert_eq!(
                offset_from_caret(
                    document,
                    caret,
                    NavigationDirection::Back,
                    TextBoundary::Graphmeme,
                ),
                storage.offset_from_caret(
                    caret,
                    NavigationDirection::Back,
                    TextBoundary::Graphmeme,
                ),
                "backward grapheme navigation at {caret}"
            );
            assert_eq!(
                offset_from_caret(
                    document,
                    caret,
                    NavigationDirection::Forward,
                    TextBoundary::Graphmeme,
                ),
                storage.offset_from_caret(
                    caret,
                    NavigationDirection::Forward,
                    TextBoundary::Graphmeme,
                ),
                "forward grapheme navigation at {caret}"
            );
        }

        for pair in boundaries.windows(2) {
            let start = pair[0];
            let end = pair[1];
            assert_eq!(
                offset_from_caret(
                    document,
                    start,
                    NavigationDirection::Forward,
                    TextBoundary::Graphmeme,
                ),
                end,
                "forward/backward round trip starts at {start}"
            );
            assert_eq!(
                offset_from_caret(
                    document,
                    end,
                    NavigationDirection::Back,
                    TextBoundary::Graphmeme,
                ),
                start,
                "backward/forward round trip ends at {end}"
            );
        }
    }

    #[test]
    fn grapheme_navigation_matches_string_storage_across_chunk_seams() {
        let cases = [
            ("e\u{301}", 2047),
            ("👩\u{200d}💻", 2044),
            ("🇺🇸🇨🇦", 2044),
            ("\r\n", 2047),
        ];

        for (cluster, prefix_len) in cases {
            let document = document_with_seam(cluster, prefix_len);
            assert_grapheme_navigation_matches_string(&document);
        }
    }

    #[test]
    fn grapheme_navigation_handles_long_regional_indicator_runs() {
        let flags = "🇺".repeat(900);
        let text = format!("{}{}{}", "x".repeat(1500), flags, "y".repeat(1000));
        let document = Document::new(text);
        assert_grapheme_navigation_matches_string(&document);
    }

    #[test]
    fn grapheme_navigation_clamps_offsets_inside_scalars() {
        let document = Document::new(format!("{}🙂e\u{301}", "x".repeat(2046)));
        for offset in 0..=document.len_bytes() {
            if document.is_char_boundary(offset) {
                continue;
            }
            let clamped = document.clamp_byte_offset(offset);
            for direction in [NavigationDirection::Back, NavigationDirection::Forward] {
                assert_eq!(
                    offset_from_caret(&document, offset, direction, TextBoundary::Graphmeme,),
                    offset_from_caret(&document, clamped, direction, TextBoundary::Graphmeme,)
                );
            }
        }
    }

    #[test]
    fn word_navigation_matches_string_storage_by_lines() {
        let text = format!(
            "{}\r\n  cafe\u{301}  👩\u{200d}💻\n\nlast_word  ",
            "x".repeat(2050)
        );
        let document = Document::new(text.clone());
        let storage = StringStorage::from(text);

        let mut positions: Vec<_> = document
            .as_str()
            .char_indices()
            .map(|(position, _)| position)
            .collect();
        positions.push(document.len_bytes());
        for caret in positions {
            for direction in [NavigationDirection::Back, NavigationDirection::Forward] {
                assert_eq!(
                    offset_from_caret(&document, caret, direction, TextBoundary::Word),
                    storage.offset_from_caret(caret, direction, TextBoundary::Word),
                    "word navigation at {caret} toward {direction:?}"
                );
            }
            assert_eq!(
                word_range_at(&document, caret),
                storage.word_range_at(caret),
                "word range at {caret}"
            );
        }
    }
}
