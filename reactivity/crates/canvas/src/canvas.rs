use crate::text::Raster;
use crate::{Affine, Color, ColorConfig, Error, Point, Rect, TextLayout, TextSystem};
use std::{collections::HashSet, sync::Arc};

const TILE: usize = 16;
const MAX_PIXELS: usize = 16 * 1024 * 1024;
const MAX_COMMANDS: usize = 65_536;
const MAX_REFERENCES: usize = 4 * 1024 * 1024;
const MAX_MASK_BYTES: usize = 32 * 1024 * 1024;
const SAMPLES: [f64; 4] = [0.125, 0.375, 0.625, 0.875];

#[derive(Clone, Copy, Debug, Default)]
pub struct RenderStats {
    pub render_count: u64,
    pub commands: usize,
    pub tile_references: usize,
    pub full_rect_tiles: usize,
    pub skipped_command_tiles: usize,
    pub boundary_pixels: usize,
    pub sample_tests: usize,
    pub retained_mask_bytes: usize,
    pub command_bytes: usize,
    pub bin_bytes: usize,
    /// Number of disjoint 16-row output bands rendered in this frame.
    pub output_bands: usize,
    pub parallel: bool,
}

#[derive(Clone, Copy)]
struct Mapping {
    inverse: [f64; 6],
}
impl Mapping {
    fn new(t: Affine) -> Result<Self, Error> {
        if !t.is_finite()
            || [t.a, t.b, t.c, t.d, t.tx, t.ty]
                .iter()
                .any(|v| v.abs() > 1_048_576.0)
        {
            return Err(Error::InvalidGeometry);
        }
        let (a, b, c, d, tx, ty) = (
            t.a as f64,
            t.b as f64,
            t.c as f64,
            t.d as f64,
            t.tx as f64,
            t.ty as f64,
        );
        let det = a * d - b * c;
        if det == 0.0 {
            return Err(Error::InvalidGeometry);
        }
        let inverse = [
            d / det,
            -b / det,
            -c / det,
            a / det,
            (c * ty - d * tx) / det,
            (b * tx - a * ty) / det,
        ];
        if inverse.iter().any(|v| !v.is_finite() || v.abs() > 1e12) {
            return Err(Error::InvalidGeometry);
        }
        Ok(Self { inverse })
    }
    fn local(self, x: f64, y: f64) -> (f64, f64) {
        let [a, b, c, d, tx, ty] = self.inverse;
        (a * x + c * y + tx, b * x + d * y + ty)
    }
    fn error(self, x: f64, y: f64) -> f64 {
        let [a, b, c, d, tx, ty] = self.inverse;
        // Encloses scalar f64 multiply/add and input-bound comparison error
        // for this admitted finite domain. No fast-math/reassociation required.
        64.0 * f64::EPSILON
            * (a.abs() * x.abs()
                + c.abs() * y.abs()
                + tx.abs()
                + b.abs() * x.abs()
                + d.abs() * y.abs()
                + ty.abs()
                + 1.0)
    }
}
#[derive(Clone)]
enum Source {
    Rect,
    Glyph(Arc<Raster>),
}
#[derive(Clone)]
struct Command {
    rect: Rect,
    clip: Rect,
    map: Mapping,
    source: Source,
    color: [f32; 4],
    bounds: [usize; 4],
}

/// Immutable mask borrowed from a prepared scene. Backends upload while borrowed
/// or obtain their own explicit backing lease; this borrow cannot outlive Canvas.
#[derive(Clone, Copy, Debug)]
pub struct GlyphMask<'a> {
    pub key: crate::GlyphKey,
    pub width: usize,
    pub height: usize,
    pub coverage: &'a [u8],
}

/// Canonical ordered draw, with the exact inverse used by the CPU reference.
/// A backend narrowing f64 to f32 must validate its numeric/coverage contract.
/// Color is premultiplied extended linear sRGB. Clip is in canvas coordinates;
/// bounds is a conservative integer device quad, already clipped to the canvas.
/// Glyph coverage cells span local_rect: mask pixel dimensions may differ from
/// logical extents under device-density rasterization. Test the half-open local
/// rectangle before normalizing into mask coordinates.
#[derive(Clone, Copy, Debug)]
pub struct PreparedDraw<'a> {
    pub local_rect: Rect,
    pub inverse: [f64; 6],
    pub clip: Rect,
    pub bounds: Rect,
    pub color: [f32; 4],
    pub mask: Option<GlyphMask<'a>>,
}

