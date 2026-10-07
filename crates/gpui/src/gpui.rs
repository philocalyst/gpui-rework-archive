#![doc = include_str!("../README.md")]
#![warn(missing_docs)]
#![allow(clippy::type_complexity)] // Not useful, GPUI makes heavy use of callbacks
#![allow(clippy::collapsible_else_if)] // False positives in platform specific code
#![allow(unused_mut)] // False positives in platform specific code

extern crate self as gpui;
#[macro_use]
mod action;
mod animated;
mod app;

mod arena;
mod asset_cache;
mod assets;
mod bounds_tree;
mod color;
/// The default colors used by GPUI.
pub mod colors;
#[cfg(feature = "profiler")]
mod debug_overlay;
mod element;
mod elements;
mod executor;
mod platform_scheduler;
pub(crate) use platform_scheduler::PlatformScheduler;
mod geometry;
mod gestures;
mod global;
mod input;
mod inspector;
mod interactive;
mod key_dispatch;
mod keymap;
mod lerp;
mod motion;
mod path_builder;
mod platform;
pub mod prelude;
/// Profiling utilities for task, frame, and thread performance tracking.
pub mod profiler;
#[cfg(any(
    test,
    target_os = "windows",
    target_os = "linux",
    target_family = "wasm",
    feature = "headless",
    feature = "bench-support"
))]
/// Bounded queues used by dispatchers and platform bridges.
pub mod queue;
mod scene;
mod shared_uri;
mod spring;
mod style;
mod style_transitions;
mod styled;
mod subscription;
mod svg_renderer;
mod tab_stop;
mod taffy;
#[cfg(any(test, feature = "headless"))]
pub mod test;
mod text_system;
mod transition;
mod util;
mod view;
mod window;

#[cfg(any(test, feature = "headless"))]
pub use proptest;

#[cfg(doc)]
pub mod _accessibility;
#[cfg(doc)]
pub mod _ownership_and_data_flow;

/// Explanations of the framework's rendering, input, scheduling, and platform contracts.
///
/// Complete programs and browser previews live in the
/// [walkthroughs](https://gpui-ce.github.io/examples/).
#[cfg(doc)]
pub mod _documentation {
    #[doc = include_str!("../docs/rendering.md")]
    pub mod rendering {}
    #[doc = include_str!("../docs/input.md")]
    pub mod input {}
    #[doc = include_str!("../docs/scheduling.md")]
    pub mod scheduling {}
    #[doc = include_str!("../docs/platforms.md")]
    pub mod platforms {}
    #[cfg(feature = "test-support")]
    #[doc = include_str!("../docs/testing.md")]
    pub mod testing {}
}

/// Do not touch, here be dragons for use by gpui_macros and such.
#[doc(hidden)]
pub mod private {
    pub use anyhow;
    pub use inventory;
    pub use schemars;
    pub use serde;
    pub use serde_json;
}

mod seal {
    /// A mechanism for restricting implementations of a trait to only those in GPUI.
    /// See: <https://predr.ag/blog/definitive-guide-to-sealed-traits-in-rust/>
    pub trait Sealed {}
}

pub use accesskit;
pub use accesskit::Action as AccessibleAction;
pub use accesskit::{Orientation, Role, Toggled};
pub use action::*;
pub use animated::*;
pub use anyhow::Result;
pub use app::*;
pub(crate) use arena::*;
pub use asset_cache::*;
pub use assets::*;
pub use color::*;
pub use ctor::ctor;
#[cfg(feature = "profiler")]
pub use debug_overlay::*;
pub use element::*;
pub use elements::*;
pub use executor::*;
pub use geometry::*;
pub use gestures::*;
pub use global::*;
pub use gpui_macros::{
    AppContext, InteractiveElement, IntoElement, ParentElement, Render, StatefulInteractiveElement,
    Styled, VisualContext, bench, property_test, register_action, test,
};
pub use spring::*;

/// Defines a Criterion benchmark group for benchmarks annotated with [`gpui::bench`].
///
/// This mirrors `criterion::criterion_group!` so GPUI benchmark files can keep the
/// same shape as ordinary Criterion benchmarks.
///
/// [`gpui::bench`]: crate::bench
#[macro_export]
macro_rules! bench_group {
    ($($tokens:tt)*) => {
        criterion::criterion_group!($($tokens)*);
    };
}

