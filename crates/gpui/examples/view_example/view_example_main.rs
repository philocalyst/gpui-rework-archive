#![cfg_attr(target_family = "wasm", no_main)]

//! Compose string-backed and editor-backed inputs, text areas, and cursor readouts.

#[path = "../shared/prelude.rs"]
mod example_prelude;

mod example_editor;
mod example_input;
mod example_text_area;

#[cfg(all(test, feature = "test-support"))]
mod example_tests;

use example_editor::Editor;
use example_input::Input;
use example_text_area::TextArea;

use gpui::{
    App, Context, Div, Entity, IntoElement, KeyBinding, Render, SharedString, Window, actions, div,
    hsla, prelude::*, px, rgb, size,
};

actions!(
    view_example,
    [Backspace, Delete, Left, Right, Home, End, Enter, Quit]
);

/// A stateless sibling that reads the same editor as the input.
///
/// Reading the entity during rendering registers the containing view's
/// dependency. The editor's notifications therefore refresh this readout too.
#[derive(IntoElement)]
struct CursorReadout {
    editor: Entity<Editor>,
}

impl CursorReadout {
    fn new(editor: Entity<Editor>) -> Self {
        Self { editor }
    }
}

impl gpui::RenderOnce for CursorReadout {
    fn render(self, _window: &mut Window, cx: &mut App) -> impl IntoElement {
        let cursor = self.editor.read(cx).cursor;
        div()
            .text_sm()
            .text_color(hsla(0., 0., 0.45, 1.))
            .child(SharedString::from(format!("cursor @ {cursor}")))
    }
}

struct ViewExample;

impl ViewExample {
    fn new() -> Self {
        Self
    }
}

impl Render for ViewExample {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // Each hook call site retains one buffer or editor between frames.
        let name = window.use_state(cx, |_, _| String::new());
        let email = window.use_state(cx, |_, _| String::from("me@example.com"));
        let bio = window.use_state(cx, |_, _| String::new());
        // Retain editors directly when another component needs their caret state.
        let notes = window.use_state(cx, |window, cx| Editor::new("multi\nline", window, cx));
        let owned = window.use_state(cx, |window, cx| Editor::new("editable", window, cx));

        div()
            .flex()
            .flex_col()
            .size_full()
            .bg(rgb(0xf0f0f0))
            .p(px(24.))
            .gap(px(24.))
            .child(
                section("Inputs — from a String (cursor stays internal)")
                    .child(Input::new(name, "Name").width(px(320.)))
                    .child(
                        Input::new(email, "Email")
                            .width(px(320.))
                            .color(hsla(0., 0., 0.3, 1.)),
                    ),
            )
            .child(
                section("Input — from an Editor (read its cursor beside it)").child(
                    div()
                        .flex()
                        .items_center()
                        .gap(px(12.))
                        .child(Input::editor(owned.clone(), "Shared editor").width(px(320.)))
                        .child(CursorReadout::new(owned)),
                ),
            )
            .child(
                section("Text areas — from a String, or from an Editor")
                    .child(TextArea::new(bio, 3, "Biography"))
                    .child(
                        div()
                            .flex()
                            .items_start()
                            .gap(px(12.))
                            .child(TextArea::editor(notes.clone(), 3, "Notes").color(hsla(
                                250. / 360.,
                                0.7,
                                0.4,
                                1.,
                            )))
                            .child(CursorReadout::new(notes)),
                    ),
            )
    }
}

/// A labeled vertical section.
fn section(title: &str) -> Div {
    div().flex().flex_col().gap(px(8.)).child(
        div()
            .text_sm()
            .text_color(hsla(0., 0., 0.3, 1.))
            .child(SharedString::from(title.to_string())),
    )
}

fn view_factory(_window: &mut Window, cx: &mut App) -> Entity<ViewExample> {
    cx.bind_keys([
        KeyBinding::new("backspace", Backspace, Some("TextInput")),
        KeyBinding::new("delete", Delete, Some("TextInput")),
        KeyBinding::new("left", Left, Some("TextInput")),
        KeyBinding::new("right", Right, Some("TextInput")),
        KeyBinding::new("home", Home, Some("TextInput")),
        KeyBinding::new("end", End, Some("TextInput")),
        KeyBinding::new("enter", Enter, Some("TextInput")),
        KeyBinding::new("cmd-q", Quit, None),
    ]);
    cx.on_action(|_: &Quit, cx| cx.quit());
    cx.new(|_| ViewExample::new())
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example(
        "Composed text inputs and text areas",
        size(px(560.), px(480.)),
        view_factory,
    );
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example(
        "Composed text inputs and text areas",
        size(px(560.), px(480.)),
        view_factory,
    );
}
