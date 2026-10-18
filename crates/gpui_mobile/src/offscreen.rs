//! Offscreen windows: GPUI windows drawn into a texture instead of onto the
//! screen, so an application can turn a view into an image.
//!
//! OffscreenWindow opens an ordinary GPUI window without a UIKit or NDK surface.
//! Layout, text shaping and painting use the normal GPUI path, and render reads
//! pixels through the WGPU headless renderer.
//!
//! One native headless renderer is shared by open offscreen windows on the
//! platform thread. It is dropped when the last offscreen window closes, which
//! releases its target, atlas, device, and pipelines. The next capture creates a
//! fresh renderer. The optional offscreen feature exposes this module on
//! Android. Unit tests also compile it on the host; gpui_mobile does not provide
//! an iOS platform backend.

use std::{
    cell::{Cell, RefCell},
    rc::Rc,
    sync::Arc,
};

use anyhow::{Context as _, Result};
use gpui::{
    AnyWindowHandle, App, AppContext as _, AsyncApp, Bounds, Capslock, DevicePixels,
    DispatchEventResult, Entity, GpuSpecs, Modifiers, Pixels, PlatformAtlas, PlatformDisplay,
    PlatformHeadlessRenderer, PlatformInput, PlatformInputHandler, PlatformWindow, Point,
    PromptButton, PromptLevel, Render, RequestFrameOptions, Scene, Size, Window, WindowAppearance,
    WindowBackgroundAppearance, WindowBounds, WindowControlArea, WindowHandle, WindowOptions,
    WindowVisibility, point, px,
};
use gpui_wgpu::WgpuHeadlessRenderer;
pub use image::RgbaImage;
use raw_window_handle::{HasDisplayHandle, HasWindowHandle};

thread_local! {
    /// Set by [`OffscreenWindow::open`] for the platform's `open_window` call it
    /// makes, which then answers with an [`OffscreenPlatformWindow`].
    static PENDING: RefCell<Option<Rc<RefCell<State>>>> = const { RefCell::new(None) };
    static RENDERER: RefCell<Option<SharedRenderer>> = const { RefCell::new(None) };
    /// Offscreen platform windows GPUI has not dropped yet.
    static OPEN_WINDOWS: Cell<usize> = const { Cell::new(0) };
}

/// A GPUI window rendered into images instead of onto the screen.
///
/// Close it with [`Self::close`]. Dropping the handle without closing it (for
/// example when the task capturing it is cancelled) closes the window on the
/// next turn of the main thread's executor instead, since `Drop` has no `App`.
pub struct OffscreenWindow<V> {
    handle: WindowHandle<V>,
    state: Rc<RefCell<State>>,
    /// Closes the window when the handle is dropped; `None` once [`Self::close`]
    /// has closed it.
    close_on_drop: Option<AsyncApp>,
}

