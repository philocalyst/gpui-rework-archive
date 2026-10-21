use bytemuck::{Pod, Zeroable};
use gpui_canvas::{GlyphKey, GlyphMask, OutputProfile, PreparedDraw, PreparedScene, SdrMapping};
use std::{borrow::Cow, collections::HashMap};

const MAX_DRAWS: usize = 65_536;
const MAX_REFERENCES: usize = 4 * 1024 * 1024;
const MAX_PIXELS: usize = 16 * 1024 * 1024;
const MAX_ATLAS_SIDE: u32 = 2048;

#[derive(Debug)]
pub enum Error {
    Device(String),
    Shader(String),
    UnsupportedTarget(wgpu::TextureFormat),
    InvalidScene,
    Precision { draw: usize },
    ResourceLimit,
    AtlasFull,
}
impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "GPU renderer: {self:?}")
    }
}
impl std::error::Error for Error {}

#[repr(C)]
#[derive(Clone, Copy, Pod, Zeroable)]
struct DrawData {
    local: [f32; 4],
    inverse_x: [f32; 4],
    inverse_y: [f32; 4],
    clip: [f32; 4],
    color: [f32; 4],
    atlas: [u32; 4],
}
#[repr(C)]
#[derive(Clone, Copy, Pod, Zeroable)]
struct Globals {
    viewport: [u32; 4],
    clear: [f32; 4],
    mapping: [f32; 4],
}

#[derive(Clone, Copy, Debug, Default)]
pub struct Stats {
    pub submissions: u64,
    pub draws: usize,
    pub tile_references: usize,
    pub instance_upload_bytes: usize,
    pub mask_upload_bytes: usize,
    pub gpu_buffer_bytes: u64,
    pub atlas_bytes: u64,
    pub cpu_index_capacity_bytes: usize,
}

struct Buffer {
    handle: wgpu::Buffer,
    size: u64,
}
impl Buffer {
    fn new(device: &wgpu::Device, label: &'static str, size: u64, uniform: bool) -> Self {
        let usage = if uniform {
            wgpu::BufferUsages::UNIFORM
        } else {
            wgpu::BufferUsages::STORAGE
        };
        Self {
            handle: device.create_buffer(&wgpu::BufferDescriptor {
                label: Some(label),
                size,
                usage: usage | wgpu::BufferUsages::COPY_DST,
                mapped_at_creation: false,
            }),
            size,
        }
    }
    fn write(&mut self, device: &wgpu::Device, queue: &wgpu::Queue, bytes: &[u8]) {
        if bytes.len() as u64 > self.size {
            *self = Self::new(
                device,
                "scene data",
                (bytes.len() as u64).next_power_of_two(),
                false,
            );
        }
        if !bytes.is_empty() {
            queue.write_buffer(&self.handle, 0, bytes);
        }
    }
}

#[derive(Clone, Copy)]
struct Tile {
    x: u32,
    y: u32,
    width: u32,
    height: u32,
}
struct Atlas {
    texture: wgpu::Texture,
    view: wgpu::TextureView,
    side: u32,
    x: u32,
    y: u32,
    row_height: u32,
    entries: HashMap<GlyphKey, Tile>,
}
impl Atlas {
    fn new(device: &wgpu::Device, side: u32) -> Self {
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: Some("glyph coverage"),
            size: wgpu::Extent3d {
                width: side,
                height: side,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: wgpu::TextureFormat::R8Unorm,
            usage: wgpu::TextureUsages::TEXTURE_BINDING | wgpu::TextureUsages::COPY_DST,
            view_formats: &[],
        });
        let view = texture.create_view(&Default::default());
        Self {
            texture,
            view,
            side,
            x: 0,
            y: 0,
            row_height: 0,
            entries: HashMap::new(),
        }
    }
    fn insert(&mut self, queue: &wgpu::Queue, mask: GlyphMask<'_>) -> Option<usize> {
        if self.entries.contains_key(&mask.key) {
            return Some(0);
        }
        let (width, height) = (mask.width as u32, mask.height as u32);
        if width == 0 || height == 0 || width > self.side || height > self.side {
            return None;
        }
        let (mut x, mut y, mut row) = (self.x, self.y, self.row_height);
        if x + width > self.side {
            x = 0;
            y += row;
            row = 0;
        }
        if y + height > self.side {
            return None;
        }
        queue.write_texture(
            wgpu::TexelCopyTextureInfo {
                texture: &self.texture,
                mip_level: 0,
                origin: wgpu::Origin3d { x, y, z: 0 },
                aspect: wgpu::TextureAspect::All,
            },
            mask.coverage,
            wgpu::TexelCopyBufferLayout {
                offset: 0,
                bytes_per_row: Some(width),
                rows_per_image: Some(height),
            },
            wgpu::Extent3d {
                width,
                height,
                depth_or_array_layers: 1,
            },
        );
        self.x = x + width;
        self.y = y;
        self.row_height = row.max(height);
        self.entries.insert(
            mask.key,
            Tile {
                x,
                y,
                width,
                height,
            },
        );
        Some(mask.coverage.len())
    }
}

