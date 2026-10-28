use gpui_gpu::{Renderer, wgpu};
fn main() {
    let mut descriptor = wgpu::InstanceDescriptor::new_without_display_handle();
    descriptor.backends = wgpu::Backends::VULKAN;
    let instance = wgpu::Instance::new(descriptor);
    let adapter = pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
        force_fallback_adapter: true, ..Default::default()
    })).unwrap();
    eprintln!("adapter={:?}", adapter.get_info());
    let (device, queue) = pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor::default())).unwrap();
    for iteration in 0..4 {
        let mut renderer = None;
        let started = std::time::Instant::now();
        let allocation = allocation_counter::measure(|| {
            renderer = Some(pollster::block_on(Renderer::new(device.clone(), queue.clone(), wgpu::TextureFormat::Rgba8UnormSrgb)).unwrap());
        });
        let elapsed = started.elapsed().as_nanos();
        std::hint::black_box(renderer.as_ref().unwrap());
        println!("renderer,{iteration},{elapsed},{allocation:?}");
        drop(renderer);
        device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    }
}
