use shape_api_experiment::{Select, Shape, capabilities as cap};
use std::{hint::black_box, time::Instant};

// Capability marker implementations bind explicit custom registrations to this concrete type.
trait Draggable {
    fn payload(&self) -> &str;
}
struct Card {
    title: String,
    payload: String,
    ordinal: u32,
}
impl Draggable for Card {
    fn payload(&self) -> &str {
        &self.payload
    }
}

#[derive(Shape)]
#[shape(capabilities(cap::Draggable))]
struct CardShape {
    title: String,
    payload: String,
    ordinal: u32,
}
impl shape_api_experiment::traits::Styled for CardShape {}
impl shape_api_experiment::traits::Parent for CardShape {}
impl shape_api_experiment::Implements<cap::Draggable> for CardShape {}

// Generic metadata is available per concrete monomorphization without an instance registry.
#[derive(Shape)]
#[shape(capabilities(cap::ReadOnly))]
struct GenericCard<T: 'static> {
    value: T,
}
impl<T: 'static> shape_api_experiment::Implements<cap::ReadOnly> for GenericCard<T> {}

#[derive(Shape)]
struct ColdType {
    value: u8,
}

fn main() {
    let _card = Card {
        title: "hello".into(),
        payload: "drag me".into(),
        ordinal: 7,
    };
    let both = Select::descendants()
        .with::<cap::Styled>()
        .and::<cap::Draggable>();
    assert!(both.matches::<CardShape>());
    assert!(Select::this().with::<cap::Styled>().matches::<CardShape>());
    assert_eq!(CardShape::shape().fields.len(), 3);
    assert!(shape_api_experiment::linked_shape_for::<CardShape>().is_some());
    assert_ne!(
        GenericCard::<u32>::shape().type_name,
        GenericCard::<String>::shape().type_name
    );
    assert_eq!(CardShape::shape().fields[0].name, "title");
    assert!(
        CardShape::shape()
            .capabilities
            .iter()
            .any(|c| c.name == "Styled")
    );
    assert!(
        CardShape::shape()
            .capabilities
            .iter()
            .any(|c| c.name == "Parent")
    );
    println!(
        "shape={} fields={:?} caps={:?}",
        CardShape::shape().type_name,
        CardShape::shape()
            .fields
            .iter()
            .map(|f| f.name)
            .collect::<Vec<_>>(),
        CardShape::shape()
            .capabilities
            .iter()
            .map(|c| c.name)
            .collect::<Vec<_>>()
    );
    benchmark();
}
fn benchmark() {
    const N: usize = 2_000_000;
    let start = Instant::now();
    let _ = ColdType::shape();
    let cold = start.elapsed();
    let start = Instant::now();
    let mut checksum = 0;
    for _ in 0..N {
        checksum += CardShape::shape().fields.len();
        black_box(
            Select::this()
                .with::<cap::Styled>()
                .and::<cap::Draggable>()
                .matches::<CardShape>(),
        );
    }
    let warm = start.elapsed();
    println!(
        "std::time harness: cold_init={cold:?}; warm lookup+2 predicates={warm:?} for {N} iterations ({:.1} ns/iter), checksum={checksum}",
        warm.as_nanos() as f64 / N as f64
    );
}
