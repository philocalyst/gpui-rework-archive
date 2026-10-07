mod views;
use views::{write_html, write_markdown, write_svg};

use crate::image_diff::{DiffMode, MotionDifference, compare_images, compare_transitions};
use crate::{
    ImageDifference, NativeReplayInfo, NativeReplayMetrics, RenderedCheckpoint, RenderedScenario,
    RenderedSuite, ScenarioMetrics, Viewport, validate_id,
};
use anyhow::{Context, Result, ensure};
use flate2::{Compression, GzBuilder, read::MultiGzDecoder};
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, BTreeSet, HashSet},
    fs,
    io::{Read, Write},
    path::{Component, Path, PathBuf},
};
use tempfile::TempDir;

const MAX_COMPRESSED_SCENE_BYTES: u64 = 12 * 1024 * 1024;
const MAX_DECOMPRESSED_SCENE_BYTES: usize = 12 * 1024 * 1024;
const MAX_MANIFEST_BYTES: u64 = 12 * 1024 * 1024;

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
    fn metadata<'a>(
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

/// Writes a report suite with captured scenes, PNGs, metrics, and a static HTML viewer.
///
/// This convenience function sends every scenario through ReportWriter.
pub fn write_report(
    suite: &RenderedSuite,
    output_dir: impl AsRef<Path>,
    options: ReportOptions,
) -> Result<ReportManifest> {
    let mut writer = ReportWriter::new(output_dir, options)?;
    writer.add_suite(suite)?;
    writer.finish()
}

/// Incrementally writes captures or report inputs into one portable report directory.
///
/// Scenes and images are persisted as each scenario arrives, so report collection can keep only
/// one input scenario in memory at a time.
pub struct ReportWriter {
    target_dir: PathBuf,
    output_dir: PathBuf,
    _staging_dir: TempDir,
    options: ReportOptions,
    baseline: Option<(PathBuf, ReportManifest)>,
    scenarios: Vec<ScenarioManifest>,
    scenario_indices: BTreeMap<String, usize>,
    font_packs: BTreeSet<String>,
    source_git_sha: Option<String>,
    native_replay: Option<NativeReplayInfo>,
    platform_checks: Option<gpui::WindowCheckReport>,
    failed: bool,
}

impl ReportWriter {
    /// Creates a staging directory beside the output and reads an optional baseline once.
    pub fn new(output_dir: impl AsRef<Path>, options: ReportOptions) -> Result<Self> {
        let requested = output_dir.as_ref();
        ensure!(
            !requested.is_symlink(),
            "report output directory cannot be a symlink"
        );
        let requested_output = resolved_candidate(requested)?;
        if requested_output.exists() {
            ensure!(
                !fs::symlink_metadata(&requested_output)?
                    .file_type()
                    .is_symlink(),
                "report output directory cannot be a symlink"
            );
            ensure!(
                requested_output.is_dir(),
                "report output is not a directory"
            );
        }
        let baseline = if let Some(baseline_dir) = &options.baseline_dir {
            let baseline_root = baseline_dir.canonicalize().with_context(|| {
                format!("opening baseline directory {}", baseline_dir.display())
            })?;
            ensure!(
                requested_output != baseline_root
                    && !requested_output.starts_with(&baseline_root)
                    && !baseline_root.starts_with(&requested_output),
                "output and baseline directories must not contain one another"
            );
            Some((baseline_root.clone(), read_manifest(&baseline_root)?))
        } else {
            None
        };
        if requested_output.exists() {
            let mut entries = fs::read_dir(&requested_output)?;
            if entries.next().is_some() {
                read_manifest(&requested_output).with_context(|| {
                    format!(
                        "refusing to replace non-report output directory {}",
                        requested_output.display()
                    )
                })?;
            }
        }
        let parent = requested_output
            .parent()
            .context("report output must have a parent directory")?;
        fs::create_dir_all(parent)
            .with_context(|| format!("creating report parent directory {}", parent.display()))?;
        let staging_dir = tempfile::Builder::new()
            .prefix(".gpui-report-")
            .tempdir_in(parent)
            .with_context(|| {
                format!(
                    "creating staging directory beside {}",
                    requested_output.display()
                )
            })?;
        let output_dir = staging_dir.path().join("report");
        fs::create_dir(&output_dir)?;
        Ok(Self {
            target_dir: requested_output,
            output_dir,
            _staging_dir: staging_dir,
            options,
            baseline,
            scenarios: Vec::new(),
            scenario_indices: BTreeMap::new(),
            font_packs: BTreeSet::new(),
            source_git_sha: None,
            native_replay: None,
            platform_checks: None,
            failed: false,
        })
    }

    /// Writes one scenario, rejecting duplicate IDs.
    pub fn add_scenario(&mut self, scenario: &RenderedScenario) -> Result<()> {
        self.add(|writer| writer.add_scenario_inner(scenario))
    }

    fn add_scenario_inner(&mut self, scenario: &RenderedScenario) -> Result<()> {
        validate_id(&scenario.id)?;
        ensure!(
            scenario
                .checkpoints
                .iter()
                .all(|checkpoint| checkpoint.native.is_none())
                || self.native_replay.is_some(),
            "native checkpoint artifacts require suite native replay metadata; use add_suite"
        );
        ensure!(
            !self.scenario_indices.contains_key(&scenario.id),
            "duplicate scenario id: {}",
            scenario.id
        );
        self.write_scenario(scenario, None)
    }

    /// Adds an in-memory suite, including its optional native and platform metadata.
    pub fn add_suite(&mut self, suite: &RenderedSuite) -> Result<()> {
        self.add(|writer| writer.add_suite_inner(suite))
    }

    fn add_suite_inner(&mut self, suite: &RenderedSuite) -> Result<()> {
        merge_optional_report_value(
            &mut self.native_replay,
            suite.native_replay.clone(),
            "native WGPU adapter metadata",
        )?;
        merge_optional_report_value(
            &mut self.platform_checks,
            suite.platform_checks.clone(),
            "platform lifecycle report",
        )?;
        for scenario in &suite.scenarios {
            self.add_scenario(scenario)?;
        }
        Ok(())
    }

