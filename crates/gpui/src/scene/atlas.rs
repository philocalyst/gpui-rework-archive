use crate::{
    AtlasKey, AtlasTextureId, AtlasTextureKind, AtlasTile, Bounds, CapturedBitmap, DevicePixels,
    GlyphAtlasEntry, PlatformAtlas, RenderGlyphParams, Size, TileId, ValidatedRasterizedGlyph,
};
use anyhow::{Context, Result, ensure};
use collections::HashMap;
use std::{
    borrow::Cow,
    sync::{Arc, Mutex},
};

/// An in-memory atlas for captured scene pixels and renderer-independent tests.
///
/// Each uploaded tile occupies its own texture, making allocation stable and
/// keeping the host renderer independent of windowing systems and graphics
/// APIs. Tile coordinates are in physical [`DevicePixels`]; this atlas accepts
/// only tile ID zero when resolving a bitmap.
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
}

impl SceneAtlas {
    /// Creates an empty atlas.
    pub fn new() -> Self {
        Self::default()
    }

    /// Builds an atlas from a capture's canonical bitmap list.
    ///
    /// Each bitmap's vector index becomes its texture index, as used by
    /// [`SceneCapture::bitmaps`](crate::SceneCapture::bitmaps). Returns an error if any bitmap has invalid
    /// dimensions or packed pixel data.
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
            let next = &mut data.next_by_kind[kind_slot(bitmap.kind)];
            *next = (*next).max(index as u32 + 1);
        }
        drop(data);
        Ok(atlas)
    }

    /// Inserts or replaces a captured bitmap at the supplied texture index.
    ///
    /// The texture kind must match the bitmap kind, and the bitmap must contain
    /// tightly packed data with valid dimensions. Replacing a slot changes the
    /// pixels resolved for every tile that references that texture ID.
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
        data.bitmaps.insert(texture_id, Arc::new(bitmap));
        Ok(())
    }

    /// Copies one tile's pixels into an owned portable value.
    ///
    /// This CPU atlas stores one bitmap per texture, so `tile_id` must be zero.
    /// Returns an error for an unknown texture ID, a mismatched texture kind,
    /// or an empty slot.
    pub fn resolve(&self, tile: AtlasTile) -> Result<CapturedBitmap> {
        Ok((*self.resolve_shared(tile)?).clone())
    }

    /// Shares immutable pixels after releasing the atlas lock.
    ///
    /// The returned `Arc` remains valid if the atlas is later changed or
    /// dropped. Replaying a scene can therefore reuse the same pixels without
    /// copying them on every frame. Returns the same lookup errors as
    /// [`Self::resolve`].
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

fn channels(kind: AtlasTextureKind) -> usize {
    if kind == AtlasTextureKind::Monochrome {
        1
    } else {
        4
    }
}
