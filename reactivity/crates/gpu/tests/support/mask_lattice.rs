//! Public-interface fixture, byte-identical in the independent pre-change core.
use super::*;

#[test]
fn public_mask_lattice_readbacks_replay_clips_and_density_fallbacks() {
    pollster::block_on(async {
        let capture = std::env::var_os("GPUI_MASK_LATTICE_CAPTURE").map(std::path::PathBuf::from);
        if let Some(path) = &capture {
            std::fs::create_dir(path).unwrap();
        }
        let mut count = 0;
        for (format_index, format) in [
            wgpu::TextureFormat::Rgba8UnormSrgb,
            wgpu::TextureFormat::Bgra8UnormSrgb,
            wgpu::TextureFormat::Rgba16Float,
        ]
        .into_iter()
        .enumerate()
        {
            let mut gpu = renderer(format).await;
            let config = if format_index == 2 {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.).unwrap()
            } else {
                ColorConfig::default()
            };
            let mut fonts = TextSystem::bundled().unwrap();
            let run = fonts.shape("Agj office Wé", 17., None).unwrap();
            for banked in [false, true] {
                for case in 0..14 {
                    for step in 0..2 {
                        let mut canvas = Canvas::recording(112, 80, config).unwrap();
                        canvas.clear(Color::linear_srgb(0.0625, 0.125, 0.25, 1.).unwrap());
                        let mut clip = Rect::new(1.125, 0.375, 107.125, 76.625);
                        if case == 7 {
                            clip.width = 107.125_f32.next_up();
                        }
                        if case == 8 {
                            clip.width = 107.125_f32.next_down();
                        }
                        let origin_x = match case {
                            0 => 2.,
                            1 => 2.125,
                            2 => 2.125_f32.next_up(),
                            3 => 2.125_f32.next_down(),
                            4 => 2.37631,
                            5 => -3.125,
                            _ => 2.375,
                        };
                        let transform = match case {
                            9 => Affine {
                                a: 1.25,
                                d: 0.875,
                                ..Affine::IDENTITY
                            },
                            10 => Affine {
                                c: 0.125,
                                ..Affine::IDENTITY
                            },
                            11 => Affine {
                                a: -1.,
                                tx: 110.,
                                ..Affine::IDENTITY
                            },
                            _ => Affine::translation(0.125 * step as f32, 0.375),
                        };
                        let density = if case == 12 {
                            2.
                        } else if case == 13 {
                            1.25
                        } else {
                            1.
                        };
                        canvas
                            .fill_rect(
                                Rect::new(0.25, 0.75, 108.5, 68.25),
                                Affine::IDENTITY,
                                clip,
                                Color::rgba(193, 47, 91, 77),
                            )
                            .unwrap();
                        let color = if format_index == 2 {
                            Color::linear_srgb(-0.0, -1e-40, 1.5, 0.625).unwrap()
                        } else {
                            Color::rgba(23, 113, 231, 159)
                        };
                        let slot = banked.then(|| {
                            canvas
                                .paint_slot(gpui_canvas::PaintColor::new(color))
                                .unwrap()
                        });
                        let chain = if case == 6 {
                            Some(
                                canvas
                                    .create_clip(
                                        None,
                                        gpui_canvas::ClipShape::RoundedRect {
                                            rect: Rect::new(3.125, 1.375, 102.75, 72.25),
                                            radius: 5.125,
                                        },
                                        Affine::IDENTITY,
                                    )
                                    .unwrap(),
                            )
                        } else {
                            None
                        };
                        for row in 0..2 {
                            let origin = Point {
                                x: origin_x + row as f32 * 0.25,
                                y: 2.125 + row as f32 * 22.25,
                            };
                            let selected: gpui_canvas::Clip =
                                chain.map_or_else(|| clip.into(), Into::into);
                            if let Some(slot) = slot {
                                canvas
                                    .draw_text_scaled_slot(
                                        &mut fonts, &run, origin, transform, selected, slot,
                                        density,
                                    )
                                    .unwrap();
                            } else {
                                canvas
                                    .draw_text_scaled(
                                        &mut fonts, &run, origin, transform, selected, color,
                                        density,
                                    )
                                    .unwrap();
                            }
                        }
                        canvas
                            .fill_rect(
                                Rect::new(18.375, 8.125, 14.25, 37.5),
                                Affine::IDENTITY,
                                clip,
                                Color::rgba(255, 137, 17, 63),
                            )
                            .unwrap();
                        let mut expanded = None;
                        for grouped in [false, true] {
                            gpu.set_grouped_records(grouped);
                            gpu.set_tile_proofs(false);
                            let pixels = readback(&mut gpu, &canvas);
                            if let Some(before) = &expanded {
                                assert_eq!(
                                    &pixels, before,
                                    "inline/compact {format_index}/{banked}/{case}/{step}"
                                );
                            } else {
                                expanded = Some(pixels.clone());
                            }
                            let target = output_texture(&gpu, &canvas);
                            gpu.redraw(&target.create_view(&Default::default()))
                                .unwrap();
                            assert_eq!(read_texture(&gpu, &target), pixels);
                            gpu.set_tile_proofs(true);
                            assert_eq!(readback(&mut gpu, &canvas), pixels);
                            if let Some(path) = &capture {
                                std::fs::write(
                                    path.join(format!(
                                        "{format_index}-{banked}-{case}-{step}-{grouped}.rgba"
                                    )),
                                    &pixels,
                                )
                                .unwrap();
                            }
                            count += 1;
                        }
                    }
                }
            }
        }
        assert_eq!(count, 336);
        println!(
            "MASK_LATTICE_PUBLIC frames={count} replay_exact=true compact_exact=true proofs_exact=true"
        );
    });
}
