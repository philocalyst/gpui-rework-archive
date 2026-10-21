use crate::text::Raster;
use crate::{Affine, Color, ColorConfig, Error, Point, Rect, TextLayout, TextSystem};
use std::{collections::HashMap, sync::Arc};

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
    /// Exact capacities of typed draw/resource Vec lanes; excludes opaque
    /// HashMap bucket/control allocation, raster bodies and Canvas header.
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
/// Lower an axis-aligned transformed rectangle to this canvas's fixed 4×4
/// sample lattice, intersected with `parent` and the physical viewport.
///
/// The returned rectangle is a raster clip, not continuous geometry for input
/// or accessibility. Its quarter-pixel endpoints select exactly the samples
/// selected by the ordinary canvas's finite inverse predicate, including
/// reflections and inverse/forward rounding ties. A different sampling quality
/// must re-lower the original geometry instead of reusing this clip.
pub fn sampled_rect_clip(
    transform: Affine,
    rect: Rect,
    parent: Rect,
    viewport: [u32; 2],
) -> Result<Rect, Error> {
    validate_rect(rect)?;
    validate_rect(parent)?;
    let [width, height] = viewport;
    let pixels = u64::from(width) * u64::from(height);
    if pixels == 0 || pixels > MAX_PIXELS as u64 || width > 16_384 || height > 16_384 {
        return Err(Error::InvalidDimensions);
    }
    if transform.b != 0.0 || transform.c != 0.0 {
        return Err(Error::InvalidGeometry);
    }
    let map = Mapping::new(transform)?;
    if rect.is_empty() || parent.is_empty() {
        return Ok(Rect::default());
    }
    fn lower_bound(count: u32, mut predicate: impl FnMut(u32) -> bool) -> u32 {
        let (mut low, mut high) = (0, count);
        while low < high {
            let mid = low + (high - low) / 2;
            if predicate(mid) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        low
    }
    let mut intervals = [[0; 2]; 2];
    for (axis, interval) in intervals.iter_mut().enumerate() {
        let (minimum, extent, clip_start, clip_extent, side) = if axis == 0 {
            (rect.x, rect.width, parent.x, parent.width, width)
        } else {
            (rect.y, rect.height, parent.y, parent.height, height)
        };
        let minimum = f64::from(minimum);
        let maximum = minimum + f64::from(extent);
        let clip_start = f64::from(clip_start);
        let clip_end = clip_start + f64::from(clip_extent);
        let increasing = map.inverse[if axis == 0 { 0 } else { 3 }] > 0.0;
        let local = |world: f64| {
            // Use the same finite multiply/add order as ordinary sample().
            // Off-diagonal coefficients are ±0: the other positive sample
            // coordinate cannot affect membership, including signed-zero ties.
            let point = if axis == 0 {
                map.local(world, 0.125)
            } else {
                map.local(0.125, world)
            };
            if axis == 0 { point.0 } else { point.1 }
        };
        let first = lower_bound(side * 4, |index| {
            let world = f64::from(index) * 0.25 + 0.125;
            world >= clip_start
                && if increasing {
                    local(world) >= minimum
                } else {
                    local(world) < maximum
                }
        });
        let end = lower_bound(side * 4, |index| {
            let world = f64::from(index) * 0.25 + 0.125;
            world >= clip_end
                || if increasing {
                    local(world) >= maximum
                } else {
                    local(world) < minimum
                }
        });
        if end <= first {
            return Ok(Rect::default());
        }
        *interval = [first, end];
    }
    let [[left, right], [top, bottom]] = intervals;
    // Midpoints between lattice samples preserve ordinary integer clip edges.
    // Every integer here is <=65536, so all products/sums are exact in f32.
    Ok(Rect::new(
        left as f32 * 0.25,
        top as f32 * 0.25,
        (right - left) as f32 * 0.25,
        (bottom - top) as f32 * 0.25,
    ))
}

// One source of retained draw order. Compact typed lanes share text-run state;
// the renderer and exported scene resolve the same checked private addresses.
const INLINE_DRAW: u32 = 1 << 31;
const RECT_SOURCE: u32 = u32::MAX;
const _: () = assert!(MAX_COMMANDS < INLINE_DRAW as usize);

#[derive(Clone, Copy)]
struct Common {
    clip: Rect,
    map: Mapping,
    color: [f32; 4],
}
#[derive(Clone, Copy)]
struct Geometry {
    rect: Rect,
    // Canvas admission limits both dimensions to 16,384.
    bounds: [u16; 4],
}
struct PendingDraw {
    geometry: Geometry,
    source: u32,
}
struct InlineDraw {
    common: Common,
    geometry: Geometry,
}
struct Placement {
    geometry: Geometry,
    common: u32,
    source: u32,
}
// Factor the common font identity out of the primary mask index. Glyph+size is
// a lossless 48-bit key within that face; other faces retain their complete key.
// There is no fingerprint collision policy or truncated identity comparison.
#[derive(Default)]
struct MaskIndex {
    face: Option<u64>,
    primary: HashMap<u64, u32>,
    other: HashMap<crate::GlyphKey, u32>,
}
impl MaskIndex {
    fn get(&self, key: &crate::GlyphKey) -> Option<&u32> {
        let (face, local) = key.index_parts();
        if self.face == Some(face) {
            self.primary.get(&local)
        } else {
            self.other.get(key)
        }
    }
    fn insert(&mut self, key: crate::GlyphKey, index: u32) {
        let (face, local) = key.index_parts();
        if *self.face.get_or_insert(face) == face {
            self.primary.insert(local, index);
        } else {
            self.other.insert(key, index);
        }
    }
    fn reserve(&mut self, masks: &[Arc<Raster>]) -> Result<(), Error> {
        let face = self
            .face
            .or_else(|| masks.first().map(|m| m.key.index_parts().0));
        let primary = masks
            .iter()
            .filter(|m| Some(m.key.index_parts().0) == face)
            .count();
        self.primary
            .try_reserve(primary)
            .map_err(|_| Error::ResourceLimit)?;
        self.other
            .try_reserve(masks.len() - primary)
            .map_err(|_| Error::ResourceLimit)
    }
    fn clear(&mut self) {
        self.face = None;
        self.primary.clear();
        self.other.clear();
    }
    fn capacity(&self) -> usize {
        self.primary.capacity() + self.other.capacity()
    }
}

#[derive(Default)]
struct DisplayList {
    order: Vec<u32>,
    inline: Vec<InlineDraw>,
    inline_sources: Vec<u32>,
    commons: Vec<Common>,
    group_ranges: Vec<[u32; 2]>,
    placements: Vec<Placement>,
    masks: Vec<Arc<Raster>>,
    mask_index: MaskIndex,
}
#[derive(Clone, Copy)]
enum BorrowedSource<'a> {
    Rect,
    Glyph(&'a Raster),
}
#[derive(Clone, Copy)]
struct BorrowedCommand<'a> {
    rect: Rect,
    clip: Rect,
    map: Mapping,
    source: BorrowedSource<'a>,
    color: [f32; 4],
    bounds: [usize; 4],
}
impl DisplayList {
    fn len(&self) -> usize {
        self.order.len()
    }
    fn clear(&mut self) {
        self.order.clear();
        self.inline.clear();
        self.inline_sources.clear();
        self.commons.clear();
        self.group_ranges.clear();
        self.placements.clear();
        self.masks.clear();
        self.mask_index.clear();
    }
    fn storage(&self) -> SceneStorage {
        SceneStorage {
            header_bytes: size_of::<Self>(),
            order_bytes: self.order.capacity() * size_of::<u32>(),
            inline_bytes: self.inline.capacity() * size_of::<InlineDraw>()
                + self.inline_sources.capacity() * size_of::<u32>(),
            common_bytes: self.commons.capacity() * size_of::<Common>()
                + self.group_ranges.capacity() * size_of::<[u32; 2]>(),
            placement_bytes: self.placements.capacity() * size_of::<Placement>(),
            resource_handles_bytes: self.masks.capacity() * size_of::<Arc<Raster>>(),
            resource_index_capacity: self.mask_index.capacity(),
            resource_entries: self.masks.len(),
        }
    }
    fn bytes(&self) -> usize {
        self.storage().lane_bytes()
    }
    fn iter(&self) -> impl ExactSizeIterator<Item = BorrowedCommand<'_>> + DoubleEndedIterator {
        self.order.iter().map(|&address| self.get(address))
    }
    // Addresses are private and constructed only by admitted appends. Every
    // resource/common/geometry index belongs to this DisplayList; no external
    // stale address can enter this indexing path.
    #[inline]
    fn parts(&self, address: u32) -> (&Common, &Geometry, u32) {
        if address & INLINE_DRAW != 0 {
            let draw = &self.inline[(address & !INLINE_DRAW) as usize];
            (
                &draw.common,
                &draw.geometry,
                self.inline_sources[(address & !INLINE_DRAW) as usize],
            )
        } else {
            let p = &self.placements[address as usize];
            (&self.commons[p.common as usize], &p.geometry, p.source)
        }
    }
    #[inline]
    fn get(&self, address: u32) -> BorrowedCommand<'_> {
        let (common, geometry, source) = self.parts(address);
        BorrowedCommand {
            rect: geometry.rect,
            clip: common.clip,
            map: common.map,
            color: common.color,
            bounds: geometry.bounds.map(usize::from),
            source: if source == RECT_SOURCE {
                BorrowedSource::Rect
            } else {
                BorrowedSource::Glyph(&self.masks[source as usize])
            },
        }
    }
    // Reserve all lanes before publication. Allocation failure can grow capacity
    // but cannot change the published draw sequence or resource table.
    fn reserve(
        &mut self,
        draws: usize,
        resources: &[Arc<Raster>],
        grouped: bool,
    ) -> Result<(), Error> {
        self.order
            .try_reserve(draws)
            .map_err(|_| Error::ResourceLimit)?;
        self.masks
            .try_reserve(resources.len())
            .map_err(|_| Error::ResourceLimit)?;
        self.mask_index.reserve(resources)?;
        if grouped {
            self.commons
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
            self.group_ranges
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
            self.placements
                .try_reserve(draws)
                .map_err(|_| Error::ResourceLimit)?;
        } else {
            self.inline
                .try_reserve(draws)
                .map_err(|_| Error::ResourceLimit)?;
            self.inline_sources
                .try_reserve(draws)
                .map_err(|_| Error::ResourceLimit)?;
        }
        Ok(())
    }
    fn append(
        &mut self,
        common: Common,
        pending: impl IntoIterator<Item = PendingDraw>,
        grouped: bool,
        masks: Vec<Arc<Raster>>,
    ) {
        for mask in masks {
            let index = self.masks.len() as u32;
            self.mask_index.insert(mask.key, index);
            self.masks.push(mask);
        }
        let group = self.commons.len() as u32;
        if grouped {
            self.commons.push(common);
            self.group_ranges.push([self.order.len() as u32; 2]);
        }
        for command in pending {
            let source = command.source;
            let geometry = command.geometry;
            if grouped {
                self.order.push(self.placements.len() as u32);
                self.placements.push(Placement {
                    geometry,
                    common: group,
                    source,
                });
            } else {
                self.order.push(INLINE_DRAW | self.inline.len() as u32);
                self.inline.push(InlineDraw { geometry, common });
                self.inline_sources.push(source);
            }
        }
        if grouped {
            self.group_ranges[group as usize][1] = self.order.len() as u32;
        }
    }
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

