use crate::{
    AnyElement, AnyEntity, AnyWeakEntity, App, Bounds, Context, Element, ElementId, Entity,
    EntityId, GlobalElementId, InspectorElementId, IntoElement, LayoutId, PaintIndex, Pixels,
    PrepaintStateIndex, Render, RenderOnce, Style, StyleRefinement, ViewDependencies, WeakEntity,
};
use crate::{Empty, Window};
use anyhow::Result;
use refineable::Refineable;
use std::{any::TypeId, fmt, ops::Range};

/// A dynamically-typed view handle that can be downcast to a specific `Entity<V>`.
///
/// This is the type-erased counterpart to [`ViewElement`]: it holds an entity plus
/// a function pointer to its render, and is itself a [`View`], so embedding it as an
/// element goes through the same [`ViewElement`] machinery as any other view.
#[derive(Clone, Debug)]
pub struct AnyView {
    entity: AnyEntity,
    render: fn(&AnyView, &mut Window, &mut App) -> AnyElement,
}

impl<V: Render> From<Entity<V>> for AnyView {
    fn from(value: Entity<V>) -> Self {
        AnyView {
            entity: value.into_any(),
            render: any_view::render::<V>,
        }
    }
}

impl AnyView {
    /// Embed this view as a cached [`ViewElement`] laid out at `style`.
    ///
    /// The rendered subtree is recycled from the previous frame unless
    /// [Context::notify] was called on the backing entity since it was rendered
    /// (or [Window::refresh] is called, which ignores caching).
    pub fn cached(self, style: StyleRefinement) -> ViewElement<AnyView> {
        let entity_id = self.entity_id();
        ViewElement::retained(self, entity_id, Some(style))
    }

    /// Convert this to a weak handle.
    pub fn downgrade(&self) -> AnyWeakView {
        AnyWeakView {
            entity: self.entity.downgrade(),
            render: self.render,
        }
    }

    /// Convert this to a [Entity] of a specific type.
    /// If this handle does not contain a view of the specified type, returns itself in an `Err` variant.
    pub fn downcast<T: 'static>(self) -> Result<Entity<T>, Self> {
        match self.entity.downcast() {
            Ok(entity) => Ok(entity),
            Err(entity) => Err(Self {
                entity,
                render: self.render,
            }),
        }
    }

    /// Gets the [TypeId] of the underlying view.
    pub fn entity_type(&self) -> TypeId {
        self.entity.entity_type
    }

    /// The [`EntityId`] of this view.
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

/// `AnyView` is the type-erased [`View`]: its `render` is a function pointer rather
/// than a concrete type, but it participates in the reactive graph exactly like any
/// other view via [`ViewElement`].
impl View for AnyView {
    fn entity_id(&self) -> Option<EntityId> {
        Some(self.entity.entity_id())
    }

    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
        (self.render)(&self, window, cx)
    }
}

impl<V: 'static + Render> IntoElement for Entity<V> {
    type Element = ViewElement<Entity<V>>;

    fn into_element(self) -> Self::Element {
        let entity_id = self.entity_id();
        ViewElement::retained(self, entity_id, None)
    }
}

impl IntoElement for AnyView {
    type Element = ViewElement<AnyView>;

    fn into_element(self) -> Self::Element {
        let entity_id = self.entity_id();
        ViewElement::retained(self, entity_id, None)
    }
}

/// A weak, dynamically-typed view handle.
pub struct AnyWeakView {
    entity: AnyWeakEntity,
    render: fn(&AnyView, &mut Window, &mut App) -> AnyElement,
}

impl AnyWeakView {
    /// Upgrade to a strong `AnyView` handle, if the view is still alive.
    pub fn upgrade(&self) -> Option<AnyView> {
        let entity = self.entity.upgrade()?;
        Some(AnyView {
            entity,
            render: self.render,
        })
    }
}

