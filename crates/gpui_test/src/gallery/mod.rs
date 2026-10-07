//! Shared visual views and the default deterministic regression scenarios.

mod interaction;
mod media;
mod stress;
mod tasks;
mod views;
pub use interaction::InteractionScenario;
pub use media::{MediaAssets, MediaScenario};
pub use stress::StressScenario;
pub use tasks::{AsyncTaskScenario, TaskState};
pub use views::{AnimationScenario, EffectsScenario, LayoutScenario, TextScenario};

use crate::{AnyScenario, Scenario};
use anyhow::Result;
use gpui::{App, AppContext as _, point, px, size};
use std::time::Duration;

/// Shared wrapping and mixed-script scenarios used by the lesson and regression gallery.
pub fn text_scenarios() -> Result<Vec<Scenario<TextScenario>>> {
    [
        (
            "text-mixed-script",
            "Wrapping, underline, and mixed scripts",
            460.,
            340.,
            1.,
            "default",
            "Default width",
        ),
        (
            "text-narrow-wrap",
            "Narrow text wrapping",
            320.,
            420.,
            1.,
            "narrow",
            "Narrow viewport",
        ),
        (
            "text-hidpi-2x",
            "Text at 2x device scale",
            340.,
            280.,
            2.,
            "hidpi",
            "2x device scale",
        ),
        (
            "text-fractional-dpi",
            "Text at fractional device scale",
            340.,
            280.,
            1.5,
            "fractional",
            "1.5x device scale",
        ),
    ]
    .into_iter()
    .map(|(id, title, width, height, scale, checkpoint, label)| {
        let scenario = Scenario::new(id, title, size(px(width), px(height)), |_, cx: &mut App| {
            cx.new(|_| TextScenario)
        })?
        .scale_factor(scale)?
        .checkpoint(checkpoint, label, Duration::ZERO)?;
        Ok(scenario)
    })
    .collect()
}

/// Canonical layered painting scenario used by the rendering example.
pub fn effects_scenario() -> Result<Scenario<EffectsScenario>> {
    Scenario::new(
        "effects",
        "Clipping, opacity, gradients, paths, and nested filters",
        size(px(480.), px(420.)),
        |_, cx: &mut App| cx.new(|_| EffectsScenario),
    )?
    .checkpoint("effects", "Layered effects", Duration::ZERO)
}

/// Fixed-clock animation is captured using the same GPUI animation wrapper as its runnable view.
pub fn animation_scenario() -> Result<Scenario<AnimationScenario>> {
    Scenario::new(
        "animation-clock",
        "Animation at fixed dispatcher times",
        size(px(320.), px(220.)),
        |_, cx: &mut App| cx.new(|_| AnimationScenario),
    )?
    .checkpoint("t000", "0 ms", Duration::ZERO)?
    .checkpoint("t300", "300 ms", Duration::from_millis(300))?
    .checkpoint("t600", "600 ms", Duration::from_millis(600))?
    .checkpoint("t900", "900 ms", Duration::from_millis(900))?
    .checkpoint("t1200", "1200 ms", Duration::from_millis(1200))
}

/// Canonical flexible-row example and its capture checkpoint.
pub fn layout_scenario() -> Result<Scenario<LayoutScenario>> {
    Scenario::new(
        "layout",
        "Flexible layout",
        size(px(620.), px(300.)),
        |_, cx: &mut App| cx.new(|_| LayoutScenario),
    )?
    .checkpoint("default", "Default layout", Duration::ZERO)
}

