#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<Vec<Option<Box<std::sync::Arc<std::sync::atomic::AtomicU64>>>>>);
const VALUE: Source<Model,Vec<Option<Box<std::sync::Arc<std::sync::atomic::AtomicU64>>>>> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
