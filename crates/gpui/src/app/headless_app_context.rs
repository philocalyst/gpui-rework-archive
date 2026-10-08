//! Run GPUI without opening a native window.
//!
//! Supply a [`PlatformTextSystem`] for shaping and glyph rasterization. The
//! context uses the regular entity, element, layout, and scene implementations,
//! with [`TestPlatform`] providing a clock and event delivery that the caller
//! controls. An optional renderer enables pixel screenshots; scene capture
//! works without one.

use crate::{
    AnyView, AnyWindowHandle, App, AppCell, AppContext, AssetRegistry, AssetSource,
    BackgroundExecutor, Bounds, Context, Entity, EntityId, EventEmitter, ForegroundExecutor,
    Global, Hsla, Pixels, PlatformHeadlessRenderer, PlatformTextSystem, Render, Reservation,
    ScaledPixels, Size, Task, TestDispatcher, TestPlatform, TextSystem, Window, WindowBounds,
    WindowHandle, WindowOptions,
    app::{GpuiBorrow, GpuiMode},
};
use anyhow::Result;
use image::RgbaImage;
use std::{future::Future, rc::Rc, sync::Arc, time::Duration};

/// An app whose windows, clock, and frame delivery are driven by the caller.
///
/// Use this for a headless test or an external execution host, such as the
/// documentation's Miri workbench. Supply a text system with the fonts needed
/// by the component. [`new`](Self::new) records scenes without a pixel renderer;
/// [`with_platform`](Self::with_platform) can also supply a screenshot renderer.
///
/// By default, flushing app effects draws dirty windows. A host with its own
/// frame loop can disable that behavior with [`set_automatic_drawing`](Self::set_automatic_drawing),
/// then deliver input and draw once at its chosen frame boundary. Advancing
/// the clock and delivering frame callbacks are separate operations.
///
/// ```
/// use gpui::{HeadlessAppContext, PlatformTextSystem};
/// use std::sync::Arc;
///
/// fn frame_driver(text: Arc<dyn PlatformTextSystem>) -> HeadlessAppContext {
///     let mut cx = HeadlessAppContext::new(text);
///     cx.set_automatic_drawing(false);
///     cx
/// }
/// ```
pub struct HeadlessAppContext {
    /// The underlying app cell.
    pub app: Rc<AppCell>,
    /// The background executor for running async tasks.
    pub background_executor: BackgroundExecutor,
    /// The foreground executor for running tasks on the main thread.
    pub foreground_executor: ForegroundExecutor,
    dispatcher: TestDispatcher,
    platform: Rc<TestPlatform>,
    text_system: Arc<TextSystem>,
}

impl HeadlessAppContext {
    /// Create a simulated app with `platform_text_system` and no pixel renderer.
    ///
    /// Scenes still record layout and drawing. The asset source is empty and
    /// the fake HTTP client returns 404. Scheduler seed comes from `SEED`,
    /// falling back to zero when absent or invalid.
    pub fn new(platform_text_system: Arc<dyn PlatformTextSystem>) -> Self {
        Self::with_platform(platform_text_system, Arc::new(()), || None)
    }

    /// Creates a new headless app context with a custom text system and asset source.
    pub fn with_asset_source(
        platform_text_system: Arc<dyn PlatformTextSystem>,
        asset_source: Arc<dyn AssetSource>,
    ) -> Self {
        Self::with_platform(platform_text_system, asset_source, || None)
    }

