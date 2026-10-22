//! Production packed index and the old tree, plus an aligned-entry control.
const MAX_NODES: usize = 100_000;
#[path = "/root/gpui-identity-index/reactivity/crates/gpui/src/runtime/identity_index.rs"]
mod identity_index;
use identity_index::IdentityIndex;
use std::{collections::BTreeMap, hint::black_box, time::Instant};

#[repr(C)]
struct AlignedEntry { identity:u64, index:u32 }
enum AlignedIndex { Contiguous{first:u64,len:usize}, Indexed(Box<[AlignedEntry]>) }
impl AlignedIndex {
    fn new(ids: &[u64]) -> Self {
        if ids.is_empty() {return Self::Contiguous{first:0,len:0};}
        let first=ids[0];
        if ids.iter().enumerate().all(|(index,&identity)|identity.checked_sub(first)==Some(index as u64)) {
            return Self::Contiguous{first,len:ids.len()};
        }
        let mut entries:Vec<_>=ids.iter().copied().enumerate().map(|(index,identity)|AlignedEntry{identity,index:index as u32}).collect();
        entries.sort_unstable_by_key(|entry|entry.identity);
        assert!(entries.windows(2).all(|p|p[0].identity!=p[1].identity));
        Self::Indexed(entries.into_boxed_slice())
    }
}
trait Lookup {fn lookup(&self,id:u64)->Option<usize>;}
impl Lookup for IdentityIndex {fn lookup(&self,id:u64)->Option<usize>{self.get(id)}}
impl Lookup for BTreeMap<u64,usize> {fn lookup(&self,id:u64)->Option<usize>{self.get(&id).copied()}}
impl Lookup for AlignedIndex {
    fn lookup(&self,id:u64)->Option<usize>{
        match self {
            Self::Contiguous{first,len}=>{let index=id.checked_sub(*first)?;(index<*len as u64).then_some(index as usize)}
            Self::Indexed(entries)=>entries.binary_search_by_key(&id,|entry|entry.identity).ok().map(|i|entries[i].index as usize),
        }
    }
}
#[inline(never)]
fn queries<T:Lookup>(index:&T,keys:&[u64],rounds:usize)->u64 {
    let mut checksum=0u64;
    for _ in 0..rounds {for &id in keys {checksum=checksum.wrapping_add(index.lookup(black_box(id)).map_or(u64::MAX,|i|i as u64));}}
    checksum
}
fn measure<T:Lookup>(tag:&str,mode:&str,ids:&[u64],keys:&[u64],rounds:usize,build:impl FnOnce()->T)->u64 {
    let mut index=None;
    let start=Instant::now();
    let allocation=allocation_counter::measure(||index=Some(build()));
    let ns=start.elapsed().as_nanos();
    println!("cost,build,{tag},{mode},{},1,{ns},{},{},{},{}",ids.len(),allocation.count_total,allocation.bytes_total,allocation.bytes_current,allocation.bytes_max);
    let index=index.unwrap();
    let start=Instant::now();
    let mut result=0;
    let allocation=allocation_counter::measure(||result=queries(&index,keys,rounds));
    let ns=start.elapsed().as_nanos();
    assert_eq!(allocation.count_total,0);
    println!("cost,lookup,{tag},{mode},{},{},{ns},0,0,0,0",ids.len(),keys.len()*rounds);
    result
}
fn main(){
    println!("pin,{}",env!("IDENTITY_INDEX_SOURCE"));
    assert_eq!(std::mem::size_of::<AlignedIndex>(),24);
    assert_eq!(std::mem::size_of::<AlignedEntry>(),16);
    let capture=std::env::args().nth(1).as_deref()==Some("capture");
    if capture{assert_eq!(std::env::var("IDENTITY_INDEX_QUIET").as_deref(),Ok("approved"));}
    let rotation=std::env::var("TABLE_ROTATION").unwrap_or_else(|_|"0".into()).parse::<usize>().unwrap()%3;
    for count in if capture{vec![60,4096,65_536]}else{vec![1,60]} {
        for mode in ["contiguous","gaps","permuted","reverse"] {
            let ids:Vec<u64>=(0..count).map(|i|100+match mode{"gaps"=>2*i,"permuted"=>(i*193)%count,"reverse"=>count-1-i,_=>i}as u64).collect();
            let keys:Vec<u64>=(0..count).map(|i|if i%16==0{u64::MAX}else{ids[(i*193)%count]}).collect();
            let index=IdentityIndex::from_ids(ids.iter().copied());
            for (i,&id) in ids.iter().enumerate(){assert!(index.contains(id));assert_eq!(index.required(id),i);}
            assert_eq!(index.get(u64::MAX),None);
            let rounds=if capture{8}else{1};
            let mut expected=None;
            for step in 0..3 {
                let value=match (step+rotation)%3 {
                    0=>measure("packed12",mode,&ids,&keys,rounds,||IdentityIndex::from_ids(ids.iter().copied())),
                    1=>measure("aligned16",mode,&ids,&keys,rounds,||AlignedIndex::new(&ids)),
                    _=>measure("tree",mode,&ids,&keys,rounds,||ids.iter().copied().enumerate().map(|(i,id)|(id,i)).collect::<BTreeMap<_,_>>()),
                };
                if let Some(expected)=expected {assert_eq!(value,expected);}else {expected=Some(value);}
            }
            println!("guard,{mode},{count},{:016x}",expected.unwrap());
        }
    }
}
