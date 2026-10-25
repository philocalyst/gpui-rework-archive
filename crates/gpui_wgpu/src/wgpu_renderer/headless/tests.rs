use super::{GpuReplayInfo, normalize_readback_rgba, timestamp_duration, timestamp_envelope};
use std::time::Duration;

#[test]
fn timestamp_duration_requires_a_valid_order_and_finite_range() {
    assert_eq!(
        timestamp_duration(100, 120, 2.5).unwrap(),
        Duration::from_nanos(50)
    );
    assert!(timestamp_duration(120, 100, 1.0).is_err());
    assert!(timestamp_duration(0, 1, 0.0).is_err());
    assert!(timestamp_duration(0, 1, f32::NAN).is_err());
    assert!(timestamp_duration(0, u64::MAX, f32::MAX).is_err());
}

#[test]
fn timestamp_envelope_contains_overlapping_passes_and_rejects_bad_pairs() {
    assert_eq!(
        timestamp_envelope([(100, 120), (110, 140), (90, 130)], 1.0).unwrap(),
        Some(Duration::from_nanos(50))
    );
    assert_eq!(timestamp_envelope([], 1.0).unwrap(), None);
    assert!(timestamp_envelope([(100, 120), (140, 130)], 1.0).is_err());
    assert!(timestamp_envelope([(100, 120)], f32::NAN).is_err());
}

#[test]
fn invalid_timestamp_data_disables_the_reported_capability_with_a_reason() {
    let mut info = GpuReplayInfo {
        adapter_name: "test adapter".into(),
        driver: "test driver".into(),
        backend: "test backend".into(),
        device_type: "CPU".into(),
        gpu_timestamps_available: true,
        gpu_timestamps_unavailable_reason: None,
    };
    info.disable_timestamps("invalid query data: GPU timestamp pass 0: end precedes start");

    assert!(!info.gpu_timestamps_available);
    assert_eq!(
        info.gpu_timestamps_unavailable_reason.as_deref(),
        Some(
            "GPU timestamp telemetry disabled: invalid query data: GPU timestamp pass 0: end precedes start"
        )
    );
}

#[test]
fn readback_conversion_swizzles_then_unpremultiplies_and_clears_zero_alpha_rgb() {
    let mut pixels = [16, 32, 64, 128, 200, 120, 40, 0];
    normalize_readback_rgba(&mut pixels, true, true);
    assert_eq!(pixels, [128, 64, 32, 128, 0, 0, 0, 0]);
}

#[test]
fn opaque_readback_only_swizzles_when_needed() {
    let mut pixels = [10, 20, 30, 255];
    normalize_readback_rgba(&mut pixels, true, false);
    assert_eq!(pixels, [30, 20, 10, 255]);
}

#[test]
fn owned_memory_uses_the_live_wgpu_allocator_report_when_available() {
    let renderer = match super::WgpuHeadlessRenderer::new() {
        Ok(renderer) => renderer,
        Err(error) => {
            eprintln!("skipping allocator report assertion without a GPU adapter: {error:#}");
            return;
        }
    };
    let device = renderer.renderer.resources().device.clone();
    let allocator_report = device.generate_allocator_report();
    let memory = renderer.owned_memory_usage();

    if let Some(report) = allocator_report {
        assert_eq!(
            memory.process_device_memory_bytes,
            Some(report.total_reserved_bytes)
        );
        assert_eq!(
            memory.process_device_memory_source,
            Some(
                "WGPU Device::generate_allocator_report().total_reserved_bytes; allocator backing memory blocks including unused capacity, excluding driver/global residency"
            )
        );
        assert_eq!(memory.process_device_memory_unavailable_reason, None);
    } else {
        #[cfg(target_os = "macos")]
        {
            use objc2_metal::MTLDevice;

            // SAFETY: This only reads the allocation counter from the selected Metal device
            // while both the WGPU device and HAL guard remain alive.
            if let Some(metal_device) = unsafe { device.as_hal::<wgpu::hal::api::Metal>() } {
                // Metal's shared-device counter can change between reads when another test
                // allocates resources. Check its capability and scope, not a racy equality.
                assert!(metal_device.raw_device().currentAllocatedSize() > 0);
                assert!(
                    memory
                        .process_device_memory_bytes
                        .is_some_and(|bytes| bytes > 0)
                );
                assert!(memory.process_device_memory_source.is_some_and(|source| {
                    source.starts_with("Metal MTLDevice.currentAllocatedSize")
                }));
                assert_eq!(memory.process_device_memory_unavailable_reason, None);
            } else {
                assert_eq!(memory.process_device_memory_bytes, None);
                assert!(memory.process_device_memory_unavailable_reason.is_some());
            }
        }
        #[cfg(not(target_os = "macos"))]
        {
            assert_eq!(memory.process_device_memory_bytes, None);
            assert_eq!(memory.process_device_memory_source, None);
            assert!(
                memory.process_device_memory_unavailable_reason.is_some(),
                "unsupported allocator and backend APIs need an explicit reason"
            );
        }
    }
}
