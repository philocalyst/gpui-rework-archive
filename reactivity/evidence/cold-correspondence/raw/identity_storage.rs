#![allow(dead_code)]
const MAX_NODES: usize = 100_000;
#[path="/home/user/gpui-cold-correspondence-lab/reactivity/crates/gpui/src/runtime/identity_index.rs"]
mod identity_index;
fn main() {
    for n in [0,1,2,7,8,9,31,32,33,63,64,65,257] { for entropy in [false,true] {
        let ids:Vec<_>=(0..n).map(|i| if entropy {(i as u64).wrapping_mul(0x9e3779b97f4a7c15).wrapping_add(1)}else{i as u64+1}).collect();
        let index=identity_index::IdentityIndex::from_ids(ids.iter().copied());
        let heap=match &index {identity_index::IdentityIndex::Contiguous{..}=>0,identity_index::IdentityIndex::Runs(v)=>std::mem::size_of_val(&**v),identity_index::IdentityIndex::Indexed(v)=>std::mem::size_of_val(&**v)};
        for (i,id) in ids.iter().enumerate(){assert_eq!(index.get(*id),Some(i));}
        println!("{n},{entropy},{},{}",std::mem::size_of_val(&index),heap);
    }}
}
