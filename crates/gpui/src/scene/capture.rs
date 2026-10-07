//! Versioned, renderer-neutral snapshots of a finished scene.
//!
//! Captures store the sorted primitive arrays and a canonical compiled command stream. Atlas
//! tiles are copied through a resolver and assigned local IDs, so atlas allocation history does
//! not become part of the snapshot.

use super::*;
use anyhow::{Context, Result, ensure};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// Current serialized scene-capture format version.
pub const SCENE_CAPTURE_VERSION: u32 = 1;

/// A tightly packed standalone bitmap for one captured atlas tile.
#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct CapturedBitmap {
    /// Pixel format of this standalone tile.
    pub kind: AtlasTextureKind,
    /// Width in pixels.
    pub width: u32,
    /// Height in pixels.
    pub height: u32,
    /// Tightly packed pixel bytes.
    pub bytes: Vec<u8>,
}

impl CapturedBitmap {
    /// Checks dimensions and the byte count for this bitmap's native atlas format.
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
/// Native paint surfaces contain backend-owned handles and cannot be represented here; capture
/// returns an error if the source scene contains any surfaces.
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
pub struct SceneCapture {
    version: u32,
    shadows: Vec<Shadow>,
    quads: Vec<Quad>,
    paths: Vec<Path<ScaledPixels>>,
    underlines: Vec<Underline>,
    monochrome_sprites: Vec<MonochromeSprite>,
    subpixel_sprites: Vec<SubpixelSprite>,
    polychrome_sprites: Vec<PolychromeSprite>,
    backdrop_filters: Vec<BackdropFilter>,
    filter_boundaries: Vec<FilterBoundary>,
    commands: Vec<RenderCommand>,
    bitmaps: Vec<CapturedBitmap>,
}

impl SceneCapture {
    /// Captures a finished scene. `resolve_tile` must return the tile's standalone pixels,
    /// tightly packed according to its [`AtlasTextureKind`]. Each distinct tile is resolved once.
    pub fn capture(
        scene: &Scene,
        mut resolve_tile: impl FnMut(AtlasTile) -> Result<CapturedBitmap>,
    ) -> Result<Self> {
        ensure!(scene.is_finished, "scene must be finished before capture");
        ensure!(
            scene.surfaces.is_empty(),
            "scene capture does not support native paint surfaces"
        );
        let commands = scene.render_plan.commands().to_vec();
        // Public primitive arrays may have changed after finish. Check the source
        // plan before rewriting tile references, in both debug and release builds.
        ScenePlan::from_captured_commands(scene, commands.clone())?;
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
            commands,
            bitmaps: Vec::new(),
        };
        capture.canonicalize_tiles(&mut resolve_tile)?;
        capture.validate()?;
        Ok(capture)
    }

    /// Returns the capture format version.
    pub fn version(&self) -> u32 {
        self.version
    }

    /// Returns captured per-tile bitmaps. A canonical `AtlasTextureId.index` is the index into
    /// this list, and every bitmap represents one tile with `tile_id == TileId(0)`.
    pub fn bitmaps(&self) -> &[CapturedBitmap] {
        &self.bitmaps
    }

    /// Returns the canonical compiled renderer command stream.
    pub fn commands(&self) -> &[RenderCommand] {
        &self.commands
    }

    /// Restores a finished scene for renderer replay without consuming this capture.
    ///
    /// Paint operations and the layout cache belong to the live window. They are not
    /// restored, so this scene cannot act as a previous frame for [`Scene::replay`].
    pub fn to_scene(&self) -> Result<Scene> {
        self.validate_resources()?;
        let mut scene = self.clone_primitives();
        scene.render_plan = ScenePlan::from_captured_commands(&scene, self.commands.clone())?;
        scene.is_finished = true;
        Ok(scene)
    }

