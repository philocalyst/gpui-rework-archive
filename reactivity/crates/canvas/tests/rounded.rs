use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Error, Point, Rect, rounded_rect_contains};

fn expected(rect: Rect, radius: f32, map: Affine, x: f64, y: f64) -> bool {
    // Independent inverse: subtract the translation first, then solve the
    // two-by-two system. Corner membership uses a nearest circle center.
    let (a, b, c, d) = (map.a as f64, map.b as f64, map.c as f64, map.d as f64);
    let det = a * d - b * c;
    let wx = x - map.tx as f64;
    let wy = y - map.ty as f64;
    let x = (d * wx - c * wy) / det - rect.x as f64;
    let y = (a * wy - b * wx) / det - rect.y as f64;
    let w = rect.width as f64;
    let h = rect.height as f64;
    if !(x >= 0.0 && y >= 0.0 && x < w && y < h) {
        return false;
    }
    let r = (radius as f64).min(w / 2.0).min(h / 2.0);
    if (x >= r && x <= w - r) || (y >= r && y <= h - r) {
        return true;
    }
    let cx = if x < r { r } else { w - r };
    let cy = if y < r { r } else { h - r };
    (x - cx).hypot(y - cy) <= r
}

#[test]
fn analytic_sample_oracle_reflections_shear_clips_and_radius_clamping() {
    let rect = Rect::new(1.0, 2.0, 17.0, 13.0);
    let clip = Rect::new(2.125, 1.375, 26.5, 25.25);
    for radius in [
        0.0,
        -0.0,
        f32::from_bits(1),
        0.125,
        1.0,
        5.0,
        100.0,
        f32::MAX,
    ] {
        for transform in [
            Affine::IDENTITY,
            Affine {
                a: -1.0,
                b: 0.0,
                c: 0.0,
                d: 1.0,
                tx: 27.0,
                ty: 0.0,
            },
            Affine {
                a: 1.0,
                b: 0.25,
                c: 0.5,
                d: 1.0,
                tx: 1.0,
                ty: 2.0,
            },
        ] {
            let mut canvas = Canvas::new(32, 32).unwrap();
            canvas.clear(Color::TRANSPARENT);
            canvas
                .fill_rounded_rect(rect, radius, transform, clip, Color::WHITE)
                .unwrap();
            let pixels = canvas.pixels().to_vec();
            for y in 0..32 {
                for x in 0..32 {
                    let mut count = 0;
                    for sy in 0..4 {
                        for sx in 0..4 {
                            let wx = x as f64 + (sx as f64 + 0.5) / 4.0;
                            let wy = y as f64 + (sy as f64 + 0.5) / 4.0;
                            if wx >= clip.x as f64
                                && wy >= clip.y as f64
                                && wx < clip.x as f64 + clip.width as f64
                                && wy < clip.y as f64 + clip.height as f64
                                && expected(rect, radius, transform, wx, wy)
                            {
                                count += 1;
                            }
                        }
                    }
                    let alpha = (count as f32 * 255.0 / 16.0).round() as u8;
                    assert_eq!(
                        pixels[(y * 32 + x) * 4 + 3],
                        alpha,
                        "r={radius} map={transform:?} at {x},{y}"
                    );
                }
            }
            canvas.set_tile_proofs(false);
            assert_eq!(canvas.pixels(), pixels);
        }
    }
}

