#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<Box<dyn std::any::Any>>);
const VALUE: Source<Model, Box<dyn std::any::Any>> = Source::new(FieldId::new(0), "value", |m| &m.0, |m| &mut m.0);
fn main() {}
