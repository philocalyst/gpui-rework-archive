//! Differential proof of the EXISTING mutable Parley rebreak seam only.
//! This is not a shared shaped owner, an immutable width view or a benchmark.
use super::*;

#[derive(Debug, PartialEq, Eq)]
struct Observed {
    metrics: [u32; 4],
    raw_lines: Vec<[u32; 12]>,
    canvas_lines: Vec<[u32; 7]>,
    runs: Vec<[u32; 5]>,
    glyphs: Vec<[u32; 7]>,
    carets: Vec<[u32; 3]>,
    accepted_glyphs: Vec<[u32; 5]>,
    accepted_runs: Vec<[u32; 7]>,
}

#[derive(Debug, PartialEq, Eq)]
struct Canonical {
    metrics: [u32; 3],
    glyphs: Vec<[u32; 5]>,
    lines: Vec<[u32; 6]>,
    runs: Vec<[u32; 7]>,
    carets: Vec<[u32; 3]>,
}

fn canonical(shape: &TextLayout) -> Canonical {
    let map = shape.mapping.as_ref().expect("ordinary interactive shape must retain geometry");
    Canonical {
        metrics: [shape.width, shape.height, shape.baseline].map(f32::to_bits),
        glyphs: shape.glyphs().map(|glyph| [u32::from(glyph.id), u32::from(glyph.font.0),
            glyph.cluster, glyph.x.to_bits(), glyph.baseline.to_bits()]).collect(),
        lines: map.lines.iter().map(|line| [line.start, line.end, line.top.to_bits(), line.height.to_bits(),
            line.baseline.to_bits(), line.width.to_bits()]).collect(),
        runs: map.runs.iter().map(|run| [run.start, run.end, run.glyph_start, run.glyph_end, run.line,
            u32::from(run.font.0), u32::from(run.direction == TextDirection::RightToLeft)]).collect(),
        carets: map.carets.as_ref().unwrap().iter().map(|stop| [stop.byte, stop.x.to_bits(), u32::from(stop.affinities)]).collect(),
    }
}

fn canonical_from_views(views: &[Observed], lengths: &[usize], width: Option<f32>) -> Canonical {
    assert_eq!(views.len(), lengths.len());
    let mut output = Canonical { metrics: [0; 3], glyphs: Vec::new(), lines: Vec::new(), runs: Vec::new(), carets: Vec::new() };
    let mut measured_width = 0f32;
    let mut height = 0f32;
    for (index, (view, &length)) in views.iter().zip(lengths).enumerate() {
        measured_width = measured_width.max(if length == 0 { 0. } else {
            f32::from_bits(view.metrics[if width.is_some() { 0 } else { 1 }])
        });
        height += f32::from_bits(view.metrics[2]);
        if index == 0 { output.metrics[2] = view.raw_lines.first().map_or(0f32.to_bits(), |line| line[1]); }
        output.glyphs.extend_from_slice(&view.accepted_glyphs);
        output.lines.extend(view.canvas_lines.iter().map(|line| [line[0], line[1], line[2], line[3], line[4], line[5]]));
        output.runs.extend_from_slice(&view.accepted_runs);
        output.carets.extend_from_slice(&view.carets);
    }
    output.metrics[0] = measured_width.to_bits(); output.metrics[1] = height.to_bits();
    output
}

fn build_once(planner: &mut Planner<'_>, content: &str, size: f32, needed: u8) -> parley::Layout<()> {
    let names = FAMILIES.iter().enumerate().filter_map(|(slot, family)| {
        (slot == 0 || needed & (1 << (slot - 1)) != 0)
            .then(|| FontFamilyName::Named((*family).into()))
    }).collect::<Vec<_>>();
    let mut layout = parley::Layout::new();
    let mut builder = planner.context.ranged_builder(&mut planner.fonts, content, 1., false);
    builder.push_default(&names[..]);
    builder.push_default(StyleProperty::FontSize(size));
    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
    builder.build_into(&mut layout, content);
    assert_eq!(layout.inline_boxes().len(), 0);
    assert_eq!(layout.alignment(), None);
    layout
}

