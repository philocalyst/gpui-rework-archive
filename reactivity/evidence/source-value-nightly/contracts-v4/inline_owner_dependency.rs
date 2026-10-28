#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Nested { child: Signal<String> }
struct Model { outer: Signal<Nested> }
const OUTER: Source<Model, Nested> = Source::new(FieldId::new(1), "outer", |m| &m.outer, |m| &mut m.outer);
fn register() -> Sources<Model> { Sources::new().field(OUTER) }
fn main() {}
