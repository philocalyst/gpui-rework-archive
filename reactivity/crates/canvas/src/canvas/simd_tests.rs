//! Explicit backend calls, without a global or test-only production dispatcher.
use super::*;
use crate::{AlphaMode, ImageOptions, OutputProfile, PixelFormat};

struct Backend<S>(S);
impl<S: Simd> RenderSchedule for Backend<S> {
    fn render<W: PixelWriter>(
        &self,
        frame: Frame<'_>,
        writer: W,
        pixels: &mut [W::Element],
        offsets: &[u32],
        members: &mut [u32],
    ) -> RenderStats {
        let columns = usize::from(frame.raster_bounds[2] - frame.raster_bounds[0]);
        let mut stats = RenderStats::default();
        for row in frame.tile_bounds[1]..frame.tile_bounds[3] {
            let begin = (row - frame.tile_bounds[1]) * columns;
            let end = begin + columns;
            let mut band = frame;
            band.tile_bounds[1] = row;
            band.tile_bounds[3] = row + 1;
            let low = row * TILE * frame.width * W::ELEMENTS;
            let high = ((row + 1) * TILE).min(frame.height) * frame.width * W::ELEMENTS;
            let local_members = &mut members
                [(offsets[begin] - offsets[0]) as usize..(offsets[end] - offsets[0]) as usize];
            stats = combine_stats(
                stats,
                render_band_impl(
                    self.0,
                    band,
                    writer,
                    &mut pixels[low..high],
                    &offsets[begin..=end],
                    local_members,
                ),
            );
        }
        stats
    }
}

// Independent uncompressed scalar composition, with no Samples, tile proofs,
// separable coverage, SIMD helpers, encoded-color cache, or production reduction.
// Primitive sampling/encoders have separate analytic and published-value oracles
// in the integration suite; this checks their complete pipeline composition.
fn reference(canvas: &Canvas) -> Vec<u8> {
    let elements = if canvas.color_config.format == PixelFormat::Rgba16Float {
        8
    } else {
        4
    };
    let mut output = vec![0; canvas.width * canvas.height * elements];
    for y in 0..canvas.height {
        for x in 0..canvas.width {
            let mut values = [canvas.clear; 16];
            for command in canvas.commands.iter() {
                match command.source {
                    BorrowedSource::ImageNearest(image) | BorrowedSource::ImageLinear(image) => {
                        let sampling = if matches!(command.source, BorrowedSource::ImageNearest(_))
                        {
                            ImageSampling::Nearest
                        } else {
                            ImageSampling::Linear
                        };
                        for (index, dst) in values.iter_mut().enumerate() {
                            let wx = x as f64 + SAMPLES[index % 4];
                            let wy = y as f64 + SAMPLES[index / 4];
                            if wx < command.clip.x as f64
                                || wy < command.clip.y as f64
                                || wx >= command.clip.x as f64 + command.clip.width as f64
                                || wy >= command.clip.y as f64 + command.clip.height as f64
                            {
                                continue;
                            }
                            let (lx, ly) = command.map.local(wx, wy);
                            let lx = lx - command.rect.x as f64;
                            let ly = ly - command.rect.y as f64;
                            if command.color[0] > 0.0
                                && !rounded::contains(
                                    Rect::new(0.0, 0.0, command.rect.width, command.rect.height),
                                    command.color[0],
                                    lx,
                                    ly,
                                )
                            {
                                continue;
                            }
                            if let Some(source) = image.view().sample(
                                lx,
                                ly,
                                command.rect.width as f64,
                                command.rect.height as f64,
                                sampling,
                            ) {
                                for channel in 0..4 {
                                    dst[channel] =
                                        source[channel] * 1.0 + dst[channel] * (1.0 - source[3]);
                                }
                            }
                        }
                    }
                    _ => {
                        for (dst, coverage) in values.iter_mut().zip(sample(
                            &command,
                            x,
                            y,
                            &mut RenderStats::default(),
                        )) {
                            if coverage > 0.0 {
                                let alpha = command.color[3] * coverage;
                                for (channel, dst) in dst.iter_mut().enumerate() {
                                    *dst = command.color[channel] * coverage + *dst * (1.0 - alpha);
                                }
                            }
                        }
                    }
                }
            }
            let color = std::array::from_fn(|channel| {
                let mut sum = values[0][channel] as f64;
                for value in &values[1..] {
                    sum += value[channel] as f64;
                }
                (sum / 16.0) as f32
            });
            let destination = &mut output[(y * canvas.width + x) * elements..][..elements];
            match canvas.color_config.format {
                PixelFormat::Rgba16Float => {
                    destination.copy_from_slice(&canvas.color_config.half_encoder().encode(color))
                }
                PixelFormat::Rgba8Premultiplied => {
                    destination.copy_from_slice(&canvas.color_config.encoder().encode(color))
                }
            }
        }
    }
    output
}

