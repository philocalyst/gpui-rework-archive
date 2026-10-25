//! Paired lowering proof only; this is NOT a production resource or GPUI cache.
use super::*;

struct FixtureShapes {
    owners: Vec<parley::ShapedParagraph<()>>,
    ids: [Option<u64>; 3],
    faces: FontSet,
}
fn shapes(text: &str, size: f32) -> FixtureShapes {
    let face = FontFace::bundled().unwrap();
    let mut planner = Planner::new(&face).unwrap();
    let needed = planner.coverage(text).unwrap();
    let names = FAMILIES.iter().enumerate().filter_map(|(slot, family)| {
        (slot == 0 || needed & (1 << (slot - 1)) != 0)
            .then(|| FontFamilyName::Named((*family).into()))
    }).collect::<Vec<_>>();
    let owners = paragraph::ranges(text).map(|part| {
        let content = &text[part.content];
        let mut builder = planner.context.ranged_builder(&mut planner.fonts, content, 1., false);
        builder.push_default(&names[..]);
        builder.push_default(StyleProperty::FontSize(size));
        builder.push_default(StyleProperty::OverflowWrap(OverflowWrap::Anywhere));
        builder.build(content).try_into_shaped_paragraph().unwrap()
    }).collect();
    // Capture originating IDs and accepted owning face set BEFORE planner dies.
    FixtureShapes { owners, ids: planner.blob_ids, faces: planner.faces.clone() }
}
fn lower<const MATERIALIZE: bool>(
    source: &FixtureShapes, views: &[parley::WidthView<'_, ()>], text: &str,
    size: f32, width: Option<f32>, interactive: bool,
) -> Result<Planned, Error> {
    let parts = paragraph::ranges(text).collect::<Vec<_>>();
    assert_eq!(parts.len(), views.len());
    let mut lowering = Lowering::new();
    for (part, view) in parts.iter().zip(views) {
        lowering = lowering.paragraph::<MATERIALIZE>(PlannedParagraph::View(view),
            &text[part.content.clone()], part, text, size, width, interactive, &source.ids)?;
    }
    Ok(lowering.finish())
}
fn packed(source: &FixtureShapes, planned: Planned, text: &str, size: f32) -> TextLayout {
    // EXACT existing font_set(mask) policy over the originating accepted faces,
    // not registration in a fresh context (equal bytes do not imply equal IDs).
    let fonts = Arc::new(FontSet { primary: source.faces.primary.clone(),
        fallbacks: std::array::from_fn(|i| if planned.mask & (1 << i) != 0 {
            source.faces.fallbacks[i].clone()
        } else { None }) });
    assert!(fonts.primary.same_face(&source.faces.primary));
    for slot in 1..=2 {
        if planned.mask & (1 << (slot - 1)) != 0 {
            assert!(fonts.face(slot).unwrap().same_face(source.faces.face(slot).unwrap()));
        }
    }
    TextLayout { width: planned.metrics.width, height: planned.metrics.height,
        baseline: planned.metrics.baseline, font_size: size,
        glyphs: GlyphBuffer::new(planned.glyphs, text.len()).unwrap(),
        fonts, mapping: planned.details.map(Arc::new) }
}
fn words(source: &FixtureShapes, views: &[parley::WidthView<'_, ()>], text: &str,
    size: f32, width: Option<f32>, interactive: bool) -> Vec<u64> {
    super::super::lowering_control::packed_words(&packed(source,
        lower::<true>(source, views, text, size, width, interactive).unwrap(), text, size))
}
#[test]
fn held_a_b_a_views_lower_to_cold_full_packed_output_with_original_font_ids() {
    let _registry = super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    let face = FontFace::bundled().unwrap();
    let corpus = [String::new(), "a".into(), "office affinity AVATAR trailing  ".into(),
        "abc אבג 123 xyz العربية office".into(), "a\u{200d}b\u{2066}אבג\u{2069}".into(),
        "line\u{2028}next end".into(), format!("a{} end", "\u{301}".repeat(512)),
        "office café\r\n\r\nאבג العربية\nlast\r\n".into()];
    let mut checked = 0;
    for text in corpus {
        for size in [14.1, 23.75] {
            let source = shapes(&text, size);
            let a = source.owners.iter().map(|p| p.width_view(Some(120.)).unwrap()).collect::<Vec<_>>();
            let before = words(&source, &a, &text, size, Some(120.), true);
            let b = source.owners.iter().map(|p| p.width_view(Some(40.)).unwrap()).collect::<Vec<_>>();
            let a2 = source.owners.iter().map(|p| p.width_view(Some(120.)).unwrap()).collect::<Vec<_>>();
            if text == "office affinity AVATAR trailing  " {
                assert_ne!(a[0].lines().count(), b[0].lines().count(), "fixture must rewrap");
                assert_ne!(before, words(&source, &b, &text, size, Some(40.), true));
            }
            assert_eq!(words(&source, &a, &text, size, Some(120.), true), before);
            assert_eq!(words(&source, &a2, &text, size, Some(120.), true), before);
            for width in [None, Some(1.), Some(40.), Some(60.), Some(120.)] {
                let views = source.owners.iter().map(|p| p.width_view(width).unwrap()).collect::<Vec<_>>();
                for interactive in [false, true] {
                    let mut shaper = face.shaper();
                    let cold = if interactive { shaper.shape_interactive(&text, size, width) }
                        else { shaper.shape(&text, size, width) }.unwrap();
                    assert_eq!(words(&source, &views, &text, size, width, interactive),
                        super::super::lowering_control::packed_words(&cold));
                    checked += 1;
                }
                let measured = lower::<false>(&source, &views, &text, size, width, false).unwrap();
                let cold = face.shaper().measure(&text, size, width).unwrap();
                assert_eq!([measured.metrics.width, measured.metrics.height, measured.metrics.baseline].map(f32::to_bits),
                    [cold.width, cold.height, cold.baseline].map(f32::to_bits));
                assert!(measured.glyphs.is_empty() && measured.details.is_none());
                assert_eq!(words(&source, &a, &text, size, Some(120.), true), before);
            }
            drop(b); drop(a2);
            assert_eq!(words(&source, &a, &text, size, Some(120.), true), before);
        }
    }
    assert_eq!(checked, 160);
    eprintln!("SHARED-LOWERING-VIEW-CASES {checked}");
}
fn reject<const MATERIALIZE: bool>(count: usize, ids: &[Option<u64>; 3], content: &str) -> Error {
    let source = shapes("office", 14.1);
    let view = source.owners[0].width_view(Some(40.)).unwrap();
    let mut state = Lowering::new();
    state.glyph_count = count; // Fault injection: aggregate predecessor budget.
    let part = paragraph::ranges("office").next().unwrap();
    match state.paragraph::<MATERIALIZE>(PlannedParagraph::View(&view), content,
        &part, "office", 14.1, Some(40.), true, ids) {
        Err(error) => error,
        Ok(_) => panic!("injected admission fault unexpectedly accepted"),
    }
}
#[test]
fn materialized_and_measure_lowering_preserve_first_admission_errors() {
    let _registry = super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    // Cap precedes invalid-source line freeze and foreign-font checks.
    assert_eq!(reject::<true>(MAX_GLYPHS, &[None; 3], "x"), Error::ResourceLimit);
    assert_eq!(reject::<false>(MAX_GLYPHS, &[None; 3], "x"), Error::ResourceLimit);
    // Non-simple line freeze precedes font-slot lookup, even MATERIALIZE=false.
    assert_eq!(reject::<true>(0, &[None; 3], "x"), Error::InvalidFont);
    assert_eq!(reject::<false>(0, &[None; 3], "x"), Error::InvalidFont);
    // IDs are exact, never inferred from equal font bytes or a fresh Planner.
    assert_eq!(reject::<true>(0, &[None; 3], "office"), Error::ForeignLayout);
    assert_eq!(reject::<false>(0, &[None; 3], "office"), Error::ForeignLayout);
}

fn check_fresh_registration<const MATERIALIZE: bool>(source: &FixtureShapes, fresh_ids: &[Option<u64>; 3]) {
    let view = source.owners[0].width_view(Some(40.)).unwrap();
    let part = paragraph::ranges("office").next().unwrap();
    match Lowering::new().paragraph::<MATERIALIZE>(PlannedParagraph::View(&view), "office",
        &part, "office", 14.1, Some(40.), true, fresh_ids) {
        Err(error) => assert_eq!(error, Error::ForeignLayout),
        Ok(_) => panic!("fresh registration must not accept original owner's font IDs"),
    }
}
#[test]
fn same_face_fresh_registration_is_not_original_font_identity() {
    let _registry = super::super::super::BUNDLED_TEST_LOCK.lock().unwrap();
    let source = shapes("office", 14.1);
    let same_face = source.faces.primary.clone();
    let fresh = Planner::new(&same_face).unwrap();
    assert!(same_face.same_face(&source.faces.primary));
    assert_ne!(fresh.blob_ids[0], source.ids[0], "fixture must mint a distinct registration ID");
    check_fresh_registration::<true>(&source, &fresh.blob_ids);
    check_fresh_registration::<false>(&source, &fresh.blob_ids);
}
