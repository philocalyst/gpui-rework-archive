//! One-shot canonical publication binding. No Target/ACK/image completion grant.
use super::*;
use gpui_reactivity_core::change::{BatchStamp,ChangeBatch,Facet,PreparedPublication,PreparedChanges,PublicationReceipt,SceneGroups,SceneRevision,SiteId,ClosedDependencies,DependencyNode,Artifact,Phase};

// Intentionally INLINE: no fallible allocation after canonical mutation. All
// owned batch/range vectors were admitted by the producer before this commit.
// Exact default Canvas ABI cost must be measured/priced separately from old464.
pub(super) struct Binding {
    receipt:PublicationReceipt,
    batch:ChangeBatch,
    closed:Option<ClosedDependencies>,
    groups:SceneGroups,
    users:MaterialUsers,
    mutation:Mutation,
    scratch:Vec<PaintSlot>,
}
// Owners are checked addresses in Binding.groups, never semantic identities.
// The table and CSR move together and checked-slot retarget changes headers only.
struct MaterialUsers { bank:SceneRevision, offsets:Vec<u32>, owners:Vec<u32> }
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
        if u32::try_from(groups.groups().len()).is_err() || groups.revision()!=bank {return Err(PublicationError::Metadata);}
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
                        edges.push((slot.index(),u32::try_from(index).map_err(|_|PublicationError::Metadata)?));
                    }
                    index+=1;
                }
            }
            first=end;
        }
        Self::from_edges(rows,edges,bank,groups)
    }
    fn from_edges(rows:usize,mut edges:Vec<(u32,u32)>,bank:SceneRevision,groups:&SceneGroups)->Result<Self,PublicationError> {
        // Addresses are meaningful only in this exact owned canonical table.
        if u32::try_from(groups.groups().len()).is_err() || groups.revision()!=bank
            || edges.iter().any(|(slot,index)|*slot as usize>=rows || *index as usize>=groups.groups().len()) {
            return Err(PublicationError::Metadata);
        }
        if rows==0 {return Ok(Self {bank,offsets:Vec::new(),owners:Vec::new()});}
        edges.sort_unstable_by_key(|(slot,index)|(*slot,groups.groups()[*index as usize].local));edges.dedup();
        if u32::try_from(edges.len()).is_err() {return Err(PublicationError::Metadata);}
        let offset_count=rows.checked_add(1).ok_or(PublicationError::Metadata)?;
        let mut offsets=Vec::new();offsets.try_reserve_exact(offset_count).map_err(|_|PublicationError::Allocation)?;
        let mut owners=Vec::new();owners.try_reserve_exact(edges.len()).map_err(|_|PublicationError::Allocation)?;
        let mut cursor=0;
        for row in 0..rows {
            offsets.push(owners.len() as u32);
            while cursor<edges.len() && edges[cursor].0 as usize==row {owners.push(edges[cursor].1);cursor+=1;}
        }
        offsets.push(owners.len() as u32);Ok(Self {bank,offsets,owners})
    }
    fn owners(&self,slot:PaintSlot)->Option<&[u32]> {
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
    /// Already-closed OLD+NEW logical dependencies; physical group/resource/tile
    /// resolution and target completion are still separate renderer admission.
    /// Missing closure is a mandatory conservative full-consumer fallback.
    pub fn closed_dependencies(self)->Option<&'a ClosedDependencies> {self.binding.closed.as_ref()}
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
        self.binding.users.owners(slot).map(move |users|users.iter().map(move |index|
            SiteId::from_monotonic(owner,self.binding.groups.groups()[*index as usize].local)))
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
fn check_non_graphical(changes:&PreparedChanges<'_>,stamp:BatchStamp)->Result<(),PublicationError> {
    if changes.batch().entries.iter().any(|entry|!entry.facets.is_non_graphical()) {
        return Err(PublicationError::IncompleteChanges);
    }
    let closed=changes.closed_dependencies().ok_or(PublicationError::IncompleteChanges)?;
    if closed.stamp()!=stamp || !closed.full().is_empty() || closed.artifacts().iter().any(|node|!matches!(node,
        DependencyNode::Site(Artifact {site,phase:Phase::Hit|Phase::Semantics}) if site.owner==stamp.to.owner)) {
        return Err(PublicationError::IncompleteChanges);
    }
    Ok(())
}
impl Canvas {
    pub(super) fn revoke_publication(&mut self) {self.publication=None;}
    /// Reuse the COMPLETE canonical command owner for a strictly non-graphical
    /// accepted transition. This is not partial group reuse or image completion.
    /// Both the raw facts and mandatory closed receipt must contain only
    /// Hit/Semantics work. Unknown/future/graphical domains fail closed.
    /// No command traversal, drawing, rasterization or resource cloning occurs.
    pub fn commit_non_graphical_publication(&mut self,changes:PreparedChanges<'_>,publication:PreparedPublication<'_>)->Result<DamageRegion,PublicationError> {
        // All authority lives in the one checked retarget guard, including
        // direct callers of SlotCommit with an empty edit list.
        self.prepare_slots(&[]).map_err(|_|PublicationError::Metadata)?.commit_publication(changes,publication)
    }

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
        // Once recorded ownership begins, there is ONE mandatory metadata
        // authority. External tables cannot bypass failed/incomplete scopes.
        if self.recording.is_some() {return Err(PublicationError::Metadata);}
        self.commit_with_materials(changes,publication,groups,None)
    }
    pub(super) fn commit_with_materials(self,changes:PreparedChanges<'_>,publication:PreparedPublication<'_>,groups:SceneGroups,edges:Option<Vec<(u32,u32)>>)->Result<DamageRegion,PublicationError> {
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
        let users=if let Some(edges)=edges {
            MaterialUsers::from_edges(self.pending.prepared_scene().paint_bank().len(),edges,stamp.to,&groups)?
        }else{MaterialUsers::build(self.pending.prepared_scene(),&groups,stamp.to)?};
        let damage=DamageRegion::checked_canvas_bounds([0,0,self.pending.width,self.pending.height]);
        let target=self.commit_into(); // infallible canonical mutation revokes old binding first
        let (batch,closed)=changes.commit_with_closure();let receipt=publication.commit();
        target.publication=Some(Binding {receipt,batch,closed,groups,users,mutation:Mutation::Snapshot,scratch:Vec::new()});
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
    if changed==0 {
        // A nonempty same-color list is not a substitute for a closed
        // non-graphical proof. Raw Paint no-ops conservatively take full stage
        // until a separate completed-output proof can certify that intent.
        check_non_graphical(changes,stamp)?;
    }else{
        if changed!=0 && changes.closed_dependencies().is_none() && !changes.batch().entries.iter().any(|entry|entry.facets.contains(Facet::Paint)) {
            return Err(PublicationError::NonPaintMutation);
        }
        if changes.batch().entries.iter().any(|entry|!entry.facets.is_material_only()) {
            return Err(PublicationError::NonPaintMutation);
        }
        if let Some(closed)=changes.closed_dependencies() {
            // Material is distinct from primitive CONTENT/generation. Any causal
            // geometry/content or unknown resource/global domain needs full stage.
            if closed.artifacts().iter().any(|node|!matches!(node,
                DependencyNode::Site(Artifact {phase:Phase::Material|Phase::Raster|Phase::Hit|Phase::Semantics,..}))) {
                return Err(PublicationError::IncompleteChanges);
            }
        }
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
            for index in users {
                // PreparedChanges owns Journal's unique SiteId-ordered rows.
                let site=SiteId::from_monotonic(old.users.bank.owner,old.groups.groups()[*index as usize].local);
                let covered=if let Some(closed)=changes.closed_dependencies() {
                    closed.stamp()==stamp && closed.full().is_empty()
                        && [Phase::Material,Phase::Raster].into_iter().all(|phase|
                            closed.artifacts().contains(&DependencyNode::Site(Artifact {site,phase})))
                }else{
                    changes.batch().entries.binary_search_by_key(&site,|entry|entry.site).ok()
                        .is_some_and(|index|changes.batch().entries[index].facets.contains(Facet::Paint))
                };
                if !covered {return Err(PublicationError::UncoveredPaint);}
            }
        }
    }
    // O(1) preflight against the already validated owned group partition.
    // Dropping this header-only guard changes nothing.
    drop(old.groups.prepare_retarget(stamp).map_err(|_|PublicationError::Stamp)?);
    Ok(stamp)
}
pub(super) fn slot_origin(canvas:&Canvas)->Result<(SceneRevision,SceneRevision),PublicationError> {
    let binding=canvas.publication.as_ref().ok_or(PublicationError::NoPublication)?;
    Ok((binding.receipt.stamp().to,binding.users.bank))
}
pub(super) fn slot_users(canvas:&Canvas,slot:PaintSlot)->Option<impl Iterator<Item=SiteId>+'_> {
    let binding=canvas.publication.as_ref()?;let owner=binding.users.bank.owner;
    binding.users.owners(slot).map(move |users|users.iter().map(move |index|SiteId::from_monotonic(owner,binding.groups.groups()[*index as usize].local)))
}
pub(super) struct SlotParts {pub(super) groups:SceneGroups,users:MaterialUsers,mutation:SlotMutation,scratch:Vec<PaintSlot>}
pub(super) fn take_slot_groups(canvas:&mut Canvas)->SlotParts {
    let Binding {receipt,batch:_,closed:_,groups,users,mutation,scratch}=canvas.publication.take().expect("prevalidated old binding");
    let base=receipt.stamp().to;
    let spare=match mutation {Mutation::Snapshot=>Vec::new(),Mutation::Slots(old)=>old.slots};
    SlotParts {groups,users,mutation:SlotMutation {base,slots:scratch},scratch:spare}
}
pub(super) fn install(canvas:&mut Canvas,receipt:PublicationReceipt,batch:ChangeBatch,closed:Option<ClosedDependencies>,parts:SlotParts) {
    let SlotParts {groups,users,mutation,scratch}=parts;
    canvas.publication=Some(Binding {receipt,batch,closed,groups,users,mutation:Mutation::Slots(mutation),scratch});
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn non_graphical_receipt_reuses_complete_command_and_resource_owner_without_emission() {
        use crate::{AlphaMode,Image,ImageProfile,ImageSampling,TextSystem,Point,Gradient,GradientGeometry,GradientStop,Extend,Interpolation};
        use gpui_reactivity_core::change::{FrameIssuer,Journal,GroupSpan,Change,Facets,Scope,Support,Dependencies};
        use std::num::NonZeroU64 as Nz;
        fn pointers(canvas:&Canvas)->[usize;7] {
            let commands=&canvas.commands;
            [commands.order.as_ptr() as usize,commands.inline.as_ptr() as usize,commands.commons.as_ptr() as usize,
             commands.masks.as_ptr() as usize,commands.images.as_deref().map_or(0,|r|r as *const ImageResources as usize),
             commands.images.as_deref().and_then(|r|r.clips.as_deref()).map_or(0,|r|r as *const clips::ClipArena as usize),
             canvas.raster.as_deref().map_or(0,|r|r as *const RasterScratch as usize)]
        }
        let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),16);
        let site=SiteId::from_monotonic(issuer.owner(),Nz::new(1).unwrap());
        let image=Image::rgba8(1,1,ImageProfile::Srgb,AlphaMode::Straight,vec![30,60,190,170].into_boxed_slice()).unwrap();
        let gradient=Gradient::new(GradientGeometry::Linear {start:Point::default(),end:Point{x:1.,y:0.}},
            &[GradientStop::new(0.,Color::BLACK),GradientStop::new(1.,Color::WHITE)],Extend::Pad,Interpolation::LinearSrgb).unwrap();
        let mut text=TextSystem::bundled().unwrap();let layout=text.shape("owner reuse",10.,None).unwrap();
        let mut emit=|scene:&mut CanvasScene<'_>| {
            scene.clear(Color::BLACK);
            let clip=scene.create_clip(None,ClipShape::RoundedRect {rect:Rect::new(1.,1.,62.,30.),radius:4.},Affine::IDENTITY).unwrap();
            scene.fill_gradient(&gradient,Rect::new(0.,0.,64.,32.),0.,Affine::IDENTITY,clip).unwrap();
            scene.draw_image(&image,Rect::new(28.,2.,30.,24.),Affine::IDENTITY,clip,ImageSampling::Nearest).unwrap();
            scene.draw_text_scaled(&mut text,&layout,Point{x:2.,y:5.},Affine::IDENTITY,clip,Color::WHITE,1.).unwrap();
        };
        let mut canvas=Canvas::recording(64,32,ColorConfig::default()).unwrap();
        let first=BatchStamp {from:None,to:SceneRevision {owner:issuer.owner(),sequence:Nz::new(1).unwrap()},source_epoch:1,snapshot_epoch:1};
        let mut scene=canvas.stage();emit(&mut scene);
        let count=scene.draw_count();assert!(count>2);
        let groups=SceneGroups::new(first.to,1,1,vec![GroupSpan {local:site.local,parent:None,draws:0..count as u32}],count).unwrap();
        scene.commit_publication(journal.prepare(first).unwrap(),issuer.prepare(first).unwrap(),groups).unwrap();
        let mut seed=vec![0;64*32];canvas.render_bgrx(&mut seed).unwrap();
        let before=pointers(&canvas);let storage=canvas.prepared_scene().storage();let masks:Vec<_>=canvas.commands.masks.iter().map(Arc::as_ptr).collect();
        assert!(!masks.is_empty());assert_ne!(before[4],0);assert_ne!(before[5],0);assert_ne!(before[6],0);
        let mut graph=Dependencies::new(64);graph.reset(first.to);graph.register_site(site);assert!(graph.finish(1));
        for (sequence,facet) in [(2,Facet::Hit),(3,Facet::Semantics)] {
            journal.record(Change {site,facets:Facets::one(facet),scope:Scope::Site,before:Support::Pending,after:Support::Pending});
            let closed=graph.invalidate_pending(&journal);
            let next=BatchStamp {from:journal.base(),to:SceneRevision {owner:issuer.owner(),sequence:Nz::new(sequence).unwrap()},source_epoch:sequence,snapshot_epoch:sequence};
            let changes=journal.prepare(next).unwrap().with_closed(closed).unwrap();let publication=issuer.prepare(next).unwrap();
            let mut damage=None;
            let allocations=allocation_counter::measure(|| {damage=Some(canvas.commit_non_graphical_publication(changes,publication).unwrap());});
            assert_eq!((allocations.count_total,allocations.bytes_total),(0,0),"guard/closure construction is outside this commit-only scope");
            assert!(damage.unwrap().is_empty());assert_eq!(pointers(&canvas),before,"no command/resource/raster owner replaced");
            assert_eq!(canvas.commands.masks.iter().map(Arc::as_ptr).collect::<Vec<_>>(),masks);
            assert_eq!(canvas.prepared_scene().storage().lane_bytes(),storage.lane_bytes());
            let frame=canvas.accepted_scene().unwrap();assert_eq!(frame.stamp(),next);
            let mutation=frame.checked_slot_mutation().unwrap();assert_eq!(mutation.base(),next.from.unwrap());assert_eq!(mutation.bank_origin(),first.to);assert!(mutation.changed_slots().is_empty());
            let mut output=vec![0;64*32];canvas.render_bgrx(&mut output).unwrap();assert_eq!(output,seed);
            graph.reset(next.to);graph.register_site(site);assert!(graph.finish(1));
        }
        let mut cold=Canvas::recording(64,32,ColorConfig::default()).unwrap();let mut scene=cold.stage();emit(&mut scene);scene.commit();
        let mut expected=vec![0;64*32];cold.render_bgrx(&mut expected).unwrap();assert_eq!(seed,expected);
    }

    #[test]
    fn material_owner_addresses_reject_revision_mismatch_and_out_of_range_before_csr_allocation() {
        use std::num::NonZeroU64 as Nz;
        use gpui_reactivity_core::change::{FrameIssuer,GroupSpan};
        let issuer=FrameIssuer::new().unwrap();
        let bank=SceneRevision {owner:issuer.owner(),sequence:Nz::new(1).unwrap()};
        let groups=SceneGroups::new(bank,1,1,vec![GroupSpan {local:Nz::new(9).unwrap(),parent:None,draws:0..1}],1).unwrap();
        assert!(matches!(MaterialUsers::from_edges(1,vec![(0,1)],bank,&groups),Err(PublicationError::Metadata)));
        let other=SceneRevision {owner:issuer.owner(),sequence:Nz::new(2).unwrap()};
        assert!(matches!(MaterialUsers::from_edges(1,vec![(0,0)],other,&groups),Err(PublicationError::Metadata)));
        assert!(matches!(MaterialUsers::from_edges(1,vec![(1,0)],bank,&groups),Err(PublicationError::Metadata)));
        let users=MaterialUsers::from_edges(1,vec![(0,0),(0,0)],bank,&groups).unwrap();
        assert_eq!(users.offsets,vec![0,1]);assert_eq!(users.owners,vec![0]);
        assert_eq!(size_of::<(u32,u32)>(),8);assert_eq!(size_of::<u32>(),4);
        assert_eq!(size_of::<(u32,Nz)>(),16);assert_eq!(size_of::<Nz>(),8);
        assert_eq!(size_of::<Vec<u32>>(),size_of::<Vec<Nz>>(),"no header saving claimed");
        let groups=SceneGroups::new(bank,1,1,vec![
            GroupSpan {local:Nz::new(9).unwrap(),parent:None,draws:0..1},
            GroupSpan {local:Nz::new(2).unwrap(),parent:None,draws:1..2},
            GroupSpan {local:Nz::new(7).unwrap(),parent:None,draws:2..3},
        ],3).unwrap();
        let edges=vec![(0,0),(0,1),(0,2)];let mut retained=None;
        let allocations=allocation_counter::measure(|| {
            retained=Some(MaterialUsers::from_edges(1,edges,bank,&groups).unwrap());
        });
        assert_eq!((allocations.count_total,allocations.bytes_total),(2,20),"offsets8 + owners12; old u64 owners requested24");
        let retained=retained.unwrap();assert_eq!(retained.owners,vec![1,2,0]);
    }
    #[test]
    fn common_model_inline_binding_layout_is_explicit_not_a_silent_old_budget_change() {
        println!("COMMON_PUBLICATION_LAYOUT Canvas={} oldCanvas=464 Binding={} OptionBinding={} Receipt={} Batch={} Groups={} Stats={} Scratch={}",
            size_of::<Canvas>(),size_of::<Binding>(),size_of::<Option<Binding>>(),size_of::<PublicationReceipt>(),
            size_of::<ChangeBatch>(),size_of::<SceneGroups>(),size_of::<RenderStats>(),size_of::<RasterScratch>());
        assert_eq!(size_of::<Option<Binding>>(),size_of::<Binding>(),"one inline binding, no hidden heap owner");
        assert_eq!(size_of::<Canvas>(),464+size_of::<Option<Binding>>(),"versioned common-model cost; old ABI test deliberately remains frozen until accounting descendant");
        assert_eq!(size_of::<RenderStats>(),96);assert_eq!(size_of::<RasterScratch>(),56);
    }
    #[test]
    fn fused_actual_admission_edges_equal_independent_group_scan_for_shared_empty_and_rolled_back_text() {
        use gpui_reactivity_core::change::{FrameIssuer,Journal,SiteId};
        use std::num::NonZeroU64 as Nz;
        let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),32);
        let stamp=BatchStamp {from:None,to:SceneRevision {owner:issuer.owner(),sequence:Nz::new(1).unwrap()},source_epoch:1,snapshot_epoch:1};
        let mut canvas=Canvas::recording(64,32,ColorConfig::default()).unwrap();let mut stage=canvas.stage();stage.start_recording(stamp).unwrap();
        let slot=stage.paint_slot(PaintColor::new(Color::WHITE)).unwrap();let clip=Rect::new(0.,0.,64.,32.);
        let site=|n|SiteId::from_monotonic(stamp.to.owner,Nz::new(n).unwrap());
        let mut text=TextSystem::bundled().unwrap();let layout=text.shape("MMMM",4.,None).unwrap();let empty=text.shape("",4.,None).unwrap();let failing=text.shape("WWWW",4.,None).unwrap();
        let mut cached=None;
        for n in 1..=7 {
            let mut scope=stage.begin_recorded_site(site(n),None).unwrap();let scene=scope.scene_mut();
            match n {
                1=>scene.fill_rect_slot(Rect::new(1.,1.,8.,8.),Affine::IDENTITY,clip,slot).unwrap(),
                2=>scene.fill_rounded_rect_slot(Rect::new(12.,2.,9.,9.),2.,Affine::IDENTITY,clip,slot).unwrap(),
                3=>scene.fill_rounded_rect_shared(Rect::new(24.,2.,9.,9.),2.,Affine::IDENTITY,clip,PaintColor::new(Color::BLACK),&mut cached).unwrap(),
                4=>scene.draw_text_scaled_shared(&mut text,&layout,Point{x:1.,y:24.},Affine::IDENTITY,clip,PaintColor::new(Color::BLACK),&mut cached,1.).unwrap(),
                5=>scene.draw_text_scaled_slot(&mut text,&empty,Point::default(),Affine::IDENTITY,clip,slot,1.).unwrap(),
                6=>{let old=scene.pending.references;let draws=scene.draw_count();let masks=scene.pending.commands.masks.len();
                    scene.pending.references=MAX_REFERENCES-1;
                    assert!(scene.draw_text_scaled_slot(&mut text,&failing,Point{x:0.,y:10.},Affine::IDENTITY,clip,slot,1.).is_err());
                    assert_eq!(scene.draw_count(),draws);assert_eq!(scene.pending.commands.masks.len(),masks);scene.pending.references=old;},
                _=>scene.fill_rect_slot(Rect::new(1000.,1000.,8.,8.),Affine::IDENTITY,clip,slot).unwrap(),
            }
            scope.finish();
        }
        let (groups,edges)=stage.recording_parts_for_test();
        assert_eq!(groups.groups().len(),7);assert_eq!(groups.groups()[4].draws.start,groups.groups()[4].draws.end);
        let actual=MaterialUsers::from_edges(stage.pending.prepared_scene().paint_bank().len(),edges.unwrap(),stamp.to,&groups).unwrap();
        let reference=MaterialUsers::build(stage.pending.prepared_scene(),&groups,stamp.to).unwrap();
        assert_eq!(actual.bank,reference.bank);assert_eq!(actual.offsets,reference.offsets);assert_eq!(actual.owners,reference.owners);
        stage.commit_recorded_publication(journal.prepare(stamp).unwrap(),issuer.prepare(stamp).unwrap()).unwrap();
        let view=canvas.accepted_scene().unwrap();assert_eq!(view.material_users(slot).unwrap().map(|s|s.local.get()).collect::<Vec<_>>(),vec![1,2]);
        assert_eq!(view.material_users(cached.unwrap()).unwrap().map(|s|s.local.get()).collect::<Vec<_>>(),vec![3,4]);
    }

}
