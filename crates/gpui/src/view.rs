use crate::{
    AnyElement, AnyEntity, AnyWeakEntity, App, Bounds, Context, Element, ElementId, Entity,
    EntityId, GlobalElementId, InspectorElementId, IntoElement, LayoutId, PaintIndex, Pixels,
    PrepaintStateIndex, Render, RenderOnce, ResolvedDirection, Style, StyleRefinement,
    ViewDependencies, WeakEntity,
};
use crate::{Empty, Window};
use anyhow::Result;
use refineable::Refineable;
use std::{
    any::{TypeId, type_name},
    fmt,
    ops::Range,
    sync::Arc,
};

/// A type-erased handle to a view.
///
/// It pairs an [`Entity`] with its render function, so a field or collection can hold views of
/// different types. Convert an entity with `AnyView::from` or `.into()`, and recover its type with
/// [`AnyView::downcast`]. An `AnyView` can be a child wherever a view is accepted. Two `AnyView`s
/// compare equal when they refer to the same entity.
///
/// # Example
///
/// ```
/// use gpui::{AnyView, Context, Render, TestApp, Window, div, prelude::*};
///
/// struct First;
/// struct Second;
///
/// impl Render for First {
///     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
///         div().child("First")
///     }
/// }
///
/// impl Render for Second {
///     fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
///         div().child("Second")
///     }
/// }
///
/// let mut app = TestApp::new();
/// let (first, second) = app.update(|cx| (cx.new(|_| First), cx.new(|_| Second)));
/// let views: Vec<AnyView> = vec![first.into(), second.into()];
///
/// assert!(views[0].clone().downcast::<First>().is_ok());
/// assert!(views[1].clone().downcast::<First>().is_err());
/// ```
#[derive(Clone, Debug)]
pub struct AnyView {
    entity: AnyEntity,
    render: fn(&AnyView, &mut Window, &mut App) -> AnyElement,
    view_type_name: &'static str,
}

impl<V: Render> From<Entity<V>> for AnyView {
    fn from(value: Entity<V>) -> Self {
        AnyView {
            entity: value.into_any(),
            render: any_view::render::<V>,
            view_type_name: type_name::<V>(),
        }
    }
}

impl AnyView {
    /// Returns this view as an element with a fixed root layout style.
    ///
    /// GPUI can reuse the rendered subtree while the view's entity, tracked entity and global
    /// reads, and layout environment remain unchanged. Reads made by nested views and deferred
    /// prepaint or paint work are tracked too. A notification to a tracked entity, a tracked
    /// global revision change, or [`Window::refresh`] causes the view to rebuild. Changes to
    /// bounds or inherited layout and paint state can also require fresh output.
    ///
    /// `style` sets the retained root's layout style. Pass the entity directly as a child when it
    /// should keep its natural layout. See [`Entity::cached`] and
    /// [retained view rendering](crate::_documentation::concepts::retained_rendering).
    pub fn cached(self, style: StyleRefinement) -> ViewElement<AnyView> {
        self.into_element().cached(style)
    }

    /// Returns a weak handle to this view. The weak handle doesn't keep the view alive.
    ///
    /// Call [`AnyWeakView::upgrade`] on it to get an `AnyView` back, or `None` once the view has
    /// been dropped.
    pub fn downgrade(&self) -> AnyWeakView {
        AnyWeakView {
            entity: self.entity.downgrade(),
            render: self.render,
            view_type_name: self.view_type_name,
        }
    }

    /// Converts this handle into an [`Entity`] of type `T`.
    ///
    /// Returns `Err` with the unchanged `AnyView` when the view isn't a `T`.
    pub fn downcast<T: 'static>(self) -> Result<Entity<T>, Self> {
        match self.entity.downcast() {
            Ok(entity) => Ok(entity),
            Err(entity) => Err(Self {
                entity,
                render: self.render,
                view_type_name: self.view_type_name,
            }),
        }
    }

    /// Returns the [`TypeId`] of the view's type.
    pub fn entity_type(&self) -> TypeId {
        self.entity.entity_type
    }

    /// Returns the [`EntityId`] of the entity that backs this view.
    pub fn entity_id(&self) -> EntityId {
        self.entity.entity_id()
    }
}

