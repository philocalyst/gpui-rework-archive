#[path = "../src/support.rs"]
mod support;

// ## Own the count {#state}
// Click Increment and the label gains one. The value behind that label is
// `Counter::count`; the button holds no separate count.
//
// [`AppContext::new`] stores `Counter` in the app and returns an [`Entity`]
// handle. Cloning that handle refers to the same counter and keeps it alive;
// it does not copy the field. [`Context`] is the scoped capability passed to
// callbacks and render methods, so this example mutates the view through its
// listener rather than borrowing the entity again.

use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, rgb};

struct Counter {
    count: u32,
}

// ## Read state into a frame {#render}
// [`Render`] reads the count while building the label and button for this
// frame. Styling sets their layout and appearance. The button ID gives its
// interaction state a stable identity as the element values are rebuilt.
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
// [`Context::notify`] reports that this entity's observable state changed.
// GPUI schedules affected views to render again; the next render reads the new
// count. Assigning a field alone does not schedule that update. This separates
// mutation from invalidation, which matters when state is changed outside a
// render callback.
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
