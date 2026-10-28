//! Same public context-first drop probe, with matched optional device features.
use gpui_gpu::{GpuContext, RendererState, wgpu};
use gpui_gpu_owner_fixture as fixture;

fn main() {
    let (_instance, adapter) = fixture::adapter();
    let (device, queue) = pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
        required_features: adapter.features() & wgpu::Features::PASSTHROUGH_SHADERS,
        ..Default::default()
    }))
    .unwrap();
    println!("before context");
    fixture::counters(&device);
    let context =
        pollster::block_on(GpuContext::new(device.clone(), queue, fixture::FORMAT)).unwrap();
    let state = RendererState::new(&context);
    println!("live context and state");
    fixture::counters(&device);
    let context_drop = allocation_counter::measure(|| drop(context));
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    println!("context_drop={context_drop:?}");
    fixture::counters(&device);
    let state_drop = allocation_counter::measure(|| drop(state));
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    println!("state_drop={state_drop:?}");
    fixture::counters(&device);
}
