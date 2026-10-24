//! Borrowed semantic queries over the acknowledged sheet, shared by tools and
//! application users. Queries never construct a diagnostic snapshot or mirror.
use super::{Actions, Error, Presented, Runtime, Target, View, Win};
use crate::identity::Sites;
use crate::{Rect, Role, remote::LaneSet};

mod serialize;
pub use serialize::SemanticSnapshot;

// One borrowed context on the visitor stack, not a context pointer or semantic
// mirror retained per node. Every part borrows this same acknowledged sheet.
struct Context<'a> {
    sites: &'a Sites,
    text: Option<&'a super::text_geometry::TextResources>,
    size: [u32; 2],
    nodes: &'a [Presented],
    focused: Option<Target>,
    #[cfg(feature = "accessibility")]
    focused_hint: Option<usize>,
    metadata: Option<&'a super::metadata::Sheet>,
    geometry: super::geometry::GeometryView<'a>,
    selection: Option<super::editing::SelectionSnapshot>,
}
impl<'a> Context<'a> {
    fn new<M>(runtime: &'a Runtime<M>) -> Self {
        Self {
            sites: &runtime.sites,
            text: runtime.text.as_deref(),
            size: runtime.presentation_size,
            nodes: &runtime.presented,
            focused: runtime.focused,
            #[cfg(feature = "accessibility")]
            focused_hint: runtime
                .focused
                .and_then(|target| runtime.sites.resolve(target))
                .and_then(|identity| runtime.by_identity.get(identity)),
            selection: runtime
                .metadata
                .as_ref()
                .and_then(|m| m.editing.as_ref())
                .and_then(|frozen| frozen.presented),
            geometry: runtime.presented_geometry(),
            metadata: runtime
                .metadata
                .as_ref()
                .map(|metadata| &metadata.presented),
        }
    }
    fn part(&self, index: usize) -> Part<'_> {
        Part {
            index,
            context: self,
        }
    }
}

/// A checked, borrowed P. Native projection cannot fail halfway through an
/// adapter update: this borrow freezes its already-validated context throughout
/// conversion, with no callbacks into application code.
#[cfg(feature = "accessibility")]
pub(crate) struct SemanticSheet<'a>(Context<'a>);
#[cfg(feature = "accessibility")]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) struct SemanticState {
    pub token: Option<crate::PresentationToken>,
    pub epoch: u64,
    pub valid: bool,
    pub focus: Option<Target>,
    pub size: [u32; 2],
}
#[cfg(feature = "accessibility")]
impl SemanticSheet<'_> {
    pub(crate) fn focused(&self) -> Option<Part<'_>> {
        let identity = self.0.sites.resolve(self.0.focused?)?;
        // The current logical index is only a hint. Lists compact P, and an
        // eligible older P may differ from the current description. Certify
        // membership by P identity before using it; otherwise search P itself.
        let index = self
            .0
            .focused_hint
            .filter(|&index| {
                self.0
                    .nodes
                    .get(index)
                    .is_some_and(|node| node.identity == identity)
            })
            .or_else(|| {
                self.0
                    .nodes
                    .iter()
                    .position(|node| node.identity == identity)
            })?;
        Some(self.0.part(index))
    }
    pub(crate) fn len(&self) -> usize {
        self.0.nodes.len()
    }
    pub(crate) fn part_at(&self, index: usize) -> Option<Part<'_>> {
        self.0.nodes.get(index).map(|_| self.0.part(index))
    }
    pub(crate) fn children(&self, index: usize) -> impl Iterator<Item = Part<'_>> {
        self.0
            .nodes
            .iter()
            .enumerate()
            .skip(index + 1)
            .take_while(move |(_, node)| node.parent.index().is_some_and(|parent| parent >= index))
            .filter(move |(_, node)| node.parent.index() == Some(index))
            .map(|(index, _)| self.0.part(index))
    }
    pub(crate) fn visit(&self, mut visitor: impl FnMut(Part<'_>)) {
        for index in 0..self.0.nodes.len() {
            visitor(self.0.part(index));
        }
    }
}

