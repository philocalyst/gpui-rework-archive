//! Paint quads and paths in a canvas, then use pointer events to build a stroke.

use gpui::colors::Colors;
use gpui::{
    Bounds, ColorExt, Context, Hsla, MouseButton, MouseDownEvent, MouseMoveEvent, MouseUpEvent,
    Path, PathBuilder, Pixels, Point, Render, Rgba, Window, canvas, div, fill, point, prelude::*,
    px, rgb, size,
};
use palette::IntoColor;

#[path = "../shared/prelude.rs"]
mod example_prelude;

#[path = "custom_drawing/primitives.rs"]
mod primitives;
use primitives::{basic_shapes_canvas, custom_paths_canvas};

struct DrawingCanvas {
    lines: Vec<Vec<Point<Pixels>>>,
    current_line: Vec<Point<Pixels>>,
    is_drawing: bool,
    color_index: usize,
}

impl DrawingCanvas {
    fn new() -> Self {
        Self {
            lines: Vec::new(),
            current_line: Vec::new(),
            is_drawing: false,
            color_index: 0,
        }
    }

    fn palette(colors: &Colors) -> [Rgba; 6] {
        [
            rgb(0xd32f2f),
            rgb(0x388e3c),
            colors.selected,
            rgb(0xf9a825),
            rgb(0x8b5cf6), // Purple
            rgb(0x06b6d4), // Cyan
        ]
    }

    fn current_color(&self, colors: &Colors) -> Rgba {
        let palette = Self::palette(colors);
        palette[self.color_index % palette.len()]
    }

    fn on_mouse_down(
        &mut self,
        event: &MouseDownEvent,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        if event.button == MouseButton::Left {
            // A stroke is committed only on release, so clear can discard an unfinished drag.
            self.is_drawing = true;
            self.current_line = vec![event.position];
            cx.notify();
        }
    }

    fn on_mouse_move(
        &mut self,
        event: &MouseMoveEvent,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        if self.is_drawing {
            self.current_line.push(event.position);
            cx.notify();
        }
    }

    fn on_mouse_up(&mut self, _event: &MouseUpEvent, _window: &mut Window, cx: &mut Context<Self>) {
        if self.is_drawing && self.current_line.len() > 1 {
            self.lines.push(std::mem::take(&mut self.current_line));
            self.color_index += 1;
        }
        self.is_drawing = false;
        self.current_line.clear();
        cx.notify();
    }

    fn clear(&mut self, cx: &mut Context<Self>) {
        self.lines.clear();
        self.current_line.clear();
        self.is_drawing = false;
        self.color_index = 0;
        cx.notify();
    }

    fn draw_line(window: &mut Window, points: &[Point<Pixels>], color: Rgba) {
        if points.len() < 2 {
            return;
        }

        let mut path = PathBuilder::stroke(px(3.));
        path.move_to(points[0]);
        for position in &points[1..] {
            path.line_to(*position);
        }
        if let Ok(path) = path.build() {
            window.paint_path(path, color);
        }
    }
}

impl Render for DrawingCanvas {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let drawing = cx.entity();
        let current_color = self.current_color(&colors);
        let palette = Self::palette(&colors);

        let surface = colors.container;
        let border = colors.border;
        let error = rgb(0xd32f2f);
        let error_hover = rgb(0xe04545);
        let text = colors.selected_text;
        let text_muted = colors.disabled;