impl PartialEq for AnyView {
    fn eq(&self, other: &Self) -> bool {
        self.entity == other.entity
    }
}

impl Eq for AnyView {}

/// `AnyView` is the type-erased [`View`]. Its render is a function pointer rather than a
/// concrete type, so it takes part in the reactive graph like any other view, with the same
/// identity as its entity.
impl View for AnyView {
    fn entity_id(&self) -> Option<EntityId> {
        Some(self.entity.entity_id())
    }

    #[cfg(not(gpui_hot_reload))]
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        (self.render)(&self, window, cx)
    }

    // The stored function pointer was captured from the original binary, so it must be looked up
    // in the jump table to reach the patched render.
    #[cfg(gpui_hot_reload)]
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        subsecond::HotFn::current(self.render).call((&self, window, cx))
    }
}

impl<V: 'static + Render> IntoElement for Entity<V> {
    type Element = ViewElement<Entity<V>>;

    fn into_element(self) -> Self::Element {
        ViewElement::with_type_name(self, type_name::<V>())
    }

    #[inline(never)]
    fn into_any_element(self) -> AnyElement {
        self.into_element().into_any()
    }
}

impl IntoElement for AnyView {
    type Element = ViewElement<AnyView>;

    fn into_element(self) -> Self::Element {
        let view_type_name = self.view_type_name;
        ViewElement::with_type_name(self, view_type_name)
    }
}

/// A weak, type-erased handle to a view.
///
/// It does not keep the view alive. Create one with [`AnyView::downgrade`] or convert a
/// [`WeakEntity`].
pub struct AnyWeakView {
    entity: AnyWeakEntity,
    render: fn(&AnyView, &mut Window, &mut App) -> AnyElement,
    view_type_name: &'static str,
}

impl AnyWeakView {
    /// Returns a strong [`AnyView`] if the view is still alive, or `None` if it has been dropped.
    pub fn upgrade(&self) -> Option<AnyView> {
        let entity = self.entity.upgrade()?;
        Some(AnyView {
            entity,
            render: self.render,
            view_type_name: self.view_type_name,
        })
    }
}

impl<V: 'static + Render> From<WeakEntity<V>> for AnyWeakView {
    fn from(view: WeakEntity<V>) -> Self {
        AnyWeakView {
            entity: view.into(),
            render: any_view::render::<V>,
            view_type_name: type_name::<V>(),
        }
    }
}

impl PartialEq for AnyWeakView {
    fn eq(&self, other: &Self) -> bool {
        self.entity == other.entity
    }
}

impl std::fmt::Debug for AnyWeakView {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("AnyWeakView")
            .field("entity_id", &self.entity.entity_id)
            .finish_non_exhaustive()
    }
}

mod any_view {
    use crate::{AnyElement, AnyView, App, IntoElement, Render, Window};

    pub(crate) fn render<V: 'static + Render>(
        view: &AnyView,
        window: &mut Window,
        cx: &mut App,
    ) -> AnyElement {
        let view = view.clone().downcast::<V>().unwrap();
        // Record the view's Render type name so the accessibility debug dump can
        // attribute nodes to the view that produced them.
        #[cfg(debug_assertions)]
        window
            .a11y
            .view_type_names
            .insert(view.entity_id(), std::any::type_name::<V>());
        view.update(cx, |view, cx| {
            #[cfg(all(
                feature = "hot-patching",
                debug_assertions,
                not(target_family = "wasm")
            ))]
            let element = subsecond::HotFn::current(V::render).call((view, window, cx));
            #[cfg(not(all(
                feature = "hot-patching",
                debug_assertions,
                not(target_family = "wasm")
            )))]
            let element = view.render(window, cx);
            element.into_any_element()
        })
    }
}

