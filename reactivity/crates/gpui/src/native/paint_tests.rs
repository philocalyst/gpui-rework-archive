//! The actual private native packet bridge, with offscreen readback oracles.
use super::*;
use crate::{Color, El, FieldId, Signal, SignalMap, Source, Sources, div, rgb};
#[path = "scroll_copy_tests.rs"]
mod scroll_copy_tests;
struct Paint {
    color: Signal<Color>,
    mapped: bool,
}
impl Paint {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
}
impl View for Paint {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        let node = div().size(24).rounded(5.0);
        if self.mapped {
            node.bg(self.color.map(|color| *color))
        } else {
            node.bg(&self.color)
        }
    }
}
fn read(gpu: &GpuSurface, texture: &wgpu::Texture) -> Vec<u8> {
    let bytes = texture.format().block_copy_size(None).unwrap();
    let stride = (texture.width() * bytes).next_multiple_of(256);
    let buffer = gpu
        .renderer
        .device()
        .create_buffer(&wgpu::BufferDescriptor {
            label: Some("native paint readback"),
            size: u64::from(stride) * u64::from(texture.height()),
            usage: wgpu::BufferUsages::MAP_READ | wgpu::BufferUsages::COPY_DST,
            mapped_at_creation: false,
        });
    let mut encoder = gpu
        .renderer
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
                rows_per_image: Some(texture.height()),
            },
        },
        wgpu::Extent3d {
            width: texture.width(),
            height: texture.height(),
            depth_or_array_layers: 1,
        },
    );
    gpu.renderer.queue().submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |result| {
        send.send(result).unwrap();
    });
    gpu.renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    receive.recv().unwrap().unwrap();
    let mapped = buffer.get_mapped_range(..).unwrap();
    let mut output = Vec::new();
    for row in mapped.chunks_exact(stride as usize) {
        output.extend_from_slice(&row[..(texture.width() * bytes) as usize]);
    }
    drop(mapped);
    buffer.unmap();
    if matches!(texture.format(), wgpu::TextureFormat::Bgra8UnormSrgb) {
        for pixel in output.as_chunks_mut::<4>().0.iter_mut() {
            pixel.swap(0, 2);
        }
    }
    output
}
fn render<M: View + 'static>(
    gpu: &mut GpuSurface,
    oracle: &mut Renderer,
    owner: &mut Win<M>,
    texture: &wgpu::Texture,
) {
    let view = texture.create_view(&Default::default());
    let token = owner
        .with_paint_scene(|scene, token, state, damage| {
            gpu.render_damaged(scene, token, state, &view, Some(damage))
                .unwrap();
            token
        })
        .unwrap();
    let actual = read(gpu, texture);
    let expected = owner.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    owner
        .with_scene(|scene, _| oracle.render(scene, &view))
        .unwrap()
        .unwrap();
    assert_eq!(
        actual,
        read(gpu, texture),
        "native patch vs independent full GPU renderer"
    );
    if texture.format() == wgpu::TextureFormat::Rgba16Float {
        for (gpu, cpu) in actual
            .as_chunks::<2>()
            .0
            .iter()
            .zip(expected.as_chunks::<2>().0.iter())
        {
            let a = u16::from_le_bytes(*gpu);
            let b = u16::from_le_bytes(*cpu);
            // Rank finite signed halves monotonically, identifying both zeros.
            let ordered = |bits: u16| {
                let magnitude = bits & 0x7fff;
                if bits & 0x8000 == 0 {
                    0x8000 + magnitude
                } else {
                    0x8000 - magnitude
                }
            };
            assert!(
                ordered(a).abs_diff(ordered(b)) <= 1,
                "CPU/HDR conversion: {a:04x} vs {b:04x}"
            );
        }
    } else {
        assert!(
            actual
                .iter()
                .zip(&expected)
                .all(|(&a, &b)| a.abs_diff(b) <= 1),
            "CPU/SDR conversion"
        );
    }
    owner.presented(token).unwrap();
}
pub(super) fn run(gpu: &mut GpuSurface) {
    for (hdr, mapped) in [(false, false), (true, false), (false, true), (true, true)] {
        let old = if hdr {
            let renderer = pollster::block_on(Renderer::new(
                gpu.renderer.device().clone(),
                gpu.renderer.queue().clone(),
                wgpu::TextureFormat::Rgba16Float,
            ))
            .unwrap();
            Some(std::mem::replace(
                &mut gpu.renderer,
                gpui_gpu::RetainedRenderer::new(renderer),
            ))
        } else {
            None
        };
        gpu.packet_token = None;
        let mut oracle = pollster::block_on(Renderer::new(
            gpu.renderer.device().clone(),
            gpu.renderer.queue().clone(),
            gpu.renderer.format(),
        ))
        .unwrap();
        let mut owner = Win::recording(
            Paint {
                color: Signal::new(Color::BLACK),
                mapped,
            },
            WindowOptions {
                size: [32, 24],
                colors: if hdr {
                    gpui_canvas::ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0)
                        .unwrap()
                } else {
                    Default::default()
                },
            },
        )
        .unwrap();
        let texture = gpu
            .renderer
            .device()
            .create_texture(&wgpu::TextureDescriptor {
                label: Some("native paint oracle"),
                size: wgpu::Extent3d {
                    width: 32,
                    height: 24,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format: gpu.renderer.format(),
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
                view_formats: &[],
            });
        render(gpu, &mut oracle, &mut owner, &texture);
        owner.set(Paint::COLOR, Color::WHITE).unwrap();
        render(gpu, &mut oracle, &mut owner, &texture);
        assert_eq!(
            (
                gpu.renderer.stats().validated_draws,
                gpu.renderer.stats().instance_upload_bytes
            ),
            (0, 16)
        );
        owner.set(Paint::COLOR, rgb(0x102030)).unwrap();
        owner.set(Paint::COLOR, rgb(0x405060)).unwrap();
        render(gpu, &mut oracle, &mut owner, &texture);
        assert!(
            gpu.renderer.stats().validated_draws > 0,
            "coalesced token gap rebuilds latest C"
        );
        for color in [
            Color::linear_srgb(3.0, -0.5, 0.25, 1.0).unwrap(),
            Color::linear_srgb(-f32::from_bits(1), 0.5, 2.0, 1.0).unwrap(),
            Color::TRANSPARENT,
            Color::linear_srgb(2.0, 0.5, 0.0, 0.0).unwrap(),
            Color::BLACK,
        ] {
            owner.set(Paint::COLOR, color).unwrap();
            render(gpu, &mut oracle, &mut owner, &texture);
        }
        owner
            .set(Paint::COLOR, Color::rgba(40, 60, 80, 100))
            .unwrap();
        render(gpu, &mut oracle, &mut owner, &texture);
        assert!(
            gpu.renderer.stats().validated_draws > 0,
            "alpha change rebuilds topology/proofs"
        );
        // A different window can have the same source epoch. Its damage must
        // not authorize repair over this window's pixels, even on one device.
        let mut other = Win::recording(
            Paint {
                color: Signal::new(Color::BLACK),
                mapped,
            },
            WindowOptions {
                size: [32, 24],
                colors: if hdr {
                    gpui_canvas::ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0)
                        .unwrap()
                } else {
                    Default::default()
                },
            },
        )
        .unwrap();
        let other_token = other.with_scene(|_, token| token).unwrap();
        other.presented(other_token).unwrap();
        other.set(Paint::COLOR, Color::WHITE).unwrap();
        render(gpu, &mut oracle, &mut other, &texture);
        assert_eq!(gpu.renderer.retained_stats().composited_pixels, 32 * 24);
        render(gpu, &mut oracle, &mut owner, &texture);
        assert_eq!(gpu.renderer.retained_stats().composited_pixels, 32 * 24);
        if let Some(old) = old {
            gpu.renderer = old;
        }
        gpu.packet_token = None;
    }
    scroll_copy_tests::run(gpu);
}
