//! Interactive, conditional, and theme-aware styling patterns.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::colors::Colors;
use gpui::{
    App, ColorExt, Context, FocusHandle, Hsla, KeyBinding, Render, Rgba, Window, actions, div,
    prelude::*, px, rgb,
};
use palette::{IntoColor, WithAlpha};

actions!(styling_example, [Tab, TabPrev]);

fn section(colors: &Colors, title: &'static str, content: impl IntoElement) -> gpui::Div {
    let surface: Hsla = colors.container.into_color();
    let border: Hsla = colors.border.into_color();
    div()
        .flex()
        .flex_col()
        .gap_3()
        .p_4()
        .rounded_lg()
        .bg(surface.opacity(0.3))
        .border_1()
        .border_color(border.opacity(0.5))
        .child(
            div()
                .text_sm()
                .font_weight(gpui::FontWeight::SEMIBOLD)
                .text_color(colors.text)
                .child(title),
        )
        .child(content)
}

fn note(colors: &Colors, text: &'static str) -> gpui::Div {
    div().text_xs().text_color(colors.disabled).child(text)
}

fn button(id: &'static str, label: &'static str, colors: &Colors) -> gpui::Stateful<gpui::Div> {
    div()
        .id(id)
        .px_4()
        .py_2()
        .rounded_md()
        .cursor_pointer()
        .bg(colors.selected)
        .text_color(colors.selected_text)
        .text_sm()
        .hover(|style| style.opacity(0.85))
        .active(|style| style.opacity(0.7))
        .child(label)
}

fn focus_button(
    id: &'static str,
    handle: &FocusHandle,
    colors: &Colors,
) -> gpui::Stateful<gpui::Div> {
    let ring: Rgba = rgb(0x60a5fa);
    let accent = colors.selected;
    let surface_hover = colors.selected;
    div()
        .id(id)
        .track_focus(handle)
        .px_4()
        .py_2()
        .rounded_md()
        .cursor_pointer()
        .bg(colors.container)
        .text_color(colors.text)
        .text_sm()
        .border_2()
        .border_color(gpui::transparent_black())
        .hover(move |style| style.bg(surface_hover))
        .focus(move |style| style.border_color(accent))
        .focus_visible(move |style| style.border_color(ring).shadow_sm())
        .child("Tab stop")
}

fn choice(label: &'static str, selected: bool, disabled: bool, colors: &Colors) -> gpui::Div {
    let mut item = div()
        .px_3()
        .py_2()
        .rounded_md()
        .text_sm()
        .border_1()
        .border_color(gpui::transparent_black())
        .child(label);
    if disabled {
        item = item
            .cursor_not_allowed()
            .opacity(0.5)
            .bg(colors.container)
            .text_color(colors.disabled);
    } else if selected {
        let selected: Hsla = colors.selected.into_color();
        item = item
            .bg(selected.opacity(0.2))
            .border_color(colors.selected)
            .text_color(colors.text);
    } else {
        let hover = colors.selected;
        item = item
            .cursor_pointer()
            .bg(colors.container)
            .text_color(colors.text)
            .hover(move |style| style.bg(hover));
    }
    item
}

fn group_card(title: &'static str, colors: &Colors) -> gpui::Div {
    let border = colors.border;
    let accent = colors.selected;
    let text = colors.text;
    let muted = colors.disabled;
    div()
        .group("card")
        .p_3()
        .rounded_md()
        .border_1()
        .border_color(border)
        .hover(move |style| style.border_color(accent))
        .child(
            div()
                .flex()
                .justify_between()
                .child(div().text_sm().text_color(text).child(title))
                .child(
                    div()
                        .text_xs()
                        .text_color(muted)
                        .opacity(0.)
                        .group_hover("card", |style| style.opacity(1.))
                        .child("→"),
                ),
        )
        .child(note(
            colors,
            "The child appears when its parent is hovered.",
        ))
}

struct StylingExample {
    root_focus: FocusHandle,
    tab_stops: [FocusHandle; 3],
}

impl StylingExample {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let root_focus = cx.focus_handle();
        window.focus(&root_focus, cx);
        Self {
            root_focus,
            tab_stops: std::array::from_fn(|index| {
                cx.focus_handle()
                    .tab_index(index as isize + 1)
                    .tab_stop(true)
            }),
        }
    }

    #[cfg(test)]
    fn focused_tab_stop(&self, window: &Window) -> Option<usize> {
        self.tab_stops
            .iter()
            .position(|handle| handle.is_focused(window))
    }

    fn tab(&mut self, _: &Tab, window: &mut Window, cx: &mut Context<Self>) {
        window.focus_next(cx);
    }

    fn tab_prev(&mut self, _: &TabPrev, window: &mut Window, cx: &mut Context<Self>) {
        window.focus_prev(cx);
    }
}

