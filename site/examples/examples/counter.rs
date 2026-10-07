#[path = "../src/support.rs"]
mod support;

// ## Own the count {#state}
// Click Increment and the label gains one. The value behind that label is
// `Counter::count`; the button holds no separate count.
//
// GPUI stores the `Counter` and gives its owner an [`Entity`] handle. Cloning
// the handle keeps the same counter alive. It does not copy the field. During
// an update, [`Context`] grants access to this counter and the rest of the app.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, rgb};

struct Counter {
    count: u32,
}

// ## Read state into a frame {#render}
// [`Render`] builds a label from the current count and puts a button below it.
// The styling controls their appearance; the button's ID keeps its interaction
// state associated with this button across frames.
//
// [`Context::listener`] supplies the counter to the click handler. Its other
// arguments are the click event, the window, and the counter's context. The
// handler uses the supplied `&mut Counter` rather than borrowing it again
// through an entity handle.

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
            .child(div().text_2xl().child(format!("Count: {}", self.count)))
            .child(
                div()
                    .id("increment")
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
// [`Context::notify`] queues a change notification. GPUI invalidates rendering
// that depends on this entity, and the next render reads the updated count.
// Assigning a field does not send that notification for you.
//
// Remove `cx.notify()` and run again. Clicks still change the field, but the
// label can stay stale until other work causes a render. Restore the call and
// the mutation and displayed value stay connected. `saturating_add` also makes
// the counter stop at `u32::MAX` rather than overflow.

impl Counter {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count = self.count.saturating_add(1);
        cx.notify();
    }
}

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<Counter> {
    cx.new(|_cx| Counter { count: 0 })
}

pub fn main() {
    support::run(component);
}