/// A value that renders into elements and may carry an entity identity.
///
/// Every [`Entity`] of a [`Render`] type is a `View`, and so is every [`RenderOnce`] component.
/// Implement `View` directly when a component needs both props from its parent and an entity
/// identity. Otherwise, use [`Render`] for an entity-backed view or [`RenderOnce`] for a stateless
/// component.
///
/// When [`View::entity_id`] returns `Some`, that entity is the view's identity. GPUI gives the
/// view its own space for element ids, so state inside it can't collide with its siblings. A
/// [`Context::notify`] on that entity redraws only this view's subtree. When it returns `None`,
/// the view is stateless. GPUI scopes it under its type name, and it has no entity to notify.
pub trait View: 'static + Sized {
    /// Returns the entity that identifies this view, or `None` for a stateless view.
    ///
    /// A view that holds its entity as a field returns the entity's id here. The id becomes the
    /// view's [`ElementId`]. Two views backed by the same entity must not be siblings under one
    /// parent, because their element state would collide. Nesting is fine, since the parent's
    /// path keeps the ids apart.
    fn entity_id(&self) -> Option<EntityId>;

    /// Renders this view into elements. Takes `self` by value, so the view is used up.
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement;
}

/// A stateless component (`RenderOnce`) is a [`View`] with no entity identity.
impl<T: RenderOnce> View for T {
    fn entity_id(&self) -> Option<EntityId> {
        None
    }

    #[inline]
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        #[cfg(all(
            feature = "hot-patching",
            debug_assertions,
            not(target_family = "wasm")
        ))]
        let element = subsecond::HotFn::current(<T as RenderOnce>::render).call((self, window, cx));
        #[cfg(not(all(
            feature = "hot-patching",
            debug_assertions,
            not(target_family = "wasm")
        )))]
        let element = RenderOnce::render(self, window, cx);
        element
    }
}

/// An entity that renders itself (`Render`) is a [`View`] keyed by its own id.
impl<T: Render> View for Entity<T> {
    fn entity_id(&self) -> Option<EntityId> {
        Some(Entity::entity_id(self))
    }

    #[inline]
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        self.update(cx, |this, cx| {
            #[cfg(all(
                feature = "hot-patching",
                debug_assertions,
                not(target_family = "wasm")
            ))]
            let element = subsecond::HotFn::current(T::render).call((this, window, cx));
            #[cfg(not(all(
                feature = "hot-patching",
                debug_assertions,
                not(target_family = "wasm")
            )))]
            let element = Render::render(this, window, cx);
            element.into_any_element()
        })
    }
}

impl<T: Render> Entity<T> {
    /// Returns this entity as an element with a fixed root layout style.
    ///
    /// Entity-backed views retain naturally when passed directly as children. Use this method
    /// when the parent should set the view's root layout style. GPUI reuses the rendered subtree
    /// while the view's entity, tracked entity and global reads, and layout environment remain
    /// unchanged. Reads made by nested views and deferred prepaint or paint work are tracked too.
    /// A notification to a tracked entity, a tracked global revision change, or
    /// [`Window::refresh`] causes the view to rebuild. Changes to bounds or inherited layout and
    /// paint state can also require fresh output.
    ///
    /// `style` sets the retained root's layout contract. Give it dimensions and constraints that
    /// fit the parent. For the invalidation rules and the distinction between natural and
    /// fixed-style retention, see
    /// [retained view rendering](crate::_documentation::concepts::retained_rendering).
    #[track_caller]
    pub fn cached(self, style: StyleRefinement) -> ViewElement<Entity<T>> {
        ViewElement::with_type_name(self, type_name::<T>()).cached(style)
    }
}

