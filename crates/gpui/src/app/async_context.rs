use crate::{
    AnyView, AnyWindowHandle, App, AppCell, AppContext, BackgroundExecutor, BorrowAppContext,
    Entity, EntityId, EventEmitter, Focusable, ForegroundExecutor, Global, GpuiBorrow,
    PromptButton, PromptLevel, Render, Reservation, Result, Subscription, Task, VisualContext,
    Window, WindowHandle,
};
use anyhow::{Context as _, bail};
use derive_more::{Deref, DerefMut};
use futures::channel::oneshot;
use futures::future::FutureExt;
use std::{future::Future, rc::Weak};

use super::{Context, WeakEntity};

/// An app handle that can be held across `await` points.
///
/// `AsyncApp` does not keep the application alive. It is usually created by
/// [`App::to_async`] or supplied to [`App::spawn`], and each operation briefly
/// borrows the live app. If the app has been released, entity operations and
/// [`update`](Self::update) panic when they try to obtain app access.
/// [`update_window`](AppContext::update_window) instead returns an error;
/// [`with_window`](AppContext::with_window) returns `None`. These window
/// operations also reject a conflicting app borrow or an app currently quitting.
///
/// For a complete task lifecycle example, see the
/// [async task walkthrough](https://gpui-ce.github.io/examples/async-task/#completion).
///
/// Entity operations acquire synchronous app access for their closure; no
/// entity or app borrow may cross the next `await`. [`AppContext::as_mut`] is
/// unsupported and panics on this context. Use an update closure instead.
#[derive(Clone)]
pub struct AsyncApp {
    pub(crate) app: Weak<AppCell>,
    pub(crate) background_executor: BackgroundExecutor,
    pub(crate) foreground_executor: ForegroundExecutor,
}

impl AsyncApp {
    fn app(&self) -> std::rc::Rc<AppCell> {
        self.app
            .upgrade()
            .expect("app was released before async operation completed")
    }
}

impl AppContext for AsyncApp {
    fn new<T: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T> {
        let app = self.app();
        let mut app = app.borrow_mut();
        app.new(build_entity)
    }

    fn reserve_entity<T: 'static>(&mut self) -> Reservation<T> {
        let app = self.app();
        let mut app = app.borrow_mut();
        app.reserve_entity()
    }

    fn insert_entity<T: 'static>(
        &mut self,
        reservation: Reservation<T>,
        build_entity: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T> {
        let app = self.app();
        let mut app = app.borrow_mut();
        app.insert_entity(reservation, build_entity)
    }

    fn update_entity<T: 'static, R>(
        &mut self,
        handle: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R {
        let app = self.app();
        let mut app = app.borrow_mut();
        app.update_entity(handle, update)
    }

    fn as_mut<'a, T>(&'a mut self, _handle: &Entity<T>) -> GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        panic!("Cannot as_mut with an async context. Try calling update() first")
    }

    fn read_entity<T, R>(&self, handle: &Entity<T>, callback: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static,
    {
        let app = self.app();
        let lock = app.borrow();
        lock.read_entity(handle, callback)
    }

    fn notify(&mut self, entity_id: EntityId) {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.notify(entity_id);
    }

    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.emit(entity, event)
    }

    fn update_window<T, F>(&mut self, window: AnyWindowHandle, f: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        let app = self.app.upgrade().context("app was released")?;
        let mut lock = app.try_borrow_mut()?;
        if lock.quitting {
            bail!("app is quitting");
        }
        lock.update_window(window, f)
    }

    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        let app = self.app.upgrade()?;
        let mut lock = app.try_borrow_mut().ok()?;
        if lock.quitting {
            return None;
        }
        lock.with_window(entity_id, f)
    }

    fn read_window<T, R>(
        &self,
        window: &WindowHandle<T>,
        read: impl FnOnce(Entity<T>, &App) -> R,
    ) -> Result<R>
    where
        T: 'static,
    {
        let app = self.app.upgrade().context("app was released")?;
        let lock = app.borrow();
        if lock.quitting {
            bail!("app is quitting");
        }
        lock.read_window(window, read)
    }

    #[track_caller]
    fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.background_executor.spawn(future)
    }

    fn read_global<G, R>(&self, callback: impl FnOnce(&G, &App) -> R) -> R
    where
        G: Global,
    {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.update(|this| this.read_global(callback))
    }

    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>) {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.insert_global_entity(entity)
    }

    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>) {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.remove_global_entity(entity)
    }

    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>> {
        let app = self.app();
        let mut lock = app.borrow_mut();
        let iter = lock.global_entities();
        // Cloning the iterator here so that lock can be released when function is going out of scope
        iter.collect::<Vec<_>>().into_iter()
    }
}

