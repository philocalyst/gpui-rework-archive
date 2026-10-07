//! Deterministic, headless visual scenarios for GPUI.
//!
//! Scenarios are ordinary GPUI views paired with named, fixed-time checkpoints. The
//! [`Harness`] runs those checkpoints without opening a native window. Call
//! [`write_report`] only when you want to persist the returned capture bundle.

mod fonts;
pub mod image_diff;
#[cfg(feature = "gpu")]
pub mod native;
mod report;
mod runner;
mod snapshot;

pub mod gallery;
pub use fonts::{bundled_fonts, bundled_text_system};
pub use gallery::built_in_scenarios;
pub use image_diff::{
    DiffMode, ImageComparison, ImageDifference, MotionDifference, PixelRegion,
    TransitionComparison, VisibleDifference, compare_images, compare_transition_images,
    compare_transitions,
};
pub use report::{
    CheckpointManifest, EnvironmentManifest, MotionComparison, NativeCheckpointManifest,
    ReportChange, ReportChangeKind, ReportManifest, ReportOptions, ReportStatus, ReportWriter,
    ScenarioManifest, collect_reports, compare_reports, compare_reports_selected, diff_images,
    read_manifest, read_report, write_report,
};
pub use runner::{
    Harness, NativeCheckpoint, NativeReplayInfo, NativeReplayMetrics, RenderedCheckpoint,
    RenderedScenario, RenderedSuite, ScenarioMetrics, TimingPercentiles, Viewport,
};

use anyhow::{Result, ensure};
use gpui::{
    AnyWindowHandle, App, DispatchEventResult, Entity, HeadlessAppContext, Pixels, PlatformInput,
    Render, Size, Window, WindowBounds, WindowHandle, WindowOptions,
};
use std::time::Duration;

/// A renderable scenario with a fixed viewport and ordered checkpoints.
///
/// Each checkpoint advances the simulated clock to `at`, applies its optional
/// update, and captures one finished GPUI frame.
pub struct Scenario<V: Render + 'static> {
    id: String,
    title: String,
    size: Size<Pixels>,
    scale_factor: f32,
    build: Box<dyn Fn(&mut Window, &mut App) -> Entity<V>>,
    checkpoints: Vec<Checkpoint<V>>,
}

/// One named, deterministic point in a scenario timeline.
pub struct Checkpoint<V: Render + 'static> {
    id: String,
    name: String,
    at: Duration,
    update: Option<Box<dyn Fn(&mut HeadlessAppContext, &Entity<V>, WindowHandle<V>) -> Result<()>>>,
}

/// A type-erased scenario that can be run alongside other view types.
///
/// Use this when collecting a heterogeneous set of application-owned scenarios. The underlying
/// view remains statically typed inside each scenario.
pub struct AnyScenario {
    scenario: Box<dyn RunnableScenario>,
}

trait RunnableScenario {
    fn id(&self) -> &str;
    fn title(&self) -> &str;
    fn run(&self, harness: &Harness) -> Result<RenderedScenario>;
}

impl<V: gpui::Render + 'static> RunnableScenario for Scenario<V> {
    fn id(&self) -> &str {
        Scenario::id(self)
    }
    fn title(&self) -> &str {
        Scenario::title(self)
    }
    fn run(&self, harness: &Harness) -> Result<RenderedScenario> {
        harness.run(self)
    }
}

impl<V: gpui::Render + 'static> From<Scenario<V>> for AnyScenario {
    fn from(scenario: Scenario<V>) -> Self {
        Self {
            scenario: Box::new(scenario),
        }
    }
}

impl AnyScenario {
    /// Stable identifier.
    pub fn id(&self) -> &str {
        self.scenario.id()
    }

    /// Human-readable title.
    pub fn title(&self) -> &str {
        self.scenario.title()
    }

    /// Runs the original typed scenario.
    pub fn run(&self, harness: &Harness) -> Result<RenderedScenario> {
        self.scenario.run(harness)
    }
}

