#[cfg(target_os = "windows")]
use crate::WindowsScreenCaptureFrame;
use crate::{
    App, Bounds, DevicePixels, Element, ElementId, GlobalElementId, InspectorElementId,
    IntoElement, LayoutId, ObjectFit, Pixels, Size, Style, StyleRefinement, Styled, Window,
};
#[cfg(target_os = "macos")]
use core_video::pixel_buffer::CVPixelBuffer;
use refineable::Refineable;

/// A source of a surface's content.
#[derive(Clone)]
pub enum SurfaceSource {
    /// A macOS image buffer from CoreVideo
    #[cfg(target_os = "macos")]
    Surface(CVPixelBuffer),
    /// A GPU texture handle (type-erased to avoid depending on wgpu)
    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    Texture {
        /// The GPU texture, type-erased (expected to be `Arc<wgpu::Texture>`)
        texture: std::sync::Arc<dyn std::any::Any + Send + Sync>,
        /// Dimensions of the texture in device pixels
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
            #[cfg(any(target_os = "linux", target_os = "freebsd"))]
            SurfaceSource::Texture { size, .. } => _f
                .debug_struct("Texture")
                .field("size", &size)
                .finish_non_exhaustive(),
            #[cfg(target_os = "windows")]
            SurfaceSource::WindowsCapture(ref frame) => frame.fmt(_f),
            SurfaceSource::Unsupported(size) => {
                _f.debug_tuple("Unsupported").field(&size).finish()
            }
        }
    }
}

impl SurfaceSource {
    /// The size of the surface's source content, in device pixels.
    pub fn size(&self) -> Size<DevicePixels> {
        match self {
            #[cfg(target_os = "macos")]
            SurfaceSource::Surface(buffer) => {
                crate::size(buffer.get_width().into(), buffer.get_height().into())
            }
            #[cfg(any(target_os = "linux", target_os = "freebsd"))]
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

/// A surface element.
pub struct Surface {
    source: SurfaceSource,
    object_fit: ObjectFit,
    style: StyleRefinement,
}

/// Create a new surface element.
pub fn surface(source: impl Into<SurfaceSource>) -> Surface {
    Surface {
        source: source.into(),
        object_fit: ObjectFit::Contain,
        style: Default::default(),
    }
}

impl Surface {
    /// Set the object fit for the image.
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
        _window.paint_surface(new_bounds, self.source.clone());
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{TestAppContext, point, px, size};

    const IMAGE_SIZE: Size<DevicePixels> = size(DevicePixels(200), DevicePixels(100));

    #[gpui::test]
    fn object_fit_selects_bounds_and_paint_inserts_primitive(cx: &mut TestAppContext) {
        let bounds = Bounds::new(point(px(0.), px(0.)), size(px(100.), px(100.)));
        assert_eq!(
            ObjectFit::Fill.get_bounds(bounds, IMAGE_SIZE),
            bounds,
            "fill stretches to the element bounds"
        );
        let contain = ObjectFit::Contain.get_bounds(bounds, IMAGE_SIZE);
        assert_eq!(contain.size, size(px(100.), px(50.)), "contain fits inside");
        assert_eq!(contain.origin, point(px(0.), px(25.)), "contain centers");
        let cover = ObjectFit::Cover.get_bounds(bounds, IMAGE_SIZE);
        assert_eq!(cover.size, size(px(200.), px(100.)), "cover fills bounds");
        assert_eq!(
            cover.origin,
            point(px(-50.), px(0.)),
            "cover crops overflow"
        );
        assert_eq!(
            ObjectFit::ScaleDown.get_bounds(bounds, IMAGE_SIZE),
            contain,
            "scale-down behaves like contain when larger"
        );
        assert_eq!(
            ObjectFit::None.get_bounds(bounds, IMAGE_SIZE).size,
            size(px(200.), px(100.)),
            "none keeps original size"
        );

        // Painting the element must emit a PaintSurface primitive whose bounds
        // reflect the selected object-fit.
        let window = cx.add_empty_window();
        let source = SurfaceSource::Unsupported(IMAGE_SIZE);
        window.draw(point(px(0.), px(0.)), size(px(100.), px(100.)), {
            move |_, _| surface(source).size_full().object_fit(ObjectFit::Contain)
        });

        let (primitive_bounds, source_size) = window.update(|window, _| {
            let primitive = window
                .rendered_frame
                .scene
                .surfaces
                .last()
                .expect("surface should paint a PaintSurface primitive");
            (primitive.bounds, primitive.source.size())
        });
        let scale_factor = window.update(|window, _| window.scale_factor());
        assert_eq!(
            primitive_bounds,
            Bounds::new(
                point(px(0.).scale(scale_factor), px(25.).scale(scale_factor)),
                size(px(100.).scale(scale_factor), px(50.).scale(scale_factor)),
            ),
            "painted bounds must match the contain object-fit"
        );
        assert_eq!(source_size, IMAGE_SIZE, "source size is carried through");
    }
}
