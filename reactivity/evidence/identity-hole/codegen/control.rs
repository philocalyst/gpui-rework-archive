//! Exact production module; target assembly/layout control, no application.
const MAX_NODES: usize = 100_000;
#[path = "/root/gpui-identity-hole-hot/reactivity/crates/gpui/src/runtime/identity_index.rs"]
mod identity_index;
use identity_index::IdentityIndex;

#[inline(never)]
pub fn hole_lookup(ids: &[u64], queries: &[u64]) -> usize {
    let index = IdentityIndex::from_ids(ids.iter().copied());
    queries.iter().fold(0, |sum, &id| sum ^ index.get(id).unwrap_or(usize::MAX))
}
const _: () = assert!(std::mem::size_of::<IdentityIndex>() == 24);
const _: () = assert!(std::mem::size_of::<identity_index::HoleShape>() == 8);
const _: () = assert!(std::mem::size_of::<identity_index::Entry>() == 12);
const _: () = assert!(std::mem::align_of::<identity_index::Entry>() == 4);
const _: () = assert!(std::mem::size_of::<identity_index::Run>() == 16);
