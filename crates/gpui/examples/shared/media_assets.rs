use std::borrow::Cow;

use gpui::{AssetSource, SharedString};

/// Embedded resources shared by the image loading and GIF examples.
pub struct MediaAssets;

impl AssetSource for MediaAssets {
    fn load(&self, path: &str) -> anyhow::Result<Option<Cow<'static, [u8]>>> {
        let bytes = match path {
            "images/app-icon.png" => &include_bytes!("../assets/images/app-icon.png")[..],
            "images/typing-cat.gif" => &include_bytes!("../assets/images/black-cat-typing.gif")[..],
            _ => return Ok(None),
        };
        Ok(Some(Cow::Borrowed(bytes)))
    }

    fn list(&self, _path: &str) -> anyhow::Result<Vec<SharedString>> {
        Ok(vec![
            "images/app-icon.png".into(),
            "images/typing-cat.gif".into(),
        ])
    }
}
