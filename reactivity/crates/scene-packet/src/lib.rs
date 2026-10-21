//! Immutable prepared paint storage, intended to replace expanded commands.
//! It is not a second canonical scene to copy beside an existing command list.
//! A glyph run shares one inverse/clip/paint; glyph rectangles retain their
//! distinct origins in that common local space. Resources are borrowed from
//! one owned lease per registered key, never cloned during glyph admission or
//! iteration. A caller's resource key must include its namespace/revision, and
//! the resource contents must remain immutable while leased.
#![forbid(unsafe_code)]

use gpui_reactivity_core::{Affine, Rect};
use std::{collections::BTreeMap, fmt, mem::size_of};

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct ResourceKey(pub u128);
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Glyph {
    pub rect: Rect,
    pub resource: ResourceKey,
}
/// Color is already linear-light premultiplied working color, not author color.
#[derive(Clone, Copy, Debug)]
pub struct Paint {
    pub transform: Affine,
    pub clip: Rect,
    pub color: [f32; 4],
}
#[derive(Clone, Copy, Debug)]
pub struct Limits {
    pub operations: usize,
    pub glyphs: usize,
    pub resources: usize,
}
impl Default for Limits {
    fn default() -> Self {
        Self {
            operations: 65_536,
            glyphs: 65_536,
            resources: 65_536,
        }
    }
}
#[derive(Clone, Copy, Debug, Default)]
pub struct Capacity {
    pub rectangles: usize,
    pub runs: usize,
    pub glyphs: usize,
    pub resources: usize,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    Geometry,
    Paint,
    Limit,
    Allocation,
    DuplicateResource(ResourceKey),
    MissingResource(ResourceKey),
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "prepared packet: {self:?}")
    }
}
impl std::error::Error for Error {}
/// u16 bounds are justified by the checked 16,384-pixel viewport ceiling.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Bounds(pub [u16; 4]);

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Common {
    inverse: [f64; 6],
    clip: Rect,
    color: [f32; 4],
}
impl Common {
    pub fn clip(&self) -> Rect {
        self.clip
    }
    pub fn color(&self) -> [f32; 4] {
        self.color
    }
    pub fn inverse(&self) -> &[f64; 6] {
        &self.inverse
    }
    pub fn local(&self, x: f64, y: f64) -> (f64, f64) {
        let [a, b, c, d, tx, ty] = self.inverse;
        (a * x + c * y + tx, b * x + d * y + ty)
    }
    /// Same conservative arithmetic guard as the scalar canvas mapping.
    pub fn error(&self, x: f64, y: f64) -> f64 {
        let [a, b, c, d, tx, ty] = self.inverse;
        64.0 * f64::EPSILON
            * (a.abs() * x.abs()
                + c.abs() * y.abs()
                + tx.abs()
                + b.abs() * x.abs()
                + d.abs() * y.abs()
                + ty.abs()
                + 1.0)
    }
    pub fn prepare(paint: Paint) -> Result<Self, Error> {
        validate_rect(paint.clip)?;
        let t = paint.transform;
        if !t.is_finite()
            || [t.a, t.b, t.c, t.d, t.tx, t.ty]
                .iter()
                .any(|v| v.abs() > 1_048_576.0)
        {
            return Err(Error::Geometry);
        }
        if paint.color.iter().any(|v| !v.is_finite())
            || paint.color[..3].iter().any(|v| v.abs() > 1e20)
            || !(0.0..=1.0).contains(&paint.color[3])
        {
            return Err(Error::Paint);
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
            return Err(Error::Geometry);
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
            return Err(Error::Geometry);
        }
        Ok(Self {
            inverse,
            clip: paint.clip,
            color: paint.color,
        })
    }
}

#[derive(Clone, Copy, Debug)]
pub struct Rectangle {
    pub rect: Rect,
    pub common: Common,
    pub bounds: Bounds,
}
#[derive(Clone, Copy)]
struct Placement {
    rect: Rect,
    resource: u32,
    bounds: Bounds,
}
struct Run {
    common: Common,
    start: u32,
    count: u32,
}
struct Resource<R> {
    key: ResourceKey,
    lease: R,
}
enum Order {
    Rectangle(u32),
    Glyphs(u32),
}

