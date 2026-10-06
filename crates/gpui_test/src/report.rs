use crate::{RenderedSuite, ScenarioMetrics, Viewport, validate_id};
use anyhow::{Context, Result, ensure};
use plotters::prelude::*;
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, BTreeSet, HashSet},
    fs,
    path::{Path, PathBuf},
};

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
    /// Scenarios and checkpoint artifacts in stable order.
    pub scenarios: Vec<ScenarioManifest>,
    /// Complete comparison results for the selected baseline, including removed items.
    #[serde(default)]
    pub changes: Vec<ReportChange>,
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
    /// GPU memory measurement. Null for the CPU-only backend.
    pub gpu_memory_bytes: Option<u64>,
    /// Baseline comparison outcome for this scenario.
    pub status: ReportStatus,
    /// Checkpoint captures in timeline order.
    pub checkpoints: Vec<CheckpointManifest>,
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
    /// CPU-side timing, primitive, batch, and bitmap metrics.
    pub metrics: ScenarioMetrics,
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
/// The portable scene and rendered image remain as typed values until this function is called.
pub fn write_report(
    suite: &RenderedSuite,
    output_dir: impl AsRef<Path>,
    options: ReportOptions,
) -> Result<ReportManifest> {
    let output_dir = output_dir.as_ref();
    fs::create_dir_all(output_dir)
        .with_context(|| format!("creating report directory {}", output_dir.display()))?;
    let baseline_manifest = if let Some(baseline_dir) = &options.baseline_dir {
        let output_canonical = output_dir.canonicalize()?;
        let baseline_canonical = baseline_dir
            .canonicalize()
            .with_context(|| format!("opening baseline directory {}", baseline_dir.display()))?;
        ensure!(
            output_canonical != baseline_canonical
                && !output_canonical.starts_with(&baseline_canonical)
                && !baseline_canonical.starts_with(&output_canonical),
            "output and baseline directories must not contain one another"
        );
        Some(read_manifest(baseline_dir)?)
    } else {
        None
    };
    let mut scenario_ids = HashSet::new();
    let mut scenarios = Vec::with_capacity(suite.scenarios.len());
    for scenario in &suite.scenarios {
        validate_id(&scenario.id)?;
        ensure!(
            scenario_ids.insert(&scenario.id),
            "duplicate scenario id: {}",
            scenario.id
        );
        let previous_scenario = baseline_manifest.as_ref().and_then(|manifest| {
            manifest
                .scenarios
                .iter()
                .find(|previous| previous.id == scenario.id)
        });
        let scenario_metadata_changed = previous_scenario.map(|previous| {
            previous.title != scenario.title
                || previous.viewport.width != scenario.viewport.width
                || previous.viewport.height != scenario.viewport.height
                || previous.viewport.scale_factor != scenario.viewport.scale_factor
        });
        let dir = output_dir.join(&scenario.id);
        fs::create_dir_all(&dir)
            .with_context(|| format!("creating scenario directory {}", dir.display()))?;
        let mut checkpoints = Vec::with_capacity(scenario.checkpoints.len());
        let mut checkpoint_ids = HashSet::new();
        for checkpoint in &scenario.checkpoints {
            validate_id(&checkpoint.id)?;
            ensure!(
                checkpoint_ids.insert(&checkpoint.id),
                "duplicate checkpoint id in {}: {}",
                scenario.id,
                checkpoint.id
            );
            let scene_file = format!("{}.scene.json", checkpoint.id);
            let png_file = format!("{}.png", checkpoint.id);
            let scene_path = dir.join(&scene_file);
            let scene_bytes = serde_json::to_vec_pretty(&checkpoint.capture)?;
            fs::write(&scene_path, &scene_bytes)
                .with_context(|| format!("writing {}", scene_path.display()))?;
            let png_path = dir.join(&png_file);
            save_png(&png_path, &checkpoint.image)?;
            let previous_checkpoint = previous_scenario.and_then(|previous| {
                previous
                    .checkpoints
                    .iter()
                    .find(|item| item.id == checkpoint.id)
            });
            let previous_assets = previous_checkpoint.zip(options.baseline_dir.as_deref());
            let before = previous_assets
                .map(|(previous, root)| read_image(&root.join(&previous.png)))
                .transpose()?;
            let pixels_changed = before.as_ref().map(|image| image != &checkpoint.image);
            let scene_changed = previous_assets
                .map(|(previous, root)| -> Result<bool> {
                    // Compare the persisted values: to_value widens f32 numbers
                    // differently from the JSON serializer used by capture files.
                    Ok(read_json_value(&root.join(&previous.scene_json))?
                        != serde_json::from_slice::<serde_json::Value>(&scene_bytes)?)
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
            let (before_png, diff_png) = if pixels_changed == Some(true)
                && let Some(before) = &before
            {
                let before_file = format!("{}.before.png", checkpoint.id);
                let diff_file = format!("{}.diff.png", checkpoint.id);
                save_png(&dir.join(&before_file), before)?;
                let diff = diff_images(before, &checkpoint.image);
                save_png(&dir.join(&diff_file), &diff)?;
                (
                    Some(format!("{}/{}", scenario.id, before_file)),
                    Some(format!("{}/{}", scenario.id, diff_file)),
                )
            } else {
                (None, None)
            };
            checkpoints.push(CheckpointManifest {
                id: checkpoint.id.clone(),
                name: checkpoint.name.clone(),
                time_ns: checkpoint.time_ns,
                scene_json: format!("{}/{}", scenario.id, scene_file),
                png: format!("{}/{}", scenario.id, png_file),
                before_png,
                diff_png,
                status,
                pixels_changed,
                scene_changed,
                metadata_changed,
                metrics: checkpoint.metrics.clone(),
            });
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
        scenarios.push(ScenarioManifest {
            id: scenario.id.clone(),
            title: scenario.title.clone(),
            viewport: scenario.viewport.clone(),
            gpu_memory_bytes: None,
            status,
            checkpoints,
        });
    }
    let mut manifest = ReportManifest {
        schema_version: 1,
        backend: "cpu".into(),
        environment: EnvironmentManifest {
            renderer: "gpui-ce-cpu".into(),
            font_pack: suite
                .scenarios
                .iter()
                .map(|scenario| scenario.font_pack.as_str())
                .collect::<BTreeSet<_>>()
                .into_iter()
                .collect::<Vec<_>>()
                .join(", "),
            git_sha: option_env!("GIT_SHA").map(str::to_owned),
        },
        scenarios,
        changes: Vec::new(),
    };
    if let Some(baseline) = &baseline_manifest {
        // Comparisons were measured while writing each checkpoint. Reuse those facts
        // instead of writing, decoding, and comparing the entire report a second time.
        manifest.changes =
            compare_manifests(baseline, &manifest, &options.selected_ids, |_, current| {
                Ok((
                    current
                        .pixels_changed
                        .context("matched checkpoint has pixel comparison")?,
                    current
                        .scene_changed
                        .context("matched checkpoint has scene comparison")?,
                ))
            })?;
    }
    fs::write(
        output_dir.join("manifest.json"),
        serde_json::to_vec_pretty(&manifest)?,
    )?;
    write_markdown(&manifest, output_dir)?;
    write_svg(&manifest, output_dir)?;
    write_html(&manifest, output_dir)?;
    Ok(manifest)
}

/// Reads a suite manifest and validates its schema, viewport, identifiers, and artifact paths.
/// Images and scene values are loaded only when a comparison needs them.
pub fn read_manifest(report_dir: impl AsRef<Path>) -> Result<ReportManifest> {
    let path = report_dir.as_ref().join("manifest.json");
    let manifest: ReportManifest = serde_json::from_slice(
        &fs::read(&path).with_context(|| format!("reading {}", path.display()))?,
    )?;
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
                checkpoint.scene_json == format!("{}/{}.scene.json", scenario.id, checkpoint.id)
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
                }),
                "noncanonical comparison image paths for {}/{}",
                scenario.id,
                checkpoint.id
            );
        }
    }
    Ok(manifest)
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
    let baseline_dir = baseline_dir.as_ref();
    let current_dir = current_dir.as_ref();
    let baseline = read_manifest(baseline_dir)?;
    let current = read_manifest(current_dir)?;
    compare_manifests(&baseline, &current, selected_ids, |old, new| {
        Ok((
            read_image(&baseline_dir.join(&old.png))? != read_image(&current_dir.join(&new.png))?,
            read_json_value(&baseline_dir.join(&old.scene_json))?
                != read_json_value(&current_dir.join(&new.scene_json))?,
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
        if old_scenario.title != new_scenario.title
            || old_scenario.viewport.width != new_scenario.viewport.width
            || old_scenario.viewport.height != new_scenario.viewport.height
            || old_scenario.viewport.scale_factor != new_scenario.viewport.scale_factor
        {
            changes.push(change(
                ReportChangeKind::ScenarioMetadataChanged,
                id,
                None,
                "scenario title or viewport changed",
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

/// Highlights changed pixels and resized regions in red over a dimmed current frame.
pub fn diff_images(before: &image::RgbaImage, current: &image::RgbaImage) -> image::RgbaImage {
    let width = before.width().max(current.width());
    let height = before.height().max(current.height());
    let mut diff = image::RgbaImage::new(width, height);
    for y in 0..height {
        for x in 0..width {
            let a = before.get_pixel_checked(x, y);
            let b = current.get_pixel_checked(x, y);
            diff.put_pixel(
                x,
                y,
                if a == b {
                    let pixel = b.copied().unwrap_or(image::Rgba([0; 4]));
                    image::Rgba([pixel[0] / 3, pixel[1] / 3, pixel[2] / 3, 255])
                } else {
                    image::Rgba([255, 32, 32, 255])
                },
            );
        }
    }
    diff
}

fn save_png(path: &Path, image: &image::RgbaImage) -> Result<()> {
    image
        .save_with_format(path, image::ImageFormat::Png)
        .with_context(|| format!("writing {}", path.display()))
}

fn read_image(path: &Path) -> Result<image::RgbaImage> {
    image::open(path)
        .map(|image| image.to_rgba8())
        .with_context(|| format!("reading baseline image {}", path.display()))
}

fn read_json_value(path: &Path) -> Result<serde_json::Value> {
    serde_json::from_slice(&fs::read(path).with_context(|| format!("reading {}", path.display()))?)
        .with_context(|| format!("parsing scene capture {}", path.display()))
}

fn write_markdown(manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let mut md = String::from(
        "# GPUI visual scenario report\n\nBackend: CPU. VRAM is unavailable for this backend; bitmap bytes measure captured atlas storage. Timings exclude font setup, capture serialization, and PNG encoding.\n\n| Scenario / checkpoint | Time (ms) | Samples | Build p50/p95/p99 (ms) | Replay p50/p95/p99 (ms) | Primitives | Batches | Bitmap bytes | VRAM | Status |\n|---|---:|---:|---:|---:|---:|---:|---:|---|---|\n",
    );
    for scenario in &manifest.scenarios {
        for checkpoint in &scenario.checkpoints {
            let m = &checkpoint.metrics;
            let title = format!("{} / {}", scenario.title, checkpoint.name)
                .replace('|', "\\|")
                .replace(['\n', '\r'], " ");
            md.push_str(&format!(
                "| [{}]({}) | {:.3} | {} | {} | {} | {} | {} | {} | n/a | {} |\n",
                title,
                checkpoint.png,
                checkpoint.time_ns as f64 / 1_000_000.0,
                m.frame_count,
                timing_triplet(
                    m.scene_build_p50_ns,
                    m.scene_build_p95_ns,
                    m.scene_build_p99_ns
                ),
                timing_triplet(
                    m.cpu_render_p50_ns,
                    m.cpu_render_p95_ns,
                    m.cpu_render_p99_ns
                ),
                m.primitive_count,
                m.batch_count,
                m.bitmap_storage_bytes,
                status_name(checkpoint.status),
            ));
        }
    }
    md.push_str("\n![Frame timings](metrics.svg)\n\n## Baseline changes\n\n");
    if !manifest.changes.is_empty() {
        for change in &manifest.changes {
            md.push_str(&format!("- {}\n", change));
        }
    } else if manifest
        .scenarios
        .iter()
        .all(|scenario| scenario.status == ReportStatus::BaselineUnavailable)
    {
        md.push_str("No baseline was supplied.\n");
    } else {
        md.push_str("No scenario or checkpoint changes.\n");
    }
    fs::write(output_dir.join("report.md"), md)?;
    Ok(())
}

fn timing_triplet(p50: u64, p95: u64, p99: u64) -> String {
    format!(
        "{:.3} / {:.3} / {:.3}",
        p50 as f64 / 1_000_000.0,
        p95 as f64 / 1_000_000.0,
        p99 as f64 / 1_000_000.0
    )
}

fn write_svg(manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let values: Vec<_> = manifest
        .scenarios
        .iter()
        .flat_map(|scenario| {
            scenario.checkpoints.iter().map(move |checkpoint| {
                (
                    format!("{} / {}", scenario.id, checkpoint.id),
                    checkpoint.metrics.scene_build_p50_ns,
                    checkpoint.metrics.cpu_render_p50_ns,
                )
            })
        })
        .collect();
    let path = output_dir.join("metrics.svg");
    let height = 140 + values.len().max(1) as u32 * 36;
    let root = SVGBackend::new(&path, (1100, height)).into_drawing_area();
    root.fill(&WHITE).map_err(plot_err)?;
    let max = values
        .iter()
        .map(|value| value.1.max(value.2))
        .max()
        .unwrap_or(1)
        .max(1);
    let rows = values.len().max(1) * 2;
    let mut chart = ChartBuilder::on(&root)
        .caption("Median frame work by checkpoint", ("sans-serif", 24))
        .margin(18)
        .x_label_area_size(48)
        .y_label_area_size(300)
        .build_cartesian_2d(
            0u64..max.saturating_add(max / 10 + 1),
            (0usize..rows).with_key_points((0..values.len()).map(|index| index * 2 + 1).collect()),
        )
        .map_err(plot_err)?;
    chart
        .configure_mesh()
        .y_labels(values.len())
        .y_label_formatter(&|index| {
            values
                .get(*index / 2)
                .map(|value| value.0.clone())
                .unwrap_or_default()
        })
        .x_desc("milliseconds")
        .x_label_formatter(&|ns| format!("{:.1}", *ns as f64 / 1_000_000.0))
        .disable_mesh()
        .draw()
        .map_err(plot_err)?;
    for (index, (_, build, replay)) in values.iter().enumerate() {
        let row = index * 2;
        let build_bar = chart
            .draw_series(std::iter::once(Rectangle::new(
                [(0, row), (*build, row + 1)],
                BLUE.mix(0.75).filled(),
            )))
            .map_err(plot_err)?;
        if index == 0 {
            build_bar.label("Scene build").legend(|(x, y)| {
                Rectangle::new([(x, y - 4), (x + 16, y + 4)], BLUE.mix(0.75).filled())
            });
        }
        let replay_bar = chart
            .draw_series(std::iter::once(Rectangle::new(
                [(0, row + 1), (*replay, row + 2)],
                RED.mix(0.7).filled(),
            )))
            .map_err(plot_err)?;
        if index == 0 {
            replay_bar.label("CPU replay").legend(|(x, y)| {
                Rectangle::new([(x, y - 4), (x + 16, y + 4)], RED.mix(0.7).filled())
            });
        }
    }
    chart
        .configure_series_labels()
        .background_style(WHITE.mix(0.9))
        .border_style(BLACK)
        .draw()
        .map_err(plot_err)?;
    root.present().map_err(plot_err)?;
    Ok(())
}

fn write_html(manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let mut html = String::from(
        r#"<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>GPUI scenario report</title>
  <style>
    body { font: 15px system-ui; line-height: 1.5; max-width: 1200px;
           margin: 2rem; background: #111; color: #eee; }
    nav a { display: inline-block; margin: 0 1rem .5rem 0; }
    a { color: #8cc8ff; }
    section { margin: 2rem 0; }
    img { max-width: 100%; height: auto; border: 1px solid #555; }
    .images { display: grid; gap: 1rem;
              grid-template-columns: repeat(auto-fit, minmax(min(100%, 280px), 1fr)); }
    figure { margin: 0 0 1rem; }
    figcaption { margin: .5rem 0; }
  </style>
</head>
<body>
  <h1>GPUI scenario report</h1>
  <p><a href="manifest.json">JSON manifest</a> · <a href="report.md">Markdown metrics</a></p>
  <img src="metrics.svg" alt="Scene build and CPU replay timings">
"#,
    );
    html.push_str("<nav aria-label=\"Scenarios\">");
    for scenario in &manifest.scenarios {
        html.push_str(&format!(
            "<a href=\"#{}\">{}</a>",
            scenario.id,
            escape_html(&scenario.title)
        ));
    }
    html.push_str("</nav>");
    if !manifest.changes.is_empty() {
        html.push_str("<section><h2>Baseline changes</h2><ul>");
        for change in &manifest.changes {
            html.push_str(&format!("<li>{}</li>", escape_html(&change.to_string())));
        }
        html.push_str("</ul></section>");
    }
    for scenario in &manifest.scenarios {
        html.push_str(&format!(
            "<section id=\"{}\"><h2>{}</h2>",
            scenario.id,
            escape_html(&scenario.title)
        ));
        for checkpoint in &scenario.checkpoints {
            html.push_str(&format!(
                "<h3>{} · {:.1} ms · {}</h3><p><a href=\"{}\">Captured scene JSON</a></p>",
                escape_html(&checkpoint.name),
                checkpoint.time_ns as f64 / 1_000_000.0,
                status_name(checkpoint.status),
                checkpoint.scene_json
            ));
            html.push_str("<div class=\"images\">");
            let images = [
                ("Before", checkpoint.before_png.as_deref()),
                ("Current", Some(checkpoint.png.as_str())),
                ("Changes in red", checkpoint.diff_png.as_deref()),
            ];
            for (label, path) in images {
                if let Some(path) = path {
                    html.push_str(&format!("<figure><figcaption>{label}</figcaption><a href=\"{path}\"><img loading=\"lazy\" src=\"{path}\" alt=\"{label}\"></a></figure>"));
                }
            }
            html.push_str("</div>");
        }
        html.push_str("</section>");
    }
    html.push_str("</body></html>");
    fs::write(output_dir.join("index.html"), html)?;
    Ok(())
}

fn status_name(status: ReportStatus) -> &'static str {
    match status {
        ReportStatus::BaselineUnavailable => "baseline unavailable",
        ReportStatus::New => "new",
        ReportStatus::Unchanged => "unchanged",
        ReportStatus::Changed => "changed",
    }
}

fn escape_html(s: &str) -> String {
    s.replace('&', "&amp;")
        .replace('<', "&lt;")
        .replace('>', "&gt;")
        .replace('"', "&quot;")
        .replace('\'', "&#39;")
}
fn plot_err<E: std::fmt::Debug>(error: E) -> anyhow::Error {
    anyhow::anyhow!("plot error: {error:?}")
}

#[cfg(test)]
mod tests {
    use super::diff_images;
    use image::{Rgba, RgbaImage};

    #[test]
    fn pixel_diff_keeps_context_and_marks_transparent_resize_regions() {
        let before = RgbaImage::from_pixel(2, 1, Rgba([90, 120, 150, 255]));
        let mut current = RgbaImage::new(3, 1);
        current.put_pixel(0, 0, before[(0, 0)]);
        current.put_pixel(1, 0, Rgba([91, 120, 150, 255]));
        let diff = diff_images(&before, &current);
        assert_eq!(diff[(0, 0)], Rgba([30, 40, 50, 255]), "unchanged context");
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
