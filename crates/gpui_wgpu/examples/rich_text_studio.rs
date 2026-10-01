//! A small native rich-text editor composed from GPUI's ordinary document blocks.
//!
//! Run the window with:
//! `cargo run -p gpui_ce_wgpu --example rich_text_studio --features test-support`
//!
//! Render a WGPU headless screenshot with:
//! `cargo run -p gpui_ce_wgpu --example rich_text_studio --features test-support -- --headless --output /tmp/rich-text-studio.png --size 1280 820`

use gpui::prelude::FluentBuilder;
use gpui::{
    AppContext, Bounds, Context, ElementId, Entity, FontWeight, HeadlessAppContext,
    InteractiveElement, IntoElement, ParentElement, Pixels, PlatformTextSystem, Render, Size,
    StatefulInteractiveElement, Styled, Subscription, Window, div, px, rgb, rgb_to_hsla, size,
};
use gpui_ce_elements::{
    editable_text::{EditableTextState, TextChanged, text_area, text_input},
    rich_text::{Affinity, Document, InlineStyle, RangeSet, RichText, Span},
};
use gpui_ce_wgpu::{CosmicTextSystem, WgpuHeadlessRenderer};
use std::{borrow::Cow, path::PathBuf, sync::Arc};

const CANVAS: u32 = 0xf5f5f2;
const PAPER: u32 = 0xfffefa;
const INK: u32 = 0x242721;
const MUTED: u32 = 0x81847c;
const LINE: u32 = 0xe6e6df;
const GREEN: u32 = 0x4a7055;
const GREEN_PALE: u32 = 0xeaf0e8;
const GREEN_DARK: u32 = 0x31533a;
const AMBER: u32 = 0xb5793f;
const CODE_BG: u32 = 0x202823;

const INITIAL_TITLE: &str = "A softer start to the day";
const INITIAL_TASKS: [&str; 2] = ["Water the seedlings", "Take the long way home"];
const RUST_SAMPLE: &str =
    "fn excerpt(doc: &Document) -> String {\n    doc.slice(0..doc.len_bytes())\n}";

fn demo_font_bytes() -> Vec<Cow<'static, [u8]>> {
    vec![
        Cow::Borrowed(
            include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf")
                .as_slice(),
        ),
        Cow::Borrowed(
            include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Italic.ttf").as_slice(),
        ),
        Cow::Borrowed(
            include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBold.ttf")
                .as_slice(),
        ),
        Cow::Borrowed(
            include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBoldItalic.ttf")
                .as_slice(),
        ),
        Cow::Borrowed(include_bytes!("../../../assets/fonts/lilex/Lilex-Regular.ttf").as_slice()),
        Cow::Borrowed(include_bytes!("../../../assets/fonts/lilex/Lilex-Bold.ttf").as_slice()),
        Cow::Borrowed(include_bytes!("../../../assets/fonts/lilex/Lilex-Italic.ttf").as_slice()),
        Cow::Borrowed(
            include_bytes!("../../../assets/fonts/lilex/Lilex-BoldItalic.ttf").as_slice(),
        ),
    ]
}

fn demo_text_system() -> anyhow::Result<Arc<CosmicTextSystem>> {
    let text_system = Arc::new(CosmicTextSystem::new("IBM Plex Sans"));
    text_system.add_fonts(demo_font_bytes())?;
    Ok(text_system)
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum DisplayMode {
    Edit,
    Read,
}

/// The studio's document is composed from a few explicit, native blocks.
#[derive(Clone, Copy)]
enum NoteBlock {
    Heading,
    Paragraph,
    Tasks,
    Code,
}

impl NoteBlock {
    fn label(self) -> &'static str {
        match self {
            Self::Heading => "Heading",
            Self::Paragraph => "Text",
            Self::Tasks => "To-do list",
            Self::Code => "Code",
        }
    }
}

const NOTE_BLOCKS: [NoteBlock; 4] = [
    NoteBlock::Heading,
    NoteBlock::Paragraph,
    NoteBlock::Tasks,
    NoteBlock::Code,
];

fn initial_paragraph() -> RichText {
    RichText::new()
        .text("Good writing has a rhythm. It leaves ")
        .span("room", InlineStyle::default().bold())
        .text(" for the thought to catch up with the sentence.\n\nKeep a small note of ")
        .span(
            "café at 4:30",
            InlineStyle::default().bold().color(rgb(AMBER)),
        )
        .text(" and ")
        .span("東京の朝", InlineStyle::default().italic())
        .text(". Save a little space for what surprises you.")
        .finish()
}

fn word_count(text: &str) -> usize {
    text.split_whitespace()
        .filter(|word| word.chars().any(char::is_alphanumeric))
        .count()
}

#[cfg(test)]
fn text_range(text: &str, needle: &str) -> std::ops::Range<usize> {
    let start = text.find(needle).expect("sample text contains phrase");
    start..start + needle.len()
}

fn is_identifier(character: Option<char>) -> bool {
    character.is_some_and(|character| character.is_alphanumeric() || character == '_')
}

/// A tiny fixed-token adapter for the sample only, not a Rust parser.
/// A real syntax service can pass its own UTF-8 byte ranges into the same decoration API.
fn rust_token_decorations(source: &str) -> RangeSet<InlineStyle> {
    let tokens = [
        ("fn", InlineStyle::default().bold().color(rgb(0x9ecb9a))),
        (
            "excerpt",
            InlineStyle::default().bold().color(rgb(0xd3b27c)),
        ),
        (
            "Document",
            InlineStyle::default().bold().color(rgb(0x84b9c3)),
        ),
        ("String", InlineStyle::default().color(rgb(0x84b9c3))),
        ("doc", InlineStyle::default().color(rgb(0xd3b27c))),
        ("slice", InlineStyle::default().color(rgb(0xceb0e6))),
        ("len_bytes", InlineStyle::default().color(rgb(0xd3b27c))),
    ];

    let mut spans = Vec::new();
    for (token, style) in tokens {
        for (start, matched) in source.match_indices(token) {
            let end = start + matched.len();
            let before = source[..start].chars().next_back();
            let after = source[end..].chars().next();
            if !is_identifier(before) && !is_identifier(after) {
                spans.push(Span::new(
                    start..end,
                    Affinity::Before,
                    Affinity::After,
                    style.clone(),
                ));
            }
        }
    }
    RangeSet::new(spans)
}

