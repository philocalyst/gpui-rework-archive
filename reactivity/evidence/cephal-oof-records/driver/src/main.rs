#[allow(dead_code)]
#[path = "/root/gpui-cephal-flat-oof/reactivity/crates/core/tests/layout.rs"]
mod layout;
use layout::oof::MeasuredRows;
fn phase(fixture: &mut MeasuredRows, name: &str, edit: impl FnOnce(&mut MeasuredRows)) {
    let before = fixture.tree.stats();
    let allocation = allocation_counter::measure(|| { edit(fixture);fixture.compute(); });
    let after = fixture.tree.stats();
    fixture.assert_cold();
    let measured = after.measure_calls - before.measure_calls;
    let computed = after.computed_answers - before.computed_answers;
    let cached = after.cached_answers - before.cached_answers;
    match name {
        "text" => { assert!(measured <= 4);assert!(computed <= 8); }
        "style" => { assert!(measured <= 4);assert!(computed <= 10);assert!(cached >= 900); }
        "placement" => { assert_eq!(measured, 0);assert!(computed <= 8); }
        "reparent" => { assert!(measured <= 4);assert!(computed <= 12);assert!(cached >= 900); }
        _ => {}
    }
    let storage = fixture.tree.storage();
    println!("{name},{},{},{},{},{measured},{computed},{cached},{},{},{}",allocation.bytes_current,allocation.bytes_total,allocation.bytes_max,allocation.count_total,after.changed_layout_writes-before.changed_layout_writes,storage.absolute_contexts,storage.cache_heap_bytes);
}
fn main() {
    let include_tooltip = std::env::args().nth(1).unwrap() == "oof";
    let mut fixture = MeasuredRows::new(include_tooltip);
    eprintln!("LayoutTree={},tooltip={include_tooltip}",size_of::<gpui_reactivity_core::layout::LayoutTree>());
    println!("stage,retained,total,peak,calls,measured,computed,cached,changed,contexts,cache_heap");
    phase(&mut fixture,"compute",|_|{});
    phase(&mut fixture,"text",MeasuredRows::edit_text);
    phase(&mut fixture,"style",MeasuredRows::edit_style);
    if include_tooltip {
        phase(&mut fixture,"placement",MeasuredRows::edit_placement);
        phase(&mut fixture,"reparent",MeasuredRows::reparent);
    }
}
