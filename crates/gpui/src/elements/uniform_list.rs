//! A scrollable list optimized for items with one shared height.
//!
//! `uniform_list` measures one representative item to calculate the content
//! height and visible range, then lays out only the requested rows. It does not
//! measure every offscreen row. Every rendered item must have the same height
//! for the current frame. If heights differ, use [`crate::list`] instead.
//! Rendering is lazy: the callback receives the visible range, including partially visible
//! rows, and separate one-item ranges for measurement. See the
//! [visible-range walkthrough](https://gpui-ce.github.io/examples/lists/#visible-range).

use crate::{
    AnyElement, App, AvailableSpace, Bounds, Element, ElementId, Entity, GlobalElementId, Hitbox,
    InspectorElementId, InteractiveElement, Interactivity, IntoElement, IsZero, LayoutId,
    ListSizingBehavior, Overflow, Pixels, Point, ScrollHandle, Size, StyleRefinement, Styled,
    Window, point, px, size,
};
use smallvec::SmallVec;
use std::{cell::RefCell, cmp, ops::Range, rc::Rc};

use super::ListHorizontalSizingBehavior;

/// Construct a lazily rendered list of `item_count` uniform-height items.
///
/// The callback receives a half-open item range and must return elements in that order. Each
/// element must resolve to the same height as the item selected for measurement. Keep `id` stable
/// across frames so scroll state and descendants retain their identity.
/// The callback also receives one-item measurement requests; it is not called
/// exactly once per frame. Return one element for each requested index.
#[track_caller]
// docs:examples:begin
#[doc = include_str!("../docs/examples/gpui-uniform-list.md")]
// docs:examples:end
pub fn uniform_list<R>(
    id: impl Into<ElementId>,
    item_count: usize,
    f: impl 'static + Fn(Range<usize>, &mut Window, &mut App) -> Vec<R>,
) -> UniformList
where
    R: IntoElement,
{
    let id = id.into();
    let mut base_style = StyleRefinement::default();
    base_style.overflow.y = Some(Overflow::Scroll);

    let render_range = move |range: Range<usize>, window: &mut Window, cx: &mut App| {
        f(range, window, cx)
            .into_iter()
            .map(|component| component.into_any_element())
            .collect()
    };

    UniformList {
        item_count,
        item_to_measure_index: 0,
        render_items: Box::new(render_range),
        decorations: Vec::new(),
        interactivity: Interactivity {
            element_id: Some(id),
            base_style: Box::new(base_style),
            ..Interactivity::new()
        },
        scroll_handle: None,
        sizing_behavior: ListSizingBehavior::default(),
        horizontal_sizing_behavior: ListHorizontalSizingBehavior::default(),
    }
}

/// A scrolling viewport whose rows all share one measured height.
///
/// Construct this with [`uniform_list`], then use [`Styled`] to give it a
/// finite size. The default [`ListSizingBehavior::Auto`] uses those layout
/// constraints; [`Self::with_sizing_behavior`] can infer an intrinsic size
/// from the representative row instead. An unbounded content height does
/// not provide a useful scrolling viewport.
///
/// Rows are separate layout roots with the viewport width available to them.
/// They do not automatically stretch to that width: use [`Styled::w_full`]
/// when a row's background or hit target should fill it. Keep row heights
/// equal and positive; choose [`crate::list`] when content determines each
/// row's height. See [`Self::with_width_from_item`] for representative
/// measurement and [`Self::track_scroll`] for controlling the position.
pub struct UniformList {
    item_count: usize,
    item_to_measure_index: usize,
    render_items: Box<
        dyn for<'a> Fn(Range<usize>, &'a mut Window, &'a mut App) -> SmallVec<[AnyElement; 64]>,
    >,
    decorations: Vec<Box<dyn UniformListDecoration>>,
    interactivity: Interactivity,
    scroll_handle: Option<UniformListScrollHandle>,
    sizing_behavior: ListSizingBehavior,
    horizontal_sizing_behavior: ListHorizontalSizingBehavior,
}

/// Rows and decorations carried through one [`UniformList`] draw.
///
/// The list's [`Element`] implementation creates this during layout and fills
/// it during prepaint. It does not retain a scroll position between frames;
/// use [`UniformListScrollHandle`] for that state.
pub struct UniformListFrameState {
    items: SmallVec<[AnyElement; 32]>,
    decorations: SmallVec<[AnyElement; 2]>,
}

