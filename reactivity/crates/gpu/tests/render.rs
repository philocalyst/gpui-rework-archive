use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use gpui_gpu::{Renderer, Stats, wgpu};

async fn renderer(format: wgpu::TextureFormat) -> Renderer {
    let mut descriptor = wgpu::InstanceDescriptor::new_without_display_handle();
    descriptor.backends = wgpu::Backends::VULKAN;
    let instance = wgpu::Instance::new(descriptor);
    let adapter = instance
        .request_adapter(&wgpu::RequestAdapterOptions {
            force_fallback_adapter: true,
            ..Default::default()
        })
        .await
        .expect("Vulkan test adapter is required");
    eprintln!("adapter: {:?}", adapter.get_info());
    Renderer::request(&adapter, format).await.unwrap()
}
fn readback(renderer: &mut Renderer, canvas: &Canvas) -> Vec<u8> {
    let texture = output_texture(renderer, canvas);
    renderer
        .render(
            canvas.prepared_scene(),
            &texture.create_view(&Default::default()),
        )
        .unwrap();
    read_texture(renderer, &texture)
}

fn output_texture(renderer: &Renderer, canvas: &Canvas) -> wgpu::Texture {
    let (width, height) = (canvas.width(), canvas.height());
    let device = renderer.device();
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("test output"),
        size: wgpu::Extent3d {
            width,
            height,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: renderer.format(),
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    })
}

fn read_texture(renderer: &Renderer, texture: &wgpu::Texture) -> Vec<u8> {
    let (width, height) = (texture.width(), texture.height());
    let bytes = renderer.format().block_copy_size(None).unwrap();
    let stride = (width * bytes).next_multiple_of(256);
    let device = renderer.device();
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("readback"),
        size: u64::from(stride) * u64::from(height),
        usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    });
    let mut encoder = renderer
        .device()
        .create_command_encoder(&Default::default());
    encoder.copy_texture_to_buffer(
        wgpu::TexelCopyTextureInfo {
            texture,
            mip_level: 0,
            origin: wgpu::Origin3d::ZERO,
            aspect: wgpu::TextureAspect::All,
        },
        wgpu::TexelCopyBufferInfo {
            buffer: &buffer,
            layout: wgpu::TexelCopyBufferLayout {
                offset: 0,
                bytes_per_row: Some(stride),
                rows_per_image: Some(height),
            },
        },
        wgpu::Extent3d {
            width,
            height,
            depth_or_array_layers: 1,
        },
    );
    renderer.queue().submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |result| {
        send.send(result).unwrap()
    });
    renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    receive.recv().unwrap().unwrap();
    let mapped = buffer.get_mapped_range(..);
    let mut output = Vec::with_capacity((width * height * bytes) as usize);
    for row in mapped.chunks_exact(stride as usize) {
        output.extend_from_slice(&row[..(width * bytes) as usize]);
    }
    drop(mapped);
    buffer.unmap();
    output
}

fn compare_tile_modes(renderer: &mut Renderer, canvas: &mut Canvas) -> Stats {
    renderer.set_tile_proofs(false);
    let reference = readback(renderer, canvas);
    let reference_stats = renderer.stats();
    renderer.set_tile_proofs(true);
    let optimized = readback(renderer, canvas);
    assert_eq!(optimized, reference, "tile proof changed GPU output");
    let stats = renderer.stats();
    assert_eq!(
        stats.original_tile_references,
        reference_stats.tile_references
    );
    assert_eq!(
        stats.skipped_tile_references,
        reference_stats.tile_references - stats.tile_references
    );
    assert!(stats.sample_draw_evaluations <= reference_stats.sample_draw_evaluations);
    canvas.set_tile_proofs(false);
    for (index, (&a, &b)) in optimized.iter().zip(canvas.pixels()).enumerate() {
        assert!(
            (i16::from(a) - i16::from(b)).abs() <= 1,
            "byte{index}: GPU{a} CPU{b}"
        );
    }
    stats
}

