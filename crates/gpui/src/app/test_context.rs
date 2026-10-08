use crate::{
    Action, AnyView, AnyWindowHandle, App, AppCell, AppContext, AssetRegistry, AsyncApp,
    AvailableSpace, BackgroundExecutor, BorrowAppContext, Bounds, Capslock, ClipboardItem,
    DrawPhase, Drawable, Element, Empty, EntityId, EventEmitter, ForegroundExecutor, Global,
    InputEvent, Keystroke, Modifiers, ModifiersChangedEvent, MouseButton, MouseDownEvent,
    MouseMoveEvent, MouseUpEvent, Pixels, Platform, Point, Render, Result, SharedString, Size,
    SystemNotification, SystemNotificationResponse, Task, TestDispatcher, TestPlatform,
    TestScreenCaptureSource, TestWindow, TextSystem, VisualContext, Window, WindowBounds,
    WindowHandle, WindowOptions, app::GpuiMode, window::ElementArenaScope,
};
use anyhow::{anyhow, bail};
use futures::{Stream, StreamExt, channel::oneshot};

use std::{
    cell::RefCell, future::Future, ops::Deref, path::PathBuf, rc::Rc, sync::Arc, time::Duration,
};

/// A simulated application on the seeded scheduler used by `#[gpui::test]`.
///
/// Each context owns separate entities, globals, windows, and platform state.
/// Multiple context arguments in one test share a scheduler, so their tasks
/// can interleave under the same seed. Cloning a context shares its app;
/// [`Self::new_app`] creates another app on that scheduler.
///
/// [`Self::update`] flushes app effects but leaves draining ready tasks to
/// [`Self::run_until_parked`]. Neither operation advances future timers.
/// Use [`Self::executor`] to advance test time. For a single app whose updates
/// should also drain ready tasks, use [`TestApp`](crate::TestApp).
/// Flushing effects draws dirty simulated windows by default; [`Self::skip_drawing`]
/// disables that work for model-only tests. Explicit drawing is still useful
/// when an assertion needs a frame sampled at a particular clock value.
/// See the [testing guide](https://gpui-ce.github.io/book/testing.html) for observer,
/// timer, cancellation, and input fixtures.
#[derive(Clone)]
pub struct TestAppContext {
    #[doc(hidden)]
    pub background_executor: BackgroundExecutor,
    #[doc(hidden)]
    pub foreground_executor: ForegroundExecutor,
    #[doc(hidden)]
    pub dispatcher: TestDispatcher,
    test_platform: Rc<TestPlatform>,
    text_system: Arc<TextSystem>,
    fn_name: Option<&'static str>,
    on_quit: Rc<RefCell<Vec<Box<dyn FnOnce() + 'static>>>>,
    #[doc(hidden)]
    pub app: Rc<AppCell>,
}

impl AppContext for TestAppContext {
    fn new<T: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T> {
        let mut app = self.app.borrow_mut();
        app.new(build_entity)
    }

    fn reserve_entity<T: 'static>(&mut self) -> crate::Reservation<T> {
        let mut app = self.app.borrow_mut();
        app.reserve_entity()
    }

    fn insert_entity<T: 'static>(
        &mut self,
        reservation: crate::Reservation<T>,
        build_entity: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T> {
        let mut app = self.app.borrow_mut();
        app.insert_entity(reservation, build_entity)
    }

    fn update_entity<T: 'static, R>(
        &mut self,
        handle: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R {
        let mut app = self.app.borrow_mut();
        app.update_entity(handle, update)
    }

    fn as_mut<'a, T>(&'a mut self, _: &Entity<T>) -> super::GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        panic!("Cannot use as_mut with a test app context. Try calling update() first")
    }

    fn read_entity<T, R>(&self, handle: &Entity<T>, read: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static,
    {
        let app = self.app.borrow();
        app.read_entity(handle, read)
    }

    fn notify(&mut self, entity_id: EntityId) {
        let mut lock = self.app.borrow_mut();
        lock.notify(entity_id)
    }

    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        let mut lock = self.app.borrow_mut();
        lock.emit(entity, event)
    }

    fn update_window<T, F>(&mut self, window: AnyWindowHandle, f: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        let mut lock = self.app.borrow_mut();
        lock.update_window(window, f)
    }

    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        let mut lock = self.app.borrow_mut();
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
        let app = self.app.borrow();
        app.read_window(window, read)
    }

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
        let app = self.app.borrow();
        app.read_global(callback)
    }

    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>) {
        let mut lock = self.app.borrow_mut();
        lock.insert_global_entity(entity)
    }

    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>) {
        let mut lock = self.app.borrow_mut();
        lock.remove_global_entity(entity)
    }

    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>> {
        let lock = self.app.borrow();
        let iter = lock.global_entities();
        // Cloning the iterator here so that lock can be released when function is going out of scope
        iter.collect::<Vec<_>>().into_iter()
    }
}

impl TestAppContext {
    /// Creates an app on `dispatcher`, with an optional test name for diagnostics.
    ///
    /// Prefer `#[gpui::test]`, which supplies the scheduler, runs async tests,
    /// and calls [`Self::quit`] afterward. This constructor installs simulated
    /// text metrics, an empty asset registry, and a fake HTTP client returning
    /// 404. Replace the client with [`App::set_http_client`] when testing a
    /// resource response. Use [`Self::new_app`] for a second independent app
    /// whose tasks should interleave on the same scheduler.
    pub fn build(dispatcher: TestDispatcher, fn_name: Option<&'static str>) -> Self {
        let arc_dispatcher = Arc::new(dispatcher.clone());
        let background_executor = BackgroundExecutor::new(arc_dispatcher.clone());
        let foreground_executor = ForegroundExecutor::new(arc_dispatcher);
        let platform = TestPlatform::new(background_executor.clone(), foreground_executor.clone());
        let http_client = crate::http_client::FakeHttpClient::with_404_response();
        let text_system = Arc::new(TextSystem::new(platform.text_system()));

        let app = App::new_app(
            platform.clone(),
            AssetRegistry::default().into(),
            http_client,
        );
        app.borrow_mut().mode = GpuiMode::test();

        Self {
            app,
            background_executor,
            foreground_executor,
            dispatcher,
            test_platform: platform,
            text_system,
            fn_name,
            on_quit: Rc::new(RefCell::new(Vec::default())),
        }
    }

    /// Disable drawing for this application for the rest of the test.
    ///
    /// Entity effects and tasks still run. Use this for model-only tests;
    /// input tests need a drawn frame to install listeners and hitboxes.
    pub fn skip_drawing(&mut self) {
        self.app.borrow_mut().mode = GpuiMode::Test {
            skip_drawing: true,
            draw_on_flush: true,
        };
    }

    /// Create a standalone context with scheduler seed zero.
    ///
    /// Prefer `#[gpui::test]` when the test needs its cleanup, async runner,
    /// or seed options. This constructor does not apply those macro hooks.
    pub fn single() -> Self {
        let dispatcher = TestDispatcher::new(0);
        Self::build(dispatcher, None)
    }

