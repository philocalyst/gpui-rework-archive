//! Elements are GPUI's low-level rendering contract. An element tree is built for a frame, laid
//! out with [Taffy](https://github.com/DioxusLabs/taffy), prepared for hit testing and focus, and
//! painted into the window. Most applications use [`RenderOnce`], [`Render`], and the elements in
//! [`crate::elements`] rather than implementing this module's traits directly.
//!
//! # Element Basics
//!
//! A frame runs in three ordered phases. [`Element::request_layout`] creates layout nodes and
//! returns the element's layout state. [`Element::prepaint`] receives the resolved bounds and
//! records hitboxes, focus information, and other frame-local state. [`Element::paint`] consumes
//! those two states to draw. The tree and frame-local callbacks are rebuilt for the next frame;
//! persistent state must live in a view, an entity, or an element state handle.
//!
//! But some state is too simple and voluminous to store in every view that needs it, e.g.
//! whether a hover has been started or not. For this, GPUI provides the [`Element::PrepaintState`], associated type.
//!
//! # Implementing your own elements
//!
//! Implement an element when a component needs a custom layout algorithm or direct paint access.
//! The implementation owns the invariants of its subtree: ordinary children stay within their
//! assigned bounds, while overlays may deliberately escape them through
//! [`Window::with_content_mask`]. Keep any state needed between frames outside the element value.
//!
//! For reusable components, prefer [`RenderOnce`] with `#[derive(IntoElement)]`; use [`Render`] when
//! the component is backed by an entity and must be invalidated independently. The
//! [layout constraints example](https://gpui-ce.github.io/examples/layout/#constraints) and
//! [drawing example](https://gpui-ce.github.io/examples/drawing/#paint) show the public path from
//! a component to an element tree and custom painting.

use crate::{
    A11ySubtreeBuilder, App, ArenaBox, AvailableSpace, Bounds, Context, DispatchNodeId, ElementId,
    FocusHandle, InspectorElementId, LayoutId, Pixels, Point, Size, Style, Window,
    util::FluentBuilder, window::with_element_arena,
};
use derive_more::{Deref, DerefMut};
use std::{
    any::Any,
    fmt::{self, Debug, Display},
    mem, panic,
    sync::Arc,
};

/// Participate in layout, prepaint, and paint for one position in a window's element tree.
///
/// GPUI calls these methods in order for each frame and passes the state returned by
/// [`request_layout`](Self::request_layout) into the later phases. Return a stable [`ElementId`]
/// when the element owns state that should follow it across frames; omit it for an ephemeral
/// element. Layout IDs and `bounds` are frame-local and must not be retained.
pub trait Element: 'static + IntoElement {
    /// Frame-local state produced while requesting layout and reused by prepaint and paint.
    type RequestLayoutState: 'static;

    /// Frame-local state produced after layout and reused by paint.
    type PrepaintState: 'static;

    /// Return this element's identity, if it owns state that should persist across frames.
    ///
    /// The global id can in turn be used to access state that's connected to an element with the same id across
    /// frames. This id must be unique among children of the first containing element with an id.
    fn id(&self) -> Option<ElementId>;

    /// Return the source location used by the inspector to identify this element.
    fn source_location(&self) -> Option<&'static panic::Location<'static>>;

    /// Request a Taffy layout node and initialize [`Self::RequestLayoutState`].
    fn request_layout(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState);

    /// Receive resolved bounds and record frame-local hitboxes, focus, or child state.
    fn prepaint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState;

    /// Paint using the resolved bounds and both phase states.
    fn paint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    );

    /// Returns the accessible role for this element, if any.
    /// Elements that return `None` have no accessibility node unless
    /// [`Element::is_a11y_hidden`] returns `true`.
    ///
    /// Note: inclusion in accessibility tree requires non-`None` [`id`][Element::id].
    ///
    /// See the [accessibility guide](crate::_accessibility) for an overview.
    fn a11y_role(&self) -> Option<accesskit::Role> {
        None
    }

    /// Whether assistive technology should ignore this element and its
    /// descendants.
    ///
    /// GPUI gives a hidden element without a role an internal container node.
    /// AccessKit uses that node to omit the subtree.
    fn is_a11y_hidden(&self) -> bool {
        false
    }

    /// Write accessibility properties to the given node.
    /// GPUI calls this only when [`Element::a11y_role`] returns `Some` or
    /// [`Element::is_a11y_hidden`] returns `true`.
    ///
    /// See the [accessibility guide](crate::_accessibility) for an overview.
    fn write_a11y_info(&self, _node: &mut accesskit::Node) {}

    /// Add synthetic child nodes to an [`Element`]. The element must have an
    /// [`.id()`][Element::id]. It must also have a
    /// [`.role()`][Element::a11y_role] or return `true` from
    /// [`Element::is_a11y_hidden`].
    ///
    /// Some elements may want to inject accessibility nodes that do not
    /// correspond to any GPUI element. For example, a custom text field element
    /// may want to inject synthetic child nodes for the text content.
    ///
    /// See [Synthetic children](crate::_accessibility#synthetic-children) in
    /// the accessibility guide for more detail.
    fn a11y_synthetic_children(
        &mut self,
        _prepaint: &mut Self::PrepaintState,
        _builder: &mut A11ySubtreeBuilder,
    ) {
    }

    /// Convert this element into a dynamically-typed [`AnyElement`].
    fn into_any(self) -> AnyElement {
        AnyElement::new(self)
    }
}