impl<V: Render + 'static> OffscreenWindow<V> {
    /// Opens a window of `size` logical pixels drawn at `scale_factor` device
    /// pixels per logical pixel, with `build` creating its root view.
    pub fn open(
        size: Size<Pixels>,
        scale_factor: f32,
        appearance: WindowAppearance,
        cx: &mut App,
        build: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> Result<Self> {
        anyhow::ensure!(
            scale_factor.is_finite() && scale_factor > 0.0,
            "scale_factor must be finite and positive"
        );
        let renderer = renderer()?;
        // If validation or setup fails before the platform consumes PENDING,
        // release a renderer created for this first open. The guard preserves
        // it when another offscreen platform window is already live.
        let pending_guard = PendingOpenGuard;
        let max_texture_size = renderer
            .borrow()
            .as_ref()
            .expect("new renderer is live")
            .max_texture_size;
        let max_readback_buffer_size = renderer
            .borrow()
            .as_ref()
            .expect("new renderer is live")
            .max_readback_buffer_size;
        device_size(
            size,
            scale_factor,
            max_texture_size,
            max_readback_buffer_size,
        )?;
        let state = Rc::new(RefCell::new(State {
            bounds: Bounds::new(Point::default(), size),
            scale_factor,
            appearance,
            renderer,
            max_texture_size,
            max_readback_buffer_size,
            request_frame: None,
            resize: None,
            input_handler: None,
            read_back: false,
            image: None,
        }));
        PENDING.with(|pending| *pending.borrow_mut() = Some(state.clone()));
        let options = WindowOptions {
            window_bounds: Some(WindowBounds::Windowed(Bounds::new(
                point(px(0.), px(0.)),
                size,
            ))),
            focus: false,
            show: false,
            ..Default::default()
        };
        let handle = cx.open_window(options, build);
        drop(pending_guard);
        // `open_window` takes it on success; clear it if the platform never got that far.
        Ok(Self {
            handle: handle?,
            state,
            close_on_drop: Some(cx.to_async()),
        })
    }

    /// The GPUI handle of the window, to update its root view between renders.
    pub fn handle(&self) -> WindowHandle<V> {
        self.handle
    }

    /// The largest square size one [`Self::render`] can produce at this
    /// window's scale factor. This accounts for both the texture dimension and
    /// the padded GPU readback buffer; rectangular sizes are checked separately
    /// when rendered.
    pub fn max_size(&self) -> Size<Pixels> {
        let state = self.state.borrow();
        let max_device_side =
            max_device_side(state.max_texture_size, state.max_readback_buffer_size);
        let mut side =
            (max_device_side as f64 / state.scale_factor as f64).min(f32::MAX as f64) as f32;
        while side > 0.0
            && device_size(
                Size {
                    width: px(side),
                    height: px(side),
                },
                state.scale_factor,
                state.max_texture_size,
                state.max_readback_buffer_size,
            )
            .is_err()
        {
            side = f32::from_bits(side.to_bits() - 1);
        }
        let side = px(side);
        Size {
            width: side,
            height: side,
        }
    }

    /// Lays the window out at `size`, draws one frame and returns its pixels.
    ///
    /// GPUI delivers the frame through the window's own callbacks, which borrow
    /// the `App` themselves, so call this from an async task between `update`s
    /// (for example after `cx.spawn(async move |cx| …)` resumes), never from
    /// inside `App::update` or a view's `render`.
    pub fn render(&self, size: Size<Pixels>) -> Result<RgbaImage> {
        self.frame(size, true)?
            .context("GPUI did not draw the offscreen window")?
    }

    /// Lays the window out at `size` and paints one frame without reading it
    /// back, so views can measure their content (for example to size the next
    /// [`Self::render`]). The same calling rule as [`Self::render`] applies.
    pub fn layout(&self, size: Size<Pixels>) -> Result<()> {
        self.frame(size, false).map(|_| ())
    }

    fn frame(&self, size: Size<Pixels>, read_back: bool) -> Result<Option<Result<RgbaImage>>> {
        let (scale_factor, max_texture_size, max_readback_buffer_size) = {
            let state = self.state.borrow();
            (
                state.scale_factor,
                state.max_texture_size,
                state.max_readback_buffer_size,
            )
        };
        device_size(
            size,
            scale_factor,
            max_texture_size,
            max_readback_buffer_size,
        )?;
        let resize = {
            let mut state = self.state.borrow_mut();
            let changed = state.bounds.size != size;
            state.bounds.size = size;
            state.read_back = read_back;
            state.image = None;
            changed.then(|| state.resize.take()).flatten()
        };
        if let Some(mut resize) = resize {
            let scale_factor = self.state.borrow().scale_factor;
            resize(size, scale_factor);
            self.state.borrow_mut().resize = Some(resize);
        }

        let mut request_frame = self
            .state
            .borrow_mut()
            .request_frame
            .take()
            .context("the offscreen window has no frame callback; was it closed?")?;
        request_frame(RequestFrameOptions {
            require_presentation: true,
            force_render: true,
            ..Default::default()
        });
        let mut state = self.state.borrow_mut();
        state.request_frame = Some(request_frame);
        Ok(state.image.take())
    }

    /// Closes the window, dropping its view tree.
    pub fn close(mut self, cx: &mut App) {
        // Within the window's own update it can't be reached; the drop below
        // then closes it from a fresh task instead.
        if self
            .handle
            .update(cx, |_, window, _| window.remove_window())
            .is_ok()
        {
            self.close_on_drop = None;
        }
    }
}

