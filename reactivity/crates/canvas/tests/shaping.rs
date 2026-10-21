use gpui_canvas::{Error, FontFace, TextSystem};
use std::hint::black_box;

#[test]
fn borrowed_batch_preserves_lines_clusters_errors_and_shared_face_identity() {
    let face = FontFace::bundled().unwrap();
    let mut batch = face.shaper();
    let service = TextSystem::from_font(face.clone());
    for (text, width) in [
        ("office café AVATAR", None),
        ("office café AVATAR", Some(28.0)),
        ("Ελλάδα\nКириллица", Some(40.0)),
        ("a\u{301}\n\n", Some(1.0)),
        ("अ नमस्ते", None),
    ] {
        let actual = batch.shape(text, 16.0, width).unwrap();
        let expected = service.shape(text, 16.0, width).unwrap();
        assert_eq!(actual.glyphs(), expected.glyphs());
        assert_eq!(actual.width, expected.width);
        assert_eq!(actual.height, expected.height);
        assert_eq!(actual.baseline, expected.baseline);
        assert_eq!(service.ink_bounds(&actual), service.ink_bounds(&expected));
    }
    assert_eq!(
        batch.shape("漢", 16.0, None).unwrap_err(),
        service.shape("漢", 16.0, None).unwrap_err()
    );
    assert_eq!(
        batch.shape("\u{10ffff}", 16.0, None).unwrap_err(),
        Error::MissingGlyph('\u{10ffff}')
    );
    assert_eq!(
        batch.shape("a", 0.0, None).unwrap_err(),
        Error::InvalidFontSize
    );
    assert_eq!(
        batch.shape("a", 16.0, Some(0.0)).unwrap_err(),
        Error::InvalidWidth
    );
    // An error does not corrupt the scoped parser.
    assert_eq!(batch.shape("office", 16.0, None).unwrap().glyphs().len(), 4);
}

#[test]
fn batch_parses_once_and_releases_tables_without_an_idle_cache() {
    let face = FontFace::bundled().unwrap();
    let idle = allocation_counter::measure(|| {
        black_box(face.shaper());
    });
    assert_eq!(idle.count_total, 0, "an unused pass must not parse tables");
    let isolated = allocation_counter::measure(|| {
        for _ in 0..8 {
            black_box(
                face.shaper()
                    .shape("office café AVATAR", 16.0, None)
                    .unwrap(),
            );
        }
    });
    let batched = allocation_counter::measure(|| {
        let mut batch = face.shaper();
        for _ in 0..8 {
            black_box(batch.shape("office café AVATAR", 16.0, None).unwrap());
        }
    });
    assert_eq!(isolated.bytes_current, 0);
    assert_eq!(
        batched.bytes_current, 0,
        "table backing must be released on drop"
    );
    assert!(batched.bytes_total * 4 < isolated.bytes_total);
    assert!(batched.count_total * 4 < isolated.count_total);
}
