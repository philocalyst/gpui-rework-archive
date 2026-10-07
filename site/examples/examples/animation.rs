#[path = "../src/support.rs"]
mod support;

// ## Make Replay change identity {#state}
// The blue bar grows from 24 to 124 logical pixels over 700 milliseconds.
// An [`Animation`] supplies its clock and a [`Motion`] describes its duration.
// The view stores only a replay number.
//
// Clicking Replay changes the animation key. The new key starts a new run;
// rendering again with the same key continues the existing run. This is why
// a click increments an identity rather than resetting a timer.

use std::time::Duration;

use gpui::{
    Animation, AnimationExt, AppContext, Context, IntoElement, Motion, Render, Window, div,
    ease_in_out, prelude::*, px, rgb,
};

struct AnimationDemo {
    replay: usize,
}

// ## Sample width and opacity together {#animate}
// [`AnimationExt::with_animation`] retains the clock under `("bar", replay)`.
// Its callback receives progress shaped by [`ease_in_out`] and applies it to
// [`Styled::w`] and [`Styled::opacity`]. GPUI requests frames while the motion
// is active and stops requesting them when it finishes.
//
// With [`App::reduce_motion`] enabled, this one-shot animation displays its end
// state without requesting animation frames. Replay still changes identity,
// but each new run is immediately presented at that end state.

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
// Click Replay, then resize while the bar expands. The retained key lets
// progress continue through the new layout. Replace `("bar", replay)` with a
// constant key and run again: clicking Replay no longer creates a fresh run.
// The platform helper creates the view through [`AppContext::new`].

fn component(_window: &mut Window, cx: &mut gpui::App) -> gpui::Entity<AnimationDemo> {
    cx.new(|_cx| AnimationDemo { replay: 0 })
}

pub fn main() {
    support::run(component);
}
