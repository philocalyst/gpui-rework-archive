use std::sync::Arc;

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

/// Ordered family names consulted when the primary font lacks a character.
#[derive(Default, Clone, Eq, PartialEq, Hash, Debug, Deserialize, Serialize, JsonSchema)]
pub struct FontFallbacks(pub Arc<Vec<String>>);

impl FontFallbacks {
    /// Borrow the configured fallback family names in lookup order.
    pub fn fallback_list(&self) -> &[String] {
        self.0.as_slice()
    }

    /// Build fallback policy from family names.
    pub fn from_fonts(fonts: Vec<String>) -> Self {
        FontFallbacks(Arc::new(fonts))
    }
}