pub struct Packet<R> {
    viewport: [u16; 2],
    order: Box<[Order]>,
    rectangles: Box<[Rectangle]>,
    runs: Box<[Run]>,
    glyphs: Box<[Placement]>,
    resources: Box<[Resource<R>]>,
}
pub struct Builder<R> {
    viewport: [u16; 2],
    limits: Limits,
    order: Vec<Order>,
    rectangles: Vec<Rectangle>,
    runs: Vec<Run>,
    glyphs: Vec<Placement>,
    resources: Vec<Resource<R>>,
    keys: BTreeMap<ResourceKey, u32>,
}
impl<R> Builder<R> {
    pub fn new(width: u16, height: u16, limits: Limits) -> Result<Self, Error> {
        if width == 0 || height == 0 || width > 16_384 || height > 16_384 {
            return Err(Error::Geometry);
        }
        if [limits.operations, limits.glyphs, limits.resources]
            .iter()
            .any(|n| *n > u32::MAX as usize)
        {
            return Err(Error::Limit);
        }
        Ok(Self {
            viewport: [width, height],
            limits,
            order: Vec::new(),
            rectangles: Vec::new(),
            runs: Vec::new(),
            glyphs: Vec::new(),
            resources: Vec::new(),
            keys: BTreeMap::new(),
        })
    }
    /// Resource-map construction is temporary and included in prepare costs.
    pub fn reserve(&mut self, capacity: Capacity) -> Result<(), Error> {
        let operations = capacity
            .rectangles
            .checked_add(capacity.runs)
            .ok_or(Error::Limit)?;
        if operations > self.limits.operations
            || capacity.glyphs > self.limits.glyphs
            || capacity.resources > self.limits.resources
        {
            return Err(Error::Limit);
        }
        reserve(&mut self.order, operations)?;
        reserve(&mut self.rectangles, capacity.rectangles)?;
        reserve(&mut self.runs, capacity.runs)?;
        reserve(&mut self.glyphs, capacity.glyphs)?;
        reserve(&mut self.resources, capacity.resources)
    }
    /// Duplicate/limit errors return the owned resource. Lookup first to avoid
    /// even a caller-side Arc clone for an existing key.
    pub fn resource(&mut self, key: ResourceKey, lease: R) -> Result<(), (Error, R)> {
        if self.keys.contains_key(&key) {
            return Err((Error::DuplicateResource(key), lease));
        }
        if self.resources.len() == self.limits.resources {
            return Err((Error::Limit, lease));
        }
        if self.resources.try_reserve(1).is_err() {
            return Err((Error::Allocation, lease));
        }
        let index = self.resources.len() as u32;
        self.resources.push(Resource { key, lease });
        self.keys.insert(key, index);
        Ok(())
    }
    pub fn has_resource(&self, key: ResourceKey) -> bool {
        self.keys.contains_key(&key)
    }
    pub fn rectangle(&mut self, rect: Rect, paint: Paint) -> Result<(), Error> {
        let common = Common::prepare(paint)?;
        validate_rect(rect)?;
        let Some(bounds) = bounds(rect, paint, self.viewport) else {
            return Ok(());
        };
        if self.order.len() == self.limits.operations {
            return Err(Error::Limit);
        }
        self.order.try_reserve(1).map_err(|_| Error::Allocation)?;
        self.rectangles
            .try_reserve(1)
            .map_err(|_| Error::Allocation)?;
        let index = self.rectangles.len() as u32;
        self.rectangles.push(Rectangle {
            rect,
            common,
            bounds,
        });
        self.order.push(Order::Rectangle(index));
        Ok(())
    }
    /// A rollback guard truncates plain placement records on errors or iterator
    /// panic; it allocates nothing and drops no user resource payload.
    pub fn glyph_run(
        &mut self,
        paint: Paint,
        glyphs: impl IntoIterator<Item = Glyph>,
    ) -> Result<(), Error> {
        let common = Common::prepare(paint)?;
        let start = self.glyphs.len();
        let mut pending = Pending {
            glyphs: &mut self.glyphs,
            start,
            committed: false,
        };
        for glyph in glyphs {
            validate_rect(glyph.rect)?;
            let resource = *self
                .keys
                .get(&glyph.resource)
                .ok_or(Error::MissingResource(glyph.resource))?;
            let Some(bounds) = bounds(glyph.rect, paint, self.viewport) else {
                continue;
            };
            if pending.glyphs.len() == self.limits.glyphs {
                return Err(Error::Limit);
            }
            pending
                .glyphs
                .try_reserve(1)
                .map_err(|_| Error::Allocation)?;
            pending.glyphs.push(Placement {
                rect: glyph.rect,
                resource,
                bounds,
            });
        }
        let count = pending.glyphs.len() - start;
        if count != 0 {
            if self.order.len() == self.limits.operations {
                return Err(Error::Limit);
            }
            self.order.try_reserve(1).map_err(|_| Error::Allocation)?;
            self.runs.try_reserve(1).map_err(|_| Error::Allocation)?;
            let index = self.runs.len() as u32;
            self.runs.push(Run {
                common,
                start: start as u32,
                count: count as u32,
            });
            self.order.push(Order::Glyphs(index));
        }
        pending.committed = true;
        Ok(())
    }
    /// Remove unused registered leases before publication. One temporary u32
    /// remapping lane is charged by preparation benchmarks and then discarded.
    pub fn finish(mut self) -> Packet<R> {
        if self.glyphs.is_empty() {
            self.resources.clear();
        } else {
            let mut remap = vec![u32::MAX; self.resources.len()];
            for glyph in &self.glyphs {
                remap[glyph.resource as usize] = 0;
            }
            let mut next = 0;
            for index in &mut remap {
                if *index != u32::MAX {
                    *index = next;
                    next += 1;
                }
            }
            for glyph in &mut self.glyphs {
                glyph.resource = remap[glyph.resource as usize];
            }
            let mut index = 0;
            self.resources.retain(|_| {
                let used = remap[index] != u32::MAX;
                index += 1;
                used
            });
        }
        Packet {
            viewport: self.viewport,
            order: self.order.into_boxed_slice(),
            rectangles: self.rectangles.into_boxed_slice(),
            runs: self.runs.into_boxed_slice(),
            glyphs: self.glyphs.into_boxed_slice(),
            resources: self.resources.into_boxed_slice(),
        }
    }
}
fn reserve<T>(values: &mut Vec<T>, target: usize) -> Result<(), Error> {
    values
        .try_reserve_exact(target.saturating_sub(values.len()))
        .map_err(|_| Error::Allocation)
}
struct Pending<'a> {
    glyphs: &'a mut Vec<Placement>,
    start: usize,
    committed: bool,
}
impl Drop for Pending<'_> {
    fn drop(&mut self) {
        if !self.committed {
            self.glyphs.truncate(self.start);
        }
    }
}