    /// Loads one report at a time and keeps the first identical copy of each scenario ID.
    pub fn add_report(&mut self, report_dir: impl AsRef<Path>) -> Result<()> {
        self.add(|writer| writer.add_report_inner(report_dir.as_ref()))
    }

    fn add_report_inner(&mut self, report_dir: &Path) -> Result<()> {
        let root = report_dir
            .canonicalize()
            .with_context(|| format!("opening report directory {}", report_dir.display()))?;
        ensure!(
            root != self.target_dir
                && !root.starts_with(&self.target_dir)
                && !self.target_dir.starts_with(&root),
            "input report and output directories must not contain one another"
        );
        let manifest = read_manifest(&root)?;
        ensure!(
            manifest.backend == "cpu",
            "unsupported report backend {:?}",
            manifest.backend
        );
        merge_optional_report_value(
            &mut self.native_replay,
            manifest.native_replay,
            "native WGPU adapter metadata",
        )?;
        merge_optional_report_value(
            &mut self.platform_checks,
            manifest.platform_checks,
            "platform lifecycle report",
        )?;
        if let Some(source_sha) = &manifest.environment.git_sha {
            if let Some(existing_sha) = &self.source_git_sha {
                ensure!(
                    existing_sha == source_sha,
                    "incompatible source revisions across collected reports"
                );
            } else {
                self.source_git_sha = Some(source_sha.clone());
            }
        }
        for scenario_manifest in manifest.scenarios {
            if let Some(index) = self.scenario_indices.get(&scenario_manifest.id)
                && identical_stored_scenarios(
                    &root,
                    &scenario_manifest,
                    &manifest.environment,
                    &self.output_dir,
                    &self.scenarios[*index],
                )?
            {
                continue;
            }
            let scenario = read_scenario(
                &root,
                &manifest.environment.font_pack,
                scenario_manifest.clone(),
            )?;
            if let Some(index) = self.scenario_indices.get(&scenario.id).copied() {
                let existing = read_scenario(&self.output_dir, "", self.scenarios[index].clone())?;
                ensure!(
                    scenarios_equal(&existing, &scenario),
                    "conflicting duplicate scenario ID {:?}",
                    scenario.id
                );
            } else {
                self.write_scenario(&scenario, Some((&root, &scenario_manifest)))?;
            }
        }
        Ok(())
    }

    /// Writes the final manifest and its report views.
    pub fn finish(self) -> Result<ReportManifest> {
        ensure!(
            !self.failed,
            "cannot finish a report writer after a failed add operation"
        );
        let ambient_git_sha = std::env::var("GIT_SHA").ok();
        if let (Some(imported), Some(ambient)) = (&self.source_git_sha, &ambient_git_sha) {
            ensure!(
                imported == ambient,
                "GIT_SHA {ambient:?} conflicts with imported report revision {imported:?}"
            );
        }
        let git_sha = self.source_git_sha.or(ambient_git_sha);
        let mut manifest = ReportManifest {
            schema_version: 1,
            backend: "cpu".into(),
            environment: EnvironmentManifest {
                renderer: "gpui-ce-cpu".into(),
                font_pack: self.font_packs.into_iter().collect::<Vec<_>>().join(", "),
                git_sha,
            },
            native_replay: self.native_replay,
            platform_checks: self.platform_checks,
            scenarios: self.scenarios,
            changes: Vec::new(),
        };
        if let Some((_, baseline)) = &self.baseline {
            manifest.changes = compare_manifests(
                baseline,
                &manifest,
                &self.options.selected_ids,
                |_, current| {
                    Ok((
                        current
                            .pixels_changed
                            .context("matched checkpoint has pixel comparison")?,
                        current
                            .scene_changed
                            .context("matched checkpoint has scene comparison")?,
                    ))
                },
            )?;
        }
        fs::write(
            self.output_dir.join("manifest.json"),
            serde_json::to_vec_pretty(&manifest)?,
        )?;
        manifest.write_views(&self.output_dir)?;
        publish_report(&self.output_dir, &self.target_dir)?;
        Ok(manifest)
    }

    fn add(&mut self, operation: impl FnOnce(&mut Self) -> Result<()>) -> Result<()> {
        ensure!(
            !self.failed,
            "report writer is unusable after a failed add operation"
        );
        let result = operation(self);
        self.failed |= result.is_err();
        result
    }

