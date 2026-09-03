//! GPU-free, deterministic snapshotting of a finished [`Scene`].
//!
//! [`SceneArchive`] lowers a scene into a fully-typed, serializable command stream
//! (`anyrender`-style) so renderers and snapshot tests can compare scenes without touching
//! GPU or font state. The archive is hermetic: primitives carry their final assigned draw
//! orders, atlas tiles are collected into a deduplicated, sorted resource list, and
//! [`SceneArchive::to_canonical_json`] quantizes floats onto a fixed grid so platform noise
//! (e.g. `-0.0`, sub-grid fp32 drift) cannot flip a diff.
//!
//! Heap/GPU-backed primitives ([`PaintSurface`] and [`Path`]'s private build state) are
//! lowered to typed surrogates; everything else is the plain scene type itself.

use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

use crate::{
    AtlasTextureId, AtlasTile, BackdropFilter, Background, Bounds, ContentMask, DevicePixels,
    DrawOrder, FilterBoundary, FilterRenderTarget, MonochromeSprite, PaintOperation, PaintSurface,
    Path, PathId, PathVertex, PolychromeSprite, Primitive, Quad, ScaledPixels, Scene, Shadow, Size,
    SubpixelSprite, Underline,
};

/// Floats in the canonical JSON are snapped to this grid (device pixels at 1/10,000 precision).
const QUANTIZE_SCALE: f64 = 1e4;

/// A canonical, fully-typed snapshot of a [`Scene`].
#[derive(Clone, Debug, Serialize, Deserialize, JsonSchema)]
pub struct SceneArchive {
    /// Format version; bump when the serialized shape changes.
    pub version: u32,
    /// The scene's ordered operation stream (layers preserved, draw ops canonically sorted).
    pub commands: Vec<SerializableCommand>,
    /// Atlas textures and tiles referenced by the scene's sprites, deduplicated and sorted.
    pub resources: SortedResources,
}

/// The scene's draw resources, collected independently of insertion order.
#[derive(Clone, Debug, Default, Serialize, Deserialize, JsonSchema)]
pub struct SortedResources {
    /// Distinct atlas textures, sorted by (index, kind).
    pub textures: Vec<AtlasTextureId>,
    /// Distinct atlas tiles, sorted by texture, tile id, and tile geometry.
    pub tiles: Vec<AtlasTile>,
}

/// One step of a scene: a layer open/close, a primitive, or a compiled filter command.
#[derive(Clone, Debug, Serialize, Deserialize, JsonSchema)]
#[serde(tag = "op", rename_all = "snake_case")]
#[expect(missing_docs)]
pub enum SerializableCommand {
    StartLayer(Bounds<ScaledPixels>),
    EndLayer,
    Shadow(Shadow),
    Quad(Quad),
    Path(SerializablePath),
    Underline(Underline),
    MonochromeSprite(MonochromeSprite),
    SubpixelSprite(SubpixelSprite),
    PolychromeSprite(PolychromeSprite),
    Surface(SerializableSurface),
    BackdropFilter(BackdropFilter),
    FilterBoundary(FilterBoundary),
    BeginFilter {
        /// The opening marker of the isolated group.
        boundary: FilterBoundary,
        /// Where the group's content is rendered.
        target: SerializableFilterTarget,
    },
    EndFilter {
        /// The matched opening marker, used to composite the group.
        boundary: FilterBoundary,
        /// The closing marker, whose order places this command after the group's content.
        closing_boundary: FilterBoundary,
        /// The same target selected by the matching begin command.
        target: SerializableFilterTarget,
    },
}

/// The render target assigned to a content-filter group by the compiled plan.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize, JsonSchema)]
#[expect(missing_docs)]
pub enum SerializableFilterTarget {
    Inline,
    Isolated(u32),
}

