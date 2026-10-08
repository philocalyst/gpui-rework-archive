//! Views connect application state to an element tree. A [`RenderOnce`] component is rebuilt when
//! its parent renders; a [`Render`] component is stored in an [`Entity`](crate::Entity), has a
//! stable identity, and can be invalidated with [`Context::notify`](crate::Context::notify).
//! Rendering then follows the element lifecycle described by [`crate::Element`].
//!
//! Use [`RenderOnce`] to consume parent-supplied component values and [`Render`] for an entity
//! with its own identity. A `RenderOnce` component can also access separately retained state.
//! Give repeated components separate identity scopes. Rendering the same entity
//! twice as siblings gives their descendants the same element-state paths.
//! Use separate entities or distinct parent IDs to keep those paths independent.
//! See the [counter walkthrough](https://gpui-ce.github.io/examples/counter/#render)
//! for the smallest complete stateful example.

use crate::{
    AnyElement, AnyEntity, AnyWeakEntity, App, Bounds, ContentMask, Context, Element, ElementId,
    Entity, EntityId, GlobalElementId, InspectorElementId, IntoElement, LayoutId, PaintIndex,
    Pixels, PrepaintStateIndex, Render, RenderOnce, ResolvedDirection, Style, StyleRefinement,
    TextStyle, UnicodeBidi, WeakEntity,
};
use crate::{Empty, Window};
use anyhow::Result;
use collections::FxHashSet;
use refineable::Refineable;
use std::mem;
use std::{any::TypeId, fmt, ops::Range};

/// A strong view handle whose concrete render type has been erased.
///
/// Convert an `Entity<V>` into `AnyView` to store views with different types in
/// one collection or root slot. Cloning retains the same entity; it does not
/// clone its state. It can be added as an element like a typed view. Use
/// [`downcast`](Self::downcast) to recover the concrete handle when needed.
///
/// ```rust
/// use gpui::{AnyView, Entity, Render};
///
/// fn panes<A: Render, B: Render>(first: Entity<A>, second: Entity<B>) -> Vec<AnyView> {
///     vec![first.into(), second.into()]
/// }
/// ```
///
/// Erasing the type preserves the entity's identity and render implementation.
/// It does not create an independently owned copy of a view. Retaining a
/// collection of these handles keeps its views alive even when they are not
/// currently mounted. Use [`AnyWeakView`] when an index or callback should
/// remember a view without becoming an owner. See the
/// [ownership chapter](crate::_ownership_and_data_flow).
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
    /// Embeds this view with subtree caching and the supplied outer layout style.
    ///
    /// The outer layout must supply its size; GPUI does not measure that size
    /// from the cached contents. Invalidation and cache reuse follow
    /// [`Entity::cached`]. Add the view directly as a child when its contents
    /// should determine its layout size.
    pub fn cached(self, style: StyleRefinement) -> ViewElement<AnyView> {
        ViewElement::new(self).cached(style)
    }

    /// Remember this view without retaining its state.
    ///
    /// The weak handle can be upgraded while any strong owner remains.
    /// Creating it does not remove this handle's ownership.
    pub fn downgrade(&self) -> AnyWeakView {
        AnyWeakView {
            entity: self.entity.downgrade(),
            render: self.render,
        }
    }

    /// Recover a typed handle when this view's concrete type is `T`.
    ///
    /// On a mismatch, return the original `AnyView` in `Err`, preserving its
    /// ownership and render implementation. No state is copied or converted.
    /// Cloning before the downcast retains an erased handle as well as the
    /// successful typed one; both then refer to the same entity.
    pub fn downcast<T: 'static>(self) -> Result<Entity<T>, Self> {
        match self.entity.downcast() {
            Ok(entity) => Ok(entity),
            Err(entity) => Err(Self {
                entity,
                render: self.render,
            }),
        }
    }

    /// Return the concrete view value's Rust [`TypeId`].
    ///
    /// Use it for runtime type checks, not as a persistent document or plugin ID.
    pub fn entity_type(&self) -> TypeId {
        self.entity.entity_type
    }

    /// Return this view's entity identity within its app.
    ///
    /// Clones and successful downcasts keep this identity. Equality compares
    /// it, rather than the rendered elements or state fields.
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

