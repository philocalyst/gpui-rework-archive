// todo("windows"): remove
#![cfg_attr(windows, allow(dead_code))]

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

use crate::{
    AtlasTextureId, AtlasTile, Background, Bounds, ContentMask, Corners, Edges, Pixels, Point,
    Radians, ScaledFilter, ScaledPixels, Size, bounds_tree::BoundsTree, point,
};
use smallvec::SmallVec;
use std::{
    fmt::Debug,
    iter::Peekable,
    ops::{Add, Range, Sub},
    slice,
};

mod plan;
pub use plan::*;
mod abi;
#[doc(hidden)]
pub use abi::{SCENE_BUFFER_LAYOUTS, SceneBufferLayout};

/// A [`PathVertex`] in scaled pixels.
#[allow(non_camel_case_types, unused)]
pub type PathVertex_ScaledPixels = PathVertex<ScaledPixels>;

/// The order in which primitives are drawn. Lower values are drawn first.
pub type DrawOrder = u32;

pub(crate) const DEFAULT_BORDER_DASHED_LENGTH: f32 = 2.0;
pub(crate) const DEFAULT_BORDER_DASHED_GAP: f32 = 1.0;

/// A `bool` stored as a four-byte integer, so its layout matches the GPU's view of it.
///
/// Scene structs use this instead of [`bool`] for flags that the shaders read. Convert with
/// [`ShaderBool::from`]. [`Underline::wavy`], [`Shadow::inset`] and [`PolychromeSprite::grayscale`]
/// are `ShaderBool`s.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
#[repr(u32)]
pub enum ShaderBool {
    /// The flag is disabled.
    #[default]
    Disabled = 0,
    /// The flag is enabled.
    Enabled = 1,
}

impl ShaderBool {
    /// Returns `true` if this flag is [`ShaderBool::Enabled`].
    pub fn is_enabled(self) -> bool {
        self == Self::Enabled
    }
}

impl From<bool> for ShaderBool {
    fn from(value: bool) -> Self {
        if value { Self::Enabled } else { Self::Disabled }
    }
}

/// The primitives painted for one frame, ready for a renderer to consume.
///
/// [`crate::Window`] fills a scene while it paints. You rarely create one yourself, but it is
/// public so tests and custom renderers can inspect the result. Add primitives with
/// [`Scene::insert_primitive`] in paint order, then call [`Scene::finish`] before reading the
/// renderer-facing vectors: `finish` sorts them by draw order and compiles the render plan.
///
/// # Examples
///
/// ```
/// # use gpui::{Bounds, ContentMask, Quad, Scene, ScaledPixels, point, rgb, size};
/// let bounds = Bounds {
///     origin: point(ScaledPixels(0.), ScaledPixels(0.)),
///     size: size(ScaledPixels(100.), ScaledPixels(40.)),
/// };
/// let mut scene = Scene::default();
/// scene.insert_primitive(Quad {
///     bounds,
///     content_mask: ContentMask { bounds, ..Default::default() },
///     background: rgb(0x2563eb).into(),
///     ..Default::default()
/// });
/// scene.finish();
/// assert_eq!(scene.quads.len(), 1);
/// ```
#[derive(Default)]
pub struct Scene {
    pub(crate) paint_operations: Vec<PaintOperation>,
    primitive_bounds: BoundsTree<ScaledPixels>,
    layer_stack: Vec<Option<DrawOrder>>,
    filter_depth: usize,
    /// [`Shadow`] primitives. Sorted by draw order after [`Scene::finish`].
    pub shadows: Vec<Shadow>,
    /// [`Quad`] primitives. Sorted by draw order after [`Scene::finish`].
    pub quads: Vec<Quad>,
    /// [`Path`] primitives. A [`PathId`] is the index the path had when it was inserted, which
    /// [`Scene::finish`] can change by sorting this vector.
    pub paths: Vec<Path<ScaledPixels>>,
    /// [`Underline`] primitives. Sorted by draw order after [`Scene::finish`].
    pub underlines: Vec<Underline>,
    /// Single-color sprites, such as icons and glyph masks.
    pub monochrome_sprites: Vec<MonochromeSprite>,
    /// Glyphs drawn with subpixel anti-aliasing.
    pub subpixel_sprites: Vec<SubpixelSprite>,
    /// Full-color sprites, such as images and color emoji.
    pub polychrome_sprites: Vec<PolychromeSprite>,
    /// [`crate::PaintSurface`] primitives, such as video frames.
    pub surfaces: Vec<PaintSurface>,
    surface_opacities: Vec<f32>,
    /// [`crate::BackdropFilter`] primitives.
    pub backdrop_filters: Vec<BackdropFilter>,
    /// Start and end markers of filter or grouped-opacity isolation. Matched pairs isolate the group; unmatched markers render inline.
    pub filter_boundaries: Vec<FilterBoundary>,
    sort_keys: Vec<SceneSortKey>,
    sort_old_to_new: Vec<usize>,
    sort_scratch: Vec<usize>,
    permutations: ScenePermutations,
    render_plan: ScenePlan,
    is_finished: bool,
}

impl Scene {
    fn prepare_recording(&mut self) {
        if !self.is_finished {
            return;
        }

        if !self.permutations.is_identity() {
            for operation in &mut self.paint_operations {
                self.permutations.remap(operation, &self.sort_old_to_new);
            }
        }
        self.permutations = ScenePermutations::default();
        self.sort_old_to_new.clear();
        self.sort_scratch.clear();
        self.sort_keys.clear();
        self.is_finished = false;
    }

    /// Removes every primitive and resets the scene so that it can be painted again.
    ///
    /// The vectors keep their capacity, so a scene that is cleared and refilled each frame
    /// reuses its allocations.
    pub fn clear(&mut self) {
        self.paint_operations.clear();
        self.primitive_bounds.clear();
        self.layer_stack.clear();
        self.filter_depth = 0;
        self.paths.clear();
        self.shadows.clear();
        self.quads.clear();
        self.underlines.clear();
        self.monochrome_sprites.clear();
        self.subpixel_sprites.clear();
        self.polychrome_sprites.clear();
        self.surfaces.clear();
        self.surface_opacities.clear();
        self.backdrop_filters.clear();
        self.filter_boundaries.clear();
        self.sort_keys.clear();
        self.sort_old_to_new.clear();
        self.sort_scratch.clear();
        self.permutations = ScenePermutations::default();
        self.render_plan.clear();
        self.is_finished = false;
    }

    /// Returns whether this scene has never recorded content or raised its ordering floor.
    pub(crate) fn is_pristine(&self) -> bool {
        self.paint_operations.is_empty()
            && self.primitive_bounds.is_pristine()
            && self.layer_stack.is_empty()
            && self.filter_depth == 0
            && self.shadows.is_empty()
            && self.quads.is_empty()
            && self.paths.is_empty()
            && self.underlines.is_empty()
            && self.monochrome_sprites.is_empty()
            && self.subpixel_sprites.is_empty()
            && self.polychrome_sprites.is_empty()
            && self.surfaces.is_empty()
            && self.surface_opacities.is_empty()
            && self.backdrop_filters.is_empty()
            && self.filter_boundaries.is_empty()
            && self.sort_keys.is_empty()
            && self.sort_old_to_new.is_empty()
            && self.sort_scratch.is_empty()
            && self.permutations.is_identity()
            && self.render_plan.commands.is_empty()
            && !self.is_finished
    }

    /// Whether this finished scene can be transferred as a complete retained paint range.
    ///
    /// This is the source-side condition only. Frame also requires an exact nonempty full-range
    /// replay into a pristine destination, then moves the immutable window-owned scene instead of
    /// replaying its operations. The move preserves its lanes, order tree, permutations, render
    /// plan, and resource handles as one coherent snapshot.
    pub(crate) fn can_transfer_full_scene(&self) -> bool {
        self.is_finished
    }

    /// Returns the number of paint operations in this scene, including layer boundaries.
    pub fn len(&self) -> usize {
        self.paint_operations.len()
    }

    /// Starts a layer. Every primitive inserted until the matching [`Scene::pop_layer`] receives
    /// the layer's draw order, so the layer's contents are not interleaved with surrounding
    /// primitives. Within a layer, the renderer still groups work by primitive type.
    ///
    /// [`crate::Window::paint_layer`] calls this for you.
    pub fn push_layer(&mut self, bounds: Bounds<ScaledPixels>) {
        self.prepare_recording();
        let order = self.primitive_bounds.insert(bounds);
        self.layer_stack.push(Some(order));
        self.paint_operations
            .push(PaintOperation::StartLayer(bounds));
    }

    /// Ends the layer started by the most recent [`Scene::push_layer`]. The scene does not check
    /// that the calls are balanced, so callers must keep the nesting correct.
    pub fn pop_layer(&mut self) {
        self.prepare_recording();
        self.layer_stack.pop();
        self.paint_operations.push(PaintOperation::EndLayer);
    }

    /// Makes every primitive inserted after this call draw above every primitive inserted before it.
    ///
    /// Use this to put overlays, such as tooltips and drag images, above the rest of the scene. The
    /// renderer draws primitives in ascending draw order.
    pub fn raise_order_floor(&mut self) {
        self.prepare_recording();
        let floor = self.primitive_bounds.max_order() + 1;
        self.primitive_bounds.set_order_floor(floor);
    }

    pub(crate) fn is_in_filter_group(&self) -> bool {
        self.filter_depth > 0
    }

    /// Adds a primitive in paint order and assigns it a draw order.
    ///
    /// A primitive whose bounds are empty after clipping to its content mask is dropped. A
    /// transformed sprite is clipped by its transformed bounds. Filter boundaries are never
    /// dropped. Inside a layer started with [`Scene::push_layer`], the primitive takes the layer's
    /// draw order. Otherwise it takes one more than the highest draw order of any primitive that
    /// it overlaps, so it draws above them. In either case the order is at least the floor set by
    /// [`Scene::raise_order_floor`].
    ///
    /// # Examples
    ///
    /// ```
    /// # use gpui::{Bounds, Quad, Scene, ScaledPixels, point, size};
    /// let mut scene = Scene::default();
    /// let bounds = Bounds {
    ///     origin: point(ScaledPixels(0.), ScaledPixels(0.)),
    ///     size: size(ScaledPixels(100.), ScaledPixels(40.)),
    /// };
    /// // The default content mask is empty, so this quad is clipped away.
    /// scene.insert_primitive(Quad { bounds, ..Default::default() });
    /// scene.finish();
    /// assert!(scene.quads.is_empty());
    /// ```
    pub fn insert_primitive(&mut self, primitive: impl Into<Primitive>) {
        self.insert_primitive_recorded(primitive.into());
    }

    fn insert_primitive_recorded(&mut self, mut primitive: Primitive) {
        self.prepare_recording();
        if self.is_in_filter_group()
            && let Primitive::SubpixelSprite(sprite) = primitive
        {
            primitive = Primitive::MonochromeSprite(MonochromeSprite {
                order: sprite.order,
                padding: sprite.padding,
                bounds: sprite.bounds,
                content_mask: sprite.content_mask,
                color: sprite.color,
                tile: sprite.tile,
                transformation: sprite.transformation,
            });
        }
        let clipped_bounds = primitive
            .paint_bounds()
            .intersect(&primitive.content_mask().bounds);

        // Content-filter boundaries must always be inserted as matched pairs — dropping one
        // (e.g. for an empty clipped region) would orphan its partner and corrupt the renderer's
        // target stack. Each marker takes an order strictly above ALL prior content, so the start
        // sorts after everything painted before it and the element's own children (which overlap
        // the marker bounds) sort strictly above the start. This keeps a marker's order range from
        // colliding with unrelated non-overlapping content that reuses low orderings (e.g. a
        // background grid), which would otherwise sweep that content into the group. Content
        // painted *after* the group is held above it by raising the order floor when the end
        // marker is inserted (see below) — otherwise a later non-overlapping sibling could reuse a
        // low order that lands inside the start..end range and be swept into the group.
        let is_filter_boundary = matches!(primitive, Primitive::FilterBoundary(_));

        if clipped_bounds.is_empty() && !is_filter_boundary {
            return;
        }

        let order = if is_filter_boundary {
            let order_bounds = if clipped_bounds.is_empty() {
                *primitive.bounds()
            } else {
                clipped_bounds
            };
            self.primitive_bounds.insert_above_all(order_bounds)
        } else {
            self.layer_stack
                .last()
                .copied()
                .flatten()
                .unwrap_or_else(|| self.primitive_bounds.insert(clipped_bounds))
        };
        let paint_operation = match primitive {
            Primitive::Shadow(mut shadow) => {
                shadow.order = order;
                let index = self.shadows.len();
                self.shadows.push(shadow);
                PaintOperation::Shadow(index)
            }
            Primitive::Quad(mut quad) => {
                quad.order = order;
                let index = self.quads.len();
                self.quads.push(quad);
                PaintOperation::Quad(index)
            }
            Primitive::Path(mut path) => {
                path.order = order;
                path.id = PathId(self.paths.len());
                let index = self.paths.len();
                self.paths.push(path);
                PaintOperation::Path(index)
            }
            Primitive::Underline(mut underline) => {
                underline.order = order;
                let index = self.underlines.len();
                self.underlines.push(underline);
                PaintOperation::Underline(index)
            }
            Primitive::MonochromeSprite(mut sprite) => {
                sprite.order = order;
                let index = self.monochrome_sprites.len();
                self.monochrome_sprites.push(sprite);
                PaintOperation::MonochromeSprite(index)
            }
            Primitive::SubpixelSprite(mut sprite) => {
                sprite.order = order;
                let index = self.subpixel_sprites.len();
                self.subpixel_sprites.push(sprite);
                PaintOperation::SubpixelSprite(index)
            }
            Primitive::PolychromeSprite(mut sprite) => {
                sprite.order = order;
                let index = self.polychrome_sprites.len();
                self.polychrome_sprites.push(sprite);
                PaintOperation::PolychromeSprite(index)
            }
            Primitive::Surface(mut surface) => {
                surface.order = order;
                let index = self.surfaces.len();
                self.surfaces.push(surface);
                self.surface_opacities.push(1.0);
                PaintOperation::Surface(index)
            }
            Primitive::BackdropFilter(mut filter) => {
                filter.order = order;
                let index = self.backdrop_filters.len();
                self.backdrop_filters.push(filter);
                PaintOperation::BackdropFilter(index)
            }
            Primitive::FilterBoundary(mut boundary) => {
                boundary.order = order;
                self.layer_stack.fill(None);
                self.primitive_bounds.set_order_floor(order + 1);
                if boundary.is_start {
                    self.filter_depth += 1;
                } else {
                    self.filter_depth = self.filter_depth.saturating_sub(1);
                }
                let index = self.filter_boundaries.len();
                self.filter_boundaries.push(boundary);
                PaintOperation::FilterBoundary(index)
            }
        };
        self.paint_operations.push(paint_operation);
    }