    fn write_scenario(
        &mut self,
        scenario: &RenderedScenario,
        source: Option<(&Path, &ScenarioManifest)>,
    ) -> Result<()> {
        let output_dir = self.output_dir.as_path();
        let baseline_manifest = self.baseline.as_ref().map(|(_, manifest)| manifest);
        let previous_scenario = baseline_manifest.as_ref().and_then(|manifest| {
            manifest
                .scenarios
                .iter()
                .find(|previous| previous.id == scenario.id)
        });
        let scenario_metadata_changed =
            baseline_manifest
                .as_ref()
                .zip(previous_scenario)
                .map(|(manifest, previous)| {
                    previous.metadata(&manifest.environment)
                        != (
                            scenario.title.as_str(),
                            &scenario.viewport,
                            scenario.font_pack.as_str(),
                        )
                });
        let dir = output_dir.join(&scenario.id);
        fs::create_dir_all(&dir)
            .with_context(|| format!("creating scenario directory {}", dir.display()))?;
        let mut checkpoints = Vec::with_capacity(scenario.checkpoints.len());
        let mut checkpoint_ids = HashSet::new();
        let mut previous_pair: Option<(usize, image::RgbaImage)> = None;
        for (index, checkpoint) in scenario.checkpoints.iter().enumerate() {
            validate_id(&checkpoint.id)?;
            ensure!(
                checkpoint_ids.insert(&checkpoint.id),
                "duplicate checkpoint id in {}: {}",
                scenario.id,
                checkpoint.id
            );
            let scene_file = format!("{}.scene.json.gz", checkpoint.id);
            let png_file = format!("{}.png", checkpoint.id);
            let scene_path = dir.join(&scene_file);
            let source_checkpoint =
                source.map(|(root, scenario)| (root, &scenario.checkpoints[index]));
            // Compress artifact bytes after serialization; comparison and snapshots still use
            // the original scene values, independent of their storage encoding.
            if let Some((root, source)) = source_checkpoint
                && source.scene_json.ends_with(".gz")
            {
                fs::copy(artifact_path(root, &source.scene_json)?, &scene_path)?;
            } else {
                let scene_bytes = serde_json::to_vec(&checkpoint.capture)?;
                fs::write(&scene_path, gzip_scene_json(&scene_bytes)?)
                    .with_context(|| format!("writing {}", scene_path.display()))?;
            }
            let png_path = dir.join(&png_file);
            if let Some((root, source)) = source_checkpoint {
                fs::copy(artifact_path(root, &source.png)?, &png_path)?;
            } else {
                save_png(&png_path, &checkpoint.image)?;
            }
            let native = if let Some(native) = &checkpoint.native {
                let native_file = format!("{}.native.png", checkpoint.id);
                let diff_file = format!("{}.native.diff.png", checkpoint.id);
                if let Some((root, source)) = source_checkpoint
                    && let Some(source_native) = &source.native
                {
                    fs::copy(
                        artifact_path(root, &source_native.png)?,
                        dir.join(&native_file),
                    )?;
                } else {
                    save_png(&dir.join(&native_file), &native.image)?;
                }
                let different = native.image != checkpoint.image;
                let exact = different
                    .then(|| compare_images(&checkpoint.image, &native.image, DiffMode::Exact));
                if let Some(exact) = &exact {
                    save_png(&dir.join(&diff_file), &exact.image)?;
                } else {
                    save_png(&dir.join(&diff_file), &native.diff)?;
                }
                let heatmap_png = if different {
                    let heatmap_file = format!("{}.native.heatmap.png", checkpoint.id);
                    let magnitude =
                        compare_images(&checkpoint.image, &native.image, DiffMode::Magnitude);
                    save_png(&dir.join(&heatmap_file), &magnitude.image)?;
                    Some(format!("{}/{}", scenario.id, heatmap_file))
                } else {
                    None
                };
                Some(NativeCheckpointManifest {
                    png: format!("{}/{}", scenario.id, native_file),
                    diff_png: format!("{}/{}", scenario.id, diff_file),
                    metrics: native.metrics.clone(),
                    difference: exact
                        .map(|exact| exact.difference)
                        .unwrap_or_else(|| native.difference.clone()),
                    heatmap_png,
                })
            } else {
                None
            };
            let baseline_index = previous_scenario.and_then(|previous| {
                previous
                    .checkpoints
                    .iter()
                    .position(|item| item.id == checkpoint.id)
            });
            let previous_checkpoint = previous_scenario
                .zip(baseline_index)
                .map(|(scenario, index)| &scenario.checkpoints[index]);
            let previous_assets =
                previous_checkpoint.zip(self.baseline.as_ref().map(|(root, _)| root.as_path()));
            let before = previous_assets
                .map(|(previous, root)| read_image(&root.join(&previous.png)))
                .transpose()?;
            // Do not bridge an added/removed or reordered checkpoint. Both sides must describe
            // the same adjacent transition; unequal elapsed times remain explicit metadata.
            let motion = previous_pair.as_ref().zip(before.as_ref()).and_then(
                |((previous_baseline_index, previous_before), before)| {
                    let baseline_index = baseline_index?;
                    if baseline_index != previous_baseline_index + 1 {
                        return None;
                    }
                    let previous_current = &scenario.checkpoints[index - 1];
                    let previous_baseline =
                        &previous_scenario?.checkpoints[*previous_baseline_index];
                    Some(MotionComparison {
                        previous_checkpoint_id: previous_current.id.clone(),
                        before_duration_ns: previous_checkpoint?
                            .time_ns
                            .checked_sub(previous_baseline.time_ns),
                        current_duration_ns: checkpoint
                            .time_ns
                            .checked_sub(previous_current.time_ns),
                        difference: compare_transitions(
                            previous_before,
                            before,
                            &previous_current.image,
                            &checkpoint.image,
                        ),
                    })
                },
            );
            let comparison = before
                .as_ref()
                .filter(|image| *image != &checkpoint.image)
                .map(|image| compare_images(image, &checkpoint.image, DiffMode::Exact));
            let pixels_changed = before.as_ref().map(|_| {
                comparison.as_ref().is_some_and(|comparison| {
                    comparison.difference.changed_pixels > 0 || comparison.difference.size_changed
                })
            });
            let difference = comparison
                .as_ref()
                .map(|comparison| comparison.difference.clone());
            let scene_changed = previous_assets
                .map(|(previous, root)| -> Result<bool> {
                    // Compare the persisted values: to_value widens f32 numbers
                    // differently from the JSON serializer used by capture files.
                    Ok(read_capture(&artifact_path(root, &previous.scene_json)?)?
                        != checkpoint.capture)
                })
                .transpose()?;
            let metadata_changed = previous_checkpoint.map(|previous| {
                previous.name != checkpoint.name
                    || previous.time_ns != checkpoint.time_ns
                    || scenario_metadata_changed.unwrap_or(false)
            });
            let status = match (baseline_manifest.is_some(), previous_checkpoint) {
                (false, _) => ReportStatus::BaselineUnavailable,
                (true, None) => ReportStatus::New,
                (true, Some(_))
                    if pixels_changed == Some(true)
                        || scene_changed == Some(true)
                        || metadata_changed == Some(true) =>
                {
                    ReportStatus::Changed
                }
                (true, Some(_)) => ReportStatus::Unchanged,
            };
            let (before_png, diff_png, heatmap_png) = if pixels_changed == Some(true)
                && let (Some(before), Some(exact)) = (&before, &comparison)
            {
                let before_file = format!("{}.before.png", checkpoint.id);
                let diff_file = format!("{}.diff.png", checkpoint.id);
                let heatmap_file = format!("{}.heatmap.png", checkpoint.id);
                save_png(&dir.join(&before_file), before)?;
                save_png(&dir.join(&diff_file), &exact.image)?;
                let magnitude = compare_images(before, &checkpoint.image, DiffMode::Magnitude);
                save_png(&dir.join(&heatmap_file), &magnitude.image)?;
                (
                    Some(format!("{}/{}", scenario.id, before_file)),
                    Some(format!("{}/{}", scenario.id, diff_file)),
                    Some(format!("{}/{}", scenario.id, heatmap_file)),
                )
            } else {
                (None, None, None)
            };
            checkpoints.push(CheckpointManifest {
                id: checkpoint.id.clone(),
                name: checkpoint.name.clone(),
                time_ns: checkpoint.time_ns,
                before_time_ns: previous_checkpoint.map(|previous| previous.time_ns),
                scene_json: format!("{}/{}", scenario.id, scene_file),
                png: format!("{}/{}", scenario.id, png_file),
                before_png,
                diff_png,
                heatmap_png,
                status,
                pixels_changed,
                scene_changed,
                metadata_changed,
                difference,
                motion,
                metrics: checkpoint.metrics.clone(),
                native,
            });
            previous_pair = baseline_index.zip(before);
        }
        let checkpoint_set_changed = previous_scenario.is_some_and(|previous| {
            let old_ids: BTreeSet<_> = previous
                .checkpoints
                .iter()
                .map(|checkpoint| checkpoint.id.as_str())
                .collect();
            let new_ids: BTreeSet<_> = scenario
                .checkpoints
                .iter()
                .map(|checkpoint| checkpoint.id.as_str())
                .collect();
            old_ids != new_ids
        });
        let status = if baseline_manifest.is_none() {
            ReportStatus::BaselineUnavailable
        } else if previous_scenario.is_none() {
            ReportStatus::New
        } else if scenario_metadata_changed == Some(true)
            || checkpoint_set_changed
            || checkpoints
                .iter()
                .any(|checkpoint| checkpoint.status == ReportStatus::Changed)
        {
            ReportStatus::Changed
        } else if checkpoints
            .iter()
            .any(|checkpoint| checkpoint.status == ReportStatus::New)
        {
            ReportStatus::New
        } else {
            ReportStatus::Unchanged
        };
        self.scenario_indices
            .insert(scenario.id.clone(), self.scenarios.len());
        self.font_packs.insert(scenario.font_pack.clone());
        self.scenarios.push(ScenarioManifest {
            id: scenario.id.clone(),
            title: scenario.title.clone(),
            viewport: scenario.viewport.clone(),
            font_pack: Some(scenario.font_pack.clone()),
            status,
            checkpoints,
        });
        Ok(())
    }
}

