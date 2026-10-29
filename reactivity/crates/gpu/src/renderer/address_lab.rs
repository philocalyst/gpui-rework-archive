//! Local experiment only. Private frame versions, not production journal authority.
use super::*;

/// Existing semantic identity plus the node's local command ordinal. The caller
/// must supply these from the same exact scene version, not a reconstructed snapshot.
pub type DrawKey = [u64; 2];
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Mode {
    RawRelocation,
    RelativeDomains,
    StableDraws,
}
#[derive(Clone, Copy, Debug, Default)]
pub struct Work {
    pub key_comparisons: usize,
    pub key_insertions: usize,
    pub key_moved_bytes: usize,
    pub directory_entries: usize,
    pub group_events: usize,
    pub tile_comparisons: usize,
    pub tile_reused: usize,
    pub tile_appended_entries: usize,
    pub arena_compactions: usize,
    pub scanned_bytes: usize,
    pub staged_bytes: usize,
    pub write_calls: usize,
    pub gpu_copy_bytes: u64,
    pub gpu_copy_calls: usize,
    pub cpu_copy_bytes: usize,
    pub fallback: bool,
    pub resource_keys_examined: usize,
    pub format_group_visits: usize,
    pub clip_guard_visits: usize,
    pub resource_index_cloned_capacity: usize,
}
/// A bounded address allocator; it does not mint semantic identity or authorize
/// reuse of an old draw's interpretation. Handles are not recycled in the campaign.
pub struct Handles {
    namespace: u64,
    rows: Vec<(DrawKey, u32)>,
}
impl Handles {
    pub fn new(namespace: u64) -> Self {
        Self {
            namespace,
            rows: Vec::new(),
        }
    }
    pub fn retained_bytes(&self) -> usize {
        size_of::<Self>() + self.rows.capacity() * size_of::<(DrawKey, u32)>()
    }
    fn resolve(&mut self, namespace: u64, keys: &[DrawKey], work: &mut Work) -> Option<Vec<u32>> {
        if namespace != self.namespace {
            return None;
        }
        let mut out = Vec::with_capacity(keys.len());
        let mut seen = [0_u64; 64]; // 512B bounded validation scratch.

        for &key in keys {
            let index = self.rows.binary_search_by(|(old, _)| {
                work.key_comparisons += 1;
                old.cmp(&key)
            });
            let handle = match index {
                Ok(i) => self.rows[i].1,
                Err(i) => {
                    if self.rows.len() == 4096 {
                        return None;
                    }
                    let handle = self.rows.len() as u32;
                    work.key_insertions += 1;
                    work.key_moved_bytes += (self.rows.len() - i) * size_of::<(DrawKey, u32)>();
                    self.rows.insert(i, (key, handle));
                    handle
                }
            };
            let bit = 1_u64 << (handle % 64);
            if seen[handle as usize / 64] & bit != 0 {
                return None;
            }
            seen[handle as usize / 64] |= bit;
            out.push(handle);
        }
        Some(out)
    }
}

