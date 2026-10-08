use std::{
    fs,
    hash::{Hash, Hasher},
    path::Path,
    sync::Arc,
};

use crate::{
    App, Asset, Bounds, Element, GlobalElementId, Hitbox, InspectorElementId, InteractiveElement,
    Interactivity, IntoElement, LayoutId, Pixels, Point, Radians, SharedString, Size,
    StyleRefinement, Styled, TransformationMatrix, Window, point, px, radians, size,
};
use gpui_util::ResultExt;

/// An SVG painted as a single-color icon inside a styled layout box.
///
/// Construct it with [`svg`], choose a source, set its size, and supply the tint
/// through [`Styled::text_color`]. Source RGB colors are discarded; their alpha
/// determines where the tint is visible. For a multicolor illustration, use
/// [`img`](crate::img) to decode an SVG resource as a [`RenderImage`](crate::RenderImage),
/// or rasterize it explicitly with [`SvgRenderer`](crate::SvgRenderer).
///
/// The SVG's dimensions do not determine this element's layout size. Its
/// assigned width determines the raster scale while preserving aspect ratio;
/// the raster is centered in the box. A tall result can extend beyond that box.
/// Use an ancestor's content mask when it must be clipped. Unlike [`Img`](crate::Img),
/// `Svg` has no loading or error replacement builder.
pub struct Svg {
    interactivity: Interactivity,
    transformation: Option<Transformation>,
    path: Option<SharedString>,
    external_path: Option<SharedString>,
    data: Option<Arc<[u8]>>,
    data_path: Option<SharedString>,
}

/// Constructs a single-color SVG element without a source or intrinsic size.
///
/// Here the bytes are part of the program, so no asset registration is needed:
///
/// ```
/// use gpui::{prelude::*, px, rgb, svg};
///
/// let check = svg()
///     .data(br#"<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16">
///         <path d="M3 8 L7 12 L13 4" fill="none" stroke="black"/>
///     </svg>"#)
///     .size(px(16.))
///     .text_color(rgb(0x155b50));
/// ```
///
/// Choose [`Svg::path`] for a bundled asset, [`Svg::external_path`] for a
/// native file, or [`Svg::data`] for bytes already in memory. If several are
/// set, data takes precedence, then the external path, then the registry path.
/// A source-less SVG paints no icon. Missing registry data also paints no icon;
/// load, parse, and rasterization failures are logged. Handle those errors
/// explicitly with [`SvgRenderer`](crate::SvgRenderer) when the UI must present
/// or recover from them. The [assets chapter](crate::_documentation::assets)
/// explains source selection and loading lifetimes.
#[track_caller]
pub fn svg() -> Svg {
    Svg {
        interactivity: Interactivity::new(),
        transformation: None,
        path: None,
        external_path: None,
        data: None,
        data_path: None,
    }
}

impl Svg {
    /// Selects an exact key in the app's [`AssetRegistry`](crate::AssetRegistry).
    ///
    /// Install the registry with
    /// [`Application::with_assets`](crate::Application::with_assets). A URL
    /// or filesystem spelling is still only a registry key here; this method
    /// does not fetch or read it. On the first uncached paint, registry loading
    /// and rasterization run synchronously. Preload the bytes when an on-demand
    /// registry loader would block that frame.
    ///
    /// Repeated calls replace this path. A source already set through
    /// [`data`](Self::data) or [`external_path`](Self::external_path) takes
    /// precedence. Missing data leaves the icon empty; decoding errors are logged.
    pub fn path(mut self, path: impl Into<SharedString>) -> Self {
        self.path = Some(path.into());
        self
    }

    /// Loads SVG bytes from a filesystem path on the background executor.
    ///
    /// This bypasses [`AssetSource`](crate::AssetSource). It is intended for
    /// native applications; a browser cannot read an arbitrary native path.
    /// While the read is pending, the icon is empty. Completion notifies the
    /// view that started the request. Reading errors are logged and remain in
    /// the typed asset cache; this element has no built-in retry or fallback.
    /// Parsing and rasterization still happen during paint after bytes arrive.
    ///
    /// Repeated calls replace this path. In-memory [`data`](Self::data) takes
    /// precedence over it.
    pub fn external_path(mut self, path: impl Into<SharedString>) -> Self {
        self.external_path = Some(path.into());
        self
    }