/// A typed serializable surrogate for a [`Path`], carrying only its render-relevant state.
#[derive(Clone, Debug, Serialize, Deserialize, JsonSchema)]
pub struct SerializablePath {
    /// The path's identity, assigned at insert time.
    pub id: PathId,
    /// The path's draw order.
    pub order: DrawOrder,
    /// The path's bounding box in device pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The content mask that clips the path.
    pub content_mask: ContentMask<ScaledPixels>,
    /// The triangulated vertices sent to the renderer.
    pub vertices: Vec<PathVertex<ScaledPixels>>,
    /// The path's fill.
    pub color: Background,
}

/// A typed serializable surrogate for a [`PaintSurface`]; the GPU handle is replaced by its size.
#[derive(Clone, Debug, Serialize, Deserialize, JsonSchema)]
pub struct SerializableSurface {
    /// The surface's draw order.
    pub order: DrawOrder,
    /// The surface's bounds in device pixels.
    pub bounds: Bounds<ScaledPixels>,
    /// The content mask that clips the surface.
    pub content_mask: ContentMask<ScaledPixels>,
    /// Size of the source image in device pixels; the GPU handle itself is not serializable.
    pub source_size: Size<DevicePixels>,
}

impl SceneArchive {
    /// The current archive format version.
    pub const VERSION: u32 = 1;

    /// Lowers a scene into a deterministic, typed snapshot.
    ///
    /// Commands follow the scene's paint operations (so layers are preserved in order), but draw
    /// operations are canonically sorted by `(draw order, kind, content)` within each layer span —
    /// making the archive independent of primitive insertion order. When the scene is finished,
    /// content-filter boundaries are replaced by the plan's `BeginFilter`/`EndFilter` commands so
    /// the snapshot also captures the render contract.
    pub fn from_scene(scene: &Scene) -> Self {
        let mut plan_filters = Vec::new();
        if scene.is_finished {
            for command in scene.render_commands() {
                match command {
                    crate::RenderCommand::BeginFilter {
                        boundary_index,
                        target,
                    } => {
                        let boundary = &scene.filter_boundaries[*boundary_index];
                        plan_filters.push((
                            boundary.order,
                            SerializableCommand::BeginFilter {
                                boundary: boundary.clone(),
                                target: (*target).into(),
                            },
                        ));
                    }
                    crate::RenderCommand::EndFilter {
                        boundary_index,
                        closing_boundary_index,
                        target,
                    } => {
                        let boundary = &scene.filter_boundaries[*boundary_index];
                        let closing_boundary = &scene.filter_boundaries[*closing_boundary_index];
                        plan_filters.push((
                            closing_boundary.order,
                            SerializableCommand::EndFilter {
                                boundary: boundary.clone(),
                                closing_boundary: closing_boundary.clone(),
                                target: (*target).into(),
                            },
                        ));
                    }
                    crate::RenderCommand::Batch(_) => {}
                }
            }
        }

        let mut commands = Vec::with_capacity(scene.paint_operations.len());
        for operation in &scene.paint_operations {
            commands.push(match operation {
                PaintOperation::StartLayer(bounds) => SerializableCommand::StartLayer(*bounds),
                PaintOperation::EndLayer => SerializableCommand::EndLayer,
                PaintOperation::Primitive(Primitive::FilterBoundary(boundary)) => {
                    // Linear per-boundary search is fine: scenes hold few filter groups, and the
                    // O(n) match keeps this short instead of building an order-keyed index.
                    match plan_filters
                        .iter()
                        .position(|(order, _)| *order == boundary.order)
                    {
                        Some(index) => plan_filters.remove(index).1,
                        None => SerializableCommand::FilterBoundary(boundary.clone()),
                    }
                }
                PaintOperation::Primitive(primitive) => {
                    SerializableCommand::from_primitive(primitive)
                }
            });
        }

        Self {
            version: Self::VERSION,
            commands: canonicalize(commands),
            resources: SortedResources::from_tiles(
                scene
                    .monochrome_sprites
                    .iter()
                    .map(|sprite| sprite.tile)
                    .chain(scene.subpixel_sprites.iter().map(|sprite| sprite.tile))
                    .chain(scene.polychrome_sprites.iter().map(|sprite| sprite.tile)),
            ),
        }
    }

