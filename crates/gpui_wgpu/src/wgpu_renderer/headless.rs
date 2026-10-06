use std::sync::Arc;
use std::time::{Duration, Instant};

use gpui::{AtlasTile, DevicePixels, Scene, Size};

use crate::{WgpuAtlas, WgpuContext};

use super::{FontRasterizationSettings, WgpuRenderer, WgpuSurfaceConfig};

struct OffscreenTarget {
    texture: wgpu::Texture,
    view: wgpu::TextureView,
    readback: wgpu::Buffer,
    padded_bytes_per_row: u32,
    size: Size<DevicePixels>,
}

impl WgpuRenderer {
    pub(super) fn new_headless(
        context: &WgpuContext,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<Self> {
        let mut renderer = Self::new_internal(
            None,
            context,
            None,
            WgpuSurfaceConfig {
                size,
                transparent: false,
                preferred_present_mode: None,
            },
            None,
            None,
            Arc::new(WgpuAtlas::from_context(context)),
        )?;

        renderer.target.clear_color = wgpu::Color::BLACK;

        Ok(renderer)
    }

    fn create_offscreen_target(&self) -> OffscreenTarget {
        let width = self.target.width();
        let height = self.target.height();
        let padded_bytes_per_row = (width * 4).next_multiple_of(wgpu::COPY_BYTES_PER_ROW_ALIGNMENT);
        let texture = self
            .resources()
            .device
            .create_texture(&wgpu::TextureDescriptor {
                label: Some("gpui_offscreen_target"),
                size: wgpu::Extent3d {
                    width,
                    height,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format: self.target.format(),
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
                view_formats: &[],
            });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        let readback = self
            .resources()
            .device
            .create_buffer(&wgpu::BufferDescriptor {
                label: Some("gpui_offscreen_readback"),
                size: u64::from(padded_bytes_per_row) * u64::from(height),
                usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
                mapped_at_creation: false,
            });
        OffscreenTarget {
            texture,
            view,
            readback,
            padded_bytes_per_row,
            size: self.viewport_size(),
        }
    }

    fn read_offscreen_target(
        &self,
        target: &OffscreenTarget,
        submission: wgpu::SubmissionIndex,
    ) -> anyhow::Result<image::RgbaImage> {
        let width = target.size.width.0 as u32;
        let height = target.size.height.0 as u32;
        let bytes_per_row = width * 4;
        let (sender, receiver) = std::sync::mpsc::sync_channel(1);
        target
            .readback
            .slice(..)
            .map_async(wgpu::MapMode::Read, move |result| {
                let _ = sender.send(result);
            });
        self.resources()
            .device
            .poll(wgpu::PollType::Wait {
                submission_index: Some(submission),
                timeout: Some(Duration::from_secs(30)),
            })
            .map_err(|error| anyhow::anyhow!("failed to poll offscreen readback: {error}"))?;
        receiver
            .recv()
            .map_err(|error| anyhow::anyhow!("offscreen readback callback dropped: {error}"))?
            .map_err(|error| anyhow::anyhow!("failed to map offscreen readback: {error}"))?;

        let mapped = target.readback.slice(..).get_mapped_range();
        let mut pixels = Vec::with_capacity(bytes_per_row as usize * height as usize);
        for row in mapped.chunks_exact(target.padded_bytes_per_row as usize) {
            pixels.extend_from_slice(&row[..bytes_per_row as usize]);
        }
        drop(mapped);
        target.readback.unmap();
        normalize_readback_rgba(
            &mut pixels,
            self.target.format() == wgpu::TextureFormat::Bgra8Unorm,
            self.target.alpha_mode() == wgpu::CompositeAlphaMode::PreMultiplied,
        );
        image::RgbaImage::from_raw(width, height, pixels)
            .ok_or_else(|| anyhow::anyhow!("offscreen readback dimensions did not match its data"))
    }

    /// Renders through the normal scene path and reads back without presenting.
    pub fn render_to_image(&mut self, scene: &Scene) -> anyhow::Result<image::RgbaImage> {
        let target = self.create_offscreen_target();
        let submission = self
            .render_to_view_with_readback(scene, &target.view, target.readback_copy())
            .ok_or_else(|| anyhow::anyhow!("failed to render scene into the offscreen target"))?;
        self.read_offscreen_target(&target, submission)
    }
}

impl OffscreenTarget {
    fn readback_copy(&self) -> super::frame::ReadbackCopy<'_> {
        super::frame::ReadbackCopy {
            texture: &self.texture,
            buffer: &self.readback,
            bytes_per_row: self.padded_bytes_per_row,
            width: self.size.width.0 as u32,
            height: self.size.height.0 as u32,
        }
    }
}

/// Adapter facts and whether this device exposes command-encoder GPU timestamps.
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
    /// Whether encoder timestamp queries were enabled on the created device.
    pub gpu_timestamps_available: bool,
    /// Adapter capability reason when timestamps are unavailable.
    pub gpu_timestamps_unavailable_reason: Option<String>,
}