impl AsyncApp {
    /// Schedules all windows to be redrawn.
    ///
    /// Panics if the application has already been released.
    pub fn refresh(&self) {
        let app = self.app();
        let mut lock = app.borrow_mut();
        // A direct call would leave the refresh effect queued, which cannot wake
        // a platform render loop that has already parked.
        lock.update(|cx| cx.refresh_windows());
    }

    /// Returns the executor for `Send` work that does not need app access.
    ///
    /// Await a background task from [`spawn`](Self::spawn), then use an update
    /// closure to apply its result on the foreground thread.
    pub fn background_executor(&self) -> &BackgroundExecutor {
        &self.background_executor
    }

    /// Returns the executor for futures on the app's foreground thread.
    ///
    /// [`spawn`](Self::spawn) also supplies an async app handle to the future.
    pub fn foreground_executor(&self) -> &ForegroundExecutor {
        &self.foreground_executor
    }

    /// Runs `f` with exclusive app access, then flushes effects produced by it.
    ///
    /// Panics if the app has been released or if `f` attempts a re-entrant app
    /// borrow. Do not hold an app reference across an `.await`; use this method
    /// again after the await.
    pub fn update<R>(&self, f: impl FnOnce(&mut App) -> R) -> R {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.update(f)
    }

    /// Subscribes to typed events from `entity` through [`App::subscribe`].
    ///
    /// Keep the returned subscription for as long as delivery is needed.
    /// Registration and delivery follow the app's effect queue; the callback
    /// receives the publisher and payload with synchronous app access. This
    /// method does not retain the publisher, but any handles captured by
    /// `on_event` remain strong.
    pub fn subscribe<T, Event>(
        &mut self,
        entity: &Entity<T>,
        on_event: impl FnMut(Entity<T>, &Event, &mut App) + 'static,
    ) -> Subscription
    where
        T: 'static + EventEmitter<Event>,
        Event: 'static,
    {
        let app = self.app();
        let mut lock = app.borrow_mut();
        lock.subscribe(entity, on_event)
    }