    /// Replays operations from `range` in `prev_scene` into this scene.
    ///
    /// The range indexes the source scene paint-operation stream and must be within its current
    /// length. Replayed primitives are inserted through this scene normal clipping and draw-order
    /// logic, so the destination scene can combine them with newly painted content. If the source
    /// scene has been finished, its lane-sort mappings are applied before reading each primitive.
    pub fn replay(&mut self, range: Range<usize>, prev_scene: &Scene) {
        for operation in &prev_scene.paint_operations[range] {
            let mut operation = *operation;
            prev_scene
                .permutations
                .remap(&mut operation, &prev_scene.sort_old_to_new);
            match operation {
                PaintOperation::StartLayer(bounds) => self.push_layer(bounds),
                PaintOperation::EndLayer => self.pop_layer(),
                PaintOperation::Shadow(index) => {
                    self.insert_primitive(Primitive::Shadow(prev_scene.shadows[index]))
                }
                PaintOperation::Quad(index) => {
                    self.insert_primitive(Primitive::Quad(prev_scene.quads[index]))
                }
                PaintOperation::Path(index) => {
                    self.insert_primitive(Primitive::Path(prev_scene.paths[index].clone()))
                }
                PaintOperation::Underline(index) => {
                    self.insert_primitive(Primitive::Underline(prev_scene.underlines[index]))
                }
                PaintOperation::MonochromeSprite(index) => self.insert_primitive(
                    Primitive::MonochromeSprite(prev_scene.monochrome_sprites[index]),
                ),
                PaintOperation::SubpixelSprite(index) => self.insert_primitive(
                    Primitive::SubpixelSprite(prev_scene.subpixel_sprites[index]),
                ),
                PaintOperation::PolychromeSprite(index) => self.insert_primitive(
                    Primitive::PolychromeSprite(prev_scene.polychrome_sprites[index]),
                ),
                PaintOperation::Surface(index) => {
                    self.insert_primitive(Primitive::Surface(prev_scene.surfaces[index].clone()))
                }
                PaintOperation::BackdropFilter(index) => self.insert_primitive(
                    Primitive::BackdropFilter(prev_scene.backdrop_filters[index].clone()),
                ),
                PaintOperation::FilterBoundary(index) => self.insert_primitive(
                    Primitive::FilterBoundary(prev_scene.filter_boundaries[index].clone()),
                ),
            }
        }
    }

    /// Sorts primitive lanes by draw order and compiles renderer commands for this scene.
    ///
    /// Call this after recording operations and before reading [`Self::batches`] or
    /// [`Self::render_commands`]. Calling it again after further insertions updates the compiled
    /// plan while preserving the operation indices used by replay.
    pub fn finish(&mut self) {
        let was_finished = self.is_finished;
        self.surface_opacities.resize(self.surfaces.len(), 1.0);
        self.surface_opacities.truncate(self.surfaces.len());

        let mut permutations = ScenePermutations::default();
        macro_rules! sort_and_apply_lane {
            ($kind:ident, $lane:ident, $key:expr, $parallel:expr) => {{
                sort_scene_items(
                    &self.$lane,
                    &mut self.sort_keys,
                    &mut self.sort_old_to_new,
                    $key,
                    &mut permutations[SceneLane::$kind],
                );
                apply_scene_sort(
                    &mut self.$lane,
                    &self.sort_old_to_new,
                    &mut self.sort_scratch,
                    permutations[SceneLane::$kind].sort.clone(),
                    $key,
                    $parallel,
                );
            }};
        }
        sort_and_apply_lane!(Shadows, shadows, |shadow| (shadow.order, 0), |_| {});
        sort_and_apply_lane!(Quads, quads, |quad| (quad.order, 0), |_| {});
        sort_and_apply_lane!(Paths, paths, |path| (path.order, 0), |_| {});
        sort_and_apply_lane!(
            Underlines,
            underlines,
            |underline| (underline.order, 0),
            |_| {}
        );
        sort_and_apply_lane!(
            MonochromeSprites,
            monochrome_sprites,
            |sprite| { (sprite.order, sprite.tile.tile_id.0) },
            |_| {}
        );
        sort_and_apply_lane!(
            SubpixelSprites,
            subpixel_sprites,
            |sprite| { (sprite.order, sprite.tile.tile_id.0) },
            |_| {}
        );
        sort_and_apply_lane!(
            PolychromeSprites,
            polychrome_sprites,
            |sprite| { (sprite.order, sprite.tile.tile_id.0) },
            |_| {}
        );
        sort_and_apply_lane!(Surfaces, surfaces, |surface| (surface.order, 0), |edit| {
            match edit {
                LaneEdit::Swap(from, to) => self.surface_opacities.swap(from, to),
                LaneEdit::Reverse(range) => self.surface_opacities[range].reverse(),
            }
        });
        sort_and_apply_lane!(
            BackdropFilters,
            backdrop_filters,
            |filter| (filter.order, 0),
            |_| {}
        );
        // Markers normally get distinct, monotonically-increasing orders (children overlap
        // their group bounds and so sort strictly between the start and end). The `!is_start`
        // tiebreak only matters for a degenerate empty group whose start and end tie: it keeps
        // the start (false = 0) ahead of the end (true = 1) so the pair stays well-formed.
        sort_and_apply_lane!(
            FilterBoundaries,
            filter_boundaries,
            |boundary| { (boundary.order, (!boundary.is_start) as u32) },
            |_| {}
        );
        self.sort_keys.clear();
        self.sort_scratch.clear();
        if was_finished {
            if !permutations.is_identity() {
                let composed = compose_scene_permutations(
                    &self.permutations,
                    &permutations,
                    &self.sort_old_to_new,
                    &mut self.sort_scratch,
                );
                std::mem::swap(&mut self.sort_old_to_new, &mut self.sort_scratch);
                self.sort_scratch.clear();
                self.permutations = composed;
            }
        } else {
            self.permutations = permutations;
        }
        let commands = std::mem::take(&mut self.render_plan.commands);
        self.render_plan = ScenePlan::build(self, commands);
        self.is_finished = true;
    }

    /// Returns the draw batches of a finished scene, in drawing order.
    ///
    /// Each batch is a run of one primitive type that the renderer draws in one call.
    /// [`PrimitiveBatch::FilterBoundary`] entries mark the start and end of filter or grouped-opacity groups.
    /// Use [`Scene::render_commands`] when you also need the offscreen target for each group.
    ///
    /// # Panics
    ///
    /// In debug builds, panics if the scene hasn't been finished.
    ///
    /// # Examples
    ///
    /// ```
    /// # use gpui::{Bounds, ContentMask, PrimitiveBatch, Quad, Scene, ScaledPixels, point, size};
    /// let bounds = Bounds {
    ///     origin: point(ScaledPixels(0.), ScaledPixels(0.)),
    ///     size: size(ScaledPixels(100.), ScaledPixels(40.)),
    /// };
    /// let mut scene = Scene::default();
    /// scene.insert_primitive(Quad {
    ///     bounds,
    ///     content_mask: ContentMask { bounds, ..Default::default() },
    ///     ..Default::default()
    /// });
    /// scene.finish();
    /// assert_eq!(
    ///     scene.batches().collect::<Vec<_>>(),
    ///     vec![PrimitiveBatch::Quads { range: 0..1, smoothed: false }],
    /// );
    /// ```
    #[cfg_attr(
        all(
            any(target_os = "linux", target_os = "freebsd"),
            not(any(feature = "x11", feature = "wayland"))
        ),
        allow(dead_code)
    )]
    pub fn batches(&self) -> impl Iterator<Item = PrimitiveBatch> + '_ {
        self.render_commands().iter().map(|command| match command {
            RenderCommand::Batch(batch) => batch.clone(),
            RenderCommand::BeginFilter { boundary_index, .. } => {
                PrimitiveBatch::FilterBoundary(*boundary_index)
            }
            RenderCommand::EndFilter {
                closing_boundary_index,
                ..
            } => PrimitiveBatch::FilterBoundary(*closing_boundary_index),
        })
    }

    /// Returns the render commands of a finished scene, in drawing order.
    ///
    /// Commands are primitive batches, plus begin and end markers for filter or grouped-opacity groups that say
    /// whether each group draws into an isolated target. Renderers use these instead of
    /// [`Scene::batches`] when they manage offscreen targets.
    ///
    /// # Panics
    ///
    /// In debug builds, panics if the scene hasn't been finished.
    pub fn render_commands(&self) -> &[RenderCommand] {
        self.render_plan().commands()
    }

    /// Returns the compiled [`ScenePlan`] of a finished scene.
    ///
    /// # Panics
    ///
    /// In debug builds, panics if the scene hasn't been finished, or if its primitive storage changed
    /// after [`Scene::finish`].
    pub fn render_plan(&self) -> &ScenePlan {
        debug_assert!(
            self.is_finished,
            "Scene::finish must be called before rendering"
        );
        self.render_plan.assert_matches(self);
        &self.render_plan
    }

    /// Returns the intrinsic opacity of each surface in the same order.
    ///
    /// Surfaces are fully opaque here; group opacity is applied when compositing.
    pub fn surface_opacities(&self) -> &[f32] {
        &self.surface_opacities
    }

    /// Returns `true` if rendering this scene needs an offscreen target. That is the case when it has
    /// backdrop filters, or filter or grouped-opacity groups that draw into an isolated target.
    ///
    /// # Panics
    ///
    /// In debug builds, panics if the scene hasn't been finished.
    pub fn requires_offscreen_rendering(&self) -> bool {
        self.render_plan().requirements().uses_offscreen_target
    }
}

/// Internal representation of [`palette::Hsla`] with the layout provided to the renderer.
#[derive(Clone, Copy, Debug, Default, PartialEq, Serialize, Deserialize, JsonSchema)]
#[repr(C)]
pub struct SceneHsla {
    /// Hue, in a range from 0 to 1
    pub(crate) h: f32,
    /// Saturation, in a range from 0 to 1
    pub(crate) s: f32,
    /// Lightness, in a range from 0 to 1
    pub(crate) l: f32,
    /// Alpha, in a range from 0 to 1
    pub(crate) a: f32,
}
impl Into<palette::Hsla> for SceneHsla {
    fn into(self) -> palette::Hsla {
        palette::Hsla::new(self.h * 360.0, self.s, self.l, self.a)
    }
}
impl From<palette::Hsla> for SceneHsla {
    fn from(hsla: palette::Hsla) -> Self {
        Self {
            h: hsla.hue.into_positive_degrees() / 360.0,
            s: hsla.saturation,
            l: hsla.lightness,
            a: hsla.alpha,
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, Ord, PartialOrd, Default)]
#[cfg_attr(
    all(
        any(target_os = "linux", target_os = "freebsd"),
        not(any(feature = "x11", feature = "wayland"))
    ),
    allow(dead_code)
)]
pub(crate) enum PrimitiveKind {
    // Lowest discriminant: at an equal order, a filter or grouped-opacity group-start is emitted before
    // the group's own content so the renderer redirects rendering before any child draws.
    FilterBoundaryStart,
    Shadow,
    #[default]
    Quad,
    Path,
    Underline,
    MonochromeSprite,
    SubpixelSprite,
    PolychromeSprite,
    Surface,
    BackdropFilter,
    // Highest discriminant: at an equal order, a group-end is emitted after the group's content
    // so the renderer composites the filtered group only once every child has been drawn.
    FilterBoundaryEnd,
}

#[derive(Clone, Copy)]
pub(crate) enum PaintOperation {
    Shadow(usize),
    Quad(usize),
    Path(usize),
    Underline(usize),
    MonochromeSprite(usize),
    SubpixelSprite(usize),
    PolychromeSprite(usize),
    Surface(usize),
    BackdropFilter(usize),
    FilterBoundary(usize),
    StartLayer(Bounds<ScaledPixels>),
    EndLayer,
}

#[derive(Clone, Copy)]
#[repr(usize)]
enum SceneLane {
    Shadows,
    Quads,
    Paths,
    Underlines,
    MonochromeSprites,
    SubpixelSprites,
    PolychromeSprites,
    Surfaces,
    BackdropFilters,
    FilterBoundaries,
}

const SCENE_LANE_COUNT: usize = SceneLane::FilterBoundaries as usize + 1;

#[derive(Clone)]
struct ScenePermutations {
    lanes: [LaneMapping; SCENE_LANE_COUNT],
}

impl Default for ScenePermutations {
    fn default() -> Self {
        Self {
            lanes: std::array::from_fn(|_| LaneMapping::default()),
        }
    }
}

impl std::ops::Index<SceneLane> for ScenePermutations {
    type Output = LaneMapping;