pub struct GlyphView<'a, R> {
    pub rect: Rect,
    pub bounds: Bounds,
    pub key: ResourceKey,
    pub resource: &'a R,
}
pub struct GlyphRun<'a, R> {
    pub common: &'a Common,
    glyphs: &'a [Placement],
    resources: &'a [Resource<R>],
}
impl<'a, R> GlyphRun<'a, R> {
    pub fn glyphs(&self) -> impl ExactSizeIterator<Item = GlyphView<'a, R>> + 'a {
        let resources = self.resources;
        self.glyphs.iter().map(move |glyph| {
            let resource = &resources[glyph.resource as usize];
            GlyphView {
                rect: glyph.rect,
                bounds: glyph.bounds,
                key: resource.key,
                resource: &resource.lease,
            }
        })
    }
}
pub enum Operation<'a, R> {
    Rectangle(&'a Rectangle),
    Glyphs(GlyphRun<'a, R>),
}
impl<R> Packet<R> {
    pub fn viewport(&self) -> [u16; 2] {
        self.viewport
    }
    pub fn operations(&self) -> impl ExactSizeIterator<Item = Operation<'_, R>> {
        self.order.iter().map(|op| match *op {
            Order::Rectangle(index) => Operation::Rectangle(&self.rectangles[index as usize]),
            Order::Glyphs(index) => {
                let run = &self.runs[index as usize];
                let start = run.start as usize;
                Operation::Glyphs(GlyphRun {
                    common: &run.common,
                    glyphs: &self.glyphs[start..start + run.count as usize],
                    resources: &self.resources,
                })
            }
        })
    }
    pub fn resources(&self) -> impl ExactSizeIterator<Item = (ResourceKey, &R)> {
        self.resources
            .iter()
            .map(|resource| (resource.key, &resource.lease))
    }
    pub fn storage(&self) -> Storage {
        Storage {
            object: size_of::<Self>(),
            order: self.order.len() * size_of::<Order>(),
            rectangles: self.rectangles.len() * size_of::<Rectangle>(),
            runs: self.runs.len() * size_of::<Run>(),
            placements: self.glyphs.len() * size_of::<Placement>(),
            resource_leases: self.resources.len() * size_of::<Resource<R>>(),
        }
    }
}
/// Exact requested packet bytes including object/Box metadata and every lane.
/// Resource bodies behind generic R and allocator bookkeeping are separate.
#[derive(Clone, Copy, Debug)]
pub struct Storage {
    pub object: usize,
    pub order: usize,
    pub rectangles: usize,
    pub runs: usize,
    pub placements: usize,
    pub resource_leases: usize,
}
impl Storage {
    pub fn total(self) -> usize {
        self.object
            + self.order
            + self.rectangles
            + self.runs
            + self.placements
            + self.resource_leases
    }
}

