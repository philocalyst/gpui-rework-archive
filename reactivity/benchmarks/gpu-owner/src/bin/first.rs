//! First owner on an already-created device. No elapsed-time measurement.
use gpui_gpu::{GpuContext, Renderer, wgpu};
use gpui_gpu_owner_fixture as fixture;

fn capture<T>(device: &wgpu::Device, build: impl FnOnce() -> T) {
    let mut owner = None;
    fixture::counters(device);
    let construct = allocation_counter::measure(|| owner = Some(build()));
    println!(
        "construct={construct:?}; owner={},holder={}",
        size_of::<T>(),
        size_of_val(&owner)
    );
    fixture::counters(device);
    let release = allocation_counter::measure(|| drop(owner));
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    println!("release={release:?}");
    fixture::counters(device);
}
fn main() {
    let mode = std::env::args().nth(1).expect("context or renderer");
    let optional = std::env::args().nth(2).as_deref() != Some("no-feature");
    let (_instance, adapter) = fixture::adapter();
    // Matched default/reference/candidate device features. This fixture's
    // explicit device request is not a production backend-admission policy.
    let features = if optional {
        adapter.features() & wgpu::Features::PASSTHROUGH_SHADERS
    } else {
        wgpu::Features::empty()
    };
    let (device, queue) = pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
        required_features: features,
        ..Default::default()
    }))
    .unwrap();
    println!("enabled_features={features:?}; mode={mode}");
    match mode.as_str() {
        "context" => capture(&device, || {
            pollster::block_on(GpuContext::new(
                device.clone(),
                queue.clone(),
                fixture::FORMAT,
            ))
            .unwrap()
        }),
        "renderer" => capture(&device, || {
            pollster::block_on(Renderer::new(
                device.clone(),
                queue.clone(),
                fixture::FORMAT,
            ))
            .unwrap()
        }),
        _ => panic!("expected context or renderer"),
    }
}
