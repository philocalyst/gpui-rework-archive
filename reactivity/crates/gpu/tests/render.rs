use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use gpui_gpu::{Renderer, Stats, wgpu};

#[test]
fn packed_images_profiles_alpha_filters_and_cache_match_cpu() {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling};
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let clip = Rect::new(1.125, 0.375, 29.5, 22.25);
        for profile in [ImageProfile::Srgb, ImageProfile::DisplayP3] {
            for alpha in [AlphaMode::Straight, AlphaMode::Premultiplied] {
                let bytes = (0..35)
                    .flat_map(|i| {
                        let a = [0, 63, 127, 255][i % 4];
                        let rgb = [(i * 31) as u8, (i * 57) as u8, (i * 13) as u8];
                        let rgb = rgb.map(|v| {
                            if alpha == AlphaMode::Premultiplied {
                                (u16::from(v) * u16::from(a) / 255) as u8
                            } else {
                                v
                            }
                        });
                        [rgb[0], rgb[1], rgb[2], a]
                    })
                    .collect::<Vec<_>>();
                let image = Image::rgba8(7, 5, profile, alpha, bytes.into_boxed_slice()).unwrap();
                for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
                    for map in [
                        Affine::IDENTITY,
                        Affine {
                            a: -0.9,
                            b: 0.,
                            c: 0.,
                            d: 1.25,
                            tx: 29.125,
                            ty: 0.375,
                        },
                        Affine {
                            a: 0.9,
                            b: 0.13,
                            c: -0.17,
                            d: 0.75,
                            tx: 5.125,
                            ty: 0.125,
                        },
                    ] {
                        let mut canvas = Canvas::recording(32, 24, ColorConfig::default()).unwrap();
                        canvas.clear(Color::WHITE);
                        canvas
                            .draw_image(
                                &image,
                                Rect::new(0.125, 0.375, 25.5, 19.25),
                                map,
                                clip,
                                sampling,
                            )
                            .unwrap();
                        let first = readback(&mut renderer, &canvas);
                        let stats = renderer.image_stats().unwrap();
                        assert_eq!(stats.packed_bytes, 7 * 5 * 4);
                        let second = readback(&mut renderer, &canvas);
                        assert_eq!(first, second);
                        assert_eq!(renderer.image_stats().unwrap().uploaded_bytes, 0);
                        let cpu = canvas.pixels();
                        for (index, (&gpu, &cpu)) in first.iter().zip(cpu).enumerate() {
                            assert!(
                                (i16::from(gpu) - i16::from(cpu)).abs() <= 1,
                                "{profile:?} {alpha:?} {sampling:?} {map:?} byte{index}: GPU{gpu} CPU{cpu}"
                            );
                        }
                    }
                }
            }
        }
        // Prefix growth must relocate/reupload image words. Removing the final
        // image drops its key map and restores ordinary draw-buffer residency.
        let image = Image::rgba8(
            1,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![255, 17, 29, 255].into_boxed_slice(),
        )
        .unwrap();
        let mut canvas = Canvas::recording(32, 24, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        canvas
            .draw_image(
                &image,
                Rect::new(0., 0., 32., 24.),
                Affine::IDENTITY,
                Rect::new(0., 0., 32., 24.),
                ImageSampling::Linear,
            )
            .unwrap();
        let before = readback(&mut renderer, &canvas);
        for _ in 0..100 {
            canvas
                .fill_rect(
                    Rect::new(0., 0., 0.01, 0.01),
                    Affine::IDENTITY,
                    Rect::new(0., 0., 32., 24.),
                    Color::BLACK,
                )
                .unwrap();
        }
        assert_eq!(canvas.prepared_scene().draws().len(), 101);
        assert_eq!(readback(&mut renderer, &canvas), before);
        assert_eq!(renderer.image_stats().unwrap().uploaded_bytes, 4);
        canvas.clear(Color::WHITE);
        assert!(
            readback(&mut renderer, &canvas)
                .iter()
                .all(|&byte| byte == 255)
        );
        assert!(renderer.image_stats().is_none());
    });
}

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
    let mapped = buffer.get_mapped_range(..).unwrap();
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
fn zero_coverage_hdr_preserves_numeric_zero_across_cpu_and_gpu() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        for proofs in [false, true] {
            renderer.set_tile_proofs(proofs);
            let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
            let mut canvas = Canvas::recording(1, 1, config).unwrap();
            canvas.set_tile_proofs(proofs);
            canvas.clear(Color::linear_srgb(-0.0, -0.0, -0.0, 1.0).unwrap());
            let cpu_before = canvas.pixels().to_vec();
            let gpu_before = readback(&mut renderer, &canvas);
            canvas
                .fill_rect(
                    Rect::new(0.0, 0.0, 0.01, 0.01),
                    Affine::IDENTITY,
                    Rect::new(0.0, 0.0, 1.0, 1.0),
                    Color::WHITE,
                )
                .unwrap();
            let cpu_after = canvas.pixels().to_vec();
            let gpu_after = readback(&mut renderer, &canvas);
            assert_eq!(cpu_before, cpu_after, "CPU keeps the exact clear bits");
            for pixels in [cpu_before, gpu_before, cpu_after, gpu_after] {
                // Shader reductions may erase the sign of a zero. Require the
                // same numeric color without promising cross-device zero signs.
                let words: Vec<_> = pixels
                    .chunks_exact(2)
                    .map(|pair| u16::from_le_bytes([pair[0], pair[1]]))
                    .collect();
                assert!(words[..3].iter().all(|value| value & 0x7fff == 0));
                assert_eq!(words[3], 0x3c00);
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

#[test]
fn grouped_and_inline_packets_match_every_pixel_in_mixed_scenes() {
    pollster::block_on(async {
        for format in [
            wgpu::TextureFormat::Rgba8UnormSrgb,
            wgpu::TextureFormat::Rgba16Float,
        ] {
            let mut renderer = renderer(format).await;
            let config = if format == wgpu::TextureFormat::Rgba16Float {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::DisplayP3, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            let mut fonts = TextSystem::bundled().unwrap();
            let layout = fonts.shape("office café jé", 18.0, None).unwrap();
            let single = fonts.shape("H", 18.0, None).unwrap();
            let mut canvas = Canvas::recording(160, 88, config).unwrap();
            let clip = Rect::new(1.125, 0.125, 157.5, 86.75);
            canvas.clear(Color::linear_srgb(0.2, 0.3, 0.4, 1.0).unwrap());
            canvas
                .fill_rect(
                    Rect::new(4.0, 2.0, 90.0, 50.0),
                    Affine::IDENTITY,
                    clip,
                    Color::rgba(20, 80, 130, 120),
                )
                .unwrap();
            for (row, density) in [1.0, 1.25, 1.5, 2.0].into_iter().enumerate() {
                canvas
                    .draw_text_scaled(
                        &mut fonts,
                        &layout,
                        Point {
                            x: 5.0,
                            y: row as f32 * 17.0,
                        },
                        Affine {
                            a: 0.95,
                            b: 0.07,
                            c: 0.15,
                            d: 1.0,
                            tx: 0.025,
                            ty: 0.1,
                        },
                        clip,
                        Color::linear_srgb(-0.2, 1.5, 0.3, 0.7).unwrap(),
                        density,
                    )
                    .unwrap();
            }
            canvas
                .draw_text(
                    &mut fonts,
                    &single,
                    Point { x: 140.0, y: 10.0 },
                    Affine::IDENTITY,
                    clip,
                    Color::linear_srgb(-1e-40, -0.0, 1.0, 1.0).unwrap(),
                )
                .unwrap();
            for proofs in [false, true] {
                renderer.set_tile_proofs(proofs);
                renderer.set_grouped_records(false);
                let expanded = readback(&mut renderer, &canvas);
                let old = renderer.stats();
                assert_eq!(old.shared_groups, 0);
                assert_eq!(old.draw_record_bytes, old.draws * 96);
                renderer.set_grouped_records(true);
                let compact = readback(&mut renderer, &canvas);
                let new = renderer.stats();
                assert_eq!(compact, expanded, "{format:?},proofs={proofs}");
                assert_eq!(new.shared_groups, 4);
                assert_eq!(new.inline_draws, 2);
                assert_eq!(new.compact_draws + new.inline_draws, new.draws);
                assert_eq!(
                    new.draw_record_bytes,
                    new.shared_groups * 80 + new.compact_draws * 32 + new.inline_draws * 96
                );
                assert!(new.draw_record_bytes < old.draw_record_bytes);
            }
            // A final certificate points to a tagged inline word address AFTER
            // several compact runs. Canonical earlier groups remain retained.
            canvas
                .fill_rect(
                    Rect::new(-2.0, -2.0, 164.0, 92.0),
                    Affine::IDENTITY,
                    Rect::new(0.0, 0.0, 160.0, 88.0),
                    Color::rgb(25, 60, 130),
                )
                .unwrap();
            renderer.set_grouped_records(false);
            let expanded = readback(&mut renderer, &canvas);
            renderer.set_grouped_records(true);
            assert_eq!(readback(&mut renderer, &canvas), expanded);
            assert_eq!(renderer.stats().uniform_tiles, 60);
            assert_eq!(renderer.stats().sample_draw_evaluations, 0);
            assert_eq!(renderer.stats().shared_groups, 4);
        }
    });
}

#[test]
fn grouped_error_envelopes_match_inline_across_fractional_glyph_samples() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let mut fonts = TextSystem::bundled().unwrap();
        let clip = Rect::new(0.125, 0.375, 126.5, 62.25);
        for n in 0..48 {
            let size = 12.0 + (n % 7) as f32 * 1.125;
            let density = [1.0, 1.25, 1.3, 2.0][n % 4];
            let layout = fonts.shape("Héj office", size, None).unwrap();
            let mut canvas = Canvas::recording(
                128,
                64,
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap(),
            )
            .unwrap();
            canvas.clear(Color::linear_srgb(0.125, 0.3, 0.7, 1.0).unwrap());
            let reflected = n % 2 == 0;
            let transform = Affine {
                a: if reflected { -1.0 } else { 1.0 },
                b: (n % 5) as f32 * 0.03125,
                c: (n % 3) as f32 * 0.0625 - 0.0625,
                d: 1.0,
                tx: if reflected { 120.125 } else { 0.125 },
                ty: 0.375,
            };
            for row in 0..2 {
                let color = if n % 3 == 0 {
                    Color::linear_srgb(-1e-40, -0.0, 1.0, 0.7).unwrap()
                } else {
                    Color::linear_srgb(1.5, -0.1, 0.25, 0.7).unwrap()
                };
                canvas
                    .draw_text_scaled(
                        &mut fonts,
                        &layout,
                        Point {
                            x: 2.0 + n as f32 * 0.000_001,
                            y: row as f32 * 24.0,
                        },
                        transform,
                        clip,
                        color,
                        density,
                    )
                    .unwrap();
            }
            renderer.set_grouped_records(false);
            let old = readback(&mut renderer, &canvas);
            renderer.set_grouped_records(true);
            assert_eq!(
                readback(&mut renderer, &canvas),
                old,
                "fixture{n},density={density}"
            );
        }
    });
}

