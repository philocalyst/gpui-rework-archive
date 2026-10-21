use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};

const FONT: &[u8] = include_bytes!("../assets/NotoSans.ttf");

#[test]
fn requested_outline_masks_have_real_coverage_and_preserve_placement() {
    let old = fontdue::Font::from_bytes(FONT, fontdue::FontSettings::default()).unwrap();
    let mut text = TextSystem::bundled().unwrap();
    let mut compared = 0;
    let mut changed = 0;
    let mut error = 0_u64;
    let mut max_error = 0_u8;
    let mut bytes = 0;
    for content in ["office café AVATAR", "Αθήνα", "Привет", "jéÅ"] {
        for density in [1.0, 1.25, 2.0] {
            let layout = text.shape(content, 16.0, None).unwrap();
            let old_line = old.horizontal_line_metrics(16.0).unwrap();
            // Parley/Skrifa compute line metrics with a different f32 operation
            // order from Fontdue. Keep the independent metric check within four
            // ULPs; mask dimensions and placement below remain exact/tight.
            assert!(
                layout
                    .baseline
                    .to_bits()
                    .abs_diff(old_line.ascent.to_bits())
                    <= 4
            );
            assert!(
                layout
                    .height
                    .to_bits()
                    .abs_diff(old_line.new_line_size.max(16.0).to_bits())
                    <= 4
            );
            let mut canvas = Canvas::recording(512, 96, ColorConfig::default()).unwrap();
            canvas
                .draw_text_scaled(
                    &mut text,
                    &layout,
                    Point { x: 4.0, y: 2.0 },
                    Affine::scale(density, density),
                    Rect::new(0.0, 0.0, 512.0, 96.0),
                    Color::WHITE,
                    density,
                )
                .unwrap();
            let scene = canvas.prepared_scene();
            // Space has no outline; all other glyphs have an actual leased mask.
            let glyphs = layout
                .glyphs()
                .iter()
                .filter(|g| old.rasterize_indexed(g.id, 16.0 * density).0.width != 0)
                .collect::<Vec<_>>();
            assert_eq!(
                scene.draws().len(),
                glyphs.len(),
                "{content:?}, density={density}"
            );
            for (draw, glyph) in scene.draws().zip(glyphs) {
                let mask = draw.source.mask().unwrap();
                let (metrics, prior) = old.rasterize_indexed(glyph.id, 16.0 * density);
                assert_eq!((mask.width, mask.height), (metrics.width, metrics.height));
                let expected_x = 4.0 + glyph.x + metrics.xmin as f32 / density;
                let expected_y =
                    2.0 + glyph.baseline - (metrics.ymin + metrics.height as i32) as f32 / density;
                assert!((draw.local_rect.x - expected_x).abs() < 0.0001);
                assert!((draw.local_rect.y - expected_y).abs() < 0.0001);
                assert!(mask.coverage.iter().any(|&a| a != 0));
                assert!(mask.coverage.iter().any(|&a| a != 0 && a != 255));
                for (&a, b) in mask.coverage.iter().zip(prior) {
                    max_error = max_error.max(a.abs_diff(b));
                    changed += usize::from(a != b);
                    error += (i64::from(a) - i64::from(b)).unsigned_abs().pow(2);
                    bytes += 1;
                }
                compared += 1;
            }
            assert_ne!(scene.draws().len(), 0);
        }
    }
    // This is an intentional rasterizer change, not exact Fontdue parity.
    // Observed RMSE 1.51; a four-level RMS cap permits small backend/platform
    // rounding changes, while rejecting widespread coverage shifts.
    assert_eq!(compared, 84);
    assert!(changed > 0);
    assert!((error as f64 / bytes as f64).sqrt() < 4.0);
    eprintln!(
        "mask_count={compared},mask_bytes={bytes},changed_bytes={changed},max_error={max_error},coverage_rmse={:.4}",
        (error as f64 / bytes as f64).sqrt()
    );
}

#[test]
fn empty_glyphs_do_not_create_masks_and_clearing_cache_preserves_scene_leases() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("   ", 16.0, None).unwrap();
    let mut canvas = Canvas::recording(80, 40, ColorConfig::default()).unwrap();
    canvas
        .draw_text(
            &mut text,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 80.0, 40.0),
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(text.cache_bytes(), 0);
    assert_eq!(canvas.prepared_scene().draws().len(), 0);
    let layout = text.shape("éj", 16.0, None).unwrap();
    canvas
        .draw_text(
            &mut text,
            &layout,
            Point::default(),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 80.0, 40.0),
            Color::WHITE,
        )
        .unwrap();
    let before = canvas.try_pixels().unwrap().to_vec();
    assert!(text.cache_bytes() > 0);
    text.clear_cache();
    assert_eq!(text.cache_bytes(), 0);
    canvas
        .fill_rect(
            Rect::new(79.0, 39.0, 0.01, 0.01),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 80.0, 40.0),
            Color::WHITE,
        )
        .unwrap();
    assert_eq!(canvas.try_pixels().unwrap(), before);
}

#[test]
fn immutable_font_admission_has_no_eager_outline_heap() {
    let mut face = None;
    let measured = allocation_counter::measure(|| {
        face = Some(gpui_canvas::FontFace::bundled().unwrap());
    });
    // A shared face may already exist; cold admission is only its Arc header.
    assert!(measured.bytes_current < 4096, "{measured:?}");
    let mut text = TextSystem::from_font(face.unwrap());
    let layout = text.shape("office café AVATAR", 16.0, None).unwrap();
    assert_eq!(text.cache_bytes(), 0);
    let mut canvas = Canvas::recording(256, 64, ColorConfig::default()).unwrap();
    let prepared = allocation_counter::measure(|| {
        canvas
            .draw_text(
                &mut text,
                &layout,
                Point::default(),
                Affine::IDENTITY,
                Rect::new(0.0, 0.0, 256.0, 64.0),
                Color::WHITE,
            )
            .unwrap();
    });
    assert!(prepared.bytes_current < 128 * 1024, "{prepared:?}");
    let before = text.cache_bytes();
    let huge = text.shape("W", 512.0, None).unwrap();
    assert_eq!(
        canvas.draw_text_scaled(
            &mut text,
            &huge,
            Point::default(),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 256.0, 64.0),
            Color::WHITE,
            8.0
        ),
        Err(gpui_canvas::Error::ResourceLimit)
    );
    assert_eq!(text.cache_bytes(), before);
}