#[derive(Clone, Copy)]
/// Borrowed semantic data cannot outlive a visitor invocation.
///
/// ```compile_fail
/// use gpui::{El, View, Win, text};
/// struct Page;
/// impl View for Page { fn view(&self) -> El<'_> { text("page") } }
/// let win = Win::demo(Page);
/// let mut saved = None;
/// win.visit(|part| saved = part.text()).unwrap();
/// println!("{saved:?}");
/// ```
pub struct Part<'a> {
    index: usize,
    context: &'a Context<'a>,
}
impl<'a> Part<'a> {
    fn node(self) -> &'a Presented {
        &self.context.nodes[self.index]
    }

    #[cfg(feature = "accessibility")]
    pub(crate) fn native_id(self) -> u64 {
        self.node().identity
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn text_lease(self) -> Option<&'a crate::shared_text::SharedText> {
        self.node().text.as_ref()
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn text_geometry_lease(
        self,
    ) -> Option<&'a std::sync::Arc<gpui_canvas::TextGeometry>> {
        Some(&self.context.text?.entry(self.index)?.map)
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn native_parent_index(self) -> Option<usize> {
        self.node().parent.index()
    }
    /// Stable window-qualified identity, also used by input and inspector APIs.
    /// Merely reading a target does not grant it a particular action.
    #[inline]
    pub fn target(self) -> Target {
        self.context.sites.target(self.node().identity)
    }
    pub fn parent(self) -> Option<Target> {
        self.node().parent.index().map(|index| {
            self.context
                .sites
                .target(self.context.nodes[index].identity)
        })
    }
    /// Current interaction focus on this presented part. Structural/value and
    /// geometry data come from the acknowledged sheet; focus can change without
    /// a frame or source edit, and is revoked immediately on logical removal.
    pub fn focused(self) -> bool {
        self.context.focused == Some(self.target())
    }
    /// Disabled state from the acknowledged presentation.
    pub fn disabled(self) -> bool {
        self.node().disabled()
    }
    /// Input validation state from the acknowledged presentation. This is
    /// independent of focus, editability, and an application's color policy.
    pub fn invalid(self) -> bool {
        self.node().invalid()
    }
    pub fn actions(self) -> Actions {
        self.node().actions
    }
    pub fn role(self) -> Role {
        self.node().kind.role()
    }
    /// The two-state checkbox value from the acknowledged presentation.
    /// Other roles have no checked state. Activation does not change it until
    /// the model describes a new value and that presentation is acknowledged.
    pub fn checked(self) -> Option<bool> {
        match self.node().kind {
            super::NodeKind::CheckBox(checked) => Some(checked),
            _ => None,
        }
    }
    pub fn text(self) -> Option<&'a str> {
        self.node().text.as_deref()
    }
    /// Exact target/rounded-shape and viewport hit from this P. This is the
    /// ordinary dispatcher predicate, independent from newer logical state.
    pub fn contains_point(self, point: crate::Point) -> bool {
        contains_point(
            self.context.nodes,
            self.context.geometry,
            self.context
                .metadata
                .is_some_and(|metadata| !metadata.viewports.is_empty()),
            self.index,
            point,
        )
    }
    /// Exact text geometry and origin from this acknowledged presentation.
    /// Available while native accessibility is inactive and across failed L/C.
    pub fn text_geometry(self) -> Option<super::text_geometry::TextGeometry<'a>> {
        let entry = self.context.text?.entry(self.index)?;
        Some(super::text_geometry::TextGeometry {
            part: self,
            map: &entry.map,
            origin: entry.origin,
        })
    }
    pub(super) fn text_clip(self) -> Rect {
        let size = self.context.size;
        let viewport = Rect::new(0., 0., size[0] as f32, size[1] as f32);
        if self
            .context
            .metadata
            .is_none_or(|metadata| metadata.viewports.is_empty())
            && !self.context.geometry.has_clips()
        {
            return viewport;
        }
        let mut clip = viewport;
        let mut index = Some(self.index);
        while let Some(row) = index {
            let node = &self.context.nodes[row];
            if self.context.geometry.clips(node.identity)
                || matches!(
                    node.kind,
                    super::NodeKind::List | super::NodeKind::ListItem | super::NodeKind::Scroll
                )
            {
                clip = node
                    .transform(self.context.geometry.bases())
                    .and_then(|map| {
                        gpui_reactivity_core::CoordinateSpace::new(map).bounds(node.local_rect())
                    })
                    .map_or(Rect::default(), |bounds| clip.intersection(bounds));
            }
            index = node.parent.index();
        }
        clip
    }
    /// An explicit declared/inspector name, or the visual label fallback.
    /// Edited input values never become accessible names.
    pub fn name(self) -> Option<&'a str> {
        if let Some(slot) = self
            .context
            .metadata
            .and_then(|metadata| metadata.name(self.node().identity))
        {
            return slot.value.as_deref();
        }
        (self.node().kind != super::NodeKind::Input)
            .then(|| self.text())
            .flatten()
    }
    pub fn description(self) -> Option<&'a str> {
        self.context
            .metadata
            .and_then(|metadata| metadata.description(self.node().identity))
            .and_then(|slot| slot.value.as_deref())
    }
    /// Frozen total source length for this published list container.
    pub fn list(self) -> Option<super::ListInfo> {
        self.context
            .metadata
            .and_then(|metadata| metadata.list(self.node().identity))
    }
    /// Frozen position/key/count for this published row wrapper. Descendants
    /// can walk parent targets; positions are never inferred from keys or y.
    pub fn list_item(self) -> Option<super::ListItemInfo> {
        let metadata = self.context.metadata?;
        let row = metadata.row(self.node().identity)?;
        // Row wrappers are immediate children of their list in this SAME P.
        // The parent already freezes the count; neither field needs repeating
        // per row, and current logical list state must never supply them.
        let parent = &self.context.nodes[self.node().parent.index()?];
        let list = metadata.list(parent.identity)?;
        Some(super::ListItemInfo {
            list: self.context.sites.target(parent.identity),
            key: row.key,
            index: row.index,
            count: list.count,
        })
    }
    /// Frozen local scroll range and offset, independent of newer candidates.
    pub fn viewport(self) -> Option<crate::ScrollViewport> {
        self.context
            .metadata
            .and_then(|metadata| metadata.viewport(self.node().identity, self.context.nodes))
    }
    pub fn value(self) -> Option<&'a str> {
        (self.node().kind == super::NodeKind::Input)
            .then(|| self.text())
            .flatten()
    }
    /// Selection in the acknowledged input text, independent of newer logical
    /// edits or an unacknowledged candidate. Other parts have no selection.
    pub fn selection(self) -> Option<gpui_canvas::TextSelection> {
        let value = self.value()?;
        if let Some(selection) = self
            .context
            .selection
            .and_then(|snapshot| snapshot.selection(self.node().identity))
        {
            return Some(selection);
        }
        let caret = gpui_canvas::TextPosition {
            offset: gpui_canvas::TextOffset::new(value.len())?,
            affinity: gpui_canvas::CaretAffinity::Downstream,
        };
        Some(gpui_canvas::TextSelection {
            anchor: caret,
            focus: caret,
        })
    }
    /// Physical viewport-clipped bounds of the acknowledged presentation.
    /// Uniform local radius from this acknowledged sheet, independent of a
    /// newer logical inspector edit or an unacknowledged visual candidate.
    pub fn clips_children(self) -> bool {
        self.context.geometry.clips(self.node().identity)
    }
    pub fn corner_radius(self) -> f32 {
        self.context.geometry.radius(self.node().identity)
    }
    pub fn bounds(self) -> Rect {
        self.node().bounds
    }
    /// The canonical local rectangle before window/viewport clipping.
    pub fn local_bounds(self) -> Rect {
        self.node().local_rect()
    }
    /// Absolute node-local to window-physical transform, already including
    /// ancestors and DPI. Applying it again as a parent transform is incorrect.
    pub fn transform(self) -> Option<crate::Affine> {
        self.node().transform(self.context.geometry.bases())
    }
    /// Conservative full window-physical bounds, derived only when requested.
    /// Native adapters add the window-to-screen mapping. This differs from
    /// `bounds()` for partially clipped elements and must not be used as a hit
    /// predicate. No second full rectangle is retained per semantic node.
    pub fn unclipped_bounds(self) -> Option<Rect> {
        self.node()
            .transform(self.context.geometry.bases())
            .and_then(|map| {
                gpui_reactivity_core::CoordinateSpace::new(map).bounds(self.node().local_rect())
            })
    }
}

