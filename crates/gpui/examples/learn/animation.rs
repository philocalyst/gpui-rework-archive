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

fn lesson_scenario() -> anyhow::Result<Scenario<AnimationLesson>> {
    Scenario::new(
        "animation",
        "Animation",
        size(px(720.), px(640.)),
        |_, cx: &mut App| cx.new(AnimationLesson::new),
    )?
    .checkpoint(
        "initial",
        "Motion and keyed transition at rest",
        Duration::ZERO,
    )?
    .checkpoint_with(
        "motion-start",
        "Play starts a Motion pass",
        Duration::ZERO,
        |cx, view, window| {
            dispatch_click_on(cx, window.into(), "play-motion")?;
            let progress = view.read_with(cx, |view, app| {
                view.motion_progress(app.background_executor().now())
            });
            anyhow::ensure!(
                progress == Some(0.),
                "Motion did not start at zero: {progress:?}"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "motion-midpoint",
        "Eased Motion reaches its midpoint",
        Duration::from_millis(450),
        |cx, view, _| {
            let progress = view.read_with(cx, |view, app| {
                view.motion_progress(app.background_executor().now())
            });
            anyhow::ensure!(
                progress.is_some_and(|value| (0.45..=0.55).contains(&value)),
                "Motion midpoint was {progress:?}"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "motion-complete",
        "Motion reaches its final value",
        Duration::from_millis(900),
        |cx, view, _| {
            let progress = view.read_with(cx, |view, app| {
                view.motion_progress(app.background_executor().now())
            });
            anyhow::ensure!(progress == Some(1.), "Motion completion was {progress:?}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "motion-restart",
        "Play restarts Motion from zero",
        Duration::from_secs(1),
        |cx, view, window| {
            dispatch_click_on(cx, window.into(), "play-motion")?;
            let progress = view.read_with(cx, |view, app| {
                view.motion_progress(app.background_executor().now())
            });
            anyhow::ensure!(progress == Some(0.), "Motion restart was {progress:?}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "style-hover",
        "Pointer hover starts a style transition",
        Duration::from_millis(1_100),
        |cx, _view, window| {
            let bounds = cx
                .debug_bounds(window.into(), "style-transition")?
                .ok_or_else(|| anyhow::anyhow!("style transition selector is missing"))?;
            gpui_test::dispatch_input(
                cx,
                window.into(),
                gpui::PlatformInput::MouseMove(gpui::MouseMoveEvent {
                    position: bounds.center(),
                    pressed_button: None,
                    modifiers: gpui::Modifiers::default(),
                }),
            )?;
            Ok(())
        },
    )?
    .checkpoint_with(
        "bounce-start",
        "Click replays the keyed bounce",
        Duration::from_millis(1_200),
        |cx, view, window| {
            dispatch_click_on(cx, window.into(), "keyed-bounce")?;
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.bounce_generation == 1),
                "click did not remount the keyed bounce"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "bounce-midpoint",
        "Keyed bounce midway through its easing",
        Duration::from_millis(1_650),
        |cx, view, window| {
            cx.draw_window(window.into())?;
            let progress = view.read_with(cx, |view, _| view.bounce_progress.get());
            anyhow::ensure!(progress > 0.1, "keyed bounce did not advance: {progress}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "bounce-complete",
        "Keyed bounce returns to its resting position",
        Duration::from_millis(2_100),
        |cx, view, window| {
            cx.draw_window(window.into())?;
            let progress = view.read_with(cx, |view, _| view.bounce_progress.get());
            anyhow::ensure!(progress == 0., "keyed bounce completion was {progress}");
            Ok(())
        },
    )?
    .checkpoint_with(
        "bounce-restart",
        "Clicking the keyed card restarts animation",
        Duration::from_millis(2_200),
        |cx, view, window| {
            dispatch_click_on(cx, window.into(), "keyed-bounce")?;
            cx.draw_window(window.into())?;
            let (progress, generation) = view.read_with(cx, |view, _| {
                (view.bounce_progress.get(), view.bounce_generation)
            });
            anyhow::ensure!(generation == 2, "keyed bounce generation is {generation}");
            anyhow::ensure!(progress == 0., "keyed bounce restart began at {progress}");
            Ok(())
        },
    )
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