/// Borrowed canonical scene; CPU tile bins are disposable and not part of it.
/// Clear and draws use the same working-color domain. No rasterization occurs
/// when obtaining this view or traversing it, and no mask Arc is cloned.
#[derive(Clone, Copy)]
pub struct PreparedScene<'a> {
    pub width: u32,
    pub height: u32,
    pub color_config: ColorConfig,
    pub clear: [f32; 4],
    commands: &'a [Command],
}
impl<'a> PreparedScene<'a> {
    pub fn draws(self) -> impl ExactSizeIterator<Item = PreparedDraw<'a>> + DoubleEndedIterator {
        self.commands.iter().map(|command| {
            let [left, top, right, bottom] = command.bounds;
            PreparedDraw {
                local_rect: command.rect,
                inverse: command.map.inverse,
                clip: command.clip,
                bounds: Rect::new(
                    left as f32,
                    top as f32,
                    (right - left) as f32,
                    (bottom - top) as f32,
                ),
                color: command.color,
                mask: match &command.source {
                    Source::Rect => None,
                    Source::Glyph(mask) => Some(GlyphMask {
                        key: mask.key,
                        width: mask.metrics.width,
                        height: mask.metrics.height,
                        coverage: &mask.pixels,
                    }),
                },
            }
        })
    }
}

