use crate::{
    AtlasKey, AtlasTextureId, AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap, DevicePixels,
    GlyphAtlasEntry, PlatformAtlas, RenderGlyphParams, Size, TileId, ValidatedRasterizedGlyph,
};
use anyhow::{Context, Result, ensure};
use collections::{HashMap, HashSet};
use std::{
    borrow::Cow,
    sync::{Arc, Mutex},
};

/// An in-memory atlas. Each uploaded tile occupies its own texture, making allocation stable
/// and keeping the host renderer independent of windowing systems and graphics APIs.
#[derive(Default)]
pub struct SceneAtlas {
    data: Mutex<SceneAtlasData>,
}

#[derive(Default)]
struct SceneAtlasData {
    bitmaps: HashMap<AtlasTextureId, Arc<CapturedBitmap>>,
    ids_by_key: HashMap<AtlasKey, AtlasTile>,
    ids_by_glyph: HashMap<RenderGlyphParams, GlyphAtlasEntry>,
    next_by_kind: [u32; 3],
    bytes: usize,
}

impl SceneAtlas {
    /// Creates an empty atlas.
    pub fn new() -> Self {
        Self::default()
    }

    /// Builds an atlas from canonical SceneCapture resources. Bitmap vector indices are the
    /// canonical texture indices produced by SceneCapture.
    pub fn from_captured_bitmaps(bitmaps: &[CapturedBitmap]) -> Result<Self> {
        let atlas = Self::new();
        let mut data = atlas.data.lock().unwrap();
        for (index, bitmap) in bitmaps.iter().enumerate() {
            bitmap
                .validate()
                .with_context(|| format!("invalid captured atlas bitmap {index}"))?;
            data.bitmaps.insert(
                AtlasTextureId {
                    kind: bitmap.kind,
                    index: index as u32,
                },
                Arc::new(bitmap.clone()),
            );
            data.bytes += bitmap.bytes.len();
            let next = &mut data.next_by_kind[kind_slot(bitmap.kind)];
            *next = (*next).max(index as u32 + 1);
        }
        drop(data);
        Ok(atlas)
    }

    /// Inserts or replaces a canonical captured bitmap at the supplied texture index.
    pub fn insert_captured(
        &self,
        texture_id: AtlasTextureId,
        bitmap: CapturedBitmap,
    ) -> Result<()> {
        ensure!(
            texture_id.kind == bitmap.kind,
            "captured bitmap kind does not match texture id"
        );
        bitmap.validate()?;
        let next_index = texture_id.index.checked_add(1)
            .context("captured texture index cannot be incremented")?;
        let mut data = self.data.lock().unwrap();
        data.next_by_kind[kind_slot(texture_id.kind)] =
            data.next_by_kind[kind_slot(texture_id.kind)].max(next_index);
        data.bytes += bitmap.bytes.len();
        if let Some(previous) = data.bitmaps.insert(texture_id, Arc::new(bitmap)) {
            data.bytes -= previous.bytes.len();
        }
        Ok(())
    }

    /// Copies a tile's pixels into a portable value. SceneCapture canonical tiles use one bitmap per
    /// texture and tile id zero; ordinary atlas uploads use the same single-tile allocation.
    pub fn resolve(&self, tile: AtlasTile) -> Result<CapturedBitmap> {
        Ok((*self.resolve_shared(tile)?).clone())
    }

    /// Keeps immutable pixels alive after releasing the atlas lock. Replaying a
    /// scene can share the bitmap without copying it on every frame.
    pub fn resolve_shared(&self, tile: AtlasTile) -> Result<Arc<CapturedBitmap>> {
        ensure!(
            tile.tile_id == TileId(0),
            "CPU atlas does not recognize tile id {}",
            tile.tile_id.0
        );
        let atlas = self.data.lock().unwrap();
        let bitmap = atlas
            .bitmaps
            .get(&tile.texture_id)
            .context("CPU atlas texture index is missing")?;
        ensure!(
            bitmap.kind == tile.texture_id.kind,
            "CPU atlas texture kind mismatch"
        );
        ensure!(
            bitmap.width > 0 && bitmap.height > 0,
            "CPU atlas texture slot is empty"
        );
        Ok(bitmap.clone())
    }

