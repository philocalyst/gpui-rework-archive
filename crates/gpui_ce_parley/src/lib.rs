//! Shared text shaping and glyph rasterization built on Parley.
//!
//! [`ParleyTextSystem`] implements GPUI's platform text-system trait. Parley resolves fonts, shapes
//! runs, and produces line/document geometry; the injected [`GlyphRasterizer`] turns selected glyph
//! instances into pixel buffers for the renderer. Applications can choose whether to enumerate
//! operating-system fonts with [`SystemFonts`], register font bytes, provide a rasterizer, and add
//! fallback families.
//!
//! Font catalog setup is separate from text layout. The browser platform starts with
//! [`SystemFonts::Skip`], so register embedded font data before opening a window when the
//! application needs deterministic text. With either catalog mode, explicit styles and registered
//! family names are resolved before configured fallback families. Layout, selection, visual-line,
//! and glyph ranges are UTF-8 byte offsets, even when one shaped cluster covers several Unicode
//! scalars or bidirectional text paints in a different visual order.
//!
//! ```no_run
//! use std::borrow::Cow;
//! use gpui::{PlatformTextSystem, TextSystem};
//! use gpui_ce_parley::{ParleyTextSystem, SystemFonts};
//!
//! let backend = ParleyTextSystem::new(SystemFonts::Skip)
//!     .with_fallback_families(["Noto Sans", "Noto Color Emoji"]);
//! // Replace these bytes with a bundled TTF/OTF byte slice in an application.
//! let font_bytes: &'static [u8] = b"";
//! backend.add_fonts(vec![Cow::Borrowed(font_bytes)])?;
//! let system = TextSystem::new(std::sync::Arc::new(backend));
//! # let _ = system;
//! # Ok::<(), anyhow::Error>(())
//! ```

mod catalog;
#[cfg(test)]
mod font_fixtures {
    include!("font_fixtures.rs");
    include!("font_fixtures_tests.rs");
}
mod store;
mod text_system;

pub use catalog::SystemFonts;
/// Shared owner for registered font bytes.
///
/// Use a blob when font data should be retained and shared by a font collection without copying
/// it into each individual face.
pub use fontique::Blob as FontDataBlob;
pub use store::{
    BitmapFallbackGlyphRasterizer, ColorGlyphKind, FontSynthesis, FontVariation, GlyphRasterizer,
    RasterFace, SwashGlyphRasterizer,
};
pub use text_system::ParleyTextSystem;

pub(crate) use store::FontStore;
