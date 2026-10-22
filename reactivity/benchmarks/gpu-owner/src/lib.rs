//! Public offscreen ownership fixture. No elapsed-time measurements.
use gpui_canvas::{
    Affine, AlphaMode, Canvas, Color, ColorConfig, Image, ImageProfile, ImageSampling, Point, Rect,
    TextSystem,
};
use gpui_gpu::wgpu;

pub const FORMAT: wgpu::TextureFormat = wgpu::TextureFormat::Rgba8UnormSrgb;

pub fn adapter() -> (wgpu::Instance, wgpu::Adapter) {
    let mut descriptor = wgpu::InstanceDescriptor::new_without_display_handle();
    descriptor.backends = wgpu::Backends::VULKAN;
    let instance = wgpu::Instance::new(descriptor);
    let adapter = pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
        force_fallback_adapter: true,
        ..Default::default()
    }))
    .expect("Vulkan fallback adapter required");
    eprintln!(
        "adapter={:?}; counters={}",
        adapter.get_info(),
        cfg!(feature = "counts")
    );
    (instance, adapter)
}

pub fn device(adapter: &wgpu::Adapter) -> (wgpu::Device, wgpu::Queue) {
    pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor::default())).unwrap()
}

/// Different dimensions, image keys/pixels, glyph masks, and packets per window.
/// All scene/font ownership is prepared outside the GPU-owner allocation scope.
pub fn scenes(n: usize) -> Vec<Canvas> {
    let mut fonts = TextSystem::bundled().unwrap();
    (0..n)
        .map(|index| {
            let width = 96 + index as u32 * 3;
            let height = 56 + index as u32 * 2;
            let clip = Rect::new(0., 0., width as f32, height as f32);
            let mut canvas = Canvas::recording(width, height, ColorConfig::default()).unwrap();
            canvas.clear(Color::WHITE);
            canvas
                .fill_rect(
                    Rect::new(1., 1., 31., 9.),
                    Affine::IDENTITY,
                    clip,
                    Color::rgb(index as u8 * 19, 71, 131),
                )
                .unwrap();
            let image = Image::rgba8(
                2,
                1,
                ImageProfile::Srgb,
                AlphaMode::Straight,
                vec![19 + index as u8, 113, 211, 255, 231, 43, index as u8, 127].into_boxed_slice(),
            )
            .unwrap();
            canvas
                .draw_image(
                    &image,
                    Rect::new(4., 12., 21., 13.),
                    Affine::IDENTITY,
                    clip,
                    ImageSampling::Nearest,
                )
                .unwrap();
            let text = fonts
                .shape(&format!("office café {index}"), 14. + index as f32, None)
                .unwrap();
            canvas
                .draw_text(
                    &mut fonts,
                    &text,
                    Point { x: 2., y: 29. },
                    Affine::IDENTITY,
                    clip,
                    Color::BLACK,
                )
                .unwrap();
            canvas
        })
        .collect()
}

pub fn target(device: &wgpu::Device, canvas: &Canvas) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("owner fixture output"),
        size: wgpu::Extent3d {
            width: canvas.width(),
            height: canvas.height(),
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: FORMAT,
        usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
        view_formats: &[],
    })
}

pub fn pixels(device: &wgpu::Device, queue: &wgpu::Queue, texture: &wgpu::Texture) -> Vec<u8> {
    let stride = (texture.width() * 4).next_multiple_of(256);
    let buffer = device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("owner fixture readback"),
        size: u64::from(stride * texture.height()),
        usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    });
    let mut encoder = device.create_command_encoder(&Default::default());
    encoder.copy_texture_to_buffer(
        texture.as_image_copy(),
        wgpu::TexelCopyBufferInfo {
            buffer: &buffer,
            layout: wgpu::TexelCopyBufferLayout {
                offset: 0,
                bytes_per_row: Some(stride),
                rows_per_image: None,
            },
        },
        texture.size(),
    );
    queue.submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |result| {
        send.send(result).unwrap();
    });
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    receive.recv().unwrap().unwrap();
    let mapped = buffer.get_mapped_range(..).unwrap();
    let result = mapped
        .chunks_exact(stride as usize)
        .flat_map(|row| row[..texture.width() as usize * 4].iter().copied())
        .collect();
    drop(mapped);
    buffer.unmap();
    result
}

pub fn check(actual: &[u8], canvas: &mut Canvas) -> u64 {
    assert_eq!(actual.len(), canvas.pixels().len());
    for (index, (&gpu, &cpu)) in actual.iter().zip(canvas.pixels()).enumerate() {
        assert!(
            (i16::from(gpu) - i16::from(cpu)).abs() <= 1,
            "byte {index}: GPU {gpu}, CPU {cpu}"
        );
    }
    actual.iter().fold(0xcbf29ce484222325, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x100000001b3)
    })
}

pub fn counters(device: &wgpu::Device) {
    if cfg!(feature = "counts") {
        eprintln!("native_live={:?}", device.get_internal_counters());
    }
}