/// Renders the retained entity through its original [`Render`] implementation.
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
        ViewElement::new(self)
    }
}

impl IntoElement for AnyView {
    type Element = ViewElement<AnyView>;

    fn into_element(self) -> Self::Element {
        ViewElement::new(self)
    }
}

/// A remembered view identity that does not keep the view alive.
///
/// Obtain it from [`AnyView::downgrade`] or convert a [`WeakEntity<V>`] whose
/// value implements [`Render`]. It retains the information needed to render
/// after a successful [`Self::upgrade`], but supplies no access to released
/// state. Use it for callbacks or indexes whose lifetime should not own the
/// view. Equality compares entity identity within an app, even after release.
pub struct AnyWeakView {
    entity: AnyWeakEntity,
    render: fn(&AnyView, &mut Window, &mut App) -> AnyElement,
}

impl AnyWeakView {
    /// Retain the view if a strong owner still exists.
    ///
    /// Return `None` after the last strong handle is dropped or the app is
    /// released. This can happen before effect processing destroys the stored
    /// view value. A successful upgrade becomes another owner; it neither
    /// remounts a removed view nor recreates a released one.
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

/// Connects a renderable value to an optional entity identity.
///
/// [`Entity<T>`] implements this trait when `T` implements [`Render`]; its
/// entity identity scopes descendant element IDs and lets notifications
/// invalidate its subtree. A [`RenderOnce`] value also implements `View`, but
/// returns no entity identity. Its parent supplies its lifetime and invalidation.
///
/// Usually implement `Render` or `RenderOnce`. Implement `View` directly when
/// a component combines parent-supplied properties with a retained entity whose
/// identity should scope its subtree.
pub trait View: 'static + Sized {
    /// This view's identity, if it has one. A view typically holds the backing
    /// entity as a field and returns its [`EntityId`] here.
    ///
    /// The id becomes this view's [`ElementId`], so two views keyed on the same
    /// entity must not be rendered at the same position in the element tree
    /// (e.g. as siblings under the same parent): their internal element state
    /// (`use_state`, scroll offsets, etc.) would silently collide. Nesting is
    /// fine — the id is scoped by the parent path.
    ///
    /// Returning `None` uses the view's Rust type name as an element-state
    /// scope. That separates different component types, not two instances of
    /// one type. Wrap repeated instances in parents with distinct, stable IDs;
    /// see [`RenderOnce`].
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

/// An owned component has a type-name scope, but no entity identity.
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
    /// Embeds this view with subtree caching and the supplied outer layout style.
    ///
    /// GPUI can reuse the subtree's prepaint and paint records while the entity
    /// is clean and its bounds, clipping mask, text style, and text direction
    /// are unchanged. [`Context::notify`] invalidates it; [`Window::refresh`]
    /// bypasses reuse.
    ///
    /// Caching requires a definite outer size: `style` determines the layout
    /// box instead of measuring the view's contents. Use `.child(entity)`
    /// without `cached` when content should determine that size. See
    /// [`crate::_documentation::rendering`] for frame phases and retained state.
    ///
    /// ```
    /// use gpui::{Entity, IntoElement, Render, StyleRefinement, prelude::*, px};
    ///
    /// fn sidebar<V: Render>(view: Entity<V>) -> impl IntoElement {
    ///     view.cached(StyleRefinement::default().w(px(240.)).h_full())
    /// }
    /// ```
    ///
    /// # Invalidate the view when its inputs change
    ///
    /// Reading a shared model while rendering records which window needs a
    /// redraw; it does not notify this view. Retain a [`Context::observe`]
    /// subscription that calls `cx.notify()` on the view when the model changes.
    /// Do the same with [`Context::observe_global`] for global inputs. When a
    /// parent updates this view's fields, notify it in that update too. A cache
    /// hit reuses both drawing and input handlers, including their captures.
    ///
    /// The [cached-view test](https://gpui-ce.github.io/guides/testing/#check-that-a-shared-model-invalidates-a-cached-view)
    /// checks reuse and the new painted color after a model notification.
    #[track_caller]
    pub fn cached(self, style: StyleRefinement) -> ViewElement<Entity<T>> {
        ViewElement::new(self).cached(style)
    }
}