/// Convert a value into a concrete or type-erased [`Element`].
pub trait IntoElement: Sized {
    /// The concrete element type produced by [`Self::into_element`].
    type Element: Element;

    /// Convert this value into its concrete element.
    fn into_element(self) -> Self::Element;

    /// Convert this value into an [`AnyElement`] for heterogeneous child lists.
    fn into_any_element(self) -> AnyElement {
        self.into_element().into_any()
    }
}

impl<T: IntoElement> FluentBuilder for T {}

/// Render a stateful entity into an element tree.
///
/// The entity remains the view's identity, so notifying its context invalidates this subtree. Use
/// [`RenderOnce`] for an owned component that is rebuilt from its inputs.
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-Render-9fb18c52.md")]
// docs:examples:end
pub trait Render: 'static + Sized {
    /// Build the current element tree for this entity.
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement;
}

impl Render for Empty {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        Empty
    }
}

/// Render an owned, stateless component once into an element tree.
///
/// Implement this trait (or derive [`IntoElement`]) for a reusable recipe made from plain data.
/// Because rendering consumes `self`, fluent builder methods can assemble the component directly.
/// Put persistent state in an [`Entity`](crate::Entity) and implement [`Render`] when it must be
/// independently invalidated.
pub trait RenderOnce: 'static {
    /// Consume the component and build its element tree.
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement;
}

/// A variation on [`ParentElement`] which only supports children of a particular type.
pub trait ParentElementTyped {
    /// The specific item type that this element accepts (could simply implement IntoElement or be an element itself).
    type Child;

    /// Extend this element's children with the given child elements.
    fn extend(&mut self, elements: impl IntoIterator<Item = Self::Child>);

    /// Add a single child element to this element.
    fn child(mut self, child: Self::Child) -> Self
    where
        Self: Sized,
    {
        self.extend(std::iter::once(child));
        self
    }

    /// Add multiple child elements to this element.
    fn children(mut self, children: impl IntoIterator<Item = Self::Child>) -> Self
    where
        Self: Sized,
    {
        self.extend(children);
        self
    }
}

/// This is a helper trait to provide a uniform interface for constructing elements that
/// can accept any number of any kind of child elements
pub trait ParentElement {
    /// Extend this element's children with the given child elements.
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>);

    /// Add a single child element to this element.
    fn child(mut self, child: impl IntoElement) -> Self
    where
        Self: Sized,
    {
        self.extend(std::iter::once(child.into_element().into_any()));
        self
    }

    /// Add multiple child elements to this element.
    fn children(mut self, children: impl IntoIterator<Item = impl IntoElement>) -> Self
    where
        Self: Sized,
    {
        self.extend(children.into_iter().map(|child| child.into_any_element()));
        self
    }
}

/// A globally unique identifier for an element, used to track state across frames.
#[derive(Deref, DerefMut, Clone, Default, Debug, Eq, PartialEq, Hash)]
pub struct GlobalElementId(pub(crate) Arc<[ElementId]>);

