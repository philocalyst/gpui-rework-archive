use gpui_lens_experiment::registry::{RegisteredElement, RegistryCapability, RegistryLens, Schema};
use gpui_lens_experiment::{Capability, ErasedElement, Lens};
use std::{hint::black_box, time::Instant};

trait Counter {
    fn increment(&mut self);
}
struct Cell(u64);
impl Counter for Cell {
    fn increment(&mut self) {
        self.0 = black_box(self.0).wrapping_add(1);
    }
}
struct CounterLens;
struct RegisteredCounter;
impl Lens<Cell> for CounterLens {
    type View<'a> = &'a mut dyn Counter;
    fn project(target: &mut Cell) -> Self::View<'_> {
        target
    }
}
impl RegistryLens<Cell, dyn Counter> for RegisteredCounter {
    fn project<'a>(target: &'a mut Cell) -> &'a mut (dyn Counter + 'static) {
        target
    }
}

fn main() {
    const N: usize = 10_000_000;
    let cap = Capability::<Cell, CounterLens>::new();
    let mut direct_cell = Cell(0);
    let start = Instant::now();
    for _ in 0..N {
        CounterLens::project(black_box(&mut direct_cell)).increment();
    }
    let direct = start.elapsed();
    let mut erased = ErasedElement::new(Cell(0));
    let start = Instant::now();
    for _ in 0..N {
        erased.capability(cap).unwrap().increment();
    }
    let erased_query = start.elapsed();
    black_box(direct_cell.0);
    black_box(erased.downcast_mut::<Cell>().unwrap().0);

    let registered = RegistryCapability::<dyn Counter, RegisteredCounter>::new();
    let mut schema_builder = Schema::<Cell>::builder();
    schema_builder.register(registered);
    let schema = std::sync::Arc::new(schema_builder.build());
    let mut registered_element = RegisteredElement::new(Cell(0), schema);
    let start = Instant::now();
    for _ in 0..N {
        registered_element.get(registered).unwrap().increment();
    }
    let registry_query = start.elapsed();
    black_box(registered_element.get(registered).unwrap());

    println!(
        "direct typed projection: {direct:?}; exact-target erased query: {erased_query:?}; registered trait query: {registry_query:?}"
    );
}
