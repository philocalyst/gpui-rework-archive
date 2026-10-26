//! Copy this fixture unchanged onto c6ac1481d1 to compare the old transport.
use gpui::{Completion, Questions, WindowOptions, prelude::*};
use std::{convert::Infallible, marker::PhantomData};
struct Model<T> {
    value: Signal<u64>,
    marker: PhantomData<fn() -> T>,
}
impl<T: 'static> Model<T> {
    const VALUE: Source<Self, u64> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl<T: 'static> View for Model<T> {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        div()
    }
}
fn storage<T: Send + 'static>(name: &str) {
    let mut plan = None;
    let allocation = allocation_counter::measure(|| {
        plan = Some(
            Questions::new()
                .question(
                    Model::<T>::VALUE,
                    |value| *value,
                    |_: u64, cap: Completion<T, Infallible>| {
                        drop(cap);
                        Ok(())
                    },
                )
                .unwrap()
                .0,
        )
    });
    let plan = plan.unwrap();
    let plan_bytes = size_of_val(&plan);
    let win = Win::recording_questions(
        Model {
            value: Signal::new(1),
            marker: PhantomData,
        },
        plan,
        WindowOptions::default(),
    )
    .unwrap();
    println!(
        "{name},{},{},{},{},{}",
        size_of::<T>(),
        allocation.count_total,
        allocation.bytes_total,
        plan_bytes,
        size_of_val(&win)
    );
}
#[test]
fn requested_storage_matrix() {
    println!("value,value_bytes,allocations,requested_heap,plan_bytes,window_bytes");
    storage::<u64>("u64");
    storage::<String>("String");
    storage::<[u8; 304]>("PageSized304");
    storage::<[u8; 4096]>("Inline4096");
    #[repr(align(64))]
    struct Aligned {
        _bytes: [u8; 4096],
    }
    storage::<Aligned>("Aligned4096");
}
