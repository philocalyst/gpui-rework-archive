use super::*;

#[test]
fn rejected_outline_preserves_warm_backend_and_cached_masks() {
    let face = FontFace::new(&PRIMARY_BYTES[..]).unwrap();
    let font = ttf_parser::Face::parse(&PRIMARY_BYTES, 0).unwrap();
    let a = font.glyph_index('A').unwrap().0;
    let b = font.glyph_index('B').unwrap().0;
    let mut cache = RasterCache::default();
    let mask = cache.raster(&face, a, 16.0).unwrap();
    let backend = &**cache.scaler.as_ref().unwrap() as *const OutlineRaster;
    let retained = cache.cache_bytes;

    assert!(matches!(
        cache.raster(&face, u16::MAX, 16.0),
        Err(Error::InvalidFont)
    ));
    assert_eq!(cache.cache_bytes, retained);
    assert_eq!(cache.cache.len(), 1);
    assert_eq!(
        &**cache.scaler.as_ref().unwrap() as *const OutlineRaster,
        backend
    );
    assert!(Arc::ptr_eq(&mask, &cache.raster(&face, a, 16.0).unwrap()));
    cache.raster(&face, b, 16.0).unwrap();
    assert_eq!(
        &**cache.scaler.as_ref().unwrap() as *const OutlineRaster,
        backend
    );
}

#[test]
fn empty_moves_keep_original_bounds_without_growing_storage() {
    let mut path = OutlinePath::default();
    path.clear();
    let mut pen = BoundsPen {
        path: Some(&mut path),
        ..BoundsPen::default()
    };
    for i in 0..1_000_000 {
        pen.move_to((i % 1000) as f32, -0.25);
        pen.close();
    }
    assert_eq!(pen.min, [0.0, -0.25]);
    assert_eq!(pen.max, [999.0, -0.25]);
    assert_eq!(pen.segments, 0);
    assert!(path.points.is_empty());
    assert!(path.verbs.is_empty());
    assert_eq!(path.points.capacity(), 0);
    assert_eq!(path.verbs.capacity(), 0);
}

#[test]
fn accepted_cubic_contours_fill_but_do_not_exceed_recording_caps() {
    let mut path = OutlinePath::default();
    path.clear();
    for _ in 0..65_536 {
        path.pending = Some(Point::new(0.0, 0.0));
        path.segment(
            Verb::CurveTo,
            &[
                Point::new(1.0, 2.0),
                Point::new(2.0, 1.0),
                Point::new(3.0, 3.0),
            ],
        );
        path.close();
    }
    assert!(path.overflow);
    assert!(path.points.is_empty());
    assert!(path.verbs.is_empty());
    assert_eq!(path.point_count, 4 * 65_536);
    assert_eq!(path.verb_count, 3 * 65_536);
    path.replay();
    for _ in 0..65_536 {
        path.pending = Some(Point::new(0.0, 0.0));
        path.segment(
            Verb::CurveTo,
            &[
                Point::new(1.0, 2.0),
                Point::new(2.0, 1.0),
                Point::new(3.0, 3.0),
            ],
        );
        path.close();
    }
    assert!(!path.overflow);
    assert_eq!(path.points.len(), 4 * 65_536);
    assert_eq!(path.verbs.len(), 3 * 65_536);
    assert_eq!(path.points.capacity(), 4 * 65_536);
    assert!(path.verbs.capacity() <= (3_usize * 65_536).next_power_of_two());
    path.pending = Some(Point::new(0.0, 0.0));
    path.segment(Verb::LineTo, &[Point::new(1.0, 1.0)]);
    path.close();
    assert!(path.overflow);
    assert!(path.points.is_empty());
    assert!(path.verbs.is_empty());
    path.clear();
    assert!(!path.overflow);
    assert!(path.pending.is_none());
    assert!(!path.open);
}
