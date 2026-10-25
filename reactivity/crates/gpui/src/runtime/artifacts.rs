//! Canonical live-source derived artifact ownership. No width LRU or render root.
use super::*;
use gpui_reactivity_core::{change::Artifact,resource::ResourceLease};
use gpui_canvas::text::{FontFace,ShapeArtifact};

pub(super) struct ShapeInputs { source:SharedText, font:FontFace, size:u32 }
impl ShapeInputs {
    pub(super) fn new(source:SharedText,font:FontFace,size:f32)->Self { Self {source,font,size:size.to_bits()} }
    fn matches(&self,other:&Self)->bool {
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
/// Dense index is only an optimization; canonical Artifact identity is checked
/// on every lookup. No width cache and no per-lookup registry scan. Both Vec
/// capacities are separately reportable metadata, not font/payload/RSS claims.
pub(super) struct ArtifactStore { accepted:Vec<Option<(Artifact,Entry)>>, pending:Vec<Option<(Artifact,Entry)>>, limit:usize }
impl ArtifactStore {
    pub(super) fn new(admitted_site_limit:usize)->Self { Self {accepted:Vec::new(),pending:Vec::new(),limit:admitted_site_limit} }
    pub(super) fn begin(&mut self) {self.abort();}
    pub(super) fn abort(&mut self) {for entry in &mut self.pending {*entry=None;}}
    pub(super) fn get(&self,slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ShapeArtifact> {
        self.pending.get(slot).and_then(Option::as_ref).filter(|(actual,entry)|*actual==key && entry.inputs.matches(inputs))
            .or_else(||self.accepted.get(slot).and_then(Option::as_ref).filter(|(actual,entry)|*actual==key && entry.inputs.matches(inputs)))
            .map(|(_,entry)|entry.shape())
    }
    pub(super) fn stage(&mut self,slot:usize,key:Artifact,inputs:ShapeInputs,shape:ShapeArtifact)->bool {
        if slot>=self.limit {return false;}
        let Some(length)=slot.checked_add(1) else {return false;};
        if self.pending.len()<length {
            if self.pending.try_reserve(length-self.pending.len()).is_err() {return false;}
            self.pending.resize_with(length,||None);
        }
        // Reserve accepted capacity now, so commit cannot require a fresh Vec
        // allocation after source/scene admission. Allocation failure declines
        // optional retention without altering accepted entries or ordinary output.
        if self.accepted.len()<length {
            if self.accepted.try_reserve(length-self.accepted.len()).is_err() {return false;}
            self.accepted.resize_with(length,||None);
        }
        self.pending[slot]=Some((key,Entry {inputs,payload:DerivedPayload::TextShape(shape)}));true
    }
    pub(super) fn commit(&mut self,mut live:impl FnMut(usize,Artifact)->bool) {
        for (index,entry) in self.accepted.iter_mut().enumerate() {if entry.as_ref().is_some_and(|(key,_)|!live(index,*key)) {*entry=None;}}
        for (index,entry) in self.pending.iter_mut().enumerate() {
            if let Some((key,value))=entry.take() {if live(index,key) {self.accepted[index]=Some((key,value));}}
        }
    }
    pub(super) fn lease(&self,slot:usize,key:Artifact,inputs:&ShapeInputs)->Option<&ResourceLease> {self.get(slot,key,inputs).map(ShapeArtifact::lease)}
    /// Exact payload capacity of store INDEX arrays, including inline entry/key/
    /// lease headers. Shared ShapeResource/font allocations charged separately.
    pub(super) fn index_capacity_bytes(&self)->Option<usize> {
        self.accepted.capacity().checked_add(self.pending.capacity())?
            .checked_mul(std::mem::size_of::<Option<(Artifact,Entry)>>())
    }
}