/// Defines the entry point for GPUI Criterion benchmark groups.
///
/// This mirrors `criterion::criterion_main!` so GPUI benchmark files can keep the
/// same shape as ordinary Criterion benchmarks.
#[macro_export]
macro_rules! bench_main {
    ($($tokens:tt)*) => {
        criterion::criterion_main!($($tokens)*);
    };
}
pub use gpui_shared_string::*;
pub use gpui_util::arc_cow::ArcCow;
/// HTTP client abstraction for making requests.
pub mod http_client;
pub use input::*;
pub use inspector::*;
pub use interactive::*;
use key_dispatch::*;
pub use keymap::*;
pub use lerp::*;
pub use motion::*;
pub use path_builder::*;
pub use platform::*;
pub use profiler::*;
#[cfg(any(target_os = "windows", target_os = "linux", target_family = "wasm"))]
pub use queue::{PriorityQueueReceiver, PriorityQueueSender};
pub use refineable::*;
pub use scene::*;
pub use shared_uri::*;
use std::{any::Any, future::Future};
pub use style::*;
pub use style_transitions::*;
pub use styled::*;
pub use subscription::*;
pub use svg_renderer::*;
pub(crate) use tab_stop::*;
use taffy::TaffyLayoutEngine;
pub use taffy::{AvailableSpace, LayoutId};
#[cfg(any(test, feature = "headless"))]
pub use test::*;
pub use text_system::*;
pub use transition::*;
pub use util::{FutureExt, Timeout};
pub use view::*;
pub use window::*;

#[cfg(not(target_family = "wasm"))]
pub use pollster::block_on;

/// Entity and app operations shared by synchronous and asynchronous contexts.
///
/// Use this bound for a helper that creates, reads, or updates an entity
/// without needing a particular caller's context type:
///
/// ```
/// use gpui::{AppContext, Entity};
///
/// fn increment<C: AppContext>(count: &Entity<u32>, cx: &mut C) -> u32 {
///     count.update(cx, |value, cx| {
///         *value = value.saturating_add(1);
///         cx.notify();
///         *value
///     })
/// }
/// ```
///
/// # Choose a context
///
/// | Context | Where it comes from | Access across `await` |
/// | --- | --- | --- |
/// | [`App`] | App and window callbacks | Keep the borrow inside the callback. |
/// | [`Context<T>`](Context) | Construction or update of one entity | Keep the borrow inside the callback. |
/// | [`AsyncApp`] | A foreground task or [`App::to_async`] | Reacquires app access for each operation. |
/// | [`AsyncWindowContext`] | [`Window::to_async`] | Reacquires app/window access through handles. |
///
/// An async context does not hold a mutable app borrow while a future waits.
/// Entity reads and updates still run synchronously, and recursive access to
/// the same entity panics. Async entity operations can also panic after the
/// app has been released; window-handle operations return errors instead.
/// [`with_window`](Self::with_window) returns `None` when it cannot obtain
/// the entity's currently associated window.
///
/// [`VisualContext`] adds operations that require a window. Test contexts
/// implement these traits too when `test-support` is enabled.
pub trait AppContext {
    /// Builds a value, stores it in the app, and returns its strong handle.
    ///
    /// `build_entity` receives the new entity's [`Context`]. The value is not
    /// available for a handle-based read until that closure has returned;
    /// construct it from local values instead of reading `cx.entity()`.
    /// Dropping the last returned or cloned handle schedules release.
    #[expect(
        clippy::wrong_self_convention,
        reason = "`App::new` is an ubiquitous function for creating entities"
    )]
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-AppContext-new-d959d7f1.md")]
// docs:examples:end
    fn new<T: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T>;

    /// Reserve a slot for a entity to be inserted later.
    /// The returned [Reservation] allows you to obtain the [EntityId] for the future entity.
    fn reserve_entity<T: 'static>(&mut self) -> Reservation<T>;

    /// Insert a new entity in the app context based on a [Reservation] previously obtained from [`reserve_entity`].
    ///
    /// [`reserve_entity`]: Self::reserve_entity
    fn insert_entity<T: 'static>(
        &mut self,
        reservation: Reservation<T>,
        build_entity: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T>;

    /// Calls `update` with exclusive access to the value and its context.
    ///
    /// Returns the callback's result. Mutation does not notify automatically;
    /// call [`Context::notify`] when consumers need to observe the change.
    /// Reading or updating the same entity through another handle while this
    /// callback runs panics. See [`Entity::update`].
    fn update_entity<T, R>(
        &mut self,
        handle: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R
    where
        T: 'static;

    /// Borrows an entity mutably until the returned guard is dropped.
    ///
    /// The guard ties the entity lease to this context's mutable borrow.
    /// Recursive entity access panics. Async contexts cannot provide this
    /// guard and panic; use [`update_entity`](Self::update_entity) instead.
    fn as_mut<'a, T>(&'a mut self, handle: &Entity<T>) -> GpuiBorrow<'a, T>
    where
        T: 'static;

    /// Calls `read` with the entity's value and app, returning its result.
    ///
    /// A read does not process pending effects. It panics if the entity is
    /// currently leased by an update. See [`Entity::read_with`].
    fn read_entity<T, R>(&self, handle: &Entity<T>, read: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static;

    /// Marks an entity changed and invalidates rendering that depends on it.
    ///
    /// Observers run during effect processing after the current update closure
    /// returns; repeated pending notifications can be coalesced. GPUI does not
    /// infer changes from field mutation. Use this for state changes consumers
    /// should reread, and use [`emit`](Self::emit) when they need an event payload.
    fn notify(&mut self, entity_id: EntityId);

    /// Queues a typed event from `entity` for its subscribers.
    ///
    /// The entity type must implement [`EventEmitter<EventType>`]. Delivery
    /// occurs during effect processing, after the current update closure
    /// returns. Unlike [`notify`](Self::notify), this carries a payload and
    /// does not itself invalidate rendering. This app-level form lets code
    /// emit without updating the publisher.
    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static;

    /// Calls `f` with the live window, its erased root view, and the app.
    ///
    /// Returns an error if the handle no longer names a window. An async
    /// context also returns an error when the app has gone away, is quitting,
    /// or is already borrowed. Panics from `f` are not converted to errors.
    fn update_window<T, F>(&mut self, window: AnyWindowHandle, f: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T;

    /// Calls `f` with the window currently associated with this entity.
    ///
    /// The association comes from the most recent render that referenced the
    /// entity, or from its creation window before its first render. Returns
    /// `None` if no window is associated, the window has closed, or that window
    /// is already being updated. Async contexts also return `None` if the app
    /// was released, is quitting, or cannot be borrowed. See [`App::with_window`].
    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R>;

    /// Reads the window's root entity as `T`, then calls `read` with it.
    ///
    /// Returns an error for a closed window or a root with a different type.
    /// It does not provide a mutable window borrow. The async implementation
    /// also returns an error after app release or while quitting. A conflicting
    /// synchronous app borrow can still panic.
    fn read_window<T, R>(
        &self,
        window: &WindowHandle<T>,
        read: impl FnOnce(Entity<T>, &App) -> R,
    ) -> Result<R>
    where
        T: 'static;

    /// Spawns a `Send` future on the background executor.
    ///
    /// The future receives no foreground app access. Await its returned task
    /// in a foreground future to deliver a result to an entity. Dropping the
    /// task cancels remaining polling; [`Task::detach`] lets it continue.
    fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static;

    /// Calls `callback` with the assigned global and this app.
    ///
    /// Panics if no global of type `G` is assigned. Use the callback form to
    /// keep the borrow scoped while reading other app state.
    fn read_global<G, R>(&self, callback: impl FnOnce(&G, &App) -> R) -> R
    where
        G: Global;

    /// Adds a strong entity handle to app-owned global storage.
    ///
    /// This keeps the entity alive even when no other handles remain. The app
    /// releases this owner at shutdown; call [`Self::remove_global_entity`]
    /// when the app should stop retaining it sooner.
    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>);

    /// Removes the matching entity handle from app-owned global storage.
    ///
    /// If this was the last strong handle, weak upgrades fail immediately and
    /// GPUI drops the stored value during effect processing. Other strong
    /// handles continue to keep it alive.
    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>);

    /// Clones handles to globally-stored entities of type `T`.
    ///
    /// Each yielded handle is strong and keeps its entity alive after the
    /// iterator or app context is dropped. Use [`WeakEntity`] for non-owning
    /// references in long-lived records.
    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>>;
}