    /// Opens a window using the root entity returned by `build_root_view`.
    ///
    /// Returns an error while the app is quitting or when the platform rejects
    /// the window request. Panics if the app has been released or is already
    /// borrowed; unlike [`update_window`](AppContext::update_window), this
    /// method does not turn those failures into errors.
    pub fn open_window<V>(
        &self,
        options: crate::WindowOptions,
        build_root_view: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> Result<WindowHandle<V>>
    where
        V: 'static + Render,
    {
        let app = self.app();
        let mut lock = app.borrow_mut();
        if lock.quitting {
            bail!("app is quitting");
        }
        lock.open_window(options, build_root_view)
    }

    /// Schedules a future on the foreground executor.
    ///
    /// The future receives a clone of this handle and may call
    /// [`AsyncApp::update`] after awaits. Dropping the returned task cancels it;
    /// if a task outlives the app, its next operation that needs the app can
    /// panic because the weak handle can no longer be upgraded.
    #[track_caller]
    pub fn spawn<AsyncFn, R>(&self, f: AsyncFn) -> Task<R>
    where
        AsyncFn: AsyncFnOnce(&mut AsyncApp) -> R + 'static,
        R: 'static,
    {
        let mut cx = self.clone();
        self.foreground_executor
            .spawn(async move { f(&mut cx).await }.boxed_local())
    }

    /// Returns whether this app has a global of type `G`.
    ///
    /// Panics if app access is unavailable. A missing global returns `false`;
    /// it does not create a default value.
    pub fn has_global<G: Global>(&self) -> bool {
        let app = self.app();
        let app = app.borrow_mut();
        app.has_global::<G>()
    }

    /// Reads an installed global with synchronous app access.
    ///
    /// Panics if the global is absent or the app cannot be borrowed. Use
    /// [`try_read_global`](Self::try_read_global) when the global is optional.
    pub fn read_global<G: Global, R>(&self, read: impl FnOnce(&G, &App) -> R) -> R {
        let app = self.app();
        let app = app.borrow_mut();
        read(app.global(), &app)
    }

    /// Reads a global if it is installed and the app is not quitting.
    ///
    /// Returns `None` without calling `read` when either condition fails.
    /// This only makes global lookup optional: a released app or conflicting
    /// app borrow still panics, as with [`read_global`](Self::read_global).
    pub fn try_read_global<G: Global, R>(&self, read: impl FnOnce(&G, &App) -> R) -> Option<R> {
        let app = self.app();
        let app = app.borrow_mut();
        if app.quitting {
            return None;
        }
        Some(read(app.try_global()?, &app))
    }

    /// Installs `G::default()` if needed, then reads the global.
    ///
    /// Initialization runs in an app update and flushes its effects before
    /// `read` is called. Subsequent reads use the existing value. Panics when
    /// app access is unavailable.
    pub fn read_default_global<G: Global + Default, R>(
        &self,
        read: impl FnOnce(&G, &App) -> R,
    ) -> R {
        let app = self.app();
        let mut app = app.borrow_mut();
        app.update(|cx| {
            cx.default_global::<G>();
        });
        read(app.global(), &app)
    }

    /// Updates an installed global, then flushes the app's effects.
    ///
    /// The callback temporarily leases `G`: recursive access to that global
    /// panics. Restoring it queues its observers. A missing global or unavailable
    /// app also panics. See [`BorrowAppContext::update_global`].
    pub fn update_global<G: Global, R>(&self, update: impl FnOnce(&mut G, &mut App) -> R) -> R {
        let app = self.app();
        let mut app = app.borrow_mut();
        app.update(|cx| cx.update_global(update))
    }

    /// Defers an entity update until the returned guard is dropped.
    ///
    /// The guard retains a weak entity handle. Release before guard drop skips
    /// the callback. Otherwise it runs synchronously on drop: app access must
    /// still be available, and the entity must not already be under update.
    /// Use [`App::defer`] from an app callback when work should wait until the
    /// current update has finished.
    pub fn on_drop<T: 'static, Callback: FnOnce(&mut T, &mut Context<T>) + 'static>(
        &self,
        entity: &WeakEntity<T>,
        f: Callback,
    ) -> gpui_util::Deferred<impl FnOnce() + use<T, Callback>> {
        let entity = entity.clone();
        let mut cx = self.clone();
        gpui_util::defer(move || {
            entity.update(&mut cx, f).ok();
        })
    }
}

/// An async app handle paired with one window's identity.
///
/// Obtain it from [`Window::to_async`] or a window-scoped task. The handle can
/// cross `await`, but owns neither the application nor the window. Reacquire
/// both with [`update`](Self::update) after waiting; a closed window returns an
/// error instead of keeping the window alive.
///
/// This type dereferences to [`AsyncApp`] for app-only operations. Those methods
/// retain their own failure behavior, including panics when the app is gone.
/// Its window-scoped methods take precedence over methods of the same name on
/// `AsyncApp`. Use `AsyncApp::update(&cx, |cx| ...)` explicitly for an app-only
/// update; `cx.update(|window, cx| ...)` requires this window.
/// [`VisualContext`] adds view construction and focus operations; its entity
/// updates follow the entity's associated window, which can differ from this
/// handle's window.
///
/// # Create app state or window state
///
/// [`AppContext::new`] and [`AppContext::insert_entity`] attempt construction
/// in this window, giving the entity an initial window association. If window
/// access fails, they fall back to app-only construction. A closed window
/// therefore does not prevent these methods from creating an entity. The
/// fallback retains [`AsyncApp`]'s panic behavior if the app cannot be borrowed
/// or has been released.
///
/// Use [`VisualContext::new_window_entity`] when construction needs a live
/// [`Window`]. It returns an error without calling the constructor when this
/// window cannot be accessed. App-only entity reads and updates do not require
/// the window to remain open.
///
/// ```
/// # #[cfg(feature = "test-support")] {
/// use gpui::{AppContext as _, AsyncApp, Context, Render, TestApp, VisualContext as _,
///            Window, div, prelude::*};
/// use std::cell::Cell;
///
/// struct Root;
/// impl Render for Root {
///     fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
///         div()
///     }
/// }
///
/// let mut app = TestApp::new();
/// let mut window = app.open_window(|_, _| Root);
/// let mut cx = window.update(|_, window, cx| window.to_async(cx));
/// window.update(|_, window, _| window.remove_window());
///
/// let draft = cx.new(|_| String::from("draft"));
/// assert_eq!(draft.read_with(&cx, |draft, _| draft.clone()), "draft");
/// assert!(draft.update_in(&mut cx, |_, _, _| ()).is_err());
/// assert!(cx.update(|_, _| ()).is_err());
/// AsyncApp::update(&cx, |cx| {
///     draft.update(cx, |draft, _| draft.push_str(" saved"));
/// });
/// assert_eq!(draft.read_with(&cx, |draft, _| draft.clone()), "draft saved");
///
/// let constructed = Cell::new(false);
/// assert!(cx.new_window_entity(|_, _| {
///     constructed.set(true);
///     String::from("window state")
/// }).is_err());
/// assert!(!constructed.get());
/// # }
/// ```
///
/// # Update this window explicitly
///
/// Enter this context's [`update`](Self::update) closure, then update the
/// entity through the supplied [`App`], when the operation must use this
/// particular window. Calling [`Entity::update_in`] instead follows the
/// entity's current window association.
///
/// ```no_run
/// use gpui::{AsyncWindowContext, WeakEntity};
/// use std::time::Duration;
///
/// async fn rename_later(
///     label: WeakEntity<String>,
///     cx: &mut AsyncWindowContext,
/// ) -> anyhow::Result<()> {
///     cx.background_executor().timer(Duration::from_secs(1)).await;
///     cx.update(|window, cx| {
///         label.update(cx, |label, cx| {
///             *label = "Ready".into();
///             window.set_window_title(label.as_str());
///             cx.notify();
///         })
///     })??;
///     Ok(())
/// }
/// ```
///
/// The first `?` handles an unavailable app or window; the second handles a
/// released entity. Neither handle retains its target while the timer waits.
#[derive(Clone, Deref, DerefMut)]
pub struct AsyncWindowContext {
    #[deref]
    #[deref_mut]
    app: AsyncApp,
    window: AnyWindowHandle,
}

impl AsyncWindowContext {
    pub(crate) fn new_context(app: AsyncApp, window: AnyWindowHandle) -> Self {
        Self { app, window }
    }

