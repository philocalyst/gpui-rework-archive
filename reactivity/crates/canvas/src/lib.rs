//! CPU canvas with extended-linear source-over and profiled premultiplied output.
#![deny(unsafe_code)]
pub use gpui_reactivity_core::{Affine, Point, Rect};
mod canvas;
mod color;
mod damage;
mod image;
mod text;
pub use canvas::{
    Canvas, CanvasScene, CanvasAcceptedSceneView, CheckedSlotMutation, PublicationError, Clip, ClipChain, ClipGeometry, ClipId, ClipShape, GlyphMask,
    MAX_CLIP_DEPTH, MAX_CLIP_NODES, PaintColor, PaintCommit, PaintEdit, PaintError, PaintErrorKind,
    PaintIndex, PaintSlot, PreparedClipNode, PreparedDraw, PreparedGroup, PreparedPaint,
    PreparedPlacement, PreparedScene, PreparedSource, RenderStats, SceneStorage, SlotCommit,
    SlotEdit, SlotError, SlotErrorKind, rounded_rect_contains, sampled_rect_clip,
};
pub use color::gradient::{
    Extend, Gradient, GradientGeometry, GradientKey, GradientStop, GradientView, Interpolation,
    MAX_GRADIENT_STOPS,
};
pub use color::{
    Color, ColorConfig, ColorSpace, FloatRangePolicy, OutputMetadata, OutputProfile,
    OutputTransfer, PixelFormat, SdrMapping, oklch, rgb,
};
pub use damage::DamageRegion;
pub use image::{
    AlphaMode, Image, ImageKey, ImageOptions, ImagePixels, ImageProfile, ImageSampling, ImageView,
    MAX_IMAGE_SCENE_BYTES,
};
pub use text::{
    CaretAffinity, FontFace, Glyph, GlyphKey, GlyphRun, TextDirection, TextGeometry, TextGrapheme,
    TextLayout, TextLine, TextMetrics, TextOffset, TextPosition, TextRun, TextSelection,
    TextShaper, TextSystem,
};

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Error {
    InvalidDimensions,
    InvalidGeometry,
    InvalidClip,
    InvalidPaintSlot,
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
    InvalidGradient,
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
