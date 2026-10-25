//! Incremental staging, deduplication, and atomic publication.
use super::*;

mod scenario;

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
}
