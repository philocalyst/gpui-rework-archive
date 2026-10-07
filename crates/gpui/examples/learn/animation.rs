//! Compare the declarative animation wrapper, sampled Motion, keyed transitions, and style transitions.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use std::{
    cell::Cell,
    rc::Rc,
    time::{Duration, Instant},
};

use gpui::{
    Animation, AnimationExt, App, AppContext as _, Context, Entity, Motion, MotionDurationExt,
    Render, Window, bounce, div, ease_in_out, millis, prelude::*, px, rgb, size,
};
use gpui_test::{Scenario, dispatch_click_on, gallery::AnimationScenario};

struct AnimationLesson {
    repeated: Entity<AnimationScenario>,
    motion_start: Option<Instant>,
    bounce_progress: Rc<Cell<f32>>,
    bounce_generation: usize,
}

impl AnimationLesson {
    fn new(cx: &mut Context<Self>) -> Self {
        Self {
            repeated: cx.new(|_| AnimationScenario),
            motion_start: None,
            bounce_progress: Rc::new(Cell::new(0.)),
            bounce_generation: 0,
        }
    }

    fn motion_progress(&self, now: Instant) -> Option<f32> {
        self.motion_start.map(|started| {
            Motion::new(millis(900))
                .with_easing(ease_in_out)
                .sample(now.saturating_duration_since(started))
                .progress
                .get()
        })
    }
}

impl Render for AnimationLesson {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let bounce_progress = self.bounce_progress.clone();
        let bounce_generation = self.bounce_generation;
        let bounce_animation =
            Animation::new(Motion::new(millis(900))).with_easing(bounce(ease_in_out));
        let motion = Motion::new(millis(900)).with_easing(ease_in_out);
        let motion_sample = self.motion_start.map(|started| {
            motion.sample(
                cx.background_executor()
                    .now()
                    .saturating_duration_since(started),
            )
        });
        if motion_sample.is_some_and(|sample| sample.is_active) {
            window.request_animation_frame();
        }
        let progress = motion_sample.map_or(0., |sample| sample.progress.get());
        let motion_card = lesson_card(
            "Motion sample",
            "Motion::sample maps dispatcher time to eased progress.",
            div()
                .flex()
                .flex_col()
                .gap_2()
                .child(
                    div()
                        .relative()
                        .h(px(42.))
                        .rounded_md()
                        .bg(rgb(0xe7ebf0))
                        .child(
                            div()
                                .absolute()
                                .top(px(6.))
                                .left(px(8. + 200. * progress))
                                .size(px(30.))
                                .rounded_full()
                                .bg(rgb(0x3478c8)),
                        )
                        .child(format!("{:.0}%", progress * 100.)),
                )
                .child(
                    div()
                        .id("play-motion")
                        .debug_selector(|| "play-motion".into())
                        .px_3()
                        .py_2()
                        .rounded_md()
                        .bg(rgb(0x3478c8))
                        .text_color(rgb(0xffffff))
                        .cursor_pointer()
                        .child("Play / restart")
                        .on_click(cx.listener(|this, _, _, cx| {
                            this.motion_start = Some(cx.background_executor().now());
                            cx.notify();
                        })),
                ),
        );
        let keyed_card = lesson_card(
            "Keyed animation",
            "A fresh key remounts animation state and replays from zero.",
            div()
                .relative()
                .h(px(96.))
                .rounded_md()
                .bg(rgb(0xe7ebf0))
                .child(
                    div()
                        .id("keyed-bounce")
                        .debug_selector(|| "keyed-bounce".into())
                        .size_full()
                        .cursor_pointer()
                        .on_click(cx.listener(|this, _, _, cx| {
                            this.bounce_generation += 1;
                            cx.notify();
                        }))
                        .child(
                            div()
                                .w(px(120.))
                                .h(px(34.))
                                .flex()
                                .items_center()
                                .justify_center()
                                .rounded_full()
                                .bg(rgb(0xe3a534))
                                .text_color(rgb(0xffffff))
                                .cursor_pointer()
                                .child("Replay bounce")
                                .with_animation(
                                    ("bounce-run", bounce_generation),
                                    bounce_animation,
                                    move |element, progress| {
                                        bounce_progress.set(progress);
                                        element
                                            .absolute()
                                            .left(px(18.))
                                            .top(px(52. * (1. - progress)))
                                    },
                                ),
                        ),
                ),
        );
        let style_card = lesson_card(
            "Style transition",
            "Hover and press interpolate style refinements.",
            div()
                .id("style-transition")
                .debug_selector(|| "style-transition".into())
                .inline_flex()
                .px_4()
                .py_2()
                .rounded_full()
                .bg(rgb(0x36a37c))
                .text_color(rgb(0xffffff))
                .cursor_pointer()
                .transitions(|transition| {
                    transition
                        .bg(millis(200).with_easing(ease_in_out))
                        .p(gpui::spring(600., 22., 1.))
                })
                .hover(|style| style.bg(rgb(0x26785c)).p(px(20.)))
                .active(|style| style.bg(rgb(0x164d3a)))
                .child("Hover and press"),
        );

        div().size_full().p_5().bg(rgb(0xf1f3f6)).child(
            div()
                .flex()
                .flex_col()
                .gap_4()
                .max_w(px(660.))
                .child(
                    div()
                        .text_xl()
                        .font_weight(gpui::FontWeight::BOLD)
                        .child("Animation"),
                )
                .child(self.repeated.clone())
                .child(
                    div()
                        .flex()
                        .flex_wrap()
                        .gap_3()
                        .child(motion_card)
                        .child(keyed_card)
                        .child(style_card),
                ),
        )
    }
}

fn lesson_card(title: &'static str, hint: &'static str, example: impl IntoElement) -> gpui::Div {
    div()
        .flex()
        .flex_col()
        .gap_2()
        .p_4()
        .min_w(px(260.))
        .flex_1()
        .rounded_lg()
        .bg(rgb(0xffffff))
        .child(div().font_weight(gpui::FontWeight::SEMIBOLD).child(title))
        .child(hint)
        .child(example)
}

fn main() {
    example_prelude::run_example(lesson_scenario().expect("valid animation scenario"))
        .expect("run animation example");
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_test::Harness;

    #[test]
    fn dispatcher_clock_drives_motion_restart_and_keyed_transition() -> anyhow::Result<()> {
        Harness::new().run(&lesson_scenario()?)?;
        Ok(())
    }
}

#[path = "animation/checkpoints.rs"]
mod checkpoints;
use checkpoints::lesson_scenario;
