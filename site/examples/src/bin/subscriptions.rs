#[path = "../support.rs"]
mod support;

// docs:step state | Put changing data in its own entity
// The model is separate from the view on purpose. It can be shared by several
// views, and it owns the mutation that matters to the application. `Entity<Model>`
// is a handle; the value stays in GPUI's app state and is read only through a
// context or app borrow.
//
// The model has no rendering code. Its `increment` method changes the value and
// calls `notify`, which is the explicit signal that observers should run.
// docs:api gpui::Entity gpui::Context::notify
// docs:code
use gpui::{AppContext, Context, Entity, IntoElement, Render, Subscription, Window, div, prelude::*, rgb};

struct Model {
    count: u32,
}

impl Model {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count = self.count.saturating_add(1);
        cx.notify();
    }
}
// docs:end

// docs:step observe | Keep the view subscribed to the model
// A notification does not automatically redraw every consumer. The view owns a
// `Subscription` that turns model notifications into view notifications. The
// callback captures the view weakly through `Context::observe`, so this relation
// does not keep the view alive and disappears when the subscription is dropped.
//
// Storing the handle is the important line. A temporary subscription would be
// cancelled at the end of the constructor. Detaching would make it live until
// the publisher or weak target disappears; here the view owns the relationship,
// so ordinary RAII is clearer.
// docs:api gpui::Context::observe gpui::Subscription
// docs:code
struct CounterView {
    model: Entity<Model>,
    model_subscription: Subscription,
}

impl CounterView {
    fn new(model: Entity<Model>, cx: &mut Context<Self>) -> Self {
        let model_subscription = cx.observe(&model, |_view, _model, cx| cx.notify());
        Self { model, model_subscription }
    }
}
// docs:end

// docs:step observe-state | Read the model and update it from a click
// Render reads the current model value, so the view has one source of truth.
// The button updates that same entity and the model sends its notification.
// The stored subscription then notifies this view, causing the next frame to
// read the new count. There is no hidden mirrored count to get out of sync.
//
// The listener borrows the view only for the event callback. The model update
// finishes before the callback returns, so no model borrow crosses a render or
// await boundary.
// docs:api gpui::Entity::read gpui::Entity::update gpui::Context::listener
// docs:code
impl Render for CounterView {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let count = self.model.read(cx).count;
        div()
            .size_full().flex().flex_col().items_center().justify_center().gap_4()
            .bg(rgb(0xf7f6f2)).text_color(rgb(0x202b29))
            .child(div().text_2xl().child(format!("Count: {count}")))
            .child(
                div().id("increment-model").px_4().py_2().rounded_md()
                    .bg(rgb(0x155b50)).text_color(rgb(0xffffff)).cursor_pointer()
                    .child("Increment")
                    .on_click(cx.listener(|this, _, _, cx| {
                        this.model.update(cx, |model, cx| model.increment(cx));
                    })),
            )
    }
}
// docs:end

// docs:step lifetime | Build both entities under the app
// The model is created first, then the view subscribes to it. The window roots
// the view entity, and the view roots its subscription. Closing the window drops
// the view and cancels the relationship cleanly.
//
// This is the smallest useful shape for a shared model: create one entity,
// create one or more observers, retain each subscription with its observer, and
// notify after every mutation that should affect rendering.
// docs:api gpui::AppContext::new gpui::Application
// docs:code
pub fn main() {
    support::run(|_window, cx| {
        let model = cx.new(|_cx| Model { count: 0 });
        let model_for_view = model.clone();
        cx.new(|cx| CounterView::new(model_for_view, cx))
    });
}
// docs:end
