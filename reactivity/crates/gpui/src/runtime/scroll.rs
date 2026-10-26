//! Cold viewport payloads reuse the existing list owner lane.
use super::*;
use crate::{Axis, ScrollDelta, ScrollError, ScrollOffset, ScrollViewport};

pub(super) struct ScrollState {
    pub axes: Axis,
    pub offset: ScrollOffset,
}
pub(super) enum ViewportState {
    List(ListState),
    Scroll(ScrollState),
}
impl ViewportState {
    pub fn list(&self) -> Option<&ListState> {
        match self {
            Self::List(state) => Some(state),
            Self::Scroll(_) => None,
        }
    }
    pub fn scroll(&self) -> Option<&ScrollState> {
        match self {
            Self::Scroll(state) => Some(state),
            Self::List(_) => None,
        }
    }
}
#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub(super) enum ViewportKey {
    List(ListId),
    Scroll(u64),
}
impl ViewportState {
    pub fn identity(&self, key: ViewportKey) -> u64 {
        match self {
            Self::List(state) => state.identity,
            Self::Scroll(_) => match key {
                ViewportKey::Scroll(identity) => identity,
                _ => unreachable!("viewport key matches payload"),
            },
        }
    }
}
impl<M: View + 'static> Runtime<M> {
    pub(super) fn has_lists(&self) -> bool {
        // Derived ordering puts List keys first, before all ordinary Scroll keys.
        matches!(
            self.viewports.first_key_value(),
            Some((ViewportKey::List(_), _))
        )
    }
    pub(super) fn list_by_id(&self, id: ListId) -> Option<(u64, &ListState)> {
        self.viewports
            .get(&ViewportKey::List(id))
            .and_then(ViewportState::list)
            .map(|state| (state.identity, state))
    }
}
#[derive(Clone, Copy, Debug, PartialEq)]
pub(super) enum ViewportInfo {
    List {
        info: ListInfo,
        scroll: ScrollViewport,
    },
    Scroll(ScrollViewport),
}
impl ViewportInfo {
    pub fn list(self) -> Option<ListInfo> {
        match self {
            Self::List { info, .. } => Some(info),
            Self::Scroll(_) => None,
        }
    }
    pub fn scroll(self) -> ScrollViewport {
        match self {
            Self::List { scroll, .. } | Self::Scroll(scroll) => scroll,
        }
    }
}
// Cohort-relative indexes use existing padding; dimensions remain authoritative
// in the same P node. No identity map or node scan is needed to read a range.
#[derive(Clone, Copy, Debug, PartialEq)]
pub(super) struct ListFrozen {
    identity: u64,
    id: ListId,
    count: u32,
    index: u32,
    offset: f64,
    max: f64,
}
#[derive(Clone, Copy, Debug, PartialEq)]
pub(super) struct ScrollFrozen {
    identity: u64,
    axes: Axis,
    index: u32,
    offset: ScrollOffset,
    min: ScrollOffset,
    max: ScrollOffset,
}
#[derive(Clone, Default)]
pub(super) struct Columns {
    lists: Box<[ListFrozen]>,
    scrolls: Box<[ScrollFrozen]>,
}
#[derive(Clone, Default)]
pub(super) enum ViewportColumn {
    #[default]
    Empty,
    Lists(Box<[ListFrozen]>),
    Scrolls(Box<[ScrollFrozen]>),
    Mixed(Box<Columns>),
}
fn find<T>(rows: &[T], identity: u64, key: impl Fn(&T) -> u64) -> Option<&T> {
    rows.binary_search_by_key(&identity, key)
        .ok()
        .map(|index| &rows[index])
}
impl ViewportColumn {
    fn lists(&self) -> &[ListFrozen] {
        match self {
            Self::Lists(rows) => rows,
            Self::Mixed(rows) => &rows.lists,
            _ => &[],
        }
    }
    fn scrolls(&self) -> &[ScrollFrozen] {
        match self {
            Self::Scrolls(rows) => rows,
            Self::Mixed(rows) => &rows.scrolls,
            _ => &[],
        }
    }
    pub fn is_empty(&self) -> bool {
        matches!(self, Self::Empty)
    }
    pub fn list(&self, identity: u64) -> Option<ListInfo> {
        let row = find(self.lists(), identity, |row| row.identity)?;
        Some(ListInfo {
            id: row.id,
            count: row.count,
        })
    }
    #[cfg(feature = "accessibility")]
    pub fn index(&self, identity: u64) -> Option<usize> {
        find(self.lists(), identity, |row| row.identity)
            .map(|row| row.index as usize)
            .or_else(|| {
                find(self.scrolls(), identity, |row| row.identity).map(|row| row.index as usize)
            })
    }
    pub fn info(&self, identity: u64, nodes: &[Presented]) -> Option<ViewportInfo> {
        if let Some(row) = find(self.lists(), identity, |row| row.identity) {
            let node = nodes
                .get(row.index as usize)
                .filter(|node| node.identity == identity)?;
            return Some(list_info(
                *row,
                [
                    f64::from(node.placement.size[0]),
                    f64::from(node.placement.size[1]),
                ],
            ));
        }
        let row = find(self.scrolls(), identity, |row| row.identity)?;
        let node = nodes
            .get(row.index as usize)
            .filter(|node| node.identity == identity)?;
        Some(scroll_info(
            *row,
            [
                f64::from(node.placement.size[0]),
                f64::from(node.placement.size[1]),
            ],
        ))
    }
    #[cfg(feature = "accessibility")]
    fn payload(&self, identity: u64) -> Option<ViewportInfo> {
        find(self.lists(), identity, |row| row.identity)
            .map(|row| list_info(*row, [0.0; 2]))
            .or_else(|| {
                find(self.scrolls(), identity, |row| row.identity)
                    .map(|row| scroll_info(*row, [0.0; 2]))
            })
    }
    pub fn offset(&self, identity: u64) -> Option<ScrollOffset> {
        find(self.lists(), identity, |row| row.identity)
            .map(|row| ScrollOffset {
                x: 0.0,
                y: row.offset,
            })
            .or_else(|| find(self.scrolls(), identity, |row| row.identity).map(|row| row.offset))
    }
}
#[cfg(feature = "accessibility")]
pub(super) fn same_payload(
    column: Option<&ViewportColumn>,
    identity: u64,
    next: Option<ViewportInfo>,
) -> bool {
    column.and_then(|column| column.payload(identity))
        == next.map(|mut info| {
            match &mut info {
                ViewportInfo::List { scroll, .. } | ViewportInfo::Scroll(scroll) => {
                    scroll.size = [0.0; 2]
                }
            };
            info
        })
}
fn list_info(row: ListFrozen, size: [f64; 2]) -> ViewportInfo {
    ViewportInfo::List {
        info: ListInfo {
            id: row.id,
            count: row.count,
        },
        scroll: ScrollViewport {
            axes: Axis::Y,
            offset: ScrollOffset {
                x: 0.0,
                y: row.offset,
            },
            min: ScrollOffset::default(),
            max: ScrollOffset { x: 0.0, y: row.max },
            size,
        },
    }
}
fn scroll_info(row: ScrollFrozen, size: [f64; 2]) -> ViewportInfo {
    ViewportInfo::Scroll(ScrollViewport {
        axes: row.axes,
        offset: row.offset,
        min: row.min,
        max: row.max,
        size,
    })
}
#[derive(Default)]
pub(super) struct ViewportBuild {
    lists: Vec<ListFrozen>,
    scrolls: Vec<ScrollFrozen>,
}
impl ViewportBuild {
    #[cfg(feature = "accessibility")]
    pub fn info(&self, identity: u64, size: [f64; 2]) -> Option<ViewportInfo> {
        find(&self.lists, identity, |row| row.identity)
            .map(|row| list_info(*row, size))
            .or_else(|| {
                find(&self.scrolls, identity, |row| row.identity).map(|row| scroll_info(*row, size))
            })
    }
    pub fn offset(&self, identity: u64) -> Option<ScrollOffset> {
        find(&self.scrolls, identity, |row| row.identity).map(|row| row.offset)
    }
    pub fn freeze(mut self, mut index: impl FnMut(u64) -> Option<usize>) -> ViewportColumn {
        self.lists.retain_mut(|row| {
            index(row.identity).is_some_and(|index| {
                row.index = index as u32;
                true
            })
        });
        self.scrolls.retain_mut(|row| {
            index(row.identity).is_some_and(|index| {
                row.index = index as u32;
                true
            })
        });
        match (self.lists.is_empty(), self.scrolls.is_empty()) {
            (true, true) => ViewportColumn::Empty,
            (false, true) => ViewportColumn::Lists(self.lists.into_boxed_slice()),
            (true, false) => ViewportColumn::Scrolls(self.scrolls.into_boxed_slice()),
            (false, false) => ViewportColumn::Mixed(Box::new(Columns {
                lists: self.lists.into_boxed_slice(),
                scrolls: self.scrolls.into_boxed_slice(),
            })),
        }
    }
}