/// Shared scroll state for a [`UniformList`].
///
/// Store one handle on the owning view and bind it with
/// [`UniformList::track_scroll`] on each render. Item-scroll methods queue a
/// request for the next prepaint; they do not notify the view or request a
/// redraw. Call [`Context::notify`](crate::Context::notify) or [`Window::refresh`]
/// after changing the position.
///
/// Clones share geometry and one pending item request. A later request replaces
/// an earlier unconsumed one. Geometry queries describe the last prepaint;
/// queuing a request does not immediately update them.
#[derive(Clone, Debug, Default)]
pub struct UniformListScrollHandle(pub Rc<RefCell<UniformListScrollState>>);

/// Where to place the element scrolled to.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ScrollStrategy {
    /// Place the element at the top of the list's viewport.
    Top,
    /// Center the element, clamping the scroll position at the list's ends.
    Center,
    /// Align the element with the bottom edge, clamping at the list's ends.
    Bottom,
    /// Keep a visible element in place. Otherwise align it with the top edge
    /// when it lies above the viewport, or the bottom edge when it lies below.
    Nearest,
}

/// An item-scroll request consumed during the uniform list's next prepaint.
#[derive(Clone, Copy, Debug)]
pub struct DeferredScrollToItem {
    /// The item index to scroll to
    pub item_index: usize,
    /// The scroll strategy to use
    pub strategy: ScrollStrategy,
    /// Inset from the top edge in item heights, used by `Top` and `Center`.
    pub offset: usize,
    /// Align even if the item is already visible. `Nearest` still leaves visible items in place.
    pub scroll_strict: bool,
}

/// Persistent geometry and pending scroll requests shared by a uniform list and its handle.
#[derive(Clone, Debug, Default)]
pub struct UniformListScrollState {
    /// Pixel-offset scroll state populated by the list.
    pub base_handle: ScrollHandle,
    /// Request awaiting consumption by the next list prepaint.
    pub deferred_scroll_to_item: Option<DeferredScrollToItem>,
    /// Viewport and total content size from the last prepaint, not one row's size.
    pub last_item_size: Option<ItemSize>,
    /// Whether logical rows are displayed in reverse vertical order.
    /// Set through [`UniformList::y_flipped`] after attaching this handle.
    pub y_flipped: bool,
}

#[derive(Copy, Clone, Debug, Default)]
/// The measured list viewport and its total content size.
pub struct ItemSize {
    /// The viewport inside the list's border and padding.
    pub item: Size<Pixels>,
    /// Total row height and the scrollable content width.
    pub contents: Size<Pixels>,
}

impl UniformListScrollHandle {
    /// Create a new scroll handle to bind to a uniform list.
    // docs:examples:begin
    #[doc = include_str!("../docs/examples/gpui-UniformListScrollHandle-new-c1900937.md")]
    // docs:examples:end
    pub fn new() -> Self {
        Self(Rc::new(RefCell::new(UniformListScrollState {
            base_handle: ScrollHandle::new(),
            deferred_scroll_to_item: None,
            last_item_size: None,
            y_flipped: false,
        })))
    }

    /// Queues a request to reveal a logical item index.
    ///
    /// A fully visible item stays in place. Otherwise `strategy` selects its
    /// alignment; [`ScrollStrategy::Nearest`] moves only far enough to reveal
    /// it. The next prepaint consumes the request and clamps the resulting
    /// offset to the scrollable extent. Schedule a redraw separately.
    pub fn scroll_to_item(&self, ix: usize, strategy: ScrollStrategy) {
        self.0.borrow_mut().deferred_scroll_to_item = Some(DeferredScrollToItem {
            item_index: ix,
            strategy,
            offset: 0,
            scroll_strict: false,
        });
    }

    /// Scroll the list so that the given item index is at scroll strategy position.
    ///
    /// `Top`, `Center`, and `Bottom` align even an already visible item.
    /// `Nearest` still leaves a visible item in place. The next prepaint
    /// consumes this request; schedule a redraw separately.
    pub fn scroll_to_item_strict(&self, ix: usize, strategy: ScrollStrategy) {
        self.0.borrow_mut().deferred_scroll_to_item = Some(DeferredScrollToItem {
            item_index: ix,
            strategy,
            offset: 0,
            scroll_strict: true,
        });
    }

