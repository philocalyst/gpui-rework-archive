#[path = "../src/support.rs"]
mod support;

// ## Keep a keyboard target {#focus}
// Pressing Space will increment this counter. [`FocusHandle`] identifies a
// focus target; `track_focus` attaches it to the element tree through the
// [`InteractiveElement`] trait and places it on the path that receives keyboard actions. Merely storing
// the handle on the view creates no path and receives no keys.
//
// Click inside the preview before pressing Space. In a browser there are two
// focus boundaries: the page must focus the preview frame, then GPUI must
// focus this view within its window.

use gpui::{
    AppContext, Context, FocusHandle, IntoElement, KeyBinding, Render, Window, actions, div,
    prelude::*, rgb, text,
};

actions!(counter_keys, [Increment]);

struct KeyboardCounter {
    count: u32,
    focus: FocusHandle,
}

// ## Bind an operation in a context {#bindings}
// The [`actions`] macro declares the typed operation `Increment`. A
// [`KeyBinding`] maps Space to that operation when the focused element path
// contains the `Counter` key context. [`App::bind_keys`] installs the mapping
// during setup; [`Window::focus`] selects this view's handle when the window
// opens. Binding and handling are separate: a key produces an action, then an
// element on the dispatch path decides what that action does.
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
// The root's `key_context` supplies the context predicate used by the binding.
// [`Context::listener`] gives the handler scoped access to this view, and
// [`Context::notify`] schedules a render after the count changes. The keymap
// chooses *when* the operation is dispatched; the action listener defines its
// effect on this view.
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
            .child(text!(format!("Count: {}", self.count)))
            .child(text!("Press Space to increment"))
    }
}