/// Small typography helper for the sidebar and block labels.
fn small_label(text: impl Into<String>) -> impl IntoElement {
    div()
        .text_size(px(10.0))
        .font_weight(FontWeight::SEMIBOLD)
        .text_color(rgb(MUTED))
        .child(text.into())
}

fn button(
    id: &'static str,
    label: &'static str,
    active: bool,
    on_click: impl Fn(&mut RichTextStudio, &mut Window, &mut Context<RichTextStudio>) + 'static,
    cx: &mut Context<RichTextStudio>,
) -> impl IntoElement {
    div()
        .id(id)
        .px(px(10.0))
        .py(px(7.0))
        .rounded(px(6.0))
        .bg(rgb(if active { GREEN_PALE } else { PAPER }))
        .border_1()
        .border_color(rgb(if active { 0xd9e5d6 } else { LINE }))
        .text_color(rgb(if active { GREEN_DARK } else { INK }))
        .text_size(px(12.0))
        .font_weight(FontWeight::SEMIBOLD)
        .cursor_pointer()
        .on_click(cx.listener(move |this, _, window, cx| on_click(this, window, cx)))
        .child(label)
}

fn mode_button(
    id: &'static str,
    label: &'static str,
    mode: DisplayMode,
    target: DisplayMode,
    cx: &mut Context<RichTextStudio>,
) -> impl IntoElement {
    div()
        .id(id)
        .px(px(11.0))
        .py(px(6.0))
        .rounded(px(6.0))
        .bg(rgb(if mode == target { PAPER } else { CANVAS }))
        .text_color(rgb(if mode == target { INK } else { MUTED }))
        .text_size(px(11.0))
        .font_weight(FontWeight::SEMIBOLD)
        .cursor_pointer()
        .on_click(cx.listener(move |this, _, window, cx| {
            if target == DisplayMode::Read {
                window.blur(cx);
            }
            this.mode = target;
            this.status = if target == DisplayMode::Read {
                "Read mode · the same text and formatting, composed as native blocks."
            } else {
                "Edit mode · select a phrase and apply inline formatting."
            };
            cx.notify();
        }))
        .child(label)
}

struct RichTextStudio {
    mode: DisplayMode,
    title: Option<Entity<EditableTextState>>,
    paragraph: Option<Entity<EditableTextState>>,
    task_inputs: [Option<Entity<EditableTextState>>; 2],
    code: Option<Entity<EditableTextState>>,
    initial_paragraph: Option<RichText>,
    paragraph_subscription: Option<Subscription>,
    code_subscription: Option<Subscription>,
    checked: [bool; 2],
    words: usize,
    characters: usize,
    code_lines: usize,
    status: &'static str,
}

impl RichTextStudio {
    fn new() -> Self {
        let paragraph = initial_paragraph();
        Self {
            mode: DisplayMode::Edit,
            title: None,
            paragraph: None,
            task_inputs: [None, None],
            code: None,
            initial_paragraph: Some(paragraph.clone()),
            paragraph_subscription: None,
            code_subscription: None,
            checked: [true, false],
            words: word_count(paragraph.as_str()),
            characters: paragraph.as_str().chars().count(),
            code_lines: RUST_SAMPLE.lines().count(),
            status: "Select a phrase and try the inline toolbar.",
        }
    }

    fn task_row(
        &self,
        index: usize,
        text_state: &Entity<EditableTextState>,
        mode: DisplayMode,
        cx: &mut Context<Self>,
    ) -> impl IntoElement {
        let is_checked = self.checked[index];
        let checkbox_base = || {
            div()
                .size(px(16.0))
                .flex()
                .items_center()
                .justify_center()
                .rounded(px(4.0))
                .border_1()
                .border_color(rgb(if is_checked { GREEN } else { 0xc8c9c3 }))
                .bg(rgb(if is_checked { GREEN } else { PAPER }))
                .text_color(rgb(PAPER))
                .text_size(px(10.0))
                .child(if is_checked { "✓" } else { "" })
        };
        let checkbox: gpui::AnyElement = if mode == DisplayMode::Edit {
            checkbox_base()
                .id(format!("studio-task-check-{index}"))
                .cursor_pointer()
                .on_click(cx.listener(move |this, _, _, cx| {
                    this.checked[index] = !this.checked[index];
                    this.status = if this.checked[index] {
                        "Task marked complete."
                    } else {
                        "Task returned to the list."
                    };
                    cx.notify();
                }))
                .into_any_element()
        } else {
            checkbox_base().into_any_element()
        };

        let mut text = div()
            .flex_1()
            .min_w(px(0.0))
            .text_size(px(12.0))
            .text_color(rgb(if is_checked { MUTED } else { INK }));
        if mode == DisplayMode::Edit {
            let id = ElementId::from(format!("studio-task-input-{index}"));
            text = text.child(
                text_input(id)
                    .state(text_state.downgrade())
                    .text_size(px(12.0))
                    .line_height(px(20.0))
                    .text_color(rgb(if is_checked { MUTED } else { INK }))
                    .selection_color(rgb_to_hsla(rgb(0xdce8d9)))
                    .caret_color(rgb_to_hsla(rgb(GREEN)))
                    .w_full()
                    .h(px(22.0)),
            );
        } else {
            text = text.child(text_state.read(cx).rich_text_snapshot());
        }

        div()
            .flex()
            .items_center()
            .gap(px(10.0))
            .py(px(3.0))
            .child(checkbox)
            .child(text)
    }
}

impl Render for RichTextStudio {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let viewport = window.viewport_size();
        let width = f32::from(viewport.width);
        let compact = width < 960.0;
        let gap = if compact { 12.0 } else { 16.0 };
        let padding = if compact { 18.0 } else { 30.0 };

        let title_id = ElementId::from("studio-title");
        let title = EditableTextState::use_keyed_init(title_id.clone(), window, cx, |_, _| {
            Document::new(INITIAL_TITLE)
        });
        self.title = Some(title.clone());

