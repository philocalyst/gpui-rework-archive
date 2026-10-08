#[cfg(target_os = "windows")]
use crate::WindowsScreenCaptureFrame;
use crate::{
    App, Bounds, DevicePixels, Element, ElementId, GlobalElementId, InspectorElementId,
    IntoElement, LayoutId, ObjectFit, Pixels, Size, Style, StyleRefinement, Styled, Window,
};
#[cfg(target_os = "macos")]
use core_video::pixel_buffer::CVPixelBuffer;
use refineable::Refineable;

/// A backend-owned image that GPUI can composite without decoding it as an asset.
///
/// Use a surface for a captured frame, video buffer, or custom GPU render target.
/// Use [`img`](crate::img) for an ordinary image loaded from bytes, a file, or a URL.
/// [`surface`] places this source in the element tree; [`Window::paint_surface`]
/// records it directly during a custom element's paint phase.
///
/// A variant being available does not establish that the selected renderer can
/// import it. The source must use that renderer's supported format and device.
/// Cloning retains the underlying handle, not a copy of its pixels. These handles
/// cannot be transported in a [`SceneCapture`](crate::SceneCapture).
#[derive(Clone)]
pub enum SurfaceSource {
    /// A macOS [CoreVideo pixel buffer](https://developer.apple.com/documentation/corevideo/cvpixelbuffer).
    ///
    /// The supplied Metal and WGPU renderers expect full-range, bi-planar YCbCr
    /// (`kCVPixelFormatType_420YpCbCr8BiPlanarFullRange`). The WGPU importer also
    /// requires an IOSurface-backed, Metal-compatible allocation. The default
    /// Metal renderer asserts the pixel format when drawing; an arbitrary BGRA
    /// pixel buffer is not accepted.
    #[cfg(target_os = "macos")]
    Surface(CVPixelBuffer),
    /// A texture created on GPUI's WGPU device.
    ///
    /// GPUI erases the concrete type to keep WGPU out of its core dependencies.
    /// The supplied importer downcasts the value behind `texture` to
    /// `wgpu::Texture`, using the renderer's WGPU version. Coerce an
    /// `Arc<wgpu::Texture>` to the field type; placing that `Arc` inside another
    /// `Arc` gives the wrong erased type.
    ///
    /// Prefer `gpui_wgpu::WgpuRenderTarget::surface` when using the WGPU package.
    /// Obtain its device through `WgpuContextHandle::from_window`. On macOS the
    /// platform facade's `macos-wgpu` feature selects the WGPU renderer; enabling
    /// `custom-gpu` alone does not make the default Metal renderer import textures.
    /// See the [platform feature guide](crate::_documentation::platforms#cargo-features).
    #[cfg(any(
        target_os = "linux",
        target_os = "freebsd",
        all(target_os = "macos", feature = "custom-gpu"),
        all(target_family = "wasm", feature = "custom-gpu")
    ))]
    Texture {
        /// Shared ownership of a `wgpu::Texture`, erased to the core API's type.
        #[cfg(not(target_family = "wasm"))]
        texture: std::sync::Arc<dyn std::any::Any + Send + Sync>,
        /// Shared ownership of a `wgpu::Texture`, erased to the core API's type.
        ///
        /// WGPU handles are intentionally thread-local in browser builds.
        #[cfg(target_family = "wasm")]
        texture: std::sync::Arc<dyn std::any::Any>,
        /// Nonzero texture dimensions in device pixels, used for object fitting.
        ///
        /// These dimensions do not set the element's layout size.
        size: Size<DevicePixels>,
    },
    /// A native Windows Graphics Capture texture.
    #[cfg(target_os = "windows")]
    WindowsCapture(WindowsScreenCaptureFrame),
    /// A placeholder for platforms that cannot import native surfaces.
    #[doc(hidden)]
    Unsupported(Size<DevicePixels>),
}

impl std::fmt::Debug for SurfaceSource {
    fn fmt(&self, _f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match *self {
            #[cfg(target_os = "macos")]
            SurfaceSource::Surface(ref buf) => _f.debug_tuple("Surface").field(buf).finish(),
            #[cfg(any(
                target_os = "linux",
                target_os = "freebsd",
                all(target_os = "macos", feature = "custom-gpu"),
                all(target_family = "wasm", feature = "custom-gpu")
            ))]
            SurfaceSource::Texture { size, .. } => _f
                .debug_struct("Texture")
                .field("size", &size)
                .finish_non_exhaustive(),
            #[cfg(target_os = "windows")]
            SurfaceSource::WindowsCapture(ref frame) => frame.fmt(_f),
            SurfaceSource::Unsupported(size) => _f.debug_tuple("Unsupported").field(&size).finish(),
        }
    }
}

