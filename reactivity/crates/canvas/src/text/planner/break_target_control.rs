//! Test-only frozen17d5ac1/new-target ordinary API control, including boxes.
use super::*;

#[test]
fn ordinary_break_target_frozen_control_output() {
    let face = FontFace::bundled().unwrap();
    for (case, content) in ["office affinity trailing  ", "abc אבג 123 العربية office"].into_iter().enumerate() {
        for kind in [parley::InlineBoxKind::InFlow, parley::InlineBoxKind::OutOfFlow, parley::InlineBoxKind::CustomOutOfFlow] {
            for shift in [parley::BaselineShift::Length(1.25), parley::BaselineShift::Top, parley::BaselineShift::Bottom] {
                for alignment in [parley::Alignment::Start, parley::Alignment::Center, parley::Alignment::Justify] {
                    for width in [40., 120.] {
                        let mut planner = Planner::new(&face).unwrap();
                        let needed = planner.coverage(content).unwrap();
                        let names = FAMILIES.iter().enumerate().filter_map(|(slot, family)| {
                            (slot == 0 || needed & (1 << (slot - 1)) != 0)
                                .then(|| FontFamilyName::Named((*family).into()))
                        }).collect::<Vec<_>>();
                        let mut builder = planner.context.ranged_builder(&mut planner.fonts, content, 1., false);
                        builder.push_default(&names[..]);
                        builder.push_default(StyleProperty::FontSize(14.1));
                        builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
                        for (id, index) in [(7, 0), (8, content.len())] {
                            builder.push_inline_box(parley::InlineBox { id, index, kind, width: 3.125,
                                height: 23.75, baseline: Some(11.1),
                                vertical_align: parley::VerticalAlign { shift, ..Default::default() } });
                        }
                        let mut layout = builder.build(content);
                        layout.set_text_indent(3.125, parley::IndentOptions::default());
                        layout.break_all_lines(Some(width));
                        layout.align(alignment, parley::AlignmentOptions::default());
                        let mut out = [layout.width(), layout.full_width(), layout.height(), layout.layout_max_advance()]
                            .map(|word| u64::from(word.to_bits())).to_vec();
                        for line in layout.lines() {
                            out.extend([0, line.text_range().start as u64, line.text_range().end as u64]);
                            let m = line.metrics();
                            out.extend([m.line_height, m.baseline, m.offset, m.indent, m.advance,
                                m.hanging_advance, m.inline_min_coord, m.inline_max_coord, m.block_min_coord,
                                m.block_max_coord, m.content_block_min_coord, m.content_block_max_coord]
                                .map(|word| u64::from(word.to_bits())));
                            for item in line.items() {
                                match item {
                                    PositionedLayoutItem::InlineBox(b) => {
                                        out.extend([1, b.id, match b.kind {
                                            parley::InlineBoxKind::InFlow => 0,
                                            parley::InlineBoxKind::OutOfFlow => 1,
                                            parley::InlineBoxKind::CustomOutOfFlow => 2,
                                        }]);
                                        out.extend([b.x, b.y, b.width, b.height].map(|word| u64::from(word.to_bits())));
                                        out.extend([u64::from(b.baseline.is_some()), u64::from(b.baseline.unwrap_or(0.).to_bits())]);
                                    }
                                    PositionedLayoutItem::GlyphRun(run) => {
                                        let slot = planner.blob_ids.iter().position(|id| *id == Some(run.run().font().data.id())).unwrap();
                                        let range = run.run().text_range();
                                        out.extend([2, slot as u64, range.start as u64, range.end as u64,
                                            u64::from(run.run().is_rtl()), run.run().glyph_count() as u64]);
                                        let mut sources = run.run().glyph_source_ranges();
                                        for g in run.positioned_glyphs() {
                                            let source = sources.next().unwrap();
                                            out.extend([3, u64::from(g.id), source.start as u64, source.end as u64,
                                                u64::from(g.x.to_bits()), u64::from(g.y.to_bits()), u64::from(g.advance.to_bits())]);
                                        }
                                        assert!(sources.next().is_none());
                                    }
                                }
                            }
                        }
                        for byte in 0..=content.len() {
                            for affinity in [Affinity::Upstream, Affinity::Downstream] {
                                let cursor = Cursor::from_byte_index(&layout, byte, affinity);
                                let rect = cursor.geometry(&layout, 1.);
                                out.extend([4, byte as u64, cursor.index() as u64,
                                    u64::from(cursor.affinity() == Affinity::Downstream),
                                    rect.x0.to_bits(), rect.y0.to_bits(), rect.x1.to_bits(), rect.y1.to_bits()]);
                            }
                        }
                        eprintln!("BREAK-TARGET-ORACLE case={case} kind={kind:?} shift={shift:?} alignment={alignment:?} width={} words={out:?}", width.to_bits());
                    }
                }
            }
        }
    }
}