    /// Scroll the list to the given item index with an offset in number of items.
    ///
    /// This uses non-strict scrolling: if the item is already visible within the offset region,
    /// no scrolling occurs.
    ///
    /// `offset` reserves space above the target, measured in item heights.
    /// `Top` aligns below that inset; `Center` centers in the remaining viewport.
    /// `Bottom` ignores the offset. `Nearest` uses the inset when deciding whether
    /// the target is above the visible region.
    pub fn scroll_to_item_with_offset(&self, ix: usize, strategy: ScrollStrategy, offset: usize) {
        self.0.borrow_mut().deferred_scroll_to_item = Some(DeferredScrollToItem {
            item_index: ix,
            strategy,
            offset,
            scroll_strict: false,
        });
    }

    /// Scroll the list so that the given item index is at the exact scroll strategy position with an offset.
    ///
    /// `Top`, `Center`, and `Bottom` align even an already visible item;
    /// `Nearest` moves only an item outside the usable region.
    ///
    /// `offset` reserves space above the target, measured in item heights.
    /// `Top` aligns below that inset; `Center` centers in the remaining viewport.
    /// `Bottom` ignores the offset. `Nearest` still leaves a visible item in place.
    pub fn scroll_to_item_strict_with_offset(
        &self,
        ix: usize,
        strategy: ScrollStrategy,
        offset: usize,
    ) {
        self.0.borrow_mut().deferred_scroll_to_item = Some(DeferredScrollToItem {
            item_index: ix,
            strategy,
            offset,
            scroll_strict: true,
        });
    }

    /// Returns the row direction last set on this handle.
    ///
    /// This starts as `false`. It describes logical row order, not the sign
    /// of the pixel scroll offset.
    pub fn y_flipped(&self) -> bool {
        self.0.borrow().y_flipped
    }

    /// Returns a pending item target, or the base handle's top child index.
    ///
    /// This testing helper does not calculate a uniform row index from the
    /// pixel offset. After consumption, it delegates to
    /// [`ScrollHandle::logical_scroll_top`], whose child bounds are normally
    /// populated by a `Div`; an ordinary uniform list does not populate them.
    /// Do not use this as an assertion of the visible row after a scroll.
    #[cfg(any(test, feature = "headless"))]
    pub fn logical_scroll_top_index(&self) -> usize {
        let this = self.0.borrow();
        this.deferred_scroll_to_item
            .as_ref()
            .map(|deferred| deferred.item_index)
            .unwrap_or_else(|| this.base_handle.logical_scroll_top().0)
    }

    /// Returns whether the last measured content is taller than the viewport.
    ///
    /// Returns `false` before the first prepaint. This describes geometry;
    /// a pending scroll request does not change it.
    pub fn is_scrollable(&self) -> bool {
        if let Some(size) = self.0.borrow().last_item_size {
            size.contents.height > size.item.height
        } else {
            false
        }
    }

    /// Reports whether the viewport is at the physical bottom of its scroll extent.
    ///
    /// Returns `None` before usable scroll geometry exists or when there is
    /// no vertical overflow. This uses the base handle's last offset and does
    /// not account for a pending item request. Row order does not change its
    /// meaning: with [`UniformList::y_flipped`], the physical bottom contains
    /// the beginning of logical item order. [`Self::scroll_to_bottom`] instead
    /// requests the logical end.
    pub fn is_scrolled_to_end(&self) -> Option<bool> {
        let state = self.0.borrow();
        let max_offset = state.base_handle.max_offset();
        if max_offset.y <= px(0.) {
            return None;
        }
        let offset = state.base_handle.offset();
        Some(-offset.y >= max_offset.y)
    }

    /// Queues a request to reveal the end of the list's logical item order.
    ///
    /// With ordinary row order, this scrolls to the physical bottom. With
    /// [`UniformList::y_flipped`], the end of the logical order is at the
    /// physical top. Schedule a redraw to consume the request.
    pub fn scroll_to_bottom(&self) {
        self.scroll_to_item(usize::MAX, ScrollStrategy::Bottom);
    }
}

impl Styled for UniformList {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.interactivity.base_style
    }
}

