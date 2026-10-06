//! Versioned, renderer-neutral snapshots of a finished scene.
//!
//! Captures store the sorted primitive arrays and the already-compiled command stream. Atlas
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
    fn validate(&self) -> Result<()> {
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

type TileKey = (u32, AtlasTextureKind, u32, i32, i32, i32, i32, u32);

fn tile_key(tile: AtlasTile) -> TileKey {
    (
        tile.texture_id.index,
        tile.texture_id.kind,
        tile.tile_id.0,
        tile.bounds.origin.x.0,
        tile.bounds.origin.y.0,
        tile.bounds.size.width.0,
        tile.bounds.size.height.0,
        tile.padding,
    )
}

/// A portable snapshot of a finished scene's sorted primitives and render commands.
///
/// Native paint surfaces contain backend-owned handles and cannot be represented here; capture
/// returns an error if the source scene contains any surfaces.
#[derive(Clone, Debug, Serialize, Deserialize)]
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

fn sprite_subcommand(
    command: &RenderCommand,
    texture_id: AtlasTextureId,
    range: std::ops::Range<usize>,
) -> RenderCommand {
    let RenderCommand::Batch(batch) = command else {
        unreachable!()
    };
    let batch = match batch {
        PrimitiveBatch::MonochromeSprites { .. } => {
            PrimitiveBatch::MonochromeSprites { texture_id, range }
        }
        PrimitiveBatch::SubpixelSprites { .. } => {
            PrimitiveBatch::SubpixelSprites { texture_id, range }
        }
        PrimitiveBatch::PolychromeSprites { smoothed, .. } => PrimitiveBatch::PolychromeSprites {
            texture_id,
            range,
            smoothed: *smoothed,
        },
        _ => unreachable!(),
    };
    RenderCommand::Batch(batch)
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
        let commands = scene.render_plan().commands().to_vec();
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

    /// Returns the preserved compiled renderer command stream.
    pub fn commands(&self) -> &[RenderCommand] {
        &self.commands
    }

    /// Restores a finished scene without consuming this capture.
    pub fn to_scene(&self) -> Result<Scene> {
        self.clone().into_scene()
    }

    /// Restores a finished scene while retaining its captured command order and batching.
    pub fn into_scene(self) -> Result<Scene> {
        self.validate()?;
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
        let mut remap = HashMap::<TileKey, AtlasTile>::new();
        let source_commands = std::mem::take(&mut self.commands);
        let mut commands = Vec::with_capacity(source_commands.len());
        for command in source_commands {
            let sprite_batch = match &command {
                RenderCommand::Batch(PrimitiveBatch::MonochromeSprites { range, .. }) => {
                    Some((AtlasTextureKind::Monochrome, range.clone()))
                }
                RenderCommand::Batch(PrimitiveBatch::SubpixelSprites { range, .. }) => {
                    Some((AtlasTextureKind::Subpixel, range.clone()))
                }
                RenderCommand::Batch(PrimitiveBatch::PolychromeSprites { range, .. }) => {
                    Some((AtlasTextureKind::Polychrome, range.clone()))
                }
                _ => None,
            };
            let Some((kind, range)) = sprite_batch else {
                commands.push(command);
                continue;
            };
            let mut run_start = range.start;
            let mut run_texture = None;
            for sprite_index in range.clone() {
                let source = self
                    .sprite_tile(sprite_index, kind)
                    .context("sprite batch range is out of bounds")?;
                let key = tile_key(source);
                let canonical = if let Some(tile) = remap.get(&key) {
                    *tile
                } else {
                    let bitmap = resolve_tile(source)
                        .with_context(|| format!("resolving atlas tile {:?}", source.tile_id))?;
                    bitmap.validate()?;
                    ensure!(
                        bitmap.kind == source.texture_id.kind,
                        "resolved bitmap kind does not match atlas tile kind"
                    );
                    let index =
                        u32::try_from(self.bitmaps.len()).context("too many captured bitmaps")?;
                    let tile = AtlasTile {
                        texture_id: AtlasTextureId {
                            index,
                            kind: bitmap.kind,
                        },
                        tile_id: TileId(0),
                        padding: 0,
                        bounds: Bounds {
                            origin: point(DevicePixels(0), DevicePixels(0)),
                            size: Size {
                                width: DevicePixels(bitmap.width as i32),
                                height: DevicePixels(bitmap.height as i32),
                            },
                        },
                    };
                    self.bitmaps.push(bitmap);
                    remap.insert(key, tile);
                    tile
                };
                self.set_sprite_tile(sprite_index, kind, canonical)
                    .context("sprite batch range is out of bounds")?;
                if let Some(previous) = run_texture {
                    if previous != canonical.texture_id {
                        commands.push(sprite_subcommand(
                            &command,
                            previous,
                            run_start..sprite_index,
                        ));
                        run_start = sprite_index;
                    }
                }
                run_texture = Some(canonical.texture_id);
            }
            if let Some(texture_id) = run_texture {
                commands.push(sprite_subcommand(
                    &command,
                    texture_id,
                    run_start..range.end,
                ));
            }
        }
        self.commands = commands;
        Ok(())
    }

    fn sprite_tile(&self, index: usize, kind: AtlasTextureKind) -> Option<AtlasTile> {
        match kind {
            AtlasTextureKind::Monochrome => {
                self.monochrome_sprites.get(index).map(|sprite| sprite.tile)
            }
            AtlasTextureKind::Subpixel => {
                self.subpixel_sprites.get(index).map(|sprite| sprite.tile)
            }
            AtlasTextureKind::Polychrome => {
                self.polychrome_sprites.get(index).map(|sprite| sprite.tile)
            }
        }
    }

    fn set_sprite_tile(
        &mut self,
        index: usize,
        kind: AtlasTextureKind,
        tile: AtlasTile,
    ) -> Option<()> {
        match kind {
            AtlasTextureKind::Monochrome => self
                .monochrome_sprites
                .get_mut(index)
                .map(|sprite| sprite.tile = tile),
            AtlasTextureKind::Subpixel => self
                .subpixel_sprites
                .get_mut(index)
                .map(|sprite| sprite.tile = tile),
            AtlasTextureKind::Polychrome => self
                .polychrome_sprites
                .get_mut(index)
                .map(|sprite| sprite.tile = tile),
        }
    }

    /// Checks the format version, primitive references, command ranges, filter nesting, bitmap
    /// data, and finite floating-point values.
    pub fn validate(&self) -> Result<()> {
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
        let scene = Scene {
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
        };
        ScenePlan::from_captured_commands(&scene, self.commands.clone())?;
        let value = serde_json::to_value(self).context("checking captured scene numbers")?;
        ensure!(
            !contains_json_null(&value),
            "captured scene contains a non-finite number"
        );
        ensure!(
            !contains_negative_dimensions(&value),
            "captured scene contains a negative dimension"
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
                .contains("shadow range out of bounds")
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