    fn index(&self, lane: SceneLane) -> &Self::Output {
        &self.lanes[lane as usize]
    }
}

impl std::ops::IndexMut<SceneLane> for ScenePermutations {
    fn index_mut(&mut self, lane: SceneLane) -> &mut Self::Output {
        &mut self.lanes[lane as usize]
    }
}

#[derive(Clone, Default)]
struct LaneMapping {
    source_len: usize,
    sort: LaneSort,
}

#[derive(Clone, Default)]
enum LaneSort {
    #[default]
    Identity,
    Swap(usize),
    Reverse(usize),
    ReverseRuns(Range<usize>),
    Indexed(Range<usize>),
}

enum LanePattern {
    Identity,
    Swap(usize),
    Reverse,
    ReverseRuns,
    Indexed,
}

#[derive(Clone, Copy, Eq, Ord, PartialEq, PartialOrd)]
struct SceneSortKey(DrawOrder, u32, usize);

impl ScenePermutations {
    fn is_identity(&self) -> bool {
        self.lanes
            .iter()
            .all(|mapping| matches!(&mapping.sort, LaneSort::Identity))
    }

    fn remap(&self, operation: &mut PaintOperation, old_to_new: &[usize]) {
        let (lane, index) = match operation {
            PaintOperation::Shadow(index) => (SceneLane::Shadows, index),
            PaintOperation::Quad(index) => (SceneLane::Quads, index),
            PaintOperation::Path(index) => (SceneLane::Paths, index),
            PaintOperation::Underline(index) => (SceneLane::Underlines, index),
            PaintOperation::MonochromeSprite(index) => (SceneLane::MonochromeSprites, index),
            PaintOperation::SubpixelSprite(index) => (SceneLane::SubpixelSprites, index),
            PaintOperation::PolychromeSprite(index) => (SceneLane::PolychromeSprites, index),
            PaintOperation::Surface(index) => (SceneLane::Surfaces, index),
            PaintOperation::BackdropFilter(index) => (SceneLane::BackdropFilters, index),
            PaintOperation::FilterBoundary(index) => (SceneLane::FilterBoundaries, index),
            PaintOperation::StartLayer(_) | PaintOperation::EndLayer => return,
        };
        remap_index(index, &self[lane].sort, old_to_new);
    }
}

fn compose_scene_permutations(
    previous: &ScenePermutations,
    current: &ScenePermutations,
    source: &[usize],
    output: &mut Vec<usize>,
) -> ScenePermutations {
    ScenePermutations {
        lanes: std::array::from_fn(|index| {
            compose_lane(
                &previous.lanes[index],
                &current.lanes[index],
                source,
                output,
            )
        }),
    }
}

fn compose_lane(
    previous: &LaneMapping,
    current: &LaneMapping,
    source: &[usize],
    output: &mut Vec<usize>,
) -> LaneMapping {
    let source_len = previous.source_len;
    let sort = match (&previous.sort, &current.sort) {
        (LaneSort::Identity, sort) => copy_lane_sort(sort, source_len, source, output),
        (sort, LaneSort::Identity) => copy_lane_sort(sort, source_len, source, output),
        (LaneSort::Swap(old), LaneSort::Swap(new)) if old == new => LaneSort::Identity,
        (LaneSort::Reverse(old), LaneSort::Reverse(new)) if old == new => LaneSort::Identity,
        _ => {
            let start = output.len();
            for old_index in 0..source_len {
                let current_index = map_index(old_index, &previous.sort, source);
                output.push(map_index(current_index, &current.sort, source));
            }
            if output[start..]
                .iter()
                .enumerate()
                .all(|(index, &mapped)| index == mapped)
            {
                output.truncate(start);
                LaneSort::Identity
            } else {
                LaneSort::Indexed(start..output.len())
            }
        }
    };
    LaneMapping { source_len, sort }
}

fn copy_lane_sort(
    sort: &LaneSort,
    source_len: usize,
    source: &[usize],
    output: &mut Vec<usize>,
) -> LaneSort {
    match sort {
        LaneSort::Identity => LaneSort::Identity,
        LaneSort::Swap(position) => LaneSort::Swap(*position),
        LaneSort::Reverse(len) => LaneSort::Reverse(*len),
        LaneSort::ReverseRuns(range) | LaneSort::Indexed(range) => {
            copy_lane_map(range, source_len, source, output)
        }
    }
}

fn copy_lane_map(
    range: &Range<usize>,
    source_len: usize,
    source: &[usize],
    output: &mut Vec<usize>,
) -> LaneSort {
    let start = output.len();
    let mapping = &source[range.start..range.start + source_len];
    if mapping
        .iter()
        .enumerate()
        .all(|(index, &mapped)| index == mapped)
    {
        return LaneSort::Identity;
    }
    output.extend_from_slice(mapping);
    LaneSort::Indexed(start..output.len())
}

#[inline]
fn remap_index(index: &mut usize, sort: &LaneSort, old_to_new: &[usize]) {
    *index = map_index(*index, sort, old_to_new);
}

#[inline]
fn map_index(index: usize, sort: &LaneSort, old_to_new: &[usize]) -> usize {
    match sort {
        LaneSort::Identity => {}
        LaneSort::Swap(position) => {
            return match index {
                index if index == *position => index + 1,
                index if index == *position + 1 => index - 1,
                index => index,
            };
        }
        LaneSort::Reverse(len) => return len - 1 - index,
        LaneSort::ReverseRuns(range) | LaneSort::Indexed(range) => {
            return old_to_new[range.start + index];
        }
    }
    index
}

/// Selects a cheap lane operation for monotone keys; equal runs never take simple reverse.
/// Remaining keys use old indices as a final key, preserving stable-sort tie behavior.
fn sort_scene_items<T>(
    items: &[T],
    sort_keys: &mut Vec<SceneSortKey>,
    old_to_new: &mut Vec<usize>,
    key: impl Fn(&T) -> (DrawOrder, u32),
    mapping: &mut LaneMapping,
) {
    mapping.source_len = items.len();
    let sort = &mut mapping.sort;
    match classify_scene_lane(items, &key) {
        LanePattern::Identity => *sort = LaneSort::Identity,
        LanePattern::Swap(position) => *sort = LaneSort::Swap(position),
        LanePattern::Reverse => *sort = LaneSort::Reverse(items.len()),
        LanePattern::ReverseRuns => {
            let start = old_to_new.len();
            old_to_new.resize(start + items.len(), 0);
            let mut run_start = 0;
            let mut run_key = key(&items[0]);
            for end in 1..=items.len() {
                let next_key = items.get(end).map(&key);
                if next_key != Some(run_key) {
                    let new_start = items.len() - end;
                    for old_index in run_start..end {
                        old_to_new[start + old_index] = new_start + old_index - run_start;
                    }
                    run_start = end;
                    if let Some(next_key) = next_key {
                        run_key = next_key;
                    }
                }
            }
            *sort = LaneSort::ReverseRuns(start..old_to_new.len());
        }
        LanePattern::Indexed => {
            let start = old_to_new.len();
            sort_keys.clear();
            sort_keys.extend(items.iter().enumerate().map(|(index, item)| {
                let (order, tie_break) = key(item);
                SceneSortKey(order, tie_break, index)
            }));
            sort_keys.sort_unstable();
            old_to_new.resize(start + items.len(), 0);
            for (new_index, &SceneSortKey(_, _, old_index)) in sort_keys.iter().enumerate() {
                old_to_new[start + old_index] = new_index;
            }
            *sort = LaneSort::Indexed(start..old_to_new.len());
        }
    }
}

fn classify_scene_lane<T>(items: &[T], key: &impl Fn(&T) -> (DrawOrder, u32)) -> LanePattern {
    let mut inversions = items
        .windows(2)
        .enumerate()
        .filter(|(_, pair)| key(&pair[0]) > key(&pair[1]));
    let Some((position, _)) = inversions.next() else {
        return LanePattern::Identity;
    };
    if inversions.next().is_none() {
        let lower = key(&items[position + 1]);
        let upper = key(&items[position]);
        // With one inversion, its adjacent keys bound the already ordered prefix and suffix.
        let prefix_is_ordered = position == 0 || key(&items[position - 1]) <= lower;
        let suffix_is_ordered = position + 2 == items.len() || upper <= key(&items[position + 2]);
        if prefix_is_ordered && suffix_is_ordered {
            return LanePattern::Swap(position);
        }
    }

    match items
        .windows(2)
        .try_fold(true, |strictly_decreasing, pair| {
            let previous = key(&pair[0]);
            let current = key(&pair[1]);
            if previous < current {
                None
            } else {
                Some(strictly_decreasing && previous > current)
            }
        }) {
        Some(true) => LanePattern::Reverse,
        Some(false) => LanePattern::ReverseRuns,
        None => LanePattern::Indexed,
    }
}

enum LaneEdit {
    Swap(usize, usize),
    Reverse(Range<usize>),
}

/// Applies a permutation in place and mirrors each edit to its parallel lane.
fn apply_scene_sort<T>(
    items: &mut [T],
    old_to_new: &[usize],
    scratch: &mut Vec<usize>,
    sort: LaneSort,
    key: impl Fn(&T) -> (DrawOrder, u32),
    mut apply_parallel: impl FnMut(LaneEdit),
) {
    match sort {
        LaneSort::Identity => {}
        LaneSort::Swap(position) => {
            items.swap(position, position + 1);
            apply_parallel(LaneEdit::Swap(position, position + 1));
        }
        LaneSort::Reverse(len) => {
            items[..len].reverse();
            apply_parallel(LaneEdit::Reverse(0..len));
        }
        LaneSort::ReverseRuns(range) => {
            let len = items.len();
            items.reverse();
            apply_parallel(LaneEdit::Reverse(0..len));
            let mut start = 0;
            while start < len {
                let run_key = key(&items[start]);
                let mut end = start + 1;
                while end < len && key(&items[end]) == run_key {
                    end += 1;
                }
                let run = start..end;
                items[run.clone()].reverse();
                apply_parallel(LaneEdit::Reverse(run));
                start = end;
            }
            debug_assert_eq!(range.len(), len);
        }
        LaneSort::Indexed(range) => {
            scratch.clear();
            scratch.extend_from_slice(&old_to_new[range]);
            let old_to_new = scratch.as_mut_slice();
            for index in 0..items.len() {
                while old_to_new[index] != index {
                    let destination = old_to_new[index];
                    items.swap(index, destination);
                    apply_parallel(LaneEdit::Swap(index, destination));
                    old_to_new.swap(index, destination);
                }
            }
        }
    }
}

/// Any primitive that [`Scene::insert_primitive`] accepts.
#[derive(Clone)]
pub enum Primitive {
    /// A [`Shadow`].
    Shadow(Shadow),
    /// A [`Quad`].
    Quad(Quad),
    /// A [`Path`].
    Path(Path<ScaledPixels>),
    /// An [`Underline`].
    Underline(Underline),
    /// A [`MonochromeSprite`].
    MonochromeSprite(MonochromeSprite),
    /// A [`SubpixelSprite`].
    SubpixelSprite(SubpixelSprite),
    /// A [`PolychromeSprite`].
    PolychromeSprite(PolychromeSprite),
    /// A [`crate::PaintSurface`].
    Surface(PaintSurface),
    /// A [`crate::BackdropFilter`].
    BackdropFilter(BackdropFilter),
    /// A [`FilterBoundary`] marker.
    FilterBoundary(FilterBoundary),
}

impl Primitive {
    /// The screen-space bounds of the primitive, which for transformed sprites differ from
    /// their stored bounds.
    fn paint_bounds(&self) -> Bounds<ScaledPixels> {
        match self {
            Primitive::MonochromeSprite(sprite) => {
                transformed_bounds(sprite.bounds, sprite.transformation)
            }
            Primitive::SubpixelSprite(sprite) => {
                transformed_bounds(sprite.bounds, sprite.transformation)
            }
            Primitive::Underline(underline) => underline
                .bounds
                .intersect(&underline.clip_bounds)
                .intersect(&underline.content_mask.bounds),
            _ => *self.bounds(),
        }
    }

    /// Returns the bounds of this primitive, in scaled pixels.
    pub fn bounds(&self) -> &Bounds<ScaledPixels> {
        match self {
            Primitive::Shadow(shadow) => &shadow.bounds,
            Primitive::Quad(quad) => &quad.bounds,
            Primitive::Path(path) => &path.bounds,
            Primitive::Underline(underline) => &underline.bounds,
            Primitive::MonochromeSprite(sprite) => &sprite.bounds,
            Primitive::SubpixelSprite(sprite) => &sprite.bounds,
            Primitive::PolychromeSprite(sprite) => &sprite.bounds,
            Primitive::Surface(surface) => &surface.bounds,
            Primitive::BackdropFilter(filter) => &filter.bounds,
            Primitive::FilterBoundary(boundary) => &boundary.bounds,
        }
    }

    /// Returns the content mask that clips this primitive.
    pub fn content_mask(&self) -> &ContentMask<ScaledPixels> {
        match self {
            Primitive::Shadow(shadow) => &shadow.content_mask,
            Primitive::Quad(quad) => &quad.content_mask,
            Primitive::Path(path) => &path.content_mask,
            Primitive::Underline(underline) => &underline.content_mask,
            Primitive::MonochromeSprite(sprite) => &sprite.content_mask,
            Primitive::SubpixelSprite(sprite) => &sprite.content_mask,
            Primitive::PolychromeSprite(sprite) => &sprite.content_mask,
            Primitive::Surface(surface) => &surface.content_mask,
            Primitive::BackdropFilter(filter) => &filter.content_mask,
            Primitive::FilterBoundary(boundary) => &boundary.content_mask,
        }
    }
}