impl<V> Drop for OffscreenWindow<V> {
    fn drop(&mut self) {
        let Some(cx) = self.close_on_drop.take() else {
            return;
        };
        // The handle can be dropped while the `App` is borrowed (inside an update,
        // or by a task being cancelled), so close the window from a fresh task.
        let handle: AnyWindowHandle = *self.handle;
        cx.spawn(async move |cx| {
            let _ = cx.update_window(handle, |_, window, _| window.remove_window());
        })
        .detach();
    }
}

fn device_size(
    size: Size<Pixels>,
    scale_factor: f32,
    max_texture_size: u32,
    max_readback_buffer_size: u64,
) -> Result<Size<DevicePixels>> {
    anyhow::ensure!(
        scale_factor.is_finite()
            && scale_factor > 0.0
            && size.width.as_f32().is_finite()
            && size.width.as_f32() > 0.0
            && size.height.as_f32().is_finite()
            && size.height.as_f32() > 0.0,
        "offscreen dimensions and scale factor must be finite and positive"
    );
    let width = (size.width.as_f32() * scale_factor).round();
    let height = (size.height.as_f32() * scale_factor).round();
    anyhow::ensure!(
        width.is_finite()
            && height.is_finite()
            && width >= 1.0
            && height >= 1.0
            && width <= max_texture_size as f32
            && height <= max_texture_size as f32
            && width <= i32::MAX as f32
            && height <= i32::MAX as f32,
        "offscreen size exceeds the GPU texture limit"
    );
    let device_size = Size {
        width: DevicePixels(width as i32),
        height: DevicePixels(height as i32),
    };
    anyhow::ensure!(
        padded_readback_size(width as u32, height as u32)
            .is_some_and(|bytes| bytes <= max_readback_buffer_size),
        "offscreen readback exceeds the GPU buffer limit"
    );
    Ok(device_size)
}

fn padded_readback_size(width: u32, height: u32) -> Option<u64> {
    // WGPU requires texture-to-buffer copy rows to use 256-byte alignment.
    const COPY_BYTES_PER_ROW_ALIGNMENT: u64 = 256;
    let row_bytes = u64::from(width).checked_mul(4)?;
    let alignment = COPY_BYTES_PER_ROW_ALIGNMENT;
    let padded_row_bytes = row_bytes
        .checked_add(alignment - 1)?
        .checked_div(alignment)?
        .checked_mul(alignment)?;
    padded_row_bytes.checked_mul(u64::from(height))
}

fn max_device_side(max_texture_size: u32, max_readback_buffer_size: u64) -> u32 {
    let mut low = 0;
    let mut high = max_texture_size;
    while low < high {
        let middle = low + (high - low).div_ceil(2);
        if padded_readback_size(middle, middle)
            .is_some_and(|bytes| bytes <= max_readback_buffer_size)
        {
            low = middle;
        } else {
            high = middle - 1;
        }
    }
    low
}

struct PendingOpenGuard;

impl Drop for PendingOpenGuard {
    fn drop(&mut self) {
        PENDING.with(|pending| pending.borrow_mut().take());
        if OPEN_WINDOWS.with(Cell::get) == 0 {
            release_renderer();
        }
    }
}

fn release_renderer() {
    let renderer = RENDERER.with(|slot| slot.borrow_mut().take());
    if let Some(renderer) = renderer {
        renderer.borrow_mut().take();
    }
}

/// Answers the platform's `open_window` with an offscreen window when
/// [`OffscreenWindow::open`] asked for one.
pub(crate) fn take_pending() -> Option<Box<dyn PlatformWindow>> {
    let state = PENDING.with(|pending| pending.borrow_mut().take())?;
    OPEN_WINDOWS.with(|open| open.set(open.get() + 1));
    Some(Box::new(OffscreenPlatformWindow(state)))
}

