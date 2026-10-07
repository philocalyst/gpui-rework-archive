//! Three animation mechanisms: automatic progress, explicit sampling, and style interpolation.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    Animation, AnimationExt, Context, Motion, MotionDurationExt, MotionSample, Window, bounce, div,
    ease_in_out, millis, prelude::*, px, rgb, size,
};
use std::time::Instant;

#[derive(Default)]
struct AnimationLesson {
    motion_start: Option<Instant>,
    bounce_generation: usize,
}

impl AnimationLesson {
    fn new(_cx: &mut Context<Self>) -> Self {
        Self::default()
    }

    fn sample_motion(&self, now: Instant) -> Option<MotionSample> {
        self.motion_start.map(|started| {
            Motion::new(millis(900))
                .with_easing(ease_in_out)
                .sample(now.saturating_duration_since(started))
        })
    }
}

impl Render for AnimationLesson {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        // Sample the dispatcher clock, rather than frame count, so speed does not depend on FPS.
        let sample = self.sample_motion(cx.background_executor().now());
        if sample.is_some_and(|sample| sample.is_active) {
            window.request_animation_frame();
        }
        let progress = sample.map_or(0., |sample| sample.progress.get());

        div()
            .size_full()
            .p_5()
            .flex()
            .flex_col()
            .gap_4()
            .bg(rgb(0xf1f3f6))
            .child(row(
                "Animation: automatically requests frames",
                track().child(
                    marker().with_animation(
                        "repeat",
                        Animation::new(millis(1200))
                            .repeat()
                            .with_easing(ease_in_out),
                        |marker, progress| marker.left(px(200. * progress)),
                    ),
                ),
            ))
            .child(row(
                "Motion: sample and request frames yourself",
                div()
                    .flex()
                    .gap_3()
                    .child(track().child(marker().left(px(200. * progress))))
                    .child(
                        control("play-motion", "Play / restart").on_click(cx.listener(
                            |this, _, _, cx| {
                                this.motion_start = Some(cx.background_executor().now());
                                cx.notify();
                            },
                        )),
                    ),
            ))
            .child(row(
                "A new key restarts animation state",
                div()
                    .flex()
                    .gap_3()
                    .child(track().child(marker().with_animation(
                        ("bounce", self.bounce_generation),
                        Animation::new(millis(900)).with_easing(bounce(ease_in_out)),
                        |marker, progress| marker.left(px(200. * progress)),
                    )))
                    .child(
                        control("keyed-bounce", "Replay bounce").on_click(cx.listener(
                            |this, _, _, cx| {
                                this.bounce_generation += 1;
                                cx.notify();
                            },
                        )),
                    ),
            ))
            .child(row(
                "Transitions interpolate hover and pressed styles",
                control("style-transition", "Hover and press")
                    .transitions(|transition| {
                        transition
                            .bg(millis(200).with_easing(ease_in_out))
                            .p(gpui::spring(600., 22., 1.))
                    })
                    .hover(|style| style.bg(rgb(0x26785c)).p(px(20.)))
                    .active(|style| style.bg(rgb(0x164d3a))),
            ))
    }
}

fn row(label: &'static str, content: impl IntoElement) -> impl IntoElement {
    div().flex().flex_col().gap_2().child(label).child(content)
}
fn track() -> gpui::Div {
    div()
        .relative()
        .w(px(240.))
        .h(px(40.))
        .rounded_md()
        .bg(rgb(0xe2e8f0))
}
fn marker() -> gpui::Div {
    div()
        .absolute()
        .top(px(5.))
        .size(px(30.))
        .rounded_full()
        .bg(rgb(0x3478c8))
}
fn control(id: &'static str, label: &'static str) -> gpui::Stateful<gpui::Div> {
    div()
        .id(id)
        .debug_selector(|| id.into())
        .px_3()
        .py_2()
        .rounded_md()
        .bg(rgb(0x3478c8))
        .text_color(rgb(0xffffff))
        .cursor_pointer()
        .child(label)
}

fn main() {
    example_prelude::run_example("Animation", size(px(640.), px(420.)), |_, cx| {
        cx.new(AnimationLesson::new)
    });
}

#[cfg(all(test, feature = "test-support"))]
#[path = "animation/tests.rs"]
mod tests;