#[test]
fn inverse_lattice_clips_preserve_actual_vulkan_pixels() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let viewport = [33, 17];
        let window = Rect::new(0., 0., 33., 17.);
        let local = Rect::new(0., 0., 1.25, 3.75);
        for sx in [-2., -1.25, -0.1, 0.1, 1.25, 2.] {
            for sy in [-1.3, -0.1, 0.1, 1.3] {
                let transform = Affine {
                    a: sx,
                    d: sy,
                    tx: 0.125,
                    ty: 0.375,
                    ..Affine::IDENTITY
                };
                let clip =
                    gpui_canvas::sampled_rect_clip(transform, local, window, viewport).unwrap();
                let mut original = Canvas::new(viewport[0], viewport[1]).unwrap();
                original.clear(Color::WHITE);
                original
                    .fill_rect(local, transform, window, Color::BLACK)
                    .unwrap();
                let mut lowered = Canvas::new(viewport[0], viewport[1]).unwrap();
                lowered.clear(Color::WHITE);
                lowered
                    .fill_rect(window, Affine::IDENTITY, clip, Color::BLACK)
                    .unwrap();
                assert_eq!(lowered.pixels(), original.pixels(), "CPU {sx}/{sy}");
                let expected = readback(&mut renderer, &original);
                for proofs in [false, true] {
                    renderer.set_tile_proofs(proofs);
                    assert_eq!(
                        readback(&mut renderer, &lowered),
                        expected,
                        "GPU {sx}/{sy}, proofs={proofs}"
                    );
                }
            }
        }
    });
}

#[test]
fn all_authored_color_layouts_reach_real_sdr_and_hdr_targets() {
    pollster::block_on(async {
        let colors = [
            Color::srgb(-0.2, 1.3, 0.35, 0.7).unwrap(),
            Color::display_p3(1.2, -0.3, 0.4, 0.7).unwrap(),
            Color::linear_display_p3(4.0, -0.25, 0.5, 0.7).unwrap(),
            Color::linear_srgb(-0.25, 4.0, 0.5, 0.7).unwrap(),
            Color::oklch(0.7, 0.15, 120.0, 0.7).unwrap(),
        ];
        for format in [
            wgpu::TextureFormat::Rgba8UnormSrgb,
            wgpu::TextureFormat::Rgba16Float,
        ] {
            let mut renderer = renderer(format).await;
            let config = if format == wgpu::TextureFormat::Rgba16Float {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            for color in colors {
                let mut canvas = Canvas::recording(3, 2, config).unwrap();
                if format == wgpu::TextureFormat::Rgba16Float {
                    canvas.clear(color);
                } else {
                    // The SDR GPU surface contract requires an opaque clear.
                    canvas.clear(Color::WHITE);
                    let rect = Rect::new(0.0, 0.0, 3.0, 2.0);
                    canvas
                        .fill_rect(rect, Affine::IDENTITY, rect, color)
                        .unwrap();
                }
                let actual = readback(&mut renderer, &canvas);
                let expected = canvas.pixels();
                if format == wgpu::TextureFormat::Rgba16Float {
                    for (a, b) in actual.chunks_exact(2).zip(expected.chunks_exact(2)) {
                        assert!(
                            u16::from_le_bytes([a[0], a[1]])
                                .abs_diff(u16::from_le_bytes([b[0], b[1]]))
                                <= 1,
                            "{color:?}: {actual:?} != {expected:?}"
                        );
                    }
                } else {
                    for (&a, &b) in actual.iter().zip(expected) {
                        assert!(a.abs_diff(b) <= 1, "{color:?}: {actual:?} != {expected:?}");
                    }
                }
            }
        }
    });
}

#[test]
fn unicode_paragraphs_fallback_and_fractional_density_match_cpu() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut text = TextSystem::bundled().unwrap();
        let font = text.font_face().clone();
        let mut shaper = font.shaper();
        let layout = shaper
            .shape(
                "office Ελληνικά नमस्ते\r\nabc العربية אבג 123",
                16.,
                Some(215.),
            )
            .unwrap();
        assert!(
            layout
                .runs()
                .any(|run| run.direction() == gpui_canvas::TextDirection::RightToLeft)
        );
        for density in [1., 1.25, 2.] {
            for reflected in [false, true] {
                let mut canvas = Canvas::recording(320, 192, ColorConfig::default()).unwrap();
                canvas.clear(Color::WHITE);
                canvas
                    .draw_text_scaled(
                        &mut text,
                        &layout,
                        Point { x: 1.25, y: 2.5 },
                        Affine {
                            a: if reflected { -density } else { density },
                            d: density,
                            tx: if reflected { 319.5 } else { 0.25 },
                            ty: 0.125,
                            ..Affine::IDENTITY
                        },
                        Rect::new(0.1, 0.3, 319.2, 190.1),
                        Color::BLACK,
                        density,
                    )
                    .unwrap();
                compare_tile_modes(&mut renderer, &mut canvas);
            }
        }
    });
}

#[test]
fn images_reach_linear_hdr_and_display_p3_output_without_a_linear_gpu_mirror() {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling, OutputProfile};
    fn half(bytes: &[u8]) -> f32 {
        let bits = u16::from_le_bytes([bytes[0], bytes[1]]);
        let sign = if bits & 0x8000 == 0 { 1. } else { -1. };
        let exponent = ((bits >> 10) & 31) as i32;
        let mantissa = (bits & 1023) as f32;
        sign * if exponent == 0 {
            mantissa * 2f32.powi(-24)
        } else {
            (1. + mantissa / 1024.) * 2f32.powi(exponent - 15)
        }
    }
    pollster::block_on(async {
        let straight = [
            [4., -0.25, 0.5, 1.],
            [0.5, 2., -0.1, 0.5],
            [9., 1., 0., 0.],
            [0.1, 0.4, 3., 0.75],
        ];
        let premultiplied = straight.map(|mut p| {
            for c in 0..3 {
                p[c] *= p[3];
            }
            p
        });
        let images = [
            Image::linear_srgb(2, 2, AlphaMode::Straight, Box::new(straight)).unwrap(),
            Image::linear_srgb(2, 2, AlphaMode::Premultiplied, Box::new(premultiplied)).unwrap(),
            Image::rgba8(
                2,
                2,
                ImageProfile::DisplayP3,
                AlphaMode::Straight,
                vec![
                    255, 0, 0, 255, 0, 255, 0, 127, 0, 0, 255, 63, 255, 0, 255, 0,
                ]
                .into_boxed_slice(),
            )
            .unwrap(),
        ];
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let mut worst = 0f32;
        for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
            for image in &images {
                for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
                    let config = ColorConfig::linear_hdr(profile, 203.).unwrap();
                    let mut canvas = Canvas::recording(13, 9, config).unwrap();
                    canvas.clear(Color::linear_srgb(0.2, 0.3, 0.5, 0.7).unwrap());
                    canvas
                        .draw_image(
                            image,
                            Rect::new(0.125, 0.375, 9.25, 7.5),
                            Affine {
                                a: -0.9,
                                d: 0.9,
                                tx: 11.125,
                                ty: 0.125,
                                ..Affine::IDENTITY
                            },
                            Rect::new(1.125, 0.375, 10.1, 7.5),
                            sampling,
                        )
                        .unwrap();
                    let gpu = readback(&mut renderer, &canvas);
                    let cpu = canvas.pixels();
                    for (index, (a, b)) in gpu.chunks_exact(2).zip(cpu.chunks_exact(2)).enumerate()
                    {
                        let (a, b) = (half(a), half(b));
                        worst = worst.max((a - b).abs());
                        assert!(
                            (a - b).abs() <= 0.000002f32.max(b.abs() * 0.0015),
                            "{profile:?} {sampling:?} value{index}: GPU{a} CPU{b}"
                        );
                    }
                    let stats = renderer.image_stats().unwrap();
                    assert_eq!(stats.packed_bytes, image.pixel_bytes());
                }
            }
        }
        eprintln!("HDR image maximum observed absolute error: {worst}");
    });
}

