#[path = "../support.rs"]
mod support;

// docs:step focus | Give keyboard input somewhere to go
// Keyboard actions follow the focus path. This view keeps a `FocusHandle`,
// then focuses it when the window opens. Rendering attaches the handle to
// an element through `track_focus`; keeping the handle alone does not place it
// in the element tree.
//
// Click inside the browser preview before pressing Space. The page and the
// embedded GPUI window have separate focus.
// docs:api gpui::FocusHandle gpui::Window::focus
// docs:code
use gpui::{AppContext, Context, FocusHandle, IntoElement, KeyBinding, Render, Window,
    actions, div, prelude::*, rgb};

actions!(counter_keys, [Increment]);

struct KeyboardCounter {
    count: u32,
    focus: FocusHandle,
}
// docs:end

// docs:step bindings | Translate a key into an operation
// An action names an operation independently of its shortcut. The binding
// matches Space only on a focus path with the `Counter` key context. Other
// views can bind the same key to a different operation.
//
// Bindings are installed once during application setup. Registering them on
// every render would repeat work unrelated to the current frame.
// docs:api gpui::actions gpui::KeyBinding gpui::App::bind_keys
// docs:code
pub fn main() {
    support::run(|window, cx| {
        cx.bind_keys([KeyBinding::new("space", Increment, Some("Counter"))]);
        cx.new(|cx| {
            let focus = cx.focus_handle();
            window.focus(&focus, cx);
            KeyboardCounter { count: 0, focus }
        })
    });
}
// docs:end

// docs:step dispatch | Handle the action on the focused element
// The root supplies the matching key context and action listener. Pressing
// Space dispatches `Increment` to this handler; the handler updates state and
// requests a redraw just as a click listener would.
//
// Use the same action for a menu item or another input device when it represents
// the same operation. See [focus and dispatch](@/guides/focus.md) for propagation
// and the difference between key listeners and action listeners.
// docs:api gpui::StatefulInteractiveElement gpui::Context::listener gpui::Context::notify
// docs:code
impl Render for KeyboardCounter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div().id("keyboard-counter").key_context("Counter").track_focus(&self.focus)
            .on_action(cx.listener(|this, _action: &Increment, _window, cx| {
                this.count = this.count.saturating_add(1);
                cx.notify();
            }))
            .size_full().flex().flex_col().items_center().justify_center().gap_4()
            .bg(rgb(0xf7f6f2)).text_color(rgb(0x202b29))
            .child(format!("Count: {}", self.count))
            .child("Press Space to increment")
    }
}
// docs:end