impl Element for UniformList {
    type RequestLayoutState = UniformListFrameState;
    type PrepaintState = Option<Hitbox>;

    fn id(&self) -> Option<ElementId> {
        self.interactivity.element_id.clone()
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let max_items = self.item_count;
        let item_size = self.measure_item(None, window, cx);
        let layout_id = self.interactivity.request_layout(
            global_id,
            inspector_id,
            window,
            cx,
            |style, window, cx| match self.sizing_behavior {
                ListSizingBehavior::Infer => {
                    window.with_text_style(style.text_style().cloned(), |window| {
                        window.request_measured_layout(
                            style,
                            move |known_dimensions, available_space, _window, _cx| {
                                let desired_height = item_size.height * max_items;
                                let width = known_dimensions.width.unwrap_or(match available_space
                                    .width
                                {
                                    AvailableSpace::Definite(x) => x,
                                    AvailableSpace::MinContent | AvailableSpace::MaxContent => {
                                        item_size.width
                                    }
                                });
                                let height = match available_space.height {
                                    AvailableSpace::Definite(height) => desired_height.min(height),
                                    AvailableSpace::MinContent | AvailableSpace::MaxContent => {
                                        desired_height
                                    }
                                };
                                size(width, height)
                            },
                        )
                    })
                }
                ListSizingBehavior::Auto => window
                    .with_text_style(style.text_style().cloned(), |window| {
                        window.request_layout(style, None, cx)
                    }),
            },
        );

        (
            layout_id,
            UniformListFrameState {
                items: SmallVec::new(),
                decorations: SmallVec::new(),
            },
        )
    }