        let paragraph_id = ElementId::from("studio-paragraph");
        let initial = self.initial_paragraph.take();
        let paragraph = EditableTextState::use_keyed_rich_text(
            paragraph_id.clone(),
            window,
            cx,
            move |_, _| initial.unwrap_or_else(initial_paragraph),
        );
        self.paragraph = Some(paragraph.clone());
        if self.paragraph_subscription.is_none() {
            self.paragraph_subscription = Some(cx.subscribe(
                &paragraph,
                |this, paragraph, _: &TextChanged, cx| {
                    let text = paragraph.read(cx).as_str();
                    this.words = word_count(text);
                    this.characters = text.chars().count();
                    cx.notify();
                },
            ));
        }

        let task0_id = ElementId::from("studio-task-input-0");
        let task0 = EditableTextState::use_keyed_init(task0_id, window, cx, |_, _| {
            Document::new(INITIAL_TASKS[0])
        });
        let task1_id = ElementId::from("studio-task-input-1");
        let task1 = EditableTextState::use_keyed_init(task1_id, window, cx, |_, _| {
            Document::new(INITIAL_TASKS[1])
        });
        self.task_inputs = [Some(task0.clone()), Some(task1.clone())];

        let code_id = ElementId::from("studio-code");
        let code = EditableTextState::use_keyed_init(code_id.clone(), window, cx, |_, _| {
            Document::new(RUST_SAMPLE)
        });
        self.code = Some(code.clone());
        if self.code_subscription.is_none() {
            self.code_subscription =
                Some(cx.subscribe(&code, |this, code, _: &TextChanged, cx| {
                    this.code_lines = code.read(cx).as_str().lines().count();
                    cx.notify();
                }));
        }

        let mode = self.mode;
        let title_snapshot =
            (mode == DisplayMode::Read).then(|| title.read(cx).rich_text_snapshot());
        let paragraph_snapshot =
            (mode == DisplayMode::Read).then(|| paragraph.read(cx).rich_text_snapshot());
        let code_text = code.read(cx).shared_string();
        let code_decorations = rust_token_decorations(&code_text);
        let code_read_snapshot = if mode == DisplayMode::Read {
            let snapshot = code.read(cx).rich_text_snapshot();
            Some(
                RichText::try_from_parts(
                    snapshot.shared_string(),
                    snapshot.ranges().concat(&code_decorations),
                )
                .expect("the fixed token adapter creates valid code ranges"),
            )
        } else {
            None
        };

        let mut title_content = div()
            .w_full()
            .text_size(px(if compact { 29.0 } else { 35.0 }))
            .line_height(px(if compact { 36.0 } else { 42.0 }))
            .font_family(".ZedSans")
            .font_weight(FontWeight::MEDIUM)
            .text_color(rgb(INK));
        if mode == DisplayMode::Edit {
            title_content = title_content.child(
                text_input(title_id)
                    .state(title.downgrade())
                    .text_size(px(if compact { 29.0 } else { 35.0 }))
                    .line_height(px(if compact { 36.0 } else { 42.0 }))
                    .font_family(".ZedSans")
                    .font_weight(FontWeight::MEDIUM)
                    .text_color(rgb(INK))
                    .selection_color(rgb_to_hsla(rgb(0xdce8d9)))
                    .caret_color(rgb_to_hsla(rgb(GREEN)))
                    .w_full()
                    .min_h(px(if compact { 38.0 } else { 46.0 }))
                    .h_auto(),
            );
        } else {
            title_content = title_content.child(title_snapshot.expect("read mode snapshot"));
        }

        let mut format_toolbar = div().flex().items_center().gap(px(6.0));
        if mode == DisplayMode::Edit {
            let bold_editor = paragraph.clone();
            format_toolbar = format_toolbar.child(button(
                "studio-bold",
                "B",
                false,
                move |this, _, cx| {
                    bold_editor.update(cx, |state, cx| {
                        state.format_selection(InlineStyle::default().bold(), cx);
                    });
                    this.status = "Bold style added to the selected text.";
                    cx.notify();
                },
                cx,
            ));
            let italic_editor = paragraph.clone();
            format_toolbar = format_toolbar.child(button(
                "studio-italic",
                "I",
                false,
                move |this, _, cx| {
                    italic_editor.update(cx, |state, cx| {
                        state.format_selection(InlineStyle::default().italic(), cx);
                    });
                    this.status = "Italic style added to the selected text.";
                    cx.notify();
                },
                cx,
            ));
            let accent_editor = paragraph.clone();
            format_toolbar = format_toolbar.child(button(
                "studio-accent",
                "Soft highlight",
                false,
                move |this, _, cx| {
                    accent_editor.update(cx, |state, cx| {
                        state.format_selection(
                            InlineStyle::default()
                                .bold()
                                .color(rgb(GREEN_DARK))
                                .background(rgb(GREEN_PALE)),
                            cx,
                        );
                    });
                    this.status = "Highlight added; it stays with the text as it moves.";
                    cx.notify();
                },
                cx,
            ));
        } else {
            format_toolbar = format_toolbar.child(
                div()
                    .rounded(px(6.0))
                    .bg(rgb(GREEN_PALE))
                    .px(px(10.0))
                    .py(px(7.0))
                    .text_size(px(11.0))
                    .font_weight(FontWeight::MEDIUM)
                    .text_color(rgb(GREEN_DARK))
                    .child("Composed from the same document"),
            );
        }

        let mut paragraph_content = div()
            .w_full()
            .rounded(px(8.0))
            .border_1()
            .border_color(rgb(LINE))
            .bg(rgb(PAPER))
            .p(px(if compact { 14.0 } else { 18.0 }))
            .text_size(px(15.0))
            .line_height(px(24.0))
            .font_family(".ZedSans")
            .text_color(rgb(INK));
        if mode == DisplayMode::Edit {
            paragraph_content = paragraph_content.child(
                text_area(paragraph_id)
                    .state(paragraph.downgrade())
                    .text_size(px(15.0))
                    .line_height(px(24.0))
                    .font_family(".ZedSans")
                    .text_color(rgb(INK))
                    .selection_color(rgb_to_hsla(rgb(0xdce8d9)))
                    .caret_color(rgb_to_hsla(rgb(GREEN)))
                    .w_full()
                    .min_h(px(if compact { 104.0 } else { 112.0 }))
                    .h_auto(),
            );
        } else {
            paragraph_content = paragraph_content.child(paragraph_snapshot.expect("read snapshot"));
        }