/// Returned by [Context::reserve_entity] to later be passed to [Context::insert_entity].
/// Allows you to obtain the [EntityId] for a entity before it is created.
pub struct Reservation<T>(pub(crate) Slot<T>);

impl<T: 'static> Reservation<T> {
    /// Returns the [EntityId] that will be associated with the entity once it is inserted.
    pub fn entity_id(&self) -> EntityId {
        self.0.entity_id()
    }
}

/// App operations that can also supply a window to their callbacks.
///
/// [`AsyncWindowContext`] implements this trait for foreground tasks; the
/// simulated visual test context implements it with `test-support`. Ordinary
/// render and input callbacks already receive separate [`Window`] and
/// [`Context`] arguments and can use those directly.
///
/// Each implementation chooses [`Result`](Self::Result). Async operations are
/// fallible because the window can close while a future waits. Check the
/// returned result before assuming a view was installed or focused.
///
/// A task can await work, then reacquire the window for one synchronous update:
///
/// ```no_run
/// use gpui::{AsyncWindowContext, Entity};
/// use std::time::Duration;
///
/// async fn rename_later(
///     label: Entity<String>,
///     cx: &mut AsyncWindowContext,
/// ) -> anyhow::Result<()> {
///     cx.background_executor().timer(Duration::from_secs(1)).await;
///     label.update_in(cx, |text, window, cx| {
///         *text = "Ready".into();
///         window.set_window_title(text);
///         cx.notify();
///     })?;
///     Ok(())
/// }
/// ```
///
/// Here `?` handles an unavailable app or associated window. It does not catch
/// a recursive entity borrow: reading or updating `label` again inside that
/// callback still panics. A visual test context returns the callback's value
/// directly and panics when its required window is unavailable, so generic
/// code must respect the implementation's `Result` type.
pub trait VisualContext: AppContext {
    /// Wraps an operation's result according to this context's failure model.
    ///
    /// [`AsyncWindowContext`] uses `anyhow::Result<T>`; the visual test context
    /// returns `T` directly and panics when its required window is absent.
    type Result<T>;