/// Retained software display list. Only the selected output format is full-frame storage.
/// Rendering uses one fixed linear-premultiplied tile, then encodes once.
/// `clear` begins a new scene; appending after `pixels` rerenders the retained scene.
pub struct Canvas {
    color_config: ColorConfig,
    width: usize,
    height: usize,
    pixels: Vec<u8>,
    clear: [f32; 4],
    commands: Vec<Command>,
    masks: HashSet<usize>,
    mask_bytes: usize,
    references: usize,
    dirty: bool,
    offsets: Vec<usize>,
    indices: Vec<u32>,
    cursor: Vec<usize>,
    stats: RenderStats,
    tile_proofs: bool,
}
impl Canvas {
    pub fn new(width: u32, height: u32) -> Result<Self, Error> {
        Self::with_color_config(width, height, ColorConfig::default())
    }
    pub fn with_color_config(
        width: u32,
        height: u32,
        color_config: ColorConfig,
    ) -> Result<Self, Error> {
        let mut canvas = Self::recording(width, height, color_config)?;
        canvas.allocate_pixels()?;
        Ok(canvas)
    }
    /// Record a canonical scene without allocating a CPU image. Native backends
    /// can borrow prepared_scene(); CPU diagnostics allocate on first try_pixels.
    pub fn recording(width: u32, height: u32, color_config: ColorConfig) -> Result<Self, Error> {
        color_config.validate()?;
        let (width, height) = (width as usize, height as usize);
        let count = width.checked_mul(height).ok_or(Error::InvalidDimensions)?;
        if count == 0 || count > MAX_PIXELS || width > 16_384 || height > 16_384 {
            return Err(Error::InvalidDimensions);
        }
        let mut canvas = Self::empty(width, height, color_config);
        canvas.dirty = true;
        Ok(canvas)
    }
    fn allocate_pixels(&mut self) -> Result<(), Error> {
        let length = self.width * self.height * self.color_config.bytes_per_pixel();
        if self.pixels.len() != length {
            self.pixels
                .try_reserve_exact(length - self.pixels.len())
                .map_err(|_| Error::ResourceLimit)?;
            self.pixels.resize(length, 0);
        }
        Ok(())
    }
    /// Bytes retained by the optional CPU output image, including spare capacity.
    pub fn output_bytes(&self) -> usize {
        self.pixels.capacity()
    }
    fn empty(width: usize, height: usize, color_config: ColorConfig) -> Self {
        Self {
            color_config,
            width,
            height,
            pixels: Vec::new(),
            clear: [0.0; 4],
            commands: Vec::new(),
            masks: HashSet::new(),
            mask_bytes: 0,
            references: 0,
            dirty: false,
            offsets: Vec::new(),
            indices: Vec::new(),
            cursor: Vec::new(),
            stats: RenderStats::default(),
            tile_proofs: true,
        }
    }
    /// Prepare a replacement display list while retaining the previous pixels
    /// and scene on failure. The candidate owns no full-frame output buffer.
    pub fn stage(&mut self) -> CanvasScene<'_> {
        let mut pending = Self::empty(self.width, self.height, self.color_config);
        pending.tile_proofs = self.tile_proofs;
        CanvasScene {
            target: self,
            pending,
        }
    }
    pub fn width(&self) -> u32 {
        self.width as u32
    }
    pub fn height(&self) -> u32 {
        self.height as u32
    }
    pub fn stats(&self) -> RenderStats {
        self.stats
    }
    pub fn prepared_scene(&self) -> PreparedScene<'_> {
        PreparedScene {
            width: self.width as u32,
            height: self.height as u32,
            color_config: self.color_config,
            clear: self.clear,
            commands: &self.commands,
        }
    }
    /// Describes the bytes returned by pixels. Display P3 requires a tagged,
    /// negotiated presentation path; treating those bytes as sRGB is incorrect.
    pub fn color_config(&self) -> ColorConfig {
        self.color_config
    }
    /// Diagnostic/reference switch. Both paths have identical sample semantics.
    pub fn set_tile_proofs(&mut self, enabled: bool) {
        if self.tile_proofs != enabled {
            self.tile_proofs = enabled;
            self.dirty = true;
        }
    }
    pub fn clear(&mut self, color: Color) {
        self.commands.clear();
        self.masks.clear();
        self.mask_bytes = 0;
        self.references = 0;
        self.clear = color.premultiplied();
        self.dirty = true;
    }
    /// Clip is an axis-aligned rectangle in canvas coordinates, before sampling.
    /// Singular/ill-conditioned transforms and out-of-domain geometry return errors.
    pub fn fill_rect(
        &mut self,
        rect: Rect,
        transform: Affine,
        clip: Rect,
        color: Color,
    ) -> Result<(), Error> {
        let command = self.prepare(rect, transform, clip, color, Source::Rect)?;
        if let Some(command) = command {
            self.admit(std::slice::from_ref(&command))?;
            self.commands.push(command);
            self.dirty = true;
        }
        Ok(())
    }
    /// Origin and layout positions are local to transform. Layout and glyph masks
    /// belong to the same immutable FontFace. No text is reshaped during painting.
    pub fn draw_text(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
    ) -> Result<(), Error> {
        self.draw_text_scaled(text, layout, origin, transform, clip, color, 1.0)
    }
    /// Shape positions remain logical; rasterize masks at the supplied device
    /// density and express their extents back in logical units. This preserves
    /// device-resolution glyph coverage without changing layout or enlarging a
    /// low-resolution bitmap. Physical font sizes are bounded to 4096px, and
    /// each bitmap remains subject to the existing 1MiB raster resource limit.
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
        raster_scale: f32,
    ) -> Result<(), Error> {
        text.validate(layout)?;
        if !raster_scale.is_finite() || raster_scale <= 0.0 {
            return Err(Error::InvalidGeometry);
        }
        let physical_font_size = layout.font_size() * raster_scale;
        if !physical_font_size.is_finite()
            || !(0.0..=4096.0).contains(&physical_font_size)
            || physical_font_size == 0.0
        {
            return Err(Error::InvalidFontSize);
        }
        if !origin.x.is_finite() || !origin.y.is_finite() {
            return Err(Error::InvalidGeometry);
        }
        // Validate even an empty run, and prepare all commands before publishing.
        Mapping::new(transform)?;
        validate_rect(clip)?;
        let mut pending = Vec::with_capacity(layout.glyphs().len());
        let mut pending_masks = HashSet::new();
        let mut pending_bytes = 0;
        for glyph in layout.glyphs() {
            let raster = text.raster(glyph.id, physical_font_size)?;
            let m = raster.metrics;
            let rect = Rect::new(
                origin.x + glyph.x + m.xmin as f32 / raster_scale,
                origin.y + glyph.baseline
                    - m.ymin as f32 / raster_scale
                    - m.height as f32 / raster_scale,
                m.width as f32 / raster_scale,
                m.height as f32 / raster_scale,
            );
            if let Some(command) =
                self.prepare(rect, transform, clip, color, Source::Glyph(raster))?
            {
                if let Source::Glyph(raster) = &command.source {
                    // Pointer keys are used only while the corresponding Arc is
                    // retained by this pending run or the admitted command list.
                    let key = Arc::as_ptr(raster) as usize;
                    if !self.masks.contains(&key) && pending_masks.insert(key) {
                        pending_bytes += raster.pixels.len();
                        if self.mask_bytes + pending_bytes > MAX_MASK_BYTES {
                            return Err(Error::ResourceLimit);
                        }
                    }
                }
                pending.push(command);
            }
        }
        self.admit(&pending)?;
        if !pending.is_empty() {
            self.commands.extend(pending);
            self.dirty = true;
        }
        Ok(())
    }
    fn prepare(
        &self,
        rect: Rect,
        transform: Affine,
        clip: Rect,
        color: Color,
        source: Source,
    ) -> Result<Option<Command>, Error> {
        validate_rect(rect)?;
        validate_rect(clip)?;
        let map = Mapping::new(transform)?;
        if rect.is_empty() || clip.is_empty() || color.alpha() == 0.0 {
            return Ok(None);
        }
        let mut min = [f64::INFINITY; 2];
        let mut max = [f64::NEG_INFINITY; 2];
        let pad = 0.0;
        for (x, y) in [
            (rect.x as f64 - pad, rect.y as f64 - pad),
            (rect.x as f64 + rect.width as f64 + pad, rect.y as f64 - pad),
            (
                rect.x as f64 - pad,
                rect.y as f64 + rect.height as f64 + pad,
            ),
            (
                rect.x as f64 + rect.width as f64 + pad,
                rect.y as f64 + rect.height as f64 + pad,
            ),
        ] {
            let wx = transform.a as f64 * x + transform.c as f64 * y + transform.tx as f64;
            let wy = transform.b as f64 * x + transform.d as f64 * y + transform.ty as f64;
            min[0] = min[0].min(wx);
            min[1] = min[1].min(wy);
            max[0] = max[0].max(wx);
            max[1] = max[1].max(wy);
        }
        // Expand by one device pixel as an outward arithmetic guard. Actual local/clip sample tests remain authoritative.
        let left = (min[0] - 1.0)
            .max(clip.x as f64)
            .max(0.0)
            .floor()
            .min(self.width as f64) as usize;
        let top = (min[1] - 1.0)
            .max(clip.y as f64)
            .max(0.0)
            .floor()
            .min(self.height as f64) as usize;
        let right = (max[0] + 1.0)
            .min(clip.x as f64 + clip.width as f64)
            .min(self.width as f64)
            .ceil()
            .max(0.0) as usize;
        let bottom = (max[1] + 1.0)
            .min(clip.y as f64 + clip.height as f64)
            .min(self.height as f64)
            .ceil()
            .max(0.0) as usize;
        if left >= right || top >= bottom {
            return Ok(None);
        }
        Ok(Some(Command {
            rect,
            clip,
            map,
            source,
            color: color.premultiplied(),
            bounds: [left, top, right, bottom],
        }))
    }
    fn admit(&mut self, pending: &[Command]) -> Result<(), Error> {
        if self.commands.len() + pending.len() > MAX_COMMANDS {
            return Err(Error::ResourceLimit);
        }
        let mut refs = 0usize;
        let mut bytes = 0usize;
        let mut added = HashSet::new();
        for command in pending {
            let [x, y, r, b] = command.bounds;
            refs += ((r - 1) / TILE - x / TILE + 1) * ((b - 1) / TILE - y / TILE + 1);
            if let Source::Glyph(mask) = &command.source {
                let key = Arc::as_ptr(mask) as usize;
                if !self.masks.contains(&key) && added.insert(key) {
                    bytes += mask.pixels.len();
                }
            }
        }
        if self.references + refs > MAX_REFERENCES || self.mask_bytes + bytes > MAX_MASK_BYTES {
            return Err(Error::ResourceLimit);
        }
        self.commands
            .try_reserve(pending.len())
            .map_err(|_| Error::ResourceLimit)?;
        self.masks
            .try_reserve(added.len())
            .map_err(|_| Error::ResourceLimit)?;
        self.masks.extend(added);
        self.mask_bytes += bytes;
        self.references += refs;
        Ok(())
    }
    /// Premultiplied output, top-left origin, tightly packed rows. RGBA8 uses
    /// encoded-profile channels; RGBA16Float is linear little-endian binary16.
    /// Primaries, transfer and reference white are declared by color_config().metadata().
    /// Linear composition precedes a single tile encoding. A clean call does no work.
    pub fn pixels(&mut self) -> &[u8] {
        self.try_pixels()
            .expect("CPU output allocation failed; use try_pixels for fallible access")
    }
    /// Allocate the optional CPU image and render if dirty. Allocation failure
    /// leaves the canonical scene intact and does not publish a partial image.
    pub fn try_pixels(&mut self) -> Result<&[u8], Error> {
        self.allocate_pixels()?;
        if self.dirty {
            self.render(&Serial);
            self.dirty = false;
        }
        Ok(&self.pixels)
    }
    /// Render using an explicitly owned pool; small scenes use the serial path.
    #[cfg(feature = "parallel")]
    pub fn pixels_with(&mut self, pool: &RenderPool) -> &[u8] {
        self.try_pixels_with(pool)
            .expect("CPU output allocation failed; use try_pixels_with for fallible access")
    }
    #[cfg(feature = "parallel")]
    pub fn try_pixels_with(&mut self, pool: &RenderPool) -> Result<&[u8], Error> {
        self.allocate_pixels()?;
        if self.dirty {
            self.render(pool);
            self.dirty = false;
        }
        Ok(&self.pixels)
    }
    fn render(&mut self, schedule: &impl RenderSchedule) {
        let columns = self.width.div_ceil(TILE);
        let rows = self.height.div_ceil(TILE);
        let tiles = columns * rows;
        self.offsets.clear();
        self.offsets.resize(tiles + 1, 0);
        for command in &self.commands {
            visit_tiles(command, columns, |tile| self.offsets[tile + 1] += 1);
        }
        for i in 1..self.offsets.len() {
            self.offsets[i] += self.offsets[i - 1];
        }
        self.indices.clear();
        self.indices.resize(self.references, 0);
        // Counting cursor is transient O(tile count), never O(pixel count).
        self.cursor.clear();
        self.cursor.extend_from_slice(&self.offsets[..tiles]);
        for (index, command) in self.commands.iter().enumerate() {
            visit_tiles(command, columns, |tile| {
                self.indices[self.cursor[tile]] = index as u32;
                self.cursor[tile] += 1;
            });
        }
        let mut stats = RenderStats {
            render_count: self.stats.render_count.saturating_add(1),
            commands: self.commands.len(),
            tile_references: self.references,
            retained_mask_bytes: self.mask_bytes,
            command_bytes: self.commands.capacity() * std::mem::size_of::<Command>(),
            bin_bytes: self.offsets.capacity() * std::mem::size_of::<usize>()
                + self.cursor.capacity() * std::mem::size_of::<usize>()
                + self.indices.capacity() * 4,
            ..RenderStats::default()
        };
        let frame = Frame {
            width: self.width,
            height: self.height,
            clear: self.clear,
            commands: &self.commands,
            offsets: &self.offsets,
            indices: &self.indices,
            tile_proofs: self.tile_proofs,
        };
        let rendered = match self.color_config.format {
            crate::PixelFormat::Rgba8Premultiplied => {
                schedule.render(frame, self.color_config.encoder(), &mut self.pixels)
            }
            crate::PixelFormat::Rgba16Float => {
                schedule.render(frame, self.color_config.half_encoder(), &mut self.pixels)
            }
        };
        stats.full_rect_tiles = rendered.full_rect_tiles;
        stats.skipped_command_tiles = rendered.skipped_command_tiles;
        stats.boundary_pixels = rendered.boundary_pixels;
        stats.sample_tests = rendered.sample_tests;
        stats.output_bands = rows;
        stats.parallel = rendered.parallel;
        self.stats = stats;
    }
}

