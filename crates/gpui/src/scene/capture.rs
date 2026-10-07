//! Versioned, renderer-neutral snapshots of a finished scene.
//!
//! Captures store the sorted primitive arrays and a canonical compiled command stream. Atlas
//! tiles are copied through a resolver and assigned local IDs, so atlas allocation history does
//! not become part of the snapshot.

use super::*;
use anyhow::{Context, Result, ensure};
use serde::{Deserialize, Serialize};
use collections::HashMap;

/// Current serialized scene-capture format version.
///
/// Increment this when a change makes previously serialized capture data
/// incompatible with the current validator or scene reconstruction logic.
pub const SCENE_CAPTURE_VERSION: u32 = 2;

/// A tightly packed standalone bitmap for one captured atlas tile.
///
/// Dimensions are physical pixels. `bytes` contains exactly one row after
/// another with no row padding; the required channel count comes from `kind`.
#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct CapturedBitmap {
    /// Atlas pixel format, which determines the number of bytes per pixel.
    pub kind: AtlasTextureKind,
    /// Width in pixels.
    pub width: u32,
    /// Height in pixels.
    pub height: u32,
    /// Tightly packed pixel bytes.
    #[serde(with = "serde_bytes")]
    pub bytes: Vec<u8>,
}

impl CapturedBitmap {
    /// Checks positive dimensions and the byte count for this bitmap's atlas format.
    ///
    /// Returns an error for dimensions outside scene-coordinate limits or a
    /// byte length that does not match the format and dimensions.
    pub fn validate(&self) -> Result<()> {
        ensure!(
            self.width > 0 && self.height > 0,
            "bitmap dimensions must be positive"
        );
        ensure!(
            self.width <= i32::MAX as u32 && self.height <= i32::MAX as u32,
            "bitmap dimensions exceed scene coordinate limits"
        );
        self.kind
            .validate_upload(
                Size {
                    width: DevicePixels(self.width as i32),
                    height: DevicePixels(self.height as i32),
                },
                &self.bytes,
            )
            .context("invalid captured bitmap")
    }
}

/// A portable snapshot of a finished scene's sorted primitives and render commands.
///
/// A capture owns the bitmap pixels referenced by its sprites. Atlas identifiers
/// are local to the capture, so a receiver can import it into a different
/// window with [`Window::import_scene_capture`](crate::Window::import_scene_capture).
/// The receiving window still uses GPUI's normal renderer and batching.
///
/// Captures contain drawing data, not entities, event listeners, focus, or the
/// source window's layout cache. An embedding host supplies those separately.
/// Native paint surfaces contain backend-owned handles; capturing a scene with
/// such a surface returns an error.
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct SceneCapture {
    version: u32,
    #[serde(with = "super::shader_records")]
    shadows: Vec<Shadow>,
    #[serde(with = "super::shader_records")]
    quads: Vec<Quad>,
    paths: Vec<Path<ScaledPixels>>,
    #[serde(with = "super::shader_records")]
    underlines: Vec<Underline>,
    #[serde(with = "super::shader_records")]
    monochrome_sprites: Vec<MonochromeSprite>,
    #[serde(with = "super::shader_records")]
    subpixel_sprites: Vec<SubpixelSprite>,
    #[serde(with = "super::shader_records")]
    polychrome_sprites: Vec<PolychromeSprite>,
    backdrop_filters: Vec<BackdropFilter>,
    filter_boundaries: Vec<FilterBoundary>,
    commands: Vec<RenderCommand>,
    bitmaps: Vec<CapturedBitmap>,
}

impl SceneCapture {
    /// Copies a finished scene into a canonical snapshot.
    ///
    /// `resolve_tile` supplies each referenced atlas tile's standalone pixels,
    /// tightly packed according to its [`AtlasTextureKind`]. Each distinct tile
    /// is resolved once. Bitmap ordering is canonicalized so equivalent scenes
    /// can be compared independently of their atlas allocation history.
    ///
    /// Returns an error for an unfinished scene, a native paint surface, invalid
    /// scene data, or a failed tile lookup. Use [`capture_live`](Self::capture_live)
    /// when transporting frames without requiring canonical bitmap order.
    pub fn capture(
        scene: &Scene,
        resolve_tile: impl FnMut(AtlasTile) -> Result<CapturedBitmap>,
    ) -> Result<Self> {
        Self::capture_inner(scene, resolve_tile, true)
    }