const MAX_RANGE: f64 = (1_u64 << 40) as f64;

/// Transform overflow inherits relative mappings and nearest viewport indexes
/// through the active ancestor frontier.
/// A nested viewport contributes its aperture, never its hidden content.
fn bounds64(space: CoordinateSpace, rect: Rect) -> Result<[f64; 4], Error> {
    let [a, b, c, d, x, y] = space.coefficients();
    let mut edges = [
        f64::INFINITY,
        f64::INFINITY,
        f64::NEG_INFINITY,
        f64::NEG_INFINITY,
    ];
    for u in [f64::from(rect.x), f64::from(rect.x) + f64::from(rect.width)] {
        for v in [
            f64::from(rect.y),
            f64::from(rect.y) + f64::from(rect.height),
        ] {
            let (px, py) = (a * u + c * v + x, b * u + d * v + y);
            if !px.is_finite() || !py.is_finite() {
                return Err(ScrollError::UnsupportedTransform.into());
            }
            edges[0] = edges[0].min(px);
            edges[1] = edges[1].min(py);
            edges[2] = edges[2].max(px);
            edges[3] = edges[3].max(py);
        }
    }
    Ok(edges)
}
pub(super) fn geometry<M: View + 'static>(runtime: &Runtime<M>) -> Result<ViewportBuild, Error> {
    let lists = runtime
        .viewports
        .keys()
        .take_while(|key| matches!(key, ViewportKey::List(_)))
        .count();
    let mut infos = ViewportBuild {
        lists: Vec::with_capacity(lists),
        scrolls: Vec::with_capacity(runtime.viewports.len() - lists),
    };
    let mut has_scroll = false;
    for (&key, state) in &runtime.viewports {
        let identity = state.identity(key);
        let layout = runtime.layout.layout(
            runtime
                .layout_nodes
                .required(runtime.by_identity.required(identity)),
        )?;
        match key {
            ViewportKey::List(id) => {
                let state = state.list().unwrap();
                infos.lists.push(ListFrozen {
                    identity,
                    id,
                    count: state.viewport.len as u32,
                    index: 0,
                    offset: state.viewport.offset,
                    max: (state.viewport.extent - state.viewport.viewport_height).max(0.0),
                });
            }
            ViewportKey::Scroll(_) => {
                has_scroll = true;
                let state = state.scroll().unwrap();
                infos.scrolls.push(ScrollFrozen {
                    identity,
                    axes: state.axes,
                    index: 0,
                    offset: state.offset,
                    min: ScrollOffset {
                        x: f64::from(layout.scrollable_overflow_rect.left).min(0.0),
                        y: f64::from(layout.scrollable_overflow_rect.top).min(0.0),
                    },
                    max: ScrollOffset {
                        x: f64::from(layout.scrollable_overflow_rect.right)
                            .max(f64::from(layout.size.width)),
                        y: f64::from(layout.scrollable_overflow_rect.bottom)
                            .max(f64::from(layout.size.height)),
                    },
                });
            }
        }
    }
    infos.lists.sort_unstable_by_key(|row| row.identity);
    infos.scrolls.sort_unstable_by_key(|row| row.identity);
    if !has_scroll {
        return Ok(infos);
    }
    let mut frontier = super::frontier::Frontier::new(
        (CoordinateSpace::new(Affine::IDENTITY), Parent::NONE),
        usize::from(runtime.layout_depth),
    );
    let mut ancestor = Parent::NONE;
    for (index, node) in runtime.nodes.iter().enumerate() {
        let layout = runtime
            .layout
            .layout(runtime.layout_nodes.required(index))?;
        while ancestor.index() != node.parent().index() {
            frontier.pop();
            ancestor = runtime.nodes[ancestor.index().unwrap()].parent();
        }
        let (parent_space, nearest) = frontier.top();
        let parent = node.parent().index();
        let inherited = nearest.index();
        let base = parent
            .filter(|&parent| {
                !matches!(
                    runtime.nodes[parent].kind(),
                    NodeKind::List | NodeKind::Scroll
                )
            })
            .map_or(CoordinateSpace::new(Affine::IDENTITY), |_| parent_space);
        let space = base
            .compose(Affine::translation(layout.location.x, layout.location.y))
            .compose(runtime.styles.get(index).transform);
        let rect = Rect::new(0.0, 0.0, layout.size.width, layout.size.height);
        if !rect.is_empty()
            && let Some(parent) = inherited
        {
            let viewport = &mut infos.scrolls[parent];
            let edges = bounds64(space, rect)?;
            viewport.min.x = viewport.min.x.min(edges[0]);
            viewport.min.y = viewport.min.y.min(edges[1]);
            viewport.max.x = viewport.max.x.max(edges[2]);
            viewport.max.y = viewport.max.y.max(edges[3]);
        }
        let own = infos
            .scrolls
            .binary_search_by_key(&node.identity(), |row| row.identity)
            .ok();
        if runtime
            .nodes
            .get(index + 1)
            .is_some_and(|next| next.parent().index() == Some(index))
        {
            frontier.push((
                space,
                Parent::new(if node.kind() == NodeKind::List {
                    None
                } else {
                    own.or(inherited)
                }),
            ));
            ancestor = Parent::new(Some(index));
        }
    }
    for viewport in &mut infos.scrolls {
        let layout = runtime.layout.layout(
            runtime
                .layout_nodes
                .required(runtime.by_identity.required(viewport.identity)),
        )?;
        let size = [f64::from(layout.size.width), f64::from(layout.size.height)];
        if [
            viewport.min.x,
            viewport.min.y,
            viewport.max.x,
            viewport.max.y,
            size[0],
            size[1],
        ]
        .iter()
        .any(|value| !value.is_finite() || value.abs() > MAX_RANGE)
        {
            return Err(ScrollError::ResourceLimit.into());
        }
        viewport.max.x = (viewport.max.x - size[0]).max(0.0);
        viewport.max.y = (viewport.max.y - size[1]).max(0.0);
        if !viewport.axes.x() {
            viewport.min.x = 0.0;
            viewport.max.x = 0.0;
        }
        if !viewport.axes.y() {
            viewport.min.y = 0.0;
            viewport.max.y = 0.0;
        }
        viewport.offset.x = viewport.offset.x.clamp(viewport.min.x, viewport.max.x);
        viewport.offset.y = viewport.offset.y.clamp(viewport.min.y, viewport.max.y);
    }
    Ok(infos)
}