#[test]
fn opaque_tile_proofs_skip_overlap_and_preserve_later_edges() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let clip = Rect::new(0.0, 0.0, 35.0, 19.0);
        let mut canvas = Canvas::recording(35, 19, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        for n in 0..32 {
            canvas
                .fill_rect(
                    clip,
                    Affine::IDENTITY,
                    clip,
                    Color::rgb(n * 7, n * 5, n * 3),
                )
                .unwrap();
        }
        let stats = compare_tile_modes(&mut renderer, &mut canvas);
        assert_eq!(stats.draws, 32, "canonical records remain retained");
        assert_eq!(stats.uniform_tiles, 6, "includes partial edge tiles");
        assert_eq!(stats.original_tile_references, 192);
        assert_eq!(stats.tile_references, 0);
        assert_eq!(stats.sample_evaluations, 0);
        assert_eq!(stats.sample_draw_evaluations, 0);
        canvas
            .fill_rect(
                Rect::new(18.5, 0.0, 16.5, 19.0),
                Affine::IDENTITY,
                clip,
                Color::rgba(255, 10, 5, 120),
            )
            .unwrap();
        let stats = compare_tile_modes(&mut renderer, &mut canvas);
        assert!(stats.uniform_tiles > 0 && stats.uniform_tiles < 6);
        assert!(stats.sample_evaluations > 0);
        assert!(stats.skipped_tile_references > 180);
        assert_eq!(stats.draws, 33);
    });
}

#[test]
fn tile_certificates_fall_back_for_clip_alpha_shear_and_ambiguous_edges() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let viewport = Rect::new(0.0, 0.0, 48.0, 32.0);
        for (transform, clip, alpha) in [
            (Affine::IDENTITY, viewport, 255),
            (Affine::IDENTITY, viewport, 254),
            (Affine::IDENTITY, Rect::new(0.1, 0.0, 16.025, 32.0), 255),
            (
                Affine {
                    c: 0.3,
                    ..Affine::IDENTITY
                },
                viewport,
                255,
            ),
        ] {
            let mut canvas = Canvas::recording(48, 32, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            for n in 0..5 {
                canvas
                    .fill_rect(
                        viewport,
                        Affine::IDENTITY,
                        viewport,
                        Color::rgb(20 * n, 100, 140),
                    )
                    .unwrap();
            }
            canvas
                .fill_rect(viewport, transform, clip, Color::rgba(210, 10, 50, alpha))
                .unwrap();
            // Later translucent geometry must survive an earlier occluder.
            canvas
                .fill_rect(
                    Rect::new(2.1, 3.2, 39.5, 21.0),
                    Affine::rotation(0.03),
                    viewport,
                    Color::rgba(5, 230, 60, 80),
                )
                .unwrap();
            compare_tile_modes(&mut renderer, &mut canvas);
        }
        for width in [
            f32::from_bits((1.0_f32 / 24.0).to_bits() - 1),
            1.0_f32 / 24.0,
        ] {
            let mut canvas = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            canvas
                .fill_rect(
                    Rect::new(0.0, 0.0, width, 1.0),
                    Affine::scale(3.0, 1.0),
                    viewport,
                    Color::rgb(255, 0, 0),
                )
                .unwrap();
            assert_eq!(
                compare_tile_modes(&mut renderer, &mut canvas).uniform_tiles,
                0
            );
        }
    });
}

#[test]
fn opaque_proof_changes_do_not_discard_background_records() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let viewport = Rect::new(0.0, 0.0, 32.0, 16.0);
        for (alpha, clip) in [
            (255, viewport),
            (100, viewport),
            (255, Rect::new(1.0, 0.0, 15.0, 16.0)),
            (255, viewport),
        ] {
            let mut canvas = Canvas::recording(32, 16, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            canvas
                .fill_rect(viewport, Affine::IDENTITY, viewport, Color::rgb(255, 0, 0))
                .unwrap();
            canvas
                .fill_rect(
                    viewport,
                    Affine::IDENTITY,
                    clip,
                    Color::rgba(0, 0, 255, alpha),
                )
                .unwrap();
            let stats = compare_tile_modes(&mut renderer, &mut canvas);
            assert_eq!(stats.draws, 2);
        }
    });
}

#[test]
fn uniform_float_tiles_preserve_reference_output_bits() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
        let viewport = Rect::new(0.0, 0.0, 32.0, 16.0);
        for (color, uniform_tiles) in [
            (Color::linear_srgb(-0.0, 0.0, -2.0, 1.0).unwrap(), 0),
            (Color::linear_srgb(-1e-40, 0.0, -2.0, 1.0).unwrap(), 0),
            (Color::linear_srgb(1e-40, 0.0, -2.0, 1.0).unwrap(), 2),
            (Color::linear_srgb(1e19, -1e19, 0.00001, 1.0).unwrap(), 2),
        ] {
            let mut canvas = Canvas::recording(32, 16, config).unwrap();
            canvas.clear(Color::linear_srgb(-1.0, 1.0, -1.0, 0.25).unwrap());
            canvas
                .fill_rect(viewport, Affine::IDENTITY, viewport, color)
                .unwrap();
            renderer.set_tile_proofs(false);
            let reference = readback(&mut renderer, &canvas);
            renderer.set_tile_proofs(true);
            let optimized = readback(&mut renderer, &canvas);
            assert_eq!(&optimized[..8], &reference[..8]);
            assert_eq!(optimized, reference);
            assert_eq!(renderer.stats().uniform_tiles, uniform_tiles);
        }
    });
}

