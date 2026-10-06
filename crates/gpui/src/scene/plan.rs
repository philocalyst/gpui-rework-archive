use super::{AtlasTextureId, BatchIterator, FilterBoundary, Scene};
use serde::{Deserialize, Serialize};
use smallvec::SmallVec;
use std::ops::Range;

/// Nested content-filter groups with dedicated isolation targets; deeper ones render inline.
pub const MAX_FILTER_GROUP_DEPTH: usize = 2;

/// Index of an offscreen texture reserved for an isolated content-filter group.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub struct FilterTargetIndex(usize);

impl FilterTargetIndex {
    /// Returns the index into the renderer's content-filter target pool.
    pub fn as_usize(self) -> usize {
        self.0
    }
}

/// Where the contents of a filter group are rendered.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub enum FilterRenderTarget {
    /// Render directly into the current target once isolation targets are exhausted.
    Inline,
    /// Render into a dedicated offscreen target and composite it into the parent.
    Isolated(FilterTargetIndex),
}

impl FilterRenderTarget {
    fn is_isolated(self) -> bool {
        matches!(self, Self::Isolated(_))
    }
}

/// Resource totals computed while a scene's render plan is compiled.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
#[expect(missing_docs)]
pub struct ScenePlanRequirements {
    pub command_count: usize,
    pub instance_batch_count: usize,
    pub path_rasterization_vertex_count: usize,
    pub path_sprite_count: usize,
    pub surface_count: usize,
    pub backdrop_filter_count: usize,
    pub isolated_filter_count: usize,
    pub isolated_target_count: usize,
    pub uses_path_target: bool,
    pub uses_offscreen_target: bool,
}

/// A compiled scene command stream, built by [`Scene::finish`] and shared by every renderer.
#[derive(Debug, Default)]
pub struct ScenePlan {
    // Retain this allocation across `Scene::clear`/`Scene::finish`; scenes are rebuilt every frame.
    pub(super) commands: Vec<RenderCommand>,
    requirements: ScenePlanRequirements,
    scene_lengths: SceneLengths,
}

impl ScenePlan {
    pub(super) fn clear(&mut self) {
        self.commands.clear();
        self.requirements = ScenePlanRequirements::default();
        self.scene_lengths = SceneLengths::default();
    }

    pub(super) fn build(scene: &Scene, mut commands: Vec<RenderCommand>) -> Self {
        commands.clear();
        commands.reserve(scene.len());
        let mut matched_starts =
            SmallVec::<[bool; 8]>::from_elem(false, scene.filter_boundaries.len());
        let mut pending_starts = SmallVec::<[usize; 4]>::new();
        for (index, boundary) in scene.filter_boundaries.iter().enumerate() {
            if boundary.is_start {
                pending_starts.push(index);
            } else if let Some(start_index) = pending_starts.pop() {
                matched_starts[start_index] = true;
            }
        }

        let mut filter_stack = SmallVec::<[(usize, FilterRenderTarget); 4]>::new();
        let mut isolated_depth = 0;
        let mut requirements = ScenePlanRequirements::default();

        for batch in BatchIterator::new(scene) {
            match batch {
                PrimitiveBatch::FilterBoundary(boundary_index) => {
                    let boundary = &scene.filter_boundaries[boundary_index];
                    if boundary.is_start {
                        let target = if matched_starts[boundary_index]
                            && isolated_depth < MAX_FILTER_GROUP_DEPTH
                        {
                            FilterRenderTarget::Isolated(FilterTargetIndex(isolated_depth))
                        } else {
                            FilterRenderTarget::Inline
                        };
                        if target.is_isolated() {
                            isolated_depth += 1;
                            requirements.uses_offscreen_target = true;
                            requirements.isolated_target_count =
                                requirements.isolated_target_count.max(isolated_depth);
                        }
                        filter_stack.push((boundary_index, target));
                        commands.push(RenderCommand::BeginFilter {
                            boundary_index,
                            target,
                        });
                    } else if let Some((start_index, target)) = filter_stack.pop() {
                        if target.is_isolated() {
                            isolated_depth -= 1;
                            requirements.isolated_filter_count += 1;
                        }
                        commands.push(RenderCommand::EndFilter {
                            boundary_index: start_index,
                            closing_boundary_index: boundary_index,
                            target,
                        });
                    } else {
                        debug_assert!(false, "content-filter end boundary has no matching start");
                        commands.push(RenderCommand::EndFilter {
                            boundary_index,
                            closing_boundary_index: boundary_index,
                            target: FilterRenderTarget::Inline,
                        });
                    }
                }
                batch => {
                    requirements.include_batch(&batch);
                    commands.push(RenderCommand::Batch(batch));
                }
            }
        }

        requirements.command_count = commands.len();
        Self {
            commands,
            requirements,
            scene_lengths: SceneLengths::for_scene(scene),
        }
    }