/// The element type for [`View`] implementations. Wraps a `View` and hooks it
/// into layout, prepaint, and paint. Constructed via [`ViewElement::new`].
#[doc(hidden)]
pub struct ViewElement<V: View> {
    view: Option<V>,
    entity_id: Option<EntityId>,
    cached_style: Option<StyleRefinement>,
    #[cfg(debug_assertions)]
    source: &'static core::panic::Location<'static>,
}

impl<V: View> ViewElement<V> {
    /// Wrap a [`View`] as an element.
    #[track_caller]
    pub fn new(view: V) -> Self {
        let entity_id = view.entity_id();
        ViewElement {
            entity_id,
            cached_style: None,
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
        self.cached_style = Some(style);
        self
    }
}

impl<V: View> IntoElement for ViewElement<V> {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

struct ViewElementState {
    prepaint_range: Range<PrepaintStateIndex>,
    paint_range: Range<PaintIndex>,
    cache_key: ViewElementCacheKey,
    accessed_entities: FxHashSet<EntityId>,
}

#[derive(Default)]
#[doc(hidden)]
pub struct ViewElementRequestLayoutState {
    element: Option<AnyElement>,
    detached_layout_id: Option<LayoutId>,
    accessed_entities: FxHashSet<EntityId>,
}

#[derive(Default)]
struct ViewDirectionState {
    known: bool,
    contribution: Option<ResolvedDirection>,
}

#[derive(PartialEq)]
struct ViewElementCacheKey {
    bounds: Bounds<Pixels>,
    content_mask: ContentMask<Pixels>,
    text_style: TextStyle,
    direction: ResolvedDirection,
    unicode_bidi: UnicodeBidi,
}

impl<V: View> Element for ViewElement<V> {
    type RequestLayoutState = ViewElementRequestLayoutState;
    type PrepaintState = Option<AnyElement>;

    fn id(&self) -> Option<ElementId> {
        self.entity_id.map(ElementId::View)
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        #[cfg(debug_assertions)]
        return Some(self.source);

        #[cfg(not(debug_assertions))]
        return None;
    }

    fn request_layout(
        &mut self,
        global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let entity_id = self.entity_id;
        let request_layout = |window: &mut Window| {
            let caching_disabled = window.is_inspector_picking(cx);

            if let (Some(entity_id), Some(style)) = (
                entity_id,
                self.cached_style.as_ref().filter(|_| !caching_disabled),
            ) {
                let mut root_style = Style::default();
                root_style.refine(style);
                let layout_id = window.request_layout(root_style, None, cx);
                let (known, contribution) = window.with_element_state::<ViewDirectionState, _>(
                    global_id.unwrap(),
                    |state, _window| {
                        let state = state.unwrap_or_default();
                        ((state.known, state.contribution), state)
                    },
                );
                let should_probe =
                    !known || window.dirty_views.contains(&entity_id) || window.refreshing;

                if should_probe {
                    let ((element, detached_layout_id), accessed_entities) = cx
                        .detect_accessed_entities(|cx| {
                            let mut element = render_view(self.view.take().unwrap(), window, cx);
                            let detached_layout_id = element.request_layout(window, cx);

                            (element, detached_layout_id)
                        });
                    window.set_layout_logical_children(
                        layout_id,
                        std::slice::from_ref(&detached_layout_id),
                    );

                    return (
                        layout_id,
                        ViewElementRequestLayoutState {
                            element: Some(element),
                            detached_layout_id: Some(detached_layout_id),
                            accessed_entities,
                        },
                    );
                }

                window.set_layout_auto_direction_hint(layout_id, contribution);

                return (layout_id, ViewElementRequestLayoutState::default());
            }

            let mut element = render_view(self.view.take().unwrap(), window, cx);
            let layout_id = element.request_layout(window, cx);

            (
                layout_id,
                ViewElementRequestLayoutState {
                    element: Some(element),
                    ..Default::default()
                },
            )
        };

        if let Some(entity_id) = entity_id {
            window.with_rendered_view(entity_id, request_layout)
        } else {
            window.with_id(
                ElementId::Name(std::any::type_name::<V>().into()),
                request_layout,
            )
        }
    }

