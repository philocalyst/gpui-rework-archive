#[path = "../src/support.rs"]
mod support;

// ## Keep a keyboard target {#focus}
// Pressing Space will increment this counter. The view owns a [`FocusHandle`]
// and attaches it to the root element with `track_focus`. Keeping a handle on
// the view alone does not attach a keyboard target to the element tree.
//
// Click inside the browser preview before pressing Space. The page's focus
// must enter the iframe as well as GPUI's focus entering this view.

use gpui::{
    AppContext, Context, FocusHandle, IntoElement, KeyBinding, Render, Window, actions, div,
    prelude::*, rgb,
};

actions!(counter_keys, [Increment]);

struct KeyboardCounter {
    count: u32,
    focus: FocusHandle,
}

// ## Bind an operation in a context {#bindings}
// The [`actions`] macro declares `Increment`. A [`KeyBinding`] maps Space to
// that operation when the focused path contains the `Counter` key context.
// [`App::bind_keys`] installs the binding during setup; [`Window::focus`]
// selects this view's handle when the window opens.
//
// A shortcut belongs to an operation, not to a particular input device. A
// menu or another control can dispatch the same action without synthesizing
// Space.

fn component(window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<KeyboardCounter> {
    cx.bind_keys([KeyBinding::new("space", Increment, Some("Counter"))]);
    cx.new(|cx| {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        KeyboardCounter { count: 0, focus }
    })
}

pub fn main() {
    support::run(component);
}

// ## Handle the action on its path {#dispatch}
// The root's `key_context` supplies the predicate used by the binding.
// [`Context::listener`] adapts the action handler to this view, and
// [`Context::notify`] connects its changed count to the next frame.
//
// Remove `track_focus` and run again: the handle exists, but this root is no
// longer on its focus path. Restore it to receive Space. Read the
// [focus guide](@/guides/focus.md) for action propagation and multi-stroke keys.

impl Render for KeyboardCounter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("keyboard-counter")
            .key_context("Counter")
            .track_focus(&self.focus)
            .on_action(cx.listener(|this, _action: &Increment, _window, cx| {
                this.count = this.count.saturating_add(1);
                cx.notify();
            }))
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(format!("Count: {}", self.count))
            .child("Press Space to increment")
    }
}