/// Measurements for one completed headless scene submission.
#[derive(Clone, Debug)]
pub struct GpuFrameMeasurement {
    /// CPU wall time from scene preparation through command encoding, queue submission, and
    /// completion wait. Excludes target setup, timestamp mapping, and pixel readback mapping.
    pub encode_submit_completion: Duration,
    /// Device timestamp interval around encoded scene rendering and final compositing.
    /// Excludes readback mapping and includes no CPU wait time.
    pub gpu_execution: Option<Duration>,
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

/// Surface-free renderer used by GPUI visual tests and benchmarks.
pub struct WgpuHeadlessRenderer {
    renderer: WgpuRenderer,
    target: Option<OffscreenTarget>,
    measurement_info: Option<GpuReplayInfo>,
    timestamp_resources: Option<TimestampResources>,
}

impl WgpuHeadlessRenderer {
    pub fn new() -> anyhow::Result<Self> {
        let context = WgpuContext::new_headless(None)?;
        let renderer = WgpuRenderer::new_headless(
            &context,
            Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        )?;
        Ok(Self {
            renderer,
            target: None,
            measurement_info: None,
            timestamp_resources: None,
        })
    }

    /// Creates a renderer that requests device timestamps when the selected adapter supports
    /// them. The non-measurement constructor never requests timestamp-query features.
    pub fn new_with_measurements() -> anyhow::Result<Self> {
        let (context, supports_timestamps) = WgpuContext::new_headless_with_optional_timestamps()?;
        let renderer = WgpuRenderer::new_headless(
            &context,
            Size {
                width: DevicePixels(1),
                height: DevicePixels(1),
            },
        )?;
        let info = replay_info(&renderer, supports_timestamps);
        let timestamp_resources = supports_timestamps.then(|| {
            TimestampResources::new(
                &renderer.resources().device,
                context.queue.get_timestamp_period(),
            )
        });
        Ok(Self {
            renderer,
            target: None,
            measurement_info: Some(info),
            timestamp_resources,
        })
    }

    fn ensure_target(&mut self, size: Size<DevicePixels>) -> anyhow::Result<()> {
        anyhow::ensure!(
            size.width.0 > 0 && size.height.0 > 0,
            "headless render target must have positive dimensions"
        );
        let limit = self
            .renderer
            .resources()
            .device
            .limits()
            .max_texture_dimension_2d;
        anyhow::ensure!(
            size.width.0 as u32 <= limit && size.height.0 as u32 <= limit,
            "headless target {size:?} exceeds adapter texture limit {limit}"
        );
        if self
            .target
            .as_ref()
            .is_some_and(|target| target.size == size)
        {
            return Ok(());
        }
        self.renderer.update_drawable_size(size);
        self.target = Some(self.renderer.create_offscreen_target());
        Ok(())
    }

