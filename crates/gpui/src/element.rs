//! Elements are GPUI's low-level rendering contract. An element tree is built for a frame, laid
//! out with [Taffy](https://github.com/DioxusLabs/taffy), prepared for hit testing and focus, and
//! painted into the window. Most applications use [`RenderOnce`], [`Render`], and the elements in
//! [`crate::elements`] rather than implementing this module's traits directly.
//!
//! # Element Basics
//!
//! A frame runs in three ordered phases. [`Element::request_layout`] creates layout nodes and
//! returns the element's layout state. [`Element::prepaint`] receives the resolved bounds and
//! records hitboxes, focus information, and other frame-local state. [`Element::paint`] borrows
//! those two states to draw. A newly rendered tree builds its own phase state
//! and callbacks; cached views can reuse earlier frame records. Persistent state
//! belongs in an entity or under a stable element ID.
//!
//! `RequestLayoutState` and `PrepaintState` carry work between phases of this
//! frame. For state that must survive another render, use an entity or
//! [`Window::with_element_state`] under a stable element ID. The associated
//! types alone do not make state persistent.
//!
//! # Choose a component boundary
//!
//! Use [`RenderOnce`] and `#[derive(IntoElement)]` for a reusable component built
//! from inputs. Use [`Render`] for a component backed by an entity that can be
//! notified independently. Implement [`Element`] when the component needs to
//! control layout, hit testing, or the preparation passed into painting.
//!
//! Custom paint code uses the window's coordinate and clipping state. Layout
//! bounds describe the assigned region; they do not clip drawing by themselves.
//! [`Window::with_content_mask`] narrows the active clip. The
//! [drawing walkthrough](https://gpui-ce.github.io/examples/drawing/#paint)
//! shows how [`crate::canvas`] provides custom painting without a new element
//! implementation. The [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/)
//! implements all three methods and shows their state handoff.

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
/// When drawing this element, GPUI calls these methods in order and passes the state returned by
/// [`request_layout`](Self::request_layout) into the later phases. Return a stable [`ElementId`]
/// when the element owns state that should follow it across frames; omit it for an ephemeral
/// element. A [`LayoutId`] is valid only for its frame. Bounds may be retained
/// as the last measured geometry, but must be refreshed when layout changes.
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-Element-e02c3ee0.md")]
// docs:examples:end
pub trait Element: 'static + IntoElement {
    /// Frame-local state produced while requesting layout and reused by prepaint and paint.
    type RequestLayoutState: 'static;

    /// Frame-local state produced after layout and reused by paint.
    type PrepaintState: 'static;

    /// Returns this element's component of the window's identity path.
    ///
    /// GPUI appends this ID to the IDs of its containing elements to form a [`GlobalElementId`].
    /// The local ID must be unique among siblings in the same identity scope
    /// and remain the same through this element's layout, prepaint, and paint.
    /// Use a record's key for a row that can move; its position would transfer
    /// retained state to a different record after reordering.
    ///
    /// Return `None` when this element needs no identity of its own. Its
    /// children can still supply their own IDs within the enclosing scope.
    /// An ID allows retained element state and accessibility nodes; it does
    /// not retain the element value itself. See
    /// [element identity](crate::_ownership_and_data_flow#give-retained-element-state-an-identity).
    fn id(&self) -> Option<ElementId>;

    /// Returns the construction call site shown by the inspector, when available.
    ///
    /// Store [`std::panic::Location::caller()`] in a `#[track_caller]`
    /// constructor to report the application's call site. Computing it here
    /// would report the rendering machinery's call instead. Return `None`
    /// when the element does not record its origin.
    fn source_location(&self) -> Option<&'static panic::Location<'static>>;

    /// Registers this element's layout request and prepares its children.
    ///
    /// Return a node from [`Window::request_layout`] or
    /// [`Window::request_measured_layout`], together with the state needed by
    /// later phases. A container requests its children's layout first, passes
    /// their IDs to its own request, and retains those child element values
    /// for prepaint and paint.
    ///
    /// This method records inputs to layout; the final bounds are not known
    /// yet. For intrinsic content such as text, a measured-layout callback
    /// receives the known dimensions and available-space query when the
    /// layout engine measures it. That callback can run several times for one
    /// layout request, so it must tolerate repeated queries.
    ///
    /// `id` includes this element's local ID and its ID-bearing ancestors.
    /// GPUI has already entered that identity scope for this call. Use the
    /// supplied ID with [`Window::with_element_state`] when the element needs
    /// bookkeeping that survives a rebuilt tree.
    fn request_layout(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState);

    /// Prepares interaction and frame state after layout has resolved `bounds`.
    ///
    /// The bounds use logical, window-local pixels, including the active
    /// element offset. Insert hitboxes, associate focus handles, and prepaint
    /// retained child elements here. Return the data paint needs, such as a
    /// hitbox ID or prepared drawing geometry. `request_layout` is the state
    /// returned by this element's layout request; it can also be updated here.
    ///
    /// GPUI calls [`Self::a11y_synthetic_children`] after this method when the
    /// element has an active accessibility node. Store any geometry that hook
    /// needs in [`Self::PrepaintState`]. Painting a shape alone creates neither
    /// a hitbox nor an accessible control.
    fn prepaint(
        &mut self,
        id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState;

    /// Records drawing and input handlers for the prepared element.
    ///
    /// GPUI passes the same bounds and phase states prepared for this draw.
    /// Paint retained children and register handlers using the hitboxes
    /// created during prepaint. Keyboard handlers attach to the dispatch node
    /// GPUI created for this element in that phase.
    ///
    /// Bounds do not clip drawing automatically. Use
    /// [`Window::with_content_mask`] when drawing must stay in a smaller
    /// region, and arrange the same clip during prepaint when it must also
    /// constrain hit testing. The [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/#draw)
    /// shows the complete state handoff.
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

/// Convert a component value into its concrete [`Element`] representation.
///
/// `IntoElement` lets parents accept component values without naming each concrete return type.
/// Use [`AnyElement`] when storing children of different concrete types in the same collection.
/// Type erasure does not add persistent identity; the concrete element's ID determines whether
/// GPUI can associate retained element state with it across frames.
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-IntoElement-1ab5061b.md")]
// docs:examples:end
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
    /// Builds an element tree describing the entity's current state.
    ///
    /// Return a correct tree whenever this method runs; rendering can be
    /// cached or invalidated, so its call count is not a lifecycle signal.
    /// Store persistent values on the entity or under stable element IDs.
    /// Avoid starting a new task or subscription on each render: create those
    /// relationships during construction or in response to an explicit event.
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement;
}

