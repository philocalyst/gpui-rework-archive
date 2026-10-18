use crate::canvas_fallback::{CanvasFontFallback, classify_canvas_fallback};
use gpui::FontId;
use std::ops::Range;
use unicode_segmentation::UnicodeSegmentation;

/// One glyph's exact source ownership as emitted by a modern platform text layout.
#[derive(Clone, Debug, Eq, PartialEq)]
pub(crate) struct GlyphRecord {
    pub(crate) source: Range<usize>,
    pub(crate) font_id: FontId,
    pub(crate) source_run: usize,
    pub(crate) line_index: usize,
    pub(crate) missing: bool,
    pub(crate) native_color: bool,
    /// Paint-fragment provenance for aggregate shaping-cluster ownership.
    pub(crate) fragment_index: usize,
    pub(crate) fragment_source: Range<usize>,
    /// Set only by Parley provenance for its internally injected root bidi control.
    pub(crate) synthetic_root_control: bool,
}

/// A complete grapheme whose glyphs can be replaced with one independent Canvas draw.
#[derive(Clone, Debug, Eq, PartialEq)]
pub(crate) struct Candidate {
    pub(crate) source: Range<usize>,
    pub(crate) font_id: FontId,
    pub(crate) source_run: usize,
    pub(crate) line_index: usize,
    pub(crate) color: bool,
    /// Indices into the input stream, kept in visual order.
    pub(crate) glyph_records: Vec<usize>,
}

fn has_supported_leading_scalar_emoji_sequence(
    grapheme: &str,
    fallback: crate::canvas_fallback::CanvasFallback,
) -> bool {
    if !fallback.is_emoji || !fallback.emoji_presentation {
        return false;
    }
    let mut chars = grapheme.chars();
    let Some(first) = chars.next() else {
        return false;
    };
    let suffix = chars.as_str();
    let modifier = matches!(
        suffix,
        "\u{1f3fb}"
            | "\u{fe0f}\u{1f3fb}"
            | "\u{1f3fc}"
            | "\u{fe0f}\u{1f3fc}"
            | "\u{1f3fd}"
            | "\u{fe0f}\u{1f3fd}"
            | "\u{1f3fe}"
            | "\u{fe0f}\u{1f3fe}"
            | "\u{1f3ff}"
            | "\u{fe0f}\u{1f3ff}"
    );
    let flag = unicode_properties::emoji::is_regional_indicator(first)
        && suffix.chars().count() == 1
        && suffix
            .chars()
            .next()
            .is_some_and(unicode_properties::emoji::is_regional_indicator);
    let keycap =
        matches!(first, '0'..='9' | '#' | '*') && matches!(suffix, "\u{20e3}" | "\u{fe0f}\u{20e3}");
    modifier || flag || keycap
}