#[test]
fn real_vulkan_pixels_match_cpu_sampling_and_preserve_correlated_edges() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut canvas = Canvas::recording(80, 64, ColorConfig::default()).unwrap();
        let clip = Rect::new(0.0, 0.0, 80.0, 64.0);
        canvas.clear(Color::WHITE);
        for (r, t, c) in [
            (
                Rect::new(1.0, 2.0, 40.0, 30.0),
                Affine::IDENTITY,
                Color::rgb(30, 60, 150),
            ),
            (
                Rect::new(10.0, 4.0, 34.5, 25.0),
                Affine::IDENTITY,
                Color::rgba(200, 30, 20, 120),
            ),
            (
                Rect::new(0.0, 0.0, 25.0, 20.0),
                Affine::translation(41.0, 24.0).compose(Affine::rotation(0.17)),
                Color::rgba(5, 210, 50, 180),
            ),
        ] {
            canvas.fill_rect(r, t, clip, c).unwrap();
        }
        let actual = readback(&mut renderer, &canvas);
        assert_eq!(
            canvas.output_bytes(),
            0,
            "GPU submission must not request a CPU image"
        );
        let expected = canvas.pixels();
        for (index, (&a, &b)) in actual.iter().zip(expected).enumerate() {
            assert!(
                (i16::from(a) - i16::from(b)).abs() <= 1,
                "byte{index}:GPU{a} CPU{b}"
            );
        }
        let mut edge = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
        edge.clear(Color::WHITE);
        let half = Rect::new(0.0, 0.0, 0.5, 1.0);
        edge.fill_rect(half, Affine::IDENTITY, clip, Color::rgb(255, 0, 0))
            .unwrap();
        edge.fill_rect(half, Affine::IDENTITY, clip, Color::rgb(0, 0, 255))
            .unwrap();
        let actual = readback(&mut renderer, &edge);
        for (&a, &b) in actual.iter().zip(edge.pixels()) {
            assert!((i16::from(a) - i16::from(b)).abs() <= 1);
        }
    });
}

#[test]
fn real_text_uses_shared_glyph_keys_and_uploads_only_missing_masks() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut fonts = TextSystem::bundled().unwrap();
        let run = fonts.shape("office café", 18.0, None).unwrap();
        let mut canvas = Canvas::recording(160, 42, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        canvas
            .draw_text(
                &mut fonts,
                &run,
                Point { x: 8.0, y: 4.0 },
                Affine::IDENTITY,
                Rect::new(0.0, 0.0, 160.0, 42.0),
                Color::BLACK,
            )
            .unwrap();
        let actual = readback(&mut renderer, &canvas);
        assert!(renderer.stats().mask_upload_bytes > 0);
        renderer.set_tile_proofs(false);
        assert_eq!(readback(&mut renderer, &canvas), actual);
        renderer.set_tile_proofs(true);
        let second = readback(&mut renderer, &canvas);
        assert_eq!(actual, second);
        assert_eq!(renderer.stats().mask_upload_bytes, 0);
        let expected = canvas.pixels();
        for (index, (&a, &b)) in actual.iter().zip(expected).enumerate() {
            assert!(
                (i16::from(a) - i16::from(b)).abs() <= 1,
                "byte{index}:GPU{a} CPU{b}"
            );
        }
        assert!(actual.chunks_exact(4).any(|pixel| pixel[0] < 50));
    });
}