    /// Restores a serialized command stream after validating every referenced array range and
    /// filter boundary. Unlike `build`, this preserves the original command order and grouping.
    pub(super) fn from_captured_commands(
        scene: &Scene,
        commands: Vec<RenderCommand>,
    ) -> anyhow::Result<Self> {
        use anyhow::{bail, ensure};

        let lengths = SceneLengths::for_scene(scene);
        let mut covered = SceneLengths::default();
        let mut requirements = ScenePlanRequirements::default();
        let mut filter_stack = Vec::<(usize, FilterRenderTarget)>::new();
        let mut boundary_pair_stack = Vec::<usize>::new();
        let mut expected_closing_boundaries = vec![None; lengths.filter_boundaries];
        for (index, boundary) in scene.filter_boundaries.iter().enumerate() {
            if boundary.is_start {
                boundary_pair_stack.push(index);
            } else if let Some(start_index) = boundary_pair_stack.pop() {
                expected_closing_boundaries[start_index] = Some(index);
            }
        }
        let mut seen_boundaries = vec![false; lengths.filter_boundaries];
        let mut isolated_depth = 0;
        for (command_index, command) in commands.iter().enumerate() {
            match command {
                RenderCommand::Batch(batch) => {
                    let (range, count, next, kind) = match batch {
                        PrimitiveBatch::Shadows { range, .. } => (range, lengths.shadows, &mut covered.shadows, "shadow"),
                        PrimitiveBatch::Quads { range, .. } => (range, lengths.quads, &mut covered.quads, "quad"),
                        PrimitiveBatch::Paths { range, .. } => (range, lengths.paths, &mut covered.paths, "path"),
                        PrimitiveBatch::Underlines(range) => (range, lengths.underlines, &mut covered.underlines, "underline"),
                        PrimitiveBatch::MonochromeSprites { range, .. } =>
                            (range, lengths.monochrome_sprites, &mut covered.monochrome_sprites, "monochrome sprite"),
                        PrimitiveBatch::SubpixelSprites { range, .. } =>
                            (range, lengths.subpixel_sprites, &mut covered.subpixel_sprites, "subpixel sprite"),
                        PrimitiveBatch::PolychromeSprites { range, .. } =>
                            (range, lengths.polychrome_sprites, &mut covered.polychrome_sprites, "polychrome sprite"),
                        PrimitiveBatch::Surfaces(range) => (range, lengths.surfaces, &mut covered.surfaces, "surface"),
                        PrimitiveBatch::BackdropFilters(range) =>
                            (range, lengths.backdrop_filters, &mut covered.backdrop_filters, "backdrop filter"),
                        PrimitiveBatch::FilterBoundary(_) => bail!(
                            "command {command_index}: raw filter boundary is not a compiled command"
                        ),
                    };
                    ensure!(
                        range.start == *next && range.start < range.end && range.end <= count,
                        "command {command_index}: invalid {kind} range {range:?} for {count} primitives"
                    );
                    *next = range.end;
                    match batch {
                        PrimitiveBatch::Paths { range, rasterization_vertex_count, sprite_count } => {
                            let paths = &scene.paths[range.clone()];
                            ensure!(paths.iter().all(|path| path.vertices.len() % 3 == 0),
                                "command {command_index}: path vertices must form complete triangles");
                            let expected_vertices = paths.iter().map(|path| path.vertices.len()).sum::<usize>();
                            let expected_sprites = if paths.first().unwrap().order == paths.last().unwrap().order {
                                paths.len()
                            } else { 1 };
                            ensure!(
                                *rasterization_vertex_count == expected_vertices && *sprite_count == expected_sprites,
                                "command {command_index}: path resource counts do not match its range"
                            );
                        }
                        PrimitiveBatch::MonochromeSprites { texture_id, range } => {
                            ensure!(
                                range
                                    .clone()
                                    .all(|index| scene.monochrome_sprites[index].tile.texture_id
                                        == *texture_id),
                                "command {command_index}: monochrome sprite texture does not match its range"
                            );
                        }
                        PrimitiveBatch::SubpixelSprites { texture_id, range } => {
                            ensure!(
                                range
                                    .clone()
                                    .all(|index| scene.subpixel_sprites[index].tile.texture_id
                                        == *texture_id),
                                "command {command_index}: subpixel sprite texture does not match its range"
                            );
                        }
                        PrimitiveBatch::PolychromeSprites {
                            texture_id, range, ..
                        } => {
                            ensure!(
                                range
                                    .clone()
                                    .all(|index| scene.polychrome_sprites[index].tile.texture_id
                                        == *texture_id),
                                "command {command_index}: polychrome sprite texture does not match its range"
                            );
                        }
                        _ => {}
                    }
                    requirements.include_batch(batch);
                }
                RenderCommand::BeginFilter {
                    boundary_index,
                    target,
                } => {
                    ensure!(
                        *boundary_index < lengths.filter_boundaries,
                        "command {command_index}: opening boundary index out of bounds"
                    );
                    ensure!(
                        scene.filter_boundaries[*boundary_index].is_start,
                        "command {command_index}: begin command references an end boundary"
                    );
                    ensure!(
                        expected_closing_boundaries[*boundary_index].is_some(),
                        "command {command_index}: opening boundary has no matching close"
                    );
                    ensure!(
                        !seen_boundaries[*boundary_index],
                        "command {command_index}: opening boundary appears more than once"
                    );
                    seen_boundaries[*boundary_index] = true;
                    let expected_target = if isolated_depth < MAX_FILTER_GROUP_DEPTH {
                        FilterRenderTarget::Isolated(FilterTargetIndex(isolated_depth))
                    } else {
                        FilterRenderTarget::Inline
                    };
                    ensure!(*target == expected_target,
                        "command {command_index}: filter target does not match isolation depth");
                    if let FilterRenderTarget::Isolated(target_index) = target {
                        ensure!(
                            target_index.0 == isolated_depth
                                && isolated_depth < MAX_FILTER_GROUP_DEPTH,
                            "command {command_index}: invalid isolated filter target"
                        );
                        isolated_depth += 1;
                        requirements.uses_offscreen_target = true;
                        requirements.isolated_target_count =
                            requirements.isolated_target_count.max(isolated_depth);
                    }
                    filter_stack.push((*boundary_index, *target));
                }
                RenderCommand::EndFilter {
                    boundary_index,
                    closing_boundary_index,
                    target,
                } => {
                    ensure!(
                        *boundary_index < lengths.filter_boundaries
                            && *closing_boundary_index < lengths.filter_boundaries,
                        "command {command_index}: closing boundary index out of bounds"
                    );
                    ensure!(
                        !scene.filter_boundaries[*closing_boundary_index].is_start,
                        "command {command_index}: end command references an opening boundary"
                    );
                    let Some((start, start_target)) = filter_stack.pop() else {
                        bail!("command {command_index}: end filter has no matching begin")
                    };
                    ensure!(
                        start == *boundary_index && start_target == *target,
                        "command {command_index}: end filter does not match its begin"
                    );
                    ensure!(
                        *closing_boundary_index > *boundary_index,
                        "command {command_index}: closing filter boundary precedes its begin"
                    );
                    ensure!(
                        expected_closing_boundaries[*boundary_index]
                            == Some(*closing_boundary_index),
                        "command {command_index}: closing boundary is not paired with its begin"
                    );
                    ensure!(
                        !seen_boundaries[*closing_boundary_index],
                        "command {command_index}: closing boundary appears more than once"
                    );
                    seen_boundaries[*closing_boundary_index] = true;
                    if target.is_isolated() {
                        isolated_depth -= 1;
                        requirements.isolated_filter_count += 1;
                    }
                }
            }
        }
        ensure!(
            filter_stack.is_empty(),
            "captured commands leave filter groups open"
        );
        ensure!(
            seen_boundaries.into_iter().all(|seen| seen),
            "captured commands do not reference every filter boundary"
        );
        covered.filter_boundaries = lengths.filter_boundaries;
        ensure!(covered == lengths, "captured commands do not cover every primitive");
        requirements.command_count = commands.len();
        Ok(Self {
            commands,
            requirements,
            scene_lengths: lengths,
        })
    }