fn transformed_bounds(
    bounds: Bounds<ScaledPixels>,
    transformation: TransformationMatrix,
) -> Bounds<ScaledPixels> {
    if transformation == TransformationMatrix::unit() {
        return bounds;
    }

    let corners = [
        bounds.origin,
        bounds.top_right(),
        bounds.bottom_left(),
        bounds.bottom_right(),
    ]
    .map(|corner| {
        transformation
            .apply(corner.map(|value| Pixels(value.0)))
            .map(|value| ScaledPixels(value.0))
    });
    let top_left = corners
        .iter()
        .fold(corners[0], |min, corner| min.min(corner));
    let bottom_right = corners
        .iter()
        .fold(corners[0], |max, corner| max.max(corner));
    Bounds::from_corners(top_left, bottom_right)
}

#[cfg_attr(
    all(
        any(target_os = "linux", target_os = "freebsd"),
        not(any(feature = "x11", feature = "wayland"))
    ),
    allow(dead_code)
)]
struct BatchIterator<'a> {
    shadows_start: usize,
    shadows_iter: Peekable<slice::Iter<'a, Shadow>>,
    quads_start: usize,
    quads_iter: Peekable<slice::Iter<'a, Quad>>,
    paths_start: usize,
    paths: &'a [Path<ScaledPixels>],
    paths_iter: Peekable<slice::Iter<'a, Path<ScaledPixels>>>,
    underlines_start: usize,
    underlines_iter: Peekable<slice::Iter<'a, Underline>>,
    monochrome_sprites_start: usize,
    monochrome_sprites_iter: Peekable<slice::Iter<'a, MonochromeSprite>>,
    subpixel_sprites_start: usize,
    subpixel_sprites_iter: Peekable<slice::Iter<'a, SubpixelSprite>>,
    polychrome_sprites_start: usize,
    polychrome_sprites_iter: Peekable<slice::Iter<'a, PolychromeSprite>>,
    surfaces_start: usize,
    surfaces_iter: Peekable<slice::Iter<'a, PaintSurface>>,
    backdrop_filters_start: usize,
    backdrop_filters_iter: Peekable<slice::Iter<'a, BackdropFilter>>,
    filter_boundaries_start: usize,
    filter_boundaries_iter: Peekable<slice::Iter<'a, FilterBoundary>>,
}

impl<'a> BatchIterator<'a> {
    fn new(scene: &'a Scene) -> Self {
        Self {
            shadows_start: 0,
            shadows_iter: scene.shadows.iter().peekable(),
            quads_start: 0,
            quads_iter: scene.quads.iter().peekable(),
            paths_start: 0,
            paths: &scene.paths,
            paths_iter: scene.paths.iter().peekable(),
            underlines_start: 0,
            underlines_iter: scene.underlines.iter().peekable(),
            monochrome_sprites_start: 0,
            monochrome_sprites_iter: scene.monochrome_sprites.iter().peekable(),
            subpixel_sprites_start: 0,
            subpixel_sprites_iter: scene.subpixel_sprites.iter().peekable(),
            polychrome_sprites_start: 0,
            polychrome_sprites_iter: scene.polychrome_sprites.iter().peekable(),
            surfaces_start: 0,
            surfaces_iter: scene.surfaces.iter().peekable(),
            backdrop_filters_start: 0,
            backdrop_filters_iter: scene.backdrop_filters.iter().peekable(),
            filter_boundaries_start: 0,
            filter_boundaries_iter: scene.filter_boundaries.iter().peekable(),
        }
    }
}

fn precedes_limit(
    order: DrawOrder,
    kind: PrimitiveKind,
    limit: Option<(DrawOrder, PrimitiveKind)>,
) -> bool {
    limit.is_none_or(|limit| (order, kind) < limit)
}

fn has_corner_smoothing(corner_smoothing: f32) -> bool {
    corner_smoothing > 0.0
}

impl<'a> Iterator for BatchIterator<'a> {
    type Item = PrimitiveBatch;

    fn next(&mut self) -> Option<Self::Item> {
        let orders_and_kinds = [
            (
                self.shadows_iter.peek().map(|s| s.order),
                PrimitiveKind::Shadow,
            ),
            (self.quads_iter.peek().map(|q| q.order), PrimitiveKind::Quad),
            (self.paths_iter.peek().map(|q| q.order), PrimitiveKind::Path),
            (
                self.underlines_iter.peek().map(|u| u.order),
                PrimitiveKind::Underline,
            ),
            (
                self.monochrome_sprites_iter.peek().map(|s| s.order),
                PrimitiveKind::MonochromeSprite,
            ),
            (
                self.subpixel_sprites_iter.peek().map(|s| s.order),
                PrimitiveKind::SubpixelSprite,
            ),
            (
                self.polychrome_sprites_iter.peek().map(|s| s.order),
                PrimitiveKind::PolychromeSprite,
            ),
            (
                self.surfaces_iter.peek().map(|s| s.order),
                PrimitiveKind::Surface,
            ),
            (
                self.backdrop_filters_iter.peek().map(|f| f.order),
                PrimitiveKind::BackdropFilter,
            ),
            (
                self.filter_boundaries_iter.peek().map(|b| b.order),
                // The same vec yields both start and end markers; the discriminant decides
                // where the next marker sorts relative to draw batches at an equal order
                // (start before content, end after).
                match self.filter_boundaries_iter.peek() {
                    Some(boundary) if boundary.is_start => PrimitiveKind::FilterBoundaryStart,
                    _ => PrimitiveKind::FilterBoundaryEnd,
                },
            ),
        ];
        // Find the two lowest live cursors in one fixed-size scan.
        let mut first = None;
        let mut second = None;
        for (order, kind) in orders_and_kinds {
            let Some(order) = order else {
                continue;
            };
            let candidate = (order, kind);
            if first.is_none_or(|current| candidate < current) {
                second = first;
                first = Some(candidate);
            } else if second.is_none_or(|current| candidate < current) {
                second = Some(candidate);
            }
        }
        let (_, batch_kind) = first?;
        let max_order_and_kind = second;

        match batch_kind {
            PrimitiveKind::Shadow => {
                let smoothed =
                    has_corner_smoothing(self.shadows_iter.peek().unwrap().corner_smoothing);
                let shadows_start = self.shadows_start;
                let mut shadows_end = shadows_start + 1;
                self.shadows_iter.next();
                while self
                    .shadows_iter
                    .next_if(|shadow| {
                        precedes_limit(shadow.order, batch_kind, max_order_and_kind)
                            && has_corner_smoothing(shadow.corner_smoothing) == smoothed
                    })
                    .is_some()
                {
                    shadows_end += 1;
                }
                self.shadows_start = shadows_end;
                Some(PrimitiveBatch::Shadows {
                    range: shadows_start..shadows_end,
                    smoothed,
                })
            }
            PrimitiveKind::Quad => {
                let smoothed =
                    has_corner_smoothing(self.quads_iter.peek().unwrap().corner_smoothing);
                let quads_start = self.quads_start;
                let mut quads_end = quads_start + 1;
                self.quads_iter.next();
                while self
                    .quads_iter
                    .next_if(|quad| {
                        precedes_limit(quad.order, batch_kind, max_order_and_kind)
                            && has_corner_smoothing(quad.corner_smoothing) == smoothed
                    })
                    .is_some()
                {
                    quads_end += 1;
                }
                self.quads_start = quads_end;
                Some(PrimitiveBatch::Quads {
                    range: quads_start..quads_end,
                    smoothed,
                })
            }
            PrimitiveKind::Path => {
                let paths_start = self.paths_start;
                let mut paths_end = paths_start + 1;
                self.paths_iter.next();
                while self
                    .paths_iter
                    .next_if(|path| precedes_limit(path.order, batch_kind, max_order_and_kind))
                    .is_some()
                {
                    paths_end += 1;
                }
                self.paths_start = paths_end;
                let range = paths_start..paths_end;
                let paths = &self.paths[range.clone()];
                let rasterization_vertex_count = paths.iter().map(|path| path.vertices.len()).sum();
                let sprite_count = if paths
                    .last()
                    .is_some_and(|path| path.order == paths[0].order)
                {
                    paths.len()
                } else {
                    1
                };
                Some(PrimitiveBatch::Paths {
                    range,
                    rasterization_vertex_count,
                    sprite_count,
                })
            }
            PrimitiveKind::Underline => {
                let underlines_start = self.underlines_start;
                let mut underlines_end = underlines_start + 1;
                self.underlines_iter.next();
                while self
                    .underlines_iter
                    .next_if(|underline| {
                        precedes_limit(underline.order, batch_kind, max_order_and_kind)
                    })
                    .is_some()
                {
                    underlines_end += 1;
                }
                self.underlines_start = underlines_end;
                Some(PrimitiveBatch::Underlines(underlines_start..underlines_end))
            }
            PrimitiveKind::MonochromeSprite => {
                let texture_id = self.monochrome_sprites_iter.peek().unwrap().tile.texture_id;
                let sprites_start = self.monochrome_sprites_start;
                let mut sprites_end = sprites_start + 1;
                self.monochrome_sprites_iter.next();
                while self
                    .monochrome_sprites_iter
                    .next_if(|sprite| {
                        precedes_limit(sprite.order, batch_kind, max_order_and_kind)
                            && sprite.tile.texture_id == texture_id
                    })
                    .is_some()
                {
                    sprites_end += 1;
                }
                self.monochrome_sprites_start = sprites_end;
                Some(PrimitiveBatch::MonochromeSprites {
                    texture_id,
                    range: sprites_start..sprites_end,
                })
            }
            PrimitiveKind::SubpixelSprite => {
                let texture_id = self.subpixel_sprites_iter.peek().unwrap().tile.texture_id;
                let sprites_start = self.subpixel_sprites_start;
                let mut sprites_end = sprites_start + 1;
                self.subpixel_sprites_iter.next();
                while self
                    .subpixel_sprites_iter
                    .next_if(|sprite| {
                        precedes_limit(sprite.order, batch_kind, max_order_and_kind)
                            && sprite.tile.texture_id == texture_id
                    })
                    .is_some()
                {
                    sprites_end += 1;
                }
                self.subpixel_sprites_start = sprites_end;
                Some(PrimitiveBatch::SubpixelSprites {
                    texture_id,
                    range: sprites_start..sprites_end,
                })
            }
            PrimitiveKind::PolychromeSprite => {
                let first_sprite = self.polychrome_sprites_iter.peek().unwrap();
                let texture_id = first_sprite.tile.texture_id;
                let smoothed = has_corner_smoothing(first_sprite.corner_smoothing);
                let sprites_start = self.polychrome_sprites_start;
                let mut sprites_end = sprites_start + 1;
                self.polychrome_sprites_iter.next();
                while self
                    .polychrome_sprites_iter
                    .next_if(|sprite| {
                        precedes_limit(sprite.order, batch_kind, max_order_and_kind)
                            && sprite.tile.texture_id == texture_id
                            && has_corner_smoothing(sprite.corner_smoothing) == smoothed
                    })
                    .is_some()
                {
                    sprites_end += 1;
                }
                self.polychrome_sprites_start = sprites_end;
                Some(PrimitiveBatch::PolychromeSprites {
                    texture_id,
                    range: sprites_start..sprites_end,
                    smoothed,
                })
            }
            PrimitiveKind::Surface => {
                let surfaces_start = self.surfaces_start;
                let mut surfaces_end = surfaces_start + 1;
                self.surfaces_iter.next();
                while self
                    .surfaces_iter
                    .next_if(|surface| {
                        precedes_limit(surface.order, batch_kind, max_order_and_kind)
                    })
                    .is_some()
                {
                    surfaces_end += 1;
                }
                self.surfaces_start = surfaces_end;
                Some(PrimitiveBatch::Surfaces(surfaces_start..surfaces_end))
            }
            PrimitiveKind::BackdropFilter => {
                let backdrop_filters_start = self.backdrop_filters_start;
                let mut backdrop_filters_end = backdrop_filters_start + 1;
                self.backdrop_filters_iter.next();
                while self
                    .backdrop_filters_iter
                    .next_if(|filter| precedes_limit(filter.order, batch_kind, max_order_and_kind))
                    .is_some()
                {
                    backdrop_filters_end += 1;
                }
                self.backdrop_filters_start = backdrop_filters_end;
                Some(PrimitiveBatch::BackdropFilters(
                    backdrop_filters_start..backdrop_filters_end,
                ))
            }
            // Boundaries are emitted one at a time (never merged) so the renderer can switch
            // render targets at exactly the right point in the batch stream.
            PrimitiveKind::FilterBoundaryStart | PrimitiveKind::FilterBoundaryEnd => {
                let index = self.filter_boundaries_start;
                self.filter_boundaries_iter.next();
                self.filter_boundaries_start = index + 1;
                Some(PrimitiveBatch::FilterBoundary(index))
            }
        }
    }
}

/// A filled rectangle with an optional border and rounded corners, in scaled pixels.
///
/// This is the scene form of a [`crate::PaintQuad`]. [`crate::Window::paint_quad`] creates it for you, so build a
/// [`crate::PaintQuad`] with [`crate::fill`], [`crate::outline`] or [`crate::quad`] instead.
#[derive(Debug, Copy, Clone)]
#[repr(C)]
pub struct Quad {
    /// The draw order. [`Scene::insert_primitive`] assigns it. Set it to `0` when you build a quad.
    pub order: DrawOrder,
    /// Whether the border is [`BorderStyle::Solid`] or [`BorderStyle::Dashed`].
    pub border_style: BorderStyle,
    /// The length of each dash of a dashed border, as a multiple of the border width.
    pub border_dashed_length: f32,
    /// The gap between dashes of a dashed border, as a multiple of the border width.
    pub border_dashed_gap: f32,
    /// The rectangle to fill, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this quad.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The fill. Use a transparent background to draw only the border.
    pub background: Background,
    /// The color of the border.
    pub border_color: Background,
    /// The radius of each corner, in scaled pixels. A radius larger than half the quad's size
    /// produces sharp corners where the arcs meet.
    pub corner_radii: Corners<ScaledPixels>,
    /// The width of each border edge, in scaled pixels.
    pub border_widths: Edges<ScaledPixels>,
    /// How smooth the corners are, from `0.0` for circular arcs to `1.0`. Set by
    /// [`crate::Window::paint_quad_with_corner_smoothing`].
    pub corner_smoothing: f32,
    /// Padding for the GPU struct layout. [`crate::Window`] always sets it to `0`.
    pub padding: u32,
}