#[test]
fn text_free_reset_releases_keys_without_invalidating_in_flight_text() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut fonts = TextSystem::bundled().unwrap();
        let run = fonts.shape("office café", 18.0, None).unwrap();
        let clip = Rect::new(0.0, 0.0, 160.0, 42.0);
        let mut text = Canvas::recording(160, 42, ColorConfig::default()).unwrap();
        text.clear(Color::WHITE);
        text.draw_text(
            &mut fonts,
            &run,
            Point { x: 4.0, y: 2.0 },
            Affine::IDENTITY,
            clip,
            Color::BLACK,
        )
        .unwrap();
        let target = output_texture(&renderer, &text);
        renderer
            .render(
                text.prepared_scene(),
                &target.create_view(&Default::default()),
            )
            .unwrap();
        let populated = renderer.stats();
        assert!(populated.mask_upload_bytes > 0 && populated.atlas_bytes > 1);
        assert!(populated.atlas_keys > 0 && populated.atlas_key_capacity > 0);
        let mut empty = Canvas::recording(160, 42, ColorConfig::default()).unwrap();
        empty.clear(Color::rgb(20, 40, 80));
        let empty_target = output_texture(&renderer, &empty);
        let mut invalid = empty.prepared_scene();
        invalid.color_config.mapping = gpui_canvas::SdrMapping::ReinhardPerChannel {
            exposure: f32::INFINITY,
        };
        assert!(matches!(
            renderer.render(invalid, &empty_target.create_view(&Default::default())),
            Err(gpui_gpu::Error::InvalidScene)
        ));
        // Rejection did not discard the admitted cache.
        renderer
            .render(
                text.prepared_scene(),
                &target.create_view(&Default::default()),
            )
            .unwrap();
        assert_eq!(renderer.stats().mask_upload_bytes, 0);
        // No poll has occurred: both text submissions may still use the old atlas.
        renderer
            .render(
                empty.prepared_scene(),
                &empty_target.create_view(&Default::default()),
            )
            .unwrap();
        assert_eq!(renderer.stats().atlas_bytes, 1);
        assert_eq!(renderer.stats().atlas_keys, 0);
        assert_eq!(renderer.stats().atlas_key_capacity, 0);
        let previous = read_texture(&renderer, &target);
        for (&actual, &expected) in previous.iter().zip(text.pixels()) {
            assert!((i16::from(actual) - i16::from(expected)).abs() <= 1);
        }
        assert!(
            read_texture(&renderer, &empty_target)
                .chunks_exact(4)
                .all(|pixel| pixel == [20, 40, 80, 255])
        );
        assert_eq!(readback(&mut renderer, &text), previous);
        assert!(
            renderer.stats().mask_upload_bytes > 0,
            "returning text reuploads masks"
        );
        readback(&mut renderer, &empty);
        readback(&mut renderer, &empty);
        assert_eq!(renderer.stats().atlas_bytes, 1);
        assert_eq!(renderer.stats().atlas_key_capacity, 0);
    });
}

#[test]
fn linear_float_target_retains_hdr_and_premultiplied_alpha() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
        let mut canvas = Canvas::recording(2, 1, config).unwrap();
        canvas.clear(Color::linear_srgb(4.0, 0.5, -0.25, 0.5).unwrap());
        let bytes = readback(&mut renderer, &canvas);
        let pixel: Vec<_> = bytes[..8]
            .chunks_exact(2)
            .map(|b| u16::from_le_bytes([b[0], b[1]]))
            .collect();
        assert_eq!(pixel, [0x4000, 0x3400, 0xb000, 0x3800]);
        assert_eq!(canvas.output_bytes(), 0);
    });
}

#[test]
fn float_target_rejects_sdr_scene_metadata_before_submission() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let canvas = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
        let target = renderer.device().create_texture(&wgpu::TextureDescriptor {
            label: None,
            size: wgpu::Extent3d {
                width: 1,
                height: 1,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: renderer.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            view_formats: &[],
        });
        assert!(matches!(
            renderer.render(
                canvas.prepared_scene(),
                &target.create_view(&Default::default())
            ),
            Err(gpui_gpu::Error::InvalidScene)
        ));
        assert_eq!(renderer.stats().submissions, 0);
    });
}

#[test]
fn narrowed_inverse_preserves_the_adversarial_half_open_edge() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let clip = Rect::new(0.0, 0.0, 1.0, 1.0);
        // The first sample is x=.125. Canonical f64 division puts it inside
        // f32(1/24), but f32(1/3)*.125 rounds exactly onto the excluded edge.
        // Check both sides of that rounded boundary and reflected geometry.
        for bits in [
            (1.0_f32 / 24.0).to_bits() - 1,
            (1.0_f32 / 24.0).to_bits(),
            (1.0_f32 / 24.0).to_bits() + 1,
        ] {
            for transform in [
                Affine::scale(3.0, 1.0),
                Affine::translation(1.0, 0.0).compose(Affine::scale(-3.0, 1.0)),
            ] {
                let mut canvas = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
                canvas.clear(Color::WHITE);
                canvas
                    .fill_rect(
                        Rect::new(0.0, 0.0, f32::from_bits(bits), 1.0),
                        transform,
                        clip,
                        Color::rgb(255, 0, 0),
                    )
                    .unwrap();
                assert_eq!(readback(&mut renderer, &canvas), canvas.pixels());
            }
        }
    });
}

