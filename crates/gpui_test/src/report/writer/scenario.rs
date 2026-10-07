//! Persist a scenario and attach baseline pixel, scene, and motion comparisons.
use super::*;

impl ReportWriter {
    pub(super) fn write_scenario(
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
            let motion = if let (
                Some((previous_baseline_index, previous_before)),
                Some(before),
                Some(baseline_index),
                Some(previous_scenario),
            ) = (
                previous_pair.as_ref(),
                before.as_ref(),
                baseline_index,
                previous_scenario,
            ) && baseline_index == previous_baseline_index + 1
            {
                let previous_current = &scenario.checkpoints[index - 1];
                let previous_baseline = &previous_scenario.checkpoints[*previous_baseline_index];
                let difference = compare_transitions(
                    previous_before,
                    before,
                    &previous_current.image,
                    &checkpoint.image,
                );
                let (diff_png, heatmap_png) = if difference.changed_pixels > 0 {
                    let write_visualization = |mode, suffix| -> Result<String> {
                        let file = format!("{}.motion.{suffix}.png", checkpoint.id);
                        let compared = compare_transition_images(
                            previous_before,
                            before,
                            &previous_current.image,
                            &checkpoint.image,
                            mode,
                        );
                        save_png(&dir.join(&file), &compared.image)?;
                        Ok(format!("{}/{file}", scenario.id))
                    };
                    (
                        Some(write_visualization(DiffMode::Exact, "diff")?),
                        Some(write_visualization(DiffMode::Magnitude, "heatmap")?),
                    )
                } else {
                    (None, None)
                };
                Some(MotionComparison {
                    previous_checkpoint_id: previous_current.id.clone(),
                    before_duration_ns: previous_scenario.checkpoints[baseline_index]
                        .time_ns
                        .checked_sub(previous_baseline.time_ns),
                    current_duration_ns: checkpoint.time_ns.checked_sub(previous_current.time_ns),
                    difference,
                    diff_png,
                    heatmap_png,
                })
            } else {
                None
            };
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