    /// Captures a live frame without sorting bitmap contents for deterministic
    /// snapshot identity. Primitive order, filters, and renderer batching still
    /// use the normal scene compiler. Every referenced tile is self-contained.
    /// As with [`Self::capture`], the scene must be finished and must not contain
    /// native surfaces; a tile-resolution or validation failure returns an error.
    pub fn capture_live(
        scene: &Scene,
        resolve_tile: impl FnMut(AtlasTile) -> Result<CapturedBitmap>,
    ) -> Result<Self> {
        Self::capture_inner(scene, resolve_tile, false)
    }

    fn capture_inner(
        scene: &Scene,
        mut resolve_tile: impl FnMut(AtlasTile) -> Result<CapturedBitmap>,
        canonical: bool,
    ) -> Result<Self> {
        ensure!(scene.is_finished, "scene must be finished before capture");
        ensure!(
            scene.surfaces.is_empty(),
            "scene capture does not support native paint surfaces"
        );
        // Public primitive arrays may have changed after finish. Check the source
        // plan before rewriting tile references, in both debug and release builds.
        #[cfg(not(miri))]
        ScenePlan::from_captured_commands(scene, scene.render_plan.commands().to_vec())?;
        let mut capture = Self {
            version: SCENE_CAPTURE_VERSION,
            shadows: scene.shadows.clone(),
            quads: scene.quads.clone(),
            paths: scene.paths.clone(),
            underlines: scene.underlines.clone(),
            monochrome_sprites: scene.monochrome_sprites.clone(),
            subpixel_sprites: scene.subpixel_sprites.clone(),
            polychrome_sprites: scene.polychrome_sprites.clone(),
            backdrop_filters: scene.backdrop_filters.clone(),
            filter_boundaries: scene.filter_boundaries.clone(),
            commands: Vec::new(),
            bitmaps: Vec::new(),
        };
        capture.canonicalize_tiles(&mut resolve_tile, canonical)?;
        // The native receiver validates the serialized scene once. Repeating this
        // walk in an interpreter makes capture dominate otherwise simple frames.
        #[cfg(not(miri))]
        capture.validate()?;
        Ok(capture)
    }

    /// Returns the serialized capture format version.
    ///
    /// Compare with [`SCENE_CAPTURE_VERSION`] before implementing a custom
    /// reader. GPUI reconstruction rejects unsupported versions.
    pub fn version(&self) -> u32 {
        self.version
    }

    /// Returns captured per-tile bitmaps. A canonical `AtlasTextureId.index` is the index into
    /// this list, and every bitmap represents one tile with `tile_id == TileId(0)`.
    pub fn bitmaps(&self) -> &[CapturedBitmap] {
        &self.bitmaps
    }

    /// Returns the compiled renderer command stream stored in this capture.
    ///
    /// Its batch ranges index this capture's primitive arrays, and its atlas
    /// IDs index [`Self::bitmaps`]. Use [`Self::to_scene`] or
    /// [`Self::into_scene`] to validate and reconstruct a scene.
    pub fn commands(&self) -> &[RenderCommand] {
        &self.commands
    }

    /// Restores a finished scene for renderer replay without consuming this capture.
    ///
    /// Paint operations and the layout cache belong to the live window. They are not
    /// restored, so this scene cannot act as a previous frame for [`Scene::replay`].
    /// Returns an error if the serialized resources or command stream are invalid.
    pub fn to_scene(&self) -> Result<Scene> {
        self.validate_resources()?;
        let mut scene = self.clone_primitives();
        scene.render_plan = ScenePlan::from_captured_commands(&scene, self.commands.clone())?;
        scene.is_finished = true;
        Ok(scene)
    }

