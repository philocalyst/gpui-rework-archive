//! Compose portable GPUI scenes through the parent window's ordinary renderer.
use super::*;
use crate::{AtlasKey, PlatformAtlas};
use anyhow::{Result, ensure};
use std::{
    borrow::Cow,
    collections::HashMap,
    sync::{Arc, Weak},
};

struct Resource {
    bitmap: CapturedBitmap,
    tile: AtlasTile,
    key: AtlasKey,
    atlas: Arc<dyn PlatformAtlas>,
}
impl Drop for Resource {
    fn drop(&mut self) {
        self.atlas.remove(&self.key);
    }
}

/// Reuses imported atlas pixels across frames without owning unused resources.
///
/// Each imported scene holds strong references to its atlas resources. The cache
/// stores weak references so dropping the last [`ImportedScene`] removes its
/// imported atlas entries. Keep the imported scene alive for as long as its
/// sprites may be rendered.
#[derive(Default)]
pub struct SceneResources {
    entries: HashMap<u64, Vec<Weak<Resource>>>,
}

/// A captured scene whose sprite tiles belong to the destination window's atlas.
///
/// This handle keeps imported atlas pixels alive. Drop it when the scene will no
/// longer be rendered so the atlas can release those entries. Use the window's
/// scene-import and append APIs to compose it through the window's normal scene
/// recorder and renderer.
pub struct ImportedScene {
    scene: Scene,
    _resources: Vec<Arc<Resource>>,
}
impl SceneResources {
    pub(crate) fn import(
        &mut self,
        capture: &SceneCapture,
        atlas: Arc<dyn PlatformAtlas>,
    ) -> Result<ImportedScene> {
        let mut scene = capture.to_scene()?;
        let mut resources = Vec::with_capacity(capture.bitmaps().len());
        // Weak entries never own GPU resources or pixel data. Prune old generations.
        self.entries.retain(|_, values| {
            values.retain(|value| value.strong_count() != 0);
            !values.is_empty()
        });
        for bitmap in capture.bitmaps() {
            let hash = seahash::hash(&bitmap.bytes);
            let entries = self.entries.entry(hash).or_default();
            let existing = entries.iter().filter_map(Weak::upgrade).find(|resource| {
                Arc::ptr_eq(&resource.atlas, &atlas) && resource.bitmap == *bitmap
            });
            let resource = match existing {
                Some(resource) => resource,
                None => {
                    let key = AtlasKey::Captured {
                        resource: uuid::Uuid::new_v4(),
                        kind: bitmap.kind,
                    };
                    let size = Size::new(
                        DevicePixels(bitmap.width as i32),
                        DevicePixels(bitmap.height as i32),
                    );
                    let tile = atlas
                        .get_or_insert_with(&key, &mut || {
                            Ok(Some((size, Cow::Borrowed(bitmap.bytes.as_slice()))))
                        })?
                        .ok_or_else(|| anyhow::anyhow!("captured atlas upload produced no tile"))?;
                    let resource = Arc::new(Resource {
                        bitmap: bitmap.clone(),
                        tile,
                        key,
                        atlas: atlas.clone(),
                    });
                    entries.push(Arc::downgrade(&resource));
                    resource
                }
            };
            resources.push(resource);
        }
        for sprite in &mut scene.monochrome_sprites {
            sprite.tile = resources[sprite.tile.texture_id.index as usize].tile;
        }
        for sprite in &mut scene.subpixel_sprites {
            sprite.tile = resources[sprite.tile.texture_id.index as usize].tile;
        }
        for sprite in &mut scene.polychrome_sprites {
            sprite.tile = resources[sprite.tile.texture_id.index as usize].tile;
        }
        // Tile IDs changed, so reconstruct the command plan using the local atlas.
        scene.finish();
        Ok(ImportedScene {
            scene,
            _resources: resources,
        })
    }
}

