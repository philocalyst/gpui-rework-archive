use gpui::{
    AppContext, Context, IntoElement, Render, UniformListScrollHandle, Window, div, prelude::*, px,
    rgb, uniform_list,
};

struct Rows {
    scroll: UniformListScrollHandle,
}

impl Render for Rows {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .p_6()
            .flex()
            .flex_col()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .child(
                div()
                    .text_2xl()
                    .text_color(rgb(0x202b29))
                    .child("10,000 uniform rows"),
            )
            .child(
                div().h(px(320.)).w_full().child(
                    uniform_list("rows", 10_000, |range, _window, _cx| {
                        range
                            .map(|ix| {
                                div()
                                    .h_8()
                                    .flex()
                                    .items_center()
                                    .px_3()
                                    .bg(if ix % 2 == 0 {
                                        rgb(0xffffff)
                                    } else {
                                        rgb(0xe8efed)
                                    })
                                    .text_color(rgb(0x202b29))
                                    .child(format!("Row {ix}"))
                            })
                            .collect()
                    })
                    .size_full()
                    .track_scroll(&self.scroll),
                ),
            )
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Rows> {
    cx.new(|_cx| Rows {
        scroll: UniformListScrollHandle::new(),
    })
}
