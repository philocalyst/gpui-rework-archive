use bytemuck::{Pod, Zeroable};
use gpui_canvas::{
    GlyphKey, GlyphMask, OutputProfile, PixelFormat, PreparedDraw, PreparedScene, SdrMapping,
};
use std::{borrow::Cow, collections::HashMap};

const MAX_DRAWS: usize = 65_536;
const MAX_REFERENCES: usize = 4 * 1024 * 1024;
const MAX_PIXELS: usize = 16 * 1024 * 1024;
const MAX_ATLAS_SIDE: u32 = 2048;
const UNIFORM_TILE: u32 = 1 << 31;
const _: () = assert!(MAX_REFERENCES < UNIFORM_TILE as usize);
const _: () = assert!(MAX_DRAWS < UNIFORM_TILE as usize);

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
#[repr(C)]
#[derive(Clone, Copy, Pod, Zeroable)]
struct Correction {
    x: [f32; 4],
    y: [f32; 4],
}

#[derive(Clone, Copy, Debug, Default)]
pub struct Stats {
    pub submissions: u64,
    pub draws: usize,
    pub tile_references: usize,
    pub original_tile_references: usize,
    /// References omitted from the sampled CSR, including uniform tiles.
    pub skipped_tile_references: usize,
    pub uniform_tiles: usize,
    /// Planned lattice samples, excluding clear and certified uniform pixels.
    pub sample_evaluations: u64,
    /// Planned sample_draw calls, including calls rejected by clip/geometry.
    pub sample_draw_evaluations: u64,
    pub instance_upload_bytes: usize,
    pub mask_upload_bytes: usize,
    pub gpu_buffer_bytes: u64,
    pub atlas_bytes: u64,
    pub cpu_index_capacity_bytes: usize,
    pub correction_records: usize,
    /// Hash-table entry capacity, excluding its allocator/control-byte overhead.
    pub correction_key_capacity: usize,
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
    corrections: Buffer,
    atlas: Atlas,
    records: Vec<DrawData>,
    ranges: Vec<[u32; 2]>,
    references: Vec<u32>,
    cursors: Vec<u32>,
    residuals: Vec<Correction>,
    residual_keys: HashMap<[u32; 8], u32>,
    tile_proofs: bool,
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
        let corrections = Buffer::new(&device, "inverse residuals", 32, false);
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
            corrections,
            atlas,
            records: Vec::new(),
            ranges: Vec::new(),
            references: Vec::new(),
            cursors: Vec::new(),
            residuals: Vec::new(),
            residual_keys: HashMap::new(),
            tile_proofs: true,
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
    /// Disable only the disposable tile proofs for reference comparisons.
    pub fn set_tile_proofs(&mut self, enabled: bool) {
        self.tile_proofs = enabled;
    }