    /// Returns this context's window identity without checking whether it is open.
    pub fn window_handle(&self) -> AnyWindowHandle {
        self.window
    }

    /// Borrows this context's window and app for one synchronous update.
    ///
    /// Returns an error if the window is closed, already being updated, or app
    /// access is unavailable.
    /// Panics raised by `update` propagate. See [`AppContext::update_window`].
    pub fn update<R>(&mut self, update: impl FnOnce(&mut Window, &mut App) -> R) -> Result<R> {
        self.app
            .update_window(self.window, |_, window, cx| update(window, cx))
    }

    /// Updates this window with access to its current, erased root view.
    ///
    /// This has the same failure behavior as [`update`](Self::update). Use
    /// [`AnyView::downcast`] when the root's concrete type is known.
    pub fn update_root<R>(
        &mut self,
        update: impl FnOnce(AnyView, &mut Window, &mut App) -> R,
    ) -> Result<R> {
        self.app.update_window(self.window, update)
    }

    /// Schedules a callback at this window's next frame.
    ///
    /// If the window or app cannot be updated now, registration is silently
    /// skipped. Once registered, timing follows [`Window::on_next_frame`].
    pub fn on_next_frame(&mut self, f: impl FnOnce(&mut Window, &mut App) + 'static) {
        self.app
            .update_window(self.window, |_, window, _| window.on_next_frame(f))
            .ok();
    }