    /// Restores a scene for renderer replay, preserving command order and batching.
    /// Like [`Self::to_scene`], this does not restore the live window's paint cache.
    /// The capture is consumed, so primitive vectors and bitmap storage can be
    /// moved instead of cloned. Returns an error if validation fails.
    pub fn into_scene(self) -> Result<Scene> {
        self.validate_resources()?;
        let mut scene = Scene {
            paint_operations: Vec::new(),
            primitive_bounds: Default::default(),
            layer_stack: Vec::new(),
            shadows: self.shadows,
            quads: self.quads,
            paths: self.paths,
            underlines: self.underlines,
            monochrome_sprites: self.monochrome_sprites,
            subpixel_sprites: self.subpixel_sprites,
            polychrome_sprites: self.polychrome_sprites,
            surfaces: Vec::new(),
            surface_opacities: Vec::new(),
            backdrop_filters: self.backdrop_filters,
            filter_boundaries: self.filter_boundaries,
            render_plan: ScenePlan::default(),
            is_finished: false,
        };
        scene.render_plan = ScenePlan::from_captured_commands(&scene, self.commands)?;
        scene.is_finished = true;
        Ok(scene)
    }

    fn canonicalize_tiles(
        &mut self,
        resolve_tile: &mut impl FnMut(AtlasTile) -> Result<CapturedBitmap>,
        canonical: bool,
    ) -> Result<()> {
        let mut sources = HashMap::<AtlasTile, usize>::default();
        let mut resources = Vec::new();
        let tiles = self
            .monochrome_sprites
            .iter()
            .map(|sprite| sprite.tile)
            .chain(self.subpixel_sprites.iter().map(|sprite| sprite.tile))
            .chain(self.polychrome_sprites.iter().map(|sprite| sprite.tile));
        for tile in tiles {
            if sources.contains_key(&tile) {
                continue;
            }
            let bitmap = resolve_tile(tile)
                .with_context(|| format!("resolving atlas tile {:?}", tile.tile_id))?;
            bitmap.validate()?;
            ensure!(
                bitmap.kind == tile.texture_id.kind,
                "resolved bitmap kind does not match atlas tile kind"
            );
            ensure!(
                bitmap.width as i32 == tile.bounds.size.width.0
                    && bitmap.height as i32 == tile.bounds.size.height.0,
                "resolved bitmap dimensions do not match atlas tile bounds"
            );
            let index = resources.len();
            sources.insert(tile, index);
            resources.push((index, bitmap));
        }

        // Content order is independent of atlas allocation and first-use history.
        // Equal bitmaps share one captured resource, even across distinct live tiles.
        if canonical {
            resources.sort_by(|(_, left), (_, right)| {
            (left.kind as u32, left.width, left.height)
                .cmp(&(right.kind as u32, right.width, right.height))
                .then_with(|| left.bytes.cmp(&right.bytes))
            });
        }
        let mut normalized = vec![None; resources.len()];
        for (source_index, bitmap) in resources {
            let index = if canonical && self.bitmaps.last() == Some(&bitmap) {
                self.bitmaps.len() - 1
            } else {
                self.bitmaps.push(bitmap);
                self.bitmaps.len() - 1
            };
            let bitmap = &self.bitmaps[index];
            normalized[source_index] = Some(AtlasTile {
                texture_id: AtlasTextureId {
                    index: u32::try_from(index).context("too many captured bitmaps")?,
                    kind: bitmap.kind,
                },
                tile_id: TileId(0),
                padding: 0,
                bounds: Bounds::new(
                    point(DevicePixels(0), DevicePixels(0)),
                    crate::size(
                        DevicePixels(bitmap.width as i32),
                        DevicePixels(bitmap.height as i32),
                    ),
                ),
            });
        }
        let tiles = self
            .monochrome_sprites
            .iter_mut()
            .map(|sprite| &mut sprite.tile)
            .chain(
                self.subpixel_sprites
                    .iter_mut()
                    .map(|sprite| &mut sprite.tile),
            )
            .chain(
                self.polychrome_sprites
                    .iter_mut()
                    .map(|sprite| &mut sprite.tile),
            );
        for tile in tiles {
            *tile = normalized[sources[tile]].expect("every source tile was normalized");
        }

        // GPUI assigns distinct draw orders to intersecting primitives. Sort only
        // within an order, where atlas-dependent ordering cannot affect compositing.
        if canonical {
            self.monochrome_sprites
            .sort_by(|a, b| sprite_order(a.order, a.tile, a.bounds, b.order, b.tile, b.bounds));
        self.subpixel_sprites
            .sort_by(|a, b| sprite_order(a.order, a.tile, a.bounds, b.order, b.tile, b.bounds));
        self.polychrome_sprites
            .sort_by(|a, b| sprite_order(a.order, a.tile, a.bounds, b.order, b.tile, b.bounds));
        }
        self.commands = ScenePlan::build_primitives(self.primitives(), Vec::new()).commands;
        Ok(())
    }

