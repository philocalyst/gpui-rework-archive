//! Blur — the no-macro floor.
//!
//! This deliberately has conditional builders, iterators, helpers, nested filters, and a window,
//! but no signals and no UI macro. Every helper finishes as the concrete `El<'f>` — `div()`,
//! `column(…)`, `row(…)` and every completed builder are one nominal type (14 §1.2) — so ordinary
//! Rust branches compose without `Either`, `.any()`, boxing, or a builder closure (07 §2.1). There
//! is no `el(…)` constructor; nothing here needs one.
//!
//! Every helper here borrows nothing — only `Color`/`u32`/`&'static str` literals — and none of
//! them is ever branched over by its caller, so each returns the lifetime-hiding leaf spelling
//! `impl Element` (14 §1.2) rather than naming `El<'static>`. The moment a helper borrowed live
//! state (`text(&self.title)`), its return would borrow `'_` instead — `caption(label: &str)`
//! shows the shape, staying open to restyling (`impl Element + Styled + '_`) because callers chain
//! `.pos(…)` on it. `blur()` is the whole body of the document root — the same "seals as `El`"
//! rule `counter_face` follows in creating_components.rs — so it alone keeps a named `El<'static>`.
//! Nothing is cloned during description; the commit diff promotes only what changed since last
//! frame.
//!
//! Placement is a value, not a second tree: there is one child verb (`.child(x)`), and popping a
//! child out of flow is `.child(x.align(TopRight))` / `.pos(x, y)` — no `layers(…)`, `stack(…)`,
//! or `.overlay(…)` (13 §3.3). The document root fills the window by default, so `blur()` needs
//! no `.size_full()` ceremony to claim it (12 §4b); the root only states the one thing it adds —
//! `Color::Black` — not the size the window already gives it.
//!
//! Two children rules, not one (14 §2/§2.1). Flow containers (`column(…)`, `row(…)`, `grid(…)`)
//! are born with their children — a tuple, an iterator, or one element in the constructor, always
//! (there is no `.children(…)` method to chain at the end). `div()` is different on purpose: it is
//! the styled-box primitive, and stays nullary — `div(())` is never written, content is added with
//! `.child(x)`. `blur()` below is the demonstration: its eleven pieces are each already
//! self-placed (`.pos(…)`), so there is no arrangement for a flow container to own, and the honest
//! spelling is one `div()` with eleven chained `.child(…)` calls, not `div((…))` (which cannot
//! exist alongside nullary `div()`, arity being how Rust would have to distinguish them) and not
//! `column`/`row` (which would fight the children's own placement).

use gpui::prelude::*;

fn busy_background() -> impl Element {
    let palette = [
        0xef4444, 0xf97316, 0xeab308, 0x22c55e, 0x06b6d4, 0x3b82f6, 0x8b5cf6, 0xec4899,
    ];

    column((0..9).map(|row_index| {
        row((0..8).map(|column_index| {
            div()
                .grow(1)
                .h_full()
                .bg(palette[(row_index * 8 + column_index) % palette.len()])
                .center()
                .text_color(Color::White)
                .text_xl()
                .child(text("◆"))
        }))
        .grow(1)
    }))
    .absolute()
    .inset_0()
}

fn frosted_panel() -> impl Element {
    div()
        .absolute()
        .pos(60, 120)
        .size(360, 200)
        .rounded_xl()
        .bg(Color::White.alpha(0.19))
        .backdrop_blur(24)
        .border(Stroke::new(1, Color::White.alpha(0.38)))
        .center()
        .text_color(0x111111)
        .text_2xl()
        .child(text("backdrop_blur(24px)"))
}

fn overlay_popover() -> impl Element {
    div()
        .absolute()
        .pos(260, 260)
        .size(300, 150)
        .rounded_lg()
        .bg(0x1e293b.alpha(0.4))
        .backdrop_blur(12)
        .border(Stroke::new(1, Color::White.alpha(0.67)))
        .center()
        .text_color(Color::White)
        .text_xl()
        .child(text("backdrop_blur + text"))
}

fn content_blurred() -> impl Element {
    div()
        .absolute()
        .pos(120, 420)
        .size(280, 120)
        .blur(5)
        .bg(0x0f172a)
        .rounded_lg()
        .center()
        .text_color(0xfacc15)
        .text_3xl()
        .child(text("blur(5px) content"))
}

