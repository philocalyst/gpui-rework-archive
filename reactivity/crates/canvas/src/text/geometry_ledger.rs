//! Matched ownership/materialization accounting, not a timing benchmark.
use super::*;

#[test]
fn direct_geometry_materialization_omits_the_shared_allocation() {
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    let font = FontFace::bundled().unwrap();
    let mut shaper = font.shaper();
    drop(
        shaper
            .shape_interactive("office אבג\r\nnext", 16., Some(80.))
            .unwrap(),
    );
    for _ in 0..4 {
        let mut shared = None;
        let shared_cost = allocation_counter::measure(|| {
            shared = Some(
                shaper
                    .shape_interactive("office אבג\r\nnext", 16., Some(80.))
                    .unwrap(),
            );
        });
        let mut owned = None;
        let owned_cost = allocation_counter::measure(|| {
            owned = Some(
                shaper
                    .shape_owned_interactive("office אבג\r\nnext", 16., Some(80.))
                    .unwrap(),
            );
        });
        assert_eq!(shared_cost.count_total, owned_cost.count_total + 1);
        assert_eq!(shared_cost.count_current, owned_cost.count_current + 1);
        assert_eq!(
            shared.as_ref().unwrap().glyphs().len(),
            owned.as_ref().unwrap().glyphs().len()
        );
        println!(
            "DIRECT_GEOMETRY shared_header={} owned_header={} shared={shared_cost:?} owned={owned_cost:?}",
            size_of::<TextLayout>(),
            size_of::<OwnedTextLayout>()
        );
    }
}

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
                shape.glyphs.capacity() * size_of::<PackedGlyph>(),
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
        ("zwj", "a\u{200d}b e\u{301} العربية".into()),
        ("emoji", "👩\u{200d}💻".into()),
        ("one_long_grapheme", format!("a{}", "\u{301}".repeat(1024))),
    ] {
        for width in [None, Some(1.), Some(55.), Some(400.)] {
            let layout = match shaper.shape_interactive(&source, 16., width) {
                Ok(layout) => layout,
                Err(error @ Error::MissingGlyph(_)) if name == "emoji" => {
                    println!("CARET_GROUPS case={name} width={width:?} rejected={error:?}");
                    continue;
                }
                Err(error) => panic!("{name} {width:?}: {error:?}"),
            };
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

#[test]
fn packed_owner_is_shared_only_when_the_scene_needs_a_retained_run() {
    use crate::{Affine, Canvas, Color, ColorConfig, Point};
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    let face = FontFace::bundled().unwrap();
    let mut text = TextSystem::from_font(face.clone());
    let mut pair = face.shaper().shape("Hi", 12., None).unwrap();
    let mut single = face.shaper().shape("H", 12., None).unwrap();
    let clip = Rect::new(0., 0., 64., 32.);
    let mut canvas = Canvas::recording(64, 32, ColorConfig::default()).unwrap();
    canvas.clear(Color::BLACK);
    assert!(pair.glyphs.is_unique());
    let mut clone = None;
    let cost = allocation_counter::measure(|| clone = Some(pair.clone()));
    assert_eq!((cost.count_total, cost.bytes_total), (0, 0));
    let clone = clone.unwrap();
    assert_eq!(clone.glyphs.as_ptr(), pair.glyphs.as_ptr());
    assert!(!pair.glyphs.is_unique());
    drop(clone);
    canvas
        .draw_text(
            &mut text,
            &single,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert!(single.glyphs.is_unique());
    canvas
        .draw_text(
            &mut text,
            &pair,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert!(!pair.glyphs.is_unique());
    let mut before = [0; 64 * 32];
    canvas.render_bgrx(&mut before).unwrap();
    // A live scene owns its glyph stream and mask leases independently of L
    // and the mutable raster service. Public metrics cannot rewrite glyph bits.
    drop(pair);
    drop(single);
    text.clear_cache();
    drop(text);
    let mut after = [0; 64 * 32];
    canvas.render_bgrx(&mut after).unwrap();
    assert_eq!(before, after);
    canvas.clear(Color::TRANSPARENT);
    println!(
        "PACKED_SHARED layout={} owner_payload={} shared_header=16",
        size_of::<TextLayout>(),
        size_of::<GlyphBuffer>()
    );
}

#[test]
fn each_retained_text_call_charges_one_packed_owner_lease() {
    use crate::{Affine, Canvas, Color, ColorConfig, Point};
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    let face = FontFace::bundled().unwrap();
    let mut text = TextSystem::from_font(face.clone());
    let mut layout = face.shaper().shape("Hi", 12., None).unwrap();
    let clip = Rect::new(0., 0., 64., 32.);
    let mut canvas = Canvas::recording(64, 32, ColorConfig::default()).unwrap();
    for _ in 0..32 {
        canvas
            .draw_text(
                &mut text,
                &layout,
                Point::default(),
                Affine::IDENTITY,
                clip,
                Color::WHITE,
            )
            .unwrap();
    }
    assert!(!layout.glyphs.is_unique());
    assert_eq!(canvas.prepared_scene().masks().len(), 2);
    canvas.clear(Color::TRANSPARENT);
    assert!(layout.glyphs.is_unique());
    println!(
        "PACKED_RUN_LEASES admitted_runs=32 owner_shared_during_scene=true owner_unique_after_clear=true unique_mask_leases=2"
    );
}