        let task_rows = div()
            .flex()
            .flex_col()
            .gap(px(4.0))
            .child(self.task_row(0, &task0, mode, cx))
            .child(self.task_row(1, &task1, mode, cx));

        let mut code_content = div()
            .w_full()
            .rounded(px(8.0))
            .bg(rgb(CODE_BG))
            .p(px(if compact { 12.0 } else { 16.0 }));
        if mode == DisplayMode::Edit {
            code_content = code_content.child(
                text_area(code_id)
                    .state(code.downgrade())
                    .text_size(px(11.0))
                    .line_height(px(17.0))
                    .font_family(".ZedMono")
                    .text_color(rgb(0xd6ded4))
                    .selection_color(rgb_to_hsla(rgb(0x49564a)))
                    .caret_color(rgb_to_hsla(rgb(0xb5d1a9)))
                    .decorations(code_decorations)
                    .w_full()
                    .min_h(px(if compact { 66.0 } else { 72.0 }))
                    .h_auto(),
            );
        } else {
            code_content = code_content.child(
                div()
                    .text_size(px(11.0))
                    .line_height(px(17.0))
                    .font_family(".ZedMono")
                    .text_color(rgb(0xd6ded4))
                    .child(code_read_snapshot.expect("read mode code snapshot")),
            );
        }

        let task_count = if self.checked.iter().all(|checked| *checked) {
            "2 of 2 complete"
        } else if self.checked.iter().any(|checked| *checked) {
            "1 of 2 complete"
        } else {
            "0 of 2 complete"
        };

