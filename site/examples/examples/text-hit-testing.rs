#[path = "../src/support.rs"]
mod support;

// ## Share the layout, not a guessed character width {#layout}
// Click the paragraph to place a marker at a shaping-cluster boundary.
// [`StyledText::layout`] returns a shared [`TextLayout`]. Cloning it lets the
// input handler and the marker use the exact layout the text element measured.
// Its positions become available after layout and prepaint, before input.
//
// The string includes a combining accent in `Café` and a multibyte `ß`.
// Neither a Rust `char` count nor a fixed character width can locate every
// displayed cluster. Change the paragraph width and try the wrapped lines.

use gpui::{
    AppContext, Bounds, Context, IntoElement, MouseButton, MouseDownEvent, Render, StyledText,
    Window, canvas, div, fill, prelude::*, px, rgb, size,
};

const PARAGRAPH: &str = "Café — Straße — click a wrapped line to inspect its UTF-8 byte index.";

struct HitTest {
    index: usize,
    hit: bool,
}

// ## Keep the hit and the nearest edge distinct {#hit}
// [`TextLayout::index_for_position`] returns `Ok(index)` for a cluster hit
// and `Err(index)` for the nearest visual edge outside a line. Both indices
// count UTF-8 bytes. The handler retains that distinction in the status label
// and calls [`Context::notify`] to draw the new marker.
//
// This demonstrates a cluster marker. A text editor also needs caret affinity,
// grapheme-aware movement, selection, focus, and input-method handling. See
// the [text guide](@/guides/text.md) before building those on a display element.

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
            .child(format!(
                "Byte {} / {} · {}",
                self.index,
                PARAGRAPH.len(),
                if self.hit {
                    "cluster hit"
                } else {
                    "visual edge"
                },
            ))
    }
}

// ## Map the index back after prepaint {#marker}
// The [`canvas`] runs after the paragraph's text child. Its prepaint callback
// asks [`TextLayout::position_for_index`] for the marker's window-space point;
// paint uses that point directly. Subtract the text bounds only if the caller
// needs local coordinates. No extra offset belongs in this paint call.
//
// At a soft wrap, the following line owns the boundary position. A byte inside
// an atomic shaping cluster maps to its logical start. This is why the marker
// can move farther than one byte when you click the next visible cluster.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<HitTest> {
    cx.new(|_cx| HitTest {
        index: 0,
        hit: false,
    })
}

pub fn main() {
    support::run(component);
}