#[test]
fn mixed_image_payload_offsets_and_reordered_exact_keys_remain_coherent() {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling};
    let images = [
        Image::rgba8(
            3,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![255, 0, 0, 255, 0, 255, 0, 127, 0, 0, 255, 0].into_boxed_slice(),
        )
        .unwrap(),
        Image::rgba8(
            2,
            2,
            ImageProfile::DisplayP3,
            AlphaMode::Premultiplied,
            vec![
                63, 0, 31, 63, 0, 127, 63, 127, 127, 31, 255, 255, 0, 0, 0, 0,
            ]
            .into_boxed_slice(),
        )
        .unwrap(),
        Image::linear_srgb(
            1,
            2,
            AlphaMode::Straight,
            Box::new([[4., -0.2, 0.5, 1.], [0.5, 0.75, 3., 0.5]]),
        )
        .unwrap(),
    ];
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let payload: usize = images.iter().map(Image::pixel_bytes).sum();
        for order in [[0, 1, 2], [2, 0, 1], [1, 2, 0]] {
            let mut canvas = Canvas::recording(33, 17, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            let clip = Rect::new(0., 0., 33., 17.);
            for (position, index) in order.into_iter().enumerate() {
                canvas
                    .draw_image(
                        &images[index],
                        Rect::new(position as f32 * 8., 0., 17., 17.),
                        Affine::IDENTITY,
                        clip,
                        ImageSampling::Linear,
                    )
                    .unwrap();
            }
            canvas
                .draw_image(
                    &images[order[0]],
                    Rect::new(0.125, 13.375, 9.25, 3.),
                    Affine::IDENTITY,
                    clip,
                    ImageSampling::Nearest,
                )
                .unwrap();
            let gpu = readback(&mut renderer, &canvas);
            assert_eq!(renderer.image_stats().unwrap().resources, 3);
            assert_eq!(renderer.image_stats().unwrap().packed_bytes, payload);
            assert_eq!(renderer.image_stats().unwrap().uploaded_bytes, payload);
            for (i, (&a, &b)) in gpu.iter().zip(canvas.pixels()).enumerate() {
                assert!(a.abs_diff(b) <= 1, "order{order:?} byte{i}: GPU{a} CPU{b}");
            }
            assert_eq!(readback(&mut renderer, &canvas), gpu);
            assert_eq!(renderer.image_stats().unwrap().uploaded_bytes, 0);
        }
    });
}

fn assert_packet_replay(before: Stats, after: Stats) {
    assert!(after.packet_reused);
    assert_eq!(after.submissions, before.submissions + 1);
    assert_eq!(
        (
            after.validated_draws,
            after.binning_tile_visits,
            after.bind_group_creations
        ),
        (0, 0, 0)
    );
    assert_eq!(
        (after.instance_upload_bytes, after.mask_upload_bytes),
        (0, 0)
    );
    assert_eq!(
        (
            after.draws,
            after.tile_references,
            after.sample_draw_evaluations
        ),
        (
            before.draws,
            before.tile_references,
            before.sample_draw_evaluations
        )
    );
    assert_eq!(
        (
            after.gpu_buffer_bytes,
            after.atlas_bytes,
            after.cpu_index_capacity_bytes
        ),
        (
            before.gpu_buffer_bytes,
            before.atlas_bytes,
            before.cpu_index_capacity_bytes
        )
    );
}

#[test]
fn explicit_packet_redraw_submits_complete_pixels_to_fresh_targets_after_scene_drop() {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling};
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut canvas = Canvas::recording(96, 64, ColorConfig::default()).unwrap();
        let clip = Rect::new(0., 0., 96., 64.);
        canvas.clear(Color::rgb(19, 29, 47));
        canvas
            .fill_rect(
                Rect::new(0.125, 1.375, 71., 38.),
                Affine::IDENTITY,
                clip,
                Color::rgba(200, 20, 90, 150),
            )
            .unwrap();
        let image = Image::rgba8(
            2,
            2,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![
                255, 0, 0, 255, 0, 255, 0, 127, 0, 0, 255, 63, 255, 255, 255, 255,
            ]
            .into_boxed_slice(),
        )
        .unwrap();
        canvas
            .draw_image(
                &image,
                Rect::new(40.125, 2.375, 35., 23.),
                Affine::IDENTITY,
                clip,
                ImageSampling::Linear,
            )
            .unwrap();
        let mut text = TextSystem::bundled().unwrap();
        let layout = text.shape("Reuse café", 16., None).unwrap();
        canvas
            .draw_text(
                &mut text,
                &layout,
                Point {
                    x: 2.125,
                    y: 36.375,
                },
                Affine::IDENTITY,
                clip,
                Color::WHITE,
            )
            .unwrap();
        let first = readback(&mut renderer, &canvas);
        let before = renderer.stats();
        assert_eq!(
            before.validated_draws,
            canvas.prepared_scene().draws().len()
        );
        assert_eq!(
            before.binning_tile_visits,
            2 * before.original_tile_references
        );
        assert_eq!(before.bind_group_creations, 1);
        assert!(!before.packet_reused);
        assert!(before.instance_upload_bytes > 0 && before.mask_upload_bytes > 0);
        assert!(renderer.image_stats().unwrap().uploaded_bytes > 0);
        // Prepared GPU resources outlive every borrowed CPU command/resource.
        let texture = output_texture(&renderer, &canvas);
        drop(canvas);
        drop(image);
        drop(layout);
        drop(text);
        for iteration in 0..3 {
            let before = renderer.stats();
            assert!(
                renderer
                    .redraw(&texture.create_view(&Default::default()))
                    .unwrap()
                    .is_some()
            );
            assert_packet_replay(before, renderer.stats());
            if iteration == 0 {
                eprintln!(
                    "packet_prepare={before:?}\npacket_redraw={:?}",
                    renderer.stats()
                );
            }
            assert_eq!(renderer.image_stats().unwrap().uploaded_bytes, 0);
            assert_eq!(read_texture(&renderer, &texture), first);
        }
    });
}

#[test]
fn queued_redraw_keeps_its_packet_before_later_uploads_and_buffer_replacement() {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling};
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let images = [(2, [231, 19, 43, 255]), (8, [29, 71, 211, 255])].map(|(side, rgba)| {
            Image::rgba8(
                side,
                side,
                ImageProfile::Srgb,
                AlphaMode::Straight,
                rgba.repeat(side as usize * side as usize)
                    .into_boxed_slice(),
            )
            .unwrap()
        });
        let mut scenes = images.each_ref().map(|image| {
            let mut canvas = Canvas::recording(32, 24, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            let rect = Rect::new(0., 0., 32., 24.);
            canvas
                .draw_image(image, rect, Affine::IDENTITY, rect, ImageSampling::Nearest)
                .unwrap();
            canvas
        });
        let targets = std::array::from_fn::<_, 3, _>(|_| output_texture(&renderer, &scenes[0]));
        renderer
            .render(
                scenes[0].prepared_scene(),
                &targets[0].create_view(&Default::default()),
            )
            .unwrap();
        let first = renderer.stats();
        renderer
            .redraw(&targets[1].create_view(&Default::default()))
            .unwrap()
            .unwrap();
        assert_packet_replay(first, renderer.stats());
        renderer
            .render(
                scenes[1].prepared_scene(),
                &targets[2].create_view(&Default::default()),
            )
            .unwrap();
        assert!(!renderer.stats().packet_reused);
        // No polling, readback, or CPU wait occurred between these submissions.
        // Replacement drops our old binding; the queued commands retain its leases.
        assert!(renderer.image_stats().unwrap().uploaded_bytes > 0);
        drop(images);
        let actual = targets
            .each_ref()
            .map(|target| read_texture(&renderer, target));
        assert_eq!(actual[0], actual[1]);
        assert_ne!(actual[0], actual[2]);
        for (index, scene) in scenes.iter_mut().enumerate() {
            for (&gpu, &cpu) in actual[index * 2].iter().zip(scene.pixels()) {
                assert!(gpu.abs_diff(cpu) <= 1);
            }
        }
    });
}

#[test]
fn unkeyed_calls_revalidate_mutable_headers_and_distinct_scenes_and_modes() {
    use gpui_canvas::OutputProfile;
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut a = Canvas::recording(32, 24, ColorConfig::default()).unwrap();
        a.clear(Color::WHITE);
        let mut b = Canvas::recording(32, 24, ColorConfig::default()).unwrap();
        b.clear(Color::rgb(70, 120, 190));
        let white = readback(&mut renderer, &a);
        let colored = readback(&mut renderer, &b);
        assert_ne!(colored, white);
        assert!(!renderer.stats().packet_reused);
        assert_eq!(readback(&mut renderer, &a), white);
        let target = output_texture(&renderer, &a);
        let mut scene = a.prepared_scene();
        scene.clear = b.prepared_scene().clear;
        renderer
            .render(scene, &target.create_view(&Default::default()))
            .unwrap();
        assert_eq!(read_texture(&renderer, &target), colored);
        assert!(!renderer.stats().packet_reused);
        scene.color_config.profile = OutputProfile::DisplayP3;
        renderer
            .render(scene, &target.create_view(&Default::default()))
            .unwrap();
        let p3 = read_texture(&renderer, &target);
        assert_ne!(p3, colored);
        let p3_cpu = Canvas::with_color_config(32, 24, scene.color_config).unwrap();
        let mut p3_cpu = p3_cpu;
        p3_cpu.clear(Color::rgb(70, 120, 190));
        for (&x, &y) in p3.iter().zip(p3_cpu.pixels()) {
            assert!((i16::from(x) - i16::from(y)).abs() <= 1);
        }
        assert!(
            renderer
                .redraw(&target.create_view(&Default::default()))
                .unwrap()
                .is_some()
        );
        let before = renderer.stats();
        renderer.set_grouped_records(true);
        renderer.set_tile_proofs(true);
        assert!(
            renderer
                .redraw(&target.create_view(&Default::default()))
                .unwrap()
                .is_some()
        );
        assert_packet_replay(before, renderer.stats());
        for (groups, proofs) in [(false, true), (false, false), (true, false), (true, true)] {
            renderer.set_grouped_records(groups);
            renderer.set_tile_proofs(proofs);
            assert!(
                renderer
                    .redraw(&target.create_view(&Default::default()))
                    .unwrap()
                    .is_none()
            );
            renderer
                .render(scene, &target.create_view(&Default::default()))
                .unwrap();
            assert_eq!(read_texture(&renderer, &target), p3);
        }
        // Even a caller-mutated header uses the ordinary full admission path.
        scene.width = 33;
        assert!(
            renderer
                .render(scene, &target.create_view(&Default::default()))
                .is_err()
        );
        assert!(
            renderer
                .redraw(&target.create_view(&Default::default()))
                .unwrap()
                .is_none()
        );
    });
}

