use std::cell::Cell;
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

mod telemetry;
mod timestamps;
pub use telemetry::{GpuFrameMeasurement, GpuOwnedMemoryUsage, GpuReplayInfo};
use telemetry::{process_device_memory, replay_info};
use timestamps::TimestampResources;
#[cfg(test)]
use timestamps::{timestamp_duration, timestamp_envelope};

/// Surface-free renderer used by GPUI visual tests and benchmarks.
pub struct WgpuHeadlessRenderer {
    renderer: WgpuRenderer,
    target: Option<OffscreenTarget>,
    measurement_info: Option<GpuReplayInfo>,
    timestamp_resources: Option<TimestampResources>,
}

impl WgpuHeadlessRenderer {
    /// Creates a surface-free renderer without GPU timestamp queries.
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
                2,
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

    fn disable_timestamp_measurement(&mut self, error: impl std::fmt::Display) {
        self.timestamp_resources = None;
        if let Some(info) = &mut self.measurement_info {
            info.disable_timestamps(error);
        }
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
        if let Some(resources) = &mut self.timestamp_resources {
            match super::frame::timestamp_query_capacity(scene).and_then(|capacity| {
                resources.ensure_capacity(&self.renderer.resources().device, capacity)
            }) {
                Ok(()) => resources.reset(),
                Err(error) => self.disable_timestamp_measurement(format!(
                    "scene exceeds available query capacity: {error:#}"
                )),
            }
        }
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
        let timestamp_result = self
            .timestamp_resources
            .as_ref()
            .map(|resources| {
                let duration = resources.read_duration(&device)?;
                if let Some(gpu) = duration {
                    anyhow::ensure!(
                        gpu <= encode_submit_completion.saturating_add(resources.resolution()),
                        "GPU timestamp interval {gpu:?} exceeds encode/submit/completion {encode_submit_completion:?}"
                    );
                }
                Ok::<_, anyhow::Error>(duration)
            })
            .transpose();
        let gpu_execution = match timestamp_result {
            Ok(duration) => duration.flatten(),
            Err(error) => {
                self.disable_timestamp_measurement(format!("invalid query data: {error:#}"));
                None
            }
        };
        let gpu_timestamp_resolution = self
            .timestamp_resources
            .as_ref()
            .map(TimestampResources::resolution);
        Ok(GpuFrameMeasurement {
            encode_submit_completion,
            gpu_execution,
            gpu_timestamp_resolution,
        })
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
mod tests;
