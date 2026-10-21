use gpui_canvas::{Affine, Canvas, Color, Error, Point, Rect, TextSystem};

const FONT: &[u8] = include_bytes!("../assets/NotoSans.ttf");
fn clip() -> Rect {
    Rect::new(0.0, 0.0, 96.0, 72.0)
}
fn white() -> Color {
    Color::rgb(255, 255, 255)
}
fn black() -> Color {
    Color::rgb(0, 0, 0)
}

#[test]
fn linear_light_alpha_and_premultiplied_output() {
    let mut canvas = Canvas::new(2, 1).unwrap();
    canvas.clear(Color::rgba(0, 0, 255, 255));
    canvas
        .fill_rect(
            Rect::new(0.0, 0.0, 1.0, 1.0),
            Affine::IDENTITY,
            clip(),
            Color::rgba(255, 0, 0, 128),
        )
        .unwrap();
    let pixels = canvas.pixels();
    assert!((pixels[0] as i16 - 188).abs() <= 1);
    assert!((pixels[2] as i16 - 187).abs() <= 1);
    assert_eq!(pixels[3], 255);
    assert_eq!(&pixels[4..], [0, 0, 255, 255]);
    canvas.clear(Color::rgba(255, 0, 0, 128));
    assert_eq!(&canvas.pixels()[..4], [128, 0, 0, 128]);
}

// Independent oracle: forward-transform a polygon and test oriented edges,
// retain all subpixel colors, composite in f64, average, encode only at the end.
// It deliberately does not call the canvas inverse, classifier or blend helpers.
#[derive(Clone, Copy)]
struct Draw {
    rect: Rect,
    transform: Affine,
    clip: Rect,
    color: Color,
}
fn inside(draw: Draw, x: f64, y: f64) -> bool {
    let c = draw.clip;
    if x < c.x as f64
        || y < c.y as f64
        || x >= c.x as f64 + c.width as f64
        || y >= c.y as f64 + c.height as f64
    {
        return false;
    }
    let r = draw.rect;
    let t = draw.transform;
    let points = [
        (r.x as f64, r.y as f64),
        (r.x as f64 + r.width as f64, r.y as f64),
        (r.x as f64 + r.width as f64, r.y as f64 + r.height as f64),
        (r.x as f64, r.y as f64 + r.height as f64),
    ]
    .map(|(x, y)| {
        (
            t.a as f64 * x + t.c as f64 * y + t.tx as f64,
            t.b as f64 * x + t.d as f64 * y + t.ty as f64,
        )
    });
    let sign = (t.a as f64 * t.d as f64 - t.b as f64 * t.c as f64).signum();
    for i in 0..4 {
        let a = points[i];
        let b = points[(i + 1) % 4];
        let cross = ((b.0 - a.0) * (y - a.1) - (b.1 - a.1) * (x - a.0)) * sign;
        if cross < 0.0 || (cross == 0.0 && (i == 1 || i == 2)) {
            return false;
        }
    }
    true
}
fn decode(value: f32) -> f64 {
    let v = value as f64;
    if v <= 0.04045 {
        v / 12.92
    } else {
        ((v + 0.055) / 1.055).powf(2.4)
    }
}
fn source(c: Color) -> [f64; 4] {
    let [r, g, b, a] = c.channels();
    let a = a as f64;
    [decode(r) * a, decode(g) * a, decode(b) * a, a]
}
fn encoded(c: [f64; 4]) -> [u8; 4] {
    let mut out = [0; 4];
    let a = c[3];
    if a == 0.0 {
        return out;
    }
    for i in 0..3 {
        let v = (c[i] / a).clamp(0.0, 1.0);
        let e = if v <= 0.0031308 {
            12.92 * v
        } else {
            1.055 * v.powf(1.0 / 2.4) - 0.055
        };
        out[i] = (e * a * 255.0).round() as u8;
    }
    out[3] = (a * 255.0).round() as u8;
    out
}
fn reference(width: usize, height: usize, background: Color, draws: &[Draw]) -> Vec<u8> {
    let mut result = Vec::with_capacity(width * height * 4);
    for y in 0..height {
        for x in 0..width {
            let mut average = [0.0; 4];
            for sy in 0..4 {
                for sx in 0..4 {
                    let wx = x as f64 + (sx as f64 + 0.5) / 4.0;
                    let wy = y as f64 + (sy as f64 + 0.5) / 4.0;
                    let mut color = source(background);
                    for &draw in draws {
                        if inside(draw, wx, wy) {
                            let src = source(draw.color);
                            for i in 0..4 {
                                color[i] = src[i] + color[i] * (1.0 - src[3]);
                            }
                        }
                    }
                    for i in 0..4 {
                        average[i] += color[i] / 16.0;
                    }
                }
            }
            result.extend_from_slice(&encoded(average));
        }
    }
    result
}
fn assert_close(actual: &[u8], expected: &[u8]) {
    assert_eq!(actual.len(), expected.len());
    for (i, (&a, &b)) in actual.iter().zip(expected).enumerate() {
        assert!((a as i16 - b as i16).abs() <= 1, "byte {i}: {a} vs {b}");
    }
}