    /// Restores a scene for renderer replay, preserving command order and batching.
    /// Like [`Self::to_scene`], this does not restore the live window's paint cache.
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
    ) -> Result<()> {
        let mut sources = HashMap::<AtlasTile, usize>::new();
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
        resources.sort_by(|(_, left), (_, right)| {
            (left.kind as u32, left.width, left.height)
                .cmp(&(right.kind as u32, right.width, right.height))
                .then_with(|| left.bytes.cmp(&right.bytes))
        });
        let mut normalized = vec![None; resources.len()];
        for (source_index, bitmap) in resources {
            let index = if self.bitmaps.last() == Some(&bitmap) {
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
        self.monochrome_sprites
            .sort_by(|a, b| sprite_order(a.order, a.tile, a.bounds, b.order, b.tile, b.bounds));
        self.subpixel_sprites
            .sort_by(|a, b| sprite_order(a.order, a.tile, a.bounds, b.order, b.tile, b.bounds));
        self.polychrome_sprites
            .sort_by(|a, b| sprite_order(a.order, a.tile, a.bounds, b.order, b.tile, b.bounds));
        self.commands = ScenePlan::build(&self.clone_primitives(), Vec::new()).commands;
        Ok(())
    }

    /// Checks the format version, primitive references, command ranges, filter nesting, bitmap
    /// data, and finite floating-point values.
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
mod tests {
    use super::*;

    fn test_bounds(x: f32) -> Bounds<ScaledPixels> {
        Bounds {
            origin: point(ScaledPixels(x), ScaledPixels(2.0)),
            size: Size {
                width: ScaledPixels(8.0),
                height: ScaledPixels(6.0),
            },
        }
    }

    #[test]
    fn serializes_sorted_scene_arrays_and_preserves_commands() {
        let mut scene = Scene::default();
        let bounds = test_bounds(1.0);
        scene.insert_primitive(Quad {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            ..Default::default()
        });
        scene.finish();

        let capture = SceneCapture::capture(&scene, |_| anyhow::bail!("unexpected tile"))
            .expect("capture quad scene");
        let json = serde_json::to_string(&capture).expect("serialize capture");
        let decoded: SceneCapture = serde_json::from_str(&json).expect("deserialize capture");
        let restored = decoded.into_scene().expect("restore scene");

        assert_eq!(restored.quads.len(), 1);
        assert_eq!(restored.quads[0].bounds, scene.quads[0].bounds);
        assert_eq!(restored.render_commands(), scene.render_commands());
    }

    #[test]
    fn capture_equality_covers_roundtrip_geometry_commands_and_bitmap_bytes() {
        let bounds = test_bounds(1.0);
        let mut scene = Scene::default();
        scene.insert_primitive(Quad {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            ..Default::default()
        });
        scene.insert_primitive(MonochromeSprite {
            order: 0,
            padding: 0,
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            color: SceneHsla::default(),
            tile: AtlasTile {
                texture_id: AtlasTextureId {
                    index: 17,
                    kind: AtlasTextureKind::Monochrome,
                },
                tile_id: TileId(23),
                padding: 0,
                bounds: Bounds {
                    origin: point(DevicePixels(0), DevicePixels(0)),
                    size: Size {
                        width: DevicePixels(2),
                        height: DevicePixels(2),
                    },
                },
            },
            transformation: TransformationMatrix::unit(),
        });
        scene.finish();

        let capture = SceneCapture::capture(&scene, |tile| {
            Ok(CapturedBitmap {
                kind: tile.texture_id.kind,
                width: 2,
                height: 2,
                bytes: vec![255; 4],
            })
        })
        .expect("capture scene");
        let json = serde_json::to_string(&capture).expect("serialize capture");
        let decoded: SceneCapture = serde_json::from_str(&json).expect("deserialize capture");
        assert_eq!(capture, decoded);

        let mut changed_geometry = capture.clone();
        changed_geometry.quads[0].bounds.origin.x.0 += 1.0;
        assert_ne!(capture, changed_geometry);

        let mut changed_commands = capture.clone();
        match &mut changed_commands.commands[0] {
            RenderCommand::Batch(PrimitiveBatch::Quads { smoothed, .. }) => *smoothed = !*smoothed,
            command => panic!("expected first command to be a quad batch, got {command:?}"),
        }
        assert_ne!(capture, changed_commands);

        let mut changed_bitmap = capture.clone();
        changed_bitmap.bitmaps[0].bytes[0] ^= 1;
        assert_ne!(capture, changed_bitmap);
    }

    #[test]
    fn canonicalizes_tile_pixels_and_texture_ids() {
        let source_texture = AtlasTextureId {
            index: 91,
            kind: AtlasTextureKind::Monochrome,
        };
        let source_tile = AtlasTile {
            texture_id: source_texture,
            tile_id: TileId(420),
            padding: 2,
            bounds: Bounds {
                origin: point(DevicePixels(8), DevicePixels(10)),
                size: Size {
                    width: DevicePixels(2),
                    height: DevicePixels(2),
                },
            },
        };
        let bounds = test_bounds(1.0);
        let sprite = MonochromeSprite {
            order: 0,
            padding: 0,
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            color: SceneHsla::default(),
            tile: source_tile,
            transformation: TransformationMatrix::unit(),
        };
        let mut scene = Scene::default();
        scene.insert_primitive(sprite);
        scene.finish();

        let capture = SceneCapture::capture(&scene, |tile| {
            assert_eq!(tile, source_tile);
            Ok(CapturedBitmap {
                kind: AtlasTextureKind::Monochrome,
                width: 2,
                height: 2,
                bytes: vec![1, 2, 3, 4],
            })
        })
        .expect("capture sprite scene");
        let restored = capture.to_scene().expect("restore sprite scene");
        let tile = restored.monochrome_sprites[0].tile;
        assert_eq!(tile.texture_id.index, 0);
        assert_eq!(tile.tile_id, TileId(0));
        assert_eq!(tile.padding, 0);
        assert_eq!(tile.bounds.origin, point(DevicePixels(0), DevicePixels(0)));
        assert_eq!(capture.bitmaps()[0].bytes, [1, 2, 3, 4]);
    }

    #[test]
    fn rejects_unsupported_versions_invalid_ranges_and_non_finite_values() {
        let mut scene = Scene::default();
        let bounds = test_bounds(1.0);
        scene.insert_primitive(Quad {
            bounds,
            content_mask: ContentMask {
                bounds,
                ..Default::default()
            },
            ..Default::default()
        });
        scene.finish();
        let mut capture = SceneCapture::capture(&scene, |_| anyhow::bail!("unexpected tile"))
            .expect("capture quad scene");

        let mut wrong_version = capture.clone();
        wrong_version.version += 1;
        assert!(
            wrong_version
                .into_scene()
                .err()
                .unwrap()
                .to_string()
                .contains("unsupported scene capture version")
        );

        capture.commands = vec![RenderCommand::Batch(PrimitiveBatch::Shadows {
            range: 0..1,
            smoothed: false,
        })];
        assert!(
            capture
                .into_scene()
                .err()
                .unwrap()
                .to_string()
                .contains("does not match compiled scene")
        );

        let mut invalid_scene = Scene::default();
        let mut invalid_quad = Quad::default();
        invalid_quad.corner_smoothing = f32::NAN;
        invalid_quad.bounds = bounds;
        invalid_quad.content_mask.bounds = bounds;
        invalid_scene.insert_primitive(invalid_quad);
        invalid_scene.finish();
        assert!(
            SceneCapture::capture(&invalid_scene, |_| anyhow::bail!("unexpected tile"))
                .unwrap_err()
                .to_string()
                .contains("non-finite")
        );
    }
}
