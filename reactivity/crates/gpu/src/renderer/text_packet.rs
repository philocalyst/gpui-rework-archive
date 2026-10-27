//! Gather changed masked runs, validate every member, then repair one packet.
//! The first formulation still scans and repacks the entire surviving CSR.
use super::*;
use gpui_canvas::TextRunSlot;
use std::num::NonZeroU32;

#[derive(Clone, Copy)]
pub(super) struct Run {
    word: NonZeroU32,
    ordinal: u32,
    count: u32,
    references: u32,
}
impl Run {
    pub(super) fn new(ordinal: usize, group: PreparedGroup<'_>, word: usize) -> Self {
        Self {
            word: NonZeroU32::new((word + 5) as u32).unwrap(),
            ordinal: ordinal as u32,
            count: group.bounds().len() as u32,
            references: group.bounds().map(tile_count).sum::<usize>() as u32,
        }
    }
    fn contains(self, address: u32) -> bool {
        address & INLINE_RECORD == 0
            && address >= self.word.get()
            && address < self.word.get() + self.count * 2
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum TextPacketError {
    NoPacket,
    InvalidTarget,
    InvalidBatch,
    MissingRun,
    ChangedShape,
    ChangedCommon,
    MissingResource,
    Capacity,
}
impl std::fmt::Display for TextPacketError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for TextPacketError {}

struct Patch {
    slot: TextRunSlot,
    run: Run,
    words: Vec<Word>,
}
impl Patch {
    fn changes(&self, address: u32, old: &[Word], common_changed: bool) -> bool {
        if !self.run.contains(address) {
            return false;
        }
        let offset = 5 + (address - self.run.word.get()) as usize;
        common_changed
            || self.words[offset..offset + 2] != old[address as usize..address as usize + 2]
    }
}
// Rows are disjoint. Cap command count; overflow uses the original damage.
fn append_region(regions: &mut Option<Vec<[u32; 4]>>, rect: [u32; 4], damage: [u32; 4]) {
    let [l, t, r, b] = [
        rect[0].max(damage[0]),
        rect[1].max(damage[1]),
        rect[2].min(damage[2]),
        rect[3].min(damage[3]),
    ];
    if l >= r || t >= b {
        return;
    }
    let Some(spans) = regions else { return };
    if let Some(last) = spans.last_mut()
        && last[1] == t
        && last[3] == b
        && last[2] == l
    {
        last[2] = r;
    } else if spans.len() == 256 {
        *regions = None;
    } else {
        spans.push([l, t, r, b]);
    }
}
// Keep small edits on packet-only preparation. All borrows are read-only and
// end before commit; equal compact words alone do not imply equal membership.
#[inline(never)]
fn repair_regions(
    state: &RendererState,
    patches: &[Patch],
    next_ranges: &[[u32; 2]],
    next_references: &[u32],
    damage: [u32; 4],
) -> Option<Vec<[u32; 4]>> {
    let [width, height] = state.packet.as_ref().unwrap().dimensions();
    let columns = width.div_ceil(16) as usize;
    let common_changed: [bool; 4] = std::array::from_fn(|i| {
        patches.get(i).is_some_and(|p| {
            let word = p.run.word.get() as usize;
            p.words[..5] != state.records[word - 5..word]
        })
    });
    let mut regions = Some(Vec::new());
    for (tile, (old, next)) in state.ranges.iter().zip(next_ranges).enumerate() {
        if old == next && old[1] == UNIFORM_TILE {
            continue;
        }
        let _old = if old[1] == UNIFORM_TILE {
            &old[..1]
        } else {
            &state.references[old[0] as usize..old[1] as usize]
        };
        let next = if next[1] == UNIFORM_TILE {
            &next[..1]
        } else {
            &next_references[next[0] as usize..next[1] as usize]
        };
        let dirty = next.iter().any(|&address| {
            patches
                .iter()
                .zip(&common_changed)
                .any(|(p, &common)| p.changes(address, &state.records, common))
        });
        if dirty {
            append_region(
                &mut regions,
                tile_bounds(tile, columns, width, height),
                damage,
            );
            if regions.is_none() {
                break;
            }
        }
    }
    regions
}

fn correction_matches(state: &RendererState, group: PreparedGroup<'_>, index: u32) -> bool {
    let Some(old) = state.residuals.get(index as usize) else {
        return false;
    };
    let low = std::array::from_fn::<_, 8, _>(|i| match i {
        0..6 => (group.inverse[i] - f64::from(group.inverse[i] as f32)) as f32,
        6 => clip_residual(group.clip.x, group.clip.width),
        _ => clip_residual(group.clip.y, group.clip.height),
    });
    // Original correction() canonicalizes all-zero residuals to index zero.
    if low.iter().all(|v| *v == 0.) {
        return index == 0;
    }
    let next = Correction {
        x: [low[0], low[2], low[4], low[6]],
        y: [low[1], low[3], low[5], low[7]],
    };
    bytemuck::bytes_of(old) == bytemuck::bytes_of(&next)
}

pub(super) fn patch(
    state: &mut RendererState,
    context: &GpuContext,
    runs: &mut [Option<Run>],
    edits: &[(TextRunSlot, PreparedGroup<'_>)],
    output: Output<'_>,
) -> Result<(wgpu::SubmissionIndex, u64), TextPacketError> {
    let packet = state.packet.as_ref().ok_or(TextPacketError::NoPacket)?;
    state
        .check_context(context)
        .map_err(|_| TextPacketError::InvalidTarget)?;
    let [width, height] = packet.dimensions();
    if output.view.texture().format() != context.format
        || [
            output.view.texture().width(),
            output.view.texture().height(),
        ] != [width, height]
    {
        return Err(TextPacketError::InvalidTarget);
    }
    if !(1..=4).contains(&edits.len()) || edits.windows(2).any(|p| p[0].0.index() >= p[1].0.index())
    {
        return Err(TextPacketError::InvalidBatch);
    }
    let columns = width.div_ceil(16) as usize;
    let mut patches = Vec::with_capacity(edits.len());
    let mut additions = Vec::new();
    let mut original = state.stats.original_tile_references;
    let mut visits = 0;
    let mut validated = 0;
    for &(slot, group) in edits {
        let mut run = runs
            .get(slot.index())
            .copied()
            .flatten()
            .ok_or(TextPacketError::MissingRun)?;
        if group.text_run_slot() != Some(slot) || group.bounds().len() != run.count as usize {
            return Err(TextPacketError::ChangedShape);
        }
        if group.clip_chain().is_some() || group.paint_slot().is_some() {
            return Err(TextPacketError::ChangedCommon);
        }
        let word = run.word.get() as usize;
        let common = word - 5;
        let correction = state.records[common + 4][0];
        if !correction_matches(state, group, correction) {
            return Err(TextPacketError::ChangedCommon);
        }
        let mut error = [0.0_f32; 2];
        let mut words = Vec::with_capacity(5 + run.count as usize * 2);
        words.resize(5, [0; 4]);
        let mut references = 0usize;
        for (index, p) in group.placements().enumerate() {
            let draw = prepared(group, p);
            let e = validate_draw(draw, run.ordinal as usize + index, width, height)
                .map_err(|_| TextPacketError::ChangedShape)?;
            error[0] = error[0].max(e[0]);
            error[1] = error[1].max(e[1]);
            let mask = p.source.mask().ok_or(TextPacketError::ChangedShape)?;
            let tile = state
                .atlas
                .entries
                .get(&mask.key)
                .ok_or(TextPacketError::MissingResource)?;
            if tile.width as usize != mask.width || tile.height as usize != mask.height {
                return Err(TextPacketError::MissingResource);
            }
            let r = p.local_rect;
            words.extend_from_slice(&[
                float_word([r.x, r.y, r.width, r.height]),
                [
                    tile.x,
                    tile.y,
                    tile.width | (tile.height << 16),
                    common as u32,
                ],
            ]);
            references = references
                .checked_add(tile_count(p.bounds))
                .ok_or(TextPacketError::Capacity)?;
            if references > MAX_REFERENCES {
                return Err(TextPacketError::Capacity);
            }
            let address = (word + index * 2) as u32;
            visit(p.bounds, columns, |tile| {
                visits += 1;
                if run.ordinal + index as u32 + 1 >= state.cursors[tile] {
                    additions.push((tile, address));
                }
            });
            validated += 1;
        }
        let common_words = common_words(group, error, correction);
        let mut signature = common_words;
        // These two lanes are derived numerical bounds, not transform/clip/
        // color authority. Recompute them for the complete changed run exactly
        // as full preparation does; every other common word must still match.
        signature[0][3] = state.records[common][3];
        signature[1][3] = state.records[common + 1][3];
        if signature.as_slice() != &state.records[common..word] {
            return Err(TextPacketError::ChangedCommon);
        }
        words[..5].copy_from_slice(&common_words);
        original = original
            .checked_sub(run.references as usize)
            .and_then(|n| n.checked_add(references))
            .ok_or(TextPacketError::Capacity)?;
        run.references = references as u32;
        patches.push(Patch { slot, run, words });
    }
    if original > MAX_REFERENCES {
        return Err(TextPacketError::Capacity);
    }
    additions.sort_unstable();
    let mut next_ranges = Vec::with_capacity(state.ranges.len());
    let mut next_references = Vec::with_capacity(state.references.len());
    let mut cursor = 0;
    let damage_bounds = output.damage.and_then(|d| d.bounds());
    for (tile, &[start, end]) in state.ranges.iter().enumerate() {
        let begin = cursor;
        while cursor < additions.len() && additions[cursor].0 == tile {
            cursor += 1;
        }
        if end == UNIFORM_TILE && begin == cursor {
            next_ranges.push([start, end]);
            continue;
        }
        let offset = next_references.len();
        if end == UNIFORM_TILE {
            next_references.push(start);
        } else {
            next_references.extend(
                state.references[start as usize..end as usize]
                    .iter()
                    .copied()
                    .filter(|&address| !patches.iter().any(|p| p.run.contains(address))),
            );
        }
        next_references.extend(additions[begin..cursor].iter().map(|&(_, address)| address));
        // Word positions preserve painter order across compact and inline draws.
        if begin != cursor {
            next_references[offset..].sort_unstable_by_key(|a| a & !INLINE_RECORD);
        }
        if next_references.len() > MAX_REFERENCES {
            return Err(TextPacketError::Capacity);
        }
        next_ranges.push([offset as u32, next_references.len() as u32]);
    }
    debug_assert_eq!(cursor, additions.len());
    if next_references.len().max(1) as u64 * 4 > state.indices.size {
        return Err(TextPacketError::Capacity);
    }
    let indices_changed = next_references != state.references;
    let ranges_changed = next_ranges != state.ranges;
    let rebind = next_references.len() != state.references.len();
    let uploaded = patches.iter().map(|p| p.words.len() * 16).sum::<usize>()
        + if indices_changed {
            next_references.len() * 4
        } else {
            0
        }
        + if ranges_changed {
            next_ranges.len() * 8
        } else {
            0
        };
    let area = |[l, t, r, b]: [u32; 4]| u64::from(r - l) * u64::from(b - t);
    // Sixteen tiles of potential pixel work before paying another CSR pass.
    let regions = damage_bounds
        .filter(|&bounds| area(bounds) >= 4096)
        .and_then(|bounds| repair_regions(state, &patches, &next_ranges, &next_references, bounds));
    let composited_pixels = regions.as_ref().map_or_else(
        || {
            output
                .damage
                .map_or(u64::from(width) * u64::from(height), |_| {
                    damage_bounds.map_or(0, area)
                })
        },
        |regions| regions.iter().copied().map(area).sum(),
    );
    // No semantic validation remains. Revoke replay before the first queue write.
    let mut packet = state.packet.take().unwrap();
    for p in patches {
        let word = p.run.word.get() as usize - 5;
        state.records[word..word + p.words.len()].copy_from_slice(&p.words);
        context.queue.write_buffer(
            &state.draws.handle,
            (word * 16) as u64,
            bytemuck::cast_slice(&p.words),
        );
        runs[p.slot.index()] = Some(p.run);
    }
    state.references = next_references;
    state.ranges = next_ranges;
    if indices_changed && !state.references.is_empty() {
        context.queue.write_buffer(
            &state.indices.handle,
            0,
            bytemuck::cast_slice(&state.references),
        );
    }
    if ranges_changed {
        context
            .queue
            .write_buffer(&state.tiles.handle, 0, bytemuck::cast_slice(&state.ranges));
    }
    if rebind {
        packet.bindings = state.bindings(context);
    }
    let submitted = context.submit_regions(output, &packet.bindings, regions.as_deref());
    state.packet = Some(packet);
    let mut uniform = 0;
    let mut samples = 0;
    let mut sample_draws = 0;
    for (tile, &[start, end]) in state.ranges.iter().enumerate() {
        if end == UNIFORM_TILE {
            uniform += 1;
        } else if start != end {
            let [l, t, r, b] = tile_bounds(tile, columns, width, height);
            let n = u64::from((r - l) * (b - t)) * 16;
            samples += n;
            sample_draws += n * u64::from(end - start);
        }
    }
    let stats = &mut state.stats;
    stats.submissions = stats.submissions.saturating_add(1);
    stats.packet_reused = true;
    stats.validated_draws = validated;
    stats.binning_tile_visits = visits;
    stats.bind_group_creations = usize::from(rebind);
    stats.tile_references = state.references.len();
    stats.original_tile_references = original;
    stats.skipped_tile_references = original - state.references.len();
    stats.uniform_tiles = uniform;
    stats.sample_evaluations = samples;
    stats.sample_draw_evaluations = sample_draws;
    stats.instance_upload_bytes = uploaded;
    stats.mask_upload_bytes = 0;
    stats.cpu_index_capacity_bytes = state.records.capacity() * 16
        + state.ranges.capacity() * 8
        + state.references.capacity() * 4
        + state.cursors.capacity() * 4
        + state.residuals.capacity() * 32;
    if let Some(images) = &mut state.images {
        images.redrawn();
    }
    Ok((submitted, composited_pixels))
}
