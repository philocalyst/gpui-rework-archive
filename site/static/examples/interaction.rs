use gpui::{
    Context, FocusHandle, Focusable, IntoElement, Render, Window,
    actions, div, prelude::*,
};

actions!(interaction_study, [Activate]);

#[derive(Clone, Copy, Default)]
enum GestureState {
    #[default]
    Idle,
    Hovered,
    Pressed,
    Activated,
}

struct InteractionStudy {
    state: GestureState,
    focus_handle: FocusHandle,
}

impl Focusable for InteractionStudy {
    fn focus_handle(&self, _cx: &gpui::App) -> FocusHandle {
        self.focus_handle.clone()
    }
}

impl Render for InteractionStudy {
    fn render(
        &mut self,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) -> impl IntoElement {
        div()
            .id("interaction-study")
            .key_context("InteractionStudy")
            .track_focus(&self.focus_handle)
            .child(match self.state {
                GestureState::Idle => "Press, point, focus.",
                GestureState::Hovered => "Hovered",
                GestureState::Pressed => "Pressed",
                GestureState::Activated => "Activated",
            })
            .on_hover(cx.listener(|this, hovered, _, cx| {
                this.state = if *hovered {
                    GestureState::Hovered
                } else {
                    GestureState::Idle
                };
                cx.notify();
            }))
            .on_mouse_down(gpui::MouseButton::Left, cx.listener(|this, _, _, cx| {
                this.state = GestureState::Pressed;
                cx.notify();
            }))
            .on_click(cx.listener(|this, _, _, cx| {
                this.state = GestureState::Activated;
                cx.notify();
            }))
            .on_action(cx.listener(|this, _: &Activate, _, cx| {
                this.state = GestureState::Activated;
                cx.notify();
            }))
    }
}

// At startup, bind Enter and Space to Activate in the InteractionStudy context.
