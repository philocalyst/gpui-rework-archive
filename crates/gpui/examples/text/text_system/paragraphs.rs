//! Paragraphs recipes for the text-system reference window.
use super::*;

pub(super) fn multilingual_text() -> impl IntoElement {
    let mut multilingual_font = font("IBM Plex Sans");
    multilingual_font.fallbacks = Some(FontFallbacks::from_fonts(vec![
        "Noto Sans Arabic".into(),
        "Noto Sans Hebrew".into(),
        "Noto Color Emoji".into(),
    ]));

    let mut emoji_samples = div().flex().flex_col().gap_2();
    for font_size in [16.0, 24.0, 32.0] {
        emoji_samples = emoji_samples.child(
            div()
                .text_size(px(font_size))
                .child("Color emoji: 😀 🎉 🚀 💡 🔥 ✨"),
        );
    }

    div()
        .flex()
        .flex_col()
        .gap_3()
        .rounded_md()
        .bg(rgb(SAMPLE_SURFACE))
        .p_4()
        .font(multilingual_font)
        .text_2xl()
        .line_height(relative(1.6))
        .child("Latin and combining marks: Café · Cafe\u{301} · naïve")
        .child("Arabic: مرحباً بالعالم")
        .child("Hebrew: שלום עולם")
        .child("Mixed direction: GPUI يكتب النص 42 مرة")
        .child(emoji_samples)
}

pub(super) fn paragraph_layout() -> impl IntoElement {
    const PARAGRAPH: &str = "A paragraph can wrap at word boundaries while keeping styled text, punctuation, and spacing together. Resize the window and this sample will follow the available width.";
    const PATH: &str = "src/text_system/really_long_filename.rs";

    div()
        .flex()
        .flex_col()
        .gap_3()
        .child(
            paragraph_container()
                .rounded_md()
                .bg(rgb(SAMPLE_SURFACE))
                .p_4()
                .font_family("IBM Plex Sans")
                .text_lg()
                .line_height(relative(1.55))
                .child(PARAGRAPH),
        )
        .child(
            sample_row()
                .child(sample(
                    "Line height 1.0",
                    div()
                        .font_family("IBM Plex Sans")
                        .line_height(relative(1.0))
                        .child("Tight lines\nkeep rows close\ntogether."),
                ))
                .child(sample(
                    "Line height 1.8",
                    div()
                        .font_family("IBM Plex Sans")
                        .line_height(relative(1.8))
                        .child("Loose lines\nleave more room\nbetween rows."),
                ))
                .child(sample(
                    "Centered",
                    paragraph_container()
                        .font_family("IBM Plex Sans")
                        .text_center()
                        .child("Every visual line is centered inside the available width."),
                )),
        )
        .child(
            sample_row()
                .child(sample(
                    "End ellipsis",
                    paragraph_container()
                        .overflow_hidden()
                        .whitespace_nowrap()
                        .text_ellipsis()
                        .child(PATH),
                ))
                .child(sample(
                    "Middle ellipsis",
                    paragraph_container()
                        .overflow_hidden()
                        .whitespace_nowrap()
                        .text_ellipsis_middle()
                        .child(PATH),
                ))
                .child(sample(
                    "Two-line clamp",
                    paragraph_container()
                        .text_ellipsis()
                        .line_clamp(2)
                        .child(PARAGRAPH),
                )),
        )
}
