use crate::text::{LayoutView, Raster, SharedGlyphs};
use crate::{
    Affine, Color, ColorConfig, DamageRegion, Error, Image, ImageKey, ImageSampling, ImageView,
    Point, Rect, TextLayout, TextSystem,
};
#[cfg(any(feature = "simd", test))]
use fearless_simd::Level;
use fearless_simd::Simd;
#[cfg(feature = "simd")]
use fearless_simd::dispatch;
use std::{collections::HashMap, sync::Arc};

mod clips;
pub use clips::{
    Clip, ClipChain, ClipGeometry, ClipId, ClipShape, MAX_CLIP_DEPTH, MAX_CLIP_NODES,
    PreparedClipNode,
};
mod columns;
use columns::{Columns, PaintUse, StoredCommon};
pub use columns::{
    PaintColor, PaintSlot, PreparedPaint, SlotCommit, SlotEdit, SlotError, SlotErrorKind,
};
mod bins;
use bins::RasterScratch;
mod glyph_axis;
mod image_axis;
mod mask_kernel;
mod metric_scale;
use metric_scale::MetricScale;
mod paint;
pub use paint::{PaintCommit, PaintEdit, PaintError, PaintErrorKind, PaintIndex};
mod rounded;
pub use rounded::rounded_rect_contains;
mod samples;
#[cfg(test)]
mod simd_tests;
use glyph_axis::GlyphAxis;
use samples::Samples;

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
    /// Command references in the tiles rasterized by this call, before opacity cuts.
    pub tile_references: usize,
    pub full_rect_tiles: usize,
    pub skipped_command_tiles: usize,
    pub boundary_pixels: usize,
    /// Geometric membership/address queries. Separable axes share queries
    /// across tile rows and columns instead of mapping every 2D sample.
    pub sample_tests: usize,
    pub retained_mask_bytes: usize,
    /// Exact capacities of typed draw/resource Vec lanes; excludes opaque
    /// HashMap bucket/control allocation, raster bodies and Canvas header.
    pub command_bytes: usize,
    /// CSR vector capacity bytes; excludes the lazy scratch header.
    pub bin_bytes: usize,
    /// Number of disjoint 16-row output bands rendered in this frame.
    pub output_bands: usize,
    pub parallel: bool,
    /// This raster reused geometry bins; color changes can revoke opaque cuts.
    pub bins_reused: bool,
}

#[derive(Clone, Copy)]
struct Mapping {
    inverse: [f64; 6],
}
impl Mapping {
    fn axis_aligned(self) -> bool {
        self.inverse[1] == 0.0 && self.inverse[2] == 0.0
    }
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
    validate_sampled_domain(rect, parent, viewport)?;
    if transform.b != 0.0 || transform.c != 0.0 {
        return Err(Error::InvalidGeometry);
    }
    let map = Mapping::new(transform)?;
    Ok(lower_sampled_rect(&map, rect, parent, viewport))
}

fn validate_sampled_domain(rect: Rect, parent: Rect, viewport: [u32; 2]) -> Result<(), Error> {
    validate_rect(rect)?;
    validate_rect(parent)?;
    let [width, height] = viewport;
    let pixels = u64::from(width) * u64::from(height);
    if pixels == 0 || pixels > MAX_PIXELS as u64 || width > 16_384 || height > 16_384 {
        return Err(Error::InvalidDimensions);
    }
    Ok(())
}

fn lower_sampled_rect(map: &Mapping, rect: Rect, parent: Rect, [width, height]: [u32; 2]) -> Rect {
    if rect.is_empty() || parent.is_empty() {
        return Rect::default();
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
            return Rect::default();
        }
        *interval = [first, end];
    }
    let [[left, right], [top, bottom]] = intervals;
    // Midpoints between lattice samples preserve ordinary integer clip edges.
    // Every integer here is <=65536, so all products/sums are exact in f32.
    Rect::new(
        left as f32 * 0.25,
        top as f32 * 0.25,
        (right - left) as f32 * 0.25,
        (bottom - top) as f32 * 0.25,
    )
}

// One source of retained draw order. Compact typed lanes share text-run state;
// the renderer and exported scene resolve the same checked private addresses.
const INLINE_GLYPH: u16 = u16::MAX;
const RECT_SOURCE: u32 = u32::MAX;
const ROUNDED_SOURCE: u32 = 1 << 31;
const IMAGE_SOURCE: u32 = 1 << 30;
const NEAREST_SOURCE: u32 = 1 << 29;
const GRADIENT_SOURCE: u32 = 1 << 28;
const RESOURCE_INDEX: u32 = GRADIENT_SOURCE - 1;
fn resource_material(source: u32) -> bool {
    source & ROUNDED_SOURCE == 0 && source & (IMAGE_SOURCE | GRADIENT_SOURCE) != 0
}
const _: () = assert!(MAX_COMMANDS <= u16::MAX as usize + 1);
// Each published image/mask resource has at least one admitted placement.
// Rounded radii keep all 31 positive-f32 bits; the NaN sentinel remains Rect.
const _: () = assert!(MAX_COMMANDS < NEAREST_SOURCE as usize);