impl Default for Quad {
    fn default() -> Self {
        Self {
            order: Default::default(),
            border_style: Default::default(),
            border_dashed_length: DEFAULT_BORDER_DASHED_LENGTH,
            border_dashed_gap: DEFAULT_BORDER_DASHED_GAP,
            bounds: Default::default(),
            content_mask: Default::default(),
            background: Default::default(),
            border_color: Default::default(),
            corner_radii: Default::default(),
            border_widths: Default::default(),
            corner_smoothing: Default::default(),
            padding: Default::default(),
        }
    }
}

impl From<Quad> for Primitive {
    fn from(quad: Quad) -> Self {
        Primitive::Quad(quad)
    }
}

/// A horizontal line under or through text, which can be wavy.
///
/// Produced by [`crate::Window::paint_underline`] and [`crate::Window::paint_strikethrough`].
#[derive(Debug, Copy, Clone)]
#[repr(C)]
pub struct Underline {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// Padding for the GPU struct layout. [`crate::Window`] always sets it to `0`.
    pub padding: u32,
    /// The line's full rectangle, in scaled pixels. This remains the phase origin for wavy lines.
    pub bounds: Bounds<ScaledPixels>,
    /// The hard clip rectangle, independent of the content mask's fade ramp.
    ///
    /// This can be narrowed to split a line around exclusions without changing its geometry or
    /// moving the origin of a wavy underline.
    pub clip_bounds: Bounds<ScaledPixels>,
    /// The region that clips this line and supplies its edge fade.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The color of the line.
    pub color: SceneHsla,
    /// The thickness of the line, in scaled pixels.
    pub thickness: ScaledPixels,
    /// Draws a wavy line when [`ShaderBool::Enabled`].
    pub wavy: ShaderBool,
}

impl From<Underline> for Primitive {
    fn from(underline: Underline) -> Self {
        Primitive::Underline(underline)
    }
}

/// A blurred shadow of a rounded rectangle. It is drawn outside the element, or inside it when
/// [`Shadow::inset`] is set.
///
/// Produced by [`crate::Window::paint_drop_shadows`] and [`crate::Window::paint_inset_shadows`].
#[derive(Debug, Copy, Clone)]
#[repr(C)]
pub struct Shadow {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// The blur radius, in scaled pixels.
    pub blur_radius: ScaledPixels,
    /// The rectangle that the shadow is drawn for, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The corner radii of the shadow, in scaled pixels.
    pub corner_radii: Corners<ScaledPixels>,
    /// The region that clips this shadow.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The color of the shadow.
    pub color: Background,
    /// The bounds of the element that casts the shadow, in scaled pixels.
    pub element_bounds: Bounds<ScaledPixels>,
    /// The corner radii of [`Shadow::element_bounds`], in scaled pixels.
    pub element_corner_radii: Corners<ScaledPixels>,
    /// Whether this shadow is rendered inside the element instead of outside it.
    pub inset: ShaderBool,
    /// How smooth the corners are, from `0.0` for circular arcs to `1.0`.
    pub corner_smoothing: f32,
}

impl From<Shadow> for Primitive {
    fn from(shadow: Shadow) -> Self {
        Primitive::Shadow(shadow)
    }
}

/// A filter applied to the content already painted behind `bounds`, composited into a rounded
/// rectangle. A blur gives the frosted-glass effect.
///
/// Produced by [`crate::Window::paint_backdrop_filter`]. It is only emitted when its filter chain is not
/// empty, since identity filters are dropped at paint time.
#[derive(Default, Debug, Clone)]
pub struct BackdropFilter {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// The rectangle that receives the filtered backdrop, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this filter.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The corner radii of [`BackdropFilter::bounds`], in scaled pixels.
    pub corner_radii: Corners<ScaledPixels>,
    /// How smooth the corners are, from `0.0` for circular arcs to `1.0`.
    pub corner_smoothing: f32,
    /// The filter chain applied to the backdrop, in scene (device-pixel) space. Identity filters
    /// are dropped at paint time, so a `BackdropFilter` is only emitted when this is non-empty.
    ///
    /// Inline capacity is 4: a `SmallVec<[ScaledFilter; 4]>` is the same size as capacity 1 here
    /// (the heap repr already occupies that space), so chains up to 4 filters avoid allocating
    /// at no extra struct size.
    pub filters: SmallVec<[ScaledFilter; 4]>,
    /// The element opacity, multiplied into the composited result.
    pub opacity: f32,
}

impl BackdropFilter {
    /// Returns the largest Gaussian blur radius in this filter chain, in device pixels.
    pub fn max_blur_radius(&self) -> f32 {
        max_blur_radius(&self.filters)
    }
}

impl From<BackdropFilter> for Primitive {
    fn from(filter: BackdropFilter) -> Self {
        Primitive::BackdropFilter(filter)
    }
}

/// The start or end marker of a filter or grouped-opacity isolation group.
///
/// The primitives between a matched pair are drawn into an offscreen target, filtered as one layer,
/// and composited back into bounds. Group opacity is applied once to the completed result.
/// An empty filter chain is opacity-only isolation; nesting may allocate pooled targets beyond the
/// inline target-stack capacity.
/// Produced by [`crate::Window::with_filter_layer`], which inserts a start marker, paints its contents, and
/// inserts the end marker, or by the element-opacity scope.
#[derive(Debug, Clone)]
pub struct FilterBoundary {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// The rectangle that the filtered group is composited into, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this group.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The corner radii of [`FilterBoundary::bounds`], in scaled pixels.
    pub corner_radii: Corners<ScaledPixels>,
    /// How smooth the corners are, from `0.0` for circular arcs to `1.0`.
    pub corner_smoothing: f32,
    /// The filter chain applied to the isolated group, in scene (device-pixel) space. Identity
    /// Identity filters are dropped at paint time; an empty chain represents an opacity-only group.
    /// Inline capacity 4 (same struct size as 1 here — see [`BackdropFilter::filters`]).
    pub filters: SmallVec<[ScaledFilter; 4]>,
    /// Opacity applied once when compositing the completed group into its parent.
    pub opacity: f32,
    /// `true` for the start marker, which opens the group. `false` for the end marker, which closes it.
    pub is_start: bool,
}

impl FilterBoundary {
    /// Returns the largest Gaussian blur radius in this filter chain, in device pixels.
    pub fn max_blur_radius(&self) -> f32 {
        max_blur_radius(&self.filters)
    }
}

/// Returns the largest blur radius in a scene-space filter chain.
///
/// This match is deliberately exhaustive so adding a filter requires one shared scheduling
/// decision instead of three backend-specific implementations that can drift.
fn max_blur_radius(filters: &[ScaledFilter]) -> f32 {
    filters.iter().fold(0.0, |radius, filter| match filter {
        ScaledFilter::Blur(filter_radius) => radius.max(filter_radius.0),
    })
}

impl From<FilterBoundary> for Primitive {
    fn from(boundary: FilterBoundary) -> Self {
        Primitive::FilterBoundary(boundary)
    }
}

/// The style of a [`Quad`] border.
#[derive(Default, Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize, JsonSchema)]
#[repr(u32)]
pub enum BorderStyle {
    /// A solid border.
    #[default]
    Solid = 0,
    /// A dashed border.
    Dashed = 1,
}

/// A 2D affine transform in scaled pixels: a 2x2 linear part and a translation.
///
/// Sprites carry one in [`MonochromeSprite::transformation`] and [`SubpixelSprite::transformation`].
/// Start from [`TransformationMatrix::unit`] and chain calls to build a transform. When you chain
/// calls, the transform from the last call is applied to a point first.
///
/// # Examples
///
/// ```
/// # use gpui::{ScaledPixels, TransformationMatrix, point, px, size};
/// let moved = TransformationMatrix::unit().translate(point(ScaledPixels(10.), ScaledPixels(5.)));
/// assert_eq!(moved.apply(point(px(1.), px(2.))), point(px(11.), px(7.)));
///
/// let scaled = TransformationMatrix::unit().scale(size(2., 3.));
/// assert_eq!(scaled.apply(point(px(1.), px(1.))), point(px(2.), px(3.)));
///
/// // The translation is applied first, then the scale.
/// let chained = TransformationMatrix::unit()
///     .scale(size(2., 3.))
///     .translate(point(ScaledPixels(10.), ScaledPixels(5.)));
/// assert_eq!(chained.apply(point(px(1.), px(1.))), point(px(22.), px(18.)));
/// ```
#[derive(Debug, Clone, Copy, PartialEq)]
#[repr(C)]
pub struct TransformationMatrix {
    /// 2x2 matrix containing rotation and scale,
    /// stored row-major
    pub rotation_scale: [[f32; 2]; 2],
    /// translation vector
    pub translation: [f32; 2],
}

impl Eq for TransformationMatrix {}

impl TransformationMatrix {
    /// Returns the identity transform, which leaves points unchanged.
    pub fn unit() -> Self {
        Self {
            rotation_scale: [[1.0, 0.0], [0.0, 1.0]],
            translation: [0.0, 0.0],
        }
    }

    /// Returns this transform combined with a translation by `point`. The translation is applied to
    /// points before this transform.
    pub fn translate(mut self, point: Point<ScaledPixels>) -> Self {
        self.compose(Self {
            rotation_scale: [[1.0, 0.0], [0.0, 1.0]],
            translation: [point.x.0, point.y.0],
        })
    }

    /// Returns this transform combined with a clockwise rotation by `angle` around the origin. Clockwise
    /// is on screen, where the y axis points down.
    pub fn rotate(self, angle: Radians) -> Self {
        self.compose(Self {
            rotation_scale: [
                [angle.0.cos(), -angle.0.sin()],
                [angle.0.sin(), angle.0.cos()],
            ],
            translation: [0.0, 0.0],
        })
    }

    /// Returns this transform combined with a scale by `size` around the origin.
    pub fn scale(self, size: Size<f32>) -> Self {
        self.compose(Self {
            rotation_scale: [[size.width, 0.0], [0.0, size.height]],
            translation: [0.0, 0.0],
        })
    }

    /// Returns `self` combined with `other`, so that `other` is applied to points first. This is the
    /// matrix product `self * other`.
    #[inline]
    pub fn compose(self, other: TransformationMatrix) -> TransformationMatrix {
        if other == Self::unit() {
            return self;
        }
        // Perform matrix multiplication
        TransformationMatrix {
            rotation_scale: [
                [
                    self.rotation_scale[0][0] * other.rotation_scale[0][0]
                        + self.rotation_scale[0][1] * other.rotation_scale[1][0],
                    self.rotation_scale[0][0] * other.rotation_scale[0][1]
                        + self.rotation_scale[0][1] * other.rotation_scale[1][1],
                ],
                [
                    self.rotation_scale[1][0] * other.rotation_scale[0][0]
                        + self.rotation_scale[1][1] * other.rotation_scale[1][0],
                    self.rotation_scale[1][0] * other.rotation_scale[0][1]
                        + self.rotation_scale[1][1] * other.rotation_scale[1][1],
                ],
            ],
            translation: [
                self.translation[0]
                    + self.rotation_scale[0][0] * other.translation[0]
                    + self.rotation_scale[0][1] * other.translation[1],
                self.translation[1]
                    + self.rotation_scale[1][0] * other.translation[0]
                    + self.rotation_scale[1][1] * other.translation[1],
            ],
        }
    }

    /// Returns `point` transformed by this matrix.
    pub fn apply(&self, point: Point<Pixels>) -> Point<Pixels> {
        let input = [point.x.0, point.y.0];
        let mut output = self.translation;
        for (i, output_cell) in output.iter_mut().enumerate() {
            for (k, input_cell) in input.iter().enumerate() {
                *output_cell += self.rotation_scale[i][k] * *input_cell;
            }
        }
        Point::new(output[0].into(), output[1].into())
    }
}

impl Default for TransformationMatrix {
    fn default() -> Self {
        Self::unit()
    }
}

/// A single-color sprite: an alpha mask from the sprite atlas, tinted with `color`.
///
/// Produced by [`crate::Window::paint_svg`] for icons, and by [`crate::Window::paint_glyph`] for glyphs that are
/// drawn as alpha masks.
#[derive(Copy, Clone, Debug)]
#[repr(C)]
pub struct MonochromeSprite {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// Padding for the GPU struct layout. [`crate::Window`] always sets it to `0`.
    pub padding: u32,
    /// The rectangle to draw into, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this sprite.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The tint color.
    pub color: SceneHsla,
    /// The atlas tile that holds the mask.
    pub tile: AtlasTile,
    /// The transform applied to the sprite, around its origin.
    pub transformation: TransformationMatrix,
}

impl From<MonochromeSprite> for Primitive {
    fn from(sprite: MonochromeSprite) -> Self {
        Primitive::MonochromeSprite(sprite)
    }
}

