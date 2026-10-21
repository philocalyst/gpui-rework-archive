//! CPU canvas with extended-linear source-over and profiled premultiplied RGBA8.
#![forbid(unsafe_code)]
pub use gpui_reactivity_core::{Affine, Point, Rect};
mod canvas;
mod color;
mod text;
pub use canvas::{Canvas, CanvasScene, GlyphMask, PreparedDraw, PreparedScene, RenderStats};
pub use color::{Color, ColorConfig, ColorSpace, OutputProfile, PixelFormat, SdrMapping, rgb};
pub use text::{FontFace, Glyph, GlyphKey, TextLayout, TextSystem};

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Error {
    InvalidDimensions,
    InvalidGeometry,
    InvalidFont,
    InvalidFontSize,
    InvalidWidth,
    ResourceLimit,
    UnsupportedDirection,
    UnsupportedScript(char),
    UnsupportedControl(char),
    MissingGlyph(char),
    ForeignLayout,
    InvalidColor,
    ColorOutOfRange,
    UnsupportedPixelFormat,
}
impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for Error {}

#[cfg(feature = "parallel")]
pub use canvas::{ParallelError, RenderPool};