fn observe(layout: &parley::Layout<()>, content: &str, ids: [Option<u64>; 3], source: usize, height: f32, glyph_base: usize, line_base: usize) -> Observed {
    let mut output = Observed {
        metrics: [layout.width(), layout.full_width(), layout.height(), layout.layout_max_advance()].map(f32::to_bits),
        raw_lines: Vec::new(), canvas_lines: Vec::new(), runs: Vec::new(), glyphs: Vec::new(), carets: Vec::new(),
        accepted_glyphs: Vec::new(), accepted_runs: Vec::new(),
    };
    for (line_index, line) in layout.lines().enumerate() {
        let m = line.metrics();
        output.raw_lines.push([m.line_height, m.baseline, m.offset, m.indent, m.advance,
            m.hanging_advance, m.inline_min_coord, m.inline_max_coord, m.block_min_coord,
            m.block_max_coord, m.content_block_min_coord, m.content_block_max_coord].map(f32::to_bits));
        let frozen = freeze_line(line, content, source, height).unwrap();
        output.canvas_lines.push([frozen.start, frozen.end, frozen.top.to_bits(), frozen.height.to_bits(),
            frozen.baseline.to_bits(), frozen.width.to_bits(), match line.break_reason() {
                parley::layout::BreakReason::None => 0, parley::layout::BreakReason::Regular => 1,
                parley::layout::BreakReason::Explicit => 2, parley::layout::BreakReason::Emergency => 3,
            }]);
        for item in line.items() {
            let PositionedLayoutItem::GlyphRun(run) = item else { panic!("Canvas subset cannot contain inline boxes"); };
            let slot = ids.iter().position(|id| *id == Some(run.run().font().data.id())).unwrap() as u32;
            let range = run.run().text_range();
            output.runs.push([(source + range.start) as u32, (source + range.end) as u32, slot,
                u32::from(run.run().is_rtl()), run.run().glyph_count() as u32]);
            assert!(run.run().normalized_coords().iter().all(|coordinate| coordinate.to_bits() == 0));
            let accepted_start = glyph_base + output.accepted_glyphs.len();
            let mut sources = run.run().glyph_source_ranges();
            for glyph in run.positioned_glyphs() {
                let range = sources.next().unwrap();
                output.glyphs.push([slot, glyph.id, (source + range.start) as u32, (source + range.end) as u32,
                    glyph.x.to_bits(), (height + glyph.y).to_bits(), glyph.advance.to_bits()]);
                if content.is_empty() { continue; }
                if glyph.id == 0 {
                    let ignored = content.get(range.clone()).is_some_and(|part| part.chars().all(|ch|
                        CodePointSetData::new::<DefaultIgnorableCodePoint>().contains(ch)));
                    assert!(ignored && glyph.advance == 0., "ordinary accepted-corpus zero filtering only");
                    continue;
                }
                output.accepted_glyphs.push([glyph.id, slot, (source + range.start) as u32,
                    glyph.x.to_bits(), (height + glyph.y).to_bits()]);
            }
            assert!(sources.next().is_none());
            let range = if content.is_empty() { 0..0 } else { run.run().text_range() };
            output.accepted_runs.push([(source + range.start) as u32, (source + range.end) as u32,
                accepted_start as u32, (glyph_base + output.accepted_glyphs.len()) as u32,
                (line_base + line_index) as u32, slot, u32::from(run.run().is_rtl())]);
        }
    }
    let mut carets = Vec::new();
    append_carets(&mut carets, layout, content, source, height).unwrap();
    output.carets = carets.into_iter().map(|stop| [stop.byte, stop.x.to_bits(), u32::from(stop.affinities)]).collect();
    output
}

#[test]
fn one_built_paragraph_rebreaks_a_b_a_exactly_like_fresh_original_builds() {
    let face = FontFace::bundled().unwrap();
    for content in [
        "".to_owned(), "office affinity AVATAR trailing  ".to_owned(),
        "abc אבג 123 xyz العربية office".to_owned(),
        "a\u{200d}b\u{2066}אבג\u{2069}".to_owned(),
        "line\u{2028}next end".to_owned(), format!("a{} end", "\u{301}".repeat(512)),
        "Responsive office affinity café e\u{301} words naturally change line breaks. ".repeat(16),
    ] {
        for size in [8., 14., 14.1, 23.75] {
            let mut planner = Planner::new(&face).unwrap();
            let needed = planner.coverage(&content).unwrap();
            let mut reused = build_once(&mut planner, &content, size, needed);
            let styles = (reused.styles().as_ptr(), reused.styles().len());
            let ids = planner.blob_ids;
            for width in [Some(120.), Some(60.), Some(120.), None, Some(1.), Some(40.), Some(f32::from_bits(40f32.to_bits() + 1))] {
                // No builder, analysis, shaping call, clone or mutation of the
                // font context occurs between these width changes.
                reused.break_all_lines(width);
                let actual = observe(&reused, &content, ids, 0, 0., 0, 0);
                let mut cold_planner = Planner::new(&face).unwrap();
                let cold_needed = cold_planner.coverage(&content).unwrap();
                let mut cold = build_once(&mut cold_planner, &content, size, cold_needed);
                cold.break_all_lines(width);
                assert_eq!(actual, observe(&cold, &content, cold_planner.blob_ids, 0, 0., 0, 0),
                    "size={size}, width={width:?}, text={content:?}");
                let original = face.shaper().shape_interactive(&content, size, width).unwrap();
                assert_eq!(canonical_from_views(std::slice::from_ref(&actual), &[content.len()], width), canonical(&original));
                assert_eq!((reused.styles().as_ptr(), reused.styles().len()), styles);
                assert_eq!(planner.blob_ids, ids);
                assert_eq!(reused.text_len(), content.len());
            }
        }
    }
}