#[test]
fn redraw_rejects_wrong_targets_without_discarding_the_valid_packet() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut canvas = Canvas::recording(16, 16, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        let good = output_texture(&renderer, &canvas);
        assert!(
            renderer
                .redraw(&good.create_view(&Default::default()))
                .unwrap()
                .is_none()
        );
        renderer
            .render(
                canvas.prepared_scene(),
                &good.create_view(&Default::default()),
            )
            .unwrap();
        let first = read_texture(&renderer, &good);
        for (size, format) in [
            ([17, 16], renderer.format()),
            ([16, 16], wgpu::TextureFormat::Rgba16Float),
        ] {
            let bad = renderer.device().create_texture(&wgpu::TextureDescriptor {
                label: None,
                size: wgpu::Extent3d {
                    width: size[0],
                    height: size[1],
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format,
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
                view_formats: &[],
            });
            let count = renderer.stats().submissions;
            assert!(matches!(
                renderer.redraw(&bad.create_view(&Default::default())),
                Err(gpui_gpu::Error::InvalidScene)
            ));
            assert_eq!(renderer.stats().submissions, count);
            assert!(
                renderer
                    .redraw(&good.create_view(&Default::default()))
                    .unwrap()
                    .is_some()
            );
            assert_eq!(read_texture(&renderer, &good), first);
        }
        let mut replacement = Renderer::new(
            renderer.device().clone(),
            renderer.queue().clone(),
            renderer.format(),
        )
        .await
        .unwrap();
        assert!(
            replacement
                .redraw(&good.create_view(&Default::default()))
                .unwrap()
                .is_none()
        );
    });
}

#[test]
fn failed_preparation_after_image_upload_discards_the_previous_packet() {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling};
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let mut a = Canvas::recording(64, 64, ColorConfig::default()).unwrap();
        a.clear(Color::WHITE);
        let small = Image::rgba8(
            1,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![230, 19, 7, 255].into_boxed_slice(),
        )
        .unwrap();
        a.draw_image(
            &small,
            Rect::new(0., 0., 64., 64.),
            Affine::IDENTITY,
            Rect::new(0., 0., 64., 64.),
            ImageSampling::Nearest,
        )
        .unwrap();
        let tracked_start = a.paint_cursor();
        a.fill_rect(
            Rect::new(2.0, 2.0, 3.0, 3.0),
            Affine::IDENTITY,
            Rect::new(0.0, 0.0, 64.0, 64.0),
            Color::BLACK,
        )
        .unwrap();
        let tracked_index = a.paint_index(tracked_start).unwrap();
        let first = readback(&mut renderer, &a);
        let mut failing = Canvas::recording(512, 256, ColorConfig::default()).unwrap();
        failing.clear(Color::BLACK);
        let large = Image::rgba8(
            32,
            32,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![33; 32 * 32 * 4].into_boxed_slice(),
        )
        .unwrap();
        let clip = Rect::new(0., 0., 512., 256.);
        failing
            .draw_image(
                &large,
                Rect::new(0., 0., 32., 32.),
                Affine::IDENTITY,
                clip,
                ImageSampling::Nearest,
            )
            .unwrap();
        let mut text = TextSystem::bundled().unwrap();
        for value in ["W", "M", "N", "H", "Q", "O", "A", "B", "C", "D", "E", "F"] {
            let layout = text.shape(value, 128., None).unwrap();
            failing
                .draw_text_scaled(
                    &mut text,
                    &layout,
                    Point { x: 0., y: 0. },
                    Affine::IDENTITY,
                    clip,
                    Color::WHITE,
                    8.,
                )
                .unwrap();
        }
        let area: usize = failing
            .prepared_scene()
            .masks()
            .map(|m| m.width * m.height)
            .sum();
        assert!(area > 2048 * 2048, "fixture must exceed atlas area");
        let target = output_texture(&renderer, &failing);
        assert!(matches!(
            renderer.render(
                failing.prepared_scene(),
                &target.create_view(&Default::default())
            ),
            Err(gpui_gpu::Error::AtlasFull)
        ));
        assert_eq!(
            renderer.image_stats().unwrap().uploaded_bytes,
            32 * 32 * 4,
            "image buffer changed before the atlas rejection"
        );
        let old_target = output_texture(&renderer, &a);
        assert!(
            renderer
                .redraw(&old_target.create_view(&Default::default()))
                .unwrap()
                .is_none()
        );
        assert_eq!(
            readback(&mut renderer, &a),
            first,
            "retry rebuilds all old resource coordinates"
        );
        let mut paint = gpui_gpu::PaintRenderer::new(renderer);
        paint
            .render(
                a.prepared_scene(),
                &old_target.create_view(&Default::default()),
                &[tracked_index],
            )
            .unwrap();
        assert!(paint.binding(tracked_index).is_some());
        assert!(matches!(
            paint.render(
                failing.prepared_scene(),
                &target.create_view(&Default::default()),
                &[]
            ),
            Err(gpui_gpu::Error::AtlasFull)
        ));
        assert_eq!(paint.image_stats().unwrap().uploaded_bytes, 32 * 32 * 4);
        assert!(
            paint.binding(tracked_index).is_none(),
            "resource failure revokes the active map too"
        );
        assert!(
            paint
                .redraw(&old_target.create_view(&Default::default()))
                .unwrap()
                .is_none()
        );
    });
}

#[test]
fn hdr_and_wide_gamut_packets_redraw_exactly_without_reencoding_or_uploads() {
    use gpui_canvas::OutputProfile;
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        for profile in [OutputProfile::Srgb, OutputProfile::DisplayP3] {
            let mut canvas =
                Canvas::recording(23, 19, ColorConfig::linear_hdr(profile, 203.).unwrap()).unwrap();
            canvas.clear(Color::linear_srgb(-0.25, 2., 0.5, 0.7).unwrap());
            canvas
                .fill_rect(
                    Rect::new(0.125, 0.375, 19., 17.),
                    Affine::IDENTITY,
                    Rect::new(0., 0., 23., 19.),
                    Color::linear_display_p3(3., 0.1, -0.2, 0.5).unwrap(),
                )
                .unwrap();
            let first = readback(&mut renderer, &canvas);
            let target = output_texture(&renderer, &canvas);
            let before = renderer.stats();
            assert!(
                renderer
                    .redraw(&target.create_view(&Default::default()))
                    .unwrap()
                    .is_some()
            );
            assert_packet_replay(before, renderer.stats());
            assert_eq!(read_texture(&renderer, &target), first);
        }
    });
}

#[test]
fn analytic_rounded_rectangles_match_cpu_and_never_use_rect_certificates() {
    pollster::block_on(async {
        for format in [
            wgpu::TextureFormat::Rgba8UnormSrgb,
            wgpu::TextureFormat::Rgba16Float,
        ] {
            let mut renderer = renderer(format).await;
            let hdr = format == wgpu::TextureFormat::Rgba16Float;
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            for radius in [0.0, 0.125, 1.0, 5.0, 12.5, 1000.0] {
                for map in [
                    Affine::IDENTITY,
                    Affine {
                        a: -1.0,
                        b: 0.0,
                        c: 0.0,
                        d: 1.0,
                        tx: 39.0,
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
                    let mut canvas = Canvas::recording(48, 40, config).unwrap();
                    canvas.clear(Color::WHITE);
                    let rect = Rect::new(0.125, 0.375, 29.0, 25.0);
                    let clip = Rect::new(0.375, 0.125, 45.5, 38.25);
                    for color in [Color::rgba(255, 0, 0, 128), Color::rgba(0, 0, 255, 128)] {
                        canvas
                            .fill_rounded_rect(rect, radius, map, clip, color)
                            .unwrap();
                    }
                    let actual = readback(&mut renderer, &canvas);
                    assert_eq!(renderer.stats().draw_record_bytes, 2 * 96);
                    if radius > 0.0 {
                        assert_eq!(renderer.stats().uniform_tiles, 0);
                    }
                    renderer.set_tile_proofs(false);
                    assert_eq!(readback(&mut renderer, &canvas), actual);
                    renderer.set_tile_proofs(true);
                    let expected = canvas.pixels();
                    if hdr {
                        for (i, (a, b)) in actual
                            .chunks_exact(2)
                            .zip(expected.chunks_exact(2))
                            .enumerate()
                        {
                            assert!(
                                u16::from_le_bytes([a[0], a[1]])
                                    .abs_diff(u16::from_le_bytes([b[0], b[1]]))
                                    <= 1,
                                "radius {radius} map {map:?} half {i}"
                            );
                        }
                    } else {
                        for (i, (&a, &b)) in actual.iter().zip(expected).enumerate() {
                            assert!(
                                a.abs_diff(b) <= 1,
                                "radius {radius} map {map:?} byte {i}: GPU {a} CPU {b}"
                            );
                        }
                    }
                }
            }
            // CPU accepts this radius. Shader FTZ/distance range limits are a
            // separate typed Precision error, never a silently squared zero.
            let mut tiny = Canvas::recording(8, 8, config).unwrap();
            tiny.clear(Color::WHITE);
            let rect = Rect::new(0.0, 0.0, 8.0, 8.0);
            tiny.fill_rounded_rect(
                rect,
                f32::from_bits(1),
                Affine::IDENTITY,
                rect,
                Color::BLACK,
            )
            .unwrap();
            let output = output_texture(&renderer, &tiny);
            assert!(matches!(
                renderer.render(
                    tiny.prepared_scene(),
                    &output.create_view(&Default::default())
                ),
                Err(gpui_gpu::Error::Precision { draw: 0 })
            ));
            assert_eq!(
                tiny.try_pixels().unwrap().len(),
                8 * 8 * if hdr { 8 } else { 4 }
            );
        }
    });
}

#[test]
fn rounded_images_share_pixels_and_fixed_packet_strides_preserve_queued_order() {
    use gpui_canvas::{AlphaMode, Image, ImageOptions, ImageProfile, ImageSampling};
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let image = Image::rgba8(
            2,
            2,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![
                255, 0, 0, 255, 0, 255, 0, 128, 0, 0, 255, 255, 255, 255, 255, 255,
            ]
            .into_boxed_slice(),
        )
        .unwrap();
        let mut a = Canvas::recording(40, 32, ColorConfig::default()).unwrap();
        a.clear(Color::WHITE);
        let clip = Rect::new(0.0, 0.0, 40.0, 32.0);
        for (i, radius) in [0.0, 5.0, 10.0, 1.0].into_iter().enumerate() {
            a.draw_image_with(
                &image,
                Rect::new(i as f32 * 4.0 + 0.125, 0.375, 23.0, 25.0),
                Affine::IDENTITY,
                clip,
                ImageOptions {
                    sampling: ImageSampling::Linear,
                    corner_radius: radius,
                },
            )
            .unwrap();
            a.fill_rounded_rect(
                Rect::new(2.0 + i as f32, 17.0, 8.0, 9.0),
                2.0,
                Affine::IDENTITY,
                clip,
                Color::rgba(0, 0, 0, 128),
            )
            .unwrap();
        }
        assert_eq!(a.prepared_scene().images().count(), 1);
        let mut b = Canvas::recording(40, 32, ColorConfig::default()).unwrap();
        b.clear(Color::BLACK);
        b.draw_image_with(
            &image,
            Rect::new(0.0, 0.0, 40.0, 32.0),
            Affine::IDENTITY,
            clip,
            ImageOptions {
                sampling: ImageSampling::Nearest,
                corner_radius: 16.0,
            },
        )
        .unwrap();
        for grouped in [false, true] {
            renderer.set_grouped_records(grouped);
            let ta = output_texture(&renderer, &a);
            let replay = output_texture(&renderer, &a);
            let tb = output_texture(&renderer, &b);
            renderer
                .render(a.prepared_scene(), &ta.create_view(&Default::default()))
                .unwrap();
            assert_eq!(renderer.image_stats().unwrap().packed_bytes, 16);
            // Images and rounded solids retain the ordinary six-word records.
            // Resource replacement must preserve prior queued submissions.
            assert_eq!(renderer.stats().draw_record_bytes, 8 * 96);
            renderer
                .redraw(&replay.create_view(&Default::default()))
                .unwrap()
                .unwrap();
            renderer
                .render(b.prepared_scene(), &tb.create_view(&Default::default()))
                .unwrap();
            let actual_a = read_texture(&renderer, &ta);
            assert_eq!(actual_a, read_texture(&renderer, &replay));
            let actual_b = read_texture(&renderer, &tb);
            for (actual, expected) in [(&actual_a, a.pixels()), (&actual_b, b.pixels())] {
                for (i, (&x, &y)) in actual.iter().zip(expected).enumerate() {
                    assert!(x.abs_diff(y) <= 1, "byte {i}: GPU {x} CPU {y}");
                }
            }
        }
    });
}

