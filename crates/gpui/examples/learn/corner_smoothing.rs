//! Corner smoothing
//!
//! Adjust a rounded rectangle's smoothing, radius, width, and height.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{App, Context, Window, div, prelude::*, px, rgb, rgba, size};
use palette::WithAlpha;
use slider::Slider;
use std::time::Duration;

const INITIAL_SIZE: f32 = 200.;
const MIN_SIZE: f32 = 20.;
const MAX_SIZE: f32 = 280.;

struct CornerSmoothingExample {
    corner_smoothing: f32,
    corner_radius: f32,
    width: f32,
    height: f32,
}

impl CornerSmoothingExample {
    fn clamp_corner_radius(&mut self) {
        self.corner_radius = self.corner_radius.min(self.width.min(self.height) / 2.);
    }
}

impl Render for CornerSmoothingExample {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let max_corner_radius = self.width.min(self.height) / 2.;

        div()
            .relative()
            .size_full()
            .bg(rgb(0x110f15))
            .child(
                div()
                    .absolute()
                    .inset_0()
                    .flex()
                    .items_center()
                    .justify_center()
                    .pb(px(200.))
                    .child(
                        div().flex().flex_col().items_center().gap(px(28.)).child(
                            div()
                                .w(px(self.width))
                                .h(px(self.height))
                                .rounded(px(self.corner_radius))
                                .rounded_smoothing(self.corner_smoothing)
                                .bg(rgba(0x663399b8).with_alpha(0.5)),
                        ),
                    ),
            )
            .child(
                div()
                    .absolute()
                    .left(px(0.))
                    .right(px(0.))
                    .bottom(px(48.))
                    .flex()
                    .justify_center()
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .items_center()
                            .gap(px(20.))
                            .child(
                                div()
                                    .flex()
                                    .gap(px(32.))
                                    .child(
                                        Slider::new(
                                            "corner-smoothing-slider",
                                            "Corner smoothing",
                                            self.corner_smoothing,
                                            0.,
                                            1.,
                                        )
                                        .display_value(format!("{:.2}", self.corner_smoothing))
                                        .on_change(
                                            cx.processor(|this, smoothing, _window, cx| {
                                                this.corner_smoothing = smoothing;
                                                cx.notify();
                                            }),
                                        ),
                                    )
                                    .child(
                                        Slider::new(
                                            "radius-slider",
                                            "Radius",
                                            self.corner_radius,
                                            0.,
                                            max_corner_radius,
                                        )
                                        .on_change(
                                            cx.processor(|this, radius, _window, cx| {
                                                this.corner_radius = radius;
                                                cx.notify();
                                            }),
                                        ),
                                    ),
                            )
                            .child(
                                div()
                                    .flex()
                                    .gap(px(32.))
                                    .child(
                                        Slider::new(
                                            "width-slider",
                                            "Width",
                                            self.width,
                                            MIN_SIZE,
                                            MAX_SIZE,
                                        )
                                        .on_change(
                                            cx.processor(|this, width, _window, cx| {
                                                this.width = width;
                                                this.clamp_corner_radius();
                                                cx.notify();
                                            }),
                                        ),
                                    )
                                    .child(
                                        Slider::new(
                                            "height-slider",
                                            "Height",
                                            self.height,
                                            MIN_SIZE,
                                            MAX_SIZE,
                                        )
                                        .on_change(
                                            cx.processor(|this, height, _window, cx| {
                                                this.height = height;
                                                this.clamp_corner_radius();
                                                cx.notify();
                                            }),
                                        ),
                                    ),
                            ),
                    ),
            )
    }
}

fn smoothing_scenario() -> anyhow::Result<gpui_test::Scenario<CornerSmoothingExample>> {
    gpui_test::Scenario::new(
        "corner-smoothing",
        "Corner smoothing",
        size(px(500.), px(650.)),
        |_, cx: &mut App| {
            cx.new(|_| CornerSmoothingExample {
                corner_smoothing: 1.,
                corner_radius: 40.,
                width: INITIAL_SIZE,
                height: INITIAL_SIZE,
            })
        },
    )?
    .checkpoint("default", "Rounded rectangle", Duration::ZERO)?
    .checkpoint_with(
        "smoothing-midpoint",
        "Mouse input changes corner smoothing",
        Duration::from_millis(100),
        |cx, view, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "corner-smoothing-slider")?;
            let smoothing = view.read_with(cx, |view, _| view.corner_smoothing);
            anyhow::ensure!(
                (smoothing - 0.5).abs() < 0.01,
                "slider center set smoothing to {smoothing}"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "minimum-size-clamps-radius",
        "Reducing width clamps the corner radius",
        Duration::from_millis(200),
        |cx, view, window| {
            set_slider(cx, window.into(), "width-slider", 0.)?;
            let (width, radius) = view.read_with(cx, |view, _| (view.width, view.corner_radius));
            anyhow::ensure!(width == MIN_SIZE, "minimum width was {width}");
            anyhow::ensure!(radius <= MIN_SIZE / 2., "radius was not clamped: {radius}");
            Ok(())
        },
    )
}

fn main() {
    example_prelude::run_example(smoothing_scenario().expect("valid smoothing scenario"))
        .expect("run corner smoothing example");
}

fn set_slider(
    cx: &mut gpui::HeadlessAppContext,
    window: gpui::AnyWindowHandle,
    selector: &str,
    fraction: f32,
) -> anyhow::Result<()> {
    let bounds = cx
        .debug_bounds(window, selector)?
        .ok_or_else(|| anyhow::anyhow!("slider {selector:?} is missing"))?;
    let position = gpui::point(
        bounds.left() + bounds.size.width * fraction,
        bounds.center().y,
    );
    gpui_test::dispatch_input(
        cx,
        window,
        gpui::PlatformInput::MouseDown(gpui::MouseDownEvent {
            button: gpui::MouseButton::Left,
            position,
            modifiers: gpui::Modifiers::default(),
            click_count: 1,
            first_mouse: false,
        }),
    )?;
    gpui_test::dispatch_input(
        cx,
        window,
        gpui::PlatformInput::MouseUp(gpui::MouseUpEvent {
            button: gpui::MouseButton::Left,
            position,
            modifiers: gpui::Modifiers::default(),
            click_count: 1,
        }),
    )?;
    Ok(())
}

#[path = "corner_smoothing/slider.rs"]
mod slider;
