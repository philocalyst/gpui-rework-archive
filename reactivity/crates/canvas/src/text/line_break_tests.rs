//! Actual producer API equivalence: batch, incremental, public undo/revert and
//! a partial incremental layout consumed as a batch. No testing-only layout API.
use super::*;
use parley::layout::{BreakLines, YieldData};

#[derive(Debug, PartialEq)]
struct GlyphBits {
    source: std::ops::Range<usize>,
    id: u32,
    position: [u32; 3],
}
#[derive(Debug, PartialEq)]
struct RunBits {
    source: std::ops::Range<usize>,
    rtl: bool,
    glyphs: Vec<GlyphBits>,
}
#[derive(Debug, PartialEq)]
struct LineBits {
    source: std::ops::Range<usize>,
    metrics: [u32; 12],
    runs: Vec<RunBits>,
}
fn snapshot(layout: &parley::Layout<()>) -> Vec<LineBits> {
    layout
        .lines()
        .map(|line| {
            let m = line.metrics();
            LineBits {
                source: line.text_range(),
                metrics: [
                    m.line_height,
                    m.baseline,
                    m.offset,
                    m.indent,
                    m.advance,
                    m.hanging_advance,
                    m.inline_min_coord,
                    m.inline_max_coord,
                    m.block_min_coord,
                    m.block_max_coord,
                    m.content_block_min_coord,
                    m.content_block_max_coord,
                ]
                .map(f32::to_bits),
                runs: line
                    .items()
                    .filter_map(|item| {
                        let PositionedLayoutItem::GlyphRun(run) = item else {
                            return None;
                        };
                        Some(RunBits {
                            source: run.run().text_range(),
                            rtl: run.run().is_rtl(),
                            glyphs: run
                                .positioned_glyphs()
                                .zip(run.run().glyph_source_ranges())
                                .map(|(glyph, source)| GlyphBits {
                                    source,
                                    id: glyph.id,
                                    position: [glyph.x, glyph.y, glyph.advance].map(f32::to_bits),
                                })
                                .collect(),
                        })
                    })
                    .collect(),
            }
        })
        .collect()
}
fn fonts() -> FontContext {
    // Independent immutable test font bytes; never touches the GPUI bundled
    // registry/ID lifetime whose concurrency/release test runs in this process.
    let mut fonts = FontContext {
        collection: Collection::new(CollectionOptions {
            shared: false,
            system_fonts: false,
        }),
        source_cache: SourceCache::default(),
    };
    for (family, bytes) in
        FAMILIES
            .into_iter()
            .zip([&PRIMARY_BYTES[..], &ARABIC_BYTES[..], &HEBREW_BYTES[..]])
    {
        fonts.collection.register_fonts(
            Blob::new(Arc::new(bytes)),
            Some(FontInfoOverride {
                family_name: Some(family),
                width: Some(Default::default()),
                style: Some(Default::default()),
                weight: Some(Default::default()),
                axes: None,
            }),
        );
    }
    fonts
}
fn build(
    fonts: &mut FontContext,
    context: &mut LayoutContext<()>,
    source: &str,
    boxes: Option<parley::InlineBoxKind>,
    height: f32,
) -> parley::Layout<()> {
    let names = FAMILIES.map(|name| FontFamilyName::Named(name.into()));
    let mut builder = context.ranged_builder(fonts, source, 1., false);
    builder.push_default(&names[..]);
    builder.push_default(StyleProperty::FontSize(16.));
    builder.push_default(StyleProperty::LineHeight(parley::LineHeight::Absolute(
        height,
    )));
    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
    if let Some((byte, _)) = source.char_indices().nth(2) {
        builder.push(
            StyleProperty::VerticalAlign(parley::VerticalAlign::TOP),
            byte..source.len(),
        );
        builder.push(StyleProperty::FontSize(25.), byte..source.len());
    }
    if let Some(kind) = boxes {
        for (id, index) in [(1, 0), (2, source.len())] {
            builder.push_inline_box(parley::InlineBox {
                id,
                index,
                kind,
                width: 7.,
                height: 13.,
                baseline: None,
                vertical_align: Default::default(),
            });
        }
    }
    builder.build(source)
}
fn place_box(breaker: &mut BreakLines<'_, ()>, outcome: &YieldData) {
    if let YieldData::InlineBoxBreak(data) = outcome {
        // The same zero-size CustomOutOfFlow policy used by break_remaining.
        breaker
            .state_mut()
            .append_inline_box_to_line(data.advance, 0., 0.);
    }
}

