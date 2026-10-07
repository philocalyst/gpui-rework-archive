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
    Ok(gpui_test::Scenario::new(
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
    )?)
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

mod slider {
    use std::{cell::Cell, rc::Rc};

    use gpui::{
        App, Bounds, ColorExt, Context, DragMoveEvent, MouseButton, Pixels, Window, div,
        prelude::*, px, relative, rgb,
    };

    const WIDTH: f32 = 180.;

    type ChangeHandler = Rc<dyn Fn(f32, &mut Window, &mut App)>;

    #[derive(Clone)]
    struct SliderDrag {
        id: &'static str,
    }

    impl Render for SliderDrag {
        fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
            gpui::Empty
        }
    }

    #[derive(IntoElement)]
    pub struct Slider {
        id: &'static str,
        label: &'static str,
        value: f32,
        min: f32,
        max: f32,
        value_text: String,
        on_change: Option<ChangeHandler>,
    }

    impl Slider {
        pub fn new(id: &'static str, label: &'static str, value: f32, min: f32, max: f32) -> Self {
            Self {
                id,
                label,
                value,
                min,
                max,
                value_text: format!("{value:.0}px"),
                on_change: None,
            }
        }

        pub fn display_value(mut self, value: impl Into<String>) -> Self {
            self.value_text = value.into();
            self
        }

        pub fn on_change(
            mut self,
            callback: impl Fn(f32, &mut Window, &mut App) + 'static,
        ) -> Self {
            self.on_change = Some(Rc::new(callback));
            self
        }

        fn value_from_position(
            position_x: Pixels,
            bounds: Bounds<Pixels>,
            min: f32,
            max: f32,
        ) -> f32 {
            let position = (position_x - bounds.left()).clamp(px(0.), bounds.size.width);
            let percentage = position / bounds.size.width;
            min + (max - min) * percentage
        }
    }

    impl RenderOnce for Slider {
        fn render(self, _window: &mut Window, _cx: &mut App) -> impl IntoElement {
            let percentage = ((self.value - self.min) / (self.max - self.min)).clamp(0., 1.);
            let track_bounds = Rc::new(Cell::new(None));

            let click_bounds = track_bounds.clone();
            let click_handler = self.on_change.clone();
            let drag_handler = self.on_change.clone();
            let id = self.id;
            let min = self.min;
            let max = self.max;

            let track = div()
                .id(id)
                .debug_selector(move || id.into())
                .relative()
                .w_full()
                .h(px(24.))
                .flex()
                .items_center()
                .cursor_pointer()
                .on_mouse_down(MouseButton::Left, move |event, window, cx| {
                    if let (Some(bounds), Some(handler)) = (click_bounds.get(), &click_handler) {
                        handler(
                            Slider::value_from_position(event.position.x, bounds, min, max),
                            window,
                            cx,
                        );
                    }
                })
                .on_drag(SliderDrag { id }, |drag, _, _, cx| cx.new(|_| drag.clone()))
                .on_drag_move(move |event: &DragMoveEvent<SliderDrag>, window, cx| {
                    let is_active_slider = event.drag(cx).id == id;
                    if is_active_slider && let Some(handler) = &drag_handler {
                        handler(
                            Slider::value_from_position(
                                event.event.position.x,
                                event.bounds,
                                min,
                                max,
                            ),
                            window,
                            cx,
                        );
                    }
                })
                .child(
                    div()
                        .relative()
                        .w_full()
                        .h(px(6.))
                        .rounded_full()
                        .bg(rgb(0xffffff).opacity(0.18))
                        .child(
                            div()
                                .absolute()
                                .left(px(0.))
                                .right(relative(1. - percentage))
                                .h_full()
                                .rounded_full()
                                .bg(rgb(0x9b6dce)),
                        )
                        .child(
                            div()
                                .absolute()
                                .top(px(-5.))
                                .left(relative(percentage))
                                .ml(px(-8.))
                                .size(px(16.))
                                .rounded_full()
                                .bg(rgb(0xe8dff2))
                                .shadow_md(),
                        ),
                );

            div()
                .w(px(WIDTH))
                .flex()
                .flex_col()
                .gap(px(8.))
                .child(
                    div()
                        .flex()
                        .justify_between()
                        .text_sm()
                        .text_color(rgb(0xe8dff2))
                        .child(self.label)
                        .child(self.value_text),
                )
                .child(
                    div()
                        .w_full()
                        .on_children_prepainted(move |bounds, _window, _cx| {
                            track_bounds.set(bounds.first().copied());
                        })
                        .child(track),
                )
        }
    }
}
