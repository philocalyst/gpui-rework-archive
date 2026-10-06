#![cfg_attr(target_family = "wasm", no_main)]

#[path = "../../shared/prelude.rs"]
mod example_prelude;
#[path = "../../example_support/fonts.rs"]
mod example_support;

use std::{
    path::{Path, PathBuf},
    sync::Arc,
    time::Duration,
};

use gpui::{
    Animation, AnimationExt, App, AppContext as _, Asset, AssetLogger, AssetSource, Context, Hsla,
    ImageAssetLoader, ImageCacheError, ImgResourceLoader, LOADING_DELAY, Length, RenderImage,
    Resource, SharedString, Window, black, div, img, prelude::*, pulsating_between, px, red,
};
use gpui_platform::application;
use palette::WithAlpha;

struct Assets {
    base: PathBuf,
}

impl AssetSource for Assets {
    fn load(&self, path: &str) -> anyhow::Result<Option<std::borrow::Cow<'static, [u8]>>> {
        std::fs::read(resolve_path(&self.base, path))
            .map(Into::into)
            .map_err(Into::into)
            .map(Some)
    }

    fn list(&self, path: &str) -> anyhow::Result<Vec<SharedString>> {
        Ok(std::fs::read_dir(resolve_path(&self.base, path))?
            .filter_map(|entry| {
                Some(SharedString::from(
                    entry.ok()?.file_name().to_string_lossy().into_owned(),
                ))
            })
            .collect::<Vec<_>>())
    }
}

fn resolve_path(base: &Path, path: &str) -> PathBuf {
    let path = Path::new(path);
    if path.is_absolute() {
        path.to_path_buf()
    } else {
        base.join(path)
    }
}

const IMAGE: &str = concat!(
    env!("CARGO_MANIFEST_DIR"),
    "/examples/gallery/rendering/image/app-icon.png"
);

#[derive(Copy, Clone, Hash)]
struct LoadImageParameters {
    timeout: Duration,
    fail: bool,
}

struct LoadImageWithParameters {}

impl Asset for LoadImageWithParameters {
    type Source = LoadImageParameters;

    type Output = Result<Arc<RenderImage>, ImageCacheError>;

    fn load(
        parameters: Self::Source,
        cx: &mut App,
    ) -> impl std::future::Future<Output = Self::Output> + Send + 'static {
        let timer = cx.background_executor().timer(parameters.timeout);
        let data = AssetLogger::<ImageAssetLoader>::load(
            Resource::Path(Path::new(IMAGE).to_path_buf().into()),
            cx,
        );
        async move {
            timer.await;
            if parameters.fail {
                log::error!("Intentionally failed to load image");
                Err(anyhow::anyhow!("Failed to load image").into())
            } else {
                data.await
            }
        }
    }
}

struct ImageLoadingExample {}

impl ImageLoadingExample {
    fn loading_element() -> impl IntoElement {
        div().size_full().flex_none().p_0p5().rounded_xs().child(
            div().size_full().with_animation(
                "loading-bg",
                Animation::new(Duration::from_secs(3))
                    .repeat()
                    .with_easing(pulsating_between(0.04, 0.24)),
                move |this, delta| this.bg(black().with_alpha(delta)),
            ),
        )
    }

    fn fallback_element() -> impl IntoElement {
        let fallback_color: Hsla = black().with_alpha(0.5);

        div().size_full().flex_none().p_0p5().child(
            div()
                .size_full()
                .flex()
                .items_center()
                .justify_center()
                .rounded_xs()
                .text_sm()
                .text_color(fallback_color)
                .border_1()
                .border_color(fallback_color)
                .child("?"),
        )
    }
}

fn parameterized_image(id: &'static str, timeout: Duration, fail: bool) -> impl IntoElement {
    let source = LoadImageParameters { timeout, fail };
    img(move |window: &mut Window, cx: &mut App| {
        window.use_asset::<LoadImageWithParameters>(&source, cx)
    })
    .id(id)
    .border_1()
    .size_12()
    .with_fallback(|| ImageLoadingExample::fallback_element().into_any_element())
    .border_color(red())
    .with_loading(|| ImageLoadingExample::loading_element().into_any_element())
    .on_click(move |_, _, cx| cx.remove_asset::<LoadImageWithParameters>(&source))
}

impl Render for ImageLoadingExample {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div().flex().flex_col().size_full().justify_around().child(
            div().flex().flex_row().w_full().justify_around().child(
                div()
                    .flex()
                    .bg(gpui::white())
                    .size(Length::Definite(px(300.0).into()))
                    .justify_center()
                    .items_center()
                    // This one resolves before the loading delay; the next two exercise waiting and failure.
                    .child(parameterized_image(
                        "image-1",
                        LOADING_DELAY.saturating_sub(Duration::from_millis(25)),
                        false,
                    ))
                    .child(parameterized_image(
                        "image-2",
                        Duration::from_secs(5),
                        false,
                    ))
                    .child(parameterized_image("image-3", Duration::from_secs(5), true))
                    .child({
                        // Ensure that the normal image loader doesn't spam logs
                        let image_source = Path::new(env!("CARGO_MANIFEST_DIR"))
                            .join("examples/gallery/rendering/image/__intentionally_missing.png");
                        img(image_source.clone())
                            .id("image-4")
                            .border_1()
                            .size_12()
                            .with_fallback(|| Self::fallback_element().into_any_element())
                            .border_color(red())
                            .with_loading(|| Self::loading_element().into_any_element())
                            .on_click(move |_, _, cx| {
                                cx.remove_asset::<ImgResourceLoader>(&image_source.clone().into());
                            })
                    }),
            ),
        )
    }
}

fn run_example() {
    application()
        .with_assets(Assets {
            base: PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("examples/gallery/rendering"),
        })
        .run(|cx: &mut App| {
            if !example_support::load_fonts(cx) {
                return;
            }
            let options = example_prelude::centered_window(500., 320., cx);
            cx.open_window(options, |_, cx| cx.new(|_| ImageLoadingExample {}))
                .expect("open image loading example");
            example_prelude::init_example(cx, "Image Loading");
        });
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    env_logger::init();
    run_example();
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    run_example();
}
