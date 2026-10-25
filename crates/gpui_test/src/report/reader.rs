//! Validated report loading and duplicate comparison.
use super::*;

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
            if let Some(motion) = &checkpoint.motion {
                ensure!(
                    motion.diff_png.as_deref().is_none_or(|path| {
                        path == format!("{}/{}.motion.diff.png", scenario.id, checkpoint.id)
                    }) && motion.heatmap_png.as_deref().is_none_or(|path| {
                        path == format!("{}/{}.motion.heatmap.png", scenario.id, checkpoint.id)
                    }),
                    "noncanonical transition image paths for {}/{}",
                    scenario.id,
                    checkpoint.id
                );
            }
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

pub(super) fn read_scenario(
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
        if let Some(motion) = &checkpoint.motion {
            for path in [&motion.diff_png, &motion.heatmap_png]
                .into_iter()
                .flatten()
            {
                artifact_path(root, path)?;
            }
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

pub(super) fn scenarios_equal(left: &RenderedScenario, right: &RenderedScenario) -> bool {
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
pub(super) fn identical_stored_scenarios(
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
        if let Some(motion) = &source.motion {
            for path in [&motion.diff_png, &motion.heatmap_png]
                .into_iter()
                .flatten()
            {
                artifact_path(source_root, path)?;
            }
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

pub(super) fn files_equal(left: &Path, right: &Path) -> Result<bool> {
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

pub(super) fn merge_optional_report_value<T: Serialize>(
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