#[test]
fn transformed_rectangles_match_exhaustive_sample_oracle() {
    let mut seed = 13u64;
    let mut next = || {
        seed = seed.wrapping_mul(6364136223846793005).wrapping_add(1);
        ((seed >> 32) as u32) as f32 / u32::MAX as f32
    };
    for scene in 0..20 {
        let mut draws = Vec::new();
        let mut canvas = Canvas::new(41, 29).unwrap();
        let background = Color::rgba(10, 20, 30, 83);
        canvas.clear(background);
        // Large interior and opaque overlap exercise both certification and cuts.
        draws.push(Draw {
            rect: Rect::new(-2.0, -2.0, 46.0, 35.0),
            transform: Affine::IDENTITY,
            clip: clip(),
            color: Color::rgb(20, 70, 150),
        });
        for _ in 0..12 {
            draws.push(Draw {
                rect: Rect::new(-5.0, -3.0, 5.0 + next() * 28.0, 4.0 + next() * 24.0),
                transform: Affine {
                    a: if scene % 2 == 0 {
                        -0.5 - next()
                    } else {
                        0.5 + next()
                    },
                    b: next() - 0.5,
                    c: next() - 0.5,
                    d: 0.5 + next(),
                    tx: next() * 41.0,
                    ty: next() * 29.0,
                },
                clip: Rect::new(1.3, 2.6, 35.2, 23.1),
                color: Color::rgba(
                    (next() * 255.0) as u8,
                    (next() * 255.0) as u8,
                    (next() * 255.0) as u8,
                    (next() * 255.0) as u8,
                ),
            });
        }
        for draw in &draws {
            canvas
                .fill_rect(draw.rect, draw.transform, draw.clip, draw.color)
                .unwrap();
        }
        let expected = reference(41, 29, background, &draws);
        assert_close(canvas.pixels(), &expected);
        let accelerated = canvas.pixels().to_vec();
        canvas.set_tile_proofs(false);
        assert_close(canvas.pixels(), &expected);
        assert_eq!(canvas.pixels(), accelerated);
    }
}

#[test]
fn correlated_edges_are_composited_before_sample_average() {
    let mut canvas = Canvas::new(1, 1).unwrap();
    let left = Rect::new(0.0, 0.0, 0.5, 1.0);
    canvas
        .fill_rect(left, Affine::IDENTITY, clip(), Color::rgb(255, 0, 0))
        .unwrap();
    canvas
        .fill_rect(left, Affine::IDENTITY, clip(), Color::rgb(0, 0, 255))
        .unwrap();
    // Half blue, half transparent. Averaging each primitive before composition
    // incorrectly leaves a red contribution and gives alpha 0.75.
    assert_eq!(canvas.pixels(), [0, 0, 128, 128]);
}