    /// Returns the handle of the window associated with this context.
    fn window_handle(&self) -> AnyWindowHandle;

    /// Updates an entity with access to its current window.
    ///
    /// An entity can be associated with the most recently rendered window
    /// that referenced it. The async implementation uses that association,
    /// which can differ from [`window_handle`](Self::window_handle), and
    /// returns an error when no associated window is available.
    fn update_window_entity<T: 'static, R>(
        &mut self,
        entity: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Window, &mut Context<T>) -> R,
    ) -> Self::Result<R>;

    /// Builds an entity while borrowing this context's window.
    ///
    /// The constructor receives the window and the new entity's context.
    /// The async implementation returns an error if the window cannot be
    /// obtained before construction.
    fn new_window_entity<T: 'static>(
        &mut self,
        build_entity: impl FnOnce(&mut Window, &mut Context<T>) -> T,
    ) -> Self::Result<Entity<T>>;

    /// Replace the root view of a window with a new view.
    fn replace_root_view<V>(
        &mut self,
        build_view: impl FnOnce(&mut Window, &mut Context<V>) -> V,
    ) -> Self::Result<Entity<V>>
    where
        V: 'static + Render;

    /// Focus a entity in the window, if it implements the [`Focusable`] trait.
    fn focus<V>(&mut self, entity: &Entity<V>) -> Self::Result<()>
    where
        V: Focusable;
}

/// Declares which typed events an entity may emit.
///
/// Implement `EventEmitter<Event>` for the entity type that publishes
/// `Event`. Consumers can then register with [`Context::subscribe`] or
/// [`App::subscribe`]. Events carry a payload and are delivered during effect
/// processing; they are separate from [`Context::notify`], which tells
/// consumers to reread the entity's current state.
pub trait EventEmitter<E: Any>: 'static {}

/// Global mutation methods available to values that can borrow an [`App`].
///
/// This is blanket-implemented for `BorrowMut<App>`, so `App` and wrappers that
/// mutably borrow an `App` can use the same [`update_global`](Self::update_global)
/// and [`set_global`](Self::set_global) calls. `update_global` leases the value
/// while its callback runs, then restores it and schedules observers of that
/// global type. Use [`App::global_mut`] when a direct mutable reference is more
/// convenient; both paths notify global observers when mutable access is taken.
pub trait BorrowAppContext {
    /// Replaces the context's global of type `T` and schedules its observers.
    fn set_global<T: Global>(&mut self, global: T);
    /// Updates an already-installed global and schedules its observers.
    ///
    /// Panics if that type has no global. The callback receives the global and
    /// the context together, avoiding a second borrow of the app.
    fn update_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R
    where
        G: Global;
    /// Inserts `G::default()` if needed, then updates the global.
    ///
    /// The callback and observer behavior match [`update_global`](Self::update_global).
    fn update_default_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R
    where
        G: Global + Default;
}

impl<C> BorrowAppContext for C
where
    C: std::borrow::BorrowMut<App>,
{
    fn set_global<G: Global>(&mut self, global: G) {
        self.borrow_mut().set_global(global)
    }

    #[track_caller]
    fn update_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R
    where
        G: Global,
    {
        let mut global = self.borrow_mut().lease_global::<G>();
        let result = f(&mut global, self);
        self.borrow_mut().end_global_lease(global);
        result
    }

    fn update_default_global<G, R>(&mut self, f: impl FnOnce(&mut G, &mut Self) -> R) -> R
    where
        G: Global + Default,
    {
        self.borrow_mut().default_global::<G>();
        self.update_global(f)
    }
}

/// Information about the GPU GPUI is running on.
#[derive(Default, Debug, serde::Serialize, serde::Deserialize, Clone)]
pub struct GpuSpecs {
    /// Whether the GPU is really a fake (like `llvmpipe`) running on the CPU.
    pub is_software_emulated: bool,
    /// The name of the device, as reported by Vulkan.
    pub device_name: String,
    /// The name of the driver, as reported by Vulkan.
    pub driver_name: String,
    /// Further information about the driver, as reported by Vulkan.
    pub driver_info: String,
}
