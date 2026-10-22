//! Same production index, plus an aligned layout control; codegen only.
const MAX_NODES: usize = 100_000;
#[path = "/root/gpui-identity-index/reactivity/crates/gpui/src/runtime/identity_index.rs"]
mod identity_index;
use identity_index::IdentityIndex;
use std::collections::BTreeMap;

#[inline(never)]
pub fn packed_lookup(ids: &[u64], queries: &[u64]) -> usize {
    let index = IdentityIndex::from_ids(ids.iter().copied());
    queries.iter().fold(0, |sum, &id| sum ^ index.get(id).unwrap_or(usize::MAX))
}
#[inline(never)]
pub fn tree_lookup(ids: &[u64], queries: &[u64]) -> usize {
    let index: BTreeMap<_, _> = ids.iter().copied().enumerate().map(|(i,id)| (id,i)).collect();
    queries.iter().fold(0, |sum, id| sum ^ index.get(id).copied().unwrap_or(usize::MAX))
}
#[repr(C)]
struct AlignedEntry {identity:u64,index:u32}
#[inline(never)]
pub fn aligned_lookup(ids: &[u64], queries: &[u64]) -> usize {
    let mut entries: Vec<_> = ids.iter().copied().enumerate().map(|(i,identity)| AlignedEntry{identity,index:i as u32}).collect();
    entries.sort_unstable_by_key(|entry|entry.identity);
    queries.iter().fold(0, |sum,&id| sum ^ entries.binary_search_by_key(&id, |entry|entry.identity).ok().map(|i|entries[i].index as usize).unwrap_or(usize::MAX))
}

#[path = "/root/gpui-identity-runs/reactivity/crates/gpui/src/runtime/identity_index.rs"]
mod runs_index;
#[inline(never)]
pub fn runs_lookup(ids: &[u64], queries: &[u64]) -> usize {
    let index = runs_index::IdentityIndex::from_ids(ids.iter().copied());
    queries.iter().fold(0, |sum, &id| sum ^ index.get(id).unwrap_or(usize::MAX))
}
const _: () = assert!(std::mem::size_of::<IdentityIndex>() == 24);
const _: () = assert!(std::mem::size_of::<identity_index::Entry>() == 12);
const _: () = assert!(std::mem::align_of::<identity_index::Entry>() == 4);
const _: () = assert!(std::mem::size_of::<runs_index::IdentityIndex>() == 24);
const _: () = assert!(std::mem::size_of::<runs_index::Run>() == 16);
const _: () = assert!(std::mem::size_of::<AlignedEntry>() == 16);