fn renderer() -> Result<SharedRenderer> {
    RENDERER.with(|slot| {
        let existing = slot.borrow().clone();
        if let Some(renderer) = existing {
            if renderer.borrow().is_some() {
                return Ok(renderer);
            }
        }
        let renderer = create_renderer()?;
        let max_texture_size = renderer.max_texture_size();
        let max_readback_buffer_size = renderer.max_readback_buffer_size();
        let sprite_atlas = renderer.sprite_atlas();
        let shared = Rc::new(RefCell::new(Some(RendererState {
            renderer,
            sprite_atlas,
            max_texture_size,
            max_readback_buffer_size,
        })));
        *slot.borrow_mut() = Some(shared.clone());
        Ok(shared)
    })
}

/// The renderer chooses Metal on Apple and the platform-native backend elsewhere.
fn create_renderer() -> Result<WgpuHeadlessRenderer> {
    WgpuHeadlessRenderer::new()
}

/// GPUI's per-window frame callback, driven by [`OffscreenWindow::frame`].
type FrameCallback = Box<dyn FnMut(RequestFrameOptions)>;
/// GPUI's per-window resize callback.
type ResizeCallback = Box<dyn FnMut(Size<Pixels>, f32)>;

type SharedRenderer = Rc<RefCell<Option<RendererState>>>;

struct RendererState {
    renderer: WgpuHeadlessRenderer,
    sprite_atlas: Arc<dyn PlatformAtlas>,
    max_texture_size: u32,
    max_readback_buffer_size: u64,
}

struct State {
    bounds: Bounds<Pixels>,
    scale_factor: f32,
    appearance: WindowAppearance,
    renderer: SharedRenderer,
    max_texture_size: u32,
    max_readback_buffer_size: u64,
    request_frame: Option<FrameCallback>,
    resize: Option<ResizeCallback>,
    input_handler: Option<PlatformInputHandler>,
    /// Whether the next `draw` reads its pixels back ([`OffscreenWindow::render`])
    /// or only paints ([`OffscreenWindow::layout`]).
    read_back: bool,
    /// What the last `draw` produced, taken by [`OffscreenWindow::render`].
    image: Option<Result<RgbaImage>>,
}

struct OffscreenPlatformWindow(Rc<RefCell<State>>);

/// GPUI drops the platform window with the window itself, after its view tree.
/// When the final one closes, the shared headless renderer is dropped too, which
/// releases the target, atlas, device, and pipelines.
impl Drop for OffscreenPlatformWindow {
    fn drop(&mut self) {
        let open = OPEN_WINDOWS.with(|open| {
            open.set(open.get().saturating_sub(1));
            open.get()
        });
        if open > 0 {
            return;
        }
        // Clear the cache cell too: a stale OffscreenWindow handle may still hold
        // State, but it must not keep the device, target or atlas alive.
        release_renderer();
    }
}

// No native window backs it, so there is no handle to report; `NotSupported`
// is `raw_window_handle`'s variant for exactly this.
impl HasWindowHandle for OffscreenPlatformWindow {
    fn window_handle(
        &self,
    ) -> Result<raw_window_handle::WindowHandle<'_>, raw_window_handle::HandleError> {
        Err(raw_window_handle::HandleError::NotSupported)
    }
}

impl HasDisplayHandle for OffscreenPlatformWindow {
    fn display_handle(
        &self,
    ) -> Result<raw_window_handle::DisplayHandle<'_>, raw_window_handle::HandleError> {
        Err(raw_window_handle::HandleError::NotSupported)
    }
}

impl PlatformWindow for OffscreenPlatformWindow {
    fn bounds(&self) -> Bounds<Pixels> {
        self.0.borrow().bounds
    }

    fn is_maximized(&self) -> bool {
        false
    }

    fn window_bounds(&self) -> WindowBounds {
        WindowBounds::Windowed(self.bounds())
    }

    fn content_size(&self) -> Size<Pixels> {
        self.bounds().size
    }

    fn resize(&mut self, size: Size<Pixels>) {
        self.0.borrow_mut().bounds.size = size;
    }

    fn scale_factor(&self) -> f32 {
        self.0.borrow().scale_factor
    }

    fn appearance(&self) -> WindowAppearance {
        self.0.borrow().appearance
    }

    fn display(&self) -> Option<Rc<dyn PlatformDisplay>> {
        None
    }

