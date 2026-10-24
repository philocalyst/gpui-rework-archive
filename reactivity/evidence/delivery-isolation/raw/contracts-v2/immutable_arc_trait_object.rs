#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<std::sync::Arc<dyn std::any::Any + Send + Sync + gpui::SourceValue>>);
const VALUE: Source<Model,std::sync::Arc<dyn std::any::Any + Send + Sync + gpui::SourceValue>> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