#[derive(Clone, Copy)]
struct Common {
    clip: Rect,
    map: Mapping,
    // Solid/glyph: premultiplied color. Image: [local radius,0,0,1].
    // Source tags choose the meaning; image filters never consume solid paint.
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
    common: StoredCommon,
    rect: Rect,
    source: u32,
}
struct CommonGroup {
    common: StoredCommon,
    range: [u32; 2],
    glyphs: SharedGlyphs,
    origin: Point,
    scale: MetricScale,
}
// A raster witness, not expanded glyph geometry. The glyph positions live only
// in the shared packed owner. Cached admitted bounds avoid repeating forward
// transform/clip work in CSR, compatibility iterators and every tile visit.
#[derive(Clone, Copy)]
struct DrawRef {
    bounds: [u16; 4],
    command: u16,
    glyph: u16,
    mask: u16,
}
impl DrawRef {
    fn inline(self) -> bool {
        self.glyph == INLINE_GLYPH
    }
}
const _: () = assert!(size_of::<DrawRef>() == 14);
fn glyph_rect(origin: Point, [x, baseline]: [f32; 2], raster: &Raster, scale: MetricScale) -> Rect {
    let m = raster.metrics;
    let [xmin, ymin, width, height] = scale.apply([
        m.xmin as f32,
        m.ymin as f32,
        m.width as f32,
        m.height as f32,
    ]);
    Rect::new(
        origin.x + x + xmin,
        origin.y + baseline - ymin - height,
        width,
        height,
    )
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
    fn reserve_key(&mut self, key: crate::GlyphKey) -> Result<(), Error> {
        let (face, _) = key.index_parts();
        if self.face.is_none_or(|primary| primary == face) {
            self.primary.try_reserve(1)
        } else {
            self.other.try_reserve(1)
        }
        .map_err(|_| Error::ResourceLimit)
    }
    fn remove(&mut self, key: crate::GlyphKey) {
        let (face, local) = key.index_parts();
        if self.face == Some(face) {
            self.primary.remove(&local);
        } else {
            self.other.remove(&key);
        }
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
    order: Vec<DrawRef>,
    inline: Vec<InlineDraw>,
    commons: Vec<CommonGroup>,
    columns: Columns,
    masks: Vec<Arc<Raster>>,
    mask_index: MaskIndex,
    images: Option<Box<ImageResources>>,
}
#[derive(Default)]
struct ImageResources {
    clips: Option<Box<clips::ClipArena>>,
    values: Vec<Image>,
    index: HashMap<ImageKey, u32>,
    bytes: usize,
    gradients: Option<Box<GradientResources>>,
}
#[derive(Default)]
struct GradientResources {
    values: Vec<(crate::GradientKey, Option<crate::Gradient>)>,
    index: HashMap<crate::GradientKey, u32>,
    bytes: usize,
}
#[derive(Clone, Copy)]
enum BorrowedSource<'a> {
    Rect,
    Rounded(f32),
    Glyph(&'a Raster),
    ImageNearest(&'a Image),
    ImageLinear(&'a Image),
    Gradient {
        key: crate::GradientKey,
        lease: Option<&'a crate::Gradient>,
    },
}
impl<'a> BorrowedSource<'a> {
    fn material_color(self, paint: [f32; 4]) -> [f32; 4] {
        match self {
            Self::ImageNearest(_) | Self::ImageLinear(_) | Self::Gradient { .. } => [1.0; 4],
            _ => paint,
        }
    }
    fn prepared(self, paint: [f32; 4]) -> PreparedSource<'a> {
        match self {
            Self::Rect => PreparedSource::Solid,
            Self::Rounded(radius) => PreparedSource::RoundedRect(radius),
            Self::Glyph(mask) => PreparedSource::Mask(mask_view(mask)),
            Self::Gradient { lease, .. } => PreparedSource::Gradient {
                gradient: lease.expect("canonical gradient lease").view(),
                radius: paint[0],
            },
            Self::ImageNearest(image) => PreparedSource::Image {
                radius: paint[0],
                image: image.view(),
                sampling: ImageSampling::Nearest,
            },
            Self::ImageLinear(image) => PreparedSource::Image {
                radius: paint[0],
                image: image.view(),
                sampling: ImageSampling::Linear,
            },
        }
    }
}
#[derive(Clone, Copy)]
struct BorrowedCommand<'a> {
    rect: Rect,
    clip: Rect,
    map: Mapping,
    source: BorrowedSource<'a>,
    clip_chain: Option<ClipChain<'a>>,
    color: [f32; 4],
    bounds: [usize; 4],
}
impl BorrowedCommand<'_> {
    fn unchanged(self, other: Self) -> bool {
        fn rect_bits(rect: Rect) -> [u32; 4] {
            [rect.x, rect.y, rect.width, rect.height].map(f32::to_bits)
        }
        self.bounds == other.bounds
            && rect_bits(self.rect) == rect_bits(other.rect)
            && rect_bits(self.clip) == rect_bits(other.clip)
            && self.map.inverse.map(f64::to_bits) == other.map.inverse.map(f64::to_bits)
            && self.color.map(f32::to_bits) == other.color.map(f32::to_bits)
            && match (self.clip_chain, other.clip_chain) {
                (None, None) => true,
                (Some(a), Some(b)) => a.same(b),
                _ => false,
            }
            && match (self.source, other.source) {
                (BorrowedSource::Rect, BorrowedSource::Rect) => true,
                (BorrowedSource::Rounded(left), BorrowedSource::Rounded(right)) => {
                    left.to_bits() == right.to_bits()
                }
                (
                    BorrowedSource::Gradient { key: left, .. },
                    BorrowedSource::Gradient { key: right, .. },
                ) => left == right,
                (BorrowedSource::Glyph(left), BorrowedSource::Glyph(right)) => {
                    // Both immutable leases are alive during comparison, so
                    // allocation identity cannot undergo reuse here.
                    std::ptr::eq(left, right)
                }
                (BorrowedSource::ImageNearest(left), BorrowedSource::ImageNearest(right))
                | (BorrowedSource::ImageLinear(left), BorrowedSource::ImageLinear(right)) => {
                    left == right
                }
                _ => false,
            }
    }
}
impl DisplayList {
    fn len(&self) -> usize {
        self.order.len()
    }
    fn clear(&mut self) {
        self.order.clear();
        self.inline.clear();
        self.commons.clear();
        self.columns.clear();
        self.masks.clear();
        self.mask_index.clear();
        self.images = None;
    }
    fn storage(&self) -> SceneStorage {
        SceneStorage {
            header_bytes: size_of::<Self>(),
            resource_header_bytes: self.images.as_ref().map_or(0, |r| {
                size_of::<ImageResources>()
                    + r.gradients
                        .as_ref()
                        .map_or(0, |_| size_of::<GradientResources>())
                    + r.clips
                        .as_ref()
                        .map_or(0, |_| size_of::<clips::ClipArena>())
            }),
            order_bytes: self.order.capacity() * size_of::<DrawRef>(),
            inline_bytes: self.inline.capacity() * size_of::<InlineDraw>(),
            common_bytes: self.commons.capacity() * size_of::<CommonGroup>() + self.columns.bytes(),
            placement_bytes: 0,
            clip_node_bytes: self.clip_geometry().map_or(0, ClipGeometry::node_bytes),
            resource_handles_bytes: self.masks.capacity() * size_of::<Arc<Raster>>()
                + self.images.as_ref().map_or(0, |r| {
                    r.values.capacity() * size_of::<Image>()
                        + r.gradients.as_ref().map_or(0, |g| {
                            g.values.capacity()
                                * size_of::<(crate::GradientKey, Option<crate::Gradient>)>()
                        })
                }),
            resource_index_capacity: self.mask_index.capacity()
                + self.images.as_ref().map_or(0, |r| {
                    r.index.capacity() + r.gradients.as_ref().map_or(0, |g| g.index.capacity())
                }),
            resource_entries: self.masks.len()
                + self.images.as_ref().map_or(0, |r| {
                    r.values.len() + r.gradients.as_ref().map_or(0, |g| g.values.len())
                })
                + self
                    .clip_geometry()
                    .map_or(0, |geometry| geometry.nodes().len()),
        }
    }
    fn bytes(&self) -> usize {
        self.storage().lane_bytes()
    }
    fn iter(
        &self,
        viewport: Rect,
    ) -> impl ExactSizeIterator<Item = BorrowedCommand<'_>> + DoubleEndedIterator {
        self.order
            .iter()
            .map(move |&address| self.get(address, viewport))
    }
    /// Device-clipped integer bounds in painter order. CSR construction needs
    /// no material, resource lease, inverse mapping, or command reconstruction.
    fn ordered_bounds(&self) -> impl ExactSizeIterator<Item = [u16; 4]> + DoubleEndedIterator {
        self.order.iter().map(|address| address.bounds)
    }
    // Private witnesses are published only after the complete text transaction
    // succeeds. Every index belongs to this scene and its immutable packed owner.
    #[inline]
    fn state(&self, address: DrawRef) -> (StoredCommon, u32) {
        if address.inline() {
            let draw = &self.inline[usize::from(address.command)];
            (draw.common, draw.source)
        } else {
            (
                self.commons[usize::from(address.command)].common,
                u32::from(address.mask),
            )
        }
    }
    #[inline]
    fn stored(&self, address: DrawRef) -> (StoredCommon, Geometry, u32) {
        let (common, source) = self.state(address);
        let rect = if address.inline() {
            self.inline[usize::from(address.command)].rect
        } else {
            let run = &self.commons[usize::from(address.command)];
            glyph_rect(
                run.origin,
                run.glyphs.position(address.glyph),
                &self.masks[usize::from(address.mask)],
                run.scale,
            )
        };
        (
            common,
            Geometry {
                rect,
                bounds: address.bounds,
            },
            source,
        )
    }
    #[inline]
    fn source(&self, source: u32) -> BorrowedSource<'_> {
        if source == RECT_SOURCE {
            BorrowedSource::Rect
        } else if source & ROUNDED_SOURCE != 0 {
            BorrowedSource::Rounded(f32::from_bits(source & !ROUNDED_SOURCE))
        } else if source & GRADIENT_SOURCE != 0 {
            let (key, lease) = &self
                .images
                .as_ref()
                .unwrap()
                .gradients
                .as_ref()
                .unwrap()
                .values[(source & RESOURCE_INDEX) as usize];
            BorrowedSource::Gradient {
                key: *key,
                lease: lease.as_ref(),
            }
        } else if source & IMAGE_SOURCE != 0 {
            let image = &self.images.as_ref().unwrap().values[(source & RESOURCE_INDEX) as usize];
            if source & NEAREST_SOURCE != 0 {
                BorrowedSource::ImageNearest(image)
            } else {
                BorrowedSource::ImageLinear(image)
            }
        } else {
            BorrowedSource::Glyph(&self.masks[source as usize])
        }
    }
    #[inline]
    fn get(&self, address: DrawRef, viewport: Rect) -> BorrowedCommand<'_> {
        let (stored, geometry, source) = self.stored(address);
        let image = resource_material(source);
        let common = self.columns.resolve(stored, viewport, image);
        BorrowedCommand {
            rect: geometry.rect,
            clip: self.clip_bounds(common.clip),
            clip_chain: self.clip_chain(common.clip),
            map: common.map,
            color: common.color,
            bounds: geometry.bounds.map(usize::from),
            source: self.source(source),
        }
    }
    fn reserve_inline(&mut self) -> Result<(), Error> {
        self.order
            .try_reserve(1)
            .map_err(|_| Error::ResourceLimit)?;
        self.inline.try_reserve(1).map_err(|_| Error::ResourceLimit)
    }
    fn reserve_draws(&mut self, additional: usize) -> Result<(), Error> {
        let required = self.order.len() + additional;
        if required <= self.order.capacity() {
            return Ok(());
        }
        if let Some(previous) = self.commons.last() {
            let quantum = (previous.range[1] - previous.range[0]) as usize;
            // Inline draws do not participate in the text growth quantum.
            let inline = self.inline.len();
            let capacity = ((required - inline).div_ceil(quantum).next_power_of_two() * quantum
                + inline)
                .min(MAX_COMMANDS);
            self.order.try_reserve_exact(capacity - self.order.len())
        } else {
            self.order.try_reserve(additional)
        }
        .map_err(|_| Error::ResourceLimit)
    }
    fn append_inline(
        &mut self,
        common: Common,
        command: PendingDraw,
        viewport: Rect,
        shared: Option<PaintSlot>,
    ) {
        let image = resource_material(command.source);
        let common = self.columns.store(common, viewport, shared, image);
        if !image {
            self.columns.support(
                common.paint,
                DamageRegion::checked_canvas_bounds(command.geometry.bounds.map(usize::from)),
                command.source == RECT_SOURCE,
            );
        }
        self.order.push(DrawRef {
            bounds: command.geometry.bounds,
            command: self.inline.len() as u16,
            glyph: INLINE_GLYPH,
            mask: 0,
        });
        self.inline.push(InlineDraw {
            common,
            rect: command.geometry.rect,
            source: command.source,
        });
    }
    fn publish_group(
        &mut self,
        start: usize,
        common: StoredCommon,
        glyphs: SharedGlyphs,
        origin: Point,
        scale: MetricScale,
    ) {
        for address in &self.order[start..] {
            self.columns.support(
                common.paint,
                DamageRegion::checked_canvas_bounds(address.bounds.map(usize::from)),
                false,
            );
        }
        self.commons.push(CommonGroup {
            common,
            range: [start as u32, self.order.len() as u32],
            glyphs,
            origin,
            scale,
        });
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

#[derive(Clone, Copy, Debug)]
pub enum PreparedSource<'a> {
    Solid,
    /// Uniform circular corners in local units, clamped to half each extent.
    /// This is sampled analytic geometry, not a bitmap or integrated area.
    RoundedRect(f32),
    Gradient {
        gradient: crate::GradientView<'a>,
        radius: f32,
    },
    Mask(GlyphMask<'a>),
    Image {
        image: ImageView<'a>,
        sampling: ImageSampling,
        radius: f32,
    },
}
impl<'a> PreparedSource<'a> {
    pub fn dimensions(self) -> Option<[usize; 2]> {
        match self {
            Self::Solid | Self::RoundedRect(_) | Self::Gradient { .. } => None,
            Self::Mask(mask) => Some([mask.width, mask.height]),
            Self::Image { image, .. } => Some([image.width() as usize, image.height() as usize]),
        }
    }
    pub fn mask(self) -> Option<GlyphMask<'a>> {
        if let Self::Mask(mask) = self {
            Some(mask)
        } else {
            None
        }
    }
    pub fn image(self) -> Option<(ImageView<'a>, ImageSampling)> {
        if let Self::Image {
            image, sampling, ..
        } = self
        {
            Some((image, sampling))
        } else {
            None
        }
    }
    pub fn corner_radius(self) -> Option<f32> {
        match self {
            Self::RoundedRect(radius) => Some(radius),
            Self::Gradient { radius, .. } if radius != 0.0 => Some(radius),
            Self::Image { radius, .. } if radius != 0.0 => Some(radius),
            _ => None,
        }
    }
    pub fn gradient(self) -> Option<(crate::GradientView<'a>, f32)> {
        if let Self::Gradient { gradient, radius } = self {
            Some((gradient, radius))
        } else {
            None
        }
    }
    pub fn is_solid(self) -> bool {
        matches!(self, Self::Solid)
    }
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
    pub source: PreparedSource<'a>,
    pub clip_chain: Option<ClipChain<'a>>,
}

impl PreparedDraw<'_> {
    /// Lower this draw's rectangular local domain onto the fixed 4×4 lattice.
    /// This checks rectangular membership only; rounded corners and material
    /// sampling remain separate. The inverse must be finite and axis-aligned,
    /// within the Canvas inverse-magnitude limit of 1e12.
    pub fn sampled_rect_clip(&self, viewport: [u32; 2]) -> Result<Rect, Error> {
        if self.clip_chain.is_some() {
            return Err(Error::InvalidGeometry);
        }
        validate_sampled_domain(self.local_rect, self.clip, viewport)?;
        let map = Mapping {
            inverse: self.inverse,
        };
        if !map.axis_aligned()
            || map.inverse[0] == 0.0
            || map.inverse[3] == 0.0
            || map.inverse.iter().any(|v| !v.is_finite() || v.abs() > 1e12)
        {
            return Err(Error::InvalidGeometry);
        }
        Ok(lower_sampled_rect(
            &map,
            self.local_rect,
            self.clip,
            viewport,
        ))
    }
}