    fn prepaint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<AnyElement> {
        if let Some(entity_id) = self.entity_id {
            // Stateful path.
            window.set_view_id(entity_id);
            window.with_rendered_view(entity_id, |window| {
                if request_layout.detached_layout_id.is_none()
                    && let Some(mut element) = request_layout.element.take()
                {
                    element.prepaint(window, cx);
                    return Some(element);
                }

                window.with_element_state::<ViewElementState, _>(
                    global_id.unwrap(),
                    |element_state, window| {
                        let cache_key = ViewElementCacheKey {
                            bounds,
                            content_mask: window.content_mask(),
                            text_style: window.text_style(),
                            direction: window.resolved_direction(),
                            unicode_bidi: window.resolved_unicode_bidi(),
                        };

                        if request_layout.element.is_none()
                            && let Some(mut element_state) = element_state
                            && element_state.cache_key == cache_key
                            && !window.dirty_views.contains(&entity_id)
                            && !window.refreshing
                        {
                            let prepaint_start = window.prepaint_index();
                            window.reuse_prepaint(element_state.prepaint_range.clone());
                            cx.entities
                                .extend_accessed(&element_state.accessed_entities);
                            let prepaint_end = window.prepaint_index();
                            element_state.prepaint_range = prepaint_start..prepaint_end;

                            return (None, element_state);
                        }

                        let refreshing = mem::replace(&mut window.refreshing, true);
                        let prepaint_start = window.prepaint_index();
                        let mut accessed_entities =
                            mem::take(&mut request_layout.accessed_entities);
                        let (element, additional_entities) = cx.detect_accessed_entities(|cx| {
                            let mut element = request_layout.element.take().unwrap_or_else(|| {
                                render_view(self.view.take().unwrap(), window, cx)
                            });
                            element.layout_as_root(bounds.size.into(), window, cx);
                            element.prepaint_at(bounds.origin, window, cx);

                            element
                        });
                        accessed_entities.extend(additional_entities);

                        if let Some(detached_layout_id) = request_layout.detached_layout_id.take() {
                            let contribution =
                                window.layout_auto_direction_contribution(detached_layout_id);
                            window.with_element_state::<ViewDirectionState, _>(
                                global_id.unwrap(),
                                |_state, _window| {
                                    (
                                        (),
                                        ViewDirectionState {
                                            known: true,
                                            contribution,
                                        },
                                    )
                                },
                            );
                        }

                        let prepaint_end = window.prepaint_index();
                        window.refreshing = refreshing;

                        (
                            Some(element),
                            ViewElementState {
                                accessed_entities,
                                prepaint_range: prepaint_start..prepaint_end,
                                paint_range: PaintIndex::default()..PaintIndex::default(),
                                cache_key,
                            },
                        )
                    },
                )
            })
        } else {
            // Stateless path: just prepaint the element.
            window.with_id(
                ElementId::Name(std::any::type_name::<V>().into()),
                |window| {
                    request_layout
                        .element
                        .as_mut()
                        .unwrap()
                        .prepaint(window, cx);
                },
            );
            Some(request_layout.element.take().unwrap())
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
        if let Some(entity_id) = self.entity_id {
            // Stateful path.
            window.with_rendered_view(entity_id, |window| {
                let caching_disabled = window.is_inspector_picking(cx);
                if self.cached_style.is_some() && !caching_disabled {
                    window.with_element_state::<ViewElementState, _>(
                        global_id.unwrap(),
                        |element_state, window| {
                            let mut element_state = element_state.unwrap();

                            let paint_start = window.paint_index();

                            if let Some(element) = element {
                                let refreshing = mem::replace(&mut window.refreshing, true);
                                element.paint(window, cx);
                                window.refreshing = refreshing;
                            } else {
                                window.reuse_paint(element_state.paint_range.clone());
                            }

                            let paint_end = window.paint_index();
                            element_state.paint_range = paint_start..paint_end;

                            ((), element_state)
                        },
                    )
                } else {
                    element.as_mut().unwrap().paint(window, cx);
                }
            });
        } else {
            // Stateless path: just paint the element.
            window.with_id(
                ElementId::Name(std::any::type_name::<V>().into()),
                |window| {
                    element.as_mut().unwrap().paint(window, cx);
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