/// The element that draws a [`View`].
///
/// It wraps the view and runs it through the three element phases. Its id is the view's entity
/// when the view has one. You rarely name this type: entities, [`AnyView`] and derived components
/// all convert into it. Create one with [`ViewElement::new`].
#[doc(hidden)]
pub struct ViewElement<V: View> {
    view: Option<V>,
    mount: Option<ViewMount>,
    #[cfg(feature = "profiler")]
    view_type_name: &'static str,
    #[cfg(debug_assertions)]
    source: &'static core::panic::Location<'static>,
}

impl<V: View> ViewElement<V> {
    /// Wraps `view` as an element. The element takes the view's entity id, if it has one.
    #[track_caller]
    pub fn new(view: V) -> Self {
        let mut element = Self::with_type_name(view, type_name::<V>());
        if let Some(mount) = &mut element.mount {
            mount.policy = ViewPolicy::Fresh;
        }
        element
    }

    /// Wraps a view whose draw time profiling attributes to `view_type_name`,
    /// such as an entity's type rather than [`Entity`]'s.
    #[track_caller]
    #[cfg_attr(not(feature = "profiler"), expect(unused_variables))]
    pub(crate) fn with_type_name(view: V, view_type_name: &'static str) -> Self {
        let mount = view.entity_id().map(|entity_id| ViewMount {
            entity_id,
            mount_id: None,
            policy: ViewPolicy::Retained { fixed_style: None },
        });
        ViewElement {
            mount,
            #[cfg(feature = "profiler")]
            view_type_name,
            view: Some(view),
            #[cfg(debug_assertions)]
            source: core::panic::Location::caller(),
        }
    }

    /// Enable caching of this view's rendered subtree, laid out at `style`.
    /// The composer supplies the layout style because caching skips rendering
    /// the contents to measure them.
    ///
    /// Crate-private on purpose: caching is only sound for entity-backed views,
    /// where [`Context::notify`] is the contract that busts the cache. A stateless
    /// view has no such contract, so a frozen subtree could never be invalidated.
    /// Reach this through [`Entity::cached`] or [`AnyView::cached`], which are
    /// entity-backed by construction.
    pub(crate) fn cached(mut self, style: StyleRefinement) -> Self {
        let mount = self
            .mount
            .as_mut()
            .expect("only entity-backed views can retain a cached subtree");
        mount.policy = ViewPolicy::Retained {
            fixed_style: Some(Arc::new(style)),
        };
        self
    }
}

struct ViewMount {
    entity_id: EntityId,
    mount_id: Option<u32>,
    policy: ViewPolicy,
}

enum ViewPolicy {
    /// Explicitly constructed ViewElements remain fresh so parent-provided props are observed.
    Fresh,
    /// Entity and AnyView elements retain naturally; a style makes the root layout fixed.
    Retained {
        fixed_style: Option<Arc<StyleRefinement>>,
    },
}

