use std::time::Duration;

use gpui::{
    Animation, AnimationExt, AppContext, Context, FocusHandle, IntoElement, Motion, Render, Role,
    Window, div, ease_in_out, prelude::*, px, rgb,
};

struct AnimationDemo {
    replay: usize,
    focus: FocusHandle,
}

impl Render for AnimationDemo {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let replay = self.replay;
        let animation =
            Animation::new(Motion::new(Duration::from_millis(700))).with_easing(ease_in_out);

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
            .bg(rgb(0xf4f1ea))
            .child(
                div()
                    .id("replay")
                    .role(Role::Button)
                    .aria_label("Replay")
                    .tab_index(0)
                    .focus_visible(|style| style.ring_2().ring_color(rgb(0x3478c8)))
                    .px_4()
                    .py_2()
                    .rounded_md()
                    .bg(rgb(0x155b50))
                    .text_color(rgb(0xffffff))
                    .cursor_pointer()
                    .child("Replay")
                    .on_click(cx.listener(|this, _, _, cx| {
                        this.replay = this.replay.wrapping_add(1);
                        cx.notify();
                    })),
            )
            .child(
                div().h(px(48.)).w(px(180.)).flex().items_center().child(
                    div()
                        .h(px(32.))
                        .rounded_full()
                        .bg(rgb(0x3478c8))
                        .with_animation(("bar", replay), animation, |bar, progress| {
                            bar.w(px(24. + 100. * progress))
                                .opacity(0.25 + 0.75 * progress)
                        }),
                ),
            )
    }
}

fn component(window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<AnimationDemo> {
    cx.new(|cx| {
        let focus = cx.focus_handle();
        window.focus(&focus, cx);
        AnimationDemo { replay: 0, focus }
    })
}