impl Render for StylingExample {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);
        let swatches = [
            ("background", colors.background),
            ("container", colors.container),
            ("selected", colors.selected),
            ("border", colors.border),
            ("success", rgb(0x388e3c)),
            ("warning", rgb(0xf9a825)),
            ("error", rgb(0xd32f2f)),
        ];

        div()
            .id("styling")
            .track_focus(&self.root_focus)
            .on_action(cx.listener(Self::tab))
            .on_action(cx.listener(Self::tab_prev))
            .size_full()
            .p_6()
            .bg(colors.background)
            .overflow_scroll()
            .child(
                div()
                    .flex()
                    .flex_col()
                    .gap_4()
                    .max_w(px(520.))
                    .child(
                        div()
                            .text_xl()
                            .font_weight(gpui::FontWeight::BOLD)
                            .text_color(colors.text)
                            .child("Styling"),
                    )
                    .child(section(
                        &colors,
                        "Pointer states",
                        div()
                            .flex()
                            .flex_col()
                            .gap_2()
                            .child(note(
                                &colors,
                                "Hover and press to see hover() and active().",
                            ))
                            .child(
                                div()
                                    .flex()
                                    .gap_2()
                                    .child(button("hover", "Hover", &colors))
                                    .child(button("press", "Press", &colors)),
                            ),
                    ))
                    .child(section(
                        &colors,
                        "Keyboard focus",
                        div()
                            .flex()
                            .flex_col()
                            .gap_2()
                            .child(note(
                                &colors,
                                "Tab through stops; focus_visible() distinguishes keyboard focus.",
                            ))
                            .child(div().flex().gap_2().children(
                                self.tab_stops.iter().enumerate().map(|(i, handle)| {
                                    focus_button(
                                        match i {
                                            0 => "focus-1",
                                            1 => "focus-2",
                                            _ => "focus-3",
                                        },
                                        handle,
                                        &colors,
                                    )
                                }),
                            )),
                    ))
                    .child(section(
                        &colors,
                        "Conditional styles",
                        div()
                            .flex()
                            .flex_col()
                            .gap_2()
                            .child(note(
                                &colors,
                                "Choose a branch with ordinary Rust state or props.",
                            ))
                            .child(
                                div()
                                    .flex()
                                    .flex_col()
                                    .gap_1()
                                    .child(choice("Normal", false, false, &colors))
                                    .child(choice("Selected", true, false, &colors))
                                    .child(choice("Disabled", false, true, &colors)),
                            )
                            .child(
                                div().flex().flex_wrap().gap_2().children(
                                    [
                                        ("Success", rgb(0x388e3c), colors.selected_text),
                                        ("Warning", rgb(0xf9a825), rgb(0x000000)),
                                        ("Error", rgb(0xd32f2f), colors.selected_text),
                                        ("Neutral", colors.container, colors.text),
                                    ]
                                    .into_iter()
                                    .map(|(name, bg, fg)| {
                                        div()
                                            .px_2()
                                            .py_0p5()
                                            .rounded_full()
                                            .text_xs()
                                            .bg(bg)
                                            .text_color(fg)
                                            .child(name)
                                    }),
                                ),
                            ),
                    ))
                    .child(section(
                        &colors,
                        "Group hover and theme colors",
                        div()
                            .flex()
                            .flex_col()
                            .gap_2()
                            .child(group_card("Documents", &colors))
                            .child(div().flex().flex_wrap().gap_2().children(
                                swatches.into_iter().map(|(name, color)| {
                                    div()
                                        .flex()
                                        .flex_col()
                                        .items_center()
                                        .gap_1()
                                        .child(
                                            div()
                                                .size_8()
                                                .rounded_md()
                                                .bg(color)
                                                .border_1()
                                                .border_color(gpui::white().with_alpha(0.2)),
                                        )
                                        .child(note(&colors, name))
                                }),
                            )),
                    )),
            )
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        bind_keys(cx);
        let options = example_prelude::centered_window(560., 760., cx);
        cx.open_window(options, |window, cx| {
            cx.new(|cx| StylingExample::new(window, cx))
        })
        .expect("open styling example");
        example_prelude::init_example(cx, "Styling");
    });
}

fn bind_keys(cx: &mut App) {
    cx.bind_keys([
        KeyBinding::new("tab", Tab, None),
        KeyBinding::new("shift-tab", TabPrev, None),
    ]);
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui::{KeyDownEvent, Keystroke, PlatformInput, px, size};
    use gpui_test::{Harness, Scenario, dispatch_input};
    use std::time::Duration;

    fn press_and_expect_focus(
        cx: &mut gpui::HeadlessAppContext,
        view: &gpui::Entity<StylingExample>,
        window: gpui::WindowHandle<StylingExample>,
        key: &str,
        expected: usize,
    ) -> anyhow::Result<()> {
        dispatch_input(
            cx,
            window.into(),
            PlatformInput::KeyDown(KeyDownEvent {
                keystroke: Keystroke::parse(key)?,
                is_held: false,
                prefer_character_input: false,
            }),
        )?;
        let focused = cx.update_window(window.into(), |_, window, app| {
            view.read(app).focused_tab_stop(window)
        })?;
        anyhow::ensure!(
            focused == Some(expected),
            "{key} focused {focused:?}, expected stop {expected}"
        );
        Ok(())
    }

    #[test]
    fn tab_and_shift_tab_move_real_focus_between_styled_controls() -> anyhow::Result<()> {
        let scenario = Scenario::new(
            "styling-focus-test",
            "Keyboard focus styling",
            size(px(560.), px(760.)),
            |window, cx: &mut App| {
                bind_keys(cx);
                cx.new(|cx| StylingExample::new(window, cx))
            },
        )?
        .checkpoint("initial", "Root focus", Duration::ZERO)?
        .checkpoint_with(
            "first-stop",
            "Tab to first control",
            Duration::from_millis(1),
            |cx, view, window| press_and_expect_focus(cx, view, window, "tab", 0),
        )?
        .checkpoint_with(
            "second-stop",
            "Tab to second control",
            Duration::from_millis(2),
            |cx, view, window| press_and_expect_focus(cx, view, window, "tab", 1),
        )?
        .checkpoint_with(
            "shift-tab",
            "Reverse to first control",
            Duration::from_millis(3),
            |cx, view, window| press_and_expect_focus(cx, view, window, "shift-tab", 0),
        )?;

        Harness::new().run(&scenario)?;
        Ok(())
    }
}