    fn prepaint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        frame_state: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Hitbox> {
        let style = self
            .interactivity
            .compute_style(global_id, None, window, cx);
        let border = style.border_widths.to_pixels(window.rem_size());
        let padding = style
            .padding
            .to_pixels(bounds.size.into(), window.rem_size());

        let padded_bounds = Bounds::from_corners(
            bounds.origin + point(border.left + padding.left, border.top + padding.top),
            bounds.bottom_right()
                - point(border.right + padding.right, border.bottom + padding.bottom),
        );

        let can_scroll_horizontally = matches!(
            self.horizontal_sizing_behavior,
            ListHorizontalSizingBehavior::Unconstrained
        );

        let longest_item_size = self.measure_item(None, window, cx);
        let content_width = if can_scroll_horizontally {
            padded_bounds.size.width.max(longest_item_size.width)
        } else {
            padded_bounds.size.width
        };
        let content_size = Size {
            width: content_width,
            height: longest_item_size.height * self.item_count,
        };

        let shared_scroll_offset = self.interactivity.scroll_offset.clone().unwrap();
        let item_height = longest_item_size.height;
        let shared_scroll_to_item = self.scroll_handle.as_mut().and_then(|handle| {
            let mut handle = handle.0.borrow_mut();
            handle.last_item_size = Some(ItemSize {
                item: padded_bounds.size,
                contents: content_size,
            });
            handle.deferred_scroll_to_item.take()
        });

        self.interactivity.prepaint(
            global_id,
            inspector_id,
            bounds,
            content_size,
            window,
            cx,
            |_style, mut scroll_offset, hitbox, window, cx| {
                let y_flipped = if let Some(scroll_handle) = &self.scroll_handle {
                    let scroll_state = scroll_handle.0.borrow();
                    scroll_state.y_flipped
                } else {
                    false
                };

                if self.item_count > 0 {
                    let content_height = item_height * self.item_count;

                    let is_scrolled_vertically = !scroll_offset.y.is_zero();
                    let max_scroll_offset = padded_bounds.size.height - content_height;

                    if is_scrolled_vertically && scroll_offset.y < max_scroll_offset {
                        shared_scroll_offset.borrow_mut().y = max_scroll_offset;
                        scroll_offset.y = max_scroll_offset;
                    }

                    let content_width = content_size.width + padding.left + padding.right;
                    let is_scrolled_horizontally =
                        can_scroll_horizontally && !scroll_offset.x.is_zero();
                    if is_scrolled_horizontally && content_width <= padded_bounds.size.width {
                        shared_scroll_offset.borrow_mut().x = Pixels::ZERO;
                        scroll_offset.x = Pixels::ZERO;
                    }

                    if let Some(DeferredScrollToItem {
                        mut item_index,
                        mut strategy,
                        offset,
                        scroll_strict,
                    }) = shared_scroll_to_item
                    {
                        if y_flipped {
                            item_index =
                                self.item_count.saturating_sub(item_index.saturating_add(1));
                        }
                        let list_height = padded_bounds.size.height;
                        let mut updated_scroll_offset = shared_scroll_offset.borrow_mut();
                        let item_top = item_height * item_index;
                        let item_bottom = item_top + item_height;
                        let scroll_top = -updated_scroll_offset.y;
                        let offset_pixels = item_height * offset;

                        // is the selected item above/below currently visible items
                        let is_above = item_top < scroll_top + offset_pixels;
                        let is_below = item_bottom > scroll_top + list_height;

                        if scroll_strict || is_above || is_below {
                            if strategy == ScrollStrategy::Nearest {
                                if is_above {
                                    strategy = ScrollStrategy::Top;
                                } else if is_below {
                                    strategy = ScrollStrategy::Bottom;
                                }
                            }

                            let max_scroll_offset =
                                (content_height - list_height).max(Pixels::ZERO);
                            match strategy {
                                ScrollStrategy::Top => {
                                    updated_scroll_offset.y = -(item_top - offset_pixels)
                                        .clamp(Pixels::ZERO, max_scroll_offset);
                                }
                                ScrollStrategy::Center => {
                                    let item_center = item_top + item_height / 2.0;

                                    let viewport_height = list_height - offset_pixels;
                                    let viewport_center = offset_pixels + viewport_height / 2.0;
                                    let target_scroll_top = item_center - viewport_center;
                                    updated_scroll_offset.y =
                                        -target_scroll_top.clamp(Pixels::ZERO, max_scroll_offset);
                                }
                                ScrollStrategy::Bottom => {
                                    updated_scroll_offset.y = -(item_bottom - list_height)
                                        .clamp(Pixels::ZERO, max_scroll_offset);
                                }
                                ScrollStrategy::Nearest => {
                                    // Nearest, but the item is visible -> no scroll is required
                                }
                            }
                        }
                        scroll_offset = *updated_scroll_offset
                    }

                    let first_visible_element_ix =
                        (-(scroll_offset.y + padding.top) / item_height).floor() as usize;
                    let last_visible_element_ix = ((-scroll_offset.y + padded_bounds.size.height)
                        / item_height)
                        .ceil() as usize;

                    let visible_range = first_visible_element_ix
                        ..cmp::min(last_visible_element_ix, self.item_count);

                    let items = if y_flipped {
                        let flipped_range = self.item_count.saturating_sub(visible_range.end)
                            ..self.item_count.saturating_sub(visible_range.start);
                        let mut items = (self.render_items)(flipped_range, window, cx);
                        items.reverse();
                        items
                    } else {
                        (self.render_items)(visible_range.clone(), window, cx)
                    };

                    window.with_content_mask(
                        Some(style.scroll_mask(bounds, window.rem_size())),
                        |window| {
                            for (mut item, ix) in items.into_iter().zip(visible_range.clone()) {
                                let item_origin = padded_bounds.origin
                                    + scroll_offset
                                    + point(Pixels::ZERO, item_height * ix);

                                let available_width = if can_scroll_horizontally {
                                    padded_bounds.size.width + scroll_offset.x.abs()
                                } else {
                                    padded_bounds.size.width
                                };
                                let available_space = size(
                                    AvailableSpace::Definite(available_width),
                                    AvailableSpace::Definite(item_height),
                                );
                                item.layout_as_root(available_space, window, cx);
                                item.prepaint_at(item_origin, window, cx);
                                frame_state.items.push(item);
                            }

                            let bounds = Bounds::new(
                                padded_bounds.origin + scroll_offset,
                                padded_bounds.size,
                            );
                            for decoration in &self.decorations {
                                let mut decoration = decoration.as_ref().compute(
                                    visible_range.clone(),
                                    bounds,
                                    scroll_offset,
                                    item_height,
                                    self.item_count,
                                    window,
                                    cx,
                                );
                                let available_space = size(
                                    AvailableSpace::Definite(bounds.size.width),
                                    AvailableSpace::Definite(bounds.size.height),
                                );
                                decoration.layout_as_root(available_space, window, cx);
                                decoration.prepaint_at(bounds.origin, window, cx);
                                frame_state.decorations.push(decoration);
                            }
                        },
                    );
                }

                hitbox
            },
        )
    }