fn validate_rect(rect: Rect) -> Result<(), Error> {
    if !rect.is_valid()
        || [rect.x, rect.y, rect.width, rect.height]
            .iter()
            .any(|v| v.abs() > 1_048_576.0)
    {
        Err(Error::Geometry)
    } else {
        Ok(())
    }
}
/// Scalar canvas's one-pixel outward guard then device clip/viewport. Builder
/// validation precedes this helper. Local sample tests remain authoritative.
fn bounds(rect: Rect, paint: Paint, viewport: [u16; 2]) -> Option<Bounds> {
    if rect.is_empty() || paint.clip.is_empty() || paint.color[3] == 0.0 {
        return None;
    }
    let t = paint.transform;
    let mut min = [f64::INFINITY; 2];
    let mut max = [f64::NEG_INFINITY; 2];
    for (x, y) in [
        (rect.x as f64, rect.y as f64),
        (rect.x as f64 + rect.width as f64, rect.y as f64),
        (rect.x as f64, rect.y as f64 + rect.height as f64),
        (
            rect.x as f64 + rect.width as f64,
            rect.y as f64 + rect.height as f64,
        ),
    ] {
        let wx = t.a as f64 * x + t.c as f64 * y + t.tx as f64;
        let wy = t.b as f64 * x + t.d as f64 * y + t.ty as f64;
        min[0] = min[0].min(wx);
        min[1] = min[1].min(wy);
        max[0] = max[0].max(wx);
        max[1] = max[1].max(wy);
    }
    let clip = paint.clip;
    let left = (min[0] - 1.0)
        .max(clip.x as f64)
        .max(0.0)
        .floor()
        .min(viewport[0] as f64) as u16;
    let top = (min[1] - 1.0)
        .max(clip.y as f64)
        .max(0.0)
        .floor()
        .min(viewport[1] as f64) as u16;
    let right = (max[0] + 1.0)
        .min(clip.x as f64 + clip.width as f64)
        .min(viewport[0] as f64)
        .ceil()
        .max(0.0) as u16;
    let bottom = (max[1] + 1.0)
        .min(clip.y as f64 + clip.height as f64)
        .min(viewport[1] as f64)
        .ceil()
        .max(0.0) as u16;
    (left < right && top < bottom).then_some(Bounds([left, top, right, bottom]))
}