/// Exact Vec-capacity ledger. HashMap bucket/control allocation is opaque:
/// resource_index_capacity is an entry count, deliberately not a byte estimate.
/// Mask payload/Arc control blocks and allocator slack are separate ownership.
#[derive(Clone, Copy, Debug, Default)]
pub struct SceneStorage {
    pub header_bytes: usize,
    /// Separately boxed resource-vector/index headers. Excludes allocator
    /// metadata, resource payloads, and opaque hash-table allocation overhead.
    pub resource_header_bytes: usize,
    /// Direct painter-indexed raster witnesses, including cached device bounds.
    pub order_bytes: usize,
    pub inline_bytes: usize,
    pub common_bytes: usize,
    /// Legacy expanded geometry lane; zero for retained packed-text scenes.
    pub placement_bytes: usize,
    /// Capacity of immutable parent-linked clip nodes, absent for flat clips.
    pub clip_node_bytes: usize,
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
            + self.clip_node_bytes
            + self.resource_handles_bytes
    }
}

/// Geometry/resource view within one common transform/clip/paint group.
#[derive(Clone, Copy, Debug)]
pub struct PreparedPlacement<'a> {
    pub local_rect: Rect,
    pub bounds: Rect,
    pub source: PreparedSource<'a>,
}
/// Borrowed typed group. Backends may upload common state once for all its
/// placements; painter order is exactly the order returned by groups().
#[derive(Clone, Copy)]
pub struct PreparedGroup<'a> {
    pub inverse: [f64; 6],
    pub clip: Rect,
    pub color: [f32; 4],
    commands: &'a DisplayList,
    order: &'a [DrawRef],
}
impl<'a> PreparedGroup<'a> {
    pub fn clip_chain(self) -> Option<ClipChain<'a>> {
        let (stored, source) = self.commands.state(self.order[0]);
        let common = self
            .commands
            .columns
            .resolve(stored, self.clip, resource_material(source));
        self.commands.clip_chain(common.clip)
    }
    /// Device bounds in painter order, without expanding packed text positions.
    pub fn bounds(self) -> impl ExactSizeIterator<Item = Rect> + DoubleEndedIterator {
        self.order
            .iter()
            .map(|address| device_bounds(address.bounds))
    }

    /// Material views in painter order, without reconstructing local geometry.
    pub fn sources(
        self,
    ) -> impl ExactSizeIterator<Item = PreparedSource<'a>> + DoubleEndedIterator {
        self.order.iter().map(move |&address| {
            let (stored, source) = self.commands.state(address);
            self.commands
                .source(source)
                .prepared([stored.image_radius(), 0.0, 0.0, 1.0])
        })
    }

    /// Shared working paint relationship in this canonical scene, if present.
    pub fn paint_slot(self) -> Option<PaintSlot> {
        let (stored, source) = self.commands.state(self.order[0]);
        if resource_material(source) {
            return None;
        }
        self.commands.columns.shared_slot(stored.paint)
    }

    pub fn placements(
        self,
    ) -> impl ExactSizeIterator<Item = PreparedPlacement<'a>> + DoubleEndedIterator {
        self.order.iter().map(move |&address| {
            let (stored, geometry, source) = self.commands.stored(address);
            PreparedPlacement {
                local_rect: geometry.rect,
                bounds: device_bounds(geometry.bounds),
                source: self.commands.source(source).prepared([
                    stored.image_radius(),
                    0.0,
                    0.0,
                    1.0,
                ]),
            }
        })
    }
}
struct Groups<'a> {
    commands: &'a DisplayList,
    extent: [u16; 2],
    front: usize,
    back: usize,
    remaining: usize,
}
impl<'a> Groups<'a> {
    fn view(&self, start: usize, end: usize) -> PreparedGroup<'a> {
        let address = self.commands.order[start];
        let (stored, source) = self.commands.state(address);
        let image = resource_material(source);
        let common = self
            .commands
            .columns
            .resolve(stored, extent_rect(self.extent), image);
        PreparedGroup {
            inverse: common.map.inverse,
            clip: self.commands.clip_bounds(common.clip),
            color: if resource_material(source) {
                [1.0; 4]
            } else {
                common.color
            },
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
        self.front = if address.inline() {
            start + 1
        } else {
            self.commands.commons[usize::from(address.command)].range[1] as usize
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
        if !address.inline() {
            self.back = self.commands.commons[usize::from(address.command)].range[0] as usize;
        }
        self.remaining -= 1;
        Some(self.view(self.back, end))
    }
}
impl ExactSizeIterator for Groups<'_> {}
#[inline]
fn viewport_rect(width: usize, height: usize) -> Rect {
    Rect::new(0.0, 0.0, width as f32, height as f32)
}
#[inline]
fn extent_rect([width, height]: [u16; 2]) -> Rect {
    viewport_rect(width as usize, height as usize)
}
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
///
/// Lazy draw expansion still borrows the scene, including its mask pixels.
///
/// ```compile_fail,E0505
/// let canvas = gpui_canvas::Canvas::new(16, 16).unwrap();
/// let draws = canvas.prepared_scene().draws();
/// drop(canvas);
/// let _ = draws.count();
/// ```
#[derive(Clone, Copy)]
pub struct PreparedScene<'a> {
    pub width: u32,
    pub height: u32,
    pub color_config: ColorConfig,
    pub clear: [f32; 4],
    commands: &'a DisplayList,
    extent: [u16; 2],
}
impl<'a> PreparedScene<'a> {
    /// Prefix ending at the last shared row. Positions include intervening
    /// literal rows so a slot has the same checked address in every backend.
    pub fn paint_bank(
        self,
    ) -> impl ExactSizeIterator<Item = PreparedPaint> + DoubleEndedIterator + 'a {
        self.commands.columns.bank()
    }

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
            extent: self.extent,
            front: 0,
            back: self.commands.order.len(),
            remaining: self.commands.commons.len() + self.commands.inline.len(),
        }
    }
    /// Unique leased masks, in first-admission order. No resource handle clones.
    pub fn masks(self) -> impl ExactSizeIterator<Item = GlyphMask<'a>> + DoubleEndedIterator {
        self.commands.masks.iter().map(|mask| mask_view(mask))
    }
    /// Unique immutable image leases, borrowed without cloning a resource.
    pub fn clip_nodes(self) -> impl DoubleEndedIterator<Item = PreparedClipNode> {
        self.commands
            .clip_geometry()
            .into_iter()
            .flat_map(ClipGeometry::nodes)
    }
    pub fn images(self) -> impl DoubleEndedIterator<Item = ImageView<'a>> {
        self.commands
            .images
            .iter()
            .flat_map(|r| r.values.iter().map(Image::view))
    }

    pub fn gradients(self) -> impl DoubleEndedIterator<Item = crate::GradientView<'a>> {
        self.commands
            .images
            .iter()
            .flat_map(|r| r.gradients.iter())
            .flat_map(|r| {
                r.values
                    .iter()
                    .map(|(_, lease)| lease.as_ref().expect("canonical lease").view())
            })
    }

    pub fn draws(self) -> impl ExactSizeIterator<Item = PreparedDraw<'a>> + DoubleEndedIterator {
        self.commands.iter(extent_rect(self.extent)).map(|command| {
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
                color: command.source.material_color(command.color),
                source: command.source.prepared(command.color),
                clip_chain: command.clip_chain,
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
    raster: Option<Box<RasterScratch>>,
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
            raster: None,
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
    fn damage_from(&self, previous: &Self) -> DamageRegion {
        let full = DamageRegion::checked_canvas_bounds([0, 0, self.width, self.height]);
        if previous.width != self.width
            || previous.height != self.height
            || previous.color_config != self.color_config
            || previous.clear.map(f32::to_bits) != self.clear.map(f32::to_bits)
        {
            return full;
        }
        let mut damage = DamageRegion::default();
        let mut previous = previous
            .commands
            .iter(viewport_rect(previous.width, previous.height));
        let mut next = self.commands.iter(viewport_rect(self.width, self.height));
        // Zip may consume an unmatched item from its first iterator. Bound the
        // shared prefix explicitly so removals retain their old support.
        for _ in 0..previous.len().min(next.len()) {
            let old = previous.next().unwrap();
            let new = next.next().unwrap();
            if !old.unchanged(new) {
                damage = damage
                    .union(DamageRegion::checked_canvas_bounds(old.bounds))
                    .union(DamageRegion::checked_canvas_bounds(new.bounds));
                if damage == full {
                    return full;
                }
            }
        }
        for command in previous.chain(next) {
            damage = damage.union(DamageRegion::checked_canvas_bounds(command.bounds));
            if damage == full {
                return full;
            }
        }
        damage
    }
    pub fn prepared_scene(&self) -> PreparedScene<'_> {
        PreparedScene {
            width: self.width as u32,
            height: self.height as u32,
            color_config: self.color_config,
            clear: self.clear,
            commands: &self.commands,
            extent: [self.width as u16, self.height as u16],
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
        self.invalidate_bins();
        self.commands.clear();
        self.mask_bytes = 0;
        self.references = 0;
        self.clear = color.premultiplied();
        self.dirty = true;
    }
    /// Clip is a canvas rectangle or a capability created by `create_clip`.
    /// Singular/ill-conditioned transforms and out-of-domain geometry return errors.
    pub fn fill_rect(
        &mut self,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
    ) -> Result<(), Error> {
        self.fill_shape(
            rect,
            transform,
            clip.into(),
            PaintColor::new(color),
            RECT_SOURCE,
            PaintUse::Literal,
        )
    }
    /// Sample a rounded rectangle at the same 4×4 lattice as other commands.
    /// Radius is finite/nonnegative and is clamped against the local extents;
    /// zero uses the existing rectangular command and proof path exactly.
    /// This does not install a rounded descendant clip.
    pub fn fill_rounded_rect(
        &mut self,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
    ) -> Result<(), Error> {
        rounded::validate_radius(radius)?;
        let source = if radius == 0.0 {
            RECT_SOURCE
        } else {
            ROUNDED_SOURCE | radius.to_bits()
        };
        self.fill_shape(
            rect,
            transform,
            clip.into(),
            PaintColor::new(color),
            source,
            PaintUse::Literal,
        )
    }
    pub fn fill_rect_slot(
        &mut self,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        slot: PaintSlot,
    ) -> Result<(), Error> {
        self.fill_shape(
            rect,
            transform,
            clip.into(),
            self.slot_color(slot)?,
            RECT_SOURCE,
            PaintUse::Existing(slot),
        )
    }
    pub fn fill_rounded_rect_slot(
        &mut self,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
        slot: PaintSlot,
    ) -> Result<(), Error> {
        rounded::validate_radius(radius)?;
        let source = if radius == 0.0 {
            RECT_SOURCE
        } else {
            ROUNDED_SOURCE | radius.to_bits()
        };
        self.fill_shape(
            rect,
            transform,
            clip.into(),
            self.slot_color(slot)?,
            source,
            PaintUse::Existing(slot),
        )
    }
    #[allow(clippy::too_many_arguments)]
    fn fill_shape(
        &mut self,
        rect: Rect,
        transform: Affine,
        clip: Clip,
        color: PaintColor,
        source: u32,
        paint: PaintUse<'_>,
    ) -> Result<(), Error> {
        let clip = self.resolve_clip(clip)?;
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            color: color.0,
        };
        let command = self.prepare(rect, transform, common, source)?;
        if let Some(command) = command {
            self.commands.columns.admit(
                common,
                viewport_rect(self.width, self.height),
                paint.reference(),
                resource_material(source),
                paint.new_shared(),
            )?;
            self.admit(&command)?;
            let shared = paint.commit(&mut self.commands.columns, color);
            self.commands.append_inline(
                common,
                command,
                viewport_rect(self.width, self.height),
                shared,
            );
            self.dirty = true;
        }
        Ok(())
    }
    /// Initialize the shared row only if a command is actually admitted.
    /// A populated positional cache reuses its current owned bank color; use
    /// prepare_slots for transactional changes instead of passing a new initial.
    #[allow(clippy::too_many_arguments)]
    pub fn fill_rounded_rect_shared(
        &mut self,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
        initial: PaintColor,
        cache: &mut Option<PaintSlot>,
    ) -> Result<(), Error> {
        rounded::validate_radius(radius)?;
        let value = if let Some(slot) = *cache {
            self.slot_color(slot)?
        } else {
            initial
        };
        let source = if radius == 0.0 {
            RECT_SOURCE
        } else {
            ROUNDED_SOURCE | radius.to_bits()
        };
        self.fill_shape(
            rect,
            transform,
            clip.into(),
            value,
            source,
            PaintUse::Shared(cache),
        )
    }
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled_shared<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        initial: PaintColor,
        cache: &mut Option<PaintSlot>,
        raster_scale: f32,
    ) -> Result<(), Error> {
        let value = if let Some(slot) = *cache {
            self.slot_color(slot)?
        } else {
            initial
        };
        self.draw_text_working(
            text,
            layout.view(),
            origin,
            transform,
            clip.into(),
            value,
            raster_scale,
            PaintUse::Shared(cache),
        )
    }
    /// Analytic gradient paint, sampled at the same correlated 4×4 sites as
    /// coverage. Only a distinct immutable resource obtains a canonical lease.
    pub fn fill_gradient(
        &mut self,
        gradient: &crate::Gradient,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
    ) -> Result<(), Error> {
        self.fill_gradient_with(gradient, rect, radius, transform, clip.into(), false)
    }
    fn fill_gradient_with(
        &mut self,
        gradient: &crate::Gradient,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: Clip,
        previous_lease: bool,
    ) -> Result<(), Error> {
        rounded::validate_radius(radius)?;
        let clip = self.resolve_clip(clip)?;
        let resources = self
            .commands
            .images
            .as_deref()
            .and_then(|r| r.gradients.as_deref());
        let existing = resources.and_then(|r| r.index.get(&gradient.key()).copied());
        let index = existing.unwrap_or_else(|| resources.map_or(0, |r| r.values.len() as u32));
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            color: [radius, 0.0, 0.0, 1.0],
        };
        let Some(command) = self.prepare(rect, transform, common, GRADIENT_SOURCE | index)? else {
            return Ok(());
        };
        let mut unpublished = None;
        if existing.is_none() {
            let total = resources
                .map_or(0, |r| r.bytes)
                .checked_add(gradient.view().byte_len())
                .ok_or(Error::ResourceLimit)?;
            if total
                .checked_add(self.commands.images.as_ref().map_or(0, |r| r.bytes))
                .is_none_or(|b| b > crate::MAX_IMAGE_SCENE_BYTES)
            {
                return Err(Error::ResourceLimit);
            }
            let r = if let Some(r) = &mut self.commands.images {
                r.as_mut()
            } else {
                unpublished
                    .insert(Box::<ImageResources>::default())
                    .as_mut()
            };
            let gradients = r.gradients.get_or_insert_with(Default::default);
            gradients
                .values
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
            gradients
                .index
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
        }
        self.commands.columns.admit(
            common,
            viewport_rect(self.width, self.height),
            None,
            true,
            false,
        )?;
        self.admit(&command)?;
        if unpublished.is_some() {
            self.commands.images = unpublished;
        }
        if existing.is_none() {
            let r = self
                .commands
                .images
                .as_mut()
                .unwrap()
                .gradients
                .as_mut()
                .unwrap();
            r.values.push((
                gradient.key(),
                if previous_lease {
                    None
                } else {
                    Some(gradient.clone())
                },
            ));
            r.index.insert(gradient.key(), index);
            r.bytes += gradient.view().byte_len();
        }
        self.commands.append_inline(
            common,
            command,
            viewport_rect(self.width, self.height),
            None,
        );
        self.dirty = true;
        Ok(())
    }
    /// Reconstruct immutable pixels across `rect`, using linear-premultiplied
    /// texel colors. Geometry/clip use the same sample sites as other draws.
    pub fn draw_image(
        &mut self,
        image: &Image,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        sampling: ImageSampling,
    ) -> Result<(), Error> {
        self.draw_image_with(
            image,
            rect,
            transform,
            clip,
            crate::ImageOptions {
                sampling,
                corner_radius: 0.0,
            },
        )
    }
    pub fn draw_image_with(
        &mut self,
        image: &Image,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        options: crate::ImageOptions,
    ) -> Result<(), Error> {
        self.draw_image_working(image, rect, transform, clip.into(), options)
    }
    fn draw_image_working(
        &mut self,
        image: &Image,
        rect: Rect,
        transform: Affine,
        clip: Clip,
        options: crate::ImageOptions,
    ) -> Result<(), Error> {
        let crate::ImageOptions {
            sampling,
            corner_radius,
        } = options;
        rounded::validate_radius(corner_radius)?;
        let clip = self.resolve_clip(clip)?;
        let resources = self.commands.images.as_deref();
        let existing = resources.and_then(|r| r.index.get(&image.key()).copied());
        let index = existing.unwrap_or_else(|| resources.map_or(0, |r| r.values.len() as u32));
        let source = IMAGE_SOURCE
            | index
            | if sampling == ImageSampling::Nearest {
                NEAREST_SOURCE
            } else {
                0
            };
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            // Image material is reconstructed from the resource. These private
            // solid-color lanes are a tagged image shape payload; public views
            // still expose canonical white rather than an authored tint.
            color: [corner_radius, 0.0, 0.0, 1.0],
        };
        let Some(command) = self.prepare(rect, transform, common, source)? else {
            return Ok(());
        };
        let mut unpublished = None;
        if existing.is_none() {
            let bytes = resources
                .map_or(0, |r| r.bytes)
                .checked_add(image.pixel_bytes())
                .ok_or(Error::ResourceLimit)?;
            if bytes
                .checked_add(
                    resources
                        .and_then(|r| r.gradients.as_deref())
                        .map_or(0, |g| g.bytes),
                )
                .is_none_or(|b| b > crate::MAX_IMAGE_SCENE_BYTES)
            {
                return Err(Error::ResourceLimit);
            }
            let resources = if let Some(resources) = &mut self.commands.images {
                resources.as_mut()
            } else {
                unpublished
                    .insert(Box::<ImageResources>::default())
                    .as_mut()
            };
            resources
                .values
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
            resources
                .index
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
        }
        self.commands.columns.admit(
            common,
            viewport_rect(self.width, self.height),
            None,
            true,
            false,
        )?;
        self.admit(&command)?;
        if unpublished.is_some() {
            self.commands.images = unpublished;
        }
        if existing.is_none() {
            let resources = self.commands.images.as_mut().unwrap();
            resources.values.push(image.clone());
            resources.index.insert(image.key(), index);
            resources.bytes += image.pixel_bytes();
        }
        self.commands.append_inline(
            common,
            command,
            viewport_rect(self.width, self.height),
            None,
        );
        self.dirty = true;
        Ok(())
    }
    /// Origin and layout positions are local to transform. Layout and glyph masks
    /// belong to the same immutable FontFace. No text is reshaped during painting.
    pub fn draw_text<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
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
    pub fn draw_text_scaled<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
        raster_scale: f32,
    ) -> Result<(), Error> {
        self.draw_text_working(
            text,
            layout.view(),
            origin,
            transform,
            clip.into(),
            PaintColor::new(color),
            raster_scale,
            PaintUse::Literal,
        )
    }
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled_slot<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        slot: PaintSlot,
        raster_scale: f32,
    ) -> Result<(), Error> {
        self.draw_text_working(
            text,
            layout.view(),
            origin,
            transform,
            clip.into(),
            self.slot_color(slot)?,
            raster_scale,
            PaintUse::Existing(slot),
        )
    }
    #[allow(clippy::too_many_arguments)]
    fn draw_text_working(
        &mut self,
        text: &mut TextSystem,
        layout: LayoutView<'_>,
        origin: Point,
        transform: Affine,
        clip: Clip,
        color: PaintColor,
        raster_scale: f32,
        paint: PaintUse<'_>,
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
        let clip = self.resolve_clip(clip)?;
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            color: color.0,
        };
        let metric_scale = MetricScale::new(raster_scale);
        // Prepare the final unpublished raster-witness tail. A singleton stays
        // inline and never retains a scene lease on the packed glyph owner.
        let order_start = self.commands.order.len();
        let mask_start = self.commands.masks.len();
        let primary_face = self.commands.mask_index.face;
        let group = self.commands.commons.len() as u16;
        let mut first = None;
        let mut count = 0;
        let mut bytes = 0;
        let mut references = 0;
        let admitted = (|| {
            for (glyph_index, glyph) in layout.glyphs().enumerate() {
                let key = text.layout_key(layout, glyph, physical_font_size)?;
                let existing = self.commands.mask_index.get(&key).copied();
                // Deduplicate before leasing: repeated placements and later
                // labels never increment the raster's Arc strong count.
                let new = if existing.is_none() {
                    Some(text.layout_raster(layout, glyph, physical_font_size)?)
                } else {
                    None
                };
                let index = existing.unwrap_or(self.commands.masks.len() as u32);
                let raster = new
                    .as_deref()
                    .unwrap_or_else(|| &self.commands.masks[index as usize]);
                let rect = glyph_rect(origin, [glyph.x, glyph.baseline], raster, metric_scale);
                let Some(command) = self.prepare(rect, transform, common, index)? else {
                    continue;
                };
                let [x, y, r, b] = command.geometry.bounds.map(usize::from);
                references += ((r - 1) / TILE - x / TILE + 1) * ((b - 1) / TILE - y / TILE + 1);
                count += 1;
                if order_start + count > MAX_COMMANDS
                    || self.references + references > MAX_REFERENCES
                {
                    return Err(Error::ResourceLimit);
                }
                if let Some(mask) = new {
                    bytes += mask.pixels.len();
                    if self.mask_bytes + bytes > MAX_MASK_BYTES {
                        return Err(Error::ResourceLimit);
                    }
                    self.commands
                        .masks
                        .try_reserve(1)
                        .map_err(|_| Error::ResourceLimit)?;
                    self.commands.mask_index.reserve_key(key)?;
                    self.commands.mask_index.insert(key, index);
                    self.commands.masks.push(mask);
                }
                let witness = DrawRef {
                    bounds: command.geometry.bounds,
                    command: group,
                    glyph: glyph_index as u16,
                    mask: index as u16,
                };
                if count == 1 {
                    first = Some((command, witness));
                } else {
                    self.commands
                        .reserve_draws(if count == 2 { 2 } else { 1 })?;
                    if count == 2 {
                        self.commands.order.push(first.as_ref().unwrap().1);
                    }
                    self.commands.order.push(witness);
                }
            }
            if count > 1 {
                self.commands
                    .commons
                    .try_reserve(1)
                    .map_err(|_| Error::ResourceLimit)?;
            } else if count == 1 {
                self.commands.reserve_inline()?;
            }
            if count != 0 {
                self.commands.columns.admit(
                    common,
                    viewport_rect(self.width, self.height),
                    paint.reference(),
                    false,
                    paint.new_shared(),
                )?;
            }
            Ok(())
        })();
        if let Err(error) = admitted {
            // No published columns, painter order, counters, bins or pixels changed.
            // Remove only keys introduced by this draw, including other faces.
            self.commands.order.truncate(order_start);
            for mask in self.commands.masks.drain(mask_start..) {
                self.commands.mask_index.remove(mask.key);
            }
            self.commands.mask_index.face = primary_face;
            return Err(error);
        }
        if count != 0 {
            let viewport = viewport_rect(self.width, self.height);
            let shared = paint.commit(&mut self.commands.columns, color);
            if count == 1 {
                self.commands
                    .append_inline(common, first.unwrap().0, viewport, shared);
            } else {
                let common = self.commands.columns.store(common, viewport, shared, false);
                self.commands.publish_group(
                    order_start,
                    common,
                    layout.shared_glyphs(),
                    origin,
                    metric_scale,
                );
            }
            self.mask_bytes += bytes;
            self.references += references;
            self.invalidate_bins();
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
        let clip = self.commands.clip_bounds(common.clip);
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
    fn admit(&mut self, command: &PendingDraw) -> Result<(), Error> {
        let [x, y, r, b] = command.geometry.bounds.map(usize::from);
        let refs = ((r - 1) / TILE - x / TILE + 1) * ((b - 1) / TILE - y / TILE + 1);
        if self.commands.len() == MAX_COMMANDS || self.references + refs > MAX_REFERENCES {
            return Err(Error::ResourceLimit);
        }
        self.commands.reserve_inline()?;
        self.references += refs;
        self.invalidate_bins();
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
        self.render_output(&Serial, Some(destination), None);
        Ok(())
    }
    /// Repair tiles intersecting `region` in a preserved external image.
    /// The caller owns buffer-age validation and must ensure the remaining
    /// pixels already match this scene. This never changes diagnostic pixels.
    pub fn render_bgrx_region(
        &mut self,
        destination: &mut [u32],
        region: DamageRegion,
    ) -> Result<(), Error> {
        self.validate_bgrx(destination.len())?;
        self.render_output(&Serial, Some(destination), Some(region));
        Ok(())
    }
    #[cfg(feature = "parallel")]
    pub fn render_bgrx_with(
        &mut self,
        destination: &mut [u32],
        pool: &RenderPool,
    ) -> Result<(), Error> {
        self.validate_bgrx(destination.len())?;
        self.render_output(pool, Some(destination), None);
        Ok(())
    }
    #[cfg(feature = "parallel")]
    pub fn render_bgrx_region_with(
        &mut self,
        destination: &mut [u32],
        region: DamageRegion,
        pool: &RenderPool,
    ) -> Result<(), Error> {
        self.validate_bgrx(destination.len())?;
        self.render_output(pool, Some(destination), Some(region));
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
        self.render_output(schedule, None, None);
    }
    fn render_output(
        &mut self,
        schedule: &impl RenderSchedule,
        external: Option<&mut [u32]>,
        region: Option<DamageRegion>,
    ) {
        let [left, top, right, bottom] = region
            .map_or([0, 0, self.width as u32, self.height as u32], |region| {
                region.bounds().unwrap_or_default()
            });
        let tile_bounds = [
            (left as usize).min(self.width) / TILE,
            (top as usize).min(self.height) / TILE,
            (right as usize).min(self.width).div_ceil(TILE),
            (bottom as usize).min(self.height).div_ceil(TILE),
        ];
        if tile_bounds[0] == tile_bounds[2] || tile_bounds[1] == tile_bounds[3] {
            self.stats = RenderStats {
                render_count: self.stats.render_count,
                commands: self.commands.len(),
                retained_mask_bytes: self.mask_bytes,
                command_bytes: self.commands.bytes(),
                bin_bytes: self.bin_bytes(),
                ..RenderStats::default()
            };
            return;
        }
        let raster = self.raster.get_or_insert_with(Box::default);
        let bins_reused = raster.prepare(&self.commands, tile_bounds);
        let mut stats = RenderStats {
            render_count: self.stats.render_count.saturating_add(1),
            commands: self.commands.len(),
            retained_mask_bytes: self.mask_bytes,
            command_bytes: self.commands.bytes(),
            bin_bytes: raster.bytes(),
            bins_reused,
            ..RenderStats::default()
        };
        let (raster_bounds, offsets, members) = raster.rows(tile_bounds);
        let frame = Frame {
            width: self.width,
            height: self.height,
            clear: self.clear,
            commands: &self.commands,
            raster_bounds,
            tile_proofs: self.tile_proofs,
            tile_bounds,
        };
        let rendered = if let Some(words) = external {
            schedule.render(
                frame,
                BgrxEncoder(self.color_config.encoder()),
                words,
                offsets,
                members,
            )
        } else {
            match self.color_config.format {
                crate::PixelFormat::Rgba8Premultiplied => schedule.render(
                    frame,
                    self.color_config.encoder(),
                    &mut self.pixels,
                    offsets,
                    members,
                ),
                crate::PixelFormat::Rgba16Float => schedule.render(
                    frame,
                    self.color_config.half_encoder(),
                    &mut self.pixels,
                    offsets,
                    members,
                ),
            }
        };
        stats.tile_references = rendered.tile_references;
        stats.full_rect_tiles = rendered.full_rect_tiles;
        stats.skipped_command_tiles = rendered.skipped_command_tiles;
        stats.boundary_pixels = rendered.boundary_pixels;
        stats.sample_tests = rendered.sample_tests;
        stats.output_bands = tile_bounds[3] - tile_bounds[1];
        stats.parallel = rendered.parallel;
        self.stats = stats;
    }
    fn bin_bytes(&self) -> usize {
        self.raster.as_ref().map_or(0, |raster| raster.bytes())
    }
    fn invalidate_bins(&mut self) {
        if let Some(raster) = &mut self.raster {
            raster.invalidate();
        }
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
    raster_bounds: [u16; 4],
    tile_proofs: bool,
    tile_bounds: [usize; 4],
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
        offsets: &[u32],
        members: &mut [u32],
    ) -> RenderStats;
}
struct Serial;
impl RenderSchedule for Serial {
    fn render<W: PixelWriter>(
        &self,
        frame: Frame<'_>,
        writer: W,
        pixels: &mut [W::Element],
        offsets: &[u32],
        members: &mut [u32],
    ) -> RenderStats {
        render_region(frame, writer, pixels, offsets, members, false)
    }
}
fn combine_stats(mut left: RenderStats, right: RenderStats) -> RenderStats {
    left.tile_references += right.tile_references;
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
        offsets: &[u32],
        members: &mut [u32],
    ) -> RenderStats {
        // Estimate distinguishes a proven uniform viewport fill from sampled
        // edges/text. It chooses scheduling only and cannot affect the pixels.
        let pixel_bounds = [
            frame.tile_bounds[0] * TILE,
            frame.tile_bounds[1] * TILE,
            (frame.tile_bounds[2] * TILE).min(frame.width),
            (frame.tile_bounds[3] * TILE).min(frame.height),
        ];
        let mut work = (pixel_bounds[2] - pixel_bounds[0]) * (pixel_bounds[3] - pixel_bounds[1]);
        // The estimate is monotone. Once this lower bound reaches the threshold,
        // no later command can change the scheduling decision.
        if work < self.min_work {
            for command in frame
                .commands
                .iter(viewport_rect(frame.width, frame.height))
            {
                let [left, top, right, bottom] = command.bounds;
                let area = right
                    .min(pixel_bounds[2])
                    .saturating_sub(left.max(pixel_bounds[0]))
                    * bottom
                        .min(pixel_bounds[3])
                        .saturating_sub(top.max(pixel_bounds[1]));
                let uniform = frame.tile_proofs
                    && matches!(command.source, BorrowedSource::Rect)
                    && full_tile(&command, 0, 0, frame.width, frame.height);
                work = work.saturating_add(if uniform { area / 256 } else { area * 16 });
                if work >= self.min_work {
                    break;
                }
            }
        }
        if work < self.min_work || frame.height <= TILE {
            return Serial.render(frame, writer, pixels, offsets, members);
        }
        let mut stats = self
            .pool
            .install(|| render_region(frame, writer, pixels, offsets, members, true));
        stats.parallel = true;
        stats
    }
}