    fn primitives(&self) -> ScenePrimitives<'_> {
        ScenePrimitives {
            shadows: &self.shadows, quads: &self.quads, paths: &self.paths,
            underlines: &self.underlines, monochrome_sprites: &self.monochrome_sprites,
            subpixel_sprites: &self.subpixel_sprites, polychrome_sprites: &self.polychrome_sprites,
            surfaces: &[], backdrop_filters: &self.backdrop_filters,
            filter_boundaries: &self.filter_boundaries,
        }
    }

    /// Checks the format version, primitive references, command ranges, filter
    /// nesting, bitmap data, finite floating-point values, and non-negative
    /// dimensions.
    ///
    /// Deserialization alone does not perform these checks. Validate a received
    /// capture before relying on its contents. [`to_scene`](Self::to_scene) and
    /// window import perform validation as part of reconstructing the scene.
    pub fn validate(&self) -> Result<()> {
        self.to_scene().map(|_| ())
    }

    fn validate_resources(&self) -> Result<()> {
        ensure!(
            self.version == SCENE_CAPTURE_VERSION,
            "unsupported scene capture version {}",
            self.version
        );
        ensure!(
            self.bitmaps.len() <= u32::MAX as usize,
            "too many captured bitmaps"
        );
        for (index, bitmap) in self.bitmaps.iter().enumerate() {
            bitmap
                .validate()
                .with_context(|| format!("bitmap {index}"))?;
        }
        for (index, sprite) in self.monochrome_sprites.iter().enumerate() {
            self.validate_tile(sprite.tile, AtlasTextureKind::Monochrome, index)?;
        }
        for (index, sprite) in self.subpixel_sprites.iter().enumerate() {
            self.validate_tile(sprite.tile, AtlasTextureKind::Subpixel, index)?;
        }
        for (index, sprite) in self.polychrome_sprites.iter().enumerate() {
            self.validate_tile(sprite.tile, AtlasTextureKind::Polychrome, index)?;
        }
        for filter in &self.backdrop_filters {
            validate_filters(&filter.filters, filter.opacity)?;
        }
        for boundary in &self.filter_boundaries {
            validate_filters(&boundary.filters, boundary.opacity)?;
        }
        // Geometry has no optional fields. serde_json encodes non-finite floats
        // as null; reject them without expanding the bitmap bytes into JSON values.
        self.validate_numbers("shadows", &self.shadows)?;
        self.validate_numbers("quads", &self.quads)?;
        self.validate_numbers("paths", &self.paths)?;
        self.validate_numbers("underlines", &self.underlines)?;
        self.validate_numbers("monochrome sprites", &self.monochrome_sprites)?;
        self.validate_numbers("subpixel sprites", &self.subpixel_sprites)?;
        self.validate_numbers("polychrome sprites", &self.polychrome_sprites)?;
        self.validate_numbers("backdrop filters", &self.backdrop_filters)?;
        self.validate_numbers("filter boundaries", &self.filter_boundaries)
    }

    fn clone_primitives(&self) -> Scene {
        Scene {
            paint_operations: Vec::new(),
            primitive_bounds: Default::default(),
            layer_stack: Vec::new(),
            shadows: self.shadows.clone(),
            quads: self.quads.clone(),
            paths: self.paths.clone(),
            underlines: self.underlines.clone(),
            monochrome_sprites: self.monochrome_sprites.clone(),
            subpixel_sprites: self.subpixel_sprites.clone(),
            polychrome_sprites: self.polychrome_sprites.clone(),
            surfaces: Vec::new(),
            surface_opacities: Vec::new(),
            backdrop_filters: self.backdrop_filters.clone(),
            filter_boundaries: self.filter_boundaries.clone(),
            render_plan: ScenePlan::default(),
            is_finished: false,
        }
    }

    fn validate_numbers(&self, kind: &str, primitives: &impl Serialize) -> Result<()> {
        let value = serde_json::to_value(primitives)?;
        ensure!(
            !contains_json_null(&value),
            "captured {kind} contain a non-finite number"
        );
        ensure!(
            !contains_negative_dimensions(&value),
            "captured {kind} contain a negative dimension"
        );
        Ok(())
    }

    fn validate_tile(&self, tile: AtlasTile, kind: AtlasTextureKind, index: usize) -> Result<()> {
        ensure!(
            tile.texture_id.kind == kind,
            "sprite {index} has an incompatible atlas kind"
        );
        let bitmap = self
            .bitmaps
            .get(tile.texture_id.index as usize)
            .context("sprite references a missing bitmap")?;
        ensure!(
            bitmap.kind == kind,
            "sprite {index} bitmap kind does not match its atlas kind"
        );
        ensure!(
            tile.tile_id.0 == 0 && tile.padding == 0,
            "sprite {index} has a non-canonical tile reference"
        );
        ensure!(
            tile.bounds.origin == point(DevicePixels(0), DevicePixels(0)),
            "sprite {index} tile origin is not normalized"
        );
        ensure!(
            tile.bounds.size.width.0 == bitmap.width as i32
                && tile.bounds.size.height.0 == bitmap.height as i32,
            "sprite {index} tile bounds do not match its bitmap dimensions"
        );
        Ok(())
    }
}