    fn mouse_position(&self) -> Point<Pixels> {
        Point::default()
    }

    fn modifiers(&self) -> Modifiers {
        Modifiers::default()
    }

    fn capslock(&self) -> Capslock {
        Capslock::default()
    }

    fn set_input_handler(&mut self, input_handler: PlatformInputHandler) {
        self.0.borrow_mut().input_handler = Some(input_handler);
    }

    fn take_input_handler(&mut self) -> Option<PlatformInputHandler> {
        self.0.borrow_mut().input_handler.take()
    }

    fn prompt(
        &self,
        _level: PromptLevel,
        _msg: &str,
        _detail: Option<&str>,
        _answers: &[PromptButton],
    ) -> Option<futures::channel::oneshot::Receiver<usize>> {
        None
    }

    fn activate(&self, _token: Option<&str>) -> bool {
        false
    }

    fn is_active(&self) -> bool {
        false
    }

    fn visibility(&self) -> WindowVisibility {
        WindowVisibility::Visible
    }

    fn is_hovered(&self) -> bool {
        false
    }

    fn background_appearance(&self) -> WindowBackgroundAppearance {
        WindowBackgroundAppearance::Opaque
    }

    fn set_title(&mut self, _title: &str) {}

    fn set_background_appearance(&self, _background_appearance: WindowBackgroundAppearance) {}

    fn minimize(&self) {}

    fn zoom(&self) {}

    fn toggle_fullscreen(&self) {}

    fn is_fullscreen(&self) -> bool {
        false
    }

    fn on_request_frame(&self, callback: Box<dyn FnMut(RequestFrameOptions)>) {
        self.0.borrow_mut().request_frame = Some(callback);
    }

    fn on_input(&self, _callback: Box<dyn FnMut(PlatformInput) -> DispatchEventResult>) {}

    fn on_active_status_change(&self, _callback: Box<dyn FnMut(bool)>) {}

    fn on_visibility_change(&self, _callback: Box<dyn FnMut(WindowVisibility)>) {}

    fn on_hover_status_change(&self, _callback: Box<dyn FnMut(bool)>) {}

    fn on_resize(&self, callback: Box<dyn FnMut(Size<Pixels>, f32)>) {
        self.0.borrow_mut().resize = Some(callback);
    }

    fn on_moved(&self, _callback: Box<dyn FnMut()>) {}

    fn on_display_changed(&self, _callback: Box<dyn FnMut()>) {}

    fn on_should_close(&self, _callback: Box<dyn FnMut() -> bool>) {}

    fn on_hit_test_window_control(&self, _callback: Box<dyn FnMut() -> Option<WindowControlArea>>) {
    }

    fn on_close(&self, _callback: Box<dyn FnOnce()>) {}

    fn on_appearance_changed(&self, _callback: Box<dyn FnMut()>) {}

    fn draw(&self, scene: &Scene) {
        let mut state = self.0.borrow_mut();
        if !state.read_back {
            return;
        }
        let size = match device_size(
            state.bounds.size,
            state.scale_factor,
            state.max_texture_size,
            state.max_readback_buffer_size,
        ) {
            Ok(size) => size,
            Err(error) => {
                state.image = Some(Err(error));
                return;
            }
        };
        let renderer = state.renderer.clone();
        let image = match renderer.borrow_mut().as_mut() {
            Some(renderer) => renderer.renderer.render_scene_to_image(scene, size),
            None => Err(anyhow::anyhow!("offscreen renderer is closed")),
        };
        state.image = Some(image);
    }

    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas> {
        self.0
            .borrow()
            .renderer
            .borrow()
            .as_ref()
            .expect("sprite atlas requested after offscreen renderer closed")
            .sprite_atlas
            .clone()
    }

    fn is_subpixel_rendering_supported(&self) -> bool {
        false
    }

    fn gpu_specs(&self) -> Option<GpuSpecs> {
        None
    }