impl Display for GlobalElementId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for (i, element_id) in self.0.iter().enumerate() {
            if i > 0 {
                write!(f, ".")?;
            }
            write!(f, "{}", element_id)?;
        }
        Ok(())
    }
}

impl GlobalElementId {
    pub(crate) fn accesskit_node_id(&self) -> accesskit::NodeId {
        use std::hash::{Hash, Hasher};
        let mut hasher = std::hash::DefaultHasher::default();
        self.hash(&mut hasher);
        accesskit::NodeId(hasher.finish())
    }
}

trait ElementObject {
    fn inner_element(&mut self) -> &mut dyn Any;

    fn request_layout(&mut self, window: &mut Window, cx: &mut App) -> LayoutId;

    fn prepaint(&mut self, window: &mut Window, cx: &mut App);

    fn paint(&mut self, window: &mut Window, cx: &mut App);

    fn layout_as_root(
        &mut self,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> Size<Pixels>;
}

/// A wrapper around an implementer of [`Element`] that allows it to be drawn in a window.
pub struct Drawable<E: Element> {
    /// The drawn element.
    pub element: E,
    phase: ElementDrawPhase<E::RequestLayoutState, E::PrepaintState>,
}

#[derive(Default)]
enum ElementDrawPhase<RequestLayoutState, PrepaintState> {
    #[default]
    Start,
    RequestLayout {
        layout_id: LayoutId,
        global_id: Option<GlobalElementId>,
        inspector_id: Option<InspectorElementId>,
        request_layout: RequestLayoutState,
    },
    LayoutComputed {
        layout_id: LayoutId,
        global_id: Option<GlobalElementId>,
        inspector_id: Option<InspectorElementId>,
        available_space: Size<AvailableSpace>,
        request_layout: RequestLayoutState,
    },
    Prepaint {
        node_id: DispatchNodeId,
        global_id: Option<GlobalElementId>,
        inspector_id: Option<InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: RequestLayoutState,
        prepaint: PrepaintState,
        inline_fragments: Option<Arc<[Bounds<Pixels>]>>,
    },
    Painted,
}

/// A wrapper around an implementer of [`Element`] that allows it to be drawn in a window.
impl<E: Element> Drawable<E> {
    pub(crate) fn new(element: E) -> Self {
        Drawable {
            element,
            phase: ElementDrawPhase::Start,
        }
    }

