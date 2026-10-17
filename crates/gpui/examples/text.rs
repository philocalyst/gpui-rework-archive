//! Typography: the size scale, weights, decorations, alignment, wrapping and truncation,
//! monospace text, and one paragraph with styled ranges.
//!
//! Text style cascades from a parent to its children, so a line height or color set on a
//! container applies to everything inside it. `StyledText` styles byte ranges within one string,
//! which lets a single paragraph mix weights, colors, and decorations.
//!
//! Run it with `cargo run --example text`.

use std::{iter, ops::Range};

use gpui::{
    AbsoluteLength, App, Bounds, Context, DefiniteLength, Div, FontStyle, FontWeight,
    HighlightStyle, QuitMode, Rgba, SharedString, StrikethroughStyle, StyledText, TextStyle,
    TextTransform, UnderlineStyle, Window, WindowBounds, WindowOptions, colors::Colors, div,
    prelude::*, px, relative, rgb, rgb_to_hsla, size,
};

const ACCENT: u32 = 0x2563eb;

#[derive(Clone, Debug, PartialEq)]
struct SpecimenTheme {
    bg: Rgba,
    fg: Rgba,
}

impl SpecimenTheme {
    fn for_appearance(window: &Window) -> Self {
        let colors = Colors::for_appearance(window);
        Self {
            bg: colors.container,
            fg: colors.text,
        }
    }

    fn invert(self) -> Self {
        Self {
            bg: self.fg,
            fg: self.bg,
        }
    }
}

#[derive(Debug, Clone, PartialEq, IntoElement)]
struct Specimen {
    id: usize,
    scale: f32,
    text_style: Option<TextStyle>,
    string: SharedString,
    invert: bool,
}

impl Specimen {
    fn new(id: usize) -> Self {
        Self {
            id,
            scale: 1.0,
            text_style: None,
            string: "The quick brown fox jumps over the lazy dog".into(),
            invert: false,
        }
    }

    fn invert(mut self) -> Self {
        self.invert = !self.invert;
        self
    }

    fn scale(mut self, scale: f32) -> Self {
        self.scale = scale;
        self
    }
}

impl RenderOnce for Specimen {
    fn render(self, window: &mut Window, _cx: &mut App) -> impl IntoElement {
        let rem_size = window.rem_size();
        let style = self.text_style.unwrap_or_else(|| window.text_style());
        let font_size: f32 = style.font_size.to_pixels(rem_size).into();
        let line_height = match style.line_height {
            DefiniteLength::Absolute(AbsoluteLength::Pixels(value)) => {
                let pixels: f32 = value.into();
                pixels / font_size
            }
            DefiniteLength::Absolute(AbsoluteLength::Rems(value)) => {
                let pixels: f32 = value.to_pixels(rem_size).into();
                pixels / font_size
            }
            DefiniteLength::Relative(value) => value.as_f32(),
        };

        let mut theme = SpecimenTheme::for_appearance(window);
        if self.invert {
            theme = theme.invert();
        }

        div()
            .id(format!("specimen-{}", self.id))
            .bg(theme.bg)
            .text_color(theme.fg)
            .text_size(px(font_size * self.scale))
            .line_height(relative(line_height))
            .p(px(10.0))
            .child(self.string)
    }
}

#[derive(Debug, Clone, PartialEq, IntoElement)]
struct CharacterGrid {
    scale: f32,
    invert: bool,
    text_style: Option<TextStyle>,
}

impl CharacterGrid {
    pub fn new() -> Self {
        Self {
            scale: 1.0,
            invert: false,
            text_style: None,
        }
    }

    pub fn scale(mut self, scale: f32) -> Self {
        self.scale = scale;
        self
    }
}

