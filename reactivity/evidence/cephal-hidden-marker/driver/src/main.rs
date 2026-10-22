#[allow(dead_code)]
#[path = "/root/gpui-cephal-hidden-marker/reactivity/crates/core/tests/layout/hidden.rs"]
mod hidden;
use hidden::HiddenTree;
fn phase(fixture: &mut HiddenTree, name: &str, edit: impl FnOnce(&mut HiddenTree)) {
    let before = fixture.tree.stats();
    let a = allocation_counter::measure(|| {
        edit(fixture);
        fixture.compute();
    });
    let after = fixture.tree.stats();
    fixture.assert_cold();
    let storage = fixture.tree.storage();
    println!(
        "{name},{},{},{},{},{},{},{},{},{},{}",
        a.bytes_current,
        a.bytes_total,
        a.bytes_max,
        a.count_total,
        storage.allocated_caches,
        storage.cache_heap_bytes,
        after.computed_answers - before.computed_answers,
        after.cached_answers - before.cached_answers,
        after.measure_calls - before.measure_calls,
        after.changed_layout_writes - before.changed_layout_writes
    );
}
fn main() {
    let mode = std::env::args().nth(1).unwrap();
    let count = if mode == "empty" { 0 } else { 1000 };
    let mut fixture = None;
    let a =
        allocation_counter::measure(|| fixture = Some(HiddenTree::new(count, mode == "hidden")));
    let mut fixture = fixture.unwrap();
    eprintln!(
        "LayoutTree={},mode={mode}",
        size_of::<gpui_reactivity_core::layout::LayoutTree>()
    );
    println!("stage,retained,total,peak,calls,caches,cache_heap,computed,cached,measured,changed");
    println!(
        "construct,{},{},{},{},0,0,0,0,0,0",
        a.bytes_current, a.bytes_total, a.bytes_max, a.count_total
    );
    phase(&mut fixture, "compute", |_| {});
    phase(&mut fixture, "dirty", |f| {
        f.tree.mark_dirty(f.root).unwrap()
    });
    if count != 0 {
        if mode == "warm-hide" {
            phase(&mut fixture, "hide-all", |f| {
                for index in 0..count {
                    f.set_hidden(index, true)
                }
            });
            phase(&mut fixture, "reveal-all", |f| {
                for index in 0..count {
                    f.set_hidden(index, false)
                }
            });
        } else if mode == "hidden" {
            phase(&mut fixture, "reveal-one", |f| f.set_hidden(0, false));
            phase(&mut fixture, "hide-one", |f| f.set_hidden(0, true));
            phase(&mut fixture, "move", |f| {
                f.tree.reparent(f.leaves[0], Some(f.parents[1])).unwrap();
            });
            phase(&mut fixture, "remove-reuse", |f| {
                let s = f.tree.style(f.parents[2]).unwrap().clone();
                f.tree.remove(f.parents[2]).unwrap();
                let p = f
                    .tree
                    .insert(Some(f.root), gpui_reactivity_core::NodeKind::Element, s)
                    .unwrap();
                f.tree
                    .insert(
                        Some(p),
                        gpui_reactivity_core::NodeKind::Element,
                        Default::default(),
                    )
                    .unwrap();
            });
            phase(&mut fixture, "reveal-all", |f| {
                for index in 0..count {
                    if f.tree.tree().contains(f.parents[index]) {
                        f.set_hidden(index, false)
                    }
                }
            });
        }
    }
}