    /// Returns the test name supplied to [`Self::build`], if any.
    ///
    /// `#[gpui::test]` supplies its function name; [`Self::single`] has no name.
    pub fn test_function_name(&self) -> Option<&'static str> {
        self.fn_name
    }

    /// Reports whether a save-path prompt is waiting for an answer.
    ///
    /// This is a pending-state query, not a history of previous prompts. Answer
    /// it with [`Self::simulate_new_path_selection`]. For an open-path prompt,
    /// use [`Self::did_prompt_for_paths`].
    pub fn did_prompt_for_new_path(&self) -> bool {
        self.test_platform.did_prompt_for_new_path()
    }

    /// Create a separate application whose tasks share this test's scheduler.
    ///
    /// Entities, globals, windows, and simulated platform data are separate.
    /// Use [`Clone`] to share the existing app instead.
    pub fn new_app(&self) -> TestAppContext {
        Self::build(self.dispatcher.clone(), self.fn_name)
    }

    /// Runs registered cleanup callbacks, then shuts down this app.
    ///
    /// `#[gpui::test]` calls this after the test body. Callbacks run in
    /// registration order before app shutdown. Clones share both the app and
    /// this cleanup list. A separate context made with [`Self::new_app`] has
    /// its own app and cleanup list.
    pub fn quit(&self) {
        self.on_quit.borrow_mut().drain(..).for_each(|f| f());
        self.app.borrow_mut().shutdown();
    }

    /// Registers cleanup for the next [`Self::quit`] call.
    ///
    /// The callback runs before app shutdown. Register it before test teardown;
    /// merely dropping a context does not call this callback. Prefer ordinary
    /// owned fixtures and `Drop` when cleanup does not need this boundary.
    pub fn on_quit(&mut self, f: impl FnOnce() + 'static) {
        self.on_quit.borrow_mut().push(Box::new(f));
    }

    /// Marks every open window dirty for the next effect cycle.
    ///
    /// This queues invalidation without flushing effects, draining tasks, or
    /// advancing time. It always returns `Ok(())`. Use [`Self::update`] to
    /// flush app effects, or explicitly draw the frame whose geometry the
    /// test needs to inspect.
    pub fn refresh(&mut self) -> Result<()> {
        let mut app = self.app.borrow_mut();
        app.refresh_windows();
        Ok(())
    }

    /// Returns the shared scheduler's executor for `Send` work and test timers.
    ///
    /// Its [`advance_clock`](BackgroundExecutor::advance_clock) method advances
    /// simulated time and runs work due in that interval. Foreground and
    /// background tasks use the same test dispatcher; this does not create a
    /// production worker thread. See [`Self::spawn`] for a local future that
    /// can update app state after an await.
    pub fn executor(&self) -> BackgroundExecutor {
        self.background_executor.clone()
    }

    /// Returns the executor for local foreground futures.
    ///
    /// Spawning queues work; [`Self::run_until_parked`] polls ready tasks.
    /// [`Self::spawn`] also supplies a weak [`AsyncApp`] to the future.
    pub fn foreground_executor(&self) -> &ForegroundExecutor {
        &self.foreground_executor
    }

    /// Borrow the app for a synchronous update and flush its queued effects.
    ///
    /// The closure must not borrow this context's app again. Ready tasks are
    /// not drained here; call [`Self::run_until_parked`] after the borrow ends.
    pub fn update<R>(&self, f: impl FnOnce(&mut App) -> R) -> R {
        let mut cx = self.app.borrow_mut();
        cx.update(f)
    }

    /// Inspect app state without flushing effects or polling tasks.
    pub fn read<R>(&self, f: impl FnOnce(&App) -> R) -> R {
        let cx = self.app.borrow();
        f(&cx)
    }

    /// Opens a simulated window using the test display's maximized bounds.
    ///
    /// The closure constructs its root entity once. GPUI performs the initial
    /// draw after construction; the returned [`WindowHandle`] identifies the
    /// window without owning its lifetime. Use [`Self::open_window`] for a
    /// specific logical size, or [`Self::add_window_view`] for a root handle
    /// and window-bound context together.
    pub fn add_window<F, V>(&mut self, build_window: F) -> WindowHandle<V>
    where
        F: FnOnce(&mut Window, &mut Context<V>) -> V,
        V: 'static + Render,
    {
        let mut cx = self.app.borrow_mut();

        // Some tests rely on the window size matching the bounds of the test display
        let bounds = Bounds::maximized(None, &cx);
        cx.open_window(
            WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds))),
            |window, cx| cx.new(|cx| build_window(window, cx)),
        )
        .unwrap()
    }

    /// Opens a simulated window of `window_size` logical pixels at the origin.
    ///
    /// Use this for a layout boundary such as a compact toolbar width. The
    /// closure constructs the root once and GPUI performs the initial draw.
    /// Dropping the returned handle does not close the window; call
    /// [`Window::remove_window`] inside a window update for explicit teardown.
    pub fn open_window<F, V>(
        &mut self,
        window_size: Size<Pixels>,
        build_window: F,
    ) -> WindowHandle<V>
    where
        F: FnOnce(&mut Window, &mut Context<V>) -> V,
        V: 'static + Render,
    {
        let mut cx = self.app.borrow_mut();
        cx.open_window(
            WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(Bounds {
                origin: Point::default(),
                size: window_size,
            }))),
            |window, cx| cx.new(|cx| build_window(window, cx)),
        )
        .unwrap()
    }

    /// Opens an empty simulated window and returns a window-bound context.
    ///
    /// Uses the test display's maximized bounds, then drains ready tasks.
    /// The context is retained until [`Self::quit`]; use
    /// [`VisualTestContext::from_window`] when the fixture should own its
    /// context by value. [`VisualTestContext::draw`] can exercise a standalone
    /// element here; a view-dependent element needs a root [`Render`] instead.
    pub fn add_empty_window(&mut self) -> &mut VisualTestContext {
        let mut cx = self.app.borrow_mut();
        let bounds = Bounds::maximized(None, &cx);
        let window = cx
            .open_window(
                WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds))),
                |_, cx| cx.new(|_| Empty),
            )
            .unwrap();
        drop(cx);
        let cx = VisualTestContext::from_window(*window.deref(), self).into_mut();
        cx.run_until_parked();
        cx
    }

    /// Opens a view and returns its strong root handle and window-bound context.
    ///
    /// Uses the test display's maximized bounds and drains ready tasks after
    /// opening. The context is retained until [`Self::quit`]. The root handle
    /// independently keeps the view alive, even after the window closes; drop
    /// it as well when asserting release. For a fixture owned by value, use
    /// [`Self::add_window`] followed by [`VisualTestContext::from_window`].
    pub fn add_window_view<F, V>(
        &mut self,
        build_root_view: F,
    ) -> (Entity<V>, &mut VisualTestContext)
    where
        F: FnOnce(&mut Window, &mut Context<V>) -> V,
        V: 'static + Render,
    {
        let mut cx = self.app.borrow_mut();
        let bounds = Bounds::maximized(None, &cx);
        let window = cx
            .open_window(
                WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds))),
                |window, cx| cx.new(|cx| build_root_view(window, cx)),
            )
            .unwrap();
        drop(cx);
        let view = window.root(self).unwrap();
        let cx = VisualTestContext::from_window(*window.deref(), self).into_mut();
        cx.run_until_parked();

        // it might be nice to try and cleanup these at the end of each test.
        (view, cx)
    }

    /// Returns this app's text system, backed by simulated text metrics.
    ///
    /// These metrics do not establish real shaping, wrapping, or bidi layout.
    /// Use [`TestApp::with_text_system`](crate::TestApp::with_text_system) with
    /// a real shaper and bundled font for assertions about those behaviors.
    pub fn text_system(&self) -> &Arc<TextSystem> {
        &self.text_system
    }

    /// Replaces this app's in-memory clipboard item.
    ///
    /// This preserves the complete [`ClipboardItem`], including multiple
    /// entries and metadata. It does not access the native system clipboard.
    pub fn write_to_clipboard(&self, item: ClipboardItem) {
        self.test_platform.write_to_clipboard(item)
    }

    /// Reads the last item written to this app's in-memory clipboard.
    ///
    /// Returns `None` before the first write. Reading does not consume the item.
    pub fn read_from_clipboard(&self) -> Option<ClipboardItem> {
        self.test_platform.read_from_clipboard()
    }

    /// Answer a pending new-path (save) prompt using its proposed directory.
    ///
    /// Return a path to accept it or `None` to cancel. Panics when no such
    /// prompt is pending. Existing-path prompts use [`Self::simulate_path_prompt_response`].
    pub fn simulate_new_path_selection(
        &self,
        select_path: impl FnOnce(&std::path::Path) -> Option<std::path::PathBuf>,
    ) {
        self.test_platform.simulate_new_path_selection(select_path);
    }

    /// Answers the oldest pending open-path prompt using its requested options.
    ///
    /// Return paths to accept, or `None` to cancel. Panics if no prompt is
    /// pending, or if several paths are returned for a single-selection prompt.
    /// This sends the answer without draining tasks; await the app's receiver
    /// or call [`Self::run_until_parked`] before inspecting its continuation.
    /// Save-path prompts use [`Self::simulate_new_path_selection`].
    pub fn simulate_path_prompt_response(
        &self,
        select_paths: impl FnOnce(&crate::PathPromptOptions) -> Option<Vec<std::path::PathBuf>>,
    ) {
        self.test_platform
            .simulate_path_prompt_response(select_paths);
    }

    /// Reports whether an open-path prompt is waiting for an answer.
    ///
    /// Answer it with [`Self::simulate_path_prompt_response`]. This does not
    /// report save-path prompts or previously answered dialogs.
    pub fn did_prompt_for_paths(&self) -> bool {
        self.test_platform.did_prompt_for_paths()
    }

    /// Answers the oldest pending alert by its exact button label.
    ///
    /// Panics if no alert is pending or the label is absent. The answer wakes
    /// its receiver without draining ready tasks. Inspect the message with
    /// [`Self::pending_prompt`] before answering, then await the continuation
    /// or call [`Self::run_until_parked`] to check its result.
    #[track_caller]
    pub fn simulate_prompt_answer(&self, button: &str) {
        self.test_platform.simulate_prompt_answer(button);
    }

    /// Reports whether a platform alert is waiting for an answer.
    pub fn has_pending_prompt(&self) -> bool {
        self.test_platform.has_pending_prompt()
    }

    /// Returns the oldest pending alert's message and detail without consuming it.
    ///
    /// A missing detail is returned as an empty string. Returns `None` when
    /// there is no alert; path-selection prompts are separate queues.
    pub fn pending_prompt(&self) -> Option<(String, String)> {
        self.test_platform.pending_prompt()
    }

    /// Return the most recent URL passed to [`App::open_url`], if any.
    pub fn opened_url(&self) -> Option<String> {
        self.test_platform.opened_url.borrow().clone()
    }

    /// Returns the application identity configured during this test.
    pub fn app_identity(&self) -> Option<(SharedString, SharedString)> {
        self.test_platform.app_identity()
    }

    /// Returns all system notifications shown during this test, in order.
    pub fn shown_system_notifications(&self) -> Vec<SystemNotification> {
        self.test_platform.shown_system_notifications()
    }

    /// Returns the system notifications currently delivered by the test platform.
    pub fn delivered_system_notifications(&self) -> Vec<SystemNotification> {
        self.test_platform.delivered_system_notifications()
    }

    /// Returns the tags of all system notifications dismissed during this test, in order.
    pub fn dismissed_system_notifications(&self) -> Vec<SharedString> {
        self.test_platform.dismissed_system_notifications()
    }

    /// Simulates the user activating a system notification.
    pub fn simulate_system_notification_response(&self, response: SystemNotificationResponse) {
        self.test_platform
            .simulate_system_notification_response(response);
    }

    /// Changes a simulated window's content size in logical pixels.
    ///
    /// Invokes its platform resize callback without draining ready tasks or
    /// advancing time. Panics if the window is closed. Draw explicitly before
    /// asserting the resulting geometry.
    pub fn simulate_window_resize(&self, window_handle: AnyWindowHandle, size: Size<Pixels>) {
        self.test_window(window_handle).simulate_resize(size);
    }

    /// Install a receiver for the next restart request's path and arguments.
    ///
    /// Call before triggering the restart. Replacing an earlier expectation
    /// drops its sender and cancels that receiver.
    pub fn expect_restart(&self) -> oneshot::Receiver<(Option<PathBuf>, Vec<std::ffi::OsString>)> {
        let (tx, rx) = futures::channel::oneshot::channel();
        self.test_platform.expect_restart.borrow_mut().replace(tx);
        rx
    }

    /// Causes the given sources to be returned if the application queries for screen
    /// capture sources.
    pub fn set_screen_capture_sources(&self, sources: Vec<TestScreenCaptureSource>) {
        self.test_platform.set_screen_capture_sources(sources);
    }

    /// Returns all windows open in the test.
    pub fn windows(&self) -> Vec<AnyWindowHandle> {
        self.app.borrow().windows()
    }

    /// Spawn a local foreground future with a weak async app handle.
    ///
    /// Retain or await its [`Task`] to keep it running, or detach it to give
    /// up cancellation through that handle. This does not move work to a
    /// background thread or drain the scheduler.
    #[track_caller]
    pub fn spawn<Fut, R>(&self, f: impl FnOnce(AsyncApp) -> Fut) -> Task<R>
    where
        Fut: Future<Output = R> + 'static,
        R: 'static,
    {
        self.foreground_executor.spawn(f(self.to_async()))
    }

    /// Reports whether this app contains a global of type `G`.
    pub fn has_global<G: Global>(&self) -> bool {
        let app = self.app.borrow();
        app.has_global::<G>()
    }

    /// Reads a global for the duration of `read`, without flushing effects.
    ///
    /// Panics if `G` is absent. Use [`Self::try_read_global`] when absence is
    /// part of the behavior under test. This does not drain ready tasks.
    pub fn read_global<G: Global, R>(&self, read: impl FnOnce(&G, &App) -> R) -> R {
        let app = self.app.borrow();
        read(app.global(), &app)
    }

    /// Reads `G` when present, or returns `None` without calling `read`.
    ///
    /// This does not flush app effects or drain ready tasks.
    pub fn try_read_global<G: Global, R>(&self, read: impl FnOnce(&G, &App) -> R) -> Option<R> {
        let lock = self.app.borrow();
        Some(read(lock.try_global()?, &lock))
    }

    /// Installs or replaces `G`, then flushes app effects.
    ///
    /// Ready tasks are not drained. Retain a global observation when the test
    /// needs to check consumers notified by subsequent updates.
    pub fn set_global<G: Global>(&mut self, global: G) {
        let mut lock = self.app.borrow_mut();
        lock.update(|cx| cx.set_global(global))
    }

    /// Updates `G` and flushes effects, without draining ready tasks.
    ///
    /// Panics if `G` is absent. The global is leased during the callback, so
    /// recursively accessing that same global also panics. See
    /// [`BorrowAppContext::update_global`] for the borrowing and notification contract.
    pub fn update_global<G: Global, R>(&mut self, update: impl FnOnce(&mut G, &mut App) -> R) -> R {
        let mut lock = self.app.borrow_mut();
        lock.update(|cx| cx.update_global(update))
    }

    /// Returns a weak app handle for foreground tasks that need app access after an await.
    ///
    /// This does not move work to a background thread. Use `executor()` for
    /// `Send` background work and `spawn()` for a local foreground future.
    pub fn to_async(&self) -> AsyncApp {
        AsyncApp {
            app: Rc::downgrade(&self.app),
            background_executor: self.background_executor.clone(),
            foreground_executor: self.foreground_executor.clone(),
        }
    }

    /// Runs ready tasks until no runnable work remains.
    ///
    /// Pending timers do not advance automatically. The executor's
    /// `advance_clock` method advances time and runs work due in that interval;
    /// call this again only when more runnable work has since been queued.
    pub fn run_until_parked(&self) {
        self.dispatcher.run_until_parked();
    }

    /// Dispatch an action on the window's focus path, then drain ready work.
    ///
    /// This bypasses key matching. Use [`Self::simulate_keystrokes`] when
    /// testing a binding or its key-context predicate. Panics if the window
    /// is closed.
    pub fn dispatch_action<A>(&mut self, window: AnyWindowHandle, action: A)
    where
        A: Action,
    {
        window
            .update(self, |_, window, cx| {
                window.dispatch_action(action.boxed_clone(), cx)
            })
            .unwrap();

        self.background_executor.run_until_parked()
    }

    /// Dispatch space-separated key presses, then drain ready tasks.
    ///
    /// Each token is parsed by [`Keystroke::parse`] and passed through
    /// [`Window::dispatch_keystroke`], including simulated committed text.
    /// No key releases are sent. For press/release behavior such as button
    /// activation, use [`VisualTestContext::simulate_event`] as well.
    /// Panics on a parse error or a closed window.
    pub fn simulate_keystrokes(&mut self, window: AnyWindowHandle, keystrokes: &str) {
        for keystroke in keystrokes
            .split(' ')
            .map(Keystroke::parse)
            .map(Result::unwrap)
        {
            self.dispatch_keystroke(window, keystroke);
        }

        self.background_executor.run_until_parked()
    }

    /// Simulate text as individual key presses, then drain ready work.
    ///
    /// This uses keystroke parsing and GPUI's simulated committed-text path,
    /// not native IME composition. Use the text-input handler's methods when
    /// testing marked ranges or replacement semantics. Panics if the window
    /// is closed.
    pub fn simulate_input(&mut self, window: AnyWindowHandle, input: &str) {
        for keystroke in input.split("").map(Keystroke::parse).map(Result::unwrap) {
            self.dispatch_keystroke(window, keystroke);
        }

        self.background_executor.run_until_parked()
    }

    /// Dispatch one key press and its simulated committed text.
    ///
    /// App effects are flushed, but ready tasks are not drained and no key
    /// release is generated. Panics if the window is closed. For a sequence
    /// with automatic draining, use [`Self::simulate_keystrokes`].
    pub fn dispatch_keystroke(&mut self, window: AnyWindowHandle, keystroke: Keystroke) {
        self.update_window(window, |_, window, cx| {
            window.dispatch_keystroke(keystroke, cx)
        })
        .unwrap();
    }

    /// Returns the `TestWindow` backing the given handle.
    pub(crate) fn test_window(&self, window: AnyWindowHandle) -> TestWindow {
        self.app
            .borrow_mut()
            .windows
            .get_mut(window.id)
            .unwrap()
            .as_deref_mut()
            .unwrap()
            .platform_window
            .as_test()
            .unwrap()
            .clone()
    }

    /// Install a notification stream before starting the operation to observe.
    ///
    /// Each item is a signal to read the entity's current state, not a
    /// snapshot or an item for every field mutation. Notifications require
    /// `notify` and may be coalesced. The channel closes when the entity is
    /// released.
    ///
    /// This helper detaches its observation: dropping the stream does not
    /// unregister it. Use [`crate::observe`] for a stream that owns its
    /// subscription and unsubscribes on drop.
    /// The [notification fixture](crate::_documentation::testing#observe-before-starting-the-operation)
    /// shows why observation must precede the operation, and which stream owns
    /// its subscription.
    pub fn notifications<T: 'static>(
        &mut self,
        entity: &Entity<T>,
    ) -> impl Stream<Item = ()> + use<T> {
        let (tx, rx) = futures::channel::mpsc::unbounded();
        self.update(|cx| {
            cx.observe(entity, {
                let tx = tx.clone();
                move |_, _| {
                    let _ = tx.unbounded_send(());
                }
            })
            .detach();
            cx.observe_release(entity, move |_, _| tx.close_channel())
                .detach()
        });
        rx
    }

    /// Install a stream of cloned event payloads from `entity`.
    ///
    /// Install this before emitting the first event the test needs to see.
    /// Unlike notifications, events describe individual occurrences. The
    /// subscription is detached; dropping the receiver alone does not
    /// unregister it. Releasing the publisher removes the callback.
    /// See the [event fixture](crate::_documentation::testing#preserve-each-events-payload)
    /// for asserting several payloads published during one update.
    pub fn events<Evt, T: 'static + EventEmitter<Evt>>(
        &mut self,
        entity: &Entity<T>,
    ) -> futures::channel::mpsc::UnboundedReceiver<Evt>
    where
        Evt: 'static + Clone,
    {
        let (tx, rx) = futures::channel::mpsc::unbounded();
        entity
            .update(self, |_, cx: &mut Context<T>| {
                cx.subscribe(entity, move |_entity, _handle, event, _cx| {
                    let _ = tx.unbounded_send(event.clone());
                })
            })
            .detach();
        rx
    }

    /// Wait for an entity predicate, with a three-second test-clock timeout.
    ///
    /// Checks immediately and again after each notification. The operation
    /// being tested must notify when it changes the relevant state. Treat the
    /// predicate as an assertion query, even though it receives mutable access.
    /// Panics on timeout. Use [`Self::run_until_parked`] followed by an assertion
    /// when draining currently ready work is the desired boundary.
    ///
    /// The async test runner can advance the simulated clock while waiting.
    /// This timeout is not three seconds of wall time, and it cannot make an
    /// uncontrolled network request deterministic. For exact deadlines, use
    /// the [timer fixture](crate::_documentation::testing#check-both-sides-of-a-timer-deadline).
    pub async fn condition<T: 'static>(
        &mut self,
        entity: &Entity<T>,
        mut predicate: impl FnMut(&mut T, &mut Context<T>) -> bool,
    ) {
        let timer = self.executor().timer(Duration::from_secs(3));
        let mut notifications = self.notifications(entity);

        use futures::FutureExt as _;
        use futures_concurrency::future::Race as _;

        (
            async {
                loop {
                    if entity.update(self, &mut predicate) {
                        return Ok(());
                    }

                    if notifications.next().await.is_none() {
                        bail!("entity dropped")
                    }
                }
            },
            timer.map(|_| Err(anyhow!("condition timed out"))),
        )
            .race()
            .await
            .unwrap();
    }

    /// Set a name for this App.
    #[cfg(any(test, feature = "headless"))]
    pub fn set_name(&mut self, name: &'static str) {
        self.update(|cx| cx.name = Some(name))
    }
}

