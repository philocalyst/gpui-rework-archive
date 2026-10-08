use crate::{
    Action, AnyView, AnyWindowHandle, App, AppCell, AppContext, AssetSource, BackgroundExecutor,
    Bounds, ClipboardItem, Context, Entity, EntityId, EventEmitter, ForegroundExecutor, Global,
    InputEvent, Keystroke, Modifiers, MouseButton, MouseDownEvent, MouseMoveEvent, MouseUpEvent,
    Pixels, Platform, Point, Render, Result, Size, Task, TestDispatcher, TextSystem,
    VisualTestPlatform, Window, WindowBounds, WindowHandle, WindowOptions, app::GpuiMode,
};
use anyhow::anyhow;
use image::RgbaImage;
use std::{future::Future, rc::Rc, sync::Arc, time::Duration};

/// A macOS visual-test app with caller-supplied platform rendering and seeded tasks.
///
/// [`VisualTestPlatform`] delegates window creation and text to the supplied
/// platform, while GPUI tasks use a controlled scheduler. Off-screen windows
/// can be captured through their renderer. This differs from
/// [`TestAppContext`](crate::TestAppContext), which uses a simulated window
/// and text system.
///
/// [`Self::advance_clock`] controls scheduled GPUI timers; it does not control
/// OS callbacks, GPU completion, or `web_time::Instant`. Set the viewport,
/// fonts, density, and motion policy deliberately for reproducible captures.
#[derive(Clone)]
pub struct VisualTestAppContext {
    /// The underlying app cell
    pub app: Rc<AppCell>,
    /// The background executor for running async tasks
    pub background_executor: BackgroundExecutor,
    /// The foreground executor for running tasks on the main thread
    pub foreground_executor: ForegroundExecutor,
    /// The test dispatcher for deterministic task scheduling
    dispatcher: TestDispatcher,
    platform: Rc<dyn Platform>,
    text_system: Arc<TextSystem>,
}

impl VisualTestAppContext {
    /// Wraps `platform` with controlled task scheduling and an empty asset source.
    ///
    /// Windows and text shaping come from the supplied platform. The `SEED`
    /// environment variable selects the scheduler seed; a missing or invalid
    /// value uses zero. HTTP requests use the test client's default 404 response.
    /// Use [`Self::with_asset_source`] when the view needs bundled resources,
    /// including SVG icons.
    pub fn new(platform: Rc<dyn Platform>) -> Self {
        Self::with_asset_source(platform, Arc::new(()))
    }

    /// Creates a new `VisualTestAppContext` with a custom asset source.
    ///
    /// Use this when you need SVG icons to render properly in visual tests.
    /// Pass the real `Assets` struct to enable icon rendering.
    pub fn with_asset_source(
        platform: Rc<dyn Platform>,
        asset_source: Arc<dyn AssetSource>,
    ) -> Self {
        // Use a seeded RNG for deterministic behavior
        let seed = std::env::var("SEED")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(0);

        // Create a visual test platform that combines real Mac rendering
        // with controllable TestDispatcher for deterministic task scheduling
        let platform = Rc::new(VisualTestPlatform::new(platform, seed));

        // Get the dispatcher and executors from the platform
        let dispatcher = platform.dispatcher().clone();
        let background_executor = platform.background_executor();
        let foreground_executor = platform.foreground_executor();

        let text_system = Arc::new(TextSystem::new(platform.text_system()));

        let http_client = crate::http_client::FakeHttpClient::with_404_response();

        let mut app = App::new_app(
            platform.clone(),
            gpui::AssetRegistry::from(asset_source).into(),
            http_client,
        );
        app.borrow_mut().mode = GpuiMode::test();

        Self {
            app,
            background_executor,
            foreground_executor,
            dispatcher,
            platform,
            text_system,
        }
    }