    fn update_ime_position(&self, _bounds: Bounds<Pixels>) {}
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn headless_renderer_reads_back_the_requested_pixel_extent() -> anyhow::Result<()> {
        let mut renderer = create_renderer()?;
        let mut scene = Scene::default();
        scene.finish();
        let image = renderer.render_scene_to_image(
            &scene,
            Size {
                width: DevicePixels(4),
                height: DevicePixels(3),
            },
        )?;
        assert_eq!((image.width(), image.height()), (4, 3));
        assert!(image.pixels().all(|pixel| pixel.0 == [0, 0, 0, 255]));
        Ok(())
    }

    #[test]
    fn device_size_rejects_invalid_and_over_limit_allocations() -> anyhow::Result<()> {
        let max = 256;
        assert!(
            device_size(
                Size {
                    width: px(0.1),
                    height: px(1.)
                },
                1.0,
                max,
                u64::MAX
            )
            .is_err()
        );
        assert!(
            device_size(
                Size {
                    width: px(f32::INFINITY),
                    height: px(1.)
                },
                1.0,
                max,
                u64::MAX
            )
            .is_err()
        );
        assert!(
            device_size(
                Size {
                    width: px(257.),
                    height: px(1.)
                },
                1.0,
                max,
                u64::MAX
            )
            .is_err()
        );
        assert_eq!(
            device_size(
                Size {
                    width: px(64.5),
                    height: px(3.)
                },
                2.0,
                max,
                u64::MAX
            )?,
            Size {
                width: DevicePixels(129),
                height: DevicePixels(6),
            }
        );
        assert!(
            device_size(
                Size {
                    width: px(4.),
                    height: px(3.)
                },
                1.0,
                max,
                767,
            )
            .is_err(),
            "4x3 RGBA readback uses three 256-byte padded rows"
        );
        assert_eq!(max_device_side(4096, 4 * 256 * 256), 256);
        Ok(())
    }

    #[test]
    fn platform_draw_reads_an_asymmetric_colored_scene() -> anyhow::Result<()> {
        use gpui::{Bounds, ContentMask, Quad, ScaledPixels, hsla, solid_background};

        let cache = renderer()?;
        let (max_texture_size, max_readback_buffer_size) = {
            let renderer = cache.borrow();
            let renderer = renderer.as_ref().unwrap();
            (renderer.max_texture_size, renderer.max_readback_buffer_size)
        };
        let state = Rc::new(RefCell::new(State {
            bounds: Bounds::new(
                Point::default(),
                Size {
                    width: px(8.),
                    height: px(6.),
                },
            ),
            scale_factor: 1.0,
            appearance: WindowAppearance::Light,
            max_texture_size,
            max_readback_buffer_size,
            renderer: cache,
            request_frame: None,
            resize: None,
            input_handler: None,
            read_back: true,
            image: None,
        }));
        let platform = OffscreenPlatformWindow(state.clone());
        let full = Bounds {
            origin: Point {
                x: ScaledPixels(0.),
                y: ScaledPixels(0.),
            },
            size: Size {
                width: ScaledPixels(8.),
                height: ScaledPixels(6.),
            },
        };
        let mut scene = Scene::default();
        scene.insert_primitive(Quad {
            bounds: Bounds {
                origin: Point {
                    x: ScaledPixels(1.),
                    y: ScaledPixels(1.),
                },
                size: Size {
                    width: ScaledPixels(3.),
                    height: ScaledPixels(2.),
                },
            },
            content_mask: ContentMask {
                bounds: full,
                ..Default::default()
            },
            background: solid_background(hsla(0., 1., 0.5, 1.)),
            ..Default::default()
        });
        scene.finish();

        platform.draw(&scene);
        let image = state
            .borrow_mut()
            .image
            .take()
            .expect("draw reads back pixels")?;
        assert_eq!((image.width(), image.height()), (8, 6));
        assert_eq!(image.get_pixel(2, 1).0, [255, 0, 0, 255]);
        assert_eq!(image.get_pixel(6, 4).0, [0, 0, 0, 255]);
        drop(platform);
        Ok(())
    }

