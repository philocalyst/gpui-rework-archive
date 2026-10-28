//! Public-interface adversary: the literal proof-disabled path is the scalar oracle.
use super::*;

#[test]
fn public_sample_partitions_preserve_overlap_refinement_and_fallbacks() {
    pollster::block_on(async {
        let mut frames = 0;
        for format in [
            wgpu::TextureFormat::Rgba8UnormSrgb,
            wgpu::TextureFormat::Bgra8UnormSrgb,
            wgpu::TextureFormat::Rgba16Float,
        ] {
            let hdr = format == wgpu::TextureFormat::Rgba16Float;
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.).unwrap()
            } else {
                ColorConfig::default()
            };
            let mut gpu = renderer(format).await;
            let mut fonts = TextSystem::bundled().unwrap();
            let run = fonts.shape("MWj", 18., None).unwrap();
            for phase in 0..4 {
                let mut reference = None;
                for banked in [false, true] {
                    let mut canvas = Canvas::recording(64, 40, config).unwrap();
                    canvas.clear(if hdr {
                        Color::linear_srgb(-0.0, -1e-40, 0.25, 0.5).unwrap()
                    } else {
                        Color::WHITE
                    });
                    let viewport = Rect::new(0., 0., 64., 40.);
                    canvas
                        .fill_rect(
                            viewport,
                            Affine::IDENTITY,
                            viewport,
                            Color::rgba(71, 131, 173, 79),
                        )
                        .unwrap();
                    let chain = (phase == 3).then(|| {
                        canvas
                            .create_clip(
                                None,
                                gpui_canvas::ClipShape::RoundedRect {
                                    rect: Rect::new(7.125, 3.375, 38.75, 27.25),
                                    radius: 3.125,
                                },
                                Affine::IDENTITY,
                            )
                            .unwrap()
                    });
                    for layer in 0..3 {
                        let color = if hdr {
                            Color::linear_srgb(
                                if layer == 0 { -0.0 } else { -1e-40 },
                                layer as f32 * 0.25,
                                1.5,
                                0.625,
                            )
                            .unwrap()
                        } else {
                            Color::rgba(23 + layer * 41, 191 - layer * 37, 59 + layer * 19, 159)
                        };
                        let slot = banked.then(|| {
                            canvas
                                .paint_slot(gpui_canvas::PaintColor::new(color))
                                .unwrap()
                        });
                        let origin = Point {
                            x: 3.125 + phase as f32 * 0.25 + layer as f32 * 0.25,
                            y: 4.125 + ((phase + layer) % 4) as f32 * 0.25,
                        };
                        let transform = if phase == 2 && layer == 1 {
                            Affine {
                                c: 0.125,
                                ..Affine::IDENTITY
                            }
                        } else {
                            Affine::IDENTITY
                        };
                        let clip: gpui_canvas::Clip = if layer == 2 {
                            chain.map_or_else(|| viewport.into(), Into::into)
                        } else {
                            viewport.into()
                        };
                        if let Some(slot) = slot {
                            canvas
                                .draw_text_scaled_slot(
                                    &mut fonts, &run, origin, transform, clip, slot, 1.,
                                )
                                .unwrap();
                        } else {
                            canvas
                                .draw_text_scaled(
                                    &mut fonts, &run, origin, transform, clip, color, 1.,
                                )
                                .unwrap();
                        }
                        canvas
                            .fill_rect(
                                Rect::new(12.125 + layer as f32 * 0.25, 1.375, 0.25, 35.25),
                                Affine::IDENTITY,
                                viewport,
                                Color::rgba(239, 31, 107, 113),
                            )
                            .unwrap();
                    }
                    for grouped in [false, true] {
                        gpu.set_grouped_records(grouped);
                        for proofs in [false, true] {
                            gpu.set_tile_proofs(proofs);
                            let actual = readback(&mut gpu, &canvas);
                            if let Some(expected) = &reference {
                                assert_eq!(
                                    &actual, expected,
                                    "phase={phase} banked={banked} grouped={grouped} proofs={proofs} format={format:?}"
                                );
                            } else {
                                assert!(!banked && !grouped && !proofs);
                                reference = Some(actual.clone());
                            }
                            let before = gpu.stats();
                            let target = output_texture(&gpu, &canvas);
                            gpu.redraw(&target.create_view(&Default::default()))
                                .unwrap()
                                .unwrap();
                            assert_eq!(read_texture(&gpu, &target), actual);
                            assert_packet_replay(before, gpu.stats());
                            frames += 1;
                        }
                    }
                }
            }
        }
        assert_eq!(frames, 96);
        println!(
            "SAMPLE_PARTITIONS_PUBLIC frames={frames} scalar_literal_oracle=true replay_exact=true"
        );
    });
}
