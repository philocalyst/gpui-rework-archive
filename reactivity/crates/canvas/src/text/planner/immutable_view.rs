//! Source-only gate of actual immutable source / independent width ownership.
//! No runtime adoption, canonical format change, cursor API or memory claim.
use super::*;

#[derive(Debug, PartialEq, Eq)]
struct Words {
    metrics: [u32; 4],
    raw_lines: Vec<[u32; 12]>,
    canvas_lines: Vec<[u32; 6]>,
    runs: Vec<[u32; 6]>,
    glyphs: Vec<[u32; 7]>,
}
fn words<'a>(
    metrics: [f32; 4],
    lines: impl Iterator<Item = parley::layout::Line<'a, ()>>,
    content: &str,
    ids: [Option<u64>; 3],
) -> Words {
    let mut out = Words { metrics: metrics.map(f32::to_bits), raw_lines: Vec::new(),
        canvas_lines: Vec::new(), runs: Vec::new(), glyphs: Vec::new() };
    for (line_index, line) in lines.enumerate() {
        let m = line.metrics();
        out.raw_lines.push([m.line_height, m.baseline, m.offset, m.indent, m.advance,
            m.hanging_advance, m.inline_min_coord, m.inline_max_coord, m.block_min_coord,
            m.block_max_coord, m.content_block_min_coord, m.content_block_max_coord].map(f32::to_bits));
        let frozen = freeze_line(line, content, 0, 0.).unwrap();
        out.canvas_lines.push([frozen.start, frozen.end, frozen.top.to_bits(), frozen.height.to_bits(),
            frozen.baseline.to_bits(), frozen.width.to_bits()]);
        for item in line.items() {
            let PositionedLayoutItem::GlyphRun(run) = item else { panic!("unboxed subset"); };
            let slot = ids.iter().position(|id| *id == Some(run.run().font().data.id())).unwrap() as u32;
            let range = run.run().text_range();
            out.runs.push([line_index as u32, range.start as u32, range.end as u32, slot,
                u32::from(run.run().is_rtl()), run.run().glyph_count() as u32]);
            let mut sources = run.run().glyph_source_ranges();
            for glyph in run.positioned_glyphs() {
                let range = sources.next().unwrap();
                out.glyphs.push([slot, glyph.id, range.start as u32, range.end as u32,
                    glyph.x.to_bits(), glyph.y.to_bits(), glyph.advance.to_bits()]);
            }
            assert!(sources.next().is_none());
        }
    }
    out
}
fn build(planner: &mut Planner<'_>, content: &str, size: f32) -> parley::Layout<()> {
    let needed = planner.coverage(content).unwrap();
    let names = FAMILIES.iter().enumerate().filter_map(|(slot, family)| {
        (slot == 0 || needed & (1 << (slot - 1)) != 0)
            .then(|| FontFamilyName::Named((*family).into()))
    }).collect::<Vec<_>>();
    let mut builder = planner.context.ranged_builder(&mut planner.fonts, content, 1., false);
    builder.push_default(&names[..]);
    builder.push_default(StyleProperty::FontSize(size));
    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
    builder.build(content)
}
fn snapshot(view: &parley::WidthView<'_, ()>, content: &str, ids: [Option<u64>; 3]) -> Words {
    words([view.width(), view.full_width(), view.height(), view.layout_max_advance()], view.lines(), content, ids)
}
fn cold(content: &str, size: f32, width: Option<f32>, indent: f32) -> Words {
    let face = FontFace::bundled().unwrap();
    let mut planner = Planner::new(&face).unwrap();
    let mut layout = build(&mut planner, content, size);
    layout.set_text_indent(indent, parley::IndentOptions::default());
    layout.break_all_lines(width);
    words([layout.width(), layout.full_width(), layout.height(), layout.layout_max_advance()],
        layout.lines(), content, planner.blob_ids)
}