/// A glyph drawn with subpixel anti-aliasing, tinted with `color`.
///
/// Produced by [`crate::Window::paint_glyph`] for glyphs that use subpixel rendering.
#[derive(Copy, Clone, Debug)]
#[repr(C)]
pub struct SubpixelSprite {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// Padding for the GPU struct layout. [`crate::Window`] always sets it to `0`.
    pub padding: u32,
    /// The rectangle to draw into, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this sprite.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The tint color.
    pub color: SceneHsla,
    /// The atlas tile that holds the glyph.
    pub tile: AtlasTile,
    /// The transform applied to the sprite, around its origin.
    pub transformation: TransformationMatrix,
}

impl From<SubpixelSprite> for Primitive {
    fn from(sprite: SubpixelSprite) -> Self {
        Primitive::SubpixelSprite(sprite)
    }
}

/// A sprite whose colors come from the atlas as they are, such as an image or a color emoji.
///
/// Produced by [`crate::Window::paint_image`] and [`crate::Window::paint_emoji`], and by [`crate::Window::paint_glyph`]
/// for color glyphs.
#[derive(Copy, Clone, Debug)]
#[repr(C)]
pub struct PolychromeSprite {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// Draws the sprite in grayscale when [`ShaderBool::Enabled`].
    pub grayscale: ShaderBool,
    /// The opacity, multiplied into the sprite's alpha.
    pub opacity: f32,
    /// How smooth the corners are, from `0.0` for circular arcs to `1.0`.
    pub corner_smoothing: f32,
    /// The rectangle to draw into, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this sprite.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The corner radii of [`PolychromeSprite::bounds`], in scaled pixels.
    pub corner_radii: Corners<ScaledPixels>,
    /// The atlas tile that holds the pixels.
    pub tile: AtlasTile,
}

impl From<PolychromeSprite> for Primitive {
    fn from(sprite: PolychromeSprite) -> Self {
        Primitive::PolychromeSprite(sprite)
    }
}

/// A surface produced outside GPUI, such as a video frame, drawn as a rectangle.
///
/// Produced by [`crate::Window::paint_surface`].
#[derive(Clone, Debug)]
pub struct PaintSurface {
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// The rectangle to draw into, in scaled pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The region that clips this surface.
    pub content_mask: ContentMask<ScaledPixels>,
    /// Where the pixels come from for the cross-platform packet renderer.
    pub source: crate::SurfaceSource,
    /// Native Apple pixel buffer retained for the upstream platform surface seam.
    #[cfg(any(target_os = "macos", target_os = "ios"))]
    pub image_buffer: Option<objc2_core_foundation::CFRetained<objc2_core_video::CVPixelBuffer>>,
}

impl From<PaintSurface> for Primitive {
    fn from(surface: PaintSurface) -> Self {
        Primitive::Surface(surface)
    }
}

/// Identifies a [`Path`] by the index it had in [`Scene::paths`] when the path was inserted. The
/// scene assigns it at that point, and [`Scene::finish`] may sort the paths afterwards.
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash)]
pub struct PathId(pub usize);

/// A filled shape, stored as a triangle mesh.
///
/// Use [`crate::PathBuilder`] to build a path from lines and curves, and [`crate::Window::paint_path`] to paint
/// it. The methods on this type add triangles one at a time, which is lower level than
/// [`crate::PathBuilder`].
///
/// # Examples
///
/// ```
/// # use gpui::{Path, point, px};
/// let mut path = Path::new(point(px(0.), px(0.)));
/// path.line_to(point(px(10.), px(0.)));
/// path.line_to(point(px(10.), px(10.)));
/// assert_eq!(path.vertices.len(), 3);
/// ```
#[derive(Clone, Debug)]
pub struct Path<P: Clone + Debug + Default + PartialEq> {
    /// The index this path had in [`Scene::paths`] when it was inserted.
    pub id: PathId,
    /// The draw order. [`Scene::insert_primitive`] assigns it.
    pub order: DrawOrder,
    /// The bounding box of all vertices.
    pub bounds: Bounds<P>,
    /// The region that clips this path.
    pub content_mask: ContentMask<P>,
    /// The triangle vertices, three per triangle.
    pub vertices: Vec<PathVertex<P>>,
    /// The fill color or gradient.
    pub color: Background,
    start: Point<P>,
    current: Point<P>,
    contour_count: usize,
}

impl Path<Pixels> {
    /// Creates an empty path whose current point is `start`. The path has no area until it has a
    /// second segment.
    pub fn new(start: Point<Pixels>) -> Self {
        Self {
            id: PathId(0),
            order: DrawOrder::default(),
            vertices: Vec::new(),
            start,
            current: start,
            bounds: Bounds {
                origin: start,
                size: Default::default(),
            },
            content_mask: Default::default(),
            color: Default::default(),
            contour_count: 0,
        }
    }

    /// Returns a copy of this path with every coordinate multiplied by `factor`. Use it to convert
    /// logical pixels to scaled pixels.
    pub fn scale(&self, factor: f32) -> Path<ScaledPixels> {
        Path {
            id: self.id,
            order: self.order,
            bounds: self.bounds.scale(factor),
            content_mask: self.content_mask.scale(factor),
            vertices: self
                .vertices
                .iter()
                .map(|vertex| vertex.scale(factor))
                .collect(),
            start: self.start.map(|start| start.scale(factor)),
            current: self.current.scale(factor),
            contour_count: self.contour_count,
            color: self.color,
        }
    }

    /// Moves the current point to `to` and starts a new contour there. Nothing is drawn.
    pub fn move_to(&mut self, to: Point<Pixels>) {
        self.contour_count += 1;
        self.start = to;
        self.current = to;
    }

    /// Draws a straight line from the current point to `to`.
    ///
    /// The first call after [`Path::new`] only moves the current point. Each later call adds a triangle
    /// made from the contour's start point, the current point and `to`.
    pub fn line_to(&mut self, to: Point<Pixels>) {
        self.contour_count += 1;
        if self.contour_count > 1 {
            self.push_triangle(
                (self.start, self.current, to),
                (point(0., 1.), point(0., 1.), point(0., 1.)),
            );
        }
        self.current = to;
    }

    /// Draws a quadratic curve from the current point to `to`, bent toward the control point `ctrl`.
    pub fn curve_to(&mut self, to: Point<Pixels>, ctrl: Point<Pixels>) {
        self.contour_count += 1;
        if self.contour_count > 1 {
            self.push_triangle(
                (self.start, self.current, to),
                (point(0., 1.), point(0., 1.), point(0., 1.)),
            );
        }

        self.push_triangle(
            (self.current, ctrl, to),
            (point(0., 0.), point(0.5, 0.), point(1., 1.)),
        );
        self.current = to;
    }

    /// Appends one triangle, with positions and shader coordinates for each corner, and grows
    /// [`Path::bounds`] to include it.
    pub fn push_triangle(
        &mut self,
        xy: (Point<Pixels>, Point<Pixels>, Point<Pixels>),
        st: (Point<f32>, Point<f32>, Point<f32>),
    ) {
        self.bounds = self
            .bounds
            .union(&Bounds {
                origin: xy.0,
                size: Default::default(),
            })
            .union(&Bounds {
                origin: xy.1,
                size: Default::default(),
            })
            .union(&Bounds {
                origin: xy.2,
                size: Default::default(),
            });

        self.vertices.push(PathVertex {
            xy_position: xy.0,
            st_position: st.0,
            content_mask: Default::default(),
        });
        self.vertices.push(PathVertex {
            xy_position: xy.1,
            st_position: st.1,
            content_mask: Default::default(),
        });
        self.vertices.push(PathVertex {
            xy_position: xy.2,
            st_position: st.2,
            content_mask: Default::default(),
        });
    }
}

impl<T> Path<T>
where
    T: Clone + Debug + Default + PartialEq + PartialOrd + Add<T, Output = T> + Sub<Output = T>,
{
    /// Returns [`Path::bounds`] intersected with the content mask.
    #[allow(unused)]
    pub fn clipped_bounds(&self) -> Bounds<T> {
        self.bounds.intersect(&self.content_mask.bounds)
    }
}

impl From<Path<ScaledPixels>> for Primitive {
    fn from(path: Path<ScaledPixels>) -> Self {
        Primitive::Path(path)
    }
}

/// A vertex of a [`Path`] triangle.
#[derive(Clone, Debug)]
#[repr(C)]
pub struct PathVertex<P: Clone + Debug + Default + PartialEq> {
    /// The position of the vertex.
    pub xy_position: Point<P>,
    /// Shader coordinates that tell the renderer where the vertex sits on a curve. Straight edges
    /// use `(0, 1)`. A curve from [`Path::curve_to`] uses `(0, 0)`, `(0.5, 0)` and `(1, 1)`.
    pub st_position: Point<f32>,
    /// The content mask of this vertex. [`crate::Window::paint_path`] leaves it at its default.
    pub content_mask: ContentMask<P>,
}

