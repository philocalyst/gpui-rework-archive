use super::*;
use crate::lazy_indirect_qualification::{arm, assert_balanced, fixture};

#[test]
fn lazy_draw_pool_buffer_failure_and_unwind() {
    for backend in [wgt::Backends::NOOP, wgt::Backends::VULKAN] {
        for unwind in [false, true] {
            for stage in 1..=2 {
                let (global, device, events) = fixture(backend, true);
                let buffer = device
                    .create_buffer(&wgt::BufferDescriptor {
                        label: None,
                        size: 256,
                        usage: wgt::BufferUsages::INDIRECT,
                        mapped_at_creation: false,
                    })
                    .unwrap();
                drop(buffer);
                arm(
                    &events,
                    if unwind { 0 } else { stage },
                    if unwind { stage } else { 0 },
                );
                let draw = &device.ready_indirect_validation().unwrap().draw;
                let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                    create_buffer_and_bind_group(
                        device.raw(),
                        wgt::BufferUses::INDIRECT | wgt::BufferUses::STORAGE_READ_WRITE,
                        draw.dst_bind_group_layout.as_ref(),
                        None,
                        None,
                    )
                }));
                if unwind {
                    assert!(result.is_err());
                } else {
                    assert!(result.unwrap().is_err());
                }
                drop(device);
                drop(global);
                assert_balanced(&events);
            }
        }
    }
}

#[test]
fn lazy_draw_resources_return_pools_before_last_device_drop() {
    let (global, device, events) = fixture(wgt::Backends::VULKAN, true);
    drop(
        device
            .create_buffer(&wgt::BufferDescriptor {
                label: None,
                size: 256,
                usage: wgt::BufferUsages::INDIRECT,
                mapped_at_creation: false,
            })
            .unwrap(),
    );
    let weak = Arc::downgrade(&device);
    let mut resources = DrawResources::new(device.clone());
    resources.get_dst_subrange(16, &mut None).unwrap();
    resources.get_metadata_subrange(16, &mut None).unwrap();
    drop(device);
    drop(global);
    assert!(
        weak.upgrade().is_some(),
        "live DrawResources must retain Device"
    );
    drop(resources);
    assert!(
        weak.upgrade().is_none(),
        "pool return must precede final Device disposal"
    );
    assert_balanced(&events);
}