/// A frame borrows immutable commands and CSR bins. Workers never prepare text,
/// mutate a font cache, clone resource handles, or observe a candidate scene.
#[derive(Clone, Copy)]
struct Frame<'a> {
    width: usize,
    height: usize,
    clear: [f32; 4],
    commands: &'a [Command],
    offsets: &'a [usize],
    indices: &'a [u32],
    tile_proofs: bool,
}

/// Format dispatch happens once per frame, not through a pixel function pointer.
pub(crate) trait PixelWriter: Copy + Send + Sync {
    const BYTES: usize;
    fn write(self, color: [f32; 4], destination: &mut [u8]);
}
impl PixelWriter for crate::color::OutputEncoder {
    const BYTES: usize = 4;
    #[inline]
    fn write(self, color: [f32; 4], destination: &mut [u8]) {
        destination.copy_from_slice(&self.encode(color));
    }
}
trait RenderSchedule {
    fn render<W: PixelWriter>(&self, frame: Frame<'_>, writer: W, pixels: &mut [u8])
    -> RenderStats;
}
struct Serial;
impl RenderSchedule for Serial {
    fn render<W: PixelWriter>(
        &self,
        frame: Frame<'_>,
        writer: W,
        pixels: &mut [u8],
    ) -> RenderStats {
        pixels
            .chunks_mut(TILE * frame.width * W::BYTES)
            .enumerate()
            .map(|(index, band)| render_band(frame, writer, index, band))
            .fold(RenderStats::default(), combine_stats)
    }
}
fn combine_stats(mut left: RenderStats, right: RenderStats) -> RenderStats {
    left.full_rect_tiles += right.full_rect_tiles;
    left.skipped_command_tiles += right.skipped_command_tiles;
    left.boundary_pixels += right.boundary_pixels;
    left.sample_tests += right.sample_tests;
    left
}

/// Explicit persistent executor. The default crate feature creates no threads.
/// A pool owns its worker threads; it never uses Rayon's global pool.
#[cfg(feature = "parallel")]
pub struct RenderPool {
    pool: rayon::ThreadPool,
    min_work: usize,
}
#[cfg(feature = "parallel")]
impl RenderPool {
    pub fn new(workers: usize) -> Result<Self, ParallelError> {
        if !(1..=64).contains(&workers) {
            return Err(ParallelError::InvalidWorkerCount);
        }
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(workers)
            .stack_size(512 * 1024)
            .thread_name(|index| format!("gpui-raster-{index}"))
            .build()
            .map_err(ParallelError::Build)?;
        Ok(Self {
            pool,
            min_work: 65_536,
        })
    }
    /// Scheduling estimate only: pixel writes plus conservative sample work.
    /// Zero forces the parallel path for reproducible comparisons.
    pub fn with_min_work(mut self, min_work: usize) -> Self {
        self.min_work = min_work;
        self
    }
    pub fn workers(&self) -> usize {
        self.pool.current_num_threads()
    }
}
#[cfg(feature = "parallel")]
#[derive(Debug)]
pub enum ParallelError {
    InvalidWorkerCount,
    Build(rayon::ThreadPoolBuildError),
}
#[cfg(feature = "parallel")]
impl std::fmt::Display for ParallelError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::InvalidWorkerCount => f.write_str("worker count must be in 1..=64"),
            Self::Build(error) => write!(f, "raster thread pool: {error}"),
        }
    }
}
#[cfg(feature = "parallel")]
impl std::error::Error for ParallelError {}
#[cfg(feature = "parallel")]
impl RenderSchedule for RenderPool {
    fn render<W: PixelWriter>(
        &self,
        frame: Frame<'_>,
        writer: W,
        pixels: &mut [u8],
    ) -> RenderStats {
        use rayon::prelude::*;
        // Estimate distinguishes a proven uniform viewport fill from sampled
        // edges/text. It chooses scheduling only and cannot affect the pixels.
        let work = frame
            .commands
            .iter()
            .fold(frame.width * frame.height, |work, command| {
                let [left, top, right, bottom] = command.bounds;
                let uniform = frame.tile_proofs
                    && matches!(command.source, Source::Rect)
                    && full_tile(command, 0, 0, frame.width, frame.height);
                work.saturating_add(if uniform {
                    (right - left) * (bottom - top) / 256
                } else {
                    (right - left) * (bottom - top) * 16
                })
            });
        if work < self.min_work || frame.height <= TILE {
            return Serial.render(frame, writer, pixels);
        }
        let mut stats = self.pool.install(|| {
            pixels
                .par_chunks_mut(TILE * frame.width * W::BYTES)
                .enumerate()
                .map(|(index, band)| render_band(frame, writer, index, band))
                .reduce(RenderStats::default, combine_stats)
        });
        stats.parallel = true;
        stats
    }
}

