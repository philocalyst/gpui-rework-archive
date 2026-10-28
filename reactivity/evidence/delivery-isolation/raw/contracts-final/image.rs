#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<gpui::Image>);
const VALUE: Source<Model,gpui::Image> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
