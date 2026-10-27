//! Complete owner publication + native packet bridge + GPU completion ablation.
//! Offscreen completion is not swapchain/scanout latency.
use super::*;
use crate::native::workload_port;
use std::time::Instant;
use winit::{application::ApplicationHandler, event::WindowEvent, window::WindowId};

struct Flat {
    color: crate::Signal<crate::Color>,
    size: u32,
}
impl Flat {
    const COLOR: crate::Source<Self, crate::Color> = crate::Source::new(
        crate::FieldId::new(1),
        "color",
        |m| &m.color,
        |m| &mut m.color,
    );
}
impl View for Flat {
    fn sources() -> crate::Sources<Self> {
        crate::Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> crate::El<'_> {
        crate::div().size(self.size).bg(&self.color)
    }
}
struct SolidList {
    offset: crate::Signal<f64>,
    tiny: bool,
}
impl SolidList {
    const OFFSET: crate::Source<Self, f64> = crate::Source::new(
        crate::FieldId::new(1),
        "offset",
        |m| &m.offset,
        |m| &mut m.offset,
    );
    fn width(&self) -> f64 {
        if self.tiny { 16. } else { 920. }
    }
    fn row_height(&self) -> f64 {
        if self.tiny { 4. } else { 28. }
    }
}
impl crate::ItemSource for SolidList {
    fn len(&self) -> usize {
        100_000
    }
    fn key(&self, index: usize) -> crate::ItemKey {
        crate::ItemKey::new(index as u64)
    }
    fn index_of(&self, key: crate::ItemKey) -> Option<usize> {
        usize::try_from(key.get()).ok().filter(|i| *i < 100_000)
    }
    fn row(&self, index: usize) -> crate::El<'_> {
        crate::div()
            .w(self.width())
            .h(self.row_height())
            .bg(if index % 2 == 0 {
                crate::Color::WHITE
            } else {
                crate::Color::BLACK
            })
    }
}
impl View for SolidList {
    fn sources() -> crate::Sources<Self> {
        crate::Sources::new().direct(Self::OFFSET)
    }
    fn view(&self) -> crate::El<'_> {
        crate::div()
            .w(if self.tiny { 32 } else { 960 })
            .h(if self.tiny { 32 } else { 720 })
            .bg(crate::Color::BLACK)
            .child(
                crate::div()
                    .w(0)
                    .h(0)
                    .transform(crate::Affine::translation(
                        if self.tiny { 0. } else { 20. },
                        if self.tiny { 0. } else { 290. },
                    ))
                    .child(
                        crate::uniform_list(crate::ListId::new(1), self, self.row_height())
                            .overscan(2)
                            .scroll_offset(&self.offset)
                            .w(self.width())
                            .h(if self.tiny { 16 } else { 400 }),
                    ),
            )
    }
}
fn texture(gpu: &GpuSurface, size: [u32; 2]) -> wgpu::Texture {
    gpu.renderer
        .device()
        .create_texture(&wgpu::TextureDescriptor {
            label: Some("complete scroll benchmark target"),
            size: wgpu::Extent3d {
                width: size[0],
                height: size[1],
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: gpu.renderer.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        })
}
fn present<M: View + 'static>(gpu: &mut GpuSurface, owner: &mut Win<M>, view: &wgpu::TextureView) {
    let token = owner
        .with_paint_scene(|scene, token, paint, damage| {
            gpu.render_damaged(scene, token, paint, view, Some(damage))
                .unwrap();
            token
        })
        .unwrap();
    gpu.renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    owner.presented(token).unwrap();
}
fn read(gpu: &GpuSurface, texture: &wgpu::Texture) -> Vec<u8> {
    let stride = (texture.width() * 4).next_multiple_of(256);
    let buffer = gpu
        .renderer
        .device()
        .create_buffer(&wgpu::BufferDescriptor {
            label: None,
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
        texture.size(),
    );
    gpu.renderer.queue().submit([encoder.finish()]);
    let (send, receive) = std::sync::mpsc::channel();
    buffer.map_async(wgpu::MapMode::Read, .., move |r| send.send(r).unwrap());
    gpu.renderer
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    receive.recv().unwrap().unwrap();
    let mapped = buffer.get_mapped_range(..).unwrap();
    mapped
        .chunks_exact(stride as usize)
        .flat_map(|row| &row[..texture.width() as usize * 4])
        .copied()
        .collect()
}
fn check<M: View + 'static>(gpu: &GpuSurface, owner: &Win<M>, output: &wgpu::Texture) -> u64 {
    let actual = read(gpu, output);
    let mut oracle = pollster::block_on(Renderer::new(
        gpu.renderer.device().clone(),
        gpu.renderer.queue().clone(),
        gpu.renderer.format(),
    ))
    .unwrap();
    owner
        .with_scene(|scene, _| oracle.render(scene, &output.create_view(&Default::default())))
        .unwrap()
        .unwrap();
    assert!(
        actual == read(gpu, output),
        "complete workload differs from full GPU rendering"
    );
    actual.iter().fold(0xcbf29ce484222325, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x100000001b3)
    })
}
fn run(gpu: &mut GpuSurface) {
    let case = std::env::var("GPUI_SCROLL_CASE").expect("explicit case");
    let allocations = std::env::var_os("GPUI_SCROLL_ALLOC").is_some();
    let frames: usize = std::env::var("GPUI_SCROLL_FRAMES")
        .unwrap()
        .parse()
        .unwrap();
    assert!(frames >= 4);
    let setup = Instant::now();
    let mut fixture = None;
    let mut flat = None;
    let mut list = None;
    let tiny_list = case == "list-tiny";
    let flat_size = if case == "flat-tiny" { 8 } else { 512 };
    let mut mount = || {
        if case.starts_with("list") {
            list = Some(
                Win::recording(
                    SolidList {
                        offset: crate::Signal::new(0.),
                        tiny: tiny_list,
                    },
                    WindowOptions {
                        size: if tiny_list { [32, 32] } else { [960, 720] },
                        ..Default::default()
                    },
                )
                .unwrap(),
            );
        } else if case.starts_with("flat") {
            flat = Some(
                Win::recording(
                    Flat {
                        color: crate::Signal::new(crate::Color::BLACK),
                        size: flat_size,
                    },
                    WindowOptions {
                        size: [flat_size, flat_size],
                        ..Default::default()
                    },
                )
                .unwrap(),
            );
        } else {
            fixture = Some(workload_port::CostFixture::new(&case));
        }
    };
    let mount_allocation = if allocations {
        Some(allocation_counter::measure(mount))
    } else {
        mount();
        None
    };
    let mount_ns = setup.elapsed().as_nanos();
    let output = texture(
        gpu,
        if tiny_list {
            [32, 32]
        } else if fixture.is_some() || list.is_some() {
            [960, 720]
        } else {
            [flat_size, flat_size]
        },
    );
    let view = output.create_view(&Default::default());
    let first = Instant::now();
    let mut initial = || {
        if let Some(f) = &mut fixture {
            present(gpu, &mut f.owner, &view);
        } else if let Some(owner) = &mut list {
            present(gpu, owner, &view);
        } else {
            present(gpu, flat.as_mut().unwrap(), &view);
        }
    };
    let first_allocation = if allocations {
        Some(allocation_counter::measure(initial))
    } else {
        initial();
        None
    };
    let first_ns = first.elapsed().as_nanos();
    let mut samples = Vec::with_capacity(frames + 16);
    for frame in 0..frames + 16 {
        let start = Instant::now();
        let mut operation = || {
            if let Some(f) = &mut fixture {
                f.advance(&case);
                present(gpu, &mut f.owner, &view);
            } else if let Some(owner) = &mut list {
                owner
                    .set(
                        SolidList::OFFSET,
                        (frame + 1) as f64 * if tiny_list { 1. } else { 14. },
                    )
                    .unwrap();
                present(gpu, owner, &view);
            } else {
                let owner = flat.as_mut().unwrap();
                owner
                    .set(
                        Flat::COLOR,
                        if frame % 2 == 0 {
                            crate::Color::WHITE
                        } else {
                            crate::Color::BLACK
                        },
                    )
                    .unwrap();
                present(gpu, owner, &view);
            }
        };
        let allocation = if allocations {
            Some(allocation_counter::measure(operation))
        } else {
            operation();
            None
        };
        let elapsed = start.elapsed().as_nanos();
        let stats = gpu.renderer.retained_stats();
        samples.push((frame, elapsed, stats, allocation));
    }
    let (hash, epoch) = if let Some(f) = &fixture {
        (
            check(gpu, &f.owner, &output),
            f.owner.snapshot().unwrap().source_epoch,
        )
    } else if let Some(owner) = &list {
        (
            check(gpu, owner, &output),
            owner.snapshot().unwrap().source_epoch,
        )
    } else {
        let owner = flat.as_ref().unwrap();
        (
            check(gpu, owner, &output),
            owner.snapshot().unwrap().source_epoch,
        )
    };
    println!("SETUP,{case},{mount_ns},{first_ns},{hash:016x},{epoch}");
    for (label, allocation) in [("mount", mount_allocation), ("first", first_allocation)] {
        if let Some(a) = allocation {
            println!(
                "SETUP_ALLOC,{case},{label},{},{},{},{}",
                a.count_total, a.bytes_total, a.bytes_current, a.bytes_max
            );
        }
    }
    println!(
        "HEADERS,SceneDamage={},RetainedRenderer={},GpuSurface={}",
        size_of::<crate::runtime::paint::SceneDamage>(),
        size_of::<gpui_gpu::RetainedRenderer>(),
        size_of::<GpuSurface>()
    );
    for (frame, ns, stats, allocation) in samples {
        if let Some(a) = allocation {
            println!(
                "ALLOC,{case},{frame},{},{},{},{},{},{}",
                a.count_total,
                a.bytes_total,
                a.bytes_current,
                a.bytes_max,
                stats.image_bytes,
                stats.copied_pixels
            );
        } else {
            println!(
                "FRAME,{case},{frame},{ns},{},{},{}",
                stats.composited_pixels, stats.copied_pixels, stats.image_bytes
            );
        }
    }
}
struct Harness {
    complete: bool,
}
impl ApplicationHandler for Harness {
    fn resumed(&mut self, event_loop: &ActiveEventLoop) {
        let window = Arc::new(
            event_loop
                .create_window(NativeWindow::default_attributes().with_visible(false))
                .unwrap(),
        );
        let mut descriptor =
            wgpu::InstanceDescriptor::new_with_display_handle_from_env(Box::new(window.clone()));
        descriptor.backends = wgpu::Backends::VULKAN;
        let instance = wgpu::Instance::new(descriptor);
        let handle = instance.create_surface(window).unwrap();
        let adapter = pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
            compatible_surface: Some(&handle),
            force_fallback_adapter: true,
            ..Default::default()
        }))
        .unwrap();
        eprintln!("SCROLL_ADAPTER,{:?}", adapter.get_info());
        assert_eq!(adapter.get_info().device_type, wgpu::DeviceType::Cpu);
        let renderer = pollster::block_on(Renderer::request(
            &adapter,
            wgpu::TextureFormat::Bgra8UnormSrgb,
        ))
        .unwrap();
        let errors = DeviceErrors::install(renderer.device(), None);
        let mut gpu = GpuSurface {
            handle,
            renderer: gpui_gpu::RetainedRenderer::new(renderer),
            errors,
            packet_token: None,
        };
        run(&mut gpu);
        assert!(gpu.errors.take().is_none(), "native GPU device fault");
        self.complete = true;
        event_loop.exit();
    }
    fn window_event(&mut self, _: &ActiveEventLoop, _: WindowId, _: WindowEvent) {}
}
#[test]
#[ignore = "isolated complete-operation cost measurement; explicit software Vulkan and case required"]
fn complete_workload_cost() {
    use winit::platform::x11::EventLoopBuilderExtX11;
    let event_loop = EventLoop::builder()
        .with_x11()
        .with_any_thread(true)
        .build()
        .unwrap();
    let mut harness = Harness { complete: false };
    event_loop.run_app(&mut harness).unwrap();
    assert!(harness.complete);
}
