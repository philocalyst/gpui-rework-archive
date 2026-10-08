#[path = "../src/support.rs"]
mod support;

// ## Share the layout, not a guessed character width {#layout}
// Click the paragraph to place a marker at the nearest shaped cluster index.
// [`StyledText::layout`] returns a shared [`TextLayout`]. Cloning it lets the
// input handler and marker query the same shaped geometry the text element
// measured. Position queries need layout and prepaint to have populated that
// geometry; building the element tree is too early.
//
// The string includes a combining accent in `Café` and a multibyte `ß`.
// Neither a Rust `char` count nor a fixed character width can locate every
// displayed cluster. Change the paragraph width and try the wrapped lines.

use gpui::{
    AppContext, Bounds, Context, IntoElement, MouseButton, MouseDownEvent, Render, Role,
    StyledText, Window, canvas, div, fill, prelude::*, px, rgb, size, text,
};

const PARAGRAPH: &str = "Café — Straße — click a wrapped line to inspect its UTF-8 byte index.";

struct HitTest {
    index: usize,
    hit: bool,
}

// ## Keep the hit and the nearest edge distinct {#hit}
// [`TextLayout::index_for_position`] returns `Ok(index)` for a hit on text and
// `Err(index)` for the nearest visual edge when the position is outside a line.
// Both are UTF-8 byte offsets. The handler keeps the hit/edge distinction in
// its status and calls [`Context::notify`] so the marker is rendered again.
//
// This demonstrates a cluster marker. A text editor also needs caret affinity,
// grapheme-aware movement, selection, focus, and input-method handling. See
// the [text guide](@/guides/text.md) before building those on a display element.
// The paragraph has an accessible text label and the byte report uses [`text`].
// Moving this diagnostic marker remains a pointer-only operation; it is not a
// keyboard-accessible text selection control.

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

// ## Map the index back after prepaint {#marker}
// The [`canvas`] runs after the paragraph's text child. Its prepaint callback
// asks [`TextLayout::position_for_index`] for the marker's window-space point;
// paint uses that point directly. Subtract the text bounds only if the caller
// needs local coordinates. No extra offset belongs in this paint call.
//
// At a soft wrap, the following line owns the boundary position. A byte inside
// an atomic shaping cluster maps to its logical start, so adjacent visible
// glyphs need not have adjacent byte indices. Click at the start of the next
// wrapped line and compare the displayed byte offset with the marker position.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<HitTest> {
    cx.new(|_cx| HitTest {
        index: 0,
        hit: false,
    })
}

pub fn main() {
    support::run(component);
}
