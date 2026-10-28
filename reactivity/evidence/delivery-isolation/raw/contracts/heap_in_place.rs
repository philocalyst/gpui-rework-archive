#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model { outer: Signal<Vec<Signal<String>>> }
const OUTER: Source<Model, Vec<Signal<String>>> = Source::new(FieldId::new(1), "outer", |m| &m.outer, |m| &mut m.outer);
