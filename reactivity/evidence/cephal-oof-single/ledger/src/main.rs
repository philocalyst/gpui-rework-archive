#![allow(dead_code)]
use std::collections::BTreeMap;
use cephal::tree::AbsoluteContext;
use gpui_reactivity_core::{NodeId, Tree, NodeKind};
include!("cold.rs");
fn report(name: &str, f: impl FnOnce()) {
 let a=allocation_counter::measure(f);
 println!("{name},{},{},{},{}",a.bytes_current,a.bytes_total,a.bytes_max,a.count_total);
}
fn main() {
 println!("AbsoluteContexts={},NodeId={},AbsoluteContext={},map={},LayoutTree={}",size_of::<AbsoluteContexts>(),size_of::<NodeId>(),size_of::<AbsoluteContext>(),size_of::<BTreeMap<NodeId,AbsoluteContext>>(),size_of::<gpui_reactivity_core::layout::LayoutTree>());
 let mut tree=Tree::new();
 let ids:Vec<_>=(0..13).map(|_|tree.insert(None,NodeKind::Element).unwrap()).collect();
 let mut records=None;
 report("box",||records=Some(Box::new(AbsoluteContexts::Empty)));
 let mut records=records.unwrap();
 report("single-first",||records.insert(ids[0],AbsoluteContext::default()));
 report("single-replace",||records.insert(ids[0],AbsoluteContext::default()));
 let mut moved=None;
 report("single-take",||moved=records.remove(&ids[0]));
 report("single-reinsert",||records.insert(ids[0],moved.take().unwrap()));
 for (index,&id) in ids.iter().enumerate().skip(1) {
  report(&format!("insert-{}",index+1),||records.insert(id,AbsoluteContext::default()));
 }
 for &id in ids.iter().skip(1) { records.remove(&id).unwrap(); }
 report("many-take-last",||moved=records.remove(&ids[0]));
 assert!(matches!(*records,AbsoluteContexts::Many(..)));
 report("many-reinsert",||records.insert(ids[0],moved.take().unwrap()));
 report("drop-many",||drop(records));
}
