//! Charge startup admission outside the frozen owner-construction scope.
use gpui_gpu::wgpu;
use gpui_gpu_owner_fixture as fixture;
fn main() {
    let (_instance, adapter) = fixture::adapter();
    let mut hint = wgpu::Features::empty();
    let previous = allocation_counter::measure(|| {
        // Exact prior vendor hint, kept here only as the losing allocation control.
        if adapter.get_info().backend == wgpu::Backend::Vulkan {
            hint = adapter.features() & wgpu::Features::PASSTHROUGH_SHADERS;
        }
    });
    let expected = hint;
    let current = allocation_counter::measure(|| hint = adapter.shader_artifact_features());
    assert_eq!(hint, expected);
    for enabled in [false, true] {
        let (device, _queue) =
            pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
                required_features: if enabled {
                    hint
                } else {
                    wgpu::Features::empty()
                },
                ..Default::default()
            }))
            .unwrap();
        let mut profile = None;
        let queried = allocation_counter::measure(|| profile = device.shader_artifact_profile());
        println!("enabled={enabled},profile={profile:?},profile_allocations={queried:?}");
        assert_eq!(profile.is_some(), enabled);
    }
    println!("previous_hint={previous:?},current_hint={current:?}");
}
