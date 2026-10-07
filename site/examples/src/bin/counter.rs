#[path = "../support.rs"]
mod support;

// docs:step state | Put the value on the view
// The counter starts with one field. GPUI owns this value; an `Entity<Counter>`
// is the handle used to read or update it. A clone of the handle refers to the
// same counter, rather than copying its `count`.
//
// Keeping state on the view makes the next two steps explicit: rendering reads
// the field, and a click changes it. There is no second copy of the count in an element.
// docs:api gpui::Entity gpui::Context
// docs:code
use gpui::{AppContext, Context, IntoElement, Render, Window, div, prelude::*, rgb};

struct Counter {
    count: u32,
}
// docs:end

// docs:step render | Build the next frame from that value
// `render` returns the element tree for the current count. The outer `Div`
// arranges a label and a button in a column. The button has a stable ID because
// GPUI uses that identity to retain interaction state across frames.
//
// The listener borrows the counter through its `Context<Counter>`. Its arguments
// are the counter, the click event, the window, and the context. We only need
// the counter and context here.
// docs:api gpui::Render gpui::InteractiveElement gpui::Context::listener
// docs:code
impl Render for Counter {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full().flex().flex_col().items_center().justify_center().gap_4()
            .bg(rgb(0xf7f6f2)).text_color(rgb(0x202b29))
            .child(div().text_2xl().child(format!("Count: {}", self.count)))
            .child(
                div().id("increment").px_4().py_2().rounded_md()
                    .bg(rgb(0x155b50)).text_color(rgb(0xffffff)).cursor_pointer()
                    .child("Increment")
                    .on_click(cx.listener(|this, _event, _window, cx| this.increment(cx))),
            )
    }
}
// docs:end

// docs:step update | Change the state and request a redraw
// `notify` tells observers that this entity changed and invalidates its view.
// The next render reads the new count. Mutation alone does not make that request.
//
// Try removing `cx.notify()` locally. The field still changes on a click, but
// the label can remain stale until another event causes the view to render.
// `saturating_add` keeps repeated clicks from overflowing the integer.
// docs:api gpui::Context::notify
// docs:code
impl Counter {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count = self.count.saturating_add(1);
        cx.notify();
    }
}

pub fn main() {
    support::run(|_window, cx| cx.new(|_cx| Counter { count: 0 }));
}
// docs:end