    /// Serializes the archive to a pretty, deterministic JSON string.
    ///
    /// Floats are quantized to a `1e-4` grid (`-0.0` → `0.0`); integer ids pass through untouched.
    /// Quantization is a generic walk over the serialized [`serde_json::Value`] so the archive
    /// types stay exact (see [`quantize_json`]).
    pub fn to_canonical_json(&self) -> String {
        let mut value = serde_json::to_value(self).expect("SceneArchive serialization cannot fail");
        quantize_json(&mut value);
        serde_json::to_string_pretty(&value).expect("pretty JSON cannot fail")
    }
}

impl SortedResources {
    fn from_tiles(tiles: impl IntoIterator<Item = AtlasTile>) -> Self {
        let mut tiles: Vec<AtlasTile> = tiles.into_iter().collect();
        let mut textures: Vec<AtlasTextureId> = tiles.iter().map(|tile| tile.texture_id).collect();
        textures.sort_unstable_by_key(|id| (id.index, id.kind as u8));
        textures.dedup();
        tiles.sort_unstable_by_key(tile_key);
        tiles.dedup();
        Self { textures, tiles }
    }
}

fn tile_key(tile: &AtlasTile) -> (u32, u8, u32, u32, i32, i32, i32, i32) {
    (
        tile.texture_id.index,
        tile.texture_id.kind as u8,
        tile.tile_id.0,
        tile.padding,
        tile.bounds.origin.x.0,
        tile.bounds.origin.y.0,
        tile.bounds.size.width.0,
        tile.bounds.size.height.0,
    )
}

impl SerializableCommand {
    fn from_primitive(primitive: &Primitive) -> Self {
        match primitive {
            Primitive::Shadow(shadow) => Self::Shadow(*shadow),
            Primitive::Quad(quad) => Self::Quad(*quad),
            Primitive::Path(path) => Self::Path(path.into()),
            Primitive::Underline(underline) => Self::Underline(*underline),
            Primitive::MonochromeSprite(sprite) => Self::MonochromeSprite(*sprite),
            Primitive::SubpixelSprite(sprite) => Self::SubpixelSprite(*sprite),
            Primitive::PolychromeSprite(sprite) => Self::PolychromeSprite(*sprite),
            Primitive::Surface(surface) => Self::Surface(surface.into()),
            Primitive::BackdropFilter(filter) => Self::BackdropFilter(filter.clone()),
            Primitive::FilterBoundary(boundary) => Self::FilterBoundary(boundary.clone()),
        }
    }

    /// The primitive's assigned draw order, used to canonically sort draw operations.
    fn order(&self) -> DrawOrder {
        match self {
            Self::StartLayer(_) | Self::EndLayer => 0,
            Self::Shadow(command) => command.order,
            Self::Quad(command) => command.order,
            Self::Path(command) => command.order,
            Self::Underline(command) => command.order,
            Self::MonochromeSprite(command) => command.order,
            Self::SubpixelSprite(command) => command.order,
            Self::PolychromeSprite(command) => command.order,
            Self::Surface(command) => command.order,
            Self::BackdropFilter(command) => command.order,
            Self::FilterBoundary(command) => command.order,
            Self::BeginFilter { boundary, .. } => boundary.order,
            Self::EndFilter {
                closing_boundary, ..
            } => closing_boundary.order,
        }
    }

    /// Sort rank mirroring [`crate::PrimitiveKind`] so equal-order content matches render order.
    fn kind_rank(&self) -> u8 {
        match self {
            Self::BeginFilter { .. } => 0,
            Self::Shadow(_) => 1,
            Self::Quad(_) => 2,
            Self::Path(_) => 3,
            Self::Underline(_) => 4,
            Self::MonochromeSprite(_) => 5,
            Self::SubpixelSprite(_) => 6,
            Self::PolychromeSprite(_) => 7,
            Self::Surface(_) => 8,
            Self::BackdropFilter(_) => 9,
            Self::EndFilter { .. } => 10,
            Self::FilterBoundary(boundary) => {
                // Raw (unfinished) markers: a start sorts before same-order content, an end after.
                if boundary.is_start { 0 } else { 10 }
            }
            Self::StartLayer(_) | Self::EndLayer => u8::MAX,
        }
    }
}