    /// Returns the ordered rendering commands.
    pub fn commands(&self) -> &[RenderCommand] {
        &self.commands
    }

    /// Returns the resource totals collected while compiling this plan.
    pub fn requirements(&self) -> &ScenePlanRequirements {
        &self.requirements
    }

    pub(super) fn assert_matches(&self, scene: &Scene) {
        debug_assert_eq!(
            self.scene_lengths,
            SceneLengths::for_scene(scene),
            "scene primitive storage changed after Scene::finish"
        );
    }
}

impl ScenePlanRequirements {
    fn include_batch(&mut self, batch: &PrimitiveBatch) {
        match batch {
            PrimitiveBatch::Shadows { range, .. }
            | PrimitiveBatch::Quads { range, .. }
            | PrimitiveBatch::Underlines(range) => {
                self.instance_batch_count += usize::from(!range.is_empty());
            }
            PrimitiveBatch::Paths {
                rasterization_vertex_count,
                sprite_count,
                ..
            } => {
                self.path_rasterization_vertex_count += rasterization_vertex_count;
                if *rasterization_vertex_count > 0 {
                    self.path_sprite_count += sprite_count;
                    self.uses_path_target = true;
                    self.instance_batch_count += 2;
                }
            }
            PrimitiveBatch::MonochromeSprites { range, .. }
            | PrimitiveBatch::SubpixelSprites { range, .. }
            | PrimitiveBatch::PolychromeSprites { range, .. } => {
                self.instance_batch_count += usize::from(!range.is_empty());
            }
            PrimitiveBatch::Surfaces(range) => self.surface_count += range.len(),
            PrimitiveBatch::BackdropFilters(range) => {
                self.backdrop_filter_count += range.len();
                self.uses_offscreen_target |= !range.is_empty();
            }
            PrimitiveBatch::FilterBoundary(_) => {
                unreachable!("filter boundaries are compiled before requirements are collected")
            }
        }
    }
}

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
struct SceneLengths {
    shadows: usize,
    quads: usize,
    paths: usize,
    underlines: usize,
    monochrome_sprites: usize,
    subpixel_sprites: usize,
    polychrome_sprites: usize,
    surfaces: usize,
    backdrop_filters: usize,
    filter_boundaries: usize,
}