impl RenderOnce for CharacterGrid {
    fn render(self, window: &mut Window, _cx: &mut App) -> impl IntoElement {
        let mut theme = SpecimenTheme::for_appearance(window);

        if self.invert {
            theme = theme.invert();
        }

        let characters = vec![
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A", "B", "C", "D", "E", "F", "G",
            "H", "I", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y",
            "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "p", "q",
            "r", "s", "t", "u", "v", "w", "x", "y", "z", "ẞ", "ſ", "ß", "ð", "Þ", "þ", "α", "β",
            "Γ", "γ", "Δ", "δ", "η", "θ", "ι", "κ", "Λ", "λ", "μ", "ν", "ξ", "π", "τ", "υ", "φ",
            "χ", "ψ", "∂", "а", "в", "Ж", "ж", "З", "з", "К", "к", "л", "м", "Н", "н", "Р", "р",
            "У", "у", "ф", "ч", "ь", "ы", "Э", "э", "Я", "я", "ij", "öẋ", ".,", "⣝⣑", "~", "*",
            "_", "^", "`", "'", "(", "{", "«", "#", "&", "@", "$", "¢", "%", "|", "?", "¶", "µ",
            "❮", "<=", "!=", "==", "--", "++", "=>", "->", "🏀", "🎊", "😍", "❤️", "👍", "👎",
        ];

        let columns = 20;
        let rows = characters.len().div_ceil(columns);

        let grid_rows = (0..rows).map(|row_idx| {
            let start_idx = row_idx * columns;
            let end_idx = (start_idx + columns).min(characters.len());

            div()
                .w_full()
                .flex()
                .flex_row()
                .children((start_idx..end_idx).map(|i| {
                    div()
                        .text_center()
                        .size(px(62.))
                        .bg(theme.bg)
                        .text_color(theme.fg)
                        .text_size(px(24.0))
                        .line_height(relative(1.0))
                        .child(characters[i])
                }))
                .when(end_idx - start_idx < columns, |d| {
                    d.children(
                        iter::repeat_with(|| div().flex_1()).take(columns - (end_idx - start_idx)),
                    )
                })
        });

        div().p_4().gap_2().flex().flex_col().children(grid_rows)
    }
}

struct Typography {
    next_id: usize,
    font_family: SharedString,
}

impl Typography {
    fn next_id(&mut self) -> usize {
        self.next_id += 1;
        self.next_id
    }

    fn button(
        text: &str,
        cx: &mut Context<Self>,
        on_click: impl Fn(&mut Self, &mut Context<Self>) + 'static,
    ) -> impl IntoElement {
        div()
            .id(text.to_string())
            .flex_none()
            .child(text.to_string())
            .bg(gpui::black())
            .text_color(gpui::white())
            .active(|this| this.opacity(0.8))
            .px_3()
            .py_1()
            .on_click(cx.listener(move |this, _, _, cx| on_click(this, cx)))
    }
}

const FONT_FAMILIES: [&str; 5] = [
    ".ZedMono",
    ".SystemUIFont",
    "Menlo",
    "Monaco",
    "Courier New",
];

impl Render for Typography {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let text_style = window.text_style();
        let rem_size = window.rem_size();
        let font_size: f32 = text_style.font_size.to_pixels(rem_size).into();
        let line_height = match text_style.line_height {
            DefiniteLength::Absolute(AbsoluteLength::Pixels(value)) => {
                let pixels: f32 = value.into();
                pixels / font_size
            }
            DefiniteLength::Absolute(AbsoluteLength::Rems(value)) => {
                let pixels: f32 = value.to_pixels(rem_size).into();
                pixels / font_size
            }
            DefiniteLength::Relative(value) => value.as_f32(),
        };
        let type_scale = 1.33;

        let step_down_2 = 1.0 / (type_scale * type_scale);
        let step_down_1 = 1.0 / type_scale;
        let base = 1.0;
        let step_up_1 = base * type_scale;
        let step_up_2 = step_up_1 * type_scale;
        let step_up_3 = step_up_2 * type_scale;
        let step_up_4 = step_up_3 * type_scale;
        let step_up_5 = step_up_4 * type_scale;
        let step_up_6 = step_up_5 * type_scale;