    /// Copies SVG bytes into the element and derives their raster-cache key.
    ///
    /// The element owns its copy, so `data` may be a temporary slice. This
    /// method does not validate or rasterize it; parsing happens on an uncached
    /// paint and failures are logged. The content hash supplies a stable key
    /// for reusing the same bytes at the same raster size.
    ///
    /// Repeated calls replace the bytes. In-memory data takes precedence over
    /// both path sources, regardless of which builder was called last.
    pub fn data(mut self, data: &[u8]) -> Self {
        // Generate a unique deterministic path based on the data hash for caching
        let mut hasher = std::collections::hash_map::DefaultHasher::new();
        data.hash(&mut hasher);
        let hash = hasher.finish();
        let path = SharedString::from(format!("__binary_svg__{}", hash));
        self.data = Some(Arc::from(data));
        self.data_path = Some(path);
        self
    }

    /// Replaces the transformation of the painted icon.
    ///
    /// Scale and rotation act about the element's center, then translation
    /// shifts the result in logical pixels. Layout bounds, the hitbox, and
    /// the content mask do not move with it. Size the element for layout and
    /// use this transform for a visual effect, such as rotating a disclosure
    /// icon without moving its clickable row. See [`Transformation`].
    pub fn with_transformation(mut self, transformation: Transformation) -> Self {
        self.transformation = Some(transformation);
        self
    }
}

impl Element for Svg {
    type RequestLayoutState = ();
    type PrepaintState = Option<Hitbox>;

    fn id(&self) -> Option<crate::ElementId> {
        self.interactivity.element_id.clone()
    }

    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        self.interactivity.source_location()
    }

    fn request_layout(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        let layout_id = self.interactivity.request_layout(
            global_id,
            inspector_id,
            window,
            cx,
            |style, window, cx| window.request_layout(style, None, cx),
        );
        (layout_id, ())
    }

    fn prepaint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Hitbox> {
        self.interactivity.prepaint(
            global_id,
            inspector_id,
            bounds,
            bounds.size,
            window,
            cx,
            |_, _, hitbox, _, _| hitbox,
        )
    }

    fn paint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        _request_layout: &mut Self::RequestLayoutState,
        hitbox: &mut Option<Hitbox>,
        window: &mut Window,
        cx: &mut App,
    ) where
        Self: Sized,
    {
        self.interactivity.paint(
            global_id,
            inspector_id,
            bounds,
            hitbox.as_ref(),
            window,
            cx,
            |style, window, cx| {
                let transformation = self
                    .transformation
                    .as_ref()
                    .map(|transformation| {
                        transformation.into_matrix(bounds.center(), window.scale_factor())
                    })
                    .unwrap_or_default();

                if let Some((data, path)) = self.data.as_ref().zip(self.data_path.as_ref()) {
                    if let Some(color) = style.text.color {
                        window
                            .paint_svg(
                                bounds,
                                path.clone(),
                                Some(&**data),
                                transformation,
                                color,
                                cx,
                            )
                            .log_err();
                    }
                } else if let Some((path, color)) =
                    self.external_path.as_ref().zip(style.text.color)
                {
                    let Some(bytes) = window
                        .use_asset::<SvgAsset>(path, cx)
                        .and_then(|asset| asset.log_err())
                    else {
                        return;
                    };

                    window
                        .paint_svg(
                            bounds,
                            path.clone(),
                            Some(&bytes),
                            transformation,
                            color,
                            cx,
                        )
                        .log_err();
                } else if let Some((path, color)) = self.path.as_ref().zip(style.text.color) {
                    window
                        .paint_svg(bounds, path.clone(), None, transformation, color, cx)
                        .log_err();
                }
            },
        )
    }
}

impl IntoElement for Svg {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}

impl Styled for Svg {
    fn style(&mut self) -> &mut StyleRefinement {
        &mut self.interactivity.base_style
    }
}

impl InteractiveElement for Svg {
    fn interactivity(&mut self) -> &mut Interactivity {
        &mut self.interactivity
    }
}