impl From<&Path<ScaledPixels>> for SerializablePath {
    fn from(path: &Path<ScaledPixels>) -> Self {
        Self {
            id: path.id,
            order: path.order,
            bounds: path.bounds,
            content_mask: path.content_mask,
            vertices: path.vertices.clone(),
            color: path.color,
        }
    }
}

impl From<&PaintSurface> for SerializableSurface {
    fn from(surface: &PaintSurface) -> Self {
        Self {
            order: surface.order,
            bounds: surface.bounds,
            content_mask: surface.content_mask,
            source_size: surface.source.size(),
        }
    }
}

impl From<FilterRenderTarget> for SerializableFilterTarget {
    fn from(target: FilterRenderTarget) -> Self {
        match target {
            FilterRenderTarget::Inline => Self::Inline,
            FilterRenderTarget::Isolated(index) => {
                Self::Isolated(u32::try_from(index.as_usize()).expect("target index fits u32"))
            }
        }
    }
}

/// Sorts draw operations by `(order, kind, content)` within each span between layer markers,
/// keeping the layer open/close sequence (and its bracketing) in paint order.
fn canonicalize(commands: Vec<SerializableCommand>) -> Vec<SerializableCommand> {
    let is_layer = |command: &SerializableCommand| {
        matches!(
            command,
            SerializableCommand::StartLayer(_) | SerializableCommand::EndLayer
        )
    };

    // Keys are precomputed once so the comparator never re-serializes (or panics). The content
    // tiebreak is the raw, unquantized JSON: sub-`1e-4` differences are still ordered
    // deterministically, but quantization only happens at `to_canonical_json`.
    fn sort_span(span: &mut Vec<SerializableCommand>) {
        let mut keyed: Vec<((DrawOrder, u8, String), SerializableCommand)> = span
            .drain(..)
            .map(|command| {
                let key = (
                    command.order(),
                    command.kind_rank(),
                    serde_json::to_string(&command).expect("SerializableCommand serializes"),
                );
                (key, command)
            })
            .collect();
        keyed.sort_unstable_by(|a, b| a.0.cmp(&b.0));
        span.extend(keyed.into_iter().map(|(_, command)| command));
    }

    let mut result = Vec::with_capacity(commands.len());
    let mut span = Vec::new();
    for command in commands {
        if is_layer(&command) {
            sort_span(&mut span);
            result.append(&mut span);
            result.push(command);
        } else {
            span.push(command);
        }
    }
    sort_span(&mut span);
    result.append(&mut span);
    result
}

/// Snaps every float in a serialized archive onto the `1e-4` grid, leaving integers untouched.
fn quantize_json(value: &mut serde_json::Value) {
    match value {
        serde_json::Value::Number(number) if number.is_f64() => {
            let float = number.as_f64().expect("f64 number");
            *number = serde_json::Number::from_f64(quantize_f64(float))
                .expect("finite f64 is valid JSON");
        }
        serde_json::Value::Array(items) => {
            for item in items {
                quantize_json(item);
            }
        }
        serde_json::Value::Object(map) => {
            for item in map.values_mut() {
                quantize_json(item);
            }
        }
        _ => {}
    }
}