        div()
            .id("page")
            .font_family(self.font_family.clone())
            .size_full()
            .overflow_y_scroll()
            .bg(colors.background)
            .text_color(colors.text)
            .child(
                div()
                    .bg(colors.container)
                    .border_b_1()
                    .border_color(colors.border)
                    .p_3()
                    .flex()
                    .child(Self::button(&self.font_family, cx, |this, cx| {
                        let new_family = FONT_FAMILIES
                            .iter()
                            .position(|family| *family == this.font_family.as_str())
                            .map(|index| FONT_FAMILIES[(index + 1) % FONT_FAMILIES.len()])
                            .unwrap_or(FONT_FAMILIES[0]);
                        this.font_family = SharedString::new(new_family);
                        cx.notify();
                    })),
            )
            .child(
                div().flex().justify_center().p_4().child(
                    div()
                        .flex()
                        .flex_col()
                        .gap_10()
                        .w_full()
                        .max_w(px(640.))
                        .child(header(&colors))
                        .child(paragraph())
                        .child(section("Size", sizes(&colors)))
                        .child(section("Weight", weights(&colors)))
                        .child(section("Style", styles(&colors)))
                        .child(section("Alignment", alignment(&colors)))
                        .child(section("Wrapping and truncation", overflow(&colors)))
                        .child(section("Monospace", monospace(&colors))),
                ),
            )
            .child(
                div()
                    .id("text-example")
                    .overflow_y_scroll()
                    .overflow_x_hidden()
                    .bg(rgb(0xffffff))
                    .size_full()
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .p_3()
                            .text_size(px(font_size))
                            .line_height(relative(line_height))
                            .children([
                                div().child("CJK: 中文「日本語」한글"),
                                div().child(
                                    "Kana: が / か\u{3099}; Hangul: 각 / \u{1100}\u{1161}\u{11a8}",
                                ),
                                div().child("Emoji: 😀 ❤️ ❤\u{fe0e} 👍🏽 🇯🇵 1\u{fe0f}\u{20e3} 👩‍💻 👨‍👩‍👧‍👦"),
                            ]),
                    )
                    .child(div().child(CharacterGrid::new().scale(base)))
                    .child(
                        div()
                            .child(Specimen::new(self.next_id()).scale(step_down_2))
                            .child(Specimen::new(self.next_id()).scale(step_down_2).invert())
                            .child(Specimen::new(self.next_id()).scale(step_down_1))
                            .child(Specimen::new(self.next_id()).scale(step_down_1).invert())
                            .child(Specimen::new(self.next_id()).scale(base))
                            .child(Specimen::new(self.next_id()).scale(base).invert())
                            .child(Specimen::new(self.next_id()).scale(step_up_1))
                            .child(Specimen::new(self.next_id()).scale(step_up_1).invert())
                            .child(Specimen::new(self.next_id()).scale(step_up_2))
                            .child(Specimen::new(self.next_id()).scale(step_up_2).invert())
                            .child(Specimen::new(self.next_id()).scale(step_up_3))
                            .child(Specimen::new(self.next_id()).scale(step_up_3).invert())
                            .child(Specimen::new(self.next_id()).scale(step_up_4))
                            .child(Specimen::new(self.next_id()).scale(step_up_4).invert())
                            .child(Specimen::new(self.next_id()).scale(step_up_5))
                            .child(Specimen::new(self.next_id()).scale(step_up_5).invert())
                            .child(Specimen::new(self.next_id()).scale(step_up_6))
                            .child(Specimen::new(self.next_id()).scale(step_up_6).invert()),
                    ),
            )
            .child(div().w(px(240.)).h_full().bg(colors.container))
    }
}

fn header(colors: &Colors) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(
            div()
                .text_xs()
                .font_weight(FontWeight::SEMIBOLD)
                .text_color(rgb(ACCENT))
                .text_transform(TextTransform::Uppercase)
                .letter_spacing(px(1.))
                .child("Typography"),
        )
        .child(
            div()
                .text_3xl()
                .font_weight(FontWeight::BOLD)
                .child("Setting type in GPUI"),
        )
        .child(
            div()
                .text_lg()
                .text_color(colors.disabled)
                .child("A few style methods cover most of what a page of text needs."),
        )
}

fn paragraph() -> impl IntoElement {
    let text = "Styles cascade from parent to child, so one line height on a container covers \
        every paragraph in it. Inside a single paragraph, StyledText changes only the ranges \
        you name: a semibold term, an italic aside, a colored phrase, an underlined link and a \
        struck-through correction.";
    let accent = rgb_to_hsla(rgb(ACCENT));

    let highlights = [
        (
            range_of(text, "a semibold term"),
            HighlightStyle {
                font_weight: Some(FontWeight::SEMIBOLD),
                ..Default::default()
            },
        ),
        (
            range_of(text, "an italic aside"),
            HighlightStyle {
                font_style: Some(FontStyle::Italic),
                ..Default::default()
            },
        ),
        (
            range_of(text, "a colored phrase"),
            HighlightStyle::color(accent),
        ),
        (
            range_of(text, "an underlined link"),
            HighlightStyle {
                underline: Some(UnderlineStyle {
                    thickness: px(1.),
                    color: Some(accent),
                    ..Default::default()
                }),
                ..Default::default()
            },
        ),
        (
            range_of(text, "struck-through correction"),
            HighlightStyle {
                strikethrough: Some(StrikethroughStyle {
                    thickness: px(1.),
                    ..Default::default()
                }),
                ..Default::default()
            },
        ),
    ];

    div()
        .text_base()
        .line_height(relative(1.6))
        .child(StyledText::new(text).with_highlights(highlights))
}

fn range_of(text: &str, phrase: &str) -> Range<usize> {
    let start = text.find(phrase).expect("the phrase is part of the text");
    start..start + phrase.len()
}