    fn request_layout(&mut self, window: &mut Window, cx: &mut App) -> LayoutId {
        match mem::take(&mut self.phase) {
            ElementDrawPhase::Start => {
                let global_id = self.element.id().map(|element_id| {
                    window.element_id_stack.push(element_id);
                    GlobalElementId(Arc::from(&*window.element_id_stack))
                });

                let inspector_id;
                #[cfg(any(feature = "inspector", debug_assertions))]
                {
                    inspector_id = self.element.source_location().map(|source| {
                        let path = crate::InspectorElementPath {
                            global_id: GlobalElementId(Arc::from(&*window.element_id_stack)),
                            source_location: source,
                        };
                        window.build_inspector_element_id(path)
                    });
                }
                #[cfg(not(any(feature = "inspector", debug_assertions)))]
                {
                    inspector_id = None;
                }

                #[cfg(all(
                    feature = "hot-patching",
                    debug_assertions,
                    not(target_family = "wasm")
                ))]
                let (layout_id, request_layout) = subsecond::HotFn::current(E::request_layout)
                    .call((
                        &mut self.element,
                        global_id.as_ref(),
                        inspector_id.as_ref(),
                        window,
                        cx,
                    ));
                #[cfg(not(all(
                    feature = "hot-patching",
                    debug_assertions,
                    not(target_family = "wasm")
                )))]
                let (layout_id, request_layout) = self.element.request_layout(
                    global_id.as_ref(),
                    inspector_id.as_ref(),
                    window,
                    cx,
                );

                if global_id.is_some() {
                    window.element_id_stack.pop();
                }

                self.phase = ElementDrawPhase::RequestLayout {
                    layout_id,
                    global_id,
                    inspector_id,
                    request_layout,
                };
                layout_id
            }
            _ => panic!("must call request_layout only once"),
        }
    }

    pub(crate) fn prepaint(&mut self, window: &mut Window, cx: &mut App) {
        match mem::take(&mut self.phase) {
            ElementDrawPhase::RequestLayout {
                layout_id,
                global_id,
                inspector_id,
                mut request_layout,
            }
            | ElementDrawPhase::LayoutComputed {
                layout_id,
                global_id,
                inspector_id,
                mut request_layout,
                ..
            } => {
                if let Some(element_id) = self.element.id() {
                    window.element_id_stack.push(element_id);
                    debug_assert_eq!(&*global_id.as_ref().unwrap().0, &*window.element_id_stack);
                }

                let bounds = window.layout_bounds(layout_id);
                let mut pushed_a11y_node = false;
                if window.a11y.is_active() {
                    if let Some(global_id) = global_id.as_ref() {
                        let hidden = self.element.is_a11y_hidden();
                        let role = self.element.a11y_role();
                        if role.is_some() || hidden {
                            let role = role.unwrap_or(accesskit::Role::GenericContainer);
                            let node_id = global_id.accesskit_node_id();
                            let mut node = accesskit::Node::new(role);
                            let scale = window.scale_factor();
                            node.set_bounds(accesskit::Rect {
                                x0: (bounds.origin.x.0 * scale) as f64,
                                y0: (bounds.origin.y.0 * scale) as f64,
                                x1: ((bounds.origin.x.0 + bounds.size.width.0) * scale) as f64,
                                y1: ((bounds.origin.y.0 + bounds.size.height.0) * scale) as f64,
                            });
                            self.element.write_a11y_info(&mut node);
                            if hidden {
                                node.set_hidden();
                            }
                            window.a11y.node_bounds.insert(node_id, bounds);
                            pushed_a11y_node = window.a11y.nodes.push(node_id, node);
                            #[cfg(debug_assertions)]
                            if pushed_a11y_node {
                                let view = window
                                    .a11y
                                    .view_type_names
                                    .get(&window.current_view())
                                    .copied();
                                let source_location = self.element.source_location();
                                window.a11y.nodes.record_node_info(
                                    node_id,
                                    crate::window::a11y::debug::NodeDebugInfo {
                                        synthetic: false,
                                        view,
                                        element_id: global_id.0.last().map(|id| format!("{id:?}")),
                                        source_location,
                                    },
                                );
                            }
                        }
                    }
                }

                let node_id = window.next_frame.dispatch_tree.push_node();

                let inline_fragments = window.inline_fragments(layout_id);
                let previous_fragments = std::mem::replace(
                    &mut window.current_inline_fragments,
                    inline_fragments.clone(),
                );

                let mut prepaint = window.with_layout_direction_context(layout_id, |window| {
                    #[cfg(all(
                        feature = "hot-patching",
                        debug_assertions,
                        not(target_family = "wasm")
                    ))]
                    {
                        subsecond::HotFn::current(E::prepaint).call((
                            &mut self.element,
                            global_id.as_ref(),
                            inspector_id.as_ref(),
                            bounds,
                            &mut request_layout,
                            window,
                            cx,
                        ))
                    }

                    #[cfg(not(all(
                        feature = "hot-patching",
                        debug_assertions,
                        not(target_family = "wasm")
                    )))]
                    {
                        self.element.prepaint(
                            global_id.as_ref(),
                            inspector_id.as_ref(),
                            bounds,
                            &mut request_layout,
                            window,
                            cx,
                        )
                    }
                });

                window.current_inline_fragments = previous_fragments;
                window.next_frame.dispatch_tree.pop_node();

                if pushed_a11y_node {
                    if let Some(global_id) = global_id.as_ref() {
                        #[cfg(debug_assertions)]
                        let creator = crate::window::a11y::debug::NodeCreator {
                            view: window
                                .a11y
                                .view_type_names
                                .get(&window.current_view())
                                .copied(),
                            element_id: global_id.0.last().map(|id| format!("{id:?}")),
                            source_location: self.element.source_location(),
                        };
                        let mut builder = A11ySubtreeBuilder::new(
                            global_id.accesskit_node_id(),
                            &mut window.a11y.nodes,
                        );
                        #[cfg(debug_assertions)]
                        {
                            builder = builder.with_creator(creator);
                        }
                        self.element
                            .a11y_synthetic_children(&mut prepaint, &mut builder);
                    }
                    window.a11y.nodes.pop();
                }

                if global_id.is_some() {
                    window.element_id_stack.pop();
                }

                self.phase = ElementDrawPhase::Prepaint {
                    node_id,
                    global_id,
                    inspector_id,
                    bounds,
                    request_layout,
                    prepaint,
                    inline_fragments,
                };
            }
            _ => panic!("must call request_layout before prepaint"),
        }
    }

    pub(crate) fn paint(
        &mut self,
        window: &mut Window,
        cx: &mut App,
    ) -> (E::RequestLayoutState, E::PrepaintState) {
        match mem::take(&mut self.phase) {
            ElementDrawPhase::Prepaint {
                node_id,
                global_id,
                inspector_id,
                bounds,
                mut request_layout,
                mut prepaint,
                inline_fragments,
                ..
            } => {
                if let Some(element_id) = self.element.id() {
                    window.element_id_stack.push(element_id);
                    debug_assert_eq!(&*global_id.as_ref().unwrap().0, &*window.element_id_stack);
                }

                window.next_frame.dispatch_tree.set_active_node(node_id);

                let previous_fragments =
                    std::mem::replace(&mut window.current_inline_fragments, inline_fragments);

                #[cfg(all(
                    feature = "hot-patching",
                    debug_assertions,
                    not(target_family = "wasm")
                ))]
                subsecond::HotFn::current(E::paint).call((
                    &mut self.element,
                    global_id.as_ref(),
                    inspector_id.as_ref(),
                    bounds,
                    &mut request_layout,
                    &mut prepaint,
                    window,
                    cx,
                ));
                #[cfg(not(all(
                    feature = "hot-patching",
                    debug_assertions,
                    not(target_family = "wasm")
                )))]
                self.element.paint(
                    global_id.as_ref(),
                    inspector_id.as_ref(),
                    bounds,
                    &mut request_layout,
                    &mut prepaint,
                    window,
                    cx,
                );

                if global_id.is_some() {
                    window.element_id_stack.pop();
                }

                window.current_inline_fragments = previous_fragments;

                self.phase = ElementDrawPhase::Painted;
                (request_layout, prepaint)
            }
            _ => panic!("must call prepaint before paint"),
        }
    }

    fn compute_layout_as_root(
        &mut self,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Size<Pixels>) {
        if matches!(&self.phase, ElementDrawPhase::Start) {
            self.request_layout(window, cx);
        }

        let layout_id = match mem::take(&mut self.phase) {
            ElementDrawPhase::RequestLayout {
                layout_id,
                global_id,
                inspector_id,
                request_layout,
            } => {
                window.compute_layout(layout_id, available_space, cx);
                self.phase = ElementDrawPhase::LayoutComputed {
                    layout_id,
                    global_id,
                    inspector_id,
                    available_space,
                    request_layout,
                };
                layout_id
            }
            ElementDrawPhase::LayoutComputed {
                layout_id,
                global_id,
                inspector_id,
                available_space: prev_available_space,
                request_layout,
            } => {
                if available_space != prev_available_space {
                    window.compute_layout(layout_id, available_space, cx);
                }
                self.phase = ElementDrawPhase::LayoutComputed {
                    layout_id,
                    global_id,
                    inspector_id,
                    available_space,
                    request_layout,
                };
                layout_id
            }
            _ => panic!("cannot measure after painting"),
        };

        (layout_id, window.layout_bounds(layout_id).size)
    }

    pub(crate) fn layout_as_root(
        &mut self,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> Size<Pixels> {
        self.compute_layout_as_root(available_space, window, cx).1
    }
}