/// Exact Vec-capacity ledger. HashMap bucket/control allocation is opaque:
/// resource_index_capacity is an entry count, deliberately not a byte estimate.
/// Mask payload/Arc control blocks and allocator slack are separate ownership.
#[derive(Clone, Copy, Debug, Default)]
pub struct SceneStorage {
    pub header_bytes: usize,
    pub order_bytes: usize,
    pub inline_bytes: usize,
    pub common_bytes: usize,
    pub placement_bytes: usize,
    pub resource_handles_bytes: usize,
    pub resource_index_capacity: usize,
    pub resource_entries: usize,
}
impl SceneStorage {
    pub fn lane_bytes(self) -> usize {
        self.order_bytes
            + self.inline_bytes
            + self.common_bytes
            + self.placement_bytes
            + self.resource_handles_bytes
    }
}

/// Geometry/resource view within one common transform/clip/paint group.
#[derive(Clone, Copy, Debug)]
pub struct PreparedPlacement<'a> {
    pub local_rect: Rect,
    pub bounds: Rect,
    pub mask: Option<GlyphMask<'a>>,
}
/// Borrowed typed group. Backends may upload common state once for all its
/// placements; painter order is exactly the order returned by groups().
#[derive(Clone, Copy)]
pub struct PreparedGroup<'a> {
    pub inverse: [f64; 6],
    pub clip: Rect,
    pub color: [f32; 4],
    commands: &'a DisplayList,
    order: &'a [u32],
}
impl<'a> PreparedGroup<'a> {
    pub fn placements(
        self,
    ) -> impl ExactSizeIterator<Item = PreparedPlacement<'a>> + DoubleEndedIterator {
        self.order.iter().map(move |&address| {
            let (_, geometry, source) = self.commands.parts(address);
            PreparedPlacement {
                local_rect: geometry.rect,
                bounds: device_bounds(geometry.bounds),
                mask: if source == RECT_SOURCE {
                    None
                } else {
                    Some(mask_view(&self.commands.masks[source as usize]))
                },
            }
        })
    }
}
struct Groups<'a> {
    commands: &'a DisplayList,
    front: usize,
    back: usize,
    remaining: usize,
}
impl<'a> Groups<'a> {
    fn view(&self, start: usize, end: usize) -> PreparedGroup<'a> {
        let (common, _, _) = self.commands.parts(self.commands.order[start]);
        PreparedGroup {
            inverse: common.map.inverse,
            clip: common.clip,
            color: common.color,
            commands: self.commands,
            order: &self.commands.order[start..end],
        }
    }
}
impl<'a> Iterator for Groups<'a> {
    type Item = PreparedGroup<'a>;
    fn next(&mut self) -> Option<Self::Item> {
        if self.front == self.back {
            return None;
        }
        let start = self.front;
        let address = self.commands.order[start];
        self.front = if address & INLINE_DRAW != 0 {
            start + 1
        } else {
            self.commands.group_ranges[self.commands.placements[address as usize].common as usize]
                [1] as usize
        };
        self.remaining -= 1;
        Some(self.view(start, self.front))
    }
    fn size_hint(&self) -> (usize, Option<usize>) {
        (self.remaining, Some(self.remaining))
    }
}
impl DoubleEndedIterator for Groups<'_> {
    fn next_back(&mut self) -> Option<Self::Item> {
        if self.front == self.back {
            return None;
        }
        let end = self.back;
        self.back -= 1;
        let address = self.commands.order[self.back];
        if address & INLINE_DRAW == 0 {
            self.back = self.commands.group_ranges
                [self.commands.placements[address as usize].common as usize][0]
                as usize;
        }
        self.remaining -= 1;
        Some(self.view(self.back, end))
    }
}
impl ExactSizeIterator for Groups<'_> {}
#[inline]
fn device_bounds([left, top, right, bottom]: [u16; 4]) -> Rect {
    Rect::new(
        left as f32,
        top as f32,
        (right - left) as f32,
        (bottom - top) as f32,
    )
}
#[inline]
fn mask_view(mask: &Raster) -> GlyphMask<'_> {
    GlyphMask {
        key: mask.key,
        width: mask.metrics.width,
        height: mask.metrics.height,
        coverage: &mask.pixels,
    }
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
    commands: &'a DisplayList,
}
impl<'a> PreparedScene<'a> {
    /// Certify a command-free opaque sRGB/SDR scene for native solid fill.
    /// Returns the exact same0x00RRGGBB word as render_bgrx, without an output
    /// buffer, bins or raster work. Other scenes require the ordinary renderer.
    /// This certifies content only; a host must still submit and acknowledge it.
    pub fn solid_bgrx(self) -> Result<Option<u32>, Error> {
        let pixels = u64::from(self.width) * u64::from(self.height);
        if pixels == 0 || pixels > MAX_PIXELS as u64 || self.width > 16_384 || self.height > 16_384
        {
            return Err(Error::InvalidDimensions);
        }
        self.color_config.validate()?;
        if self.clear.iter().any(|v| !v.is_finite()) || !(0.0..=1.0).contains(&self.clear[3]) {
            return Err(Error::InvalidColor);
        }
        if self.clear[..3].iter().any(|v| v.abs() > 1e20) {
            return Err(Error::ColorOutOfRange);
        }
        if self.commands.len() != 0
            || self.clear[3] != 1.0
            || self.color_config.profile != crate::OutputProfile::Srgb
            || self.color_config.format != crate::PixelFormat::Rgba8Premultiplied
        {
            return Ok(None);
        }
        Ok(Some(pack_bgrx(
            self.color_config.encoder().encode(self.clear),
        )))
    }