#[test]
fn real_shaping_ligatures_unicode_measure_and_paint_are_stable() {
    let mut text = TextSystem::new(FONT).unwrap();
    let layout = text.shape("office café e\u{301}", 22.0, None).unwrap();
    assert!(layout.glyphs().len() < "office café e\u{301}".chars().count());
    assert!(layout.width > 70.0 && layout.baseline > 0.0 && layout.height > layout.baseline);
    let repeat = text.shape("office café e\u{301}", 22.0, None).unwrap();
    assert!(
        !text
            .shape("Ελληνικά", 22.0, None)
            .unwrap()
            .glyphs()
            .is_empty()
    );
    assert!(
        !text
            .shape("Привет", 22.0, None)
            .unwrap()
            .glyphs()
            .is_empty()
    );
    assert!(matches!(
        text.shape("Latin Ω", 22.0, None),
        Err(Error::UnsupportedScript('Ω'))
    ));
    assert_eq!(layout.glyphs(), repeat.glyphs());
    assert_eq!(layout.width, repeat.width);
    let ink = text.ink_bounds(&layout).unwrap();
    let mut canvas = Canvas::new(240, 80).unwrap();
    canvas.clear(white());
    canvas
        .draw_text(
            &mut text,
            &layout,
            Point { x: 10.0, y: 8.0 },
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 240.0, 80.0),
            black(),
        )
        .unwrap();
    let first = canvas.pixels().to_vec();
    let dark: Vec<_> = first
        .chunks_exact(4)
        .enumerate()
        .filter(|(_, p)| p[0] < 240)
        .map(|(i, _)| (i % 240, i / 240))
        .collect();
    assert!(dark.len() > 100);
    for (x, y) in dark {
        assert!(x as f32 + 1.0 >= 10.0 + ink.x && x as f32 <= 10.0 + ink.x + ink.width + 1.0);
        assert!(y as f32 + 1.0 >= 8.0 + ink.y && y as f32 <= 8.0 + ink.y + ink.height + 1.0);
    }
    let stats = canvas.stats();
    assert_eq!(canvas.pixels(), first);
    assert_eq!(canvas.stats().sample_tests, stats.sample_tests);
    assert_eq!(canvas.stats().render_count, stats.render_count);
    text.clear_cache();
    // Retained commands lease masks even if the font service cache is evicted.
    canvas
        .fill_rect(
            Rect::new(230.0, 70.0, 2.0, 2.0),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 240.0, 80.0),
            white(),
        )
        .unwrap();
    assert_eq!(canvas.pixels(), first);
}

#[test]
fn wrapped_runs_keep_utf8_clusters_and_reshape_lines() {
    let text = TextSystem::new(FONT).unwrap();
    let one = text.shape("office", 18.0, None).unwrap();
    let source = "office café office café";
    let wrapped = text.shape(source, 18.0, Some(one.width + 1.0)).unwrap();
    assert!(wrapped.height > one.height);
    assert!(wrapped.width <= one.width + 1.0);
    for glyph in wrapped.glyphs() {
        assert!(source.is_char_boundary(glyph.cluster as usize));
    }
    let newline = text.shape("office\n", 18.0, None).unwrap();
    assert_eq!(newline.height, one.height * 2.0);
}

#[test]
fn transformed_text_clip_and_foreign_layout_failure_are_explicit() {
    let mut text = TextSystem::new(FONT).unwrap();
    let foreign = TextSystem::new(FONT).unwrap();
    let layout = text.shape("café", 24.0, None).unwrap();
    let mut canvas = Canvas::new(96, 72).unwrap();
    canvas.clear(white());
    let transform = Affine {
        a: -1.0,
        b: 0.2,
        c: 0.4,
        d: 1.0,
        tx: 90.0,
        ty: 0.0,
    };
    let window_clip = Rect::new(20.25, 10.0, 50.0, 30.5);
    canvas
        .draw_text(
            &mut text,
            &layout,
            Point { x: 0.0, y: 0.0 },
            transform,
            window_clip,
            black(),
        )
        .unwrap();
    let output = canvas.pixels().to_vec();
    assert!(output.chunks_exact(4).any(|p| p[0] < 200));
    for y in 0..72 {
        for x in 0..96 {
            if !(20..71).contains(&x) || !(10..41).contains(&y) {
                assert_eq!(
                    &output[(y * 96 + x) * 4..(y * 96 + x) * 4 + 4],
                    [255, 255, 255, 255]
                );
            }
        }
    }
    let foreign_layout = foreign.shape("x", 18.0, None).unwrap();
    assert_eq!(
        canvas.draw_text(
            &mut text,
            &foreign_layout,
            Point::default(),
            Affine::IDENTITY,
            clip(),
            black()
        ),
        Err(Error::ForeignLayout)
    );
    assert_eq!(canvas.pixels(), output);
}

