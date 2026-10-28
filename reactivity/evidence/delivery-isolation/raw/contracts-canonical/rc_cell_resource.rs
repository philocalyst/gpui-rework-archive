#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Resource { bytes: Vec<u8>, drops: std::rc::Rc<std::cell::Cell<usize>> }
struct Model(Signal<Resource>);
const VALUE: Source<Model,Resource> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
