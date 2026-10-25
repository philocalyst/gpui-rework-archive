//! Canonical live-source derived artifact ownership. No width LRU or render root.
use super::*;
use std::collections::BTreeMap;
use gpui_reactivity_core::{change::Artifact,resource::ResourceLease};
use gpui_canvas::text::{FontFace,ShapeArtifact};

#[derive(Clone)]
pub(super) struct ShapeInputs { source:SharedText, font:FontFace, size:u32 }
impl ShapeInputs {
    pub(super) fn new(source:SharedText,font:FontFace,size:f32)->Self { Self {source,font,size:size.to_bits()} }
    pub(super) fn matches(&self,other:&Self)->bool {
        // Both immutable leases stay alive: address+length cannot be an ABA hit.
        std::ptr::eq::<str>(&*self.source,&*other.source) && self.font.same_face(&other.font) && self.size==other.size
    }
}
/// Future artifact kinds join this common owner, not independent cache maps.
pub(super) enum DerivedPayload { TextShape(ShapeArtifact) }
struct Entry { inputs:ShapeInputs, payload:DerivedPayload }
impl Entry {
    fn shape(&self)->&ShapeArtifact { match &self.payload {DerivedPayload::TextShape(shape)=>shape} }
}
/// Sparse full-Artifact owner. Neither Node index nor TextSlot is an allocation
/// index; one late admitted shape costs one record even after declined text.
/// Standard BTree nodes have opaque allocation overhead/capacity: report actual
/// isolated test allocator observations separately from exact inline payload.
#[derive(Clone,Copy,Debug,Default,PartialEq,Eq)]
pub(super) struct StoreVisits {pub(super) abort:usize,pub(super) commit:usize,pub(super) overflow:bool}
pub(super) struct ArtifactStore {
    accepted:BTreeMap<Artifact,Entry>,pending:BTreeMap<Artifact,Option<Entry>>,
    pending_new:usize,limit:usize,visits:StoreVisits,
}
impl ArtifactStore {
    pub(super) fn new(admitted_site_limit:usize)->Self {
        Self {accepted:BTreeMap::new(),pending:BTreeMap::new(),pending_new:0,limit:admitted_site_limit,visits:StoreVisits::default()}
    }
    fn visit(counter:&mut usize,n:usize,overflow:&mut bool) {
        if let Some(next)=counter.checked_add(n) {*counter=next;} else {*counter=usize::MAX;*overflow=true;}
    }
    pub(super) fn begin(&mut self) {self.abort();}
    pub(super) fn abort(&mut self) {
        Self::visit(&mut self.visits.abort,self.pending.len(),&mut self.visits.overflow);
        self.pending.clear();self.pending_new=0;
    }
    pub(super) fn get(&self,_slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ShapeArtifact> {
        if let Some(pending)=self.pending.get(&key) {return pending.as_ref().filter(|entry|entry.inputs.matches(inputs)).map(Entry::shape);}
        self.accepted.get(&key).filter(|entry|entry.inputs.matches(inputs)).map(Entry::shape)
    }
    /// The actual final dependency wins: drop incompatible pending B, reuse
    /// accepted A if exact inputs match; tombstone ONLY incompatible accepted.
    pub(super) fn reconcile(&mut self,slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ShapeArtifact> {
        if self.pending.get(&key).is_some_and(|entry|entry.as_ref().is_some_and(|entry|entry.inputs.matches(inputs))) {
            return self.get(slot,key,inputs);
        }
        if self.pending.remove(&key).is_some() && !self.accepted.contains_key(&key) {self.pending_new-=1;}
        if self.accepted.get(&key).is_some_and(|entry|entry.inputs.matches(inputs)) {return self.get(slot,key,inputs);}
        if self.accepted.contains_key(&key) {self.pending.insert(key,None);}
        None
    }
    pub(super) fn stage(&mut self,_slot:usize,key:Artifact,inputs:ShapeInputs,shape:ShapeArtifact)->bool {
        if shape.lease().origin()!=gpui_reactivity_core::change::DependencyNode::Site(key) {return false;}
        let new=!self.pending.contains_key(&key)&&!self.accepted.contains_key(&key);
        if new && self.accepted.len().checked_add(self.pending_new).is_none_or(|n|n>=self.limit) {return false;}
        self.pending.insert(key,Some(Entry {inputs,payload:DerivedPayload::TextShape(shape)}));
        if new {self.pending_new+=1;} true
    }
    /// Only after successful C/read-set publication. Failed preparation MUST
    /// abort instead. Recoverable semantic failures never mutate accepted roots.
    /// BTree/Arc metadata allocation still has the documented global-OOM caveat.
    pub(super) fn commit(&mut self,mut live:impl FnMut(Artifact)->bool) {
        Self::visit(&mut self.visits.commit,self.accepted.len(),&mut self.visits.overflow);
        Self::visit(&mut self.visits.commit,self.pending.len(),&mut self.visits.overflow);
        self.accepted.retain(|key,_|live(*key));
        for (key,value) in std::mem::take(&mut self.pending) {
            if !live(key) {continue;}
            if let Some(value)=value {self.accepted.insert(key,value);} else {self.accepted.remove(&key);}
        }
        self.pending_new=0;
    }
    pub(super) fn lease(&self,slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ResourceLease> {self.get(slot,key,inputs).map(ShapeArtifact::lease)}
    pub(super) fn visits(&self)->StoreVisits {self.visits}
    /// Exact inline entry/key/header bytes, NOT BTree node capacity, allocator
    /// overhead, or RSS. Allocator-based metadata probes run in isolated tests.
    pub(super) fn metadata_payload_bytes(&self)->Option<usize> {
        std::mem::size_of::<Self>().checked_add(self.accepted.len().checked_mul(std::mem::size_of::<(Artifact,Entry)>())?)?
            .checked_add(self.pending.len().checked_mul(std::mem::size_of::<(Artifact,Option<Entry>)>())?)
    }
    #[cfg(test)]
    pub(super) fn owned_resource_ids(&self)->std::collections::BTreeSet<gpui_reactivity_core::resource::ResourceId> {
        self.accepted.values().map(|entry|entry.shape().lease().id())
            .chain(self.pending.values().filter_map(|entry|entry.as_ref().map(|entry|entry.shape().lease().id()))).collect()
    }
}