    /// Reads an installed global together with this window.
    ///
    /// Unavailable app or window access returns an error. A missing global
    /// panics through [`App::global`].
    pub fn read_global<G: Global, R>(
        &mut self,
        read: impl FnOnce(&G, &Window, &App) -> R,
    ) -> Result<R> {
        self.app
            .update_window(self.window, |_, window, cx| read(cx.global(), window, cx))
    }

    /// Updates an installed global together with this window.
    ///
    /// Unavailable app or window access returns an error. A missing global or
    /// recursive global access panics. Global observers are queued when the
    /// callback's lease is restored; see [`BorrowAppContext::update_global`].
    pub fn update_global<G, R>(
        &mut self,
        update: impl FnOnce(&mut G, &mut Window, &mut App) -> R,
    ) -> Result<R>
    where
        G: Global,
    {
        self.app.update_window(self.window, |_, window, cx| {
            cx.update_global(|global, cx| update(global, window, cx))
        })
    }

    /// Spawns a foreground future with a clone of this window context.
    ///
    /// Await background work in the future, then call [`update`](Self::update)
    /// to apply its result. Dropping the returned [`Task`] cancels the future;
    /// neither the task's context nor its window handle keeps the window open.
    /// Closing the window does not cancel the future. A later window update
    /// returns an error, which the future can handle before returning.
    #[track_caller]
    pub fn spawn<AsyncFn, R>(&self, f: AsyncFn) -> Task<R>
    where
        AsyncFn: AsyncFnOnce(&mut AsyncWindowContext) -> R + 'static,
        R: 'static,
    {
        let mut cx = self.clone();
        self.foreground_executor
            .spawn(async move { f(&mut cx).await }.boxed_local())
    }

    /// Presents a prompt and returns the chosen answer's zero-based index.
    ///
    /// Presentation follows [`Window::prompt`], including custom prompt builders
    /// and platform behavior. If this window cannot be updated, the returned
    /// receiver is canceled; awaiting it yields an error.
    pub fn prompt<T>(
        &mut self,
        level: PromptLevel,
        message: &str,
        detail: Option<&str>,
        answers: &[T],
    ) -> oneshot::Receiver<usize>
    where
        T: Clone + Into<PromptButton>,
    {
        self.app
            .update_window(self.window, |_, window, cx| {
                window.prompt(level, message, detail, answers, cx)
            })
            .unwrap_or_else(|_| oneshot::channel().1)
    }
}

impl AppContext for AsyncWindowContext {
    fn new<T>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T>
    where
        T: 'static,
    {
        let mut build_entity = Some(build_entity);
        match self.app.update_window(self.window, |_, _, cx| {
            cx.new(
                build_entity
                    .take()
                    .expect("build_entity is taken exactly once"),
            )
        }) {
            Ok(entity) => entity,
            Err(_) => self.app.new(
                build_entity
                    .take()
                    .expect("update_window returned Err without invoking the closure"),
            ),
        }
    }