impl<T: 'static> Entity<T> {
    /// Install a one-shot event subscription and return its waiting future.
    ///
    /// Call this before the operation that emits the event. The future owns
    /// the subscription; dropping it unsubscribes. Awaiting clones the first
    /// payload received, and panics if the sender disappears without an event.
    pub fn next_event<Event>(&self, cx: &mut TestAppContext) -> impl Future<Output = Event>
    where
        Event: Send + Clone + 'static,
        T: EventEmitter<Event>,
    {
        let (tx, mut rx) = oneshot::channel();
        let mut tx = Some(tx);
        let subscription = self.update(cx, |_, cx| {
            cx.subscribe(self, move |_, _, event, _| {
                if let Some(tx) = tx.take() {
                    _ = tx.send(event.clone());
                }
            })
        });

        async move {
            let event = rx.await.expect("no event emitted");
            drop(subscription);
            event
        }
    }
}

impl<V: 'static> Entity<V> {
    /// Observes the next entity notification, then advances test time immediately.
    ///
    /// The observation is installed and the test clock is advanced by
    /// `advance_clock_by` before this method returns. Advancing the clock runs
    /// due work immediately, so the returned future can already be ready when
    /// first polled. A value mutation without [`Context::notify`] does not
    /// complete it. The future owns the observation and unsubscribes on drop;
    /// it has no timeout and panics if the entity is released before notifying.
    ///
    /// This example registers the observation before advancing across a task's
    /// deadline. The state has changed before the returned future is awaited:
    ///
    /// ```
    /// use gpui::{AppContext as _, TestAppContext};
    /// use std::time::Duration;
    ///
    /// let mut cx = TestAppContext::single();
    /// let finished = cx.new(|_| false);
    /// let weak = finished.downgrade();
    /// let timer = cx.executor().timer(Duration::from_secs(1));
    /// let task = cx.spawn(|mut cx| async move {
    ///     timer.await;
    ///     weak.update(&mut cx, |finished, cx| {
    ///         *finished = true;
    ///         cx.notify();
    ///     }).unwrap();
    /// });
    /// cx.run_until_parked();
    /// assert!(!finished.read_with(&cx, |finished, _| *finished));
    /// let notified = finished.next_notification(Duration::from_secs(1), &cx);
    /// assert!(finished.read_with(&cx, |finished, _| *finished));
    /// futures::executor::block_on(notified);
    /// assert!(task.is_ready());
    /// cx.quit();
    /// ```
    ///
    /// Use [`crate::observe`] for repeated notifications without advancing
    /// time, or [`TestAppContext::condition`] for a predicate with a timeout.
    pub fn next_notification(
        &self,
        advance_clock_by: Duration,
        cx: &TestAppContext,
    ) -> impl Future<Output = ()> {
        use postage::prelude::{Sink as _, Stream as _};

        let (mut tx, mut rx) = postage::mpsc::channel(1);
        let subscription = cx.app.borrow_mut().observe(self, move |_, _| {
            tx.try_send(()).ok();
        });

        cx.executor().advance_clock(advance_clock_by);

        async move {
            rx.recv()
                .await
                .expect("entity dropped while test was waiting for its next notification");
            drop(subscription);
        }
    }
}

