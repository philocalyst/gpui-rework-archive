#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model(Signal<triomphe::Arc<gpui_canvas::TextGeometry>>);
const VALUE: Source<Model,triomphe::Arc<gpui_canvas::TextGeometry>> = Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