#[test]
fn invalid_inputs_and_caps_do_not_corrupt_scene() {
    assert!(matches!(Canvas::new(0, 1), Err(Error::InvalidDimensions)));
    assert!(matches!(
        Canvas::new(u32::MAX, 2),
        Err(Error::InvalidDimensions)
    ));
    assert!(TextSystem::new(b"broken").is_err());
    let text = TextSystem::new(FONT).unwrap();
    assert!(matches!(
        text.shape("abc", f32::NAN, None),
        Err(Error::InvalidFontSize)
    ));
    assert!(matches!(
        text.shape("abc", 12.0, Some(0.0)),
        Err(Error::InvalidWidth)
    ));
    assert!(matches!(
        text.shape("a\tb", 12.0, None),
        Err(Error::UnsupportedControl('\t'))
    ));
    assert!(matches!(
        text.shape("a\u{202e}b", 12.0, None),
        Err(Error::UnsupportedControl('\u{202e}'))
    ));
    assert!(matches!(
        text.shape("\u{10ffff}", 12.0, None),
        Err(Error::MissingGlyph(_))
    ));
    assert!(matches!(
        text.shape(&"a".repeat(32769), 12.0, None),
        Err(Error::ResourceLimit)
    ));
    let mut canvas = Canvas::new(1, 1).unwrap();
    canvas.clear(white());
    let before = canvas.pixels().to_vec();
    assert_eq!(
        canvas.fill_rect(
            Rect::new(0.0, 0.0, 1.0, 1.0),
            Affine::scale(0.0, 1.0),
            clip(),
            black()
        ),
        Err(Error::InvalidGeometry)
    );
    assert_eq!(canvas.pixels(), before);
    for _ in 0..65_536 {
        canvas
            .fill_rect(
                Rect::new(0.0, 0.0, 1.0, 1.0),
                Affine::IDENTITY,
                clip(),
                black(),
            )
            .unwrap();
    }
    assert_eq!(
        canvas.fill_rect(
            Rect::new(0.0, 0.0, 1.0, 1.0),
            Affine::IDENTITY,
            clip(),
            black()
        ),
        Err(Error::ResourceLimit)
    );
    assert_eq!(canvas.pixels(), [0, 0, 0, 255]);
}

#[test]
fn swash_native_pixels_and_transformed_cells_match_independent_oracles() {
    let mut text = TextSystem::bundled().unwrap();

    for content in ["H", "j", "é"] {
        let layout = text.shape(content, 22.0, None).unwrap();
        let glyph = layout.glyphs()[0];
        let (metrics, mask) = reference_mask(glyph.id, 22.0);
        let origin = Point {
            x: 12.0,
            y: 32.0 - layout.baseline,
        };
        let left = 12 + metrics.xmin;
        let top = 32 - metrics.ymin - metrics.height as i32;
        let mut expected = vec![0; 64 * 64 * 4];
        for y in 0..metrics.height {
            for x in 0..metrics.width {
                let index = ((top as usize + y) * 64 + left as usize + x) * 4;
                expected[index..index + 4].fill(mask[y * metrics.width + x]);
            }
        }
        let mut canvas = Canvas::new(64, 64).unwrap();
        canvas
            .draw_text(
                &mut text,
                &layout,
                origin,
                Affine::IDENTITY,
                Rect::new(0.0, 0.0, 64.0, 64.0),
                Color::WHITE,
            )
            .unwrap();
        assert_close(canvas.pixels(), &expected);
    }
    let layout = text.shape("H", 12.0, None).unwrap();
    let glyph = layout.glyphs()[0];
    let (metrics, mask) = reference_mask(glyph.id, 12.0);
    let origin = Point { x: 4.0, y: 2.0 };
    let transform = Affine {
        a: -1.0,
        b: 0.2,
        c: 0.35,
        d: 1.1,
        tx: 35.0,
        ty: 0.0,
    };
    let window_clip = Rect::new(1.25, 2.5, 43.0, 30.0);
    let gx = origin.x + glyph.x + metrics.xmin as f32;
    let gy = origin.y + glyph.baseline - metrics.ymin as f32 - metrics.height as f32;
    let mut draws = Vec::new();
    for y in 0..metrics.height {
        for x in 0..metrics.width {
            let alpha = mask[y * metrics.width + x];
            if alpha == 0 {
                continue;
            }
            draws.push(Draw {
                rect: Rect::new(gx + x as f32, gy + y as f32, 1.0, 1.0),
                transform,
                clip: window_clip,
                color: Color::rgba(255, 255, 255, alpha),
            });
        }
    }
    let expected = reference(48, 36, Color::TRANSPARENT, &draws);
    let mut canvas = Canvas::new(48, 36).unwrap();
    canvas
        .draw_text(
            &mut text,
            &layout,
            origin,
            transform,
            window_clip,
            Color::WHITE,
        )
        .unwrap();
    assert_close(canvas.pixels(), &expected);
}

