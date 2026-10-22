//! Matched ownership/materialization accounting, not a timing benchmark.
use super::*;

#[test]
fn scoped_geometry_allocation_and_payload_ledger() {
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    let font = FontFace::bundled().unwrap();
    println!(
        "GEOMETRY_HEADERS layout={} details={} stop={} run={} line={} system={}",
        size_of::<TextLayout>(),
        size_of::<Details>(),
        size_of::<layout::Stop>(),
        size_of::<layout::Run>(),
        size_of::<layout::Line>(),
        size_of::<TextSystem>()
    );
    for (name, value, width) in [
        ("empty", String::new(), None),
        ("short", "a short label".into(), None),
        (
            "wrapped",
            "office café אבג and العربية ".repeat(24),
            Some(180.),
        ),
        ("ascii32k", "a".repeat(MAX_TEXT), Some(400.)),
        (
            "one_long_grapheme",
            format!("a{}", "\u{301}".repeat(1024)),
            Some(400.),
        ),
    ] {
        for interactive in [false, true] {
            let mut retained = None;
            let cost = allocation_counter::measure(|| {
                let mut shaper = font.shaper();
                retained = Some(
                    if interactive {
                        shaper.shape_interactive(&value, 16., width)
                    } else {
                        shaper.shape(&value, 16., width)
                    }
                    .unwrap(),
                );
            });
            let shape = retained.unwrap();
            let (runs, lines, stops, capacity) =
                shape.mapping.as_ref().map_or((0, 0, 0, 0), |map| {
                    let stops = map.carets.as_deref().map_or(0, <[_]>::len);
                    let capacity = map.runs.capacity() * size_of::<layout::Run>()
                        + map.lines.capacity() * size_of::<layout::Line>()
                        + map
                            .carets
                            .as_ref()
                            .map_or(0, |stops| stops.capacity() * size_of::<layout::Stop>());
                    (map.runs.len(), map.lines.len(), stops, capacity)
                });
            println!(
                "GEOMETRY_PAYLOAD case={name} bytes={} interactive={interactive} glyphs={} glyph_capacity_bytes={} runs={runs} lines={lines} stops={stops} geometry_capacity_bytes={capacity} allocations={} requested={} peak_live={} retained={} retained_allocations={}",
                value.len(),
                shape.glyphs.len(),
                shape.glyphs.capacity() * size_of::<Glyph>(),
                cost.count_total,
                cost.bytes_total,
                cost.bytes_max,
                cost.bytes_current,
                cost.count_current
            );
        }
    }
}

#[test]
fn retained_geometry_drops_paint_leases_and_detaches_explicit_mutation() {
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    let font = FontFace::bundled().unwrap();
    let mut layout = font
        .shaper()
        .shape_interactive("office אבג\r\nnext", 16., Some(50.))
        .unwrap();
    let geometry = layout.retain_geometry().unwrap();
    let before = geometry
        .graphemes()
        .map(|unit| {
            (
                unit.text_range(),
                unit.bounds(),
                unit.line(),
                unit.direction(),
            )
        })
        .collect::<Vec<_>>();
    let font_set = Arc::downgrade(&layout.fonts);
    let cost = allocation_counter::measure(|| {
        let borrowed = layout.retain_geometry().unwrap();
        assert!(Arc::ptr_eq(&borrowed, &geometry));
    });
    assert_eq!(cost.count_total, 0);
    layout.discard_interaction();
    assert!(layout.geometry().is_some_and(|map| map.carets.is_none()));
    drop(layout);
    assert!(
        font_set.upgrade().is_none(),
        "geometry must not retain glyph font-set leases"
    );
    assert_eq!(
        geometry
            .graphemes()
            .map(|unit| (
                unit.text_range(),
                unit.bounds(),
                unit.line(),
                unit.direction()
            ))
            .collect::<Vec<_>>(),
        before
    );
    let runs = geometry.runs().collect::<Vec<_>>();
    assert_eq!(runs.first().unwrap().text_range().start.byte(), 0);
    assert_eq!(
        runs.last().unwrap().text_range().end.byte(),
        geometry.text_len()
    );
    for pair in runs.windows(2) {
        assert_eq!(pair[0].text_range().end, pair[1].text_range().start);
    }
}

#[test]
fn canonical_caret_group_shapes_are_measured_before_implicit_affinity_encoding() {
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    for (name, source) in [
        ("empty", String::new()),
        ("ascii32k", "a".repeat(MAX_TEXT)),
        ("ligatures", "office affine e\u{301}".into()),
        ("paragraphs", "a\r\n\r\nb\r\n\u{2028}\u{2028}".into()),
        ("bidi", "abc אבג 123 العربية xyz".into()),
        (
            "isolates",
            "a \u{2067}אבג 12\u{2069} b \u{202e}BC\u{202c}D".into(),
        ),
        ("zwj", "👩\u{200d}💻 e\u{301} नमस्ते".into()),
        ("one_long_grapheme", format!("a{}", "\u{301}".repeat(1024))),
    ] {
        for width in [None, Some(1.), Some(55.), Some(400.)] {
            let layout = shaper.shape_interactive(&source, 16., width).unwrap();
            let stops = layout.mapping.as_ref().unwrap().carets.as_deref().unwrap();
            let (mut common, mut split, mut exclusive) = (0, 0, 0);
            for group in stops.chunk_by(|a, b| a.byte == b.byte) {
                match group {
                    [only] if only.affinities == 3 => common += 1,
                    [upstream, downstream]
                        if upstream.affinities == 1 && downstream.affinities == 2 =>
                    {
                        split += 1
                    }
                    [only] if only.affinities == 1 || only.affinities == 2 => exclusive += 1,
                    _ => panic!("unexpected producer group {name} {width:?}: {group:?}"),
                }
            }
            println!(
                "CARET_GROUPS case={name} width={width:?} bytes={} stops={} common={common} split={split} exclusive={exclusive}",
                source.len(),
                stops.len()
            );
        }
    }
}
