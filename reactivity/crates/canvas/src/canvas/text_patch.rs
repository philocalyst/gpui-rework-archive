//! Bounded text replacement in an already admitted canonical scene.
use super::*;

/// Positional grouped text run in one complete scene, like `PaintSlot`.
/// Pair with the owner's scene token; scene replacement reuses positions.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct TextRunSlot(std::num::NonZeroU32);

impl CanvasScene<'_> {
    /// Record ordinary literal text and identify its grouped run when present.
    /// Empty and singleton admission returns no replaceable run.
    #[allow(clippy::too_many_arguments)]
    pub fn draw_text_scaled_tracked(
        &mut self,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: impl Into<Clip>,
        color: Color,
        raster_scale: f32,
    ) -> Result<Option<TextRunSlot>, Error> {
        let before = self.pending.commands.commons.len();
        self.pending.draw_text_scaled(
            text,
            layout,
            origin,
            transform,
            clip,
            color,
            raster_scale,
        )?;
        Ok((self.pending.commands.commons.len() == before + 1)
            .then(|| TextRunSlot(std::num::NonZeroU32::new(before as u32 + 1).unwrap())))
    }
}

impl Canvas {
    /// Transactionally replace a run without changing painter-order addresses.
    /// `None` means the caller must prepare a complete scene: the grouped
    /// length, common state or already leased raster resources did not match.
    /// Rejection/error leaves the entire preceding scene and pixels unchanged.
    #[allow(clippy::too_many_arguments)]
    pub fn try_patch_text(
        &mut self,
        slot: TextRunSlot,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
        raster_scale: f32,
    ) -> Result<Option<DamageRegion>, Error> {
        self.try_patch_text_observed(
            slot,
            text,
            layout,
            origin,
            transform,
            clip,
            color,
            raster_scale,
            |_| {},
        )
    }

    /// Replace a text run and observe conservative old/new bounds of only the
    /// changed painter-order contributions. Common state and immutable raster
    /// leases are validated before observation; rejection observes nothing.
    /// Bounds may overlap. A caller repairing several regions must deduplicate
    /// them. The observer runs before commit; if it panics, this Canvas is intact.
    #[allow(clippy::too_many_arguments)]
    pub fn try_patch_text_observed(
        &mut self,
        slot: TextRunSlot,
        text: &mut TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Rect,
        color: Color,
        raster_scale: f32,
        mut observe: impl FnMut(DamageRegion),
    ) -> Result<Option<DamageRegion>, Error> {
        let index = slot.0.get() as usize - 1;
        let Some(old) = self.commands.commons.get(index) else {
            return Ok(None);
        };
        text.validate(layout)?;
        let mut prepared =
            Self::recording(self.width as u32, self.height as u32, self.color_config)?;
        prepared.draw_text_scaled(text, layout, origin, transform, clip, color, raster_scale)?;
        if prepared.commands.commons.len() != 1
            || !prepared.commands.inline.is_empty()
            || prepared.commands.order.len() != (old.range[1] - old.range[0]) as usize
        {
            return Ok(None);
        }
        let viewport = viewport_rect(self.width, self.height);
        let a = self.commands.columns.resolve(old.common, viewport, false);
        let b =
            prepared
                .commands
                .columns
                .resolve(prepared.commands.commons[0].common, viewport, false);
        let rect_bits = |r: Rect| [r.x, r.y, r.width, r.height].map(f32::to_bits);
        if self.commands.clip_chain(a.clip).is_some()
            || rect_bits(a.clip) != rect_bits(b.clip)
            || a.map.inverse.map(f64::to_bits) != b.map.inverse.map(f64::to_bits)
            || a.color.map(f32::to_bits) != b.color.map(f32::to_bits)
        {
            return Ok(None);
        }
        // Remap only into existing leases. No historical resource accumulation.
        for address in &mut prepared.commands.order {
            let key = prepared.commands.masks[usize::from(address.mask)].key;
            let Some(&mask) = self.commands.mask_index.get(&key) else {
                return Ok(None);
            };
            address.command = index as u16;
            address.mask = mask as u16;
        }
        let range = old.range[0] as usize..old.range[1] as usize;
        let references = |addresses: &[DrawRef]| -> usize {
            addresses
                .iter()
                .map(|a| {
                    let [l, t, r, b] = a.bounds.map(usize::from);
                    ((r - 1) / TILE - l / TILE + 1) * ((b - 1) / TILE - t / TILE + 1)
                })
                .sum()
        };
        let next_references =
            self.references - references(&self.commands.order[range.clone()]) + prepared.references;
        if next_references > MAX_REFERENCES {
            return Ok(None);
        }
        // Do not retain a resource whose last admitted use disappears. The
        // existing scene's exact use counts make this test local to this run.
        let mut old_masks: Vec<_> = self.commands.order[range.clone()]
            .iter()
            .map(|a| a.mask)
            .collect();
        let mut new_masks: Vec<_> = prepared.commands.order.iter().map(|a| a.mask).collect();
        old_masks.sort_unstable();
        new_masks.sort_unstable();
        for &mask in &old_masks {
            let count = |masks: &[u16]| {
                masks.partition_point(|&m| m <= mask) - masks.partition_point(|&m| m < mask)
            };
            if self.commands.masks[usize::from(mask)].uses as usize + count(&new_masks)
                == count(&old_masks)
            {
                return Ok(None);
            }
        }
        let mut damage = DamageRegion::default();
        let new = &prepared.commands.commons[0];
        for (&before, &after) in self.commands.order[range.clone()]
            .iter()
            .zip(&prepared.commands.order)
        {
            let rect = |run: &CommonGroup, address: DrawRef| {
                glyph_rect(
                    run.origin,
                    run.glyphs.position(address.glyph),
                    &self.commands.masks[usize::from(address.mask)],
                    run.scale,
                )
            };
            // Both addresses now name leases in the preceding scene. Common
            // map/color/clip bits are already equal. Equal bounds alone cannot
            // prove equal sampling: fractional local placement matters too.
            if before.mask == after.mask
                && before.bounds == after.bounds
                && rect_bits(rect(old, before)) == rect_bits(rect(new, after))
            {
                continue;
            }
            for address in [before, after] {
                let support = DamageRegion::checked_canvas_bounds(address.bounds.map(usize::from));
                damage = damage.union(support);
                observe(support);
            }
        }
        // All fallible admission is complete. Painter order, resource counts
        // and common-state ownership remain unchanged.
        let mut group = prepared.commands.commons.pop().unwrap();
        group.common = old.common;
        group.range = old.range;
        self.commands
            .columns
            .support(group.common.paint, damage, false);
        for mask in old_masks {
            self.commands.masks[usize::from(mask)].uses -= 1;
        }
        for mask in new_masks {
            self.commands.masks[usize::from(mask)].uses += 1;
        }
        self.commands.order[range].copy_from_slice(&prepared.commands.order);
        self.commands.commons[index] = group;
        self.references = next_references;
        self.invalidate_bins();
        self.dirty = true;
        Ok(Some(damage))
    }
}
