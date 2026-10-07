//! # Deterministic application tests
//!
//! [`TestApp`] runs GPUI with a test platform and controllable schedulers. It
//! is useful for testing entities, views, input dispatch, and task completion
//! without creating a native window. [`TestApp::update`] and
//! [`TestAppWindow::update`] flush queued effects and run currently ready work
//! before returning; advancing time is a separate operation.
//!
//! ```
//! # use gpui::{AppContext, Context, Render, TestApp, Window, IntoElement, ParentElement, div};
//! # struct Counter { count: u32 }
//! # impl Render for Counter {
//! #   fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
//! #     div().child(self.count.to_string())
//! #   }
//! # }
//! let mut app = TestApp::new();
//! let mut window = app.open_window(|_, _| Counter { count: 0 });
//! window.update(|counter, _, cx| { counter.count += 1; cx.notify(); });
//! assert_eq!(window.read(|counter, _| counter.count), 1);
//! ```
//!
//! The harness remains single-threaded for foreground state. Use
//! [`TestApp::advance_clock`] to move time and run work due by that time;
//! `run_until_parked` does not invent elapsed time. Window inspection methods
//! panic if their window has already been closed, matching the test's invalid
//! handle rather than silently testing a different window.

use crate::{
    AnyWindowHandle, App, AppCell, AppContext, AssetRegistry, AsyncApp, BackgroundExecutor,
    BorrowAppContext, Bounds, ClipboardItem, Context, Entity, ForegroundExecutor, Global,
    InputEvent, Keystroke, MouseButton, MouseDownEvent, MouseMoveEvent, MouseUpEvent, Pixels,
    Platform, PlatformTextSystem, Point, Render, Size, Task, TestDispatcher, TestPlatform,
    TextSystem, Window, WindowBounds, WindowHandle, WindowOptions, app::GpuiMode,
};
use std::{future::Future, rc::Rc, sync::Arc, time::Duration};

/// A deterministic application and its simulated platform.
///
/// Unlike `TestAppContext`, `TestApp` automatically flushes effects after
/// each update and provides simpler window management.
pub struct TestApp {
    app: Rc<AppCell>,
    platform: Rc<TestPlatform>,
    background_executor: BackgroundExecutor,
    foreground_executor: ForegroundExecutor,
    #[allow(dead_code)]
    dispatcher: TestDispatcher,
    text_system: Arc<TextSystem>,
}

impl TestApp {
    /// Creates a test app with the default deterministic seed (`0`).
    pub fn new() -> Self {
        Self::with_seed(0)
    }

    /// Creates a test app whose scheduler randomization uses `seed`.
    pub fn with_seed(seed: u64) -> Self {
        Self::build(seed, None, Arc::new(()))
    }

    /// Creates a test app using a caller-provided text system for shaping.
    ///
    /// The text system is shared by the app and platform; callers own its
    /// fonts and lifetime through the supplied `Arc`.
    pub fn with_text_system(text_system: Arc<dyn PlatformTextSystem>) -> Self {
        Self::build(0, Some(text_system), Arc::new(()))
    }

    /// Creates a test app with custom text shaping and asset loading.
    pub fn with_text_system_and_assets(
        text_system: Arc<dyn PlatformTextSystem>,
        asset_source: Arc<dyn crate::AssetSource>,
    ) -> Self {
        Self::build(0, Some(text_system), asset_source)
    }

    fn build(
        seed: u64,
        platform_text_system: Option<Arc<dyn PlatformTextSystem>>,
        asset_source: Arc<dyn crate::AssetSource>,
    ) -> Self {
        let dispatcher = TestDispatcher::new(seed);
        let arc_dispatcher = Arc::new(dispatcher.clone());
        let background_executor = BackgroundExecutor::new(arc_dispatcher.clone());
        let foreground_executor = ForegroundExecutor::new(arc_dispatcher);
        let platform = match platform_text_system.clone() {
            Some(ts) => TestPlatform::with_text_system(
                background_executor.clone(),
                foreground_executor.clone(),
                ts,
            ),
            None => TestPlatform::new(background_executor.clone(), foreground_executor.clone()),
        };
        let http_client = crate::http_client::FakeHttpClient::with_404_response();
        let text_system = Arc::new(TextSystem::new(
            platform_text_system.unwrap_or_else(|| platform.text_system.clone()),
        ));

        let app = App::new_app(
            platform.clone(),
            AssetRegistry::from(asset_source).into(),
            http_client,
        );
        app.borrow_mut().mode = GpuiMode::test();

        Self {
            app,
            platform,
            background_executor,
            foreground_executor,
            dispatcher,
            text_system,
        }
    }

