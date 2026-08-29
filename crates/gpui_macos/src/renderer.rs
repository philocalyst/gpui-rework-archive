use gpui::{DevicePixels, Size};
use gpui_wgpu::{GpuContext, WgpuDeviceRequirements, WgpuRenderer, WgpuSurfaceConfig};
use raw_window_handle as rwh;
use std::{ffi::c_void, ptr::NonNull};

pub(crate) type Context = GpuContext;
pub(crate) type Renderer = WgpuRenderer;

#[derive(Clone, Copy, Debug)]
pub(crate) struct RawWindow {
    view: NonNull<c_void>,
}

impl RawWindow {
    /// The caller keeps the NSView alive until every renderer using this handle is dropped.
    pub(crate) unsafe fn new(view: *mut c_void) -> Self {
        Self {
            view: NonNull::new(view).expect("macOS renderer requires a valid NSView"),
        }
    }
}

// AppKit objects are main-thread-owned, but raw-window-handle requires these marker traits for
// surface creation and recovery. WGPU never dereferences the pointer away from those calls.
unsafe impl Send for RawWindow {}
unsafe impl Sync for RawWindow {}

impl rwh::HasWindowHandle for RawWindow {
    fn window_handle(&self) -> Result<rwh::WindowHandle<'_>, rwh::HandleError> {
        // SAFETY: `view` is an NSView retained by MacWindowState for this handle's lifetime.
        unsafe {
            Ok(rwh::WindowHandle::borrow_raw(rwh::RawWindowHandle::AppKit(
                rwh::AppKitWindowHandle::new(self.view),
            )))
        }
    }
}

impl rwh::HasDisplayHandle for RawWindow {
    fn display_handle(&self) -> Result<rwh::DisplayHandle<'_>, rwh::HandleError> {
        Ok(rwh::DisplayHandle::appkit())
    }
}

pub(crate) unsafe fn new_renderer(
    context: Context,
    native_view: *mut c_void,
    size: Size<DevicePixels>,
    transparent: bool,
    requirements: Option<WgpuDeviceRequirements>,
) -> Renderer {
    // SAFETY: MacWindow owns the NSView and destroys the renderer before releasing it.
    let window = unsafe { RawWindow::new(native_view) };
    WgpuRenderer::new(
        context,
        &window,
        WgpuSurfaceConfig {
            size,
            transparent,
            preferred_present_mode: Some(gpui_wgpu::wgpu::PresentMode::Fifo),
        },
        None,
        requirements,
    )
    .expect("failed to create macOS WGPU renderer")
}