    pub fn render(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        scene
            .color_config
            .validate()
            .map_err(|_| Error::InvalidScene)?;
        let pixels = (scene.width as usize)
            .checked_mul(scene.height as usize)
            .ok_or(Error::ResourceLimit)?;
        if target.texture().width() != scene.width
            || target.texture().height() != scene.height
            || target.texture().format() != self.format
        {
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
        if hdr != (scene.color_config.format == PixelFormat::Rgba16Float) {
            return Err(Error::InvalidScene);
        }
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
        let mut original_references = 0usize;
        for (index, draw) in scene.draws().enumerate() {
            let error = validate_draw(draw, index, scene.width, scene.height)?;
            let mut record = DrawData::zeroed();
            record.inverse_x[3] = error[0];
            record.inverse_y[3] = error[1];
            self.records.push(record);
            visit(draw, columns, |tile| {
                if self.tile_proofs
                    && full_tile(draw, error, tile, columns, scene.width, scene.height)
                {
                    self.ranges[tile] = [index as u32 + 1, 1];
                } else {
                    self.ranges[tile][1] += 1;
                }
            });
            original_references = original_references
                .checked_add(tile_count(draw))
                .ok_or(Error::ResourceLimit)?;
            if original_references > MAX_REFERENCES {
                return Err(Error::ResourceLimit);
            }
        }
        let mask_bytes = self.prepare_atlas(scene)?;
        let mut offset = 0;
        self.cursors.clear();
        for range in &mut self.ranges {
            let cutoff = range[0];
            self.cursors.push(cutoff);
            let count = range[1];
            if cutoff != 0 && count == 1 {
                *range = [cutoff - 1, UNIFORM_TILE];
            } else {
                offset += count;
                // Filled backward in painter order. The first word becomes
                // the start offset; the second stays the exclusive end.
                *range = [offset, offset];
            }
        }
        let references = offset as usize;
        self.references.clear();
        self.references.resize(references, 0);
        self.residuals.clear();
        self.residuals.push(Correction::zeroed());
        self.residual_keys.clear();
        for (index, draw) in scene.draws().enumerate() {
            let [a, b, c, d, tx, ty] = draw.inverse.map(|value| value as f32);
            let clip = draw.clip;
            let low = std::array::from_fn::<_, 8, _>(|i| match i {
                0..6 => (draw.inverse[i] - f64::from(draw.inverse[i] as f32)) as f32,
                6 => clip_residual(clip.x, clip.width),
                _ => clip_residual(clip.y, clip.height),
            });
            let key = low.map(f32::to_bits);
            let correction = if low.iter().all(|v| *v == 0.0) {
                0
            } else {
                *self.residual_keys.entry(key).or_insert_with(|| {
                    let slot = self.residuals.len() as u32;
                    self.residuals.push(Correction {
                        x: [low[0], low[2], low[4], low[6]],
                        y: [low[1], low[3], low[5], low[7]],
                    });
                    slot
                })
            };
            let r = draw.local_rect;
            let atlas = draw.mask.map_or([0; 4], |mask| {
                let tile = self.atlas.entries[&mask.key];
                [tile.x, tile.y, tile.width | (tile.height << 16), 0]
            });
            let error_x = self.records[index].inverse_x[3];
            let error_y = self.records[index].inverse_y[3];
            self.records[index] = DrawData {
                local: [r.x, r.y, r.width, r.height],
                inverse_x: [a, c, tx, error_x],
                inverse_y: [b, d, ty, error_y],
                clip: [clip.x, clip.y, clip.width, clip.height],
                color: draw.color,
                atlas: [atlas[0], atlas[1], atlas[2], correction],
            };
        }
        for (index, draw) in scene.draws().enumerate().rev() {
            visit(draw, columns, |tile| {
                let range = &mut self.ranges[tile];
                if range[1] != UNIFORM_TILE && index as u32 + 1 >= self.cursors[tile] {
                    range[0] -= 1;
                    self.references[range[0] as usize] = index as u32;
                }
            });
        }
        let mut uniform_tiles = 0;
        let mut sample_evaluations = 0;
        let mut sample_draw_evaluations = 0;
        for (tile, range) in self.ranges.iter().enumerate() {
            if range[1] == UNIFORM_TILE {
                uniform_tiles += 1;
            } else if range[0] != range[1] {
                let [left, top, right, bottom] =
                    tile_bounds(tile, columns, scene.width, scene.height);
                let samples = u64::from((right - left) * (bottom - top)) * 16;
                sample_evaluations += samples;
                sample_draw_evaluations += samples * u64::from(range[1] - range[0]);
            }
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
        self.corrections.write(
            &self.device,
            &self.queue,
            bytemuck::cast_slice(&self.residuals),
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
                wgpu::BindGroupEntry {
                    binding: 5,
                    resource: self.corrections.handle.as_entire_binding(),
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
            original_tile_references: original_references,
            skipped_tile_references: original_references - references,
            uniform_tiles,
            sample_evaluations,
            sample_draw_evaluations,
            instance_upload_bytes: self.records.len() * 96
                + self.ranges.len() * 8
                + references * 4
                + self.residuals.len() * 32
                + 48,
            mask_upload_bytes: mask_bytes,
            correction_records: self.residuals.len(),
            correction_key_capacity: self.residual_keys.capacity(),
            gpu_buffer_bytes: self.globals.size
                + self.draws.size
                + self.tiles.size
                + self.indices.size
                + self.corrections.size,
            atlas_bytes: u64::from(self.atlas.side).pow(2),
            cpu_index_capacity_bytes: self.records.capacity() * 96
                + self.ranges.capacity() * 8
                + self.references.capacity() * 4
                + self.cursors.capacity() * 4
                + self.residuals.capacity() * 32,
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
fn clip_residual(start: f32, extent: f32) -> f32 {
    let rounded = start + extent;
    if rounded.is_finite() {
        (f64::from(start) + f64::from(extent) - f64::from(rounded)) as f32
    } else {
        // A finite sample cannot equal an overflowing rounded clip endpoint.
        0.0
    }
}
fn tile_bounds(tile: usize, columns: usize, width: u32, height: u32) -> [u32; 4] {
    let left = (tile % columns) as u32 * 16;
    let top = (tile / columns) as u32 * 16;
    [left, top, (left + 16).min(width), (top + 16).min(height)]
}

// A certificate covers every lattice sample, independently in canonical f64
// and in the packed-high f32 shader path. It never assumes DD/f64 equivalence.
fn full_tile(
    draw: PreparedDraw<'_>,
    error: [f32; 2],
    tile: usize,
    columns: usize,
    width: u32,
    height: u32,
) -> bool {
    if draw.mask.is_some()
        || draw.color[3] != 1.0
        // Source-over can change -0 to +0 according to the backdrop's sign.
        // Such a draw is not a backdrop-independent byte value on float targets.
        || draw.color.iter().any(|v| v.to_bits() == (-0.0_f32).to_bits())
    {
        return false;
    }
    let [left, top, right, bottom] = tile_bounds(tile, columns, width, height);
    let clip = draw.clip;
    // The continuous tile is contained. Actual samples stay 1/8 pixel inside
    // its max edges, so the clip's rounded endpoint is never ambiguous here.
    if f64::from(clip.x) > f64::from(left)
        || f64::from(clip.y) > f64::from(top)
        || f64::from(clip.x) + f64::from(clip.width) < f64::from(right)
        || f64::from(clip.y) + f64::from(clip.height) < f64::from(bottom)
    {
        return false;
    }
    let m = draw.inverse;
    let high = m.map(|v| f64::from(v as f32));
    let r = draw.local_rect;
    for y in [f64::from(top) + 0.125, f64::from(bottom) - 0.125] {
        for x in [f64::from(left) + 0.125, f64::from(right) - 0.125] {
            for (axis, origin, extent) in [(0, r.x, r.width), (1, r.y, r.height)] {
                let origin = f64::from(origin);
                let extent = f64::from(extent);
                let packed = high[axis] * x + high[axis + 2] * y + high[axis + 4] - origin;
                // Covers raw dot, origin subtraction and extent subtraction,
                // with headroom for fusing/reordering. The additional shader
                // envelope keeps edges > error, excluding its DD branch.
                let rounding = 16.0
                    * f64::from(f32::EPSILON)
                    * (high[axis].abs() * x
                        + high[axis + 2].abs() * y
                        + high[axis + 4].abs()
                        + origin.abs()
                        + extent.abs()
                        + 1.0);
                let margin = rounding + f64::from(error[axis]);
                if packed <= margin || extent - packed <= margin {
                    return false;
                }
                let canonical = m[axis] * x + m[axis + 2] * y + m[axis + 4] - origin;
                let guard = 32.0
                    * f64::EPSILON
                    * (m[axis].abs() * x
                        + m[axis + 2].abs() * y
                        + m[axis + 4].abs()
                        + origin.abs()
                        + extent.abs()
                        + 1.0);
                if canonical <= guard || extent - canonical <= guard {
                    return false;
                }
            }
        }
    }
    true
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
) -> Result<[f32; 2], Error> {
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
    let local = draw.local_rect;
    let magnitude = m[0].abs() * x
        + m[2].abs() * y
        + m[4].abs()
        + m[1].abs() * x
        + m[3].abs() * y
        + m[5].abs()
        + f64::from(local.x).abs()
        + f64::from(local.y).abs()
        + f64::from(local.width).abs()
        + f64::from(local.height).abs();
    // Leave headroom for the split products, origin subtraction and division
    // correction. Finite coefficients alone do not imply finite shader math.
    if !magnitude.is_finite() || magnitude > f64::from(f32::MAX) / 32.0 {
        return Err(Error::Precision { draw: index });
    }
    if let Some(mask) = draw.mask {
        let scale_x = mask.width as f64 / f64::from(local.width);
        let scale_y = mask.height as f64 / f64::from(local.height);
        if !scale_x.is_finite()
            || !scale_y.is_finite()
            || scale_x > f64::from(f32::MAX) / 32.0
            || scale_y > f64::from(f32::MAX) / 32.0
            || magnitude * mask.width.max(mask.height) as f64 > f64::from(f32::MAX) / 32.0
        {
            return Err(Error::Precision { draw: index });
        }
    }
    let origin_error = 4.0
        * f64::from(f32::EPSILON)
        * (f64::from(local.x).abs()
            + f64::from(local.y).abs()
            + f64::from(local.width).abs()
            + f64::from(local.height).abs());
    let error = (error_x + error_y + arithmetic + origin_error)
        * (m[0].abs() + m[1].abs() + m[2].abs() + m[3].abs())
        / det.abs();
    if !error.is_finite() || error > 1.0 / 32.0 {
        return Err(Error::Precision { draw: index });
    }
    // Include subtraction of the local origin and comparison to its extent.
    // This controls the expensive correction path, not the admission ceiling.
    Ok([
        (error_x
            + arithmetic
            + 4.0
                * f64::from(f32::EPSILON)
                * (f64::from(local.x).abs() + f64::from(local.width).abs())) as f32,
        (error_y
            + arithmetic
            + 4.0
                * f64::from(f32::EPSILON)
                * (f64::from(local.y).abs() + f64::from(local.height).abs())) as f32,
    ])
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_canvas::Rect;

    #[test]
    fn storage_records_match_shader_stride_and_offsets() {
        assert_eq!(std::mem::size_of::<DrawData>(), 96);
        assert_eq!(std::mem::offset_of!(DrawData, inverse_x), 16);
        assert_eq!(std::mem::offset_of!(DrawData, inverse_y), 32);
        assert_eq!(std::mem::offset_of!(DrawData, atlas), 80);
        assert_eq!(std::mem::size_of::<Correction>(), 32);
        assert_eq!(std::mem::offset_of!(Correction, y), 16);
        assert_eq!(std::mem::size_of::<Globals>(), 48);
        let source = crate::shader::ui::WGSL_SOURCE.wgsl_source().unwrap();
        let module = wgpu::naga::front::wgsl::parse_str(&source).unwrap();
        assert_eq!(
            module
                .global_variables
                .iter()
                .filter(|(_, variable)| matches!(
                    variable.space,
                    wgpu::naga::AddressSpace::Storage { .. }
                ))
                .count(),
            4,
            "remain within the baseline four storage buffers per stage"
        );
        let mut layout = wgpu::naga::proc::Layouter::default();
        layout.update(module.to_ctx()).unwrap();
        for (name, size, offsets) in [
            ("Draw", 96, &[0, 16, 32, 48, 64, 80][..]),
            ("Globals", 48, &[0, 16, 32][..]),
            ("Correction", 32, &[0, 16][..]),
        ] {
            let (handle, ty) = module
                .types
                .iter()
                .find(|(_, ty)| ty.name.as_deref() == Some(name))
                .unwrap();
            assert_eq!(layout[handle].size, size);
            assert_eq!(
                layout[handle].alignment,
                wgpu::naga::proc::Alignment::SIXTEEN
            );
            let wgpu::naga::TypeInner::Struct { members, .. } = &ty.inner else {
                panic!("expected struct")
            };
            assert_eq!(
                members
                    .iter()
                    .map(|member| member.offset)
                    .collect::<Vec<_>>(),
                offsets
            );
        }
    }

    #[test]
    fn precision_admission_rejects_finite_but_overflowing_intermediates() {
        let mut draw = PreparedDraw {
            local_rect: Rect::new(0.0, 0.0, 1.0, 1.0),
            inverse: [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
            clip: Rect::new(0.0, 0.0, 1.0, 1.0),
            bounds: Rect::new(0.0, 0.0, 1.0, 1.0),
            color: [1.0; 4],
            mask: None,
        };
        assert!(validate_draw(draw, 7, 1, 1).is_ok());
        draw.inverse = [3e38, 0.0, 0.0, 3e38, 3e38, 3e38];
        assert!(matches!(
            validate_draw(draw, 7, 1, 1),
            Err(Error::Precision { draw: 7 })
        ));
        draw.inverse = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0];
        draw.local_rect.x = f32::MAX;
        assert!(matches!(
            validate_draw(draw, 7, 1, 1),
            Err(Error::Precision { draw: 7 })
        ));
    }

    #[test]
    fn certificates_imply_sample_membership_in_both_numeric_domains() {
        let mut accepted = 0;
        for n in 0..64 {
            let draw = PreparedDraw {
                local_rect: Rect::new(-8.0, -8.0, 16.0 + n as f32, 40.0),
                inverse: [1.0, n as f64 / 256.0, -0.3, 1.0, n as f64 / 8.0, 0.0],
                clip: Rect::new(0.0, 0.0, 16.0, 16.0),
                bounds: Rect::new(0.0, 0.0, 16.0, 16.0),
                color: [1.0; 4],
                mask: None,
            };
            let error = validate_draw(draw, 0, 16, 16).unwrap();
            if !full_tile(draw, error, 0, 1, 16, 16) {
                continue;
            }
            accepted += 1;
            for y in 0..64 {
                for x in 0..64 {
                    let (x, y) = (x as f32 * 0.25 + 0.125, y as f32 * 0.25 + 0.125);
                    for (axis, origin, extent) in
                        [(0, -8.0, draw.local_rect.width), (1, -8.0, 40.0)]
                    {
                        let m = draw.inverse;
                        let exact =
                            m[axis] * f64::from(x) + m[axis + 2] * f64::from(y) + m[axis + 4]
                                - f64::from(origin);
                        assert!(exact >= 0.0 && exact < f64::from(extent));
                        let high = m.map(|v| v as f32);
                        let separate =
                            high[axis] * x + high[axis + 2] * y + high[axis + 4] - origin;
                        let fused = high[axis]
                            .mul_add(x, high[axis + 2].mul_add(y, high[axis + 4]))
                            - origin;
                        for value in [separate, fused] {
                            assert!(value > error[axis] && extent - value > error[axis]);
                        }
                    }
                }
            }
        }
        assert!(accepted > 20, "exercise nontrivial successful certificates");
    }
}
