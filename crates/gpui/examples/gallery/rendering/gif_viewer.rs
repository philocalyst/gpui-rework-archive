#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;
#[path = "../../shared/media_assets.rs"]
mod media_assets;

use gpui::{
    App, Asset, Context, ImageAssetLoader, Render, RenderImage, Window, img, prelude::*, px, size,
};
use std::{sync::Arc, time::Duration};

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

fn gif_scenario() -> anyhow::Result<gpui_test::Scenario<GifViewer>> {
    gpui_test::Scenario::new(
        "gif-viewer",
        "Animated GIF",
        size(px(640.), px(480.)),
        |window, cx: &mut App| {
            // Image animation is paused in inactive windows; activate captures just as a native
            // window does so fixed-clock checkpoints can observe real frame changes.
            window.activate();
            // Decode the embedded bytes once so the simulated image clock starts on first paint.
            let resource = gpui::Resource::Embedded("images/typing-cat.gif".into());
            let image = futures::executor::block_on(ImageAssetLoader::load(resource, cx))
                .expect("decode embedded GIF");
            cx.new(|_| GifViewer { image })
        },
    )?
    .checkpoint("start", "First animation frame", Duration::ZERO)?
    .checkpoint(
        "middle",
        "Animation advances at simulated time",
        Duration::from_millis(500),
    )?
    .checkpoint(
        "loop",
        "Animation returns after a full cycle",
        Duration::from_secs(1),
    )
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example_with_assets(
        gif_scenario().expect("valid GIF scenario"),
        Arc::new(media_assets::MediaAssets),
    )
    .expect("run GIF viewer");
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example_with_assets(
        gif_scenario().expect("valid GIF scenario"),
        Arc::new(media_assets::MediaAssets),
    )
    .expect("run GIF viewer");
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_test::Harness;

    #[test]
    fn simulated_clock_advances_and_loops_the_embedded_gif() -> anyhow::Result<()> {
        let rendered = Harness::new()
            .with_asset_source(Arc::new(media_assets::MediaAssets))
            .run(&gif_scenario()?)?;
        let frames = &rendered.checkpoints;
        anyhow::ensure!(frames.len() == 3, "unexpected GIF checkpoints");
        anyhow::ensure!(
            frames[0].image != frames[1].image,
            "the midpoint should render a different GIF frame"
        );
        anyhow::ensure!(
            frames[0].image == frames[2].image,
            "the full cycle should return to the initial GIF frame"
        );
        Ok(())
    }
}
