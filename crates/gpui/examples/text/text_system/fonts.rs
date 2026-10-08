//! Fonts recipes for the text-system reference window.
use super::*;

pub(super) fn font_faces() -> impl IntoElement {
    sample_row()
        .child(sample(
            "IBM Plex Sans",
            div()
                .font_family("IBM Plex Sans")
                .text_lg()
                .flex()
                .flex_col()
                .gap_2()
                .child("Regular: Hamburgefonts 0123456789")
                .child(div().italic().child("Italic: Hamburgefonts 0123456789"))
                .child(
                    div()
                        .font_weight(FontWeight::SEMIBOLD)
                        .child("Semibold: Hamburgefonts 0123456789"),
                )
                .child(
                    div()
                        .font_weight(FontWeight::SEMIBOLD)
                        .italic()
                        .child("Semibold italic: Hamburgefonts 0123456789"),
                ),
        ))
        .child(sample(
            "Lilex",
            div()
                .font_family("Lilex")
                .text_lg()
                .flex()
                .flex_col()
                .gap_2()
                .child("fn main() { println!(\"hello\"); }")
                .child(
                    div()
                        .font_weight(FontWeight::BOLD)
                        .child("let answer = Some(42);"),
                ),
        ))
}

pub(super) fn variable_font_widths() -> impl IntoElement {
    sample_row().children(
        [
            ("Extra-condensed (62.5%)", FontWidth::EXTRA_CONDENSED),
            ("Condensed (75%)", FontWidth::CONDENSED),
            ("Normal (100%)", FontWidth::NORMAL),
        ]
        .map(|(label, width)| {
            sample(
                label,
                div()
                    .font_family("Noto Sans")
                    .font_width(width)
                    .text_2xl()
                    .child("hello gpui-ce"),
            )
        }),
    )
}

pub(super) fn open_type_and_spacing() -> impl IntoElement {
    let ligature_text = "!=  ==  =>  ->  >=  <=";

    sample_row()
        .child(sample(
            "Default font features",
            div().font_family("Lilex").text_2xl().child(ligature_text),
        ))
        .child(sample(
            "Contextual alternates disabled",
            div()
                .font_family("Lilex")
                .font_features(FontFeatures::disable_ligatures())
                .text_2xl()
                .child(ligature_text),
        ))
        .child(sample(
            "Letter spacing and case",
            div()
                .font_family("IBM Plex Sans")
                .text_transform(TextTransform::Uppercase)
                .letter_spacing(px(2.5))
                .text_lg()
                .child("spaced heading"),
        ))
}
