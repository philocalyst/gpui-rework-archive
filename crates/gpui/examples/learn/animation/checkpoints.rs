//! Deterministic input sequences and state assertions for this lesson.
use super::*;

pub(super) fn lesson_scenario() -> anyhow::Result<Scenario<AnimationLesson>> {
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
