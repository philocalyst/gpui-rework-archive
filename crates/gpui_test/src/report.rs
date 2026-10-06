use crate::{RenderedSuite, ScenarioMetrics, Viewport, validate_id};
use anyhow::{Context, Result, ensure};
use plotters::prelude::*;
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, BTreeSet, HashSet},
    fs,
    io::Cursor,
    path::{Path, PathBuf},
};

/// Optional output settings for a capture report.
#[derive(Clone, Debug, Default)]
pub struct ReportOptions {
    /// Existing baseline directory. Files follow `<scenario>/<checkpoint>.png`.
    pub baseline_dir: Option<PathBuf>,
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
    /// Rendered PNG bytes changed.
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
            fs::write(&scene_path, serde_json::to_vec_pretty(&checkpoint.capture)?)
                .with_context(|| format!("writing {}", scene_path.display()))?;
            let png_path = dir.join(&png_file);
            save_png(&png_path, &checkpoint.image)?;
            let previous_checkpoint = previous_scenario.and_then(|previous| {
                previous
                    .checkpoints
                    .iter()
                    .find(|item| item.id == checkpoint.id)
            });
            let baseline_image_path = previous_checkpoint
                .map(|previous| options.baseline_dir.as_ref().unwrap().join(&previous.png));
            let (pixels_changed, scene_changed) = if let Some(previous) = previous_checkpoint {
                let old_image_path = options.baseline_dir.as_ref().unwrap().join(&previous.png);
                let old_image = read_image(&old_image_path)?;
                let old_scene_path = options
                    .baseline_dir
                    .as_ref()
                    .unwrap()
                    .join(&previous.scene_json);
                let old_scene = read_json_value(&old_scene_path)?;
                let current_scene = read_json_value(&scene_path)?;
                (
                    Some(old_image != checkpoint.image),
                    Some(old_scene != current_scene),
                )
            } else {
                (None, None)
            };
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
                && let Some(baseline_path) = baseline_image_path
            {
                let before_file = format!("{}.before.png", checkpoint.id);
                let diff_file = format!("{}.diff.png", checkpoint.id);
                fs::copy(&baseline_path, dir.join(&before_file))
                    .with_context(|| format!("copying baseline {}", baseline_path.display()))?;
                let before = image::open(&baseline_path)
                    .with_context(|| format!("opening baseline {}", baseline_path.display()))?
                    .to_rgba8();
                let diff = diff_images(&before, &checkpoint.image);
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
    let manifest = ReportManifest {
        schema_version: 1,
        backend: "cpu".into(),
        environment: EnvironmentManifest {
            renderer: "gpui-ce-cpu".into(),
            font_pack: "bundled".into(),
            git_sha: option_env!("GIT_SHA").map(str::to_owned),
        },
        scenarios,
        changes: Vec::new(),
    };
    let manifest_path = output_dir.join("manifest.json");
    fs::write(&manifest_path, serde_json::to_vec_pretty(&manifest)?)?;
    let mut manifest = manifest;
    if let Some(baseline_dir) = &options.baseline_dir {
        manifest.changes = compare_reports(baseline_dir, output_dir)?;
    }
    fs::write(&manifest_path, serde_json::to_vec_pretty(&manifest)?)?;
    write_markdown(suite, &manifest, output_dir)?;
    write_svg(suite, output_dir)?;
    write_html(suite, &manifest, output_dir)?;
    Ok(manifest)
}

/// Reads and validates a suite manifest from an output directory.
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
            scenario.viewport.width > 0 && scenario.viewport.height > 0,
            "scenario viewport dimensions must be positive"
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
            let report_root = report_dir.as_ref();
            read_image(&report_root.join(&checkpoint.png))?;
            read_json_value(&report_root.join(&checkpoint.scene_json))?;
            if let Some(path) = &checkpoint.before_png {
                read_image(&report_root.join(path))?;
            }
            if let Some(path) = &checkpoint.diff_png {
                read_image(&report_root.join(path))?;
            }
        }
    }
    Ok(manifest)
}