    /// Bounds cached resources after a frame has been captured. Tiles referenced
    /// by that frame stay valid for GPUI's next-frame paint reuse. Captured frames
    /// and shared bitmap leases own their pixels independently of this cache.
    /// A single live scene can exceed the cache budget; its resources are never
    /// discarded merely to meet a limit.
    pub fn retain_frame_tiles(&self, live: &HashSet<AtlasTextureId>) {
        const MAX_BYTES: usize = 8 * 1024 * 1024;
        const MAX_ENTRIES: usize = 4096;
        let mut data = self.data.lock().unwrap();
        if data.bytes <= MAX_BYTES
            && data.ids_by_key.len() <= MAX_ENTRIES
            && data.ids_by_glyph.len() <= MAX_ENTRIES
        {
            return;
        }
        data.bitmaps.retain(|id, _| live.contains(id));
        data.ids_by_key
            .retain(|_, tile| live.contains(&tile.texture_id));
        data.ids_by_glyph.retain(|_, entry| {
            entry
                .tile
                .is_some_and(|tile| live.contains(&tile.texture_id))
        });
        data.bytes = data.bitmaps.values().map(|bitmap| bitmap.bytes.len()).sum();
    }

    fn upload(&self, key: &AtlasKey, size: Size<DevicePixels>, bytes: &[u8]) -> Result<AtlasTile> {
        let kind = key.texture_kind();
        ensure!(
            size.width.0 > 0 && size.height.0 > 0,
            "CPU atlas upload requires positive dimensions"
        );
        let expected = (size.width.0 as usize)
            .checked_mul(size.height.0 as usize)
            .and_then(|pixels| pixels.checked_mul(channels(kind)))
            .context("CPU atlas upload dimensions overflow")?;
        ensure!(
            bytes.len() == expected,
            "CPU atlas upload expected {expected} bytes, received {}",
            bytes.len()
        );
        let mut data = self.data.lock().unwrap();
        if let Some(tile) = data.ids_by_key.get(key) {
            return Ok(*tile);
        }
        let slot = kind_slot(kind);
        let index = data.next_by_kind[slot];
        data.next_by_kind[slot] += 1;
        let tile = AtlasTile {
            texture_id: AtlasTextureId { kind, index },
            tile_id: TileId(0),
            padding: 0,
            bounds: Bounds {
                origin: crate::point(DevicePixels(0), DevicePixels(0)),
                size,
            },
        };
        data.bitmaps.insert(
            tile.texture_id,
            Arc::new(CapturedBitmap {
                kind,
                width: size.width.0 as u32,
                height: size.height.0 as u32,
                bytes: bytes.to_vec(),
            }),
        );
        data.bytes += bytes.len();
        data.ids_by_key.insert(key.clone(), tile);
        Ok(tile)
    }
}

impl PlatformAtlas for SceneAtlas {
    fn get_or_insert_with<'a>(
        &self,
        key: &AtlasKey,
        build: &mut dyn FnMut() -> Result<Option<(Size<DevicePixels>, Cow<'a, [u8]>)>>,
    ) -> Result<Option<AtlasTile>> {
        if let Some(tile) = self.data.lock().unwrap().ids_by_key.get(key) {
            return Ok(Some(*tile));
        }
        let Some((size, bytes)) = build()? else {
            return Ok(None);
        };
        Ok(Some(self.upload(key, size, &bytes)?))
    }

    fn get_or_insert_glyph_with(
        &self,
        params: &RenderGlyphParams,
        build: &mut dyn FnMut() -> Result<ValidatedRasterizedGlyph>,
    ) -> Result<GlyphAtlasEntry> {
        if let Some(entry) = self.data.lock().unwrap().ids_by_glyph.get(params) {
            return Ok(*entry);
        }
        let glyph = build()?;
        if glyph.size.width.0 <= 0 || glyph.size.height.0 <= 0 {
            let entry = GlyphAtlasEntry {
                tile: None,
                bounds: glyph.bounds,
                format: glyph.format,
            };
            self.data
                .lock()
                .unwrap()
                .ids_by_glyph
                .insert(params.clone(), entry);
            return Ok(entry);
        }
        let key = AtlasKey::Glyph {
            params: params.clone(),
            format: glyph.format,
        };
        let tile = self.upload(&key, glyph.size, &glyph.pixels)?.into();
        let entry = GlyphAtlasEntry {
            tile,
            bounds: glyph.bounds,
            format: glyph.format,
        };
        self.data
            .lock()
            .unwrap()
            .ids_by_glyph
            .insert(params.clone(), entry);
        Ok(entry)
    }