impl Render for Empty {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        Empty
    }
}

/// Consumes an owned component to produce an element tree.
///
/// Implement this trait for a component built from parent-supplied data, then
/// derive [`IntoElement`] to use it as a child. Each value is rendered once;
/// the parent creates another value when it renders again. Builder methods can
/// therefore consume and return `self` without managing a persistent component.
///
/// ```
/// use gpui::{App, IntoElement, RenderOnce, SharedString, Window, div, prelude::*};
///
/// #[derive(IntoElement)]
/// struct Badge { label: SharedString }
///
/// impl RenderOnce for Badge {
///     fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
///         div().px_2().py_1().rounded_md().child(self.label)
///     }
/// }
/// ```
///
/// This trait supplies no independent entity identity. It can still use state
/// retained under stable element IDs, or hold handles to parent-owned entities.
/// Implement [`Render`] on an entity when the component itself should own state
/// and receive independent invalidation through [`Context::notify`].
///
/// # Give repeated instances separate scopes
///
/// Deriving `IntoElement` scopes the component's element state by its Rust type
/// name. Two `Badge` siblings still have the same type, so put each inside a
/// parent with a stable record key when they use retained state or child IDs:
///
/// ```
/// # use gpui::{App, IntoElement, RenderOnce, SharedString, Window, div, prelude::*};
/// # #[derive(IntoElement)]
/// # struct Badge { label: SharedString }
/// # impl RenderOnce for Badge {
/// #     fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
/// #         div().child(self.label)
/// #     }
/// # }
/// fn badges(records: &[(u64, SharedString)]) -> impl IntoElement {
///     div().children(records.iter().map(|(id, label)| {
///         div().id(("badge", *id)).child(Badge { label: label.clone() })
///     }))
/// }
/// ```
///
/// The parent's ID is active when `Badge::render` runs. An ID on the element
/// returned by `render` is applied later: it cannot scope an earlier
/// [`Window::use_state`] call inside that method. The
/// [identity chapter](crate::_ownership_and_data_flow#give-retained-element-state-an-identity)
/// explains keys, removal, and retained state. The
/// [row-state test](https://gpui-ce.github.io/guides/testing/#keep-row-state-with-its-record)
/// changes one row, reverses the records, and checks that each record keeps
/// its own state.
pub trait RenderOnce: 'static {
    /// Consume the component and build its element tree.
    fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement;
}