/// Groups only complete graphemes with exact, single-font and single-line glyph ownership.
pub(crate) fn collect_candidates(
    text: &str,
    glyphs: &[GlyphRecord],
    policy: CanvasFontFallback,
) -> Vec<Candidate> {
    let mut candidates = Vec::new();
    for (start, grapheme) in text.grapheme_indices(true) {
        let Some(fallback) = classify_canvas_fallback(grapheme) else {
            continue;
        };
        if !policy.allows(fallback.is_emoji) {
            continue;
        }

        let source = start..start + grapheme.len();
        let overlapping_fragments = glyphs
            .iter()
            .filter(|glyph| {
                glyph.fragment_source.start < source.end && source.start < glyph.fragment_source.end
            })
            .map(|glyph| glyph.fragment_index)
            .collect::<std::collections::HashSet<_>>();
        if overlapping_fragments.len() != 1 {
            continue;
        }
        let fragment_index = *overlapping_fragments.iter().next().unwrap();
        let fragment_records = glyphs
            .iter()
            .enumerate()
            .filter(|(_, glyph)| glyph.fragment_index == fragment_index)
            .collect::<Vec<_>>();
        if fragment_records
            .iter()
            .any(|(_, glyph)| glyph.source.is_empty() && !glyph.synthetic_root_control)
        {
            continue;
        }
        let indices = fragment_records
            .iter()
            .filter_map(|(index, glyph)| {
                let overlaps = glyph.source.start < source.end && source.start < glyph.source.end;
                if overlaps && (glyph.source.start < source.start || glyph.source.end > source.end)
                {
                    return Some(usize::MAX);
                }
                overlaps.then_some(*index)
            })
            .collect::<Vec<_>>();
        if indices.contains(&usize::MAX) {
            continue;
        }
        let indices = indices;
        let Some(&first_index) = indices.first() else {
            continue;
        };
        let first = &glyphs[first_index];
        if indices.iter().any(|index| {
            let glyph = &glyphs[*index];
            glyph.font_id != first.font_id
                || glyph.source_run != first.source_run
                || glyph.line_index != first.line_index
        }) {
            continue;
        }

        // Some shapers expose one leading-scalar range for every glyph produced by an
        // Extended_Pictographic ZWJ sequence. Keep those exact ranges, and only accept the
        // aggregate when the supported grapheme classifier proved the complete sequence.
        let first_scalar_end = grapheme
            .chars()
            .next()
            .map_or(source.start, |ch| source.start + ch.len_utf8());
        let first_scalar = source.start..first_scalar_end;
        let repeated_leading_cluster_ownership = indices.len() >= 2
            && fragment_records
                .iter()
                .filter(|(_, glyph)| {
                    glyph.source.start < source.end && source.start < glyph.source.end
                })
                .count()
                == indices.len()
            && indices.iter().all(|index| {
                let glyph = &glyphs[*index];
                glyph.source == first_scalar
                    && glyph.source.start >= source.start
                    && glyph.source.end <= source.end
                    && glyph.fragment_source.start <= source.start
                    && source.end <= glyph.fragment_source.end
            })
            && !glyphs.iter().any(|glyph| {
                glyph.fragment_index != fragment_index
                    && glyph.source.start < source.end
                    && source.start < glyph.source.end
            });
        let zwj_cluster_ownership = fallback.is_emoji
            && fallback.emoji_presentation
            && grapheme.contains('\u{200d}')
            && repeated_leading_cluster_ownership;
        let structured_emoji_cluster_ownership =
            has_supported_leading_scalar_emoji_sequence(grapheme, fallback)
                && repeated_leading_cluster_ownership;

        // Parley can also map a shaping cluster to its leading scalar when a paint fragment
        // spans neighboring graphemes. Accept that only when the fragment itself owns exactly
        // this grapheme and all its glyphs are contained. Otherwise require exact byte coverage
        // except for FE0E/FE0F selector bytes.
        let aggregate_ownership = fragment_records.len() == indices.len()
            && fragment_records.iter().all(|(_, glyph)| {
                glyph.fragment_source == source
                    && !glyph.source.is_empty()
                    && glyph.source.start >= source.start
                    && glyph.source.end <= source.end
            });
        if !(aggregate_ownership || zwj_cluster_ownership || structured_emoji_cluster_ownership) {
            let mut covered = vec![false; grapheme.len()];
            for index in &indices {
                let range = &glyphs[*index].source;
                for byte in range.start - source.start..range.end - source.start {
                    covered[byte] = true;
                }
            }
            let mut byte = 0;
            let mut valid = true;
            for ch in grapheme.chars() {
                let char_end = byte + ch.len_utf8();
                if covered[byte..char_end].iter().any(|covered| !covered)
                    && !matches!(ch, '\u{fe0e}' | '\u{fe0f}')
                {
                    valid = false;
                    break;
                }
                byte = char_end;
            }
            if !valid {
                continue;
            }
        }
        let missing = indices.iter().any(|index| glyphs[*index].missing);
        let wrong_presentation = if fallback.emoji_presentation {
            indices.iter().any(|index| !glyphs[*index].native_color)
        } else {
            indices.iter().any(|index| glyphs[*index].native_color)
        };
        if !(missing || wrong_presentation) {
            continue;
        }
        candidates.push(Candidate {
            source,
            font_id: first.font_id,
            source_run: first.source_run,
            line_index: first.line_index,
            color: fallback.emoji_presentation,
            glyph_records: indices,
        });
    }

    candidates
}

