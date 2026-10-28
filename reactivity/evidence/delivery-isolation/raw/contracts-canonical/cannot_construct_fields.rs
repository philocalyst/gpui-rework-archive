#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<Signal<String>>);
const VALUE: Source<Model,Signal<String>> = Source { id: FieldId::new(0), name: "value", read: |m| &m.0, write: |m| &mut m.0 };
