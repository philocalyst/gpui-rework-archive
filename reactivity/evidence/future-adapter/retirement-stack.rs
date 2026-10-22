//! Public inferred lane types expose the transient close representation.
use gpui::{Completion, FieldId, LaneSet, Questions, Signal, Source};
use std::convert::Infallible;

struct Model {
    input: Signal<u64>,
}
const INPUT: Source<Model, u64> =
    Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
fn retired<M, L: LaneSet<M>>(_: &Questions<M, L>) -> usize {
    size_of::<L::Retired>()
}
fn report<T: Send + 'static>(name: &str) {
    let (plan, _) = Questions::new()
        .question(
            INPUT,
            |v| *v,
            |_, cap: Completion<T, Infallible>| {
                drop(cap);
                Ok(())
            },
        )
        .unwrap();
    println!(
        "{name},{},{},{}",
        size_of::<T>(),
        size_of_val(&plan),
        retired(&plan)
    );
}
fn main() {
    println!("value,value_bytes,plan_bytes,transient_close_bytes");
    report::<u64>("u64");
    report::<String>("String");
    report::<[u8; 304]>("Page304");
    report::<[u8; 4096]>("Inline4096");
    #[repr(align(64))]
    struct Aligned {
        _bytes: [u8; 4096],
    }
    report::<Aligned>("Aligned4096");
    println!(
        "detached_inbox_receiver_bytes,{}",
        size_of::<<gpui::Lane<u64, fn(&mut (), u64), ()> as LaneSet<()>>::Retired>()
    );
}