impl<V> Entity<V> {
    /// Wait until a read-only predicate becomes true after a notification or event.
    ///
    /// Installs both subscriptions before returning, then checks the predicate
    /// when polled and after either signal. Unlike [`TestAppContext::condition`],
    /// this helper has no timeout. Dropping the future unsubscribes. Panics if
    /// the entity is released while waiting.
    pub fn condition<Evt>(
        &self,
        cx: &TestAppContext,
        mut predicate: impl FnMut(&V, &App) -> bool,
    ) -> impl Future<Output = ()>
    where
        Evt: 'static,
        V: EventEmitter<Evt>,
    {
        use postage::prelude::{Sink as _, Stream as _};

        let (tx, mut rx) = postage::mpsc::channel(1024);

        let mut cx = cx.app.borrow_mut();
        let subscriptions = (
            cx.observe(self, {
                let mut tx = tx.clone();
                move |_, _| {
                    tx.blocking_send(()).ok();
                }
            }),
            cx.subscribe(self, {
                let mut tx = tx;
                move |_, _: &Evt, _| {
                    tx.blocking_send(()).ok();
                }
            }),
        );

        let cx = cx.this.upgrade().unwrap();
        let handle = self.downgrade();

        async move {
            loop {
                {
                    let cx = cx.borrow();
                    let cx = &*cx;
                    if predicate(
                        handle
                            .upgrade()
                            .expect("view dropped with pending condition")
                            .read(cx),
                        cx,
                    ) {
                        break;
                    }
                }

                rx.recv()
                    .await
                    .expect("view dropped with pending condition");
            }
            drop(subscriptions);
        }
    }
}

