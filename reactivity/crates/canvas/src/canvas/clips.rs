//! Immutable parent prefixes. Continuous geometry and raster lowering are
//! separate views of the same admitted shapes; no draw owns a copied chain.
use super::{
    BorrowedCommand, BorrowedSource, Canvas, ImageResources, Mapping, SAMPLES, rounded,
    validate_rect, viewport_rect,
};
use crate::{Affine, Error, Point, Rect};
use std::{
    num::NonZeroU64,
    sync::atomic::{AtomicU64, Ordering},
};

pub const MAX_CLIP_NODES: usize = 16_384;
pub const MAX_CLIP_DEPTH: usize = 64;
const _: () = assert!(MAX_CLIP_NODES < 1 << 24 && MAX_CLIP_DEPTH < 256);
const CHAIN: u32 = 0x7fc0_0003;
static NEXT_OWNER: AtomicU64 = AtomicU64::new(1);

/// One closed local shape. Rectangles are half-open; circular edges are closed.
/// Radius is finite/nonnegative and clamps to half the local extents.
#[derive(Clone, Copy, Debug)]
pub enum ClipShape {
    Rect(Rect),
    RoundedRect { rect: Rect, radius: f32 },
}

/// A capability in one Canvas scene. Clear, replacement, and dropped candidates
/// invalidate their old handles. Parents must belong to the same current scene.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ClipId {
    owner: NonZeroU64,
    index: u32,
}
#[derive(Clone, Copy, Debug)]
pub enum Clip {
    Rect(Rect),
    Chain(ClipId),
}
impl From<Rect> for Clip {
    fn from(rect: Rect) -> Self {
        Self::Rect(rect)
    }
}
impl From<ClipId> for Clip {
    fn from(id: ClipId) -> Self {
        Self::Chain(id)
    }
}

pub(super) struct ClipArena {
    owner: NonZeroU64,
    nodes: Vec<Node>,
}
struct Node {
    rect: Rect,
    map: Mapping,
    bounds: Rect,
    // A finite value proves the entire prefix lowers exactly to this lattice
    // rectangle. NaN denotes an unlowered prefix, never authored geometry.
    raster: Rect,
    radius: f32,
    // Older parent index+1 in low24; checked depth in the high8.
    link: u32,
}
impl Node {
    fn parent(&self) -> Option<u32> {
        let value = self.link & 0x00ff_ffff;
        (value != 0).then(|| value - 1)
    }
    fn depth(&self) -> usize {
        (self.link >> 24) as usize
    }
    fn contains(&self, x: f64, y: f64) -> bool {
        let (x, y) = self.map.local(x, y);
        rounded::contains(self.rect, self.radius, x, y)
    }
    fn same_geometry(&self, other: &Self) -> bool {
        let bits = |r: Rect| [r.x, r.y, r.width, r.height].map(f32::to_bits);
        bits(self.rect) == bits(other.rect)
            && self.map.inverse.map(f64::to_bits) == other.map.inverse.map(f64::to_bits)
            && bits(self.bounds) == bits(other.bounds)
            && bits(self.raster) == bits(other.raster)
            && self.radius.to_bits() == other.radius.to_bits()
    }
    fn command(&self) -> BorrowedCommand<'_> {
        BorrowedCommand {
            rect: self.rect,
            map: self.map,
            clip: self.bounds,
            clip_chain: None,
            source: if self.radius == 0.0 {
                BorrowedSource::Rect
            } else {
                BorrowedSource::Rounded(self.radius)
            },
            color: [1.0; 4],
            bounds: [0; 4],
        }
    }
}