        div()
            .flex()
            .flex_col()
            .gap_2()
            .child(
                div()
                    .id("drawing-area")
                    .debug_selector(|| "drawing-area".into())
                    .h_48()
                    .rounded_lg()
                    .bg(surface)
                    .border_1()
                    .border_color(border)
                    .cursor_crosshair()
                    .overflow_hidden()
                    .on_mouse_down(MouseButton::Left, cx.listener(Self::on_mouse_down))
                    .on_mouse_move(cx.listener(Self::on_mouse_move))
                    .on_mouse_up(MouseButton::Left, cx.listener(Self::on_mouse_up))
                    .child(
                        canvas(
                            move |_, _, _| {},
                            move |_bounds, _, window, cx| {
                                // Borrow stroke data only during paint; rendering does not copy
                                // every point the user has drawn.
                                let drawing = drawing.read(cx);
                                for (i, line) in drawing.lines.iter().enumerate() {
                                    let color = palette[i % palette.len()];
                                    DrawingCanvas::draw_line(window, line, color);
                                }

                                DrawingCanvas::draw_line(
                                    window,
                                    &drawing.current_line,
                                    current_color,
                                );
                            },
                        )
                        .size_full(),
                    ),
            )
            .child(
                div()
                    .flex()
                    .gap_2()
                    .child(
                        div()
                            .id("clear-btn")
                            .debug_selector(|| "clear-btn".into())
                            .px_3()
                            .py_1()
                            .rounded_md()
                            .bg(error)
                            .text_sm()
                            .text_color(text)
                            .cursor_pointer()
                            .hover(move |s| s.bg(error_hover))
                            .child("Clear")
                            .on_click(cx.listener(|this, _, _, cx| {
                                this.clear(cx);
                            })),
                    )
                    .child(
                        div()
                            .text_xs()
                            .text_color(text_muted)
                            .child("Click and drag to draw"),
                    ),
            )
    }
}

struct CustomDrawingExample {
    drawing_canvas: gpui::Entity<DrawingCanvas>,
}

impl CustomDrawingExample {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            drawing_canvas: cx.new(|_| DrawingCanvas::new()),
        }
    }
}

impl Render for CustomDrawingExample {
    fn render(&mut self, window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);

        div()
            .id("main")
            .size_full()
            .p_6()
            .bg(colors.background)
            .overflow_scroll()
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap_6()
                    .max_w(px(500.))
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .gap_1()
                            .child(
                                div()
                                    .text_xl()
                                    .font_weight(gpui::FontWeight::BOLD)
                                    .text_color(colors.text)
                                    .child("Custom Drawing"),
                            )
                            .child(
                                div()
                                    .text_sm()
                                    .text_color(colors.disabled)
                                    .child("Canvas element, paths, and interactive painting"),
                            ),
                    )
                    .child(section(
                        &colors,
                        "1. Basic Shapes (paint_quad)",
                        "Use window.paint_quad() to draw filled rectangles",
                        basic_shapes_canvas(&colors),
                        px(70.),
                    ))
                    .child(section(
                        &colors,
                        "2. Custom Paths (PathBuilder)",
                        "Create complex shapes with PathBuilder and paint_path()",
                        custom_paths_canvas(&colors),
                        px(80.),
                    ))
                    .child(section(
                        &colors,
                        "3. Interactive Drawing",
                        "Combine canvas with mouse events for drawing",
                        self.drawing_canvas.clone(),
                        px(240.),
                    )),
            )
    }
}

fn section(
    colors: &Colors,
    title: &'static str,
    description: &'static str,
    content: impl IntoElement,
    height: Pixels,
) -> impl IntoElement {
    let surface: Hsla = colors.container.into_color();

    div()
        .flex()
        .flex_col()
        .gap_3()
        .p_4()
        .rounded_lg()
        .bg(surface.opacity(0.5))
        .border_1()
        .border_color(colors.border)
        .child(
            div()
                .flex()
                .flex_col()
                .gap_1()
                .child(
                    div()
                        .text_sm()
                        .font_weight(gpui::FontWeight::SEMIBOLD)
                        .text_color(colors.text)
                        .child(title),
                )
                .child(
                    div()
                        .text_xs()
                        .text_color(colors.disabled)
                        .child(description),
                ),
        )
        .child(div().h(height).child(content))
}

fn main() {
    example_prelude::run_example("Custom drawing", size(px(550.), px(800.)), |_, cx| {
        cx.new(CustomDrawingExample::new)
    });
}
