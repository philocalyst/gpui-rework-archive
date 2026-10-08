use gpui::{
    AppContext, Bounds, Context, IntoElement, MouseButton, MouseDownEvent, Render, Role,
    StyledText, Window, canvas, div, fill, prelude::*, px, rgb, size, text,
};

const PARAGRAPH: &str = "Café — Straße — click a wrapped line to inspect its UTF-8 byte index.";

struct HitTest {
    index: usize,
    hit: bool,
}

impl Render for HitTest {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let text = StyledText::new(PARAGRAPH);
        let input_layout = text.layout().clone();
        let marker_layout = text.layout().clone();
        let index = self.index;
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(
                div()
                    .id("paragraph")
                    .role(Role::Label)
                    .aria_label(PARAGRAPH)
                    .relative()
                    .w(px(280.))
                    .text_size(px(18.))
                    .line_height(px(28.))
                    .cursor_text()
                    .on_mouse_down(
                        MouseButton::Left,
                        cx.listener(move |this, event: &MouseDownEvent, _window, cx| {
                            let result = input_layout.index_for_position(event.position);
                            this.hit = result.is_ok();
                            this.index = result.unwrap_or_else(|edge| edge);
                            cx.notify();
                        }),
                    )
                    .child(text)
                    .child(
                        canvas(
                            move |_bounds, _window, _cx| {
                                // The text child was prepainted before this sibling.
                                (
                                    marker_layout.position_for_index(index),
                                    marker_layout.line_height(),
                                )
                            },
                            |_bounds, (position, height), window, _cx| {
                                if let Some(position) = position {
                                    window.paint_quad(fill(
                                        Bounds::new(position, size(px(2.), height)),
                                        rgb(0xd04736),
                                    ));
                                }
                            },
                        )
                        .absolute()
                        .inset_0(),
                    ),
            )
            .child(text!(format!(
                "Byte {} / {} · {}",
                self.index,
                PARAGRAPH.len(),
                if self.hit {
                    "cluster hit"
                } else {
                    "visual edge"
                },
            )))
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<HitTest> {
    cx.new(|_cx| HitTest {
        index: 0,
        hit: false,
    })
}
