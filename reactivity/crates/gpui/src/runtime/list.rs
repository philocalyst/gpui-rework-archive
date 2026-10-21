//! Cold list state and bounded borrowed materialization. No item source survives
//! an owner description, and historical offscreen row identities are not kept.
use super::*;
use crate::{ItemKey, ItemSource, ListError, ListId, ListViewport, list::ListPlan};

const MAX_ITEMS: usize = 1_000_000_000;
const MAX_ROWS: usize = 4096;
const MAX_EXTENT: f64 = (1_u64 << 40) as f64;
const MAX_COORDINATE: f32 = 1_000_000.0;

pub(super) struct ListState {
    pub identity: u64,
    pub viewport: ListViewport,
    pub anchor: Option<(ItemKey, f64)>,
}
pub(super) struct ListRow {
    pub list: ListId,
    pub key: ItemKey,
    pub index: u32,
    pub y: f32,
    pub height: f32,
    pub visible: bool,
}
#[derive(Clone, Copy)]
pub(super) enum ScrollPosition {
    Delta(f64),
    Index(usize),
    Key(ItemKey),
}
#[derive(Clone, Copy)]
pub(super) struct ScrollRequest {
    pub id: ListId,
    pub position: ScrollPosition,
}

fn checked_index(
    source: &dyn ItemSource,
    key: ItemKey,
    len: usize,
) -> Result<Option<usize>, ListError> {
    match source.index_of(key) {
        Some(index) if index >= len || source.key(index) != key => {
            Err(ListError::InvalidIndex(key))
        }
        index => Ok(index),
    }
}
pub(super) fn plan(
    previous: Option<&ListState>,
    style: Style,
    source: &dyn ItemSource,
    row_height: f64,
    request: Option<ScrollPosition>,
) -> Result<ListPlan, ListError> {
    let viewport = f64::from(style.height.ok_or(ListError::MissingViewport)?);
    if !row_height.is_finite()
        || !(1.0 / 64.0..f64::from(MAX_COORDINATE)).contains(&row_height)
        || !viewport.is_finite()
        || !(0.0..f64::from(MAX_COORDINATE)).contains(&viewport)
        || viewport == 0.0
    {
        return Err(ListError::InvalidMetrics);
    }
    // Match ordinary layout lengths: one finite f32 author value, wide math thereafter.
    let row_height = f64::from(row_height as f32);
    if style.padding != 0.0 || style.gap != 0.0 {
        return Err(ListError::UnsupportedStyle);
    }
    let len = source.len();
    let extent = len as f64 * row_height;
    if len > MAX_ITEMS || !extent.is_finite() || extent > MAX_EXTENT {
        return Err(ListError::ResourceLimit);
    }
    let previous_offset = previous.map_or(0.0, |state| state.viewport.offset);
    let mut offset = match request {
        Some(ScrollPosition::Delta(delta)) => previous_offset + delta,
        Some(ScrollPosition::Index(index)) => {
            if index >= len {
                return Err(ListError::IndexOutOfRange);
            }
            index as f64 * row_height
        }
        Some(ScrollPosition::Key(key)) => {
            checked_index(source, key, len)?.ok_or(ListError::MissingKey(key))? as f64 * row_height
        }
        None => match previous.and_then(|state| state.anchor) {
            Some((key, intra)) => checked_index(source, key, len)?
                .map_or(previous_offset, |index| {
                    index as f64 * row_height + intra.min(row_height)
                }),
            None => previous_offset,
        },
    };
    offset = offset.clamp(0.0, (extent - viewport).max(0.0));
    let start = ((offset / row_height).floor() as usize).min(len);
    let end = (((offset + viewport) / row_height).ceil() as usize).min(len);
    if end - start > MAX_ROWS {
        return Err(ListError::ResourceLimit);
    }
    let mut keys = Vec::with_capacity(end - start);
    let mut unique = BTreeSet::new();
    for index in start..end {
        let key = source.key(index);
        if !unique.insert(key) {
            return Err(ListError::DuplicateKey(key));
        }
        if checked_index(source, key, len)? != Some(index) {
            return Err(ListError::InvalidIndex(key));
        }
        keys.push(key);
    }
    let anchor = keys
        .first()
        .copied()
        .map(|key| (key, offset - start as f64 * row_height));
    Ok(ListPlan {
        viewport: ListViewport {
            len,
            offset,
            extent,
            row_height,
            viewport_height: viewport,
            visible_range: start..end,
            realized_range: start..end,
            realized_rows: end - start,
        },
        keys,
        anchor,
    })
}