#[test]
fn one_immutable_owner_has_simultaneous_independent_a_b_a_views() {
    for content in ["", "office affinity AVATAR trailing  ", "abc אבג 123 xyz العربية office",
        "a\u{200d}b\u{2066}אבג\u{2069}", "line\u{2028}next end"] {
        for size in [14.1, 23.75] {
            for indent in [0., 3.125] {
                // Planner/font-context scratch dies before ANY width is built.
                let (owner, ids) = {
                    let face = FontFace::bundled().unwrap();
                    let mut planner = Planner::new(&face).unwrap();
                    let mut layout = build(&mut planner, content, size);
                    layout.set_text_indent(indent, parley::IndentOptions::default());
                    (layout.try_into_shaped_paragraph().unwrap(), planner.blob_ids)
                };
                let styles = owner.styles().as_ptr();
                let a = owner.width_view(Some(120.)).unwrap();
                let before_a = snapshot(&a, content, ids);
                let b = owner.width_view(Some(40.)).unwrap();
                let a2 = owner.width_view(Some(120.)).unwrap();
                if content == "office affinity AVATAR trailing  " {
                    assert_ne!(a.lines().count(), b.lines().count(), "fixture must rewrap");
                }
                assert_eq!(snapshot(&a, content, ids), before_a);
                assert_eq!(snapshot(&a2, content, ids), before_a);
                assert_eq!(before_a, cold(content, size, Some(120.), indent));
                assert_eq!(snapshot(&b, content, ids), cold(content, size, Some(40.), indent));
                assert_ne!(a.get(0).unwrap().metrics() as *const _, b.get(0).unwrap().metrics() as *const _);
                assert_ne!(a.get(0).unwrap().metrics() as *const _, a2.get(0).unwrap().metrics() as *const _);
                drop(b); drop(a2);
                assert_eq!(snapshot(&a, content, ids), before_a);
                for width in [None, Some(1.), Some(60.), Some(120.)] {
                    let next = owner.width_view(width).unwrap();
                    assert_eq!(snapshot(&next, content, ids), cold(content, size, width, indent));
                    assert_eq!(snapshot(&a, content, ids), before_a);
                    assert_eq!(owner.styles().as_ptr(), styles);
                }
                assert_eq!(owner.text_len(), content.len());
                for invalid in [0., -1., f32::NAN, f32::INFINITY] {
                    assert!(owner.width_view(Some(invalid)).is_none());
                    assert_eq!(snapshot(&a, content, ids), before_a);
                }
            }
        }
    }
}

#[test]
fn unsupported_conversion_returns_the_original_layout_unchanged() {
    let face = FontFace::bundled().unwrap();
    let mut planner = Planner::new(&face).unwrap();
    let mut aligned = build(&mut planner, "office words", 14.1);
    aligned.break_all_lines(Some(40.));
    aligned.align(parley::Alignment::Center, parley::AlignmentOptions::default());
    let before = format!("{aligned:#?}");
    let styles = aligned.styles().as_ptr();
    let aligned = match aligned.try_into_shaped_paragraph() {
        Err(original) => original,
        Ok(_) => panic!("aligned prototype must use the ordinary path"),
    };
    assert_eq!(format!("{aligned:#?}"), before);
    assert_eq!(aligned.styles().as_ptr(), styles);

    let content = "office";
    let mut builder = planner.context.ranged_builder(&mut planner.fonts, content, 1., false);
    builder.push_default(FontFamilyName::Named(FAMILIES[0].into()));
    builder.push_default(StyleProperty::FontSize(14.1));
    builder.push_inline_box(parley::InlineBox { id: 7, index: 0,
        kind: parley::InlineBoxKind::InFlow, width: 3.125, height: 13.75,
        baseline: None, vertical_align: Default::default() });
    let mut boxed = builder.build(content);
    boxed.break_all_lines(Some(40.));
    let before = format!("{boxed:#?}");
    let styles = boxed.styles().as_ptr();
    let boxed = match boxed.try_into_shaped_paragraph() {
        Err(original) => original,
        Ok(_) => panic!("inline-box prototype must use the ordinary path"),
    };
    assert_eq!(format!("{boxed:#?}"), before);
    assert_eq!(boxed.styles().as_ptr(), styles);
    assert_eq!(boxed.inline_boxes().len(), 1);
}
