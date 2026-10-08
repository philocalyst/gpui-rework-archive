//! Renderer-independent compilation of a recorded [`Scene`].
//!
//! A plan is the stable hand-off between scene recording and backend drawing:
//! primitive arrays stay owned by the scene, while commands describe sorting,
//! batching, path targets, and filter isolation. Resource counts are estimates
//! for the compiled plan, not GPU allocation guarantees.

use super::{AtlasTextureId, BatchIterator, FilterBoundary, Scene, ScenePrimitives};
use serde::{Deserialize, Serialize};
use smallvec::SmallVec;
use std::ops::Range;

/// Maximum number of nested content-filter groups isolated at once.
///
/// When a scene nests more groups, deeper groups still receive begin/end
/// commands but render inline into the current target. Their contents therefore
/// do not get a separate offscreen surface for applying the group filter as a
/// single composite. This limit bounds intermediate-target use across renderers.
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
///
/// These describe work implied by the plan and help a backend size or prepare
/// resources. They are counts and flags, not byte sizes or allocation
/// guarantees; surface size, atlas residency, and backend limits still matter.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct ScenePlanRequirements {
    /// Number of commands in the compiled stream.
    pub command_count: usize,
    /// Number of non-empty instance batches.
    pub instance_batch_count: usize,
    /// Number of vertices sent through path rasterization.
    pub path_rasterization_vertex_count: usize,
    /// Number of path sprites emitted by path rasterization.
    pub path_sprite_count: usize,
    /// Number of native paint surfaces in the scene.
    pub surface_count: usize,
    /// Number of isolated backdrop-filter groups.
    pub backdrop_filter_count: usize,
    /// Number of isolated content-filter groups.
    pub isolated_filter_count: usize,
    /// Maximum number of simultaneously isolated filter targets.
    pub isolated_target_count: usize,
    /// Whether path rasterization requires its dedicated target.
    pub uses_path_target: bool,
    /// Whether backdrop or isolated content filters need an offscreen target.
    ///
    /// The path rasterization target is reported separately by
    /// [`Self::uses_path_target`].
    pub uses_offscreen_target: bool,
}