pub(super) fn row_style(
    kind: NodeKind,
    declared: &Style,
    parent: Option<Flow>,
    slot: Option<&ListRow>,
) -> cephal::Style {
    let mut style = layout_style(declared);
    if kind == NodeKind::List && declared.width.is_none() {
        use cephal::style::Dimension;
        if parent.is_none() {
            style.size.width = Dimension::percent(1.0);
        } else if parent == Some(Flow::Row) {
            style.flex_grow = 1.0;
            style.flex_basis = Dimension::length(0.0);
        }
    }
    if let Some(slot) = slot {
        use cephal::style::{Dimension, LengthPercentageAuto, Position};
        style.position = Position::Absolute;
        style.inset = cephal::Rect {
            left: LengthPercentageAuto::length(0.0),
            right: LengthPercentageAuto::length(0.0),
            top: LengthPercentageAuto::length(slot.y),
            bottom: LengthPercentageAuto::AUTO,
        };
        style.size.height = Dimension::length(slot.height);
    }
    style
}
fn edges(rect: Rect) -> [f64; 4] {
    [
        f64::from(rect.x),
        f64::from(rect.y),
        f64::from(rect.x) + f64::from(rect.width),
        f64::from(rect.y) + f64::from(rect.height),
    ]
}
fn intersect(a: [f64; 4], b: [f64; 4]) -> [f64; 4] {
    [
        a[0].max(b[0]),
        a[1].max(b[1]),
        a[2].min(b[2]),
        a[3].min(b[3]),
    ]
}
fn ceil32(value: f64) -> f32 {
    let narrowed = value as f32;
    if f64::from(narrowed) < value {
        narrowed.next_up()
    } else {
        narrowed
    }
}
fn floor32(value: f64) -> f32 {
    let narrowed = value as f32;
    if f64::from(narrowed) > value {
        narrowed.next_down()
    } else {
        narrowed
    }
}
fn envelope(edges: [f64; 4]) -> Rect {
    let [left, top, right, bottom] = edges;
    if right <= left || bottom <= top {
        return Rect::default();
    }
    let x = floor32(left);
    let y = floor32(top);
    // Ceil the extent relative to the outward origin. Even Rect::contains's
    // f32 endpoint addition cannot move inward past the exact endpoint.
    Rect::new(
        x,
        y,
        ceil32(right - f64::from(x)),
        ceil32(bottom - f64::from(y)),
    )
}
pub(super) fn clipped_bounds(bounds: Rect, clip: Rect) -> Rect {
    envelope(intersect(edges(bounds), edges(clip)))
}
pub(super) fn viewport_clip(
    parent: Rect,
    hit_parent: Rect,
    map: Option<Affine>,
    rect: Rect,
    viewport: [u32; 2],
) -> Result<(Rect, Rect), Error> {
    let map = map.ok_or(ListError::UnsupportedTransform)?;
    if map.b != 0.0 || map.c != 0.0 {
        return Err(ListError::UnsupportedTransform.into());
    }
    let x0 = f64::from(map.tx);
    let y0 = f64::from(map.ty);
    let x1 = x0 + f64::from(map.a) * f64::from(rect.width);
    let y1 = y0 + f64::from(map.d) * f64::from(rect.height);
    let exact = [x0.min(x1), y0.min(y1), x0.max(x1), y0.max(y1)];
    if exact
        .iter()
        .any(|v| !v.is_finite() || v.abs() >= f64::from(MAX_COORDINATE))
        || exact[2] - exact[0] >= f64::from(MAX_COORDINATE)
        || exact[3] - exact[1] >= f64::from(MAX_COORDINATE)
    {
        return Err(ListError::UnsupportedTransform.into());
    }
    let clip = gpui_canvas::sampled_rect_clip(map, rect, parent, viewport)?;
    if rect.is_empty() {
        return Ok((clip, Rect::default()));
    }
    // Raster clips are sample-specific. Input broad-phase envelopes come from
    // original geometry, including nonempty axes whose forward sum collapses;
    // exact ancestor inverse predicates decide actual pointer membership.
    let original = CoordinateSpace::new(map)
        .bounds(rect)
        .ok_or(ListError::UnsupportedTransform)?;
    Ok((clip, clipped_bounds(original, hit_parent)))
}

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Resolve one list in the current acknowledged sheet. IDs are window local.
    pub fn list(&self, id: ListId) -> Result<Target, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let state = runtime.lists.get(&id).ok_or(Error::MissingElement)?;
        if !runtime
            .presented
            .iter()
            .any(|node| node.identity == state.identity)
        {
            return Err(Error::MissingElement);
        }
        Ok(runtime.sites.target(state.identity))
    }
    pub fn list_state(&self, target: Target) -> Result<ListViewport, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let id = runtime.list_id(target)?;
        Ok(runtime.lists[&id].viewport.clone())
    }
    /// Visible keyed row root; scope ordinary role/text queries with `within`.
    pub fn list_item(&self, target: Target, key: ItemKey) -> Result<Target, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let id = runtime.list_id(target)?;
        runtime
            .list_rows
            .iter()
            .find(|(_, row)| row.list == id && row.key == key && row.visible)
            .map(|(&identity, _)| runtime.sites.target(identity))
            .ok_or(Error::MissingElement)
    }
    pub fn scroll(&mut self, target: Target, delta: f64) -> Result<Commit, Error> {
        if !delta.is_finite() || delta.abs() > MAX_EXTENT {
            return Err(ListError::InvalidDelta.into());
        }
        self.scroll_list(target, ScrollPosition::Delta(delta))
    }
    pub fn scroll_to_index(&mut self, target: Target, index: usize) -> Result<Commit, Error> {
        self.scroll_list(target, ScrollPosition::Index(index))
    }
    pub fn scroll_to_key(&mut self, target: Target, key: ItemKey) -> Result<Commit, Error> {
        self.scroll_list(target, ScrollPosition::Key(key))
    }
    fn scroll_list(&mut self, target: Target, position: ScrollPosition) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let id = runtime.list_id(target)?;
        if matches!(position, ScrollPosition::Delta(0.0)) {
            return Ok(runtime.commit());
        }
        runtime.changed_nodes = 0;
        runtime.describe_with(false, Some(ScrollRequest { id, position }))?;
        runtime.present()
    }
    /// Physical window point; delta is in logical layout units.
    pub fn scroll_at(&mut self, point: Point, delta: f64) -> Result<Commit, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        if !Rect::new(
            0.0,
            0.0,
            runtime.presentation_size[0] as f32,
            runtime.presentation_size[1] as f32,
        )
        .contains(point)
        {
            return Err(Error::NotHittable);
        }
        // Use the same painter-order occlusion as pointer input. A later
        // painted/interactive overlay outside a list blocks the wheel too.
        let mut cursor = runtime
            .presented
            .iter()
            .enumerate()
            .rev()
            .find(|(index, node)| {
                (node.hittable || node.kind == NodeKind::List) && runtime.sheet_hit(*index, point)
            })
            .map(|(index, _)| index)
            .ok_or(Error::NotHittable)?;
        let target = loop {
            let node = &runtime.presented[cursor];
            if node.kind == NodeKind::List {
                break runtime.sites.target(node.identity);
            }
            cursor = node.parent.index().ok_or(Error::NotHittable)?;
        };
        self.scroll(target, delta)
    }
}
impl<M: View + 'static> Runtime<M> {
    fn list_id(&self, target: Target) -> Result<ListId, Error> {
        let identity = self.resolve(target)?;
        self.lists
            .iter()
            .find(|(_, state)| state.identity == identity)
            .map(|(&id, _)| id)
            .ok_or(ListError::NotList.into())
    }
    pub(super) fn sheet_hit(&self, index: usize, point: Point) -> bool {
        let node = &self.presented[index];
        if !node.bounds.contains(point)
            || !node.transform.get().is_some_and(|map| {
                let radius = self
                    .metadata
                    .as_ref()
                    .and_then(|m| m.geometry.as_ref())
                    .map_or(0.0, |g| g.frozen_radius(node.identity));
                if radius == 0.0 {
                    CoordinateSpace::new(map).hit(node.rect, point)
                } else {
                    gpui_canvas::rounded_rect_contains(node.rect, radius, map, point)
                        .unwrap_or(false)
                }
            })
        {
            return false;
        }
        if self.lists.is_empty() {
            return true;
        }
        let mut cursor = node.parent.index();
        while let Some(index) = cursor {
            let node = &self.presented[index];
            if matches!(node.kind, NodeKind::List | NodeKind::ListItem)
                && !node
                    .transform
                    .get()
                    .is_some_and(|map| CoordinateSpace::new(map).hit(node.rect, point))
            {
                return false;
            }
            cursor = node.parent.index();
        }
        true
    }
    pub(super) fn in_list(&self, mut index: usize) -> bool {
        loop {
            if self.nodes[index].kind() == NodeKind::ListItem {
                return true;
            }
            match self.nodes[index].parent.index() {
                Some(parent) => index = parent,
                None => return false,
            }
        }
    }
}