fn render_band<W: PixelWriter>(
    frame: Frame<'_>,
    writer: W,
    band_index: usize,
    pixels: &mut [u8],
) -> RenderStats {
    let columns = frame.width.div_ceil(TILE);
    let mut stats = RenderStats::default();
    let mut scratch = [[0.0f32; 4]; TILE * TILE * 16];
    // All admitted writers emit at most eight bytes. These fixed local buffers
    // cache uniform colors without a heap allocation or repeated transfer work.
    let mut clear = [0u8; 8];
    writer.write(frame.clear, &mut clear[..W::BYTES]);
    for tile in band_index * columns..(band_index + 1) * columns {
        let ordered = &frame.indices[frame.offsets[tile]..frame.offsets[tile + 1]];
        let left = tile % columns * TILE;
        let top = band_index * TILE;
        let right = (left + TILE).min(frame.width);
        let bottom = (top + TILE).min(frame.height);
        let start = if frame.tile_proofs {
            ordered
                .iter()
                .rposition(|index| {
                    let command = &frame.commands[*index as usize];
                    command.color[3] == 1.0
                        && matches!(command.source, Source::Rect)
                        && full_tile(command, left, top, right, bottom)
                })
                .unwrap_or(0)
        } else {
            0
        };
        stats.skipped_command_tiles += start;
        let mut uniform = Some(frame.clear);
        for &index in &ordered[start..] {
            let command = &frame.commands[index as usize];
            let full = frame.tile_proofs
                && matches!(command.source, Source::Rect)
                && full_tile(command, left, top, right, bottom);
            if full {
                stats.full_rect_tiles += 1;
                if let Some(value) = &mut uniform {
                    blend(value, command.color, 1.0);
                    continue;
                }
            } else if let Some(value) = uniform.take() {
                // A uniform prefix needs no tile storage until an edge or
                // glyph makes its sample colors differ.
                scratch.fill(value);
            }
            for y in top.max(command.bounds[1])..bottom.min(command.bounds[3]) {
                for x in left.max(command.bounds[0])..right.min(command.bounds[2]) {
                    let coverages = if full {
                        [1.0; 16]
                    } else {
                        stats.boundary_pixels += 1;
                        sample(command, x, y, &mut stats)
                    };
                    for (sample, coverage) in coverages.into_iter().enumerate() {
                        if coverage > 0.0 {
                            blend(
                                &mut scratch[((y - top) * TILE + x - left) * 16 + sample],
                                command.color,
                                coverage,
                            );
                        }
                    }
                }
            }
        }
        // Each output pixel is written exactly once: empty tiles write the
        // cached clear, uniform tiles encode once, and sampled tiles reduce.
        let uniform_color = uniform;
        let mut uniform_bytes = clear;
        if !ordered.is_empty()
            && let Some(color) = uniform_color
        {
            writer.write(color, &mut uniform_bytes[..W::BYTES]);
        }
        for y in top..bottom {
            for x in left..right {
                let offset = ((y - top) * frame.width + x) * W::BYTES;
                let destination = &mut pixels[offset..offset + W::BYTES];
                if uniform_color.is_some() {
                    destination.copy_from_slice(&uniform_bytes[..W::BYTES]);
                } else {
                    let color = {
                        let start = ((y - top) * TILE + x - left) * 16;
                        sample_mean(scratch[start..start + 16].iter().copied())
                    };
                    writer.write(color, destination);
                }
            }
        }
    }
    stats
}