fn content_blurred_rich() -> impl Element {
    // Three swatches arranged in a row is genuinely a row, not a styled box wrapping an iterator
    // (14 §2.1) — `row(…)` is the flow container, born with its children, and its default
    // direction already IS `Flex::row`, so the explicit `.layout(Flex::row()…)` descriptor this
    // used to carry is redundant; `.center()` is the same shorthand `frosted_panel`/`caption`'s
    // siblings use elsewhere in this file for `Align::Center` + `Justify::Center` together.
    row([0xef4444, 0x22c55e, 0x3b82f6]
        .into_iter()
        .map(|hex| div().size(48, 48).rounded_md().bg(hex)))
    .absolute()
    .pos(120, 580)
    .size(280, 120)
    .blur(6)
    .bg(0x1e293b)
    .rounded_lg()
    .center()
    .gap(12)
}

fn nested_content_blurred() -> impl Element {
    column((
        text("outer blur(3px)"),
        div()
            .size(190, 100)
            .blur(8)
            .bg(0xf59e0b)
            .rounded_lg()
            .center()
            .text_color(0x111111)
            .text_2xl()
            .child(text("inner blur(8px)")),
    ))
    .absolute()
    .pos(740, 80)
    .size(290, 220)
    .blur(3)
    .bg(0x1e293b)
    .rounded_xl()
    .center()
    .gap(16)
    .text_color(0xe2e8f0)
    .text_xl()
}

const SEAM_COLORS: [u32; 4] = [0xef4444, 0x22c55e, 0x3b82f6, 0xeab308];

fn seam_block(index: usize, hex: u32, blur_each: bool) -> impl Element {
    let block = div().grow(1).h_full();

    // Both branches are the same concrete builder type. This is ordinary Rust, not
    // macro-normalized typestate.
    let block = if blur_each { block.blur(5) } else { block };

    block
        .bg(hex)
        .center()
        .text_color(Color::White)
        .text_2xl()
        .child(text(index + 1))
}

fn adjacent_per_block_blur() -> impl Element {
    row(SEAM_COLORS
        .into_iter()
        .enumerate()
        .map(|(index, hex)| seam_block(index, hex, true)))
    .absolute()
    .pos(740, 350)
    .size(290, 110)
    .bg(0x050505)
}

fn adjacent_group_blur() -> impl Element {
    row(SEAM_COLORS
        .into_iter()
        .enumerate()
        .map(|(index, hex)| seam_block(index, hex, false)))
    .absolute()
    .pos(740, 510)
    .size(290, 110)
    .bg(0x050505)
    .blur(5)
}

fn caption(label: &str) -> impl Element + Styled + '_ {
    text(label)
        .px(8)
        .py(4)
        .rounded_md()
        .bg(Color::Black.alpha(0.8))
        .text_color(Color::White)
        .text_sm()
}

// The two-children-rules demonstration promised above: eleven self-placed pieces, `div()` +
// eleven `.child(…)` chains (14 §2.1).
fn blur() -> El<'static> {
    div()
        .bg(Color::Black)
        .child(busy_background())
        .child(frosted_panel())
        .child(content_blurred())
        .child(content_blurred_rich())
        .child(nested_content_blurred())
        .child(adjacent_per_block_blur())
        .child(adjacent_group_blur())
        .child(caption("nested content blur").pos(740, 50))
        .child(caption("adjacent — blur each block (seams, = CSS)").pos(740, 322))
        .child(caption("adjacent — blur the parent (one group, clean)").pos(740, 482))
        .child(overlay_popover())
}

fn main() {
    Application::run(
        Window::document(blur)
            .title("Blur")
            .position(100, 100)
            .size(1060, 760),
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn emits_the_expected_filter_plan() {
        let blur = Win::demo(Window::document(blur).size(1060, 760));

        // `open` is a turn barrier and `Win` exposes semantic queries directly.
        assert_eq!(blur.filter_count(FilterKind::BackdropBlur), 2);
        assert_eq!(blur.filter_count(FilterKind::ContentBlur), 9);
    }

    #[test]
    fn a_conditional_finished_builder_keeps_one_type() {
        fn assert_element(_: impl Element) {}

        assert_element(seam_block(0, 0xff0000, false));
        assert_element(seam_block(0, 0xff0000, true));
    }
}