use derive_more::{Deref, DerefMut};

use super::{Context, Entity};
#[derive(Deref, DerefMut, Clone)]
/// A simulated window plus its [`TestAppContext`].
///
/// [`Self::update`] supplies a window and app together, while dereferencing
/// exposes the underlying test context. Obtain one from
/// [`TestAppContext::add_window_view`] or [`Self::from_window`]. This harness
/// records GPUI drawing; native macOS pixel capture uses
/// [`VisualTestAppContext`](crate::VisualTestAppContext) instead.
pub struct VisualTestContext {
    #[deref]
    #[deref_mut]
    /// The app context shared with this window-bound fixture.
    ///
    /// Dereferencing exposes its app-level helpers. Its clone retains the app;
    /// dropping this fixture does not close the window.
    pub cx: TestAppContext,
    window: AnyWindowHandle,
}

impl VisualTestContext {
    /// Updates this window and flushes app effects before returning.
    ///
    /// The window and app borrows last only for the callback. Ready tasks are
    /// not drained; call [`Self::run_until_parked`] after the update when the
    /// assertion depends on queued work. Panics if the window is closed.
    pub fn update<R>(&mut self, f: impl FnOnce(&mut Window, &mut App) -> R) -> R {
        self.cx
            .update_window(self.window, |_, window, cx| f(window, cx))
            .unwrap()
    }

