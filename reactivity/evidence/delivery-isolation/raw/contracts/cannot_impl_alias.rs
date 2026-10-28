#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Escape(Signal<String>);
impl gpui::SourceValue for Escape {}