    /// Request a window of `size` at logical position `(-10000, -10000)`.
    ///
    /// The window is shown but initially unfocused; the requested origin puts
    /// it outside a usual desktop. Placement still belongs to the supplied
    /// platform. [`Self::capture_screenshot`] reads the renderer's texture and
    /// does not require an on-screen capture session.
    pub fn open_offscreen_window<V: Render + 'static>(
        &mut self,
        size: Size<Pixels>,
        build_root: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> Result<WindowHandle<V>> {
        use crate::{point, px};

        let bounds = Bounds {
            origin: point(px(-10000.0), px(-10000.0)),
            size,
        };

        let mut cx = self.app.borrow_mut();
        cx.open_window(
            WindowOptions::new()
                .window_bounds(Some(WindowBounds::Windowed(bounds)))
                .focus(false)
                .show(true),
            build_root,
        )
    }

    /// Opens an off-screen window with default size (1280x800).
    pub fn open_offscreen_window_default<V: Render + 'static>(
        &mut self,
        build_root: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> Result<WindowHandle<V>> {
        use crate::{px, size};
        self.open_offscreen_window(size(px(1280.0), px(800.0)), build_root)
    }

    /// Returns whether screen capture is supported on this platform.
    pub fn is_screen_capture_supported(&self) -> bool {
        self.platform.is_screen_capture_supported()
    }

    /// Returns the text system used by this context.
    pub fn text_system(&self) -> &Arc<TextSystem> {
        &self.text_system
    }

    /// Returns the background executor.
    pub fn executor(&self) -> BackgroundExecutor {
        self.background_executor.clone()
    }

    /// Returns the foreground executor.
    pub fn foreground_executor(&self) -> ForegroundExecutor {
        self.foreground_executor.clone()
    }

    /// Runs ready foreground and background work until no runnable tasks remain.
    ///
    /// Pending timers do not advance automatically. [`Self::advance_clock`]
    /// advances time and runs work due in that interval.
    pub fn run_until_parked(&self) {
        self.dispatcher.run_until_parked();
    }

    /// Advances the simulated clock and runs work due by the new time.
    ///
    /// The shared test scheduler drains runnable work while crossing timers
    /// due within `duration`, then leaves the clock at the requested
    /// destination. It does not model production wall-clock scheduling or
    /// latency.
    pub fn advance_clock(&self, duration: Duration) {
        self.dispatcher.advance_clock(duration);
    }

    /// Borrow the app for a synchronous operation without draining tasks.
    ///
    /// Calls the closure directly without flushing app effects. Use
    /// [`Self::update_window`] for window work that queues effects.
    pub fn update<R>(&mut self, f: impl FnOnce(&mut App) -> R) -> R {
        let mut app = self.app.borrow_mut();
        f(&mut app)
    }

    /// Reads from the app state.
    pub fn read<R>(&self, f: impl FnOnce(&App) -> R) -> R {
        let app = self.app.borrow();
        f(&app)
    }

    /// Updates a window.
    pub fn update_window<T, F>(&mut self, window: AnyWindowHandle, f: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        let mut lock = self.app.borrow_mut();
        lock.update_window(window, f)
    }

    /// Spawns a task on the foreground executor.
    pub fn spawn<F, R>(&self, f: F) -> Task<R>
    where
        F: Future<Output = R> + 'static,
        R: 'static,
    {
        self.foreground_executor.spawn(f)
    }

    /// Checks if a global of type G exists.
    pub fn has_global<G: Global>(&self) -> bool {
        let app = self.app.borrow();
        app.has_global::<G>()
    }

    /// Reads a global value.
    pub fn read_global<G: Global, R>(&self, f: impl FnOnce(&G, &App) -> R) -> R {
        let app = self.app.borrow();
        f(app.global::<G>(), &app)
    }

    /// Sets a global value.
    pub fn set_global<G: Global>(&mut self, global: G) {
        let mut app = self.app.borrow_mut();
        app.set_global(global);
    }

    /// Updates a global value.
    pub fn update_global<G: Global, R>(&mut self, f: impl FnOnce(&mut G, &mut App) -> R) -> R {
        let mut lock = self.app.borrow_mut();
        lock.update(|cx| {
            let mut global = cx.lease_global::<G>();
            let result = f(&mut global, cx);
            cx.end_global_lease(global);
            result
        })
    }