/// The raw shader remains unchanged. The experimental module applies checked,
/// narrowly scoped transformations to its generated text, preserving a separately
/// compiled original pipeline as the pixel oracle. Both sources are recorded.
pub fn shader_source() -> String {
    let mut source = SHADER_SOURCE.to_owned();
    fn replace_once(source: &mut String, old: &str, new: &str) {
        assert_eq!(
            source.matches(old).count(),
            1,
            "frozen shader transformation anchor"
        );
        *source = source.replacen(old, new, 1);
    }
    replace_once(
        &mut source,
        "fn load_draw(address: u32) -> Draw {",
        r#"
fn lab_draw_address(address: u32) -> u32 {
    if ((GLOBALS.viewport.w & 32u) != 0u) {
        let directory = bitcast<u32>(GLOBALS.mapping.z);
        return WORDS[directory + address / 4u][address % 4u];
    }
    return address;
}
fn lab_clip_address(index: u32) -> u32 {
    if ((GLOBALS.viewport.w & 16u) != 0u) {
        return bitcast<u32>(GLOBALS.mapping.y) + index * 5u;
    }
    return index;
}
fn load_draw(virtual_address: u32) -> Draw {
    let address = lab_draw_address(virtual_address);"#,
    );
    // There are two common-load sites, but banked formats explicitly fall back.
    assert_eq!(source.matches("let state_base = u32(atlas.w);").count(), 2);
    source = source.replacen(
        "let state_base = u32(atlas.w);",
        r#"var state_base = u32(atlas.w);
    if ((GLOBALS.viewport.w & 16u) != 0u) { state_base = base - state_base; }"#,
        1,
    );
    replace_once(
        &mut source,
        "clip_chain_contains(bitcast<u32>(draw.clip.y), point)",
        "clip_chain_contains(lab_clip_address(bitcast<u32>(draw.clip.y)), point)",
    );
    source
}
impl GpuContext {
    pub async fn new_address_lab(
        device: wgpu::Device,
        queue: wgpu::Queue,
        format: wgpu::TextureFormat,
    ) -> Result<Self, Error> {
        if cfg!(feature = "offline-shader") {
            return Err(Error::InvalidScene);
        }
        Self::new_source(device, queue, format, Cow::Owned(shader_source())).await
    }
}

#[derive(Clone, Copy, Debug, Default)]
pub enum Fault {
    #[default]
    None,
    OldClipDescriptor,
    OldDirectoryDescriptor,
}
struct Base {
    records: Vec<Word>,
    ranges: Vec<[u32; 2]>,
    references: Vec<u32>,
    corrections: Vec<Correction>,
    copied_handles: [wgpu::Buffer; 4],
    mode: Mode,
    clip_base: usize,
    directory_base: usize,
}
impl Base {
    fn bytes(&self, kind: usize) -> &[u8] {
        match kind {
            0 => bytemuck::cast_slice(&self.records),
            1 => bytemuck::cast_slice(&self.ranges),
            2 => bytemuck::cast_slice(&self.references),
            3 => bytemuck::cast_slice(&self.corrections),
            _ => unreachable!(),
        }
    }
    fn heap(&self) -> usize {
        self.records.capacity() * 16
            + self.ranges.capacity() * 8
            + self.references.capacity() * 4
            + self.corrections.capacity() * 32
    }
}
pub(super) struct Frame {
    mode: Mode,
    pub(super) work: Work,
    handles: Vec<u32>,
    directory: Vec<u32>,
    groups: Vec<[usize; 4]>,
    base: Option<Box<Base>>,
    clip_base: usize,
    directory_base: usize,
    fault: Fault,
}
impl Frame {
    pub(super) fn group(&mut self, ordinal: usize, count: usize, start: usize, compact: bool) {
        self.work.group_events += 1;
        self.groups
            .push([ordinal, count, start, usize::from(compact)]);
        if self.mode == Mode::StableDraws {
            for i in 0..count {
                let address = if compact {
                    start + 5 + 2 * i
                } else {
                    start + 6 * i
                };
                self.directory[self.handles[ordinal + i] as usize] =
                    address as u32 | if compact { 0 } else { INLINE_RECORD };
                self.work.directory_entries += 1;
            }
        }
    }
    pub(super) fn reference(&self, ordinal: usize, raw: u32) -> u32 {
        if self.mode == Mode::StableDraws {
            self.handles[ordinal]
        } else {
            raw
        }
    }
    pub(super) fn append_directory(&mut self, records: &mut Vec<Word>, clip_base: usize) {
        self.clip_base = clip_base;
        self.directory_base = records.len();
        if self.mode == Mode::StableDraws {
            for chunk in self.directory.chunks(4) {
                let mut word = [0; 4];
                word[..chunk.len()].copy_from_slice(chunk);
                records.push(word);
            }
        }
    }
    pub(super) fn finish(
        &mut self,
        records: &mut [Word],
        ranges: &mut [[u32; 2]],
        references: &mut Vec<u32>,
    ) {
        if self.mode == Mode::RelativeDomains {
            for &[_, n, start, compact] in &self.groups {
                if compact != 0 {
                    if records[start + 2][0] == 0x7fc00003 {
                        records[start + 2][1] = (records[start + 2][1] - self.clip_base as u32) / 5;
                    }
                    for i in 0..n {
                        let base = start + 5 + 2 * i;
                        records[base + 1][3] = base as u32 - records[base + 1][3];
                    }
                } else {
                    for i in 0..n {
                        let w = start + 6 * i + 3;
                        if records[w][0] == 0x7fc00003 {
                            records[w][1] = (records[w][1] - self.clip_base as u32) / 5;
                        }
                    }
                }
            }
        }
        if self.mode != Mode::StableDraws {
            return;
        }
        let Some(base) = self
            .base
            .as_ref()
            .filter(|b| b.mode == Mode::StableDraws && b.ranges.len() == ranges.len())
        else {
            return;
        };
        // Actual freshly prepared CSR is the oracle. Keep a previous interval
        // only when every ordered stable handle matches; geometry is not reused.
        let mut reuse = Vec::with_capacity(ranges.len());
        let mut append = 0;
        for (now, old) in ranges.iter().zip(&base.ranges) {
            let same = if now[1] == UNIFORM_TILE || old[1] == UNIFORM_TILE {
                self.work.tile_comparisons += 1;
                now == old
            } else {
                let a = &references[now[0] as usize..now[1] as usize];
                let b = &base.references[old[0] as usize..old[1] as usize];
                a.len() == b.len()
                    && a.iter().zip(b).all(|(a, b)| {
                        self.work.tile_comparisons += 1;
                        a == b
                    })
            };
            if !same && now[1] != UNIFORM_TILE {
                append += (now[1] - now[0]) as usize;
            }
            reuse.push(same);
        }
        let bound = references.len().saturating_mul(4).saturating_add(1024);
        if base.references.len().saturating_add(append) > bound {
            self.work.arena_compactions += 1;
            return;
        }
        let mut next = Vec::with_capacity(base.references.len() + append);
        next.extend_from_slice(&base.references);
        self.work.cpu_copy_bytes += base.references.len() * 4;
        for ((now, old), same) in ranges.iter_mut().zip(&base.ranges).zip(reuse) {
            if same {
                *now = *old;
                self.work.tile_reused += 1;
            } else if now[1] != UNIFORM_TILE {
                let start = next.len();
                next.extend_from_slice(&references[now[0] as usize..now[1] as usize]);
                self.work.tile_appended_entries += next.len() - start;
                *now = [start as u32, next.len() as u32];
            }
        }
        *references = next;
    }
    pub(super) fn globals(&mut self, globals: &mut Globals) {
        let bits = match self.mode {
            Mode::RawRelocation => 0,
            Mode::RelativeDomains => 16,
            Mode::StableDraws => 32,
        };
        globals.viewport[3] |= bits;
        let mut clip = self.clip_base;
        let mut directory = self.directory_base;
        if let Some(base) = &self.base {
            match self.fault {
                Fault::None => {}
                Fault::OldClipDescriptor => clip = base.clip_base,
                Fault::OldDirectoryDescriptor => directory = base.directory_base,
            }
        }
        globals.mapping[1] = f32::from_bits(clip as u32);
        globals.mapping[2] = f32::from_bits(directory as u32);
        self.work.staged_bytes += 48;
        self.work.write_calls += 1;
    }
    pub(super) fn upload(
        &mut self,
        buffer: &mut Buffer,
        context: &GpuContext,
        bytes: &[u8],
        kind: usize,
    ) {
        let base = self.base.as_ref().filter(|b| {
            b.copied_handles[kind] == buffer.handle && bytes.len() as u64 <= buffer.size
        });
        let Some(base) = base else {
            buffer.write(&context.device, &context.queue, bytes);
            self.work.staged_bytes += bytes.len();
            self.work.write_calls += usize::from(!bytes.is_empty());
            return;
        };
        let before = base.bytes(kind);
        let mut start = None;
        for offset in (0..bytes.len()).step_by(16) {
            let end = (offset + 16).min(bytes.len());
            self.work.scanned_bytes += end - offset;
            let changed = before.get(offset..end) != Some(&bytes[offset..end]);
            if changed {
                if start.is_none() {
                    start = Some(offset);
                }
            } else if let Some(s) = start.take() {
                context
                    .queue
                    .write_buffer(&buffer.handle, s as u64, &bytes[s..offset]);
                self.work.staged_bytes += offset - s;
                self.work.write_calls += 1;
            }
        }
        if let Some(s) = start {
            context
                .queue
                .write_buffer(&buffer.handle, s as u64, &bytes[s..]);
            self.work.staged_bytes += bytes.len() - s;
            self.work.write_calls += 1;
        }
    }
    fn heap(&self) -> usize {
        self.handles.capacity() * 4
            + self.directory.capacity() * 4
            + self.groups.capacity() * size_of::<[usize; 4]>()
            + self
                .base
                .as_ref()
                .map_or(0, |b| size_of::<Base>() + b.heap())
    }
}

struct Deferred<'a>(&'a wgpu::TextureView);
impl retained::Submission for Deferred<'_> {
    fn view(&self) -> &wgpu::TextureView {
        self.0
    }
    fn submit(self, context: &GpuContext, _: &wgpu::BindGroup) -> wgpu::SubmissionIndex {
        // Flush only this private candidate's staged writes. Actual consumption
        // happens later through Version::submit, in any requested version order.
        context.queue.submit([])
    }
}
/// Private mutable packet ownership. There is no API to prepare again into this
/// version, or to change its resources after creation. `submit` only replays it.
pub struct Version {
    state: RendererState,
    stamp: [u64; 2],
    pub prepared: wgpu::SubmissionIndex,
    prepared_stats: Stats,
    prepared_images: Option<ImageStats>,
}
impl Version {
    #[allow(clippy::too_many_arguments)]
    pub fn prepare(
        context: &GpuContext,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
        stamp: [u64; 2],
        keys: &[DrawKey],
        allocator: &mut Handles,
        mode: Mode,
        predecessor: Option<&Version>,
        fault: Fault,
    ) -> Result<Self, Error> {
        if !context.address_shader || keys.len() != scene.draws().len() || stamp.contains(&0) {
            return Err(Error::InvalidScene);
        }
        if predecessor.is_some_and(|p| p.stamp[0] != stamp[0] || p.stamp[1] >= stamp[1]) {
            return Err(Error::InvalidScene);
        }
        let mut work = Work::default();
        let encoded_clips = scene.groups().any(|g| {
            work.format_group_visits += 1;
            g.clip_chain().is_some()
        });
        // Only encoded parent links constrain this shader. Unused clip metadata
        // and prefixes lowered by clips::append to raster rectangles have none.
        let supported = scene.paint_bank().len() == 0
            && scene.gradients().next().is_none()
            && (!encoded_clips
                || scene.clip_nodes().all(|n| {
                    work.clip_guard_visits += 1;
                    n.raster_rect.is_some() || n.parent.is_none()
                }));
        let mut effective = mode;
        let handles = if supported && mode == Mode::StableDraws {
            match allocator.resolve(stamp[0], keys, &mut work) {
                Some(v) => v,
                None => {
                    work.fallback = true;
                    effective = Mode::RawRelocation;
                    Vec::new()
                }
            }
        } else {
            Vec::new()
        };
        if !supported {
            work.fallback = true;
            effective = Mode::RawRelocation;
        }
        let mut state = RendererState::new(context);
        let mut base = None;
        if let Some(previous) = predecessor.filter(|_| !work.fallback) {
            let old = &previous.state;
            let mut encoder =
                context
                    .device
                    .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                        label: Some("private packet predecessor copy"),
                    });
            fn copied(
                context: &GpuContext,
                encoder: &mut wgpu::CommandEncoder,
                old: &Buffer,
                work: &mut Work,
            ) -> Buffer {
                let next = Buffer::new(&context.device, "private version", old.size, false);
                encoder.copy_buffer_to_buffer(&old.handle, 0, &next.handle, 0, old.size);
                work.gpu_copy_bytes += old.size;
                work.gpu_copy_calls += 1;
                next
            }
            state.draws = copied(context, &mut encoder, &old.draws, &mut work);
            state.tiles = copied(context, &mut encoder, &old.tiles, &mut work);
            state.indices = copied(context, &mut encoder, &old.indices, &mut work);
            state.corrections = copied(context, &mut encoder, &old.corrections, &mut work);
            // Submission order is essential: copying AFTER patch writes would
            // overwrite the candidate with predecessor bytes.
            context.queue.submit([encoder.finish()]);
            work.resource_index_cloned_capacity +=
                old.images.as_ref().map_or(0, |i| i.stats().index_capacity);
            state.images = old.images.clone();
            // Share an atlas only for existing keys; insertion into a shared
            // predecessor atlas would permit a later fork to overwrite readers.
            if scene.masks().all(|m| {
                work.resource_keys_examined += 1;
                old.atlas.entries.contains_key(&m.key)
            }) {
                work.resource_index_cloned_capacity += old.atlas.entries.capacity();
                state.atlas = Atlas {
                    texture: old.atlas.texture.clone(),
                    view: old.atlas.view.clone(),
                    side: old.atlas.side,
                    x: old.atlas.x,
                    y: old.atlas.y,
                    row_height: old.atlas.row_height,
                    entries: old.atlas.entries.clone(),
                };
            }
            let old_frame = old.lab.as_ref().unwrap();
            let b = Base {
                records: old.records.clone(),
                ranges: old.ranges.clone(),
                references: old.references.clone(),
                corrections: old.residuals.clone(),
                copied_handles: [
                    state.draws.handle.clone(),
                    state.tiles.handle.clone(),
                    state.indices.handle.clone(),
                    state.corrections.handle.clone(),
                ],
                mode: old_frame.mode,
                clip_base: old_frame.clip_base,
                directory_base: old_frame.directory_base,
            };
            work.cpu_copy_bytes +=
                b.bytes(0).len() + b.bytes(1).len() + b.bytes(2).len() + b.bytes(3).len();
            base = Some(Box::new(b));
        }
        state.lab = Some(Box::new(Frame {
            mode: effective,
            work,
            handles,
            directory: if effective == Mode::StableDraws {
                vec![0; allocator.rows.len()]
            } else {
                Vec::new()
            },
            groups: Vec::new(),
            base,
            clip_base: 0,
            directory_base: 0,
            fault,
        }));
        let prepared = state.render_observed(context, scene, Deferred(target), |_, _, _, _| {})?;
        let prepared_stats = state.stats();
        let prepared_images = state.image_stats();
        Ok(Self {
            state,
            stamp,
            prepared,
            prepared_stats,
            prepared_images,
        })
    }
    pub fn submit(
        &mut self,
        context: &GpuContext,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        self.state
            .redraw(context, target)?
            .ok_or(Error::InvalidScene)
    }
    pub fn work(&self) -> Work {
        self.state.lab.as_ref().unwrap().work
    }
    pub fn stats(&self) -> Stats {
        self.prepared_stats
    }
    pub fn images(&self) -> Option<ImageStats> {
        self.prepared_images
    }
    pub fn snapshot(&self) -> PacketTrace {
        self.state.trace_packet()
    }
    pub fn adapter_retained_bytes(&self) -> usize {
        size_of::<Frame>() + self.state.lab.as_ref().unwrap().heap()
    }
    pub fn orphan_copy_bytes(&self) -> u64 {
        let Some(base) = self.state.lab.as_ref().unwrap().base.as_ref() else {
            return 0;
        };
        let current = [
            &self.state.draws.handle,
            &self.state.tiles.handle,
            &self.state.indices.handle,
            &self.state.corrections.handle,
        ];
        base.copied_handles
            .iter()
            .zip(current)
            .filter(|(old, current)| *old != *current)
            .map(|(old, _)| old.size())
            .sum()
    }
    pub fn gpu_storage_bytes(&self) -> u64 {
        self.state.stats.gpu_buffer_bytes
            + self.orphan_copy_bytes()
            + u64::from(self.state.atlas.side).pow(2)
    }
    pub fn unique_gpu_storage_bytes(versions: &[Self]) -> u64 {
        let mut total = 0;
        for (i, v) in versions.iter().enumerate() {
            total += v.state.stats.gpu_buffer_bytes + v.orphan_copy_bytes();
            if !versions[..i]
                .iter()
                .any(|p| p.state.atlas.texture == v.state.atlas.texture)
            {
                total += u64::from(v.state.atlas.side).pow(2);
            }
        }
        total
    }
}