/// Reads a suite manifest and validates its schema, viewport, identifiers, and artifact paths.
/// Images and scene values are loaded only when a comparison needs them.
pub fn read_manifest(report_dir: impl AsRef<Path>) -> Result<ReportManifest> {
    let path = report_dir.as_ref().join("manifest.json");
    let manifest_bytes = read_limited_file(&path, MAX_MANIFEST_BYTES)
        .with_context(|| format!("reading {}", path.display()))?;
    let manifest: ReportManifest = serde_json::from_slice(&manifest_bytes)?;
    ensure!(
        manifest.schema_version == 1,
        "unsupported manifest schema version {}",
        manifest.schema_version
    );
    let mut scenario_ids = HashSet::new();
    for scenario in &manifest.scenarios {
        validate_id(&scenario.id)?;
        ensure!(
            scenario_ids.insert(&scenario.id),
            "duplicate scenario id: {}",
            scenario.id
        );
        ensure!(
            scenario.viewport.width.is_finite()
                && scenario.viewport.height.is_finite()
                && scenario.viewport.width > 0.0
                && scenario.viewport.height > 0.0,
            "scenario viewport dimensions must be finite and positive"
        );
        ensure!(
            scenario.viewport.scale_factor.is_finite() && scenario.viewport.scale_factor > 0.0,
            "scenario scale factor must be finite and positive"
        );
        let mut checkpoint_ids = HashSet::new();
        for checkpoint in &scenario.checkpoints {
            validate_id(&checkpoint.id)?;
            ensure!(
                checkpoint_ids.insert(&checkpoint.id),
                "duplicate checkpoint id in {}: {}",
                scenario.id,
                checkpoint.id
            );
            ensure!(
                (checkpoint.scene_json == format!("{}/{}.scene.json", scenario.id, checkpoint.id)
                    || checkpoint.scene_json
                        == format!("{}/{}.scene.json.gz", scenario.id, checkpoint.id))
                    && checkpoint.png == format!("{}/{}.png", scenario.id, checkpoint.id),
                "noncanonical artifact paths for {}/{}",
                scenario.id,
                checkpoint.id
            );
            ensure!(
                checkpoint.before_png.as_deref().is_none_or(|path| {
                    path == format!("{}/{}.before.png", scenario.id, checkpoint.id)
                }) && checkpoint.diff_png.as_deref().is_none_or(|path| {
                    path == format!("{}/{}.diff.png", scenario.id, checkpoint.id)
                }) && checkpoint.heatmap_png.as_deref().is_none_or(|path| {
                    path == format!("{}/{}.heatmap.png", scenario.id, checkpoint.id)
                }),
                "noncanonical comparison image paths for {}/{}",
                scenario.id,
                checkpoint.id
            );
            if let Some(native) = &checkpoint.native {
                ensure!(
                    manifest.native_replay.is_some(),
                    "native checkpoint artifact exists without suite native replay metadata"
                );
                ensure!(
                    native.png == format!("{}/{}.native.png", scenario.id, checkpoint.id)
                        && native.diff_png
                            == format!("{}/{}.native.diff.png", scenario.id, checkpoint.id),
                    "noncanonical native image paths for {}/{}",
                    scenario.id,
                    checkpoint.id
                );
                ensure!(
                    native.heatmap_png.as_deref().is_none_or(|path| {
                        path == format!("{}/{}.native.heatmap.png", scenario.id, checkpoint.id)
                    }),
                    "noncanonical native heatmap path for {}/{}",
                    scenario.id,
                    checkpoint.id
                );
            }
        }
    }
    Ok(manifest)
}