pub struct Query<'a, M: View + 'static> {
    runtime: Option<&'a Runtime<M>>,
    role: Option<Role>,
    text: Option<(&'a str, bool)>,
    name: Option<&'a str>,
    description: Option<&'a str>,
    within: Option<Target>,
}
impl<'a, M: View + 'static> Query<'a, M> {
    pub fn text<'b>(self, text: &'b str) -> Query<'b, M>
    where
        'a: 'b,
    {
        let mut query: Query<'b, M> = self;
        query.text = Some((text, false));
        query
    }
    pub fn containing<'b>(self, text: &'b str) -> Query<'b, M>
    where
        'a: 'b,
    {
        let mut query: Query<'b, M> = self;
        query.text = Some((text, true));
        query
    }
    /// Match the accessible name in conjunction with other dimensions.
    pub fn name<'b>(self, name: &'b str) -> Query<'b, M>
    where
        'a: 'b,
    {
        let mut query: Query<'b, M> = self;
        query.name = Some(name);
        query
    }
    pub fn description<'b>(self, description: &'b str) -> Query<'b, M>
    where
        'a: 'b,
    {
        let mut query: Query<'b, M> = self;
        query.description = Some(description);
        query
    }
    /// Restrict this query to one presented subtree, including its root.
    pub fn within(mut self, target: Target) -> Self {
        self.within = Some(target);
        self
    }
    fn scope(&self, runtime: &'a Runtime<M>) -> Result<std::ops::Range<usize>, Error> {
        let Some(target) = self.within else {
            return Ok(0..runtime.presented.len());
        };
        let identity = runtime.sites.resolve(target).ok_or(Error::StaleTarget)?;
        let root = runtime
            .presented
            .iter()
            .position(|node| node.identity == identity)
            .ok_or(Error::StaleTarget)?;
        // Preorder makes a subtree contiguous. Its first following nonmember
        // attaches before root (or has no parent), so no ancestor walks or
        // retained subtree-end column are needed for scoped semantic queries.
        let following = &runtime.presented[root + 1..];
        let len = following
            .iter()
            .position(|node| node.parent.index().is_none_or(|parent| parent < root))
            .unwrap_or(following.len());
        Ok(root..root + 1 + len)
    }
    fn matches(&self, part: Part<'_>) -> bool {
        self.role.is_none_or(|role| part.role() == role)
            && self.name.is_none_or(|name| part.name() == Some(name))
            && self
                .description
                .is_none_or(|description| part.description() == Some(description))
            && self.text.is_none_or(|(text, contains)| {
                part.text().is_some_and(|actual| {
                    if contains {
                        actual.contains(text)
                    } else {
                        actual == text
                    }
                })
            })
    }
    /// Count the presented matches without minting target records.
    pub fn count(&self) -> Result<usize, Error> {
        let mut count = 0;
        let runtime = self.runtime.ok_or(Error::Closed)?;
        sheet(runtime)?;
        let context = Context::new(runtime);
        for index in self.scope(runtime)? {
            count += usize::from(self.matches(context.part(index)));
        }
        Ok(count)
    }
    /// Resolve one unique live match. Ambiguity is an error, not first-match
    /// dispatch to a possibly different instance of a reusable component.
    pub fn one(&self) -> Result<Target, Error> {
        let runtime = self.runtime.ok_or(Error::Closed)?;
        runtime.live()?;
        runtime.current_presentation()?;
        let mut identity = 0;
        let mut count = 0;
        let context = Context::new(runtime);
        for index in self.scope(runtime)? {
            if self.matches(context.part(index)) {
                count += 1;
                identity = runtime.presented[index].identity;
            }
        }
        match count {
            0 => Err(Error::MissingElement),
            1 => Ok(runtime.sites.target(identity)),
            matches => Err(Error::AmbiguousElement { matches }),
        }
    }
}