#[test]
fn staged_scene_keeps_old_pixels_and_reuses_the_output_allocation() {
    let mut canvas = Canvas::new(32, 24).unwrap();
    canvas.clear(Color::WHITE);
    let address = canvas.pixels().as_ptr();
    let previous = canvas.pixels().to_vec();
    {
        let mut candidate = canvas.stage();
        candidate.clear(Color::BLACK);
        assert_eq!(
            candidate.fill_rect(
                Rect::new(0.0, 0.0, 1.0, 1.0),
                Affine::scale(0.0, 1.0),
                clip(),
                Color::WHITE
            ),
            Err(Error::InvalidGeometry)
        );
        // Failure/drop cannot mutate the target command list or pixels.
    }
    assert_eq!(canvas.pixels(), previous);
    assert_eq!(canvas.pixels().as_ptr(), address);
    let mut candidate = canvas.stage();
    candidate.clear(Color::BLACK);
    candidate.commit();
    assert_eq!(canvas.pixels().as_ptr(), address);
    assert!(canvas.pixels().chunks_exact(4).all(|p| p == [0, 0, 0, 255]));
}

#[test]
fn no_sample_draw_preserves_the_entire_background_at_quantization_thresholds() {
    use gpui_canvas::{ColorConfig, PixelFormat};
    // Just above the exact opaque sRGB byte0/1 transition. Repeated f32
    // accumulation of sixteen identical clear samples used to move it below
    // that transition, so adding a zero-coverage draw darkened its whole tile.
    let threshold = f32::from_bits(0x391f22b4);
    for format in [PixelFormat::Rgba8Premultiplied, PixelFormat::Rgba16Float] {
        for proofs in [false, true] {
            for alpha in [1.0, 0.5] {
                let mut canvas = Canvas::with_color_config(
                    32,
                    17,
                    ColorConfig {
                        format,
                        ..Default::default()
                    },
                )
                .unwrap();
                canvas.set_tile_proofs(proofs);
                // Keep premultiplied red on the same threshold for both alphas.
                canvas.clear(Color::linear_srgb(threshold / alpha, 0.0, 0.0, alpha).unwrap());
                let before = canvas.pixels().to_vec();
                canvas
                    .fill_rect(
                        Rect::new(0.0, 0.0, 0.01, 0.01),
                        Affine::IDENTITY,
                        Rect::new(0.0, 0.0, 32.0, 17.0),
                        Color::WHITE,
                    )
                    .unwrap();
                assert_eq!(
                    canvas.pixels(),
                    before,
                    "zero-coverage draw changed background: {format:?}, proofs={proofs}, alpha={alpha}"
                );
            }
        }
    }
}

// Fresh independent context, no production cache/preflight/placement conversion.
fn reference_mask(glyph: u16, size: f32) -> (fontdue::Metrics, Vec<u8>) {
    let mut context = swash::scale::ScaleContext::new();
    let font = swash::FontRef::from_index(FONT, 0).unwrap();
    let mut scaler = context.builder(font).size(size).hint(false).build();
    let image = swash::scale::Render::new(&[swash::scale::Source::Outline])
        .format(swash::zeno::Format::Alpha)
        .render(&mut scaler, glyph)
        .unwrap();
    let p = image.placement;
    (
        fontdue::Metrics {
            xmin: p.left,
            ymin: p.top - p.height as i32,
            width: p.width as usize,
            height: p.height as usize,
            ..Default::default()
        },
        image.data,
    )
}