    /// Binds a fixture to a window in `cx`'s app.
    ///
    /// Clones the app context without opening, activating, or drawing a window.
    /// The handle must belong to this app. Keep the returned fixture by value
    /// when its lifetime should follow the test's ordinary local ownership.
    /// Window operations panic after the window closes.
    pub fn from_window(window: AnyWindowHandle, cx: &TestAppContext) -> Self {
        Self {
            cx: cx.clone(),
            window,
        }
    }

    /// Runs ready tasks until no runnable work remains.
    ///
    /// Pending timers do not advance automatically; use the test context's
    /// executor to advance time and run work due in that interval. Call this
    /// again only when more runnable work has since been queued.
    pub fn run_until_parked(&self) {
        self.cx.background_executor.run_until_parked();
    }

    /// Dispatches an action along the focus path, then drains ready tasks.
    ///
    /// This bypasses key matching. Use [`Self::simulate_keystrokes`] to test
    /// a binding and its key-context predicate. Panics on a closed window.
    pub fn dispatch_action<A>(&mut self, action: A)
    where
        A: Action,
    {
        self.cx.dispatch_action(self.window, action)
    }

    /// Reads the simulated platform title last set by [`Window::set_window_title`].
    ///
    /// Returns `None` before a title is set; an explicitly empty title is
    /// `Some(String::new())`. Panics on a closed window.
    pub fn window_title(&mut self) -> Option<String> {
        self.cx.test_window(self.window).0.lock().title.clone()
    }

    /// Reads the path last set by [`Window::set_document_path`].
    ///
    /// Returns `None` when no path is set. This inspects platform metadata;
    /// it does not read a document from disk. Panics on a closed window.
    pub fn document_path(&mut self) -> Option<std::path::PathBuf> {
        self.cx
            .test_window(self.window)
            .0
            .lock()
            .document_path
            .clone()
    }

    /// Dispatches space-separated key presses, then drains ready tasks.
    ///
    /// For example, `"cmd-p escape"` uses [`Keystroke::parse`] for each token.
    /// It includes simulated committed text but sends no releases. Use
    /// [`Self::simulate_event`] for a matching [`crate::KeyUpEvent`] when
    /// checking button activation. Panics on invalid syntax or a closed window.
    pub fn simulate_keystrokes(&mut self, keystrokes: &str) {
        self.cx.simulate_keystrokes(self.window, keystrokes)
    }

    /// Dispatches text through the test keystroke path, then drains ready tasks.
    ///
    /// Delegates to [`TestAppContext::simulate_input`], including its simulated
    /// committed-text behavior. It does not reproduce native IME composition
    /// or send key releases. Panics on a closed window.
    pub fn simulate_input(&mut self, input: &str) {
        self.cx.simulate_input(self.window, input)
    }

    /// Moves the pointer to a window-local point in logical pixels.
    ///
    /// `button` describes an already pressed button; it does not generate a
    /// press. Dispatches the move with `modifiers`, then drains ready tasks.
    pub fn simulate_mouse_move(
        &mut self,
        position: Point<Pixels>,
        button: impl Into<Option<MouseButton>>,
        modifiers: Modifiers,
    ) {
        self.simulate_event(MouseMoveEvent {
            position,
            modifiers,
            pressed_button: button.into(),
        })
    }

    /// Sends one pointer press at a window-local point in logical pixels.
    ///
    /// Uses click count one and `first_mouse = false`. It does not first send
    /// a move, activate the window, or send a release. Drains ready tasks.
    pub fn simulate_mouse_down(
        &mut self,
        position: Point<Pixels>,
        button: MouseButton,
        modifiers: Modifiers,
    ) {
        self.simulate_event(MouseDownEvent {
            position,
            modifiers,
            button,
            click_count: 1,
            first_mouse: false,
        })
    }

    /// Sends one pointer release at a window-local point in logical pixels.
    ///
    /// Uses click count one. It does not first send a move or press. Drains
    /// ready tasks; the corresponding press should come from the test fixture.
    pub fn simulate_mouse_up(
        &mut self,
        position: Point<Pixels>,
        button: MouseButton,
        modifiers: Modifiers,
    ) {
        self.simulate_event(MouseUpEvent {
            position,
            modifiers,
            button,
            click_count: 1,
        })
    }

    /// Sends a primary press and release at a window-local logical point.
    ///
    /// Both events use click count one and the supplied modifiers. Ready work
    /// drains after each event, so a press handler can change state before
    /// release. No pointer move or clock advancement is added.
    pub fn simulate_click(&mut self, position: Point<Pixels>, modifiers: Modifiers) {
        self.simulate_event(MouseDownEvent {
            position,
            modifiers,
            button: MouseButton::Left,
            click_count: 1,
            first_mouse: false,
        });
        self.simulate_event(MouseUpEvent {
            position,
            modifiers,
            button: MouseButton::Left,
            click_count: 1,
        });
    }

    /// Sends a modifier-state change with Caps Lock off, then drains ready tasks.
    ///
    /// This does not synthesize presses or releases for individual keys. Use
    /// [`Self::simulate_event`] to retain a different Caps Lock state.
    pub fn simulate_modifiers_change(&mut self, modifiers: Modifiers) {
        self.simulate_event(ModifiersChangedEvent {
            modifiers,
            capslock: Capslock { on: false },
        })
    }

    /// Sends a Caps Lock change with all other modifiers off, then drains ready tasks.
    pub fn simulate_capslock_change(&mut self, on: bool) {
        self.simulate_event(ModifiersChangedEvent {
            modifiers: Modifiers::none(),
            capslock: Capslock { on },
        })
    }

    /// Changes the simulated content size in logical pixels.
    ///
    /// Invokes the platform resize callback without draining ready tasks or
    /// advancing time. Panics on a closed window. Draw before asserting the
    /// resulting layout.
    pub fn simulate_resize(&self, size: Size<Pixels>) {
        self.simulate_window_resize(self.window, size)
    }

    /// Looks up a debug selector in the last completed frame's logical bounds.
    ///
    /// Install it with [`InteractiveElement::debug_selector`](crate::InteractiveElement::debug_selector)
    /// and draw the intended frame first. Returns `None` when that selector
    /// was not recorded. Selectors are diagnostic strings, not element IDs;
    /// duplicate strings overwrite earlier bounds. Panics on a closed window.
    pub fn debug_bounds(&mut self, selector: &'static str) -> Option<Bounds<Pixels>> {
        self.update(|window, _| window.rendered_frame.debug_bounds.get(selector).copied())
    }

