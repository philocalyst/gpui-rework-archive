//! Opt-in packet ownership for color-only writes. Plain Renderer has no per-draw
//! map or mapping allocation. This owner never lends it mutably.
use super::*;
use gpui_canvas::{PaintEdit, PaintIndex};
use std::{num::NonZeroU32, ops::Deref};

/// Positional entry in the current PaintRenderer map, not a lifecycle or
/// semantic capability. A full render can reuse its position. Callers pair
/// bindings and Canvas indices with their own exact admitted-scene token.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct PaintBinding(u32);

#[derive(Clone, Copy, Debug)]
pub struct GpuPaintEdit {
    binding: PaintBinding,
    paint: PaintEdit,
}
impl GpuPaintEdit {
    pub fn new(binding: PaintBinding, paint: PaintEdit) -> Self {
        Self { binding, paint }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PaintError {
    NoPacket,
    InvalidTarget,
    InvalidBinding {
        edit: usize,
    },
    Unordered {
        edit: usize,
    },
    UnsupportedGroup {
        edit: usize,
    },
    AlphaChanged {
        edit: usize,
    },
    /// A formerly eligible opaque rectangle may have a uniform tile or
    /// occlusion certificate. Signed negative zero/subnormal RGB cannot use it.
    ProofColor {
        edit: usize,
    },
}
impl std::fmt::Display for PaintError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{self:?}")
    }
}
impl std::error::Error for PaintError {}

struct Site {
    index: PaintIndex,
    // Color offsets are always >=3; None is an unsupported diagnostic group.
    word: Option<NonZeroU32>,
    rectangle: bool,
}

/// Opt-in renderer owner with one active-only positional map. Shared access
/// permits ordinary diagnostics/device access; there is deliberately no
/// DerefMut or mutable inner escape. into_inner consumes and discards the map.
pub struct PaintRenderer {
    inner: Renderer,
    sites: Vec<Site>,
}
impl Deref for PaintRenderer {
    type Target = Renderer;
    fn deref(&self) -> &Renderer {
        &self.inner
    }
}
impl PaintRenderer {
    pub fn new(inner: Renderer) -> Self {
        Self {
            inner,
            sites: Vec::new(),
        }
    }
    pub fn into_inner(self) -> Renderer {
        self.inner
    }

    /// Prepare a full scene and capture only these strictly increasing group
    /// positions. All prior mapping/replay authority is revoked before mutation.
    pub fn render(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
        requested: &[PaintIndex],
    ) -> Result<wgpu::SubmissionIndex, Error> {
        if requested.windows(2).any(|pair| pair[0] >= pair[1]) {
            self.sites.clear();
            self.inner.state.packet = None;
            return Err(Error::InvalidScene);
        }
        self.render_indices(scene, target, requested.iter().copied())
    }

    /// Capture an unordered positional set in the existing map, without a
    /// second index array. Sorting and duplicate checks occur at full prepare.
    pub fn render_indices(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
        requested: impl IntoIterator<Item = PaintIndex>,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        self.inner.state.packet = None;
        self.sites.clear();
        let requested = requested.into_iter();
        let demand = requested.size_hint().0;
        if demand != 0 && self.sites.capacity() > demand.saturating_mul(4) {
            self.sites = Vec::new();
        }
        self.sites
            .try_reserve_exact(demand)
            .map_err(|_| Error::ResourceLimit)?;
        for index in requested {
            self.sites
                .try_reserve(1)
                .map_err(|_| Error::ResourceLimit)?;
            self.sites.push(Site {
                index,
                word: None,
                rectangle: false,
            });
        }
        if self.sites.is_empty() {
            self.sites = Vec::new();
        } else if self.sites.capacity() > self.sites.len().saturating_mul(4) {
            self.sites.shrink_to_fit();
        }
        self.render_mapped(scene, target)
    }

