#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<std::cell::RefCell<Vec<u64>>>);
const VALUE: Source<Model,std::cell::RefCell<Vec<u64>>> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
