#[path = "../src/support.rs"]
mod support;

// ## Own the count {#state}
// Click Increment and the label gains one. `Counter` owns the count; the label
// and button are rebuilt from that value when GPUI renders the view.
//
// GPUI stores the view in an [`Entity`]. Cloning its handle keeps the same
// counter alive, with the same field. The constructor below starts it at zero.

use gpui::{
    AppContext, Context, FocusHandle, IntoElement, Render, Role, Window, div, prelude::*, rgb, text,
};

struct Counter {
    count: u32,
    focus: FocusHandle,
}

// ## Read state into a frame {#render}
// [`Render`] reads the count while building the label and button for this
// frame. Styling sets their layout and appearance. The button ID gives its
// interaction state a stable identity as the element values are rebuilt.
//
// The [`Context`] belongs to this counter for the duration of `render`.
// [`Context::listener`] creates a callback that can update it later, when the
// button is activated. The callback receives `&mut Counter`; its other
// arguments are the click event, the window, and the counter's context. The
// entity is already borrowed there, so use that supplied counter to change it.
//
// [`text`] gives the changing label an accessibility node. The button's
// [`StatefulInteractiveElement::role`] and label identify its purpose;
// [`InteractiveElement::tab_index`] records its place in the focus order.
// The root's key listener moves through that order on Tab or Shift+Tab;
// registering a tab stop alone does not bind those keys. Once focused,
// [`StatefulInteractiveElement::on_click`] also accepts Enter and Space.
// `focus_visible` draws a ring during keyboard navigation. Try clicking, then
// use Tab and Enter or Space to reach the same operation. Run the native
// example with assistive technology to check its named button and Click action.

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .track_focus(&self.focus)
            .on_key_down(|event, window, cx| {
                let mut modifiers = event.keystroke.modifiers;
                let reverse = modifiers.shift;
                modifiers.shift = false;
                if event.keystroke.key == "tab" && !modifiers.modified() {
                    if reverse {
                        window.focus_prev(cx);
                    } else {
                        window.focus_next(cx);
                    }
                    cx.stop_propagation();
                }
            })
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(
                div()
                    .text_2xl()
                    .child(text!(format!("Count: {}", self.count))),
            )
            .child(
                div()
                    .id("increment")
                    .role(Role::Button)
                    .aria_label("Increment")
                    .tab_index(0)
                    .focus_visible(|style| style.ring_2().ring_color(rgb(0x3478c8)))
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .cursor_pointer()
                    .child("Increment")
                    .on_click(cx.listener(|this, _event, _window, cx| this.increment(cx))),
            )
    }
}

// ## Change the value, then notify {#update}
// `increment` changes the field, then calls [`Context::notify`]. GPUI marks
// affected views for rendering; the next frame reads the new count. Notification
// does not paint the label inside this callback. Assigning the field alone
// does not request that frame.
//
// Other work, including a button's interaction styling, can also redraw the
// window and conceal a missing notification. Do not rely on that redraw to
// publish a model change. The [notification test](@/guides/testing.md#make-the-assertion-at-the-right-boundary)
// checks the consumer directly, so removing `notify` breaks its assertion.
// `saturating_add` makes this counter stop at `u32::MAX` rather than overflow.
//
// To change its behavior, replace `saturating_add(1)` with `saturating_add(5)`.
// Run while the count is one: a compatible edit keeps that one, and the next
// activation displays six. The [editing guide](@/guides/live-editing.md)
// explains when an edit requires a fresh component instead.

impl Counter {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count = self.count.saturating_add(1);
        cx.notify();
    }
}

// ## Create the view and open a window {#launch}
// [`AppContext::new`] stores a counter starting at zero and returns its entity
// handle. The shared launcher calls this constructor while opening a window
// and uses the returned entity as its root view. On desktop, closing the last
// example window quits the application.
//
// The constructor selects a root [`FocusHandle`] before the first frame.
// `track_focus` attaches it when rendering, so the root can receive the first
// Tab even before any button has been clicked. Focus and the count belong to
// the same view, but represent separate state.
//
// Run it with `cargo run -p gpui-documentation-examples --example counter`.
// To change window options or application setup, continue
// with [the first-window example](@/examples/first-window.md).

fn component(window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Counter> {
    cx.new(|cx| {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        Counter { count: 0, focus }
    })
}

pub fn main() {
    support::run(component);
}
