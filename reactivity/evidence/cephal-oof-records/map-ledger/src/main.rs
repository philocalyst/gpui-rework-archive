use std::collections::BTreeMap;
use cephal::tree::AbsoluteContext;
use cephal::compute::oof::OofEntry;
use gpui_reactivity_core::{NodeId, Tree, NodeKind};
fn report(name: &str, f: impl FnOnce()) {
    let a = allocation_counter::measure(f);
    println!("{name},{},{},{},{}", a.bytes_current, a.bytes_total, a.bytes_max, a.count_total);
}
fn main() {
    println!("NodeId={},AbsoluteContext={},OofEntry={},map={},LayoutTree={}", size_of::<NodeId>(),size_of::<AbsoluteContext>(),size_of::<OofEntry>(),size_of::<BTreeMap<NodeId,AbsoluteContext>>(),size_of::<gpui_reactivity_core::layout::LayoutTree>());
    let mut tree = Tree::new();
    let ids: Vec<_> = (0..13).map(|_| tree.insert(None, NodeKind::Element).unwrap()).collect();
    let mut map = None;
    report("box", || map = Some(Box::new(BTreeMap::new())));
    let mut map = map.unwrap();
    for (index, &id) in ids.iter().enumerate() {
        report(&format!("insert-{}",index+1), || { map.insert(id, AbsoluteContext::default()); });
    }
    report("drop-map", || drop(map));
    let mut entries: Vec<OofEntry> = Vec::new();
    report("entries-capacity16", || entries.reserve_exact(16));
    assert_eq!(entries.capacity(),16);
    report("drop-entries", || drop(entries));
}
