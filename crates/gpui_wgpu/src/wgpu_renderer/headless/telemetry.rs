//! Completed-frame measurements and explicitly scoped allocation metadata.
use super::*;

/// Adapter facts and whether render-pass GPU timestamps remain usable.
#[derive(Clone, Debug)]
pub struct GpuReplayInfo {
    /// Selected adapter name.
    pub adapter_name: String,
    /// Adapter-reported driver name and version.
    pub driver: String,
    /// Backend selected by WGPU.
    pub backend: String,
    /// WGPU adapter class, such as discrete, integrated, or CPU.
    pub device_type: String,
    /// Whether render-pass timestamp queries remain enabled and have returned valid data.
    pub gpu_timestamps_available: bool,
    /// Why timestamps are unavailable or were disabled after invalid data or capacity limits.
    pub gpu_timestamps_unavailable_reason: Option<String>,
}

impl GpuReplayInfo {
    pub(super) fn disable_timestamps(&mut self, error: impl std::fmt::Display) {
        self.gpu_timestamps_available = false;
        self.gpu_timestamps_unavailable_reason =
            Some(format!("GPU timestamp telemetry disabled: {error}"));
    }
}

/// Measurements for one completed headless scene submission.
#[derive(Clone, Debug)]
pub struct GpuFrameMeasurement {
    /// CPU wall time from scene preparation through command encoding, queue submission, and
    /// completion wait. Excludes target setup, timestamp mapping, and pixel readback mapping.
    pub encode_submit_completion: Duration,
    /// Device timestamp envelope from the earliest start to the latest end across actual scene
    /// render passes (including path rasterization, filters, and offscreen compositing). It spans
    /// gaps or overlap between passes and excludes readback mapping and CPU wait time. It is `None`
    /// when timestamps are unsupported or disabled, or the scene submits no drawable pass.
    pub gpu_execution: Option<Duration>,
    /// Resolution of the adapter's timestamp counter, rounded up to whole nanoseconds.
    pub gpu_timestamp_resolution: Option<Duration>,
}

/// Exact sizes of selected renderer-owned resources, not driver VRAM usage.
#[derive(Clone, Debug, Default, PartialEq, Eq)]
pub struct GpuOwnedMemoryUsage {
    /// Sum of currently live atlas backing texture extents by format.
    pub atlas_backing_textures_bytes: u64,
    /// Size of the single headless render target texture, or zero before allocation.
    pub headless_target_texture_bytes: u64,
    /// Size of the readback buffer, or zero before target allocation.
    pub readback_buffer_bytes: u64,
    /// Sum of the three fields above. Excludes internal WGPU allocations, pipelines,
    /// intermediate filter/path textures, allocator padding, and driver bookkeeping.
    pub measured_owned_bytes: u64,
    /// Allocator/device allocation value; its precise scope is specified in the source field.
    pub process_device_memory_bytes: Option<u64>,
    /// Platform API and scope of `process_device_memory_bytes`, when available.
    pub process_device_memory_source: Option<&'static str>,
    /// Why process/device allocation telemetry is unavailable on the selected backend.
    pub process_device_memory_unavailable_reason: Option<String>,
    /// Exact subset included by `measured_owned_bytes`.
    pub measured_owned_scope: &'static str,
}

pub(super) fn process_device_memory(
    renderer: &WgpuRenderer,
) -> (Option<u64>, Option<&'static str>, Option<String>) {
    let (device, _) = renderer.gpu_context();
    if let Some(report) = device.generate_allocator_report() {
        return (
            Some(report.total_reserved_bytes),
            Some(
                "WGPU Device::generate_allocator_report().total_reserved_bytes; allocator backing memory blocks including unused capacity, excluding driver/global residency",
            ),
            None,
        );
    }

    #[cfg(target_os = "macos")]
    return process_device_memory_metal(&device);

    #[cfg(not(target_os = "macos"))]
    (
        None,
        None,
        Some(
            "WGPU allocator report unavailable and no backend allocation query is implemented"
                .into(),
        ),
    )
}

#[cfg(target_os = "macos")]
fn process_device_memory_metal(
    device: &wgpu::Device,
) -> (Option<u64>, Option<&'static str>, Option<String>) {
    use objc2_metal::MTLDevice;

    // SAFETY: We only borrow the selected Metal device while the WGPU `Device` and returned HAL
    // guard are alive. The callback performs a read-only size query and neither mutates nor
    // destroys any HAL or Metal resource.
    let Some(metal_device) = (unsafe { device.as_hal::<wgpu::hal::api::Metal>() }) else {
        return (
            None,
            None,
            Some(
                "WGPU selected a non-Metal device, so Metal allocation telemetry is unavailable"
                    .into(),
            ),
        );
    };
    let bytes = metal_device.raw_device().currentAllocatedSize() as u64;
    (
        Some(bytes),
        Some(
            "Metal MTLDevice.currentAllocatedSize; resources on this shared device (unified-memory allocation, not system-wide VRAM residency)",
        ),
        None,
    )
}

pub(super) fn replay_info(renderer: &WgpuRenderer, timestamps: bool) -> GpuReplayInfo {
    let info = renderer
        .gpu_context_info()
        .expect("headless context is available");
    let adapter = info.adapter_info();
    GpuReplayInfo {
        adapter_name: adapter.name.clone(),
        driver: format!("{} {}", adapter.driver, adapter.driver_info),
        backend: format!("{:?}", info.backend()),
        device_type: format!("{:?}", adapter.device_type),
        gpu_timestamps_available: timestamps,
        gpu_timestamps_unavailable_reason: (!timestamps)
            .then(|| "selected adapter does not expose TIMESTAMP_QUERY".into()),
    }
}