/// A compiled scene command stream, built by [`Scene::finish`] and shared by every renderer.
///
/// The stream preserves painter order across the scene's type-grouped primitive
/// arrays. A [`RenderCommand::Batch`] identifies an adjacent run compatible
/// with one pipeline and, for sprites, one atlas texture. Path batches first
/// rasterize triangles into the path target and then composite the resulting
/// sprites. Filter begin/end commands bracket isolated content groups; a
/// backend follows their [`FilterRenderTarget`] assignment instead of choosing
/// its own nesting policy.
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

    pub(super) fn build(scene: &Scene, commands: Vec<RenderCommand>) -> Self {
        Self::build_primitives(scene.into(), commands)
    }

    pub(super) fn build_primitives(
        scene: ScenePrimitives<'_>,
        mut commands: Vec<RenderCommand>,
    ) -> Self {
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
            scene_lengths: SceneLengths::for_primitives(scene),
        }
    }

    /// Restores a command stream only when it matches the scene's canonical compilation.
    ///
    /// Reusing the compiler keeps range, texture, smoothing, ordering, and resource-count
    /// validation in one place. Serialized ranges are never used to index primitive arrays.
    pub(super) fn from_captured_commands(
        scene: &Scene,
        commands: Vec<RenderCommand>,
    ) -> anyhow::Result<Self> {
        use anyhow::ensure;

        for (index, path) in scene.paths.iter().enumerate() {
            ensure!(
                path.vertices.len() % 3 == 0,
                "path {index}: vertices must form complete triangles"
            );
        }
        // The live compiler tolerates an unmatched opening boundary by drawing inline.
        // Portable captures require complete groups, checked before invoking the compiler.
        let mut openings = Vec::new();
        for (index, boundary) in scene.filter_boundaries.iter().enumerate() {
            if boundary.is_start {
                openings.push(index);
            } else {
                ensure!(
                    openings.pop().is_some(),
                    "filter boundary {index}: end has no matching begin"
                );
            }
        }
        ensure!(
            openings.is_empty(),
            "captured scene leaves filter groups open"
        );

        let expected = Self::build(scene, Vec::new());
        for index in 0..expected.commands.len().max(commands.len()) {
            let actual = commands.get(index);
            let required = expected.commands.get(index);
            ensure!(
                actual == required,
                "command {index} does not match compiled scene: got {actual:?}, expected {required:?}"
            );
        }
        Ok(expected)
    }

    /// Returns the ordered rendering commands for the finished scene.
    ///
    /// Each batch range indexes the matching primitive array on that scene.
    pub fn commands(&self) -> &[RenderCommand] {
        &self.commands
    }

    /// Returns work counts and target requirements collected while compiling this plan.
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
        Self::for_primitives(scene.into())
    }
    fn for_primitives(scene: ScenePrimitives<'_>) -> Self {
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

/// A contiguous range of one primitive type drawn by a compatible pipeline invocation.
///
/// Ranges index the corresponding public primitive array on the same finished
/// [`Scene`]. They are valid only while that scene's arrays remain unchanged.
/// Batches remain in painter order: adjacent primitives can be merged only
/// when their pipeline state and texture requirements match and no intervening
/// primitive would change compositing order.
#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
pub enum PrimitiveBatch {
    /// Drop shadows sharing a smoothing pipeline.
    Shadows {
        /// Indices in [`Scene::shadows`].
        range: Range<usize>,
        /// Whether this batch uses the smoothed pipeline.
        smoothed: bool,
    },
    /// Rounded rectangles and borders sharing a smoothing pipeline.
    Quads {
        /// Indices in [`Scene::quads`].
        range: Range<usize>,
        /// Whether this batch uses the smoothed pipeline.
        smoothed: bool,
    },
    /// Paths rasterized into a temporary target before compositing.
    Paths {
        /// Indices in [`Scene::paths`].
        range: Range<usize>,
        /// Total vertices sent through path rasterization.
        rasterization_vertex_count: usize,
        /// Number of path sprites to composite.
        sprite_count: usize,
    },
    /// Indices of text decorations in [`Scene::underlines`].
    Underlines(Range<usize>),
    /// Grayscale sprites that sample the same atlas texture.
    MonochromeSprites {
        /// Atlas texture sampled by every sprite in this batch.
        texture_id: AtlasTextureId,
        /// Indices in [`Scene::monochrome_sprites`].
        range: Range<usize>,
    },
    /// LCD text sprites that sample the same atlas texture.
    SubpixelSprites {
        /// Atlas texture sampled by every sprite in this batch.
        texture_id: AtlasTextureId,
        /// Indices in [`Scene::subpixel_sprites`].
        range: Range<usize>,
    },
    /// Color sprites sharing an atlas texture and smoothing pipeline.
    PolychromeSprites {
        /// Atlas texture sampled by every sprite in this batch.
        texture_id: AtlasTextureId,
        /// Indices in [`Scene::polychrome_sprites`].
        range: Range<usize>,
        /// Whether this batch uses the smoothed pipeline.
        smoothed: bool,
    },
    /// Indices of native surfaces in [`Scene::surfaces`].
    Surfaces(Range<usize>),
    /// Indices of backdrop effects in [`Scene::backdrop_filters`].
    BackdropFilters(Range<usize>),
    /// One marker in [`Scene::filter_boundaries`].
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
    /// Returns the opening filter boundary associated with a filter command.
    ///
    /// For an [`Self::EndFilter`] command this is the matching opening marker;
    /// use `closing_boundary_index` to access the end marker. Batch commands
    /// have no boundary and return `None`.
    ///
    /// # Panics
    ///
    /// Panics if a filter command's index is outside `scene.filter_boundaries`.
    /// Use the scene that supplied the command, with its arrays unchanged.
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