#[test]
fn clip_extent_sum_preserves_half_open_sample_membership() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        for bits in [
            0.025_f32.to_bits() - 2,
            0.025_f32.to_bits() - 1,
            0.025_f32.to_bits(),
            0.025_f32.to_bits() + 1,
        ] {
            let extent = f32::from_bits(bits);
            for clip in [
                Rect::new(0.1, 0.0, extent, 1.0),
                Rect::new(0.0, 0.1, 1.0, extent),
            ] {
                for transform in [
                    Affine::IDENTITY,
                    Affine::translation(1.0, 1.0).compose(Affine::scale(-1.0, -1.0)),
                ] {
                    let mut canvas = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
                    canvas.clear(Color::WHITE);
                    canvas
                        .fill_rect(
                            Rect::new(0.0, 0.0, 1.0, 1.0),
                            transform,
                            clip,
                            Color::rgb(255, 0, 0),
                        )
                        .unwrap();
                    assert_eq!(
                        readback(&mut renderer, &canvas),
                        canvas.pixels(),
                        "clip={clip:?} transform={transform:?}"
                    );
                }
            }
        }
    });
}

#[test]
fn zero_coverage_draw_preserves_threshold_clear_and_hdr_bits() {
    pollster::block_on(async {
        for format in [
            wgpu::TextureFormat::Rgba8UnormSrgb,
            wgpu::TextureFormat::Rgba16Float,
        ] {
            let mut renderer = renderer(format).await;
            for clear in [
                Color::linear_srgb(f32::from_bits(0x391f22b4), 0.01, 0.5, 1.0).unwrap(),
                Color::linear_srgb(0.74975586, 0.00390625, 12.5, 0.3).unwrap(),
            ] {
                if format != wgpu::TextureFormat::Rgba16Float && clear.alpha() != 1.0 {
                    continue;
                }
                let config = if format == wgpu::TextureFormat::Rgba16Float {
                    ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
                } else {
                    ColorConfig::default()
                };
                let mut canvas = Canvas::recording(1, 1, config).unwrap();
                canvas.clear(clear);
                let before = readback(&mut renderer, &canvas);
                canvas
                    .fill_rect(
                        Rect::new(0.0, 0.0, 0.01, 0.01),
                        Affine::IDENTITY,
                        Rect::new(0.0, 0.0, 1.0, 1.0),
                        Color::WHITE,
                    )
                    .unwrap();
                assert_eq!(readback(&mut renderer, &canvas), before);
            }
        }
    });
}

#[test]
fn maximum_admitted_tone_mapping_is_finite_and_bright() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let config = ColorConfig {
            mapping: gpui_canvas::SdrMapping::ReinhardPerChannel { exposure: 1e10 },
            ..ColorConfig::default()
        };
        let mut canvas = Canvas::recording(1, 1, config).unwrap();
        canvas.clear(Color::linear_srgb(1e19, -1e19, 1.0, 1.0).unwrap());
        assert_eq!(readback(&mut renderer, &canvas), [255, 0, 255, 255]);
    });
}

#[test]
fn physical_glyph_masks_map_back_to_logical_rectangles() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut fonts = TextSystem::bundled().unwrap();
        let run = fonts.shape("office café", 16.0, None).unwrap();
        for scale in [1.0, 1.25, 1.5, 2.0] {
            let mut canvas = Canvas::recording(240, 80, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            canvas
                .draw_text_scaled(
                    &mut fonts,
                    &run,
                    Point { x: 2.125, y: 1.375 },
                    Affine::scale(scale, scale),
                    Rect::new(0.0, 0.0, 240.0, 80.0),
                    Color::BLACK,
                    scale,
                )
                .unwrap();
            let actual = readback(&mut renderer, &canvas);
            for (index, (&a, &b)) in actual.iter().zip(canvas.pixels()).enumerate() {
                assert!(
                    (i16::from(a) - i16::from(b)).abs() <= 1,
                    "scale{scale} byte{index}: GPU{a} CPU{b}"
                );
            }
        }
    });
}