/// Selection, disclosure, focus, and scroll states after real input dispatch.
pub fn interaction_scenario() -> Result<Scenario<InteractionScenario>> {
    Scenario::new(
        "interaction-states",
        "Selection, disclosure, focus, and scroll input",
        size(px(420.), px(420.)),
        |_, cx: &mut App| cx.new(InteractionScenario::new),
    )?
    .checkpoint_with(
        "initial",
        "Initial focus and expanded tree",
        Duration::ZERO,
        |cx, view, window| {
            let focused = cx.update_window(window.into(), |_, actual_window, app| {
                view.read(app).root_focused(actual_window)
            })?;
            anyhow::ensure!(focused, "root focus handle was not focused");
            Ok(())
        },
    )?
    .checkpoint_with(
        "selected",
        "Click second item",
        Duration::from_millis(100),
        |cx, _view, window| {
            crate::dispatch_click_on(cx, window.into(), "interaction-item-1")?;
            anyhow::ensure!(
                _view.read_with(cx, |view, _| view.selected_index()) == 1,
                "click did not select the second item"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "collapsed",
        "Click tree disclosure",
        Duration::from_millis(200),
        |cx, _view, window| {
            crate::dispatch_click_on(cx, window.into(), "interaction-tree-toggle")?;
            anyhow::ensure!(
                !_view.read_with(cx, |view, _| view.tree_expanded()),
                "click did not collapse the tree branch"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "scrolled",
        "Dispatch wheel input",
        Duration::from_millis(300),
        |cx, _view, window| {
            crate::dispatch_scroll_on(
                cx,
                window.into(),
                "interaction-scroll-viewport",
                point(px(0.), px(-36.)),
            )?;
            anyhow::ensure!(
                _view.read_with(cx, |view, _| view.scroll_offset_y()) < 0.0,
                "wheel input did not change the scroll offset"
            );
            Ok(())
        },
    )
}

/// Self-contained SVG and raster clipping/transformation example.
pub fn media_scenario() -> Result<Scenario<MediaScenario>> {
    Scenario::new(
        "media",
        "SVG and raster image clipping and transforms",
        size(px(360.), px(300.)),
        |_, cx: &mut App| cx.new(|_| MediaScenario),
    )?
    .checkpoint("default", "Inline SVG and raster", Duration::ZERO)
}

/// Large virtual list and deliberate overlap used for paint stress captures.
pub fn stress_scenario() -> Result<Scenario<StressScenario>> {
    Scenario::new(
        "layered-stress",
        "Virtualized rows and overlapping paint layers",
        size(px(620.), px(480.)),
        |_, cx: &mut App| cx.new(|_| StressScenario),
    )?
    .checkpoint("default", "Virtual rows", Duration::ZERO)
}

/// Foreground cancellation and completion states driven by real button input.
pub fn tasks_scenario() -> Result<Scenario<AsyncTaskScenario>> {
    Scenario::new(
        "async-tasks",
        "Foreground task cancellation and completion",
        size(px(360.), px(220.)),
        |_, cx: &mut App| cx.new(|_| AsyncTaskScenario::new()),
    )?
    .checkpoint("ready", "No task has started", Duration::ZERO)?
    .checkpoint_with(
        "started",
        "Start background work",
        Duration::ZERO,
        |cx, view, window| {
            crate::dispatch_click_on(cx, window.into(), "async-task-action")?;
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.state()) == TaskState::Running,
                "task did not start"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "running",
        "Task is awaiting its result",
        Duration::from_millis(100),
        |cx, view, _| {
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.state()) == TaskState::Running,
                "task left running state before background work completed"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "cancelled",
        "Cancel the pending task",
        Duration::from_millis(200),
        |cx, view, window| {
            crate::dispatch_click_on(cx, window.into(), "async-task-action")?;
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.state()) == TaskState::Cancelled,
                "task was not cancelled"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "restarted",
        "Start a fresh task",
        Duration::from_millis(300),
        |cx, view, window| {
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.state()) == TaskState::Cancelled,
                "cancelled work applied a late result"
            );
            crate::dispatch_click_on(cx, window.into(), "async-task-action")?;
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.state()) == TaskState::Running,
                "task did not restart"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "completed",
        "Apply the background result",
        Duration::from_millis(600),
        |cx, view, _| {
            anyhow::ensure!(
                view.read_with(cx, |view, _| view.state()) == TaskState::Completed(42),
                "background result was not applied"
            );
            Ok(())
        },
    )
}

/// Returns the deterministic regression gallery. The same typed views and checkpoints are used
/// by native examples through the builders above.
pub fn built_in_scenarios() -> Result<Vec<AnyScenario>> {
    let mut scenarios = text_scenarios()?
        .into_iter()
        .map(AnyScenario::from)
        .collect::<Vec<_>>();
    scenarios.extend([
        effects_scenario()?.into(),
        animation_scenario()?.into(),
        layout_scenario()?.into(),
        interaction_scenario()?.into(),
        media_scenario()?.into(),
        stress_scenario()?.into(),
        tasks_scenario()?.into(),
    ]);
    Ok(scenarios)
}
