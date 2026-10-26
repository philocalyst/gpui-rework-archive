//! The actual private native packet bridge, with offscreen readback oracles.
use super::*;
use crate::{Color, El, FieldId, Signal, SignalMap, Source, Sources, div, rgb};
struct Paint {
    color: Signal<Color>,
    mapped: bool,
    two: bool,
    broken: bool,
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
        let node = div().size(if self.two { 12 } else { 24 }).rounded(5.0)
            .transform(if self.broken { crate::Affine::scale(0., 1.) } else { crate::Affine::IDENTITY });
        let node = if self.mapped {
            node.bg(self.color.map(|color| *color))
        } else {
            node.bg(&self.color)
        };
        if self.two {
            crate::row((node, div().size(12).rounded(3.).bg(self.color.map(|color| *color))))
        } else {
            node
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
        .with_paint_scene(|scene, token, state| {
            gpu.render_paint(scene, token, state, &view).unwrap();
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
struct Hover {
    current: Signal<u32>,
}
impl Hover {
    const CURRENT: Source<Self, u32> = Source::new(
        FieldId::new(1), "current", |model| &model.current, |model| &mut model.current,
    );
}
impl View for Hover {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::CURRENT) }
    fn view(&self) -> El<'_> {
        crate::row((0..3).map(|index| {
            div().size(8).bg(self.current.map_with(index, |current, index| {
                if *current == index { Color::WHITE } else { Color::BLACK }
            }))
        }))
    }
}
fn coalesced_hover_predecessor(
    gpu: &mut GpuSurface,
    oracle: &mut Renderer,
    texture: &wgpu::Texture,
    hdr: bool,
) {
    let mut owner = Win::recording(
        Hover { current: Signal::new(0) },
        WindowOptions {
            size: [32, 24],
            colors: if hdr {
                gpui_canvas::ColorConfig::linear_hdr(gpui_canvas::OutputProfile::Srgb, 203.0).unwrap()
            } else { Default::default() },
        },
    ).unwrap();
    gpu.packet_token = None;
    render(gpu, oracle, &mut owner, texture);
    for current in [1, 2] {
        let previous_capacity = owner.with_paint_scene(|_, _, state| {
            state.map_or(0, |state| state.retained_edit_capacity())
        }).unwrap();
        let cost = allocation_counter::measure(|| {
            owner.set(Hover::CURRENT, current).unwrap();
        });
        owner.with_paint_scene(|_, _, state| {
            let state = state.expect("two actual changed hover relationships");
            assert_eq!(state.edits().len(), 2);
            eprintln!(
                "NATIVE_TWO_SLOT_TRANSPORT previous_capacity={previous_capacity} current_capacity={} slot_edit_bytes={} allocations={} requested={} scoped_net_retained={} scoped_peak={}",
                state.retained_edit_capacity(), size_of::<gpui_canvas::SlotEdit>(),
                cost.count_total, cost.bytes_total, cost.bytes_current, cost.bytes_max,
            );
        }).unwrap();
    }
    owner.with_paint_scene(|_, _, state| {
        assert_ne!(Some(state.unwrap().from), gpu.packet_token);
    }).unwrap();
    // 0→1 changes A/B, then1→2 changes B/C. Applying only the last delta to
    // the submitted0 image leaves A wrong, so exact bytes detect a bad guard.
    render(gpu, oracle, &mut owner, texture);
    assert!(gpu.renderer.stats().validated_draws > 0);
}
pub(super) fn run(gpu: &mut GpuSurface) {
    for (hdr, mapped, two) in [
        (false, false, false), (true, false, false),
        (false, true, false), (true, true, false),
        (false, false, true), (true, false, true),
        (false, true, true), (true, true, true),
    ] {
        let old = if hdr {
            let renderer = pollster::block_on(Renderer::new(
                gpu.renderer.device().clone(),
                gpu.renderer.queue().clone(),
                wgpu::TextureFormat::Rgba16Float,
            ))
            .unwrap();
            Some(std::mem::replace(&mut gpu.renderer, renderer))
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
                two,
                broken: false,
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
        owner.with_paint_scene(|_, _, state| {
            let state = state.expect("same-alpha source update owns one slot transition");
            assert_eq!(Some(state.from), gpu.packet_token);
            assert_eq!(state.edits().len(), if two { 2 } else { 1 });
            assert!(state.edits().windows(2).all(|pair| pair[0].slot() < pair[1].slot()));
            eprintln!("NATIVE_PAINT_TRANSITION edits={} retained_capacity={}", state.edits().len(), state.retained_edit_capacity());
        }).unwrap();
        render(gpu, &mut oracle, &mut owner, &texture);
        assert_eq!(
            (
                gpu.renderer.stats().validated_draws,
                gpu.renderer.stats().instance_upload_bytes
            ),
            (0, if two { 32 } else { 16 })
        );
        if !hdr && !mapped && !two {
            // Exercise the exact-byte stale-predecessor oracle before the
            // older work-counter-only coalescing controls below can fail.
            coalesced_hover_predecessor(gpu, &mut oracle, &texture, false);
            render(gpu, &mut oracle, &mut owner, &texture);
        }
        if two {
            owner.set(Paint::COLOR, rgb(0x708090)).unwrap();
            let eligible = owner.with_scene(|_, token| token).unwrap();
            assert!(owner.update(|model| model.broken = true).is_err());
            assert_eq!(owner.with_scene(|_, token| token).unwrap(), eligible);
            // Submit the older two-slot C. The failed coarse description may
            // revoke optional slot transport, so a full GPU fallback is legal;
            // its ACK cannot certify the newer failed logical description.
            render(gpu, &mut oracle, &mut owner, &texture);
            let receipt = owner.snapshot().unwrap();
            assert!(receipt.presentation_epoch < receipt.source_epoch);
            assert_eq!(gpu.packet_token, Some(eligible));
            owner.update(|model| model.broken = false).unwrap();
            render(gpu, &mut oracle, &mut owner, &texture);
        }
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
        if two && mapped {
            coalesced_hover_predecessor(gpu, &mut oracle, &texture, hdr);
        }
        if let Some(old) = old {
            gpu.renderer = old;
        }
        gpu.packet_token = None;
    }
}