fn sheet<M: View + 'static>(runtime: &Runtime<M>) -> Result<(), Error> {
    runtime.live()?;
    if runtime.presentation_valid {
        Ok(())
    } else {
        Err(Error::PresentationStale)
    }
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    #[cfg(feature = "accessibility")]
    pub(crate) fn accessibility_namespace(&self) -> Result<std::num::NonZeroU64, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        Ok(runtime.sites.namespace())
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn accessibility_sheet(&self) -> Result<SemanticSheet<'_>, Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        if runtime.next_identity > u64::MAX / 4 {
            return Err(Error::ResourceLimit);
        }
        Ok(SemanticSheet(Context::new(runtime)))
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn accessibility_state(&self) -> Result<SemanticState, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        // Native even IDs name sites; odd IDs name projected text children.
        // Keep this projection's finite namespace explicit and checked.
        if runtime.next_identity > u64::MAX / 4 {
            return Err(Error::ResourceLimit);
        }
        Ok(SemanticState {
            // New candidates do not change the acknowledged sheet's identity.
            // The window namespace is constant; only one sequence is retained.
            token: runtime
                .presented_sequence
                .map(|sequence| crate::PresentationToken {
                    window: runtime.sites.namespace(),
                    sequence,
                }),
            epoch: runtime.presentation_epoch,
            valid: runtime.presentation_valid,
            focus: runtime.focused,
            size: runtime.presentation_size,
        })
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn accessibility_target(&self, id: u64) -> Result<Target, Error> {
        if id == 0 {
            return Err(Error::StaleTarget);
        }
        let runtime = self.runtime()?;
        runtime.live()?;
        let target = runtime.sites.target(id);
        runtime.resolve(target)?;
        Ok(target)
    }
    #[cfg(feature = "accessibility")]
    pub(crate) fn accessibility_viewport_transform(
        &self,
        target: Target,
    ) -> Result<crate::Affine, Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        let identity = runtime.resolve(target)?;
        let index = runtime
            .metadata
            .as_ref()
            .and_then(|metadata| metadata.presented.viewports.index(identity))
            .ok_or(Error::NotInteractive)?;
        runtime
            .presented
            .get(index)
            .filter(|node| node.identity == identity)
            .and_then(|node| node.transform(runtime.presented_geometry().bases()))
            .ok_or(Error::StaleTarget)
    }
    pub fn query(&self) -> Query<'_, M> {
        Query {
            runtime: self.inner.as_deref(),
            role: None,
            text: None,
            name: None,
            description: None,
            within: None,
        }
    }
    pub fn role(&self, role: Role) -> Query<'_, M> {
        Query {
            runtime: self.inner.as_deref(),
            role: Some(role),
            text: None,
            name: None,
            description: None,
            within: None,
        }
    }
    pub fn contains_text(&self, text: &str) -> Result<bool, Error> {
        Ok(self.query().containing(text).count()? != 0)
    }
    /// Visit a borrowed coherent semantic sheet, including an older sheet while
    /// accepted source edits await a successful presentation. Parts cannot escape
    /// this borrow. No target records or snapshot strings are allocated.
    pub fn visit(&self, mut visitor: impl FnMut(Part<'_>)) -> Result<(), Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        let context = Context::new(runtime);
        for index in 0..context.nodes.len() {
            visitor(context.part(index));
        }
        Ok(())
    }
    pub fn bounds(&self, target: Target) -> Result<Rect, Error> {
        let runtime = self.runtime()?;
        sheet(runtime)?;
        let identity = runtime.sites.resolve(target).ok_or(Error::StaleTarget)?;
        runtime
            .presented
            .iter()
            .find(|node| node.identity == identity)
            .map(|node| node.bounds)
            .ok_or(Error::StaleTarget)
    }
    pub fn filter_count(
        &self,
        mut predicate: impl FnMut(Part<'_>) -> bool,
    ) -> Result<usize, Error> {
        let mut count = 0;
        self.visit(|part| count += usize::from(predicate(part)))?;
        Ok(count)
    }
}

#[cfg(all(test, feature = "accessibility"))]
mod tests {
    use super::*;
    struct Buttons;
    impl View for Buttons {
        fn view(&self) -> crate::El<'_> {
            crate::column((crate::button("first"), crate::button("second")))
        }
    }
    #[test]
    fn focus_hint_requires_acknowledged_identity_membership() {
        let mut win = Win::demo(Buttons);
        assert!(win.accessibility_sheet().unwrap().focused().is_none());
        let second = win.button("second");
        win.focus(second).unwrap();
        let runtime = win.runtime().unwrap();
        let mut context = Context::new(runtime);
        assert_eq!(SemanticSheet(context).focused().unwrap().target(), second);
        for hint in [None, Some(0), Some(usize::MAX)] {
            context = Context::new(runtime);
            context.focused_hint = hint;
            assert_eq!(SemanticSheet(context).focused().unwrap().target(), second);
        }
        // A new/logically surviving target must not become native focus unless
        // the acknowledged sheet actually contains it, regardless of the hint.
        context = Context::new(runtime);
        context.focused = Some(runtime.sites.target(u64::MAX / 4));
        context.focused_hint = Some(1);
        assert!(SemanticSheet(context).focused().is_none());
    }
}

