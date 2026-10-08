#[path = "../src/support.rs"]
mod support;

// ## Share a model {#state}
// `Model` owns the count independently of the view that displays it. A view
// keeps an [`Entity`] handle; another view can clone that handle and read the
// same model without copying the count.
//
// The model's `increment` method changes its field and calls [`Context::notify`].
// That signal means “read my current state”, without describing each mutation.

use gpui::{
    AppContext, Context, Entity, IntoElement, Render, Role, Subscription, Window, div, prelude::*,
    rgb, text,
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
// This view displays the model's count and counts observer callbacks.
// [`Context::observe`] subscribes this view to model notifications. The
// callback changes the view's own count, then notifies the view so that its
// rendered label is refreshed. The model signal and view invalidation are two
// separate steps because they belong to two entities.
//
// Retain the returned [`Subscription`]. A temporary subscription is dropped
// before the next click and cancels the callback. The observer captures its
// target view weakly, so retaining the subscription does not retain the view.
//
// > [!NOTE]
// > GPUI may coalesce pending notifications. Therefore this number counts
// > observer callback deliveries, not model assignments or clicks. Use a typed
// > event when each operation must carry its own payload or remain individually
// > observable.

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
// [`Entity::read`] borrows the model for this render. GPUI records the read so
// a model notification can invalidate windows that displayed it. The explicit
// observer serves a different purpose: it updates this view's callback count.
//
// The click handler uses [`Context::listener`] to access the view and
// [`Entity::update`] to access its model. Those are different entities. The
// model update completes before the handler returns; the queued observer runs
// during effect processing, after the model's update borrow has ended.
//
// Both labels use [`text`] so their values appear in the accessibility tree.
// Increment has a button role, an accessible name, and a tab stop. Use Tab and
// Enter to check that the same state transition works without a pointer.

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
            .child(div().text_2xl().child(text!(format!("Count: {count}"))))
            .child(text!(format!(
                "Notifications received: {}",
                self.notifications
            )))
            .child(
                div()
                    .id("increment-model")
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
                    .on_click(cx.listener(|this, _, _, cx| {
                        this.model.update(cx, |model, cx| model.increment(cx));
                    })),
            )
    }
}

// ## Give the relationship an owner {#lifetime}
// [`AppContext::new`] creates the model, then creates a view that owns a clone
// of its handle and the returned [`Subscription`]. The window keeps the root
// view alive. Releasing that view drops the subscription and stops observation;
// the model can then be released when its remaining strong handles are gone.
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
