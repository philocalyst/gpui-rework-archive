//! Mandatory actual own ranges, optional authoritative material-edge fusion.
use super::*;
use gpui_reactivity_core::change::{BatchStamp,GroupSpan,PreparedChanges,PreparedPublication,SceneGroups,SceneRevision,SiteId};
use std::num::NonZeroU64;

pub(super) struct Recording {
    stamp:BatchStamp,
    groups:Vec<GroupSpan>,
    edges:Option<Vec<(u32,u32)>>,
    active:Option<(usize,NonZeroU64)>,
    valid:bool,
}
/// Structural parent selector, not stable identity/address/ACK authority.
/// Snapshot and expected local identity are rechecked against CURRENT storage.
#[derive(Clone,Copy)]
pub struct RecordedSiteIndex {snapshot:SceneRevision,local:NonZeroU64,index:u32}
pub struct RecordedSiteScope<'stage,'canvas> {
    scene:&'stage mut CanvasScene<'canvas>,index:RecordedSiteIndex,finished:bool,
}
impl<'stage,'canvas> RecordedSiteScope<'stage,'canvas> {
    pub fn index(&self)->RecordedSiteIndex {self.index}
    pub fn scene_mut(&mut self)->&mut CanvasScene<'canvas> {self.scene}
    /// Producer calls only after successful completion of its OWN paint callback.
    /// Close this scope before visiting children.
    pub fn finish(mut self)->RecordedSiteIndex {self.finished=true;self.index}
}
impl Drop for RecordedSiteScope<'_,'_> {
    fn drop(&mut self) {
        let end=self.scene.pending.commands.len() as u32;
        if let Some(recording)=&mut self.scene.recording {
            if recording.stamp.to!=self.index.snapshot || recording.active!=Some((self.index.index as usize,self.index.local))
                || recording.groups.get(self.index.index as usize).is_none_or(|group|group.local!=self.index.local) {
                recording.valid=false;recording.active=None;return;
            }
            if let Some(group)=recording.groups.get_mut(self.index.index as usize) {group.draws.end=end;}
            else {recording.valid=false;}
            recording.valid &= self.finished;
            recording.active=None;
        }
    }
}
impl<'canvas> CanvasScene<'canvas> {
    /// Also serves as EXPLICIT restart after clear, never discards live draws.
    pub fn start_recording(&mut self,stamp:BatchStamp)->Result<(),PublicationError> {
        self.start_recording_with_capacity(stamp,0)
    }
    /// Admit the producer's known node-count capacity once BEFORE installing a
    /// replacement recorder or invoking callbacks. Count is a storage hint, not
    /// membership/identity authority; actual own spans are still validated.
    pub fn start_recording_with_capacity(&mut self,stamp:BatchStamp,sites:usize)->Result<(),PublicationError> {
        if stamp.snapshot_epoch==0 || sites>u32::MAX as usize || self.pending.commands.len()!=0
            || self.recording.as_ref().is_some_and(|r|r.active.is_some()) {return Err(PublicationError::Metadata);}
        let mut groups=Vec::new();
        groups.try_reserve_exact(sites).map_err(|_|PublicationError::Allocation)?;
        self.recording=Some(Recording {stamp,groups,edges:Some(Vec::new()),active:None,valid:true});Ok(())
    }
    /// O(1) selector from THIS mandatory span table; no shadow token vector.
    /// Only successfully finished earlier own callbacks can name a parent.
    pub fn recorded_site(&self,index:usize)->Option<RecordedSiteIndex> {
        let recording=self.recording.as_ref()?;
        if !recording.valid || recording.active.is_some() {return None;}
        let group=recording.groups.get(index)?;
        Some(RecordedSiteIndex {snapshot:recording.stamp.to,local:group.local,index:u32::try_from(index).ok()?})
    }
    pub fn begin_recorded_site(&mut self,site:SiteId,parent:Option<RecordedSiteIndex>)->Result<RecordedSiteScope<'_,'canvas>,PublicationError> {
        let start=self.pending.commands.len() as u32;
        let recording=self.recording.as_mut().ok_or(PublicationError::Metadata)?;
        if !recording.valid || recording.active.is_some() || site.owner!=recording.stamp.to.owner {return Err(PublicationError::Metadata);}
        let parent=if let Some(parent)=parent {
            if parent.snapshot!=recording.stamp.to || recording.groups.get(parent.index as usize).is_none_or(|g|g.local!=parent.local) {
                return Err(PublicationError::Metadata);
            }
            Some(parent.index)
        }else{None};
        let index=u32::try_from(recording.groups.len()).map_err(|_|PublicationError::Metadata)?;
        // Mandatory range storage is admitted BEFORE any callback/drawing.
        recording.groups.try_reserve(1).map_err(|_|PublicationError::Allocation)?;
        recording.groups.push(GroupSpan {local:site.local,parent,draws:start..start});
        recording.active=Some((index as usize,site.local));
        let token=RecordedSiteIndex {snapshot:recording.stamp.to,local:site.local,index};
        Ok(RecordedSiteScope {scene:self,index:token,finished:false})
    }
    pub(super) fn record_material_use(&mut self,start:usize,slot:Option<PaintSlot>) {
        if self.pending.commands.len()==start {return;}
        let Some(recording)=&mut self.recording else{return;};
        let Some((index,_))=recording.active else{recording.edges=None;return;};
        let Some(slot)=slot else{recording.edges=None;return;};
        let Ok(index)=u32::try_from(index) else{recording.edges=None;return;};
        if let Some(edges)=&mut recording.edges {
            if edges.last()==Some(&(slot.index(),index)) {return;}
            if edges.try_reserve(1).is_err() {recording.edges=None;return;}
            edges.push((slot.index(),index));
        }
    }
    pub(super) fn recording_clear(&mut self) {
        if let Some(recording)=&mut self.recording {
            if !recording.groups.is_empty() || recording.active.is_some() {
                recording.valid=false;recording.edges=None;
            }
        }
    }
    pub fn commit_recorded_publication(mut self,changes:PreparedChanges<'_>,publication:PreparedPublication<'_>)->Result<DamageRegion,PublicationError> {
        let recording=self.recording.take().ok_or(PublicationError::Metadata)?;
        if !recording.valid || recording.active.is_some() || recording.stamp!=publication.stamp() || recording.stamp!=changes.batch().stamp {
            return Err(PublicationError::Metadata);
        }
        let groups=SceneGroups::new(recording.stamp.to,recording.stamp.source_epoch,recording.stamp.snapshot_epoch,
            recording.groups,self.pending.commands.len()).ok_or(PublicationError::Metadata)?;
        self.commit_with_materials(changes,publication,groups,recording.edges)
    }
}

