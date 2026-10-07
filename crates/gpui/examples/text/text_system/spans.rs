//! Spans recipes for the text-system reference window.
use super::*;

pub(super) fn styled_runs() -> impl IntoElement {
    const TEXT_RUNS: &str = "Styled runs share one line of text.";

    let highlights = [
        (
            0..6,
            HighlightStyle {
                color: Some(hsla(0.58, 0.9, 0.7, 1.)),
                font_weight: Some(FontWeight::BOLD),
                ..Default::default()
            },
        ),
        (
            7..11,
            HighlightStyle {
                font_style: Some(FontStyle::Italic),
                ..Default::default()
            },
        ),
        (
            12..17,
            HighlightStyle {
                background_color: Some(hsla(0.13, 0.7, 0.35, 0.45)),
                ..Default::default()
            },
        ),
        (
            18..21,
            HighlightStyle {
                underline: Some(UnderlineStyle {
                    thickness: px(2.),
                    color: Some(hsla(0.36, 0.65, 0.55, 1.)),
                    wavy: false,
                }),
                ..Default::default()
            },
        ),
        (
            22..26,
            HighlightStyle {
                strikethrough: Some(StrikethroughStyle {
                    thickness: px(1.),
                    color: Some(hsla(0.0, 0.75, 0.65, 1.)),
                }),
                ..Default::default()
            },
        ),
    ];

    div()
        .rounded_md()
        .bg(rgb(SAMPLE_SURFACE))
        .p_4()
        .font_family("IBM Plex Sans")
        .text_2xl()
        .child(StyledText::new(TEXT_RUNS).with_highlights(highlights))
}

fn inline_badge(label: &'static str) -> impl IntoElement {
    div()
        .inline_flex()
        .items_center()
        .gap_1()
        .px_2()
        .py_1()
        .rounded_md()
        .bg(rgb(0x1f6f78))
        .font_weight(FontWeight::SEMIBOLD)
        .text_color(rgb(0xffffff))
        .align_middle()
        .child(div().size_2().rounded_full().bg(rgb(0xffffff)))
        .child(label)
}

pub(super) fn inline_layout() -> impl IntoElement {
    div()
        .block()
        .w_full()
        .rounded_md()
        .bg(rgb(SAMPLE_SURFACE))
        .p_5()
        .font_family("IBM Plex Sans")
        .text_size(px(20.))
        .line_height(relative(1.65))
        .child("A paragraph can contain ")
        .child(inline_badge("inline elements"))
        .child(
            div()
                .inline()
                .text_color(rgb(0xf2cc60))
                .child(" alongside nested spans with ")
                .child(
                    div()
                        .inline()
                        .font_weight(FontWeight::BOLD)
                        .child("their own styles"),
                )
                .child(". Everything remains in the same flow, so this "),
        )
        .child(inline_badge("badge"))
        .child(" moves naturally as the window becomes narrower.")
}
