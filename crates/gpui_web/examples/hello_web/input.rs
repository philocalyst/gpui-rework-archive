//! Minimal text-field fixture for browser glyph-fallback acceptance.

use std::borrow::Cow;

use gpui::{App, Context, Render, Window, WindowOptions, div, prelude::*, px, rgb};
use gpui_elements::editable_text::{
    actions::{DEFAULT_INPUT_CONTEXT, default_bindings},
    text_input,
};

struct FallbackInput;

impl Render for FallbackInput {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .bg(rgb(0xffffff))
            .text_color(rgb(0x202030))
            .flex()
            .items_center()
            .justify_center()
            .child(
                div()
                    .w_full()
                    .max_w(px(520.))
                    .p_6()
                    .flex()
                    .flex_col()
                    .gap_4()
                    .child(div().text_xl().child("Text fallback acceptance"))
                    .child(
                        text_input("fallback-input")
                            .font_family("IBM Plex Sans")
                            .placeholder("Type text here")
                            .placeholder_color(rgb(0x666666))
                            .w_full()
                            .min_h_auto()
                            .max_h_auto()
                            .whitespace_nowrap()
                            .px_3()
                            .py_2()
                            .border_1()
                            .border_color(rgb(0x888888))
                            .bg(rgb(0xffffff)),
                    ),
            )
    }
}

fn requested_backend() -> gpui_platform::WebBackendPreference {
    let search = web_sys::window()
        .and_then(|window| window.location().search().ok())
        .unwrap_or_default();
    if search
        .trim_start_matches('?')
        .split('&')
        .any(|parameter| parameter == "backend=webgpu")
    {
        gpui_platform::WebBackendPreference::WebGpu
    } else if search
        .trim_start_matches('?')
        .split('&')
        .any(|parameter| parameter == "backend=webgl")
    {
        gpui_platform::WebBackendPreference::WebGl
    } else {
        gpui_platform::WebBackendPreference::Auto
    }
}

fn main() {
    gpui_platform::web_init();
    gpui_platform::application_with_web_backend(requested_backend()).run(|cx: &mut App| {
        cx.bind_keys(default_bindings().as_keybindings(Some(DEFAULT_INPUT_CONTEXT)));
        cx.text_system()
            .add_fonts(vec![Cow::Borrowed(include_bytes!(
                "../../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf"
            ))])
            .expect("the bundled IBM Plex font is valid");
        cx.open_window(WindowOptions::default(), |_window, cx| {
            cx.new(|_cx| FallbackInput)
        })
        .expect("failed to open text fallback window");
        cx.activate(true);
    });
}