/// Quantizes to the nearest `1e-4`, normalizing `-0.0` (and any sub-step float) to `0.0`.
fn quantize_f64(value: f64) -> f64 {
    if !value.is_finite() {
        return value;
    }
    let quantized = (value * QUANTIZE_SCALE).round() / QUANTIZE_SCALE;
    if quantized == 0.0 { 0.0 } else { quantized }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        AtlasTextureKind, Corners, Pixels, Point, ScaledFilter, SceneHsla, ShaderBool, TileId,
        TransformationMatrix, point,
    };

    fn sp(value: f32) -> ScaledPixels {
        ScaledPixels(value)
    }

    fn bounds_at(x: f32, y: f32) -> Bounds<ScaledPixels> {
        Bounds {
            origin: Point { x: sp(x), y: sp(y) },
            size: Size {
                width: sp(100.0),
                height: sp(100.0),
            },
        }
    }

    fn mask() -> ContentMask<ScaledPixels> {
        ContentMask {
            bounds: bounds_at(0.0, 0.0),
        }
    }

    fn quad_at(x: f32, y: f32) -> Quad {
        Quad {
            bounds: bounds_at(x, y),
            content_mask: ContentMask {
                bounds: bounds_at(x, y),
            },
            ..Default::default()
        }
    }

    fn quad() -> Quad {
        quad_at(0.0, 0.0)
    }

    fn shadow_at(x: f32, y: f32) -> Shadow {
        Shadow {
            order: 0,
            blur_radius: sp(4.0),
            bounds: bounds_at(x, y),
            corner_radii: Corners::default(),
            content_mask: ContentMask {
                bounds: bounds_at(x, y),
            },
            color: SceneHsla::default(),
            element_bounds: bounds_at(x, y),
            element_corner_radii: Corners::default(),
            inset: ShaderBool::Disabled,
            padding: 0,
        }
    }

    fn underline() -> Underline {
        Underline {
            order: 0,
            padding: 0,
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            color: SceneHsla::default(),
            thickness: sp(1.0),
            wavy: ShaderBool::Disabled,
        }
    }

    fn sprite() -> MonochromeSprite {
        MonochromeSprite {
            order: 0,
            padding: 0,
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            color: SceneHsla::default(),
            tile: tile(AtlasTextureKind::Monochrome, 2, TileId(3)),
            transformation: TransformationMatrix::unit(),
        }
    }

    fn subpixel_sprite() -> SubpixelSprite {
        SubpixelSprite {
            order: 0,
            padding: 0,
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            color: SceneHsla::default(),
            tile: tile(AtlasTextureKind::Subpixel, 3, TileId(4)),
            transformation: TransformationMatrix::unit(),
        }
    }

    fn polychrome_sprite() -> PolychromeSprite {
        PolychromeSprite {
            order: 0,
            padding: 0,
            grayscale: ShaderBool::Disabled,
            opacity: 1.0,
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            corner_radii: Corners::default(),
            tile: tile(AtlasTextureKind::Polychrome, 4, TileId(5)),
        }
    }

    fn tile(kind: AtlasTextureKind, index: u32, tile_id: TileId) -> AtlasTile {
        AtlasTile {
            texture_id: AtlasTextureId { index, kind },
            tile_id,
            padding: 0,
            bounds: Bounds {
                origin: Point {
                    x: DevicePixels(0),
                    y: DevicePixels(0),
                },
                size: Size {
                    width: DevicePixels(16),
                    height: DevicePixels(16),
                },
            },
        }
    }

    fn path() -> crate::Path<ScaledPixels> {
        let mut path = crate::Path::new(point(Pixels(0.0), Pixels(0.0)));
        path.line_to(point(Pixels(10.0), Pixels(0.0)));
        path.line_to(point(Pixels(10.0), Pixels(10.0)));
        let mut path = path.scale(2.0);
        path.content_mask = mask();
        path
    }

    fn backdrop() -> BackdropFilter {
        BackdropFilter {
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            corner_radii: Corners::default(),
            filters: smallvec::smallvec![ScaledFilter::Blur(sp(8.0))],
            ..Default::default()
        }
    }

    fn boundary(is_start: bool) -> FilterBoundary {
        FilterBoundary {
            order: 0,
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            corner_radii: Corners::default(),
            filters: smallvec::smallvec![ScaledFilter::Blur(sp(8.0))],
            opacity: 1.0,
            is_start,
        }
    }

    fn surface() -> PaintSurface {
        PaintSurface {
            order: 0,
            bounds: bounds_at(0.0, 0.0),
            content_mask: mask(),
            source: crate::SurfaceSource::Unsupported(Size {
                width: DevicePixels(32),
                height: DevicePixels(32),
            }),
        }
    }

    /// A scene exercising every draw primitive plus a content-filter group and a layer.
    fn sample_scene() -> Scene {
        let mut scene = Scene::default();
        scene.insert_primitive(quad());
        scene.insert_primitive(shadow_at(0.0, 200.0));
        scene.insert_primitive(underline());
        scene.push_layer(bounds_at(0.0, 0.0));
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(sprite());
        scene.insert_primitive(subpixel_sprite());
        scene.insert_primitive(polychrome_sprite());
        scene.insert_primitive(backdrop());
        scene.insert_primitive(path());
        scene.insert_primitive(surface());
        scene.insert_primitive(boundary(false));
        scene.pop_layer();
        scene.finish();
        scene
    }

    #[test]
    fn archive_roundtrips_through_canonical_json_stably() {
        let archive = SceneArchive::from_scene(&sample_scene());
        let first = archive.to_canonical_json();
        let reparsed: SceneArchive =
            serde_json::from_str(&first).expect("canonical JSON parses back into the archive");
        assert_eq!(reparsed.to_canonical_json(), first);
        assert_eq!(archive.version, SceneArchive::VERSION);
    }

    #[test]
    fn sample_scene_covers_every_command_variant() {
        let ops: Vec<_> = SceneArchive::from_scene(&sample_scene())
            .commands
            .iter()
            .map(op_name)
            .collect();
        assert_eq!(ops.len(), 13);
        for op in [
            "start_layer",
            "end_layer",
            "begin_filter",
            "end_filter",
            "shadow",
            "quad",
            "path",
            "underline",
            "monochrome_sprite",
            "subpixel_sprite",
            "polychrome_sprite",
            "surface",
            "backdrop_filter",
        ] {
            assert!(ops.contains(&op), "missing {op}");
        }
    }

    #[test]
    fn unfinished_scenes_keep_filter_boundary_markers() {
        let mut scene = Scene::default();
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));
        let commands = SceneArchive::from_scene(&scene).commands;
        assert!(matches!(
            commands[0],
            SerializableCommand::FilterBoundary(ref boundary) if boundary.is_start
        ));
        assert!(matches!(commands[1], SerializableCommand::Quad(_)));
        assert!(matches!(
            commands[2],
            SerializableCommand::FilterBoundary(ref boundary) if !boundary.is_start
        ));
    }

    #[test]
    fn integer_ids_pass_through_and_negative_zero_normalizes() {
        let mut scene = Scene::default();
        scene.insert_primitive(sprite());
        scene.insert_primitive(path());
        scene.insert_primitive(quad_at(-0.0, -0.0));
        scene.finish();
        let json = SceneArchive::from_scene(&scene).to_canonical_json();
        assert!(json.contains("\"id\": 0"));
        assert!(json.contains("\"tile_id\": 3"));
        assert!(json.contains("\"index\": 2"));
        assert!(json.contains("\"width\": 16"));
        assert!(!json.contains("-0.0"));
    }

    #[test]
    fn tiles_sort_by_geometry() {
        let mut moved = sprite();
        moved.tile.bounds.origin.x = DevicePixels(50);
        let mut scene = Scene::default();
        scene.insert_primitive(moved);
        scene.insert_primitive(sprite());
        scene.finish();
        let tiles = SceneArchive::from_scene(&scene).resources.tiles;
        assert_eq!(tiles[0].bounds.origin.x.0, 0);
        assert_eq!(tiles[1].bounds.origin.x.0, 50);
    }

    fn op_name(command: &SerializableCommand) -> &'static str {
        match command {
            SerializableCommand::StartLayer(_) => "start_layer",
            SerializableCommand::EndLayer => "end_layer",
            SerializableCommand::Shadow(_) => "shadow",
            SerializableCommand::Quad(_) => "quad",
            SerializableCommand::Path(_) => "path",
            SerializableCommand::Underline(_) => "underline",
            SerializableCommand::MonochromeSprite(_) => "monochrome_sprite",
            SerializableCommand::SubpixelSprite(_) => "subpixel_sprite",
            SerializableCommand::PolychromeSprite(_) => "polychrome_sprite",
            SerializableCommand::Surface(_) => "surface",
            SerializableCommand::BackdropFilter(_) => "backdrop_filter",
            SerializableCommand::FilterBoundary(_) => "filter_boundary",
            SerializableCommand::BeginFilter { .. } => "begin_filter",
            SerializableCommand::EndFilter { .. } => "end_filter",
        }
    }

    #[test]
    fn quantize_normalizes_negative_zero_and_sub_step_floats() {
        for (input, expected) in [
            (-0.0, 0.0),
            (-1e-5, 0.0),
            (1e-5, 0.0),
            (0.00016, 0.0002),
            (12.34567, 12.3457),
            (1.0, 1.0),
        ] {
            assert_eq!(quantize_f64(input), expected);
        }
    }

    #[test]
    fn ordering_is_stable_across_shuffled_insertion() {
        let mut first = Scene::default();
        first.insert_primitive(quad());
        first.insert_primitive(quad_at(200.0, 0.0));
        first.insert_primitive(shadow_at(0.0, 200.0));
        first.finish();
        let mut shuffled = Scene::default();
        shuffled.insert_primitive(shadow_at(0.0, 200.0));
        shuffled.insert_primitive(quad_at(200.0, 0.0));
        shuffled.insert_primitive(quad());
        shuffled.finish();
        assert_eq!(
            SceneArchive::from_scene(&first).to_canonical_json(),
            SceneArchive::from_scene(&shuffled).to_canonical_json()
        );
    }

    #[test]
    fn resources_are_collected_sorted_and_deduplicated() {
        let mut scene = Scene::default();
        scene.insert_primitive(sprite());
        let mut second = sprite();
        second.tile.texture_id.index = 1;
        second.tile.tile_id = TileId(9);
        scene.insert_primitive(second);
        scene.insert_primitive(sprite());
        scene.finish();
        let resources = SceneArchive::from_scene(&scene).resources;
        let indices: Vec<_> = resources.textures.iter().map(|id| id.index).collect();
        assert_eq!(indices, [1, 2]);
        assert_eq!(resources.tiles.len(), 2);
    }

    #[test]
    fn layers_are_captured_in_paint_order() {
        let mut scene = Scene::default();
        scene.push_layer(bounds_at(0.0, 0.0));
        scene.insert_primitive(quad());
        scene.pop_layer();
        scene.finish();
        let commands = SceneArchive::from_scene(&scene).commands;
        assert!(matches!(commands[0], SerializableCommand::StartLayer(_)));
        assert!(matches!(commands[1], SerializableCommand::Quad(_)));
        assert!(matches!(commands[2], SerializableCommand::EndLayer));
    }

    #[test]
    fn draw_ops_stay_within_their_layer_spans() {
        let mut scene = Scene::default();
        scene.push_layer(bounds_at(0.0, 0.0));
        scene.insert_primitive(quad());
        scene.pop_layer();
        scene.insert_primitive(quad_at(200.0, 0.0));
        scene.finish();
        let commands = SceneArchive::from_scene(&scene).commands;
        assert!(matches!(commands[0], SerializableCommand::StartLayer(_)));
        assert!(matches!(commands[1], SerializableCommand::Quad(_)));
        assert!(matches!(commands[2], SerializableCommand::EndLayer));
        assert!(matches!(commands[3], SerializableCommand::Quad(_)));
    }

    #[test]
    fn finished_scenes_emit_begin_and_end_filter_commands() {
        let mut scene = Scene::default();
        scene.insert_primitive(boundary(true));
        scene.insert_primitive(quad());
        scene.insert_primitive(boundary(false));
        scene.finish();
        let commands = SceneArchive::from_scene(&scene).commands;
        assert!(matches!(
            commands[0],
            SerializableCommand::BeginFilter { .. }
        ));
        assert!(matches!(commands[1], SerializableCommand::Quad(_)));
        assert!(matches!(commands[2], SerializableCommand::EndFilter { .. }));
    }
}
