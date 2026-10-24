//! Direct canonical paint slots in the existing word packet. No per-draw map.
use super::*;
use gpui_canvas::{PaintSlot, SlotEdit};

const SHARED: u32 = 1;
const RECTANGLE: u32 = 2;
const _: () = assert!(MAX_DRAWS * 6 + MAX_DRAWS * 2 + MAX_DRAWS / 32 + 1 < INLINE_RECORD as usize);

pub(super) fn prefix_words(rows: usize) -> usize {
    if rows == 0 {
        0
    } else {
        1 + rows.div_ceil(64) + rows
    }
}
pub(super) fn color_word(rows: usize, slot: PaintSlot) -> u32 {
    let index = slot.index() as usize;
    assert!(index < rows);
    (1 + rows.div_ceil(64) + index) as u32
}
pub(super) fn write_prefix(records: &mut Vec<Word>, scene: PreparedScene<'_>, rows: usize) {
    if rows == 0 {
        return;
    }
    let flags = rows.div_ceil(64);
    records.resize(1 + flags, [0; 4]);
    records[0] = [rows as u32, flags as u32, (1 + flags) as u32, 0];
    for (index, paint) in scene.paint_bank().enumerate() {
        let bits =
            (u32::from(paint.shared()) * SHARED) | (u32::from(paint.rectangle()) * RECTANGLE);
        records[1 + index / 64][index / 16 % 4] |= bits << (index % 16 * 2);
        records.push(float_word(paint.value().working()));
    }
}
fn row(records: &[Word], slot: PaintSlot) -> Option<(usize, u32)> {
    let index = slot.index() as usize;
    if index >= records.first()?[0] as usize {
        return None;
    }
    let flags = (records[1 + index / 64][index / 16 % 4] >> (index % 16 * 2)) & 3;
    Some((records[0][2] as usize + index, flags))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SlotError {
    NoPacket,
    IncompatibleContext,
    InvalidTarget,
    MissingSlot { edit: usize },
    NotShared { edit: usize },
    Unordered { edit: usize },
    AlphaChanged { edit: usize },
    ProofColor { edit: usize },
}
impl std::fmt::Display for SlotError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for SlotError {}
impl RendererState {
    /// Validate positional writes against this renderer's last banked packet.
    /// These positions are not scene identities. A native owner additionally
    /// checks its exact preceding complete-C token before using this operation.
    /// A rejected edit leaves replay eligible; no record/queue mutation occurs.
    pub fn prepare_slots<'owner, 'edits, 'target>(
        &'owner mut self,
        context: &'owner GpuContext,
        edits: &'edits [SlotEdit],
        target: &'target wgpu::TextureView,
    ) -> Result<GpuSlotCommit<'owner, 'edits, 'target>, SlotError> {
        if self.layout != context.layout {
            return Err(SlotError::IncompatibleContext);
        }
        let packet = self
            .packet
            .as_ref()
            .filter(|packet| packet.banked())
            .ok_or(SlotError::NoPacket)?;
        if packet.dimensions() != [target.texture().width(), target.texture().height()]
            || target.texture().format() != context.format
        {
            return Err(SlotError::InvalidTarget);
        }
        let mut previous = None;
        let mut changed = 0;
        for (edit, write) in edits.iter().enumerate() {
            if previous.is_some_and(|slot| slot >= write.slot()) {
                return Err(SlotError::Unordered { edit });
            }
            previous = Some(write.slot());
            let (word, flags) =
                row(&self.records, write.slot()).ok_or(SlotError::MissingSlot { edit })?;
            if flags & SHARED == 0 {
                return Err(SlotError::NotShared { edit });
            }
            let next = write.value().working();
            if self.records[word][3] != next[3].to_bits() {
                return Err(SlotError::AlphaChanged { edit });
            }
            if self.records[word] == float_word(next) {
                continue;
            }
            // Tile ranges may omit predecessors or resolve directly to a uniform
            // draw. Preserve that proof class; exceptional RGB rebuilds instead.
            if flags & RECTANGLE != 0
                && next[3] == 1.0
                && next.iter().any(|v| v.is_sign_negative() && !v.is_normal())
            {
                return Err(SlotError::ProofColor { edit });
            }
            changed += 1;
        }
        Ok(GpuSlotCommit {
            owner: self,
            context,
            edits,
            target,
            changed,
        })
    }
}
#[must_use = "commit updates and submits; dropping leaves the packet unchanged"]
pub struct GpuSlotCommit<'owner, 'edits, 'target> {
    owner: &'owner mut RendererState,
    context: &'owner GpuContext,
    edits: &'edits [SlotEdit],
    target: &'target wgpu::TextureView,
    changed: usize,
}
impl GpuSlotCommit<'_, '_, '_> {
    pub fn changed_slots(&self) -> usize {
        self.changed
    }
    pub fn upload_bytes(&self) -> usize {
        self.changed * 16
    }
    pub fn commit(self) -> wgpu::SubmissionIndex {
        // Revoke before the first queue write. A panic can never replay partially
        // mutated words. Queue ordering keeps earlier submitted frames immutable.
        let packet = self.owner.packet.take().expect("exclusive admitted packet");
        for edit in self.edits {
            let (word, _) = row(&self.owner.records, edit.slot()).expect("validated row");
            let next = float_word(edit.value().working());
            if self.owner.records[word] == next {
                continue;
            }
            self.owner.records[word] = next;
            self.context.queue.write_buffer(
                &self.owner.draws.handle,
                (word * 16) as u64,
                bytemuck::bytes_of(&next),
            );
        }
        let submitted =
            self.context
                .submit(self.target, &packet.bindings, packet.clip_accelerated());
        self.owner.packet = Some(packet);
        let stats = &mut self.owner.stats;
        stats.submissions = stats.submissions.saturating_add(1);
        stats.packet_reused = true;
        stats.validated_draws = 0;
        stats.binning_tile_visits = 0;
        stats.bind_group_creations = 0;
        stats.instance_upload_bytes = self.changed * 16;
        stats.mask_upload_bytes = 0;
        if let Some(images) = &mut self.owner.images {
            images.redrawn();
        }
        submitted
    }
}