impl Scene {
    pub(crate) fn append_imported(
        &mut self,
        imported: &ImportedScene,
        offset: Point<ScaledPixels>,
        scale: f32,
        clip: ContentMask<ScaledPixels>,
        opacity: f32,
    ) -> Result<()> {
        ensure!(
            scale.is_finite() && scale > 0.,
            "scene scale must be positive and finite"
        );
        let source = &imported.scene;
        let mut insert = |mut primitive: Primitive| {
            transform(&mut primitive, offset, scale, clip, opacity);
            self.insert_primitive(primitive);
        };
        for batch in source.batches() {
            match batch {
                PrimitiveBatch::Shadows { range, .. } => {
                    for primitive in source.shadows[range].iter().copied().map(Primitive::Shadow) {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::Quads { range, .. } => {
                    for primitive in source.quads[range].iter().copied().map(Primitive::Quad) {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::Paths { range, .. } => {
                    for primitive in source.paths[range].iter().cloned().map(Primitive::Path) {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::Underlines(range) => {
                    for primitive in source.underlines[range]
                        .iter()
                        .copied()
                        .map(Primitive::Underline)
                    {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::MonochromeSprites { range, .. } => {
                    for primitive in source.monochrome_sprites[range]
                        .iter()
                        .copied()
                        .map(Primitive::MonochromeSprite)
                    {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::SubpixelSprites { range, .. } => {
                    for primitive in source.subpixel_sprites[range]
                        .iter()
                        .copied()
                        .map(Primitive::SubpixelSprite)
                    {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::PolychromeSprites { range, .. } => {
                    for primitive in source.polychrome_sprites[range]
                        .iter()
                        .copied()
                        .map(Primitive::PolychromeSprite)
                    {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::BackdropFilters(range) => {
                    for primitive in source.backdrop_filters[range]
                        .iter()
                        .cloned()
                        .map(Primitive::BackdropFilter)
                    {
                        insert(primitive);
                    }
                }
                PrimitiveBatch::FilterBoundary(index) => insert(Primitive::FilterBoundary(
                    source.filter_boundaries[index].clone(),
                )),
                PrimitiveBatch::Surfaces(_) => {
                    anyhow::bail!("portable scenes cannot contain native surface handles")
                }
            }
        }
        Ok(())
    }
}
fn transform(
    p: &mut Primitive,
    offset: Point<ScaledPixels>,
    scale: f32,
    clip: ContentMask<ScaledPixels>,
    opacity: f32,
) {
    let unit = |v: &ScaledPixels| ScaledPixels(v.0 * scale);
    let bounds = |b: Bounds<ScaledPixels>| Bounds {
        origin: b.origin.map(|v| ScaledPixels(v.0 * scale)) + offset,
        size: b.size.map(|v| ScaledPixels(v.0 * scale)),
    };
    let mask = |m: ContentMask<ScaledPixels>| {
        let m = ContentMask {
            bounds: bounds(m.bounds),
            fade_out: m.fade_out.map(unit),
        };
        m.intersect(&clip)
    };
    let matrix = TransformationMatrix {
        rotation_scale: [[scale, 0.], [0., scale]],
        translation: [offset.x.0, offset.y.0],
    };
    match p {
        Primitive::Shadow(v) => {
            v.bounds = bounds(v.bounds);
            v.element_bounds = bounds(v.element_bounds);
            v.content_mask = mask(v.content_mask);
            v.corner_radii = v.corner_radii.map(unit);
            v.element_corner_radii = v.element_corner_radii.map(unit);
            v.blur_radius = unit(&v.blur_radius);
            v.color = v.color.opacity(opacity);
        }
        Primitive::Quad(v) => {
            v.bounds = bounds(v.bounds);
            v.content_mask = mask(v.content_mask);
            v.corner_radii = v.corner_radii.map(unit);
            v.border_widths = v.border_widths.map(unit);
            v.border_dashed_length *= scale;
            v.border_dashed_gap *= scale;
            v.background = v.background.opacity(opacity);
            v.border_color = v.border_color.opacity(opacity);
        }
        Primitive::Path(v) => {
            v.bounds = bounds(v.bounds);
            v.content_mask = mask(v.content_mask);
            v.start = v.start.map(|v| ScaledPixels(v.0 * scale)) + offset;
            v.current = v.current.map(|v| ScaledPixels(v.0 * scale)) + offset;
            for vertex in &mut v.vertices {
                vertex.xy_position = vertex.xy_position.map(|v| ScaledPixels(v.0 * scale)) + offset;
                vertex.content_mask = mask(vertex.content_mask);
            }
            v.color = v.color.opacity(opacity);
        }
        Primitive::Underline(v) => {
            v.bounds = bounds(v.bounds);
            v.content_mask = mask(v.content_mask);
            v.thickness = unit(&v.thickness);
            v.color.a *= opacity;
        }
        // Sprite bounds remain in their local coordinates; compose the screen transform once.
        Primitive::MonochromeSprite(v) => {
            v.content_mask = mask(v.content_mask);
            v.transformation = matrix.compose(v.transformation);
            v.color.a *= opacity;
        }
        Primitive::SubpixelSprite(v) => {
            v.content_mask = mask(v.content_mask);
            v.transformation = matrix.compose(v.transformation);
            v.color.a *= opacity;
        }
        Primitive::PolychromeSprite(v) => {
            v.bounds = bounds(v.bounds);
            v.content_mask = mask(v.content_mask);
            v.corner_radii = v.corner_radii.map(unit);
            v.opacity *= opacity;
        }
        Primitive::BackdropFilter(v) => {
            v.bounds = bounds(v.bounds);
            v.content_mask = mask(v.content_mask);
            v.corner_radii = v.corner_radii.map(unit);
            for f in &mut v.filters {
                match f {
                    ScaledFilter::Blur(r) => *r = unit(r),
                }
            }
            v.opacity *= opacity;
        }
        Primitive::FilterBoundary(v) => {
            v.bounds = bounds(v.bounds);
            v.content_mask = mask(v.content_mask);
            v.corner_radii = v.corner_radii.map(unit);
            for f in &mut v.filters {
                match f {
                    ScaledFilter::Blur(r) => *r = unit(r),
                }
            }
            v.opacity *= opacity;
        }
        Primitive::Surface(_) => unreachable!("captures exclude platform surface handles"),
    }
}

#[cfg(test)]
#[path = "embed_tests.rs"]
mod tests;