/// GPU-owned caches and one fullscreen tile compositor. It consumes canonical
/// scene records directly; no CPU image, MSAA image or float intermediate exists.
pub struct Renderer {
    device: wgpu::Device,
    queue: wgpu::Queue,
    format: wgpu::TextureFormat,
    pipeline: wgpu::RenderPipeline,
    layout: wgpu::BindGroupLayout,
    globals: Buffer,
    draws: Buffer,
    tiles: Buffer,
    indices: Buffer,
    atlas: Atlas,
    records: Vec<DrawData>,
    ranges: Vec<[u32; 2]>,
    references: Vec<u32>,
    cursors: Vec<u32>,
    stats: Stats,
}
impl Renderer {
    pub async fn request(
        adapter: &wgpu::Adapter,
        format: wgpu::TextureFormat,
    ) -> Result<Self, Error> {
        let (device, queue) = adapter
            .request_device(&wgpu::DeviceDescriptor {
                label: Some("GPUI"),
                ..Default::default()
            })
            .await
            .map_err(|error| Error::Device(error.to_string()))?;
        Self::new(device, queue, format).await
    }
    pub async fn new(
        device: wgpu::Device,
        queue: wgpu::Queue,
        format: wgpu::TextureFormat,
    ) -> Result<Self, Error> {
        if !matches!(
            format,
            wgpu::TextureFormat::Rgba8UnormSrgb
                | wgpu::TextureFormat::Bgra8UnormSrgb
                | wgpu::TextureFormat::Rgba16Float
        ) {
            return Err(Error::UnsupportedTarget(format));
        }
        let source = crate::shader::ui::WGSL_SOURCE
            .wgsl_source()
            .map_err(|error| Error::Shader(error.to_string()))?;
        let errors = device.push_error_scope(wgpu::ErrorFilter::Validation);
        let module = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("GPUI tile compositor"),
            source: wgpu::ShaderSource::Wgsl(Cow::Owned(source)),
        });
        let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
            label: Some("GPUI tile compositor"),
            layout: None,
            vertex: wgpu::VertexState {
                module: &module,
                entry_point: Some("vertex"),
                compilation_options: Default::default(),
                buffers: &[],
            },
            primitive: Default::default(),
            depth_stencil: None,
            multisample: Default::default(),
            fragment: Some(wgpu::FragmentState {
                module: &module,
                entry_point: Some("fragment"),
                compilation_options: Default::default(),
                targets: &[Some(wgpu::ColorTargetState {
                    format,
                    blend: None,
                    write_mask: wgpu::ColorWrites::ALL,
                })],
            }),
            multiview_mask: None,
            cache: None,
        });
        if let Some(error) = errors.pop().await {
            return Err(Error::Shader(error.to_string()));
        }
        let layout = pipeline.get_bind_group_layout(0);
        let globals = Buffer::new(&device, "globals", 48, true);
        let draws = Buffer::new(&device, "draws", 96, false);
        let tiles = Buffer::new(&device, "tiles", 8, false);
        let indices = Buffer::new(&device, "indices", 4, false);
        let atlas = Atlas::new(&device, 1);
        Ok(Self {
            device,
            queue,
            format,
            pipeline,
            layout,
            globals,
            draws,
            tiles,
            indices,
            atlas,
            records: Vec::new(),
            ranges: Vec::new(),
            references: Vec::new(),
            cursors: Vec::new(),
            stats: Stats::default(),
        })
    }
    pub fn device(&self) -> &wgpu::Device {
        &self.device
    }
    pub fn queue(&self) -> &wgpu::Queue {
        &self.queue
    }
    pub fn format(&self) -> wgpu::TextureFormat {
        self.format
    }
    pub fn stats(&self) -> Stats {
        self.stats
    }

    pub fn render(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        let pixels = (scene.width as usize)
            .checked_mul(scene.height as usize)
            .ok_or(Error::ResourceLimit)?;
        if target.texture().width() != scene.width || target.texture().height() != scene.height
            || target.texture().format() != self.format {
            return Err(Error::InvalidScene);
        }
        if pixels == 0
            || pixels > MAX_PIXELS
            || scene.width > 16_384
            || scene.height > 16_384
            || scene.draws().len() > MAX_DRAWS
        {
            return Err(Error::ResourceLimit);
        }
        if scene
            .clear
            .iter()
            .any(|value| !value.is_finite() || value.abs() > 1e20)
            || !(0.0..=1.0).contains(&scene.clear[3])
        {
            return Err(Error::InvalidScene);
        }
        let hdr = self.format == wgpu::TextureFormat::Rgba16Float;
        if !hdr && scene.clear[3] != 1.0 {
            return Err(Error::InvalidScene);
        }
        let (columns, rows) = (
            scene.width.div_ceil(16) as usize,
            scene.height.div_ceil(16) as usize,
        );
        self.ranges.clear();
        self.ranges.resize(columns * rows, [0, 0]);
        self.records.clear();
        let mut references = 0usize;
        for (index, draw) in scene.draws().enumerate() {
            validate_draw(draw, index, scene.width, scene.height)?;
            visit(draw, columns, |tile| self.ranges[tile][1] += 1);
            references = references
                .checked_add(tile_count(draw))
                .ok_or(Error::ResourceLimit)?;
            if references > MAX_REFERENCES {
                return Err(Error::ResourceLimit);
            }
        }
        let mask_bytes = self.prepare_atlas(scene)?;
        let mut offset = 0;
        for range in &mut self.ranges {
            let count = range[1];
            *range = [offset, offset + count];
            offset += count;
        }
        self.cursors.clear();
        self.cursors
            .extend(self.ranges.iter().map(|range| range[0]));
        self.references.clear();
        self.references.resize(references, 0);
        for (index, draw) in scene.draws().enumerate() {
            visit(draw, columns, |tile| {
                self.references[self.cursors[tile] as usize] = index as u32;
                self.cursors[tile] += 1;
            });
            let [a, b, c, d, tx, ty] = draw.inverse.map(|value| value as f32);
            let r = draw.local_rect;
            let clip = draw.clip;
            let atlas = draw.mask.map_or([0; 4], |mask| {
                let tile = self.atlas.entries[&mask.key];
                [tile.x, tile.y, tile.width, tile.height]
            });
            self.records.push(DrawData {
                local: [r.x, r.y, r.width, r.height],
                inverse_x: [a, c, tx, 0.0],
                inverse_y: [b, d, ty, 0.0],
                clip: [clip.x, clip.y, clip.x + clip.width, clip.y + clip.height],
                color: draw.color,
                atlas,
            });
        }
        let (tone, exposure) = match scene.color_config.mapping {
            SdrMapping::Clip => (0, 1.0),
            SdrMapping::ReinhardPerChannel { exposure }
                if exposure.is_finite() && exposure > 0.0 =>
            {
                (2, exposure)
            }
            _ => return Err(Error::InvalidScene),
        };
        let mode = u32::from(scene.color_config.profile == OutputProfile::DisplayP3)
            | tone
            | if hdr { 4 } else { 0 };
        let globals = Globals {
            viewport: [scene.width, scene.height, columns as u32, mode],
            clear: scene.clear,
            mapping: [exposure, 0.0, 0.0, 0.0],
        };
        self.queue
            .write_buffer(&self.globals.handle, 0, bytemuck::bytes_of(&globals));
        self.draws.write(
            &self.device,
            &self.queue,
            bytemuck::cast_slice(&self.records),
        );
        self.tiles.write(
            &self.device,
            &self.queue,
            bytemuck::cast_slice(&self.ranges),
        );
        self.indices.write(
            &self.device,
            &self.queue,
            bytemuck::cast_slice(&self.references),
        );
        let bindings = self.device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("GPUI scene"),
            layout: &self.layout,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: 0,
                    resource: self.globals.handle.as_entire_binding(),
                },
                wgpu::BindGroupEntry {
                    binding: 1,
                    resource: self.draws.handle.as_entire_binding(),
                },
                wgpu::BindGroupEntry {
                    binding: 2,
                    resource: self.tiles.handle.as_entire_binding(),
                },
                wgpu::BindGroupEntry {
                    binding: 3,
                    resource: self.indices.handle.as_entire_binding(),
                },
                wgpu::BindGroupEntry {
                    binding: 4,
                    resource: wgpu::BindingResource::TextureView(&self.atlas.view),
                },
            ],
        });
        let mut encoder = self
            .device
            .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                label: Some("GPUI frame"),
            });
        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("GPUI frame"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: target,
                    resolve_target: None,
                    depth_slice: None,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                        store: wgpu::StoreOp::Store,
                    },
                })],
                depth_stencil_attachment: None,
                timestamp_writes: None,
                occlusion_query_set: None,
                multiview_mask: None,
            });
            pass.set_pipeline(&self.pipeline);
            pass.set_bind_group(0, &bindings, &[]);
            pass.draw(0..3, 0..1);
        }
        let submitted = self.queue.submit([encoder.finish()]);
        self.stats = Stats {
            submissions: self.stats.submissions.saturating_add(1),
            draws: self.records.len(),
            tile_references: references,
            instance_upload_bytes: self.records.len() * 96
                + self.ranges.len() * 8
                + references * 4
                + 48,
            mask_upload_bytes: mask_bytes,
            gpu_buffer_bytes: self.globals.size
                + self.draws.size
                + self.tiles.size
                + self.indices.size,
            atlas_bytes: u64::from(self.atlas.side).pow(2),
            cpu_index_capacity_bytes: self.records.capacity() * 96
                + self.ranges.capacity() * 8
                + self.references.capacity() * 4
                + self.cursors.capacity() * 4,
        };
        Ok(submitted)
    }
    fn prepare_atlas(&mut self, scene: PreparedScene<'_>) -> Result<usize, Error> {
        let mut uploaded = 0;
        for draw in scene.draws() {
            if let Some(mask) = draw.mask {
                if let Some(bytes) = self.atlas.insert(&self.queue, mask) {
                    uploaded += bytes;
                } else {
                    let mut side = self.atlas.side.max(128);
                    loop {
                        side = (side * 2).min(MAX_ATLAS_SIDE);
                        let mut next = Atlas::new(&self.device, side);
                        let mut bytes = 0;
                        let mut fits = true;
                        for mask in scene.draws().filter_map(|draw| draw.mask) {
                            if let Some(size) = next.insert(&self.queue, mask) {
                                bytes += size;
                            } else {
                                fits = false;
                                break;
                            }
                        }
                        if fits {
                            self.atlas = next;
                            return Ok(uploaded + bytes);
                        }
                        if side == MAX_ATLAS_SIDE {
                            return Err(Error::AtlasFull);
                        }
                    }
                }
            }
        }
        Ok(uploaded)
    }
}