fn sprite_order(
    order_a: DrawOrder,
    tile_a: AtlasTile,
    bounds_a: Bounds<ScaledPixels>,
    order_b: DrawOrder,
    tile_b: AtlasTile,
    bounds_b: Bounds<ScaledPixels>,
) -> std::cmp::Ordering {
    (order_a, tile_a.texture_id.index)
        .cmp(&(order_b, tile_b.texture_id.index))
        .then_with(|| bounds_a.origin.y.0.total_cmp(&bounds_b.origin.y.0))
        .then_with(|| bounds_a.origin.x.0.total_cmp(&bounds_b.origin.x.0))
}

fn validate_filters(filters: &[ScaledFilter], opacity: f32) -> Result<()> {
    ensure!(
        (0.0..=1.0).contains(&opacity),
        "filter opacity must be between zero and one"
    );
    for filter in filters {
        match filter {
            ScaledFilter::Blur(radius) => ensure!(
                radius.0 >= 0.0 && radius.0.is_finite(),
                "blur radius must be finite and non-negative"
            ),
        }
    }
    Ok(())
}

fn contains_json_null(value: &serde_json::Value) -> bool {
    match value {
        serde_json::Value::Null => true,
        serde_json::Value::Array(values) => values.iter().any(contains_json_null),
        serde_json::Value::Object(values) => values.values().any(contains_json_null),
        _ => false,
    }
}

fn contains_negative_dimensions(value: &serde_json::Value) -> bool {
    match value {
        serde_json::Value::Array(values) => values.iter().any(contains_negative_dimensions),
        serde_json::Value::Object(values) => {
            let negative_size = values.get("size").is_some_and(|size| {
                ["width", "height"].iter().any(|dimension| {
                    size.get(*dimension)
                        .and_then(serde_json::Value::as_f64)
                        .is_some_and(|value| value < 0.0)
                })
            });
            negative_size || values.values().any(contains_negative_dimensions)
        }
        _ => false,
    }
}

#[cfg(test)]
mod tests;