impl PathVertex<Pixels> {
    /// Returns this vertex with its position and content mask multiplied by `factor`.
    pub fn scale(&self, factor: f32) -> PathVertex<ScaledPixels> {
        PathVertex {
            xy_position: self.xy_position.scale(factor),
            st_position: self.st_position,
            content_mask: self.content_mask.scale(factor),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{AtlasTextureKind, DevicePixels, Point, ShaderBool, Size, SurfaceSource, TileId};

    fn sp(value: f32) -> ScaledPixels {
        ScaledPixels(value)
    }

    /// All test primitives cover the same region so the bounds tree assigns strictly
    /// increasing orders in insertion order — making the expected batch order deterministic.
    fn full_bounds() -> Bounds<ScaledPixels> {
        Bounds {
            origin: Point {
                x: sp(0.0),
                y: sp(0.0),
            },
            size: Size {
                width: sp(100.0),
                height: sp(100.0),
            },
        }
    }

    fn mask() -> ContentMask<ScaledPixels> {
        ContentMask {
            bounds: full_bounds(),
            ..Default::default()
        }
    }

    fn quad() -> Quad {
        Quad {
            bounds: full_bounds(),
            content_mask: mask(),
            ..Default::default()
        }
    }

    #[test]
    fn full_scene_transfer_eligibility_requires_a_finished_scene_only() {
        let mut unfinished = Scene::default();
        unfinished.insert_primitive(quad());
        assert!(!unfinished.can_transfer_full_scene());

        let mut ordinary = Scene::default();
        ordinary.insert_primitive(quad());
        ordinary.finish();
        assert!(ordinary.can_transfer_full_scene());

        let mut layered = Scene::default();
        layered.push_layer(full_bounds());
        layered.insert_primitive(quad());
        layered.pop_layer();
        layered.finish();
        assert!(layered.can_transfer_full_scene());

        let mut raised_floor = Scene::default();
        raised_floor.raise_order_floor();
        raised_floor.insert_primitive(quad());
        raised_floor.finish();
        assert!(raised_floor.can_transfer_full_scene());

        let mut filtered = Scene::default();
        filtered.insert_primitive(boundary(true));
        filtered.insert_primitive(quad());
        filtered.insert_primitive(boundary(false));
        filtered.finish();
        assert!(filtered.can_transfer_full_scene());

        let mut with_backdrop = Scene::default();
        with_backdrop.insert_primitive(backdrop());
        with_backdrop.finish();
        assert!(with_backdrop.can_transfer_full_scene());

        let mut with_surface = Scene::default();
        with_surface.insert_primitive(surface());
        with_surface.finish();
        assert!(with_surface.can_transfer_full_scene());
    }

    #[test]
    fn underline_paint_bounds_intersect_geometry_clip_and_content_mask() {
        let underline = Underline {
            order: 0,
            padding: 0,
            bounds: Bounds {
                origin: Point {
                    x: sp(10.0),
                    y: sp(10.0),
                },
                size: Size {
                    width: sp(45.0),
                    height: sp(25.0),
                },
            },
            clip_bounds: Bounds {
                origin: Point {
                    x: sp(30.0),
                    y: sp(15.0),
                },
                size: Size {
                    width: sp(60.0),
                    height: sp(25.0),
                },
            },
            content_mask: ContentMask {
                bounds: Bounds {
                    origin: Point {
                        x: sp(25.0),
                        y: sp(20.0),
                    },
                    size: Size {
                        width: sp(45.0),
                        height: sp(10.0),
                    },
                },
                ..Default::default()
            },
            color: Default::default(),
            thickness: sp(1.0),
            wavy: ShaderBool::Disabled,
        };

        assert_eq!(
            Primitive::Underline(underline).paint_bounds(),
            Bounds {
                origin: Point {
                    x: sp(30.0),
                    y: sp(20.0)
                },
                size: Size {
                    width: sp(25.0),
                    height: sp(10.0)
                },
            }
        );
    }

    fn shadow() -> Shadow {
        Shadow {
            order: 0,
            blur_radius: sp(0.0),
            bounds: full_bounds(),
            corner_radii: Corners::default(),
            content_mask: mask(),
            color: Default::default(),
            element_bounds: full_bounds(),
            element_corner_radii: Corners::default(),
            inset: ShaderBool::Disabled,
            corner_smoothing: 0.0,
        }
    }

    fn subpixel_sprite() -> SubpixelSprite {
        SubpixelSprite {
            order: 0,
            padding: 0,
            bounds: full_bounds(),
            content_mask: mask(),
            color: Default::default(),
            tile: AtlasTile {
                texture_id: AtlasTextureId {
                    index: 0,
                    kind: AtlasTextureKind::Subpixel,
                },
                tile_id: TileId(0),
                padding: 0,
                bounds: Bounds::<DevicePixels>::default(),
            },
            transformation: TransformationMatrix::unit(),
        }
    }

    fn polychrome_sprite(texture_index: u32) -> PolychromeSprite {
        PolychromeSprite {
            order: 0,
            grayscale: ShaderBool::Disabled,
            opacity: 1.0,
            corner_smoothing: 0.0,
            bounds: full_bounds(),
            content_mask: mask(),
            corner_radii: Corners::default(),
            tile: AtlasTile {
                texture_id: AtlasTextureId {
                    index: texture_index,
                    kind: AtlasTextureKind::Polychrome,
                },
                tile_id: TileId(0),
                padding: 0,
                bounds: Bounds::<DevicePixels>::default(),
            },
        }
    }

    fn monochrome_sprite(
        content_mask: ContentMask<ScaledPixels>,
        transformation: TransformationMatrix,
    ) -> MonochromeSprite {
        MonochromeSprite {
            order: 0,
            padding: 0,
            // Three wide and two tall, before the transformation.
            bounds: Bounds {
                origin: Point {
                    x: sp(0.0),
                    y: sp(0.0),
                },
                size: Size {
                    width: sp(3.0),
                    height: sp(2.0),
                },
            },
            content_mask,
            color: Default::default(),
            tile: AtlasTile {
                texture_id: AtlasTextureId {
                    index: 0,
                    kind: AtlasTextureKind::Monochrome,
                },
                tile_id: TileId(0),
                padding: 0,
                bounds: Bounds::<DevicePixels>::default(),
            },
            transformation,
        }
    }

    /// Rotates a quarter turn, so the sprite covers x in 3..5 and y in 1..4.
    fn rotated_sprite_transform() -> TransformationMatrix {
        TransformationMatrix {
            rotation_scale: [[0.0, -1.0], [1.0, 0.0]],
            translation: [5.0, 1.0],
        }
    }

    fn mask_at(x: f32, y: f32, width: f32, height: f32) -> ContentMask<ScaledPixels> {
        ContentMask {
            bounds: Bounds {
                origin: Point { x: sp(x), y: sp(y) },
                size: Size {
                    width: sp(width),
                    height: sp(height),
                },
            },
            ..Default::default()
        }
    }

    #[test]
    fn transformed_sprite_is_clipped_by_its_transformed_bounds() {
        // The mask only overlaps the rotated sprite.
        let mut scene = Scene::default();
        scene.insert_primitive(monochrome_sprite(
            mask_at(3.0, 1.0, 1.0, 3.0),
            rotated_sprite_transform(),
        ));
        assert_eq!(scene.monochrome_sprites.len(), 1);

        // The mask only overlaps the sprite before it is rotated.
        let mut scene = Scene::default();
        scene.insert_primitive(monochrome_sprite(
            mask_at(0.0, 0.0, 1.0, 1.0),
            rotated_sprite_transform(),
        ));
        assert!(scene.monochrome_sprites.is_empty());
    }

    #[test]
    fn transformed_sprite_overlap_preserves_order_against_quads() {
        let mut scene = Scene::default();
        let mut background = quad();
        background.bounds = Bounds {
            origin: Point {
                x: sp(3.5),
                y: sp(1.5),
            },
            size: Size {
                width: sp(1.0),
                height: sp(1.0),
            },
        };
        scene.insert_primitive(background);
        scene.insert_primitive(monochrome_sprite(mask(), rotated_sprite_transform()));

        assert!(
            scene.monochrome_sprites[0].order > scene.quads[0].order,
            "the later transformed sprite must sort above the overlapping quad"
        );
    }

    fn batches(scene: &mut Scene) -> Vec<PrimitiveBatch> {
        scene.finish();
        scene.batches().collect()
    }

    #[test]
    fn smoothing_and_texture_changes_define_batches() {
        let mut scene = Scene::default();
        for smoothing in [0.0, 0.0, 0.5, 1.0, 0.0] {
            let mut quad = quad();
            quad.corner_smoothing = smoothing;
            scene.insert_primitive(quad);
        }

        for smoothing in [0.0, 0.0, 0.5, 1.0, 0.0] {
            let mut shadow = shadow();
            shadow.corner_smoothing = smoothing;
            scene.insert_primitive(shadow);
        }

        for (texture, smoothing) in [
            (0, 0.0),
            (0, 0.0),
            (0, 0.5),
            (0, 1.0),
            (1, 1.0),
            (1, 0.5),
            (1, 0.0),
        ] {
            let mut sprite = polychrome_sprite(texture);
            sprite.corner_smoothing = smoothing;
            scene.insert_primitive(sprite);
        }

        let batch_signatures = batches(&mut scene)
            .into_iter()
            .map(|batch| match batch {
                PrimitiveBatch::Quads { range, smoothed } => ("quad", None, range, smoothed),
                PrimitiveBatch::Shadows { range, smoothed } => ("shadow", None, range, smoothed),
                PrimitiveBatch::PolychromeSprites {
                    texture_id,
                    range,
                    smoothed,
                } => ("polychrome", Some(texture_id.index), range, smoothed),
                other => panic!("unexpected batch: {other:?}"),
            })
            .collect::<Vec<_>>();
        assert_eq!(
            batch_signatures,
            vec![
                ("quad", None, 0..2, false),
                ("quad", None, 2..4, true),
                ("quad", None, 4..5, false),
                ("shadow", None, 0..2, false),
                ("shadow", None, 2..4, true),
                ("shadow", None, 4..5, false),
                ("polychrome", Some(0), 0..2, false),
                ("polychrome", Some(0), 2..4, true),
                ("polychrome", Some(1), 4..6, true),
                ("polychrome", Some(1), 6..7, false),
            ]
        );
    }

    /// A 100x100 quad whose bounds don't overlap `full_bounds()` (used to exercise the
    /// order-reuse path: non-overlapping content reuses low draw-orders).
    fn detached_quad() -> Quad {
        let bounds = Bounds {
            origin: Point {
                x: sp(200.0),
                y: sp(200.0),
            },
            size: Size {
                width: sp(100.0),
                height: sp(100.0),
            },
        };
        Quad {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            ..Default::default()
        }
    }

    fn boundary(is_start: bool) -> FilterBoundary {
        FilterBoundary {
            order: 0,
            bounds: full_bounds(),
            content_mask: mask(),
            corner_radii: Corners::default(),
            corner_smoothing: 0.0,
            filters: smallvec::smallvec![ScaledFilter::Blur(sp(8.0))],
            opacity: 1.0,
            is_start,
        }
    }

    fn backdrop() -> BackdropFilter {
        BackdropFilter {
            bounds: full_bounds(),
            content_mask: mask(),
            corner_radii: Corners::default(),
            filters: smallvec::smallvec![ScaledFilter::Blur(sp(20.0))],
            opacity: 1.0,
            ..Default::default()
        }
    }

    fn surface() -> PaintSurface {
        PaintSurface {
            order: 0,
            bounds: full_bounds(),
            content_mask: mask(),
            source: SurfaceSource::Unsupported(Size::default()),
            #[cfg(any(target_os = "macos", target_os = "ios"))]
            image_buffer: None,
        }
    }

    fn tagged_surface(tag: i32) -> PaintSurface {
        PaintSurface {
            source: SurfaceSource::Unsupported(Size {
                width: DevicePixels(tag),
                height: DevicePixels(1),
            }),
            ..surface()
        }
    }

    fn path_with_triangles(triangle_count: usize) -> Path<ScaledPixels> {
        let mut path = Path::new(point(crate::px(10.0), crate::px(10.0)));
        let triangle = (
            point(crate::px(10.0), crate::px(10.0)),
            point(crate::px(20.0), crate::px(10.0)),
            point(crate::px(10.0), crate::px(20.0)),
        );
        let st = (point(0.0, 0.0), point(1.0, 0.0), point(0.0, 1.0));
        for _ in 0..triangle_count {
            path.push_triangle(triangle, st);
        }
        let mut path = path.scale(1.0);
        path.bounds = full_bounds();
        path.content_mask = mask();
        path
    }

    fn batch_kinds(scene: &mut Scene) -> Vec<&'static str> {
        scene.finish();
        scene
            .batches()
            .map(|batch| match batch {
                PrimitiveBatch::Quads { .. } => "quad",
                PrimitiveBatch::BackdropFilters(_) => "backdrop",
                PrimitiveBatch::FilterBoundary(ix) => {
                    if scene.filter_boundaries[ix].is_start {
                        "start"
                    } else {
                        "end"
                    }
                }
                _ => "other",
            })
            .collect()
    }

    #[test]
    fn content_filter_group_brackets_its_children() {
        let mut scene = Scene::default();
        // Background painted before the filtered element.
        scene.insert_primitive(quad());
        // A content-filtered element: start marker, its child, end marker.
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));