    fn paint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<crate::Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        hitbox: &mut Option<Hitbox>,
        window: &mut Window,
        cx: &mut App,
    ) {
        self.interactivity.paint(
            global_id,
            inspector_id,
            bounds,
            hitbox.as_ref(),
            window,
            cx,
            |_, window, cx| {
                for item in &mut request_layout.items {
                    item.paint(window, cx);
                }
                for decoration in &mut request_layout.decorations {
                    decoration.paint(window, cx);
                }
            },
        )
    }
}

impl IntoElement for UniformList {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

/// An element painted over a uniform list's rows, such as an indentation guide.
///
/// Attach it with [`UniformList::with_decoration`]. Decorations are laid out
/// and prepainted after the visible rows, inside the list's scroll mask, then
/// painted in registration order. They do not contribute to row measurement
/// or the scroll extent. An empty list does not compute decorations.
pub trait UniformListDecoration {
    /// Builds the decoration during list prepaint using this frame's geometry.
    ///
    /// `bounds` has the viewport's size but its origin already includes
    /// `scroll_offset`, in logical window coordinates. The returned element
    /// is laid out with that size available and prepainted at that origin.
    /// Do not add the scroll offset a second time.
    ///
    /// `visible_range` indexes physical row slots, including partially visible
    /// rows. With reversed row order, logical indices instead occupy
    /// `item_count - visible_range.end .. item_count - visible_range.start`.
    /// `item_height` is the shared measured height, and `item_count` is the
    /// full collection size, not the number of constructed rows.
    fn compute(
        &self,
        visible_range: Range<usize>,
        bounds: Bounds<Pixels>,
        scroll_offset: Point<Pixels>,
        item_height: Pixels,
        item_count: usize,
        window: &mut Window,
        cx: &mut App,
    ) -> AnyElement;
}

impl<T: UniformListDecoration + 'static> UniformListDecoration for Entity<T> {
    fn compute(
        &self,
        visible_range: Range<usize>,
        bounds: Bounds<Pixels>,
        scroll_offset: Point<Pixels>,
        item_height: Pixels,
        item_count: usize,
        window: &mut Window,
        cx: &mut App,
    ) -> AnyElement {
        self.update(cx, |inner, cx| {
            inner.compute(
                visible_range,
                bounds,
                scroll_offset,
                item_height,
                item_count,
                window,
                cx,
            )
        })
    }
}

impl UniformList {
    /// Chooses the representative item used to measure both row height and content width.
    ///
    /// Choose the widest row for horizontally scrollable content; the list does
    /// not scan every row for a maximum. `None` selects index zero, and an
    /// out-of-range index is clamped to the last item. All rows must still share
    /// the measured height.
    pub fn with_width_from_item(mut self, item_index: Option<usize>) -> Self {
        self.item_to_measure_index = item_index.unwrap_or(0);
        self
    }

    /// Chooses between style-based sizing and an inferred content size.
    ///
    /// [`ListSizingBehavior::Auto`] (the default) leaves sizing to the style
    /// and parent layout. [`ListSizingBehavior::Infer`] uses the representative
    /// row's height times the item count, capped by definite available height.
    /// It fills definite available width or uses the representative row's
    /// intrinsic width. Parent constraints and explicit dimensions still apply.
    ///
    /// Inferring size without a finite parent constraint can make the viewport
    /// as tall as the collection. Prefer explicit viewport dimensions for a
    /// large scrolling list.
    pub fn with_sizing_behavior(mut self, behavior: ListSizingBehavior) -> Self {
        self.sizing_behavior = behavior;
        self
    }

    /// Chooses whether row content fits the viewport or can scroll horizontally.
    ///
    /// [`ListHorizontalSizingBehavior::Unconstrained`] enables horizontal
    /// overflow using the representative row's measured width. Select that row
    /// with [`with_width_from_item`](Self::with_width_from_item); wider unmeasured
    /// rows do not automatically enlarge the scrollable width.
    pub fn with_horizontal_sizing_behavior(
        mut self,
        behavior: ListHorizontalSizingBehavior,
    ) -> Self {
        self.horizontal_sizing_behavior = behavior;
        match behavior {
            ListHorizontalSizingBehavior::FitList => {
                self.interactivity.base_style.overflow.x = None;
            }
            ListHorizontalSizingBehavior::Unconstrained => {
                self.interactivity.base_style.overflow.x = Some(Overflow::Scroll);
            }
        }
        self
    }