    fn remove(&self, key: &AtlasKey) {
        let mut data = self.data.lock().unwrap();
        if let Some(tile) = data.ids_by_key.remove(key) {
            if let Some(bitmap) = data.bitmaps.remove(&tile.texture_id) {
                data.bytes -= bitmap.bytes.len();
            }
        }
        if let AtlasKey::Glyph { params, .. } = key {
            data.ids_by_glyph.remove(params);
        }
    }
}

fn kind_slot(kind: AtlasTextureKind) -> usize {
    match kind {
        AtlasTextureKind::Monochrome => 0,
        AtlasTextureKind::Polychrome => 1,
        AtlasTextureKind::Subpixel => 2,
    }
}

fn channels(kind: AtlasTextureKind) -> usize {
    if kind == AtlasTextureKind::Monochrome {
        1
    } else {
        4
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{
        FontId, GlyphId, GlyphRenderMode, PreparedRasterStyle, RasterizedGlyph,
        RasterizedGlyphFormat, point, px, size,
    };

    #[test]
    fn changing_glyph_variants_keep_live_tiles_and_bound_cached_pixels() {
        let atlas = SceneAtlas::new();
        let mut previous_lease: Option<(Arc<CapturedBitmap>, Vec<u8>)> = None;
        for variant in 0..1000 {
            let params = RenderGlyphParams {
                font_id: FontId(0),
                glyph_id: GlyphId(variant),
                font_size: px(variant as f32 + 10.),
                subpixel_variant: point(0, 0),
                scale_factor: 1.,
                raster_style: PreparedRasterStyle::independent(GlyphRenderMode::Grayscale),
            };
            let pixels = vec![(variant % 255) as u8; 128 * 128];
            let entry = atlas
                .get_or_insert_glyph_with(&params, &mut || {
                    ValidatedRasterizedGlyph::new(RasterizedGlyph {
                        bounds: Bounds::new(
                            point(DevicePixels(0), DevicePixels(0)),
                            size(DevicePixels(128), DevicePixels(128)),
                        ),
                        size: size(DevicePixels(128), DevicePixels(128)),
                        format: RasterizedGlyphFormat::AlphaMask,
                        pixels: pixels.clone(),
                    })
                })
                .unwrap();
            let tile = entry.tile.unwrap();
            let current = atlas.resolve_shared(tile).unwrap();
            atlas.retain_frame_tiles(&HashSet::from_iter([tile.texture_id]));
            assert_eq!(atlas.resolve(tile).unwrap().bytes, pixels);
            assert!(atlas.data.lock().unwrap().bytes <= 8 * 1024 * 1024);
            if let Some((lease, expected)) = previous_lease.take() {
                assert_eq!(lease.bytes, expected);
            }
            previous_lease = Some((current, pixels));
        }
        assert!(atlas.data.lock().unwrap().ids_by_glyph.len() <= 512);
    }

    #[test]
    fn empty_glyph_variants_do_not_accumulate_without_bitmaps() {
        let atlas = SceneAtlas::new();
        for variant in 0..9000 {
            let params = RenderGlyphParams {
                font_id: FontId(0),
                glyph_id: GlyphId(variant),
                font_size: px(12.),
                subpixel_variant: point(0, 0),
                scale_factor: 1.,
                raster_style: PreparedRasterStyle::independent(GlyphRenderMode::Grayscale),
            };
            atlas
                .get_or_insert_glyph_with(&params, &mut || {
                    ValidatedRasterizedGlyph::new(RasterizedGlyph::empty(
                        RasterizedGlyphFormat::AlphaMask,
                    ))
                })
                .unwrap();
            atlas.retain_frame_tiles(&HashSet::default());
            assert!(atlas.data.lock().unwrap().ids_by_glyph.len() <= 4096);
        }
    }
}