/// Appends children of one component-specific type.
///
/// Use this trait for a parent whose children carry information beyond an
/// element tree, such as a tab label or a menu item's action. [`ParentElement`]
/// accepts any value that implements [`IntoElement`] instead.
pub trait ParentElementTyped {
    /// The value accepted for each child. It need not implement [`IntoElement`].
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

/// Appends element children in the order supplied.
///
/// Builders such as [`Div`](crate::Div) implement this trait so callers can
/// mix strings, entity-backed views, and owned components. The default builders
/// erase each child's concrete type into [`AnyElement`]. They append to the
/// existing children; they do not replace them.
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

/// The path of local [`ElementId`] values identifying an element in its window.
///
/// GPUI builds this path from the IDs on the route through the element tree. It keys retained
/// element state and accessibility nodes; it is distinct from [`LayoutId`], which is created for
/// layout work in one frame. Application code supplies local [`ElementId`] values and normally
/// receives this expanded path only in [`Element`] callbacks.
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

/// An element and the state of its current layout, prepaint, and paint sequence.
///
/// GPUI creates this wrapper when an element is erased into [`AnyElement`].
/// Application code normally uses that interface to draw children.
pub struct Drawable<E: Element> {
    /// The concrete element being drawn.
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

/// An element whose concrete type is erased, together with its current draw state.
///
/// Obtain one with [`IntoElement::into_any_element`] when a parent must store
/// children of different types. Conversion preserves the contained element's
/// identity and behavior; it adds no ID or layout box of its own. A
/// [`Div`](crate::Div), a view backed by an entity, and an owned component can
/// therefore share one collection:
///
/// ```
/// use gpui::{AnyElement, Entity, IntoElement, ParentElement, Render, div};
///
/// fn children<V: Render>(view: Entity<V>) -> Vec<AnyElement> {
///     vec![div().child("Details").into_any_element(), view.into_any_element()]
/// }
/// ```
///
/// # Prepare each child once
///
/// A custom parent drives the child's phases. Choose one layout path:
///
/// | Child placement | Layout | Prepaint | Paint |
/// | --- | --- | --- | --- |
/// | Part of the parent's layout | Call [`request_layout`](Self::request_layout) and include the returned ID in the parent's layout request. | After GPUI computes the containing tree, call [`prepaint`](Self::prepaint). | Call [`paint`](Self::paint). |
/// | Positioned independently | Call [`layout_as_root`](Self::layout_as_root) with the available space. | Call [`prepaint_at`](Self::prepaint_at) with a window-local translation. | Call [`paint`](Self::paint). |
///
/// [`prepaint_as_root`](Self::prepaint_as_root) combines the independent layout
/// and prepaint steps. Retain the same `AnyElement` between phases: creating a
/// replacement discards the prepared state. Measurement may be repeated before
/// prepaint, but prepaint and paint each run once per element value. Calling
/// phases out of order panics.
///
/// The element is allocated in GPUI's temporary element arena. Keep it within
/// the draw that created it; clearing that arena destroys the element, and
/// accessing its `AnyElement` afterward panics. Store an [`Entity`](crate::Entity),
/// [`AnyView`](crate::AnyView), or component inputs when something must survive
/// another frame, then build a new element from them. An element ID retains
/// associated state across those new values, not the values themselves. See
/// the [rendering chapter](crate::_documentation::rendering).
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