#[cfg(test)]
impl CanvasScene<'_> {
    pub(super) fn recording_parts_for_test(&self)->(SceneGroups,Option<Vec<(u32,u32)>>) {
        let recording=self.recording.as_ref().unwrap();
        (SceneGroups::new(recording.stamp.to,recording.stamp.source_epoch,recording.stamp.snapshot_epoch,
            recording.groups.clone(),self.draw_count()).unwrap(),recording.edges.clone())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use gpui_reactivity_core::change::{FrameIssuer,Journal};
    fn stamp(issuer:&FrameIssuer,journal:&Journal,n:u64)->BatchStamp {
        BatchStamp {from:journal.base(),to:SceneRevision {owner:issuer.owner(),sequence:NonZeroU64::new(n).unwrap()},source_epoch:n,snapshot_epoch:n}
    }
    fn site(stamp:BatchStamp,n:u64)->SiteId {SiteId::from_monotonic(stamp.to.owner,NonZeroU64::new(n).unwrap())}
    fn raw_groups(scene:&CanvasScene<'_>)->SceneGroups {
        let recording=scene.recording.as_ref().unwrap();
        SceneGroups::new(recording.stamp.to,recording.stamp.source_epoch,recording.stamp.snapshot_epoch,
            recording.groups.clone(),scene.draw_count()).unwrap()
    }
    #[test]
    fn current_table_parent_selector_rejects_active_invalid_and_out_of_range_without_allocation() {
        let issuer=FrameIssuer::new().unwrap();let journal=Journal::new(issuer.owner(),8);
        let next=stamp(&issuer,&journal,1);let mut canvas=Canvas::recording(16,16,ColorConfig::default()).unwrap();
        let mut scene=canvas.stage();assert!(scene.recorded_site(0).is_none());
        scene.start_recording_with_capacity(next,3).unwrap();assert!(scene.recorded_site(0).is_none());
        let mut root=scene.begin_recorded_site(site(next,1),None).unwrap();
        assert!(root.scene_mut().recorded_site(0).is_none(),"unfinished current own callback cannot be a parent token");
        root.finish();let parent=scene.recorded_site(0).unwrap();
        assert_eq!(parent.local,site(next,1).local);assert_eq!(parent.snapshot,next.to);
        assert!(scene.recorded_site(1).is_none());
        let measured=allocation_counter::measure(||for _ in 0..32 {assert!(scene.recorded_site(0).is_some());});
        assert_eq!(measured.bytes_total,0);
        scene.begin_recorded_site(site(next,2),Some(parent)).unwrap().finish();
        assert!(scene.recorded_site(1).is_some());
        assert!(scene.recording.as_ref().unwrap().groups.capacity()>=3);
        assert!(scene.start_recording_with_capacity(next,usize::MAX).is_err());
        assert_eq!(scene.recording.as_ref().unwrap().groups.len(),2,"failed mandatory admission must preserve previous recording");
        assert!(scene.recorded_site(1).is_some());
        drop(scene.begin_recorded_site(site(next,3),Some(parent)).unwrap());
        assert!(scene.recorded_site(0).is_none(),"failed own callback revokes the complete recording");
    }
    #[test]
    fn required_empty_and_actual_shared_ranges_survive_optional_trace_decline() {
        let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),32);
        let mut canvas=Canvas::recording(64,32,ColorConfig::default()).unwrap();let next=stamp(&issuer,&journal,1);
        let mut scene=canvas.stage();scene.start_recording(next).unwrap();scene.clear(Color::BLACK);
        let slot=scene.paint_slot(PaintColor::new(Color::WHITE)).unwrap();
        for n in 1..=4 {
            let mut scope=scene.begin_recorded_site(site(next,n),None).unwrap();
            if n<3 {scope.scene_mut().fill_rect_slot(Rect::new(n as f32*4.,2.,8.,8.),Affine::IDENTITY,Rect::new(0.,0.,64.,32.),slot).unwrap();}
            // n3/n4 are mandatory EMPTY logical own spans, not missing nodes.
            scope.finish();
        }
        assert_eq!(scene.recording.as_ref().unwrap().groups.len(),4);
        let groups=raw_groups(&scene);assert_eq!(groups.draw_count(),2);
        // Optional allocation-admission failure discards ONLY the edge cache.
        scene.recording.as_mut().unwrap().edges=None;
        assert_eq!(scene.recording.as_ref().unwrap().groups.len(),4);
        scene.commit_recorded_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap()).unwrap();
        let frame=canvas.accepted_scene().unwrap();assert_eq!(frame.groups().groups().len(),4);
        assert_eq!(frame.material_users(slot).unwrap().map(|s|s.local.get()).collect::<Vec<_>>(),vec![1,2]);
    }
    #[test]
    fn dropped_or_panicked_scope_cannot_publish_and_clear_requires_explicit_restart() {
        let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),32);
        let mut canvas=Canvas::recording(32,32,ColorConfig::default()).unwrap();let next=stamp(&issuer,&journal,1);
        let mut scene=canvas.stage();scene.start_recording(next).unwrap();
        let failed=std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let mut scope=scene.begin_recorded_site(site(next,1),None).unwrap();
            scope.scene_mut().fill_rect(Rect::new(0.,0.,8.,8.),Affine::IDENTITY,Rect::new(0.,0.,32.,32.),Color::WHITE).unwrap();
            panic!("intentional source callback failure");
        }));assert!(failed.is_err());
        assert!(scene.recording.as_ref().unwrap().active.is_none());
        assert!(!scene.recording.as_ref().unwrap().valid);
        assert_eq!(scene.commit_recorded_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap()),Err(PublicationError::Metadata));
        assert!(canvas.accepted_scene().is_err());assert_eq!(journal.base(),None);
        let mut scene=canvas.stage();scene.start_recording(next).unwrap();
        scene.begin_recorded_site(site(next,1),None).unwrap().finish();scene.clear(Color::BLACK);
        assert!(!scene.recording.as_ref().unwrap().valid);
        scene.start_recording(next).unwrap(); // explicit fresh empty recorder
        scene.begin_recorded_site(site(next,2),None).unwrap().finish();
        scene.commit_recorded_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap()).unwrap();
        assert_eq!(canvas.accepted_scene().unwrap().groups().groups()[0].local.get(),2);
    }
    #[test]
    fn nested_owner_and_stale_parent_selectors_reject_without_overwriting_active_scope() {
        let issuer=FrameIssuer::new().unwrap();let journal=Journal::new(issuer.owner(),8);let next=stamp(&issuer,&journal,1);
        let mut a=Canvas::recording(16,16,ColorConfig::default()).unwrap();let mut first=a.stage();first.start_recording(next).unwrap();
        let mut scope=first.begin_recorded_site(site(next,1),None).unwrap();
        assert!(scope.scene_mut().begin_recorded_site(site(next,2),None).is_err());
        let parent=scope.finish();
        let mut b=Canvas::recording(16,16,ColorConfig::default()).unwrap();let mut second=b.stage();second.start_recording(next).unwrap();
        second.begin_recorded_site(site(next,3),None).unwrap().finish();
        assert!(second.begin_recorded_site(site(next,4),Some(parent)).is_err(),"same index but different semantic parent");
    }
    #[test]
    fn unfinished_recording_cannot_escape_through_legacy_publication_with_external_metadata() {
        let mut issuer=FrameIssuer::new().unwrap();let mut journal=Journal::new(issuer.owner(),8);
        let mut canvas=Canvas::recording(16,16,ColorConfig::default()).unwrap();let next=stamp(&issuer,&journal,1);
        let mut stage=canvas.stage();stage.start_recording(next).unwrap();
        {let mut scope=stage.begin_recorded_site(site(next,1),None).unwrap();
            scope.scene_mut().fill_rect(Rect::new(0.,0.,8.,8.),Affine::IDENTITY,Rect::new(0.,0.,16.,16.),Color::WHITE).unwrap();}
        let external=SceneGroups::new(next.to,1,1,vec![GroupSpan {local:site(next,1).local,parent:None,draws:0..stage.draw_count() as u32}],stage.draw_count()).unwrap();
        assert_eq!(stage.commit_publication(journal.prepare(next).unwrap(),issuer.prepare(next).unwrap(),external),Err(PublicationError::Metadata));
        assert_eq!(journal.base(),None);assert!(canvas.accepted_scene().is_err());
    }

}