fn tile_count(draw: PreparedDraw<'_>) -> usize {
    let r = draw.bounds;
    ((r.x as usize + r.width as usize - 1) / 16 - r.x as usize / 16 + 1)
        * ((r.y as usize + r.height as usize - 1) / 16 - r.y as usize / 16 + 1)
}
fn visit(draw: PreparedDraw<'_>, columns: usize, mut visit: impl FnMut(usize)) {
    let r = draw.bounds;
    for y in r.y as usize / 16..=(r.y as usize + r.height as usize - 1) / 16 {
        for x in r.x as usize / 16..=(r.x as usize + r.width as usize - 1) / 16 {
            visit(y * columns + x);
        }
    }
}
fn validate_draw(
    draw: PreparedDraw<'_>,
    index: usize,
    width: u32,
    height: u32,
) -> Result<(), Error> {
    let b = draw.bounds;
    if !b.is_valid()
        || b.is_empty()
        || b.x < 0.0
        || b.y < 0.0
        || b.x + b.width > width as f32
        || b.y + b.height > height as f32
    {
        return Err(Error::InvalidScene);
    }
    let narrowed = draw.inverse.map(|value| value as f32);
    if narrowed.iter().any(|value| !value.is_finite()) {
        return Err(Error::Precision { draw: index });
    }
    // Bound coefficient narrowing plus shader multiply/add error in local
    // coordinates, then map that uncertainty back into device coordinates.
    let m = draw.inverse;
    let det = m[0] * m[3] - m[1] * m[2];
    if det == 0.0 || !det.is_finite() {
        return Err(Error::Precision { draw: index });
    }
    let x = f64::from(width);
    let y = f64::from(height);
    let error_x = (m[0] - f64::from(narrowed[0])).abs() * x
        + (m[2] - f64::from(narrowed[2])).abs() * y
        + (m[4] - f64::from(narrowed[4])).abs();
    let error_y = (m[1] - f64::from(narrowed[1])).abs() * x
        + (m[3] - f64::from(narrowed[3])).abs() * y
        + (m[5] - f64::from(narrowed[5])).abs();
    let arithmetic = 8.0
        * f64::from(f32::EPSILON)
        * (m[0].abs() * x
            + m[2].abs() * y
            + m[4].abs()
            + m[1].abs() * x
            + m[3].abs() * y
            + m[5].abs()
            + 1.0);
    let error = (error_x + error_y + arithmetic)
        * (m[0].abs() + m[1].abs() + m[2].abs() + m[3].abs())
        / det.abs();
    if !error.is_finite() || error > 1.0 / 32.0 {
        return Err(Error::Precision { draw: index });
    }
    Ok(())
}
