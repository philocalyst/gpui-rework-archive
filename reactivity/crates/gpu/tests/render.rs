use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use gpui_gpu::{Renderer, wgpu};

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
    let (width, height) = (canvas.width(), canvas.height());
    let bytes = renderer.format().block_copy_size(None).unwrap();
    let stride = (width * bytes).next_multiple_of(256);
    let device = renderer.device();
    let texture = device.create_texture(&wgpu::TextureDescriptor {
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
    });
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("readback"),
        size: u64::from(stride) * u64::from(height),
        usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    });
    renderer
        .render(
            canvas.prepared_scene(),
            &texture.create_view(&Default::default()),
        )
        .unwrap();
    let mut encoder = renderer
        .device()
        .create_command_encoder(&Default::default());
    encoder.copy_texture_to_buffer(
        wgpu::TexelCopyTextureInfo {
            texture: &texture,
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
fn linear_float_target_retains_hdr_and_premultiplied_alpha() {
    pollster::block_on(async {
        let mut renderer = renderer(wgpu::TextureFormat::Rgba16Float).await;
        let mut canvas = Canvas::recording(2, 1, ColorConfig::default()).unwrap();
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
                let mut canvas = Canvas::recording(1, 1, ColorConfig::default()).unwrap();
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