impl<V: View> IntoElement for ViewElement<V> {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

#[derive(Default)]
pub(crate) struct ViewElementState {
    cache: Option<ViewCache>,
}

struct ViewCache {
    layout: LayoutCache,
    output: CachedOutput,
}

struct LayoutCache {
    root: LayoutId,
    environment: crate::window::ViewEnvironment,
    fixed_style: Option<Arc<StyleRefinement>>,
    dependencies: ViewDependencies,
    direction_contribution: Option<ResolvedDirection>,
    frame_bound: bool,
}

#[cfg(test)]
pub(crate) fn retained_type_footprint() -> [(&'static str, usize); 4] {
    [
        ("StyleRefinement", std::mem::size_of::<StyleRefinement>()),
        ("ViewPolicy", std::mem::size_of::<ViewPolicy>()),
        ("LayoutCache", std::mem::size_of::<LayoutCache>()),
        (
            "ViewElement<AnyView>",
            std::mem::size_of::<ViewElement<crate::AnyView>>(),
        ),
    ]
}

enum CachedOutput {
    NeedsPrepaint,
    Prepared(ViewOutput<Option<Range<PaintIndex>>>),
    Painted(ViewOutput<Range<PaintIndex>>),
}

struct ViewOutput<P> {
    key: ViewOutputKey,
    prepaint_range: Range<PrepaintStateIndex>,
    a11y_roots: Vec<accesskit::NodeId>,
    paint: P,
}

#[derive(PartialEq)]
struct ViewOutputKey {
    bounds: Bounds<Pixels>,
    // Normally paint runs under the same ambient state as request_layout, so
    // `None` avoids storing a second copy. Nested mask/opacity/input scopes are
    // captured only when the prepaint environment differs from that baseline.
    environment: Option<crate::window::ViewEnvironment>,
}

impl ViewElementState {
    /// Include roots created by deferred prepaint in the retained accessibility subtree.
    ///
    /// The owning view's prepaint finishes before Window runs deferred draws, so its initial
    /// subtree snapshot cannot include those nodes. Window calls this only while the cached
    /// output is prepared for the current frame; replayed deferred ranges must not append again.
    pub(crate) fn extend_a11y_roots(&mut self, roots: &[accesskit::NodeId]) {
        if roots.is_empty() {
            return;
        }
        let Some(cache) = &mut self.cache else {
            return;
        };
        if let CachedOutput::Prepared(output) = &mut cache.output {
            output.a11y_roots.extend_from_slice(roots);
        }
    }

    pub(crate) fn extend_dependencies(
        &mut self,
        dependencies: &ViewDependencies,
        frame_bound: bool,
    ) {
        if let Some(cache) = &mut self.cache {
            cache.layout.dependencies.extend(dependencies);
            cache.layout.frame_bound |= frame_bound;
        }
    }

    pub(crate) fn rebase_prepaint_range(
        &mut self,
        source: &Range<crate::window::PrepaintStateIndex>,
        destination: &crate::window::PrepaintStateIndex,
    ) {
        let Some(cache) = &mut self.cache else { return };
        match &mut cache.output {
            CachedOutput::NeedsPrepaint => {}
            CachedOutput::Prepared(output) => {
                rebase_range(&mut output.prepaint_range, source, destination)
            }
            CachedOutput::Painted(output) => {
                rebase_range(&mut output.prepaint_range, source, destination)
            }
        }
    }

    pub(crate) fn rebase_paint_range(
        &mut self,
        source: &Range<crate::window::PaintIndex>,
        destination: &crate::window::PaintIndex,
    ) {
        let Some(cache) = &mut self.cache else { return };
        match &mut cache.output {
            CachedOutput::NeedsPrepaint => {}
            CachedOutput::Prepared(output) => {
                if let Some(range) = &mut output.paint {
                    rebase_range(range, source, destination);
                }
            }
            CachedOutput::Painted(output) => rebase_range(&mut output.paint, source, destination),
        }
    }
}

#[cfg(not(gpui_hot_reload))]
#[inline]
fn render_view<V: View>(view: V, window: &mut Window, cx: &mut App) -> AnyElement {
    view.render(window, cx).into_any_element()
}

/// Every view and component render passes through this hot-patchable boundary, so the
/// patched code for that render and everything it calls runs on the next frame.
#[cfg(gpui_hot_reload)]
fn render_view<V: View>(view: V, window: &mut Window, cx: &mut App) -> AnyElement {
    #[inline(never)]
    fn render_view_impl<V: View>(view: V, window: &mut Window, cx: &mut App) -> AnyElement {
        view.render(window, cx).into_any_element()
    }

    subsecond::HotFn::current(render_view_impl::<V>).call((view, window, cx))
}

trait RebaseRangeIndex: Sized {
    fn rebase_from(&mut self, source: &Range<Self>, destination: &Self);
}

impl RebaseRangeIndex for PrepaintStateIndex {
    fn rebase_from(&mut self, source: &Range<Self>, destination: &Self) {
        PrepaintStateIndex::rebase_from(self, source, destination);
    }
}

impl RebaseRangeIndex for PaintIndex {
    fn rebase_from(&mut self, source: &Range<Self>, destination: &Self) {
        PaintIndex::rebase_from(self, source, destination);
    }
}

fn rebase_range<I: RebaseRangeIndex>(range: &mut Range<I>, source: &Range<I>, destination: &I) {
    range.start.rebase_from(source, destination);
    range.end.rebase_from(source, destination);
}

fn cache_is_valid(cache: &ViewCache, entity_id: EntityId, window: &Window, cx: &App) -> bool {
    !window.refreshing
        && !window.is_inspector_picking(cx)
        && !window.inspector_is_open()
        && !window.dirty_views.contains(&entity_id)
        && !cache.layout.frame_bound
        && !cache
            .layout
            .dependencies
            .entities
            .iter()
            .any(|entity| window.dirty_views.contains(entity))
        && cache
            .layout
            .dependencies
            .globals
            .iter()
            .all(|(global_type, revision)| cx.global_revision(*global_type) == *revision)
}

impl<V: View> Element for ViewElement<V> {
    type RequestLayoutState = Option<AnyElement>;
    type PrepaintState = Option<AnyElement>;

    fn id(&self) -> Option<ElementId> {
        self.mount
            .as_ref()
            .map(|mount| ElementId::View(mount.entity_id))
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        #[cfg(debug_assertions)]
        return Some(self.source);

        #[cfg(not(debug_assertions))]
        return None;
    }

    fn request_layout(
        &mut self,
        id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        if let Some(mount) = self.mount.as_mut() {
            let entity_id = mount.entity_id;
            let global_id = id.expect("entity-backed views must have an element id");
            let mount_id = window.next_view_mount_id(global_id);
            mount.mount_id = Some(mount_id);
            let cache_id = Window::mounted_view_id(global_id, mount_id);

            let fixed_style = match &mount.policy {
                ViewPolicy::Fresh => {
                    return window.with_rendered_view(entity_id, |window| {
                        window.with_cached_view(cache_id, mount_id, |window| {
                            let mut element = render_view(self.view.take().unwrap(), window, cx);
                            let layout = element.request_layout(window, cx);
                            (layout, Some(element))
                        })
                    });
                }
                ViewPolicy::Retained { fixed_style } => fixed_style.clone(),
            };

            let (layout_id, request) = window.with_rendered_view(entity_id, |window| {
                window.with_cached_view(cache_id.clone(), mount_id, |window| {
                    let environment = window.view_environment();
                    window.with_element_state::<ViewElementState, _>(&cache_id, |state, window| {
                        let mut state = state.unwrap_or_default();
                        if let Some(cache) = state.cache.as_ref().filter(|cache| {
                            cache_is_valid(cache, entity_id, window, cx)
                                && cache.layout.environment == environment
                                && cache.layout.fixed_style == fixed_style
                        }) {
                            let root = cache.layout.root;
                            window.retain_layout_subtree(root);
                            if fixed_style.is_some() {
                                window.set_layout_auto_direction_hint(
                                    root,
                                    cache.layout.direction_contribution,
                                );
                            }
                            cx.extend_accessed_dependencies(&cache.layout.dependencies);
                            window.note_view_reused();
                            return ((root, None), state);
                        }

                        let (root, request_element, dependencies, direction_contribution) =
                            if let Some(style) = &fixed_style {
                                let mut root_style = Style::default();
                                root_style.refine(style.as_ref());
                                let root = window.request_layout(root_style, None, cx);
                                let ((element, direction_contribution), dependencies) = cx
                                    .detect_accessed_dependencies(|cx| {
                                        let mut element =
                                            render_view(self.view.take().unwrap(), window, cx);
                                        let child_layout = element.request_layout(window, cx);
                                        let contribution =
                                            window.layout_auto_direction_contribution(child_layout);
                                        window.set_layout_auto_direction_hint(root, contribution);
                                        (element, contribution)
                                    });
                                (root, Some(element), dependencies, direction_contribution)
                            } else {
                                let ((element, root_layout), dependencies) = cx
                                    .detect_accessed_dependencies(|cx| {
                                        let mut element =
                                            render_view(self.view.take().unwrap(), window, cx);
                                        let root_layout = element.request_layout(window, cx);
                                        (element, root_layout)
                                    });
                                (root_layout, Some(element), dependencies, None)
                            };

                        state.cache = Some(ViewCache {
                            layout: LayoutCache {
                                root,
                                environment,
                                fixed_style,
                                dependencies,
                                direction_contribution,
                                frame_bound: false,
                            },
                            output: CachedOutput::NeedsPrepaint,
                        });
                        window.note_view_rebuilt();
                        ((root, request_element), state)
                    })
                })
            });
            (layout_id, request)
        } else {
            // Stateless path: isolate subtree via type name (no entity identity).
            window.with_id(
                ElementId::Name(std::any::type_name::<V>().into()),
                |window| {
                    let mut element = render_view(self.view.take().unwrap(), window, cx);
                    let layout_id = element.request_layout(window, cx);
                    (layout_id, Some(element))
                },
            )
        }
    }

    fn prepaint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        element: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<AnyElement> {
        if let Some(mount) = self.mount.as_ref() {
            let entity_id = mount.entity_id;
            let mount_id = mount.mount_id.expect("request_layout sets the view mount");
            let cache_id = Window::mounted_view_id(global_id.unwrap(), mount_id);
            window.set_view_id(entity_id);

            let fixed_style = match &mount.policy {
                ViewPolicy::Fresh => {
                    return window.with_rendered_view(entity_id, |window| {
                        window.with_cached_view(cache_id, mount_id, |window| {
                            let mut element = element.take().unwrap();
                            element.prepaint(window, cx);
                            Some(element)
                        })
                    });
                }
                ViewPolicy::Retained { fixed_style } => fixed_style.clone(),
            };

            window.with_rendered_view(entity_id, |window| {
                window.with_cached_view(cache_id.clone(), mount_id, |window| {
                    let mut fresh_element = element.take();
                    let request_reused = fresh_element.is_none();
                    let environment = window.view_environment();

                    window.with_element_state::<ViewElementState, _>(&cache_id, |state, window| {
                        let mut state = state.unwrap_or_default();
                        let cache = state.cache.as_mut().expect("retained view layout exists");
                        let key = ViewOutputKey {
                            bounds,
                            environment: (environment != cache.layout.environment)
                                .then_some(environment.clone()),
                        };
                        let can_replay = request_reused
                            && cache.layout.fixed_style == fixed_style
                            && cache_is_valid(cache, entity_id, window, cx)
                            && matches!(&cache.output, CachedOutput::Painted(output) if output.key == key);
                        let prepaint_start = window.prepaint_index();
                        let a11y_start = window.a11y.cache_subtree_start();
                        let (element, paint_source, a11y_roots) = if can_replay {
                            let CachedOutput::Painted(output) =
                                std::mem::replace(&mut cache.output, CachedOutput::NeedsPrepaint)
                            else {
                                unreachable!("replay requires a completed paint")
                            };
                            window.a11y.reuse_prepaint(&output.a11y_roots);
                            window.reuse_prepaint(output.prepaint_range);
                            cx.extend_accessed_dependencies(&cache.layout.dependencies);
                            (None, Some(output.paint), output.a11y_roots)
                        } else {
                            cache.output = CachedOutput::NeedsPrepaint;
                            let (fresh_element, dependencies) = cx.detect_accessed_dependencies(|cx| {
                                let mut fresh_element = fresh_element.take().unwrap_or_else(|| {
                                    render_view(self.view.take().unwrap(), window, cx)
                                });
                                if request_reused || fixed_style.is_some() {
                                    if request_reused && fixed_style.is_none() {
                                        // A detached intrinsic layout can reparent retained child nodes.
                                        // Rebuild this owner chain next frame to reconnect it safely.
                                        window.mark_cached_views_frame_bound();
                                    }
                                    fresh_element.layout_as_root_at_size(
                                        bounds.size.into(),
                                        bounds.size,
                                        window,
                                        cx,
                                    );
                                    fresh_element.prepaint_at(bounds.origin, window, cx);
                                } else {
                                    fresh_element.prepaint(window, cx);
                                }
                                fresh_element
                            });
                            cache.layout.dependencies.extend(&dependencies);
                            cx.extend_accessed_dependencies(&cache.layout.dependencies);
                            let roots = window.a11y.cache_subtree_roots(a11y_start);
                            (Some(fresh_element), None, roots)
                        };

                        let prepaint_end = window.prepaint_index();
                        cache.output = CachedOutput::Prepared(ViewOutput {
                            key,
                            prepaint_range: prepaint_start..prepaint_end,
                            a11y_roots,
                            paint: paint_source,
                        });
                        cache.layout.frame_bound =
                            window.has_frame_bound_layout(&cache_id);
                        (element, state)
                    })
                })
            })
        } else {
            // Stateless path: just prepaint the element.
            window.with_id(
                ElementId::Name(std::any::type_name::<V>().into()),
                |window| {
                    let Some(mut element) = element.take() else {
                        unreachable!("stateless views always render in request_layout")
                    };
                    element.prepaint(window, cx);
                    Some(element)
                },
            )
        }
    }

    fn paint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        element: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        if let Some(mount) = self.mount.as_ref() {
            let entity_id = mount.entity_id;
            let mount_id = mount.mount_id.expect("request_layout sets the view mount");
            let cache_id = Window::mounted_view_id(global_id.unwrap(), mount_id);

            if matches!(&mount.policy, ViewPolicy::Fresh) {
                window.with_rendered_view(entity_id, |window| {
                    window.with_cached_view(cache_id, mount_id, |window| {
                        if let Some(element) = element {
                            element.paint(window, cx);
                        }
                    })
                });
                return;
            }

            window.with_rendered_view(entity_id, |window| {
                window.with_cached_view(cache_id.clone(), mount_id, |window| {
                    window.with_element_state::<ViewElementState, _>(&cache_id, |state, window| {
                        let mut state = state.unwrap_or_default();
                        let cache = state.cache.as_mut().expect("retained view layout exists");
                        let CachedOutput::Prepared(prepared) =
                            std::mem::replace(&mut cache.output, CachedOutput::NeedsPrepaint)
                        else {
                            unreachable!("prepaint must prepare output before paint")
                        };
                        let paint_start = window.paint_index();
                        if let Some(element) = element {
                            let (_, dependencies) =
                                cx.detect_accessed_dependencies(|cx| element.paint(window, cx));
                            cache.layout.dependencies.extend(&dependencies);
                            cx.extend_accessed_dependencies(&cache.layout.dependencies);
                        } else {
                            let paint_source = prepared
                                .paint
                                .as_ref()
                                .expect("replayed prepaint has a completed paint range");
                            window.a11y.reuse_paint(&prepared.a11y_roots);
                            window.reuse_paint(paint_source.clone());
                            cx.extend_accessed_dependencies(&cache.layout.dependencies);
                        }
                        cache.layout.frame_bound |= window.has_frame_bound_layout(&cache_id);
                        cache.output = CachedOutput::Painted(ViewOutput {
                            key: prepared.key,
                            prepaint_range: prepared.prepaint_range,
                            paint: paint_start..window.paint_index(),
                            a11y_roots: prepared.a11y_roots,
                        });
                        ((), state)
                    })
                })
            });
        } else {
            // Stateless path: just paint the element.
            window.with_id(
                ElementId::Name(std::any::type_name::<V>().into()),
                |window| {
                    if let Some(element) = element {
                        element.paint(window, cx);
                    }
                },
            );
        }
    }
}

/// A view that renders nothing.
///
/// Its `render` returns [`Empty`]. Use it as a placeholder view, for example as the root of a
/// window that has no content yet.
pub struct EmptyView;

impl Render for EmptyView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        Empty
    }
}