    /// Create a simulated app with custom text, assets, and a renderer factory.
    ///
    /// The factory runs for each opened window. Return `Some` to supply that
    /// window's atlas and pixel rendering; `None` keeps scene recording alone.
    /// This does not start a native event loop. Drive time, input, frame
    /// callbacks, and drawing through this context's methods.
    pub fn with_platform(
        platform_text_system: Arc<dyn PlatformTextSystem>,
        asset_source: Arc<dyn AssetSource>,
        renderer_factory: impl Fn() -> Option<Box<dyn PlatformHeadlessRenderer>> + 'static,
    ) -> Self {
        let seed = std::env::var("SEED")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(0);

        let dispatcher = TestDispatcher::new(seed);
        let arc_dispatcher = Arc::new(dispatcher.clone());
        let background_executor = BackgroundExecutor::new(arc_dispatcher.clone());
        let foreground_executor = ForegroundExecutor::new(arc_dispatcher);

        let renderer_factory: Box<dyn Fn() -> Option<Box<dyn PlatformHeadlessRenderer>>> =
            Box::new(renderer_factory);
        let platform = TestPlatform::with_platform(
            background_executor.clone(),
            foreground_executor.clone(),
            platform_text_system.clone(),
            Some(renderer_factory),
        );

        let text_system = Arc::new(TextSystem::new(platform_text_system));
        let http_client = crate::http_client::FakeHttpClient::with_404_response();
        let app = App::new_app(
            platform.clone(),
            AssetRegistry::from(asset_source).into(),
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

    /// Controls whether each state update immediately draws dirty windows.
    /// Tests default to eager drawing. External frame drivers can batch effects
    /// and input, then call `draw_window` once at their frame boundary, as a
    /// desktop platform does between display refreshes.
    pub fn set_automatic_drawing(&mut self, enabled: bool) {
        if let GpuiMode::Test { draw_on_flush, .. } = &mut self.app.borrow_mut().mode {
            *draw_on_flush = enabled;
        }
    }

    /// Mirrors the containing platform's support for subpixel text coverage.
    pub fn set_subpixel_rendering_supported(&mut self, supported: bool) {
        if self.platform.window_subpixel_rendering.replace(supported) != supported {
            self.update(|cx| cx.refresh_windows());
        }
    }

    /// Opens a window for headless rendering.
    pub fn open_window<V: Render + 'static>(
        &mut self,
        size: Size<Pixels>,
        build_root: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> Result<WindowHandle<V>> {
        self.open_window_with_scale_factor(
            size,
            self.platform.window_scale_factor.get(),
            build_root,
        )
    }

    /// Opens a window with its platform density installed before the root builder
    /// runs, so construction observes the same metrics as subsequent rendering.
    pub fn open_window_with_scale_factor<V: Render + 'static>(
        &mut self,
        size: Size<Pixels>,
        scale_factor: f32,
        build_root: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> Result<WindowHandle<V>> {
        use crate::{point, px};
        anyhow::ensure!(
            scale_factor.is_finite() && scale_factor > 0.,
            "invalid density"
        );
        let previous_scale = self.platform.window_scale_factor.replace(scale_factor);

        let bounds = Bounds {
            origin: point(px(0.0), px(0.0)),
            size,
        };

        let mut cx = self.app.borrow_mut();
        let draw_initial = cx.mode.draw_on_flush();
        let result = cx.open_window_inner(
            WindowOptions::new()
                .window_bounds(Some(WindowBounds::Windowed(bounds)))
                .focus(false)
                .show(false),
            build_root,
            draw_initial,
        );
        self.platform.window_scale_factor.set(previous_scale);
        result
    }

    /// Runs ready tasks until no runnable work remains.
    ///
    /// Pending timers do not advance automatically. [`Self::advance_clock`]
    /// advances time and runs work due in that interval.
    pub fn run_until_parked(&self) {
        self.dispatcher.run_until_parked();
    }

    /// Advances the simulated clock and runs work due by the new time.
    ///
    /// The scheduler drains runnable work while crossing timers due within
    /// `duration`, then leaves the clock at the requested destination. This
    /// does not model production wall-clock scheduling or latency.
    pub fn advance_clock(&self, duration: Duration) {
        self.dispatcher.advance_clock(duration);
    }

    /// Enables parking mode, allowing blocking on real I/O (e.g., async asset loading).
    pub fn allow_parking(&self) {
        self.dispatcher.allow_parking();
    }

    /// Disables parking mode, returning to deterministic test execution.
    pub fn forbid_parking(&self) {
        self.dispatcher.forbid_parking();
    }

    /// Borrow the app for a synchronous operation.
    ///
    /// This helper calls the closure directly; it does not flush app effects
    /// or drain tasks. Use [`Self::update_window`] for window work that queues
    /// effects, then [`Self::run_until_parked`] for ready tasks.
    pub fn update<R>(&mut self, f: impl FnOnce(&mut App) -> R) -> R {
        let mut app = self.app.borrow_mut();
        f(&mut app)
    }

    /// Update an open window through the app's effect boundary.
    ///
    /// Returns an error for a closed window. Effect flushing draws dirty
    /// windows only when automatic drawing is enabled. This does not drain
    /// tasks; use [`Self::draw_window`] for an explicit draw.
    pub fn update_window<R>(
        &mut self,
        window: AnyWindowHandle,
        f: impl FnOnce(AnyView, &mut Window, &mut App) -> R,
    ) -> Result<R> {
        let mut app = self.app.borrow_mut();
        app.update_window(window, f)
    }

    /// Draws a frame without presenting it or advancing the simulated clock.
    ///
    /// Advance the clock and apply input before calling this to capture a specific
    /// animation or interaction state. The element arena is released after paint.
    pub fn draw_window(&mut self, window: AnyWindowHandle) -> Result<()> {
        self.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
    }

    /// Paints only when GPUI has invalidated the window, as a platform frame
    /// callback does. Returns whether a new scene was produced.
    pub fn draw_window_if_dirty(&mut self, window: AnyWindowHandle) -> Result<bool> {
        self.update_window(window, |_, window, cx| {
            let dirty = window.invalidator.is_dirty();
            if dirty {
                window.draw(cx).clear(cx);
            }
            dirty
        })
    }

    /// Delivers keyboard or pointer input through the regular GPUI event dispatch path.
    pub fn dispatch_input(
        &mut self,
        window: AnyWindowHandle,
        input: crate::PlatformInput,
    ) -> Result<crate::DispatchEventResult> {
        self.update_window(window, |_, window, cx| window.dispatch_event(input, cx))
    }

    /// Delivers callbacks waiting for the next frame, without advancing time.
    pub fn deliver_next_frame(&mut self, window: AnyWindowHandle) -> Result<usize> {
        self.update_window(window, |_, window, cx| window.simulate_next_frame(cx))
    }

    /// Reports the next frame or timer deadline so an external driver can sleep
    /// while an idle component has no work. This does not execute callbacks.
    pub fn next_frame_delay(&mut self, window: AnyWindowHandle) -> Result<Option<Duration>> {
        let animation = self.update_window(window, |_, window, _| {
            window.invalidator.is_dirty() || !window.next_frame_callbacks.borrow().is_empty()
        })?;
        let timer = self.dispatcher.scheduler().next_timer_delay();
        Ok(match (animation, timer) {
            (true, Some(timer)) => Some(timer.min(Duration::from_millis(16))),
            (true, None) => Some(Duration::from_millis(16)),
            (false, timer) => timer,
        })
    }

    /// Calls the current platform text handler without retaining an app borrow.
    /// Its methods update the app themselves, matching native platform dispatch.
    pub fn with_platform_input_handler<R>(
        &mut self,
        window: AnyWindowHandle,
        operation: impl FnOnce(&mut crate::PlatformInputHandler) -> R,
    ) -> Result<Option<R>> {
        let handler = self.update_window(window, |_, window, _| {
            window.platform_window.take_input_handler()
        })?;
        let Some(mut handler) = handler else {
            return Ok(None);
        };
        let result = operation(&mut handler);
        self.update_window(window, |_, window, _| {
            window.platform_window.set_input_handler(handler)
        })?;
        Ok(Some(result))
    }

    /// Reads the cursor selected by the rendered frame at the current pointer.
    pub fn cursor_style(&mut self, window: AnyWindowHandle) -> Result<crate::CursorStyle> {
        self.update_window(window, |_, window, _| {
            window
                .rendered_frame
                .cursor_style(window)
                .unwrap_or_default()
        })
    }

    /// Changes the device density and invalidates layout and glyph rasterization.
    pub fn set_scale_factor(&mut self, window: AnyWindowHandle, scale_factor: f32) -> Result<()> {
        anyhow::ensure!(
            scale_factor.is_finite() && scale_factor > 0.0,
            "scale factor must be positive and finite"
        );
        // Deliver the platform callback after releasing the app borrow: it updates the
        // same window and must be able to borrow the app again.
        let mut test_window = self
            .update_window(window, |_, window, _| {
                window
                    .platform_window
                    .as_test()
                    .map(|window| window.clone())
            })?
            .ok_or_else(|| anyhow::anyhow!("headless window has no test platform"))?;
        test_window.simulate_scale_factor(scale_factor);
        Ok(())
    }

    /// Changes the logical viewport through the regular platform resize callback.
    pub fn set_viewport_size(&mut self, window: AnyWindowHandle, size: Size<Pixels>) -> Result<()> {
        anyhow::ensure!(
            size.width > Pixels::ZERO && size.height > Pixels::ZERO,
            "viewport must have positive dimensions"
        );
        let mut platform = self
            .update_window(window, |_, window, _| {
                window.platform_window.as_test().cloned()
            })?
            .ok_or_else(|| anyhow::anyhow!("headless window has no test platform"))?;
        platform.simulate_resize(size);
        Ok(())
    }

    /// Reads the finished scene of the last drawn frame.
    ///
    /// The callback keeps scene borrows inside the window update. It can inspect
    /// the command plan, measure resources, or capture a portable display list.
    pub fn read_scene<R>(
        &mut self,
        window: AnyWindowHandle,
        read: impl FnOnce(&crate::Scene) -> R,
    ) -> Result<R> {
        self.update_window(window, |_, window, _| read(&window.rendered_frame.scene))
    }

    /// Capture the last drawn scene, resolving each atlas tile through the callback.
    ///
    /// This does not draw a new frame. The caller supplies bitmap access;
    /// capture can work without a pixel renderer. Errors from tile resolution
    /// or scene capture propagate to the caller.
    pub fn capture_scene(
        &mut self,
        window: AnyWindowHandle,
        resolve_tile: impl FnMut(crate::AtlasTile) -> Result<crate::CapturedBitmap>,
    ) -> Result<crate::SceneCapture> {
        self.read_scene(window, |scene| {
            crate::SceneCapture::capture(scene, resolve_tile)
        })?
    }

    /// Capture the last drawn scene with the live capture policy.
    ///
    /// Unlike [`Self::capture_scene`], this avoids content-sorting atlas
    /// bitmaps for snapshot identity. It does not draw, deliver frame callbacks,
    /// or advance time; resolve tiles from the atlas that owns the scene.
    pub fn capture_live_scene(
        &mut self,
        window: AnyWindowHandle,
        resolve_tile: impl FnMut(crate::AtlasTile) -> Result<crate::CapturedBitmap>,
    ) -> Result<crate::SceneCapture> {
        self.read_scene(window, |scene| {
            crate::SceneCapture::capture_live(scene, resolve_tile)
        })?
    }

    /// Returns the most recently rendered bounds for an element's debug selector.
    pub fn debug_bounds(
        &mut self,
        window: AnyWindowHandle,
        selector: &str,
    ) -> Result<Option<Bounds<Pixels>>> {
        self.update_window(window, |_, window, _| {
            window.rendered_frame.debug_bounds.get(selector).copied()
        })
    }

    /// Returns the device-pixel bounds of rendered solid quads with the requested color.
    pub fn solid_quad_bounds(
        &mut self,
        window: AnyWindowHandle,
        color: Hsla,
    ) -> Result<Vec<Bounds<ScaledPixels>>> {
        let color = color.into();
        self.update_window(window, |_, window, _| {
            window
                .rendered_frame
                .scene
                .quads
                .iter()
                .filter(|quad| quad.background.solid == color)
                .map(|quad| quad.bounds)
                .collect()
        })
    }

    /// Returns the device-pixel bounds of painted monochrome glyphs of this color.
    pub fn glyph_bounds(
        &mut self,
        window: AnyWindowHandle,
        color: Hsla,
    ) -> Result<Vec<Bounds<ScaledPixels>>> {
        let color = color.into();
        self.update_window(window, |_, window, _| {
            window
                .rendered_frame
                .scene
                .monochrome_sprites
                .iter()
                .filter(|sprite| sprite.color == color)
                .map(|sprite| sprite.bounds)
                .collect()
        })
    }

    /// Returns the device-pixel bounds of painted underlines of this color.
    pub fn underline_bounds(
        &mut self,
        window: AnyWindowHandle,
        color: Hsla,
    ) -> Result<Vec<Bounds<ScaledPixels>>> {
        let color = color.into();
        self.update_window(window, |_, window, _| {
            window
                .rendered_frame
                .scene
                .underlines
                .iter()
                .filter(|underline| underline.color == color)
                .map(|underline| underline.bounds)
                .collect()
        })
    }

    /// Captures a screenshot from a window.
    ///
    /// Requires that the context was created with a renderer factory that
    /// returns `Some` via [`HeadlessAppContext::with_platform`].
    pub fn capture_screenshot(&mut self, window: AnyWindowHandle) -> Result<RgbaImage> {
        let mut app = self.app.borrow_mut();
        app.update_window(window, |_, window, _| window.render_to_image())?
    }

    /// Returns the text system.
    pub fn text_system(&self) -> &Arc<TextSystem> {
        &self.text_system
    }

    /// Returns the background executor.
    pub fn background_executor(&self) -> &BackgroundExecutor {
        &self.background_executor
    }

    /// Returns the foreground executor.
    pub fn foreground_executor(&self) -> &ForegroundExecutor {
        &self.foreground_executor
    }
}

impl Drop for HeadlessAppContext {
    fn drop(&mut self) {
        // Shut down the app so windows are closed and entity handles are
        // released before the LeakDetector runs.
        self.app.borrow_mut().shutdown();
    }
}

impl AppContext for HeadlessAppContext {
    fn new<T: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T> {
        let mut app = self.app.borrow_mut();
        app.new(build_entity)
    }

    fn reserve_entity<T: 'static>(&mut self) -> Reservation<T> {
        let mut app = self.app.borrow_mut();
        app.reserve_entity()
    }

    fn insert_entity<T: 'static>(
        &mut self,
        reservation: Reservation<T>,
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

    fn as_mut<'a, T>(&'a mut self, _: &Entity<T>) -> GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        panic!("Cannot use as_mut with HeadlessAppContext. Call update() instead.")
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
        app.notify(entity_id);
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
        app.read_global(callback)
    }

    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>) {
        let mut app = self.app.borrow_mut();
        app.insert_global_entity(entity)
    }

    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>) {
        let mut app = self.app.borrow_mut();
        app.remove_global_entity(entity)
    }

    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>> {
        let app = self.app.borrow();
        let iter = app.global_entities();
        // Cloning the iterator here so that lock can be released when function is going out of scope
        iter.collect::<Vec<_>>().into_iter()
    }
}