// One sheet-qualified borrow for hit traversal, never retained in a row/owner.
pub(super) struct HitSheet<'a> {
    pub nodes: &'a [Presented],
    pub geometry: super::geometry::GeometryView<'a>,
    pub size: [u32; 2],
    pub has_viewports: bool,
}
impl HitSheet<'_> {
    #[inline(always)]
    pub fn contains_window(&self, point: crate::Point) -> bool {
        Rect::new(0., 0., self.size[0] as f32, self.size[1] as f32).contains(point)
    }
    #[inline]
    pub fn hit(&self, point: crate::Point) -> Option<usize> {
        let mut rows = self.nodes.iter().enumerate().rev();
        while let Some((index, node)) = rows.next() {
            if !node.hittable {
                let skip = node.parent.skip();
                // Discard the remaining nonhittable run in constant time.
                if skip > 1 {
                    rows.nth(skip - 2);
                }
                continue;
            }
            if contains_point(self.nodes, self.geometry, self.has_viewports, index, point) {
                return Some(index);
            }
        }
        None
    }
}

// Shared by production pointer dispatch and borrowed public/native queries.
// Every clip/shape belongs to the supplied sheet; L cannot skip its checks.
pub(super) fn contains_point(
    nodes: &[Presented],
    geometry: super::geometry::GeometryView<'_>,
    has_viewports: bool,
    index: usize,
    point: crate::Point,
) -> bool {
    let node = &nodes[index];
    if !node.bounds.contains(point)
        || !node.transform(geometry.bases()).is_some_and(|map| {
            gpui_canvas::rounded_rect_contains(
                node.local_rect(),
                geometry.radius(node.identity),
                map,
                point,
            )
            .unwrap_or(false)
        })
    {
        return false;
    }
    // The empty frozen P column proves absence without consulting L.
    if !has_viewports && !geometry.has_clips() {
        return true;
    }
    let mut parent = node.parent.index();
    while let Some(index) = parent {
        let node = &nodes[index];
        let clipped = geometry.clips(node.identity);
        if (clipped
            || matches!(
                node.kind,
                super::NodeKind::List | super::NodeKind::ListItem | super::NodeKind::Scroll
            ))
            && !node.transform(geometry.bases()).is_some_and(|map| {
                gpui_canvas::rounded_rect_contains(
                    node.local_rect(),
                    if clipped {
                        geometry.radius(node.identity)
                    } else {
                        0.0
                    },
                    map,
                    point,
                )
                .unwrap_or(false)
            })
        {
            return false;
        }
        parent = node.parent.index();
    }
    true
}

#[cfg(test)]
mod geometry_layout_tests {
    use super::*;
    #[test]
    fn basis_borrowed_geometry_context_layout_is_explicit() {
        println!(
            "BASIS_QUERY_LAYOUT context={} context_align={} part={} geometry_view={} bases={}",
            size_of::<Context<'_>>(),
            std::mem::align_of::<Context<'_>>(),
            size_of::<Part<'_>>(),
            size_of::<super::super::geometry::GeometryView<'_>>(),
            size_of::<super::super::geometry::Bases<'_>>()
        );
        assert_eq!(size_of::<Part<'_>>(), 16);
        assert_eq!(size_of::<super::super::geometry::GeometryView<'_>>(), 24);
        assert_eq!(size_of::<super::super::geometry::Bases<'_>>(), 16);
    }
}