        // The start must precede the group's child and the end must follow it, so the
        // renderer can redirect rendering for exactly the group's span.
        assert_eq!(
            batch_kinds(&mut scene),
            vec!["quad", "start", "quad", "end"]
        );
    }

    #[test]
    fn replay_inside_opacity_group_converts_cached_subpixel_glyphs_to_monochrome() {
        let mut previous = Scene::default();
        previous.insert_primitive(subpixel_sprite());
        previous.finish();

        let mut replayed = Scene::default();
        let mut start = boundary(true);
        start.opacity = 0.5;
        replayed.insert_primitive(start);
        replayed.replay(0..previous.paint_operations.len(), &previous);
        let mut end = boundary(false);
        end.opacity = 0.5;
        replayed.insert_primitive(end);
        replayed.finish();

        assert!(replayed.subpixel_sprites.is_empty());
        assert_eq!(replayed.monochrome_sprites.len(), 1);
        assert!(matches!(
            replayed.render_commands(),
            [
                RenderCommand::BeginFilter { .. },
                RenderCommand::Batch(PrimitiveBatch::MonochromeSprites { .. }),
                RenderCommand::EndFilter { .. }
            ]
        ));
    }

    #[test]
    fn replay_matches_forced_fresh_scene_across_group_layers_surfaces_and_order_barriers() {
        fn paint(scene: &mut Scene) {
            scene.insert_primitive(quad());
            scene.push_layer(full_bounds());
            scene.insert_primitive(quad());
            scene.pop_layer();
            let mut outer = boundary(true);
            outer.opacity = 0.35;
            scene.insert_primitive(outer);
            let mut inner = boundary(true);
            inner.filters.clear();
            inner.opacity = 0.6;
            scene.insert_primitive(inner);
            scene.insert_primitive(Primitive::Surface(tagged_surface(44)));
            scene.insert_primitive(backdrop());
            scene.insert_primitive(quad());
            let mut inner_end = boundary(false);
            inner_end.opacity = 0.6;
            scene.insert_primitive(inner_end);
            scene.insert_primitive(quad());
            let mut outer_end = boundary(false);
            outer_end.opacity = 0.35;
            scene.insert_primitive(outer_end);
            scene.raise_order_floor();
            scene.insert_primitive(detached_quad());
        }

        let mut previous = Scene::default();
        paint(&mut previous);
        previous.finish();
        for (quad, order) in previous.quads.iter_mut().zip([3, 1, 2, 4]) {
            quad.order = order;
        }
        for (surface, order) in previous.surfaces.iter_mut().zip([2]) {
            surface.order = order;
        }
        previous.finish();

        let mut replayed = Scene::default();
        replayed.replay(0..previous.paint_operations.len(), &previous);
        replayed.finish();
        let mut forced_fresh = Scene::default();
        paint(&mut forced_fresh);
        forced_fresh.finish();

        assert_eq!(replayed.render_commands(), forced_fresh.render_commands());
        assert_eq!(
            replayed.surface_opacities(),
            forced_fresh.surface_opacities()
        );
        let boundaries = |scene: &Scene| {
            scene
                .filter_boundaries
                .iter()
                .map(|b| (b.is_start, b.opacity, b.filters.len()))
                .collect::<Vec<_>>()
        };
        assert_eq!(boundaries(&replayed), boundaries(&forced_fresh));
        let tags = |scene: &Scene| {
            scene
                .surfaces
                .iter()
                .map(|surface| match &surface.source {
                    SurfaceSource::Unsupported(size) => size.width.0,
                    _ => unreachable!(),
                })
                .collect::<Vec<_>>()
        };
        assert_eq!(tags(&replayed), [44]);
        assert_eq!(tags(&forced_fresh), [44]);
        let close_order = replayed.filter_boundaries.last().unwrap().order;
        assert!(replayed.quads.last().unwrap().order > close_order);
        assert!(replayed.requires_offscreen_rendering());
        assert!(forced_fresh.requires_offscreen_rendering());
    }

    #[test]
    fn replay_resolves_typed_indices_after_every_primitive_lane_is_sorted() {
        let mut scene = Scene::default();
        for smoothing in [0.1, 0.2, 0.3] {
            let mut quad = quad();
            quad.corner_smoothing = smoothing;
            scene.insert_primitive(quad);
        }
        scene.insert_primitive(path_with_triangles(1));
        scene.insert_primitive(path_with_triangles(2));
        for tile_id in [8, 2, 5] {
            let mut sprite = polychrome_sprite(0);
            sprite.tile.tile_id = TileId(tile_id);
            sprite.opacity = tile_id as f32 / 10.0;
            scene.insert_primitive(sprite);
        }
        for (tag, _opacity) in [(10, 0.1), (20, 0.2), (30, 0.3)] {
            let surface = tagged_surface(tag);
            scene.insert_primitive(Primitive::Surface(surface));
        }
        for opacity in [0.1, 0.2] {
            let mut filter = backdrop();
            filter.opacity = opacity;
            scene.insert_primitive(filter);
        }

        // Force non-identity permutations, including stable ties and sprite tile-id sorting.
        for (quad, order) in scene.quads.iter_mut().zip([2, 1, 2]) {
            quad.order = order;
        }
        for (path, order) in scene.paths.iter_mut().zip([2, 1]) {
            path.order = order;
        }
        for sprite in &mut scene.polychrome_sprites {
            sprite.order = 7;
        }
        for (surface, order) in scene.surfaces.iter_mut().zip([3, 1, 2]) {
            surface.order = order;
        }
        for (filter, order) in scene.backdrop_filters.iter_mut().zip([2, 1]) {
            filter.order = order;
        }
        scene.finish();

        assert_eq!(
            scene
                .quads
                .iter()
                .map(|quad| quad.corner_smoothing)
                .collect::<Vec<_>>(),
            [0.2, 0.1, 0.3]
        );
        assert_eq!(
            scene
                .paths
                .iter()
                .map(|path| (path.id, path.vertices.len()))
                .collect::<Vec<_>>(),
            [(PathId(1), 6), (PathId(0), 3)]
        );
        assert_eq!(
            scene
                .polychrome_sprites
                .iter()
                .map(|sprite| (sprite.tile.tile_id, sprite.opacity))
                .collect::<Vec<_>>(),
            [(TileId(2), 0.2), (TileId(5), 0.5), (TileId(8), 0.8)]
        );
        assert_eq!(scene.surface_opacities(), &[1.0, 1.0, 1.0]);
        assert_eq!(
            scene
                .surfaces
                .iter()
                .map(|surface| match &surface.source {
                    SurfaceSource::Unsupported(size) => size.width.0,
                    _ => unreachable!(),
                })
                .collect::<Vec<_>>(),
            [20, 30, 10]
        );
        assert_eq!(
            scene
                .backdrop_filters
                .iter()
                .map(|filter| filter.opacity)
                .collect::<Vec<_>>(),
            [0.2, 0.1]
        );

        let mut replay = Scene::default();
        replay.replay(0..scene.paint_operations.len(), &scene);
        replay.finish();
        assert_eq!(
            replay
                .quads
                .iter()
                .map(|quad| quad.corner_smoothing)
                .collect::<Vec<_>>(),
            [0.1, 0.2, 0.3]
        );
        assert_eq!(
            replay
                .paths
                .iter()
                .map(|path| (path.id, path.vertices.len()))
                .collect::<Vec<_>>(),
            [(PathId(0), 3), (PathId(1), 6)]
        );
        assert_eq!(
            replay
                .polychrome_sprites
                .iter()
                .map(|sprite| (sprite.tile.tile_id, sprite.opacity))
                .collect::<Vec<_>>(),
            [(TileId(8), 0.8), (TileId(2), 0.2), (TileId(5), 0.5)]
        );
        assert_eq!(replay.surface_opacities(), &[1.0, 1.0, 1.0]);
        assert_eq!(
            replay
                .surfaces
                .iter()
                .map(|surface| match &surface.source {
                    SurfaceSource::Unsupported(size) => size.width.0,
                    _ => unreachable!(),
                })
                .collect::<Vec<_>>(),
            [10, 20, 30]
        );
        assert_eq!(
            replay
                .backdrop_filters
                .iter()
                .map(|filter| filter.opacity)
                .collect::<Vec<_>>(),
            [0.1, 0.2]
        );
    }

    #[test]
    fn replay_keeps_filter_pairs_attached_after_boundary_sorting() {
        let mut scene = Scene::default();
        for opacity in [0.25, 0.75] {
            let mut start = boundary(true);
            start.opacity = opacity;
            scene.insert_primitive(start);
            scene.insert_primitive(quad());
            let mut end = boundary(false);
            end.opacity = opacity;
            scene.insert_primitive(end);
        }
        scene.filter_boundaries[0].order = 2;
        scene.filter_boundaries[1].order = 2;
        scene.filter_boundaries[2].order = 1;
        scene.filter_boundaries[3].order = 1;
        scene.finish();

        assert_eq!(
            scene
                .filter_boundaries
                .iter()
                .map(|boundary| boundary.opacity)
                .collect::<Vec<_>>(),
            [0.75, 0.75, 0.25, 0.25]
        );

        let mut replay = Scene::default();
        replay.replay(0..scene.paint_operations.len(), &scene);
        replay.finish();
        assert_eq!(
            replay
                .filter_boundaries
                .iter()
                .map(|boundary| boundary.opacity)
                .collect::<Vec<_>>(),
            [0.25, 0.25, 0.75, 0.75]
        );
        assert_eq!(
            replay
                .render_commands()
                .iter()
                .filter_map(|command| match command {
                    RenderCommand::BeginFilter { boundary_index, .. } =>
                        Some(replay.filter_boundaries[*boundary_index].opacity,),
                    _ => None,
                })
                .collect::<Vec<_>>(),
            [0.25, 0.75]
        );
    }

    #[test]
    fn finished_scenes_can_be_extended_then_replayed_repeatedly() {
        let mut previous = Scene::default();
        for smoothing in [0.1, 0.2] {
            let mut quad = quad();
            quad.corner_smoothing = smoothing;
            previous.insert_primitive(quad);
        }
        previous.finish();

        let mut appended = Scene::default();
        appended.replay(0..previous.len(), &previous);
        appended.finish();
        let mut quad = quad();
        quad.corner_smoothing = 0.3;
        appended.insert_primitive(quad);
        appended.finish();

        let mut replay = Scene::default();
        replay.replay(0..appended.len(), &appended);
        replay.replay(0..appended.len(), &appended);
        replay.finish();
        assert_eq!(
            replay
                .quads
                .iter()
                .map(|quad| quad.corner_smoothing)
                .collect::<Vec<_>>(),
            [0.1, 0.2, 0.3, 0.1, 0.2, 0.3]
        );
    }

    // Note: this validates only the *scene ordering* of nested filter boundaries (start/child/
    // end interleaving), not that a renderer actually isolates both levels — that depends on the
    // backend's group-texture pool (see MAX_FILTER_DEPTH) and is exercised by the `blur` example.
    // Note: this validates only the *scene ordering* of nested filter boundaries (start/child/
    // end interleaving), not that a renderer actually isolates both levels — that depends on the
    // backend's group-texture pool (see MAX_FILTER_DEPTH) and is exercised by the `blur` example.
    #[test]
    fn nested_content_filters_emit_well_nested_ordering() {
        let mut scene = Scene::default();
        scene.insert_primitive(boundary(true)); // outer start
        scene.insert_primitive(quad()); // outer child
        scene.insert_primitive(boundary(true)); // inner start
        scene.insert_primitive(quad()); // inner child
        scene.insert_primitive(boundary(false)); // inner end
        scene.insert_primitive(boundary(false)); // outer end

        assert_eq!(
            batch_kinds(&mut scene),
            vec!["start", "quad", "start", "quad", "end", "end"]
        );
    }

    #[test]
    fn content_after_a_filter_group_sorts_above_it() {
        let mut scene = Scene::default();
        // A content-filtered element: start marker, its child, end marker.
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));
        // A sibling painted after the group that does NOT overlap it. Without the close-time
        // order-floor it would reuse the lowest order, tie with the start marker, and be swept
        // into the group (start, quad, quad, end); it must instead sort after the end marker.
        scene.insert_primitive(detached_quad());

        assert_eq!(
            batch_kinds(&mut scene),
            vec!["start", "quad", "end", "quad"]
        );
    }

    #[test]
    fn backdrop_filter_sorts_before_a_later_overlapping_quad() {
        let mut scene = Scene::default();
        // Content behind the frosted panel.
        scene.insert_primitive(quad());
        // The panel: its backdrop snapshot, then its (translucent) background quad on top.
        scene.insert_primitive(backdrop());
        scene.insert_primitive(quad());

        assert_eq!(batch_kinds(&mut scene), vec!["quad", "backdrop", "quad"]);
    }

    #[test]
    fn render_commands_allocate_targets_for_nested_filter_groups() {
        let mut scene = Scene::default();
        // Three nested groups receive distinct pooled targets. The inline storage depth
        // is only a stack optimization; it is not a limit on target allocation.
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));
        scene.insert_primitive(boundary(false));
        scene.insert_primitive(boundary(false));
        scene.finish();

        let commands: Vec<_> = scene
            .render_commands()
            .iter()
            .map(|command| match command {
                RenderCommand::Batch(PrimitiveBatch::Quads { .. }) => "quad".to_string(),
                RenderCommand::BeginFilter {
                    boundary_index,
                    target,
                } => {
                    let boundary = &scene.filter_boundaries[*boundary_index];
                    assert!(boundary.is_start);
                    format!("begin:{target:?}")
                }
                // An end command must carry its matched *start* boundary. This lets a
                // renderer use the opening group's bounds, filters, and opacity while
                // composing it, rather than trusting an independently-sorted end marker.
                RenderCommand::EndFilter {
                    boundary_index,
                    target,
                    ..
                } => {
                    let boundary = &scene.filter_boundaries[*boundary_index];
                    assert!(boundary.is_start);
                    format!("end:{target:?}")
                }
                RenderCommand::Batch(other) => panic!("unexpected batch: {other:?}"),
            })
            .collect();

        assert_eq!(
            commands,
            vec![
                "begin:Isolated(FilterTargetIndex(0))",
                "quad",
                "begin:Isolated(FilterTargetIndex(1))",
                "quad",
                "begin:Isolated(FilterTargetIndex(2))",
                "quad",
                "end:Isolated(FilterTargetIndex(2))",
                "end:Isolated(FilterTargetIndex(1))",
                "end:Isolated(FilterTargetIndex(0))",
            ]
        );
    }

    #[test]
    fn render_commands_keep_later_content_outside_a_completed_filter() {
        let mut scene = Scene::default();
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));
        // This non-overlapping sibling would reuse a low order without the close-time
        // order floor. The command stream is the renderer contract: it must come after
        // the group has been composited, not be painted into its offscreen target.
        scene.insert_primitive(detached_quad());
        scene.finish();

        let commands: Vec<_> = scene
            .render_commands()
            .iter()
            .map(|command| match command {
                RenderCommand::BeginFilter { target, .. } => {
                    format!("begin:{target:?}")
                }
                RenderCommand::EndFilter { target, .. } => format!("end:{target:?}"),
                RenderCommand::Batch(PrimitiveBatch::Quads { .. }) => "quad".to_string(),
                RenderCommand::Batch(other) => panic!("unexpected batch: {other:?}"),
            })
            .collect();

        assert_eq!(
            commands,
            vec![
                "begin:Isolated(FilterTargetIndex(0))",
                "quad",
                "end:Isolated(FilterTargetIndex(0))",
                "quad"
            ]
        );
    }

    #[test]
    fn unmatched_filter_start_renders_inline() {
        let mut scene = Scene::default();
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.finish();

        let mut commands = scene.render_commands().iter();
        assert!(matches!(
            commands.next(),
            Some(RenderCommand::BeginFilter {
                target: FilterRenderTarget::Inline,
                ..
            })
        ));
        assert!(matches!(
            commands.next(),
            Some(RenderCommand::Batch(PrimitiveBatch::Quads { .. }))
        ));
        assert!(commands.next().is_none());
        assert!(!scene.requires_offscreen_rendering());
    }

    #[test]
    fn finish_rebuilds_the_plan_after_direct_primitive_mutation() {
        let mut scene = Scene::default();
        scene.insert_primitive(quad());
        scene.finish();
        let commands = scene.render_commands().to_vec();

        // Primitive storage is public, so direct mutation must change the compiled plan.
        scene.quads.push(quad());
        scene.finish();
        assert_ne!(scene.render_commands(), commands);
        assert_eq!(scene.render_plan().requirements().instance_batch_count, 1);
    }

    #[test]
    fn render_plan_reuses_its_command_allocation_across_frames() {
        let mut scene = Scene::default();
        for _ in 0..32 {
            scene.insert_primitive(quad());
        }
        scene.finish();
        let capacity = scene.render_plan.commands.capacity();
        assert!(capacity >= 32);

        scene.clear();
        assert_eq!(scene.render_plan.commands.capacity(), capacity);
        scene.insert_primitive(quad());
        scene.finish();
        assert_eq!(scene.render_plan.commands.capacity(), capacity);
    }

    #[test]
    fn maximum_draw_order_is_not_treated_as_an_empty_batch_cursor() {
        let mut scene = Scene::default();
        let mut quad = quad();
        quad.order = DrawOrder::MAX;
        scene.quads.push(quad);
        scene.finish();

        assert!(matches!(
            scene.render_commands(),
            [RenderCommand::Batch(PrimitiveBatch::Quads { range, smoothed: false })]
                if range == &(0..1)
        ));
    }

    #[test]
    fn plan_requirements_are_collected_with_filter_pairing() {
        let mut scene = Scene::default();
        scene.insert_primitive(backdrop());
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));
        scene.finish();

        let requirements = scene.render_plan().requirements();
        assert_eq!(requirements.backdrop_filter_count, 1);
        assert_eq!(requirements.isolated_filter_count, 1);
        assert_eq!(requirements.isolated_target_count, 1);
        assert_eq!(requirements.instance_batch_count, 1);
        assert!(requirements.uses_offscreen_target);
    }
    #[test]
    fn filter_requirements_distinguish_opacity_from_blur() {
        for (name, group, content_blur, backdrop_blur) in [
            ("ordinary quad", false, false, false),
            ("opacity", true, false, false),
            ("content blur", true, true, false),
            ("backdrop blur", false, false, true),
            ("backdrop inside opacity", true, false, true),
        ] {
            let mut scene = Scene::default();
            let mut start = boundary(true);
            if !content_blur {
                start.filters.clear();
                start.opacity = 0.5;
            }
            if group {
                scene.insert_primitive(start.clone());
            }
            if backdrop_blur {
                scene.insert_primitive(backdrop());
            }
            scene.insert_primitive(quad());
            if group {
                scene.insert_primitive(FilterBoundary {
                    is_start: false,
                    ..start
                });
            }
            scene.finish();
            let requirements = scene.render_plan().requirements();
            assert_eq!(
                (
                    requirements.uses_offscreen_target,
                    requirements.uses_blur_target
                ),
                (group || backdrop_blur, content_blur || backdrop_blur),
                "{name}"
            );
        }
    }
}
