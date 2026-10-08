#[path = "../src/support.rs"]
mod support;

// ## Own the count {#state}
// Click Increment and the label gains one. `Counter` owns the count; the label
// and button are rebuilt from that value when GPUI renders the view.
//
// GPUI stores the view in an [`Entity`]. Cloning its handle keeps the same
// counter alive, with the same field. The constructor at the end of this
// program creates that entity; first, define what it stores and renders.

use gpui::{AppContext, Context, IntoElement, Render, Role, Window, div, prelude::*, rgb, text};

struct Counter {
    count: u32,
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
// [`InteractiveElement::tab_index`] makes it reachable with Tab. Once focused,
// [`StatefulInteractiveElement::on_click`] also accepts Enter and Space.
// `focus_visible` draws a ring during keyboard navigation. Try clicking, then
// use Tab and Enter or Space to reach the same operation. Run the native
// example with assistive technology to check its named button and Click action.

impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
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
// Remove `cx.notify()` and run again. Clicks still change the field, but the
// label can stay stale until other work causes a render. Restore the call and
// the label follows the field again. `saturating_add` makes the counter stop
// at `u32::MAX` rather than overflow.

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
// Run it with `cargo run -p gpui-documentation-examples --example counter`.
// To change window options or application setup, continue
// with [the first-window example](@/examples/first-window.md).

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Counter> {
    cx.new(|_cx| Counter { count: 0 })
}

pub fn main() {
    support::run(component);
}