impl SceneLengths {
    fn for_scene(scene: &Scene) -> Self {
        Self {
            shadows: scene.shadows.len(),
            quads: scene.quads.len(),
            paths: scene.paths.len(),
            underlines: scene.underlines.len(),
            monochrome_sprites: scene.monochrome_sprites.len(),
            subpixel_sprites: scene.subpixel_sprites.len(),
            polychrome_sprites: scene.polychrome_sprites.len(),
            surfaces: scene.surfaces.len(),
            backdrop_filters: scene.backdrop_filters.len(),
            filter_boundaries: scene.filter_boundaries.len(),
        }
    }
}

/// A contiguous range of one primitive type drawn by a single pipeline invocation.
#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[allow(missing_docs)]
pub enum PrimitiveBatch {
    Shadows {
        range: Range<usize>,
        smoothed: bool,
    },
    Quads {
        range: Range<usize>,
        smoothed: bool,
    },
    Paths {
        range: Range<usize>,
        rasterization_vertex_count: usize,
        sprite_count: usize,
    },
    Underlines(Range<usize>),
    MonochromeSprites {
        texture_id: AtlasTextureId,
        range: Range<usize>,
    },
    SubpixelSprites {
        texture_id: AtlasTextureId,
        range: Range<usize>,
    },
    PolychromeSprites {
        texture_id: AtlasTextureId,
        range: Range<usize>,
        smoothed: bool,
    },
    Surfaces(Range<usize>),
    BackdropFilters(Range<usize>),
    FilterBoundary(usize),
}