#[cfg(test)]
mod frame_driver_tests {
    use super::*;
    use crate::prelude::*;
    use crate::{
        Context, MouseDownEvent, MouseUpEvent, PlatformInput, Styled, div, point, px, rgb, size,
    };
    use std::cell::Cell;
    struct Counter {
        renders: Rc<Cell<usize>>,
        count: u32,
    }
    impl Render for Counter {
        fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
            self.renders.set(self.renders.get() + 1);
            div()
                .id("counter")
                .w(px(100.))
                .h(px(60.))
                .bg(rgb(0x110000 + self.count))
                .on_click(cx.listener(|this, _, _, cx| {
                    this.count += 1;
                    cx.notify();
                }))
        }
    }
    #[test]
    fn construction_density_and_first_frame_callbacks_match_platform_order() {
        let renders = Rc::new(Cell::new(0));
        let mut app = HeadlessAppContext::new(Arc::new(crate::TestTextSystem));
        app.set_automatic_drawing(false);
        let render_count = renders.clone();
        let window = app
            .open_window_with_scale_factor(size(px(200.), px(150.)), 1.25, move |window, cx| {
                assert_eq!(
                    window.scale_factor(),
                    1.25,
                    "density is visible during construction"
                );
                let entity = cx.new(|_| Counter {
                    renders: render_count,
                    count: 0,
                });
                let callback_entity = entity.clone();
                window.on_next_frame(move |window, cx| {
                    assert!(
                        !window.rendered_frame.scene.quads.is_empty(),
                        "initial paint precedes the first display callback"
                    );
                    callback_entity.update(cx, |this, cx| {
                        this.count += 1;
                        cx.notify();
                    });
                });
                entity
            })
            .unwrap();
        assert!(app.draw_window_if_dirty(window.into()).unwrap());
        assert_eq!(renders.get(), 1);
        assert!(
            !app.draw_window_if_dirty(window.into()).unwrap(),
            "idle frame should reuse its scene"
        );
        assert_eq!(app.deliver_next_frame(window.into()).unwrap(), 1);
        app.run_until_parked();
        assert!(app.draw_window_if_dirty(window.into()).unwrap());
        assert_eq!(renders.get(), 2);
        app.set_scale_factor(window.into(), 2.).unwrap();
        assert!(app.draw_window_if_dirty(window.into()).unwrap());
        app.update_window(window.into(), |_, window, _| {
            assert_eq!(window.scale_factor(), 2.)
        })
        .unwrap();
    }
    #[test]
    fn external_frame_driver_batches_updates_without_losing_real_event_effects() {
        let renders = Rc::new(Cell::new(0));
        let mut app = HeadlessAppContext::new(Arc::new(crate::TestTextSystem));
        app.set_automatic_drawing(false);
        let render_count = renders.clone();
        let window = app
            .open_window(size(px(200.), px(150.)), move |_, cx| {
                cx.new(|_| Counter {
                    renders: render_count,
                    count: 0,
                })
            })
            .unwrap();
        assert_eq!(renders.get(), 0, "external driver owns the initial paint");
        app.draw_window(window.into()).unwrap();
        assert_eq!(renders.get(), 1);
        app.dispatch_input(
            window.into(),
            PlatformInput::MouseDown(MouseDownEvent {
                position: point(px(20.), px(20.)),
                ..Default::default()
            }),
        )
        .unwrap();
        app.dispatch_input(
            window.into(),
            PlatformInput::MouseUp(MouseUpEvent {
                position: point(px(20.), px(20.)),
                ..Default::default()
            }),
        )
        .unwrap();
        assert_eq!(
            renders.get(),
            1,
            "input effects should not each produce a frame"
        );
        app.read_window(&window, |entity, cx| assert_eq!(entity.read(cx).count, 1))
            .unwrap();
        app.draw_window(window.into()).unwrap();
        assert_eq!(renders.get(), 2);
        assert_eq!(
            app.solid_quad_bounds(window.into(), crate::rgb_to_hsla(rgb(0x110001)))
                .unwrap()
                .len(),
            1
        );
        app.set_automatic_drawing(true);
        app.update_window(window.into(), |root, _, cx| {
            let counter = root.downcast::<Counter>().unwrap();
            counter.update(cx, |this, cx| {
                this.count += 1;
                cx.notify();
            });
        })
        .unwrap();
        assert!(
            renders.get() > 2,
            "existing eager headless drawing remains available"
        );
    }
}