impl<V: 'static + Render> From<WeakEntity<V>> for AnyWeakView {
    fn from(view: WeakEntity<V>) -> Self {
        AnyWeakView {
            entity: view.into(),
            render: any_view::render::<V>,
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

/// A renderable that participates in GPUI's reactive graph — the unifying model
/// behind [`Render`] and [`RenderOnce`].
///
/// When `entity_id()` returns `Some`, that id becomes the view's identity: it gets
/// a unique element-id space (so internal `use_state` / `.id(..)` never collide
/// across siblings) and `cx.notify()` on that entity re-renders only this view's
/// subtree. `None` behaves like a stateless component.
///
/// You rarely implement `View` directly. `Entity<T: Render>` and any `T: RenderOnce`
/// get a blanket impl below; implement it by hand only when a component needs both
/// parent-supplied props *and* a backing entity for identity.
pub trait View: 'static + Sized {
    /// This view's identity, if it has one. A view typically holds the backing
    /// entity as a field and returns its [`EntityId`] here.
    ///
    /// The id becomes this view's [`ElementId`], so two views keyed on the same
    /// entity must not be rendered at the same position in the element tree
    /// (e.g. as siblings under the same parent): their internal element state
    /// (`use_state`, scroll offsets, etc.) would silently collide. Nesting is
    /// fine — the id is scoped by the parent path.
    fn entity_id(&self) -> Option<EntityId>;

    /// Render this view into an element tree, consuming `self`.
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement;
}

fn render_view<V: View>(view: V, window: &mut Window, cx: &mut App) -> AnyElement {
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
}

/// A stateless component (`RenderOnce`) is a `View` with no identity.
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

/// An entity that renders itself (`Render`) is a `View` keyed on its own id.
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
    /// Embed this entity as a cached [`ViewElement`] laid out at `style`.
    ///
    /// The rendered subtree is reused until the entity is notified (or the
    /// cached bounds / text style change). Caching requires a definite size:
    /// a cached view is laid out from `style` and is *not* measured from its
    /// contents. `.child(entity)` uses natural layout and retains its subtree
    /// while the entity is clean; use [`ViewElement::new`] for a manual `View`
    /// whose parent-supplied props must remain fresh.
    #[track_caller]
    pub fn cached(self, style: StyleRefinement) -> ViewElement<Entity<T>> {
        let entity_id = self.entity_id();
        ViewElement::retained(self, entity_id, Some(style))
    }
}

/// The element type for [`View`] implementations. Wraps a `View` and hooks it
/// into layout, prepaint, and paint. Constructed via [`ViewElement::new`].
#[doc(hidden)]
pub struct ViewElement<V: View> {
    view: Option<V>,
    mount: Option<ViewMount>,
    #[cfg(debug_assertions)]
    source: &'static core::panic::Location<'static>,
}

struct ViewMount {
    entity_id: EntityId,
    mount_id: Option<u32>,
    policy: ViewPolicy,
}

#[derive(Clone)]
enum ViewPolicy {
    Fresh,
    Retained {
        fixed_style: Option<StyleRefinement>,
    },
}

impl<V: View> ViewElement<V> {
    /// Wrap a [`View`] as an element.
    #[track_caller]
    pub fn new(view: V) -> Self {
        let mount = view.entity_id().map(|entity_id| ViewMount {
            entity_id,
            mount_id: None,
            policy: ViewPolicy::Fresh,
        });
        ViewElement {
            mount,
            view: Some(view),
            #[cfg(debug_assertions)]
            source: core::panic::Location::caller(),
        }
    }

    fn retained(view: V, entity_id: EntityId, fixed_style: Option<StyleRefinement>) -> Self {
        Self {
            view: Some(view),
            mount: Some(ViewMount {
                entity_id,
                mount_id: None,
                policy: ViewPolicy::Retained { fixed_style },
            }),
            #[cfg(debug_assertions)]
            source: core::panic::Location::caller(),
        }
    }
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
    fixed_style: Option<StyleRefinement>,
    dependencies: ViewDependencies,
    frame_bound: bool,
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
                            cx.extend_accessed_dependencies(&cache.layout.dependencies);
                            window.note_view_reused();
                            return ((root, None), state);
                        }

                        let (root, request_element, dependencies) =
                            if let Some(style) = &fixed_style {
                                let mut root_style = Style::default();
                                root_style.refine(style);
                                let root = window.request_layout(root_style, None, cx);
                                (root, None, ViewDependencies::default())
                            } else {
                                let ((element, root_layout), dependencies) = cx
                                    .detect_accessed_dependencies(|cx| {
                                        let mut element =
                                            render_view(self.view.take().unwrap(), window, cx);
                                        let root_layout = element.request_layout(window, cx);
                                        (element, root_layout)
                                    });
                                (root_layout, Some(element), dependencies)
                            };

                        state.cache = Some(ViewCache {
                            layout: LayoutCache {
                                root,
                                environment,
                                fixed_style,
                                dependencies,
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

/// A view that renders nothing
pub struct EmptyView;

impl Render for EmptyView {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        Empty
    }
}
