//! DHAT retained-owner control: exit before dropping any live graphics owner.
//! This deliberately skips destructors, unlike the ordinary first.rs control.
use gpui_gpu::{Renderer, wgpu};
use gpui_gpu_owner_fixture as fixture;

fn main() {
    let (_instance, adapter) = fixture::adapter();
    let (device, queue) = pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
        required_features: adapter.features() & wgpu::Features::PASSTHROUGH_SHADERS,
        ..Default::default()
    }))
    .unwrap();
    let owner = pollster::block_on(Renderer::new(device.clone(), queue, fixture::FORMAT)).unwrap();
    std::hint::black_box(&owner);
    fixture::counters(&device);
    // DHAT's end snapshot now includes this Renderer, external Device/Adapter/
    // Instance observers and driver state. It is neither a leak test nor RSS.
    std::process::exit(0);
}
