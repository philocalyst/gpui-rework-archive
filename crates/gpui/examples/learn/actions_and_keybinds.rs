//! Bind typed actions to keyboard shortcuts in a focused view.
//! Press Space to increment the counter and Backspace to reset it.

#![cfg_attr(target_family = "wasm", no_main)]

use gpui::colors::Colors;
use gpui::{
    App, Context, FocusHandle, KeyBinding, KeyDownEvent, Keystroke, PlatformInput, Window, actions,
    div, prelude::*, px, size,
};
use std::time::Duration;

#[path = "../shared/prelude.rs"]
mod example_prelude;

actions!(keybinds_example, [Increment, Reset]);

fn register_keybinds(cx: &mut App) {
    cx.bind_keys([
        KeyBinding::new("space", Increment, Some("Counter")),
        KeyBinding::new("backspace", Reset, Some("Counter")),
    ]);
}

struct ActionsExample {
    count: usize,
    focus_handle: FocusHandle,
}

impl ActionsExample {
    fn new(window: &mut Window, cx: &mut Context<Self>) -> Self {
        let focus_handle = cx.focus_handle();
        window.focus(&focus_handle, cx);

        Self {
            count: 0,
            focus_handle,
        }
    }

    fn increment(&mut self, _action: &Increment, _window: &mut Window, cx: &mut Context<Self>) {
        self.count += 1;
        cx.notify();
    }

    fn reset(&mut self, _action: &Reset, _window: &mut Window, cx: &mut Context<Self>) {
        self.count = 0;
        cx.notify();
    }
}

impl Render for ActionsExample {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let colors = Colors::for_appearance(window);

        div()
            .id("counter")
            .key_context("Counter")
            .track_focus(&self.focus_handle)
            .on_action(cx.listener(Self::increment))
            .on_action(cx.listener(Self::reset))
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .size_full()
            .bg(colors.background)
            .text_color(colors.text)
            .child(div().text_3xl().child(format!("Count: {}", self.count)))
            .child("Space to increment. Backspace to reset.")
    }
}

fn actions_scenario() -> anyhow::Result<gpui_test::Scenario<ActionsExample>> {
    Ok(gpui_test::Scenario::new(
        "actions-and-keybinds",
        "Actions and keybinds",
        size(px(480.), px(240.)),
        |window, cx: &mut App| {
            register_keybinds(cx);
            cx.new(|cx| ActionsExample::new(window, cx))
        },
    )?
    .checkpoint("initial", "Focused counter", Duration::ZERO)?
    .checkpoint_with(
        "incremented",
        "Space dispatches the increment action",
        Duration::from_millis(100),
        |cx, view, window| {
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::KeyDown(KeyDownEvent {
                    keystroke: Keystroke::parse("space")?,
                    is_held: false,
                    prefer_character_input: false,
                }),
            )?;
            anyhow::ensure!(view.read_with(cx, |view, _| view.count) == 1);
            Ok(())
        },
    )?
    .checkpoint_with(
        "reset",
        "Backspace dispatches reset",
        Duration::from_millis(200),
        |cx, view, window| {
            gpui_test::dispatch_input(
                cx,
                window.into(),
                PlatformInput::KeyDown(KeyDownEvent {
                    keystroke: Keystroke::parse("backspace")?,
                    is_held: false,
                    prefer_character_input: false,
                }),
            )?;
            anyhow::ensure!(view.read_with(cx, |view, _| view.count) == 0);
            Ok(())
        },
    )?)
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    example_prelude::run_example(actions_scenario().expect("valid action scenario"))
        .expect("run actions example");
}

#[cfg(target_family = "wasm")]
#[wasm_bindgen::prelude::wasm_bindgen(start)]
pub fn start() {
    gpui_platform::web_init();
    example_prelude::run_example(actions_scenario().expect("valid action scenario"))
        .expect("run actions example");
}
