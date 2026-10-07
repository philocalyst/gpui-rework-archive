#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;
#[path = "../../shared/media_assets.rs"]
mod media_assets;

use gpui::{
    App, AppContext as _, Asset, Context, Entity, ImageAssetLoader, Render, RenderImage, Window,
    img, prelude::*, px, size,
};
use std::sync::Arc;

struct GifViewer {
    image: Arc<RenderImage>,
}

impl Render for GifViewer {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        img(self.image.clone())
            // Img keeps its frame index and last simulated tick in element state under this ID.
            .id("gif-viewer-image")
            .size_full()
            .object_fit(gpui::ObjectFit::Contain)
    }
}

fn gif_viewer(window: &mut Window, cx: &mut App) -> Entity<GifViewer> {
    window.activate();
    let resource = gpui::Resource::Embedded("images/typing-cat.gif".into());
    let image = futures::executor::block_on(ImageAssetLoader::load(resource, cx))
        .expect("decode embedded GIF");
    cx.new(|_| GifViewer { image })
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example_with_assets(
        "Animated GIF",
        size(px(640.), px(480.)),
        Arc::new(media_assets::MediaAssets),
        gif_viewer,
    );
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example_with_assets(
        "Animated GIF",
        size(px(640.), px(480.)),
        Arc::new(media_assets::MediaAssets),
        gif_viewer,
    );
}
