//! Material-independent clip prefixes share WORDS before immutable material
//! tails. Existing draw/common records and storage bindings do not grow.
use super::{Error, Word, float_word, validate_draw};
use gpui_canvas::{MAX_CLIP_NODES, PreparedDraw, PreparedScene, PreparedSource, Rect};
const WORDS: usize = 5;
const MARKER: u32 = 0x7fc0_0003;
const MAX_BYTES: usize = MAX_CLIP_NODES * WORDS * 16;
// Chain starts precede immutable material tails. Draw records use <=6 words
// per placement; the paint prefix has <=2*MAX_DRAWS color rows plus flags/header.
// This proves the shader's sample-local cache sentinel cannot name a chain.
const _: () = assert!(
    super::MAX_DRAWS * 8 + super::MAX_DRAWS / 32 + 1 + MAX_CLIP_NODES * WORDS < u32::MAX as usize
);

pub(super) fn reference(base: usize, index: u32) -> Result<Word, Error> {
    let word = base
        .checked_add(index as usize * WORDS)
        .ok_or(Error::ResourceLimit)?;
    Ok([
        MARKER,
        u32::try_from(word).map_err(|_| Error::ResourceLimit)?,
        0,
        0,
    ])
}
pub(super) fn append(records: &mut Vec<Word>, scene: PreparedScene<'_>) -> Result<(), Error> {
    if !scene.groups().any(|group| group.clip_chain().is_some()) {
        return Ok(());
    }
    let count = scene.clip_nodes().count();
    let bytes = count.checked_mul(WORDS * 16).ok_or(Error::ResourceLimit)?;
    if count > MAX_CLIP_NODES || bytes > MAX_BYTES {
        return Err(Error::ResourceLimit);
    }
    records
        .try_reserve(count * WORDS)
        .map_err(|_| Error::ResourceLimit)?;
    let base = records.len();
    let viewport = Rect::new(0.0, 0.0, scene.width as f32, scene.height as f32);
    for (index, mut node) in scene.clip_nodes().enumerate() {
        if let Some(rect) = node.raster_rect {
            node.local_rect = rect;
            node.inverse = [1.0, -0.0, -0.0, 1.0, 0.0, 0.0];
            node.radius = 0.0;
            node.parent = None;
        }
        let radius = node
            .radius
            .min(node.local_rect.width * 0.5)
            .min(node.local_rect.height * 0.5);
        validate_draw(
            PreparedDraw {
                local_rect: node.local_rect,
                inverse: node.inverse,
                clip: viewport,
                bounds: viewport,
                color: [1.0; 4],
                clip_chain: None,
                source: if radius == 0.0 {
                    PreparedSource::Solid
                } else {
                    PreparedSource::RoundedRect(radius)
                },
            },
            index,
            scene.width,
            scene.height,
        )?;
        let parent = if let Some(parent) = node.parent {
            if parent as usize >= index {
                return Err(Error::InvalidScene);
            }
            reference(base, parent)?[1]
        } else {
            0
        };
        let high = node.inverse.map(|value| value as f32);
        let low = std::array::from_fn::<_, 6, _>(|lane| {
            (node.inverse[lane] - f64::from(high[lane])) as f32
        });
        let scale = if radius == 0.0 {
            1.0
        } else {
            f32::from_bits((254 - (radius.to_bits() >> 23)) << 23)
        };
        let rect = node.local_rect;
        records.extend_from_slice(&[
            float_word([rect.x, rect.y, rect.width, rect.height]),
            float_word([high[0], high[2], high[4], radius]),
            float_word([high[1], high[3], high[5], scale]),
            [low[0].to_bits(), low[2].to_bits(), low[4].to_bits(), parent],
            float_word([low[1], low[3], low[5], 0.0]),
        ]);
    }
    Ok(())
}
