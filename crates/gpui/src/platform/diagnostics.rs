//! Serializable results from optional native window lifecycle probes.
//!
//! These reports are test-support data, not a runtime health API. A failed probe keeps its
//! partial events and errors so callers can persist evidence from an interrupted native run.

use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

/// Native lifecycle outcomes, independent of the backend that collected them.
#[derive(Clone, Debug, Default, Serialize, Deserialize)]
pub struct WindowCheckReport {
    /// Version of the serialized report contract.
    pub schema_version: u32,
    /// Operating system used for the probe.
    pub platform: String,
    /// Whether all supported checks completed successfully.
    pub status: WindowCheckStatus,
    /// Backend capabilities exercised by this run.
    pub capabilities: BTreeMap<String, bool>,
    /// Completed lifecycle events and observed latency.
    pub events: Vec<WindowCheckEvent>,
    /// Evidence from the native renderer, when capture is supported.
    pub frame: Option<WindowFrameReport>,
    /// Evidence that the OS delivered the requested resize.
    pub resize: Option<WindowResizeReport>,
    /// Check failures, retained so failed runs can still produce a report.
    pub errors: Vec<String>,
}

/// Completion state of a native lifecycle probe.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum WindowCheckStatus {
    /// The event loop has not completed the probe.
    #[default]
    Running,
    /// Every supported check passed.
    Passed,
    /// At least one check failed or the event loop exited early.
    Failed,
}

impl std::fmt::Display for WindowCheckStatus {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Self::Running => "running",
            Self::Passed => "passed",
            Self::Failed => "failed",
        })
    }
}

/// An observed event, including the polling work required to receive it.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct WindowCheckEvent {
    /// Lifecycle condition that completed.
    pub name: String,
    /// Number of event-loop observations.
    pub polls: usize,
    /// Elapsed wall-clock milliseconds.
    pub elapsed_ms: u128,
}

/// Counts from a captured native frame.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct WindowFrameReport {
    /// View paints observed before reading the native frame.
    pub render_count: usize,
    /// Quads in the last finished scene.
    pub quads: usize,
    /// Monochrome glyph sprites in the last finished scene.
    pub monochrome_sprites: usize,
    /// Subpixel glyph sprites in the last finished scene.
    pub subpixel_sprites: usize,
    /// Color glyph and image sprites in the last finished scene.
    pub polychrome_sprites: usize,
    /// Native readback width in device pixels.
    pub capture_width: u32,
    /// Native readback height in device pixels.
    pub capture_height: u32,
    /// Readback pixels that differ from the top-left background sample.
    pub painted_pixels: usize,
}

/// The dimensions actually delivered by a native resize callback.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct WindowResizeReport {
    /// Native bounds callbacks observed during the probe.
    pub callback_count: usize,
    /// Content width delivered by the callback, in logical pixels.
    pub width: f32,
    /// Content height delivered by the callback, in logical pixels.
    pub height: f32,
}