#[test]
fn adjacent_producer_bracketed_widths_cross_a_real_break_and_match_cold_original() {
    let face = FontFace::bundled().unwrap();
    let content = "a".repeat(64);
    let size = 14.1;
    let mut planner = Planner::new(&face).unwrap();
    let needed = planner.coverage(&content).unwrap();
    let mut reused = build_once(&mut planner, &content, size, needed);
    let reaches_end = |view: &parley::Layout<()>| view.get(0).unwrap().text_range().end == content.len();
    let mut low = f32::MIN_POSITIVE.to_bits(); let mut high = f32::MAX.to_bits();
    reused.break_all_lines(Some(f32::from_bits(low))); assert!(!reaches_end(&reused));
    reused.break_all_lines(Some(f32::from_bits(high))); assert!(reaches_end(&reused));
    while high - low > 1 {
        let middle = low + (high - low) / 2;
        reused.break_all_lines(Some(f32::from_bits(middle)));
        if reaches_end(&reused) { high = middle; } else { low = middle; }
    }
    assert_eq!(high, low + 1);
    for bits in [low - 1, low, high, high + 1] {
        let width = Some(f32::from_bits(bits));
        reused.break_all_lines(width);
        if bits == low { assert!(!reaches_end(&reused)); }
        if bits == high { assert!(reaches_end(&reused)); }
        let actual = observe(&reused, &content, planner.blob_ids, 0, 0., 0, 0);
        let mut cold_planner = Planner::new(&face).unwrap();
        let needed = cold_planner.coverage(&content).unwrap();
        let mut cold = build_once(&mut cold_planner, &content, size, needed);
        cold.break_all_lines(width);
        assert_eq!(actual, observe(&cold, &content, cold_planner.blob_ids, 0, 0., 0, 0));
        let original = face.shaper().shape_interactive(&content, size, width).unwrap();
        assert_eq!(canonical_from_views(&[actual], &[content.len()], width), canonical(&original));
    }
}

#[test]
fn reused_hard_paragraphs_preserve_source_offsets_and_original_vertical_addition_order() {
    let face = FontFace::bundled().unwrap();
    let text = format!("office affinity café words\r\n\r\nאבג 123 العربية\n{}\u{2028}last\r\n", "a\u{301} words ".repeat(96));
    let paragraphs = paragraph::ranges(&text).collect::<Vec<_>>();
    let mut planner = Planner::new(&face).unwrap();
    // Production resolves coverage for the WHOLE source once and gives every
    // paragraph that same family list, not per-paragraph coverage.
    let needed = planner.coverage(&text).unwrap();
    let mut reused = paragraphs.iter().map(|part|
        build_once(&mut planner, &text[part.content.clone()], 23.75, needed)).collect::<Vec<_>>();
    let ids = planner.blob_ids;
    for width in [Some(120.), Some(60.), Some(120.), None, Some(1.)] {
        let mut height = 0f32;
        let mut glyph_base = 0;
        let mut line_base = 0;
        let actual = reused.iter_mut().zip(&paragraphs).map(|(view, part)| {
            view.break_all_lines(width);
            let output = observe(view, &text[part.content.clone()], ids, part.content.start, height, glyph_base, line_base);
            height += view.height();
            glyph_base += output.accepted_glyphs.len();
            line_base += output.canvas_lines.len();
            output
        }).collect::<Vec<_>>();
        let mut cold_planner = Planner::new(&face).unwrap();
        let cold_needed = cold_planner.coverage(&text).unwrap();
        let mut cold_height = 0f32;
        let mut cold_glyph_base = 0;
        let mut cold_line_base = 0;
        let expected = paragraphs.iter().map(|part| {
            let content = &text[part.content.clone()];
            let mut view = build_once(&mut cold_planner, content, 23.75, cold_needed);
            view.break_all_lines(width);
            let output = observe(&view, content, cold_planner.blob_ids, part.content.start, cold_height, cold_glyph_base, cold_line_base);
            cold_height += view.height();
            cold_glyph_base += output.accepted_glyphs.len();
            cold_line_base += output.canvas_lines.len();
            output
        }).collect::<Vec<_>>();
        assert_eq!(actual, expected, "width={width:?}");
        assert_eq!(height.to_bits(), cold_height.to_bits());
        let lengths = paragraphs.iter().map(|part| part.content.len()).collect::<Vec<_>>();
        let original = face.shaper().shape_interactive(&text, 23.75, width).unwrap();
        assert_eq!(canonical_from_views(&actual, &lengths, width), canonical(&original));
    }
}

