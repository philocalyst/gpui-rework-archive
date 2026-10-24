#![forbid(unsafe_code)]
#![allow(dead_code, unused_imports)]
use gpui::{FieldId, Signal, Source, Sources};
struct Model { leaf: Signal<String>, nested: Signal<Signal<String>> }
const LEAF: Source<Model,String> = Source::new(FieldId::new(0), "leaf", |m| &m.leaf, |m| &mut m.leaf);
const NESTED: Source<Model,Signal<String>> = LEAF;
