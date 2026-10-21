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
