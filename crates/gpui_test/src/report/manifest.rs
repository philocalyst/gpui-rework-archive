//! Portable report schema and comparison outcomes.
use super::*;

/// Optional output settings for a capture report.
#[derive(Clone, Debug, Default)]
pub struct ReportOptions {
    /// Existing baseline directory. Files follow `<scenario>/<checkpoint>.png`.
    pub baseline_dir: Option<PathBuf>,
    /// Compare only these scenario IDs. Empty compares the complete suite.
    pub selected_ids: Vec<String>,
}

/// The versioned, portable suite manifest consumed by report sites and automation.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ReportManifest {
    /// Manifest schema version.
    pub schema_version: u32,
    /// Rendering backend identifier.
    pub backend: String,
    /// Renderer and font pack details.
    pub environment: EnvironmentManifest,
    /// Native replay adapter metadata; absent from CPU-only reports.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub native_replay: Option<NativeReplayInfo>,
    /// Optional OS-backed window lifecycle diagnostics.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub platform_checks: Option<gpui::WindowCheckReport>,
    /// Scenarios and checkpoint artifacts in stable order.
    pub scenarios: Vec<ScenarioManifest>,
    /// Complete comparison results for the selected baseline, including removed items.
    #[serde(default)]
    pub changes: Vec<ReportChange>,
}

impl ReportManifest {
    /// Regenerate Markdown, SVG, and HTML views from this manifest without loading captures.
    ///
    /// The generated views link to artifacts by paths relative to `output_dir`; callers must
    /// keep those scene and image artifacts available at the same relative paths. This method
    /// does not rewrite `manifest.json` or re-encode captured scenes or PNGs.
    pub fn write_views(&self, output_dir: impl AsRef<Path>) -> Result<()> {
        let output_dir = output_dir.as_ref();
        fs::create_dir_all(output_dir)
            .with_context(|| format!("creating report views in {}", output_dir.display()))?;
        write_markdown(self, output_dir)?;
        write_svg(self, output_dir)?;
        write_html(self, output_dir)?;
        Ok(())
    }
}

/// Environment fields that affect capture interpretation.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct EnvironmentManifest {
    /// Renderer identifier.
    pub renderer: String,
    /// Font fixture pack identifier.
    pub font_pack: String,
    /// Optional source revision supplied by the build.
    pub git_sha: Option<String>,
}

/// One scenario entry in [`ReportManifest`].
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ScenarioManifest {
    /// Stable scenario ID.
    pub id: String,
    /// Human-readable scenario title.
    pub title: String,
    /// Logical viewport and device scale.
    pub viewport: Viewport,
    /// Font fixture pack used by this scenario. Optional for older schema-version-1 reports.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub font_pack: Option<String>,
    /// Baseline comparison outcome for this scenario.
    pub status: ReportStatus,
    /// Checkpoint captures in timeline order.
    pub checkpoints: Vec<CheckpointManifest>,
}

impl ScenarioManifest {
    pub(super) fn metadata<'a>(
        &'a self,
        environment: &'a EnvironmentManifest,
    ) -> (&'a str, &'a Viewport, &'a str) {
        (
            &self.title,
            &self.viewport,
            self.font_pack.as_deref().unwrap_or(&environment.font_pack),
        )
    }
}

/// One checkpoint entry in a scenario manifest.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct CheckpointManifest {
    /// Stable checkpoint ID.
    pub id: String,
    /// Human-readable checkpoint name.
    pub name: String,
    /// Absolute simulated time in nanoseconds.
    pub time_ns: u64,
    /// Previous checkpoint time when a baseline checkpoint matched this ID.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub before_time_ns: Option<u64>,
    /// Relative path to serialized scene JSON.
    pub scene_json: String,
    /// Relative path to rendered PNG.
    pub png: String,
    /// Relative path to the copied before image when a baseline exists.
    pub before_png: Option<String>,
    /// Relative path to a red pixel-difference image when a baseline exists.
    pub diff_png: Option<String>,
    /// Baseline comparison outcome for this checkpoint.
    pub status: ReportStatus,
    /// Whether rendered pixels differ from an available baseline.
    pub pixels_changed: Option<bool>,
    /// Whether the serialized display list differs from an available baseline.
    pub scene_changed: Option<bool>,
    /// Whether scenario or checkpoint metadata differs from an available baseline.
    pub metadata_changed: Option<bool>,
    /// Exact and alpha-aware image difference statistics against the baseline.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub difference: Option<ImageDifference>,
    /// Relative path to the magnitude heatmap when pixels changed against the baseline.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub heatmap_png: Option<String>,
    /// Motion comparison for the preceding matched checkpoint, when both timelines are adjacent.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub motion: Option<MotionComparison>,
    /// CPU-side timing, primitive, batch, and bitmap metrics.
    pub metrics: ScenarioMetrics,
    /// Native replay artifacts and CPU-vs-native pixel statistics, when requested.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub native: Option<NativeCheckpointManifest>,
}

/// Frame-to-frame changes, paired by consecutive checkpoint IDs rather than wall time.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct MotionComparison {
    /// The preceding checkpoint in both timelines.
    pub previous_checkpoint_id: String,
    /// Baseline elapsed time; absent when its timestamps run backwards.
    pub before_duration_ns: Option<u64>,
    /// Current elapsed time; absent when its timestamps run backwards.
    pub current_duration_ns: Option<u64>,
    /// Signed premultiplied color, alpha, and extent transition differences.
    pub difference: MotionDifference,
    /// Relative path to the exact transition mask when motion differs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub diff_png: Option<String>,
    /// Relative path to the transition magnitude heatmap when motion differs.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub heatmap_png: Option<String>,
}

/// Native replay artifacts for one checkpoint.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct NativeCheckpointManifest {
    /// Relative path to the native-rendered image.
    pub png: String,
    /// Relative path to the CPU-vs-native red difference image.
    pub diff_png: String,
    /// Native timings and explicitly scoped memory measurements.
    pub metrics: NativeReplayMetrics,
    /// Difference against the canonical CPU rendering.
    pub difference: ImageDifference,
    /// Relative path to the CPU-vs-native magnitude heatmap when pixels differ.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub heatmap_png: Option<String>,
}

/// Summary status for a report artifact.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ReportStatus {
    /// No baseline report was supplied or available.
    BaselineUnavailable,
    /// A baseline exists but has no corresponding scenario or checkpoint.
    New,
    /// Pixels, scene, and metadata match the baseline.
    Unchanged,
    /// At least one of pixels, scene, or metadata changed.
    Changed,
}

/// Machine-readable category for a comparison result.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ReportChangeKind {
    /// A scenario was added.
    ScenarioAdded,
    /// A scenario was removed.
    ScenarioRemoved,
    /// Scenario title or viewport metadata changed.
    ScenarioMetadataChanged,
    /// A checkpoint was added.
    CheckpointAdded,
    /// A checkpoint was removed.
    CheckpointRemoved,
    /// Checkpoint label or simulated time changed.
    CheckpointMetadataChanged,
    /// Decoded image dimensions or RGBA pixels changed.
    PixelsChanged,
    /// Serialized scene capture changed.
    SceneChanged,
}

/// A structured difference between two report directories.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ReportChange {
    /// Change category.
    pub kind: ReportChangeKind,
    /// Scenario identifier.
    pub scenario_id: String,
    /// Checkpoint ID for checkpoint-level changes.
    pub checkpoint_id: Option<String>,
    /// Human-readable summary.
    pub detail: String,
}