/// Command-only candidate tied to one canvas. Dropping it leaves the published
/// scene untouched. Commit requires no allocation or further validation.
///
/// ```compile_fail
/// let mut canvas=gpui_canvas::Canvas::new(16,16).unwrap();
/// let mut candidate=canvas.stage();
/// candidate.pixels(); // Candidates cannot rasterize or expose stale output.
/// ```
pub struct CanvasScene<'a> {
    target: &'a mut Canvas,
    pending: Canvas,
}
impl CanvasScene<'_> {
    pub fn width(&self) -> u32 {
        self.pending.width()
    }
    pub fn height(&self) -> u32 {
        self.pending.height()
    }
    pub fn clear(&mut self, color: Color) {
        self.pending.clear(color);
    }
    pub fn fill_rect(
        &mut self,
        rect: Rect,
        transform: Affine,
        clip: Rect,
        color: Color,
    ) -> Result<(), Error> {
        self.pending.fill_rect(rect, transform, clip, color)
    }
    pub fn draw_text(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
    ) -> Result<(), Error> {
        self.pending
            .draw_text(text, layout, origin, transform, clip, color)
    }
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
        raster_scale: f32,
    ) -> Result<(), Error> {
        self.pending
            .draw_text_scaled(text, layout, origin, transform, clip, color, raster_scale)
    }
    pub fn commit(self) {
        self.target.clear = self.pending.clear;
        self.target.commands = self.pending.commands;
        self.target.masks = self.pending.masks;
        self.target.mask_bytes = self.pending.mask_bytes;
        self.target.references = self.pending.references;
        self.target.dirty = true;
    }
}
fn validate_rect(rect: Rect) -> Result<(), Error> {
    if !rect.is_valid()
        || [rect.x, rect.y, rect.width, rect.height]
            .iter()
            .any(|v| v.abs() > 1_048_576.0)
    {
        Err(Error::InvalidGeometry)
    } else {
        Ok(())
    }
}
fn visit_tiles(command: &Command, columns: usize, mut visit: impl FnMut(usize)) {
    let [x, y, r, b] = command.bounds;
    for ty in y / TILE..=(b - 1) / TILE {
        for tx in x / TILE..=(r - 1) / TILE {
            visit(ty * columns + tx);
        }
    }
}
fn full_tile(command: &Command, left: usize, top: usize, right: usize, bottom: usize) -> bool {
    let r = command.rect;
    let c = command.clip;
    if (left as f64) < c.x as f64
        || (top as f64) < c.y as f64
        || right as f64 > c.x as f64 + c.width as f64
        || bottom as f64 > c.y as f64 + c.height as f64
    {
        return false;
    }
    for (x, y) in [
        (left as f64, top as f64),
        (right as f64, top as f64),
        (left as f64, bottom as f64),
        (right as f64, bottom as f64),
    ] {
        let (lx, ly) = command.map.local(x, y);
        let error = command.map.error(x, y);
        if lx - error <= r.x as f64
            || ly - error <= r.y as f64
            || lx + error >= r.x as f64 + r.width as f64
            || ly + error >= r.y as f64 + r.height as f64
        {
            return false;
        }
    }
    true
}
fn sample(command: &Command, x: usize, y: usize, stats: &mut RenderStats) -> [f32; 16] {
    let r = command.rect;
    let clip = command.clip;
    let mut values = [0.0; 16];
    for (sy, oy) in SAMPLES.into_iter().enumerate() {
        for (sx, ox) in SAMPLES.into_iter().enumerate() {
            stats.sample_tests += 1;
            let wx = x as f64 + ox;
            let wy = y as f64 + oy;
            if wx < clip.x as f64
                || wy < clip.y as f64
                || wx >= clip.x as f64 + clip.width as f64
                || wy >= clip.y as f64 + clip.height as f64
            {
                continue;
            }
            let (lx, ly) = command.map.local(wx, wy);
            values[sy * 4 + sx] = match &command.source {
                Source::Rect => {
                    if lx >= r.x as f64
                        && ly >= r.y as f64
                        && lx < r.x as f64 + r.width as f64
                        && ly < r.y as f64 + r.height as f64
                    {
                        1.0
                    } else {
                        0.0
                    }
                }
                Source::Glyph(mask) => mask_sample(
                    mask,
                    lx - r.x as f64,
                    ly - r.y as f64,
                    r.width as f64,
                    r.height as f64,
                ),
            };
        }
    }
    values
}
fn mask_sample(mask: &Raster, x: f64, y: f64, width: f64, height: f64) -> f32 {
    // Fontdue has already integrated outline coverage into each raster cell.
    // Reconstruct it as a piecewise-constant field, preserving that native AA
    // at integer placement. General affine resampling uses the common 4x4 grid;
    // this is bounded sampling, not a scalable outline or exact area renderer.
    // The half-open logical rectangle defines coverage. Normalization can round
    // an exterior edge inward, or the last interior point up to the texel count;
    // test the local domain first, then clamp only an admitted texel index.
    if x < 0.0
        || y < 0.0
        || x >= width
        || y >= height
        || mask.metrics.width == 0
        || mask.metrics.height == 0
    {
        return 0.0;
    }
    let column = ((x * (mask.metrics.width as f64 / width)) as usize).min(mask.metrics.width - 1);
    let row = ((y * (mask.metrics.height as f64 / height)) as usize).min(mask.metrics.height - 1);
    mask.pixels[row * mask.metrics.width + column] as f32 / 255.0
}
fn blend(dst: &mut [f32; 4], src: [f32; 4], coverage: f32) {
    let alpha = src[3] * coverage;
    for i in 0..4 {
        dst[i] = src[i] * coverage + dst[i] * (1.0 - alpha);
    }
}
fn sample_mean(samples: impl Iterator<Item = [f32; 4]>) -> [f32; 4] {
    // Sixteen identical f32 values sum exactly in f64 (24+4 significant
    // bits). Narrow once, preserving a uniform tile's exact working color.
    // Otherwise a zero-coverage command could move the clear across an output
    // quantization threshold merely by materializing its sample tile.
    let mut sum = [0.0f64; 4];
    for sample in samples {
        for i in 0..4 {
            sum[i] += sample[i] as f64;
        }
    }
    sum.map(|value| (value / 16.0) as f32)
}

