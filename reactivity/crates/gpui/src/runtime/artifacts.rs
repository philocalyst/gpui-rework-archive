//! Canonical live-source derived artifact ownership. No width LRU or render root.
use super::*;
use std::collections::BTreeMap;
use gpui_reactivity_core::{change::Artifact,resource::ResourceLease};
use gpui_canvas::{FontFace,ShapeArtifact,OptionalShape};
use gpui_reactivity_core::resource::{ResourceContext,OptionalHandle,WindowAccounting,ResourceKind};
use gpui_reactivity_core::change::FrameIssuer;

#[derive(Clone)]
pub(super) struct ShapeInputs { source:SharedText, font:FontFace, size:u32 }
impl ShapeInputs {
    pub(super) fn new(source:SharedText,font:FontFace,size:f32)->Self { Self {source,font,size:size.to_bits()} }
    pub(super) fn matches(&self,other:&Self)->bool {
        // Both immutable leases stay alive: address+length cannot be an ABA hit.
        std::ptr::eq::<str>(&*self.source,&*other.source) && self.font.same_face(&other.font) && self.size==other.size
    }
}
/// A weak validity witness. Reclamation drops the actual source/font key leases.
#[derive(Clone)]
pub(super) struct RetainedInputs { handle:OptionalHandle<ShapeInputs> }
impl RetainedInputs {
    pub(super) fn retain(inputs:ShapeInputs,context:&mut ResourceContext,scope:WindowAccounting,issuer:&FrameIssuer,key:Artifact)->Option<Self> {
        let mut tx=context.window_reservation(scope,issuer).ok()?;
        let draft=tx.stage(ResourceKind::Utf8Source,key).ok()?;
        tx.share_utf8(draft,inputs.source.utf8_backing()).ok()?;
        inputs.font.share_retained_text_backing(&mut tx,draft).ok()?;
        let lease=tx.commit().ok()?.pop()?;
        Some(Self {handle:context.retain_optional(inputs,lease).ok()?})
    }
    pub(super) fn discard(&self,context:&mut ResourceContext) {let _=context.discard_optional(&self.handle);}
    pub(super) fn matches(&self,context:&ResourceContext,inputs:&ShapeInputs)->bool {
        context.pin_optional(&self.handle).ok().flatten().is_some_and(|pin|pin.payload().matches(inputs))
    }
}
enum InputWitness { #[cfg(test)] Reference(ShapeInputs), Reclaimable(RetainedInputs) }
impl InputWitness {
    fn matches(&self,inputs:&ShapeInputs,context:Option<&ResourceContext>)->bool {
        match self {#[cfg(test)] Self::Reference(saved)=>saved.matches(inputs),Self::Reclaimable(saved)=>context.is_some_and(|context|saved.matches(context,inputs))}
    }
}
/// Future artifact kinds join this common owner, not independent cache maps.
pub(super) enum DerivedPayload { #[cfg(test)] TextShape(ShapeArtifact), ReclaimableTextShape(OptionalShape) }
struct Entry { inputs:InputWitness, payload:DerivedPayload }
impl Entry {
    #[cfg(test)]
    fn shape(&self)->Option<&ShapeArtifact> { match &self.payload {DerivedPayload::TextShape(shape)=>Some(shape),_=>None} }
    fn id(&self)->gpui_reactivity_core::resource::ResourceId {match &self.payload {#[cfg(test)] DerivedPayload::TextShape(shape)=>shape.lease().id(),DerivedPayload::ReclaimableTextShape(shape)=>shape.id()}}
    fn pin(&self,context:&ResourceContext)->Option<ShapeArtifact> {match &self.payload {#[cfg(test)] DerivedPayload::TextShape(shape)=>Some(shape.clone()),DerivedPayload::ReclaimableTextShape(shape)=>shape.pin(context).ok().flatten()}}
}
/// Sparse canonical owner rows. Nodes and touched-key capacity are staged BEFORE
/// C; commit changes only touched rows. No accepted-map insertion during commit.
/// Full-liveness commit is the correctness reference/incomplete-history fallback.
enum Pending { Unchanged, Replace(Entry), Retire }
struct Owner { accepted:Option<Entry>, pending:Pending, touched:bool }
#[derive(Clone,Copy,Debug,Default,PartialEq,Eq)]
pub(super) struct StoreVisits {pub(super) staged_optional:usize,pub(super) retire:usize,pub(super) abort:usize,pub(super) commit:usize,pub(super) full_fallbacks:usize,pub(super) overflow:bool}
pub(super) struct ArtifactStore {
    owners:BTreeMap<Artifact,Owner>, touched:Vec<Artifact>,
    limit:usize,full_scan:bool,visits:StoreVisits,
}
impl ArtifactStore {
    pub(super) fn new(admitted_site_limit:usize)->Self {
        Self {owners:BTreeMap::new(),touched:Vec::new(),limit:admitted_site_limit,full_scan:false,visits:StoreVisits::default()}
    }
    fn visit(counter:&mut usize,n:usize,overflow:&mut bool) {
        if let Some(next)=counter.checked_add(n) {*counter=next;} else {*counter=usize::MAX;*overflow=true;}
    }
    fn touch(&mut self,key:Artifact) {
        let owner=self.owners.get_mut(&key).expect("existing canonical owner");
        if owner.touched {return;} owner.touched=true;
        let reserved={
            #[cfg(test)]
            {if FORCE_TOUCH_FAILURE.with(|flag|flag.get()) {false} else {self.touched.try_reserve(1).is_ok()}}
            #[cfg(not(test))]
            {self.touched.try_reserve(1).is_ok()}
        };
        if reserved {self.touched.push(key);} else {
            // Existing owner still records the transactional state. Metadata
            // reserve failure selects the full reference walk, never a missed
            // retirement or new semantic text error. No mutation is published.
            self.full_scan=true;
        }
    }
    pub(super) fn begin(&mut self) {self.abort();}
    pub(super) fn abort(&mut self) {
        if self.full_scan {
            Self::visit(&mut self.visits.abort,self.owners.len(),&mut self.visits.overflow);
            self.owners.retain(|_,owner| {owner.pending=Pending::Unchanged;owner.touched=false;owner.accepted.is_some()});
        } else {
            Self::visit(&mut self.visits.abort,self.touched.len(),&mut self.visits.overflow);
            for key in self.touched.drain(..) {
                let remove=if let Some(owner)=self.owners.get_mut(&key) {owner.pending=Pending::Unchanged;owner.touched=false;owner.accepted.is_none()} else {false};
                if remove {self.owners.remove(&key);}
            }
        }
        self.touched.clear();self.full_scan=false;self.release_empty_index();
    }
    #[cfg(test)]
    pub(super) fn get(&self,_slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ShapeArtifact> {
        let owner=self.owners.get(&key)?;
        let entry=match &owner.pending {Pending::Replace(entry)=>Some(entry),Pending::Retire=>None,Pending::Unchanged=>owner.accepted.as_ref()};
        entry.filter(|entry|entry.inputs.matches(inputs,None)).and_then(Entry::shape)
    }
    #[cfg(test)]
    pub(super) fn reconcile(&mut self,slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ShapeArtifact> {
        let owner=self.owners.get(&key)?;
        if matches!(&owner.pending,Pending::Replace(entry) if entry.inputs.matches(inputs,None)) {return self.get(slot,key,inputs);}
        let accepted_matches=owner.accepted.as_ref().is_some_and(|entry|entry.inputs.matches(inputs,None));
        if accepted_matches {
            // Superseded pending B drops, but accepted A remains the final input.
            self.owners.get_mut(&key).unwrap().pending=Pending::Unchanged;
            return self.get(slot,key,inputs);
        }
        self.touch(key);self.owners.get_mut(&key).unwrap().pending=Pending::Retire;None
    }
    /// Called from the common producer's actual removed/invalidated owner set.
    /// Caller stages the matching empty resource-read replacement before C.
    pub(super) fn retire_owner(&mut self,key:Artifact)->Option<gpui_reactivity_core::resource::ResourceId> {
        let old=self.owners.get(&key)?.accepted.as_ref().map(|entry|entry.id());
        Self::visit(&mut self.visits.retire,1,&mut self.visits.overflow);
        self.touch(key);self.owners.get_mut(&key).unwrap().pending=Pending::Retire;old
    }
    /// Incomplete producer history fallback. No key Vec clone is needed.
    /// Pending replacements are optional and may be dropped; a later exact
    /// resolver can rescue a still-valid accepted owner before publication.
    pub(super) fn retire_all(&mut self,mut visit:impl FnMut(Artifact)) {
        Self::visit(&mut self.visits.retire,self.owners.len(),&mut self.visits.overflow);
        for (&key,owner) in &mut self.owners {
            if owner.accepted.is_none() {continue;}
            if !owner.touched {
                owner.touched=true;
                if self.touched.try_reserve(1).is_ok() {self.touched.push(key);} else {self.full_scan=true;}
            }
            owner.pending=Pending::Retire;visit(key);
        }
    }
    #[cfg(test)]
    pub(super) fn stage(&mut self,_slot:usize,key:Artifact,inputs:ShapeInputs,shape:ShapeArtifact)->bool {
        if shape.lease().origin()!=gpui_reactivity_core::change::DependencyNode::Site(key) {return false;}
        if !self.owners.contains_key(&key) {
            if self.owners.len()>=self.limit || self.touched.try_reserve(1).is_err() {return false;}
            // BTree allocation is staged before C (global-OOM caveat remains).
            self.owners.insert(key,Owner {accepted:None,pending:Pending::Unchanged,touched:true});self.touched.push(key);
        } else {self.touch(key);}
        self.owners.get_mut(&key).unwrap().pending=Pending::Replace(Entry {inputs:InputWitness::Reference(inputs),payload:DerivedPayload::TextShape(shape)});true
    }
    /// Adopted path: weak payload and input owners; no raw root retained here.
    pub(super) fn reconcile_optional(&mut self,key:Artifact,inputs:&ShapeInputs,context:&ResourceContext)->Option<ShapeArtifact> {
        let owner=self.owners.get(&key)?;
        let pending=match &owner.pending {Pending::Replace(entry) if entry.inputs.matches(inputs,Some(context))=>entry.pin(context),_=>None};
        if pending.is_some() {return pending;}
        let accepted=owner.accepted.as_ref().filter(|entry|entry.inputs.matches(inputs,Some(context))).and_then(|entry|entry.pin(context));
        if accepted.is_some() {self.owners.get_mut(&key).unwrap().pending=Pending::Unchanged;return accepted;}
        self.touch(key);self.owners.get_mut(&key).unwrap().pending=Pending::Retire;None
    }
    pub(super) fn stage_optional(&mut self,key:Artifact,inputs:RetainedInputs,shape:ShapeArtifact,context:&mut ResourceContext)->bool {
        if shape.lease().origin()!=gpui_reactivity_core::change::DependencyNode::Site(key) {return false;}
        if !self.owners.contains_key(&key) {
            if self.owners.len()>=self.limit || self.touched.try_reserve(1).is_err() {return false;}
            self.owners.insert(key,Owner {accepted:None,pending:Pending::Unchanged,touched:true});self.touched.push(key);
        } else {self.touch(key);}
        let Ok(shape)=shape.into_optional(context) else {self.owners.get_mut(&key).unwrap().pending=Pending::Retire;return false;};
        self.owners.get_mut(&key).unwrap().pending=Pending::Replace(Entry {inputs:InputWitness::Reclaimable(inputs),payload:DerivedPayload::ReclaimableTextShape(shape)});
        Self::visit(&mut self.visits.staged_optional,1,&mut self.visits.overflow);true
    }
    pub(super) fn retained_inputs(&self,key:Artifact)->Option<RetainedInputs> {
        let owner=self.owners.get(&key)?;
        let entry=match &owner.pending {Pending::Replace(entry)=>Some(entry),Pending::Retire=>None,Pending::Unchanged=>owner.accepted.as_ref()}?;
        match &entry.inputs {InputWitness::Reclaimable(inputs)=>Some(inputs.clone()),#[cfg(test)] _=>None}
    }
    fn apply(owner:&mut Owner) {
        match std::mem::replace(&mut owner.pending,Pending::Unchanged) {
            Pending::Unchanged=>{},Pending::Replace(entry)=>owner.accepted=Some(entry),Pending::Retire=>owner.accepted=None,
        } owner.touched=false;
    }
    /// Complete producer history path: only keys touched this turn are visited.
    /// No map insert or Vec growth occurs here. Host allocation probes qualify
    /// the intended zero-allocation commit, not a compiler/RSS claim here.
    pub(super) fn commit_touched(&mut self) {
        if self.full_scan {self.commit(|_|true);return;}
        Self::visit(&mut self.visits.commit,self.touched.len(),&mut self.visits.overflow);
        for key in self.touched.drain(..) {
            let remove=if let Some(owner)=self.owners.get_mut(&key) {Self::apply(owner);owner.accepted.is_none()} else {false};
            if remove {self.owners.remove(&key);}
        }
        self.release_empty_index();
    }
    /// Full-liveness reference/fallback when producer history is incomplete.
    /// This intentionally visits all current rows, not a claimed changed-only path.
    pub(super) fn commit(&mut self,mut live:impl FnMut(Artifact)->bool) {
        Self::visit(&mut self.visits.full_fallbacks,1,&mut self.visits.overflow);
        Self::visit(&mut self.visits.commit,self.owners.len(),&mut self.visits.overflow);
        self.owners.retain(|key,owner| {Self::apply(owner);live(*key)&&owner.accepted.is_some()});
        self.touched.clear();self.full_scan=false;self.release_empty_index();
    }
    fn release_empty_index(&mut self) {if self.owners.is_empty() {self.touched.shrink_to_fit();}}
    #[cfg(test)]
    pub(super) fn lease(&self,slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ResourceLease> {self.get(slot,key,inputs).map(ShapeArtifact::lease)}
    pub(super) fn visits(&self)->StoreVisits {self.visits}
    /// Exact inline row/key/header + touched Vec capacity, NOT private BTree node
    /// spare capacity/allocator overhead. Isolated allocator probes price that.
    pub(super) fn metadata_payload_bytes(&self)->Option<usize> {
        std::mem::size_of::<Self>().checked_add(self.owners.len().checked_mul(std::mem::size_of::<(Artifact,Owner)>())?)?
            .checked_add(self.touched.capacity().checked_mul(std::mem::size_of::<Artifact>())?)
    }
    #[cfg(test)]
    pub(super) fn entry_inline_bytes()->usize {std::mem::size_of::<(Artifact,Owner)>()}
    #[cfg(test)]
    pub(super) fn owned_resource_ids(&self)->std::collections::BTreeSet<gpui_reactivity_core::resource::ResourceId> {
        self.owners.values().flat_map(|owner| [owner.accepted.as_ref().map(|entry|entry.id()),
            match &owner.pending {Pending::Replace(entry)=>Some(entry.id()),_=>None}]).flatten().collect()
    }
}

#[cfg(test)]
std::thread_local! {static FORCE_TOUCH_FAILURE:std::cell::Cell<bool>=const {std::cell::Cell::new(false)};}
#[cfg(test)]
pub(super) fn with_forced_touch_failure<R>(f:impl FnOnce()->R)->R {
    struct Reset(bool);
    impl Drop for Reset {fn drop(&mut self) {FORCE_TOUCH_FAILURE.with(|flag|flag.set(self.0));}}
    let _reset=Reset(FORCE_TOUCH_FAILURE.with(|flag|flag.replace(true)));f()
}
