//! Matched public owner/drop control for the numeric and layout-lease designs.
use gpui_gpu::{GpuContext, RendererState, wgpu};
use gpui_gpu_owner_fixture as fixture;

fn main() {
    let (_instance, adapter) = fixture::adapter();
    let (device, queue) = fixture::device(&adapter);
    let layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
        label: Some("clone-only allocation control"),
        entries: &[],
    });
    let mut clone = None;
    let cloned = allocation_counter::measure(|| clone = Some(layout.clone()));
    let released = allocation_counter::measure(|| drop(clone));
    assert_eq!(cloned.count_total, 0);
    assert_eq!(released.count_total, 0);
    println!("layout_clone={cloned:?}; nonfinal_clone_drop={released:?}");
    drop(layout);

    let context =
        pollster::block_on(GpuContext::new(device.clone(), queue, fixture::FORMAT)).unwrap();
    let state = RendererState::new(&context);
    println!(
        "headers:context={},state={}",
        size_of::<GpuContext>(),
        size_of::<RendererState>()
    );
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