fn check<S: Simd>(simd: S, canvas: &mut Canvas, expected: &[u8]) {
    canvas.pixels.resize(expected.len(), 0);
    for proofs in [false, true] {
        canvas.set_tile_proofs(proofs);
        canvas.render(&Backend(simd));
        assert_eq!(
            canvas.pixels,
            expected,
            "{:?}, proofs={proofs}, {:?}",
            simd.level(),
            canvas.color_config
        );
    }
}

#[test]
fn complete_pixels_all_supported_backends_match_independent_sample_composition() {
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("Ag café", 9.5, None).unwrap();
    let image = Image::linear_srgb(
        2,
        2,
        AlphaMode::Premultiplied,
        vec![
            [-0.0, 0.25, 1.5, 0.5],
            [0.5, -0.125, 2.0, 0.75],
            [f32::from_bits(1), -0.0, 0.0, 1.0],
            [0.0; 4],
        ]
        .into_boxed_slice(),
    )
    .unwrap();
    for format in [PixelFormat::Rgba8Premultiplied, PixelFormat::Rgba16Float] {
        for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
            let mut canvas = Canvas::recording(
                33,
                17,
                ColorConfig {
                    format,
                    profile,
                    ..Default::default()
                },
            )
            .unwrap();
            canvas.clear(Color::linear_srgb(-0.0, f32::from_bits(1), -0.0, 1.0).unwrap());
            let clip = Rect::new(0.125, 0.375, 32.5, 16.5);
            for (index, color) in [
                Color::oklch(0.7, 0.3, 137.5, 0.625).unwrap(),
                Color::linear_display_p3(2.5, -0.125, 0.3, 0.75).unwrap(),
                Color::linear_srgb(
                    0.5_f32.next_down(),
                    0.5_f32.next_up(),
                    -f32::from_bits(1),
                    0.5,
                )
                .unwrap(),
            ]
            .into_iter()
            .enumerate()
            {
                let map = Affine {
                    a: if index == 1 { -0.8 } else { 1.0 },
                    b: 0.125,
                    c: -0.25,
                    d: 0.9,
                    tx: 4.0 + index as f32 * 7.0,
                    ty: 0.375,
                };
                canvas
                    .fill_rect(Rect::new(0.125, 1.375, 15.25, 9.5), map, clip, color)
                    .unwrap();
                canvas
                    .fill_rounded_rect(Rect::new(0.5, 0.75, 11.5, 13.25), 3.25, map, clip, color)
                    .unwrap();
            }
            for (index, sampling) in [ImageSampling::Nearest, ImageSampling::Linear]
                .into_iter()
                .enumerate()
            {
                canvas
                    .draw_image_with(
                        &image,
                        Rect::new(0.125, 0.375, 13.75, 11.25),
                        Affine {
                            a: 1.0,
                            b: 0.125 * index as f32,
                            c: -0.25,
                            d: 1.0,
                            tx: 13.0,
                            ty: 1.0,
                        },
                        clip,
                        ImageOptions {
                            sampling,
                            corner_radius: index as f32 * 2.5,
                        },
                    )
                    .unwrap();
            }
            canvas
                .draw_text(
                    &mut text,
                    &layout,
                    Point { x: 0.375, y: 6.125 },
                    Affine::IDENTITY,
                    clip,
                    Color::rgba(137, 31, 211, 193),
                )
                .unwrap();
            let expected = reference(&canvas);
            check(fearless_simd::Fallback::new(), &mut canvas, &expected);
            let level = Level::new();
            #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
            {
                if let Some(s) = level.as_sse2() {
                    check(s, &mut canvas, &expected);
                }
                if let Some(s) = level.as_sse4_2() {
                    check(s, &mut canvas, &expected);
                }
                if let Some(s) = level.as_avx2() {
                    check(s, &mut canvas, &expected);
                }
                if let Some(s) = level.as_avx512() {
                    check(s, &mut canvas, &expected);
                }
            }
            #[cfg(target_arch = "aarch64")]
            if let Some(s) = level.as_neon() {
                check(s, &mut canvas, &expected);
            }
            #[cfg(all(target_arch = "wasm32", target_feature = "simd128"))]
            if let Some(s) = level.as_wasm_simd128() {
                check(s, &mut canvas, &expected);
            }
            eprintln!("complete scene executed supported backends through {level:?}");
        }
    }
}
