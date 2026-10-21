use gpui_canvas::{
    Affine, Canvas, Color, ColorConfig, OutputProfile, PixelFormat, Point, Rect, TextSystem,
};

#[test]
fn adjacent_hdr_zeros_keep_distinct_output_signs() {
    let config = ColorConfig::linear_hdr(OutputProfile::Srgb, 203.0).unwrap();
    let mut canvas = Canvas::recording(2, 1, config).unwrap();
    canvas.clear(Color::linear_srgb(-0.0, -0.0, -0.0, 1.0).unwrap());
    canvas
        .fill_rect(
            Rect::new(1.0, 0.0, 1.0, 1.0),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 2.0, 1.0),
            Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap(),
        )
        .unwrap();
    for proofs in [false, true] {
        canvas.set_tile_proofs(proofs);
        let words: Vec<_> = canvas
            .pixels()
            .chunks_exact(2)
            .map(|pair| u16::from_le_bytes([pair[0], pair[1]]))
            .collect();
        assert_eq!(words, [0x8000, 0x8000, 0x8000, 0x3c00, 0, 0, 0, 0x3c00]);
    }
}

#[test]
fn promoted_pixels_match_uncompressed_samples_across_tiles_and_color_formats() {
    fn next(seed: &mut u64) -> u32 {
        *seed = seed
            .wrapping_mul(6_364_136_223_846_793_005)
            .wrapping_add(1_442_695_040_888_963_407);
        (*seed >> 32) as u32
    }
    fn value(seed: &mut u64, range: f32) -> f32 {
        (next(seed) % 65_537) as f32 / 65_536.0 * range
    }
    let mut seed = 8_128_973;
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("office café", 13.5, None).unwrap();
    for format in [PixelFormat::Rgba8Premultiplied, PixelFormat::Rgba16Float] {
        for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
            for (width, height) in [(1, 1), (15, 17), (16, 16), (17, 31), (32, 33), (79, 53)] {
                let config = ColorConfig {
                    profile,
                    format,
                    ..Default::default()
                };
                let mut canvas = Canvas::recording(width, height, config).unwrap();
                let viewport = Rect::new(0.0, 0.0, width as f32, height as f32);
                for turn in 0..100 {
                    canvas.clear(
                        Color::linear_srgb(
                            value(&mut seed, 3.0) - 1.0,
                            value(&mut seed, 3.0) - 1.0,
                            value(&mut seed, 3.0) - 1.0,
                            value(&mut seed, 1.0),
                        )
                        .unwrap(),
                    );
                    for draw in 0..next(&mut seed) % 24 {
                        let clip = if draw % 3 == 0 {
                            viewport
                        } else {
                            Rect::new(
                                value(&mut seed, width as f32),
                                value(&mut seed, height as f32),
                                value(&mut seed, width as f32),
                                value(&mut seed, height as f32),
                            )
                        };
                        let rect = Rect::new(
                            value(&mut seed, 12.0) - 6.0,
                            value(&mut seed, 12.0) - 6.0,
                            value(&mut seed, 40.0) + 0.01,
                            value(&mut seed, 40.0) + 0.01,
                        );
                        let sign = if next(&mut seed).is_multiple_of(2) {
                            1.0
                        } else {
                            -1.0
                        };
                        let transform = Affine {
                            a: sign * (value(&mut seed, 2.0) + 0.1),
                            b: if draw % 3 == 0 {
                                value(&mut seed, 0.6) - 0.3
                            } else {
                                -0.0
                            },
                            c: if draw % 4 == 0 {
                                value(&mut seed, 0.6) - 0.3
                            } else {
                                0.0
                            },
                            d: value(&mut seed, 2.0) + 0.1,
                            tx: value(&mut seed, width as f32 + 20.0) - 10.0,
                            ty: value(&mut seed, height as f32 + 20.0) - 10.0,
                        };
                        let color = Color::linear_display_p3(
                            value(&mut seed, 10.0) - 2.0,
                            value(&mut seed, 4.0) - 1.0,
                            value(&mut seed, 7.0) - 1.0,
                            value(&mut seed, 1.0),
                        )
                        .unwrap();
                        canvas.fill_rect(rect, transform, clip, color).unwrap();
                    }
                    if turn % 5 == 0 {
                        canvas
                            .draw_text(
                                &mut text,
                                &layout,
                                Point {
                                    x: 0.125 + value(&mut seed, 12.0),
                                    y: 0.375 + value(&mut seed, 8.0),
                                },
                                Affine::IDENTITY,
                                viewport,
                                Color::linear_srgb(2.0, -0.1, 0.7, 0.6).unwrap(),
                            )
                            .unwrap();
                    }
                    canvas.set_tile_proofs(true);
                    let promoted = canvas.pixels().to_vec();
                    // Disabling proofs retains sixteen independent colors per
                    // pixel. Axis membership has its separate scalar oracle.
                    canvas.set_tile_proofs(false);
                    assert_eq!(
                        canvas.pixels(),
                        promoted,
                        "{width}x{height}, turn {turn}, {format:?}, {profile:?}"
                    );
                }
            }
        }
    }
}
