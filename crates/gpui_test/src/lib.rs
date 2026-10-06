//! Deterministic, headless visual scenarios for GPUI.
//!
//! Scenarios are ordinary GPUI views paired with named, fixed-time checkpoints. The
//! [`Harness`] runs those checkpoints without opening a native window. Call
//! [`write_report`] only when you want to persist the returned capture bundle.

mod report;
mod runner;
mod snapshot;

pub mod gallery;
pub use gallery::{BuiltInScenario, built_in_scenarios};
pub use report::{
    CheckpointManifest, EnvironmentManifest, ReportChange, ReportChangeKind, ReportManifest,
    ReportOptions, ReportStatus, ScenarioManifest, compare_reports, compare_reports_selected,
    diff_images, read_manifest, write_report,
};
pub use runner::{
    Harness, RenderedCheckpoint, RenderedScenario, RenderedSuite, ScenarioMetrics, Viewport,
    bundled_text_system,
};

use anyhow::{Result, ensure};
use gpui::{
    AnyWindowHandle, App, DispatchEventResult, Entity, HeadlessAppContext, Pixels, PlatformInput,
    Render, Size, WindowHandle,
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
    build: Box<dyn Fn(&mut App) -> Entity<V>>,
    checkpoints: Vec<Checkpoint<V>>,
}

/// One named, deterministic point in a scenario timeline.
pub struct Checkpoint<V: Render + 'static> {
    id: String,
    name: String,
    at: Duration,
    update: Option<Box<dyn Fn(&mut HeadlessAppContext, &Entity<V>, WindowHandle<V>) -> Result<()>>>,
}

impl<V: Render + 'static> Scenario<V> {
    /// Creates a scenario. IDs must contain only lowercase ASCII letters, digits,
    /// hyphens, or underscores so output paths are stable and safe.
    pub fn new(
        id: impl Into<String>,
        title: impl Into<String>,
        size: Size<Pixels>,
        build: impl Fn(&mut App) -> Entity<V> + 'static,
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
