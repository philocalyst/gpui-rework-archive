//! Reuse admitted text witnesses from the exclusively borrowed predecessor.
//! This is bounded sequential discovery, not a retained second scene/cache.
use super::*;

#[derive(Default)]
pub(super) struct Replay {
    next: usize,
    masks: Vec<Option<u16>>,
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn unchanged_public_staging_uses_the_predecessor_certificate() {
        let mut text = TextSystem::bundled().unwrap();
        let layout = text.shape("retained run", 14., None).unwrap();
        let mut canvas = Canvas::new(128, 64).unwrap();
        let origin = Point { x: 0., y: 0. };
        let clip = Rect::new(0., 0., 128., 64.);
        canvas
            .draw_text(
                &mut text,
                &layout,
                origin,
                Affine::IDENTITY,
                clip,
                Color::BLACK,
            )
            .unwrap();
        let mut stage = canvas.stage();
        stage
            .draw_text_scaled(
                &mut text,
                &layout,
                origin,
                Affine::IDENTITY,
                clip,
                Color::BLACK,
                1.,
            )
            .unwrap();
        assert_eq!(stage.replay.next, 1);
        assert_eq!(
            stage.pending.commands.order.len(),
            stage.target.commands.order.len()
        );
    }
}

impl Replay {
    pub(super) fn clear(&mut self) {
        self.next = 0;
        self.masks.fill(None);
    }
    #[allow(clippy::too_many_arguments)]
    pub(super) fn text(
        &mut self,
        previous: &Canvas,
        next: &mut Canvas,
        text: &TextSystem,
        layout: &TextLayout,
        origin: Point,
        transform: Affine,
        clip: Clip,
        color: Color,
        raster_scale: f32,
    ) -> Result<bool, Error> {
        let Clip::Rect(clip) = clip else {
            return Ok(false);
        };
        if layout.glyphs().len() < 2 {
            return Ok(false);
        }
        let rgba = color.premultiplied().map(f32::to_bits);
        let point_bits = |p: Point| [p.x, p.y].map(f32::to_bits);
        let rect_bits = |r: Rect| [r.x, r.y, r.width, r.height].map(f32::to_bits);
        let affine_bits = |a: Affine| [a.a, a.b, a.c, a.d, a.tx, a.ty].map(f32::to_bits);
        let found = previous
            .commands
            .commons
            .iter()
            .enumerate()
            .skip(self.next)
            .take(8)
            .find(|(_, group)| {
                if !group.glyphs.same_layout(layout)
                    || point_bits(group.origin) != point_bits(origin)
                    || affine_bits(group.transform) != affine_bits(transform)
                    || group.raster_scale.to_bits() != raster_scale.to_bits()
                {
                    return false;
                }
                let common = previous.commands.columns.resolve(
                    group.common,
                    viewport_rect(previous.width, previous.height),
                    false,
                );
                previous.commands.clip_chain(common.clip).is_none()
                    && rect_bits(common.clip) == rect_bits(clip)
                    && common.color.map(f32::to_bits) == rgba
            });
        let Some((index, group)) = found else {
            return Ok(false);
        };
        // The predecessor and layout simultaneously lease immutable glyph
        // positions. Exact forward transform/clip/scale preserve admission;
        // inverse equality alone would not certify forward-rounded bounds.
        text.validate(layout)?;
        let old = &previous.commands.order[group.range[0] as usize..group.range[1] as usize];
        let references: usize = old
            .iter()
            .map(|a| {
                let [l, t, r, b] = a.bounds.map(usize::from);
                ((r - 1) / TILE - l / TILE + 1) * ((b - 1) / TILE - t / TILE + 1)
            })
            .sum();
        if next.commands.order.len() + old.len() > MAX_COMMANDS
            || next.references + references > MAX_REFERENCES
        {
            return Err(Error::ResourceLimit);
        }
        let common = Common {
            clip,
            map: Mapping::new(transform)?,
            color: color.premultiplied(),
        };
        let viewport = viewport_rect(next.width, next.height);
        next.commands
            .columns
            .admit(common, viewport, None, false, false)?;
        next.commands.reserve_draws(old.len())?;
        next.commands
            .commons
            .try_reserve(1)
            .map_err(|_| Error::ResourceLimit)?;
        if self.masks.is_empty() {
            self.masks
                .try_reserve_exact(previous.commands.masks.len())
                .map_err(|_| Error::ResourceLimit)?;
            self.masks.resize(previous.commands.masks.len(), None);
        }
        let start = next.commands.order.len();
        let masks = next.commands.masks.len();
        let face = next.commands.mask_index.face;
        let mut bytes = 0;
        let admitted = (|| {
            for address in old {
                let source = usize::from(address.mask);
                let remapped = match self.masks[source] {
                    Some(index) => index,
                    None => {
                        let mask = &previous.commands.masks[source];
                        let index = if let Some(&index) = next.commands.mask_index.get(&mask.key) {
                            index as u16
                        } else {
                            bytes += mask.pixels.len();
                            if next.mask_bytes + bytes > MAX_MASK_BYTES {
                                return Err(Error::ResourceLimit);
                            }
                            next.commands
                                .masks
                                .try_reserve(1)
                                .map_err(|_| Error::ResourceLimit)?;
                            next.commands.mask_index.reserve_key(mask.key)?;
                            let index = next.commands.masks.len() as u16;
                            next.commands.masks.push(mask.clone());
                            next.commands.mask_index.insert(mask.key, u32::from(index));
                            index
                        };
                        self.masks[source] = Some(index);
                        index
                    }
                };
                next.commands.order.push(DrawRef {
                    command: next.commands.commons.len() as u16,
                    mask: remapped,
                    ..*address
                });
            }
            Ok(())
        })();
        if let Err(error) = admitted {
            next.commands.order.truncate(start);
            for mask in next.commands.masks.drain(masks..) {
                next.commands.mask_index.remove(mask.key);
            }
            next.commands.mask_index.face = face;
            self.masks.clear();
            return Err(error);
        }
        let stored = next.commands.columns.store(common, viewport, None, false);
        next.commands.publish_group(
            start,
            stored,
            layout.shared_glyphs(),
            origin,
            MetricScale::new(raster_scale),
            transform,
            raster_scale,
        );
        next.references += references;
        next.mask_bytes += bytes;
        next.invalidate_bins();
        next.dirty = true;
        self.next = index + 1;
        Ok(true)
    }
}