#[cfg(test)]
mod scaled_mask_tests {
    use super::*;

    #[test]
    fn normalized_mask_obeys_half_open_local_edges_before_texel_rounding() {
        let mut fonts = TextSystem::bundled().unwrap();
        let layout = fonts.shape("H", 16.0, None).unwrap();
        let original = fonts.raster(layout.glyphs()[0].id, 20.0).unwrap();
        // Uniform nonzero coverage makes accidental edge inclusion or an
        // interior lookup rounded beyond the last texel directly observable.
        let mask = Raster {
            key: original.key,
            metrics: fontdue::Metrics {
                width: 17,
                height: 9,
                ..Default::default()
            },
            pixels: vec![255; 17 * 9],
        };
        for scale in [1.0_f32, 1.25, 1.3, 1.5, 1.75, 2.25, 3.1] {
            let width = (17.0 / scale) as f64;
            let height = (9.0 / scale) as f64;
            for (x, y, expected) in [
                (0.0, 0.0, 1.0),
                (width.next_down(), height.next_down(), 1.0),
                (width, height * 0.5, 0.0),
                (width * 0.5, height, 0.0),
                (width.next_up(), height * 0.5, 0.0),
                (-f64::MIN_POSITIVE, height * 0.5, 0.0),
            ] {
                assert_eq!(
                    mask_sample(&mask, x, y, width, height),
                    expected,
                    "scale={scale},x={x},y={y}"
                );
            }
        }
    }
}