        let document = div()
            .w_full()
            .max_w(px(790.0))
            .rounded(px(12.0))
            .border_1()
            .border_color(rgb(LINE))
            .bg(rgb(PAPER))
            .p(px(padding))
            .flex()
            .flex_col()
            .gap(px(gap))
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap(px(if compact { 5.0 } else { 7.0 }))
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .gap(px(7.0))
                            .child(small_label("DAILY NOTES"))
                            .child(div().size(px(4.0)).rounded_full().bg(rgb(0xc4c9bd)))
                            .child(
                                div()
                                    .text_size(px(10.0))
                                    .text_color(rgb(MUTED))
                                    .child("Tuesday, September 24"),
                            ),
                    )
                    .child(title_content)
                    .child(
                        div()
                            .text_size(px(12.0))
                            .text_color(rgb(MUTED))
                            .child("A few lines for what matters today."),
                    ),
            )
            .child(
                div()
                    .flex()
                    .items_center()
                    .justify_between()
                    .child(format_toolbar)
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .gap(px(6.0))
                            .text_size(px(10.0))
                            .text_color(rgb(MUTED))
                            .child(if mode == DisplayMode::Edit {
                                "EDITING"
                            } else {
                                "READING"
                            })
                            .child(div().size(px(5.0)).rounded_full().bg(rgb(GREEN))),
                    ),
            )
            .child(paragraph_content)
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap(px(8.0))
                    .pt(px(2.0))
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .justify_between()
                            .child(small_label("A FEW THINGS TO DO"))
                            .child(
                                div()
                                    .rounded(px(5.0))
                                    .bg(rgb(GREEN_PALE))
                                    .px(px(7.0))
                                    .py(px(3.0))
                                    .text_size(px(9.0))
                                    .text_color(rgb(GREEN_DARK))
                                    .child(task_count),
                            ),
                    )
                    .child(task_rows),
            )
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap(px(8.0))
                    .pt(px(1.0))
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .justify_between()
                            .child(small_label("CODE BLOCK"))
                            .child(
                                div()
                                    .rounded(px(4.0))
                                    .bg(rgb(0x303b33))
                                    .px(px(7.0))
                                    .py(px(3.0))
                                    .text_size(px(9.0))
                                    .text_color(rgb(0xb8c5b8))
                                    .child(format!("RUST · {} LINES", self.code_lines)),
                            ),
                    )
                    .child(code_content)
                    .child(div().text_size(px(10.0)).text_color(rgb(MUTED)).child(
                        "A fixed token adapter supplies sample ranges; the code stays editable.",
                    )),
            )
            .child(
                div()
                    .flex()
                    .items_center()
                    .justify_between()
                    .pt(px(if compact { 1.0 } else { 4.0 }))
                    .border_t_1()
                    .border_color(rgb(LINE))
                    .text_size(px(10.0))
                    .text_color(rgb(MUTED))
                    .child(format!(
                        "{} words · {} characters",
                        self.words, self.characters
                    ))
                    .child(self.status),
            );

        let sidebar = div()
            .w(px(if compact { 0.0 } else { 214.0 }))
            .flex()
            .flex_col()
            .gap(px(22.0))
            .when(!compact, |sidebar| {
                sidebar
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .gap(px(9.0))
                            .px(px(10.0))
                            .py(px(8.0))
                            .rounded(px(7.0))
                            .bg(rgb(PAPER))
                            .border_1()
                            .border_color(rgb(LINE))
                            .child(
                                div()
                                    .size(px(26.0))
                                    .flex()
                                    .items_center()
                                    .justify_center()
                                    .rounded(px(6.0))
                                    .bg(rgb(GREEN))
                                    .text_size(px(14.0))
                                    .font_family(".ZedSans")
                                    .font_weight(FontWeight::BOLD)
                                    .text_color(rgb(PAPER))
                                    .child("n"),
                            )
                            .child(
                                div()
                                    .flex()
                                    .flex_col()
                                    .gap(px(2.0))
                                    .child(
                                        div()
                                            .text_size(px(11.0))
                                            .font_weight(FontWeight::SEMIBOLD)
                                            .text_color(rgb(INK))
                                            .child("Commonplace"),
                                    )
                                    .child(
                                        div()
                                            .text_size(px(9.0))
                                            .text_color(rgb(MUTED))
                                            .child("Personal workspace"),
                                    ),
                            ),
                    )
                    .child(
                        div()
                            .flex()
                            .flex_col()
                            .gap(px(8.0))
                            .child(small_label("YOUR PAGES"))
                            .child(
                                div()
                                    .flex()
                                    .items_center()
                                    .gap(px(8.0))
                                    .rounded(px(6.0))
                                    .bg(rgb(GREEN_PALE))
                                    .px(px(10.0))
                                    .py(px(8.0))
                                    .text_size(px(11.0))
                                    .font_weight(FontWeight::MEDIUM)
                                    .text_color(rgb(GREEN_DARK))
                                    .child("▤")
                                    .child("Daily notes"),
                            )
                            .child(
                                div()
                                    .flex()
                                    .items_center()
                                    .gap(px(8.0))
                                    .px(px(10.0))
                                    .py(px(7.0))
                                    .text_size(px(11.0))
                                    .text_color(rgb(MUTED))
                                    .child("▤")
                                    .child("Reading list"),
                            )
                            .child(
                                div()
                                    .flex()
                                    .items_center()
                                    .gap(px(8.0))
                                    .px(px(10.0))
                                    .py(px(7.0))
                                    .text_size(px(11.0))
                                    .text_color(rgb(MUTED))
                                    .child("▤")
                                    .child("Garden journal"),
                            ),
                    )
                    .child(
                        div()
                            .mt(px(3.0))
                            .pt(px(13.0))
                            .border_t_1()
                            .border_color(rgb(LINE))
                            .flex()
                            .flex_col()
                            .gap(px(9.0))
                            .child(small_label("ON THIS PAGE"))
                            .children(NOTE_BLOCKS.into_iter().map(|block| {
                                div()
                                    .flex()
                                    .items_center()
                                    .gap(px(8.0))
                                    .px(px(10.0))
                                    .py(px(5.0))
                                    .text_size(px(10.0))
                                    .text_color(rgb(if matches!(block, NoteBlock::Heading) {
                                        GREEN_DARK
                                    } else {
                                        MUTED
                                    }))
                                    .child(if matches!(block, NoteBlock::Heading) {
                                        "•"
                                    } else {
                                        "·"
                                    })
                                    .child(block.label())
                            })),
                    )
            });

        div()
            .size_full()
            .flex()
            .flex_col()
            .bg(rgb(CANVAS))
            .font_family(".ZedSans")
            .text_color(rgb(INK))
            .child(
                div()
                    .h(px(60.0))
                    .flex()
                    .items_center()
                    .justify_between()
                    .px(px(if compact { 18.0 } else { 28.0 }))
                    .border_b_1()
                    .border_color(rgb(LINE))
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .gap(px(10.0))
                            .child(
                                div()
                                    .size(px(26.0))
                                    .flex()
                                    .items_center()
                                    .justify_center()
                                    .rounded(px(7.0))
                                    .bg(rgb(GREEN))
                                    .text_size(px(14.0))
                                    .font_family(".ZedSans")
                                    .font_weight(FontWeight::BOLD)
                                    .text_color(rgb(PAPER))
                                    .child("n"),
                            )
                            .child(
                                div()
                                    .flex()
                                    .items_center()
                                    .gap(px(8.0))
                                    .text_size(px(11.0))
                                    .text_color(rgb(MUTED))
                                    .child("Commonplace")
                                    .child(div().text_color(rgb(0xc7c8c1)).child("/"))
                                    .child(
                                        div()
                                            .font_weight(FontWeight::SEMIBOLD)
                                            .text_color(rgb(INK))
                                            .child("Daily notes"),
                                    ),
                            ),
                    )
                    .child(
                        div()
                            .flex()
                            .items_center()
                            .gap(px(3.0))
                            .rounded(px(8.0))
                            .bg(rgb(0xebebe6))
                            .p(px(3.0))
                            .child(mode_button(
                                "studio-mode-edit",
                                "Edit",
                                self.mode,
                                DisplayMode::Edit,
                                cx,
                            ))
                            .child(mode_button(
                                "studio-mode-read",
                                "Read",
                                self.mode,
                                DisplayMode::Read,
                                cx,
                            )),
                    ),
            )
            .child(
                div()
                    .flex_1()
                    .min_h(px(0.0))
                    .flex()
                    .gap(px(if compact { 0.0 } else { 28.0 }))
                    .p(px(if compact { 18.0 } else { 24.0 }))
                    .child(sidebar)
                    .child(
                        div()
                            .id("studio-page-scroll")
                            .flex_1()
                            .min_w(px(0.0))
                            .min_h(px(0.0))
                            .overflow_y_scroll()
                            .flex()
                            .justify_center()
                            .items_start()
                            .child(document),
                    ),
            )
    }
}

struct Options {
    output: PathBuf,
    viewport: Size<Pixels>,
    headless: bool,
    read_mode: bool,
}

impl Options {
    fn parse() -> anyhow::Result<Self> {
        let mut options = Self {
            output: "/tmp/gpui-rich-text-studio.png".into(),
            viewport: size(px(1440.0), px(900.0)),
            headless: false,
            read_mode: false,
        };
        let mut args = std::env::args().skip(1);
        while let Some(arg) = args.next() {
            match arg.as_str() {
                "--headless" => options.headless = true,
                "--read" => options.read_mode = true,
                "--output" => {
                    options.output = args
                        .next()
                        .ok_or_else(|| anyhow::anyhow!("missing output path"))?
                        .into()
                }
                "--size" => {
                    options.viewport = size(
                        px(args
                            .next()
                            .ok_or_else(|| anyhow::anyhow!("missing width"))?
                            .parse()?),
                        px(args
                            .next()
                            .ok_or_else(|| anyhow::anyhow!("missing height"))?
                            .parse()?),
                    )
                }
                _ => anyhow::bail!("unknown argument: {arg}"),
            }
        }
        anyhow::ensure!(
            f32::from(options.viewport.width).is_finite()
                && f32::from(options.viewport.height).is_finite()
                && f32::from(options.viewport.width) >= 640.0
                && f32::from(options.viewport.height) >= 480.0,
            "viewport must be finite and at least 640 × 480"
        );
        Ok(options)
    }
}