/// Borrowed immutable geometry in one scene. This view cannot outlive or mutate
/// the Canvas; no raster approximation is used to answer continuous hit tests.
#[derive(Clone, Copy)]
pub struct ClipGeometry<'a> {
    pub(super) arena: &'a ClipArena,
}
#[derive(Clone, Copy)]
pub struct ClipChain<'a> {
    arena: &'a ClipArena,
    index: u32,
}
impl std::fmt::Debug for ClipChain<'_> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ClipChain")
            .field("index", &self.index)
            .field("depth", &self.depth())
            .finish()
    }
}
/// Positional node data for a backend borrowing this complete scene. Parent
/// indices are strictly older zero-based positions, not cross-scene authority.
#[derive(Clone, Copy, Debug)]
pub struct PreparedClipNode {
    pub local_rect: Rect,
    pub inverse: [f64; 6],
    pub radius: f32,
    pub parent: Option<u32>,
    /// Exact fixed-lattice lowering of this entire prefix, when certified.
    /// This rectangle is not continuous hit or accessibility geometry.
    pub raster_rect: Option<Rect>,
}
impl<'a> ClipGeometry<'a> {
    pub fn chain(self, id: ClipId) -> Result<ClipChain<'a>, Error> {
        if id.owner != self.arena.owner || id.index as usize >= self.arena.nodes.len() {
            return Err(Error::InvalidClip);
        }
        Ok(ClipChain {
            arena: self.arena,
            index: id.index,
        })
    }
    pub fn nodes(
        self,
    ) -> impl ExactSizeIterator<Item = PreparedClipNode> + DoubleEndedIterator + 'a {
        self.arena.nodes.iter().map(|node| PreparedClipNode {
            local_rect: node.rect,
            inverse: node.map.inverse,
            radius: node.radius,
            parent: node.parent(),
            raster_rect: node.raster.x.is_finite().then_some(node.raster),
        })
    }
    pub(super) fn node_bytes(self) -> usize {
        self.arena.nodes.capacity() * size_of::<Node>()
    }
    pub fn storage_bytes(self) -> usize {
        size_of::<ClipArena>() + self.arena.nodes.capacity() * size_of::<Node>()
    }
}
impl ClipChain<'_> {
    pub fn index(self) -> u32 {
        self.index
    }
    pub fn depth(self) -> usize {
        self.arena.nodes[self.index as usize].depth()
    }
    pub fn bounds(self) -> Rect {
        self.arena.nodes[self.index as usize].bounds
    }
    pub fn contains(self, point: Point) -> bool {
        self.contains_at(f64::from(point.x), f64::from(point.y))
    }
    pub(super) fn contains_at(self, x: f64, y: f64) -> bool {
        if !x.is_finite() || !y.is_finite() {
            return false;
        }
        let bounds = self.bounds();
        if !(x >= f64::from(bounds.x)
            && y >= f64::from(bounds.y)
            && x < f64::from(bounds.x) + f64::from(bounds.width)
            && y < f64::from(bounds.y) + f64::from(bounds.height))
        {
            return false;
        }
        let mut next = Some(self.index);
        while let Some(index) = next {
            let node = &self.arena.nodes[index as usize];
            if !node.contains(x, y) {
                return false;
            }
            next = node.parent();
        }
        true
    }
    /// Exact canonical 4×4 membership, one bit per sample. This is a raster
    /// query, distinct from contains(), and never a separately filtered alpha.
    pub fn sample_mask(self, x: u32, y: u32) -> u16 {
        let mut result = 0;
        for (row, oy) in SAMPLES.into_iter().enumerate() {
            for (column, ox) in SAMPLES.into_iter().enumerate() {
                result |= u16::from(self.contains_at(f64::from(x) + ox, f64::from(y) + oy))
                    << (row * 4 + column);
            }
        }
        result
    }
    pub(super) fn mask<S: fearless_simd::Simd>(
        self,
        simd: S,
        x: usize,
        y: usize,
        stats: &mut super::RenderStats,
    ) -> u16 {
        let mut result = u16::MAX;
        let mut next = Some(self.index);
        while let Some(index) = next {
            let node = &self.arena.nodes[index as usize];
            let mut command = node.command();
            if node.raster.x.is_finite() {
                command.rect = node.raster;
                command.clip = node.raster;
                command.map = Mapping {
                    inverse: [1.0, -0.0, -0.0, 1.0, 0.0, 0.0],
                };
                command.source = BorrowedSource::Rect;
                return result & super::mask_kernel::coverage(simd, &command, x, y, stats);
            }
            result &= super::mask_kernel::coverage(simd, &command, x, y, stats);
            if result == 0 {
                break;
            }
            next = node.parent();
        }
        result
    }
    // Damage compares immutable shape content across scene owners. This does
    // not grant capability equality or let handles escape their own arena.
    pub(super) fn same(self, other: Self) -> bool {
        if std::ptr::eq(self.arena, other.arena) && self.index == other.index {
            return true;
        }
        if self.depth() != other.depth() {
            return false;
        }
        let (mut left, mut right) = (self.index, other.index);
        loop {
            let a = &self.arena.nodes[left as usize];
            let b = &other.arena.nodes[right as usize];
            if !a.same_geometry(b) {
                return false;
            }
            match (a.parent(), b.parent()) {
                (Some(a), Some(b)) => (left, right) = (a, b),
                (None, None) => return true,
                _ => return false,
            }
        }
    }
}

