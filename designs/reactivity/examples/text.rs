//! Syntax sketch of `crates/gpui/examples/learn/text.rs`.
//!
//! Constructors take children, text is `text(...)`, extracted chrome is `.apply(card)` — `pipe`
//! no longer exists (13 §4.2). Launch is the terse `Application::run(Window::document(view)…)`
//! (07 §12). `section`/`labeled` borrow both a `&str` and a child element, so they share one
//! `'a`; neither is ever branched over, so both take the lifetime-hiding leaf spelling
//! `impl Element + 'a` rather than `El<'a>`, and there is no `el(…)` wrapping them (14 §1.2). The
//! stateless galleries below borrow nothing and are likewise never branched, so they return
//! `impl Element` too. One scroll vocabulary: `.scroll(Axis::Y)`, never `.overflow_scroll()`
//! (12 §8).

use gpui::prelude::*;

fn card<E: Element + Styled>(e: E) -> E {
    e.gap_2().p_3().bg(theme.container.opacity(0.5)).rounded_lg()
}

fn section<'a>(title: &'a str, content: impl Element + 'a) -> impl Element + 'a {
    column((text(title).text_sm().semibold(), content)).apply(card)
}

fn labeled<'a>(caption: &'a str, body: impl Element + 'a) -> impl Element + 'a {
    column((text(caption).text_xs().text_muted(), body)).gap_1()
}

fn sample<E: Element + Styled>(e: E) -> E {
    e.p_2().bg(theme.container).rounded_sm()
}

fn text_sizes() -> impl Element {
    labeled(
        "Font sizes: text_xs, text_sm, text_base, text_lg, text_xl",
        row((
            text("Extra Small").text_xs(),
            text("Small").text_sm(),
            text("Base").text_base(),
            text("Large").text_lg(),
            text("Extra Large").text_xl(),
        ))
        .flex_wrap()
        .items_baseline()
        .gap_3(),
    )
}

fn text_weights() -> impl Element {
    labeled(
        "Font weights: THIN through BLACK",
        row((
            text("Thin").font_weight(FontWeight::THIN),
            text("Light").font_weight(FontWeight::LIGHT),
            text("Normal").font_weight(FontWeight::NORMAL),
            text("Medium").font_weight(FontWeight::MEDIUM),
            text("Semibold").font_weight(FontWeight::SEMIBOLD),
            text("Bold").font_weight(FontWeight::BOLD),
            text("Black").font_weight(FontWeight::BLACK),
        ))
        .flex_wrap()
        .gap_3(),
    )
}

fn text_alignment() -> impl Element {
    labeled(
        "Alignment: default (left), text_center, text_right",
        column((
            text("Left aligned (default)").apply(sample),
            text("Center aligned").apply(sample).text_center(),
            text("Right aligned").apply(sample).text_right(),
        ))
        .gap_1(),
    )
}

fn text_decoration() -> impl Element {
    labeled(
        "Decorations: underline, strikethrough, italic",
        row((
            text("Underlined text")
                .underline()
                .underline_color(theme.selected),
            text("Strikethrough text")
                .line_through()
                .underline_color(0xd32f2f),
            text("Italic text").italic(),
        ))
        .flex_wrap()
        .gap_4(),
    )
}

fn line_height() -> impl Element {
    labeled(
        "Line height: relative(1.0), relative(1.5), relative(2.0)",
        row((
            text("Tight\nline\nheight")
                .apply(sample)
                .flex_1()
                .text_sm()
                .line_height(relative(1.0)),
            text("Normal\nline\nheight")
                .apply(sample)
                .flex_1()
                .text_sm()
                .line_height(relative(1.5)),
            text("Loose\nline\nheight")
                .apply(sample)
                .flex_1()
                .text_sm()
                .line_height(relative(2.0)),
        ))
        .gap_3(),
    )
}

fn styled_text() -> impl Element {
    labeled(
        "Marks on one IFC — not a span tree",
        text("Bold Italic Normal Semibold")
            .text_lg()
            .mark(0..4, Mark::bold())
            .mark(5..11, Mark::italic())
            .mark(19..27, Mark::semibold()),
    )
}

fn text_overflow() -> impl Element {
    let long = "The quick brown fox jumps over the lazy dog. This is a long sentence that will overflow its container.";
    fn box_of<E: Element + Styled>(e: E) -> E {
        e.p_2()
            .bg(theme.container)
            .border_1()
            .border_color(theme.border)
            .rounded_sm()
            .overflow_hidden()
    }
    labeled(
        "Overflow handling: ellipsis, truncate, line_clamp",
        column((
            labeled("text_ellipsis (single line):", text(long).apply(box_of).text_ellipsis()),
            labeled("line_clamp(2):", text(long).apply(box_of).text_ellipsis().line_clamp(2)),
            labeled(
                "truncate (hard cut):",
                text(long).apply(box_of).text_overflow(TextOverflow::Truncate),
            ),
            labeled("whitespace_nowrap:", text(long).apply(box_of).whitespace_nowrap()),
        ))
        .gap_2(),
    )
}

fn character_grid() -> impl Element {
    const CHARACTERS: &[&str] = &[
        "A", "B", "C", "D", "E", "a", "b", "c", "d", "e", "0", "1", "2", "3", "4", "5", "6",
        "7", "8", "9", "α", "β", "γ", "δ", "ε", "θ", "λ", "π", "σ", "ω", "Д", "Ж", "И", "Л",
        "Ф", "Ц", "Ш", "Щ", "Ы", "Я", "你", "好", "世", "界", "日", "本", "語", "中", "文", "字",
        "→", "←", "↑", "↓", "•", "★", "♠", "♥", "♦", "♣", "😀", "🎉", "🚀", "💡", "🔥", "✨",
        "🎨", "📚", "🎵", "❤️",
    ];
    labeled(
        "Unicode and emoji support",
        grid(CHARACTERS.iter().map(|c| {
            div().size_8().center().text_lg().line_height(relative(1.0)).child(text(*c))
        }))
        .p_2()
        .bg(theme.container)
        .border_1()
        .border_color(theme.border)
        .rounded_md()
        .cols(10)
        .gap_1(),
    )
}

struct TextGallery;

impl View for TextGallery {
    fn view(&self) -> El<'_> {
        // One child (the inner content column) — a styled scroll box, not a flow container;
        // `column()` never takes zero args (14 §2.1).
        div().p_4().bg(theme.background).scroll(Axis::Y).child(
            column((
                column((
                    text("Text & Typography").text_xl().bold(),
                    text("Font styling, alignment, overflow, and unicode support")
                        .text_sm()
                        .text_muted(),
                ))
                .gap_1(),
                section("Font Sizes", text_sizes()),
                section("Font Weights", text_weights()),
                section("Text Alignment", text_alignment()),
                section("Text Decoration", text_decoration()),
                section("Line Height", line_height()),
                section("Styled Text", styled_text()),
                section("Text Overflow", text_overflow()),
                section("Character Grid", character_grid()),
            ))
            .gap_4()
            .max_w(600),
        )
    }
}

fn main() {
    Application::run(Window::document(TextGallery).title("Text").size(650, 900).centered());
}