fn section(title: &'static str, body: impl IntoElement) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_4()
        .child(
            div()
                .text_sm()
                .font_weight(FontWeight::SEMIBOLD)
                .child(title),
        )
        .child(body)
}

/// Each sample next to a monospace label that names the method that styled it.
fn specimens(
    colors: &Colors,
    rows: impl IntoIterator<Item = (&'static str, Div)>,
) -> impl IntoElement {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .children(rows.into_iter().map(|(label, sample)| {
            div()
                .flex()
                .flex_wrap()
                .items_baseline()
                .gap_x_4()
                .gap_y_1()
                .child(
                    div()
                        .w(px(112.))
                        .flex_none()
                        .font_family("Lilex")
                        .text_xs()
                        .text_color(colors.disabled)
                        .child(label),
                )
                .child(sample)
        }))
}

fn sizes(colors: &Colors) -> impl IntoElement {
    let sample = "Sphinx of black quartz";
    specimens(
        colors,
        [
            ("text_xs", div().text_xs().child(sample)),
            ("text_sm", div().text_sm().child(sample)),
            ("text_base", div().text_base().child(sample)),
            ("text_lg", div().text_lg().child(sample)),
            ("text_xl", div().text_xl().child(sample)),
            ("text_2xl", div().text_2xl().child(sample)),
            ("text_3xl", div().text_3xl().child(sample)),
        ],
    )
}

fn weights(colors: &Colors) -> impl IntoElement {
    let weights = [
        ("LIGHT", FontWeight::LIGHT),
        ("NORMAL", FontWeight::NORMAL),
        ("MEDIUM", FontWeight::MEDIUM),
        ("SEMIBOLD", FontWeight::SEMIBOLD),
        ("BOLD", FontWeight::BOLD),
    ];
    specimens(
        colors,
        weights.map(|(label, weight)| {
            (
                label,
                div()
                    .text_lg()
                    .font_weight(weight)
                    .child("Sphinx of black quartz"),
            )
        }),
    )
}

fn styles(colors: &Colors) -> impl IntoElement {
    specimens(
        colors,
        [
            ("italic", div().italic().child("For asides and titles")),
            ("underline", div().underline().child("For links")),
            ("line_through", div().line_through().child("For removals")),
            (
                "wavy",
                div()
                    .underline()
                    .text_decoration_wavy()
                    .text_decoration_color(rgb(ACCENT))
                    .child("For spelling errors"),
            ),
            (
                "text_color",
                div().text_color(rgb(ACCENT)).child("For emphasis"),
            ),
        ],
    )
}

fn alignment(colors: &Colors) -> impl IntoElement {
    let box_ = || div().w_full().p_2().rounded_md().bg(colors.container);
    div()
        .flex()
        .flex_col()
        .gap_2()
        .child(box_().text_left().child("Left aligned"))
        .child(box_().text_center().child("Centered"))
        .child(box_().text_right().child("Right aligned"))
}

fn overflow(colors: &Colors) -> impl IntoElement {
    let sentence = "GPUI lays out this sentence in a fixed column, so it wraps onto as many lines as it needs.";
    let column = || div().w(px(240.));
    specimens(
        colors,
        [
            ("wrap", column().child(sentence)),
            ("truncate", column().truncate().child(sentence)),
            (
                "line_clamp(2)",
                column().line_clamp(2).text_ellipsis().child(sentence),
            ),
            (
                "ellipsis_middle",
                column()
                    .whitespace_nowrap()
                    .text_ellipsis_middle()
                    .child("quarterly-report-final-reviewed.pdf"),
            ),
        ],
    )
}

fn monospace(colors: &Colors) -> impl IntoElement {
    div()
        .font_family("Lilex")
        .text_sm()
        .p_3()
        .rounded_md()
        .bg(colors.container)
        .flex()
        .flex_col()
        .gap_1()
        .child(r#"let style = div().font_family("Lilex").text_sm();"#)
        .child("let count = cx.new(|_cx| Counter { count: 0 });")
}

fn main() {
    gpui_platform::application()
        .with_quit_mode(QuitMode::LastWindowClosed)
        .run(run);
}

/// Opens the example window. The browser player and the example tests call this too.
pub fn run(cx: &mut App) {
    let bounds = Bounds::centered(None, size(px(720.), px(860.)), cx);
    cx.open_window(
        WindowOptions::default().window_bounds(WindowBounds::Windowed(bounds)),
        |_window, cx| {
            cx.new(|_cx| Typography {
                next_id: 0,
                font_family: ".ZedMono".into(),
            })
        },
    )
    .unwrap();
    cx.activate(true);
}