/// Loads a report's portable captures and PNGs into an in-memory suite.
///
/// Paths are constrained to the canonical report layout before opening any artifacts, and every
/// serialized scene is validated before it is returned for replay or collection.
pub fn read_report(report_dir: impl AsRef<Path>) -> Result<RenderedSuite> {
    let report_dir = report_dir.as_ref();
    let root = report_dir
        .canonicalize()
        .with_context(|| format!("opening report directory {}", report_dir.display()))?;
    let manifest = read_manifest(&root)?;
    ensure!(
        manifest.backend == "cpu",
        "unsupported report backend {:?}",
        manifest.backend
    );
    let mut scenarios = Vec::with_capacity(manifest.scenarios.len());
    for scenario in manifest.scenarios {
        scenarios.push(read_scenario(
            &root,
            &manifest.environment.font_pack,
            scenario,
        )?);
    }
    Ok(RenderedSuite {
        scenarios,
        native_replay: manifest.native_replay,
        platform_checks: manifest.platform_checks,
    })
}

/// Loads multiple reports in input order, retaining the first copy of identical scenario IDs.
///
/// Duplicate captures must agree on all scenario/checkpoint metadata, scene and bitmap content,
/// and canonical RGBA pixels. Timing metrics are intentionally ignored. Non-null native adapter
/// and platform results must agree wherever they are both present.
pub fn collect_reports(report_dirs: &[impl AsRef<Path>]) -> Result<RenderedSuite> {
    ensure!(
        !report_dirs.is_empty(),
        "at least one report directory is required"
    );
    let mut suite = RenderedSuite::new(Vec::new());
    let mut scenario_indices = BTreeMap::<String, usize>::new();
    for report_dir in report_dirs {
        let report_dir = report_dir.as_ref();
        let root = report_dir
            .canonicalize()
            .with_context(|| format!("opening report directory {}", report_dir.display()))?;
        let manifest = read_manifest(&root)?;
        ensure!(
            manifest.backend == "cpu",
            "unsupported report backend {:?}",
            manifest.backend
        );
        merge_optional_report_value(
            &mut suite.native_replay,
            manifest.native_replay,
            "native WGPU adapter metadata",
        )?;
        merge_optional_report_value(
            &mut suite.platform_checks,
            manifest.platform_checks,
            "platform lifecycle report",
        )?;
        for scenario_manifest in manifest.scenarios {
            let scenario =
                read_scenario(&root, &manifest.environment.font_pack, scenario_manifest)?;
            if let Some(index) = scenario_indices.get(&scenario.id) {
                let existing = &suite.scenarios[*index];
                ensure!(
                    scenarios_equal(existing, &scenario),
                    "conflicting duplicate scenario ID {:?}",
                    scenario.id
                );
            } else {
                scenario_indices.insert(scenario.id.clone(), suite.scenarios.len());
                suite.scenarios.push(scenario);
            }
        }
    }
    Ok(suite)
}

fn read_scenario(
    root: &Path,
    default_font_pack: &str,
    scenario: ScenarioManifest,
) -> Result<RenderedScenario> {
    let device_size = scenario.viewport.device_size()?;
    let mut checkpoints = Vec::with_capacity(scenario.checkpoints.len());
    for checkpoint in scenario.checkpoints {
        if let Some(path) = &checkpoint.heatmap_png {
            artifact_path(root, path)?;
        }
        let scene_path = artifact_path(root, &checkpoint.scene_json)?;
        let capture = read_capture(&scene_path).with_context(|| {
            format!("validating scene capture {}/{}", scenario.id, checkpoint.id)
        })?;

        let image = read_image(&artifact_path(root, &checkpoint.png)?)?;
        ensure!(
            image.dimensions() == (device_size.width.0 as u32, device_size.height.0 as u32),
            "image dimensions do not match viewport for {}/{}",
            scenario.id,
            checkpoint.id
        );
        let native = checkpoint
            .native
            .map(|native| -> Result<_> {
                let native_image = read_image(&artifact_path(root, &native.png)?)?;
                let diff = read_image(&artifact_path(root, &native.diff_png)?)?;
                if let Some(path) = &native.heatmap_png {
                    artifact_path(root, path)?;
                }
                ensure!(
                    native_image.dimensions() == image.dimensions()
                        && diff.dimensions() == image.dimensions(),
                    "native images have unexpected dimensions for {}/{}",
                    scenario.id,
                    checkpoint.id
                );
                Ok(crate::NativeCheckpoint {
                    image: native_image,
                    diff,
                    metrics: native.metrics,
                    difference: native.difference,
                })
            })
            .transpose()?;
        checkpoints.push(RenderedCheckpoint {
            id: checkpoint.id,
            name: checkpoint.name,
            time_ns: checkpoint.time_ns,
            capture,
            image,
            metrics: checkpoint.metrics,
            native,
        });
    }
    Ok(RenderedScenario {
        id: scenario.id,
        title: scenario.title,
        viewport: scenario.viewport,
        font_pack: scenario
            .font_pack
            .unwrap_or_else(|| default_font_pack.to_owned()),
        checkpoints,
    })
}

fn scenarios_equal(left: &RenderedScenario, right: &RenderedScenario) -> bool {
    left.title == right.title
        && left.viewport == right.viewport
        && left.font_pack == right.font_pack
        && left.checkpoints.len() == right.checkpoints.len()
        && left
            .checkpoints
            .iter()
            .zip(&right.checkpoints)
            .all(|(left, right)| {
                left.id == right.id
                    && left.name == right.name
                    && left.time_ns == right.time_ns
                    && left.capture == right.capture
                    && left.image == right.image
            })
}