    /// Lay out, prepaint, and paint one element at `origin` in `space`.
    ///
    /// Returns the element's layout and prepaint states. This is a low-level
    /// fixture for standalone elements: it does not render the window's root
    /// view or establish a current view on the render stack. Elements that
    /// need view identity, including tracked scrolling, should be tested in a
    /// root [`Render`] implementation instead. Use [`TestAppWindow::draw`](crate::TestAppWindow::draw)
    /// to draw such a view without leasing it for an update at the same time.
    pub fn draw<E>(
        &mut self,
        origin: Point<Pixels>,
        space: impl Into<Size<AvailableSpace>>,
        f: impl FnOnce(&mut Window, &mut App) -> E,
    ) -> (E::RequestLayoutState, E::PrepaintState)
    where
        E: Element,
    {
        self.update(|window, cx| {
            let arena_scope = ElementArenaScope::enter(&cx.element_arena);

            window.invalidator.set_phase(DrawPhase::Prepaint);
            let mut element = Drawable::new(f(window, cx));
            element.layout_as_root(space.into(), window, cx);
            window.with_absolute_element_offset(origin, |window| element.prepaint(window, cx));

            window.invalidator.set_phase(DrawPhase::Paint);
            let (request_layout_state, prepaint_state) = element.paint(window, cx);

            window.invalidator.set_phase(DrawPhase::None);
            window.refresh();

            drop(element);
            arena_scope.exit(&cx.element_arena).clear(cx);

            (request_layout_state, prepaint_state)
        })
    }

    /// Sends one platform input event, then drains ready tasks.
    ///
    /// Draw the intended tree first so its hitboxes and listeners are present.
    /// This preserves the supplied event: a raw key press does not add committed
    /// text, and no matching release or gesture phase is synthesized. Use
    /// [`Self::simulate_keystrokes`] for the committed-text key path. This does
    /// not advance time or send input through the operating system. Panics on
    /// a closed window.
    pub fn simulate_event<E: InputEvent>(&mut self, event: E) {
        self.test_window(self.window)
            .simulate_input(event.to_platform_input());
        self.background_executor.run_until_parked();
    }

    /// Deactivates this window if it is the simulated platform's active window.
    ///
    /// Drains ready tasks to deliver the activation change. It leaves the
    /// window's selected focus handle intact: native activation and element
    /// focus are separate. Another active window is left unchanged.
    pub fn deactivate_window(&mut self) {
        if Some(self.window) == self.test_platform.active_window() {
            self.test_platform.set_active_window(None)
        }
        self.background_executor.run_until_parked();
    }

    /// Calls the window's close-request callback and returns its decision.
    ///
    /// Returns `false` when no callback is installed. A `true` decision means
    /// the callback allows closing; this helper does **not** perform the native
    /// platform's subsequent removal. Call [`Window::remove_window`] explicitly
    /// when testing teardown. A callback can itself remove the window, in which
    /// case this helper panics while trying to restore it. It also panics if
    /// called on an already closed window.
    ///
    /// See the [close-request test](crate::_documentation::testing#separate-a-close-decision-from-teardown)
    /// for checking a veto, an allowed request, and actual release separately.
    pub fn simulate_close(&mut self) -> bool {
        let handler = self
            .cx
            .update_window(self.window, |_, window, _| {
                window
                    .platform_window
                    .as_test()
                    .unwrap()
                    .0
                    .lock()
                    .should_close_handler
                    .take()
            })
            .unwrap();
        if let Some(mut handler) = handler {
            let should_close = handler();
            self.cx
                .update_window(self.window, |_, window, _| {
                    window.platform_window.on_should_close(handler);
                })
                .unwrap();
            should_close
        } else {
            false
        }
    }

    /// Retains this fixture until its app's next [`TestAppContext::quit`] call.
    ///
    /// This supports the borrowed fixtures returned by
    /// [`TestAppContext::add_window_view`] and [`TestAppContext::add_empty_window`].
    /// The returned reference is typed as `'static`, but the registered cleanup
    /// destroys the context when the test quits. Do not retain or use it beyond
    /// that boundary. Prefer keeping [`Self::from_window`]'s result by value.
    pub fn into_mut(self) -> &'static mut Self {
        let ptr = Box::into_raw(Box::new(self));
        // safety: on_quit will be called after the test has finished.
        // the executor will ensure that all tasks related to the test have stopped.
        // so there is no way for cx to be accessed after on_quit is called.
        // todo: This is unsound under stacked borrows (also tree borrows probably?)
        // the mutable reference invalidates `ptr` which is later used in the closure
        let cx = unsafe { &mut *ptr };
        cx.on_quit(move || unsafe {
            drop(Box::from_raw(ptr));
        });
        cx
    }
}

impl AppContext for VisualTestContext {
    fn new<T: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T> {
        self.window
            .update(&mut self.cx, |_, _, cx| cx.new(build_entity))
            .expect("window was unexpectedly closed")
    }

    fn reserve_entity<T: 'static>(&mut self) -> crate::Reservation<T> {
        self.cx.reserve_entity()
    }

    fn insert_entity<T: 'static>(
        &mut self,
        reservation: crate::Reservation<T>,
        build_entity: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T> {
        self.window
            .update(&mut self.cx, |_, _, cx| {
                cx.insert_entity(reservation, build_entity)
            })
            .expect("window was unexpectedly closed")
    }

    fn update_entity<T, R>(
        &mut self,
        handle: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R
    where
        T: 'static,
    {
        self.cx.update_entity(handle, update)
    }

    fn as_mut<'a, T>(&'a mut self, handle: &Entity<T>) -> super::GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        self.cx.as_mut(handle)
    }

    fn read_entity<T, R>(&self, handle: &Entity<T>, read: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static,
    {
        self.cx.read_entity(handle, read)
    }

    fn notify(&mut self, entity_id: EntityId) {
        self.cx.notify(entity_id)
    }

    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        self.cx.emit(entity, event)
    }

    fn update_window<T, F>(&mut self, window: AnyWindowHandle, f: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        self.cx.update_window(window, f)
    }

    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        self.cx.with_window(entity_id, f)
    }

    fn read_window<T, R>(
        &self,
        window: &WindowHandle<T>,
        read: impl FnOnce(Entity<T>, &App) -> R,
    ) -> Result<R>
    where
        T: 'static,
    {
        self.cx.read_window(window, read)
    }

    fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.cx.background_spawn(future)
    }

    fn read_global<G, R>(&self, callback: impl FnOnce(&G, &App) -> R) -> R
    where
        G: Global,
    {
        self.cx.read_global(callback)
    }

    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>) {
        self.cx.insert_global_entity(entity)
    }

    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>) {
        self.cx.remove_global_entity(entity)
    }

    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>> {
        self.cx.global_entities()
    }
}

impl VisualContext for VisualTestContext {
    type Result<T> = T;

    /// Returns the simulated window's identity without retaining its root view.
    fn window_handle(&self) -> AnyWindowHandle {
        self.window
    }

    fn new_window_entity<T: 'static>(
        &mut self,
        build_entity: impl FnOnce(&mut Window, &mut Context<T>) -> T,
    ) -> Entity<T> {
        self.window
            .update(&mut self.cx, |_, window, cx| {
                cx.new(|cx| build_entity(window, cx))
            })
            .expect("window was unexpectedly closed")
    }

    fn update_window_entity<V: 'static, R>(
        &mut self,
        view: &Entity<V>,
        update: impl FnOnce(&mut V, &mut Window, &mut Context<V>) -> R,
    ) -> R {
        let view = view.clone();
        self.cx
            .app
            .borrow_mut()
            .with_window(view.entity_id(), |window, app| {
                view.update(app, |v, cx| update(v, window, cx))
            })
            .expect("entity has no current window; use `update` instead of `update_in`")
    }

    fn replace_root_view<V>(
        &mut self,
        build_view: impl FnOnce(&mut Window, &mut Context<V>) -> V,
    ) -> Entity<V>
    where
        V: 'static + Render,
    {
        self.window
            .update(&mut self.cx, |_, window, cx| {
                window.replace_root(cx, build_view)
            })
            .expect("window was unexpectedly closed")
    }

    fn focus<V: crate::Focusable>(&mut self, view: &Entity<V>) {
        self.window
            .update(&mut self.cx, |_, window, cx| {
                view.read(cx).focus_handle(cx).focus(window, cx)
            })
            .expect("window was unexpectedly closed")
    }
}

