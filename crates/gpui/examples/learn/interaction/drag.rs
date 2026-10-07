//! A drag carries a typed value; the preview and drop target consume that same value.
use super::InteractionLesson;
use gpui::{Context, Pixels, Point, Rgba, Window, div, prelude::*, px, rgb};

#[derive(Clone, Copy)]
pub(super) struct DragItem {
    pub(super) index: usize,
    color: Rgba,
}

struct DragPreview {
    item: DragItem,
    offset: Point<Pixels>,
}

impl Render for DragPreview {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        // Keep the preview under the point where the user grabbed the source element.
        div()
            .id("drag-preview")
            .debug_selector(|| "drag-preview".into())
            .pl(self.offset.x - px(40.))
            .pt(self.offset.y - px(20.))
            .child(
                div()
                    .w(px(80.))
                    .h(px(40.))
                    .rounded_md()
                    .bg(self.item.color)
                    .text_color(rgb(0xffffff))
                    .child(format!("Item {}", self.item.index + 1)),
            )
    }
}

pub(super) fn controls(
    dropped: Option<DragItem>,
    cx: &mut Context<InteractionLesson>,
) -> impl IntoElement + use<> {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div().flex().gap_2().children(
                [0xd45555, 0x348b62, 0x9670c9]
                    .into_iter()
                    .enumerate()
                    .map(|(index, color)| {
                        let item = DragItem {
                            index,
                            color: rgb(color),
                        };
                        div()
                            .id(("drag-item", index))
                            .debug_selector(move || format!("drag-item-{index}"))
                            .p_3()
                            .rounded_md()
                            .bg(item.color)
                            .text_color(rgb(0xffffff))
                            .cursor_grab()
                            .child(format!("Item {}", index + 1))
                            .on_drag(item, |item, offset, _, cx| {
                                cx.new(|_| DragPreview {
                                    item: *item,
                                    offset,
                                })
                            })
                    }),
            ),
        )
        .child(
            div()
                .id("drop-target")
                .debug_selector(|| "drop-target".into())
                .h(px(56.))
                .p_3()
                .rounded_md()
                .border_1()
                .border_dashed()
                .border_color(dropped.map_or(rgb(0x9aa1ad), |item| item.color))
                .child(dropped.map_or_else(
                    || "Drop here".into(),
                    |item| format!("Dropped item {}", item.index + 1),
                ))
                // The DragItem parameter filters drops by payload type; unrelated drags are ignored.
                .on_drop(cx.listener(|this, item: &DragItem, _, cx| {
                    this.dropped = Some(*item);
                    cx.notify();
                })),
        )
}