    /// Simulate whitespace-separated key presses, then drain ready tasks.
    ///
    /// Uses [`Keystroke::parse`] and [`Window::dispatch_keystroke`]. No key
    /// releases are sent. Panics on invalid syntax; a closed window is ignored.
    pub fn simulate_keystrokes(&mut self, window: AnyWindowHandle, keystrokes: &str) {
        for keystroke_text in keystrokes.split_whitespace() {
            let keystroke = Keystroke::parse(keystroke_text)
                .unwrap_or_else(|_| panic!("Invalid keystroke: {}", keystroke_text));
            self.dispatch_keystroke(window, keystroke);
        }
        self.run_until_parked();
    }

    /// Dispatch a key press and simulated committed text without draining tasks.
    ///
    /// A closed window is ignored. Use [`Self::simulate_event`] to send a
    /// matching [`crate::KeyUpEvent`] when testing press/release activation.
    pub fn dispatch_keystroke(&mut self, window: AnyWindowHandle, keystroke: Keystroke) {
        self.update_window(window, |_, window, cx| {
            window.dispatch_keystroke(keystroke, cx);
        })
        .ok();
    }

    /// Dispatch one key press and committed string per Unicode scalar.
    ///
    /// Drains ready tasks afterward. This does not reproduce native IME
    /// composition, and a closed window is ignored.
    pub fn simulate_input(&mut self, window: AnyWindowHandle, input: &str) {
        for char in input.chars() {
            let key = char.to_string();
            let keystroke = Keystroke {
                modifiers: Modifiers::default(),
                key: key.clone(),
                key_char: Some(key),
            };
            self.dispatch_keystroke(window, keystroke);
        }
        self.run_until_parked();
    }

    /// Simulates a mouse move event.
    pub fn simulate_mouse_move(
        &mut self,
        window: AnyWindowHandle,
        position: Point<Pixels>,
        button: impl Into<Option<MouseButton>>,
        modifiers: Modifiers,
    ) {
        self.simulate_event(
            window,
            MouseMoveEvent {
                position,
                modifiers,
                pressed_button: button.into(),
            },
        );
    }

    /// Simulates a mouse down event.
    pub fn simulate_mouse_down(
        &mut self,
        window: AnyWindowHandle,
        position: Point<Pixels>,
        button: MouseButton,
        modifiers: Modifiers,
    ) {
        self.simulate_event(
            window,
            MouseDownEvent {
                position,
                modifiers,
                button,
                click_count: 1,
                first_mouse: false,
            },
        );
    }

    /// Simulates a mouse up event.
    pub fn simulate_mouse_up(
        &mut self,
        window: AnyWindowHandle,
        position: Point<Pixels>,
        button: MouseButton,
        modifiers: Modifiers,
    ) {
        self.simulate_event(
            window,
            MouseUpEvent {
                position,
                modifiers,
                button,
                click_count: 1,
            },
        );
    }

    /// Simulates a click (mouse down followed by mouse up).
    pub fn simulate_click(
        &mut self,
        window: AnyWindowHandle,
        position: Point<Pixels>,
        modifiers: Modifiers,
    ) {
        self.simulate_mouse_down(window, position, MouseButton::Left, modifiers);
        self.simulate_mouse_up(window, position, MouseButton::Left, modifiers);
    }

    /// Dispatch platform input through GPUI and drain ready tasks.
    ///
    /// Uses the last drawn frame's listeners and normal dispatch rules. A
    /// closed window is ignored. It does not send input through native OS APIs.
    pub fn simulate_event<E: InputEvent>(&mut self, window: AnyWindowHandle, event: E) {
        self.update_window(window, |_, window, cx| {
            window.dispatch_event(event.to_platform_input(), cx);
        })
        .ok();
        self.run_until_parked();
    }

    /// Dispatch an action on the focus path, then drain ready tasks.
    ///
    /// This bypasses key matching; a closed window is ignored.
    pub fn dispatch_action(&mut self, window: AnyWindowHandle, action: impl Action) {
        self.update_window(window, |_, window, cx| {
            window.dispatch_action(action.boxed_clone(), cx);
        })
        .ok();
        self.run_until_parked();
    }