    /// Borrows the concrete element as `T`, or returns `None` for a different type.
    ///
    /// `T` must be the element produced by [`IntoElement::into_element`], which
    /// can differ from the component value passed to that conversion. Mutating
    /// it does not restart completed phases: finish configuration before
    /// requesting layout when the change affects size or child structure.
    pub fn downcast_mut<T: 'static>(&mut self) -> Option<&mut T> {
        self.0.inner_element().downcast_mut::<T>()
    }

    /// Requests the child's layout node and initializes its layout-phase state.
    ///
    /// A custom parent calls this once per child from its own
    /// [`Element::request_layout`], then includes the returned ID in its layout
    /// request. Calling it twice on the same element value panics.
    pub fn request_layout(&mut self, window: &mut Window, cx: &mut App) -> LayoutId {
        self.0.request_layout(window, cx)
    }

    /// Prepares the child using its resolved layout bounds.
    ///
    /// Call after layout has been computed and before [`paint`](Self::paint).
    /// This records hitboxes and other frame data. It returns the subtree's
    /// focused handle only if focus had not already been recorded in this frame.
    /// Panics if layout has not been requested or this element value has
    /// already entered prepaint or paint. Requesting layout alone does not
    /// compute it; the containing tree must be laid out before this call.
    pub fn prepaint(&mut self, window: &mut Window, cx: &mut App) -> Option<FocusHandle> {
        let focus_assigned = window.next_frame.focus.is_some();

        self.0.prepaint(window, cx);

        if !focus_assigned && let Some(focus_id) = window.next_frame.focus {
            return FocusHandle::for_id(focus_id, &cx.focus_handles);
        }

        None
    }

    /// Paints the prepared child and installs its input handlers for this frame.
    ///
    /// Call once, after [`prepaint`](Self::prepaint). Calling before prepaint
    /// or painting the same element value again panics.
    pub fn paint(&mut self, window: &mut Window, cx: &mut App) {
        self.0.paint(window, cx);
    }

    /// Measures the element as a layout root and returns its logical-pixel size.
    ///
    /// This also requests layout if needed. Before prepaint, it can be called
    /// again with different available space to recompute the size; it does not
    /// rebuild the element or repeat its layout request. Use this to measure a
    /// detached subtree before choosing where to place it. For an ordinary
    /// child, include its [`request_layout`](Self::request_layout) ID in the
    /// parent's request instead, so the parent participates in sizing it.
    ///
    /// Available space constrains layout; it does not clip drawing or force
    /// an explicitly sized element to fit. The result is a size, not a new
    /// origin. Follow with [`prepaint_at`](Self::prepaint_at) and
    /// [`paint`](Self::paint), or use [`prepaint_as_root`](Self::prepaint_as_root)
    /// when the origin is already known. Calling after the element has entered
    /// prepaint or paint panics.
    pub fn layout_as_root(
        &mut self,
        available_space: Size<AvailableSpace>,
        window: &mut Window,
        cx: &mut App,
    ) -> Size<Pixels> {
        self.0.layout_as_root(available_space, window, cx)
    }