    /// Appends an overlay computed after the visible rows during prepaint.
    ///
    /// Decorations paint over rows in registration order, share the list's
    /// scroll mask, and do not enlarge its content. See
    /// [`UniformListDecoration::compute`] for coordinate and row-index rules.
    pub fn with_decoration(mut self, decoration: impl UniformListDecoration + 'static) -> Self {
        self.decorations.push(Box::new(decoration));
        self
    }

    fn measure_item(
        &self,
        list_width: Option<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Size<Pixels> {
        if self.item_count == 0 {
            return Size::default();
        }

        let item_ix = cmp::min(self.item_to_measure_index, self.item_count - 1);
        let mut items = (self.render_items)(item_ix..item_ix + 1, window, cx);
        let Some(mut item_to_measure) = items.pop() else {
            return Size::default();
        };
        let available_space = size(
            list_width.map_or(AvailableSpace::MaxContent, |width| {
                AvailableSpace::Definite(width)
            }),
            AvailableSpace::MinContent,
        );
        item_to_measure.layout_as_root(available_space, window, cx)
    }

    /// Binds the list to a retained scroll handle for this render.
    ///
    /// The handle receives measured geometry and lets other controls queue
    /// scroll requests. Reuse the same handle across frames; bind separate
    /// handles for independent lists.
    // docs:examples:begin
    #[doc = include_str!("../docs/examples/gpui-UniformList-track-scroll-47552143.md")]
    // docs:examples:end
    pub fn track_scroll(mut self, handle: &UniformListScrollHandle) -> Self {
        self.interactivity.tracked_scroll_handle = Some(handle.0.borrow().base_handle.clone());
        self.scroll_handle = Some(handle.clone());
        self
    }

    /// Reverses visual row order, placing item zero at the bottom.
    ///
    /// This uses the tracked handle's state, so call
    /// [`track_scroll`](Self::track_scroll) first. Without a handle it has no
    /// effect. Changing the direction adjusts the current offset using the
    /// last measured content size.
    pub fn y_flipped(mut self, y_flipped: bool) -> Self {
        if let Some(ref scroll_handle) = self.scroll_handle {
            let mut scroll_state = scroll_handle.0.borrow_mut();
            let mut base_handle = &scroll_state.base_handle;
            let offset = base_handle.offset();
            match scroll_state.last_item_size {
                Some(last_size) if scroll_state.y_flipped != y_flipped => {
                    let new_y_offset =
                        -(offset.y + last_size.contents.height - last_size.item.height);
                    base_handle.set_offset(point(offset.x, new_y_offset));
                    scroll_state.y_flipped = y_flipped;
                }
                // Handle case where list is initially flipped.
                None if y_flipped => {
                    base_handle.set_offset(point(offset.x, Pixels::MIN));
                    scroll_state.y_flipped = y_flipped;
                }
                _ => {}
            }
        }
        self
    }
}

impl InteractiveElement for UniformList {
    fn interactivity(&mut self) -> &mut crate::Interactivity {
        &mut self.interactivity
    }
}

#[cfg(test)]
mod test {
    use crate::TestAppContext;

    #[gpui::test]
    fn flipped_end_request_does_not_overflow(cx: &mut TestAppContext) {
        use crate::{
            AppContext as _, Context, IntoElement, Render, Styled, UniformListScrollHandle, Window,
            div, px, size, uniform_list,
        };

        struct FlippedRows(UniformListScrollHandle);
        impl Render for FlippedRows {
            fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
                uniform_list("rows", 47, |range, _, _| {
                    range.map(|_| div().h(px(20.))).collect()
                })
                .track_scroll(&self.0)
                .y_flipped(true)
                .size_full()
            }
        }

