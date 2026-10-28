from pathlib import Path
p=Path('/tmp/gpui-cephal-single-ledger'); (p/'src').mkdir(parents=True,exist_ok=True)
base=Path('/tmp/gpui-cephal-oof-map-ledger')
(p/'Cargo.toml').write_text((base/'Cargo.toml').read_text().replace('gpui-cephal-oof-map-ledger','gpui-cephal-single-ledger'))
(p/'Cargo.lock').write_text((base/'Cargo.lock').read_text())
s=Path('/root/gpui-cephal-flat-oof/reactivity/crates/core/src/layout.rs').read_text(); start=s.index('enum AbsoluteContexts {'); end=s.index('/// Retained flex/block/grid',start)
(p/'src/cold.rs').write_text(s[start:end])
(p/'src/main.rs').write_text('''#![allow(dead_code)]
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
''')