#[test]
fn invalid_radius_is_transactional_and_negative_zero_is_rectangular() {
    let mut canvas = Canvas::recording(16, 16, ColorConfig::default()).unwrap();
    let rect = Rect::new(0.0, 0.0, 16.0, 16.0);
    canvas
        .fill_rect(rect, Affine::IDENTITY, rect, Color::WHITE)
        .unwrap();
    for radius in [f32::NAN, f32::INFINITY, f32::NEG_INFINITY, -1.0] {
        assert_eq!(
            canvas.fill_rounded_rect(rect, radius, Affine::IDENTITY, rect, Color::BLACK),
            Err(Error::InvalidGeometry)
        );
        assert_eq!(canvas.prepared_scene().draws().count(), 1);
        assert_eq!(
            rounded_rect_contains(rect, radius, Affine::IDENTITY, Point { x: 8.0, y: 8.0 }),
            Err(Error::InvalidGeometry)
        );
    }
    canvas.clear(Color::BLACK);
    canvas
        .fill_rounded_rect(rect, -0.0, Affine::IDENTITY, rect, Color::WHITE)
        .unwrap();
    assert!(
        canvas
            .prepared_scene()
            .draws()
            .next()
            .unwrap()
            .source
            .is_solid()
    );
    assert!(rounded_rect_contains(rect, 5.0, Affine::IDENTITY, Point { x: 0.0, y: 5.0 }).unwrap());
    assert!(!rounded_rect_contains(rect, 5.0, Affine::IDENTITY, Point { x: 0.0, y: 0.0 }).unwrap());
    assert!(
        !rounded_rect_contains(rect, 5.0, Affine::IDENTITY, Point { x: 16.0, y: 5.0 }).unwrap()
    );
}

#[test]
fn correlated_layers_cannot_fill_each_others_rounded_corners() {
    let mut canvas = Canvas::new(32, 32).unwrap();
    let rect = Rect::new(0.0, 0.0, 32.0, 32.0);
    canvas.clear(Color::TRANSPARENT);
    canvas
        .fill_rounded_rect(
            rect,
            16.0,
            Affine::IDENTITY,
            rect,
            Color::rgba(255, 0, 0, 128),
        )
        .unwrap();
    canvas
        .fill_rounded_rect(
            rect,
            16.0,
            Affine::IDENTITY,
            rect,
            Color::rgba(0, 0, 255, 128),
        )
        .unwrap();
    let first = canvas.pixels().to_vec();
    assert_eq!(first[3], 0);
    assert_eq!(first[(16 * 32 + 16) * 4 + 3], 192);
    assert_eq!(canvas.stats().full_rect_tiles, 0);
    canvas.set_tile_proofs(false);
    assert_eq!(first, canvas.pixels());
}

#[test]
fn source_word_preserves_every_finite_radius_exponent_and_mantissa_samples() {
    let mut canvas = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
    let rect = Rect::new(0.0, 0.0, 1.0, 1.0);
    for exponent in 0..255 {
        for mantissa in [0, 1, 0x003fffff, 0x007fffff] {
            let bits = exponent << 23 | mantissa;
            let radius = f32::from_bits(bits);
            canvas.clear(Color::WHITE);
            canvas
                .fill_rounded_rect(rect, radius, Affine::IDENTITY, rect, Color::BLACK)
                .unwrap();
            let source = canvas.prepared_scene().draws().next().unwrap().source;
            if bits == 0 {
                assert!(source.is_solid());
            } else {
                assert_eq!(source.corner_radius().unwrap().to_bits(), bits);
            }
        }
    }
}

#[test]
fn public_image_views_keep_canonical_material_and_exact_authored_radius() {
    use gpui_canvas::{AlphaMode, Image, ImageOptions, ImageSampling};
    let image = Image::linear_srgb(1, 1, AlphaMode::Straight, Box::new([[1.0; 4]])).unwrap();
    let mut canvas = Canvas::recording(16, 16, ColorConfig::default()).unwrap();
    let rect = Rect::new(0.0, 0.0, 16.0, 16.0);
    for radius in [0.0, -0.0, f32::from_bits(1), 5.25, f32::MAX] {
        canvas.clear(Color::TRANSPARENT);
        canvas
            .draw_image_with(
                &image,
                rect,
                Affine::IDENTITY,
                rect,
                ImageOptions {
                    sampling: ImageSampling::Linear,
                    corner_radius: radius,
                },
            )
            .unwrap();
        let scene = canvas.prepared_scene();
        let draw = scene.draws().next().unwrap();
        assert_eq!(draw.color, [1.0; 4]);
        assert_eq!(scene.groups().next().unwrap().color, [1.0; 4]);
        assert_eq!(draw.source.image().unwrap().0.key(), image.key());
        if radius == 0.0 {
            assert!(draw.source.corner_radius().is_none());
        } else {
            assert_eq!(
                draw.source.corner_radius().unwrap().to_bits(),
                radius.to_bits()
            );
        }
    }
}