    /// Runs `f` with mutable app access, then drains ready work and effects.
    ///
    /// This does not advance the simulated clock. A callback that recursively
    /// borrows the app still panics like production app updates.
    pub fn update<R>(&mut self, f: impl FnOnce(&mut App) -> R) -> R {
        let result = {
            let mut app = self.app.borrow_mut();
            app.update(f)
        };
        self.run_until_parked();
        result
    }

    /// Runs `f` with a read-only app borrow.
    pub fn read<R>(&self, f: impl FnOnce(&App) -> R) -> R {
        let app = self.app.borrow();
        f(&app)
    }

    /// Creates a new entity in this test application.
    ///
    /// This test-only spelling forwards to [`AppContext::new`]. Production code
    /// normally receives an [`App`] or [`Context`] and calls `cx.new` directly.
    pub fn new_entity<T: 'static>(
        &mut self,
        build: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T> {
        self.update(|cx| cx.new(build))
    }

    /// Updates an entity and runs the test app's pending effects.
    pub fn update_entity<T: 'static, R>(
        &mut self,
        entity: &Entity<T>,
        f: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R {
        self.update(|cx| entity.update(cx, f))
    }

    /// Reads an entity for the duration of `f`.
    pub fn read_entity<T: 'static, R>(
        &self,
        entity: &Entity<T>,
        f: impl FnOnce(&T, &App) -> R,
    ) -> R {
        self.read(|cx| f(entity.read(cx), cx))
    }

    /// Opens a test window with maximized test-platform bounds.
    ///
    /// The closure constructs the root view once. The returned window owns a
    /// typed handle for inspection and input simulation.
    pub fn open_window<V: Render + 'static>(
        &mut self,
        build_view: impl FnOnce(&mut Window, &mut Context<V>) -> V,
    ) -> TestAppWindow<V> {
        let bounds = self.read(|cx| Bounds::maximized(None, cx));
        let handle = self.update(|cx| {
            cx.open_window(
                WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds))),
                |window, cx| cx.new(|cx| build_view(window, cx)),
            )
            .unwrap()
        });

        TestAppWindow {
            handle,
            app: self.app.clone(),
            platform: self.platform.clone(),
            background_executor: self.background_executor.clone(),
        }
    }

    /// Opens a test window using explicit [`WindowOptions`].
    pub fn open_window_with_options<V: Render + 'static>(
        &mut self,
        options: WindowOptions,
        build_view: impl FnOnce(&mut Window, &mut Context<V>) -> V,
    ) -> TestAppWindow<V> {
        let handle = self.update(|cx| {
            cx.open_window(options, |window, cx| cx.new(|cx| build_view(window, cx)))
                .unwrap()
        });

        TestAppWindow {
            handle,
            app: self.app.clone(),
            platform: self.platform.clone(),
            background_executor: self.background_executor.clone(),
        }
    }

    /// Runs ready foreground and background tasks until the scheduler parks.
    ///
    /// Pending timers remain pending until [`Self::advance_clock`] makes them
    /// ready. A task dropped before this call is cancelled and is not observed.
    pub fn run_until_parked(&self) {
        self.background_executor.run_until_parked();
    }

    /// Advances the test clock and runs work due by the new time.
    ///
    /// The scheduler drains runnable work while crossing timers due within
    /// `duration`, then leaves the clock at the requested destination. This
    /// does not model production wall-clock scheduling or latency.
    pub fn advance_clock(&self, duration: Duration) {
        self.background_executor.advance_clock(duration);
    }

    /// Spawns a local future on the foreground executor.
    pub fn spawn<Fut, R>(&self, f: impl FnOnce(AsyncApp) -> Fut) -> Task<R>
    where
        Fut: Future<Output = R> + 'static,
        R: 'static,
    {
        self.foreground_executor.spawn(f(self.to_async()))
    }

    /// Spawns a `Send` future on the background executor.
    pub fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.background_executor.spawn(future)
    }

    /// Returns a weak async app handle for work across `await` points.
    pub fn to_async(&self) -> AsyncApp {
        AsyncApp {
            app: Rc::downgrade(&self.app),
            background_executor: self.background_executor.clone(),
            foreground_executor: self.foreground_executor.clone(),
        }
    }

    /// Returns the app's deterministic background executor.
    pub fn background_executor(&self) -> &BackgroundExecutor {
        &self.background_executor
    }

    /// Returns the app's deterministic foreground executor.
    pub fn foreground_executor(&self) -> &ForegroundExecutor {
        &self.foreground_executor
    }

    /// Returns the text system used by this test app.
    pub fn text_system(&self) -> &Arc<TextSystem> {
        &self.text_system
    }

    /// Returns whether a global of type `G` is installed.
    pub fn has_global<G: Global>(&self) -> bool {
        self.read(|cx| cx.has_global::<G>())
    }

    /// Installs or replaces a global value and flushes effects.
    pub fn set_global<G: Global>(&mut self, global: G) {
        self.update(|cx| cx.set_global(global));
    }

    /// Reads an installed global. Panics when `G` is absent.
    pub fn read_global<G: Global, R>(&self, f: impl FnOnce(&G, &App) -> R) -> R {
        self.read(|cx| f(cx.global(), cx))
    }

    /// Update a global value.
    pub fn update_global<G: Global, R>(&mut self, f: impl FnOnce(&mut G, &mut App) -> R) -> R {
        self.update(|cx| cx.update_global(f))
    }

    // Platform simulation methods

    /// Write text to the simulated clipboard.
    pub fn write_to_clipboard(&self, item: ClipboardItem) {
        self.platform.write_to_clipboard(item);
    }

    /// Read from the simulated clipboard.
    pub fn read_from_clipboard(&self) -> Option<ClipboardItem> {
        self.platform.read_from_clipboard()
    }

    /// Returns the most recent URL opened through `App::open_url`.
    pub fn opened_url(&self) -> Option<String> {
        self.platform.opened_url.borrow().clone()
    }

    /// Returns whether a new-path prompt is pending.
    pub fn did_prompt_for_new_path(&self) -> bool {
        self.platform.did_prompt_for_new_path()
    }

    /// Answers the pending new-path prompt with a test selection callback.
    pub fn simulate_new_path_selection(
        &self,
        select: impl FnOnce(&std::path::Path) -> Option<std::path::PathBuf>,
    ) {
        self.platform.simulate_new_path_selection(select);
    }

    /// Returns whether a platform prompt is pending.
    pub fn has_pending_prompt(&self) -> bool {
        self.platform.has_pending_prompt()
    }

    /// Answers the pending prompt by button label.
    pub fn simulate_prompt_answer(&self, button: &str) {
        self.platform.simulate_prompt_answer(button);
    }

    /// Returns handles for all currently open test windows.
    pub fn windows(&self) -> Vec<AnyWindowHandle> {
        self.read(|cx| cx.windows())
    }
}