fn checked_delta(delta: ScrollDelta) -> Result<(), Error> {
    if [delta.x, delta.y]
        .iter()
        .any(|value| !value.is_finite() || value.abs() > MAX_RANGE)
    {
        Err(ScrollError::InvalidDelta.into())
    } else {
        Ok(())
    }
}
fn clamped(viewport: ScrollViewport, offset: ScrollOffset) -> ScrollOffset {
    ScrollOffset {
        x: offset.x.clamp(viewport.min.x, viewport.max.x),
        y: offset.y.clamp(viewport.min.y, viewport.max.y),
    }
}

// Plans contain only scalars/indexes into the frozen P borrow. Iteration is
// repeatable: one pass counts/list-plans, the second applies ordinary offsets.
// Ordinary wheel input allocates no request, changed-node or rollback Vec.
#[derive(Clone, Copy)]
enum ScrollPlan {
    Direct {
        identity: u64,
        offset: ScrollOffset,
    },
    Wheel {
        cursor: Option<usize>,
        remaining: [f64; 2],
    },
    Into {
        cursor: Option<usize>,
        edges: [f64; 4],
    },
    Done,
}
#[derive(Clone, Copy)]
struct Context<'a> {
    nodes: &'a [Presented],
    sheet: &'a metadata::Sheet,
    scale: f64,
    geometry: geometry::GeometryView<'a>,
}
struct Changes<'a> {
    context: Context<'a>,
    plan: ScrollPlan,
}
impl ScrollPlan {
    fn iter(self, context: Context<'_>) -> Changes<'_> {
        Changes {
            context,
            plan: self,
        }
    }
}
impl Iterator for Changes<'_> {
    type Item = (u64, ScrollOffset, Option<ListId>);
    fn next(&mut self) -> Option<Self::Item> {
        loop {
            match &mut self.plan {
                ScrollPlan::Done => return None,
                ScrollPlan::Direct { identity, offset } => {
                    let value = self
                        .context
                        .sheet
                        .viewport_info(*identity, self.context.nodes)?;
                    let next = clamped(value.scroll(), *offset);
                    let result = (next != value.scroll().offset).then_some((
                        *identity,
                        next,
                        value.list().map(|list| list.id),
                    ));
                    self.plan = ScrollPlan::Done;
                    return result;
                }
                ScrollPlan::Wheel { cursor, remaining } => {
                    let node = &self.context.nodes[cursor.take()?];
                    *cursor = node.parent.index();
                    let Some(value) = self
                        .context
                        .sheet
                        .viewport_info(node.identity, self.context.nodes)
                    else {
                        continue;
                    };
                    let viewport = value.scroll();
                    let map = node.transform(self.context.geometry.bases())?; // P viewport admission guarantees an invertible axis map.
                    let mut offset = viewport.offset;
                    for (axis, coefficient, low, high, current) in [
                        (
                            0,
                            f64::from(map.a),
                            viewport.min.x,
                            viewport.max.x,
                            &mut offset.x,
                        ),
                        (
                            1,
                            f64::from(map.d),
                            viewport.min.y,
                            viewport.max.y,
                            &mut offset.y,
                        ),
                    ] {
                        let old = *current;
                        let local = remaining[axis] * self.context.scale / coefficient;
                        let requested = old + local;
                        *current = requested.clamp(low, high);
                        if *current != old {
                            remaining[axis] = if requested >= low && requested <= high {
                                0.0
                            } else {
                                let residual =
                                    (local - (*current - old)) * coefficient / self.context.scale;
                                residual.clamp(remaining[axis].min(0.0), remaining[axis].max(0.0))
                            };
                        }
                    }
                    if offset != viewport.offset {
                        return Some((node.identity, offset, value.list().map(|list| list.id)));
                    }
                }
                ScrollPlan::Into { cursor, edges } => {
                    let node = &self.context.nodes[cursor.take()?];
                    *cursor = node.parent.index();
                    let Some(value) = self
                        .context
                        .sheet
                        .viewport_info(node.identity, self.context.nodes)
                    else {
                        continue;
                    };
                    let viewport = value.scroll();
                    let map = node.transform(self.context.geometry.bases())?;
                    let mut requested = viewport.offset;
                    for (axis, coefficient, translation, size, current) in [
                        (
                            0,
                            f64::from(map.a),
                            f64::from(map.tx),
                            viewport.size[0],
                            &mut requested.x,
                        ),
                        (
                            1,
                            f64::from(map.d),
                            f64::from(map.ty),
                            viewport.size[1],
                            &mut requested.y,
                        ),
                    ] {
                        let a = (edges[axis] - translation) / coefficient;
                        let b = (edges[axis + 2] - translation) / coefficient;
                        let (low, high) = (a.min(b), a.max(b));
                        // Project zero onto offsets giving minimal containment:
                        // a small target fits; an oversized target contains the
                        // aperture. Existing overlap does not jump to an end.
                        *current += 0.0_f64.clamp(low.min(high - size), low.max(high - size));
                    }
                    let offset = clamped(viewport, requested);
                    let dx = (offset.x - viewport.offset.x) * f64::from(map.a);
                    let dy = (offset.y - viewport.offset.y) * f64::from(map.d);
                    edges[0] -= dx;
                    edges[2] -= dx;
                    edges[1] -= dy;
                    edges[3] -= dy;
                    // Ancestors must reveal the fragment admitted by this
                    // aperture, not hidden overflow whose AABB can span the
                    // ancestor while the aperture itself is offscreen.
                    for (axis, coefficient, translation, size) in [
                        (0, f64::from(map.a), f64::from(map.tx), viewport.size[0]),
                        (1, f64::from(map.d), f64::from(map.ty), viewport.size[1]),
                    ] {
                        let end = translation + coefficient * size;
                        edges[axis] = edges[axis].max(translation.min(end));
                        edges[axis + 2] = edges[axis + 2].min(translation.max(end));
                    }
                    if edges[0] >= edges[2] || edges[1] >= edges[3] {
                        *cursor = None;
                    }
                    if offset != viewport.offset {
                        return Some((node.identity, offset, value.list().map(|list| list.id)));
                    }
                }
            }
        }
    }
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    /// Read frozen acknowledged viewport metadata, including while a newer C is
    /// pending or failed. Mutations additionally require current coordinate authority.
    pub fn viewport(&self, target: Target) -> Result<ScrollViewport, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        if !runtime.presentation_valid {
            return Err(Error::PresentationStale);
        }
        let identity = runtime.resolve(target)?;
        runtime
            .metadata
            .as_ref()
            .and_then(|metadata| metadata.presented.viewport(identity, &runtime.presented))
            .ok_or(ScrollError::NotViewport.into())
    }
    /// Move in the target viewport's local logical axes.
    pub fn scroll_by(&mut self, target: Target, delta: ScrollDelta) -> Result<Commit, Error> {
        checked_delta(delta)?;
        self.runtime()?.current_presentation()?;
        let viewport = self.viewport(target)?;
        self.scroll_to(
            target,
            ScrollOffset {
                x: viewport.offset.x + delta.x,
                y: viewport.offset.y + delta.y,
            },
        )
    }
    pub fn scroll_to(&mut self, target: Target, offset: ScrollOffset) -> Result<Commit, Error> {
        if [offset.x, offset.y]
            .iter()
            .any(|value| !value.is_finite() || value.abs() > MAX_RANGE)
        {
            return Err(ScrollError::InvalidOffset.into());
        }
        self.runtime()?.current_presentation()?;
        self.viewport(target)?;
        let identity = self.runtime()?.resolve(target)?;
        self.apply_scroll_plan(ScrollPlan::Direct { identity, offset })
    }
    fn apply_scroll_plan(&mut self, plan: ScrollPlan) -> Result<Commit, Error> {
        let mut runtime = self.runtime_mut()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let mut requests = Vec::new(); // Allocates only when virtual rows must be materialized.
        let mut count = 0;
        {
            let state = &mut runtime.runtime;
            let Some(metadata) = &state.metadata else {
                return Ok(state.commit());
            };
            let context = Context {
                nodes: &state.presented,
                sheet: &metadata.presented,
                scale: f64::from(state.presentation_scale_factor),
                geometry: metadata
                    .geometry
                    .as_deref()
                    .map_or_else(geometry::GeometryView::empty, geometry::Geometry::view),
            };
            for (_, offset, list) in plan.iter(context) {
                count += 1;
                if let Some(id) = list {
                    requests.push(ScrollRequest {
                        id,
                        position: list::ScrollPosition::Offset(offset.y),
                    });
                }
            }
            if count == 0 {
                return Ok(state.commit());
            }
            for (identity, offset, list) in plan.iter(context) {
                if list.is_none() {
                    let changed = match state.viewports.get_mut(&ViewportKey::Scroll(identity)) {
                        Some(ViewportState::Scroll(viewport)) if viewport.offset != offset => {
                            viewport.offset = offset; true
                        }
                        _ => false,
                    };
                    if changed {
                        if let Some(index) = state.by_identity.get(identity) {
                            changes::record(&mut state.changes, state.sites.namespace(), state.nodes[index].identity,
                                change_model::Facets::one(change_model::Facet::Transform), change_model::Scope::Subtree,
                                change_model::Support::Pending, change_model::Support::Pending);
                        } else { state.changes.full(change_model::FullReasons::UNKNOWN_DEPENDENCY); }
                    }
                }
            }
        }
        // External aperture changes can retire virtual row capabilities. The
        // existing list reconciliation mints fresh identities when those rows
        // return; ordinary-only trees need no source description.
        let described = !requests.is_empty() || runtime.has_lists();
        let result = if described {
            runtime.describe_with(false, &requests)
        } else {
            Ok(())
        };
        let result = result.and_then(|()| {
            runtime.dirty = true;
            runtime.changed_nodes = count;
            runtime.present()
        });
        if result.is_err() {
            let state = &mut runtime.runtime;
            if let Some(metadata) = &state.metadata {
                for (&key, viewport) in &mut state.viewports {
                    if let (ViewportKey::Scroll(identity), ViewportState::Scroll(viewport)) =
                        (key, viewport)
                        && let Some(frozen) = metadata.presented.viewports.offset(identity)
                    {
                        viewport.offset = frozen;
                    }
                }
            }
            if !described {
                state.dirty = false;
            }
        }
        result
    }
    /// Physical point, window-logical displacement. Each viewport consumes in
    /// its inverse linear space; only residual axes reach its ancestors.
    pub fn scroll_at_2d(&mut self, point: Point, delta: ScrollDelta) -> Result<Commit, Error> {
        checked_delta(delta)?;
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
        let geometry = runtime.presented_geometry();
        let cursor = runtime
            .presented
            .iter()
            .enumerate()
            .rev()
            .find(|(index, node)| {
                (node.hittable || matches!(node.kind, NodeKind::List | NodeKind::Scroll))
                    && runtime.sheet_hit_with_geometry(*index, point, geometry)
            })
            .map(|(index, _)| index)
            .ok_or(Error::NotHittable)?;
        let mut ancestor = Some(cursor);
        let found = std::iter::from_fn(|| {
            let index = ancestor?;
            ancestor = runtime.presented[index].parent.index();
            Some(index)
        })
        .any(|index| {
            matches!(
                runtime.presented[index].kind,
                NodeKind::Scroll | NodeKind::List
            )
        });
        if !found {
            return Err(Error::NotHittable);
        }
        self.apply_scroll_plan(ScrollPlan::Wheel {
            cursor: Some(cursor),
            remaining: [delta.x, delta.y],
        })
    }
    /// Bring full retained bounds into ancestor viewports as far as admitted
    /// ranges permit. This is the same operation used by accessibility.
    pub fn scroll_into_view(&mut self, target: Target) -> Result<Commit, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let identity = runtime.resolve(target)?;
        let index = runtime
            .presented
            .iter()
            .position(|node| node.identity == identity)
            .ok_or(Error::StaleTarget)?;
        let node = &runtime.presented[index];
        let map = node
            .transform(runtime.presented_geometry().bases())
            .ok_or(ScrollError::UnsupportedTransform)?;
        let edges = bounds64(CoordinateSpace::new(map), node.local_rect())?;
        self.apply_scroll_plan(ScrollPlan::Into {
            cursor: node.parent.index(),
            edges,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Role, prelude::*};

    struct Empty;
    impl View for Empty {
        fn view(&self) -> El<'_> {
            div()
        }
    }

    struct List;
    impl ItemSource for List {
        fn len(&self) -> usize {
            0
        }
        fn key(&self, _: usize) -> ItemKey {
            unreachable!()
        }
        fn index_of(&self, _: ItemKey) -> Option<usize> {
            None
        }
        fn row(&self, _: usize) -> El<'_> {
            unreachable!()
        }
    }
    impl View for List {
        fn view(&self) -> El<'_> {
            uniform_list(ListId::new(1), self, 20).size(40)
        }
    }
    struct Page;
    impl View for Page {
        fn view(&self) -> El<'_> {
            column((div().size(80), div().size(80)))
                .scroll(Axis::Y)
                .size(40)
        }
    }
    #[test]
    fn wheel_plan_is_repeatable_without_allocation() {
        let win = Win::with_size(Page, 80, 80).unwrap();
        let runtime = win.runtime().unwrap();
        let context = Context {
            nodes: &runtime.presented,
            sheet: &runtime.metadata.as_ref().unwrap().presented,
            scale: 1.0,
            geometry: runtime.presented_geometry(),
        };
        let plan = ScrollPlan::Wheel {
            cursor: Some(runtime.presented.len() - 1),
            remaining: [0.0, 20.0],
        };
        let measured = allocation_counter::measure(|| {
            let first = plan.iter(context).next().unwrap();
            let second = plan.iter(context).next().unwrap();
            assert_eq!(first, second);
            assert_eq!(first.1.y, 20.0);
        });
        assert_eq!(measured.count_total, 0);
    }

    #[test]
    fn frozen_viewport_index_cannot_alias_a_different_p_node() {
        let win = Win::with_size(Page, 80, 80).unwrap();
        let runtime = win.runtime().unwrap();
        let identity = runtime.presented[0].identity;
        let mut column = runtime
            .metadata
            .as_ref()
            .unwrap()
            .presented
            .viewports
            .clone();
        let ViewportColumn::Scrolls(rows) = &mut column else {
            panic!("ordinary-only column")
        };
        assert_eq!(rows.len(), 1);
        rows[0].index = 1;
        assert!(column.info(identity, &runtime.presented).is_none());
        let ViewportColumn::Scrolls(rows) = &mut column else {
            unreachable!()
        };
        rows[0].index = u32::MAX;
        assert!(column.info(identity, &runtime.presented).is_none());
        assert_eq!(std::mem::size_of::<ViewportColumn>(), 24);
        assert_eq!(std::mem::size_of::<ListFrozen>(), 40);
        assert_eq!(std::mem::size_of::<ScrollFrozen>(), 64);
    }

    #[test]
    #[ignore = "explicit cold and warm whole-operation allocation ledger"]
    fn viewport_storage_and_allocation_ledger() {
        use std::mem::size_of;
        println!(
            "scroll_sizes,Node={},Presented={},Prepared={},Runtime={},El={},Draft={},Extra={},Sheet={},ListState={},ViewportKey={},ViewportState={},ViewportInfo={},ViewportColumn={},ListFrozen={},ScrollFrozen={},ScrollViewport={},Plan={}",
            size_of::<Node>(),
            size_of::<Presented>(),
            size_of::<Prepared>(),
            size_of::<Runtime<()>>(),
            size_of::<El<'_>>(),
            size_of::<crate::element::DraftNode<'_>>(),
            size_of::<crate::semantic::ElementExtra<'_>>(),
            size_of::<metadata::Sheet>(),
            size_of::<ListState>(),
            size_of::<ViewportKey>(),
            size_of::<ViewportState>(),
            size_of::<ViewportInfo>(),
            size_of::<ViewportColumn>(),
            size_of::<ListFrozen>(),
            size_of::<ScrollFrozen>(),
            size_of::<ScrollViewport>(),
            size_of::<ScrollPlan>()
        );
        fn record(label: &str, run: impl FnOnce()) {
            let measured = allocation_counter::measure(run);
            println!(
                "scroll_alloc,{label},count={},total={},retained={},peak={}",
                measured.count_total,
                measured.bytes_total,
                measured.bytes_current,
                measured.bytes_max
            );
        }
        let mut ordinary = None;
        record("ordinary_recording", || {
            ordinary = Some(
                Win::recording(
                    Empty,
                    WindowOptions {
                        size: [80, 80],
                        ..Default::default()
                    },
                )
                .unwrap(),
            )
        });
        drop(ordinary);
        let mut list = None;
        record("first_list_recording", || {
            list = Some(
                Win::recording(
                    List,
                    WindowOptions {
                        size: [80, 80],
                        ..Default::default()
                    },
                )
                .unwrap(),
            )
        });
        drop(list);
        let mut owner = None;
        record("scroll_recording", || {
            owner = Some(
                Win::recording(
                    Page,
                    WindowOptions {
                        size: [80, 80],
                        ..Default::default()
                    },
                )
                .unwrap(),
            )
        });
        let mut owner = owner.unwrap();
        let token = owner.with_scene(|_, token| token).unwrap();
        owner.presented(token).unwrap();
        let target = owner.role(Role::ScrollView).one().unwrap();
        for i in 0..3 {
            record(&format!("warm_scroll_{i}"), || {
                owner
                    .scroll_by(target, ScrollDelta { x: 0.0, y: 10.0 })
                    .unwrap();
                let token = owner.with_scene(|_, token| token).unwrap();
                owner.presented(token).unwrap();
            });
        }
    }
}