/// Capture the SAME test-only dump on a727080 and the facade candidate under
/// matched stable/Nix inputs. Comparing two paths inside only the candidate is
/// insufficient: both could share the same mechanically introduced read error.
#[test]
fn borrowed_read_frozen_control_output() {
    eprintln!("READ-FACADE-SIZES {:?}", [
        std::mem::size_of::<parley::Layout<()>>(),
        std::mem::size_of::<parley::layout::Line<'_, ()>>(),
        std::mem::size_of::<parley::layout::Run<'_, ()>>(),
        std::mem::size_of::<parley::layout::Cluster<'_, ()>>(),
        std::mem::size_of::<parley::layout::GlyphRun<'_, ()>>(),
    ]);
    let face = FontFace::bundled().unwrap();
    for (case, text) in [
        String::new(),
        "office affinity AVATAR trailing  ".into(),
        "abc אבג 123 xyz العربية office".into(),
        "a\u{200d}b\u{2066}אבג\u{2069}".into(),
        "line\u{2028}next end".into(),
        format!("a{} end", "\u{301}".repeat(512)),
        "office café\r\n\r\nאבג العربية\nlast\r\n".into(),
    ].into_iter().enumerate() {
        for size in [14.1, 23.75] {
            for width in [None, Some(1.), Some(40.), Some(120.)] {
                let mut planner = Planner::new(&face).unwrap();
                let needed = planner.coverage(&text).unwrap();
                let mut height = 0f32;
                let mut glyph_base = 0;
                let mut line_base = 0;
                for (part_index, part) in paragraph::ranges(&text).enumerate() {
                    let content = &text[part.content.clone()];
                    let mut layout = build_once(&mut planner, content, size, needed);
                    layout.break_all_lines(width);
                    let observed = observe(&layout, content, planner.blob_ids,
                        part.content.start, height, glyph_base, line_base);
                    // Exercise both ends and independent clones of the moved
                    // borrowed line facade, without retaining a mutable owner.
                    let forward = layout.lines().map(|line| line.text_range()).collect::<Vec<_>>();
                    let reverse = layout.lines().rev().map(|line| line.text_range()).collect::<Vec<_>>();
                    assert_eq!(forward.iter().cloned().rev().collect::<Vec<_>>(), reverse);
                    let mut ends = layout.lines();
                    let clone = ends.clone();
                    let mut alternating = Vec::new();
                    while let Some(line) = ends.next() {
                        alternating.push(line.text_range());
                        if let Some(line) = ends.next_back() { alternating.push(line.text_range()); }
                    }
                    assert_eq!(clone.map(|line| line.text_range()).collect::<Vec<_>>(), forward);
                    let mut expected = Vec::new();
                    let (mut front, mut back) = (0, forward.len());
                    while front < back {
                        expected.push(forward[front].clone()); front += 1;
                        if front < back { back -= 1; expected.push(forward[back].clone()); }
                    }
                    assert_eq!(alternating, expected);
                    eprintln!("READ-FACADE-ORACLE case={case} size={} width={:?} part={part_index} {observed:?}",
                        size.to_bits(), width.map(f32::to_bits));
                    height += layout.height();
                    glyph_base += observed.accepted_glyphs.len();
                    line_base += observed.canvas_lines.len();
                }
            }
        }
    }
}