    /// Prepares the laid-out element with a logical, window-local translation.
    ///
    /// This replaces the active element offset. The element's position within
    /// its layout tree still contributes to its bounds; `origin` does not
    /// replace that position or recompute layout. A child already laid out at
    /// `(12, 0)` receives bounds at `(32, 30)` when `origin` is `(20, 30)`.
    /// A separately computed root normally starts at `(0, 0)`.
    ///
    /// Call after layout has been computed. The phase, panic, and returned
    /// focus-handle rules follow [`prepaint`](Self::prepaint). Paint subsequently
    /// uses the prepared bounds; do not add this translation again to drawing
    /// coordinates. The translation moves neither the content mask nor sibling
    /// elements. Use [`Window::with_content_mask`] in both phases when a subtree
    /// must clip input and paint. See the worked
    /// [`prepaint_as_root`](Self::prepaint_as_root) example and
    /// [coordinate spaces](crate::_documentation::layout#keep-geometry-in-one-coordinate-space).
    pub fn prepaint_at(
        &mut self,
        origin: Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<FocusHandle> {
        window.with_absolute_element_offset(origin, |window| self.prepaint(window, cx))
    }

    /// Lays out the element as a root, then prepaints it with the supplied translation.
    ///
    /// Use this for a separately positioned subtree, such as an overlay. The
    /// `origin` follows [`prepaint_at`](Self::prepaint_at)'s coordinate rules.
    /// Measurement follows [`layout_as_root`](Self::layout_as_root), and the
    /// returned focus handle follows [`prepaint`](Self::prepaint).
    ///
    /// # Position a subtree during prepaint
    ///
    /// This canvas prepares a 24-by-12 marker twelve pixels from its left edge
    /// and eight from its top. The marker is laid out independently, so it does
    /// not determine the canvas's size. The prepaint closure returns the same
    /// prepared element for the paint closure to consume:
    ///
    /// ```
    /// use gpui::{Context, IntoElement, Render, Window, canvas, div, point,
    ///            prelude::*, px, rgb};
    ///
    /// struct Preview;
    /// impl Render for Preview {
    ///     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
    ///         div().p(px(20.)).child(
    ///             canvas(
    ///                 |bounds, window, cx| {
    ///                     let mut marker = div().w(px(24.)).h(px(12.))
    ///                         .bg(rgb(0x155b50)).into_any_element();
    ///                     marker.prepaint_as_root(
    ///                         bounds.origin + point(px(12.), px(8.)),
    ///                         bounds.size.into(), window, cx,
    ///                     );
    ///                     marker
    ///                 },
    ///                 |_, mut marker, window, cx| marker.paint(window, cx),
    ///             ).w(px(80.)).h(px(40.))
    ///         )
    ///     }
    /// }
    /// # let mut app = gpui::TestApp::new();
    /// # let mut window = app.open_window(|_, _| Preview);
    /// # window.draw();
    /// # window.update(|_, window, _| {
    /// #     let marker = window.painted_quads().into_iter()
    /// #         .find(|quad| quad.background == rgb(0x155b50).into()).unwrap();
    /// #     assert_eq!(marker.bounds.origin,
    /// #         point(px(32.), px(28.)).scale(window.scale_factor()));
    /// #     assert_eq!(marker.bounds.size,
    /// #         gpui::size(px(24.), px(12.)).scale(window.scale_factor()));
    /// # });
    /// ```
    ///
    /// The parent's padding contributes twenty pixels to each coordinate;
    /// `origin` therefore places the marker at `(32, 28)` in the window. No
    /// paint-time offset is needed. This method does not defer paint order or
    /// escape the enclosing clip. Use [`anchored`](crate::anchored) for edge
    /// fitting and [`deferred`](crate::deferred) for a popup that must draw above
    /// surrounding content.
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

/// An element with `display: none`: it occupies no layout space and paints nothing.
///
/// Use this for an absent child when the surrounding API needs an element value.
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