    fn reserve_entity<T: 'static>(&mut self) -> Reservation<T> {
        self.app.reserve_entity()
    }

    fn insert_entity<T: 'static>(
        &mut self,
        reservation: Reservation<T>,
        build_entity: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T> {
        let mut args = Some((reservation, build_entity));
        match self.app.update_window(self.window, |_, _, cx| {
            let (reservation, build_entity) = args.take().expect("args are taken exactly once");
            cx.insert_entity(reservation, build_entity)
        }) {
            Ok(entity) => entity,
            Err(_) => {
                let (reservation, build_entity) = args
                    .take()
                    .expect("update_window returned Err without invoking the closure");
                self.app.insert_entity(reservation, build_entity)
            }
        }
    }

    fn update_entity<T: 'static, R>(
        &mut self,
        handle: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R {
        self.app.update_entity(handle, update)
    }

    fn as_mut<'a, T>(&'a mut self, _: &Entity<T>) -> GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        panic!("Cannot use as_mut() from an async context, call `update`")
    }

    fn read_entity<T, R>(&self, handle: &Entity<T>, read: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static,
    {
        self.app.read_entity(handle, read)
    }

    fn notify(&mut self, entity_id: EntityId) {
        self.app.notify(entity_id);
    }

    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        self.app.emit(entity, event)
    }

    fn update_window<T, F>(&mut self, window: AnyWindowHandle, update: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        self.app.update_window(window, update)
    }

    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        self.app.with_window(entity_id, f)
    }

    fn read_window<T, R>(
        &self,
        window: &WindowHandle<T>,
        read: impl FnOnce(Entity<T>, &App) -> R,
    ) -> Result<R>
    where
        T: 'static,
    {
        self.app.read_window(window, read)
    }

    #[track_caller]
    fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.app.background_executor.spawn(future)
    }

    fn read_global<G, R>(&self, callback: impl FnOnce(&G, &App) -> R) -> R
    where
        G: Global,
    {
        self.app.read_global(callback)
    }

    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>) {
        self.app.insert_global_entity(entity)
    }

    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>) {
        self.app.remove_global_entity(entity)
    }

    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>> {
        self.app.global_entities()
    }
}

impl VisualContext for AsyncWindowContext {
    type Result<T> = Result<T>;

    fn window_handle(&self) -> AnyWindowHandle {
        self.window
    }

    fn new_window_entity<T: 'static>(
        &mut self,
        build_entity: impl FnOnce(&mut Window, &mut Context<T>) -> T,
    ) -> Result<Entity<T>> {
        self.app.update_window(self.window, |_, window, cx| {
            cx.new(|cx| build_entity(window, cx))
        })
    }

    fn update_window_entity<T: 'static, R>(
        &mut self,
        view: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Window, &mut Context<T>) -> R,
    ) -> Result<R> {
        let view = view.clone();
        self.app
            .with_window(view.entity_id(), |window, app| {
                view.update(app, |entity, cx| update(entity, window, cx))
            })
            .context("entity has no current window")
    }

    fn replace_root_view<V>(
        &mut self,
        build_view: impl FnOnce(&mut Window, &mut Context<V>) -> V,
    ) -> Result<Entity<V>>
    where
        V: 'static + Render,
    {
        self.app.update_window(self.window, |_, window, cx| {
            window.replace_root(cx, build_view)
        })
    }

    fn focus<V>(&mut self, view: &Entity<V>) -> Result<()>
    where
        V: Focusable,
    {
        self.app.update_window(self.window, |_, window, cx| {
            view.read(cx).focus_handle(cx).focus(window, cx);
        })
    }
}
