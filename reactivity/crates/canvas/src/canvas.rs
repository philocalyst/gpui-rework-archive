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

/// Retained software display list. Only RGBA8 output is full-frame storage.
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
        color_config.validate()?;
        let (width, height) = (width as usize, height as usize);
        let count = width.checked_mul(height).ok_or(Error::InvalidDimensions)?;
        if count == 0 || count > MAX_PIXELS || width > 16_384 || height > 16_384 {
            return Err(Error::InvalidDimensions);
        }
        let mut pixels = Vec::new();
        pixels
            .try_reserve_exact(count * 4)
            .map_err(|_| Error::ResourceLimit)?;
        pixels.resize(count * 4, 0);
        let mut canvas = Self::empty(width, height, color_config);
        canvas.pixels = pixels;
        Ok(canvas)
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
    /// come from the exact same font service. No text is reshaped during painting.
    pub fn draw_text(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
    ) -> Result<(), Error> {
        text.validate(layout)?;
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
            let raster = text.raster(glyph.id, layout.font_size())?;
            let m = raster.metrics;
            let rect = Rect::new(
                origin.x + glyph.x + m.xmin as f32,
                origin.y + glyph.baseline - m.ymin as f32 - m.height as f32,
                m.width as f32,
                m.height as f32,
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
    /// Premultiplied encoded-profile RGBA8, top-left origin, tightly packed rows.
    /// Both supported profiles use the sRGB transfer curve; see color_config().
    /// Linear composition precedes a single tile encoding. A clean call does no work.
    pub fn pixels(&mut self) -> &[u8] {
        if self.dirty {
            self.render();
            self.dirty = false;
        }
        &self.pixels
    }
    fn render(&mut self) {
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
        let mut scratch = [[0.0f32; 4]; TILE * TILE * 16];
        let encoder = self.color_config.encoder();
        let clear_bytes = encoder.encode(self.clear);
        for pixel in self.pixels.chunks_exact_mut(4) {
            pixel.copy_from_slice(&clear_bytes);
        }
        for tile in 0..tiles {
            let ordered = &self.indices[self.offsets[tile]..self.offsets[tile + 1]];
            if ordered.is_empty() {
                continue;
            }
            let left = tile % columns * TILE;
            let top = tile / columns * TILE;
            let right = (left + TILE).min(self.width);
            let bottom = (top + TILE).min(self.height);
            let start = if self.tile_proofs {
                ordered
                    .iter()
                    .rposition(|index| {
                        let command = &self.commands[*index as usize];
                        command.color[3] == 1.0
                            && matches!(command.source, Source::Rect)
                            && full_tile(command, left, top, right, bottom)
                    })
                    .unwrap_or(0)
            } else {
                0
            };
            stats.skipped_command_tiles += start;
            let mut uniform = Some(self.clear);
            for &index in &ordered[start..] {
                let command = &self.commands[index as usize];
                let full = self.tile_proofs
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
            let uniform_bytes =
                uniform.map(|color| encoder.encode(sample_mean(std::iter::repeat_n(color, 16))));
            for y in top..bottom {
                for x in left..right {
                    let rgba = uniform_bytes.unwrap_or_else(|| {
                        let start = ((y - top) * TILE + x - left) * 16;
                        let average = sample_mean(scratch[start..start + 16].iter().copied());
                        encoder.encode(average)
                    });
                    let offset = (y * self.width + x) * 4;
                    self.pixels[offset..offset + 4].copy_from_slice(&rgba);
                }
            }
        }
        self.stats = stats;
    }
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
                Source::Glyph(mask) => mask_sample(mask, lx - r.x as f64, ly - r.y as f64),
            };
        }
    }
    values
}
fn mask_sample(mask: &Raster, x: f64, y: f64) -> f32 {
    // Fontdue has already integrated outline coverage into each raster cell.
    // Reconstruct it as a piecewise-constant field, preserving that native AA
    // at integer placement. General affine resampling uses the common 4x4 grid;
    // this is bounded sampling, not a scalable outline or exact area renderer.
    if x < 0.0 || y < 0.0 || x >= mask.metrics.width as f64 || y >= mask.metrics.height as f64 {
        return 0.0;
    }
    mask.pixels[y as usize * mask.metrics.width + x as usize] as f32 / 255.0
}
fn blend(dst: &mut [f32; 4], src: [f32; 4], coverage: f32) {
    let alpha = src[3] * coverage;
    for i in 0..4 {
        dst[i] = src[i] * coverage + dst[i] * (1.0 - alpha);
    }
}
fn sample_mean(samples: impl Iterator<Item = [f32; 4]>) -> [f32; 4] {
    let mut average = [0.0; 4];
    for sample in samples {
        for i in 0..4 {
            average[i] += sample[i] / 16.0;
        }
    }
    average
}