// An already validated capture needs no second decode when its persisted bytes are identical.
// Different encodings fall back to typed scene and decoded pixel comparison.
fn identical_stored_scenarios(
    source_root: &Path,
    source: &ScenarioManifest,
    environment: &EnvironmentManifest,
    stored_root: &Path,
    stored: &ScenarioManifest,
) -> Result<bool> {
    if source.metadata(environment) != stored.metadata(environment)
        || source.checkpoints.len() != stored.checkpoints.len()
    {
        return Ok(false);
    }
    for (source, stored) in source.checkpoints.iter().zip(&stored.checkpoints) {
        if source.id != stored.id || source.name != stored.name || source.time_ns != stored.time_ns
        {
            return Ok(false);
        }
        let mut paths = vec![
            (&source.scene_json, &stored.scene_json),
            (&source.png, &stored.png),
        ];
        match (&source.native, &stored.native) {
            (Some(source), Some(stored)) => {
                paths.extend([
                    (&source.png, &stored.png),
                    (&source.diff_png, &stored.diff_png),
                ]);
                if let Some(path) = &source.heatmap_png {
                    artifact_path(source_root, path)?;
                }
            }
            (None, None) => {}
            _ => return Ok(false),
        }
        if let Some(path) = &source.heatmap_png {
            artifact_path(source_root, path)?;
        }
        for (source_path, stored_path) in paths {
            if !files_equal(
                &artifact_path(source_root, source_path)?,
                &artifact_path(stored_root, stored_path)?,
            )? {
                return Ok(false);
            }
        }
    }
    Ok(true)
}

fn files_equal(left: &Path, right: &Path) -> Result<bool> {
    let mut left = fs::File::open(left)?;
    let mut right = fs::File::open(right)?;
    let mut remaining = left.metadata()?.len();
    if remaining != right.metadata()?.len() {
        return Ok(false);
    }
    let mut a = [0; 16 * 1024];
    let mut b = [0; 16 * 1024];
    while remaining > 0 {
        let count = remaining.min(a.len() as u64) as usize;
        left.read_exact(&mut a[..count])?;
        right.read_exact(&mut b[..count])?;
        if a[..count] != b[..count] {
            return Ok(false);
        }
        remaining -= count as u64;
    }
    Ok(true)
}

fn merge_optional_report_value<T: Serialize>(
    current: &mut Option<T>,
    incoming: Option<T>,
    label: &str,
) -> Result<()> {
    if let Some(incoming) = incoming {
        if let Some(current) = current {
            ensure!(
                serde_json::to_value(&*current)? == serde_json::to_value(&incoming)?,
                "incompatible {label} across collected reports"
            );
        } else {
            *current = Some(incoming);
        }
    }
    Ok(())
}

fn artifact_path(root: &Path, relative: &str) -> Result<PathBuf> {
    let path = root
        .join(relative)
        .canonicalize()
        .with_context(|| format!("opening report artifact {relative}"))?;
    ensure!(
        path.starts_with(root),
        "report artifact escapes report directory: {relative}"
    );
    Ok(path)
}

fn resolved_candidate(path: &Path) -> Result<PathBuf> {
    let absolute = if path.is_absolute() {
        path.to_path_buf()
    } else {
        std::env::current_dir()?.join(path)
    };
    let mut resolved = PathBuf::new();
    for component in absolute.components() {
        match component {
            Component::Prefix(prefix) => resolved.push(prefix.as_os_str()),
            Component::RootDir => resolved.push(component.as_os_str()),
            Component::CurDir => {}
            Component::ParentDir => {
                resolved.pop();
            }
            Component::Normal(part) => {
                let candidate = resolved.join(part);
                resolved = match fs::symlink_metadata(&candidate) {
                    Ok(_) => candidate.canonicalize()?,
                    Err(error) if error.kind() == std::io::ErrorKind::NotFound => candidate,
                    Err(error) => return Err(error.into()),
                };
            }
        }
    }
    Ok(resolved)
}

fn publish_report(staged_report: &Path, target: &Path) -> Result<()> {
    let parent = target
        .parent()
        .context("report output must have a parent")?;
    if target.exists() {
        let backup_root = tempfile::Builder::new()
            .prefix(".gpui-report-backup-")
            .tempdir_in(parent)?;
        let backup = backup_root.path().join("previous");
        fs::rename(target, &backup)
            .with_context(|| format!("moving existing report {} aside", target.display()))?;
        if let Err(error) = fs::rename(staged_report, target) {
            let restore = fs::rename(&backup, target);
            if let Err(restore_error) = restore {
                let backup_location = backup.display().to_string();
                let _preserved_tempdir = backup_root.keep();
                anyhow::bail!(
                    "publishing report failed ({error}); restoring previous report also failed ({restore_error}); previous report preserved at {backup_location}"
                );
            }
            return Err(error)
                .with_context(|| format!("publishing report to {}", target.display()));
        }
        drop(backup_root);
    } else {
        fs::rename(staged_report, target)
            .with_context(|| format!("publishing report to {}", target.display()))?;
    }
    Ok(())
}

/// Compares two report directories. Any scenario/checkpoint addition, removal, metadata,
/// serialized-scene, or decoded pixel change is returned as a human-readable entry.
pub fn compare_reports(
    baseline_dir: impl AsRef<Path>,
    current_dir: impl AsRef<Path>,
) -> Result<Vec<ReportChange>> {
    compare_reports_selected(baseline_dir, current_dir, &[])
}

