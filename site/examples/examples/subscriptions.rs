#[path = "../src/support.rs"]
mod support;

// ## Share a model {#state}
// `Model` owns the count. A view keeps an [`Entity`] handle to that model;
// another view could keep a clone and read the same value.
//
// The model's `increment` method changes its field and calls [`Context::notify`].
// That signal means “read my current state”, without describing each mutation.

use gpui::{
    AppContext, Context, Entity, IntoElement, Render, Subscription, Window, div, prelude::*, rgb,
};

struct Model {
    count: u32,
}

impl Model {
    fn increment(&mut self, cx: &mut Context<Self>) {
        self.count = self.count.saturating_add(1);
        cx.notify();
    }
}

// ## Observe a change {#observe}
// This view displays the model's count and the number of notifications it has
// received. [`Context::observe`] updates that second value when the model
// notifies. The callback then notifies the view because its own state changed.
//
// Retain the returned [`Subscription`]. A temporary subscription is dropped
// before the next click and cancels the callback. The observer captures its
// target view weakly, so retaining the subscription does not retain the view.
//
// > [!NOTE]
// > Pending notifications can be coalesced. The notification count measures
// > callback deliveries, not assignments to the model. Use typed events when
// > each operation needs a separate payload.

struct CounterView {
    model: Entity<Model>,
    notifications: u32,
    _model_subscription: Subscription,
}

impl CounterView {
    fn new(model: Entity<Model>, cx: &mut Context<Self>) -> Self {
        let _model_subscription = cx.observe(&model, |view: &mut Self, _model, cx| {
            view.notifications = view.notifications.saturating_add(1);
            cx.notify();
        });
        Self {
            model,
            notifications: 0,
            _model_subscription,
        }
    }
}

// ## Read the model; display the observation {#observe-state}
// [`Entity::read`] borrows the model for this render. GPUI tracks that read
// when deciding which windows a model notification invalidates. An explicit
// observer is useful here for the view's additional notification count.
//
// The click handler uses [`Context::listener`] to access the view and
// [`Entity::update`] to access its model. Those are different entities. The
// model update completes before the handler returns; the queued observer runs
// during effect processing, after the model's update borrow has ended.

impl Render for CounterView {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let count = self.model.read(cx).count;
        div()
            .size_full()
            .flex()
            .flex_col()
            .items_center()
            .justify_center()
            .gap_4()
            .bg(rgb(0xf7f6f2))
            .text_color(rgb(0x202b29))
            .child(div().text_2xl().child(format!("Count: {count}")))
            .child(format!("Notifications received: {}", self.notifications))
            .child(
                div()
                    .id("increment-model")
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .cursor_pointer()
                    .child("Increment")
                    .on_click(cx.listener(|this, _, _, cx| {
                        this.model.update(cx, |model, cx| model.increment(cx));
                    })),
            )
    }
}

// ## Give the relationship an owner {#lifetime}
// [`AppContext::new`] creates the model, then the view. Its constructor stores
// the model handle and subscription. The window keeps the view alive; when
// the view is released, its fields release both handles.
//
// Click once and both numbers increase. Try discarding the subscription in
// the constructor: the model still changes, but the notification count stays
// zero. The platform helper starts the app through [`Application`].

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<CounterView> {
    let model = cx.new(|_cx| Model { count: 0 });
    let model_for_view = model.clone();
    cx.new(|cx| CounterView::new(model_for_view, cx))
}

pub fn main() {
    support::run(component);
}