fn headless(options: &Options) -> anyhow::Result<()> {
    let mut cx = HeadlessAppContext::with_platform(demo_text_system()?, Arc::new(()), || {
        Some(Box::new(WgpuHeadlessRenderer::new().expect("GPU renderer")))
    });
    let mode = if options.read_mode {
        DisplayMode::Read
    } else {
        DisplayMode::Edit
    };
    let window = cx.open_window(options.viewport, move |_, cx| {
        cx.new(|_| {
            let mut studio = RichTextStudio::new();
            studio.mode = mode;
            studio
        })
    })?;
    cx.update_window(window.into(), |_, window, cx| {
        window.draw(cx).clear(cx);
    })?;
    cx.capture_screenshot(window.into())?
        .save(&options.output)?;
    println!("Saved {}", options.output.display());
    Ok(())
}

#[cfg(not(target_family = "wasm"))]
fn native(options: Options) {
    let mode = if options.read_mode {
        DisplayMode::Read
    } else {
        DisplayMode::Edit
    };
    gpui_platform::application().run(move |cx: &mut gpui::App| {
        cx.text_system()
            .add_fonts(demo_font_bytes())
            .expect("load the studio's bundled IBM Plex Sans and Lilex fonts");
        cx.open_window(
            gpui::WindowOptions {
                window_bounds: Some(gpui::WindowBounds::Windowed(Bounds::centered(
                    None,
                    options.viewport,
                    cx,
                ))),
                ..Default::default()
            },
            |_, cx| {
                cx.new(|_| {
                    let mut studio = RichTextStudio::new();
                    studio.mode = mode;
                    studio
                })
            },
        )
        .expect("rich-text studio window");
        cx.activate(true);
    });
}

