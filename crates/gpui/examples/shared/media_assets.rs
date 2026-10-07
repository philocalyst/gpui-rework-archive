use std::borrow::Cow;

use gpui::{AssetSource, SharedString};

/// Small visual fixtures embedded into both native examples and CPU captures.
pub struct MediaAssets;

impl AssetSource for MediaAssets {
    fn load(&self, path: &str) -> anyhow::Result<Option<Cow<'static, [u8]>>> {
        let bytes = match path {
            "images/app-icon.png" => &include_bytes!("../gallery/rendering/image/app-icon.png")[..],
            "images/typing-cat.gif" => {
                &include_bytes!("../gallery/rendering/image/black-cat-typing.gif")[..]
            }
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