pub(super) fn encoded_index(rect: Rect) -> Option<u32> {
    (rect.x.to_bits() == CHAIN).then_some(rect.y.to_bits())
}
impl super::DisplayList {
    pub(super) fn clip_geometry(&self) -> Option<ClipGeometry<'_>> {
        Some(ClipGeometry {
            arena: self.images.as_ref()?.clips.as_deref()?,
        })
    }
    pub(super) fn clip_chain(&self, clip: Rect) -> Option<ClipChain<'_>> {
        Some(ClipChain {
            arena: self.clip_geometry()?.arena,
            index: encoded_index(clip)?,
        })
    }
    pub(super) fn clip_bounds(&self, clip: Rect) -> Rect {
        self.clip_chain(clip).map_or(clip, ClipChain::bounds)
    }
}
impl Canvas {
    pub fn clip_geometry(&self) -> Option<ClipGeometry<'_>> {
        self.commands.clip_geometry()
    }
    /// Append an immutable local clip to an existing prefix. Bounds/depth and
    /// allocation admission complete before the new handle becomes observable.
    pub fn create_clip(
        &mut self,
        parent: Option<ClipId>,
        shape: ClipShape,
        transform: Affine,
    ) -> Result<ClipId, Error> {
        let (rect, radius) = match shape {
            ClipShape::Rect(rect) => (rect, 0.0),
            ClipShape::RoundedRect { rect, radius } => (rect, radius),
        };
        validate_rect(rect)?;
        rounded::validate_radius(radius)?;
        let map = Mapping::new(transform)?;
        let parent_chain = parent
            .map(|id| self.clip_geometry().ok_or(Error::InvalidClip)?.chain(id))
            .transpose()?;
        let depth = parent_chain.map_or(1, |chain| chain.depth() + 1);
        let count = self
            .clip_geometry()
            .map_or(0, |geometry| geometry.arena.nodes.len());
        if depth > MAX_CLIP_DEPTH || count == MAX_CLIP_NODES {
            return Err(Error::ResourceLimit);
        }
        let viewport = viewport_rect(self.width, self.height);
        let parent_bounds = parent_chain.map_or(viewport, ClipChain::bounds);
        // Outward integer bounds use the same guard as draw admission. These
        // bounds never answer continuous hit membership or certify interior.
        let bounds = self
            .prepare(
                rect,
                transform,
                super::Common {
                    clip: parent_bounds,
                    map,
                    color: [1.0; 4],
                },
                super::RECT_SOURCE,
            )?
            .map_or(Rect::default(), |draw| {
                super::device_bounds(draw.geometry.bounds)
            });
        let parent_raster = parent_chain.map_or(Some(viewport), |chain| {
            let raster = chain.arena.nodes[chain.index as usize].raster;
            raster.x.is_finite().then_some(raster)
        });
        let raster = if radius == 0.0 && map.axis_aligned() {
            parent_raster
                .map(|parent| {
                    super::sampled_rect_clip(
                        transform,
                        rect,
                        parent,
                        [self.width as u32, self.height as u32],
                    )
                })
                .transpose()?
        } else {
            None
        }
        .unwrap_or(Rect::new(f32::NAN, 0.0, 0.0, 0.0));
        let node = Node {
            rect,
            radius,
            map,
            bounds,
            raster,
            link: (depth as u32) << 24 | parent.map_or(0, |id| id.index + 1),
        };
        if self.clip_geometry().is_none() {
            let owner = NEXT_OWNER
                .try_update(Ordering::Relaxed, Ordering::Relaxed, |owner| {
                    owner.checked_add(1)
                })
                .map_err(|_| Error::ResourceLimit)?;
            let owner = NonZeroU64::new(owner).expect("clip owners start at one and never wrap");
            let mut nodes = Vec::new();
            nodes.try_reserve(1).map_err(|_| Error::ResourceLimit)?;
            nodes.push(node);
            let arena = Box::new(ClipArena { owner, nodes });
            self.revoke_publication();
            self.commands
                .images
                .get_or_insert_with(Box::<ImageResources>::default)
                .clips = Some(arena);
            Ok(ClipId { owner, index: 0 })
        } else {
            let arena = self
                .commands
                .images
                .as_mut()
                .unwrap()
                .clips
                .as_mut()
                .unwrap();
            arena
                .nodes
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
            self.publication=None;
            arena.nodes.push(node);
            Ok(ClipId {
                owner: arena.owner,
                index: count as u32,
            })
        }
    }
    pub(super) fn resolve_clip(&self, clip: Clip) -> Result<Rect, Error> {
        match clip {
            Clip::Rect(rect) => {
                validate_rect(rect)?;
                Ok(rect)
            }
            Clip::Chain(id) => {
                let chain = self.clip_geometry().ok_or(Error::InvalidClip)?.chain(id)?;
                let raster = chain.arena.nodes[chain.index as usize].raster;
                Ok(if raster.x.is_finite() {
                    raster
                } else {
                    Rect::new(f32::from_bits(CHAIN), f32::from_bits(id.index), 0.0, 0.0)
                })
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn canonical_clip_storage_and_transient_views_are_charged() {
        println!(
            "CLIP_HEADERS canvas={} candidate={} display_list={} resource_box={} arena={} node={} common={} scope={} draw_view={} group_view={} cpu_command={} clip_argument={} handle={} geometry_view={} chain_view={} exported_node={} optional_handle={}",
            size_of::<Canvas>(),
            size_of::<super::super::CanvasScene<'_>>(),
            size_of::<super::super::DisplayList>(),
            size_of::<ImageResources>(),
            size_of::<ClipArena>(),
            size_of::<Node>(),
            size_of::<super::super::StoredCommon>(),
            size_of::<super::super::columns::Scope>(),
            size_of::<super::super::PreparedDraw<'_>>(),
            size_of::<super::super::PreparedGroup<'_>>(),
            size_of::<BorrowedCommand<'_>>(),
            size_of::<Clip>(),
            size_of::<ClipId>(),
            size_of::<ClipGeometry<'_>>(),
            size_of::<ClipChain<'_>>(),
            size_of::<PreparedClipNode>(),
            size_of::<Option<ClipId>>()
        );
        let mut canvas = Canvas::recording(8, 8, Default::default()).unwrap();
        let mut id = None;
        let cold = allocation_counter::measure(|| {
            id = Some(
                canvas
                    .create_clip(
                        None,
                        ClipShape::RoundedRect {
                            rect: Rect::new(0.0, 0.0, 8.0, 8.0),
                            radius: 2.0,
                        },
                        Affine::IDENTITY,
                    )
                    .unwrap(),
            );
        });
        let id = id.unwrap();
        let storage = canvas.prepared_scene().storage();
        println!(
            "CLIP_COLD count={} bytes={} storage={storage:?}",
            cold.count_total, cold.bytes_total
        );
        for _ in 0..5 {
            canvas
                .fill_rect(
                    Rect::new(0.0, 0.0, 8.0, 8.0),
                    Affine::IDENTITY,
                    id,
                    crate::Color::WHITE,
                )
                .unwrap();
        }
        let warmed = allocation_counter::measure(|| {
            for _ in 0..3 {
                canvas
                    .fill_rect(
                        Rect::new(0.0, 0.0, 8.0, 8.0),
                        Affine::IDENTITY,
                        id,
                        crate::Color::WHITE,
                    )
                    .unwrap();
            }
        });
        assert_eq!(warmed.count_total, 0);
        assert_eq!(canvas.prepared_scene().clip_nodes().count(), 1);
        assert_eq!(
            canvas.prepared_scene().storage().clip_node_bytes,
            storage.clip_node_bytes
        );
        println!(
            "CLIP_SHARED_APPEND count={} bytes={}",
            warmed.count_total, warmed.bytes_total
        );
    }
}
