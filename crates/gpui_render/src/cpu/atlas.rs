use super::channels;
use anyhow::{Context, Result, ensure};
use gpui::{
    AtlasKey, AtlasTextureId, AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap,
    DevicePixels, GlyphAtlasEntry, PlatformAtlas, RenderGlyphParams, Size,
    TileId, ValidatedRasterizedGlyph,
};
use std::{borrow::Cow, collections::HashMap, sync::Mutex};

/// An in-memory atlas. Each uploaded tile occupies its own texture, making allocation stable
/// and keeping the host renderer independent of windowing systems and graphics APIs.
#[derive(Default)]
pub struct CpuAtlas {
    data: Mutex<CpuAtlasData>,
}

#[derive(Default)]
struct CpuAtlasData {
    bitmaps: HashMap<AtlasTextureId, CapturedBitmap>,
    ids_by_key: HashMap<AtlasKey, AtlasTile>,
    ids_by_glyph: HashMap<RenderGlyphParams, GlyphAtlasEntry>,
    next_by_kind: [u32; 3],
}

impl CpuAtlas {
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
                bitmap.clone(),
            );
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
        let mut data = self.data.lock().unwrap();
        data.next_by_kind[kind_slot(texture_id.kind)] =
            data.next_by_kind[kind_slot(texture_id.kind)].max(texture_id.index + 1);
        data.bitmaps.insert(texture_id, bitmap);
        Ok(())
    }

    /// Resolves a tile to its retained bitmap. SceneCapture canonical tiles use one bitmap per
    /// texture and tile id zero; ordinary atlas uploads use the same single-tile allocation.
    pub fn resolve(&self, tile: AtlasTile) -> Result<CapturedBitmap> {
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

    fn upload(&self, key: &AtlasKey, size: Size<DevicePixels>, bytes: &[u8]) -> Result<AtlasTile> {
        let kind = key.texture_kind();
        ensure!(
            size.width.0 > 0
                && size.height.0 > 0
                && size.width.0 <= i32::MAX
                && size.height.0 <= i32::MAX,
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
                origin: gpui::point(DevicePixels(0), DevicePixels(0)),
                size,
            },
        };
        data.bitmaps.insert(
            tile.texture_id,
            CapturedBitmap {
                kind,
                width: size.width.0 as u32,
                height: size.height.0 as u32,
                bytes: bytes.to_vec(),
            },
        );
        data.ids_by_key.insert(key.clone(), tile);
        Ok(tile)
    }
}

impl PlatformAtlas for CpuAtlas {
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
            data.bitmaps.remove(&tile.texture_id);
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