    fn render_mapped(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        self.sites.sort_unstable_by_key(|site| site.index);
        let mut previous = None;
        for site in &self.sites {
            if previous.is_some_and(|index| index == site.index)
                || scene.paint_index(site.index.order()) != Some(site.index)
            {
                self.sites.clear();
                return Err(Error::InvalidScene);
            }
            previous = Some(site.index);
        }
        let sites = &mut self.sites;
        let mut next = 0;
        let result = self.inner.state.render_observed(
            &self.inner.context,
            scene,
            target.into(),
            |ordinal, group, word, compact| {
                if let Some(site) = sites.get_mut(next)
                    && site.index.order() as usize == ordinal
                {
                    site.word = (group.paint_slot().is_none()
                        && (compact || group.bounds().len() == 1))
                        .then(|| NonZeroU32::new((word + if compact { 3 } else { 4 }) as u32))
                        .flatten();
                    site.rectangle = group
                        .sources()
                        .next()
                        .is_some_and(|source| source.is_solid());
                    next += 1;
                }
            },
        );
        if result.is_err() {
            self.sites.clear();
        }
        debug_assert!(result.is_err() || next == self.sites.len());
        result
    }
    /// Resolve once when installing a token-qualified source sink. Patch
    /// admission itself uses direct map indexing and does not search this Vec.
    pub fn binding(&self, index: PaintIndex) -> Option<PaintBinding> {
        self.inner.state.packet.as_ref()?;
        self.sites
            .binary_search_by_key(&index, |s| s.index)
            .ok()
            .map(|i| PaintBinding(i as u32))
    }
    pub fn binding_bytes(&self) -> usize {
        self.sites.capacity() * size_of::<Site>()
    }
    pub fn redraw(
        &mut self,
        target: &wgpu::TextureView,
    ) -> Result<Option<wgpu::SubmissionIndex>, Error> {
        self.inner.redraw(target)
    }
    pub fn set_grouped_records(&mut self, enabled: bool) {
        if self.inner.state.grouped_records != enabled {
            self.sites.clear();
        }
        self.inner.set_grouped_records(enabled);
    }
    pub fn set_tile_proofs(&mut self, enabled: bool) {
        if self.inner.state.tile_proofs != enabled {
            self.sites.clear();
        }
        self.inner.set_tile_proofs(enabled);
    }

    /// Validate every write and target before any record or queue mutation.
    /// The guard's exclusive owner borrow freezes packet/map/configuration.
    pub fn prepare_paint<'owner, 'edits, 'target>(
        &'owner mut self,
        edits: &'edits [GpuPaintEdit],
        target: &'target wgpu::TextureView,
    ) -> Result<GpuPaintCommit<'owner, 'edits, 'target>, PaintError> {
        self.prepare_edits(EditsRef::Bound(edits), target)
    }

    /// Borrow owner-converted colors directly. Positional map lookup costs
    /// O(log bound groups) per edit, without another retained staging array.
    pub fn prepare_paint_indexed<'owner, 'edits, 'target>(
        &'owner mut self,
        edits: &'edits [PaintEdit],
        target: &'target wgpu::TextureView,
    ) -> Result<GpuPaintCommit<'owner, 'edits, 'target>, PaintError> {
        self.prepare_edits(EditsRef::Indexed(edits), target)
    }
    fn prepare_edits<'owner, 'edits, 'target>(
        &'owner mut self,
        edits: EditsRef<'edits>,
        target: &'target wgpu::TextureView,
    ) -> Result<GpuPaintCommit<'owner, 'edits, 'target>, PaintError> {
        let packet = self
            .inner
            .state
            .packet
            .as_ref()
            .ok_or(PaintError::NoPacket)?;
        if [target.texture().width(), target.texture().height()] != packet.dimensions()
            || target.texture().format() != self.inner.context.format
        {
            return Err(PaintError::InvalidTarget);
        }
        let mut previous = None;
        let mut changed = 0;
        for i in 0..edits.len() {
            let (binding, paint) = edits
                .get(i, &self.sites)
                .ok_or(PaintError::InvalidBinding { edit: i })?;
            if previous.is_some_and(|b| b >= binding) {
                return Err(PaintError::Unordered { edit: i });
            }
            previous = Some(binding);
            let site = self
                .sites
                .get(binding)
                .filter(|s| s.index == paint.index())
                .ok_or(PaintError::InvalidBinding { edit: i })?;
            let word = site
                .word
                .ok_or(PaintError::UnsupportedGroup { edit: i })?
                .get() as usize;
            let old = self.inner.state.records[word];
            let color = paint.color();
            let next = color.map(f32::to_bits);
            if color[3] == 0.0 || old[3] != next[3] {
                return Err(PaintError::AlphaChanged { edit: i });
            }
            if old == next {
                continue;
            }
            if site.rectangle
                && color[3] == 1.0
                && color.iter().any(|v| v.is_sign_negative() && !v.is_normal())
            {
                return Err(PaintError::ProofColor { edit: i });
            }
            changed += 1;
        }
        Ok(GpuPaintCommit {
            owner: self,
            edits,
            target,
            changed,
        })
    }
}