        let handle = UniformListScrollHandle::new();
        let window = cx.open_window(size(px(200.), px(200.)), |_, _| FlippedRows(handle.clone()));
        let mut draw = || {
            cx.update_window(window.into(), |_, window, cx| window.draw(cx).clear(cx))
                .unwrap();
        };
        draw();
        assert!(handle.0.borrow().base_handle.offset().y < px(0.));
        handle.scroll_to_bottom();
        draw();
        assert_eq!(handle.0.borrow().base_handle.offset().y, px(0.));
        assert!(handle.0.borrow().deferred_scroll_to_item.is_none());
    }

    #[gpui::test]
    fn test_scroll_strategy_nearest(cx: &mut TestAppContext) {
        use crate::{
            Context, FocusHandle, ScrollStrategy, UniformListScrollHandle, Window, div, prelude::*,
            px, uniform_list,
        };
        use std::ops::Range;

        actions!(example, [SelectNext, SelectPrev]);

        struct TestView {
            index: usize,
            length: usize,
            scroll_handle: UniformListScrollHandle,
            focus_handle: FocusHandle,
            visible_range: Range<usize>,
        }

        impl TestView {
            pub fn select_next(
                &mut self,
                _: &SelectNext,
                window: &mut Window,
                _: &mut Context<Self>,
            ) {
                if self.index + 1 == self.length {
                    self.index = 0
                } else {
                    self.index += 1;
                }
                self.scroll_handle
                    .scroll_to_item(self.index, ScrollStrategy::Nearest);
                window.refresh();
            }

            pub fn select_previous(
                &mut self,
                _: &SelectPrev,
                window: &mut Window,
                _: &mut Context<Self>,
            ) {
                if self.index == 0 {
                    self.index = self.length - 1
                } else {
                    self.index -= 1;
                }
                self.scroll_handle
                    .scroll_to_item(self.index, ScrollStrategy::Nearest);
                window.refresh();
            }
        }

        impl Render for TestView {
            fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
                div()
                    .id("list-example")
                    .track_focus(&self.focus_handle)
                    .on_action(cx.listener(Self::select_next))
                    .on_action(cx.listener(Self::select_previous))
                    .size_full()
                    .child(
                        uniform_list(
                            "entries",
                            self.length,
                            cx.processor(|this, range: Range<usize>, _window, _cx| {
                                this.visible_range = range.clone();
                                range
                                    .map(|ix| div().id(ix).h(px(20.0)).child(format!("Item {ix}")))
                                    .collect()
                            }),
                        )
                        .track_scroll(&self.scroll_handle)
                        .h(px(200.0)),
                    )
            }
        }

        let (view, cx) = cx.add_window_view(|window, cx| {
            let focus_handle = cx.focus_handle();
            window.focus(&focus_handle, cx);
            TestView {
                scroll_handle: UniformListScrollHandle::new(),
                index: 0,
                focus_handle,
                length: 47,
                visible_range: 0..0,
            }
        });

        // 10 out of 47 items are visible

        // First 9 times selecting next item does not scroll
        for ix in 1..10 {
            cx.dispatch_action(SelectNext);
            view.read_with(cx, |view, _| {
                assert_eq!(view.index, ix);
                assert_eq!(view.visible_range, 0..10);
            })
        }

        // Now each time the list scrolls down by 1
        for ix in 10..47 {
            cx.dispatch_action(SelectNext);
            view.read_with(cx, |view, _| {
                assert_eq!(view.index, ix);
                assert_eq!(view.visible_range, ix - 9..ix + 1);
            })
        }

        // After the last item we move back to the start
        cx.dispatch_action(SelectNext);
        view.read_with(cx, |view, _| {
            assert_eq!(view.index, 0);
            assert_eq!(view.visible_range, 0..10);
        });

        // Return to the last element
        cx.dispatch_action(SelectPrev);
        view.read_with(cx, |view, _| {
            assert_eq!(view.index, 46);
            assert_eq!(view.visible_range, 37..47);
        });

        // First 9 times selecting previous does not scroll
        for ix in (37..46).rev() {
            cx.dispatch_action(SelectPrev);
            view.read_with(cx, |view, _| {
                assert_eq!(view.index, ix);
                assert_eq!(view.visible_range, 37..47);
            })
        }

        // Now each time the list scrolls up by 1
        for ix in (0..37).rev() {
            cx.dispatch_action(SelectPrev);
            view.read_with(cx, |view, _| {
                assert_eq!(view.index, ix);
                assert_eq!(view.visible_range, ix..ix + 10);
            })
        }
    }
}