    /// Write to this visual test platform's in-memory clipboard.
    ///
    /// This does not write the native platform clipboard or test its permissions.
    pub fn write_to_clipboard(&self, item: ClipboardItem) {
        self.platform.write_to_clipboard(item);
    }

    /// Read this visual test platform's in-memory clipboard.
    pub fn read_from_clipboard(&self) -> Option<ClipboardItem> {
        self.platform.read_from_clipboard()
    }

    /// Poll an entity predicate with a wall-clock timeout and test-clock delays.
    ///
    /// Checks the predicate, checks elapsed `web_time::Instant`, drains ready
    /// work, then awaits a ten-millisecond scheduler timer before repeating.
    /// A caller must drive test time for that timer to wake. Advancing test
    /// time alone does not advance the wall-clock timeout. Returns an error
    /// on timeout; panics if the entity is unavailable.
    pub async fn wait_for<T: 'static>(
        &mut self,
        entity: &Entity<T>,
        predicate: impl Fn(&T) -> bool,
        timeout: Duration,
    ) -> Result<()> {
        let start = web_time::Instant::now();
        loop {
            {
                let app = self.app.borrow();
                if predicate(entity.read(&app)) {
                    return Ok(());
                }
            }

            if start.elapsed() > timeout {
                return Err(anyhow!("Timed out waiting for condition"));
            }

            self.run_until_parked();
            self.background_executor
                .timer(Duration::from_millis(10))
                .await;
        }
    }

    /// Reads the last built scene through the supplied platform's pixel renderer.
    ///
    /// This does not draw a new frame or wait for animation completion. Build
    /// the intended frame with [`Window::draw`] and clear its arena token before
    /// capturing. The window need not be on screen: this reads the renderer's
    /// texture rather than capturing the desktop.
    ///
    /// Returns an error for a closed window or failed renderer readback. Image
    /// dimensions are in device pixels. See [`Window::render_to_image`].
    #[cfg(any(test, feature = "headless"))]
    pub fn capture_screenshot(&mut self, window: AnyWindowHandle) -> Result<RgbaImage> {
        self.update_window(window, |_, window, _cx| window.render_to_image())?
    }

    /// Await 32 milliseconds of scheduler time, then drain ready tasks.
    ///
    /// Despite the name, this does not inspect animation state or guarantee
    /// completion. Longer and repeating animations can remain active, and
    /// frame callbacks are separate from timers. Prefer advancing the clock
    /// to a specific sample and drawing before a screenshot assertion.
    pub async fn wait_for_animations(&self) {
        self.background_executor
            .timer(Duration::from_millis(32))
            .await;
        self.run_until_parked();
    }
}

impl AppContext for VisualTestAppContext {
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

    fn as_mut<'a, T>(&'a mut self, _: &Entity<T>) -> crate::GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        panic!("Cannot use as_mut with a visual test app context. Try calling update() first")
    }

    fn read_entity<T, R>(&self, handle: &Entity<T>, read: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static,
    {
        let app = self.app.borrow();
        app.read_entity(handle, read)
    }

    fn notify(&mut self, entity_id: EntityId) {
        let mut app = self.app.borrow_mut();
        app.notify(entity_id)
    }

    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        let mut app = self.app.borrow_mut();
        app.emit(entity, event)
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
        callback(app.global::<G>(), &app)
    }

    fn insert_global_entity<E: 'static>(&mut self, entity: Entity<E>) {
        let mut app = self.app.borrow_mut();
        app.insert_global_entity(entity)
    }

    fn remove_global_entity<E: 'static>(&mut self, entity: &Entity<E>) {
        let mut app = self.app.borrow_mut();
        app.remove_global_entity(entity)
    }

    fn global_entities<E: 'static>(&self) -> impl Iterator<Item = Entity<E>> {
        let app = self.app.borrow();
        let iter = app.global_entities();
        // Cloning the iterator here so that lock can be released when function is going out of scope
        iter.collect::<Vec<_>>().into_iter()
    }
}