/// Decide whether a relaid-out glyph is safely hidden under a full-grapheme Canvas overlay.
pub(crate) fn replacement_glyph_is_suppressed(
    range: &Range<usize>,
    replacements: &[Range<usize>],
) -> Result<bool, ()> {
    if range.start > range.end {
        return Err(());
    }
    for replacement in replacements {
        if range.is_empty() {
            if replacement.start <= range.start && range.start <= replacement.end {
                return Err(());
            }
        } else if range.start < replacement.end && replacement.start < range.end {
            if range.start >= replacement.start && range.end <= replacement.end {
                return Ok(true);
            }
            return Err(());
        }
    }
    Ok(false)
}

/// Return complete Unicode grapheme ranges touched by exact shaping-cluster ranges.
pub(crate) fn graphemes_intersecting_ranges(
    text: &str,
    ranges: &[Range<usize>],
) -> Vec<Range<usize>> {
    text.grapheme_indices(true)
        .filter_map(|(start, grapheme)| {
            let end = start + grapheme.len();
            ranges
                .iter()
                .any(|range| range.start < end && start < range.end)
                .then_some(start..end)
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn glyph(
        source: Range<usize>,
        font_id: usize,
        source_run: usize,
        line_index: usize,
        missing: bool,
        native_color: bool,
    ) -> GlyphRecord {
        GlyphRecord {
            source: source.clone(),
            font_id: FontId(font_id),
            source_run,
            line_index,
            missing,
            native_color,
            fragment_index: 0,
            fragment_source: source.clone(),
            synthetic_root_control: false,
        }
    }

    fn in_fragment(mut glyph: GlyphRecord, index: usize, source: Range<usize>) -> GlyphRecord {
        glyph.fragment_index = index;
        glyph.fragment_source = source;
        glyph
    }

    #[test]
    fn groups_full_extended_graphemes_and_preserves_exact_byte_ownership() {
        let text = "a👩‍💻中";
        let start = 1;
        let emoji_end = start + "👩‍💻".len();
        let glyphs = [
            glyph(start..emoji_end, 3, 0, 0, true, false),
            glyph(start..emoji_end, 3, 0, 0, true, false),
            glyph(emoji_end..text.len(), 3, 0, 0, true, false),
        ];
        let candidates = collect_candidates(text, &glyphs, CanvasFontFallback::EmojiAndCjk);
        assert_eq!(candidates.len(), 2);
        assert_eq!(candidates[0].source, start..emoji_end);
        assert_eq!(candidates[0].glyph_records, vec![0, 1]);
        assert_eq!(candidates[1].source, emoji_end..text.len());
        assert_eq!(candidates[1].glyph_records, vec![2]);
        assert!(
            candidates
                .windows(2)
                .all(|pair| pair[0].source.end <= pair[1].source.start)
        );
    }

    #[test]
    fn keeps_visual_bidi_record_order_without_reversing_source_ranges() {
        let text = "😀中";
        let glyphs = [
            glyph(4..7, 7, 0, 0, true, false),
            glyph(0..4, 7, 0, 0, true, false),
        ];
        let candidates = collect_candidates(text, &glyphs, CanvasFontFallback::EmojiAndCjk);
        assert_eq!(candidates.len(), 2);
        assert_eq!(candidates[0].source, 0..4);
        assert_eq!(candidates[0].glyph_records, vec![1]);
        assert_eq!(candidates[1].source, 4..7);
        assert_eq!(candidates[1].glyph_records, vec![0]);
    }

    #[test]
    fn replaces_missing_or_wrong_color_presentation_only() {
        let text = "❤️😀";
        let first_end = "❤️".len();
        let glyphs = [
            glyph(0..first_end, 1, 0, 0, false, false),
            glyph(first_end..text.len(), 1, 0, 0, false, true),
        ];
        let candidates = collect_candidates(text, &glyphs, CanvasFontFallback::Emoji);
        assert_eq!(candidates.len(), 1);
        assert_eq!(candidates[0].source, 0..first_end);
        assert!(candidates[0].color);
    }

    #[test]
    fn rejects_cross_font_cross_run_and_cross_line_clusters() {
        let text = "👩‍💻";
        let end = text.len();
        for glyphs in [
            vec![
                glyph(0..end, 1, 0, 0, true, false),
                glyph(0..end, 2, 0, 0, true, false),
            ],
            vec![
                glyph(0..end, 1, 0, 0, true, false),
                glyph(0..end, 1, 1, 0, true, false),
            ],
            vec![
                glyph(0..end, 1, 0, 0, true, false),
                glyph(0..end, 1, 0, 1, true, false),
            ],
        ] {
            assert!(collect_candidates(text, &glyphs, CanvasFontFallback::Emoji).is_empty());
        }
    }

    #[test]
    fn missing_cluster_ranges_report_their_complete_unicode_graphemes() {
        let text = "A👨‍👩‍👧‍👦か\u{3099}Z";
        let family_start = text.find("👨").unwrap();
        let family_end = family_start + "👨‍👩‍👧‍👦".len();
        let kana_start = text.find("か").unwrap();
        let z_start = text.find("Z").unwrap();
        assert_eq!(
            graphemes_intersecting_ranges(
                text,
                &[
                    family_start..family_start + "👨".len(),
                    kana_start..kana_start + "か".len()
                ],
            ),
            vec![family_start..family_end, kana_start..z_start],
        );
    }

    #[test]
    fn rejects_partial_glyph_ownership_and_disabled_candidates() {
        let text = "\u{1f468}\u{200d}\u{1f469}\u{200d}\u{1f467}\u{200d}\u{1f466}";
        let glyphs = [glyph(0..4, 1, 0, 0, true, false)];
        assert!(collect_candidates(text, &glyphs, CanvasFontFallback::Emoji).is_empty());
        let emoji = "😀";
        let glyphs = [glyph(0..emoji.len(), 1, 0, 0, true, false)];
        assert!(collect_candidates(emoji, &glyphs, CanvasFontFallback::Disabled).is_empty());
    }

    #[test]
    fn accepts_modifier_flag_and_keycap_leading_scalar_ownership() {
        for grapheme in ["👍🏽", "🇯🇵", "1️⃣"] {
            let text = format!("界{grapheme}中");
            let start = "界".len();
            let end = start + grapheme.len();
            let lead_end = start + grapheme.chars().next().unwrap().len_utf8();
            let records = (0..2)
                .map(|_| {
                    in_fragment(
                        glyph(start..lead_end, 9, 0, 0, true, false),
                        0,
                        0..text.len(),
                    )
                })
                .collect::<Vec<_>>();
            let candidates = collect_candidates(&text, &records, CanvasFontFallback::Emoji);
            assert_eq!(candidates.len(), 1, "{grapheme}");
            assert_eq!(candidates[0].source, start..end);
            assert_eq!(candidates[0].glyph_records, vec![0, 1]);
        }
    }

    #[test]
    fn rejects_ambiguous_structured_leading_scalar_ownership() {
        let text = "x👍🏽";
        let start = "x".len();
        let lead_end = start + '👍'.len_utf8();
        let source = start..text.len();
        let valid = || {
            (0..2)
                .map(|_| {
                    in_fragment(
                        glyph(start..lead_end, 4, 0, 0, true, false),
                        0,
                        0..text.len(),
                    )
                })
                .collect::<Vec<_>>()
        };
        let mut one = valid();
        one.truncate(1);
        assert!(collect_candidates(text, &one, CanvasFontFallback::Emoji).is_empty());

        let mut crossing = valid();
        crossing.push(in_fragment(
            glyph(start..text.len() + 1, 4, 0, 0, true, false),
            0,
            0..text.len() + 1,
        ));
        assert!(collect_candidates(text, &crossing, CanvasFontFallback::Emoji).is_empty());

        let mut competing = valid();
        competing.push(in_fragment(
            glyph(source.clone(), 5, 0, 0, true, false),
            1,
            source,
        ));
        assert!(collect_candidates(text, &competing, CanvasFontFallback::Emoji).is_empty());

        let mut mixed = valid();
        mixed[1].font_id = FontId(5);
        assert!(collect_candidates(text, &mixed, CanvasFontFallback::Emoji).is_empty());

        let unsupported = "\u{1f44d}\u{1f3fd}\u{200d}";
        let lead_end = char::from_u32(0x1f44d).unwrap().len_utf8();
        let rows = (0..2)
            .map(|_| {
                in_fragment(
                    glyph(0..lead_end, 4, 0, 0, true, false),
                    0,
                    0..unsupported.len(),
                )
            })
            .collect::<Vec<_>>();
        assert!(collect_candidates(unsupported, &rows, CanvasFontFallback::Emoji).is_empty());
    }

    #[test]
    fn accepts_leading_scalar_cluster_ownership_in_a_broad_fragment() {
        let family = "👨‍👩‍👧‍👦";
        let text = format!("界{family}😀");
        let family_start = "界".len();
        let family_end = family_start + family.len();
        let family_lead_end = family_start + '👨'.len_utf8();
        let records = [
            glyph(0.."界".len(), 3, 0, 0, true, false),
            glyph(family_start..family_lead_end, 3, 0, 0, true, false),
            glyph(family_start..family_lead_end, 3, 0, 0, false, false),
            glyph(family_start..family_lead_end, 3, 0, 0, true, false),
            glyph(family_start..family_lead_end, 3, 0, 0, false, false),
            glyph(family_start..family_lead_end, 3, 0, 0, true, false),
            glyph(family_end..text.len(), 3, 0, 0, true, false),
        ]
        .into_iter()
        .enumerate()
        .map(|(_index, glyph)| in_fragment(glyph, 0, 0..text.len()))
        .collect::<Vec<_>>();
        let candidates = collect_candidates(&text, &records, CanvasFontFallback::EmojiAndCjk);
        assert_eq!(candidates.len(), 3);
        assert_eq!(candidates[0].source, 0.."界".len());
        assert_eq!(candidates[0].glyph_records, vec![0]);
        assert_eq!(candidates[1].source, family_start..family_end);
        assert_eq!(candidates[1].glyph_records, vec![1, 2, 3, 4, 5]);
        assert_eq!(candidates[2].source, family_end..text.len());
        assert_eq!(candidates[2].glyph_records, vec![6]);
        assert!(
            records
                .iter()
                .all(|glyph| glyph.fragment_source == (0..text.len()))
        );
    }

    #[test]
    fn accepts_repeated_family_clusters_with_offset_specific_ownership() {
        let family = "👨‍👩‍👧‍👦";
        let text = format!("{family}{family}");
        let first_lead = 0..'👨'.len_utf8();
        let second_start = family.len();
        let second_lead = second_start..second_start + '👨'.len_utf8();
        let mut records = Vec::new();
        for source in [first_lead, second_lead] {
            for missing in [true, false, true] {
                records.push(in_fragment(
                    glyph(source.clone(), 5, 0, 0, missing, false),
                    0,
                    0..text.len(),
                ));
            }
        }
        let candidates = collect_candidates(&text, &records, CanvasFontFallback::Emoji);
        assert_eq!(candidates.len(), 2);
        assert_eq!(candidates[0].source, 0..family.len());
        assert_eq!(candidates[0].glyph_records, vec![0, 1, 2]);
        assert_eq!(candidates[1].source, second_start..text.len());
        assert_eq!(candidates[1].glyph_records, vec![3, 4, 5]);
    }

    #[test]
    fn rejects_ambiguous_or_inconsistent_zwj_cluster_ownership() {
        let family = "👨‍👩‍👧‍👦";
        let text = format!("{family}{family}");
        let first_lead = 0..'👨'.len_utf8();
        let first_end = family.len();
        let broad_fragment = 0..text.len();
        let valid = || {
            (0..3)
                .map(|_| {
                    in_fragment(
                        glyph(first_lead.clone(), 5, 0, 0, true, false),
                        0,
                        broad_fragment.clone(),
                    )
                })
                .collect::<Vec<_>>()
        };

        let mut one_record = valid();
        one_record.truncate(1);
        assert!(collect_candidates(&text, &one_record, CanvasFontFallback::Emoji).is_empty());

        let mut crossing = valid();
        crossing.push(in_fragment(
            glyph(0..first_end + 4, 5, 0, 0, true, false),
            0,
            broad_fragment.clone(),
        ));
        assert!(collect_candidates(&text, &crossing, CanvasFontFallback::Emoji).is_empty());

        let mut competing = valid();
        competing.push(in_fragment(
            glyph(0..4, 6, 0, 0, true, false),
            1,
            0..first_end,
        ));
        assert!(collect_candidates(&text, &competing, CanvasFontFallback::Emoji).is_empty());

        for (font_id, source_run, line_index) in [(6, 0, 0), (5, 1, 0), (5, 0, 1)] {
            let records = (0..3)
                .map(|index| {
                    in_fragment(
                        glyph(
                            first_lead.clone(),
                            if index == 0 { font_id } else { 5 },
                            if index == 1 { source_run } else { 0 },
                            if index == 2 { line_index } else { 0 },
                            true,
                            false,
                        ),
                        0,
                        broad_fragment.clone(),
                    )
                })
                .collect::<Vec<_>>();
            assert!(collect_candidates(&text, &records, CanvasFontFallback::Emoji).is_empty());
        }

        let mut escaped_fragment = valid();
        for glyph in &mut escaped_fragment {
            glyph.fragment_source = first_lead.clone();
        }
        assert!(collect_candidates(&text, &escaped_fragment, CanvasFontFallback::Emoji).is_empty());

        let mut empty = valid();
        empty.push(in_fragment(
            glyph(0..0, 5, 0, 0, true, false),
            0,
            broad_fragment,
        ));
        assert!(collect_candidates(&text, &empty, CanvasFontFallback::Emoji).is_empty());
    }

    #[test]
    fn accepts_only_parley_tagged_synthetic_root_empty_rows() {
        let text = "😀😀😀";
        let mut rows = vec![
            in_fragment(glyph(0..0, 5, 0, 0, false, false), 0, 0..text.len()),
            in_fragment(glyph(0..4, 5, 0, 0, true, false), 0, 0..text.len()),
            in_fragment(glyph(4..8, 5, 0, 0, true, false), 0, 0..text.len()),
            in_fragment(glyph(8..12, 5, 0, 0, true, false), 0, 0..text.len()),
        ];
        rows[0].synthetic_root_control = true;
        let candidates = collect_candidates(text, &rows, CanvasFontFallback::Emoji);
        assert_eq!(candidates.len(), 3);
        assert_eq!(candidates[0].source, 0..4);
        assert_eq!(candidates[0].glyph_records, vec![1]);
        assert_eq!(candidates[1].source, 4..8);
        assert_eq!(candidates[1].glyph_records, vec![2]);
        assert_eq!(candidates[2].source, 8..12);
        assert_eq!(candidates[2].glyph_records, vec![3]);

        rows[0].synthetic_root_control = false;
        assert!(collect_candidates(text, &rows, CanvasFontFallback::Emoji).is_empty());
    }

    #[test]
    fn accepts_full_fragment_ownership_for_family_emoji_without_fabricating_glyph_ranges() {
        let text = "\u{1f468}\u{200d}\u{1f469}\u{200d}\u{1f467}\u{200d}\u{1f466}";
        let end = text.len();
        let glyphs = (0..7)
            .map(|_| in_fragment(glyph(0.."\u{1f468}".len(), 4, 0, 0, true, false), 0, 0..end))
            .collect::<Vec<_>>();
        let candidates = collect_candidates(text, &glyphs, CanvasFontFallback::Emoji);
        assert_eq!(candidates.len(), 1);
        assert_eq!(candidates[0].source, 0..end);
        assert_eq!(candidates[0].glyph_records, (0..7).collect::<Vec<_>>());
        assert!(
            glyphs
                .iter()
                .all(|glyph| glyph.source == (0.."\u{1f468}".len()))
        );
    }

    #[test]
    fn rejects_competing_fragment_and_unproven_family_gap() {
        let text = "\u{1f468}\u{200d}\u{1f469}\u{200d}\u{1f467}\u{200d}\u{1f466}";
        let end = text.len();
        let glyphs = [
            in_fragment(glyph(0..4, 4, 0, 0, true, false), 0, 0..end),
            in_fragment(glyph(8..12, 4, 0, 0, true, false), 1, 0..end),
        ];
        assert!(collect_candidates(text, &glyphs, CanvasFontFallback::Emoji).is_empty());
        let partial = [glyph(0..4, 4, 0, 0, true, false)];
        assert!(collect_candidates(text, &partial, CanvasFontFallback::Emoji).is_empty());
    }

    #[test]
    fn permits_only_selector_gaps_and_preserves_text_vs_emoji_presentation() {
        let spider = "\u{1f578}";
        let text = format!("{spider}\u{fe0f}{spider}\u{fe0e}");
        let second_start = (spider.to_owned() + "\u{fe0f}").len();
        let full_source = 0..text.len();
        let glyphs = [
            in_fragment(
                glyph(0..spider.len(), 9, 0, 0, false, false),
                0,
                full_source.clone(),
            ),
            in_fragment(
                glyph(
                    second_start..second_start + spider.len(),
                    9,
                    0,
                    0,
                    false,
                    true,
                ),
                0,
                full_source,
            ),
        ];
        let candidates = collect_candidates(&text, &glyphs, CanvasFontFallback::Emoji);
        assert_eq!(candidates.len(), 2);
        assert_eq!(candidates[0].source, 0..second_start);
        assert!(candidates[0].color);
        assert_eq!(candidates[1].source, second_start..text.len());
        assert!(!candidates[1].color);
        let arbitrary_gap = [glyph(0..spider.len(), 9, 0, 0, true, false)];
        assert!(
            collect_candidates(
                &(spider.to_owned() + "\u{200d}"),
                &arbitrary_gap,
                CanvasFontFallback::Emoji
            )
            .is_empty()
        );
    }

    #[test]
    fn changed_relayout_ranges_are_hidden_only_when_contained() {
        let replacements = [4..15, 20..24];
        assert_eq!(
            replacement_glyph_is_suppressed(&(8..12), &replacements),
            Ok(true)
        );
        assert_eq!(
            replacement_glyph_is_suppressed(&(4..15), &replacements),
            Ok(true)
        );
        assert_eq!(
            replacement_glyph_is_suppressed(&(15..20), &replacements),
            Ok(false)
        );
        assert_eq!(
            replacement_glyph_is_suppressed(&(12..21), &replacements),
            Err(())
        );
        assert_eq!(
            replacement_glyph_is_suppressed(&(9..9), &replacements),
            Err(())
        );
    }
}
