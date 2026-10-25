//! Production frontend workloads, including generated schemas and native methods.

use super::{Describe, TypedPath, ValueMut};
use criterion::Criterion;
use std::hint::black_box;

#[gpui_macros::reflect]
mod fixture {
    pub struct Details {
        pub value: u64,
    }
    pub struct Counter {
        pub value: u64,
        pub details: Details,
    }

    impl Counter {
        pub fn increment(&mut self) {
            self.value = self.value.wrapping_add(1);
        }
    }

    pub trait Increment {
        fn increment(&mut self);
    }
    impl Increment for Counter {
        fn increment(&mut self) {
            self.increment();
        }
    }
}

use fixture::{Counter, Details, Increment};

fn new_counter() -> Counter {
    Counter {
        value: 0,
        details: Details { value: 0 },
    }
}

fn direct(counter: &mut Counter) {
    black_box(counter).increment();
}

fn field(counter: &mut Counter) {
    let value = Counter::fields().value.get_mut(black_box(counter));
    *value = value.wrapping_add(1);
}

fn typed(counter: &mut Counter) {
    let mut value = ValueMut::new(black_box(counter));
    let value = value.at(Counter::fields().value).unwrap();
    *value = value.wrapping_add(1);
}

fn nested(counter: &mut Counter) {
    let path = Counter::fields().details.then(Details::fields().value);
    let mut value = ValueMut::new(black_box(counter));
    let value = value.at(path).unwrap();
    *value = value.wrapping_add(1);
}

fn named(counter: &mut Counter) {
    let mut value = ValueMut::new(black_box(counter));
    let mut field = value.field("value").unwrap();
    let value = field.downcast_mut::<u64>().unwrap();
    *value = value.wrapping_add(1);
}

fn role(counter: &mut Counter) {
    ValueMut::new(black_box(counter))
        .cast_mut::<dyn Increment>()
        .unwrap()
        .increment();
}

fn method(counter: &mut Counter) {
    Counter::methods().increment.call(black_box(counter));
}

const WORKLOADS: [(&str, fn(&mut Counter)); 7] = [
    ("native", direct),
    ("field", field),
    ("typed", typed),
    ("nested", nested),
    ("named", named),
    ("role", role),
    ("method", method),
];

fn verify() {
    for (name, operation) in WORKLOADS {
        let mut counter = new_counter();
        operation(&mut counter);
        assert_eq!(counter.value + counter.details.value, 1, "{name}");
    }
}

pub(super) fn run(criterion: &mut Criterion) {
    verify();
    let mut group = criterion.benchmark_group("reflection/value");
    for (name, operation) in WORKLOADS {
        let mut counter = new_counter();
        group.bench_function(name, |bencher| {
            bencher.iter(|| operation(black_box(&mut counter)));
        });
    }
    let mut counter = new_counter();
    let mut value = ValueMut::new(&mut counter);
    let role = value.cast_mut::<dyn Increment>().unwrap();
    group.bench_function("prepared_role", |bencher| {
        bencher.iter(|| black_box(&mut *role).increment());
    });
    let mut counter = new_counter();
    let projection = Counter::type_shape().role::<dyn Increment>().unwrap();
    group.bench_function("prepared_projection", |bencher| {
        bencher.iter(|| {
            projection
                .get_mut(black_box(&mut counter))
                .unwrap()
                .increment()
        });
    });
    group.finish();
}

pub(super) fn profile_allocations(profile: &mut impl FnMut(&str, &mut dyn FnMut())) {
    verify();
    for (name, operation) in WORKLOADS {
        let mut counter = new_counter();
        profile(&format!("value/{name}"), &mut || operation(&mut counter));
        assert_eq!(counter.value + counter.details.value, 1, "{name}");
    }
    let projection = Counter::type_shape().role::<dyn Increment>().unwrap();
    let mut counter = new_counter();
    profile("value/prepared_projection", &mut || {
        projection.get_mut(&mut counter).unwrap().increment();
    });
    assert_eq!(counter.value, 1);
}
