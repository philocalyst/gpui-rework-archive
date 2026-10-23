use bytemuck::{Pod, Zeroable};
use gpui_canvas::{
    GlyphKey, GlyphMask, OutputProfile, PixelFormat, PreparedDraw, PreparedGroup,
    PreparedPlacement, PreparedScene, SdrMapping,
};
use std::{borrow::Cow, collections::HashMap};
#[cfg(feature = "offline-shader")]
#[allow(unsafe_code)]
mod artifact;
mod images;
mod owned;
mod paint;
mod slots;
pub use images::ImageStats;
pub use paint::{GpuPaintCommit, GpuPaintEdit, PaintBinding, PaintError, PaintRenderer};
pub use slots::{GpuSlotCommit, SlotError};

const MAX_DRAWS: usize = 65_536;
const SHADER_SOURCE: &str = include_str!(concat!(env!("OUT_DIR"), "/ui.wgsl"));
const MAX_REFERENCES: usize = 4 * 1024 * 1024;
const MAX_PIXELS: usize = 16 * 1024 * 1024;
const MAX_ATLAS_SIDE: u32 = 2048;
const ROUNDED_SOURCE: u32 = 1 << 30;
const _: () = assert!(MAX_ATLAS_SIDE < ROUNDED_SOURCE);
const UNIFORM_TILE: u32 = 1 << 31;
const _: () = assert!(MAX_REFERENCES < UNIFORM_TILE as usize);
const _: () = assert!(MAX_DRAWS < UNIFORM_TILE as usize);

#[derive(Debug)]
pub enum Error {
    Device(String),
    Shader(String),
    UnsupportedTarget(wgpu::TextureFormat),
    InvalidScene,
    /// The mutable state belongs to a different context, even on the same device.
    IncompatibleContext,
    Precision {
        draw: usize,
    },
    ResourceLimit,
    AtlasFull,
}
impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "GPU renderer: {self:?}")
    }
}
impl std::error::Error for Error {}

fn validate_format(format: wgpu::TextureFormat) -> Result<(), Error> {
    match format {
        wgpu::TextureFormat::Rgba8UnormSrgb
        | wgpu::TextureFormat::Bgra8UnormSrgb
        | wgpu::TextureFormat::Rgba16Float => Ok(()),
        _ => Err(Error::UnsupportedTarget(format)),
    }
}

#[repr(C)]
#[derive(Clone, Copy, Pod, Zeroable)]
struct Globals {
    viewport: [u32; 4],
    clear: [f32; 4],
    exposure: f32,
    material_offset: u32,
    padding: [u32; 2],
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
    /// Last successful submission reused admitted topology/resources. A paint
    /// patch may have uploaded color words; instance_upload_bytes distinguishes it.
    pub packet_reused: bool,
    /// CPU validate_draw calls for the last successful submission, not GPU work.
    pub validated_draws: usize,
    /// Forward and reverse CSR draw-bound tile visits, before proof filtering.
    pub binning_tile_visits: usize,
    /// Bind groups created for the last successful submission (zero on replay/patch).
    pub bind_group_creations: usize,
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
    pub draw_record_bytes: usize,
    pub shared_groups: usize,
    /// Placements sharing common state with another placement.
    pub compact_draws: usize,
    /// Placements owning unshared common state; the legacy diagnostic name
    /// remains, but every placement now uses the same two-word schema.
    pub inline_draws: usize,
    pub mask_upload_bytes: usize,
    pub gpu_buffer_bytes: u64,
    pub atlas_bytes: u64,
    pub atlas_keys: usize,
    pub atlas_key_capacity: usize,
    pub cpu_index_capacity_bytes: usize,
    pub correction_records: usize,
    /// Hash-table entry capacity, excluding its allocator/control-byte overhead.
    pub correction_key_capacity: usize,
}

// Every placement points at two affine words and two material words. Separate
// planes make a multi-group transform one contiguous upload. Singleton packets
// still cost six words; sharing saves four words per repeated placement.
// The common address's high bit selects a paint-bank color, never another schema.
const _: () = assert!(MAX_DRAWS * 6 < SLOT_COLOR as usize);
const CORRECTION_BITS: u32 = 17;
const CORRECTION_MASK: u32 = (1 << CORRECTION_BITS) - 1;
const RESOURCE_BITS: u32 = 32 - CORRECTION_BITS;
const _: () = assert!(MAX_DRAWS <= CORRECTION_MASK as usize);
const _: () = assert!(MAX_ATLAS_SIDE < 1 << RESOURCE_BITS);
type Word = [u32; 4];

// Two stack-owned envelopes follow the physical packet bands. No shadow
// records, per-draw dirty tags, dirty collection or retained generation exists.
struct Changes(std::ops::Range<usize>);
impl Changes {
    fn new() -> Self {
        Self(usize::MAX..0)
    }
    fn replace<const N: usize>(&mut self, records: &mut [Word], start: usize, next: [Word; N]) {
        for (offset, next) in next.into_iter().enumerate() {
            let index = start + offset;
            if records[index] != next {
                self.0.start = self.0.start.min(index);
                self.0.end = self.0.end.max(index + 1);
                records[index] = next;
            }
        }
    }
    fn upload(&self, records: &[Word], buffer: &Buffer, queue: &wgpu::Queue) -> usize {
        if self.0.is_empty() {
            return 0;
        }
        let words = &records[self.0.clone()];
        queue.write_buffer(
            &buffer.handle,
            (self.0.start * 16) as u64,
            bytemuck::cast_slice(words),
        );
        words.len() * 16
    }
}
fn float_word(value: [f32; 4]) -> Word {
    value.map(f32::to_bits)
}
fn prepared<'a>(group: PreparedGroup<'a>, p: PreparedPlacement<'a>) -> PreparedDraw<'a> {
    PreparedDraw {
        local_rect: p.local_rect,
        inverse: group.inverse,
        clip: group.clip,
        bounds: p.bounds,
        color: group.color,
        source: p.source,
    }
}
fn common_words(draw: PreparedDraw<'_>, error: [f32; 2]) -> [Word; 4] {
    let [a, b, c, d, tx, ty] = draw.inverse.map(|v| v as f32);
    let clip = draw.clip;
    [
        float_word([a, c, tx, error[0]]),
        float_word([b, d, ty, error[1]]),
        float_word([clip.x, clip.y, clip.width, clip.height]),
        float_word(packet_color(draw)),
    ]
}