impl AnyWindowHandle {
    /// Creates a view entity while this window is available to its constructor.
    ///
    /// This does not replace the root or mount the view in the element tree.
    /// Retain and render the returned entity to display it. The window must
    /// belong to `cx`'s app; this panics if it has closed. Use
    /// [`Window::replace_root`] when replacing the window's root is intended.
    pub fn build_entity<V: Render + 'static>(
        &self,
        cx: &mut TestAppContext,
        build_view: impl FnOnce(&mut Window, &mut Context<V>) -> V,
    ) -> Entity<V> {
        self.update(cx, |_, window, cx| cx.new(|cx| build_view(window, cx)))
            .unwrap()
    }
}

#[cfg(test)]
mod tests {
    use crate::{
        PathPromptOptions, SystemNotification, SystemNotificationAction,
        SystemNotificationResponse, TestAppContext,
    };
    use std::cell::RefCell;
    use std::path::PathBuf;
    use std::rc::Rc;

    #[gpui::test]
    async fn test_system_notifications_require_identity_and_replace_matching_tags(
        cx: &mut TestAppContext,
    ) {
        cx.update(|cx| {
            cx.show_system_notification(SystemNotification {
                tag: "thread-1".into(),
                title: "Task started".into(),
                body: "Running tests".into(),
                actions: Vec::new(),
            });
        });
        assert!(cx.shown_system_notifications().is_empty());
        assert!(cx.delivered_system_notifications().is_empty());

        cx.update(|cx| {
            cx.set_app_identity("com.example.tasks", "Tasks");
            cx.show_system_notification(SystemNotification {
                tag: "thread-1".into(),
                title: "Task started".into(),
                body: "Running tests".into(),
                actions: Vec::new(),
            });
            cx.show_system_notification(SystemNotification {
                tag: "thread-1".into(),
                title: "Task finished".into(),
                body: "All tests passed".into(),
                actions: vec![SystemNotificationAction {
                    id: "open".into(),
                    label: "Open".into(),
                }],
            });
        });

        assert_eq!(
            cx.app_identity(),
            Some(("com.example.tasks".into(), "Tasks".into()))
        );
        assert_eq!(cx.shown_system_notifications().len(), 2);
        assert_eq!(
            cx.delivered_system_notifications(),
            [SystemNotification {
                tag: "thread-1".into(),
                title: "Task finished".into(),
                body: "All tests passed".into(),
                actions: vec![SystemNotificationAction {
                    id: "open".into(),
                    label: "Open".into(),
                }],
            }]
        );

        cx.update(|cx| cx.dismiss_system_notification("thread-1"));
        assert!(cx.delivered_system_notifications().is_empty());
        assert_eq!(cx.dismissed_system_notifications(), ["thread-1"]);
    }

    #[gpui::test]
    async fn test_system_notification_body_and_action_responses(cx: &mut TestAppContext) {
        let responses = Rc::new(RefCell::new(Vec::new()));
        cx.update(|cx| {
            cx.on_system_notification_response({
                let responses = responses.clone();
                move |response, _cx| responses.borrow_mut().push(response)
            });
        });

        cx.simulate_system_notification_response(SystemNotificationResponse {
            tag: "thread-1".into(),
            action_id: None,
        });
        cx.simulate_system_notification_response(SystemNotificationResponse {
            tag: "thread-1".into(),
            action_id: Some("default".into()),
        });

        assert_eq!(
            responses.borrow().as_slice(),
            &[
                SystemNotificationResponse {
                    tag: "thread-1".into(),
                    action_id: None,
                },
                SystemNotificationResponse {
                    tag: "thread-1".into(),
                    action_id: Some("default".into()),
                },
            ]
        );
    }

    #[gpui::test]
    async fn test_system_notification_response_handler_can_be_replaced(cx: &mut TestAppContext) {
        let first_responses = Rc::new(RefCell::new(Vec::new()));
        let second_responses = Rc::new(RefCell::new(Vec::new()));
        cx.update(|cx| {
            cx.on_system_notification_response({
                let first_responses = first_responses.clone();
                move |response, _cx| first_responses.borrow_mut().push(response)
            });
            cx.on_system_notification_response({
                let second_responses = second_responses.clone();
                move |response, _cx| second_responses.borrow_mut().push(response)
            });
        });

        let response = SystemNotificationResponse {
            tag: "thread-1".into(),
            action_id: None,
        };
        cx.simulate_system_notification_response(response.clone());

        assert!(first_responses.borrow().is_empty());
        assert_eq!(second_responses.borrow().as_slice(), &[response]);
    }

    #[gpui::test]
    async fn test_system_notification_response_handler_can_reenter_app(cx: &mut TestAppContext) {
        cx.update(|cx| {
            cx.set_app_identity("com.example.tasks", "Tasks");
            cx.show_system_notification(SystemNotification {
                tag: "thread-1".into(),
                title: "Task finished".into(),
                body: "All tests passed".into(),
                actions: Vec::new(),
            });
            cx.on_system_notification_response(|response, cx| {
                cx.dismiss_system_notification(&response.tag);
            });
        });

        cx.simulate_system_notification_response(SystemNotificationResponse {
            tag: "thread-1".into(),
            action_id: None,
        });

        assert!(cx.delivered_system_notifications().is_empty());
        assert_eq!(cx.dismissed_system_notifications(), ["thread-1"]);
    }

    #[gpui::test]
    async fn test_simulate_path_prompt_response(cx: &mut TestAppContext) {
        assert!(!cx.did_prompt_for_paths());

        let receiver = cx.update(|cx| {
            cx.prompt_for_paths(PathPromptOptions {
                files: false,
                directories: true,
                multiple: true,
                prompt: None,
            })
        });
        assert!(cx.did_prompt_for_paths());

        let selected = vec![PathBuf::from("/a"), PathBuf::from("/b")];
        cx.simulate_path_prompt_response({
            let selected = selected.clone();
            move |options| {
                assert!(options.multiple);
                Some(selected)
            }
        });
        assert!(!cx.did_prompt_for_paths());

        let response = receiver.await.unwrap().unwrap();
        assert_eq!(response, Some(selected));
    }

    #[gpui::test]
    async fn test_simulate_path_prompt_cancellation(cx: &mut TestAppContext) {
        let receiver = cx.update(|cx| {
            cx.prompt_for_paths(PathPromptOptions {
                files: true,
                directories: false,
                multiple: false,
                prompt: None,
            })
        });

        cx.simulate_path_prompt_response(|_options| None);

        let response = receiver.await.unwrap().unwrap();
        assert_eq!(response, None);
    }
}