/// Backend-neutral rendering work derived from a [`Scene`].
#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub enum RenderCommand {
    /// A normal primitive batch.
    Batch(PrimitiveBatch),
    /// Begin rendering a content-filter group.
    BeginFilter {
        /// Index of the opening boundary in [`Scene::filter_boundaries`].
        boundary_index: usize,
        /// Whether this group renders inline or into an isolated target.
        target: FilterRenderTarget,
    },
    /// Finish and composite a content-filter group.
    EndFilter {
        /// Index of the matched opening boundary in [`Scene::filter_boundaries`].
        boundary_index: usize,
        /// Index of the closing marker in [`Scene::filter_boundaries`].
        closing_boundary_index: usize,
        /// The same target selected by the matching begin command.
        target: FilterRenderTarget,
    },
}

impl RenderCommand {
    /// Returns the opening filter boundary carried by a filter command.
    pub fn boundary<'a>(&self, scene: &'a Scene) -> Option<&'a FilterBoundary> {
        match self {
            Self::BeginFilter { boundary_index, .. } | Self::EndFilter { boundary_index, .. } => {
                Some(&scene.filter_boundaries[*boundary_index])
            }
            Self::Batch(_) => None,
        }
    }

    /// A diagnostic label suitable for GPU debug annotations.
    pub fn label(&self) -> String {
        match self {
            Self::Batch(batch) => batch.label(),
            Self::BeginFilter { target, .. } => match target {
                FilterRenderTarget::Isolated(index) => {
                    format!("begin filter group ({})", index.as_usize())
                }
                FilterRenderTarget::Inline => "begin inline filter group".into(),
            },
            Self::EndFilter { target, .. } => match target {
                FilterRenderTarget::Isolated(index) => {
                    format!("end filter group ({})", index.as_usize())
                }
                FilterRenderTarget::Inline => "end inline filter group".into(),
            },
        }
    }
}

impl PrimitiveBatch {
    /// A diagnostic label suitable for GPU debug annotations.
    pub fn label(&self) -> String {
        match self {
            Self::Shadows { range, smoothed } => format!(
                "{}shadows ({})",
                if *smoothed { "smoothed " } else { "" },
                range.len()
            ),
            Self::Quads { range, smoothed } => format!(
                "{}quads ({})",
                if *smoothed { "smoothed " } else { "" },
                range.len()
            ),
            Self::Paths { range, .. } => format!("paths ({})", range.len()),
            Self::Underlines(range) => format!("underlines ({})", range.len()),
            Self::MonochromeSprites { texture_id, range } => format!(
                "monochrome sprites ({}) on atlas {}",
                range.len(),
                texture_id.index
            ),
            Self::SubpixelSprites { texture_id, range } => format!(
                "subpixel sprites ({}) on atlas {}",
                range.len(),
                texture_id.index
            ),
            Self::PolychromeSprites {
                texture_id,
                range,
                smoothed,
            } => format!(
                "{}polychrome sprites ({}) on atlas {}",
                if *smoothed { "smoothed " } else { "" },
                range.len(),
                texture_id.index
            ),
            Self::Surfaces(range) => format!("surfaces ({})", range.len()),
            Self::BackdropFilters(range) => format!("backdrop filters ({})", range.len()),
            Self::FilterBoundary(index) => format!("filter boundary ({index})"),
        }
    }
}