#[test]
fn rounded_circle_pythagorean_sites_neighbor_radii_and_origin_cancellation() {
    pollster::block_on(async {
        for hdr in [false, true] {
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let mut renderer = renderer(format).await;
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            for origin in [0.125, 32.125, -32.125] {
                for radius in [
                    f32::from_bits(5.0_f32.to_bits() - 1),
                    5.0,
                    f32::from_bits(5.0_f32.to_bits() + 1),
                ] {
                    let mut canvas = Canvas::recording(16, 16, config).unwrap();
                    canvas.clear(if hdr {
                        Color::TRANSPARENT
                    } else {
                        Color::WHITE
                    });
                    let clip = Rect::new(0.0, 0.0, 16.0, 16.0);
                    canvas
                        .fill_rounded_rect(
                            Rect::new(origin, origin, 10.0, 10.0),
                            radius,
                            Affine {
                                tx: 0.125 - origin,
                                ty: 0.125 - origin,
                                ..Affine::IDENTITY
                            },
                            clip,
                            if hdr { Color::WHITE } else { Color::BLACK },
                        )
                        .unwrap();
                    let gpu = readback(&mut renderer, &canvas);
                    if hdr {
                        // Sixteen binary coverage values average to exact
                        // multiples of 1/16. No transfer/quantizer tolerance
                        // can hide a different geometric sample decision.
                        assert_eq!(gpu, canvas.pixels(), "origin {origin}, radius {radius}");
                    } else {
                        for (i, (&a, &b)) in gpu.iter().zip(canvas.pixels()).enumerate() {
                            assert!(
                                a.abs_diff(b) <= 1,
                                "SDR transfer byte {i}, origin {origin}, radius {radius}: {a}/{b}"
                            );
                        }
                    }
                }
            }
        }
    });
}

#[test]
fn rounded_image_material_decodes_exact_hdr_coverage() {
    use gpui_canvas::{AlphaMode, Image, ImageOptions, ImageSampling};
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let image = Image::linear_srgb(1, 1, AlphaMode::Straight, Box::new([[1.0; 4]])).unwrap();
        let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
        for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
            for radius in [
                f32::from_bits(5.0_f32.to_bits() - 1),
                5.0,
                f32::from_bits(5.0_f32.to_bits() + 1),
            ] {
                let mut canvas = Canvas::recording(16, 16, config).unwrap();
                canvas.clear(Color::TRANSPARENT);
                canvas
                    .draw_image_with(
                        &image,
                        Rect::new(32.125, 32.125, 10.0, 10.0),
                        Affine {
                            tx: -32.0,
                            ty: -32.0,
                            ..Affine::IDENTITY
                        },
                        Rect::new(0.0, 0.0, 16.0, 16.0),
                        ImageOptions {
                            sampling,
                            corner_radius: radius,
                        },
                    )
                    .unwrap();
                assert_eq!(
                    readback(&mut renderer, &canvas),
                    canvas.pixels(),
                    "{sampling:?}, radius {radius}"
                );
            }
        }
    });
}

fn patch_scene(
    canvas: &mut Canvas,
    text: &mut TextSystem,
    layout: &gpui_canvas::TextLayout,
    colors: [Color; 3],
) -> [gpui_canvas::PaintIndex; 3] {
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0.0, 0.0, 64.0, 48.0);
    let start = canvas.paint_cursor();
    canvas
        .fill_rect(clip, Affine::IDENTITY, clip, colors[0])
        .unwrap();
    let background = canvas.paint_index(start).unwrap();
    let start = canvas.paint_cursor();
    canvas
        .fill_rounded_rect(
            Rect::new(0.125, 0.375, 31.0, 27.0),
            6.0,
            Affine {
                a: -1.0,
                c: 0.25,
                tx: 43.0,
                ty: 4.0,
                ..Affine::IDENTITY
            },
            clip,
            colors[1],
        )
        .unwrap();
    let upper = canvas.paint_index(start).unwrap();
    let start = canvas.paint_cursor();
    canvas
        .draw_text(
            text,
            layout,
            Point { x: 1.0, y: 8.0 },
            Affine::IDENTITY,
            clip,
            colors[2],
        )
        .unwrap();
    [background, upper, canvas.paint_index(start).unwrap()]
}

#[test]
fn paint_packets_queue_a_patch_b_patch_c_before_readback_and_match_full_rebuilds() {
    use gpui_canvas::PaintEdit;
    use gpui_gpu::{GpuPaintEdit, PaintRenderer};
    pollster::block_on(async {
        for hdr in [false, true] {
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::DisplayP3, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            let mut gpu = PaintRenderer::new(renderer(format).await);
            let mut text = TextSystem::bundled().unwrap();
            let layout = text.shape("ABA café", 16.0, None).unwrap();
            let colors = [
                [
                    Color::rgb(40, 50, 60),
                    Color::rgba(255, 0, 0, 128),
                    Color::BLACK,
                ],
                [
                    Color::rgb(60, 50, 40),
                    Color::rgba(0, 0, 255, 128),
                    Color::rgb(20, 180, 50),
                ],
                [
                    Color::linear_display_p3(-0.2, 1.2, 0.3, 1.0).unwrap(),
                    Color::rgba(0, 255, 0, 128),
                    Color::rgb(70, 40, 190),
                ],
            ];
            let mut canvases: Vec<_> = (0..3)
                .map(|_| Canvas::recording(64, 48, config).unwrap())
                .collect();
            let indices = patch_scene(&mut canvases[0], &mut text, &layout, colors[0]);
            for i in 1..3 {
                assert_eq!(
                    indices,
                    patch_scene(&mut canvases[i], &mut text, &layout, colors[i])
                );
            }
            let ta = output_texture(&gpu, &canvases[0]);
            let tb = output_texture(&gpu, &canvases[0]);
            let tc = output_texture(&gpu, &canvases[0]);
            gpu.render(
                canvases[0].prepared_scene(),
                &ta.create_view(&Default::default()),
                &indices,
            )
            .unwrap();
            assert_eq!(gpu.binding_bytes(), 3 * 12);
            for (i, target) in [(1, &tb), (2, &tc)] {
                let edits: Vec<_> = indices
                    .iter()
                    .zip(colors[i])
                    .map(|(&index, color)| {
                        GpuPaintEdit::new(gpu.binding(index).unwrap(), PaintEdit::new(index, color))
                    })
                    .collect();
                let view = target.create_view(&Default::default());
                let indexed: Vec<_> = indices
                    .iter()
                    .zip(colors[i])
                    .map(|(&index, color)| PaintEdit::new(index, color))
                    .collect();
                let plan = if i == 1 {
                    gpu.prepare_paint(&edits, &view).unwrap()
                } else {
                    gpu.prepare_paint_indexed(&indexed, &view).unwrap()
                };
                assert_eq!(plan.changed_groups(), 3);
                assert_eq!(plan.upload_bytes(), 48);
                plan.commit();
                let stats = gpu.stats();
                assert_eq!(
                    (
                        stats.validated_draws,
                        stats.binning_tile_visits,
                        stats.bind_group_creations
                    ),
                    (0, 0, 0)
                );
                assert_eq!(
                    (stats.instance_upload_bytes, stats.mask_upload_bytes),
                    (48, 0)
                );
            }
            // No poll/readback occurred between baseline and either patch.
            let actual = [
                read_texture(&gpu, &ta),
                read_texture(&gpu, &tb),
                read_texture(&gpu, &tc),
            ];
            let mut plain = gpu.into_inner();
            for (i, canvas) in canvases.iter().enumerate() {
                assert_eq!(
                    actual[i],
                    readback(&mut plain, canvas),
                    "hdr={hdr}, frame={i}"
                );
            }
        }
    });
}