/// Compares all scenarios or only the listed scenario IDs when `selected_ids` is nonempty.
pub fn compare_reports_selected(
    baseline_dir: impl AsRef<Path>,
    current_dir: impl AsRef<Path>,
    selected_ids: &[String],
) -> Result<Vec<ReportChange>> {
    let baseline_dir = baseline_dir.as_ref().canonicalize()?;
    let current_dir = current_dir.as_ref().canonicalize()?;
    let baseline = read_manifest(&baseline_dir)?;
    let current = read_manifest(&current_dir)?;
    compare_manifests(&baseline, &current, selected_ids, |old, new| {
        Ok((
            read_image(&artifact_path(&baseline_dir, &old.png)?)?
                != read_image(&artifact_path(&current_dir, &new.png)?)?,
            read_capture(&artifact_path(&baseline_dir, &old.scene_json)?)?
                != read_capture(&artifact_path(&current_dir, &new.scene_json)?)?,
        ))
    })
}

// Entity additions, removals, and metadata use the same comparison for in-memory
// captures and saved reports. The caller supplies the two content comparisons.
fn compare_manifests(
    baseline: &ReportManifest,
    current: &ReportManifest,
    selected_ids: &[String],
    mut content_changed: impl FnMut(&CheckpointManifest, &CheckpointManifest) -> Result<(bool, bool)>,
) -> Result<Vec<ReportChange>> {
    for id in selected_ids {
        validate_id(id)?;
    }
    let old_scenarios: BTreeMap<_, _> = baseline
        .scenarios
        .iter()
        .filter(|scenario| selected_ids.is_empty() || selected_ids.contains(&scenario.id))
        .map(|scenario| (scenario.id.as_str(), scenario))
        .collect();
    let new_scenarios: BTreeMap<_, _> = current
        .scenarios
        .iter()
        .filter(|scenario| selected_ids.is_empty() || selected_ids.contains(&scenario.id))
        .map(|scenario| (scenario.id.as_str(), scenario))
        .collect();
    let mut changes = Vec::<ReportChange>::new();
    for id in old_scenarios.keys() {
        if !new_scenarios.contains_key(id) {
            changes.push(change(
                ReportChangeKind::ScenarioRemoved,
                id,
                None,
                "scenario removed",
            ));
        }
    }
    for id in new_scenarios.keys() {
        if !old_scenarios.contains_key(id) {
            changes.push(change(
                ReportChangeKind::ScenarioAdded,
                id,
                None,
                "scenario added",
            ));
        }
    }
    for (id, new_scenario) in &new_scenarios {
        let Some(old_scenario) = old_scenarios.get(id) else {
            continue;
        };
        if old_scenario.metadata(&baseline.environment)
            != new_scenario.metadata(&current.environment)
        {
            changes.push(change(
                ReportChangeKind::ScenarioMetadataChanged,
                id,
                None,
                "scenario title, viewport, or font pack changed",
            ));
        }
        let old_checkpoints: BTreeMap<_, _> = old_scenario
            .checkpoints
            .iter()
            .map(|cp| (cp.id.as_str(), cp))
            .collect();
        let new_checkpoints: BTreeMap<_, _> = new_scenario
            .checkpoints
            .iter()
            .map(|cp| (cp.id.as_str(), cp))
            .collect();
        for checkpoint_id in old_checkpoints.keys() {
            if !new_checkpoints.contains_key(checkpoint_id) {
                changes.push(change(
                    ReportChangeKind::CheckpointRemoved,
                    id,
                    Some(checkpoint_id),
                    "checkpoint removed",
                ));
            }
        }
        for checkpoint_id in new_checkpoints.keys() {
            if !old_checkpoints.contains_key(checkpoint_id) {
                changes.push(change(
                    ReportChangeKind::CheckpointAdded,
                    id,
                    Some(checkpoint_id),
                    "checkpoint added",
                ));
            }
        }
        for (checkpoint_id, new_cp) in &new_checkpoints {
            let Some(old_cp) = old_checkpoints.get(checkpoint_id) else {
                continue;
            };
            if old_cp.name != new_cp.name || old_cp.time_ns != new_cp.time_ns {
                changes.push(change(
                    ReportChangeKind::CheckpointMetadataChanged,
                    id,
                    Some(checkpoint_id),
                    "checkpoint name or simulated time changed",
                ));
            }
            let (pixels_changed, scene_changed) = content_changed(old_cp, new_cp)?;
            if pixels_changed {
                changes.push(change(
                    ReportChangeKind::PixelsChanged,
                    id,
                    Some(checkpoint_id),
                    "rendered PNG changed",
                ));
            }
            if scene_changed {
                changes.push(change(
                    ReportChangeKind::SceneChanged,
                    id,
                    Some(checkpoint_id),
                    "serialized scene capture changed",
                ));
            }
        }
    }
    Ok(changes)
}

fn change(
    kind: ReportChangeKind,
    scenario_id: &str,
    checkpoint_id: Option<&str>,
    detail: &str,
) -> ReportChange {
    ReportChange {
        kind,
        scenario_id: scenario_id.to_owned(),
        checkpoint_id: checkpoint_id.map(str::to_owned),
        detail: detail.to_owned(),
    }
}

impl std::fmt::Display for ReportChange {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if let Some(checkpoint_id) = &self.checkpoint_id {
            write!(
                formatter,
                "{} {}/{}: {}",
                self.kind, self.scenario_id, checkpoint_id, self.detail
            )
        } else {
            write!(
                formatter,
                "{} {}: {}",
                self.kind, self.scenario_id, self.detail
            )
        }
    }
}

impl std::fmt::Display for ReportChangeKind {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        formatter.write_str(match self {
            Self::ScenarioAdded => "scenario_added",
            Self::ScenarioRemoved => "scenario_removed",
            Self::ScenarioMetadataChanged => "scenario_metadata_changed",
            Self::CheckpointAdded => "checkpoint_added",
            Self::CheckpointRemoved => "checkpoint_removed",
            Self::CheckpointMetadataChanged => "checkpoint_metadata_changed",
            Self::PixelsChanged => "pixels_changed",
            Self::SceneChanged => "scene_changed",
        })
    }
}

