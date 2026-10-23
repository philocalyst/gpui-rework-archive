//! Packed immutable pixels share the existing WORDS buffer after its draw
//! prefix. Stable scenes upload no pixels; no fifth storage binding is needed.
use super::{Buffer, Error};
use gpui_canvas::{AlphaMode, ImageKey, ImagePixels, ImageProfile, ImageSampling, PreparedScene};
use std::collections::HashMap;

pub(super) const IMAGE: u32 = 1 << 31;
pub(super) const FILTER_LINEAR: u32 = 1;
const PREMULTIPLIED: u32 = 2;
const DISPLAY_P3: u32 = 4;
const LINEAR_RGBA: u32 = 8;
pub(super) const ROUNDED: u32 = 16;
const _: () = assert!(ROUNDED & (FILTER_LINEAR | PREMULTIPLIED | DISPLAY_P3 | LINEAR_RGBA) == 0);
const _: () = assert!(
    (FILTER_LINEAR | PREMULTIPLIED | DISPLAY_P3 | LINEAR_RGBA | ROUNDED)
        < 1 << super::RESOURCE_BITS
);

#[derive(Clone, Copy, Debug, Default)]
pub struct ImageStats {
    pub resources: usize,
    pub packed_bytes: usize,
    pub uploaded_bytes: usize,
    pub prefix_bytes: usize,
    pub gpu_buffer_bytes: u64,
    /// Hash-table entries, excluding opaque allocator/control-byte overhead.
    pub index_capacity: usize,
}
#[derive(Clone, Copy)]
struct Entry {
    word: u32,
    flags: u32,
}
pub(super) struct Images {
    keys: Vec<ImageKey>,
    entries: HashMap<ImageKey, Entry>,
    prefix_words: usize,
    stats: ImageStats,
}
impl Images {
    pub(super) fn stats(&self) -> ImageStats {
        self.stats
    }
    pub(super) fn redrawn(&mut self) {
        self.stats.uploaded_bytes = 0;
    }
    pub(super) fn metadata(&self, key: ImageKey, sampling: ImageSampling) -> [u32; 2] {
        let entry = self.entries[&key];
        [
            IMAGE | entry.word,
            entry.flags
                | if sampling == ImageSampling::Linear {
                    FILTER_LINEAR
                } else {
                    0
                },
        ]
    }
}

pub(super) fn prepare(
    device: &wgpu::Device,
    queue: &wgpu::Queue,
    buffer: &mut Buffer,
    current: &mut Option<Box<Images>>,
    draw_words: usize,
    scene: PreparedScene<'_>,
) -> Result<(), Error> {
    let count = scene.images().count();
    if count == 0 {
        if current.take().is_some() {
            // Submitted bind groups retain their own old buffer leases.
            *buffer = Buffer::new(
                device,
                "scene data",
                (draw_words * 16).max(256).next_power_of_two() as u64,
                false,
            );
        }
        return Ok(());
    }
    if let Some(current) = current.as_mut()
        && draw_words <= current.prefix_words
        && current
            .keys
            .iter()
            .copied()
            .eq(scene.images().map(|image| image.key()))
    {
        current.stats.uploaded_bytes = 0;
        return Ok(());
    }
    let prefix_words = draw_words
        .max(1)
        .checked_next_power_of_two()
        .ok_or(Error::ResourceLimit)?;
    // Build an unpublished complete index. Allocation/admission failure leaves
    // the old cache coherent; no image lease or linear CPU mirror is retained.
    let mut next = Images {
        keys: Vec::new(),
        entries: HashMap::new(),
        prefix_words,
        stats: ImageStats::default(),
    };
    next.keys
        .try_reserve_exact(count)
        .map_err(|_| Error::ResourceLimit)?;
    next.entries
        .try_reserve(count)
        .map_err(|_| Error::ResourceLimit)?;
    let mut words = prefix_words;
    for image in scene.images() {
        let bytes = image.pixel_bytes();
        next.stats.packed_bytes = next
            .stats
            .packed_bytes
            .checked_add(bytes)
            .ok_or(Error::ResourceLimit)?;
        if next.stats.packed_bytes > gpui_canvas::MAX_IMAGE_SCENE_BYTES {
            return Err(Error::ResourceLimit);
        }
        let word = u32::try_from(words).map_err(|_| Error::ResourceLimit)?;
        if word >= IMAGE {
            return Err(Error::ResourceLimit);
        }
        words = words
            .checked_add(bytes.div_ceil(16))
            .ok_or(Error::ResourceLimit)?;
        let flags = match image.pixels() {
            ImagePixels::Rgba8 { profile, alpha, .. } => {
                (if profile == ImageProfile::DisplayP3 {
                    DISPLAY_P3
                } else {
                    0
                }) | (if alpha == AlphaMode::Premultiplied {
                    PREMULTIPLIED
                } else {
                    0
                })
            }
            ImagePixels::LinearPremultiplied(_) => LINEAR_RGBA,
        };
        next.entries.insert(image.key(), Entry { word, flags });
        next.keys.push(image.key());
    }
    let required = words
        .checked_mul(16)
        .and_then(|bytes| bytes.checked_add(255))
        .map(|bytes| bytes / 256 * 256)
        .ok_or(Error::ResourceLimit)? as u64;
    if required > device.limits().max_storage_buffer_binding_size
        || required > device.limits().max_buffer_size
    {
        return Err(Error::ResourceLimit);
    }
    if buffer.size < required || buffer.size > required.saturating_mul(4) {
        *buffer = Buffer::new(device, "scene words and packed images", required, false);
    }
    for image in scene.images() {
        let mut offset = u64::from(next.entries[&image.key()].word) * 16;
        match image.pixels() {
            ImagePixels::Rgba8 { bytes, .. } => {
                for chunk in bytes.chunks(65536) {
                    queue.write_buffer(&buffer.handle, offset, chunk);
                    offset += chunk.len() as u64;
                }
            }
            ImagePixels::LinearPremultiplied(pixels) => {
                for chunk in pixels.chunks(4096) {
                    let bytes = bytemuck::cast_slice(chunk);
                    queue.write_buffer(&buffer.handle, offset, bytes);
                    offset += bytes.len() as u64;
                }
            }
        }
    }
    next.stats.resources = count;
    next.stats.uploaded_bytes = next.stats.packed_bytes;
    next.stats.prefix_bytes = prefix_words * 16;
    next.stats.gpu_buffer_bytes = buffer.size;
    next.stats.index_capacity = next.entries.capacity();
    *current = Some(Box::new(next));
    Ok(())
}