/// Scale, rotation, and translation applied to an SVG's painted pixels.
///
/// Scaling and rotation are about the element's center; translation is in
/// logical pixels and happens afterward. The layout box, hitbox, and clipping
/// region are unchanged. Builders replace their corresponding component,
/// rather than composing another transformation.
///
/// For a half-turn about the icon's center, followed by a two-pixel shift:
///
/// ```
/// use gpui::{Transformation, point, px, radians};
///
/// let transform = Transformation::rotate(radians(std::f32::consts::PI))
///     .with_translation(point(px(2.), px(0.)));
/// assert_eq!(
///     transform.with_rotation(radians(0.)),
///     Transformation::translate(point(px(2.), px(0.))),
/// );
/// ```
///
/// The equality shows replacement: `with_rotation(0)` removes the half-turn.
/// It does not append a second rotation to it.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Transformation {
    scale: Size<f32>,
    translate: Point<Pixels>,
    rotate: Radians,
}

impl Default for Transformation {
    fn default() -> Self {
        Self {
            scale: size(1.0, 1.0),
            translate: point(px(0.0), px(0.0)),
            rotate: radians(0.0),
        }
    }
}

impl Transformation {
    /// Creates a center-relative scale with no rotation or translation.
    ///
    /// `size(1., 1.)` preserves both axes; `size(2., 1.)` doubles only width.
    /// Negative factors reflect the drawing. Use [`Self::with_scaling`] to
    /// change the scale while retaining existing rotation and translation.
    pub fn scale(scale: Size<f32>) -> Self {
        Self {
            scale,
            translate: point(px(0.0), px(0.0)),
            rotate: radians(0.0),
        }
    }

    /// Creates a logical-pixel translation with unit scale and no rotation.
    ///
    /// Positive x moves right and positive y moves down. Use
    /// [`Self::with_translation`] to preserve other transformation components.
    pub fn translate(translate: Point<Pixels>) -> Self {
        Self {
            scale: size(1.0, 1.0),
            translate,
            rotate: radians(0.0),
        }
    }

    /// Creates a center-relative rotation with unit scale and no translation.
    ///
    /// The angle uses [`Radians`]; positive angles rotate clockwise in the
    /// window's downward-y coordinate system. Use [`Self::with_rotation`] to
    /// retain an existing scale and translation.
    pub fn rotate(rotate: impl Into<Radians>) -> Self {
        let rotate = rotate.into();
        Self {
            scale: size(1.0, 1.0),
            translate: point(px(0.0), px(0.0)),
            rotate,
        }
    }

    /// Replaces the scale on each axis, preserving rotation and translation.
    ///
    /// Calling this twice keeps the second scale; it does not multiply them.
    pub fn with_scaling(mut self, scale: Size<f32>) -> Self {
        self.scale = scale;
        self
    }

    /// Replaces the logical-pixel translation, preserving scale and rotation.
    ///
    /// Translation applies after the center-relative scale and rotation.
    pub fn with_translation(mut self, translate: Point<Pixels>) -> Self {
        self.translate = translate;
        self
    }

    /// Replaces the angle in radians, preserving scale and translation.
    ///
    /// Calling this twice keeps the second angle; it does not add them.
    pub fn with_rotation(mut self, rotate: impl Into<Radians>) -> Self {
        self.rotate = rotate.into();
        self
    }

    fn into_matrix(self, center: Point<Pixels>, scale_factor: f32) -> TransformationMatrix {
        //Note: if you read this as a sequence of matrix multiplications, start from the bottom
        TransformationMatrix::unit()
            .translate(center.scale(scale_factor) + self.translate.scale(scale_factor))
            .rotate(self.rotate)
            .scale(self.scale)
            .translate(center.scale(-scale_factor))
    }
}

enum SvgAsset {}

impl Asset for SvgAsset {
    type Source = SharedString;
    type Output = Result<Arc<[u8]>, Arc<std::io::Error>>;

    fn load(
        source: Self::Source,
        _cx: &mut App,
    ) -> impl Future<Output = Self::Output> + Send + 'static {
        async move {
            let bytes = fs::read(Path::new(source.as_ref())).map_err(|e| Arc::new(e))?;
            let bytes = Arc::from(bytes);
            Ok(bytes)
        }
    }
}