impl Default for TestApp {
    fn default() -> Self {
        Self::new()
    }
}

/// A typed test handle for one open window and its root view.
pub struct TestAppWindow<V> {
    handle: WindowHandle<V>,
    app: Rc<AppCell>,
    platform: Rc<TestPlatform>,
    background_executor: BackgroundExecutor,
}

impl<V: 'static + Render> TestAppWindow<V> {
    /// Returns the typed window handle.
    pub fn handle(&self) -> WindowHandle<V> {
        self.handle
    }

    /// Returns the root view entity.
    ///
    /// Panics if the window was closed or its root has a different type.
    pub fn root(&self) -> Entity<V> {
        let mut app = self.app.borrow_mut();
        let any_handle: AnyWindowHandle = self.handle.into();
        app.update_window(any_handle, |root_view, _, _| {
            root_view.downcast::<V>().expect("root view type mismatch")
        })
        .expect("window not found")
    }

    /// Updates the root view, then drains ready tasks and effects.
    ///
    /// Panics if the window is closed or the root type does not match `V`.
    pub fn update<R>(&mut self, f: impl FnOnce(&mut V, &mut Window, &mut Context<V>) -> R) -> R {
        let result = {
            let mut app = self.app.borrow_mut();
            let any_handle: AnyWindowHandle = self.handle.into();
            app.update_window(any_handle, |root_view, window, cx| {
                let view = root_view.downcast::<V>().expect("root view type mismatch");
                view.update(cx, |view, cx| f(view, window, cx))
            })
            .expect("window not found")
        };
        self.background_executor.run_until_parked();
        result
    }

    /// Reads the root view without flushing effects.
    ///
    /// Panics if the window or root view is unavailable.
    pub fn read<R>(&self, f: impl FnOnce(&V, &App) -> R) -> R {
        let app = self.app.borrow();
        let view = self
            .app
            .borrow()
            .windows
            .get(self.handle.window_id())
            .and_then(|w| w.as_ref())
            .and_then(|w| w.root.clone())
            .and_then(|r| r.downcast::<V>().ok())
            .expect("window or root view not found");
        f(view.read(&app), &app)
    }

    /// Returns the test platform's window title, when exposed.
    ///
    /// The current test platform does not expose a title through this API and
    /// therefore returns `None` for an open window.
    pub fn title(&self) -> Option<String> {
        let app = self.app.borrow();
        app.read_window(&self.handle, |_, _cx| {
            // TODO: expose title through Window API
            None
        })
        .unwrap()
    }

    /// Parses and dispatches one keystroke, then drains ready work.
    ///
    /// Panics when `keystroke` cannot be parsed or the window is closed.
    pub fn simulate_keystroke(&mut self, keystroke: &str) {
        let keystroke = Keystroke::parse(keystroke).unwrap();
        {
            let mut app = self.app.borrow_mut();
            let any_handle: AnyWindowHandle = self.handle.into();
            app.update_window(any_handle, |_, window, cx| {
                window.dispatch_keystroke(keystroke, cx);
            })
            .unwrap();
        }
        self.background_executor.run_until_parked();
    }

    /// Dispatches space-separated keystrokes in order.
    pub fn simulate_keystrokes(&mut self, keystrokes: &str) {
        for keystroke in keystrokes.split(' ') {
            self.simulate_keystroke(keystroke);
        }
    }

    /// Dispatches one keystroke for each Unicode scalar in `input`.
    pub fn simulate_input(&mut self, input: &str) {
        for char in input.chars() {
            self.simulate_keystroke(&char.to_string());
        }
    }

    /// Dispatches a mouse-move event at `position`.
    pub fn simulate_mouse_move(&mut self, position: Point<Pixels>) {
        self.simulate_event(MouseMoveEvent {
            position,
            modifiers: Default::default(),
            pressed_button: None,
        });
    }

    /// Dispatches a single left/right/etc. mouse-down event.
    pub fn simulate_mouse_down(&mut self, position: Point<Pixels>, button: MouseButton) {
        self.simulate_event(MouseDownEvent {
            position,
            button,
            modifiers: Default::default(),
            click_count: 1,
            first_mouse: false,
        });
    }

    /// Dispatches a single mouse-up event.
    pub fn simulate_mouse_up(&mut self, position: Point<Pixels>, button: MouseButton) {
        self.simulate_event(MouseUpEvent {
            position,
            button,
            modifiers: Default::default(),
            click_count: 1,
        });
    }

    /// Dispatches a mouse-down followed by a mouse-up at `position`.
    pub fn simulate_click(&mut self, position: Point<Pixels>, button: MouseButton) {
        self.simulate_mouse_down(position, button);
        self.simulate_mouse_up(position, button);
    }

    /// Dispatches a pixel scroll event at `position`.
    pub fn simulate_scroll(&mut self, position: Point<Pixels>, delta: Point<Pixels>) {
        self.simulate_event(crate::ScrollWheelEvent {
            position,
            delta: crate::ScrollDelta::Pixels(delta),
            modifiers: Default::default(),
            touch_phase: crate::TouchPhase::Moved,
        });
    }

    /// Converts and dispatches a platform input event, then drains ready work.
    pub fn simulate_event<E: InputEvent>(&mut self, event: E) {
        let platform_input = event.to_platform_input();
        {
            let mut app = self.app.borrow_mut();
            let any_handle: AnyWindowHandle = self.handle.into();
            app.update_window(any_handle, |_, window, cx| {
                window.dispatch_event(platform_input, cx);
            })
            .unwrap();
        }
        self.background_executor.run_until_parked();
    }

    /// Resizes the simulated platform window and drains ready work.
    pub fn simulate_resize(&mut self, size: Size<Pixels>) {
        let window_id = self.handle.window_id();
        let mut app = self.app.borrow_mut();
        if let Some(Some(window)) = app.windows.get_mut(window_id) {
            if let Some(test_window) = window.platform_window.as_test() {
                test_window.simulate_resize(size);
            }
        }
        drop(app);
        self.background_executor.run_until_parked();
    }

    /// Draws and clears the window immediately.
    ///
    /// Use this when a test needs layout/paint state before simulating pointer
    /// input. It does not advance timers.
    pub fn draw(&mut self) {
        let mut app = self.app.borrow_mut();
        let any_handle: AnyWindowHandle = self.handle.into();
        app.update_window(any_handle, |_, window, cx| {
            window.draw(cx).clear(cx);
        })
        .unwrap();
    }
}

