from pathlib import Path
source=Path('/home/user/gpui-state-lab/reactivity/crates/gpui/examples/state_update_cost.rs').read_text()
model=source[source.index('struct Page'):source.index('// Measurement-only FFI')]
helpers=source[source.index('fn ack('):source.index('fn main(')]
ledger='''//! Requested allocation costs for the identical state-update model.
use gpui::{WindowOptions, prelude::*};
'''+model+helpers+'''
fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let rows: usize = args[0].parse().unwrap();
    let bytes = std::fs::read(&args[1]).unwrap();
    let font = gpui_canvas::FontFace::new(&bytes).unwrap();
    // Global immutable text data and code are warmed outside the owner ledger.
    drop(mount(rows, "Count: 0".into(), font.clone()));
    let mut win = None;
    let cold = allocation_counter::measure(|| {
        win = Some(mount(rows, "Count: 0".into(), font.clone()));
    });
    let mut total = cold.bytes_current;
    println!("rows,stage,allocations,requested,live_delta,live_total,peak_new");
    println!("{rows},cold,{},{},{},{},{}",cold.count_total,cold.bytes_total,cold.bytes_current,total,cold.bytes_max);
    for (stage,value) in [("warm","Count: 1"),("warm2","Count: 2"),("long","Count: 123456789"),("short","Count: 3")] {
        let cost = allocation_counter::measure(|| {
            let owner = win.as_mut().unwrap();
            owner.set(Page::LABEL,value.into()).unwrap();
            ack(owner);
        });
        total += cost.bytes_current;
        println!("{rows},{stage},{},{},{},{},{}",cost.count_total,cost.bytes_total,cost.bytes_current,total,cost.bytes_max);
        assert!(win.as_ref().unwrap().contains_text(value).unwrap());
    }
    let cost = allocation_counter::measure(|| drop(win.take()));
    total += cost.bytes_current;
    println!("{rows},drop,{},{},{},{},{}",cost.count_total,cost.bytes_total,cost.bytes_current,total,cost.bytes_max);
    assert_eq!(total,0,"all measured window allocations reclaimed");
    eprintln!("font_file_bytes={},shared_immutable_font_is_outside_owner_ledger=true",bytes.len());
}
'''
for root in ['/home/user/gpui-state-lab','/home/user/gpui-sparse-text-lab','/home/user/gpui-text-session-lab']:
 p=Path(root)/'reactivity/crates/gpui/examples/state_update_allocations.rs'
 assert not p.exists()
 p.write_text(ledger)