/// Marks exact RGBA differences in red over the current frame composited on a checkerboard.
pub fn diff_images(before: &image::RgbaImage, current: &image::RgbaImage) -> image::RgbaImage {
    crate::compare_images(before, current, crate::DiffMode::Exact).image
}

fn save_png(path: &Path, image: &image::RgbaImage) -> Result<()> {
    image
        .save_with_format(path, image::ImageFormat::Png)
        .with_context(|| format!("writing {}", path.display()))
}

fn read_image(path: &Path) -> Result<image::RgbaImage> {
    const MAX_RGBA_BYTES: u64 = 128 * 1024 * 1024;
    let mut reader = image::ImageReader::open(path)
        .with_context(|| format!("opening report image {}", path.display()))?;
    reader.set_format(image::ImageFormat::Png);
    let mut limits = image::Limits::default();
    limits.max_alloc = Some(MAX_RGBA_BYTES);
    reader.limits(limits);
    let decoded = reader
        .decode()
        .with_context(|| format!("decoding report image {}", path.display()))?;
    let (width, height) = (decoded.width(), decoded.height());
    ensure!(
        u64::from(width) * u64::from(height) * 4 <= MAX_RGBA_BYTES,
        "decoded RGBA image exceeds 128 MiB: {}",
        path.display()
    );
    Ok(decoded.to_rgba8())
}

fn read_capture(path: &Path) -> Result<gpui::SceneCapture> {
    let capture: gpui::SceneCapture = serde_json::from_slice(&read_scene_json(path)?)
        .with_context(|| format!("parsing scene capture {}", path.display()))?;
    capture
        .validate()
        .with_context(|| format!("validating scene capture {}", path.display()))?;
    Ok(capture)
}

fn gzip_scene_json(bytes: &[u8]) -> Result<Vec<u8>> {
    ensure!(
        bytes.len() <= MAX_DECOMPRESSED_SCENE_BYTES,
        "scene capture exceeds 12 MiB before compression"
    );
    let mut encoder = GzBuilder::new()
        .mtime(0)
        .write(Vec::new(), Compression::fast());
    encoder
        .write_all(bytes)
        .context("compressing scene capture")?;
    let compressed = encoder
        .finish()
        .context("finishing compressed scene capture")?;
    ensure!(
        compressed.len() as u64 <= MAX_COMPRESSED_SCENE_BYTES,
        "compressed scene capture exceeds 12 MiB"
    );
    Ok(compressed)
}

fn read_scene_json(path: &Path) -> Result<Vec<u8>> {
    let compressed = path.extension().is_some_and(|extension| extension == "gz");
    let limit = if compressed {
        MAX_COMPRESSED_SCENE_BYTES
    } else {
        MAX_DECOMPRESSED_SCENE_BYTES as u64
    };
    if compressed {
        ensure!(
            path.metadata()?.len() <= limit,
            "compressed scene capture exceeds 12 MiB: {}",
            path.display()
        );
    } else {
        ensure!(
            path.metadata()?.len() <= limit,
            "scene capture exceeds 12 MiB: {}",
            path.display()
        );
    }
    let mut bounded_file = fs::File::open(path)
        .with_context(|| format!("reading {}", path.display()))?
        .take(limit + 1);
    let mut bytes = Vec::new();
    bounded_file
        .read_to_end(&mut bytes)
        .with_context(|| format!("reading {}", path.display()))?;
    ensure!(
        bytes.len() as u64 <= limit,
        "scene artifact exceeds 12 MiB: {}",
        path.display()
    );
    if compressed {
        ensure!(
            bytes.len() as u64 <= MAX_COMPRESSED_SCENE_BYTES,
            "compressed scene capture exceeds 12 MiB: {}",
            path.display()
        );
        let decoder = MultiGzDecoder::new(bytes.as_slice());
        let mut bounded = decoder.take((MAX_DECOMPRESSED_SCENE_BYTES + 1) as u64);
        let mut decoded = Vec::new();
        bounded
            .read_to_end(&mut decoded)
            .with_context(|| format!("decompressing scene capture {}", path.display()))?;
        ensure!(
            decoded.len() <= MAX_DECOMPRESSED_SCENE_BYTES,
            "decompressed scene capture exceeds 12 MiB: {}",
            path.display()
        );
        Ok(decoded)
    } else {
        Ok(bytes)
    }
}

fn read_limited_file(path: &Path, max_bytes: u64) -> Result<Vec<u8>> {
    ensure!(
        path.metadata()?.len() <= max_bytes,
        "file exceeds {} MiB: {}",
        max_bytes / (1024 * 1024),
        path.display()
    );
    let mut file = fs::File::open(path)?.take(max_bytes + 1);
    let mut bytes = Vec::new();
    file.read_to_end(&mut bytes)?;
    ensure!(
        bytes.len() as u64 <= max_bytes,
        "file exceeds {} MiB: {}",
        max_bytes / (1024 * 1024),
        path.display()
    );
    Ok(bytes)
}

#[cfg(test)]
mod tests {
    use super::diff_images;
    use image::{Rgba, RgbaImage};

    #[test]
    fn exact_diff_keeps_context_and_marks_transparent_resize_regions() {
        let before = RgbaImage::from_pixel(2, 1, Rgba([90, 120, 150, 255]));
        let mut current = RgbaImage::new(3, 1);
        current.put_pixel(0, 0, before[(0, 0)]);
        current.put_pixel(1, 0, Rgba([91, 120, 150, 255]));
        let diff = diff_images(&before, &current);
        assert_eq!(diff[(0, 0)], before[(0, 0)], "unchanged context");
        assert_eq!(diff[(1, 0)], Rgba([255, 32, 32, 255]), "one-channel change");
        assert_eq!(
            diff[(2, 0)],
            Rgba([255, 32, 32, 255]),
            "new transparent area"
        );
        assert_eq!(
            diff_images(&current, &before)[(2, 0)],
            diff[(2, 0)],
            "removed transparent area"
        );
    }
}