/// Compares two report directories. Any scenario/checkpoint addition, removal, metadata,
/// serialized-scene, or exact PNG change is returned as a human-readable entry.
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
    for id in selected_ids {
        validate_id(id)?;
    }
    let baseline = read_manifest(baseline_dir)?;
    let current = read_manifest(current_dir)?;
    let old_scenarios: BTreeMap<_, _> = baseline
        .scenarios
        .iter()
        .filter(|scenario| selected_ids.is_empty() || selected_ids.contains(&scenario.id))
        .map(|scenario| (scenario.id.as_str(), scenario))
        .collect();
    let new_scenarios: BTreeMap<_, _> = current
        .scenarios
        .iter()
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
            let old_png = baseline_dir.join(&old_checkpoints[checkpoint_id].png);
            let new_png = current_dir.join(&new_cp.png);
            if read_image(&old_png)? != read_image(&new_png)? {
                changes.push(change(
                    ReportChangeKind::PixelsChanged,
                    id,
                    Some(checkpoint_id),
                    "rendered PNG changed",
                ));
            }
            let old_scene = baseline_dir.join(&old_checkpoints[checkpoint_id].scene_json);
            let new_scene = current_dir.join(&new_cp.scene_json);
            if read_json_value(&old_scene)? != read_json_value(&new_scene)? {
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

/// Builds a red overlay image: unchanged pixels are dark and changed pixels are red.
pub fn diff_images(before: &image::RgbaImage, current: &image::RgbaImage) -> image::RgbaImage {
    let width = before.width().max(current.width());
    let height = before.height().max(current.height());
    let mut diff = image::RgbaImage::new(width, height);
    for y in 0..height {
        for x in 0..width {
            let a = before
                .get_pixel_checked(x, y)
                .copied()
                .unwrap_or(image::Rgba([0, 0, 0, 0]));
            let b = current
                .get_pixel_checked(x, y)
                .copied()
                .unwrap_or(image::Rgba([0, 0, 0, 0]));
            let delta = (0..4)
                .map(|channel| a[channel].abs_diff(b[channel]))
                .max()
                .unwrap_or(0);
            diff.put_pixel(
                x,
                y,
                if delta == 0 {
                    image::Rgba([24, 24, 24, 255])
                } else {
                    image::Rgba([255, 32, 32, 255])
                },
            );
        }
    }
    diff
}

fn save_png(path: &Path, image: &image::RgbaImage) -> Result<()> {
    let mut bytes = Cursor::new(Vec::new());
    image::DynamicImage::ImageRgba8(image.clone()).write_to(&mut bytes, image::ImageFormat::Png)?;
    fs::write(path, bytes.into_inner()).with_context(|| format!("writing {}", path.display()))?;
    Ok(())
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

fn write_markdown(
    suite: &RenderedSuite,
    manifest: &ReportManifest,
    output_dir: &Path,
) -> Result<()> {
    let mut md = String::from(
        "# GPUI visual scenario report\n\nBackend: CPU\n\n| Scenario | Checkpoint | Time (ns) | Scene build p50/p95/p99 (ns) | CPU render p50/p95/p99 (ns) | Primitives | Batches | Bitmap bytes |\n|---|---|---:|---:|---:|---:|---:|---:|\n",
    );
    for scenario in &suite.scenarios {
        for checkpoint in &scenario.checkpoints {
            let m = &checkpoint.metrics;
            md.push_str(&format!(
                "| {} | {} | {} | {} / {} / {} | {} / {} / {} | {} | {} | {} |\n",
                scenario.title,
                checkpoint.name,
                checkpoint.time_ns,
                m.scene_build_p50_ns,
                m.scene_build_p95_ns,
                m.scene_build_p99_ns,
                m.cpu_render_p50_ns,
                m.cpu_render_p95_ns,
                m.cpu_render_p99_ns,
                m.primitive_count,
                m.batch_count,
                m.bitmap_storage_bytes
            ));
        }
    }
    md.push_str("\n## Baseline changes\n\n");
    if manifest.changes.is_empty() {
        md.push_str("No scenario or checkpoint changes.\n");
    } else {
        for change in &manifest.changes {
            md.push_str(&format!("- {}\n", change));
        }
    }
    fs::write(output_dir.join("report.md"), md)?;
    Ok(())
}

fn write_svg(suite: &RenderedSuite, output_dir: &Path) -> Result<()> {
    let path = output_dir.join("metrics.svg");
    let root = SVGBackend::new(&path, (960, 520)).into_drawing_area();
    root.fill(&WHITE).map_err(plot_err)?;
    let values: Vec<_> = suite
        .scenarios
        .iter()
        .flat_map(|scenario| {
            scenario.checkpoints.iter().map(move |c| {
                (
                    format!("{} / {}", scenario.id, c.id),
                    c.metrics.scene_build_p50_ns,
                    c.metrics.cpu_render_p50_ns,
                )
            })
        })
        .collect();
    let max = values
        .iter()
        .map(|v| v.1.max(v.2))
        .max()
        .unwrap_or(1)
        .max(1);
    let rows = values.len().max(1) * 2;
    let mut chart = ChartBuilder::on(&root)
        .caption("Scenario frame timings (nanoseconds)", ("sans-serif", 24))
        .margin(18)
        .x_label_area_size(48)
        .y_label_area_size(120)
        .build_cartesian_2d(0u64..max.saturating_add(max / 10 + 1), 0usize..rows)
        .map_err(plot_err)?;
    chart
        .configure_mesh()
        .y_labels(values.len())
        .y_label_formatter(&|idx| {
            values
                .get(*idx / 2)
                .map(|value| value.0.clone())
                .unwrap_or_default()
        })
        .x_desc("nanoseconds")
        .disable_mesh()
        .draw()
        .map_err(plot_err)?;
    for (index, (_, scene, cpu)) in values.iter().enumerate() {
        let row = index * 2;
        chart
            .draw_series(std::iter::once(Rectangle::new(
                [(0, row), (*scene, row + 1)],
                BLUE.mix(0.75).filled(),
            )))
            .map_err(plot_err)?;
        chart
            .draw_series(std::iter::once(Rectangle::new(
                [(0, row + 1), (*cpu, row + 2)],
                RED.mix(0.7).filled(),
            )))
            .map_err(plot_err)?;
    }
    root.present().map_err(plot_err)?;
    Ok(())
}

fn write_html(suite: &RenderedSuite, manifest: &ReportManifest, output_dir: &Path) -> Result<()> {
    let mut html = String::from(
        "<!doctype html><meta charset=\"utf-8\"><title>GPUI scenario report</title><style>body{font:15px system-ui;margin:2rem;background:#111;color:#eee}section{margin:2rem 0}img{max-width:100%;border:1px solid #555}figure{display:inline-block;vertical-align:top;width:min(48%,700px);margin:0 1% 1rem 0}figcaption{margin:.5rem 0}</style><h1>GPUI scenario report</h1><p><a href=\"manifest.json\">Versioned JSON manifest</a> · <a href=\"report.md\">Markdown metrics</a> · <a href=\"metrics.svg\">Timing plot</a></p>",
    );
    if !manifest.changes.is_empty() {
        html.push_str("<section><h2>Baseline changes</h2><ul>");
        for change in &manifest.changes {
            html.push_str(&format!("<li>{}</li>", escape_html(&change.to_string())));
        }
        html.push_str("</ul></section>");
    }
    for scenario in &suite.scenarios {
        html.push_str(&format!(
            "<section><h2>{}</h2>",
            escape_html(&scenario.title)
        ));
        for checkpoint in &scenario.checkpoints {
            let report_checkpoint = manifest
                .scenarios
                .iter()
                .find(|entry| entry.id == scenario.id)
                .and_then(|entry| {
                    entry
                        .checkpoints
                        .iter()
                        .find(|entry| entry.id == checkpoint.id)
                })
                .context("report manifest is missing a checkpoint")?;
            html.push_str(&format!("<figure><figcaption>{} <small>{}</small></figcaption><a href=\"{}/{}.png\"><img loading=\"lazy\" src=\"{}/{}.png\"></a>", escape_html(&checkpoint.name), status_name(report_checkpoint.status), scenario.id, checkpoint.id, scenario.id, checkpoint.id));
            if let Some(before) = &report_checkpoint.before_png {
                html.push_str(&format!("<a href=\"{before}\"><img loading=\"lazy\" src=\"{before}\" alt=\"Baseline image\"></a>"));
            }
            if let Some(diff) = &report_checkpoint.diff_png {
                html.push_str(&format!("<a href=\"{diff}\"><img loading=\"lazy\" src=\"{diff}\" alt=\"Red pixel difference\"></a>"));
            }
            html.push_str("</figure>");
        }
        html.push_str("</section>");
    }
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
