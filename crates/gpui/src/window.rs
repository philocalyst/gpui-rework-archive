use crate::{
    Action, AnyDrag, AnyElement, AnyImageCache, AnyTooltip, AnyView, App, AppContext, Arena, Asset,
    AsyncWindowContext, AtlasTile, AvailableSpace, BackdropFilter, Background, BorderStyle, Bounds,
    BoxShadow, Capslock, ColorExt, Context, Corners, CursorHideMode, CursorStyle, Decorations,
    DevicePixels, DispatchActionListener, DispatchNodeId, DispatchTree, DisplayId, Edges, Effect,
    Entity, EntityId, EventEmitter, FileDropEvent, Filter, FilterBoundary, FontId, Global,
    GlobalElementId, GlyphId, GlyphRenderMode, GpuSpecs, InputHandler, IntoElement, IsZero,
    KeyBinding, KeyContext, KeyDownEvent, KeyEvent, Keystroke, KeystrokeEvent, LayoutId, Lerp,
    LineLayoutIndex, Modifiers, ModifiersChangedEvent, MonochromeSprite, Motion, MouseButton,
    MouseEvent, MouseMoveEvent, MouseUpEvent, Path, Pixels, PlatformAtlas, PlatformDisplay,
    PlatformInput, PlatformInputHandler, PlatformWindow, Point, PolychromeSprite, Priority,
    PromptButton, PromptLevel, Quad, RasterizedGlyphFormat, Render, RenderGlyphParams, RenderImage,
    RenderImageParams, RenderSvgParams, Replay, ResizeEdge, ResolvedDirection,
    SMOOTH_SVG_SCALE_FACTOR, SUBPIXEL_VARIANTS_X, SUBPIXEL_VARIANTS_Y, ScaledFilter, ScaledPixels,
    Scene, Shadow, SharedString, Size, StrikethroughStyle, Style, SubpixelSprite, SubscriberSet,
    Subscription, SystemWindowTab, SystemWindowTabController, TabStopMap, TaffyLayoutEngine, Task,
    TextInputConfiguration, TextInputStateChange, TextRenderingMode, TextStyle,
    TextStyleRefinement, ThermalState, TransformationMatrix, Transition, TransitionState,
    Underline, UnderlineStyle, UnicodeBidi, WindowAppearance, WindowBackgroundAppearance,
    WindowBounds, WindowControls, WindowDecorations, WindowOptions, WindowParams, WindowTextSystem,
    gestures::{GestureTuning, RecognizedTouchGesture, TouchGestureRecognizer},
    interactive::TouchEvent,
    point, px, rems, size, transparent_black,
    util::{
        atomic_incr_if_not_zero, ceil_to_device_pixel, floor_to_device_pixel,
        round_half_toward_zero, round_half_toward_zero_f64, round_stroke_to_device_pixel,
        round_to_device_pixel,
    },
    white,
};
use anyhow::{Context as _, Result, anyhow};
use collections::{FxHashMap, FxHashSet};
use derive_more::{Deref, DerefMut};
use futures::FutureExt;
use futures::channel::oneshot;
use gpui_util::post_inc;
use gpui_util::{ResultExt, measure};
use itertools::FoldWhile::{Continue, Done};
use itertools::Itertools;
use palette::Hsla;
use parking_lot::RwLock;
use raw_window_handle::{HandleError, HasDisplayHandle, HasWindowHandle};
use refineable::Refineable;
use scheduler::Instant;
use serde::{Deserialize, Serialize};
use slotmap::SlotMap;
use smallvec::SmallVec;
use std::{
    any::{Any, TypeId},
    borrow::Cow,
    cell::{Cell, RefCell},
    cmp,
    collections::HashMap,
    fmt::{Debug, Display},
    hash::{Hash, Hasher},
    marker::PhantomData,
    mem,
    ops::{DerefMut, Range},
    rc::Rc,
    sync::{
        Arc, Weak,
        atomic::{AtomicBool, AtomicUsize, Ordering::SeqCst},
    },
    time::Duration,
};
use uuid::Uuid;

#[cfg(not(target_family = "wasm"))]
use self::a11y::ROOT_NODE_ID;
#[cfg(feature = "profiler")]
use crate::DebugFrameOverlayMode;
#[cfg(any(feature = "inspector", debug_assertions))]
use crate::Inspector;
#[cfg(feature = "profiler")]
use crate::profiler;

pub(crate) mod a11y;
mod prompts;

use a11y::A11y;
pub use a11y::A11ySubtreeBuilder;
pub use prompts::*;

fn quantize_glyph_origin(origin: Point<ScaledPixels>) -> (Point<ScaledPixels>, Point<u8>) {
    fn axis(value: ScaledPixels, variants: u8) -> (ScaledPixels, u8) {
        let quantized = round_half_toward_zero(value.0 * variants as f32) / variants as f32;
        let integer = quantized.floor();
        let variant = ((quantized - integer) * variants as f32).round() as u8;
        (ScaledPixels(integer), variant.min(variants - 1))
    }

    let (integer_x, variant_x) = axis(origin.x, SUBPIXEL_VARIANTS_X);
    let (integer_y, variant_y) = axis(origin.y, SUBPIXEL_VARIANTS_Y);
    (point(integer_x, integer_y), point(variant_x, variant_y))
}

fn quantize_color_glyph_origin(origin: Point<ScaledPixels>) -> (Point<ScaledPixels>, Point<u8>) {
    (
        origin.map(|coordinate| ScaledPixels(round_half_toward_zero(coordinate.0))),
        Point::default(),
    )
}

/// Default content size used when no explicit window size is provided.
pub const DEFAULT_WINDOW_SIZE: Size<Pixels> = size(px(1536.), px(1095.));

/// Default minimum size for auxiliary windows such as settings and rules-library windows.
pub const DEFAULT_ADDITIONAL_WINDOW_SIZE: Size<Pixels> = Size {
    width: Pixels(900.),
    height: Pixels(750.),
};

/// Phase in which an input listener runs.
///
/// Pointer listeners capture in paint order, from back to front, and bubble in
/// reverse order. Their callbacks decide eligibility using hitboxes; low-level
/// listeners can also observe input outside their region. Keyboard and action
/// listeners capture along the root-to-focus path and bubble back toward the root.
#[derive(Default, Copy, Clone, Debug, Eq, PartialEq)]
pub enum DispatchPhase {
    /// The second phase: pointer listeners run front to back, while keyboard
    /// and action listeners run from the focused node toward the root.
    /// Ordinary element handlers usually handle this phase.
    #[default]
    Bubble,
    /// The first phase: pointer listeners run back to front, while keyboard
    /// and action listeners run from the root toward the focused node.
    ///
    /// Outside-click detection and clearing pressed state can depend on seeing
    /// input here. Stopping propagation also prevents the later bubble phase.
    Capture,
}

impl DispatchPhase {
    /// Returns true if this represents the "bubble" phase.
    #[inline]
    pub fn bubble(self) -> bool {
        self == DispatchPhase::Bubble
    }

    /// Returns true if this represents the "capture" phase.
    #[inline]
    pub fn capture(self) -> bool {
        self == DispatchPhase::Capture
    }
}

struct WindowInvalidatorInner {
    #[cfg(feature = "profiler")]
    pub window_id: WindowId,
    pub dirty: bool,
    pub draw_phase: DrawPhase,
    pub dirty_views: FxHashSet<EntityId>,
    pub update_count: usize,
    #[cfg(feature = "profiler")]
    pub frame_dirty: FrameDirtyAccumulator,
    pub platform_waker: Option<Rc<dyn Fn()>>,
}

/// Per-frame invalidation bookkeeping, drained at draw time and emitted to the
/// frame profiler. Tracks when the current frame first became dirty and how
/// many invalidations were coalesced into it, whenever the profiler is
/// compiled in. Retention of the resulting per-frame records is what
/// `profiler::trace_enabled()` controls, not this measurement.
#[cfg(feature = "profiler")]
#[derive(Default)]
struct FrameDirtyAccumulator {
    dirty_at: Option<Instant>,
    invalidations: u64,
}

#[derive(Clone)]
pub(crate) struct WindowInvalidator {
    inner: Rc<RefCell<WindowInvalidatorInner>>,
}

impl WindowInvalidator {
    pub fn new(#[allow(unused_variables)] window_id: WindowId) -> Self {
        WindowInvalidator {
            inner: Rc::new(RefCell::new(WindowInvalidatorInner {
                #[cfg(feature = "profiler")]
                window_id,
                dirty: true,
                draw_phase: DrawPhase::None,
                dirty_views: FxHashSet::default(),
                update_count: 0,
                #[cfg(feature = "profiler")]
                frame_dirty: FrameDirtyAccumulator::default(),
                platform_waker: None,
            })),
        }
    }

    pub fn invalidate_view(&self, entity: EntityId, cx: &mut App) -> bool {
        let mut inner = self.inner.borrow_mut();
        inner.update_count += 1;
        inner.dirty_views.insert(entity);
        if inner.draw_phase == DrawPhase::None {
            #[cfg(feature = "profiler")]
            let dirty_at = Self::record_frame_dirty(&mut inner);
            let became_dirty = !inner.dirty;
            inner.dirty = true;
            let waker = became_dirty.then(|| inner.platform_waker.clone()).flatten();
            #[cfg(feature = "profiler")]
            let window_id = inner.window_id;
            drop(inner);
            #[cfg(feature = "profiler")]
            if became_dirty {
                profiler::journal::record_frame_pending(window_id, dirty_at);
            }
            cx.push_effect(Effect::Notify { emitter: entity });
            if let Some(waker) = waker {
                waker();
            }
            true
        } else {
            false
        }
    }

    pub fn is_dirty(&self) -> bool {
        self.inner.borrow().dirty
    }

    pub fn set_dirty(&self, dirty: bool) {
        let mut inner = self.inner.borrow_mut();
        let became_dirty = dirty && !inner.dirty;
        inner.dirty = dirty;
        if dirty {
            inner.update_count += 1;
        }
        #[cfg(feature = "profiler")]
        let dirty_at = dirty.then(|| Self::record_frame_dirty(&mut inner));
        let waker = became_dirty.then(|| inner.platform_waker.clone()).flatten();
        #[cfg(feature = "profiler")]
        let window_id = inner.window_id;
        drop(inner);
        #[cfg(feature = "profiler")]
        if became_dirty && let Some(dirty_at) = dirty_at {
            profiler::journal::record_frame_pending(window_id, dirty_at);
        }
        if let Some(waker) = waker {
            waker();
        }
    }

    pub fn set_platform_waker(&self, waker: Option<Rc<dyn Fn()>>) {
        let mut inner = self.inner.borrow_mut();
        inner.platform_waker = waker;
        let waker = inner.dirty.then(|| inner.platform_waker.clone()).flatten();
        drop(inner);
        if let Some(waker) = waker {
            waker();
        }
    }

    /// Wakes the platform's frame-request source so a frame request is
    /// delivered even if the platform stops requesting frames for idle
    /// windows. No-op on platforms without a frame waker.
    pub fn wake_platform(&self) {
        let waker = self.inner.borrow().platform_waker.clone();
        if let Some(waker) = waker {
            waker();
        }
    }

    pub fn set_phase(&self, phase: DrawPhase) {
        self.inner.borrow_mut().draw_phase = phase
    }

    pub fn update_count(&self) -> usize {
        self.inner.borrow().update_count
    }

    #[cfg(feature = "profiler")]
    fn record_frame_dirty(inner: &mut WindowInvalidatorInner) -> Instant {
        let dirty_at = *inner.frame_dirty.dirty_at.get_or_insert_with(Instant::now);
        inner.frame_dirty.invalidations += 1;
        dirty_at
    }

    #[cfg(feature = "profiler")]
    fn take_frame_dirty(&self) -> FrameDirtyAccumulator {
        mem::take(&mut self.inner.borrow_mut().frame_dirty)
    }

    pub fn take_views(&self) -> FxHashSet<EntityId> {
        mem::take(&mut self.inner.borrow_mut().dirty_views)
    }

    pub fn replace_views(&self, views: FxHashSet<EntityId>) {
        self.inner.borrow_mut().dirty_views = views;
    }

    pub fn not_drawing(&self) -> bool {
        self.inner.borrow().draw_phase == DrawPhase::None
    }

    #[track_caller]
    pub fn debug_assert_paint(&self) {
        debug_assert!(
            matches!(self.inner.borrow().draw_phase, DrawPhase::Paint),
            "this method can only be called during paint"
        );
    }

    #[track_caller]
    pub fn debug_assert_prepaint(&self) {
        debug_assert!(
            matches!(self.inner.borrow().draw_phase, DrawPhase::Prepaint),
            "this method can only be called during request_layout, or prepaint"
        );
    }

    #[track_caller]
    pub fn debug_assert_paint_or_prepaint(&self) {
        debug_assert!(
            matches!(
                self.inner.borrow().draw_phase,
                DrawPhase::Paint | DrawPhase::Prepaint
            ),
            "this method can only be called during request_layout, prepaint, or paint"
        );
    }
}

type AnyObserver = Box<dyn FnMut(&mut Window, &mut App) -> bool + 'static>;

pub(crate) type AnyWindowFocusListener =
    Box<dyn FnMut(&WindowFocusEvent, &mut Window, &mut App) -> bool + 'static>;

pub(crate) struct WindowFocusEvent {
    pub(crate) previous_focus_path: SmallVec<[FocusId; 8]>,
    pub(crate) current_focus_path: SmallVec<[FocusId; 8]>,
}

impl WindowFocusEvent {
    pub fn is_focus_in(&self, focus_id: FocusId) -> bool {
        !self.previous_focus_path.contains(&focus_id) && self.current_focus_path.contains(&focus_id)
    }

    pub fn is_focus_out(&self, focus_id: FocusId) -> bool {
        self.previous_focus_path.contains(&focus_id) && !self.current_focus_path.contains(&focus_id)
    }
}

/// A focus change that left a watched subtree.
///
/// Provided to [`Context::on_focus_out`] and [`Window::on_focus_out`]. Moving
/// between descendants of that subtree does not produce this event.
pub struct FocusOutEvent {
    /// A weak focus handle representing what was blurred.
    pub blurred: WeakFocusHandle,
}

slotmap::new_key_type! {
    /// A focus identity allocated within one app.
    pub struct FocusId;
}

thread_local! {
    /// Fallback arena used when no app-specific arena is active.
    /// In production, each window draw sets CURRENT_ELEMENT_ARENA to the app's arena.
    pub(crate) static ELEMENT_ARENA: RefCell<Arena> = RefCell::new(Arena::new(1024 * 1024));

    /// Points to the current App's element arena during draw operations.
    /// This allows multiple test Apps to have isolated arenas, preventing
    /// cross-session corruption when the scheduler interleaves their tasks.
    static CURRENT_ELEMENT_ARENA: Cell<Option<*const RefCell<Arena>>> = const { Cell::new(None) };
}

/// Whether a window draw is currently in progress on this thread.
///
/// This holds exactly while an `ElementArenaScope` is active: nested scopes
/// restore the previous (still set) arena pointer, so `CURRENT_ELEMENT_ARENA`
/// is `Some` from the outermost draw's start to its end.
///
/// The `on_request_frame` callback uses this to defer draw requests that
/// arrive re-entrantly while a draw is already on the stack (e.g. via nested
/// message pumping in the Windows window procedure), instead of running a
/// nested draw or panicking on the already-borrowed App.
fn draw_in_progress() -> bool {
    CURRENT_ELEMENT_ARENA.with(|current| current.get().is_some())
}

/// Allocates an element in the current arena. Uses the app-specific arena if one
/// is active (during draw), otherwise falls back to the thread-local ELEMENT_ARENA.
pub(crate) fn with_element_arena<R>(f: impl FnOnce(&mut Arena) -> R) -> R {
    CURRENT_ELEMENT_ARENA.with(|current| {
        if let Some(arena_ptr) = current.get() {
            // SAFETY: The pointer is valid for the duration of the draw operation
            // that set it, and we're being called during that same draw.
            let arena_cell = unsafe { &*arena_ptr };
            f(&mut arena_cell.borrow_mut())
        } else {
            ELEMENT_ARENA.with_borrow_mut(f)
        }
    })
}

/// Scope guard that sets CURRENT_ELEMENT_ARENA for the duration of a draw
/// operation and tracks the arena's scope depth, so that a nested draw's
/// `ArenaClearNeeded::clear` is deferred rather than freeing memory the outer
/// draw still references (see `Arena::clear`).
///
/// Call [`ElementArenaScope::exit`] with the same arena that was entered to
/// obtain the [`ArenaClearNeeded`] token the draw now owes; requiring `exit`
/// makes it impossible to request a clear before the scope has ended. The
/// scope's teardown — restoring the thread-local and balancing `begin_scope`
/// with `end_scope` — happens in `Drop`, so the arena's scope depth stays
/// balanced on every path, including when a panic unwinds a draw before `exit`
/// is reached. (If teardown lived only in `exit`, such a panic would leave the
/// scope depth permanently elevated and defer every future clear, leaking
/// memory unboundedly.)
pub(crate) struct ElementArenaScope {
    /// The entered arena: compared against the argument in `exit`, and
    /// dereferenced in `Drop` to end its scope (see the SAFETY note there).
    entered: *const RefCell<Arena>,
    previous: Option<*const RefCell<Arena>>,
    exited: bool,
}

impl ElementArenaScope {
    /// Enter a scope where element allocations use the given arena.
    pub(crate) fn enter(arena: &RefCell<Arena>) -> Self {
        arena.borrow_mut().begin_scope();
        let previous = CURRENT_ELEMENT_ARENA.with(|current| {
            let prev = current.get();
            current.set(Some(arena as *const RefCell<Arena>));
            prev
        });
        Self {
            entered: arena as *const RefCell<Arena>,
            previous,
            exited: false,
        }
    }

    /// End the scope: restores the previously-current arena and ends the
    /// arena's clear-deferral scope. Returns the token for the arena clear the
    /// draw now owes; producing it here makes it impossible to request a clear
    /// before the scope has ended (which would be silently deferred forever).
    ///
    /// Panics if passed a different arena than was entered: ending the scope
    /// of the wrong arena would unbalance two arenas' scope depths, allowing
    /// one of them to clear while a draw still references its memory.
    pub(crate) fn exit(mut self, arena: &RefCell<Arena>) -> ArenaClearNeeded {
        assert!(
            std::ptr::eq(self.entered, arena),
            "ElementArenaScope::exit called with a different arena than was entered"
        );
        self.exited = true;
        // Teardown (restoring the thread-local and ending the arena's
        // clear-deferral scope) runs in `Drop`, which fires both here — `self`
        // is dropped as `exit` returns, before the token reaches the caller —
        // and when a panic unwinds the draw before `exit` is reached.
        ArenaClearNeeded::new(arena)
    }
}

impl Drop for ElementArenaScope {
    fn drop(&mut self) {
        // Teardown lives here (rather than in `exit`) so it runs exactly once on
        // every path: `exit` consumes and drops the guard on the normal path,
        // and unwinding drops it on the panic path. Balancing `begin_scope` here
        // keeps the arena's scope depth correct even when a draw panics; if this
        // only happened in `exit`, a panic between `enter` and `exit` would leave
        // the depth elevated and defer every future clear.
        CURRENT_ELEMENT_ARENA.with(|current| {
            current.set(self.previous);
        });
        // SAFETY: `entered` came from a `&RefCell<Arena>` in `enter`, and the
        // arena (owned by the `App` being drawn) outlives this guard on both the
        // normal and unwinding paths, since the guard is a local of the draw.
        unsafe { &*self.entered }.borrow_mut().end_scope();
        if !self.exited && !std::thread::panicking() {
            debug_assert!(false, "ElementArenaScope dropped without calling exit()");
            log::error!(
                "ElementArenaScope dropped without calling exit(); \
                 the arena clear for this draw was never requested"
            );
        }
    }
}

/// Returned when the element arena has been used and so must be cleared before the next draw.
#[must_use]
pub struct ArenaClearNeeded {
    /// Identity of the arena that was drawn into. Only ever compared against
    /// another pointer in `clear`; never dereferenced.
    arena: *const RefCell<Arena>,
}

impl ArenaClearNeeded {
    /// Create a new ArenaClearNeeded token for the App whose arena was drawn
    /// into. Private: the only way to obtain one is [`ElementArenaScope::exit`].
    fn new(arena: &RefCell<Arena>) -> Self {
        Self {
            arena: arena as *const RefCell<Arena>,
        }
    }

    /// Clear the element arena of the App the draw ran against. If an enclosing
    /// draw is still in progress (this draw was nested inside it), the clear is
    /// deferred to the enclosing draw's own `ArenaClearNeeded` so that its live
    /// allocations aren't freed.
    ///
    /// Panics if passed a different App than the draw ran against, since
    /// clearing another App's arena could free memory its draws still
    /// reference.
    pub fn clear(self, cx: &mut App) {
        assert!(
            std::ptr::eq(self.arena, &cx.element_arena),
            "ArenaClearNeeded::clear called with a different App than the draw ran against"
        );
        cx.element_arena.borrow_mut().clear();
    }
}

pub(crate) type FocusMap = RwLock<SlotMap<FocusId, FocusRef>>;
pub(crate) struct FocusRef {
    pub(crate) ref_count: AtomicUsize,
    pub(crate) tab_index: isize,
    pub(crate) tab_stop: bool,
}

impl FocusId {
    /// Returns whether this ID is the window's selected GPUI focus target.
    ///
    /// This does not check whether the handle is alive or rendered, or whether
    /// the native window is active. Prefer [`FocusHandle::is_focused`] when
    /// holding a retained handle.
    pub fn is_focused(&self, window: &Window) -> bool {
        window.focus == Some(*self)
    }

    /// Returns whether this ID is focused or is an ancestor of the focused handle.
    ///
    /// See [`FocusHandle::contains_focused`] for the rendered-tree semantics.
    pub fn contains_focused(&self, window: &Window, cx: &App) -> bool {
        window
            .focused(cx)
            .is_some_and(|focused| self.contains(focused.id, window))
    }

    /// Returns whether this ID is focused or is below the focused handle.
    ///
    /// See [`FocusHandle::within_focused`] for the rendered-tree semantics.
    pub fn within_focused(&self, window: &Window, cx: &App) -> bool {
        let focused = window.focused(cx);
        focused.is_some_and(|focused| focused.id.contains(*self, window))
    }

    /// Obtains whether this handle contains the given handle in the most recently rendered frame.
    pub(crate) fn contains(&self, other: Self, window: &Window) -> bool {
        window
            .rendered_frame
            .dispatch_tree
            .focus_contains(*self, other)
    }
}

/// A retained identity that a rendered element can use for keyboard focus.
///
/// Create a handle with [`App::focus_handle`], store it on the view, and attach
/// it through [`track_focus`](crate::InteractiveElement::track_focus). Creating a
/// handle alone does not focus an element. Call [`Window::focus`] to select it.
/// Keyboard dispatch follows the path that rendered the focused handle;
/// visual selection and pointer hover are separate state.
/// Use the handle only with windows belonging to the app that created it.
///
/// Clones share the focus identity. Keep the handle stable across renders so
/// the window can relate the next dispatch path to the previous one.
/// Each keyboard target needs its own handle: attaching clones to two elements
/// in one window gives both the same identity, and lookup finds the last
/// registered node. A parent and child that need focus queries should each
/// track a separate handle.
/// [`is_focused`](Self::is_focused) reports the window's selected identity,
/// even while the native window is inactive. The subtree queries use the
/// last rendered dispatch tree; they do not inspect a view's stored children.
/// See the [input chapter](crate::_documentation::input) for focus ownership,
/// tab navigation, and action routing.
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-FocusHandle-4a40e532.md")]
// docs:examples:end
pub struct FocusHandle {
    pub(crate) id: FocusId,
    handles: Arc<FocusMap>,
    /// This copy's tab index, read from the shared configuration when cloned.
    ///
    /// Use [`tab_index`](Self::tab_index) to configure traversal. Assigning this
    /// field alone does not update the map used by clones or `track_focus`.
    pub tab_index: isize,
    /// This copy's tab-stop flag, read from the shared configuration when cloned.
    ///
    /// Use [`tab_stop`](Self::tab_stop) to configure traversal. Assigning this
    /// field alone does not update the map used by clones or `track_focus`.
    pub tab_stop: bool,
}

impl std::fmt::Debug for FocusHandle {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_fmt(format_args!("FocusHandle({:?})", self.id))
    }
}

impl FocusHandle {
    pub(crate) fn new(handles: &Arc<FocusMap>) -> Self {
        let id = handles.write().insert(FocusRef {
            ref_count: AtomicUsize::new(1),
            tab_index: 0,
            tab_stop: false,
        });

        Self {
            id,
            tab_index: 0,
            tab_stop: false,
            handles: handles.clone(),
        }
    }

    pub(crate) fn for_id(id: FocusId, handles: &Arc<FocusMap>) -> Option<Self> {
        let lock = handles.read();
        let focus = lock.get(id)?;
        if atomic_incr_if_not_zero(&focus.ref_count) == 0 {
            return None;
        }
        Some(Self {
            id,
            tab_index: focus.tab_index,
            tab_stop: focus.tab_stop,
            handles: handles.clone(),
        })
    }

    /// Sets the element's position in tab traversal and returns the handle.
    ///
    /// Lower indices sort first within a tab group. This updates the returned
    /// handle and shared map, which future clones and weak upgrades read.
    /// Already-held handles keep their public field values until replaced.
    /// Negative indices also participate; use [`Self::tab_stop`] to exclude
    /// a handle from traversal. Setting the index does not enable its tab stop.
    /// The window's recorded traversal order changes on its next paint, so
    /// request a redraw after changing a retained view's configuration.
    pub fn tab_index(mut self, index: isize) -> Self {
        self.tab_index = index;
        if let Some(focus) = self.handles.write().get_mut(self.id) {
            focus.tab_index = index;
        }
        self
    }

    /// Sets whether tab traversal may stop on this element and returns the handle.
    ///
    /// The default is `false`. A rendered handle with this set to `true` joins
    /// its tab group's order. This does not focus it. As with [`Self::tab_index`],
    /// the setting is shared with future clones and upgrades; existing copies
    /// keep their field values.
    /// Request a redraw to replace an already painted traversal order.
    /// This does not install a key binding; call [`Window::focus_next`] or
    /// [`Window::focus_prev`] from the application's traversal handler.
    pub fn tab_stop(mut self, tab_stop: bool) -> Self {
        self.tab_stop = tab_stop;
        if let Some(focus) = self.handles.write().get_mut(self.id) {
            focus.tab_stop = tab_stop;
        }
        self
    }

    /// Converts this handle into a weak reference that does not keep the focus entry alive.
    pub fn downgrade(&self) -> WeakFocusHandle {
        WeakFocusHandle {
            id: self.id,
            handles: Arc::downgrade(&self.handles),
        }
    }

    /// Requests focus for the element associated with this handle.
    ///
    /// Delegates to [`Window::focus`]. An accepted request changes the selected identity immediately;
    /// focus listeners compare rendered paths when the window next draws.
    /// This does not activate the native window.
    pub fn focus(&self, window: &mut Window, cx: &mut App) {
        window.focus(self, cx)
    }

    /// Returns whether this is the window's selected GPUI focus identity.
    ///
    /// The handle need not be rendered, and the native window need not be
    /// active. Use [`Window::is_window_active`] for native activation.
    pub fn is_focused(&self, window: &Window) -> bool {
        self.id.is_focused(window)
    }

    /// Returns whether this handle is focused or is an ancestor of the focused handle.
    ///
    /// Ancestry comes from the last rendered dispatch tree. This is useful for
    /// styling a panel while one of its controls has focus. Native window
    /// activation does not affect the result.
    /// The handle contains itself even without a rendered node. For distinct
    /// handles, both must appear on the same rendered ancestor path. See
    /// [`Self::contains`] to compare two handles without consulting focus.
    pub fn contains_focused(&self, window: &Window, cx: &App) -> bool {
        self.id.contains_focused(window, cx)
    }

    /// Returns whether this handle is focused or is below the focused handle.
    ///
    /// This reverses [`Self::contains_focused`]: it asks whether the focused
    /// subtree contains this handle, using the last rendered dispatch tree.
    /// For example, focusing a panel makes this true for its rendered search
    /// field. Focusing that field makes it false for the panel. A focused
    /// handle always lies within itself, including before it is rendered.
    pub fn within_focused(&self, window: &Window, cx: &mut App) -> bool {
        self.id.within_focused(window, cx)
    }

    /// Returns whether `other` is this handle or a descendant in the last rendered tree.
    ///
    /// A handle always contains itself, including before it is rendered.
    /// Distinct handles must both occur on the same rendered ancestor path.
    pub fn contains(&self, other: &Self, window: &Window) -> bool {
        self.id.contains(other.id, window)
    }

    /// Dispatches `action` to the element that rendered this handle in the last frame.
    ///
    /// Dispatch runs synchronously along that node's route, whether or not
    /// the handle is focused. If it has no node in that frame, the action is
    /// ignored. Use [`Window::dispatch_action`] for deferred dispatch to the
    /// window's current focus target, including root fallback.
    pub fn dispatch_action(&self, action: &dyn Action, window: &mut Window, cx: &mut App) {
        if let Some(node_id) = window
            .rendered_frame
            .dispatch_tree
            .focusable_node_id(self.id)
        {
            window.dispatch_action_on_node(node_id, action, cx)
        }
    }
}

impl Clone for FocusHandle {
    fn clone(&self) -> Self {
        Self::for_id(self.id, &self.handles).unwrap()
    }
}

impl PartialEq for FocusHandle {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id
    }
}

impl Eq for FocusHandle {}

impl Drop for FocusHandle {
    fn drop(&mut self) {
        self.handles
            .read()
            .get(self.id)
            .unwrap()
            .ref_count
            .fetch_sub(1, SeqCst);
    }
}

/// A focus identity that does not retain its app's focus map or focus entry.
///
/// Upgrade before use. This returns `None` after the last strong focus handle
/// is dropped, even if the window still records the old focus ID.
/// Rendered elements and tab-order records can retain strong clones, so
/// dropping the owning view's copy alone need not make an upgrade fail.
#[derive(Clone, Debug)]
pub struct WeakFocusHandle {
    pub(crate) id: FocusId,
    pub(crate) handles: Weak<FocusMap>,
}

impl WeakFocusHandle {
    /// Retains the identity if at least one strong handle still exists.
    ///
    /// Returns `None` after the app's focus map or its last strong handle is
    /// gone. A successful upgrade does not establish that an element currently
    /// renders the handle, or that any window has selected it.
    pub fn upgrade(&self) -> Option<FocusHandle> {
        let handles = self.handles.upgrade()?;
        FocusHandle::for_id(self.id, &handles)
    }
}

impl PartialEq for WeakFocusHandle {
    fn eq(&self, other: &WeakFocusHandle) -> bool {
        self.id == other.id
    }
}

impl Eq for WeakFocusHandle {}

impl PartialEq<FocusHandle> for WeakFocusHandle {
    fn eq(&self, other: &FocusHandle) -> bool {
        self.id == other.id
    }
}

impl PartialEq<WeakFocusHandle> for FocusHandle {
    fn eq(&self, other: &WeakFocusHandle) -> bool {
        self.id == other.id
    }
}

/// Lets a caller obtain a view's retained keyboard-focus identity.
///
/// Return a clone of a handle stored on the view, and attach that same
/// identity to its element tree with
/// [`track_focus`](crate::InteractiveElement::track_focus).
/// Creating a new handle on each call gives callers an identity the rendered
/// tree does not know. Implementing this trait does not focus the view or
/// make its handle a tab stop.
///
/// [`Context::focus_view`] selects another view through this trait;
/// [`Context::focus_self`] selects the current view. An `Entity<V>` also
/// implements `Focusable` when `V` does, so callers can work through the entity
/// without knowing which field owns its handle. See the
/// [input chapter](crate::_documentation::input#keyboard-focus) for selecting,
/// attaching, and querying that identity.
pub trait Focusable: 'static {
    /// Returns a strong clone of the identity attached to this view's focus target.
    ///
    /// This queries the handle; it does not request focus or activate a window.
    fn focus_handle(&self, cx: &App) -> FocusHandle;
}

impl<V: Focusable> Focusable for Entity<V> {
    fn focus_handle(&self, cx: &App) -> FocusHandle {
        self.read(cx).focus_handle(cx)
    }
}

/// A renderable, focusable view that can ask its owner to dismiss it.
///
/// The blanket implementation applies to types implementing [`Focusable`],
/// [`Render`], and [`EventEmitter<DismissEvent>`]. The trait installs no owner
/// or subscription: the containing view must subscribe and act on the event.
pub trait ManagedView: Focusable + EventEmitter<DismissEvent> + Render {}

impl<M: Focusable + EventEmitter<DismissEvent> + Render> ManagedView for M {}

/// Emitted by a [`ManagedView`] when its owner should dismiss it.
pub struct DismissEvent;

type FrameCallback = Box<dyn FnOnce(&mut Window, &mut App)>;

pub(crate) type AnyMouseListener =
    Box<dyn FnMut(&dyn Any, DispatchPhase, &mut Window, &mut App) + 'static>;

#[derive(Clone)]
pub(crate) struct CursorStyleRequest {
    pub(crate) hitbox_id: Option<HitboxId>,
    pub(crate) style: CursorStyle,
}

/// Input eligibility and hitbox metadata at one logical window-coordinate point.
///
/// The hover and scroll routes visit frontmost records first and include the
/// record that blocks regions behind it. An overlay can block hover while
/// allowing scroll through; see [`HitboxBehavior::BlockMouseExceptScroll`].
/// [`entry`](Self::entry) also exposes metadata for regions outside these routes.
#[derive(Default, Eq, PartialEq)]
pub struct HitTest {
    // HitboxIds which were included in the test's click path (the last of which will be the box that caused occlusion)
    ordered_ids: SmallVec<[HitboxId; 8]>,
    // metadata about all hitboxes, even those outside the test's path
    entries: HashMap<HitboxId, HitTestEntry>,
    // the number of hitbox ids in `ordered_ids` which support mouse. anything after this amount only support scroll.
    hover_hitbox_count: usize,
}

impl HitTest {
    /// Creates a new hit-test by iterating the provided hitboxes to find all those which are not occluded.
    fn new<'a>(hitboxes: impl Iterator<Item = &'a Hitbox>, position: Point<Pixels>) -> Self {
        let mut num_until_mouse_blocked = None::<usize>;
        let mut ids_until_occlusion = SmallVec::default();
        let mut entries = HashMap::default();
        let mut found_hit_occlusion = false;
        // index is 0=closest to viewer, n=farthest from viewer
        for (index, hitbox) in hitboxes.enumerate() {
            entries.insert(
                hitbox.id,
                HitTestEntry {
                    depth: index,
                    tags: hitbox.tags.clone(),
                },
            );

            if found_hit_occlusion {
                continue;
            }

            if !hitbox.contains(&position) {
                continue;
            }

            ids_until_occlusion.push(hitbox.id);

            // Identify the threshold at which mouse is blocked in any way (BlockMouseExceptScroll or BlockMouse)
            if num_until_mouse_blocked.is_none() && hitbox.behavior.blocks_mouse() {
                num_until_mouse_blocked = Some(ids_until_occlusion.len());
            }

            // Found a hitbox that fully occludes boxes behind it. Can now stop iterating.
            if hitbox.behavior.occludes() {
                found_hit_occlusion = true;
            }
        }
        Self {
            hover_hitbox_count: num_until_mouse_blocked.unwrap_or(ids_until_occlusion.len()),
            ordered_ids: ids_until_occlusion,
            entries,
        }
    }

    /// Visits geometrically hit regions from front to back until hover is blocked.
    ///
    /// Includes the blocking region itself. This route does not apply input
    /// modality or pointer capture; [`HitboxId::is_hovered`] adds those checks.
    pub fn iter_hovered(&self) -> impl Iterator<Item = &HitboxId> {
        self.ordered_ids.iter().take(self.hover_hitbox_count)
    }

    /// Visits geometrically hit regions from front to back until scroll is blocked.
    ///
    /// Includes the blocking region itself. Unlike the hover route, it continues
    /// past [`HitboxBehavior::BlockMouseExceptScroll`] regions.
    pub fn iter_scrollable(&self) -> impl Iterator<Item = &HitboxId> {
        self.ordered_ids.iter()
    }

    /// Returns metadata for a hitbox recorded in the tested frame.
    ///
    /// `Some` does not mean the point hit this region: metadata includes
    /// occluded regions and regions that do not contain the point.
    pub fn entry(&self, id: &HitboxId) -> Option<&HitTestEntry> {
        self.entries.get(id)
    }
}

/// An entry in a [`HitTest`] which represents a [`Hitbox`]. Contains some metadata about the
/// hitbox in the frame the HitTest was evaluated on.
#[derive(Debug, PartialEq, Eq)]
pub struct HitTestEntry {
    /// The depth of the hitbox in the ordered list from the Frame.
    /// A smaller number is closer to the viewer, and a larger number is farther from the viewer.
    depth: usize,
    tags: Vec<SharedString>,
}

impl HitTestEntry {
    /// Returns the depth of the [`Hitbox`] in the frame.
    /// A smaller value (closer to 0) represents closer to the viewer.
    /// A larger value represents a hitbox farther from the viewer.
    pub fn depth(&self) -> usize {
        self.depth
    }

    /// Returns any tags assigned to the [`Hitbox`] in the frame.
    pub fn tags(&self) -> &Vec<SharedString> {
        &self.tags
    }
}

/// A type of window control area that corresponds to the platform window.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum WindowControlArea {
    /// An area that allows dragging of the platform window.
    Drag,
    /// An area that allows closing of the platform window.
    Close,
    /// An area that allows maximizing of the platform window.
    Max,
    /// An area that allows minimizing of the platform window.
    Min,
}

/// A frame-record identity used to query a [`Hitbox`]'s input eligibility.
///
/// It does not contain bounds or behavior flags. Retain the prepared hitbox
/// for the matching painted frame; use an [`ElementId`] for identity across
/// rebuilt frames.
#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash)]
pub struct HitboxId(u64);

#[cfg(feature = "headless")]
impl HitboxId {
    /// A placeholder HitboxId exclusively for integration testing API's that
    /// need a hitbox but where the value of the hitbox does not matter. The
    /// alternative is to make the Hitbox optional but that complicates the
    /// implementation.
    pub const fn placeholder() -> Self {
        Self(0)
    }
}

impl HitboxId {
    /// Returns whether this hitbox is eligible for ordinary pointer interaction.
    ///
    /// Pointer capture makes the captured hitbox eligible even outside its
    /// bounds. Otherwise, keyboard input modality suppresses hover, and the
    /// region must occur on the window's hover hit-test route. Use
    /// [`Self::should_handle_scroll`] for scroll events.
    ///
    /// See [`Hitbox::is_hovered`] for details.
    pub fn is_hovered(self, window: &Window) -> bool {
        // If this hitbox has captured the pointer, it's always considered hovered
        if window.captured_hitbox == Some(self) {
            return true;
        }
        if window.last_input_was_keyboard() {
            return false;
        }
        self.hit_test(window)
    }

    /// Checks if the hitbox with this ID is currently hovered, regardless of the last
    /// input modality used.
    ///
    /// See [`HitboxId::is_hovered`] for more details.
    pub(crate) fn is_hovered_ignoring_last_input(self, window: &Window) -> bool {
        // If this hitbox has captured the pointer, it's always considered hovered
        if window.captured_hitbox == Some(self) {
            return true;
        }
        self.hit_test(window)
    }

    fn hit_test(self, window: &Window) -> bool {
        window.mouse_hit_test().iter_hovered().contains(&self)
    }

    /// Checks if the hitbox with this ID contains the mouse and should handle scroll events.
    /// Typically this should only be used when handling `ScrollWheelEvent`, and otherwise
    /// `is_hovered` should be used. See the documentation of `Hitbox::is_hovered` for details about
    /// this distinction.
    pub fn should_handle_scroll(self, window: &Window) -> bool {
        window.mouse_hit_test().iter_scrollable().contains(&self)
    }

    fn next(mut self) -> HitboxId {
        HitboxId(self.0.wrapping_add(1))
    }
}

/// A logical window-local input region recorded during prepaint.
///
/// Bounds and inline fragments are clipped by the content mask. Hit testing
/// visits later records first, so a blocking region can make earlier regions
/// ineligible. [`contains`](Self::contains) checks geometry alone;
/// [`is_hovered`](Self::is_hovered) also accounts for blocking and input modality.
/// Create one with [`Window::insert_hitbox`].
#[derive(Clone, Debug, Deref)]
pub struct Hitbox {
    /// A unique identifier for the hitbox.
    pub id: HitboxId,
    /// Input bounds in logical, window-local pixels, before clipping.
    #[deref]
    pub bounds: Bounds<Pixels>,
    /// The logical, window-local clip captured when the hitbox was inserted.
    pub content_mask: ContentMask<Pixels>,
    /// Flags that specify hitbox behavior.
    pub behavior: HitboxBehavior,
    /// Disjoint regions of an inline element. `bounds` is their union.
    pub fragments: Option<Arc<[Bounds<Pixels>]>>,
    /// Additional user-provided tags to extend behavior of the hitbox.
    pub tags: Vec<SharedString>,
}

impl Hitbox {
    /// Tests a logical, window-local point against the clipped geometry.
    ///
    /// With inline fragments, the point must lie in one of those fragments;
    /// otherwise it must lie in [`Self::bounds`]. It must also lie within the
    /// content mask's rectangle. Edge fades do not narrow this input region.
    ///
    /// This ignores blocking regions, keyboard input modality, and pointer
    /// capture. Use [`Self::is_hovered`] for ordinary pointer handlers, where
    /// those policies matter. Checking `bounds.contains(point)` alone would
    /// also ignore clipping and gaps between inline fragments.
    pub fn contains(&self, point: &Point<Pixels>) -> bool {
        self.content_mask.bounds.contains(point)
            && self.fragments.as_ref().map_or_else(
                || self.bounds.contains(point),
                |fragments| fragments.iter().any(|bounds| bounds.contains(point)),
            )
    }

    /// Returns whether this region is eligible for ordinary pointer interaction.
    ///
    /// Geometric containment alone is insufficient: a region in front can
    /// block it, and keyboard input modality suppresses hover highlights.
    /// Pointer capture overrides both checks for the captured hitbox, even
    /// when the cursor leaves its bounds. See [`HitboxId::is_hovered`].
    ///
    /// Use [`Self::should_handle_scroll`] for wheel events. An overlay with
    /// [`HitboxBehavior::BlockMouseExceptScroll`] blocks clicks and hover
    /// behind it while leaving an underlying container eligible to scroll.
    pub fn is_hovered(&self, window: &Window) -> bool {
        self.id.is_hovered(window)
    }

    /// Checks if the hitbox contains the mouse and should handle scroll events. Typically this
    /// should only be used when handling `ScrollWheelEvent`, and otherwise `is_hovered` should be
    /// used. See the documentation of `Hitbox::is_hovered` for details about this distinction.
    ///
    /// This can return `false` even when the hitbox contains the mouse, if a hitbox in front of
    /// this sets `HitboxBehavior::BlockMouse` (`InteractiveElement::occlude`).
    pub fn should_handle_scroll(&self, window: &Window) -> bool {
        self.id.should_handle_scroll(window)
    }
}

/// Whether a hit region blocks other regions behind it.
///
/// These flags affect hit testing, not event propagation itself. Low-level
/// [`Window::on_mouse_event`] listeners still receive events unless propagation
/// stops; they must check their hitbox. Pointer capture can override ordinary
/// hover eligibility for its captured hitbox.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
pub enum HitboxBehavior {
    /// Leaves regions behind it eligible for pointer and scroll input.
    #[default]
    Normal,

    /// Blocks pointer and scroll eligibility behind this region.
    ///
    /// Ordinary hover, tooltip, and pointer handlers behind it stop matching.
    /// Set through [`InteractiveElement::occlude`](crate::InteractiveElement::occlude),
    /// for example on an overlay that should block the content beneath it.
    BlockMouse,

    /// Blocks pointer eligibility behind this region but lets scroll hit testing continue.
    ///
    /// Use for an overlay whose underlying container should still scroll.
    /// Set through [`InteractiveElement::block_mouse_except_scroll`](crate::InteractiveElement::block_mouse_except_scroll).
    /// Behind it, [`Hitbox::is_hovered`] is false while
    /// [`Hitbox::should_handle_scroll`] can remain true.
    BlockMouseExceptScroll,
}

impl HitboxBehavior {
    /// Returns true if this behavior should prevent hit-tests from marking hitboxes behind it as hovered (aka this is the last element that can be hovered).
    pub fn blocks_mouse(&self) -> bool {
        matches!(self, Self::BlockMouse | Self::BlockMouseExceptScroll)
    }

    /// Returns whether this region blocks both pointer and scroll hit testing behind it.
    pub fn occludes(&self) -> bool {
        matches!(self, Self::BlockMouse)
    }
}

/// Identifies a tooltip request within its window's frame.
///
/// Returned by [`Window::set_tooltip`]. This is not a retained element identity.
#[derive(Copy, Clone, Debug, Default, Eq, PartialEq)]
pub struct TooltipId(usize);

impl TooltipId {
    /// Returns whether this request is the displayed tooltip and contains the cursor.
    ///
    /// This checks the tooltip rectangle directly. It does not apply ordinary
    /// hitbox occlusion or suppress the result during keyboard input modality.
    pub fn is_hovered(&self, window: &Window) -> bool {
        window
            .tooltip_bounds
            .as_ref()
            .is_some_and(|tooltip_bounds| {
                tooltip_bounds.id == *self
                    && tooltip_bounds.bounds.contains(&window.mouse_position())
            })
    }
}

pub(crate) struct TooltipBounds {
    id: TooltipId,
    bounds: Bounds<Pixels>,
}

#[derive(Clone)]
pub(crate) struct TooltipRequest {
    id: TooltipId,
    tooltip: AnyTooltip,
}

pub(crate) struct DeferredDraw {
    current_view: EntityId,
    priority: usize,
    parent_node: DispatchNodeId,
    element_id_stack: SmallVec<[ElementId; 32]>,
    text_style_stack: Vec<TextStyleRefinement>,
    content_mask: Option<ContentMask<Pixels>>,
    rem_size: Pixels,
    element: Option<AnyElement>,
    absolute_offset: Point<Pixels>,
    prepaint_range: Range<PrepaintStateIndex>,
    paint_range: Range<PaintIndex>,
}

pub(crate) struct Frame {
    pub(crate) focus: Option<FocusId>,
    pub(crate) window_active: bool,
    pub(crate) element_states: FxHashMap<(GlobalElementId, TypeId), ElementStateBox>,
    accessed_element_states: Vec<(GlobalElementId, TypeId)>,
    pub(crate) mouse_listeners: Vec<Option<AnyMouseListener>>,
    pub(crate) dispatch_tree: DispatchTree,
    pub(crate) scene: Scene,
    pub(crate) hitboxes: Vec<Hitbox>,
    pub(crate) window_control_hitboxes: Vec<(WindowControlArea, Hitbox)>,
    pub(crate) deferred_draws: Vec<DeferredDraw>,
    pub(crate) input_handlers: Vec<Option<PlatformInputHandler>>,
    pub(crate) tooltip_requests: Vec<Option<TooltipRequest>>,
    pub(crate) cursor_styles: Vec<CursorStyleRequest>,
    #[cfg(any(test, feature = "headless"))]
    pub(crate) debug_bounds: FxHashMap<String, Bounds<Pixels>>,
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub(crate) next_inspector_instance_ids: FxHashMap<Rc<crate::InspectorElementPath>, usize>,
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub(crate) inspector_hitboxes: FxHashMap<HitboxId, crate::InspectorElementId>,
    pub(crate) tab_stops: TabStopMap,
}

#[derive(Clone, Default)]
pub(crate) struct PrepaintStateIndex {
    hitboxes_index: usize,
    tooltips_index: usize,
    deferred_draws_index: usize,
    dispatch_tree_index: usize,
    accessed_element_states_index: usize,
    line_layout_index: LineLayoutIndex,
}

#[derive(Clone, Default)]
pub(crate) struct PaintIndex {
    scene_index: usize,
    mouse_listeners_index: usize,
    input_handlers_index: usize,
    cursor_styles_index: usize,
    accessed_element_states_index: usize,
    tab_handle_index: usize,
    line_layout_index: LineLayoutIndex,
}

impl Frame {
    pub(crate) fn new(dispatch_tree: DispatchTree) -> Self {
        Frame {
            focus: None,
            window_active: false,
            element_states: FxHashMap::default(),
            accessed_element_states: Vec::new(),
            mouse_listeners: Vec::new(),
            dispatch_tree,
            scene: Scene::default(),
            hitboxes: Vec::new(),
            window_control_hitboxes: Vec::new(),
            deferred_draws: Vec::new(),
            input_handlers: Vec::new(),
            tooltip_requests: Vec::new(),
            cursor_styles: Vec::new(),

            #[cfg(any(test, feature = "headless"))]
            debug_bounds: FxHashMap::default(),

            #[cfg(any(feature = "inspector", debug_assertions))]
            next_inspector_instance_ids: FxHashMap::default(),

            #[cfg(any(feature = "inspector", debug_assertions))]
            inspector_hitboxes: FxHashMap::default(),
            tab_stops: TabStopMap::default(),
        }
    }

    pub(crate) fn clear(&mut self) {
        self.element_states.clear();
        self.accessed_element_states.clear();
        self.mouse_listeners.clear();
        self.dispatch_tree.clear();
        self.scene.clear();
        self.input_handlers.clear();
        self.tooltip_requests.clear();
        self.cursor_styles.clear();
        self.hitboxes.clear();
        self.window_control_hitboxes.clear();
        self.deferred_draws.clear();
        self.tab_stops.clear();
        self.focus = None;

        #[cfg(any(test, feature = "headless"))]
        {
            self.debug_bounds.clear();
        }

        #[cfg(any(feature = "inspector", debug_assertions))]
        {
            self.next_inspector_instance_ids.clear();
            self.inspector_hitboxes.clear();
        }
    }

    pub(crate) fn cursor_style(&self, window: &Window) -> Option<CursorStyle> {
        self.cursor_styles
            .iter()
            .rev()
            .fold_while(None, |style, request| match request.hitbox_id {
                None => Done(Some(request.style)),
                Some(hitbox_id) => Continue(style.or_else(|| {
                    hitbox_id
                        .is_hovered_ignoring_last_input(window)
                        .then_some(request.style)
                })),
            })
            .into_inner()
    }

    pub(crate) fn hit_test(&self, position: Point<Pixels>) -> HitTest {
        HitTest::new(self.hitboxes.iter().rev(), position)
    }

    pub(crate) fn focus_path(&self) -> SmallVec<[FocusId; 8]> {
        self.focus
            .map(|focus_id| self.dispatch_tree.focus_path(focus_id))
            .unwrap_or_default()
    }

    pub(crate) fn finish(&mut self, prev_frame: &mut Self) {
        for element_state_key in &self.accessed_element_states {
            if let Some((element_state_key, element_state)) =
                prev_frame.element_states.remove_entry(element_state_key)
            {
                self.element_states.insert(element_state_key, element_state);
            }
        }

        self.scene.finish();
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Ord, PartialOrd)]
enum InputModality {
    Mouse,
    Keyboard,
    Touch,
}

/// Rendering, focus, input, and platform state for one window.
///
/// GPUI passes a mutable window borrow to rendering and input callbacks. Use
/// it for layout, painting, focus, and window-specific services. Store a
/// [`WindowHandle`] when later work must find this window again; a closed
/// window makes handle updates fail.
///
/// Layout and paint APIs use logical [`Pixels`]. GPUI applies the display
/// scale before sending primitives to the renderer. Do not multiply layout
/// coordinates by that scale yourself. Bounds describe the current frame,
/// and layout IDs belong to that frame's tree. Keep entity or element identities
/// when later work needs to find the same logical control.
///
/// Paint calls record a scene for later presentation. Use [`canvas`](crate::canvas)
/// for a custom region; the [rendering chapter](crate::_documentation::rendering)
/// explains layout, prepaint, paint, and the state carried between them.
/// Platform operations such as decoration and fullscreen have the limits of
/// the selected backend. A request can return before the platform applies it.
///
/// # Find the operation you need
///
/// | Task | Start here |
/// | --- | --- |
/// | Keep access for a later callback | [`window_handle`](Self::window_handle), [`to_async`](Self::to_async), [`spawn`](Self::spawn) |
/// | Update displayed state | [`Context::notify`]; [`refresh`](Self::refresh) when the whole window needs rebuilding |
/// | Continue an animation | [`request_animation_frame`](Self::request_animation_frame), [`on_next_frame`](Self::on_next_frame) |
/// | Focus a control or move through tab stops | [`focus`](Self::focus), [`focus_next`](Self::focus_next), [`focus_prev`](Self::focus_prev) |
/// | Draw a custom element | [`request_layout`](Self::request_layout), [`layout_bounds`](Self::layout_bounds), [`paint_quad`](Self::paint_quad) |
/// | Clip or offset a custom region | [`with_content_mask`](Self::with_content_mask), [`with_element_offset`](Self::with_element_offset) |
/// | Connect an editor to platform text input | [`handle_input`](Self::handle_input), [`EntityInputHandler`](crate::EntityInputHandler) |
/// | Restore window geometry | [`window_bounds`](Self::window_bounds), [`WindowOptions`] |
///
/// Prefer element builders for ordinary layout and interaction. The low-level
/// layout, hitbox, and paint methods are for implementing [`Element`](crate::Element);
/// their phase requirements follow that lifecycle.
pub struct Window {
    pub(crate) handle: AnyWindowHandle,
    pub(crate) invalidator: WindowInvalidator,
    pub(crate) removed: bool,
    pub(crate) platform_window: Box<dyn PlatformWindow>,
    display_id: Option<DisplayId>,
    is_resizable: bool,
    is_minimizable: bool,
    sprite_atlas: Arc<dyn PlatformAtlas>,
    text_system: Arc<WindowTextSystem>,
    text_rendering_mode: Rc<Cell<TextRenderingMode>>,
    rem_size: Pixels,
    /// The stack of override values for the window's rem size.
    ///
    /// This is used by `with_rem_size` to allow rendering an element tree with
    /// a given rem size.
    rem_size_override_stack: SmallVec<[Pixels; 8]>,
    pub(crate) viewport_size: Size<Pixels>,
    layout_engine: Option<TaffyLayoutEngine>,
    pub(crate) collecting_inline: bool,
    pub(crate) current_inline_fragments: Option<Arc<[Bounds<Pixels>]>>,
    pub(crate) root: Option<AnyView>,
    pub(crate) element_id_stack: SmallVec<[ElementId; 32]>,
    pub(crate) text_style_stack: Vec<TextStyleRefinement>,
    pub(crate) measurement_direction: ResolvedDirection,
    pub(crate) measurement_unicode_bidi: UnicodeBidi,
    pub(crate) rendered_entity_stack: Vec<EntityId>,
    pub(crate) element_offset_stack: Vec<Point<Pixels>>,
    /// Bounds of the parent `Div` currently prepainting this element as one of its children.
    /// Inset transitions use these bounds to resolve `auto` from the child's rendered position.
    style_transition_containing_bounds: Option<Bounds<Pixels>>,
    pub(crate) element_opacity: f32,
    pub(crate) content_mask_stack: Vec<ContentMask<Pixels>>,
    pub(crate) requested_autoscroll: Option<Bounds<Pixels>>,
    /// The [`TextInputConfiguration`] most recently forwarded to the platform
    /// window, so that only actual changes are forwarded (reconfiguring a live
    /// input session can restart the IME connection).
    last_text_input_configuration: Option<TextInputConfiguration>,
    focused_text_input_active: bool,
    pub(crate) image_cache_stack: Vec<AnyImageCache>,
    pub(crate) rendered_frame: Frame,
    pub(crate) next_frame: Frame,
    next_hitbox_id: HitboxId,
    pub(crate) next_tooltip_id: TooltipId,
    pub(crate) tooltip_bounds: Option<TooltipBounds>,
    pub(crate) next_frame_callbacks: Rc<RefCell<Vec<FrameCallback>>>,
    pub(crate) dirty_views: FxHashSet<EntityId>,
    focus_listeners: SubscriberSet<(), AnyWindowFocusListener>,
    pub(crate) focus_lost_listeners: SubscriberSet<(), AnyObserver>,
    focus_lost_path: SmallVec<[FocusId; 8]>,
    default_prevented: bool,
    mouse_position: Point<Pixels>,
    mouse_hit_test: HitTest,
    modifiers: Modifiers,
    capslock: Capslock,
    scale_factor: f32,
    pub(crate) bounds_observers: SubscriberSet<(), AnyObserver>,
    appearance: WindowAppearance,
    pub(crate) appearance_observers: SubscriberSet<(), AnyObserver>,
    pub(crate) button_layout_observers: SubscriberSet<(), AnyObserver>,
    active: Rc<Cell<bool>>,
    hovered: Rc<Cell<bool>>,
    pub(crate) needs_present: Rc<Cell<bool>>,
    /// Tracks recent input event timestamps to determine if input is arriving at a high rate.
    /// Used to selectively enable VRR optimization only when input rate exceeds 60fps.
    pub(crate) input_rate_tracker: Rc<RefCell<InputRateTracker>>,
    #[cfg(feature = "profiler")]
    window_profiler: profiler::WindowProfiler,
    last_input_modality: InputModality,
    touch_gestures: TouchGestureRecognizer,
    touch_prediction_enabled: bool,
    long_press_timer: Option<Task<()>>,
    long_press_capture: Option<EntityId>,
    pub(crate) refreshing: bool,
    pub(crate) activation_observers: SubscriberSet<(), AnyObserver>,
    pub(crate) focus: Option<FocusId>,
    focus_enabled: bool,
    /// Incremented every time focus moves. Used to invalidate a
    /// pending keyboard activation state when focus changes.
    pub(crate) focus_generation: u64,
    pending_input: Option<PendingInput>,
    pending_modifier: ModifierState,
    pub(crate) pending_input_observers: SubscriberSet<(), AnyObserver>,
    prompt: Option<RenderablePromptHandle>,
    pub(crate) client_inset: Option<Pixels>,
    /// The hitbox that has captured the pointer, if any.
    /// While captured, mouse events route to this hitbox regardless of hit testing.
    captured_hitbox: Option<HitboxId>,
    #[cfg(any(feature = "inspector", debug_assertions))]
    inspector: Option<Entity<Inspector>>,
    #[cfg(feature = "profiler")]
    debug_frame_overlay: crate::debug_overlay::DebugFrameOverlay,
    pub(crate) a11y: A11y,
}

#[derive(Clone, Debug, Default)]
struct ModifierState {
    modifiers: Modifiers,
    saw_other_input: bool,
}

/// Tracks input event timestamps to determine if input is arriving at a high rate.
/// Used for selective VRR (Variable Refresh Rate) optimization.
#[derive(Clone, Debug)]
pub(crate) struct InputRateTracker {
    timestamps: Vec<Instant>,
    window: Duration,
    inputs_per_second: u32,
    sustain_until: Instant,
    sustain_duration: Duration,
}

impl Default for InputRateTracker {
    fn default() -> Self {
        Self {
            timestamps: Vec::new(),
            window: Duration::from_millis(100),
            inputs_per_second: 60,
            sustain_until: Instant::now(),
            sustain_duration: Duration::from_secs(1),
        }
    }
}

impl InputRateTracker {
    pub fn record_input(&mut self) {
        let now = Instant::now();
        self.timestamps.push(now);
        self.prune_old_timestamps(now);

        let min_events = self.inputs_per_second as u128 * self.window.as_millis() / 1000;
        if self.timestamps.len() as u128 >= min_events {
            self.sustain_until = now + self.sustain_duration;
        }
    }

    pub fn is_high_rate(&self) -> bool {
        Instant::now() < self.sustain_until
    }

    fn prune_old_timestamps(&mut self, now: Instant) {
        self.timestamps
            .retain(|&t| now.duration_since(t) <= self.window);
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(crate) enum DrawPhase {
    None,
    Prepaint,
    Paint,
    Focus,
}

#[derive(Default, Debug)]
struct PendingInput {
    keystrokes: SmallVec<[Keystroke; 1]>,
    focus: Option<FocusId>,
    timer: Option<Task<()>>,
    needs_timeout: bool,
}

pub(crate) struct ElementStateBox {
    pub(crate) inner: Box<dyn Any>,
    #[cfg(debug_assertions)]
    pub(crate) type_name: &'static str,
}

fn default_bounds(display_id: Option<DisplayId>, cx: &mut App) -> WindowBounds {
    // TODO, BUG: if you open a window with the currently active window
    // on the stack, this will erroneously fallback to `None`
    //
    // TODO these should be the initial window bounds not considering maximized/fullscreen
    let active_window_bounds = cx
        .active_window()
        .and_then(|w| w.update(cx, |_, window, _| window.window_bounds()).ok());

    const CASCADE_OFFSET: f32 = 25.0;

    let display = display_id
        .map(|id| cx.find_display(id))
        .unwrap_or_else(|| cx.primary_display());

    let default_placement = || Bounds::new(point(px(0.), px(0.)), DEFAULT_WINDOW_SIZE);

    // Use visible_bounds to exclude taskbar/dock areas
    let display_bounds = display
        .as_ref()
        .map(|d| d.visible_bounds())
        .unwrap_or_else(default_placement);

    let (
        Bounds {
            origin: base_origin,
            size: base_size,
        },
        window_bounds_ctor,
    ): (_, fn(Bounds<Pixels>) -> WindowBounds) = match active_window_bounds {
        Some(bounds) => match bounds {
            WindowBounds::Windowed(bounds) => (bounds, WindowBounds::Windowed),
            WindowBounds::Maximized(bounds) => (bounds, WindowBounds::Maximized),
            WindowBounds::Fullscreen(bounds) => (bounds, WindowBounds::Fullscreen),
        },
        None => (
            display
                .as_ref()
                .map(|d| d.default_bounds())
                .unwrap_or_else(default_placement),
            WindowBounds::Windowed,
        ),
    };

    let cascade_offset = point(px(CASCADE_OFFSET), px(CASCADE_OFFSET));
    let proposed_origin = base_origin + cascade_offset;
    let proposed_bounds = Bounds::new(proposed_origin, base_size);

    let display_right = display_bounds.origin.x + display_bounds.size.width;
    let display_bottom = display_bounds.origin.y + display_bounds.size.height;
    let window_right = proposed_bounds.origin.x + proposed_bounds.size.width;
    let window_bottom = proposed_bounds.origin.y + proposed_bounds.size.height;

    let fits_horizontally = window_right <= display_right;
    let fits_vertically = window_bottom <= display_bottom;

    let final_origin = match (fits_horizontally, fits_vertically) {
        (true, true) => proposed_origin,
        (false, true) => point(display_bounds.origin.x, base_origin.y),
        (true, false) => point(base_origin.x, display_bounds.origin.y),
        (false, false) => display_bounds.origin,
    };
    window_bounds_ctor(Bounds::new(final_origin, base_size))
}

impl Window {
    pub(crate) fn new(
        handle: AnyWindowHandle,
        options: WindowOptions,
        cx: &mut App,
    ) -> Result<Self> {
        let background_appearance = options.background_appearance();
        let WindowOptions {
            window_bounds,
            titlebar,
            focus,
            show,
            kind,
            is_movable,
            app_owns_titlebar_drag,
            inactive_frame_interval,
            is_resizable,
            is_minimizable,
            display_id,
            app_id,
            window_min_size,
            window_decorations,
            #[cfg_attr(
                not(any(target_os = "linux", target_os = "freebsd")),
                allow(unused_variables)
            )]
            icon,
            #[cfg_attr(not(target_os = "macos"), allow(unused_variables))]
            tabbing_identifier,
            ..
        } = options;

        let initial_window_title = titlebar
            .as_ref()
            .and_then(|titlebar| titlebar.title.clone());

        let window_bounds = window_bounds.unwrap_or_else(|| default_bounds(display_id, cx));
        let mut platform_window = cx.platform.open_window(
            handle,
            WindowParams {
                bounds: window_bounds.get_bounds(),
                titlebar,
                kind,
                is_movable,
                app_owns_titlebar_drag,
                is_resizable,
                is_minimizable,
                focus,
                show,
                display_id,
                window_min_size,
                app_id: app_id.clone(),
                icon,
                #[cfg(target_os = "macos")]
                tabbing_identifier,
            },
        )?;

        let tab_bar_visible = platform_window.tab_bar_visible();
        SystemWindowTabController::init_visible(cx, tab_bar_visible);
        if let Some(tabs) = platform_window.tabbed_windows() {
            SystemWindowTabController::add_tab(cx, handle.window_id(), tabs);
        }

        let display_id = platform_window.display().map(|display| display.id());
        let sprite_atlas = platform_window.sprite_atlas();
        let mouse_position = platform_window.mouse_position();
        let modifiers = platform_window.modifiers();
        let capslock = platform_window.capslock();
        let content_size = platform_window.content_size();
        let scale_factor = platform_window.scale_factor();
        let appearance = platform_window.appearance();
        let text_system = Arc::new(WindowTextSystem::new(cx.text_system().clone()));
        let invalidator = WindowInvalidator::new(handle.window_id());
        let active = Rc::new(Cell::new(platform_window.is_active()));
        let hovered = Rc::new(Cell::new(platform_window.is_hovered()));
        let needs_present = Rc::new(Cell::new(false));
        let next_frame_callbacks: Rc<RefCell<Vec<FrameCallback>>> = Default::default();
        let input_rate_tracker = Rc::new(RefCell::new(InputRateTracker::default()));
        let last_frame_time = Rc::new(Cell::new(None));

        platform_window
            .request_decorations(window_decorations.unwrap_or(WindowDecorations::Server));
        platform_window.set_background_appearance(background_appearance);

        match window_bounds {
            WindowBounds::Fullscreen(_) => platform_window.toggle_fullscreen(),
            WindowBounds::Maximized(_) => platform_window.zoom(),
            WindowBounds::Windowed(_) => {}
        }

        let accessibility_force_disabled = cx.accessibility_force_disabled;
        let accessibility_forced = cx.accessibility_forced;
        let a11y_active_flag = Arc::new(AtomicBool::new(false));

        #[cfg(not(target_family = "wasm"))]
        if !accessibility_force_disabled {
            let mut initial_root_node = accesskit::Node::new(accesskit::Role::Window);
            if let Some(title) = &initial_window_title {
                initial_root_node.set_label(title.to_string());
            }
            let initial_tree = accesskit::TreeUpdate {
                nodes: vec![(ROOT_NODE_ID, initial_root_node)],
                tree: Some(accesskit::Tree::new(ROOT_NODE_ID)),
                tree_id: accesskit::TreeId::ROOT,
                focus: ROOT_NODE_ID,
            };
            let (activation_sender, activation_receiver) = async_channel::unbounded::<()>();
            let (deactivation_sender, deactivation_receiver) = async_channel::unbounded::<()>();
            let (action_sender, action_receiver) =
                async_channel::unbounded::<accesskit::ActionRequest>();

            platform_window.a11y_init(crate::A11yCallbacks {
                activation: {
                    let active_flag = a11y_active_flag.clone();
                    Box::new(move || {
                        log::info!("Accessibility activated");
                        active_flag.store(true, SeqCst);
                        activation_sender.send_blocking(()).log_err();
                        Some(initial_tree.clone())
                    })
                },
                action: Box::new(move |request| {
                    action_sender.send_blocking(request).log_err();
                }),
                deactivation: {
                    let active_flag = a11y_active_flag.clone();
                    Box::new(move || {
                        log::info!("Accessibility deactivated");
                        active_flag.store(false, SeqCst);
                        deactivation_sender.send_blocking(()).log_err();
                    })
                },
            });

            // A11y can be activated at any time, and so we cannot compute a
            // correct `TreeUpdate` on-demand. When this happens, we return a
            // default empty `TreeUpdate`.
            //
            // So we force a new frame, which will then send a correct `TreeUpdate`.
            let mut async_cx = cx.to_async();
            cx.foreground_executor()
                .spawn(async move {
                    while activation_receiver.recv().await.is_ok() {
                        handle
                            .update(&mut async_cx, |_, window, _| window.refresh())
                            .log_err();
                    }
                })
                .detach();

            let mut async_cx = cx.to_async();
            cx.foreground_executor()
                .spawn(async move {
                    while deactivation_receiver.recv().await.is_ok() {
                        handle
                            .update(&mut async_cx, |_, window, _| window.refresh())
                            .log_err();
                    }
                })
                .detach();

            let mut async_cx = cx.to_async();
            cx.foreground_executor()
                .spawn(async move {
                    while let Ok(request) = action_receiver.recv().await {
                        handle
                            .update(&mut async_cx, |_, window, cx| {
                                window.handle_a11y_action(request, cx);
                            })
                            .log_err();
                    }
                })
                .detach();
        }

        #[cfg(all(
            feature = "hot-patching",
            debug_assertions,
            not(target_family = "wasm")
        ))]
        let (hot_patch_sender, hot_patch_receiver) = async_channel::bounded(1);

        platform_window.on_close(Box::new({
            let window_id = handle.window_id();
            let mut cx = cx.to_async();
            #[cfg(all(
                feature = "hot-patching",
                debug_assertions,
                not(target_family = "wasm")
            ))]
            let hot_patch_sender = hot_patch_sender.clone();
            move || {
                #[cfg(all(
                    feature = "hot-patching",
                    debug_assertions,
                    not(target_family = "wasm")
                ))]
                hot_patch_sender.close();
                let _ = handle.update(&mut cx, |_, window, _| window.remove_window());
                let _ = cx.update(|cx| {
                    SystemWindowTabController::remove_tab(cx, window_id);
                });
            }
        }));
        #[cfg(all(
            feature = "hot-patching",
            debug_assertions,
            not(target_family = "wasm")
        ))]
        {
            // The patch callback runs off the UI thread. Forward it to the
            // foreground executor so refresh can wake demand-driven platforms.
            subsecond::register_handler(Arc::new(move || {
                let _ = hot_patch_sender.try_send(());
            }));
            let mut cx = cx.to_async();
            let foreground_executor = cx.foreground_executor().clone();
            foreground_executor
                .spawn(async move {
                    while hot_patch_receiver.recv().await.is_ok() {
                        if handle
                            .update(&mut cx, |_, window, _| window.refresh())
                            .is_err()
                        {
                            break;
                        }
                    }
                })
                .detach();
        }
        platform_window.on_request_frame(Box::new({
            let mut cx = cx.to_async();
            let invalidator = invalidator.clone();
            let active = active.clone();
            let needs_present = needs_present.clone();
            let next_frame_callbacks = next_frame_callbacks.clone();
            let input_rate_tracker = input_rate_tracker.clone();
            let mut deferred_force_render = false;
            move |request_frame_options| {
                #[cfg(feature = "profiler")]
                let _foreground_turn = profiler::journal::foreground_turn();
                // This must be checked before anything else: if this request
                // arrived re-entrantly while a draw is on this thread's stack
                // (e.g. via a nested message pump in the Windows window
                // procedure), drawing would nest draws, and even touching the
                // App would panic on its already-mutable borrow. Skip instead;
                // the platform leaves the window invalidated (or re-invalidates
                // it), so a fresh request arrives once the in-progress draw
                // unwinds. Remember force_render so the deferred frame still
                // bypasses the view cache.
                //
                // Returning here skips `complete_frame`, which on Wayland would
                // stall the window's frame callbacks (no `surface.commit()`) —
                // but calling it would hit the App borrow panic above, and this
                // branch is unreachable there in practice: only Windows pumps
                // platform events (and thus requests frames) mid-draw.
                if draw_in_progress() {
                    log::debug!("deferring re-entrant window draw request");
                    deferred_force_render |= request_frame_options.force_render;
                    return;
                }
                // Take the deferred flag first: `||` short-circuits, and leaving
                // the flag set when this request already forces a render would
                // force a second, redundant render on the next frame.
                let force_render =
                    mem::take(&mut deferred_force_render) || request_frame_options.force_render;

                let thermal_state = handle
                    .update(&mut cx, |_, _, cx| cx.thermal_state())
                    .log_err();

                // Throttle frame rate based on conditions:
                // - Thermal pressure (Serious/Critical): cap to ~60fps
                // - Inactive window (not focused): cap to ~30fps to save energy
                let min_frame_interval = if request_frame_options.require_presentation
                    || (!request_frame_options.force_render
                        && next_frame_callbacks.borrow().is_empty())
                {
                    None
                } else if !active.get() && !input_rate_tracker.borrow_mut().is_high_rate() {
                    inactive_frame_interval
                } else if let Some(ThermalState::Critical | ThermalState::Serious) = thermal_state {
                    Some(Duration::from_micros(16667))
                } else {
                    None
                };

                let now = Instant::now();
                if let Some(min_interval) = min_frame_interval {
                    if let Some(last_frame) = last_frame_time.get()
                        && now.duration_since(last_frame) < min_interval
                    {
                        // Don't lose a pending forced render to throttling.
                        deferred_force_render |= force_render;
                        // Deferred by throttling: ask demand-driven platforms to retry.
                        handle
                            .update(&mut cx, |_, window, _| {
                                window.platform_window.schedule_frame();
                            })
                            .log_err();
                        // The demand that entered this branch (a deferred forced
                        // render or pending next-frame callbacks) is still
                        // unserved; platforms that stop requesting frames for
                        // idle windows need a wakeup to deliver the retry.
                        invalidator.wake_platform();
                        return;
                    }
                }
                last_frame_time.set(Some(now));

                let pending_next_frame_callbacks = next_frame_callbacks.take();
                if !pending_next_frame_callbacks.is_empty() {
                    handle
                        .update(&mut cx, |_, window, cx| {
                            for callback in pending_next_frame_callbacks {
                                callback(window, cx);
                            }
                        })
                        .log_err();
                }

                // Keep presenting if input was recently arriving at a high rate (>= 60fps).
                // Once high-rate input is detected, we sustain presentation for 1 second
                // to prevent display underclocking during active input.
                let needs_present = request_frame_options.require_presentation
                    || needs_present.get()
                    || input_rate_tracker.borrow_mut().is_high_rate();

                if invalidator.is_dirty() || force_render {
                    measure("frame duration", || {
                        handle
                            .update(&mut cx, |_, window, cx| {
                                if force_render {
                                    // Bypass cached view reuse so we don't replay stale
                                    // atlas tile references after a GPU device recovery.
                                    window.refresh();
                                }
                                let arena_clear_needed = window.draw(cx);
                                window.present();
                                arena_clear_needed.clear(cx);
                            })
                            .log_err();
                    })
                } else if needs_present {
                    handle
                        .update(&mut cx, |_, window, _| window.present())
                        .log_err();
                }

                handle
                    .update(&mut cx, |_, window, _| {
                        if window.invalidator.is_dirty()
                            || !window.next_frame_callbacks.borrow().is_empty()
                        {
                            window.platform_window.schedule_frame();
                        }
                    })
                    .log_err();

                // Platforms that stop requesting frames for idle windows only
                // deliver another request after a wakeup. If demand remains
                // after this frame (the window was re-invalidated mid-draw, or
                // animations scheduled next-frame callbacks), re-arm the frame
                // source explicitly.
                if invalidator.is_dirty() || !next_frame_callbacks.borrow().is_empty() {
                    invalidator.wake_platform();
                }
            }
        }));
        invalidator.set_platform_waker(platform_window.frame_waker());
        platform_window.on_resize(Box::new({
            let mut cx = cx.to_async();
            move |_, _| {
                handle
                    .update(&mut cx, |_, window, cx| window.bounds_changed(cx))
                    .log_err();
            }
        }));
        platform_window.on_moved(Box::new({
            let mut cx = cx.to_async();
            move || {
                handle
                    .update(&mut cx, |_, window, cx| window.bounds_changed(cx))
                    .log_err();
            }
        }));
        platform_window.on_appearance_changed(Box::new({
            let cx = cx.to_async();
            let foreground_executor = cx.foreground_executor().clone();
            move || {
                let mut cx = cx.clone();
                // Defer the update because changing the AppKit appearance may
                // synchronously invoke this callback while App is already borrowed.
                foreground_executor
                    .spawn(async move {
                        handle
                            .update(&mut cx, |_, window, cx| window.appearance_changed(cx))
                            .log_err();
                    })
                    .detach();
            }
        }));
        platform_window.on_button_layout_changed(Box::new({
            let mut cx = cx.to_async();
            move || {
                handle
                    .update(&mut cx, |_, window, cx| window.button_layout_changed(cx))
                    .log_err();
            }
        }));
        platform_window.on_active_status_change(Box::new({
            let mut cx = cx.to_async();
            move |active| {
                handle
                    .update(&mut cx, |_, window, cx| {
                        window.active.set(active);
                        window.modifiers = window.platform_window.modifiers();
                        window.capslock = window.platform_window.capslock();
                        window
                            .activation_observers
                            .clone()
                            .retain(&(), |callback| callback(window, cx));

                        window.bounds_changed(cx);
                        window.refresh();

                        SystemWindowTabController::update_last_active(cx, window.handle.id);
                    })
                    .log_err();
            }
        }));
        platform_window.on_hover_status_change(Box::new({
            let mut cx = cx.to_async();
            move |active| {
                handle
                    .update(&mut cx, |_, window, _| {
                        window.hovered.set(active);
                        window.refresh();
                    })
                    .log_err();
            }
        }));
        platform_window.on_input({
            let mut cx = cx.to_async();
            Box::new(move |event| {
                handle
                    .update(&mut cx, |_, window, cx| window.dispatch_event(event, cx))
                    .log_err()
                    .unwrap_or(DispatchEventResult::default())
            })
        });
        platform_window.on_hit_test_window_control({
            let mut cx = cx.to_async();
            Box::new(move || {
                handle
                    .update(&mut cx, |_, window, _cx| {
                        for (area, hitbox) in &window.rendered_frame.window_control_hitboxes {
                            let mut scrollable_ids = window.mouse_hit_test().iter_scrollable();
                            if scrollable_ids.contains(&hitbox.id) {
                                return Some(*area);
                            }
                        }
                        None
                    })
                    .log_err()
                    .unwrap_or(None)
            })
        });
        platform_window.on_move_tab_to_new_window({
            let mut cx = cx.to_async();
            Box::new(move || {
                handle
                    .update(&mut cx, |_, _window, cx| {
                        SystemWindowTabController::move_tab_to_new_window(cx, handle.window_id());
                    })
                    .log_err();
            })
        });
        platform_window.on_merge_all_windows({
            let mut cx = cx.to_async();
            Box::new(move || {
                handle
                    .update(&mut cx, |_, _window, cx| {
                        SystemWindowTabController::merge_all_windows(cx, handle.window_id());
                    })
                    .log_err();
            })
        });
        platform_window.on_select_next_tab({
            let mut cx = cx.to_async();
            Box::new(move || {
                handle
                    .update(&mut cx, |_, _window, cx| {
                        SystemWindowTabController::select_next_tab(cx, handle.window_id());
                    })
                    .log_err();
            })
        });
        platform_window.on_select_previous_tab({
            let mut cx = cx.to_async();
            Box::new(move || {
                handle
                    .update(&mut cx, |_, _window, cx| {
                        SystemWindowTabController::select_previous_tab(cx, handle.window_id())
                    })
                    .log_err();
            })
        });
        platform_window.on_toggle_tab_bar({
            let mut cx = cx.to_async();
            Box::new(move || {
                handle
                    .update(&mut cx, |_, window, cx| {
                        let tab_bar_visible = window.platform_window.tab_bar_visible();
                        SystemWindowTabController::set_visible(cx, tab_bar_visible);
                    })
                    .log_err();
            })
        });

        if let Some(app_id) = app_id {
            platform_window.set_app_id(&app_id);
        }

        platform_window.map_window().unwrap();

        Ok(Window {
            handle,
            invalidator,
            removed: false,
            platform_window,
            display_id,
            is_resizable,
            is_minimizable,
            sprite_atlas,
            text_system,
            text_rendering_mode: cx.text_rendering_mode.clone(),
            rem_size: px(16.),
            rem_size_override_stack: SmallVec::new(),
            viewport_size: content_size,
            layout_engine: Some(TaffyLayoutEngine::new()),
            collecting_inline: false,
            current_inline_fragments: None,
            root: None,
            element_id_stack: SmallVec::default(),
            text_style_stack: Vec::new(),
            measurement_direction: ResolvedDirection::LeftToRight,
            measurement_unicode_bidi: UnicodeBidi::Normal,
            rendered_entity_stack: Vec::new(),
            element_offset_stack: Vec::new(),
            style_transition_containing_bounds: None,
            content_mask_stack: Vec::new(),
            element_opacity: 1.0,
            requested_autoscroll: None,
            last_text_input_configuration: None,
            focused_text_input_active: false,
            rendered_frame: Frame::new(DispatchTree::new(cx.keymap.clone(), cx.actions.clone())),
            next_frame: Frame::new(DispatchTree::new(cx.keymap.clone(), cx.actions.clone())),
            next_frame_callbacks,
            next_hitbox_id: HitboxId(0),
            next_tooltip_id: TooltipId::default(),
            tooltip_bounds: None,
            dirty_views: FxHashSet::default(),
            focus_listeners: SubscriberSet::new(),
            focus_lost_listeners: SubscriberSet::new(),
            focus_lost_path: SmallVec::new(),
            default_prevented: true,
            mouse_position,
            mouse_hit_test: HitTest::default(),
            modifiers,
            capslock,
            scale_factor,
            bounds_observers: SubscriberSet::new(),
            appearance,
            appearance_observers: SubscriberSet::new(),
            button_layout_observers: SubscriberSet::new(),
            active,
            hovered,
            needs_present,
            input_rate_tracker,
            #[cfg(feature = "profiler")]
            window_profiler: profiler::WindowProfiler::new(handle.window_id())?,
            last_input_modality: InputModality::Mouse,
            touch_gestures: TouchGestureRecognizer::new(
                cx.platform
                    .gestures()
                    .map_or_else(GestureTuning::default, |gestures| gestures.tuning()),
            ),
            touch_prediction_enabled: true,
            long_press_timer: None,
            long_press_capture: None,
            refreshing: false,
            activation_observers: SubscriberSet::new(),
            focus: None,
            focus_enabled: true,
            focus_generation: 0,
            pending_input: None,
            pending_modifier: ModifierState::default(),
            pending_input_observers: SubscriberSet::new(),
            prompt: None,
            client_inset: None,
            image_cache_stack: Vec::new(),
            captured_hitbox: None,
            #[cfg(any(feature = "inspector", debug_assertions))]
            inspector: None,
            #[cfg(feature = "profiler")]
            debug_frame_overlay: crate::debug_overlay::DebugFrameOverlay::new(),
            a11y: A11y::new(
                a11y_active_flag,
                accessibility_force_disabled,
                accessibility_forced,
                initial_window_title,
            ),
        })
    }

    pub(crate) fn new_focus_listener(
        &self,
        value: AnyWindowFocusListener,
    ) -> (Subscription, impl FnOnce() + use<>) {
        self.focus_listeners.insert((), value)
    }
}

#[derive(Clone, Debug, Default, PartialEq, Eq)]
/// Reports GPUI's propagation and default-handling flags after dispatch.
pub struct DispatchEventResult {
    /// Whether propagation continued after dispatch.
    ///
    /// `false` means a listener stopped propagation. It does not imply that the platform default
    /// action was prevented; inspect [`Self::default_prevented`] separately.
    pub propagate: bool,
    /// Whether a listener called [`Window::prevent_default`].
    ///
    /// The platform adapter decides how this affects native defaults.
    pub default_prevented: bool,
}

/// Rectangular region that clips window content, with optional fades at each edge.
///
/// Content outside `bounds` is omitted. Fades are evaluated in window space against these
/// axis-aligned bounds and do not follow transforms. Complex masks are not supported.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
#[repr(C)]
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-ContentMask-596c376b.md")]
// docs:examples:end
pub struct ContentMask<P: Clone + Debug + Default + PartialEq> {
    /// Visible rectangle in the mask's coordinate unit.
    pub bounds: Bounds<P>,
    /// Fade distance at each edge. A zero distance leaves that edge fully opaque.
    pub fade_out: Edges<P>,
}

impl ContentMask<Pixels> {
    /// Converts pixel units to scaled pixels by `factor`.
    pub fn scale(&self, factor: f32) -> ContentMask<ScaledPixels> {
        ContentMask {
            bounds: self.bounds.scale(factor),
            fade_out: self.fade_out.scale(factor),
        }
    }

    /// Returns the intersection of two masks, combining edge fades at the resulting edges.
    ///
    /// For each edge, the mask that actually clips at that edge contributes its
    /// fade; when both masks clip at the same coordinate, the stronger fade wins.
    pub fn intersect(&self, other: &Self) -> Self {
        fn edge_fade(
            a: Pixels,
            b: Pixels,
            a_fade: Pixels,
            b_fade: Pixels,
            a_clips_closer: impl Fn(Pixels, Pixels) -> bool,
        ) -> Pixels {
            if a_clips_closer(a, b) {
                a_fade
            } else if a_clips_closer(b, a) {
                b_fade
            } else {
                a_fade.max(b_fade)
            }
        }

        ContentMask {
            bounds: self.bounds.intersect(&other.bounds),
            fade_out: Edges {
                top: edge_fade(
                    self.bounds.top(),
                    other.bounds.top(),
                    self.fade_out.top,
                    other.fade_out.top,
                    |a, b| a > b,
                ),
                right: edge_fade(
                    self.bounds.right(),
                    other.bounds.right(),
                    self.fade_out.right,
                    other.fade_out.right,
                    |a, b| a < b,
                ),
                bottom: edge_fade(
                    self.bounds.bottom(),
                    other.bounds.bottom(),
                    self.fade_out.bottom,
                    other.fade_out.bottom,
                    |a, b| a < b,
                ),
                left: edge_fade(
                    self.bounds.left(),
                    other.bounds.left(),
                    self.fade_out.left,
                    other.fade_out.left,
                    |a, b| a > b,
                ),
            },
        }
    }
}

impl ContentMask<ScaledPixels> {
    /// Intersects two masks in device coordinates with the normal edge fade rules.
    pub fn intersect(&self, other: &Self) -> Self {
        let logical = |mask: &Self| ContentMask {
            bounds: mask.bounds.map(|v| Pixels(v.0)),
            fade_out: mask.fade_out.map(|v| Pixels(v.0)),
        };
        let merged = logical(self).intersect(&logical(other));
        Self {
            bounds: merged.bounds.map(|v| ScaledPixels(v.0)),
            fade_out: merged.fade_out.map(|v| ScaledPixels(v.0)),
        }
    }
}

#[cfg(test)]
mod content_mask_tests {
    use super::*;

    fn mask(left: f32, width: f32, fade_left: f32) -> ContentMask<Pixels> {
        ContentMask {
            bounds: Bounds::new(point(px(left), px(0.)), size(px(width), px(10.))),
            fade_out: Edges {
                left: px(fade_left),
                ..Default::default()
            },
        }
    }

    #[test]
    fn intersect_keeps_only_the_fade_at_the_visible_edge() {
        let outer = mask(0., 100., 20.);
        let inner = mask(30., 40., 0.);
        assert_eq!(outer.intersect(&inner).fade_out.left, px(0.));

        let child = mask(0., 40., 0.);
        assert_eq!(outer.intersect(&child).fade_out.left, px(20.));
    }
}

impl Window {
    fn mark_view_dirty(&mut self, view_id: EntityId) {
        // Mark ancestor views as dirty. If already in the `dirty_views` set, then all its ancestors
        // should already be dirty.
        for view_id in self
            .rendered_frame
            .dispatch_tree
            .view_path_reversed(view_id)
        {
            if !self.dirty_views.insert(view_id) {
                break;
            }
        }
    }

    /// Observes changes to this window's platform appearance.
    ///
    /// Read [`appearance`](Self::appearance) once for the initial value; registration does not
    /// invoke the callback. Later callbacks receive a fresh window and app borrow. Retain the
    /// returned subscription to keep observing. Neither registration nor the subscription
    /// keeps the window alive. See the [colors module](crate::colors) for palette updates.
    pub fn observe_window_appearance(
        &self,
        mut callback: impl FnMut(&mut Window, &mut App) + 'static,
    ) -> Subscription {
        let (subscription, activate) = self.appearance_observers.insert(
            (),
            Box::new(move |window, cx| {
                callback(window, cx);
                true
            }),
        );
        activate();
        subscription
    }

    /// Observes a change to the platform's titlebar button layout.
    ///
    /// Keep the returned [`Subscription`] to continue receiving changes. This
    /// does not invoke the callback immediately or retain the window.
    pub fn observe_button_layout_changed(
        &self,
        mut callback: impl FnMut(&mut Window, &mut App) + 'static,
    ) -> Subscription {
        let (subscription, activate) = self.button_layout_observers.insert(
            (),
            Box::new(move |window, cx| {
                callback(window, cx);
                true
            }),
        );
        activate();
        subscription
    }

    /// Builds and installs a new root view, then schedules a redraw.
    ///
    /// The replacement changes the type checked by any existing [`WindowHandle`]; a handle for
    /// the previous root type will fail its next typed read or update. The returned entity is a
    /// clone of the new root and can be retained independently of the handle.
    pub fn replace_root<E>(
        &mut self,
        cx: &mut App,
        build_view: impl FnOnce(&mut Window, &mut Context<E>) -> E,
    ) -> Entity<E>
    where
        E: 'static + Render,
    {
        let view = cx.new(|cx| build_view(self, cx));
        self.root = Some(view.clone().into());
        self.refresh();
        view
    }

    /// Returns this window's root view, preserving absence and type mismatch.
    ///
    /// - `None`: this window has no root view.
    /// - `Some(None)`: a root exists, but its type is not `E`.
    /// - `Some(Some(entity))`: the root is an `E`; the returned clone retains it.
    ///
    /// For access from outside a window callback, [`WindowHandle::read`]
    /// returns an error for a closed window or a root-type mismatch.
    pub fn root<E>(&self) -> Option<Option<Entity<E>>>
    where
        E: 'static + Render,
    {
        self.root
            .as_ref()
            .map(|view| view.clone().downcast::<E>().ok())
    }

    /// Returns a copyable identity for this window.
    ///
    /// The handle does not keep the native window alive. Store it to reacquire the window later
    /// through an [`AppContext`]; operations fail after the window closes.
    pub fn window_handle(&self) -> AnyWindowHandle {
        self.handle
    }

    /// Mark the window dirty so the next frame rebuilds its drawing.
    ///
    /// This is a no-op while the window is drawing. For an element that needs
    /// another animation frame, use [`Self::request_animation_frame`]; for a
    /// callback at the next frame opportunity, use [`Self::on_next_frame`] and
    /// notify the entity whose state changed. A refresh requests work; it does
    /// not draw or present the window synchronously.
    pub fn refresh(&mut self) {
        if self.invalidator.not_drawing() {
            self.refreshing = true;
            self.invalidator.set_dirty(true);
        }
    }

    /// Marks this window for removal from the app.
    ///
    /// The app removes it after the current window update finishes. Use the platform close
    /// callback when the user requests a close that may be vetoed.
    pub fn remove_window(&mut self) {
        self.removed = true;
    }

    /// Return the window's current GPUI focus target, if its handle is still alive.
    ///
    /// This is independent of whether the native window is active; use
    /// [`Self::is_window_active`] for that. A handle can be focused before it
    /// has a node in the rendered tree, so `Some` alone does not establish that
    /// element-level key listeners can currently receive input.
    pub fn focused(&self, cx: &App) -> Option<FocusHandle> {
        self.focus
            .and_then(|id| FocusHandle::for_id(id, &cx.focus_handles))
    }

    /// While focus-lost listeners are being dispatched, returns the closest ancestor of the
    /// previously focused element that can still receive focus, making it a suitable target
    /// for focus restoration. Returns `None` at all other times, or when no such ancestor exists.
    pub fn focus_lost_restore_target(&self, cx: &App) -> Option<FocusHandle> {
        let (_leaf, ancestors) = self.focus_lost_path.split_last()?;
        ancestors.iter().rev().find_map(|id| {
            self.rendered_frame.dispatch_tree.focusable_node_id(*id)?;
            FocusHandle::for_id(*id, &cx.focus_handles)
        })
    }

    /// Moves focus to the element associated with `handle`.
    ///
    /// Focusing the already-focused handle is a no-op, as is any request after
    /// [`Self::disable_focus`]. A change clears pending key sequences and
    /// requests a redraw. This does not activate the native window.
    ///
    /// Attach the handle with [`InteractiveElement::track_focus`](crate::InteractiveElement::track_focus) before
    /// relying on its element listeners. Without a node for the focused
    /// handle, keyboard dispatch falls back to the rendered root.
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-Window-focus-ca2fdb4a.md")]
    // docs:examples:end
    pub fn focus(&mut self, handle: &FocusHandle, cx: &mut App) {
        if !self.focus_enabled || self.focus == Some(handle.id) {
            return;
        }

        self.focus = Some(handle.id);
        self.focus_generation = self.focus_generation.wrapping_add(1);
        self.clear_pending_keystrokes(cx);

        self.refresh();
    }

    /// Clears this window's selected GPUI focus target and pending key sequence.
    ///
    /// This requests a redraw without deactivating the native window. With no
    /// selected target, keyboard dispatch falls back to the rendered root.
    /// Later calls to [`Self::focus`] remain valid; use [`Self::disable_focus`]
    /// to prevent them. Focus listeners observe the change on a subsequent draw.
    pub fn blur(&mut self, cx: &mut App) {
        self.clear_pending_keystrokes(cx);

        if !self.focus_enabled {
            return;
        }

        if self.focus.is_some() {
            self.focus_generation = self.focus_generation.wrapping_add(1);
        }
        self.focus = None;
        self.refresh();
    }

    /// Clear GPUI focus and disable further focus requests for this window.
    ///
    /// There is no corresponding enable operation. Use [`Self::blur`] when
    /// focus should be cleared temporarily while later requests remain valid.
    pub fn disable_focus(&mut self, cx: &mut App) {
        self.blur(cx);
        self.focus_enabled = false;
    }

    /// Moves focus to the next enabled tab stop, wrapping at the end of the rendered order.
    ///
    /// This is a no-op while focus is disabled or when the current frame contains no tab stops.
    /// With no focus, or a target absent from that order, starts at its first
    /// stop. A selected non-stop container remains a position in the order:
    /// traversal starts after it. The order comes from the last painted frame.
    /// This method does not install a Tab binding. See the
    /// [input chapter](crate::_documentation::input#connect-tab-to-traversal)
    /// for the key listener that invokes it.
    pub fn focus_next(&mut self, cx: &mut App) {
        if !self.focus_enabled {
            return;
        }

        if let Some(handle) = self.rendered_frame.tab_stops.next(self.focus.as_ref()) {
            self.focus(&handle, cx)
        }
    }

    /// Moves focus to the previous enabled tab stop, wrapping at the beginning of the rendered order.
    ///
    /// This is a no-op while focus is disabled or when the current frame contains no tab stops.
    /// With no focus, or a target absent from that order, starts at its last
    /// stop. A selected non-stop container remains a position in the order:
    /// traversal starts before it. The order comes from the last painted frame.
    /// Call this for Shift+Tab in the application's traversal handler; see
    /// [`Self::focus_next`] for the corresponding forward operation.
    pub fn focus_prev(&mut self, cx: &mut App) {
        if !self.focus_enabled {
            return;
        }

        if let Some(handle) = self.rendered_frame.tab_stops.prev(self.focus.as_ref()) {
            self.focus(&handle, cx)
        }
    }

    /// Returns this window's text-layout cache and font interface.
    ///
    /// Use [`Self::text_style`] for the inherited text style. Custom text
    /// elements can use [`WindowTextSystem`] to shape and measure runs before
    /// painting them.
    pub fn text_system(&self) -> &Arc<WindowTextSystem> {
        &self.text_system
    }

    /// Resolves the text style inherited at the current drawing position.
    ///
    /// Refinements installed by [`Self::with_text_style`] apply from the
    /// outermost scope inward, starting with [`TextStyle::default`].
    pub fn text_style(&self) -> TextStyle {
        let mut style = TextStyle::default();
        for refinement in &self.text_style_stack {
            style.refine(refinement);
        }
        style
    }

    /// Returns the resolved direction of the current measured or prepainted layout node.
    ///
    /// Custom elements can use this when direction changes intrinsic measurement or a detached
    /// sublayout created during prepaint.
    pub fn resolved_direction(&self) -> ResolvedDirection {
        self.measurement_direction
    }

    /// Returns the bidirectional formatting mode of the measured layout node.
    #[doc(hidden)]
    pub fn resolved_unicode_bidi(&self) -> UnicodeBidi {
        self.measurement_unicode_bidi
    }

    /// Check if the platform window is maximized.
    ///
    /// On some platforms (namely Windows) this is different than the bounds being the size of the display
    pub fn is_maximized(&self) -> bool {
        self.platform_window.is_maximized()
    }

    /// Requests a native decoration mode from the window manager.
    ///
    /// This is meaningful for Wayland integrations; other platforms may ignore the request.
    pub fn request_decorations(&self, decorations: WindowDecorations) {
        self.platform_window.request_decorations(decorations);
    }

    /// Sets the exclusive zone for a Wayland layer-shell surface.
    ///
    /// A positive logical-pixel distance reserves space from the anchored edge. Zero lets the
    /// compositor place the surface in other exclusive zones; `-1` opts out of exclusive-zone
    /// handling. The value is ignored by backends without layer-shell support.
    pub fn set_exclusive_zone(&self, zone: Pixels) {
        self.platform_window.set_exclusive_zone(zone);
    }

    /// Set which anchored edge a layer-shell surface's exclusive zone applies to.
    /// This is only needed to disambiguate a corner-anchored surface; otherwise the
    /// edge is deduced from the anchor. The edge must be a single edge the surface
    /// is anchored to, or it is ignored. (Wayland layer-shell windows only)
    #[cfg(all(target_os = "linux", feature = "wayland"))]
    pub fn set_exclusive_edge(&self, edge: crate::layer_shell::Anchor) {
        self.platform_window.set_exclusive_edge(edge);
    }

    /// Start an interactive window resize operation if this window is resizable.
    pub fn start_window_resize(&self, edge: ResizeEdge) {
        if self.is_resizable {
            self.platform_window.start_window_resize(edge);
        }
    }

    /// Sets the Wayland surface's input region in logical window coordinates.
    ///
    /// Pointer and touch events outside the region pass through to surfaces below this one. Other
    /// backends may ignore the request.
    ///
    /// - `Some(rects)` restricts input to the union of `rects`, in window coordinates.
    /// - `Some(&[])` is an empty region, so the window receives no pointer or touch input.
    /// - `None` resets the region to the default, so the whole window receives input again.
    pub fn set_input_region(&self, region: Option<&[Bounds<Pixels>]>) {
        self.platform_window.set_input_region(region);
    }

    /// Returns the platform bounds and state to use when restoring or reopening this window.
    ///
    /// The value may preserve windowed, maximized, or fullscreen state rather than just the
    /// current rectangle. Use [`Self::inner_window_bounds`] when restoration should exclude
    /// client-decoration insets where the backend reports them.
    pub fn window_bounds(&self) -> WindowBounds {
        self.platform_window.window_bounds()
    }

    /// Returns restoration bounds excluding client-decoration insets where supported.
    ///
    /// Backends without separate client decorations return the same value as [`Self::window_bounds`].
    pub fn inner_window_bounds(&self) -> WindowBounds {
        self.platform_window.inner_window_bounds()
    }

    /// Queues `action` for dispatch after the current update completes.
    ///
    /// The method records the current focus identity. The deferred callback
    /// uses that identity in the window's rendered dispatch tree, falling back
    /// to the root if it has no node there. A focus change before delivery does
    /// not retarget the action to the newly focused element. If the window has
    /// closed, delivery is skipped and the lookup error is logged.
    ///
    /// Deferral lets the initiating entity update finish before a handler
    /// reacquires that entity. See [`Action`] for propagation and bindings.
    pub fn dispatch_action(&mut self, action: Box<dyn Action>, cx: &mut App) {
        let focus_id = self.focused(cx).map(|handle| handle.id);

        let window = self.handle;
        cx.defer(move |cx| {
            window
                .update(cx, |_, window, cx| {
                    let node_id = window.focus_node_id_in_rendered_frame(focus_id);
                    window.dispatch_action_on_node(node_id, action.as_ref(), cx);
                })
                .log_err();
        })
    }

    pub(crate) fn dispatch_keystroke_observers(
        &mut self,
        event: &dyn Any,
        action: Option<Box<dyn Action>>,
        context_stack: Vec<KeyContext>,
        cx: &mut App,
    ) {
        let Some(key_down_event) = event.downcast_ref::<KeyDownEvent>() else {
            return;
        };

        cx.keystroke_observers.clone().retain(&(), move |callback| {
            (callback)(
                &KeystrokeEvent {
                    keystroke: key_down_event.keystroke.clone(),
                    action: action.as_ref().map(|action| action.boxed_clone()),
                    context_stack: context_stack.clone(),
                },
                self,
                cx,
            )
        });
    }

    pub(crate) fn dispatch_keystroke_interceptors(
        &mut self,
        event: &dyn Any,
        context_stack: Vec<KeyContext>,
        cx: &mut App,
    ) {
        let Some(key_down_event) = event.downcast_ref::<KeyDownEvent>() else {
            return;
        };

        cx.keystroke_interceptors
            .clone()
            .retain(&(), move |callback| {
                (callback)(
                    &KeystrokeEvent {
                        keystroke: key_down_event.keystroke.clone(),
                        action: None,
                        context_stack: context_stack.clone(),
                    },
                    self,
                    cx,
                )
            });
    }

    /// Queue `f` for effect processing after the current update closure returns.
    ///
    /// The closure receives a fresh mutable window borrow. Earlier queued
    /// effects run first; this does not wait for a platform frame or for every
    /// effect subsequently queued by other callbacks. If the window has been
    /// removed before delivery, `f` is skipped. See [`App::defer`].
    pub fn defer(&self, cx: &mut App, f: impl FnOnce(&mut Window, &mut App) + 'static) {
        let handle = self.handle;
        cx.defer(move |cx| {
            handle.update(cx, |_, window, cx| f(window, cx)).ok();
        });
    }

    /// Observes an entity's notifications in this window.
    ///
    /// The callback receives the entity's current state through a fresh handle;
    /// several pending notifications can coalesce. It does not run immediately
    /// at registration. Use [`Self::subscribe`] when each occurrence needs its
    /// own payload, rather than counting notifications as changes.
    ///
    /// Retain the returned subscription to keep observing. This registration
    /// retains neither the entity nor the window; delivery ends when either
    /// is unavailable or the subscription is dropped. It stays attached to
    /// this window even if the observed view is later rendered elsewhere.
    pub fn observe<T: 'static>(
        &mut self,
        observed: &Entity<T>,
        cx: &mut App,
        mut on_notify: impl FnMut(Entity<T>, &mut Window, &mut App) + 'static,
    ) -> Subscription {
        let entity_id = observed.entity_id();
        let observed = observed.downgrade();
        let window_handle = self.handle;
        cx.new_observer(
            entity_id,
            Box::new(move |cx| {
                window_handle
                    .update(cx, |_, window, cx| {
                        if let Some(handle) = observed.upgrade() {
                            on_notify(handle, window, cx);
                            true
                        } else {
                            false
                        }
                    })
                    .unwrap_or(false)
            }),
        )
    }

    /// Subscribes to events emitted by an [`EventEmitter`] entity.
    ///
    /// The callback runs during effect processing with the emitted payload,
    /// a fresh entity handle, and this window. The emitter's current fields
    /// may already reflect later changes; read the payload for the occurrence
    /// being reported. See [`EventEmitter`] for a save-revision example.
    ///
    /// Retain the returned subscription to receive events. The registration
    /// retains neither the emitter nor the window, and delivery ends when
    /// either is unavailable or the subscription is dropped.
    pub fn subscribe<Emitter, Evt>(
        &mut self,
        entity: &Entity<Emitter>,
        cx: &mut App,
        mut on_event: impl FnMut(Entity<Emitter>, &Evt, &mut Window, &mut App) + 'static,
    ) -> Subscription
    where
        Emitter: EventEmitter<Evt>,
        Evt: 'static,
    {
        let entity_id = entity.entity_id();
        let handle = entity.downgrade();
        let window_handle = self.handle;
        cx.new_subscription(
            entity_id,
            (
                TypeId::of::<Evt>(),
                Box::new(move |event, cx| {
                    window_handle
                        .update(cx, |_, window, cx| {
                            if let Some(entity) = handle.upgrade() {
                                let event = event.downcast_ref().expect("invalid event type");
                                on_event(entity, event, window, cx);
                                true
                            } else {
                                false
                            }
                        })
                        .unwrap_or(false)
                }),
            ),
        )
    }

    /// Registers a one-shot callback for release of `entity`.
    ///
    /// The callback receives the value being destroyed, after its last strong
    /// handle was dropped. This registration does not retain the entity.
    /// Keep the returned subscription until release; if this window has closed,
    /// the callback is skipped. Use [`App::observe_release`] for cleanup that
    /// must run independently of a window.
    pub fn observe_release<T>(
        &self,
        entity: &Entity<T>,
        cx: &mut App,
        mut on_release: impl FnOnce(&mut T, &mut Window, &mut App) + 'static,
    ) -> Subscription
    where
        T: 'static,
    {
        let entity_id = entity.entity_id();
        let window_handle = self.handle;
        let (subscription, activate) = cx.release_listeners.insert(
            entity_id,
            Box::new(move |entity, cx| {
                let entity = entity.downcast_mut().expect("invalid entity type");
                let _ = window_handle.update(cx, |_, window, cx| on_release(entity, window, cx));
            }),
        );
        activate();
        subscription
    }

    /// Creates an [`AsyncWindowContext`] that can be held across `await` points.
    ///
    /// The context retains neither the app nor this window. Its updates
    /// reacquire this same window by handle and return an error after it
    /// closes. See [`AsyncWindowContext::update`] for a complete example that
    /// also handles release of the entity being updated.
    pub fn to_async(&self, cx: &App) -> AsyncWindowContext {
        AsyncWindowContext::new_context(cx.to_async(), self.handle)
    }

    /// Runs `callback` at the next platform frame opportunity, before drawing.
    ///
    /// The callback receives a fresh window and app borrow. It can update and
    /// notify a view so that the ensuing draw uses the new state. Registration
    /// wakes the frame source even when the window is clean; the callback alone
    /// does not invalidate a view or guarantee a new draw or presentation.
    ///
    /// The callback runs once. A callback queued during delivery waits for a
    /// later frame opportunity. Closing the window discards pending callbacks.
    pub fn on_next_frame(&self, callback: impl FnOnce(&mut Window, &mut App) + 'static) {
        RefCell::borrow_mut(&self.next_frame_callbacks).push(Box::new(callback));
        self.platform_window.schedule_frame();
        // Next-frame callbacks create frame demand without dirtying the
        // window, so the platform's frame source must be woken explicitly.
        self.invalidator.wake_platform();
    }

    /// Notifies the view being drawn at the next frame opportunity.
    ///
    /// Call while rendering or drawing an element that needs another frame,
    /// such as a video player. The current view is notified at the next frame
    /// opportunity, even if its other state did not change. From an ordinary
    /// window callback, use [`on_next_frame`](Self::on_next_frame) and notify an
    /// explicitly captured entity instead.
    ///
    /// Callers driving purely decorative animations (spinners, pulses, and the
    /// like) should prefer [`AnimationExt::with_animation`](crate::AnimationExt::with_animation),
    /// which automatically respects [`App::reduce_motion`]. When using this
    /// method directly for decorative motion, check [`App::reduce_motion`]
    /// and skip the frame request when it is set.
    ///
    /// # Panics
    ///
    /// Panics when no view is being drawn. Debug builds also check that the
    /// window is in its prepaint or paint phase.
    pub fn request_animation_frame(&self) {
        let entity = self.current_view();
        self.on_next_frame(move |_, cx| cx.notify(entity));
    }

    /// Runs all callbacks scheduled via [`Self::on_next_frame`], returning how many ran.
    ///
    /// Tests have no platform frame loop, so this simulates the delivery of the
    /// next frame.
    #[cfg(any(test, feature = "headless"))]
    pub fn simulate_next_frame(&mut self, cx: &mut App) -> usize {
        let callbacks = self.next_frame_callbacks.take();
        let count = callbacks.len();
        for callback in callbacks {
            callback(self, cx);
        }
        count
    }

    /// Starts a task on the foreground executor with an asynchronous window context.
    ///
    /// Keep or await the returned task; dropping it cancels unfinished work.
    /// [`Task::detach`] lets it run independently. The context does not keep the
    /// window or app alive, so handle errors when reacquiring them after `await`.
    /// Move expensive `Send` work to [`App::background_spawn`] instead.
    #[track_caller]
    pub fn spawn<AsyncFn, R>(&self, cx: &App, f: AsyncFn) -> Task<R>
    where
        R: 'static,
        AsyncFn: AsyncFnOnce(&mut AsyncWindowContext) -> R + 'static,
    {
        let handle = self.handle;
        cx.spawn(async move |app| {
            let mut async_window_cx = AsyncWindowContext::new_context(app.clone(), handle);
            f(&mut async_window_cx).await
        })
    }

    /// Starts a window-aware foreground task; `priority` is currently ignored.
    ///
    /// Its lifetime and asynchronous window access follow [`spawn`](Self::spawn).
    /// Scheduling follows [`App::spawn_with_priority`], which treats every
    /// priority like an ordinary foreground task.
    #[track_caller]
    pub fn spawn_with_priority<AsyncFn, R>(
        &self,
        priority: Priority,
        cx: &App,
        f: AsyncFn,
    ) -> Task<R>
    where
        R: 'static,
        AsyncFn: AsyncFnOnce(&mut AsyncWindowContext) -> R + 'static,
    {
        let handle = self.handle;
        cx.spawn_with_priority(priority, async move |app| {
            let mut async_window_cx = AsyncWindowContext::new_context(app.clone(), handle);
            f(&mut async_window_cx).await
        })
    }

    /// Notify the window that its bounds have changed.
    ///
    /// This updates internal state like `viewport_size` and `scale_factor` from
    /// the platform window, then notifies observers. Normally called automatically
    /// by the platform's resize callback, but exposed publicly for test infrastructure.
    pub fn bounds_changed(&mut self, cx: &mut App) {
        self.scale_factor = self.platform_window.scale_factor();
        self.viewport_size = self.platform_window.content_size();
        self.display_id = self.platform_window.display().map(|display| display.id());
        self.mouse_position = self.platform_window.mouse_position();

        self.refresh();

        self.bounds_observers
            .clone()
            .retain(&(), |callback| callback(self, cx));
    }

    /// Return backend window geometry in logical pixels.
    ///
    /// The origin and decoration coverage depend on the window system; Wayland
    /// top-level windows and browser canvases do not expose an ordinary global
    /// desktop position. Use [`Self::viewport_size`] for layout inside this
    /// window and [`Self::window_bounds`] for restoration state. Element bounds
    /// are window-local and should not be offset by this rectangle's origin.
    pub fn bounds(&self) -> Bounds<Pixels> {
        self.platform_window.bounds()
    }

    /// Rasterizes the last built scene and returns its pixels as an RGBA image.
    ///
    /// This does not rebuild dirty views, advance animations, or present the
    /// result on screen. Call [`Self::draw`] and clear its arena token first
    /// when the image must include a pending state change. Dimensions are in
    /// device pixels and depend on the window's scale factor.
    ///
    /// Returns an error if the supplied platform renderer cannot perform
    /// readback or if rendering fails. The default simulated test window has
    /// no pixel renderer. See the
    /// [testing chapter](https://gpui-ce.github.io/book/testing.html#assert-drawing-before-comparing-pixels)
    /// for the distinction between inspecting primitives and comparing pixels.
    #[cfg(any(test, feature = "headless"))]
    pub fn render_to_image(&self) -> anyhow::Result<image::RgbaImage> {
        self.platform_window
            .render_to_image(&self.rendered_frame.scene)
    }

    /// Returns the current frame's quad and glyph sprite counts.
    #[cfg(any(test, feature = "headless"))]
    pub fn rendered_primitive_counts(&self) -> (usize, usize, usize, usize) {
        let scene = &self.rendered_frame.scene;
        (
            scene.quads.len(),
            scene.monochrome_sprites.len(),
            scene.subpixel_sprites.len(),
            scene.polychrome_sprites.len(),
        )
    }

    /// Returns the quads in the most recently rendered frame's scene, so tests can assert on
    /// painted output without rasterizing the frame. Quad bounds are in scaled pixels and are
    /// not clipped; each quad carries the content mask it will be clipped to when drawn. Quads
    /// whose bounds don't intersect their content mask are culled at paint time and won't appear.
    #[cfg(any(test, feature = "headless"))]
    pub fn painted_quads(&self) -> Vec<Quad> {
        self.rendered_frame.scene.quads.clone()
    }

    /// Requests a new content size in logical pixels.
    ///
    /// The platform may clamp or defer the resize. Read [`Self::viewport_size`]
    /// for the applied size, or retain a [`Context::observe_window_bounds`]
    /// subscription to respond to changes. [`Self::bounds_changed`] is the
    /// notification entry point, rather than an observation method.
    /// The browser backend sets the canvas's CSS size; it does not resize the
    /// page or an enclosing iframe.
    pub fn resize(&mut self, size: Size<Pixels>) {
        self.platform_window.resize(size);
    }

    /// Returns the fullscreen state last reported by the platform.
    ///
    /// [`Self::toggle_fullscreen`] requests a transition; this query need not
    /// change before that request returns. Browser requests can be denied.
    pub fn is_fullscreen(&self) -> bool {
        self.platform_window.is_fullscreen()
    }

    /// Returns whether the window is currently in simple (borderless) fullscreen,
    /// where it covers the entire screen including the menu bar and notch area.
    /// Always `false` on platforms other than macOS.
    pub fn is_simple_fullscreen(&self) -> bool {
        self.platform_window.is_simple_fullscreen()
    }

    pub(crate) fn appearance_changed(&mut self, cx: &mut App) {
        self.appearance = self.platform_window.appearance();

        self.appearance_observers
            .clone()
            .retain(&(), |callback| callback(self, cx));
    }

    pub(crate) fn button_layout_changed(&mut self, cx: &mut App) {
        self.button_layout_observers
            .clone()
            .retain(&(), |callback| callback(self, cx));
    }

    /// Returns the platform's light, dark, or vibrant appearance for this window.
    ///
    /// This is separate from [`Self::background_appearance`], which controls
    /// transparency and backdrop effects. Neither setting installs application
    /// colors. Use [`Self::observe_window_appearance`] to update a palette when
    /// the platform appearance changes; see the [`colors`](crate::colors) module.
    pub fn appearance(&self) -> WindowAppearance {
        self.appearance
    }

    /// Returns the drawable content size in logical pixels.
    ///
    /// Its window-local origin is `(0, 0)`. Use this for root layout and
    /// clipping; use [`Self::bounds`] for backend window geometry and
    /// [`Self::window_bounds`] for restoration state.
    pub fn viewport_size(&self) -> Size<Pixels> {
        self.viewport_size
    }

    /// Returns whether the platform considers this window active for keyboard input.
    ///
    /// This is separate from the selected element returned by [`Self::focused`].
    /// Deactivating a window preserves that element's focus identity. Use both
    /// when a control's focus styling should dim in an inactive window.
    pub fn is_window_active(&self) -> bool {
        self.active.get()
    }

    /// Returns the window-level hover flag on Windows, Linux, and FreeBSD.
    ///
    /// Other targets, including macOS and the browser, return
    /// [`Self::is_window_active`] instead. This does not hit-test an element;
    /// use [`Hitbox::is_hovered`] for a region in the current frame.
    pub fn is_window_hovered(&self) -> bool {
        if cfg!(any(
            target_os = "windows",
            target_os = "linux",
            target_os = "freebsd"
        )) {
            self.hovered.get()
        } else {
            self.is_window_active()
        }
    }

    /// Toggles the platform's zoom/maximize state.
    pub fn zoom_window(&self) {
        self.platform_window.zoom();
    }

    /// Open the native titlebar context menu at a logical window-local point.
    ///
    /// Useful for custom client-side decorations on Wayland and X11; unsupported backends may
    /// ignore the request.
    pub fn show_window_menu(&self, position: Point<Pixels>) {
        self.platform_window.show_window_menu(position)
    }

    /// Ask the native window manager to move the window from the current pointer gesture.
    ///
    /// Used by custom titlebars on Wayland, X11, and macOS. The window manager owns the move;
    /// GPUI may not receive pointer events until the operation ends.
    pub fn start_window_move(&self) {
        self.platform_window.start_window_move()
    }

    /// Set the logical-pixel inset occupied by invisible client-side decorations.
    ///
    /// Used by custom titlebars on Wayland and X11 to keep content aligned with the native frame.
    /// The value is also forwarded to the backend; `None` from [`Self::client_inset`] means no
    /// inset has been set through this API.
    pub fn set_client_inset(&mut self, inset: Pixels) {
        self.client_inset = Some(inset);
        self.platform_window.set_client_inset(inset);
    }

    /// Return the inset most recently set through [`Self::set_client_inset`], if any.
    pub fn client_inset(&self) -> Option<Pixels> {
        self.client_inset
    }

    /// Returns the backend's reported decoration mode.
    ///
    /// On Wayland and X11, use [`Decorations::Client`] and its tiling state to
    /// decide which titlebar and borders the application should draw. The
    /// reported mode can differ from the requested
    /// [`WindowOptions::window_decorations`]. Other backends can report the
    /// trait's default [`Decorations::Server`]; this is not a capability probe
    /// for every native control.
    pub fn window_decorations(&self) -> Decorations {
        self.platform_window.window_decorations()
    }

    /// Returns the `is_resizable` option supplied when this window was created.
    ///
    /// This is the requested policy, not a query of the native window manager.
    /// The backend or window role can restrict what is actually supported.
    pub fn is_resizable(&self) -> bool {
        self.is_resizable
    }

    /// Returns the `is_minimizable` option supplied when this window was created.
    ///
    /// This is the requested policy, not a native capability query. The browser,
    /// for example, has no minimization operation for its canvas window.
    pub fn is_minimizable(&self) -> bool {
        self.is_minimizable
    }

    /// Return the native window controls reported by the backend.
    ///
    /// This describes available controls; it does not imply that the application draws them.
    pub fn window_controls(&self) -> WindowControls {
        self.platform_window.window_controls()
    }

    /// Update the native window title and the window title exposed to accessibility.
    pub fn set_window_title(&mut self, title: &str) {
        self.platform_window.set_title(title);
        self.a11y.set_window_title(title.to_string());
    }

    /// Position macOS traffic-light buttons in logical window-local coordinates.
    #[cfg(target_os = "macos")]
    pub fn set_traffic_light_position(&self, position: Point<Pixels>) {
        self.platform_window.set_traffic_light_position(position);
    }

    /// Sets this window's desktop application identifier on Linux.
    ///
    /// Wayland uses it to associate the surface with a desktop entry; X11 sets
    /// both parts of `WM_CLASS`. Other supplied backends ignore the request.
    /// This does not change the window title or the application's process name.
    pub fn set_app_id(&mut self, app_id: &str) {
        self.platform_window.set_app_id(app_id);
    }

    /// Requests the window's transparency or native backdrop effect.
    ///
    /// Support depends on the backend and desktop compositor. This does not
    /// choose light or dark colors; [`Self::appearance`] reports that separate
    /// setting. Paint translucent content to reveal a transparent or blurred
    /// backdrop instead of covering it with an opaque root background.
    pub fn set_background_appearance(&self, background_appearance: WindowBackgroundAppearance) {
        self.platform_window
            .set_background_appearance(background_appearance);
    }

    /// Returns the platform background appearance used to choose text coverage.
    pub fn background_appearance(&self) -> WindowBackgroundAppearance {
        self.platform_window.background_appearance()
    }

    /// Sets the native indicator that this window's document has unsaved changes.
    ///
    /// The supplied macOS backend displays the document-edited state in its
    /// window controls. This does not invalidate a view, save a document, or
    /// prevent closing. Use [`Context::notify`](crate::Context::notify) for a
    /// state change and [`Self::on_window_should_close`] to guard unsaved work.
    /// Other native backends currently ignore this request.
    pub fn set_window_edited(&mut self, edited: bool) {
        self.platform_window.set_edited(edited);
    }

    /// Associate a document path with this window, or clear the association with `None`.
    ///
    /// The supplied macOS backend sets the represented filename; other native
    /// backends currently ignore the request. This neither opens the file nor
    /// changes the title. Pair it with [`Self::set_window_edited`] when the
    /// window represents a document.
    pub fn set_document_path(&self, path: Option<&std::path::Path>) {
        self.platform_window.set_document_path(path);
    }

    /// Returns the display currently associated with this window, if it can be identified.
    ///
    /// The result is resolved from the display ID last reported by the platform; it can be `None`
    /// before a resize/display-change notification or when the backend exposes no matching display.
    pub fn display(&self, cx: &App) -> Option<Rc<dyn PlatformDisplay>> {
        cx.platform
            .displays()
            .into_iter()
            .find(|display| Some(display.id()) == self.display_id)
    }

    /// Show the platform character palette.
    ///
    /// On macOS and Windows, opens the system character or emoji picker. On Linux,
    /// opens an installed desktop picker (Plasma, IBus, GNOME Characters, or
    /// KCharSelect); these pickers may require copying and pasting the selection.
    /// Logs a warning if the platform has no available picker.
    pub fn show_character_palette(&self) {
        self.platform_window.show_character_palette();
    }

    /// Returns the factor converting logical lengths to device-pixel lengths.
    ///
    /// At a factor of `2.0`, a 100-by-50 logical-pixel box occupies 200-by-100
    /// device pixels. Element bounds, pointer events, and style values remain
    /// in logical [`Pixels`]; GPUI applies this factor when painting.
    pub fn scale_factor(&self) -> f32 {
        self.scale_factor
    }

    /// Whether this platform can compose subpixel glyph coverage in the window.
    pub fn is_subpixel_rendering_supported(&self) -> bool {
        self.platform_window.is_subpixel_rendering_supported()
    }

    /// Overrides the display scale factor for tests.
    #[cfg(any(test, feature = "headless"))]
    pub fn set_scale_factor(&mut self, scale_factor: f32) {
        self.scale_factor = scale_factor;
        self.refresh();
    }

    /// Returns the logical-pixel size of one [`Rems`](crate::Rems) in this window.
    ///
    /// A temporary [`with_rem_size`](Self::with_rem_size) scope takes precedence
    /// over the base size. Pixel-valued styles are unaffected by this setting.
    pub fn rem_size(&self) -> Pixels {
        self.rem_size_override_stack
            .last()
            .copied()
            .unwrap_or(self.rem_size)
    }

    /// Sets the base logical-pixel size used to resolve [`Rems`](crate::Rems).
    ///
    /// Windows start at sixteen logical pixels per rem. Set a positive, finite
    /// value; this setter stores it without validation. A temporary
    /// [`with_rem_size`](Self::with_rem_size) override still takes precedence
    /// until its closure returns.
    ///
    /// This does not schedule a redraw. Call [`refresh`](Self::refresh) when
    /// changing it outside an update that already invalidates the window.
    /// See the [layout chapter](crate::_documentation::layout#choose-a-length-for-its-reference).
    pub fn set_rem_size(&mut self, rem_size: impl Into<Pixels>) {
        self.rem_size = rem_size.into();
    }

    /// Builds the full element ID for `element_id` and lends it to `f`.
    ///
    /// The ID includes the current parent ID stack. Use it for keyed state in
    /// the closure, or clone it when an owned key is needed. Its meaning belongs
    /// to this window and identity path; it is not a cross-window identifier.
    /// See [ownership and identity](crate::_ownership_and_data_flow#give-retained-element-state-an-identity).
    pub fn with_global_id<R>(
        &mut self,
        element_id: ElementId,
        f: impl FnOnce(&GlobalElementId, &mut Self) -> R,
    ) -> R {
        self.with_id(element_id, |this| {
            let global_id = GlobalElementId(Arc::from(&*this.element_id_stack));

            f(&global_id, this)
        })
    }

    /// Pushes `element_id` onto the element ID path for the duration of `f`.
    ///
    /// Nested calls build a [`GlobalElementId`](crate::GlobalElementId) from the full path. Use a
    /// stable value for the same logical element across frames and a distinct value for repeated
    /// siblings.
    #[inline]
    pub fn with_id<R>(
        &mut self,
        element_id: impl Into<ElementId>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.element_id_stack.push(element_id.into());
        let result = f(self);
        self.element_id_stack.pop();
        result
    }

    /// Runs `f` with a temporary logical-pixel size for one rem.
    ///
    /// `Some(size)` takes precedence over the base [`rem_size`](Self::rem_size)
    /// and any enclosing override. `None` preserves the current size. After
    /// the closure returns, the previous reference is active again.
    ///
    /// This changes rem resolution inside the closure; it does not recompute
    /// already-laid-out bounds or schedule another frame. Use it for custom
    /// prepaint and paint work. Calls outside those phases panic in debug builds.
    // This function is called in a highly recursive manner in editor
    // prepainting, make sure its inlined to reduce the stack burden
    #[inline]
    pub fn with_rem_size<F, R>(&mut self, rem_size: Option<impl Into<Pixels>>, f: F) -> R
    where
        F: FnOnce(&mut Self) -> R,
    {
        self.invalidator.debug_assert_paint_or_prepaint();

        if let Some(rem_size) = rem_size {
            self.rem_size_override_stack.push(rem_size.into());
            let result = f(self);
            self.rem_size_override_stack.pop();
            result
        } else {
            f(self)
        }
    }

    /// Resolves the inherited text style's line height to logical pixels.
    ///
    /// Relative lengths use the current font size and rem size. This is a
    /// style value, not the ascent or height of a particular shaped line.
    pub fn line_height(&self) -> Pixels {
        self.text_style().line_height_in_pixels(self.rem_size())
    }

    /// Snaps a logical-pixel value to the nearest device-pixel boundary.
    ///
    /// Halfway cases go toward zero. At a display scale of two, `px(10.75)`
    /// becomes 21.5 device pixels and snaps to 21, returned as `px(10.5)`.
    /// [`Pixels::round`] instead rounds to a whole logical pixel and sends
    /// halfway cases away from zero.
    ///
    /// Use this for crisp edges. The result remains in logical pixels, ready
    /// for layout or paint APIs; those methods apply the display scale.
    #[inline]
    pub fn pixel_snap(&self, value: Pixels) -> Pixels {
        px(round_to_device_pixel(value.0, self.scale_factor()) / self.scale_factor())
    }

    /// Snaps an `f64` logical-pixel value to the nearest device-pixel boundary.
    ///
    /// Like [`Self::pixel_snap`], this returns logical pixels and is useful when calculations
    /// need more precision than [`Pixels`] stores.
    #[inline]
    pub fn pixel_snap_f64(&self, value: f64) -> f64 {
        let scale_factor = f64::from(self.scale_factor());
        round_half_toward_zero_f64(value * scale_factor) / scale_factor
    }

    /// Snaps each coordinate of a logical-pixel rectangle to a device-pixel boundary.
    ///
    /// The origin and size are snapped independently. This does not independently
    /// snap the far edge; reconstruct bounds from snapped corners when that is
    /// required. The returned bounds remain in logical pixels.
    #[inline]
    pub fn pixel_snap_bounds(&self, bounds: Bounds<Pixels>) -> Bounds<Pixels> {
        bounds.map(|c| self.pixel_snap(c))
    }

    /// Snaps a logical-pixel point to device-pixel boundaries, returning logical pixels.
    #[inline]
    pub fn pixel_snap_point(&self, position: Point<Pixels>) -> Point<Pixels> {
        position.map(|c| self.pixel_snap(c))
    }

    #[inline]
    fn snap_bounds(&self, bounds: Bounds<Pixels>) -> Bounds<ScaledPixels> {
        let scale_factor = self.scale_factor();
        let left = round_to_device_pixel(bounds.left().0, scale_factor);
        let top = round_to_device_pixel(bounds.top().0, scale_factor);
        let right = round_to_device_pixel(bounds.right().0, scale_factor).max(left);
        let bottom = round_to_device_pixel(bounds.bottom().0, scale_factor).max(top);
        Bounds::from_corners(
            point(ScaledPixels(left), ScaledPixels(top)),
            point(ScaledPixels(right), ScaledPixels(bottom)),
        )
    }

    /// Rounds half-to-zero but clamps any non-zero input up to 1 dp so thin strokes do not disappear.
    #[inline]
    fn snap_stroke(&self, value: Pixels) -> ScaledPixels {
        ScaledPixels(round_stroke_to_device_pixel(value.0, self.scale_factor()))
    }

    #[inline]
    fn snap_border_widths(&self, edges: Edges<Pixels>) -> Edges<ScaledPixels> {
        edges.map(|e| self.snap_stroke(*e))
    }

    /// Floors the near edge and ceils the far edge, producing a strict superset of the raw region.
    #[inline]
    fn cover_bounds(&self, bounds: Bounds<Pixels>) -> Bounds<ScaledPixels> {
        let scale_factor = self.scale_factor();
        let left = floor_to_device_pixel(bounds.left().0, scale_factor);
        let top = floor_to_device_pixel(bounds.top().0, scale_factor);
        let right = ceil_to_device_pixel(bounds.right().0, scale_factor).max(left);
        let bottom = ceil_to_device_pixel(bounds.bottom().0, scale_factor).max(top);
        Bounds::from_corners(
            point(ScaledPixels(left), ScaledPixels(top)),
            point(ScaledPixels(right), ScaledPixels(bottom)),
        )
    }

    #[inline]
    fn snapped_content_mask(&self) -> ContentMask<ScaledPixels> {
        let mask = self.content_mask();
        ContentMask {
            bounds: self.cover_bounds(mask.bounds),
            fade_out: mask.fade_out.scale(self.scale_factor()),
        }
    }

    /// Prevents GPUI's default behavior for the current input event.
    ///
    /// For example, this can prevent a mouse-down focus change or claim a touch
    /// long press. It is separate from [`App::stop_propagation`] and does not
    /// cancel every browser or operating-system default.
    pub fn prevent_default(&mut self) {
        self.default_prevented = true;
    }

    /// Returns whether the current input event's default action has been prevented.
    ///
    /// The flag is reset between event dispatches. It is separate from stopping propagation.
    pub fn default_prevented(&self) -> bool {
        self.default_prevented
    }

    /// Checks for a listener accepting this action's type on the focused path.
    ///
    /// The search uses the last rendered dispatch tree, falling back to its
    /// root when the focused handle has no node. It does not check the action's
    /// fields, key bindings, or whether a handler will act on those fields.
    /// Global app listeners are not part of this window-tree search; use
    /// [`App::is_action_available`] when they should also count.
    pub fn is_action_available(&self, action: &dyn Action, cx: &App) -> bool {
        let node_id =
            self.focus_node_id_in_rendered_frame(self.focused(cx).map(|handle| handle.id));
        self.rendered_frame
            .dispatch_tree
            .is_action_available(action, node_id)
    }

    /// Checks action availability using the rendered dispatch path for `focus_handle`.
    ///
    /// This is useful for querying a candidate focus target without changing focus. If the handle
    /// has no node in the current frame, availability is checked from the root.
    /// Like [`Self::is_action_available`], it checks listener types rather than
    /// action values or key bindings and excludes global app listeners.
    pub fn is_action_available_in(&self, action: &dyn Action, focus_handle: &FocusHandle) -> bool {
        let node_id = self.focus_node_id_in_rendered_frame(Some(focus_handle.id));
        self.rendered_frame
            .dispatch_tree
            .is_action_available(action, node_id)
    }

    /// Returns the last recorded pointer position in logical window-local pixels.
    ///
    /// This is stored input state, not a fresh platform query. Touch and
    /// synthesized gesture events can also update it. Use an event's own
    /// position when handling that event.
    pub fn mouse_position(&self) -> Point<Pixels> {
        self.mouse_position
    }

    /// Makes a hitbox eligible for pointer handling even outside its bounds.
    ///
    /// [`HitboxId::is_hovered`] returns true for this ID despite clipping,
    /// occlusion, or keyboard modality. A custom drag can use that query in its
    /// move and release listeners. This does not filter raw listeners, make
    /// delivery exclusive, or request operating-system pointer capture outside
    /// the window. Scroll hit testing is unchanged.
    ///
    /// Capture names a hitbox record, not a retained element. Rebuilding the
    /// hitbox gives it a new ID: keep the active gesture on its owner and
    /// capture the newly inserted ID during subsequent prepaint passes.
    /// A reused cached hitbox retains its existing ID. A received mouse-up
    /// releases capture after listeners run; use [`Self::release_pointer`] when
    /// cancelling the gesture or removing its owner earlier.
    pub fn capture_pointer(&mut self, hitbox_id: HitboxId) {
        self.captured_hitbox = Some(hitbox_id);
    }

    /// Releases any active pointer capture.
    pub fn release_pointer(&mut self) {
        self.captured_hitbox = None;
    }

    /// Returns the hitbox that has captured the pointer, if any.
    pub fn captured_hitbox(&self) -> Option<HitboxId> {
        self.captured_hitbox
    }

    /// Records an entity as the owner of the current long press.
    ///
    /// The capture is released when the gesture ends or is cancelled, or when
    /// a replacement touch begins. A listener must also call
    /// [`Self::prevent_default`] on the started event to claim the gesture.
    ///
    /// This stores the entity's ID, without retaining a strong handle or
    /// changing event routing. Low-level listeners use
    /// [`Self::has_long_press_capture`] to accept later phases even outside the
    /// original hitbox. The [input chapter](crate::_documentation::input#claim-a-long-press)
    /// demonstrates that pattern across redraws and cancellation.
    pub fn capture_long_press<T: 'static>(&mut self, entity: &Entity<T>) {
        self.long_press_capture = Some(entity.entity_id());
    }

    /// Returns whether this entity's ID is the recorded long-press owner.
    ///
    /// Use this in the listener for `Moved`, `Ended`, and `Cancelled` phases.
    /// Ownership is cleared after dispatching a terminal event, so the owner
    /// can still recognize and clean up that event inside its callback.
    pub fn has_long_press_capture<T: 'static>(&self, entity: &Entity<T>) -> bool {
        self.long_press_capture == Some(entity.entity_id())
    }

    /// Returns the modifier state from the most recently received platform input.
    pub fn modifiers(&self) -> Modifiers {
        self.modifiers
    }

    /// Returns whether the last modality-changing input was a key-down event.
    ///
    /// Mouse moves and presses select mouse modality; raw touch selects touch
    /// modality. Other events, including modifier changes, leave it unchanged.
    /// [`InteractiveElement::focus_visible`](crate::InteractiveElement::focus_visible)
    /// uses this state for focus rings.
    pub fn last_input_was_keyboard(&self) -> bool {
        self.last_input_modality == InputModality::Keyboard
    }

    pub(crate) fn last_input_was_touch(&self) -> bool {
        self.last_input_modality == InputModality::Touch
    }

    /// Returns the Caps Lock state from the most recently received platform input.
    pub fn capslock(&self) -> Capslock {
        self.capslock
    }

    /// Builds the next frame and makes it the current rendered frame.
    ///
    /// This runs layout, prepaint, paint, focus notifications, and accessibility updates. It does
    /// not submit the scene to the native renderer; the platform frame loop presents it afterward.
    /// The returned arena token must be cleared through [`ArenaClearNeeded::clear`] before the
    /// app reuses the element arena. Test and benchmark callers that draw synchronously must also
    /// present the frame when they need renderer output.
    #[profiling::function]
    pub fn draw(&mut self, cx: &mut App) -> ArenaClearNeeded {
        // Drain every draw in profiler builds so a previous frame's
        // first-invalidation timestamp can't be attributed to this one.
        #[cfg(feature = "profiler")]
        let frame_dirty = self.invalidator.take_frame_dirty();
        #[cfg(feature = "profiler")]
        self.window_profiler.begin_draw();

        // Set up the per-App arena for element allocation during this draw.
        // This ensures that multiple test Apps have isolated arenas.
        let arena_scope = ElementArenaScope::enter(&cx.element_arena);

        self.invalidate_entities();
        cx.entities.clear_accessed();
        debug_assert!(self.rendered_entity_stack.is_empty());
        self.invalidator.set_dirty(false);
        self.requested_autoscroll = None;

        // Restore the previously-used input handler.
        // Place it back into a None slot (left by a previous .take()) so that
        // cached paint_range indices in reuse_paint find the handler at the
        // expected position.
        if let Some(input_handler) = self.platform_window.take_input_handler() {
            if let Some(slot) = self
                .rendered_frame
                .input_handlers
                .iter_mut()
                .rev()
                .find(|h| h.is_none())
            {
                *slot = Some(input_handler);
            } else {
                self.rendered_frame.input_handlers.push(Some(input_handler));
            }
        }
        if !cx.mode.skip_drawing() {
            self.draw_roots(cx);
            #[cfg(feature = "profiler")]
            {
                let viewport_size = self.viewport_size;
                let scale_factor = self.scale_factor();
                self.debug_frame_overlay.paint(
                    &mut self.next_frame.scene,
                    viewport_size,
                    scale_factor,
                );
            }
        }
        self.dirty_views.clear();
        self.next_frame.window_active = self.active.get();

        // Register requested input handler with the platform window.
        // Use .take() instead of .pop() to preserve Vec length, so that cached
        // paint_range indices remain valid for reuse_paint on the next frame.
        // Search backwards to find the last Some entry, since reuse_paint may
        // have copied None slots from the previous frame. (Fixes #50456)
        let focused_text_input_active = if let Some(mut input_handler) = self
            .next_frame
            .input_handlers
            .iter_mut()
            .rev()
            .find_map(|h| h.take())
        {
            let accepts_text_input = input_handler.accepts_text_input(self, cx);
            self.platform_window.set_input_handler(input_handler);
            accepts_text_input
        } else {
            false
        };
        self.apply_text_input_configuration(cx);
        if focused_text_input_active != self.focused_text_input_active {
            self.focused_text_input_active = focused_text_input_active;
            self.platform_window
                .text_input_state_changed(if focused_text_input_active {
                    TextInputStateChange::FocusGained
                } else {
                    TextInputStateChange::FocusLost
                });
        }

        self.layout_engine.as_mut().unwrap().clear();
        self.text_system().finish_frame();
        self.next_frame.finish(&mut self.rendered_frame);

        self.invalidator.set_phase(DrawPhase::Focus);
        let previous_focus_path = self.rendered_frame.focus_path();
        let previous_window_active = self.rendered_frame.window_active;
        mem::swap(&mut self.rendered_frame, &mut self.next_frame);
        self.next_frame.clear();
        let current_focus_path = self.rendered_frame.focus_path();
        let current_window_active = self.rendered_frame.window_active;
        let mut focus_before_listeners = self.focus;

        if previous_focus_path != current_focus_path
            || previous_window_active != current_window_active
        {
            if !previous_focus_path.is_empty() && current_focus_path.is_empty() {
                self.focus_lost_path = previous_focus_path.clone();
                self.focus_lost_listeners
                    .clone()
                    .retain(&(), |listener| listener(self, cx));
                self.focus_lost_path = SmallVec::new();
                // The focus-lost fallback (e.g. a workspace refocusing itself) may target
                // an element that isn't part of the element tree, in which case scheduling
                // a redraw below would dispatch focus-lost again, looping forever. Only
                // track focus movement caused by the focus listeners.
                focus_before_listeners = self.focus;
            }

            let event = WindowFocusEvent {
                previous_focus_path: if previous_window_active {
                    previous_focus_path
                } else {
                    Default::default()
                },
                current_focus_path: if current_window_active {
                    current_focus_path
                } else {
                    Default::default()
                },
            };
            self.focus_listeners
                .clone()
                .retain(&(), |listener| listener(&event, self, cx));
        }

        debug_assert!(self.rendered_entity_stack.is_empty());
        self.record_entities_accessed(cx);
        self.reset_cursor_style(cx);
        self.refreshing = false;
        self.invalidator.set_phase(DrawPhase::None);
        // Focus listeners may move focus (e.g. a dock forwarding focus to its active
        // panel). `Window::focus` suppresses `refresh` while a draw is in progress, so
        // schedule another frame here to render the new focus state and dispatch the
        // resulting focus events.
        if self.focus != focus_before_listeners {
            self.refresh();
        }
        self.needs_present.set(true);

        #[cfg(feature = "profiler")]
        {
            let draw_duration = self
                .window_profiler
                .end_draw(frame_dirty.dirty_at, frame_dirty.invalidations);
            self.debug_frame_overlay.record_frame(draw_duration);
        }

        // Exit the scope to obtain the arena-clear token this draw owes; the
        // scope's teardown itself happens in `ElementArenaScope::drop`.
        arena_scope.exit(&cx.element_arena)
    }

    fn record_entities_accessed(&mut self, cx: &mut App) {
        let mut entities_ref = cx.entities.accessed_entities.get_mut();
        let mut entities = mem::take(entities_ref.deref_mut());
        let handle = self.handle;
        cx.record_entities_accessed(
            handle,
            // Try moving window invalidator into the Window
            self.invalidator.clone(),
            &entities,
        );
        let mut entities_ref = cx.entities.accessed_entities.get_mut();
        mem::swap(&mut entities, entities_ref.deref_mut());
    }

    fn invalidate_entities(&mut self) {
        let mut views = self.invalidator.take_views();
        for entity in views.drain() {
            self.mark_view_dirty(entity);
        }
        self.invalidator.replace_views(views);
    }

    #[profiling::function]
    fn present(&mut self) {
        #[cfg(feature = "profiler")]
        let _foreground_turn = profiler::journal::foreground_turn();
        #[cfg(feature = "profiler")]
        let present_start = Instant::now();
        self.platform_window.draw(&self.rendered_frame.scene);
        #[cfg(feature = "profiler")]
        self.window_profiler.record_present(
            present_start,
            Instant::now(),
            self.active.get(),
            !self.next_frame_callbacks.borrow().is_empty(),
        );
        self.needs_present.set(false);
        profiling::finish_frame!();
    }

    /// Presents the most recently drawn frame if it hasn't been presented yet.
    ///
    /// Benchmarks drive drawing synchronously rather than through a platform
    /// frame-request loop, so they call this after each measured update to
    /// submit the frame like production presentation would.
    #[cfg(any(feature = "bench-support", all(test, feature = "profiler")))]
    pub fn present_if_needed(&mut self) {
        if self.needs_present.get() {
            self.present();
        }
    }

    /// Returns a snapshot of the current input-latency histograms.
    #[cfg(feature = "profiler")]
    pub fn input_latency_snapshot(&self) -> profiler::InputLatencySnapshot {
        self.window_profiler.input_latency_snapshot()
    }

    /// Returns a snapshot of the current frame-duration histograms.
    #[cfg(feature = "profiler")]
    pub fn frame_duration_snapshot(&self) -> profiler::FrameDurationSnapshot {
        self.window_profiler.frame_duration_snapshot()
    }

    /// Returns the current mode of the debug frame overlay.
    #[cfg(feature = "profiler")]
    pub fn debug_frame_overlay_mode(&self) -> DebugFrameOverlayMode {
        self.debug_frame_overlay.mode()
    }

    /// Sets the mode of the debug frame overlay and schedules a redraw.
    #[cfg(feature = "profiler")]
    pub fn set_debug_frame_overlay_mode(&mut self, mode: DebugFrameOverlayMode) {
        self.debug_frame_overlay.set_mode(mode);
        self.refresh();
    }

    /// Advances the debug frame overlay through its hidden, frame-time-only,
    /// and detailed modes.
    #[cfg(feature = "profiler")]
    pub fn cycle_debug_frame_overlay_mode(&mut self) {
        self.set_debug_frame_overlay_mode(self.debug_frame_overlay.mode().next());
    }

    /// Clears the debug frame overlay's frame-time statistics, except for the
    /// total frame count, and schedules a redraw.
    #[cfg(feature = "profiler")]
    pub fn reset_debug_frame_overlay_stats(&mut self) {
        self.debug_frame_overlay.reset_stats();
        self.refresh();
    }

    fn draw_roots(&mut self, cx: &mut App) {
        self.invalidator.set_phase(DrawPhase::Prepaint);
        self.tooltip_bounds.take();

        self.a11y.sync_active_flag();
        if self.a11y.is_active() {
            self.a11y.begin_frame();
        }

        let _inspector_width: Pixels = rems(30.0).to_pixels(self.rem_size());
        let root_size = {
            #[cfg(any(feature = "inspector", debug_assertions))]
            {
                if self.inspector.is_some() {
                    let mut size = self.viewport_size;
                    size.width = (size.width - _inspector_width).max(px(0.0));
                    size
                } else {
                    self.viewport_size
                }
            }
            #[cfg(not(any(feature = "inspector", debug_assertions)))]
            {
                self.viewport_size
            }
        };

        // Layout all root elements. Like the root element on the web, which
        // stretches to fill the viewport unless explicitly sized, window roots
        // fill the window when their size is `auto`.
        let scale_factor = self.scale_factor();
        let mut root_element = self.root.as_ref().unwrap().clone().into_any_element();
        let root_layout_id = root_element.request_layout(self, cx);
        self.layout_engine
            .as_mut()
            .unwrap()
            .stretch_auto_size_to_fill(root_layout_id, root_size, scale_factor);
        root_element.prepaint_as_root(Point::default(), root_size.into(), self, cx);

        #[cfg(any(feature = "inspector", debug_assertions))]
        let inspector_element = self.prepaint_inspector(_inspector_width, cx);

        self.prepaint_deferred_draws(cx);

        let mut prompt_element = None;
        let mut active_drag_element = None;
        let mut tooltip_element = None;
        if let Some(prompt) = self.prompt.take() {
            let mut element = prompt.view.any_view().into_any_element();
            let prompt_layout_id = element.request_layout(self, cx);
            self.layout_engine
                .as_mut()
                .unwrap()
                .stretch_auto_size_to_fill(prompt_layout_id, root_size, scale_factor);
            element.prepaint_as_root(Point::default(), root_size.into(), self, cx);
            prompt_element = Some(element);
            self.prompt = Some(prompt);
        } else if let Some(active_drag) = cx.active_drag.take() {
            let mut element = active_drag.view.clone().into_any_element();
            let offset = self.mouse_position() - active_drag.cursor_offset;
            element.prepaint_as_root(offset, AvailableSpace::min_size(), self, cx);
            active_drag_element = Some(element);
            cx.active_drag = Some(active_drag);
        } else {
            tooltip_element = self.prepaint_tooltip(cx);
        }

        self.mouse_hit_test = self.next_frame.hit_test(self.mouse_position);

        // Now actually paint the elements.
        self.invalidator.set_phase(DrawPhase::Paint);
        root_element.paint(self, cx);

        #[cfg(any(feature = "inspector", debug_assertions))]
        self.paint_inspector(inspector_element, cx);

        self.paint_deferred_draws(cx);

        if let Some(mut prompt_element) = prompt_element {
            prompt_element.paint(self, cx);
        } else if let Some(mut drag_element) = active_drag_element {
            drag_element.paint(self, cx);
        } else if let Some(mut tooltip_element) = tooltip_element {
            tooltip_element.paint(self, cx);
        }

        #[cfg(any(feature = "inspector", debug_assertions))]
        self.paint_inspector_hitbox(cx);

        // a11y may have been activated/deactivated halfway through the frame
        let a11y_active_start_of_frame = self.a11y.is_active();
        self.a11y.sync_active_flag();
        let a11y_active_end_of_frame = self.a11y.is_active();

        let should_send_a11y_update = a11y_active_start_of_frame && a11y_active_end_of_frame;

        if a11y_active_start_of_frame {
            // Harvest frame metadata for the debug dump while the live window
            // and frame are still in scope.
            let frame_info = crate::window::a11y::debug::FrameDebugInfo {
                viewport_size: self.viewport_size,
                scale_factor: self.scale_factor,
                tab_stop_count: self.next_frame.tab_stops.tab_stop_count(),
            };
            // clear the builder state regardless
            let tree_update = self.a11y.end_frame(frame_info);

            if should_send_a11y_update {
                log::debug!(
                    "Sending a11y tree update: {} nodes",
                    tree_update.nodes.len()
                );
                self.platform_window.a11y_tree_update(tree_update);
            }
        }
    }

    fn prepaint_tooltip(&mut self, cx: &mut App) -> Option<AnyElement> {
        // Use indexing instead of iteration to avoid borrowing self for the duration of the loop.
        for tooltip_request_index in (0..self.next_frame.tooltip_requests.len()).rev() {
            let Some(Some(tooltip_request)) = self
                .next_frame
                .tooltip_requests
                .get(tooltip_request_index)
                .cloned()
            else {
                log::error!("Unexpectedly absent TooltipRequest");
                continue;
            };
            let mut element = tooltip_request.tooltip.view.clone().into_any_element();
            let mouse_position = tooltip_request.tooltip.mouse_position;
            let tooltip_size = element.layout_as_root(AvailableSpace::min_size(), self, cx);

            let mut tooltip_bounds =
                Bounds::new(mouse_position + point(px(1.), px(1.)), tooltip_size);
            let window_bounds = Bounds {
                origin: Point::default(),
                size: self.viewport_size(),
            };

            if tooltip_bounds.right() > window_bounds.right() {
                let new_x = mouse_position.x - tooltip_bounds.size.width - px(1.);
                if new_x >= Pixels::ZERO {
                    tooltip_bounds.origin.x = new_x;
                } else {
                    tooltip_bounds.origin.x = cmp::max(
                        Pixels::ZERO,
                        tooltip_bounds.origin.x - tooltip_bounds.right() - window_bounds.right(),
                    );
                }
            }

            if tooltip_bounds.bottom() > window_bounds.bottom() {
                let new_y = mouse_position.y - tooltip_bounds.size.height - px(1.);
                if new_y >= Pixels::ZERO {
                    tooltip_bounds.origin.y = new_y;
                } else {
                    tooltip_bounds.origin.y = cmp::max(
                        Pixels::ZERO,
                        tooltip_bounds.origin.y - tooltip_bounds.bottom() - window_bounds.bottom(),
                    );
                }
            }

            // It's possible for an element to have an active tooltip while not being painted (e.g.
            // via the `visible_on_hover` method). Since mouse listeners are not active in this
            // case, instead update the tooltip's visibility here.
            let is_visible =
                (tooltip_request.tooltip.check_visible_and_update)(tooltip_bounds, self, cx);
            if !is_visible {
                continue;
            }

            self.with_absolute_element_offset(tooltip_bounds.origin, |window| {
                element.prepaint(window, cx)
            });

            self.tooltip_bounds = Some(TooltipBounds {
                id: tooltip_request.id,
                bounds: tooltip_bounds,
            });
            return Some(element);
        }
        None
    }

    fn prepaint_deferred_draws(&mut self, cx: &mut App) {
        assert_eq!(self.element_id_stack.len(), 0);

        // Process deferred draws in multiple rounds to support nesting.
        // Each round processes all current deferred draws, which may push new ones.
        //
        // The draws are processed in place rather than being moved out of
        // `next_frame.deferred_draws`: `prepaint_index` snapshots that vector's
        // length, so any prepaint range recorded during a round (view caches,
        // nested deferred draws) must index the same vector `reuse_prepaint`
        // slices on the next frame. Moving the draws out and re-appending them
        // shifts the indices of nested draws, causing reused subtrees to graft
        // the wrong deferred draws and panic in the dispatch tree.
        let mut round_start = 0;
        let mut depth = 0;
        loop {
            let round_end = self.next_frame.deferred_draws.len();
            if round_start == round_end {
                break;
            }
            // Limit maximum nesting depth to prevent infinite loops.
            assert!(depth < 10, "Exceeded maximum (10) deferred depth");
            depth += 1;

            // Sort this round by priority.
            let mut traversal_order = (round_start..round_end).collect::<SmallVec<[usize; 8]>>();
            traversal_order.sort_by_key(|ix| self.next_frame.deferred_draws[*ix].priority);

            for deferred_draw_ix in traversal_order {
                let (
                    priority,
                    element,
                    parent_node,
                    current_view,
                    rem_size,
                    absolute_offset,
                    content_mask,
                    prepaint_range,
                ) = {
                    let deferred_draw = &mut self.next_frame.deferred_draws[deferred_draw_ix];
                    self.element_id_stack
                        .clone_from(&deferred_draw.element_id_stack);
                    self.text_style_stack
                        .clone_from(&deferred_draw.text_style_stack);
                    (
                        deferred_draw.priority,
                        deferred_draw.element.take(),
                        deferred_draw.parent_node,
                        deferred_draw.current_view,
                        deferred_draw.rem_size,
                        deferred_draw.absolute_offset,
                        deferred_draw.content_mask,
                        deferred_draw.prepaint_range.clone(),
                    )
                };
                self.next_frame.dispatch_tree.set_active_node(parent_node);

                let prepaint_start = self.prepaint_index();
                if let Some(mut element) = element {
                    self.with_rendered_view(current_view, |window| {
                        window.with_content_mask(content_mask, |window| {
                            window.with_rem_size(Some(rem_size), |window| {
                                window.with_absolute_element_offset(absolute_offset, |window| {
                                    crate::DeferredPriorityStackCache::push(priority, cx);
                                    element.prepaint(window, cx);
                                    crate::DeferredPriorityStackCache::pop(cx);
                                });
                            });
                        });
                    });
                    self.next_frame.deferred_draws[deferred_draw_ix].element = Some(element);
                } else {
                    self.reuse_prepaint(prepaint_range);
                }
                let prepaint_end = self.prepaint_index();
                self.next_frame.deferred_draws[deferred_draw_ix].prepaint_range =
                    prepaint_start..prepaint_end;
            }

            self.element_id_stack.clear();
            self.text_style_stack.clear();
            round_start = round_end;
        }
    }

    fn paint_deferred_draws(&mut self, cx: &mut App) {
        assert_eq!(self.element_id_stack.len(), 0);

        // Paint all deferred draws in priority order.
        // Since prepaint has already processed nested deferreds, we just paint them all.
        if self.next_frame.deferred_draws.len() == 0 {
            return;
        }

        // Deferred draws are overlays (tooltips, popovers, drag images) and must sort above the
        // whole main scene. Raise the order floor so they do — this also keeps a deferred
        // backdrop's order from falling inside a content-filter order range left by the main scene.
        self.next_frame.scene.raise_order_floor();

        let traversal_order = self.deferred_draw_traversal_order();
        let mut deferred_draws = mem::take(&mut self.next_frame.deferred_draws);
        for deferred_draw_ix in traversal_order {
            let mut deferred_draw = &mut deferred_draws[deferred_draw_ix];
            self.element_id_stack
                .clone_from(&deferred_draw.element_id_stack);
            self.next_frame
                .dispatch_tree
                .set_active_node(deferred_draw.parent_node);

            let paint_start = self.paint_index();
            let content_mask = deferred_draw.content_mask;
            if let Some(element) = deferred_draw.element.as_mut() {
                self.with_rendered_view(deferred_draw.current_view, |window| {
                    window.with_content_mask(content_mask, |window| {
                        window.with_rem_size(Some(deferred_draw.rem_size), |window| {
                            element.paint(window, cx);
                        });
                    })
                })
            } else {
                self.reuse_paint(deferred_draw.paint_range.clone());
            }
            let paint_end = self.paint_index();
            deferred_draw.paint_range = paint_start..paint_end;
        }
        self.next_frame.deferred_draws = deferred_draws;
        self.element_id_stack.clear();
    }

    fn deferred_draw_traversal_order(&mut self) -> SmallVec<[usize; 8]> {
        let deferred_count = self.next_frame.deferred_draws.len();
        let mut sorted_indices = (0..deferred_count).collect::<SmallVec<[_; 8]>>();
        sorted_indices.sort_by_key(|ix| self.next_frame.deferred_draws[*ix].priority);
        sorted_indices
    }

    pub(crate) fn prepaint_index(&self) -> PrepaintStateIndex {
        PrepaintStateIndex {
            hitboxes_index: self.next_frame.hitboxes.len(),
            tooltips_index: self.next_frame.tooltip_requests.len(),
            deferred_draws_index: self.next_frame.deferred_draws.len(),
            dispatch_tree_index: self.next_frame.dispatch_tree.len(),
            accessed_element_states_index: self.next_frame.accessed_element_states.len(),
            line_layout_index: self.text_system.layout_index(),
        }
    }

    pub(crate) fn reuse_prepaint(&mut self, range: Range<PrepaintStateIndex>) {
        self.next_frame.hitboxes.extend(
            self.rendered_frame.hitboxes[range.start.hitboxes_index..range.end.hitboxes_index]
                .iter()
                .cloned(),
        );
        self.next_frame.tooltip_requests.extend(
            self.rendered_frame.tooltip_requests
                [range.start.tooltips_index..range.end.tooltips_index]
                .iter_mut()
                .map(|request| request.take()),
        );
        self.next_frame.accessed_element_states.extend(
            self.rendered_frame.accessed_element_states[range.start.accessed_element_states_index
                ..range.end.accessed_element_states_index]
                .iter()
                .map(|(id, type_id)| (id.clone(), *type_id)),
        );
        self.text_system
            .reuse_layouts(range.start.line_layout_index..range.end.line_layout_index);

        let reused_subtree = self.next_frame.dispatch_tree.reuse_subtree(
            range.start.dispatch_tree_index..range.end.dispatch_tree_index,
            &mut self.rendered_frame.dispatch_tree,
            self.focus,
        );

        if reused_subtree.contains_focus() {
            self.next_frame.focus = self.focus;
        }

        self.next_frame.deferred_draws.extend(
            self.rendered_frame.deferred_draws
                [range.start.deferred_draws_index..range.end.deferred_draws_index]
                .iter()
                .map(|deferred_draw| DeferredDraw {
                    current_view: deferred_draw.current_view,
                    parent_node: reused_subtree.refresh_node_id(deferred_draw.parent_node),
                    element_id_stack: deferred_draw.element_id_stack.clone(),
                    text_style_stack: deferred_draw.text_style_stack.clone(),
                    content_mask: deferred_draw.content_mask,
                    rem_size: deferred_draw.rem_size,
                    priority: deferred_draw.priority,
                    element: None,
                    absolute_offset: deferred_draw.absolute_offset,
                    prepaint_range: deferred_draw.prepaint_range.clone(),
                    paint_range: deferred_draw.paint_range.clone(),
                }),
        );
    }

    pub(crate) fn paint_index(&self) -> PaintIndex {
        PaintIndex {
            scene_index: self.next_frame.scene.len(),
            mouse_listeners_index: self.next_frame.mouse_listeners.len(),
            input_handlers_index: self.next_frame.input_handlers.len(),
            cursor_styles_index: self.next_frame.cursor_styles.len(),
            accessed_element_states_index: self.next_frame.accessed_element_states.len(),
            tab_handle_index: self.next_frame.tab_stops.paint_index(),
            line_layout_index: self.text_system.layout_index(),
        }
    }

    pub(crate) fn reuse_paint(&mut self, range: Range<PaintIndex>) {
        self.next_frame.cursor_styles.extend(
            self.rendered_frame.cursor_styles
                [range.start.cursor_styles_index..range.end.cursor_styles_index]
                .iter()
                .cloned(),
        );
        self.next_frame.input_handlers.extend(
            self.rendered_frame.input_handlers
                [range.start.input_handlers_index..range.end.input_handlers_index]
                .iter_mut()
                .map(|handler| handler.take()),
        );
        self.next_frame.mouse_listeners.extend(
            self.rendered_frame.mouse_listeners
                [range.start.mouse_listeners_index..range.end.mouse_listeners_index]
                .iter_mut()
                .map(|listener| listener.take()),
        );
        self.next_frame.accessed_element_states.extend(
            self.rendered_frame.accessed_element_states[range.start.accessed_element_states_index
                ..range.end.accessed_element_states_index]
                .iter()
                .map(|(id, type_id)| (id.clone(), *type_id)),
        );
        self.next_frame.tab_stops.replay(
            &self.rendered_frame.tab_stops.insertion_history
                [range.start.tab_handle_index..range.end.tab_handle_index],
        );

        self.text_system
            .reuse_layouts(range.start.line_layout_index..range.end.line_layout_index);
        self.next_frame.scene.replay(
            range.start.scene_index..range.end.scene_index,
            &self.rendered_frame.scene,
        );
    }

    /// Refines inherited text style for the duration of this drawing closure.
    ///
    /// [`Self::text_style`] combines the active refinements; fields omitted
    /// from `style` keep their inherited values. `None` leaves the stack alone.
    /// The scope ends when `f` returns. Call during prepaint or paint; using it
    /// outside those phases panics in debug builds.
    pub fn with_text_style<F, R>(&mut self, style: Option<TextStyleRefinement>, f: F) -> R
    where
        F: FnOnce(&mut Self) -> R,
    {
        self.invalidator.debug_assert_paint_or_prepaint();
        if let Some(style) = style {
            self.text_style_stack.push(style);
            let result = f(self);
            self.text_style_stack.pop();
            result
        } else {
            f(self)
        }
    }

    /// Records this hitbox's cursor style for the painted frame.
    ///
    /// At frame completion, the last eligible regional request wins unless a
    /// window-wide request overrides it. Eligibility follows hit testing and
    /// pointer capture, without keyboard-modality hover suppression. The
    /// native cursor is updated only while this window owns the cursor.
    /// Call during paint; using it in another phase panics in debug builds.
    pub fn set_cursor_style(&mut self, style: CursorStyle, hitbox: &Hitbox) {
        self.invalidator.debug_assert_paint();
        self.next_frame.cursor_styles.push(CursorStyleRequest {
            hitbox_id: Some(hitbox.id),
            style,
        });
    }

    /// Records a window-wide cursor override for the painted frame.
    ///
    /// The last window-wide request wins over every regional request from
    /// [`Self::set_cursor_style`], regardless of their relative order. The
    /// platform update happens at frame completion while the window owns the
    /// cursor. Call during paint; other phases panic in debug builds.
    pub fn set_window_cursor_style(&mut self, style: CursorStyle) {
        self.invalidator.debug_assert_paint();
        self.next_frame.cursor_styles.push(CursorStyleRequest {
            hitbox_id: None,
            style,
        })
    }

    /// Registers a tooltip for the upcoming frame during prepaint.
    ///
    /// The returned ID identifies this frame's request; it is not a persistent
    /// tooltip identity. Calling this outside prepaint panics in debug builds.
    pub fn set_tooltip(&mut self, tooltip: AnyTooltip) -> TooltipId {
        self.invalidator.debug_assert_prepaint();
        let id = TooltipId(post_inc(&mut self.next_tooltip_id.0));
        self.next_frame
            .tooltip_requests
            .push(Some(TooltipRequest { id, tooltip }));
        id
    }

    /// Intersects `mask` with the active clip while `f` runs.
    ///
    /// The bounds use logical, window-local pixels. `None` keeps the current
    /// clip; it does not remove an enclosing clip. The previous mask is
    /// restored when `f` returns.
    ///
    /// Apply the same mask during prepaint and paint when a region must clip
    /// both input and drawing. [`insert_hitbox`](Self::insert_hitbox) captures the prepaint
    /// mask; painting captures the paint mask. Neither changes layout or
    /// translates the supplied bounds. See the
    /// [coordinate guide](crate::_documentation::layout#keep-geometry-in-one-coordinate-space).
    /// Call during prepaint or paint; other phases panic in debug builds.
    // This function is called in a highly recursive manner in editor
    // prepainting, make sure its inlined to reduce the stack burden
    #[inline]
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-Window-with-content-mask-6cbe82e3.md")]
    // docs:examples:end
    pub fn with_content_mask<R>(
        &mut self,
        mask: Option<ContentMask<Pixels>>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.invalidator.debug_assert_paint_or_prepaint();
        if let Some(mask) = mask {
            let mask = mask.intersect(&self.content_mask());
            self.content_mask_stack.push(mask);
            let result = f(self);
            self.content_mask_stack.pop();
            result
        } else {
            f(self)
        }
    }

    /// Adds a logical-pixel offset to the current element offset for this prepaint scope.
    ///
    /// [`layout_bounds`](Self::layout_bounds) includes the resulting offset. Prepainting a
    /// child inside this scope therefore gives it shifted bounds for its
    /// hitboxes and later painting. This does not recompute layout, move the
    /// content mask, or translate coordinates passed directly to paint calls.
    /// Do not add the offset again to bounds returned by `layout_bounds`.
    ///
    /// Use [`with_absolute_element_offset`](Self::with_absolute_element_offset) to replace the current offset.
    /// Call during prepaint; other phases panic in debug builds.
    pub fn with_element_offset<R>(
        &mut self,
        offset: Point<Pixels>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.invalidator.debug_assert_prepaint();

        if offset.is_zero() {
            return f(self);
        };

        let abs_offset = self.element_offset() + offset;
        self.with_absolute_element_offset(abs_offset, f)
    }

    pub(crate) fn with_style_transition_containing_bounds<R>(
        &mut self,
        bounds: Bounds<Pixels>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.invalidator.debug_assert_prepaint();
        let previous_bounds = self.style_transition_containing_bounds.replace(bounds);
        let result = f(self);
        self.style_transition_containing_bounds = previous_bounds;
        result
    }

    pub(crate) fn style_transition_containing_bounds(&self) -> Option<Bounds<Pixels>> {
        self.style_transition_containing_bounds
    }

    /// Sets the element offset to `offset` for this prepaint scope, replacing the current offset.
    ///
    /// The point is a logical-pixel translation from the layout tree's origin,
    /// not the desired origin of a particular child. Bounds returned by
    /// [`Self::layout_bounds`] include this translation. The same coordinate
    /// rules as [`Self::with_element_offset`] apply; that method adds to the
    /// current offset instead. Call during prepaint.
    pub fn with_absolute_element_offset<R>(
        &mut self,
        offset: Point<Pixels>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.invalidator.debug_assert_prepaint();
        self.element_offset_stack.push(offset);
        let result = f(self);
        self.element_offset_stack.pop();
        result
    }

    pub(crate) fn with_element_opacity<R>(
        &mut self,
        opacity: Option<f32>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.invalidator.debug_assert_paint_or_prepaint();

        let Some(opacity) = opacity else {
            return f(self);
        };

        let previous_opacity = self.element_opacity;
        self.element_opacity = previous_opacity * opacity;
        let result = f(self);
        self.element_opacity = previous_opacity;
        result
    }

    /// Run prepaint work transactionally so it can be retried without keeping its frame records.
    ///
    /// If `f` returns `Err`, hitboxes, tooltip requests, deferred draws, dispatch nodes, accessed
    /// element-state records, and text layouts created by the closure are truncated. Other side
    /// effects, including mutations to entities or external state, are not rolled back. This is
    /// used by autoscrolling containers that prepaint once to measure, adjust an offset, then
    /// prepaint again. See [`crate::List`]. Only call during prepaint.
    pub fn transact<T, U>(&mut self, f: impl FnOnce(&mut Self) -> Result<T, U>) -> Result<T, U> {
        self.invalidator.debug_assert_prepaint();
        let index = self.prepaint_index();
        let result = f(self);
        if result.is_err() {
            self.next_frame.hitboxes.truncate(index.hitboxes_index);
            self.next_frame
                .tooltip_requests
                .truncate(index.tooltips_index);
            self.next_frame
                .deferred_draws
                .truncate(index.deferred_draws_index);
            self.next_frame
                .dispatch_tree
                .truncate(index.dispatch_tree_index);
            self.next_frame
                .accessed_element_states
                .truncate(index.accessed_element_states_index);
            self.text_system.truncate_layouts(index.line_layout_index);
        }
        result
    }

    /// Ask containing elements to scroll until these logical window-local bounds are visible.
    ///
    /// A scrollable ancestor can consume the request and retry prepaint after changing its
    /// offset, so the final frame may use a different position. Requests are frame-local and
    /// should be made during prepaint. See [`crate::List`] for a container that handles them.
    pub fn request_autoscroll(&mut self, bounds: Bounds<Pixels>) {
        self.invalidator.debug_assert_prepaint();
        self.requested_autoscroll = Some(bounds);
    }

    /// Take the pending child autoscroll request during prepaint.
    ///
    /// Taking it clears the request; containing elements such as [`crate::List`] use this to
    /// decide whether to adjust their scroll offset and retry child prepaint.
    pub fn take_autoscroll(&mut self) -> Option<Bounds<Pixels>> {
        self.invalidator.debug_assert_prepaint();
        self.requested_autoscroll.take()
    }

    /// Reads a cached asset, starting its load if this source has no cache entry.
    ///
    /// Returns `None` while loading; otherwise returns the cloned output,
    /// including any error represented by the asset's output type. Calls share
    /// the task stored by [`App::fetch_asset`]. Only the call that creates that
    /// entry arranges a notification for its current view when loading finishes.
    /// Other consumers need their own invalidation if they must update then.
    /// This includes a view reading an entry prefetched with `fetch_asset`:
    /// prefetching already created the entry, so `use_asset` adds no completion
    /// notification for that view.
    ///
    /// Call while drawing a view: a newly pending load needs the current view's
    /// identity. To manage loading outside drawing, use `fetch_asset` directly.
    pub fn use_asset<A: Asset>(&mut self, source: &A::Source, cx: &mut App) -> Option<A::Output> {
        let (task, is_first) = cx.fetch_asset::<A>(source);
        task.clone().now_or_never().or_else(|| {
            if is_first {
                let entity_id = self.current_view();
                self.spawn(cx, {
                    let task = task.clone();
                    async move |cx| {
                        task.await;

                        cx.on_next_frame(move |_, cx| {
                            cx.notify(entity_id);
                        });
                    }
                })
                .detach();
            }

            None
        })
    }

    /// Reads a cached asset, starting its load if necessary, without scheduling invalidation.
    ///
    /// Returns `None` while the shared load is pending. Unlike
    /// [`use_asset`](Self::use_asset), this never arranges a redraw on completion;
    /// the caller must provide that notification or poll on a later render.
    pub fn get_asset<A: Asset>(&mut self, source: &A::Source, cx: &mut App) -> Option<A::Output> {
        let (task, _) = cx.fetch_asset::<A>(source);
        task.now_or_never()
    }
    /// Returns the active logical window-local offset during prepaint.
    ///
    /// It is zero outside an offset scope. [`Self::layout_bounds`] already
    /// includes it; adding it again would shift the geometry twice. Use
    /// [`Self::with_element_offset`] to move a subtree relative to its current
    /// placement, or [`Self::with_absolute_element_offset`] to replace it.
    pub fn element_offset(&self) -> Point<Pixels> {
        self.invalidator.debug_assert_prepaint();
        self.element_offset_stack
            .last()
            .copied()
            .unwrap_or_default()
    }

    /// Obtain the current element opacity. This method should only be called during the
    /// prepaint phase of element drawing.
    #[inline]
    pub(crate) fn element_opacity(&self) -> f32 {
        self.invalidator.debug_assert_paint_or_prepaint();
        self.element_opacity
    }

    /// Returns the active clipping mask during prepaint or paint.
    ///
    /// Bounds and fade distances use logical window-local pixels. With no
    /// narrower scope, the mask covers the viewport. Use
    /// [`Self::with_content_mask`] to intersect a mask for child hitboxes and
    /// drawing; querying this method alone changes neither.
    pub fn content_mask(&self) -> ContentMask<Pixels> {
        self.invalidator.debug_assert_paint_or_prepaint();
        self.content_mask_stack
            .last()
            .cloned()
            .unwrap_or_else(|| ContentMask {
                bounds: Bounds {
                    origin: Point::default(),
                    size: self.viewport_size,
                },
                ..Default::default()
            })
    }

    /// Appends an identity scope for child drawing performed inside `f`.
    ///
    /// This has the same ID-stack behavior as [`Self::with_id`]. Use separate
    /// scopes when a custom element draws repeated groups whose children reuse
    /// local IDs. The scope creates no layout node, hitbox, or focus target.
    pub fn with_element_namespace<R>(
        &mut self,
        element_id: impl Into<ElementId>,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.element_id_stack.push(element_id.into());
        let result = f(self);
        self.element_id_stack.pop();
        result
    }

    /// Retains an entity under `key` within the current element identity scope.
    ///
    /// Calls `init` on first access and returns a clone of that entity's handle
    /// on later accesses. Notifications from the entity invalidate the view
    /// that created this retained state. Call during [`Render::render`],
    /// [`crate::RenderOnce::render`], or an element's drawing within a view.
    ///
    /// The window retains the entity while its state participates in consecutive
    /// frames, including reused cached drawing. If the key disappears, that
    /// retention ends. Other strong handles can keep the old entity alive, but
    /// reintroducing the key creates new state. Keep application data that must
    /// survive unmounting on a longer-lived entity instead.
    ///
    /// Keys are relative to their ID-bearing ancestors and are also separated
    /// by state type. Use a record's stable key for repeated items. See
    /// [ownership and identity](crate::_ownership_and_data_flow#give-retained-element-state-an-identity).
    ///
    /// # Panics
    ///
    /// Panics if no view is currently drawing. Debug builds also check the draw phase.
    pub fn use_keyed_state<S: 'static>(
        &mut self,
        key: impl Into<ElementId>,
        cx: &mut App,
        init: impl FnOnce(&mut Self, &mut Context<S>) -> S,
    ) -> Entity<S> {
        let current_view = self.current_view();
        self.with_global_id(key.into(), |global_id, window| {
            window.with_element_state(global_id, |state: Option<Entity<S>>, window| {
                if let Some(state) = state {
                    (state.clone(), state)
                } else {
                    let new_state = cx.new(|cx| init(window, cx));
                    cx.observe(&new_state, move |_, cx| {
                        cx.notify(current_view);
                    })
                    .detach();
                    (new_state.clone(), new_state)
                }
            })
        })
    }

    /// Calls [`Self::use_keyed_state`] using this call's Rust source location as its key.
    ///
    /// Repeated calls at the same location share a key within the same identity
    /// scope. A loop or helper that renders several controls therefore needs
    /// explicit keys or distinct parent scopes. An ID assigned to the returned
    /// element later does not scope this earlier call; use
    /// [`Self::use_keyed_state`] or wrap construction in [`Self::with_id`].
    /// All lifetime, notification, draw-phase, and panic rules follow
    /// `use_keyed_state`.
    #[track_caller]
    pub fn use_state<S: 'static>(
        &mut self,
        cx: &mut App,
        init: impl FnOnce(&mut Self, &mut Context<S>) -> S,
    ) -> Entity<S> {
        self.use_keyed_state(
            ElementId::CodeLocation(*core::panic::Location::caller()),
            cx,
            init,
        )
    }

    /// Takes an element's retained state, then stores the state returned by `f`.
    ///
    /// State is keyed by both the full [`GlobalElementId`] and `S`. The first
    /// call receives `None`; later calls in this draw or a consecutive frame
    /// receive the previously returned state. The tuple's first value is the
    /// result of this method; its second value becomes the retained state.
    ///
    /// Keep the ID stable when the same logical element is rebuilt. If its
    /// state is not accessed in a frame, GPUI discards it rather than saving it
    /// indefinitely for a later reappearance. This differs from [`Element`](crate::Element)'s
    /// associated phase states, which carry data only through the current draw.
    ///
    /// Call this while rendering or drawing an element. Use [`use_keyed_state`](Self::use_keyed_state)
    /// for retained entity state that should invalidate the view when notified.
    ///
    /// Do not recursively access the same ID and state type inside `f`: its
    /// value is temporarily outside the map, and an inner write would be
    /// replaced when `f` returns.
    ///
    /// # Panics
    ///
    /// Debug builds check that the window is in its prepaint or paint phase,
    /// which includes layout requests and view rendering.
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-Window-with-element-state-c1e1a057.md")]
    // docs:examples:end
    pub fn with_element_state<S, R>(
        &mut self,
        global_id: &GlobalElementId,
        f: impl FnOnce(Option<S>, &mut Self) -> (R, S),
    ) -> R
    where
        S: 'static,
    {
        self.invalidator.debug_assert_paint_or_prepaint();

        let key = (global_id.clone(), TypeId::of::<S>());
        self.next_frame.accessed_element_states.push(key.clone());

        if let Some(any) = self
            .next_frame
            .element_states
            .remove(&key)
            .or_else(|| self.rendered_frame.element_states.remove(&key))
        {
            let ElementStateBox {
                inner,
                #[cfg(debug_assertions)]
                type_name,
            } = any;
            // Using the extra inner option to avoid needing to reallocate a new box.
            let mut state_box = inner
                .downcast::<Option<S>>()
                .map_err(|_| {
                    #[cfg(debug_assertions)]
                    {
                        anyhow::anyhow!(
                            "invalid element state type for id, requested {:?}, actual: {:?}",
                            std::any::type_name::<S>(),
                            type_name
                        )
                    }

                    #[cfg(not(debug_assertions))]
                    {
                        anyhow::anyhow!(
                            "invalid element state type for id, requested {:?}",
                            std::any::type_name::<S>(),
                        )
                    }
                })
                .unwrap();

            let state = state_box.take().expect(
                "reentrant call to with_element_state for the same state type and element id",
            );
            let (result, state) = f(Some(state), self);
            state_box.replace(state);
            self.next_frame.element_states.insert(
                key,
                ElementStateBox {
                    inner: state_box,
                    #[cfg(debug_assertions)]
                    type_name,
                },
            );
            result
        } else {
            let (result, state) = f(None, self);
            self.next_frame.element_states.insert(
                key,
                ElementStateBox {
                    inner: Box::new(Some(state)),
                    #[cfg(debug_assertions)]
                    type_name: std::any::type_name::<S>(),
                },
            );
            result
        }
    }

    /// Reads retained state when an element has an ID, or runs without retention when it does not.
    ///
    /// `f` receives `None` without an ID, `Some(None)` on first access with an
    /// ID, and `Some(Some(state))` on later access. With an ID, return `Some`
    /// state or this method panics. Without an ID, return `None` state; debug
    /// builds check this. All other rules follow [`with_element_state`](Self::with_element_state).
    pub fn with_optional_element_state<S, R>(
        &mut self,
        global_id: Option<&GlobalElementId>,
        f: impl FnOnce(Option<Option<S>>, &mut Self) -> (R, Option<S>),
    ) -> R
    where
        S: 'static,
    {
        self.invalidator.debug_assert_paint_or_prepaint();

        if let Some(global_id) = global_id {
            self.with_element_state(global_id, |state, cx| {
                let (result, state) = f(Some(state), cx);
                let state =
                    state.expect("you must return some state when you pass some element id");
                (result, state)
            })
        } else {
            let (result, state) = f(None, self);
            debug_assert!(
                state.is_none(),
                "you must not return an element state when passing None for the global id"
            );
            result
        }
    }

    /// Creates a transition whose state is retained under this call site's identity.
    ///
    /// Like [`use_state`](Self::use_state), repeated calls at the same source
    /// location need distinct element namespaces. Use
    /// [`use_keyed_transition`](Self::use_keyed_transition) for repeated rows or
    /// multiple transitions created by one helper. The returned wrapper is new
    /// on each render; its animated entity state survives consecutive frames.
    /// This value-transition API does not apply reduced-motion preferences.
    #[track_caller]
    pub fn use_transition<T: Lerp + Clone + PartialEq + 'static>(
        &mut self,
        cx: &mut App,
        motion: impl Into<Motion>,
        init: impl Fn(&mut Window, &mut Context<TransitionState<T>>) -> T,
    ) -> Transition<T> {
        let motion = motion.into();
        let state = self.use_state(cx, |window, cx| {
            TransitionState::new(init(window, cx), motion.clone())
        });

        Transition::new(state, motion)
    }

    /// Creates a new keyed transition with persistent state.
    ///
    /// The key is scoped by the containing element IDs. Keep it stable for the
    /// same logical transition and distinct from its siblings. State survives
    /// consecutive frames in which it is accessed; omitting the element drops
    /// that retained reference. `init` runs only when state must be created.
    /// This value-transition API does not apply reduced-motion preferences.
    ///
    /// This method should only be called during `Render::render`, `RenderOnce::render`, or the drawing functions of `Element`.
    pub fn use_keyed_transition<T: Lerp + Clone + PartialEq + 'static>(
        &mut self,
        key: impl Into<ElementId>,
        cx: &mut App,
        motion: impl Into<Motion>,
        init: impl Fn(&mut Window, &mut Context<TransitionState<T>>) -> T,
    ) -> Transition<T> {
        let motion = motion.into();
        let state = self.use_keyed_state(key, cx, |window, cx| {
            TransitionState::new(init(window, cx), motion.clone())
        });

        Transition::new(state, motion)
    }

    /// Collect tab stops in a group with an optional ordering index.
    ///
    /// Lower indices sort before higher indices inside the group; `None` leaves the current tab
    /// group unchanged. The scope only affects tab navigation order in the frame being built.
    #[inline]
    pub fn with_tab_group<R>(&mut self, index: Option<isize>, f: impl FnOnce(&mut Self) -> R) -> R {
        if let Some(index) = index {
            self.next_frame.tab_stops.begin_group(index);
            let result = f(self);
            self.next_frame.tab_stops.end_group();
            result
        } else {
            f(self)
        }
    }

    /// Queues an already laid-out element for this frame's overlay pass.
    ///
    /// Prepaint and paint run after the main tree. Higher priorities paint
    /// above lower ones; equal priorities keep their registration order.
    /// `absolute_offset` replaces the element offset for deferred prepaint,
    /// in logical window-local pixels. The element keeps its identity scope,
    /// containing view, inherited text style for prepaint, and dispatch parent.
    /// Visual stacking does not move its keyboard listeners to another ancestry.
    ///
    /// Deferred drawing escapes the enclosing element's content mask. Supply
    /// `content_mask` to clip both its hitboxes and painted content; `None`
    /// leaves the overlay clipped only by the window. Use [`deferred`](crate::deferred) for the
    /// usual element wrapper. Call this during prepaint, after requesting the
    /// child's layout. Nested deferrals are limited to ten prepaint rounds.
    pub fn defer_draw(
        &mut self,
        element: AnyElement,
        absolute_offset: Point<Pixels>,
        priority: usize,
        content_mask: Option<ContentMask<Pixels>>,
    ) {
        self.invalidator.debug_assert_prepaint();
        let parent_node = self.next_frame.dispatch_tree.active_node_id().unwrap();
        self.next_frame.deferred_draws.push(DeferredDraw {
            current_view: self.current_view(),
            parent_node,
            element_id_stack: self.element_id_stack.clone(),
            text_style_stack: self.text_style_stack.clone(),
            content_mask,
            rem_size: self.rem_size(),
            priority,
            element: Some(element),
            absolute_offset,
            prepaint_range: PrepaintStateIndex::default()..PrepaintStateIndex::default(),
            paint_range: PaintIndex::default()..PaintIndex::default(),
        });
    }

    /// Groups drawing under one overlap-order region during paint.
    ///
    /// Ordinary primitives inside `f` share a draw-order key, allowing the
    /// renderer to batch them by primitive type. Keep those primitives
    /// non-overlapping when their relative order matters. The supplied bounds
    /// must cover their drawing, in logical window-local pixels.
    ///
    /// The layer bounds do not clip drawing and do not allocate an offscreen
    /// image. Use [`Self::with_content_mask`] for clipping and
    /// [`Self::with_filter_layer`] for filtered offscreen content. If the bounds
    /// miss the active mask, `f` still runs without opening a layer.
    pub fn paint_layer<R>(&mut self, bounds: Bounds<Pixels>, f: impl FnOnce(&mut Self) -> R) -> R {
        self.invalidator.debug_assert_paint();

        let content_mask = self.content_mask();
        let clipped_bounds = bounds.intersect(&content_mask.bounds);
        if !clipped_bounds.is_empty() {
            self.next_frame
                .scene
                .push_layer(self.cover_bounds(clipped_bounds));
        }

        let result = f(self);

        if !clipped_bounds.is_empty() {
            self.next_frame.scene.pop_layer();
        }

        result
    }

    /// Records a box's drop shadows.
    ///
    /// Paint them before the box's background. `bounds`, corner radii, and
    /// shadow lengths use logical window pixels. Each non-inset entry shifts
    /// the box's silhouette and applies its spread before
    /// blurring; the current content mask and element opacity apply. This
    /// changes drawing, not layout or hit testing.
    ///
    /// Inset entries are skipped. Paint those with [`Self::paint_inset_shadows`]
    /// after the background. [`Style::paint`] performs both passes in the
    /// usual order for styled elements. Call during paint; other phases
    /// panic in debug builds.
    pub fn paint_drop_shadows(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        shadows: &[BoxShadow],
    ) {
        self.paint_drop_shadows_with_corner_smoothing(bounds, corner_radii, 0.0, shadows);
    }

    /// Records drop shadows with smoothed corners.
    ///
    /// Supply a finite `corner_smoothing`; it is clamped to `0..=1`. Zero
    /// gives the ordinary drop-shadow behavior. Units, masking, opacity, and
    /// skipped inset entries follow `paint_drop_shadows`. Call during paint.
    pub fn paint_drop_shadows_with_corner_smoothing(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        corner_smoothing: f32,
        shadows: &[BoxShadow],
    ) {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let content_mask = self.snapped_content_mask();
        let opacity = self.element_opacity();
        let element_bounds = self.cover_bounds(bounds);
        let element_corner_radii = corner_radii.scale(scale_factor);
        let corner_smoothing = corner_smoothing.clamp(0.0, 1.0);
        for shadow in shadows {
            if shadow.inset {
                continue;
            }
            let shadow_bounds = (bounds + shadow.offset).dilate(shadow.spread_radius);
            self.next_frame.scene.insert_primitive(Shadow {
                order: 0,
                blur_radius: shadow.blur_radius.scale(scale_factor),
                bounds: self.cover_bounds(shadow_bounds),
                content_mask,
                corner_radii: corner_radii.scale(scale_factor),
                color: shadow.color.opacity(opacity),
                element_bounds,
                element_corner_radii,
                inset: false.into(),
                corner_smoothing,
            });
        }
    }

    /// Records the inset shadows for a box above its background.
    ///
    /// Paint the background first, then these shadows, then the contents.
    /// Positive spread shrinks each shadow's unshadowed hole; negative spread
    /// expands it. The result is confined to the box's rounded shape and the
    /// active content mask. Coordinates and shadow lengths use logical pixels,
    /// and the active element opacity applies.
    ///
    /// Drop-shadow entries are skipped; send those to [`Self::paint_drop_shadows`]
    /// before the background. [`Style::paint`] handles this ordering for styled
    /// elements. Call during paint; other phases panic in debug builds.
    pub fn paint_inset_shadows(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        shadows: &[BoxShadow],
    ) {
        self.paint_inset_shadows_with_corner_smoothing(bounds, corner_radii, 0.0, shadows);
    }

    /// Records inset shadows with smoothed corners.
    ///
    /// Supply a finite `corner_smoothing`; it is clamped to `0..=1`. Zero
    /// gives the ordinary inset-shadow behavior. Units, masking, opacity, and
    /// skipped drop-shadow entries follow `paint_inset_shadows`. Call during paint.
    pub fn paint_inset_shadows_with_corner_smoothing(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        corner_smoothing: f32,
        shadows: &[BoxShadow],
    ) {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let content_mask = self.snapped_content_mask();
        let opacity = self.element_opacity();
        let element_bounds = self.cover_bounds(bounds);
        let element_corner_radii = corner_radii.scale(scale_factor);
        let corner_smoothing = corner_smoothing.clamp(0.0, 1.0);
        for shadow in shadows {
            if !shadow.inset {
                continue;
            }
            let hole = (bounds + shadow.offset).dilate(-shadow.spread_radius);
            // Clamp at zero so a large spread can't produce negative radii, which would
            // break the SDF in the shader.
            let zero = Pixels::ZERO;
            let hole_corner_radii = Corners {
                top_left: (corner_radii.top_left - shadow.spread_radius).max(zero),
                top_right: (corner_radii.top_right - shadow.spread_radius).max(zero),
                bottom_right: (corner_radii.bottom_right - shadow.spread_radius).max(zero),
                bottom_left: (corner_radii.bottom_left - shadow.spread_radius).max(zero),
            };
            self.next_frame.scene.insert_primitive(Shadow {
                order: 0,
                blur_radius: shadow.blur_radius.scale(scale_factor),
                bounds: self.cover_bounds(hole),
                content_mask,
                corner_radii: hole_corner_radii.scale(scale_factor),
                color: shadow.color.opacity(opacity),
                element_bounds,
                element_corner_radii,
                inset: true.into(),
                corner_smoothing,
            });
        }
    }

    /// Blurs already-painted content behind a rounded rectangle.
    ///
    /// Call after painting the backdrop and before painting the panel's own
    /// translucent background and sharp contents. An opaque fill covers the
    /// effect. `bounds` and radii use logical window pixels; the active mask
    /// and element opacity apply to the filtered result. This does not change
    /// layout, clip later drawing, or blur content painted afterward.
    ///
    /// An empty or all-identity list records nothing. The supplied renderers
    /// use the largest blur radius for one operation, rather than applying
    /// each entry successively. Use [`Self::with_filter_layer`] to blur the
    /// drawing produced by a closure instead. The
    /// [drawing chapter](crate::_documentation::drawing#choose-which-pixels-to-blur)
    /// shows the paint order. Call during paint; other phases panic in debug builds.
    pub fn paint_backdrop_filter(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        filters: &[Filter],
    ) {
        self.paint_backdrop_filter_with_corner_smoothing(bounds, corner_radii, 0.0, filters);
    }

    /// Blurs the already-painted backdrop with smoothed corners.
    ///
    /// Supply a finite `corner_smoothing`; it is clamped to `0..=1`. Zero
    /// gives the ordinary rounded rectangle. Units, paint order, masking,
    /// opacity, and filter-list behavior follow `paint_backdrop_filter`.
    /// Call during paint.
    pub fn paint_backdrop_filter_with_corner_smoothing(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        corner_smoothing: f32,
        filters: &[Filter],
    ) {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let filters: SmallVec<[ScaledFilter; 4]> = filters
            .iter()
            .filter(|filter| !filter.is_identity())
            .map(|filter| filter.scale(scale_factor))
            .collect();
        if filters.is_empty() {
            return;
        }

        self.next_frame.scene.insert_primitive(BackdropFilter {
            order: 0,
            bounds: self.snap_bounds(bounds),
            content_mask: self.snapped_content_mask(),
            corner_radii: corner_radii.scale(scale_factor),
            corner_smoothing: corner_smoothing.clamp(0.0, 1.0),
            filters,
            opacity: self.element_opacity(),
        });
    }

    /// Blurs the drawing performed by `f` as one content group.
    ///
    /// The renderer draws the group into an offscreen target, filters it,
    /// and composites it into the rounded rectangle described by `bounds`
    /// and `corner_radii`. Those values use logical window pixels. The active
    /// content mask clips the composite; layout and hit testing are unchanged.
    /// For ordinary styled elements, [`Styled::blur`](crate::Styled::blur)
    /// supplies this grouping.
    ///
    /// Active element opacity is applied to each primitive painted by `f`;
    /// the composite does not apply that same opacity a second time. An empty
    /// or all-identity filter list simply runs `f`. Otherwise, the supplied
    /// renderers use the list's largest blur radius for one operation.
    ///
    /// > [!WARNING]
    /// > The current limit is two nested content groups
    /// > ([`MAX_FILTER_GROUP_DEPTH`](crate::MAX_FILTER_GROUP_DEPTH)). Deeper groups draw
    /// > inline without their own blur, although an enclosing group's blur
    /// > still affects them. Avoid relying on a separate filter at those depths.
    ///
    /// Use [`Self::paint_backdrop_filter`] to soften previously painted content
    /// while leaving a panel's own contents sharp. See the
    /// [drawing chapter](crate::_documentation::drawing#choose-which-pixels-to-blur).
    /// Call during paint; other phases panic in debug builds.
    pub fn with_filter_layer<R>(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        filters: &[Filter],
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.with_filter_layer_with_corner_smoothing(bounds, corner_radii, 0.0, filters, f)
    }

    /// Blurs a content group with smoothed composite corners.
    ///
    /// Supply a finite `corner_smoothing`; it is clamped to `0..=1`. Zero
    /// gives the ordinary rounded rectangle. The filter list, opacity,
    /// masking, and nesting limit follow `with_filter_layer`. Call during paint.
    pub fn with_filter_layer_with_corner_smoothing<R>(
        &mut self,
        bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        corner_smoothing: f32,
        filters: &[Filter],
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let filters: SmallVec<[ScaledFilter; 4]> = filters
            .iter()
            .filter(|filter| !filter.is_identity())
            .map(|filter| filter.scale(scale_factor))
            .collect();
        if filters.is_empty() {
            return f(self);
        }

        // Snapshot the (scaled) group parameters once so the start and end markers agree.
        //
        // `opacity` is 1.0 — NOT `element_opacity()`. The group's children/bg/border are painted
        // through the normal paint methods while `element_opacity` is still in effect, so they
        // already carry the element's opacity (consistent with gpui's per-primitive opacity for
        // non-filtered elements). Re-applying it at composite time would double it (e.g.
        // `.blur(r).opacity(0.5)` would render at 0.25 instead of 0.5).
        let boundary = FilterBoundary {
            order: 0,
            bounds: self.snap_bounds(bounds),
            content_mask: self.snapped_content_mask(),
            corner_radii: corner_radii.scale(scale_factor),
            corner_smoothing: corner_smoothing.clamp(0.0, 1.0),
            filters,
            opacity: 1.0,
            is_start: true,
        };

        self.next_frame.scene.insert_primitive(boundary.clone());
        let result = f(self);
        self.next_frame.scene.insert_primitive(FilterBoundary {
            is_start: false,
            ..boundary
        });

        result
    }

    fn largest_border_interior(quad: &Quad) -> Bounds<ScaledPixels> {
        let radii = &quad.corner_radii;
        let widths = &quad.border_widths;
        let reach_factor = 1.0 + quad.corner_smoothing;
        let edge_reaches = Edges {
            top: radii.top_left.max(radii.top_right) * reach_factor,
            right: radii.top_right.max(radii.bottom_right) * reach_factor,
            bottom: radii.bottom_left.max(radii.bottom_right) * reach_factor,
            left: radii.top_left.max(radii.bottom_left) * reach_factor,
        };

        let antialias_inset = point(ScaledPixels(1.0), ScaledPixels(1.0));
        let inset_bounds = |top_left_inset, bottom_right_inset| {
            Bounds::from_corners(
                quad.bounds.origin + top_left_inset + antialias_inset,
                quad.bounds.bottom_right() - bottom_right_inset - antialias_inset,
            )
        };

        // Rounded corners need only be excluded on one axis. Either candidate
        // is empty of border pixels, so use the larger interior.
        let horizontal_band = inset_bounds(
            point(widths.left, widths.top.max(edge_reaches.top)),
            point(widths.right, widths.bottom.max(edge_reaches.bottom)),
        );
        let vertical_band = inset_bounds(
            point(widths.left.max(edge_reaches.left), widths.top),
            point(widths.right.max(edge_reaches.right), widths.bottom),
        );

        let area = |bounds: &Bounds<ScaledPixels>| {
            bounds.size.width.0.max(0.) * bounds.size.height.0.max(0.)
        };
        if area(&horizontal_band) >= area(&vertical_band) {
            horizontal_band
        } else {
            vertical_band
        }
    }

    /// Records a filled and bordered rectangle in the current stacking context.
    ///
    /// Quad bounds are logical window-local pixels. GPUI snaps them to the device-pixel grid,
    /// applies the current content mask and element opacity, and records them for presentation.
    /// Use [`fill`], [`outline`], or [`quad`] to construct a quad.
    ///
    /// This method should only be called as part of the paint phase of element drawing.
    ///
    /// Corner radii can exceed the bounds, creating sharp joins where the
    /// circular arcs meet; dashed borders can then look irregular. Use
    /// [`Corners::clamp_radii_for_quad_size`] when the radii should fit the box.
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-Window-paint-quad-572d1922.md")]
    // docs:examples:end
    pub fn paint_quad(&mut self, quad: PaintQuad) {
        self.paint_quad_with_corner_smoothing(quad, 0.0);
    }

    /// Uploads a captured scene's bitmap resources into this window's atlas.
    ///
    /// Retain `resources` between imports to reuse identical pixels, and keep
    /// the returned [`ImportedScene`](crate::ImportedScene) alive while painting it.
    /// Dropping the last imported scene that uses a resource releases its atlas
    /// allocation; the resource cache holds only weak references.
    ///
    /// Returns an error for an invalid capture or a failed atlas upload. Import
    /// before calling [`paint_scene`](Self::paint_scene); importing alone draws
    /// nothing and installs no input listeners.
    pub fn import_scene_capture(
        &mut self,
        capture: &crate::SceneCapture,
        resources: &mut crate::SceneResources,
    ) -> Result<crate::ImportedScene> {
        resources.import(capture, self.sprite_atlas.clone())
    }

    /// Paints an imported GPUI scene through this window's normal renderer.
    ///
    /// `source_scale_factor` is the display density used when the source window
    /// drew the scene. GPUI converts it to this window's density and translates
    /// logical coordinates to `destination.origin`. The destination size clips
    /// the scene; it does not stretch it to fill the rectangle. The ancestor
    /// content mask and current element opacity also apply.
    ///
    /// Call during an element's paint phase, like [`paint_quad`](Self::paint_quad).
    /// Input routing and focus remain the embedding element's responsibility.
    /// Returns an error if the resulting density ratio is not positive and
    /// finite. Debug builds panic when called outside paint.
    pub fn paint_scene(
        &mut self,
        scene: &crate::ImportedScene,
        destination: Bounds<Pixels>,
        source_scale_factor: f32,
    ) -> Result<()> {
        self.invalidator.debug_assert_paint();
        let snapped = self.snap_bounds(destination);
        let ancestor = self.snapped_content_mask();
        let clip = ancestor.intersect(&ContentMask {
            bounds: snapped,
            fade_out: Edges::default(),
        });
        self.next_frame.scene.append_imported(
            scene,
            snapped.origin,
            self.scale_factor() / source_scale_factor,
            clip,
            self.element_opacity(),
        )
    }

    /// Records `quad` with the requested corner-smoothing fraction.
    ///
    /// Supply a finite value; values below zero or above one are clamped to
    /// that range. Zero is the ordinary [`Self::paint_quad`] behavior. The
    /// current content mask and element opacity apply to both fill and border.
    /// Call during paint; another phase panics in debug builds.
    pub fn paint_quad_with_corner_smoothing(&mut self, quad: PaintQuad, corner_smoothing: f32) {
        self.invalidator.debug_assert_paint();

        let opacity = self.element_opacity();
        let snapped_bounds = self.snap_bounds(quad.bounds);
        let snapped_border_widths = self.snap_border_widths(quad.border_widths);
        let quad = Quad {
            order: 0,
            bounds: snapped_bounds,
            content_mask: self.snapped_content_mask(),
            background: quad.background.opacity(opacity),
            border_color: quad.border_color.opacity(opacity),
            corner_radii: quad.corner_radii.scale(self.scale_factor()),
            border_widths: snapped_border_widths,
            border_style: quad.border_style,
            border_dashed_length: quad.border_dashed_length,
            border_dashed_gap: quad.border_dashed_gap,
            corner_smoothing: corner_smoothing.clamp(0.0, 1.0),
            padding: 0,
        };

        if !quad.background.is_transparent() {
            self.next_frame.scene.insert_primitive(quad);
            return;
        }

        // Splitting a border-only quad around its empty interior avoids shading
        // every transparent pixel inside large outlines.
        let outer_bounds = quad.bounds;
        let inner_bounds = Self::largest_border_interior(&quad);

        if inner_bounds.is_empty() {
            self.next_frame.scene.insert_primitive(quad);
            return;
        }

        let strips = [
            // Top
            Bounds::from_corners(
                outer_bounds.origin,
                point(outer_bounds.right(), inner_bounds.top()),
            ),
            // Bottom
            Bounds::from_corners(
                point(outer_bounds.left(), inner_bounds.bottom()),
                outer_bounds.bottom_right(),
            ),
            // Left
            Bounds::from_corners(
                point(outer_bounds.left(), inner_bounds.top()),
                inner_bounds.bottom_left(),
            ),
            // Right
            Bounds::from_corners(
                inner_bounds.top_right(),
                point(outer_bounds.right(), inner_bounds.bottom()),
            ),
        ];

        for strip in strips {
            let content_mask_bounds = quad.content_mask.bounds.intersect(&strip);
            if !content_mask_bounds.is_empty() {
                self.next_frame.scene.insert_primitive(Quad {
                    content_mask: ContentMask {
                        bounds: content_mask_bounds,
                        ..Default::default()
                    },
                    ..quad
                });
            }
        }
    }

    /// Records a tessellated path in the current stacking context.
    ///
    /// The path's vertices and bounds use logical window coordinates. This
    /// replaces its stored color and content mask with `color` and the current
    /// mask, applies element opacity, and scales it for the renderer. Construct
    /// the path with [`PathBuilder`](crate::PathBuilder); do not pre-scale it
    /// for display density. Call during paint; other phases panic in debug builds.
    pub fn paint_path(&mut self, mut path: Path<Pixels>, color: impl Into<Background>) {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let content_mask = self.content_mask();
        let opacity = self.element_opacity();
        path.content_mask = content_mask;
        let color: Background = color.into();
        path.color = color.opacity(opacity);
        self.next_frame
            .scene
            .insert_primitive(path.scale(scale_factor));
    }

    /// Records an underline whose upper-left corner is `origin`.
    ///
    /// Coordinates, width, and thickness use logical pixels; GPUI snaps them
    /// to device pixels. The caller chooses the vertical position from its
    /// font metrics. A wavy underline occupies three times the snapped
    /// thickness. `style.color = None` uses [`Hsla::default`], rather than
    /// resolving the inherited text color. The content mask and element
    /// opacity still apply. Call during paint; other phases panic in debug builds.
    pub fn paint_underline(
        &mut self,
        origin: Point<Pixels>,
        width: Pixels,
        style: &UnderlineStyle,
    ) {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let thickness = self.snap_stroke(style.thickness);
        let height = if style.wavy {
            ScaledPixels(thickness.0 * 3.)
        } else {
            thickness
        };
        let bounds = Bounds {
            origin: origin.map(|c| ScaledPixels(round_to_device_pixel(c.0, scale_factor))),
            size: size(self.snap_stroke(width), height),
        };
        let element_opacity = self.element_opacity();

        self.next_frame.scene.insert_primitive(Underline {
            order: 0,
            padding: 0,
            bounds,
            content_mask: self.snapped_content_mask(),
            color: style
                .color
                .unwrap_or_default()
                .opacity(element_opacity)
                .into(),
            thickness,
            wavy: style.wavy.into(),
        });
    }

    /// Records a straight strikethrough whose upper-left corner is `origin`.
    ///
    /// Coordinates, width, and thickness use logical pixels; the caller
    /// chooses the vertical position from its font metrics. As with
    /// [`Self::paint_underline`], an absent color uses [`Hsla::default`] and
    /// the current mask and opacity apply. Call during paint; other phases
    /// panic in debug builds.
    pub fn paint_strikethrough(
        &mut self,
        origin: Point<Pixels>,
        width: Pixels,
        style: &StrikethroughStyle,
    ) {
        self.invalidator.debug_assert_paint();

        let scale_factor = self.scale_factor();
        let height = style.thickness;
        let bounds = Bounds {
            origin: origin.map(|c| ScaledPixels(round_to_device_pixel(c.0, scale_factor))),
            size: size(self.snap_stroke(width), self.snap_stroke(height)),
        };
        let opacity = self.element_opacity();

        self.next_frame.scene.insert_primitive(Underline {
            order: 0,
            padding: 0,
            bounds,
            content_mask: self.snapped_content_mask(),
            thickness: self.snap_stroke(style.thickness),
            color: style.color.unwrap_or_default().opacity(opacity).into(),
            wavy: false.into(),
        });
    }

    /// Records a glyph that has already been shaped for `font_id`.
    ///
    /// `origin` is the glyph's logical window-coordinate pen position, with
    /// `origin.y` at the baseline; it is not the raster bitmap's top-left
    /// corner. `glyph_id` belongs to the supplied font, not to a Unicode code
    /// point. This method does not perform shaping or font fallback.
    ///
    /// Prefer [`ShapedLine::paint`](crate::ShapedLine::paint) or
    /// [`ShapedText::paint`](crate::ShapedText::paint) for ordinary text. GPUI
    /// chooses grayscale or subpixel coverage from the window and font
    /// settings, and caches rasterized pixels in this window's atlas. An empty
    /// raster, such as a space, records no sprite and succeeds. Rasterization
    /// and atlas errors are returned. Call during paint; other phases panic
    /// in debug builds.
    pub fn paint_glyph(
        &mut self,
        origin: Point<Pixels>,
        font_id: FontId,
        glyph_id: GlyphId,
        font_size: Pixels,
        color: Hsla,
    ) -> Result<()> {
        self.invalidator.debug_assert_paint();

        let element_opacity = self.element_opacity();
        let (integer_origin, request) =
            self.glyph_raster_request(origin, font_id, glyph_id, font_size, color, false);
        let raster_style = self
            .text_system()
            .prepare_raster_style_request(request.style);
        let params = request.with_style(raster_style);

        self.paint_glyph_from_atlas(integer_origin, params, color, element_opacity)
    }

    pub(crate) fn glyph_raster_request(
        &self,
        origin: Point<Pixels>,
        font_id: FontId,
        glyph_id: GlyphId,
        font_size: Pixels,
        color: Hsla,
        is_emoji: bool,
    ) -> (Point<ScaledPixels>, crate::GlyphRasterRequest) {
        let scale_factor = self.scale_factor();
        let glyph_origin = origin.scale(scale_factor);
        let (integer_origin, subpixel_variant) = if is_emoji {
            quantize_color_glyph_origin(glyph_origin)
        } else {
            quantize_glyph_origin(glyph_origin)
        };
        let requested_mode = if is_emoji {
            GlyphRenderMode::Color
        } else if self.should_use_subpixel_rendering(font_id, font_size) {
            GlyphRenderMode::Subpixel
        } else {
            GlyphRenderMode::Grayscale
        };
        (
            integer_origin,
            crate::GlyphRasterRequest {
                style: crate::RasterStyleRequest {
                    font_id,
                    glyph_id,
                    scene_color: crate::hsla_to_rgba(color),
                    requested_mode,
                    foreground_dependency: crate::ForegroundDependency::Full,
                },
                font_size,
                subpixel_variant,
                scale_factor,
            },
        )
    }

    fn paint_glyph_from_atlas(
        &mut self,
        integer_origin: Point<ScaledPixels>,
        params: RenderGlyphParams,
        mask_color: Hsla,
        opacity: f32,
    ) -> Result<()> {
        let text_system = self.text_system().clone();
        let entry = self
            .sprite_atlas
            .get_or_insert_glyph_with(&params, &mut || text_system.rasterize_glyph(&params))?;
        let Some(tile) = entry.tile else {
            return Ok(());
        };

        debug_assert_eq!(entry.bounds.size, tile.bounds.size.map(Into::into));
        let bounds = Bounds {
            origin: integer_origin + entry.bounds.origin.map(Into::into),
            size: tile.bounds.size.map(Into::into),
        };
        let content_mask = self.snapped_content_mask();

        match entry.format {
            RasterizedGlyphFormat::AlphaMask => {
                self.next_frame.scene.insert_primitive(MonochromeSprite {
                    order: 0,
                    padding: 0,
                    bounds,
                    content_mask,
                    color: mask_color.opacity(opacity).into(),
                    tile,
                    transformation: TransformationMatrix::unit(),
                });
            }
            RasterizedGlyphFormat::BgraSubpixelMask => {
                self.next_frame.scene.insert_primitive(SubpixelSprite {
                    order: 0,
                    padding: 0,
                    bounds,
                    content_mask,
                    color: mask_color.opacity(opacity).into(),
                    tile,
                    transformation: TransformationMatrix::unit(),
                });
            }
            RasterizedGlyphFormat::BgraColor => {
                self.next_frame.scene.insert_primitive(PolychromeSprite {
                    order: 0,
                    grayscale: false.into(),
                    corner_smoothing: 0.0,
                    bounds,
                    corner_radii: Default::default(),
                    content_mask,
                    tile,
                    opacity,
                });
            }
        }
        Ok(())
    }

    fn should_use_subpixel_rendering(&self, font_id: FontId, font_size: Pixels) -> bool {
        if self
            .platform_window
            .background_appearance()
            .is_transparent()
        {
            return false;
        }

        if !self.platform_window.is_subpixel_rendering_supported() {
            return false;
        }

        let mode = match self.text_rendering_mode.get() {
            TextRenderingMode::PlatformDefault => self
                .text_system()
                .recommended_rendering_mode(font_id, font_size),
            mode => mode,
        };

        mode == TextRenderingMode::Subpixel
    }

    /// Records a shaped glyph using color-glyph rendering.
    ///
    /// Like [`Self::paint_glyph`], this takes a font-specific glyph ID and a
    /// logical pen position whose y coordinate is the baseline. It requests
    /// color rendering and supplies white for foreground-dependent layers.
    /// Use [`Self::paint_emoji_with_color`] to choose that foreground. Prefer
    /// the shaped-line or shaped-text paint methods for a complete text run.
    /// Rasterization and atlas errors are returned; call only during paint.
    pub fn paint_emoji(
        &mut self,
        origin: Point<Pixels>,
        font_id: FontId,
        glyph_id: GlyphId,
        font_size: Pixels,
    ) -> Result<()> {
        self.paint_emoji_with_color(origin, font_id, glyph_id, font_size, white())
    }

    /// Paints a color glyph with an application foreground for `currentColor` layers.
    ///
    /// Fixed-color layers retain their own colors; `color` supplies the
    /// foreground for layers that depend on it, rather than tinting the whole
    /// bitmap. The pen position, font/glyph pairing, and error behavior match
    /// [`Self::paint_emoji`]. Call during paint; other phases panic in debug builds.
    pub fn paint_emoji_with_color(
        &mut self,
        origin: Point<Pixels>,
        font_id: FontId,
        glyph_id: GlyphId,
        font_size: Pixels,
        color: Hsla,
    ) -> Result<()> {
        self.invalidator.debug_assert_paint();

        let (integer_origin, request) =
            self.glyph_raster_request(origin, font_id, glyph_id, font_size, color, true);
        let raster_style = self
            .text_system()
            .prepare_raster_style_request(request.style);
        let params = request.with_style(raster_style);

        self.paint_glyph_from_atlas(integer_origin, params, color, self.element_opacity())
    }

    /// Paints an SVG's alpha mask in one color during paint.
    ///
    /// `Some(data)` supplies the SVG bytes; `None` loads `path` from the asset
    /// registry. A missing asset paints nothing. Parsing, zero raster size,
    /// and atlas failures return an error. Source RGB colors are discarded;
    /// their alpha is tinted with `color` and the active element opacity.
    /// Use a rendered image when the SVG's colors should be preserved.
    ///
    /// `bounds` uses logical window-local pixels. Its width determines the
    /// raster scale, preserving aspect ratio; the result is centered in the
    /// rectangle and clipped by the active content mask. The rectangle does
    /// not itself clip a tall result. `transformation` changes drawing without
    /// changing layout or hitboxes. Prefer [`svg`](crate::svg) for a styled SVG element.
    ///
    /// The atlas key contains `path` and raster size, not `data`. Give different
    /// byte contents different paths, including when both are supplied in
    /// memory; reusing the key can reuse an earlier raster. Color and drawing
    /// transformations can change without rerasterizing the alpha mask.
    pub fn paint_svg(
        &mut self,
        bounds: Bounds<Pixels>,
        path: SharedString,
        mut data: Option<&[u8]>,
        transformation: TransformationMatrix,
        color: Hsla,
        cx: &App,
    ) -> Result<()> {
        self.invalidator.debug_assert_paint();

        let element_opacity = self.element_opacity();
        let bounds = self.snap_bounds(bounds);

        let params = RenderSvgParams {
            path,
            size: bounds.size.map(|pixels| {
                DevicePixels::from((pixels.0 * SMOOTH_SVG_SCALE_FACTOR).ceil() as i32)
            }),
        };

        let Some(tile) =
            self.sprite_atlas
                .get_or_insert_with(&params.clone().into(), &mut || {
                    let Some((size, bytes)) = cx.svg_renderer.render_alpha_mask(&params, data)?
                    else {
                        return Ok(None);
                    };
                    Ok(Some((size, Cow::Owned(bytes))))
                })?
        else {
            return Ok(());
        };
        let content_mask = self.snapped_content_mask();
        let svg_bounds = Bounds {
            origin: bounds.center()
                - Point::new(
                    ScaledPixels(tile.bounds.size.width.0 as f32 / SMOOTH_SVG_SCALE_FACTOR / 2.),
                    ScaledPixels(tile.bounds.size.height.0 as f32 / SMOOTH_SVG_SCALE_FACTOR / 2.),
                ),
            size: tile
                .bounds
                .size
                .map(|value| ScaledPixels(value.0 as f32 / SMOOTH_SVG_SCALE_FACTOR)),
        };
        let final_bounds = svg_bounds
            .map_origin(|value| ScaledPixels(round_half_toward_zero(value.0)))
            .map_size(|size| size.ceil());

        self.next_frame.scene.insert_primitive(MonochromeSprite {
            order: 0,
            padding: 0,
            bounds: final_bounds,
            content_mask,
            color: color.opacity(element_opacity).into(),
            tile,
            transformation,
        });

        Ok(())
    }

    /// Paints a decoded image during an element's paint phase.
    ///
    /// `image_bounds` positions and scales the whole image; `bounds` crops it.
    /// The intersection of those rectangles receives the corner radii and is
    /// further clipped by the current content mask. The image is uploaded to
    /// the sprite atlas on demand; upload failures are returned to the caller.
    /// An empty intersection paints nothing.
    ///
    /// # Panics
    ///
    /// Panics if painting needs an invalid `frame_index`. Use an index below
    /// [`RenderImage::frame_count`], including for animated images.
    pub fn paint_image(
        &mut self,
        bounds: Bounds<Pixels>,
        image_bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        data: Arc<RenderImage>,
        frame_index: usize,
        grayscale: bool,
    ) -> Result<()> {
        self.paint_image_with_corner_smoothing(
            bounds,
            image_bounds,
            corner_radii,
            0.0,
            data,
            frame_index,
            grayscale,
        )
    }

    /// Paints [`Self::paint_image`]'s cropped image with smoothed corners.
    ///
    /// `corner_smoothing` is clamped to `0..=1`. Radii are limited to the
    /// visible rectangle before scaling to device pixels. Coordinates,
    /// masking, opacity, atlas errors, and frame-index requirements follow
    /// `paint_image`; call only during paint.
    pub fn paint_image_with_corner_smoothing(
        &mut self,
        bounds: Bounds<Pixels>,
        image_bounds: Bounds<Pixels>,
        corner_radii: Corners<Pixels>,
        corner_smoothing: f32,
        data: Arc<RenderImage>,
        frame_index: usize,
        grayscale: bool,
    ) -> Result<()> {
        self.invalidator.debug_assert_paint();

        let visible_bounds = bounds.intersect(&image_bounds);
        if visible_bounds.size.width <= Pixels::ZERO || visible_bounds.size.height <= Pixels::ZERO {
            return Ok(());
        }
        if image_bounds.size.width <= Pixels::ZERO || image_bounds.size.height <= Pixels::ZERO {
            return Ok(());
        }

        let params = RenderImageParams {
            image_id: data.id,
            frame_index,
        };

        let tile = self
            .sprite_atlas
            .get_or_insert_with(&params.into(), &mut || {
                Ok(Some((
                    data.size(frame_index),
                    Cow::Borrowed(
                        data.as_bytes(frame_index)
                            .expect("It's the caller's job to pass a valid frame index"),
                    ),
                )))
            })?
            .expect("Callback above only returns Some");

        let visible_bounds_snapped = self.snap_bounds(visible_bounds);

        let sub_tile = if visible_bounds == image_bounds {
            tile
        } else {
            let x_offset_ratio =
                (visible_bounds.origin.x - image_bounds.origin.x) / image_bounds.size.width;
            let y_offset_ratio =
                (visible_bounds.origin.y - image_bounds.origin.y) / image_bounds.size.height;
            let width_ratio = visible_bounds.size.width / image_bounds.size.width;
            let height_ratio = visible_bounds.size.height / image_bounds.size.height;

            let tile_origin_x = tile.bounds.origin.x.0;
            let tile_origin_y = tile.bounds.origin.y.0;
            let tile_width = tile.bounds.size.width.0;
            let tile_height = tile.bounds.size.height.0;

            let sub_origin_x = tile_origin_x + (x_offset_ratio * tile_width as f32).round() as i32;
            let sub_origin_y = tile_origin_y + (y_offset_ratio * tile_height as f32).round() as i32;
            let sub_width = (width_ratio * tile_width as f32).round() as i32;
            let sub_height = (height_ratio * tile_height as f32).round() as i32;

            let max_x = tile_origin_x + tile_width;
            let max_y = tile_origin_y + tile_height;

            let clamped_origin_x = sub_origin_x.clamp(tile_origin_x, max_x);
            let clamped_origin_y = sub_origin_y.clamp(tile_origin_y, max_y);
            let clamped_width = sub_width.min(max_x - clamped_origin_x).max(0);
            let clamped_height = sub_height.min(max_y - clamped_origin_y).max(0);

            AtlasTile {
                bounds: Bounds {
                    origin: point(
                        DevicePixels(clamped_origin_x),
                        DevicePixels(clamped_origin_y),
                    ),
                    size: size(DevicePixels(clamped_width), DevicePixels(clamped_height)),
                },
                ..tile
            }
        };

        let content_mask = self.snapped_content_mask();
        let corner_radii = corner_radii
            .clamp_radii_for_quad_size(visible_bounds.size)
            .scale(self.scale_factor());
        let opacity = self.element_opacity();

        self.next_frame.scene.insert_primitive(PolychromeSprite {
            order: 0,
            grayscale: grayscale.into(),
            corner_smoothing: corner_smoothing.clamp(0.0, 1.0),
            bounds: visible_bounds_snapped,
            content_mask,
            corner_radii,
            tile: sub_tile,
            opacity,
        });
        Ok(())
    }

    /// Paint a surface into the next frame's scene at the current z-index.
    ///
    /// `bounds` use logical window-local pixels and are snapped to device pixels. The current
    /// content mask and element opacity are applied. Call only during paint.
    /// This does not size, fit, or decode the source. Use [`surface`](crate::surface)
    /// for an element with layout and object fitting, and check [`SurfaceSource`](crate::SurfaceSource)
    /// for the selected renderer's device and format requirements. Source import
    /// happens during rendering, so this recording method cannot report an import failure.
    pub fn paint_surface(
        &mut self,
        bounds: Bounds<Pixels>,
        source: impl Into<crate::SurfaceSource>,
    ) {
        use crate::PaintSurface;

        self.invalidator.debug_assert_paint();

        let bounds = self.snap_bounds(bounds);
        let content_mask = self.snapped_content_mask();
        self.next_frame.scene.insert_surface(
            PaintSurface {
                order: 0,
                bounds,
                content_mask,
                source: source.into(),
            },
            self.element_opacity(),
        );
    }

    /// Evicts every frame of an image from this window's sprite atlas.
    ///
    /// This does not release the caller's decoded image or remove an asset
    /// cache entry. Painting the image again uploads its pixels again. Do not
    /// evict while a retained scene still refers to those atlas tiles.
    /// The current implementation always returns `Ok(())`.
    pub fn drop_image(&mut self, data: Arc<RenderImage>) -> Result<()> {
        for frame_index in 0..data.frame_count() {
            let params = RenderImageParams {
                image_id: data.id,
                frame_index,
            };

            self.sprite_atlas.remove(&params.clone().into());
        }

        Ok(())
    }

    /// Returns whether every frame of an image is present in the sprite atlas.
    #[cfg(any(test, feature = "headless"))]
    pub fn has_image_atlas_entry(&self, data: &RenderImage) -> bool {
        data.frame_count() > 0
            && (0..data.frame_count()).all(|frame_index| {
                self.sprite_atlas.contains(
                    &RenderImageParams {
                        image_id: data.id,
                        frame_index,
                    }
                    .into(),
                )
            })
    }

    /// Add a node to this frame's layout tree from a style and child layout IDs.
    ///
    /// Build the children's nodes first, then pass their IDs to this parent.
    /// In [`Element::request_layout`](crate::Element::request_layout), return
    /// this ID to GPUI; it computes the containing tree before calling
    /// `prepaint`. A separately laid-out subtree instead needs
    /// [`Self::compute_layout`] before its bounds can be read.
    ///
    /// The ID belongs to this frame's layout tree. Call during layout request
    /// or prepaint; other phases panic in debug builds. See
    /// [`Self::request_measured_layout`] for content that needs intrinsic
    /// measurement.
    #[must_use]
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-Window-request-layout-a55457ac.md")]
    // docs:examples:end
    pub fn request_layout(
        &mut self,
        style: Style,
        children: impl IntoIterator<Item = LayoutId>,
        cx: &mut App,
    ) -> LayoutId {
        self.invalidator.debug_assert_prepaint();

        cx.layout_id_buffer.clear();
        cx.layout_id_buffer.extend(children);
        let rem_size = self.rem_size();
        let scale_factor = self.scale_factor();

        self.layout_engine.as_mut().unwrap().request_layout(
            style,
            rem_size,
            scale_factor,
            &cx.layout_id_buffer,
        )
    }

    /// Adds a custom-measured leaf to this frame's layout tree.
    ///
    /// `measure` receives dimensions already fixed by layout and the available
    /// space on each axis. Honor a known dimension; measure the remaining axes
    /// according to [`AvailableSpace`]. Return a logical-pixel size. Parent
    /// constraints and min/max styles still affect the final bounds.
    ///
    /// Layout may call the closure more than once with different constraints.
    /// Do not treat it as a once-per-frame state update. The returned ID and
    /// retained closure belong to this frame. Call during layout request or
    /// prepaint; see the [layout chapter](crate::_documentation::layout).
    pub fn request_measured_layout<F>(&mut self, style: Style, measure: F) -> LayoutId
    where
        F: Fn(Size<Option<Pixels>>, Size<AvailableSpace>, &mut Window, &mut App) -> Size<Pixels>
            + 'static,
    {
        self.invalidator.debug_assert_prepaint();

        let rem_size = self.rem_size();
        let scale_factor = self.scale_factor();
        self.layout_engine
            .as_mut()
            .unwrap()
            .request_measured_layout(style, rem_size, scale_factor, measure)
    }

    /// Compute a requested layout subtree within the supplied available space.
    ///
    /// Use this for a subtree laid out independently of its containing tree.
    /// Ordinary [`Element`](crate::Element) implementations return their node
    /// from `request_layout`; GPUI computes the containing tree for them.
    /// [`AnyElement::layout_as_root`](crate::AnyElement::layout_as_root)
    /// requests and computes an element subtree in one operation.
    ///
    /// After computation, [`Self::layout_bounds`] returns the node's and its
    /// descendants' bounds in logical, window-local pixels. The ID must belong
    /// to the current frame's layout tree. Call during prepaint before
    /// prepainting or painting that subtree.
    pub fn compute_layout(
        &mut self,
        layout_id: LayoutId,
        available_space: Size<AvailableSpace>,
        cx: &mut App,
    ) {
        self.invalidator.debug_assert_prepaint();

        let mut layout_engine = self.layout_engine.take().unwrap();
        layout_engine.compute_layout(
            layout_id,
            available_space,
            self.measurement_direction,
            self,
            cx,
        );
        self.layout_engine = Some(layout_engine);
    }

    /// Return computed bounds for `layout_id` in logical window-local pixels.
    ///
    /// The current element offset is included, and coordinates are snapped to the device-pixel
    /// grid. The ID must belong to the layout tree computed for this frame. Call during prepaint.
    pub fn layout_bounds(&mut self, layout_id: LayoutId) -> Bounds<Pixels> {
        self.invalidator.debug_assert_prepaint();

        let scale_factor = self.scale_factor();
        let mut bounds = self
            .layout_engine
            .as_mut()
            .unwrap()
            .layout_bounds(layout_id, scale_factor)
            .map(Into::into);
        let snapped_offset = self.pixel_snap_point(self.element_offset());
        bounds.origin += snapped_offset;
        bounds
    }

    /// Returns window-local bounds with snapping relative to the layout parent.
    ///
    /// Despite the name, the result includes the parent's position and the
    /// current element offset. Only the snapping is parent-relative: GPUI snaps
    /// the local origin and size, then adds the parent's snapped origin. This
    /// keeps text placement stable as its container moves across device pixels.
    /// [`Self::layout_bounds`] instead snaps absolute edges so adjacent boxes
    /// meet. Inline fragments and parentless nodes use that ordinary path.
    /// Call during prepaint with a computed ID from the current frame.
    pub fn parent_relative_layout_bounds(&mut self, layout_id: LayoutId) -> Bounds<Pixels> {
        self.invalidator.debug_assert_prepaint();

        let scale_factor = self.scale_factor();
        let mut bounds = self
            .layout_engine
            .as_mut()
            .unwrap()
            .parent_relative_layout_bounds(layout_id, scale_factor);
        bounds.origin += self.pixel_snap_point(self.element_offset());
        bounds
    }

    pub(crate) fn publish_inline_content(
        &mut self,
        node_id: LayoutId,
        content: crate::InlineContent,
    ) -> bool {
        let Some(layout_engine) = self.layout_engine.as_mut() else {
            return false;
        };

        if let crate::InlineContent::Text { text, .. } = &content {
            layout_engine.set_direction_text(node_id, text.clone());
        }

        layout_engine
            .inline_content
            .insert(node_id, Arc::new(content));
        true
    }

    pub(crate) fn set_layout_logical_children(&mut self, node_id: LayoutId, children: &[LayoutId]) {
        self.layout_engine
            .as_mut()
            .unwrap()
            .set_logical_children(node_id, children);
    }

    pub(crate) fn set_layout_auto_direction_hint(
        &mut self,
        node_id: LayoutId,
        direction: Option<ResolvedDirection>,
    ) {
        self.layout_engine
            .as_mut()
            .unwrap()
            .set_auto_direction_hint(node_id, direction);
    }

    pub(crate) fn layout_auto_direction_contribution(
        &self,
        node_id: LayoutId,
    ) -> Option<ResolvedDirection> {
        self.layout_engine
            .as_ref()
            .unwrap()
            .auto_direction_contribution(node_id)
    }

    pub(crate) fn layout_direction_handle(
        &self,
        node_id: LayoutId,
    ) -> crate::taffy::LayoutDirectionHandle {
        self.layout_engine
            .as_ref()
            .unwrap()
            .direction_handle(node_id)
    }

    pub(crate) fn layout_directionality(
        &self,
        node_id: LayoutId,
    ) -> (ResolvedDirection, UnicodeBidi) {
        self.layout_engine.as_ref().unwrap().directionality(node_id)
    }

    pub(crate) fn with_layout_direction_context<R>(
        &mut self,
        node_id: LayoutId,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        let (direction, unicode_bidi) = self.layout_directionality(node_id);
        let previous_direction = std::mem::replace(&mut self.measurement_direction, direction);
        let previous_unicode_bidi =
            std::mem::replace(&mut self.measurement_unicode_bidi, unicode_bidi);
        let result = f(self);
        self.measurement_direction = previous_direction;
        self.measurement_unicode_bidi = previous_unicode_bidi;
        result
    }

    /// Supplies source text used by `LayoutDirection::Auto` for a custom layout node.
    ///
    /// Built-in text elements register their content automatically. Call this during
    /// `request_layout` after obtaining the node's [`LayoutId`].
    pub fn set_layout_direction_text(&mut self, node_id: LayoutId, text: impl Into<SharedString>) {
        self.layout_engine
            .as_mut()
            .unwrap()
            .set_direction_text(node_id, text.into());
    }

    pub(crate) fn inline_content(&self, node_id: LayoutId) -> Option<Arc<crate::InlineContent>> {
        self.layout_engine
            .as_ref()?
            .inline_content
            .get(&node_id)
            .cloned()
    }

    pub(crate) fn layout_display_and_position(
        &self,
        node_id: LayoutId,
    ) -> Option<(crate::Display, crate::Position)> {
        self.layout_engine
            .as_ref()
            .map(|layout_engine| layout_engine.display_and_position(node_id))
    }

    pub(crate) fn inline_fragments(&self, node_id: LayoutId) -> Option<Arc<[Bounds<Pixels>]>> {
        self.layout_engine
            .as_ref()?
            .inline_fragments
            .get(&node_id)
            .map(|fragments| {
                let offset = self.pixel_snap_point(self.element_offset());
                if offset == Point::default() {
                    return fragments.clone();
                }

                fragments
                    .iter()
                    .map(|bounds| Bounds::new(bounds.origin + offset, bounds.size))
                    .collect()
            })
    }

    pub(crate) fn place_inline(
        &mut self,
        node_id: LayoutId,
        mut bounds: Bounds<Pixels>,
        fragments: Option<Vec<Bounds<Pixels>>>,
    ) -> bool {
        if self.layout_engine.is_none() {
            return false;
        }

        let offset = self.pixel_snap_point(self.element_offset());
        bounds.origin -= offset;

        let scale = self.scale_factor();
        let Some(engine) = self.layout_engine.as_mut() else {
            return false;
        };

        engine.place_inline(node_id, bounds, scale);

        if let Some(mut fragments) = fragments {
            // A zero offset leaves fragment origins unchanged, so skip those writes.
            if offset != Point::default() {
                for fragment in &mut fragments {
                    fragment.origin -= offset;
                }
            }

            engine.inline_fragments.insert(node_id, fragments.into());
        }

        true
    }

    pub(crate) fn layout_vertical_align(
        &self,
        layout_id: LayoutId,
    ) -> Option<crate::VerticalAlign> {
        self.layout_engine
            .as_ref()
            .map(|layout_engine| layout_engine.vertical_align(layout_id))
    }

    /// Add a logical window-local hit region to this frame and return its identity.
    ///
    /// The current content mask is captured with the hitbox. Use the returned [`Hitbox`] during
    /// paint or event handling to query hover and occlusion. Hitboxes are frame-local and must be
    /// inserted during prepaint.
    ///
    /// This method should only be called as part of the prepaint phase of element drawing.
    pub fn insert_hitbox(&mut self, bounds: Bounds<Pixels>, behavior: HitboxBehavior) -> Hitbox {
        self.insert_hitbox_mut(bounds, behavior).clone()
    }

    /// Add a logical window-local hit region and return a mutable reference to its frame record.
    ///
    /// The current content mask is captured with the hitbox. Use the returned [`Hitbox`] during
    /// paint or event handling to query hover and occlusion. The reference is valid while building
    /// this frame's prepaint records; call only during prepaint.
    pub fn insert_hitbox_mut(
        &mut self,
        bounds: Bounds<Pixels>,
        behavior: HitboxBehavior,
    ) -> &mut Hitbox {
        self.invalidator.debug_assert_prepaint();

        let content_mask = self.content_mask();
        let hitbox_id = self.next_hitbox_id;
        self.next_hitbox_id = self.next_hitbox_id.next();
        let hitbox = Hitbox {
            id: hitbox_id,
            bounds,
            content_mask,
            behavior,
            fragments: self.current_inline_fragments.clone(),
            tags: Vec::default(),
        };

        self.next_frame.hitboxes.push_mut(hitbox)
    }

    /// Set a hitbox which will act as a control area of the platform window.
    ///
    /// This method should only be called as part of the paint phase of element drawing.
    pub fn insert_window_control_hitbox(&mut self, area: WindowControlArea, hitbox: Hitbox) {
        self.invalidator.debug_assert_paint();
        self.next_frame.window_control_hitboxes.push((area, hitbox));
    }

    /// Assigns a key context to the active dispatch node during paint.
    ///
    /// Key binding lookup collects contexts along the focused node's ancestor
    /// path. This replaces the context on the current node; it does not create
    /// a node or request focus. Prefer [`InteractiveElement::key_context`](crate::InteractiveElement::key_context) for
    /// ordinary element builders. See the [input chapter](crate::_documentation::input#actions-and-key-bindings).
    pub fn set_key_context(&mut self, context: KeyContext) {
        self.invalidator.debug_assert_paint();
        self.next_frame.dispatch_tree.set_key_context(context);
    }

    /// Associates the active dispatch node with a focus identity during prepaint.
    ///
    /// This lets keyboard dispatch find the node when the handle is selected;
    /// it does not select the handle or add a tab stop. Keep the handle alive
    /// and register it each time the node is rebuilt. Prefer
    /// [`InteractiveElement::track_focus`](crate::InteractiveElement::track_focus)
    /// for ordinary elements, and use
    /// [`Self::focus`] to request focus separately.
    pub fn set_focus_handle(&mut self, focus_handle: &FocusHandle, _: &App) {
        self.invalidator.debug_assert_prepaint();
        if focus_handle.is_focused(self) {
            self.next_frame.focus = Some(focus_handle.id);
        }
        self.next_frame.dispatch_tree.set_focus_id(focus_handle.id);
    }

    /// Sets the view id for the current element, which will be used to manage view caching.
    ///
    /// This method should only be called as part of element prepaint. We plan on removing this
    /// method eventually when we solve some issues that require us to construct editor elements
    /// directly instead of always using editors via views.
    pub fn set_view_id(&mut self, view_id: EntityId) {
        self.invalidator.debug_assert_prepaint();
        self.next_frame.dispatch_tree.set_view_id(view_id);
    }

    /// Get the entity ID of the view whose element is currently drawing.
    ///
    /// This is available only while a view is on the render stack, during prepaint or paint;
    /// calling it outside view drawing panics.
    pub fn current_view(&self) -> EntityId {
        self.invalidator.debug_assert_paint_or_prepaint();
        self.rendered_entity_stack.last().copied().unwrap()
    }

    #[inline]
    pub(crate) fn with_rendered_view<R>(
        &mut self,
        id: EntityId,
        f: impl FnOnce(&mut Self) -> R,
    ) -> R {
        self.rendered_entity_stack.push(id);
        let result = f(self);
        self.rendered_entity_stack.pop();
        result
    }

    /// Run drawing work with `image_cache` selected for image lookups.
    ///
    /// Passing `None` leaves the current cache selection unchanged. A supplied cache is scoped to
    /// the closure and restored afterward.
    pub fn with_image_cache<F, R>(&mut self, image_cache: Option<AnyImageCache>, f: F) -> R
    where
        F: FnOnce(&mut Self) -> R,
    {
        if let Some(image_cache) = image_cache {
            self.image_cache_stack.push(image_cache);
            let result = f(self);
            self.image_cache_stack.pop();
            result
        } else {
            f(self)
        }
    }

    /// Installs an input handler for the focused element for the next rendered frame.
    ///
    /// The handler bridges platform text input, selection, and IME composition. It is retained only
    /// until the next frame replaces the input-handler list, so call this from every paint pass.
    ///
    /// This method should only be called as part of the paint phase of element drawing.
    ///
    /// [element_input_handler]: crate::ElementInputHandler
    pub fn handle_input(
        &mut self,
        focus_handle: &FocusHandle,
        input_handler: impl InputHandler,
        cx: &App,
    ) {
        self.invalidator.debug_assert_paint();

        if focus_handle.is_focused(self) {
            let cx = self.to_async(cx);
            self.next_frame
                .input_handlers
                .push(Some(PlatformInputHandler::new(cx, Box::new(input_handler))));
        }
    }

    /// Forwards the focused input handler's [`TextInputConfiguration`] to the
    /// platform window when it differs from the last forwarded value. With no
    /// input handler the default configuration applies, so a field's
    /// preferences don't outlive its focus.
    fn apply_text_input_configuration(&mut self, cx: &mut App) {
        let configuration = match self.platform_window.take_input_handler() {
            Some(mut input_handler) => {
                let configuration = input_handler.text_input_configuration(self, cx);
                self.platform_window.set_input_handler(input_handler);
                configuration
            }
            None => TextInputConfiguration::default(),
        };
        if self.last_text_input_configuration.as_ref() != Some(&configuration) {
            self.platform_window
                .set_text_input_configuration(configuration.clone());
            self.last_text_input_configuration = Some(configuration);
        }
    }

    /// Registers a low-level pointer listener while painting the next frame.
    ///
    /// The callback receives events of type `Event` in capture and bubble
    /// phases, in paint order and reverse paint order respectively. There is no
    /// hitbox filter: check the prepared [`Hitbox`] yourself, or deliberately
    /// handle input outside it. Prefer the filtered [`InteractiveElement`](crate::InteractiveElement)
    /// builders for ordinary controls.
    ///
    /// The listener belongs to the rendered frame. Rebuilding the element
    /// replaces it; a cached subtree can reuse its previous listener record.
    pub fn on_mouse_event<Event: MouseEvent>(
        &mut self,
        mut listener: impl FnMut(&Event, DispatchPhase, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();

        self.next_frame.mouse_listeners.push(Some(Box::new(
            move |event: &dyn Any, phase: DispatchPhase, window: &mut Window, cx: &mut App| {
                if let Some(event) = event.downcast_ref() {
                    listener(event, phase, window, cx)
                }
            },
        )));
    }

    /// Observes raw touch input before gesture recognition for the next painted frame.
    /// Stopping propagation transfers gesture recognition to the listener, which is
    /// useful when embedding another GPUI window's input surface. The callback participates in
    /// capture and bubble dispatch and is discarded when a later frame omits this registration.
    /// Register it during paint.
    pub fn on_touch_event(
        &mut self,
        mut listener: impl FnMut(&TouchEvent, DispatchPhase, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();
        self.next_frame
            .mouse_listeners
            .push(Some(Box::new(move |event, phase, window, cx| {
                if let Some(event) = event.downcast_ref::<TouchEvent>() {
                    listener(event, phase, window, cx);
                }
            })));
    }

    /// Observes native file drops before their conversion to mouse drag events for the next frame.
    /// Stopping propagation lets an embedded GPUI window own the drop. The listener participates
    /// in capture and bubble dispatch and must be registered during paint.
    pub fn on_file_drop_event(
        &mut self,
        mut listener: impl FnMut(&crate::FileDropEvent, DispatchPhase, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();
        self.next_frame
            .mouse_listeners
            .push(Some(Box::new(move |event, phase, window, cx| {
                if let Some(event) = event.downcast_ref::<crate::FileDropEvent>() {
                    listener(event, phase, window, cx);
                }
            })));
    }

    /// Registers a raw key listener on the current dispatch node during paint.
    ///
    /// `Event` selects key-down or key-up delivery. Capture visits the focused
    /// node's ancestors from root to leaf; bubble visits the same path in
    /// reverse. A listener on a child of the focused node lies outside that
    /// route. Attach it to the node carrying the focus handle or an ancestor.
    ///
    /// Key binding resolution precedes raw key-down delivery, including
    /// capture. A consumed action or pending chord can prevent this listener
    /// from running. Use [`App::intercept_keystrokes`] before resolution, or
    /// the [`InteractiveElement`](crate::InteractiveElement) builders for an
    /// ordinary element handler.
    ///
    /// The listener belongs to this frame's dispatch tree. Register it again
    /// when rebuilding the node; a cached subtree can reuse its previous
    /// listener record. This method must be called during paint.
    pub fn on_key_event<Event: KeyEvent>(
        &mut self,
        listener: impl Fn(&Event, DispatchPhase, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();

        self.next_frame.dispatch_tree.on_key_event(Rc::new(
            move |event: &dyn Any, phase, window: &mut Window, cx: &mut App| {
                if let Some(event) = event.downcast_ref::<Event>() {
                    listener(event, phase, window, cx)
                }
            },
        ));
    }

    /// Registers a modifier-change listener on the active dispatch node during paint.
    ///
    /// Delivery follows the focused node's path from leaf to root and stops
    /// when a listener calls [`App::stop_propagation`]. This is not a global
    /// window listener. Its frame lifetime follows [`Self::on_key_event`];
    /// register it again when rebuilding the node.
    /// A modifier-only shortcut can consume a change before this route.
    pub fn on_modifiers_changed(
        &mut self,
        listener: impl Fn(&ModifiersChangedEvent, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();

        self.next_frame.dispatch_tree.on_modifiers_changed(Rc::new(
            move |event: &ModifiersChangedEvent, window: &mut Window, cx: &mut App| {
                listener(event, window, cx)
            },
        ));
    }

    /// Listen for focus entering `handle` or one of its descendants.
    ///
    /// Moving between descendants does not fire this callback. Entering also
    /// includes native activation while the handle lies on the focus path.
    /// Callbacks run while a draw compares the previous and new focus paths;
    /// [`Self::focus`] does not call them synchronously. Keep the returned
    /// subscription to keep listening. Registration becomes active during
    /// effect processing after the current update.
    pub fn on_focus_in(
        &mut self,
        handle: &FocusHandle,
        cx: &mut App,
        mut listener: impl FnMut(&mut Window, &mut App) + 'static,
    ) -> Subscription {
        let focus_id = handle.id;
        let (subscription, activate) =
            self.new_focus_listener(Box::new(move |event, window, cx| {
                if event.is_focus_in(focus_id) {
                    listener(window, cx);
                }
                true
            }));
        cx.defer(move |_| activate());
        subscription
    }

    /// Listen for focus leaving `handle` or one of its descendants.
    ///
    /// Moving between descendants does not fire this callback. Leaving also
    /// includes native deactivation. The event carries a weak handle to the
    /// previously focused leaf, which may already have been dropped.
    /// Callbacks run while a draw compares focus paths; keep the returned
    /// subscription to keep listening. Registration is deferred until effect
    /// processing after the current update. See [`Self::on_focus_in`].
    pub fn on_focus_out(
        &mut self,
        handle: &FocusHandle,
        cx: &mut App,
        mut listener: impl FnMut(FocusOutEvent, &mut Window, &mut App) + 'static,
    ) -> Subscription {
        let focus_id = handle.id;
        let (subscription, activate) =
            self.new_focus_listener(Box::new(move |event, window, cx| {
                if let Some(blurred_id) = event.previous_focus_path.last().copied()
                    && event.is_focus_out(focus_id)
                {
                    let event = FocusOutEvent {
                        blurred: WeakFocusHandle {
                            id: blurred_id,
                            handles: Arc::downgrade(&cx.focus_handles),
                        },
                    };
                    listener(event, window, cx)
                }
                true
            }));
        cx.defer(move |_| activate());
        subscription
    }

    fn reset_cursor_style(&self, cx: &mut App) {
        // Set the cursor only if we're the active window.
        if self.is_window_hovered() {
            let style = self
                .rendered_frame
                .cursor_style(self)
                .unwrap_or(CursorStyle::Arrow);
            cx.platform.set_cursor_style(style);
        }
    }

    /// Dispatch a key press and its simulated committed text.
    ///
    /// Sends [`KeyDownEvent`] without a matching release. Key bindings run first.
    /// If propagation remains enabled and the keystroke contains committed
    /// text, the focused text-input handler receives that text. Returns `true` when either path
    /// handled the input. Use [`Keystroke::parse`](crate::Keystroke::parse) to construct one.
    pub fn dispatch_keystroke(&mut self, keystroke: Keystroke, cx: &mut App) -> bool {
        let keystroke = keystroke.with_simulated_ime();
        let result = self.dispatch_event(
            PlatformInput::KeyDown(KeyDownEvent {
                keystroke: keystroke.clone(),
                is_held: false,
                prefer_character_input: false,
            }),
            cx,
        );
        if !result.propagate {
            return true;
        }

        if let Some(input) = keystroke.key_char
            && let Some(mut input_handler) = self.platform_window.take_input_handler()
        {
            input_handler.dispatch_input(&input, self, cx);
            self.platform_window.set_input_handler(input_handler);
            return true;
        }

        false
    }

    /// Formats the highest-precedence active binding for a shortcut label.
    ///
    /// Lookup uses the current focus path and the action's value, as in
    /// [`Self::highest_precedence_binding_for_action`]. Multi-stroke bindings
    /// are joined with spaces. If no binding matches, returns the action's
    /// registered name instead.
    pub fn keystroke_text_for(&self, action: &dyn Action) -> String {
        self.highest_precedence_binding_for_action(action)
            .map(|binding| {
                binding
                    .keystrokes()
                    .iter()
                    .map(ToString::to_string)
                    .collect::<Vec<_>>()
                    .join(" ")
            })
            .unwrap_or_else(|| action.name().to_string())
    }

    /// Delivers platform input to the last rendered frame's listeners.
    ///
    /// Keyboard input follows the focused node's ancestor path. Pointer
    /// listeners run in paint order during capture and reverse paint order
    /// during bubble; each listener decides whether its hitbox applies. Raw
    /// touch input also feeds the gesture recognizer unless propagation stops.
    /// A dirty frame is drawn before keyboard or pointer listener dispatch.
    ///
    /// The returned flags distinguish propagation from default handling.
    /// [`App::stop_propagation`] stops listeners; [`Self::prevent_default`]
    /// suppresses the applicable default behavior without stopping them. The
    /// platform adapter decides how to apply those flags to native input.
    /// For simulated typing, use [`Self::dispatch_keystroke`], which also
    /// forwards committed text to the input handler.
    #[profiling::function]
    pub fn dispatch_event(&mut self, event: PlatformInput, cx: &mut App) -> DispatchEventResult {
        #[cfg(feature = "profiler")]
        self.window_profiler.begin_input(event.kind_name());
        let update_count_before = self.invalidator.update_count();
        // Track input modality for focus-visible styling and hover suppression.
        // Hover is suppressed during keyboard modality so that keyboard navigation
        // doesn't show hover highlights on the item under the mouse cursor.
        let old_modality = self.last_input_modality;
        self.last_input_modality = match &event {
            PlatformInput::KeyDown(_) => InputModality::Keyboard,
            PlatformInput::MouseMove(_) | PlatformInput::MouseDown(_) => InputModality::Mouse,
            PlatformInput::Touch(_) => InputModality::Touch,
            _ => self.last_input_modality,
        };
        if self.last_input_modality != old_modality {
            self.refresh();
        }

        // Handlers may set this to false by calling `stop_propagation`.
        cx.propagate_event = true;
        // Handlers may set this to true by calling `prevent_default`.
        self.default_prevented = false;

        if let PlatformInput::FileDrop(drop) = &event {
            match drop {
                FileDropEvent::Entered { position, .. }
                | FileDropEvent::Pending { position }
                | FileDropEvent::Submit { position } => self.mouse_position = *position,
                FileDropEvent::Exited | FileDropEvent::Ended => {}
            }
            self.dispatch_mouse_event(drop, cx);
            if !cx.propagate_event {
                return DispatchEventResult {
                    propagate: false,
                    default_prevented: self.default_prevented,
                };
            }
        }
        let event = match event {
            // Track the mouse position with our own state, since accessing the platform
            // API for the mouse position can only occur on the main thread.
            PlatformInput::MouseMove(mouse_move) => {
                self.mouse_position = mouse_move.position;
                self.modifiers = mouse_move.modifiers;
                PlatformInput::MouseMove(mouse_move)
            }
            PlatformInput::MouseDown(mouse_down) => {
                self.mouse_position = mouse_down.position;
                self.modifiers = mouse_down.modifiers;
                PlatformInput::MouseDown(mouse_down)
            }
            PlatformInput::MouseUp(mouse_up) => {
                self.mouse_position = mouse_up.position;
                self.modifiers = mouse_up.modifiers;
                PlatformInput::MouseUp(mouse_up)
            }
            PlatformInput::MousePressure(mouse_pressure) => {
                PlatformInput::MousePressure(mouse_pressure)
            }
            PlatformInput::MouseExited(mouse_exited) => {
                self.modifiers = mouse_exited.modifiers;
                PlatformInput::MouseExited(mouse_exited)
            }
            PlatformInput::ModifiersChanged(modifiers_changed) => {
                self.modifiers = modifiers_changed.modifiers;
                self.capslock = modifiers_changed.capslock;
                PlatformInput::ModifiersChanged(modifiers_changed)
            }
            PlatformInput::ScrollWheel(scroll_wheel) => {
                self.mouse_position = scroll_wheel.position;
                self.modifiers = scroll_wheel.modifiers;
                PlatformInput::ScrollWheel(scroll_wheel)
            }
            PlatformInput::Pinch(pinch) => {
                self.mouse_position = pinch.position;
                self.modifiers = pinch.modifiers;
                PlatformInput::Pinch(pinch)
            }
            // Translate dragging and dropping of external files from the operating system
            // to internal drag and drop events.
            PlatformInput::FileDrop(file_drop) => match file_drop {
                FileDropEvent::Entered { position, paths } => {
                    self.mouse_position = position;
                    let source_window = self.handle.window_id();
                    if !cx.restore_platform_drag(source_window) && cx.active_drag.is_none() {
                        cx.active_drag = Some(AnyDrag {
                            value: Arc::new(paths.clone()),
                            view: cx.new(|_| paths).into(),
                            cursor_offset: position,
                            cursor_style: None,
                            external_payload_source: None,
                        });
                    }
                    PlatformInput::MouseMove(MouseMoveEvent {
                        position,
                        pressed_button: Some(MouseButton::Left),
                        modifiers: Modifiers::default(),
                    })
                }
                FileDropEvent::Pending { position } => {
                    self.mouse_position = position;
                    PlatformInput::MouseMove(MouseMoveEvent {
                        position,
                        pressed_button: Some(MouseButton::Left),
                        modifiers: Modifiers::default(),
                    })
                }
                FileDropEvent::Submit { position } => {
                    cx.activate(true);
                    self.mouse_position = position;
                    PlatformInput::MouseUp(MouseUpEvent {
                        button: MouseButton::Left,
                        position,
                        modifiers: Modifiers::default(),
                        click_count: 1,
                    })
                }
                FileDropEvent::Exited => {
                    if !cx.hand_restored_drag_to_platform(self.handle.window_id()) {
                        cx.active_drag.take();
                    }
                    self.refresh();
                    PlatformInput::FileDrop(FileDropEvent::Exited)
                }
                FileDropEvent::Ended => {
                    cx.end_platform_drag(self.handle.window_id());
                    self.refresh();
                    PlatformInput::FileDrop(FileDropEvent::Ended)
                }
            },
            PlatformInput::Touch(touch) => PlatformInput::Touch(touch),
            PlatformInput::LongPress(long_press) => {
                self.mouse_position = if long_press.phase == crate::TouchPhase::Started {
                    long_press.start_position
                } else {
                    long_press.position
                };
                if long_press.phase == crate::TouchPhase::Started {
                    self.long_press_capture = None;
                }
                PlatformInput::LongPress(long_press)
            }
            PlatformInput::TouchDrag(touch_drag) => {
                self.mouse_position = touch_drag.start_position;
                PlatformInput::TouchDrag(touch_drag)
            }
            PlatformInput::KeyDown(_) | PlatformInput::KeyUp(_) => event,
        };

        if let Some(any_mouse_event) = event.mouse_event() {
            self.dispatch_mouse_event(any_mouse_event, cx);
        } else if let Some(any_key_event) = event.keyboard_event() {
            self.dispatch_key_event(any_key_event, cx);
        } else if let Some(touch_event) = event.touch_event() {
            self.mouse_position = touch_event.position;
            self.dispatch_mouse_event(touch_event, cx);
            if cx.propagate_event {
                self.dispatch_touch_event(touch_event, cx);
            }
        }
        if let PlatformInput::LongPress(long_press) = &event {
            match long_press.phase {
                crate::TouchPhase::Started if !self.default_prevented => {
                    self.long_press_capture = None;
                }
                crate::TouchPhase::Ended | crate::TouchPhase::Cancelled => {
                    self.long_press_capture = None;
                }
                crate::TouchPhase::Started | crate::TouchPhase::Moved => {}
            }
        }

        // Must run after the move is dispatched: the platform owns the gesture afterwards, so this
        // is the last chance for drag listeners to see the pointer leave and reset their state.
        self.promote_external_drag_to_platform(&event, cx);

        let caused_invalidation = self.invalidator.update_count() > update_count_before;
        if caused_invalidation {
            self.input_rate_tracker.borrow_mut().record_input();
        }
        #[cfg(feature = "profiler")]
        self.window_profiler.end_input(caused_invalidation);

        DispatchEventResult {
            propagate: cx.propagate_event,
            default_prevented: self.default_prevented,
        }
    }

    fn promote_external_drag_to_platform(&mut self, event: &PlatformInput, cx: &mut App) {
        let PlatformInput::MouseMove(mouse_move) = event else {
            return;
        };
        if mouse_move.pressed_button != Some(MouseButton::Left) {
            return;
        }
        if Bounds::new(Point::default(), self.viewport_size).contains(&mouse_move.position) {
            return;
        }
        if !self.platform_window.can_start_external_drag() {
            return;
        }
        let Some(payload_source) = cx
            .active_drag
            .as_mut()
            .and_then(|drag| drag.external_payload_source.take())
        else {
            return;
        };
        let Some(payload) = payload_source(self, cx) else {
            return;
        };
        if self.platform_window.start_external_drag(&payload)
            && cx.hand_active_drag_to_platform(self.handle.window_id())
        {
            self.refresh();
        }
    }

    /// Whether recognized touch pans may use the platform's predicted touch
    /// positions ([`TouchEvent::predicted_position`]) to compensate for input
    /// latency. Defaults to true.
    pub fn touch_prediction_enabled(&self) -> bool {
        self.touch_prediction_enabled
    }

    /// Sets whether recognized touch pans may use the platform's predicted
    /// touch positions. Disabling drops [`TouchEvent::predicted_position`]
    /// before gesture recognition, so pans track only raw touch positions.
    pub fn set_touch_prediction_enabled(&mut self, enabled: bool) {
        self.touch_prediction_enabled = enabled;
    }

    /// Runs the portable gesture recognizer over a raw touch event and
    /// dispatches whatever it resolves (scroll steps, synthesized taps)
    /// through the ordinary mouse-event path.
    fn dispatch_touch_event(&mut self, event: &TouchEvent, cx: &mut App) {
        let mut event = event.clone();
        if !self.touch_prediction_enabled {
            event.predicted_position = None;
        }
        let recognized_gestures = self.touch_gestures.handle_event(&event);
        if event.phase == crate::TouchPhase::Started
            && let Some(touch_drag) = self.touch_gestures.offer_touch_drag(event.id)
        {
            self.dispatch_recognized_touch_gesture(touch_drag, cx);
        }
        if event.phase == crate::TouchPhase::Started
            && self.touch_gestures.pending_long_press().is_some()
        {
            self.long_press_capture = None;
        }
        let mut tapped = false;
        for gesture in recognized_gestures {
            tapped |= matches!(gesture, RecognizedTouchGesture::Tap { .. });
            self.dispatch_recognized_touch_gesture(gesture, cx);
        }
        if event.phase == crate::TouchPhase::Started {
            self.schedule_long_press_timer(cx);
        } else if self.touch_gestures.pending_long_press().is_none() {
            self.long_press_timer.take();
        }
        // The platform's touch-release handler may inspect the input handler
        // as soon as this dispatch returns (the web platform decides virtual
        // keyboard visibility there, inside the user gesture). Input handlers
        // are registered during draw, so draw now to make them reflect any
        // focus change the tap just caused.
        if tapped && self.invalidator.is_dirty() {
            self.draw(cx).clear(cx);
        }
        if self.touch_gestures.has_momentum() {
            self.schedule_touch_momentum_tick();
        }
    }

    fn dispatch_recognized_touch_gesture(&mut self, gesture: RecognizedTouchGesture, cx: &mut App) {
        match gesture {
            RecognizedTouchGesture::Scroll(scroll_wheel) => {
                self.mouse_position = scroll_wheel.position;
                cx.propagate_event = true;
                self.dispatch_mouse_event(&scroll_wheel, cx);
            }
            RecognizedTouchGesture::Tap { down, up } => {
                self.mouse_position = up.position;
                cx.propagate_event = true;
                self.dispatch_mouse_event(&down, cx);
                cx.propagate_event = true;
                self.dispatch_mouse_event(&up, cx);
            }
            RecognizedTouchGesture::TouchDrag(touch_drag) => {
                self.mouse_position = touch_drag.start_position;
                cx.propagate_event = true;
                self.default_prevented = false;
                let started = touch_drag.phase == crate::TouchPhase::Started;
                self.dispatch_mouse_event(&touch_drag, cx);
                if started {
                    self.touch_gestures
                        .resolve_touch_drag(self.default_prevented);
                }
            }
            RecognizedTouchGesture::LongPress(long_press) => {
                self.mouse_position = if long_press.phase == crate::TouchPhase::Started {
                    long_press.start_position
                } else {
                    long_press.position
                };
                cx.propagate_event = true;
                self.default_prevented = false;
                let started = long_press.phase == crate::TouchPhase::Started;
                let ended = matches!(
                    long_press.phase,
                    crate::TouchPhase::Ended | crate::TouchPhase::Cancelled
                );
                self.dispatch_mouse_event(&long_press, cx);
                if started {
                    let claimed = self.default_prevented;
                    self.touch_gestures.resolve_long_press(claimed);
                    if !claimed {
                        self.long_press_capture = None;
                    }
                }
                if ended {
                    self.long_press_capture = None;
                }
            }
        }
    }

    fn schedule_long_press_timer(&mut self, cx: &mut App) {
        self.long_press_timer.take();
        let Some((touch_id, duration)) = self.touch_gestures.pending_long_press() else {
            return;
        };
        self.long_press_timer = Some(self.spawn(cx, async move |cx| {
            cx.background_executor.timer(duration).await;
            cx.update(move |window, cx| {
                window.long_press_timer.take();
                if let Some(gesture) = window.touch_gestures.offer_long_press(touch_id) {
                    window.dispatch_recognized_touch_gesture(gesture, cx);
                }
            })
            .log_err();
        }));
    }

    fn schedule_touch_momentum_tick(&mut self) {
        self.on_next_frame(|window, cx| {
            if let Some(gesture) = window.touch_gestures.tick_momentum() {
                window.dispatch_recognized_touch_gesture(gesture, cx);
            }
            if window.touch_gestures.has_momentum() {
                window.schedule_touch_momentum_tick();
            }
        });
    }

    /// Returns the hit-test that was most recently cached from a mouse event on the rendered frame.
    pub fn mouse_hit_test(&self) -> &HitTest {
        &self.mouse_hit_test
    }

    fn dispatch_mouse_event(&mut self, event: &dyn Any, cx: &mut App) {
        let hit_test = self.rendered_frame.hit_test(self.mouse_position());
        if hit_test != self.mouse_hit_test {
            self.mouse_hit_test = hit_test;
            self.reset_cursor_style(cx);
        }

        #[cfg(any(feature = "inspector", debug_assertions))]
        if self.is_inspector_picking(cx) {
            self.handle_inspector_mouse_event(event, cx);
            // When inspector is picking, all other mouse handling is skipped.
            return;
        }

        let mut mouse_listeners = mem::take(&mut self.rendered_frame.mouse_listeners);

        // Capture phase, events bubble from back to front. Handlers for this phase are used for
        // special purposes, such as detecting events outside of a given Bounds.
        for listener in &mut mouse_listeners {
            let listener = listener.as_mut().unwrap();
            listener(event, DispatchPhase::Capture, self, cx);
            if !cx.propagate_event {
                break;
            }
        }

        // Bubble phase, where most normal handlers do their work.
        if cx.propagate_event {
            for listener in mouse_listeners.iter_mut().rev() {
                let listener = listener.as_mut().unwrap();
                listener(event, DispatchPhase::Bubble, self, cx);
                if !cx.propagate_event {
                    break;
                }
            }
        }

        self.rendered_frame.mouse_listeners = mouse_listeners;

        if cx.has_active_drag() {
            if event.is::<MouseMoveEvent>() {
                // If this was a mouse move event, redraw the window so that the
                // active drag can follow the mouse cursor.
                self.refresh();
            } else if event.is::<MouseUpEvent>() {
                // If this was a mouse up event, cancel the active drag and redraw
                // the window.
                cx.active_drag = None;
                self.refresh();
            }
        }

        // Auto-release pointer capture on mouse up
        if event.is::<MouseUpEvent>() && self.captured_hitbox.is_some() {
            self.captured_hitbox = None;
        }
    }

    fn dispatch_key_event(&mut self, event: &dyn Any, cx: &mut App) {
        if self.invalidator.is_dirty() {
            self.draw(cx).clear(cx);
        }

        let node_id = self.focus_node_id_in_rendered_frame(self.focus);
        let dispatch_path = self.rendered_frame.dispatch_tree.dispatch_path(node_id);

        let mut keystroke: Option<Keystroke> = None;

        if let Some(event) = event.downcast_ref::<ModifiersChangedEvent>() {
            if event.modifiers.number_of_modifiers() == 0
                && self.pending_modifier.modifiers.number_of_modifiers() == 1
                && !self.pending_modifier.saw_other_input
            {
                let key = match self.pending_modifier.modifiers {
                    modifiers if modifiers.shift => Some("shift"),
                    modifiers if modifiers.control => Some("control"),
                    modifiers if modifiers.alt => Some("alt"),
                    modifiers if modifiers.platform => Some("platform"),
                    modifiers if modifiers.function => Some("function"),
                    _ => None,
                };
                if let Some(key) = key {
                    keystroke = Some(Keystroke {
                        key: key.to_string(),
                        key_char: None,
                        modifiers: Modifiers::default(),
                    });
                }
            }

            if self.pending_modifier.modifiers.number_of_modifiers() == 0
                && event.modifiers.number_of_modifiers() == 1
            {
                self.pending_modifier.saw_other_input = false
            } else if event.modifiers.number_of_modifiers() > 1 {
                self.pending_modifier.saw_other_input = true
            }
            self.pending_modifier.modifiers = event.modifiers
        } else if let Some(key_down_event) = event.downcast_ref::<KeyDownEvent>() {
            self.pending_modifier.saw_other_input = true;
            keystroke = Some(key_down_event.keystroke.clone());
            if key_down_event.keystroke.key_char.is_some()
                && matches!(
                    cx.cursor_hide_mode,
                    CursorHideMode::OnTyping | CursorHideMode::OnTypingAndAction
                )
            {
                cx.platform.hide_cursor_until_mouse_moves();
            }
        }

        let Some(keystroke) = keystroke else {
            self.finish_dispatch_key_event(event, dispatch_path, self.context_stack(), cx);
            return;
        };

        cx.propagate_event = true;
        self.dispatch_keystroke_interceptors(event, self.context_stack(), cx);
        if !cx.propagate_event {
            self.finish_dispatch_key_event(event, dispatch_path, self.context_stack(), cx);
            return;
        }

        let mut currently_pending = self.pending_input.take().unwrap_or_default();
        if currently_pending.focus.is_some() && currently_pending.focus != self.focus {
            currently_pending = PendingInput::default();
        }

        let match_result = self.rendered_frame.dispatch_tree.dispatch_key(
            currently_pending.keystrokes,
            keystroke,
            &dispatch_path,
        );

        if !match_result.to_replay.is_empty() {
            self.replay_pending_input(match_result.to_replay, cx);
            cx.propagate_event = true;
        }

        if !match_result.pending.is_empty() {
            currently_pending.timer.take();
            currently_pending.keystrokes = match_result.pending;
            currently_pending.focus = self.focus;

            let text_input_requires_timeout = event
                .downcast_ref::<KeyDownEvent>()
                .filter(|key_down| key_down.keystroke.key_char.is_some())
                .and_then(|_| self.platform_window.take_input_handler())
                .map_or(false, |mut input_handler| {
                    let accepts = input_handler.accepts_text_input(self, cx);
                    self.platform_window.set_input_handler(input_handler);
                    accepts
                });

            currently_pending.needs_timeout |=
                match_result.pending_has_binding || text_input_requires_timeout;

            if currently_pending.needs_timeout {
                currently_pending.timer = Some(self.spawn(cx, async move |cx| {
                    cx.background_executor.timer(Duration::from_secs(1)).await;
                    cx.update(move |window, cx| {
                        let Some(currently_pending) = window
                            .pending_input
                            .take()
                            .filter(|pending| pending.focus == window.focus)
                        else {
                            return;
                        };

                        let node_id = window.focus_node_id_in_rendered_frame(window.focus);
                        let dispatch_path =
                            window.rendered_frame.dispatch_tree.dispatch_path(node_id);

                        let to_replay = window
                            .rendered_frame
                            .dispatch_tree
                            .flush_dispatch(currently_pending.keystrokes, &dispatch_path);

                        window.pending_input_changed(cx);
                        window.replay_pending_input(to_replay, cx)
                    })
                    .log_err();
                }));
            } else {
                currently_pending.timer = None;
            }
            self.pending_input = Some(currently_pending);
            self.pending_input_changed(cx);
            cx.propagate_event = false;
            return;
        }

        let skip_bindings = event
            .downcast_ref::<KeyDownEvent>()
            .filter(|key_down_event| key_down_event.prefer_character_input)
            .map(|_| {
                self.platform_window
                    .take_input_handler()
                    .map_or(false, |mut input_handler| {
                        let accepts = input_handler.accepts_text_input(self, cx);
                        self.platform_window.set_input_handler(input_handler);
                        // If modifiers are not excessive (e.g. AltGr), and the input handler is accepting text input,
                        // we prefer the text input over bindings.
                        accepts
                    })
            })
            .unwrap_or(false);

        if !skip_bindings {
            for binding in match_result.bindings {
                self.dispatch_action_on_node(node_id, binding.action.as_ref(), cx);
                if !cx.propagate_event {
                    self.dispatch_keystroke_observers(
                        event,
                        Some(binding.action),
                        match_result.context_stack,
                        cx,
                    );
                    self.pending_input_changed(cx);
                    return;
                }
            }
        }

        self.finish_dispatch_key_event(event, dispatch_path, match_result.context_stack, cx);
        self.pending_input_changed(cx);
    }

    fn finish_dispatch_key_event(
        &mut self,
        event: &dyn Any,
        dispatch_path: SmallVec<[DispatchNodeId; 32]>,
        context_stack: Vec<KeyContext>,
        cx: &mut App,
    ) {
        self.dispatch_key_down_up_event(event, &dispatch_path, cx);
        if !cx.propagate_event {
            return;
        }

        self.dispatch_modifiers_changed_event(event, &dispatch_path, cx);
        if !cx.propagate_event {
            return;
        }

        self.dispatch_keystroke_observers(event, None, context_stack, cx);
    }

    pub(crate) fn pending_input_changed(&mut self, cx: &mut App) {
        self.pending_input_observers
            .clone()
            .retain(&(), |callback| callback(self, cx));
    }

    fn defer_pending_input_changed(&self, cx: &mut App) {
        // Avoid re-entrant entity updates by deferring observer notifications to the end of the
        // current effect cycle, and only for this window.
        let window_handle = self.handle;
        cx.defer(move |cx| {
            window_handle
                .update(cx, |_, window, cx| {
                    window.pending_input_changed(cx);
                })
                .ok();
        });
    }

    fn dispatch_key_down_up_event(
        &mut self,
        event: &dyn Any,
        dispatch_path: &SmallVec<[DispatchNodeId; 32]>,
        cx: &mut App,
    ) {
        // Capture phase
        for node_id in dispatch_path {
            let node = self.rendered_frame.dispatch_tree.node(*node_id);

            for key_listener in node.key_listeners.clone() {
                key_listener(event, DispatchPhase::Capture, self, cx);
                if !cx.propagate_event {
                    return;
                }
            }
        }

        // Bubble phase
        for node_id in dispatch_path.iter().rev() {
            // Handle low level key events
            let node = self.rendered_frame.dispatch_tree.node(*node_id);
            for key_listener in node.key_listeners.clone() {
                key_listener(event, DispatchPhase::Bubble, self, cx);
                if !cx.propagate_event {
                    return;
                }
            }
        }
    }

    fn dispatch_modifiers_changed_event(
        &mut self,
        event: &dyn Any,
        dispatch_path: &SmallVec<[DispatchNodeId; 32]>,
        cx: &mut App,
    ) {
        let Some(event) = event.downcast_ref::<ModifiersChangedEvent>() else {
            return;
        };
        for node_id in dispatch_path.iter().rev() {
            let node = self.rendered_frame.dispatch_tree.node(*node_id);
            for listener in node.modifiers_changed_listeners.clone() {
                listener(event, self, cx);
                if !cx.propagate_event {
                    return;
                }
            }
        }
    }

    /// Pending input that can still complete a binding. Input left over from a previous focus can
    /// never complete one.
    fn active_pending_input(&self) -> Option<&PendingInput> {
        self.pending_input
            .as_ref()
            .filter(|pending_input| pending_input.focus == self.focus)
    }

    /// Returns whether a multi-stroke binding is pending for the current focus.
    ///
    /// A prefix left over from another focus is not active. Use
    /// [`Self::pending_input_keystrokes`] to display the accepted prefix.
    pub fn has_pending_keystrokes(&self) -> bool {
        self.active_pending_input().is_some()
    }

    #[cfg(test)]
    pub(crate) fn pending_input_is_none(&self) -> bool {
        self.pending_input.is_none()
    }

    pub(crate) fn clear_pending_keystrokes(&mut self, cx: &mut App) {
        if self.pending_input.take().is_some() {
            self.defer_pending_input_changed(cx);
        }
    }

    /// Borrows the accepted prefix of a pending multi-stroke binding.
    ///
    /// Returns `None` if no prefix is pending for the current focus. Completion,
    /// replay, or a focus change can clear it; use
    /// [`Context::observe_pending_input`](crate::Context::observe_pending_input)
    /// to update a shortcut indicator.
    pub fn pending_input_keystrokes(&self) -> Option<&[Keystroke]> {
        self.active_pending_input()
            .map(|pending_input| pending_input.keystrokes.as_slice())
    }

    fn replay_pending_input(&mut self, replays: SmallVec<[Replay; 1]>, cx: &mut App) {
        let node_id = self.focus_node_id_in_rendered_frame(self.focus);
        let dispatch_path = self.rendered_frame.dispatch_tree.dispatch_path(node_id);

        'replay: for replay in replays {
            let event = KeyDownEvent {
                keystroke: replay.keystroke.clone(),
                is_held: false,
                prefer_character_input: true,
            };

            cx.propagate_event = true;
            for binding in replay.bindings {
                self.dispatch_action_on_node(node_id, binding.action.as_ref(), cx);
                if !cx.propagate_event {
                    self.dispatch_keystroke_observers(
                        &event,
                        Some(binding.action),
                        Vec::default(),
                        cx,
                    );
                    continue 'replay;
                }
            }

            self.dispatch_key_down_up_event(&event, &dispatch_path, cx);
            if !cx.propagate_event {
                continue 'replay;
            }
            if let Some(input) = replay.keystroke.key_char.as_ref().cloned()
                && let Some(mut input_handler) = self.platform_window.take_input_handler()
            {
                input_handler.dispatch_input(&input, self, cx);
                self.platform_window.set_input_handler(input_handler)
            }
        }
    }

    fn focus_node_id_in_rendered_frame(&self, focus_id: Option<FocusId>) -> DispatchNodeId {
        focus_id
            .and_then(|focus_id| {
                self.rendered_frame
                    .dispatch_tree
                    .focusable_node_id(focus_id)
            })
            .unwrap_or_else(|| self.rendered_frame.dispatch_tree.root_node_id())
    }

    fn dispatch_action_on_node(
        &mut self,
        node_id: DispatchNodeId,
        action: &dyn Action,
        cx: &mut App,
    ) {
        self.dispatch_action_on_node_inner(node_id, action, cx);

        if !cx.propagate_event
            && cx.cursor_hide_mode == CursorHideMode::OnTypingAndAction
            && self.last_input_was_keyboard()
        {
            cx.platform.hide_cursor_until_mouse_moves();
        }
    }

    fn dispatch_action_on_node_inner(
        &mut self,
        node_id: DispatchNodeId,
        action: &dyn Action,
        cx: &mut App,
    ) {
        let dispatch_path = self.rendered_frame.dispatch_tree.dispatch_path(node_id);

        // Capture phase for global actions.
        cx.propagate_event = true;
        if let Some(mut global_listeners) = cx
            .global_action_listeners
            .remove(&action.as_any().type_id())
        {
            for listener in &global_listeners {
                #[cfg(feature = "profiler")]
                self.window_profiler.begin_action_handler(action, cx);
                listener(action.as_any(), DispatchPhase::Capture, cx);
                #[cfg(feature = "profiler")]
                self.window_profiler.end_action_handler();
                if !cx.propagate_event {
                    break;
                }
            }

            global_listeners.extend(
                cx.global_action_listeners
                    .remove(&action.as_any().type_id())
                    .unwrap_or_default(),
            );

            cx.global_action_listeners
                .insert(action.as_any().type_id(), global_listeners);
        }

        if !cx.propagate_event {
            return;
        }

        // Capture phase for window actions.
        for node_id in &dispatch_path {
            let node = self.rendered_frame.dispatch_tree.node(*node_id);
            for DispatchActionListener {
                action_type,
                listener,
            } in node.action_listeners.clone()
            {
                let any_action = action.as_any();
                if action_type == any_action.type_id() {
                    #[cfg(feature = "profiler")]
                    self.window_profiler.begin_action_handler(action, cx);
                    listener(any_action, DispatchPhase::Capture, self, cx);
                    #[cfg(feature = "profiler")]
                    self.window_profiler.end_action_handler();

                    if !cx.propagate_event {
                        return;
                    }
                }
            }
        }

        // Bubble phase for window actions.
        for node_id in dispatch_path.iter().rev() {
            let node = self.rendered_frame.dispatch_tree.node(*node_id);
            for DispatchActionListener {
                action_type,
                listener,
            } in node.action_listeners.clone()
            {
                let any_action = action.as_any();
                if action_type == any_action.type_id() {
                    cx.propagate_event = false; // Actions stop propagation by default during the bubble phase
                    #[cfg(feature = "profiler")]
                    self.window_profiler.begin_action_handler(action, cx);
                    listener(any_action, DispatchPhase::Bubble, self, cx);
                    #[cfg(feature = "profiler")]
                    self.window_profiler.end_action_handler();

                    if !cx.propagate_event {
                        return;
                    }
                }
            }
        }

        // Bubble phase for global actions.
        if let Some(mut global_listeners) = cx
            .global_action_listeners
            .remove(&action.as_any().type_id())
        {
            for listener in global_listeners.iter().rev() {
                cx.propagate_event = false; // Actions stop propagation by default during the bubble phase

                #[cfg(feature = "profiler")]
                self.window_profiler.begin_action_handler(action, cx);
                listener(action.as_any(), DispatchPhase::Bubble, cx);
                #[cfg(feature = "profiler")]
                self.window_profiler.end_action_handler();
                if !cx.propagate_event {
                    break;
                }
            }

            global_listeners.extend(
                cx.global_action_listeners
                    .remove(&action.as_any().type_id())
                    .unwrap_or_default(),
            );

            cx.global_action_listeners
                .insert(action.as_any().type_id(), global_listeners);
        }
    }

    /// Observes mutations, replacement, or removal of global type `G` in this window.
    ///
    /// Registration becomes active during effect processing and does not
    /// deliver changes queued before activation. Pending notifications can
    /// coalesce; the callback reads the current value, not a change log.
    /// Use [`App::try_global`] if removal is possible.
    ///
    /// Retain the returned subscription. The callback stops when it is dropped
    /// or this window becomes unavailable. [`App::observe_global`] supplies
    /// the same observation without a window borrow.
    pub fn observe_global<G: Global>(
        &mut self,
        cx: &mut App,
        f: impl Fn(&mut Window, &mut App) + 'static,
    ) -> Subscription {
        let window_handle = self.handle;
        let (subscription, activate) = cx.global_observers.insert(
            TypeId::of::<G>(),
            Box::new(move |cx| {
                window_handle
                    .update(cx, |_, window, cx| f(window, cx))
                    .is_ok()
            }),
        );
        cx.defer(move |_| activate());
        subscription
    }

    /// Asks the platform to activate this window.
    ///
    /// Desktop focus-stealing rules may deny the request. This does not select
    /// a GPUI element; use [`Self::focus`] for that. The browser backend marks
    /// its canvas window active but cannot bring a background tab forward.
    pub fn activate(&self) {
        self.platform_window.activate(None);
    }

    /// Request focus using a token supplied by the desktop shell, such as a
    /// Wayland tray host. Show the window before calling this method.
    ///
    /// Returns whether the platform submitted the request. The compositor may
    /// still deny focus. Returns false for empty tokens or unsupported platforms;
    /// callers can then fall back to [`Self::activate`]. Tokens must not
    /// be reused for subsequent activations.
    pub fn activate_with_token(&self, token: &str) -> bool {
        !token.is_empty() && self.platform_window.activate(Some(token))
    }

    /// Requests that the operating system draw attention to this window.
    pub fn request_attention(&self) {
        self.platform_window.request_attention();
    }

    /// Minimize the current window at the platform level.
    pub fn minimize_window(&self) {
        self.platform_window.minimize();
    }

    /// Show or hide the current window at the platform level.
    ///
    /// Call [`Window::activate`] separately when the window should also receive focus.
    /// The window manager may still focus a window when it is shown.
    pub fn set_visible(&self, visible: bool) {
        self.platform_window.set_visible(visible);
    }

    /// Returns the platform's current visibility when it can be queried.
    pub fn is_visible(&self) -> Option<bool> {
        self.platform_window.is_visible()
    }

    /// Requests a transition into or out of platform fullscreen.
    ///
    /// Read [`Self::is_fullscreen`] for the reported state after the platform
    /// responds. The browser backend requests fullscreen for its canvas;
    /// browser policy can reject that request, including without a user gesture.
    /// See the [browser request rules](https://fullscreen.spec.whatwg.org/#dom-element-requestfullscreen).
    pub fn toggle_fullscreen(&self) {
        self.platform_window.toggle_fullscreen();
    }

    /// Toggle simple (borderless) fullscreen, where the window covers the entire
    /// screen including the menu bar and, on notched displays, the area around the
    /// notch. Unlike [`Window::toggle_fullscreen`], this does not move the window
    /// into its own Mission Control space. Only has an effect on macOS.
    pub fn toggle_simple_fullscreen(&self) {
        self.platform_window.toggle_simple_fullscreen();
    }

    /// Requests an IME candidate-panel position update at the next frame opportunity.
    ///
    /// The focused input handler supplies its selected text bounds. With no
    /// handler or no selected bounds, the callback leaves the platform position
    /// unchanged. Use this after scrolling or moving a text field.
    pub fn invalidate_character_coordinates(&self) {
        self.on_next_frame(|window, cx| {
            if let Some(mut input_handler) = window.platform_window.take_input_handler() {
                if let Some(bounds) = input_handler.selected_bounds(window, cx) {
                    window.platform_window.update_ime_position(bounds);
                }
                window.platform_window.set_input_handler(input_handler);
            }
        });
    }

    /// Present a native prompt when available, otherwise show GPUI's custom prompt.
    ///
    /// The receiver resolves to the zero-based index of the selected answer.
    /// Handle cancellation when awaiting it: the channel closes if its sender
    /// is dropped without responding. A retained custom view can keep that
    /// channel alive after it is no longer displayed.
    ///
    /// A custom builder installed through [`App::set_prompt_builder`] replaces
    /// native dialogs too. Otherwise the platform gets the first opportunity,
    /// with [`fallback_prompt_renderer`](crate::fallback_prompt_renderer) used
    /// when it cannot show the prompt. In-window prompts replace rather than
    /// stack: the newest is drawn above the root, and its response restores the
    /// focus selected before the first prompt. Builders control their own input
    /// and accessibility behavior.
    ///
    /// # Panics
    ///
    /// Panics if a builder re-enters this method while constructing a prompt.
    pub fn prompt<T>(
        &mut self,
        level: PromptLevel,
        message: &str,
        detail: Option<&str>,
        answers: &[T],
        cx: &mut App,
    ) -> oneshot::Receiver<usize>
    where
        T: Clone + Into<PromptButton>,
    {
        let prompt_builder = cx.prompt_builder.take();
        let Some(prompt_builder) = prompt_builder else {
            unreachable!("Re-entrant window prompting is not supported by GPUI");
        };

        let answers = answers
            .iter()
            .map(|answer| answer.clone().into())
            .collect::<Vec<_>>();

        let receiver = match &prompt_builder {
            PromptBuilder::Default => self
                .platform_window
                .prompt(level, message, detail, &answers)
                .unwrap_or_else(|| {
                    self.build_custom_prompt(&prompt_builder, level, message, detail, &answers, cx)
                }),
            PromptBuilder::Custom(_) => {
                self.build_custom_prompt(&prompt_builder, level, message, detail, &answers, cx)
            }
        };

        cx.prompt_builder = Some(prompt_builder);

        receiver
    }

    fn build_custom_prompt(
        &mut self,
        prompt_builder: &PromptBuilder,
        level: PromptLevel,
        message: &str,
        detail: Option<&str>,
        answers: &[PromptButton],
        cx: &mut App,
    ) -> oneshot::Receiver<usize> {
        let (sender, receiver) = oneshot::channel();
        let handle = PromptHandle::new(sender);
        let handle = (prompt_builder)(level, message, detail, answers, handle, self, cx);
        self.prompt = Some(handle);
        self.refresh();
        receiver
    }

    /// Returns whether a prompt rendered by GPUI is currently active in this window.
    ///
    /// This is only true for prompts rendered in the window (see
    /// [`App::set_prompt_builder`]), not for platform-native prompt dialogs.
    pub fn has_active_prompt(&self) -> bool {
        self.prompt.is_some()
    }

    /// Returns key contexts from the root toward the focused node in the rendered frame.
    ///
    /// With no rendered focus node, this uses the root path. It does not render
    /// pending state changes; contexts come from the last built dispatch tree.
    pub fn context_stack(&self) -> Vec<KeyContext> {
        let node_id = self.focus_node_id_in_rendered_frame(self.focus);
        let dispatch_tree = &self.rendered_frame.dispatch_tree;
        dispatch_tree
            .dispatch_path(node_id)
            .iter()
            .filter_map(move |&node_id| dispatch_tree.node(node_id).context.clone())
            .collect()
    }

    /// Builds one default value per registered action type on the focus path or app.
    ///
    /// Types that cannot be built without parameters are omitted. A listener's
    /// presence does not prove it will handle a particular value, and a key
    /// binding is not required. Use [`is_action_available`](Self::is_action_available)
    /// to check a supplied action against this window's path.
    /// Results are ordered by action type identity, not by a user-facing name;
    /// sort and label them before constructing a command menu.
    pub fn available_actions(&self, cx: &App) -> Vec<Box<dyn Action>> {
        let node_id = self.focus_node_id_in_rendered_frame(self.focus);
        let mut actions = self.rendered_frame.dispatch_tree.available_actions(node_id);
        for action_type in cx.global_action_listeners.keys() {
            if let Err(ix) = actions.binary_search_by_key(action_type, |a| a.as_any().type_id()) {
                let action = cx.actions.build_action_type(action_type).ok();
                if let Some(action) = action {
                    actions.insert(ix, action);
                }
            }
        }
        actions
    }

    /// Returns unshadowed key bindings for this action in the rendered focus context.
    ///
    /// Bindings must match the action's value as well as its type. Results retain
    /// insertion order; the last result is the usual shortcut to display. This
    /// looks up bindings, not whether a listener will handle the action.
    /// Contexts come from the selected focus path in the last rendered tree.
    /// A focus change between existing nodes affects this query immediately;
    /// a changed tree must be drawn before its new contexts can be queried.
    pub fn bindings_for_action(&self, action: &dyn Action) -> Vec<KeyBinding> {
        self.rendered_frame
            .dispatch_tree
            .bindings_for_action(action, &self.context_stack())
    }

    /// Returns the last unshadowed binding for `action` on the selected focus path.
    ///
    /// This has the same context and action-value rules as
    /// [`Self::bindings_for_action`], without collecting all matches. Use it
    /// to display one shortcut for a command. For a command aimed at another
    /// panel, query [`Self::highest_precedence_binding_for_action_in`] with
    /// that panel's focus handle instead.
    pub fn highest_precedence_binding_for_action(&self, action: &dyn Action) -> Option<KeyBinding> {
        self.rendered_frame
            .dispatch_tree
            .highest_precedence_binding_for_action(action, &self.context_stack())
    }

    /// Returns unshadowed bindings for this action using exactly one supplied context.
    ///
    /// This does not include the current focus's ancestor contexts. For a real
    /// candidate focus path, use [`bindings_for_action_in`](Self::bindings_for_action_in).
    pub fn bindings_for_action_in_context(
        &self,
        action: &dyn Action,
        context: KeyContext,
    ) -> Vec<KeyBinding> {
        let dispatch_tree = &self.rendered_frame.dispatch_tree;
        dispatch_tree.bindings_for_action(action, &[context])
    }

    /// Returns the last unshadowed binding for `action` in one supplied context.
    ///
    /// Like [`Self::bindings_for_action_in_context`], this excludes ancestor
    /// contexts. Use [`Self::highest_precedence_binding_for_action_in`] when
    /// the query should include a rendered panel's whole focus path.
    pub fn highest_precedence_binding_for_action_in_context(
        &self,
        action: &dyn Action,
        context: KeyContext,
    ) -> Option<KeyBinding> {
        let dispatch_tree = &self.rendered_frame.dispatch_tree;
        dispatch_tree.highest_precedence_binding_for_action(action, &[context])
    }

    /// Returns unshadowed bindings for this action on a candidate focus path.
    ///
    /// This does not move focus. A handle absent from the rendered dispatch tree
    /// produces an empty result. Results retain insertion order, as in
    /// [`bindings_for_action`](Self::bindings_for_action).
    pub fn bindings_for_action_in(
        &self,
        action: &dyn Action,
        focus_handle: &FocusHandle,
    ) -> Vec<KeyBinding> {
        let dispatch_tree = &self.rendered_frame.dispatch_tree;
        let Some(context_stack) = self.context_stack_for_focus_handle(focus_handle) else {
            return vec![];
        };
        dispatch_tree.bindings_for_action(action, &context_stack)
    }

    /// Returns the last unshadowed binding on a candidate focus path.
    ///
    /// This does not move focus. It returns `None` if the handle has no node
    /// in the rendered tree or no binding matches. It follows the same rules
    /// as [`Self::bindings_for_action_in`], without collecting all matches.
    pub fn highest_precedence_binding_for_action_in(
        &self,
        action: &dyn Action,
        focus_handle: &FocusHandle,
    ) -> Option<KeyBinding> {
        let dispatch_tree = &self.rendered_frame.dispatch_tree;
        let context_stack = self.context_stack_for_focus_handle(focus_handle)?;
        dispatch_tree.highest_precedence_binding_for_action(action, &context_stack)
    }

    /// Returns longer bindings for which `input` is a proper prefix on the focus path.
    ///
    /// Complete bindings and removal actions are omitted. Results are sorted
    /// by context depth, then later insertion first. Removal entries are not
    /// applied to the other candidates, so this is a completion list rather
    /// than a guarantee that each binding will dispatch. See
    /// [`Keymap::possible_next_bindings_for_input`](crate::Keymap::possible_next_bindings_for_input).
    pub fn possible_bindings_for_input(&self, input: &[Keystroke]) -> Vec<KeyBinding> {
        self.rendered_frame
            .dispatch_tree
            .possible_next_bindings_for_input(input, &self.context_stack())
    }

    fn context_stack_for_focus_handle(
        &self,
        focus_handle: &FocusHandle,
    ) -> Option<Vec<KeyContext>> {
        let dispatch_tree = &self.rendered_frame.dispatch_tree;
        let node_id = dispatch_tree.focusable_node_id(focus_handle.id)?;
        let context_stack: Vec<_> = dispatch_tree
            .dispatch_path(node_id)
            .into_iter()
            .filter_map(|node_id| dispatch_tree.node(node_id).context.clone())
            .collect();
        Some(context_stack)
    }

    /// Build an event listener that updates a view while handling the event.
    ///
    /// The captured entity is weak: if it has been released, the callback silently does nothing.
    pub fn listener_for<T: 'static, E>(
        &self,
        view: &Entity<T>,
        f: impl Fn(&mut T, &E, &mut Window, &mut Context<T>) + 'static,
    ) -> impl Fn(&E, &mut Window, &mut App) + 'static {
        let view = view.downgrade();
        move |e: &E, window: &mut Window, cx: &mut App| {
            view.update(cx, |view, cx| f(view, e, window, cx)).ok();
        }
    }

    /// Build a handler that updates an entity with its typed context.
    ///
    /// The captured entity is weak: if it has been released, the callback silently does nothing.
    pub fn handler_for<E: 'static, Callback: Fn(&mut E, &mut Window, &mut Context<E>) + 'static>(
        &self,
        entity: &Entity<E>,
        f: Callback,
    ) -> impl Fn(&mut Window, &mut App) + 'static {
        let entity = entity.downgrade();
        move |window: &mut Window, cx: &mut App| {
            entity.update(cx, |entity, cx| f(entity, window, cx)).ok();
        }
    }

    /// Register the callback for a native close request.
    ///
    /// Replaces any previously registered callback. Return `false` to veto
    /// closing and `true` to allow it. For an asynchronous decision, return
    /// `false`, await the answer in a task, then call [`Self::remove_window`]
    /// after approval; direct removal does not invoke this callback again.
    /// If the app context is no longer available when the native callback runs,
    /// GPUI allows the close. See the
    /// [prompt example](crate::_documentation::platforms#wait-for-a-prompt-without-blocking-the-window).
    pub fn on_window_should_close(
        &self,
        cx: &App,
        f: impl Fn(&mut Window, &mut App) -> bool + 'static,
    ) {
        let mut cx = self.to_async(cx);
        self.platform_window.on_should_close(Box::new(move || {
            cx.update(|window, cx| f(window, cx)).unwrap_or(true)
        }))
    }

    /// Registers a listener for `action_type` at the current dispatch node.
    ///
    /// Call this during paint, while building the node's frame. The resulting
    /// listener receives both dispatch phases and remains attached to that
    /// frame. Register it when rebuilding the node; a cached subtree can reuse
    /// its previous listener record. Use [`DispatchPhase`] to choose when to
    /// handle the action.
    ///
    /// Prefer [`InteractiveElement::on_action`](crate::InteractiveElement::on_action)
    /// for a typed handler on a view's element. This method accepts erased
    /// actions for custom elements that manage their own dispatch nodes.
    pub fn on_action(
        &mut self,
        action_type: TypeId,
        listener: impl Fn(&dyn Any, DispatchPhase, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();

        self.next_frame
            .dispatch_tree
            .on_action(action_type, Rc::new(listener));
    }

    /// Registers [`on_action`](Self::on_action)'s listener when `condition` is true.
    ///
    /// This has the same paint-phase requirement and frame lifetime as
    /// `on_action`. It does not select a dispatch phase: the listener receives
    /// the phase as an argument.
    pub fn on_action_when(
        &mut self,
        condition: bool,
        action_type: TypeId,
        listener: impl Fn(&dyn Any, DispatchPhase, &mut Window, &mut App) + 'static,
    ) {
        self.invalidator.debug_assert_paint();

        if condition {
            self.next_frame
                .dispatch_tree
                .on_action(action_type, Rc::new(listener));
        }
    }

    /// Returns adapter and driver details when this renderer can report them.
    ///
    /// The macOS Metal backend and simulated test windows return `None`.
    /// WGPU backends and Windows DirectX report details, though an unavailable
    /// device or backend error can still produce `None`. The strings are
    /// backend-specific; see [`GpuSpecs`].
    pub fn gpu_specs(&self) -> Option<GpuSpecs> {
        self.platform_window.gpu_specs()
    }

    /// Clones the renderer's device and queue when the backend exposes them.
    ///
    /// The supplied WGPU backends return a boxed
    /// `(Arc<wgpu::Device>, Arc<wgpu::Queue>)`; downcasting requires the same
    /// WGPU version as the renderer. The default macOS Metal renderer and
    /// Windows DirectX renderer return `None`. Where available,
    /// `gpu_context_info` provides a typed handle carrying the surface format
    /// and device-loss state.
    /// Custom resources must use GPUI's device to be composited by that renderer.
    #[cfg(any(
        target_os = "linux",
        target_os = "freebsd",
        target_os = "windows",
        target_os = "macos"
    ))]
    pub fn gpu_context(&self) -> Option<Box<dyn std::any::Any>> {
        self.platform_window.gpu_context()
    }

    /// Returns a backend-specific handle for sharing GPUI's rendering device.
    ///
    /// The supplied WGPU backends return `gpui_wgpu::WgpuContextHandle`.
    /// Its `from_window` helper performs the downcast and returns `None` when
    /// the renderer does not expose that type. On macOS, enable the platform
    /// facade's `macos-wgpu` feature to select that renderer. See the
    /// [platform feature guide](crate::_documentation::platforms#cargo-features).
    /// A retained handle does not follow device replacement; recreate custom
    /// device-bound resources after loss and reacquire the handle after recovery.
    #[cfg(any(
        target_family = "wasm",
        target_os = "linux",
        target_os = "freebsd",
        target_os = "macos"
    ))]
    pub fn gpu_context_info(&self) -> Option<Box<dyn std::any::Any>> {
        self.platform_window.gpu_context_info()
    }

    /// Whether the GPU device backing this window has been lost (recovery
    /// happens on a subsequent platform draw). `None` when the backend
    /// cannot know. Embedders that captured the device from
    /// [`Self::gpu_context`] should stop submitting while this is
    /// `Some(true)` and re-acquire the device once it reads `Some(false)`.
    #[cfg(any(
        target_os = "linux",
        target_os = "freebsd",
        target_os = "windows",
        target_os = "macos"
    ))]
    pub fn gpu_device_lost(&self) -> Option<bool> {
        self.platform_window.gpu_device_lost()
    }

    /// Perform titlebar double-click action.
    /// This is macOS specific.
    pub fn titlebar_double_click(&self) {
        self.platform_window
            .titlebar_double_click(self.is_resizable, self.is_minimizable);
    }

    /// Reads the backend's current window title.
    ///
    /// The supplied macOS backend reports its native title. Other backends
    /// currently use the trait's empty-string default, even after
    /// [`Self::set_window_title`]. Keep application title state on its owner
    /// when it must be readable across platforms.
    pub fn window_title(&self) -> String {
        self.platform_window.get_title()
    }

    /// Lists GPUI windows in this window's native macOS tab group.
    ///
    /// `None` means no group was reported or the backend does not support
    /// native tabs. The list is a snapshot, not a subscription to tab changes.
    pub fn tabbed_windows(&self) -> Option<Vec<SystemWindowTab>> {
        self.platform_window.tabbed_windows()
    }

    /// Returns the tab bar visibility.
    /// This is macOS specific.
    pub fn tab_bar_visible(&self) -> bool {
        self.platform_window.tab_bar_visible()
    }

    /// Merges all open windows into a single tabbed window.
    /// This is macOS specific.
    pub fn merge_all_windows(&self) {
        self.platform_window.merge_all_windows()
    }

    /// Moves the tab to a new containing window.
    /// This is macOS specific.
    pub fn move_tab_to_new_window(&self) {
        self.platform_window.move_tab_to_new_window()
    }

    /// Shows or hides the window tab overview.
    /// This is macOS specific.
    pub fn toggle_window_tab_overview(&self) {
        self.platform_window.toggle_window_tab_overview()
    }

    /// Sets the tabbing identifier for the window.
    /// This is macOS specific.
    pub fn set_tabbing_identifier(&self, tabbing_identifier: Option<String>) {
        self.platform_window
            .set_tabbing_identifier(tabbing_identifier)
    }

    /// Request the OS to play an alert sound. On some platforms this is associated
    /// with the window, for others it's just a simple global function call.
    pub fn play_system_bell(&self) {
        self.platform_window.play_system_bell()
    }

    /// Returns whether this frame builds an accessibility tree.
    ///
    /// The platform can request the tree, or the application can force it for
    /// inspection. A `true` result does not establish that a screen reader is
    /// connected. [`Application::new_inaccessible`](crate::Application::new_inaccessible)
    /// disables both paths.
    ///
    /// Use this to skip computing data during rendering that is only
    /// observable through the accessibility tree. When accessibility is
    /// activated, a redraw is forced, so gated work is recomputed before the
    /// next tree update is sent to the platform.
    ///
    /// See the [accessibility guide](crate::_accessibility) for an overview.
    pub fn is_a11y_active(&self) -> bool {
        self.a11y.is_active()
    }

    /// Build this window's accessibility tree every frame, even with no
    /// assistive technology connected, so [`Self::debug_a11y_tree_json`] and
    /// the accessibility actions work for automation. Forces a redraw, since
    /// the tree is built during prepaint. [`crate::Application::new_inaccessible`]
    /// still wins.
    pub fn set_a11y_forced(&mut self, forced: bool) {
        self.a11y.set_forced(forced);
        self.refresh();
    }

    /// Serializes the last built accessibility tree for inspection.
    ///
    /// Returns `None` before a tree has been built. The JSON includes node
    /// properties, focus, bounds, and frame metadata; debug builds also include
    /// element provenance. Displayed node keys such as `a` and `b` are temporary
    /// labels, not stable AccessKit IDs. Use [`Self::a11y_tree`] for IDs passed
    /// to accessibility actions. This debug format is not a stable schema.
    pub fn debug_a11y_tree_json(&self) -> Option<String> {
        self.a11y.debug_tree_json()
    }

    /// Borrows the most recently built accessibility tree.
    ///
    /// Returns `None` before the first tree. If tree construction becomes
    /// inactive, this retains the last snapshot rather than clearing it;
    /// compare [`Self::a11y_frame_number`] when freshness matters. Node IDs
    /// stay stable with element identity. Read matching window-local geometry
    /// through [`Self::a11y_node_bounds`].
    pub fn a11y_tree(&self) -> Option<&accesskit::TreeUpdate> {
        self.a11y.last_tree_update()
    }

    /// Window-space bounds, in logical pixels, of a node in the last built tree.
    pub fn a11y_node_bounds(&self, node: accesskit::NodeId) -> Option<Bounds<Pixels>> {
        self.a11y.last_node_bounds(node)
    }

    /// How many accessibility trees this window has built; zero before the
    /// first. Lets a caller tell a fresh tree from the one it already read.
    pub fn a11y_frame_number(&self) -> u64 {
        self.a11y.frame_number()
    }

    /// Registers a handler for an AccessKit action on one node.
    ///
    /// Register during paint and repeat when rebuilding the element: listeners
    /// are cleared for each new frame. A matching request invokes all handlers
    /// registered for this node and action, then skips the built-in fallback.
    ///
    /// This registers behavior only. It does not create the node or advertise
    /// its supported actions. Prefer
    /// [`StatefulInteractiveElement::on_a11y_action`](crate::StatefulInteractiveElement::on_a11y_action)
    /// when using ordinary elements; custom elements must also write the
    /// capability to their AccessKit node. See [accessibility](crate::_accessibility).
    pub fn on_a11y_action(
        &mut self,
        node_id: accesskit::NodeId,
        action: accesskit::Action,
        listener: impl FnMut(Option<&accesskit::ActionData>, &mut Window, &mut App) + 'static,
    ) {
        self.a11y
            .action_listeners
            .entry(node_id)
            .or_default()
            .push((action, Box::new(listener)));
    }

    /// Delivers an accessibility action through the native adapter's handling path.
    ///
    /// Useful for automation and tests. Registered [`Self::on_a11y_action`]
    /// handlers run first; a match suppresses fallback behavior. Otherwise,
    /// `Click` synthesizes a pointer press/release at the node's recorded center,
    /// `Focus` selects its live focus handle, and `Blur` clears window focus.
    /// A missing node prevents the click or focus fallback; `Blur` applies to
    /// the window regardless of the target. Other unhandled actions do nothing.
    ///
    /// Use IDs from [`Self::a11y_tree`], not temporary keys from the JSON dump.
    /// This exercises GPUI's routing; it does not test what a screen reader
    /// announces. See the [testing chapter](https://gpui-ce.github.io/book/testing.html).
    #[cfg(not(target_family = "wasm"))]
    pub fn perform_a11y_action(
        &mut self,
        target: accesskit::NodeId,
        action: accesskit::Action,
        data: Option<accesskit::ActionData>,
        cx: &mut App,
    ) {
        self.handle_a11y_action(
            accesskit::ActionRequest {
                action,
                target_tree: accesskit::TreeId::ROOT,
                target_node: target,
                data,
            },
            cx,
        );
    }

    #[cfg(not(target_family = "wasm"))]
    pub(crate) fn handle_a11y_action(&mut self, request: accesskit::ActionRequest, cx: &mut App) {
        // Take listeners out temporarily so the closures can borrow Window
        // mutably, then restore them afterward.
        if let Some(mut listeners) = self.a11y.action_listeners.remove(&request.target_node) {
            let extra_data = request.data.as_ref();
            let mut matched = false;
            for (action, listener) in &mut listeners {
                if *action == request.action {
                    listener(extra_data, self, cx);
                    matched = true;
                }
            }
            self.a11y
                .action_listeners
                .insert(request.target_node, listeners);
            if matched {
                return;
            }
        }

        // Fall back to built-in action handling.
        match request.action {
            accesskit::Action::Click => {
                if let Some(bounds) = self.a11y.node_bounds.get(&request.target_node).copied() {
                    let center = bounds.center();
                    let mouse_down = PlatformInput::MouseDown(crate::MouseDownEvent {
                        button: MouseButton::Left,
                        position: center,
                        modifiers: Modifiers::default(),
                        click_count: 1,
                        first_mouse: false,
                    });
                    let mouse_up = PlatformInput::MouseUp(MouseUpEvent {
                        button: MouseButton::Left,
                        position: center,
                        modifiers: Modifiers::default(),
                        click_count: 1,
                    });
                    self.dispatch_event(mouse_down, cx);
                    self.dispatch_event(mouse_up, cx);
                }
            }
            accesskit::Action::Focus => {
                if let Some(focus_id) = self.a11y.focus_ids.get(&request.target_node).copied()
                    && let Some(handle) = FocusHandle::for_id(focus_id, &cx.focus_handles)
                {
                    self.focus(&handle, cx);
                }
            }
            accesskit::Action::Blur => {
                self.blur(cx);
            }
            _ => {
                log::debug!(
                    "Unhandled a11y action: {:?} on {:?}",
                    request.action,
                    request.target_node
                );
            }
        }
    }

    /// Toggles the inspector mode on this window.
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub fn toggle_inspector(&mut self, cx: &mut App) {
        self.inspector = match self.inspector {
            None => Some(cx.new(|_| Inspector::new())),
            Some(_) => None,
        };
        self.refresh();
    }

    /// Returns true if the window is in inspector mode.
    pub fn is_inspector_picking(&self, _cx: &App) -> bool {
        #[cfg(any(feature = "inspector", debug_assertions))]
        {
            if let Some(inspector) = &self.inspector {
                return inspector.read(_cx).is_picking();
            }
        }
        false
    }

    /// Executes the provided function with mutable access to an inspector state.
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub fn with_inspector_state<T: 'static, R>(
        &mut self,
        _inspector_id: Option<&crate::InspectorElementId>,
        cx: &mut App,
        f: impl FnOnce(&mut Option<T>, &mut Self) -> R,
    ) -> R {
        if let Some(inspector_id) = _inspector_id
            && let Some(inspector) = &self.inspector
        {
            let inspector = inspector.clone();
            let active_element_id = inspector.read(cx).active_element_id();
            if Some(inspector_id) == active_element_id {
                return inspector.update(cx, |inspector, _cx| {
                    inspector.with_active_element_state(self, f)
                });
            }
        }
        f(&mut None, self)
    }

    #[cfg(any(feature = "inspector", debug_assertions))]
    pub(crate) fn build_inspector_element_id(
        &mut self,
        path: crate::InspectorElementPath,
    ) -> crate::InspectorElementId {
        self.invalidator.debug_assert_paint_or_prepaint();
        let path = Rc::new(path);
        let next_instance_id = self
            .next_frame
            .next_inspector_instance_ids
            .entry(path.clone())
            .or_insert(0);
        let instance_id = *next_instance_id;
        *next_instance_id += 1;
        crate::InspectorElementId { path, instance_id }
    }

    #[cfg(any(feature = "inspector", debug_assertions))]
    fn prepaint_inspector(&mut self, inspector_width: Pixels, cx: &mut App) -> Option<AnyElement> {
        if let Some(inspector) = self.inspector.take() {
            let mut inspector_element = AnyView::from(inspector.clone()).into_any_element();
            inspector_element.prepaint_as_root(
                point(self.viewport_size.width - inspector_width, px(0.0)),
                size(inspector_width, self.viewport_size.height).into(),
                self,
                cx,
            );
            self.inspector = Some(inspector);
            Some(inspector_element)
        } else {
            None
        }
    }

    #[cfg(any(feature = "inspector", debug_assertions))]
    fn paint_inspector(&mut self, mut inspector_element: Option<AnyElement>, cx: &mut App) {
        if let Some(mut inspector_element) = inspector_element {
            inspector_element.paint(self, cx);
        };
    }

    /// Registers a hitbox that can be used for inspector picking mode, allowing users to select and
    /// inspect UI elements by clicking on them.
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub fn insert_inspector_hitbox(
        &mut self,
        hitbox_id: HitboxId,
        inspector_id: Option<&crate::InspectorElementId>,
        cx: &App,
    ) {
        self.invalidator.debug_assert_paint_or_prepaint();
        if !self.is_inspector_picking(cx) {
            return;
        }
        if let Some(inspector_id) = inspector_id {
            self.next_frame
                .inspector_hitboxes
                .insert(hitbox_id, inspector_id.clone());
        }
    }

    #[cfg(any(feature = "inspector", debug_assertions))]
    fn paint_inspector_hitbox(&mut self, cx: &App) {
        if let Some(inspector) = self.inspector.as_ref() {
            let inspector = inspector.read(cx);
            if let Some((hitbox_id, _)) = self.hovered_inspector_hitbox(inspector, &self.next_frame)
                && let Some(hitbox) = self
                    .next_frame
                    .hitboxes
                    .iter()
                    .find(|hitbox| hitbox.id == hitbox_id)
            {
                self.paint_quad(crate::fill(hitbox.bounds, crate::rgba(0x61afef4d)));
            }
        }
    }

    #[cfg(any(feature = "inspector", debug_assertions))]
    fn handle_inspector_mouse_event(&mut self, event: &dyn Any, cx: &mut App) {
        let Some(inspector) = self.inspector.clone() else {
            return;
        };
        if event.downcast_ref::<MouseMoveEvent>().is_some() {
            inspector.update(cx, |inspector, _cx| {
                if let Some((_, inspector_id)) =
                    self.hovered_inspector_hitbox(inspector, &self.rendered_frame)
                {
                    inspector.hover(inspector_id, self);
                }
            });
        } else if event.downcast_ref::<crate::MouseDownEvent>().is_some() {
            inspector.update(cx, |inspector, _cx| {
                if let Some((_, inspector_id)) =
                    self.hovered_inspector_hitbox(inspector, &self.rendered_frame)
                {
                    inspector.select(inspector_id, self);
                }
            });
        } else if let Some(event) = event.downcast_ref::<crate::ScrollWheelEvent>() {
            // This should be kept in sync with SCROLL_LINES in x11 platform.
            const SCROLL_LINES: f32 = 3.0;
            const SCROLL_PIXELS_PER_LAYER: f32 = 36.0;
            let delta_y = event
                .delta
                .pixel_delta(px(SCROLL_PIXELS_PER_LAYER / SCROLL_LINES))
                .y;
            if let Some(inspector) = self.inspector.clone() {
                inspector.update(cx, |inspector, _cx| {
                    if let Some(depth) = inspector.pick_depth.as_mut() {
                        *depth += f32::from(delta_y) / SCROLL_PIXELS_PER_LAYER;
                        let max_depth = self.mouse_hit_test.entries.len() as f32 - 0.5;
                        if *depth < 0.0 {
                            *depth = 0.0;
                        } else if *depth > max_depth {
                            *depth = max_depth;
                        }
                        if let Some((_, inspector_id)) =
                            self.hovered_inspector_hitbox(inspector, &self.rendered_frame)
                        {
                            inspector.set_active_element_id(inspector_id, self);
                        }
                    }
                });
            }
        }
    }

    #[cfg(any(feature = "inspector", debug_assertions))]
    fn hovered_inspector_hitbox(
        &self,
        inspector: &Inspector,
        frame: &Frame,
    ) -> Option<(HitboxId, crate::InspectorElementId)> {
        if let Some(pick_depth) = inspector.pick_depth {
            let depth = (pick_depth as i64).try_into().unwrap_or(0);
            let max_skipped = self.mouse_hit_test.entries.len().saturating_sub(1);
            let skip_count = (depth as usize).min(max_skipped);
            for hitbox_id in self.mouse_hit_test.ordered_ids.iter().skip(skip_count) {
                if let Some(inspector_id) = frame.inspector_hitboxes.get(hitbox_id) {
                    return Some((*hitbox_id, inspector_id.clone()));
                }
            }
        }
        None
    }

    /// For testing: set the current modifier keys state.
    /// This does not generate any events.
    #[cfg(any(test, feature = "headless"))]
    pub fn set_modifiers(&mut self, modifiers: Modifiers) {
        self.modifiers = modifiers;
    }

    /// For testing: simulate a mouse move event to the given position.
    /// This dispatches the event through the normal event handling path,
    /// which will trigger hover states and tooltips.
    #[cfg(any(test, feature = "headless"))]
    pub fn simulate_mouse_move(&mut self, position: Point<Pixels>, cx: &mut App) {
        let event = PlatformInput::MouseMove(MouseMoveEvent {
            position,
            modifiers: self.modifiers,
            pressed_button: None,
        });
        let _ = self.dispatch_event(event, cx);
    }
}

// #[derive(Clone, Copy, Eq, PartialEq, Hash)]
slotmap::new_key_type! {
    /// Identifies a window slot within an app.
    ///
    /// This value does not retain the window. It includes a slot generation
    /// so a later window can occupy the same slot without sharing its ID.
    /// It is not a persistent identifier across app instances or processes.
    pub struct WindowId;
}

impl WindowId {
    /// Returns the slot and generation encoded as an opaque integer.
    ///
    /// Converting back with `WindowId::from` reconstructs the value; it does
    /// not check that a corresponding window exists in any app.
    pub fn as_u64(&self) -> u64 {
        self.0.as_ffi()
    }
}

impl From<u64> for WindowId {
    fn from(value: u64) -> Self {
        WindowId(slotmap::KeyData::from_ffi(value))
    }
}

/// Finds a window through an app context, expecting a particular root view type.
///
/// Copying or dropping the handle does not affect window lifetime. Operations
/// fail after the window closes or its live root changes to another type.
/// Use [`Self::update`] to change that root with its typed context, or
/// [`Self::entity`] to retain the root entity independently of the window.
/// The handle's `Deref` exposes [`AnyWindowHandle`] operations when the root
/// type is not needed. See [ownership](crate::_ownership_and_data_flow).
///
/// Use the handle with the app that opened the window. Its ID identifies an
/// app-local slot and generation; the handle carries no app identity to reject
/// a different app that happens to contain the same slot.
#[derive(Deref, DerefMut)]
pub struct WindowHandle<V> {
    #[deref]
    #[deref_mut]
    pub(crate) any_handle: AnyWindowHandle,
    state_type: PhantomData<fn(V) -> V>,
}

impl<V> Debug for WindowHandle<V> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("WindowHandle")
            .field("any_handle", &self.any_handle.id.as_u64())
            .finish()
    }
}

impl<V: 'static + Render> WindowHandle<V> {
    /// Declares a window ID to have root view type `V`, without looking it up.
    ///
    /// Prefer the handle returned by [`App::open_window`]. This constructor is
    /// for integrations that already know an ID and its root type; it neither
    /// creates nor retains a window. Reads and updates check the live root and
    /// return an error if the window is absent or its type differs from `V`.
    /// Pass the resulting handle only to the app that supplied `id`.
    pub fn new(id: WindowId) -> Self {
        WindowHandle {
            any_handle: AnyWindowHandle {
                id,
                state_type: TypeId::of::<V>(),
                root_entity_type_name: std::any::type_name::<V>(),
            },
            state_type: PhantomData,
        }
    }

    /// Clones the live root entity through mutable window access.
    ///
    /// Returns an error when the window is absent, already being updated, or
    /// no longer has a root of type `V`. The returned entity retains its value
    /// independently of the window. Use [`Self::entity`] when a read-only app
    /// context is available and the window is not already being updated.
    #[cfg(any(test, feature = "headless"))]
    pub fn root<C>(&self, cx: &mut C) -> Result<Entity<V>>
    where
        C: AppContext,
    {
        cx.update_window(self.any_handle, |root_view, _, _| {
            root_view
                .downcast::<V>()
                .map_err(|_| anyhow!("the type of the window's root view has changed"))
        })?
    }

    /// Updates the root view of this window.
    ///
    /// Returns an error if the window has closed or its root is no longer `V`.
    /// With an app-backed context, also returns an error while this window is
    /// already being updated. Use the callback's `Window` instead of reacquiring it.
    /// The callback borrows the root exclusively; reading or updating that
    /// same entity through a handle inside the callback panics. Changing the
    /// root's state does not notify automatically; call [`Context::notify`].
    pub fn update<C, R>(
        &self,
        cx: &mut C,
        update: impl FnOnce(&mut V, &mut Window, &mut Context<V>) -> R,
    ) -> Result<R>
    where
        C: AppContext,
    {
        cx.update_window(self.any_handle, |root_view, window, cx| {
            let view = root_view
                .downcast::<V>()
                .map_err(|_| anyhow!("the type of the window's root view has changed"))?;

            Ok(view.update(cx, |view, cx| update(view, window, cx)))
        })?
    }

    /// Reads the root view through an existing app borrow.
    ///
    /// The returned reference is tied to `cx`. Returns an error if the window
    /// is closed, already being updated, or has a root of another type. Reading
    /// a root entity that is itself already under update still panics.
    ///
    /// Use [`read_with`](Self::read_with) for a generic [`AppContext`], or
    /// [`update`](Self::update) to change the root. Unlike this method,
    /// `read_with` panics when an app-backed window is already being updated.
    pub fn read<'a>(&self, cx: &'a App) -> Result<&'a V> {
        let x = cx
            .windows
            .get(self.id)
            .and_then(|window| {
                window
                    .as_deref()
                    .and_then(|window| window.root.clone())
                    .map(|root_view| root_view.downcast::<V>())
            })
            .context("window not found")?
            .map_err(|_| anyhow!("the type of the window's root view has changed"))?;

        Ok(x.read(cx))
    }

    /// Read the root view through an app-context callback.
    ///
    /// Use this when the caller has a generic [`AppContext`] or needs to compute a result without
    /// returning a reference tied to a particular app borrow. It fails if the window is closed or
    /// if the live root view's type does not match `V`.
    ///
    /// # Panics
    ///
    /// With an app-backed context, panics if this window is already being
    /// updated. Read the root supplied to that update callback instead.
    /// Reading an already borrowed root entity or acquiring conflicting async
    /// app access also panics; see [`AppContext::read_window`].
    pub fn read_with<C, R>(&self, cx: &C, read_with: impl FnOnce(&V, &App) -> R) -> Result<R>
    where
        C: AppContext,
    {
        cx.read_window(self, |root_view, cx| read_with(root_view.read(cx), cx))
    }

    /// Clones a strong handle to the window's current root entity.
    ///
    /// Returns an error if the window is closed or its live root is no longer
    /// `V`. Retaining the entity keeps its state alive, even after window
    /// removal; it does not retain a window for later drawing or input.
    ///
    /// # Panics
    ///
    /// With an app-backed context, panics if this window is already being
    /// updated. Clone the root handle before entering that callback when it
    /// must be retained separately.
    ///
    /// # Example: retain state after closing the window
    ///
    /// ```rust,test_harness
    /// use gpui::{Context, Render, TestAppContext, Window, div, prelude::*, px, size};
    ///
    /// struct Root { value: usize }
    ///
    /// impl Render for Root {
    ///     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
    ///         div().child(self.value.to_string())
    ///     }
    /// }
    ///
    /// #[gpui::test]
    /// fn keep_state_after_closing(cx: &mut TestAppContext) {
    ///     let window = cx.open_window(size(px(200.), px(100.)), |_, _| Root { value: 7 });
    ///     let root = window.entity(cx).unwrap();
    ///     window.update(cx, |_, window, _| window.remove_window()).unwrap();
    ///
    ///     assert!(window.entity(cx).is_err());
    ///     assert_eq!(root.read_with(cx, |root, _| root.value), 7);
    /// }
    /// ```
    pub fn entity<C>(&self, cx: &C) -> Result<Entity<V>>
    where
        C: AppContext,
    {
        cx.read_window(self, |root_view, _cx| root_view)
    }

    /// Reports whether the platform considers this window active.
    ///
    /// Returns `None` if the window is closed or already being updated.
    /// Activation belongs to the platform window; it does not identify the
    /// selected [`FocusHandle`] inside it. See [`Window::is_window_active`].
    pub fn is_active(&self, cx: &mut App) -> Option<bool> {
        cx.update_window(self.any_handle, |_, window, _| window.is_window_active())
            .ok()
    }
}

impl<V> Copy for WindowHandle<V> {}

impl<V> Clone for WindowHandle<V> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<V> PartialEq for WindowHandle<V> {
    fn eq(&self, other: &Self) -> bool {
        self.any_handle == other.any_handle
    }
}

impl<V> Eq for WindowHandle<V> {}

impl<V> Hash for WindowHandle<V> {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.any_handle.hash(state);
    }
}

impl<V: 'static> From<WindowHandle<V>> for AnyWindowHandle {
    fn from(val: WindowHandle<V>) -> Self {
        val.any_handle
    }
}

/// A copyable window identity with the root type declared when it was opened.
///
/// This handle does not own the window; dropping all copies does not close it.
/// Use [`update`](Self::update) to reacquire the live window through an app
/// context. Closing the window makes those operations fail. The stored type
/// metadata supports [`downcast`](Self::downcast), but replacing the live root
/// can make a previously obtained typed handle fail its next read or update.
/// Use it only with the app that opened the window; the stored ID does not
/// distinguish identical slot values in different app instances.
#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug)]
pub struct AnyWindowHandle {
    pub(crate) id: WindowId,
    state_type: TypeId,
    root_entity_type_name: &'static str,
}

impl AnyWindowHandle {
    /// Returns the window's app-local slot and generation.
    ///
    /// The ID does not retain or look up the window. Keep its originating app
    /// alongside it when passing it through an integration boundary.
    pub fn window_id(&self) -> WindowId {
        self.id
    }

    /// Returns the name of the window's declared root entity type.
    pub fn root_entity_type_name(&self) -> &'static str {
        self.root_entity_type_name
    }

    /// Converts the stored root-type metadata to a typed window handle.
    ///
    /// Returns `None` when `T` differs from the declared type. This performs no
    /// app lookup: success does not prove the window remains open or that its
    /// live root has not been replaced. The next window operation checks those
    /// conditions.
    pub fn downcast<T: 'static>(&self) -> Option<WindowHandle<T>> {
        if TypeId::of::<T>() == self.state_type {
            Some(WindowHandle {
                any_handle: *self,
                state_type: PhantomData,
            })
        } else {
            None
        }
    }

    /// Borrows the live window and passes its current erased root to `update`.
    ///
    /// Unlike [`WindowHandle::update`], this does not lease the root entity
    /// before invoking the callback; update the supplied [`AnyView`] when
    /// needed. Returns an error for a closed or already borrowed window.
    /// Async app-access failures follow [`AppContext::update_window`]; panics
    /// from `update` propagate.
    pub fn update<C, R>(
        self,
        cx: &mut C,
        update: impl FnOnce(AnyView, &mut Window, &mut App) -> R,
    ) -> Result<R>
    where
        C: AppContext,
    {
        cx.update_window(self, update)
    }

    /// Reads a root of type `T` through an app-context callback.
    ///
    /// Both the handle's declared type and the live root must match `T`.
    /// Returns an error on either mismatch or when the window is closed.
    /// The callback receives a strong entity handle; retaining it keeps the
    /// root entity alive independently of the window.
    ///
    /// # Panics
    ///
    /// With an app-backed context, panics if this window is already being
    /// updated. Async app borrowing follows [`AppContext::read_window`].
    /// Panics from `read` propagate.
    pub fn read<T, C, R>(self, cx: &C, read: impl FnOnce(Entity<T>, &App) -> R) -> Result<R>
    where
        C: AppContext,
        T: 'static,
    {
        let view = self
            .downcast::<T>()
            .context("the type of the window's root view has changed")?;

        cx.read_window(&view, read)
    }
}

impl HasWindowHandle for Window {
    fn window_handle(&self) -> Result<raw_window_handle::WindowHandle<'_>, HandleError> {
        self.platform_window.window_handle()
    }
}

impl HasDisplayHandle for Window {
    fn display_handle(
        &self,
    ) -> std::result::Result<raw_window_handle::DisplayHandle<'_>, HandleError> {
        self.platform_window.display_handle()
    }
}

/// An identity component for a rendered element.
///
/// GPUI combines the element's nested IDs into a [`GlobalElementId`](crate::GlobalElementId) for
/// retained element state and related per-element bookkeeping. Reuse the same ID for the same
/// logical element across frames; use distinct IDs for repeated siblings. `CodeLocation` is
/// convenient for a fixed call site, while list items generally need an item-specific key.
///
/// # Choose a key from the data
///
/// An integer tuple distinguishes repeated children without allocating a
/// formatted name. A nested label can reuse its local name in every row:
///
/// ```
/// use gpui::{div, prelude::*};
///
/// let item_key = 41_usize;
/// let row = div().id(("row", item_key)).child(div().id("label"));
/// ```
///
/// The row's ID scopes `"label"`, so it does not collide with the label in
/// another row. Use a domain key rather than a row index when items can be
/// reordered. `NamedChild` offers a different arrangement: it encodes a parent
/// ID and child name inside one local value, useful when the corresponding
/// elements are siblings instead of nested elements.
///
/// IDs compare by variant and contents. Their [`Display`] strings are for
/// diagnostics and are not unique serialized keys: `("row", 41_usize)` and
/// the name `"row-41"` print alike but remain different IDs. Conversion to
/// [`SharedString`] succeeds only for the `Name` variant. See
/// [retained element identity](crate::_ownership_and_data_flow#give-retained-element-state-an-identity)
/// for the state lifetime these keys control.
#[derive(Clone, Debug, Eq, PartialEq, Hash)]
pub enum ElementId {
    /// The identity of a view entity used as an element ID.
    View(EntityId),
    /// An integer ID, useful for indexed or generated elements.
    Integer(u64),
    /// A string ID, useful for named elements.
    Name(SharedString),
    /// A UUID.
    Uuid(Uuid),
    /// The identity of a focus handle, without retaining that handle.
    ///
    /// Using this ID does not install keyboard focus; attach the handle with
    /// [`InteractiveElement::track_focus`](crate::InteractiveElement::track_focus).
    FocusHandle(FocusId),
    /// A name and integer combined into one ID, useful for repeated named children.
    NamedInteger(SharedString, u64),
    /// A filesystem path compared as a path value, without canonicalization.
    Path(Arc<std::path::Path>),
    /// A source location, suitable for one fixed element at a call site.
    ///
    /// Repeating that call site in a loop repeats this ID; include an item
    /// key or an identified parent to distinguish each instance.
    CodeLocation(core::panic::Location<'static>),
    /// A labeled child ID, preserving its parent identity and adding a child name.
    NamedChild(Arc<ElementId>, SharedString),
    /// A byte array ID (used for text-anchors)
    OpaqueId([u8; 20]),
}

impl ElementId {
    /// Constructs an `ElementId::NamedInteger` from a name and `usize`.
    pub fn named_usize(name: impl Into<SharedString>, integer: usize) -> ElementId {
        Self::NamedInteger(name.into(), integer as u64)
    }
}

impl Display for ElementId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ElementId::View(entity_id) => write!(f, "view-{}", entity_id)?,
            ElementId::Integer(ix) => write!(f, "{}", ix)?,
            ElementId::Name(name) => write!(f, "{}", name)?,
            ElementId::FocusHandle(_) => write!(f, "FocusHandle")?,
            ElementId::NamedInteger(s, i) => write!(f, "{}-{}", s, i)?,
            ElementId::Uuid(uuid) => write!(f, "{}", uuid)?,
            ElementId::Path(path) => write!(f, "{}", path.display())?,
            ElementId::CodeLocation(location) => write!(f, "{}", location)?,
            ElementId::NamedChild(id, name) => write!(f, "{}-{}", id, name)?,
            ElementId::OpaqueId(opaque_id) => write!(f, "{:x?}", opaque_id)?,
        }

        Ok(())
    }
}

impl TryInto<SharedString> for ElementId {
    type Error = anyhow::Error;

    fn try_into(self) -> anyhow::Result<SharedString> {
        if let ElementId::Name(name) = self {
            Ok(name)
        } else {
            anyhow::bail!("element id is not string")
        }
    }
}

impl From<usize> for ElementId {
    fn from(id: usize) -> Self {
        ElementId::Integer(id as u64)
    }
}

impl From<i32> for ElementId {
    fn from(id: i32) -> Self {
        Self::Integer(id as u64)
    }
}

impl From<SharedString> for ElementId {
    fn from(name: SharedString) -> Self {
        ElementId::Name(name)
    }
}

impl From<String> for ElementId {
    fn from(name: String) -> Self {
        ElementId::Name(name.into())
    }
}

impl From<Arc<str>> for ElementId {
    fn from(name: Arc<str>) -> Self {
        ElementId::Name(name.into())
    }
}

impl From<Arc<std::path::Path>> for ElementId {
    fn from(path: Arc<std::path::Path>) -> Self {
        ElementId::Path(path)
    }
}

impl From<&'static str> for ElementId {
    fn from(name: &'static str) -> Self {
        ElementId::Name(SharedString::new_static(name))
    }
}

impl<'a> From<&'a FocusHandle> for ElementId {
    fn from(handle: &'a FocusHandle) -> Self {
        ElementId::FocusHandle(handle.id)
    }
}

impl From<(&'static str, EntityId)> for ElementId {
    fn from((name, id): (&'static str, EntityId)) -> Self {
        ElementId::NamedInteger(SharedString::new_static(name), id.as_u64())
    }
}

impl From<(&'static str, usize)> for ElementId {
    fn from((name, id): (&'static str, usize)) -> Self {
        ElementId::NamedInteger(SharedString::new_static(name), id as u64)
    }
}

impl From<(SharedString, usize)> for ElementId {
    fn from((name, id): (SharedString, usize)) -> Self {
        ElementId::NamedInteger(name, id as u64)
    }
}

impl From<(&'static str, u64)> for ElementId {
    fn from((name, id): (&'static str, u64)) -> Self {
        ElementId::NamedInteger(SharedString::new_static(name), id)
    }
}

impl From<Uuid> for ElementId {
    fn from(value: Uuid) -> Self {
        Self::Uuid(value)
    }
}

impl From<(&'static str, u32)> for ElementId {
    fn from((name, id): (&'static str, u32)) -> Self {
        ElementId::NamedInteger(SharedString::new_static(name), u64::from(id))
    }
}

impl<T: Into<SharedString>> From<(ElementId, T)> for ElementId {
    fn from((id, name): (ElementId, T)) -> Self {
        ElementId::NamedChild(Arc::new(id), name.into())
    }
}

impl From<&'static core::panic::Location<'static>> for ElementId {
    fn from(location: &'static core::panic::Location<'static>) -> Self {
        ElementId::CodeLocation(*location)
    }
}

impl From<[u8; 20]> for ElementId {
    fn from(opaque_id: [u8; 20]) -> Self {
        ElementId::OpaqueId(opaque_id)
    }
}

/// A filled and bordered rectangle submitted to [`Window::paint_quad`].
///
/// Coordinates, radii, and border widths are in logical pixels. Construct one
/// with [`fill`], [`outline`], or [`quad`], then adjust its fields or use the
/// builder methods. Constructing the value does not paint it.
///
/// A fill starts with zero border widths. Set both width and color to add a
/// visible border; setting its color alone leaves it borderless:
///
/// ```
/// use gpui::{Bounds, fill, point, px, rgb, size};
///
/// let bounds = Bounds::new(point(px(20.), px(12.)), size(px(120.), px(48.)));
/// let panel = fill(bounds, rgb(0xf7f6f2))
///     .border_widths(px(2.))
///     .border_color(rgb(0x155b50))
///     .corner_radii(px(6.));
/// // Submit `panel` with window.paint_quad(panel) during paint.
/// ```
///
/// The bounds are the outer box. Borders occupy its inside edge without
/// changing layout. The active content mask and element opacity are applied
/// when the window records it. The
/// [custom-element walkthrough](https://gpui-ce.github.io/examples/custom-element/#draw)
/// prepares a quad in prepaint and records it in paint.
#[derive(Clone)]
pub struct PaintQuad {
    /// Outer rectangle in logical, window-local pixels.
    pub bounds: Bounds<Pixels>,
    /// Radius at each corner, in logical pixels.
    ///
    /// These are not clamped when painted. Use
    /// [`Corners::clamp_radii_for_quad_size`] when they should fit the box.
    pub corner_radii: Corners<Pixels>,
    /// Color or gradient filling the rectangle, including beneath its border.
    pub background: Background,
    /// Width of each inside border edge, in logical pixels; zero hides that edge.
    pub border_widths: Edges<Pixels>,
    /// Color or gradient painted over the fill along edges with nonzero width.
    pub border_color: Background,
    /// Whether nonzero border edges are solid or dashed.
    pub border_style: BorderStyle,
    /// Dash length as a multiple of border width, used for [`BorderStyle::Dashed`].
    ///
    /// Constructors use `2.0`; a two-pixel border therefore has four-pixel dashes.
    pub border_dashed_length: f32,
    /// Gap length as a multiple of border width, used for [`BorderStyle::Dashed`].
    ///
    /// Constructors use `1.0`; a two-pixel border therefore has two-pixel gaps.
    pub border_dashed_gap: f32,
}

impl PaintQuad {
    /// Sets the corner radii in logical pixels without changing the bounds.
    ///
    /// A single length sets all four corners. Values are stored without
    /// clamping; see [`Window::paint_quad`] for oversized radii.
    pub fn corner_radii(self, corner_radii: impl Into<Corners<Pixels>>) -> Self {
        PaintQuad {
            corner_radii: corner_radii.into(),
            ..self
        }
    }

    /// Sets the inside border widths in logical pixels.
    ///
    /// A single length sets all four edges. This leaves the outer bounds and
    /// border color unchanged; adding widths to a [`fill`] also needs a
    /// visible [`border_color`](Self::border_color).
    pub fn border_widths(self, border_widths: impl Into<Edges<Pixels>>) -> Self {
        PaintQuad {
            border_widths: border_widths.into(),
            ..self
        }
    }

    /// Sets the border's color or gradient, leaving its widths unchanged.
    ///
    /// Edges with zero width remain invisible. The rectangle's fill remains
    /// underneath translucent borders.
    pub fn border_color(self, border_color: impl Into<Background>) -> Self {
        PaintQuad {
            border_color: border_color.into(),
            ..self
        }
    }

    /// Sets the fill inside the rectangle, including color or gradient backgrounds.
    pub fn background(self, background: impl Into<Background>) -> Self {
        PaintQuad {
            background: background.into(),
            ..self
        }
    }

    /// Sets the length of each border dash as a multiple of the border width.
    ///
    /// Used only with [`BorderStyle::Dashed`]. Negative values and NaN become
    /// zero. Setting the spacing does not change [`Self::border_style`].
    pub fn border_dashed_length(self, length_per_border_width: f32) -> Self {
        PaintQuad {
            border_dashed_length: length_per_border_width.max(0.0),
            ..self
        }
    }

    /// Sets the gap between border dashes as a multiple of the border width.
    ///
    /// Used only with [`BorderStyle::Dashed`]. Negative values and NaN become
    /// zero. Setting the spacing does not change [`Self::border_style`].
    pub fn border_dashed_gap(self, gap_per_border_width: f32) -> Self {
        PaintQuad {
            border_dashed_gap: gap_per_border_width.max(0.0),
            ..self
        }
    }
}

/// Describes a filled and bordered rectangle without painting it.
///
/// Submit the returned value with [`Window::paint_quad`] during paint. Use
/// [`fill`] for a borderless rectangle or [`outline`] for an unfilled border.
pub fn quad(
    bounds: Bounds<Pixels>,
    corner_radii: impl Into<Corners<Pixels>>,
    background: impl Into<Background>,
    border_widths: impl Into<Edges<Pixels>>,
    border_color: impl Into<Background>,
    border_style: BorderStyle,
) -> PaintQuad {
    PaintQuad {
        bounds,
        corner_radii: corner_radii.into(),
        background: background.into(),
        border_widths: border_widths.into(),
        border_color: border_color.into(),
        border_style,
        border_dashed_length: crate::scene::DEFAULT_BORDER_DASHED_LENGTH,
        border_dashed_gap: crate::scene::DEFAULT_BORDER_DASHED_GAP,
    }
}

/// Describes a square-cornered, borderless rectangle with a color or gradient fill.
///
/// Submit it with [`Window::paint_quad`] during paint.
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-fill.md")]
// docs:examples:end
pub fn fill(bounds: impl Into<Bounds<Pixels>>, background: impl Into<Background>) -> PaintQuad {
    PaintQuad {
        bounds: bounds.into(),
        corner_radii: (0.).into(),
        background: background.into(),
        border_widths: (0.).into(),
        border_color: transparent_black().into(),
        border_style: BorderStyle::default(),
        border_dashed_length: crate::scene::DEFAULT_BORDER_DASHED_LENGTH,
        border_dashed_gap: crate::scene::DEFAULT_BORDER_DASHED_GAP,
    }
}

/// Describes a square-cornered rectangle with a one-logical-pixel border and transparent fill.
///
/// Submit it with [`Window::paint_quad`] during paint. `border_style` selects
/// solid or dashed borders; use the returned value's builders to change widths
/// or dash spacing.
pub fn outline(
    bounds: impl Into<Bounds<Pixels>>,
    border_color: impl Into<Background>,
    border_style: BorderStyle,
) -> PaintQuad {
    PaintQuad {
        bounds: bounds.into(),
        corner_radii: (0.).into(),
        background: transparent_black().into(),
        border_widths: (1.).into(),
        border_color: border_color.into(),
        border_style,
        border_dashed_length: crate::scene::DEFAULT_BORDER_DASHED_LENGTH,
        border_dashed_gap: crate::scene::DEFAULT_BORDER_DASHED_GAP,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        DragMoveEvent, Empty, ExternalDragPayload, ExternalPaths, FileDragPaths, FocusHandle, Font,
        FontMetrics, ImageSource, InlineLayout, InlineLayoutRequest, InputEvent,
        InteractiveElement, LineLayout, LongPressEvent, MouseDownEvent, ParentElement,
        PlatformTextSystem, PreparedRasterStyle, RasterColorEffect, RasterStyleRequest,
        RasterizedGlyph, RequestFrameOptions, ShaderBool, StatefulInteractiveElement, Styled,
        TestApp, TestAppContext, TestTextSystem, TextLayoutRequest, TouchDragEvent, TouchId,
        TouchPhase, canvas, div, hsla, img, linear_color_stop, linear_gradient,
    };
    use image::{Frame as ImageFrame, ImageBuffer, Rgba};
    use proptest::prelude::*;
    use smallvec::smallvec;
    use std::{path::PathBuf, sync::Mutex as StdMutex};

    #[test]
    fn hit_test_preserves_inline_regions_occlusion_and_metadata() {
        let bounds = Bounds::new(Point::default(), size(px(100.), px(80.)));
        let background = Hitbox {
            id: HitboxId(1),
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            behavior: HitboxBehavior::Normal,
            tags: vec!["background".into()],
            fragments: None,
        };
        let mut inline = Hitbox {
            id: HitboxId(2),
            bounds,
            content_mask: ContentMask {
                bounds: Bounds::new(Point::default(), size(px(80.), px(80.))),
                ..Default::default()
            },
            behavior: HitboxBehavior::Normal,
            tags: vec!["inline".into()],
            fragments: Some(Arc::from([
                Bounds::new(point(px(60.), px(0.)), size(px(40.), px(40.))),
                Bounds::new(point(px(0.), px(40.)), size(px(40.), px(40.))),
            ])),
        };

        for behavior in [
            HitboxBehavior::Normal,
            HitboxBehavior::BlockMouseExceptScroll,
            HitboxBehavior::BlockMouse,
        ] {
            inline.behavior = behavior;

            for (position, inside_inline, inside_background) in [
                (point(px(70.), px(20.)), true, true),
                (point(px(20.), px(60.)), true, true),
                (point(px(20.), px(20.)), false, true),
                (point(px(90.), px(20.)), false, true),
                (point(px(120.), px(20.)), false, false),
            ] {
                let hit_test = HitTest::new([&inline, &background].into_iter(), position);
                let mut hovered = Vec::new();
                let mut scrollable = Vec::new();

                if inside_inline {
                    hovered.push(inline.id);
                    scrollable.push(inline.id);
                }

                if inside_background && (!inside_inline || behavior == HitboxBehavior::Normal) {
                    hovered.push(background.id);
                }

                if inside_background && (!inside_inline || behavior != HitboxBehavior::BlockMouse) {
                    scrollable.push(background.id);
                }

                assert_eq!(
                    hit_test.iter_hovered().copied().collect::<Vec<_>>(),
                    hovered
                );
                assert_eq!(
                    hit_test.iter_scrollable().copied().collect::<Vec<_>>(),
                    scrollable
                );

                for (depth, hitbox) in [&inline, &background].into_iter().enumerate() {
                    let entry = hit_test.entry(&hitbox.id).unwrap();
                    assert_eq!(entry.depth(), depth);
                    assert_eq!(entry.tags(), &hitbox.tags);
                }
            }
        }
    }

    proptest! {
        #[test]
        fn glyph_origin_quantization_preserves_position_with_bounded_error(
            x in -10_000.0f32..10_000.0,
            y in -10_000.0f32..10_000.0,
        ) {
            let (integer, variant) =
                quantize_glyph_origin(point(ScaledPixels(x), ScaledPixels(y)));
            let reconstructed_x =
                integer.x.0 + f32::from(variant.x) / f32::from(SUBPIXEL_VARIANTS_X);
            let reconstructed_y =
                integer.y.0 + f32::from(variant.y) / f32::from(SUBPIXEL_VARIANTS_Y);
            let maximum_error_x = 0.5 / f32::from(SUBPIXEL_VARIANTS_X) + 0.001;
            let maximum_error_y = 0.5 / f32::from(SUBPIXEL_VARIANTS_Y) + 0.001;

            prop_assert!(variant.x < SUBPIXEL_VARIANTS_X);
            prop_assert!(variant.y < SUBPIXEL_VARIANTS_Y);
            prop_assert_eq!(variant.y, 0, "vertical glyph variants change baseline snapping");
            prop_assert!((reconstructed_x - x).abs() <= maximum_error_x);
            prop_assert!((reconstructed_y - y).abs() <= maximum_error_y);

            let (color_origin, color_variant) =
                quantize_color_glyph_origin(point(ScaledPixels(x), ScaledPixels(y)));
            prop_assert_eq!(color_variant, Point::default());
            prop_assert!((color_origin.x.0 - x).abs() <= 0.501);
            prop_assert!((color_origin.y.0 - y).abs() <= 0.501);
        }
    }

    #[derive(Default)]
    struct RasterFormatTextSystem {
        rasterized: StdMutex<Vec<RenderGlyphParams>>,
        fail_next: AtomicBool,
    }

    impl PlatformTextSystem for RasterFormatTextSystem {
        fn add_fonts(&self, _fonts: Vec<Cow<'static, [u8]>>) -> anyhow::Result<()> {
            Ok(())
        }

        fn all_font_names(&self) -> Vec<String> {
            Vec::new()
        }

        fn font_id(&self, descriptor: &Font) -> anyhow::Result<FontId> {
            PlatformTextSystem::font_id(&TestTextSystem, descriptor)
        }

        fn font_metrics(&self, font_id: FontId) -> FontMetrics {
            PlatformTextSystem::font_metrics(&TestTextSystem, font_id)
        }

        fn typographic_bounds(
            &self,
            font_id: FontId,
            glyph_id: GlyphId,
        ) -> anyhow::Result<Bounds<f32>> {
            PlatformTextSystem::typographic_bounds(&TestTextSystem, font_id, glyph_id)
        }

        fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> anyhow::Result<Size<f32>> {
            PlatformTextSystem::advance(&TestTextSystem, font_id, glyph_id)
        }

        fn glyph_for_char(&self, font_id: FontId, character: char) -> Option<GlyphId> {
            PlatformTextSystem::glyph_for_char(&TestTextSystem, font_id, character)
        }

        fn rasterize_glyph(&self, params: &RenderGlyphParams) -> anyhow::Result<RasterizedGlyph> {
            self.rasterized.lock().unwrap().push(params.clone());
            if self.fail_next.swap(false, SeqCst) {
                anyhow::bail!("injected glyph rasterization failure");
            }

            let (format, pixels) = match params.glyph_id.0 {
                1 => (RasterizedGlyphFormat::AlphaMask, vec![0, 255]),
                2 => (
                    RasterizedGlyphFormat::BgraSubpixelMask,
                    vec![1, 2, 3, 0, 4, 5, 6, 0],
                ),
                3 | 5 => (
                    RasterizedGlyphFormat::BgraColor,
                    vec![10, 20, 30, 128, 40, 50, 60, 255],
                ),
                node_id => anyhow::bail!("unexpected scripted glyph {node_id}"),
            };
            let size = size(DevicePixels(2), DevicePixels(1));
            Ok(RasterizedGlyph {
                bounds: Bounds {
                    origin: point(DevicePixels(-1), DevicePixels(-2)),
                    size,
                },
                size,
                format,
                pixels,
            })
        }

        fn prepare_raster_style(&self, mut request: RasterStyleRequest) -> PreparedRasterStyle {
            if request.requested_mode == GlyphRenderMode::Color {
                request.foreground_dependency = match request.glyph_id {
                    GlyphId(3) => crate::ForegroundDependency::AlphaOnly,
                    _glyph_id => request.foreground_dependency,
                };

                PreparedRasterStyle::preblend(request)
            } else {
                PreparedRasterStyle::independent(request.requested_mode)
            }
        }

        fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout {
            PlatformTextSystem::layout_text(&TestTextSystem, request)
        }

        fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout {
            PlatformTextSystem::layout_inline(&TestTextSystem, request)
        }
    }

    struct RasterFormatView;

    impl Render for RasterFormatView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            let color = hsla(0.6, 0.7, 0.4, 0.8);
            let alternate_color = hsla(0.1, 0.6, 0.3, 0.8);
            div().size_full().opacity(0.5).child(
                canvas(
                    |_, _, _| (),
                    move |_, _, window, _| {
                        for (index, glyph_id) in [GlyphId(1), GlyphId(2)].into_iter().enumerate() {
                            let offset = px(index as f32 * 5.0);
                            let mut origin = point(px(5.0) + offset, px(10.0) + offset);

                            if index == 0 {
                                origin += point(px(0.13), px(0.245));
                            }

                            window
                                .paint_glyph(origin, FontId(7), glyph_id, px(16.0), color)
                                .unwrap();
                        }

                        let mut index = 0;

                        for glyph_id in [GlyphId(3), GlyphId(5)] {
                            for foreground in [color, alternate_color] {
                                let offset = px(index as f32 * 5.0);
                                let origin = point(px(15.0) + offset, px(20.0) + offset);

                                window
                                    .paint_emoji_with_color(
                                        origin,
                                        FontId(7),
                                        glyph_id,
                                        px(16.0),
                                        foreground,
                                    )
                                    .unwrap();
                                index += 1;
                            }
                        }
                    },
                )
                .size_full(),
            )
        }
    }

    #[test]
    fn returned_raster_format_drives_atlas_and_scene_behavior() {
        let text_system = Arc::new(RasterFormatTextSystem::default());
        let mut app = TestApp::with_text_system(text_system.clone());
        let mut test_window = app.open_window(|_, _| RasterFormatView);
        test_window.draw();

        test_window.update(|_, window, _| {
            assert_eq!(window.rendered_primitive_counts(), (0, 1, 1, 4));
            let scene = &window.rendered_frame.scene;
            let expected_color = hsla(0.6, 0.7, 0.4, 0.8).opacity(0.5).into();

            assert_eq!(scene.monochrome_sprites[0].color, expected_color);
            assert_eq!(scene.subpixel_sprites[0].color, expected_color);
            assert!(
                scene
                    .polychrome_sprites
                    .iter()
                    .all(|sprite| sprite.opacity == 0.5)
            );
            assert_eq!(
                scene.monochrome_sprites[0].bounds.origin,
                point(ScaledPixels(9.0), ScaledPixels(18.0))
            );
            assert_eq!(
                scene.monochrome_sprites[0].tile.texture_id.kind,
                crate::AtlasTextureKind::Monochrome
            );
            assert_eq!(
                scene.subpixel_sprites[0].tile.texture_id.kind,
                crate::AtlasTextureKind::Subpixel
            );
            assert_eq!(
                scene.polychrome_sprites[0].tile.texture_id.kind,
                crate::AtlasTextureKind::Polychrome
            );
            let first_tile = scene.polychrome_sprites[0].tile;
            let second_tile = scene.polychrome_sprites[1].tile;
            let third_tile = scene.polychrome_sprites[2].tile;
            let fourth_tile = scene.polychrome_sprites[3].tile;
            assert_eq!(first_tile, second_tile);
            assert_ne!(third_tile, fourth_tile);
        });

        let rasterized = text_system.rasterized.lock().unwrap();
        let color_styles = rasterized
            .iter()
            .filter(|params| params.raster_style.mode == GlyphRenderMode::Color)
            .map(|params| params.raster_style.color_effect)
            .collect::<Vec<_>>();
        assert_eq!(
            color_styles,
            [
                RasterColorEffect::Preblend(crate::Rgba8::new(0, 0, 0, 204)),
                RasterColorEffect::Preblend(crate::Rgba8::new(31, 88, 173, 204)),
                RasterColorEffect::Preblend(crate::Rgba8::new(122, 86, 31, 204)),
            ]
        );
    }

    struct FragmentFailureView;

    impl Render for FragmentFailureView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            div().size_full().child("x😀")
        }
    }

    #[test]
    fn a_failed_glyph_does_not_hide_the_rest_of_its_fragment() {
        let text_system = Arc::new(RasterFormatTextSystem {
            rasterized: StdMutex::default(),
            fail_next: AtomicBool::new(true),
        });
        let mut app = TestApp::with_text_system(text_system.clone());
        let mut test_window = app.open_window(|_, _| FragmentFailureView);
        test_window.draw();

        test_window.update(|_, window, _| {
            assert!(!window.rendered_frame.scene.subpixel_sprites.is_empty());
        });

        let glyph_ids = text_system
            .rasterized
            .lock()
            .unwrap()
            .iter()
            .map(|params| params.glyph_id)
            .collect::<Vec<_>>();
        assert!(
            glyph_ids.starts_with(&[GlyphId(1), GlyphId(2)]),
            "unexpected rasterization sequence: {glyph_ids:?}"
        );
    }

    struct EmptyView;

    impl Render for EmptyView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            div()
        }
    }

    fn shadow_gradient() -> Background {
        linear_gradient(
            90.,
            linear_color_stop(hsla(0., 1., 0.5, 0.8), 0.),
            linear_color_stop(hsla(2. / 3., 1., 0.5, 0.6), 1.),
        )
    }

    struct ShadowBackgroundView;

    impl Render for ShadowBackgroundView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            div()
                .m(px(40.))
                .w(px(80.))
                .h(px(60.))
                .rounded(px(8.))
                .bg(white())
                .opacity(0.5)
                .shadow(vec![
                    BoxShadow::new(px(4.), px(2.), shadow_gradient())
                        .blur_radius(px(6.))
                        .spread_radius(px(2.)),
                    BoxShadow::new(px(-3.), px(1.), hsla(0.3, 0.7, 0.4, 0.4)),
                    BoxShadow::new(px(0.), px(2.), shadow_gradient())
                        .blur_radius(px(4.))
                        .spread_radius(px(3.))
                        .inset(),
                ])
        }
    }

    struct CornerSmoothingSceneView {
        image: Arc<RenderImage>,
    }

    fn assert_smoothing(name: &str, minimum_count: usize, values: impl IntoIterator<Item = f32>) {
        let values = values.into_iter().collect::<Vec<_>>();
        assert!(values.len() >= minimum_count, "missing {name}");
        assert!(
            values.iter().all(|&value| value == 1.0),
            "{name}: {values:?}"
        );
    }

    impl Render for CornerSmoothingSceneView {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            let mut image = img(ImageSource::Render(self.image.clone()))
                .size(px(24.))
                .rounded(px(8.));
            image.style().corner_smoothing = Some(1.5);

            let mut root = div()
                .size(px(80.))
                .rounded(px(24.))
                .bg(crate::blue())
                .border_t(px(2.))
                .border_r(px(4.))
                .border_b(px(6.))
                .border_l(px(8.))
                .border_color(crate::white())
                .shadow(vec![
                    BoxShadow::new(px(2.), px(3.), crate::black().opacity(0.5))
                        .blur_radius(px(5.))
                        .spread_radius(px(1.)),
                    BoxShadow::new(px(1.), px(1.), crate::white().opacity(0.4))
                        .blur_radius(px(3.))
                        .inset(),
                ])
                .backdrop_blur(px(4.))
                .blur(px(2.))
                .child(image);
            root.style().corner_smoothing = Some(1.5);
            root
        }
    }

    #[gpui::test]
    fn shadow_backgrounds_survive_painting_with_geometry_and_opacity(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| ShadowBackgroundView);
        let shadows = window
            .update(cx, |_, window, _| {
                window.rendered_frame.scene.shadows.clone()
            })
            .unwrap();

        assert_eq!(shadows.len(), 3);
        let gradient = shadow_gradient().opacity(0.5);
        let drop_gradient = shadows
            .iter()
            .find(|shadow| shadow.inset == ShaderBool::Disabled && shadow.color == gradient)
            .expect("gradient drop shadow should be painted");
        let inset_gradient = shadows
            .iter()
            .find(|shadow| shadow.inset == ShaderBool::Enabled && shadow.color == gradient)
            .expect("gradient inset shadow should be painted");
        let solid = shadows
            .iter()
            .find(|shadow| shadow.color.as_solid().is_some())
            .expect("solid shadows should remain supported");

        assert_eq!(
            solid.color.as_solid(),
            Some(hsla(0.3, 0.7, 0.4, 0.2)),
            "element opacity should apply to solid shadow paint"
        );
        assert_eq!(drop_gradient.element_bounds, inset_gradient.element_bounds);
        assert!(drop_gradient.bounds.size.width > drop_gradient.element_bounds.size.width);
        assert!(drop_gradient.bounds.size.height > drop_gradient.element_bounds.size.height);
        assert!(inset_gradient.bounds.size.width < inset_gradient.element_bounds.size.width);
        assert!(inset_gradient.bounds.size.height < inset_gradient.element_bounds.size.height);
        assert!(drop_gradient.order < inset_gradient.order);
    }

    #[gpui::test]
    fn corner_smoothing_reaches_every_styled_scene_primitive(cx: &mut TestAppContext) {
        let frame = ImageFrame::new(ImageBuffer::from_pixel(2, 2, Rgba([255, 255, 255, 255])));
        let image = Arc::new(RenderImage::new(smallvec![frame]));
        let window = cx.add_window(move |_, _| CornerSmoothingSceneView { image });

        window
            .update(cx, |_, window, _| {
                let scene = &window.rendered_frame.scene;
                assert_smoothing(
                    "quads",
                    2,
                    scene.quads.iter().map(|quad| quad.corner_smoothing),
                );
                assert_smoothing(
                    "shadows",
                    2,
                    scene.shadows.iter().map(|shadow| shadow.corner_smoothing),
                );
                assert_smoothing(
                    "backdrop filters",
                    1,
                    scene
                        .backdrop_filters
                        .iter()
                        .map(|filter| filter.corner_smoothing),
                );
                assert_smoothing(
                    "filter boundaries",
                    2,
                    scene
                        .filter_boundaries
                        .iter()
                        .map(|boundary| boundary.corner_smoothing),
                );
                assert_smoothing(
                    "images",
                    1,
                    scene
                        .polychrome_sprites
                        .iter()
                        .map(|image| image.corner_smoothing),
                );
                for inset in [ShaderBool::Disabled, ShaderBool::Enabled] {
                    assert!(scene.shadows.iter().any(|shadow| shadow.inset == inset));
                }

                let border = scene
                    .quads
                    .iter()
                    .find(|quad| quad.border_widths.top.0 > 0.0)
                    .expect("border quad");
                let scale = window.scale_factor();
                assert_eq!(
                    [
                        border.border_widths.top.0,
                        border.border_widths.right.0,
                        border.border_widths.bottom.0,
                        border.border_widths.left.0,
                    ],
                    [2.0, 4.0, 6.0, 8.0].map(|width| width * scale)
                );
            })
            .unwrap();
    }

    struct OpensWindowOnPaint {
        opened: Rc<Cell<bool>>,
    }

    impl Render for OpensWindowOnPaint {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            let opened = self.opened.clone();
            div()
                .size_full()
                .child(canvas(
                    |_, _, _| {},
                    move |_, _, _window, cx| {
                        if !opened.replace(true) {
                            cx.open_window(WindowOptions::default(), |_, cx| cx.new(|_| EmptyView))
                                .unwrap();
                        }
                    },
                ))
                // Siblings painted after the canvas: their elements were
                // allocated in the arena before the nested draw, so they detect
                // a mid-draw arena clear when painted afterwards.
                .child(div().child("after"))
        }
    }

    /// Opening a window synchronously draws it and requests an element arena
    /// clear. When that happens from within another window's draw (here: from
    /// an element's paint), the clear must be deferred until the outer draw
    /// finishes, or the outer draw's arena-allocated elements would be freed
    /// out from under it.
    #[test]
    fn test_window_opened_during_draw_defers_arena_clear() {
        let mut cx = TestAppContext::single();

        let opened = Rc::new(Cell::new(false));
        // add_window draws once, which runs the nested open_window mid-draw.
        let window = cx.add_window({
            let opened = opened.clone();
            move |_, _| OpensWindowOnPaint { opened }
        });

        assert!(opened.get());
        assert_eq!(cx.windows().len(), 2);

        // The deferred clear must actually run once the outer draw unwinds:
        // subsequent draws of both windows work against a fresh arena.
        cx.update_window(window.into(), |_, window, cx| window.draw(cx).clear(cx))
            .unwrap();
    }

    /// Platforms that stop requesting frames for idle windows (currently web)
    /// rely on the frame waker firing whenever frame demand arises; a demand
    /// source that skips the waker shows up there as a window that silently
    /// stops repainting until unrelated activity wakes it.
    #[gpui::test]
    fn test_frame_waker_fires_on_frame_demand(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| EmptyView);
        let test_window = cx.test_window(window.into());

        // Windows start dirty, and that can predate waker installation;
        // installing the waker must deliver the pending wake or the first
        // frame would never be requested.
        assert!(
            test_window.frame_wake_count() >= 1,
            "opening a window must wake the frame source for the initial frame"
        );

        // Serve outstanding demand (present the frame drawn by `add_window`).
        test_window.simulate_frame_request(RequestFrameOptions::default());

        // An idle window must not wake on clean frames or plain updates, or
        // the frame source could never stop.
        let baseline = test_window.frame_wake_count();
        test_window.simulate_frame_request(RequestFrameOptions::default());
        window.update(cx, |_, _, _| {}).unwrap();
        assert_eq!(
            test_window.frame_wake_count(),
            baseline,
            "clean frames and non-notifying updates must not wake the frame source"
        );

        // Notifying a view in an idle window is the core demand signal.
        window.update(cx, |_, _, cx| cx.notify()).unwrap();
        assert!(
            test_window.frame_wake_count() > baseline,
            "notifying a view in an idle window must wake the frame source"
        );

        // Serving that demand returns to idle without further wakes.
        test_window.simulate_frame_request(RequestFrameOptions::default());
        let baseline = test_window.frame_wake_count();
        test_window.simulate_frame_request(RequestFrameOptions::default());
        assert_eq!(
            test_window.frame_wake_count(),
            baseline,
            "serving demand must return the window to idle"
        );

        // Next-frame callbacks create demand without dirtying the window.
        window
            .update(cx, |_, window, _| window.on_next_frame(|_, _| {}))
            .unwrap();
        assert!(
            test_window.frame_wake_count() > baseline,
            "scheduling a next-frame callback in an idle window must wake the frame source"
        );
    }

    /// A frame request that arrives while next-frame callbacks are pending
    /// must never strand them: either the frame runs them, or (when the
    /// inactive-window frame-rate throttle defers the frame) the waker fires
    /// so another request is delivered.
    #[gpui::test]
    fn test_pending_next_frame_callbacks_are_not_stranded(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| EmptyView);
        let test_window = cx.test_window(window.into());
        // Establish a recent last-frame time so the inactive-window throttle
        // can engage on the next request.
        test_window.simulate_frame_request(RequestFrameOptions::default());

        let callback_ran = Rc::new(Cell::new(false));
        window
            .update(cx, {
                let callback_ran = callback_ran.clone();
                move |_, window, _| {
                    window.on_next_frame(move |_, _| callback_ran.set(true));
                }
            })
            .unwrap();

        let baseline = test_window.frame_wake_count();
        test_window.simulate_frame_request(RequestFrameOptions::default());
        // The test window is inactive, so this request throttles to ~30fps
        // when it lands within the throttle interval of the previous frame
        // (the common case here, but timing-dependent): the callback is
        // deferred and the waker must re-arm the frame source. On a slow run
        // the request instead lands outside the interval and runs the
        // callback directly.
        assert!(
            test_window.frame_wake_count() > baseline || callback_ran.get(),
            "a frame request with pending next-frame callbacks must either run them or re-arm the frame source"
        );
    }

    #[gpui::test]
    fn test_window_reports_no_raw_handle_instead_of_panicking(cx: &mut TestAppContext) {
        use raw_window_handle::{HandleError, HasDisplayHandle as _, HasWindowHandle as _};

        let window = cx.add_window(|_, _| EmptyView);
        window
            .update(cx, |_, window, _| {
                assert!(matches!(
                    window.window_handle(),
                    Err(HandleError::NotSupported)
                ));
                assert!(matches!(
                    window.display_handle(),
                    Err(HandleError::NotSupported)
                ));
            })
            .unwrap();
    }

    #[gpui::test]
    fn test_window_visibility_can_be_changed(cx: &mut TestAppContext) {
        for show in [false, true] {
            let window = cx.update(|cx| {
                cx.open_window(WindowOptions::new().show(show), |_, cx| {
                    cx.new(|_| EmptyView)
                })
                .unwrap()
            });
            let platform_window = cx.test_window(window.into());
            assert_eq!(platform_window.is_visible(), show);

            for visible in [false, false, true, true, false, true] {
                window
                    .update(cx, |_, window, _| window.set_visible(visible))
                    .unwrap();
                assert_eq!(platform_window.is_visible(), visible);
            }
        }
    }

    #[gpui::test]
    fn test_appearance_change_runs_after_app_update(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| EmptyView);
        let observed_appearance = Rc::new(Cell::new(None));
        let _subscription = window
            .update(cx, {
                let observed_appearance = observed_appearance.clone();
                move |_, window, _| {
                    window.observe_window_appearance(move |window, _| {
                        observed_appearance.set(Some(window.appearance()));
                    })
                }
            })
            .unwrap();
        let test_window = cx.test_window(window.into());

        cx.update(|_| {
            test_window.simulate_appearance_change(WindowAppearance::Dark);
            assert_eq!(observed_appearance.get(), None);
        });
        cx.run_until_parked();

        assert_eq!(observed_appearance.get(), Some(WindowAppearance::Dark));
    }

    #[gpui::test]
    fn queued_frame_callback_wakes_a_parked_render_loop(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| Empty);
        let test_window = cx.test_window(window.into());

        assert!(test_window.simulate_scheduled_frame());
        assert!(test_window.simulate_scheduled_frame());
        assert!(!test_window.frame_scheduled());

        cx.update_window(window.into(), |_, window, _| {
            window.active.set(true);
            window.on_next_frame(|_, _| {});
        })
        .unwrap();
        assert!(
            test_window.frame_scheduled(),
            "queuing work on a parked window must wake the render loop"
        );

        assert!(test_window.simulate_scheduled_frame());
        assert!(
            test_window.frame_scheduled(),
            "presenting the frame must await one compositor callback"
        );
        assert!(test_window.simulate_scheduled_frame());
        assert!(!test_window.frame_scheduled());
    }

    #[gpui::test]
    fn pending_presentation_wakes_a_parked_render_loop(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| Empty);
        let test_window = cx.test_window(window.into());

        assert!(test_window.simulate_scheduled_frame());
        assert!(test_window.simulate_scheduled_frame());
        assert!(!test_window.frame_scheduled());

        cx.update_window(window.into(), |_, window, cx| window.draw(cx).clear(cx))
            .unwrap();

        assert!(
            test_window.frame_scheduled(),
            "a rendered scene awaiting presentation must wake the render loop"
        );
    }

    #[gpui::test]
    fn callback_queued_during_a_frame_requests_a_follow_up(cx: &mut TestAppContext) {
        let window = cx.add_window(|_, _| Empty);
        let test_window = cx.test_window(window.into());

        let callback_ran = Rc::new(Cell::new(false));
        cx.update_window(window.into(), |_, window, _| {
            // Inactive windows are frame-rate throttled, which would defer the
            // ticks this test drives manually.
            window.active.set(true);
            let callback_ran = callback_ran.clone();
            window.on_next_frame(move |window, _| {
                window.on_next_frame(move |_, _| callback_ran.set(true));
            });
        })
        .unwrap();

        assert!(test_window.simulate_scheduled_frame());
        assert!(!callback_ran.get());
        assert!(
            test_window.frame_scheduled(),
            "a callback queued mid-frame must schedule a follow-up before the loop parks"
        );

        assert!(test_window.simulate_scheduled_frame());
        assert!(callback_ran.get());
    }

    struct RootView {
        explicit_size: bool,
        child_bounds: Rc<Cell<Bounds<Pixels>>>,
    }

    impl Render for RootView {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            let child_bounds = self.child_bounds.clone();
            let root = div().flex().flex_col().child(
                canvas(
                    move |bounds, _, _| child_bounds.set(bounds),
                    |_, _, _, _| {},
                )
                .size_full(),
            );
            if self.explicit_size {
                root.w(px(300.)).h(px(200.))
            } else {
                root
            }
        }
    }

    #[test]
    fn auto_sized_window_root_fills_the_window() {
        let mut cx = TestAppContext::single();
        let child_bounds = Rc::new(Cell::new(Bounds::default()));
        let window = cx.add_window({
            let child_bounds = child_bounds.clone();
            move |_, _| RootView {
                explicit_size: false,
                child_bounds,
            }
        });

        let viewport_size = cx
            .update_window(window.into(), |_, window, cx| {
                window.draw(cx).clear(cx);
                window.viewport_size()
            })
            .unwrap();

        assert_eq!(child_bounds.get().size, viewport_size);
    }

    #[test]
    fn explicitly_sized_window_root_keeps_its_size() {
        let mut cx = TestAppContext::single();
        let child_bounds = Rc::new(Cell::new(Bounds::default()));
        let window = cx.add_window({
            let child_bounds = child_bounds.clone();
            move |_, _| RootView {
                explicit_size: true,
                child_bounds,
            }
        });

        cx.update_window(window.into(), |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();

        assert_eq!(child_bounds.get().size, size(px(300.), px(200.)));
    }

    struct FileDragView {
        path: PathBuf,
        observed_drag_moves: Rc<RefCell<Vec<Point<Pixels>>>>,
        observed_drops: Rc<RefCell<Vec<PathBuf>>>,
    }

    impl Render for FileDragView {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div()
                .id("file-drag")
                .size_full()
                .on_drag(self.path.clone(), |_, _, _, cx| cx.new(|_| Empty))
                .external_drag_payload(|path: &PathBuf, _, _| {
                    Some(ExternalDragPayload::Files(FileDragPaths::new([(
                        path.clone(),
                        true,
                    )])))
                })
                .on_drag_move({
                    let observed_drag_moves = self.observed_drag_moves.clone();
                    move |event: &DragMoveEvent<PathBuf>, _, _| {
                        observed_drag_moves.borrow_mut().push(event.event.position);
                    }
                })
                .on_drop({
                    let observed_drops = self.observed_drops.clone();
                    move |path: &PathBuf, _, _| observed_drops.borrow_mut().push(path.clone())
                })
        }
    }

    #[gpui::test]
    fn file_drag_is_promoted_once_and_restored_in_source_window(cx: &mut TestAppContext) {
        struct Drag {
            window: AnyWindowHandle,
            observed_drag_moves: Rc<RefCell<Vec<Point<Pixels>>>>,
            observed_drops: Rc<RefCell<Vec<PathBuf>>>,
        }

        fn start_drag(cx: &mut TestAppContext, path: PathBuf, platform_result: bool) -> Drag {
            let observed_drag_moves = Rc::new(RefCell::new(Vec::new()));
            let observed_drops = Rc::new(RefCell::new(Vec::new()));
            let window: AnyWindowHandle = cx
                .add_window({
                    let observed_drag_moves = observed_drag_moves.clone();
                    let observed_drops = observed_drops.clone();
                    move |_, _| FileDragView {
                        path,
                        observed_drag_moves,
                        observed_drops,
                    }
                })
                .into();
            cx.test_window(window)
                .set_start_external_drag_result(platform_result);

            let update_result = cx.update_window(window, |_, window, cx| {
                window.draw(cx).clear(cx);
                window.dispatch_event(
                    MouseDownEvent {
                        position: point(px(10.), px(10.)),
                        button: MouseButton::Left,
                        modifiers: Default::default(),
                        click_count: 1,
                        first_mouse: false,
                    }
                    .to_platform_input(),
                    cx,
                );
                window.dispatch_event(
                    MouseMoveEvent {
                        position: point(px(20.), px(20.)),
                        pressed_button: Some(MouseButton::Left),
                        modifiers: Default::default(),
                    }
                    .to_platform_input(),
                    cx,
                );
                assert!(cx.active_drag.is_some());
            });
            assert!(
                update_result.is_ok(),
                "failed to start drag: {update_result:?}"
            );

            assert!(cx.test_window(window).external_drag_files().is_empty());
            Drag {
                window,
                observed_drag_moves,
                observed_drops,
            }
        }

        let successful_path = PathBuf::from("/tmp/successful-drag");
        let successful = start_drag(cx, successful_path.clone(), true);
        let outside_position = point(px(-1.), px(20.));
        let update_result = cx.update_window(successful.window, |_, window, cx| {
            window.dispatch_event(
                MouseMoveEvent {
                    position: outside_position,
                    pressed_button: Some(MouseButton::Left),
                    modifiers: Default::default(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(cx.active_drag.is_none());
        });
        assert!(
            update_result.is_ok(),
            "failed to promote drag: {update_result:?}"
        );
        assert_eq!(
            cx.test_window(successful.window).external_drag_files(),
            [(successful_path.clone(), true)]
        );
        // Views must still see the move that leaves the window, otherwise they never learn to tear
        // down the drag state they built up while the pointer was inside.
        assert_eq!(
            successful.observed_drag_moves.borrow().last(),
            Some(&outside_position)
        );

        let destination: AnyWindowHandle = cx.add_window(|_, _| EmptyView).into();
        let reentry_position = point(px(30.), px(30.));
        let external_paths = || ExternalPaths([successful_path.clone()].into_iter().collect());
        let update_result = cx.update_window(destination, |_, window, cx| {
            window.dispatch_event(
                FileDropEvent::Entered {
                    position: reentry_position,
                    paths: external_paths(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(
                cx.active_drag
                    .as_ref()
                    .is_some_and(|drag| drag.value.downcast_ref::<ExternalPaths>().is_some())
            );
            window.dispatch_event(FileDropEvent::Exited.to_platform_input(), cx);
            assert!(cx.active_drag.is_none());
        });
        assert!(
            update_result.is_ok(),
            "failed to handle drag in destination window: {update_result:?}"
        );

        let update_result = cx.update_window(successful.window, |_, window, cx| {
            window.dispatch_event(
                FileDropEvent::Entered {
                    position: reentry_position,
                    paths: external_paths(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(
                cx.active_drag
                    .as_ref()
                    .is_some_and(|drag| drag.value.downcast_ref::<PathBuf>().is_some())
            );
            assert_eq!(
                successful.observed_drag_moves.borrow().last(),
                Some(&reentry_position)
            );

            window.dispatch_event(FileDropEvent::Exited.to_platform_input(), cx);
            assert!(cx.active_drag.is_none());

            window.dispatch_event(
                FileDropEvent::Entered {
                    position: reentry_position,
                    paths: external_paths(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(
                cx.active_drag
                    .as_ref()
                    .is_some_and(|drag| drag.value.downcast_ref::<PathBuf>().is_some())
            );

            window.dispatch_event(
                FileDropEvent::Submit {
                    position: reentry_position,
                }
                .to_platform_input(),
                cx,
            );
            assert_eq!(
                successful.observed_drops.borrow().as_slice(),
                std::slice::from_ref(&successful_path)
            );
            assert!(cx.active_drag.is_none());

            window.dispatch_event(FileDropEvent::Exited.to_platform_input(), cx);
            assert!(cx.active_drag.is_none());
            window.dispatch_event(FileDropEvent::Ended.to_platform_input(), cx);
            assert!(cx.active_drag.is_none());

            window.dispatch_event(
                FileDropEvent::Entered {
                    position: reentry_position,
                    paths: external_paths(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(
                cx.active_drag
                    .as_ref()
                    .is_some_and(|drag| drag.value.downcast_ref::<ExternalPaths>().is_some())
            );
            window.dispatch_event(FileDropEvent::Exited.to_platform_input(), cx);
        });
        assert!(
            update_result.is_ok(),
            "failed to restore drag in source window: {update_result:?}"
        );

        let cancelled_path = PathBuf::from("/tmp/cancelled-drag");
        let cancelled = start_drag(cx, cancelled_path.clone(), true);
        let update_result = cx.update_window(cancelled.window, |_, window, cx| {
            window.dispatch_event(
                MouseMoveEvent {
                    position: outside_position,
                    pressed_button: Some(MouseButton::Left),
                    modifiers: Default::default(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(cx.active_drag.is_none());

            window.dispatch_event(
                FileDropEvent::Entered {
                    position: reentry_position,
                    paths: ExternalPaths([cancelled_path].into_iter().collect()),
                }
                .to_platform_input(),
                cx,
            );
            assert!(
                cx.active_drag
                    .as_ref()
                    .is_some_and(|drag| drag.value.downcast_ref::<PathBuf>().is_some())
            );
            assert!(cx.stop_active_drag(window));
            assert!(cx.active_drag.is_none());
        });
        assert!(
            update_result.is_ok(),
            "failed to cancel restored drag: {update_result:?}"
        );
        assert!(!cx.update(|cx| cx.end_platform_drag(cancelled.window.window_id())));

        let removed_path = PathBuf::from("/tmp/removed-window-drag");
        let removed = start_drag(cx, removed_path, true);
        let removed_window_id = removed.window.window_id();
        let update_result = cx.update_window(removed.window, |_, window, cx| {
            window.dispatch_event(
                MouseMoveEvent {
                    position: outside_position,
                    pressed_button: Some(MouseButton::Left),
                    modifiers: Default::default(),
                }
                .to_platform_input(),
                cx,
            );
            assert!(cx.active_drag.is_none());
            window.remove_window();
        });
        assert!(
            update_result.is_ok(),
            "failed to remove drag source window: {update_result:?}"
        );
        assert!(!cx.update(|cx| cx.end_platform_drag(removed_window_id)));

        let failed_path = PathBuf::from("/tmp/failed-drag");
        let failed = start_drag(cx, failed_path.clone(), false);
        let update_result = cx.update_window(failed.window, |_, window, cx| {
            for x_position in [-1., -2.] {
                window.dispatch_event(
                    MouseMoveEvent {
                        position: point(px(x_position), px(20.)),
                        pressed_button: Some(MouseButton::Left),
                        modifiers: Default::default(),
                    }
                    .to_platform_input(),
                    cx,
                );
            }
            assert!(cx.active_drag.is_some());
        });
        assert!(
            update_result.is_ok(),
            "failed to retain drag after platform failure: {update_result:?}"
        );
        assert_eq!(
            cx.test_window(failed.window).external_drag_files(),
            [(failed_path, true)]
        );
    }

    struct FocusForwarder {
        a: FocusHandle,
        b: FocusHandle,
    }

    crate::actions!(shortcut_lookup_test, [LookupShortcut]);

    struct ShortcutTargets {
        a: FocusHandle,
        b: FocusHandle,
    }

    impl Render for ShortcutTargets {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div()
                .key_context("ShortcutRoot")
                .child(div().key_context("ShortcutA").track_focus(&self.a))
                .child(div().key_context("ShortcutB").track_focus(&self.b))
        }
    }

    #[gpui::test]
    fn shortcut_lookup_follows_focus_between_rendered_nodes(cx: &mut TestAppContext) {
        cx.update(|cx| {
            cx.bind_keys([
                KeyBinding::new("ctrl-r", LookupShortcut, Some("ShortcutRoot")),
                KeyBinding::new("ctrl-a", LookupShortcut, Some("ShortcutRoot > ShortcutA")),
                KeyBinding::new("ctrl-b", LookupShortcut, Some("ShortcutRoot > ShortcutB")),
            ])
        });
        let handle = cx.add_window(|window, cx| {
            let a = cx.focus_handle();
            let b = cx.focus_handle();
            window.focus(&a, cx);
            ShortcutTargets { a, b }
        });
        handle
            .update(cx, |this, window, cx| {
                let keys = |window: &Window| {
                    window
                        .bindings_for_action(&LookupShortcut)
                        .into_iter()
                        .map(|binding| binding.keystrokes[0].key().to_owned())
                        .collect::<Vec<_>>()
                };
                assert_eq!(keys(window), ["r", "a"]);
                assert_eq!(
                    window
                        .highest_precedence_binding_for_action(&LookupShortcut)
                        .unwrap()
                        .keystrokes[0]
                        .key(),
                    "a"
                );

                // Both nodes already exist. A focus change must affect lookup
                // immediately, without waiting for another draw.
                window.focus(&this.b, cx);
                assert_eq!(keys(window), ["r", "b"]);
                assert_eq!(
                    window
                        .highest_precedence_binding_for_action(&LookupShortcut)
                        .unwrap()
                        .keystrokes[0]
                        .key(),
                    "b"
                );
                assert_eq!(
                    window
                        .bindings_for_action_in(&LookupShortcut, &this.a)
                        .last()
                        .unwrap()
                        .keystrokes[0]
                        .key(),
                    "a"
                );

                window.blur(cx);
                // The fallback node is above this view's context-bearing div.
                assert!(keys(window).is_empty());
                assert!(
                    window
                        .highest_precedence_binding_for_action(&LookupShortcut)
                        .is_none()
                );
            })
            .unwrap();
    }

    impl Render for FocusForwarder {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div()
                .size_full()
                .child(div().w(px(50.)).h(px(50.)).track_focus(&self.a))
                .child(div().w(px(50.)).h(px(50.)).track_focus(&self.b))
        }
    }

    /// When a focus listener moves focus again (e.g. a dock forwarding focus to its
    /// active panel), the resulting focus events must be dispatched without waiting
    /// for an unrelated redraw of the window.
    #[gpui::test]
    fn test_focus_moved_by_focus_listener_is_dispatched(cx: &mut TestAppContext) {
        let b_focus_count = Rc::new(Cell::new(0));
        let window = cx.add_window({
            let b_focus_count = b_focus_count.clone();
            move |window, cx| {
                let a = cx.focus_handle();
                let b = cx.focus_handle();
                cx.on_focus(&a, window, |this: &mut FocusForwarder, window, cx| {
                    let b = this.b.clone();
                    window.focus(&b, cx);
                })
                .detach();
                cx.on_focus(&b, window, move |_, _, _| {
                    b_focus_count.set(b_focus_count.get() + 1);
                })
                .detach();
                FocusForwarder { a, b }
            }
        });

        window.update(cx, |_, window, _| window.activate()).unwrap();
        cx.executor().run_until_parked();

        window
            .update(cx, |this, window, cx| {
                let a = this.a.clone();
                window.focus(&a, cx);
            })
            .unwrap();
        cx.executor().run_until_parked();

        window
            .update(cx, |this, window, _| {
                assert!(this.b.is_focused(window));
            })
            .unwrap();
        assert_eq!(b_focus_count.get(), 1);
    }

    #[gpui::test]
    fn claimed_touch_drag_receives_movement_and_release(cx: &mut TestAppContext) {
        let events = Rc::new(RefCell::new(Vec::new()));
        let window = cx.add_window({
            let events = events.clone();
            move |_, _| TouchDragListener { events }
        });
        let touch = TouchId(1);

        dispatch_touch(window, cx, touch, TouchPhase::Started, 10.);
        dispatch_touch(window, cx, touch, TouchPhase::Moved, 30.);
        dispatch_touch(window, cx, touch, TouchPhase::Ended, 40.);

        assert_eq!(
            events.borrow().as_slice(),
            [
                (TouchPhase::Started, px(10.)),
                (TouchPhase::Moved, px(30.)),
                (TouchPhase::Ended, px(40.)),
            ]
        );
    }

    struct TouchDragListener {
        events: Rc<RefCell<Vec<(TouchPhase, Pixels)>>>,
    }

    impl Render for TouchDragListener {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            let events = self.events.clone();
            canvas(
                |_, _, _| {},
                move |_, _, window, _| {
                    window.on_mouse_event(move |event: &TouchDragEvent, phase, window, _cx| {
                        if phase != DispatchPhase::Bubble {
                            return;
                        }
                        events.borrow_mut().push((event.phase, event.position.x));
                        if event.phase == TouchPhase::Started {
                            window.prevent_default();
                        }
                    });
                },
            )
        }
    }

    #[gpui::test]
    fn long_press_is_claimed_only_when_started_prevents_default(cx: &mut TestAppContext) {
        for response in [
            LongPressResponse::PreventDefault,
            LongPressResponse::StopPropagation,
            LongPressResponse::None,
        ] {
            let phases = Rc::new(RefCell::new(Vec::new()));
            let window = cx.add_window({
                let phases = phases.clone();
                move |_, _| LongPressListener { phases, response }
            });
            dispatch_touch(window, cx, TouchId(1), TouchPhase::Started, 0.);
            cx.executor().advance_clock(Duration::from_millis(501));
            cx.executor().run_until_parked();
            window
                .update(cx, |_, window, _| {
                    assert_eq!(
                        window.long_press_capture.is_some(),
                        response == LongPressResponse::PreventDefault
                    );
                })
                .unwrap();
            dispatch_touch(window, cx, TouchId(1), TouchPhase::Moved, 2.);
            dispatch_touch(window, cx, TouchId(1), TouchPhase::Ended, 2.);
            window
                .update(cx, |_, window, _| {
                    assert!(window.long_press_capture.is_none());
                })
                .unwrap();

            let phases = phases.borrow();
            if response == LongPressResponse::PreventDefault {
                assert_eq!(
                    phases.as_slice(),
                    [TouchPhase::Started, TouchPhase::Moved, TouchPhase::Ended]
                );
            } else {
                assert_eq!(phases.as_slice(), [TouchPhase::Started]);
            }
        }
    }

    #[gpui::test]
    fn stale_default_prevention_does_not_claim_long_press(cx: &mut TestAppContext) {
        let phases = Rc::new(RefCell::new(Vec::new()));
        let window = cx.add_window({
            let phases = phases.clone();
            move |_, _| LongPressListener {
                phases,
                response: LongPressResponse::None,
            }
        });
        window
            .update(cx, |_, window, _| {
                window.prevent_default();
            })
            .unwrap();

        dispatch_touch(window, cx, TouchId(1), TouchPhase::Started, 0.);
        cx.executor().advance_clock(Duration::from_millis(501));
        cx.executor().run_until_parked();
        dispatch_touch(window, cx, TouchId(1), TouchPhase::Moved, 2.);

        assert_eq!(phases.borrow().as_slice(), [TouchPhase::Started]);
    }

    #[gpui::test]
    fn resolved_touch_cancels_scheduled_long_press(cx: &mut TestAppContext) {
        for (phase, position) in [
            (TouchPhase::Ended, 0.),
            (TouchPhase::Cancelled, 0.),
            (TouchPhase::Moved, 20.),
        ] {
            let phases = Rc::new(RefCell::new(Vec::new()));
            let window = cx.add_window({
                let phases = phases.clone();
                move |_, _| LongPressListener {
                    phases,
                    response: LongPressResponse::PreventDefault,
                }
            });
            dispatch_touch(window, cx, TouchId(1), TouchPhase::Started, 0.);
            dispatch_touch(window, cx, TouchId(1), phase, position);
            cx.executor().advance_clock(Duration::from_millis(501));
            cx.executor().run_until_parked();

            assert!(phases.borrow().is_empty(), "{phase:?} allowed long press");
        }
    }

    #[gpui::test]
    fn stale_long_press_timer_cannot_affect_replacement_touch(cx: &mut TestAppContext) {
        let phases = Rc::new(RefCell::new(Vec::new()));
        let window = cx.add_window({
            let phases = phases.clone();
            move |_, _| LongPressListener {
                phases,
                response: LongPressResponse::PreventDefault,
            }
        });
        let first_touch = TouchId(1);
        dispatch_touch(window, cx, first_touch, TouchPhase::Started, 0.);
        cx.executor().advance_clock(Duration::from_millis(250));
        dispatch_touch(window, cx, first_touch, TouchPhase::Cancelled, 0.);
        dispatch_touch(window, cx, TouchId(2), TouchPhase::Started, 10.);

        cx.executor().advance_clock(Duration::from_millis(251));
        cx.executor().run_until_parked();
        assert!(phases.borrow().is_empty());

        cx.executor().advance_clock(Duration::from_millis(250));
        cx.executor().run_until_parked();
        assert_eq!(phases.borrow().as_slice(), [TouchPhase::Started]);
    }

    #[derive(Clone, Copy, PartialEq)]
    enum LongPressResponse {
        PreventDefault,
        StopPropagation,
        None,
    }

    struct LongPressListener {
        phases: Rc<RefCell<Vec<TouchPhase>>>,
        response: LongPressResponse,
    }

    impl Render for LongPressListener {
        fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
            let entity = cx.entity();
            let phases = self.phases.clone();
            let response = self.response;
            canvas(
                |_, _, _| {},
                move |_, _, window, _| {
                    window.on_mouse_event(move |event: &LongPressEvent, phase, window, cx| {
                        if phase != DispatchPhase::Bubble {
                            return;
                        }
                        phases.borrow_mut().push(event.phase);
                        match response {
                            LongPressResponse::PreventDefault => {
                                window.capture_long_press(&entity);
                                window.prevent_default();
                            }
                            LongPressResponse::StopPropagation => cx.stop_propagation(),
                            LongPressResponse::None => {}
                        }
                    });
                },
            )
        }
    }

    fn dispatch_touch<T: 'static>(
        window: crate::WindowHandle<T>,
        cx: &mut TestAppContext,
        id: TouchId,
        phase: TouchPhase,
        x: f32,
    ) {
        window
            .update(cx, |_, window, cx| {
                window.dispatch_event(
                    TouchEvent {
                        id,
                        phase,
                        position: point(px(x), px(0.)),
                        predicted_position: None,
                        force: None,
                    }
                    .to_platform_input(),
                    cx,
                );
            })
            .unwrap();
    }
}