/// Every reference span is contiguous across physical rows, including empty
/// tiles. Splitting at an offset boundary grants each worker exclusive access
/// to its cache words and matching output bands, without a temporary collection.
fn render_region<W: PixelWriter>(
    frame: Frame<'_>,
    writer: W,
    pixels: &mut [W::Element],
    offsets: &[u32],
    members: &mut [u32],
    parallel: bool,
) -> RenderStats {
    let stride = frame.width * W::ELEMENTS;
    let first = frame.tile_bounds[1] * TILE * stride;
    let end = (frame.tile_bounds[3] * TILE).min(frame.height) * stride;
    render_rows(
        frame,
        writer,
        &mut pixels[first..end],
        offsets,
        members,
        parallel,
    )
}
fn render_rows<W: PixelWriter>(
    frame: Frame<'_>,
    writer: W,
    pixels: &mut [W::Element],
    offsets: &[u32],
    members: &mut [u32],
    _parallel: bool,
) -> RenderStats {
    let rows = frame.tile_bounds[3] - frame.tile_bounds[1];
    if rows == 1 {
        return render_band(frame, writer, pixels, offsets, members);
    }
    let middle = frame.tile_bounds[1] + rows / 2;
    let columns = usize::from(frame.raster_bounds[2] - frame.raster_bounds[0]);
    let boundary = (rows / 2) * columns;
    let (left_members, right_members) =
        members.split_at_mut((offsets[boundary] - offsets[0]) as usize);
    let (left_pixels, right_pixels) =
        pixels.split_at_mut((rows / 2) * TILE * frame.width * W::ELEMENTS);
    let mut left = frame;
    left.tile_bounds[3] = middle;
    let mut right = frame;
    right.tile_bounds[1] = middle;
    let mut render_left = move || {
        render_rows(
            left,
            writer,
            left_pixels,
            &offsets[..=boundary],
            left_members,
            _parallel,
        )
    };
    let mut render_right = move || {
        render_rows(
            right,
            writer,
            right_pixels,
            &offsets[boundary..],
            right_members,
            _parallel,
        )
    };
    #[cfg(feature = "parallel")]
    let (left, right) = if _parallel {
        rayon::join(render_left, render_right)
    } else {
        (render_left(), render_right())
    };
    #[cfg(not(feature = "parallel"))]
    let (left, right) = (render_left(), render_right());
    combine_stats(left, right)
}

