use gpui_canvas::{Affine, Canvas, Color, FontFace, Point, Rect, TextSystem};

#[test]
fn canonical_scene_is_ordered_borrowed_and_does_not_rasterize() {
    let mut canvas = Canvas::new(80, 40).unwrap();
    canvas.clear(Color::BLACK);
    let clip = Rect::new(0.0, 0.0, 80.0, 40.0);
    canvas
        .fill_rect(
            Rect::new(1.0, 2.0, 20.0, 12.0),
            Affine::translation(4.0, 6.0),
            clip,
            Color::WHITE,
        )
        .unwrap();
    let mut fonts = TextSystem::bundled().unwrap();
    let label = fonts.shape("office", 16.0, None).unwrap();
    canvas
        .draw_text(
            &mut fonts,
            &label,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    let scene = canvas.prepared_scene();
    assert_eq!((scene.width, scene.height), (80, 40));
    assert_eq!(scene.clear, [0.0, 0.0, 0.0, 1.0]);
    let mut draws = scene.draws();
    let rect = draws.next().unwrap();
    assert!(rect.source.mask().is_none());
    assert_eq!(rect.inverse, [1.0, -0.0, -0.0, 1.0, -4.0, -6.0]);
    assert!(draws.all(|draw| draw.source.mask().is_some()));
    assert_eq!(canvas.stats().render_count, 0);
    let masks: Vec<_> = scene.draws().filter_map(|d| d.source.mask()).collect();
    assert!(
        masks
            .iter()
            .all(|mask| mask.width * mask.height == mask.coverage.len())
    );
    assert_eq!(scene.draws().len(), 1 + masks.len());
}

#[test]
fn raster_keys_survive_cache_eviction_and_shared_services_but_not_distinct_faces() {
    let face = FontFace::bundled().unwrap();
    let mut first = TextSystem::from_font(face.clone());
    let mut second = TextSystem::from_font(face);
    let layout = first.shape("H", 18.0, None).unwrap();
    let keys = |canvas: &Canvas| {
        canvas
            .prepared_scene()
            .draws()
            .filter_map(|d| d.source.mask().map(|m| m.key))
            .collect::<Vec<_>>()
    };
    let mut canvas = Canvas::new(40, 40).unwrap();
    let clip = Rect::new(0.0, 0.0, 40.0, 40.0);
    canvas
        .draw_text(
            &mut first,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    let initial = keys(&canvas);
    assert_eq!(initial.len(), 1);
    first.clear_cache();
    canvas.clear(Color::TRANSPARENT);
    canvas
        .draw_text(
            &mut second,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(keys(&canvas), initial);
    let mut foreign = TextSystem::new(include_bytes!("../assets/NotoSans.ttf")).unwrap();
    let foreign_layout = foreign.shape("H", 18.0, None).unwrap();
    canvas.clear(Color::TRANSPARENT);
    canvas
        .draw_text(
            &mut foreign,
            &foreign_layout,
            Point::default(),
            Affine::IDENTITY,
            clip,
            Color::WHITE,
        )
        .unwrap();
    assert_ne!(keys(&canvas), initial);
}

#[test]
fn recording_canvas_allocates_sole_cpu_image_only_on_request() {
    let mut canvas = Canvas::recording(53, 29, Default::default()).unwrap();
    assert_eq!(canvas.output_bytes(), 0);
    canvas.clear(Color::WHITE);
    assert_eq!(canvas.prepared_scene().draws().len(), 0);
    assert_eq!(canvas.output_bytes(), 0);
    let first = canvas.try_pixels().unwrap();
    assert_eq!(first.len(), 53 * 29 * 4);
    assert!(first.chunks_exact(4).all(|pixel| pixel == [255; 4]));
    let pointer = first.as_ptr();
    {
        let mut candidate = canvas.stage();
        candidate.clear(Color::BLACK);
        candidate.commit();
    }
    assert_eq!(canvas.try_pixels().unwrap().as_ptr(), pointer);
    assert_eq!(canvas.stats().render_count, 2);
    assert_eq!(canvas.try_pixels().unwrap().as_ptr(), pointer);
    assert_eq!(canvas.stats().render_count, 2);
}