impl SurfaceSource {
    fn size(&self) -> Size<DevicePixels> {
        match self {
            #[cfg(target_os = "macos")]
            SurfaceSource::Surface(buffer) => {
                crate::size(buffer.get_width().into(), buffer.get_height().into())
            }
            #[cfg(any(
                target_os = "linux",
                target_os = "freebsd",
                all(target_os = "macos", feature = "custom-gpu"),
                all(target_family = "wasm", feature = "custom-gpu")
            ))]
            SurfaceSource::Texture { size, .. } => *size,
            #[cfg(target_os = "windows")]
            SurfaceSource::WindowsCapture(frame) => frame.size(),
            SurfaceSource::Unsupported(size) => *size,
        }
    }
}

#[cfg(target_os = "macos")]
impl From<CVPixelBuffer> for SurfaceSource {
    fn from(value: CVPixelBuffer) -> Self {
        SurfaceSource::Surface(value)
    }
}

#[cfg(target_os = "windows")]
impl From<WindowsScreenCaptureFrame> for SurfaceSource {
    fn from(value: WindowsScreenCaptureFrame) -> Self {
        SurfaceSource::WindowsCapture(value)
    }
}

#[cfg(all(target_os = "windows", feature = "screen-capture"))]
impl From<crate::ScreenCaptureFrame> for SurfaceSource {
    fn from(value: crate::ScreenCaptureFrame) -> Self {
        SurfaceSource::WindowsCapture(value.0)
    }
}

/// An element that composites a [`SurfaceSource`] into a layout box.
///
/// Construct with [`surface`], assign a size through [`Styled`], and choose
/// placement through [`object_fit`](Self::object_fit). The source is retained
/// by the element for this draw; keep a longer-lived source or render target on
/// its owning view when needed across frames.
pub struct Surface {
    source: SurfaceSource,
    object_fit: ObjectFit,
    style: StyleRefinement,
}

/// Composites a platform surface or GPU texture with [`ObjectFit::Contain`] by default.
///
/// Set its layout size through [`Styled`]. Unlike [`img`](crate::img), this
/// element does not measure the source to choose an intrinsic size. Here a
/// 16:9 panel fills its box and crops any excess:
///
/// ```
/// use gpui::{ObjectFit, SurfaceSource, div, prelude::*, px, surface};
///
/// fn video_panel(frame: SurfaceSource) -> impl IntoElement {
///     div().w(px(320.)).h(px(180.)).flex_shrink_0().overflow_hidden()
///         .child(surface(frame).size_full().object_fit(ObjectFit::Cover))
/// }
/// ```
///
/// `Cover` determines the drawing bounds; the wrapper supplies the clip.
/// Surface painting applies opacity but does not paint style backgrounds,
/// borders, shadows, or rounded corners. Use a surrounding [`Div`](crate::Div)
/// for decorations. Updating the source's pixels does not notify GPUI: request
/// a redraw when a new frame is ready, and build a new surface if its handle
/// changes. See [`SurfaceSource`] for renderer and format requirements.
pub fn surface(source: impl Into<SurfaceSource>) -> Surface {
    Surface {
        source: source.into(),
        object_fit: ObjectFit::Contain,
        style: Default::default(),
    }
}

impl Surface {
    /// Chooses how the source fits the element's layout box.
    ///
    /// The default, [`ObjectFit::Contain`], centers the whole image and preserves
    /// its aspect ratio. [`ObjectFit::Cover`] fills the box and can extend beyond
    /// it; use an ancestor's content mask, such as `div().overflow_hidden()`, to
    /// crop the excess. Fitting changes paint geometry, not the layout size.
    /// `None` and `ScaleDown` treat source pixel counts as logical lengths;
    /// they do not apply the window's density scale to those counts.
    pub fn object_fit(mut self, object_fit: ObjectFit) -> Self {
        self.object_fit = object_fit;
        self
    }
}

impl Element for Surface {
    type RequestLayoutState = ();
    type PrepaintState = ();

    fn id(&self) -> Option<ElementId> {
        None
    }

    fn source_location(&self) -> Option<&'static core::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let mut style = Style::default();
        style.refine(&self.style);
        let layout_id = window.request_layout(style, [], cx);
        (layout_id, ())
    }

    fn prepaint(
        &mut self,
        _global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        _window: &mut Window,
        _cx: &mut App,
    ) -> Self::PrepaintState {
    }

    fn paint(
        &mut self,
        _global_id: Option<&GlobalElementId>,
        _inspector_id: Option<&InspectorElementId>,
        _bounds: Bounds<Pixels>,
        _: &mut Self::RequestLayoutState,
        _: &mut Self::PrepaintState,
        _window: &mut Window,
        _: &mut App,
    ) {
        let new_bounds = self.object_fit.get_bounds(_bounds, self.source.size());
        // TODO: Add support for corner_radii.
        let mut style = Style::default();
        style.refine(&self.style);
        _window.with_element_opacity(style.opacity, |window| {
            window.paint_surface(new_bounds, self.source.clone());
        });
    }
}

impl IntoElement for Surface {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Styled for Surface {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.style
    }
}