// Keep the large sample tile only on leaf stacks, never on recursive frames.
#[inline(never)]
fn render_band<W: PixelWriter>(
    frame: Frame<'_>,
    writer: W,
    pixels: &mut [W::Element],
    offsets: &[u32],
    members: &mut [u32],
) -> RenderStats {
    #[cfg(not(feature = "simd"))]
    return render_band_impl(
        fearless_simd::Fallback::new(),
        frame,
        writer,
        pixels,
        offsets,
        members,
    );
    #[cfg(feature = "simd")]
    // Four f64 lattice sites share a geometry kernel. Use the guaranteed
    // target baseline, avoiding CPU detection and retained startup state.
    // Additional ISA variants must earn their complete raster-body cost.
    dispatch!(Level::baseline(), simd => render_band_impl(simd, frame, writer, pixels, offsets, members))
}

// Each band carries its geometry token. The original array-shaped blend and
// image pipeline stays shared, allowing LLVM to vectorize its four RGBA lanes.
#[inline(never)]
fn render_band_impl<W: PixelWriter, S: Simd>(
    simd: S,
    frame: Frame<'_>,
    writer: W,
    pixels: &mut [W::Element],
    offsets: &[u32],
    members: &mut [u32],
) -> RenderStats {
    let band_index = frame.tile_bounds[1];
    let columns = frame.tile_bounds[2] - frame.tile_bounds[0];
    let mut stats = RenderStats::default();
    let mut samples = Samples::new();
    // All admitted writers emit at most eight elements. These fixed local buffers
    // cache uniform colors without a heap allocation or repeated transfer work.
    let mut clear = [W::Element::default(); 8];
    writer.write(frame.clear, &mut clear[..W::ELEMENTS]);
    // Exact adjacent working colors share one output conversion. Compare bits
    // so HDR positive/negative zeros remain distinct; this is not quantization.
    let mut encoded_color = frame.clear.map(f32::to_bits);
    let mut encoded_bytes = clear;
    let first = frame.tile_bounds[0] - usize::from(frame.raster_bounds[0]);
    let base = offsets[0];
    for column in 0..columns {
        let tile = first + column;
        let ordered =
            &mut members[(offsets[tile] - base) as usize..(offsets[tile + 1] - base) as usize];
        stats.tile_references += ordered.len();
        let left = (frame.tile_bounds[0] + column) * TILE;
        let top = band_index * TILE;
        let right = (left + TILE).min(frame.width);
        let bottom = (top + TILE).min(frame.height);
        let start = if frame.tile_proofs {
            if let Some(cut) = bins::cached_cut(ordered) {
                cut
            } else {
                let cut = ordered
                    .iter()
                    .rposition(|&word| {
                        let address = frame.commands.order[bins::ordinal(word)];
                        // Retained text is always mask material. It cannot cut
                        // an opaque backdrop, so do not expand its geometry.
                        if !address.inline() {
                            return false;
                        }
                        let command = frame
                            .commands
                            .get(address, viewport_rect(frame.width, frame.height));
                        can_discard_backdrop(command.color)
                            && matches!(command.source, BorrowedSource::Rect)
                            && full_tile(&command, left, top, right, bottom)
                    })
                    .unwrap_or(0);
                bins::cache_cut(ordered, cut);
                cut
            }
        } else {
            0
        };
        stats.skipped_command_tiles += start;
        let mut uniform = Some(frame.clear);
        for &index in &ordered[start..] {
            let command = frame.commands.get(
                frame.commands.order[bins::ordinal(index)],
                viewport_rect(frame.width, frame.height),
            );
            let full = frame.tile_proofs
                && matches!(command.source, BorrowedSource::Rect)
                && full_tile(&command, left, top, right, bottom);
            if full {
                stats.full_rect_tiles += 1;
                if let Some(value) = &mut uniform {
                    blend(value, command.color, 1.0);
                    continue;
                }
            }
            let axis = if !full
                && matches!(command.source, BorrowedSource::Rect)
                && command.clip_chain.is_none()
                && command.map.axis_aligned()
            {
                match AxisCoverage::new(&command, [left, top, right, bottom], &mut stats) {
                    Some(axis) => Some(axis),
                    None => continue,
                }
            } else {
                None
            };
            let glyph_axis = if matches!(command.source, BorrowedSource::Glyph(_))
                && command.map.axis_aligned()
            {
                match GlyphAxis::new(&command, [left, top, right, bottom], &mut stats) {
                    Some(axis) => Some(axis),
                    None => continue,
                }
            } else {
                None
            };
            if !full && let Some(value) = uniform.take() {
                // A uniform prefix needs no tile storage until an edge or
                // glyph makes its sample colors differ.
                samples.reset(value, frame.tile_proofs);
            }
            if let BorrowedSource::Gradient { lease, .. } = command.source {
                render_gradient(
                    simd,
                    &mut samples,
                    &command,
                    [left, top, right, bottom],
                    &mut stats,
                    lease.expect("canonical lease").view(),
                );
                continue;
            }
            let image = match command.source {
                BorrowedSource::ImageNearest(image) => Some((image.view(), ImageSampling::Nearest)),
                BorrowedSource::ImageLinear(image) => Some((image.view(), ImageSampling::Linear)),
                _ => None,
            };
            if let Some((image, sampling)) = image {
                let bounds = [left, top, right, bottom];
                render_image_command(&mut samples, &command, bounds, &mut stats, image, sampling);
                continue;
            }
            for y in top.max(command.bounds[1])..bottom.min(command.bounds[3]) {
                for x in left.max(command.bounds[0])..right.min(command.bounds[2]) {
                    let pixel = (y - top) * TILE + x - left;
                    if full {
                        samples.blend_mask(pixel, command.color, u16::MAX);
                    } else if let Some(axis) = &axis {
                        stats.boundary_pixels += 1;
                        let mask = (axis.x[x - left] * 0x1111) & axis.y[y - top];
                        samples.blend_mask(pixel, command.color, mask);
                    } else if let Some(axis) = &glyph_axis {
                        stats.boundary_pixels += 1;
                        let mut coverage = axis.coverage(x - left, y - top);
                        if let Some(chain) = command.clip_chain {
                            let mask = chain.mask(simd, x, y, &mut stats);
                            for (index, value) in coverage.iter_mut().enumerate() {
                                if mask & (1 << index) == 0 {
                                    *value = 0.0;
                                }
                            }
                        }
                        samples.blend(pixel, command.color, coverage);
                    } else {
                        stats.boundary_pixels += 1;
                        if matches!(
                            command.source,
                            BorrowedSource::Rect | BorrowedSource::Rounded(_)
                        ) {
                            samples.blend_mask(
                                pixel,
                                command.color,
                                mask_kernel::coverage(simd, &command, x, y, &mut stats),
                            );
                        } else {
                            samples.blend(pixel, command.color, sample(&command, x, y, &mut stats));
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
        if uniform_color.is_some() {
            write_uniform_tile::<W>(pixels, frame.width, left, right, &uniform_bytes);
            continue;
        }
        for y in top..bottom {
            for x in left..right {
                let offset = ((y - top) * frame.width + x) * W::ELEMENTS;
                let destination = &mut pixels[offset..offset + W::ELEMENTS];
                let color = samples.color((y - top) * TILE + x - left);
                let bits = color.map(f32::to_bits);
                if bits != encoded_color {
                    writer.write(color, &mut encoded_bytes[..W::ELEMENTS]);
                    encoded_color = bits;
                }
                destination.copy_from_slice(&encoded_bytes[..W::ELEMENTS]);
            }
        }
    }
    stats
}

// Keep the encoded uniform-row loop's few live values separate from the large
// raster band. One checked row span owns the output bounds; sample reduction and
// color-cache state never enter this path. All writers and SIMD policies share it.
#[inline(never)]
fn write_uniform_tile<W: PixelWriter>(
    pixels: &mut [W::Element],
    width: usize,
    left: usize,
    right: usize,
    encoded: &[W::Element; 8],
) {
    for row in pixels.chunks_exact_mut(width * W::ELEMENTS) {
        for pixel in row[left * W::ELEMENTS..right * W::ELEMENTS].chunks_exact_mut(W::ELEMENTS) {
            pixel.copy_from_slice(&encoded[..W::ELEMENTS]);
        }
    }
}

// Keep image dispatch and its typed closures out of the common raster loop.
// In particular, adding an image path must not duplicate that dispatch in each
// output-format loop or extend the live ranges of ordinary rect/glyph state.
#[inline(never)]
fn render_image_command(
    samples: &mut Samples,
    command: &BorrowedCommand<'_>,
    bounds: [usize; 4],
    stats: &mut RenderStats,
    image: ImageView<'_>,
    sampling: ImageSampling,
) {
    let radius = match command.source {
        BorrowedSource::ImageNearest(_) | BorrowedSource::ImageLinear(_) => command.color[0],
        _ => 0.0,
    };
    if radius > 0.0 {
        render_rounded_image(samples, command, bounds, stats, image, sampling, radius);
    } else if image.needs_decode_memo() {
        render_cached_image(samples, command, bounds, stats, image, sampling);
    } else if command.clip_chain.is_none() && command.map.axis_aligned() {
        image_axis::render(samples, command, bounds, stats, image, sampling, |x, y| {
            image.texel(x, y)
        });
    } else {
        render_image(samples, command, bounds, stats, |x, y| {
            image.sample(
                x,
                y,
                command.rect.width as f64,
                command.rect.height as f64,
                sampling,
            )
        });
    }
}

#[inline(never)]
fn render_gradient<S: Simd>(
    simd: S,
    samples: &mut Samples,
    command: &BorrowedCommand<'_>,
    [left, top, right, bottom]: [usize; 4],
    stats: &mut RenderStats,
    gradient: crate::GradientView<'_>,
) {
    let mut shape = *command;
    shape.source = if command.color[0] == 0.0 {
        BorrowedSource::Rect
    } else {
        BorrowedSource::Rounded(command.color[0])
    };
    for y in top.max(command.bounds[1])..bottom.min(command.bounds[3]) {
        for x in left.max(command.bounds[0])..right.min(command.bounds[2]) {
            let mask = mask_kernel::coverage(simd, &shape, x, y, stats);
            let sources = std::array::from_fn(|i| {
                if mask & (1 << i) == 0 {
                    return None;
                }
                let (lx, ly) = command
                    .map
                    .local(x as f64 + SAMPLES[i % 4], y as f64 + SAMPLES[i / 4]);
                Some(gradient.sample_normalized([
                    ((lx - command.rect.x as f64) / command.rect.width as f64) as f32,
                    ((ly - command.rect.y as f64) / command.rect.height as f64) as f32,
                ]))
            });
            samples.blend_sources((y - top) * TILE + x - left, sources);
            stats.boundary_pixels += 1;
        }
    }
}

#[inline(never)]
fn render_rounded_image(
    samples: &mut Samples,
    command: &BorrowedCommand<'_>,
    bounds: [usize; 4],
    stats: &mut RenderStats,
    image: ImageView<'_>,
    sampling: ImageSampling,
    radius: f32,
) {
    if image.needs_decode_memo() {
        crate::image::with_decode_memo(image, |sampler| {
            render_shaped_image(samples, command, bounds, stats, radius, |x, y| {
                sampler.sample(
                    x,
                    y,
                    command.rect.width as f64,
                    command.rect.height as f64,
                    sampling,
                )
            });
        });
    } else {
        render_shaped_image(samples, command, bounds, stats, radius, |x, y| {
            image.sample(
                x,
                y,
                command.rect.width as f64,
                command.rect.height as f64,
                sampling,
            )
        });
    }
}
fn render_shaped_image(
    samples: &mut Samples,
    command: &BorrowedCommand<'_>,
    bounds: [usize; 4],
    stats: &mut RenderStats,
    radius: f32,
    mut sample: impl FnMut(f64, f64) -> Option<[f32; 4]>,
) {
    render_image(samples, command, bounds, stats, |x, y| {
        let local = Rect::new(0.0, 0.0, command.rect.width, command.rect.height);
        if rounded::contains(local, radius, x, y) {
            sample(x, y)
        } else {
            None
        }
    });
}

// Keep image-only scratch off image-free raster frames. Direct linear/HDR and
// straight-sRGB byte-table inputs never construct or initialize a decode memo.
#[inline(never)]
fn render_cached_image(
    samples: &mut Samples,
    command: &BorrowedCommand<'_>,
    bounds: [usize; 4],
    stats: &mut RenderStats,
    image: ImageView<'_>,
    sampling: ImageSampling,
) {
    crate::image::with_decode_memo(image, |sampler| {
        if command.clip_chain.is_none() && command.map.axis_aligned() {
            image_axis::render(samples, command, bounds, stats, image, sampling, |x, y| {
                sampler.texel(x, y)
            });
            return;
        }
        render_image(samples, command, bounds, stats, |x, y| {
            sampler.sample(
                x,
                y,
                command.rect.width as f64,
                command.rect.height as f64,
                sampling,
            )
        });
    });
}
#[inline(never)]
fn render_image(
    samples: &mut Samples,
    command: &BorrowedCommand<'_>,
    [left, top, right, bottom]: [usize; 4],
    stats: &mut RenderStats,
    mut sample: impl FnMut(f64, f64) -> Option<[f32; 4]>,
) {
    for y in top.max(command.bounds[1])..bottom.min(command.bounds[3]) {
        for x in left.max(command.bounds[0])..right.min(command.bounds[2]) {
            let sources = std::array::from_fn(|i| {
                stats.sample_tests += 1;
                let wx = x as f64 + SAMPLES[i % 4];
                let wy = y as f64 + SAMPLES[i / 4];
                if wx < command.clip.x as f64
                    || wy < command.clip.y as f64
                    || wx >= command.clip.x as f64 + command.clip.width as f64
                    || wy >= command.clip.y as f64 + command.clip.height as f64
                    || command
                        .clip_chain
                        .is_some_and(|chain| !chain.contains_at(wx, wy))
                {
                    return None;
                }
                let (lx, ly) = command.map.local(wx, wy);
                sample(lx - command.rect.x as f64, ly - command.rect.y as f64)
            });
            samples.blend_sources((y - top) * TILE + x - left, sources);
            stats.boundary_pixels += 1;
        }
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
    pub fn fill_gradient(
        &mut self,
        gradient: &crate::Gradient,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
    ) -> Result<(), Error> {
        let previous = self
            .target
            .commands
            .images
            .as_ref()
            .and_then(|r| r.gradients.as_ref())
            .is_some_and(|r| r.index.contains_key(&gradient.key()));
        self.pending
            .fill_gradient_with(gradient, rect, radius, transform, clip.into(), previous)
    }

    pub fn create_clip(
        &mut self,
        parent: Option<ClipId>,
        shape: ClipShape,
        transform: Affine,
    ) -> Result<ClipId, Error> {
        self.pending.create_clip(parent, shape, transform)
    }
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
        clip: impl Into<Clip>,
        color: Color,
    ) -> Result<(), Error> {
        self.pending.fill_rect(rect, transform, clip, color)
    }
    pub fn fill_rounded_rect(
        &mut self,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
    ) -> Result<(), Error> {
        self.pending
            .fill_rounded_rect(rect, radius, transform, clip, color)
    }
    pub fn fill_rect_slot(
        &mut self,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        slot: PaintSlot,
    ) -> Result<(), Error> {
        self.pending.fill_rect_slot(rect, transform, clip, slot)
    }
    pub fn fill_rounded_rect_slot(
        &mut self,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
        slot: PaintSlot,
    ) -> Result<(), Error> {
        self.pending
            .fill_rounded_rect_slot(rect, radius, transform, clip, slot)
    }
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled_slot<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        slot: PaintSlot,
        raster_scale: f32,
    ) -> Result<(), Error> {
        self.pending.draw_text_scaled_slot(
            text,
            layout,
            origin,
            transform,
            clip,
            slot,
            raster_scale,
        )
    }
    #[allow(clippy::too_many_arguments)]
    pub fn fill_rounded_rect_shared(
        &mut self,
        rect: Rect,
        radius: f32,
        transform: Affine,
        clip: impl Into<Clip>,
        initial: PaintColor,
        cache: &mut Option<PaintSlot>,
    ) -> Result<(), Error> {
        self.pending
            .fill_rounded_rect_shared(rect, radius, transform, clip, initial, cache)
    }
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled_shared<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        initial: PaintColor,
        cache: &mut Option<PaintSlot>,
        raster_scale: f32,
    ) -> Result<(), Error> {
        self.pending.draw_text_scaled_shared(
            text,
            layout,
            origin,
            transform,
            clip,
            initial,
            cache,
            raster_scale,
        )
    }
    pub fn draw_image(
        &mut self,
        image: &Image,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        sampling: ImageSampling,
    ) -> Result<(), Error> {
        self.pending
            .draw_image(image, rect, transform, clip, sampling)
    }
    pub fn draw_image_with(
        &mut self,
        image: &Image,
        rect: Rect,
        transform: Affine,
        clip: impl Into<Clip>,
        options: crate::ImageOptions,
    ) -> Result<(), Error> {
        self.pending
            .draw_image_with(image, rect, transform, clip, options)
    }
    pub fn draw_text<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
    ) -> Result<(), Error> {
        self.pending
            .draw_text(text, layout, origin, transform, clip, color)
    }
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled<G: AsRef<crate::TextGeometry>>(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout<G>,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
        raster_scale: f32,
    ) -> Result<(), Error> {
        self.pending
            .draw_text_scaled(text, layout, origin, transform, clip, color, raster_scale)
    }
    pub fn commit(mut self) {
        // The target is exclusively borrowed throughout staging. Existing
        // leases move only at commit, after damage comparison; aborts preserve
        // the predecessor and warm scene replacement touches no Arc count.
        if let Some(next) = self
            .pending
            .commands
            .images
            .as_mut()
            .and_then(|r| r.gradients.as_mut())
        {
            for (key, lease) in &mut next.values {
                if lease.is_none() {
                    let old = self
                        .target
                        .commands
                        .images
                        .as_mut()
                        .and_then(|r| r.gradients.as_mut())
                        .expect("staged predecessor");
                    let index = old.index[key] as usize;
                    *lease = old.values[index].1.take();
                    assert!(lease.is_some(), "one moved lease per exact resource");
                }
            }
        }
        self.target.invalidate_bins();
        self.target.clear = self.pending.clear;
        self.target.commands = self.pending.commands;
        self.target.mask_bytes = self.pending.mask_bytes;
        self.target.references = self.pending.references;
        self.target.dirty = true;
    }

    /// Replace the scene and return conservative changed support relative to
    /// its preceding commands. It does not certify an external buffer's age.
    /// Dropping an uncommitted candidate still leaves the old scene untouched.
    pub fn commit_with_damage(self) -> DamageRegion {
        let damage = self.pending.damage_from(self.target);
        self.commit();
        damage
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
fn full_tile(
    command: &BorrowedCommand<'_>,
    left: usize,
    top: usize,
    right: usize,
    bottom: usize,
) -> bool {
    if command.clip_chain.is_some() {
        return false;
    }
    let r = command.rect;
    let c = command.clip;
    if command.map.axis_aligned() {
        // For separable monotone axes, the first and last actual sample bound
        // every other sample. Use the same finite inverse predicate, avoiding
        // a continuous-corner error envelope or forward-rounding assumptions.
        if left < command.bounds[0]
            || top < command.bounds[1]
            || right > command.bounds[2]
            || bottom > command.bounds[3]
        {
            return false;
        }
        let (x0, y0) = (left as f64 + 0.125, top as f64 + 0.125);
        let (x1, y1) = (right as f64 - 0.125, bottom as f64 - 0.125);
        if x0 < c.x as f64
            || y0 < c.y as f64
            || x1 >= c.x as f64 + c.width as f64
            || y1 >= c.y as f64 + c.height as f64
        {
            return false;
        }
        let (lx0, ly0) = command.map.local(x0, y0);
        let (lx1, ly1) = command.map.local(x1, y1);
        return lx0.min(lx1) >= r.x as f64
            && ly0.min(ly1) >= r.y as f64
            && lx0.max(lx1) < r.x as f64 + r.width as f64
            && ly0.max(ly1) < r.y as f64 + r.height as f64;
    }
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

// A rectangle's 4×4 membership factors into four X bits and four Y bits.
// Evaluate each axis once per tile column/row rather than at every sample of
// every pixel. Their outer product retains correlated coverage at overlaps.
// This is ephemeral stack data; no retained command or Canvas header grows.
struct AxisCoverage {
    x: [u16; TILE],
    y: [u16; TILE],
}
impl AxisCoverage {
    fn new(
        command: &BorrowedCommand<'_>,
        tile: [usize; 4],
        stats: &mut RenderStats,
    ) -> Option<Self> {
        let mut result = Self {
            x: [0; TILE],
            y: [0; TILE],
        };
        let mut any = [0; 2];
        for axis in 0..2 {
            let (scale, translation, min, extent, clip, clip_extent) = if axis == 0 {
                (
                    command.map.inverse[0],
                    command.map.inverse[4],
                    command.rect.x,
                    command.rect.width,
                    command.clip.x,
                    command.clip.width,
                )
            } else {
                (
                    command.map.inverse[3],
                    command.map.inverse[5],
                    command.rect.y,
                    command.rect.height,
                    command.clip.y,
                    command.clip.height,
                )
            };
            let (bits, stride) = if axis == 0 { (1, 1) } else { (0xf, 4) };
            let first = tile[axis].max(command.bounds[axis]);
            let end = tile[axis + 2].min(command.bounds[axis + 2]);
            for pixel in first..end {
                let mut mask = 0;
                for (sample, offset) in SAMPLES.into_iter().enumerate() {
                    stats.sample_tests += 1;
                    let world = pixel as f64 + offset;
                    // Zero off-diagonal products cannot affect membership;
                    // both signs of zero compare identically at the edges.
                    let local = scale * world + translation;
                    if world >= clip as f64
                        && world < clip as f64 + clip_extent as f64
                        && local >= min as f64
                        && local < min as f64 + extent as f64
                    {
                        mask |= bits << (sample * stride);
                    }
                }
                any[axis] |= mask;
                let index = pixel - tile[axis];
                if axis == 0 {
                    result.x[index] = mask;
                } else {
                    result.y[index] = mask;
                }
            }
        }
        (any[0] != 0 && any[1] != 0).then_some(result)
    }
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
                || command
                    .clip_chain
                    .is_some_and(|chain| !chain.contains_at(wx, wy))
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
                BorrowedSource::Rounded(radius) => {
                    if rounded::contains(r, *radius, lx, ly) {
                        1.0
                    } else {
                        0.0
                    }
                }
                BorrowedSource::Gradient { .. } => {
                    unreachable!("gradient material has its own sampler")
                }
                BorrowedSource::Glyph(mask) => mask_sample(
                    mask,
                    lx - r.x as f64,
                    ly - r.y as f64,
                    r.width as f64,
                    r.height as f64,
                ),
                BorrowedSource::ImageNearest(_) | BorrowedSource::ImageLinear(_) => {
                    unreachable!("image samples carry full working colors")
                }
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
// Opaque source-over still adds backdrop * +0. Negative zero can retain the
// backdrop's sign; negative subnormals may flush to it on some targets. Color
// admission bounds all other intermediates, so ordinary opaque values discard
// the backdrop without changing the scalar result.
fn can_discard_backdrop(color: [f32; 4]) -> bool {
    color[3] == 1.0
        && !color[..3]
            .iter()
            .any(|value| value.is_sign_negative() && !value.is_normal())
}
fn sample_mean(samples: &[[f32; 4]; 16]) -> [f32; 4] {
    // Sixteen identical f32 values sum exactly in f64 (24+4 significant
    // bits). Narrow once, preserving a uniform tile's exact working color.
    // Otherwise a zero-coverage command could move the clear across an output
    // quantization threshold merely by materializing its sample tile.
    // Seed from the first sample so sixteen negative zeros retain their sign,
    // just as the uniform-color path does. Starting with +0 would erase it.
    let [first, rest @ ..] = samples;
    let mut sum = first.map(f64::from);
    for sample in rest {
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
    fn compiled_metric_scaling_preserves_integer_casts_and_rectangle_operation_order() {
        fn bits(rect: Rect) -> [u32; 4] {
            [rect.x, rect.y, rect.width, rect.height].map(f32::to_bits)
        }
        let mut scales: Vec<_> = (1..=254)
            .map(|exponent| f32::from_bits(exponent << 23))
            .collect();
        scales.extend([
            f32::from_bits(1),
            f32::MIN_POSITIVE.next_down(),
            1.25,
            1.0f32.next_up(),
            f32::MAX,
        ]);
        let mut checked = 0;
        for (xmin, ymin, width, height) in [
            (0, 0, 0, 0),
            (-3, 7, 9, 17),
            (i32::MIN, i32::MAX, usize::MAX, usize::MAX),
            (-16_777_217, 16_777_219, 16_777_217, 16_777_219),
            (i32::MAX, i32::MIN, 1, 3),
        ] {
            let raster = Raster {
                key: crate::text::GlyphKey::fixture(),
                metrics: crate::text::RasterMetrics {
                    xmin,
                    ymin,
                    width,
                    height,
                },
                pixels: Vec::new(),
            };
            for scale in &scales {
                let scale = std::hint::black_box(*scale);
                for origin in [
                    Point { x: -0.0, y: 0.0 },
                    Point {
                        x: 0.125,
                        y: -0.375,
                    },
                    Point {
                        x: -1_000_000.0,
                        y: 1_000_000.0,
                    },
                ] {
                    for [x, baseline] in
                        [[0.0, -0.0], [0.125f32.next_up(), 17.375], [-9.5, -31.125]]
                    {
                        let expected = Rect::new(
                            origin.x + x + xmin as f32 / scale,
                            origin.y + baseline - ymin as f32 / scale - height as f32 / scale,
                            width as f32 / scale,
                            height as f32 / scale,
                        );
                        assert_eq!(
                            bits(glyph_rect(
                                origin,
                                [x, baseline],
                                &raster,
                                MetricScale::new(scale)
                            )),
                            bits(expected),
                            "scale={:08x}",
                            scale.to_bits()
                        );
                        checked += 4;
                    }
                }
            }
        }
        println!("METRIC_SCALE exact_rectangle_fields={checked}");
    }

    #[test]
    fn separable_masks_and_certificates_match_every_scalar_sample() {
        let rects = [
            Rect::new(0.0, 0.0, 32.0, 32.0),
            Rect::new(0.125, 0.375, 15.875, 2.3),
            Rect::new(-10.0, 2.0, 25.0, 5.0),
            Rect::new(1_000_000.0 + 0.125, 1_000_000.0 + 0.375, 20.0, 20.0),
            Rect::new(0.125, 0.125, f32::from_bits(1), 1.0),
        ];
        for sx in [-3.1, -1.0, -0.7, 0.3, 1.0, 3.1] {
            for sy in [-1.7, -1.0, 1.0, 2.25] {
                for (tx, ty) in [
                    (0.0, 0.0),
                    (0.125, 0.375),
                    (0.125f32.next_up(), (-0.125f32).next_down()),
                    (-1_000_000.0, -1_000_000.0),
                ] {
                    let map = Mapping::new(Affine {
                        a: sx,
                        b: -0.0,
                        c: 0.0,
                        d: sy,
                        tx,
                        ty,
                    })
                    .unwrap();
                    for rect in rects {
                        for clip in [
                            Rect::new(-0.0, 0.0, 32.0, 32.0),
                            Rect::new(0.125, 0.375, 17.0, 20.0),
                            Rect::new(0.125f32.next_down(), 0.375f32.next_up(), 31.0, 31.0),
                        ] {
                            let command = BorrowedCommand {
                                clip_chain: None,
                                rect,
                                clip,
                                map,
                                source: BorrowedSource::Rect,
                                color: [0.0; 4],
                                bounds: [0, 0, 32, 32],
                            };
                            for tile in [[0, 0, 16, 16], [16, 16, 31, 29], [0, 4, 1, 5]] {
                                let axis =
                                    AxisCoverage::new(&command, tile, &mut RenderStats::default());
                                let mut entirely_covered = true;
                                for y in tile[1]..tile[3] {
                                    for x in tile[0]..tile[2] {
                                        let scalar =
                                            sample(&command, x, y, &mut RenderStats::default());
                                        let actual = axis.as_ref().map_or([0.0; 16], |axis| {
                                            let mask = (axis.x[x - tile[0]] * 0x1111)
                                                & axis.y[y - tile[1]];
                                            std::array::from_fn(|i| ((mask >> i) & 1) as f32)
                                        });
                                        assert_eq!(
                                            actual, scalar,
                                            "scale={sx},{sy}; shift={tx},{ty}; rect={rect:?}; clip={clip:?}; x={x},y={y}"
                                        );
                                        entirely_covered &=
                                            scalar.iter().all(|&value| value == 1.0);
                                    }
                                }
                                assert_eq!(
                                    full_tile(&command, tile[0], tile[1], tile[2], tile[3]),
                                    entirely_covered,
                                );
                            }
                        }
                    }
                }
            }
        }
    }

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

#[cfg(test)]
mod gradient_ownership_tests {
    use super::*;
    fn gradient(color: Color) -> crate::Gradient {
        crate::Gradient::new(
            crate::GradientGeometry::Linear {
                start: Point::default(),
                end: Point { x: 1.0, y: 0.0 },
            },
            &[
                crate::GradientStop::new(0.0, Color::BLACK),
                crate::GradientStop::new(1.0, color),
            ],
            crate::Extend::Pad,
            crate::Interpolation::LinearSrgb,
        )
        .unwrap()
    }
    #[test]
    fn staging_moves_unique_leases_without_warm_refcount_operations_and_aborts_preserve_c() {
        let g = gradient(Color::WHITE);
        let mut canvas = Canvas::new(24, 16).unwrap();
        let clip = Rect::new(0., 0., 24., 16.);
        let rect = Rect::new(2., 2., 12., 8.);
        canvas
            .fill_gradient(&g, rect, 2., Affine::IDENTITY, clip)
            .unwrap();
        assert_eq!(g.lease_count(), 2);
        let before = canvas.pixels().to_vec();
        {
            let mut next = canvas.stage();
            for _ in 0..32 {
                next.fill_gradient(&g, rect, 2., Affine::IDENTITY, clip)
                    .unwrap();
            }
            assert_eq!(
                g.lease_count(),
                2,
                "pending predecessor keys must not clone a lease"
            );
            assert_eq!(
                next.pending
                    .prepared_scene()
                    .commands
                    .images
                    .as_ref()
                    .unwrap()
                    .gradients
                    .as_ref()
                    .unwrap()
                    .values
                    .len(),
                1
            );
            assert!(
                next.fill_gradient(&g, rect, f32::NAN, Affine::IDENTITY, clip)
                    .is_err()
            );
        }
        assert_eq!(g.lease_count(), 2);
        assert_eq!(canvas.pixels(), before);
        let mut next = canvas.stage();
        next.fill_gradient(&g, rect, 2., Affine::IDENTITY, clip)
            .unwrap();
        assert_eq!(g.lease_count(), 2);
        assert!(next.commit_with_damage().is_empty());
        assert_eq!(g.lease_count(), 2);
        let replacement = gradient(Color::rgb(255, 0, 0));
        let mut next = canvas.stage();
        next.fill_gradient(&replacement, rect, 2., Affine::IDENTITY, clip)
            .unwrap();
        let damage = next.commit_with_damage();
        assert!(!damage.is_empty());
        assert_eq!(g.lease_count(), 1);
        assert_eq!(replacement.lease_count(), 2);
        assert_ne!(canvas.pixels(), before);
        assert_eq!(canvas.prepared_scene().gradients().count(), 1);
        assert!(
            !canvas
                .prepared_scene()
                .draws()
                .next()
                .unwrap()
                .source
                .is_solid()
        );
    }
    #[test]
    fn gradient_coverage_uses_the_exact_existing_simd_lattice_and_uniform_proofs_are_ineligible() {
        let g = gradient(Color::linear_srgb(2.0, -0.25, 0.5, 0.75).unwrap());
        let mut a = Canvas::new(32, 24).unwrap();
        let mut b = Canvas::new(32, 24).unwrap();
        b.set_tile_proofs(false);
        for canvas in [&mut a, &mut b] {
            canvas.clear(Color::rgba(31, 47, 73, 133));
            canvas
                .fill_gradient(
                    &g,
                    Rect::new(0.125, 0.375, 25.25, 17.5),
                    3.25,
                    Affine {
                        a: 0.9,
                        b: 0.13,
                        c: -0.17,
                        d: 0.75,
                        tx: 4.125,
                        ty: 0.125,
                    },
                    Rect::new(1.125, 0.375, 29.5, 22.25),
                )
                .unwrap();
        }
        assert_eq!(a.pixels(), b.pixels());
        assert_eq!(a.stats().full_rect_tiles, 0);
    }
}
