//! Compare manifests without replaying scenes.
use super::*;

/// Compares every scenario and checkpoint in two saved report directories.
///
/// The directories must contain readable manifests and referenced image and scene
/// artifacts. Missing or malformed artifacts return an error.
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
pub(super) fn compare_manifests(
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

pub(super) fn change(
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
