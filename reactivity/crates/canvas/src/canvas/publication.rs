//! One-shot canonical publication binding. No Target/ACK/image completion grant.
use super::*;
use gpui_reactivity_core::change::{BatchStamp,ChangeBatch,Facet,PreparedPublication,PreparedChanges,PublicationReceipt,SceneGroups,SceneRevision,SiteId};

// Intentionally INLINE: no fallible allocation after canonical mutation. All
// owned batch/range vectors were admitted by the producer before this commit.
// Exact default Canvas ABI cost must be measured/priced separately from old464.
pub(super) struct Binding {
    receipt:PublicationReceipt,
    batch:ChangeBatch,
    groups:SceneGroups,
    users:MaterialUsers,
    mutation:Mutation,
    scratch:Vec<PaintSlot>,
}
struct MaterialUsers { bank:SceneRevision, offsets:Vec<u32>, owners:Vec<std::num::NonZeroU64> }
struct SlotMutation {base:SceneRevision,slots:Vec<PaintSlot>}
enum Mutation {Snapshot,Slots(SlotMutation)}
/// Opaque actual checked transaction witness; no caller-list constructor.
#[derive(Clone,Copy)]
pub struct CheckedSlotMutation<'a> {base:SceneRevision,bank:SceneRevision,slots:&'a[PaintSlot]}
impl<'a> CheckedSlotMutation<'a> {
    pub fn base(self)->SceneRevision {self.base}
    pub fn bank_origin(self)->SceneRevision {self.bank}
    pub fn changed_slots(self)->&'a[PaintSlot] {self.slots}
}
impl MaterialUsers {
    fn build(scene:PreparedScene<'_>,groups:&SceneGroups,bank:SceneRevision)->Result<Self,PublicationError> {
        let rows=scene.paint_bank().len();
        if rows==0 {return Ok(Self {bank,offsets:Vec::new(),owners:Vec::new()});}
        let spans=groups.groups();let mut edges=Vec::new();let mut first=0;let mut owner=0;
        for group in scene.groups() {
            let end=first+group.placements().len();
            if let Some(slot)=group.paint_slot() {
                if slot.index() as usize>=rows {return Err(PublicationError::Metadata);}
                while owner<spans.len() && spans[owner].draws.end as usize<=first {owner+=1;}
                let mut index=owner;
                while index<spans.len() && (spans[index].draws.start as usize)<end {
                    if spans[index].draws.start<spans[index].draws.end {
                        edges.try_reserve(1).map_err(|_|PublicationError::Allocation)?;
                        edges.push((slot.index(),spans[index].local));
                    }
                    index+=1;
                }
            }
            first=end;
        }
        edges.sort_unstable();edges.dedup();
        let mut offsets=Vec::new();offsets.try_reserve_exact(rows+1).map_err(|_|PublicationError::Allocation)?;
        let mut owners=Vec::new();owners.try_reserve_exact(edges.len()).map_err(|_|PublicationError::Allocation)?;
        let mut cursor=0;
        for row in 0..rows {
            offsets.push(owners.len() as u32);
            while cursor<edges.len() && edges[cursor].0 as usize==row {owners.push(edges[cursor].1);cursor+=1;}
        }
        offsets.push(owners.len() as u32);Ok(Self {bank,offsets,owners})
    }
    fn owners(&self,slot:PaintSlot)->Option<&[std::num::NonZeroU64]> {
        let index=slot.index() as usize;let first=*self.offsets.get(index)? as usize;
        let end=*self.offsets.get(index+1)? as usize;Some(&self.owners[first..end])
    }
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum PublicationError { NoPublication, Stamp, Metadata, NonPaintMutation, UncoveredPaint, IncompleteChanges, Allocation }
impl std::fmt::Display for PublicationError {
    fn fmt(&self,f:&mut std::fmt::Formatter<'_>)->std::fmt::Result {write!(f,"{self:?}")}
}
impl std::error::Error for PublicationError {}

/// Borrowed immutable view of an ALREADY bound canonical scene+metadata owner.
/// Clone copies only this view. Receipt and mutable Canvas are never exposed.
/// This is source publication, NOT backend validation/completed pixels or ACK.
#[derive(Clone,Copy)]
pub struct CanvasAcceptedSceneView<'a> {
    scene:PreparedScene<'a>,
    binding:&'a Binding,
}
impl<'a> CanvasAcceptedSceneView<'a> {
    pub fn scene(self)->PreparedScene<'a> {self.scene}
    pub fn batch(self)->&'a ChangeBatch {&self.binding.batch}
    pub fn groups(self)->&'a SceneGroups {&self.binding.groups}
    pub fn stamp(self)->BatchStamp {self.binding.receipt.stamp()}
    /// A full source snapshot is NOT an incremental-clean claim. A renderer
    /// must admit/diff its complete immutable catalog before deriving jobs.
    pub fn is_full_snapshot(self)->bool {matches!(&self.binding.mutation,Mutation::Snapshot)}
    pub fn checked_slot_mutation(self)->Option<CheckedSlotMutation<'a>> {
        match &self.binding.mutation {
            Mutation::Snapshot=>None,
            Mutation::Slots(mutation)=>Some(CheckedSlotMutation {base:mutation.base,bank:self.binding.users.bank,slots:&mutation.slots}),
        }
    }
    /// Complete actual users, derived at full admission, not caller annotations.
    pub fn material_users(self,slot:PaintSlot)->Option<impl Iterator<Item=SiteId>+'a> {
        let owner=self.binding.users.bank.owner;
        self.binding.users.owners(slot).map(move |users|users.iter().map(move |local|
            SiteId::from_monotonic(owner,*local)))
    }
    /// Exact immutable view pairing only, not canonical/backend validation.
    pub fn matches_scene(self,scene:PreparedScene<'_>)->bool {same_view(self.scene,scene)}
}
fn same_view(a:PreparedScene<'_>,b:PreparedScene<'_>)->bool {
    // Exhaustive destructuring forces an audit when either canonical view or
    // render-relevant config gains a field; no silently omitted future state.
    let PreparedScene {width:aw,height:ah,color_config:ac,clear:av,commands:ao,extent:ae}=a;
    let PreparedScene {width:bw,height:bh,color_config:bc,clear:bv,commands:bo,extent:be}=b;
    let key=|ColorConfig {profile,format,mapping,reference_white_nits}| {
        let (mode,exposure)=match mapping {
            crate::SdrMapping::Clip=>(0,0),
            crate::SdrMapping::ReinhardPerChannel {exposure}=>(1,exposure.to_bits()),
        };
        (profile,format,mode,exposure,reference_white_nits.to_bits())
    };
    std::ptr::eq(ao,bo) && ae==be && aw==bw && ah==bh
        && av.map(f32::to_bits)==bv.map(f32::to_bits) && key(ac)==key(bc)
}
fn matching(changes:&PreparedChanges<'_>,publication:&PreparedPublication<'_>)->Result<BatchStamp,PublicationError> {
    let stamp=publication.stamp();
    if changes.batch().stamp!=stamp {return Err(PublicationError::Stamp);}
    Ok(stamp)
}
impl Canvas {
    pub(super) fn revoke_publication(&mut self) {self.publication=None;}
    /// This view pins the canonical owner against mutation while it is live.
    ///
    /// ```compile_fail,E0502
    /// use gpui_canvas::{Canvas,Color};
    /// let mut canvas=Canvas::new(16,16).unwrap();
    /// let view=canvas.accepted_scene().unwrap();
    /// canvas.clear(Color::WHITE);
    /// let _=view.scene();
    /// ```
    pub fn accepted_scene(&self)->Result<CanvasAcceptedSceneView<'_>,PublicationError> {
        let binding=self.publication.as_ref().ok_or(PublicationError::NoPublication)?;
        // Binding admission, ownership and mutation revocation make this O(1).
        // No caller metadata arguments, no receipt getter, no hash/revalidation.
        Ok(CanvasAcceptedSceneView {scene:self.prepared_scene(),binding})
    }
}
impl CanvasScene<'_> {
    /// Admit every fallible metadata/history check BEFORE mutating old Canvas.
    /// Dropped/rejected scene/journal/publication guards preserve their old base.
    /// One publication guard cannot bind two scenes:
    ///
    /// ```compile_fail,E0382
    /// use gpui_canvas::CanvasScene;
    /// use gpui_reactivity_core::change::{PreparedChanges,PreparedPublication,SceneGroups};
    /// fn no_rebind(a:CanvasScene<'_>,b:CanvasScene<'_>,ca:PreparedChanges<'_>,cb:PreparedChanges<'_>,p:PreparedPublication<'_>,ga:SceneGroups,gb:SceneGroups) {
    ///     let _=a.commit_publication(ca,p,ga);
    ///     let _=b.commit_publication(cb,p,gb);
    /// }
    /// ```
    pub fn commit_publication(self,changes:PreparedChanges<'_>,publication:PreparedPublication<'_>,groups:SceneGroups)->Result<DamageRegion,PublicationError> {
        let stamp=matching(&changes,&publication)?;
        if groups.revision()!=stamp.to || groups.source_epoch()!=stamp.source_epoch
            || groups.snapshot_epoch()!=stamp.snapshot_epoch || groups.draw_count()!=self.pending.commands.len() {
            return Err(PublicationError::Metadata);
        }
        if let Some(old)=&self.target.publication {
            if stamp.from!=Some(old.receipt.stamp().to) {return Err(PublicationError::Stamp);}
        }
        // Conservative legacy stage damage in O(1). Incremental renderer jobs
        // derive exact old/new support from the bound dependency/range contract;
        // do not add another whole-command diff to canonical publication.
        let users=MaterialUsers::build(self.pending.prepared_scene(),&groups,stamp.to)?;
        let damage=DamageRegion::checked_canvas_bounds([0,0,self.pending.width,self.pending.height]);
        let target=self.commit_into(); // infallible canonical mutation revokes old binding first
        let batch=changes.commit();let receipt=publication.commit();
        target.publication=Some(Binding {receipt,batch,groups,users,mutation:Mutation::Snapshot,scratch:Vec::new()});
        Ok(damage)
    }
}
// Slot implementation lives in its module so its private checked fields and
// original mutation body stay in one authority path.
pub(super) fn check_slot_publication(canvas:&mut Canvas,changes:&PreparedChanges<'_>,publication:&PreparedPublication<'_>,edits:&[SlotEdit],changed:usize)->Result<BatchStamp,PublicationError> {
    let stamp=matching(changes,publication)?;
    let old=canvas.publication.as_mut().ok_or(PublicationError::NoPublication)?;
    if stamp.from!=Some(old.receipt.stamp().to) || stamp.to.owner!=old.groups.revision().owner {return Err(PublicationError::Stamp);}
    // A truncated/unknown journal can hide layout/topology behind Paint rows.
    // A full RASTER cannot repair missing canonical geometry. Rebuild a full
    // staged snapshot instead; no hard reason certifies paint-only retargeting.
    if !changes.batch().full.is_empty() {return Err(PublicationError::IncompleteChanges);}
    if changed!=0 && !changes.batch().entries.iter().any(|entry|entry.facets.contains(Facet::Paint)) {
        return Err(PublicationError::NonPaintMutation);
    }
    for entry in &changes.batch().entries {
        if [Facet::Topology,Facet::Layout,Facet::TextSource,Facet::TextPolicy,Facet::TextWidth,
            Facet::Transform,Facet::Clip,Facet::Stacking,Facet::ResourcePixels,Facet::ResourceMetrics]
            .into_iter().any(|facet|entry.facets.contains(facet)) {return Err(PublicationError::NonPaintMutation);}
    }
    // This checked transaction is Paint-only. Typed resource-pixel operations
    // must use their own actual resource update path, not impersonate a slot.
    // All ACTUAL changed material users must be invalidated, not merely one
    // unrelated Paint annotation. Hard/truncated histories already rejected;
    // this route never treats a full-raster request as a geometry certificate.
    old.scratch.clear();old.scratch.try_reserve_exact(changed).map_err(|_|PublicationError::Allocation)?;
    for slot in canvas.commands.columns.changed_slots(edits) {old.scratch.push(slot);}
    if old.scratch.len()!=changed {return Err(PublicationError::Metadata);}
    if changes.batch().full.is_empty() {
        for slot in &old.scratch {
            let users=old.users.owners(*slot).ok_or(PublicationError::Metadata)?;
            for local in users {
                // PreparedChanges owns Journal's unique SiteId-ordered rows.
                let site=SiteId::from_monotonic(old.users.bank.owner,*local);
                let covered=changes.batch().entries.binary_search_by_key(&site,|entry|entry.site).ok()
                    .is_some_and(|index| {let entry=&changes.batch().entries[index];
                        entry.facets.contains(Facet::Paint)});
                if !covered {return Err(PublicationError::UncoveredPaint);}
            }
        }
    }
    // O(1) preflight against the already validated owned group partition.
    // Dropping this header-only guard changes nothing.
    drop(old.groups.prepare_retarget(stamp).map_err(|_|PublicationError::Stamp)?);
    Ok(stamp)
}
pub(super) struct SlotParts {pub(super) groups:SceneGroups,users:MaterialUsers,mutation:SlotMutation,scratch:Vec<PaintSlot>}
pub(super) fn take_slot_groups(canvas:&mut Canvas)->SlotParts {
    let Binding {receipt,batch:_,groups,users,mutation,scratch}=canvas.publication.take().expect("prevalidated old binding");
    let base=receipt.stamp().to;
    let spare=match mutation {Mutation::Snapshot=>Vec::new(),Mutation::Slots(old)=>old.slots};
    SlotParts {groups,users,mutation:SlotMutation {base,slots:scratch},scratch:spare}
}
pub(super) fn install(canvas:&mut Canvas,receipt:PublicationReceipt,batch:ChangeBatch,parts:SlotParts) {
    let SlotParts {groups,users,mutation,scratch}=parts;
    canvas.publication=Some(Binding {receipt,batch,groups,users,mutation:Mutation::Slots(mutation),scratch});
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn common_model_inline_binding_layout_is_explicit_not_a_silent_old_budget_change() {
        println!("COMMON_PUBLICATION_LAYOUT Canvas={} oldCanvas=464 Binding={} OptionBinding={} Receipt={} Batch={} Groups={} Stats={} Scratch={}",
            size_of::<Canvas>(),size_of::<Binding>(),size_of::<Option<Binding>>(),size_of::<PublicationReceipt>(),
            size_of::<ChangeBatch>(),size_of::<SceneGroups>(),size_of::<RenderStats>(),size_of::<RasterScratch>());
        assert_eq!(size_of::<Option<Binding>>(),size_of::<Binding>(),"one inline binding, no hidden heap owner");
        assert_eq!(size_of::<Canvas>(),464+size_of::<Option<Binding>>(),"versioned common-model cost; old ABI test deliberately remains frozen until accounting descendant");
        assert_eq!(size_of::<RenderStats>(),96);assert_eq!(size_of::<RasterScratch>(),56);
    }
}