fn main() -> anyhow::Result<()> {
    let options = Options::parse()?;
    #[cfg(not(target_family = "wasm"))]
    if !options.headless {
        native(options);
        return Ok(());
    }
    headless(&options)
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::{
        FontRun, Modifiers, MouseButton, MouseDownEvent, MouseMoveEvent, MouseUpEvent, point,
    };
    use gpui_ce_elements::rich_text::{Selection, Transaction};

    fn dispatch_click(
        cx: &mut HeadlessAppContext,
        window: gpui::AnyWindowHandle,
        position: gpui::Point<Pixels>,
    ) {
        cx.update_window(window, |_, window, cx| {
            window.dispatch_event(
                gpui::PlatformInput::MouseMove(MouseMoveEvent {
                    position,
                    pressed_button: None,
                    modifiers: Modifiers::default(),
                }),
                cx,
            );
            window.dispatch_event(
                gpui::PlatformInput::MouseDown(MouseDownEvent {
                    position,
                    button: MouseButton::Left,
                    modifiers: Modifiers::default(),
                    click_count: 1,
                    first_mouse: false,
                }),
                cx,
            );
            window.dispatch_event(
                gpui::PlatformInput::MouseUp(MouseUpEvent {
                    position,
                    button: MouseButton::Left,
                    modifiers: Modifiers::default(),
                    click_count: 1,
                }),
                cx,
            );
            window.draw(cx).clear(cx);
        })
        .unwrap();
    }

    fn dispatch_drag(
        cx: &mut HeadlessAppContext,
        window: gpui::AnyWindowHandle,
        start: gpui::Point<Pixels>,
        end: gpui::Point<Pixels>,
    ) {
        cx.update_window(window, |_, window, cx| {
            window.dispatch_event(
                gpui::PlatformInput::MouseMove(MouseMoveEvent {
                    position: start,
                    pressed_button: None,
                    modifiers: Modifiers::default(),
                }),
                cx,
            );
            window.dispatch_event(
                gpui::PlatformInput::MouseDown(MouseDownEvent {
                    position: start,
                    button: MouseButton::Left,
                    modifiers: Modifiers::default(),
                    click_count: 1,
                    first_mouse: false,
                }),
                cx,
            );
            window.dispatch_event(
                gpui::PlatformInput::MouseMove(MouseMoveEvent {
                    position: end,
                    pressed_button: Some(MouseButton::Left),
                    modifiers: Modifiers::default(),
                }),
                cx,
            );
            window.dispatch_event(
                gpui::PlatformInput::MouseUp(MouseUpEvent {
                    position: end,
                    button: MouseButton::Left,
                    modifiers: Modifiers::default(),
                    click_count: 1,
                }),
                cx,
            );
            window.draw(cx).clear(cx);
        })
        .unwrap();
    }

    fn changed_pixels(before: &image::RgbaImage, after: &image::RgbaImage) -> usize {
        assert_eq!(before.dimensions(), after.dimensions());
        (0..before.height())
            .flat_map(|y| (0..before.width()).map(move |x| (x, y)))
            .filter(|&(x, y)| {
                let before = before.get_pixel(x, y);
                let after = after.get_pixel(x, y);
                (0..3).any(|channel| before[channel].abs_diff(after[channel]) > 8)
            })
            .count()
    }

    fn make_headless() -> HeadlessAppContext {
        HeadlessAppContext::with_platform(
            demo_text_system().expect("load the studio's bundled fonts"),
            Arc::new(()),
            || Some(Box::new(WgpuHeadlessRenderer::new().expect("GPU renderer"))),
        )
    }

    #[test]
    fn bundled_fonts_resolve_weight_style_and_monospace_advances() {
        let text_system = CosmicTextSystem::new_without_system_fonts("IBM Plex Sans");
        text_system
            .add_fonts(demo_font_bytes())
            .expect("load the studio's bundled IBM Plex Sans and Lilex faces");

        let regular = text_system
            .font_id(&gpui::font("IBM Plex Sans"))
            .expect("resolve IBM Plex Sans regular");
        let bold = text_system
            .font_id(&gpui::font("IBM Plex Sans").bold())
            .expect("resolve IBM Plex Sans semibold for bold text");
        let italic = text_system
            .font_id(&gpui::font("IBM Plex Sans").italic())
            .expect("resolve IBM Plex Sans italic");
        assert_ne!(regular, bold, "bold text should select its bundled face");
        assert_ne!(
            regular, italic,
            "italic text should select its bundled face"
        );
        assert_ne!(bold, italic);

        let mono = text_system
            .font_id(&gpui::font("Lilex"))
            .expect("resolve the bundled Lilex face");
        let run = [FontRun {
            len: 4,
            font_id: mono,
            letter_spacing: None,
        }];
        let narrow = text_system.layout_line("iiii", px(16.0), &run).width;
        let wide = text_system.layout_line("WWWW", px(16.0), &run).width;
        assert_eq!(narrow, wide, "Lilex should preserve code-column alignment");
    }

    #[test]
    fn mode_switch_keeps_authored_ranges_and_native_blocks_editable_at_both_sizes() {
        for viewport in [size(px(1280.0), px(820.0)), size(px(880.0), px(640.0))] {
            let mut cx = make_headless();
            let mut view_entity = None;
            let window = cx
                .open_window(viewport, |_, cx| {
                    let view = cx.new(|_| RichTextStudio::new());
                    view_entity = Some(view.clone());
                    view
                })
                .unwrap();
            let view = view_entity.expect("studio view");
            cx.update_window(window.into(), |_, window, cx| {
                window.draw(cx).clear(cx);
            })
            .unwrap();

            let (paragraph, code, title, task_input) = cx.update(|cx| {
                let view = view.read(cx);
                (
                    view.paragraph.as_ref().unwrap().clone(),
                    view.code.as_ref().unwrap().clone(),
                    view.title.as_ref().unwrap().clone(),
                    view.task_inputs[0].as_ref().unwrap().clone(),
                )
            });
            let before = cx.capture_screenshot(window.into()).unwrap();

            let paragraph_text = cx.update(|cx| paragraph.read(cx).as_str().to_owned());
            let selection = text_range(&paragraph_text, "rhythm");
            let selected_bounds = cx.update(|cx| {
                paragraph
                    .read(cx)
                    .bounds_for_range(selection.clone())
                    .expect("sample word has visible bounds")
            });
            let middle_y = selected_bounds.origin.y + selected_bounds.size.height / 2.0;
            dispatch_drag(
                &mut cx,
                window.into(),
                point(selected_bounds.origin.x + px(1.0), middle_y),
                point(
                    selected_bounds.origin.x + selected_bounds.size.width - px(1.0),
                    middle_y,
                ),
            );
            assert_eq!(
                cx.update(|cx| paragraph.read(cx).selection().range()),
                selection,
                "mouse drag selects a UTF-8 range in the editable rich paragraph"
            );

            let first_char = cx.update(|cx| {
                paragraph
                    .read(cx)
                    .bounds_for_range(0..1)
                    .expect("paragraph has a first glyph")
            });
            let paragraph_padding = if f32::from(viewport.width) < 960.0 {
                14.0
            } else {
                18.0
            };
            let toolbar_gap = if f32::from(viewport.width) < 960.0 {
                12.0
            } else {
                16.0
            };
            dispatch_click(
                &mut cx,
                window.into(),
                point(
                    first_char.origin.x + px(14.0 - paragraph_padding),
                    first_char.origin.y - px(paragraph_padding + toolbar_gap + 14.0),
                ),
            );
            assert!(
                cx.update(|cx| {
                    paragraph
                        .read(cx)
                        .inline_styles()
                        .overlapping(selection.clone())
                        .count()
                }) > 0,
                "the real toolbar click adds a persistent mark"
            );

            let formatted = cx.capture_screenshot(window.into()).unwrap();
            assert!(
                changed_pixels(&before, &formatted) > 40,
                "formatting changes pixels in the WGPU-rendered editor"
            );

            let snapshot = cx.update(|cx| paragraph.read(cx).rich_text_snapshot());
            assert_eq!(snapshot.as_str(), paragraph_text);
            assert!(
                snapshot.ranges().overlapping(selection.clone()).count() > 0,
                "the immutable read snapshot carries the authored marks"
            );

            let end = selection.end;
            cx.update(|cx| paragraph.update(cx, |state, cx| state.move_to(end, cx)));
            cx.update_window(window.into(), |_, window, cx| {
                window.dispatch_keystroke(gpui::Keystroke::parse("!").unwrap(), cx);
                window.draw(cx).clear(cx);
            })
            .unwrap();
            assert!(
                cx.update(|cx| paragraph.read(cx).as_str().contains("rhythm!")),
                "native key input edits the paragraph block"
            );
            assert!(
                cx.update(|cx| paragraph.read(cx).inline_styles().hit(end).count()) > 0,
                "the authored mark maps through typing at its endpoint"
            );

            let task_text = cx.update(|cx| task_input.read(cx).as_str().to_owned());
            let task_bounds = cx.update(|cx| {
                task_input
                    .read(cx)
                    .bounds_for_range(0..task_text.len())
                    .expect("editable task text has visible bounds")
            });
            let checkbox_position = point(
                task_bounds.origin.x - px(18.0),
                task_bounds.origin.y + task_bounds.size.height / 2.0,
            );
            dispatch_click(&mut cx, window.into(), checkbox_position);
            assert!(!cx.update(|cx| view.read(cx).checked[0]));

            let width = f32::from(viewport.width);
            let read_button = point(px(width - 43.0), px(30.0));
            let edit_button = point(px(width - 97.0), px(30.0));
            dispatch_click(&mut cx, window.into(), read_button);
            assert_eq!(cx.update(|cx| view.read(cx).mode), DisplayMode::Read);
            let read_mode = cx.capture_screenshot(window.into()).unwrap();
            assert!(
                changed_pixels(&formatted, &read_mode) > 40,
                "Read mode composes the same content into native read-only blocks"
            );
            let read_paragraph = cx.update(|cx| paragraph.read(cx).rich_text_snapshot());
            assert_eq!(
                read_paragraph.as_str(),
                cx.update(|cx| paragraph.read(cx).as_str().to_owned())
            );
            assert!(
                read_paragraph
                    .ranges()
                    .overlapping(selection.clone())
                    .count()
                    > 0,
                "switching modes preserves the selected inline style"
            );
            assert_eq!(
                cx.update(|cx| title.read(cx).rich_text_snapshot().as_str().to_owned()),
                INITIAL_TITLE,
                "read mode composes the title from its current document"
            );
            assert_eq!(
                cx.update(|cx| task_input.read(cx).rich_text_snapshot().as_str().to_owned()),
                INITIAL_TASKS[0],
                "read mode composes task text from its current document"
            );
            dispatch_click(&mut cx, window.into(), checkbox_position);
            assert!(
                !cx.update(|cx| view.read(cx).checked[0]),
                "read mode leaves task controls unchanged"
            );
            let readonly_paragraph = cx.update(|cx| paragraph.read(cx).as_str().to_owned());
            cx.update_window(window.into(), |_, window, cx| {
                window.dispatch_keystroke(gpui::Keystroke::parse("!").unwrap(), cx);
                window.draw(cx).clear(cx);
            })
            .unwrap();
            assert_eq!(
                cx.update(|cx| paragraph.read(cx).as_str().to_owned()),
                readonly_paragraph,
                "Read mode blurs hidden editors and prevents keyboard edits"
            );

            // The same title input, checkbox rows, and code block remain ordinary native GPUI
            // elements. Switch back to Edit before exercising each input path.
            dispatch_click(&mut cx, window.into(), edit_button);
            assert_eq!(cx.update(|cx| view.read(cx).mode), DisplayMode::Edit);
            dispatch_click(&mut cx, window.into(), checkbox_position);
            assert!(cx.update(|cx| view.read(cx).checked[0]));

            let title_text = cx.update(|cx| title.read(cx).as_str().to_owned());
            let title_bounds = cx.update(|cx| {
                title
                    .read(cx)
                    .bounds_for_range(0..title_text.len())
                    .expect("editable title has visible bounds")
            });
            dispatch_click(
                &mut cx,
                window.into(),
                point(
                    title_bounds.origin.x + title_bounds.size.width - px(1.0),
                    title_bounds.origin.y + title_bounds.size.height / 2.0,
                ),
            );
            cx.update(|cx| {
                title.update(cx, |state, cx| state.move_to(title_text.len(), cx));
            });
            cx.update_window(window.into(), |_, window, cx| {
                window.dispatch_keystroke(gpui::Keystroke::parse("!").unwrap(), cx);
                window.draw(cx).clear(cx);
            })
            .unwrap();
            assert_eq!(
                cx.update(|cx| title.read(cx).as_str().to_owned()),
                format!("{INITIAL_TITLE}!"),
                "the native heading input remains editable"
            );

            let task_text = cx.update(|cx| task_input.read(cx).as_str().to_owned());
            let task_bounds = cx.update(|cx| {
                task_input
                    .read(cx)
                    .bounds_for_range(0..task_text.len())
                    .expect("editable task text has visible bounds")
            });
            dispatch_click(
                &mut cx,
                window.into(),
                point(
                    task_bounds.origin.x + task_bounds.size.width - px(1.0),
                    task_bounds.origin.y + task_bounds.size.height / 2.0,
                ),
            );
            cx.update(|cx| {
                task_input.update(cx, |state, cx| state.move_to(task_text.len(), cx));
            });
            cx.update_window(window.into(), |_, window, cx| {
                window.dispatch_keystroke(gpui::Keystroke::parse("!").unwrap(), cx);
                window.draw(cx).clear(cx);
            })
            .unwrap();
            assert_eq!(
                cx.update(|cx| task_input.read(cx).as_str().to_owned()),
                format!("{}!", INITIAL_TASKS[0]),
                "task labels are editable text inputs"
            );

            let code_text = cx.update(|cx| code.read(cx).as_str().to_owned());
            let last = code_text.len() - 1..code_text.len();
            let last_bounds = cx.update(|cx| {
                code.read(cx)
                    .bounds_for_range(last.clone())
                    .expect("code block end has visible bounds")
            });
            dispatch_click(
                &mut cx,
                window.into(),
                point(
                    last_bounds.origin.x + last_bounds.size.width - px(1.0),
                    last_bounds.origin.y + last_bounds.size.height / 2.0,
                ),
            );
            cx.update(|cx| code.update(cx, |state, cx| state.move_to(code_text.len(), cx)));
            cx.update_window(window.into(), |_, window, cx| {
                window.dispatch_keystroke(gpui::Keystroke::parse("!").unwrap(), cx);
                window.draw(cx).clear(cx);
            })
            .unwrap();
            let edited_code = cx.update(|cx| code.read(cx).as_str().to_owned());
            assert!(
                edited_code.ends_with("}!") && !rust_token_decorations(&edited_code).is_empty(),
                "the code block accepts input and derives fresh token ranges"
            );
            assert!(before.width() > 0 && before.height() > 0);
        }
    }

    #[test]
    fn document_transaction_keeps_utf8_coordinates_and_selection() {
        let mut document = Document::new("café");
        let transaction: Transaction = document
            .transaction()
            .replace(5..5, " —")
            .selection(Selection::new(9, 9))
            .build()
            .expect("valid transaction at the UTF-8 end boundary");

        assert_eq!(transaction.base_revision(), 0);
        assert_eq!(transaction.changes().changes().len(), 1);
        assert_eq!(transaction.selection().unwrap().head, 9);
        document
            .apply(&transaction)
            .expect("matching base snapshot");
        assert_eq!(document.as_str(), "café —");
        assert_eq!(document.slice(5..9), " —");
        assert_eq!(document.len_utf16(), 6);
    }

    #[test]
    fn fixed_rust_adapter_composes_readonly_code_without_parsing() {
        let document = Document::new(RUST_SAMPLE);
        let rich = RichText::try_from_parts(
            document.shared_string(),
            rust_token_decorations(document.as_str()),
        )
        .unwrap();
        assert_eq!(rich.as_str(), RUST_SAMPLE);
        assert!(rich.ranges().len() >= 6);
    }
}
