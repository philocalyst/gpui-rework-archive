use gpui::{
    AppContext, Context, Entity, FocusHandle, IntoElement, Render, Role, Subscription, Window, div,
    prelude::*, rgb, text,
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

struct CounterView {
    model: Entity<Model>,
    focus: FocusHandle,
    notifications: u32,
    _model_subscription: Subscription,
}

impl CounterView {
    fn new(model: Entity<Model>, window: &mut Window, cx: &mut Context<Self>) -> Self {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        let _model_subscription = cx.observe(&model, |view: &mut Self, _model, cx| {
            view.notifications = view.notifications.saturating_add(1);
            cx.notify();
        });
        Self {
            model,
            focus,
            notifications: 0,
            _model_subscription,
        }
    }
}

impl Render for CounterView {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let count = self.model.read(cx).count;
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

fn component(window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<CounterView> {
    let model = cx.new(|_cx| Model { count: 0 });
    let model_for_view = model.clone();
    cx.new(|cx| CounterView::new(model_for_view, window, cx))
}