#[test]
fn batch_incremental_revert_and_mixed_breaking_preserve_actual_layout_bits() {
    let mut fonts = fonts();
    let mut context = LayoutContext::new();
    for source in [
        "",
        "a",
        "office café אבג 123 العربية repeated words repeated words",
        "a\r\n\r\nb\r\n",
        "a\u{2028}\u{2028}ב\u{2028}",
        "e\u{301} 👩\u{200d}💻 \u{2067}אבג 12\u{2069} z",
    ] {
        for boxes in [
            None,
            Some(parley::InlineBoxKind::InFlow),
            Some(parley::InlineBoxKind::CustomOutOfFlow),
        ] {
            for height in [0., 22.] {
                for width in [0., 30., 80., f32::MAX] {
                    let mut batch = build(&mut fonts, &mut context, source, boxes, height);
                    batch.break_all_lines(Some(width));
                    let expected = snapshot(&batch);
                    for mode in 0..4 {
                        let mut stepped = build(&mut fonts, &mut context, source, boxes, height);
                        let mut breaker = stepped.break_lines();
                        breaker.state_mut().set_layout_max_advance(width);
                        breaker.state_mut().set_line_max_advance(width);
                        if mode == 3 {
                            if let Some(first) = breaker.break_next() {
                                place_box(&mut breaker, &first);
                            }
                            breaker.break_remaining(width);
                        } else {
                            while let Some(first) = {
                                let saved = breaker.state().clone();
                                breaker.break_next().map(|first| {
                                    if mode != 0 {
                                        if mode == 1 {
                                            assert!(breaker.revert());
                                            assert!(!breaker.revert());
                                        } else {
                                            breaker.revert_to(saved);
                                        }
                                        let replay = breaker.break_next().unwrap();
                                        assert_eq!(format!("{first:?}"), format!("{replay:?}"));
                                        replay
                                    } else {
                                        first
                                    }
                                })
                            } {
                                place_box(&mut breaker, &first);
                            }
                            // A None at document end must leave the last public
                            // checkpoint usable, as before this optimization.
                            assert!(breaker.revert());
                            let last = breaker.break_next().unwrap();
                            place_box(&mut breaker, &last);
                            breaker.finish();
                        }
                        assert_eq!(
                            snapshot(&stepped),
                            expected,
                            "{source:?} boxes={boxes:?} height={height} width={width} mode={mode}"
                        );
                    }
                }
            }
        }
    }
}

#[test]
fn max_height_revert_then_batch_repair_and_invalid_width_keep_contract() {
    let mut fonts = fonts();
    let mut context = LayoutContext::new();
    let source = "office repeated words אבג repeated words";
    let mut expected = build(&mut fonts, &mut context, source, None, 22.);
    expected.break_all_lines(Some(50.));
    let mut repaired = build(&mut fonts, &mut context, source, None, 22.);
    let mut breaker = repaired.break_lines();
    breaker.state_mut().set_layout_max_advance(50.);
    breaker.state_mut().set_line_max_advance(50.);
    breaker.state_mut().set_line_max_height(1.);
    let first = breaker.break_next().unwrap();
    assert!(matches!(first, YieldData::MaxHeightExceeded(_)));
    assert!(breaker.revert());
    assert_eq!(
        format!("{first:?}"),
        format!("{:?}", breaker.break_next().unwrap())
    );
    breaker.state_mut().set_line_max_height(f32::MAX);
    breaker.break_remaining(50.);
    assert_eq!(snapshot(&repaired), snapshot(&expected));
    let mut invalid = build(&mut fonts, &mut context, source, None, 22.);
    assert!(
        std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            invalid.break_all_lines(Some(f32::NAN));
        }))
        .is_err()
    );
}
