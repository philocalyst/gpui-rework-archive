use crate::{
    FontContext, FontFamilyName, InlineBox, InlineBoxKind, Layout, LayoutContext, OverflowWrap,
    StyleProperty,
    layout::data::LayoutItemKind,
};
use alloc::{collections::BTreeMap, sync::Arc, vec, vec::Vec};
use fontique::{Blob, Collection, CollectionOptions, FontInfoOverride, SourceCache};

fn fonts() -> FontContext {
    let mut fonts = FontContext {
        collection: Collection::new(CollectionOptions {
            shared: false,
            system_fonts: false,
        }),
        source_cache: SourceCache::default(),
    };
    for (name, bytes) in [
        ("primary", &include_bytes!("../../fonts/primary.ttf")[..]),
        ("Arabic", &include_bytes!("../../fonts/arabic.ttf")[..]),
        ("Hebrew", &include_bytes!("../../fonts/hebrew.ttf")[..]),
    ] {
        assert!(!fonts.collection.register_fonts(
            Blob::new(Arc::new(bytes)),
            Some(FontInfoOverride {
                family_name: Some(name),
                width: Some(Default::default()),
                style: Some(Default::default()),
                weight: Some(Default::default()),
                axes: None,
            }),
        ).is_empty());
    }
    fonts
}

#[derive(Default, Debug)]
struct Census {
    layouts: usize,
    lines: usize,
    reordered: usize,
    split_runs: usize,
    empty_runs: usize,
    empty_edges: usize,
    empty_among_other_runs: usize,
    boxes: usize,
    max_span: usize,
}

fn check(layout: &Layout<()>, source: &str, census: &mut Census) {
    let mut previous_end = 0;
    let mut seen_runs = BTreeMap::new();
    census.layouts += 1;
    for (line_index, line) in layout.lines().enumerate() {
        census.lines += 1;
        let items = &layout.data.line_items[line.data.item_range.clone()];
        let ids = items.iter().filter_map(|item| {
            (item.kind == LayoutItemKind::TextRun).then_some(item.index)
        }).collect::<Vec<_>>();
        census.boxes += items.len() - ids.len();
        if ids.is_empty() {
            continue;
        }
        census.reordered += usize::from(ids.windows(2).any(|pair| pair[0] > pair[1]));
        let min = *ids.iter().min().unwrap();
        let max = *ids.iter().max().unwrap();
        let span = max.checked_sub(min).unwrap().checked_add(1).unwrap();
        census.max_span = census.max_span.max(span);
        // Source shaping emits every text run once; commit_line can omit only
        // edge runs. Removing either edge does not create an interior ID hole.
        assert_eq!(span, ids.len(), "source={source:?} line={line_index} ids={ids:?}");
        let mut slots = vec![None; span];
        for (position, item) in items.iter().enumerate() {
            if item.kind == LayoutItemKind::TextRun {
                assert!(slots[item.index - min].replace(position).is_none(), "duplicate run");
            }
        }
        for (relative, position) in slots.into_iter().enumerate() {
            let position = position.expect("source-run span has no holes");
            let item = &items[position];
            assert_eq!(item.index, min + relative);
            census.split_runs += usize::from(seen_runs.insert(item.index, line_index).is_some());
            let run = line.item(position).unwrap().run().unwrap();
            assert_eq!(run.index(), position, "public index is visual item position");
            let clusters = run.clusters().collect::<Vec<_>>();
            if clusters.is_empty() {
                census.empty_runs += 1;
                census.empty_edges += usize::from(relative == 0 || relative + 1 == span);
                census.empty_among_other_runs += usize::from(span > 1);
                assert!(item.text_range.is_empty());
            }
            for cluster in clusters {
                let range = cluster.text_range();
                assert!(range.start <= range.end && range.end <= source.len());
                if !range.is_empty() {
                    assert!(range.start >= previous_end, "overlap/decrease: source={source:?} line={line_index} range={range:?} previous={previous_end}");
                    previous_end = range.end;
                }
            }
        }
    }
}

#[test]
fn producer_line_run_span_survives_bidi_split_and_empty_edges() {
    let mut fonts = fonts();
    let mut context = LayoutContext::<()>::new();
    let families = ["primary", "Arabic", "Hebrew"].map(|s| FontFamilyName::Named(s.into()));
    let mut census = Census::default();
    for source in [
        "", "\n", "\n\n", "a\r\n\u{2028}b\n", "abc אבג 123 العربية xyz\n",
        "אבג 123 xyz العربية\u{2028}", "a\u{2067}אבג 12\u{2069} z",
        "office ffi fi abc אבג xyz", "a\u{301}\u{200d}ع\u{651} e\u{301} b",
        "a    b    אבג     العربية      z\n", "a\tאבג\t12\txyz\n",
    ] {
        for width in [None, Some(0.), Some(1.), Some(12.), Some(31.), Some(80.)] {
            for styles in [0, 1, 2] {
                for boxes in [false, true] {
                    let mut builder = context.ranged_builder(&mut fonts, source, 1., false);
                    builder.push_default(&families[..]);
                    builder.push_default(StyleProperty::FontSize(16.));
                    builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
                    for (index, (start, ch)) in source.char_indices().enumerate() {
                        if styles == 2 || (styles == 1 && index % 3 == 0) {
                            builder.push(StyleProperty::FontSize(17. + (index % 2) as f32), start..start + ch.len_utf8());
                        }
                    }
                    if boxes {
                        for (id, index) in [0, source.len()].into_iter().enumerate() {
                            builder.push_inline_box(InlineBox {
                                id: id as u64,
                                index,
                                kind: if id == 0 { InlineBoxKind::InFlow } else { InlineBoxKind::OutOfFlow },
                                width: 3.125,
                                height: 13.75,
                                baseline: None,
                                vertical_align: Default::default(),
                            });
                        }
                    }
                    let mut layout = builder.build(source);
                    layout.break_all_lines(width);
                    check(&layout, source, &mut census);
                }
            }
        }
    }
    assert!(census.reordered > 0, "bidi permutation must be exercised");
    assert!(census.split_runs > 0, "line-scoped slices must recur");
    assert!(census.empty_runs > 0, "empty/synthetic runs must be exercised");
    assert!(census.empty_edges > 0, "empty run at source-order line edge");
    assert!(census.boxes > 0, "box indices must not enter text-run span");
    std::println!("span_census,{census:?}");
}
