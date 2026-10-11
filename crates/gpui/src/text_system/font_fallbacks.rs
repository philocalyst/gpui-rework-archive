use std::sync::Arc;

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

/// An ordered list of font family names to try when a [`Font`](crate::Font) lacks a glyph.
///
/// Set the list on [`Font::fallbacks`](crate::Font::fallbacks). When the primary
/// family has no glyph for a character, the text system tries these families in
/// order. Use this for scripts or symbols that your main font doesn't cover, such
/// as emoji or CJK text.
///
/// # Examples
///
/// ```
/// # use gpui::{FontFallbacks, font};
/// let mut body = font("Lilex");
/// body.fallbacks = Some(FontFallbacks::from_fonts(vec![
///     "Noto Sans Arabic".to_string(),
/// ]));
/// assert_eq!(body.fallbacks.unwrap().fallback_list(), ["Noto Sans Arabic"]);
/// ```
#[derive(Default, Clone, Eq, PartialEq, Hash, Debug, Deserialize, Serialize, JsonSchema)]
pub struct FontFallbacks(pub Arc<Vec<String>>);

impl FontFallbacks {
    /// Returns the fallback family names in the order they are tried.
    pub fn fallback_list(&self) -> &[String] {
        self.0.as_slice()
    }

    /// Creates a fallback list from family names, tried in the order given.
    pub fn from_fonts(fonts: Vec<String>) -> Self {
        FontFallbacks(Arc::new(fonts))
    }
}
