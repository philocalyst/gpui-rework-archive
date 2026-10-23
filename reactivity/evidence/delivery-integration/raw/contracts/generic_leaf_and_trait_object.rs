#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
fn declare<M,T: gpui::SourceValue>(r: fn(&M)->&Signal<T>, w: fn(&mut M)->&mut Signal<T>) -> Source<M,T> { Source::new(FieldId::new(0), "value", r, w) }
struct Model(Signal<Box<dyn std::any::Any + gpui::SourceValue>>);
const VALUE: Source<Model, Box<dyn std::any::Any + gpui::SourceValue>> = Source::new(FieldId::new(0), "value", |m| &m.0, |m| &mut m.0);
const COPY: Source<Model, Box<dyn std::any::Any + gpui::SourceValue>> = VALUE;
fn main() {}
