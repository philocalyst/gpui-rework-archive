//! CPU canvas with extended-linear source-over and profiled premultiplied output.
#![forbid(unsafe_code)]
pub use gpui_reactivity_core::{Affine, Point, Rect};
mod canvas;
mod color;
mod damage;
mod image;
mod text;
pub use canvas::{
    Canvas, CanvasScene, GlyphMask, PreparedDraw, PreparedGroup, PreparedPlacement, PreparedScene,
    PreparedSource, RenderStats, SceneStorage, sampled_rect_clip,
};
pub use color::{
    Color, ColorConfig, ColorSpace, FloatRangePolicy, OutputMetadata, OutputProfile,
    OutputTransfer, PixelFormat, SdrMapping, oklch, rgb,
};
pub use damage::DamageRegion;
pub use image::{
    AlphaMode, Image, ImageKey, ImagePixels, ImageProfile, ImageSampling, ImageView,
    MAX_IMAGE_SCENE_BYTES,
};
pub use text::{
    CaretAffinity, FontFace, Glyph, GlyphKey, GlyphRun, TextDirection, TextLayout, TextLine,
    TextOffset, TextPosition, TextSelection, TextShaper, TextSystem,
};

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Error {
    InvalidDimensions,
    InvalidGeometry,
    InvalidFont,
    UnsupportedFontFormat,
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
    UnsupportedOutputProfile,
    NonOpaqueOutput,
    InvalidImageLength,
    InvalidImageAlpha,
}
impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for Error {}

#[cfg(feature = "parallel")]
pub use canvas::{ParallelError, RenderPool};