// Closed resource variants leave seventeen exact bits available. Mask y is an
// atlas coordinate; image y contains five flags. Rounded solids instead keep a
// full radius in y and a power-of-two scale in z, whose low 23 bits are zero.
// Decode restores the original resource words before any shader interpretation.
fn resource_words(mut resource: [u32; 3], common: u32, correction: u32) -> Word {
    debug_assert!(correction <= CORRECTION_MASK);
    if resource[0] == ROUNDED_SOURCE {
        debug_assert_eq!(resource[2] & CORRECTION_MASK, 0);
        resource[2] |= correction;
    } else {
        debug_assert!(resource[1] < 1 << RESOURCE_BITS);
        resource[1] |= correction << RESOURCE_BITS;
    }
    [resource[0], resource[1], resource[2], common]
}

// Image material has no tint/opacity port. Its otherwise unused solid-color
// lanes carry shape parameters under the closed image flag, without extending
// records or duplicating pixel resources. A future tinted rounded image needs
// an explicit extended material record, not another interpretation of these.
fn rounded_image(source: gpui_canvas::PreparedSource<'_>) -> bool {
    source.image().is_some() && source.corner_radius().is_some()
}
fn shape_word(source: gpui_canvas::PreparedSource<'_>, rect: gpui_canvas::Rect) -> Word {
    let radius = source
        .corner_radius()
        .expect("admitted rounded source")
        .min(rect.width * 0.5)
        .min(rect.height * 0.5);
    let scale = f32::from_bits((254 - (radius.to_bits() >> 23)) << 23);
    [radius.to_bits(), scale.to_bits(), 0, 0]
}
fn packet_color(draw: PreparedDraw<'_>) -> [f32; 4] {
    if rounded_image(draw.source) {
        shape_word(draw.source, draw.local_rect).map(f32::from_bits)
    } else {
        draw.color
    }
}
fn compact_group(group: PreparedGroup<'_>, enabled: bool) -> bool {
    enabled
        && group.placements().len() > 1
        && !group
            .placements()
            .next()
            .is_some_and(|p| rounded_image(p.source))
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
    fn reserve(&mut self, device: &wgpu::Device, bytes: usize) -> bool {
        if bytes as u64 > self.size {
            *self = Self::new(
                device,
                "scene data",
                (bytes as u64).next_power_of_two(),
                false,
            );
            return true;
        }
        false
    }
    fn write(&mut self, device: &wgpu::Device, queue: &wgpu::Queue, bytes: &[u8]) {
        self.reserve(device, bytes.len());
        if !bytes.is_empty() {
            queue.write_buffer(&self.handle, 0, bytes);
        }
    }
    fn binding<T>(&self, rows: &[T]) -> wgpu::BindingResource<'_> {
        // Runtime arrays require one element even when no shader path reads it.
        // Keep spare allocation capacity outside the shader's visible range.
        wgpu::BindingResource::Buffer(wgpu::BufferBinding {
            buffer: &self.handle,
            offset: 0,
            size: wgpu::BufferSize::new((rows.len().max(1) * size_of::<T>()) as u64),
        })
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

// A binding to this renderer's current buffers and atlas, not a second scene.
// Invalidate before any preparation can replace or overwrite those resources.
const BANK_PACKET: u32 = 1 << 31;
const SLOT_COLOR: u32 = 1 << 31;
const _: () = assert!(MAX_DRAWS + 1 < SLOT_COLOR as usize);
struct Packet {
    bindings: wgpu::BindGroup,
    size: [u32; 2],
}

impl Packet {
    fn dimensions(&self) -> [u32; 2] {
        [self.size[0] & !BANK_PACKET, self.size[1]]
    }
    fn banked(&self) -> bool {
        self.size[0] & BANK_PACKET != 0
    }
}
/// An independently owned context and its mutable packet/resources.
/// Use `GpuContext` and `RendererState` directly to share immutable GPU work.
pub struct Renderer {
    context: GpuContext,
    state: RendererState,
}

/// One device/queue and one compositor pipeline for a fixed format.
/// Borrow this owner for independent per-window `RendererState`s. There is no
/// pipeline map, per-draw reference counting, or process-wide GPU cache.
/// A different format requires a separate context. The queue must belong to
/// the device, as with WGPU's ordinary safe resource-creation API.
pub struct GpuContext {
    device: wgpu::Device,
    queue: wgpu::Queue,
    format: wgpu::TextureFormat,
    pipeline: wgpu::RenderPipeline,
    layout: wgpu::BindGroupLayout,
}
/// Independent buffers, glyph atlas, images, scratch and retained packet.
/// No context reference is retained. Resource leases remain safe if a context
/// is dropped first, but rendering requires the original live context.
/// One retained layout handle certifies the originating context. It is cloned
/// once at construction and released on drop; frame methods only borrow it.
/// Dropping a context first retains its layout until these states are dropped.
/// After device loss, retire that context and all its states together.
pub struct RendererState {
    layout: wgpu::BindGroupLayout,
    globals: Buffer,
    draws: Buffer,
    tiles: Buffer,
    indices: Buffer,
    corrections: Buffer,
    atlas: Atlas,
    images: Option<Box<images::Images>>,
    records: Vec<Word>,
    ranges: Vec<[u32; 2]>,
    references: Vec<u32>,
    cursors: Vec<u32>,
    residuals: Vec<Correction>,
    residual_keys: HashMap<[u32; 8], u32>,
    tile_proofs: bool,
    grouped_records: bool,
    stats: Stats,
    packet: Option<Packet>,
}
impl GpuContext {
    pub async fn request(
        adapter: &wgpu::Adapter,
        format: wgpu::TextureFormat,
    ) -> Result<Self, Error> {
        validate_format(format)?;
        let (device, queue) = adapter
            .request_device(&wgpu::DeviceDescriptor {
                label: Some("GPUI"),
                #[cfg(feature = "offline-shader")]
                required_features: adapter.shader_artifact_features(),
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
        validate_format(format)?;
        #[cfg(feature = "offline-shader")]
        let internal = device.push_error_scope(wgpu::ErrorFilter::Internal);
        #[cfg(feature = "offline-shader")]
        let memory = device.push_error_scope(wgpu::ErrorFilter::OutOfMemory);
        let errors = device.push_error_scope(wgpu::ErrorFilter::Validation);
        #[cfg(feature = "offline-shader")]
        let artifact = artifact::create(&device);
        #[cfg(not(feature = "offline-shader"))]
        let artifact = None::<(
            wgpu::ShaderModule,
            wgpu::ShaderModule,
            wgpu::BindGroupLayout,
            wgpu::PipelineLayout,
        )>;
        let (module, explicit) = match artifact {
            Some((module, fragment, layout, pipeline_layout)) => {
                (module, Some((fragment, layout, pipeline_layout)))
            }
            None => (
                device.create_shader_module(wgpu::ShaderModuleDescriptor {
                    label: Some("GPUI tile compositor"),
                    source: wgpu::ShaderSource::Wgsl(Cow::Borrowed(SHADER_SOURCE)),
                }),
                None,
            ),
        };
        let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
            label: Some("GPUI tile compositor"),
            layout: explicit
                .as_ref()
                .map(|(_, _, pipeline_layout)| pipeline_layout),
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
                module: explicit
                    .as_ref()
                    .map(|(fragment, _, _)| fragment)
                    .unwrap_or(&module),
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
        // A destroyed device can yield an invalid pipeline. Keep inferred
        // layout validation in the same scope instead of panicking afterward.
        // Each context must mint a fresh layout handle, including if this ever
        // uses explicit layouts. Sharing a BGL across contexts/formats would
        // invalidate the state/context identity certificate.
        // Keep this checked pipeline lookup on the explicit route too: after
        // device loss creation errors can be ignored by WGPU's scopes, while
        // this rejects the invalid pipeline instead of returning a dead owner.
        drop(explicit);
        let layout = pipeline.get_bind_group_layout(0);
        let error = errors.pop().await;
        #[cfg(feature = "offline-shader")]
        let error = {
            let memory = memory.pop().await;
            let internal = internal.pop().await;
            error.or(memory).or(internal)
        };
        if let Some(error) = error {
            return Err(Error::Shader(error.to_string()));
        }
        Ok(Self {
            device,
            queue,
            format,
            pipeline,
            layout,
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
    fn submit(
        &self,
        target: &wgpu::TextureView,
        bindings: &wgpu::BindGroup,
    ) -> wgpu::SubmissionIndex {
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
            pass.set_bind_group(0, bindings, &[]);
            pass.draw(0..3, 0..1);
        }
        self.queue.submit([encoder.finish()])
    }
}
impl RendererState {
    /// Create independent resources on a live context. Device health remains
    /// the caller's responsibility; this does not replace its loss callback.
    /// After loss WGPU may return invalid handles whose later use can panic
    /// through validation. Retire the context and its states on device loss.
    pub fn new(context: &GpuContext) -> Self {
        let device = &context.device;
        let globals = Buffer::new(device, "globals", 48, true);
        let draws = Buffer::new(device, "draws", 16, false);
        let tiles = Buffer::new(device, "tiles", 8, false);
        let indices = Buffer::new(device, "indices", 4, false);
        let corrections = Buffer::new(device, "inverse residuals", 32, false);
        let atlas = Atlas::new(device, 1);
        Self {
            layout: context.layout.clone(),
            globals,
            draws,
            tiles,
            indices,
            corrections,
            atlas,
            images: None,
            records: Vec::new(),
            ranges: Vec::new(),
            references: Vec::new(),
            cursors: Vec::new(),
            residuals: Vec::new(),
            residual_keys: HashMap::new(),
            tile_proofs: true,
            grouped_records: true,
            stats: Stats::default(),
            packet: None,
        }
    }
    fn check_context(&self, context: &GpuContext) -> Result<(), Error> {
        if self.layout != context.layout {
            return Err(Error::IncompatibleContext);
        }
        Ok(())
    }
    pub fn stats(&self) -> Stats {
        self.stats
    }
    pub fn image_stats(&self) -> Option<ImageStats> {
        self.images.as_ref().map(|images| images.stats())
    }
    /// Diagnostic sharing oracle: give every draw its own common state.
    pub fn set_grouped_records(&mut self, enabled: bool) {
        if self.grouped_records != enabled {
            self.packet = None;
            self.grouped_records = enabled;
        }
    }
    /// Disable only the disposable tile proofs for reference comparisons.
    pub fn set_tile_proofs(&mut self, enabled: bool) {
        if self.tile_proofs != enabled {
            self.packet = None;
            self.tile_proofs = enabled;
        }
    }

    /// Validate and prepare this borrowed scene on every call. Public scene
    /// headers are mutable, so no identity or repeated borrow implies reuse.
    /// A new attempt discards redraw eligibility even if scene admission fails.
    /// A wrong context is rejected before mutation and preserves the packet.
    /// The target must belong to this context's device; WGPU validates that
    /// inherited precondition, which its public TextureView API cannot query.
    pub fn render(
        &mut self,
        context: &GpuContext,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        self.check_context(context)?;
        let resident = self.packet.take().is_some();
        self.render_observed(context, scene, target, resident, |_, _, _, _| {})
    }
    fn render_observed(
        &mut self,
        context: &GpuContext,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
        resident: bool,
        mut group_ready: impl FnMut(usize, PreparedGroup<'_>, usize, bool),
    ) -> Result<wgpu::SubmissionIndex, Error> {
        self.check_context(context)?;
        self.packet = None;
        scene
            .color_config
            .validate()
            .map_err(|_| Error::InvalidScene)?;
        let pixels = (scene.width as usize)
            .checked_mul(scene.height as usize)
            .ok_or(Error::ResourceLimit)?;
        if target.texture().width() != scene.width
            || target.texture().height() != scene.height
            || target.texture().format() != context.format
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
        let hdr = context.format == wgpu::TextureFormat::Rgba16Float;
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
        let old_words = self.records.len();
        let bank_count = scene.paint_bank().len();
        if bank_count > MAX_DRAWS * 2 {
            return Err(Error::ResourceLimit);
        }
        let bank_words = slots::prefix_words(bank_count);
        // Prepared groups partition the already bounded draw iterator. Reserve
        // the common prefix once; placements remain a uniform two-word suffix.
        let common_count: usize = scene
            .groups()
            .map(|group| {
                if compact_group(group, self.grouped_records) {
                    1
                } else {
                    group.placements().len()
                }
            })
            .sum();
        let material_offset = common_count * 2;
        let placement_start = bank_words + material_offset * 2;
        let word_count = placement_start + scene.draws().len() * 2;
        self.records
            .try_reserve_exact(word_count.saturating_sub(old_words))
            .map_err(|_| Error::ResourceLimit)?;
        self.records.resize(word_count, [0; 4]);
        let mut common_changes = Changes::new();
        let mut placement_changes = Changes::new();
        slots::write_prefix(
            &mut self.records[..bank_words],
            scene,
            bank_count,
            &mut common_changes,
        );
        self.cursors.clear();
        self.cursors.resize(columns * rows, 0);
        self.residuals.clear();
        self.residuals.push(Correction::zeroed());
        self.residual_keys.clear();
        let mut original_references = 0usize;
        let mut has_masks = false;
        let mut ordinal = 0;
        let mut shared_groups = 0;
        let mut compact_draws = 0;
        let mut common_word = bank_words;
        let mut placement_word = placement_start;
        for group in scene.groups() {
            let compact = compact_group(group, self.grouped_records);
            group_ready(ordinal, group, common_word + material_offset + 1, compact);
            let mut shared_error = [0.0_f32; 2];
            if compact {
                for (offset, p) in group.placements().enumerate() {
                    let error = validate_draw(
                        prepared(group, p),
                        ordinal + offset,
                        scene.width,
                        scene.height,
                    )?;
                    shared_error[0] = shared_error[0].max(error[0]);
                    shared_error[1] = shared_error[1].max(error[1]);
                }
                shared_groups += 1;
                compact_draws += group.placements().len();
            }
            let group_word = common_word;
            for (offset, p) in group.placements().enumerate() {
                let draw = prepared(group, p);
                let error = if compact {
                    shared_error
                } else {
                    validate_draw(draw, ordinal, scene.width, scene.height)?
                };
                let common = if compact { group_word } else { common_word };
                if !compact || offset == 0 {
                    let mut words = common_words(draw, error);
                    if let Some(slot) = group.paint_slot() {
                        words[3] = [slots::color_word(bank_count, slot), 0, 0, 0];
                    }
                    common_changes.replace(&mut self.records, common_word, [words[0], words[1]]);
                    common_changes.replace(
                        &mut self.records,
                        common_word + material_offset,
                        [words[2], words[3]],
                    );
                    common_word += 2;
                }
                has_masks |= draw.source.mask().is_some();
                let r = draw.local_rect;
                let address = placement_word as u32;
                let common = common as u32
                    | if group.paint_slot().is_some() {
                        SLOT_COLOR
                    } else {
                        0
                    };
                placement_changes.replace(
                    &mut self.records,
                    placement_word,
                    [float_word([r.x, r.y, r.width, r.height])],
                );
                // Resource xyz remain untouched until final admission. Merge
                // only the common address now; no temporary correction encoding.
                let mut metadata = self.records[placement_word + 1];
                metadata[3] = common;
                placement_changes.replace(&mut self.records, placement_word + 1, [metadata]);
                placement_word += 2;
                original_references = self.bin_draw(
                    draw,
                    error,
                    address,
                    ordinal,
                    columns,
                    scene.width,
                    scene.height,
                    original_references,
                )?;
                ordinal += 1;
            }
        }
        debug_assert_eq!(
            (common_word, placement_word),
            (bank_words + material_offset, word_count)
        );
        let relocated = images::prepare(
            &context.device,
            &context.queue,
            &mut self.draws,
            &mut self.images,
            self.records.len(),
            scene,
        )?;
        let mask_bytes = self.prepare_atlas(context, scene, has_masks)?;
        let mut offset = 0;
        for (tile, range) in self.ranges.iter_mut().enumerate() {
            let count = range[1];
            if self.cursors[tile] != 0 && count == 1 {
                range[1] = UNIFORM_TILE;
            } else {
                offset += count;
                *range = [offset, offset];
            }
        }
        let references = offset as usize;
        self.references.clear();
        self.references.resize(references, 0);
        // Uniform placement strides need no per-draw address lane. Correction
        // handles are assigned here, so no temporary metadata crosses admission.
        let mut word = word_count;
        let mut reverse_ordinal = ordinal;
        for group in scene.groups().rev() {
            let correction = self.correction(group.inverse, group.clip);
            for p in group.placements().rev() {
                word -= 2;
                reverse_ordinal -= 1;
                // Resource preparation follows admission of every draw. Patch
                // coordinates at the same address needed for tile references,
                // preserving correction indices and private common addresses.
                let atlas = if let Some((image, sampling)) = p.source.image() {
                    let [offset, mut flags] = self
                        .images
                        .as_ref()
                        .unwrap()
                        .metadata(image.key(), sampling);
                    if rounded_image(p.source) {
                        flags |= images::ROUNDED;
                    }
                    [offset, flags, image.width() | (image.height() << 16)]
                } else if p.source.corner_radius().is_some() {
                    let [radius, scale, _, _] = shape_word(p.source, p.local_rect);
                    [ROUNDED_SOURCE, radius, scale]
                } else {
                    p.source.mask().map_or([0; 3], |mask| {
                        let t = self.atlas.entries[&mask.key];
                        [t.x, t.y, t.width | (t.height << 16)]
                    })
                };
                let metadata = self.records[word + 1];
                placement_changes.replace(
                    &mut self.records,
                    word + 1,
                    [resource_words(atlas, metadata[3], correction)],
                );
                let address = word as u32;
                visit(prepared(group, p), columns, |tile| {
                    let range = &mut self.ranges[tile];
                    if range[1] != UNIFORM_TILE && reverse_ordinal as u32 + 1 >= self.cursors[tile]
                    {
                        range[0] -= 1;
                        self.references[range[0] as usize] = address;
                    }
                });
            }
        }
        debug_assert_eq!((word, reverse_ordinal), (placement_start, 0));
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
            exposure,
            material_offset: material_offset as u32,
            padding: [0; 2],
        };
        context
            .queue
            .write_buffer(&self.globals.handle, 0, bytemuck::bytes_of(&globals));
        let grew = self.draws.reserve(&context.device, word_count * 16);
        let draw_upload_bytes = if !resident || old_words != word_count || relocated || grew {
            self.draws.write(
                &context.device,
                &context.queue,
                bytemuck::cast_slice(&self.records),
            );
            word_count * 16
        } else {
            // Merge only touching envelopes. Disjoint changes cost at most two
            // queue writes, independent of the number of changed placements.
            if common_changes.0.end == placement_changes.0.start {
                common_changes.0.end = placement_changes.0.end;
                placement_changes = Changes::new();
            }
            common_changes.upload(&self.records, &self.draws, &context.queue)
                + placement_changes.upload(&self.records, &self.draws, &context.queue)
        };
        self.tiles.write(
            &context.device,
            &context.queue,
            bytemuck::cast_slice(&self.ranges),
        );
        self.indices.write(
            &context.device,
            &context.queue,
            bytemuck::cast_slice(&self.references),
        );
        self.corrections.write(
            &context.device,
            &context.queue,
            bytemuck::cast_slice(&self.residuals),
        );
        let bindings = context
            .device
            .create_bind_group(&wgpu::BindGroupDescriptor {
                label: Some("GPUI scene"),
                layout: &context.layout,
                entries: &[
                    wgpu::BindGroupEntry {
                        binding: 0,
                        resource: self.globals.handle.as_entire_binding(),
                    },
                    wgpu::BindGroupEntry {
                        binding: 1,
                        resource: if self.images.is_some() {
                            // Packed image pixels follow the record prefix.
                            self.draws.handle.as_entire_binding()
                        } else {
                            self.draws.binding(&self.records)
                        },
                    },
                    wgpu::BindGroupEntry {
                        binding: 2,
                        resource: self.tiles.binding(&self.ranges),
                    },
                    wgpu::BindGroupEntry {
                        binding: 3,
                        resource: self.indices.binding(&self.references),
                    },
                    wgpu::BindGroupEntry {
                        binding: 4,
                        resource: wgpu::BindingResource::TextureView(&self.atlas.view),
                    },
                    wgpu::BindGroupEntry {
                        binding: 5,
                        resource: self.corrections.binding(&self.residuals),
                    },
                ],
            });
        let submitted = context.submit(target, &bindings);
        self.packet = Some(Packet {
            bindings,
            size: [
                scene.width | if bank_count != 0 { BANK_PACKET } else { 0 },
                scene.height,
            ],
        });
        self.stats = Stats {
            submissions: self.stats.submissions.saturating_add(1),
            packet_reused: false,
            validated_draws: ordinal,
            binning_tile_visits: original_references * 2,
            bind_group_creations: 1,
            draws: ordinal,
            draw_record_bytes: self.records.len() * 16,
            shared_groups,
            compact_draws,
            inline_draws: ordinal - compact_draws,
            tile_references: references,
            original_tile_references: original_references,
            skipped_tile_references: original_references - references,
            uniform_tiles,
            sample_evaluations,
            sample_draw_evaluations,
            instance_upload_bytes: draw_upload_bytes
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
            atlas_keys: self.atlas.entries.len(),
            atlas_key_capacity: self.atlas.entries.capacity(),
            cpu_index_capacity_bytes: self.records.capacity() * 16
                + self.ranges.capacity() * 8
                + self.references.capacity() * 4
                + self.cursors.capacity() * 4
                + self.residuals.capacity() * 32,
        };
        Ok(submitted)
    }
    /// Submit the last successfully prepared packet to a fresh target.
    ///
    /// This is explicit replay, not a cache keyed by a caller's scene or number.
    /// It skips all command/resource validation, binning, uploads and binding
    /// creation, but still clears and draws the complete target before submitting.
    /// It does not acknowledge OS presentation or preserve swapchain pixels.
    ///
    /// None means no eligible packet (new renderer, attempted render failure, or
    /// a changed diagnostic mode). A wrong-size/format target returns an error
    /// without mutating the valid packet; retrying with a valid target is allowed.
    /// As with render, the target must be an admissible view on this device.
    pub fn redraw(
        &mut self,
        context: &GpuContext,
        target: &wgpu::TextureView,
    ) -> Result<Option<wgpu::SubmissionIndex>, Error> {
        self.check_context(context)?;
        let Some(packet) = &self.packet else {
            return Ok(None);
        };
        if [target.texture().width(), target.texture().height()] != packet.dimensions()
            || target.texture().format() != context.format
        {
            return Err(Error::InvalidScene);
        }
        let submitted = context.submit(target, &packet.bindings);
        self.stats.submissions = self.stats.submissions.saturating_add(1);
        self.stats.packet_reused = true;
        self.stats.validated_draws = 0;
        self.stats.binning_tile_visits = 0;
        self.stats.bind_group_creations = 0;
        self.stats.instance_upload_bytes = 0;
        self.stats.mask_upload_bytes = 0;
        if let Some(images) = &mut self.images {
            images.redrawn();
        }
        Ok(Some(submitted))
    }

    fn correction(&mut self, inverse: [f64; 6], clip: gpui_canvas::Rect) -> u32 {
        let low = std::array::from_fn::<_, 8, _>(|i| match i {
            0..6 => (inverse[i] - f64::from(inverse[i] as f32)) as f32,
            6 => clip_residual(clip.x, clip.width),
            _ => clip_residual(clip.y, clip.height),
        });
        if low.iter().all(|v| *v == 0.0) {
            return 0;
        }
        let key = low.map(f32::to_bits);
        *self.residual_keys.entry(key).or_insert_with(|| {
            let slot = self.residuals.len() as u32;
            self.residuals.push(Correction {
                x: [low[0], low[2], low[4], low[6]],
                y: [low[1], low[3], low[5], low[7]],
            });
            slot
        })
    }
    #[allow(clippy::too_many_arguments)]
    fn bin_draw(
        &mut self,
        draw: PreparedDraw<'_>,
        error: [f32; 2],
        address: u32,
        ordinal: usize,
        columns: usize,
        width: u32,
        height: u32,
        previous: usize,
    ) -> Result<usize, Error> {
        let total = previous
            .checked_add(tile_count(draw))
            .ok_or(Error::ResourceLimit)?;
        if total > MAX_REFERENCES {
            return Err(Error::ResourceLimit);
        }
        visit(draw, columns, |tile| {
            if self.tile_proofs && full_tile(draw, error, tile, columns, width, height) {
                self.ranges[tile] = [address, 1];
                self.cursors[tile] = ordinal as u32 + 1;
            } else {
                self.ranges[tile][1] += 1;
            }
        });
        Ok(total)
    }
    fn prepare_atlas(
        &mut self,
        context: &GpuContext,
        scene: PreparedScene<'_>,
        has_masks: bool,
    ) -> Result<usize, Error> {
        if !has_masks {
            if self.atlas.side != 1 || self.atlas.entries.capacity() != 0 {
                // Submitted bind groups retain their texture leases in wgpu;
                // replacing our cache cannot invalidate an in-flight frame.
                self.atlas = Atlas::new(&context.device, 1);
            }
            return Ok(0);
        }
        let mut uploaded = 0;
        for mask in scene.masks() {
            if let Some(bytes) = self.atlas.insert(&context.queue, mask) {
                uploaded += bytes;
            } else {
                let mut side = self.atlas.side.max(128);
                loop {
                    side = (side * 2).min(MAX_ATLAS_SIDE);
                    let mut next = Atlas::new(&context.device, side);
                    let mut fits = true;
                    for mask in scene.masks() {
                        if let Some(bytes) = next.insert(&context.queue, mask) {
                            uploaded += bytes;
                        } else {
                            fits = false;
                            break;
                        }
                    }
                    if fits {
                        self.atlas = next;
                        return Ok(uploaded);
                    }
                    if side == MAX_ATLAS_SIDE {
                        return Err(Error::AtlasFull);
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
    if !draw.source.is_solid()
        || draw.color[3] != 1.0
        // Source-over can change -0 to +0 according to the backdrop's sign.
        // A negative subnormal may also flush to -0 before that addition.
        // Neither is a backdrop-independent byte value on float targets.
        || draw.color.iter().any(|v| v.is_sign_negative() && !v.is_normal())
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
    let mut rounded_arithmetic = 0.0;
    if let Some(radius) = draw.source.corner_radius() {
        if !radius.is_finite() || radius < 0.0 {
            return Err(Error::InvalidScene);
        }
        let radius = radius.min(local.width * 0.5).min(local.height * 0.5);
        // CPU admission is broader. GPUs may flush subnormals, and a two-float
        // distance calculation is not an arbitrary-precision cancellation
        // oracle. Limit the normalized operands, not merely their final square.
        // The largest admitted normalized pre-subtraction operand is 2^20;
        // products in the actual circle comparison are near unity.
        if radius < f32::MIN_POSITIVE || magnitude / f64::from(radius) > 1_048_576.0 {
            return Err(Error::Precision { draw: index });
        }
        // Reserve a conservative additional two-float arithmetic allowance
        // through the same local-to-device error ceiling. This bounds distance
        // reconstruction as well as the coordinate transform; it is not a
        // theorem that every backend classifies all circle ties like f64.
        rounded_arithmetic =
            4096.0 * f64::from(f32::EPSILON).powi(2) * (magnitude + f64::from(radius));
    }
    if let Some([width, height]) = draw.source.dimensions() {
        let scale_x = width as f64 / f64::from(local.width);
        let scale_y = height as f64 / f64::from(local.height);
        if !scale_x.is_finite()
            || !scale_y.is_finite()
            || scale_x > f64::from(f32::MAX) / 32.0
            || scale_y > f64::from(f32::MAX) / 32.0
            || magnitude * width.max(height) as f64 > f64::from(f32::MAX) / 32.0
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
    let error = (error_x + error_y + arithmetic + origin_error + rounded_arithmetic)
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
    fn packet_storage_ledger() {
        eprintln!(
            "ownership_storage,Renderer={},GpuContext={},RendererState={},LayoutLease={},SlotGuard={}",
            size_of::<Renderer>(),
            size_of::<GpuContext>(),
            size_of::<RendererState>(),
            size_of::<wgpu::BindGroupLayout>(),
            size_of::<GpuSlotCommit<'_, '_, '_>>()
        );
        eprintln!(
            "packet_storage,Renderer={},Stats={},Packet={},OptionPacket={},BindGroup={},Canvas={},PreparedScene={}",
            size_of::<Renderer>(),
            size_of::<Stats>(),
            size_of::<Packet>(),
            size_of::<Option<Packet>>(),
            size_of::<wgpu::BindGroup>(),
            size_of::<gpui_canvas::Canvas>(),
            size_of::<PreparedScene<'_>>()
        );
    }

    #[test]
    fn storage_records_match_shader_stride_and_offsets() {
        assert_eq!(std::mem::size_of::<Correction>(), 32);
        assert_eq!(std::mem::offset_of!(Correction, y), 16);
        assert_eq!(std::mem::size_of::<Globals>(), 48);
        assert_eq!(std::mem::offset_of!(Globals, exposure), 32);
        assert_eq!(std::mem::offset_of!(Globals, material_offset), 36);
        assert_eq!(
            SHADER_SOURCE,
            crate::shader::ui::WGSL_SOURCE.wgsl_source().unwrap()
        );
        let module = wgpu::naga::front::wgsl::parse_str(SHADER_SOURCE).unwrap();
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
        let (_, word_buffer) = module
            .global_variables
            .iter()
            .find(|(_, v)| v.binding.as_ref().is_some_and(|b| b.binding == 1))
            .unwrap();
        assert!(matches!(
            module.types[word_buffer.ty].inner,
            wgpu::naga::TypeInner::Array { stride: 16, .. }
        ));
        assert_eq!(size_of::<Word>(), 16);
        let mut layout = wgpu::naga::proc::Layouter::default();
        layout.update(module.to_ctx()).unwrap();
        for (name, size, offsets) in [
            ("Draw", 96, &[0, 16, 32, 48, 64, 80][..]),
            ("Globals", 48, &[0, 16, 32, 36][..]),
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
    fn word_writers_preserve_float_and_metadata_bits() {
        let mut canvas = gpui_canvas::Canvas::recording(16, 16, Default::default()).unwrap();
        canvas
            .fill_rect(
                Rect::new(0.0, 0.0, 16.0, 16.0),
                gpui_canvas::Affine::IDENTITY,
                Rect::new(0.0, 0.0, 16.0, 16.0),
                gpui_canvas::Color::linear_srgb(-0.0, -1e-40, 1e19, 1.0).unwrap(),
            )
            .unwrap();
        let scene = canvas.prepared_scene();
        let group = scene.groups().next().unwrap();
        let draw = scene.draws().next().unwrap();
        let error = [0.00001, 0.00002];
        let common = common_words(draw, error);
        assert_eq!(common[3], draw.color.map(f32::to_bits));
        assert_eq!(common[0][3], error[0].to_bits());
        assert_eq!(common[1][3], error[1].to_bits());
        assert_eq!(
            common[2],
            float_word([
                group.clip.x,
                group.clip.y,
                group.clip.width,
                group.clip.height
            ])
        );
    }

    #[test]
    fn change_envelopes_cover_exactly_the_first_through_last_changed_word() {
        for mask in 0u32..4096 {
            let mut records = [[0; 4]; 12];
            let expected: [Word; 12] = std::array::from_fn(|index| {
                if mask & (1 << index) == 0 {
                    [0; 4]
                } else {
                    [u32::MAX; 4]
                }
            });
            let mut changes = Changes::new();
            for index in (0..12).step_by(2) {
                changes.replace(&mut records, index, [expected[index], expected[index + 1]]);
            }
            assert_eq!(records, expected);
            if mask == 0 {
                assert!(changes.0.is_empty());
            } else {
                assert_eq!(
                    changes.0,
                    mask.trailing_zeros() as usize..(32 - mask.leading_zeros()) as usize
                );
            }
            let before = changes.0.clone();
            for index in 0..12 {
                changes.replace(&mut records, index, [expected[index]]);
            }
            assert_eq!(changes.0, before);
        }
    }

    #[test]
    fn resource_codec_restores_every_correction_index_and_resource_bit() {
        use wgsl_rs::std::vec4u;
        let common = SLOT_COLOR | 300_000;
        for correction in 0..=MAX_DRAWS as u32 {
            for resource in [
                [0, 0, 0],
                [2047, 2047, 2048 | (2048 << 16)],
                [images::IMAGE | 0x3fff_ffff, 31, 16_384 | (16_384 << 16)],
            ] {
                let word = resource_words(resource, common, correction);
                assert_eq!(word[3], common);
                let decoded =
                    crate::shader::ui::decode_resource(vec4u(word[0], word[1], word[2], word[3]));
                assert_eq!([decoded.x, decoded.y, decoded.z], resource);
                assert_eq!(decoded.w, correction);
            }
        }
        for exponent in 1..=254 {
            let radius = (exponent << 23) | 0x7f_ffff;
            let scale = (254 - exponent) << 23;
            for correction in [0, 1, 65_535, 65_536] {
                let resource = [ROUNDED_SOURCE, radius, scale];
                let word = resource_words(resource, common, correction);
                let decoded =
                    crate::shader::ui::decode_resource(vec4u(word[0], word[1], word[2], word[3]));
                assert_eq!([decoded.x, decoded.y, decoded.z], resource);
                assert_eq!(decoded.w, correction);
            }
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
            source: gpui_canvas::PreparedSource::Solid,
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
                source: gpui_canvas::PreparedSource::Solid,
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
    #[cfg(feature = "vulkan-tests")]
    #[test]
    fn packet_reference_cap_and_atlas_last_row_admission() {
        pollster::block_on(async {
            let mut desc = wgpu::InstanceDescriptor::new_without_display_handle();
            desc.backends = wgpu::Backends::VULKAN;
            let instance = wgpu::Instance::new(desc);
            let adapter = instance
                .request_adapter(&wgpu::RequestAdapterOptions {
                    force_fallback_adapter: true,
                    ..Default::default()
                })
                .await
                .unwrap();
            let context = GpuContext::request(&adapter, wgpu::TextureFormat::Rgba8UnormSrgb)
                .await
                .unwrap();
            let mut state = RendererState::new(&context);
            state.ranges.resize(1, [0, 0]);
            state.cursors.resize(1, 0);
            let draw = PreparedDraw {
                local_rect: Rect::new(0., 0., 1., 1.),
                inverse: [1., 0., 0., 1., 0., 0.],
                clip: Rect::new(0., 0., 1., 1.),
                bounds: Rect::new(0., 0., 1., 1.),
                color: [1.; 4],
                source: gpui_canvas::PreparedSource::Solid,
            };
            assert_eq!(
                state
                    .bin_draw(draw, [0.; 2], 0, MAX_DRAWS - 1, 1, 1, 1, MAX_REFERENCES - 1)
                    .unwrap(),
                MAX_REFERENCES
            );
            let before = (state.ranges.clone(), state.cursors.clone());
            for previous in [MAX_REFERENCES, usize::MAX] {
                assert!(matches!(
                    state.bin_draw(draw, [0.; 2], 0, 0, 1, 1, 1, previous),
                    Err(Error::ResourceLimit)
                ));
                assert_eq!((&state.ranges, &state.cursors), (&before.0, &before.1));
            }
            assert_eq!(
                tile_bounds(65_535, 1024, 16_384, 1024),
                [16_368, 1008, 16_384, 1024]
            );
            let mut fonts = gpui_canvas::TextSystem::bundled().unwrap();
            let run = fonts.shape("X", 18., None).unwrap();
            let mut canvas = gpui_canvas::Canvas::recording(32, 32, Default::default()).unwrap();
            canvas
                .draw_text(
                    &mut fonts,
                    &run,
                    gpui_canvas::Point { x: 0., y: 0. },
                    gpui_canvas::Affine::IDENTITY,
                    Rect::new(0., 0., 32., 32.),
                    gpui_canvas::Color::BLACK,
                )
                .unwrap();
            let key = canvas.prepared_scene().masks().next().unwrap().key;
            let coverage = vec![255; MAX_ATLAS_SIDE as usize];
            let mask = GlyphMask {
                key,
                width: MAX_ATLAS_SIDE as usize,
                height: 1,
                coverage: &coverage,
            };
            let mut atlas = Atlas::new(context.device(), MAX_ATLAS_SIDE);
            atlas.x = 1;
            atlas.y = MAX_ATLAS_SIDE - 1;
            atlas.row_height = 1;
            assert!(atlas.insert(context.queue(), mask).is_none());
            assert_eq!(
                (atlas.x, atlas.y, atlas.row_height, atlas.entries.len()),
                (1, MAX_ATLAS_SIDE - 1, 1, 0)
            );
            atlas.x = 0;
            atlas.row_height = 0;
            assert_eq!(
                atlas.insert(context.queue(), mask),
                Some(MAX_ATLAS_SIDE as usize)
            );
            let tile = atlas.entries[&key];
            assert_eq!(
                (tile.x, tile.y, tile.width, tile.height),
                (0, MAX_ATLAS_SIDE - 1, MAX_ATLAS_SIDE, 1)
            );
            context
                .device()
                .poll(wgpu::PollType::wait_indefinitely())
                .unwrap();
        });
    }
}