impl<E> ElementObject for Drawable<E>
where
    E: Element,
    E::RequestLayoutState: 'static,
{
    fn inner_element(&mut self) -> &mut dyn Any {
        &mut self.element
    }

    #[inline]
    fn request_layout(&mut self, window: &mut Window, cx: &mut App) -> LayoutId {
        Drawable::request_layout(self, window, cx)
    }

    #[inline]
    fn prepaint(&mut self, window: &mut Window, cx: &mut App) {
        Drawable::prepaint(self, window, cx);
    }

    #[inline]
    fn paint(&mut self, window: &mut Window, cx: &mut App) {
        Drawable::paint(self, window, cx);
    }

    #[inline]
    fn layout_as_root(
        &mut self,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> Size<Pixels> {
        Drawable::layout_as_root(self, available_space, window, cx)
    }
}

/// A dynamically typed element that can be used to store any element type.
pub struct AnyElement(ArenaBox<dyn ElementObject>);

impl AnyElement {
    pub(crate) fn new<E>(element: E) -> Self
    where
        E: 'static + Element,
        E::RequestLayoutState: Any,
    {
        let element = with_element_arena(|arena| arena.alloc(|| Drawable::new(element)))
            .map(|element| element as &mut dyn ElementObject);
        AnyElement(element)
    }

    /// Attempt to downcast a reference to the boxed element to a specific type.
    pub fn downcast_mut<T: 'static>(&mut self) -> Option<&mut T> {
        self.0.inner_element().downcast_mut::<T>()
    }

    /// Request the layout ID of the element stored in this `AnyElement`.
    /// Used for laying out child elements in a parent element.
    pub fn request_layout(&mut self, window: &mut Window, cx: &mut App) -> LayoutId {
        self.0.request_layout(window, cx)
    }

    /// Prepares the element to be painted by storing its bounds, giving it a chance to draw hitboxes and
    /// request autoscroll before the final paint pass is confirmed.
    pub fn prepaint(&mut self, window: &mut Window, cx: &mut App) -> Option<FocusHandle> {
        let focus_assigned = window.next_frame.focus.is_some();

        self.0.prepaint(window, cx);

        if !focus_assigned && let Some(focus_id) = window.next_frame.focus {
            return FocusHandle::for_id(focus_id, &cx.focus_handles);
        }

        None
    }

    /// Paints the element stored in this `AnyElement`.
    pub fn paint(&mut self, window: &mut Window, cx: &mut App) {
        self.0.paint(window, cx);
    }

    /// Performs layout for this element within the given available space and returns its size.
    pub fn layout_as_root(
        &mut self,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> Size<Pixels> {
        self.0.layout_as_root(available_space, window, cx)
    }

    /// Prepaints this element at the given absolute origin.
    /// If any element in the subtree beneath this element is focused, its FocusHandle is returned.
    pub fn prepaint_at(
        &mut self,
        origin: Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<FocusHandle> {
        window.with_absolute_element_offset(origin, |window| self.prepaint(window, cx))
    }

    /// Performs layout on this element in the available space, then prepaints it at the given absolute origin.
    /// If any element in the subtree beneath this element is focused, its FocusHandle is returned.
    pub fn prepaint_as_root(
        &mut self,
        origin: Point<Pixels>,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<FocusHandle> {
        self.layout_as_root(available_space, window, cx);
        window.with_absolute_element_offset(origin, |window| self.prepaint(window, cx))
    }
}

impl Element for AnyElement {
    type RequestLayoutState = ();
    type PrepaintState = ();

    fn id(&self) -> Option<ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let layout_id = self.request_layout(window, cx);
        (layout_id, ())
    }

    fn prepaint(
        &mut self,
        _: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _: Bounds<Pixels>,
        _: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.prepaint(window, cx);
    }

    fn paint(
        &mut self,
        _: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _: Bounds<Pixels>,
        _: &mut Self::RequestLayoutState,
        _: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.paint(window, cx);
    }
}

impl IntoElement for AnyElement {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }

    fn into_any_element(self) -> AnyElement {
        self
    }
}

/// The empty element, which renders nothing.
pub struct Empty;

impl IntoElement for Empty {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Element for Empty {
    type RequestLayoutState = ();
    type PrepaintState = ();

    fn id(&self) -> Option<ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        (
            window.request_layout(
                Style {
                    display: crate::Display::None,
                    ..Default::default()
                },
                None,
                cx,
            ),
            (),
        )
    }

    fn prepaint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _state: &mut Self::RequestLayoutState,
        _window: &mut Window,
        _cx: &mut App,
    ) {
    }

    fn paint(
        &mut self,
        _id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        _prepaint: &mut Self::PrepaintState,
        _window: &mut Window,
        _cx: &mut App,
    ) {
    }
}