    /// Renders through the normal submission path and waits for that work to finish.
    pub fn render_scene_and_wait(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<()> {
        self.ensure_target(size)?;
        let target = self.target.as_ref().expect("target was just ensured");
        let submission =
            super::frame::render_to_view(&mut self.renderer, scene, &target.view, None)
                .ok_or_else(|| anyhow::anyhow!("failed to render headless scene"))?;
        self.renderer
            .resources()
            .device
            .poll(wgpu::PollType::Wait {
                submission_index: Some(submission),
                timeout: Some(Duration::from_secs(30)),
            })
            .map_err(|error| anyhow::anyhow!("failed to wait for headless render: {error}"))?;
        Ok(())
    }

    /// Returns selected adapter and timestamp capability information for measurement mode.
    pub fn replay_info(&self) -> Option<&GpuReplayInfo> {
        self.measurement_info.as_ref()
    }

    /// Replaces the renderer atlas with the exact captured tile bitmaps and maps canonical
    /// capture texture indices onto freshly allocated GPU atlas tiles.
    pub fn load_capture(&mut self, capture: &gpui::SceneCapture) -> anyhow::Result<Scene> {
        let mut scene = capture.to_scene()?;
        self.renderer.update_transparency(true);
        self.renderer
            .set_font_rasterization_settings(FontRasterizationSettings::default());
        let tiles = self
            .renderer
            .sprite_atlas()
            .replace_with_captured_bitmaps(capture.bitmaps())?;
        for sprite in &mut scene.monochrome_sprites {
            sprite.tile = captured_tile(sprite.tile, &tiles)?;
        }
        for sprite in &mut scene.subpixel_sprites {
            sprite.tile = captured_tile(sprite.tile, &tiles)?;
        }
        for sprite in &mut scene.polychrome_sprites {
            sprite.tile = captured_tile(sprite.tile, &tiles)?;
        }
        scene.finish();
        Ok(scene)
    }

    /// Returns exact byte sizes for atlas, headless target, and readback resources. On macOS,
    /// also reports Metal's selected-device allocation size; this is not system-wide VRAM
    /// residency. Other backends report the process/device statistic as unavailable.
    pub fn owned_memory_usage(&self) -> GpuOwnedMemoryUsage {
        let atlas = self.renderer.sprite_atlas().backing_texture_bytes();
        let (target, readback) = self.target.as_ref().map_or((0, 0), |target| {
            (texture_bytes(&target.texture), target.readback.size())
        });
        let (process_device_memory_bytes, process_device_memory_source, unavailable_reason) =
            process_device_memory(&self.renderer);
        GpuOwnedMemoryUsage {
            atlas_backing_textures_bytes: atlas,
            headless_target_texture_bytes: target,
            readback_buffer_bytes: readback,
            measured_owned_bytes: atlas.saturating_add(target).saturating_add(readback),
            process_device_memory_bytes,
            process_device_memory_source,
            process_device_memory_unavailable_reason: unavailable_reason,
            measured_owned_scope: "live atlas backing textures + headless color target + readback buffer; excludes renderer intermediates and driver allocations",
        }
    }

    /// Encodes, submits, and waits for the scene, returning that CPU wall time and, when supported
    /// by the adapter, the GPU timestamp interval for render commands and final compositing.
    pub fn render_scene_measured(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<GpuFrameMeasurement> {
        self.ensure_target(size)?;
        let target = self.target.as_ref().expect("target was just ensured");
        let started = Instant::now();
        let submission = super::frame::render_to_view_measured(
            &mut self.renderer,
            scene,
            &target.view,
            None,
            self.timestamp_resources
                .as_ref()
                .map(|resources| resources.capture()),
        )
        .ok_or_else(|| anyhow::anyhow!("failed to render measured headless scene"))?;
        let device = self.renderer.resources().device.clone();
        device
            .poll(wgpu::PollType::Wait {
                submission_index: Some(submission),
                timeout: Some(Duration::from_secs(30)),
            })
            .map_err(|error| {
                anyhow::anyhow!("failed to wait for measured headless render: {error}")
            })?;
        let encode_submit_completion = started.elapsed();
        let gpu_execution = self
            .timestamp_resources
            .as_ref()
            .map(|resources| resources.read_duration(&device))
            .transpose()?;
        Ok(GpuFrameMeasurement {
            encode_submit_completion,
            gpu_execution,
        })
    }
}

fn process_device_memory(
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

fn replay_info(renderer: &WgpuRenderer, timestamps: bool) -> GpuReplayInfo {
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
            .then(|| "selected adapter does not expose TIMESTAMP_QUERY_INSIDE_ENCODERS".into()),
    }
}

fn captured_tile(tile: AtlasTile, tiles: &[AtlasTile]) -> anyhow::Result<AtlasTile> {
    let index = tile.texture_id.index as usize;
    let captured = tiles
        .get(index)
        .ok_or_else(|| anyhow::anyhow!("capture references missing atlas bitmap {index}"))?;
    anyhow::ensure!(
        captured.texture_id.kind == tile.texture_id.kind,
        "captured atlas bitmap {index} has a different texture kind"
    );
    Ok(*captured)
}

fn texture_bytes(texture: &wgpu::Texture) -> u64 {
    let size = texture.size();
    let bytes_per_pixel = match texture.format().block_copy_size(None) {
        Some(bytes) => u64::from(bytes),
        None => 0,
    };
    u64::from(size.width)
        .saturating_mul(u64::from(size.height))
        .saturating_mul(u64::from(size.depth_or_array_layers))
        .saturating_mul(bytes_per_pixel)
}

fn normalize_readback_rgba(pixels: &mut [u8], bgra: bool, premultiplied: bool) {
    for pixel in pixels.chunks_exact_mut(4) {
        if bgra {
            pixel.swap(0, 2);
        }
        if !premultiplied {
            continue;
        }
        let alpha = u16::from(pixel[3]);
        if alpha == 0 {
            pixel[..3].fill(0);
        } else {
            for channel in &mut pixel[..3] {
                *channel = ((u16::from(*channel) * 255 + alpha / 2) / alpha).min(255) as u8;
            }
        }
    }
}

struct TimestampResources {
    period_ns: f32,
    query_set: wgpu::QuerySet,
    resolve_buffer: wgpu::Buffer,
    readback_buffer: wgpu::Buffer,
}

impl TimestampResources {
    fn new(device: &wgpu::Device, period_ns: f32) -> Self {
        let query_set = device.create_query_set(&wgpu::QuerySetDescriptor {
            label: Some("gpui_frame_timestamps"),
            ty: wgpu::QueryType::Timestamp,
            count: 2,
        });
        let resolve_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("gpui_timestamp_resolve"),
            size: 16,
            usage: wgpu::BufferUsages::QUERY_RESOLVE | wgpu::BufferUsages::COPY_SRC,
            mapped_at_creation: false,
        });
        let readback_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("gpui_timestamp_readback"),
            size: 16,
            usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            mapped_at_creation: false,
        });
        Self {
            period_ns,
            query_set,
            resolve_buffer,
            readback_buffer,
        }
    }

    fn capture(&self) -> super::frame::TimestampCapture<'_> {
        super::frame::TimestampCapture {
            query_set: &self.query_set,
            resolve_buffer: &self.resolve_buffer,
            readback_buffer: &self.readback_buffer,
        }
    }

    fn read_duration(&self, device: &wgpu::Device) -> anyhow::Result<Duration> {
        let (sender, receiver) = std::sync::mpsc::sync_channel(1);
        self.readback_buffer
            .slice(..)
            .map_async(wgpu::MapMode::Read, move |result| {
                let _ = sender.send(result);
            });
        device
            .poll(wgpu::PollType::Wait {
                submission_index: None,
                timeout: Some(Duration::from_secs(30)),
            })
            .map_err(|error| anyhow::anyhow!("failed to poll timestamp readback: {error}"))?;
        receiver
            .recv()
            .map_err(|error| anyhow::anyhow!("timestamp readback callback dropped: {error}"))??;
        let mapped = self.readback_buffer.slice(..).get_mapped_range();
        let start = u64::from_ne_bytes(mapped[0..8].try_into().expect("timestamp is u64"));
        let end = u64::from_ne_bytes(mapped[8..16].try_into().expect("timestamp is u64"));
        drop(mapped);
        self.readback_buffer.unmap();
        anyhow::ensure!(
            self.period_ns.is_finite() && self.period_ns > 0.0,
            "invalid GPU timestamp period"
        );
        let elapsed_ns = end.wrapping_sub(start) as f64 * f64::from(self.period_ns);
        Ok(Duration::from_nanos(
            elapsed_ns.round().min(u64::MAX as f64) as u64,
        ))
    }
}

impl gpui::PlatformHeadlessRenderer for WgpuHeadlessRenderer {
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> anyhow::Result<image::RgbaImage> {
        self.ensure_target(size)?;
        let target = self.target.as_ref().expect("target was just ensured");
        let submission = self
            .renderer
            .render_to_view_with_readback(scene, &target.view, target.readback_copy())
            .ok_or_else(|| anyhow::anyhow!("failed to render headless scene"))?;
        self.renderer.read_offscreen_target(target, submission)
    }

    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> anyhow::Result<()> {
        self.ensure_target(size)?;
        let target = self.target.as_ref().expect("target was just ensured");
        anyhow::ensure!(
            self.renderer.render_to_view(scene, &target.view),
            "failed to render headless scene"
        );
        Ok(())
    }

    fn sprite_atlas(&self) -> Arc<dyn gpui::PlatformAtlas> {
        self.renderer.sprite_atlas().clone()
    }
}

#[cfg(test)]
mod tests {
    use super::normalize_readback_rgba;

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
}
