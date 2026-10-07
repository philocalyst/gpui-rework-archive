#[path = "../support.rs"]
mod support;

// docs:step state | Give a replay a stable identity
// Declarative animation state lives on the element identified by its key. A
// changing key mounts a fresh animation; the same key keeps the animation's
// phase when the view renders again. This small counter is the replay control:
// clicking it increments the key, so the ball starts at the beginning without
// storing a clock or a timer in the view.
//
// The animation below is a one-shot `Animation` with a 700 ms `Motion`. The
// animator receives normalized progress and changes both width and opacity.
// `ease_in_out` shapes the progress; it does not change the key or the layout
// identity. Replacing the key with a constant is a useful experiment: clicks
// no longer restart the run.
// This is the important distinction between identity and progress: the key
// chooses which retained animation exists, while progress only samples it.
// docs:api gpui::Animation gpui::AnimationExt gpui::Motion gpui::ease_in_out
// docs:code
use std::time::Duration;

use gpui::{
    div, ease_in_out, prelude::*, Animation, AnimationExt, AppContext, Context, IntoElement,
    Motion, px, Render, rgb, Window,
};

struct AnimationDemo {
    replay: usize,
}
// docs:end

// docs:step animate | Animate style from the retained clock
// `with_animation` retains the current sample under `("ball", replay)`. GPUI
// schedules frames while the motion is active, then stops. The callback is
// called with the current eased progress, so this example can animate two
// properties together and still leave layout to the ordinary `Div` element.
//
// When reduced motion is enabled, GPUI renders a one-shot animation at its end
// state and schedules no animation frames. The key still identifies the same
// element; changing it simply creates another already-complete presentation.
// This makes the accessibility behavior deterministic rather than a special
// branch in application state.
// docs:api gpui::AnimationExt::with_animation gpui::Styled::w gpui::Styled::opacity gpui::App::reduce_motion
// docs:code
impl Render for AnimationDemo {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let replay = self.replay;
        let animation = Animation::new(Motion::new(Duration::from_millis(700)))
            .with_easing(ease_in_out);

        div()
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
                div()
                    .h(px(48.))
                    .w(px(180.))
                    .flex()
                    .items_center()
                    .child(
                        div()
                            .h(px(32.))
                            .rounded_full()
                            .bg(rgb(0x3478c8))
                            .with_animation(("ball", replay), animation, |ball, progress| {
                                ball.w(px(24. + 100. * progress))
                                    .opacity(0.25 + 0.75 * progress)
                            }),
                    ),
            )
    }
}
// docs:end

// docs:step clock | Start the view
// The view owns only the replay key. GPUI owns the animation clock and ties it
// to frame scheduling, so an idle window does not need a polling loop. The
// browser preview and the native window therefore exercise the same retained
// identity and timing contract.
//
// Open the preview, click Replay, and then resize while the ball is moving. The
// current frame is painted from the retained key and progress; a new key starts
// a new run. See the animation guide for spring motion and synchronized clocks.
// docs:api gpui::AppContext::new gpui::Application::run
// docs:code
pub fn main() {
    support::run(|_window, cx| cx.new(|_cx| AnimationDemo { replay: 0 }));
}
// docs:end
