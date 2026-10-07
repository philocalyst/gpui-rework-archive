#[path = "../src/support.rs"]
mod support;

// ## Make Replay change identity {#state}
// The blue bar grows from 24 to 124 logical pixels over 700 milliseconds.
// An [`Animation`] supplies its clock and a [`Motion`] describes its duration.
// The view stores only a replay number.
//
// Clicking Replay changes the animation's retained element-state key. A new
// key starts at the beginning; rendering with the same key reuses its existing
// start time. The replay counter is therefore an identity, not a timer value.

use std::time::Duration;

use gpui::{
    Animation, AnimationExt, AppContext, Context, IntoElement, Motion, Render, Window, div,
    ease_in_out, prelude::*, px, rgb,
};

struct AnimationDemo {
    replay: usize,
}

// ## Sample width and opacity together {#animate}
// [`AnimationExt::with_animation`] associates progress with `("bar", replay)`.
// Its callback receives eased progress from [`ease_in_out`] and derives width
// and opacity from that same value. [`Styled::w`] changes layout; [`Styled::opacity`]
// changes the rendered appearance without changing layout. GPUI requests
// frames while the motion is active and stops requesting animation frames when
// it completes.
//
// With [`App::reduce_motion`] enabled, this one-shot motion skips intermediate
// progress and presents its end state. Replay still changes the key, but each
// new run appears complete immediately. This is a useful check that decorative
// motion has a clear static result as well as an animated one.

impl Render for AnimationDemo {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let replay = self.replay;
        let animation =
            Animation::new(Motion::new(Duration::from_millis(700))).with_easing(ease_in_out);

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

// ## Test identity while it runs {#clock}
// Click Replay, then resize while the bar expands: the motion should continue
// while layout recalculates. Replace `("bar", replay)` with a constant key and
// click again. The old start time remains associated with that key, so no new
// run begins. [`AppContext::new`] creates the entity whose render method
// returns this animated element tree.

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<AnimationDemo> {
    cx.new(|_cx| AnimationDemo { replay: 0 })
}

pub fn main() {
    support::run(component);
}