    #[test]
    fn invalid_first_open_releases_idle_renderer_but_keeps_live_windows() -> anyhow::Result<()> {
        let idle_renderer = renderer()?;
        assert!(idle_renderer.borrow().is_some());
        {
            let _open_guard = PendingOpenGuard;
            assert!(device_size(px_size(0.), 1.0, 4096, u64::MAX).is_err());
        }
        assert!(RENDERER.with(|slot| slot.borrow().is_none()));
        assert!(idle_renderer.borrow().is_none());

        let active_renderer = renderer()?;
        let platform_window = {
            let state = Rc::new(RefCell::new(State {
                bounds: Bounds::new(
                    Point::default(),
                    Size {
                        width: px(4.),
                        height: px(3.),
                    },
                ),
                scale_factor: 1.0,
                appearance: WindowAppearance::Light,
                max_texture_size: active_renderer.borrow().as_ref().unwrap().max_texture_size,
                max_readback_buffer_size: active_renderer
                    .borrow()
                    .as_ref()
                    .unwrap()
                    .max_readback_buffer_size,
                renderer: active_renderer.clone(),
                request_frame: None,
                resize: None,
                input_handler: None,
                read_back: false,
                image: None,
            }));
            PENDING.with(|pending| *pending.borrow_mut() = Some(state));
            take_pending().expect("platform consumes live pending state")
        };
        {
            let _failed_second_open = PendingOpenGuard;
            assert!(device_size(px_size(0.), 1.0, 4096, u64::MAX).is_err());
        }
        assert!(active_renderer.borrow().is_some());
        drop(platform_window);
        assert!(RENDERER.with(|slot| slot.borrow().is_none()));
        Ok(())
    }

    fn px_size(value: f32) -> Size<Pixels> {
        Size {
            width: px(value),
            height: px(1.),
        }
    }

    #[test]
    fn pending_window_is_consumed_once_and_renderer_releases_and_reopens() -> anyhow::Result<()> {
        let cache = renderer()?;
        let cache_probe = cache.clone();
        let state = Rc::new(RefCell::new(State {
            bounds: Bounds::new(
                Point::default(),
                Size {
                    width: px(4.),
                    height: px(3.),
                },
            ),
            scale_factor: 1.0,
            appearance: WindowAppearance::Light,
            max_texture_size: cache.borrow().as_ref().unwrap().max_texture_size,
            max_readback_buffer_size: cache.borrow().as_ref().unwrap().max_readback_buffer_size,
            renderer: cache.clone(),
            request_frame: None,
            resize: None,
            input_handler: None,
            read_back: false,
            image: None,
        }));
        PENDING.with(|pending| *pending.borrow_mut() = Some(state.clone()));
        drop(state);
        drop(cache);

        let window = take_pending().expect("open request consumes its pending state");
        assert!(
            take_pending().is_none(),
            "one request cannot make two platform windows"
        );
        assert_eq!(OPEN_WINDOWS.with(Cell::get), 1);
        assert!(
            cache_probe.borrow().is_some(),
            "an open window retains its renderer"
        );
        drop(window);
        assert_eq!(OPEN_WINDOWS.with(Cell::get), 0);
        assert!(RENDERER.with(|slot| slot.borrow().is_none()));
        assert!(
            cache_probe.borrow().is_none(),
            "last close releases renderer and atlas"
        );

        let reopened = renderer()?;
        assert!(
            reopened.borrow().is_some(),
            "a later capture creates a fresh renderer"
        );
        let state = Rc::new(RefCell::new(State {
            bounds: Bounds::new(
                Point::default(),
                Size {
                    width: px(4.),
                    height: px(3.),
                },
            ),
            scale_factor: 1.0,
            appearance: WindowAppearance::Light,
            max_texture_size: reopened.borrow().as_ref().unwrap().max_texture_size,
            max_readback_buffer_size: reopened.borrow().as_ref().unwrap().max_readback_buffer_size,
            renderer: reopened.clone(),
            request_frame: None,
            resize: None,
            input_handler: None,
            read_back: false,
            image: None,
        }));
        PENDING.with(|pending| *pending.borrow_mut() = Some(state.clone()));
        drop(state);
        drop(reopened);
        drop(take_pending().expect("reopened capture gets a platform window"));
        assert!(RENDERER.with(|slot| slot.borrow().is_none()));
        Ok(())
    }
}