    pub fn storage(self) -> SceneStorage {
        self.commands.storage()
    }

    /// Common-state runs and singleton draws, without expanding a second list.
    pub fn groups(self) -> impl ExactSizeIterator<Item = PreparedGroup<'a>> + DoubleEndedIterator {
        Groups {
            commands: self.commands,
            front: 0,
            back: self.commands.order.len(),
            remaining: self.commands.commons.len() + self.commands.inline.len(),
        }
    }
    /// Unique leased masks, in first-admission order. No resource handle clones.
    pub fn masks(self) -> impl ExactSizeIterator<Item = GlyphMask<'a>> + DoubleEndedIterator {
        self.commands.masks.iter().map(|mask| mask_view(mask))
    }

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
                    BorrowedSource::Rect => None,
                    BorrowedSource::Glyph(mask) => Some(GlyphMask {
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
    commands: DisplayList,
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
            commands: DisplayList::default(),
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
        validate_rect(clip)?;
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            color: color.premultiplied(),
        };
        let command = self.prepare(rect, transform, common, RECT_SOURCE)?;
        if let Some(command) = command {
            self.admit(std::slice::from_ref(&command), &[], 0)?;
            self.commands
                .append(common, std::iter::once(command), false, Vec::new());
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
        validate_rect(clip)?;
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            color: color.premultiplied(),
        };
        let mut pending = Vec::with_capacity(layout.glyphs().len());
        let mut resources = Vec::<Arc<Raster>>::new();
        let mut resource_index = HashMap::new();
        let mut pending_bytes = 0;
        let base = self.commands.masks.len();
        for glyph in layout.glyphs() {
            let key = text.raster_key(glyph.id, physical_font_size);
            let existing = self
                .commands
                .mask_index
                .get(&key)
                .copied()
                .or_else(|| resource_index.get(&key).copied());
            // Lookup precedes the font-cache lease. Repeated glyph placements
            // perform no Arc increment/decrement; only unique scene masks lease.
            let new = if existing.is_none() {
                Some(text.raster(glyph.id, physical_font_size)?)
            } else {
                None
            };
            let index = existing.unwrap_or((base + resources.len()) as u32);
            let raster = if let Some(mask) = &new {
                &**mask
            } else if (index as usize) < base {
                &*self.commands.masks[index as usize]
            } else {
                &*resources[index as usize - base]
            };
            let m = raster.metrics;
            let rect = Rect::new(
                origin.x + glyph.x + m.xmin as f32 / raster_scale,
                origin.y + glyph.baseline
                    - m.ymin as f32 / raster_scale
                    - m.height as f32 / raster_scale,
                m.width as f32 / raster_scale,
                m.height as f32 / raster_scale,
            );
            if let Some(command) = self.prepare(rect, transform, common, index)? {
                if let Some(mask) = new {
                    pending_bytes += mask.pixels.len();
                    if self.mask_bytes + pending_bytes > MAX_MASK_BYTES {
                        return Err(Error::ResourceLimit);
                    }
                    resource_index.insert(key, index);
                    resources.push(mask);
                }
                pending.push(command);
            }
        }
        self.admit(&pending, &resources, pending_bytes)?;
        if !pending.is_empty() {
            let grouped = pending.len() > 1;
            self.commands.append(common, pending, grouped, resources);
            self.dirty = true;
        }
        Ok(())
    }
    fn prepare(
        &self,
        rect: Rect,
        transform: Affine,
        common: Common,
        source: u32,
    ) -> Result<Option<PendingDraw>, Error> {
        validate_rect(rect)?;
        let clip = common.clip;
        if rect.is_empty() || clip.is_empty() || common.color[3] == 0.0 {
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
        Ok(Some(PendingDraw {
            geometry: Geometry {
                rect,
                bounds: [left, top, right, bottom].map(|v| v as u16),
            },
            source,
        }))
    }
    fn admit(
        &mut self,
        pending: &[PendingDraw],
        resources: &[Arc<Raster>],
        bytes: usize,
    ) -> Result<(), Error> {
        if self.commands.len() + pending.len() > MAX_COMMANDS {
            return Err(Error::ResourceLimit);
        }
        let mut refs = 0;
        for command in pending {
            let [x, y, r, b] = command.geometry.bounds.map(usize::from);
            refs += ((r - 1) / TILE - x / TILE + 1) * ((b - 1) / TILE - y / TILE + 1);
        }
        if self.references + refs > MAX_REFERENCES || self.mask_bytes + bytes > MAX_MASK_BYTES {
            return Err(Error::ResourceLimit);
        }
        self.commands
            .reserve(pending.len(), resources, pending.len() > 1)?;
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
    /// Render directly into native packed words (0x00RRGGBB), without creating
    /// or updating the optional CPU RGBA image. The destination must contain
    /// exactly width*height words. Only opaque sRGB/RGBA8 output is supported.
    /// Every call renders its supplied buffer; external buffer identity/lifetime
    /// and presentation are owned by the host. Internal cached pixels keep their
    /// existing dirty state, so later diagnostic pixels remain coherent.
    pub fn render_bgrx(&mut self, destination: &mut [u32]) -> Result<(), Error> {
        self.validate_bgrx(destination.len())?;
        self.render_output(&Serial, Some(destination));
        Ok(())
    }
    #[cfg(feature = "parallel")]
    pub fn render_bgrx_with(
        &mut self,
        destination: &mut [u32],
        pool: &RenderPool,
    ) -> Result<(), Error> {
        self.validate_bgrx(destination.len())?;
        self.render_output(pool, Some(destination));
        Ok(())
    }
    fn validate_bgrx(&self, length: usize) -> Result<(), Error> {
        if length != self.width * self.height {
            return Err(Error::InvalidDimensions);
        }
        if self.color_config.format != crate::PixelFormat::Rgba8Premultiplied {
            return Err(Error::UnsupportedPixelFormat);
        }
        if self.color_config.profile != crate::OutputProfile::Srgb {
            return Err(Error::UnsupportedOutputProfile);
        }
        if self.clear[3] != 1.0 {
            return Err(Error::NonOpaqueOutput);
        }
        Ok(())
    }
    fn render(&mut self, schedule: &impl RenderSchedule) {
        self.render_output(schedule, None);
    }
    fn render_output(&mut self, schedule: &impl RenderSchedule, external: Option<&mut [u32]>) {
        let columns = self.width.div_ceil(TILE);
        let rows = self.height.div_ceil(TILE);
        let tiles = columns * rows;
        self.offsets.clear();
        self.offsets.resize(tiles + 1, 0);
        for command in self.commands.iter() {
            visit_tiles(&command, columns, |tile| self.offsets[tile + 1] += 1);
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
            visit_tiles(&command, columns, |tile| {
                self.indices[self.cursor[tile]] = index as u32;
                self.cursor[tile] += 1;
            });
        }
        let mut stats = RenderStats {
            render_count: self.stats.render_count.saturating_add(1),
            commands: self.commands.len(),
            tile_references: self.references,
            retained_mask_bytes: self.mask_bytes,
            command_bytes: self.commands.bytes(),
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
        let rendered = if let Some(words) = external {
            schedule.render(frame, BgrxEncoder(self.color_config.encoder()), words)
        } else {
            match self.color_config.format {
                crate::PixelFormat::Rgba8Premultiplied => {
                    schedule.render(frame, self.color_config.encoder(), &mut self.pixels)
                }
                crate::PixelFormat::Rgba16Float => {
                    schedule.render(frame, self.color_config.half_encoder(), &mut self.pixels)
                }
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
    commands: &'a DisplayList,
    offsets: &'a [usize],
    indices: &'a [u32],
    tile_proofs: bool,
}

/// Format dispatch happens once per frame, not through a pixel function pointer.
pub(crate) trait PixelWriter: Copy + Send + Sync {
    type Element: Copy + Default + Send + Sync;
    const ELEMENTS: usize;
    fn write(self, color: [f32; 4], destination: &mut [Self::Element]);
}
impl PixelWriter for crate::color::OutputEncoder {
    type Element = u8;
    const ELEMENTS: usize = 4;
    #[inline]
    fn write(self, color: [f32; 4], destination: &mut [u8]) {
        destination.copy_from_slice(&self.encode(color));
    }
}
#[derive(Clone, Copy)]
struct BgrxEncoder(crate::color::OutputEncoder);
impl PixelWriter for BgrxEncoder {
    type Element = u32;
    const ELEMENTS: usize = 1;
    #[inline]
    fn write(self, color: [f32; 4], destination: &mut [u32]) {
        destination[0] = pack_bgrx(self.0.encode(color));
    }
}
fn pack_bgrx([red, green, blue, _]: [u8; 4]) -> u32 {
    (u32::from(red) << 16) | (u32::from(green) << 8) | u32::from(blue)
}
trait RenderSchedule {
    fn render<W: PixelWriter>(
        &self,
        frame: Frame<'_>,
        writer: W,
        pixels: &mut [W::Element],
    ) -> RenderStats;
}
struct Serial;
impl RenderSchedule for Serial {
    fn render<W: PixelWriter>(
        &self,
        frame: Frame<'_>,
        writer: W,
        pixels: &mut [W::Element],
    ) -> RenderStats {
        pixels
            .chunks_mut(TILE * frame.width * W::ELEMENTS)
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
        pixels: &mut [W::Element],
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
                    && matches!(command.source, BorrowedSource::Rect)
                    && full_tile(&command, 0, 0, frame.width, frame.height);
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
                .par_chunks_mut(TILE * frame.width * W::ELEMENTS)
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
    pixels: &mut [W::Element],
) -> RenderStats {
    let columns = frame.width.div_ceil(TILE);
    let mut stats = RenderStats::default();
    let mut scratch = [[0.0f32; 4]; TILE * TILE * 16];
    // All admitted writers emit at most eight elements. These fixed local buffers
    // cache uniform colors without a heap allocation or repeated transfer work.
    let mut clear = [W::Element::default(); 8];
    writer.write(frame.clear, &mut clear[..W::ELEMENTS]);
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
                    let command = frame.commands.get(frame.commands.order[*index as usize]);
                    command.color[3] == 1.0
                        && matches!(command.source, BorrowedSource::Rect)
                        && full_tile(&command, left, top, right, bottom)
                })
                .unwrap_or(0)
        } else {
            0
        };
        stats.skipped_command_tiles += start;
        let mut uniform = Some(frame.clear);
        for &index in &ordered[start..] {
            let command = frame.commands.get(frame.commands.order[index as usize]);
            let full = frame.tile_proofs
                && matches!(command.source, BorrowedSource::Rect)
                && full_tile(&command, left, top, right, bottom);
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
                        sample(&command, x, y, &mut stats)
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
            writer.write(color, &mut uniform_bytes[..W::ELEMENTS]);
        }
        for y in top..bottom {
            for x in left..right {
                let offset = ((y - top) * frame.width + x) * W::ELEMENTS;
                let destination = &mut pixels[offset..offset + W::ELEMENTS];
                if uniform_color.is_some() {
                    destination.copy_from_slice(&uniform_bytes[..W::ELEMENTS]);
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
fn visit_tiles(command: &BorrowedCommand<'_>, columns: usize, mut visit: impl FnMut(usize)) {
    let [x, y, r, b] = command.bounds;
    for ty in y / TILE..=(b - 1) / TILE {
        for tx in x / TILE..=(r - 1) / TILE {
            visit(ty * columns + tx);
        }
    }
}
fn full_tile(
    command: &BorrowedCommand<'_>,
    left: usize,
    top: usize,
    right: usize,
    bottom: usize,
) -> bool {
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
fn sample(command: &BorrowedCommand<'_>, x: usize, y: usize, stats: &mut RenderStats) -> [f32; 16] {
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
                BorrowedSource::Rect => {
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
                BorrowedSource::Glyph(mask) => mask_sample(
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
    // The raster backend has already integrated outline coverage into each raster cell.
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
        // Uniform nonzero coverage makes accidental edge inclusion or an
        // interior lookup rounded beyond the last texel directly observable.
        let mask = Raster {
            key: crate::text::GlyphKey::fixture(),
            metrics: crate::text::RasterMetrics {
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
