use std::{cell::Cell, rc::Rc};

use gpui::{
    App, Bounds, ColorExt, Context, DragMoveEvent, MouseButton, Pixels, Window, div, prelude::*,
    px, relative, rgb,
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

    pub fn on_change(mut self, callback: impl Fn(f32, &mut Window, &mut App) + 'static) -> Self {
        self.on_change = Some(Rc::new(callback));
        self
    }

    fn value_from_position(position_x: Pixels, bounds: Bounds<Pixels>, min: f32, max: f32) -> f32 {
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
                        Slider::value_from_position(event.event.position.x, event.bounds, min, max),
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
