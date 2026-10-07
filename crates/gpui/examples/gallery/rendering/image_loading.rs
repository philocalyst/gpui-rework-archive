//! One image, three cache states: ready quickly, delayed, and failed with a fallback.

#[path = "../../shared/prelude.rs"]
mod example_prelude;
#[path = "../../shared/media_assets.rs"]
mod media_assets;

use std::{sync::Arc, time::Duration};

use gpui::{
    Animation, AnimationExt, App, AppContext as _, Asset, AssetLogger, Context, Hsla,
    ImageAssetLoader, ImageCacheError, RenderImage, Resource, Window, black, div, img, prelude::*,
    pulsating_between, px, red, rgb,
};
use palette::WithAlpha;

#[derive(Clone, Copy, Hash)]
struct LoadParameters {
    delay: Duration,
    fail: bool,
}

struct ParameterizedImage;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum LoadState {
    Pending,
    Ready,
    Failed,
}

impl Asset for ParameterizedImage {
    type Source = LoadParameters;
    type Output = Result<Arc<RenderImage>, ImageCacheError>;

    fn load(
        parameters: Self::Source,
        cx: &mut App,
    ) -> impl Future<Output = Self::Output> + Send + 'static {
        let timer = cx.background_executor().timer(parameters.delay);
        let image = AssetLogger::<ImageAssetLoader>::load(
            Resource::Embedded("images/app-icon.png".into()),
            cx,
        );
        async move {
            timer.await;
            if parameters.fail {
                Err(anyhow::anyhow!("The failure state is deliberate").into())
            } else {
                image.await
            }
        }
    }
}

struct ImageLoading {
    states: [LoadState; 3],
}

impl ImageLoading {
    fn new() -> Self {
        Self {
            states: [LoadState::Pending; 3],
        }
    }
}

impl ImageLoading {
    fn loading() -> gpui::AnyElement {
        div()
            .size_full()
            .rounded_md()
            .bg(rgb(0x94a3b8))
            .with_animation(
                "loading",
                Animation::new(Duration::from_secs(2))
                    .repeat()
                    .with_easing(pulsating_between(0.15, 0.65)),
                |element, opacity| element.opacity(opacity),
            )
            .into_any_element()
    }

    fn fallback() -> gpui::AnyElement {
        let muted: Hsla = black().with_alpha(0.55);
        div()
            .size_full()
            .flex()
            .items_center()
            .justify_center()
            .rounded_md()
            .border_1()
            .border_color(muted)
            .text_color(muted)
            .child("Load failed")
            .into_any_element()
    }

    fn preview(id: &'static str, delay: Duration, fail: bool) -> impl IntoElement + use<> {
        let source = LoadParameters { delay, fail };
        img(move |window: &mut Window, cx: &mut App| {
            window.use_asset::<ParameterizedImage>(&source, cx)
        })
        .id(id)
        .debug_selector(move || id.into())
        .size(px(112.))
        .border_1()
        .border_color(red())
        .with_loading(Self::loading)
        .with_fallback(Self::fallback)
        .on_click(move |_, _, cx| cx.remove_asset::<ParameterizedImage>(&source))
    }
}

impl Render for ImageLoading {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let samples = [
            ("Ready", Duration::from_millis(80), false),
            ("Waiting", Duration::from_secs(3), false),
            ("Fallback", Duration::from_secs(3), true),
        ];
        self.states = samples.map(|(_, delay, fail)| {
            match window.use_asset::<ParameterizedImage>(&LoadParameters { delay, fail }, cx) {
                None => LoadState::Pending,
                Some(Ok(_)) => LoadState::Ready,
                Some(Err(_)) => LoadState::Failed,
            }
        });
        div()
            .size_full()
            .flex()
            .flex_col()
            .gap_4()
            .p_5()
            .child(
                div()
                    .text_xl()
                    .font_weight(gpui::FontWeight::BOLD)
                    .child("Image loading"),
            )
            .child("Click a sample to evict its cache entry and load it again.")
            .child(
                div()
                    .flex()
                    .flex_wrap()
                    .gap_4()
                    .children(samples.into_iter().map(|(label, delay, fail)| {
                        div()
                            .flex()
                            .flex_col()
                            .gap_2()
                            .p_3()
                            .rounded_lg()
                            .bg(rgb(0xf1f3f6))
                            .child(ImageLoading::preview(label, delay, fail))
                            .child(label)
                    })),
            )
    }
}

fn image_loading_scenario() -> anyhow::Result<gpui_test::Scenario<ImageLoading>> {
    gpui_test::Scenario::new(
        "image-loading",
        "Image loading states",
        gpui::size(px(520.), px(320.)),
        |_, cx: &mut App| cx.new(|_| ImageLoading::new()),
    )?
    .checkpoint("loading", "Loading begins", Duration::ZERO)?
    .checkpoint_with(
        "ready",
        "Fast image is ready while the delayed sample still shows its placeholder",
        Duration::from_millis(250),
        |cx, view, window| {
            cx.draw_window(window.into())?;
            let states = view.read_with(cx, |view, _| view.states);
            anyhow::ensure!(
                states == [LoadState::Ready, LoadState::Pending, LoadState::Pending],
                "unexpected image cache states: {states:?}"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "fallback",
        "Delayed failure reaches the fallback after other assets load",
        Duration::from_secs(3),
        |cx, view, window| {
            cx.draw_window(window.into())?;
            let states = view.read_with(cx, |view, _| view.states);
            anyhow::ensure!(
                states == [LoadState::Ready, LoadState::Ready, LoadState::Failed],
                "unexpected image cache states: {states:?}"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "retry-pending",
        "Click evicts the failed image and returns the cache entry to pending",
        Duration::from_millis(3_100),
        |cx, view, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "Fallback")?;
            cx.draw_window(window.into())?;
            let states = view.read_with(cx, |view, _| view.states);
            anyhow::ensure!(
                states == [LoadState::Ready, LoadState::Ready, LoadState::Pending],
                "retry did not return to pending: {states:?}"
            );
            Ok(())
        },
    )
}

fn main() {
    let scenario = image_loading_scenario().expect("valid image loading scenario");
    example_prelude::run_example_with_assets(scenario, Arc::new(media_assets::MediaAssets))
        .expect("run image loading example");
}