#[test]
fn paint_validation_is_atomic_and_hdr_proof_changes_require_full_rebuild() {
    use gpui_canvas::PaintEdit;
    use gpui_gpu::{GpuPaintEdit, PaintError, PaintRenderer};
    pollster::block_on(async {
        let mut gpu = PaintRenderer::new(renderer(wgpu::TextureFormat::Rgba16Float).await);
        let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
        let mut canvas = Canvas::recording(64, 64, config).unwrap();
        let clip = Rect::new(0.0, 0.0, 64.0, 64.0);
        canvas.clear(Color::WHITE);
        let start = canvas.paint_cursor();
        canvas
            .fill_rect(clip, Affine::IDENTITY, clip, Color::rgb(50, 20, 10))
            .unwrap();
        let first = canvas.paint_index(start).unwrap();
        let start = canvas.paint_cursor();
        canvas
            .fill_rect(
                Rect::new(16.0, 16.0, 32.0, 32.0),
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
        let second = canvas.paint_index(start).unwrap();
        let a = output_texture(&gpu, &canvas);
        gpu.render(
            canvas.prepared_scene(),
            &a.create_view(&Default::default()),
            &[first, second],
        )
        .unwrap();
        assert!(gpu.stats().uniform_tiles > 0);
        let initial = read_texture(&gpu, &a);
        let b = output_texture(&gpu, &canvas);
        let view = b.create_view(&Default::default());
        for bad in [-0.0, -f32::from_bits(1)] {
            let edits = [
                GpuPaintEdit::new(
                    gpu.binding(first).unwrap(),
                    PaintEdit::new(first, Color::WHITE),
                ),
                GpuPaintEdit::new(
                    gpu.binding(second).unwrap(),
                    PaintEdit::new(second, Color::linear_srgb(bad, 0.25, 0.5, 1.0).unwrap()),
                ),
            ];
            assert_eq!(
                gpu.prepare_paint(&edits, &view).err(),
                Some(PaintError::ProofColor { edit: 1 })
            );
            gpu.redraw(&view).unwrap().unwrap();
            assert_eq!(
                read_texture(&gpu, &b),
                initial,
                "failed second edit must not write first"
            );
        }
        let edits = [GpuPaintEdit::new(
            gpu.binding(first).unwrap(),
            PaintEdit::new(first, Color::WHITE),
        )];
        drop(gpu.prepare_paint(&edits, &view).unwrap());
        gpu.redraw(&view).unwrap().unwrap();
        assert_eq!(read_texture(&gpu, &b), initial);
        let edits = [GpuPaintEdit::new(
            gpu.binding(first).unwrap(),
            PaintEdit::new(first, Color::rgba(255, 255, 255, 128)),
        )];
        assert_eq!(
            gpu.prepare_paint(&edits, &view).err(),
            Some(PaintError::AlphaChanged { edit: 0 })
        );
        let changed = [PaintEdit::new(
            second,
            Color::linear_srgb(-0.0, 0.25, 0.5, 1.0).unwrap(),
        )];
        canvas.prepare_paint(&changed).unwrap().commit();
        gpu.render(canvas.prepared_scene(), &view, &[first, second])
            .unwrap();
        let rebuilt = read_texture(&gpu, &b);
        let mut plain = gpu.into_inner();
        assert_eq!(rebuilt, readback(&mut plain, &canvas));
    });
}

#[test]
fn paint_modes_foreign_ordinals_and_attempted_full_failures_revoke_mapping() {
    use gpui_canvas::PaintEdit;
    use gpui_gpu::{GpuPaintEdit, PaintError, PaintRenderer};
    pollster::block_on(async {
        let mut gpu = PaintRenderer::new(renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await);
        let mut text = TextSystem::bundled().unwrap();
        let layout = text.shape("AAAA", 16.0, None).unwrap();
        let mut canvas = Canvas::recording(64, 48, ColorConfig::default()).unwrap();
        let sites = patch_scene(
            &mut canvas,
            &mut text,
            &layout,
            [Color::BLACK, Color::rgba(0, 0, 255, 128), Color::BLACK],
        );
        let target = output_texture(&gpu, &canvas);
        let view = target.create_view(&Default::default());
        gpu.render(canvas.prepared_scene(), &view, &sites).unwrap();
        let old = gpu.binding(sites[0]).unwrap();
        let edits = [GpuPaintEdit::new(
            old,
            PaintEdit::new(sites[1], Color::rgb(255, 0, 0)),
        )];
        assert_eq!(
            gpu.prepare_paint(&edits, &view).err(),
            Some(PaintError::InvalidBinding { edit: 0 })
        );
        gpu.set_grouped_records(false);
        assert!(gpu.binding(sites[0]).is_none());
        assert!(gpu.redraw(&view).unwrap().is_none());
        gpu.render(canvas.prepared_scene(), &view, &sites).unwrap();
        let edits = [GpuPaintEdit::new(
            gpu.binding(sites[2]).unwrap(),
            PaintEdit::new(sites[2], Color::WHITE),
        )];
        assert_eq!(
            gpu.prepare_paint(&edits, &view).err(),
            Some(PaintError::UnsupportedGroup { edit: 0 })
        );
        gpu.set_tile_proofs(false);
        assert!(gpu.binding(sites[0]).is_none());
        gpu.render(canvas.prepared_scene(), &view, &sites).unwrap();
        let mut invalid = canvas.prepared_scene();
        invalid.clear[0] = f32::NAN;
        assert!(gpu.render(invalid, &view, &sites).is_err());
        assert!(gpu.binding(sites[0]).is_none());
        assert!(gpu.redraw(&view).unwrap().is_none());
        // Wrong-target prevalidation is nonmutating and preserves a valid map.
        gpu.render(canvas.prepared_scene(), &view, &sites).unwrap();
        let mut tiny = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
        tiny.clear(Color::WHITE);
        let bad = output_texture(&gpu, &tiny);
        let wrong = bad.create_view(&Default::default());
        let edits = [GpuPaintEdit::new(
            gpu.binding(sites[0]).unwrap(),
            PaintEdit::new(sites[0], Color::WHITE),
        )];
        assert_eq!(
            gpu.prepare_paint(&edits, &wrong).err(),
            Some(PaintError::InvalidTarget)
        );
        assert!(gpu.binding(sites[0]).is_some());
        assert!(gpu.redraw(&view).unwrap().is_some());
    });
}

#[test]
fn separate_identical_color_calls_keep_independent_positional_groups() {
    use gpui_canvas::PaintEdit;
    use gpui_gpu::PaintRenderer;
    pollster::block_on(async {
        for hdr in [false, true] {
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let mut gpu = PaintRenderer::new(renderer(format).await);
            let initial = Color::rgba(100, 50, 25, 128);
            let rect = Rect::new(2.0, 3.0, 20.0, 17.0);
            let clip = Rect::new(0.0, 0.0, 32.0, 24.0);
            let build = |colors: [Color; 2]| {
                let mut canvas = Canvas::recording(32, 24, config).unwrap();
                canvas.clear(Color::WHITE);
                let mut indices = Vec::new();
                for color in colors {
                    let cursor = canvas.paint_cursor();
                    canvas
                        .fill_rect(rect, Affine::IDENTITY, clip, color)
                        .unwrap();
                    indices.push(canvas.paint_index(cursor).unwrap());
                }
                (canvas, indices)
            };
            let (mut canvas, indices) = build([initial; 2]);
            assert_eq!(canvas.prepared_scene().groups().len(), 2);
            let target = output_texture(&gpu, &canvas);
            let view = target.create_view(&Default::default());
            gpu.render_indices(
                canvas.prepared_scene(),
                &view,
                indices.iter().rev().copied(),
            )
            .unwrap();
            for colors in [
                [Color::rgba(20, 150, 60, 128), initial],
                [initial, Color::rgba(30, 70, 180, 128)],
                [initial; 2],
            ] {
                let edits: Vec<_> = indices
                    .iter()
                    .zip(colors)
                    .map(|(&index, color)| PaintEdit::new(index, color))
                    .collect();
                canvas.prepare_paint(&edits).unwrap().commit();
                gpu.prepare_paint_indexed(&edits, &view).unwrap().commit();
                let actual = read_texture(&gpu, &target);
                let (mut expected, _) = build(colors);
                assert_eq!(canvas.pixels(), expected.pixels());
                let expected_target = output_texture(&gpu, &expected);
                let mut full = Renderer::new(gpu.device().clone(), gpu.queue().clone(), format)
                    .await
                    .unwrap();
                full.render(
                    expected.prepared_scene(),
                    &expected_target.create_view(&Default::default()),
                )
                .unwrap();
                assert_eq!(actual, read_texture(&full, &expected_target));
            }
        }
    });
}

fn bank_scene(
    canvas: &mut Canvas,
    colors: [Color; 2],
    banked: bool,
) -> Option<[gpui_canvas::PaintSlot; 2]> {
    use gpui_canvas::{AlphaMode, Image, ImageProfile, ImageSampling, PaintColor};
    canvas.clear(Color::WHITE);
    let clip = Rect::new(0.0, 0.0, 64.0, 48.0);
    let a = banked.then(|| canvas.paint_slot(PaintColor::new(colors[0])).unwrap());
    if let Some(a) = a {
        canvas
            .fill_rect_slot(clip, Affine::IDENTITY, clip, a)
            .unwrap();
    } else {
        canvas
            .fill_rect(clip, Affine::IDENTITY, clip, colors[0])
            .unwrap();
    }
    // A literal row separates shared positions; no dense source-only remap.
    canvas
        .fill_rect(
            Rect::new(3.0, 4.0, 7.0, 6.0),
            Affine::IDENTITY,
            clip,
            Color::rgb(23, 45, 67),
        )
        .unwrap();
    let b = banked.then(|| canvas.paint_slot(PaintColor::new(colors[1])).unwrap());
    let rect = Rect::new(0.125, 0.375, 31.0, 27.0);
    let transform = Affine {
        a: -1.0,
        c: 0.25,
        tx: 43.0,
        ty: 4.0,
        ..Affine::IDENTITY
    };
    if let Some(b) = b {
        canvas
            .fill_rounded_rect_slot(rect, 6.0, transform, clip, b)
            .unwrap();
    } else {
        canvas
            .fill_rounded_rect(rect, 6.0, transform, clip, colors[1])
            .unwrap();
    }
    let mut text = TextSystem::bundled().unwrap();
    let layout = text.shape("ABA café", 16.0, None).unwrap();
    if let Some(b) = b {
        canvas
            .draw_text_scaled_slot(
                &mut text,
                &layout,
                Point { x: 1.0, y: 8.0 },
                Affine::IDENTITY,
                clip,
                b,
                1.0,
            )
            .unwrap();
    } else {
        canvas
            .draw_text(
                &mut text,
                &layout,
                Point { x: 1.0, y: 8.0 },
                Affine::IDENTITY,
                clip,
                colors[1],
            )
            .unwrap();
    }
    let image = Image::rgba8(
        2,
        2,
        ImageProfile::Srgb,
        AlphaMode::Straight,
        [255, 0, 255, 128].repeat(4).into_boxed_slice(),
    )
    .unwrap();
    canvas
        .draw_image(
            &image,
            Rect::new(45.0, 30.0, 12.0, 12.0),
            Affine::IDENTITY,
            clip,
            ImageSampling::Nearest,
        )
        .unwrap();
    a.zip(b).map(|(a, b)| [a, b])
}
#[test]
fn shared_bank_queues_a_patch_b_patch_c_without_poll_and_matches_full_literal_packets() {
    use gpui_canvas::{PaintColor, SlotEdit};
    pollster::block_on(async {
        for hdr in [false, true] {
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            let mut gpu = renderer(format).await;
            let colors = [
                [Color::BLACK, Color::rgba(0, 0, 255, 128)],
                [Color::rgb(80, 120, 160), Color::rgba(255, 0, 0, 128)],
                [Color::rgb(20, 40, 60), Color::rgba(0, 255, 0, 128)],
            ];
            let mut canvas = Canvas::recording(64, 48, config).unwrap();
            let slots = bank_scene(&mut canvas, colors[0], true).unwrap();
            let targets = std::array::from_fn::<_, 3, _>(|_| output_texture(&gpu, &canvas));
            gpu.render(
                canvas.prepared_scene(),
                &targets[0].create_view(&Default::default()),
            )
            .unwrap();
            for index in 1..3 {
                let edits = slots
                    .into_iter()
                    .zip(colors[index])
                    .map(|(slot, color)| SlotEdit::new(slot, PaintColor::new(color)))
                    .collect::<Vec<_>>();
                canvas.prepare_slots(&edits).unwrap().commit();
                let view = targets[index].create_view(&Default::default());
                let plan = gpu.prepare_slots(&edits, &view).unwrap();
                assert_eq!(plan.changed_slots(), 2);
                assert_eq!(plan.upload_bytes(), 32);
                plan.commit();
                let stats = gpu.stats();
                assert_eq!(stats.instance_upload_bytes, 32);
                assert_eq!(
                    (
                        stats.validated_draws,
                        stats.binning_tile_visits,
                        stats.bind_group_creations
                    ),
                    (0, 0, 0)
                );
            }
            // No submit was polled/read back before all A/B/C commands queued.
            let actual = targets.each_ref().map(|target| read_texture(&gpu, target));
            let mut oracle = renderer(format).await;
            for index in 0..3 {
                let mut full = Canvas::recording(64, 48, config).unwrap();
                bank_scene(&mut full, colors[index], false);
                assert_eq!(
                    actual[index],
                    readback(&mut oracle, &full),
                    "HDR={hdr} frame={index}"
                );
                if !hdr {
                    for (&gpu, &cpu) in actual[index].iter().zip(full.pixels()) {
                        assert!(gpu.abs_diff(cpu) <= 1);
                    }
                }
            }
            let bad = [SlotEdit::new(slots[0], PaintColor::new(Color::TRANSPARENT))];
            let view = targets[2].create_view(&Default::default());
            assert!(matches!(
                gpu.prepare_slots(&bad, &view),
                Err(gpui_gpu::SlotError::AlphaChanged { .. })
            ));
            // A valid first edit followed by a rejected second edit must not
            // change even the first bank word or revoke the complete packet.
            let mixed = [
                SlotEdit::new(slots[0], PaintColor::new(Color::WHITE)),
                SlotEdit::new(slots[1], PaintColor::new(Color::TRANSPARENT)),
            ];
            assert!(matches!(
                gpu.prepare_slots(&mixed, &view),
                Err(gpui_gpu::SlotError::AlphaChanged { edit: 1 })
            ));
            // Positional keys have no hidden namespace. Another Canvas can
            // supply an in-range literal position, which must reject by class.
            let mut positions = Canvas::recording(1, 1, config).unwrap();
            let positions = std::array::from_fn::<_, 4, _>(|_| {
                positions.paint_slot(PaintColor::new(Color::WHITE)).unwrap()
            });
            assert!(matches!(
                gpu.prepare_slots(
                    &[SlotEdit::new(positions[1], PaintColor::new(Color::WHITE))],
                    &view
                ),
                Err(gpui_gpu::SlotError::NotShared { edit: 0 })
            ));
            assert!(matches!(
                gpu.prepare_slots(
                    &[SlotEdit::new(positions[3], PaintColor::new(Color::WHITE))],
                    &view
                ),
                Err(gpui_gpu::SlotError::MissingSlot { edit: 0 })
            ));
            gpu.redraw(&view).unwrap().unwrap();
            assert_eq!(read_texture(&gpu, &targets[2]), actual[2]);
        }
    });
}

#[test]
fn literal_cow_and_equal_source_rows_preserve_queued_positional_and_slot_submissions() {
    use gpui_canvas::{PaintColor, PaintEdit, SlotEdit};
    use gpui_gpu::PaintRenderer;
    pollster::block_on(async {
        for hdr in [false, true] {
            let format = if hdr {
                wgpu::TextureFormat::Rgba16Float
            } else {
                wgpu::TextureFormat::Rgba8UnormSrgb
            };
            let config = if hdr {
                ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else {
                ColorConfig::default()
            };
            let original = Color::linear_srgb(0.25, 0.5, 0.75, 1.0).unwrap();
            let changed = Color::linear_srgb(0.75, 0.25, 0.5, 1.0).unwrap();
            let clip = Rect::new(0.0, 0.0, 32.0, 8.0);
            let rect = |column| Rect::new(column as f32 * 8.0, 0.0, 8.0, 8.0);
            let mut canvas = Canvas::recording(32, 8, config).unwrap();
            canvas.clear(Color::WHITE);
            let mut indices = Vec::new();
            for column in 0..3 {
                let cursor = canvas.paint_cursor();
                canvas
                    .fill_rect(rect(column), Affine::IDENTITY, clip, original)
                    .unwrap();
                indices.push(canvas.paint_index(cursor).unwrap());
            }
            let slot = canvas.paint_slot(PaintColor::new(original)).unwrap();
            canvas
                .fill_rect_slot(rect(3), Affine::IDENTITY, clip, slot)
                .unwrap();
            let mut gpu = PaintRenderer::new(renderer(format).await);
            let targets = std::array::from_fn::<_, 3, _>(|_| output_texture(&gpu, &canvas));
            gpu.render(
                canvas.prepared_scene(),
                &targets[0].create_view(&Default::default()),
                &indices,
            )
            .unwrap();
            // Equal positional writes detach before a later changed write,
            // while no GPU word needs changing for the equal value itself.
            canvas
                .prepare_paint(&[PaintEdit::new(indices[0], original)])
                .unwrap()
                .commit();
            let edits = [PaintEdit::new(indices[0], changed)];
            canvas.prepare_paint(&edits).unwrap().commit();
            gpu.prepare_paint_indexed(&edits, &targets[1].create_view(&Default::default()))
                .unwrap()
                .commit();
            let mut gpu = gpu.into_inner();
            let edits = [SlotEdit::new(slot, PaintColor::new(Color::WHITE))];
            canvas.prepare_slots(&edits).unwrap().commit();
            gpu.prepare_slots(&edits, &targets[2].create_view(&Default::default()))
                .unwrap()
                .commit();
            // No readback or poll occurred between the three submissions.
            let actual = targets.each_ref().map(|target| read_texture(&gpu, target));
            let mut oracle = renderer(format).await;
            for (frame, colors) in [
                [original; 4],
                [changed, original, original, original],
                [changed, original, original, Color::WHITE],
            ]
            .into_iter()
            .enumerate()
            {
                let mut full = Canvas::with_color_config(32, 8, config).unwrap();
                full.clear(Color::WHITE);
                for (column, color) in colors.into_iter().enumerate() {
                    full.fill_rect(rect(column), Affine::IDENTITY, clip, color)
                        .unwrap();
                }
                assert_eq!(
                    actual[frame],
                    readback(&mut oracle, &full),
                    "HDR={hdr} frame={frame}"
                );
                if hdr {
                    assert_eq!(actual[frame], full.try_pixels().unwrap());
                } else {
                    for (&gpu, &cpu) in actual[frame].iter().zip(full.try_pixels().unwrap()) {
                        assert!(gpu.abs_diff(cpu) <= 1);
                    }
                }
            }
        }
    });
}

#[test]
fn bank_patch_rejects_exceptional_opaque_proof_colors_then_full_render_recovers() {
    use gpui_canvas::{PaintColor, SlotEdit};
    pollster::block_on(async {
        let mut gpu = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let config = ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap();
        let mut canvas = Canvas::recording(16, 16, config).unwrap();
        let slot = canvas.paint_slot(PaintColor::new(Color::WHITE)).unwrap();
        let rect = Rect::new(0., 0., 16., 16.);
        canvas
            .fill_rect_slot(rect, Affine::IDENTITY, rect, slot)
            .unwrap();
        let target = output_texture(&gpu, &canvas);
        let view = target.create_view(&Default::default());
        gpu.render(canvas.prepared_scene(), &view).unwrap();
        for first in [-0.0, f32::from_bits(0x8000_0001)] {
            let color = Color::linear_srgb(first, 0.25, 0.5, 1.0).unwrap();
            let working = PaintColor::new(color);
            assert_eq!(working.working()[0].to_bits(), first.to_bits());
            let edits = [SlotEdit::new(slot, working)];
            let before = read_texture(&gpu, &target);
            assert!(matches!(
                gpu.prepare_slots(&edits, &view),
                Err(gpui_gpu::SlotError::ProofColor { edit: 0 })
            ));
            gpu.redraw(&view).unwrap().unwrap();
            assert_eq!(read_texture(&gpu, &target), before);
            canvas.prepare_slots(&edits).unwrap().commit();
            gpu.render(canvas.prepared_scene(), &view).unwrap();
            let mut literal = Canvas::recording(16, 16, config).unwrap();
            literal
                .fill_rect(rect, Affine::IDENTITY, rect, color)
                .unwrap();
            let mut oracle = renderer(wgpu::TextureFormat::Rgba16Float).await;
            assert_eq!(read_texture(&gpu, &target), readback(&mut oracle, &literal));
            // Restore a normal proof class before checking the next rejected
            // transition, so the test does not rely on a prior exceptional row.
            canvas
                .prepare_slots(&[SlotEdit::new(slot, PaintColor::new(Color::WHITE))])
                .unwrap()
                .commit();
            gpu.render(canvas.prepared_scene(), &view).unwrap();
        }
    });
}

#[test]
fn shared_context_keeps_packets_atlases_images_and_slots_independent() {
    use gpui_canvas::{PaintColor, SlotEdit};
    use gpui_gpu::{GpuContext, RendererState};
    pollster::block_on(async {
        let owner = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let context = owner.context();
        let mut a = RendererState::new(context);
        let mut b = RendererState::new(context);
        let mut ca = Canvas::recording(64, 48, ColorConfig::default()).unwrap();
        let mut cb = Canvas::recording(81, 59, ColorConfig::default()).unwrap();
        let slots = bank_scene(&mut ca, [Color::WHITE, Color::BLACK], true).unwrap();
        bank_scene(
            &mut cb,
            [Color::rgb(13, 31, 57), Color::rgb(41, 113, 211)],
            true,
        );
        let ta = output_texture(&owner, &ca);
        let tb = output_texture(&owner, &cb);
        let va = ta.create_view(&Default::default());
        let vb = tb.create_view(&Default::default());
        a.render(context, ca.prepared_scene(), &va).unwrap();
        b.render(context, cb.prepared_scene(), &vb).unwrap();
        let before_b = read_texture(&owner, &tb);
        assert!(b.stats().atlas_keys > 0);
        assert_eq!(b.image_stats().unwrap().resources, 1);
        for (&gpu, &cpu) in before_b.iter().zip(cb.pixels()) {
            assert!((i16::from(gpu) - i16::from(cpu)).abs() <= 1);
        }

        // Even the same device/format has a distinct inferred pipeline layout.
        let other = GpuContext::new(
            context.device().clone(),
            context.queue().clone(),
            context.format(),
        )
        .await
        .unwrap();
        let foreign = renderer(context.format()).await;
        let writes = [SlotEdit::new(
            slots[0],
            PaintColor::new(Color::rgb(67, 137, 211)),
        )];
        let stats = a.stats();
        let before_a = read_texture(&owner, &ta);
        for wrong in [&other, foreign.context()] {
            assert!(matches!(
                a.render(wrong, ca.prepared_scene(), &va),
                Err(gpui_gpu::Error::IncompatibleContext)
            ));
            assert!(matches!(
                a.redraw(wrong, &va),
                Err(gpui_gpu::Error::IncompatibleContext)
            ));
            assert!(matches!(
                a.prepare_slots(wrong, &writes, &va),
                Err(gpui_gpu::SlotError::IncompatibleContext)
            ));
            assert_eq!(a.stats().submissions, stats.submissions);
            assert_eq!(a.stats().instance_upload_bytes, stats.instance_upload_bytes);
            assert_eq!(read_texture(&owner, &ta), before_a);
        }
        a.redraw(context, &va).unwrap().unwrap();
        assert_eq!(read_texture(&owner, &ta), before_a);
        ca.prepare_slots(&writes).unwrap().commit();
        a.prepare_slots(context, &writes, &va).unwrap().commit();
        for (&gpu, &cpu) in read_texture(&owner, &ta).iter().zip(ca.pixels()) {
            assert!((i16::from(gpu) - i16::from(cpu)).abs() <= 1);
        }
        b.redraw(context, &vb).unwrap().unwrap();
        assert_eq!(read_texture(&owner, &tb), before_b);

        // Replacing one window's entire state neither invalidates nor uploads
        // the survivor's packet, atlas or image cache.
        a = RendererState::new(context);
        assert!(a.redraw(context, &va).unwrap().is_none());
        drop(a);
        b.redraw(context, &vb).unwrap().unwrap();
        assert_eq!(b.stats().mask_upload_bytes, 0);
        assert_eq!(b.image_stats().unwrap().uploaded_bytes, 0);
        assert_eq!(read_texture(&owner, &tb), before_b);
        b.render(context, cb.prepared_scene(), &vb).unwrap();
        assert_eq!(b.stats().mask_upload_bytes, 0);
        assert_eq!(b.image_stats().unwrap().uploaded_bytes, 0);

        let wrong_format = context.device().create_texture(&wgpu::TextureDescriptor {
            label: Some("wrong-format shared target"),
            size: tb.size(),
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: wgpu::TextureFormat::Bgra8UnormSrgb,
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            view_formats: &[],
        });
        let wrong_view = wrong_format.create_view(&Default::default());
        assert!(matches!(
            b.prepare_slots(context, &[], &wrong_view),
            Err(gpui_gpu::SlotError::InvalidTarget)
        ));
        assert!(matches!(
            b.redraw(context, &wrong_view),
            Err(gpui_gpu::Error::InvalidScene)
        ));
        b.redraw(context, &vb).unwrap().unwrap();
        assert_eq!(read_texture(&owner, &tb), before_b);
        assert!(matches!(
            b.render(context, cb.prepared_scene(), &wrong_view),
            Err(gpui_gpu::Error::InvalidScene)
        ));
        assert!(b.redraw(context, &vb).unwrap().is_none());
    });
}

#[test]
fn shared_context_drop_and_real_destroy_never_rebind_old_state() {
    use gpui_gpu::{GpuContext, RendererState};
    pollster::block_on(async {
        let owner = renderer(wgpu::TextureFormat::Rgba8UnormSrgb).await;
        let temporary = GpuContext::new(
            owner.device().clone(),
            owner.queue().clone(),
            owner.format(),
        )
        .await
        .unwrap();
        let abandoned = RendererState::new(&temporary);
        // WGPU's resource leases safely outlive the high-level context. This
        // does not authorize rebinding them to a replacement inferred layout.
        drop(temporary);
        let mut abandoned = abandoned;
        let mut canvas = Canvas::recording(8, 8, ColorConfig::default()).unwrap();
        canvas.clear(Color::WHITE);
        let target = output_texture(&owner, &canvas);
        let view = target.create_view(&Default::default());
        assert!(matches!(
            abandoned.render(owner.context(), canvas.prepared_scene(), &view),
            Err(gpui_gpu::Error::IncompatibleContext)
        ));
        drop(abandoned);

        let destroyed = renderer(owner.format()).await;
        let mut stale = RendererState::new(destroyed.context());
        let destroyed_target = output_texture(&destroyed, &canvas);
        stale
            .render(
                destroyed.context(),
                canvas.prepared_scene(),
                &destroyed_target.create_view(&Default::default()),
            )
            .unwrap();
        let (send, receive) = std::sync::mpsc::channel();
        destroyed
            .device()
            .set_device_lost_callback(move |reason, message| {
                send.send((reason, message)).unwrap();
            });
        destroyed.device().destroy();
        destroyed
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
        let (reason, message) = receive
            .recv_timeout(std::time::Duration::from_secs(5))
            .unwrap();
        eprintln!("actual destroy callback: {reason:?}, {message}");
        assert!(matches!(
            stale.render(owner.context(), canvas.prepared_scene(), &view),
            Err(gpui_gpu::Error::IncompatibleContext)
        ));
        assert!(matches!(
            stale.redraw(owner.context(), &view),
            Err(gpui_gpu::Error::IncompatibleContext)
        ));
        assert!(matches!(
            stale.prepare_slots(owner.context(), &[], &view),
            Err(gpui_gpu::SlotError::IncompatibleContext)
        ));
        let invalid = GpuContext::new(
            destroyed.device().clone(),
            destroyed.queue().clone(),
            owner.format(),
        )
        .await;
        assert!(
            invalid.is_err(),
            "destroyed device must not create a usable context"
        );
        drop(stale);
        let mut fresh = RendererState::new(owner.context());
        fresh
            .render(owner.context(), canvas.prepared_scene(), &view)
            .unwrap();
        owner
            .device()
            .poll(wgpu::PollType::wait_indefinitely())
            .unwrap();
    });
}