impl<V> Clone for TestAppWindow<V> {
    fn clone(&self) -> Self {
        Self {
            handle: self.handle,
            app: self.app.clone(),
            platform: self.platform.clone(),
            background_executor: self.background_executor.clone(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{FocusHandle, Focusable, div, prelude::*};

    struct Counter {
        count: usize,
        focus_handle: FocusHandle,
    }

    impl Counter {
        fn new(_window: &mut Window, cx: &mut Context<Self>) -> Self {
            let focus_handle = cx.focus_handle();
            Self {
                count: 0,
                focus_handle,
            }
        }

        fn increment(&mut self, _cx: &mut Context<Self>) {
            self.count += 1;
        }
    }

    impl Focusable for Counter {
        fn focus_handle(&self, _cx: &App) -> FocusHandle {
            self.focus_handle.clone()
        }
    }

    impl Render for Counter {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            div().child(format!("Count: {}", self.count))
        }
    }

    #[test]
    fn test_basic_usage() {
        let mut app = TestApp::new();

        let mut window = app.open_window(Counter::new);

        window.update(|counter, _window, cx| {
            counter.increment(cx);
        });

        window.read(|counter, _| {
            assert_eq!(counter.count, 1);
        });

        drop(window);
        app.update(|cx| cx.shutdown());
    }

    #[test]
    fn test_entity_creation() {
        let mut app = TestApp::new();

        let entity = app.new_entity(|cx| Counter {
            count: 42,
            focus_handle: cx.focus_handle(),
        });

        app.read_entity(&entity, |counter, _| {
            assert_eq!(counter.count, 42);
        });

        app.update_entity(&entity, |counter, _cx| {
            counter.count += 1;
        });

        app.read_entity(&entity, |counter, _| {
            assert_eq!(counter.count, 43);
        });
    }

    #[test]
    fn test_globals() {
        let mut app = TestApp::new();

        struct MyGlobal(String);
        impl Global for MyGlobal {}

        assert!(!app.has_global::<MyGlobal>());

        app.set_global(MyGlobal("hello".into()));

        assert!(app.has_global::<MyGlobal>());

        app.read_global::<MyGlobal, _>(|global, _| {
            assert_eq!(global.0, "hello");
        });

        app.update_global::<MyGlobal, _>(|global, _| {
            global.0 = "world".into();
        });

        app.read_global::<MyGlobal, _>(|global, _| {
            assert_eq!(global.0, "world");
        });
    }
}
