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

use crate::Scenario;
use anyhow::Result;
use gpui::{App, AppContext as _, point, px, size};
use std::time::Duration;

/// A registered scenario that can be listed and run alongside other view types.
/// The view remains statically typed inside the scenario.
pub struct BuiltInScenario {
    scenario: Box<dyn RunnableScenario>,
}

trait RunnableScenario {
    fn id(&self) -> &str;
    fn title(&self) -> &str;
    fn run(&self, harness: &crate::Harness) -> Result<crate::RenderedScenario>;
}

impl<V: gpui::Render + 'static> RunnableScenario for Scenario<V> {
    fn id(&self) -> &str {
        Scenario::id(self)
    }
    fn title(&self) -> &str {
        Scenario::title(self)
    }
    fn run(&self, harness: &crate::Harness) -> Result<crate::RenderedScenario> {
        harness.run(self)
    }
}

impl<V: gpui::Render + 'static> From<Scenario<V>> for BuiltInScenario {
    fn from(scenario: Scenario<V>) -> Self {
        Self {
            scenario: Box::new(scenario),
        }
    }
}

impl BuiltInScenario {
    /// Stable identifier.
    pub fn id(&self) -> &str {
        self.scenario.id()
    }

    /// Human-readable title.
    pub fn title(&self) -> &str {
        self.scenario.title()
    }

    /// Runs the original typed scenario.
    pub fn run(&self, harness: &crate::Harness) -> Result<crate::RenderedScenario> {
        self.scenario.run(harness)
    }
}

/// Returns the deterministic regression gallery. The same view types are used by
/// runnable examples in `gpui/examples`.
pub fn built_in_scenarios() -> Result<Vec<BuiltInScenario>> {
    let text = Scenario::new(
        "text-mixed-script",
        "Wrapping, underline, and mixed scripts",
        size(px(460.), px(340.)),
        |_, cx: &mut App| cx.new(|_| TextScenario),
    )?
    .checkpoint("default", "Default width", Duration::ZERO)?;
    let narrow = Scenario::new(
        "text-narrow-wrap",
        "Narrow text wrapping",
        size(px(320.), px(420.)),
        |_, cx: &mut App| cx.new(|_| TextScenario),
    )?
    .checkpoint("narrow", "Narrow viewport", Duration::ZERO)?;
    let hidpi = Scenario::new(
        "text-hidpi-2x",
        "Text at 2x device scale",
        size(px(340.), px(280.)),
        |_, cx: &mut App| cx.new(|_| TextScenario),
    )?
    .scale_factor(2.0)?
    .checkpoint("hidpi", "2x device scale", Duration::ZERO)?;
    let fractional_dpi = Scenario::new(
        "text-fractional-dpi",
        "Text at fractional device scale",
        size(px(340.), px(280.)),
        |_, cx: &mut App| cx.new(|_| TextScenario),
    )?
    .scale_factor(1.5)?
    .checkpoint("fractional", "1.5x device scale", Duration::ZERO)?;
    let effects = Scenario::new(
        "effects",
        "Clipping, opacity, gradients, paths, and nested filters",
        size(px(480.), px(420.)),
        |_, cx: &mut App| cx.new(|_| EffectsScenario),
    )?
    .checkpoint("effects", "Layered effects", Duration::ZERO)?;
    let animation = Scenario::new(
        "animation-clock",
        "Animation at fixed dispatcher times",
        size(px(320.), px(220.)),
        |_, cx: &mut App| cx.new(|_| AnimationScenario),
    )?
    .checkpoint("t000", "0 ms", Duration::ZERO)?
    .checkpoint("t300", "300 ms", Duration::from_millis(300))?
    .checkpoint("t600", "600 ms", Duration::from_millis(600))?
    .checkpoint("t900", "900 ms", Duration::from_millis(900))?
    .checkpoint("t1200", "1200 ms", Duration::from_millis(1200))?;
    let layout = Scenario::new(
        "layout",
        "Flexible layout",
        size(px(620.), px(300.)),
        |_, cx: &mut App| cx.new(|_| LayoutScenario),
    )?
    .checkpoint("default", "Default layout", Duration::ZERO)?;
    let interaction = Scenario::new(
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
    )?;
    let media = Scenario::new(
        "media",
        "SVG and raster image clipping and transforms",
        size(px(360.), px(300.)),
        |_, cx: &mut App| cx.new(|_| MediaScenario),
    )?
    .checkpoint("default", "Inline SVG and raster", Duration::ZERO)?;
    let stress = Scenario::new(
        "layered-stress",
        "Virtualized rows and overlapping paint layers",
        size(px(620.), px(480.)),
        |_, cx: &mut App| cx.new(|_| StressScenario),
    )?
    .checkpoint("default", "Virtual rows", Duration::ZERO)?;
    let async_tasks = Scenario::new(
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
    )?;
    Ok(vec![
        text.into(),
        narrow.into(),
        hidpi.into(),
        fractional_dpi.into(),
        effects.into(),
        animation.into(),
        layout.into(),
        interaction.into(),
        media.into(),
        stress.into(),
        async_tasks.into(),
    ])
}