impl<V: Render + 'static> Scenario<V> {
    /// Creates a scenario using the same view factory as [`App::open_window`].
    /// IDs must contain only lowercase ASCII letters, digits,
    /// hyphens, or underscores so output paths are stable and safe.
    pub fn new(
        id: impl Into<String>,
        title: impl Into<String>,
        size: Size<Pixels>,
        build: impl Fn(&mut Window, &mut App) -> Entity<V> + 'static,
    ) -> Result<Self> {
        let id = id.into();
        validate_id(&id)?;
        ensure!(
            size.width.as_f32().is_finite()
                && size.height.as_f32().is_finite()
                && size.width.as_f32() > 0.0
                && size.height.as_f32() > 0.0,
            "scenario viewport dimensions must be finite and positive"
        );
        Ok(Self {
            id,
            title: title.into(),
            size,
            scale_factor: 1.0,
            build: Box::new(build),
            checkpoints: Vec::new(),
        })
    }

    /// Sets the deterministic device scale used to build and capture the window.
    pub fn scale_factor(mut self, scale_factor: f32) -> Result<Self> {
        ensure!(
            scale_factor.is_finite() && scale_factor > 0.0,
            "scale factor must be finite and positive"
        );
        self.scale_factor = scale_factor;
        Ok(self)
    }

    /// Adds an unmodified checkpoint at an absolute simulated time.
    pub fn checkpoint(
        mut self,
        id: impl Into<String>,
        name: impl Into<String>,
        at: Duration,
    ) -> Result<Self> {
        self.push_checkpoint(Checkpoint {
            id: id.into(),
            name: name.into(),
            at,
            update: None,
        })?;
        Ok(self)
    }

    /// Adds a checkpoint whose update runs after its clock advance and before drawing.
    pub fn checkpoint_with(
        mut self,
        id: impl Into<String>,
        name: impl Into<String>,
        at: Duration,
        update: impl Fn(&mut HeadlessAppContext, &Entity<V>, WindowHandle<V>) -> Result<()> + 'static,
    ) -> Result<Self> {
        self.push_checkpoint(Checkpoint {
            id: id.into(),
            name: name.into(),
            at,
            update: Some(Box::new(update)),
        })?;
        Ok(self)
    }

    fn push_checkpoint(&mut self, checkpoint: Checkpoint<V>) -> Result<()> {
        validate_id(&checkpoint.id)?;
        ensure!(
            !self.checkpoints.iter().any(|item| item.id == checkpoint.id),
            "duplicate checkpoint id: {}",
            checkpoint.id
        );
        ensure!(
            self.checkpoints
                .last()
                .is_none_or(|previous| previous.at <= checkpoint.at),
            "checkpoint times must be nondecreasing"
        );
        self.checkpoints.push(checkpoint);
        Ok(())
    }

    /// Stable scenario identifier.
    pub fn id(&self) -> &str {
        &self.id
    }

    /// Human-readable scenario title.
    pub fn title(&self) -> &str {
        &self.title
    }

    /// Logical viewport size used by the headless capture and as the native window's default.
    pub fn size(&self) -> Size<Pixels> {
        self.size
    }

    /// Opens the scenario's original typed view in a native GPUI window.
    ///
    /// Caller-provided bounds are preserved. When no bounds are supplied, the scenario viewport
    /// is centered on the current display so ordinary examples can mount the same view used by
    /// headless captures.
    pub fn open_window(&self, cx: &mut App, mut options: WindowOptions) -> Result<WindowHandle<V>> {
        if options.window_bounds.is_none() {
            options.window_bounds = Some(WindowBounds::centered(self.size, cx));
        }
        cx.open_window(options, |window, app| (self.build)(window, app))
    }
}

/// Validates an identifier used as an artifact directory or filename component.
pub fn validate_id(id: &str) -> Result<()> {
    ensure!(!id.is_empty(), "identifier must not be empty");
    ensure!(
        id.bytes().all(|byte| byte.is_ascii_lowercase()
            || byte.is_ascii_digit()
            || byte == b'-'
            || byte == b'_'),
        "identifier must use lowercase ASCII letters, digits, hyphens, or underscores: {id}"
    );
    ensure!(
        !matches!(id.as_bytes().first(), Some(b'-' | b'_'))
            && !matches!(id.as_bytes().last(), Some(b'-' | b'_')),
        "identifier cannot start or end with punctuation: {id}"
    );
    Ok(())
}

/// Dispatches one normal GPUI input event and runs newly scheduled headless work to a parked
/// state. Use this from [`Scenario::checkpoint_with`] for pointer, keyboard, or scroll actions.
pub fn dispatch_input(
    cx: &mut HeadlessAppContext,
    window: AnyWindowHandle,
    input: PlatformInput,
) -> Result<DispatchEventResult> {
    let result = cx.dispatch_input(window, input)?;
    cx.run_until_parked();
    Ok(result)
}

/// Dispatches a normal left-button click at logical window coordinates.
pub fn dispatch_click(
    cx: &mut HeadlessAppContext,
    window: AnyWindowHandle,
    position: gpui::Point<Pixels>,
) -> Result<()> {
    dispatch_input(
        cx,
        window,
        PlatformInput::MouseDown(gpui::MouseDownEvent {
            button: gpui::MouseButton::Left,
            position,
            modifiers: gpui::Modifiers::default(),
            click_count: 1,
            first_mouse: false,
        }),
    )?;
    dispatch_input(
        cx,
        window,
        PlatformInput::MouseUp(gpui::MouseUpEvent {
            button: gpui::MouseButton::Left,
            position,
            modifiers: gpui::Modifiers::default(),
            click_count: 1,
        }),
    )?;
    Ok(())
}

/// Dispatches a click at the rendered center of a GPUI debug selector.
///
/// Use `.debug_selector(|| "stable-name".into())` on the target element. The most recent
/// completed frame must contain that selector; this avoids brittle hard-coded coordinates.
pub fn dispatch_click_on(
    cx: &mut HeadlessAppContext,
    window: AnyWindowHandle,
    selector: &str,
) -> Result<()> {
    let bounds = cx
        .debug_bounds(window, selector)?
        .ok_or_else(|| anyhow::anyhow!("no rendered element has debug selector {selector:?}"))?;
    dispatch_click(cx, window, bounds.center())
}

/// Dispatches a scroll-wheel event at the rendered center of a GPUI debug selector.
pub fn dispatch_scroll_on(
    cx: &mut HeadlessAppContext,
    window: AnyWindowHandle,
    selector: &str,
    delta: gpui::Point<Pixels>,
) -> Result<DispatchEventResult> {
    let bounds = cx
        .debug_bounds(window, selector)?
        .ok_or_else(|| anyhow::anyhow!("no rendered element has debug selector {selector:?}"))?;
    dispatch_input(
        cx,
        window,
        PlatformInput::ScrollWheel(gpui::ScrollWheelEvent {
            position: bounds.center(),
            delta: gpui::ScrollDelta::Pixels(delta),
            modifiers: gpui::Modifiers::default(),
            touch_phase: gpui::TouchPhase::Moved,
        }),
    )
}
