use std::sync::Arc;

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

/// Preferred font families after the primary family in a [`Font`](crate::Font) request.
///
/// Fallback can supply a face when the primary family is unavailable or cannot draw a
/// character. One string can consequently use several faces. The backend can also consult
/// its own configured and system fallbacks after these names; this list does not exclude them.
/// An empty list adds no preferred families.
///
/// ```
/// use gpui::{FontFallbacks, div, font, prelude::*};
///
/// let mut request = font("IBM Plex Sans");
/// request.fallbacks = Some(FontFallbacks::from_fonts(vec![
///     "Noto Sans Arabic".into(),
///     "Noto Color Emoji".into(),
/// ]));
/// let label = div().font(request).child("مرحباً 👋");
/// ```
///
/// Names do not load font files. Install the families on the host or register their bytes
/// through [`TextSystem::add_fonts`](crate::TextSystem::add_fonts). The browser backend
/// needs registered bytes; naming a desktop font does not make it available there. See the
/// [text chapter](crate::_documentation::text) for the relationship between font requests,
/// shaped glyphs, and measured geometry.
#[derive(Default, Clone, Eq, PartialEq, Hash, Debug, Deserialize, Serialize, JsonSchema)]
pub struct FontFallbacks(pub Arc<Vec<String>>);

impl FontFallbacks {
    /// Borrow the configured fallback family names in lookup order.
    pub fn fallback_list(&self) -> &[String] {
        self.0.as_slice()
    }

    /// Store preferred families in order, without resolving or validating their names.
    /// Clones share this list through its [`Arc`].
    pub fn from_fonts(fonts: Vec<String>) -> Self {
        FontFallbacks(Arc::new(fonts))
    }
}