#[derive(Clone, Copy)]
enum EditsRef<'a> {
    Bound(&'a [GpuPaintEdit]),
    Indexed(&'a [PaintEdit]),
}
impl EditsRef<'_> {
    fn len(self) -> usize {
        match self {
            Self::Bound(e) => e.len(),
            Self::Indexed(e) => e.len(),
        }
    }
    fn get(self, index: usize, sites: &[Site]) -> Option<(usize, PaintEdit)> {
        match self {
            Self::Bound(edits) => edits.get(index).map(|e| (e.binding.0 as usize, e.paint)),
            Self::Indexed(edits) => {
                let paint = *edits.get(index)?;
                let binding = sites
                    .binary_search_by_key(&paint.index(), |site| site.index)
                    .ok()?;
                Some((binding, paint))
            }
        }
    }
}

/// A fully prevalidated packet edit. Drop changes nothing. Commit revokes
/// replay before writing, updates only color words, then clears/draws/submits
/// the entire target. It does not acknowledge native presentation.
///
/// ```compile_fail,E0499
/// use gpui_gpu::{PaintRenderer, GpuPaintEdit, wgpu};
/// fn cannot_retarget(owner: &mut PaintRenderer, edits: &[GpuPaintEdit], target: &wgpu::TextureView) {
///     let plan = owner.prepare_paint(edits, target).unwrap();
///     owner.set_tile_proofs(false);
///     plan.commit();
/// }
/// ```
#[must_use = "call commit to update and submit the packet; dropping changes nothing"]
pub struct GpuPaintCommit<'owner, 'edits, 'target> {
    owner: &'owner mut PaintRenderer,
    edits: EditsRef<'edits>,
    target: &'target wgpu::TextureView,
    changed: usize,
}
impl GpuPaintCommit<'_, '_, '_> {
    pub fn changed_groups(&self) -> usize {
        self.changed
    }
    pub fn upload_bytes(&self) -> usize {
        self.changed * 16
    }
    pub fn commit(self) -> wgpu::SubmissionIndex {
        let context = &self.owner.inner.context;
        let inner = &mut self.owner.inner.state;
        // If queue mutation or submit panics, no old packet can be replayed.
        let packet = inner
            .packet
            .take()
            .expect("guard holds the admitted packet");
        for i in 0..self.edits.len() {
            let (binding, paint) = self
                .edits
                .get(i, &self.owner.sites)
                .expect("validated frozen map");
            let site = &self.owner.sites[binding];
            let word = site.word.expect("validated color word").get() as usize;
            let next = paint.color().map(f32::to_bits);
            if inner.records[word] == next {
                continue;
            }
            inner.records[word] = next;
            context.queue.write_buffer(
                &inner.draws.handle,
                (word * 16) as u64,
                bytemuck::bytes_of(&next),
            );
        }
        let submitted = context.submit(self.target.into(), &packet.bindings);
        inner.packet = Some(packet);
        inner.stats.submissions = inner.stats.submissions.saturating_add(1);
        inner.stats.packet_reused = true;
        inner.stats.validated_draws = 0;
        inner.stats.binning_tile_visits = 0;
        inner.stats.pixel_uniform_checks = 0;
        inner.stats.bind_group_creations = 0;
        inner.stats.instance_upload_bytes = self.changed * 16;
        inner.stats.mask_upload_bytes = 0;
        if let Some(images) = &mut inner.images {
            images.redrawn();
        }
        submitted
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn optional_map_and_guards_have_explicit_storage() {
        eprintln!(
            "paint_gpu_storage,Renderer={},PaintRenderer={},MapHeader={},Site={},Binding={},Edit={},Guard={}",
            size_of::<Renderer>(),
            size_of::<PaintRenderer>(),
            size_of::<Vec<Site>>(),
            size_of::<Site>(),
            size_of::<PaintBinding>(),
            size_of::<GpuPaintEdit>(),
            size_of::<GpuPaintCommit<'_, '_, '_>>()
        );
        assert_eq!(size_of::<PaintBinding>(), 4);
        assert_eq!(size_of::<Site>(), 12);
        assert_eq!(size_of::<GpuPaintEdit>(), 24);
        if size_of::<usize>() == 8 {
            assert_eq!(size_of::<PaintRenderer>(), size_of::<Renderer>() + 24);
        }
    }
}
