//! Paint quads and paths in a canvas, then use pointer events to build a stroke.

use gpui::colors::Colors;
use gpui::{
    App, Bounds, ColorExt, Context, Hsla, Modifiers, MouseButton, MouseDownEvent, MouseMoveEvent,
    MouseUpEvent, Path, PathBuilder, Pixels, Point, Render, Rgba, Window, canvas, div, fill, point,
    prelude::*, px, rgb, size,
};
use palette::IntoColor;
use std::time::Duration;

#[path = "../shared/prelude.rs"]
mod example_prelude;

fn basic_shapes_canvas(colors: &Colors) -> impl IntoElement {
    let fills = [rgb(0xd32f2f), rgb(0x388e3c), colors.selected];

    canvas(
        move |_bounds, _window, _cx| {},
        move |bounds, _prepaint_state, window, _cx| {
            for (index, color) in fills.into_iter().enumerate() {
                window.paint_quad(fill(
                    Bounds::new(
                        bounds.origin + point(px(10. + index as f32 * 70.), px(10.)),
                        size(px(60.), px(40.)),
                    ),
                    color,
                ));
            }
        },
    )
    .size_full()
}

// Close the star polygon so GPUI can fill the resulting path.
fn create_star(center: Point<Pixels>, outer_radius: f32, inner_radius: f32) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    let points = 5;

    for i in 0..points * 2 {
        let angle =
            std::f32::consts::PI / 2.0 - (i as f32) * std::f32::consts::PI / (points as f32);
        let radius = if i % 2 == 0 {
            outer_radius
        } else {
            inner_radius
        };

        let x = center.x + px(angle.cos() * radius);
        let y = center.y - px(angle.sin() * radius);

        if i == 0 {
            builder.move_to(point(x, y));
        } else {
            builder.line_to(point(x, y));
        }
    }

    builder.close();
    builder.build().unwrap()
}

fn create_triangle(p1: Point<Pixels>, p2: Point<Pixels>, p3: Point<Pixels>) -> Path<Pixels> {
    let mut builder = PathBuilder::fill();
    builder.move_to(p1);
    builder.line_to(p2);
    builder.line_to(p3);
    builder.close();
    builder.build().unwrap()
}

fn custom_paths_canvas(colors: &Colors) -> impl IntoElement {
    let warning = rgb(0xf9a825);
    let accent = colors.selected;

    canvas(
        move |_bounds, _window, _cx| {},
        move |bounds, _, window, _cx| {
            let center_y = bounds.origin.y + bounds.size.height / 2.0;

            let star_center = point(bounds.origin.x + px(50.), center_y);
            let star = create_star(star_center, 30., 15.);
            window.paint_path(star, warning);

            let tri_base_x = bounds.origin.x + px(120.);
            let triangle = create_triangle(
                point(tri_base_x + px(30.), center_y - px(25.)),
                point(tri_base_x, center_y + px(25.)),
                point(tri_base_x + px(60.), center_y + px(25.)),
            );
            window.paint_path(triangle, rgb(0x8b5cf6)); // Purple

            let arrow_x = bounds.origin.x + px(200.);
            let mut arrow_builder = PathBuilder::fill();
            arrow_builder.move_to(point(arrow_x, center_y));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y - px(20.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y - px(10.)));
            arrow_builder.line_to(point(arrow_x + px(50.), center_y - px(10.)));
            arrow_builder.line_to(point(arrow_x + px(50.), center_y + px(10.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y + px(10.)));
            arrow_builder.line_to(point(arrow_x + px(20.), center_y + px(20.)));
            arrow_builder.close();
            let arrow = arrow_builder.build().unwrap();
            window.paint_path(arrow, accent);
        },
    )
    .size_full()
}

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

fn drawing_scenario() -> anyhow::Result<gpui_test::Scenario<CustomDrawingExample>> {
    Ok(gpui_test::Scenario::new(
        "custom-drawing",
        "Custom drawing",
        size(px(550.), px(800.)),
        |_, cx: &mut App| cx.new(CustomDrawingExample::new),
    )?
    .checkpoint("default", "Canvas and paths", Duration::ZERO)?
    .checkpoint_with(
        "stroke",
        "Draw one pointer stroke",
        Duration::from_millis(100),
        |cx, view, window| {
            let bounds = cx
                .debug_bounds(window.into(), "drawing-area")?
                .ok_or_else(|| anyhow::anyhow!("drawing canvas is not laid out"))?;
            let start = bounds.center();
            let end = point(start.x + px(12.), start.y + px(12.));
            gpui_test::dispatch_input(
                cx,
                window.into(),
                gpui::PlatformInput::MouseDown(gpui::MouseDownEvent {
                    button: MouseButton::Left,
                    position: start,
                    modifiers: Modifiers::default(),
                    click_count: 1,
                    first_mouse: false,
                }),
            )?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                gpui::PlatformInput::MouseMove(gpui::MouseMoveEvent {
                    position: end,
                    pressed_button: Some(MouseButton::Left),
                    modifiers: Modifiers::default(),
                }),
            )?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                gpui::PlatformInput::MouseUp(gpui::MouseUpEvent {
                    button: MouseButton::Left,
                    position: end,
                    modifiers: Modifiers::default(),
                    click_count: 1,
                }),
            )?;
            let lines = view.read_with(cx, |view, app| view.drawing_canvas.read(app).lines.len());
            anyhow::ensure!(lines == 1, "stroke produced {lines} lines");
            Ok(())
        },
    )?
    .checkpoint_with(
        "cleared",
        "Clear removes committed and unfinished strokes",
        Duration::from_millis(200),
        |cx, view, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "clear-btn")?;
            view.read_with(cx, |view, app| {
                let drawing = view.drawing_canvas.read(app);
                anyhow::ensure!(
                    drawing.lines.is_empty()
                        && drawing.current_line.is_empty()
                        && !drawing.is_drawing,
                    "clear left stroke state behind"
                );
                Ok(())
            })
        },
    )?)
}

fn main() {
    example_prelude::run_example(drawing_scenario().expect("valid drawing scenario"))
        .expect("run custom drawing example");
}
